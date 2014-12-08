   ORG 00H
   JMP INIT
   ORG 0BH
   JMP T0INT
   ORG 1BH
   JMP T1INT
   ORG 050H
FRE_HIGH REG R3
FRE_LOW REG R4
INIT:
   MOV IE, #10001010B
   MOV TMOD, #00010001B
   MOV  R7, #20
   SETB IP.1
SCAN0:
   MOV P1, #7FH
   JNB P1.0, dBt0
SCAN4:
   JNB P1.1, dBt4
SCAN8:
   JNB P1.2, dBt8
SCAN1:
   MOV P1, #0BFH
   JNB P1.0, dBt1
SCAN5:
   JNB P1.1, dBt5
SCAN9:
   JNB P1.2, dBt9
SCAN2:
   MOV P1, #0DFH
   JNB P1.0, dBt2
SCAN6:
   JNB P1.1, dBt6
SCANA:
   JNB P1.2, dBtA
SCAN3:
   MOV P1, #0EFH
   JNB P1.0, dBt3
SCAN7:
   JNB P1.1, dBt7
SCANB:
   JNB P1.2, dBtB
   LJMP SCAN0
dBt0:
   LJMP dB0
dBt4:
   LJMP dB4
dBt8:
   LJMP dB8
dBt1:
   LJMP dB1
dBt5:
   LJMP dB5
dBt9:
   LJMP dB9
dBt2:
   LJMP dB2
dBt6:
   LJMP dB6
dBtA:
   LJMP dBA
dBt3:
   LJMP dB3
dBt7:
   LJMP dB7
dBtB:
   LJMP dBB
dB0:
   LCALL DELAY
   JB P1.0, temp4
   MOV DPTR, #FRE_So1 ;Set Frequency
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp4:
   LJMP SCAN4
dB4:
   LCALL DELAY
   JB P1.1, temp8
   MOV DPTR, #FRE_Re1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp8:
   LJMP SCAN8
dB8:
   LCALL DELAY
   JB P1.2, temp1
   MOV DPTR, #FRE_La2
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp1:
   LJMP SCAN1
dB1:
   LCALL DELAY
   JB P1.0, temp5
   MOV DPTR, #FRE_La1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp5:
   LJMP SCAN5
dB5:
   LCALL DELAY
   JB P1.1, temp9
   MOV DPTR, #FRE_Mi1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp9:
   LJMP SCAN9
dB9:
   LCALL DELAY
   JB P1.2, temp2
   MOV DPTR, #FRE_Si2
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp2:
   LJMP SCAN2
dB2:
   LCALL DELAY
   JB P1.0, temp6
   MOV DPTR, #FRE_Si1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp6:
   LJMP SCAN6
dB6:
   LCALL DELAY
   JB P1.1, tempA
   MOV DPTR, #FRE_Fa1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
tempA:
   LJMP SCANA
dBA:
   LCALL DELAY
   JB P1.2, temp3
   MOV DPTR, #FRE_Do2
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp3:
   LJMP SCAN3
dB3:
   LCALL DELAY
   JB P1.0, temp7
   MOV DPTR, #FRE_Do1
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
temp7:
   LJMP SCAN7
dB7:
   LCALL DELAY
   JB P1.1, tempB
   MOV DPTR, #FRE_So2
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
   LJMP SCAN0
tempB:
   LJMP SCANB
dBB:
   LCALL DELAY
   JB P1.2, temp0
   MOV DPTR, #FRE_Re2
   LCALL GET_FRE
   MOV  R7, #20
   SETB TF0
   SETB TF1
temp0:
   LJMP SCAN0
GET_FRE:
   MOV A, #0
   MOVC A, @A+DPTR
   MOV FRE_HIGH, A
   MOV A, #1
   MOVC A, @A+DPTR
   MOV FRE_LOW, A
   RET
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
   ;set timer -> higher byte
   MOV TH0, FRE_HIGH
   ;set timer -> lower byte
   MOV TL0, FRE_LOW
   ;start the timer0
   SETB TR0
   RETI

T1INT:
   CLR TR1  ;stop the timer1
   DJNZ R7, SET_TIMER1  ;whether if the timer1 counts to 1 sec
   CLR TR0  ;stop the timer0 and the sound output
   RETI
SET_TIMER1:
   ;set 50ms
   MOV TL1, #0B0H
   MOV TH1, #3CH
   SETB TR1
   RETI
FRE_So1:
    DB  0FBH, 04H   ;Higher byte, Lower byte
FRE_La1:
    DB  0FBH, 90H
FRE_Si1:
    DB  0FCH, 0CH
FRE_Do1:
    DB  0FCH, 44H
FRE_Re1:
    DB  0FCH, 0ACH
FRE_Mi1:
    DB  0FDH, 09H
FRE_Fa1:
    DB  0FDH, 34H
FRE_So2:
    DB  0FDH, 83H
FRE_La2:
    DB  0FDH, 0C8H
FRE_Si2:
    DB  0FEH, 0BH
FRE_Do2:
    DB  0FEH, 22H
FRE_Re2:
    DB  0FEH, 56H
    END
