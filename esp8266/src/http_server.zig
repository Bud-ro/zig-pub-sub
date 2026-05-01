const std = @import("std");
const application = @import("application.zig");
const SystemErds = @import("system_erds.zig");

var app_ref: *application.Application = undefined;
var body_buf: [1536]u8 = undefined;

pub fn init(app: *application.Application) void {
    app_ref = app;
    http_server_init_c();
}

extern fn http_server_init_c() void;

export fn zig_http_handle(request: [*]const u8, req_len: u32, response: [*]u8, resp_capacity: u32) u32 {
    const req = request[0..req_len];
    const path = parse_path(req);

    const count = app_ref.system_data.read(.erd_http_request_count);
    app_ref.system_data.write(.erd_http_request_count, count +% 1);

    var body_len: usize = 0;
    var status: []const u8 = "200 OK";
    var ctype: []const u8 = "text/html";

    if (std.mem.startsWith(u8, path, "/erd/")) {
        ctype = "application/json";
        const erd_name = path[5..];
        if (is_post(req)) {
            if (erd_write_dispatch(erd_name, get_body(req))) {
                body_len = buf_copy(0, "{\"ok\":true}");
            } else {
                status = "404 Not Found";
                body_len = buf_copy(0, "{\"error\":\"unknown\"}");
            }
        } else {
            body_len = erd_read_dispatch(erd_name);
            if (body_len == 0) {
                status = "404 Not Found";
                body_len = buf_copy(0, "{\"error\":\"unknown\"}");
            }
        }
    } else {
        body_len = build_dashboard();
    }

    // Assemble into response buffer
    var len: usize = 0;
    const resp = response[0..resp_capacity];
    len += r_copy(resp, len, "HTTP/1.1 ");
    len += r_copy(resp, len, status);
    len += r_copy(resp, len, "\r\nContent-Type: ");
    len += r_copy(resp, len, ctype);
    len += r_copy(resp, len, "\r\nConnection: close\r\n\r\n");
    if (len + body_len <= resp_capacity) {
        @memcpy(resp[len..][0..body_len], body_buf[0..body_len]);
        len += body_len;
    }

    return @truncate(len);
}

fn r_copy(resp: []u8, offset: usize, s: []const u8) usize {
    if (offset + s.len > resp.len) return 0;
    @memcpy(resp[offset..][0..s.len], s);
    return s.len;
}

fn parse_path(request: []const u8) []const u8 {
    var i: usize = 0;
    while (i < request.len and request[i] != ' ') : (i += 1) {}
    if (i >= request.len) return "/";
    i += 1;
    const start = i;
    while (i < request.len and request[i] != ' ' and request[i] != '?' and request[i] != '\r') : (i += 1) {}
    return request[start..i];
}

fn is_post(request: []const u8) bool {
    return request.len >= 4 and std.mem.eql(u8, request[0..4], "POST");
}

fn get_body(request: []const u8) []const u8 {
    var i: usize = 0;
    while (i + 3 < request.len) : (i += 1) {
        if (request[i] == '\r' and request[i + 1] == '\n' and request[i + 2] == '\r' and request[i + 3] == '\n')
            return request[i + 4 ..];
    }
    return "";
}

const erd_names = std.meta.fieldNames(SystemErds.ErdDefinitions);

fn ErdReadFn() type {
    return *const fn () usize;
}
fn ErdWriteFn() type {
    return *const fn ([]const u8) bool;
}

const read_fns = blk: {
    var fns: [erd_names.len]ErdReadFn() = undefined;
    for (erd_names, 0..) |name, i| fns[i] = make_read_fn(name);
    break :blk fns;
};

const write_fns = blk: {
    var fns: [erd_names.len]ErdWriteFn() = undefined;
    for (erd_names, 0..) |name, i| fns[i] = make_write_fn(name);
    break :blk fns;
};

fn make_read_fn(comptime name: []const u8) ErdReadFn() {
    return struct {
        fn f() usize {
            const erd_enum = @field(SystemErds.ErdEnum, name);
            const T = @field(SystemErds.erd, name).T;
            const val = app_ref.system_data.read(erd_enum);
            var len: usize = 0;
            len += buf_copy(len, "{\"name\":\"" ++ name ++ "\",\"value\":");
            len += format_val(T, &val, body_buf[len..]);
            len += buf_copy(len, "}");
            return len;
        }
    }.f;
}

fn make_write_fn(comptime name: []const u8) ErdWriteFn() {
    return struct {
        fn f(body: []const u8) bool {
            const erd_enum = @field(SystemErds.ErdEnum, name);
            const T = @field(SystemErds.erd, name).T;
            if (parse_value(T, body)) |val| {
                app_ref.system_data.write(erd_enum, val);
                return true;
            }
            return false;
        }
    }.f;
}

fn erd_read_dispatch(erd_name: []const u8) usize {
    for (erd_names, 0..) |name, i| {
        if (std.mem.eql(u8, erd_name, name)) return read_fns[i]();
    }
    return 0;
}

fn erd_write_dispatch(erd_name: []const u8, body: []const u8) bool {
    for (erd_names, 0..) |name, i| {
        if (std.mem.eql(u8, erd_name, name)) return write_fns[i](body);
    }
    return false;
}

fn build_dashboard() usize {
    var len: usize = 0;
    len += buf_copy(len, "<h2>ZigPubSub</h2><pre>");

    const uptime = app_ref.system_data.read(.erd_uptime_seconds);
    len += buf_copy(len, "uptime: ");
    len += fmt_u32(uptime, body_buf[len..]);

    const led = app_ref.system_data.read(.erd_led_state);
    len += buf_copy(len, "\nled:    ");
    len += buf_copy(len, if (led) "ON" else "OFF");

    const reqs = app_ref.system_data.read(.erd_http_request_count);
    len += buf_copy(len, "\nreqs:   ");
    len += fmt_u32(reqs, body_buf[len..]);

    const ip = app_ref.system_data.read(.erd_wifi_ip_addr);
    len += buf_copy(len, "\nip:     ");
    len += fmt_u32(ip & 0xFF, body_buf[len..]);
    body_buf[len] = '.';
    len += 1;
    len += fmt_u32((ip >> 8) & 0xFF, body_buf[len..]);
    body_buf[len] = '.';
    len += 1;
    len += fmt_u32((ip >> 16) & 0xFF, body_buf[len..]);
    body_buf[len] = '.';
    len += 1;
    len += fmt_u32((ip >> 24) & 0xFF, body_buf[len..]);

    len += buf_copy(len, "</pre>");
    return len;
}

fn buf_copy(offset: usize, s: []const u8) usize {
    if (offset + s.len > body_buf.len) return 0;
    @memcpy(body_buf[offset..][0..s.len], s);
    return s.len;
}

fn format_val(comptime T: type, val: *const T, buf: []u8) usize {
    if (T == bool) {
        const s = if (val.*) "true" else "false";
        if (s.len <= buf.len) @memcpy(buf[0..s.len], s);
        return s.len;
    } else if (T == u32) {
        return fmt_u32(val.*, buf);
    } else if (@typeInfo(T) == .@"enum") {
        return fmt_u32(@intFromEnum(val.*), buf);
    } else {
        const s = "\"?\"";
        if (s.len <= buf.len) @memcpy(buf[0..s.len], s);
        return s.len;
    }
}

fn fmt_u32(val: u32, buf: []u8) usize {
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

fn parse_value(comptime T: type, body: []const u8) ?T {
    const trimmed = std.mem.trim(u8, body, " \r\n\t");
    if (T == bool) {
        if (std.mem.eql(u8, trimmed, "true") or std.mem.eql(u8, trimmed, "1")) return true;
        if (std.mem.eql(u8, trimmed, "false") or std.mem.eql(u8, trimmed, "0")) return false;
        return null;
    } else if (T == u32) {
        if (trimmed.len == 0) return null;
        var result: u32 = 0;
        for (trimmed) |c| {
            if (c < '0' or c > '9') return null;
            result = result * 10 + (c - '0');
        }
        return result;
    }
    return null;
}
