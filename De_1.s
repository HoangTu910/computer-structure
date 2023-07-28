#Bai 1		
#Với N là số 4-bit nhập từ SW[5:2], viết chương trình assembly cho hệ
#thống để tính r16 = 1 + 3 + 5 + … + (2*N + 1)
#Kết quả xuất ra RED_LED.
#Viết chương trình con để thực hiện việc tính tổng r16 = 1 + 3 + 5+ … + (2*N + 1).

.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.global 	_start

_start:
	movia	r2,		LEDS_BASE
	movia 	r3, 	SW_BASE
	movia 	sp, 	SDRAM_END-3
	movia 	r10, 	N
START:
	ldwio	r17,	0(r3)
	andi 	r5, 	r17, 	0b111100	#And Switch 5:2
	srli 	r5,		r5,		0x2			#Shift right 2 bit
	movi	r7,		0
	movi	r8,		0 #ket qua
	movi	r9,		0 #bien dem
	call 	SUM
	ldw 	r16, 	0(r10)
	stwio 	r16, 	0(r2)
	br 		START
SUM:
	subi 	sp, 	sp,		20
	stw 	r5, 	0(sp)	
	stw 	r6, 	4(sp)	#Bien tam
	stw		r7,		8(sp)	
	stw		r8,		12(sp)
	stw		r9,		16(sp)
LOOP:
	bgt 	r9, 	r5,		END_FUNC #if(i > N) -> END_FUNC
	add		r7,		r7,		r7	#2N
	add		r7,		r7,		r6	#3N
	addi 	r7,		r7,		1	#3N + 1
	add		r8,		r8,		r7  #luu ket qua vo r8
	addi	r9,		r9,		1	#Tang i
	sub		r7,		r7,		r7	#reset r7
	add		r7,		r7,		r9  #Tang n len 1
	sub		r6,		r6,		r6	#reset r6
	add		r6,		r6,		r7	#add n da tang vo r6 de cong
	br 		LOOP
	
END_FUNC:
	stw 	r8, 	0(r10)
	ldw 	r5, 	0(sp)
	ldw 	r6, 	4(sp)
	ldw		r7,		8(sp)	
	ldw		r8,		12(sp)
	ldw 	r9,		16(sp)
	sub 	r6,		r6,		r6
	addi 	sp, 	sp, 	20
	ret
.data 
N: 	.word 	0
.end