*----------------------------------------------------------------------*
*   INCLUDE ZRIMISLSTTOP                                               *
*----------------------------------------------------------------------*
*&  ���α׷��� : ����纰 ����� ��ȸ                                  *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.15                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :����纰 �κ� ��Ȳ��ȸ�� ���� Include.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* ���̺�.
*-----------------------------------------------------------------------
TABLES : ZTINS,                       " ����κ�.
         ZTINSSG2,                    " SEG2
         ZTINSAGR,                    " AGR
         ZTINSRSP,                    " ����κ� Response
         ZTREQST,                     " �����Ƿ� ����(Status)
         ZTRECST,                     " �����Ƿ� ���.
         ZTREQHD.                     " �����Ƿ� ���.

*-----------------------------------------------------------------------
* SELECT RECORD ��.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       ZFREQNO    LIKE ZTINS-ZFREQNO,          " �����Ƿ� ������ȣ.
       ZFINSEQ    LIKE ZTINS-ZFINSEQ,
       INSAMDNO   LIKE ZTINS-ZFAMDNO,
       ZFAMDNO    LIKE ZTINS-ZFAMDNO,          " Amend Seq.
       ZFINNO     LIKE ZTINS-ZFINNO,
       ZFKRWAMT   LIKE ZTINS-ZFKRWAMT,
       WERKS      LIKE ZTREQHD-ZFWERKS,
       BUPLA      LIKE ZTBKPF-BUPLA,
       BUKRS      LIKE ZTINS-BUKRS,
       BELNR      LIKE ZTINS-BELNR,
       ZFOPCD     LIKE ZTINS-ZFOPCD,
       GJAHR      LIKE ZTINS-GJAHR.
DATA: END OF IT_SELECTED.


DATA : BEGIN OF IT_LIFNR OCCURS 0,
       ZFOPCD     LIKE ZTINS-ZFOPCD.
DATA : END   OF IT_LIFNR.


DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       L_COUNT           TYPE I,                 " �������� LINE COUNT
       W_LCOUNT          TYPE I,                 " ����� COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
       W_TABIX           LIKE SY-TABIX,          " TABLE INDEX
       W_EKNAM           LIKE T024-EKNAM,
       W_WERKSNM         LIKE T001W-NAME1,
       W_TRANS           LIKE ZTREQHD-ZFTRANS,
       W_MATNM(35)       TYPE C,
       W_MIN_LSG2        LIKE ZTINSSG2-ZFLSG2,   " �ּ� �ݺ���.
       W_MIN_LAGR        LIKE ZTINSAGR-ZFLAGR,   " �ִ� �ݺ���.
       W_MAX_ZFAMDNO     LIKE ZTINS-ZFAMDNO,     " AEND ȸ��.
       W_MAX_ZFAMDNO_OLD LIKE ZTINS-ZFAMDNO,     " AEND ȸ��.
       OLD_ZFOPCD        LIKE ZTINS-ZFOPCD,     " ����ȸ��CODE.
       OLD_ZFKRW         LIKE ZTINS-ZFKRW,       " �Ұ�ݾ���ȭ.
       SUB_TOTALK        LIKE ZTINS-ZFKRWAMT,    " �Ұ�ݾ׿�ȭ.
       P_BUKRS           LIKE ZTINS-BUKRS.
