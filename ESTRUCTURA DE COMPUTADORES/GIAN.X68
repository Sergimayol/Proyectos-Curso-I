*-----------------------------------------------------------
* Title      : PRAFIN18
* Written by : Gian Lucas Martín Chamorro y Alejandro Cortés Fernández
* Date       : 20/05/2018
* Description: Emulador de la USC-1
*-----------------------------------------------------------
    ORG $1000
EPROG: DC.W $6805,$681B,$200D,$4001,$2010,$4002,$480A
       DC.W $3013,$600D,$67FB,$900C,$8002,$C000,$0002
       DC.W $0003,$0001,$0003,$0002,$0004,$0000,$0000,$0000
EIR:   DC.W 0 ;eregistro de instruccion
EPC:   DC.W 0 ;econtador de programa
ET0:   DC.W 0 ;eregistro T0
ER1:   DC.W 0 ;eregistro R1
ER2:   DC.W 0 ;eregistro R2
ER3:   DC.W 0 ;eregistro R3
ER4:   DC.W 0 ;eregistro R4
EB5:   DC.W 0 ;eregistro B5
EB6:   DC.W 0 ;eregistro B6
ESR:   DC.W 0 ;eregistro de estado (00000000 00000ZNC)

START:
    CLR.W EPC
    LEA.L EPROG,A0     
   
FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC
	;*** y dejar listo el EPC para que apunte a la siguiente instruccion
    CLR.L D4
    MOVE.W EPC,D4
    MULU #2,D4
    MOVE.W 0(A0,D4),EIR ;Calcula desplazamiento respecto a EPROG en base al EPC
    ADDQ.W #1,EPC
    ;--- FFETCH: FIN FETCH
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1
        MOVE.W #0,-(A7) ;Espacio en pila para resultado
        MOVE.W EIR,-(A7) ;Parámetro en la pila
        JSR DECOD
        ADDQ.W #2,SP ;Borra de pila el parámetro
        MOVE.W (SP)+,D1 ;Resultado de decodificación
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ELOA
    JMP ESTO
    JMP ELOX
    JMP ESTX
    JMP EMOV
    JMP EADD
    JMP ESUB
    JMP ECMP
    JMP EINC
    JMP ESTC
    JMP ENAN
    JMP EBRI
    JMP EBRZ
    JMP EBRN
    JMP ESTP
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.

;Decodifica la direccion de memoria en la subrutina DIREC y mueve, con indexado
;sumandole la @ de EPROG, su contenido a ET0. Despues actualiza los eflags 
;Z y N.        
ELOA:               
    MOVE.W EIR, D0
    JSR DIREC
    MOVE.W EPROG(A2),ET0
    MOVE SR,D2
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    MOVE.W D3,ESR
    JMP FETCH
    
;Decodifica la dirección de memoria en la subrutina DIREC y mueve  
;el contenido de ET0 a dicha direccion.
ESTO:
    MOVE.W EIR, D0
    JSR DIREC
    MOVE.W ET0,EPROG(A2)
    JMP FETCH
    
;Mueve el contenido del registro de memoria B5 o B6(dependiendo del bit 8)
;a D5 y se lo suma a la direccion de memoria A2 para despues mover, con indexado
;sumandole la @ de EPROG, su contenido a ETO. Finalmente actualiza los flags
;Z y N.
ELOX:
    MOVE.W EIR, D0
    BTST #8,D0
    BEQ ETB5
    JSR DIREC
    MOVE.W EB6,D5
    MULU.W #2,D5
    ADDA.W D5,A2
    MOVE.W EPROG(A2),ET0
    JMP ETELOX 
    ETB5:    
    JSR DIREC
    MOVE.W EB5,D5
    MULU.W #2,D5
    ADDA.W D5,A2
    MOVE.W EPROG(A2),ET0
    ETELOX:
    MOVE SR,D2    
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    MOVE.W D3,ESR
    JMP FETCH
    
;Mueve el contenido del registro de memoria B5 o B6(dependiendo del bit 8)
;a D5 y se lo suma a la dirección de memoria a A2, luego de sumarle el @ de EPROG;
;el contenido de ET0 se mueve a dicha dirección.  
ESTX:
    MOVE.W EIR, D0
    BTST #8,D0
    BEQ ETB5_2
    JSR DIREC
    MOVE.W EB6,D5
    MULU.W #2,D5
    ADDA.W D5,A2
    MOVE.W ET0,EPROG(A2)
    JMP FETCH    
    ETB5_2:      
    JSR DIREC
    MOVE.W EB5,D5
    MULU.W #2,D5
    ADDA.W D5,A2
    MOVE.W ET0,EPROG(A2) 
    JMP FETCH
    
;Mueve el contenido del contenido de A4(Xa) al contenido de A3(Xb) y actualiza 
;los flags Z y N.    
EMOV:
    MOVE.W EIR,D0
    JSR Xb
    JSR Xa
    MOVE.W (A4),(A3)
    MOVE SR,D2    
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    MOVE.W D3,ESR
    JMP FETCH
    
;Mueve el contenido del contenido de A3(Xb) a D5. Despues, el contenido 
;del contenido de A4(Xa) se suma a D5 y se actualizan los tres flags. Despues,
;el contenido de D5 se mueva a la dirección A5(Xc).
EADD:
    MOVE.W EIR, D0 
    JSR Xb
    JSR Xa
    JSR Xc
    MOVE.W (A3),D5
    ADD.W (A4),D5      
    MOVE SR,D2
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    JSR ACTC
    MOVE.W D3,ESR
    MOVE.W D5,(A5)
    JMP FETCH
    
;Mueve el contenido de A3(Xb) a D5 y le hace una NOT bit a bit. Despues se suma
;un 1 a D5 y despues se suma este con el contenido del contenido de A4(Xa) y se 
;actualizan los tres flags para finalmente mover el resultado a la direccion 
;A5(Xc).   
ESUB:
    MOVE.W EIR, D0 
    JSR Xb
    JSR Xa
    JSR Xc
    MOVE.W (A3),D5
    NOT.W D5
    ADDQ.W #1,D5      
    ADD.W (A4),D5
    MOVE SR,D2
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    JSR ACTC
    MOVE.W D3,ESR
    MOVE.W D5,(A5)
    JMP FETCH
    
;Mueve el contenido de A3(Xb) a D5 y le resta el contenido del contenido de 
;A4(Xa) para despues actualizar los tres flags.
ECMP:
    MOVE.W EIR, D0 
    JSR Xb
    JSR Xa
    JSR Xc
    MOVE.W (A3),D5
    CMP.W (A4),D5      
    MOVE SR,D2
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    JSR ACTC
    MOVE.W D3,ESR
    JMP FETCH
    
;Le suma D0 (cuyo contenido es el valor de k) al contenido del contenido de 
;A3(Xb) y se actualizan los tres flags.    
EINC:    
    MOVE.W EIR, D0
    JSR Xb
    JSR K
    ADD.W D0,(A3)
    MOVE SR,D2    
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    JSR ACTC
    MOVE.W D3,ESR
    JMP FETCH
    
;Mueve el contenido de D0 (cuyo contenido es el valor de k) y lo mueve a la
;direccion A3(Xb). Finalmente actualiza los flags Z y N
ESTC: 
    MOVE.W EIR, D0
    JSR Xb
    JSR K
    MOVE.W D0,(A3)
    MOVE SR,D2    
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    MOVE.W D3,ESR
    JMP FETCH
    
;Mueve el contenido del contenido de A3(Xb) al registro D5 para despues hacer
;una AND bit a bit con el contenido del contenido de A4(Xa), hacer una NOT bit
;a bit de D5 y mover el resultado a la direccion A5(Xc). Finalmente actualiza 
;los flags Z y N.           
ENAN:
    MOVE.W EIR, D0
    JSR Xb
    JSR Xa
    JSR Xc
    MOVE.W (A3),D5
    AND.W (A4),D5
    NOT.W D5
    MOVE.W D5,(A5)
    MOVE SR,D2    
    MOVE.W ESR,D3
    JSR ACTZ
    JSR ACTN
    MOVE.W D3,ESR
    JMP FETCH
    
;Salta a la subrutina BRDIREC y despues coge esa direccion de salto y lo carga 
;en el EPC.
EBRI:
    MOVE.W EIR, D0
    JSR BRDIREC
    MOVE.W A2,EPC
    JMP FETCH

;Dependiendo del bit 2 (eflag Z) de D3(ESR) hace el branch a EZ0 o carga en EPC
;el valor de salto.     
EBRZ:
    MOVE.W ESR,D3
    BTST #2,D3
    BEQ EZ0
    MOVE.W EIR,D0
    JSR BRDIREC
    MOVE.W A2,EPC
    EZ0:    
    JMP FETCH 
 
;Dependiendo del bit 1 (eflag N) de D3(ESR) hace el branch a EN0 o carga en EPC
;el valor de salto.        
EBRN:
    MOVE.W ESR,D3
    BTST #1,D3
    BEQ EN0
    MOVE.W EIR,D0
    JSR BRDIREC
    MOVE.W A2,EPC
    EN0:    
    JMP FETCH 

;Salta a END START y detiene la ejecucion del programa    
ESTP:
   JMP FINISH
    ;--- FEXEC: FIN EJECUCION

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

;Subrutina de usuario que devuelve una posicion de memoria, especificada en la 
;einstruccion, lista para usarse en A2.
DIREC: 
    LSL.W #8,D0
    LSR.W #8,D0
    MULU.W #2,D0
    MOVEA.W D0,A2
    RTS

;Subrutina de usuario especifica para einstrucciones de branch que devuelve
;la direccion que hay que poner en el EPC.   
BRDIREC:
    LSL.W #8,D0
    LSR.W #8,D0
    MOVEA.W D0,A2
    RTS

;Subrutina que guarda el operando k (en dir. inmediato) en el registro 
;de datos D0 y hace una extension de signo.
K:
    LSR.W #3,D0  
    EXT.W D0
    RTS  
    
;Subrutina que decodifica que registro es el operando B y lo guarda en A3.
Xb:
    BTST.L #2,D0
    BEQ Xb0XX
    BTST #1,D0
    BEQ Xb10X
    LEA.L EB6,A3 ;B es B6
    RTS
Xb0XX:
    BTST #1,D0
    BEQ Xb00X
    BTST #0,D0
    BEQ Xb010
    LEA.L ER3,A3 ;B es R3
    RTS
Xb10X:
    BTST.L #0,D0
    BEQ Xb100
    LEA.L EB5,A3 ;B es B5
    RTS
Xb100:        
    LEA.L ER4,A3 ;B es R4
    RTS
Xb00X:
    BTST.L #0,D0
    BEQ Xb000
    LEA.L ER1,A3 ;B es R1
    RTS
Xb000:    
    LEA.L ET0,A3 ;B es T0
    RTS
Xb010:
    LEA.L ER2,A3 ;B es R2
    RTS
    
;Subrutina que decodifica que registro es el operando A y lo guarda en A4.   
Xa: 
    BTST.L #5,D0
    BEQ Xa0XX
    BTST #4,D0
    BEQ Xa10X
    LEA.L EB6,A4 ;A es B6
    RTS
Xa0XX:  
    BTST #4,D0
    BEQ Xa00X
    BTST #3,D0
    BEQ Xa010
    LEA.L ER3,A4 ;A es R3
    RTS
Xa10X:
    BTST.L #3,D0
    BEQ Xa100
    LEA.L EB5,A4 ;A es B5
    RTS
Xa100:        
    LEA.L ER4,A4 ;A es R4
    RTS
Xa00X:
    BTST.L #3,D0
    BEQ Xa000
    LEA.L ER1,A4 ;A es R1
    RTS
Xa000:    
    LEA.L ET0,A4 ;A es T0
    RTS
Xa010:
    LEA.L ER2,A4 ;A es R2
    RTS
    
;Subrutina que decodifica que registro es el operando C y lo guarda en A5.
Xc: 
    BTST.L #8,D0
    BEQ Xc0XX
    BTST #7,D0
    BEQ Xa10X
    LEA.L EB6,A5 ;C es B6
    RTS
Xc0XX: 
    BTST #7,D0
    BEQ Xc00X
    BTST #6,D0
    BEQ Xc010
    LEA.L ER3,A5 ;C es R3
    RTS
Xc10X:
    BTST.L #6,D0
    BEQ Xc100
    LEA.L EB5,A5 ;C es B5
    RTS
Xc100:        
    LEA.L ER4,A5 ;C es R4
    RTS
Xc00X:
    BTST.L #6,D0
    BEQ Xc000
    LEA.L ER1,A5 ;C es R1
    RTS
Xc000:    
    LEA.L ET0,A5 ;C es T0
    RTS
Xc010:
    LEA.L ER2,A5 ;C es R2
    RTS
    
ACTZ: ;Se usa para actualizar el eflag Z.
    BTST #2,D2
    BEQ Z0
    BSET #2,D3
    RTS
Z0: BCLR #2,D3
    RTS
 
ACTN: ;Se usa para actualizar el eflag N.
    BTST #3,D2
    BEQ N0
    BSET #1,D3
    RTS
N0: BCLR #1,D3
    RTS
    
ACTC: ;Se usa para actualizar el eflag C.
    BTST #0,D2
    BEQ C0
    BSET #0,D3
    RTS
C0: BCLR #0,D3
    RTS
    
    ;--- FSUBR: FIN SUBRUTINAS

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
    MOVE.L D0,-(SP) ;Guarda D0
    MOVE.W 8(SP),D0 ;Pone el EIR en D0

    BTST #15,D0
    BEQ E0XXXX
    BTST #14,D0
    BEQ E10XXX
    MOVE.W #14,10(SP) ;EINSTRUCCION 14
    MOVE.L (SP)+,D0
    RTS
E0XXXX:  
    BTST #14,D0
    BEQ E00XXX
    BTST #13,D0
    BEQ E010XX
    BTST #12,D0
    BEQ E0110X
    MOVE.W #10,10(SP) ;EINSTRUCCION 10
    MOVE.L (SP)+,D0
    RTS
E00XXX:  
    BTST #13,D0
    BEQ E000XX
    BTST #12,D0
    BEQ E0010X
    MOVE.W #3,10(SP) ;EINSTRUCCION 3
    MOVE.L (SP)+,D0
    RTS
E000XX:
    BTST #12,D0
    BEQ E0000X
    MOVE.W #1,10(SP) ;EINSTRUCCION 1
    MOVE.L (SP)+,D0
    RTS
E0000X:
    MOVE.W #0,10(SP) ;EINSTRUCCION 0
    MOVE.L (SP)+,D0
    RTS
E0010X:
    MOVE.W #2,10(SP) ;EINSTRUCCION 2
    MOVE.L (SP)+,D0
    RTS
E010XX:
    BTST #12,D0
    BEQ E0100X
    BTST #11,D0
    BEQ E01010    
    MOVE.W #7,10(SP) ;EINSTRUCCION 7
    MOVE.L (SP)+,D0
    RTS
E0100X:
    BTST #11,D0
    BEQ E01000
    MOVE.W #5,10(SP) ;EINSTRUCCION 5
    MOVE.L (SP)+,D0
    RTS
E01000:
    MOVE.W #4,10(SP) ;EINSTRUCCION 4
    MOVE.L (SP)+,D0
    RTS
E01010:
    MOVE.W #6,10(SP) ;EINSTRUCCION 6
    MOVE.L (SP)+,D0
    RTS
E0110X:
    BTST #11,D0
    BEQ E01100
    MOVE.W #9,10(SP) ;EINSTRUCCION 9
    MOVE.L (SP)+,D0
    RTS
E01100:
    MOVE.W #8,10(SP) ;EINSTRUCCION 8
    MOVE.L (SP)+,D0
    RTS   
E10XXX:
    BTST #13,D0
    BEQ E100XX
    MOVE.W #13,10(SP) ;EINSTRUCCION 13
    MOVE.L (SP)+,D0
    RTS
    E100XX:
    BTST #12,D0    
    BEQ E1000X
    MOVE.W #12,10(SP) ;EINSTRUCCION 12
    MOVE.L (SP)+,D0
    RTS
E1000X:
    MOVE.W #11,10(SP) ;EINSTRUCCION 11
    MOVE.L (SP)+,D0
    RTS
    ;--- FDECOD: FIN DECOD
 
FINISH: 
    END    START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
