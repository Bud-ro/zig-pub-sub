; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Shared dispatcher for 8 watched ERDs: binary search + memcpy
; (runtime size -> memcpy call) + conditional swap + publishWire.
; One copy regardless of watched-ERD count; the swap fn pointer is
; null-checked so no-swap ERDs (flags u8, raw_bytes [4]u8) skip the
; indirect call.
;
wire_wide_handler:
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, word ptr [rsi + 8]
        mov	ecx, 8
        xor	edx, edx
        jmp	.L0
.L1:
        mov	rcx, r8
        cmp	rdx, rcx
        jae	.L2
.L0:
        mov	r8, rcx
        sub	r8, rdx
        shr	r8
        add	r8, rdx
        mov	r9, r8
        shl	r9, 4
        movzx	r10d, word ptr [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"+8]
        cmp	r10w, ax
        je	.L3
        jae	.L1
        add	r8, 1
        mov	rdx, r8
        cmp	rdx, rcx
        jb	.L0
        jmp	.L2
.L3:
        mov	r15, rdi
        lea	r12, [r9 + "wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).descriptors"]
        mov	rsi, qword ptr [rsi]
        movzx	r14d, word ptr [r12 + 12]
        mov	rdi, rsp
        mov	rdx, r14
        call	memcpy@PLT
        mov	rax, qword ptr [r12]
        test	rax, rax
        je	.L4
        mov	rdi, rsp
        mov	rsi, r14
        call	rax
.L4:
        movzx	esi, word ptr [r12 + 10]
        mov	rdx, rsp
        mov	rdi, r15
        mov	rcx, r14
        mov	r8, rbx
        call	"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire"
.L2:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

; --- called functions ---

"wire_publisher.WirePublisher(system_data.SystemData(codegen_wire_publisher.WireDefs,meta.FieldEnum(codegen_wire_publisher.WireDefs),.{ .temperature = .{ ... }, .pressure = .{ ... }, .uptime = .{ ... }, .flags = .{ ... }, .sample = .{ ... }, .reading = .{ ... }, .raw_bytes = .{ ... }, .raw_a = .{ ... }, .raw_b = .{ ... }, .ind_build = .{ ... }, .conv_sum = .{ ... } },codegen_wire_publisher.WireComponents),&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..8],3).publishWire":
        push	r14
        push	rbx
        sub	rsp, 24
        mov	rbx, r8
        mov	r14, rdi
        mov	word ptr [rsp + 16], si
        mov	qword ptr [rsp], rdx
        mov	qword ptr [rsp + 8], rcx
        mov	rax, qword ptr [rdi + 8]
        test	rax, rax
        je	.L5
        mov	rdi, qword ptr [r14]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.L5:
        mov	rax, qword ptr [r14 + 24]
        test	rax, rax
        je	.L6
        mov	rdi, qword ptr [r14 + 16]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.L6:
        mov	rax, qword ptr [r14 + 40]
        test	rax, rax
        je	.L7
        mov	rdi, qword ptr [r14 + 32]
        mov	rsi, rsp
        mov	rdx, rbx
        call	rax
.L7:
        add	rsp, 24
        pop	rbx
        pop	r14
        ret

