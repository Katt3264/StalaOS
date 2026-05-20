; @return eax - the character



keyboard_pool_key:
     
k_AGAIN:
      mov eax, 0
      
      in al,64h       ; get the status
      test al,1       ; check output buffer
      jz short k_AGAIN

      test al,20h     ; check if it is a PS2Mouse-byte
      jnz short k_AGAIN
      in al,60h       ; get the key

    ; convert key

      cmp eax, 90
      jge k_AGAIN

      push ebx
      mov ebx, SCAN_CODE_TO_ASCII
      add ebx, eax
      mov al, [ebx]
      pop ebx

      cmp eax, 0
      je k_AGAIN

k_end:
   
      ret

 ; enter-10  backspace-8  left-7 up-3 down-6 right-4

SCAN_CODE_TO_ASCII db 0, '?', '1', '2', '3', '4', '5', '6', '7', '8' ; 0-9
NEXT0 db '9', '0', 0, 0, 8, 0, 'Q', 'W', 'E', 'R' ; 10-19
NEXT1 db 'T', 'Y', 'U', 'I', 'O', 'P', 0, 0, 10, 0 ; 20-29
NEXT2 db 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 0 ; 30-39
NEXT3 db 0, 0, 0, 0, 'Z', 'X', 'C', 'V', 'B', 'N' ; 40-49
NEXT4 db 'M', ',', '.', 0, 0, 0, 0, ' ', 0, 0 ; 50-59
NEXT5 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; 60-69
NEXT6 db 0, 0, 3, 0, 0, 7, 0, 4, 0, 0 ; 70-79
NEXT7 db 6, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; 80-89