const GPIO_OUT: *volatile u32 = @ptrFromInt(0x60000300);
const GPIO_OUT_W1TS: *volatile u32 = @ptrFromInt(0x60000304);
const GPIO_OUT_W1TC: *volatile u32 = @ptrFromInt(0x60000308);
const GPIO_ENABLE_W1TS: *volatile u32 = @ptrFromInt(0x60000310);

const LED_PIN: u5 = 2;

export fn user_init() void {
    GPIO_ENABLE_W1TS.* = @as(u32, 1) << LED_PIN;

    while (true) {
        GPIO_OUT_W1TS.* = @as(u32, 1) << LED_PIN;
        delay(500_000);
        GPIO_OUT_W1TC.* = @as(u32, 1) << LED_PIN;
        delay(500_000);
    }
}

fn delay(count: u32) void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        asm volatile ("nop");
    }
}
