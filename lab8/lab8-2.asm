    ORG 00H
    JMP INIT
    ORG 23H
    JMP INTERRUPT
    ORG 50H
INDEX REG R0    ;���V�ĴX��ROW
INIT:
    MOV SCON, #01010000B    ;�]�w��Mode 1, Receive enable
    ANL PCON, #01111111B    ;SMOD = 0, �ϱo��J��clock���H32�@���j�v
    MOV IE, #10010000B      ;�Ұʤ��_
    MOV TMOD, #00100000B    ;�]�wTimer 1��Mode 2
    MOV TH1, #0F3H          ;�]�w�j�v
    SETB TR1                ;�Ұ�Timer 1
    MOV INDEX, #0           ;�k�sRow
    ;���y��L
KEY_PAD:
    ;���y�Ĥ@��Column
    MOV DPTR, #KEY1
    MOV P1, #7FH
    ACALL READ_KEY
    ;���y�ĤG��Column
    MOV DPTR, #KEY2
    MOV P1, #0BFH
    ACALL READ_KEY
    ;���y�ĤT��Column
    MOV DPTR, #KEY3
    MOV P1, #0DFH
    ACALL READ_KEY
    ;���y�ĥ|��Column
    MOV DPTR, #KEY4
    MOV P1, #0EFH
    ACALL READ_KEY
    JMP KEY_PAD
READ_KEY:   ;�P�_�O���@�ӫ���Q���U
    ;�P�_�Ĥ@��Row������
    MOV INDEX, #0
    JNB P1.0, DEB1
    ;�P�_�ĤG��Row������
    INC INDEX   ;���WRow��Index
    JNB P1.1, DEB2
    ;�P�_�ĤT��Row������
    INC INDEX
    JNB P1.2, DEB3
    ;�P�_�ĥ|��Row������
    INC INDEX
    JNB P1.3, DEB4
    RET
DEB1:
    ACALL DELAY ;Debounce��delay
    JB P1.0, READ_KEY   ;�Y�S���U�N���s���y
    JMP TEMP    ;�Y�����U�h���ܧP�_�O�_�������
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
    JNB P1.0, $ ;�����}�~�|�e�X��
    JNB P1.1, $
    JNB P1.2, $
    JNB P1.3, $
SEND:
    MOV A, INDEX    ;�^���۹������䪺�r��
    MOVC A, @A+DPTR
    MOV SBUF, A     ;�e�X�r��
    RET
DELAY:  ;�@��Debounce�Ϊ�Delay
   MOV R6, #0AFH
DELAY1:
   MOV R7, #0AH
   DJNZ R7, $
   DJNZ R6, DELAY1
   RET
INTERRUPT:
    JNB TI, END_INTER   ;�P�_�O�_�ǿ駹��
    CLR TI  ;�M���ǿ駹��Flag
END_INTER:
    CLR RI  ;�M�ű�������Flag
    RETI
;����۹������r����
KEY1:
    DB "048C"
KEY2:
    DB "159D"
KEY3:
    DB "26AE"
KEY4:
    DB "37BF"
    END
