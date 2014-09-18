*&---------------------------------------------------------------------*
*& Include ZRIM10TOP                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : [Include] ���� ���� Main Data Define                  *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.17                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

CONTROLS TABSTRIP    TYPE TABSTRIP.
CONTROLS: TC_0103    TYPE TABLEVIEW USING SCREEN 0103.
CONTROLS: TC_0104    TYPE TABLEVIEW USING SCREEN 0104.
CONTROLS: TC_0104_1  TYPE TABLEVIEW USING SCREEN 0104.
CONTROLS: TC_0104_2  TYPE TABLEVIEW USING SCREEN 0104.
CONTROLS: TC_0023    TYPE TABLEVIEW USING SCREEN 0023.

*>> ����Ÿ ��ȯ�� Internal Table.
DATA: BEGIN OF IT_TRS OCCURS 0,
       ZFIVNO    LIKE  ZTIV-ZFIVNO,     " ����԰� ��û������ȣ.
       ZFBLNO    LIKE  ZTIDS-ZFBLNO,    " B/L ������ȣ.
       ZFHBLNO   LIKE  ZTIDS-ZFHBLNO,    " HBL.
       ZFCLSEQ   LIKE  ZTIDS-ZFCLSEQ.   " �������.
DATA : END OF IT_TRS.

*>> ���Թ����� �޴� ���¸� ����� ��?
DATA : C_TR(15)      VALUE '����â�� ���'.

*>> SCREEN TEXT.
DATA : WT_BUKRS(30),
       WT_PLANT(30),
       WT_ZFTRGB(4),     " ���۱���.
       WT_ZFDRMT(4),     " ���۹��.
       WT_ZFTRCO(35).    " ��۾�ü.

DATA : W_CREATE(6)        TYPE     C     VALUE   'Create',
       W_CHANGE(6)        TYPE     C     VALUE   'Change',
       W_DISPLAY(7)       TYPE     C     VALUE   'Display',
       W_OPEN(08)         TYPE     C     VALUE   'Openning',
       W_STAUTS(13)       TYPE     C     VALUE   'Status Change'.

*>> ���� ����, ��ȸ�� �ߺ��˻����� ��.
DATA : BEGIN OF IT_ZFTRNO OCCURS 0,
         ZFTRNO LIKE ZTTRHD-ZFTRNO,
       END OF IT_ZFTRNO.

*>> �ߺ��˻����� üũ.
DATA : W_SRCH(2). " PO, HB, BL

DATA : W_POYN_CK. " ����ȯ ����.
*>> �����.
DATA : IT_ZSBSEG      LIKE ZSBSEG OCCURS 10 WITH HEADER LINE.
DATA : IT_ZSBSEG_ORG  LIKE ZSBSEG OCCURS 10 WITH HEADER LINE.

*>> �������üũ��.
DATA : W_IDSDT LIKE ZTIDS-ZFIDSDT,
       W_WDT(10).

*> ��ݺ�, �ΰǺ� ���� ����.
DATA : W_THAP LIKE ZSBSEG-WRBTR,
       W_MHAP LIKE ZSBSEG-WRBTR.

DATA : LINE1   TYPE   I.

*> ������� �����񱳸� ���� ����.
DATA : W_TOTWT LIKE ZTTRCST-ZFCTON.

*> �������� RANGE.
DATA: BEGIN OF RG_SEL OCCURS 10,
         SIGN(1),
         OPTION(2),
         LOW  LIKE ZTTRHD-ZFTRNO,
         HIGH LIKE ZTTRHD-ZFTRNO,
      END   OF RG_SEL.
