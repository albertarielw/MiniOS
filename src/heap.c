#include "heap.h"

unsigned int heap_base;

void heap_init()
{
    heap_base = 0x100000;
}

// memory allocator, similar to malloc
// currently very simple but cannot free memory -> we need a way to know how to free memory
int kalloc(int bytes)
{
    unsigned int new_object_address = heap_base;

    heap_base += bytes;

    return new_object_address;
}