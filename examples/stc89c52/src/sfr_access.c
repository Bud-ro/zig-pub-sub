/* SFR accessor functions for the STC89C52RC (8051).
 *
 * 8051 SFRs live in a special address space that SDCC accesses via the
 * __sfr keyword.  The Zig C backend emits standard C which cannot express
 * these, so all SFR reads and writes are routed through thin C wrappers
 * compiled directly by SDCC. */

/* --- SFR declarations --- */

__sfr __at(0x90) P1;     /* Port 1 (LED on bit 0) */
__sfr __at(0x98) SCON;   /* Serial control */
__sfr __at(0x99) SBUF;   /* Serial buffer */
__sfr __at(0x89) TMOD;   /* Timer mode */
__sfr __at(0x8D) TH1;    /* Timer 1 high byte (auto-reload value) */
__sfr __at(0x88) TCON;   /* Timer control */
__sfr __at(0x87) PCON;   /* Power control */

/* --- P1 (GPIO) --- */

void sfr_set_p1(unsigned char val) { P1 = val; }
unsigned char sfr_get_p1(void) { return P1; }

/* --- UART --- */

/* Initialize UART: mode 1, 9600 baud at 11.0592 MHz.
 *   SCON = 0x40  -- mode 1 (8-bit UART), TX only (REN=0)
 *   TMOD = 0x20  -- Timer1 mode 2 (8-bit auto-reload)
 *   TH1  = 0xFD  -- reload for 9600 baud
 *   TR1  = 1     -- start Timer1 (TCON bit 6) */
void sfr_uart_init(void) {
    SCON = 0x40;
    TMOD = 0x20;
    TH1  = 0xFD;
    TCON |= 0x40;  /* TR1 = 1 */
}

/* Transmit one byte: write SBUF, wait for TI, clear TI. */
void sfr_uart_putc(unsigned char c) {
    SBUF = c;
    while (!(SCON & 0x02));  /* wait for TI */
    SCON &= ~0x02;           /* clear TI */
}
