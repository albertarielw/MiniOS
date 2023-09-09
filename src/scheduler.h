/*
Terms:

Current Process: process that is using the processor right now
Scheduler: choose next process based on some algo (in this case round robin)

Implementation:
choose next process -> context switch -> update PCB -> jump to process code 
*/

#ifndef SCHEDULER_H
#define SCHEDULER_H

#include "process.h"

extern int next_sch_pid, curr_sch_pid;
extern process_t *next_process;

void scheduler_init();
void scheduler(int eip, int edi, int esi, int ebp, int esp, int ebx, int edx, int ecx, int eax);
void run_next_process();

#endif // SCHEDULER_H