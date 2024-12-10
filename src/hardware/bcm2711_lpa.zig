// Auto generated using regz and the SVD from https://github.com/adafruit/broadcom-peripherals/tree/main-build

const micro = @import("microzig");
const mmio = micro.mmio;

pub const devices = struct {
    ///  BCM2711 found in the Raspberry Pi 4
    pub const bcm2711_lpa = struct {
        pub const properties = struct {
            pub const @"cpu.endian" = "little";
            pub const @"cpu.revision" = "r0p0";
            pub const @"cpu.name" = "CA72";
            pub const @"cpu.nvicPrioBits" = "2";
        };

        pub const VectorTable = extern struct {
            const Handler = micro.interrupt.Handler;
            const unhandled = micro.interrupt.unhandled;

            initial_stack_pointer: u32,
            Reset: Handler,
            reserved0: [13]u32 = undefined,
            SysTick: Handler = unhandled,
            ///  Software generated interrupt 0
            SGI0: Handler = unhandled,
            ///  Software generated interrupt 1
            SGI1: Handler = unhandled,
            ///  Software generated interrupt 2
            SGI2: Handler = unhandled,
            ///  Software generated interrupt 3
            SGI3: Handler = unhandled,
            ///  Software generated interrupt 4
            SGI4: Handler = unhandled,
            ///  Software generated interrupt 5
            SGI5: Handler = unhandled,
            ///  Software generated interrupt 6
            SGI6: Handler = unhandled,
            ///  Software generated interrupt 7
            SGI7: Handler = unhandled,
            ///  Software generated interrupt 8
            SGI8: Handler = unhandled,
            ///  Software generated interrupt 9
            SGI9: Handler = unhandled,
            ///  Software generated interrupt 10
            SGI10: Handler = unhandled,
            ///  Software generated interrupt 11
            SGI11: Handler = unhandled,
            ///  Software generated interrupt 12
            SGI12: Handler = unhandled,
            ///  Software generated interrupt 13
            SGI13: Handler = unhandled,
            ///  Software generated interrupt 14
            SGI14: Handler = unhandled,
            ///  Software generated interrupt 15
            SGI15: Handler = unhandled,
            reserved30: [46]u32 = undefined,
            ///  OR of EMMC and EMMC2
            EMMC: Handler = unhandled,
            reserved77: [33]u32 = undefined,
            ///  Timer 0 matched
            TIMER_0: Handler = unhandled,
            ///  Timer 1 matched
            TIMER_1: Handler = unhandled,
            ///  Timer 2 matched
            TIMER_2: Handler = unhandled,
            ///  Timer 3 matched
            TIMER_3: Handler = unhandled,
            reserved114: [5]u32 = undefined,
            ///  USB interrupt
            USB: Handler = unhandled,
            reserved120: [19]u32 = undefined,
            ///  Interrupt from AUX
            AUX: Handler = unhandled,
            reserved140: [19]u32 = undefined,
            ///  Interrupt from bank 0
            GPIO0: Handler = unhandled,
            ///  Interrupt from bank 1
            GPIO1: Handler = unhandled,
            ///  Interrupt from bank 2
            GPIO2: Handler = unhandled,
            ///  OR of all GPIO interrupts
            GPIO: Handler = unhandled,
            ///  OR of all I2C interrupts
            I2C: Handler = unhandled,
            ///  OR of all SPI interrupts except 1 and 2
            SPI: Handler = unhandled,
            reserved165: [2]u32 = undefined,
            ///  OR of all UART interrupts except 1
            UART: Handler = unhandled,
        };

        pub const peripherals = struct {
            ///  Broadcom System Timer
            pub const SYSTMR: *volatile types.peripherals.SYSTMR = @ptrFromInt(0xfe003000);
            ///  Mailboxes for talking to/from VideoCore
            pub const VCMAILBOX: *volatile types.peripherals.VCMAILBOX = @ptrFromInt(0xfe00b880);
            ///  Broadcom Clock Manager
            pub const CM_PCM: *volatile types.peripherals.CM_PCM = @ptrFromInt(0xfe101098);
            ///  Broadcom Clock Manager
            pub const CM_PWM: *volatile types.peripherals.CM_PCM = @ptrFromInt(0xfe1010a0);
            ///  Pin level and mux control
            pub const GPIO: *volatile types.peripherals.GPIO = @ptrFromInt(0xfe200000);
            ///  ARM Prime Cell PL011
            pub const UART0: *volatile types.peripherals.UART0 = @ptrFromInt(0xfe201000);
            ///  ARM Prime Cell PL011
            pub const UART2: *volatile types.peripherals.UART0 = @ptrFromInt(0xfe201400);
            ///  ARM Prime Cell PL011
            pub const UART3: *volatile types.peripherals.UART0 = @ptrFromInt(0xfe201600);
            ///  ARM Prime Cell PL011
            pub const UART4: *volatile types.peripherals.UART0 = @ptrFromInt(0xfe201800);
            ///  ARM Prime Cell PL011
            pub const UART5: *volatile types.peripherals.UART0 = @ptrFromInt(0xfe201a00);
            ///  Broadcom SPI Controller
            pub const SPI0: *volatile types.peripherals.SPI0 = @ptrFromInt(0xfe204000);
            ///  Broadcom SPI Controller
            pub const SPI3: *volatile types.peripherals.SPI0 = @ptrFromInt(0xfe204600);
            ///  Broadcom SPI Controller
            pub const SPI4: *volatile types.peripherals.SPI0 = @ptrFromInt(0xfe204800);
            ///  Broadcom SPI Controller
            pub const SPI5: *volatile types.peripherals.SPI0 = @ptrFromInt(0xfe204a00);
            ///  Broadcom SPI Controller
            pub const SPI6: *volatile types.peripherals.SPI0 = @ptrFromInt(0xfe204c00);
            ///  Interrupt status of new peripherals
            pub const PACTL: *volatile types.peripherals.PACTL = @ptrFromInt(0xfe204e00);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC0: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe205000);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC3: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe205600);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC4: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe205800);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC5: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe205a00);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC6: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe205c00);
            ///  Broadcom PWM
            pub const PWM0: *volatile types.peripherals.PWM0 = @ptrFromInt(0xfe20c000);
            ///  Broadcom PWM
            pub const PWM1: *volatile types.peripherals.PWM0 = @ptrFromInt(0xfe20c800);
            ///  Three auxiliary peripherals
            pub const AUX: *volatile types.peripherals.AUX = @ptrFromInt(0xfe215000);
            ///  Mini UART
            pub const UART1: *volatile types.peripherals.UART1 = @ptrFromInt(0xfe215040);
            ///  Aux SPI
            pub const SPI1: *volatile types.peripherals.SPI1 = @ptrFromInt(0xfe215080);
            ///  Aux SPI
            pub const SPI2: *volatile types.peripherals.SPI1 = @ptrFromInt(0xfe2150c0);
            ///  Arasan SD3.0 Host AHB eMMC 4.4
            pub const EMMC: *volatile types.peripherals.EMMC = @ptrFromInt(0xfe300000);
            ///  Broadcom Serial Controller (I2C compatible)
            pub const BSC1: *volatile types.peripherals.BSC0 = @ptrFromInt(0xfe804000);
            ///  USB on the go high speed
            pub const USB_OTG_GLOBAL: *volatile types.peripherals.USB_OTG_GLOBAL = @ptrFromInt(0xfe980000);
            ///  USB on the go high speed
            pub const USB_OTG_HOST: *volatile types.peripherals.USB_OTG_HOST = @ptrFromInt(0xfe980400);
            ///  USB on the go high speed
            pub const USB_OTG_DEVICE: *volatile types.peripherals.USB_OTG_DEVICE = @ptrFromInt(0xfe980800);
            ///  USB on the go high speed power control
            pub const USB_OTG_PWRCLK: *volatile types.peripherals.USB_OTG_PWRCLK = @ptrFromInt(0xfe980e00);
            ///  Broadcom Legacy Interrupt Controller
            pub const LIC: *volatile types.peripherals.LIC = @ptrFromInt(0xff800000);
            ///  ARM GIC-400 Generic Interrupt Controller Distributor
            pub const GIC_DIST: *volatile types.peripherals.GIC_DIST = @ptrFromInt(0xff841000);
            ///  ARM GIC-400 Generic Interrupt Controller CPU Interface
            pub const GIC_CPU: *volatile types.peripherals.GIC_CPU = @ptrFromInt(0xff842000);
        };
    };
};

pub const types = struct {
    pub const peripherals = struct {
        ///  Mailboxes for talking to/from VideoCore
        pub const VCMAILBOX = extern struct {
            ///  Read messages from the VideoCore
            READ: u32,
            reserved16: [12]u8,
            PEEK0: u32,
            SENDER0: u32,
            STATUS0: mmio.Mmio(packed struct(u32) {
                reserved30: u30,
                EMPTY: u1,
                FULL: u1,
            }),
            CONFIG0: mmio.Mmio(packed struct(u32) {
                ///  Enable the interrupt when data is available
                IRQEN: u1,
                padding: u31,
            }),
            ///  Write messages to the VideoCore
            WRITE: u32,
            reserved48: [12]u8,
            PEEK1: u32,
            SENDER1: u32,
            STATUS1: u32,
            CONFIG1: u32,
        };

        ///  Broadcom Clock Manager
        pub const CM_PCM = extern struct {
            ///  Control / Status
            CS: mmio.Mmio(packed struct(u32) {
                reserved4: u4,
                ///  Enable the clock generator. (Switch SRC first.)
                ENAB: u1,
                ///  Stop and reset the generator
                KILL: u1,
                reserved7: u1,
                ///  Indicates the clock generator is running
                BUSY: u1,
                ///  Generate an edge on output. (For testing)
                FLIP: u1,
                ///  MASH control, stage count
                MASH: u2,
                reserved24: u13,
                ///  Password. Always 0x5a
                PASSWD: packed union {
                    raw: u8,
                    value: enum(u8) {
                        PASSWD = 0x5a,
                        _,
                    },
                },
            }),
            ///  Clock divisor
            DIV: mmio.Mmio(packed struct(u32) {
                ///  Fractional part of divisor
                DIVF: u12,
                ///  Integer part of divisor
                DIVI: u12,
                ///  Password. Always 0x5a
                PASSWD: packed union {
                    raw: u8,
                    value: enum(u8) {
                        PASSWD = 0x5a,
                        _,
                    },
                },
            }),
        };

        ///  Arasan SD3.0 Host AHB eMMC 4.4
        pub const EMMC = extern struct {
            ///  Argument for ACMD23 command
            ARG2: u32,
            ///  Numer and size in bytes for data block to be transferred
            BLKSIZECNT: mmio.Mmio(packed struct(u32) {
                ///  Block size in bytes
                BLKSIZE: u10,
                reserved16: u6,
                ///  Number of blocks to be transferred
                BLKCNT: u16,
            }),
            ///  Argument for everything but ACMD23
            ARG1: u32,
            ///  Issue commands to the card
            CMDTM: mmio.Mmio(packed struct(u32) {
                reserved1: u1,
                ///  Enable block counter
                TM_BLKCNT_EN: u1,
                ///  Command after completion
                TM_AUTO_CMD_EN: packed union {
                    raw: u2,
                    value: enum(u2) {
                        NONE = 0x0,
                        CMD12 = 0x1,
                        CMD23 = 0x2,
                        _,
                    },
                },
                ///  Direction of data transfer
                TM_DAT_DIR: packed union {
                    raw: u1,
                    value: enum(u1) {
                        HOST_TO_CARD = 0x0,
                        CARD_TO_HOST = 0x1,
                    },
                },
                ///  Type of data transfer
                TM_MULTI_BLOCK: packed union {
                    raw: u1,
                    value: enum(u1) {
                        SINGLE = 0x0,
                        MULTIPLE = 0x1,
                    },
                },
                reserved16: u10,
                ///  Type of expected response
                CMD_RSPNS_TYPE: packed union {
                    raw: u2,
                    value: enum(u2) {
                        NONE = 0x0,
                        @"136BITS" = 0x1,
                        @"48BITS" = 0x2,
                        @"48BITS_USING_BUSY" = 0x3,
                    },
                },
                reserved19: u1,
                ///  Check the responses CRC
                CMD_CRCCHK_EN: u1,
                ///  Check that the response has the same command index
                CMD_IXCHK_EN: u1,
                ///  Command involves data
                CMD_ISDATA: u1,
                ///  Type of command to be issued
                CMD_TYPE: packed union {
                    raw: u2,
                    value: enum(u2) {
                        NORMAL = 0x0,
                        SUSPEND = 0x1,
                        RESUME = 0x2,
                        ABORT = 0x3,
                    },
                },
                ///  Command index to be issued
                CMD_INDEX: u6,
                padding: u2,
            }),
            ///  Status bits of the response
            RESP0: u32,
            ///  Bits 63:32 of CMD2 and CMD10 responses
            RESP1: u32,
            ///  Bits 95:64 of CMD2 and CMD10 responses
            RESP2: u32,
            ///  Bits 127:96 of CMD2 and CMD10 responses
            RESP3: u32,
            ///  Data to/from the card
            DATA: u32,
            ///  Status info for debugging
            STATUS: mmio.Mmio(packed struct(u32) {
                ///  Command line still in use
                CMD_INHIBIT: u1,
                ///  Data lines still in use
                DAT_INHIBIT: u1,
                ///  At least one data line is active
                DAT_ACTIVE: u1,
                reserved8: u5,
                ///  Write transfer is active
                WRITE_TRANSFER: u1,
                ///  Read transfer is active
                READ_TRANSFER: u1,
                ///  The buffer has space for new data
                BUFFER_WRITE_ENABLE: u1,
                ///  New data is available to read
                BUFFER_READ_ENABLE: u1,
                reserved20: u8,
                ///  Value of DAT[3:0]
                DAT_LEVEL0: u4,
                ///  Value of CMD
                CMD_LEVEL: u1,
                ///  Value of DAT[7:4]
                DAT_LEVEL1: u4,
                padding: u3,
            }),
            ///  Control
            CONTROL0: mmio.Mmio(packed struct(u32) {
                reserved1: u1,
                ///  Use 4 data lines
                HCTL_DWIDTH: u1,
                ///  Enable high speed mode
                HCTL_HS_EN: u1,
                reserved5: u2,
                ///  Use 8 data lines
                HCTL_8BIT: u1,
                reserved16: u10,
                ///  Stop the current transaction at the next block gap
                GAP_STOP: u1,
                ///  Restart a transaction stopped by GAP_STOP
                GAP_RESTART: u1,
                ///  Use DAT2 read/wait protocol
                READWAIT_EN: u1,
                ///  Enable interrupt on block gap
                GAP_IEN: u1,
                ///  Enable SPI mode
                SPI_MODE: u1,
                ///  Boot mode enabled
                BOOT_EN: u1,
                ///  Enable alternate boot mode
                ALT_BOOT_EN: u1,
                padding: u9,
            }),
            ///  Configure
            CONTROL1: mmio.Mmio(packed struct(u32) {
                ///  Enable internal clock
                CLK_INTLEN: u1,
                ///  SD Clock stable
                CLK_STABLE: u1,
                ///  SD Clock enable
                CLK_EN: u1,
                reserved5: u2,
                ///  Mode of clock generation
                CLK_GENSEL: packed union {
                    raw: u1,
                    value: enum(u1) {
                        DIVIDED = 0x0,
                        PROGRAMMABLE = 0x1,
                    },
                },
                ///  Clock base divider MSBs
                CLK_FREQ_MS2: u2,
                ///  Clock base divider LSB
                CLK_FREQ8: u8,
                ///  Data timeout exponent (TMCLK * 2 ** (x + 13)) 1111 disabled
                DATA_TOUNIT: u4,
                reserved24: u4,
                ///  Reset the complete host circuit
                SRST_HC: u1,
                ///  Reset the command handling circuit
                SRST_CMD: u1,
                ///  Reset the data handling circuit
                SRST_DATA: u1,
                padding: u5,
            }),
            ///  Interrupt flags
            INTERRUPT: mmio.Mmio(packed struct(u32) {
                ///  Command has finished
                CMD_DONE: u1,
                ///  Data transfer has finished
                DATA_DONE: u1,
                ///  Data transfer has stopped at block gap
                BLOCK_GAP: u1,
                reserved4: u1,
                ///  DATA can be written to
                WRITE_RDY: u1,
                ///  DATA contains data to be read
                READ_RDY: u1,
                reserved8: u2,
                ///  Card made interrupt request
                CARD: u1,
                reserved12: u3,
                ///  Clock retune request
                RETUNE: u1,
                ///  Boot has been acknowledged
                BOOTACK: u1,
                ///  Boot operation has terminated
                ENDBOOT: u1,
                ///  An error has occured
                ERR: u1,
                ///  Command timeout
                CTO_ERR: u1,
                ///  Command CRC error
                CCRC_ERR: u1,
                ///  Command end bit error (not 1)
                CEND_ERR: u1,
                ///  Incorrect response command index
                CBAD_ERR: u1,
                ///  Data timeout
                DTO_ERR: u1,
                ///  Data CRC error
                DCRC_ERR: u1,
                ///  Data end bit error (not 1)
                DEND_ERR: u1,
                reserved24: u1,
                ///  Auto command error
                ACMD_ERR: u1,
                padding: u7,
            }),
            ///  Mask interrupts that change in INTERRUPT
            IRPT_MASK: mmio.Mmio(packed struct(u32) {
                ///  Command has finished
                CMD_DONE: u1,
                ///  Data transfer has finished
                DATA_DONE: u1,
                ///  Data transfer has stopped at block gap
                BLOCK_GAP: u1,
                reserved4: u1,
                ///  DATA can be written to
                WRITE_RDY: u1,
                ///  DATA contains data to be read
                READ_RDY: u1,
                reserved8: u2,
                ///  Card made interrupt request
                CARD: u1,
                reserved12: u3,
                ///  Clock retune request
                RETUNE: u1,
                ///  Boot has been acknowledged
                BOOTACK: u1,
                ///  Boot operation has terminated
                ENDBOOT: u1,
                reserved16: u1,
                ///  Command timeout
                CTO_ERR: u1,
                ///  Command CRC error
                CCRC_ERR: u1,
                ///  Command end bit error (not 1)
                CEND_ERR: u1,
                ///  Incorrect response command index
                CBAD_ERR: u1,
                ///  Data timeout
                DTO_ERR: u1,
                ///  Data CRC error
                DCRC_ERR: u1,
                ///  Data end bit error (not 1)
                DEND_ERR: u1,
                reserved24: u1,
                ///  Auto command error
                ACMD_ERR: u1,
                padding: u7,
            }),
            ///  Enable interrupt to core
            IRPT_EN: mmio.Mmio(packed struct(u32) {
                ///  Command has finished
                CMD_DONE: u1,
                ///  Data transfer has finished
                DATA_DONE: u1,
                ///  Data transfer has stopped at block gap
                BLOCK_GAP: u1,
                reserved4: u1,
                ///  DATA can be written to
                WRITE_RDY: u1,
                ///  DATA contains data to be read
                READ_RDY: u1,
                reserved8: u2,
                ///  Card made interrupt request
                CARD: u1,
                reserved12: u3,
                ///  Clock retune request
                RETUNE: u1,
                ///  Boot has been acknowledged
                BOOTACK: u1,
                ///  Boot operation has terminated
                ENDBOOT: u1,
                reserved16: u1,
                ///  Command timeout
                CTO_ERR: u1,
                ///  Command CRC error
                CCRC_ERR: u1,
                ///  Command end bit error (not 1)
                CEND_ERR: u1,
                ///  Incorrect response command index
                CBAD_ERR: u1,
                ///  Data timeout
                DTO_ERR: u1,
                ///  Data CRC error
                DCRC_ERR: u1,
                ///  Data end bit error (not 1)
                DEND_ERR: u1,
                reserved24: u1,
                ///  Auto command error
                ACMD_ERR: u1,
                padding: u7,
            }),
            ///  Control 2
            CONTROL2: mmio.Mmio(packed struct(u32) {
                ///  Auto command not executed due to an error
                ACNOX_ERR: u1,
                ///  Auto command timeout
                ACTO_ERR: u1,
                ///  Command CRC error during auto command
                ACCRC_ERR: u1,
                ///  End bit is not 1 during auto command
                ACEND_ERR: u1,
                ///  Command index error during auto command
                ACBAD_ERR: u1,
                reserved7: u2,
                ///  Error during auto CMD12
                NOTC12_ERR: u1,
                reserved16: u8,
                ///  Select the speed of the SD card
                UHSMODE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        SDR12 = 0x0,
                        SDR25 = 0x1,
                        SDR50 = 0x2,
                        SDR104 = 0x3,
                        DDR50 = 0x4,
                        _,
                    },
                },
                reserved22: u3,
                ///  SD Clock tune in progress
                TUNEON: u1,
                ///  Tuned clock is used for sampling data
                TUNED: u1,
                padding: u8,
            }),
            reserved80: [16]u8,
            ///  Force an interrupt
            FORCE_IRPT: mmio.Mmio(packed struct(u32) {
                ///  Command has finished
                CMD_DONE: u1,
                ///  Data transfer has finished
                DATA_DONE: u1,
                ///  Data transfer has stopped at block gap
                BLOCK_GAP: u1,
                reserved4: u1,
                ///  DATA can be written to
                WRITE_RDY: u1,
                ///  DATA contains data to be read
                READ_RDY: u1,
                reserved8: u2,
                ///  Card made interrupt request
                CARD: u1,
                reserved12: u3,
                ///  Clock retune request
                RETUNE: u1,
                ///  Boot has been acknowledged
                BOOTACK: u1,
                ///  Boot operation has terminated
                ENDBOOT: u1,
                reserved16: u1,
                ///  Command timeout
                CTO_ERR: u1,
                ///  Command CRC error
                CCRC_ERR: u1,
                ///  Command end bit error (not 1)
                CEND_ERR: u1,
                ///  Incorrect response command index
                CBAD_ERR: u1,
                ///  Data timeout
                DTO_ERR: u1,
                ///  Data CRC error
                DCRC_ERR: u1,
                ///  Data end bit error (not 1)
                DEND_ERR: u1,
                reserved24: u1,
                ///  Auto command error
                ACMD_ERR: u1,
                padding: u7,
            }),
            reserved112: [28]u8,
            ///  Number of SD clock cycles to wait for boot
            BOOT_TIMEOUT: u32,
            ///  What submodules are accessed by the debug bus
            DBG_SEL: mmio.Mmio(packed struct(u32) {
                SELECT: packed union {
                    raw: u1,
                    value: enum(u1) {
                        RECEIVER_FIFO = 0x0,
                        OTHERS = 0x1,
                    },
                },
                padding: u31,
            }),
            reserved128: [8]u8,
            ///  Fine tune DMA request generation
            EXRDFIFO_CFG: mmio.Mmio(packed struct(u32) {
                ///  Read threshold in 32 bit words
                RD_THRSH: u3,
                padding: u29,
            }),
            ///  Enable the extension data register
            EXRDFIFO_EN: mmio.Mmio(packed struct(u32) {
                ///  Enable the extension FIFO
                ENABLE: u1,
                padding: u31,
            }),
            ///  Sample clock delay step duration
            TUNE_STEP: mmio.Mmio(packed struct(u32) {
                DELAY: u3,
                padding: u29,
            }),
            ///  Sample clock delay step count for SDR
            TUNE_STEPS_STD: mmio.Mmio(packed struct(u32) {
                STEPS: u6,
                padding: u26,
            }),
            ///  Sample clock delay step count for DDR
            TUNE_STEPS_DDR: mmio.Mmio(packed struct(u32) {
                STEPS: u6,
                padding: u26,
            }),
            reserved240: [92]u8,
            ///  Interrupts in SPI mode depend on CS
            SPI_INT_SPT: mmio.Mmio(packed struct(u32) {
                SELECT: u8,
                padding: u24,
            }),
            reserved252: [8]u8,
            ///  Version information and slot interrupt status
            SLOTISR_VER: mmio.Mmio(packed struct(u32) {
                ///  OR of interrupt and wakeup signals for each slot
                SLOT_STATUS: u8,
                reserved16: u8,
                ///  Host controller specification version
                SDVERSION: u8,
                ///  Vendor version number
                VENDOR: u8,
            }),
        };

        ///  Broadcom System Timer
        pub const SYSTMR = extern struct {
            ///  Control / Status
            CS: mmio.Mmio(packed struct(u32) {
                ///  System timer match 0
                M0: u1,
                ///  System timer match 1
                M1: u1,
                ///  System timer match 2
                M2: u1,
                ///  System timer match 3
                M3: u1,
                padding: u28,
            }),
            ///  Lower 32 bits for the free running counter
            CLO: u32,
            ///  Higher 32 bits for the free running counter
            CHI: u32,
            ///  Compare channel 0
            C0: u32,
            ///  Compare channel 1
            C1: u32,
            ///  Compare channel 2
            C2: u32,
            ///  Compare channel 3
            C3: u32,
        };

        ///  ARM Prime Cell PL011
        pub const UART0 = extern struct {
            ///  Data Register
            DR: mmio.Mmio(packed struct(u32) {
                ///  DATA
                DATA: u8,
                ///  FE
                FE: u1,
                ///  PE
                PE: u1,
                ///  BE
                BE: u1,
                ///  OE
                OE: u1,
                padding: u20,
            }),
            ///  Receive Status Register
            RSR: mmio.Mmio(packed struct(u32) {
                ///  FE
                FE: u1,
                ///  PE
                PE: u1,
                ///  BE
                BE: u1,
                ///  OE
                OE: u1,
                padding: u28,
            }),
            reserved24: [16]u8,
            ///  Flag Register
            FR: mmio.Mmio(packed struct(u32) {
                ///  CTS
                CTS: u1,
                ///  DSR
                DSR: u1,
                ///  DCD
                DCD: u1,
                ///  BUSY
                BUSY: u1,
                ///  RXFE
                RXFE: u1,
                ///  TXFF
                TXFF: u1,
                ///  RXFF
                RXFF: u1,
                ///  TXFE
                TXFE: u1,
                ///  RI
                RI: u1,
                padding: u23,
            }),
            reserved36: [8]u8,
            ///  Integer Baud Rate Register
            IBRD: mmio.Mmio(packed struct(u32) {
                ///  BAUDDIVINT
                BAUDDIVINT: u16,
                padding: u16,
            }),
            ///  Fractional Baud Rate Register
            FBRD: mmio.Mmio(packed struct(u32) {
                ///  BAUDDIVFRAC
                BAUDDIVFRAC: u6,
                padding: u26,
            }),
            ///  Line Control Register
            LCR_H: mmio.Mmio(packed struct(u32) {
                ///  BRK
                BRK: u1,
                ///  PEN
                PEN: u1,
                ///  EPS
                EPS: u1,
                ///  STP2
                STP2: u1,
                ///  FEN
                FEN: u1,
                ///  WLEN
                WLEN: u2,
                ///  SPS
                SPS: u1,
                padding: u24,
            }),
            ///  Control Register
            CR: mmio.Mmio(packed struct(u32) {
                ///  UARTEN
                UARTEN: u1,
                ///  SIREN
                SIREN: u1,
                ///  SIRLP
                SIRLP: u1,
                reserved8: u5,
                ///  TXE
                TXE: u1,
                ///  RXE
                RXE: u1,
                ///  DTR
                DTR: u1,
                ///  RTS
                RTS: u1,
                reserved14: u2,
                ///  RTSEN
                RTSEN: u1,
                ///  CTSEN
                CTSEN: u1,
                padding: u16,
            }),
            ///  Interrupt FIFO Level Select Register
            IFLS: mmio.Mmio(packed struct(u32) {
                ///  TXIFLSEL
                TXIFLSEL: u3,
                ///  RXIFLSEL
                RXIFLSEL: u3,
                padding: u26,
            }),
            ///  Interrupt Mask set_Clear Register
            IMSC: mmio.Mmio(packed struct(u32) {
                ///  RIMIM
                RIMIM: u1,
                ///  CTSMIM
                CTSMIM: u1,
                ///  DCDMIM
                DCDMIM: u1,
                ///  DSRMIM
                DSRMIM: u1,
                ///  RXIM
                RXIM: u1,
                ///  TXIM
                TXIM: u1,
                ///  RTIM
                RTIM: u1,
                ///  FEIM
                FEIM: u1,
                ///  PEIM
                PEIM: u1,
                ///  BEIM
                BEIM: u1,
                ///  OEIM
                OEIM: u1,
                padding: u21,
            }),
            ///  Raw Interrupt Status Register
            RIS: mmio.Mmio(packed struct(u32) {
                ///  RIRMIS
                RIRMIS: u1,
                ///  CTSRMIS
                CTSRMIS: u1,
                ///  DCDRMIS
                DCDRMIS: u1,
                ///  DSRRMIS
                DSRRMIS: u1,
                ///  RXRIS
                RXRIS: u1,
                ///  TXRIS
                TXRIS: u1,
                ///  RTRIS
                RTRIS: u1,
                ///  FERIS
                FERIS: u1,
                ///  PERIS
                PERIS: u1,
                ///  BERIS
                BERIS: u1,
                ///  OERIS
                OERIS: u1,
                padding: u21,
            }),
            ///  Masked Interrupt Status Register
            MIS: mmio.Mmio(packed struct(u32) {
                ///  RIMMIS
                RIMMIS: u1,
                ///  CTSMMIS
                CTSMMIS: u1,
                ///  DCDMMIS
                DCDMMIS: u1,
                ///  DSRMMIS
                DSRMMIS: u1,
                ///  RXMIS
                RXMIS: u1,
                ///  TXMIS
                TXMIS: u1,
                ///  RTMIS
                RTMIS: u1,
                ///  FEMIS
                FEMIS: u1,
                ///  PEMIS
                PEMIS: u1,
                ///  BEMIS
                BEMIS: u1,
                ///  OEMIS
                OEMIS: u1,
                padding: u21,
            }),
            ///  Interrupt Clear Register
            ICR: mmio.Mmio(packed struct(u32) {
                ///  RIMIC
                RIMIC: u1,
                ///  CTSMIC
                CTSMIC: u1,
                ///  DCDMIC
                DCDMIC: u1,
                ///  DSRMIC
                DSRMIC: u1,
                ///  RXIC
                RXIC: u1,
                ///  TXIC
                TXIC: u1,
                ///  RTIC
                RTIC: u1,
                ///  FEIC
                FEIC: u1,
                ///  PEIC
                PEIC: u1,
                ///  BEIC
                BEIC: u1,
                ///  OEIC
                OEIC: u1,
                padding: u21,
            }),
            ///  DMA Control Register
            DMACR: mmio.Mmio(packed struct(u32) {
                ///  RXDMAE
                RXDMAE: u1,
                ///  TXDMAE
                TXDMAE: u1,
                ///  DMAONERR
                DMAONERR: u1,
                padding: u29,
            }),
        };

        ///  USB on the go high speed power control
        pub const USB_OTG_PWRCLK = extern struct {
            ///  power and clock gating control
            PCGCCTL: mmio.Mmio(packed struct(u32) {
                ///  Stop PHY clock
                STPPCLK: u1,
                ///  Gate HCLK
                GATEHCLK: u1,
                ///  Power clamp
                PWRCLMP: u1,
                ///  Power down modules
                RSTPDWNMODULE: u1,
                ///  PHY Suspended
                PHYSUSP: u1,
                ///  Enable sleep clock gating
                ENABLE_L1GATING: u1,
                ///  PHY is in sleep mode
                PHYSLEEP: u1,
                ///  PHY is in deep sleep
                DEEPSLEEP: u1,
                ///  Reset after suspend
                RESETAFTERSUSP: u1,
                ///  Restore mode
                RESTOREMODE: u1,
                ///  Enable extended hibernation
                ENEXTNDEDHIBER: u1,
                ///  Extended hibernation clamp
                EXTNDEDHIBERNATIONCLAMP: u1,
                ///  Extended hibernation switch
                EXTNDEDHIBERNATIONSWITCH: u1,
                ///  Essential register values restored
                ESSREGRESTORED: u1,
                ///  Restore value
                RESTORE_VALUE: u18,
            }),
        };

        ///  USB on the go high speed
        pub const USB_OTG_DEVICE = extern struct {
            ///  OTG_HS device configuration register
            DCFG: mmio.Mmio(packed struct(u32) {
                ///  Device speed
                DSPD: u2,
                ///  Nonzero-length status OUT handshake
                NZLSOHSK: u1,
                reserved4: u1,
                ///  Device address
                DAD: u7,
                ///  Periodic (micro)frame interval
                PFIVL: u2,
                reserved24: u11,
                ///  Periodic scheduling interval
                PERSCHIVL: u2,
                padding: u6,
            }),
            ///  OTG_HS device control register
            DCTL: mmio.Mmio(packed struct(u32) {
                ///  Remote wakeup signaling
                RWUSIG: u1,
                ///  Soft disconnect
                SDIS: u1,
                ///  Global IN NAK status
                GINSTS: u1,
                ///  Global OUT NAK status
                GONSTS: u1,
                ///  Test control
                TCTL: u3,
                ///  Set global IN NAK
                SGINAK: u1,
                ///  Clear global IN NAK
                CGINAK: u1,
                ///  Set global OUT NAK
                SGONAK: u1,
                ///  Clear global OUT NAK
                CGONAK: u1,
                ///  Power-on programming done
                POPRGDNE: u1,
                padding: u20,
            }),
            ///  OTG_HS device status register
            DSTS: mmio.Mmio(packed struct(u32) {
                ///  Suspend status
                SUSPSTS: u1,
                ///  Enumerated speed
                ENUMSPD: u2,
                ///  Erratic error
                EERR: u1,
                reserved8: u4,
                ///  Frame number of the received SOF
                FNSOF: u14,
                padding: u10,
            }),
            reserved16: [4]u8,
            ///  OTG_HS device IN endpoint common interrupt mask register
            DIEPMSK: mmio.Mmio(packed struct(u32) {
                ///  Transfer completed interrupt mask
                XFRCM: u1,
                ///  Endpoint disabled interrupt mask
                EPDM: u1,
                reserved3: u1,
                ///  Timeout condition mask (nonisochronous endpoints)
                TOM: u1,
                ///  IN token received when TxFIFO empty mask
                ITTXFEMSK: u1,
                ///  IN token received with EP mismatch mask
                INEPNMM: u1,
                ///  IN endpoint NAK effective mask
                INEPNEM: u1,
                reserved8: u1,
                ///  FIFO underrun mask
                TXFURM: u1,
                ///  BNA interrupt mask
                BIM: u1,
                padding: u22,
            }),
            ///  OTG_HS device OUT endpoint common interrupt mask register
            DOEPMSK: mmio.Mmio(packed struct(u32) {
                ///  Transfer completed interrupt mask
                XFRCM: u1,
                ///  Endpoint disabled interrupt mask
                EPDM: u1,
                reserved3: u1,
                ///  SETUP phase done mask
                STUPM: u1,
                ///  OUT token received when endpoint disabled mask
                OTEPDM: u1,
                reserved6: u1,
                ///  Back-to-back SETUP packets received mask
                B2BSTUP: u1,
                reserved8: u1,
                ///  OUT packet error mask
                OPEM: u1,
                ///  BNA interrupt mask
                BOIM: u1,
                padding: u22,
            }),
            ///  OTG_HS device all endpoints interrupt register
            DAINT: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint interrupt bits
                IEPINT: u16,
                ///  OUT endpoint interrupt bits
                OEPINT: u16,
            }),
            ///  OTG_HS all endpoints interrupt mask register
            DAINTMSK: mmio.Mmio(packed struct(u32) {
                ///  IN EP interrupt mask bits
                IEPM: u16,
                ///  OUT EP interrupt mask bits
                OEPM: u16,
            }),
            reserved40: [8]u8,
            ///  OTG_HS device VBUS discharge time register
            DVBUSDIS: mmio.Mmio(packed struct(u32) {
                ///  Device VBUS discharge time
                VBUSDT: u16,
                padding: u16,
            }),
            ///  OTG_HS device VBUS pulsing time register
            DVBUSPULSE: mmio.Mmio(packed struct(u32) {
                ///  Device VBUS pulsing time
                DVBUSP: u12,
                padding: u20,
            }),
            ///  OTG_HS Device threshold control register
            DTHRCTL: mmio.Mmio(packed struct(u32) {
                ///  Nonisochronous IN endpoints threshold enable
                NONISOTHREN: u1,
                ///  ISO IN endpoint threshold enable
                ISOTHREN: u1,
                ///  Transmit threshold length
                TXTHRLEN: u9,
                reserved16: u5,
                ///  Receive threshold enable
                RXTHREN: u1,
                ///  Receive threshold length
                RXTHRLEN: u9,
                reserved27: u1,
                ///  Arbiter parking enable
                ARPEN: u1,
                padding: u4,
            }),
            ///  OTG_HS device IN endpoint FIFO empty interrupt mask register
            DIEPEMPMSK: mmio.Mmio(packed struct(u32) {
                ///  IN EP Tx FIFO empty interrupt mask bits
                INEPTXFEM: u16,
                padding: u16,
            }),
            ///  OTG_HS device each endpoint interrupt register
            DEACHINT: mmio.Mmio(packed struct(u32) {
                reserved1: u1,
                ///  IN endpoint 1interrupt bit
                IEP1INT: u1,
                reserved17: u15,
                ///  OUT endpoint 1 interrupt bit
                OEP1INT: u1,
                padding: u14,
            }),
            ///  OTG_HS device each endpoint interrupt register mask
            DEACHINTMSK: mmio.Mmio(packed struct(u32) {
                reserved1: u1,
                ///  IN Endpoint 1 interrupt mask bit
                IEP1INTM: u1,
                reserved17: u15,
                ///  OUT Endpoint 1 interrupt mask bit
                OEP1INTM: u1,
                padding: u14,
            }),
            ///  OTG_HS device each in endpoint-1 interrupt register
            DIEPEACHMSK1: mmio.Mmio(packed struct(u32) {
                ///  Transfer completed interrupt mask
                XFRCM: u1,
                ///  Endpoint disabled interrupt mask
                EPDM: u1,
                reserved3: u1,
                ///  Timeout condition mask (nonisochronous endpoints)
                TOM: u1,
                ///  IN token received when TxFIFO empty mask
                ITTXFEMSK: u1,
                ///  IN token received with EP mismatch mask
                INEPNMM: u1,
                ///  IN endpoint NAK effective mask
                INEPNEM: u1,
                reserved8: u1,
                ///  FIFO underrun mask
                TXFURM: u1,
                ///  BNA interrupt mask
                BIM: u1,
                reserved13: u3,
                ///  NAK interrupt mask
                NAKM: u1,
                padding: u18,
            }),
            reserved128: [60]u8,
            ///  OTG_HS device each OUT endpoint-1 interrupt register
            DOEPEACHMSK1: mmio.Mmio(packed struct(u32) {
                ///  Transfer completed interrupt mask
                XFRCM: u1,
                ///  Endpoint disabled interrupt mask
                EPDM: u1,
                reserved3: u1,
                ///  Timeout condition mask
                TOM: u1,
                ///  IN token received when TxFIFO empty mask
                ITTXFEMSK: u1,
                ///  IN token received with EP mismatch mask
                INEPNMM: u1,
                ///  IN endpoint NAK effective mask
                INEPNEM: u1,
                reserved8: u1,
                ///  OUT packet error mask
                TXFURM: u1,
                ///  BNA interrupt mask
                BIM: u1,
                reserved12: u2,
                ///  Bubble error interrupt mask
                BERRM: u1,
                ///  NAK interrupt mask
                NAKM: u1,
                ///  NYET interrupt mask
                NYETM: u1,
                padding: u17,
            }),
        };

        ///  USB on the go high speed
        pub const USB_OTG_HOST = extern struct {
            ///  OTG_HS host configuration register
            HCFG: mmio.Mmio(packed struct(u32) {
                ///  FS/LS PHY clock select
                FSLSPCS: u2,
                ///  FS- and LS-only support
                FSLSS: u1,
                padding: u29,
            }),
            ///  OTG_HS Host frame interval register
            HFIR: mmio.Mmio(packed struct(u32) {
                ///  Frame interval
                FRIVL: u16,
                padding: u16,
            }),
            ///  OTG_HS host frame number/frame time remaining register
            HFNUM: mmio.Mmio(packed struct(u32) {
                ///  Frame number
                FRNUM: u16,
                ///  Frame time remaining
                FTREM: u16,
            }),
            reserved16: [4]u8,
            ///  Host periodic transmit FIFO/queue status register
            HPTXSTS: mmio.Mmio(packed struct(u32) {
                ///  Periodic transmit data FIFO space available
                PTXFSAVL: u16,
                ///  Periodic transmit request queue space available
                PTXQSAV: u8,
                ///  Top of the periodic transmit request queue
                PTXQTOP: u8,
            }),
            ///  OTG_HS Host all channels interrupt register
            HAINT: mmio.Mmio(packed struct(u32) {
                ///  Channel interrupts
                HAINT: u16,
                padding: u16,
            }),
            ///  OTG_HS host all channels interrupt mask register
            HAINTMSK: mmio.Mmio(packed struct(u32) {
                ///  Channel interrupt mask
                HAINTM: u16,
                padding: u16,
            }),
            reserved64: [36]u8,
            ///  OTG_HS host port control and status register
            HPRT: mmio.Mmio(packed struct(u32) {
                ///  Port connect status
                PCSTS: u1,
                ///  Port connect detected
                PCDET: u1,
                ///  Port enable
                PENA: u1,
                ///  Port enable/disable change
                PENCHNG: u1,
                ///  Port overcurrent active
                POCA: u1,
                ///  Port overcurrent change
                POCCHNG: u1,
                ///  Port resume
                PRES: u1,
                ///  Port suspend
                PSUSP: u1,
                ///  Port reset
                PRST: u1,
                reserved10: u1,
                ///  Port line status
                PLSTS: u2,
                ///  Port power
                PPWR: u1,
                ///  Port test control
                PTCTL: u4,
                ///  Port speed
                PSPD: u2,
                padding: u13,
            }),
        };

        ///  USB on the go high speed
        pub const USB_OTG_GLOBAL = extern struct {
            ///  OTG_HS control and status register
            GOTGCTL: mmio.Mmio(packed struct(u32) {
                ///  Session request success
                SRQSCS: u1,
                ///  Session request
                SRQ: u1,
                reserved8: u6,
                ///  Host negotiation success
                HNGSCS: u1,
                ///  HNP request
                HNPRQ: u1,
                ///  Host set HNP enable
                HSHNPEN: u1,
                ///  Device HNP enabled
                DHNPEN: u1,
                reserved16: u4,
                ///  Connector ID status
                CIDSTS: u1,
                ///  Long/short debounce time
                DBCT: u1,
                ///  A-session valid
                ASVLD: u1,
                ///  B-session valid
                BSVLD: u1,
                padding: u12,
            }),
            ///  OTG_HS interrupt register
            GOTGINT: mmio.Mmio(packed struct(u32) {
                reserved2: u2,
                ///  Session end detected
                SEDET: u1,
                reserved8: u5,
                ///  Session request success status change
                SRSSCHG: u1,
                ///  Host negotiation success status change
                HNSSCHG: u1,
                reserved17: u7,
                ///  Host negotiation detected
                HNGDET: u1,
                ///  A-device timeout change
                ADTOCHG: u1,
                ///  Debounce done
                DBCDNE: u1,
                padding: u12,
            }),
            ///  OTG_HS AHB configuration register
            GAHBCFG: mmio.Mmio(packed struct(u32) {
                ///  Global interrupt mask
                GINT: u1,
                ///  Maximum AXI burst length
                AXI_BURST: packed union {
                    raw: u2,
                    value: enum(u2) {
                        @"4" = 0x0,
                        @"3" = 0x1,
                        @"2" = 0x2,
                        @"1" = 0x3,
                    },
                },
                reserved4: u1,
                ///  Wait for all AXI writes before signaling DMA
                AXI_WAIT: u1,
                ///  DMA enable
                DMAEN: u1,
                reserved7: u1,
                ///  TxFIFO empty level
                TXFELVL: u1,
                ///  Periodic TxFIFO empty level
                PTXFELVL: u1,
                padding: u23,
            }),
            ///  OTG_HS USB configuration register
            GUSBCFG: mmio.Mmio(packed struct(u32) {
                ///  FS timeout calibration
                TOCAL: u3,
                ///  PHY Interface width
                PHYIF: packed union {
                    raw: u1,
                    value: enum(u1) {
                        @"8BIT" = 0x0,
                        @"16BIT" = 0x1,
                    },
                },
                ///  PHY Type
                PHYTYPE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        UTMI = 0x0,
                        ULPI = 0x1,
                    },
                },
                ///  Full speed interface
                FSIF: packed union {
                    raw: u1,
                    value: enum(u1) {
                        @"6PIN" = 0x0,
                        @"3PIN" = 0x1,
                    },
                },
                ///  Transceiver select
                PHYSEL: packed union {
                    raw: u1,
                    value: enum(u1) {
                        USB20 = 0x0,
                        USB11 = 0x1,
                    },
                },
                ///  ULPI data rate
                DDRSEL: packed union {
                    raw: u1,
                    value: enum(u1) {
                        SINGLE = 0x0,
                        DOUBLE = 0x1,
                    },
                },
                ///  SRP-capable
                SRPCAP: u1,
                ///  HNP-capable
                HNPCAP: u1,
                ///  USB turnaround time
                TRDT: u4,
                reserved15: u1,
                ///  PHY Low-power clock select
                PHYLPCS: u1,
                reserved17: u1,
                ///  ULPI FS/LS select
                ULPIFSLS: u1,
                ///  ULPI Auto-resume
                ULPIAR: u1,
                ///  ULPI Clock SuspendM
                ULPICSM: u1,
                ///  ULPI External VBUS Drive
                ULPIEVBUSD: u1,
                ///  ULPI external VBUS indicator
                ULPIEVBUSI: u1,
                ///  TermSel DLine pulsing selection
                TSDPS: u1,
                ///  Indicator complement
                PCCI: u1,
                ///  Indicator pass through
                PTCI: u1,
                ///  ULPI interface protect disable
                ULPIIPD: u1,
                reserved29: u3,
                ///  Forced host mode
                FHMOD: u1,
                ///  Forced peripheral mode
                FDMOD: u1,
                ///  Corrupt Tx packet
                CTXPKT: u1,
            }),
            ///  OTG_HS reset register
            GRSTCTL: mmio.Mmio(packed struct(u32) {
                ///  Core soft reset
                CSRST: u1,
                ///  HCLK soft reset
                HSRST: u1,
                ///  Host frame counter reset
                FCRST: u1,
                reserved4: u1,
                ///  RxFIFO flush
                RXFFLSH: u1,
                ///  TxFIFO flush
                TXFFLSH: u1,
                ///  TxFIFO number
                TXFNUM: u5,
                reserved30: u19,
                ///  DMA request signal
                DMAREQ: u1,
                ///  AHB master idle
                AHBIDL: u1,
            }),
            ///  OTG_HS core interrupt register
            GINTSTS: mmio.Mmio(packed struct(u32) {
                ///  Current mode of operation
                CMOD: u1,
                ///  Mode mismatch interrupt
                MMIS: u1,
                ///  OTG interrupt
                OTGINT: u1,
                ///  Start of frame
                SOF: u1,
                ///  RxFIFO nonempty
                RXFLVL: u1,
                ///  Nonperiodic TxFIFO empty
                NPTXFE: u1,
                ///  Global IN nonperiodic NAK effective
                GINAKEFF: u1,
                ///  Global OUT NAK effective
                BOUTNAKEFF: u1,
                reserved10: u2,
                ///  Early suspend
                ESUSP: u1,
                ///  USB suspend
                USBSUSP: u1,
                ///  USB reset
                USBRST: u1,
                ///  Enumeration done
                ENUMDNE: u1,
                ///  Isochronous OUT packet dropped interrupt
                ISOODRP: u1,
                ///  End of periodic frame interrupt
                EOPF: u1,
                reserved18: u2,
                ///  IN endpoint interrupt
                IEPINT: u1,
                ///  OUT endpoint interrupt
                OEPINT: u1,
                ///  Incomplete isochronous IN transfer
                IISOIXFR: u1,
                ///  Incomplete periodic transfer
                PXFR_INCOMPISOOUT: u1,
                ///  Data fetch suspended
                DATAFSUSP: u1,
                reserved24: u1,
                ///  Host port interrupt
                HPRTINT: u1,
                ///  Host channels interrupt
                HCINT: u1,
                ///  Periodic TxFIFO empty
                PTXFE: u1,
                reserved28: u1,
                ///  Connector ID status change
                CIDSCHG: u1,
                ///  Disconnect detected interrupt
                DISCINT: u1,
                ///  Session request/new session detected interrupt
                SRQINT: u1,
                ///  Resume/remote wakeup detected interrupt
                WKUINT: u1,
            }),
            ///  OTG_HS interrupt mask register
            GINTMSK: mmio.Mmio(packed struct(u32) {
                reserved1: u1,
                ///  Mode mismatch interrupt mask
                MMISM: u1,
                ///  OTG interrupt mask
                OTGINT: u1,
                ///  Start of frame mask
                SOFM: u1,
                ///  Receive FIFO nonempty mask
                RXFLVLM: u1,
                ///  Nonperiodic TxFIFO empty mask
                NPTXFEM: u1,
                ///  Global nonperiodic IN NAK effective mask
                GINAKEFFM: u1,
                ///  Global OUT NAK effective mask
                GONAKEFFM: u1,
                reserved10: u2,
                ///  Early suspend mask
                ESUSPM: u1,
                ///  USB suspend mask
                USBSUSPM: u1,
                ///  USB reset mask
                USBRST: u1,
                ///  Enumeration done mask
                ENUMDNEM: u1,
                ///  Isochronous OUT packet dropped interrupt mask
                ISOODRPM: u1,
                ///  End of periodic frame interrupt mask
                EOPFM: u1,
                reserved17: u1,
                ///  Endpoint mismatch interrupt mask
                EPMISM: u1,
                ///  IN endpoints interrupt mask
                IEPINT: u1,
                ///  OUT endpoints interrupt mask
                OEPINT: u1,
                ///  Incomplete isochronous IN transfer mask
                IISOIXFRM: u1,
                ///  Incomplete periodic transfer mask
                PXFRM_IISOOXFRM: u1,
                ///  Data fetch suspended mask
                FSUSPM: u1,
                reserved24: u1,
                ///  Host port interrupt mask
                PRTIM: u1,
                ///  Host channels interrupt mask
                HCIM: u1,
                ///  Periodic TxFIFO empty mask
                PTXFEM: u1,
                reserved28: u1,
                ///  Connector ID status change mask
                CIDSCHGM: u1,
                ///  Disconnect detected interrupt mask
                DISCINT: u1,
                ///  Session request/new session detected interrupt mask
                SRQIM: u1,
                ///  Resume/remote wakeup detected interrupt mask
                WUIM: u1,
            }),
            ///  OTG_HS Receive status debug read register (host mode)
            GRXSTSR_Host: mmio.Mmio(packed struct(u32) {
                ///  Channel number
                CHNUM: u4,
                ///  Byte count
                BCNT: u11,
                ///  Data PID
                DPID: u2,
                ///  Packet status
                PKTSTS: u4,
                padding: u11,
            }),
            ///  OTG_HS status read and pop register (host mode)
            GRXSTSP_Host: mmio.Mmio(packed struct(u32) {
                ///  Channel number
                CHNUM: u4,
                ///  Byte count
                BCNT: u11,
                ///  Data PID
                DPID: u2,
                ///  Packet status
                PKTSTS: u4,
                padding: u11,
            }),
            ///  OTG_HS Receive FIFO size register
            GRXFSIZ: mmio.Mmio(packed struct(u32) {
                ///  RxFIFO depth
                RXFD: u16,
                padding: u16,
            }),
            ///  OTG_HS nonperiodic transmit FIFO size register (host mode)
            GNPTXFSIZ_Host: mmio.Mmio(packed struct(u32) {
                ///  Nonperiodic transmit RAM start address
                NPTXFSA: u16,
                ///  Nonperiodic TxFIFO depth
                NPTXFD: u16,
            }),
            ///  OTG_HS nonperiodic transmit FIFO/queue status register
            GNPTXSTS: mmio.Mmio(packed struct(u32) {
                ///  Nonperiodic TxFIFO space available
                NPTXFSAV: u16,
                ///  Nonperiodic transmit request queue space available
                NPTQXSAV: u8,
                ///  Top of the nonperiodic transmit request queue
                NPTXQTOP: u7,
                padding: u1,
            }),
            reserved56: [8]u8,
            ///  OTG_HS general core configuration register
            GCCFG: mmio.Mmio(packed struct(u32) {
                reserved16: u16,
                ///  Power down
                PWRDWN: u1,
                ///  Enable I2C bus connection for the external I2C PHY interface
                I2CPADEN: u1,
                ///  Enable the VBUS sensing device
                VBUSASEN: u1,
                ///  Enable the VBUS sensing device
                VBUSBSEN: u1,
                ///  SOF output enable
                SOFOUTEN: u1,
                ///  VBUS sensing disable option
                NOVBUSSENS: u1,
                padding: u10,
            }),
            ///  OTG_HS core ID register
            CID: mmio.Mmio(packed struct(u32) {
                ///  Product ID field
                PRODUCT_ID: u32,
            }),
            ///  OTG_HS vendor ID register
            VID: u32,
            ///  Direction
            HW_DIRECTION: mmio.Mmio(packed struct(u32) {
                ///  Direction %s
                DIRECTION: packed struct(u32) { u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2, u2 },
            }),
            ///  Hardware Config 0
            HW_CONFIG0: mmio.Mmio(packed struct(u32) {
                ///  Operating Mode
                OPERATING_MODE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        HNP_SRP_CAPABLE = 0x0,
                        SRP_ONLY_CAPABLE = 0x1,
                        NO_HNP_SRP_CAPABLE = 0x2,
                        SRP_CAPABLE_DEVICE = 0x3,
                        NO_SRP_CAPABLE_DEVICE = 0x4,
                        SRP_CAPABLE_HOST = 0x5,
                        NO_SRP_CAPABLE_HOST = 0x6,
                        _,
                    },
                },
                ///  Architecture
                ARCHITECTURE: packed union {
                    raw: u2,
                    value: enum(u2) {
                        SLAVE_ONLY = 0x0,
                        EXTERNAL_DMA = 0x1,
                        INTERNAL_DMA = 0x2,
                        _,
                    },
                },
                ///  Point to Point
                POINT_TO_POINT: u1,
                ///  High Speed Physical
                HIGH_SPEED_PHY: packed union {
                    raw: u2,
                    value: enum(u2) {
                        NOT_SUPPORTED = 0x0,
                        UTMI = 0x1,
                        ULPI = 0x2,
                        UTMI_ULPI = 0x3,
                    },
                },
                ///  Full Speed Physical
                FULL_SPEED_PHY: packed union {
                    raw: u2,
                    value: enum(u2) {
                        PHY0 = 0x0,
                        DEDICATED = 0x1,
                        PHY2 = 0x2,
                        PHY3 = 0x3,
                    },
                },
                ///  Device end point count
                DEVICE_END_POINT_COUNT: u4,
                ///  Host channel count
                HOST_CHANNEL_COUNT: u4,
                ///  Supports periodic endpoints
                SUPPORTS_PERIODIC_ENDPOINTS: u1,
                ///  Dynamic FIFO
                DYNAMIC_FIFO: u1,
                ///  Multi proc int
                MULTI_PROC_INT: u1,
                reserved22: u1,
                ///  Non periodic queue depth
                NON_PERIODIC_QUEUE_DEPTH: u2,
                ///  Host periodic queue depth
                HOST_PERIODIC_QUEUE_DEPTH: u2,
                ///  Device token queue depth
                DEVICE_TOKEN_QUEUE_DEPTH: u5,
                ///  Enable IC USB
                ENABLE_IC_USB: u1,
            }),
            reserved256: [180]u8,
            ///  OTG_HS Host periodic transmit FIFO size register
            HPTXFSIZ: mmio.Mmio(packed struct(u32) {
                ///  Host periodic TxFIFO start address
                PTXSA: u16,
                ///  Host periodic TxFIFO depth
                PTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF1: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF2: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            reserved284: [16]u8,
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF3: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF4: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF5: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF6: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
            ///  OTG_HS device IN endpoint transmit FIFO size register
            DIEPTXF7: mmio.Mmio(packed struct(u32) {
                ///  IN endpoint FIFOx transmit RAM start address
                INEPTXSA: u16,
                ///  IN endpoint TxFIFO depth
                INEPTXFD: u16,
            }),
        };

        ///  Broadcom SPI Controller
        pub const SPI0 = extern struct {
            ///  Control and Status
            CS: mmio.Mmio(packed struct(u32) {
                ///  Chip select
                CS: u2,
                ///  Clock phase
                CPHA: u1,
                ///  Clock polarity
                CPOL: u1,
                ///  Clear the FIFO(s)
                CLEAR: packed union {
                    raw: u2,
                    value: enum(u2) {
                        TX = 0x1,
                        RX = 0x2,
                        BOTH = 0x3,
                        _,
                    },
                },
                ///  Chip select polarity
                CSPOL: u1,
                ///  Transfer active
                TA: u1,
                ///  Enable DMA
                DMAEN: u1,
                ///  Interrupt on done
                INTD: u1,
                ///  Interrupt on RX
                INTR: u1,
                ///  Automatically deassert chip select
                ADCS: u1,
                ///  Read enable
                REN: u1,
                ///  LoSSI enable
                LEN: u1,
                LMONO: u1,
                TE_EN: u1,
                ///  Transfer is done
                DONE: u1,
                ///  RX FIFO contains data
                RXD: u1,
                ///  TX FIFO can accept data
                TXD: u1,
                ///  RX FIFO has data to be read
                RXR: u1,
                ///  RX FIFO full
                RXF: u1,
                ///  Chip select 0 polarity
                CSPOL0: u1,
                ///  Chip select 1 polarity
                CSPOL1: u1,
                ///  Chip select 2 polarity
                CSPOL2: u1,
                ///  Enable DMA in LoSSI mode
                DMA_LEN: u1,
                ///  Enable long data word in LoSSI mode
                LEN_LONG: u1,
                padding: u6,
            }),
            ///  FIFO access
            FIFO: mmio.Mmio(packed struct(u32) {
                ///  Data
                DATA: u32,
            }),
            ///  Clock divider
            CLK: mmio.Mmio(packed struct(u32) {
                ///  Clock divider
                CDIV: u16,
                padding: u16,
            }),
            ///  Data length
            DLEN: mmio.Mmio(packed struct(u32) {
                ///  Data length
                DLEN: u16,
                padding: u16,
            }),
            ///  LoSSI output hold delay
            LTOH: mmio.Mmio(packed struct(u32) {
                ///  Output hold delay
                TOH: u4,
                padding: u28,
            }),
            DC: mmio.Mmio(packed struct(u32) {
                ///  DMA Write request threshold
                TDREQ: u8,
                ///  DMA write panic threshold
                TPANIC: u8,
                ///  DMA read request threshold
                RDREQ: u8,
                ///  DMA read panic threshold
                RPANIC: u8,
            }),
        };

        ///  ARM GIC-400 Generic Interrupt Controller CPU Interface
        pub const GIC_CPU = extern struct {
            ///  CPU Interface Control
            GICC_CTLR: mmio.Mmio(packed struct(u32) {
                ///  Enable signaling of group 0
                ENABLE_GROUP_0: u1,
                ///  Enable signaling of group 1
                ENABLE_GROUP_1: u1,
                ///  Whether a read of IAR acknowledges the interrupt
                ACKCTL: u1,
                ///  Group 0 triggers FIQ
                FIQEN: u1,
                ///  Common control of interrupts through GICC_BPR
                CBPR: u1,
                ///  Bypass FIQ is not signaled to processor
                FIQBYPDISGRP0: u1,
                ///  Bypass IRQ is not signaled to processor
                IRQBYPDISGRP0: u1,
                ///  Alias of group 1 FIQ bypass disable
                FIQBYPDISGRP1: u1,
                ///  Alias of group 1 IRQ bypass disable
                IRQBYPDISGRP1: u1,
                ///  Secure EOIR does priority drop. DIR does deactivate.
                EOIMODES: u1,
                ///  Non-Secure EOIR does priority drop. DIR does deactivate.
                EOIMODENS: u1,
                padding: u21,
            }),
            ///  Interrupt Priority Mask
            GICC_PMR: mmio.Mmio(packed struct(u32) {
                ///  Interrupts with a higher number are not signaled
                PRIORITY: u8,
                padding: u24,
            }),
            ///  Binary Point
            GICC_BPR: mmio.Mmio(packed struct(u32) {
                ///  Split point between group priority and subpriority
                BINARY_POINT: u3,
                padding: u29,
            }),
            ///  Interrupt Acknowledge
            GICC_IAR: mmio.Mmio(packed struct(u32) {
                ///  Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            ///  End of Interrupt
            GICC_EOIR: mmio.Mmio(packed struct(u32) {
                ///  Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            ///  Running Priority
            GICC_RPR: mmio.Mmio(packed struct(u32) {
                ///  Current running priority
                PRIORITY: u8,
                padding: u24,
            }),
            ///  Highest Priority Pending Interrupt
            GICC_HPPIR: mmio.Mmio(packed struct(u32) {
                ///  Pending Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            ///  Aliased Binary Point
            GICC_ABPR: mmio.Mmio(packed struct(u32) {
                ///  Split point between group priority and subpriority
                BINARY_POINT: u3,
                padding: u29,
            }),
            ///  Aliased Interrupt Acknowledge
            GICC_AIAR: mmio.Mmio(packed struct(u32) {
                ///  Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            ///  Aliased End of Interrupt
            GICC_AEOIR: mmio.Mmio(packed struct(u32) {
                ///  Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            ///  Aliased Highest Priority Pending Interrupt
            GICC_AHPPIR: mmio.Mmio(packed struct(u32) {
                ///  Pending Interrupt ID
                INTERRUPT_ID: u10,
                ///  CPUID that requested a software interrupt, 0 otherwise
                CPUID: u3,
                padding: u19,
            }),
            reserved208: [164]u8,
            ///  Active Priority
            GICC_APR0: u32,
            reserved224: [12]u8,
            ///  Non-Secure Active Priority
            GICC_NSAPR0: u32,
            reserved252: [24]u8,
            ///  CPU Interface Identification Register
            GICC_IIDR: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            reserved4096: [3840]u8,
            ///  Deactivate Interrupt
            GICC_DIR: u32,
        };

        ///  ARM GIC-400 Generic Interrupt Controller Distributor
        pub const GIC_DIST = extern struct {
            ///  Distributor Control Register
            GICD_CTLR: mmio.Mmio(packed struct(u32) {
                ///  Enable group 0 interrupts
                ENABLE_GROUP0: u1,
                ///  Enable group 1 interrupts
                ENABLE_GROUP1: u1,
                padding: u30,
            }),
            ///  Interrupt Controller Type Register
            GICD_TYPER: mmio.Mmio(packed struct(u32) {
                ///  Interrupt line number
                IT_LINES_NUMBER: u5,
                ///  CPU number
                CPU_NUMBER: u3,
                reserved10: u2,
                ///  Security extension implemented
                SECURITY_EXTENSION: u1,
                ///  Lockable SPI count
                LSPI: u4,
                padding: u17,
            }),
            ///  Distributor Implementer Identification Register
            GICD_IIDR: mmio.Mmio(packed struct(u32) {
                ///  Implementer
                IMPLEMENTER: u12,
                ///  Revision
                REVISION: u4,
                ///  Variant
                VARIANT: u4,
                reserved24: u4,
                ///  Product ID
                PRODUCT_ID: u8,
            }),
            reserved3328: [3316]u8,
            ///  Private Peripheral Interrupt Status Register
            GICD_PPISR: mmio.Mmio(packed struct(u32) {
                reserved9: u9,
                ///  Virtual maintenance interrupt
                ID25: u1,
                ///  Hypervisor timer event
                ID26: u1,
                ///  Virtual timer event
                ID27: u1,
                ///  nLEGACYFIQ signal
                ID28: u1,
                ///  Secure physical timer event
                ID29: u1,
                ///  Non-secure physical timer event
                ID30: u1,
                ///  nLEGACYIRQ signal
                ID31: u1,
                padding: u16,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR0: mmio.Mmio(packed struct(u32) {
                ///  Shared interrupt 32
                SPI32: u1,
                ///  Shared interrupt 33
                SPI33: u1,
                ///  Shared interrupt 34
                SPI34: u1,
                ///  Shared interrupt 35
                SPI35: u1,
                ///  Shared interrupt 36
                SPI36: u1,
                ///  Shared interrupt 37
                SPI37: u1,
                ///  Shared interrupt 38
                SPI38: u1,
                ///  Shared interrupt 39
                SPI39: u1,
                ///  Shared interrupt 40
                SPI40: u1,
                ///  Shared interrupt 41
                SPI41: u1,
                ///  Shared interrupt 42
                SPI42: u1,
                ///  Shared interrupt 43
                SPI43: u1,
                ///  Shared interrupt 44
                SPI44: u1,
                ///  Shared interrupt 45
                SPI45: u1,
                ///  Shared interrupt 46
                SPI46: u1,
                ///  Shared interrupt 47
                SPI47: u1,
                ///  Shared interrupt 48
                SPI48: u1,
                ///  Shared interrupt 49
                SPI49: u1,
                ///  Shared interrupt 50
                SPI50: u1,
                ///  Shared interrupt 51
                SPI51: u1,
                ///  Shared interrupt 52
                SPI52: u1,
                ///  Shared interrupt 53
                SPI53: u1,
                ///  Shared interrupt 54
                SPI54: u1,
                ///  Shared interrupt 55
                SPI55: u1,
                ///  Shared interrupt 56
                SPI56: u1,
                ///  Shared interrupt 57
                SPI57: u1,
                ///  Shared interrupt 58
                SPI58: u1,
                ///  Shared interrupt 59
                SPI59: u1,
                ///  Shared interrupt 60
                SPI60: u1,
                ///  Shared interrupt 61
                SPI61: u1,
                ///  Shared interrupt 62
                SPI62: u1,
                ///  Shared interrupt 63
                SPI63: u1,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR1: mmio.Mmio(packed struct(u32) {
                ///  ARMC Timer
                TIMER: u1,
                ///  Mailbox
                MAILBOX: u1,
                ///  Doorbell 0
                DOORBELL0: u1,
                ///  Doorbell 1
                DOORBELL1: u1,
                ///  VPU0 halted
                VPU0_HALTED: u1,
                ///  VPU1 halted
                VPU1_HALTED: u1,
                ///  ARM address error
                ARM_ADDRESS_ERROR: u1,
                ///  ARM AXI error
                ARM_AXI_ERROR: u1,
                ///  Software interrupt 0
                SWI0: u1,
                ///  Software interrupt 1
                SWI1: u1,
                ///  Software interrupt 2
                SWI2: u1,
                ///  Software interrupt 3
                SWI3: u1,
                ///  Software interrupt 4
                SWI4: u1,
                ///  Software interrupt 5
                SWI5: u1,
                ///  Software interrupt 6
                SWI6: u1,
                ///  Software interrupt 7
                SWI7: u1,
                ///  Shared interrupt 80
                SPI80: u1,
                ///  Shared interrupt 81
                SPI81: u1,
                ///  Shared interrupt 82
                SPI82: u1,
                ///  Shared interrupt 83
                SPI83: u1,
                ///  Shared interrupt 84
                SPI84: u1,
                ///  Shared interrupt 85
                SPI85: u1,
                ///  Shared interrupt 86
                SPI86: u1,
                ///  Shared interrupt 87
                SPI87: u1,
                ///  Shared interrupt 88
                SPI88: u1,
                ///  Shared interrupt 89
                SPI89: u1,
                ///  Shared interrupt 90
                SPI90: u1,
                ///  Shared interrupt 91
                SPI91: u1,
                ///  Shared interrupt 92
                SPI92: u1,
                ///  Shared interrupt 93
                SPI93: u1,
                ///  Shared interrupt 94
                SPI94: u1,
                ///  Shared interrupt 95
                SPI95: u1,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR2: mmio.Mmio(packed struct(u32) {
                ///  Timer 0
                TIMER_0: u1,
                ///  Timer 1
                TIMER_1: u1,
                ///  Timer 2
                TIMER_2: u1,
                ///  Timer 3
                TIMER_3: u1,
                ///  H264 0
                H264_0: u1,
                ///  H264 1
                H264_1: u1,
                ///  H264 2
                H264_2: u1,
                ///  JPEG
                JPEG: u1,
                ///  ISP
                ISP: u1,
                ///  USB
                USB: u1,
                ///  V3D
                V3D: u1,
                ///  Transposer
                TRANSPOSER: u1,
                ///  Multicore Sync 0
                MULTICORE_SYNC_0: u1,
                ///  Multicore Sync 1
                MULTICORE_SYNC_1: u1,
                ///  Multicore Sync 2
                MULTICORE_SYNC_2: u1,
                ///  Multicore Sync 3
                MULTICORE_SYNC_3: u1,
                ///  DMA 0
                DMA_0: u1,
                ///  DMA 1
                DMA_1: u1,
                ///  DMA 2
                DMA_2: u1,
                ///  DMA 3
                DMA_3: u1,
                ///  DMA 4
                DMA_4: u1,
                ///  DMA 5
                DMA_5: u1,
                ///  DMA 6
                DMA_6: u1,
                ///  OR of DMA 7 and 8
                DMA_7_8: u1,
                ///  OR of DMA 9 and 10
                DMA_9_10: u1,
                ///  DMA 11
                DMA_11: u1,
                ///  DMA 12
                DMA_12: u1,
                ///  DMA 13
                DMA_13: u1,
                ///  DMA 14
                DMA_14: u1,
                ///  OR of UART1, SPI1 and SPI2
                AUX: u1,
                ///  ARM
                ARM: u1,
                ///  DMA 15
                DMA_15: u1,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR3: mmio.Mmio(packed struct(u32) {
                ///  HDMI CEC
                HDMI_CEC: u1,
                ///  HVS
                HVS: u1,
                ///  RPIVID
                RPIVID: u1,
                ///  SDC
                SDC: u1,
                ///  DSI 0
                DSI_0: u1,
                ///  Pixel Valve 2
                PIXEL_VALVE_2: u1,
                ///  Camera 0
                CAMERA_0: u1,
                ///  Camera 1
                CAMERA_1: u1,
                ///  HDMI 0
                HDMI_0: u1,
                ///  HDMI 1
                HDMI_1: u1,
                ///  Pixel Valve 3
                PIXEL_VALVE_3: u1,
                ///  SPI/BSC Slave
                SPI_BSC_SLAVE: u1,
                ///  DSI 1
                DSI_1: u1,
                ///  Pixel Valve 0
                PIXEL_VALVE_0: u1,
                ///  OR of Pixel Valve 1 and 2
                PIXEL_VALVE_1_2: u1,
                ///  CPR
                CPR: u1,
                ///  SMI
                SMI: u1,
                ///  GPIO 0
                GPIO_0: u1,
                ///  GPIO 1
                GPIO_1: u1,
                ///  GPIO 2
                GPIO_2: u1,
                ///  GPIO 3
                GPIO_3: u1,
                ///  OR of all I2C
                I2C: u1,
                ///  OR of all SPI
                SPI: u1,
                ///  PCM/I2S
                PCM_I2S: u1,
                ///  SDHOST
                SDHOST: u1,
                ///  OR of all PL011 UARTs
                UART: u1,
                ///  OR of all ETH_PCIe L2
                ETH_PCIE: u1,
                ///  VEC
                VEC: u1,
                ///  CPG
                CPG: u1,
                ///  RNG
                RNG: u1,
                ///  OR of EMMC and EMMC2
                EMMC: u1,
                ///  ETH_PCIe secure
                ETH_PCIE_SECURE: u1,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR4: mmio.Mmio(packed struct(u32) {
                ///  Shared interrupt 160
                SPI160: u1,
                ///  Shared interrupt 161
                SPI161: u1,
                ///  Shared interrupt 162
                SPI162: u1,
                ///  Shared interrupt 163
                SPI163: u1,
                ///  Shared interrupt 164
                SPI164: u1,
                ///  Shared interrupt 165
                SPI165: u1,
                ///  Shared interrupt 166
                SPI166: u1,
                ///  Shared interrupt 167
                SPI167: u1,
                ///  Shared interrupt 168
                SPI168: u1,
                ///  Shared interrupt 169
                SPI169: u1,
                ///  Shared interrupt 170
                SPI170: u1,
                ///  Shared interrupt 171
                SPI171: u1,
                ///  Shared interrupt 172
                SPI172: u1,
                ///  Shared interrupt 173
                SPI173: u1,
                ///  Shared interrupt 174
                SPI174: u1,
                ///  Shared interrupt 175
                SPI175: u1,
                ///  Shared interrupt 176
                SPI176: u1,
                ///  Shared interrupt 177
                SPI177: u1,
                ///  Shared interrupt 178
                SPI178: u1,
                ///  Shared interrupt 179
                SPI179: u1,
                ///  Shared interrupt 180
                SPI180: u1,
                ///  Shared interrupt 181
                SPI181: u1,
                ///  Shared interrupt 182
                SPI182: u1,
                ///  Shared interrupt 183
                SPI183: u1,
                ///  Shared interrupt 184
                SPI184: u1,
                ///  Shared interrupt 185
                SPI185: u1,
                ///  Shared interrupt 186
                SPI186: u1,
                ///  Shared interrupt 187
                SPI187: u1,
                ///  Shared interrupt 188
                SPI188: u1,
                ///  Shared interrupt 189
                SPI189: u1,
                ///  Shared interrupt 190
                SPI190: u1,
                ///  Shared interrupt 191
                SPI191: u1,
            }),
            ///  Shared Peripheral Interrupt Status Registers
            GICD_SPISR5: mmio.Mmio(packed struct(u32) {
                ///  Shared interrupt 192
                SPI192: u1,
                ///  Shared interrupt 193
                SPI193: u1,
                ///  Shared interrupt 194
                SPI194: u1,
                ///  Shared interrupt 195
                SPI195: u1,
                ///  Shared interrupt 196
                SPI196: u1,
                ///  Shared interrupt 197
                SPI197: u1,
                ///  Shared interrupt 198
                SPI198: u1,
                ///  Shared interrupt 199
                SPI199: u1,
                ///  Shared interrupt 200
                SPI200: u1,
                ///  Shared interrupt 201
                SPI201: u1,
                ///  Shared interrupt 202
                SPI202: u1,
                ///  Shared interrupt 203
                SPI203: u1,
                ///  Shared interrupt 204
                SPI204: u1,
                ///  Shared interrupt 205
                SPI205: u1,
                ///  Shared interrupt 206
                SPI206: u1,
                ///  Shared interrupt 207
                SPI207: u1,
                ///  Shared interrupt 208
                SPI208: u1,
                ///  Shared interrupt 209
                SPI209: u1,
                ///  Shared interrupt 210
                SPI210: u1,
                ///  Shared interrupt 211
                SPI211: u1,
                ///  Shared interrupt 212
                SPI212: u1,
                ///  Shared interrupt 213
                SPI213: u1,
                ///  Shared interrupt 214
                SPI214: u1,
                ///  Shared interrupt 215
                SPI215: u1,
                ///  Shared interrupt 216
                SPI216: u1,
                ///  Shared interrupt 217
                SPI217: u1,
                ///  Shared interrupt 218
                SPI218: u1,
                ///  Shared interrupt 219
                SPI219: u1,
                ///  Shared interrupt 220
                SPI220: u1,
                ///  Shared interrupt 221
                SPI221: u1,
                ///  Shared interrupt 222
                SPI222: u1,
                ///  Shared interrupt 223
                SPI223: u1,
            }),
            reserved3840: [484]u8,
            ///  Software Generated Interrupt Register
            GICD_SGIR: u32,
            reserved3856: [12]u8,
            ///  SGI Clear-Pending Registers
            GICD_CPENDSGIRn: u32,
            reserved3872: [12]u8,
            ///  SGI Set-Pending Registers
            GICD_SPENDSGIRn: u32,
            reserved4048: [172]u8,
            ///  Peripheral ID 4
            GICD_PIDR4: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 5
            GICD_PIDR5: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 6
            GICD_PIDR6: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 7
            GICD_PIDR7: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 0
            GICD_PIDR0: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 1
            GICD_PIDR1: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 2
            GICD_PIDR2: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Peripheral ID 3
            GICD_PIDR3: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Component ID 0
            GICD_CIDR0: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Component ID 1
            GICD_CIDR1: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Component ID 2
            GICD_CIDR2: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
            ///  Component ID 3
            GICD_CIDR3: mmio.Mmio(packed struct(u32) {
                padding: u32,
            }),
        };

        ///  Broadcom Legacy Interrupt Controller
        pub const LIC = extern struct {
            reserved512: [512]u8,
            ///  Basic pending info
            BASIC_PENDING: mmio.Mmio(packed struct(u32) {
                ///  ARMC Timer
                TIMER: u1,
                ///  Mailbox
                MAILBOX: u1,
                ///  Doorbell 0
                DOORBELL0: u1,
                ///  Doorbell 1
                DOORBELL1: u1,
                ///  VPU0 halted
                VPU0_HALTED: u1,
                ///  VPU1 halted
                VPU1_HALTED: u1,
                ///  ARM address error
                ARM_ADDRESS_ERROR: u1,
                ///  ARM AXI error
                ARM_AXI_ERROR: u1,
                ///  One or more bits are set in PENDING_1 (ignores 7, 9, 10, 18, 19)
                PENDING_1: u1,
                ///  One or more bits are set in PENDING_2 (ignores 53 - 57, 62)
                PENDING_2: u1,
                ///  Interrupt 7
                INT7: u1,
                ///  Interrupt 9
                INT9: u1,
                ///  Interrupt 10
                INT10: u1,
                ///  Interrupt 18
                INT18: u1,
                ///  Interrupt 19
                INT19: u1,
                ///  Interrupt 53
                INT53: u1,
                ///  Interrupt 54
                INT54: u1,
                ///  Interrupt 55
                INT55: u1,
                ///  Interrupt 56
                INT56: u1,
                ///  Interrupt 57
                INT57: u1,
                ///  Interrupt 62
                INT62: u1,
                padding: u11,
            }),
            ///  Pending state for interrupts 1 - 31
            PENDING_1: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 0
                INT0: u1,
                ///  Interrupt 1
                INT1: u1,
                ///  Interrupt 2
                INT2: u1,
                ///  Interrupt 3
                INT3: u1,
                ///  Interrupt 4
                INT4: u1,
                ///  Interrupt 5
                INT5: u1,
                ///  Interrupt 6
                INT6: u1,
                ///  Interrupt 7
                INT7: u1,
                ///  Interrupt 8
                INT8: u1,
                ///  Interrupt 9
                INT9: u1,
                ///  Interrupt 10
                INT10: u1,
                ///  Interrupt 11
                INT11: u1,
                ///  Interrupt 12
                INT12: u1,
                ///  Interrupt 13
                INT13: u1,
                ///  Interrupt 14
                INT14: u1,
                ///  Interrupt 15
                INT15: u1,
                ///  Interrupt 16
                INT16: u1,
                ///  Interrupt 17
                INT17: u1,
                ///  Interrupt 18
                INT18: u1,
                ///  Interrupt 19
                INT19: u1,
                ///  Interrupt 20
                INT20: u1,
                ///  Interrupt 21
                INT21: u1,
                ///  Interrupt 22
                INT22: u1,
                ///  Interrupt 23
                INT23: u1,
                ///  Interrupt 24
                INT24: u1,
                ///  Interrupt 25
                INT25: u1,
                ///  Interrupt 26
                INT26: u1,
                ///  Interrupt 27
                INT27: u1,
                ///  Interrupt 28
                INT28: u1,
                ///  Interrupt 29
                INT29: u1,
                ///  Interrupt 30
                INT30: u1,
                ///  Interrupt 31
                INT31: u1,
            }),
            ///  Pending state for interrupts 32 - 63
            PENDING_2: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 32
                INT32: u1,
                ///  Interrupt 33
                INT33: u1,
                ///  Interrupt 34
                INT34: u1,
                ///  Interrupt 35
                INT35: u1,
                ///  Interrupt 36
                INT36: u1,
                ///  Interrupt 37
                INT37: u1,
                ///  Interrupt 38
                INT38: u1,
                ///  Interrupt 39
                INT39: u1,
                ///  Interrupt 40
                INT40: u1,
                ///  Interrupt 41
                INT41: u1,
                ///  Interrupt 42
                INT42: u1,
                ///  Interrupt 43
                INT43: u1,
                ///  Interrupt 44
                INT44: u1,
                ///  Interrupt 45
                INT45: u1,
                ///  Interrupt 46
                INT46: u1,
                ///  Interrupt 47
                INT47: u1,
                ///  Interrupt 48
                INT48: u1,
                ///  Interrupt 49
                INT49: u1,
                ///  Interrupt 50
                INT50: u1,
                ///  Interrupt 51
                INT51: u1,
                ///  Interrupt 52
                INT52: u1,
                ///  Interrupt 53
                INT53: u1,
                ///  Interrupt 54
                INT54: u1,
                ///  Interrupt 55
                INT55: u1,
                ///  Interrupt 56
                INT56: u1,
                ///  Interrupt 57
                INT57: u1,
                ///  Interrupt 58
                INT58: u1,
                ///  Interrupt 59
                INT59: u1,
                ///  Interrupt 60
                INT60: u1,
                ///  Interrupt 61
                INT61: u1,
                ///  Interrupt 62
                INT62: u1,
                ///  Interrupt 63
                INT63: u1,
            }),
            ///  FIQ control
            FIQ_CONTROL: mmio.Mmio(packed struct(u32) {
                ///  FIQ Source
                SOURCE: packed union {
                    raw: u7,
                    value: enum(u7) {
                        ///  Interrupt 0
                        INT0 = 0x0,
                        ///  Interrupt 1
                        INT1 = 0x1,
                        ///  Interrupt 2
                        INT2 = 0x2,
                        ///  Interrupt 3
                        INT3 = 0x3,
                        ///  Interrupt 4
                        INT4 = 0x4,
                        ///  Interrupt 5
                        INT5 = 0x5,
                        ///  Interrupt 6
                        INT6 = 0x6,
                        ///  Interrupt 7
                        INT7 = 0x7,
                        ///  Interrupt 8
                        INT8 = 0x8,
                        ///  Interrupt 9
                        INT9 = 0x9,
                        ///  Interrupt 10
                        INT10 = 0xa,
                        ///  Interrupt 11
                        INT11 = 0xb,
                        ///  Interrupt 12
                        INT12 = 0xc,
                        ///  Interrupt 13
                        INT13 = 0xd,
                        ///  Interrupt 14
                        INT14 = 0xe,
                        ///  Interrupt 15
                        INT15 = 0xf,
                        ///  Interrupt 16
                        INT16 = 0x10,
                        ///  Interrupt 17
                        INT17 = 0x11,
                        ///  Interrupt 18
                        INT18 = 0x12,
                        ///  Interrupt 19
                        INT19 = 0x13,
                        ///  Interrupt 20
                        INT20 = 0x14,
                        ///  Interrupt 21
                        INT21 = 0x15,
                        ///  Interrupt 22
                        INT22 = 0x16,
                        ///  Interrupt 23
                        INT23 = 0x17,
                        ///  Interrupt 24
                        INT24 = 0x18,
                        ///  Interrupt 25
                        INT25 = 0x19,
                        ///  Interrupt 26
                        INT26 = 0x1a,
                        ///  Interrupt 27
                        INT27 = 0x1b,
                        ///  Interrupt 28
                        INT28 = 0x1c,
                        ///  Interrupt 29
                        INT29 = 0x1d,
                        ///  Interrupt 30
                        INT30 = 0x1e,
                        ///  Interrupt 31
                        INT31 = 0x1f,
                        ///  Interrupt 32
                        INT32 = 0x20,
                        ///  Interrupt 33
                        INT33 = 0x21,
                        ///  Interrupt 34
                        INT34 = 0x22,
                        ///  Interrupt 35
                        INT35 = 0x23,
                        ///  Interrupt 36
                        INT36 = 0x24,
                        ///  Interrupt 37
                        INT37 = 0x25,
                        ///  Interrupt 38
                        INT38 = 0x26,
                        ///  Interrupt 39
                        INT39 = 0x27,
                        ///  Interrupt 40
                        INT40 = 0x28,
                        ///  Interrupt 41
                        INT41 = 0x29,
                        ///  Interrupt 42
                        INT42 = 0x2a,
                        ///  Interrupt 43
                        INT43 = 0x2b,
                        ///  Interrupt 44
                        INT44 = 0x2c,
                        ///  Interrupt 45
                        INT45 = 0x2d,
                        ///  Interrupt 46
                        INT46 = 0x2e,
                        ///  Interrupt 47
                        INT47 = 0x2f,
                        ///  Interrupt 48
                        INT48 = 0x30,
                        ///  Interrupt 49
                        INT49 = 0x31,
                        ///  Interrupt 50
                        INT50 = 0x32,
                        ///  Interrupt 51
                        INT51 = 0x33,
                        ///  Interrupt 52
                        INT52 = 0x34,
                        ///  Interrupt 53
                        INT53 = 0x35,
                        ///  Interrupt 54
                        INT54 = 0x36,
                        ///  Interrupt 55
                        INT55 = 0x37,
                        ///  Interrupt 56
                        INT56 = 0x38,
                        ///  Interrupt 57
                        INT57 = 0x39,
                        ///  Interrupt 58
                        INT58 = 0x3a,
                        ///  Interrupt 59
                        INT59 = 0x3b,
                        ///  Interrupt 60
                        INT60 = 0x3c,
                        ///  Interrupt 61
                        INT61 = 0x3d,
                        ///  Interrupt 62
                        INT62 = 0x3e,
                        ///  Interrupt 63
                        INT63 = 0x3f,
                        ///  ARMC Timer
                        TIMER = 0x40,
                        ///  Mailbox
                        MAILBOX = 0x41,
                        ///  Doorbell 0
                        DOORBELL0 = 0x42,
                        ///  Doorbell 1
                        DOORBELL1 = 0x43,
                        ///  VPU0 halted
                        VPU0_HALTED = 0x44,
                        ///  VPU1 halted
                        VPU1_HALTED = 0x45,
                        ///  ARM address error
                        ARM_ADDRESS_ERROR = 0x46,
                        ///  ARM AXI error
                        ARM_AXI_ERROR = 0x47,
                        _,
                    },
                },
                ///  FIQ Enable
                ENABLE: u1,
                padding: u24,
            }),
            ///  Enable interrupts 1 - 31
            ENABLE_1: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 0
                INT0: u1,
                ///  Interrupt 1
                INT1: u1,
                ///  Interrupt 2
                INT2: u1,
                ///  Interrupt 3
                INT3: u1,
                ///  Interrupt 4
                INT4: u1,
                ///  Interrupt 5
                INT5: u1,
                ///  Interrupt 6
                INT6: u1,
                ///  Interrupt 7
                INT7: u1,
                ///  Interrupt 8
                INT8: u1,
                ///  Interrupt 9
                INT9: u1,
                ///  Interrupt 10
                INT10: u1,
                ///  Interrupt 11
                INT11: u1,
                ///  Interrupt 12
                INT12: u1,
                ///  Interrupt 13
                INT13: u1,
                ///  Interrupt 14
                INT14: u1,
                ///  Interrupt 15
                INT15: u1,
                ///  Interrupt 16
                INT16: u1,
                ///  Interrupt 17
                INT17: u1,
                ///  Interrupt 18
                INT18: u1,
                ///  Interrupt 19
                INT19: u1,
                ///  Interrupt 20
                INT20: u1,
                ///  Interrupt 21
                INT21: u1,
                ///  Interrupt 22
                INT22: u1,
                ///  Interrupt 23
                INT23: u1,
                ///  Interrupt 24
                INT24: u1,
                ///  Interrupt 25
                INT25: u1,
                ///  Interrupt 26
                INT26: u1,
                ///  Interrupt 27
                INT27: u1,
                ///  Interrupt 28
                INT28: u1,
                ///  Interrupt 29
                INT29: u1,
                ///  Interrupt 30
                INT30: u1,
                ///  Interrupt 31
                INT31: u1,
            }),
            ///  Enable interrupts 32 - 63
            ENABLE_2: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 32
                INT32: u1,
                ///  Interrupt 33
                INT33: u1,
                ///  Interrupt 34
                INT34: u1,
                ///  Interrupt 35
                INT35: u1,
                ///  Interrupt 36
                INT36: u1,
                ///  Interrupt 37
                INT37: u1,
                ///  Interrupt 38
                INT38: u1,
                ///  Interrupt 39
                INT39: u1,
                ///  Interrupt 40
                INT40: u1,
                ///  Interrupt 41
                INT41: u1,
                ///  Interrupt 42
                INT42: u1,
                ///  Interrupt 43
                INT43: u1,
                ///  Interrupt 44
                INT44: u1,
                ///  Interrupt 45
                INT45: u1,
                ///  Interrupt 46
                INT46: u1,
                ///  Interrupt 47
                INT47: u1,
                ///  Interrupt 48
                INT48: u1,
                ///  Interrupt 49
                INT49: u1,
                ///  Interrupt 50
                INT50: u1,
                ///  Interrupt 51
                INT51: u1,
                ///  Interrupt 52
                INT52: u1,
                ///  Interrupt 53
                INT53: u1,
                ///  Interrupt 54
                INT54: u1,
                ///  Interrupt 55
                INT55: u1,
                ///  Interrupt 56
                INT56: u1,
                ///  Interrupt 57
                INT57: u1,
                ///  Interrupt 58
                INT58: u1,
                ///  Interrupt 59
                INT59: u1,
                ///  Interrupt 60
                INT60: u1,
                ///  Interrupt 61
                INT61: u1,
                ///  Interrupt 62
                INT62: u1,
                ///  Interrupt 63
                INT63: u1,
            }),
            ///  Enable basic interrupts
            ENABLE_BASIC: mmio.Mmio(packed struct(u32) {
                ///  ARMC Timer
                TIMER: u1,
                ///  Mailbox
                MAILBOX: u1,
                ///  Doorbell 0
                DOORBELL0: u1,
                ///  Doorbell 1
                DOORBELL1: u1,
                ///  VPU0 halted
                VPU0_HALTED: u1,
                ///  VPU1 halted
                VPU1_HALTED: u1,
                ///  ARM address error
                ARM_ADDRESS_ERROR: u1,
                ///  ARM AXI error
                ARM_AXI_ERROR: u1,
                padding: u24,
            }),
            ///  Disable interrupts 1 - 31
            DISABLE_1: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 0
                INT0: u1,
                ///  Interrupt 1
                INT1: u1,
                ///  Interrupt 2
                INT2: u1,
                ///  Interrupt 3
                INT3: u1,
                ///  Interrupt 4
                INT4: u1,
                ///  Interrupt 5
                INT5: u1,
                ///  Interrupt 6
                INT6: u1,
                ///  Interrupt 7
                INT7: u1,
                ///  Interrupt 8
                INT8: u1,
                ///  Interrupt 9
                INT9: u1,
                ///  Interrupt 10
                INT10: u1,
                ///  Interrupt 11
                INT11: u1,
                ///  Interrupt 12
                INT12: u1,
                ///  Interrupt 13
                INT13: u1,
                ///  Interrupt 14
                INT14: u1,
                ///  Interrupt 15
                INT15: u1,
                ///  Interrupt 16
                INT16: u1,
                ///  Interrupt 17
                INT17: u1,
                ///  Interrupt 18
                INT18: u1,
                ///  Interrupt 19
                INT19: u1,
                ///  Interrupt 20
                INT20: u1,
                ///  Interrupt 21
                INT21: u1,
                ///  Interrupt 22
                INT22: u1,
                ///  Interrupt 23
                INT23: u1,
                ///  Interrupt 24
                INT24: u1,
                ///  Interrupt 25
                INT25: u1,
                ///  Interrupt 26
                INT26: u1,
                ///  Interrupt 27
                INT27: u1,
                ///  Interrupt 28
                INT28: u1,
                ///  Interrupt 29
                INT29: u1,
                ///  Interrupt 30
                INT30: u1,
                ///  Interrupt 31
                INT31: u1,
            }),
            ///  Disable interrupts 32 - 63
            DISABLE_2: mmio.Mmio(packed struct(u32) {
                ///  Interrupt 32
                INT32: u1,
                ///  Interrupt 33
                INT33: u1,
                ///  Interrupt 34
                INT34: u1,
                ///  Interrupt 35
                INT35: u1,
                ///  Interrupt 36
                INT36: u1,
                ///  Interrupt 37
                INT37: u1,
                ///  Interrupt 38
                INT38: u1,
                ///  Interrupt 39
                INT39: u1,
                ///  Interrupt 40
                INT40: u1,
                ///  Interrupt 41
                INT41: u1,
                ///  Interrupt 42
                INT42: u1,
                ///  Interrupt 43
                INT43: u1,
                ///  Interrupt 44
                INT44: u1,
                ///  Interrupt 45
                INT45: u1,
                ///  Interrupt 46
                INT46: u1,
                ///  Interrupt 47
                INT47: u1,
                ///  Interrupt 48
                INT48: u1,
                ///  Interrupt 49
                INT49: u1,
                ///  Interrupt 50
                INT50: u1,
                ///  Interrupt 51
                INT51: u1,
                ///  Interrupt 52
                INT52: u1,
                ///  Interrupt 53
                INT53: u1,
                ///  Interrupt 54
                INT54: u1,
                ///  Interrupt 55
                INT55: u1,
                ///  Interrupt 56
                INT56: u1,
                ///  Interrupt 57
                INT57: u1,
                ///  Interrupt 58
                INT58: u1,
                ///  Interrupt 59
                INT59: u1,
                ///  Interrupt 60
                INT60: u1,
                ///  Interrupt 61
                INT61: u1,
                ///  Interrupt 62
                INT62: u1,
                ///  Interrupt 63
                INT63: u1,
            }),
            ///  Disable basic interrupts
            DISABLE_BASIC: mmio.Mmio(packed struct(u32) {
                ///  ARMC Timer
                TIMER: u1,
                ///  Mailbox
                MAILBOX: u1,
                ///  Doorbell 0
                DOORBELL0: u1,
                ///  Doorbell 1
                DOORBELL1: u1,
                ///  VPU0 halted
                VPU0_HALTED: u1,
                ///  VPU1 halted
                VPU1_HALTED: u1,
                ///  ARM address error
                ARM_ADDRESS_ERROR: u1,
                ///  ARM AXI error
                ARM_AXI_ERROR: u1,
                padding: u24,
            }),
        };

        ///  Broadcom PWM
        pub const PWM0 = extern struct {
            ///  Control
            CTL: mmio.Mmio(packed struct(u32) {
                ///  Enable channel 1
                PWEN1: u1,
                ///  Channel 1 mode
                MODE1: packed union {
                    raw: u1,
                    value: enum(u1) {
                        PWM = 0x0,
                        SERIAL = 0x1,
                    },
                },
                ///  Repeat last value from FIFO for channel 1
                RPTL1: u1,
                ///  State when not transmitting on channel 1
                SBIT1: u1,
                ///  Channel 1 polarity inverted
                POLA1: u1,
                ///  Use FIFO for channel 1
                USEF1: u1,
                ///  Clear FIFO
                CLRF1: u1,
                ///  M/S mode for channel 1
                MSEN1: u1,
                ///  Enable channel 2
                PWEN2: u1,
                ///  Channel 2 mode
                MODE2: packed union {
                    raw: u1,
                    value: enum(u1) {
                        PWM = 0x0,
                        SERIAL = 0x1,
                    },
                },
                ///  Repeat last value from FIFO for channel 2
                RPTL2: u1,
                ///  State when not transmitting on channel 2
                SBIT2: u1,
                ///  Channel 2 polarity inverted
                POLA2: u1,
                ///  Use FIFO for channel 2
                USEF2: u1,
                reserved15: u1,
                ///  M/S mode for channel 2
                MSEN2: u1,
                padding: u16,
            }),
            ///  Status
            STA: mmio.Mmio(packed struct(u32) {
                ///  FIFO full
                FULL1: u1,
                ///  FIFO empty
                EMPT1: u1,
                ///  FIFO write error
                WERR1: u1,
                ///  FIFO read error
                RERR1: u1,
                ///  Channel 1 gap occurred
                GAPO1: u1,
                ///  Channel 2 gap occurred
                GAPO2: u1,
                ///  Channel 3 gap occurred
                GAPO3: u1,
                ///  Channel 4 gap occurred
                GAPO4: u1,
                ///  Bus error
                BERR: u1,
                ///  Channel 1 state
                STA1: u1,
                ///  Channel 2 state
                STA2: u1,
                ///  Channel 3 state
                STA3: u1,
                ///  Channel 4 state
                STA4: u1,
                padding: u19,
            }),
            ///  DMA control
            DMAC: mmio.Mmio(packed struct(u32) {
                ///  DMA threshold for DREQ signal
                DREQ: u8,
                ///  DMA threshold for panic signal
                PANIC: u8,
                reserved31: u15,
                ///  DMA enabled
                ENAB: u1,
            }),
            reserved16: [4]u8,
            ///  Range for channel 1
            RNG1: u32,
            ///  Channel 1 data
            DAT1: u32,
            ///  FIFO input
            FIF1: u32,
            reserved32: [4]u8,
            ///  Range for channel 2
            RNG2: u32,
            ///  Channel 2 data
            DAT2: u32,
        };

        ///  Interrupt status of new peripherals
        pub const PACTL = extern struct {
            ///  Interrupt status
            CS: mmio.Mmio(packed struct(u32) {
                ///  SPI0 interrupt active
                SPI_0: u1,
                ///  SPI1 interrupt active
                SPI_1: u1,
                ///  SPI2 interrupt active
                SPI_2: u1,
                ///  SPI3 interrupt active
                SPI_3: u1,
                ///  SPI4 interrupt active
                SPI_4: u1,
                ///  SPI5 interrupt active
                SPI_5: u1,
                ///  SPI6 interrupt active
                SPI_6: u1,
                reserved8: u1,
                ///  I2C0 interrupt active
                I2C_0: u1,
                ///  I2C1 interrupt active
                I2C_1: u1,
                ///  I2C2 interrupt active
                I2C_2: u1,
                ///  I2C3 interrupt active
                I2C_3: u1,
                ///  I2C4 interrupt active
                I2C_4: u1,
                ///  I2C5 interrupt active
                I2C_5: u1,
                ///  I2C6 interrupt active
                I2C_6: u1,
                ///  I2C7 interrupt active
                I2C_7: u1,
                ///  UART5 interrupt active
                UART_5: u1,
                ///  UART4 interrupt active
                UART_4: u1,
                ///  UART3 interrupt active
                UART_3: u1,
                ///  UART2 interrupt active
                UART_2: u1,
                ///  UART0 interrupt active
                UART_0: u1,
                padding: u11,
            }),
        };

        ///  Broadcom Serial Controller (I2C compatible)
        pub const BSC0 = extern struct {
            ///  Control
            C: mmio.Mmio(packed struct(u32) {
                ///  Transfer is read
                READ: u1,
                reserved4: u3,
                ///  Clear the FIFO
                CLEAR: u2,
                reserved7: u1,
                ///  Start transfer
                ST: u1,
                ///  Interrupt on done
                INTD: u1,
                ///  Interrupt on TX
                INTT: u1,
                ///  Interrupt on RX
                INTR: u1,
                reserved15: u4,
                ///  I2C Enable
                I2CEN: u1,
                padding: u16,
            }),
            ///  Status
            S: mmio.Mmio(packed struct(u32) {
                ///  Transfer active
                TA: u1,
                ///  Transfer done
                DONE: u1,
                ///  FIFO needs to be written
                TXW: u1,
                ///  FIFO needs to be read
                RXR: u1,
                ///  FIFO has space for at least one byte
                TXD: u1,
                ///  FIFO contains at least one byte
                RXD: u1,
                ///  FIFO is empty. Nothing to transmit
                TXE: u1,
                ///  FIFO is full. Can't receive anything else
                RXF: u1,
                ///  Error: No ack
                ERR: u1,
                ///  Clock stretch timeout
                CLKT: u1,
                padding: u22,
            }),
            ///  Data length
            DLEN: mmio.Mmio(packed struct(u32) {
                ///  Data length
                DLEN: u16,
                padding: u16,
            }),
            ///  Slave address
            A: mmio.Mmio(packed struct(u32) {
                ///  Slave address
                ADDR: u7,
                padding: u25,
            }),
            ///  Data FIFO
            FIFO: mmio.Mmio(packed struct(u32) {
                ///  Access the FIFO
                DATA: u8,
                padding: u24,
            }),
            ///  Clock divider
            DIV: mmio.Mmio(packed struct(u32) {
                ///  Divide the source clock
                CDIV: u16,
                padding: u16,
            }),
            ///  Data delay (Values must be under CDIV / 2)
            DEL: mmio.Mmio(packed struct(u32) {
                ///  Delay before reading after a rising edge
                REDL: u16,
                ///  Delay before reading after a falling edge
                FEDL: u16,
            }),
            ///  Clock stretch timeout (broken on 283x)
            CLKT: mmio.Mmio(packed struct(u32) {
                ///  Number of SCL clock cycles to wait
                TOUT: u16,
                padding: u16,
            }),
        };

        ///  Aux SPI
        pub const SPI1 = extern struct {
            ///  Control 0
            CNTL0: mmio.Mmio(packed struct(u32) {
                ///  Number of bits to shift
                SHIFT_LENGTH: u6,
                ///  Shift out the most significant bit (MSB) first
                MSB_FIRST: u1,
                ///  Idle clock high
                INVERT_CLK: u1,
                ///  Data is clocked out on rising edge of CLK
                OUT_RISING: u1,
                ///  Clear FIFOs
                CLEAR_FIFOS: u1,
                ///  Data is clocked in on rising edge of CLK
                IN_RISING: u1,
                ///  Enable the interface
                ENABLE: u1,
                ///  Controls extra DOUT hold time in system clock cycles
                DOUT_HOLD_TIME: packed union {
                    raw: u2,
                    value: enum(u2) {
                        @"0" = 0x0,
                        @"1" = 0x1,
                        @"4" = 0x2,
                        @"7" = 0x3,
                    },
                },
                ///  Take shift length and data from FIFO
                VARIABLE_WIDTH: u1,
                ///  Take CS pattern and data from TX FIFO (along with VARIABLE_WIDTH)
                VARIABLE_CS: u1,
                ///  Post input mode
                POST_INPUT: u1,
                ///  The CS pattern when active
                CHIP_SELECTS: u3,
                ///  SPI clock speed. clk = sys / 2 * (SPEED + 1)
                SPEED: u12,
            }),
            ///  Control 1
            CNTL1: mmio.Mmio(packed struct(u32) {
                ///  Don't clear the RX shift register before a new transaction
                KEEP_INPUT: u1,
                ///  Shift the most significant bit first (MSB)
                MSB_FIRST: u1,
                reserved6: u4,
                ///  Enable DONE interrupt
                DONE_ENABLE: u1,
                ///  Enable TX empty interrupt
                TXE_ENABLE: u1,
                ///  Additional SPI clock cycles where CS is high
                CS_HIGH_TIME: u3,
                padding: u21,
            }),
            ///  Status
            STAT: mmio.Mmio(packed struct(u32) {
                ///  Number of bits left to be processed.
                BIT_COUNT: u6,
                ///  Indicates a transfer is ongoing
                BUSY: u1,
                ///  RX FIFO is empty
                RX_EMPTY: u1,
                ///  RX FIFO is full
                RX_FULL: u1,
                ///  TX FIFO is empty
                TX_EMPTY: u1,
                ///  TX FIFO is full
                TX_FULL: u1,
                reserved16: u5,
                ///  Number of entries in RX FIFO
                RX_LEVEL: u4,
                reserved24: u4,
                ///  Number of entries in TX FIFO
                TX_LEVEL: u4,
                padding: u4,
            }),
            ///  Read the RXFIFO without removing an entry
            PEEK: mmio.Mmio(packed struct(u32) {
                ///  FIFO data access
                DATA: u16,
                padding: u16,
            }),
            ///  Writing to the FIFO will deassert CS at the end of the access
            IO: [4]mmio.Mmio(packed struct(u32) {
                ///  FIFO data access
                DATA: u16,
                padding: u16,
            }),
            ///  Writing to the FIFO will maintain CS at the end of the access
            TXHOLD: [4]mmio.Mmio(packed struct(u32) {
                ///  FIFO data access
                DATA: u16,
                padding: u16,
            }),
        };

        ///  Three auxiliary peripherals
        pub const AUX = extern struct {
            ///  Interrupt status
            IRQ: mmio.Mmio(packed struct(u32) {
                ///  UART1 interrupt active
                UART_1: u1,
                ///  SPI1 interrupt active
                SPI_1: u1,
                ///  SPI2 interrupt active
                SPI_2: u1,
                padding: u29,
            }),
            ///  Enable sub-peripherals
            ENABLES: mmio.Mmio(packed struct(u32) {
                ///  UART1 enabled
                UART_1: u1,
                ///  SPI1 enabled
                SPI_1: u1,
                ///  SPI2 enabled
                SPI_2: u1,
                padding: u29,
            }),
        };
    };
};
