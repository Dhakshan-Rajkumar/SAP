*----------------------------------------------------------------------*
*   INCLUDE ZRIMINTOP                                                  *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   TABLE ����                                                         *
*----------------------------------------------------------------------*
TABLES : ZTBKPF,               " ��빮�� HEADER
         ZTBSEG,               " ��빮�� ITEM
         ZTBDIV,               " ��� ��� ����.
         ZTBHIS,               " ��� HISTORY
         ZTIMIMG00 ,
         ZTIMIMG08 ,
         ZTREQHD   ,
         ZTREQIT   ,
         EKKO,
         MAKT,
         ZTIV,
         ZTIVHST,
         ZTIVIT,
         ZTIVHSTIT,
         RV61A.

*----------------------------------------------------------------------*
*   INTERNAL TABLE ����                                                *
*----------------------------------------------------------------------*
DATA : BEGIN OF IT_REQ OCCURS 0,
       EBELN           LIKE   ZTREQIT-EBELN,
       EBELP           LIKE   ZTREQIT-EBELP,
       MENGE           LIKE   ZTREQIT-MENGE,
       MEINS           LIKE   ZTREQIT-MEINS,
       GRMENGE         LIKE   ZTREQIT-MENGE.
DATA : END   OF IT_REQ.

DATA : BEGIN OF   IT_TAB_AMT OCCURS 0,
       EBELN      LIKE EKBZ-EBELN,           " PO.
       EBELP      LIKE EKBZ-EBELP,           " PO ITEM.
       ZFCSTGRP   LIKE ZTBDIV-ZFCSTGRP,      " ���׷�.
       ZFCD       LIKE ZTBDIV-ZFCD,          " ����ڵ�.
       ZFCDNM     LIKE ZTIMIMG08-ZFCDNM,     " ����.
       MATNR      LIKE ZTBDIV-MATNR,         " ����.
       MAKTX      LIKE MAKT-MAKTX,           " �����.
       MENGE      LIKE ZTBDIV-MENGE,         " ������.
       GRMENGE    LIKE ZTIVHSTIT-GRMENGE,    " �԰����.
       MEINS      LIKE ZTBDIV-MEINS,         " ��������.
       ZFAMT      LIKE ZTBDIV-ZFAMT,         " �߻����ݾ�.
       WAERS      LIKE ZTBDIV-WAERS,         " ��ȭ.
       INAMT      LIKE ZTBDIV-ZFAMT.         " �����ݾ�.
DATA : END OF IT_TAB_AMT.

DATA : BEGIN OF   IT_TAB_SUM OCCURS 0,
       MATNR      LIKE ZTBDIV-MATNR,         " ����.
       MAKTX      LIKE MAKT-MAKTX,           " �����.
       ZFCSTGRP   LIKE ZTBDIV-ZFCSTGRP,      " ���׷�.
       ZFCD       LIKE ZTBDIV-ZFCD,          " ����ڵ�.
       ZFCDNM     LIKE ZTIMIMG08-ZFCDNM,     " ����.
       WAERS      LIKE ZTBDIV-WAERS,         " ��ȭ.
       INAMT      LIKE ZTBDIV-ZFAMT.         " �����ݾ�.
DATA : END OF IT_TAB_SUM.

DATA : BEGIN OF   IT_TAB_TOTAL OCCURS 0,
       MATNR      LIKE ZTBDIV-MATNR,         " ����.
       MAKTX      LIKE MAKT-MAKTX,           " �����.
       ZFCSTGRP   LIKE ZTBDIV-ZFCSTGRP,      " ���׷�.
       ZFCD       LIKE ZTBDIV-ZFCD,          " ����ڵ�.
       ZFCDNM     LIKE ZTIMIMG08-ZFCDNM,     " ����.
       WAERS      LIKE ZTBDIV-WAERS,         " ��ȭ.
       INAMT      LIKE ZTBDIV-ZFAMT.         " �����ݾ�.
DATA : END OF IT_TAB_TOTAL.

*----------------------------------------------------------------------*
*   VARIABLE ����                                                      *
*----------------------------------------------------------------------*
DATA : W_ERR_CHK         TYPE C,
       W_TABIX           LIKE SY-TABIX,
       W_LINE            TYPE I,
       SV_CHK            TYPE C,
       SV_EBELN          LIKE EKPO-EBELN,
       SV_EBELP          LIKE EKPO-EBELP,
       W_MENGE           LIKE ZTIVHSTIT-GRMENGE,
       SV_AMT            LIKE ZTBDIV-ZFAMT,
       TOT_AMT           LIKE ZTBDIV-ZFAMT,
       SV_WAERS          LIKE ZTBDIV-WAERS,
       W_COUNT           TYPE I,
       SV_MATNR          LIKE ZTBDIV-MATNR,
       SV_MAKTX          LIKE MAKT-MAKTX,
       SV_CDNM           LIKE ZTIMIMG08-ZFCDNM,
       SV_CSTGRP         LIKE ZTBDIV-ZFCSTGRP,
       SV_ZFCD           LIKE ZTBDIV-ZFCD,
       W_CNT             TYPE I,
       W_MOD             TYPE I,
       SV_TOT            LIKE ZTBDIV-ZFAMT.
