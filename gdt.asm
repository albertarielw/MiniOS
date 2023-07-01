gdt:
    ; in x86, first entry is null descriptor
    null_descriptor :   dw 0, 0, 0, 0
    ; code and data segment of kernel
    kernel_code_descriptor  : dw 0xffff, 0x0000, 0x9a00, 0x00cf
    kernel_data_descriptor  : dw 0xffff, 0x0000, 0x9200, 0x00cf
    ; code and data segment of user application
    userspace_code_descriptor   : dw 0xffff, 0x0000, 0xfa00, 0x00cf
    userspace_data_descriptor   : dw 0xffff, 0x0000, 0xf200, 0x00cf

gdtr:
    ; size: 5 entries, each 8 byte
    gdt_size_in_bytes   :   dw ( 5 * 8 )
    gdt_base_address    :   dd gdt
