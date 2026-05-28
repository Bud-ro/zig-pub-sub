; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
subscribe_converted_flag:
        add	rdi, 72
        push	2
        pop	rsi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 2
        mov	ecx, offset .Lcodegen_harness.conv_sub_callback
        xor	edx, edx
        jmp	.LSubscription.subscribe

