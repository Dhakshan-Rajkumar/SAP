*----------------------------------------------------------------------*
*   INCLUDE ZRIMBLCSTTOP                                               *
*----------------------------------------------------------------------*
*&  ���α׷��� : B/L ��� Posting                          *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.05.23                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : B/L ����� ��ȸ�Ͽ� ȸ��ó����?
*&
*&---------------------------------------------------------------------*
TABLES : ZTCUCLCST,       " ��� ��?
         ZTBL,            " Bill of Lading
         ZTIDS,           " ���Ը�?
         LFA1,            " Vendor Master
         ZTIMIMG08,       " ������?
         J_1BT001WV,      " Assign Branch to Plant
         ZVT001W,
         SPOP.     " POPUP_TO_CONFIRM_... function ��� �˾�ȭ�� ��?


*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF    IT_SELECTED OCCURS 0,
      ZFVEN       LIKE ZTCUCLCST-ZFVEN,
      ZFPAY       LIKE ZTCUCLCST-ZFPAY,
      ZTERM       LIKE ZTCUCLCST-ZTERM,
      MWSKZ       LIKE ZTCUCLCST-MWSKZ,
      ZFWERKS     LIKE ZTCUCLCST-ZFWERKS,
      ZFCAMT      LIKE ZTCUCLCST-ZFCAMT,
END OF IT_SELECTED.
*-----------------------------------------------------------------------
* BDC �� Table
*-----------------------------------------------------------------------
DATA:    BEGIN OF ZBDCDATA OCCURS 0.
         INCLUDE STRUCTURE BDCDATA.
DATA     END OF ZBDCDATA.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       W_LOOP_CNT        TYPE I,             " Loop Count
       SV_ZFVEN          LIKE ZTCUCLCST-ZFVEN,
       SV_ZFPAY          LIKE ZTCUCLCST-ZFPAY,
       SV_ZTERM          LIKE ZTCUCLCST-ZTERM,
       SV_MWSKZ          LIKE ZTCUCLCST-MWSKZ,
       SV_ZFWERKS        LIKE ZTCUCLCST-ZFWERKS,
       SUM_ZFCAMT        LIKE ZTCUCLCST-ZFCAMT,
       W_POSDT           LIKE SY-DATUM,
       W_DOCDT           LIKE SY-DATUM,
       ZFFIYR            LIKE ZTCUCLCST-ZFFIYR,
       ZFACDO            LIKE ZTCUCLCST-ZFACDO,
       RADIO_NONE(1)     TYPE C,
       RADIO_ALL(1)      TYPE C,
       RADIO_ERROR(1)    TYPE C,
       DISPMODE(1)       TYPE C,
       TEMP_WRBTR(16),
       TEMP_WMWST(16),
       W_WRBTR           LIKE ZTBLCST-ZFCKAMT,
       OK-CODE           LIKE SY-UCOMM,
       UMODE             VALUE 'S'.     " Async, Sync

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

DATA : W_J_1BT001WV    LIKE J_1BT001WV.
