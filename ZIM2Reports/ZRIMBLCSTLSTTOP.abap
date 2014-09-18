*----------------------------------------------------------------------*
*   INCLUDE ZRIMBLCSTLSTTOP                                            *
*----------------------------------------------------------------------*
*&  ���α׷��� : B/L ��� ȸ��ó�� ��Ȳ                                *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.09.26                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : B/L����� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*
TABLES : ZTBL,            " Bill of Lading
         ZTBLCST,       " �����?
         LFA1,            " Vendor Master
         ZTIMIMG00,       " ������?
         ZTIMIMG08,       " ������?
         BKPF.
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
        ZFBLNO      LIKE ZTBLCST-ZFBLNO,
        ZFFIYR      LIKE ZTBLCST-ZFFIYR,
        ZFACDO      LIKE ZTBLCST-ZFACDO,
END OF IT_SELECTED.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_LOOP_CNT        TYPE I,             " Loop Count
       SV_ZFVEN          LIKE ZTBLCST-ZFVEN,
       SV_ZFPAY          LIKE ZTBLCST-ZFPAY,
       SV_ZFFIYR         LIKE ZTBLCST-ZFFIYR,
       SV_ZFACDO         LIKE ZTBLCST-ZFACDO,
       SV_ZFCSCD         LIKE ZTBLCST-ZFCSCD,
       SV_ZFWERKS        LIKE ZTBLCST-ZFWERKS,
       TOT_ZFCKAMT       LIKE ZTBLCST-ZFCKAMT,
       SUM_ZFCKAMT       LIKE ZTBLCST-ZFCKAMT.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.
