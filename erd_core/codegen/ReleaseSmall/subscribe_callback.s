subscribe_callback:
        cmp	qword ptr [rdi + 24], offset .Lcodegen_harness.accumulate_callback
        je	.LBB20_2
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset .Lcodegen_harness.accumulate_callback
.LBB20_2:
        ret

