*----------------------------------------------------------------------*
*   INCLUDE ZRIMLCMGTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���Խ���(�����ϱ���)                                  *
*&      �ۼ��� : �ͼ�ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.10                                            *
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
TABLES : ZTREQHD,         " �����Ƿ� Header
         ZTREQIT,         " �����Ƿ� Item
         ZTREQST,         " �����Ƿ� Status
         ZTPMTHD,         " Payment Notice Header
         LFA1.            " ����ó������ (�Ϲݼ���)

*-----------------------------------------------------------------------
* SELECT RECORD ��.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFREQNO    LIKE ZTREQST-ZFREQNO,           " �����Ƿ� ������ȣ.
      ZFAMDNO    LIKE ZTREQST-ZFAMDNO,           " Amend Seq.
END OF IT_SELECTED.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_TABIX           LIKE SY-TABIX,
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
       W_MIN_ZFITMNO     LIKE ZTREQIT-ZFITMNO,   " �׸��ȣ.
       W_MAX_ZFAMDNO_OLD LIKE ZTREQST-ZFAMDNO,
       W_MAX_ZFAMDNO     LIKE ZTREQST-ZFAMDNO.
