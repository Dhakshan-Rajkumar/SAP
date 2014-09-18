*&---------------------------------------------------------------------*
*&  INCLUDE ZRIMINSCRTBTOP                                             *
*&---------------------------------------------------------------------*
*&  ���α׷��� : B/L ���� �κ� ���߻����� Include                      *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.06                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.      :
*&
*&---------------------------------------------------------------------*

TABLES : ZTBL,            " B/L
         ZTBLIT,          " B/L Item
         ZTPMTHD,         " Payment Notice Header
         ZTPMTIV,         " Payment Notice Invoice
         ZTBLINR,         " ���ԽŰ�.
         ZTIDS,           " ���Ը���.
         DD03D,           " Dynpro fields for table fields
         T024E,           " ��������.
         T024,            " ���ű׷�.
         LFA1,            " ����ó������ (�Ϲݼ���)
         TINC,            " ��: �ε�����.
         EKPO,            " Purchasing Document Item
         ZVREQHD_ST,      " �����Ƿ� Header + Status View
         ZVEKKO_REQHD_ST, " EKKO + �����Ƿ� Header + Status View
         ZTOFF,           " OFFER SHEET
         ZTOFFFTX,        " OFFER SHEET FTX
         ZTIMIMGTX,       " EDI TEXT.
         ZTDHF1,          " ǥ�� EDI Flat Head
         ZTCDF1,          " ���ڹ�����ȣ ä��(EDI)
         ZTIMIMG03,       " �������� �ڵ�.
         ZTIMIMG00.       " ���Խý��� Basic Config

*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       GUBUN      TYPE C,                        " ���� ����.
       ZFBLNO     LIKE ZTBL-ZFBLNO,              " B/L ������ȣ.
       ZFMATGB    LIKE ZTBL-ZFMATGB,             " ���籸��.
END OF IT_SELECTED.

*-----------------------------------------------------------------------
* Internal Table Define
*-----------------------------------------------------------------------
DATA : IT_BLTMP      LIKE TABLE OF ZTBL WITH HEADER LINE.
DATA : BAPIMEPOITEM   LIKE  BAPIMEPOITEM   OCCURS 0 WITH HEADER LINE.
DATA : BAPIMEPOITEMX  LIKE  BAPIMEPOITEMX  OCCURS 0 WITH HEADER LINE.

DATA: DYNPROG            LIKE SY-REPID,
      DYNNR              LIKE SY-DYNNR,
      WINDOW_TITLE(30)   TYPE C.

*-----------------------------------------------------------------------
* Internal Table Define: IT_TAB_DOWN.
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB_DOWN OCCURS 0,
         W_EDI_RECORD(65535)  TYPE C,
       END   OF IT_TAB_DOWN.

*> RETURN MESSAGE ó����.
 DATA:   BEGIN OF RETURN OCCURS 0.   ">> RETURN ����.
         INCLUDE STRUCTURE   BAPIRET2.
 DATA:   END   OF RETURN.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       LINE(3)           TYPE N,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX          LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT     TYPE I,
       W_BUTTON_ANSWER  TYPE C,
       W_ITEM_CNT      LIKE SY-TABIX,          " ǰ�� count
       W_AMOUNT        LIKE ZTIV-ZFIVAMT,     " �����Ƿ� Amount
       W_TOT_AMOUNT    LIKE ZTIV-ZFIVAMT,      " �����Ƿ� Amount
       W_LOCAL_AMT     LIKE ZTIV-ZFIVAMT,      " USD ȯ�� Amount
       W_ZFPWDT        LIKE ZTPMTHD-ZFPWDT,
       W_EBELN         LIKE EKPO-EBELN,
       W_LFA1          LIKE LFA1,
       W_MENGE         LIKE ZTREQIT-MENGE,
       W_ZSREQIT       LIKE ZSREQIT,
       W_MAX_ZFAMDNO   LIKE ZTREQST-ZFAMDNO,
       OK-CODE         LIKE SY-UCOMM,
       ANTWORT         TYPE C,
       P_BUKRS         LIKE ZTREQHD-BUKRS.

RANGES: R_ZFRLST1 FOR ZTREQST-ZFRLST1 OCCURS 0.

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_LFA1_SELECT
*&---------------------------------------------------------------------*
FORM P1000_GET_LFA1_SELECT USING    P_LIFNR
                           CHANGING P_LFA1.
   CLEAR : P_LFA1.
   IF P_LIFNR IS INITIAL.
      EXIT.
   ENDIF.
*-----------------------------------------------------------------------
* VENDOR MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
   CALL FUNCTION 'READ_LFA1'
        EXPORTING
              XLIFNR          = P_LIFNR
        IMPORTING
              XLFA1           = P_LFA1
        EXCEPTIONS
              KEY_INCOMPLETE  = 01
              NOT_AUTHORIZED  = 02
              NOT_FOUND       = 03.

   CASE SY-SUBRC.
      WHEN 01.     MESSAGE I025.
      WHEN 02.     MESSAGE E950.
      WHEN 03.     MESSAGE E020   WITH    P_LIFNR.
   ENDCASE.

   TRANSLATE P_LFA1  TO UPPER CASE.

ENDFORM.                    " P1000_GET_LFA1_SELECT
