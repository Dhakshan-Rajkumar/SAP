*----------------------------------------------------------------------*
*   INCLUDE ZRIMTIVSTOP                                                *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���ݰ�꼭�� Invoice ��ȸ                             *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.03.07                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
TABLES : EKKO,
         EKPO,
         EKAB,
         ZTVTIV,          " ���ݰ�꼭�� Invoice
         ZTVTIVIT,        " ���ݰ�꼭�� Invoice Item
*        ZZJ_1KFBUSPL,    " Business Place Data
         ZVVTIV_IT,       " VIEW TABLE.
         ZTVT,            " ���ݰ��?
         ZTVTSG1,         " ���ݰ�꼭 Seg 1
         ZTVTSG3,         " ���ݰ�꼭 Seg 3
         ZTRED,           " �μ�?
         ZTREDSG1,        " �μ��� Seg 1
         ZTREQHD,         " ������?
         ZTREQST,         " �����Ƿڻ�?
         ZTREQIT,         " ���� ������.
         ZTLLCHD,         " Local L/C Header
         ZTLLCAMHD,       " Local L/C Amend
*        ZTBPADDR,        " stcd2 per bupla (����庰 �ּ�)
         ZTIMIMG00,       " ���Խý��� Basic Config
         ZTIMIMGTX,
         LFA1,            " Vendor Master (General Section)
         MAKT,
         J_1BT001WV,      " Assign Branch to Plant
         ZVT001W.
*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFGFDYR     LIKE ZTVTIV-ZFGFDYR,           "���� ȸ����ǥ��?
      ZFGFDNO     LIKE ZTVTIV-ZFGFDNO,           "���� ȸ����ǥ��?
      BUKRS       LIKE ZTVTIV-BUKRS,             "���� ȸ����ǥ��?
*      ZFDOCST     LIKE ZTRE
      ZFVTNO      LIKE ZTVT-ZFVTNO,              " ���ݰ�꼭 ������?
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* ���ݰ�꼭 ��?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_ZTVT OCCURS 0,
      ZFGFDYR     LIKE ZTVTIV-ZFGFDYR,           " ���� ȸ����ǥ��?
      ZFGFDNO     LIKE ZTVTIV-ZFGFDNO,           " ���� ȸ����ǥ��?
      BUKRS       LIKE ZTVTIV-BUKRS,             " ȸ���ڵ�.
      ZFREQTY     LIKE ZTVTIVIT-ZFREQTY,         " �����Ƿ� Type
      LIFNR       LIKE ZTVTIV-LIFNR,             " Vendor
      EBELN       LIKE ZTVTIVIT-EBELN,           " P/O No
      EBELP       LIKE ZTVTIVIT-EBELP,           " P/O Item
      MATNR       LIKE ZTVTIVIT-MATNR,           " �����ڵ�.
      ZFWERKS     LIKE ZTVTIVIT-ZFWERKS,         " Plant
      ZFDODT      LIKE ZTVTIV-ZFDODT,            " Document Date
END OF IT_ZTVT.
*-----------------------------------------------------------------------
* ���ݰ�꼭 ��?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_ZTVT_S OCCURS 0,
      ZFGFDYR     LIKE ZTVTIV-ZFGFDYR,           " ���� ȸ����ǥ��?
      ZFGFDNO     LIKE ZTVTIV-ZFGFDNO,           " ���� ȸ����ǥ��?
      BUKRS       LIKE ZTVTIV-BUKRS,             " ȸ���ڵ�.
      ZFREQTY     LIKE ZTVTIVIT-ZFREQTY,         " �����Ƿ� Type
      LIFNR       LIKE ZTVTIV-LIFNR,             " Vendor
      EBELN       LIKE ZTVTIVIT-EBELN,           " P/O No
      ZFWERKS     LIKE ZTVTIVIT-ZFWERKS,         " Plant
      ZFDODT      LIKE ZTVTIV-ZFDODT,            " Document Date
END OF IT_ZTVT_S.
*-----------------------------------------------------------------------
* �μ��� ��?
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
* �μ��� ��?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_ZTRED OCCURS 0,
      BUKRS       LIKE ZTVTIV-BUKRS,         " ȸ���ڵ�.
      LIFNR       LIKE ZTVTIV-LIFNR,         " Vendor
      EBELN       LIKE ZTVTIVIT-EBELN,       " P/O No
      EBELP       LIKE ZTVTIVIT-EBELP,       " P/O ITEM
      KONNR       LIKE EKAB-KONNR,
      KTPNR       LIKE EKAB-KTPNR,
      BSTYP       LIKE EKKO-BSTYP,
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




DATA: BEGIN OF IT_ZTRED_S OCCURS 0,
      ZFGFDYR     LIKE ZTVTIV-ZFGFDYR,       " ���� ȸ����ǥ��?
      ZFGFDNO     LIKE ZTVTIV-ZFGFDNO,       " ���� ȸ����ǥ��?
      BUKRS       LIKE ZTVTIV-BUKRS,             " ȸ���ڵ�.
      LIFNR       LIKE ZTVTIV-LIFNR,         " Vendor
      EBELN       LIKE ZTVTIVIT-EBELN,       " P/O No
      ZFWERKS     LIKE ZTVTIVIT-ZFWERKS,     " Plant
      ZFVTNO      LIKE ZTVTIV-ZFVTNO,        " ���ݰ�꼭 ������?
END OF IT_ZTRED_S.
*-----------------------------------------------------------------------
*>> SIMULATION DATA INTERNAL TABLE
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SIM OCCURS 0,
      SORT        TYPE C,
      LIFNR       LIKE ZTVT-LIFNR,
      NAME(20)    TYPE C,
      ZFWERKS     LIKE ZTVTIVIT-ZFWERKS,
      ZFREQTY     LIKE ZTVTIVIT-ZFREQTY,
      ZFVCDT      LIKE ZTVT-ZFVCDT,
      ZFTOTAM     LIKE ZTVT-ZFTOTAM,
      ZFTSAMK     LIKE ZTVT-ZFTSAMK,
      ZFTTXAM     LIKE ZTVT-ZFTTXAM,
      ZFTSAMF     LIKE ZTVT-ZFTSAMF,
      ZFTSAMFC    LIKE ZTVT-ZFTSAMFC,
      EBELN       LIKE ZTVTIVIT-EBELN,
      MATNR       LIKE ZTVTSG3-MATNR,
      ZFGONM(20)  TYPE C,
      ZFQUN       LIKE ZTVTSG3-ZFQUN,
      ZFQUNM      LIKE ZTVTSG3-ZFQUNM,
      ZFSAMK      LIKE ZTVTSG3-ZFSAMK,
      ZFSAMF      LIKE ZTVTSG3-ZFSAMF,
      ZFSAMFC     LIKE ZTVTSG3-ZFSAMFC,
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



DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_LOOP_CNT        TYPE I,
       W_MOD             TYPE I,
       INCLUDE(8)        TYPE C,
       W_ZFOPNNO         LIKE ZTREQHD-ZFOPNNO,
       W_ZFREQNO         LIKE ZTREQHD-ZFREQNO,
       W_ZFAMDNO         LIKE ZTREQST-ZFAMDNO,
       W_ZFLSG3          LIKE ZTVTSG3-ZFLSG3,
       W_ZFLSG1          LIKE ZTREDSG1-ZFLSG1,
       W_ZFVTNO          LIKE ZTVT-ZFVTNO,
       W_ZFREDNO         LIKE ZTVTIV-ZFREDNO,
       W_ZFREQTY         LIKE ZTREQHD-ZFREQTY,
       W_MATNR           LIKE ZTVTIVIT-MATNR,
       W_ZFSAMF          LIKE ZTVTSG3-ZFSAMF,
       W_ZFSAMK          LIKE ZTVTSG3-ZFSAMK,
       W_ZFREAMF         LIKE ZTRED-ZFREAMF,
       W_ZFREAMK         LIKE ZTRED-ZFREAMK,
       SV_BUKRS          LIKE ZTVT-BUKRS,
       SV_ZFREQTY        LIKE ZTVTIVIT-ZFREQTY,
       SV_LIFNR          LIKE ZTVTIV-LIFNR,
       SV_ZFDODT         LIKE ZTVTIV-ZFDODT,
       SV_ZFWERKS        LIKE ZTVTIVIT-ZFWERKS,
       SV_EBELN          LIKE ZTVTIVIT-EBELN,
       SV_KONNR          LIKE EKAB-KONNR,
       SV_BSTYP          LIKE EKKO-BSTYP,
       SV_MATNR          LIKE ZTVTIVIT-MATNR,
       SV_ZFVTNO         LIKE ZTVTIV-ZFVTNO,
       SUM_ZFTOTAM       LIKE ZTVT-ZFTOTAM,
       SUM_ZFTTXAM       LIKE ZTVT-ZFTTXAM,
       SUM_ZFTSAMK       LIKE ZTVT-ZFTSAMK,
       SUM_ZFTSAMF       LIKE ZTVT-ZFTSAMF,
       SV_ZFTSAMFC       LIKE ZTVT-ZFTSAMFC,
       W_CNT             TYPE I.

DATA : W_ERR_CHK(1)      TYPE C,
       W_ZFVTNO_NM(28)   TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LFA1            LIKE LFA1,          " ����?
       W_ADRC            LIKE ADRC,
       W_LIST_INDEX      LIKE SY-TABIX,
       W_BUKRS           LIKE ZTVTIV-BUKRS,
       W_ZFGFDYR         LIKE ZTVTIV-ZFGFDYR,
       W_ZFGFDNO         LIKE ZTVTIV-ZFGFDNO,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.
