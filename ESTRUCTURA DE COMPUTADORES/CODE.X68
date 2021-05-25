*-----------------------------------------------------------
* Title      : PRAFIN21
* Written by : Alejandro Rodriguez Arguimbau y Sergi Mayol Matos
* Date       : 31/05/2021
* Description: Emulador de la CDB
*-----------------------------------------------------------
    ORG $1000
EPROG:  DC.W $B803,$BFFC,$E0F0,$C0C0,$50C0,$E108,$C0E1,$50C0,$8803
        DC.W $8881,$50C0,$6080,$C066,$D110,$0000,$0004,$0003,$0000
EIR:    DC.W 0 ;eregistro de instruccion
EPC:    DC.W 0 ;econtador de programa
ER0:    DC.W 0 ;eregistro R0
ER1:    DC.W 0 ;eregistro R1
ER2:    DC.W 0 ;eregistro R2
ER3:    DC.W 0 ;eregistro R3
ER4:    DC.W 0 ;eregistro R4
ER5:    DC.W 0 ;eregistro R5
ET6:    DC.W 0 ;eregistro T6
ET7:    DC.W 0 ;eregistro T7
ESR:    DC.W 0 ;eregistro de estado (00000000 00000NCZ)

        ;VECTOR TEMPORAL
CODE:   DC.W 0,0,0,0,0,0,0,0,0 ;0B, 0B, 0E, 0C, 02, 0E, 0C, 08, 02, 05, 05, 02, 03, 0C, 0D, 00
        DC.W 0,0,0,0,0,0,0,0,0
N:      EQU 18     


START:
    CLR.W EPC
    
    MOVE.W #N,D1          ;Para bucle DBRA
    SUBQ #1,D1 
    LEA EPROG,A0        ;Cargamos las direcciones efectivas
    LEA CODE,A1
FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	
	; ESCRIBID VUESTRO CODIGO AQUI
MAINLOOP:
    MOVE.W (A0)+,ER0    ;Avanzar siguiente posición del vector
    MOVE.W #0,-(A7)     ;Reservar espacio en la pila para parametro de salida
    MOVE.W ER0,-(A7)
    JSR DECOD
    ADDQ.W #2,A7
    DBRA D1,MAINLOOP
        
    ;--- FFETCH: FIN FETCH
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

	; ESCRIBID VUESTRO CODIGO AQUI
        
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP EHLT
    JMP EJMN
    JMP EJMZ
    JMP EJMI
    JMP ECOM
    JMP EADD
    JMP ESUB
    JMP ENEG
    JMP EAND
    JMP EOR
    JMP ENOT
    JMP ESET
    JMP EMOV
    JMP ESTO
    JMP ELOA
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
	
	; ESCRIBID EN CADA ETIQUETA LA FASE DE EJECUCION DE CADA INSTRUCCION
EHLT:
EJMN:
EJMZ:
EJMI:
ECOM:
EADD:
ESUB:
ENEG:
EAND:
EOR:
ENOT:
ESET:
EMOV:
ESTO:
ELOA:
    ;--- FEXEC: FIN EJECUCION

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	; ESCRIBID VUESTRO CODIGO AQUI
        
    ;--- FSUBR: FIN SUBRUTINAS

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
	; ESCRIBID VUESTRO CODIGO AQUI
    MOVE.W D0,-(A7)
    MOVE.W 6(A7),D0
    BTST.L #15,D0
    BNE BIT1 ; Salta si el bit es 1, es decir, Z=0
    
    *---------------------------------------------------------------*
    * BEQ si queremos que bit Z = 1 y BNE si queremos que bit Z = 0 *
    *---------------------------------------------------------------*
    
    ;BULCE SI BIT 15 = 1
    BTST.L #14,D0 ;0  
    BNE BIT1cero
    MOVE.W #0,(A1)+
    JMP FINAL ;Id HLT ;00

BIT1:   
    BTST.L #14,D0 ;1
    BNE BIT2 Salta si el bit es 1, es decir, Z=0
    BTST.L #13,D0 ;10
    BNE BIT5
    BTST.L #12,D0 ;100
    BNE BIT6
    BTST.L #11,D0 ;1000
    BNE BIT7
    MOVE.W #4,(A1)+ ; ID COM; 10000
    JMP FINAL
 

   
BIT2: 
    BTST.L #13,D0 ;11
    BNE BIT3
    BTST.L #12,D0 ;110
    BNE BIT4
    MOVE.W #12,(A1)+
    JMP FINAL ; ID MOV; 1100
    
BIT3:
    MOVE.W #14,(A1)+
    JMP FINAL ; Id LOA; 1110
    
BIT4: 
    MOVE.W #13,(A1)+
    JMP FINAL ; Id STO ; 1101    

BIT5:
    MOVE.W #12,D0 ;101
    BNE BIT9
    MOVE.W #11,D0 ;1010
    BNE BIT10
    MOVE.W #8,(A1)+
    JMP FINAL ; ID AND; 10100
    
    
BIT6:
    BTST.L #11,D0 ; 1001
    BNE BIT8
    MOVE.W #6,(A1)+
    JMP FINAL ; ID SUB, 10010    
    
BIT7:
    MOVE.W #5,(A1)+
    JMP FINAL ; ID ADD ; 10001   
    
BIT8:  
    MOVE.W #7,(A1)+ 
    JMP FINAL ; Id NEG ;10011 
   
BIT9:
    MOVE.W #11,D0 ;1011
    BNE BIT11
    MOVE.W #10,(A1)+
    JMP FINAL ; ID NOT; 10110
    
    
BIT10:
    MOVE.W #9,(A1)+
    JMP FINAL ; ID OR ; 10101    
    
BIT11:
    MOVE.W #11,(A1)+
    JMP FINAL ; ID SET ;10111    
    
      
BIT1cero: ; 0
    BTST.L #13,D0 ; 01
    BEQ BIT2cero  
    MOVE.W #3,(A1)+ ;011
    JMP FINAL ; ID JMI M ; 0110
    
BIT2cero:  
    BTST.L #12,D0 ;010
    BNE BIT3cero
    MOVE.W #1,(A1)+
    JMP FINAL ; ID JMN M ;0100

BIT3cero:
    MOVE.W #2,(A1)+
    JMP FINAL ; ID JMZ M ; 0101
    
        
FINAL:
    ADDQ.W #2,A7
    RTS
    ;--- FDECOD: FIN DECOD
    END    START



















*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
