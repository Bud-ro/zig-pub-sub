const Erd = @import("erd.zig").Erd;

const RamDataComponent = @This();

// ERD definitions
const RamErdDefinition = struct {
    applicationVersion: Erd = .{ .erd_handle = 0x0000, .T = u32 },
};

const erd = RamErdDefinition{};
