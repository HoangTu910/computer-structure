.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.global 	_start

_start:
	movia	r10,	0
	movia	sp,		SDRAM_END - 3
	movia	r3,		SW_BASE
	movia	r2,		LEDS_BASE

_main:
	ldwio 	r17,	0(r3)
	andi	r4,		r17,	0b0011111111
	movia	r5,		2
	movia	r6,		1
	movia	r7,		0 #Count
	movia	r11,	0
	add		r11,	r11,	r4
	call	CHECK_SNT
	ldw		r16,	0(r10)
	stwio	r16,	0(r2)
	br		_main
	
CHECK_SNT:
	subi	sp,		sp,		16
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r11,	8(sp)
	stw		r6,		12(sp)
	
LOOP:
	bgt		r5,		r4,		OUTPUT2
	bgt		r6,		r4,		OUTPUT2
	bgt		r0,		r11,	ADDR6 #neu khong chia het thi tang r6 de tiep tuc bai toan
	beq		r11,	r0,		COUNT #neu chia het thi ++
	sub		r11,	r11,	r6 #chia r4 cho N (N tang dan)
	br		LOOP

COUNT:
	addi	r7,		r7,		1
	addi	r6,		r6,		1
	movia	r11,	0
	add		r11,	r11,	r4
	br		LOOP

ADDR6:
	addi	r6,		r6,		1
	movia	r11,	0
	add		r11,	r11,	r4
	br		LOOP

OUTPUT1:
	movia	r15,	0b1111111111
	br		END_FUNC
	
OUTPUT2:
	beq		r7,		r5,		OUTPUT1 #neu r7 = 2 thi la snt
	movia	r15,	0b0000000000 #neu khong thi ko phai la snt	
	br		END_FUNC

END_FUNC:
	stw		r15,	0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r11,	8(sp)
	ldw		r6,		12(sp)
	addi	sp,		sp,		16
	ret

.end