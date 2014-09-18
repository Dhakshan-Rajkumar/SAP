*&---------------------------------------------------------------------*
*& Report  ZRIMLCLST                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �ŷ���������.                                         *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.02                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMLCLST NO STANDARD PAGE HEADING MESSAGE-ID ZIM
                  LINE-SIZE 187.

TABLES: EKKO,                " ABAP Standard Header Table..
        EKPO,                " ABAP Standard Item Table..
        EKET,                " ��ǰ��������� ��������..
        ZTREQHD,             " �����Ƿ� Header Table..
        LFA1,                " �ŷ�ó Master Table..
        ZTREQORJ,            " �����Ƿ� ������ Table..
        ZTREQST,             " �����Ƿ� ���� Table..
        ZTREQIT,             " �����Ƿ� Item Table..
        ZTMLCHD.             " Master L/C Header..

*------------------------------------------*
* P/O ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*------------------------------------------*

DATA: BEGIN OF IT_PO OCCURS 1000,          " Internal Table IT_PO..
        EBELN    LIKE   EKKO-EBELN,        " P/O Header No..
        BSART    LIKE   EKKO-BSART,        " Purchasing Document Type..
        LOEKZ    LIKE   EKKO-LOEKZ,        " Deletion indicator..
        LIFNR    LIKE   EKKO-LIFNR,        " Vendor's Account No..
        EKORG    LIKE   EKKO-EKORG,        " Purchasing Organization..
        EKGRP    LIKE   EKKO-EKGRP,        " Purchasing Group..
        WAERS    LIKE   EKKO-WAERS,        " Current Key..
        EBELP    LIKE   EKPO-EBELP,        " P/O Item No..
        TXZ01    LIKE   EKPO-TXZ01,        " Short Text..
        MATNR    LIKE   EKPO-MATNR,        " Material No..
        MENGE    LIKE   EKPO-MENGE,        " Purchase Order Quantity..
        MEINS    LIKE   EKPO-MEINS,        " Order Unit..
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
        ZFREQSD   LIKE   ZTREQHD-ZFREQSD,  " ����������.
        ZFLASTAM  LIKE   ZTREQHD-ZFLASTAM, " ���������ݾ�.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFUSDAM   LIKE   ZTREQHD-ZFUSDAM,  " USD ȯ��ݾ�.
        ZFMATGB   LIKE   ZTREQHD-ZFMATGB,  " ���籸��.
        ZFUSD     LIKE   ZTREQHD-ZFUSD,    " ��ȭ��ȭ.
        ZFAPRT    LIKE   ZTREQHD-ZFAPRT,   " ������.
        BUKRS     LIKE   ZTREQHD-BUKRS,    " ȸ���ڵ�.
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
        ZFREF1    LIKE   ZTREQST-ZFREF1,   " ��������-��������.
        ZFREF2    LIKE   ZTREQST-ZFREF2,   " ��������-��������.
      END OF IT_RN.

*-----------------------------------------------------------------------
* Master L/C Data ��ȸ�� ���� Internal Table ����.
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_MRN OCCURS 1000.
      INCLUDE STRUCTURE ZTMLCHD.
DATA  END OF IT_MRN.

*-----------------------------------------------------------------------
* �����Ƿ� ������ ��ȸ�� ���� Internal Table ����.
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_ORJ OCCURS 1000.
      INCLUDE STRUCTURE ZTREQORJ.
DATA  END OF IT_ORJ.

*-----------------------------------------------------------------------
* Vendor Master Data ��ȸ�� ���� Internal Table ����.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_VD OCCURS 1000.
      INCLUDE STRUCTURE LFA1.
DATA  END OF IT_VD.

*-----------------------------------------------------------------------
* Error Check �� Table Index ������ ���� ���� ����.
*-----------------------------------------------------------------------
DATA: W_ERR_CHK   TYPE  C,
      W_TABIX     TYPE  I.

*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_BUKRS   FOR ZTREQHD-BUKRS,    " ȸ���ڵ�.
               S_MATNR   FOR EKPO-MATNR,       " ���� No.
               S_EBELN   FOR EKKO-EBELN,       " P/O No.
               S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� No.
               S_OPNNO   FOR ZTREQHD-ZFOPNNO,  " L/C No.
               S_EKORG   FOR ZTREQST-EKORG,    " Purch. Org.
               S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
               S_REQTY   FOR ZTREQHD-ZFREQTY,  " �����Ƿ� Type.
               S_DOCST   FOR ZTREQST-ZFDOCST DEFAULT 'O'.  " ��������.
SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.

*-----------------------------------------------------------------------
* TOP-OF-PAGE.
*-----------------------------------------------------------------------
TOP-OF-PAGE.

   PERFORM P3000_TITLE_WRITE.             "��� ���...

*-----------------------------------------------------------------------
* Start-Of-Selection
*-----------------------------------------------------------------------
START-OF-SELECTION.

   PERFORM P1000_READ_DATA.

   IF W_ERR_CHK EQ 'Y'.
      EXIT.
   ENDIF.

*-----------------------------------------------------------------------
* End-Of-Selection
*-----------------------------------------------------------------------
END-OF-SELECTION.

* Title Text Write.
   SET TITLEBAR 'TIT1'.
*   SET PF-STATUS 'ZIM92'.

* List Write...
   PERFORM P3000_WRITE_LC_DATA.           "��� ���...

*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT LINE-SELECTION.

DATA : L_TEXT(20).

  GET CURSOR FIELD L_TEXT.
  CASE L_TEXT.   " �ʵ��..

    WHEN 'IT_RN-EBELN'.
       SET PARAMETER ID 'BES'  FIELD IT_RN-EBELN.
       CALL TRANSACTION 'ME23' AND SKIP FIRST SCREEN.

    WHEN 'IT_RN-ZFREQNO'.
       SET PARAMETER ID 'ZPREQNO' FIELD IT_RN-ZFREQNO.
       CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_RN.

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

   SKIP 2.
   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
   WRITE: /70 '[ �� �� �� �� �� �� ]'
              COLOR COL_HEADING INTENSIFIED OFF.

   FORMAT RESET.
   WRITE: / 'Date: ', SY-DATUM.
   ULINE.

*>>> Field Name�� Title�� ������ش�.
   FORMAT COLOR COL_HEADING INTENSIFIED ON.
   WRITE: /  SY-VLINE NO-GAP, '�����ȣ          ' NO-GAP,
             SY-VLINE NO-GAP,
            'ǰ��                                    ' NO-GAP,
             SY-VLINE NO-GAP, '���ſ���No' NO-GAP,
             SY-VLINE NO-GAP, 'ǰ�� ' NO-GAP,
             SY-VLINE NO-GAP, '�����Ƿ�No' NO-GAP,
             SY-VLINE NO-GAP, 'S/D       ' NO-GAP,
             SY-VLINE NO-GAP, '��ǰ��    ' NO-GAP,
             SY-VLINE NO-GAP, '����             ' NO-GAP,
             SY-VLINE NO-GAP, '�ܰ�            ' NO-GAP,
             SY-VLINE NO-GAP, 'ORJ' NO-GAP,
             SY-VLINE NO-GAP, '����ó�ڵ�' NO-GAP,
             SY-VLINE NO-GAP, '���޻�                   ' NO-GAP,
             SY-VLINE NO-GAP.

   FORMAT COLOR COL_HEADING INTENSIFIED OFF.

    WRITE:  / SY-VLINE NO-GAP, '�𼱸�            ' NO-GAP,
              SY-VLINE NO-GAP, '������' NO-GAP,
           61 SY-VLINE NO-GAP, '��������1' NO-GAP,
          129 SY-VLINE NO-GAP, '��������2' NO-GAP,
          187 SY-VLINE NO-GAP.
   FORMAT RESET.
   ULINE.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA.

   PERFORM P1000_READ_RN_DATA.
   PERFORM P1000_READ_PO_DATA.
   PERFORM P1000_READ_ORJ_DATA.
   PERFORM P1000_READ_VD_DATA.

   IF W_ERR_CHK EQ 'Y'.
      EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_LC_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_LC_DATA.

PERFORM P2000_SORT_IT_DATA.

LOOP AT IT_RN.

   READ TABLE IT_PO  WITH KEY EBELN = IT_RN-EBELN.

   SELECT * FROM  EKET UP TO 1 ROWS
            WHERE EBELN EQ IT_PO-EBELN
            AND   EBELP EQ IT_PO-EBELP
            ORDER BY EINDT.
      EXIT.
   ENDSELECT.

   READ TABLE IT_ORJ WITH KEY ZFREQNO = IT_RN-ZFREQNO.
   READ TABLE IT_VD  WITH KEY LIFNR = IT_PO-LIFNR.

   FORMAT COLOR COL_NORMAL INTENSIFIED ON.

*>>> �����ȣ�� Write �ϱ� ���� Logic.
   WRITE: SY-VLINE NO-GAP, IT_RN-MATNR NO-GAP.

*>>> ǰ���� ����ϱ� ���� Logic.
   WRITE: SY-VLINE NO-GAP, IT_RN-TXZ01 NO-GAP.

*>>> ���ſ�����ȣ�� ����ϱ� ���� Logic.
   WRITE: SY-VLINE NO-GAP, IT_RN-EBELN NO-GAP.
   WRITE: SY-VLINE NO-GAP, IT_RN-ZFITMNO NO-GAP.

   WRITE:    SY-VLINE NO-GAP, IT_RN-ZFREQNO NO-GAP,
             SY-VLINE NO-GAP, IT_RN-ZFREQSD NO-GAP,
             SY-VLINE NO-GAP, EKET-EINDT NO-GAP,
             SY-VLINE NO-GAP, IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP,
             SY-VLINE NO-GAP, IT_RN-NETPR CURRENCY IT_PO-WAERS NO-GAP,
             SY-VLINE NO-GAP, IT_ORJ-ZFORIG NO-GAP,
             SY-VLINE NO-GAP, IT_PO-LIFNR NO-GAP,
             SY-VLINE NO-GAP, IT_VD-NAME1(25) NO-GAP,
             SY-VLINE NO-GAP.
      HIDE: IT_RN.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

   WRITE: / SY-VLINE NO-GAP, '                  ' NO-GAP,
            SY-VLINE NO-GAP, IT_RN-ZFAPRT NO-GAP,
         61 SY-VLINE NO-GAP, IT_RN-ZFREF1(67) NO-GAP,
            SY-VLINE NO-GAP, IT_RN-ZFREF2(57) NO-GAP,
        187 SY-VLINE.
   FORMAT RESET.
      HIDE: IT_RN.

   W_TABIX = W_TABIX + 1.

      CLEAR: IT_RN.
   ULINE.
ENDLOOP.

   WRITE: '��:', W_TABIX, '��'.

ENDFORM.                    " P3000_WEITE_LC_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_PO_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_PO_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_PO
     FROM   EKKO AS H INNER JOIN EKPO AS I
     ON     H~EBELN EQ I~EBELN
            FOR ALL ENTRIES IN IT_RN
     WHERE  H~EBELN EQ IT_RN-EBELN
     AND    I~EBELP EQ IT_RN-ZFITMNO
     AND    H~BSTYP EQ 'F'.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
   EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_PO_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_RN_DATA.

   DATA: L_LINE_COUNT TYPE I.

   W_ERR_CHK = 'N'.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_RN
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO
     AND    H~EBELN    IN  S_EBELN
     AND    I~MATNR    IN  S_MATNR
     AND    H~ZFREQTY  IN  S_REQTY
     AND    H~ZFOPNNO  IN  S_OPNNO.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

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
*&      Form  P1000_READ_MLC_DATA
*&---------------------------------------------------------------------*
*       Master LC Data�� ������� ���� �����ƾ.
*----------------------------------------------------------------------*
FORM P1000_READ_MLC_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MRN
            FROM ZTMLCHD
            FOR ALL ENTRIES IN IT_RN
            WHERE ZFREQNO   EQ  IT_RN-ZFREQNO.
      IF SY-SUBRC NE 0.
         W_ERR_CHK = 'Y'.
         MESSAGE S353.
         EXIT.
      ENDIF.

ENDFORM.                    " P1000_READ_MLC_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ORJ_DATA
*&---------------------------------------------------------------------*
*  ���������� ����Ÿ�� ������� ���� �����ƾ.
*----------------------------------------------------------------------*
FORM P1000_READ_ORJ_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ORJ
            FROM ZTREQORJ
            FOR ALL ENTRIES IN IT_RN
           WHERE ZFREQNO   EQ   IT_RN-ZFREQNO
             AND ZFLSG7O   EQ   '00010'.

ENDFORM.                    " P1000_READ_ORJ_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_VD_DATA
*&---------------------------------------------------------------------*
*  Vendor Master ���̺� �����͸� �б� ���� �����ƾ.
*----------------------------------------------------------------------*
FORM P1000_READ_VD_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_VD
            FROM LFA1
            FOR ALL ENTRIES IN IT_PO
            WHERE LIFNR   EQ   IT_PO-LIFNR.

ENDFORM.                    " P1000_READ_VD_DATA
*&---------------------------------------------------------------------*
*&      Form  P2000_SORT_IT_DATA
*&---------------------------------------------------------------------*
* Internal Table�� ������ �׸񺰷� ����.
*----------------------------------------------------------------------*
FORM P2000_SORT_IT_DATA.

   SORT IT_RN BY TXZ01 EBELN ZFITMNO ZFREQNO.

ENDFORM.                    " P2000_SORT_IT_DATA
