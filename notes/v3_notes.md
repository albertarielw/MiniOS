# Process Management

## The Basics of Process Management

One of kernel main responsibility is process management. Process is a running program.

Kernel provides system call: to allow above apps to use its services. This can be implemented using interrupts, similar to BIOS.

Process Control Block (PCB): stores process information -> minimaly store code + data

Inter Process Communication (IPC): shared memory, message passing

Data Races: unsynchronized access to data <- studied in Concurrency Control (DBMS)

Thread: lightweight process, Coroutine: lightweight tread

## The Basics of Multitasking

Multitasking: system can run multiple processes simultaneously

Context Switch: switch between processes

Multiprogramming: have a queue of ready process, once idle you switch

Time Sharing (extension of multiprogramming): switch before idle -> better scheduling

Process scheduling: algorithm to schedule processes

Round Robin: one of the scheduling algorithm -> queue of ready process, give a quanta to run then switch

Process context: registers to store data, change segment register valuem EIP -> save in PCB

Preemptyive vs Cooperative: CPU can force process to give up even if it is not done

## x86 Multitasking

Multitasking can be implemented by software or hardware. x86 provides hardware multitasking but now, we use software multitasking for portability currently some computers use a variaty of hardware architecture, not necessarily x86

x86 hardware multitasking

Task-State Segment: store context of a specific process

Each process has its own TSS and each TSS has entry in the GDT table -> TSS descriptor
Special registoer: task register should contain the segment selector of the currently running process TSS descriptor, the instruction ltr is used to store a value in this register

The structure of TSS descriptor in GDT table is same as segment descriptor. The only differnece is type field -> which has static binary value 010B1 in TSS descriptor where B (busy flag) should have 1 when active 0 when inactive

Context switching in x86

Method 1: call or jump to TSS descriptor in GDT and the operand. Suppose scheduler select process A as the next process to run, scheduler can cause context switch by using the call or jmp and the operand should be the segment selector of A's TSS descriptor. The processor is going to take a copy of currently running process (e.g. B) andstore it in B's own TSS then value of A's TSS will be loaded into the processor registers and then execute A

Method 2: call or jump to task gate. Task gate descriptor can be defined in a task gate. When process is called instead of jumped to it should return using iret 

## Implementing Process Management

1. Setup task-state segment (so kernel can let user space software to run)

2. Basic data structure for process table and process sontrol block (will be more complicated when we have dynamic memory allocation)

3. Scheduer + system timer's interrupt -> to enforce pre emptive multitasking, round robin algo

4. Create number of dummy process to test

