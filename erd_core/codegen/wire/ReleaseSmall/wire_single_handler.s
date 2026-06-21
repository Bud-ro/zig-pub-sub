; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; Degenerate dispatch: with one watched ERD the binary search folds
; to a single idx compare and the swap fn pointer is devirtualized
; and inlined (rol for u16) -- no table, no indirect call, no memcpy
; call. The shared-handler design specializes for free at N=1.
;
wire_single_handler:
        jmp	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler"

; --- called functions ---

".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).handler":
        cmp	word ptr [rsi + 8], 0
        je	.L0
        ret
.L0:
        push	rax
        mov	rax, qword ptr [rsi]
        movzx	eax, word ptr [rax]
        rol	ax, 8
        mov	word ptr [rsp + 6], ax
        lea	rsi, [rsp + 6]
        call	".Lwire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire"
        add	rsp, 8
        ret

