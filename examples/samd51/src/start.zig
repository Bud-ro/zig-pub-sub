//! ARM Cortex-M4 startup code for ATSAMD51J19A.
//! Provides the vector table and Reset_Handler that copies .data from flash
//! to RAM, zeros .bss, and calls main.
//!
//! On Cortex-M, the hardware loads the initial stack pointer from
//! vector_table[0] and branches to the reset vector at vector_table[1],
//! so Reset_Handler runs with a valid stack from the first instruction.

const app = @import("main.zig");

extern var _data_start: u32;
extern var _data_end: u32;
extern const _data_loadaddr: u32;
extern var _bss_start: u32;
extern var _bss_end: u32;
extern const _stack_top: u32;

/// Reset handler: copy .data from flash to RAM, zero .bss, then call main.
export fn Reset_Handler() noreturn { // zlinter-disable-current-line function_naming
    // Copy .data section from flash to RAM
    const data_start: [*]u32 = @ptrCast(&_data_start);
    const data_end: [*]u32 = @ptrCast(&_data_end);
    const data_load: [*]const u32 = @ptrCast(&_data_loadaddr);
    const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
    const data_words = data_len >> 2;
    for (0..data_words) |i| {
        data_start[i] = data_load[i];
    }

    // Zero .bss section
    const bss_start: [*]u32 = @ptrCast(&_bss_start);
    const bss_end: [*]u32 = @ptrCast(&_bss_end);
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);
    const bss_words = bss_len >> 2;
    for (0..bss_words) |i| {
        bss_start[i] = 0;
    }

    app.main();
}

/// Default handler for unhandled interrupts -- infinite loop.
fn defaultHandler() noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}

/// Vector table entry: either a handler function pointer or a raw address
/// (for the initial stack pointer). Using an opaque pointer type so the
/// linker can resolve addresses at link time without Zig requiring
/// comptime-known values.
const VectorEntry = ?*const anyopaque;

/// ARM Cortex-M4 vector table. Placed in .vector_table section so the
/// linker script puts it at the start of flash (address 0x00000000).
export const _vector_table linksection(".vector_table") = [_]VectorEntry{
    @ptrCast(&_stack_top), // Initial stack pointer
    @ptrCast(&Reset_Handler), // Reset
    @ptrCast(&defaultHandler), // NMI
    @ptrCast(&defaultHandler), // HardFault
    @ptrCast(&defaultHandler), // MemManage
    @ptrCast(&defaultHandler), // BusFault
    @ptrCast(&defaultHandler), // UsageFault
    null, // Reserved
    null, // Reserved
    null, // Reserved
    null, // Reserved
    @ptrCast(&defaultHandler), // SVCall
    @ptrCast(&defaultHandler), // DebugMon
    null, // Reserved
    @ptrCast(&defaultHandler), // PendSV
    @ptrCast(&app.SysTick_Handler), // SysTick
};
