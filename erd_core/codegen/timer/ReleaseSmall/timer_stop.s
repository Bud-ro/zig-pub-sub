; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_stop:
        jmp	.Ltimer.TimerModule.stop

; --- called functions ---

.Ltimer.TimerModule.stop:
        and	byte ptr [rsi], -2
        cmp	qword ptr [rsi + 8], 0
        jne	.Ltimer.TimerModule.removeTimer
        ret

