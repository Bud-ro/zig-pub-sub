# elf_size — ELF Memory Usage Summary

A Zig library and CLI tool that parses ELF section headers and reports memory usage per region. Built for embedded firmware where you need to know exactly how much RAM, IRAM, and flash you're using.

## Usage

### CLI

```bash
cd elf_size && zig build
./zig-out/bin/elf-size firmware.elf RAM:3FFE8000:14000 IRAM:40100000:8000 FLASH:40210000:5C000
```

Region spec format: `name:origin:length` (hex, no `0x` prefix).

Output:
```
RAM:
  .data                   3042 bytes
  .rodata                  984 bytes
  .bss                   25408 bytes
     29434 bytes used  (35.93%)
     52486 bytes free  (64.06%)

IRAM:
  .text                  26600 bytes
     26600 bytes used  (81.17%)
      6168 bytes free  (18.82%)

FLASH:
  .irom0.text           196996 bytes
    196996 bytes used  (52.27%)
    179836 bytes free  (47.72%)
```

### As a build step

Add a post-link step in your `build.zig` to print the report and save it to `zig-out/MEMORY_REPORT.txt`:

```zig
const mem_report = b.addSystemCommand(&.{
    "sh", "-c",
    "TOOL=../elf_size/zig-out/bin/elf-size; " ++
        "[ -x $TOOL ] || (cd ../elf_size && zig build); " ++
        "$TOOL zig-out/firmware.elf RAM:3FFE8000:14000 IRAM:40100000:8000 | tee zig-out/MEMORY_REPORT.txt",
});
mem_report.step.dependOn(&link.step);
b.getInstallStep().dependOn(&mem_report.step);
```

### As a library

```zig
const elf_size = @import("elf_size");

const regions = [_]elf_size.MemoryRegion{
    .{ .name = "RAM",   .origin = 0x20000000, .length = 32 * 1024 },
    .{ .name = "FLASH", .origin = 0x08000000, .length = 256 * 1024 },
};

var buf: [4096]u8 = undefined;
const len = try elf_size.format_summary("firmware.elf", &regions, &buf);
// buf[0..len] contains the formatted report
```

## How it works

1. Reads the ELF32 header to find section headers and the string table
2. Iterates all sections with the `SHF_ALLOC` flag (sections that occupy memory at runtime)
3. Maps each section to a user-defined memory region by address range
4. Computes used/free bytes and percentages per region

## Supported targets

Any ELF32 binary — ARM Cortex-M, Xtensa, RISC-V, AVR, etc. Only requires the section headers to be present (not stripped).
