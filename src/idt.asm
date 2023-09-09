isr_0:
	cli
	; push number of current interrupt into the stack
	push 0
	jmp isr_basic

isr_1:
	cli
	push 1
	jmp isr_basic
	
isr_2:
	cli
	push 2
	jmp isr_basic
	
isr_3:
	cli
	push 3
	jmp isr_basic
	
isr_4:
	cli
	push 4
	jmp isr_basic
	
isr_5:
	cli
	push 5
	jmp isr_basic
	
isr_6:
	cli
	push 6
	jmp isr_basic
	
isr_7:
	cli
	push 7
	jmp isr_basic
	
isr_8:
	cli
	push 8
	jmp isr_basic
	
isr_9:
	cli
	push 9
	jmp isr_basic
	
isr_10:
	cli
	push 10
	jmp isr_basic
	
isr_11:
	cli
	push 11
	jmp isr_basic
	
isr_12:
	cli
	push 12
	jmp isr_basic
	
isr_13:
	cli
	push 13
	jmp isr_basic
	
isr_14:
	cli
	push 14
	jmp isr_basic
	
isr_15:
	cli
	push 15
	jmp isr_basic
	
isr_16:
	cli
	push 16
	jmp isr_basic
	
isr_17:
	cli
	push 17
	jmp isr_basic
	
isr_18:
	cli
	push 18
	jmp isr_basic
	
isr_19:
	cli
	push 19
	jmp isr_basic
	
isr_20:
	cli
	push 20
	jmp isr_basic
	
isr_21:
	cli
	push 21
	jmp isr_basic

isr_22:
	cli
	push 22
	jmp isr_basic
	
isr_23:
	cli
	push 23
	jmp isr_basic
	
isr_24:
	cli
	push 24
	jmp isr_basic
	
isr_25:
	cli
	push 25
	jmp isr_basic
	
isr_26:
	cli
	push 26
	jmp isr_basic
	
isr_27:
	cli
	push 27
	jmp isr_basic
	
isr_28:
	cli
	push 28
	jmp isr_basic
	
isr_29:
	cli
	push 29
	jmp isr_basic
	
isr_30:
	cli
	push 30
	jmp isr_basic
	
isr_31:
	cli
	push 31
	jmp isr_basic
	
; System Timer
isr_32:
	; part 1

	cli ; step 1 disable interrupt (when handling interrupt, btetter to not receive any other interrupt)
	
	; step 2 and 3
	; when this interrupt handler is called, context of the processor is the context of suspended process
	; we define ISRs gate descriptors as interrupt gates in IDT 
	; -> if we define as task gates, the context of the suspended gates in the IDT table will not be available directly on processor's registers
	
	; since context is reachable, we store in the stack (useful when scheduler needs to copy the context of the suspended process to the memory)
	; push into the stack also provides 2 benefits
	; 1. we can use register in current code as we wont lose the suspended process context
	; 2. method of passing parameters
	
	pusha ; step 2 pusha pushes values of all general registers in the order: EAX, ECX, EDX, EBX, ESP, EBP, ESI and EDI


	; step 3 to push EIP

	; Curr EIP is a pointer to curr instruction, not the one we want to suspend
	
	; Suppose A is running
	; We want to suspend A, so ISR32 is called
	; Return address to where A suspended is stored at the top of the stack (based on calling convention)
	; Then we run ISR32
	; At this point, ISR32 has put 8 registers to the stack (because of pusha)
	; ESP points to top of stack, to find return address of A (EIP of A) simply use esp + 32
	mov eax, [esp + 32]
	push eax

	call scheduler ; step 4 

	; ... ;

	; part 2

	; step 5

	; after scheduler, tell PIC we finish handling IRQ by send end of interrupt command to PIC
	mov al, 0x20
	out 0x20, al
	
	; step 6

	; jump to memory address in which the selected process were suspended
	; exploit calling convention again

	; remove all values added to stack by adding 40 (8 general register + EIP + 4 to get to the start of return address added)
	add esp, 40d
	push run_next_process

	iret ; step 7
	
isr_33:
	cli
	push 33
	jmp irq_basic
	
isr_34:
	cli
	push 34
	jmp irq_basic
	
isr_35:
	cli
	push 35
	jmp irq_basic
	
isr_36:
	cli
	push 36
	jmp irq_basic
	
isr_37:
	cli
	push 37
	jmp irq_basic

isr_38:
	cli
	push 38
	jmp irq_basic

isr_39:
	cli
	push 39
	jmp irq_basic

isr_40:
	cli
	push 40
	jmp irq_basic

isr_41:
	cli
	push 41
	jmp irq_basic

isr_42:
	cli
	push 42
	jmp irq_basic

isr_43:
	cli
	push 43
	jmp irq_basic

isr_44:
	cli
	push 44
	jmp irq_basic

isr_45:
	cli
	push 45
	jmp irq_basic

isr_46:
	cli
	push 46
	jmp irq_basic

isr_47:
	cli
	push 47
	jmp irq_basic
	
isr_48:
	cli
	push 48
	jmp irq_basic

isr_basic:
	; call C function interrput_handler
	call interrupt_handler
	
	; clean stack frame: pop stack frame and save popped value in eax (chosen arbitrarily)
	pop eax
	sti
	iret
	
irq_basic:
;	cli
	call interrupt_handler
	
	mov al, 0x20
	out 0x20, al
	
	cmp byte [esp], 40d ; Interrupt number
	jnge irq_basic_end
	
	mov al, 0xa0
	out 0x20, al
	
	irq_basic_end:
		pop eax
		sti
		iret
	
; The value of the flags from Basekernel (kernelcode.S) (https://github.com/dthain/basekernel)
idt:
	; handler_name, segment_selector, present, privilege_level, descriptor_size, gate_type (in this case interrupt)
	dw isr_0, 8, 0x8e00, 0x0000
	dw isr_1, 8, 0x8e00, 0x0000
	dw isr_2, 8, 0x8e00, 0x0000
	dw isr_3, 8, 0x8e00, 0x0000
	dw isr_4, 8, 0x8e00, 0x0000
	dw isr_5, 8, 0x8e00, 0x0000
	dw isr_6, 8, 0x8e00, 0x0000
	dw isr_7, 8, 0x8e00, 0x0000
	dw isr_8, 8, 0x8e00, 0x0000
	dw isr_9, 8, 0x8e00, 0x0000
	dw isr_10, 8, 0x8e00, 0x0000
	dw isr_11, 8, 0x8e00, 0x0000
	dw isr_12, 8, 0x8e00, 0x0000
	dw isr_13, 8, 0x8e00, 0x0000
	dw isr_14, 8, 0x8e00, 0x0000
	dw isr_15, 8, 0x8e00, 0x0000
	dw isr_16, 8, 0x8e00, 0x0000
	dw isr_17, 8, 0x8e00, 0x0000
	dw isr_18, 8, 0x8e00, 0x0000
	dw isr_19, 8, 0x8e00, 0x0000
	dw isr_20, 8, 0x8e00, 0x0000
	dw isr_21, 8, 0x8e00, 0x0000
	dw isr_22, 8, 0x8e00, 0x0000
	dw isr_23, 8, 0x8e00, 0x0000
	dw isr_24, 8, 0x8e00, 0x0000
	dw isr_25, 8, 0x8e00, 0x0000
	dw isr_26, 8, 0x8e00, 0x0000
	dw isr_27, 8, 0x8e00, 0x0000
	dw isr_28, 8, 0x8e00, 0x0000
	dw isr_29, 8, 0x8e00, 0x0000
	dw isr_30, 8, 0x8e00, 0x0000
	dw isr_31, 8, 0x8e00, 0x0000
	dw isr_32, 8, 0x8e00, 0x0000
	dw isr_33, 8, 0x8e00, 0x0000
	dw isr_34, 8, 0x8e00, 0x0000
	dw isr_35, 8, 0x8e00, 0x0000
	dw isr_36, 8, 0x8e00, 0x0000
	dw isr_37, 8, 0x8e00, 0x0000
	dw isr_38, 8, 0x8e00, 0x0000
	dw isr_39, 8, 0x8e00, 0x0000
	dw isr_40, 8, 0x8e00, 0x0000
	dw isr_41, 8, 0x8e00, 0x0000
	dw isr_42, 8, 0x8e00, 0x0000
	dw isr_43, 8, 0x8e00, 0x0000
	dw isr_44, 8, 0x8e00, 0x0000
	dw isr_45, 8, 0x8e00, 0x0000
	dw isr_46, 8, 0x8e00, 0x0000
	dw isr_47, 8, 0x8e00, 0x0000
	dw isr_48, 8, 0x8e00, 0x0000
	
idtr:
	idt_size_in_bytes	: 	dw idtr - idt
	idt_base_address	: 	dd idt
