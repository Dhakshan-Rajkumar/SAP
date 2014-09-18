*&---------------------------------------------------------------------*
*& Include ZRIMBLDOMCSTTOP                                            *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �Ͽ���ۺ� ���伭 DATA DEFINE                         *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.12                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
  TABLES: ZTBL, ZTIMIMG08.

  DATA : MAX-LINE TYPE I VALUE 152.     " REPORT ����.

  DATA : W_ERR_CHK(1)      TYPE C,
         W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
         W_PAGE            TYPE I,                 " Page Counter
         W_LINE            TYPE I,                 " �������� LINE COUNT
         LINE(3)           TYPE N,                 " �������� LINE COUNT
         W_COUNT           TYPE I,                 " ��ü COUNT
         W_TABIX           LIKE SY-TABIX,
         W_ITCOUNT(3),                             " ǰ�� COUNT.
         W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
         W_LIST_INDEX      LIKE SY-TABIX,
         W_LFA1            LIKE LFA1,
         TEMP              TYPE  F,
         W_SUBRC           LIKE SY-SUBRC.

  DATA : BEGIN OF ST_HEAD,
         ZFBLNO    LIKE    ZTBL-ZFBLNO,    " B/L No.
         ZFREBELN  LIKE    ZTBL-ZFREBELN,  " P/O ��ȣ.
         ZFSHNO    LIKE    ZTBL-ZFSHNO,    " ��������.
         ZFMBLNO   LIKE    ZTBL-ZFMBLNO,
         ZFHBLNO   LIKE    ZTBL-ZFHBLNO,
         ZFCARNM   LIKE    ZTBL-ZFCARNM,   " �����.
         ZFRETA    LIKE    ZTBL-ZFRETA,    " ������.
         ZFINDT    LIKE    ZTBLINR_TMP-ZFINDT,   " ������.
         ZFTBLNO   LIKE    ZTBLINR_TMP-ZFTBLNO,  " ���԰�����ȣ.
         ZFHSCL    LIKE    ZTBLINR_TMP-ZFHSCL,   " ȭ������.
         W_HSCL(30) TYPE C,
         ZFPKCN    LIKE    ZTBL-ZFPKCN,    " Packing����.
         ZFPKCNM   LIKE    ZTBL-ZFPKCNM,
         ZFNEWT    LIKE    ZTBL-ZFNEWT,    " �����߷�.
         ZFNEWTM   LIKE    ZTBL-ZFNEWTM,
*         ZFTOWT    LIKE    ZTBL-ZFTOWT,   " ���Ӱ���߷�.
*         ZFTOWTM   LIKE    ZTBL-ZFTOWTM,
         ZFTOVL    LIKE    ZTBL-ZFTOVL,    " ��������.
         ZFTOVLM   LIKE    ZTBL-ZFTOVLM,
         ZFFORD    LIKE    ZTBL-ZFFORD,    "Forwarder
         W_FORD(28) TYPE C,
         ZFHAYEK   LIKE    ZTBL-ZFHAYEK,   "�Ͽ���ü.
         W_HAYEK(28) TYPE C.
  DATA : END OF ST_HEAD .

  DATA : BEGIN OF IT_TAB_COST OCCURS 0,
         ZFBLNO     LIKE  ZTBLCST-ZFBLNO,  " ���׷�.
         ZFCSCD     LIKE  ZTBLCST-ZFCSCD,
         ZFCDNM     LIKE  ZTIMIMG08-ZFCDNM,
*         ZFCAMT     LIKE  ZTBLCST-ZFCAMT,
         WAERS      LIKE  ZTBLCST-WAERS,
         ZFCKAMT    LIKE  ZTBLCST-ZFCKAMT,
         ZFVAT      LIKE  ZTBLCST-ZFVAT.
  DATA : END OF IT_TAB_COST .

 DATA : W_REMARK(56).

 DATA : W_SUB_VAT LIKE ZTBLCST-ZFCAMT,
        W_SUB_KRW LIKE ZTBLCST-ZFCKAMT,
        W_GRD_TOT LIKE ZTBKPF-WRBTR.
