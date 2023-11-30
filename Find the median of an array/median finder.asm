STACKSG SEGMENT PARA STACK 'STACK'
    DW 16 DUP(?)
STACKSG ENDS

DATASG SEGMENT PARA 'DATA'
    SAYILAR DW 10 DUP(0)
    MEDYAN DW ?
    N DB 0
    CR	EQU 13
    LF	EQU 10
    MSG0	DB CR, LF, 'Sayi adedi(N)nin 1 eksigini giriniz(N-1): ', 0
    MSG1	DB CR, LF, 'Sayiyilari giriniz: ', 0
    MSG2	DB CR, LF, 'MEDYAN: ', 0
    HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
DATASG ENDS

CODESG SEGMENT PARA 'CODE'
    ASSUME CS:CODESG, DS:DATASG, SS:STACKSG

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                            ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                            ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                            ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                            ; en az anlamlı hane en alta ve onu altında da                                   
                                            ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP


PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 


PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	    PUSH BX 
        MOV BX,	AX			        ;Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	    ;AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			    ;0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ;AL’deki karakteri ekrana yazar
        INC BX 				        ;bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			    ;yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

GETN2 MACRO
    PUSH BX
    PUSH CX
    PUSH DX

    MOV DX, 1                    ;sayının şimdilik + olduğunu varsayalım 
    XOR BX, BX                   ;okuma yapmadı Hane 0 olur. 
    XOR CX, CX                   ;ara toplam değeri de 0’dır. 

GETN2_START:
    MOV AL, [SI]                 ;SI işaretçisi üzerinden karakteri al

    CMP AL, CR
    JE FIN_READ2                 ;Enter tuşuna basılmışsa okuma biter
    CMP AL, '-'                  
    JNE CTRL2_NUM                ;gelen 0-9 arasında bir sayı mı?

NEGATIVE2:
    MOV DX, -1                   ; - basıldı ise sayı negatif, DX=-1 olur
    JMP NEW2                     ; yeni haneyi al

CTRL2_NUM:
    CALL GETC                    ;klavyeden ilk değeri AL’ye oku.
    CMP AL, CR 
    JE FIN_READ2                 ;Enter tuşuna basılmışsa okuma biter
    CMP AL, '-'                  
    JNE NEW2                     ;gelen 0-9 arasında bir sayı mı?
    
    MOV DX, -1                   ;- basıldı ise sayı negatif, DX=-1 olur
    JMP NEW2                     ;yeni haneyi al

NEW2:
    CMP AL, '0'                  ;sayının 0-9 arasında olduğunu kontrol et.
    JB ERROR2
    CMP AL, '9'
    JA ERROR2                    ;değilse HATA mesajı verilecek

    SUB AL, '0'                  ;rakam alındı, haneyi toplama dâhil et 
    XOR BX, BX
    MOV BL, AL                   ;BL’ye okunan haneyi koy 
    MOV AX, 10                   ;Haneyi eklerken *10 yapılacak 
    PUSH DX                      ;MUL komutu DX’i bozar işaret için saklanmalı
    MUL CX                       ;DX:AX = AX * CX
    POP DX                       ;işareti geri al 
    MOV CX, AX                   ;CX deki ara değer *10 yapıldı 
    ADD CX, BX                   ;okunan haneyi ara değere ekle 
    JMP CTRL2_NUM                ;klavyeden yeni basılan değeri al 

ERROR2:
    JMP GETN2_START              ;o ana kadar okunanları unut yeniden sayı almaya başla 

FIN_READ2:
    MOV AX, CX                   ;sonuç AX üzerinden dönecek 
    CMP DX, 1
    JE FIN_GETN2
    NEG AX                       ;AX = -AX

FIN_GETN2:
    POP DX
    POP CX
    POP DX
ENDM

GETC	PROC NEAR
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 
 
GIRIS_N MACRO
    MOV CX, 2       ;En fazla 10 tamsayı saklayabilmeli (2 olmasının sebebi enter karakteri)
L1:
    MOV AH, 01       ;01h, klavyeden bir karakter okuma işlemi yapar
    INT 21H           ;DOS hizmet çağrısını yap
    CMP AL, 13        ;Enter tuşuna basıldığında döngüyü sonlandır
    JE L1_EXIT

    SUB AL, '0'       ;ASCII karakterini tamsayıya dönüştür
    XOR AH,AH
    ADD AL,1
    MOV N, AL           ;AL'yi SAYILAR dizisine kaydet
    LOOP L1             ;CX sıfıra ulaşana kadar döngüyü tekrarla
L1_EXIT:
ENDM

SIRALA_MEDYAN PROC NEAR
    ;Selection sort
    XOR AH,AH
    MOV AL,N
    DEC AX
    MOV CX,AX
    MOV BX, 2
    MUL BX
    MOV SI,AX
    MOV DI,AX

    OUTER_LOOP:

        PUSH CX

        MOV AX, SAYILAR[SI]
        MOV DI, SI
        SUB DI, 2

        INNER_LOOP:
            CMP AX, SAYILAR[DI]    ; Şu anki elemanın minimum elemandan küçük olup olmadığını kontrol et
            JG NOT_LESS            ; JBE komutu "jump if below or equal" anlamına gelir, yani küçükse veya eşitse NOT_LESS'e atla

            MOV BX, SAYILAR[SI]   ;SWAP islemi
            MOV DX, SAYILAR[DI]
            MOV SAYILAR[SI], DX
            MOV SAYILAR[DI], BX
            MOV AX, SAYILAR[SI]

        NOT_LESS:
            SUB DI, 2
            LOOP INNER_LOOP ; İç döngüyü tekrarla

        POP CX
        SUB SI, 2
        LOOP OUTER_LOOP ; Dış döngüyü tekrarla

        ; MEDYAN hesapla

        XOR AH, AH   ;Medyan hesabı icin (dizi[0+a] + dizi[SI-a])/2 islemi yapildi
        MOV AL, N    ;SI degerini zaten biliyoruz (N*2 - 2)
        XOR DX,DX    ;a ise N/2 , N*2 islemleri sirayla yapilarak bulundu
        MOV BX, 2
        DIV BX
        MUL BX
        MOV SI, AX
        
        XOR AX,AX
        MOV AL,N
        MUL BX
        SUB AX,2
        SUB AX,SI
        MOV DI,AX
        

        MOV AX, SAYILAR[SI] ;dizi[0+a]
        ADD AX, SAYILAR[DI] ;dizi[0+a] + dizi[SI-a]
        XOR DX,DX
        DIV BX
        XOR DX, DX
        MOV MEDYAN, AX ;Medyan hesabı icin (dizi[0+a] + dizi[SI-a])/2

        RET
SIRALA_MEDYAN ENDP


BASLA PROC FAR

    PUSH DS         ;standart exe komutlari
    XOR AX,AX
    PUSH AX

    MOV AX, DATASG
    MOV DS, AX

    MOV AX, OFFSET MSG0
    CALL PUT_STR

    GIRIS_N         ;Dizi eleman sayisi alma (N-1 şeklinde)

    XOR CX,CX
    MOV CL,N
    XOR SI,SI

loop1:             ;Elemanlari okuyup diziye yerleştirme
    MOV AX, OFFSET MSG1
    CALL PUT_STR			 
    XOR AX,AX 
    GETN2
    MOV SAYILAR[SI],AX
    ADD SI,2
    LOOP loop1   

    CALL SIRALA_MEDYAN  ;Elemanlari siralama
    
    MOV AX, OFFSET MSG2 ;Medyan:
    CALL PUT_STR   

    MOV AX, MEDYAN      ;Medyan değerini yazdır
    CALL PUTN           
    MOV AX,1

    RETF
BASLA ENDP

CODESG ENDS
END BASLA