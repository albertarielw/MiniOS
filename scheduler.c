#include "scheduler.h"

int next_sch_pid, curr_sch_pid;
process_t *next_process;

void scheduler_init()
{
    next_sch_pid = 0;
    curr_sch_pid = 0;
}

process_t *get_next_process()
{
    // set next process
    process_t *next_process = processes[next_sch_pid];

    // set curr pid to next process
    curr_sch_pid = next_sch_pid;

    // determine next_sch_pid
    next_sch_pid++;
    next_sch_pid = next_sch_pid % processes_count;

    return next_process;
}

void scheduler( int eip, int edi, int esi, int ebp, int esp, int ebx, int edx, int ecx, int eax )
{
    process_t *curr_process;
    
    print( " EAX = " ); // For Testing Purpose
    printi( eax ); // For Testing Purpose
    
    // ... //
    
    // PART 1
    
    curr_process = processes[ curr_sch_pid ]; // currently running process to be saved in PCB
    next_process = get_next_process(); // next process to run
    
    // ... //
    
    // PART 2

    // save context of current process to PCB
    if ( curr_process->state == RUNNING )
    {
        curr_process->context.eax = eax;
        curr_process->context.ecx = ecx;
        curr_process->context.edx = edx;
        curr_process->context.ebx = ebx;
        curr_process->context.esp = esp;
        curr_process->context.ebp = ebp;
        curr_process->context.esi = esi;
        curr_process->context.edi = edi;
        curr_process->context.eip = eip;
    }
    
    curr_process->state = READY;
    
    // ... //
    
    // PART 3
    
    // opposite of PART 2 move context from PCB to registers
    asm( "  mov %0, %%eax;  \
            mov %0, %%ecx;  \
            mov %0, %%edx;  \
            mov %0, %%ebx;  \
            mov %0, %%esi;  \
            mov %0, %%edi;" 
            : : "r" ( next_process->context.eax ), "r" ( next_process->context.ecx ), "r" ( next_process->context.edx ), "r" ( next_process->context.ebx ),
                "r" ( next_process->context.esi ), "r" ( next_process->context.edi ) );
    
    next_process->state = RUNNING;
}

void run_next_process()
{
    // enable interrupt, then jump to the memory adddress which is stored in the EIP of next process PCB
    asm( "  sti;            \
            jmp *%0" : : "r" ( next_process->context.eip ) );
}