# nrf52840 -- Zig on nRF52840

Bare-metal Zig firmware for the nRF52840-DK. Demonstrates the erd_core pub-sub framework running on a Cortex-M4 target with SysTick-driven 1ms timing, EasyDMA UARTE debug output, and an interrupt-driven run-to-completion super-loop.

## Hardware

- **Board**: nRF52840-DK (PCA10056)
- **MCU**: nRF52840 -- ARM Cortex-M4F, 64 MHz HFCLK (default internal oscillator), 1MB flash, 256KB RAM
- **LED**: P0.13 -- LED1 (active-low, on-board green LED)
- **Serial**: UARTE0 TX on P0.06, 115200 baud (BAUDRATE=0x01D7E000), EasyDMA single-byte polling mode

## What It Does

- **LED blink** via erd_core: SysTick fires every 1ms -> TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **SysTick timing**: Cortex-M SysTick configured with reload 63999 (64 MHz / 64000 = 1kHz) drives `timer_module.incrementCurrentTime(1)` from the interrupt handler

## Build Pipeline

```
Zig source -> Cortex-M4 Thumb ELF -> nrf52840.ld linker script -> firmware.bin + firmware.hex (objcopy)
```

Zig targets `thumb-freestanding-none` with the `cortex_m4` CPU model. The vector table is placed at flash origin `0x00000000`. `start.zig` provides the reset handler (.data copy, .bss zero) and wires the SysTick vector to `application.sysTickHandler`.

## Prerequisites

```bash
# Nordic command-line tools (nrfjprog)
# Download from: https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools
# Or via apt for some distributions:
sudo apt install nrf-command-line-tools
```

## Build & Flash

```bash
cd nrf52840
zig build          # Build firmware ELF + firmware.bin + firmware.hex + memory report
zig build flash    # Build and flash via nrfjprog (J-Link on DK)
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives P0.13 GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `start.zig` | Cortex-M4 vector table, reset handler (.data copy, .bss zero), SysTick wiring |
| `main.zig` | Entry point: hardware init, application init, WFI super-loop |
| `hardware.zig` | Board HAL: LED pin assignment (P0.13 active-low) |
| `application.zig` | erd_core wiring: SystemData, TimerModule, SysTick config, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (nRF52840 GPIO peripheral, P0 port) |
| `uart.zig` | Minimal UARTE0 EasyDMA TX driver (P0.06, 115200 baud) |
