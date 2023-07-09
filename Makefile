ASM = nasm
CC = gcc
BOOTSTRAP_FILE = bootstrap.asm 
INIT_KERNEL_FILES = starter.asm
KERNEL_FILES = main.c
KERNEL_FLAGS = -Wall -m32 -c -ffreestanding -fno-asynchronous-unwind-tables -fno-pie
KERNEL_OBJECT = -o kernel.elf

build: $(BOOTSTRAP_FILE) $(KERNEL_FILE)
	$(ASM) -f bin $(BOOTSTRAP_FILE) -o bootstrap.o
	$(ASM) -f elf32 $(INIT_KERNEL_FILES) -o starter.o 
	$(CC) $(KERNEL_FLAGS) $(KERNEL_FILES) $(KERNEL_OBJECT)
	ld -melf_i386 -Tlinker.ld starter.o kernel.elf -o minios.elf
	objcopy -O binary minios.elf minios.bin
	dd if=bootstrap.o of=kernel.img
	dd seek=1 conv=sync if=minios.bin of=kernel.img bs=512 count=5
	dd seek=6 conv=sync if=/dev/zero of=kernel.img bs=512 count=2046

run:
	qemu-system-x86_64 -s kernel.img

clean:
	rm -rf *.o *.img *.bin *.elf