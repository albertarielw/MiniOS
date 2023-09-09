; start indicates starting point of the execution
start:

    ; we want to move 07C0h to ds (why? it will be explained in later segment)
    ; we cannot mov ds, 0x08C0 directly because ds (segment register) cannot be loaded with value directly in x86
    ; further details: https://stackoverflow.com/questions/19074666/8086-why-cant-we-move-an-immediate-data-into-segment-register
	mov ax, 07C0h
	mov ds, ax
		
	
    ; define si to be title_string or message_string
    ; call print_string which prints to screen the values saved in si
	mov si, title_string
	call print_string ; "CALL" is used instead of "JMP" because we would like to return to the next instruction after "print_string" finishes.
	
	mov si, message_string
	call print_string
	
	
	call load_kernel_from_disk
	
    ; gives control to kernel by jumping to the start of the kernel
    ; 0900h is the same value we have loaded in the register es in the beginning of load_kernel_from_disk
    ; 0000 is the offset we have specified in the register bx in load_kernel_from_disk before calling 02h:13h
	jmp 0900h:0000

; BIOS service 13h:02h loads the required sector into the memory address es:bx
; So, the value 0900h which has been set to es in the code above will be the starting memory address of the kernel
; Previously, it was enough to set bx = 0 since we only load 1 sector -> the code will reside from offset 0 to 511
; Now we are loading > 1 sector so we need to increment bx
load_kernel_from_disk:	
	; increment bx by 1 sector to load the next sector
	mov ax, [curr_sector_to_load]
	sub ax, 2
	mov bx, 512d
	mul bx
	mov bx, ax
	
	mov ax, 0900h
	mov es, ax

    ; service number 02h is specified to register ah
    ; it reads sectors from the hard disk and loads them into the memory
	mov ah, 02h     

    ; 01h is the number of sector we ants to read (since simple_kernel.asm is < 512 bytes, 1 sector is enough)
	mov al, 1h    	

	; 0h is the track number we would like to read (track 0)
	mov ch, 0h      

	; 02h is the sector number we would like to read (sector 2)
	mov cl, [curr_sector_to_load]     

	; 0h is the head number (of the disk)
    ; specifies the type of disk
    ; 0h means floppy disk, 80h means hard disk #0, 81h means hard disk #1, etc.
    ; the value of bx is the memory address that the content will be loaded into
    ; we are reading one sector and the content will be stored on memory address 0h
	mov dh, 0h      
	mov dl, 80h     ; Drive to read from. (0 = Floppy. 80h = Drive #0. 81h = Drive #1)
	int 13h         ; BIOS Disk Services
	
    ; when the content is loaded successfully, BIOS service 13h:02h set carry flag to 0, otherwise 1 and stores error code in ax
    ; if cf is 1 jc will jump
	jc kernel_load_error

    ; increment curr_sector_to_load, decrement number_of_sectors_to_load
	sub byte [number_of_sectors_to_load], 1
	add byte [curr_sector_to_load], 1
	cmp byte [number_of_sectors_to_load], 0
	
	jne load_kernel_from_disk
	
	ret

; When the bootloader fails to load the kernel. A nice message is printted for the user.
kernel_load_error:
	mov si, load_error_string
	call print_string
	
	; "$" is a special expression in NASM. It means the starting memory address (or assembly position?) of current instruction, that means
	; the following instruction is going to loop forever. 
	jmp $

; ... ;
; ... ;

; BIOS provides video services through intrrupt 10h. The value of the register "ah" decides which video service that we are requesting from BIOS.
; Those BIOS services are only available on Real Mode (https://stackoverflow.com/questions/26448480/bios-interrupts-in-protected-mode)
;
; ah = 0Eh means that we wish to print a character in TTY mode.
; For an example of using service "0Eh" to print "Hello" character by character, please refer to "../examples/bootstrap/1/".
	
print_string:
	; specify function for printing character
	mov ah, 0Eh

print_char:
    ; char to print is passed via si
    ; lodsb will transfer first character of the string to the register al and increase value of si by 1 byte
	lodsb
	
	cmp al, 0
	je printing_finished
	
	int 10h

	jmp print_char

printing_finished:
    mov al, 10d ; print new line 10d = ENDL
    int 10h
    
    ; reading current cursor position
    mov ah, 03h ; specify service for reading current position of cursor
	mov bh, 0
	int 10h
	
	; move the cursor to the beginning
	mov ah, 02h ; specify service for setting cursor to position 0
	mov dl, 0 ; position to be set is passed to dl
	int 10h
    
    ; print_string is a procedure (or function), therefore we should return. It is called by using "CALL" instead of "JMP".
	ret

title_string        		db  'The Bootloader of 539kernel.', 0
message_string      		db  'The kernel is loading...', 0
load_error_string   		db  'The kernel cannot be loaded', 0
number_of_sectors_to_load 	db 	10d ; 255 sectors = 127.5KB ; [MQH] NEW 4 July 2021
curr_sector_to_load 		db 	2d

; write the magic signature 0xAA55
times 510-($-$$) db 0

; pad with 0 so magic signature is at loc 510-511 (0-based)
dw 0xAA55
