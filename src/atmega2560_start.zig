// A substantial portion of this came from: https://github.com/FireFox317/avr-arduino-zig/blob/master/src/start.zig
// Original License:
//
// MIT License
//
// Copyright (c) 2021 Timon Kruiper
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

const std = @import("std");
const atmega2560 = @import("hardware/atmega2560.zig");
const hardware = @import("hardware/hardware.zig");
const uart = @import("hardware/uart.zig");
const main = @import("atmega2560_main.zig");

comptime {
    std.debug.assert(std.mem.eql(u8, "RESET", std.meta.fields(atmega2560.VectorTable)[0].name));
    var asm_str: []const u8 = ".section .vectors\njmp _start\n";

    const has_interrupts = @hasDecl(hardware, "interrupts");
    if (has_interrupts) {
        if (@hasDecl(hardware.interrupts, "RESET"))
            @compileError("Not allowed to overload the reset vector");

        for (std.meta.declarations(hardware.interrupts)) |decl| {
            if (!@hasField(atmega2560.VectorTable, decl.name)) {
                var msg: []const u8 = "There is no such interrupt as '" ++ decl.name ++ "'. ISRs the 'interrupts' namespace must be one of:\n";
                for (std.meta.fields(atmega2560.VectorTable)) |field| {
                    if (!std.mem.eql(u8, "RESET", field.name)) {
                        msg = msg ++ "    " ++ field.name ++ "\n";
                    }
                }

                @compileError(msg);
            }
        }
    }

    for (std.meta.fields(atmega2560.VectorTable)[1..]) |field| {
        const new_insn = if (has_interrupts) overload: {
            if (@hasDecl(hardware.interrupts, field.name)) {
                const handler = @field(hardware.interrupts, field.name);
                const calling_convention = switch (@typeInfo(@TypeOf(@field(hardware.interrupts, field.name)))) {
                    .Fn => |info| info.calling_convention,
                    else => @compileError("Declarations in 'interrupts' namespace must all be functions. '" ++ field.name ++ "' is not a function"),
                };

                const exported_fn = switch (calling_convention) {
                    .Unspecified => struct {
                        fn wrapper() callconv(.C) void {
                            //if (calling_convention == .Unspecified) // TODO: workaround for some weird stage1 bug
                            @call(.{ .modifier = .always_inline }, handler, .{});
                        }
                    }.wrapper,
                    else => @compileError("Just leave interrupt handlers with an unspecified calling convention"),
                };

                const options = .{ .name = field.name, .linkage = .Strong };
                @export(exported_fn, options);
                break :overload "jmp " ++ field.name;
            } else {
                break :overload "jmp _unhandled_vector";
            }
        } else "jmp _unhandled_vector";

        asm_str = asm_str ++ new_insn ++ "\n";
    }
    asm (asm_str);
}

export fn _unhandled_vector() void {
    while (true) {}
}

pub export fn _start() noreturn {
    // At startup the stack pointer is at the end of RAM
    // so, no need to set it manually!

    copy_data_to_ram();
    clear_bss();

    main.main();
    while (true) {}
}

fn copy_data_to_ram() void {
    asm volatile (
        \\  ; load Z register with the address of the data in flash
        \\  ldi r30, lo8(__data_load_start)
        \\  ldi r31, hi8(__data_load_start)
        \\  ; load X register with address of the data in ram
        \\  ldi r26, lo8(__data_start)
        \\  ldi r27, hi8(__data_start)
        \\  ; load address of end of the data in ram
        \\  ldi r24, lo8(__data_end)
        \\  ldi r25, hi8(__data_end)
        \\  rjmp .L2
        \\
        \\.L1:
        \\  lpm r18, Z+ ; copy from Z into r18 and increment Z
        \\  st X+, r18  ; store r18 at location X and increment X
        \\
        \\.L2:
        \\  cp r26, r24
        \\  cpc r27, r25 ; check and branch if we are at the end of data
        \\  brne .L1
    );
    // Probably a good idea to add clobbers here, but compiler doesn't seem to care
}

fn clear_bss() void {
    asm volatile (
        \\  ; load X register with the beginning of bss section
        \\  ldi r26, lo8(__bss_start)
        \\  ldi r27, hi8(__bss_start)
        \\  ; load end of the bss in registers
        \\  ldi r24, lo8(__bss_end)
        \\  ldi r25, hi8(__bss_end)
        \\  ldi r18, 0x00
        \\  rjmp .L4
        \\
        \\.L3:
        \\  st X+, r18
        \\
        \\.L4:
        \\  cp r26, r24
        \\  cpc r27, r25 ; check and branch if we are at the end of bss
        \\  brne .L3
    );
    // Probably a good idea to add clobbers here, but compiler doesn't seem to care
}

pub fn panic(msg: []const u8, error_return_trace: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    // Currently assumes that the uart is initialized in main().
    uart.write("PANIC: ");
    uart.write(msg);

    // TODO: print stack trace (addresses), which can than be turned into actual source line
    //       numbers on the connected machine.
    _ = error_return_trace;
    while (true) {}
}
