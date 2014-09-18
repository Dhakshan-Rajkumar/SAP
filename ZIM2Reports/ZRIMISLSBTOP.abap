*----------------------------------------------------------------------*
*   INCLUDE ZRIMISLSBTOP                                               *
*----------------------------------------------------------------------*
*&  ���α׷��� : BL���� �κ� ���� TOP                                  *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.04                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :BL���� �κ� ���� ����Ʈ�� ���� Include.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* ���̺�.
*-----------------------------------------------------------------------
TABLES : ZTINSB,                       " ����κ�.
         ZTINSBSG2,                    " SEG2
         ZTINSBAGR,                    " AGR
         ZTINSBRSP,                    " ����κ� Response
         ZTBL,                         " B/L
         ZTREQHD,                      " �����Ƿ� TABLE.
         ZTBLCST,                      " B/L ���.
         ZTBLIT.                       " B/L ITEM.


*-----------------------------------------------------------------------
* SELECT RECORD ��.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       ZFBLNO     LIKE ZTINSB-ZFBLNO,          " B/L ������ȣ.
       ZFINSEQ    LIKE ZTINSB-ZFINSEQ,
       ZFINNO     LIKE ZTINSB-ZFINNO,
       ZFKRWAMT   LIKE ZTINSB-ZFKRWAMT,
       WERKS      LIKE ZTBL-ZFWERKS,
       BUPLA      LIKE ZTBKPF-BUPLA,
       BUKRS      LIKE ZTINSB-BUKRS,
       BELNR      LIKE ZTINSB-BELNR,
       ZFOPCD     LIKE ZTINSB-ZFOPCD,
       GJAHR      LIKE ZTINSB-GJAHR.
DATA: END OF IT_SELECTED.

DATA : BEGIN OF IT_LIFNR OCCURS 0,
       ZFOPCD     LIKE ZTINSB-ZFOPCD.
DATA : END   OF IT_LIFNR.

DATA : W_ERR_CHK(1)      TYPE C,                  " ERROR CHECK.
       W_SELECTED_LINES  TYPE P,                  " ���� LINE COUNT
       W_PAGE            TYPE I,                  " Page Counter
       W_LINE            TYPE I,                  " �������� LINE COUNT
       LINE(3)           TYPE N,                  " �������� LINE COUNT
       W_COUNT           TYPE I,                  " ��ü COUNT
       L_COUNT           TYPE I,                  " �������� LINE COUNT
       W_LCOUNT          TYPE I,                  " ����� COUNT
       W_LIST_INDEX      LIKE SY-TABIX,           " TABLE INDEX
       W_FIELD_NM        LIKE DD03D-FIELDNAME,    " �ʵ��.
       W_TABIX           LIKE SY-TABIX,           " TABLE INDEX
       W_EKNAM           LIKE T024-EKNAM,         " �����.
       W_WERKSNM         LIKE T001W-NAME1,        " �÷�Ʈ��.
       W_TRANS           LIKE ZTINSB-ZFTRANS,     " ��۹��.
       W_MATNM(35)       TYPE C,                  " �����.
       W_MIN_LSG2        LIKE ZTINSBSG2-ZFLSG2,   " �ּ� �ݺ���.
       W_MIN_LAGR        LIKE ZTINSBAGR-ZFLAGR,   " �ִ� �ݺ���.
       OLD_ZFOPCD        LIKE ZTINSB-ZFOPCD,      " ����ȸ��CODE.
       OLD_ZFKRW         LIKE ZTINSB-ZFKRW,       " �Ұ�ݾ���ȭ.
       SUB_TOTALK        LIKE ZTINSB-ZFKRWAMT,    " �Ұ�ݾ׿�ȭ.
       W_ZFCSTGRP        LIKE ZTBKPF-ZFCSTGRP,    " ���׷��ڵ�.
       P_BUKRS           LIKE ZTBL-BUKRS.
