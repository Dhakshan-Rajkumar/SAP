*----------------------------------------------------------------------*
*   INCLUDE ZRIMPAYMTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : Payment Notice ����                                   *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.05.30                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : Payment Notice �� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*

TABLES : ZTPMTHD.           " Payment Notice Head
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFPNNO     LIKE ZTPMTHD-ZFPNNO,    " Payment Notice ������?
      ZFPYDT     LIKE ZTPMTHD-ZFPYDT,
END OF IT_SELECTED.

DATA : BEGIN OF IT_ZTPMTHD OCCURS 0.
       INCLUDE STRUCTURE ZTPMTHD.
       DATA : LOCK     TYPE C VALUE 'N'.
DATA : END   OF IT_ZTPMTHD.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
*       W_ZFPYDT  LIKE ZTPMTHD-ZFPYDT,
       W_ZFPYDT(10),
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.
