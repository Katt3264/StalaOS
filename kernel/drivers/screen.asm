set_cursor_offset:
    push eax
    push ebx
    push edx

    mov ebx, eax

    mov al, 15
    mov dx, 0x3d4
    out dx, al

    mov al, bl
    mov dx, 0x3d5
    out dx, al

    mov al, 14
    mov dx, 0x3d4
    out dx, al

    mov al, bh
    mov dx, 0x3d5
    out dx, al
    
    pop edx
    pop ebx
    pop eax
    
    ret


draw_screen:
  
    push eax
    push ebx
    push ecx
    push edx

    
    ;mov eax, 0xb8000
    ;mov ebx, mem

mem_loop:
    
    ;cmp eax, 0xb8000 + 160*25
    ;je mem_loop_end

transfer:

    ;mov ch, 0x0f
    ;mov cl, [ebx]
    ;mov [eax], cx

    ;add eax, 2
    ;add ebx, 1
    ;jmp mem_loop


mem_loop_end:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

