*----------------------------------------------------------------------*
*   INCLUDE ZRIMCLICTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ�(�������) �ڷ� ����                          *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.25                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
TABLES : ZTBL,            " Bill of Lading
         ZTBLINOU,        " ������?
         ZTBLINR,         " ���Խ�?
         ZTREQHD,         " ������?
         ZTREQST,         " �����Ƿ� ��?
         ZTIV,            " Invoice
         ZTIVIT,          " Invoice Item
         ZTCUCLIV,        " ��� Invoice
         ZTCUCLIVIT,      " ��� Invoice Item
         ZTCUCL,          " ��?
         ZTIMIMG06,       " ���ȯ?
         ZTIDR,           " ���Խ�?
         ZTIDRHS,         " ���ԽŰ� ����?
         ZTIDRHSD,        " ���ԽŰ� ��?
         ZTIDRHSL,        " ���ԽŰ� ���Ȯ?
         ZTREQIL,         " ������õ ��?
         ZTIMIMG01,       " Payment Term Configuration
         ZTIMIMG00,       " ���Խý��� Basic Config
         EKKO.            " Purchasing Document Header
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFIVNO     LIKE ZTIV-ZFIVNO,           "Invoice ������?
      ZFBLNO     LIKE ZTIV-ZFBLNO,           "B/L ������?
      ZFCUST     LIKE ZTIV-ZFCUST,           "�����?
      ZFCLSEQ    LIKE ZTCUCL-ZFCLSEQ,        "�����?
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED_TMP OCCURS 0,
      ZFIVNO     LIKE ZTIV-ZFIVNO,           "Invoice ������?
      ZFBLNO     LIKE ZTIV-ZFBLNO,           "B/L ������?
      ZFCUST     LIKE ZTIV-ZFCUST,           "�����?
      ZFCLSEQ    LIKE ZTCUCL-ZFCLSEQ,        "�����?
END OF IT_SELECTED_TMP.
*-----------------------------------------------------------------------
* ��� Table Key
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CUCL OCCURS 0,
      ZFBLNO     LIKE ZTCUCL-ZFBLNO,         " B/L ������?
      ZFCLSEQ    LIKE ZTCUCL-ZFCLSEQ,        " �����?
END OF IT_CUCL.
*-----------------------------------------------------------------------
* �����Ƿ� Table Key
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_REQHD OCCURS 0,
      ZFREQNO    LIKE ZTREQHD-ZFREQNO,       " �����Ƿ� ������?
END OF IT_REQHD.
*-----------------------------------------------------------------------
* ��/�� ����?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IDRIT OCCURS 0,
      ZFBLNO     LIKE ZTCUCLIV-ZFBLNO,         " B/L ������?
      ZFREQNO    LIKE ZTREQHD-ZFREQNO,         " �����Ƿ� ������?
      ZFIVNO     LIKE ZTCUCLIVIT-ZFIVNO,       " Invoice ������?
      ZFIVDNO    LIKE ZTCUCLIVIT-ZFIVDNO,      " Invoice Item �Ϸù�?
      MATNR      LIKE ZTCUCLIVIT-MATNR,        " Material number
      STAWN      LIKE ZTCUCLIVIT-STAWN,        " H/S Code
      MENGE      LIKE ZTCUCLIVIT-MENGE,        " Invoice ��?
      MEINS      LIKE ZTCUCLIVIT-MEINS,        " Base unit of measure
      NETPR      LIKE ZTCUCLIVIT-NETPR,        " Net price
      PEINH      LIKE ZTCUCLIVIT-PEINH,        " Price unit
      BPRME      LIKE ZTCUCLIVIT-BPRME,        " Order price unit
      TXZ01      LIKE ZTCUCLIVIT-TXZ01,        " Short Text
      ZFIVAMT    LIKE ZTCUCLIVIT-ZFIVAMT,      " Invoice ��?
      ZFIVAMC    LIKE ZTCUCLIVIT-ZFIVAMC,      " Invoice �ݾ� ��?
      ZFCONO     LIKE ZTIDRHSD-ZFCONO,         " ����?
      ZFRONO     LIKE ZTIDRHSD-ZFRONO,         " �԰�(��)��?
END OF IT_IDRIT.

DATA : W_ZFAPLDT         LIKE ZTIMIMG06-ZFAPLDT,
       W_PROC_CNT        TYPE I,             " ó����?
       W_CRET_CNT        TYPE I,             " ������?
       W_LOOP_CNT        TYPE I,             " Loop Count
       W_MENGE           LIKE ZTCUCLIVIT-MENGE,
       W_ZFIVNO          LIKE ZTCUCLIV-ZFIVNO,
       W_ZFBTSEQ         LIKE ZTBLINR-ZFBTSEQ,
       W_ZFQNT           LIKE ZTIDRHS-ZFQNT,
       W_ZFLASTAM        LIKE ZTREQHD-ZFLASTAM,
       W_ZFCKAMT         LIKE ZTRECST-ZFCKAMT,
       W_ZFINAMT         LIKE ZTIDR-ZFINAMT,
       W_ZFDUAM          LIKE ZTIDR-ZFDUAM,
       W_ZFIVAMT         LIKE ZTCUCLIV-ZFIVAMT,
       W_ZFIVAMT_S       LIKE ZTIV-ZFIVAMT,
       W_ZFIVPKHD        LIKE ZTIV-ZFIVAMT.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.

DATA  W_SUBRC            LIKE SY-SUBRC.
