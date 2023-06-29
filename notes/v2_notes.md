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

7. x86 run-time stack



