                page 60,132         
 
;---------------------------------------------------
        .MODEL  SMALL
        .STACK  64
        .DATA
CR      EQU     0DH
LF      EQU     0AH
MSG1    DB      'ENTER NUMBER OF ELEMENTS (MAX 9) : ','$',CR,LF
MSG2    DB      CR,LF,'ENTER NUMBER : ','$'
MSG3    DB      CR,LF,'RESULT : ','$'
ARR     DB      50 DUP(0)
AR3     DB      CR,LF,'GIVEN ARRAY : ','$'
ALP     DB      '  ','$'
LIM     DB      ?
;---------------------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX

        MOV     AH,09H         ;ENTER NO OF ELEMENTS
        MOV     DX,SEG  MSG1
        MOV     DS,DX
        LEA     DX,MSG1
        INT     21H

        MOV     AH,01H
        INT     21H
        MOV     CL,AL
        SUB     CL,30H

        MOV     CH,00H          ;INITIALISATIONS
        MOV     BH,00H
        MOV     BL,00H
        LEA     SI,ARR

         
        MOV     LIM,CL          ;STORE COUNT FOR PRINTING ARRAY


LOOP1:
        MOV     AH,09H          ;ENTER NUMBER
        MOV     DX,SEG  MSG2
        MOV     DS,DX
        LEA     DX,MSG2
        INT     21H


        MOV     AH,01H          ;TENS PLACE
        INT     21H
        MOV     [SI],AL
        INC     SI
        SUB     AL,30H
        ADD     AL,BH
        MOV     AH,00H
        AAA
        MOV     BH,AL
        ADD     CH,AH




        MOV     AH,01H          ;UNITS PLACE
        INT     21H
        MOV     [SI],AL
        INC     SI
        SUB     AL,30H
        ADD     AL,BL
        MOV     AH,00H
        AAA
        MOV     BL,AL
        ADD     BH,AH

        MOV     AL,BH           ;TO CHECK IF ADDITION IS ABOVE 100
        MOV     AH,CH
        AAA
        MOV     BH,AL
        MOV     CH,AH


        DEC     CL
        JNZ     LOOP1

        MOV     AH,09H       
        MOV     DX,SEG  MSG3    ;RESULT
        MOV     DS,DX
        LEA     DX,MSG3
        INT     21H

        ADD     CH,30H
        MOV     AH,02H
        MOV     DL,CH
        INT     21H

        ADD     BH,30H
        MOV     AH,02H
        MOV     DL,BH
        INT     21H

        ADD     BL,30H
        MOV     AH,02H
        MOV     DL,BL
        INT     21H



        MOV     AH,09H       
        MOV     DX,SEG  AR3    ;GIVEN ARRAY
        MOV     DS,DX
        LEA     DX,AR3
        INT     21H


        MOV     BL,LIM
LOOP2:
        DEC     SI
        DEC     SI
        DEC     LIM
        JNZ     LOOP2

LOOP3:
        MOV     AH,02H
        MOV     DL,[SI]
        INT     21H
        INC     SI

        MOV     AH,02H
        MOV     DL,[SI]
        INT     21H
        INC     SI
        
        MOV     AH,09H       
        MOV     DX,SEG  ALP    ;COMMA
        MOV     DS,DX
        LEA     DX,ALP
        INT     21H

        DEC     BL
        JNZ     LOOP3




        MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN
                     
