#include "screen.h"

/*
There are two VGA modes: text and grapics
To show on screen, entities (pixel or char) should be loaded to video memory (a part of main memory)
In text mode, starting address of video memory is b8000h (this is phyiscal memory). Width: 80, Height: 25
In graphics mode, starting address is a0000h. Width: 320, Height: 200
*/
#include "screen.h"
#include "scheduler.h"

void processA();
void processB();
void processC();
void processD();

void kernel_main()
{
	process_t p1, p2, p3, p4;
	
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
	
    process_create( &processA, &p1 );
    process_create( &processB, &p2 );
    process_create( &processC, &p3 );
    process_create( &processD, &p4 );
	
	while( 1 );
}

void interrupt_handler( int interrupt_number )
{
	println();
	print( "Interrupt Received " );
	printi( interrupt_number );
}

// iterates through character in a string until \0 is found
// for each character, figures out the right position to print (based on memory location) and print it onto screen
void print( char *str )
{
	int currCharLocationInVidMem, currColorLocationInVidMem;
	
	while ( *str != '\0' )
	{
        currCharLocationInVidMem = nextTextPos * 2;
		currColorLocationInVidMem = currCharLocationInVidMem + 1;
		
		video[ currCharLocationInVidMem ] = *str;
		video[ currColorLocationInVidMem ] = 15;
		
		nextTextPos++;
		
		str++;
	}
}

void println()
{
	nextTextPos = ++currLine * 80; // because the screen width in 03h is 80
}

void printi( int number )
{
	char* digitToStr[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };
	
	if ( number >= 0 && number <= 9 )
	{
		print( digitToStr[ number ] );
		return;
	}
	else
	{
		int remaining = number % 10;
		number = number / 10;
		
		printi( number );
		printi( remaining );
	}
}