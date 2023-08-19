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

Currently: running or ready state

*/