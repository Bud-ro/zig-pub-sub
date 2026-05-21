; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
subscribe_converted:
        add	rdi, 104
        xor	esi, esi
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 2
        mov	edx, offset codegen_harness.conv_sub_callback
        jmp	Subscription.subscribe

