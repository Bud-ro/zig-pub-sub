# app

Demo application that wires ERD definitions to concrete data component implementations.

Serves as a reference for how to use `erd_core` and `erd_schema` in a real project:

- `system_erds.zig` — defines the application's ERD table (types, handles, component ownership, subscription slots)
- `app.zig` — binds ERD definitions to `RamDataComponent`, `IndirectDataComponent`, and `ConvertedDataComponent` instances
- `main.zig` — entry point that dumps the ERD table as JSON via `erd_schema`

## Build

```bash
zig build run   # Run the app (prints ERD JSON to debug log)
```
