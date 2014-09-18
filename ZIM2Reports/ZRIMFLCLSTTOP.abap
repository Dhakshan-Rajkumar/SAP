*----------------------------------------------------------------------*
*   INCLUDE ZRIMFLCLSTTOP                                              *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* TABLES �� ���� DEFINE.                                               *
*----------------------------------------------------------------------*

*>>> TABLE DEFINE.
TABLES : ZTREQHD,                  "�����Ƿ� �ش�.
         ZTREQIT,                  "�����Ƿ� ITEM.
         ZTREQST,                  "�����Ƿ� ����.
         T001W,                    "STANDARD-Plant
         EKPO.                     "STANDARD.

*>>> ���� DEFINE.
DATA   : W_ERR_CHK TYPE C VALUE 'N',   "ERROR CHECK.
         W_LINE  TYPE I,               "IT_TAB LINE ��.
         W_LINE1 TYPE I,              "�Ұ�� LINE ��.
         W_SUM   LIKE ZTREQHD-ZFLASTAM, "��ȭ �Ұ��.
         W_TOTAL LIKE ZTREQHD-ZFLASTAM, "��ȭ �����.
         W_WERKS LIKE EKPO-WERKS,     "�����.
         W_PRI LIKE ZTREQIT-NETPR,    "�ܰ�.
         W_FOR LIKE ZTREQHD-ZFLASTAM, "��ȭ.
         W_WON LIKE ZTREQHD-ZFLASTAM, "��ȭ.
         W_MOD LIKE SY-TABIX,        "Ȧ¦.
         W_TABIX LIKE SY-TABIX.

*>>> IT_TAB DEFINE.
DATA : BEGIN OF IT_TAB OCCURS 0,
         WERKS    LIKE EKPO-WERKS,      "EKPO 	�÷�Ʈ
         EBELN    LIKE ZTREQHD-EBELN,   "EKKO 	P/O �ֹ���ȣ
*>>KEY
         ZFREQNO  LIKE ZTREQHD-ZFREQNO,   "�����Ƿ� ������ȣ
*>>�ʿ�FIELD �����.
         ZFOPNDT  LIKE ZTREQST-ZFOPNDT,   "������-��ȭ,��ȭ.
         KURSF    LIKE ZTREQHD-KURSF,	 "ȯ��
         FFACT    LIKE ZTREQHD-FFACT,	 "���� ��ȭ����ȯ��
         BPUMZ    LIKE EKPO-BPUMZ,
                      "�������ݴ����� ���������� ȯ���ϴ� ����
         BPUMN    LIKE EKPO-BPUMN,        " �и�
         BPRME    LIKE ZTREQIT-BPRME,     "Order price unit
         MENGE    LIKE ZTREQIT-MENGE,     "�����Ƿ� ����
         MEINS    LIKE ZTREQIT-MEINS,	 "T006	�⺻����
         NETPR    LIKE ZTREQIT-NETPR,	 "�ܰ�
         PEINH    LIKE ZTREQIT-PEINH,	 "���ݴ���
         TXZ01    LIKE ZTREQIT-TXZ01,	 "����(ǰ��)
         LIFNR    LIKE ZTREQHD-LIFNR,     "����ó������
*>>LIST
         ZFDOCST  LIKE ZTREQST-ZFDOCST,   "���� ���� 'O'
         IMTRD    LIKE ZTREQHD-IMTRD,	 "�����ڱ��� 'F'.
         LLIEF    LIKE ZTREQHD-LLIEF,	 "���޾�ü(OFFER CODE)
         INCO1    LIKE ZTREQHD-INCO1,	 "TINC�ε�����(��������)
         WAERS    LIKE ZTREQHD-WAERS,	 "TCURC ��ȭŰ (ȭ��)
         MATNR    LIKE ZTREQHD-MATNR,	 "�����ȣ
         MAKTX    LIKE ZTREQHD-MAKTX,	 "���系��
         EBELP    LIKE ZTREQIT-EBELP,	 "���Ź��� ǰ���ȣ
*>>MAKE FIELD-�ܰ�,��ȭ,��ȭ ����.
         EX_PRI   LIKE ZTREQIT-NETPR,     "�ܰ���.
         EX_FOR   LIKE ZTREQHD-ZFLASTAM,  "��ȭ��.
         EX_WON   LIKE ZTREQHD-ZFLASTAM.  "��ȭ��.

DATA : END OF IT_TAB.


*>>> �Ұ�� IT_TAB DEFINE.
DATA : BEGIN OF IT_SUMMARY OCCURS 10,
         WAERS    LIKE    ZTREQHD-WAERS,
         EX_FOR   LIKE    ZTREQHD-ZFLASTAM,
         EX_WON   LIKE    ZTREQHD-ZFLASTAM.
DATA : END OF IT_SUMMARY.

*>>> ����� IT_TAB DEFINE.
DATA : BEGIN OF IT_TOTAL OCCURS 10,
         WAERS    LIKE    ZTREQHD-WAERS,
         EX_FOR   LIKE    ZTREQHD-ZFLASTAM,
         EX_WON   LIKE    ZTREQHD-ZFLASTAM.
DATA : END OF IT_TOTAL.

*>>> IT_TEMP DEFINE.
DATA : BEGIN OF IT_TEMP OCCURS 0,
*>>KEY
         ZFREQNO   LIKE ZTREQHD-ZFREQNO,  "�����Ƿ� ������ȣ
*LIST
         ZFOPNDT   LIKE ZTREQST-ZFOPNDT,  "������-��ȭ,��ȭ.
         KURSF     LIKE ZTREQHD-KURSF,	 "ȯ��
         FFACT     LIKE ZTREQHD-FFACT,	 "���� ��ȭ����ȯ��
         ZFDOCST   LIKE ZTREQST-ZFDOCST,  "���� ���� 'O'
         IMTRD     LIKE ZTREQHD-IMTRD,	 "�����ڱ��� 'F'.
         EBELN     LIKE ZTREQHD-EBELN,	 "����(P/O �ֹ���ȣ)
         LLIEF     LIKE ZTREQHD-LLIEF,	 "���޾�ü(OFFER CODE)
         INCO1     LIKE ZTREQHD-INCO1,	 "�ε����� (��������)
         WAERS     LIKE ZTREQHD-WAERS,	 "TCURC ��ȭŰ (ȭ��)
         MATNR     LIKE ZTREQHD-MATNR,	 "�����ȣ
         LIFNR    LIKE ZTREQHD-LIFNR,     "����ó������
         MAKTX     LIKE ZTREQHD-MAKTX.    "���系��
DATA: END OF IT_TEMP.

*>>> IT_ITEM DEFINE.
DATA: BEGIN OF IT_ITEM OCCURS 0,
*>>KEY
        ZFREQNO   LIKE ZTREQHD-ZFREQNO,   "�����Ƿ� ������ȣ
*>>LIST
        MENGE	    LIKE ZTREQIT-MENGE,      "�����Ƿ� ����
        MEINS     LIKE ZTREQIT-MEINS,	"T006	�⺻����
        NETPR     LIKE ZTREQIT-NETPR,	"�ܰ�
        PEINH     LIKE ZTREQIT-PEINH,	"���ݴ���
        TXZ01	    LIKE ZTREQIT-TXZ01,	"����(ǰ��)
        EBELP	    LIKE ZTREQIT-EBELP.	"���Ź���EBELN�� EKPO-WERK
DATA: END OF IT_ITEM.
