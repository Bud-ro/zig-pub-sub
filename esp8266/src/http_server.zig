const std = @import("std");
const sdk = @import("sdk.zig");
const application = @import("application.zig");
const SystemErds = @import("system_erds.zig");
const erd_core = @import("erd_core");

var server_conn: sdk.Espconn = undefined;
var server_tcp: sdk.EspTcp = undefined;
var app_ref: *application.Application = undefined;

var body_buf: [1536]u8 = undefined;
var response_buf: [2048]u8 = undefined;

pub fn init(app: *application.Application) void {
    app_ref = app;

    server_tcp = std.mem.zeroes(sdk.EspTcp);
    server_tcp.local_port = 80;

    server_conn = std.mem.zeroes(sdk.Espconn);
    server_conn.type = @as(u32, sdk.ESPCONN_TCP);
    server_conn.state = 0;
    server_conn.proto = &server_tcp;

    _ = sdk.espconn_regist_connectcb(&server_conn, on_connect);
    _ = sdk.espconn_accept(&server_conn);
    _ = sdk.espconn_regist_time(&server_conn, 30, 0);
}

fn on_connect(arg: ?*anyopaque) callconv(sdk.cc) void {
    const conn: *sdk.Espconn = @ptrCast(@alignCast(arg orelse return));
    _ = sdk.espconn_regist_recvcb(conn, on_receive);
}

fn on_receive(arg: ?*anyopaque, data: [*]u8, len: u16) callconv(sdk.cc) void {
    const conn: *sdk.Espconn = @ptrCast(@alignCast(arg orelse return));
    const request = data[0..len];
    const path = parse_path(request);

    const count = app_ref.system_data.read(.erd_http_request_count);
    app_ref.system_data.write(.erd_http_request_count, count +% 1);

    if (std.mem.startsWith(u8, path, "/erd/")) {
        const erd_name = path[5..];
        if (is_post(request)) {
            if (erd_write_dispatch(erd_name, get_body(request))) {
                send_response(conn, "200 OK", "application/json", "{\"ok\":true}");
            } else {
                send_response(conn, "404 Not Found", "application/json", "{\"error\":\"unknown\"}");
            }
        } else {
            const json_len = erd_read_dispatch(erd_name);
            if (json_len > 0) {
                send_response(conn, "200 OK", "application/json", body_buf[0..json_len]);
            } else {
                send_response(conn, "404 Not Found", "application/json", "{\"error\":\"unknown\"}");
            }
        }
    } else {
        const html_len = build_dashboard();
        send_response(conn, "200 OK", "text/html", body_buf[0..html_len]);
    }
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

// Comptime-generated dispatch: runtime ERD name → comptime read/write
const erd_names = std.meta.fieldNames(SystemErds.ErdDefinitions);

fn ErdReadFn() type {
    return *const fn () usize;
}
fn ErdWriteFn() type {
    return *const fn ([]const u8) bool;
}
fn ErdRowFn() type {
    return *const fn (usize) usize;
}

const read_fns = blk: {
    var fns: [erd_names.len]ErdReadFn() = undefined;
    for (erd_names, 0..) |name, i| {
        fns[i] = make_read_fn(name);
    }
    break :blk fns;
};

const write_fns = blk: {
    var fns: [erd_names.len]ErdWriteFn() = undefined;
    for (erd_names, 0..) |name, i| {
        fns[i] = make_write_fn(name);
    }
    break :blk fns;
};

const row_fns = blk: {
    var fns: [erd_names.len]ErdRowFn() = undefined;
    for (erd_names, 0..) |name, i| {
        fns[i] = make_row_fn(name);
    }
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

fn make_row_fn(comptime name: []const u8) ErdRowFn() {
    return struct {
        fn f(base: usize) usize {
            const erd_enum = @field(SystemErds.ErdEnum, name);
            const T = @field(SystemErds.erd, name).T;
            const val = app_ref.system_data.read(erd_enum);
            var len: usize = 0;
            len += buf_copy(base + len, "<tr><td>" ++ name ++ "</td><td>");
            len += format_val(T, &val, body_buf[base + len ..]);
            len += buf_copy(base + len, "</td></tr>");
            return len;
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
    len += buf_copy(len, "<html><head><title>ZigPubSub</title>");
    len += buf_copy(len, "<meta name=viewport content='width=device-width'>");
    len += buf_copy(len, "<style>body{font-family:monospace;margin:20px}table{border-collapse:collapse}td,th{border:1px solid #ccc;padding:6px}th{background:#f0f0f0}</style>");
    len += buf_copy(len, "</head><body><h2>ZigPubSub ERD Dashboard</h2><table><tr><th>ERD</th><th>Value</th></tr>");
    for (row_fns) |row_fn| {
        len += row_fn(len);
    }
    len += buf_copy(len, "</table><br><small>Zig + ESP8266 + erd_core</small></body></html>");
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

fn send_response(conn: *sdk.Espconn, status: []const u8, content_type: []const u8, body: []const u8) void {
    var len: usize = 0;

    const h1 = "HTTP/1.1 ";
    @memcpy(response_buf[len..][0..h1.len], h1);
    len += h1.len;
    @memcpy(response_buf[len..][0..status.len], status);
    len += status.len;
    const h2 = "\r\nContent-Type: ";
    @memcpy(response_buf[len..][0..h2.len], h2);
    len += h2.len;
    @memcpy(response_buf[len..][0..content_type.len], content_type);
    len += content_type.len;
    const h3 = "\r\nConnection: close\r\n\r\n";
    @memcpy(response_buf[len..][0..h3.len], h3);
    len += h3.len;

    if (len + body.len <= response_buf.len) {
        @memcpy(response_buf[len..][0..body.len], body);
        len += body.len;
    }

    _ = sdk.espconn_send(conn, &response_buf, @truncate(len));
}
