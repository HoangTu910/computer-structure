#Với N là số 4-bit nhập từ SW[3:0], M là số 4-bit được nhập từ SW[7:4].
#Viết chương trình assembly cho hệ thống để tính r16 là ước chung lớn nhất.
#(UCLN) của N và M, và xuất kết quả ra RED_LED.

.text
.equ		LEDS_BASE,		0xFF200000		
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.global 	_start

_start:
	movia	r10,	0
	movia 	sp,		SDRAM_END - 3
	movia 	r3,		SW_BASE
	movia 	r2,		LEDS_BASE
_main:
	ldwio 	r17,	0(r3)
	andi 	r4,		r17,	0b0000001111 #so A
	ldwio 	r18,	0(r3)
	andi	r5,		r18,	0b0011110000 #so B
	srli	r5,		r5,		4
	call	UCLN
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
UCLN:
	subi 	sp, 	sp,		12
	stw		r4,		0(sp)
	stw		r5,		4(sp)

LOOP:
	beq		r4,		r5,		END_FUNC #if(A == B) -> END_FUNC
	beq 	r4,		r0,		SUM #if(A == 0) A = A + B
	beq		r5,		r0,		SUM #if(B == 0) A = A + B
	bgt		r4,		r5,		ASUBB #if(A > B) A = A - B
	bgt		r5,		r4,		BSUBA #if(B < A) B = B - A
SUM:
	add		r4,		r4,		r5
	br		END_FUNC
ASUBB:
	sub		r4,		r4,		r5
	br 		LOOP
BSUBA:
	sub		r5,		r5,		r4
	br 		LOOP
END_FUNC:
	stw		r4,		0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	addi	sp,		sp,		12
	ret
.end