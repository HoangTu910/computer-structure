.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.equ 		KEY, 			0xFF200050
.equ 		HEX3_HEX0, 		0xFF200020
.global 	_start

_start:
	movia	r10,	0
	movia	sp,		SDRAM_END - 3
	movia	r3,		SW_BASE
	movia	r2,		LEDS_BASE
	movia	r7,		SEVEN_SEG_DECODE_TABLE

_main:
	ldwio	r17,	0(r3)
	andi	r4,		r17,	0b0000001111
	ldwio	r18,	0(r3)
	andi	r5,		r18,	0b0011110000
	srli	r5,		r5,		4
	movia	r6,		0
	movia	r12,	0
	movia	r14,	0 #Count
	movia	r11,	9
	call	DECODE
	br		_main

DECODE:
	subi	sp,		sp,		36
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r6,		8(sp)
	stw		r12,	12(sp)
	stw		r16,	20(sp)
	stw		r19,	24(sp)
	stw		r15,	28(sp)
LOOP:
	add		r10,	r5,		r4
	br		COUNT

COUNT:
	beq		r14,	r10,	SEVEN_SEG_DECODER
	addi	r6,		r6,		1
	addi	r14,	r14,	1
	bgt		r6,		r11,	CHUC
	br		COUNT
	
CHUC:
	mov		r6,		r0
	addi	r12,	r12,	1
	br		COUNT
	
	
SEVEN_SEG_DECODER:
	add 	r15, 	r7, 	r6
	ldb 	r16, 	0(r15)
	stb 	r16, 	0(r9)
	addi 	r9, 	r9, 	1
	
	add 	r15, 	r7, 	r12
	ldb 	r16, 	0(r15)
	stb 	r16, 	0(r9)
	
	movia 	r9, 	HEX_SEGMENTS
	ldw 	r16, 	0(r9)
	movia 	r19, 	HEX3_HEX0
	stwio 	r16, 	0(r19)
	br 		END_FUNC


END_FUNC:
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r6,		8(sp)
	ldw		r12,	12(sp)
	ldw		r16,	20(sp)
	ldw		r19,	24(sp)
	ldw		r15,	28(sp)
	addi	sp,		sp,		36
	ret
	
.data
SEVEN_SEG_DECODE_TABLE:
	.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111
	.byte 0b01100110, 0b01101101, 0b01111101, 0b00000111
	.byte 0b11111111, 0b01100111, 0b00000000, 0b00000000
	.byte 0b00000000, 0b00000000, 0b00000000, 0b00000000
HEX_SEGMENTS: .fill 1, 4, 0
.end