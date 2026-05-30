; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_stop:
        jmp	timer.TimerModule.stop

; --- called functions ---

timer.TimerModule.stop:
        and	byte ptr [rsi], -2
        cmp	qword ptr [rsi + 8], 0
        jne	timer.TimerModule.removeTimer
        ret

