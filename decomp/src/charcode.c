#include "constants/charcode.h"

#include "charcode.h"

#define FORMAT_ARG_TYPE_MASK 0xFF00

charcode_t *CharCode_SkipFormatArg(const charcode_t *cstr)
{
    GF_ASSERT(*cstr == CHAR_FORMAT_ARG);

    if (*cstr == CHAR_FORMAT_ARG) {
        cstr += 2;
        u32 skip = *cstr++;
        cstr += skip;
    }

    return cstr;
}

u32 CharCode_FormatArgType(const charcode_t *cstr)
{
    GF_ASSERT(*cstr == CHAR_FORMAT_ARG);
    return *(cstr + 1);
}

BOOL CharCode_IsFormatArg(const charcode_t *cstr)
{
    u32 type = CharCode_FormatArgType(cstr);

    // Sovereign Complete: HeartGold's string variables too, its STRVAR_3, STRVAR_4 and STRVAR_34 (its
    // MsgArray_ControlCodeIsStrVar), which its imported text uses (the Pokéathlon's course names, Buena's password)
    if ((type & FORMAT_ARG_TYPE_MASK) == 0x100
        || (type & FORMAT_ARG_TYPE_MASK) == 0x600
        || (type & FORMAT_ARG_TYPE_MASK) == 0x500
        || (type & FORMAT_ARG_TYPE_MASK) == 0x300
        || (type & FORMAT_ARG_TYPE_MASK) == 0x400
        || (type & FORMAT_ARG_TYPE_MASK) == 0x3400) {
        return TRUE;
    }

    return FALSE;
}

u32 CharCode_FormatArgParam(const charcode_t *cstr, u32 paramIdx)
{
    GF_ASSERT(*cstr == CHAR_FORMAT_ARG);

    cstr += 2;
    u32 skip = *cstr++;

    GF_ASSERT(paramIdx < skip);

    return cstr[paramIdx];
}
