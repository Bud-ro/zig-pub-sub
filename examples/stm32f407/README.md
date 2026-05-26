# stm32f407 -- Zig on STM32F407

Bare-metal Zig firmware for the STM32F407VGT6 Discovery board. Demonstrates the erd_core pub-sub framework running on a Cortex-M4F target with four user LEDs, USART2 debug output via the ST-Link virtual COM port, and a software timer super-loop.

## Hardware

- **Board**: STM32F407G-DISC1 (Discovery)
- **MCU**: STM32F407VGT6 -- ARM Cortex-M4F, 168 MHz max (running at 16 MHz HSI default), 1MB flash, 128KB SRAM + 64KB CCM
- **LED**: PD12 green (primary blink, active-high); also PD13 orange, PD14 red, PD15 blue
- **Serial**: USART2 TX on PA2 (AF7), 115200 baud (16 MHz HSI clock, BRR=0x8B), routed to ST-Link virtual COM port

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle on PD12 (green)
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> Cortex-M4 Thumb ELF (configurable optimize) -> stm32f407.ld linker script -> stm32f407.bin (objcopy)
```

Zig targets `thumb-freestanding-eabi` with the `cortex_m4` CPU model. The linker script places `.isr_vector` at flash origin `0x08000000`. `start.zig` exports the vector table and `Reset_Handler` which copies `.data` from flash to SRAM and zeros `.bss` before calling `main`.

## Prerequisites

```bash
# ST-Link flash tool
sudo apt install stlink-tools
```

## Build & Flash

```bash
cd stm32f407
zig build          # Build firmware ELF + stm32f407.bin
zig build flash    # Build and flash via st-flash (ST-Link)
zig build mem      # Print memory usage report
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives PD12 GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point: hardware init, application init, busy-wait super-loop |
| `start.zig` | Cortex-M4 vector table, Reset_Handler (.data copy, .bss zero) |
| `hardware.zig` | Board HAL: LED pin assignments (PD12-15 active-high), GPIO init |
| `application.zig` | erd_core wiring: SystemData, TimerModule, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (MODER/OTYPER/OSPEEDR/PUPDR, BSRR) |
| `rcc.zig` | RCC AHB1/APB1/APB2 clock-enable helpers |
| `uart.zig` | Minimal USART2 TX driver (PA2 AF7, 115200 baud) |
