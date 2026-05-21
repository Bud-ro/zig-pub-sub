; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
mixed_unsubscribe_conv:
        add	rdi, 144
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner":
        mov	esi, 2
        jmp	Subscription.unsubscribe

