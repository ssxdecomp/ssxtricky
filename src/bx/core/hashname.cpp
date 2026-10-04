#include "common.h"

INCLUDE_ASM("bx/core/hashname", bxPjwHash__FPUiPc);
#ifdef SKIP_ASM
u32 bxPjwHash(u32* arg0, char* arg1)
{
	return 0;
}
#endif

INCLUDE_ASM("bx/core/hashname", bxStringHash);
#ifdef SKIP_ASM
u32 bxStringHash(char* arg0) {
    u32 result;
    u32 hResult;
    result = bxPjwHash(&hResult, arg0);
    return result;
}
#endif