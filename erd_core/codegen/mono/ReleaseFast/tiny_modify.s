; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Same modifyInner tradeoff as mixed_modify. Copies Pair
; to stack for a single field increment. Per-component
; monomorphized -- tiny/wide/mixed each get their own
; modifyInner despite identical logic.
;
tiny_modify:
        mov	rsi, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).modifyInner__anon_0"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).modifyInner__anon_0":
        push	rax
        mov	rcx, rsi
        mov	rax, qword ptr [rdi + 5]
        mov	qword ptr [rsp], rax
        add	eax, 1
        mov	dword ptr [rsp], eax
        mov	rax, qword ptr [rsp]
        mov	qword ptr [rdi + 5], rax
        mov	rdx, rsp
        mov	esi, 2
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        pop	rax
        ret

