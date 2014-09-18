*&---------------------------------------------------------------------*
*& Report  ZRIMLCLST02                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���Խ���(��������)                                    *
*&      �ۼ��� : �ͼ�ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.08.13                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMLCLST02    MESSAGE-ID ZIM
                       LINE-SIZE 147
                       NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* �����Ƿ� ������� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFREQNO     LIKE ZTREQHD-ZFREQNO,         " �����Ƿ� ��ȣ.
       EBELN       LIKE ZTREQHD-EBELN,           " P/O No.
       ZFSHCU      LIKE ZTREQHD-ZFSHCU,          " ������.
       PAMDNO(16)  TYPE C,                       " ALL AMEND ȸ��.
       WAERS       LIKE ZTREQHD-WAERS,           " Currency
       ZFBENI      LIKE ZTREQHD-ZFBENI,          " Beneficiary
       NAME2(24),                                " Name 1
       ZFOPBN      LIKE ZTREQHD-ZFOPBN,          " ��������.
       NAME3(24),                                " Name 1
       TXZ01       LIKE ZTREQIT-TXZ01,           " ���系��.
       ZFUSAT      LIKE ZTMLCHD-ZFUSAT,          " ��������.
       ZFAMDNO     LIKE ZTREQST-ZFAMDNO,         " Amend ȸ��.
       ZFUSD       LIKE ZTREQST-ZFUSD,           " USD Currency
       ZFOPNNO     LIKE ZTREQST-ZFOPNNO,         " L/C No.
       ZFOPNDT     LIKE ZTREQST-ZFOPNDT,         " ������.
       ZFOPAMT     LIKE ZTREQST-ZFOPAMT,         " �����ݾ�.
       ZFUSDAM     LIKE ZTREQST-ZFUSDAM.         " USD ȯ��ݾ�.
DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TAB_DOWN OCCURS 0,
       ZFREQNO     LIKE ZTREQHD-ZFREQNO,         " �����Ƿ� ��ȣ.
       EBELN       LIKE ZTREQHD-EBELN,           " P/O No.
       ZFSHCU      LIKE ZTREQHD-ZFSHCU,          " ������.
       PAMDNO(16)  TYPE C,                       " ALL AMEND ȸ��.
       WAERS       LIKE ZTREQHD-WAERS,           " Currency
       ZFBENI      LIKE ZTREQHD-ZFBENI,          " Beneficiary
       NAME2(24),                                " Name 1
       ZFOPBN      LIKE ZTREQHD-ZFOPBN,          " ��������.
       NAME3(24),                                " Name 1
       TXZ01       LIKE ZTREQIT-TXZ01,           " ���系��.
       ZFUSAT      LIKE ZTMLCHD-ZFUSAT,          " ��������.
       ZFAMDNO     LIKE ZTREQST-ZFAMDNO,         " Amend ȸ��.
       ZFUSD       LIKE ZTREQST-ZFUSD,           " USD Currency
       ZFOPNNO     LIKE ZTREQST-ZFOPNNO,         " L/C No.
       ZFOPNDT     LIKE ZTREQST-ZFOPNDT,         " ������.
       ZFOPAMT     LIKE ZTREQST-ZFOPAMT,         " �����ݾ�.
       ZFUSDAM     LIKE ZTREQST-ZFUSDAM.         " USD ȯ��ݾ�.
DATA : END OF IT_TAB_DOWN.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE ZRIMLSLSTTOP.
INCLUDE ZRIMSORTCOM.                        " �����Ƿ� Report Sort
INCLUDE ZRIMUTIL01.                         " Utility Function ����.

*-----------------------------------------------------------------------
* Selection Screen ��.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    SELECT-OPTIONS: S_RLDT   FOR SY-DATUM,          " ������.
                    S_OPBN   FOR ZTREQHD-ZFOPBN,    " ��������.
                    S_MATGB  FOR ZTREQHD-ZFMATGB,   " ���籸��.
                    S_REQTY  FOR ZTREQHD-ZFREQTY,   " �����Ƿ� Type
                    S_WERKS  FOR ZTREQHD-ZFWERKS,   " ��ǥ Plant
                    S_EKORG  FOR ZTREQST-EKORG,     " Purch. Org.
                    S_EBELN  FOR ZTREQHD-EBELN,     " P/O No.
                    S_LIFNR  FOR ZTREQHD-LIFNR,     " Vendor
                    S_ZFBENI FOR ZTREQHD-ZFBENI,    " Beneficiary
                    S_EKGRP  FOR ZTREQST-EKGRP,     " Purch. Group
                    S_REQNO  FOR ZTREQHD-ZFREQNO.   " �����Ƿ� ������ȣ.
SELECTION-SCREEN END OF BLOCK B1.

* Parameter �ʱⰪ Setting
INITIALIZATION.                                     " �ʱⰪ SETTING
    PERFORM P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
    PERFORM P3000_TITLE_WRITE.                      " ��� ���...

*-----------------------------------------------------------------------
* START-OF-SELECTION.
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ���̺� Select
    PERFORM P1000_GET_ZTREQHD         USING W_ERR_CHK.

* ����Ʈ Write
    PERFORM P3000_DATA_WRITE          USING W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.    EXIT.     ENDIF.
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTREQHD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P1000_GET_ZTREQHD USING    P_W_ERR_CHK.

ENDFORM.                    " P1000_GET_ZTREQHD
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RESET_LIST.

ENDFORM.                    " RESET_LIST
