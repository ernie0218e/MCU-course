    ORG 00H
    JMP INIT
    ORG 50H
LCD MACRO DATA      ;LCD Display
    MOV P1, #101B   ;set mode
    MOV P0, DATA    ;send data
    MOV P1, #000B   ;complete!
    ACALL BUSY
    ENDM
INIT:
    MOV DPTR, #0400H
    MOV R0, #00H
    MOV R1, #00H
    MOV R2, #00H
    ;Initialize the LCD
    MOV P1, #100B
    MOV P0, #00111000B
    MOV P1, #000B
    ACALL DELAY
    MOV P1, #100B
    MOV P0, #00001110B
    MOV P1, #000B
    ACALL DELAY
    MOV P1, #100B
    MOV P0, #00000110B
    MOV P1, #000B
    ACALL DELAY
    ACALL CLEAR ;Clear the Screen
FIRST:  ;display the first line
    MOV A, R0
    MOVC A, @A+DPTR
    LCD A
    INC R0
    ACALL DELAY
    CJNE R0, #11H, FIRST
    MOV P1, #100B   ;Change to the next line
    MOV P0, #0C0H
    MOV P1, #000B
    ACALL BUSY
SECOND: ;display the second line & shift the screen
    MOV A, R0
    MOVC A, @A+DPTR
    LCD A
    INC R0
    ACALL DELAY
    CJNE R0, #21H, SECOND
    ACALL SHIFT ;shift the screen
    MOV A, R0
    MOVC A, @A+DPTR
    LCD A
    ACALL DELAY
    ACALL SHIFT
    INC R0
    MOV A, R0
    MOVC A, @A+DPTR
    LCD A
    SJMP $
CLEAR:
    MOV P1, #100B
    MOV P0, #01H
    MOV P1, #000B
    ACALL BUSY
    RET
SHIFT:
    MOV P1, #100B   ;shift screen
    MOV P0, #18H
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
    DB  "Microcomputer is very interesting!!"
    END


