; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
wire_wide_unsubscribe:
        jmp	.LSubscription.unsubscribe

; --- called functions ---

.LSubscription.unsubscribe:
        cmp	qword ptr [rdi + 8], offset .Lcodegen_wire_publisher.downstreamCb
        je	.L0
        cmp	qword ptr [rdi + 24], offset .Lcodegen_wire_publisher.downstreamCb
        je	.L1
        cmp	qword ptr [rdi + 40], offset .Lcodegen_wire_publisher.downstreamCb
        je	.L2
        ret
.L0:
        add	rdi, 8
        mov	qword ptr [rdi], 0
        ret
.L1:
        add	rdi, 24
        mov	qword ptr [rdi], 0
        ret
.L2:
        add	rdi, 40
        mov	qword ptr [rdi], 0
        ret

