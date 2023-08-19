/*
Process Data Structure

Static memory allocation: memory size is known at compile time (e.g. local variables, parameters, function invocation) -> stack
Dynamic memory allocation: memory size is only known at run time -> heap

Dynamic memory allocation is done by memory allocator (e.g. Doug Lea's memory allocator)
C++, Java, Python -> automatic memory allocation
C -> manual using malloc

In V3: 
use static memory allocation through global variables (dynamic memory allocation will be added in V4)
can only use pre-defined processes -> but the focus of this version is mainly for process scheduling

Process Control Block

Store process information: state (currently running or ready), process context
*/

typedef enum process_state { READY, RUNNING } process_state_t;

typedef struct process_context
{
    int eax, ecx, edx, ebx, esp, ebp, esi, edi, eip;
} process_context_t;

typedef struct process
{
    int pid;
    process_context_t context;
    process_state_t state;
    int *base_address; // when kernel intend to run a process for the first time, jump to base_address
} process_t;

process_t *processes[ 15 ];

int processes_count; // number of process -> for modulo in round robin
int curr_pid;

void process_init();
void process_create( int *, process_t * ); // params: pointer to base address of process, pointer to PCB
