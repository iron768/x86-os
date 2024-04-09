[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; the same one used for linking the kernel
jmp short boot
nop

boot:
    mov [BOOT_DRIVE], dl ; the bios sets up the boot drive in 'dl' on boot
    mov bp, 0x9000
    mov sp, bp

    call print_nl
    mov bx, MSG_REAL_MODE
    call print
    call print_nl

    call load_kernel ; read our kernel from disk
    call switch_to_pm ; disable interrupts, load GDT and finally jumps to 'BEGIN_PM'
    jmp $ ; this is never ran

%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/32bit_print.asm"
%include "boot/switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; read from our disk and store it in 0x1000
    ; the dh register is the LSB of the of the data "edx"
    mov dh, 32 ; kernel size!
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET ; give control to the kernel
    jmp $ ; stay here until the kernel gives us the control back (if they ever do)

BOOT_DRIVE db 0 ; store this in memory so 'dl' cannot be overridden
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Switched to 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0
MSG_RETURN_KERNEL db "Error -> Returned from kernel"

; padding
times 510 - ($ - $$) db 0
dw 0xaa55 ; bios magic word