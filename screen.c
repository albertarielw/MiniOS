#include "screen.h"

void screen_init() {
    video = 0xB8000;
    nextTextPos = 0;
    currLine = 0;
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
