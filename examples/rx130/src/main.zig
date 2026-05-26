//! RX130 firmware entry point.
//! Provides the bare-metal `_start` reset handler: sets up the stack pointer,
//! zeroes .bss, copies .data from flash to RAM, then enters the application
//! super-loop.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Bare-metal reset handler. Called directly from the fixed vector table.
/// Sets up the C runtime environment (stack, .bss, .data) and enters the
/// application super-loop. Exported with linker-visible name `_start`.
export fn _start() callconv(.naked) noreturn { // zlinter-disable-current-line function_naming
    // Set up stack pointer, zero .bss, copy .data, then call main.
    // RX assembly uses `#` for immediate values and `_symbol` for linker symbols.
    asm volatile (
        \\  mvtc #_stack_top, isp
        \\  mvtc #_stack_top, usp
        \\
        \\  /* Zero .bss */
        \\  mov #_bss_start, r1
        \\  mov #_bss_end, r2
        \\  mov #0, r3
        \\bss_loop:
        \\  cmp r1, r2
        \\  beq bss_done
        \\  mov.b r3, [r1]
        \\  add #1, r1
        \\  bra bss_loop
        \\bss_done:
        \\
        \\  /* Copy .data from flash to RAM */
        \\  mov #_data_load, r1
        \\  mov #_data_start, r2
        \\  mov #_data_end, r3
        \\data_loop:
        \\  cmp r2, r3
        \\  beq data_done
        \\  mov.b [r1], r4
        \\  mov.b r4, [r2]
        \\  add #1, r1
        \\  add #1, r2
        \\  bra data_loop
        \\data_done:
        \\
        \\  bsr __main
        \\halt_loop:
        \\  wait
        \\  bra halt_loop
    );
}

/// Main function called after C runtime init. Initializes hardware,
/// prints a boot banner, then enters the run-to-completion super-loop.
export fn _main() void { // zlinter-disable-current-line function_naming
    hardware.init();
    uart.puts("RX130 boot\r\n");

    application.init(&app);
    uart.puts("System ready\r\n");

    // Run-to-completion super-loop
    while (true) {
        application.tick(&app);
    }
}
