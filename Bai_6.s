.text
.equ	SW_BASE,	0xFF200040
.equ	LEDS_BASE,	0xFF200000
.equ	SDRAM_END,	0x03FFFFFF
.global	_start

_start:
	movia	r2,		LEDS_BASE
	movia	r3,		SW_BASE
	movia	sp,		SDRAM_END-3
	movia	r15,	0

START:
	ldwio	r17,	0(r3)
	andi	r10,	r17,	0b0000001111#multiplicand
	ldwio	r18,	0(r3)
	andi	r11,	r18,	0b0011110000#multiplier
	srli	r11,	r11,	4
	movia	r12,	0
	movia	r19,	1
	movia	r7,		1
	movia	r8,		4
	call	MUL
	ldw		r16,	0(r15)
	stwio	r16,	0(r2)
	br		START
MUL:
	subi	sp,		sp,		16
	stw		r10,	0(sp)
	stw		r11,	4(sp)
	stw		r12,	8(sp)
	stw		r7,		12(sp)
LOOP:
	andi	r5,		r11,	0b0001
	beq		r5,		r19,	ADD
	br		SHIFT
ADD:
	add		r12,	r12,	r10
	br		SHIFT
SHIFT:
	slli	r10,	r10,	1
	srli	r11,	r11,	1
	beq		r7,		r8,		END_FUNC
	addi	r7,		r7,		1
	br		LOOP
END_FUNC:
	stw		r12,	0(r15)
	ldw		r10,	0(sp)
	ldw		r11,	4(sp)
	ldw		r12,	8(sp)
	ldw		r7,		12(sp)
	addi	sp,		sp,		16
	ret
.end