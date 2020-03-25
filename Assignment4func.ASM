        ;TITLE   ASSF4   CALLED SUBPROGRAM 
;---------------------------------------------------
        .MODEL  SMALL
        .STACK  64
        .DATA
CR      EQU     0DH
LF      EQU     0AH
MSGF1   DB      CR,LF,'ENTER STRING 1 : ','$'
MSGF2   DB      CR,LF,'ENTER STRING 2 : ','$'
MSGA1   DB      CR,LF,'CONCATINATED STRING IS : ','$'
MSGB1   DB      CR,LF,'THE GIVEN STRINGS ARE EQUAL ','$'
MSGB2   DB      CR,LF,'THE GIVEN STRINGS ARE NOT EQUAL ','$'
MSGC1   DB      CR,LF,'NUMBER OF OCCURENCES : ','$'
MSGD1   DB      CR,LF,'NUMBER OF ALPHABETS : ','$' 
MSGD2   DB      CR,LF,'NUMBER OF SYMBOLS : ','$' 
MSGD3   DB      CR,LF,'NUMBER OF DIGITS : ','$' 

COUNT   DB      30H


STR1    DB      40
        DB      0
        DB      40 DUP('$')
STR2    DB      40
        DB      0
        DB      40 DUP('$')




;----------------------------------------------------
        .CODE

CONPROC PROC    FAR             ;STRING CONCAT
        PUBLIC  CONPROC

        MOV     AH,09H
        LEA     DX,MSGF1
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR1
        INT     21H

        MOV     AH,09H
        LEA     DX,MSGF2
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR2
        INT     21H

        LEA     DI,STR2         ;POINTER TO STR2
        INC     DI
        MOV     DL,[DI]         ;COPY LENGTH
        MOV     DH,00H
        INC     DI      
                
        LEA     SI,STR1         ;INITIALISE A POINTER
        INC     SI              ;POINT TO LENGTH
        MOV     CL,[SI]         ;COPY LENGTH
        ADD     [SI],DL
        ADD     SI,CX
        INC     SI              ;POINT TO THE END


LOOP11:
        MOV     BL,[DI]         ;COPY TO STR1
        MOV     [SI],BL
        INC     SI
        INC     DI
        DEC     CL
        JNZ     LOOP11

        MOV     AH,09H          ;PRINT
        LEA     DX,MSGA1
        INT     21H
        MOV     AH,09H
        LEA     DX,STR1
        INC     DX
        INC     DX
        INT     21H




        RET
CONPROC ENDP
                          
        
COMPPROC PROC   FAR             ;STRING COMPARE
        PUBLIC  COMPPROC

        MOV     AH,09H
        LEA     DX,MSGF1
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR1
        INT     21H

        MOV     AH,09H
        LEA     DX,MSGF2
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR2
        INT     21H

        LEA     SI,STR1
        INC     SI
        MOV     DL,[SI]

        LEA     DI,STR2
        INC     DI
        MOV     DH,[DI]

        CMP     DH,DL           ;LENGTH CHECK
        JNZ     INVAL2

        MOV     CL,DL

LOOP21:
        INC     SI
        MOV     DL,[SI]

        INC     DI
        MOV     DH,[DI]

        CMP     DH,DL           ;STRING CHECK
        JNZ     INVAL2
        DEC     CL
        JNZ     LOOP21

        MOV     AH,09H
        LEA     DX,MSGB1
        INT     21H
        RET

INVAL2:
        MOV     AH,09H
        LEA     DX,MSGB2
        INT     21H
        RET
COMPPROC ENDP

        
SUBSPROC PROC   FAR             ;SUBSTRING
        PUBLIC  SUBSPROC

        MOV     COUNT,30H

        MOV     AH,09H
        LEA     DX,MSGF1
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR1
        INT     21H

        MOV     AH,09H
        LEA     DX,MSGF2
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR2
        INT     21H

        LEA     SI,STR1
        INC     SI
        MOV     CL,[SI]

        LEA     DI,STR2
        INC     DI
        MOV     CH,[DI]

        INC     DI
        INC     SI
        

LOOP31:
        MOV     BH,CH
        MOV     BL,00H
EQUAL:  MOV     DL,[SI]
        MOV     DH,[DI]

        CMP     DH,DL
        JNE     NEQUAL
        INC     DI
        INC     SI
        INC     BL
        DEC     BH
        JNZ     EQUAL
        INC     COUNT


NEQUAL:
        MOV     BH,00H
        SUB     SI,BX
        SUB     DI,BX
        INC     SI
        DEC     CL
        JNZ     LOOP31

        MOV     AH,09H
        LEA     DX,MSGC1
        INT     21H


        MOV     AH,02H
        MOV     DL,COUNT
        INT     21H


        RET
SUBSPROC ENDP

        
DETPROC PROC   FAR             ;STRING DETAILS
        PUBLIC  DETPROC

        MOV     AH,09H
        LEA     DX,MSGF1
        INT     21H

        MOV     AH,0AH
        LEA     DX,STR1
        INT     21H

        LEA     SI,STR1
        INC     SI
        MOV     CL,[SI]
        INC     SI
        MOV     BH,30H          ;ALPHA
        MOV     BL,30H          ;NUM
        MOV     CH,30H          ;SYMBOLS

LOOP41:
        MOV     DL,[SI]

        CMP     DL,29H
        JNG     SYMBOLS
        CMP     DL,39H
        JNG     NUMBERS
        CMP     DL,40H
        JNG     SYMBOLS
        CMP     DL,5AH
        JNG     ALPHA
        CMP     DL,60H
        JNG     SYMBOLS
        CMP     DL,7AH
        JNG     ALPHA
        JMP     SYMBOLS

SYMBOLS:
        INC     CH
        JMP     LOOPT

ALPHA:
        INC     BH
        JMP     LOOPT

NUMBERS:
        INC     BL

LOOPT:
        INC     SI
        DEC     CL
        JNZ     LOOP41



EXIT4:
        MOV     AH,09H          ;ALPHA
        LEA     DX,MSGD1
        INT     21H
        MOV     AH,02H
        MOV     DL,BH
        INT     21H

        MOV     AH,09H          ;DIGIT
        LEA     DX,MSGD3
        INT     21H
        MOV     AH,02H
        MOV     DL,BL
        INT     21H

        MOV     AH,09H          ;SYMBOLS
        LEA     DX,MSGD2
        INT     21H
        MOV     AH,02H
        MOV     DL,CH
        INT     21H
        
        RET
DETPROC ENDP



        END     





