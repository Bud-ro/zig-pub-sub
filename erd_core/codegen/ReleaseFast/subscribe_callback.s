; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
subscribe_callback:
        add	rdi, 16
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner":
        mov	esi, 1
        mov	ecx, offset codegen_harness.accumulate_callback
        xor	edx, edx
        jmp	Subscription.subscribe

