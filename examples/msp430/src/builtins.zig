//! Bare-metal runtime support for MSP430.
//! Provides memset, memcpy, MSP430 ABI math helpers (__mspabi_divu,
//! __mspabi_mpyi), and an abort trap. These are normally supplied by
//! compiler_rt or libc, which we omit on this freestanding target.

/// Fill `n` bytes of `dest` with `c`.
export fn memset(dest: [*]u8, c: u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        dest[i] = c;
    }
    return dest;
}

/// Copy `n` bytes from `src` to `dest` (non-overlapping).
export fn memcpy(dest: [*]u8, src: [*]const u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        dest[i] = src[i];
    }
    return dest;
}

// MSP430 ABI helper: unsigned 16-bit division.
// Convention: numerator in R12, denominator in R14.
// Returns quotient in R12, remainder in R14.
comptime {
    asm (
        \\.globl __mspabi_divu
        \\__mspabi_divu:
        \\  clr r13
        \\  mov #1, r15
        \\1:
        \\  cmp r12, r14
        \\  jhs 2f
        \\  add r14, r14
        \\  add r15, r15
        \\  jmp 1b
        \\2:
        \\  sub r14, r12
        \\  jhs 3f
        \\  add r14, r12
        \\  jmp 4f
        \\3:
        \\  add r15, r13
        \\4:
        \\  clrc
        \\  rrc r14
        \\  clrc
        \\  rrc r15
        \\  tst r15
        \\  jnz 2b
        \\  mov r12, r14
        \\  mov r13, r12
        \\  ret
    );
}

// MSP430 ABI helper: signed 16-bit multiply.
// Convention: operands in R12 and R14, result in R12.
comptime {
    asm (
        \\.globl __mspabi_mpyi
        \\__mspabi_mpyi:
        \\  clr r15
        \\  tst r12
        \\  jz 2f
        \\1:
        \\  bit #1, r12
        \\  jz 3f
        \\  add r14, r15
        \\3:
        \\  rla r14
        \\  rra r12
        \\  jnz 1b
        \\2:
        \\  mov r15, r12
        \\  ret
    );
}

/// Abort trap -- enter an infinite loop.
export fn abort() noreturn {
    while (true) {}
}
