#!/usr/bin/env python3
"""Cut a battle recorded by record_battle.py down to a short preview: the way in (the last INTRO seconds before the
battle starts: the walk up, the trainer's lines, the VS screen), the first turn whole (the Mega Evolution, then the
move), TURN seconds of each later turn (the moves and what they do) up to turn FOCUS, REST seconds of each one after (the
rest of the team's turns, when the preview is about the lead), and the end (from END seconds before the battle
is over to a few seconds after). The cut points are the marks record_battle.py leaves in OUT.mp4.ts.events (frame
numbers of the recording, at 20 a second).

Usage: python3 tools/complete/cut_battle.py BATTLE.mp4 PREVIEW.mp4 [--intro S] [--turn S] [--focus N] [--rest S]
       [--end S]
"""
import subprocess
import sys

FPS = 20  # record_battle.py's Recorder keeps every third frame of the game's 60


def main():
    args = sys.argv[1:]
    option = lambda name, default: float(args[args.index(name) + 1]) if name in args else default  # noqa: E731
    src, out = args[:2]
    intro, turn, end = option('--intro', 22), option('--turn', 14), option('--end', 12)
    focus, rest = int(option('--focus', 1000)), option('--rest', 14)
    marks = []
    for line in open(src + '.ts.events', encoding='utf-8'):
        frame, _, what = line.rstrip('\n').partition(' ')
        marks.append((int(frame) / FPS, what))
    start = next(t for t, what in marks if what == 'the battle starts')
    over = next((t for t, what in marks if what == 'the battle is over'), None)
    turns = [t for t, what in marks if what.startswith('turn ')]
    length = float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0',
                                   src], capture_output=True, text=True, check=True).stdout)
    over = over if over is not None else length - 6
    clips = [(max(0, start - intro), turns[1] if len(turns) > 1 else over)]  # the way in and the first turn whole
    for i, t in enumerate(turns[1:], 1):
        nxt = turns[i + 1] if i + 1 < len(turns) else over
        a = t if i < focus else min(t + 2, nxt)  # a quick turn from its move's animation, past the menu
        clips.append((a, min(a + (turn if i < focus else rest), nxt)))
    clips.append((max(clips[-1][1], over - end), min(length, over + 6)))
    merged = []
    for a, b in clips:  # clips that meet are one
        if merged and a <= merged[-1][1] + 0.5:
            merged[-1] = (merged[-1][0], max(merged[-1][1], b))
        elif b > a:
            merged.append((a, b))
    parts = ''.join(f'[0:v]trim={a:.2f}:{b:.2f},setpts=PTS-STARTPTS[v{i}];' for i, (a, b) in enumerate(merged))
    graph = parts + ''.join(f'[v{i}]' for i in range(len(merged))) + f'concat=n={len(merged)}:v=1:a=0[out]'
    subprocess.run(['ffmpeg', '-loglevel', 'error', '-y', '-i', src, '-filter_complex', graph, '-map', '[out]',
                    '-c:v', 'libx264', '-crf', '20', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', out], check=True)
    total = sum(b - a for a, b in merged)
    print(f'{len(merged)} clips, {total:.0f} s of {length:.0f}: {out}')
    for a, b in merged:
        print(f'  {a:7.1f} - {b:7.1f}')


if __name__ == '__main__':
    main()
