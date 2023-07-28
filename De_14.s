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
	movia	r1,		1
_main:
	ldwio	r17,	0(r3)
	andi	r4,		r17,	0b1111111111
	movia	r8,		0
	movia	r5,		0
	movia	r11,	9
	call	COUNT
	br		_main
	
COUNT:
	subi	sp,		sp,		24
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r8,		8(sp)
	stw		r16,	12(sp)
	stw		r10,	16(sp)
	stw		r18,	20(sp)
LOOP:
	beq		r4,		r0,		CHECK_SEGMENT
	andi	r5,		r4,		0b0000000001
	beq		r5,		r1,		ADD1
	srli	r4,		r4,		1
	br		LOOP

CHECK_SEGMENT:
	bgt		r8,		r11,	SET_SEGMENT
	br		SEVEN_SEG_DECODER`

SET_SEGMENT:
	sub		r8,		r8,		r8		
	addi	r10,	r10,	1
	br		SEVEN_SEG_DECODER
	
ADD1:
	addi	r8,		r8,		1
	srli	r4,		r4,		1
	br		LOOP
	
SEVEN_SEG_DECODER:
	add 	r15, 	r7, 	r8
	ldb		r16, 	0(r15)
	stb 	r16, 	0(r9)
	addi 	r9, 	r9, 	1 #Qua segment tiep theo
	
	add 	r15, 	r7, 	r10
	ldb		r16, 	0(r15)
	stb 	r16, 	0(r9)
	
	movia 	r9, 	HEX_SEGMENTS
	ldw 	r16, 	0(r9)
	movia 	r18, 	HEX3_HEX0
	stwio 	r16, 	0(r18)
	br 		END_FUNC

END_FUNC:
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r8,		8(sp)
	ldw		r16,	12(sp)
	ldw		r10,	16(sp)
	ldw		r18,	20(sp)
	addi	sp,		sp,		24
	ret
	
.data
SEVEN_SEG_DECODE_TABLE:
	.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111
	.byte 0b01100110, 0b01101101, 0b01111101, 0b00000111
	.byte 0b11111111, 0b01100111, 0b00000000, 0b00000000
	.byte 0b00000000, 0b00000000, 0b00000000, 0b00000000
HEX_SEGMENTS: .fill 1, 4, 0

.end