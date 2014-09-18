*----------------------------------------------------------------------*
*   INCLUDE ZRIMCSTCHATOP                                              *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   TABLE ����                                                         *
*----------------------------------------------------------------------*
TABLES : ZTBKPF,               " ��빮�� HEADER
         ZTBSEG,               " ��빮�� ITEM
         ZTBDIV,               " ��� ��� ����.
         ZTBHIS,               " ��� HISTORY
         T163B ,               " TEXT
         T163C ,               " TEXT
         T685T ,               " TEXT
         EKBZ  ,               " ��� ȸ�� ��ǥ
         EKBE  ,               " ���� ȸ�� ��ǥ
         KONV  ,
         EKKO  ,
         EKPO  ,
         ZTIMIMG01 ,
         ZTIMIMG00 ,
         ZTIMIMG08 ,
         ZTREQHD   ,
         ZTREQIT   ,
         RV61A.

*----------------------------------------------------------------------*
*   INTERNAL TABLE ����                                                *
*----------------------------------------------------------------------*
DATA : BEGIN OF IT_REQ OCCURS 0,
       EBELN           LIKE   ZTREQIT-EBELN,
       EBELP           LIKE   ZTREQIT-EBELP.
DATA : END   OF IT_REQ.

DATA : BEGIN OF IT_PO OCCURS 0,
       EBELN           LIKE   EKPO-EBELN,
       EBELP           LIKE   EKPO-EBELP,
       WERKS           LIKE   EKPO-WERKS,
       MEINS           LIKE   EKPO-MEINS,
       BUKRS           LIKE   EKKO-BUKRS.
DATA : END   OF IT_PO.

DATA : BEGIN OF IT_DIV OCCURS 0,
       EBELN           LIKE   ZTBDIV-EBELN,      " PO Header.
       EBELP           LIKE   ZTBDIV-EBELP,      " PO Item.
       ZFRVSX          LIKE   ZTBKPF-ZFRVSX,     " ����ǥ.
       BUKRS           LIKE   ZTBDIV-BUKRS,      " ȸ���ڵ�.
       ZFACDO          LIKE   ZTBKPF-ZFACDO,     " ��ǥ��ȣ.
       ZFFIYR          LIKE   ZTBKPF-ZFFIYR,     " ��ǥ�⵵.
       ZFDCSTX         LIKE   ZTBDIV-ZFDCSTX,    " Delivery Cost ����.
       ZFCSTGRP        LIKE   ZTBDIV-ZFCSTGRP,   " ���׷�.
       ZFCD            LIKE   ZTBDIV-ZFCD,       " ����ڵ�.
       WRBTR           LIKE   ZTBDIV-WRBTR,      " �ݾ�.
       DMBTR           LIKE   ZTBDIV-DMBTR,      " ��ȭ���.
       HWAER           LIKE   ZTBDIV-HWAER,      " ��ȭ.
       MENGE           LIKE   ZTBDIV-MENGE,      " ����.
       MEINS           LIKE   ZTBDIV-MEINS.      " ����.
DATA : END   OF IT_DIV.

DATA : BEGIN OF IT_EKBZ OCCURS 0,
       EBELN           LIKE   EKBZ-EBELN,        " PO Header
       EBELP           LIKE   EKBZ-EBELP,        " PO Item
       VGABE           LIKE   EKBZ-VGABE,        " Transaction ����.
       GJAHR           LIKE   EKBZ-GJAHR,        " ��ǥ�⵵.
       BELNR           LIKE   EKBZ-BELNR,        " ��ǥ��ȣ.
       BEWTP           LIKE   EKBZ-BEWTP,        " PO �̷�����.
       DMBTR           LIKE   EKBZ-DMBTR,        " ������ȭ�ݾ�.
       HSWAE           LIKE   EKBZ-HSWAE,        " ��ȭ.
       MENGE           LIKE   EKBZ-MENGE,        " ����.
       MEINS           LIKE   EKPO-MEINS,        " ����.
       SHKZG           LIKE   EKBZ-SHKZG,        " �뺯/���� ������.
       KSCHL           LIKE   EKBZ-KSCHL.
DATA : END   OF IT_EKBZ.

DATA : BEGIN OF IT_EKBE  OCCURS 0,
       EBELN           LIKE   EKBE-EBELN,        " PO Header
       EBELP           LIKE   EKBE-EBELP,        " PO Item
       VGABE           LIKE   EKBE-VGABE,        " Transaction ����.
       GJAHR           LIKE   EKBE-GJAHR,        " ��ǥ�⵵.
       BELNR           LIKE   EKBE-BELNR,        " ��ǥ��ȣ.
       BEWTP           LIKE   EKBE-BEWTP,        " PO �̷�����.
       DMBTR           LIKE   EKBE-DMBTR,        " ������ȭ�ݾ�.
       HSWAE           LIKE   EKBE-HSWAE,        " ��ȭ.
       MENGE           LIKE   EKBE-MENGE,        " ����.
       MEINS           LIKE   EKPO-MEINS,        " ����.
       SHKZG           LIKE   EKBE-SHKZG.        " �뺯/���� ������.
DATA : END   OF IT_EKBE.

*----------------------------------------------------------------------*
*   VARIABLE ����                                                      *
*----------------------------------------------------------------------*
DATA : W_ERR_CHK         TYPE C,
       W_COUNT           TYPE I,
       W_LINE            TYPE I,
       SV_SORT           TYPE C,
       SV_CHK            TYPE C,
       INCLUDE(8)        TYPE C,
       SV_TEXT(20)       TYPE C,
       SV_TOT1           LIKE EKBZ-DMBTR,
       SV_TOT2           LIKE EKBZ-DMBTR,
       SV_TOT3           LIKE EKBZ-DMBTR,
       SV_PER1(5)        TYPE P  DECIMALS 5,
       SV_PER2(5)        TYPE P  DECIMALS 5,
       SV_PER3(5)        TYPE P  DECIMALS 5,
       SV_KSCHL          LIKE EKBZ-KSCHL,
       SV_MENGE          LIKE EKPO-MENGE,
       SV_DMBTR          LIKE EKBZ-DMBTR,
       SV_NAME           LIKE T001W-NAME1,
       SV_KEY            LIKE KONV-WAERS,
       SV_SUM            LIKE EKBZ-DMBTR,
       SV_SUM1           LIKE EKBZ-DMBTR,
       SV_SUM2           LIKE EKBZ-DMBTR,
       SV_SUM3           LIKE EKBZ-DMBTR,
       SV_SUM4           LIKE EKBZ-DMBTR,
       SV_CHA            LIKE EKBZ-DMBTR,
       SV_EBELN          LIKE EKPO-EBELN,
       SV_EBELP          LIKE EKPO-EBELP,
       SV_MEINS          LIKE EKPO-MEINS,
       SV_WAERS          LIKE EKBZ-WAERS,
       SV_KNUMV          LIKE EKKO-KNUMV.
