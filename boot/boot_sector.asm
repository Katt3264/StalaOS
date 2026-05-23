[org 0x7c00]
[bits 16]
    
disk_load:

    mov [BOOT_DRIVE], dl
    mov bp, 0x7000
    mov sp, bp

    mov bx, 0x7e00  ; bx <- destination address
    mov ax, 0x0000
    mov es, ax

disk_loop:

    mov ah, 0x02         ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, 1            ; al <- number of sectors to read (0x01 .. 0x80)
    mov cl, [sector]     ; cl <- sector (0x01 .. 0x11)
    mov ch, [cylinder]   ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
    mov dh, [head]       ; dh <- head number (0x0 .. 0xF)
    mov dl, [BOOT_DRIVE]

    inc dh
    dec dh
    int 0x13      ; BIOS interrupt
    ;jc disk_error ; if error (stored in the carry bit)


    ; increment sector pointer
    mov cl, [sector]
    inc cl
    mov [sector], cl

    ; CHS logic
    cmp byte [sector], 19
    jne .chs_done
    mov byte [sector], 1
    inc byte [head]

    cmp byte [head], 2
    jne .chs_done
    mov byte [head], 0
    inc byte [cylinder]
.chs_done:
    ; decrement remaining sectors
    mov cl, [remaining]
    dec cl
    jz .done
    mov [remaining], cl

    ; increment address and offset
    add bx, 512
    jnc .no_wrap
    mov ax, es
    add ax, 0x1000
    mov es, ax
.no_wrap:
    jmp disk_loop
.done:
    jmp post_boot_load

sector db 2
head db 0
cylinder db 0
remaining      db 127 ; max 17 before head change; 20 gets loaded: 10240 bytes total
BOOT_DRIVE db 0

disk_error:
    mov bx, DISK_ERROR
    call print
    mov dh, ah ; ah = error code, dl = disk drive that dropped the error
    call print_hex
    jmp halt_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print
    jmp halt_loop

halt_loop:
    jmp $

DISK_ERROR: db "int 0x13 error", 0
SECTORS_ERROR: db "Sector read error", 0

; bx - string
print:
    pusha
print_start:
    mov al, [bx] ; 'bx' is the base address for the string
    cmp al, 0 
    je print_done

    ; the part where we print with the BIOS help
    mov ah, 0x0e
    int 0x10 ; 'al' already contains the char

    ; increment pointer and do next loop
    add bx, 1
    jmp print_start
print_done:
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10

    popa
    ret


; receiving the data in 'dx'
print_hex:
    pusha
    mov cx, 0 ; our index variable
hex_loop:
    cmp cx, 4 ; loop 4 times
    je print_hex_end
    ; 1. convert last char of 'dx' to ascii
    mov ax, dx ; we will use 'ax' as our working register
    and ax, 0x000f ; 0x1234 -> 0x0004 by masking first three to zeros
    add al, 0x30 ; add 0x30 to N to convert it to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle hex_step_2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65-58=7
hex_step_2:
    ; 2. get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx  ; our index variable
    mov [bx], al ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234
    add cx, 1 ; increment index and loop
    jmp hex_loop
print_hex_end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov bx, HEX_OUT
    call print
    popa
    ret

HEX_OUT: db '0x0000',0 ; reserve memory for our new string

times 510 - ($-$$) db 0
dw 0xaa55

; ######################
; # END OF BOOT SECTOR #
; ######################

%include "boot/boot_2.asm"
