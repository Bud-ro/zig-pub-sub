/* Minimal libc stubs for the HCS08 C backend build.
   The Zig C backend output references memcpy/memset; we provide
   trivial byte-loop implementations since there is no libc on
   bare-metal HCS08. */

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
