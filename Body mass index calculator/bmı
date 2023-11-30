STACKSG SEGMENT PARA STACK 'STACK'
    DW 16 DUP(?)
STACKSG ENDS

DATASG SEGMENT PARA 'DATA'
    KILO DW 82,62,64,86
    BOY DW 160,172,179,182
    VKI DW 4 DUP(0)
DATASG ENDS

CODESG SEGMENT PARA 'CODE'
    ASSUME CS:CODESG, DS:DATASG, SS:STACKSG

BASLA PROC FAR

       PUSH DS         ; standart exe komutlari
       XOR AX,AX
       PUSH AX
       MOV AX, DATASG
       MOV DS, AX
    
       XOR SI,SI     ; Dizide gezebilmek icin indis = 0 islemi
       MOV CX,4      ; 4 eleman var
       MOV BX,10000    ; 10000 le carpmak icin bx = 100 islemi yapıldı

loop1: MOV AX, WORD PTR [KILO+SI]    ; VKI[CX] = KILO[CX] * 10000  then VKI[CX] = VKI[CX] / (BOY[CX]*BOY[CX]) 
       MUL BX
       DIV WORD PTR [BOY+SI] 
       XOR DX,DX     
       DIV WORD PTR [BOY+SI] 
       MOV WORD PTR [VKI+SI],AX
       ADD SI,2
       XOR DX,DX       ; Bolme isleminde küsürat siliniyor yoksa art arda iki bolme sorun cikariyor
       XOR AX,AX
       LOOP loop1

;ic ice iki for islemi ile selection sort

       XOR SI,SI    ; i=0
dis:   MOV DI,SI    ; j=i

ic:    MOV AX, WORD PTR [VKI+SI]   ; if: dizi[i] > dizi[j] = swap
       CMP AX, WORD PTR [VKI+DI]
       JLE kucuk
       MOV BX,AX
       MOV AX,WORD PTR [VKI+DI]    ; swap islemi
       MOV WORD PTR [VKI+SI],AX
       MOV WORD PTR [VKI+DI],BX
kucuk: 
       ADD DI,2   ; dizi word tanimlandigi icin 2 arttiriyoruz
       CMP DI,8   ; dizi word tanimlandigi icin 2*4 = 8 e kadar kontrol ediyoruz
       JL ic
       ADD SI,2   ; dizi word tanimlandigi icin 2 arttiriyoruz
       CMP SI,8   ; dizi word tanimlandigi icin 2*4 = 8 e kadar kontrol ediyoruz
       JL dis

   RETF
BASLA ENDP

CODESG ENDS
END BASLA