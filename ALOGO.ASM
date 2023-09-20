cseg		segment
		LOCALS
		assume	cs:cseg,ds:cseg,ss:cseg
		org	100h

start:	
		push ds
		push es
		push bp
		push si
		push di
		push cx
		push dx
		
		call begin
		
		pop dx
		pop cx
		pop di
		pop si
		pop bp
		pop es
		pop ds
		
		ret
		
;		align 1;

INCLUDE ALOGBIN

begin:
				        MOV   AX, CS
				        MOV   ES, AX
				        MOV   DS, AX
				        MOV   AH, 00
				        MOV   AL, 04
				        INT   10h
				        MOV   AH, 0Bh
				        MOV   BX, 1
				        INT   10h
				        MOV   AH, 0Bh
				        MOV   BX, 0100h
				        INT   10h
				        MOV   BX, 2FA0h ; 8192+4000
				        PUSH  BX
				        MOV   BX, 0FA0h ; 4000 
				        PUSH  BX
						
						JMP  draw_p1 ; L_07E2
L_075E:
						JMP  draw_p2 ; L_0874
L_0761:
						JMP  draw_p3 ; L_08A4
L_0764:
						MOV   CH, 2Ah
L_0766:
						POP   SI
						MOV   BX, SI
						CALL  L_08D0
						POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  L_08D0
				        CALL  L_0812
				        CALL  L_086A
				        DEC   CH
				        CMP   CH, 0
				        JNZ   L_0766
						
				        MOV   AX, 0EEEEh
				        CALL  sm_delay
						
				        MOV   BL, 02
				        MOV   DX, 0043h
				        MOV   AL, 0B6h
				        OUT   DX, AL
				        MOV   DX, 0042h
				        MOV   AX, 0533h
				        OUT   DX, AL
				        MOV   AL, AH
				        OUT   DX, AL
				        MOV   DX, 0061h
				        IN    AL, DX
				        MOV   AH, AL
				        OR    AL, 3
				        OUT   DX, AL
;beep pause						
				        SUB   CX, CX
L_07A2:		     
				 		LOOP  L_07A2
				        DEC   BL
				        JNZ   L_07A2
						
				        MOV   AL, AH
				        OUT   DX, AL
						
				        MOV   AX, 0EEEEh
				        CALL  sm_delay
L_07B1:		     
				 		POP   DI
				        POP   SI
				        PUSH  SI
				        PUSH  DI
				        MOV   CL, 050h
L_07B7:		     
				 		MOV   AL, 0
				        MOV   BYTE PTR ES:[DI], AL
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        INC   DI
				        DEC   CL
				        CMP   CL, 0
				        JNZ   L_07B7
				        CMP   DI, 0FF0h
				        JZ    exit
				        CALL  L_083E
				        MOV   AX, 0A55h
				        CALL  sm_delay
				        JMP  L_07B1
exit: ;L_07D9:		     
				 		MOV   AH, 0
				        MOV   AL, 1
				        INT   10h
				        POP   AX
				        POP   AX
						
				        RET ;; end ; WAS RET FAR
				 
draw_p1: ;L_07E2:		     
				 		MOV   DI, offset logodata ;0103h ; was 3
				        MOV   CX, 8
L_07E8:
				        POP   SI
				        PUSH  SI
				        MOV   AX, 0B800h
				        MOV   ES, AX
				        CALL  L_08FE
				        CALL  L_0940
				        CALL  L_091F
				        INC   DI
				        POP   BX
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  L_08FE
				        CALL  L_0940
				        CALL  L_091F
				        INC   DI
				        CALL  L_0812
				        CALL  L_086A
				        LOOPE  L_07E8
				        JMP   L_075E
L_0812:
						POP   BX
				        POP   SI
				        CMP   SI, 2000h
				        JNC   L_0824
				        ADD   SI, 2000h
				        SUB   SI, 0050h
				        JMP   L_0828
				        
						;db 90h
L_0824:
				        SUB   SI, 2000h
L_0828:		 
				 		POP   AX
				        CMP   AX, 2000h
				        JNC   L_0834
				        ADD   AX, 2000h
				        JMP   L_083A
						;db 90h
L_0834:		 
				 		SUB   AX, 2000h
				        ADD   AX, 0050h
L_083A:		 
				 		PUSH  AX
				        PUSH  SI
				        PUSH  BX
				        RETN
L_083E:		 
				 		POP   SI
				        POP   BX
				        CMP   BX, 2000h
				        JNC   L_084D
				        ADD   BX, 2000h
				        JMP   L_0854
						;db 90h
L_084D:
				        SUB   BX, 2000h
				        ADD   BX, 0050h
L_0854:
						POP   AX
						CMP   AX, 2000h
						JNC   L_0863
						ADD   AX, 2000h
						SUB   AX, 0050h
						JMP   L_0866
						;db 90h
L_0863:
						SUB   AX, 2000h
L_0866:
						PUSH  AX
						PUSH  BX
						PUSH  SI
						RETN
L_086A:
						MOV   AX, 5555 ; =015B3h
sm_delay:
						DEC   AX
						CMP   AX, 0
						JNZ   sm_delay
						RET
draw_p2: ;L_0874:
						MOV   DH, 12 ; 0ch
				        ;MOV   DI, offset logodata + 0370h ; in .com=0473h ; was 373h
						MOV   DI, offset logo_prt2; in .com=0473h ; was 373h
				        MOV   BP, offset logo_prt2 + 12 ; in .com=047Fh ; was 37fh
L_087C:
				        POP   SI
				        MOV   BX, SI
						
				        CALL  L_094E
						
				        ADD   DI, 12
				        ADD   BP, 12
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  L_094E
				        ADD   DI, 12
				        ADD   BP, 12
				        CALL  L_0812
				        CALL  L_086A
				        DEC   DH
				        CMP   DH, 00
				        JNZ   L_087C
				        JMP   L_0761
draw_p3: ;L_08A4:		 
				 		MOV   DH, 012h ; =18
				        MOV   DI, offset logo_prt3 ;logodata+598h; in .com=069Bh ; was 059Bh
				        MOV   BP, offset logo_prt3+12; logodata+598h + 12 ; in .com=06A7h ; was 05A7h
L_08AC:
				 		POP   SI
				        MOV   BX, SI
				        CALL  L_094E
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  L_08D0
				        ADD   DI, 12
				        ADD   BP, 12
				        CALL  L_0812
				        CALL  L_086A
				        DEC   DH
				        CMP   DH, 00
				        JNZ   L_08CE
				        JMP  L_0764
L_08CE:				
				        JMP  L_08AC
L_08D0:
						MOV   CL, 05
L_08D2:
						MOV   AL, 00
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L_08D2
				        MOV   CL, 70 ; 046h
L_08E1:		 
				 		MOV   AL, 0AAh
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L_08E1
				        MOV   CL, 05
L_08F0:		 
				 		MOV   AL, 00
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L_08F0
				        RET
L_08FE:
				        PUSH  CX
				        MOV   CX, 5
				        MOV   AL, 00
L_0904:
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, 0
				        JNZ   L_0904
						
				        MOV   CX, 7
				        MOV   AL, 0AAh
L_0913:
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, 0
				        JNZ   L_0913
				        POP   CX
				        RETN
L_091F:
				        PUSH  CX
				        MOV   CX, 9
				        MOV   AL, 0AAh
L_0925:
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, 0
				        JNZ   L_0925
				        MOV   CX, 5
				        MOV   AL, 00
L_0934:
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, 0
				        JNZ   L_0934
				        POP   CX
				        RETN
L_0940:		     
				 		MOV   AL, BYTE PTR [DI]
				        CMP   AL, 36 ; 24h
				        JZ    L_094D
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        INC   DI
				        JMP  L_0940
L_094D:		     
				 		RETN
						
L_094E:		     
				 		MOV   CL, BYTE PTR DS:[BP+00]
L_0952:		     
				 		MOV   AL, BYTE PTR [DI]
				        CMP   AL, 36 ; 24h
				        JZ    L_0969
				        MOV   BYTE PTR ES:[SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JZ    L_0965
						
				        JMP  L_0952
L_0965:		     
				 		INC   BP
				        INC   DI
				        JMP  L_094E
L_0969:
						RET
						

cseg		ends
		end	start
