#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "../libc/mem.h"

#include <stdint.h>

void kernel_main() {
    isr_install();
    irq_install();

    kprint("Operating system loaded.");
    kprint_nl();

    kprint("Type something, it will run through the shell\n type END to halt \n>");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        kprint("Stopping the CPU, goodbye! \n");

        asm volatile("hlt");
    } else if (strcmp(input, "PAGE") == 0) {
        // test kmalloc
        uint32_t phys_addr;
        uint32_t page = kmalloc(1000, 1, &phys_addr);

        char page_str[16] = "";

        hex_to_ascii(page, page_str);

        char phys_str[16] = "";

        hex_to_ascii(phys_addr, phys_str);

        kprint("Page: ");
        kprint(page_str);
        kprint(", physical address: ");
        kprint(phys_str);

        kprint_nl();
    } else if (strcmp(input, "CLR") == 0) {
        clear_screen();
        
        kprint("Cleared screen.");
        kprint_nl();
    } else {
        kprint("Syntax Error: ");
        kprint(input);
        kprint("\n> ");
    }
}