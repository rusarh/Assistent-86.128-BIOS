; +-------------------------------------------------------------------------+
; |   ASSISTENT 86/128 BASIC I/O SYSTEM                                     |
; |   decompilation:  Ruslan Staritsyn, 2022                                |
; +-------------------------------------------------------------------------+
;
; Input	MD5   :	1370007B1E86C502F4D4B0A98DB23B8B
; Input	CRC32 :	8426CBF5

; File Name   :	ASSTFE00.BIN
; Format      :	Binary file
; Base Address:	F000h Range: FE000h - 100000h Loaded length: 2000h

		Ideal
		p8086n
		model flat

; ===========================================================================

; Segment type:	Pure code
segment		F000 byte public 'CODE'
		assume cs:F000
		;org 0E000h
		assume es:nothing, ss:nothing, ds:nothing
VIDEO_PARM1	db  38h	;
			db  28h	; 
			db  2Bh	; 
			db  0Ah
			db  26h	;
			db    0
			db  19h
			db  1Fh
			db    2
			db    7
			db    6
			db    7
			db    0
			db    0
			db    0
			db    0
C1		dw offset C11		; ...
C2		dw offset C24

; =============== S U B	R O U T	I N E =======================================


proc		STGTST near		; ...
		mov	cx, 4000h

STGTST_CNT:				; ...
		cld			; Clear	Direction Flag
		mov	bx, cx
		mov	ax, 0FFFFh
		mov	dx, 0AA55h
		sub	di, di		; Integer Subtraction
		rep stosb		; Store	String

C3:					; ...
		dec	di		; Decrement by 1
		std			; Set Direction	Flag

C4:					; ...
		mov	si, di
		mov	cx, bx

C5:					; ...
		lodsb			; Load String
		xor	al, ah		; Logical Exclusive OR
		jnz	short C7	; Jump if Not Zero (ZF=0)
		cmp	ah, 0		; Compare Two Operands
		jz	short C6	; Jump if Zero (ZF=1)
		mov	al, dl
		stosb			; Store	String

C6:					; ...
		loop	C5		; Loop while CX	!= 0
		cmp	ah, 0		; Compare Two Operands
		jz	short C7	; Jump if Zero (ZF=1)
		mov	ah, al
		xchg	dh, dl		; Exchange Register/Memory with	Register
		cld			; Clear	Direction Flag
		inc	di		; Increment by 1
		jz	short C4	; Jump if Zero (ZF=1)
		dec	di		; Decrement by 1
		mov	dx, 1
		jmp	short C3	; Jump
; ---------------------------------------------------------------------------

C7:					; ...
		retn			; Return Near from Procedure
endp		STGTST

; ---------------------------------------------------------------------------

RESET:					; ...
		cli			; Clear	Interrupt Flag
		mov	ah, 0D5h
		sahf			; Store	AH into	Flags Register
		jnb	short ERR01	; Jump if Not Below (CF=0)
		jnz	short ERR01	; Jump if Not Zero (ZF=0)
		jnp	short ERR01	; Jump if Not Parity (PF=0)
		jns	short ERR01	; Jump if Not Sign (SF=0)
		lahf			; Load Flags into AH Register
		mov	cl, 5
		shr	ah, cl		; Shift	Logical	Right
		jnb	short ERR01	; Jump if Not Below (CF=0)
		mov	al, 40h
		shl	al, 1		; Shift	Logical	Left
		jno	short ERR01	; Jump if Not Overflow (OF=0)
		xor	ah, ah		; Logical Exclusive OR
		sahf			; Store	AH into	Flags Register
		jb	short ERR01	; Jump if Below	(CF=1)
		jz	short ERR01	; Jump if Zero (ZF=1)
		js	short ERR01	; Jump if Sign (SF=1)
		jp	short ERR01	; Jump if Parity (PF=1)
		lahf			; Load Flags into AH Register
		mov	cl, 5
		shr	ah, cl		; Shift	Logical	Right
		jb	short ERR01	; Jump if Below	(CF=1)
		shl	ah, 1		; Shift	Logical	Left
		jo	short ERR01	; Jump if Overflow (OF=1)
		mov	ax, 0FFFFh
		stc			; Set Carry Flag

C8:					; ...
		mov	ds, ax
		assume ds:nothing
		mov	bx, ds
		mov	es, bx
		assume es:nothing
		mov	cx, es
		mov	ss, cx
		assume ss:nothing
		mov	dx, ss
		mov	sp, dx
		mov	bp, sp
		mov	si, bp
		mov	di, si
		jnb	short C9	; Jump if Not Below (CF=0)
		xor	ax, di		; Logical Exclusive OR
		jnz	short ERR01	; Jump if Not Zero (ZF=0)
		clc			; Clear	Carry Flag
		jnb	short C8	; Jump if Not Below (CF=0)

C9:					; ...
		or	ax, di		; Logical Inclusive OR
		jz	short C10	; Jump if Zero (ZF=1)

ERR01:					; ...
		hlt			; Halt
; ---------------------------------------------------------------------------

C10:					; ...
		mov	al, 0
		out	0A0h, al	; PIC 2	 same as 0020 for PIC 1
		out	83h, al		; DMA page register 74LS612:
					; Channel 1 (address bits 16-23)
		mov	al, 99h
		out	63h, al		; PC/XT	PPI Command/Mode Register.
					; Selects which	PPI ports are input or output.
					; BIOS sets to 99H (Ports A and	C are input, B is output).
		mov	al, 0FCh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		sub	al, al		; Integer Subtraction
		mov	dx, 3D8h
		out	dx, al
		mov	ax, cs
		mov	ss, ax
		assume ss:nothing
		mov	bx, 0E000h
		cld			; Clear	Direction Flag
		mov	sp, offset C1
		jmp	ROS_CHECKSUM	; Jump
; ---------------------------------------------------------------------------
C11		db  90h	; �		; ...
		db  90h	; �
; ---------------------------------------------------------------------------
		mov	al, 4
		out	8, al		; DMA 8237A-5. cmd reg bits:
					; 0: enable mem-to-mem DMA
					; 1: enable Ch0	address	hold
					; 2: disable controller
					; 3: compressed	timing mode
					; 4: enable rotating priority
					; 5: extended write mode; 0=late write
					; 6: DRQ sensing - active high
					; 7: DACK sensing - active high
		mov	al, 54h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		sub	cx, cx		; Integer Subtraction
		mov	bl, cl
		mov	al, cl
		out	41h, al		; Timer	8253-5 (AT: 8254.2).

C12:
		mov	al, 40h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		cmp	bl, 0FFh	; Compare Two Operands
		jmp	short C15	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

C15:					; ...
		mov	al, 54h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	al, 0Fh
		out	41h, al		; Timer	8253-5 (AT: 8254.2).
		out	0Dh, al		; DMA controller, 8237A-5.
					; master clear.
					; Any OUT clears the ctrlr (must be re-initialized)
		mov	al, 0
		out	8, al		; DMA 8237A-5. cmd reg bits:
					; 0: enable mem-to-mem DMA
					; 1: enable Ch0	address	hold
					; 2: disable controller
					; 3: compressed	timing mode
					; 4: enable rotating priority
					; 5: extended write mode; 0=late write
					; 6: DRQ sensing - active high
					; 7: DACK sensing - active high
		mov	al, 42h
		out	0Bh, al		; DMA 8237A-5. mode register bits:
					; 0-1: channel (00=0; 01=1; 10=2; 11=3)
					; 2-3: transfer	type (00=verify=Nop; 01=write; 10=read)
					; 4: 1=enable auto-initialization
					; 5: 1=address increment; 0=address decrement
					; 6-7: 00=demand mode; 01=single; 10=block; 11=cascade
		mov	ax, cs
		mov	ds, ax
		assume ds:nothing
		mov	bx, offset VIDEO_PARM1
		mov	cx, 10h
		mov	dx, 3D4h
		xor	ah, ah		; Logical Exclusive OR

loc_FE101:				; ...
		mov	al, ah
		out	dx, al		; Video: CRT cntrlr addr
					; horizontal total
		inc	dx		; Increment by 1
		inc	ah		; Increment by 1
		mov	al, [bx]
		out	dx, al		; Video: CRT controller	internal registers
		inc	bx		; Increment by 1
		dec	dx		; Decrement by 1
		loop	loc_FE101	; Loop while CX	!= 0
		mov	dx, 3D8h
		mov	al, 20h
		out	dx, al
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	bx, [ds:72h]
		sub	ax, ax		; Integer Subtraction
		mov	es, ax
		assume es:nothing
		mov	ds, ax
		assume ds:nothing
		sub	di, di		; Integer Subtraction
		in	al, 60h		; 8042 keyboard	controller data	register
		and	al, 0Ch		; Logical AND
		add	al, 4		; Add
		mov	cl, 0Ch
		shl	ax, cl		; Shift	Logical	Left
		mov	cx, ax
		mov	ah, al
		cld			; Clear	Direction Flag

loc_FE134:				; ...
		stosb			; Store	String
		loop	loc_FE134	; Loop while CX	!= 0
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 0Fh		; Logical AND
		jz	short C21	; Jump if Zero (ZF=1)
		mov	dx, 1000h
		mov	ah, al
		mov	al, 0

loc_FE144:				; ...
		mov	es, dx
		assume es:nothing
		mov	cx, 8000h
		sub	di, di		; Integer Subtraction
		rep stosb		; Store	String
		add	dx, 800h	; Add
		dec	ah		; Decrement by 1
		jnz	short loc_FE144	; Jump if Not Zero (ZF=0)

C21:					; ...
		mov	al, 13h
		out	20h, al		; Interrupt controller,	8259A.
		mov	al, 8
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, 9
		out	21h, al		; Interrupt controller,	8259A.
		sub	ax, ax		; Integer Subtraction
		mov	es, ax
		assume es:nothing
		mov	si, 40h
		mov	ds, si
		assume ds:nothing
		mov	[ds:72h], bx
		cmp	[word ptr ds:72h], 1234h ; Compare Two Operands
		jz	short C25	; Jump if Zero (ZF=1)
		mov	ds, ax
		assume ds:nothing
		cli			; Clear	Interrupt Flag
		mov	sp, 0E012h
		jmp	STGTST		; Jump
; ---------------------------------------------------------------------------

C24:					; ...
		jz	short C25	; Jump if Zero (ZF=1)
		jmp	ERR01		; Jump
; ---------------------------------------------------------------------------

C25:					; ...
		mov	ax, 30h
		mov	ss, ax
		assume ss:nothing
		mov	sp, 100h
		mov	[word ptr es:8], offset	HALT
		mov	[word ptr es:0Ah], 0F000h
		jmp	short TST6	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

ROS_CHECKSUM:				; ...
		mov	cx, 8192
		xor	al, al		; Logical Exclusive OR

C26:					; ...
		add	al, [cs:bx]	; Add
		inc	bx		; Increment by 1
		loop	C26		; Loop while CX	!= 0
		or	al, al		; Logical Inclusive OR
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

TST6:					; ...
		mov	[word ptr es:14h], offset PRINT_SCREEN ;
					;
					; ;---------------------------------------------
					; ; TEST.06
					; ;   8259 INTERRUPT CONTROLLER	TEST
					; ;DESCRIPTION
					; ;   READ/WRITE THE INTERRUPT MASK REGISTER (IMR) WITH	ALL ONES AND ZEROES
					; ;   ENABLE SYSTEM INTERRUPTS.	 MASK DEVICE INTERRUPTS	OFF. CHECK FOR
					; ;   HOT INTERRUPTS (UNEXPECTED).
					; ;--------------------------------------------
		mov	[word ptr es:16h], 0F000h
		cli			; Clear	Interrupt Flag
		mov	al, 0
		out	21h, al		; Interrupt controller,	8259A.
		in	al, 21h		; Interrupt controller,	8259A.
		or	al, al		; Logical Inclusive OR
		jnz	short D6	; Jump if Not Zero (ZF=0)
		mov	al, 0FFh
		out	21h, al		; Interrupt controller,	8259A.
		in	al, 21h		; Interrupt controller,	8259A.
		add	al, 1		; Add
		jnz	short D6	; Jump if Not Zero (ZF=0)
		cld			; Clear	Direction Flag
		mov	cx, 8
		mov	di, 20h

D3:					; ...
		mov	ax, offset D11
		stosw			; Store	String
		mov	ax, cs
		stosw			; Store	String
		add	bx, 4		; Add
		loop	D3		; Loop while CX	!= 0
		xor	ah, ah		; Logical Exclusive OR
		sti			; Set Interrupt	Flag
		sub	cx, cx		; Integer Subtraction

D4:					; ...
		loop	D4		; Loop while CX	!= 0

D5:					; ...
		loop	D5		; Loop while CX	!= 0
		or	ah, ah		; Logical Inclusive OR
		jz	short D7	; Jump if Zero (ZF=1)

D6:					; ...
		mov	dx, 101h
		call	ERR_BEEP	; Call Procedure
		cli			; Clear	Interrupt Flag
		hlt			; Halt
; ---------------------------------------------------------------------------

D7:					; ...
		mov	ah, 0		; ;--------------------------------------------
					; ;TEST.7
					; ;   8253 TIMER CHECKOUT
					; ;DESCRIPTION
					; ;   VERIFY THAT THE SYSTEM TIMER (0) DOESN'T COUNT TOO FAST NOR TOO
					; ;   SLOW.
					; ;--------------------------------------------
		xor	ch, ch		; Logical Exclusive OR
		mov	al, 0FEh
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, 10h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	cl, 16h
		mov	al, cl
		out	40h, al		; Timer	8253-5 (AT: 8254.2).

D8:					; ...
		test	ah, 0FFh	; Logical Compare
		jnz	short D9	; Jump if Not Zero (ZF=0)
		loop	D8		; Loop while CX	!= 0
		jmp	short D6	; Jump
; ---------------------------------------------------------------------------

D9:					; ...
		mov	cl, 12h
		mov	al, 0FFh
		out	40h, al		; Timer	8253-5 (AT: 8254.2).
		mov	ah, 0
		mov	al, 0FEh
		out	21h, al		; Interrupt controller,	8259A.

D10:					; ...
		test	ah, 0FFh	; Logical Compare
		jnz	short D6	; Jump if Not Zero (ZF=0)
		loop	D10		; Loop while CX	!= 0
		jmp	short TST8	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		D11 near		; ...
		mov	ah, 1		; ;--------------------------------------------
					; ;   TEMPORARY	INTERRUPT SERVICE ROUTINE
					; ;--------------------------------------------
		push	ax
		mov	al, 0FFh
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		pop	ax
		iret			; Interrupt Return
endp		D11

; ---------------------------------------------------------------------------

HALT:					; ...
		cli			; Clear	Interrupt Flag
		hlt			; Halt
; ---------------------------------------------------------------------------
A201		db ' 201'               ; ...
; ---------------------------------------------------------------------------

TST8:					; ...
		cld			; Clear	Direction Flag
		mov	di, 40h
		push	cs
		pop	ds
		assume ds:nothing
		mov	si, offset VECTOR_TABLE32
		mov	cx, 20h
		rep movsw		; Move Byte(s) from String to String
		mov	al, 0FFh	; ;   SETUP TIMER 0 TO MODE 3
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, 36h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	al, 0
		out	40h, al		; Timer	8253-5 (AT: 8254.2).
		out	40h, al		; Timer	8253-5 (AT: 8254.2).
		mov	ax, 40h		; ;   SETUP TIMER 0 TO BLINK LED IF MANUFACTURING TEST MODE
		mov	ds, ax
		assume ds:nothing
		in	al, 60h		; 8042 keyboard	controller data	register
		mov	ah, 0
		test	al, 80h		; Logical Compare
		jnz	short loc_FE264	; Jump if Not Zero (ZF=0)
		mov	ah, 20h

loc_FE264:				; ...
		and	al, 7Fh		; Logical AND
		mov	[ds:10h], ax
		mov	ah, 0
		and	al, 30h		; Logical AND
		jnz	short E7	; Jump if Not Zero (ZF=0)
		jmp	E19		; Jump
; ---------------------------------------------------------------------------

E7:					; ...
		xchg	ah, al		; Exchange Register/Memory with	Register
		cmp	ah, 30h		; Compare Two Operands
		jz	short E8	; Jump if Zero (ZF=1)
		inc	al		; Increment by 1
		cmp	ah, 20h		; Compare Two Operands
		jnz	short E8	; Jump if Not Zero (ZF=0)
		mov	al, 3

E8:					; ...
		push	ax
		sub	ah, ah		; Integer Subtraction
		int	10h		; - VIDEO - SET	VIDEO MODE
					; AL = mode
		pop	ax
		push	ax
		mov	al, 1
		mov	bx, 0B800h
		mov	dx, 3D8h
		mov	cx, 4000h
		dec	al		; Decrement by 1

E9:
		out	dx, al
		mov	es, bx
		assume es:nothing
		mov	ax, 40h
		mov	ds, ax
		cmp	[word ptr ds:72h], 1234h ; Compare Two Operands
		jz	short E10	; Jump if Zero (ZF=1)
		mov	ds, bx
		assume ds:nothing
		call	STGTST_CNT	; Call Procedure
		jz	short E10	; Jump if Zero (ZF=1)
		mov	dx, 102h
		call	ERR_BEEP	; Call Procedure

E10:					; ...
		pop	ax
		push	ax
		mov	ah, 0
		int	10h		; - VIDEO - SET	VIDEO MODE
					; AL = mode
		mov	ax, 7020h
		sub	di, di		; Integer Subtraction
		mov	cx, 28h
		cld			; Clear	Direction Flag
		rep stosw		; Store	String
		pop	ax		; ;--------------------------------------------
					; ;TEST.10
					; ;   CRT INTERFACE LINES TEST
					; ;DESCRIPTION
					; ;   SENSE ON/OFF TRANSITION OF THE VIDEO ENABLE AND HORIZONTAL
					; ;   SYNC LINES.
					; ;--------------------------------------------
		push	ax
		mov	dx, 3DAh

E11:
		mov	ah, 8

E12:					; ...
		sub	cx, cx		; Integer Subtraction

E13:					; ...
		in	al, dx		; Video	status bits:
					; 0: retrace.  1=display is in vert or horiz retrace.
					; 1: 1=light pen is triggered; 0=armed
					; 2: 1=light pen switch	is open; 0=closed
					; 3: 1=vertical	sync pulse is occurring.
		and	al, ah		; Logical AND
		jnz	short E14	; Jump if Not Zero (ZF=0)
		loop	E13		; Loop while CX	!= 0
		jmp	short E17	; Jump
; ---------------------------------------------------------------------------

E14:					; ...
		sub	cx, cx		; Integer Subtraction

E15:					; ...
		in	al, dx		; Video	status bits:
					; 0: retrace.  1=display is in vert or horiz retrace.
					; 1: 1=light pen is triggered; 0=armed
					; 2: 1=light pen switch	is open; 0=closed
					; 3: 1=vertical	sync pulse is occurring.
		and	al, ah		; Logical AND
		jz	short E16	; Jump if Zero (ZF=1)
		loop	E15		; Loop while CX	!= 0
		jmp	short E17	; Jump
; ---------------------------------------------------------------------------

E16:					; ...
		mov	cl, 3
		shr	ah, cl		; Shift	Logical	Right
		jnz	short E12	; Jump if Not Zero (ZF=0)
		jmp	short E18	; Jump
; ---------------------------------------------------------------------------

E17:					; ...
		mov	dx, 102h
		call	ERR_BEEP	; Call Procedure

E18:					; ...
		pop	ax
		mov	ah, 0
		int	10h		; - VIDEO - SET	VIDEO MODE
					; AL = mode

E19:					; ...
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	ah, [ds:10h]
		and	ah, 0Ch		; Logical AND
		mov	al, 4
		mul	ah		; Unsigned Multiplication of AL	or AX
		add	al, 10h		; Add
		mov	dx, ax
		mov	bx, ax
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 0Fh		; Logical AND
		mov	ah, 10h
		mul	ah		; Unsigned Multiplication of AL	or AX
		mov	[ds:15h], ax
		cmp	bx, 40h		; Compare Two Operands
		jz	short E20	; Jump if Zero (ZF=1)
		sub	ax, ax		; Integer Subtraction

E20:					; ...
		add	ax, bx		; Add
		mov	[ds:13h], ax
		cmp	[word ptr ds:72h], 1234h ; Compare Two Operands
		jz	short E22	; Jump if Zero (ZF=1)
		mov	bx, 400h
		mov	cx, 10h

E21:					; ...
		cmp	dx, cx		; Compare Two Operands
		jbe	short E23	; Jump if Below	or Equal (CF=1 | ZF=1)
		mov	ds, bx
		assume ds:nothing
		mov	es, bx
		assume es:nothing
		add	cx, 10h		; Add
		add	bx, 400h	; Add
		push	cx
		push	bx
		push	dx
		call	STGTST		; Call Procedure
		pop	dx
		pop	bx
		pop	cx
		jz	short E21	; Jump if Zero (ZF=1)
		mov	dx, ds
		mov	ch, al
		mov	al, dh
		mov	cl, 4
		shr	al, cl		; Shift	Logical	Right
		call	XLAT_PRINT_CODE	; Call Procedure
		mov	al, dh
		and	al, 0Fh		; Logical AND
		call	XLAT_PRINT_CODE	; Call Procedure
		mov	al, 20h
		call	print_char	; Call Procedure
		mov	al, ch
		mov	cl, 4
		shr	al, cl		; Shift	Logical	Right
		call	XLAT_PRINT_CODE	; Call Procedure
		mov	al, ch
		and	al, 0Fh		; Logical AND
		call	XLAT_PRINT_CODE	; Call Procedure
		mov	si, offset A201	; " 201"
		mov	cx, 4
		call	P_MSG		; Call Procedure

E22:					; ...
		jmp	short TST12	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

E23:					; ...
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	dx, [ds:15h]
		or	dx, dx		; Logical Inclusive OR
		jz	short E22	; Jump if Zero (ZF=1)
		mov	cx, 0
		cmp	bx, 1000h	; Compare Two Operands
		ja	short E22	; Jump if Above	(CF=0 &	ZF=0)
		mov	bx, 1000h
		jmp	short E21	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		XLAT_PRINT_CODE	near	; ...
		add	al, 90h		; Add
		daa			; Decimal Adjust AL after Addition
		adc	al, 40h		; Add with Carry
		daa			; Decimal Adjust AL after Addition
endp		XLAT_PRINT_CODE	; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


proc		print_char near		; ...
		mov	ah, 0Eh
		mov	bh, 0
		int	10h		; - VIDEO - WRITE CHARACTER AND	ADVANCE	CURSOR (TTY WRITE)
					; AL = character, BH = display page (alpha modes)
					; BL = foreground color	(graphics modes)
		retn			; Return Near from Procedure
endp		print_char

; ---------------------------------------------------------------------------
F1		db  33h	; 3		; ...
		db  30h	; 0
		db  31h	; 1
F2		db  31h	; 1		; ...
		db  33h	; 3
		db  31h	; 1
F3		db  36h	; 6		; ...
		db  30h	; 0
		db  31h	; 1
F4		dw 03BCh
		dw 378h
		dw 278h
; ---------------------------------------------------------------------------

TST12:					; ...
		mov	ax, 40h
		mov	ds, ax
		call	KBD_RESET	; Call Procedure
		jcxz	short loc_FE3EA	; Jump if CX is	0
		mov	al, 4Dh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		cmp	bl, 0AAh	; Compare Two Operands
		jnz	short loc_FE3EA	; Jump if Not Zero (ZF=0)
		mov	al, 0CCh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	al, 4Ch
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		sub	cx, cx		; Integer Subtraction

loc_FE3D2:				; ...
		loop	loc_FE3D2	; Loop while CX	!= 0
		in	al, 60h		; 8042 keyboard	controller data	register
		cmp	al, 0		; Compare Two Operands
		jz	short loc_FE3F3	; Jump if Zero (ZF=1)
		mov	ch, al
		mov	cl, 4
		shr	al, cl		; Shift	Logical	Right
		call	XLAT_PRINT_CODE	; Call Procedure
		mov	al, ch
		and	al, 0Fh		; Logical AND
		call	XLAT_PRINT_CODE	; Call Procedure

loc_FE3EA:				; ...
		mov	si, offset F1
		mov	cx, 3
		call	P_MSG		; Call Procedure

loc_FE3F3:				; ...
		sub	ax, ax		; Integer Subtraction
		mov	es, ax
		assume es:nothing
		mov	cx, 30h
		push	cs
		pop	ds
		assume ds:nothing
		mov	si, 0FEF3h
		mov	di, 20h
		cld			; Clear	Direction Flag
		rep movsw		; Move Byte(s) from String to String
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	al, 4Dh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	al, 0FFh
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, 0B6h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	ax, 4D3h
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		mov	al, ah
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 10h		; Logical AND
		mov	[ds:6Bh], al
		call	READ_HALF_BIT	; Call Procedure
		call	READ_HALF_BIT	; Call Procedure
		jcxz	short loc_FE43A	; Jump if CX is	0
		cmp	bx, 540h	; Compare Two Operands
		jnb	short loc_FE43A	; Jump if Not Below (CF=0)
		cmp	bx, 410h	; Compare Two Operands
		jnb	short F9	; Jump if Not Below (CF=0)

loc_FE43A:				; ...
		mov	si, offset F2
		mov	cx, 3
		call	P_MSG		; Call Procedure

F9:					; ...
		mov	al, 0FCh
		out	21h, al		; Interrupt controller,	8259A.
		mov	al, [ds:10h]
		test	al, 1		; Logical Compare
		jnz	short F10	; Jump if Not Zero (ZF=0)
		jmp	short F15	; Jump
; ---------------------------------------------------------------------------

F10:					; ...
		mov	al, 0BCh
		out	21h, al		; Interrupt controller,	8259A.
		mov	ah, 0
		int	13h		; DISK - RESET DISK SYSTEM
					; DL = drive (if bit 7 is set both hard	disks and floppy disks reset)
		test	ah, 0FFh	; Logical Compare
		jnz	short F13	; Jump if Not Zero (ZF=0)
		mov	dx, 3F2h
		mov	al, 1Ch
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		sub	cx, cx		; Integer Subtraction

F11:					; ...
		loop	F11		; Loop while CX	!= 0

F12:					; ...
		loop	F12		; Loop while CX	!= 0
		xor	dx, dx		; Logical Exclusive OR
		mov	ch, 1
		mov	[ds:3Eh], dl
		call	near ptr 5300h	; Call Procedure
		jb	short F13	; Jump if Below	(CF=1)
		mov	ch, 22h
		call	near ptr 5300h	; Call Procedure
		jnb	short F14	; Jump if Not Below (CF=0)

F13:					; ...
		mov	si, offset F3
		mov	cx, 3
		call	P_MSG		; Call Procedure

F14:					; ...
		mov	al, 0Ch
		mov	dx, 3F2h
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;

F15:					; ...
		mov	si, 1Eh
		mov	[ds:1Ah], si
		mov	[ds:1Ch], si
		mov	[ds:80h], si
		add	si, 20h		; Add
		mov	[ds:82h], si
		mov	bp, 0E3AFh
		mov	si, 0

F16:					; ...
		mov	dx, [cs:bp+0]
		mov	al, 0AAh
		out	dx, al
		sub	al, al		; Integer Subtraction
		in	al, dx
		cmp	al, 0AAh	; Compare Two Operands
		jnz	short F17	; Jump if Not Zero (ZF=0)
		mov	[si+8],	dx
		inc	si		; Increment by 1
		inc	si		; Increment by 1

F17:					; ...
		inc	bp		; Increment by 1
		inc	bp		; Increment by 1
		cmp	bp, offset TST12 ; Compare Two Operands
		jnz	short F16	; Jump if Not Zero (ZF=0)
		mov	bx, 0
		mov	dx, 3FAh
		in	al, dx		; COM: interrupt identification	register bits:
					; 0: 1=no interrupt pending
					; 1: 00=receiver line status interrupt.	 Occurs	upon:
					;	overrun, parity, or framing error, or break
					;    01=received data available
					;    10=transmitter buffer empty
					;    11=modem status.
		test	al, 0F8h	; Logical Compare
		jnz	short loc_FE4D7	; Jump if Not Zero (ZF=0)
		mov	[word ptr bx+0], 3F8h
		inc	bx		; Increment by 1
		inc	bx		; Increment by 1

loc_FE4D7:				; ...
		mov	dx, 2FAh
		in	al, dx		; COM: interrupt identification	register bits:
					; 0: 1=no interrupt pending
					; 1: 00=receiver line status interrupt.	 Occurs	upon:
					;	overrun, parity, or framing error, or break
					;    01=received data available
					;    10=transmitter buffer empty
					;    11=modem status.
		test	al, 0F8h	; Logical Compare
		jnz	short loc_FE4E7	; Jump if Not Zero (ZF=0)
		mov	[word ptr bx+0], 2F8h
		inc	bx		; Increment by 1
		inc	bx		; Increment by 1

loc_FE4E7:				; ...
		mov	ax, si
		mov	cl, 3
		ror	al, cl		; Rotate Right
		or	al, bl		; Logical Inclusive OR
		or	[ds:11h], al	; Logical Inclusive OR
		mov	dx, 201h
		in	al, dx		; Game I/O port
					; bits 0-3: Coordinates	(resistive, time-dependent inputs)
					; bits 4-7: Buttons/Triggers (digital inputs)
		nop			; No Operation
		nop			; No Operation
		test	al, 0Fh		; Logical Compare
		jnz	short loc_FE502	; Jump if Not Zero (ZF=0)
		or	[byte ptr ds:11h], 10h ; Logical Inclusive OR

loc_FE502:				; ...
		mov	al, 80h
		out	0A0h, al	; PIC 2	 same as 0020 for PIC 1
		int	19h		; DISK BOOT
					; causes reboot	of disk	system

; =============== S U B	R O U T	I N E =======================================


proc		ERR_BEEP near		; ...
		pushf			; Push Flags Register onto the Stack
		cli			; Clear	Interrupt Flag
		push	ds
		mov	ax, 40h
		mov	ds, ax
		or	dh, dh		; Logical Inclusive OR
		jz	short G3	; Jump if Zero (ZF=1)

G1:					; ...
		mov	bl, 6
		call	BEEP		; Call Procedure

G2:					; ...
		loop	G2		; Loop while CX	!= 0
		dec	dh		; Decrement by 1
		jnz	short G1	; Jump if Not Zero (ZF=0)
		cmp	[byte ptr ds:12h], 1 ; Compare Two Operands
		jnz	short G3	; Jump if Not Zero (ZF=0)
		mov	al, 0CDh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		jmp	short G1	; Jump
; ---------------------------------------------------------------------------

G3:					; ...
		mov	bl, 1
		call	BEEP		; Call Procedure

G4:					; ...
		loop	G4		; Loop while CX	!= 0
		dec	dl		; Decrement by 1
		jnz	short G3	; Jump if Not Zero (ZF=0)

G5:					; ...
		loop	G5		; Loop while CX	!= 0

G6:					; ...
		loop	G6		; Loop while CX	!= 0
		pop	ds
		assume ds:nothing
		popf			; Pop Stack into Flags Register
		retn			; Return Near from Procedure
endp		ERR_BEEP


; =============== S U B	R O U T	I N E =======================================


proc		BEEP near		; ...
		mov	al, 0B6h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	ax, 533h
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		mov	al, ah
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	ah, al
		or	al, 3		; Logical Inclusive OR
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		sub	cx, cx		; Integer Subtraction

G7:					; ...
		loop	G7		; Loop while CX	!= 0
		dec	bl		; Decrement by 1
		jnz	short G7	; Jump if Not Zero (ZF=0)
		mov	al, ah
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		retn			; Return Near from Procedure
endp		BEEP


; =============== S U B	R O U T	I N E =======================================


proc		KBD_RESET near		; ...
		mov	al, 0Ch
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	cx, 2956h

loc_FE567:				; ...
		loop	loc_FE567	; Loop while CX	!= 0
		mov	al, 0CCh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	al, 4Ch
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	al, 0FDh
		out	21h, al		; Interrupt controller,	8259A.
		sti			; Set Interrupt	Flag
		mov	ah, 0
		sub	cx, cx		; Integer Subtraction

loc_FE57A:				; ...
		test	ah, 0FFh	; Logical Compare
		jnz	short loc_FE581	; Jump if Not Zero (ZF=0)
		loop	loc_FE57A	; Loop while CX	!= 0

loc_FE581:				; ...
		in	al, 60h		; 8042 keyboard	controller data	register
		mov	bl, al
		mov	al, 0CCh
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		retn			; Return Near from Procedure
endp		KBD_RESET


; =============== S U B	R O U T	I N E =======================================


proc		P_MSG near		; ...
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		cmp	[byte ptr ds:12h], 1 ; Compare Two Operands
		jnz	short G12	; Jump if Not Zero (ZF=0)
		mov	dh, 1
		jmp	ERR_BEEP	; Jump
; ---------------------------------------------------------------------------

G12:					; ...
		mov	al, [cs:si]
		inc	si		; Increment by 1
		mov	bh, 0
		mov	ah, 0Eh
		int	10h		; - VIDEO - WRITE CHARACTER AND	ADVANCE	CURSOR (TTY WRITE)
					; AL = character, BH = display page (alpha modes)
					; BL = foreground color	(graphics modes)
		loop	G12		; Loop while CX	!= 0
		mov	ax, 0E0Dh
		int	10h		; - VIDEO - WRITE CHARACTER AND	ADVANCE	CURSOR (TTY WRITE)
					; AL = character, BH = display page (alpha modes)
					; BL = foreground color	(graphics modes)
		mov	ax, 0E0Ah
		int	10h		; - VIDEO - WRITE CHARACTER AND	ADVANCE	CURSOR (TTY WRITE)
					; AL = character, BH = display page (alpha modes)
					; BL = foreground color	(graphics modes)
		retn			; Return Near from Procedure
endp		P_MSG


; =============== S U B	R O U T	I N E =======================================

; Attributes: noreturn

proc		BOOT_STRAP near		; ...
		call	far ptr	0F490h:0 ;  ASSISTENT LOGO PROC
		sti			; Set Interrupt	Flag
		call	SET_DATASEG	; Call Procedure
		mov	ax, [ds:10h]
		test	al, 1		; Logical Compare
		jz	short H3	; Jump if Zero (ZF=1)
		mov	cx, 4

H1:					; ...
		push	cx
		mov	ah, 0
		int	13h		; DISK - RESET DISK SYSTEM
					; DL = drive (if bit 7 is set both hard	disks and floppy disks reset)
		jb	short H2	; Jump if Below	(CF=1)
		mov	ah, 2
		mov	bx, 0
		mov	es, bx
		mov	bx, 7C00h
		mov	dx, 0
		mov	cx, 1
		mov	al, 1
		int	13h		; DISK - READ SECTORS INTO MEMORY
					; AL = number of sectors to read, CH = track, CL = sector
					; DH = head, DL	= drive, ES:BX -> buffer to fill
					; Return: CF set on error, AH =	status,	AL = number of sectors read

H2:					; ...
		pop	cx
		jnb	short loc_FE5E7	; Jump if Not Below (CF=0)
		loop	H1		; Loop while CX	!= 0

H3:					; ...
		int	18h		; TRANSFER TO ROM BASIC
					; causes transfer to ROM-based BASIC (IBM-PC)
					; often	reboots	a compatible; often has	no effect at all

loc_FE5E7:				; ...
		jmp	far ptr	0:7C00h	; Jump
endp		BOOT_STRAP

; ---------------------------------------------------------------------------
A1		dw 1047			; ...
					; ; 110	BAUD  ;	TABLE OF INIT VALUE
		dw 768
		dw 384
		dw 192
		dw 96
		dw 48
		dw 24
		dw 12

; =============== S U B	R O U T	I N E =======================================


proc		RS232_IO far		; ...
		sti			; Set Interrupt	Flag
		push	ds
		push	dx
		push	si
		push	di
		push	cx
		push	bx
		mov	si, dx
		mov	di, dx
		shl	si, 1		; Shift	Logical	Left
		call	SET_DATASEG	; Call Procedure
		mov	dx, [si+0]
		or	dx, dx		; Logical Inclusive OR
		jz	short A3	; Jump if Zero (ZF=1)
		or	ah, ah		; Logical Inclusive OR
		jz	short A4	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short A5	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short loc_FE68C	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jnz	short A3	; Jump if Not Zero (ZF=0)
		jmp	loc_FE6AE	; Jump
; ---------------------------------------------------------------------------

A3:					; ...
		pop	bx
		pop	cx
		pop	di
		pop	si
		pop	dx
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

A4:					; ...
		mov	ah, al
		add	dx, 3		; Add
		mov	al, 80h
		out	dx, al
		mov	dl, ah
		mov	cl, 4
		rol	dl, cl		; Rotate Left
		and	dx, 0Eh		; Logical AND
		mov	di, offset A1
		add	di, dx		; Add
		mov	dx, [si+0]
		inc	dx		; Increment by 1
		mov	al, [cs:di+1]
		out	dx, al
		dec	dx		; Decrement by 1
		mov	al, [cs:di]
		out	dx, al
		add	dx, 3		; Add
		mov	al, ah
		and	al, 1Fh		; Logical AND
		out	dx, al
		dec	dx		; Decrement by 1
		dec	dx		; Decrement by 1
		mov	al, 0
		out	dx, al
		jmp	short loc_FE6AE	; Jump
; ---------------------------------------------------------------------------

A5:					; ...
		push	ax
		add	dx, 4		; Add
		mov	al, 3
		out	dx, al
		inc	dx		; Increment by 1
		inc	dx		; Increment by 1
		mov	bh, 30h
		call	RS232_DATA	; Call Procedure
		jz	short loc_FE67B	; Jump if Zero (ZF=1)

loc_FE673:				; ...
		pop	cx
		mov	al, cl

loc_FE676:				; ...
		or	ah, 80h		; Logical Inclusive OR
		jmp	short A3	; Jump
; ---------------------------------------------------------------------------

loc_FE67B:				; ...
		dec	dx		; Decrement by 1
		mov	bh, 20h
		call	RS232_DATA	; Call Procedure
		jnz	short loc_FE673	; Jump if Not Zero (ZF=0)
		sub	dx, 5		; Integer Subtraction
		pop	cx
		mov	al, cl
		out	dx, al
		jmp	short A3	; Jump
; ---------------------------------------------------------------------------

loc_FE68C:				; ...
		add	dx, 4		; Add
		mov	al, 1
		out	dx, al
		inc	dx		; Increment by 1
		inc	dx		; Increment by 1
		mov	bh, 20h
		call	RS232_DATA	; Call Procedure
		jnz	short loc_FE676	; Jump if Not Zero (ZF=0)
		dec	dx		; Decrement by 1
		mov	bh, 1
		call	RS232_DATA	; Call Procedure
		jnz	short loc_FE676	; Jump if Not Zero (ZF=0)
		and	ah, 1Eh		; Logical AND
		mov	dx, [si+0]
		in	al, dx
		jmp	A3		; Jump
; ---------------------------------------------------------------------------

loc_FE6AE:				; ...
		mov	dx, [si+0]
		add	dx, 5		; Add
		in	al, dx
		mov	ah, al
		inc	dx		; Increment by 1
		in	al, dx
		jmp	A3		; Jump
endp		RS232_IO


; =============== S U B	R O U T	I N E =======================================


proc		RS232_DATA near		; ...
		mov	bl, [di+7Ch]

loc_FE6C1:				; ...
		sub	cx, cx		; Integer Subtraction

loc_FE6C3:				; ...
		in	al, dx
		mov	ah, al
		and	al, bh		; Logical AND
		cmp	al, bh		; Compare Two Operands
		jz	short locret_FE6D4 ; Jump if Zero (ZF=1)
		loop	loc_FE6C3	; Loop while CX	!= 0
		dec	bl		; Decrement by 1
		jnz	short loc_FE6C1	; Jump if Not Zero (ZF=0)
		or	bh, bh		; Logical Inclusive OR

locret_FE6D4:				; ...
		retn			; Return Near from Procedure
endp		RS232_DATA


; =============== S U B	R O U T	I N E =======================================


proc		KEYBOARD_IO far		; ...
		sti			; Set Interrupt	Flag
		push	ds
		push	bx
		call	SET_DATASEG	; Call Procedure
		or	ah, ah		; Logical Inclusive OR
		jz	short K1	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short K2	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short K3	; Jump if Zero (ZF=1)
		jmp	short loc_FE717	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

K1:					; ...
		sti			; Set Interrupt	Flag
		nop			; No Operation
		cli			; Clear	Interrupt Flag
		mov	bx, [ds:1Ah]
		cmp	bx, [ds:1Ch]	; Compare Two Operands
		jz	short K1	; Jump if Zero (ZF=1)
		mov	ax, [bx]
		call	K4		; Call Procedure
		mov	[ds:1Ah], bx
		jmp	short loc_FE717	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

K2:					; ...
		cli			; Clear	Interrupt Flag
		mov	bx, [ds:1Ah]
		cmp	bx, [ds:1Ch]	; Compare Two Operands
		mov	ax, [bx]
		sti			; Set Interrupt	Flag
		pop	bx
		pop	ds
		retf	2		; Return Far from Procedure
; ---------------------------------------------------------------------------

K3:					; ...
		mov	al, [ds:17h]

loc_FE717:				; ...
		pop	bx
		pop	ds
		iret			; Interrupt Return
endp		KEYBOARD_IO


; =============== S U B	R O U T	I N E =======================================


proc		K4 near			; ...
		add	bx, 2		; Add
		cmp	bx, [ds:82h]	; Compare Two Operands
		jnz	short K5	; Jump if Not Zero (ZF=0)
		mov	bx, [ds:80h]

K5:					; ...
		retn			; Return Near from Procedure
endp		K4

; ---------------------------------------------------------------------------
K6		db  52h	; R		; ...
K6_1		db  3Ah	; :		; ...
		db  45h	; E
		db  46h	; F
		db  38h	; 8
		db  1Dh
		db  2Ah	; *
		db  36h	; 6
K7		db  80h	; �
		db  40h	; @
		db  20h
		db  10h
		db    8
		db    4
		db    2
		db    1
K8		db 27			; ...
					; ;------ SCAN CODE TABLES
		db 0FFh
		db    0
		db 0FFh
		db 0FFh
		db 0FFh
		db  1Eh
		db 0FFh
		db 0FFh
		db 0FFh
		db 0FFh
		db  1Fh
		db 0FFh
		db  7Fh	; 
		db 0FFh
		db  11h
		db  17h
		db    5
		db  12h
		db  14h
		db  19h
		db  15h
		db    9
		db  0Fh
		db  10h
		db  1Bh
		db 1Dh
		db 0Ah
		db 0FFh
		db    1
		db  13h
		db    4
		db    6
		db    7
		db    8
		db  0Ah
		db  0Bh
		db  0Ch
		db 0FFh
		db 0FFh
		db 0FFh
		db 0FFh
		db  1Ch
		db  1Ah
		db  18h
		db    3
		db  16h
		db    2
		db  0Eh
		db  0Dh
		db 0FFh
		db 0FFh
		db 0FFh
		db 0FFh
		db 0FFh
		db 0FFh
		db  20h
		db 0FFh
K9		db 0FFh			; ...
		db 0FFh
		db  77h	; w
		db 0FFh
		db  84h	; �
		db 0FFh
		db  73h	; s
		db 0FFh
		db  74h	; t
		db 0FFh
		db  75h	; u
		db 0FFh
		db  76h	; v
		db 0FFh
		db 0FFh
		db  49h	; I
		db  48h	; H
		db  47h	; G
		db  4Dh	; M
		db  4Ch	; L
		db  4Bh	; K
		db  51h	; Q
		db  50h	; P
		db  4Fh	; O
		db  52h	; R
K10		db  1Bh			; ...
		db  31h	; 1
		db  32h	; 2
		db  33h	; 3
		db  34h	; 4
		db  35h	; 5
		db  36h	; 6
		db  37h	; 7
		db  38h	; 8
		db  39h	; 9
		db  30h	; 0
		db  2Dh	; -
		db  3Dh	; =
		db    8
		db    9
		db  71h	; q
		db  77h	; w
		db  65h	; e
		db  72h	; r
		db  74h	; t
		db  79h	; y
		db  75h	; u
		db  69h	; i
		db  6Fh	; o
		db  70h	; p
		db  5Bh	; [
		db  5Dh	; ]
		db  0Dh
		db 0FFh
		db  61h	; a
		db  73h	; s
		db  64h	; d
		db  66h	; f
		db  67h	; g
		db  68h	; h
		db  6Ah	; j
		db  6Bh	; k
		db  6Ch	; l
		db  3Bh	; ;
		db  27h	; '
		db  60h	; `
		db 0FFh
		db  5Ch	; \
		db  7Ah	; z
		db  78h	; x
		db  63h	; c
		db  76h	; v
		db  62h	; b
		db  6Eh	; n
		db  6Dh	; m
		db  2Ch	; ,
		db  2Eh	; .
		db  2Fh	; /
		db 0FFh
		db  2Ah	; *
		db 0FFh
		db  20h
		db 0FFh
K10_RUS		db  1Bh			; ...
		db  31h	; 1
		db  32h	; 2
		db  33h	; 3
		db  34h	; 4
		db  35h	; 5
		db  36h	; 6
		db  37h	; 7
		db  38h	; 8
		db  39h	; 9
		db  30h	; 0
		db  2Dh	; -
		db  3Dh	; =
		db    8
		db    9
		db 0EFh	; �
		db 0D2h	; �
		db 0D5h	; �
		db 0E0h	; �
		db 0E2h	; �
		db 0EBh	; �
		db 0E3h	; �
		db 0D8h	; �
		db 0DEh	; �
		db 0DFh	; �
		db  5Bh	; [
		db  5Dh	; ]
		db  0Dh
		db 0FFh
		db 0D0h	; �
		db 0E1h	; �
		db 0D4h	; �
		db 0E4h	; �
		db 0D3h	; �
		db 0E5h	; �
		db 0D9h	; �
		db 0DAh	; �
		db 0DBh	; �
		db  3Bh	; ;
		db  27h	; '
		db  60h	; `
		db 0FFh
		db  5Ch	; \
		db 0D7h	; �
		db 0ECh	; �
		db 0E6h	; �
		db 0D6h	; �
		db 0D1h	; �
		db 0DDh	; �
		db 0DCh	; �
		db  2Ch	; ,
		db  2Eh	; .
		db  2Fh	; /
		db 0FFh
		db  2Ah	; *
		db 0FFh
		db  20h
		db 0FFh
K11		db  1Bh			; ...
					; ;------ UC TABLE
		db  21h	; !
		db  40h	; @
		db  23h	; #
		db  24h	; $
		db  25h	; %
		db  5Eh	; ^
		db  26h	; &
		db  2Ah	; *
		db  28h	; (
		db  29h	; )
		db  5Fh	; _
		db  2Bh	; +
		db    8
		db    0
		db  51h	; Q
		db  57h	; W
		db  45h	; E
		db  52h	; R
		db  54h	; T
		db  59h	; Y
		db  55h	; U
		db  49h	; I
		db  4Fh	; O
		db  50h	; P
		db  7Bh	; {
		db  7Dh	; }
		db  0Dh
		db 0FFh
		db  41h	; A
		db  53h	; S
		db  44h	; D
		db  46h	; F
		db  47h	; G
		db  48h	; H
		db  4Ah	; J
		db  4Bh	; K
		db  4Ch	; L
		db  3Ah	; :
		db  22h	; "
		db  7Eh	; ~
		db 0FFh
		db  7Ch	; |
		db  5Ah	; Z
		db  58h	; X
		db  43h	; C
		db  56h	; V
		db  42h	; B
		db  4Eh	; N
		db  4Dh	; M
		db  3Ch	; <
		db  3Eh	; >
		db  3Fh	; ?
		db 0FFh
		db    0
		db 0FFh
		db  20h
		db 0FFh
K11_RUS		db  1Bh			; ...
					; RUS TABLE
		db  21h	; !
		db  40h	; @
		db  23h	; #
		db  24h	; $
		db  25h	; %
		db  5Eh	; ^
		db  26h	; &
		db  2Ah	; *
		db  28h	; (
		db  29h	; )
		db  5Fh	; _
		db  2Bh	; +
		db    8
		db    0
		db 0CFh	; �
		db 0B2h	; �
		db 0B5h	; �
		db 0C0h	; �
		db 0C2h	; �
		db 0CBh	; �
		db 0C3h	; �
		db 0B8h	; �
		db 0BEh	; �
		db 0BFh	; �
		db  7Bh	; {
		db  7Dh	; }
		db  0Dh
		db 0FFh
		db 0B0h	; �
		db 0C1h	; �
		db 0B4h	; �
		db 0C4h	; �
		db 0B3h	; �
		db 0C5h	; �
		db 0B9h	; �
		db 0BAh	; �
		db 0BBh	; �
		db  3Ah	; :
		db  22h	; "
		db  7Eh	; ~
		db 0FFh
		db  7Ch	; |
		db 0B7h	; �
		db 0CCh	; �
		db 0C6h	; �
		db 0B6h	; �
		db 0B1h	; �
		db 0BDh	; �
		db 0BCh	; �
		db  3Ch	; <
		db  3Eh	; >
		db  3Fh	; ?
		db 0FFh
		db    0
		db 0FFh
		db  20h
		db 0FFh
K12		db 0E8h	; �		; ...
		db 0E9h	; �
		db 0EAh	; �
		db 0EDh	; �
		db 0E7h	; �
		db 0EEh	; �
		db 0FFh
		db 0F1h	; �
K13		db 0C8h	; �		; ...
		db 0C9h	; �
		db 0CAh	; �
		db 0CDh	; �
		db 0C7h	; �
		db 0CEh	; �
		db 0FFh
		db 0F0h	; �
K14		db  37h	; 7		; ...
		db  38h	; 8
		db  39h	; 9
		db  2Dh	; -
		db  34h	; 4
		db  35h	; 5
		db  36h	; 6
		db  2Bh	; +
		db  31h	; 1
		db  32h	; 2
		db  33h	; 3
		db  30h	; 0
		db  2Eh	; .
; ---------------------------------------------------------------------------

KB_INT:					; ...
		sti			; Set Interrupt	Flag
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		push	ds
		push	es
		cld			; Clear	Direction Flag
		call	SET_DATASEG	; Call Procedure
		in	al, 60h		; 8042 keyboard	controller data	register
		push	ax
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	ah, al
		or	al, 80h		; Logical Inclusive OR
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		xchg	ah, al		; Exchange Register/Memory with	Register
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		pop	ax
		mov	ah, al
		cmp	al, 0FFh	; Compare Two Operands
		jnz	short K16	; Jump if Not Zero (ZF=0)
		jmp	K62		; Jump
; ---------------------------------------------------------------------------

K16:					; ...
		mov	si, 17h
		and	al, 7Fh		; Logical AND
		cmp	al, 5Ah		; Compare Two Operands
		jz	short loc_FE8D0	; Jump if Zero (ZF=1)
		push	cs
		pop	es
		assume es:nothing
		mov	di, offset K6
		mov	cx, 8
		repne scasb		; Compare String
		mov	al, ah
		jz	short loc_FE8EB	; Jump if Zero (ZF=1)
		jmp	loc_FE96D	; Jump
; ---------------------------------------------------------------------------

loc_FE8D0:				; ...
		test	ah, 80h		; Logical Compare
		jz	short loc_FE8DB	; Jump if Zero (ZF=1)
		and	[byte ptr si+1], 0FDh ;	Logical	AND
		jmp	short loc_FE8FF	; Jump
; ---------------------------------------------------------------------------

loc_FE8DB:				; ...
		test	[byte ptr si+1], 2 ; Logical Compare
		jnz	short loc_FE8FF	; Jump if Not Zero (ZF=0)
		or	[byte ptr si+1], 2 ; Logical Inclusive OR
		xor	[byte ptr si+1], 1 ; Logical Exclusive OR
		jmp	short loc_FE8FF	; Jump
; ---------------------------------------------------------------------------

loc_FE8EB:				; ...
		sub	di, offset K6_1	; Integer Subtraction
		mov	ah, [cs:di-18D0h]
		test	al, 80h		; Logical Compare
		jnz	short loc_FE94E	; Jump if Not Zero (ZF=0)
		cmp	ah, 10h		; Compare Two Operands
		jnb	short loc_FE901	; Jump if Not Below (CF=0)
		or	[si], ah	; Logical Inclusive OR

loc_FE8FF:				; ...
		jmp	short loc_FE97B	; Jump
; ---------------------------------------------------------------------------

loc_FE901:				; ...
		test	[byte ptr si], 0Ch ; Logical Compare
		jz	short loc_FE91E	; Jump if Zero (ZF=1)
		test	ah, 60h		; Logical Compare
		jnz	short loc_FE937	; Jump if Not Zero (ZF=0)
		cmp	ah, 80h		; Compare Two Operands
		jz	short loc_FE917	; Jump if Zero (ZF=1)
		test	[byte ptr si], 4 ; Logical Compare
		jz	short loc_FE8FF	; Jump if Zero (ZF=1)
		jmp	short loc_FE96D	; Jump
; ---------------------------------------------------------------------------

loc_FE917:				; ...
		test	[byte ptr si], 8 ; Logical Compare
		jz	short loc_FE8FF	; Jump if Zero (ZF=1)
		jmp	short loc_FE96D	; Jump
; ---------------------------------------------------------------------------

loc_FE91E:				; ...
		cmp	ah, 80h		; Compare Two Operands
		jnz	short loc_FE937	; Jump if Not Zero (ZF=0)
		test	[byte ptr si], 20h ; Logical Compare
		jnz	short loc_FE932	; Jump if Not Zero (ZF=0)
		test	[byte ptr si], 3 ; Logical Compare
		jz	short loc_FE937	; Jump if Zero (ZF=1)

loc_FE92D:				; ...
		mov	ax, 5230h
		jmp	short loc_FE965	; Jump
; ---------------------------------------------------------------------------

loc_FE932:				; ...
		test	[byte ptr si], 3 ; Logical Compare
		jz	short loc_FE92D	; Jump if Zero (ZF=1)

loc_FE937:				; ...
		test	[si+1],	ah	; Logical Compare
		jnz	short loc_FE97B	; Jump if Not Zero (ZF=0)
		xor	[si], ah	; Logical Exclusive OR
		or	[si+1],	ah	; Logical Inclusive OR
		cmp	al, 45h		; Compare Two Operands
		jz	short loc_FE96D	; Jump if Zero (ZF=1)
		cmp	al, 52h		; Compare Two Operands
		jnz	short loc_FE97B	; Jump if Not Zero (ZF=0)
		mov	ax, 5200h
		jmp	short loc_FE965	; Jump
; ---------------------------------------------------------------------------

loc_FE94E:				; ...
		cmp	ah, 10h		; Compare Two Operands
		not	ah		; One's Complement Negation
		jnb	short loc_FE968	; Jump if Not Below (CF=0)
		and	[si], ah	; Logical AND
		cmp	al, 0B8h	; Compare Two Operands
		jnz	short loc_FE97B	; Jump if Not Zero (ZF=0)
		xor	ax, ax		; Logical Exclusive OR
		xchg	al, [ds:19h]	; Exchange Register/Memory with	Register
		cmp	al, 0		; Compare Two Operands
		jz	short loc_FE97B	; Jump if Zero (ZF=1)

loc_FE965:				; ...
		jmp	loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FE968:				; ...
		and	[si+1],	ah	; Logical AND
		jmp	short loc_FE97B	; Jump
; ---------------------------------------------------------------------------

loc_FE96D:				; ...
		cmp	al, 80h		; Compare Two Operands
		jnb	short loc_FE97B	; Jump if Not Below (CF=0)
		test	[byte ptr si+1], 8 ; Logical Compare
		jz	short loc_FE989	; Jump if Zero (ZF=1)
		and	[byte ptr si+1], 0F7h ;	Logical	AND

loc_FE97B:				; ...
		cli			; Clear	Interrupt Flag
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.

loc_FE980:				; ...
		pop	es
		assume es:nothing
		pop	ds
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

loc_FE989:				; ...
		test	[byte ptr si], 8 ; Logical Compare
		jnz	short loc_FE991	; Jump if Not Zero (ZF=0)
		jmp	loc_FEA1E	; Jump
; ---------------------------------------------------------------------------

loc_FE991:				; ...
		test	[byte ptr si], 4 ; Logical Compare
		jz	short loc_FE9BC	; Jump if Zero (ZF=1)
		cmp	al, 53h		; Compare Two Operands
		jnz	short loc_FE9A5	; Jump if Not Zero (ZF=0)
		mov	[word ptr ds:72h], 1234h
		jmp	far ptr	RESET	; Jump
; ---------------------------------------------------------------------------

loc_FE9A5:				; ...
		cmp	al, 2		; Compare Two Operands
		jnz	short loc_FE9BC	; Jump if Not Zero (ZF=0)
		mov	ax, 0
		mov	ds, ax
		mov	si, 54h
		mov	[word ptr si], 4600h
		mov	[word ptr si+2], 0F000h
		jmp	short loc_FE97B	; Jump
; ---------------------------------------------------------------------------

loc_FE9BC:				; ...
		cmp	al, 39h		; Compare Two Operands
		jb	short loc_FE9EB	; Jump if Below	(CF=1)
		ja	short loc_FE9C6	; Jump if Above	(CF=0 &	ZF=0)
		mov	al, 20h
		jmp	short loc_FE965	; Jump
; ---------------------------------------------------------------------------

loc_FE9C6:				; ...
		mov	di, 0E781h
		mov	cx, 0Ah
		repne scasb		; Compare String
		jnz	short loc_FE9DE	; Jump if Not Zero (ZF=0)
		mov	al, [ds:19h]
		mov	ah, 0Ah
		mul	ah		; Unsigned Multiplication of AL	or AX
		add	ax, cx		; Add
		mov	[ds:19h], al

loc_FE9DC:				; ...
		jmp	short loc_FE97B	; Jump
; ---------------------------------------------------------------------------

loc_FE9DE:				; ...
		cmp	al, 3Bh		; Compare Two Operands
		jb	short loc_FE9FB	; Jump if Below	(CF=1)
		cmp	al, 45h		; Compare Two Operands
		jnb	short loc_FE9FB	; Jump if Not Below (CF=0)
		add	ah, 2Dh		; Add
		jmp	short loc_FEA15	; Jump
; ---------------------------------------------------------------------------

loc_FE9EB:				; ...
		cmp	al, 1Eh		; Compare Two Operands
		jb	short loc_FEA02	; Jump if Below	(CF=1)
		cmp	al, 26h		; Compare Two Operands
		jbe	short loc_FEA15	; Jump if Below	or Equal (CF=1 | ZF=1)
		cmp	al, 2Ch		; Compare Two Operands
		jb	short loc_FE9FB	; Jump if Below	(CF=1)
		cmp	al, 32h		; Compare Two Operands
		jbe	short loc_FEA15	; Jump if Below	or Equal (CF=1 | ZF=1)

loc_FE9FB:				; ...
		mov	[byte ptr ds:19h], 0
		jmp	short loc_FE9DC	; Jump
; ---------------------------------------------------------------------------

loc_FEA02:				; ...
		cmp	al, 19h		; Compare Two Operands
		ja	short loc_FE9FB	; Jump if Above	(CF=0 &	ZF=0)
		cmp	al, 10h		; Compare Two Operands
		jnb	short loc_FEA15	; Jump if Not Below (CF=0)
		cmp	al, 0Eh		; Compare Two Operands
		jnb	short loc_FE9FB	; Jump if Not Below (CF=0)
		cmp	al, 2		; Compare Two Operands
		jb	short loc_FE9FB	; Jump if Below	(CF=1)
		add	ah, 76h		; Add

loc_FEA15:				; ...
		mov	[byte ptr ds:19h], 0
		mov	al, 0
		jmp	short loc_FEA69	; Jump
; ---------------------------------------------------------------------------

loc_FEA1E:				; ...
		test	[byte ptr si], 4 ; Logical Compare
		jz	short loc_FEA85	; Jump if Zero (ZF=1)
		cmp	al, 46h		; Compare Two Operands
		jnz	short loc_FEA3F	; Jump if Not Zero (ZF=0)
		mov	bx, [ds:80h]
		mov	[ds:1Ah], bx
		mov	[ds:1Ch], bx
		mov	[byte ptr ds:71h], 80h
		int	1Bh		; CTRL-BREAK KEY
		sub	ax, ax		; Integer Subtraction
		jmp	loc_FEB35	; Jump
; ---------------------------------------------------------------------------

loc_FEA3F:				; ...
		cmp	al, 45h		; Compare Two Operands
		jnz	short loc_FEA62	; Jump if Not Zero (ZF=0)
		or	[byte ptr si+1], 8 ; Logical Inclusive OR
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		cmp	[byte ptr ds:49h], 7 ; Compare Two Operands
		jz	short loc_FEA59	; Jump if Zero (ZF=1)
		mov	dx, 3D8h
		mov	al, [ds:65h]
		out	dx, al

loc_FEA59:				; ...
		test	[byte ptr si+1], 8 ; Logical Compare
		jnz	short loc_FEA59	; Jump if Not Zero (ZF=0)
		jmp	loc_FE980	; Jump
; ---------------------------------------------------------------------------

loc_FEA62:				; ...
		cmp	al, 37h		; Compare Two Operands
		jnz	short loc_FEA6C	; Jump if Not Zero (ZF=0)
		mov	ax, 7200h

loc_FEA69:				; ...
		jmp	loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FEA6C:				; ...
		mov	bx, offset K8
		cmp	al, 3Bh		; Compare Two Operands
		jnb	short loc_FEA76	; Jump if Not Below (CF=0)
		jmp	loc_FEB31	; Jump
; ---------------------------------------------------------------------------

loc_FEA76:				; ...
		cmp	al, 45h		; Compare Two Operands
		jb	short loc_FEA80	; Jump if Below	(CF=1)
		mov	bx, offset K9
		jmp	loc_FEBBB	; Jump
; ---------------------------------------------------------------------------

loc_FEA80:				; ...
		add	ah, 23h		; Add

loc_FEA83:				; ...
		jmp	short loc_FEA15	; Jump
; ---------------------------------------------------------------------------

loc_FEA85:				; ...
		cmp	al, 3Bh		; Compare Two Operands
		jb	short loc_FEA97	; Jump if Below	(CF=1)
		cmp	al, 45h		; Compare Two Operands
		jnb	short loc_FEACB	; Jump if Not Below (CF=0)
		test	[byte ptr si], 3 ; Logical Compare
		jz	short loc_FEA83	; Jump if Zero (ZF=1)
		add	ah, 19h		; Add
		jmp	short loc_FEA83	; Jump
; ---------------------------------------------------------------------------

loc_FEA97:				; ...
		test	[byte ptr si], 3 ; Logical Compare
		jz	short loc_FEAC0	; Jump if Zero (ZF=1)
		cmp	al, 0Fh		; Compare Two Operands
		jnz	short loc_FEAA5	; Jump if Not Zero (ZF=0)
		mov	ax, 0F00h
		jmp	short loc_FEA69	; Jump
; ---------------------------------------------------------------------------

loc_FEAA5:				; ...
		cmp	al, 37h		; Compare Two Operands
		jnz	short loc_FEAB2	; Jump if Not Zero (ZF=0)
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		int	5		;  - PRINT-SCREEN KEY
					; automatically	called by keyboard scanner when	print-screen key is pressed
		jmp	loc_FE980	; Jump
; ---------------------------------------------------------------------------

loc_FEAB2:				; ...
		mov	bx, offset K11
		test	[byte ptr si+1], 1 ; Logical Compare
		jz	short loc_FEAF4	; Jump if Zero (ZF=1)
		mov	bx, offset K11_RUS
		jmp	short loc_FEB31	; Jump
; ---------------------------------------------------------------------------

loc_FEAC0:				; ...
		mov	bx, offset K10_RUS
		test	[byte ptr si+1], 1 ; Logical Compare
		jnz	short loc_FEB31	; Jump if Not Zero (ZF=0)
		jmp	short loc_FEB2E	; Jump
; ---------------------------------------------------------------------------

loc_FEACB:				; ...
		cmp	al, 54h		; Compare Two Operands
		jnb	short loc_FEB18	; Jump if Not Below (CF=0)
		cmp	al, 4Ah		; Compare Two Operands
		jz	short loc_FEAED	; Jump if Zero (ZF=1)
		cmp	al, 4Eh		; Compare Two Operands
		jz	short loc_FEAED	; Jump if Zero (ZF=1)
		test	[byte ptr si], 20h ; Logical Compare
		jnz	short loc_FEAE8	; Jump if Not Zero (ZF=0)
		test	[byte ptr si], 3 ; Logical Compare
		jnz	short loc_FEAED	; Jump if Not Zero (ZF=0)

loc_FEAE1:				; ...
		cmp	al, 47h		; Compare Two Operands
		jnb	short loc_FEA83	; Jump if Not Below (CF=0)

loc_FEAE5:				; ...
		jmp	loc_FE97B	; Jump
; ---------------------------------------------------------------------------

loc_FEAE8:				; ...
		test	[byte ptr si], 3 ; Logical Compare
		jnz	short loc_FEAE1	; Jump if Not Zero (ZF=0)

loc_FEAED:				; ...
		sub	al, 46h		; Integer Subtraction
		jbe	short loc_FEAE5	; Jump if Below	or Equal (CF=1 | ZF=1)
		mov	bx, offset K14

loc_FEAF4:				; ...
		jmp	short loc_FEB31	; Jump
; ---------------------------------------------------------------------------

loc_FEAF6:				; ...
		mov	ax, 0E200h
		jmp	short loc_FEB2C	; Jump
; ---------------------------------------------------------------------------

loc_FEAFB:				; ...
		mov	bx, offset K13
		test	[byte ptr si], 3 ; Logical Compare
		jnz	short loc_FEB11	; Jump if Not Zero (ZF=0)
		test	[byte ptr si], 40h ; Logical Compare
		jnz	short loc_FEB0B	; Jump if Not Zero (ZF=0)

loc_FEB08:				; ...
		mov	bx, offset K12

loc_FEB0B:				; ...
		sub	al, 54h		; Integer Subtraction
		xlat	[byte ptr cs:bx] ; Table Lookup	Translation
		jmp	short loc_FEB2C	; Jump
; ---------------------------------------------------------------------------

loc_FEB11:				; ...
		test	[byte ptr si], 40h ; Logical Compare
		jnz	short loc_FEB08	; Jump if Not Zero (ZF=0)
		jmp	short loc_FEB0B	; Jump
; ---------------------------------------------------------------------------

loc_FEB18:				; ...
		cmp	al, 62h		; Compare Two Operands
		jz	short loc_FEAF6	; Jump if Zero (ZF=1)
		cmp	al, 5Bh		; Compare Two Operands
		ja	short loc_FEAE5	; Jump if Above	(CF=0 &	ZF=0)
		test	[byte ptr si+1], 1 ; Logical Compare
		jnz	short loc_FEAFB	; Jump if Not Zero (ZF=0)
		cmp	al, 56h		; Compare Two Operands
		jnz	short loc_FEAE5	; Jump if Not Zero (ZF=0)
		mov	al, 0FDh

loc_FEB2C:				; ...
		jmp	short loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FEB2E:				; ...
		mov	bx, offset K10

loc_FEB31:				; ...
		dec	al		; Decrement by 1
		xlat	[byte ptr cs:bx] ; Table Lookup	Translation

loc_FEB35:				; ...
		cmp	al, 0FFh	; Compare Two Operands
		jz	short loc_FEB93	; Jump if Zero (ZF=1)
		cmp	ah, 0FFh	; Compare Two Operands
		jz	short loc_FEB93	; Jump if Zero (ZF=1)
		test	[byte ptr si], 40h ; Logical Compare
		jz	short loc_FEB7E	; Jump if Zero (ZF=1)
		test	[byte ptr si], 3 ; Logical Compare
		jz	short loc_FEB64	; Jump if Zero (ZF=1)
		cmp	al, 41h		; Compare Two Operands
		jb	short loc_FEB7E	; Jump if Below	(CF=1)
		cmp	al, 5Ah		; Compare Two Operands
		ja	short loc_FEB54	; Jump if Above	(CF=0 &	ZF=0)

loc_FEB50:				; ...
		add	al, 20h		; Add
		jmp	short loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FEB54:				; ...
		cmp	al, 0B0h	; Compare Two Operands
		jb	short loc_FEB7E	; Jump if Below	(CF=1)
		cmp	al, 0CFh	; Compare Two Operands
		jbe	short loc_FEB50	; Jump if Below	or Equal (CF=1 | ZF=1)
		cmp	al, 0F0h	; Compare Two Operands
		jnz	short loc_FEB7E	; Jump if Not Zero (ZF=0)
		mov	al, 0F1h
		jmp	short loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FEB64:				; ...
		cmp	al, 61h		; Compare Two Operands
		jb	short loc_FEB7E	; Jump if Below	(CF=1)
		cmp	al, 7Ah		; Compare Two Operands
		ja	short loc_FEB70	; Jump if Above	(CF=0 &	ZF=0)

loc_FEB6C:				; ...
		sub	al, 20h		; Integer Subtraction
		jmp	short loc_FEB7E	; Jump
; ---------------------------------------------------------------------------

loc_FEB70:				; ...
		cmp	al, 0D0h	; Compare Two Operands
		jb	short loc_FEB7E	; Jump if Below	(CF=1)
		cmp	al, 0EFh	; Compare Two Operands
		jbe	short loc_FEB6C	; Jump if Below	or Equal (CF=1 | ZF=1)
		cmp	al, 0F1h	; Compare Two Operands
		jnz	short loc_FEB7E	; Jump if Not Zero (ZF=0)
		mov	al, 0F0h

loc_FEB7E:				; ...
		mov	bx, [ds:1Ch]
		mov	si, bx
		call	K4		; Call Procedure
		cmp	bx, [ds:1Ah]	; Compare Two Operands
		jz	short K62	; Jump if Zero (ZF=1)
		mov	[si], ax
		mov	[ds:1Ch], bx

loc_FEB93:				; ...
		jmp	loc_FE97B	; Jump
; ---------------------------------------------------------------------------

K62:					; ...
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		mov	bx, 80h
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		push	ax

loc_FEBA0:				; ...
		and	al, 0FCh	; Logical AND
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	cx, 48h

loc_FEBA7:				; ...
		loop	loc_FEBA7	; Loop while CX	!= 0
		or	al, 2		; Logical Inclusive OR
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	cx, 48h

loc_FEBB0:				; ...
		loop	loc_FEBB0	; Loop while CX	!= 0
		dec	bx		; Decrement by 1
		jnz	short loc_FEBA0	; Jump if Not Zero (ZF=0)
		pop	ax
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		jmp	loc_FE980	; Jump
; ---------------------------------------------------------------------------

loc_FEBBB:				; ...
		sub	al, 45h		; Integer Subtraction
		xlat	[byte ptr cs:bx] ; Table Lookup	Translation
		mov	ah, al
		mov	al, 0
		jmp	loc_FEB35	; Jump

; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

proc		DISKETTE_IO far		; ...
		sti			; Set Interrupt	Flag
		push	bx
		push	cx
		push	ds
		push	si
		push	di
		push	bp
		push	dx
		mov	bp, sp
		call	SET_DATASEG	; Call Procedure
		test	[byte ptr ds:11h], 20h ; Logical Compare
		jz	short loc_FEBFB	; Jump if Zero (ZF=1)
		shl	ch, 1		; Shift	Logical	Left
		add	ch, dh		; Add
		push	es
		push	bx
		push	ax
		cmp	ah, 5		; Compare Two Operands
		jnz	short loc_FEBFB	; Jump if Not Zero (ZF=0)
		push	bx
		push	cx
		push	ax
		xor	ax, ax		; Logical Exclusive OR
		mov	al, ch
		call	GET_DPT		; Call Procedure

loc_FEBF0:				; ...
		mov	[es:bx], ax
		add	bx, 4		; Add
		loop	loc_FEBF0	; Loop while CX	!= 0
		pop	ax
		pop	cx
		pop	bx

loc_FEBFB:				; ...
		call	J1		; Call Procedure
		mov	bx, 4
		call	GET_PARM	; Call Procedure
		mov	[ds:40h], ah
		test	[byte ptr ds:11h], 20h ; Logical Compare
		pop	dx
		jz	short loc_FEC2E	; Jump if Zero (ZF=1)
		pop	bx
		pop	es
		cmp	dh, 5		; Compare Two Operands
		pop	dx
		jnz	short loc_FEC2E	; Jump if Not Zero (ZF=0)
		mov	ah, [es:bx]
		sub	ah, dh		; Integer Subtraction
		shr	ah, 1		; Shift	Logical	Right
		call	GET_DPT		; Call Procedure

loc_FEC22:				; ...
		mov	[es:bx], ah
		inc	bx		; Increment by 1
		mov	[es:bx], dh
		add	bx, 3		; Add
		loop	loc_FEC22	; Loop while CX	!= 0

loc_FEC2E:				; ...
		mov	ah, [ds:41h]
		cmp	ah, 1		; Compare Two Operands
		cmc			; Complement Carry Flag
		pop	bp
		pop	di
		pop	si
		pop	ds
		pop	cx
		pop	bx
		retf	2		; Return Far from Procedure
endp		DISKETTE_IO ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


proc		J1 near			; ...
		mov	dh, al
		and	[byte ptr ds:3Eh], 7Fh ; Logical AND
		and	[byte ptr ds:3Fh], 7Fh ; Logical AND
		or	ah, ah		; Logical Inclusive OR
		jz	short DISK_RESET ; Jump	if Zero	(ZF=1)
		dec	ah		; Decrement by 1
		jz	short DISK_STATUS ; Jump if Zero (ZF=1)
		mov	[byte ptr ds:41h], 0
		cmp	dl, 4		; Compare Two Operands
		jnb	short J3	; Jump if Not Below (CF=0)
		dec	ah		; Decrement by 1
		jz	short DISK_READ	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jnz	short J2	; Jump if Not Zero (ZF=0)
		jmp	DISK_WRITE	; Jump
; ---------------------------------------------------------------------------

J2:					; ...
		dec	ah		; Decrement by 1
		jz	short DISK_VERF	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short DISK_FORMAT ; Jump if Zero (ZF=1)

J3:					; ...
		mov	[byte ptr ds:41h], 1
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

DISK_RESET:				; ...
		mov	dx, 3F2h
		cli			; Clear	Interrupt Flag
		mov	al, [ds:3Fh]
		mov	cl, 4
		shl	al, cl		; Shift	Logical	Left
		test	al, 20h		; Logical Compare
		jnz	short J5	; Jump if Not Zero (ZF=0)
		test	al, 40h		; Logical Compare
		jnz	short J4	; Jump if Not Zero (ZF=0)
		test	al, 80h		; Logical Compare
		jz	short J6	; Jump if Zero (ZF=1)
		inc	al		; Increment by 1

J4:					; ...
		inc	al		; Increment by 1

J5:					; ...
		inc	al		; Increment by 1

J6:					; ...
		or	al, 8		; Logical Inclusive OR
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		mov	[byte ptr ds:3Eh], 0
		mov	[byte ptr ds:41h], 0
		or	al, 4		; Logical Inclusive OR
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		sti			; Set Interrupt	Flag
		call	CHK_STAT_2	; Call Procedure
		mov	al, [ds:42h]
		cmp	al, 0C0h	; Compare Two Operands
		jz	short J7	; Jump if Zero (ZF=1)
		or	[byte ptr ds:41h], 20h ; Logical Inclusive OR
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J7:					; ...
		mov	ah, 3
		call	NEC_OUTPUT	; Call Procedure
		mov	bx, 1
		call	GET_PARM	; Call Procedure
		mov	bx, 2
		call	GET_PARM	; Call Procedure
		or	ah, 1		; Logical Inclusive OR
		call	NEC_OUTPUT	; Call Procedure
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

DISK_STATUS:				; ...
		mov	al, [ds:41h]
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

DISK_READ:				; ...
		call	sub_FEEC0	; Call Procedure
		mov	ah, 66h
		jmp	short RW_OPN	; Jump
; ---------------------------------------------------------------------------

DISK_VERF:				; ...
		call	sub_FEEC0	; Call Procedure
		mov	ah, 63h
		clc			; Clear	Carry Flag
		jmp	short RW_OPN	; Jump
; ---------------------------------------------------------------------------

DISK_FORMAT:				; ...
		or	[byte ptr ds:3Fh], 80h ; Logical Inclusive OR
		call	sub_FEEC0	; Call Procedure
		mov	ah, 4Dh
		jmp	short RW_OPN	; Jump
; ---------------------------------------------------------------------------

DISK_WRITE:				; ...
		or	[byte ptr ds:3Fh], 80h ; Logical Inclusive OR
		call	sub_FEEC0	; Call Procedure
		mov	ah, 45h		; ; NEC	COMMAND	TO WRITE TO DISKETTE

RW_OPN:					; ...
		jnb	short J11	; ;----- ALLOW WRITE ROUTINE TO	FALL INTO RW_OPN
					; ;---------------------------------------
					; ; RW_OPN
					; ;   THIS ROUTINE PERFORMS THE	READ/WRITE/VERIFY OPERATION
					; ;---------------------------------------
		mov	[byte ptr ds:41h], 9
		mov	al, 0
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J11:					; ...
		push	ax
		push	cx
		mov	cl, dl
		mov	al, 10h
		shl	al, cl		; Shift	Logical	Left
		or	al, dl		; Logical Inclusive OR
		or	al, 0Ch		; Logical Inclusive OR
		mov	[ds:48h], al
		mov	al, 1
		shl	al, cl		; Shift	Logical	Left
		cli			; Clear	Interrupt Flag
		mov	[byte ptr ds:40h], 0FFh
		test	[ds:3Fh], al	; Logical Compare
		jnz	short J14	; Jump if Not Zero (ZF=0)
		and	[byte ptr ds:3Fh], 0F0h	; Logical AND
		or	[ds:3Fh], al	; Logical Inclusive OR
		sti			; Set Interrupt	Flag
		mov	al, [ds:48h]
		push	dx
		mov	dx, 3F2h
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		pop	dx
		mov	bx, 14h
		call	GET_PARM	; Call Procedure

J12:					; ...
		or	ah, ah		; Logical Inclusive OR
		jz	short J14	; Jump if Zero (ZF=1)
		sub	cx, cx		; Integer Subtraction

J13:					; ...
		loop	J13		; Loop while CX	!= 0
		dec	ah		; Decrement by 1
		jmp	short J12	; Jump
; ---------------------------------------------------------------------------

J14:					; ...
		sti			; Set Interrupt	Flag
		pop	cx
		call	near ptr 5300h	; ; ASST EXTERNAL FD SEEK PROC
		pop	ax
		jnb	short SEEK_OK	; Jump if Not Below (CF=0)
		jmp	J21		; Jump
; ---------------------------------------------------------------------------

SEEK_OK:				; ...
		mov	al, ah
		mov	di, ax
		mov	si, offset J21
		push	si
		cmp	ah, 63h		; Compare Two Operands
		jnz	short FD_SEND_OUT ; Jump if Not	Zero (ZF=0)
		mov	ah, 66h

FD_SEND_OUT:				; ...
		call	NEC_OUTPUT	; Call Procedure
		mov	ah, 0
		test	[byte ptr ds:11h], 20h ; Logical Compare
		jnz	short loc_FED6C	; Jump if Not Zero (ZF=0)
		mov	ah, [bp+1]

loc_FED6C:				; ...
		shl	ah, 1		; Shift	Logical	Left
		shl	ah, 1		; Shift	Logical	Left
		and	ah, 4		; Logical AND
		or	ah, dl		; Logical Inclusive OR
		call	NEC_OUTPUT	; Call Procedure
		test	di, 8		; Logical Compare
		jz	short loc_FED98	; Jump if Zero (ZF=1)
		mov	bx, 7
		call	GET_PARM	; Call Procedure
		mov	bx, 9
		call	GET_PARM	; Call Procedure
		mov	bx, 0Fh
		call	GET_PARM	; Call Procedure
		mov	bx, 11h
		mov	bp, 24h
		jmp	short loc_FEDFA	; Jump
; ---------------------------------------------------------------------------

loc_FED98:				; ...
		mov	ah, ch
		call	NEC_OUTPUT	; Call Procedure
		mov	ah, 0
		test	[byte ptr ds:11h], 20h ; Logical Compare
		jnz	short loc_FEDA9	; Jump if Not Zero (ZF=0)
		mov	ah, [bp+1]

loc_FEDA9:				; ...
		call	NEC_OUTPUT	; Call Procedure
		mov	ah, cl
		call	NEC_OUTPUT	; Call Procedure
		mov	bx, 7
		call	GET_PARM	; Call Procedure
		mov	bx, 9
		call	GET_PARM	; Call Procedure
		mov	bx, 0Bh
		call	GET_PARM	; Call Procedure
		mov	bx, 0Dh
		mov	bp, [ds:46h]
		test	di, 20h		; Logical Compare
		jz	short loc_FEDFA	; Jump if Zero (ZF=1)
		mov	cx, [ds:44h]
		mov	dx, 3F4h
		cli			; Clear	Interrupt Flag
		call	GET_PARM	; Call Procedure
		pop	si
		mov	si, di
		mov	di, cx
		sub	cx, cx		; Integer Subtraction

loc_FEDE2:				; ...
		in	al, dx
		cmp	al, 0F0h	; Compare Two Operands
		jz	short loc_FEDEB	; Jump if Zero (ZF=1)
		loop	loc_FEDE2	; Loop while CX	!= 0
		jmp	short loc_FEE33	; Jump
; ---------------------------------------------------------------------------

loc_FEDEB:				; ...
		inc	dx		; Increment by 1
		in	al, dx
		test	si, 4		; Logical Compare
		jz	short loc_FEDF4	; Jump if Zero (ZF=1)
		stosb			; Store	String

loc_FEDF4:				; ...
		dec	dx		; Decrement by 1
		dec	bp		; Decrement by 1
		jnz	short loc_FEDE2	; Jump if Not Zero (ZF=0)
		jmp	short loc_FEE22	; Jump
; ---------------------------------------------------------------------------

loc_FEDFA:				; ...
		mov	cx, [ds:44h]
		mov	dx, 3F4h
		mov	di, ds
		cli			; Clear	Interrupt Flag
		call	GET_PARM	; Call Procedure
		pop	si
		mov	si, cx
		push	es
		pop	ds
		sub	cx, cx		; Integer Subtraction

loc_FEE0E:				; ...
		in	al, dx
		cmp	al, 0B0h	; Compare Two Operands
		jz	short loc_FEE19	; Jump if Zero (ZF=1)
		loop	loc_FEE0E	; Loop while CX	!= 0
		mov	ds, di
		jmp	short loc_FEE33	; Jump
; ---------------------------------------------------------------------------

loc_FEE19:				; ...
		inc	dx		; Increment by 1
		lodsb			; Load String
		out	dx, al
		dec	dx		; Decrement by 1
		dec	bp		; Decrement by 1
		jnz	short loc_FEE0E	; Jump if Not Zero (ZF=0)
		mov	ds, di

loc_FEE22:				; ...
		mov	al, [ds:48h]
		or	al, 80h		; Logical Inclusive OR
		mov	dx, 3F2h
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		and	al, 7Fh		; Logical AND
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;
		call	WAIT_INT	; Call Procedure

J17:					; Jump if Below	(CF=1)
		jb	short J21

loc_FEE33:				; ...
		sti			; Set Interrupt	Flag
		call	RESULTS		; Call Procedure
		jb	short J20	; Jump if Below	(CF=1)
		cld			; Clear	Direction Flag
		mov	si, 42h
		lodsb			; Load String
		and	al, 0C0h	; Logical AND
		jz	short J22	; Jump if Zero (ZF=1)
		cmp	al, 40h		; Compare Two Operands
		jnz	short J18	; Jump if Not Zero (ZF=0)
		lodsb			; Load String
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 4
		jb	short J19	; Jump if Below	(CF=1)
		shl	al, 1		; Shift	Logical	Left
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 10h
		jb	short J19	; Jump if Below	(CF=1)
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 8
		jb	short J19	; Jump if Below	(CF=1)
		shl	al, 1		; Shift	Logical	Left
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 4
		jb	short J19	; Jump if Below	(CF=1)
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 3
		jb	short J19	; Jump if Below	(CF=1)
		shl	al, 1		; Shift	Logical	Left
		mov	ah, 2
		jb	short J19	; Jump if Below	(CF=1)

J18:					; ...
		mov	ah, 20h

J19:					; ...
		or	[ds:41h], ah	; Logical Inclusive OR
		call	NUM_TRANS	; Call Procedure

J20:					; ...
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J21:					; ...
		call	RESULTS		; Call Procedure
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J22:					; ...
		call	NUM_TRANS	; Call Procedure
		xor	ah, ah		; Logical Exclusive OR
		retn			; Return Near from Procedure
endp		J1


; =============== S U B	R O U T	I N E =======================================


proc		NEC_OUTPUT near		; ...
		push	dx
		push	cx
		mov	dx, 3F4h
		xor	cx, cx		; Logical Exclusive OR

J23:					; ...
		in	al, dx		; Floppy: main status reg bits:
					; 0-3: diskette	busy
					; 4: 1=cntrlr busy
					; 5: 1=non-DMA mode
					; 6: Data dir: 1=cntrlr	to CPU
					; 7: 1=OK to snd/rcv cmd or data
		test	al, 40h		; Logical Compare
		jz	short J25	; Jump if Zero (ZF=1)
		loop	J23		; Loop while CX	!= 0

J24:					; ...
		or	[byte ptr ds:41h], 80h ; Logical Inclusive OR
		pop	cx
		pop	dx
		pop	ax
		stc			; Set Carry Flag
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J25:					; ...
		xor	cx, cx		; Logical Exclusive OR

J26:					; ...
		in	al, dx
		test	al, 80h		; Logical Compare
		jnz	short J27	; Jump if Not Zero (ZF=0)
		loop	J26		; Loop while CX	!= 0
		jmp	short J24	; Jump
; ---------------------------------------------------------------------------

J27:					; ...
		pop	cx
		mov	al, ah
		mov	dx, 3F5h
		out	dx, al		; Floppy: FDC command/data register.
		pop	dx
		retn			; Return Near from Procedure
endp		NEC_OUTPUT ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


proc		GET_PARM near		; ...
		push	ds
		sub	ax, ax		; Integer Subtraction
		mov	ds, ax
		lds	si, [ds:78h]	; Load Full Pointer to DS:xx
		shr	bx, 1		; Shift	Logical	Right
		mov	ah, [bx+si]
		pop	ds
		jb	short NEC_OUTPUT ; Jump	if Below (CF=1)
		retn			; Return Near from Procedure
endp		GET_PARM


; =============== S U B	R O U T	I N E =======================================


proc		sub_FEEC0 near		; ...
		push	cx
		mov	[ds:44h], bx
		mov	ax, es
		mov	cl, 4
		shl	ax, cl		; Shift	Logical	Left
		add	bx, ax		; Add
		push	bx
		clc			; Clear	Carry Flag
		mov	bx, 6
		call	GET_PARM	; Call Procedure
		mov	cl, ah
		mov	ah, dh
		shr	ax, 1		; Shift	Logical	Right
		shl	ax, cl		; Shift	Logical	Left
		mov	[ds:46h], ax
		dec	ax		; Decrement by 1
		pop	bx
		add	ax, bx		; Add
		pop	cx
		retn			; Return Near from Procedure
endp		sub_FEEC0


; =============== S U B	R O U T	I N E =======================================


proc		CHK_STAT_2 near		; ...
		call	WAIT_INT	; Call Procedure
		jb	short J34	; Jump if Below	(CF=1)
		mov	ah, 8
		call	NEC_OUTPUT	; Call Procedure
		call	RESULTS		; Call Procedure
		jb	short J34	; Jump if Below	(CF=1)
		mov	al, [ds:42h]
		and	al, 60h		; Logical AND
		cmp	al, 60h		; Compare Two Operands
		jz	short J35	; Jump if Zero (ZF=1)
		clc			; Clear	Carry Flag

J34:					; ...
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J35:					; ...
		or	[byte ptr ds:41h], 40h ; Logical Inclusive OR
		stc			; Set Carry Flag
		retn			; Return Near from Procedure
endp		CHK_STAT_2


; =============== S U B	R O U T	I N E =======================================


proc		WAIT_INT near		; ...
		sti			; Set Interrupt	Flag
		push	bx
		push	cx
		mov	bl, 2
		xor	cx, cx		; Logical Exclusive OR

J36:					; ...
		test	[byte ptr ds:3Eh], 80h ; Logical Compare
		jnz	short J37	; Jump if Not Zero (ZF=0)
		loop	J36		; Loop while CX	!= 0
		dec	bl		; Decrement by 1
		jnz	short J36	; Jump if Not Zero (ZF=0)
		or	[byte ptr ds:41h], 80h ; Logical Inclusive OR
		stc			; Set Carry Flag

J37:					; ...
		pushf			; Push Flags Register onto the Stack
		and	[byte ptr ds:3Eh], 7Fh ; Logical AND
		popf			; Pop Stack into Flags Register
		pop	cx
		pop	bx
		retn			; Return Near from Procedure
endp		WAIT_INT

; ---------------------------------------------------------------------------

DISK_INT:				; ...
		sti			; Set Interrupt	Flag
		push	ds
		push	ax
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		or	[byte ptr ds:3Eh], 80h ; Logical Inclusive OR
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		pop	ax
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return

; =============== S U B	R O U T	I N E =======================================


proc		RESULTS	near		; ...
		cld			; Clear	Direction Flag
		mov	di, 42h
		push	cx
		push	dx
		push	bx
		mov	bl, 7

J38:					; ...
		xor	cx, cx		; Logical Exclusive OR
		mov	dx, 3F4h

J39:					; ...
		in	al, dx		; Floppy: main status reg bits:
					; 0-3: diskette	busy
					; 4: 1=cntrlr busy
					; 5: 1=non-DMA mode
					; 6: Data dir: 1=cntrlr	to CPU
					; 7: 1=OK to snd/rcv cmd or data
		test	al, 80h		; Logical Compare
		jnz	short J40A	; Jump if Not Zero (ZF=0)
		loop	J39		; Loop while CX	!= 0
		or	[byte ptr ds:41h], 80h ; Logical Inclusive OR

J40:					; ...
		stc			; Set Carry Flag
		pop	bx
		pop	dx
		pop	cx
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

J40A:					; ...
		in	al, dx
		test	al, 40h		; Logical Compare
		jnz	short J42	; Jump if Not Zero (ZF=0)

J41:					; ...
		or	[byte ptr ds:41h], 20h ; Logical Inclusive OR
		jmp	short J40	; Jump
; ---------------------------------------------------------------------------

J42:					; ...
		inc	dx		; Increment by 1
		in	al, dx
		mov	[di], al
		inc	di		; Increment by 1
		mov	cx, 0Ah

J43:					; ...
		loop	J43		; Loop while CX	!= 0
		dec	dx		; Decrement by 1
		in	al, dx
		test	al, 10h		; Logical Compare
		jz	short J44	; Jump if Zero (ZF=1)
		dec	bl		; Decrement by 1
		jnz	short J38	; Jump if Not Zero (ZF=0)
		jmp	short J41	; Jump
; ---------------------------------------------------------------------------

J44:					; ...
		pop	bx
		pop	dx
		pop	cx
		retn			; Return Near from Procedure
endp		RESULTS


; =============== S U B	R O U T	I N E =======================================


proc		NUM_TRANS near		; ...
		mov	al, [ds:45h]
		cmp	al, ch		; Compare Two Operands
		mov	al, [ds:47h]
		jz	short J45	; Jump if Zero (ZF=1)
		mov	bx, 8
		call	GET_PARM	; Call Procedure
		mov	al, ah
		inc	al		; Increment by 1

J45:					; ...
		sub	al, cl		; Integer Subtraction
		retn			; Return Near from Procedure
endp		NUM_TRANS


; =============== S U B	R O U T	I N E =======================================


proc		GET_DPT	near		; ...
		push	ds
		xor	cx, cx		; Logical Exclusive OR
		mov	ds, cx
		lds	si, [ds:78h]	; Load Full Pointer to DS:xx
		mov	cl, [si+4]
		pop	ds
		retn			; Return Near from Procedure
endp		GET_DPT


; =============== S U B	R O U T	I N E =======================================


proc		SET_DATASEG near	; ...
		push	ax
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		pop	ax
		retn			; Return Near from Procedure
endp		SET_DATASEG

; ---------------------------------------------------------------------------
DISK_BASE	db 11011111b		; ...
					; ; SRT=C, HD UNLOAD=0F	- 1ST SPECIFY BYTE
		db 2			; ; HD LOAD=1, MODE=DMA	- 2ND SPECIFY BYTE
		db 25h			; MOTOR_WAIT  ;	WAIT AFTER OPN TIL MOTOR OFF
		db 2			; ; 512	BYTES/SECTOR
		db 9			; ; EOT	(LAST SECTOR ON	TRACK)
		db 2Ah			; ; GAP	LENGTH
		db 0FFh			; ; DTL
		db 50h			; ; GAP	LENGTH FOR FORMAT
		db 0F6h			; ; FILL BYTE FOR FORMAT
		db 8			; ; HEAD SETTLE	TIME (MILLISECONDS)
		db 2			; ; MOTOR START	TIME (1/8 SECONDS)

; =============== S U B	R O U T	I N E =======================================


proc		RD_C near		; ...
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 10h		; Logical AND
		cmp	al, ah		; Compare Two Operands
		jz	short RD2	; Jump if Zero (ZF=1)
		mov	bx, 0Ah

RD1:					; ...
		dec	bx		; Decrement by 1
		jnz	short RD1	; Jump if Not Zero (ZF=0)
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 10h		; Logical AND
		cmp	al, ah		; Compare Two Operands

RD2:					; ...
		retn			; Return Near from Procedure
endp		RD_C

; ---------------------------------------------------------------------------
		db    0

; =============== S U B	R O U T	I N E =======================================


proc		PRINTER_IO far		; ...
		sti			; Set Interrupt	Flag
		push	ds
		push	dx
		push	si
		push	cx
		push	bx
		mov	si, 40h
		mov	ds, si
		mov	si, dx
		shl	si, 1		; Shift	Logical	Left
		mov	dx, [si+8]
		or	dx, dx		; Logical Inclusive OR
		jz	short B1	; Jump if Zero (ZF=1)
		or	ah, ah		; Logical Inclusive OR
		jz	short B2	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short B8	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short B5	; Jump if Zero (ZF=1)

B1:					; ...
		pop	bx
		pop	cx
		pop	si
		pop	dx
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

B2:					; ...
		push	ax
		mov	bl, 0Ah
		xor	cx, cx		; Logical Exclusive OR
		out	dx, al
		inc	dx		; Increment by 1

B3:					; ...
		in	al, dx
		mov	ah, al
		test	al, 80h		; Logical Compare
		jnz	short B4	; Jump if Not Zero (ZF=0)
		loop	B3		; Loop while CX	!= 0
		dec	bl		; Decrement by 1
		jnz	short B3	; Jump if Not Zero (ZF=0)
		or	ah, 1		; Logical Inclusive OR
		and	ah, 0F9h	; Logical AND
		jmp	short B7	; Jump
; ---------------------------------------------------------------------------

B4:					; ...
		mov	al, 0Dh
		inc	dx		; Increment by 1
		out	dx, al
		mov	al, 0Ch
		out	dx, al
		pop	ax

B5:					; ...
		push	ax

B6:					; ...
		mov	dx, [si+8]
		inc	dx		; Increment by 1
		in	al, dx
		mov	ah, al
		and	ah, 0F8h	; Logical AND

B7:					; ...
		pop	dx
		mov	al, dl
		xor	ah, 48h		; Logical Exclusive OR
		jmp	short B1	; Jump
; ---------------------------------------------------------------------------

B8:					; ...
		push	ax
		add	dx, 2		; Add
		mov	al, 8
		out	dx, al
		mov	ax, 3E8h

B9:					; ...
		dec	ax		; Decrement by 1
		jnz	short B9	; Jump if Not Zero (ZF=0)
		mov	al, 0Ch
		out	dx, al
		jmp	short B6	; Jump
endp		PRINTER_IO

; ---------------------------------------------------------------------------
M1		dw offset SET_MODE
		dw offset SET_CTYPE
		dw offset SET_CPOS
		dw offset READ_CURSOR
		dw offset READ_LPEN
		dw offset ACT_DISP_PAGE
		dw offset SCROLL_UP
		dw offset SCROLL_DOWN
		dw offset READ_AC_CURRENT
		dw offset WRITE_AC_CURRENT
		dw offset WRITE_C_CURRENT
		dw offset SET_COLOR
		dw offset WRITE_DOT
		dw offset READ_DOT
		dw offset WRITE_TTY
		dw offset VIDEO_STATE
; ---------------------------------------------------------------------------

VIDEO_IO:				; ...
		sti			; Set Interrupt	Flag
		cld			; Clear	Direction Flag
		push	es
		push	ds
		push	dx
		push	cx
		push	bx
		push	si
		push	di
		push	ax
		mov	al, ah
		xor	ah, ah		; Logical Exclusive OR
		shl	ax, 1		; Shift	Logical	Left
		mov	si, ax
		cmp	ax, 20h		; Compare Two Operands
		jb	short M2	; Jump if Below	(CF=1)
		pop	ax
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

M2:					; ...
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	ax, 0B800h
		mov	di, [ds:10h]
		and	di, 30h		; Logical AND
		cmp	di, 30h		; Compare Two Operands
		jnz	short M3	; Jump if Not Zero (ZF=0)
		mov	ax, 0B000h

M3:					; ...
		mov	es, ax
		assume es:nothing
		pop	ax
		mov	ah, [ds:49h]
		jmp	[cs:M1+si]	; Indirect Near	Jump
; ---------------------------------------------------------------------------
VIDEO_PARMS	db 38h			; ...
					; ; SET	UP FOR 40X25
		db  28h	; (
		db  2Ch	; ,
		db  0Ah
		db  26h	; &
		db    0
		db  19h
		db  1Fh
		db    2
		db    7
		db    6
		db    7
		db    0
		db    0
		db    0
		db    0
		db  71h	; q		; ; SET	UP FOR 80X25
		db  50h	; P
		db  59h	; Y
		db  0Fh
		db  26h	; &
		db    0
		db  19h
		db  1Fh
		db    2
		db    7
		db    6
		db    7
		db    0
		db    0
		db    0
		db    0
		db  38h	; 8		; ; SET	UP FOR GRAPHICS
		db  28h	; (
		db  2Ch	; ,
		db  0Ah
		db  7Fh	; 
		db  1Eh
		db  64h	; d
		db  76h	; v
		db    2
		db    1
		db    6
		db    7
		db    0
		db    0
		db    0
		db    0
		db  71h	; q
		db  50h	; P
		db  59h	; Y
		db  0Ah
		db  26h	; &
		db    0
		db  19h
		db  1Fh
		db    2
		db    7
		db    6
		db    7
		db    0
		db    0
		db    0
		db    0			; ; TABLE OF REGEN LENGTHS
M5		dw 2048			; ...
					; ; 40X25
		dw 4096			; ; 80X25
		dw 16384		; ; GRAPHICS
		dw 16384		; ; GRAPHICS
M6		db 40			; ...
					; ;------ COLUMNS
		db 40
		db 80
		db 80
		db 40
		db 40
		db 80
		db 80
M7		db  2Ch	; ,		; ...
					; ; TABLE OF MODE SETS
		db  28h	; (
		db  2Dh	; -
		db  29h	; )
		db  2Ah	; *
		db  2Eh	; .
		db  1Eh
		db  29h	; )
; ---------------------------------------------------------------------------

SET_MODE:				; ...
		mov	dx, 3D4h
		mov	bl, 0
		cmp	di, 30h		; Compare Two Operands
		jnz	short M8	; Jump if Not Zero (ZF=0)
		mov	al, 7
		mov	dx, 3B4h
		inc	bl		; Increment by 1

M8:					; ...
		mov	ah, al
		mov	[ds:49h], al
		mov	[ds:63h], dx
		push	ds
		push	ax
		push	dx
		add	dx, 4		; Add
		mov	al, bl
		out	dx, al
		pop	dx
		sub	ax, ax		; Integer Subtraction
		mov	ds, ax
		assume ds:nothing
		lds	bx, [ds:74h]	; Load Full Pointer to DS:xx
		pop	ax
		mov	cx, 10h
		cmp	ah, 2		; Compare Two Operands
		jb	short M9	; Jump if Below	(CF=1)
		add	bx, cx		; Add
		cmp	ah, 4		; Compare Two Operands
		jb	short M9	; Jump if Below	(CF=1)
		add	bx, cx		; Add
		cmp	ah, 7		; Compare Two Operands
		jb	short M9	; Jump if Below	(CF=1)
		add	bx, cx		; Add

M9:					; ...
		push	ax
		xor	ah, ah		; Logical Exclusive OR

M10:					; ...
		mov	al, ah
		out	dx, al
		inc	dx		; Increment by 1
		inc	ah		; Increment by 1
		mov	al, [bx]
		out	dx, al
		inc	bx		; Increment by 1
		dec	dx		; Decrement by 1
		loop	M10		; Loop while CX	!= 0
		pop	ax
		pop	ds
		xor	di, di		; Logical Exclusive OR
		mov	[ds:4Eh], di
		mov	[byte ptr ds:62h], 0
		mov	cx, 2000h
		cmp	ah, 4		; Compare Two Operands
		jb	short M12	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short M11	; Jump if Zero (ZF=1)
		xor	ax, ax		; Logical Exclusive OR
		jmp	short M13	; Jump
; ---------------------------------------------------------------------------

M11:					; ...
		mov	cx, 800h

M12:					; ...
		mov	ax, 720h

M13:					; ...
		rep stosw		; Store	String
		mov	[word ptr ds:60h], 67h
		mov	al, [ds:49h]
		xor	ah, ah		; Logical Exclusive OR
		mov	si, ax
		mov	dx, [ds:63h]
		add	dx, 4		; Add
		mov	al, [cs:si+OFFSET M7]
		out	dx, al
		mov	[ds:65h], al
		mov	al, [cs:si+OFFSET M6]
		xor	ah, ah		; Logical Exclusive OR
		mov	[ds:4Ah], ax
		and	si, 0Eh		; Logical AND
		mov	cx, [cs:si+OFFSET M5]
		mov	[ds:4Ch], cx
		mov	cx, 8
		mov	di, 50h
		push	ds
		pop	es
		assume es:nothing
		xor	ax, ax		; Logical Exclusive OR
		rep stosw		; Store	String
		inc	dx		; Increment by 1
		mov	al, 30h
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		jnz	short M14	; Jump if Not Zero (ZF=0)
		mov	al, 3Fh

M14:					; ...
		out	dx, al
		mov	[ds:66h], al
; START	OF FUNCTION CHUNK FOR SCROLL_DOWN

VIDEO_RETURN:				; ...
		pop	di
		pop	si
		pop	bx

M15:					; ...
		pop	cx
		pop	dx
		pop	ds
		pop	es
		iret			; Interrupt Return
; END OF FUNCTION CHUNK	FOR SCROLL_DOWN
; ---------------------------------------------------------------------------

SET_CTYPE:				; ...
		mov	ah, 0Ah
		mov	[ds:60h], cx
		call	M16		; Call Procedure
		jmp	short VIDEO_RETURN ; Jump

; =============== S U B	R O U T	I N E =======================================


proc		M16 near		; ...
		mov	dx, [ds:63h]
		mov	al, ah
		out	dx, al
		inc	dx		; Increment by 1
		mov	al, ch
		out	dx, al
		dec	dx		; Decrement by 1
		mov	al, ah
		inc	al		; Increment by 1
		out	dx, al
		inc	dx		; Increment by 1
		mov	al, cl
		out	dx, al
		retn			; Return Near from Procedure
endp		M16

; ---------------------------------------------------------------------------

SET_CPOS:				; ...
		mov	cl, bh
		xor	ch, ch		; Logical Exclusive OR
		shl	cx, 1		; Shift	Logical	Left
		mov	si, cx
		mov	[si+50h], dx
		cmp	[ds:62h], bh	; Compare Two Operands
		jnz	short M17	; Jump if Not Zero (ZF=0)
		mov	ax, dx
		call	M18		; Call Procedure

M17:					; ...
		jmp	short VIDEO_RETURN ; Jump

; =============== S U B	R O U T	I N E =======================================


proc		M18 near		; ...
		call	POSITION	; Call Procedure
		mov	cx, ax
		add	cx, [ds:4Eh]	; Add
		sar	cx, 1		; Shift	Arithmetic Right
		mov	ah, 0Eh
		call	M16		; Call Procedure
		retn			; Return Near from Procedure
endp		M18

; ---------------------------------------------------------------------------

READ_CURSOR:				; ...
		mov	bl, bh
		xor	bh, bh		; Logical Exclusive OR
		shl	bx, 1		; Shift	Logical	Left
		mov	dx, [bx+50h]
		mov	cx, [ds:60h]
		pop	di
		pop	si
		pop	bx
		pop	ax
		pop	ax
		pop	ds
		pop	es
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

ACT_DISP_PAGE:				; ...
		mov	[ds:62h], al
		mov	cx, [ds:4Ch]
		cbw			; AL ->	AX (with sign)
		push	ax
		mul	cx		; Unsigned Multiplication of AL	or AX
		mov	[ds:4Eh], ax
		mov	cx, ax
		sar	cx, 1		; Shift	Arithmetic Right
		mov	ah, 0Ch
		call	M16		; Call Procedure
		pop	bx
		shl	bx, 1		; Shift	Logical	Left
		mov	ax, [bx+50h]
		call	M18		; Call Procedure
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

SET_COLOR:				; ...
		mov	dx, [ds:63h]
		add	dx, 5		; Add
		mov	al, [ds:66h]
		or	bh, bh		; Logical Inclusive OR
		jnz	short M20	; Jump if Not Zero (ZF=0)
		and	al, 0E0h	; Logical AND
		and	bl, 1Fh		; Logical AND
		or	al, bl		; Logical Inclusive OR

M19:					; ...
		out	dx, al
		mov	[ds:66h], al
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

M20:					; ...
		and	al, 0DFh	; Logical AND
		shr	bl, 1		; Shift	Logical	Right
		jnb	short M19	; Jump if Not Below (CF=0)
		or	al, 20h		; Logical Inclusive OR
		jmp	short M19	; Jump
; ---------------------------------------------------------------------------

VIDEO_STATE:				; ...
		mov	ah, [ds:4Ah]
		mov	al, [ds:49h]
		mov	bh, [ds:62h]
		pop	di
		pop	si
		pop	cx
		jmp	M15		; Jump

; =============== S U B	R O U T	I N E =======================================


proc		POSITION near		; ...
		push	bx
		mov	bx, ax
		mov	al, ah
		mul	[byte ptr ds:4Ah] ; Unsigned Multiplication of AL or AX
		xor	bh, bh		; Logical Exclusive OR
		add	ax, bx		; Add
		shl	ax, 1		; Shift	Logical	Left
		pop	bx
		retn			; Return Near from Procedure
endp		POSITION


; =============== S U B	R O U T	I N E =======================================


proc		SCROLL_UP near		; ...

; FUNCTION CHUNK AT F2E6 SIZE 00000004 BYTES

		mov	bl, al
		cmp	ah, 4		; Compare Two Operands
		jb	short N1	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short N1	; Jump if Zero (ZF=1)
		jmp	GRAPHICS_UP	; Jump
; ---------------------------------------------------------------------------

N1:					; ...
		push	bx
		mov	ax, cx
		call	SCROLL_POSITION	; Call Procedure
		jz	short N7	; Jump if Zero (ZF=1)
		add	si, ax		; Add
		mov	ah, dh
		sub	ah, bl		; Integer Subtraction

N2:					; ...
		call	N10		; Call Procedure
		add	si, bp		; Add
		add	di, bp		; Add
		dec	ah		; Decrement by 1
		jnz	short N2	; Jump if Not Zero (ZF=0)

N3:					; ...
		pop	ax
		mov	al, 20h

N4:					; ...
		call	N11		; Call Procedure
		add	di, bp		; Add
		dec	bl		; Decrement by 1
		jnz	short N4	; Jump if Not Zero (ZF=0)
endp		SCROLL_UP

; START	OF FUNCTION CHUNK FOR SCROLL_DOWN

N5:					; ...
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		cmp	[byte ptr ds:49h], 7 ; Compare Two Operands
		jz	short N6	; Jump if Zero (ZF=1)
		mov	al, [ds:65h]
		mov	dx, 3D8h
		out	dx, al

N6:					; ...
		jmp	VIDEO_RETURN	; Jump
; END OF FUNCTION CHUNK	FOR SCROLL_DOWN
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR SCROLL_UP

N7:					; ...
		mov	bl, dh
		jmp	short N3	; Jump
; END OF FUNCTION CHUNK	FOR SCROLL_UP

; =============== S U B	R O U T	I N E =======================================


proc		SCROLL_POSITION	near	; ...
		cmp	[byte ptr ds:49h], 2 ; Compare Two Operands
		jb	short N9	; Jump if Below	(CF=1)
		cmp	[byte ptr ds:49h], 3 ; Compare Two Operands
		ja	short N9	; Jump if Above	(CF=0 &	ZF=0)
		push	dx
		mov	dx, 3DAh
		push	ax

N8:					; ...
		in	al, dx		; Video	status bits:
					; 0: retrace.  1=display is in vert or horiz retrace.
					; 1: 1=light pen is triggered; 0=armed
					; 2: 1=light pen switch	is open; 0=closed
					; 3: 1=vertical	sync pulse is occurring.
		test	al, 8		; Logical Compare
		jz	short N8	; Jump if Zero (ZF=1)
		mov	al, 25h
		mov	dx, 3D8h
		out	dx, al
		pop	ax
		pop	dx

N9:					; ...
		call	POSITION	; Call Procedure
		add	ax, [ds:4Eh]	; Add
		mov	di, ax
		mov	si, ax
		sub	dx, cx		; Integer Subtraction
		inc	dh		; Increment by 1
		inc	dl		; Increment by 1
		xor	ch, ch		; Logical Exclusive OR
		mov	bp, [ds:4Ah]
		add	bp, bp		; Add
		mov	al, bl
		mul	[byte ptr ds:4Ah] ; Unsigned Multiplication of AL or AX
		add	ax, ax		; Add
		push	es
		pop	ds
		assume ds:nothing
		cmp	bl, 0		; Compare Two Operands
		retn			; Return Near from Procedure
endp		SCROLL_POSITION


; =============== S U B	R O U T	I N E =======================================


proc		N10 near		; ...
		mov	cl, dl
		push	si
		push	di
		rep movsw		; Move Byte(s) from String to String
		pop	di
		pop	si
		retn			; Return Near from Procedure
endp		N10


; =============== S U B	R O U T	I N E =======================================


proc		N11 near		; ...
		mov	cl, dl
		push	di
		rep stosw		; Store	String
		pop	di
		retn			; Return Near from Procedure
endp		N11


; =============== S U B	R O U T	I N E =======================================


proc		SCROLL_DOWN near	; ...

; FUNCTION CHUNK AT F1C7 SIZE 00000008 BYTES
; FUNCTION CHUNK AT F2D0 SIZE 00000016 BYTES
; FUNCTION CHUNK AT F4F7 SIZE 00000060 BYTES

		std			; Set Direction	Flag
		mov	bl, al
		cmp	ah, 4		; Compare Two Operands
		jb	short N12	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short N12	; Jump if Zero (ZF=1)
		jmp	GRAPHICS_DOWN	; Jump
; ---------------------------------------------------------------------------

N12:					; ...
		push	bx
		mov	ax, dx
		call	SCROLL_POSITION	; Call Procedure
		jz	short N16	; Jump if Zero (ZF=1)
		sub	si, ax		; Integer Subtraction
		mov	ah, dh
		sub	ah, bl		; Integer Subtraction

N13:					; ...
		call	N10		; Call Procedure
		sub	si, bp		; Integer Subtraction
		sub	di, bp		; Integer Subtraction
		dec	ah		; Decrement by 1
		jnz	short N13	; Jump if Not Zero (ZF=0)

N14:					; ...
		pop	ax
		mov	al, 20h

N15:					; ...
		call	N11		; Call Procedure
		sub	di, bp		; Integer Subtraction
		dec	bl		; Decrement by 1
		jnz	short N15	; Jump if Not Zero (ZF=0)
		jmp	N5		; Jump
; ---------------------------------------------------------------------------

N16:					; ...
		mov	bl, dh
		jmp	short N14	; Jump
endp		SCROLL_DOWN ; sp-analysis failed

; ---------------------------------------------------------------------------

READ_AC_CURRENT:			; ...
		cmp	ah, 4		; Compare Two Operands
		jb	short P1	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short P1	; Jump if Zero (ZF=1)
		jmp	GRAPHICS_READ	; Jump
; ---------------------------------------------------------------------------

P1:					; ...
		call	FIND_POSITION	; Call Procedure
		mov	si, bx
		mov	dx, [ds:63h]
		add	dx, 6		; Add
		push	es
		pop	ds

P2:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jnz	short P2	; Jump if Not Zero (ZF=0)
		cli			; Clear	Interrupt Flag

P3:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jz	short P3	; Jump if Zero (ZF=1)
		lodsw			; Load String
		jmp	VIDEO_RETURN	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		FIND_POSITION near	; ...
		mov	cl, bh
		xor	ch, ch		; Logical Exclusive OR
		mov	si, cx
		shl	si, 1		; Shift	Logical	Left
		mov	ax, [si+50h]
		xor	bx, bx		; Logical Exclusive OR
		jcxz	short P5	; Jump if CX is	0

P4:					; ...
		add	bx, [ds:4Ch]	; Add
		loop	P4		; Loop while CX	!= 0

P5:					; ...
		call	POSITION	; Call Procedure
		add	bx, ax		; Add
		retn			; Return Near from Procedure
endp		FIND_POSITION

; ---------------------------------------------------------------------------

WRITE_AC_CURRENT:			; ...
		cmp	ah, 4		; Compare Two Operands
		jb	short P6	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short P6	; Jump if Zero (ZF=1)
		jmp	GRAPHICS_WRITE	; Jump
; ---------------------------------------------------------------------------

P6:					; ...
		mov	ah, bl
		push	ax
		push	cx
		call	FIND_POSITION	; Call Procedure
		mov	di, bx
		pop	cx
		pop	bx

P7:					; ...
		mov	dx, [ds:63h]
		add	dx, 6		; Add

P8:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jnz	short P8	; Jump if Not Zero (ZF=0)
		cli			; Clear	Interrupt Flag

P9:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jz	short P9	; Jump if Zero (ZF=1)
		mov	ax, bx
		stosw			; Store	String
		sti			; Set Interrupt	Flag
		loop	P7		; Loop while CX	!= 0
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

WRITE_C_CURRENT:			; ...
		cmp	ah, 4		; Compare Two Operands
		jb	short P10	; Jump if Below	(CF=1)
		cmp	ah, 7		; Compare Two Operands
		jz	short P10	; Jump if Zero (ZF=1)
		jmp	GRAPHICS_WRITE	; Jump
; ---------------------------------------------------------------------------

P10:					; ...
		push	ax
		push	cx
		call	FIND_POSITION	; Call Procedure
		mov	di, bx
		pop	cx
		pop	bx

P11:					; ...
		mov	dx, [ds:63h]
		add	dx, 6		; Add

P12:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jnz	short P12	; Jump if Not Zero (ZF=0)
		cli			; Clear	Interrupt Flag

P13:					; ...
		in	al, dx
		test	al, 1		; Logical Compare
		jz	short P13	; Jump if Zero (ZF=1)
		mov	al, bl
		stosb			; Store	String
		inc	di		; Increment by 1
		loop	P11		; Loop while CX	!= 0
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

READ_DOT:				; ...
		call	R3		; Call Procedure
		mov	al, [es:si]
		and	al, ah		; Logical AND
		shl	al, cl		; Shift	Logical	Left
		mov	cl, dh
		rol	al, cl		; Rotate Left
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

WRITE_DOT:				; ...
		push	ax
		push	ax
		call	R3		; Call Procedure
		shr	al, cl		; Shift	Logical	Right
		and	al, ah		; Logical AND
		mov	cl, [es:si]
		pop	bx
		test	bl, 80h		; Logical Compare
		jnz	short R2	; Jump if Not Zero (ZF=0)
		not	ah		; One's Complement Negation
		and	cl, ah		; Logical AND
		or	al, cl		; Logical Inclusive OR

R1:					; ...
		mov	[es:si], al
		pop	ax
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

R2:					; ...
		xor	al, cl		; Logical Exclusive OR
		jmp	short R1	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		R3 near			; ...
		push	bx
		push	ax
		mov	al, 40
		push	dx
		and	dl, 0FEh	; Logical AND
		mul	dl		; Unsigned Multiplication of AL	or AX
		pop	dx
		test	dl, 1		; Logical Compare
		jz	short R4	; Jump if Zero (ZF=1)
		add	ax, 2000h	; Add

R4:					; ...
		mov	si, ax
		pop	ax
		mov	dx, cx
		mov	bx, 2C0h
		mov	cx, 302h
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		jb	short R5	; Jump if Below	(CF=1)
		mov	bx, 180h
		mov	cx, 703h

R5:					; ...
		and	ch, dl		; Logical AND
		shr	dx, cl		; Shift	Logical	Right
		add	si, dx		; Add
		mov	dh, bh
		sub	cl, cl		; Integer Subtraction

R6:					; ...
		ror	al, 1		; Rotate Right
		add	cl, ch		; Add
		dec	bh		; Decrement by 1
		jnz	short R6	; Jump if Not Zero (ZF=0)
		mov	ah, bl
		shr	ah, cl		; Shift	Logical	Right
		pop	bx
		retn			; Return Near from Procedure
endp		R3


; =============== S U B	R O U T	I N E =======================================


proc		GRAPHICS_UP near	; ...
		mov	bl, al
		mov	ax, cx
		call	GRAPH_POSN	; Call Procedure
		mov	di, ax
		sub	dx, cx		; Integer Subtraction
		add	dx, 101h	; Add
		shl	dh, 1		; Shift	Logical	Left
		shl	dh, 1		; Shift	Logical	Left
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		jnb	short R7	; Jump if Not Below (CF=0)
		shl	dl, 1		; Shift	Logical	Left
		shl	di, 1		; Shift	Logical	Left

R7:					; ...
		push	es
		pop	ds
		sub	ch, ch		; Integer Subtraction
		shl	bl, 1		; Shift	Logical	Left
		shl	bl, 1		; Shift	Logical	Left
		jz	short R_11	; Jump if Zero (ZF=1)
		mov	al, bl
		mov	ah, 50h
		mul	ah		; Unsigned Multiplication of AL	or AX
		mov	si, di
		add	si, ax		; Add
		mov	ah, dh
		sub	ah, bl		; Integer Subtraction

R_8:					; ...
		call	R17		; Call Procedure
		sub	si, 1FB0h	; Integer Subtraction
		sub	di, 1FB0h	; Integer Subtraction
		dec	ah		; Decrement by 1
		jnz	short R_8	; Jump if Not Zero (ZF=0)

R_9:					; ...
		mov	al, bh

R_10:					; ...
		call	R18		; Call Procedure
		sub	di, 1FB0h	; Integer Subtraction
		dec	bl		; Decrement by 1
		jnz	short R_10	; Jump if Not Zero (ZF=0)
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

R_11:					; ...
		mov	bl, dh
		jmp	short R_9	; Jump
endp		GRAPHICS_UP

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR SCROLL_DOWN

GRAPHICS_DOWN:				; ...
		std			; Set Direction	Flag
		mov	bl, al
		mov	ax, dx
		call	GRAPH_POSN	; Call Procedure
		mov	di, ax
		sub	dx, cx		; Integer Subtraction
		add	dx, 101h	; Add
		shl	dh, 1		; Shift	Logical	Left
		shl	dh, 1		; Shift	Logical	Left
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		jnb	short R_12	; Jump if Not Below (CF=0)
		shl	dl, 1		; Shift	Logical	Left
		shl	di, 1		; Shift	Logical	Left
		inc	di		; Increment by 1

R_12:					; ...
		push	es
		pop	ds
		sub	ch, ch		; Integer Subtraction
		add	di, 0F0h	; Add
		shl	bl, 1		; Shift	Logical	Left
		shl	bl, 1		; Shift	Logical	Left
		jz	short R_16	; Jump if Zero (ZF=1)
		mov	al, bl
		mov	ah, 50h
		mul	ah		; Unsigned Multiplication of AL	or AX
		mov	si, di
		sub	si, ax		; Integer Subtraction
		mov	ah, dh
		sub	ah, bl		; Integer Subtraction

R_13:					; ...
		call	R17		; Call Procedure
		sub	si, 2000H+80	; Integer Subtraction
		sub	di, 2000h+80	; Integer Subtraction
		dec	ah		; Decrement by 1
		jnz	short R_13	; Jump if Not Zero (ZF=0)

R_14:					; ...
		mov	al, bh

R_15:					; ...
		call	R18		; Call Procedure
		sub	di, 2050h	; Integer Subtraction
		dec	bl		; Decrement by 1
		jnz	short R_15	; Jump if Not Zero (ZF=0)
		cld			; Clear	Direction Flag
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

R_16:					; ...
		mov	bl, dh
		jmp	short R_14	; Jump
; END OF FUNCTION CHUNK	FOR SCROLL_DOWN

; =============== S U B	R O U T	I N E =======================================


proc		R17 near		; ...
		mov	cl, dl
		push	si
		push	di
		rep movsb		; Move Byte(s) from String to String
		pop	di
		pop	si
		add	si, 2000h	; Add
		add	di, 2000h	; Add
		push	si
		push	di
		mov	cl, dl
		rep movsb		; Move Byte(s) from String to String
		pop	di
		pop	si
		retn			; Return Near from Procedure
endp		R17


; =============== S U B	R O U T	I N E =======================================


proc		R18 near		; ...
		mov	cl, dl
		push	di
		rep stosb		; Store	String
		pop	di
		add	di, 2000h	; Add
		push	di
		mov	cl, dl
		rep stosb		; Store	String
		pop	di
		retn			; Return Near from Procedure
endp		R18


; =============== S U B	R O U T	I N E =======================================


proc		GRAPHICS_WRITE near	; ...
		mov	ah, 0
		push	ax
		call	S26		; Call Procedure
		mov	di, ax
		pop	ax
		cmp	al, 80h		; Compare Two Operands
		jnb	short S1	; Jump if Not Below (CF=0)
		mov	si, offset CRT_CHAR_GEN
		push	cs
		jmp	short S2	; Jump
; ---------------------------------------------------------------------------

S1:					; ...
		sub	al, 80h		; Integer Subtraction
		push	ds
		sub	si, si		; Integer Subtraction
		mov	ds, si
		lds	si, [ds:7Ch]	; Load Full Pointer to DS:xx
		mov	dx, ds
		pop	ds
		push	dx

S2:					; ...
		shl	ax, 1		; Shift	Logical	Left
		shl	ax, 1		; Shift	Logical	Left
		shl	ax, 1		; Shift	Logical	Left
		add	si, ax		; Add
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		pop	ds
		jb	short S7	; Jump if Below	(CF=1)

S3:					; ...
		push	di
		push	si
		mov	dh, 4

S4:					; ...
		lodsb			; Load String
		test	bl, 80h		; Logical Compare
		jnz	short S6	; Jump if Not Zero (ZF=0)
		stosb			; Store	String
		lodsb			; Load String

S5:					; ...
		mov	[es:di+1FFFh], al
		add	di, 4Fh		; Add
		dec	dh		; Decrement by 1
		jnz	short S4	; Jump if Not Zero (ZF=0)
		pop	si
		pop	di
		inc	di		; Increment by 1
		loop	S3		; Loop while CX	!= 0
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

S6:					; ...
		xor	al, [es:di]	; Logical Exclusive OR
		stosb			; Store	String
		lodsb			; Load String
		xor	al, [es:di+1FFFh] ; Logical Exclusive OR
		jmp	short S5	; Jump
; ---------------------------------------------------------------------------

S7:					; ...
		mov	dl, bl
		shl	di, 1		; Shift	Logical	Left
		call	S19		; Call Procedure

S8:					; ...
		push	di
		push	si
		mov	dh, 4

S9:					; ...
		lodsb			; Load String
		call	S21		; Call Procedure
		and	ax, bx		; Logical AND
		test	dl, 80h		; Logical Compare
		jz	short S10	; Jump if Zero (ZF=1)
		xor	ah, [es:di]	; Logical Exclusive OR
		xor	al, [es:di+1]	; Logical Exclusive OR

S10:					; ...
		mov	[es:di], ah
		mov	[es:di+1], al
		lodsb			; Load String
		call	S21		; Call Procedure
		and	ax, bx		; Logical AND
		test	dl, 80h		; Logical Compare
		jz	short S11	; Jump if Zero (ZF=1)
		xor	ah, [es:di+2000h] ; Logical Exclusive OR
		xor	al, [es:di+2001h] ; Logical Exclusive OR

S11:					; ...
		mov	[es:di+2000h], ah
		mov	[es:di+2001h], al
		add	di, 50h		; Add
		dec	dh		; Decrement by 1
		jnz	short S9	; Jump if Not Zero (ZF=0)
		pop	si
		pop	di
		add	di, 2		; Add
		loop	S8		; Loop while CX	!= 0
		jmp	VIDEO_RETURN	; Jump
endp		GRAPHICS_WRITE

; ---------------------------------------------------------------------------

GRAPHICS_READ:				; ...
		call	S26		; Call Procedure
		mov	si, ax
		sub	sp, 8		; Integer Subtraction
		mov	bp, sp
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		push	es
		pop	ds
		jb	short S13	; Jump if Below	(CF=1)
		mov	dh, 4

S12:					; ...
		mov	al, [si]
		mov	[bp+0],	al
		inc	bp		; Increment by 1
		mov	al, [si+2000h]
		mov	[bp+0],	al
		inc	bp		; Increment by 1
		add	si, 50h		; Add
		dec	dh		; Decrement by 1
		jnz	short S12	; Jump if Not Zero (ZF=0)
		jmp	short S15	; Jump
; ---------------------------------------------------------------------------
		db  90h	; �
; ---------------------------------------------------------------------------

S13:					; ...
		shl	si, 1		; Shift	Logical	Left
		mov	dh, 4

S14:					; ...
		call	S23		; Call Procedure
		add	si, 2000h	; Add
		call	S23		; Call Procedure
		sub	si, 1FB0h	; Integer Subtraction
		dec	dh		; Decrement by 1
		jnz	short S14	; Jump if Not Zero (ZF=0)

S15:					; ...
		mov	di, 0FA6Eh
		push	cs
		pop	es
		assume es:nothing
		sub	bp, 8		; Integer Subtraction
		mov	si, bp
		cld			; Clear	Direction Flag
		mov	al, 0

S16:					; ...
		push	ss
		pop	ds
		assume ds:nothing
		mov	dx, 80h

S17:					; ...
		push	si
		push	di
		mov	cx, 8
		repe cmpsb		; Compare Strings
		pop	di
		pop	si
		jz	short S18	; Jump if Zero (ZF=1)
		inc	al		; Increment by 1
		add	di, 8		; Add
		dec	dx		; Decrement by 1
		jnz	short S17	; Jump if Not Zero (ZF=0)
		cmp	al, 0		; Compare Two Operands
		jz	short S18	; Jump if Zero (ZF=1)
		sub	ax, ax		; Integer Subtraction
		mov	ds, ax
		assume ds:nothing
		les	di, [ds:7Ch]	; Load Full Pointer to ES:xx
		assume es:nothing
		mov	ax, es
		or	ax, di		; Logical Inclusive OR
		jz	short S18	; Jump if Zero (ZF=1)
		mov	al, 80h
		jmp	short S16	; Jump
; ---------------------------------------------------------------------------

S18:					; ...
		add	sp, 8		; Add
		jmp	VIDEO_RETURN	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		S19 near		; ...
		and	bl, 3		; Logical AND
		mov	al, bl
		push	cx
		mov	cx, 3

S20:					; ...
		shl	al, 1		; Shift	Logical	Left
		shl	al, 1		; Shift	Logical	Left
		or	bl, al		; Logical Inclusive OR
		loop	S20		; Loop while CX	!= 0
		mov	bh, bl
		pop	cx
		retn			; Return Near from Procedure
endp		S19


; =============== S U B	R O U T	I N E =======================================


proc		S21 near		; ...
		push	dx		; ;--------------------------------------------
					; ; EXPAND_BYTE
					; ;  THIS ROUTINE TAKES	THE BYTE IN AL AND DOUBLES ALL
					; ;  OF	THE BITS, TURNING THE 8	BITS INTO 16 BITS.
					; ;  THE RESULT	IS LEFT	IN AX
					; ;--------------------------------------------
		push	cx
		push	bx
		mov	dx, 0
		mov	cx, 1

S22:					; ...
		mov	bx, ax
		and	bx, cx		; Logical AND
		or	dx, bx		; Logical Inclusive OR
		shl	ax, 1		; Shift	Logical	Left
		shl	cx, 1		; Shift	Logical	Left
		mov	bx, ax
		and	bx, cx		; Logical AND
		or	dx, bx		; Logical Inclusive OR
		shl	cx, 1		; Shift	Logical	Left
		jnb	short S22	; Jump if Not Below (CF=0)
		mov	ax, dx
		pop	bx
		pop	cx
		pop	dx
		retn			; Return Near from Procedure
endp		S21


; =============== S U B	R O U T	I N E =======================================


proc		S23 near		; ...
		mov	ah, [si]
		mov	al, [si+1]
		mov	cx, 0C000h
		mov	dl, 0

loc_FF6F9:				; ...
		test	ax, cx		; Logical Compare
		clc			; Clear	Carry Flag
		jz	short loc_FF6FF	; Jump if Zero (ZF=1)
		stc			; Set Carry Flag

loc_FF6FF:				; ...
		rcl	dl, 1		; Rotate Through Carry Left
		shr	cx, 1		; Shift	Logical	Right
		shr	cx, 1		; Shift	Logical	Right
		jnb	short loc_FF6F9	; Jump if Not Below (CF=0)
		mov	[bp+0],	dl
		inc	bp		; Increment by 1
		retn			; Return Near from Procedure
endp		S23


; =============== S U B	R O U T	I N E =======================================


proc		S26 near		; ...
		mov	ax, [ds:50h]
endp		S26 ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


proc		GRAPH_POSN near		; ...
		push	bx
		mov	bx, ax
		mov	al, ah
		mul	[byte ptr ds:4Ah] ; Unsigned Multiplication of AL or AX
		shl	ax, 1		; Shift	Logical	Left
		shl	ax, 1		; Shift	Logical	Left
		sub	bh, bh		; Integer Subtraction
		add	ax, bx		; Add
		pop	bx
		retn			; Return Near from Procedure
endp		GRAPH_POSN

; ---------------------------------------------------------------------------

WRITE_TTY:				; ...
		push	ax
		push	ax
		mov	bh, [ds:62h]
		mov	ah, 3
		int	10h		; - VIDEO - READ CURSOR	POSITION
					; BH = page number
					; Return: DH,DL	= row,column, CH = cursor start	line, CL = cursor end line
		pop	ax
		cmp	al, 8		; Compare Two Operands
		jz	short U8	; Jump if Zero (ZF=1)
		cmp	al, 0Dh		; Compare Two Operands
		jz	short U9	; Jump if Zero (ZF=1)
		cmp	al, 0Ah		; Compare Two Operands
		jz	short U10	; Jump if Zero (ZF=1)
		cmp	al, 7		; Compare Two Operands
		jz	short U11	; Jump if Zero (ZF=1)
		mov	ah, 0Ah
		mov	cx, 1
		int	10h		; - VIDEO - WRITE CHARACTERS ONLY AT CURSOR POSITION
					; AL = character, BH = display page - alpha mode
					; BL = color of	character (graphics mode, PCjr only)
					; CX = number of times to write	character
		inc	dl		; Increment by 1
		cmp	dl, [ds:4Ah]	; Compare Two Operands
		jnz	short U7	; Jump if Not Zero (ZF=0)
		mov	dl, 0
		cmp	dh, 18h		; Compare Two Operands
		jnz	short U6	; Jump if Not Zero (ZF=0)

U1:					; ...
		mov	ah, 2
		mov	bh, 0
		int	10h		; - VIDEO - SET	CURSOR POSITION
					; DH,DL	= row, column (0,0 = upper left)
					; BH = page number
		mov	al, [ds:49h]
		cmp	al, 4		; Compare Two Operands
		jb	short U2	; Jump if Below	(CF=1)
		cmp	al, 7		; Compare Two Operands
		mov	bh, 0
		jnz	short U3	; Jump if Not Zero (ZF=0)

U2:					; ...
		mov	ah, 8
		int	10h		; - VIDEO - READ ATTRIBUTES/CHARACTER AT CURSOR	POSITION
					; BH = display page
					; Return: AL = character
					; AH = attribute of character (alpha modes)
		mov	bh, ah

U3:					; ...
		mov	ax, 601h
		mov	cx, 0
		mov	dh, 18h
		mov	dl, [ds:4Ah]
		dec	dl		; Decrement by 1

U4:					; ...
		int	10h		; - VIDEO - SCROLL PAGE	UP
					; AL = number of lines to scroll window	(0 = blank whole window)
					; BH = attributes to be	used on	blanked	lines
					; CH,CL	= row,column of	upper left corner of window to scroll
					; DH,DL	= row,column of	lower right corner of window

U5:					; ...
		pop	ax
		jmp	VIDEO_RETURN	; Jump
; ---------------------------------------------------------------------------

U6:					; ...
		inc	dh		; Increment by 1

U7:					; ...
		mov	ah, 2
		jmp	short U4	; Jump
; ---------------------------------------------------------------------------

U8:					; ...
		cmp	dl, 0		; Compare Two Operands
		jz	short U7	; Jump if Zero (ZF=1)
		dec	dl		; Decrement by 1
		jmp	short U7	; Jump
; ---------------------------------------------------------------------------

U9:					; ...
		mov	dl, 0
		jmp	short U7	; Jump
; ---------------------------------------------------------------------------

U10:					; ...
		cmp	dh, 24		; Compare Two Operands
		jnz	short U6	; Jump if Not Zero (ZF=0)
		jmp	short U1	; Jump
; ---------------------------------------------------------------------------

U11:					; ...
		mov	bl, 2
		call	BEEP		; Call Procedure
		jmp	short U5	; Jump
; ---------------------------------------------------------------------------
V1		db 3			; ...
					; ;------ SUBTRACT_TABLE
		db 3
		db 5
		db 5
		db 3
		db 3
		db 3
		db 4

; =============== S U B	R O U T	I N E =======================================


proc		READ_LPEN far		; ...
		mov	ah, 0
		mov	dx, [ds:63h]
		add	dx, 6		; Add
		in	al, dx
		test	al, 4		; Logical Compare
		jnz	short V6	; Jump if Not Zero (ZF=0)
		test	al, 2		; Logical Compare
		jz	short V7	; Jump if Zero (ZF=1)
		mov	ah, 10h
		mov	dx, [ds:63h]
		mov	al, ah
		out	dx, al
		inc	dx		; Increment by 1
		in	al, dx
		mov	ch, al
		dec	dx		; Decrement by 1
		inc	ah		; Increment by 1
		mov	al, ah
		out	dx, al
		inc	dx		; Increment by 1
		in	al, dx
		mov	ah, ch
		mov	bl, [ds:49h]
		sub	bh, bh		; Integer Subtraction
		mov	bl, [cs:bx+OFFSET V1]
		sub	ax, bx		; Integer Subtraction
		sub	ax, [ds:4Eh]	; Integer Subtraction
		jns	short V2	; Jump if Not Sign (SF=0)
		mov	ax, 0

V2:					; ...
		mov	cl, 3
		cmp	[byte ptr ds:49h], 4 ; Compare Two Operands
		jb	short V4	; Jump if Below	(CF=1)
		cmp	[byte ptr ds:49h], 7 ; Compare Two Operands
		jz	short V4	; Jump if Zero (ZF=1)
		mov	dl, 28h
		div	dl		; Unsigned Divide
		mov	ch, al
		add	ch, ch		; Add
		mov	bl, ah
		sub	bh, bh		; Integer Subtraction
		cmp	[byte ptr ds:49h], 6 ; Compare Two Operands
		jnz	short V3	; Jump if Not Zero (ZF=0)
		mov	cl, 4
		shl	ah, 1		; Shift	Logical	Left

V3:					; ...
		shl	bx, cl		; Shift	Logical	Left
		mov	dl, ah
		mov	dh, al
		shr	dh, 1		; Shift	Logical	Right
		shr	dh, 1		; Shift	Logical	Right
		jmp	short V5	; Jump
; ---------------------------------------------------------------------------

V4:					; ...
		div	[byte ptr ds:4Ah] ; Unsigned Divide
		mov	dh, al
		mov	dl, ah
		shl	al, cl		; Shift	Logical	Left
		mov	ch, al
		mov	bl, ah
		xor	bh, bh		; Logical Exclusive OR
		shl	bx, cl		; Shift	Logical	Left

V5:					; ...
		mov	ah, 1

V6:					; ...
		push	dx
		mov	dx, [ds:63h]
		add	dx, 7		; Add
		out	dx, al
		pop	dx

V7:					; ...
		pop	di
		pop	si
		pop	ds
		pop	ds
		pop	ds
		pop	ds
		pop	es
		iret			; Interrupt Return
endp		READ_LPEN ; sp-analysis	failed

; ---------------------------------------------------------------------------

MEMORY_SIZE_DETERMINE:			; ...
		sti			; Set Interrupt	Flag
		push	ds
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	ax, [ds:13h]
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

EQUIPMENT:				; ...
		sti			; Set Interrupt	Flag
		push	ds
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		mov	ax, [ds:10h]
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

CASSETTE_IO:				; ...
		sti			; Set Interrupt	Flag
		push	ds
		push	ax
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		and	[byte ptr ds:71h], 7Fh ; Logical AND
		pop	ax
		call	W1		; Call Procedure
		pop	ds
		assume ds:nothing
		retf	2		; Return Far from Procedure

; =============== S U B	R O U T	I N E =======================================


proc		W1 near			; ...
		or	ah, ah		; Logical Inclusive OR
		jz	short MOTOR_ON	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short MOTOR_OFF	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short READ_BLOCK ; Jump	if Zero	(ZF=1)
		dec	ah		; Decrement by 1
		jnz	short W2	; Jump if Not Zero (ZF=0)
		jmp	WRITE_BLOCK	; Jump
; ---------------------------------------------------------------------------

W2:					; ...
		mov	ah, 80h
		stc			; Set Carry Flag
		retn			; Return Near from Procedure
endp		W1


; =============== S U B	R O U T	I N E =======================================


proc		MOTOR_ON near		; ...
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		and	al, 0F7h	; Logical AND

W3:					; ...
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		sub	ah, ah		; Integer Subtraction
		retn			; Return Near from Procedure
endp		MOTOR_ON


; =============== S U B	R O U T	I N E =======================================


proc		MOTOR_OFF near		; ...
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		or	al, 8		; Logical Inclusive OR
		jmp	short W3	; Jump
endp		MOTOR_OFF


; =============== S U B	R O U T	I N E =======================================


proc		READ_BLOCK near		; ...
		push	bx
		push	cx
		push	si
		mov	si, 7
		call	BEGIN_OP	; Call Procedure

W4:					; ...
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 10h		; Logical AND
		mov	[ds:6Bh], al
		mov	dx, 3F7Ah

W5:					; ...
		test	[byte ptr ds:71h], 80h ; Logical Compare
		jz	short W6	; Jump if Zero (ZF=1)
		jmp	W17		; Jump
; ---------------------------------------------------------------------------

W6:					; ...
		dec	dx		; Decrement by 1
		jnz	short W7	; Jump if Not Zero (ZF=0)
		jmp	W17		; Jump
; ---------------------------------------------------------------------------

W7:					; ...
		call	READ_HALF_BIT	; Call Procedure
		jcxz	short W5	; Jump if CX is	0
		mov	dx, 6F0h
		mov	cx, 200h
		in	al, 21h		; Interrupt controller,	8259A.
		or	al, 1		; Logical Inclusive OR
		out	21h, al		; Interrupt controller,	8259A.

W8:					; ...
		test	[byte ptr ds:71h], 80h ; Logical Compare
		jnz	short W17	; Jump if Not Zero (ZF=0)
		push	cx
		call	READ_HALF_BIT	; Call Procedure
		or	cx, cx		; Logical Inclusive OR
		pop	cx
		jz	short W4	; Jump if Zero (ZF=1)
		cmp	dx, bx		; Compare Two Operands
		jcxz	short W9	; Jump if CX is	0
		jnb	short W4	; Jump if Not Below (CF=0)
		loop	W8		; Loop while CX	!= 0

W9:					; ...
		jb	short W8	; Jump if Below	(CF=1)
		call	READ_HALF_BIT	; Call Procedure
		call	READ_BYTE	; Call Procedure
		cmp	al, 16h		; Compare Two Operands
		jnz	short W16	; Jump if Not Zero (ZF=0)
		pop	si
		pop	cx
		pop	bx
		push	cx

W10:					; ...
		mov	[word ptr ds:69h], 0FFFFh
		mov	dx, 100h

W11:					; ...
		test	[byte ptr ds:71h], 80h ; Logical Compare
		jnz	short W13	; Jump if Not Zero (ZF=0)
		call	READ_BYTE	; Call Procedure
		jb	short W13	; Jump if Below	(CF=1)
		jcxz	short W12	; Jump if CX is	0
		mov	[es:bx], al
		inc	bx		; Increment by 1
		dec	cx		; Decrement by 1

W12:					; ...
		dec	dx		; Decrement by 1
		jg	short W11	; Jump if Greater (ZF=0	& SF=OF)
		call	READ_BYTE	; Call Procedure
		call	READ_BYTE	; Call Procedure
		sub	ah, ah		; Integer Subtraction
		cmp	[word ptr ds:69h], 1D0Fh ; Compare Two Operands
		jnz	short W14	; Jump if Not Zero (ZF=0)
		jcxz	short W15	; Jump if CX is	0
		jmp	short W10	; Jump
; ---------------------------------------------------------------------------

W13:					; ...
		mov	ah, 1

W14:					; ...
		inc	ah		; Increment by 1

W15:					; ...
		pop	dx
		sub	dx, cx		; Integer Subtraction
		push	ax
		test	ah, 3		; Logical Compare
		jnz	short W18	; Jump if Not Zero (ZF=0)
		call	READ_BYTE	; Call Procedure
		jmp	short W18	; Jump
; ---------------------------------------------------------------------------

W16:					; ...
		dec	si		; Decrement by 1
		jz	short W17	; Jump if Zero (ZF=1)
		jmp	W4		; Jump
; ---------------------------------------------------------------------------

W17:					; ...
		pop	si		; ;------ NO DATA FROM CASSETTE	ERROR, I.E. TIMEOUT
		pop	cx
		pop	bx
		sub	dx, dx		; Integer Subtraction
		mov	ah, 4
		push	ax

W18:					; ...
		in	al, 21h		; Interrupt controller,	8259A.
		and	al, 0FEh	; Logical AND
		out	21h, al		; Interrupt controller,	8259A.
		call	MOTOR_OFF	; Call Procedure
		pop	ax
		cmp	ah, 1		; Compare Two Operands
		cmc			; Complement Carry Flag
		retn			; Return Near from Procedure
endp		READ_BLOCK


; =============== S U B	R O U T	I N E =======================================


proc		READ_BYTE near		; ...
		push	bx
		push	cx
		mov	cl, 8

W19:					; ...
		push	cx
		call	READ_HALF_BIT	; Call Procedure
		jcxz	short W21	; Jump if CX is	0
		push	bx
		call	READ_HALF_BIT	; Call Procedure
		pop	ax
		jcxz	short W21	; Jump if CX is	0
		add	bx, ax		; Add
		cmp	bx, 0DE0h	; Compare Two Operands
		cmc			; Complement Carry Flag
		lahf			; Load Flags into AH Register
		pop	cx
		rcl	ch, 1		; Rotate Through Carry Left
		sahf			; Store	AH into	Flags Register
		call	CRC_GEN		; Call Procedure
		dec	cl		; Decrement by 1
		jnz	short W19	; Jump if Not Zero (ZF=0)
		mov	al, ch
		clc			; Clear	Carry Flag

W20:					; ...
		pop	cx
		pop	bx
		retn			; Return Near from Procedure
; ---------------------------------------------------------------------------

W21:					; ...
		pop	cx
		stc			; Set Carry Flag
		jmp	short W20	; Jump
endp		READ_BYTE


; =============== S U B	R O U T	I N E =======================================


proc		READ_HALF_BIT near	; ...
		mov	cx, 0C8h
		mov	ah, [ds:6Bh]

W22:					; ...
		call	RD_C		; Call Procedure
		nop			; No Operation
		nop			; No Operation
		nop			; No Operation
		loope	W22		; Loop while rCX != 0 and ZF=1
		mov	[ds:6Bh], al
		mov	al, 0
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		in	al, 40h		; Timer	8253-5 (AT: 8254.2).
		mov	ah, al
		in	al, 40h		; Timer	8253-5 (AT: 8254.2).
		xchg	al, ah		; Exchange Register/Memory with	Register
		mov	bx, [ds:67h]
		sub	bx, ax		; Integer Subtraction
		mov	[ds:67h], ax
		retn			; Return Near from Procedure
endp		READ_HALF_BIT


; =============== S U B	R O U T	I N E =======================================


proc		WRITE_BLOCK near	; ...
		push	bx
		push	cx
		in	al, 61h		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		and	al, 0FDh	; Logical AND
		or	al, 1		; Logical Inclusive OR
		out	61h, al		; PC/XT	PPI port B bits:
					; 0: Tmr 2 gate	��� OR	03H=spkr ON
					; 1: Tmr 2 data	ͼ  AND	0fcH=spkr OFF
					; 3: 1=read high switches
					; 4: 0=enable RAM parity checking
					; 5: 0=enable I/O channel check
					; 6: 0=hold keyboard clock low
					; 7: 0=enable kbrd
		mov	al, 0B6h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		call	BEGIN_OP	; ; START MOTOR	AND DELAY
		mov	ax, 2368
		call	w31		; ;SET CX FOR LEADER BYTE COUNT
		mov	cx, 800h

W23:					; ...
		stc			; Set Carry Flag
		call	WRITE_BIT	; Call Procedure
		loop	W23		; Loop while CX	!= 0
		clc			; Clear	Carry Flag
		call	WRITE_BIT	; Call Procedure
		pop	cx
		pop	bx
		mov	al, 16h
		call	WRITE_BYTE	; Call Procedure

WR_BLOCK:				; ...
		mov	[word ptr ds:69h], 0FFFFh
		mov	dx, 100h

W24:					; ...
		mov	al, [es:bx]
		call	WRITE_BYTE	; Call Procedure
		jcxz	short W25	; Jump if CX is	0
		inc	bx		; Increment by 1
		dec	cx		; Decrement by 1

W25:					; ...
		dec	dx		; Decrement by 1
		jg	short W24	; Jump if Greater (ZF=0	& SF=OF)
		mov	ax, [ds:69h]	; ;------------------- WRITE CRC --------------
					; ;  WRITE 1'S COMPLEMENT OF CRC REG TO CASSETTE
					; ;  WHICH IS CHECKED FOR CORRECTNESS WHEN THE BLOCK IS	READ
					; ;
					; ;  REG AX IS MODIFIED
					; ;------------------------------------------
		not	ax		; One's Complement Negation
		push	ax
		xchg	ah, al		; Exchange Register/Memory with	Register
		call	WRITE_BYTE	; Call Procedure
		pop	ax
		call	WRITE_BYTE	; Call Procedure

W25_1:					; Logical Inclusive OR
		or	cx, cx
		jnz	short WR_BLOCK	; Jump if Not Zero (ZF=0)
		push	cx
		mov	cx, 20h

W26:					; ...
		stc			; Set Carry Flag
		call	WRITE_BIT	; Call Procedure
		loop	W26		; Loop while CX	!= 0
		pop	cx
		mov	al, 0B0h
		out	43h, al		; Timer	8253-5 (AT: 8254.2).
		mov	ax, 1
		call	w31		; Call Procedure
		call	MOTOR_OFF	; Call Procedure
		sub	ax, ax		; Integer Subtraction
		retn			; Return Near from Procedure
endp		WRITE_BLOCK


; =============== S U B	R O U T	I N E =======================================


proc		WRITE_BYTE near		; ...
		push	cx
		push	ax
		mov	ch, al
		mov	cl, 8

W27:					; ...
		rcl	ch, 1		; Rotate Through Carry Left
		pushf			; Push Flags Register onto the Stack
		call	WRITE_BIT	; Call Procedure
		popf			; Pop Stack into Flags Register
		call	CRC_GEN		; ;COMPUTE CRC ON DATA BIT
		dec	cl		; Decrement by 1
		jnz	short W27	; Jump if Not Zero (ZF=0)
		pop	ax
		pop	cx
		retn			; Return Near from Procedure
endp		WRITE_BYTE


; =============== S U B	R O U T	I N E =======================================


proc		WRITE_BIT near		; ...
		mov	ax, 2368	; ; SET	AX TO NOMINAL ONE SIZE
		jb	short W28	; ; JUMP IF ONE	BIT
		mov	ax, 1184	; ; NO,	SET TO NOMINAL ZERO SIZE

W28:					; ...
		push	ax

W29:					; ...
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 20h		; Logical AND
		jz	short W29	; Jump if Zero (ZF=1)

W30:					; ...
		in	al, 62h		; PC/XT	PPI port C. Bits:
					; 0-3: values of DIP switches
					; 5: 1=Timer 2 channel out
					; 6: 1=I/O channel check
					; 7: 1=RAM parity check	error occurred.
		and	al, 20h		; Logical AND
		jnz	short W30	; Jump if Not Zero (ZF=0)
		pop	ax
endp		WRITE_BIT ; sp-analysis	failed


; =============== S U B	R O U T	I N E =======================================


proc		w31 near		; ...
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		mov	al, ah
		out	42h, al		; Timer	8253-5 (AT: 8254.2).
		retn			; Return Near from Procedure
endp		w31


; =============== S U B	R O U T	I N E =======================================


proc		CRC_GEN	near		; ...
		mov	ax, [ds:69h]
		rcr	ax, 1		; Rotate Through Carry Right
		rcl	ax, 1		; Rotate Through Carry Left
		clc			; Clear	Carry Flag
		jno	short W32	; Jump if Not Overflow (OF=0)
		xor	ax, 810h	; Logical Exclusive OR
		stc			; Set Carry Flag

W32:					; ...
		rcl	ax, 1		; Rotate Through Carry Left
		mov	[ds:69h], ax
		retn			; Return Near from Procedure
endp		CRC_GEN


; =============== S U B	R O U T	I N E =======================================


proc		BEGIN_OP near		; ...
		call	MOTOR_ON	; Call Procedure
		mov	bl, 42h

W33:					; ...
		mov	cx, 700h

W34:					; ...
		loop	W34		; Loop while CX	!= 0
		dec	bl		; Decrement by 1
		jnz	short W33	; Jump if Not Zero (ZF=0)
		retn			; Return Near from Procedure
endp		BEGIN_OP

; ---------------------------------------------------------------------------
CRT_CHAR_GEN	db 8 dup(0), 7Eh, 81h, 0A5h, 81h, 0BDh,	99h, 81h, 2 dup(7Eh) ; ...
		db 0FFh, 0DBh, 0FFh, 0C3h, 0E7h, 0FFh, 7Eh, 6Ch, 3 dup(0FEh)
		db 7Ch,	38h, 10h, 0, 10h, 38h, 7Ch, 0FEh, 7Ch, 38h, 10h
		db 0, 38h, 7Ch,	38h, 2 dup(0FEh), 7Ch, 38h, 7Ch, 2 dup(10h)
		db 38h,	7Ch, 0FEh, 7Ch,	38h, 7Ch, 2 dup(0), 18h, 2 dup(3Ch)
		db 18h,	2 dup(0), 2 dup(0FFh), 0E7h, 2 dup(0C3h), 0E7h
		db 2 dup(0FFh),	0, 3Ch,	66h, 2 dup(42h), 66h, 3Ch, 0, 0FFh
		db 0C3h, 99h, 2	dup(0BDh), 99h,	0C3h, 0FFh, 0Fh, 7, 0Fh
		db 7Dh,	3 dup(0CCh), 78h, 3Ch, 3 dup(66h), 3Ch,	18h, 7Eh
		db 18h,	3Fh, 33h, 3Fh, 2 dup(30h), 70h,	0F0h, 0E0h, 7Fh
		db 63h,	7Fh, 2 dup(63h), 67h, 0E6h, 0C0h, 99h, 5Ah, 3Ch
		db 2 dup(0E7h),	3Ch, 5Ah, 99h, 80h, 0E0h, 0F8h,	0FEh, 0F8h
		db 0E0h, 80h, 0, 2, 0Eh, 3Eh, 0FEh, 3Eh, 0Eh, 2, 0, 18h
		db 3Ch,	7Eh, 2 dup(18h), 7Eh, 3Ch, 18h,	5 dup(66h), 0
		db 66h,	0, 7Fh,	2 dup(0DBh), 7Bh, 3 dup(1Bh), 0, 3Eh, 63h
		db 38h,	2 dup(6Ch), 38h, 0CCh, 78h, 4 dup(0), 3	dup(7Eh)
		db 0, 18h, 3Ch,	7Eh, 18h, 7Eh, 3Ch, 18h, 0FFh, 18h, 3Ch
		db 7Eh,	4 dup(18h), 0, 4 dup(18h), 7Eh,	3Ch, 18h, 2 dup(0)
		db 18h,	0Ch, 0FEh, 0Ch,	18h, 3 dup(0), 30h, 60h, 0FEh
		db 60h,	30h, 4 dup(0), 3 dup(0C0h), 0FEh, 3 dup(0), 24h
		db 66h,	0FFh, 66h, 24h,	3 dup(0), 18h, 3Ch, 7Eh, 2 dup(0FFh)
		db 3 dup(0), 2 dup(0FFh), 7Eh, 3Ch, 18h, 0Ah dup(0), 30h
		db 2 dup(78h), 2 dup(30h), 0, 30h, 0, 3	dup(6Ch), 5 dup(0)
		db 2 dup(6Ch), 0FEh, 6Ch, 0FEh,	2 dup(6Ch), 0, 30h, 7Ch
		db 0C0h, 78h, 0Ch, 0F8h, 30h, 2	dup(0),	0C6h, 0CCh, 18h
		db 30h,	66h, 0C6h, 0, 38h, 6Ch,	38h, 76h, 0DCh,	0CCh, 76h
		db 0, 2	dup(60h), 0C0h,	5 dup(0), 18h, 30h, 3 dup(60h)
		db 30h,	18h, 0,	60h, 30h, 3 dup(18h), 30h, 60h,	2 dup(0)
		db 66h,	3Ch, 0FFh, 3Ch,	66h, 3 dup(0), 2 dup(30h), 0FCh
		db 2 dup(30h), 7 dup(0), 2 dup(30h), 60h, 3 dup(0), 0FCh
		db 9 dup(0), 2 dup(30h), 0, 6, 0Ch, 18h, 30h, 60h, 0C0h
		db 80h,	0, 7Ch,	0C6h, 0CEh, 0DEh, 0F6h,	0E6h, 7Ch, 0, 30h
		db 70h,	4 dup(30h), 0FCh, 0, 78h, 0CCh,	0Ch, 38h, 60h
		db 0CCh, 0FCh, 0, 78h, 0CCh, 0Ch, 38h, 0Ch, 0CCh, 78h
		db 0, 1Ch, 3Ch,	6Ch, 0CCh, 0FEh, 0Ch, 1Eh, 0, 0FCh, 0C0h
		db 0F8h, 2 dup(0Ch), 0CCh, 78h,	0, 38h,	60h, 0C0h, 0F8h
		db 2 dup(0CCh),	78h, 0,	0FCh, 0CCh, 0Ch, 18h, 3	dup(30h)
		db 0, 78h, 2 dup(0CCh),	78h, 2 dup(0CCh), 78h, 0, 78h
		db 2 dup(0CCh),	7Ch, 0Ch, 18h, 70h, 2 dup(0), 2	dup(30h)
		db 2 dup(0), 2 dup(30h), 2 dup(0), 2 dup(30h), 2 dup(0)
		db 2 dup(30h), 60h, 18h, 30h, 60h, 0C0h, 60h, 30h, 18h
		db 3 dup(0), 0FCh, 2 dup(0), 0FCh, 2 dup(0), 60h, 30h
		db 18h,	0Ch, 18h, 30h, 60h, 0, 78h, 0CCh, 0Ch, 18h, 30h
		db 0, 30h, 0, 7Ch, 0C6h, 3 dup(0DEh), 0C0h, 78h, 0, 30h
		db 78h,	2 dup(0CCh), 0FCh, 2 dup(0CCh),	0, 0FCh, 2 dup(66h)
		db 7Ch,	2 dup(66h), 0FCh, 0, 3Ch, 66h, 3 dup(0C0h), 66h
		db 3Ch,	0, 0F8h, 6Ch, 3	dup(66h), 6Ch, 0F8h, 0,	0FEh, 62h
		db 68h,	78h, 68h, 62h, 0FEh, 0,	0FEh, 62h, 68h,	78h, 68h
		db 60h,	0F0h, 0, 3Ch, 66h, 2 dup(0C0h),	0CEh, 66h, 3Eh
		db 0, 3	dup(0CCh), 0FCh, 3 dup(0CCh), 0, 78h, 5	dup(30h)
		db 78h,	0, 1Eh,	3 dup(0Ch), 2 dup(0CCh), 78h, 0, 0E6h
		db 66h,	6Ch, 78h, 6Ch, 66h, 0E6h, 0, 0F0h, 3 dup(60h)
		db 62h,	66h, 0FEh, 0, 0C6h, 0EEh, 2 dup(0FEh), 0D6h, 2 dup(0C6h)
		db 0, 0C6h, 0E6h, 0F6h,	0DEh, 0CEh, 2 dup(0C6h), 0, 38h
		db 6Ch,	3 dup(0C6h), 6Ch, 38h, 0, 0FCh,	2 dup(66h), 7Ch
		db 2 dup(60h), 0F0h, 0,	78h, 3 dup(0CCh), 0DCh,	78h, 1Ch
		db 0, 0FCh, 2 dup(66h),	7Ch, 6Ch, 66h, 0E6h, 0,	78h, 0CCh
		db 0E0h, 70h, 1Ch, 0CCh, 78h, 0, 0FCh, 0B4h, 4 dup(30h)
		db 78h,	0, 6 dup(0CCh),	0FCh, 0, 5 dup(0CCh), 78h, 30h
		db 0, 3	dup(0C6h), 0D6h, 0FEh, 0EEh, 0C6h, 0, 2	dup(0C6h)
		db 6Ch,	2 dup(38h), 6Ch, 0C6h, 0, 3 dup(0CCh), 78h, 2 dup(30h)
		db 78h,	0, 0FEh, 0C6h, 8Ch, 18h, 32h, 66h, 0FEh, 0, 78h
		db 5 dup(60h), 78h, 0, 0C0h, 60h, 30h, 18h, 0Ch, 6, 2
		db 0, 78h, 5 dup(18h), 78h, 0, 10h, 38h, 6Ch, 0C6h, 0Bh	dup(0)
		db 0FFh, 2 dup(30h), 18h, 7 dup(0), 78h, 0Ch, 7Ch, 0CCh
		db 76h,	0, 0E0h, 2 dup(60h), 7Ch, 2 dup(66h), 0DCh, 3 dup(0)
		db 78h,	0CCh, 0C0h, 0CCh, 78h, 0, 1Ch, 2 dup(0Ch), 7Ch
		db 2 dup(0CCh),	76h, 3 dup(0), 78h, 0CCh, 0FCh,	0C0h, 78h
		db 0, 38h, 6Ch,	60h, 0F0h, 2 dup(60h), 0F0h, 3 dup(0)
		db 76h,	2 dup(0CCh), 7Ch, 0Ch, 0F8h, 0E0h, 60h,	6Ch, 76h
		db 2 dup(66h), 0E6h, 0,	30h, 0,	70h, 3 dup(30h), 78h, 0
		db 0Ch,	0, 3 dup(0Ch), 2 dup(0CCh), 78h, 0E0h, 60h, 66h
		db 6Ch,	78h, 6Ch, 0E6h,	0, 70h,	5 dup(30h), 78h, 3 dup(0)
		db 0CCh, 2 dup(0FEh), 0D6h, 0C6h, 3 dup(0), 0F8h, 4 dup(0CCh)
		db 3 dup(0), 78h, 3 dup(0CCh), 78h, 3 dup(0), 0DCh, 2 dup(66h)
		db 7Ch,	60h, 0F0h, 2 dup(0), 76h, 2 dup(0CCh), 7Ch, 0Ch
		db 1Eh,	2 dup(0), 0DCh,	76h, 66h, 60h, 0F0h, 3 dup(0)
		db 7Ch,	0C0h, 78h, 0Ch,	0F8h, 0, 10h, 30h, 7Ch,	2 dup(30h)
		db 34h,	18h, 3 dup(0), 4 dup(0CCh), 76h, 3 dup(0), 3 dup(0CCh)
		db 78h,	30h, 3 dup(0), 0C6h, 0D6h, 2 dup(0FEh),	6Ch, 3 dup(0)
		db 0C6h, 6Ch, 38h, 6Ch,	0C6h, 3	dup(0),	3 dup(0CCh), 7Ch
		db 0Ch,	0F8h, 2	dup(0),	0FCh, 98h, 30h,	64h, 0FCh, 0, 1Ch
		db 2 dup(30h), 0E0h, 2 dup(30h), 1Ch, 0, 3 dup(18h), 0
		db 3 dup(18h), 0, 0E0h,	2 dup(30h), 1Ch, 2 dup(30h), 0E0h
		db 0, 76h, 0DCh, 7 dup(0), 10h,	38h, 6Ch, 2 dup(0C6h)
		db 0FEh, 0
; ---------------------------------------------------------------------------

TIME_OF_DAY:				; ...
		sti			; ;--- INT 1A -------------------------------
					; ; TIME_OF_DAY
					; ;  THIS ROUTINE ALLOWS THE CLOCK TO BE SET/READ
					; ;
					; ; INPUT
					; ;   (AH) = 0	  READ THE CURRENT CLOCK SETTING
					; ;	  RETURNS CX = HIGH PORTION OF COUNT
					; ;	      DX = LOW PORTION OF COUNT
					; ;	      AL = 0 IF	TIMER HAS NOT PASSED 24	HOURS SINCE LAST READ
					; ;		 <>0 IF	ON ANOTHER DAY
					; ;   (AH) = 1	  SET THE CURRENT CLOCK
					; ;   CX = HIGH	PORTION	OF COUNT
					; ;   DX = LOW PORTION OF COUNT
					; ; NOTE: COUNTS OCCUR AT THE RATE OF 1193180/65536 COUNTS/SEC
					; ;   (OR ABOUT	18.2 PER SECOND	-- SEE EQUATES BELOW)
					; ;--------------------------------------------
		push	ds
		push	ax
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		pop	ax
		or	ah, ah		; Logical Inclusive OR
		jz	short T2	; Jump if Zero (ZF=1)
		dec	ah		; Decrement by 1
		jz	short T3	; Jump if Zero (ZF=1)

T1:					; ...
		sti			; Set Interrupt	Flag
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
; ---------------------------------------------------------------------------

T2:					; ...
		cli			; Clear	Interrupt Flag
		mov	al, [ds:70h]
		mov	[byte ptr ds:70h], 0
		mov	cx, [ds:6Eh]
		mov	dx, [ds:6Ch]
		jmp	short T1	; Jump
; ---------------------------------------------------------------------------

T3:					; ...
		cli			; Clear	Interrupt Flag
		mov	[ds:6Ch], dx
		mov	[ds:6Eh], cx
		mov	[byte ptr ds:70h], 0
		jmp	short T1	; Jump

; =============== S U B	R O U T	I N E =======================================


proc		TIMER_INT far		; ...
		sti			; ;--------------------------------------------
					; ; THIS ROUTINE HANDLES THE TIMER INTERRUPT FROM
					; ; CHANNEL 0 OF THE 8253 TIMER. INPUT FREQUENCY IS 1.19318 MHZ
					; ; AND	THE DIVISOR IS 65536, RESULTING	IN APPROX. 18.2	INTERRUPTS
					; ; EVERY SECOND.
					; ;
					; ; THE	INTERRUPT HANDLER MAINTAINS A COUNT OF INTERRUPTS SINCE	POWER
					; ;  ON	TIME, WHICH MAY	BE USED	TO ESTABLISH TIME OF DAY.
					; ; THE	INTERRUPT HANDLER ALSO DECREMENTS THE MOTOR CONTROL COUNT
					; ;  OF	THE DISKETTE, AND WHEN IT EXPIRES, WILL	TURN OFF THE DISKETTE
					; ;  MOTOR, AND	RESET THE MOTOR	RUNNING	FLAGS
					; ; THE	INTERRUPT HANDLER WILL ALSO INVOKE A USER ROUTINE THROUGH INTERRUPT
					; ;  1CH AT EVERY TIME TICK.  THE USER MUST CODE A ROUTINE AND PLACE THE
					; ;  CORRECT ADDRESS IN	THE VECTOR TABLE.
					; ;--------------------------------------------
		push	ds
		push	ax
		push	dx
		mov	ax, 40h
		mov	ds, ax
		assume ds:nothing
		inc	[word ptr ds:6Ch] ; Increment by 1
		jnz	short T4	; Jump if Not Zero (ZF=0)
		inc	[word ptr ds:6Eh] ; Increment by 1

T4:					; ...
		cmp	[word ptr ds:6Eh], 18h ; Compare Two Operands
		jnz	short T5	; Jump if Not Zero (ZF=0)
		cmp	[word ptr ds:6Ch], 0B0h	; Compare Two Operands
		jnz	short T5	; Jump if Not Zero (ZF=0)
		mov	[word ptr ds:6Eh], 0
		mov	[word ptr ds:6Ch], 0
		mov	[byte ptr ds:70h], 1

T5:					; ...
		dec	[byte ptr ds:40h] ; Decrement by 1
		jnz	short T6	; Jump if Not Zero (ZF=0)
		and	[byte ptr ds:3Fh], 0F0h	; Logical AND
		mov	al, 0Ch
		mov	dx, 3F2h
		out	dx, al		; Floppy: digital output reg bits:
					; 0-1: Drive to	select 0-3 (AT:	bit 1 not used)
					; 2:   0=reset diskette	controller; 1=enable controller
					; 3:   1=enable	diskette DMA and interrupts
					; 4-7: drive motor enable.  Set	bits to	turn drive ON.
					;

T6:					; ...
		int	1Ch		; CLOCK	TICK
		mov	al, 20h
		out	20h, al		; Interrupt controller,	8259A.
		pop	dx
		pop	ax
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
endp		TIMER_INT

; ---------------------------------------------------------------------------
VECTOR_TABLE	dw offset TIMER_INT	; ;--------------------------------------------
					; ; THESE ARE THE VECTORS WHICH	ARE MOVED INTO
					; ;  THE 8086 INTERRUPT	AREA DURING POWER ON
					; ;--------------------------------------------
		dw 0F000h
		dw offset KB_INT
		dw 0F000h
		dd 0			; ; INTERRUPT A
		dd 0			; ; INTERRUPT B
		dd 0			; ; INTERRUPT C
		dd 0			; ; INTERRUPT D
		dw offset DISK_INT
		dw 0F000h
		dd 0			; ; INTERRUPT F
VECTOR_TABLE32	dw offset VIDEO_IO	; ...
					; ; INTERRUPT 10H
		dw 0F000h
		dw offset EQUIPMENT	; ; INTERRUPT 11H
		dw 0F000h
		dw offset MEMORY_SIZE_DETERMINE	; ; INT	12H
		dw 0F000h
		dw offset DISKETTE_IO	; ; INTERRUPT 13H
		dw 0F000h
		dw offset RS232_IO	; ; INTERRUPT 14H
		dw 0F000h
		dw offset CASSETTE_IO	; ; INTERRUPT 15h
		dw 0F000h
		dw offset KEYBOARD_IO	; ; INTERRUPT 16H
		dw 0F000h
		dw offset PRINTER_IO	; ; INTERRUPT 17H
		dw 0F000h
		dw 00000h		; ; INTERRUPT 18H
		dw 0F600h		;   ROM	BASIC ENTRY POINT
		dw offset BOOT_STRAP	; ; INTERRUPT 19H
		dw 0F000h
		dw offset TIME_OF_DAY	; ; INTERRUPT 1AH -- TIME OF DAY
		dw 0F000h
		dw offset DUMMY_RETURN	; ; INTERRUPT 1BH -- KEYBOARD BREAK ADDR
		dw 0F000h
		dw offset DUMMY_RETURN	; ; INTERRUPT 1CH -- TIMER BREAK ADDR
		dw 0F000h
		dw offset VIDEO_PARMS	; ; INTERRUPT 1DH -- VIDEO PARAMETERS
		dw 0F000h
		dw offset DISK_BASE	; ; INTERRUPT 1EH -- DISK PARMS
		dw 0F000h
		dw 0			; ; INTERRUPT 1FH -- POINTER TO	VIDEO EXT
		dw 0F400h
; ---------------------------------------------------------------------------

DUMMY_RETURN:				; ...
		iret			; Interrupt Return

; =============== S U B	R O U T	I N E =======================================


proc		PRINT_SCREEN far	; ...
		sti			; ;-- INT 5 ----------------------------------
					; ;   THIS LOGIC WILL BE INVOKED BY INTERRUPT 05H TO PRINT
					; ;   THE SCREEN. THE CURSOR POSITION AT THE TIME THIS ROUTINE
					; ;   IS INVOKED WILL BE SAVED AND RESTORED UPON COMPLETION. THE
					; ;   ROUTINE IS INTENDED TO RUN WITH INTERRUPTS ENABLED.
					; ;   IF A SUBSEQUENT 'PRINT SCREEN KEY IS DEPRESSED DURING THE
					; ;   TIME THIS	ROUTINE	IS PRINTING IT WILL BE IGNORED.
					; ;   ADDRESS 50:0 CONTAINS THE	STATUS OF THE PRINT SCREEN:
					; ;
					; ;   50:0    =0  EITHER PRINT SCREEN HAS NOT BEEN CALLED
					; ;	      OR UPON RETURN FROM A CALL THIS INDICATES
					; ;	      A	SUCCESSFUL OPERATION.
					; ;
					; ;	  =1  PRINT SCREEN IS IN PROGRESS
					; ;
					; ;	  =377	  ERROR	ENCOUNTERED DURING PRINTING
					; ;--------------------------------------------
		push	ds
		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax, 50h
		mov	ds, ax
		assume ds:nothing
		cmp	[byte ptr ds:0], 1 ; Compare Two Operands
		jz	short ERR10	; Jump if Zero (ZF=1)
		mov	[byte ptr ds:0], 1
		mov	ah, 0Fh
		int	10h		; - VIDEO - GET	CURRENT	VIDEO MODE
					; Return: AH = number of columns on screen
					; AL = current video mode
					; BH = current active display page
		mov	cl, ah
		mov	ch, 19h
		call	CRLF		; Call Procedure
		push	cx
		mov	ah, 3
		int	10h		; - VIDEO - READ CURSOR	POSITION
					; BH = page number
					; Return: DH,DL	= row,column, CH = cursor start	line, CL = cursor end line
		pop	cx
		push	dx
		xor	dx, dx		; Logical Exclusive OR

PRI10:					; ...
		mov	ah, 2
		int	10h		; - VIDEO - SET	CURSOR POSITION
					; DH,DL	= row, column (0,0 = upper left)
					; BH = page number
		mov	ah, 8
		int	10h		; - VIDEO - READ ATTRIBUTES/CHARACTER AT CURSOR	POSITION
					; BH = display page
					; Return: AL = character
					; AH = attribute of character (alpha modes)
		or	al, al		; Logical Inclusive OR
		jnz	short PRI15	; Jump if Not Zero (ZF=0)
		mov	al, 20h

PRI15:					; ...
		push	dx
		xor	dx, dx		; Logical Exclusive OR
		xor	ah, ah		; Logical Exclusive OR
		int	17h		; PRINTER - OUTPUT CHARACTER
					; AL = character, DX = printer port (0-3)
					; Return: AH = status bits
		pop	dx
		test	ah, 29h		; Logical Compare
		jnz	short PRI20	; Jump if Not Zero (ZF=0)
		inc	dl		; Increment by 1
		cmp	cl, dl		; Compare Two Operands
		jnz	short PRI10	; Jump if Not Zero (ZF=0)
		xor	dl, dl		; Logical Exclusive OR
		mov	ah, dl
		push	dx
		call	CRLF		; Call Procedure
		pop	dx
		inc	dh		; Increment by 1
		cmp	ch, dh		; Compare Two Operands
		jnz	short PRI10	; Jump if Not Zero (ZF=0)
		pop	dx
		mov	ah, 2
		int	10h		; - VIDEO -
		mov	[byte ptr ds:0], 0
		jmp	short ERR10	; Jump
; ---------------------------------------------------------------------------

PRI20:					; ...
		pop	dx
		mov	ah, 2
		int	10h		; - VIDEO - SET	CURSOR POSITION
					; DH,DL	= row, column (0,0 = upper left)
					; BH = page number
		mov	[byte ptr ds:0], 0FFh

ERR10:					; ...
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		pop	ds
		assume ds:nothing
		iret			; Interrupt Return
endp		PRINT_SCREEN


; =============== S U B	R O U T	I N E =======================================


proc		CRLF near		; ...
		xor	dx, dx		; Logical Exclusive OR
		xor	ah, ah		; Logical Exclusive OR
		mov	al, 0Ah
		int	17h		; PRINTER - OUTPUT CHARACTER
					; AL = character, DX = printer port (0-3)
					; Return: AH = status bits
		xor	ah, ah		; Logical Exclusive OR
		mov	al, 0Dh
		int	17h		; PRINTER - OUTPUT CHARACTER
					; AL = character, DX = printer port (0-3)
					; Return: AH = status bits
		retn			; Return Near from Procedure
endp		CRLF

; ---------------------------------------------------------------------------
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
		db    0
; ---------------------------------------------------------------------------
		jmp	far ptr	RESET	; Jump
; ---------------------------------------------------------------------------
a311289		db '31/12/89'           ; ; RELEASE MARKER
		db 0FFh
		db 0FEh
		db    0
ends		F000


		end
