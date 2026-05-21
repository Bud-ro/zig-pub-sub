; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
mixed_unsubscribe_ram:
        add	rdi, 24
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner":
        mov	esi, 2
        jmp	Subscription.unsubscribe

