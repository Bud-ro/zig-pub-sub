/* ROM provides ets_memcpy/ets_memset — alias them as standard libc symbols
   so the C backend output links without pulling in a full libc. */

extern void *ets_memcpy(void *dest, const void *src, unsigned int n);
extern void *ets_memset(void *s, int c, unsigned int n);

void *memcpy(void *dest, const void *src, unsigned int n) {
    return ets_memcpy(dest, src, n);
}

void *memset(void *s, int c, unsigned int n) {
    return ets_memset(s, c, n);
}
