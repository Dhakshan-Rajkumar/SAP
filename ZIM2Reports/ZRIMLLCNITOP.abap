*----------------------------------------------------------------------*
*   INCLUDE ZRIMLLCNITOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : Local L/C ���������뺸?
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.06.21                                            ?
*&  ����ȸ��PJT: �������ڻ�� �ֽ�ȸ��
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTREQHD,           " ������?
         ZTREQST,           " �����Ƿڻ���
         ZTLLCHD,           " Local L/C Head
         ZTLLCAMHD.         " Local L/C Amend Head
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFREQNO     LIKE ZTREQHD-ZFREQNO,      "�����Ƿ� ������?
END OF IT_SELECTED.

DATA  W_ZFAMDNO        LIKE ZTREQST-ZFAMDNO.

DATA : OPTION(1)       TYPE C,             " ���� popup Screen���� ��?
       ANTWORT(1)      TYPE C,             " ���� popup Screen���� ��?
       CANCEL_OPTION   TYPE C,             " ���� popup Screen���� ��?
       TEXTLEN         TYPE I,             " ���� popup Screen���� ��?
       W_PROC_CNT      TYPE I.             " ó����?

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I.
