#include "screen.h"

void screen_init() {
    video = 0xB8000;
    nextTextPos = 0;
    currLine = 0;
}