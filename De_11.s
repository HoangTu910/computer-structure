#Với N là số 8-bit được nhập từ Slider Switch ở vị trí SW[9:2].
#Viết chương trình assembly thực hiện kiểm tra xem N có chia hết cho 0x14 và lớn hơn 0x41 không.
#Nếu thỏa 2 điều kiện thì RED_LED[9:0] sáng, nếu thỏa 1 trong 2 điều kiện thì RED_LED[3:0] sáng, 
#nếu không thỏa 2 điều kiện RED_LED[9:0] tắt
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
	ldwio	r17,	0(r3)
	andi 	r4,		r17,	0b1111111100
	srli	r4,		r4,		2
	movia	r5,		0x14 #So chia
	movia 	r6,		0x41 #So so sanh
	movia	r7,		0 #Dem dieu kien
	movia	r1,		1
	movia	r8,		2 #Check dieu kien
	movia	r9,		0
	call	CHECK_DIV
	ldw		r16,	0(r10)
	stwio	r16,	0(r2)
	br		_main
	
CHECK_DIV:
	subi	sp,		sp,		12
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	movia	r11,	0
	add		r11,	r11,	r4 #Chua tam r4
	br 		LOOP
	
COUNT:
	addi	r7,		r7,		1
	br		CHECK_NUM

COUNT2:
	addi	r7,		r7,		1
	br		STATE
	
LOOP:
	bgt		r0,		r11,	CHECK_NUM
	beq		r11,	r0,		COUNT
	sub		r11,	r11,	r5
	br 		LOOP
	
CHECK_NUM:
	bgt		r4,		r6,		COUNT2
	br		STATE
	
OFF:
	movia	r9,		0
	br		END_FUNC

ON1:
	movia	r9,		0b0000000111
	br		END_FUNC
ON2:
	movia	r9,		0b1111111111
	br 		END_FUNC
	
STATE:
	beq		r7,		r0,		OFF
	beq		r7,		r1,		ON1
	beq		r7,		r8,		ON2
	
END_FUNC:
	stw		r9,		0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	addi	sp,		sp,		12
	ret

.end
	