*&---------------------------------------------------------------------*
*&  INCLUDE ZRIMIVPRCTOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Invoice Processing - �԰�ó��,                        *
*&                                    �����, I/V, G/R,              *
*&                                    �ݾ�Ȯ��, �ݾ���ȸ, Status ����  *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.21                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : ZTIV,            ">�����û.
         *ZTIV,           ">�����û HEADER.
         ZTIVIT,          ">�����û Item
         ZTMSHD,          ">�𼱰��� HEADER.
         ZTBL,            ">Bill of Lading
         ZTBLCST,         ">B/L ���.
         ZTCUCL,          ">���.
         ZTCUCLIV,        ">��� Invoice
         ZTREQHD,         ">�����Ƿ�.
         ZTRECST,         ">�����Ƿں��.
         ZTREQST,         ">�����Ƿڻ���/
         ZTPMTHD,         ">Payment Notice Head
         ZTPMTIV,         ">Payment Notice Invoice
         TCURS,           ">ȯ��.
         ZTIDSUS,
         ZTIMIMG00,       ">���Խý��� Basic Config
         ZTIMIMG01,       ">Payment Term Configuration
         ZTIMIMG04,       ">Planned Cost Rate
         ZTIMIMG11,       ">G/R, I/V, ���ó�� Configuration
         LFBK,            ">Vendor Master (Bank Details)
         EKPO,            ">Purchasing Document Item
         EKET,            ">Scheduling Agreement Schedule Line
         T156,            ">Movement Type
         T001L,           ">Storage Locations
         SPOP.            ">POPUP_TO_CONFIRM_...
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFIVNO     LIKE ZTIV-ZFIVNO,           "Invoice ������?
END OF IT_SELECTED.

*-----------------------------------------------------------------------
* ����п� ���� Table
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CST OCCURS 0,
      ZFIVNO      LIKE ZTIV-ZFIVNO,          " Invoice ������ȣ.
*      ZFREQNO     LIKE ZTIV-ZFREQNO,         " �����Ƿ� ������ȣ.
      ZFBLNO      LIKE ZTIV-ZFBLNO,          " B/L ������ȣ.
      ZFCLSEQ     LIKE ZTCUCL-ZFCLSEQ,       " �������.
      ZFIVAMK     LIKE ZTIV-ZFIVAMK,         " Invoice �ݾ�(��ȭ)
      ZFLASTAMK   LIKE ZTREQHD-ZFLASTAM,     " L/C �����ݾ�(��ȭ)
      ZFIVAMTSK   LIKE ZTIV-ZFIVAMT,         " B/L �ݾ�(��ȭ) I/V ��?
      ZFIDRAMK    LIKE ZTIV-ZFIVAMT,         " ���(��ȭ)��?
      ZFLCCSK     LIKE ZTRECST-ZFCAMT,       " �����Ƿں�?
      ZFBLCSK     LIKE ZTBLCST-ZFCAMT,       " B/L ���.
      ZFCRCSK     LIKE ZTCUCLCST-ZFCAMT,     " ������.
      ZFCUAMT     LIKE ZTCUCLCST-ZFCAMT,     " ����.
      ZFPLRTE     LIKE ZTIVIT-ZFPLRTE,       " Planned Cost Rate
END OF IT_CST.

DATA : W_ZFOPNDT         LIKE ZTREQST-ZFOPNDT,      " ����?
       W_ZFAPLDT         LIKE ZTIMIMG04-ZFAPLDT,    " ����?
       W_ZFEXRT          LIKE ZTIV-ZFEXRT,          " ȯ?
       W_PROC_CNT        TYPE I,                    " ó���Ǽ�.
       W_ERR_CNT         TYPE I,
       W_ZFCST           LIKE ZTIV-ZFPCST,          " ��������?
       W_ZFIVAMP         LIKE ZTIV-ZFIVAMT,         " Invoice ó���ݾ�.
       W_ZFIVPDT         LIKE ZTIVHST-BUDAT,     " I/V Posting Date
       W_ZFIVDDT         LIKE ZTIVHST-BLDAT,     " I/V Document Date
       W_ZFGRPDT         LIKE ZTIVHST-BUDAT,     " G/R Posting Date
       W_ZFGRDDT         LIKE ZTIVHST-BLDAT,     " G/R Document Date
       W_ZFIDSDT         LIKE ZTIDS-ZFIDSDT,
       W_BWARTWE         LIKE RM07M-BWARTWE,        " Movement Type
       W_LGORT           LIKE RM07M-LGORT,          " Storage Locaion
       W_ZFAMDNO         LIKE ZTREQST-ZFAMDNO,      " Amend Seq.
       W_WEPOS           LIKE EKPO-WEPOS,
       RADIO_NONE(1)     TYPE C,
       RADIO_ALL(1)      TYPE C,
       RADIO_ERROR(1)    TYPE C,
       DISPMODE(1)       TYPE C.
*-----------------------------------------------------------------------
* BDC �� Table
*-----------------------------------------------------------------------
DATA:    BEGIN OF ZBDCDATA OCCURS 0.
         INCLUDE STRUCTURE BDCDATA.
DATA     END OF ZBDCDATA.

DATA : W_LFA1            LIKE LFA1,
       W_LFA12           LIKE LFA1,
       W_EBELN           LIKE ZTREQHD-EBELN,
       W_MENGE           LIKE EKET-MENGE,
       W_WEMNG           LIKE EKET-WEMNG,
       W_WERKS           LIKE ZTREQHD-ZFWERKS,
       TEMP_KURSF(10),
       TEMP_WRBTR(16),
       TEMP_BKTXT        LIKE BKPF-BKTXT,
       TEMP_MENGE(17),
       TEMP_BLART(2),
       TEMP_FNAM         LIKE BDCDATA-FNAM,
       TEMP_XBLNR(16),
       TEMP_ERFMG(17),
       OK-CODE           LIKE SY-UCOMM,
       LOOP_CNT(2).
*-----------------------------------------------------------------------
DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       F(20)             TYPE C,             " Field Name Alias
       LINE              TYPE I,
       W_BUTTON_ANSWER   TYPE C,
       W_LOOPLINES       LIKE SY-LOOPC,
       W_OLD_SUBRC       LIKE SY-SUBRC,
       W_ROW_MARK        TYPE C,
       G_PARAM_LINE      LIKE SY-TABIX.
DATA:  W_AMTTXT1(19),
       W_AMTTXT2(19),
       W_AMTLEN1 TYPE I,
       W_AMTLEN2 TYPE I.
