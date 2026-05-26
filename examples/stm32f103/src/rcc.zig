//! RCC (Reset and Clock Control) register definitions for STM32F103.
//!
//! Provides direct register access to the clock control peripheral.
//! Base address: 0x40021000.

// zlinter-disable declaration_naming - hardware register names follow STM datasheet

/// RCC base address.
const RCC_BASE: u32 = 0x40021000;

/// Clock control register (HSI/HSE/PLL on/off and ready flags).
pub const CR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x00);

/// Clock configuration register (clock source select, AHB/APB prescalers).
pub const CFGR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x04);

/// Clock interrupt register.
pub const CIR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x08);

/// APB2 peripheral reset register.
pub const APB2RSTR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x0C);

/// APB1 peripheral reset register.
pub const APB1RSTR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x10);

/// AHB peripheral clock enable register.
pub const AHBENR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x14);

/// APB2 peripheral clock enable register.
/// Key bits:
///   bit 0  = AFIOEN  (alternate function I/O clock)
///   bit 2  = IOPAEN  (GPIOA clock)
///   bit 3  = IOPBEN  (GPIOB clock)
///   bit 4  = IOPCEN  (GPIOC clock)
///   bit 14 = USART1EN (USART1 clock)
pub const APB2ENR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x18);

/// APB1 peripheral clock enable register.
pub const APB1ENR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x1C);

// zlinter-enable declaration_naming

/// Enable the clock for GPIOA (APB2ENR bit 2).
pub fn enableGpioA() void {
    APB2ENR.* |= (1 << 2);
}

/// Enable the clock for GPIOB (APB2ENR bit 3).
pub fn enableGpioB() void {
    APB2ENR.* |= (1 << 3);
}

/// Enable the clock for GPIOC (APB2ENR bit 4).
pub fn enableGpioC() void {
    APB2ENR.* |= (1 << 4);
}

/// Enable the clock for USART1 (APB2ENR bit 14).
pub fn enableUsart1() void {
    APB2ENR.* |= (1 << 14);
}

/// Enable the alternate function I/O clock (APB2ENR bit 0).
pub fn enableAfio() void {
    APB2ENR.* |= (1 << 0);
}
