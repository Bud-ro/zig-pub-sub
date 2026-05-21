; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
mixed_modify:
        mov	rsi, rdi
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_defs))[0..5]).modifyInner__anon_0"

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_defs))[0..5]).modifyInner__anon_0":
        push	rax
        mov	rcx, rsi
        mov	rax, qword ptr [rdi + 15]
        mov	qword ptr [rsp], rax
        add	eax, 1
        mov	dword ptr [rsp], eax
        mov	rax, qword ptr [rsp]
        mov	qword ptr [rdi + 15], rax
        mov	rdx, rsp
        mov	esi, 4
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_defs))[0..5]).publish"
        pop	rax
        ret

