Chapter 1. Starts with bootloader

1. Compiler vs assembler?
compiler translates source code to machine code is compiler
assembler translates assembly code to machine code e.g. netwide asm (nasm) by Intel, GNU asm (gasm) by AT&T

2. Why is bootloader written in assembly?
- Because of the need for higher control of hardware e.g. manipulate registers which higher level language cannot
- BIOS may not support higher level language e.g. higher level language may need OS routine or syscalls

3. x86 

registers?
- the registers are 32 bit so 16 bit processor cannot supoort
- 8 GPRs: EAX EBX ECX EDX + ESI EDI EBP ESP
IP (instruction pointer)/ EIP -> program counter
EAX used to be AX in 16 bit
in fact AX: first 16 bits AL (low): first 8, AH (high): next 8

instruction set?
- like function e.g. mov al, 01h ; h means hexadecimal

4. nasm

nasm -f <binary_format> <filename> [-o <output>]

binary_format gives a specification which gives a blueprint of how a binary file is organized (how it is tructured etc.)

types:
bin:	Raw binary file. This is the simplest format, and it is the default format.
coff:	COFF object file. This is a portable format that is supported by many different operating systems.
elf:	ELF object file. This is the most widely used format for Linux and Unix operating systems.
macho:	Mach-O object file. This is the native format for macOS.
rdf:	RDF object file. This is a format that is used by some debuggers.
ith:	Intel HEX object file. This is a format that is used to store binary data in a human-readable format.
dbg:	Debugging information file. This file contains information that can be used by a debugger to debug your program.

from the format, a system will assume some specifications with regards to the format

5. GNU Make

Automate building process (compiling, linking, assembling)
Makefile is text which tells GNU Make the building process

target: prerequisite
    recipe

memorize makefile cheatsheet

c_compiler = gcc
buid_dependencies = file1.o file2.o
file1_dependencies = file1.c
file2_dependencies = file2.c file2.h
bin_filename = ex_file
build: $(buid_dependencies)
    $(c_compiler) -o $(bin_filename) $(buid_dependencies)
file1.o: $(file1_dependencies)
    gcc -c $(file1_dependencies)
file2.o: $(file2_dependencies)
    gcc -c $(file2_dependencies)

6. Use virtual machine e.g. qemu or bochs to run kernel image: more convenient due to easier debugging

7. What is the bootloader?

BIOS -> loads bootloader -> to load OS, prepare system in the state expected by OS, in protected 32 bit system need to collect critical info
such as memory information which are safe/ reserved by hardware

Firmware of a computer is the program that loads the bootloader e.g. BIOS (used by IBM compatible PCs)

Boot sector: first sector of the hard disk where bootloader is

In BIOS computer, size of bootloader is limited to 512 Bytes (due to hard disk sector size - each one is 512 bytes)

Boot process runs in x86 operating mode known as real mode (16 bit environment), even if the processor is 64 bit processor can only use 16 bit

- Hard disk structure

CDs stacked on top of each other
Has 2 heads (read and write heads)

Seek time (move head to the right track) + rotational latency (rotate track to be at the right sector) + tranfer time (transfer from disk to memory)

in boot process: go to track 0, sector 0, loads first sector

- BIOS 

BIOS service: similar to functions in higher level function -> we can call them, they are in
the form of a set of interrupt nums.

Service category = library e.g. 10h (or 0x10) -> category of video services
service = function in that library

example:
```
mov ah, 0Eh ; specify service number and put them in ah register
int 10h ; call service category
```

For example, the service 0Eh in interrupt 10h expects to find the character
that the user wants to print in the register al, so, the register al is one
of service 0Eh parameters. The following code requests from BIOS to
print the character S on the screen:
```
mov ah, 0Eh
mov al, ’S’
int 10h
```

- NASM and x86 

[label:] instruction operands ; comments

e.g.
; prints character 'S' to screen
func:
    mov ah, 0Eh
    mov al, ’S’
    int 10h

colon : is optional
call_video_service int 10h
call_video_service
    int 10h

a. call and ret
call -> sets current position as return address, then invoke another funciton
ret -> gets the saved return address and continue from there

print_two_times:
    call print_character_S_with_BIOS
    call print_character_S_with_BIOS
    ret

print_character_S_with_BIOS:
    mov ah, 0Eh
    mov al, ’S’
    int 10h
    ret

b. one-way unconditional jump

jmp -> does not save return address so continue from there/ ret can't be used
print_character_S_with_BIOS:
    mov ah, 0Eh
    mov al, ’S’
    jmp call_video_service

print_character_A_with_BIOS:
    mov ah, 0Eh
    mov al, ’A’

call_video_service:
    int 10h

infinite loop example
infinite_loop:
    jmp infinite_loop

c. conditional jump

status register: bits to store values e.g. first bit (bit zero) for carry result

je -> jump if equal
jne -> jump if not equal

main:
    cmp al, 5
    je the_value_equals_5
    ; The rest of the code of ‘main‘ label

d. load string

lodsb -> load single byte
lodsw -> load single word
loadsd -> load double word

e. pseudo instructions
not actual x86 instruction, NASM intrepets them and convert them to actual instruction

f. declare bytes

our_variable db ’abc’, 0

g. repeat instruction

times 5 call print_character_S_with_BIOS
times 100 db 0

h. special instruction

$ which points to the beginning of the assembly position of the current source line

$$ which points to the beginning of the current section of assembly code.

e.g. jmp $

8. Implementing Bootloader

BIOS-family

size: 512 bytes
loads the bootloader in the memory address 07C0h
recognize as bootloader if it ends with AA55h

to build: bootloader bootstrap.asm, kernel simple_kernel.asm and Makefile
