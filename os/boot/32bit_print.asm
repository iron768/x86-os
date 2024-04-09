[bits 32] ; using 32 protected mode

; the constants are defined
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; color byte for each char

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY ; set the edx to the start of the video memory
    mov ah, WHITE_ON_BLACK ; store the attributes in 'ah'

print_string_pm_loop:
    mov al, [ebx] ; [ebx] is the address is the character

    cmp al, 0 ; check if the end of the string
    je print_string_pm_done

    mov [edx], ax ; store the character + attribute in video memory
    add ebx, 1 ; get the next char by incrementing
    add edx, 2 ; next video memory in position

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret