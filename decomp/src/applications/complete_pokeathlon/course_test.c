#include <nitro.h>

#include "complete_pokeathlon_course.h"
#include "complete_pokeathlon_select.h"
#include "complete_test.h"
#include "heap.h"

// Sovereign Complete: the test build's note of how far HeartGold's Pokéathlon course got
// (gCompleteTestPokeathlonCourse, include/complete_test.h), from the course's own frame (course.c): its state, its
// event, the heap's low point. It lives in the course's overlay, so it costs the main module nothing.
#ifdef SOVEREIGN_TEST

u8 CompletePokeathlonCourse_TestStateIndex(void *courseData);
u32 CompletePokeathlonCourse_TestEventIndex(void *courseData);
u32 CompletePokeathlonCourse_TestEvent(void *courseData);

void CompletePokeathlonCourse_TestNote(void *courseData)
{
    CompleteTestPokeathlonCourse *test = &gCompleteTestPokeathlonCourse;
    u32 free = HeapExp_FndGetTotalFreeSize(HGSS_HEAP_ID_POKEATHLON);

    if (free < test->heapFree) {
        test->heapFree = free;
    }

    if (courseData == NULL) { // the course's exit
        return;
    }

    u8 state = CompletePokeathlonCourse_TestStateIndex(courseData);

    if (state > test->lastState || test->frames == 0) {
        test->lastState = state;
    }

    test->state = state;
    test->eventIndex = CompletePokeathlonCourse_TestEventIndex(courseData);
    test->event = CompletePokeathlonCourse_TestEvent(courseData);
    test->frames++;
}

void CompletePokeathlonCourse_TestExit(void)
{
    gCompleteTestPokeathlonCourse.heapLeft = HeapExp_FndGetTotalFreeSize(HGSS_HEAP_ID_POKEATHLON);
}

#endif
