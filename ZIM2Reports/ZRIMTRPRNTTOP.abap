*&---------------------------------------------------------------------*
*& Include ZRIMTRCONFTOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �߼��� ��� LIST  DATA DEFINE                         *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.04                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
TABLES: ZTTRHD,ZTTRIT,LFA1, T001W.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
       W_LIST_INDEX      LIKE SY-TABIX,
       W_LFA1            LIKE LFA1,
       W_BUTTON_ANSWER   TYPE C,
       W_UPDATE_CNT      TYPE I,
       W_ZFGIDT(10).                    "�������.

DATA:   BEGIN OF IT_TAB OCCURS 0,   ">> ����.
        MARK       TYPE  C,                " MARK
        ZFTRNO     LIKE  ZTTRHD-ZFTRNO,    " ����â������ȣ.
        ZFGIDT     LIKE  ZTTRHD-ZFGIDT,    " �������.
        ZFDRDT     LIKE  ZTTRHD-ZFDRDT,    " ���۱�����.
        ZFTRGB     LIKE  ZTTRHD-ZFTRGB,    " ���۱���.
        W_TRGB(4)  TYPE  C,                " ���۱��и�.
        ZFDRMT     LIKE  ZTTRHD-ZFDRMT,    " ���۹��.
        W_DRMT(4)  TYPE  C,                " ���۹����.
        ZFREBELN   LIKE  ZTTRHD-ZFREBELN,  " ��ǥ P/O.
        WERKS      LIKE  ZTTRHD-WERKS,     " ��ǥ PLANT.
        W_WERKS    LIKE  T001W-NAME1,      " ����ó��.
        ZFTRCO     LIKE  ZTTRHD-ZFTRCO,    " ��۾�ü.
        W_TRCO     LIKE  LFA1-NAME1,       " ��۾�ü��.
        ZFSENDER   LIKE  ZTTRHD-ZFSENDER,  " �߼���.
        ZFGIYN     LIKE  ZTTRHD-ZFGIYN,    " ���ó������.
        W_GIYN(12) TYPE  C.
DATA:   END   OF IT_TAB.

DATA: IT_TMP LIKE TABLE OF IT_TAB WITH HEADER LINE.

DATA: BEGIN OF IT_TABIT OCCURS 0,
      ZFTRNO      LIKE  ZTTRIT-ZFTRNO,     " ����â������ȣ.
      ZFTRIT      LIKE  ZTTRIT-ZFTRIT,     " ITEM NO.
      MATNR       LIKE  ZTTRIT-MATNR,      " �����ȣ.
      TXZ01       LIKE  ZTTRIT-TXZ01,      " ǰ��.
      CCMENGE     LIKE  ZTTRIT-CCMENGE,    " �������.
      GIMENGE     LIKE  ZTTRIT-GIMENGE,    " ������.
      WERKS       LIKE  ZTTRIT-WERKS,      " ��ǥ PLANT.
      W_WERKS     LIKE  T001W-NAME1,       " ����ó��.
      LGORT       LIKE  ZTTRIT-LGORT,      " Storage location
      W_LGORT     LIKE  LFA1-NAME1,        " ��۾�ü��.
      ZFIVNO      LIKE  ZTTRIT-ZFIVNO.     " ���������ȣ.
DATA: END OF IT_TABIT.

DATA : BEGIN OF IT_SELECTED OCCURS 0,
       ZFTRNO     LIKE ZTTRHD-ZFTRNO,      " TRANS. DOCUMENT NO.
       ZFGIDT     LIKE ZTTRHD-ZFGIDT,      " �������.
       ZFDRDT     LIKE ZTTRHD-ZFDRDT,      " ���۱�����.
       ZFGIYN     LIKE ZTTRHD-ZFGIYN.      " ó������.
DATA : END OF IT_SELECTED.

DATA : IT_TRHD LIKE TABLE OF ZTTRHD WITH HEADER LINE.

DATA: BEGIN OF RG_SEL OCCURS 10,
         SIGN(1),
         OPTION(2),
         LOW  LIKE ZTTRHD-ZFTRNO,
         HIGH LIKE ZTTRHD-ZFTRNO,
      END   OF RG_SEL.
