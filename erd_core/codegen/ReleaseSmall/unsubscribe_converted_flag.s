; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
unsubscribe_converted_flag:
        add	rdi, 72
        push	2
        pop	rsi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).unsubscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).unsubscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        jmp	.LSubscription.unsubscribe

