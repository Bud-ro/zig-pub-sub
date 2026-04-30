# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a **multi-package monorepo** with four Zig packages:

| Package | Path | Description |
|---------|------|-------------|
| **erd_core** | `erd_core/` | Core ERD/pub-sub framework - generic data components, system data, timer, subscriptions |
| **erd_schema** | `erd_schema/` | ERD serialization (JSON, future formats) - transforms Zig ERD types into consumable output |
| **data_gen** | `data_gen/` | Constraint-based data generation for property-based testing |
| **app** | `app/` | Demo application - wires ERD definitions to concrete components |

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
```

## Architecture

This is a **typed publish-subscribe data system** for embedded/real-time Zig applications. It uses comptime-known ERD (Entity-Reference-Designator) definitions to achieve zero-cost abstractions over static memory.

### Core Concepts (erd_core)

**ERD (Entity-Reference-Designator)** - A named, typed data field with a 16-bit handle. Each ERD declares its type, owner, and subscription slot count at comptime.

**SystemData** - Top-level aggregator that owns data components and subscription arrays. Provides the public API: `read`, `write`, `subscribe`, `unsubscribe`, `publish`. Also has `runtime_read`/`runtime_write` for dynamic ERD access.

**Data Components** own ERDs and provide storage:
- **RamDataComponent** (`erd_core/src/ram_data_component.zig`) - Packed byte-array storage with comptime-optimized reads/writes and on-change subscriptions.
- **IndirectDataComponent** (`erd_core/src/indirect_data_component.zig`) - Read-only computed values via function pointers.
- **ConvertedDataComponent** (`erd_core/src/converted_data_component.zig`) - Derived data computed from other ERDs via mappings.

**Subscription** - Fixed-size callback arrays per ERD, identity by function pointer.

### Timer Module

`erd_core/src/timer.zig` - Lightweight software scheduler using a sorted singly-linked list. Supports periodic and one-shot timers, pause/resume, and uses pointer alignment tricks (LSB stores `is_periodic` flag) for memory efficiency. Designed for tick-based embedded run-to-completion loops.

### ERD Schema (erd_schema)

`erd_schema/src/erd_json.zig` - Generic JSON serialization for any ERD definitions struct. Accepts any type whose fields are Erd types and produces JSON with name, id, and type information for ERDs that have an `erd_number`.

### Data Generation Framework (data_gen)

`data_gen/src/` - Constraint-based data generation for property-based testing. Completely standalone (no dependencies beyond std).

### Application (app)

`app/src/system_erds.zig` - Application-specific ERD definitions. `app/src/app.zig` - Wires ERD definitions to concrete data component implementations. `app/src/main.zig` - Entry point that dumps ERD definitions as JSON.

## Testing

Each package has its own tests aggregated via `src/root.zig` test blocks. The root `zig build test` runs all packages. The `assert_sometimes` dependency provides assertions that can be toggled: disabled in `test` step (for binary size), enabled in `test_coverage` step (full assertion coverage).

## Dependencies

- **erd_core** depends on `assert_sometimes` (external, via git)
- **erd_schema** depends on `erd_core` (path dep)
- **data_gen** has no dependencies
- **app** depends on `erd_core` and `erd_schema` (path deps)

## Code Style

- **Preserve doc comments.** Do not remove or rewrite existing `///` doc comments when modifying code. Update them if the behavior changes, but never delete them.

## Codegen Snapshots

After making changes to data components, system_data, or subscription logic, run `zig build codegen-check` to verify assembly snapshots haven't regressed. If there are intentional changes, update with `zig build codegen-update`. Snapshot files live in `erd_core/codegen/`.

## Formatting

After completing any code changes, run `zig fmt erd_core/src/ erd_schema/src/ data_gen/src/ app/src/` to format all packages before reporting results.
