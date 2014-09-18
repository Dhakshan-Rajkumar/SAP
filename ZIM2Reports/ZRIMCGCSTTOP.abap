*----------------------------------------------------------------------*
*   INCLUDE ZRIMRECSTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : �����Ƿں�� Posting                                  *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.03.23                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : �����Ƿ� ����� ��ȸ�Ͽ� ȸ��ó�� ����.
*&
*&---------------------------------------------------------------------*
TABLES : ZTCGHD,         " ������?
         ZTMSHD ,
         ZTCGCST,         " �����Ƿ� ��?
         LFA1,            " Vendor Master
         ZTIMIMG00,       " ������?
         ZTIMIMG08,       " ������?
         ZTIMIMG11,       " G/R, I/V, ���ó�� Configuration
         BSEG,
         COBL,
         LFB1,
         J_1BT001WV,      " Assign Branch to Plant
         ZVT001W,
         SPOP.     " POPUP_TO_CONFIRM_... function ��� �˾�ȭ�� ��?
*>> MESSAGE ��¿�.
TABLES : BAL_S_DMSG.
*-----------------------------------------------------------------------
* ERROR ó���� TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON       LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(255) TYPE C.
DATA : END OF IT_ERR_LIST.

*-----------------------------------------------------------------------
* �Ͽ� ������ TABLE
*-----------------------------------------------------------------------
DATA:    BEGIN OF IT_ZTCGCST OCCURS 0.
         INCLUDE STRUCTURE ZTCGCST.
DATA     END OF IT_ZTCGCST.
*-----------------------------------------------------------------------
* ������ CODE INTERNAL TABLE
*-----------------------------------------------------------------------
DATA:    BEGIN OF IT_ZTIMIMG08 OCCURS 0.
         INCLUDE STRUCTURE ZTIMIMG08.
DATA     END OF IT_ZTIMIMG08.

*-----------------------------------------------------------------------
* SELECT RECORD
*-----------------------------------------------------------------------
DATA: BEGIN OF    IT_SELECTED OCCURS 0,
      BUKRS       LIKE ZTCGCST-BUKRS,
      ZFCGNO      LIKE ZTCGCST-ZFCGNO,
      ZFVEN       LIKE ZTCGCST-LIFNR,
      ZFPAY       LIKE ZTCGCST-ZFPAY,
      ZTERM       LIKE ZTCGCST-ZTERM,
      MWSKZ       LIKE ZTCGCST-MWSKZ,
      ZFCKAMT     LIKE ZTCGCST-ZFCKAMT,
      ZFVAT       LIKE ZTCGCST-ZFVAT,
      ZFWERKS     LIKE ZTCGCST-WERKS,
      GRP_MARK(10)    TYPE   C,
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* BDC �� Table
*-----------------------------------------------------------------------
DATA:    BEGIN OF ZBDCDATA OCCURS 0.
         INCLUDE STRUCTURE BDCDATA.
DATA     END OF ZBDCDATA.

*-----------------------------------------------------------------------
* LOCK TABLE
*-----------------------------------------------------------------------
DATA:    BEGIN OF IT_LOCKED OCCURS 0,
         ZFCGNO     LIKE   ZTCGHD-ZFCGNO.
DATA     END OF IT_LOCKED.

*-----------------------------------------------------------------------
* �𼱹�ȣ, �𼱸� TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_MSNO OCCURS 0,
       ZFMSNO          LIKE   ZTMSHD-ZFMSNO,
       ZFMSNM          LIKE   ZTMSHD-ZFMSNM,
END   OF IT_MSNO.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_ERR_CNT         TYPE I,
       W_LOOP_CNT        TYPE I,             " Loop Count
       INCLUDE(8)        TYPE C,             "
       MARKFIELD         TYPE C,
       SV_ZFVEN          LIKE ZTCGCST-LIFNR,
       SV_BUKRS          LIKE ZTCGCST-BUKRS,
       SV_ZFVEN_NM(20)   TYPE C,
       SV_ZFPAY_NM(20)   TYPE C,
       SV_ZFPAY          LIKE ZTCGCST-ZFPAY,
       SV_ZTERM          LIKE ZTCGCST-ZTERM,
       SV_MWSKZ          LIKE ZTCGCST-MWSKZ,
       W_GRP_MARK(10)    TYPE C,
       SUM_ZFCKAMT       LIKE ZTCGCST-ZFCKAMT,
       SUM_ZFVAT         LIKE ZTCGCST-ZFVAT,
       W_POSDT           LIKE SY-DATUM,
       W_DOCDT           LIKE SY-DATUM,
       W_SY_SUBRC        LIKE SY-SUBRC,
       ZFFIYR            LIKE ZTCGCST-GJAHR,
       ZFACDO            LIKE ZTCGCST-BELNR,
       RADIO_NONE(1)     TYPE C,
       RADIO_ALL(1)      TYPE C,
       RADIO_ERROR(1)    TYPE C,
       W_LOCK_CHK(1)     TYPE C,
       TEMP_WRBTR(16),
       TEMP_WMWST(16),
       ANWORT,
       W_WRBTR           LIKE ZTRECST-ZFCKAMT,
       OK-CODE           LIKE SY-UCOMM.

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
       W_MOD             TYPE I.

DATA : W_J_1BT001WV    LIKE J_1BT001WV.
DATA  SV_ZFWERKS       LIKE ZTRECST-ZFWERKS.
