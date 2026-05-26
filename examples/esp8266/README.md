# esp8266 — Zig on ESP8266 via C Backend

Bare-metal Zig firmware for the ESP8266, compiled through Zig's C backend and linked against the ESP8266 NonOS SDK. Demonstrates the erd_core pub-sub framework running on real embedded hardware with WiFi.

## Hardware

- **Board**: HiLetGo NodeMCU ESP8266 (ESP-12F module)
- **MCU**: ESP8266EX — Xtensa LX106, 80MHz, 80KB DRAM, 32KB IRAM, 4MB SPI flash
- **LED**: GPIO2 (active-low, built-in blue LED)
- **Serial**: CH340 USB-to-UART, 74880 baud (matches ROM boot output)
- **Connection**: USB via WSL2 + usbipd-win for `/dev/ttyUSB0` passthrough

## What It Does

- **LED blink** via erd_core: TimerModule fires a 500ms periodic callback → writes `erd_led_state` → subscription triggers GPIO toggle
- **Uptime counter**: 1-second periodic timer increments `erd_uptime_seconds`
- **WiFi scanner**: Station mode, scans nearby APs every 10 seconds, prints SSID / channel / RSSI / auth mode to UART

## Build Pipeline

```
Zig source → C backend (-ofmt=c) → sed fixup → xtensa-lx106-elf-gcc (-Os) → link with SDK libs → esptool elf2image → flash
```

The Zig compiler emits C code for the xtensa-freestanding target. A `sed` post-processing step fixes `static void const` declarations that the C backend emits for comptime-only types (Zig C backend limitation). The C is then compiled with the apt-provided `xtensa-lx106-elf-gcc` and linked against ESP8266 NonOS SDK 2.2.1 static libraries.

## Prerequisites

```bash
# Xtensa cross-compiler and flash tool
sudo apt install gcc-xtensa-lx106 binutils-xtensa-lx106 esptool

# ESP8266 NonOS SDK (auto-fetched by `zig build` if missing, or clone manually)
cd esp8266
git clone --depth 1 --branch v2.2.1 https://github.com/espressif/ESP8266_NONOS_SDK.git sdk

# USB passthrough (WSL2 only)
# Install usbipd-win on Windows, then:
#   usbipd bind --busid <X-X>
#   usbipd attach --wsl --busid <X-X>
# Device appears as /dev/ttyUSB0
```

## Build & Flash

```bash
cd esp8266
zig build          # Build firmware (produces zig-out/firmware_0x00000.bin + 0x10000.bin)
zig build flash    # Build and flash to /dev/ttyUSB0
```

## Serial Monitor

The ESP8266 ROM and SDK both output at 74880 baud:

```bash
python3 -c "
import serial, time
s = serial.Serial('/dev/ttyUSB0', 74880)
while True:
    if s.in_waiting:
        print(s.read(s.in_waiting).decode('ascii', errors='replace'), end='')
    time.sleep(0.1)
"
```

## SDK Details

Uses **NonOS SDK 2.2.1** (not 3.0+). Key reasons:
- SDK 3.0's `system_partition_table_regist` API doesn't work with the apt-provided xtensa-gcc
- SDK 2.2.1 uses the simpler `user_rf_cal_sector_set` entry point
- Version 1 image format (no second-stage bootloader required)

## ERD Definitions

| ERD | Type | Description |
|-----|------|-------------|
| `erd_uptime_seconds` | `u32` | Seconds since boot |
| `erd_led_state` | `bool` | LED on/off (subscription drives GPIO) |
| `erd_wifi_mode` | `WifiMode` | AP or station |
| `erd_wifi_status` | `WifiStatus` | Connection state |
| `erd_wifi_ip_addr` | `u32` | IP address (little-endian) |
| `erd_http_request_count` | `u32` | HTTP request counter (for future HTTP server) |

## Module Structure

| File | Purpose |
|------|---------|
| `main.zig` | Entry point (`user_init`), system init callback |
| `hardware.zig` | GPIO setup, LED control |
| `application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `system_erds.zig` | ERD definitions following erd_core patterns |
| `wifi.zig` | WiFi scanner with periodic scan and UART output |
| `sdk.zig` | ESP8266 NonOS SDK extern declarations and struct layouts |
| `gpio.zig` | Register-level GPIO with pin mux configuration |
| `uart.zig` | Minimal UART0 driver for debug output |
| `libc_stubs.c` | Minimal memcpy/memset for C backend output |

## Known Limitations

- The `sed` fixup for `static void const` is fragile — depends on exact C backend output format
- WiFi scan output can interleave with SDK's own `scandone` print
- BssInfo struct padding may be slightly off for some AP entries
