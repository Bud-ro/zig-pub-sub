; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
mixed_subscribe_ram:
        add	rdi, 24
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_erds))[0..3]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_erds))[0..3]).subscribeInner":
        mov	esi, 2
        jmp	.LSubscription.subscribe

