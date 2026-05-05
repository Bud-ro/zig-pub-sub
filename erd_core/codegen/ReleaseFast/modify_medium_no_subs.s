modify_medium_no_subs:
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_0"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_0":
        add	dword ptr [rdi + 300], 1
        ret

