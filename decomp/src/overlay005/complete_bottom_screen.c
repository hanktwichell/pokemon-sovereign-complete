#include <nitro.h>

#include "field/field_system.h"
#include "overlay005/ov5_021EA714.h"

#include "brightness_controller.h"
#include "complete_pokegear.h"
#include "field_task.h"
#include "heap.h"

// Sovereign Complete: the field's bottom screen switches between the Pokétch and the Pokégear as the field runs
// (include/complete_pokegear.h): the one showing fades out and ends, and the other starts and fades in, as Platinum's
// task does for the Pokétch the player gets in Jubilife (src/overlay005/enable_poketch_task.c)

#define FIELD_BOTTOM_SCREEN_POKETCH 1 // FieldSystem's bottomScreen: the Pokétch's, of the map's load mode

typedef struct SwitchBottomScreenTask {
    int state;
} SwitchBottomScreenTask;

static BOOL FieldTask_SwitchBottomScreen(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    SwitchBottomScreenTask *taskData = FieldTask_GetEnv(task);

    switch (taskData->state) {
    case 0:
        BrightnessController_StartTransition(2, -16, 0, GX_BLEND_PLANEMASK_BG0 | GX_BLEND_PLANEMASK_BG1 | GX_BLEND_PLANEMASK_BG2 | GX_BLEND_PLANEMASK_BG3 | GX_BLEND_PLANEMASK_OBJ | GX_BLEND_PLANEMASK_BD, BRIGHTNESS_SUB_SCREEN);
        taskData->state++;
        break;
    case 1:
        if (BrightnessController_IsTransitionComplete(BRIGHTNESS_SUB_SCREEN)) {
            ov5_021EA790(fieldSystem);
            taskData->state++;
        }
        break;
    case 2:
        if (ov5_021EA7CC(fieldSystem)) {
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

// As the field takes the player's input (src/overlay005/field_control.c): when the other screen is due, the switch
BOOL CompleteBottomScreen_TrySwitch(FieldSystem *fieldSystem)
{
    if (fieldSystem->bottomScreen != FIELD_BOTTOM_SCREEN_POKETCH || !CompleteBottomScreen_SwitchDue(fieldSystem->saveData)) {
        return FALSE;
    }

    SwitchBottomScreenTask *taskData = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(SwitchBottomScreenTask));

    taskData->state = 0;
    FieldSystem_CreateTask(fieldSystem, FieldTask_SwitchBottomScreen, taskData);
    return TRUE;
}
