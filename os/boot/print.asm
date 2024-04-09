print:
    pusha

; in C
; while (string[i] != 0) { print string[i]; i++ }

; comparison for string end (null byte)
start:
    mov al, [bx] ; 'bx' is the address of the string
    cmp al, 0
    je done

    ; print using the BIOS
    mov ah, 0x0e
    int 0x10 ; video service interrupt, contains the 'al' character already

    ; increment the pointer and the the next loop
    add bx, 1
    jmp start

done:
    popa
    ret

print_nl:
    pusha

    mov ah, 0x0e
    mov al, 0x0a ; new line '\n'
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10

    popa
    ret