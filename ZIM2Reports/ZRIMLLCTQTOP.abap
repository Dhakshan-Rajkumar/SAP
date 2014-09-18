*----------------------------------------------------------------------*
*   INCLUDE ZRIMLLCQTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : Local L/C ���������뺸?
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.06.21                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES :  ZTVTIV,    " ���ݰ�꼭�� Invoice Header
          ZTVTIVIT,    "  Item Database View
          ZTREQHD,   " ������?
          ZTPMTHD,   " Payment Notice Head
          ZTPMTIV,    " Payment Notice Invoice
          ZTLLCHD,   " Local L/C Head
          ZTLLCAMHD. " Local L/C Amend

DATA: W_ZFREQNO        LIKE ZTREQHD-ZFREQNO, " �����Ƿ� ������?
      W_ZFOPNNO        LIKE ZTREQHD-ZFOPNNO, " L/C No
      W_ZFBENI         LIKE ZTREQHD-ZFBENI,  " Vendor
      W_ZFBENI_NM(20)  TYPE C,
      W_ZFOPBN         LIKE ZTREQHD-ZFOPBN,  " ������?
      W_ZFOPBN_NM(20)  TYPE C,
      W_ZFOPNDT        LIKE ZTREQST-ZFOPNDT, " ����?
      W_ZFEXDT         LIKE ZTLLCHD-ZFEXDT,  " ��ȿ��?
      W_ZFEXRT         LIKE ZTLLCHD-ZFEXRT,  " ȯ?
      W_ZFOPAMT        LIKE ZTLLCHD-ZFOPAMT, " ������?
      W_ZFOPAMTC       LIKE ZTLLCHD-ZFOPAMTC, "�����ݾ���?
      W_ZFOPKAM        LIKE ZTLLCHD-ZFOPKAM, " �����ݾ�(��ȭ)
      W_ZFOPAMT_1      LIKE ZTLLCHD-ZFOPAMT, " �߻���?
      W_ZFOPKAM_1      LIKE ZTLLCHD-ZFOPKAM, " �߻��ݾ�(��ȭ)
      W_ZFOPAMT_2      LIKE ZTLLCHD-ZFOPAMT, " ������?
      W_ZFOPKAM_2      LIKE ZTLLCHD-ZFOPKAM, " �����ݾ�(��ȭ)
      W_ZFOPAMT_3      LIKE ZTLLCHD-ZFOPAMT, " ��?
      W_ZFOPKAM_3      LIKE ZTLLCHD-ZFOPKAM, " �ܾ�(��ȭ)
      W_ZFOPAMT_4      LIKE ZTLLCHD-ZFOPAMT, " ���԰���?
      W_ZFOPKAM_4      LIKE ZTLLCHD-ZFOPKAM, " ���԰��ܾ�(��ȭ)
      W_ZFAMDNO        LIKE ZTREQST-ZFAMDNO,
      W_ZFPNNO         LIKE ZTPMTHD-ZFPNNO.

DATA : OPTION(1)       TYPE C,             " ���� popup Screen���� ��?
       ANTWORT(1)      TYPE C,             " ���� popup Screen���� ��?
       CANCEL_OPTION   TYPE C,             " ���� popup Screen���� ��?
       TEXTLEN         TYPE I,             " ���� popup Screen���� ��?
       W_PROC_CNT      TYPE I.             " ó����?

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
