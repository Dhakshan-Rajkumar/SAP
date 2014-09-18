*&---------------------------------------------------------------------*
*& Report ZRIMMATHIS                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �������纰 ��Ȳ���� PROGRAM                           *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.04.06                                            *
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*& 2001.07.03  ������ ( ���� �԰� �������� ���� ���� �԰��ڷ� DISPLAY )
*&---------------------------------------------------------------------*
REPORT ZRIMMATHIS NO STANDARD PAGE HEADING MESSAGE-ID ZIM
                     LINE-SIZE 143.

TABLES: EKKO,                " ABAP Standard Header Table..
        EKPO,                " ABAP Standard Item Table..
        ZTREQHD,             " �����Ƿ� Header Table..
        ZTREQIT,             " �����Ƿ� Item Table..
        ZTBL,                " B/L Table..
        ZTBLIT,              " B/L  Item Table..
        LFA1,                " �ŷ�ó Master Table..
        ZTMSHD,              " �𼱰��� Header Table..
        ZTCGHD,              " �Ͽ� Header Table..
        ZTCGIT,              " �Ͽ� ���� Table..
        ZTREQORJ,            " �����Ƿ� ������ ���� Table..
        ZTIMIMG03,           " �������� �ڵ� Table..
        ZTIMIMG10,           " ������ ����..
        T005T,               " �����̸� Table..
        T001L,               " ������ġ Table..
        T001W,               " �÷�Ʈ/�б� Table..
        ZTCIVHD,             " Commercial Invoice Header..
        ZTCIVIT,             " Commercial Invoice Items..
        ZTIV,                " �����û/�԰��û Header..
        ZTIVIT,              " �����û/�԰��û Item Table..
        ZTCUCL,              " ��� Table..
        ZTCUCLIV,            " ��� Invoice Table..
        ZTCUCLIVIT,          " ��� Invoice Item Table..
        ZTIDS,               " ���Ը��� Table..
        ZTIDSHSD,
        ZTIDR,               " ���ԽŰ� Table..
        ZTIVHSTIT.           " �԰��û ITEM.

*------------------------------------------*
* P/O ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*------------------------------------------*
DATA: BEGIN OF IT_PO OCCURS 1000,
        EBELN    LIKE   EKKO-EBELN,      " P/O Header No..
        LIFNR    LIKE   EKKO-LIFNR,      " Vendor's Account No..
        AEDAT    LIKE   EKKO-AEDAT,      " ���ڵ������..
        WAERS    LIKE   EKKO-WAERS,      " ��ȭŰ..
        EBELP    LIKE   EKPO-EBELP,      " P/O Item No..
        MATNR    LIKE   EKPO-MATNR,      " �����ȣ..
        BUKRS    LIKE   EKPO-BUKRS,      " ȸ���ڵ�..
        WERKS    LIKE   EKPO-WERKS,      " �÷�Ʈ..
        TXZ01    LIKE   EKPO-TXZ01,      " ����..
        MENGE    LIKE   EKPO-MENGE,      " ���ſ�������..
        MEINS    LIKE   EKPO-MEINS,      " ��������..
        NETPR    LIKE   EKPO-NETPR,      " ���Ź����� �ܰ� (������ȭ).
        PEINH    LIKE   EKPO-PEINH,      " ���ݴ���..
        NAME1    LIKE   LFA1-NAME1,                         " �̸�1..
      END OF IT_PO.

*-----------------------------------------------*
* �����Ƿ� ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*-----------------------------------------------*

DATA: BEGIN OF IT_RN OCCURS 1000,
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ.
        ZFREQTY   LIKE   ZTREQHD-ZFREQTY,  " �����Ƿ� TYPE
        EBELN     LIKE   ZTREQHD-EBELN,    " Purchasing Document Number.
        EBELP     LIKE   ZTREQIT-EBELP,    " P/O Item Number.
        LIFNR     LIKE   ZTREQHD-LIFNR,    " Vendor's Account Number.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFOPNNO   LIKE   ZTREQHD-ZFOPNNO,  " �ſ���-���ι�ȣ.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ���Թ��� ǰ���ȣ.
        MATNR     LIKE   ZTREQIT-MATNR,    " Material Number.
        MENGE     LIKE   ZTREQIT-MENGE,    " �����Ƿڼ���.
        MEINS     LIKE   ZTREQIT-MEINS,    " Base Unit of Measure.
        NETPR     LIKE   ZTREQIT-NETPR,    " Net Price.
        PEINH     LIKE   ZTREQIT-PEINH,    " Price Unit.
        BPRME     LIKE   ZTREQIT-BPRME,    " Order Price Unit.
        ZFORIG    LIKE   ZTREQORJ-ZFORIG,  " ������걹..
        LANDX     LIKE   T005T-LANDX,      " �����̸�..
        END OF IT_RN.

*-----------------------------------------------------------------------
* B/L ��ȣ ��ȸ�� ���� Internal Table Declaration.
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_BL OCCURS 1000,
        ZFBLNO    LIKE   ZTBL-ZFBLNO,      " B/L ���� ��ȣ..
        ZFMSNO    LIKE   ZTBL-ZFMSNO,      " �𼱰�����ȣ..
        ZFFORD    LIKE   ZTBL-ZFFORD,      " Forwarder..
        ZFAPRTC   LIKE   ZTBL-ZFAPRTC,     " ������ �ڵ�..
        ZFAPRT    LIKE   ZTBL-ZFAPRT,      " ������..
        ZFHBLNO   LIKE   ZTBL-ZFHBLNO,     " House B/L No..
        ZFREBELN  LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O No..
        LIFNR     LIKE   ZTBL-LIFNR,       " Account No..
        ZFOPNNO   LIKE   ZTBL-ZFOPNNO,     " �ſ���-���ι�ȣ.
        ZFETA     LIKE   ZTBL-ZFETA,       " ������(ETD)..
        ZFPOYN    LIKE   ZTBL-ZFPOYN,      " ��ȯ����..
        ZFRENT    LIKE   ZTBL-ZFRENT,      " �絵 B/L ����..
        ZFBLIT    LIKE   ZTBLIT-ZFBLIT,    " B/L ǰ���ȣ..
        EBELN     LIKE   ZTBLIT-EBELN,     " ���Ź�����ȣ..
        EBELP     LIKE   ZTBLIT-EBELP,     " ���Ź��� ǰ���ȣ..
        ZFREQNO   LIKE   ZTBLIT-ZFREQNO,   " �����Ƿ� ������ȣ..
        ZFITMNO   LIKE   ZTBLIT-ZFITMNO,   " ���Թ��� ǰ���ȣ..
        MATNR     LIKE   ZTBLIT-MATNR,     " �����ȣ..
        BLMENGE   LIKE   ZTBLIT-BLMENGE,   " B/L ����..
        MEINS     LIKE   ZTBLIT-MEINS,     " �⺻����..
      END OF IT_BL.

*-----------------------------------------------------------------------
* �𼱰����� ���� Internal Table ����..
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_MS OCCURS 1000,
        ZFMSNO    LIKE   ZTMSHD-ZFMSNO,    " �𼱰�����ȣ..
        ZFMSNM    LIKE   ZTMSHD-ZFMSNM,    " �𼱸�..
        ZFREQNO   LIKE   ZTMSIT-ZFREQNO,   " �����Ƿڰ�����ȣ..
        ZFSHSDF   LIKE   ZTMSHD-ZFSHSDF,   " ������(From)..
        ZFSHSDT   LIKE   ZTMSHD-ZFSHSDT,   " ������(To)..
      END OF IT_MS.

*-----------------------------------------------------------------------
*  Declaration of Internal Table for Commercial Invoice Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CIV OCCURS 1000,
        ZFCIVRN   LIKE ZTCIVHD-ZFCIVRN,  " Commercial Invoice ������ȣ..
        ZFCIVNO   LIKE ZTCIVHD-ZFCIVNO,  " Commercial Invoice Number..
        ZFMAVN    LIKE ZTCIVHD-ZFMAVN,   " ���� �ŷ�ó�ڵ�..
        ZFOPBN    LIKE ZTCIVHD-ZFOPBN,   " �������� �ŷ�ó�ڵ�..
        ZFCIVSQ   LIKE ZTCIVIT-ZFCIVSQ,  " Commercial Invoice ǰ���ȣ..
        EBELN     LIKE ZTCIVIT-EBELN,    " ���Ź�����ȣ..
        EBELP     LIKE ZTCIVIT-EBELP,    " ���Ź��� ǰ���ȣ..
        ZFREQNO   LIKE ZTCIVIT-ZFREQNO,  " �����Ƿ� ������ȣ..
        ZFITMNO   LIKE ZTCIVIT-ZFITMNO,  " ���Թ��� ǰ���ȣ..
        ZFBLNO    LIKE ZTCIVIT-ZFBLNO,   " B/L ������ȣ..
        ZFBLIT    LIKE ZTCIVIT-ZFBLIT,   " B/L ǰ���ȣ..
        CMENGE    LIKE ZTCIVIT-CMENGE,   " Commercial Invoice ����..
        MEINS     LIKE ZTCIVIT-MEINS,    " �⺻����..
      END OF IT_CIV.

*-----------------------------------------------------------------------
* �Ͽ��� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_CG OCCURS 1000,
        ZFCGNO    LIKE   ZTCGHD-ZFCGNO,    " �Ͽ�������ȣ..
        ZFMSNO    LIKE   ZTCGHD-ZFMSNO,    " �𼱰�����ȣ..
        ZFETA     LIKE   ZTCGHD-ZFETA,     " ������(ETA)..
        ZFCGPT    LIKE   ZTCGHD-ZFCGPT,    " �Ͽ���..
        ZFCGIT    LIKE   ZTCGIT-ZFCGIT,    " �Ͽ��������..
        EBELN     LIKE   ZTCGIT-EBELN,     " ���Ź�����ȣ..
        EBELP     LIKE   ZTCGIT-EBELP,     " ���Ź��� ǰ���ȣ..
        ZFREQNO   LIKE   ZTCGIT-ZFREQNO,   " �����Ƿ� ������ȣ..
        ZFITMNO   LIKE   ZTCGIT-ZFITMNO,   " ���Թ��� ǰ���ȣ..
        ZFBLNO    LIKE   ZTCGIT-ZFBLNO,    " B/L ������ȣ..
        ZFBLIT    LIKE   ZTCGIT-ZFBLIT,    " B/L ǰ���ȣ..
        MATNR     LIKE   ZTCGIT-MATNR,     " �����ȣ..
        CGMENGE   LIKE   ZTCGIT-CGMENGE,   " �Ͽ��������..
        MEINS     LIKE   ZTCGIT-MEINS,     " �⺻����..
        ZFBNARCD  LIKE   ZTCGIT-ZFBNARCD,  " �������� ���ΰ����ڵ�..
      END OF IT_CG.

*-----------------------------------------------------------------------
* �ŷ�ó������ ���̺� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_LFA OCCURS 1000,
         LIFNR    LIKE   LFA1-LIFNR,
         NAME1    LIKE   LFA1-NAME1,
      END OF IT_LFA.

*-----------------------------------------------------------------------
* ���������ڵ� ���̺� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IMG03 OCCURS 1000.
        INCLUDE STRUCTURE ZTIMIMG03.
DATA  END OF IT_IMG03.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for Customer Clearence Data Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CUCLIV OCCURS 1000,
        ZFIVNO    LIKE   ZTCUCLIV-ZFIVNO,    " Invoice ������ȣ.
        ZFBLNO    LIKE   ZTCUCLIV-ZFBLNO,    " B/L ������ȣ.
        ZFCLSEQ   LIKE   ZTCUCLIV-ZFCLSEQ,   " �������.
        ZFIVAMT   LIKE   ZTCUCLIV-ZFIVAMT,   " Invoice �ݾ�.
        ZFIVAMC   LIKE   ZTCUCLIV-ZFIVAMC,   " Invoice �ݾ� ��ȭ.
        ZFIVAMK   LIKE   ZTCUCLIV-ZFIVAMK,   " Invoice �ݾ�(��ȭ)
        ZFRMK1    LIKE   ZTCUCLIV-ZFRMK1,    " ��������1.
        ZFRMK2    LIKE   ZTCUCLIV-ZFRMK2,    " ��������2.
        MJAHR     LIKE   ZTCUCLIV-MJAHR,     " ���繮������.
        MBLNR     LIKE   ZTCUCLIV-MBLNR,     " ���繮����ȣ.
        ZFPONC    LIKE   ZTCUCLIV-ZFPONC,    " ���԰ŷ�����.
        ZFIVDNO   LIKE   ZTCUCLIVIT-ZFIVDNO, " Invoice Item �Ϸù�ȣ.
        MATNR     LIKE   ZTCUCLIVIT-MATNR,   " �����ȣ.
        STAWN     LIKE   ZTCUCLIVIT-STAWN,   " �����ڵ��ȣ.
        MENGE     LIKE   ZTCUCLIVIT-MENGE,   " �����Ƿڼ���.
        MEINS     LIKE   ZTCUCLIVIT-MEINS,   " �⺻����.
        NETPR     LIKE   ZTCUCLIVIT-NETPR,   " �ܰ�.
        PEINH     LIKE   ZTCUCLIVIT-PEINH,   " ���ݴ���.
        BPRME     LIKE   ZTCUCLIVIT-BPRME,   " Order Price Unit.
        TXZ01     LIKE   ZTCUCLIVIT-TXZ01,   " ����.
      END OF IT_CUCLIV.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for Customs Clearance Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_CUCL OCCURS 1000.
        INCLUDE STRUCTURE ZTCUCLIV.
DATA  END OF IT_CUCL.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for ZTIDR Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IDR OCCURS 1000.
        INCLUDE STRUCTURE ZTIDR.
*DATA  zfivno  LIKE  ztidrhsd-zfivno.
DATA  ZFIVDNO LIKE  ZTIDRHSD-ZFIVDNO.
DATA  ZFQNT   LIKE  ZTIDRHSD-ZFQNT.
DATA  ZFQNTM  LIKE  ZTIDRHSD-ZFQNTM.
DATA  END OF IT_IDR.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for ZTIDS Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IDS OCCURS 1000.
        INCLUDE STRUCTURE ZTIDS.
DATA  ZFQNT  LIKE  ZTIDSHSD-ZFQNT.
DATA  ZFQNTM LIKE  ZTIDSHSD-ZFQNTM.
DATA: END OF IT_IDS.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for T001L Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_T001L OCCURS 1000.
        INCLUDE STRUCTURE T001L.
DATA: END OF IT_T001L.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for T001W Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_T001W OCCURS 1000.
        INCLUDE STRUCTURE T001W.
DATA: END OF IT_T001W.

*-------------------------------------------------*
* �԰� DATA�� READ �ϱ� ���� INTERNAL TABLE ����. *
*-------------------------------------------------*
DATA : BEGIN OF IT_IN OCCURS 1000,
       ZFIVNO    LIKE   ZTIVHSTIT-ZFIVNO,
       ZFIVHST   LIKE   ZTIVHSTIT-ZFIVHST,
       ZFGRST    LIKE   ZTIVHSTIT-ZFGRST,
       ZFIVDNO   LIKE   ZTIVHSTIT-ZFIVDNO,
       MATNR     LIKE   ZTIVHSTIT-MATNR,
       GRMENGE   LIKE   ZTIVHSTIT-GRMENGE,
       MEINS     LIKE   ZTIVHSTIT-MEINS,
       WERKS     LIKE   ZTIVHSTIT-WERKS,
       LGORT     LIKE   ZTIVHSTIT-LGORT,
       MBLNR     LIKE   ZTIVHST-MBLNR,
       MJAHR     LIKE   ZTIVHST-MJAHR,
       EBELN     LIKE   EKPO-EBELN,
       EBELP     LIKE   EKPO-EBELP,
       BUKRS     LIKE   ZTIV-BUKRS.
DATA : END OF IT_IN.

*-----------------------------------------------------------------------
* Declaration of Internal Talbe for ZTIVIT Table Reference..
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_IVIT OCCURS 1000.
        INCLUDE STRUCTURE ZTIVIT.
DATA:   ZFCUST    LIKE   ZTIV-ZFCUST,
        ZFGRST    LIKE   ZTIV-ZFGRST.
DATA: END OF IT_IVIT.

*-----------------------------------------------------------------------
* Declaration of Variable for Table Usage..
*-----------------------------------------------------------------------
DATA: W_TABIX     LIKE SY-TABIX,
      W_BEWTP     LIKE EKBE-BEWTP,
      W_ERR_CHK   TYPE C,
      W_TRIPLE(5) TYPE C,
      W_PAGE      TYPE I.

*-----------------------------------------------------------------------
* Declaration of Variable for Instead of ON CHANGE OF Function..
*-----------------------------------------------------------------------
DATA: W_LOOP_CNT  TYPE I,
      TEMP_MATNR  LIKE EKPO-MATNR,         " �����ȣ�� �ӽ÷� ����..
      TEMP_TXZ01  LIKE EKPO-TXZ01,         " ���系���� �ӽ÷� ����..
      TEMP_EBELN  LIKE EKPO-EBELN,         " P/O ��ȣ�� �ӽ÷� ����..
      TEMP_EBELP  LIKE EKPO-EBELP,         " Item ��ȣ�� �ӽ÷� ����..
      TEMP_REQNO  LIKE ZTREQHD-ZFREQNO,    " �����Ƿڰ�����ȣ ����..
      TEMP_ITMNO  LIKE ZTREQIT-ZFITMNO,    " Item ��ȣ�� �ӽ÷� ����..
      TEMP_BLNO   LIKE ZTBL-ZFBLNO,        " B/L ��ȣ�� �ӽ÷� ����..
      TEMP_BLIT   LIKE ZTBLIT-ZFBLIT,      " B/L Item ��ȣ �ӽ�����..
      TEMP_CGNO   LIKE ZTCGHD-ZFCGNO,      " �Ͽ�������ȣ�� �ӽ�����..
      TEMP_CGIT   LIKE ZTCGIT-ZFCGIT,      " �Ͽ���������� �ӽ�����..
      TEMP_IVNO   LIKE ZTIVIT-ZFIVNO,      " ���/�԰��û������ȣ ����.
      TEMP_IVDNO  LIKE ZTIVIT-ZFIVDNO.    " Invoice Item �Ϸù�ȣ ����..

*-----------------------------------------------------------------------
* HIDE VARIABLE.
*-----------------------------------------------------------------------
DATA: BEGIN OF DOCU,
        TYPE(2)   TYPE C,
        CODE      LIKE EKKO-EBELN,
        ITMNO     LIKE EKPO-EBELP,
        YEAR      LIKE BKPF-GJAHR,
      END OF DOCU.

*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_BUKRS   FOR ZTREQHD-BUKRS,
               S_EBELN   FOR EKKO-EBELN,       " P/O No.
               S_MATNR   FOR EKPO-MATNR,       " ���� No.
               S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� No.
               S_OPNNO   FOR ZTREQHD-ZFOPNNO,  " �ſ���-���ι�ȣ.
               S_LIFNR   FOR ZTREQHD-LIFNR,    " Vendor.
               S_REQTY   FOR ZTREQHD-ZFREQTY,
               S_TRANS   FOR ZTREQHD-ZFTRANS,
               S_REQSD   FOR ZTREQHD-ZFREQSD,
               S_REQED   FOR ZTREQHD-ZFREQED,
               S_SHCU    FOR ZTREQHD-ZFSHCU.
* PARAMETERS :   P_TRIPLE  AS CHECKBOX.          " �ﱹ������?
SELECTION-SCREEN END OF BLOCK B2.

*.. �ﱹ���� ��?
SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-R01.
  SELECTION-SCREEN : BEGIN OF LINE,
                     COMMENT 01(31) TEXT-R01.
    SELECTION-SCREEN : COMMENT 33(4) TEXT-R04.
    PARAMETERS : P_ALL RADIOBUTTON GROUP RDG.
    SELECTION-SCREEN : COMMENT 52(3) TEXT-R02.
    PARAMETERS : P_YES RADIOBUTTON GROUP RDG.
    SELECTION-SCREEN : COMMENT 70(3) TEXT-R03.
    PARAMETERS : P_NO  RADIOBUTTON GROUP RDG.
  SELECTION-SCREEN : END OF LINE.
SELECTION-SCREEN END OF BLOCK B3.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
  SET TITLEBAR 'TIT1'.
  MOVE 'X' TO P_ALL.
*-----------------------------------------------------------------------
* TOP-OF-PAGE.
*-----------------------------------------------------------------------
TOP-OF-PAGE.
  PERFORM P3000_TITLE_WRITE.

*-----------------------------------------------------------------------
* START-OF-SELECTION.
*-----------------------------------------------------------------------
START-OF-SELECTION.

* �����Ƿ� No.
  PERFORM P1000_READ_RN_DATA USING W_ERR_CHK.
  CHECK W_ERR_CHK NE 'Y'.

* P/O Table Select..
  PERFORM P1000_READ_PO_DATA.

* �� Table Select..
  PERFORM P1000_READ_MS_DATA.

* B/L Table Select..
  PERFORM P1000_READ_BL_DATA.

* Commercial Invoice Table Select..
  PERFORM P1000_READ_CIV_DATA.

* �Ͽ� Table Select..
  PERFORM P1000_READ_CG_DATA.

* ���������ڵ� Table Select..
  PERFORM P1000_READ_IMG03_DATA.

* ����ó Table Select..
  PERFORM P1000_READ_LFA_DATA.

* ��� Table Select..
  PERFORM P1000_READ_CUCL_DATA.

* ��� Invoice Table Select..
*   PERFORM P1000_READ_CUCLIV_DATA.

* �����û/�԰��û Table Select..
  PERFORM P1000_READ_IVIT_DATA.

* ���ԽŰ� Table Select..
  PERFORM P1000_READ_ZFIDR_DATA.

* ���Ը��� Table Select..
  PERFORM P1000_READ_ZFIDS_DATA.

* T001W Table Select..
  PERFORM P1000_READ_T001W_DATA.

* T001L Table Select..
  PERFORM P1000_READ_T001L_DATA.

* NHJ �߰�( 2001. 07. 03 )
* �԰� TABLE READ
   PERFORM P1000_READ_IN_DATA.

*-----------------------------------------------------------------------
* END-OF-SELECTION.
*-----------------------------------------------------------------------
END-OF-SELECTION.
  CHECK W_ERR_CHK NE 'Y'.
* Title Text Write.
  SET TITLEBAR 'TIT1'.
  SET PF-STATUS 'ZIM92'.

* Sort P/O, Request No. Internal Table.
  PERFORM P2000_SORT_IT_DATA.

* List Write...
  PERFORM P3000_WRITE_PO_DATA.

*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT LINE-SELECTION.

  DATA : L_TEXT_MA(20),
         L_TEXT_PO(20),
         L_TEXT_RN(20),
         L_TEXT_BL(24),
         L_TEXT_IVIT(20),
         L_TEXT_CIV(20),
         L_TEXT_IDR(20),
         L_TEXT_IDS(20),
         L_TEXT_IN(20).
  DATA : MM03_START_SICHT(15) TYPE C  VALUE 'BDEKLPQSVXZA'.

  GET CURSOR FIELD L_TEXT_MA.
  CASE L_TEXT_MA.   " �ʵ��..

    WHEN 'IT_PO-MATNR' OR 'IT_PO-TXZ01'.
      SET PARAMETER ID 'MAT' FIELD IT_PO-MATNR.
      SET PARAMETER ID 'BUK' FIELD IT_PO-BUKRS.
      SET PARAMETER ID 'WRK' FIELD IT_PO-WERKS.
      SET PARAMETER ID 'LAG' FIELD ''.
      SET PARAMETER ID 'MXX' FIELD MM03_START_SICHT.
      CALL TRANSACTION 'MM03' AND SKIP  FIRST SCREEN.

  ENDCASE.

  GET CURSOR FIELD L_TEXT_PO.
  CASE L_TEXT_PO.   " �ʵ��..

    WHEN 'IT_PO-EBELN' OR 'IT_PO-EBELP'.
      SET PARAMETER ID 'BES'  FIELD IT_PO-EBELN.
      SET PARAMETER ID 'BSP'  FIELD IT_PO-EBELP.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
  ENDCASE.
  CLEAR: IT_PO.

  GET CURSOR FIELD L_TEXT_RN.
  CASE L_TEXT_RN.   " �ʵ��..

    WHEN 'IT_RN-ZFOPNNO' OR 'IT_RN-ZFREQNO'.
      SET PARAMETER ID 'ZPREQNO' FIELD IT_RN-ZFREQNO.
      SET PARAMETER ID 'ZPOPNNO' FIELD ''.
      SET PARAMETER ID 'BES'     FIELD ''.
      CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_RN.

  GET CURSOR FIELD L_TEXT_BL.
  CASE L_TEXT_BL.   " �ʵ��..

    WHEN 'IT_BL-ZFHBLNO' OR 'IT_BL-ZFBLNO'.
      SET PARAMETER ID 'ZPBLNO'  FIELD IT_BL-ZFBLNO.
      SET PARAMETER ID 'ZPHBLNO' FIELD ''.
      CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.
    WHEN 'IT_CG-ZFCGNO'.
      SET PARAMETER ID 'ZPHBLNO' FIELD ''.
      SET PARAMETER ID 'ZPBLNO'  FIELD ''.
      SET PARAMETER ID 'ZPCGNO'  FIELD IT_CG-ZFCGNO.
      CALL TRANSACTION 'ZIM83' AND SKIP FIRST SCREEN.
  ENDCASE.
  CLEAR: IT_BL.

  GET CURSOR FIELD L_TEXT_IVIT.
  CASE L_TEXT_IVIT.   " �ʵ��..

    WHEN 'IT_IVIT-ZFIVNO'.
      SET PARAMETER ID 'ZPIVNO' FIELD IT_IVIT-ZFIVNO.
      SET PARAMETER ID 'ZPBLNO' FIELD ''.
      SET PARAMETER ID 'ZPHBLNO' FIELD ''.
      CALL TRANSACTION 'ZIM33' AND SKIP FIRST SCREEN.
  ENDCASE.
  CLEAR: IT_IVIT.

  GET CURSOR FIELD L_TEXT_CIV.
  CASE L_TEXT_CIV.   " �ʵ��..

    WHEN 'IT_CIV-ZFCIVRN' OR 'IT_CIV-ZFCIVNO'.
      SET PARAMETER ID 'ZPCIVRN' FIELD IT_CIV-ZFCIVRN.
      SET PARAMETER ID 'ZPCIVNO' FIELD ''.
      CALL TRANSACTION 'ZIM37' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_CIV.

  GET CURSOR FIELD L_TEXT_IDR.
  CASE L_TEXT_IDR.   " �ʵ��..

    WHEN 'IT_IDR-ZFIDRNO' OR 'IT_IDR-ZFCLSEQ'.
      SET PARAMETER ID 'ZPIDRNO' FIELD IT_IDR-ZFIDRNO.
      SET PARAMETER ID 'ZPCLSEQ' FIELD IT_IDR-ZFCLSEQ.
      SET PARAMETER ID 'ZPBLNO' FIELD IT_IDR-ZFBLNO.
      SET PARAMETER ID 'ZPHBLNO' FIELD ''.
      CALL TRANSACTION 'ZIM63' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_IDR.

  GET CURSOR FIELD L_TEXT_IDS.
  CASE L_TEXT_IDS.   " �ʵ��..

    WHEN 'IT_IDS-ZFIDRNO' OR 'IT_IDS-ZFCLSEQ'.
      SET PARAMETER ID 'ZPIDRNO' FIELD IT_IDS-ZFIDRNO.
      SET PARAMETER ID 'ZPCLSEQ' FIELD IT_IDS-ZFCLSEQ.
      SET PARAMETER ID 'ZPHBLNO' FIELD ''.
      SET PARAMETER ID 'ZPBLNO' FIELD  IT_IDS-ZFBLNO.
      CALL TRANSACTION 'ZIM76' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_IDS.
*>> NHJ 20001.07.03 �԰� DATA DISPLAY
  GET CURSOR FIELD L_TEXT_IN.
  CASE  L_TEXT_IN.
     WHEN  'IT_IN-MBLNR'.
           SET  PARAMETER ID  'BUK'   FIELD   IT_IN-BUKRS.
           SET  PARAMETER ID  'MBN'   FIELD   IT_IN-MBLNR.
           SET  PARAMETER ID  'MJA'   FIELD   IT_IN-MJAHR.
*>> �԰��� ��ȸ FUNCTION CALL.
           CALL FUNCTION 'MIGO_DIALOG'
            EXPORTING
              I_ACTION                  = 'A04'
              I_REFDOC                  = 'R02'
              I_NOTREE                  = 'X'
*             I_NO_AUTH_CHECK           =
              I_SKIP_FIRST_SCREEN       = 'X'
*             I_DEADEND                 = 'X'
              I_OKCODE                  = 'OK_GO'
*             I_LEAVE_AFTER_POST        =
*             i_new_rollarea            = 'X'
*             I_SYTCODE                 =
*             I_EBELN                   =
*             I_EBELP                   =
              I_MBLNR                   = IT_IN-MBLNR
              I_MJAHR                   = IT_IN-MJAHR
*             I_ZEILE                   =
           EXCEPTIONS
              ILLEGAL_COMBINATION       = 1
              OTHERS                    = 2.
      ENDCASE.
      CLEAR  L_TEXT_IN.
*&------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&------------------------------------------------------------------*
FORM P1000_READ_RN_DATA USING W_ERR_CHK.

  W_ERR_CHK = 'N'.
  CLEAR  W_TRIPLE.
  IF P_ALL = 'X'.
     W_TRIPLE = '%'.
  ELSEIF P_NO = 'X'.
     W_TRIPLE = ' %'.
  ELSEIF P_YES = 'X'.
     W_TRIPLE = 'X%'.
  ENDIF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_RN
    FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
    ON     H~ZFREQNO EQ I~ZFREQNO
    WHERE  H~ZFREQNO  IN  S_REQNO
    AND    H~ZFOPNNO  IN  S_OPNNO
    AND    H~EBELN    IN  S_EBELN
    AND    I~MATNR    IN  S_MATNR
    AND    H~LIFNR    IN  S_LIFNR
    AND    H~ZFREQTY  IN  S_REQTY
    AND    H~ZFTRANS  IN  S_TRANS
    AND    H~BUKRS    IN  S_BUKRS
    AND    H~ZFREQSD  IN  S_REQSD
    AND    H~ZFREQED  IN  S_REQED
    AND    H~ZFSHCU   IN  S_SHCU
    AND    H~ZFTRIPLE LIKE  W_TRIPLE.

    IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
    ENDIF.

    LOOP AT IT_RN.
      W_TABIX = SY-TABIX.
      ON CHANGE OF IT_RN-ZFREQNO.
        SELECT SINGLE * FROM ZTREQORJ
                       WHERE ZFREQNO = IT_RN-ZFREQNO
                         AND ZFLSG7O = '00010'.

        SELECT SINGLE * FROM T005T
                       WHERE LAND1   = ZTREQORJ-ZFORIG
                         AND SPRAS   = SY-LANGU.
      ENDON.

      MOVE: ZTREQORJ-ZFORIG TO IT_RN-ZFORIG,
            T005T-LANDX     TO IT_RN-LANDX.
      MODIFY IT_RN INDEX W_TABIX.
    ENDLOOP.

  ENDFORM.                    " P1000_READ_RN_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_PO_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_PO_DATA.

  SELECT *
    INTO   CORRESPONDING FIELDS OF TABLE IT_PO
    FROM   EKKO AS H INNER JOIN EKPO AS I
    ON     H~EBELN EQ I~EBELN
    FOR ALL ENTRIES IN IT_RN
    WHERE  H~EBELN EQ IT_RN-EBELN
    AND    I~EBELP EQ IT_RN-EBELP.
*     AND    I~MATNR EQ IT_RN-MATNR
*     AND    H~LIFNR EQ IT_RN-LIFNR.

  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

ENDFORM.                    " P1000_READ_PO_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_LFA_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_LFA_DATA.

  SELECT *
    INTO   CORRESPONDING FIELDS OF TABLE IT_LFA
    FROM   LFA1
    FOR ALL ENTRIES IN IT_RN
    WHERE  LIFNR EQ IT_RN-LIFNR.

  SELECT *
    APPENDING  CORRESPONDING FIELDS OF TABLE IT_LFA
    FROM   LFA1
    FOR ALL ENTRIES IN IT_IMG03
    WHERE  LIFNR EQ IT_IMG03-LIFNR.

  SELECT *
    APPENDING  CORRESPONDING FIELDS OF TABLE IT_LFA
    FROM   LFA1
    FOR ALL ENTRIES IN IT_CIV
    WHERE  LIFNR EQ IT_CIV-ZFMAVN
       OR  LIFNR EQ IT_CIV-ZFOPBN.

ENDFORM.                    " P1000_READ_LFA_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MS_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_MS
    FROM   ZTMSHD AS H INNER JOIN ZTMSIT AS I
    ON     H~ZFMSNO EQ I~ZFMSNO
    FOR ALL ENTRIES   IN  IT_RN
    WHERE  I~ZFREQNO  EQ  IT_RN-ZFREQNO.

  SELECT *
    APPENDING  CORRESPONDING FIELDS OF TABLE IT_MS
    FROM   ZTMSHD AS H INNER JOIN ZTMSIT AS I
    ON     H~ZFMSNO EQ I~ZFMSNO
    FOR ALL ENTRIES   IN IT_BL
    WHERE  H~ZFMSNO   EQ IT_BL-ZFMSNO.


ENDFORM.                    " P1000_READ_MS_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_BL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_BL_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_BL
    FROM   ZTBL AS H INNER JOIN ZTBLIT AS I
    ON     H~ZFBLNO  EQ I~ZFBLNO
    FOR ALL ENTRIES IN IT_RN
    WHERE  I~EBELN   EQ IT_RN-EBELN
    AND    I~EBELP   EQ IT_RN-EBELP
    AND    I~ZFREQNO EQ IT_RN-ZFREQNO
    AND    I~ZFITMNO EQ IT_RN-ZFITMNO.

ENDFORM.                    " P1000_READ_BL_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_CIV_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_CIV_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_CIV
    FROM   ZTCIVHD AS H INNER JOIN ZTCIVIT AS I
    ON     H~ZFCIVRN  EQ I~ZFCIVRN
    FOR ALL ENTRIES IN IT_RN
    WHERE  I~EBELN   EQ IT_RN-EBELN
    AND    I~EBELP   EQ IT_RN-EBELP
    AND    I~ZFREQNO EQ IT_RN-ZFREQNO
    AND    I~ZFITMNO EQ IT_RN-ZFITMNO.
*     AND    I~ZFBLNO  EQ IT_BL-ZFBLNO
*     AND    I~ZFBLIT  EQ IT_BL-ZFBLIT.

ENDFORM.                    " P1000_READ_CIV_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_CG_DATA
*&---------------------------------------------------------------------*
*       Read Cargo Data.
*----------------------------------------------------------------------*
FORM P1000_READ_CG_DATA.

  IF NOT IT_BL[] IS INITIAL.
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE IT_CG
      FROM   ZTCGHD AS H INNER JOIN ZTCGIT AS I
      ON     H~ZFCGNO EQ I~ZFCGNO
      FOR ALL ENTRIES   IN  IT_BL
      WHERE  I~EBELN    EQ  IT_BL-EBELN
      AND    I~EBELP    EQ  IT_BL-EBELP
      AND    I~ZFREQNO  EQ  IT_BL-ZFREQNO
      AND    I~ZFITMNO  EQ  IT_BL-ZFITMNO
      AND    I~ZFBLNO   EQ  IT_BL-ZFBLNO
      AND    I~ZFBLIT   EQ  IT_BL-ZFBLIT.
  ENDIF.

ENDFORM.                    " P1000_READ_CG_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IMG03_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_IMG03_DATA.

  SELECT *
    INTO   CORRESPONDING FIELDS OF TABLE IT_IMG03
    FROM   ZTIMIMG03
    FOR ALL ENTRIES IN IT_CG
    WHERE  ZFBNARCD EQ IT_CG-ZFBNARCD.

ENDFORM.                    " P1000_READ_IMG03_DATA

*&---------------------------------------------------------------------
*&      Form  P1000_READ_CUCL_DATA
*&---------------------------------------------------------------------
*       text
*----------------------------------------------------------------------

FORM P1000_READ_CUCL_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_CUCL
    FROM ZTCUCLIV
    FOR ALL ENTRIES IN IT_IVIT
    WHERE ZFIVNO EQ IT_IVIT-ZFIVNO.

ENDFORM.                    " P1000_READ_CUCL_DATA

**&---------------------------------------------------------------------
*
**&      Form  P1000_READ_CUCLIV_DATA
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
*
*FORM P1000_READ_CUCLIV_DATA.
*
*   SELECT *
*     INTO CORRESPONDING FIELDS OF TABLE IT_CUCLIV
*     FROM ZTCUCLIV AS H INNER JOIN ZTCUCLIVIT AS I
*     ON     H~ZFIVNO EQ I~ZFIVNO
*     WHERE  ZFBLNO   EQ IT_CUCL-ZFBLNO
*       AND  ZFCLSEQ  EQ IT_CUCL-ZFCLSEQ.
*
*ENDFORM.                    " P1000_READ_CUCLIV_DATA
*

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IVIT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_IVIT_DATA.
  DATA : L_TABIX LIKE SY-TABIX.

  IF NOT IT_BL[] IS INITIAL.
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE IT_IVIT
      FROM ZTIVIT
      FOR ALL ENTRIES IN IT_BL
      WHERE   ZFBLNO EQ IT_BL-ZFBLNO
        AND   ZFBLIT EQ IT_BL-ZFBLIT
        AND ( ZFCGNO IS NULL
        OR    ZFCGNO EQ SPACE ).
  ENDIF.
*     EQ IT_BL-ZFBLNO.
  IF NOT IT_CG[] IS INITIAL.
    SELECT *
      APPENDING CORRESPONDING FIELDS OF TABLE IT_IVIT
      FROM ZTIVIT
      FOR ALL ENTRIES IN IT_CG
      WHERE ZFCGNO EQ IT_CG-ZFCGNO
        AND ZFCGIT EQ IT_CG-ZFCGIT.
  ENDIF.

*>> LOCAL ���� DATA SELECT!
  SELECT  *
     APPENDING CORRESPONDING FIELDS OF TABLE IT_IVIT
     FROM   ZTIV AS H INNER JOIN ZTIVIT AS I
     ON       H~ZFIVNO   EQ    I~ZFIVNO
     FOR    ALL ENTRIES  IN    IT_RN
     WHERE  ( H~ZFREQTY  EQ    'LO' OR H~ZFREQTY EQ 'PU' )
     AND      I~ZFREQNO  EQ    IT_RN-ZFREQNO
     AND      I~ZFITMNO  EQ    IT_RN-ZFITMNO.

  LOOP AT IT_IVIT.
    L_TABIX = SY-TABIX.
    SELECT SINGLE ZFCUST ZFGRST
           INTO   (IT_IVIT-ZFCUST, IT_IVIT-ZFGRST)
           FROM   ZTIV
           WHERE  ZFIVNO EQ IT_IVIT-ZFIVNO.
    MODIFY IT_IVIT INDEX L_TABIX.
  ENDLOOP.
ENDFORM.                    " P1000_READ_IVIT_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ZFIDR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_ZFIDR_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_IDR
    FROM ZTIDR  AS  H  INNER JOIN  ZTIDRHSD AS I
    ON   H~ZFBLNO  EQ  I~ZFBLNO
    AND  H~ZFCLSEQ EQ  I~ZFCLSEQ
    FOR ALL ENTRIES IN IT_IVIT
    WHERE I~ZFIVNO  EQ IT_IVIT-ZFIVNO
      AND I~ZFIVDNO EQ IT_IVIT-ZFIVDNO.

ENDFORM.                    " P1000_READ_ZFIDR_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ZFIDS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_ZFIDS_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_IDS
    FROM ZTIDS  AS  H  INNER  JOIN  ZTIDSHSD  AS  I
    ON   H~ZFBLNO    EQ  I~ZFBLNO
    AND  H~ZFCLSEQ   EQ  I~ZFCLSEQ
    FOR ALL ENTRIES IN IT_IDR
    WHERE H~ZFBLNO  EQ  IT_IDR-ZFBLNO
      AND H~ZFCLSEQ EQ  IT_IDR-ZFCLSEQ.

ENDFORM.                    " P1000_READ_ZFIDS_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_T001W_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_T001W_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_T001W FROM T001W
    FOR ALL ENTRIES IN IT_IVIT
    WHERE WERKS   EQ IT_IVIT-WERKS.
*       AND ZFCLSEQ EQ IT_CUCL-ZFCLSEQ.

ENDFORM.                    " P1000_READ_T001W_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_T001L_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_T001L_DATA.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_T001L FROM T001L
    FOR ALL ENTRIES IN IT_IVIT
    WHERE WERKS   EQ IT_IVIT-WERKS
      AND LGORT   EQ IT_IVIT-LGORT.

ENDFORM.                    " P1000_READ_T001L_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE: /55 '[���纰 ������Ȳ]'
             COLOR COL_HEADING INTENSIFIED OFF.

  WRITE: / 'Date: ' ,
            SY-DATUM .

  WRITE: / '   '  COLOR COL_HEADING INTENSIFIED OFF,
           ': P/O  ' ,
           '   '  COLOR COL_NORMAL  INTENSIFIED OFF,
           ': �����Ƿ�  ',
           '   '  COLOR COL_NORMAL  INTENSIFIED ON,
           ': Commercial I/V  ',
           '   '  COLOR COL_TOTAL   INTENSIFIED OFF,
           ': B/L  ',
           '   '  COLOR COL_POSITIVE INTENSIFIED OFF,
           ': �Ͽ�  ',
           '   '  COLOR COL_NEGATIVE INTENSIFIED OFF,
           ': �����û  ',
           '   '  COLOR COL_GROUP    INTENSIFIED OFF,
           ': ���ԽŰ�  ',
           '   '  COLOR COL_GROUP    INTENSIFIED ON,
           ': ���Ը���  ',
           '   '  COLOR COL_TOTAL    INTENSIFIED ON,
           ': �԰�  '.
  SKIP 1.
ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_SORT_IT_DATA
*&---------------------------------------------------------------------*
*       SORTING INTERNAL TABLE..
*----------------------------------------------------------------------*
FORM P2000_SORT_IT_DATA.

  SORT IT_PO BY MATNR EBELN EBELP.
  SORT IT_RN BY MATNR EBELN ZFITMNO ZFREQNO.

ENDFORM.                    " P2000_SORT_IT_DATA

*----------------------------------------------------------------------*
* ���ȭ�� ��ȸ�� ���� PERFORM ��..
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  P3000_WEITE_PO_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_PO_DATA.
  DATA : L_FIRST_LINE   VALUE  'Y',
         L_DATE(10).

*>>> �ӽú����� ������ �ʱ�ȭ..
  CLEAR: TEMP_MATNR, " �����?
         TEMP_EBELN, " P/O ��?
         TEMP_EBELP, " Item ��?
         TEMP_TXZ01. " ���系?
  SKIP.
  LOOP AT IT_PO.
    IF TEMP_TXZ01 NE IT_PO-TXZ01.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      ULINE.
      WRITE: / IT_PO-MATNR NO-GAP, IT_PO-TXZ01 NO-GAP,
               '                               ' NO-GAP,
               142 '' NO-GAP.
      HIDE: IT_PO.
      FORMAT RESET.
    ENDIF.

    IF IT_PO-EBELN NE TEMP_EBELN.
      READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      CONCATENATE  IT_PO-AEDAT(4)  IT_PO-AEDAT+4(2)
                    IT_PO-AEDAT+6(2)
                    INTO L_DATE
                    SEPARATED BY '/'.

      READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: / IT_PO-EBELN NO-GAP.
      WRITE: 43 IT_PO-EBELP NO-GAP.
      WRITE: 68 IT_PO-MENGE UNIT IT_PO-MEINS NO-GAP,
             85 IT_PO-MEINS NO-GAP,
             91 IT_PO-PEINH NO-GAP, 97 IT_LFA-NAME1(20) NO-GAP.
*         WRITE: 132 L_DATE NO-GAP, '' NO-GAP.
      WRITE: 132 IT_PO-AEDAT NO-GAP, '' NO-GAP.
      HIDE: IT_PO.

    ELSEIF IT_PO-EBELP NE TEMP_EBELP.
      READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: / IT_PO-EBELN NO-GAP.
      WRITE: 43 IT_PO-EBELP NO-GAP.
      WRITE: 68 IT_PO-MENGE UNIT IT_PO-MEINS NO-GAP,
             85 IT_PO-MEINS NO-GAP,
             91 IT_PO-PEINH NO-GAP, 97 IT_LFA-NAME1(20) NO-GAP.
*         WRITE: 132 L_DATE NO-GAP, '' NO-GAP.
      WRITE: 132 IT_PO-AEDAT NO-GAP, '' NO-GAP.
      HIDE: IT_PO.
    ENDIF.
    PERFORM P3000_WRITE_RN_DATA.
    TEMP_MATNR = IT_PO-MATNR.
    TEMP_TXZ01 = IT_PO-TXZ01.
    TEMP_EBELN = IT_PO-EBELN.
    TEMP_EBELP = IT_PO-EBELP.
    CLEAR: IT_PO.
  ENDLOOP.

ENDFORM.                    " P3000_WEITE_PO_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_RN_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_RN_DATA.

  DATA : L_FIRST_LINE   VALUE  'Y',
         L_DATE_F(10),
         L_DATE_T(10).

*>>> �ӽú����� ������ �ʱ�ȭ..
  CLEAR: TEMP_REQNO,
         TEMP_ITMNO,
         W_LOOP_CNT.

  LOOP AT IT_RN
     WHERE EBELN = IT_PO-EBELN
       AND EBELP = IT_PO-EBELP.

    W_LOOP_CNT = W_LOOP_CNT + 1.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    IF TEMP_REQNO NE IT_RN-ZFREQNO.
      IF L_FIRST_LINE = 'Y'.
        WRITE: /3 IT_RN-ZFREQNO NO-GAP, 15 IT_RN-ZFOPNNO(20) NO-GAP.
      ELSE.
        WRITE: /3 IT_RN-ZFREQNO NO-GAP, 15 IT_RN-ZFOPNNO(20) NO-GAP.
      ENDIF.
      L_FIRST_LINE = 'N'.

      WRITE: 45 IT_RN-ZFITMNO NO-GAP,
             52 IT_RN-LANDX NO-GAP,
             68 IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP,
             85 IT_RN-MEINS NO-GAP, 142 '' NO-GAP.
      HIDE: IT_RN.
    ELSEIF TEMP_ITMNO NE IT_RN-ZFITMNO.
      WRITE: /45 IT_RN-ZFITMNO NO-GAP,
              52 IT_RN-LANDX NO-GAP,
              68 IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP,
             85 IT_RN-MEINS NO-GAP, 142 '' NO-GAP.
      HIDE: IT_RN.
    ENDIF.
    LOOP AT IT_MS
       WHERE ZFREQNO = IT_RN-ZFREQNO.
      CONCATENATE IT_MS-ZFSHSDF(4)
                  IT_MS-ZFSHSDF+4(2)
                  IT_MS-ZFSHSDF+6(2)
                  INTO L_DATE_F
                  SEPARATED BY '/'.

      CONCATENATE IT_MS-ZFSHSDT(4)
                  IT_MS-ZFSHSDT+4(2)
                  IT_MS-ZFSHSDT+6(2)
                  INTO L_DATE_T
                  SEPARATED BY '/'.

*         WRITE: 100 IT_MS-ZFMSNM(18) NO-GAP,
*               120 L_DATE_F NO-GAP,
*               132 L_DATE_T NO-GAP,
*               142 '' NO-GAP.
      WRITE: 100 IT_MS-ZFMSNM(18) NO-GAP,
             120 IT_MS-ZFSHSDF NO-GAP,
             132 IT_MS-ZFSHSDT NO-GAP,
             142 '' NO-GAP.

    ENDLOOP.
    PERFORM P3000_WRITE_CIV_DATA.
    PERFORM P3000_WRITE_LO_IVIT_DATA.
    PERFORM P3000_WRITE_BL_DATA.

    IF W_LOOP_CNT LT 1.
      PERFORM P3000_WRITE_BL_DATA.
    ENDIF.

    TEMP_REQNO = IT_RN-ZFREQNO.
    TEMP_ITMNO = IT_RN-ZFITMNO.
    CLEAR: IT_RN.
  ENDLOOP.

ENDFORM.                    " P3000_WRITE_RN_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_CIV_DATA
*&---------------------------------------------------------------------*
*       Subroutine for Writing Commercial Invoice Data.
*----------------------------------------------------------------------*
FORM P3000_WRITE_CIV_DATA.

  LOOP AT IT_CIV
     WHERE ZFREQNO = IT_RN-ZFREQNO
       AND ZFITMNO = IT_RN-ZFITMNO.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE: /3 IT_CIV-ZFCIVRN NO-GAP, '  ' NO-GAP,
              IT_CIV-ZFCIVNO(30) NO-GAP, IT_CIV-ZFCIVSQ NO-GAP,
           68 IT_CIV-CMENGE UNIT IT_CIV-MEINS NO-GAP,
           85 IT_CIV-MEINS NO-GAP.
    HIDE: IT_CIV.
    READ TABLE IT_LFA WITH KEY LIFNR = IT_CIV-ZFMAVN.
    IF SY-SUBRC EQ 0.
      WRITE IT_LFA-NAME1(20) NO-GAP.
    ELSE.
      WRITE: 142 '' NO-GAP.
    ENDIF.
    READ TABLE IT_LFA WITH KEY LIFNR = IT_CIV-ZFOPBN.
    IF SY-SUBRC EQ 0.
      WRITE: IT_LFA-NAME1(20) NO-GAP, 142 '' NO-GAP.
    ELSE.
      WRITE: 142 '' NO-GAP.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " P3000_WRITE_CIV_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_BL_DATA
*&---------------------------------------------------------------------*
*        Write Bill of Lading Data.
*----------------------------------------------------------------------*
FORM P3000_WRITE_BL_DATA.
  DATA : L_FIRST_LINE   VALUE  'Y',
         L_DATE_F(10),
         L_DATE_T(10).
*>>> �ӽú����� ������ �ʱ�ȭ..
  CLEAR : TEMP_BLNO,
          TEMP_BLIT.

  LOOP AT IT_BL
     WHERE ZFREQNO = IT_RN-ZFREQNO
       AND ZFITMNO = IT_RN-ZFITMNO.
    FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

    IF TEMP_BLNO NE IT_BL-ZFBLNO.
      WRITE: /5 IT_BL-ZFBLNO NO-GAP, 17 IT_BL-ZFHBLNO NO-GAP,
             47 IT_BL-ZFBLIT NO-GAP, 54 IT_BL-ZFFORD NO-GAP,
             68 IT_BL-BLMENGE UNIT IT_BL-MEINS NO-GAP,
             85 IT_BL-MEINS NO-GAP, 90 IT_BL-ZFAPRTC NO-GAP,
            142 '' NO-GAP.
      PERFORM P3000_WRITE_BL_ADD_DATA.
      HIDE: IT_BL.
    ELSEIF TEMP_BLIT NE IT_BL-ZFBLIT.
      WRITE: /, /47 IT_BL-ZFBLIT NO-GAP, 54 IT_BL-ZFFORD NO-GAP,
                 68 IT_BL-BLMENGE UNIT IT_BL-MEINS NO-GAP,
                 85 IT_BL-MEINS NO-GAP, 90 IT_BL-ZFAPRTC NO-GAP,
                142 '' NO-GAP.
      PERFORM P3000_WRITE_BL_ADD_DATA.
      HIDE: IT_BL.
    ENDIF.

    LOOP AT IT_MS
       WHERE ZFMSNO = IT_BL-ZFMSNO.
      CONCATENATE IT_MS-ZFSHSDF(4)
                  IT_MS-ZFSHSDF+4(2)
                  IT_MS-ZFSHSDF+6(2)
                  INTO L_DATE_F
                  SEPARATED BY '/'.

      CONCATENATE IT_MS-ZFSHSDT(4)
                  IT_MS-ZFSHSDT+4(2)
                  IT_MS-ZFSHSDT+6(2)
                  INTO L_DATE_T
                  SEPARATED BY '/'.

*         WRITE: 100 IT_MS-ZFMSNM(18) NO-GAP,
*               120 L_DATE_F NO-GAP,
*               132 L_DATE_T NO-GAP,
*               142 '' NO-GAP.
      WRITE: 100 IT_MS-ZFMSNM(18) NO-GAP,
             120 IT_MS-ZFSHSDF NO-GAP,
             132 IT_MS-ZFSHSDT NO-GAP,
             142 '' NO-GAP.

    ENDLOOP.

**> �Ͽ����� �����û�� ������ ���.
    READ TABLE IT_IVIT WITH KEY ZFBLNO = IT_BL-ZFBLNO
                                ZFBLIT = IT_BL-ZFBLIT
                                ZFCGNO = ''.
    IF SY-SUBRC EQ 0.
      PERFORM P3000_WRITE_IVIT_DATA.
    ENDIF.
    PERFORM P3000_WRITE_CG_DATA.
    CLEAR: IT_BL.
  ENDLOOP.

ENDFORM.                    " P3000_WRITE_BL_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_BL_ADD_DATA
*&---------------------------------------------------------------------*
*       �絵 B/L ���ο� ����ȯ ���θ� ���..
*----------------------------------------------------------------------*
FORM P3000_WRITE_BL_ADD_DATA.

  IF IT_BL-ZFPOYN EQ 'Y'.
    WRITE: 95 '��ȯ'.
  ELSE.
    WRITE: 95 '��ȯ'.
  ENDIF.

  IF IT_BL-ZFRENT EQ 'X'.
    WRITE: 102 '�絵 B/L'.
  ENDIF.

ENDFORM.                    " P3000_WRITE_BL_ADD_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_CG_DATA
*&---------------------------------------------------------------------*
*       �Ͽ����� Data�� ���..
*----------------------------------------------------------------------*
FORM P3000_WRITE_CG_DATA.

  CLEAR : TEMP_CGNO,
          TEMP_CGIT.

  LOOP AT IT_CG
     WHERE ZFBLNO = IT_BL-ZFBLNO
       AND ZFBLIT = IT_BL-ZFBLIT.
    FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
    READ TABLE IT_IMG03 WITH KEY ZFBNARCD = IT_CG-ZFBNARCD.
    IF SY-SUBRC EQ 0.
      READ TABLE IT_LFA   WITH KEY LIFNR    = IT_IMG03-LIFNR.
      IF SY-SUBRC NE 0.
        CLEAR : IT_LFA.
      ENDIF.
    ELSE.
      CLEAR : IT_LFA.
    ENDIF.

    IF TEMP_CGNO NE IT_CG-ZFCGNO.
      WRITE: /7 IT_CG-ZFCGNO NO-GAP, 19 IT_CG-ZFCGPT NO-GAP.
      WRITE: 23 IT_LFA-NAME1(20) NO-GAP, 49 IT_CG-ZFCGIT NO-GAP,
             68 IT_CG-CGMENGE UNIT IT_CG-MEINS NO-GAP,
             85 IT_CG-MEINS NO-GAP, 142 '' NO-GAP.
      HIDE: IT_CG.

    ELSEIF TEMP_CGIT NE IT_CG-ZFCGIT.
      WRITE: /, /23 IT_LFA-NAME1(20) NO-GAP, 49 IT_CG-ZFCGIT NO-GAP,
              68 IT_CG-CGMENGE UNIT IT_CG-MEINS NO-GAP,
              85 IT_CG-MEINS NO-GAP, 142 '' NO-GAP.
      HIDE: IT_CG.
      TEMP_CGNO = IT_CG-ZFCGNO.
      TEMP_CGIT = IT_CG-ZFCGIT.
    ENDIF.
    READ TABLE IT_IVIT WITH KEY ZFCGNO = IT_CG-ZFCGNO
                                ZFCGIT = IT_CG-ZFCGIT.
    IF SY-SUBRC EQ 0.
      PERFORM P3000_WRITE_IVIT_DATA.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " P3000_WRITE_CG_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IVIT_DATA
*&---------------------------------------------------------------------*
*       ���/�԰� ��û Data�� ���..
*----------------------------------------------------------------------*
FORM P3000_WRITE_IVIT_DATA.

  CLEAR : TEMP_IVNO,
          TEMP_IVDNO.

  IF IT_IVIT-ZFCGNO = ''.
    LOOP AT IT_IVIT WHERE ZFBLNO = IT_BL-ZFBLNO
                    AND   ZFBLIT = IT_BL-ZFBLIT
                    AND   ZFCGNO = SPACE.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
      IF TEMP_IVNO NE IT_IVIT-ZFIVNO.
        WRITE: /9 IT_IVIT-ZFIVNO NO-GAP, 21 IT_IVIT-TXZ01 NO-GAP,
               51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.

        HIDE: IT_IVIT.
      ELSEIF TEMP_IVDNO NE IT_IVIT-ZFIVDNO.
        WRITE: /, 21 IT_IVIT-TXZ01 NO-GAP,
               /51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.

        HIDE: IT_IVIT.
      ENDIF.
      TEMP_IVNO  = IT_IVIT-ZFIVNO.
      TEMP_IVDNO = IT_IVIT-ZFIVDNO.
*>> ������¿� ���� ����ڷ� WRITE
      IF IT_IVIT-ZFCUST EQ '2'
      OR IT_IVIT-ZFCUST EQ '3'
      OR IT_IVIT-ZFCUST EQ 'Y'.
         PERFORM P3000_WRITE_IDR_DATA.
      ENDIF.

    ENDLOOP.
  ELSE.
    LOOP AT IT_IVIT WHERE ZFCGNO = IT_CG-ZFCGNO
                      AND ZFCGIT = IT_CG-ZFCGIT.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
      IF TEMP_IVNO NE IT_IVIT-ZFIVNO.
        WRITE: /9 IT_IVIT-ZFIVNO NO-GAP, 21 IT_IVIT-TXZ01 NO-GAP,
               51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.

        HIDE: IT_IVIT.
      ELSEIF TEMP_IVDNO NE IT_IVIT-ZFIVDNO.
        WRITE: /, 21 IT_IVIT-TXZ01 NO-GAP,
               /51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.
        HIDE: IT_IVIT.

      ENDIF.
*>> ������¿� ���� ����ڷ� WRITE
      IF IT_IVIT-ZFCUST EQ '2'
      OR IT_IVIT-ZFCUST EQ '3'
      OR IT_IVIT-ZFCUST EQ 'Y'.
         PERFORM P3000_WRITE_IDR_DATA.
      ENDIF.

      TEMP_IVNO  = IT_IVIT-ZFIVNO.
      TEMP_IVDNO = IT_IVIT-ZFIVDNO.

    ENDLOOP.
  ENDIF.

ENDFORM.                    " P3000_WRITE_IVIT_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_OTHER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_OTHER_DATA.

  IF IT_IVIT-ZFCUST EQ '1'.
    WRITE: 97 '���ԽŰ� �Ƿڻ���' NO-GAP.
  ELSEIF IT_IVIT-ZFCUST EQ '2'.
    WRITE: 97 '���ԽŰ� �Ƿڴ��' NO-GAP.
  ELSEIF IT_IVIT-ZFCUST EQ '3'.
    WRITE: 97 '���ԽŰ� �Ƿ� ��' NO-GAP.
  ELSEIF IT_IVIT-ZFCUST EQ 'Y'.
    WRITE: 97 '����Ϸ�' NO-GAP.
  ELSEIF IT_IVIT-ZFCUST EQ 'N'.
    WRITE: 97 '����� ���(�Ұ�)' NO-GAP.
  ENDIF.
*>> NHJ 2001.07.03 ( �����԰� �������� ���� �԰�Ϸ� ���� CHECK DEL )
*  IF it_ivit-zfgrst EQ 'Y'.
*   WRITE: 120 '�԰�Ϸ�' NO-GAP.
* ELSEIF it_ivit-zfgrst EQ 'N'.
*   WRITE: 120 '�԰���' NO-GAP.
* ELSEIF it_ivit-zfgrst EQ 'X'.
*   WRITE: 120 '���԰���' NO-GAP.
* ENDIF.

*  WRITE 142 '' NO-GAP.

ENDFORM.                    " P3000_WRITE_OTHER_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IDR_DATA
*&---------------------------------------------------------------------*
*       ���ԽŰ�/���� ���� �����͸� ���..
*----------------------------------------------------------------------*
FORM P3000_WRITE_IDR_DATA.

  IF IT_IVIT-ZFCUST EQ 'Y'.
*   IF sy-subrc EQ 0.
      READ TABLE IT_IDR WITH KEY ZFIVNO  = IT_IVIT-ZFIVNO
                                 ZFIVDNO = IT_IVIT-ZFIVDNO.

      FORMAT COLOR COL_GROUP INTENSIFIED OFF.
      WRITE: /11 IT_IDR-ZFIDRNO NO-GAP, 31 IT_IDR-ZFCUT NO-GAP,
              53 IT_IDR-ZFCLSEQ NO-GAP,
              68 IT_IDR-ZFQNT UNIT IT_IDR-ZFQNTM NO-GAP,
              85 IT_IDR-ZFQNTM NO-GAP, 132 IT_IDR-ZFIDWDT NO-GAP,
             142 '' NO-GAP.
*            READ TABLE WITH KEY
      HIDE: IT_IDR.
      READ TABLE IT_IDS WITH KEY ZFBLNO  = IT_IDR-ZFBLNO
                                 ZFCLSEQ = IT_IDR-ZFCLSEQ.
      IF SY-SUBRC EQ 0.
        FORMAT COLOR COL_GROUP INTENSIFIED ON.
        WRITE: /13 IT_IDS-ZFIDRNO NO-GAP, 55 IT_IDS-ZFCLSEQ NO-GAP,
                68 IT_IDS-ZFQNT UNIT IT_IDS-ZFQNTM NO-GAP,
                85 IT_IDS-ZFQNTM NO-GAP, 132 IT_IDS-ZFIDSDT NO-GAP,
                142 '' NO-GAP.
        HIDE: IT_IDS.
      ENDIF.
*   ENDIF.

*>> NHJ 2001.07.03 (�԰� TABLE DATA READ).
    LOOP  AT  IT_IN  WHERE  ZFIVNO  EQ  IT_IVIT-ZFIVNO
                     AND    ZFIVDNO EQ  IT_IVIT-ZFIVDNO.
       PERFORM  P3000_WRITE_IN_DATA.
    ENDLOOP.

*    IF it_ivit-zfgrst EQ 'Y'.        " �԰���°� 'Y'�̸�..
*     FORMAT COLOR COL_TOTAL INTENSIFIED ON.
*     WRITE: /15 it_ivit-zfivno NO-GAP.
*     READ TABLE it_t001l WITH KEY lgort = it_ivit-lgort
*                                  werks = it_ivit-werks.
*     READ TABLE it_t001w WITH KEY werks = it_ivit-werks.
*     WRITE: 57 it_ivit-zfivdno NO-GAP,
*            68 it_ivit-grmenge UNIT it_ivit-meins NO-GAP,
*               it_ivit-meins NO-GAP,
*            97 it_t001w-name1 NO-GAP, it_t001l-lgobe NO-GAP,
*           142 '' NO-GAP.
*     HIDE: it_iVIT.
*    ENDIF.

  ELSEIF IT_IVIT-ZFCUST EQ '2'
      OR IT_IVIT-ZFCUST EQ '3'.
    IF SY-SUBRC EQ 0.
      READ TABLE IT_IDR WITH KEY ZFIVNO  = IT_IVIT-ZFIVNO
                                 ZFIVDNO = IT_IVIT-ZFIVDNO.
      WRITE: /11 IT_IDR-ZFIDRNO NO-GAP, 31 IT_IDR-ZFCUT NO-GAP,
              53 IT_IDR-ZFCLSEQ NO-GAP,
              68 IT_IDR-ZFQNT UNIT IT_IDR-ZFQNTM NO-GAP,
              85 IT_IDR-ZFQNTM NO-GAP, 132 IT_IDR-ZFIDWDT NO-GAP,
             142 '' NO-GAP.
      HIDE: IT_IDR.
    ENDIF.
  ENDIF.

ENDFORM.                    " P3000_WRITE_IDR_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_LO_IVIT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_LO_IVIT_DATA.

  CLEAR : TEMP_IVNO,
          TEMP_IVDNO.

  IF IT_RN-ZFREQTY  EQ 'LO' OR IT_RN-ZFREQTY EQ 'PU'.

    LOOP AT IT_IVIT WHERE ZFREQNO = IT_RN-ZFREQNO
                    AND   ZFITMNO = IT_RN-ZFITMNO.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
      IF TEMP_IVNO NE IT_IVIT-ZFIVNO.
        WRITE: /9 IT_IVIT-ZFIVNO NO-GAP, 21 IT_IVIT-TXZ01 NO-GAP,
               51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.

        HIDE: IT_IVIT.
      ELSEIF TEMP_IVDNO NE IT_IVIT-ZFIVDNO.
        WRITE: /, 21 IT_IVIT-TXZ01 NO-GAP,
               /51 IT_IVIT-ZFIVDNO NO-GAP,
               68 IT_IVIT-CCMENGE UNIT IT_IVIT-MEINS NO-GAP,
               85 IT_IVIT-MEINS NO-GAP, 142 '' NO-GAP.
        PERFORM P3000_WRITE_OTHER_DATA.      " ���/�԰���¸� ���.
        HIDE: IT_IVIT.
      ENDIF.
      TEMP_IVNO  = IT_IVIT-ZFIVNO.
      TEMP_IVDNO = IT_IVIT-ZFIVDNO.
*>> NHJ 2001.07.03 (�԰� TABLE DATA READ).
    LOOP  AT  IT_IN  WHERE  ZFIVNO  EQ  IT_IVIT-ZFIVNO
                     AND    ZFIVDNO EQ  IT_IVIT-ZFIVDNO.
       PERFORM  P3000_WRITE_IN_DATA.
    ENDLOOP.

*>>> �԰���°� 'Y'�̸�..
*      IF it_ivit-zfgrst EQ 'Y'.        " �԰���°� 'Y'�̸�..
*       FORMAT COLOR COL_TOTAL INTENSIFIED ON.
*       WRITE: /15 it_ivit-zfivno NO-GAP.
*       READ TABLE it_t001l WITH KEY lgort = it_ivit-lgort
*                                    werks = it_ivit-werks.
*       READ TABLE it_t001w WITH KEY werks = it_ivit-werks.
*       WRITE: 57 it_ivit-zfivdno NO-GAP,
*              68 it_ivit-grmenge UNIT it_ivit-meins NO-GAP,
*                 it_ivit-meins NO-GAP,
*              97 it_t001w-name1 NO-GAP, it_t001l-lgobe NO-GAP,
*            142 '' NO-GAP.
*      HIDE: it_ivit.
*     ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " P3000_WRITE_LO_IVIT_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IN_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_IN_DATA.

   SELECT  * INTO CORRESPONDING FIELDS OF TABLE IT_IN
   FROM    ZTIVHST  AS  A  INNER JOIN  ZTIVHSTIT  AS  B
   ON      A~ZFIVNO        EQ          B~ZFIVNO
   AND     A~ZFIVHST       EQ          B~ZFIVHST
   FOR     ALL  ENTRIES    IN          IT_IVIT
   WHERE   B~ZFIVNO        EQ          IT_IVIT-ZFIVNO
   AND     B~ZFIVDNO       EQ          IT_IVIT-ZFIVDNO
   AND     B~ZFGRST        EQ          'Y'.

ENDFORM.                    " P1000_READ_IN_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IN_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_IN_DATA.

   FORMAT COLOR COL_TOTAL INTENSIFIED ON.

   READ TABLE IT_T001L WITH KEY LGORT = IT_IN-LGORT
                                WERKS = IT_IN-WERKS.
   READ TABLE IT_T001W WITH KEY WERKS = IT_IN-WERKS.

   WRITE: /15  IT_IN-MBLNR     NO-GAP,
           68  IT_IN-GRMENGE   UNIT   IT_IN-MEINS NO-GAP,
               IT_IN-MEINS     NO-GAP,
           97  IT_T001W-NAME1  NO-GAP,
               IT_T001L-LGOBE  NO-GAP,
           142 ''              NO-GAP.
   HIDE: IT_IN.

ENDFORM.                    " P3000_WRITE_IN_DATA
