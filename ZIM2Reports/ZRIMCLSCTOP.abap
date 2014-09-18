*----------------------------------------------------------------------*
*   INCLUDE ZRIMCLSCTOP                                                *
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
         ZTREQHD,         " ������?
         ZTREQST,         " �����Ƿ� ��?
         ZTIV,            " Invoice
         ZTIVIT,          " Invoice Item
         ZTCUCLIV,        " ��� Invoice
         ZTCUCLIVIT,      " ��� Invoice Item
         ZTCUCL,          " ��?
         ZTIMIMG06,       " ���ȯ?
         ZTIMIMGTX,
         ZTIDR,           " ���Խ�?
         ZTIDRHS,         " ���ԽŰ� ����?
         ZTIDRHSD,        " ���ԽŰ� ��?
         ZTIDRHSL,        " ���ԽŰ� ���Ȯ?
         ZTREQIL,         " ������õ ��?
         ZTIMIMG01,       " Payment Term Configuration
         ZTIMIMG00,       " ���Խý��� Basic Config
         ZTIMIMG08,
         ZTIMIMG10,
         ZTIMIMG03,
         LFA1,
         T001,
         EKKO.            " Purchasing Document Header
*-----------------------------------------------------------------------
* INVOICE TABLE INTERNAL TABLE.
*-----------------------------------------------------------------------
DATA:  BEGIN OF IT_TAB OCCURS 0,
       ZFIVNO    LIKE   ZTIV-ZFIVNO,
       ZFBLNO    LIKE   ZTIV-ZFBLNO,
       ZFHBLNO   LIKE   ZTBL-ZFHBLNO,
       ZFCUT     LIKE   ZTIDR-ZFCUT,         " ������.
       ZFCLSEQ   LIKE   ZTIDR-ZFCLSEQ,
       NAME1     LIKE   LFA1-NAME1,
       ZFIVAMT   LIKE   ZTIV-ZFIVAMT,
       ZFIVAMC   LIKE   ZTIV-ZFIVAMC,
       ZFIVAMK   LIKE   ZTIV-ZFIVAMK,
       ZFEXRT    LIKE   ZTIV-ZFEXRT,
       ZFPOYN    LIKE   ZTIV-ZFPOYN,
       POYN(07)  TYPE   C,
       LIFNR     LIKE   ZTIV-LIFNR,
       NAME2     LIKE   LFA1-NAME1,
       ZFPHVN    LIKE   ZTIV-ZFPHVN,
       ZFINRC    LIKE   ZTIDR-ZFINRC,        " �Ű��� ����.
       INRC      LIKE   DD07T-DDTEXT,        " �Ű��� ����.
       ZFINRCD   LIKE   ZTIDR-ZFINRCD,
       INRCD     LIKE   DD07T-DDTEXT,
       ZFCLCD    LIKE   ZTIV-ZFCLCD,         " �������.
       ZFREBELN  LIKE   ZTBL-ZFREBELN,       " ��ǥ P/O NO.
       ZFRPTTY   LIKE   ZTBL-ZFRPTTY,        " ���ԽŰ�����.
       ZFSHNO    LIKE   ZTBL-ZFSHNO,         " ��������.
       IMTRD     LIKE   ZTBL-IMTRD,          " �����ڱ���.
       BUTXT     LIKE   T001-BUTXT,          " ȸ���̸�.
       BUKRS     LIKE   ZTBL-BUKRS,          " ȸ���ڵ�.
       RPTTY     LIKE   DD07T-DDTEXT,        " ���ԽŰ�����.
       ZFPONC    LIKE   ZTIDR-ZFPONC,        " ���԰ŷ�����.
       ZFCOCD    LIKE   ZTIDR-ZFCOCD,        " ¡������.
       COCD      LIKE   DD07T-DDTEXT,        " ¡������.
       INCO1     LIKE   ZTIDR-INCO1,         " INCOTERMS.
       ZFINAMT   LIKE   ZTIDR-ZFINAMT,       " �����.
       ZFTFA     LIKE   ZTIDR-ZFTFA,         " ������.
       ZFTFAC    LIKE   ZTIDR-ZFTFAC,        " ������.
       ZFBNARCD  LIKE   ZTIDR-ZFBNARCD,
       PONC      LIKE   ZTIMIMG08-ZFCDNM,    "
       ZFITKD    LIKE   ZTIDR-ZFITKD,        " ��������.
       ITKD      LIKE   DD07T-DDTEXT,        " ��������.
       ZFBNARM   LIKE   ZTIMIMG03-ZFBNARM,
       ZFCUST    LIKE   ZTIV-ZFCUST,
       CUST      LIKE   DD07T-DDTEXT,
       ZFGRST    LIKE   ZTIV-ZFGRST,
       GRST      LIKE   DD07T-DDTEXT,
       ZFCIVST   LIKE   ZTIV-ZFCIVST,
END OF IT_TAB.
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

RANGES  R_TERM1   FOR    ZTIV-ZFPOYN    OCCURS 10.
RANGES  R_TERM2   FOR    ZTIV-ZFCLCD    OCCURS 10.
RANGES  R_TERM3   FOR    ZTIV-ZFCUST    OCCURS 10.

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
       W_ZFIVPKHD        LIKE ZTIV-ZFIVAMT,
       W_ZFBLNO          LIKE ZTIV-ZFBLNO,
       W_ZFCLSEQ         LIKE ZTCUCL-ZFCLSEQ.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C,
       W_NAME1(35)       TYPE C,
       W_GUBN            TYPE C,
       W_POYN(4)         TYPE C.
