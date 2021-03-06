    ORG 00H
    JMP START
    ORG 050H
START:
    MOV DPTR, #0100H
    MOV R2, #0FFH
FIRST2:
    MOV R3, #02H
FIRST:
    ACALL INIT
FIRST_LOOP:
    MOV P1, R0
    MOV A, R1
    MOVC A, @A+DPTR
    MOV P0, A
    MOV R4, #0FFH
    DJNZ R4, $
    MOV A, R0
    RL A
    MOV R0, A
    INC R1
    CJNE R1, #05H, FIRST_LOOP
    DJNZ R3, FIRST
    DJNZ R2, FIRST2
    MOV DPTR, #0105H
    MOV R2, #0FFH
SECOND1:
    MOV R3, #02H
SECOND:
    ACALL INIT
SECOND_LOOP:
    MOV P1, R0
    MOV A, R1
    MOVC A, @A+DPTR
    MOV P0, A
    MOV R4, #0FFH
    DJNZ R4, $
    MOV A, R0
    RL A
    MOV R0, A
    INC R1
    CJNE R1, #05H, SECOND_LOOP
    DJNZ R3, SECOND
    DJNZ R2, SECOND1
    MOV DPTR, #010AH
    MOV R2, #0FFH
THIRD1:
    MOV R3, #02H
THIRD:
    ACALL INIT
THIRD_LOOP:
    MOV P1, R0
    MOV A, R1
    MOVC A, @A+DPTR
    MOV P0, A
    MOV R4, #0FFH
    DJNZ R4, $
    MOV A, R0
    RL A
    MOV R0, A
    INC R1
    CJNE R1, #05H, THIRD_LOOP
    DJNZ R3, THIRD
    DJNZ R2, THIRD1
    JMP START
INIT:
   MOV R0, #01H
   MOV R1, #00H
   RET
   ORG 0100H
   DB  00011111B, 00010101B, 01111111B, 00010101B
   DB  00011111B
   DB  01100010B, 01000110B, 01001010B, 01010010B
   DB  01100010B
   DB  01111101B, 01010101B, 00001111B, 00010101B
   DB  01111101B
   END
