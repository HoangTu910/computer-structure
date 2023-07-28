#N là số 8-bit nhập từ SW[9:2]. Viết chương trình assembly cho hệ thống để kiểm tra giá trị của N.
#Nếu N chia hết cho 0x11 và 0x18 < N < 0x40. Nếu thỏa 1 trong 2 điều kiện thì RED_LED[3:0] sáng,
#nếu thỏa hết các điều kiện thì RED_LED[7:4] sáng , nếu không thỏa 2 điều thì RED_LED[9:0] tắt.
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
	andi	r4,		r17,	0b1111111100 #So A
	srli	r4,		r4,		2
	movia	r1,		1 #Check dieu kien
	movia	r12,	2 #Check dieu kien
	movia	r6,		0x11 #N chia het
	movia	r7,		0x18 #Min
	movia	r8,		0x40 #Max
	movia	r9,		0 #Dem dieu kien
	movia	r11,	0
	add		r11,	r11,	r4 #Luu r4 de dung cho CHECK2
	call	CHIAHET
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
CHIAHET:
	subi	sp,		sp,		12
	stw		r4,		0(sp)
	stw		r6,		4(sp)
	stw		r9,		8(sp)
	
CHECK1:
	beq		r4,		r0,		COUNT1
	bgt		r0,		r4,		CHECK2
	sub		r4,		r4,		r6
	br 		CHECK1

COUNT1:
	addi	r9,		r9,		1
	br 		CHECK2

CHECK2:
	bgt		r11,	r7,		CHECK3
	br		SUMUP

CHECK3:
	bgt		r8,		r11,	COUNT2
	br		SUMUP

COUNT2:
	addi	r9,		r9,		1
	br		SUMUP

SUMUP:
	beq		r9,		r0,		OFF
	beq		r9,		r1,		ON1
	beq		r9,		r12,	ON2

OFF:
	movia	r15,	0
	br		END_FUNC
ON1:
	movia	r15,	15
	br		END_FUNC
ON2:
	movia 	r15,	240
	br		END_FUNC

END_FUNC:
	stw		r15,	0(r10)
	ldw		r4,		0(sp)
	ldw		r6,		4(sp)
	ldw		r9,		8(sp)
	addi	sp,		sp,		12
	ret

.end