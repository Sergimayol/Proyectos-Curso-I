*-----------------------------------------------------------
* Title      : PRAFIN21
* Written by : Alejandro Rodriguez Arguimbau y Sergi Mayol Matos
* Date       : 31/05/2021
* Description: Emulador de la CDB
*-----------------------------------------------------------
    ORG $1000
EPROG: DC.W $E088,$C0E2,$6050,$9042,$0000,$8842,$9802,$0000,$FFFF
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

START:
    CLR.W EPC 
    LEA.L EPROG,A0        ;Cargamos las direccion efectiva del EPROG(1000)
    
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
*****************************************************************    
;DETIENE LA MÁQUINA
EHLT:
    SIMHALT
    
*****************************************************************    
;SALTO SI EL FLAG N = 1
EJMN:
    MOVE.W ESR,D3   ;Movemos el ESR a un a D3
    BTST.L #2,D3    ;Comprobamos el valor de N
    BNE SALTON       ;Luego cambio a subrutina de salto flag N
    JMP FETCH        ;N=0
SALTON: ;N=1
    AND.W #$0FF0,EIR ;Mascara para obtener la dirección de m
    MOVE.W EIR,D5   ;D5 resgitro de op intermedias´
    LSR.L #4,D5     ;Desplazamineto bits a la derecha
    MOVE.W D5,EPC   ;Cargar M en el EPC
    JMP FETCH   
    
*****************************************************************    
;SALTO SI EL FLAG Z = 1
EJMZ:
    MOVE.W ESR,D3   ;Movemos el ESR a un a D3
    BTST.L #0,D3    ;Comprobamos valor de Z
    BNE SALTOZ
    JMP FETCH   ;Z=0
SALTOZ:
    ;Z=1
    AND.W #$0FF0,EIR ;OBTENEMOS VALOR DE M
	MOVE.W EIR,D5
	LSR.L #4,D5
	MOVE.W D5,EPC
	JMP FETCH
	
*****************************************************************    
;SALTO INCONDICIONAL
EJMI:
    AND.W #$0FF0,EIR
    MOVE.W EIR,D5
    LSR.L #4,D5
    MOVE.W D5,EPC
    JMP FETCH
    
*****************************************************************        
;HACE UN CMP RESTANDO EL CONTENIDO DE B - EL CONTENIDO DE A
ECOM:
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    MOVE.W (A3),D5 ;Guardamos el contenido actual de A3 en D5 para poder operar
    CMP.W (A4),D5      
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGC     ;Actualización eflag C
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    JMP FETCH  

*****************************************************************            
;SUMA EL CONTENIDO DE B y EL CONTENIDO DE A Y LO GUARDA EN B
EADD:
   ;OPERACIÓN B + A
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    MOVE.W (A3),D5 ;Guardamos el contenido actual de A3 en D5 para poder operar
    ADD.W (A4),D5  ;Sumamos el contenido actual de A4 con D5 
    ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGC     ;Actualización eflag C
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D5,(A3) ;Movemos el resultado de la operación al rsgitro indicado por Xb
    JMP FETCH
 
*****************************************************************        
;RESTA EL CONTENIDO DE B y EL CONTENIDO DE A Y LO GUARDA EN B
ESUB:
    ;OPERACIÓN B - A
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    MOVE.W (A3),D5 ;Guardamos el contenido actual de A3 en D5 para poder operar
    NOT.W D5       ;Se realiza el cambio de signo del operando B
    ADDQ.W #1,D5   ;(B¯ + 1)
    ADD.W (A4),D5  ;Sumamos, A - B = A + (B¯ + 1). , el contenido actual de A4 con D5 
    ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGC     ;Actualización eflag C
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D5,(A3)
    JMP FETCH    

*****************************************************************        
;CAMBIA EL SIGNO DEL CONTENIDO DE B Y LO GUARDA EN B
ENEG:
    ;NEGACIÓN OPERANDO B
    MOVE.W EIR,D0
    JSR Xb         ;Salto a subrutina Xb para decodificar el operando
    MOVE.W (A3),D5 ;Guardamos el contenido actual de A3 en D5 para poder operar
    NEG.W D5       ;Se realiza el cambio de signo del operando B
    ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D5,(A3)
    JMP FETCH
    
*****************************************************************        
;REALIZACIÓN DE UNA AND BIT A BIT DEL CONTENIDO DE B CON EL DE A 
EAND:
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    MOVE.W (A3),D5
    MOVE.W (A4),D6
    AND.W D5,D6
    ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D6,(A3)
    JMP FETCH   

*****************************************************************        
;REALIZACIÓN DE UNA OR BIT A BIT DEL CONTENIDO DE B CON EL DE A    
EOR:
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    MOVE.W (A3),D5
    MOVE.W (A4),D6
    OR.W D5,D6
    ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D6,(A3)
    JMP FETCH
    
*****************************************************************        
;CAMBIA CADA BIT HACIENDO UN NOT DEL CONTENIDO DE B
ENOT:
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xb para decodificar los operandos
    MOVE.W (A3),D5 ;Guardamos el contenido actual de A3 en D5 para poder operar
    NOT.W D5       ;Se hace una NOT del resgitro D5
   ;ACTUALIZACIÓN DE LOS EFLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    MOVE.W D5,(A3)
    JMP FETCH   

*****************************************************************        
ESET:
    MOVE.W EIR,D0
    JSR Xb
    AND.W #$0FFF,EIR
	MOVE.W EIR,D5
	LSL.L #1,D5
    AND.W #$0FF0,D5    
    LSR.L #4,D5     ;TENEMOS LA K EN D4
    BTST.L #7,D5    ;MIRAMOS SI BIT MS=1
    BNE EXT         ;SI ES 1 ESTENDEMOS SIGNO
    MOVE.W D5,(A3)
    JMP ACTEFLAGS
EXT:
    OR.W #$FF00,D5
    MOVE.W D5,(A0)
ACTEFLAGS:
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    JMP FETCH

*****************************************************************        
;COPIA EL CONTENIDO DE A en B
EMOV:
    MOVE.W EIR,D0
    JSR Xb	       ;Salto a subrutinas Xa y Xb para decodificar los operandos
    JSR Xa
    ;MOVE.W (A3),D5 ;B
    MOVE.W (A4),D6  ;A
    MOVE.W D6,(A3)  ;MOVE.W A,B 
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    JMP FETCH

*****************************************************************            
;MUEVE EL CONTENIDO DE Ti AL OPERANDO DESTINO(M)
ESTO:
    MOVE.W EIR,D5
	AND.W #$0FF0,D5
    LSR.L #4,D5
    MULS.W #2,D5
	MOVE.W D3,A5     ;EN A5 TENEMOS LA DIRECIÓN M 
 	
    AND.W #$000F,EIR ;EN EIR TENEMOS i
 	MOVE.W EIR,D6
	BTST.L #3,D6
	BNE EiT7
	LEA.L EPROG,A6
	ADD A6,A5
	MOVE.W ET6,(A5)
	JMP FETCH
	
EiT7:
    LEA.L EPROG,A6
    ADD.W A6,A5
	MOVE.W ET7,(A5)
	JMP FETCH	

*****************************************************************            
;MUEVE EL CONTENIDO DE M AL OPERANDO DESTINO(Ti)
ELOA:
	MOVE.W EIR,D5
	AND.W #$0FF0,D5
    LSR.L #4,D5
    MULS.W #2,D5
	MOVE.W D5,A5     ;EN A5 TENEMOS LA DIRECIÓN M 
	
	AND.W #$000F,EIR ;EN EIR TENEMOS i
	MOVE.W EIR,D6
	BTST.L #3,D6
	BNE EiT72	
	LEA.L EPROG,A6
    ADD.W A6,A5 
	MOVE.W (A5),ET6
	;ACTUALIZAMOS FLAGS
	MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    JMP FETCH
	
EiT72:
    LEA EPROG,A6
    ADD.W A6,A5
	MOVE.W (A5),ET7
	;ACTUALIZAMOS FLAGS
    MOVE.W SR,D2   ;Guardamos el SR en un registro intermendio para operar
    MOVE.W ESR,D3  ;Guardamos el ESR en un registro intermendio para operar
    JSR EFLAGN     ;Actualización eflag N
    JSR EFLAGZ     ;Actualización eflag Z
    MOVE.W D3,ESR  ;Guardamos los eflags actualizados en su registro correspondiente
    JMP FETCH
	
    ;--- FEXEC: FIN EJECUCION

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

   
************************************************************************
;Subrutina de usuario que actualiza el eflag N
EFLAGN: 
    BTST #3,D2 ;Comparamos el bit 3 del SR, el cual contiene el flag z
    BNE N
    BCLR #2,D3 ; N=0
    RTS
N:  BSET #2,D3 ; N=1    
    RTS
    
;Subrutina de usuario que actualiza el eflag C
EFLAGC:
    BTST #0,D2 ;Comparamos el bit 0 del SR, el cual contiene el flag z
    BNE C
    BCLR #1,D3 ; C=0
    RTS
C:  BSET #1,D3 ; C=1
    RTS

;Subrutina de usuario que actualiza el eflag Z
EFLAGZ:
    BTST #2,D2 ;Comparamos el bit 2 del SR, el cual contiene el flag z
    BNE Z 
    BCLR #0,D3 ; Z=0
    RTS
Z:  BSET #0,D3 ; Z=1
    RTS
************************************************************************
;Subrutina que decodifica el registro del operando A y lo guarda en A4    
Xa:
    BTST.L #7,D0
    BEQ Xa0XX
    BTST.L #6,D0
    BEQ Xa10X
    BTST.L #5,D0
    BEQ Xa110
    LEA.L ET7,A4 ;A es T7 ;111
    RTS
Xa0XX:
    BTST #6,D0
    BEQ Xa00X
    BTST #5,D0
    BEQ Xa010
    LEA.L ER3,A4 ;A es R3 ;011
    RTS
Xa00X:
    BTST #5,D0
    BEQ Xa000
    LEA.L ER1,A4 ;A es R1 ;001
    RTS
Xa010:
    LEA.L ER2,A4 ;A es R2 ;010
    RTS
Xa000:
    LEA.L ER0,A4 ;A es R0 ;000
    RTS
Xa10X:
    BTST.L #5,D0
    BEQ Xa100
    LEA.L ER5,A4 ;A es R5 ;101
    RTS
Xa100: 
    LEA.L ER4,A4 ;A es R4 ;100
    RTS   
Xa110:
    LEA.L ET6,A4 ;A es T6 ;110
    RTS
;Subrutina que decodifica el registro del operando B y lo guarda en A3
Xb:
    BTST.L #2,D0
    BEQ Xb0XX
    BTST.L #1,D0
    BEQ Xb10X
    BTST.L #0,D0
    BEQ Xb110
    LEA.L ET7,A3 ;B es T7 ;110
    RTS
Xb0XX:
    BTST #1,D0
    BEQ Xb00X
    BTST #0,D0
    BEQ Xb010
    LEA.L ER3,A3 ;B es R3 ;011
    RTS
Xb00X:
    BTST #0,D0
    BEQ Xb000
    LEA.L ER1,A3 ;B es R1 ;001
    RTS
Xb010:
    LEA.L ER2,A3 ;B es R2 ;010
    RTS
Xb000:
    LEA.L ER0,A3 ;B es R0 ;000
    RTS
Xb10X:
    BTST.L #0,D0
    BEQ Xb100
    LEA.L ER5,A3 ;B es R5 ;101
    RTS
Xb100: 
    LEA.L ER4,A3 ;B es R4 ;100  
    RTS 
Xb110:
    LEA.L ET6,A3 ;B es T6 ;110
    RTS
            
    ;--- FSUBR: FIN SUBRUTINAS

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
	
    MOVE.L D0,-(A7)
    MOVE.W 8(A7),D0
    BTST #15,D0
    BNE BIT1     
    ;BULCE SI BIT 15 = 1
    BTST #14,D0       ;0  
    BNE BIT1cero
    MOVE.W #0,8(A7)
    JMP FINAL           ;00 Id HLT

BIT1:   
    BTST #14,D0       ;1
    BNE BIT2 
    BTST #13,D0       ;10
    BNE BIT5
    BTST #12,D0       ;100
    BNE BIT6
    BTST #11,D0       ;1000
    BNE BIT7
    MOVE.W #4,8(A7)     ;10000 ID COM
    JMP FINAL
 
   
BIT2: 
    BTST #13,D0       ;11
    BNE BIT3
    BTST #12,D0       ;110
    BNE BIT4
    MOVE.W #12,10(A7)
    JMP FINAL           ;1100 ID MOV
    
BIT3:
    MOVE.W #14,10(A7)
    JMP FINAL           ;1110 Id LOA
    
BIT4: 
    MOVE.W #13,10(A7)
    JMP FINAL           ;1101 Id STO    

BIT5:
    MOVE.W #12,D0       ;101
    BNE BIT9
    MOVE.W #11,D0       ;1010
    BNE BIT10
    MOVE.W #8,10(A7)
    JMP FINAL           ;10100 ID AND
    
    
BIT6:
    BTST #11,D0       ;1001
    BNE BIT8
    MOVE.W #6,10(A7)
    JMP FINAL           ;10010 ID SUB   
    
BIT7:
    MOVE.W #5,10(A7)
    JMP FINAL           ;10001 ID ADD  
    
BIT8:  
    MOVE.W #7,10(A7) 
    JMP FINAL           ;10011 Id NEG 
   
BIT9:
    MOVE.W #11,D0       ;1011
    BNE BIT11
    MOVE.W #10,10(A7)
    JMP FINAL           ;10110 ID NOT
    
    
BIT10:
    MOVE.W #9,10(A7)
    JMP FINAL           ;10101 ID OR     
    
BIT11:
    MOVE.W #11,10(A7)
    JMP FINAL           ;10111 ID SET   
    
      
BIT1cero:               ;0
    BTST #13,D0       ;01
    BEQ BIT2cero  
    MOVE.W #3,10(A7)     ;011
    JMP FINAL           ;0110 ID JMI M
    
BIT2cero:  
    BTST #12,D0       ;010
    BNE BIT3cero
    MOVE.W #1,10(A7)
    JMP FINAL           ;0100 ID JMN M

BIT3cero:
    MOVE.W #2,10(A7)
    JMP FINAL           ;0101 ID JMZ M
    
        
FINAL:
    MOVE.L (A7)+,D0
    RTS
    ;--- FDECOD: FIN DECOD
    END    START



*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
