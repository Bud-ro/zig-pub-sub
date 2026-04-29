# erd_schema

Generic ERD serialization. Transforms Zig ERD definition types into machine-readable output formats.

Currently supports JSON. Designed to grow into a general-purpose tool for converting compile-time Zig type information into consumable formats that other software can parse — enabling external tools to interpret raw bytes as human-readable data.

## Usage

```zig
const erd_schema = @import("erd_schema");

// Works with any struct whose fields are Erd types
try erd_schema.generate_erd_json(MyErdDefs, my_erds, &writer, .{
    .namespace = "my-project",
});
```

ERDs with a non-null `erd_number` are included in the output. ERDs with `erd_number = null` are skipped.

## Build

```bash
zig build test  # Run unit tests
```
