# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
zig build                # Build executable
zig build run            # Run (generates ERD JSON output)
zig build test           # Run unit tests (sometimes-assertions disabled)
zig build test_coverage  # Run tests with all assertions enabled
zig build test_no_run    # Build tests without running
```

All test steps run across four optimization modes: Debug, ReleaseSafe, ReleaseSmall, ReleaseFast.

## Architecture

This is a **typed publish-subscribe data system** for embedded/real-time Zig applications. It uses comptime-known ERD (Entity-Reference-Descriptor) definitions to achieve zero-cost abstractions over static memory.

### Core Concepts

**ERD (Entity-Reference-Descriptor)** - A named, typed data field with a unique 16-bit handle. Each ERD declares its type, owner, and subscription slot count at comptime. Defined in `src/system_erds.zig`.

**Data Components** own ERDs and provide storage:
- **RamDataComponent** (`src/ram_data_component.zig`) - Stores values in a packed byte array. Comptime reads/writes compile to direct loads/stores. Fires on-change subscriptions on write.
- **IndirectDataComponent** (`src/indirect_data_component.zig`) - Read-only computed data via function pointers. No writes allowed (compile error).

**SystemData** (`src/system_data.zig`) - Top-level aggregator that owns both data components and the subscription arrays. Provides the public API: `read`, `write`, `subscribe`, `unsubscribe`, `publish`. Also has `runtime_read`/`runtime_write` for dynamic ERD access via `system_data_idx`.

**Subscriptions** - Fixed-size arrays per ERD (slot count from `.subs` field at comptime). Callbacks receive `(?*anyopaque, *OnChangeArgs, *SystemData)`. Identity is by function pointer; no duplicates per ERD.

### Timer Module

`src/timer.zig` - Lightweight software scheduler using a sorted singly-linked list. Supports periodic and one-shot timers, pause/resume, and uses pointer alignment tricks (LSB stores `is_periodic` flag) for memory efficiency. Designed for tick-based embedded run-to-completion loops.

### Data Generation Framework

`src/data_gen/` - Constraint-based data generation for property-based testing. Separate from the pub-sub core but included in the test suite.

## Testing

Tests live in `src/tests/` and are aggregated via `src/unit_tests.zig` using comptime imports. The `assert_sometimes` dependency provides assertions that can be toggled: disabled in `test` step (for binary size), enabled in `test_coverage` step (full assertion coverage). CI runs both modes on Ubuntu and Windows.

## Dependencies

Managed via `build.zig.zon`. Single dependency: `assert_sometimes`, imported as `"sometimes"` in source. This is a code coverage tool, not a traditional assertion library — it verifies that both the true and false branches of a condition are exercised across test runs. The `test` step disables these checks; `test_coverage` enables them.

## Current Limitations

This repo is early-stage and not yet cleanly usable as a library. Key issues:

- **`system_erds.zig`** defines the ERD table for a specific application. To use this framework in a new project, you'd need to copy and customize this file.
- **`system_data.zig`** conflates two concerns: the public interface (read/write/subscribe) and the structural wiring of data components. These should eventually be separated so the interface is reusable without dictating component choices.
- **`src/common/`** contains utilities generic enough to extract into a standalone library, but still has coupling to project-specific types.
