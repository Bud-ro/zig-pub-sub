# msp430 -- Zig on MSP430G2553

Bare-metal Zig firmware for the TI MSP430G2553 LaunchPad, compiled directly to MSP430 without a C backend. Demonstrates the erd_core pub-sub framework on a 16-bit ultra-low-power MCU with LED blink and uptime tracking driven by Timer_A.

## Hardware

- **Board**: TI MSP430G2553 LaunchPad (MSP-EXP430G2)
- **MCU**: Texas Instruments MSP430G2553 -- 16-bit MSP430, 16MHz max (1 MHz calibrated DCO), 16KB flash, 512B SRAM
- **LED**: P1.0 (active-high, red LED)
- **Serial**: USCI_A0 on P1.2 (TX only), 9600 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **Timer_A tick source**: The super-loop polls Timer_A0 running in continuous mode from SMCLK (1 MHz) and feeds erd_core one tick per millisecond

## Build Pipeline

```
Zig source -> MSP430 ELF (msp430-freestanding) -> objcopy -> firmware.hex (Intel HEX)
```

Zig compiles directly to MSP430 without a C backend. The linker script `msp430.ld` places sections in the correct flash and RAM regions. The compiler-rt bundle is disabled to avoid a known Zig 0.16 sqrt bug on 16-bit targets.

## Prerequisites

```bash
# MSP430 debug and flash tool
sudo apt install mspdebug
```

## Build & Flash

```bash
cd msp430
zig build          # Build firmware (produces zig-out/bin/firmware.hex)
zig build flash    # Flash to LaunchPad via mspdebug rf2500
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, DCO calibration, Timer_A setup, super-loop |
| `start.zig` | Reset vector, interrupt vector table, .bss/.data initialization |
| `builtins.zig` | Minimal compiler-rt stubs for 16-bit arithmetic |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO configuration and LED interface for P1.0 |
| `gpio.zig` | Register-level Port 1 GPIO driver |
| `uart.zig` | Minimal USCI_A0 TX driver at 9600 baud |
