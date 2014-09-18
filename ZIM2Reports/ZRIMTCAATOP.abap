*----------------------------------------------------------------------
*   INCLUDE ZRIMTCAATOP
*----------------------------------------------------------------------
*&  ���α׷��� : ���ݰ�꼭 ����/�����/EDI Flat File ����
*&      �ۼ��� : �迬�� INFOLINK Ltd.
*&      �ۼ��� : 2000.03.07
*&  ����ȸ��PJT:
*
*&---------------------------------------------------------------------
*&   DESC.     :
*&
*&---------------------------------------------------------------------

TABLES : ZTVT,      " ���ݰ��?
         ZTVTSG1,   " ���ݰ�꼭 Seg1
         ZTVTSG3,   " ���ݰ�꼭 Seg3
         ZTVTIV,    " ���ݰ�꼭�� Invoice
         ZTVTIVIT,  " ���ݰ�꼭�� Invoice Item
         ZVVTIV_IT,
         ZTIMIMGTX,
         MAKT,
         ZTRED,     " �μ�?
         ZTREDSG1,
         ZTREQHD,
         ZTREQIT,
         ZTLLCHD,
         ZTLLCAMHD,
         LFA1,      " Vendor Master (General Section)
         SPOP.      " POPUP_TO_CONFIRM_... function ��� �˾�ȭ�� ��?
*----------------------------------------------------------------------
* SELECT RECORD?
*----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFVTNO     LIKE ZTVT-ZFVTNO,      " ���ݰ�꼭 ������?
      LIFNR      LIKE LFA1-LIFNR,       " Vendor Code
      ZFDOCNO    LIKE ZTVT-ZFDOCNO,     " ���� ������?
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* �μ��� ��?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_ZTRED OCCURS 0,
      BUKRS       LIKE ZTVTIV-BUKRS,         " ȸ���ڵ�.
      LIFNR       LIKE ZTVTIV-LIFNR,         " Vendor
      EBELN       LIKE ZTVTIVIT-EBELN,       " P/O No
      EBELP       LIKE ZTVTIVIT-EBELP,       " P/O ITEM
      ZFVTNO      LIKE ZTVTIV-ZFVTNO,        " ���ݰ�꼭 ������?
      NETPR       LIKE ZTVTIVIT-NETPR,
      BPRME       LIKE ZTVTIVIT-BPRME,
      PEINH       LIKE ZTVTIVIT-PEINH,
      ZFQUN       LIKE ZTVTIVIT-ZFQUN,
      ZFQUNM      LIKE ZTVTIVIT-ZFQUNM,
      ZFREAM      LIKE ZTREDSG1-ZFREAM,
      ZFREAMC     LIKE ZTREDSG1-ZFREAMC,
      ZFREAMK     LIKE ZTVTIVIT-ZFKAMT,
      MATNR       LIKE ZTVTIVIT-MATNR,
END OF IT_ZTRED.
*-----------------------------------------------------------------------
*>> SIMULATION DATA INTERNAL TABLE
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SIM OCCURS 0,
      SORT        TYPE C,
      ZFISNO      LIKE ZTRED-ZFISNO,
      LIFNR       LIKE ZTRED-LIFNR,
      ZFSCONM(20) TYPE C,
      ZFLLCON(25) TYPE C,
      ZFRCONM     LIKE ZTRED-ZFRCONM,
      EBELN       LIKE ZTRED-EBELN,
      EBELP       LIKE ZTREDSG1-EBELP,
      ZFTQUN      LIKE ZTRED-ZFTQUN,
      ZFTQUNM     LIKE ZTRED-ZFTQUNM,
      ZFTREAMF    LIKE ZTRED-ZFREAMF,
      ZFTREAMFC   LIKE ZTRED-ZFREAMFC,
      ZFTREAMK    LIKE ZTRED-ZFREAMK,
      MATNR       LIKE ZTREDSG1-MATNR,
      MAKTX(30)   TYPE C,
      ZFQUN       LIKE ZTREDSG1-ZFQUN,
      ZFQUNM      LIKE ZTREDSG1-ZFQUNM,
      ZFREAM      LIKE ZTREDSG1-ZFREAM,
      ZFREAMC     LIKE ZTREDSG1-ZFREAMC,
      ZFREAMK     LIKE ZTREDSG1-ZFREAM,
END OF IT_SIM.
*>> MESSAGE ��¿�.
TABLES : BAL_S_DMSG.
*-----------------------------------------------------------------------
*   ERROR ó����.
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON       LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(255) TYPE C.
DATA : END OF IT_ERR_LIST.
DATA:   MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
DATA:   MESSTXT(255) TYPE C.

DATA : W_ZFDHENO       LIKE   ZTDHF1-ZFDHENO,
       W_ZFCDDOC       LIKE   ZTCDF1-ZFCDDOC,
       W_ZFDHREF       LIKE   ZTDHF1-ZFDHREF,
*       W_ZFDHDDB       LIKE   ZTDHF1-ZFDHDDB,
       W_ZFDHSRO       LIKE   ZTDHF1-ZFDHSRO,
       W_ZFVTNO        LIKE   ZTVT-ZFVTNO,
       W_ZFLSG1        LIKE   ZTREDSG1-ZFLSG1.

DATA : OPTION(1)       TYPE C,             " ���� popup Screen���� ��?
       ANTWORT(1)      TYPE C,             " ���� popup Screen���� ��?
       CANCEL_OPTION   TYPE C,             " ���� popup Screen���� ��?
       TEXTLEN         TYPE I,             " ���� popup Screen���� ��?
       W_PROC_CNT      TYPE I.             " ó����?

DATA : INCLUDE(8)        TYPE C,
       W_ERR_CHK(1)      TYPE C,
       W_YN(2)           TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_MOD             TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_ERR_CNT         TYPE I,             " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,
       W_LIST_INDEX      LIKE SY-TABIX,
       W_ZFREQTY         LIKE ZTVTIVIT-ZFREQTY,
       W_ZFREDNO         LIKE ZTVTIV-ZFREDNO,
       W_BUKRS           LIKE ZTVTIV-BUKRS,
       W_ZFGFDYR         LIKE ZTVTIV-ZFGFDYR,
       W_ZFGFDNO         LIKE ZTVTIV-ZFGFDNO,
       W_ZFOPNNO         LIKE ZTREQHD-ZFOPNNO,
       W_ZFREQNO         LIKE ZTREQHD-ZFREQNO,
       W_ZFAMDNO         LIKE ZTREQST-ZFAMDNO,
       SV_BUKRS          LIKE ZTVT-BUKRS,
       SV_ZFVTNO         LIKE ZTVT-ZFVTNO,
       SV_EBELN          LIKE ZTVTIVIT-EBELN,
       SV_LIFNR          LIKE ZTRED-LIFNR,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_UPDATE_CNT      TYPE I.
