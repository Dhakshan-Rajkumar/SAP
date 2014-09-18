&---------------------------------------------------------------------*
*&  INCLUDE ZRIMCDISTTOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���纰 �δ��� ����� ���� Include                   *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.21                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTBL,            " Bill of Lading
         ZTBLCST,         " B/L ��?
         ZTCUCL,          " ��?
         ZTCUCLIV,        " ��� Invoice
         ZTIV,            " Invoice
         ZTIVIT,          " Invoice Item
         ZTREQHD,         " ������?
         ZTRECST,         " �����Ƿں�?
         ZTREQST,         " �����Ƿڻ�?
         TCURS.           " ȯ?
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFBLNO  LIKE ZTCUCL-ZFBLNO,            " B/L ������?
      ZFCLSEQ LIKE ZTCUCL-ZFCLSEQ,           " �����?
END OF IT_SELECTED.

*-----------------------------------------------------------------------
* ����п� ���� Table
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CST OCCURS 0,
      ZFIVNO      LIKE ZTIV-ZFIVNO,          " Invoice ������?
      ZFREQNO     LIKE ZTIV-ZFREQNO,         " �����Ƿ� ������?
      ZFBLNO      LIKE ZTIV-ZFBLNO,          " B/L ������?
      ZFCLSEQ     LIKE ZTCUCL-ZFCLSEQ,       " �����?
      ZFIVAMK     LIKE ZTIV-ZFIVAMK,         " Invoice �ݾ�(��ȭ)
      ZFLASTAMK   LIKE ZTREQHD-ZFLASTAM,     " L/C �����ݾ�(��ȭ)
      ZFIVAMTSK   LIKE ZTIV-ZFIVAMT,         " B/L �ݾ�(��ȭ) I/V ��?
      ZFIDRAMK    LIKE ZTCUCL-ZFIDRAM,       " ���ԽŰ��?
      ZFLCCSK     LIKE ZTRECST-ZFCAMT,       " �����Ƿں�?
      ZFBLCSK     LIKE ZTBLCST-ZFCAMT,       " B/L ��?
      ZFCRAMT     LIKE ZTCUCL-ZFCRAMT,       " �������?
      ZFPLRTE     LIKE ZTIV-ZFPLRTE,         " Planned Cost Rate
*     ZFCUAMT     LIKE ZTCUCL-ZFCUAMT,       " ��?
END OF IT_CST.

DATA : W_ZFOPNDT  LIKE ZTREQST-ZFOPNDT,      " ����?
       W_GDATU    LIKE TCURS-GDATU.          " ����?

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
