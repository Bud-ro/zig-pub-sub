//! MSP430G2553 startup code.
//! Provides the reset vector entry point, .bss zeroing, .data initialization,
//! and the interrupt vector table placed at 0xFFE0-0xFFFF.

const main = @import("main.zig");

// Linker-defined symbols for memory initialization
extern var _sbss: u16;
extern var _ebss: u16;
extern var _sdata: u16;
extern var _edata: u16;
extern const _sidata: u16;
extern const _stack_top: u16;

fn bssSlice() [*]volatile u16 {
    return @as([*]volatile u16, @ptrCast(&_sbss));
}

fn bssLen() u16 {
    return (@intFromPtr(&_ebss) - @intFromPtr(&_sbss)) / 2;
}

fn dataSlice() [*]volatile u16 {
    return @as([*]volatile u16, @ptrCast(&_sdata));
}

fn roDataSlice() [*]const u16 {
    return @as([*]const u16, @ptrCast(&_sidata));
}

fn dataLen() u16 {
    return (@intFromPtr(&_edata) - @intFromPtr(&_sdata)) / 2;
}

/// Reset vector entry point. Disables the watchdog, sets up the stack pointer,
/// then calls initMemory which zeros .bss, copies .data, and jumps to main.
export fn _start() callconv(.naked) noreturn { // zlinter-disable-current-line function_naming
    // Disable watchdog: write password (0x5A00) | WDTHOLD (bit 7) = 0x5A80
    // MSP430 stores the stack pointer in R1; set it to top of RAM.
    asm volatile (
        \\mov #0x5A80, &0x0120
        \\mov %[stack_top], r1
        :
        : [stack_top] "i" (@intFromPtr(&_stack_top)),
    );

    // Branch to initMemory for .bss/.data init and main.
    // Cannot use @call in naked functions, so use inline asm.
    asm volatile ("br %[init]"
        :
        : [init] "i" (&initMemory),
    );
}

/// Initialize .bss and .data sections, then enter the application.
/// Separated from _start because naked functions cannot use local variables.
fn initMemory() noreturn {
    // Zero .bss
    const bss = bssSlice();
    var i: u16 = 0;
    while (i < bssLen()) : (i += 1) {
        bss[i] = 0;
    }

    // Copy .data from flash (LMA) to RAM (VMA)
    const data = dataSlice();
    const src = roDataSlice();
    var j: u16 = 0;
    while (j < dataLen()) : (j += 1) {
        data[j] = src[j];
    }

    main.main();
}

/// Default handler for unused interrupts -- infinite loop.
fn unhandledIsr() callconv(.naked) noreturn {
    while (true) {}
}

// MSP430G2553 has 16 interrupt vectors at 0xFFE0-0xFFFF (16-bit each).
// Vector 15 (0xFFFE) is the reset vector.
const ISR = *const fn () callconv(.naked) noreturn;
const unhandled: ISR = &unhandledIsr;

/// Interrupt vector table, placed at 0xFFE0 by the linker script.
pub export const vectors linksection(".vectors") = [16]ISR{
    unhandled, // 0xFFE0: unused
    unhandled, // 0xFFE2: unused
    unhandled, // 0xFFE4: Port 1
    unhandled, // 0xFFE6: Port 2
    unhandled, // 0xFFE8: unused
    unhandled, // 0xFFEA: ADC10
    unhandled, // 0xFFEC: USCI TX/RX
    unhandled, // 0xFFEE: USCI status
    unhandled, // 0xFFF0: Timer0_A CC1-2, TA0
    unhandled, // 0xFFF2: Timer0_A CC0
    unhandled, // 0xFFF4: Watchdog
    unhandled, // 0xFFF6: Comparator_A+
    unhandled, // 0xFFF8: Timer1_A CC1-2, TA1
    unhandled, // 0xFFFA: Timer1_A CC0
    unhandled, // 0xFFFC: NMI, osc fault, flash violation
    &_start, //   0xFFFE: Reset
};
