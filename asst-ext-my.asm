; +-------------------------------------------------------------------------+
; |   ASSISTENT EXTERNAL LOGO PROCEDURE          						    |
; |   decompilation:  Ruslan Staritsyn, 2022                                |
; +-------------------------------------------------------------------------+
;F490:0000  E9 36 07            JMPN  0739
						JMPN  0739

; LOGO DATA ...
 
DB FF DUP(738)

				        MOV   AX, CS
				        MOV   ES, AX
				        MOV   DS, AX
				        MOV   AH, 00
				        MOV   AL, 04
				        INT   10
				        MOV   AH, 0B
				        MOV   BX, 0001
				        INT   10
				        MOV   AH, 0B
				        MOV   BX, 0100
				        INT   10
				        MOV   BX, 2FA0
				        PUSH  BX
				        MOV   BX, 0FA0
				        PUSH  BX
					  	JMPN  L07E2
						JMPN  L0874
L0761:
						JMPN  08A4
L0764:
						MOV   CH, 2A
L0766:
						POP   SI
						MOV   BX, SI
						CALL  08D0
						POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  08D0
				        CALL  0812
				        CALL  086A
				        DEC   CH
				        CMP   CH, 00
				        JNZ   0766
				        MOV   AX, EEEE
				        CALL  086D
				        MOV   BL, 02
				        MOV   DX, 0043
				        MOV   AL, B6
				        OUT   DX, AL
				        MOV   DX, 0042
				        MOV   AX, 0533
				        OUT   DX, AL
				        MOV   AL, AH
				        OUT   DX, AL
				        MOV   DX, 0061
				        IN    AL, DX
				        MOV   AH, AL
				        OR    AL, 03
				        OUT   DX, AL
				        SUB   CX, CX
L07A2:		     
				 		LOOP  07A2
				        DEC   BL
				        JNZ   07A2
				        MOV   AL, AH
				        OUT   DX, AL
				        MOV   AX, EEEE
				        CALL  086D
L07B1:		     
				 		POP   DI
				        POP   SI
				        PUSH  SI
				        PUSH  DI
				        MOV   CL, 50
L07B7:		     
				 		MOV   AL, 00
				        MOV   BYTE [ES:DI], AL
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        INC   DI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   07B7
				        CMP   DI, 0FF0
				        JZ    07D9
				        CALL  083E
				        MOV   AX, 0A55
				        CALL  086D
				        JMPS  07B1
L07D9:		     
				 		MOV   AH, 00
				        MOV   AL, 01
				        INT   10
				        POP   AX
				        POP   AX
				        RETF
				 
L07E2:		     
				 		MOV   DI, 0003
				        MOV   CX, 0008
				        POP   SI
				        PUSH  SI
				        MOV   AX, B800
				        MOV   ES, AX
				        CALL  08FE
				        CALL  0940
				        CALL  091F
				        INC   DI
				        POP   BX
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  08FE
				        CALL  0940
				        CALL  091F
				        INC   DI
				        CALL  0812
				        CALL  086A
				        LOOPZ 07E8
				        JMPN  075E
L0812:
						POP   BX
				        POP   SI
				        CMP   SI, 2000
				        JNC   0824
				        ADD   SI, 2000
				        SUB   SI, +50
				        JMPS  0828
				        NOP
				        SUB   SI, 2000
L0828:		 
				 		POP   AX
				        CMP   AX, 2000
				        JNC   0834
				        ADD   AX, 2000
				        JMPS  083A
				        NOP
L0834:		 
				 		SUB   AX, 2000
				        ADD   AX, 0050
L083A:		 
				 		PUSH  AX
				        PUSH  SI
				        PUSH  BX
				        RETN
L083E:		 
				 		POP   SI
				        POP   BX
				        CMP   BX, 2000
				        JNC   084D
				        ADD   BX, 2000
				        JMPS  0854
				        NOP
				        SUB   BX, 2000
				        ADD   BX, +50
L0854:
						POP   AX
						CMP   AX, 2000
						JNC   0863
						ADD   AX, 2000
						SUB   AX, 0050
						JMPS  0866
						NOP
L0863:
						SUB   AX, 2000
L0866:
						PUSH  AX
						PUSH  BX
						PUSH  SI
						RETN
L086A:
						MOV   AX, 15B3
L086D:
						DEC   AX
						CMP   AX, 0000
						JNZ   086D
						RETN
L0874:
						MOV   DH, 0C
				        MOV   DI, 0373
				        MOV   BP, 037F
				        POP   SI
				        MOV   BX, SI
				        CALL  094E
				        ADD   DI, +0C
				        ADD   BP, +0C
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  094E
				        ADD   DI, +0C
				        ADD   BP, +0C
				        CALL  0812
				        CALL  086A
				        DEC   DH
				        CMP   DH, 00
				        JNZ   087C
				        JMPN  0761
L08A4:		 
				 		MOV   DH, 12
				        MOV   DI, 059B
				        MOV   BP, 05A7
L08AC:		 
				 		POP   SI
				        MOV   BX, SI
				        CALL  094E
				        POP   SI
				        PUSH  SI
				        PUSH  BX
				        CALL  08D0
				        ADD   DI, +0C
				        ADD   BP, +0C
				        CALL  0812
				        CALL  086A
				        DEC   DH
				        CMP   DH, 00
				        JNZ   L08CE
				        JMPN  L0764
				        JMPS  L08AC
L08D0:
						MOV   CL, 05
L08D2:
						MOV   AL, 00
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L08D2
				        MOV   CL, 46
L08E1:		 
				 		MOV   AL, AA
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L08E1
				        MOV   CL, 05
L08F0:		 
				 		MOV   AL, 00
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JNZ   L08F0
				        RETN
				        PUSH  CX
				        MOV   CX, 0005
				        MOV   AL, 00
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, +00
				        JNZ   L0904
				        MOV   CX, 0007
				        MOV   AL, AA
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, +00
				        JNZ   L0913
				        POP   CX
				        RETN
				        PUSH  CX
				        MOV   CX, 0009
				        MOV   AL, AA
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, +00
				        JNZ   L0925
				        MOV   CX, 0005
				        MOV   AL, 00
L0934				        
						MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CX
				        CMP   CX, +00
				        JNZ   L0934
				        POP   CX
				        RETN
L0940:		     
				 		MOV   AL, BYTE [DI]
				        CMP   AL, 24
				        JZ    094D
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        INC   DI
				        JMPS  L0940
L094D:		     
				 		RETN
L094E:		     
				 		MOV   CL, BYTE [DS:BP+00]
L0952:		     
				 		MOV   AL, BYTE [DI]
				        CMP   AL, 24
				        JZ    L0969
				        MOV   BYTE [ES:SI], AL
				        INC   SI
				        DEC   CL
				        CMP   CL, 00
				        JZ    L0965
				        JMPS  L0952
L0965:		     
				 		INC   BP
				        INC   DI
				        JMPS  094E
L0969:
						RETN

