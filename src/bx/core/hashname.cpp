#include "common.h"

INCLUDE_ASM("bx/core/hashname", bxPjwHash__FPUiPc);
u32 bxPjwHash(u32* arg0, char* arg1);

INCLUDE_ASM("bx/core/hashname", bxStringHash);
u32 bxStringHash(char* arg0) {
    u32 result;
    u32 hResult;
    result = bxPjwHash(&hResult, arg0);
    return result;
}