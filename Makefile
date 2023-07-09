ASM = nasm
CC = gcc

SRC_DIR = src
BUILD_DIR = build

BOOTSTRAP_FILE = bootstrap.asm 
INIT_KERNEL_FILES = starter.asm
KERNEL_FILES = main.c
KERNEL_FLAGS = -Wall -m32 -c -ffreestanding -fno-asynchronous-unwind-tables -fno-pie
KERNEL_OBJECT = kernel.elf

.PHONY: build link run clean

build: $(SRC_DIR)/$(BOOTSTRAP_FILE) $(BUILD_DIR)/$(KERNEL_FILE)
	$(ASM) -f bin $(SRC_DIR)/$(BOOTSTRAP_FILE) -o $(BUILD_DIR)/bootstrap.o
	$(ASM) -f elf32 $(SRC_DIR)/$(INIT_KERNEL_FILES) -o $(BUILD_DIR)/starter.o 
	$(CC) $(KERNEL_FLAGS) $(SRC_DIR)/$(KERNEL_FILES) -o $(BUILD_DIR)/$(KERNEL_OBJECT)
	ld -melf_i386 -Tlinker.ld $(BUILD_DIR)/starter.o $(BUILD_DIR)/kernel.elf -o $(BUILD_DIR)/minios.elf
	objcopy -O binary $(BUILD_DIR)/minios.elf $(BUILD_DIR)/minios.bin
	dd if=$(BUILD_DIR)/bootstrap.o of=$(BUILD_DIR)/kernel.img
	dd seek=1 conv=sync if=$(BUILD_DIR)/minios.bin of=$(BUILD_DIR)/kernel.img bs=512 count=5
	dd seek=6 conv=sync if=/dev/zero of=$(BUILD_DIR)/kernel.img bs=512 count=2046

run:
	qemu-system-x86_64 -s $(BUILD_DIR)/kernel.img

clean:
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.img $(BUILD_DIR)/*.bin $(BUILD_DIR)/*.elf