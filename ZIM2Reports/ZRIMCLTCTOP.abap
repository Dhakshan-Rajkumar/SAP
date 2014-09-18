*----------------------------------------------------------------------*
*   INCLUDE ZRIMCLTCTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ�(�������) �ڷ� ����                          *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.03.07                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTBL,            " Bill of Lading
         ZTCUCLIV,        " ��� Invoice
         ZTCUCLIVIT,      " ��� Invoice Item
         ZTCUCL,          " ��?
         ZTIMIMGTX,
         ZTIDR,           " ���Խ�?
         ZTIDRHS,         " ���ԽŰ� ����?
         ZTIDRHSD,        " ���ԽŰ� ��?
         ZTIDRHSL,        " ���ԽŰ� ���Ȯ?
         ZTBLIT  ,
         ZTIMIMG01,       " Payment Term Configuration
         ZTIMIMG02,       " Payment Term Configuration
         ZTIMIMG00.       " ���Խý��� Basic Config
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFIVNO     LIKE ZTCUCLIV-ZFIVNO,           "Invoice ������?
      ZFBLNO     LIKE ZTCUCLIV-ZFBLNO,           "B/L ������?
      ZFCUST     LIKE ZTCUCLIV-ZFCUST,           "�����?
      ZFCLSEQ    LIKE ZTCUCLIV-ZFCLSEQ,        "�����?
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* ��� Table Key
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CUCL OCCURS 0,
      ZFBLNO     LIKE ZTCUCL-ZFBLNO,         " B/L ������?
      ZFCLSEQ    LIKE ZTCUCL-ZFCLSEQ,        " �����?
END OF IT_CUCL.
*-----------------------------------------------------------------------
* ����� INVOICE INTERNAL TABLE.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IVIT OCCURS 0.
      INCLUDE STRUCTURE ZTCUCLIVIT.
DATA : END OF IT_IVIT.
*-----------------------------------------------------------------------
* ��/�� ����?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IDRIT OCCURS 0,
      ZFBLNO     LIKE ZTCUCLIV-ZFBLNO,         " B/L ������?
*      ZFREQNO    LIKE ZTIV-ZFREQNO,            " �����Ƿ� ������?
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

RANGES  R_TERM    FOR    ZTCUCLIV-ZFCUST    OCCURS 10.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_CRET_CNT        TYPE I,             " ������?
       W_MENGE           LIKE ZTCUCLIVIT-MENGE,
       W_ZFQNT           LIKE ZTIDRHS-ZFQNT,
       W_ZFBLNO          LIKE ZTCUCLIV-ZFBLNO,
       W_ZFCLSEQ         LIKE ZTCUCLIV-ZFCLSEQ.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_STAMT           LIKE ZTIDR-ZFSTAMT,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I.
