*----------------------------------------------------------------------*
*   INCLUDE ZRIMIDSLSTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ���������ȸ                                    *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.08.17                                            *
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
TABLES: ZTBL,ZTIDSUS,ZTIMIMG10,LFA1, ZTIMIMG00, ZTCIVIT, ZTCIVHD.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       P_BUKRS           LIKE ZTBL-BUKRS,        " Company Code
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME.   " �ʵ��.

DATA:   BEGIN OF IT_TAB OCCURS 0,
        ZFIVNO    LIKE ZTIV-ZFIVNO,
        ZFBLNO    LIKE ZTBL-ZFBLNO,
        ZFSHNO    LIKE ZTBL-ZFSHNO,
        W_EBELN(15),
        ZFHBLNO   LIKE ZTBL-ZFHBLNO,
        ZFRGDSR   LIKE ZTBL-ZFRGDSR,
        ZFENTNO   LIKE ZTIDSUS-ZFENTNO,
        ZFCLSEQ   LIKE ZTIDSUS-ZFCLSEQ,
        ZFOPNNO   LIKE ZTBL-ZFOPNNO,
        ZFREBELN  LIKE ZTBL-ZFREBELN,
        ZFEDT     LIKE ZTIDSUS-ZFEDT,
        ZFEEDT    LIKE ZTIDSUS-ZFEEDT,
        ZFINRC    LIKE ZTIDSUS-ZFINRC,
        DOMTEXT   LIKE DD07T-DDTEXT,
        ZFCTW     LIKE ZTIDSUS-ZFCTW,
        NAME1     LIKE LFA1-NAME1,
        ZFIVAMT   LIKE ZTIDSUS-ZFIVAMT,
        ZFIVAMC   LIKE ZTIDSUS-ZFIVAMC,
        ZFTOFEE   LIKE ZTIDSUS-ZFTOFEE,
        ZFDUTY    LIKE ZTIDSUS-ZFDUTY,
        ZFKRW     LIKE ZTIDSUS-ZFKRW,
        ZFTOCUR   LIKE ZTIDSUS-ZFTOCUR,
        INCO1     LIKE ZTIDSUS-INCO1,
        ZFPRNAM   LIKE ZTBL-ZFPRNAM,
        ZFTRMET   LIKE ZTIDSUS-ZFTRMET,
        ZFWERKS   LIKE ZTBL-ZFWERKS,
        ZFCARNM   LIKE ZTIDSUS-ZFCARNM,
        ZFEXPDT   LIKE ZTIDSUS-ZFEXPDT,
        ZFENDT    LIKE ZTIDSUS-ZFENDT,
        ZFSUMDT   LIKE ZTIDSUS-ZFSUMDT,
        ZFCIVNO   LIKE ZTCIVHD-ZFCIVNO.
DATA:   END   OF IT_TAB.
