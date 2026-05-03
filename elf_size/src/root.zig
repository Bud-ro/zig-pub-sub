//! ELF memory usage summary tool.
//! Parses ELF section headers from a binary file, maps allocated sections to
//! user-defined memory regions by address range, and formats a usage summary.
//! Designed for embedded firmware where you need to know how much RAM/flash is used.

const std = @import("std");

pub const MemoryRegion = struct {
    name: []const u8,
    origin: u32,
    length: u32,
};

const SectionInfo = struct {
    name: [32]u8 = .{0} ** 32,
    addr: u32 = 0,
    size: u32 = 0,
};

// zlinter-disable declaration_naming - ELF convention
const ELF_MAGIC = "\x7fELF";

const Elf32_Ehdr = extern struct {
    e_ident: [16]u8,
    e_type: u16,
    e_machine: u16,
    e_version: u32,
    e_entry: u32,
    e_phoff: u32,
    e_shoff: u32,
    e_flags: u32,
    e_ehsize: u16,
    e_phentsize: u16,
    e_phnum: u16,
    e_shentsize: u16,
    e_shnum: u16,
    e_shstrndx: u16,
};

const Elf32_Shdr = extern struct {
    sh_name: u32,
    sh_type: u32,
    sh_flags: u32,
    sh_addr: u32,
    sh_offset: u32,
    sh_size: u32,
    sh_link: u32,
    sh_info: u32,
    sh_addralign: u32,
    sh_entsize: u32,
};

const SHF_ALLOC = 0x2;
const MAX_SECTIONS_PER_REGION = 32;
const MAX_REGIONS = 16;
// zlinter-enable declaration_naming

/// Format a memory usage summary into the provided buffer. Returns the number of bytes written.
// zlinter-disable-next-line no_inferred_error_unions
pub fn formatSummary(elf_path: []const u8, regions: []const MemoryRegion, out: []u8) !usize {
    const file = try std.fs.cwd().openFile(elf_path, .{});
    defer file.close();

    var ehdr: Elf32_Ehdr = undefined;
    const ehdr_bytes: *[@sizeOf(Elf32_Ehdr)]u8 = @ptrCast(&ehdr);
    const ehdr_read = try file.read(ehdr_bytes);
    if (ehdr_read < @sizeOf(Elf32_Ehdr)) return error.InvalidElf;
    if (!std.mem.eql(u8, ehdr.e_ident[0..4], ELF_MAGIC)) return error.InvalidElf;
    if (ehdr.e_ident[4] != 1) return error.Not32BitElf;

    const shstrtab_offset = blk: {
        const shstr_pos = ehdr.e_shoff + @as(u32, ehdr.e_shstrndx) * @as(u32, ehdr.e_shentsize);
        try file.seekTo(shstr_pos);
        var shdr: Elf32_Shdr = undefined;
        const shdr_bytes: *[@sizeOf(Elf32_Shdr)]u8 = @ptrCast(&shdr);
        _ = try file.read(shdr_bytes);
        break :blk shdr.sh_offset;
    };

    var region_used: [MAX_REGIONS]u32 = .{0} ** MAX_REGIONS;
    var region_details: [MAX_REGIONS][MAX_SECTIONS_PER_REGION]SectionInfo = undefined;
    var region_detail_count: [MAX_REGIONS]u32 = .{0} ** MAX_REGIONS;

    var i: u16 = 0;
    while (i < ehdr.e_shnum) : (i += 1) {
        const pos = ehdr.e_shoff + @as(u32, i) * @as(u32, ehdr.e_shentsize);
        try file.seekTo(pos);
        var shdr: Elf32_Shdr = undefined;
        const shdr_bytes: *[@sizeOf(Elf32_Shdr)]u8 = @ptrCast(&shdr);
        _ = try file.read(shdr_bytes);

        if (shdr.sh_flags & SHF_ALLOC == 0) continue;
        if (shdr.sh_size == 0) continue;

        var name_buf: [32]u8 = .{0} ** 32;
        try file.seekTo(shstrtab_offset + shdr.sh_name);
        _ = try file.read(&name_buf);

        for (regions, 0..) |region, ri| {
            const region_end = region.origin + region.length;
            if (shdr.sh_addr >= region.origin and shdr.sh_addr < region_end) {
                region_used[ri] += shdr.sh_size;
                const dc = region_detail_count[ri];
                if (dc < MAX_SECTIONS_PER_REGION) {
                    region_details[ri][dc] = .{
                        .name = name_buf,
                        .addr = shdr.sh_addr,
                        .size = shdr.sh_size,
                    };
                    region_detail_count[ri] = dc + 1;
                }
                break;
            }
        }
    }

    var pos: usize = 0;

    pos += emit(out[pos..], "\n");
    for (regions, 0..) |region, ri| {
        const used = region_used[ri];
        const free = if (region.length > used) region.length - used else 0;
        const pct_used = if (region.length > 0) @as(u64, used) * 10000 / @as(u64, region.length) else 0;
        const pct_free = if (region.length > 0) @as(u64, free) * 10000 / @as(u64, region.length) else 0;

        pos += emit(out[pos..], region.name);
        pos += emit(out[pos..], ":\n");

        var j: u32 = 0;
        while (j < region_detail_count[ri]) : (j += 1) {
            const s = region_details[ri][j];
            var sname_len: usize = 0;
            while (sname_len < s.name.len and s.name[sname_len] != 0) : (sname_len += 1) {}

            pos += emit(out[pos..], "  ");
            pos += emitPadded(out[pos..], s.name[0..sname_len], 20);
            pos += emitU32Right(out[pos..], s.size, 8);
            pos += emit(out[pos..], " bytes\n");
        }

        pos += emit(out[pos..], "  ");
        pos += emitU32Right(out[pos..], used, 8);
        pos += emit(out[pos..], " bytes used  (");
        pos += emitPct(out[pos..], pct_used);
        pos += emit(out[pos..], ")\n  ");
        pos += emitU32Right(out[pos..], free, 8);
        pos += emit(out[pos..], " bytes free  (");
        pos += emitPct(out[pos..], pct_free);
        pos += emit(out[pos..], ")\n\n");
    }

    return pos;
}

fn emit(buf: []u8, s: []const u8) usize {
    if (s.len > buf.len) return 0;
    @memcpy(buf[0..s.len], s);
    return s.len;
}

fn emitPadded(buf: []u8, s: []const u8, width: usize) usize {
    var pos: usize = 0;
    pos += emit(buf[pos..], s);
    while (pos < width) {
        if (pos >= buf.len) break;
        buf[pos] = ' ';
        pos += 1;
    }
    return pos;
}

fn emitU32(buf: []u8, val: u32) usize {
    if (val == 0) {
        buf[0] = '0';
        return 1;
    }
    var n = val;
    var tmp: [10]u8 = undefined;
    var i: usize = 0;
    while (n > 0) : (i += 1) {
        tmp[i] = @truncate(n % 10 + '0');
        n /= 10;
    }
    var j: usize = 0;
    while (j < i) : (j += 1) buf[j] = tmp[i - 1 - j];
    return i;
}

fn emitU32Right(buf: []u8, val: u32, width: usize) usize {
    var tmp: [10]u8 = undefined;
    const len = emitU32(&tmp, val);
    var pos: usize = 0;
    if (len < width) {
        var pad = width - len;
        while (pad > 0) : (pad -= 1) {
            if (pos >= buf.len) break;
            buf[pos] = ' ';
            pos += 1;
        }
    }
    pos += emit(buf[pos..], tmp[0..len]);
    return pos;
}

fn emitPct(buf: []u8, pct_x100: u64) usize {
    var pos: usize = 0;
    pos += emitU32(buf[pos..], @truncate(pct_x100 / 100));
    if (pos < buf.len) {
        buf[pos] = '.';
        pos += 1;
    }
    const frac: u32 = @truncate(pct_x100 % 100);
    if (frac < 10 and pos < buf.len) {
        buf[pos] = '0';
        pos += 1;
    }
    pos += emitU32(buf[pos..], frac);
    if (pos < buf.len) {
        buf[pos] = '%';
        pos += 1;
    }
    return pos;
}
