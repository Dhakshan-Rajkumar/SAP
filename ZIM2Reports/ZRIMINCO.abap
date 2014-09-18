*&---------------------------------------------------------------------*
*& Report  ZRIMINCO                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���纰 �ŷ� ���� ��Ȳ                                 *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.02.15                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1.
*&
*&---------------------------------------------------------------------*
*& ���泻�� :
*&---------------------------------------------------------------------*

REPORT  ZRIMINCO  NO STANDARD PAGE HEADING MESSAGE-ID ZIM
                  LINE-SIZE 173.

TABLES: EKKO,                " ABAP Standard Header Table..
        EKPO,                " ABAP Standard Item Table..
        T001W,               " PLANT TEXT
        EKET,                " ��ǰ��������� ��������..
        ZTREQHD,             " �����Ƿ� Header Table..
        LFA1,                " �ŷ�ó Master Table..
        ZTREQORJ,            " �����Ƿ� ������ Table..
        ZTREQST,             " �����Ƿ� ���� Table..
        ZTREQIT,             " �����Ƿ� Item Table..
        ZTMLCHD,             " Master L/C Header..
        ZTMSIT.
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
DATA: BEGIN OF IT_TAB OCCURS 1000,          " REQNO��ȸ����IT����.
        EBELN     LIKE   ZTREQIT-EBELN,
        EBELP     LIKE   ZTREQIT-EBELP,
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ITEM NO.
        ZFWERKS   LIKE   ZTREQHD-ZFWERKS,  " �÷�Ʈ.
        NAME1(20) TYPE   C,
        MATNR     LIKE   ZTREQIT-MATNR,
        TXZ01     LIKE   ZTREQIT-TXZ01,
        ZFTRANS   LIKE   ZTREQHD-ZFTRANS,
        TRANS_NM(9) TYPE C,
        INCO1     LIKE   ZTREQHD-INCO1,
        MENGE     LIKE   ZTREQIT-MENGE,
        MEINS     LIKE   ZTREQIT-MEINS,
        ZFAMT     LIKE   ZTREQHD-ZFOPAMT,
        NETPR     LIKE   ZTREQIT-NETPR,
        WAERS     LIKE   ZTREQHD-WAERS,
      END OF IT_TAB.

*-----------------------------------------------------------------------
* Error Check �� Table Index ������ ���� ���� ����.
*-----------------------------------------------------------------------
DATA: W_ERR_CHK   TYPE  C,
      W_TABIX     TYPE  I.

DATA: W_COUNT     TYPE  I,
      W_PAGE      TYPE  I,
      W_LINE      TYPE  I,
      W_MOD       TYPE  I,
      W_FIELD_NM  TYPE  DD03D-FIELDNAME.

*>>> Sort�� ���� ���� �� FORM Include.
INCLUDE ZRIMSORTCOM.

*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_MATGB   FOR ZTREQHD-ZFMATGB,  " ���籸��.
               S_WERKS   FOR ZTREQHD-ZFWERKS,  " �÷�Ʈ,
               S_MATNR   FOR EKPO-MATNR,       " ���� No.
               S_EBELN   FOR EKKO-EBELN,       " P/O No.
               S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� No.
               S_OPNNO   FOR ZTREQHD-ZFOPNNO,  " L/C No.
               S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
               S_REQTY   FOR ZTREQHD-ZFREQTY,  " �����Ƿ� Type.
               S_OPNDT   FOR ZTREQST-ZFOPNDT,  " ��������.
               S_CDT     FOR ZTREQST-CDAT,     " ��������.
               S_TERM    FOR ZTREQHD-ZTERM,    " ��������.
               S_INCO    FOR ZTREQHD-INCO1.    " �ε�����.
SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'ZIMR46'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_TERM-LOW.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_TERM-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_TERM-HIGH.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_TERM-HIGH.

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
   SET TITLEBAR 'ZIMR46'.
   SET PF-STATUS 'ZIMR46'.

* List Write...
   PERFORM P3000_WRITE_LC_DATA.           "��� ���...

*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT LINE-SELECTION.

  SET PARAMETER ID 'BES'     FIELD ''.
  SET PARAMETER ID 'ZFOPNNO' FIELD ''.
  SET PARAMETER ID 'ZPREQNO' FIELD IT_TAB-ZFREQNO.
  CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

AT USER-COMMAND.
  CASE SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.                  " SORT ����
         W_FIELD_NM = 'MATNR'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
         PERFORM RESET_LIST.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

   SKIP 2.
   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
   WRITE: /70 '[ ǰ�� ���� ��Ȳ ]'
              COLOR COL_HEADING INTENSIFIED OFF.

   FORMAT RESET.
   WRITE: / 'Date: ', SY-DATUM.
   ULINE.

*>>> Field Name�� Title�� ������ش�.
   FORMAT COLOR COL_HEADING INTENSIFIED ON.
   WRITE: /   SY-VLINE NO-GAP,
         (16) '�����Ƿ� ��ȣ     ' NO-GAP,  SY-VLINE NO-GAP,
         (25) '�÷�Ʈ'             NO-GAP,  SY-VLINE NO-GAP,
         (45) '����              ' NO-GAP,  SY-VLINE NO-GAP,
         (9)  '��ۼ���'           NO-GAP,  SY-VLINE NO-GAP,
         (9)  'Incoterms'          NO-GAP,  SY-VLINE NO-GAP,
         (15) '       ��������'    NO-GAP,  SY-VLINE NO-GAP,
         (5)  '����'               NO-GAP,  SY-VLINE NO-GAP,
         (15) '           �ܰ�'    NO-GAP,  SY-VLINE NO-GAP,
         (24) '           �ݾ�'    NO-GAP,  SY-VLINE NO-GAP.

   FORMAT RESET.
   ULINE.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA.

   PERFORM P1000_READ_RN_DATA.

   IF W_ERR_CHK EQ 'Y'.
      EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_LC_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_LC_DATA.

   SORT  IT_TAB  BY  ZFREQNO ZFITMNO.
   PERFORM P2000_WRITE_DATA.

ENDFORM.                    " P3000_WEITE_LC_DATA
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_RN_DATA.

   DATA: L_LINE_COUNT TYPE I.

   W_ERR_CHK = 'N'.

   SELECT   I~EBELN    I~EBELP  I~ZFREQNO  I~ZFITMNO
            H~ZFTRANS  H~INCO1  H~ZFWERKS  I~MENGE   I~NETPR
            I~MEINS    I~MATNR  I~TXZ01    I~MEINS   H~WAERS
     INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO
     AND    H~EBELN    IN  S_EBELN
     AND    I~MATNR    IN  S_MATNR
     AND    H~ZFREQTY  IN  S_REQTY
     AND    H~ZFOPNNO  IN  S_OPNNO
     AND    H~ZTERM    IN  S_TERM
     AND    H~INCO1    IN  S_INCO
     AND    H~ZFWERKS  IN  S_WERKS
     AND    H~ZFMATGB  IN  S_MATGB.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

   LOOP AT IT_TAB.

     W_TABIX = SY-TABIX.

* PO ITEM ���� SELECT!
     SELECT SINGLE * FROM EKPO WHERE EBELN EQ IT_TAB-EBELN
                               AND   EBELP EQ IT_TAB-EBELP.

     SELECT SINGLE * FROM ZTREQST
            WHERE  ZFREQNO  EQ  IT_TAB-ZFREQNO
            AND    EKGRP    IN  S_EKGRP
            AND    CDAT     IN  S_CDT
            AND    ZFOPNDT  IN  S_OPNDT
            AND    ZFAMDNO  EQ  ( SELECT MAX( ZFAMDNO ) FROM ZTREQST
                                  WHERE  ZFREQNO  EQ IT_TAB-ZFREQNO ).

     IF SY-SUBRC NE 0.
        DELETE  IT_TAB  INDEX  W_TABIX.
        CONTINUE.
     ENDIF.

     " �÷�Ʈ�� SET!
     CLEAR : T001W.
     SELECT SINGLE NAME1 INTO IT_TAB-NAME1
                         FROM T001W WHERE WERKS  EQ  IT_TAB-ZFWERKS.

     " ���籸�� SET!
     IF IT_TAB-ZFTRANS EQ 'A'.
        MOVE : 'AIR'  TO  IT_TAB-TRANS_NM.
     ELSEIF IT_TAB-ZFTRANS EQ 'O'.
        MOVE : 'OCEAN' TO  IT_TAB-TRANS_NM.
     ELSE.
        MOVE : 'AIR/OCEAN' TO IT_TAB-TRANS_NM.
     ENDIF.

     " ITEM �� �ݾ� COMPUTE.
     IF EKPO-BPUMN IS INITIAL.
        EKPO-BPUMN = 1.
     ENDIF.
     IF EKPO-PEINH IS INITIAL.
        EKPO-PEINH = 1.
     ENDIF.
     IT_TAB-ZFAMT = ( IT_TAB-MENGE * ( EKPO-BPUMZ / EKPO-BPUMN )
                  * ( IT_TAB-NETPR / EKPO-PEINH ) ).

     MODIFY  IT_TAB  INDEX  W_TABIX.

   ENDLOOP.

   DESCRIBE TABLE IT_TAB  LINES L_LINE_COUNT.
   IF L_LINE_COUNT = 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
*&      Form  P2000_WRITE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_WRITE_DATA.

   LOOP AT IT_TAB.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.
   ENDLOOP.

ENDFORM.                    " P2000_WRITE_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.

   IF W_MOD EQ 1.
      FORMAT COLOR COL_NORMAL INTENSIFIED ON.
   ELSE.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   ENDIF.

   WRITE:/ SY-VLINE NO-GAP,
          (10) IT_TAB-ZFREQNO         NO-GAP,
          '-'                         NO-GAP,
          (5)  IT_TAB-ZFITMNO         NO-GAP,  SY-VLINE NO-GAP,
          (4)  IT_TAB-ZFWERKS         NO-GAP,
          ' '                         NO-GAP,
          (20) IT_TAB-NAME1           NO-GAP,  SY-VLINE NO-GAP,
          (20) IT_TAB-MATNR NO-GAP,
          (25) IT_TAB-TXZ01 NO-GAP,   SY-VLINE NO-GAP, "�����.
          (9)  IT_TAB-TRANS_NM        NO-GAP,  SY-VLINE NO-GAP,
          (9)  IT_TAB-INCO1           NO-GAP,  SY-VLINE NO-GAP,
          (15) IT_TAB-MENGE UNIT IT_TAB-MEINS  NO-GAP,
                                      SY-VLINE NO-GAP,
          (5)  IT_TAB-MEINS NO-GAP,   SY-VLINE NO-GAP,
          (15) IT_TAB-NETPR   CURRENCY  IT_TAB-WAERS
                              NO-GAP, SY-VLINE NO-GAP,
          (19) IT_TAB-ZFAMT   CURRENCY  IT_TAB-WAERS   NO-GAP,
          (5)  IT_TAB-WAERS   NO-GAP, SY-VLINE.
* hide
   HIDE: IT_TAB.

   WRITE : / SY-ULINE.

   W_COUNT = W_COUNT + 1.
   W_MOD =  W_COUNT MOD 2.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

   IF W_COUNT GT 0.
      WRITE : / '��', W_COUNT, '��'.
   ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_PAY_TERM_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_TERM_LOW  text
*----------------------------------------------------------------------*
FORM P1000_PAY_TERM_HELP USING    P_ZTERM.

   TABLES : T052.

   CALL FUNCTION 'FI_F4_ZTERM'
         EXPORTING
              I_KOART       = 'K'
              I_ZTERM       = P_ZTERM
              I_XSHOW       = ' '
         IMPORTING
              E_ZTERM       = T052-ZTERM
         EXCEPTIONS
              NOTHING_FOUND = 01.

  IF SY-SUBRC NE 0.
*   message e177 with ekko-zterm.
    MESSAGE S177(06) WITH P_ZTERM.
    EXIT.
  ENDIF.

  IF T052-ZTERM NE SPACE.
     P_ZTERM = T052-ZTERM.
  ENDIF.

ENDFORM.                    " P1000_PAY_TERM_HELP

*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE  0  TO  SY-LSIND.

  W_COUNT = 0.
  PERFORM P3000_TITLE_WRITE.
  PERFORM P2000_WRITE_DATA.

ENDFORM.                    " RESET_LIST
