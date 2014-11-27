   ORG 00H
LOOP:
  MOV R0, #00H       ;Mask--All can be direct controll from switch
  ACALL DELAY        ;delay 2s
  ACALL DELAY
  MOV R0, #FFH       ;Mask--ALL off
  ACALL DELAY        ;delay 1s
  JMP LOOP
DELAY:
   MOV R1, #FFH
DELAY1:
   MOV R2, #FFH
DELAY2:
   MOV R3, #05H
DELAY3:
   MOV A, R0         
   ORL A, P2        ;Mask
   MOV P1, A
   DJNZ R3, DELAY3
   DJNZ R2, DELAY2
   DJNZ R1, DELAY1
   RET
END
