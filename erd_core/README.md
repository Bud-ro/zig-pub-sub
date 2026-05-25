# erd_core

Core framework for a typed publish-subscribe data system targeting embedded/real-time Zig applications.

## What's in here

- **ERD** (`Erd.zig`) : Entity-Reference-Designator type: a named, typed data field with a 16-bit handle
- **SystemData** (`system_data.zig`) : Top-level aggregator binding multiple data components into one namespace with `read`/`write`/`subscribe`/`publish` APIs
  - **RamDataComponent** (`data_component.Ram`) : Packed byte-array storage with comptime-optimized reads/writes and on-change subscriptions
  - **IndirectDataComponent** (`data_component.Indirect`) : Read-only computed values via function pointers
  - **ConvertedDataComponent** (`data_component.Converted`) : Derived data computed from other ERDs via mappings
- **Subscription** : Fixed-size callback arrays per ERD, identity by function pointer
- **Timer** : Lightweight software scheduler (periodic/one-shot) for tick-based run-to-completion loops
- **erd_table** : Comptime helpers to populate `data_component_idx`/`system_data_idx` and extract per-component ERD slices
- **erd_mapping** : Comptime helpers shared by `Indirect`/`Converted` for resolving ERD-to-function-pointer mappings
- **testing** : Test double infrastructure (`SystemDataTestDouble`) for creating standalone test ERD systems

A number of utility modules are available in `common/`.

## Usage

```zig
const erd_core = @import("erd_core");

const MyErds = struct {
    sensor: erd_core.Erd = .{ .erd_number = 0x0000, .T = u16, .component_idx = 0, .subs = 1 },
};

const my_erds = erd_core.erd_table.autofill(MyErds);
const ram_defs = erd_core.erd_table.collectByComponent(my_erds, 0);
const Ram = erd_core.data_component.Ram(&ram_defs);
const Components = struct { ram: Ram };
const MyEnum = std.meta.FieldEnum(MyErds);
const SD = erd_core.SystemData(MyErds, MyEnum, my_erds, Components);
```

## Build

```bash
zig build test           # Run unit tests
zig build test_coverage  # Run with sometimes-assertion coverage
zig build codegen-check  # Verify assembly snapshots
zig build emit-asm       # Emit assembly for inspection
```
