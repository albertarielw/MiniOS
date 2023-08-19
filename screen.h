extern volatile unsigned char *video;

extern int nextTextPos;
extern int currLine;

void screen_init();
void print( char * );
void println();
void printi( int );
void cls();
