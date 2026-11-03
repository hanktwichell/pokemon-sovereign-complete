#include "overlay005/enable_poketch_task.h"

#include <nitro.h>

#include "applications/poketch/poketch_system.h"
#include "applications/poketch/unavailable/graphics.h"
#include "field/field_system.h"
#include "field/field_system_sub2_t.h"
#include "overlay005/ov5_021EA714.h"

#include "brightness_controller.h"
#include "field_task.h"
#include "game_overlay.h"
#include "heap.h"
#include "poketch.h"
#include "render_oam.h"

FS_EXTERN_OVERLAY(poketch_unavailable);
FS_EXTERN_OVERLAY(poketch);

typedef struct EnablePoketchTask {
    int state;
} EnablePoketchTask;

static BOOL FieldTask_EnablePoketch(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    EnablePoketchTask *taskData = FieldTask_GetEnv(task);

    switch (taskData->state) {
    case 0:
        BrightnessController_StartTransition(2, -16, 0, GX_BLEND_PLANEMASK_BG0 | GX_BLEND_PLANEMASK_BG1 | GX_BLEND_PLANEMASK_BG2 | GX_BLEND_PLANEMASK_BG3 | GX_BLEND_PLANEMASK_OBJ | GX_BLEND_PLANEMASK_BD, BRIGHTNESS_SUB_SCREEN);
        taskData->state++;
        break;
    case 1:
        if (BrightnessController_IsTransitionComplete(BRIGHTNESS_SUB_SCREEN)) {
            ov5_021EA790(fieldSystem); // Sovereign Complete: the bottom screen showing ends, the Pokégear's too
            taskData->state++;
        }
        break;
    case 2:
        if (ov5_021EA7CC(fieldSystem)) { // Sovereign Complete: and the new Pokétch shows, by the bottom screen's own start
            Poketch *poketch = SaveData_GetPoketch(fieldSystem->saveData);

            Poketch_Enable(poketch);
            poketch->completePokegearShown = FALSE;
            ov5_021EA728(fieldSystem);
            taskData->state++;
        }
        break;
    case 3:
        BrightnessController_StartTransition(4, 0, -16, GX_BLEND_PLANEMASK_BG0 | GX_BLEND_PLANEMASK_BG1 | GX_BLEND_PLANEMASK_BG2 | GX_BLEND_PLANEMASK_BG3 | GX_BLEND_PLANEMASK_OBJ | GX_BLEND_PLANEMASK_BD, BRIGHTNESS_SUB_SCREEN);
        taskData->state++;
        break;
    case 4:
        if (BrightnessController_IsTransitionComplete(BRIGHTNESS_SUB_SCREEN)) {
            Heap_Free(taskData);
            return TRUE;
        }
        break;
    }

    return FALSE;
}

void FieldSystem_EnablePoketch(FieldTask *task)
{
    EnablePoketchTask *taskState = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(EnablePoketchTask));

    taskState->state = 0;
    FieldTask_InitCall(task, FieldTask_EnablePoketch, taskState);
}
