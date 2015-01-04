    ORG 00H
    JMP INIT
    ORG 23H
    JMP INTERRUPT
    ORG 50H
INIT:
    MOV SCON, #01010000B    ;�]�w��Mode 1, Receive enable
    ANL PCON, #01111111B    ;SMOD = 0, �ϱo��J��clock�Q���W32
    MOV IE, #10010000B      ;�Ұʤ��_
    MOV TMOD, #00100000B    ;�]�wTimer 1��Mode 2
    MOV TH1, #0F3H          ;�]�w�j�v
    SETB TR1                ;�Ұ�Timer 1
    JMP $
INTERRUPT:
    JNB RI, END_INTER   ;�P�_�O�_����������
    CLR RI      ;�M�ű�������Flag
    MOV A, SBUF ;�������
    MOV SBUF, A ;�ǿ���
END_INTER:
    CLR TI  ;�M���ǿ駹��Flag
    RETI
    END
