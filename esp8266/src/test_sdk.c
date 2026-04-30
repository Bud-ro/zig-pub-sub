#include "ets_sys.h"

unsigned int user_rf_cal_sector_set(void) {
    return 0x3FB;
}

void user_init(void) {
    volatile unsigned int *fifo = (volatile unsigned int *)0x60000000;
    volatile unsigned int *status = (volatile unsigned int *)0x60000004;
    const char *msg = "HELLO_FROM_USER_INIT\r\n";
    while (*msg) {
        while (((*status) >> 16 & 0xFF) >= 126) {}
        *fifo = *msg++;
    }
}
