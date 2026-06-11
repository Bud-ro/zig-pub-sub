/* Minimal zig.h shim for SDCC (hc08).
 *
 * The Zig C backend emits `#include "zig.h"` at the top of every generated
 * file.  The real zig.h is ~2000 lines of GCC/Clang intrinsics, atomics, and
 * __attribute__ annotations that SDCC cannot parse.  This header provides
 * stub definitions for every zig_* identifier the generated firmware.c
 * actually references, making the output compilable by SDCC. */

#ifndef ZIG_SDCC_SHIM_H
#define ZIG_SDCC_SHIM_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>

/* --- Attributes SDCC does not support --- */

#define zig_extern extern
#define zig_cold
#define zig_noreturn
#define zig_nonstring

/* --- Static assertions --- */
/* SDCC lacks _Static_assert / _Alignof; just discard them. */

#define zig_static_assert(cond, msg)

/* --- Trap / unreachable --- */

#define zig_trap() do { while (1); } while (0)
#define zig_unreachable() do { while (1); } while (0)

/* --- Wrapping arithmetic --- */
/* The Zig C backend emits zig_addw_u32(a, b, 32) etc. for wrapping add/sub.
 * The third argument is the bit width (unused here -- the C type already
 * provides the wrapping). */

#define zig_addw_u32(a, b, bits) ((uint32_t)((uint32_t)(a) + (uint32_t)(b)))
#define zig_subw_u32(a, b, bits) ((uint32_t)((uint32_t)(a) - (uint32_t)(b)))
#define zig_shlw_u8(a, b, bits)  ((uint8_t)((uint8_t)(a) << (b)))
#define zig_not_u8(a, bits)      ((uint8_t)(~(uint8_t)(a)))
#define zig_wrap_u8(a, bits)     ((uint8_t)(a))

/* --- Atomics (HCS08 is single-core, no atomics needed) --- */

#define zig_atomic(T) T
#define zig_memory_order_relaxed 0
#define zig_atomic_load(dst, ptr, order, tag, T) do { (dst) = *(ptr); } while (0)

#endif /* ZIG_SDCC_SHIM_H */
