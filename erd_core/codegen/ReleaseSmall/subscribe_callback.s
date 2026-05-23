; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
subscribe_callback:
        add	rdi, 16
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner":
        mov	esi, 1
        mov	edx, offset .Lcodegen_harness.accumulate_callback
        jmp	.LSubscription.subscribe

