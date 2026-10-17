#include "common.h"

INCLUDE_ASM("bx/core/hashname", bxPjwHash__FPUiPc);
#ifdef SKIP_ASM
u32 bxPjwHash(u32* out, char* str)
{
	u32 h = 0;
    u32 g;

    while (*str) {
        h = (h << 4) + *str++;
        if ((g = h & 0xF0000000) != 0) {
            h = h ^ (g >> 23) ^ g;
        }
    }
    *out = h;
    return h;
}
#endif

INCLUDE_ASM("bx/core/hashname", bxStringHash__FPc);
#ifdef SKIP_ASM
u32 bxStringHash(char* arg0) {
    u32 result;
    u32 hResult;
    result = bxPjwHash(&hResult, arg0);
    return result;
}
#endif