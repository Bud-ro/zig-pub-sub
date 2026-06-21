# rp2040 -- Zig on RP2040

Bare-metal Zig firmware for the Raspberry Pi Pico (RP2040). Demonstrates the erd_core pub-sub framework running on a Cortex-M0+ target with direct register access, a busy-wait timer loop, and UART0 debug output over USB-UART.

## Hardware

- **Board**: Raspberry Pi Pico
- **MCU**: RP2040 -- dual ARM Cortex-M0+, 133 MHz max (running on ~6.5 MHz ring oscillator default), 2MB flash (external QSPI), 256KB SRAM
- **LED**: GPIO25 (active-high, on-board green LED)
- **Serial**: UART0 TX on GPIO0 (physical pin 1), 115200 baud (IBRD=3, FBRD=34 for ~6.5 MHz ROSC)

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle on GPIO25
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> Cortex-M0+ Thumb ELF -> rp2040.ld linker script -> firmware.bin (objcopy)
```

Zig targets `thumb-freestanding-none` with the `cortex_m0plus` CPU model. The linker script places the vector table at flash origin `0x10000000`. `start.zig` provides the reset handler (.data copy, .bss zero) and a bare-metal `__atomic_load_4` implementation -- required because Cortex-M0+ has no native 32-bit atomic instructions and erd_core's timer module emits an atomic load.

## Prerequisites

```bash
# picotool for USB flashing
sudo apt install picotool
```

## Build & Flash

```bash
cd rp2040
zig build          # Build firmware ELF + firmware.bin + memory report
zig build flash    # Load firmware via picotool (hold BOOTSEL, plug USB first)
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO25) |

## Module Structure

| File | Purpose |
|------|---------|
| `start.zig` | Cortex-M0+ vector table, reset handler (.data copy, .bss zero), `__atomic_load_4` shim |
| `main.zig` | Entry point: hardware init, application init, busy-wait super-loop |
| `hardware.zig` | Board HAL: GPIO subsystem init, LED pin assignment (GPIO25 active-high) |
| `application.zig` | erd_core wiring: SystemData, TimerModule, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (RP2040 IO_BANK0 + SIO, subsystem reset) |
| `uart.zig` | Minimal UART0 TX driver (GPIO0, 115200 baud, ROSC clock) |
