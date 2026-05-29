; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; Degenerate dispatch: with one watched ERD the binary search folds
; to a single idx compare and the swap fn pointer is devirtualized
; and inlined (rol for u16) -- no table, no indirect call, no memcpy
; call. The shared-handler design specializes for free at N=1.
;
wire_single_handler:
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
        call	"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire"
        add	rsp, 8
        ret

; --- called functions ---

"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{.{ ... }}[0..1],1).publishWire":
        sub	rsp, 24
        mov	word ptr [rsp + 16], 4096
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], 2
        mov	rax, qword ptr [rdi + 8]
        test	rax, rax
        je	.L1
        mov	rdi, qword ptr [rdi]
        mov	rsi, rsp
        call	rax
.L1:
        add	rsp, 24
        ret

