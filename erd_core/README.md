# erd_core

Core framework for a typed publish-subscribe data system targeting embedded/real-time Zig applications.

## What's in here

- **ERD** (`erd.zig`) — Entity-Reference-Descriptor type: a named, typed data field with a 16-bit handle
- **RamDataComponent** — Packed byte-array storage with comptime-optimized reads/writes and on-change subscriptions
- **IndirectDataComponent** — Read-only computed values via function pointers
- **ConvertedDataComponent** — Derived data computed from other ERDs via mappings
- **SystemData** — Top-level aggregator binding multiple data components into one namespace with `read`/`write`/`subscribe`/`publish` APIs
- **Subscription** — Fixed-size callback arrays per ERD, identity by function pointer
- **Timer** — Lightweight software scheduler (periodic/one-shot) for tick-based run-to-completion loops
- **testing** — Test double infrastructure (`SystemDataTestDouble`) for creating standalone test ERD systems

Utilities in `common/`: `erd_logic`, `stopwatch`, `timer_stats`.

## Usage

```zig
const erd_core = @import("erd_core");

const MyErds = struct {
    sensor: erd_core.Erd = .{ .erd_number = 0x0000, .T = u16, .component_idx = 0, .subs = 1 },
};

const Ram = erd_core.RamDataComponent(&my_defs);
const SD = erd_core.SystemData(MyErds, MyEnum, my_erds, Components);
```

## Build

```bash
zig build test           # Run unit tests
zig build test_coverage  # Run with sometimes-assertion coverage
zig build codegen-check  # Verify assembly snapshots
zig build emit-asm       # Emit assembly for inspection
```
