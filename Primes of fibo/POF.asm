CODESG SEGMENT PARA 'CODE'
    ORG 100H        ;COM tipi programlarda 100H dan baslar
    ASSUME CS:CODESG, DS:CODESG, SS:CODESG, ES:CODESG

BASLA: JMP FIB
    F1 DW 1
    F2 DW 1
    prime DW 20 DUP(2)  ;ilk eleman 2 oldugu icin kontrol sayisini azaltmak adina 2 ile DUP islemi yaptim
    nonPrime DW 20 DUP(1) ;ilk eleman 1 oldugu icin kontrol sayisini azaltmak adina 1 ile DUP islemi yaptim
FIB PROC NEAR
 
MOV CX, 17      ;Dizinin eleman sayisi
XOR SI, SI      ;SI'yi sifirla
XOR DI, DI      ;DI'yi sifirla

LOOP2:
;FIBONACCI SAYISI HESABI
    XOR AX,AX   ; AX = 0
    MOV AX,F1   ; AX = F1       
    ADD AX,F2   ; AX = F1 + F2
    MOV DX,AX   ; DX = F1 + F2
    MOV AX,F2   ; AX = F2
    MOV F1,AX   ; F1 = F2
    MOV F2,DX   ; F2 = F1 + F2


    MOV AX, F2 ;    ; F2 bizim kontrol edecegimiz fibonacci sayisidir
    MOV DX, 2       ; DX'i 2'ye ayarla (asal sayı kontrolü için) 

nasal_loop:

    PUSH AX         ; AX'i yedekle (Dizideki ana sayimizi tutuyor ayni zamanda)
    PUSH DX         ; DX'i yedekle (Asal sayi kontrolunu yapiyor ve birer birer artiyor)

    MOV BX, DX      ; BX'i DX'e eşitle
    XOR DX, DX      ; DX değerini sifirla
    DIV BX          ; AX'i BX ile bol
    CMP DX, 0       ; Kalani kontrol et

    POP DX          ; DX'i geri yukle
    POP AX          ; AX'i geri yukle

    JZ NotPrime     ; Eğer kalan sifirsa, sayi asal değil

    INC DX          ; DX'i bir artir(Bolen sayi)

    CMP AX, DX      ;(Asal mi kontrolu icin sayiya kadar olan tum sayilara bolunuyor mu diye kontrol et)
    JA nasal_loop   ; AX, DX'i asmadiysa, asal sayi kontrolunu tekrarla


    MOV prime[SI+2], AX ; Asal ise asal dizisine ekle (+2 cunku ilk deger zaten 2 olarak var) 
    ADD SI,2           ; Asal dizisinde indisi 1*(word) arttir

    JMP sonraki        ;Bir sonraki sayiya gec

NotPrime:
    
    MOV nonPrime[DI+4], AX ; Asal degil ise nasal dizisine ekle (+4 cunku ilk iki deger 1 ve 1 seklinde zaten var)
    ADD DI,2            ; Nasal dizisinde indisi 1*(word) arttir

sonraki:              

    
    ADD BX,2          ; BX'yi bir artir (Ana dizide diger sayiya gec)

    LOOP LOOP2   ;Tum sayilar icin kurulan dongu

    MOV AX,1     ; Debug da toggle yapmak icin olusturdum


    RET         ; near tipi proc donus
    FIB ENDP    ; prosedur bitis
    CODESG ENDS ; segment bitis
    END BASLA   ; kod BASLA etiketinden basliyor ifadesi
