; start with 8 empty bytes
gdt_start: 
    dd 0x0 ; empty 4 bytes
    dd 0x0 ; empty 4 bytes

; GDT for code segment, base = 0x00000000 length = 0xfffff
gdt_code:
    ; code segement descriptor
    ; base = 0x0, limit = 0xfffff
    ; first flags: (present) 1 (privilege) 0 (descriptor type) 1 -> 1001b
    ; type flags: (code) 1 (conforming) 0 (readable) 1 (acessed) 0 -> 1010b
    ; second flags: (granularity) 1 (32bit default) 1 (64bit seg) 0 (AVL) 0 -> 1100b
    dw 0xffff ; segment length (bits 0-15)
    dw 0x0 ; segment base (bits 0-15)
    db 0x0 ; segment base (16-23)
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length (bits 16-19)
    db 0x0 ; segment base (bits 24-31)

; GDT for data segment. base and length identical to code segment
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bits), always less then one then its true size
    dd gdt_start ; address (32 bits)

; constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start 