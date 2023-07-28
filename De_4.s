#Với N là số 4-bit được nhập từ Slider Switch ở vị trí SW[3:0] và M là số
#2-bit được nhập từ SW[5:4]. Viết chương trình assembly tính r16 = N^M và
#xuất kết quả ra RED_LED.
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
	movia	r6,		1 #dem so lan mu
	movia	r7,		1 #dem so lan nhan
	movia 	r8,		0 #temp
	movia	r9,		0 #temp
	movia	r1,		1
	ldwio 	r17,	0(r3)
	andi	r4,		r17,	0b0000001111 #So doi mu
	ldwio	r18,	0(r3)
	andi	r5,		r18,	0b0000110000 #Mu 
	srli	r5,		r5,		4
	add		r8,		r0,		r4
	call	POW
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
POW:
	subi 	sp,		sp, 	16
	stw		r4,		0(sp)
	stw		r5,		4(sp)
	stw		r6,		8(sp)
	stw		r7,		12(sp)
LOOP:
	beq		r5,		r0,		ZERO
	beq		r5,		r1,		END_FUNC
	beq		r6,		r5,		END_FUNC #lap lai N lan mu
	sub		r7,		r7,		r7 #reset r7 de so sanh voi r8 la so nhan
	addi	r7,		r7,		1
	sub		r9,		r9,		r9
	add		r9,		r0,		r4 #add r9 de cong don cho phep tinh nhan
	br 		DO
ZERO:
	mov		r4,		r1
	br		END_FUNC
DO:
	beq		r7,		r8,		PLUS #N = N * N
	add 	r4,		r4,		r9 #N = N+N+N+...
	addi 	r7,		r7,		1
	br 		DO
PLUS:
	addi	r6,		r6,		1
	br 		LOOP
END_FUNC:
	stw		r4,		0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	ldw		r6,		8(sp)
	ldw		r7,		12(sp)
	addi 	sp,		sp, 	16
	ret
.end

#############################################
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
START:
	ldwio	r17,	0(r3)
	andi	r4,		r17,	0b0000001111
	ldwio	r18,	0(r3)
	andi	r5,		r18,	0b0000110000
	srli	r5,		r5,		4
	movia	r6,		1#i
	movia	r7,		1#dem nhan
	movia	r8,		0#ketqua
	movia	r11,	0
	add		r11,	r11,	r4
	movia	r9,		0
	add		r9,		r9,		r4
	call	SUM
	ldw		r16,	0(r10)
	stwio	r16,	0(r2)
	br		START
SUM:
	subi	sp,		sp,		16
	stw		r4,		0(sp)
	stw		r7,		4(sp)
	stw		r9,		8(sp)
	stw		r6,		12(sp)
LOOP:
	beq		r5,		r0,		SET1
	beq		r5,		r1,		END_FUNC
	beq		r6,		r5,		END_FUNC
	br		MUL
MUL:
	beq		r7,		r11,	RESET
	add		r4,		r4,		r9
	addi	r7,		r7,		1
	br		MUL
RESET:
	sub		r7,		r7,		r7
	sub		r9,		r9,		r9
	add		r9,		r0,		r4
	addi	r6,		r6,		1
	addi	r7,		r7,		1
	br		LOOP
SET1:
	movia	r4,		1
	br		END_FUNC
END_FUNC:
	stw		r4,		0(r10)
	ldw		r4,		0(sp)
	ldw		r7,		4(sp)
	ldw		r9,		8(sp)
	ldw		r6,		12(sp)
	addi	sp,		sp,		16
	ret
.end