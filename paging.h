#ifndef PAGING_H
#define PAGING_H

#define PDE_NUM 3 // page directory entry
#define PTE_NUM 1024 // each page holds 1024 entry

extern void load_page_directory();
extern void enable_paging();

extern unsigned int *page_directory;

void paging_init();
int create_page_entry( int, char, char, char, char, char, char, char, char );

#endif // PAGING_H