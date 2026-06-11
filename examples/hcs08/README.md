# hcs08 -- Zig + erd_core on MC9S08QE8 (HCS08) via C Backend + SDCC

Bare-metal Zig firmware for the Freescale/NXP MC9S08QE8 (DEMO9S08QE8 board),
compiled through Zig's C backend and then assembled by SDCC for the HC08
architecture.  Uses the erd_core pub-sub framework for LED blink via
subscription callbacks and uptime tracking via periodic software timers.

## Hardware

- **Board**: DEMO9S08QE8 evaluation board
- **MCU**: Freescale MC9S08QE8 -- HCS08 8-bit, 4MHz bus clock (FEI mode), 8KB flash, 256B RAM
- **LED**: PTA0 (active-high, onboard LED)
- **Serial**: SCI on PTB0 (TX only), 9600 baud

## What It Does

- **LED blink**: toggles PTA0 every ~500ms via erd_core timer + subscription
- **Uptime counter**: prints seconds since boot to UART every ~1s via erd_core timer

The LED state is an ERD (`erd_led_state`) with a subscription that drives the
hardware pin.  Writing to the ERD fires `onLedStateChanged`, which calls
`hardware.setLed()`.  Two periodic erd_core timers drive the blink (500ms) and
uptime print (1000ms).

## Build Pipeline

```
Zig source + erd_core
  -> C backend (-ofmt=c, thumb-freestanding proxy target)
  -> cp to zig-out/firmware.c
  -> scripts/patch_c_for_sdcc.py  (13-category SDCC fixup)
  -> SDCC (-mhc08 --model-large --stack-auto)
  -> link
  -> firmware.ihx (Intel HEX)
```

The Python post-processor (`scripts/patch_c_for_sdcc.py`) handles 13 categories
of SDCC incompatibilities in the Zig C backend output:

1. Replaces `#include "zig.h"` with `zig_sdcc_shim.h`
2. Fixes `static void const` to `static char const`
3. Removes `zig_static_assert` lines
4. Fixes empty array initializers `{}` to `{0}`
5. Removes unused `zig_errorName[0]` array
6. Strips designated initializers (`.field = expr`)
7. Removes unused comptime metadata (Target, CallingConvention, bitsets)
8. Simplifies nested pointer cast chains in static initializers
9. Replaces GCC inline asm with SDCC inline asm
10. Strips top-level `const` from function parameters
11. Replaces compound literals with file-scope static consts
12. Makes labels unique per function (SDCC duplicate label bug)
13. Converts struct-by-value params/returns to pointers (the key fix for erd_core)

SFR register access uses a separate `sfr_access.c` compiled directly by SDCC,
since SDCC's `__at` syntax for HCS08 absolute-addressed SFRs is not available
in standard C.

## Prerequisites

```bash
# SDCC -- Small Device C Compiler (4.x with hc08 support)
sudo apt install sdcc

# Python 3 (for patch_c_for_sdcc.py post-processor)
# Usually already available

# USBDM debugger/programmer for HCS08 (optional, for flashing)
# https://sourceforge.net/projects/usbdm/
```

## Build & Flash

```bash
cd hcs08
zig build          # Build firmware (produces zig-out/firmware.ihx)
zig build flash    # Flash to MC9S08QE8 via USBDM
```

## Memory Usage

With erd_core, the firmware compiles and links successfully but exceeds the
MC9S08QE8's 8KB flash:

| Section | Size | Description |
|---------|------|-------------|
| CSEG    | 8,969 B | Code |
| XINIT   | 2,102 B | Initialized data (in flash) |
| CONST   | 291 B   | Constants |
| GSINIT  | 33 B    | Init code |
| **Total flash** | **11,395 B (11.1 KB)** | **Exceeds 8 KB by 3.1 KB** |
| XSEG+DSEG | 45 B | RAM (fits in 256 B) |

The largest contributor to flash usage is the `main_app` variable's
`undefined` initialization pattern (Zig fills `undefined` with `0xAA` bytes).
The erd_core `SystemData` struct contains subscription arrays and the RAM
data component's byte-array storage, all filled with 0xAA at init.

### Larger HCS08 Variants That Would Fit

| Chip | Flash | RAM | Fits? |
|------|-------|-----|-------|
| MC9S08QE8  | 8 KB  | 256 B | No (needs 11.1 KB) |
| MC9S08QE16 | 16 KB | 512 B | Yes |
| MC9S08QE32 | 32 KB | 1 KB  | Yes |
| MC9S08QE64 | 60 KB | 4 KB  | Yes |

The MC9S08QE16 is the smallest HCS08 QE-family variant that can fit the
erd_core firmware.  All QE-family parts are pin-compatible, so switching from
QE8 to QE16 requires only a chip swap and updated linker memory map.

## Module Structure

| File | Purpose |
|------|---------|
| `src/main.zig` | Entry point, busy-wait 1ms tick loop |
| `src/application.zig` | erd_core wiring: SystemData, timers, subscriptions |
| `src/system_erds.zig` | ERD definitions (erd_uptime_seconds, erd_led_state) |
| `src/hardware.zig` | COP watchdog disable, GPIO setup, LED interface for PTA0 |
| `src/gpio.zig` | Port A/B GPIO driver via sfr_access.c |
| `src/uart.zig` | SCI TX driver at 9600 baud via sfr_access.c |
| `src/sfr_access.c` | SDCC-compiled SFR register accessors (SOPT1, PTADD, SCI) |
| `src/libc_stubs.c` | Minimal memcpy/memset for C backend output |
| `src/zig_sdcc_shim.h` | Minimal zig.h replacement for SDCC |
| `scripts/patch_c_for_sdcc.py` | Post-processor: Zig C output -> SDCC-compatible C |
