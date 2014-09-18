*----------------------------------------------------------------------*
*   INCLUDE ZRIMREDCTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : �μ��� �����/EDI Create                            *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&
*&      �ۼ��� : 2000.03.08                                            *
*&  ����ȸ��PJT: �������ڻ�� �ֽ�ȸ��                                 *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTIMIMG00,
         ZTVT,
         ZTVTSG1,
         ZTVTSG3,
         ZTRED,           " �μ�?
         ZTREDSG1,       " �μ��� Seg1
         ZTVTIV,          " ���ݰ�꼭�� Invoice
         LFA1,    " Vendor Master (General Section)
         SPOP.     " POPUP_TO_CONFIRM_... function ��� �˾�ȭ�� ��?
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFREDNO     LIKE ZTRED-ZFREDNO,      "�μ��� ������ȣ
      LIFNR       LIKE LFA1-LIFNR,       " Vendor Code
      ZFDOCNO     LIKE ZTVT-ZFDOCNO,       " ���� ������?
END OF IT_SELECTED.

DATA : W_ZFDHENO       LIKE   ZTDHF1-ZFDHENO,
       W_ZFCDDOC       LIKE   ZTCDF1-ZFCDDOC,
       W_ZFDHREF       LIKE   ZTDHF1-ZFDHREF,
*       W_ZFDHDDB       LIKE   ZTDHF1-ZFDHDDB,
       W_ZFDHSRO       LIKE   ZTDHF1-ZFDHSRO,
       W_ZFREDNO       LIKE   ZTRED-ZFREDNO,
       W_CNT           TYPE I.             " ó����?


DATA : OPTION(1)       TYPE C,             " ���� popup Screen���� ��?
       ANTWORT(1)      TYPE C,             " ���� popup Screen���� ��?
       CANCEL_OPTION   TYPE C,             " ���� popup Screen���� ��?
       TEXTLEN         TYPE I,             " ���� popup Screen���� ���
       W_PROC_CNT      TYPE I.             " ó����?

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
