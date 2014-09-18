*----------------------------------------------------------------------*
*   INCLUDE ZRIMCUCSTLSTTOP                                           *
*----------------------------------------------------------------------*
*&  ���α׷��� : ������ ȸ��ó�� ��Ȳ                                *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.09.19                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : �������� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*
TABLES : ZTBL,            " Bill of Lading
         ZTCUCLCST,       " �����?
         ZTIDS,           " ���Ը�?
         LFA1,            " Vendor Master
         ZTIMIMG00,       " ������?
         ZTIMIMG08,       " ������?
         BKPF.
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
        ZFBLNO      LIKE ZTCUCLCST-ZFBLNO,
        ZFCLSEQ     LIKE ZTCUCLCST-ZFCLSEQ,
        ZFFIYR      LIKE ZTCUCLCST-ZFFIYR,
        ZFACDO      LIKE ZTCUCLCST-ZFACDO,
END OF IT_SELECTED.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_LOOP_CNT        TYPE I,             " Loop Count
       SV_ZFVEN          LIKE ZTCUCLCST-ZFVEN,
       SV_ZFFIYR         LIKE ZTCUCLCST-ZFFIYR,
       SV_ZFACDO         LIKE ZTCUCLCST-ZFACDO,
       SV_ZFCSCD         LIKE ZTCUCLCST-ZFCSCD,
       TOT_ZFCAMT        LIKE ZTCUCLCST-ZFCAMT,
       SUM_ZFCAMT        LIKE ZTCUCLCST-ZFCAMT.

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
