const GPIO_OUT_W1TS: *volatile u32 = @ptrFromInt(0x60000304);
const GPIO_OUT_W1TC: *volatile u32 = @ptrFromInt(0x60000308);
const GPIO_ENABLE_W1TS: *volatile u32 = @ptrFromInt(0x60000310);

const IO_MUX_GPIO2: *volatile u32 = @ptrFromInt(0x60000838);

const WDT_CTL: *volatile u32 = @ptrFromInt(0x60000900);

// FUNC select: bit 4 (low bit), bits 8-9 (high bits)
const FUNC_MASK: u32 = (1 << 4) | (0x3 << 8);

const LED_PIN: u5 = 2;

export fn user_init() void {
    WDT_CTL.* = 0;

    // Select GPIO function for pin 2 (function 0 = GPIO)
    IO_MUX_GPIO2.* = IO_MUX_GPIO2.* & ~FUNC_MASK;

    GPIO_ENABLE_W1TS.* = @as(u32, 1) << LED_PIN;

    while (true) {
        GPIO_OUT_W1TC.* = @as(u32, 1) << LED_PIN;
        delay(5_000_000);
        GPIO_OUT_W1TS.* = @as(u32, 1) << LED_PIN;
        delay(5_000_000);
    }
}

fn delay(count: u32) void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        asm volatile ("nop");
    }
}
