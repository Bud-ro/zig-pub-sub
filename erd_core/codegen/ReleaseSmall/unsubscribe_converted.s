unsubscribe_converted:
        add	rdi, 104
        xor	esi, esi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).unsubscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).unsubscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        jmp	.LSubscription.unsubscribe

