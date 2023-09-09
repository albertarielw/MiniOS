; The values of the decriptors from Basekernel (kernelcode.S) (https://github.com/dthain/basekernel)
gdt:

	; in x86, first entry is null descriptor
	null_descriptor				: 	dw 0, 0, 0, 0

	; code and data segment of kernel
	kernel_code_descriptor		: 	dw 0xffff, 0x0000, 9a00h, 0x00cf
	kernel_data_descriptor		: 	dw 0xffff, 0x0000, 0x9200, 0x00cf

	 ; code and data segment of user application
	userspace_code_descriptor	: 	dw 0xffff, 0x0000, 0xfa00, 0x00cf
	userspace_data_descriptor	: 	dw 0xffff, 0x0000, 0xf200, 0x00cf
	
	; DON'T FORGET TO CHANGE THE SIZE OF THE GDT
	tss_descriptor				:	dw tss + 3, tss, 0x8900, 0x0000

gdtr:
	; size: 6 entries, each 8 byte
	gdt_size_in_bytes	: 	dw ( 6 * 8 ) ;= 28h
	gdt_base_address	: 	dd gdt

