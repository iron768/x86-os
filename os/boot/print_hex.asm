; receiving data from 'dx'
; assume dx = 0x1234
print_hex:
    pusha 

    mov cx, 0 ; index variable

; we are going to get the last char of 'dx' then convert it to ASCII
; numeric ASCII : '0' (ASCII 0x30) to '9' (ASCII 0x39) so we just need to add 0x30 to N
; for alphabetical values A-F : 'A' (ASCII 0x41) - 'F' (ASCII 0x46) so add 0x40
; finally move the ASCII byte to the correct position on the result string
hex_loop:
    cmp cx, 4 ; loop 4 times
    je end

    ; first step, convert the last char of 'dx' to ASCII
    mov ax, dx ; use 'ax' as our register
    and ax, 0x000f ; 0x1234 -> 0x0004 mask first three zeroes
    add al, 0x30 ; add 0x30 to convert N to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65 - 58 = 7

step2:
    ; second step, get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx ; our index variable
    mov [bx], al ; copy the ASCII char on 'al' to the position printed by 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; increment the index and loop
    add cx, 1
    jmp hex_loop 

end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov bx, HEX_OUT
    call print

    popa
    ret

HEX_OUT:
    db '0x0000', 0 ; reserve the memory for our new string