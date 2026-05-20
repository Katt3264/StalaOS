[org 0x7c00]

    mov [BOOT_DRIVE], dl
    mov bp, 0x7000
    mov sp, bp

[bits 16]
load_kernel:
    mov bx, 0x7e00

    mov dh, 127

    mov dl, [BOOT_DRIVE]
    call disk_load
    jmp post_boot_load


BOOT_DRIVE db 1

%include "boot_sector/boot_sector_print.asm"
%include "boot_sector/boot_sector_print_hex.asm"
%include "boot_sector/boot_sector_disk.asm"


times 510 - ($-$$) db 0
dw 0xaa55


post_boot_load:


[bits 16]
switch_to_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    mov eax, 0
    jmp kernel_start




%include "boot_sector/gdt_32.asm"
%include "kernel/kernel.asm"


;times 512 * 100 - ($-$$) db 0
