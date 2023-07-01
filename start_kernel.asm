; since switch 16 bit real mode -> 32 bit protected mode
bits 32

start_kernel:
    ; set segment selector
    mov eax, 10h
    mov ds, eax
    mov ss, eax

    mov eax, 0h
    mov es, eax
    mov fs, eax
    mov gs, eax

    ; enable interrupt
    sti

    call kernel_main

