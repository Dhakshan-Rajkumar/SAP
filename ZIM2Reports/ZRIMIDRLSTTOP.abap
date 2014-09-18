*----------------------------------------------------------------------*
*   INCLUDE ZRIMIDRLSTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : �������                                              *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.07                                            *
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
TABLES: ZTBL, ZTIDR, ZTIDS, ZTIMIMG10, LFA1, ZTBLINR_TMP, ZTCIVIT, EKET,
        ZTIMIMG02,   USR21, ADRP.

DATA : W_SEQ             TYPE I,
       W_ERR_CHK(1)      TYPE C,                 " ERROR CHECK
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,          " TABLE INDEX
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME.   " �ʵ��.

DATA:   BEGIN OF IT_TAB OCCURS 0,        "> ����.
        ZFBLNO    LIKE  ZTBL-ZFBLNO,     "> B/L ������ȣ.
        ZFCCNO    LIKE  ZTBL-ZFCCNO,     "> ���������ȣ.
        ZFINRNO   LIKE  ZTIDR-ZFINRNO,   "> ���Թ�ȣ.
        ZFREBELN  LIKE  ZTBL-ZFREBELN,   "> ����ȣ.
        ZFSHNO    LIKE  ZTBL-ZFSHNO,     "> ��������.
        ZFIDRNO   LIKE  ZTIDS-ZFIDRNO,   "> �Ű��ȣ.
        ZFCARNM   LIKE  ZTIDR-ZFCARNM,   "> �����.
        ZFHBLNO   LIKE  ZTBL-ZFHBLNO,    "> HOUSE B/L.
        ZFMBLNO   LIKE  ZTBL-ZFMBLNO,    "> MASTER B/L.
        ZFIVAMK   LIKE  ZTCIVIT-ZFIVAMK, "> ����ݾ�.
        ZFPKCNT   LIKE  ZTIDR-ZFPKCNT,   "> ���尳��.
        PKCT      TYPE  I,               "> �����.
        ZFPKNM    LIKE  ZTIDR-ZFPKNM,    "> �������.
        ZFTOWT    LIKE  ZTIDR-ZFTOWT,    "> ���߷�.
        ZFTOWTM   LIKE  ZTIDR-ZFTOWTM,   "> ���߷� ����.
        ZFENDT    LIKE  ZTIDR-ZFENDT,    "> ������.
        ZFINDT    LIKE  ZTIDR-ZFINDT,    "> ������.
        ZFIDWDT   LIKE  ZTIDR-ZFIDWDT,   "> �Ű���.
        ZFIDSDT   LIKE  ZTIDS-ZFIDSDT,   "> ������.
        ZFINRC    LIKE  ZTIDR-ZFINRC,    "> �Ű�������.
        IN_NM(20) TYPE  C,               "> ������.
        EINDT     LIKE  SY-DATUM,        "> ������.
        ZFCCCNAM  LIKE  ZTBL-ZFCCCNAM,   "> ��������.
        PS_NM(20) TYPE  C.
DATA:   END   OF IT_TAB.
