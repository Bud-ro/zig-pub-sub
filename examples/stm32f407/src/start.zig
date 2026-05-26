//! ARM Cortex-M4 startup code for the STM32F407.
//! Provides the vector table (initial SP + exception/interrupt handlers) and
//! the Reset_Handler that copies .data from flash to SRAM, zeros .bss, then
//! calls main.
//!
//! On Cortex-M, exception handlers use the standard C ABI (the hardware
//! performs context save/restore via the stacked frame), so handlers are
//! ordinary functions rather than ARM-style interrupt routines.

const main_mod = @import("main.zig");

/// Linker-provided symbols for .data and .bss initialization.
extern var _sdata: u32;
extern var _edata: u32;
extern const _sidata: u32;
extern var _sbss: u32;
extern var _ebss: u32;

/// Top of SRAM: 0x20000000 + 128K. The Cortex-M hardware reads this as the
/// initial stack pointer from the first word of the vector table on reset.
const stack_top: u32 = 0x20020000;

fn ptrToInt(p: *const u32) u32 {
    return @intFromPtr(p);
}

/// Reset handler: copy .data from flash, zero .bss, call main.
export fn Reset_Handler() callconv(.c) noreturn { // zlinter-disable-current-line function_naming
    // Copy .data section from flash (LMA) to SRAM (VMA).
    const data_len = (ptrToInt(&_edata) - ptrToInt(&_sdata)) / 4;
    const data_dst: [*]volatile u32 = @ptrCast(&_sdata);
    const data_src: [*]const u32 = @ptrCast(&_sidata);
    for (0..data_len) |i| {
        data_dst[i] = data_src[i];
    }

    // Zero .bss section.
    const bss_len = (ptrToInt(&_ebss) - ptrToInt(&_sbss)) / 4;
    const bss_ptr: [*]volatile u32 = @ptrCast(&_sbss);
    for (0..bss_len) |i| {
        bss_ptr[i] = 0;
    }

    main_mod.main();

    while (true) {
        asm volatile ("wfi");
    }
}

/// Default handler for unexpected exceptions/interrupts -- spin forever.
export fn Default_Handler() callconv(.c) void { // zlinter-disable-current-line function_naming
    while (true) {
        asm volatile ("nop");
    }
}

const HandlerFn = *const fn () callconv(.c) void;

/// Union allowing both function pointers and raw u32 values in the vector table.
const VectorEntry = extern union {
    handler: HandlerFn,
    value: u32,
};

/// Number of entries in the Cortex-M4 core vector table (SP + 15 exceptions).
const vector_count = 16;

/// Cortex-M vector table, placed in .isr_vector by the linker script.
/// Entry 0 is the initial stack pointer (top of 128K SRAM),
/// entries 1-15 are exception handlers.
export const vector_table: [vector_count]VectorEntry linksection(".isr_vector") = .{
    // 0: Initial stack pointer (top of SRAM)
    .{ .value = stack_top },
    // 1: Reset
    .{ .handler = Reset_Handler },
    // 2: NMI
    .{ .handler = Default_Handler },
    // 3: HardFault
    .{ .handler = Default_Handler },
    // 4: MemManage
    .{ .handler = Default_Handler },
    // 5: BusFault
    .{ .handler = Default_Handler },
    // 6: UsageFault
    .{ .handler = Default_Handler },
    // 7-10: Reserved
    .{ .value = 0 },
    .{ .value = 0 },
    .{ .value = 0 },
    .{ .value = 0 },
    // 11: SVCall
    .{ .handler = Default_Handler },
    // 12: Debug Monitor
    .{ .handler = Default_Handler },
    // 13: Reserved
    .{ .value = 0 },
    // 14: PendSV
    .{ .handler = Default_Handler },
    // 15: SysTick
    .{ .handler = Default_Handler },
};
