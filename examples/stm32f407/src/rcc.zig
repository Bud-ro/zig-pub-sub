//! Reset and Clock Control (RCC) registers for the STM32F4 family.
//! Base address 0x40023800. Provides clock gating for AHB and APB
//! peripherals (GPIO, USART, etc.).

// zlinter-disable declaration_naming - hardware register names follow STM32 convention

const base: u32 = 0x40023800;

/// Clock control register.
pub const CR: *volatile u32 = @ptrFromInt(base + 0x00);
/// PLL configuration register.
pub const PLLCFGR: *volatile u32 = @ptrFromInt(base + 0x04);
/// Clock configuration register.
pub const CFGR: *volatile u32 = @ptrFromInt(base + 0x08);
/// AHB1 peripheral clock enable register.
pub const AHB1ENR: *volatile u32 = @ptrFromInt(base + 0x30);
/// APB1 peripheral clock enable register.
pub const APB1ENR: *volatile u32 = @ptrFromInt(base + 0x40);
/// APB2 peripheral clock enable register.
pub const APB2ENR: *volatile u32 = @ptrFromInt(base + 0x44);

/// AHB1ENR bit position: GPIOA clock enable.
pub const GPIOAEN: u5 = 0;
/// AHB1ENR bit position: GPIOB clock enable.
pub const GPIOBEN: u5 = 1;
/// AHB1ENR bit position: GPIOC clock enable.
pub const GPIOCEN: u5 = 2;
/// AHB1ENR bit position: GPIOD clock enable.
pub const GPIODEN: u5 = 3;
/// AHB1ENR bit position: GPIOE clock enable.
pub const GPIOEEN: u5 = 4;

/// APB1ENR bit position: USART2 clock enable.
pub const USART2EN: u5 = 17;

// zlinter-enable declaration_naming

/// Enable clock for a peripheral on AHB1.
pub fn enableAhb1(bit: u5) void {
    AHB1ENR.* |= @as(u32, 1) << bit;
}

/// Enable clock for a peripheral on APB1.
pub fn enableApb1(bit: u5) void {
    APB1ENR.* |= @as(u32, 1) << bit;
}
