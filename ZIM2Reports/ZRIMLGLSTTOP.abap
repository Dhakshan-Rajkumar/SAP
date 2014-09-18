*----------------------------------------------------------------------*
*   INCLUDE ZRIMLGLSTTOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : L/G LIST  Report Data Define�� Include                *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.03                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

DATA : W_ERR_CHK(1)      TYPE  C,
       W_SELECTED_LINES  TYPE  P,             " ���� LINE COUNT
       W_PAGE            TYPE  I,             " Page Counter
       W_LINE            TYPE  I,             " �������� LINE COUNT
       LINE(3)           TYPE  N,             " �������� LINE COUNT
       W_COUNT           TYPE  I,             " ��ü COUNT
       W_LIST_INDEX      LIKE  SY-TABIX,
       W_FIELD_NM        LIKE  DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE  SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE  I,
       W_BUTTON_ANSWER   TYPE  C,
       W_ITEM_CNT        LIKE  SY-TABIX,          " ǰ�� count
       W_AMOUNT          LIKE  ZTIV-ZFIVAMT,     " �����Ƿ� Amount
       W_TOT_AMOUNT      LIKE  ZTIV-ZFIVAMT,      " �����Ƿ� Amount
       W_LOCAL_AMT       LIKE  ZTIV-ZFIVAMT,      " USD ȯ�� Amount
       W_ZFPWDT          LIKE  ZTPMTHD-ZFPWDT,
       W_LFA1            LIKE  LFA1,
       W_MENGE           LIKE  ZTREQIT-MENGE,
       W_ZSREQIT         LIKE  ZSREQIT,
       W_MAX_ZFAMDNO     LIKE  ZTREQST-ZFAMDNO,
       P_BUKRS           LIKE  ZTREQHD-BUKRS.

*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       GUBUN      TYPE C,                   " ���� ��?
       ZFBLNO     LIKE ZTLG-ZFBLNO,          " �����Ƿ� ������ȣ.
       ZFLGSEQ    LIKE ZTLG-ZFLGSEQ,
END OF IT_SELECTED.

DATA: BEGIN OF IT_ZTLGGOD OCCURS 0,
       ZFLGOD     LIKE ZTLGGOD-ZFLGOD,
       ZFBLNO     LIKE ZTLGGOD-ZFBLNO,
       ZFLGSEQ    LIKE ZTLGGOD-ZFLGSEQ,
       ZFGODS     LIKE ZTLGGOD-ZFGODS,
END OF IT_ZTLGGOD.
DATA  W_PONO(12).
DATA  W_Consignee(35).
DATA:  W_GODS1 LIKE ZTLGGOD-ZFGODS,
       W_GODS2 LIKE ZTLGGOD-ZFGODS,
       W_GODS3 LIKE ZTLGGOD-ZFGODS,
       W_GODS4 LIKE ZTLGGOD-ZFGODS,
       W_GODS5 LIKE ZTLGGOD-ZFGODS.
