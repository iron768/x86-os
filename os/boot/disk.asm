; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
    pusha
    ; reading from the disk needs specific values in all registers
    ; we will overwrite our input parameters from registers 'dx', so we need to save to the stack to use later
    push dx

    mov ah, 0x02 ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh ; al <- number of sectors to read (0x01 .. 0x80)
    mov cl, 0x02 ; cl <- sector (0x01 .. 0x11)
    ; 0x01 is our boot sector, 0x02 is the first 'available' sector
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper two bits in 'cl')
    ; dl <- drive number, our caller sets it as a parameter and gets it from the BIOS
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)

    ; [es:bx] <- pointer to buffer where the data will be saved and stored
    ; caller sets it up for us, and it is actually the standard location for int 13h
    int 0x13 ; BIOS interrupt 
    jc disk_error ; if error happens (its stored in the carry bit)

    pop dx
    cmp al, dh ; BIOS sets the 'al' to the number of sectors read and compare it
    jne sectors_error
    popa
    ret 

disk_error:
    mov bx, DISK_ERROR 
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = disk drive that had the error
    call print_hex ; disk status error codes can be found at : https://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR 
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0