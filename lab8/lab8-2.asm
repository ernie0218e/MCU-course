    ORG 00H
    JMP INIT
    ORG 23H
    JMP INTERRUPT
    ORG 50H
INDEX REG R0    ;指向第幾個ROW
INIT:
    MOV SCON, #01010000B    ;設定為Mode 1, Receive enable
    ANL PCON, #01111111B    ;SMOD = 0, 使得輸入的clock除以32作為鮑率
    MOV IE, #10010000B      ;啟動中斷
    MOV TMOD, #00100000B    ;設定Timer 1為Mode 2
    MOV TH1, #0F3H          ;設定鮑率
    SETB TR1                ;啟動Timer 1
    MOV INDEX, #0           ;歸零Row
    ;掃描鍵盤
KEY_PAD:
    ;掃描第一個Column
    MOV DPTR, #KEY1
    MOV P1, #7FH
    ACALL READ_KEY
    ;掃描第二個Column
    MOV DPTR, #KEY2
    MOV P1, #0BFH
    ACALL READ_KEY
    ;掃描第三個Column
    MOV DPTR, #KEY3
    MOV P1, #0DFH
    ACALL READ_KEY
    ;掃描第四個Column
    MOV DPTR, #KEY4
    MOV P1, #0EFH
    ACALL READ_KEY
    JMP KEY_PAD
READ_KEY:   ;判斷是哪一個按鍵被按下
    ;判斷第一個Row的按鍵
    MOV INDEX, #0
    JNB P1.0, DEB1
    ;判斷第二個Row的按鍵
    INC INDEX   ;遞增Row的Index
    JNB P1.1, DEB2
    ;判斷第三個Row的按鍵
    INC INDEX
    JNB P1.2, DEB3
    ;判斷第四個Row的按鍵
    INC INDEX
    JNB P1.3, DEB4
    RET
DEB1:
    ACALL DELAY ;Debounce用delay
    JB P1.0, READ_KEY   ;若沒按下就重新掃描
    JMP TEMP    ;若有按下則跳至判斷是否持續按著
DEB2:
    ACALL DELAY
    JB P1.1, READ_KEY
    JMP TEMP
DEB3:
    ACALL DELAY
    JB P1.2, READ_KEY
    JMP TEMP
DEB4:
    ACALL DELAY
    JB P1.3, READ_KEY
TEMP:
    JNB P1.0, $ ;按鍵放開才會送出值
    JNB P1.1, $
    JNB P1.2, $
    JNB P1.3, $
SEND:
    MOV A, INDEX    ;擷取相對應按鍵的字元
    MOVC A, @A+DPTR
    MOV SBUF, A     ;送出字元
    RET
DELAY:  ;作為Debounce用的Delay
   MOV R6, #0AFH
DELAY1:
   MOV R7, #0AH
   DJNZ R7, $
   DJNZ R6, DELAY1
   RET
INTERRUPT:
    JNB TI, END_INTER   ;判斷是否傳輸完畢
    CLR TI  ;清除傳輸完成Flag
END_INTER:
    CLR RI  ;清空接收完成Flag
    RETI
;按鍵相對應的字元值
KEY1:
    DB "048C"
KEY2:
    DB "159D"
KEY3:
    DB "26AE"
KEY4:
    DB "37BF"
    END
