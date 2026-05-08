# erd_schema

ERD serialization, type introspection, and wire format tooling. Transforms Zig ERD types into machine-readable JSON, and provides the inverse: interpreting raw bytes using those descriptors at runtime.

## Usage

```zig
const erd_schema = @import("erd_schema");

// Serialize ERD definitions to JSON
try erd_schema.json.generate(my_erds, &writer, .{ .namespace = "my-project" });

// Comptime: generate a Zig type from a JSON descriptor
const T = erd_schema.TypeFromDescriptor(json_str);

// Comptime: convert a struct to/from big-endian wire bytes
const wire = erd_schema.SwapRules(SensorReading).toBig(reading);
const native = erd_schema.SwapRules(SensorReading).fromBig(&wire);

// Runtime: load a schema and pretty-print wire data
const parsed = try std.json.parseFromSlice(std.json.Value, allocator, schema_json, .{});
var registry = try erd_schema.SchemaRegistry.init(allocator, parsed);
defer registry.deinit();
try registry.formatErdBig(erd_number, wire_data, &writer);
// -> "sensor: { temperature: 100, humidity: 55, status: warning }"
```

ERDs with a non-null `erd_number` are included in the output. ERDs with `erd_number = null` are skipped.

## Public API

| Export                         | Kind   | Description                                                              |
|--------------------------------|--------|--------------------------------------------------------------------------|
| `json.generate`                | fn     | Serialize ERD table to JSON writer                                       |
| `json.typeDescriptor`          | fn     | Emit single type descriptor to JSON                                      |
| `json.generateTypeDescriptor`  | fn     | Standalone type descriptor to writer                                     |
| `TypeFromDescriptor`           | fn     | Comptime: JSON string to Zig type via `@Struct`/`@Enum`/`@Union`/`@Int` |
| `SwapRules(T)`                 | type   | Comptime swap rules with `apply`, `fromBig`, `toBig`                     |
| `swap.SwapVariant`             | type   | Per-variant swap rules for manual union handling                         |
| `SchemaRegistry`               | struct | Runtime ERD lookup + BE wire data formatting                             |
| `decode.TypeDescriptor`        | struct | Runtime: `formatBytes`, `formatBytesBig`, `parseIntBig`, `swapBigToNative` |

## Type Support

| Type                          | Serialize            | TypeFromDescriptor | Decode                  | Swap                |
|-------------------------------|----------------------|--------------------|-------------------------|---------------------|
| Primitives (all widths)       | Y                    | Y (`@Int`)         | Y                       | Y                   |
| Floats (f16/f32/f64/f80/f128) | Y                    | Y                  | Y                       | Y                   |
| Bool                          | Y                    | Y                  | Y                       | N/A (1 byte)        |
| Extern structs                | Y (with offsets)     | Y (`@Struct`)      | Y                       | Y (recursive)       |
| Packed structs                | Y (with bit offsets) | Y (`@Struct`)      | Y                       | Y (as backing int)  |
| Enums (u8/u16/u32 tag)        | Y (with variants)    | Y (`@Enum`)        | Y (variant name)        | Y (as tag int)      |
| Extern unions                 | Y                    | Y (`@Union`)       | Y (all interpretations) | Per-variant         |
| Tagged unions                 | Y (struct pattern)   | Y                  | Y (active variant only) | Y (auto via tag)    |
| `[N]u8` strings               | Y (`"string"` kind)  | Y (`[N]u8`)        | Y (quoted, null-term)   | N/A                 |
| Arrays (non-u8)               | Y                    | Y                  | Y                       | Y (per-element)     |
| Auto structs                  | Compile error        | -                  | -                       | Compile error       |
| Pointers                      | Compile error        | -                  | -                       | -                   |
| Optionals                     | Compile error        | -                  | -                       | -                   |
| Vectors                       | Compile error        | -                  | -                       | Compile error       |

## Build

```bash
zig build test  # Run unit tests
```
