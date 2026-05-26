//! Register-level GPIO driver for ESP32-C3.
//! Provides basic digital output control through the GPIO matrix registers.
//! See ESP32-C3 Technical Reference Manual, Chapter 5 (IO MUX and GPIO Matrix).

// zlinter-disable declaration_naming - hardware register names follow ESP32-C3 convention
const GPIO_BASE = 0x60004000;
const GPIO_OUT_W1TS_REG: *volatile u32 = @ptrFromInt(GPIO_BASE + 0x08);
const GPIO_OUT_W1TC_REG: *volatile u32 = @ptrFromInt(GPIO_BASE + 0x0C);
const GPIO_ENABLE_W1TS_REG: *volatile u32 = @ptrFromInt(GPIO_BASE + 0x24);
const GPIO_IN_REG: *volatile u32 = @ptrFromInt(GPIO_BASE + 0x3C);

const IO_MUX_BASE = 0x60009000;
// zlinter-enable declaration_naming

/// Configure a pin for simple GPIO output via the IO MUX and GPIO matrix.
/// Sets IO_MUX function to GPIO (MCU_SEL=1), routes GPIO output through
/// the GPIO matrix (func 128 = simple GPIO), and enables the output driver.
pub fn configureOutput(pin: u5) void {
    if (pin > 21) return;

    // IO_MUX: set MCU_SEL to function 1 (GPIO) with drive strength 2
    const mux_reg: *volatile u32 = @ptrFromInt(IO_MUX_BASE + 0x04 + @as(u32, pin) * 4);
    mux_reg.* = (1 << 12) | // MCU_SEL = 1 (GPIO function)
        (2 << 10); // FUN_DRV = 2 (drive strength)

    // GPIO matrix: route simple GPIO output (function 128)
    const func_out_sel: *volatile u32 = @ptrFromInt(GPIO_BASE + 0x554 + @as(u32, pin) * 4);
    func_out_sel.* = 0x80;

    // Enable output
    GPIO_ENABLE_W1TS_REG.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin high.
pub fn setPin(pin: u5) void {
    GPIO_OUT_W1TS_REG.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin low.
pub fn clearPin(pin: u5) void {
    GPIO_OUT_W1TC_REG.* = @as(u32, 1) << pin;
}

/// Read the current level of a GPIO pin.
pub fn readPin(pin: u5) bool {
    return (GPIO_IN_REG.* >> pin) & 1 != 0;
}
