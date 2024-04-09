[bits 16]
switch_to_pm:
    cli ; first step, disable interrupts
    lgdt [gdt_descriptor] ; second step, load our GDT

    mov eax, cr0 ; to switch to protected mode we need to set the first bit of cr0, a control register
    or eax, 0x1 ; third step, set the 32 bit mode in the control register
    mov cr0, eax ; update the control register
    
    jmp CODE_SEG:init_pm ; fourth step, jump far by using a different segment

[bits 32]
; from here on we are in 32 bit mode
init_pm:
    ; since switching to 32 bit mode our segments are useless, we need to fix this
    ; using our GDT we can point the segment registers to the points defined in the GDT 
    mov ax, DATA_SEG ; fifth step, update our segment registers 
    mov ds, ax 
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; sixth step, update the stack on the top 
    mov esp, ebp

    call BEGIN_PM ; seventh and final step, call some well known label