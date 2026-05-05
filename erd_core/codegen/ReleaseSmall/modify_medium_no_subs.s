modify_medium_no_subs:
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_0"

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_0":
        add	dword ptr [rdi + 300], 1
        ret

