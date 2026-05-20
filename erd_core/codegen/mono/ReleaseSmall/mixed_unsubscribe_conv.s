mixed_unsubscribe_conv:
        add	rdi, 144
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).unsubscribeInner":
        mov	esi, 2
        jmp	.LSubscription.unsubscribe

