#include "process.h"

process_t *processes[15];
int processes_count, curr_pid;

void process_init()
{
    processes_count = 0;
    curr_pid = 0;
}

void process_create( int *base_address, process_t *process)
{
    // new id is assigned to new process
    process->pid = curr_pid++;

    // initialize context 
    process->context.eax = 0;
    process->context.ecx = 0;
    process->context.edx = 0;
    process->context.ebx = 0;
    process->context.esp = 0;
    process->context.ebp = 0;
    process->context.esi = 0;
    process->context.edi = 0;

    // EIP is initialized with the starting point of the process' code
    // So scheduler loads the correct value to the register EIP
    process->context.eip = base_address;

    // set as ready
    // in V3 only READY and RUNNING
    process->state = READY;

    process->base_address = base_address;

    processes[ process->pid ] = process;
    processes_count++;
} 