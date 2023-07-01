Basic x86 Architecture

1. Processor as a library and framework
library: provides instructions to call
framework: general rules to organize overall execution

2. operating mode of processor
it specifies: max registers size, available features, etc.
e.g. 
our bootloader in v1 works on x86 real mode -> max register size 16 bit
there are also protected mode -> 32 bits
long mode -> 64 bits

3. security concerns -> we run programs from unknown sources
- kernel memory cant be read/ written, kernel code cant be called without consent
- sensitive instructions e.g. switch real -> protected mode are only allowed for kernels
- in multitasking -> tasks should be protected from one another

solution: 
- 4 (or 2) privilege levels -> 0: kernel 1-2: device drivers 3: user app
- segmentation/ paging

4. numbering system: 1b 1h 1d ...
1 bit hex = 4 bits binary

5. Basic view of memory
logical vs physical memory space

6. x86 Segmentation
physical view: addressable array of bytes
logical view: can be created by software or hardware e.g. x86 processor (hardware)

in x86 physical address - paging -> linear memory address - segmentation -> logical address

x86 logical view: separate memory into segments e.g. code segment, data segment, stack segment
this segmentation is unavoidable (cannot turn off)

real mode

x86 uses segment register: 
- it stores starting memory address
- CS (code segment), SS, DS, ES, FS and GS 
- each segment register is 16 bits
- each segment is 64 KB.

near call/ jump: inside same segment -> does not cause change in segment register e.g. jmp 1d
far call/ jump: different segment -> cause change in segment register e.g. jmp 900d:1d (segment register becomes 900d)

example:
mov ax, 07C0h
mov ds, ax

set data segment to be 07C0h, so read/ write data will be relative to this

protected mode

fundamentally same as real mode, extended to provide memory protection:

Global Descriptor Table (GDT): stored in main memory, starting memory is saved in special purpose register GDTR as reference
segment descriptor: each entry in GDT, size of 8 bytes -> contains segment info e.g. starting memory, limit
segment selector: index to refer to segment descriptor

in real mode the value of segment register (e.g. CS) is actual address
in protected mode it is segment selector

segment descriptor 
- use: stores segment information + memory protection (each memory reference is monitored by the processor) e.g. user program tries to kill kernel
- terminology: flag -> 1 bit info field -> > 1 bit info
- logical address consists of 16 bit segment selector and 32 bit offset
- structure:
    - base address: bytes 2, 3, 4 Least Significant Bytes, byte 7 is most significant byte -> total 32 bits 
    - limit: 20 bit limit field (limit is a form of protection, avoid access outside of authorized segment)
    - Granularity (G Flag): 0 -> limit field is in 10 bytes 1 -> limit field in 4KB
    - Segment Type Falg (S Flag): 0 -> system, 1 -> application
    - Type field: 0 -> data 1 -> code
    - if code segment:
        - read-enabled (R flag): 1 execute and read 0 execut cannot read
        - conforming (C flag): 1 less privileged can access 0 less privileged cannot access
    - if data segment:
        - expansion-direction (E flag)
        - write-enabled (W flag)
    - Privilege level
    - Presence in memory (whether it is loaded into the memory)
    - Other flags:
        1. if code segment: default operation flag (D Flag)
           if stack segment: default stack pointer size (B Flag) -> 1: stack pointer is 32 bits and stored in ESP, 0: 16 bits, SP
        2. L flag: 

special register GDTR stores base physical address 

segment type
- application segment: data n code
- system segment

LDT (GDT but local): can define multiple, each is specific to a process (though cna be shared) -> use lldt instruction

7. x86 run-time 

7.1 Stack (grows downwards in x86 why though?):

1 stack frame = 1 function
EBP: stack frame base pointer -> starting mem address of the current stack
ESP: stack pointer -> mem address of top of the stack

push: decrement ESP 
pop: increment ESP

note: some prog language (esp derived from Algol) differentiate function (returns value) from procedure (does not return value)

7.1.1 Calling Convention (PLEASE READ IN MORE DETAILS)

A caller B callee

A pass params to B = push params (push in a reversed order) -> push to stack frame of A, so params of B will be in stack frame of A
push current value of EIP (returning memory address) -> value of EIP is right after call to B
x86 instruction call can be used to jump to B's code

A:
; A’s Code Before Calling B

push p3
push p2
push p1
call B
; Rest of A’s Code

the processor will start executing B -> need to set up stack frame for B -> this is done by moving the value of ESP (on top op stack) to EBP so it points to the new starting memory of the new stack frame -> but we need to save the old value of EBP so push EBP to the stack first

B:
push ebp
mov ebp, esp

; Rest of B’s Code

B can push local variable onto the stack. However, pushing new items change ESP but EBP remains the same -> we can use EBP to access older values without popping the stack

e.g.
B:
; Creating new Stack Frame
push ebp
mov ebp, esp

push 1 ; Pushing a local variable
push 2 ; Pushing another local variable

; Reading the content
; of memory address EBP + 4
; which stores the value of
; the parameters p1 and moving
; it to eax.
mov eax, [ebp + 8]

; Reading the value of the
; first local varaible and
; moving it to ebx.
mov ebx, [ebp - 4]

note: EBP -> memory address [EBP] -> value stored in that address

; Rest of B’s Code

when B finishes and needs to return a value, this value should be stored in EAX
B then deallocate its own stack frame
load returning address to EIP and resume A -> this can be done using the x86 instruction ret

A gains back control -> can deallocate (pop) B params

7.1.3 growth direction of run-time stack: downward -> earlier is placed in larger memory address (e.g. 10000), later smaller

mem addresses
20d
16d
12d
...
0d

7.1.4 grow downward vs upward
 
expansion-direction flag 0 -> downward, 1 -> upward

by default downward but why upward?

problem with downward -> resizing requires updating of memory addresses 

8. Interrupts

Interrupts vs Exceptions

E.g. interrupt: system timer for context switch, press keyboard (device driver), software interrupt -> system call

Interrupt Descriptor Table (IDT) 
- Entry to IDT is a gate descriptor each one is 8 bytes, can contain up to 256 gate descriptors
- 3 types: task, interrupt, trap gates
- interrupt vs trap: interrupt cannot be interrupted except by non-maskable interrupts, trap gate can be interrupted by new interrupt
however, we can disable interrut using x96 instruction cli

interrupt number -> IDT entry index 0 - 21 used by x86, 22 - 31 reserved, 32 - 255 system programmers can use

IDTR (similar to GDTR): lidt means load IDT