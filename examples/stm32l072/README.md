# stm32l072 -- Zig on STM32L072

Bare-metal Zig firmware for the STM32L073RZ Nucleo board. Demonstrates the erd_core pub-sub framework running on an ultra-low-power Cortex-M0+ target with SysTick-driven 1ms timing, USART2 debug output via the ST-Link virtual COM port, and a WFI idle loop.

## Hardware

- **Board**: Nucleo-L073RZ
- **MCU**: STM32L073RZ -- ARM Cortex-M0+, 32 MHz max (running at 16 MHz HSI16 internal RC), 192KB flash, 20KB SRAM
- **LED**: PA5 -- LD2 (active-high, on-board green LED)
- **Serial**: USART2 TX on PA2 (AF4), 115200 baud (16 MHz HSI16 clock, BRR=139), routed to ST-Link virtual COM port

## What It Does

- **LED blink** via erd_core: SysTick fires every 1ms -> TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle on PA5
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **SysTick timing**: SysTick configured with reload 15999 (16 MHz / 16000 = 1kHz) calls `application.tick()` from the interrupt; the main loop calls `application.run()` and WFI

## Build Pipeline

```
Zig source -> Cortex-M0+ Thumb ELF (ReleaseSmall) -> stm32l072.ld linker script -> firmware.bin (objcopy)
```

Zig targets `thumb-freestanding-eabi` with the `cortex_m0plus` CPU model. The linker script places the vector table at flash origin `0x08000000`. `start.zig` provides `resetHandler` (.data copy, .bss zero) and wires SysTick to `main.sysTickHandler`. `atomic.zig` provides a bare-metal `__atomic_load_4` shim -- required because Cortex-M0+ lacks LDREX/STREX instructions.

## Prerequisites

```bash
# ST-Link flash tool
sudo apt install stlink-tools
```

## Build & Flash

```bash
cd stm32l072
zig build          # Build firmware ELF + firmware.bin + memory report
zig build flash    # Build and flash via st-flash (ST-Link on Nucleo)
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives PA5 GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `start.zig` | Cortex-M0+ vector table, resetHandler (.data copy, .bss zero), SysTick wiring |
| `main.zig` | Entry point: hardware init, application init, SysTick handler, WFI super-loop |
| `hardware.zig` | Board HAL: HSI16 clock switch, GPIO/USART2 clock enable, SysTick config (reload 15999), LED pin (PA5 active-high) |
| `application.zig` | erd_core wiring: SystemData, TimerModule, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (STM32L0 GPIO peripheral, MODER/OTYPER/BSRR, alternate function) |
| `uart.zig` | Minimal USART2 TX driver (PA2 AF4, 115200 baud) |
| `atomic.zig` | `__atomic_load_4` shim for Cortex-M0+ (PRIMASK-based interrupt disable) |
