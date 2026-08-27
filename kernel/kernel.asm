kernel_start:
    
    ; move cursor of screen
    mov ebx, -1
    mov ax, bx
    call set_cursor_offset

    call _main

ret



%include "kernel/drivers/screen.asm"
%include "kernel/drivers/disk_read.asm"
%include "build_temp/StalaKernel.asm"