; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
unsubscribe_converted_flag:
        add	rdi, 104
        mov	esi, 2
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).unsubscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).unsubscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        jmp	Subscription.unsubscribe

