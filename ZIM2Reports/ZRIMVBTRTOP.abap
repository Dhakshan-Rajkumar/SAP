*----------------------------------------------------------------------*
*   INCLUDE ZRIMTIVSTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : ��� ���� ��� �Ƿ�                                   *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.
*&      �ۼ��� : 2000.07.07                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTBLUG.          " ��� ���� ��� ��?
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFHBLNO     LIKE ZTBLUG-ZFHBLNO,          " House B/L No.
END OF IT_SELECTED.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX.      " TABLE INDEX
