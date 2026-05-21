; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
mixed_subscribe_ram:
        add	rdi, 24
        jmp	"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_conv_defs))[0..3]).subscribeInner":
        mov	esi, 2
        jmp	Subscription.subscribe

