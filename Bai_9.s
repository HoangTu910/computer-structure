#Với số N 10-bit được nhập từ SW[9:0].
#Tiến hành viết chương trình assembly đếm số lần xuất hiện của dãy bit 0b1101.
#Kết quả xuất ra RED_LED.
#Lưu ý: Viết chương trình con thực hiện đếm số lần xuất hiện của dãy bit 0b1101. 
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
	andi	r4,		r17,	0b1111111111 #So A
	movia	r5,		0b1101000000
	movia	r6,		0 #Dem so lan xuat hien
	call	CHECK
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
CHECK:
	subi	sp,		sp,		12
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r6,		8(sp)
	
LOOP:
	beq		r4,		r0,		END_FUNC
	andi	r7,		r4,		0b1111000000
	beq		r7,		r5,		COUNT
	slli	r4,		r4,		1
	#addi	r11,	r11,	1
	br 		LOOP
COUNT:
	addi	r6,		r6,		1
	slli	r4,		r4,		1
	br 		LOOP

END_FUNC:
	stw		r6,		0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r6,		8(sp)
	addi	sp,		sp,		12
	ret

.end