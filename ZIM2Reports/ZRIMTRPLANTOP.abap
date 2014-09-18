*&---------------------------------------------------------------------*
*& Include ZRIMTRCONFTOP                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���۰�ȹ�� (����â�����)  DATA DEFINE                *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.07                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
*-----------------------------------------------------------------------
* Workflow ���� ����
*-----------------------------------------------------------------------
  DATA: FL_FROMWF.                    "Whether from WF

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
  TABLES: ZTTRHD,ZTTRIT,LFA1, T001W.

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
         W_TRGB(4)         TYPE C,                " ���۱��и�.
         TEMP              TYPE F,
         GL_PGM            TYPE C, "NCW�߰�
         GL_VAR            TYPE C.

  DATA: BEGIN OF IT_TAB OCCURS 0,
        ZFTRNO      LIKE  ZTTRIT-ZFTRNO,     " ����â������ȣ.
        ZFTRIT      LIKE  ZTTRIT-ZFTRIT,     " ITEM NO.
        WERKS       LIKE  ZTTRIT-WERKS,      " PLANT.
        EBELN       LIKE  ZTTRIT-EBELN,      " P/O ��ȣ.
        ZFSHNO      LIKE  ZTTRIT-ZFSHNO,     " ��������.
        W_WERKS     LIKE  T001W-NAME1,       " ����ó��.
        MATNR       LIKE  ZTTRIT-MATNR,      " �����ȣ.
        TXZ01       LIKE  ZTTRIT-TXZ01,      " ǰ��.
        GIMENGE     LIKE  ZTTRIT-GIMENGE,    " ������.
        MEINS       LIKE  ZTTRIT-MEINS,      " ����.
        NETPR       LIKE  ZTTRIT-NETPR,      " �ܰ�.
        AMOUNT      LIKE  ZTTRCHD-ZFTOTAMT,          " �ݾ�.
        ZFIVAMC     LIKE  ZTTRIT-ZFIVAMC.   " ��ȭŰ.
*     LGORT       LIKE  ZTTRIT-LGORT,      " Storage location
*     W_LGORT     LIKE  LFA1-NAME1,        " ��۾�ü��.
*     ZFIVNO      LIKE  ZTTRIT-ZFIVNO.     " ���������ȣ.
  DATA: END OF IT_TAB.

  DATA : W_SUB_AMT LIKE ZTTRCHD-ZFTOTAMT,    " SUB TOTOAL
         W_SUB_CUR LIKE ZTTRIT-ZFIVAMC.

  DATA : BEGIN OF IT_TOT OCCURS 0,   " GRAND TOTOAL.
         ZFIVAMC  LIKE ZTTRIT-ZFIVAMC,
         AMOUNT   LIKE ZTTRCHD-ZFTOTAMT.
  DATA : END OF IT_TOT.
