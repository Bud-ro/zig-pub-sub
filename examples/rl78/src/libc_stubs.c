/* Minimal libc stubs for the RL78 C backend build.
   The Zig C backend emits calls to memcpy/memset; provide tiny
   implementations so we don't need to pull in a full libc. */

void *memcpy(void *dest, const void *src, unsigned int n) {
    unsigned char *d = dest;
    const unsigned char *s = src;
    while (n--) *d++ = *s++;
    return dest;
}

void *memset(void *s, int c, unsigned int n) {
    unsigned char *p = s;
    while (n--) *p++ = (unsigned char)c;
    return s;
}

/* 32-bit atomic load stub for 16-bit RL78: disable interrupts around
   the read so an ISR can't update the value mid-load. */
unsigned long __atomic_load_4(const volatile void *ptr, int memorder) {
    (void)memorder;
    unsigned char ie = *(volatile unsigned char *)0xFFFFE;
    *(volatile unsigned char *)0xFFFFE = 0; /* DI */
    unsigned long val = *(const volatile unsigned long *)ptr;
    *(volatile unsigned char *)0xFFFFE = ie; /* restore IE */
    return val;
}

void abort(void) {
    for (;;) {}
}
