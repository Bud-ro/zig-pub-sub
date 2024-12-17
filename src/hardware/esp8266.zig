const micro = @import("microzig");
const mmio = micro.mmio;

pub const properties = struct {
    pub const @"cpu.endian" = "little";
    pub const @"cpu.mpuPresent" = "false";
    pub const @"cpu.revision" = "1";
    pub const @"cpu.name" = "Xtensa LX106";
    pub const @"cpu.nvicPrioBits" = "3";
    pub const @"cpu.vendorSystickConfig" = "false";
    pub const @"cpu.fpuPresent" = "true";
};

pub const peripherals = struct {
    pub const DPORT: *volatile types.peripherals.DPORT = @ptrFromInt(0x3ff00000);
    pub const EFUSE: *volatile types.peripherals.EFUSE = @ptrFromInt(0x3ff00050);
    ///  RNG register
    pub const RNG: *volatile types.peripherals.RNG = @ptrFromInt(0x3ff20e44);
    pub const UART0: *volatile types.peripherals.UART0 = @ptrFromInt(0x60000000);
    pub const SPI1: *volatile types.peripherals.SPI1 = @ptrFromInt(0x60000100);
    pub const SPI0: *volatile types.peripherals.SPI0 = @ptrFromInt(0x60000200);
    pub const GPIO: *volatile types.peripherals.GPIO = @ptrFromInt(0x60000300);
    pub const TIMER: *volatile types.peripherals.TIMER = @ptrFromInt(0x60000600);
    pub const RTC: *volatile types.peripherals.RTC = @ptrFromInt(0x60000700);
    pub const IO_MUX: *volatile types.peripherals.IO_MUX = @ptrFromInt(0x60000800);
    pub const WDT: *volatile types.peripherals.WDT = @ptrFromInt(0x60000900);
    ///  Watchdog registers
    pub const WATCHDOG: *volatile types.peripherals.WATCHDOG = @ptrFromInt(0x60000900);
    pub const SLC: *volatile types.peripherals.SLC = @ptrFromInt(0x60000b00);
    pub const I2S: *volatile types.peripherals.I2S = @ptrFromInt(0x60000e00);
    pub const UART1: *volatile types.peripherals.UART1 = @ptrFromInt(0x60000f00);
};

pub const types = struct {
    pub const peripherals = struct {
        pub const DPORT = extern struct {
            reserved4: [4]u8,
            ///  EDGE_INT_ENABLE
            EDGE_INT_ENABLE: mmio.Mmio(packed struct(u32) {
                ///  Enable the watchdog timer edge interrupt
                wdt_edge_int_enable: u1,
                ///  Enable the timer1 edge interrupt
                timer1_edge_int_enable: u1,
                padding: u30,
            }),
            reserved20: [12]u8,
            ///  DPORT_CTL
            DPORT_CTL: mmio.Mmio(packed struct(u32) {
                DPORT_CTL_DOUBLE_CLK: u1,
                padding: u31,
            }),
        };

        pub const EFUSE = extern struct {
            ///  EFUSE_DATA0
            EFUSE_DATA0: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  EFUSE_DATA1
            EFUSE_DATA1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  EFUSE_DATA2
            EFUSE_DATA2: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  EFUSE_DATA3
            EFUSE_DATA3: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
        };

        pub const GPIO = extern struct {
            ///  BT-Coexist Selection register
            GPIO_OUT: mmio.Mmio(packed struct(u32) {
                ///  The output value when the GPIO pin is set as output.
                GPIO_OUT_DATA: u16,
                ///  BT-Coexist Selection register
                GPIO_BT_SEL: u16,
            }),
            ///  GPIO_OUT_W1TS
            GPIO_OUT_W1TS: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will set the related bit in GPIO_OUT_DATA
                GPIO_OUT_DATA_W1TS: u16,
                padding: u16,
            }),
            ///  GPIO_OUT_W1TC
            GPIO_OUT_W1TC: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will clear the related bit in GPIO_OUT_DATA
                GPIO_OUT_DATA_W1TC: u16,
                padding: u16,
            }),
            ///  GPIO_ENABLE
            GPIO_ENABLE: mmio.Mmio(packed struct(u32) {
                ///  The output enable register.
                GPIO_ENABLE_DATA: u16,
                ///  SDIO-dis selection register
                GPIO_SDIO_SEL: u6,
                padding: u10,
            }),
            ///  GPIO_ENABLE_W1TS
            GPIO_ENABLE_W1TS: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will set the related bit in GPIO_ENABLE_DATA
                GPIO_ENABLE_DATA_W1TS: u16,
                padding: u16,
            }),
            ///  GPIO_ENABLE_W1TC
            GPIO_ENABLE_W1TC: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will clear the related bit in GPIO_ENABLE_DATA
                GPIO_ENABLE_DATA_W1TC: u16,
                padding: u16,
            }),
            ///  The values of the strapping pins.
            GPIO_IN: mmio.Mmio(packed struct(u32) {
                ///  The values of the GPIO pins when the GPIO pin is set as input.
                GPIO_IN_DATA: u16,
                ///  The values of the strapping pins.
                GPIO_STRAPPING: u16,
            }),
            ///  GPIO_STATUS
            GPIO_STATUS: mmio.Mmio(packed struct(u32) {
                ///  Interrupt enable register.
                GPIO_STATUS_INTERRUPT: u16,
                padding: u16,
            }),
            ///  GPIO_STATUS_W1TS
            GPIO_STATUS_W1TS: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will set the related bit in GPIO_STATUS_INTERRUPT
                GPIO_STATUS_INTERRUPT_W1TS: u16,
                padding: u16,
            }),
            ///  GPIO_STATUS_W1TC
            GPIO_STATUS_W1TC: mmio.Mmio(packed struct(u32) {
                ///  Writing 1 into a bit in this register will clear the related bit in GPIO_STATUS_INTERRUPT
                GPIO_STATUS_INTERRUPT_W1TC: u16,
                padding: u16,
            }),
            ///  GPIO_PIN0
            GPIO_PIN0: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN0_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN0_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN0_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN0_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN1
            GPIO_PIN1: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN1_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN1_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN1_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN1_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN2
            GPIO_PIN2: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN2_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN2_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN2_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN2_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN3
            GPIO_PIN3: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN3_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN3_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN3_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN3_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN4
            GPIO_PIN4: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN4_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN4_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN4_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN4_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN5
            GPIO_PIN5: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN5_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN5_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN5_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN5_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN6
            GPIO_PIN6: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN6_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN6_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN6_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN6_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN7
            GPIO_PIN7: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN7_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN7_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN7_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN7_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN8
            GPIO_PIN8: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN8_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN8_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN8_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN8_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN9
            GPIO_PIN9: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN9_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN9_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN9_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN9_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN10
            GPIO_PIN10: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN10_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN10_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN10_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN10_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN11
            GPIO_PIN11: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN11_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN11_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN11_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN11_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN12
            GPIO_PIN12: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN12_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN12_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN12_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN12_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN13
            GPIO_PIN13: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN13_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN13_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN13_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN13_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN14
            GPIO_PIN14: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN14_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN14_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN14_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN14_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_PIN15
            GPIO_PIN15: mmio.Mmio(packed struct(u32) {
                ///  1: sigma-delta; 0: GPIO_DATA
                GPIO_PIN15_SOURCE: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  sigma-delta
                        sigma_delta = 0x0,
                        ///  gpio data
                        gpio_data = 0x1,
                    },
                },
                reserved2: u1,
                ///  1: open drain; 0: normal
                GPIO_PIN15_DRIVER: packed union {
                    raw: u1,
                    value: enum(u1) {
                        ///  open drain
                        open_drain = 0x0,
                        ///  normal
                        normal = 0x1,
                    },
                },
                reserved7: u4,
                ///  0: disable; 1: positive edge; 2: negative edge; 3: both types of edge; 4: low-level; 5: high-level
                GPIO_PIN15_INT_TYPE: packed union {
                    raw: u3,
                    value: enum(u3) {
                        ///  interrupt is disabled
                        disabled = 0x0,
                        ///  interrupt is triggered on the positive edge
                        positive_edge = 0x1,
                        ///  interrupt is triggered on the negative edge
                        negative_edge = 0x2,
                        ///  interrupt is triggered on both edges
                        both_edges = 0x3,
                        ///  interrupt is triggered on the low level
                        low_level = 0x4,
                        ///  interrupt is triggered on the high level
                        high_level = 0x5,
                        _,
                    },
                },
                ///  0: disable; 1: enable GPIO wakeup CPU, only when GPIO_PIN0_INT_TYPE is 0x4 or 0x5
                GPIO_PIN15_WAKEUP_ENABLE: u1,
                padding: u21,
            }),
            ///  GPIO_SIGMA_DELTA
            GPIO_SIGMA_DELTA: mmio.Mmio(packed struct(u32) {
                ///  target level of the sigma-delta. It is a signed byte.
                SIGMA_DELTA_TARGET: u8,
                ///  Clock pre-divider for sigma-delta.
                SIGMA_DELTA_PRESCALAR: u8,
                ///  1: enable sigma-delta; 0: disable
                SIGMA_DELTA_ENABLE: u1,
                padding: u15,
            }),
            ///  Positvie edge of this bit will trigger the RTC-clock-calibration process.
            GPIO_RTC_CALIB_SYNC: mmio.Mmio(packed struct(u32) {
                ///  The cycle number of RTC-clock during RTC-clock-calibration
                RTC_PERIOD_NUM: u10,
                reserved31: u21,
                ///  Positvie edge of this bit will trigger the RTC-clock-calibration process.
                RTC_CALIB_START: u1,
            }),
            ///  0: during RTC-clock-calibration; 1: RTC-clock-calibration is done
            GPIO_RTC_CALIB_VALUE: mmio.Mmio(packed struct(u32) {
                ///  The cycle number of clk_xtal (crystal clock) for the RTC_PERIOD_NUM cycles of RTC-clock
                RTC_CALIB_VALUE: u20,
                reserved30: u10,
                ///  0: during RTC-clock-calibration; 1: RTC-clock-calibration is done
                RTC_CALIB_RDY_REAL: u1,
                ///  0: during RTC-clock-calibration; 1: RTC-clock-calibration is done
                RTC_CALIB_RDY: u1,
            }),
        };

        pub const I2S = extern struct {
            ///  I2STXFIFO
            I2STXFIFO: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  I2SRXFIFO
            I2SRXFIFO: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  I2SCONF
            I2SCONF: mmio.Mmio(packed struct(u32) {
                I2S_I2S_TX_RESET: u1,
                I2S_I2S_RX_RESET: u1,
                I2S_I2S_TX_FIFO_RESET: u1,
                I2S_I2S_RX_FIFO_RESET: u1,
                I2S_TRANS_SLAVE_MOD: u1,
                I2S_RECE_SLAVE_MOD: u1,
                I2S_RIGHT_FIRST: u1,
                I2S_MSB_RIGHT: u1,
                I2S_I2S_TX_START: u1,
                I2S_I2S_RX_START: u1,
                I2S_TRANS_MSB_SHIFT: u1,
                I2S_RECE_MSB_SHIFT: u1,
                I2S_BITS_MOD: u4,
                I2S_CLKM_DIV_NUM: u6,
                I2S_BCK_DIV_NUM: u6,
                padding: u4,
            }),
            ///  I2SINT_RAW
            I2SINT_RAW: mmio.Mmio(packed struct(u32) {
                I2S_I2S_RX_TAKE_DATA_INT_RAW: u1,
                I2S_I2S_TX_PUT_DATA_INT_RAW: u1,
                I2S_I2S_RX_WFULL_INT_RAW: u1,
                I2S_I2S_RX_REMPTY_INT_RAW: u1,
                I2S_I2S_TX_WFULL_INT_RAW: u1,
                I2S_I2S_TX_REMPTY_INT_RAW: u1,
                padding: u26,
            }),
            ///  I2SINT_ST
            I2SINT_ST: mmio.Mmio(packed struct(u32) {
                I2S_I2S_RX_TAKE_DATA_INT_ST: u1,
                I2S_I2S_TX_PUT_DATA_INT_ST: u1,
                I2S_I2S_RX_WFULL_INT_ST: u1,
                I2S_I2S_RX_REMPTY_INT_ST: u1,
                I2S_I2S_TX_WFULL_INT_ST: u1,
                I2S_I2S_TX_REMPTY_INT_ST: u1,
                padding: u26,
            }),
            ///  I2SINT_ENA
            I2SINT_ENA: mmio.Mmio(packed struct(u32) {
                I2S_I2S_RX_TAKE_DATA_INT_ENA: u1,
                I2S_I2S_TX_PUT_DATA_INT_ENA: u1,
                I2S_I2S_RX_WFULL_INT_ENA: u1,
                I2S_I2S_RX_REMPTY_INT_ENA: u1,
                I2S_I2S_TX_WFULL_INT_ENA: u1,
                I2S_I2S_TX_REMPTY_INT_ENA: u1,
                padding: u26,
            }),
            ///  I2SINT_CLR
            I2SINT_CLR: mmio.Mmio(packed struct(u32) {
                I2S_I2S_TAKE_DATA_INT_CLR: u1,
                I2S_I2S_PUT_DATA_INT_CLR: u1,
                I2S_I2S_RX_WFULL_INT_CLR: u1,
                I2S_I2S_RX_REMPTY_INT_CLR: u1,
                I2S_I2S_TX_WFULL_INT_CLR: u1,
                I2S_I2S_TX_REMPTY_INT_CLR: u1,
                padding: u26,
            }),
            ///  I2STIMING
            I2STIMING: mmio.Mmio(packed struct(u32) {
                I2S_TRANS_BCK_IN_DELAY: u2,
                I2S_TRANS_WS_IN_DELAY: u2,
                I2S_RECE_BCK_IN_DELAY: u2,
                I2S_RECE_WS_IN_DELAY: u2,
                I2S_RECE_SD_IN_DELAY: u2,
                I2S_TRANS_BCK_OUT_DELAY: u2,
                I2S_TRANS_WS_OUT_DELAY: u2,
                I2S_TRANS_SD_OUT_DELAY: u2,
                I2S_RECE_WS_OUT_DELAY: u2,
                I2S_RECE_BCK_OUT_DELAY: u2,
                I2S_TRANS_DSYNC_SW: u1,
                I2S_RECE_DSYNC_SW: u1,
                I2S_TRANS_BCK_IN_INV: u1,
                padding: u9,
            }),
            ///  I2S_FIFO_CONF
            I2S_FIFO_CONF: mmio.Mmio(packed struct(u32) {
                I2S_I2S_RX_DATA_NUM: u6,
                I2S_I2S_TX_DATA_NUM: u6,
                I2S_I2S_DSCR_EN: u1,
                I2S_I2S_TX_FIFO_MOD: u3,
                I2S_I2S_RX_FIFO_MOD: u3,
                padding: u13,
            }),
            ///  I2SRXEOF_NUM
            I2SRXEOF_NUM: mmio.Mmio(packed struct(u32) {
                I2S_I2S_RX_EOF_NUM: u32,
            }),
            ///  I2SCONF_SIGLE_DATA
            I2SCONF_SIGLE_DATA: mmio.Mmio(packed struct(u32) {
                I2S_I2S_SIGLE_DATA: u32,
            }),
        };

        pub const IO_MUX = extern struct {
            ///  IO_MUX_CONF
            IO_MUX_CONF: mmio.Mmio(packed struct(u32) {
                reserved8: u8,
                SPI0_CLK_EQU_SYS_CLK: u1,
                SPI1_CLK_EQU_SYS_CLK: u1,
                padding: u22,
            }),
            ///  IO_MUX_MTDI
            IO_MUX_MTDI: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_MTCK
            IO_MUX_MTCK: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_MTMS
            IO_MUX_MTMS: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_MTDO
            IO_MUX_MTDO: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_U0RXD
            IO_MUX_U0RXD: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_U0TXD
            IO_MUX_U0TXD: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_CLK
            IO_MUX_SD_CLK: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_DATA0
            IO_MUX_SD_DATA0: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_DATA1
            IO_MUX_SD_DATA1: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_DATA2
            IO_MUX_SD_DATA2: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_DATA3
            IO_MUX_SD_DATA3: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_SD_CMD
            IO_MUX_SD_CMD: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_GPIO0
            IO_MUX_GPIO0: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_GPIO2
            IO_MUX_GPIO2: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_GPIO4
            IO_MUX_GPIO4: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
            ///  IO_MUX_GPIO5
            IO_MUX_GPIO5: mmio.Mmio(packed struct(u32) {
                ///  configures output enable during sleep mode
                SLEEP_ENABLE: u1,
                reserved3: u2,
                ///  configures pull up during sleep mode
                SLEEP_PULLUP: u1,
                ///  configures IO_MUX function, bottom 2 bits
                FUNCTION_SELECT_LOW_BITS: u2,
                reserved7: u1,
                ///  configures pull up
                PULLUP: u1,
                ///  configures IO_MUX function, upper bit
                FUNCTION_SELECT_HIGH_BIT: u1,
                padding: u23,
            }),
        };

        pub const RTC = extern struct {
            reserved20: [20]u8,
            ///  RTC_STATE1
            RTC_STATE1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            reserved48: [24]u8,
            ///  RTC_STORE0
            RTC_STORE0: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
        };

        pub const SLC = extern struct {
            ///  SLC_CONF0
            SLC_CONF0: mmio.Mmio(packed struct(u32) {
                SLC_TXLINK_RST: u1,
                SLC_RXLINK_RST: u1,
                SLC_AHBM_FIFO_RST: u1,
                SLC_AHBM_RST: u1,
                SLC_TX_LOOP_TEST: u1,
                SLC_RX_LOOP_TEST: u1,
                SLC_RX_AUTO_WRBACK: u1,
                SLC_RX_NO_RESTART_CLR: u1,
                SLC_DSCR_BURST_EN: u1,
                SLC_DATA_BURST_EN: u1,
                reserved12: u2,
                SLC_MODE: u2,
                padding: u18,
            }),
            ///  SLC_INT_RAW
            SLC_INT_RAW: mmio.Mmio(packed struct(u32) {
                SLC_FRHOST_BIT0_INT_RAW: u1,
                SLC_FRHOST_BIT1_INT_RAW: u1,
                SLC_FRHOST_BIT2_INT_RAW: u1,
                SLC_FRHOST_BIT3_INT_RAW: u1,
                SLC_FRHOST_BIT4_INT_RAW: u1,
                SLC_FRHOST_BIT5_INT_RAW: u1,
                SLC_FRHOST_BIT6_INT_RAW: u1,
                SLC_FRHOST_BIT7_INT_RAW: u1,
                SLC_RX_START_INT_RAW: u1,
                SLC_TX_START_INT_RAW: u1,
                SLC_RX_UDF_INT_RAW: u1,
                SLC_TX_OVF_INT_RAW: u1,
                SLC_TOKEN0_1TO0_INT_RAW: u1,
                SLC_TOKEN1_1TO0_INT_RAW: u1,
                SLC_TX_DONE_INT_RAW: u1,
                SLC_TX_EOF_INT_RAW: u1,
                SLC_RX_DONE_INT_RAW: u1,
                SLC_RX_EOF_INT_RAW: u1,
                SLC_TOHOST_INT_RAW: u1,
                SLC_TX_DSCR_ERR_INT_RAW: u1,
                SLC_RX_DSCR_ERR_INT_RAW: u1,
                SLC_TX_DSCR_EMPTY_INT_RAW: u1,
                padding: u10,
            }),
            ///  SLC_INT_STATUS
            SLC_INT_STATUS: mmio.Mmio(packed struct(u32) {
                SLC_FRHOST_BIT0_INT_ST: u1,
                SLC_FRHOST_BIT1_INT_ST: u1,
                SLC_FRHOST_BIT2_INT_ST: u1,
                SLC_FRHOST_BIT3_INT_ST: u1,
                SLC_FRHOST_BIT4_INT_ST: u1,
                SLC_FRHOST_BIT5_INT_ST: u1,
                SLC_FRHOST_BIT6_INT_ST: u1,
                SLC_FRHOST_BIT7_INT_ST: u1,
                SLC_RX_START_INT_ST: u1,
                SLC_TX_START_INT_ST: u1,
                SLC_RX_UDF_INT_ST: u1,
                SLC_TX_OVF_INT_ST: u1,
                SLC_TOKEN0_1TO0_INT_ST: u1,
                SLC_TOKEN1_1TO0_INT_ST: u1,
                SLC_TX_DONE_INT_ST: u1,
                SLC_TX_EOF_INT_ST: u1,
                SLC_RX_DONE_INT_ST: u1,
                SLC_RX_EOF_INT_ST: u1,
                SLC_TOHOST_INT_ST: u1,
                SLC_TX_DSCR_ERR_INT_ST: u1,
                SLC_RX_DSCR_ERR_INT_ST: u1,
                SLC_TX_DSCR_EMPTY_INT_ST: u1,
                padding: u10,
            }),
            ///  SLC_INT_ENA
            SLC_INT_ENA: mmio.Mmio(packed struct(u32) {
                SLC_FRHOST_BIT0_INT_ENA: u1,
                SLC_FRHOST_BIT1_INT_ENA: u1,
                SLC_FRHOST_BIT2_INT_ENA: u1,
                SLC_FRHOST_BIT3_INT_ENA: u1,
                SLC_FRHOST_BIT4_INT_ENA: u1,
                SLC_FRHOST_BIT5_INT_ENA: u1,
                SLC_FRHOST_BIT6_INT_ENA: u1,
                SLC_FRHOST_BIT7_INT_ENA: u1,
                SLC_RX_START_INT_ENA: u1,
                SLC_TX_START_INT_ENA: u1,
                SLC_RX_UDF_INT_ENA: u1,
                SLC_TX_OVF_INT_ENA: u1,
                SLC_TOKEN0_1TO0_INT_ENA: u1,
                SLC_TOKEN1_1TO0_INT_ENA: u1,
                SLC_TX_DONE_INT_ENA: u1,
                SLC_TX_EOF_INT_ENA: u1,
                SLC_RX_DONE_INT_ENA: u1,
                SLC_RX_EOF_INT_ENA: u1,
                SLC_TOHOST_INT_ENA: u1,
                SLC_TX_DSCR_ERR_INT_ENA: u1,
                SLC_RX_DSCR_ERR_INT_ENA: u1,
                SLC_TX_DSCR_EMPTY_INT_ENA: u1,
                padding: u10,
            }),
            ///  SLC_INT_CLR
            SLC_INT_CLR: mmio.Mmio(packed struct(u32) {
                SLC_FRHOST_BIT0_INT_CLR: u1,
                SLC_FRHOST_BIT1_INT_CLR: u1,
                SLC_FRHOST_BIT2_INT_CLR: u1,
                SLC_FRHOST_BIT3_INT_CLR: u1,
                SLC_FRHOST_BIT4_INT_CLR: u1,
                SLC_FRHOST_BIT5_INT_CLR: u1,
                SLC_FRHOST_BIT6_INT_CLR: u1,
                SLC_FRHOST_BIT7_INT_CLR: u1,
                SLC_RX_START_INT_CLR: u1,
                SLC_TX_START_INT_CLR: u1,
                SLC_RX_UDF_INT_CLR: u1,
                SLC_TX_OVF_INT_CLR: u1,
                SLC_TOKEN0_1TO0_INT_CLR: u1,
                SLC_TOKEN1_1TO0_INT_CLR: u1,
                SLC_TX_DONE_INT_CLR: u1,
                SLC_TX_EOF_INT_CLR: u1,
                SLC_RX_DONE_INT_CLR: u1,
                SLC_RX_EOF_INT_CLR: u1,
                SLC_TOHOST_INT_CLR: u1,
                SLC_TX_DSCR_ERR_INT_CLR: u1,
                SLC_RX_DSCR_ERR_INT_CLR: u1,
                SLC_TX_DSCR_EMPTY_INT_CLR: u1,
                padding: u10,
            }),
            ///  SLC_RX_STATUS
            SLC_RX_STATUS: mmio.Mmio(packed struct(u32) {
                SLC_RX_FULL: u1,
                SLC_RX_EMPTY: u1,
                padding: u30,
            }),
            ///  SLC_RX_FIFO_PUSH
            SLC_RX_FIFO_PUSH: mmio.Mmio(packed struct(u32) {
                SLC_RXFIFO_WDATA: u9,
                reserved16: u7,
                SLC_RXFIFO_PUSH: u1,
                padding: u15,
            }),
            ///  SLC_TX_STATUS
            SLC_TX_STATUS: mmio.Mmio(packed struct(u32) {
                SLC_TX_FULL: u1,
                SLC_TX_EMPTY: u1,
                padding: u30,
            }),
            ///  SLC_TX_FIFO_POP
            SLC_TX_FIFO_POP: mmio.Mmio(packed struct(u32) {
                SLC_TXFIFO_RDATA: u11,
                reserved16: u5,
                SLC_TXFIFO_POP: u1,
                padding: u15,
            }),
            ///  SLC_RX_LINK
            SLC_RX_LINK: mmio.Mmio(packed struct(u32) {
                SLC_RXLINK_ADDR: u20,
                reserved28: u8,
                SLC_RXLINK_STOP: u1,
                SLC_RXLINK_START: u1,
                SLC_RXLINK_RESTART: u1,
                SLC_RXLINK_PARK: u1,
            }),
            ///  SLC_TX_LINK
            SLC_TX_LINK: mmio.Mmio(packed struct(u32) {
                SLC_TXLINK_ADDR: u20,
                reserved28: u8,
                SLC_TXLINK_STOP: u1,
                SLC_TXLINK_START: u1,
                SLC_TXLINK_RESTART: u1,
                SLC_TXLINK_PARK: u1,
            }),
            ///  SLC_INTVEC_TOHOST
            SLC_INTVEC_TOHOST: mmio.Mmio(packed struct(u32) {
                SLC_TOHOST_INTVEC: u8,
                padding: u24,
            }),
            ///  SLC_TOKEN0
            SLC_TOKEN0: mmio.Mmio(packed struct(u32) {
                SLC_TOKEN0_LOCAL_WDATA: u12,
                SLC_TOKEN0_LOCAL_WR: u1,
                SLC_TOKEN0_LOCAL_INC: u1,
                SLC_TOKEN0_LOCAL_INC_MORE: u1,
                reserved16: u1,
                SLC_TOKEN0: u12,
                padding: u4,
            }),
            ///  SLC_TOKEN1
            SLC_TOKEN1: mmio.Mmio(packed struct(u32) {
                SLC_TOKEN1_LOCAL_WDATA: u12,
                SLC_TOKEN1_LOCAL_WR: u1,
                SLC_TOKEN1_LOCAL_INC: u1,
                SLC_TOKEN1_LOCAL_INC_MORE: u1,
                reserved16: u1,
                SLC_TOKEN1: u12,
                padding: u4,
            }),
            ///  SLC_CONF1
            SLC_CONF1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_STATE0
            SLC_STATE0: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_STATE1
            SLC_STATE1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_BRIDGE_CONF
            SLC_BRIDGE_CONF: mmio.Mmio(packed struct(u32) {
                SLC_TXEOF_ENA: u6,
                reserved8: u2,
                SLC_FIFO_MAP_ENA: u4,
                SLC_TX_DUMMY_MODE: u1,
                reserved16: u3,
                SLC_TX_PUSH_IDLE_NUM: u16,
            }),
            ///  SLC_RX_EOF_DES_ADDR
            SLC_RX_EOF_DES_ADDR: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_TX_EOF_DES_ADDR
            SLC_TX_EOF_DES_ADDR: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_RX_EOF_BFR_DES_ADDR
            SLC_RX_EOF_BFR_DES_ADDR: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_AHB_TEST
            SLC_AHB_TEST: mmio.Mmio(packed struct(u32) {
                SLC_AHB_TESTMODE: u3,
                reserved4: u1,
                SLC_AHB_TESTADDR: u2,
                padding: u26,
            }),
            ///  SLC_SDIO_ST
            SLC_SDIO_ST: mmio.Mmio(packed struct(u32) {
                SLC_CMD_ST: u3,
                reserved4: u1,
                SLC_FUNC_ST: u4,
                SLC_SDIO_WAKEUP: u1,
                reserved12: u3,
                SLC_BUS_ST: u3,
                padding: u17,
            }),
            ///  SLC_RX_DSCR_CONF
            SLC_RX_DSCR_CONF: mmio.Mmio(packed struct(u32) {
                reserved8: u8,
                SLC_TOKEN_NO_REPLACE: u1,
                SLC_INFOR_NO_REPLACE: u1,
                padding: u22,
            }),
            ///  SLC_TXLINK_DSCR
            SLC_TXLINK_DSCR: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_TXLINK_DSCR_BF0
            SLC_TXLINK_DSCR_BF0: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_TXLINK_DSCR_BF1
            SLC_TXLINK_DSCR_BF1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_RXLINK_DSCR
            SLC_RXLINK_DSCR: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_RXLINK_DSCR_BF0
            SLC_RXLINK_DSCR_BF0: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_RXLINK_DSCR_BF1
            SLC_RXLINK_DSCR_BF1: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_DATE
            SLC_DATE: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  SLC_ID
            SLC_ID: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
        };

        pub const SPI0 = extern struct {
            ///  In the master mode, it is the start bit of a single operation. Self-clear by hardware
            SPI_CMD: mmio.Mmio(packed struct(u32) {
                reserved18: u18,
                ///  In the master mode, it is the start bit of a single operation. Self-clear by hardware
                spi_usr: u1,
                spi_hpm: u1,
                spi_res: u1,
                spi_dp: u1,
                spi_ce: u1,
                spi_be: u1,
                spi_se: u1,
                spi_pp: u1,
                spi_write_sr: u1,
                spi_read_sr: u1,
                spi_read_id: u1,
                spi_write_disable: u1,
                spi_write_enable: u1,
                spi_read: u1,
            }),
            ///  In the master mode, it is the value of address in "address" phase.
            SPI_ADDR: mmio.Mmio(packed struct(u32) {
                address: u24,
                size: u8,
            }),
            ///  SPI_CTRL
            SPI_CTRL: mmio.Mmio(packed struct(u32) {
                reserved13: u13,
                ///  this bit enable the bits: spi_qio_mode, spi_dio_mode, spi_qout_mode and spi_dout_mode
                spi_fastrd_mode: u1,
                ///  In the read operations, "read-data" phase apply 2 signals
                spi_dout_mode: u1,
                reserved20: u5,
                ///  In the read operations, "read-data" phase apply 4 signals
                spi_qout_mode: u1,
                reserved23: u2,
                ///  In the read operations, "address" phase and "read-data" phase apply 2 signals
                spi_dio_mode: u1,
                ///  In the read operations, "address" phase and "read-data" phase apply 4 signals
                spi_qio_mode: u1,
                ///  In "read-data" (MISO) phase, 1: LSB first; 0: MSB first
                spi_rd_bit_order: u1,
                ///  In "command", "address", "write-data" (MOSI) phases, 1: LSB first; 0: MSB first
                spi_wr_bit_order: u1,
                padding: u5,
            }),
            SPI_CTRL1: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the status for master to read out.
                status: u16,
                ///  Mode bits in the flash fast read mode, it is combined with spi_fastrd_mode bit.
                wb_mode: u8,
                ///  In the slave mode,it is the status for master to read out.
                status_ext: u8,
            }),
            ///  In the slave mode, this register are the status register for the master to read out.
            SPI_RD_STATUS: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, this register are the status register for the master to read out.
                slv_rd_status: u32,
            }),
            ///  spi_cs signal is delayed by 80MHz clock cycles
            SPI_CTRL2: mmio.Mmio(packed struct(u32) {
                reserved16: u16,
                ///  MISO signals are delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_miso_delay_mode: u2,
                ///  MISO signals are delayed by 80MHz clock cycles
                spi_miso_delay_num: u3,
                ///  MOSI signals are delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_mosi_delay_mode: u2,
                ///  MOSI signals are delayed by 80MHz clock cycles
                spi_mosi_delay_num: u3,
                ///  spi_cs signal is delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_cs_delay_mode: u2,
                ///  spi_cs signal is delayed by 80MHz clock cycles
                spi_cs_delay_num: u4,
            }),
            ///  In the master mode, 1: spi_clk is eqaul to 80MHz, 0: spi_clk is divided from 80 MHz clock.
            SPI_CLOCK: mmio.Mmio(packed struct(u32) {
                ///  In the master mode, it must be eqaul to spi_clkcnt_N. In the slave mode, it must be 0.
                spi_clkcnt_L: u6,
                ///  In the master mode, it must be floor((spi_clkcnt_N+1)/2-1). In the slave mode, it must be 0.
                spi_clkcnt_H: u6,
                ///  In the master mode, it is the divider of spi_clk. So spi_clk frequency is 80MHz/(spi_clkdiv_pre+1)/(spi_clkcnt_N+1)
                spi_clkcnt_N: u6,
                ///  In the master mode, it is pre-divider of spi_clk.
                spi_clkdiv_pre: u13,
                ///  In the master mode, 1: spi_clk is eqaul to 80MHz, 0: spi_clk is divided from 80 MHz clock.
                spi_clk_equ_sysclk: u1,
            }),
            ///  This bit enable the "command" phase of an operation.
            SPI_USER: mmio.Mmio(packed struct(u32) {
                ///  set spi in full duplex mode
                spi_duplex: u1,
                ///  reserved
                spi_ahb_user_command_4byte: u1,
                spi_flash_mode: u1,
                ///  reserved
                spi_ahb_user_command: u1,
                ///  spi cs keep low when spi is in done phase. 1: enable 0: disable.
                spi_cs_hold: u1,
                ///  spi cs is enable when spi is in prepare phase. 1: enable 0: disable.
                spi_cs_setup: u1,
                ///  In the slave mode, 1: rising-edge; 0: falling-edge
                spi_ck_i_edge: u1,
                ///  In the master mode, 1: rising-edge; 0: falling-edge
                spi_ck_o_edge: u1,
                reserved10: u2,
                ///  In "read-data" (MISO) phase, 1: little-endian; 0: big_endian
                spi_rd_byte_order: u1,
                ///  In "command", "address", "write-data" (MOSI) phases, 1: little-endian; 0: big_endian
                spi_wr_byte_order: u1,
                ///  In the write operations, "read-data" phase apply 2 signals
                spi_fwrite_dual: u1,
                ///  In the write operations, "read-data" phase apply 4 signals
                spi_fwrite_quad: u1,
                ///  In the write operations, "address" phase and "read-data" phase apply 2 signals
                spi_fwrite_dio: u1,
                ///  In the write operations, "address" phase and "read-data" phase apply 4 signals
                spi_fwrite_qio: u1,
                ///  1: mosi and miso signals share the same pin
                spi_sio: u1,
                reserved24: u7,
                ///  1: "read-data" phase only access to high-part of the buffer spi_w8~spi_w15
                reg_usr_miso_highpart: u1,
                ///  1: "write-data" phase only access to high-part of the buffer spi_w8~spi_w15
                reg_usr_mosi_highpart: u1,
                reserved27: u1,
                ///  This bit enable the "write-data" phase of an operation.
                spi_usr_mosi: u1,
                ///  This bit enable the "read-data" phase of an operation.
                spi_usr_miso: u1,
                ///  This bit enable the "dummy" phase of an operation.
                spi_usr_dummy: u1,
                ///  This bit enable the "address" phase of an operation.
                spi_usr_addr: u1,
                ///  This bit enable the "command" phase of an operation.
                spi_usr_command: u1,
            }),
            ///  The length in bits of "address" phase. The register value shall be (bit_num-1)
            SPI_USER1: mmio.Mmio(packed struct(u32) {
                ///  The length in spi_clk cycles of "dummy" phase. The register value shall be (cycle_num-1)
                reg_usr_dummy_cyclelen: u8,
                ///  The length in bits of "read-data" phase. The register value shall be (bit_num-1)
                reg_usr_miso_bitlen: u9,
                ///  The length in bits of "write-data" phase. The register value shall be (bit_num-1)
                reg_usr_mosi_bitlen: u9,
                ///  The length in bits of "address" phase. The register value shall be (bit_num-1)
                reg_usr_addr_bitlen: u6,
            }),
            ///  The length in bits of "command" phase. The register value shall be (bit_num-1)
            SPI_USER2: mmio.Mmio(packed struct(u32) {
                ///  The value of "command" phase
                reg_usr_command_value: u16,
                reserved28: u12,
                ///  The length in bits of "command" phase. The register value shall be (bit_num-1)
                reg_usr_command_bitlen: u4,
            }),
            ///  In the slave mode, this register are the status register for the master to write into.
            SPI_WR_STATUS: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, this register are the status register for the master to write into.
                slv_wr_status: u32,
            }),
            ///  1: disable CS2; 0: spi_cs signal is from/to CS2 pin
            SPI_PIN: mmio.Mmio(packed struct(u32) {
                ///  1: disable CS0; 0: spi_cs signal is from/to CS0 pin
                spi_cs0_dis: u1,
                ///  1: disable CS1; 0: spi_cs signal is from/to CS1 pin
                spi_cs1_dis: u1,
                ///  1: disable CS2; 0: spi_cs signal is from/to CS2 pin
                spi_cs2_dis: u1,
                reserved29: u26,
                ///  In the master mode, 1: high when idle; 0: low when idle
                spi_idle_edge: u1,
                padding: u2,
            }),
            ///  It is the synchronous reset signal of the module. This bit is self-cleared by hardware.
            SPI_SLAVE: mmio.Mmio(packed struct(u32) {
                ///  The interrupt raw bit for the completement of "read-buffer" operation in the slave mode.
                slv_rd_buf_done: u1,
                ///  The interrupt raw bit for the completement of "write-buffer" operation in the slave mode.
                slv_wr_buf_done: u1,
                ///  The interrupt raw bit for the completement of "read-status" operation in the slave mode.
                slv_rd_sta_done: u1,
                ///  The interrupt raw bit for the completement of "write-status" operation in the slave mode.
                slv_wr_sta_done: u1,
                ///  The interrupt raw bit for the completement of any operation in both the master mode and the slave mode.
                spi_trans_done: u1,
                ///  Interrupt enable bits for the below 5 sources
                spi_int_en: u5,
                reserved23: u13,
                ///  The operations counter in both the master mode and the slave mode.
                spi_trans_cnt: u4,
                ///  1: slave mode commands are defined in SPI_SLAVE3. 0: slave mode commands are fixed as 1: "write-status"; 4: "read-status"; 2: "write-buffer" and 3: "read-buffer".
                slv_cmd_define: u1,
                reserved30: u2,
                ///  1: slave mode, 0: master mode.
                spi_slave_mode: u1,
                ///  It is the synchronous reset signal of the module. This bit is self-cleared by hardware.
                spi_sync_reset: u1,
            }),
            ///  In the slave mode, it is the length in bits for "write-status" and "read-status" operations. The register valueshall be (bit_num-1)
            SPI_SLAVE1: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the enable bit of "dummy" phase for "read-buffer" operations.
                slv_rdbuf_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "write-buffer" operations.
                slv_wrbuf_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "read-status" operations.
                slv_rdsta_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "write-status" operations.
                slv_wrsta_dummy_en: u1,
                ///  In the slave mode, it is the address length in bits for "write-buffer" operation. The register value shall be(bit_num-1)
                slv_wr_addr_bitlen: u6,
                ///  In the slave mode, it is the address length in bits for "read-buffer" operation. The register value shall be(bit_num-1)
                slv_rd_addr_bitlen: u6,
                ///  In the slave mode, it is the length in bits for "write-buffer" and "read-buffer" operations. The register value shallbe (bit_num-1)
                slv_buf_bitlen: u9,
                reserved27: u2,
                ///  In the slave mode, it is the length in bits for "write-status" and "read-status" operations. The register valueshall be (bit_num-1)
                slv_status_bitlen: u5,
            }),
            ///  In the slave mode, it is the length in spi_clk cycles "dummy" phase for "write-buffer" operations. The registervalue shall be (cycle_num-1)
            SPI_SLAVE2: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "read-status" operations. Theregister value shall be (cycle_num-1)
                slv_rdsta_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "write-status" operations. Theregister value shall be (cycle_num-1)
                slv_wrsta_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "read-buffer" operations. The registervalue shall be (cycle_num-1)
                slv_rdbuf_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles "dummy" phase for "write-buffer" operations. The registervalue shall be (cycle_num-1)
                slv_wrbuf_dummy_cyclelen: u8,
            }),
            ///  In slave mode, it is the value of "write-status" command
            SPI_SLAVE3: mmio.Mmio(packed struct(u32) {
                ///  In slave mode, it is the value of "read-buffer" command
                slv_rdbuf_cmd_value: u8,
                ///  In slave mode, it is the value of "write-buffer" command
                slv_wrbuf_cmd_value: u8,
                ///  In slave mode, it is the value of "read-status" command
                slv_rdsta_cmd_value: u8,
                ///  In slave mode, it is the value of "write-status" command
                slv_wrsta_cmd_value: u8,
            }),
            ///  the data inside the buffer of the SPI module, byte 0
            SPI_W0: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 0
                spi_w0: u32,
            }),
            reserved96: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 1
            SPI_W1: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 1
                spi_w1: u32,
            }),
            reserved128: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 2
            SPI_W2: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 2
                spi_w2: u32,
            }),
            reserved160: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 3
            SPI_W3: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 3
                spi_w3: u32,
            }),
            reserved192: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 4
            SPI_W4: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 4
                spi_w4: u32,
            }),
            reserved224: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 5
            SPI_W5: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 5
                spi_w5: u32,
            }),
            reserved252: [24]u8,
            ///  This register is for two SPI masters to share the same cs, clock and data signals.
            SPI_EXT3: mmio.Mmio(packed struct(u32) {
                ///  This register is for two SPI masters to share the same cs, clock and data signals.
                reg_int_hold_ena: u2,
                padding: u30,
            }),
            ///  the data inside the buffer of the SPI module, byte 6
            SPI_W6: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 6
                spi_w6: u32,
            }),
            reserved288: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 7
            SPI_W7: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 7
                spi_w7: u32,
            }),
            reserved320: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 8
            SPI_W8: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 8
                spi_w8: u32,
            }),
            reserved352: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 9
            SPI_W9: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 9
                spi_w9: u32,
            }),
            reserved384: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 10
            SPI_W10: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 10
                spi_w10: u32,
            }),
            reserved416: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 11
            SPI_W11: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 11
                spi_w11: u32,
            }),
            reserved448: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 12
            SPI_W12: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 12
                spi_w12: u32,
            }),
            reserved480: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 13
            SPI_W13: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 13
                spi_w13: u32,
            }),
            reserved512: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 14
            SPI_W14: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 14
                spi_w14: u32,
            }),
            reserved544: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 15
            SPI_W15: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 15
                spi_w15: u32,
            }),
        };

        pub const SPI1 = extern struct {
            ///  In the master mode, it is the start bit of a single operation. Self-clear by hardware
            SPI_CMD: mmio.Mmio(packed struct(u32) {
                reserved18: u18,
                ///  In the master mode, it is the start bit of a single operation. Self-clear by hardware
                spi_usr: u1,
                spi_hpm: u1,
                spi_res: u1,
                spi_dp: u1,
                spi_ce: u1,
                spi_be: u1,
                spi_se: u1,
                spi_pp: u1,
                spi_write_sr: u1,
                spi_read_sr: u1,
                spi_read_id: u1,
                spi_write_disable: u1,
                spi_write_enable: u1,
                spi_read: u1,
            }),
            ///  In the master mode, it is the value of address in "address" phase.
            SPI_ADDR: mmio.Mmio(packed struct(u32) {
                address: u24,
                size: u8,
            }),
            ///  SPI_CTRL
            SPI_CTRL: mmio.Mmio(packed struct(u32) {
                reserved13: u13,
                ///  this bit enable the bits: spi_qio_mode, spi_dio_mode, spi_qout_mode and spi_dout_mode
                spi_fastrd_mode: u1,
                ///  In the read operations, "read-data" phase apply 2 signals
                spi_dout_mode: u1,
                reserved20: u5,
                ///  In the read operations, "read-data" phase apply 4 signals
                spi_qout_mode: u1,
                reserved23: u2,
                ///  In the read operations, "address" phase and "read-data" phase apply 2 signals
                spi_dio_mode: u1,
                ///  In the read operations, "address" phase and "read-data" phase apply 4 signals
                spi_qio_mode: u1,
                ///  In "read-data" (MISO) phase, 1: LSB first; 0: MSB first
                spi_rd_bit_order: u1,
                ///  In "command", "address", "write-data" (MOSI) phases, 1: LSB first; 0: MSB first
                spi_wr_bit_order: u1,
                padding: u5,
            }),
            SPI_CTRL1: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the status for master to read out.
                status: u16,
                ///  Mode bits in the flash fast read mode, it is combined with spi_fastrd_mode bit.
                wb_mode: u8,
                ///  In the slave mode,it is the status for master to read out.
                status_ext: u8,
            }),
            ///  In the slave mode, this register are the status register for the master to read out.
            SPI_RD_STATUS: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, this register are the status register for the master to read out.
                slv_rd_status: u32,
            }),
            ///  spi_cs signal is delayed by 80MHz clock cycles
            SPI_CTRL2: mmio.Mmio(packed struct(u32) {
                reserved16: u16,
                ///  MISO signals are delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_miso_delay_mode: u2,
                ///  MISO signals are delayed by 80MHz clock cycles
                spi_miso_delay_num: u3,
                ///  MOSI signals are delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_mosi_delay_mode: u2,
                ///  MOSI signals are delayed by 80MHz clock cycles
                spi_mosi_delay_num: u3,
                ///  spi_cs signal is delayed by spi_clk. 0: zero; 1: half cycle; 2: one cycle
                spi_cs_delay_mode: u2,
                ///  spi_cs signal is delayed by 80MHz clock cycles
                spi_cs_delay_num: u4,
            }),
            ///  In the master mode, 1: spi_clk is eqaul to 80MHz, 0: spi_clk is divided from 80 MHz clock.
            SPI_CLOCK: mmio.Mmio(packed struct(u32) {
                ///  In the master mode, it must be eqaul to spi_clkcnt_N. In the slave mode, it must be 0.
                spi_clkcnt_L: u6,
                ///  In the master mode, it must be floor((spi_clkcnt_N+1)/2-1). In the slave mode, it must be 0.
                spi_clkcnt_H: u6,
                ///  In the master mode, it is the divider of spi_clk. So spi_clk frequency is 80MHz/(spi_clkdiv_pre+1)/(spi_clkcnt_N+1)
                spi_clkcnt_N: u6,
                ///  In the master mode, it is pre-divider of spi_clk.
                spi_clkdiv_pre: u13,
                ///  In the master mode, 1: spi_clk is eqaul to 80MHz, 0: spi_clk is divided from 80 MHz clock.
                spi_clk_equ_sysclk: u1,
            }),
            ///  This bit enable the "command" phase of an operation.
            SPI_USER: mmio.Mmio(packed struct(u32) {
                ///  set spi in full duplex mode
                spi_duplex: u1,
                ///  reserved
                spi_ahb_user_command_4byte: u1,
                spi_flash_mode: u1,
                ///  reserved
                spi_ahb_user_command: u1,
                ///  spi cs keep low when spi is in done phase. 1: enable 0: disable.
                spi_cs_hold: u1,
                ///  spi cs is enable when spi is in prepare phase. 1: enable 0: disable.
                spi_cs_setup: u1,
                ///  In the slave mode, 1: rising-edge; 0: falling-edge
                spi_ck_i_edge: u1,
                ///  In the master mode, 1: rising-edge; 0: falling-edge
                spi_ck_o_edge: u1,
                reserved10: u2,
                ///  In "read-data" (MISO) phase, 1: little-endian; 0: big_endian
                spi_rd_byte_order: u1,
                ///  In "command", "address", "write-data" (MOSI) phases, 1: little-endian; 0: big_endian
                spi_wr_byte_order: u1,
                ///  In the write operations, "read-data" phase apply 2 signals
                spi_fwrite_dual: u1,
                ///  In the write operations, "read-data" phase apply 4 signals
                spi_fwrite_quad: u1,
                ///  In the write operations, "address" phase and "read-data" phase apply 2 signals
                spi_fwrite_dio: u1,
                ///  In the write operations, "address" phase and "read-data" phase apply 4 signals
                spi_fwrite_qio: u1,
                ///  1: mosi and miso signals share the same pin
                spi_sio: u1,
                reserved24: u7,
                ///  1: "read-data" phase only access to high-part of the buffer spi_w8~spi_w15
                reg_usr_miso_highpart: u1,
                ///  1: "write-data" phase only access to high-part of the buffer spi_w8~spi_w15
                reg_usr_mosi_highpart: u1,
                reserved27: u1,
                ///  This bit enable the "write-data" phase of an operation.
                spi_usr_mosi: u1,
                ///  This bit enable the "read-data" phase of an operation.
                spi_usr_miso: u1,
                ///  This bit enable the "dummy" phase of an operation.
                spi_usr_dummy: u1,
                ///  This bit enable the "address" phase of an operation.
                spi_usr_addr: u1,
                ///  This bit enable the "command" phase of an operation.
                spi_usr_command: u1,
            }),
            ///  The length in bits of "address" phase. The register value shall be (bit_num-1)
            SPI_USER1: mmio.Mmio(packed struct(u32) {
                ///  The length in spi_clk cycles of "dummy" phase. The register value shall be (cycle_num-1)
                reg_usr_dummy_cyclelen: u8,
                ///  The length in bits of "read-data" phase. The register value shall be (bit_num-1)
                reg_usr_miso_bitlen: u9,
                ///  The length in bits of "write-data" phase. The register value shall be (bit_num-1)
                reg_usr_mosi_bitlen: u9,
                ///  The length in bits of "address" phase. The register value shall be (bit_num-1)
                reg_usr_addr_bitlen: u6,
            }),
            ///  The length in bits of "command" phase. The register value shall be (bit_num-1)
            SPI_USER2: mmio.Mmio(packed struct(u32) {
                ///  The value of "command" phase
                reg_usr_command_value: u16,
                reserved28: u12,
                ///  The length in bits of "command" phase. The register value shall be (bit_num-1)
                reg_usr_command_bitlen: u4,
            }),
            ///  In the slave mode, this register are the status register for the master to write into.
            SPI_WR_STATUS: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, this register are the status register for the master to write into.
                slv_wr_status: u32,
            }),
            ///  1: disable CS2; 0: spi_cs signal is from/to CS2 pin
            SPI_PIN: mmio.Mmio(packed struct(u32) {
                ///  1: disable CS0; 0: spi_cs signal is from/to CS0 pin
                spi_cs0_dis: u1,
                ///  1: disable CS1; 0: spi_cs signal is from/to CS1 pin
                spi_cs1_dis: u1,
                ///  1: disable CS2; 0: spi_cs signal is from/to CS2 pin
                spi_cs2_dis: u1,
                reserved29: u26,
                ///  In the master mode, 1: high when idle; 0: low when idle
                spi_idle_edge: u1,
                padding: u2,
            }),
            ///  It is the synchronous reset signal of the module. This bit is self-cleared by hardware.
            SPI_SLAVE: mmio.Mmio(packed struct(u32) {
                ///  The interrupt raw bit for the completement of "read-buffer" operation in the slave mode.
                slv_rd_buf_done: u1,
                ///  The interrupt raw bit for the completement of "write-buffer" operation in the slave mode.
                slv_wr_buf_done: u1,
                ///  The interrupt raw bit for the completement of "read-status" operation in the slave mode.
                slv_rd_sta_done: u1,
                ///  The interrupt raw bit for the completement of "write-status" operation in the slave mode.
                slv_wr_sta_done: u1,
                ///  The interrupt raw bit for the completement of any operation in both the master mode and the slave mode.
                spi_trans_done: u1,
                ///  Interrupt enable bits for the below 5 sources
                spi_int_en: u5,
                reserved23: u13,
                ///  The operations counter in both the master mode and the slave mode.
                spi_trans_cnt: u4,
                ///  1: slave mode commands are defined in SPI_SLAVE3. 0: slave mode commands are fixed as 1: "write-status"; 4: "read-status"; 2: "write-buffer" and 3: "read-buffer".
                slv_cmd_define: u1,
                reserved30: u2,
                ///  1: slave mode, 0: master mode.
                spi_slave_mode: u1,
                ///  It is the synchronous reset signal of the module. This bit is self-cleared by hardware.
                spi_sync_reset: u1,
            }),
            ///  In the slave mode, it is the length in bits for "write-status" and "read-status" operations. The register valueshall be (bit_num-1)
            SPI_SLAVE1: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the enable bit of "dummy" phase for "read-buffer" operations.
                slv_rdbuf_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "write-buffer" operations.
                slv_wrbuf_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "read-status" operations.
                slv_rdsta_dummy_en: u1,
                ///  In the slave mode, it is the enable bit of "dummy" phase for "write-status" operations.
                slv_wrsta_dummy_en: u1,
                ///  In the slave mode, it is the address length in bits for "write-buffer" operation. The register value shall be(bit_num-1)
                slv_wr_addr_bitlen: u6,
                ///  In the slave mode, it is the address length in bits for "read-buffer" operation. The register value shall be(bit_num-1)
                slv_rd_addr_bitlen: u6,
                ///  In the slave mode, it is the length in bits for "write-buffer" and "read-buffer" operations. The register value shallbe (bit_num-1)
                slv_buf_bitlen: u9,
                reserved27: u2,
                ///  In the slave mode, it is the length in bits for "write-status" and "read-status" operations. The register valueshall be (bit_num-1)
                slv_status_bitlen: u5,
            }),
            ///  In the slave mode, it is the length in spi_clk cycles "dummy" phase for "write-buffer" operations. The registervalue shall be (cycle_num-1)
            SPI_SLAVE2: mmio.Mmio(packed struct(u32) {
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "read-status" operations. Theregister value shall be (cycle_num-1)
                slv_rdsta_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "write-status" operations. Theregister value shall be (cycle_num-1)
                slv_wrsta_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles of "dummy" phase for "read-buffer" operations. The registervalue shall be (cycle_num-1)
                slv_rdbuf_dummy_cyclelen: u8,
                ///  In the slave mode, it is the length in spi_clk cycles "dummy" phase for "write-buffer" operations. The registervalue shall be (cycle_num-1)
                slv_wrbuf_dummy_cyclelen: u8,
            }),
            ///  In slave mode, it is the value of "write-status" command
            SPI_SLAVE3: mmio.Mmio(packed struct(u32) {
                ///  In slave mode, it is the value of "read-buffer" command
                slv_rdbuf_cmd_value: u8,
                ///  In slave mode, it is the value of "write-buffer" command
                slv_wrbuf_cmd_value: u8,
                ///  In slave mode, it is the value of "read-status" command
                slv_rdsta_cmd_value: u8,
                ///  In slave mode, it is the value of "write-status" command
                slv_wrsta_cmd_value: u8,
            }),
            ///  the data inside the buffer of the SPI module, byte 0
            SPI_W0: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 0
                spi_w0: u32,
            }),
            reserved96: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 1
            SPI_W1: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 1
                spi_w1: u32,
            }),
            reserved128: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 2
            SPI_W2: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 2
                spi_w2: u32,
            }),
            reserved160: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 3
            SPI_W3: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 3
                spi_w3: u32,
            }),
            reserved192: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 4
            SPI_W4: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 4
                spi_w4: u32,
            }),
            reserved224: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 5
            SPI_W5: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 5
                spi_w5: u32,
            }),
            reserved252: [24]u8,
            ///  This register is for two SPI masters to share the same cs, clock and data signals.
            SPI_EXT3: mmio.Mmio(packed struct(u32) {
                ///  This register is for two SPI masters to share the same cs, clock and data signals.
                reg_int_hold_ena: u2,
                padding: u30,
            }),
            ///  the data inside the buffer of the SPI module, byte 6
            SPI_W6: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 6
                spi_w6: u32,
            }),
            reserved288: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 7
            SPI_W7: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 7
                spi_w7: u32,
            }),
            reserved320: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 8
            SPI_W8: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 8
                spi_w8: u32,
            }),
            reserved352: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 9
            SPI_W9: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 9
                spi_w9: u32,
            }),
            reserved384: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 10
            SPI_W10: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 10
                spi_w10: u32,
            }),
            reserved416: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 11
            SPI_W11: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 11
                spi_w11: u32,
            }),
            reserved448: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 12
            SPI_W12: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 12
                spi_w12: u32,
            }),
            reserved480: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 13
            SPI_W13: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 13
                spi_w13: u32,
            }),
            reserved512: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 14
            SPI_W14: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 14
                spi_w14: u32,
            }),
            reserved544: [28]u8,
            ///  the data inside the buffer of the SPI module, byte 15
            SPI_W15: mmio.Mmio(packed struct(u32) {
                ///  the data inside the buffer of the SPI module, byte 15
                spi_w15: u32,
            }),
        };

        pub const TIMER = extern struct {
            ///  the load value into the counter
            FRC1_LOAD: mmio.Mmio(packed struct(u32) {
                ///  the load value into the counter
                frc1_load_value: u23,
                padding: u9,
            }),
            ///  the current value of the counter. It is a decreasingcounter.
            FRC1_COUNT: mmio.Mmio(packed struct(u32) {
                ///  the current value of the counter. It is a decreasingcounter.
                frc1_count: u23,
                padding: u9,
            }),
            ///  FRC1_CTRL
            FRC1_CTRL: mmio.Mmio(packed struct(u32) {
                ///  Configure the interrupt type
                interrupt_type: u1,
                reserved2: u1,
                ///  Pre-scale divider for the timer
                prescale_divider: packed union {
                    raw: u2,
                    value: enum(u2) {
                        ///  divided by 1
                        devided_by_1 = 0x0,
                        ///  divided by 16
                        devided_by_16 = 0x1,
                        ///  divided by 256
                        devided_by_256 = 0x2,
                        _,
                    },
                },
                reserved6: u2,
                ///  Automatically reload when the counter hits zero
                rollover: u1,
                ///  Enable or disable the timer
                timer_enable: u1,
                ///  the status of the interrupt, when the count isdereased to zero
                frc1_int: u1,
                padding: u23,
            }),
            ///  FRC1_INT
            FRC1_INT: mmio.Mmio(packed struct(u32) {
                ///  write to clear the status of the interrupt, if theinterrupt type is "level"
                frc1_int_clr_mask: u1,
                padding: u31,
            }),
            reserved32: [16]u8,
            ///  the load value into the counter
            FRC2_LOAD: mmio.Mmio(packed struct(u32) {
                ///  the load value into the counter
                frc2_load_value: u32,
            }),
            ///  the current value of the counter. It is a increasingcounter.
            FRC2_COUNT: mmio.Mmio(packed struct(u32) {
                ///  the current value of the counter. It is a increasingcounter.
                frc2_count: u32,
            }),
            ///  FRC2_CTRL
            FRC2_CTRL: mmio.Mmio(packed struct(u32) {
                ///  Configure the interrupt type
                interrupt_type: u1,
                reserved2: u1,
                ///  Pre-scale divider for the timer
                prescale_divider: packed union {
                    raw: u2,
                    value: enum(u2) {
                        ///  divided by 1
                        devided_by_1 = 0x0,
                        ///  divided by 16
                        devided_by_16 = 0x1,
                        ///  divided by 256
                        devided_by_256 = 0x2,
                        _,
                    },
                },
                reserved6: u2,
                ///  Automatically reload when the counter hits zero
                rollover: u1,
                ///  Enable or disable the timer
                timer_enable: u1,
                ///  the status of the interrupt, when the count is equal tothe alarm value
                frc2_int: u1,
                padding: u23,
            }),
            ///  FRC2_INT
            FRC2_INT: mmio.Mmio(packed struct(u32) {
                ///  write to clear the status of the interrupt, if theinterrupt type is "level"
                frc2_int_clr_mask: u1,
                padding: u31,
            }),
            ///  the alarm value for the counter
            FRC2_ALARM: mmio.Mmio(packed struct(u32) {
                ///  the alarm value for the counter
                frc2_alarm: u32,
            }),
        };

        pub const UART0 = extern struct {
            ///  UART FIFO,length 128
            UART_FIFO: mmio.Mmio(packed struct(u32) {
                ///  R/W share the same address
                rxfifo_rd_byte: u8,
                padding: u24,
            }),
            ///  UART INTERRUPT RAW STATE
            UART_INT_RAW: mmio.Mmio(packed struct(u32) {
                ///  The interrupt raw bit for rx fifo full interrupt(depands onUART_RXFIFO_FULL_THRHD bits)
                rxfifo_full_int_raw: u1,
                ///  The interrupt raw bit for tx fifo empty interrupt(depands onUART_TXFIFO_EMPTY_THRHD bits)
                txfifo_empty_int_raw: u1,
                ///  The interrupt raw bit for parity check error
                parity_err_int_raw: u1,
                ///  The interrupt raw bit for other rx error
                frm_err_int_raw: u1,
                ///  The interrupt raw bit for rx fifo overflow
                rxfifo_ovf_int_raw: u1,
                ///  The interrupt raw bit for DSR changing level
                dsr_chg_int_raw: u1,
                ///  The interrupt raw bit for CTS changing level
                cts_chg_int_raw: u1,
                ///  The interrupt raw bit for Rx byte start error
                brk_det_int_raw: u1,
                ///  The interrupt raw bit for Rx time-out interrupt(depands on theUART_RX_TOUT_THRHD)
                rxfifo_tout_int_raw: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT STATEREGISTERUART_INT_RAW&UART_INT_ENA
            UART_INT_ST: mmio.Mmio(packed struct(u32) {
                ///  The interrupt state bit for RX fifo full event
                rxfifo_full_int_st: u1,
                ///  The interrupt state bit for TX fifo empty
                txfifo_empty_int_st: u1,
                ///  The interrupt state bit for rx parity error
                parity_err_int_st: u1,
                ///  The interrupt state for other rx error
                frm_err_int_st: u1,
                ///  The interrupt state bit for RX fifo overflow
                rxfifo_ovf_int_st: u1,
                ///  The interrupt state bit for DSR changing level
                dsr_chg_int_st: u1,
                ///  The interrupt state bit for CTS changing level
                cts_chg_int_st: u1,
                ///  The interrupt state bit for rx byte start error
                brk_det_int_st: u1,
                ///  The interrupt state bit for Rx time-out event
                rxfifo_tout_int_st: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT ENABLE REGISTER
            UART_INT_ENA: mmio.Mmio(packed struct(u32) {
                ///  The interrupt enable bit for rx fifo full event
                rxfifo_full_int_ena: u1,
                ///  The interrupt enable bit for tx fifo empty event
                txfifo_empty_int_ena: u1,
                ///  The interrupt enable bit for parity error
                parity_err_int_ena: u1,
                ///  The interrupt enable bit for other rx error
                frm_err_int_ena: u1,
                ///  The interrupt enable bit for rx fifo overflow
                rxfifo_ovf_int_ena: u1,
                ///  The interrupt enable bit for DSR changing level
                dsr_chg_int_ena: u1,
                ///  The interrupt enable bit for CTS changing level
                cts_chg_int_ena: u1,
                ///  The interrupt enable bit for rx byte start error
                brk_det_int_ena: u1,
                ///  The interrupt enable bit for rx time-out interrupt
                rxfifo_tout_int_ena: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT CLEAR REGISTER
            UART_INT_CLR: mmio.Mmio(packed struct(u32) {
                ///  Set this bit to clear the rx fifo full interrupt
                rxfifo_full_int_clr: u1,
                ///  Set this bit to clear the tx fifo empty interrupt
                txfifo_empty_int_clr: u1,
                ///  Set this bit to clear the parity error interrupt
                parity_err_int_clr: u1,
                ///  Set this bit to clear other rx error interrupt
                frm_err_int_clr: u1,
                ///  Set this bit to clear the rx fifo over-flow interrupt
                rxfifo_ovf_int_clr: u1,
                ///  Set this bit to clear the DSR changing interrupt
                dsr_chg_int_clr: u1,
                ///  Set this bit to clear the CTS changing interrupt
                cts_chg_int_clr: u1,
                ///  Set this bit to clear the rx byte start interrupt
                brk_det_int_clr: u1,
                ///  Set this bit to clear the rx time-out interrupt
                rxfifo_tout_int_clr: u1,
                padding: u23,
            }),
            ///  UART CLK DIV REGISTER
            UART_CLKDIV: mmio.Mmio(packed struct(u32) {
                ///  BAUDRATE = UART_CLK_FREQ / UART_CLKDIV
                uart_clkdiv: u20,
                padding: u12,
            }),
            ///  UART BAUDRATE DETECT REGISTER
            UART_AUTOBAUD: mmio.Mmio(packed struct(u32) {
                ///  Set this bit to enable baudrate detect
                autobaud_en: u1,
                reserved8: u7,
                glitch_filt: u8,
                padding: u16,
            }),
            ///  UART STATUS REGISTER
            UART_STATUS: mmio.Mmio(packed struct(u32) {
                ///  Number of data in uart rx fifo
                rxfifo_cnt: u8,
                reserved13: u5,
                ///  The level of uart dsr pin
                dsrn: u1,
                ///  The level of uart cts pin
                ctsn: u1,
                ///  The level of uart rxd pin
                rxd: u1,
                ///  Number of data in UART TX fifo
                txfifo_cnt: u8,
                reserved29: u5,
                ///  The level of uart dtr pin
                dtrn: u1,
                ///  The level of uart rts pin
                rtsn: u1,
                ///  The level of the uart txd pin
                txd: u1,
            }),
            ///  UART CONFIG0(UART0 and UART1)
            UART_CONF0: mmio.Mmio(packed struct(u32) {
                ///  Set parity check: 0:even 1:odd, UART CONFIG1
                parity: u1,
                ///  Set this bit to enable uart parity check
                parity_en: u1,
                ///  Set bit num: 0:5bits 1:6bits 2:7bits 3:8bits
                bit_num: u2,
                ///  Set stop bit: 1:1bit 2:1.5bits 3:2bits
                stop_bit_num: u2,
                ///  sw rts
                sw_rts: u1,
                ///  sw dtr
                sw_dtr: u1,
                ///  RESERVED, DO NOT CHANGE THIS BIT
                txd_brk: u1,
                reserved14: u5,
                ///  Set this bit to enable uart loopback test mode
                uart_loopback: u1,
                ///  Set this bit to enable uart tx hardware flow control
                tx_flow_en: u1,
                reserved17: u1,
                ///  Set this bit to reset uart rx fifo
                rxfifo_rst: u1,
                ///  Set this bit to reset uart tx fifo
                txfifo_rst: u1,
                ///  Set this bit to inverse uart rxd level
                uart_rxd_inv: u1,
                ///  Set this bit to inverse uart cts level
                uart_cts_inv: u1,
                ///  Set this bit to inverse uart dsr level
                uart_dsr_inv: u1,
                ///  Set this bit to inverse uart txd level
                uart_txd_inv: u1,
                ///  Set this bit to inverse uart rts level
                uart_rts_inv: u1,
                ///  Set this bit to inverse uart dtr level
                uart_dtr_inv: u1,
                padding: u7,
            }),
            ///  Set this bit to enable rx time-out function
            UART_CONF1: mmio.Mmio(packed struct(u32) {
                ///  The config bits for rx fifo full threshold,0-127
                rxfifo_full_thrhd: u7,
                reserved8: u1,
                ///  The config bits for tx fifo empty threshold,0-127
                txfifo_empty_thrhd: u7,
                reserved16: u1,
                ///  The config bits for rx flow control threshold,0-127
                rx_flow_thrhd: u7,
                ///  Set this bit to enable rx hardware flow control
                rx_flow_en: u1,
                ///  Config bits for rx time-out threshold,uint: byte,0-127
                rx_tout_thrhd: u7,
                ///  Set this bit to enable rx time-out function
                rx_tout_en: u1,
            }),
            ///  UART_LOWPULSE
            UART_LOWPULSE: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                lowpulse_min_cnt: u20,
                padding: u12,
            }),
            ///  UART_HIGHPULSE
            UART_HIGHPULSE: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                highpulse_min_cnt: u20,
                padding: u12,
            }),
            ///  UART_RXD_CNT
            UART_RXD_CNT: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                rxd_edge_cnt: u10,
                padding: u22,
            }),
            reserved120: [68]u8,
            ///  UART HW INFO
            UART_DATE: mmio.Mmio(packed struct(u32) {
                ///  UART HW INFO
                uart_date: u32,
            }),
            ///  UART_ID
            UART_ID: mmio.Mmio(packed struct(u32) {
                uart_id: u32,
            }),
        };

        pub const UART1 = extern struct {
            ///  UART FIFO,length 128
            UART_FIFO: mmio.Mmio(packed struct(u32) {
                ///  R/W share the same address
                rxfifo_rd_byte: u8,
                padding: u24,
            }),
            ///  UART INTERRUPT RAW STATE
            UART_INT_RAW: mmio.Mmio(packed struct(u32) {
                ///  The interrupt raw bit for rx fifo full interrupt(depands onUART_RXFIFO_FULL_THRHD bits)
                rxfifo_full_int_raw: u1,
                ///  The interrupt raw bit for tx fifo empty interrupt(depands onUART_TXFIFO_EMPTY_THRHD bits)
                txfifo_empty_int_raw: u1,
                ///  The interrupt raw bit for parity check error
                parity_err_int_raw: u1,
                ///  The interrupt raw bit for other rx error
                frm_err_int_raw: u1,
                ///  The interrupt raw bit for rx fifo overflow
                rxfifo_ovf_int_raw: u1,
                ///  The interrupt raw bit for DSR changing level
                dsr_chg_int_raw: u1,
                ///  The interrupt raw bit for CTS changing level
                cts_chg_int_raw: u1,
                ///  The interrupt raw bit for Rx byte start error
                brk_det_int_raw: u1,
                ///  The interrupt raw bit for Rx time-out interrupt(depands on theUART_RX_TOUT_THRHD)
                rxfifo_tout_int_raw: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT STATEREGISTERUART_INT_RAW&UART_INT_ENA
            UART_INT_ST: mmio.Mmio(packed struct(u32) {
                ///  The interrupt state bit for RX fifo full event
                rxfifo_full_int_st: u1,
                ///  The interrupt state bit for TX fifo empty
                txfifo_empty_int_st: u1,
                ///  The interrupt state bit for rx parity error
                parity_err_int_st: u1,
                ///  The interrupt state for other rx error
                frm_err_int_st: u1,
                ///  The interrupt state bit for RX fifo overflow
                rxfifo_ovf_int_st: u1,
                ///  The interrupt state bit for DSR changing level
                dsr_chg_int_st: u1,
                ///  The interrupt state bit for CTS changing level
                cts_chg_int_st: u1,
                ///  The interrupt state bit for rx byte start error
                brk_det_int_st: u1,
                ///  The interrupt state bit for Rx time-out event
                rxfifo_tout_int_st: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT ENABLE REGISTER
            UART_INT_ENA: mmio.Mmio(packed struct(u32) {
                ///  The interrupt enable bit for rx fifo full event
                rxfifo_full_int_ena: u1,
                ///  The interrupt enable bit for tx fifo empty event
                txfifo_empty_int_ena: u1,
                ///  The interrupt enable bit for parity error
                parity_err_int_ena: u1,
                ///  The interrupt enable bit for other rx error
                frm_err_int_ena: u1,
                ///  The interrupt enable bit for rx fifo overflow
                rxfifo_ovf_int_ena: u1,
                ///  The interrupt enable bit for DSR changing level
                dsr_chg_int_ena: u1,
                ///  The interrupt enable bit for CTS changing level
                cts_chg_int_ena: u1,
                ///  The interrupt enable bit for rx byte start error
                brk_det_int_ena: u1,
                ///  The interrupt enable bit for rx time-out interrupt
                rxfifo_tout_int_ena: u1,
                padding: u23,
            }),
            ///  UART INTERRUPT CLEAR REGISTER
            UART_INT_CLR: mmio.Mmio(packed struct(u32) {
                ///  Set this bit to clear the rx fifo full interrupt
                rxfifo_full_int_clr: u1,
                ///  Set this bit to clear the tx fifo empty interrupt
                txfifo_empty_int_clr: u1,
                ///  Set this bit to clear the parity error interrupt
                parity_err_int_clr: u1,
                ///  Set this bit to clear other rx error interrupt
                frm_err_int_clr: u1,
                ///  Set this bit to clear the rx fifo over-flow interrupt
                rxfifo_ovf_int_clr: u1,
                ///  Set this bit to clear the DSR changing interrupt
                dsr_chg_int_clr: u1,
                ///  Set this bit to clear the CTS changing interrupt
                cts_chg_int_clr: u1,
                ///  Set this bit to clear the rx byte start interrupt
                brk_det_int_clr: u1,
                ///  Set this bit to clear the rx time-out interrupt
                rxfifo_tout_int_clr: u1,
                padding: u23,
            }),
            ///  UART CLK DIV REGISTER
            UART_CLKDIV: mmio.Mmio(packed struct(u32) {
                ///  BAUDRATE = UART_CLK_FREQ / UART_CLKDIV
                uart_clkdiv: u20,
                padding: u12,
            }),
            ///  UART BAUDRATE DETECT REGISTER
            UART_AUTOBAUD: mmio.Mmio(packed struct(u32) {
                ///  Set this bit to enable baudrate detect
                autobaud_en: u1,
                reserved8: u7,
                glitch_filt: u8,
                padding: u16,
            }),
            ///  UART STATUS REGISTER
            UART_STATUS: mmio.Mmio(packed struct(u32) {
                ///  Number of data in uart rx fifo
                rxfifo_cnt: u8,
                reserved13: u5,
                ///  The level of uart dsr pin
                dsrn: u1,
                ///  The level of uart cts pin
                ctsn: u1,
                ///  The level of uart rxd pin
                rxd: u1,
                ///  Number of data in UART TX fifo
                txfifo_cnt: u8,
                reserved29: u5,
                ///  The level of uart dtr pin
                dtrn: u1,
                ///  The level of uart rts pin
                rtsn: u1,
                ///  The level of the uart txd pin
                txd: u1,
            }),
            ///  UART CONFIG0(UART0 and UART1)
            UART_CONF0: mmio.Mmio(packed struct(u32) {
                ///  Set parity check: 0:even 1:odd, UART CONFIG1
                parity: u1,
                ///  Set this bit to enable uart parity check
                parity_en: u1,
                ///  Set bit num: 0:5bits 1:6bits 2:7bits 3:8bits
                bit_num: u2,
                ///  Set stop bit: 1:1bit 2:1.5bits 3:2bits
                stop_bit_num: u2,
                ///  sw rts
                sw_rts: u1,
                ///  sw dtr
                sw_dtr: u1,
                ///  RESERVED, DO NOT CHANGE THIS BIT
                txd_brk: u1,
                reserved14: u5,
                ///  Set this bit to enable uart loopback test mode
                uart_loopback: u1,
                ///  Set this bit to enable uart tx hardware flow control
                tx_flow_en: u1,
                reserved17: u1,
                ///  Set this bit to reset uart rx fifo
                rxfifo_rst: u1,
                ///  Set this bit to reset uart tx fifo
                txfifo_rst: u1,
                ///  Set this bit to inverse uart rxd level
                uart_rxd_inv: u1,
                ///  Set this bit to inverse uart cts level
                uart_cts_inv: u1,
                ///  Set this bit to inverse uart dsr level
                uart_dsr_inv: u1,
                ///  Set this bit to inverse uart txd level
                uart_txd_inv: u1,
                ///  Set this bit to inverse uart rts level
                uart_rts_inv: u1,
                ///  Set this bit to inverse uart dtr level
                uart_dtr_inv: u1,
                padding: u7,
            }),
            ///  Set this bit to enable rx time-out function
            UART_CONF1: mmio.Mmio(packed struct(u32) {
                ///  The config bits for rx fifo full threshold,0-127
                rxfifo_full_thrhd: u7,
                reserved8: u1,
                ///  The config bits for tx fifo empty threshold,0-127
                txfifo_empty_thrhd: u7,
                reserved16: u1,
                ///  The config bits for rx flow control threshold,0-127
                rx_flow_thrhd: u7,
                ///  Set this bit to enable rx hardware flow control
                rx_flow_en: u1,
                ///  Config bits for rx time-out threshold,uint: byte,0-127
                rx_tout_thrhd: u7,
                ///  Set this bit to enable rx time-out function
                rx_tout_en: u1,
            }),
            ///  UART_LOWPULSE
            UART_LOWPULSE: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                lowpulse_min_cnt: u20,
                padding: u12,
            }),
            ///  UART_HIGHPULSE
            UART_HIGHPULSE: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                highpulse_min_cnt: u20,
                padding: u12,
            }),
            ///  UART_RXD_CNT
            UART_RXD_CNT: mmio.Mmio(packed struct(u32) {
                ///  used in baudrate detect
                rxd_edge_cnt: u10,
                padding: u22,
            }),
            reserved120: [68]u8,
            ///  UART HW INFO
            UART_DATE: mmio.Mmio(packed struct(u32) {
                ///  UART HW INFO
                uart_date: u32,
            }),
            ///  UART_ID
            UART_ID: mmio.Mmio(packed struct(u32) {
                uart_id: u32,
            }),
        };

        pub const WDT = extern struct {
            ///  WDT_CTL
            WDT_CTL: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  WDT_OP
            WDT_OP: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            ///  WDT_OP_ND
            WDT_OP_ND: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
            reserved20: [8]u8,
            ///  WDT_RST
            WDT_RST: mmio.Mmio(packed struct(u32) {
                Register: u32,
            }),
        };

        ///  RNG register
        pub const RNG = extern struct {
            ///  RNG register
            rng: u32,
        };

        ///  Watchdog registers
        pub const WATCHDOG = extern struct {
            ///  Watchdog control
            ctl: mmio.Mmio(packed struct(u32) {
                ///  Enable the watchdog timer.
                enable: u1,
                ///  When set to 1, and running in two-stage mode, it turns the watchdog into a single shot timer that doesn't reset the device.
                stage_1_no_reset: u1,
                ///  Set to 1 to disable the stage 1 of the watchdog timer
                stage_1_disable: u1,
                unknown_3: u1,
                unknown_4: u1,
                unknown_5: u1,
                padding: u26,
            }),
            ///  Reload value for stage 0
            reload_stage0: u32,
            ///  Reload value for stage 1
            reload_stage1: u32,
            ///  Watchdog clock cycle count
            count: u32,
            ///  The current watchdog stage
            stage: u32,
            ///  Watchdog reset
            reset: u32,
            ///  Watchdog stage reset
            reset_stage: u32,
        };
    };
};
