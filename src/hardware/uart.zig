// A substantial portion of this came from: https://github.com/FireFox317/avr-arduino-zig/blob/master/src/uart.zig
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

const atmega2560 = @import("atmega2560.zig");
const peripherals = @import("atmega2560.zig").peripherals;

pub fn init(comptime baud: comptime_int) void {
    // Set baudrate
    peripherals.USART0.*.UBRR0 = (atmega2560.CPU_FREQ / (8 * baud)) - 1;

    // Default uart settings are 8n1, so no need to change them!
    peripherals.USART0.*.UCSR0A.modify(.{ .U2X0 = 1 });

    // Enable transmitter!
    peripherals.USART0.*.UCSR0B.modify(.{ .TXEN0 = 1 });
}

pub fn write(data: []const u8) void {
    for (data) |ch| {
        write_ch(ch);
    }

    // Wait till we are actually done sending
    while (peripherals.USART0.*.UCSR0A.read().TXC0 != 1) {}
}

pub fn write_ch(ch: u8) void {
    // Wait till the transmit buffer is empty
    while (peripherals.USART0.*.UCSR0A.read().UDRE0 != 1) {}

    peripherals.USART0.*.UDR0 = ch;
}
