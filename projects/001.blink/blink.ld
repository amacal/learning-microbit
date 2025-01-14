MEMORY
{
    ROM : ORIGIN = 0x00000000, LENGTH = 256K
    RAM : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
    .vector : { KEEP(*(.vector)) } > ROM
    .text : { *(.text*) } > ROM
}
