# stm32f103 -- Zig on STM32F103

Bare-metal Zig firmware for the STM32F103C8T6 (Blue Pill). Demonstrates the erd_core pub-sub framework running on a Cortex-M3 target with no OS, direct register access, and a software timer loop.

## Hardware

- **Board**: Blue Pill (STM32F103C8T6 development board)
- **MCU**: STM32F103C8T6 -- ARM Cortex-M3, 72 MHz max (running at 8 MHz HSI default), 64KB flash, 20KB SRAM
- **LED**: PC13 (active-low, on-board green LED)
- **Serial**: USART1 TX on PA9, 115200 baud (8 MHz HSI clock, BRR=69)

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> Cortex-M3 Thumb ELF (ReleaseSmall) -> stm32f103.ld linker script -> firmware.bin (objcopy)
```

Zig targets `thumb-freestanding-none` with the `cortex_m3` CPU model. The linker script places the vector table at flash origin `0x08000000`. The `start.zig` reset handler copies `.data` from flash to SRAM and zeros `.bss` before calling `main`.

## Prerequisites

```bash
# ST-Link flash tool (choose one)
sudo apt install stlink-tools   # for st-flash
sudo apt install openocd        # for openocd
```

## Build & Flash

```bash
cd stm32f103
zig build             # Build firmware ELF + firmware.bin + memory report
zig build flash       # Build and flash via st-flash (ST-Link)
zig build openocd     # Build and flash via OpenOCD
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `start.zig` | Cortex-M3 vector table, reset handler (.data copy, .bss zero), panic handler |
| `main.zig` | Entry point: hardware init, application init, super-loop |
| `hardware.zig` | Board HAL: GPIO pin assignments, LED control (PC13 active-low) |
| `application.zig` | erd_core wiring: SystemData, TimerModule, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (CRL/CRH config, BSRR/BRR set/clear) |
| `rcc.zig` | RCC register definitions and clock-enable helpers |
| `uart.zig` | Minimal USART1 TX driver (PA9, 115200 baud) |
