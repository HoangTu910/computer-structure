#Viết chương trình assembly dịch chuỗi bit đang hiển thị trên RED_LED sang trái nếu KEY[1] được bấm, dịch sang phải nếu KEY[2] được bấm 
#và nếu KEY[3] được bấm thì đọc số từ Slider switch ghi ra RED_LED. Lưu ý: Viết chương trình con thực hiện chức năng kiểm tra nút nhấn nào
#được nhấn trong 3 nút KEY[1], KEY[2], KEY[3].

.text
.equ		LEDS_BASE,		0xFF200000	
.equ		SW_BASE,		0xFF200040
.equ		SDRAM_END,		0x03FFFFFF
.equ 		KEY, 			0xFF200050
.global 	_start

_start:
	movia	r10,	0
	movia	sp,		SDRAM_END - 3
	movia	r3,		SW_BASE
	movia	r2,		LEDS_BASE
	movia	r6,		KEY
	
_main:
	movi	r7,		0x2
	movi	r8,		0x4
	movi	r9,		0x8
	call	READ
	br		_main
	
READ:
	subi	sp,		sp,		4
	stw		r14,	0(sp)
	
CHECK_KEY:
	ldhio	r12,	0(r6)
	beq		r12,	zero,	CHECK_KEY
	
WAIT:
	ldhio 	r11,	0(r6)
	bne		r11,	zero,	WAIT
	andi	r12,	r12,	0x000E
	
KEY_DECODE:
	and		r14,	r12,	r9
	beq		r14,	r9,		LOAD
	and		r14,	r12,	r8	
	beq		r14,	r8,		SR
	and		r14,	r12,	r7
	beq		r14,	r7,		SL
	
LOAD:
	ldwio	r11,	0(r3)
	stwio	r11,	0(r2)
	br		END_FUNC

SR:
	ldwio	r11,	0(r2)
	srli	r11,	r11,	1
	stwio	r11,	0(r2)
	br		END_FUNC
	
SL:
	ldwio	r11,	0(r2)
	slli	r11,	r11,	1
	stwio	r11,	0(r2)
	br		END_FUNC
	
END_FUNC:
	ldw		r14,	0(sp)
	addi	sp,		sp,		4
	ret
.end
	