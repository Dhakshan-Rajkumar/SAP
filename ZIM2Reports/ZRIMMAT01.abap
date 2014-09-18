*&---------------------------------------------------------------------*
*& REPORT ZRIMMAT01                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ������� ��Ȳ                                         *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.26                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1. �����Ƿڰ� ���� ������ ��ǰ�� ������Ȳ�� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT ZRIMMATHIS NO STANDARD PAGE HEADING MESSAGE-ID ZIM.

*-----------------------------------------------------------------------
*  ��� TABLE DECLARE
*-----------------------------------------------------------------------
TABLES  : EKKO,                " ABAP Standard Header Table..
          EKPO,                " ABAP Standard Item Table..
          ZTREQHD,             " �����Ƿ� Header Table..
          ZTREQST,             " �����Ƿ� ���� Table..
          ZTREQIT,             " �����Ƿ� Item Table..
          ZTIV,                " Invoice Table..
          ZTIVIT,              " Invoice Item Table..
          ZTBL,                " B/L Table -ZTIVIT Table�� Item Table..
          LFA1,                " �ŷ�ó Master Table..
          ZTCUCL,              " ��� Table..
          ZTCUCLIV,            " ��� Invoice Table..
          ZTCUCLIVIT,          " ��� Invoice Item..
          ZTIDR,               " ���ԽŰ� Table..
          ZTIDS,               " ���Ը��� Table..
          EKET.                " ������ ���� Table..

*-----------------------------------------------------------------------
* INTERNAL TABLE & VARIABLE DECLARE
*--------------------------------------------------------------------

*------------------------------------------*
* P/O ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*------------------------------------------*

DATA: BEGIN OF IT_PO OCCURS 1000,          " Internal Table IT_PO..
        EBELN    LIKE   EKKO-EBELN,        " P/O Header No..
        BSART    LIKE   EKKO-BSART,        " Purchasing Document Type..
        LOEKZ    LIKE   EKKO-LOEKZ,        " Deletion indicator..
        ERNAM    LIKE   EKKO-ERNAM,        " Creator..
        LIFNR    LIKE   EKKO-LIFNR,        " Vendor's Account No..
        ZTERM    LIKE   EKKO-ZTERM,        " Terms of Payment Key..
        EKORG    LIKE   EKKO-EKORG,        " Purchasing Organization..
        EKGRP    LIKE   EKKO-EKGRP,        " Purchasing Group..
        WAERS    LIKE   EKKO-WAERS,        " Current Key..
        BEDAT    LIKE   EKKO-BEDAT,        " Purchasing Document Data..
        LLIEF    LIKE   EKKO-LLIEF,        " Supplying Vensor..
        INCO1    LIKE   EKKO-INCO1,        " Incoterms (Part1)..
        LIFRE    LIKE   EKKO-LIFRE,        " Difference Invoicing Party.
        EBELP    LIKE   EKPO-EBELP,        " P/O Item No..
        TXZ01    LIKE   EKPO-TXZ01,        " Short Text..
        MATNR    LIKE   EKPO-MATNR,        " Material No..
        WERKS    LIKE   EKPO-WERKS,        " Plant..
        LGORT    LIKE   EKPO-LGORT,        " Storage Location..
        MENGE    LIKE   EKPO-MENGE,        " Purchase Order Quantity..
        MEINS    LIKE   EKPO-MEINS,        " Order Unit..
        BPRME    LIKE   EKPO-BPRME,        " Order Price Unit..
        NETPR    LIKE   EKPO-NETPR,        " Net Price..
        PEINH    LIKE   EKPO-PEINH,        " Price Unit..
        ELIKZ    LIKE   EKPO-ELIKZ,        " Delivery Comience Indicator

      END OF IT_PO.

*-----------------------------------------------*
* �����Ƿ� ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*-----------------------------------------------*

DATA: BEGIN OF IT_RN OCCURS 1000,          " REQNO��ȸ����IT����.
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ.
        ZFREQTY   LIKE   ZTREQHD-ZFREQTY,  " �����Ƿ� Type.
        EBELN     LIKE   ZTREQHD-EBELN,    " Purchasing Document Number.
        LIFNR     LIKE   ZTREQHD-LIFNR,    " Vendor's Account Number.
        LLIEF     LIKE   ZTREQHD-LLIEF,    " Supplying Vendor.
        ZFBENI    LIKE   ZTREQHD-ZFBENI,   " Different Invoicing Party.
        ZTERM     LIKE   ZTREQHD-ZTERM,    " Terms of Payment Key.
        INCO1     LIKE   ZTREQHD-INCO1,    " Incoterms (Part1).
        ZFLASTAM  LIKE   ZTREQHD-ZFLASTAM, " ���������ݾ�.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFUSDAM   LIKE   ZTREQHD-ZFUSDAM,  " USD ȯ��ݾ�.
        ZFMATGB   LIKE   ZTREQHD-ZFMATGB,  " ���籸��.
        ZFUSD     LIKE   ZTREQHD-ZFUSD,    " ��ȭ��ȭ.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ���Թ��� ǰ���ȣ.
        MATNR     LIKE   ZTREQIT-MATNR,    " Material Number.
        STAWN     LIKE   ZTREQIT-STAWN,    " Commodity Code.
        MENGE     LIKE   ZTREQIT-MENGE,    " �����Ƿڼ���.
        MEINS     LIKE   ZTREQIT-MEINS,    " Base Unit of Measure.
        NETPR     LIKE   ZTREQIT-NETPR,    " Net Price.
        PEINH     LIKE   ZTREQIT-PEINH,    " Price Unit.
        BPRME     LIKE   ZTREQIT-BPRME,    " Order Price Unit.
        TXZ01     LIKE   ZTREQIT-TXZ01,    " Short Text.
        ZFAMDNO   LIKE   ZTREQST-ZFAMDNO,  " Amend Seq.
        ZFDOCST   LIKE   ZTREQST-ZFDOCST,  " ���� ����.
        ZFRTNYN   LIKE   ZTREQST-ZFRTNYN,  " ���� �ݷ� ����.
        ZFRLST1   LIKE   ZTREQST-ZFRLST1,  " �Ƿ� Release ����.
        ZFRLST2   LIKE   ZTREQST-ZFRLST2,  " ���� Release ����.
        CDAT      LIKE   ZTREQST-CDAT,     " Created on.
        ZFREQDT   LIKE   ZTREQST-ZFREQDT,  " �䰳������.
        ERNAM     LIKE   ZTREQST-ERNAM,    " Creater.
        EKORG     LIKE   ZTREQST-EKORG,    " Purch. Org.
        EKGRP     LIKE   ZTREQST-EKGRP,    " Purch. Grp.
        ZFOPNNO   LIKE   ZTREQST-ZFOPNNO,  " �ſ���-���ι�ȣ.
        ZFOPAMT   LIKE   ZTREQST-ZFOPAMT,  " ���� �ݾ�.
      END OF IT_RN.

*-----------------------------------------------*
* INVOICE ��ȣ ��ȸ�� ���� INTERNAL TABLE ����. *
*-----------------------------------------------*

DATA: BEGIN OF IT_IV OCCURS 1000,
        ZFIVNO    LIKE   ZTIV-ZFIVNO,      " Invoice ������ȣ.
*        ZFREQNO   LIKE   ZTIV-ZFREQNO,     " �����Ƿ� ������ȣ.
        ZFBLNO    LIKE   ZTIV-ZFBLNO,      " B/L ������ȣ.
*        ZFCIVNO   LIKE   ZTIV-ZFCIVNO,     " Commercial Invoice No.
*        ZFIVPDT   LIKE   ZTIV-ZFIVPDT,     " I/V Posting Date.
*        ZFIVDDT   LIKE   ZTIV-ZFIVDDT,     " I/V Document Date.
*        ZFGRPDT   LIKE   ZTIV-ZFGRPDT,     " G/R Posting Date.
*        ZFGRDDT   LIKE   ZTIV-ZFGRDDT,     " G/R Document Date.
        ZFCUST    LIKE   ZTIV-ZFCUST,      " �������.
        ZFCDST    LIKE   ZTIV-ZFCDST,      " ����� ����.
*        ZFIVST    LIKE   ZTIV-ZFIVST,      " Invoice Verify ����.
        ZFGRST    LIKE   ZTIV-ZFGRST,      " Good Receipt ����.
*        ZFPAYYN   LIKE   ZTIV-ZFPAYYN,     " Payment ����.
*        ZFGFDYR   LIKE   ZTIV-ZFGFDYR,     " ���� ȸ����ǥ����.
*        ZFGFDNO   LIKE   ZTIV-ZFGFDNO,     " ���� ȸ����ǥ��ȣ.
*        ZFCFDYR   LIKE   ZTIV-ZFCFDYR,     " ��������� ȸ����ǥ ����.
*        ZFCFDNO   LIKE   ZTIV-ZFCFDNO,     " ��������� ȸ����ǥ ��ȣ.
*        ZFMDYR    LIKE   ZTIV-ZFMDYR,      " ���繮�� ����.
*        ZFMDNO    LIKE   ZTIV-ZFMDNO,      " ���繮�� ��ȣ.
        ZFIVDNO   LIKE   ZTIVIT-ZFIVDNO,   " Invoice �Ϸù�ȣ.
        MATNR     LIKE   ZTIVIT-MATNR,     " Material Number.
*        MENGE     LIKE   ZTIVIT-MENGE,     " �����Ƿ� ����.
*        ZFPRQN    LIKE   ZTIVIT-ZFPRQN,    " Invoice ó����?
        MEINS     LIKE   ZTIVIT-MEINS,     " Base Unit of Measure.
        NETPR     LIKE   ZTIVIT-NETPR,     " Net Price.
        PEINH     LIKE   ZTIVIT-PEINH,     " Price Unit.
        BPRME     LIKE   ZTIVIT-BPRME,     " Order Price Unit.
        TXZ01     LIKE   ZTIVIT-TXZ01,     " Short Text.
        ZFIVAMT   LIKE   ZTIVIT-ZFIVAMT,   " Invoice �ݾ�.
*        ZFIVAMP   LIKE   ZTIVIT-ZFIVAMP,   " Invoice ó���ݾ�.
        ZFIVAMC   LIKE   ZTIVIT-ZFIVAMC,   " Invoice �ݾ� ��ȭ.
        ZFIVAMK   LIKE   ZTIVIT-ZFIVAMK,   " Invoice �ݾ�(��ȭ).
      END OF IT_IV.

*-----------------------------------------------------------------------
* B/L ��ȣ ��ȸ�� ���� Internal Table Declaration.
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_BL OCCURS 1000,
        ZFBLNO    LIKE   ZTBL-ZFBLNO,      " B/L ���� ��ȣ.
        KOSTL     LIKE   ZTBL-KOSTL,       " Cost Center.
        ZFHBLNO   LIKE   ZTBL-ZFHBLNO,     " House B/L No.
        ZFMBLNO   LIKE   ZTBL-ZFMBLNO,     " Master B/L No.
        ZFREBELN  LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O No.
        EKORG     LIKE   ZTBL-EKORG,       " Purchasing Organization.
        EKGRP     LIKE   ZTBL-EKGRP,       " Purchasing Group.
        LIFNR     LIKE   ZTBL-LIFNR,       " Account No.
        ZFOPNNO   LIKE   ZTBL-ZFOPNNO,     " �ſ���-���ι�ȣ.
        ZFETD     LIKE   ZTBL-ZFETD,       " ������(ETA).
        ZFETA     LIKE   ZTBL-ZFETA,       " ������(ETD).
        ZFRGDSR   LIKE   ZTBL-ZFRGDSR,     " ��ǥǰ��.
        ZFSPRTC   LIKE   ZTBL-ZFSPRTC,     " ������ �ڵ�.
        ZFSPRT    LIKE   ZTBL-ZFSPRT,      " ������.
        ZFAPPC    LIKE   ZTBL-ZFAPPC,      " �������� �ڵ�.
        ZFAPRTC   LIKE   ZTBL-ZFAPRTC,     " ������ �ڵ�.
        ZFAPRT    LIKE   ZTBL-ZFAPRT,      " ������.
        ZFNEWT    LIKE   ZTBL-ZFNEWT,      " ���߷�.
        ZFNEWTM   LIKE   ZTBL-ZFNEWTM,     " ���߷� ����.
        ZFTOWT    LIKE   ZTBL-ZFTOWT,      " ���߷�.
        ZFBLAMT   LIKE   ZTBL-ZFBLAMT,     " B/L �ݾ�.
        ZFBLAMC   LIKE   ZTBL-ZFBLAMC,     " B/L �ݾ� ��ȭ.
        ZFBLDT    LIKE   ZTBL-ZFBLDT,      " B/L ������.
        ZFBLADT   LIKE   ZTBL-ZFBLADT,     " B/L �Լ���.
        ZFBLSDT   LIKE   ZTBL-ZFBLSDT,     " B/L �ۺ���.
      END OF IT_BL.

*-----------------------------------------------------------------------
* B/L�� Invoice ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_TEMP OCCURS 1000,
        ZFBLNO    LIKE   ZTIV-ZFBLNO,
      END OF IT_TEMP.

*-----------------------------------------------------------------------
* �����ȸInvoice ��ȸ�� ���� Internal Table ����...
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
* ���ԽŰ���ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_CUCL OCCURS 1000.
      INCLUDE STRUCTURE ZTCUCL.
DATA  END OF IT_CUCL.

*-----------------------------------------------------------------------
* ���ԽŰ���ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_IDR OCCURS 1000.
      INCLUDE STRUCTURE ZTIDR.
DATA  END OF IT_IDR.

*-----------------------------------------------------------------------
* ���Ը�����ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_IDS OCCURS 1000.
        INCLUDE STRUCTURE ZTIDS.
DATA: END OF IT_IDS.

DATA: W_TABIX    LIKE SY-TABIX,
      W_BEWTP    LIKE EKBE-BEWTP,
      W_ERR_CHK  TYPE C,
      W_PAGE     TYPE I,
      COUNT      TYPE I.

*-----------------------------------------------------------------------
* HIDE VARIABLE.
*-----------------------------------------------------------------------

DATA: BEGIN OF DOCU,
        TYPE(2)   TYPE C,
        CODE      LIKE EKKO-EBELN,
        ITMNO     LIKE EKPO-EBELP,
        YEAR      LIKE BKPF-GJAHR,
      END OF DOCU.

*----------------------------------------------------*
* GOOD RECEIPT DATA ��ȸ�� ���� INTERNAL TABLE ����. *
*----------------------------------------------------*

DATA: BEGIN OF IT_GR OCCURS 0 ,
        ZFIVNO    LIKE   ZTIV-ZFIVNO,      " Invoice ������ȣ.
*        ZFREQNO   LIKE   ZTIV-ZFREQNO,   " �����Ƿ� ������ȣ.
        ZFBLNO    LIKE   ZTIV-ZFBLNO,      " B/L ������ȣ.

      END OF IT_GR.


*-----------------------------------------------------------------------
* �˻����� WINDOW CREATE
*--------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_EBELN   FOR EKKO-EBELN,       " P/O No.
               S_MATNR   FOR EKPO-MATNR,       " ���� No.
               S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� No.
               S_LIFNR   FOR ZTREQHD-LIFNR,    " Vendor.
               S_MATGB   FOR ZTREQHD-ZFMATGB,  " ���籸��..
               S_REQTY   FOR ZTREQHD-ZFREQTY,  " �����Ƿ� Type
               S_EKORG   FOR ZTREQST-EKORG,    " Purch. Org.
               S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
               S_WERKS   FOR EKPO-WERKS.       " Plant
PARAMETERS :   P_NAME    LIKE USR02-BNAME.     " �����..

SELECT-OPTIONS:
               S_DOCST   FOR ZTREQST-ZFDOCST.  " ��������..

  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(14) TEXT-002, POSITION 33.
     PARAMETERS : P_YN    AS CHECKBOX.              " ������?
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK B1.

*-----------------------------------------------------------------------
* TITLE BAR SETTING
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'ZIMR40'.

*-----------------------------------------------------------------------
* SELECT �����....
*-----------------------------------------------------------------------
START-OF-SELECTION.

* �����Ƿ� No.
   PERFORM P1000_READ_RN_DATA USING W_ERR_CHK.
   CHECK W_ERR_CHK NE 'Y'.

* Invoice No..
   PERFORM P1000_READ_IV_DATA.

* B/L Table Select..
   PERFORM P1000_READ_BL_DATA.

* ��� Table Select..
   PERFORM P1000_READ_CUCL_DATA.

* ��� Invoice Table Select..
   PERFORM P1000_READ_CUCLIV_DATA.

* ���ԽŰ� Table Select..
   PERFORM P1000_READ_ZFIDR_DATA.

* ���Ը��� Table Select..
   PERFORM P1000_READ_ZFIDS_DATA.

IF  P_YN = 'N%'.

* ����ǰ ��ȸ�� ����ǰ DATA READ.
    PERFORM P1000_READ_GR_DATA.

* DATA READ �Ͽ��� �����Ƿ�, BL����, ����������� ����.
    LOOP  AT  IT_GR.

* DATA READ �Ͽ��� �����Ƿ��������� �����Ƿ� ��ȣ�� ���� �ڷ� ����.
*      READ  TABLE IT_RN
*      WITH KEY ZFREQNO = IT_GR-ZFREQNO.

      IF  SY-SUBRC  =  0 .
          W_TABIX   =  SY-TABIX.
          DELETE IT_RN INDEX W_TABIX.
      ENDIF.

      READ  TABLE IT_BL  WITH KEY ZFBLNO = IT_GR-ZFBLNO.

      IF  SY-SUBRC  =  0 .
          W_TABIX   =  SY-TABIX.
          DELETE IT_BL INDEX W_TABIX.
      ENDIF.


    ENDLOOP.

ENDIF.

* PO TABLE SELECT.
   PERFORM P1000_READ_PO_TABLE.

*-----------------------------------------------------------------------
* SELECT �����Ŀ�....
*-----------------------------------------------------------------------
END-OF-SELECTION.

* Title Text Write.
   SET TITLEBAR 'ZIMR40'.
   SET PF-STATUS 'ZIMR40'.

* Sort P/O, Request No. Internal Table.
   PERFORM P2000_SORT_IT_DATA.

*-----------------------------------------------------------------------
* DEFINE �� COMMAND �����.
*-----------------------------------------------------------------------
AT USER-COMMAND.

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
*       �����Ƿڳ��� & �����Ƿ� ITEM ������ ��ȸ�Ѵ�.
*----------------------------------------------------------------------*
FORM P1000_READ_RN_DATA USING W_ERR_CHECK.

   DATA L_LINE_COUNT TYPE I.

   W_ERR_CHK = 'N'.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_RN
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO
     AND    H~EBELN    IN  S_EBELN
     AND    I~MATNR    IN  S_MATNR
     AND    H~LIFNR    IN  S_LIFNR
     AND    H~ZFMATGB  IN  S_MATGB
     AND    H~ZFREQTY  IN  S_REQTY
     AND    H~ZFWERKS  IN  S_WERKS.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

   CONCATENATE P_NAME '%' INTO P_NAME.

   LOOP AT IT_RN.

     W_TABIX = SY-TABIX.

     SELECT SINGLE ZFAMDNO ZFDOCST ZFRLST1 ZFRLST2 CDAT EKORG
                   EKGRP ZFOPNNO WAERS
              INTO (IT_RN-ZFAMDNO, IT_RN-ZFDOCST, IT_RN-ZFRLST1,
              IT_RN-ZFRLST2, IT_RN-CDAT, IT_RN-EKORG, IT_RN-EKGRP,
              IT_RN-ZFOPNNO, IT_RN-WAERS)
              FROM ZTREQST
              WHERE ZFREQNO EQ   IT_RN-ZFREQNO
              AND   EKORG   IN   S_EKORG
              AND   EKGRP   IN   S_EKGRP
              AND   ZFDOCST IN   S_DOCST
              AND   ERNAM   LIKE P_NAME
              AND   ZFAMDNO EQ ( SELECT MAX( ZFAMDNO ) FROM ZTREQST
                                 WHERE ZFREQNO EQ IT_RN-ZFREQNO ).
     IF SY-SUBRC = 0.
        MODIFY IT_RN INDEX W_TABIX.
     ELSE.
        DELETE IT_RN INDEX W_TABIX.
     ENDIF.

   ENDLOOP.

   DESCRIBE TABLE IT_RN LINES L_LINE_COUNT.
   IF L_LINE_COUNT = 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_RN_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_PO_TABLE
*&---------------------------------------------------------------------*
* �����Ƿڰǿ� ���ؼ��� PO TABLE SELECT.
*----------------------------------------------------------------------*
FORM P1000_READ_PO_TABLE.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_PO
     FROM   EKKO AS H INNER JOIN EKPO AS I
     ON     H~EBELN EQ I~EBELN
     FOR ALL ENTRIES IN IT_RN
     WHERE  H~EBELN EQ IT_RN-EBELN
     AND    I~EBELP EQ IT_RN-ZFITMNO.

ENDFORM.                    " P1000_READ_PO_TABLE

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IV_DATA
*&---------------------------------------------------------------------*
*     ���ǿ� �ش��ϴ� INVOICE TABLE SELECT.
*----------------------------------------------------------------------*
FORM P1000_READ_IV_DATA.

IF  P_YN = 'X'.
    P_YN = '%'.
ELSE.
    P_YN = 'N%'.
ENDIF.

*SELECT *
*     INTO CORRESPONDING FIELDS OF TABLE IT_IV
*     FROM   ZTIV AS H INNER JOIN ZTIVIT AS I
*     ON     H~ZFIVNO   EQ   I~ZFIVNO
*     WHERE  H~ZFREQNO  IN   S_REQNO
*     AND    I~MATNR    IN   S_MATNR
*     AND    H~ZFGRST   LIKE P_YN      .

ENDFORM.                    " P1000_READ_IV_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_BL_DATA
*&---------------------------------------------------------------------*
*       �ش� �ϴ� ������ BL DATA SELECT.
*----------------------------------------------------------------------*
FORM P1000_READ_BL_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_BL
     FROM   ZTBL
     FOR ALL ENTRIES IN IT_IV
     WHERE  ZFBLNO EQ IT_IV-ZFBLNO.

ENDFORM.                    " P1000_READ_BL_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_CUCL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_CUCL_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_CUCL FROM ZTIDS
     FOR ALL ENTRIES IN IT_CUCL
     WHERE ZFBLNO EQ IT_CUCL-ZFBLNO.

ENDFORM.                    " P1000_READ_CUCL_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_CUCLIV_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_CUCLIV_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_CUCLIV
     FROM ZTCUCLIV AS H INNER JOIN ZTCUCLIVIT AS I
     ON     H~ZFIVNO EQ I~ZFIVNO.


ENDFORM.                    " P1000_READ_CUCLIV_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ZFIDR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_ZFIDR_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_IDR FROM ZTIDR
     FOR ALL ENTRIES IN IT_IDR
     WHERE ZFBLNO EQ IT_IDR-ZFBLNO.

ENDFORM.                    " P1000_READ_ZFIDR_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ZFIDS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_ZFIDS_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_IDS FROM ZTIDS
     FOR ALL ENTRIES IN IT_IDS
     WHERE ZFBLNO EQ IT_IDS-ZFBLNO.

ENDFORM.                    " P1000_READ_ZFIDS_DATA

*&---------------------------------------------------------------------*
*&      Form  P2000_SORT_IT_DATA
*&---------------------------------------------------------------------*
*       PO TABLE, �����Ƿ� TABLE �����ȣ, PO NO, REQ NO ������.
*----------------------------------------------------------------------*
FORM P2000_SORT_IT_DATA.

   SORT IT_PO BY EBELP EBELN .
   SORT IT_RN BY ZFITMNO EBELN  ZFREQNO.

ENDFORM.                    " P2000_SORT_IT_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_GR_DATA
*&---------------------------------------------------------------------*
*       GOOD RECEIPT �� ������ �ڷ� SELECT.
*----------------------------------------------------------------------*
FORM P1000_READ_GR_DATA.

*SELECT H~ZFIVNO  H~ZFREQNO  H~ZFBLNO
*     INTO CORRESPONDING FIELDS OF TABLE IT_GR
*     FROM   ZTIV AS H INNER JOIN ZTIVIT AS I
*     ON     H~ZFIVNO   EQ   I~ZFIVNO
*     WHERE  H~ZFREQNO  IN   S_REQNO
*     AND    I~MATNR    IN   S_MATNR
*     AND    H~ZFGRST   =    'Y'    .


ENDFORM.                    " P1000_READ_GR_DATA
