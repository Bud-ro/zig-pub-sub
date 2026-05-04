codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        inc	dword ptr [rdi]
        pop	rbp
        ret

