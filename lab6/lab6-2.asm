   ORG 00H
   JMP INIT
   ORG 0BH
   JMP T0INT
   ORG 1BH
   JMP T1INT
   ORG 050H
FRE_HIGH REG R3
FRE_LOW REG R4
MUSIC REG R6
TEMPO REG R7
PLAY REG 20H.0
INIT:
   MOV IE, #10001010B
   MOV TMOD, #00010001B
   MOV MUSIC, #00H
   MOV DPTR, #MUSIC_TABLE
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_HIGH, A
   INC MUSIC
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_LOW, A
   INC MUSIC
MAIN:      ;play key
   MOV P1, #7FH
   JNB P1.0, dB0
SCAN1:      ;pause key
   MOV P1, #0BFH
   JNB P1.0, dB1
SCAN2:      ;restart key
   MOV P1, #0DFH
   JNB P1.0, dB2
   JMP MAIN
dB0:
   ACALL DELAY
   JB P1.0, MAIN
   MOV  TEMPO, #6

   SETB TF0
   SETB TF1
   JMP MAIN
dB1:
   ACALL DELAY
   JB P1.0, MAIN

   ;MOV  R7, #20
   CLR TR1
   CLR TR0
   JMP MAIN
dB2:
   ACALL DELAY
   JB P1.0, MAIN
   ;MOV  R7, #20
   MOV  TEMPO, #6
   CLR TR1
   CLR TR0
   MOV MUSIC, #00H
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_HIGH, A
   INC MUSIC
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_LOW, A
   INC MUSIC
   JMP MAIN

DELAY:
   MOV R0, #0AFH
DELAY1:
   MOV R1, #0AH
   DJNZ R1, $
   DJNZ R0, DELAY1
   RET
T0INT:
   CPL P2.0  ;invert the output
   CLR TR0  ;stop the timer0
   MOV TH0, FRE_HIGH ;set timer -> higher byte
   MOV TL0, FRE_LOW ;set timer -> lower byte
   SETB TR0 ;start the timer0
   RETI
T1INT:
   CLR TR1  ;stop the timer1
   DJNZ TEMPO, SET_TIMER1  ;whether if the timer1 last long enough
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_HIGH, A
   INC MUSIC
   MOV A, MUSIC
   MOVC A, @A+DPTR
   MOV FRE_LOW, A
   INC MUSIC
   CJNE MUSIC, #7CH, RETURN
   MOV MUSIC, #2
RETURN:
   MOV  TEMPO, #6
   SETB TR0
SET_TIMER1:
   ;set 50ms
   MOV TL1, #0B0H
   MOV TH1, #3CH
   SETB TR1
   RETI
MUSIC_TABLE:
   ;DB 0FBH, 04H, 0FBH, 90H, 0FCH, 0CH, 0FCH, 44H, 0FCH, 0ACH, 0FDH, 09H
   ;DB 0FDH, 34H, 0FDH, 83H,0FDH, 0C8H, 0FEH, 0BH, 0FEH, 22H, 0FEH, 56H
   DB 0FDH, 09H, 0FDH, 09H, 0FDH, 5CH, 0FDH, 83H, 0FDH, 83H, 0FEH, 085H
   DB 0FEH, 085H, 0FEH, 56H, 0FEH, 56H, 0FEH, 56H, 0FEH, 56H, 0FEH, 22H
   DB 0FEH, 0BH, 0FEH, 22H, 0FEH, 56H, 0FEH, 56H, 0FDH, 83H, 0FDH, 83H
   DB 0FDH, 83H, 0FEH, 22H, 0FEH, 0BH, 0FEH, 0BH, 0FEH, 0BH, 0FEH, 0BH
   DB 0FEH, 22H, 0FEH, 0BH, 0FDH, 0C8H, 0FDH, 83H, 0FDH, 83H, 0FEH, 0BH
   DB 0FEH, 56H, 0FEH, 56H, 0FEH, 56H, 0FEH, 56H, 0FDH, 83H, 0FDH, 83H
   DB 0FDH, 83H, 0FDH, 83H, 0FEH, 0BH, 0FEH, 56H, 0FEH, 56H, 0FEH, 56H
   DB 0FEH, 56H, 0FCH, 0ACH,0FEH, 22H, 0FEH, 22H, 0FEH, 0BH, 0FDH, 0C8H
   DB 0FDH, 0C8H, 0FDH, 0C8H, 0FDH, 83H, 0FDH, 0C8H ,0FDH, 0C8H, 0FDH, 0C8H
   DB 0FDH, 0C8H, 0FDH, 83H, 0FDH, 83H, 0FDH, 5CH, 0FDH, 83H, 0FDH, 83H
   DB 0FDH, 83H, 0FDH, 83H
   END
