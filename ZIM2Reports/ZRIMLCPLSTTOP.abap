*&---------------------------------------------------------------------*
*& INCLUDE ZRIMLCPLSTTOP.                                              *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���Խ���(�����ϱ���) Include.                         *
*&      �ۼ��� : ȫ��ǳ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.26                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*


*----------------------------------------------------------------------*
* Tables �� ���� Define                                                *
*----------------------------------------------------------------------*
TABLES : ZTREQST,ZTPMTHD,LFA1,ZTREQIT,ZTREQHD.

DATA : BEGIN OF IT_SELECTED OCCURS 0,
       ZFREQNO    LIKE ZTREQST-ZFREQNO,          " �����Ƿ� ������ȣ.
       ZFAMDNO    LIKE ZTREQST-ZFAMDNO,          " Amend Seq.
END OF IT_SELECTED.

DATA: BEGIN OF IT_SELECTED_PN OCCURS 0,
      ZFPNNO     LIKE ZTPMTHD-ZFPNNO,    " Payment Notice ������ȣ.
END OF IT_SELECTED_PN.

DATA : W_LINE            TYPE  I,
       W_COUNT           TYPE  I,
       W_LIST_INDEX      LIKE SY-TABIX,
       W_SELECTED_LINES  TYPE  I,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,
       W_PAGE            TYPE  I.
