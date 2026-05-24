# zig-pub-sub

A typed publish-subscribe data system for embedded/real-time Zig applications. Uses comptime ERD (Entity-Reference-Designator) definitions to achieve zero-cost abstractions over static memory.

## Packages

| Package | Description |
|---------|-------------|
| [`erd_core`](erd_core/) | Core framework - data components, system data, subscriptions, timer |
| [`erd_schema`](erd_schema/) | ERD serialization - transforms ERD definitions into JSON |
| [`data_gen`](data_gen/) | Constraint-based data generation |
| [`app`](app/) | Demo application wiring ERD definitions to concrete components |
| [`esp8266`](esp8266/) | ESP8266 firmware: erd_core on an embedded target via the Zig C backend |
| [`elf_size`](elf_size/) | ELF section-size reporter for embedded firmware builds |

## Quick Start

```bash
zig build test           # Run all tests across all packages
zig build run            # Run the demo app (dumps ERD JSON)
zig build test_coverage  # Run tests with sometimes-assertion coverage
zig build codegen-check  # Verify assembly snapshots haven't regressed
```

Each package can also be built and tested independently:

```bash
cd erd_core && zig build test
cd erd_schema && zig build test
cd data_gen && zig build test
cd app && zig build run
```

## Design Goals

- Fast, lightweight data storage abstraction for systems using primarily static memory
- Event-driven programming via fixed-size subscription arrays per ERD
- Extensive use of `comptime` elides lookups where possible - comptime reads compile to direct loads, writes to direct stores
- Runtime read/write paths use constant-time dispatch to the correct data component

## Using as a Library

Add `erd_core` as a Zig dependency and define your own ERD table and component wiring. See [`app/`](app/) for an example of how to wire ERD definitions to data components.

## Requirements

- Zig 0.16.0+
