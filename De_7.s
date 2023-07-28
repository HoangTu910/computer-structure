#Với 2 số a và b đều 4-bit được đọc từ Slider Switch, trong đó a = SW[3:0]
#và b = SW[7:4]. Viết chương trình assembly để thực hiện tính biểu thứ r16 = a^2 + 3b + 25.
#Xuất kết quả r16 ra RED_LED.
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
	movia	r6,		1 #Loop mu 2
	movia	r7,		0 #Bien dem mu 2
	movia	r8,		0 #nhớ r5 để nhân 3
	movia	r9,		1 #biến đếm để nhân
	movia	r11,	0 #kết quả cuối
	movia	r12,	0 #nhớ r4 để nhân để ko làm đổi kết quả r4
	ldwio 	r17,	0(r3)
	andi	r4,		r17,	0b0000001111 #A
	ldwio	r18,	0(r3)
	andi	r5,		r18,	0b0011110000 #B 
	srli	r5,		r5,		4
	add		r12,	r12,	r4
	call	CALC
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		_main
	
CALC:
	subi	sp,		sp,		12
	stw		r4,		0(sp)
	stw		r5,		4(sp)

POW2:
	beq		r4,		r0,		ZERO
	beq		r7,		r6,		MUL3
	sub		r14,	r14,	r14
	add		r14,	r14,	r4
	sub		r9,		r9,		r9
	addi	r9,		r9,		1
	br		DOPOW

ZERO:
	movi	r4,		0
	br 		MUL3
	
ADD1:
	addi	r7,		r7,		1
	br 		POW2
	
DOPOW:
	beq		r9,		r12,	ADD1
	add		r4,		r4,		r14
	addi	r9,		r9,		1
	br 		DOPOW
	
MUL3:
	add		r8,		r0,		r5
	add		r5,		r5,		r5
	add		r5,		r5,		r8
	br		LOOP
	
LOOP:
	add   	r11,	r4,		r5
	addi	r11,	r11,	25
	br		END_FUNC

END_FUNC:
	stw		r11,	0(r10)
	ldw		r4,		0(sp)
	ldw		r5,		4(sp)
	addi	sp,		sp,		12
	ret
.end



###CACH2
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
	andi	r5,		r17,	0b0000001111#a
	ldwio	r18,	0(r3)
	andi	r6,		r17,	0b0011110000#b
	srli	r6,		r6,		4
	add		r7,		r0,		r5
	movia	r8,		1
	add		r9,		r0,		r5
	call	MPROCE
	ldw		r16,	0(r10)
	stwio	r16,	0(r2)
	br		START
	
MPROCE:
	subi	sp,		sp,		12
	stw		r5,		0(sp)
	stw		r7,		4(sp)
	stw		r8,		8(sp)
POW:
	beq		r5,		r0,		MUL3
	beq		r8,		r7,		MUL3
	add		r5,		r5,		r7
	addi	r8,		r8,		1
	br		POW
MUL3:
	add		r11,	r0,		r6
	add		r6,		r6,		r6
	add		r6,		r6,		r11
	br		PLUS
PLUS:
	add		r12,	r6,		r5
	addi	r12,	r12,	25
	br		END_FUNC

END_FUNC:
	stw		r12,	0(r10)
	ldw		r5,		0(sp)
	ldw		r7,		4(sp)
	ldw		r8,		8(sp)
	addi	sp,		sp,		12
	ret
.end