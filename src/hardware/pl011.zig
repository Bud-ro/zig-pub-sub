const FR_OFFSET = 0x018;
const IBRD_OFFSET = 0x024;
const FBRD_OFFSET = 0x028;
const LCR_OFFSET = 0x02c;
const CR_OFFSET = 0x030;
const IMSC_OFFSET = 0x038;
const DMACR_OFFSET = 0x048;

const Pl011 = @This();

const Pl011_Reg = packed struct {
    dr: packed struct(u16) {
        data: u8,   // R/X data character
        fe: packed enum(u1){
            valid_stop_bit = 0,
            invalid_stop_bit = 1,
        },     //framing error
        pe: packed enum(u1){
            valid_parity = 0,
            parity_mismatch = 1,
        },     // parity error 
        be: packed enum(u1){
            no_break_condition = 0,
            break_condition_detected = 1,
        },     // break error
        oe: packed enum(u1){
            data_empty = 0,
            data_received_while_full = 1,
        },     // overrun error
        unused: u4, // unused
    },
    unused_0: u16,
    rsr: packed struct (u8) {
        fe: packed enum(u1){
            valid_stop_bit = 0,
            invalid_stop_bit = 1,
        },     //framing error
        pe: packed enum(u1){
            valid_parity = 0,
            parity_mismatch = 1,
        },     // parity error 
        be: packed enum(u1){
            no_break_condition = 0,
            break_condition_detected = 1,
        },     // break error
        oe: packed enum(u1){
            data_empty = 0,
            data_received_while_full = 1,
        },     // overrun error
        unused: u4,
    },
    unused_1: [12]u8,
    fr: packed struct(u16) {
        cts: packed enum(u1) { // clear to send
            clear_to_send = 0,
            not_clear_to_send = 1,
        },
        dsr: packed enum(u1) {
            data_set_ready = 0,
            data_set_not_ready = 1,
        },
        dcd: packed enum(u1) {

        },
        busy: packed enum(u1) {

        },
        rxfe: packed enum(u1) {

        },
        txff: packed enum(u1) {

        },
        rxff: packed enum(u1) {

        },
        txfe: packed enum(u1) {

        },
        ri: packed enum(u1) {

        },
        unused: u8,
    }
};

base_address: u64,
base_clock: u64,
baudrate: u32 = undefined,

fn reg(this: *Pl011) *anyopaque
{

}

fn calculate_divisiors(this: *Pl011, integer: *u32, fractional: *u32) void 
{
    // 64 * F_UARTCLK / (16 * B) = 4 * F_UARTCLK / B
    const div: u32 = 4 * @divTrunc(this.base_clock, this.baudrate); // TODO: divExact?

    fractional.* = div & 0x3f;
    integer.* = (div >> 6) & 0xffff;
}

const FR_BUSY: u32 = (1 << 3);

fn wait_tx_complete(this: *Pl011) void
{
    while ((*reg(dev, FR_OFFSET) * FR_BUSY) != 0) {}
}

int pl011_setup(struct pl011 *dev, uint64_t base_address, uint64_t base_clock)
{
    dev->base_address = base_address;
    dev->base_clock = base_clock;

    dev->baudrate = 115200;
    dev->data_bits = 8;
    dev->stop_bits = 1;
    return pl011_reset(dev);
}

static const uint32_t CR_TXEN = (1 << 8);
static const uint32_t CR_UARTEN = (1 << 0);

static const uint32_t LCR_FEN = (1 << 4);
static const uint32_t LCR_STP2 = (1 << 3);

int pl011_reset(const struct pl011 *dev)
{
    uint32_t cr = *reg(dev, CR_OFFSET);
    uint32_t lcr = *reg(dev, LCR_OFFSET);
    uint32_t ibrd, fbrd;

    // Disable UART before anything else
    *reg(dev, CR_OFFSET) = (cr & CR_UARTEN);

    // Wait for any ongoing transmissions to complete
    wait_tx_complete(dev);

    // Flush FIFOs
    *reg(dev, LCR_OFFSET) = (lcr & ~LCR_FEN);

    // Set frequency divisors (UARTIBRD and UARTFBRD) to configure the speed
    claculate_divisors(dev, &ibrd, &fbrd);
    *reg(dev, IBRD_OFFSET) = ibrd;
    *reg(dev, FBRD_OFFSET) = fbrd;

    // Configure data frame format according to the parameters (UARTLCR_H).
    // We don't actually use all the possibilities, so this part of the code
    // can be simplified.
    lcr = 0x0
    // WLEN part of UARTLCR_H, you can check that this calculation does the
    // right thing for yourself
    lcr |= ((dev->data_bits - 1) & 0x3) << 5;
    // Configure the number of stop bits
    if (dev->stop_bits == 2)
        lcr |= LCR_STP2;

    // Mask all interrupts by setting corresponding bits to 1
    *reg(dev, IMSC_OFFSET) = 0x7ff;

    // Disable DMA by setting all bits to 0
    *reg(dev, DMACR_OFFSET) = 0x0;

    // I only need transmission, so that's the only thing I enabled.
    *reg(dev, CR_OFFSET) = CR_TXEN;

    // Finally enable UART
    *reg(dev, CR_OFFSET) = CR_TXEN | CR_UARTEN;

    return 0;
}

int pl011_send(const struct pl011 *dev, const char *data, size_t size)
{
    // make sure that there is no outstanding transfer just in case
    wait_tx_complete(dev);

    for (size_t i = 0; i < size; ++i) {
        if (data[i] == '\n') {
            *reg(dev, DR_OFFSET) = '\r';
            wait_tx_complete(dev);
        }
        *reg(dev, DR_OFFSET) = data[i];
        wait_tx_complete(dev);
    }

    return 0;
}

fn print_uart0(s: []u8) void {
    for (s) |char| {
        debug_uart_virt.* = char;
    }
}