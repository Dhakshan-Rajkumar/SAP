*----------------------------------------------------------------------*
*   INCLUDE ZRIMBWLSTTOP                                              *
*----------------------------------------------------------------------*
*&  ���α׷��� : ����â�� ���                                    *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.08.25                                            *
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
TABLES: LFA1,
        ZTBWHD,ZTBWIT,ZTBL,
        T001W,ZTBLIT,
        ZTIMIMG00.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_TABIX           LIKE SY-TABIX,
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIRST_CHECK     TYPE I,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ��.
       MARKFIELD,
       P_BUKRS           LIKE ZTBL-BUKRS.

*-----------------------------------------------------------------------
* INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_BWHD OCCURS 0,
       ZFIVNO   LIKE ZTBWHD-ZFIVNO,
       ZFGISEQ  LIKE ZTBWHD-ZFGISEQ,
       WAERS    LIKE ZTBWHD-WAERS,
       ZFBLNO   LIKE ZTBWHD-ZFBLNO,
       ZFHBLNO  LIKE ZTBL-ZFHBLNO,
       ZFCLSEQ  LIKE ZTBWHD-ZFCLSEQ,
       ZFREBELN LIKE ZTBWHD-ZFREBELN,
       W_EBELN(12),
       WERKS    LIKE ZTBWHD-WERKS,
       ZFSHNO   LIKE ZTBWHD-ZFSHNO,
       ZFIDSDT  LIKE ZTBWHD-ZFIDSDT,
       ZFTRCO   LIKE ZTBWHD-ZFTRCO,
       ZFSENDER LIKE ZTBWHD-ZFSENDER,
       ZFGIDT   LIKE ZTBWHD-ZFGIDT,
       ZFCARNO  LIKE ZTBWHD-ZFCARNO,
       ZFDRVNM  LIKE ZTBWHD-ZFDRVNM,
       ZFRMK1   LIKE ZTBWHD-ZFRMK1,
       ZFRMK2   LIKE ZTBWHD-ZFRMK2,
       ZFRMK3   LIKE ZTBWHD-ZFRMK3,
       ZFTOWT   LIKE ZTBWHD-ZFTOWT,
       ZFTOWTM  LIKE ZTBWHD-ZFTOWTM,
       ZFTOVL   LIKE ZTBWHD-ZFTOVL,
       ZFTOVLM  LIKE ZTBWHD-ZFTOVLM,
       NAME1    LIKE LFA1-NAME1.
DATA : END OF IT_BWHD.

DATA : BEGIN OF IT_BWIT OCCURS 0,
       ZFIVNO	  LIKE ZTBWIT-ZFIVNO,  " �����û/�԰��û ������ȣ
       ZFIVDNO  LIKE ZTBWIT-ZFIVDNO, " Invoice Item �Ϸù�ȣ
       ZFGISEQ  LIKE ZTBWIT-ZFGISEQ, " ����â����� ����
       EBELN    LIKE ZTBWIT-EBELN,	   " ���Ź�����ȣ
       W_EBELN(15),
       ZFSHNO   LIKE ZTBWIT-ZFSHNO,  " ��������
       ZFREQNO  LIKE ZTBWIT-ZFREQNO, " �����Ƿ� ������ȣ
       ZFITMNO  LIKE ZTBWIT-ZFITMNO, " ���Թ��� ǰ���ȣ
       ZFBLNO	  LIKE ZTBWIT-ZFBLNO,  " B/L ������ȣ
       ZFBLIT   LIKE ZTBWIT-ZFBLIT,  " B/L ǰ���ȣ
       ZFCGNO	  LIKE ZTBWIT-ZFCGNO,  " �Ͽ�������ȣ
       ZFCGIT	  LIKE ZTBWIT-ZFCGIT,  " �Ͽ��������
       MATNR	  LIKE ZTBWIT-MATNR,   " �����ȣ
       GIMENGE  LIKE ZTBWIT-GIMENGE, " ����â�� ������
       NETPR    LIKE ZTBWIT-NETPR,
       PEINH    LIKE ZTBWIT-PEINH,   " ���ݴ���
       BPRME    LIKE ZTBWIT-BPRME,   " ��������.
       MEINS	  LIKE ZTBWIT-MEINS,   " �⺻����
       TXZ01	  LIKE ZTBWIT-TXZ01.   " ����
DATA : END OF IT_BWIT.

DATA: BEGIN OF IT_SELECTED OCCURS 0,
        ZFIVNO   LIKE ZTBWHD-ZFIVNO,
        ZFGISEQ  LIKE ZTBWHD-ZFGISEQ,
        ZFBLNO   LIKE ZTBWHD-ZFBLNO,
       ZFCLSEQ  LIKE ZTBWHD-ZFCLSEQ,
END OF IT_SELECTED.
