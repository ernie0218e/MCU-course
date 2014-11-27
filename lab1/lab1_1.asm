   ORG 00H
START:
   MOV A, #FFH
LOOP:
   MOV P1, A;     led output
   ACALL DELAY
   CPL A;         invert output
   JMP LOOP
DELAY:
   MOV R0, #FFH
DELAY1:
   MOV R1, #FFH
DELAY2:
   MOV R2, #03H
DELAY3:
   DJNZ R2, $
   DJNZ R1, DELAY2
   DJNZ R0, DELAY1
   RET
END
