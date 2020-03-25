                page 60,132         
 
;---------------------------------------------------
        .MODEL  SMALL
        .STACK  64
        .DATA
CR      EQU     0DH    
LF      EQU     0AH
STR1    DB      40
        DB      0
        DB      40 DUP (0)
STRR    DB      40 DUP (0)

MSG1    DB      CR,LF,'INPUT STRING : ','$'
MSG2    DB      CR,LF,CR,LF,'GIVEN STRING IS : ','$'
MSG3    DB      CR,LF,'LENGTH OF STRING IS : ','$'
MSG4    DB      CR,LF,'REVERSE OF STRING IS : ','$'
MSG5    DB      CR,LF,'STRING IS A PALINDROME ','$'
MSG6    DB      CR,LF,'STRING IS NOT A PALINDROME ','$',CR,LF


;---------------------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX

        LEA     SI,STR1         ;INITIALISATIONS
        INC     SI


        MOV     AH,09H          ;INPUT
        LEA     DX,MSG1
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR1
        INT     21H

        MOV     CL,[SI]
        ADD     SI,CX
        INC     SI
        MOV     DL,24H
        MOV     [SI],DL

        MOV     AH,09H          ;DISPLAY
        LEA     DX,MSG2
        INT     21H

        MOV     AH,09H
        LEA     DX,STR1
        INC     DX
        INC     DX
        INT     21H

        MOV     AH,09           ;LENGTH
        LEA     DX,MSG3
        INT     21H
        MOV     CH,CL           ;BACKUP LENGTH
        ADD     CL,30H
        MOV     AH,02H
        MOV     DL,CL
        INT     21H
        


        LEA     DI,STRR         ;REVERSE
        SUB     CL,30H

        MOV     AH,09H
        LEA     DX,MSG4
        INT     21H

LOOPA:
        DEC     SI
        MOV     DL,[SI]
        MOV     [DI],DL
        INC     DI
        DEC     CL
        JNZ     LOOPA

        MOV     DL,24H
        MOV     [DI],DL

        MOV     AH,09H
        LEA     DX,STRR
        INT     21H


        LEA     DI,STRR         ;PALINDROME
LOOPB:
        MOV     DL,[DI]
        MOV     DH,[SI]
        CMP     DH,DL
        JNE     LOOPNP
        INC     SI
        INC     DI
        DEC     CH
        JNZ     LOOPB

        MOV     AH,09H          ;IT IS PALINDROME
        LEA     DX,MSG5
        INT     21H
        JMP     END1

LOOPNP:
        MOV     AH,09H          ;IT IS NOT PALINDROME
        LEA     DX,MSG6
        INT     21H   

END1:
        MOV     AH,4CH
        INT     21H

MAIN    ENDP
        END     MAIN


        

