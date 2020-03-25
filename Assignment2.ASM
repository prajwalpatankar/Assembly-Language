                page 60,132         
 
;---------------------------------------------------
        .MODEL  SMALL
        .STACK  64
        .DATA
CR      EQU     0DH
LF      EQU     0AH
MSG1    DB      CR,LF,CR,LF,'MENU:: ',CR,LF,'(1)HEX TO BCD',CR,LF,'(2)BCD TO HEX',CR,LF,'(3)EXIT',CR,LF,'ENTER CHOICE : ','$'
MSG2    DB      CR,LF,'ENTER HEX NUMBER : ','$'
MSG3    DB      CR,LF,'ENTER BCD NUMBER : ','$'
MSG4    DB      CR,LF,'EQUIVALENT DECIMAL NUMBER : ','$'
MSG5    DB      CR,LF,'EQUIVALENT HEX NUMBER : ','$'
MSGIN   DB      CR,LF,'INVALID BCD NUMBER ! ','$'
NUM     DW      0000H
ARR     DB      5 DUP(0)
COUNT   DB      05H
ARR2    DB      20 DUP(0)
NUM2    DB      04H     ;COUNTER
MSGS    DB      ' ','$'
MSGN    DB      CR,LF,'EQUIVALENT BCD : ','$'
MSGI    DB      CR,LF,'INVALID',CR,LF,'$'


;---------------------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX


LOOP1:
        MOV     AH,09H
        LEA     DX,MSG1
        INT     21H

        MOV     AH,01H
        INT     21H

        CMP     AL,32H
        JZ      LABEL1
        JNC     LABEL3

        CALL    HEXTOBCD
        JMP     LOOP1




LABEL1:                         ;BCD TO HEX
        CALL    BCDTOHEX




        JMP     LOOP1







LABEL3:                         ;EXIT
        MOV     AX,4C00H
        INT     21H




        ;HEX TO BCD
HEXTOBCD PROC
        MOV     COUNT,05H
        MOV     NUM,0000H
        MOV     BX,0000H
        MOV     CL,04H
        MOV     CH,04H

        MOV     AH,09H          ;PRINT 
        LEA     DX,MSG2
        INT     21H
LOOP2:
        MOV     AH,01H
        INT     21H
        CMP     AL,39H
        JNG     SMALL1
        SUB     AL,07H
SMALL1: SUB     AL,30H
        MOV     AH,00H
        ADD     NUM,AX
        ROL     NUM,CL
        DEC     CH
        JNZ     LOOP2

        ROR     NUM,CL

        MOV     AX,NUM
        MOV     DX,0000H
        MOV     BX,000AH
        LEA     SI,ARR

LOOP3:
        DIV     BX
        MOV     [SI],DL
        INC     SI
        MOV     DX,0000H
        DEC     COUNT
        JNZ     LOOP3

        MOV     AH,09H
        LEA     DX,MSG4
        INT     21H



        MOV     CH,05H
        LEA     DI,ARR2

LOOP4:
        DEC     SI
        MOV     DL,[SI]
        ADD     DL,30H
        MOV     AH,02H
        INT     21H


        MOV     CL,04H          ;BINARY CONVERSION
        MOV     AL,[SI]
        MOV     AH,00H
        MOV     BL,02H
BIN1:
        MOV     DX,0000H
        DIV     BX
        ADD     DL,30H
        MOV     [DI],DX
        INC     DI
        DEC     CL
        JNZ     BIN1

        DEC     CH
        JNZ     LOOP4

        
        MOV     AH,09H
        LEA     DX,MSGN
        INT     21H


        SUB     DI,11H
        MOV     BH,05H

LOOP6:
        MOV     BL,04

LOOP5:
        MOV     AH,02H
        MOV     DL,[DI]
        INT     21H
        DEC     DI
        DEC     BL
        JNZ     LOOP5
        ADD     DI,08H

        MOV     AH,09H
        LEA     DX,MSGS
        INT     21H

        DEC     BH
        JNZ     LOOP6

        RET     
        ENDP



        ;BCDTOHEX
BCDTOHEX PROC

        MOV     AH,09H
        LEA     DX,MSG3
        INT     21H

        MOV     AH,01H
        INT     21H
        CMP     AL,31H
        JG      INVA1
        MOV     BH,AL 
        MOV     CH,04

        MOV     AH,01H
        INT     21H
        CMP     AL,31H
        JG      INVA1
        SUB     AL,30H
        MOV     DL,AL
        MOV     CL,03
        ROL     DL,CL
        DEC     CL

        MOV     AH,01H
        INT     21H
        CMP     AL,31H
        JG      INVA1
        MOV     AH,00H
        SUB     AL,30H
        ROL     AL,CL
        ADD     DL,AL
        DEC     CL
        
        MOV     AH,01H
        INT     21H
        CMP     AL,31H
        JG      INVA1
        MOV     AH,00H
        SUB     AL,30H
        ROL     AL,CL
        ADD     DL,AL
        DEC     CL

        MOV     AH,01H
        INT     21H
        CMP     AL,31H
        JG      INVA1
        SUB     AL,30H
        ADD     DL,AL
        ADD     DL,30H
        MOV     BL,DL
        CMP     BL,39H
        JG      INVA1

        MOV     AH,09H
        LEA     DX,MSG5
        INT     21H

        MOV     AH,02H
        MOV     DL,BH
        INT     21H

        MOV     AH,02H
        MOV     DL,BL
        INT     21H
        RET

INVA1:
        MOV     AH,09H
        LEA     DX,MSGIN
        INT     21H
        RET

        ENDP



MAIN    ENDP
        END     MAIN

