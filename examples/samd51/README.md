# samd51 -- Zig on SAMD51

Bare-metal Zig firmware for the Adafruit Metro M4 (ATSAMD51J19A). Demonstrates the erd_core pub-sub framework running on a Cortex-M4F target with SysTick-driven 1ms timing, SERCOM5 USART debug output, and a fully interrupt-driven idle loop.

## Hardware

- **Board**: Adafruit Metro M4 Express
- **MCU**: ATSAMD51J19A -- ARM Cortex-M4F, 120 MHz max (running at 48 MHz DFLL default), 512KB flash, 192KB SRAM
- **LED**: PA16 (active-high, on-board red LED)
- **Serial**: SERCOM5 USART TX on PA22 (pad 0), RX on PA23 (pad 1), 115200 baud (48 MHz GCLK0, BAUD=63019). Connected to Metro M4 TX/RX header pins.

## What It Does

- **LED blink** via erd_core: SysTick fires every 1ms -> TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle on PA16
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **SysTick timing**: SysTick configured with reload 47999 (48 MHz / 48000 = 1kHz) calls `application.tick()` which drives the entire timer module from the interrupt

## Build Pipeline

```
Zig source -> Cortex-M4 Thumb ELF (entry: Reset_Handler) -> samd51.ld linker script -> firmware.bin (objcopy)
```

Zig targets `thumb-freestanding-eabi` with the `cortex_m4` CPU model. The linker script places the vector table at flash origin `0x00000000`. `start.zig` provides `Reset_Handler` (.data copy, .bss zero) and wires the SysTick vector to `main.SysTick_Handler`. The bootloader occupies the first 16KB (0x4000), so bossac flashes at that offset.

## Prerequisites

```bash
# bossac for USB flashing (Adafruit bootloader)
sudo apt install bossa-cli
# or download from: https://github.com/shumatech/BOSSA
```

## Build & Flash

```bash
cd samd51
zig build          # Build firmware ELF + firmware.bin + memory report
zig build flash    # Flash via bossac to /dev/ttyACM0 at offset 0x4000
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives PA16 GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `start.zig` | Cortex-M4 vector table, Reset_Handler (.data copy, .bss zero), SysTick wiring |
| `main.zig` | Entry point: hardware init, SysTick config (reload 47999), WFI idle loop, SysTick_Handler |
| `hardware.zig` | Board HAL: LED pin assignment (PA16 active-high) |
| `application.zig` | erd_core wiring: SystemData, TimerModule, LED blink and uptime timers |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `gpio.zig` | Register-level GPIO driver (SAMD51 PORT peripheral, DIRSET/OUTSET/OUTCLR, PMUX) |
| `uart.zig` | SERCOM5 USART TX driver (PA22 pad 0, 115200 baud, GCLK0 48 MHz) |
