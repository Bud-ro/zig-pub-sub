; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_register:
        mov	qword ptr [rdi + 112], offset .Lcodegen_harness.pubSendShim
        ret

