*----------------------------------------------------------------------*
*   INCLUDE ZRIMISNSTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���Ϻ��� �κ� ��Ȳ                                    *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.05                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

INCLUDE : <ICON>.

TABLES : ZTINSB,
         ZTBL,
         ZTINSBSG2,
         ZTINSBSG3,
         ZTBLCST,
         ZTINSBAGR,
         ZTMLCSG7O,
         ZTIMIMG00,
         T005,
         ZTBLIT.

*-----------------------------------------------------------------------
* SELECT RECORD ��.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFBLNO       LIKE ZTINSB-ZFBLNO,        " �����Ƿ� ������ȣ.
*      ZFAMDNO       LIKE ZTINS-ZFAMDNO,        " ���� Amend Seq.
      ZFINSEQ       LIKE ZTINSB-ZFINSEQ.
*      W_AMDNO       LIKE ZTREQST-ZFAMDNO.
DATA: END OF IT_SELECTED.

*>>> ERROR ó����.
DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
DATA : ICON       LIKE BAL_S_DMSG-%_ICON,
       MESSTXT(255) TYPE C.
*              ZFIVNO       LIKE ZTIV-ZFIVNO.
DATA : END OF IT_ERR_LIST.


*DATA : W_MAX_ZFAMDNO     LIKE ZTINS-ZFAMDNO,
DATA : W_ZFORIG          LIKE ZTMLCSG7O-ZFORIG,
       INCLUDE(08),
       W_SUBRC           LIKE SY-SUBRC,
       W_MOD             TYPE I,
       W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       LINE(3)           TYPE N,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME, " �ʵ��.
       W_PRINT_COUNT     TYPE I,             " ��������� ���õ� ����.
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_ZFINSEQ         LIKE ZTINSBRSP-ZFINSEQ.
