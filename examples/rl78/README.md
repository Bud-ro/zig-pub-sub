# rl78 -- Zig on RL78/G14 via C Backend

Bare-metal Zig firmware for the Renesas RL78/G14 Promotion Board, compiled through Zig's C backend and linked with rl78-elf-gcc. Demonstrates the erd_core pub-sub framework on a 16-bit Renesas MCU with LED blink and uptime tracking.

## Hardware

- **Board**: Renesas RL78/G14 Promotion Board (QB-R5F104GJ-TB)
- **MCU**: Renesas R5F104GJ -- RL78 16-bit, 32MHz HOCO, 64KB flash, 4KB RAM
- **LED**: P7.7 (active-high, user LED)
- **Serial**: SAU0-CH0 on P1.2 (TX only), 9600 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> C backend (-ofmt=c, thumb-freestanding) -> sed fixup -> rl78-elf-gcc (-Os) -> link -> rl78-elf-objcopy -> firmware.hex
```

The Zig compiler emits C code targeting thumb-freestanding (the C backend does not require a matching architecture). A `sed` post-processing step fixes `static void const` declarations emitted by the C backend. The C is then compiled with `rl78-elf-gcc` and linked with the custom linker script `rl78.ld`.

## Prerequisites

```bash
# RL78 cross-compiler (Renesas GNU toolchain for RL78)
# Available from: https://llvm-gcc-renesas.com/
# Install to PATH as rl78-elf-gcc / rl78-elf-objcopy

# RL78 flash tool
# https://github.com/msalau/rl78flash
sudo apt install rl78flash  # or build from source
```

## Build & Flash

```bash
cd rl78
zig build          # Build firmware (produces zig-out/firmware.hex)
zig build flash    # Flash to RL78 on /dev/ttyUSB0 via rl78flash
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Reset handler (_start), .data/.bss init, super-loop |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO configuration and LED interface for P7.7 |
| `gpio.zig` | Register-level RL78 port GPIO driver |
| `uart.zig` | SAU0-CH0 UART TX driver at 9600 baud (32MHz HOCO) |
| `libc_stubs.c` | Minimal memcpy/memset for C backend output |
