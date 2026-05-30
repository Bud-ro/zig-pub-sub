; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; 8 unpause calls to shared bodies (was 2225 bytes of inlined tryRemove/insertTimer in RF).
;
app_unpause_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	timer.TimerModule.unpause

; --- called functions ---

timer.TimerModule.unpause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        mov	rbx, rsi
        mov	r14, rdi
        add	rdi, 8
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	timer.TimerModule.tryRemove
        test	al, 1
        je	.L1
        mov	edx, dword ptr [rbx + 24]
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.insertTimer
.L1:
        mov	rax, r14
.L2:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L3
        cmp	rax, r15
        jne	.L2
.L3:
        test	rax, rax
        je	.L4
.L0:
        pop	rbx
        pop	r14
        pop	r15
        ret
.L4:
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.isRunning

