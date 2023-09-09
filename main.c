#include "heap.h"
#include "paging.h"
#include "screen.h"
#include "scheduler.h"

/*
There are two VGA modes: text and grapics
To show on screen, entities (pixel or char) should be loaded to video memory (a part of main memory)
In text mode, starting address of video memory is b8000h (this is phyiscal memory). Width: 80, Height: 25
In graphics mode, starting address is a0000h. Width: 320, Height: 200
*/

void processA();
void processB();
void processC();
void processD();

void kernel_main()
{	
	process_t p1, p2, p3, p4;
	
	heap_init();
	paging_init();	
	screen_init();
	process_init();
	scheduler_init();
	
    // video[0] = 'A';
    // video[2] = 'B' why not video[1]? this is because the byte after char contains color information
    // Each memory location corresponds to Cartesian coordinate [k * 2] = (k % max_x, k / max_x) e.g. [0] = (0, 0), [2] = (1, 0)
	print( "Welcome to MiniOS!" );
	println();
	print( "We are now in Protected-mode" );
	println();
	
	process_create( &processA );
	process_create( &processB );
	process_create( &processC );
	process_create( &processD );
	
	asm( "sti" );
	
	while( 1 );
}

void interrupt_handler( int interrupt_number )
{
	print( "Interrupt Received " );
	printi( interrupt_number );
	println();
}

void processA()
{
	print( "Process A," );
  println();

	while ( 1 )
		asm( "mov $5390, %eax" );
}

void processB()
{
	print( "Process B," );
  println();

	while ( 1 )
		asm( "mov $5391, %eax" );
}

void processC()
{
	print( "Process C," );
  println();

	while ( 1 )
		asm( "mov $5392, %eax" );
}

void processD()
{
	print( "Process D," );
  println();

	while ( 1 )
		asm( "mov $5393, %eax" );
}
