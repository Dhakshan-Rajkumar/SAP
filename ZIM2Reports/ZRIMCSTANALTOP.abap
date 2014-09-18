*----------------------------------------------------------------------*
*   INCLUDE ZRIMCSTANALTOP                                             *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   TABLE ����                                                         *
*----------------------------------------------------------------------*
TABLES : ZTBKPF,               " ��빮�� HEADER
         ZTBSEG,               " ��빮�� ITEM
         ZTBCOST,              " �����ݿ� �̷�.
         ZTBCOIT,              " �����ݿ� �̷� ITEM.
         SPOP,
         BSIS,
         ANLA,
         ANLZ,
         UF05A,
         ZTIVHST,              " �԰��̷� TABLE.
         ZTBDIV,               " ��� ��� ����.
         ZTBHIS,               " ��� HISTORY
         T163B ,               " TEXT
         T163C ,               " TEXT
         T685T ,               " TEXT
         MAKT,                 " ���系��.
         EKKN  ,               " �ڻ��ȣ TABLE
         ZTIV  ,               " ����� Invoice
         ZTIVIT,               " ����� Invoice Item
         ZTBL  ,               " BL
         EKBZ  ,               " ��� ȸ�� ��ǥ
         EKBE  ,               " ���� ȸ�� ��ǥ
         KONV  ,               "
         EKKO  ,
         EKPO  ,
         USR01 ,
         ZTIMIMG01 ,
         ZTIMIMG00 ,
         ZTIMIMG08 ,
         ZTIMIMG11 ,
         ZTREQHD   ,
         ZTREQIT   ,
         RV61A,
         T001W,
         T134G,
         MARA,
         J_1BBRANCH.

*----------------------------------------------------------------------*
*   INTERNAL TABLE ����                                                *
*----------------------------------------------------------------------*
*>> ���� �̷� INTERNAL TABLE.
DATA : IT_ZSBCOST      LIKE ZTBCOST OCCURS 100 WITH HEADER LINE.

DATA : BEGIN OF IT_CO   OCCURS 0,
       BUKRS           LIKE   ZTBCOST-BUKRS ,
       WERKS           LIKE   ZTBCOST-WERKS ,
       MATNR           LIKE   ZTBCOST-MATNR ,
       ZFSEQ           LIKE   ZTBCOST-ZFSEQ .
DATA : END   OF IT_CO.

DATA : BEGIN OF IT_TEMP OCCURS 0,
       ZFIVNO          LIKE   ZTIVHST-ZFIVNO,
       ZFIVHST         LIKE   ZTIVHST-ZFIVHST.
DATA : END   OF IT_TEMP.

DATA : BEGIN OF IT_SELECTED OCCURS 0,
       BUKRS           LIKE   ZTBKPF-BUKRS,
       WERKS           LIKE   EKPO-WERKS,
       MATNR           LIKE   EKPO-MATNR,
       MATGB           LIKE   ZTREQHD-ZFMATGB,
       WRBTR           LIKE   EKBZ-DMBTR,
       WAERS           LIKE   ZTBKPF-WAERS.
DATA : END   OF IT_SELECTED.

DATA : BEGIN OF IT_IV  OCCURS 0,
       BUKRS           LIKE   ZTIV-BUKRS,
       ZFIVNO          LIKE   ZTIV-ZFIVNO,
       EBELN           LIKE   ZTREQIT-EBELN,
       EBELP           LIKE   ZTREQIT-EBELP,
       MATNR           LIKE   ZTIVIT-MATNR,
       ZFMATGB         LIKE   ZTIVIT-ZFMATGB,
       BUDAT           LIKE   ZTIVHST-BUDAT,
       WERKS           LIKE   ZTIVIT-WERKS.
DATA : END   OF IT_IV.

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
       ZFIMDNO         LIKE   ZTBDIV-ZFIMDNO ,   " ������ȣ.
       MATNR           LIKE   EKPO-MATNR,        " ����.
       ZFMATGB         LIKE   ZTREQHD-ZFMATGB,   " ���籸��.
       BUDAT           LIKE   ZTIVHST-BUDAT,      " �԰���.
       WERKS           LIKE   ZTIVIT-WERKS,      " �÷�Ʈ.
       BUKRS           LIKE   ZTBDIV-BUKRS,      " ȸ���ڵ�.
       ZFACDO          LIKE   ZTBKPF-ZFACDO,     " ��ǥ��ȣ.
       ZFFIYR          LIKE   ZTBKPF-ZFFIYR,     " ��ǥ�⵵.
       ZFDCSTX         LIKE   ZTBDIV-ZFDCSTX,    " Delivery Cost ����.
       ZFCSTGRP        LIKE   ZTBDIV-ZFCSTGRP,   " ���׷�.
       ZFCD            LIKE   ZTBDIV-ZFCD,       " ����ڵ�.
       WRBTR           LIKE   ZTBDIV-WRBTR,      " �ݾ�.
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
* MESSAGE TABLE ����.
*----------------------------------------------------------------------*
DATA:   BEGIN OF RETURN OCCURS 0.   ">> RETURN ����.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON       LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(255) TYPE C.
DATA:   END   OF RETURN.

*----------------------------------------------------------------------*
*   VARIABLE ����                                                      *
*----------------------------------------------------------------------*
DATA : W_ERR_CHK         TYPE C,
       W_TABIX           LIKE SY-TABIX,
       W_COUNT           TYPE I,
       W_SELECTED_LINES  TYPE I,
       W_LINE            TYPE I,
       W_MOD             TYPE I,
       MARKFIELD         TYPE C,
       SV_CHECK          TYPE C,
       SV_SORT           TYPE C,
       SV_CHK            TYPE C,
       SV_JUL            TYPE C,
       INCLUDE(8)        TYPE C,
       SV_TEXT(20)       TYPE C,
       OK-CODE           LIKE SY-UCOMM,
       W_BELNR           LIKE ZTBHIS-ZFBELNR,
       W_GJAHR           LIKE ZTBHIS-ZFGJAHR,
       W_ZFSEQ           LIKE ZTBCOST-ZFSEQ ,
       W_SEQIT           LIKE ZTBCOIT-ZFSEQIT,
       W_FIYR            LIKE ZTBCOST-ZFFIYR,
       W_ACDO            LIKE ZTBCOST-ZFACDO,
       W_KONTS_1         LIKE T030-KONTS,
       W_KONTS_2         LIKE T030-KONTS,
       W_KONTS_M         LIKE T030-KONTS,
       W_KONTS           LIKE T030-KONTS,
       W_KONTH           LIKE T030-KONTS,
       SV_TOT1           LIKE EKBZ-DMBTR,
       SV_TOT2           LIKE EKBZ-DMBTR,
       SV_TOT3           LIKE EKBZ-DMBTR,
       SV_PER1(5)        TYPE P  DECIMALS 5,
       SV_PER2(5)        TYPE P  DECIMALS 5,
       SV_PER3(5)        TYPE P  DECIMALS 5,
       SV_KSCHL          LIKE EKBZ-KSCHL,
       SV_MENGE          LIKE EKPO-MENGE,
       SV_VGABE          LIKE EKBZ-VGABE,
       SV_BEWTP          LIKE T163C-BEWTP,
       SV_BEWTK          LIKE T163C-BEWTK,
       SV_BEWTL          LIKE T163C-BEWTL,
       SV_DMBTR          LIKE EKBZ-DMBTR,
       SV_NAME           LIKE T001W-NAME1,
       SV_KEY            LIKE KONV-WAERS,
       W_WRBTR           LIKE EKBZ-DMBTR,
       TEMP_WRBTR(30)    TYPE C,
       SV_SUM            LIKE EKBZ-DMBTR,
       SV_SUM1           LIKE EKBZ-DMBTR,
       SV_SUM2           LIKE EKBZ-DMBTR,
       SV_SUM3           LIKE EKBZ-DMBTR,
       SV_SUM4           LIKE EKBZ-DMBTR,
       SV_CHA            LIKE EKBZ-DMBTR,
       SV_BUKRS          LIKE ZTBDIV-BUKRS,
       SV_WERKS          LIKE ZTBDIV-WERKS,
       SV_MATNR          LIKE ZTREQIT-MATNR,
       SV_MATGB          LIKE ZTREQHD-ZFMATGB,
       SV_GB             TYPE C,
       SV_MEINS          LIKE EKPO-MEINS,
       SV_WAERS          LIKE EKBZ-WAERS,
       SV_KNUMV          LIKE EKKO-KNUMV.
*----------------------------------------------------------------------*
* ALV REPORT FUNCTION CALL �ϱ� ���� ���� ����.
*----------------------------------------------------------------------*
TYPE-POOLS: SLIS.

CONSTANTS: GC_FORMNAME_TOP_OF_PAGE TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE'.

DATA: GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      GS_LAYOUT   TYPE SLIS_LAYOUT_ALV,
      GS_KEYINFO  TYPE SLIS_KEYINFO_ALV,
      GT_SORT     TYPE SLIS_T_SORTINFO_ALV,
      GT_SP_GROUP TYPE SLIS_T_SP_GROUP_ALV,
      GT_EVENTS   TYPE SLIS_T_EVENT.
DATA: GT_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER.
DATA  G_USER_COMMAND      TYPE SLIS_FORMNAME VALUE 'P2000_USER_COMMAND'.
DATA  G_STATUS            TYPE SLIS_FORMNAME VALUE 'P2000_SET_STATUS'.
DATA: G_REPID LIKE SY-REPID.
DATA    G_SAVE(1) TYPE C.
DATA    G_VARIANT LIKE DISVARIANT.
