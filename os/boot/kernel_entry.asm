global _start
[bits 32]

_start:
    [extern kernel_main] ; define our calling point, must have the same as kernel.c 'kernel_main' function
    call kernel_main ; calls our C function
    jmp $
