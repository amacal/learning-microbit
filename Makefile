.PHONY: blink

blink:
	arm-none-eabi-as -o projects/001.blink/blink.o projects/001.blink/blink.s
	arm-none-eabi-ld -T projects/001.blink/blink.ld -o projects/001.blink/blink.elf projects/001.blink/blink.o
	arm-none-eabi-objcopy -O ihex projects/001.blink/blink.elf projects/001.blink/blink.hex
	cp projects/001.blink/blink.hex /media/${HOST_USERNAME}/MICROBIT
