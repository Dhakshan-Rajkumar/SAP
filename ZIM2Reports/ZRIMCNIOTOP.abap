*----------------------------------------------------------------------*
*   INCLUDE ZRIMCNIOTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : Container ��/����                                    *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.07.08                                            *
*&  ����ȸ��PJT:
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTBL,          " Bill of Lading Header.
         ZTBLCON,       " B/L Container
         ZTIDS,         " ���Ը���.
         LFA1,          " VENDOR MASTER.
         T001W.         " PLANT NAME.

*& INTERNAL TABLE ����-------------------------------------------------*

DATA : IT_TAB      LIKE    ZTBL        OCCURS 0 WITH HEADER LINE.
DATA : IT_LFA1     LIKE    LFA1        OCCURS 0 WITH HEADER LINE.
DATA : IT_T001W    LIKE    T001W       OCCURS 0 WITH HEADER LINE.



DATA : W_TEM(13),
       W_ERR_CHK(1)      TYPE C,
       W_SEQ(2)          TYPE   P,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_MOD             TYPE I,             " ������ ����.
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
       W_TABIX           LIKE SY-TABIX.      " TABLE INDEX
