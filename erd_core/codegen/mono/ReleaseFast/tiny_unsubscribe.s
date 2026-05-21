; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
tiny_unsubscribe:
        add	rdi, 16
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).unsubscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).unsubscribeInner":
        mov	esi, 1
        jmp	Subscription.unsubscribe

