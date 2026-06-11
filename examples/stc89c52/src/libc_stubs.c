/* Minimal libc stubs for the Zig C backend on 8051 / SDCC.
 * The C backend emits calls to memcpy and memset.  SDCC does not provide
 * these in its default mcs51 libraries, so we supply trivial byte-loop
 * implementations suitable for the small-model memory space. */

void *memcpy(void *dest, const void *src, unsigned int n) {
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

void *memset(void *s, int c, unsigned int n) {
    unsigned char *p = (unsigned char *)s;
    while (n--) {
        *p++ = (unsigned char)c;
    }
    return s;
}
