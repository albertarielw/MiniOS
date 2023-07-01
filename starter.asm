; runs in 16 bits
; to prepare proper environment for main kernel by: 
; - init and load GDT 
; - set interrupts 
; - set video mode
; - change 16 bit real mode to 32 bit protected mode

; tell NASM to generate 16 bit code since we will be using 16 bit real mode
; in the bootloader don't need to do this because: for flat binary the default is 16 bit but we use ELF32
bits 16 
; extern tells NASM that there is a function/ variable define outside this code, it will be figured out by the linker
extern kernel_main

start:
    mov ax, cs ; set proper memory address of ds depending on the value of cs
    mov ds, ax

    call load_gdt
    call init_video_mode
    call enter_protected_mode
    call setup_interrupts

    call 08h:start_kernel

; TODO: implement setup interrupt
setup_interrupts:
    ret

load_gdt:
    ; turn off interrupts (recommended by x86)
    cli 
    ; substract address of start from gdtr, take this resulting address and load the content there
    ; why gdtr - start instead of gdtr?
    ; in real mode, gdtr -> is seen as offset from segment register instead of full address
    lgdt [gdtr - start]

    ret


