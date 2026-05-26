/* MC9S08QE8 special function register access via SDCC __at syntax.
   HCS08 SFRs live at fixed addresses; SDCC's __at places variables
   directly at those addresses so the compiler emits absolute loads
   and stores. Zig (via the C backend) calls these accessor functions. */

/* GPIO Port A */
volatile unsigned char __at(0x0000) PTAD;
volatile unsigned char __at(0x0001) PTADD;

/* GPIO Port B */
volatile unsigned char __at(0x0002) PTBD;
volatile unsigned char __at(0x0003) PTBDD;

/* SCI (UART) */
volatile unsigned char __at(0x0020) SCIBDH;
volatile unsigned char __at(0x0021) SCIBDL;
volatile unsigned char __at(0x0022) SCIC1;
volatile unsigned char __at(0x0023) SCIC2;
volatile unsigned char __at(0x0024) SCIS1;
volatile unsigned char __at(0x0027) SCID;

/* System Options (write-once after reset) -- address 0x1802 is outside
   the direct page (0x00-0xFF), so __xdata is required for SDCC to emit
   extended addressing instead of direct-page (8-bit) addressing. */
volatile __xdata unsigned char __at(0x1802) SOPT1;

/* --- GPIO Port A accessors --- */
void sfr_set_ptad(unsigned char v) { PTAD = v; }
unsigned char sfr_get_ptad(void) { return PTAD; }
void sfr_set_ptadd(unsigned char v) { PTADD = v; }

/* --- GPIO Port B accessors --- */
void sfr_set_ptbd(unsigned char v) { PTBD = v; }
unsigned char sfr_get_ptbd(void) { return PTBD; }
void sfr_set_ptbdd(unsigned char v) { PTBDD = v; }

/* --- SCI (UART) accessors --- */
void sfr_set_scibdh(unsigned char v) { SCIBDH = v; }
void sfr_set_scibdl(unsigned char v) { SCIBDL = v; }
void sfr_set_scic2(unsigned char v) { SCIC2 = v; }
unsigned char sfr_get_scis1(void) { return SCIS1; }
void sfr_set_scid(unsigned char v) { SCID = v; }

/* --- System Options accessor --- */
void sfr_set_sopt1(unsigned char v) { SOPT1 = v; }
