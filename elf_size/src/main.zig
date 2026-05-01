//! CLI tool: parses an ELF file and prints memory usage per region.
//! Usage: elf-size <elf-file> <region-spec> [<region-spec> ...]
//! Region spec: name:origin:length (hex, no 0x prefix)
//! Example: elf-size firmware.elf RAM:3FFE8000:14000 IRAM:40100000:8000 FLASH:40210000:5C000

const std = @import("std");
const elf_size = @import("root.zig");

fn writeAll(data: []const u8) void {
    const file = std.fs.File{ .handle = std.posix.STDOUT_FILENO };
    file.writeAll(data) catch {};
}

pub fn main() !void {
    var args = std.process.args();
    _ = args.next();

    const elf_path = args.next() orelse {
        writeAll("Usage: elf-size <elf-file> <name:origin:length> ...\n");
        return;
    };

    var regions: [16]elf_size.MemoryRegion = undefined;
    var count: usize = 0;

    while (args.next()) |spec| {
        if (count >= 16) break;
        regions[count] = parse_region(spec) orelse {
            writeAll("Invalid region spec\n");
            return;
        };
        count += 1;
    }

    if (count == 0) {
        writeAll("No memory regions specified\n");
        return;
    }

    var output_buf: [4096]u8 = undefined;
    const len = try elf_size.format_summary(elf_path, regions[0..count], &output_buf);
    writeAll(output_buf[0..len]);
}

fn parse_region(spec: []const u8) ?elf_size.MemoryRegion {
    var it = std.mem.splitScalar(u8, spec, ':');
    const name = it.next() orelse return null;
    const origin_str = it.next() orelse return null;
    const length_str = it.next() orelse return null;

    const origin = std.fmt.parseInt(u32, origin_str, 16) catch return null;
    const length = std.fmt.parseInt(u32, length_str, 16) catch return null;

    return .{ .name = name, .origin = origin, .length = length };
}
