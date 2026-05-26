# atmega328p -- Zig on ATmega328P

Bare-metal Zig firmware for the Arduino Uno (ATmega328P), compiled directly to AVR without a C backend. Demonstrates the erd_core pub-sub framework on an 8-bit AVR with LED blink and uptime tracking driven by Timer0.

## Hardware

- **Board**: Arduino Uno (ATmega328P)
- **MCU**: Atmel ATmega328P -- 8-bit AVR, 16MHz, 32KB flash, 2KB SRAM
- **LED**: PB5 / Arduino pin 13 (active-high, onboard LED)
- **Serial**: USART0 on PD1 (TX only), 9600 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **Timer0 tick source**: Timer0 runs in CTC mode with prescaler /64 (250 kHz), generating a 1ms compare-match tick that drives the erd_core TimerModule

## Build Pipeline

```
Zig source -> AVR ELF (avr-freestanding, atmega328p) -> objcopy -> firmware.hex (Intel HEX)
```

Zig compiles directly to AVR without a C backend. The standard AVR startup sequence is handled in Zig. The compiler-rt is built at ReleaseSmall to fit in 32KB flash.

## Prerequisites

```bash
# AVR programmer and flash tool
sudo apt install avrdude
```

## Build & Flash

```bash
cd atmega328p
zig build          # Build firmware (produces zig-out/bin/firmware.hex)
zig build flash    # Flash to Arduino Uno on /dev/ttyACM0 via avrdude
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, Timer0 CTC setup, 1ms super-loop |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO configuration and LED interface for PB5 |
| `gpio.zig` | Register-level AVR Port B/C/D GPIO driver |
| `uart.zig` | Minimal USART0 TX driver at 9600 baud |
