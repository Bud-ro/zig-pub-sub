; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
subscribe_callback:
        add	rdi, 16
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner":
        mov	esi, 1
        mov	edx, offset codegen_harness.accumulate_callback
        jmp	Subscription.subscribe

