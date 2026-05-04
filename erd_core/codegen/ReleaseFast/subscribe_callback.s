subscribe_callback:
        cmp	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
        je	.LBB17_2
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB17_2:
        ret

