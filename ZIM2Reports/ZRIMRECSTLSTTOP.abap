*----------------------------------------------------------------------*
*   INCLUDE ZRIMRECSTLSTTOP                                           *
*----------------------------------------------------------------------*
*&  ���α׷��� : �����Ƿں�� ȸ��ó�� ��Ȳ                            *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.09.26                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : �����Ƿں���� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*
TABLES : ZTREQHD,         " �����Ƿ�
         ZTRECST,         " ������
         LFA1,            " Vendor Master
         ZTIMIMG00,       " �����ڵ�
         ZTIMIMG08.       " �����ڵ�
*-----------------------------------------------------------------------
* SELECT RECORD��
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
        ZFREQNO     LIKE ZTRECST-ZFREQNO,
        ZFFIYR      LIKE ZTRECST-ZFFIYR,
        ZFACDO      LIKE ZTRECST-ZFACDO,
END OF IT_SELECTED.

DATA : W_PROC_CNT        TYPE I,             " ó���Ǽ�
       W_LOOP_CNT        TYPE I,             " Loop Count
       SV_ZFVEN          LIKE ZTRECST-ZFVEN,
       SV_ZFFIYR         LIKE ZTRECST-ZFFIYR,
       SV_ZFACDO         LIKE ZTRECST-ZFACDO,
       SV_ZFCD3          LIKE ZTIMIMG08-ZFCD3,
       TOT_ZFCKAMT       LIKE ZTRECST-ZFCKAMT,
       SUM_ZFCKAMT       LIKE ZTRECST-ZFCKAMT.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.
