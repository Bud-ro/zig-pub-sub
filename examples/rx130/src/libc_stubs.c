/* Minimal memcpy/memset implementations for the RX130 bare-metal build.
   The C backend emits calls to these; provide simple byte-loop versions
   so we don't need to pull in a full libc. */

void *memcpy(void *dest, const void *src, unsigned int n) {
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;
    while (n--) *d++ = *s++;
    return dest;
}

void *memset(void *s, int c, unsigned int n) {
    unsigned char *p = (unsigned char *)s;
    while (n--) *p++ = (unsigned char)c;
    return s;
}

void abort(void) {
    for (;;) {}
}
