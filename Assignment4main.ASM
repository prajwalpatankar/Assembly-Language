        TITLE   ASSM4       
 
;---------------------------------------------------
        .MODEL  SMALL
        .STACK  64

        EXTRN   CONPROC:FAR
        EXTRN   COMPPROC:FAR
        EXTRN   SUBSPROC:FAR
        EXTRN   DETPROC:FAR

        .DATA
CR      EQU     0DH
LF      EQU     0AH
MENU1   DB      CR,LF,CR,LF,'MENU::',CR,LF,'(1)CONCATINATE STRINGS',CR,LF,'(2)COMPARE STRINGS',CR,LF,'(3)CHECK SUBSTRING',CR,LF,'(4)STRING DETAILS',CR,LF,'(5)EXIT',CR,LF,'  ENTER YOUR CHOICE : ','$'
MSGIN   DB      CR,LF,'INVALID CHOICE !!!','$'
STR1    DB      40
        DB      0
        DB      40 DUP(0)
STR2    DB      40
        DB      0
        DB      40 DUP(0)

;----------------------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX


LOOP1:
        MOV     AH,09H
        LEA     DX,MENU1
        INT     21H

        MOV     AH,01H
        INT     21H

        CMP     AL,31H
        JE      CONCAT
        CMP     AL,32H
        JE      COMPARE
        CMP     AL,33H
        JE      SUBST
        CMP     AL,34H
        JE      DETAIL
        CMP     AL,35H
        JE      EXIT1

        MOV     AH,09H
        LEA     DX,MSGIN
        INT     21H
        JMP     LOOP1


CONCAT:
        CALL    CONPROC
        JMP     LOOP1


COMPARE:
        CALL    COMPPROC
        JMP     LOOP1

SUBST:
        CALL    SUBSPROC
        JMP     LOOP1

DETAIL:
        CALL    DETPROC
        JMP     LOOP1

EXIT1:

        MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN
