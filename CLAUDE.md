# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a **multi-package monorepo** with five core Zig packages and firmware examples:

| Package | Path | Description |
|---------|------|-------------|
| **erd_core** | `erd_core/` | Core ERD/pub-sub framework - generic data components, system data, timer, subscriptions |
| **erd_schema** | `erd_schema/` | ERD serialization (JSON, future formats) - transforms Zig ERD types into consumable output |
| **data_gen** | `data_gen/` | Constraint-based data generation for property-based testing |
| **app** | `app/` | Demo application - wires ERD definitions to concrete components |
| **elf_size** | `elf_size/` | ELF section-size reporter for embedded firmware builds |

The `examples/` directory contains firmware target packages demonstrating erd_core on various microcontrollers:

| Target | Path | Description |
|--------|------|-------------|
| **esp8266** | `examples/esp8266/` | ESP8266 firmware via Zig C backend - WiFi scanning, erd_core integration, LED blink |
| **stm32f103** | `examples/stm32f103/` | STM32F103 Blue Pill (ARM Cortex-M3) |
| **stm32f407** | `examples/stm32f407/` | STM32F407 Discovery (ARM Cortex-M4F) |
| **nrf52840** | `examples/nrf52840/` | nRF52840-DK (ARM Cortex-M4F) |
| **rp2040** | `examples/rp2040/` | RP2040 Raspberry Pi Pico (ARM Cortex-M0+) |
| **samd51** | `examples/samd51/` | ATSAMD51 Metro M4 (ARM Cortex-M4F) |
| **stm32l072** | `examples/stm32l072/` | STM32L072 Nucleo (ARM Cortex-M0+) |
| **gd32vf103** | `examples/gd32vf103/` | GD32VF103 Longan Nano (RISC-V RV32IMAC) |
| **esp32c3** | `examples/esp32c3/` | ESP32-C3 (RISC-V RV32IMC) |
| **msp430** | `examples/msp430/` | MSP430G2553 LaunchPad (16-bit) |

## Build & Test Commands

```bash
# From root (workspace)
zig build                # Build app executable
zig build run            # Run app (generates ERD JSON output)
zig build test           # Run all tests across all packages
zig build test_coverage  # Run erd_core tests with all assertions enabled
zig build codegen-check  # Verify assembly snapshots haven't regressed
zig build codegen-update # Regenerate assembly snapshots
zig build emit-asm       # Emit raw assembly for inspection

# Per-package (cd into package directory)
cd erd_core && zig build test           # Core tests only
cd erd_schema && zig build test         # Schema tests only
cd data_gen && zig build test           # Data gen tests only
cd app && zig build run                 # Run app standalone
cd examples/esp8266 && zig build                 # Build ESP8266 firmware
cd examples/esp8266 && zig build flash           # Build and flash to ESP8266
cd examples/<target> && zig build                # Build any firmware target
```

## Architecture

This is a **typed publish-subscribe data system** for embedded/real-time Zig applications. It uses comptime-known ERD (Entity-Reference-Designator) definitions to achieve zero-cost abstractions over static memory.

### Core Concepts (erd_core)

**ERD (Entity-Reference-Designator)** - A named, typed data field with a 16-bit handle. Each ERD declares its type, owner, and subscription slot count at comptime.

**SystemData** - Top-level aggregator that owns data components and subscription arrays. Provides the public API: `read`, `write`, `modify`, `subscribe`, `unsubscribe`. Also has `runtimeRead`/`runtimeWrite` for dynamic ERD access. SystemData's comptime block rejects duplicate `erd_number` values in the ERD table.

**Data Components** own ERDs and provide storage:
- **RamDataComponent** (`erd_core/src/ram_data_component.zig`) - Packed byte-array storage with comptime-optimized reads/writes and on-change subscriptions.
- **IndirectDataComponent** (`erd_core/src/indirect_data_component.zig`) - Read-only computed values via function pointers.
- **ConvertedDataComponent** (`erd_core/src/converted_data_component.zig`) - Derived data computed from other ERDs via mappings.

**erd_table** (`erd_core/src/erd_table.zig`) - Comptime helpers for populating `ErdDefinitions` instances: `autofill` assigns `data_component_idx`/`system_data_idx`; `numErdsByComponent` and `collectByComponent` extract per-component ERD slices.

**erd_mapping** (`erd_core/src/erd_mapping.zig`) - Comptime helpers shared by IndirectDataComponent and ConvertedDataComponent for resolving ERD-to-function-pointer mappings.

**Subscription** - Fixed-size callback arrays per ERD, identity by function pointer.

### Timer Module

`erd_core/src/timer.zig` - Lightweight software scheduler using a sorted singly-linked list. Supports periodic and one-shot timers, pause/resume, and uses pointer alignment tricks (LSB stores `is_periodic` flag) for memory efficiency. Designed for tick-based embedded run-to-completion loops.

### ERD Schema (erd_schema)

`erd_schema/src/erd_json.zig` - Generic JSON serialization for any ERD definitions struct. Accepts any type whose fields are Erd types and produces JSON with name, id, and type information for ERDs that have an `erd_number`.

### Data Generation Framework (data_gen)

`data_gen/src/` - Constraint-based comptime validation of embedded system configurations. Provides four modules: `constraint` (primitive checks returning `?[]const u8`), `contract` (recursive `contractValidate` protocol on struct/array fields), `transform` (float->fixed-point/scaled-int conversions with exactness errors), `generator` (comptime array builders for lookup tables). Completely standalone (no dependencies beyond std).

### Application (app)

`app/src/system_erds.zig` - Application-specific ERD definitions. `app/src/app.zig` - Wires ERD definitions to concrete data component implementations. `app/src/main.zig` - Entry point that dumps ERD definitions as JSON.

## Testing

Each package has its own tests aggregated via `src/root.zig` test blocks. The root `zig build test` runs all packages. The `assert_sometimes` dependency provides assertions that can be toggled: disabled in `test` step (for binary size), enabled in `test_coverage` step (full assertion coverage).

## Dependencies

- **erd_core** depends on `assert_sometimes` (external, via git)
- **erd_schema** depends on `erd_core` (path dep)
- **data_gen** has no dependencies
- **app** depends on `erd_core` and `erd_schema` (path deps)
- **elf_size** has no dependencies (standalone CLI + library)
- **examples/esp8266** depends on `erd_core` (via C backend `--dep`/`-M` flags), ESP8266 NonOS SDK 2.2.1 (git cloned to `examples/esp8266/sdk/`, gitignored), `xtensa-lx106-elf-gcc` (apt), `esptool` (apt)
- **examples/<target>** - native LLVM firmware targets depend on `erd_core` and `elf_size` (path deps)

## Code Style

- **Keep it ASCII only, no em/en dashes, etc.**
- **Do use file level doc comments.** Use `//!` at the top of every file 
- **Preserve doc comments.** Do not remove or rewrite existing `///` doc comments when modifying code. Update them if the behavior changes, but never delete them.

## Codegen Snapshots

After making changes to data components, system_data, or subscription logic, run `zig build codegen-check` to verify assembly snapshots haven't regressed. If there are intentional changes, update with `zig build codegen-update`. Snapshot files live in `erd_core/codegen/`.

## Linting

Before committing, run `zig build lint` from the repo root to check for style violations (import ordering, redundant comptime, naming conventions). Fix all errors and warnings before committing.

## Formatting

After completing any code changes, run `zig fmt erd_core/src/ erd_schema/src/ data_gen/src/ app/src/ elf_size/src/ examples/esp8266/src/ examples/esp8266/build.zig` to format all packages before reporting results.
