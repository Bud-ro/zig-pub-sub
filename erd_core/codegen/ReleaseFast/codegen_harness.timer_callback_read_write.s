codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        add	dword ptr [rdi], 1
        pop	rbp
        ret

