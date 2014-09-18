*&---------------------------------------------------------------------*
*& Include ZRIMBLVSLCSTTOP                                             *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �ػ� ���� ���伭  DATA DEFINE                         *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.11                                            *
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
         TEMP              TYPE  F.

  DATA : BEGIN OF ST_HEAD,
         ZFBLNO    LIKE    ZTBL-ZFBLNO,   " B/L No.
         ZFGMNO    LIKE    ZTBL-ZFGMNO,   " ȭ��������ȣ.
         ZFMSN     LIKE    ZTBL-ZFMSN,
         ZFHSN     LIKE    ZTBL-ZFHSN,
         ZFREBELN  LIKE    ZTBL-ZFREBELN, " P/O ��ȣ.
         ZFSHNO    LIKE    ZTBL-ZFSHNO,   " ��������.
         ZFMBLNO   LIKE    ZTBL-ZFMBLNO,
         ZFHBLNO   LIKE    ZTBL-ZFHBLNO,
         ZFCARNM   LIKE    ZTBL-ZFCARNM,  " �����.
         ZFRETA    LIKE    ZTBL-ZFRETA,   " ������.
         ZFINDT    LIKE    ZTBLINR_TMP-ZFINDT,   " ������.
         ZFTBLNO   LIKE    ZTBLINR_TMP-ZFTBLNO,  " ���԰�����ȣ.
         ZFETD     LIKE    ZTBL-ZFETD,    " ������.
         INCO1     LIKE    ZTBL-INCO1,    " �ε����.
         ZFSPRT    LIKE    ZTBL-ZFSPRT,   " ������.
         ZFAPRT    LIKE    ZTBL-ZFAPRT,   " ������.
         ZFCDTY    LIKE    ZTBL-ZFCDTY,   " �ڵ� ����.
         ZFCD      LIKE    ZTBL-ZFCD,     " ������ �������ڵ�.
         W_AREA    LIKE    ZTIMIMG08-ZFCDNM, " ������ ������.
         ZFEXRTT   LIKE    ZTBL-ZFEXRTT,  " ȯ��.
         ZFEXDTT   LIKE    ZTBL-ZFEXDTT,  " ȯ��������.
         ZFWERKS   LIKE    ZTBL-ZFWERKS,  " ���� �����.
         W_WERKS(30) TYPE   C,             " PLANT��.
         ZFNEWT    LIKE    ZTBL-ZFNEWT,   " �����߷�.
         ZFNEWTM   LIKE    ZTBL-ZFNEWTM,
         ZFTOWT    LIKE    ZTBL-ZFTOWT,   " ���Ӱ���߷�.
         ZFTOWTM   LIKE    ZTBL-ZFTOWTM,
         ZFTOVL    LIKE    ZTBL-ZFTOVL,   " ��������.
         ZFTOVLM   LIKE    ZTBL-ZFTOVLM,
         ZF20FT    LIKE    ZTBL-ZF20FT,
         ZF40FT    LIKE    ZTBL-ZF40FT,
         ZFGITA    LIKE    ZTBL-ZFGITA,
         ZFGTPK    LIKE    ZTBL-ZFGTPK,
         ZFMRATE   LIKE    ZTBL-ZFMRATE,  " ����.
         ZFNETPR1  LIKE    ZTBL-ZFNETPR1,
         ZFNETPR2  LIKE    ZTBL-ZFNETPR2,
         ZFUPWT    LIKE    ZTBL-ZFUPWT,    " ������ �߷�.
         ZFDFUP    LIKE    ZTBL-ZFDFUP,    " ������ ��뿩��.
         ZFCHARGE  LIKE    ZTBL-ZFCHARGE,  " ���ǿ��ӻ�뿩��.
         ZFFRE     LIKE    ZTBL-ZFFRE,     " ���� ����.
         ZFTRCUR   LIKE    ZTBL-ZFTRCUR.   " ������ȭ.
  DATA : END OF ST_HEAD .

  DATA : BEGIN OF IT_TAB_COST OCCURS 0,
         ZFBLNO     LIKE  ZTBLCST-ZFBLNO,    " ���׷�.
         ZFCSCD     LIKE  ZTBLCST-ZFCSCD,
         ZFCDNM     LIKE  ZTIMIMG08-ZFCDNM,
         ZFCAMT     LIKE  ZTBLCST-ZFCAMT,
         WAERS      LIKE  ZTBLCST-WAERS,
         ZFCKAMT    LIKE  ZTBLCST-ZFCKAMT.
  DATA : END OF IT_TAB_COST .

  DATA : W_OTH_WT  LIKE ZTBL-ZFTOWT,
         W_OTH_WTM LIKE ZTBL-ZFTOWTM,
         W_DF_CHA  LIKE ZTBKPF-WRBTR,
         W_UP_CHA  LIKE ZTBKPF-WRBTR.

 DATA : W_REMARK(40).

 DATA : W_SUB_TOT LIKE ZTBLCST-ZFCAMT,
        W_SUB_KRW LIKE ZTBLCST-ZFCKAMT,
        W_GRD_TOT LIKE ZTBLCST-ZFCAMT,
        W_GRD_KRW LIKE ZTBLCST-ZFCKAMT.
