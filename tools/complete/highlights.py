#!/usr/bin/env python3
"""Cut a short highlight video (1 to 2 minutes) from the story test's recording (tools/complete/test_hgss_opening.py
with VIDEO: an MPEG-TS file of both screens and VIDEO.events, the recording's frame number at each part's and action's
start and at each part's end).

Each highlight is a story moment, found by its part's name in the events: a clip of a few seconds from the part's last
action (the talk that starts a leader's battle, a scene's trigger), its start or its end, with a caption over it. The
clips show the top screen scaled up three times (pixels kept sharp), captioned and joined with short fades into one MP4. Moments whose part
isn't in the recording (a run stopped before it) are left out; a recording in several files (a run resumed with FROM)
is read in order, its events' frames counted per file.

Usage: python3 tools/complete/highlights.py OUT.mp4 VIDEO [VIDEO ...]
"""
import os
import re
import subprocess
import sys
import tempfile

FPS = 20  # the recording's frame rate (VIDEO_EVERY 3: 60 / 3)
FONT = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
FADE = 0.4  # seconds of each crossfade

# (part, where in it: 'start', 'end' or 'last' (its last action), seconds from there, seconds long, caption)
MOMENTS = [
    ('downstairs', 'start', 0, 5, 'A new game in New Bark Town'),
    ('the starter', 'last', 0, 6, 'Elm\'s starter, on Platinum\'s screen'),
    ('Totem Gumshoos', 'last', 0, 6, 'A Totem trial in Johto'),
    ('Whitney', 'last', 0, 6, 'Whitney, and the Mega Ring'),
    ('Morty', 'last', 0, 7, 'Morty\'s Mega Gengar'),
    ('Pryce', 'last', 0, 6, 'Pryce\'s ice gym'),
    ('Lance', 'last', 0, 7, 'Lance\'s Mega Dragonite'),
    ('the S.S. Aqua', 'end', -6, 6, 'The S.S. Aqua to Kanto'),
    ('Misty', 'last', 0, 6, 'Misty in Cerulean'),
    ('Totem Marowak', 'last', 0, 6, 'Totem Marowak in Rock Tunnel'),
    ('Blue', 'last', 0, 6, 'Blue, Kanto\'s eighth badge'),
    ('Twinleaf Town', 'last', 0, 8, 'The first ship to Sinnoh'),
    ('the briefcase', 'last', 0, 8, 'Rowan\'s briefcase'),
    ('Roark', 'last', 0, 6, 'Roark, Sinnoh\'s first gym'),
    ('the Valley Windworks', 'last', 0, 6, 'Team Galactic at the Valley Windworks'),
    ('Gardenia', 'last', 0, 6, 'Gardenia in Eterna'),
    ('Totem Lurantis', 'last', 0, 6, 'Totem Lurantis in the Great Marsh'),
    ('Spear Pillar', 'last', 0, 7, 'Spear Pillar'),
    ('Cynthia', 'last', 1, 7, 'Cynthia, Sinnoh\'s Champion'),  # her part runs on through the Hall of Fame and the
    ('Cynthia', 'end', -5, 5, 'The game cleared: home in Twinleaf'),  # reset, to Continue in Twinleaf
]


def events(path):
    """[(frame, kind, text)] from VIDEO.events."""
    out = []
    for line in open(path + '.events', encoding='utf-8'):
        frame, what = line.rstrip('\n').split(' ', 1)
        kind, _, text = what.partition(' ')
        out.append((int(frame), kind, text))
    return out


def find(videos, part):
    """(video, {'start': frame, 'end': frame, 'last': frame}) for the part, or None. The last run that has it wins."""
    found = None
    for video in videos:
        marks = events(video)
        for i, (frame, kind, text) in enumerate(marks):
            if kind == 'part' and text == part:
                where = {'start': frame}
                for frame2, kind2, text2 in marks[i + 1:]:
                    if kind2 == 'action':
                        where['last'] = frame2
                    elif kind2 == 'end':
                        where['end'] = frame2
                        break
                    elif kind2 == 'part':
                        break
                where.setdefault('last', where['start'])
                where.setdefault('end', where['last'])
                found = (video, where)
    return found


def duration(video):
    return float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', video],
                                capture_output=True, text=True).stdout.strip() or 0)


def main():
    out, videos = sys.argv[1], sys.argv[2:]
    tmp = tempfile.mkdtemp(prefix='highlights-')
    clips = []
    for part, anchor, offset, length, caption in MOMENTS:
        hit = find(videos, part)
        if not hit:
            print(f'{part}: not in the recording')
            continue
        video, where = hit
        start = max(0.0, where[anchor] / FPS + offset)
        start = min(start, max(0.0, duration(video) - length))
        clip = os.path.join(tmp, f'{len(clips):02d}.mp4')
        text = caption.replace('\\', '\\\\').replace("'", '’').replace(':', '\\:')
        vf = ('crop=256:192:0:0,scale=768:576:flags=neighbor,'  # the top screen, where the story is
              f"drawbox=x=0:y=0:w=768:h=52:color=black@0.6:t=fill,"
              f"drawtext=fontfile={FONT}:text='{text}':x=(w-text_w)/2:y=13:fontsize=28:fontcolor=white")
        # a coarse seek before the input (to a keyframe well before), then an exact one after it: a seek straight to
        # the start can land between the recording's keyframes and give no frames
        coarse = max(0.0, start - 30)
        subprocess.run(['ffmpeg', '-loglevel', 'error', '-y'] + (['-ss', f'{coarse:.2f}'] if coarse else []) +
                       ['-i', video, '-ss', f'{start - coarse:.2f}', '-t', str(length),
                        '-vf', vf, '-r', str(FPS), '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '20',
                        '-pix_fmt', 'yuv420p', '-an', clip], check=True)
        clips.append((clip, length))
        print(f'{part}: {start:.1f}s of {os.path.basename(video)}, {length}s')
    if not clips:
        sys.exit('no moments found')
    # one crossfade between each two clips
    inputs, chain, at = [], '', 0.0
    for i, (clip, length) in enumerate(clips):
        inputs += ['-i', clip]
    label = '[0:v]'
    for i in range(1, len(clips)):
        at += clips[i - 1][1] - FADE
        chain += f'{label}[{i}:v]xfade=transition=fade:duration={FADE}:offset={at:.2f}[v{i}];'
        label = f'[v{i}]'
    cmd = ['ffmpeg', '-loglevel', 'error', '-y'] + inputs
    if chain:
        cmd += ['-filter_complex', chain.rstrip(';'), '-map', label]
    cmd += ['-c:v', 'libx264', '-preset', 'medium', '-crf', '20', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', out]
    subprocess.run(cmd, check=True)
    print(f'{out}: {len(clips)} moments, {duration(out):.0f} seconds')


if __name__ == '__main__':
    main()
