# pic32mx -- Zig on PIC32MX270 via C Backend

Bare-metal Zig firmware for the PIC32MX270 Curiosity board, compiled through Zig's C backend and linked with Microchip's xc32-gcc. Demonstrates the erd_core pub-sub framework on a 32-bit MIPS MCU with LED blink and uptime tracking.

## Hardware

- **Board**: PIC32MX270 Curiosity (DM320103)
- **MCU**: Microchip PIC32MX270F256B -- MIPS32 M4K, 8MHz FRC (48MHz max with PLL), 256KB flash, 64KB RAM
- **LED**: RB5 (active-high, onboard LED)
- **Serial**: UART1 on RB3 via PPS (TX only), 9600 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> C backend (-ofmt=c, mipsel-freestanding) -> sed fixup -> xc32-gcc (-Os, -mprocessor=32MX270F256B) -> link -> xc32-objcopy -> firmware.hex
```

The Zig compiler emits C code targeting mipsel-freestanding. A `sed` post-processing step fixes `static void const` declarations emitted by the C backend. The C is then compiled with `xc32-gcc` and linked with the custom linker script `pic32mx.ld`.

## Prerequisites

```bash
# Microchip XC32 compiler
# Download installer from: https://www.microchip.com/en-us/tools-resources/develop/mplab-xc-compilers
# Default install path: /opt/microchip/xc32/<version>/bin/
# Add to PATH: export PATH=/opt/microchip/xc32/<version>/bin:$PATH

# Open-source PIC32 programmer (alternative to MPLAB IPE)
# https://github.com/sergev/pic32prog
```

## Build & Flash

```bash
cd pic32mx
zig build          # Build firmware (produces zig-out/firmware.hex)
zig build flash    # Program via pic32prog on /dev/ttyUSB0
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, busy-wait 1ms tick loop (~8000 NOPs at 8MHz FRC) |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | Watchdog disable, GPIO output setup, LED interface for RB5 |
| `gpio.zig` | Register-level PORTB GPIO driver |
| `uart.zig` | UART1 TX driver at 9600 baud via PPS on RB3 |
| `libc_stubs.c` | Minimal memcpy/memset for C backend output |
