# esp32c3 -- Zig on ESP32-C3

Bare-metal Zig firmware for the ESP32-C3-DevKitM-1, compiled directly to RISC-V without a C backend. Demonstrates the erd_core pub-sub framework running on the ESP32-C3 with LED blink and uptime tracking driven by the hardware SYSTIMER.

## Hardware

- **Board**: ESP32-C3-DevKitM-1
- **MCU**: Espressif ESP32-C3 -- RISC-V (RV32IMC), 160MHz, 400KB SRAM, 4MB flash
- **LED**: GPIO8 (active-high, onboard LED)
- **Serial**: UART0 on GPIO21 (TX only), 115200 baud (ROM bootloader default)

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback -> writes `erd_led_state` -> subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **SYSTIMER-based tick**: The super-loop polls the 16 MHz hardware SYSTIMER and feeds erd_core one tick per millisecond for accurate timer scheduling

## Build Pipeline

```
Zig source -> RISC-V ELF (riscv32-freestanding, RV32IMC) -> objcopy -> firmware.bin
```

Zig compiles directly to RISC-V without a C backend. The linker script `esp32c3.ld` places sections in IRAM and DRAM. The flat binary is flashed via `esptool.py`.

## Prerequisites

```bash
# esptool for flashing
pip install esptool
```

## Build & Flash

```bash
cd esp32c3
zig build          # Build firmware (produces zig-out/bin/firmware.bin)
zig build flash    # Flash to /dev/ttyUSB0 via esptool.py
```

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point, initializes hardware and application |
| `start.zig` | Reset handler and vector table for RISC-V bare-metal startup |
| `application.zig` | erd_core wiring: SystemData, timers, SYSTIMER-based super-loop |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `hardware.zig` | GPIO configuration and LED interface |
| `gpio.zig` | Register-level GPIO driver for ESP32-C3 |
| `uart.zig` | Minimal UART0 TX driver using ROM-initialized FIFO |
