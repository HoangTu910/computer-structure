#Số A là số 4-bit được nhập từ SW[3:0], B là số 4-bit được nhập từ SW[7:4].
#Tiến hành chương trình assembly kiểm tra xem có bao nhiêu số chia cho 3 dư 1 trong hai số A và B. 
#Kết quả xuất ra RED_LED. Lưu ý: Viết chương trình con thực hiện kiểm tra có bao nhiêu
.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF2
.global 	_start
_start:
	movia	r10,	0
	movia	sp,		SDRAM_END - 3
	movia	r3,		SW_BASE
	movia	r2,		LEDS_BASE
_main:
	movia 	r6,		3 #So 3
	movia 	r7,		1 #So 1
	movia	r8,		0 #Dem
	ldwio 	r17,	0(r3)
	andi	r4,		r17,	0b0000001111 #So A
	ldwio	r18,	0(r3)
	andi	r5,		r18,	0b0011110000 #So B 
	srli	r5,		r5,		4
	call	CHECK
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
CHECK:
	subi	sp,		sp,		12
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r8,		8(sp)
LOOP:
	bgt		r4,		r0,		SUBA
	bgt		r5,		r0,		SUBB
	br 		END_FUNC

SUBA:
	sub		r4,		r4,		r6 #r4 - 3
	beq		r4,		r7,		COUNT
	br 		LOOP
SUBB:
	sub		r5,		r5,		r6
	beq		r5,		r7,		COUNT
	br 		LOOP
	
COUNT:
	addi	r8,		r8,		1
	br 		LOOP
	
END_FUNC:
	stw		r8,		0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r8,		8(sp)
	addi	sp,		sp,		12
	ret

.end


##################
.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.global 	_start

_start:
	movia	r2,		LEDS_BASE
	movia	r3,		SW_BASE
	movia	sp,		SDRAM_END-3
	movia	r10,	0
START:
	ldwio	r17,	0(r3)
	andi	r5,		r17,	0b0000001111
	ldwio	r18,	0(r3)
	andi	r6,		r18,	0b0011110000
	srli	r6,		r6,		4
	movia	r7,		3
	movia	r8,		0
	movia	r11,	1
	call	DIV
	ldw		r16,	0(r10)
	stwio	r16,	0(r2)
	br		START

DIV:
	subi	sp,		sp,		12
	stw		r5,		0(sp)
	stw		r6,		4(sp)
	
CHECK1:
	beq		r5,		r11,		COUNT1
	bgt		r0,		r5,		CHECK2
	sub		r5,		r5,		r7
	br		CHECK1

CHECK2:
	beq		r6,		r11,		COUNT2
	bgt		r0,		r6,		END_FUNC
	sub		r6,		r6,		r7
	br		CHECK2
	
COUNT1:
	addi	r8,		r8,		1
	br		CHECK2

COUNT2:
	addi	r8,		r8,		1
	br		END_FUNC

END_FUNC:
	stw		r8,		0(r10)
	ldw		r5,		0(sp)
	ldw		r6,		4(sp)#Luu y chi load 2 thanh nay khong load thanh dem
	addi	sp,		sp,		12
	ret
.end

	