*&---------------------------------------------------------------------
*& Report  ZRIMLCBL                                                   *
*&---------------------------------------------------------------------
*&  ���α׷��� : L/C �ܷ� ����Ʈ
*&      �ۼ��� : �� �� ȣ  INFOLINK Ltd.
*&      �ۼ��� : 2002.12.03
*&---------------------------------------------------------------------
*&   DESC.     : L/C ������ �ݾ׿��� B/L�� �Լ��� ������ �ܷ��� ��ȸ.
*&
*&---------------------------------------------------------------------
TABLES : ZTREQHD,                  " �����Ƿ� ���.
         ZTREQST,                  " �����Ƿ� ����.
         ZTBL,                     " B/L Header
         ZTBLIT,                   " B/L Item
         ZTPMTHD,                  " Payment Notice Header
         LFA1.                     " Vendor Master
*-----------------------------------------------------------------------
* SELECT RECORD ��.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFHBLNO      LIKE ZTBL-ZFHBLNO,
      EBELN        LIKE ZTREQHD-EBELN,
      ZFOPNNO      LIKE ZTREQHD-ZFOPNNO,
END OF IT_SELECTED.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_LOOP_CNT        TYPE I,             " Loop Count
       SV_ZFOPNNO        LIKE ZTREQHD-ZFOPNNO,
       SV_ZFHBLNO        LIKE ZTBL-ZFHBLNO,
       SUM_ZFBLAMT       LIKE ZTBL-ZFBLAMT,
       TOT_ZFLASTAM      LIKE ZTREQHD-ZFLASTAM,
       TOT_ZFBLAMT       LIKE ZTBL-ZFBLAMT,
       TOT_W_LCBLAMT     LIKE ZTBL-ZFBLAMT.

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
