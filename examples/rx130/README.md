# rx130 -- Zig on RX130 via C Backend

Bare-metal Zig firmware for the Renesas RX130 Target Board, compiled through Zig's C backend and linked with rx-elf-gcc. Demonstrates the erd_core pub-sub framework on a 32-bit Renesas RX MCU with LED blink and uptime tracking.

## Hardware

- **Board**: Renesas RX130 Target Board (RTK5RX1300C00000BR)
- **MCU**: Renesas R5F51305 -- RX130 32-bit, 32MHz, 256KB flash, 32KB RAM
- **LED**: P1.6 (active-low, onboard LED)
- **Serial**: SCI1 on P2.6 (TX only), 9600 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> C backend (-ofmt=c, thumb-freestanding) -> sed fixup -> rx-elf-gcc (-Os) -> link -> rx-elf-objcopy -> firmware.mot (Motorola S-record)
```

The Zig compiler emits C code targeting thumb-freestanding (the C backend does not require a matching architecture). A `sed` post-processing step fixes `static void const` declarations emitted by the C backend. The C is then compiled with `rx-elf-gcc` and linked with the custom linker script `rx130.ld`. The final image is produced as a Motorola S-record for Renesas flash tools.

## Prerequisites

```bash
# RX cross-compiler (Renesas GNU toolchain for RX)
# Available from: https://llvm-gcc-renesas.com/
# Install to PATH as rx-elf-gcc / rx-elf-objcopy
```

## Build & Flash

```bash
cd rx130
zig build          # Build firmware (produces zig-out/firmware.mot)
```

Flashing uses the Motorola S-record output (`firmware.mot`) with the Renesas Flash Programmer or E2 Lite debugger.

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Reset handler (_start) in inline RX assembly, .bss/.data init, calls _main |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO and UART initialization, LED interface for P1.6 |
| `gpio.zig` | Register-level RX130 port GPIO driver |
| `uart.zig` | SCI1 UART TX driver at 9600 baud (32MHz PCLK) |
| `libc_stubs.c` | Minimal memcpy/memset for C backend output |
