# gd32vf103 -- Zig on GD32VF103

Bare-metal Zig firmware for the Sipeed Longan Nano board, compiled directly to RISC-V without a C backend. Demonstrates the erd_core pub-sub framework running on the GD32VF103 with LED blink and uptime tracking.

## Hardware

- **Board**: Sipeed Longan Nano
- **MCU**: GigaDevice GD32VF103CBT6 -- RISC-V (RV32IMAC), 108MHz, 128KB flash, 32KB SRAM
- **LED**: PC13 (active-low, red LED)
- **Serial**: USART0 on PA9 (TX only), 115200 baud

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`

## Build Pipeline

```
Zig source -> RISC-V ELF (riscv32-freestanding, RV32IMAC) -> objcopy -> firmware.bin
```

Zig compiles directly to RISC-V without a C backend. The linker script `gd32vf103.ld` places sections in flash and SRAM. The binary is produced with `objcopy` and flashed via DFU.

## Prerequisites

```bash
# DFU flashing utility
sudo apt install dfu-util
```

The Longan Nano must be put into DFU mode by holding BOOT0 and pressing RESET before flashing.

## Build & Flash

```bash
cd gd32vf103
zig build          # Build firmware (produces zig-out/bin/firmware.bin)
zig build flash    # Flash to Longan Nano via dfu-util
zig build mem      # Print flash/RAM usage report
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, busy-wait tick loop (~1ms per iteration) |
| `start.zig` | Reset handler and vector table for RISC-V bare-metal startup |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO clock enable and LED pin configuration |
| `gpio.zig` | Register-level GPIO driver for GD32VF103 |
| `uart.zig` | Minimal USART0 TX driver for debug output |
