//! Compiler-rt atomic stubs for Cortex-M0+.
//! The M0+ lacks LDREX/STREX, but aligned 32-bit loads and stores are
//! naturally atomic (single bus transaction), so the implementation is
//! just a plain volatile load/store with interrupts disabled for safety.

/// Provides __atomic_load_4 for @atomicLoad(u32, ...) on Cortex-M0+.
/// Disables interrupts around the read to prevent tearing from ISR writes.
export fn __atomic_load_4(src: *const u32, _: c_int) u32 { // zlinter-disable-current-line function_naming
    // Disable interrupts
    const primask = asm volatile ("mrs %[ret], primask"
        : [ret] "=r" (-> u32),
    );
    asm volatile ("cpsid i");

    const val = src.*;

    // Restore previous interrupt state
    asm volatile ("msr primask, %[primask]"
        :
        : [primask] "r" (primask),
    );

    return val;
}
