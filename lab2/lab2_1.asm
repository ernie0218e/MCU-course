   ORG 00H
   JMP START
   ORG 0500H
START:
   MOV DPTR, #0600H
   MOV R0, #00H
UP:
   ACALL LED
   INC R0
   CJNE R0, #09H, UP
   SJMP DOWN
DOWN:
   ACALL LED
   DJNZ R0, DOWN
   SJMP UP
LED:
   MOV A, R0
   MOVC A, @A+DPTR
   MOV P1, A
   ACALL DELAY
   RET
DELAY:
   MOV R1, #0FFH
DELAY1:
   MOV R2, #0F4H
DELAY2:
   MOV R3, #04H
   DJNZ R3, $
   DJNZ R2, DELAY2
   DJNZ R1, DELAY1
   RET
   ORG 0600H
   DB 11000000B, 11111001B, 10100100B, 10110000B
   DB 10011001B, 10010010B, 10000010B, 11111000B
   DB 10000000B, 10010000B
   END
