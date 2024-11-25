//! Control driver for the PL011 PrimeCell UART

const std = @import("std");

const Pl011 = @This();

const Pl011_UART = packed struct {
    dr: packed struct(u16) {
        data: u8, // RX/TX data character
        fe: enum(u1) {
            valid_stop_bit = 0,
            invalid_stop_bit = 1,
        }, //framing error
        pe: enum(u1) {
            valid_parity = 0,
            parity_mismatch = 1,
        }, // parity error
        be: enum(u1) {
            no_break_condition = 0,
            break_condition_detected = 1,
        }, // break error
        oe: enum(u1) {
            data_empty = 0,
            data_received_while_full = 1,
        }, // overrun error
        unused: u4, // unused
    },
    unused_0: u16,
    rsr: packed struct(u8) {
        fe: enum(u1) {
            valid_stop_bit = 0,
            invalid_stop_bit = 1,
        }, //framing error
        pe: enum(u1) {
            valid_parity = 0,
            parity_mismatch = 1,
        }, // parity error
        be: enum(u1) {
            no_break_condition = 0,
            break_condition_detected = 1,
        }, // break error
        oe: enum(u1) {
            data_empty = 0,
            data_received_while_full = 1,
        }, // overrun error
        unused: u4,
    },
    reserved_0: [12]u8,
    unused_1: [4]u8,
    fr: packed struct(u16) {
        cts: enum(u1) {
            clear_to_send = 0,
            not_clear_to_send = 1,
        },
        dsr: enum(u1) {
            data_set_ready = 0,
            data_set_not_ready = 1,
        },
        dcd: enum(u1) {
            data_carrier_detected = 0,
            data_carrier_not_detected = 1,
        },
        busy: enum(u1) {
            not_busy = 0,
            // UART is busy transmitting data, including stop bits
            // This bit is set as soon as the transmit FIFO becomes non-empty
            busy = 1,
        },
        rxfe: enum(u1) {
            receive_fifo_not_empty = 0,
            receive_fifo_empty = 1, // if FIFO is disabled then this is set when the receive holding register is empty
        },
        txff: enum(u1) {
            transmit_fifo_not_full = 0,
            transmit_fifo_full = 1, // if FIFO is disabled then this is set when the transmit holding register is full
        },
        rxff: enum(u1) {
            receive_fifo_not_full = 0,
            receive_fifo_full = 1, // if FIFO is disabled then this is set when the receive holding register is full
        },
        txfe: enum(u1) {
            transmit_fifo_not_empty = 0,
            transmit_fifo_empty = 1, // if FIFO is disabled then this is set when the transmit holding register is empty
            // NOTE: This does not indicate if there is data in the transmit shift register
        },
        ri: enum(u1) {
            ring_indicator_high = 0,
            ring_indicator_low = 1, // TODO: Idk  what this means
        },
        unused: u8,
    },
    unused_2: [2]u8,
    reserved_2: [4]u8,
    ilpr: u8, // TODO: expand upon this
    unused_3: [3]u8,
    ibrd: packed struct(u16) { // integer baud rate register
        baud_divint: u16,
    },
    unused_4: [2]u8,
    fbrd: packed struct(u8) { // fractional baud rate register
        baud_divfrac: u5,
        unused: u3,
    },
    unused_5: [3]u8,
    lcr_h: packed struct(u16) { // line control register
        brk: enum(u1) {
            dont_send_break = 0,
            send_break = 1,
        },
        pen: enum(u1) {
            parity_disabled = 0,
            parity_enabled = 1,
        },
        eps: enum(u1) {
            odd_parity = 0,
            even_parity = 1,
        },
        stp2: enum(u1) {
            one_stop_bit = 0,
            send_two_stop_bits = 1,
        },
        fen: enum(u1) {
            disable_fifos = 0, // character mode
            enable_fifos = 1,
        },
        wlen: enum(u2) { // word length
            five_bits = 0,
            six_bits = 1,
            seven_bits = 2,
            eight_bits = 3,
        },
        sps: enum(u1) {
            stick_parity_disabled = 0,
            stick_parity_enabled = 1, // See data sheet
        },
        unused: u8,
    },
    unused_6: [2]u8,
    cr: packed struct(u16) { // control register
        uarten: enum(u1) {
            uart_disabled = 0,
            uart_enabled = 1,
        },
        siren: enum(u1) { // SIR enable: see data sheet
            sir_disabled = 0,
            sir_enabled = 1,
        },
        sirlp: enum(u1) { // SIR low-power IrDA mode
            sir_low_power_disabled = 0,
            sir_low_power_enabled = 1,
        },
        unused: u4,
        lbe: enum(u1) {
            loopback_disabled = 0,
            loopback_enabled = 1,
        },
        txe: enum(u1) {
            transmit_disabled = 0,
            transmit_enabled = 1,
        },
        rxe: enum(u1) {
            receive_disabled = 0,
            receive_enabled = 1,
        },
        dtr: enum(u1) {
            data_transmit_high = 0,
            data_transmit_low = 1,
        },
        rts: enum(u1) {
            request_to_send_high = 0,
            request_to_send_low = 1,
        },
        out1: u1, // see data sheet for these
        out2: u1,
        rtsen: enum(u1) {
            rts_hardware_flow_control_disabled = 0,
            rts_hardware_flow_control_enabled = 1,
        },
        ctsen: enum(u1) {
            cts_hardware_flow_disabled = 0,
            cts_hardware_flow_enabled = 0,
        },
    },
    unused_7: [2]u8,
    ifls: packed struct(u16) {
        // Read these as fractions. Aka fifo_1_8 means 1/8th full
        txiflsel: enum(u3) { // Transmit interrupt FIFO level select. Trigger at <=
            fifo_1_8 = 0,
            fifo_1_4 = 1,
            fifo_1_2 = 2,
            fifo_3_4 = 3,
            fifo_7_8 = 4,
            _,
        },
        rxiflsel: enum(u3) { // Receive interrupt FIFO level select. Trigger at >=
            fifo_1_8 = 0,
            fifo_1_4 = 1,
            fifo_1_2 = 2,
            fifo_3_4 = 3,
            fifo_7_8 = 4,
            _,
        },
        unused: u10,
    },
    unused_8: [2]u8,
    imsc: packed struct(u16) { // Interrupt Mask Set/Clear Register
        rimim: u1, // TODO: make enums for these
        ctsmim: u1,
        dcdmim: u1,
        dsrmim: u1,
        rxim: u1,
        txim: u1,
        rtim: u1,
        feim: u1,
        peim: u1,
        beim: u1,
        oiem: u1,
        unused: u5,
    },
    unused_9: [2]u8,
    ris: packed struct(u16) { // Raw Interrupt Status Register
        // TODO: enum
        rirmis: u1,
        ctsrmis: u1,
        dcdrmis: u1,
        dsrrmis: u1,
        rxris: u1,
        txris: u1,
        rtris: u1,
        feris: u1,
        peris: u1,
        beris: u1,
        oeris: u1,
        unused: u5,
    },
    unused_10: [2]u8,
    mis: packed struct(u16) { // Masked interrupt status register
        rimmis: u1,
        ctsmmis: u1,
        dcdmmis: u1,
        dsrmmis: u1,
        rxmis: u1,
        txmis: u1,
        rtmis: u1,
        femis: u1,
        pemis: u1,
        bemis: u1,
        oemis: u1,
        unused: u5,
    },
    unused_11: [2]u8,
    icr: packed struct(u16) { // Interrupt clear register
        // TODO: enum
        rimic: u1,
        ctsmic: u1,
        dcdmic: u1,
        dsrmic: u1,
        rxic: u1,
        txic: u1,
        rtic: u1,
        feic: u1,
        peic: u1,
        beic: u1,
        oeic: u1,
        unused: u5,
    },
    unused_12: [2]u8,
    dmacr: packed struct(u16) { // DMA Control Register
        rxdmae: enum(u1) {
            receive_dma_disable = 0,
            receive_dma_enable = 1,
        },
        txdmae: enum(u1) {
            transmit_dma_disable = 0,
            transmit_dma_enable = 1,
        },
        dmaonerr: enum(u1) {
            no_dma_on_error = 0,
            dma_on_error = 1,
        },
        unused: u13,
    },
    reserved_3: [48]u8, // I have no clue why there's just 48 bytes floating around out here but the data sheets says there are
    unused_13: [4]u8,
    reserved_4: [12]u8, // Reserved for test purposes
    unused_14: [4]u8,
    reserved_5: [0xFCC - 0x090]u8, // Reserved
    unused_15: [4]u8,
    reserved_6: [0xFDC - 0xFD0]u8, // Reserved for future ID expansion
    unused_16: [4]u8,
    // TODO: I'm including the unused space here as well, gotta fix that later
    periph_id0: u32,
    periph_id1: u32,
    periph_id2: u32,
    periph_id3: u32,
    cell_id0: u32,
    cell_id1: u32,
    cell_id2: u32,
    cell_id3: u32,
};

comptime {
    std.debug.assert(@sizeOf(Pl011_UART) == 0xFFF);
}

registers: *volatile Pl011_UART = undefined,
base_clock: u64,
baudrate: u32 = undefined,

fn calculate_divisiors(this: *Pl011, integer: *u32, fractional: *u32) void {
    // 64 * F_UARTCLK / (16 * B) = 4 * F_UARTCLK / B
    const div: u32 = 4 * @divTrunc(this.base_clock, this.baudrate); // TODO: divExact?

    fractional.* = div & 0x3f;
    integer.* = (div >> 6) & 0xffff;
}

fn wait_tx_complete(this: *Pl011) void {
    while (this.registers.fr.busy != .not_busy) {}
}

pub fn init(base_address: usize, base_clock: u64) Pl011 {
    var pl011: Pl011 = .{ .base_clock = base_clock, .registers = @ptrFromInt(base_address) };

    pl011.baudrate = 115200;
    // const data_bits = .eight_bits;
    // const stop_bits = .dont_send_two_stop_bits;

    pl011.reset();
    return pl011;
}

fn reset(this: Pl011) void {
    // Disable UART before anything else
    this.registers.cr.uarten = .uart_disabled;

    // Wait for any ongoing transmissions to complete
    this.wait_tx_complete();

    // Flush FIFOs
    this.registers.lcr_h.fen = .disable_fifos;

    // Set frequency divisors (UARTIBRD and UARTFBRD) to configure the speed
    var ibrd: u32 = undefined;
    var fbrd: u32 = undefined;
    this.calculate_divisiors(&ibrd, &fbrd);
    this.registers.ibrd.baud_divint = ibrd;
    this.registers.fbrd.baud_divfrac = fbrd;

    // Configure data frame format according to the parameters (UARTLCR_H).
    // We don't actually use all the possibilities, so this part of the code
    // can be simplified.
    this.registers.lcr_h.wlen = .eight_bits;
    // Configure the number of stop bits
    this.registers.lcr_h.stp2 = .one_stop_bit;

    // Mask all interrupts by setting corresponding bits to 1
    // TODO: This is terrible
    this.registers.imsc = .{ .beim = 1, .ctsmim = 1, .dcdmim = 1, .dsrmim = 1, .feim = 1, .oiem = 1, .peim = 1, .rimim = 1, .rtim = 1, .rxim = 1, .txim = 1, .unused = 0 };

    // Disable DMA by setting all bits to 0
    this.registers.dmacr = .{ .dmaonerr = 0, .rxdmae = 0, .txdmae = 0, .unused = 0 };

    // I only need transmission, so that's the only thing I enabled.
    this.registers.cr.txe = .transmit_enabled;

    // Finally enable UART
    this.registers.cr.uarten = .uart_enabled;
}

pub fn send(this: *Pl011, data: []const u8) void {
    // make sure that there is no outstanding transfer just in case
    this.wait_tx_complete();

    for (data) |char| {
        if (char == '\n') {
            this.registers.dr.data = '\r';
            this.wait_tx_complete();
        }
        this.registers.dr.data = char;
        this.wait_tx_complete();
    }
}
