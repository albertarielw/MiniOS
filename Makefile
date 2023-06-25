ASM = nasm

SRC = src
BUILD = build

BOOTSTRAP_FILE = $(SRC)/bootstrap.asm
KERNEL_FILE = $(SRC)/simple_kernel.asm

.PHONY: all build clean

build: $(BOOTSTRAP_FILE) $(KERNEL_FILE) create_build_folder
	$(ASM) -f bin $(BOOTSTRAP_FILE) -o $(BUILD)/bootstrap.o
	$(ASM) -f bin $(KERNEL_FILE) -o $(BUILD)/kernel.o
	dd if=$(BUILD)/bootstrap.o of=$(BUILD)/kernel.img
	dd seek=1 conv=sync if=$(BUILD)/kernel.o of=$(BUILD)/kernel.img bs=512
	qemu-system-x86_64 -s $(BUILD)/kernel.img

create_build_folder:
	@mkdir -p build

clean:
	rm -f *.o *.img