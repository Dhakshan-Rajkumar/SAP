*----------------------------------------------------------------------*
*   INCLUDE ZRIMTRSLSTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���� ��� LIST DATA DEFINE                            *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.16                                            *
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
TABLES: ZTBL,ZTIDS,ZTIMIMG10,LFA1.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME.   " �ʵ��.

DATA:   BEGIN OF IT_TAB OCCURS 0,   ">> ����.
        MARK      TYPE C,              " MARK
        ZFWERKS   LIKE ZTIDS-ZFWERKS,   " ��ǥ PLANT.
        W_WERKS    LIKE  T001W-NAME1,      " ����ó��.
        W_EBELN(15),
        ZFREBELN  LIKE  ZTIDS-ZFREBELN, " P/O NO.
        ZFSHNO    LIKE  ZTBL-ZFSHNO,    " ��������.
        ZFBLNO    LIKE  ZTIDS-ZFBLNO,
        ZFHBLNO   LIKE  ZTIDS-ZFHBLNO,
        ZFRSTAW   LIKE  ZTINSB-ZFRSTAW, " ��ǥ HS CODE!!!
        ZFPKCN    LIKE  ZTBL-ZFPKCN,    " ���尳��.
        ZFPKCNM   LIKE  ZTBL-ZFPKCNM,   " ���尳������.
        ZFNEWT    LIKE  ZTBL-ZFNEWT,    " �����߷�.
        ZFNEWTM   LIKE  ZTBL-ZFNEWTM,   " �����߷�����.
        ZFINRC    LIKE  ZTIDS-ZFINRC,   " ����
        DOMTEXT   LIKE  DD07T-DDTEXT,   " ������.
        ZFSTAMT   LIKE  ZTIDS-ZFSTAMT,  " �����ݾ�.
        ZFSTAMC   LIKE  ZTIDS-ZFSTAMC,  " ��ȭ.
        ZFIDRNO   LIKE  ZTIDS-ZFIDRNO,  " ���Ը����ȣ.
        ZFOPNNO   LIKE  ZTIDS-ZFOPNNO,  " L/C NO.
        ZFRGDSR   LIKE  ZTBL-ZFRGDSR,   " ��ǥǰ��.
        ZFCLSEQ   LIKE  ZTIDS-ZFCLSEQ,  " �������.
        ZFIDSDT   LIKE  ZTIDS-ZFIDSDT,  " ���Ը�����.
        ZFTOTAMT  LIKE  ZTIDS-ZFTOTAMT, " �Ѱ�����.
        INCO1     LIKE  ZTIDS-INCO1,    " INCO.
        ZFIVNO    LIKE  ZTIDS-ZFIVNO.   " ����԰��û������ȣ.
DATA:   END   OF IT_TAB.

DATA: BEGIN OF IT_TMP OCCURS 0.
      INCLUDE STRUCTURE IT_TAB.
DATA: ZFIVDNO LIKE ZTIVIT-ZFIVDNO,
      CCMENGE LIKE ZTIVIT-CCMENGE.
DATA: END OF IT_TMP.

DATA: IT_TMP2 LIKE TABLE OF IT_TAB WITH HEADER LINE.

DATA: BEGIN OF IT_TRIT OCCURS 0,
      ZFIVNO  LIKE  ZTTRIT-ZFIVNO,
      ZFIVDNO LIKE  ZTTRIT-ZFIVDNO,
      GIMENGE LIKE  ZTTRIT-GIMENGE.
DATA: END OF IT_TRIT.


DATA: BEGIN OF IT_SELECTED OCCURS 0,
       GUBUN     TYPE C,                " ���� ����.
       ZFIVNO    LIKE ZTIV-ZFIVNO,      " ����԰� ��û������ȣ.
       ZFBLNO    LIKE  ZTIDS-ZFBLNO,    " B/L ������ȣ.
       ZFHBLNO   LIKE  ZTIDS-ZFHBLNO,   " HBL.
       ZFCLSEQ   LIKE  ZTIDS-ZFCLSEQ,   " �������.
       ZFPKCN    LIKE  ZTBL-ZFPKCN,     " ���尳��.
       ZFPKCNM   LIKE  ZTBL-ZFPKCNM,    " ���尳������.
       ZFNEWT    LIKE  ZTBL-ZFNEWT,     " �����߷�.
       ZFNEWTM   LIKE  ZTBL-ZFNEWTM.    " �����߷�����.
DATA: END OF IT_SELECTED.


DATA : BEGIN OF IT_PK_COL OCCURS 0,
       ZFPKCN    TYPE I,    " ���尳��.
       ZFPKCNM   LIKE  ZTBL-ZFPKCNM.   " ���尳������.
DATA : END OF IT_PK_COL.

DATA : BEGIN OF IT_WT_COL OCCURS 0,
       ZFNEWT    LIKE  ZTBL-ZFNEWT,    " �����߷�.
       ZFNEWTM   LIKE  ZTBL-ZFNEWTM.   " �����߷�����.
DATA : END OF IT_WT_COL.


DATA: BEGIN OF IT_TRS OCCURS 0,
       ZFIVNO    LIKE  ZTIV-ZFIVNO,     " ����԰� ��û������ȣ.
       ZFBLNO    LIKE  ZTIDS-ZFBLNO,    " B/L ������ȣ.
       ZFHBLNO   LIKE  ZTIDS-ZFHBLNO,    " HBL.
       ZFCLSEQ   LIKE  ZTIDS-ZFCLSEQ.   " �������.
DATA : END OF IT_TRS.
