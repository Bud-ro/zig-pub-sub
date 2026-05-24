; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
subscribe_converted:
        add	rdi, 72
        xor	esi, esi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.multi_converted_erds))[0..2]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 2
        mov	edx, offset .Lcodegen_harness.conv_sub_callback
        jmp	.LSubscription.subscribe

