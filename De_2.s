#De 2
#Với N là số 4-bit nhập từ SW[3:0], viết chương trình assembly thực hiện N!
#Kết quả xuất ra RED_LED. Lưu ý: Viết chương trình con
.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.global 	_start

_start: 
	movia 	r10,  	0
	movia 	sp, 	SDRAM_END-3
	movia 	r3, 	SW_BASE
	movia 	r2, 	LEDS_BASE
main_:
	#movi 	r2, 	10 #N
	movi 	r4,  	1 #i
	movi 	r5,  	-1 #dem
	movi 	r6,  	0 #giaithua(kq)
	movi 	r7,  	1 #bien nho
	movi	r1,		1 #so sánh
	ldwio 	r17, 	0(r3)
	andi 	r8, 	r17, 	0b0000001111 #N
	call 	GIAITHUA
	ldw 	r16, 	0(r10)
	stwio	r16,	0(r2)
	br 		main_
GIAITHUA:
	subi 	sp, 	sp, 	16
	stw 	r8, 	0(sp)
	stw 	r4, 	4(sp)
	stw 	r5, 	8(sp)
	stw 	r6, 	12(sp)
LOOP:
	beq		r8,		r1,		SET1 #if(N == 1) -> SET1 (r6 = 1)
	beq		r8,		r0,		SET1 #if(N == 0) -> SET1 (r6 = 1)
	beq 	r4, 	r8, 	END_FUNC #if(i == N) -> END_FUNC
MUL:
	beq 	r4, 	r8, 	END_FUNC #if(i == N) -> END_FUNC
	beq 	r5, 	r4, 	RESET #1*2*3*4 thi r4 tang len va r5 se dem so lan nhan
	add 	r6, 	r6, 	r7 #nhan N hien tai cho r5 lan
	addi 	r5, 	r5, 	1 #tang r5
	br 		MUL
RESET:
	addi 	r4, 	r4, 	1 #tang i 
	sub 	r5, 	r5, 	r5 #reset r5 de nhan
	add 	r7, 	r0, 	r6 #lay gia tri N luc vua nhan de nhan tiep
	br 		MUL
SET1:
	sub		r6,		r6,		r6
	addi 	r6,		r6,		1
	br 		END_FUNC
END_FUNC:
	stw 	r6, 	0(r10)
	ldw 	r8, 	0(sp)
	ldw 	r4, 	4(sp)
	ldw 	r5, 	8(sp)
	ldw 	r6, 	12(sp)
	addi 	sp, 	sp, 	16
	ret
.end