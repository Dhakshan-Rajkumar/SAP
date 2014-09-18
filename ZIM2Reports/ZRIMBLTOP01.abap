*&---------------------------------------------------------------------*
*&  INCLUDE ZRIMBLTOP01                                                *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� B/L ���� Data Define�� Include                   *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.01.21                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* ��� Table Define
*-----------------------------------------------------------------------
TABLES : ZTBL,        " BILL OF LADING
         LFA1,
         ZTBLCON,     " B/L CONTAINER
         ZTBLCST,     " B/L ��?
         ZTBLINOU,    " B/L ������?
         ZTBLINR,     " B/L ���Խ�?
        *ZTBLINR,     " B/L ���Խ�?
         ZTBLOUR,     " B/L �����?
         ZTIMIMG02,   "
         ZTIMIMG00,
         ZTIMIMGTX,
         ZTBLUG,      " ��޺������ ��?
         ZTIV,        " ���.
         ZTBLUGC.     " ��޺������ ��?

*-----------------------------------------------------------------------
* ����� View Define
*-----------------------------------------------------------------------
TABLES : ZVBL_INOU.  " ���Կ������� + ���ԽŰ� DATABASE VIEW


*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       GUBUN      TYPE C,                        " ���� ��?
       ZFBLNO     LIKE ZTBLINR-ZFBLNO,           " B/L ������?
       ZFHBLNO    LIKE ZTBL-ZFHBLNO,
       ZFBTSEQ    LIKE ZTBLINR-ZFBTSEQ,          " ������� �Ϸù�?
       ZFUSCD     LIKE ZTBLINR-ZFUSCD,
       ZFPRIN     LIKE ZTBLINR-ZFPRIN,
       ZFINTY     LIKE ZTBLINR-ZFINTY,
       CHECK(1),
       ZFLOCK     TYPE C VALUE 'N',
END OF IT_SELECTED.

*-----------------------------------------------------------------------
* Internal Table Define
*-----------------------------------------------------------------------
DATA : IT_ZVREQ   LIKE ZVREQHD_ST OCCURS 0 WITH HEADER LINE.

*-----------------------------------------------------------------------
* Menu Statsu Function�� Inactive�ϱ� ���� Internal Table
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_EXCL OCCURS 20,
      FCODE    LIKE RSMPE-FUNC.
DATA: END   OF IT_EXCL.


DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_SUBRC           LIKE SY-SUBRC,
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_ZFINOU          LIKE ZTIMIMG00-ZFINOU,
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_OK_CODE         LIKE SY-UCOMM,      " OK-CODE
       W_OK_CODE_OLD     LIKE SY-UCOMM,      " OK-CODE
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C,
       W_STATUS          TYPE C.
