    ORG 00H
    JMP INIT
    ORG 50H
LCD MACRO DATA      ;LCD Display
    MOV P1, #101B   ;set mode
    MOV P0, DATA    ;send data
    MOV P1, #000B   ;complete!
    ACALL BUSY      ;check busy flag
    ENDM
INIT:
    MOV DPTR, #0400H    ;Set LCD Data Mode(8bit, 2 rows, 5*7)
    MOV R0, #00H
    MOV R2, #00H
    MOV P1, #100B
    MOV P0, #00111000B
    MOV P1, #000B
    ACALL DELAY         ;Wait for the process
    MOV P1, #100B       ;Set the display & the cursor on
    MOV P0, #00001110B
    MOV P1, #000B
    ACALL DELAY         ;Wait for the LCD process
    MOV P1, #100B       ;Set how the display & the cursor shift
    MOV P0, #00000110B
    MOV P1, #000B
    ACALL DELAY
    ACALL CLEAR         ;Clear the screen
MAIN:
    MOV A, R0
    MOVC A, @A+DPTR     ;Point to the String
    MOV R1, A
    LCD R1              ;Show the character
    INC R0
    ACALL DELAY         ;the time interval between two character display
    CJNE R0, #0FH, MAIN
    INC R2
    MOV R0, #00H
    MOV DPTR, #0410H
    MOV P1, #100B   ;Change to the next line
    MOV P0, #0C0H
    MOV P1, #000B
    ACALL BUSY
    CJNE R2, #02H, MAIN
    SJMP $
CLEAR:
    MOV P1, #100B
    MOV P0, #01H
    MOV P1, #000B
    ACALL BUSY
    RET
BUSY:
    MOV P0, #0FFH   ;Important!!, Initialize
    MOV P1, #110B   ;detect busy flag, 3Byte
    MOV A, P0       ;2Byte
    MOV P1, #010B   ;end detect, 3Byte
    ANL A, #80H     ;2Byte
    JNZ $-10        ;if LCD is busy, wait & detect again
    RET
DELAY:
    MOV R3, #0FFH
DELAY2:
    MOV R4, #0FFH
    DJNZ R4, $
    DJNZ R3, DELAY2
    RET
    ORG 0400H
    DB  "Hello!!         "
    DB  "ID:0210749      "
    END

