# stc89c52 -- Zig on STC89C52RC (8051) via C Backend + SDCC

Bare-metal Zig firmware for the STC89C52RC, compiled through Zig's C backend and then assembled by SDCC for the MCS-51 architecture. Demonstrates the erd_core pub-sub framework on an 8-bit 8051 MCU with LED blink and uptime tracking.

## Hardware

- **Board**: STC89C52RC development board (common 40-pin DIP)
- **MCU**: STC89C52RC -- 8051, 11.0592MHz, 8KB flash, 256B IRAM, 512B XRAM
- **LED**: P1.0 (active-low, onboard LED)
- **Serial**: UART via SBUF on P3.0/P3.1, 9600 baud (Timer1 baud generator)

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> C backend (-ofmt=c, thumb-freestanding) -> sed fixup -> SDCC (-mmcs51, --model-small) -> link -> firmware.ihx (Intel HEX)
```

The Zig compiler emits C code targeting thumb-freestanding (the C backend does not require a matching architecture). A `sed` post-processing step fixes `static void const` declarations emitted by the C backend. SDCC compiles the C for the MCS-51 small memory model and links to produce an Intel HEX file. SFR register access requires a separate `sfr_access.c` file compiled by SDCC, since SDCC's `__sfr` extension is not available in standard C headers.

## Prerequisites

```bash
# SDCC -- Small Device C Compiler
sudo apt install sdcc

# stcgal -- STC ISP flash tool
pip install stcgal
```

## Build & Flash

```bash
cd stc89c52
zig build          # Build firmware (produces zig-out/firmware.ihx)
zig build flash    # Flash to STC89C52RC on /dev/ttyUSB0 via stcgal
```

Note: stcgal requires a power cycle on the STC device after running the flash command. The device must be unpowered when stcgal starts listening, then powered on to trigger the ISP sequence.

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, busy-wait 1ms tick loop (~230 iterations at 11.0592MHz) |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO initialization and LED interface for P1.0 |
| `gpio.zig` | P1 bit-bang GPIO driver via sfr_access.c |
| `uart.zig` | UART TX driver via SBUF/SFR accessors at 9600 baud |
| `sfr_access.c` | SDCC-compiled SFR register accessors (SCON, TMOD, TH1, SBUF) |
| `libc_stubs.c` | Minimal memcpy/memset for C backend output |
