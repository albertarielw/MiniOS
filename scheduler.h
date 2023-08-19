/*
Terms:

Current Process: process that is using the processor right now
Scheduler: choose next process based on some algo (in this case round robin)

Implementation:
choose next process -> context switch -> update PCB -> jump to process code 
*/

#include "process.h"

int next_sch_pid, curr_sch_pid;

process_t *next_process; // reference to the PCB of the next process

void scheduler_init(); // initialize values of the global variables
process_t *get_next_process();
void scheduler( int, int, int, int, int, int, int, int, int ); // 
void run_next_process();