*&---------------------------------------------------------------------*
*& Include ZRIMTRORDETOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����������ü�(����â�����)  DATA DEFINE             *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.06                                            *
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
  TABLES: ZTTRHD,ZTTRIT, ZTBKPF, LFA1, T001W.

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
         W_TRGB(4)         TYPE  C,                " ���۱��и�.
         TEMP              TYPE  F.

*>> �����������.
 DATA : BEGIN OF ST_TAB_HD,
        ZFTRNO       LIKE   ZTTRHD-ZFTRNO,    " �������ù�ȣ.
        TXZ01        LIKE   ZTTRIT-TXZ01,     " ��ǥǰ��.
        W_ITM_CN     TYPE   I,                " ǰ���.
        ZFTOWT       LIKE   ZTTRHD-ZFTOWT,    " �߷�.
        ZFTOWTM      LIKE   ZTTRHD-ZFTOWTM,   " ����.
        ZFGIDT       LIKE   ZTTRHD-ZFGIDT,    " �����.
        ZFDRDT       LIKE   ZTTRHD-ZFDRDT,    " ���۱�����.
        ZFDRMT       LIKE   ZTTRHD-ZFDRMT,    " ���۹��.
        W_DRMT(4)    TYPE   C,                " ���۹����.
        ZFTRCO       LIKE   ZTTRHD-ZFTRCO,    " ��۾�ü.
        W_TRCO       LIKE   LFA1-NAME1,       " ��۾�ü��.
        ZFTRTERM     LIKE   ZTTRHD-ZFTRTERM,  " �۾�����.
        BUKRS        LIKE   ZTTRHD-BUKRS,     " ȸ���ڵ�.
        BELNR        LIKE   ZTTRHD-BELNR,     " ��빮����ȣ.
        GJAHR        LIKE   ZTTRHD-GJAHR,     " ȸ�迬��.
        AMOUNT       LIKE   ZTBKPF-WRBTR,     " ���ް���
        WMWST        LIKE   ZTBKPF-WMWST,     " ��ǥ��ȭ����(�ΰ���)
        WRBTR        LIKE   ZTBKPF-WRBTR,     " ��ǥ��ȭ�ݾ�(�Ѿ�)
        WAERS        LIKE   ZTBKPF-WAERS,     " ��ǥ��ȭ.
        TRS_AMT      LIKE   ZTBSEG-WRBTR,     " ��ݺ�.
        MAN_AMT      LIKE   ZTBSEG-WRBTR,     " �ΰǺ�.
        ETC_AMT      LIKE   ZTBSEG-WRBTR,     " ��Ÿ���.
        ZFRMK1       LIKE   ZTTRHD-ZFRMK1,    " ���1.
        ZFRMK2       LIKE   ZTTRHD-ZFRMK2,    " ���2.
        ZFRMK3       LIKE   ZTTRHD-ZFRMK3,    " ���3.
        ZFRMK4       LIKE   ZTTRHD-ZFRMK4,    " ���4.
        ZFRMK5       LIKE   ZTTRHD-ZFRMK5.    " ���5.
  DATA : END OF ST_TAB_HD.

  DATA : BEGIN OF IT_TAB_WERKS OCCURS 0,
         WERKS       LIKE  ZTTRIT-WERKS,      " PLANT.
         W_WERKS     LIKE  T001W-NAME1.       " ����ó��.
  DATA : END OF IT_TAB_WERKS.

  DATA: BEGIN OF IT_TAB_DTL OCCURS 0,
        ZFSEQ       LIKE  ZTTRCSTIT-ZFSEQ,
        ZFHBLNO     LIKE  ZTTRCST-ZFHBLNO,    " House B/L NO.
        ZFTRATE     LIKE  ZTTRCSTIT-ZFTRATE,  " ����.
        ZFDTON      LIKE  ZTTRCSTIT-ZFDTON,   " �������.
        NETPR       LIKE  ZTTRCSTIT-NETPR,    " �ܰ�.
        WAERS       LIKE  ZTTRCSTIT-WAERS,    " ��ȭ.
        ZFTADD      LIKE  ZTTRCSTIT-ZFTADD,   " ��ݺ� ����.
        ZFTRAMT     LIKE  ZTTRCSTIT-ZFTRAMT,  " ��ݺ�.
        ZFMADD      LIKE  ZTTRCSTIT-ZFMADD,   " �ΰǺ� ����.
        ZFMAMT      LIKE  ZTTRCSTIT-ZFMAMT.   " �ΰǺ�.
  DATA: END OF IT_TAB_DTL.

  DATA : BEGIN OF IT_TAB_BSEG OCCURS 0,
         ZFCSTGRP   LIKE  ZTBSEG-ZFCSTGRP,    " ���׷�.
         ZFCD       LIKE  ZTBSEG-ZFCD,
         ZFCDNM     LIKE  ZTIMIMG08-ZFCDNM,
         WRBTR      LIKE  ZTBSEG-WRBTR.
  DATA : END OF IT_TAB_BSEG.

  DATA : BEGIN OF IT_TAB_CST OCCURS 0,
         ZFSEQ      LIKE  ZTTRCSTIT-ZFSEQ,
         ZFHBLNO    LIKE  ZTTRCST-ZFHBLNO,
         ZFGARO     LIKE  ZTTRCST-ZFGARO,
         ZFSERO     LIKE  ZTTRCST-ZFSERO,
         ZFNOPI     LIKE  ZTTRCST-ZFNOPI,
         ZFRWET     LIKE  ZTTRCST-ZFRWET,
         ZFYTON     LIKE  ZTTRCST-ZFYTON,
         ZFWTON     LIKE  ZTTRCST-ZFWTON,
         ZFCTON     LIKE  ZTTRCST-ZFCTON.
  DATA : END OF IT_TAB_CST.

  DATA : W_TRS_TOT LIKE ZTBSEG-WRBTR,
         W_MAN_TOT LIKE ZTBSEG-WRBTR,
         W_ROW_TOT LIKE ZTBSEG-WRBTR,
         W_ETC_TOT LIKE ZTBSEG-WRBTR,
         W_GRD_TOT LIKE ZTBSEG-WRBTR,
         W_WAERS   LIKE ZTBKPF-WAERS.
