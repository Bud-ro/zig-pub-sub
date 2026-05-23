; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
tiny_subscribe:
        add	rdi, 16
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).subscribeInner":
        mov	esi, 1
        jmp	Subscription.subscribe

