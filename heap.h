// base of heap from which we will allocate some memory for functions
extern unsigned int heap_base;

void heap_init();
int kalloc( int );