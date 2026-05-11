subscribe_converted:
        add	rdi, 104
        xor	esi, esi
        jmp	".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(@as([*]const Erd, @ptrCast(&codegen_harness.converted_defs))[0..2]).subscribeInner":
        shl	rsi, 4
        mov	rax, qword ptr [rdi + rsi + 8]
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB4_5
        add	rdi, rsi
        test	rax, rax
        je	.LBB4_2
        mov	rax, qword ptr [rdi + 24]
        add	rdi, 16
        xor	ecx, ecx
        test	rax, rax
        cmovne	rdi, rcx
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        je	.LBB4_5
.LBB4_7:
        test	rdi, rdi
        je	.LBB4_6
        mov	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset .Lcodegen_harness.conv_sub_callback
        ret
.LBB4_2:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset .Lcodegen_harness.conv_sub_callback
        jne	.LBB4_7
.LBB4_5:
        ret
.LBB4_6:
        push	rax
        mov	edi, offset .L__anon_0
        mov	esi, 19
        call	.Ldebug.defaultPanic

