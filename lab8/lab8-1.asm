    ORG 00H
    JMP INIT
    ORG 23H
    JMP INTERRUPT
    ORG 50H
INIT:
    MOV SCON, #01010000B    ;設定為Mode 1, Receive enable
    ANL PCON, #01111111B    ;SMOD = 0, 使得輸入的clock被除上32
    MOV IE, #10010000B      ;啟動中斷
    MOV TMOD, #00100000B    ;設定Timer 1為Mode 2
    MOV TH1, #0F3H          ;設定鮑率
    SETB TR1                ;啟動Timer 1
    JMP $
INTERRUPT:
    JNB RI, END_INTER   ;判斷是否為接收到資料
    CLR RI      ;清空接收完成Flag
    MOV A, SBUF ;接收資料
    MOV SBUF, A ;傳輸資料
END_INTER:
    CLR TI  ;清除傳輸完成Flag
    RETI
    END
