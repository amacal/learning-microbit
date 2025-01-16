.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "a"
.align 10

// stack pointer and reset handler
.word 0x20020000
.word reset + 1

// System exception handlers
.rept 14
.word hang + 1
.endr

// Interrupts handlers
.rept 240
.word hang + 1
.endr

.thumb_func
reset:

    // configure GPIO P0.15 / ROW3
    ldr      r0, =0x5000073c            // PIN_CNF[15]
    mov      r1, #0x00000001            // DIR=output
    str      r1, [r0]

    // configure GPIO P0.31 / COL3
    ldr      r0, =0x5000077c            // PIN_CNF[31]
    mov      r1, #0x00000001            // DIR=output
    str      r1, [r0]

    // configure GPIO P0.22 / ROW2
    ldr      r0, =0x50000758            // PIN_CNF[22]
    mov      r1, #0x00000001            // DIR=output
    str      r1, [r0]

    // configure GPIO P0.11 / COL2
    ldr      r0, =0x5000072c            // PIN_CNF[11]
    mov      r1, #0x00000001            // DIR=output
    str      r1, [r0]

    // configure GPIO P0.14 / BTN_A
    ldr      r0, =0x50000738            // PIN_CNF[14]
    ldr      r1, =0x0003000c            // DIR=input, PULL=pull-up, INPUT=connect, SENSE=low
    str      r1, [r0]

    // configure GPIO P0.23 / BTN_B
    ldr      r0, =0x5000075c            // PIN_CNF[23]
    ldr      r1, =0x0003000c            // DIR=input, PULL=pull-up, INPUT=connect, SENSE=low
    str      r1, [r0]

blink:

    ldr      r0, =0x50000510
    ldr      r2, [r0]

btn_a:

    lsr      r3, r2, #14
    tst      r3, #0x01
    bne      btn_b

    // set to source current ROW3 + other column
    ldr      r0, =0x50000508            // OUTSET
    ldr      r1, =0x00008800            // P0.15+P0.11
    str      r1, [r0]

    // set to sink current COL3 + other rows
    ldr      r0, =0x5000050c            // OUTCLR
    ldr      r1, =0x80400000            // P0.31+P0.22
    str      r1, [r0]

btn_b:

    lsr      r3, r2, #23
    tst      r3, #0x01
    bne      end

    // set to source current ROW2 + other columns
    ldr      r0, =0x50000508            // OUTSET
    ldr      r1, =0x80400000            // P0.22+P0.31
    str      r1, [r0]

    // set to sink current COL2 + other rows
    ldr      r0, =0x5000050c            // OUTCLR
    ldr      r1, =0x00008800            // P0.11+P0.15
    str      r1, [r0]

end:

    // set to source all column
    ldr      r0, =0x50000508            // OUTSET
    ldr      r1, =0x80000800            // P0.11+P0.31
    str      r1, [r0]

    // set to sink all rows
    ldr      r0, =0x5000050c            // OUTCLR
    ldr      r1, =0x00408000            // P0.15+P0.22
    str      r1, [r0]

    b        blink

.thumb_func
hang:

    b        .
