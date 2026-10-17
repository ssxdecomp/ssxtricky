#include "common.h"

INCLUDE_ASM("bx/core/logprint", bxLogPrint__FPce);
#ifdef SKIP_ASM
void bxLogPrint(char* arg0,...) {
    return;
}
#endif