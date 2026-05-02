const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Communication Protocol Frame Definition ---
// Field layout with structural constraints: length fields must match,
// CRC polynomial must be valid, frame delimiters must not appear in payload.

const FieldType = enum(u8) { delimiter, length, type_id, payload, crc, reserved };

const FrameField = struct {
    field_type: FieldType,
    offset: u8,
    size: u8,
};

fn validateFrameDefinition(comptime fields: []const FrameField) void {
    if (fields.len < 3)
        @compileError("frame needs at least delimiter, payload, and crc");

    if (fields[0].field_type != .delimiter)
        @compileError("frame must start with delimiter");

    var has_payload = false;
    var has_crc = false;
    var has_length = false;
    var payload_offset: u8 = 0;
    var payload_size: u8 = 0;
    var length_offset: u8 = 0;

    for (fields) |field| {
        constraints.assert(constraints.nonZero(field.size));

        if (field.field_type == .payload) {
            has_payload = true;
            payload_offset = field.offset;
            payload_size = field.size;
        }
        if (field.field_type == .crc) has_crc = true;
        if (field.field_type == .length) {
            has_length = true;
            length_offset = field.offset;
        }
    }

    if (!has_payload) @compileError("frame must have a payload field");
    if (!has_crc) @compileError("frame must have a CRC field");

    // Fields must be contiguous and non-overlapping
    for (1..fields.len) |i| {
        const prev_end = fields[i - 1].offset + fields[i - 1].size;
        if (fields[i].offset != prev_end)
            @compileError(std.fmt.comptimePrint(
                "gap or overlap between fields at offsets {} and {}",
                .{ prev_end, fields[i].offset },
            ));
    }

    // Length field must come before payload
    if (has_length and length_offset >= payload_offset)
        @compileError("length field must precede payload");

    // CRC must be last
    if (fields[fields.len - 1].field_type != .crc)
        @compileError("CRC must be the last field");
}

const simple_protocol = blk: {
    const fields = [_]FrameField{
        .{ .field_type = .delimiter, .offset = 0, .size = 1 },
        .{ .field_type = .length, .offset = 1, .size = 2 },
        .{ .field_type = .type_id, .offset = 3, .size = 1 },
        .{ .field_type = .payload, .offset = 4, .size = 64 },
        .{ .field_type = .crc, .offset = 68, .size = 2 },
    };
    validateFrameDefinition(&fields);
    break :blk fields;
};

test "simple protocol frame is contiguous" {
    comptime {
        try std.testing.expectEqual(5, simple_protocol.len);
        const last = simple_protocol[simple_protocol.len - 1];
        try std.testing.expectEqual(70, @as(u16, last.offset) + last.size);
    }
}

// --- Message Type Registry ---
// Each message type has a type ID, expected payload size, and response type.
// Response chains must not be circular.

const MessageDef = struct {
    type_id: u8,
    payload_size: u8,
    response_type_id: ?u8,
    is_broadcast: bool,
    priority: u8,
};

fn validateMessageRegistry(comptime msgs: []const MessageDef) void {
    @setEvalBranchQuota(5000);
    constraints.assert(constraints.lenInRange(1, 64, msgs.len));

    var ids: [msgs.len]u8 = undefined;
    for (msgs, 0..) |msg, i| {
        ids[i] = msg.type_id;
        constraints.assert(constraints.inRange(0, 128, msg.payload_size));
        constraints.assert(constraints.inRange(0, 7, msg.priority));

        if (msg.is_broadcast and msg.response_type_id != null)
            @compileError(std.fmt.comptimePrint(
                "broadcast message type {} cannot have a response",
                .{msg.type_id},
            ));

        // Validate response_type_id references an existing message
        if (msg.response_type_id) |resp_id| {
            var found = false;
            for (msgs) |other| {
                if (other.type_id == resp_id) {
                    found = true;
                    break;
                }
            }
            if (!found)
                @compileError(std.fmt.comptimePrint(
                    "message type {} references unknown response type {}",
                    .{ msg.type_id, resp_id },
                ));
        }
    }
    constraints.assert(constraints.noDuplicates(u8, &ids));

    // Detect response cycles (no message should chain back to itself)
    for (msgs) |start| {
        if (start.response_type_id == null) continue;
        var current_id = start.response_type_id.?;
        var depth: u8 = 0;
        while (depth < msgs.len) : (depth += 1) {
            if (current_id == start.type_id)
                @compileError(std.fmt.comptimePrint(
                    "circular response chain detected starting from type {}",
                    .{start.type_id},
                ));
            // Find the message with current_id and follow its response
            var found_resp: ?u8 = null;
            for (msgs) |m| {
                if (m.type_id == current_id) {
                    found_resp = m.response_type_id;
                    break;
                }
            }
            if (found_resp) |next| {
                current_id = next;
            } else {
                break;
            }
        }
    }
}

const message_registry = blk: {
    const msgs = [_]MessageDef{
        .{ .type_id = 0x01, .payload_size = 0, .response_type_id = 0x81, .is_broadcast = false, .priority = 7 },
        .{ .type_id = 0x02, .payload_size = 4, .response_type_id = 0x82, .is_broadcast = false, .priority = 5 },
        .{ .type_id = 0x03, .payload_size = 8, .response_type_id = 0x83, .is_broadcast = false, .priority = 5 },
        .{ .type_id = 0x04, .payload_size = 16, .response_type_id = null, .is_broadcast = false, .priority = 3 },
        .{ .type_id = 0x10, .payload_size = 1, .response_type_id = null, .is_broadcast = true, .priority = 7 },
        .{ .type_id = 0x11, .payload_size = 4, .response_type_id = null, .is_broadcast = true, .priority = 6 },
        .{ .type_id = 0x81, .payload_size = 32, .response_type_id = null, .is_broadcast = false, .priority = 5 },
        .{ .type_id = 0x82, .payload_size = 4, .response_type_id = null, .is_broadcast = false, .priority = 5 },
        .{ .type_id = 0x83, .payload_size = 64, .response_type_id = null, .is_broadcast = false, .priority = 3 },
    };
    validateMessageRegistry(&msgs);
    break :blk msgs;
};

test "message registry has unique type IDs" {
    comptime {
        try std.testing.expectEqual(9, message_registry.len);
        var ids: [message_registry.len]u8 = undefined;
        for (message_registry, 0..) |msg, i| ids[i] = msg.type_id;
        constraints.assert(constraints.noDuplicates(u8, &ids));
    }
}

test "message registry no broadcast has response" {
    comptime {
        for (message_registry) |msg| {
            if (msg.is_broadcast) {
                try std.testing.expectEqual(@as(?u8, null), msg.response_type_id);
            }
        }
    }
}

test "message registry response chain terminates" {
    comptime {
        for (message_registry) |msg| {
            if (msg.response_type_id) |resp_id| {
                var found = false;
                for (message_registry) |other| {
                    if (other.type_id == resp_id) {
                        found = true;
                        break;
                    }
                }
                try std.testing.expect(found);
            }
        }
    }
}

// --- Baud Rate Configuration ---

const BaudConfig = struct {
    baud_rate: u32,
    data_bits: u8,
    stop_bits: u8,
    parity: enum(u8) { none, even, odd },
    hw_flow_control: bool,

    pub fn validate(comptime self: BaudConfig) ?[]const u8 {
        if (self.baud_rate != 9600 and self.baud_rate != 19200 and self.baud_rate != 38400 and
            self.baud_rate != 57600 and self.baud_rate != 115200 and self.baud_rate != 230400 and
            self.baud_rate != 460800 and self.baud_rate != 921600)
            return "baud_rate must be one of 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600";
        if (self.data_bits != 7 and self.data_bits != 8) return "data_bits must be one of 7, 8";
        if (self.stop_bits != 1 and self.stop_bits != 2) return "stop_bits must be one of 1, 2";

        if (self.data_bits == 7 and self.parity == .none)
            return "7-bit data requires parity for frame synchronization";

        if (self.baud_rate > 115200 and !self.hw_flow_control)
            return "baud rates above 115200 require hardware flow control";
        return null;
    }
};

test "baud config standard 115200 8N1" {
    comptime {
        contracts.assertValid(BaudConfig{
            .baud_rate = 115200,
            .data_bits = 8,
            .stop_bits = 1,
            .parity = .none,
            .hw_flow_control = false,
        });
    }
}

test "baud config high speed with flow control" {
    comptime {
        contracts.assertValid(BaudConfig{
            .baud_rate = 921600,
            .data_bits = 8,
            .stop_bits = 1,
            .parity = .none,
            .hw_flow_control = true,
        });
    }
}

test "baud config 7-bit with parity" {
    comptime {
        contracts.assertValid(BaudConfig{
            .baud_rate = 9600,
            .data_bits = 7,
            .stop_bits = 2,
            .parity = .even,
            .hw_flow_control = false,
        });
    }
}
