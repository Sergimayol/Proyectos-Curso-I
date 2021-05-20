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
*CODE:   DC.W 0,0,0,0,0,0,0,0,0 ;0B, 0B, 0E, 0C, 
*        DC.W 0,0,0,0,0,0,0,0,0    


START:
    CLR.W EPC 
    LEA EPROG,A0        ;Cargamos las direccion efectiva del EPROG(1000)
    
FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	    
	    CLR.L D4            ; Borramos el contenido del registro de datos para que no tenga el anterior
	    MOVE.W EPC,D4       ; Movemos EPC a un registro de datos
	    MULU #2,D4           
	    MOVE.W 0(A0,D4),EIR ; Calcula el desplazamiento del EPROG según el EPC
	    ADDQ.W #1,EPC       ; Sumamos 1 al EPC
	    
	   * Tenemos qeu sumarle a A0, donde tenemos, la primera dirección de memoria del
	   * eprog la siguiente posicion de la memoria, es decir, si EPC es 0 será A0+0
	   * si EPC es 1 será A0+2 y así continuamente, una vez ya sepamos que dorección es la 
	   * que toca lo tenemos que pasar a EIR
	       
    ;--- FFETCH: FIN FETCH
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

	; ESCRIBID VUESTRO CODIGO AQUI
	MOVE.W #0,-(A7)     ; Reservar espacio en la pila para el resultado
    MOVE.W EIR,-(A7)    ; Paso de parametro EIR a la pila
    JSR DECOD           ; Salto a la subrutina
    ADDQ.W #2,A7        ; vaciar pila
    MOVE.W (A7)+,D1     ; Guardar resultado en D1
        
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
    MOVE.W EIR,D0
    JMP FETCH
EJMN:
    MOVE.W EIR,D0
    JMP FETCH
EJMZ:
    MOVE.W EIR,D0
    JMP FETCH
EJMI:
    MOVE.W EIR,D0
    JMP FETCH
ECOM:
    MOVE.W EIR,D0   
    JMP FETCH
EADD:
    MOVE.W EIR,D0
    JMP FETCH
ESUB:
    MOVE.W EIR,D0
    JMP FETCH
ENEG:
    MOVE.W EIR,D0
    JMP FETCH
EAND:
    MOVE.W EIR,D0
    JMP FETCH
EOR:
    MOVE.W EIR,D0
    JMP FETCH
ENOT:
    MOVE.W EIR,D0
    JMP FETCH
ESET:
    MOVE.W EIR,D0
    JMP FETCH
EMOV:
    MOVE.W EIR,D0
    JMP FETCH
ESTO:
    MOVE.W EIR,D0
    JMP FETCH
ELOA:
    MOVE.W EIR,D0
    JMP FETCH
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
	
    MOVE.W D0,-(A7)
    MOVE.W 6(A7),D0
    BTST.L #15,D0
    BNE BIT1     
    
    ;BULCE SI BIT 15 = 1
    BTST.L #14,D0       ;0  
    BNE BIT1cero
    MOVE.W #0,8(A7)
    JMP FINAL           ;00

BIT1:   
    BTST.L #14,D0       ;1
    BNE BIT2 
    BTST.L #13,D0       ;10
    BNE BIT5
    BTST.L #12,D0       ;100
    BNE BIT6
    BTST.L #11,D0       ;1000
    BNE BIT7
    MOVE.W #4,8(A7)     ;10000
    JMP FINAL
 
   
BIT2: 
    BTST.L #13,D0       ;11
    BNE BIT3
    BTST.L #12,D0       ;110
    BNE BIT4
    MOVE.W #12,8(A7)
    JMP FINAL           ;1100
    
BIT3:
    MOVE.W #14,8(A7)
    JMP FINAL           ;1110
    
BIT4: 
    MOVE.W #13,8(A7)
    JMP FINAL           ;1101    

BIT5:
    MOVE.W #12,D0       ;101
    BNE BIT9
    MOVE.W #11,D0       ;1010
    BNE BIT10
    MOVE.W #8,8(A7)
    JMP FINAL           ;10100
    
    
BIT6:
    BTST.L #11,D0       ;1001
    BNE BIT8
    MOVE.W #6,8(A7)
    JMP FINAL           ;10010    
    
BIT7:
    MOVE.W #5,8(A7)
    JMP FINAL           ;10001   
    
BIT8:  
    MOVE.W #7,8(A7) 
    JMP FINAL           ;10011 
   
BIT9:
    MOVE.W #11,D0       ;1011
    BNE BIT11
    MOVE.W #10,8(A7)
    JMP FINAL           ;10110
    
    
BIT10:
    MOVE.W #9,8(A7)
    JMP FINAL           ;10101    
    
BIT11:
    MOVE.W #11,8(A7)
    JMP FINAL           ;10111    
    
      
BIT1cero:               ;0
    BTST.L #13,D0       ;01
    BEQ BIT2cero  
    MOVE.W #3,8(A7)     ;011
    JMP FINAL           ;0110
    
BIT2cero:  
    BTST.L #12,D0       ;010
    BNE BIT3cero
    MOVE.W #1,8(A7)
    JMP FINAL           ;0100

BIT3cero:
    MOVE.W #2,8(A7)
    JMP FINAL           ;0101
    
        
FINAL:
    MOVE.W (A7)+,D0
    RTS
    ;--- FDECOD: FIN DECOD
    END    START

























*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
