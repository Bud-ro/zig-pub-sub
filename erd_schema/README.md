# erd_schema

Generic ERD serialization with type info. Transforms Zig ERD definition types into machine-readable output formats.

WIP

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
