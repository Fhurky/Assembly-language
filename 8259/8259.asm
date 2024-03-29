;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Cum Mar 11 2016
; Processor: 8086
; Compiler:  MASM32
;
; Before starting simulation set Internal Memory Size 
; in the 8086 model properties to 0x10000
;====================================================================
STAK    SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK    ENDS

DATA    SEGMENT PARA 'DATA'
MYDAT    DB 5 DUP(0)
DATASAY DW 0
TOPLAM  DW 0
DATASENDSAY DW 0
ALLSENT DB 1
DATA    ENDS

CODE    SEGMENT PARA 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STAK

NEWINT PROC FAR
       IN AL, 7CH
       SHR AL, 1       
       CMP AL, 57D  
       JBE sayi 
       SUB AL, 37H  
       JMP degil 
sayi:  SUB AL, 30H     
degil: 
       MOV BL, 16D         
       CMP DI, 1
       JE BIR
ON:    MUL BL
       ADD TOPLAM, AX
       INC DI
       JMP NEXT
BIR:   ADD TOPLAM, AX  
       XOR DI, DI
NEXT:  INC SI      
       CMP SI, 10
       JNE DEVAM
       MOV ALLSENT, 0
       XOR SI, SI
       
       XOR DI, DI
       MOV AX, TOPLAM
                  
       MOV BL, 10H
       DIV BL
       MOV CL, AH    ;AL,AH,CL
       XOR AH, AH
       DIV BL
       
       CMP AL, 10D
       JNB D1
       ADD AL, 30H 
       JMP D2
D1:    ADD AL, 37H       
D2:    CMP AH, 10D
       JNB D3
       ADD AH, 30H 
       JMP D4
D3:    ADD AH, 37H     
D4:    CMP CL, 10D
       JNB D5
       ADD CL, 30H 
       JMP D6
D5:    ADD CL, 37H       
D6:    MOV MYDAT[0], AL
       MOV MYDAT[1], AH
       MOV MYDAT[2], CL
       	 		 			     
       MOV AL, MYDAT[0]
       OUT 7CH, AL
       INC DATASENDSAY
DEVAM: MOV DATASAY, SI
       IRET
NEWINT ENDP	

NEWINT2 PROC FAR
       CMP ALLSENT, 1
       JE DEVAM2
       MOV DI, DATASENDSAY
       MOV AL, MYDAT[DI]
       OUT 7CH, AL
       INC DI
       CMP DI, 3
       JNE DEVAM2
       MOV TOPLAM, 0
       XOR SI,SI
       MOV ALLSENT, 1
       XOR DI, DI
DEVAM2:MOV DATASENDSAY, DI
       IRET
NEWINT2 ENDP
	
START PROC FAR

       MOV AX, DATA
       MOV DS, AX
       
       XOR AX, AX
       MOV ES, AX
       MOV AL, 78H
       MOV AH, 4
       MUL AH
       MOV BX, AX
       LEA AX, NEWINT
       MOV WORD PTR ES:[BX], AX
       MOV AX, CS
       MOV WORD PTR ES:[BX+2], AX
            
       MOV AL, 79H
       MOV AH, 4
       MUL AH
       MOV BX, AX
       LEA AX, NEWINT2
       MOV WORD PTR ES:[BX], AX
       MOV AX, CS
       MOV WORD PTR ES:[BX+2], AX	
;----------------------------------------	
;8251 kosullandirilmasi	
;----------------------------------------	
        MOV AL, 01001101B
	OUT 7EH, AL
	MOV AL, 40H
	OUT 7EH, AL
        MOV AL, 01001101B
	OUT 7EH, AL
	MOV AL, 15H
	OUT 7EH, AL
;----------------------------------------
;8259 Kosullandirma
;----------------------------------------
       MOV AL, 13H
       OUT 60H, AL 
       MOV AL, 78H
       OUT 62H, AL
       MOV AL, 03H
       OUT 62H, AL
       STI
       XOR DI,DI
ENDLESS:JMP ENDLESS

RET
START ENDP	
CODE    ENDS
        END START