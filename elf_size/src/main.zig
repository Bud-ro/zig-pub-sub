//! CLI tool: parses an ELF file and prints memory usage per region.
//! Usage: elf-size <elf-file> [--output <file>] <region-spec> [<region-spec> ...]
//! Region spec: name:origin:length (hex, no 0x prefix)
//! Example: elf-size firmware.elf RAM:3FFE8000:14000 IRAM:40100000:8000

const elf_size = @import("root.zig");
const std = @import("std");

fn writeAll(io: std.Io, data: []const u8) void {
    const stdout = std.Io.File.stdout();
    var buf: [4096]u8 = undefined;
    var w = stdout.writer(io, &buf);
    // zlinter-disable no_swallow_error
    w.interface.writeAll(data) catch {};
    w.interface.flush() catch {};
    // zlinter-enable no_swallow_error
}

/// Entry point for the ELF memory usage summary tool.
// zlinter-disable-next-line no_inferred_error_unions
pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var args = init.minimal.args.iterate();
    _ = args.next();

    const elf_path = args.next() orelse {
        writeAll(io, "Usage: elf-size <elf-file> [--output <file>] <name:origin:length> ...\n");
        return;
    };

    var output_path: ?[]const u8 = null;
    var regions: [16]elf_size.MemoryRegion = undefined;
    var count: usize = 0;

    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--output")) {
            output_path = args.next();
            continue;
        }
        if (count >= 16) break;
        regions[count] = parseRegion(arg) orelse {
            writeAll(io, "Invalid region spec\n");
            return;
        };
        count += 1;
    }

    if (count == 0) {
        writeAll(io, "No memory regions specified\n");
        return;
    }

    var buf: [4096]u8 = undefined;
    const len = try elf_size.formatSummary(elf_path, regions[0..count], &buf);

    writeAll(io, buf[0..len]);

    if (output_path) |path| {
        const file = try std.Io.Dir.cwd().createFile(io, path, .{});
        defer file.close(io);
        var wbuf: [4096]u8 = undefined;
        var w = file.writer(io, &wbuf);
        try w.interface.writeAll(buf[0..len]);
        try w.interface.flush();
    }
}

fn parseRegion(spec: []const u8) ?elf_size.MemoryRegion {
    var it = std.mem.splitScalar(u8, spec, ':');
    const name = it.next() orelse return null;
    const origin_str = it.next() orelse return null;
    const length_str = it.next() orelse return null;

    const origin = std.fmt.parseInt(u32, origin_str, 16) catch return null;
    const length = std.fmt.parseInt(u32, length_str, 16) catch return null;

    return .{ .name = name, .origin = origin, .length = length };
}
