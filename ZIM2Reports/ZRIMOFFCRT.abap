*&---------------------------------------------------------------------*
*& Report  ZRIMOFFCRT                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Local Offer Sheet Multi-Create Program                *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.04.04                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMOFFCRT   MESSAGE-ID ZIM
                     LINE-SIZE 130
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK       TYPE C,                        " MARK
       W_GB01(1)  TYPE C VALUE ';',
       UPDATE_CHK TYPE C,                        " DB �ݿ� ����...
       W_GB02(1)  TYPE C VALUE ';',
       ZFAPPDT    LIKE ZTREQST-ZFAPPDT,          " ��������?
       W_GB03(1)  TYPE C VALUE ';',
       ZFREQDT    LIKE ZTREQST-ZFREQDT,          " �䰳����?
       W_GB04(1)  TYPE C VALUE ';',
       ZFMAUD     LIKE ZTREQHD-ZFMAUD,           " ���糳��?
       W_GB05(1)  TYPE C VALUE ';',
       EBELN      LIKE ZTREQHD-EBELN,            " Purchasing document
       W_GB06(1)  TYPE C VALUE ';',
       ZFREQNO    LIKE ZTREQHD-ZFREQNO,          " �����Ƿ� ��?
       W_GB07(1)  TYPE C VALUE ';',
       ZFAMDNO    LIKE ZTREQST-ZFAMDNO,          " Amend Seq.
       W_GB08(1)  TYPE C VALUE ';',
       ZFLASTAM   LIKE ZTREQHD-ZFLASTAM,         " ������?
       W_GB09(1)  TYPE C VALUE ';',
       WAERS      LIKE ZTREQHD-WAERS,            " Currency
       W_GB10(1)  TYPE C VALUE ';',
       ZFUSDAM    LIKE ZTREQHD-ZFUSDAM,          " USD ȯ���?
       W_GB11(1)  TYPE C VALUE ';',
       ZFUSD      LIKE ZTREQHD-ZFUSD,            " USD Currency
       W_GB12(1)  TYPE C VALUE ';',
       ZFREQTY    LIKE ZTREQST-ZFREQTY,          " ������?
       W_GB13(1)  TYPE C VALUE ';',
       ZFMATGB    LIKE ZTREQHD-ZFMATGB,          " ���籸?
       W_GB14(1)  TYPE C VALUE ';',
       ZFBACD     LIKE ZTREQHD-ZFBACD,           " ����/���� ��?
       W_GB15(1)  TYPE C VALUE ';',
       EKORG      LIKE ZTREQST-EKORG,            " Purchasing organizati
       W_GB16(1)  TYPE C VALUE ';',
       EKGRP      LIKE ZTREQST-EKGRP,            " Purchasing group
       W_GB17(1)  TYPE C VALUE ';',
       ZTERM      LIKE ZTREQHD-ZTERM,            " Terms of Payment
       W_GB18(1)  TYPE C VALUE ';',
       ZFWERKS    LIKE ZTREQHD-ZFWERKS,          " ��ǥ Plant
       W_GB19(1)  TYPE C VALUE ';',
       ERNAM      LIKE ZTREQST-ERNAM,            " ���Ŵ�?
       W_GB20(1)  TYPE C VALUE ';',
       LIFNR      LIKE ZTREQHD-LIFNR,            " Vendor Code
       W_GB21(1)  TYPE C VALUE ';',
*      NAME1      LIKE LFA1-NAME1,               " Name 1
       NAME1(17),                                " Name 1
       W_GB22(1)  TYPE C VALUE ';',
       ZFBENI     LIKE ZTREQHD-ZFBENI,           " Beneficairy
       W_GB23(1)  TYPE C VALUE ';',
*      NAME2      LIKE LFA1-NAME1,               " Name 1
       NAME2(17),                                " Name 1
       W_GB24(1)  TYPE C VALUE ';',
       ZFOPBN     LIKE ZTREQHD-ZFBENI,           " Open Bank
       W_GB25(1)  TYPE C VALUE ';',
*      NAME3      LIKE LFA1-NAME1,               " Name 1
       NAME3(17),                                " Name 1
       W_GB26(1)  TYPE C VALUE ';',
       ZFRLST2    LIKE ZTREQST-ZFRLST2,          " ���� Release ��?
       W_GB27(1)  TYPE C VALUE ';',
       ZFRLDT2    LIKE ZTREQST-ZFRLDT2,          " ���� Release ��?
       W_GB28(1)  TYPE C VALUE ';',
       ZFRLNM2    LIKE ZTREQST-ZFRLNM2,          " ���� Release ���?
       W_GB29(1)  TYPE C VALUE ';',
       ZFCLOSE    LIKE ZTREQHD-ZFCLOSE,          " �����Ƿ� ���Ῡ?
       W_GB30(1)  TYPE C VALUE ';',
       ZFRLST1    LIKE ZTREQST-ZFRLST1,          " ���� Release ��?
       W_GB31(1)  TYPE C VALUE ';',
*      ZFSPRT     LIKE ZTREQHD-ZFSPRT,           " ����?
       ZFSPRT(18) TYPE C,                        " ����?
       W_GB32(1)  TYPE C VALUE ';',
*      ZFAPRT     LIKE ZTREQHD-ZFAPRT,           " ����?
       ZFAPRT(18) TYPE C,                        " ����?
       W_GB33(1)  TYPE C VALUE ';',
       INCO1      LIKE ZTREQHD-INCO1,            " Incoterms
       W_GB34(1)  TYPE C VALUE ';',
       ZFTRANS    LIKE ZTREQHD-ZFTRANS,          " VIA
       W_GB35(1)  TYPE C VALUE ';',
       ZFLEVN     LIKE ZTREQHD-ZFLEVN,           " ���Ա�?
       W_GB36(1)  TYPE C VALUE ';',
*      NAME4      LIKE LFA1-NAME1,               " Name 1
       NAME4(11),                                " Name 1
       W_GB37(1)  TYPE C VALUE ';',
*      ZFREF1     LIKE ZTREQHD-ZFREF1,           " remark
       ZFREF1(11),                               " remark
       W_GB38(1)  TYPE C VALUE ';'.
DATA : END OF IT_TAB.

DATA : IT_ZTREQORJ     LIKE ZSMLCSG7O OCCURS 0 WITH HEADER LINE.
DATA : IT_ZTREQORJ_ORG LIKE ZSMLCSG7O OCCURS 0 WITH HEADER LINE.
* ǰ�� ����Ʈ�� ���� Internal Table( Original Data )
DATA : IT_ZSREQIT LIKE ZSREQIT OCCURS 0 WITH HEADER LINE.
DATA : IT_ZSREQIT_ORG LIKE ZSREQIT OCCURS 0 WITH HEADER LINE.
*----------------------------------------------------------------------*
* local offer sheet ������ ����Ʈ�� ���� Internal Table
*----------------------------------------------------------------------*
DATA : IT_ZSOFFO          LIKE ZSOFFO      OCCURS 100 WITH HEADER LINE.
DATA : IT_ZSOFFO_ORG      LIKE ZSOFFO      OCCURS 100 WITH HEADER LINE.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* local offer sheet ��Ÿ���� ����Ʈ�� ���� Internal Table
*----------------------------------------------------------------------*
DATA : IT_ZSOFFSDE        LIKE ZSOFFSDE    OCCURS 100 WITH HEADER LINE.
DATA : IT_ZSOFFSDE_ORG    LIKE ZSOFFSDE    OCCURS 100 WITH HEADER LINE.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* local offer seg. 6 ����Ʈ�� ���� Internal Table
*----------------------------------------------------------------------*
DATA : IT_ZSOFFSG6        LIKE ZSOFFSG6    OCCURS 100 WITH HEADER LINE.
DATA : IT_ZSOFFSG6_ORG    LIKE ZSOFFSG6    OCCURS 100 WITH HEADER LINE.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* local offer seg. 6 �԰�    ����Ʈ�� ���� Internal Table
*----------------------------------------------------------------------*
DATA : IT_ZSOFFSG6G       LIKE ZSOFFSG6G   OCCURS 100 WITH HEADER LINE.
DATA : IT_ZSOFFSG6G_ORG   LIKE ZSOFFSG6G   OCCURS 100 WITH HEADER LINE.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* �����Ƿ� ��õ ����Ʈ�� ���� Internal Table
*----------------------------------------------------------------------*
DATA : IT_ZSREQIL      LIKE ZSREQIL   OCCURS 50 WITH HEADER LINE.
DATA : IT_ZSREQIL_ORG  LIKE ZSREQIL   OCCURS 50 WITH HEADER LINE.
*----------------------------------------------------------------------*


*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMPRELTOP.    " ���� Released  Report Data Define�� Include
INCLUDE   ZRIMBDCCOM.     " �����Ƿ� BDC ���� Include
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?


*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_APPDT   FOR ZTREQST-ZFAPPDT,  " ��������?
                   S_OPBN    FOR ZTREQHD-ZFOPBN,   " ������?
                   S_WERKS   FOR ZTREQHD-ZFWERKS,  " ��ǥ plant
                   S_EKORG   FOR ZTREQST-EKORG.    " Purch. Org.
   PARAMETERS :    P_NAME    LIKE USR02-BNAME.     " ���?
   SELECT-OPTIONS: S_EBELN   FOR ZTREQHD-EBELN,    " P/O Number
                   S_LIFNR   FOR ZTREQHD-LIFNR,    " vendor
                   S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
                   S_REQNO   FOR ZTREQHD-ZFREQNO.  " �����Ƿ� ������?
*&---------------------------------------------------------------------*
*&  BDC MODE ���� ��?
*&---------------------------------------------------------------------*
SELECTION-SCREEN ULINE.
SELECTION-SCREEN: BEGIN OF LINE,  COMMENT 1(13) TEXT-021, POSITION 1.
      SELECTION-SCREEN: COMMENT 32(1) TEXT-022, POSITION 34.
         PARAMETERS J1 RADIOBUTTON GROUP RAD1.              " Display
      SELECTION-SCREEN: COMMENT 40(1) TEXT-023, POSITION 42.
         PARAMETERS J2 RADIOBUTTON GROUP RAD1 DEFAULT 'X'.  " Backgroud
     SELECTION-SCREEN: COMMENT 48(1) TEXT-024, POSITION 50.
        PARAMETERS J3 RADIOBUTTON GROUP RAD1.               " Error
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN: COMMENT /1(79) TEXT-025.
SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN.
   IF J1 = 'X'. DISP_MODE = 'A'. ENDIF.
   IF J2 = 'X'. DISP_MODE = 'N'. ENDIF.
   IF J3 = 'X'. DISP_MODE = 'E'. ENDIF.
*
* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
   PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.
* ���� ���� ��?
   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* �Ķ��Ÿ ��?
   PERFORM   P2000_SET_SELETE_OPTION   USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* �����Ƿ� ���̺� SELECT
   PERFORM   P1000_GET_ZVREQHD_ST      USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ ���� Text Table SELECT
   PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.         " SORT ����.
         W_FIELD_NM = 'ZFOPBN'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ��������.

         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.

      WHEN 'DISP'.          " L/C ��ȸ...
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_SHOW_LC USING IT_SELECTED-ZFREQNO.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'CRTD'.          " OFFER SHEET DOCUMENT
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
            PERFORM P2000_POPUP_MESSAGE.     " �޼��� �ڽ�.
            IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ���.
               PERFORM P2000_BDC_DATA_MAKE.
               PERFORM P2000_REFRESH_LIST.
*               LEAVE TO SCREEN 0.
            ELSE.
                MESSAGE E032.
            ENDIF.
         ENDIF.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
         PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
         PERFORM P2000_REFRESH_LIST.
      WHEN OTHERS.
   ENDCASE.


*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
  SET  TITLEBAR 'ZIM06'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /52  '[ OFFER SHEET ���� ��� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 112 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
            '�¼�����'    ,  SY-VLINE NO-GAP,
            'P/O Number'    NO-GAP,  SY-VLINE NO-GAP,
            'CUR. '         NO-GAP,  SY-VLINE NO-GAP,
 '    ���� �ݾ�     '       NO-GAP,  SY-VLINE NO-GAP,
            'Ty'            NO-GAP,  SY-VLINE NO-GAP,
            'Mat'           NO-GAP,  SY-VLINE NO-GAP,
            'Pay.'          NO-GAP,  SY-VLINE NO-GAP,
    '     ��  ��  ��     '  NO-GAP,  SY-VLINE NO-GAP,
            'Inc'           NO-GAP,  SY-VLINE NO-GAP,
            'Vendor    '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
*           'S'             NO-GAP,  SY-VLINE NO-GAP,
            ' ���Ա��  '   NO-GAP,  SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
            '���糳��'    ,  SY-VLINE NO-GAP,
            '�����Ƿ�No'    NO-GAP,  SY-VLINE NO-GAP,
            '     '         NO-GAP,  SY-VLINE NO-GAP,
 '   USD ȯ��ݾ�   '       NO-GAP,  SY-VLINE NO-GAP,
            'TT'            NO-GAP,  SY-VLINE NO-GAP,
            'PGr'           NO-GAP,  SY-VLINE NO-GAP,
            'Plnt'          NO-GAP,  SY-VLINE NO-GAP,
    '     ��  ��  ��     '  NO-GAP,  SY-VLINE NO-GAP,
            'VIA'           NO-GAP,  SY-VLINE NO-GAP,
            'Bene.     '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
*           'C'             NO-GAP,  SY-VLINE NO-GAP,
            ' ��������  '   NO-GAP,  SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

   W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
* BDC ������ ���� ü?
*-----------------------------------------------------------------------
   IF DISP_MODE NE 'N'.            " BACKGROUND�� �ƴ� ��?
      AUTHORITY-CHECK OBJECT 'ZM_BDC_MGT'
             ID 'ACTVT' FIELD '*'.

      IF SY-SUBRC NE 0.
         MESSAGE S960 WITH SY-UNAME 'BDC ������'.
         W_ERR_CHK = 'Y'.   EXIT.
      ENDIF.
   ENDIF.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_LC_MGT'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'Offer Sheet Create Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
FORM P2000_SET_SELETE_OPTION   USING    W_ERR_CHK.
*
  W_ERR_CHK = 'N'.

* IF P_NAME IS INITIAL.       P_NAME  =  '%'.      ENDIF.
  CONCATENATE P_NAME '%' INTO P_NAME.
ENDFORM.                    " P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZVREQHD_ST
*&---------------------------------------------------------------------*
FORM P1000_GET_ZVREQHD_ST   USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting

  SELECT * INTO TABLE IT_ZVREQ FROM ZVREQHD_ST
                               WHERE ZFAPPDT    IN     S_APPDT
                               AND   ZFOPBN     IN     S_OPBN
                               AND   ZFREQTY    EQ     'LO'
                               AND   ZFWERKS    IN     S_WERKS
                               AND   EKORG      IN     S_EKORG
                               AND   ERNAM      LIKE   P_NAME
                               AND   EBELN      IN     S_EBELN
                               AND   LIFNR      IN     S_LIFNR
                               AND   EKGRP      IN     S_EKGRP
                               AND   ZFREQNO    IN     S_REQNO
                               AND   ZFDOCST    EQ     'O'
                               AND   ZFCLOSE    EQ     SPACE.

  IF SY-SUBRC NE 0.               " Not Found?
     W_ERR_CHK = 'Y'.  MESSAGE S009.    EXIT.
  ENDIF.

ENDFORM.                    " P1000_GET_ZVREQHD_ST
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.
   REFRESH : IT_TAB.

   LOOP AT IT_ZVREQ.

      W_TABIX = SY-TABIX.

*-----------------------------------------------------------------------
*  OFFER SHEET ���� ��?
*-----------------------------------------------------------------------
      SELECT SINGLE * FROM ZTOFF WHERE ZFREQNO EQ IT_ZVREQ-ZFREQNO.
      IF SY-SUBRC EQ 0.
         CONTINUE.
      ENDIF.

      MOVE-CORRESPONDING IT_ZVREQ  TO  IT_TAB.
*-----------------------------------------------------------------------
* VENDOR MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CALL FUNCTION 'READ_LFA1'
           EXPORTING
                 XLIFNR          = IT_TAB-LIFNR
           IMPORTING
                 XLFA1           = LFA1
           EXCEPTIONS
                 KEY_INCOMPLETE  = 01
                 NOT_AUTHORIZED  = 02
                 NOT_FOUND       = 03.

      CASE SY-SUBRC.
         WHEN 01.     MESSAGE E022.
         WHEN 02.     MESSAGE E950.
         WHEN 03.     MESSAGE E020   WITH    IT_TAB-LIFNR.
      ENDCASE.
      MOVE: LFA1-NAME1   TO   IT_TAB-NAME1.
*-----------------------------------------------------------------------
* Bene. MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CALL FUNCTION 'READ_LFA1'
           EXPORTING
                 XLIFNR          = IT_TAB-ZFBENI
           IMPORTING
                 XLFA1           = LFA1
           EXCEPTIONS
                 KEY_INCOMPLETE  = 01
                 NOT_AUTHORIZED  = 02
                 NOT_FOUND       = 03.

      CASE SY-SUBRC.
         WHEN 01.     MESSAGE E022.
         WHEN 02.     MESSAGE E950.
         WHEN 03.     MESSAGE E020   WITH    IT_TAB-LIFNR.
      ENDCASE.
      MOVE: LFA1-NAME1   TO   IT_TAB-NAME2.

*-----------------------------------------------------------------------
* Opeb Bank. MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CALL FUNCTION 'READ_LFA1'
           EXPORTING
                 XLIFNR          = IT_TAB-ZFOPBN
           IMPORTING
                 XLFA1           = LFA1
           EXCEPTIONS
                 KEY_INCOMPLETE  = 01
                 NOT_AUTHORIZED  = 02
                 NOT_FOUND       = 03.

      CASE SY-SUBRC.
*        WHEN 01.     MESSAGE E022.
         WHEN 02.     MESSAGE E950.
         WHEN 03.     MESSAGE E020   WITH    IT_TAB-ZFOPBN.
      ENDCASE.
      MOVE: LFA1-NAME1   TO   IT_TAB-NAME3.
*-----------------------------------------------------------------------
* ���Ա��   MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CALL FUNCTION 'READ_LFA1'
           EXPORTING
                 XLIFNR          = IT_TAB-ZFLEVN
           IMPORTING
                 XLFA1           = LFA1
           EXCEPTIONS
                 KEY_INCOMPLETE  = 01
                 NOT_AUTHORIZED  = 02
                 NOT_FOUND       = 03.

      CASE SY-SUBRC.
*        WHEN 01.     MESSAGE E022.
         WHEN 02.     MESSAGE E950.
         WHEN 03.     MESSAGE E020   WITH    IT_TAB-ZFLEVN.
      ENDCASE.
      MOVE: LFA1-NAME1   TO   IT_TAB-NAME4.

      APPEND  IT_TAB.
   ENDLOOP.

   DESCRIBE TABLE IT_TAB LINES W_LINE.
   IF W_LINE < 1.
      W_ERR_CHK = 'Y'.  MESSAGE S009.    EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIM06'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIM06'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P2000_PAGE_CHECK.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.

   ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: INDEX   TYPE P,
        ZFREQNO LIKE ZTREQST-ZFREQNO,
        ZFAMDNO LIKE ZTREQST-ZFAMDNO,
        ZFRLST1 LIKE ZTREQST-ZFRLST1,
        ZFRLST2 LIKE ZTREQST-ZFRLST2.

  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFREQNO  TO ZFREQNO,
         IT_TAB-ZFAMDNO  TO ZFAMDNO,
         IT_TAB-ZFRLST1  TO ZFRLST1,
         IT_TAB-ZFRLST2  TO ZFRLST2.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      MOVE : IT_TAB-ZFREQNO  TO IT_SELECTED-ZFREQNO,
             IT_TAB-ZFAMDNO  TO IT_SELECTED-ZFAMDNO,
             IT_TAB-ZFRLST1  TO IT_SELECTED-ZFRLST1,
             IT_TAB-ZFRLST2  TO IT_SELECTED-ZFRLST2.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
    IF INDEX GT 0.
      MOVE : ZFREQNO TO IT_SELECTED-ZFREQNO,
             ZFAMDNO TO IT_SELECTED-ZFAMDNO,
             ZFRLST1 TO IT_SELECTED-ZFRLST1,
             ZFRLST2 TO IT_SELECTED-ZFRLST2.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ELSE.
      MESSAGE S962.
    ENDIF.
  ENDIF.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / '��', W_COUNT, '��'.
  ENDIF.


ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

* IF SY-UCOMM EQ 'FRGS' OR SY-UCOMM EQ 'FRGR'.
*    IF IT_TAB-MARK EQ 'X' AND IT_TAB-UPDATE_CHK EQ 'U'.
*       MARKFIELD = 'X'.
*    ELSE.
*       CLEAR : MARKFIELD.
*    ENDIF.
* ENDIF.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE NO-GAP,
       IT_TAB-ZFAPPDT NO-GAP,            " ��������?
       SY-VLINE NO-GAP,
       IT_TAB-EBELN   NO-GAP,            " ���Ź�?
       SY-VLINE NO-GAP,
       IT_TAB-WAERS NO-GAP,              " currency
       SY-VLINE NO-GAP,
       IT_TAB-ZFLASTAM CURRENCY IT_TAB-WAERS NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFREQTY NO-GAP,            " ���� ��?
       SY-VLINE,
       IT_TAB-ZFMATGB,                   " ���� ��?
       SY-VLINE NO-GAP,
       IT_TAB-ZTERM NO-GAP,              " Payment Terms
       SY-VLINE NO-GAP,
       IT_TAB-ZFSPRT  NO-GAP,               " ����?
    85 SY-VLINE NO-GAP,
       IT_TAB-INCO1   NO-GAP,               " Incoterms
       SY-VLINE NO-GAP,
       IT_TAB-LIFNR   NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-NAME1   NO-GAP,
   118 SY-VLINE NO-GAP.
  WRITE : IT_TAB-NAME4 NO-GAP, SY-VLINE.         " ���Ա��?

* hide
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE:/ SY-VLINE, ' ',
       SY-VLINE NO-GAP,
       IT_TAB-ZFMAUD,                       " ���糳��?
    16 SY-VLINE NO-GAP,
       IT_TAB-ZFREQNO NO-GAP,               " ������?
       SY-VLINE NO-GAP,
       IT_TAB-ZFUSD NO-GAP,                 " ��ȭ ��?
       SY-VLINE NO-GAP,
       IT_TAB-ZFUSDAM  CURRENCY IT_TAB-ZFUSD NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFBACD,                       " ���� / ���� ��?
       SY-VLINE NO-GAP,
       IT_TAB-EKGRP NO-GAP,                 " Purchasing Group
       SY-VLINE NO-GAP,
       IT_TAB-ZFWERKS NO-GAP,               " ��ǥ plant
       SY-VLINE NO-GAP,
       IT_TAB-ZFAPRT  NO-GAP,             " ����?
    85 SY-VLINE,
       IT_TAB-ZFTRANS,                    " VIA
       SY-VLINE NO-GAP,
       IT_TAB-ZFBENI  NO-GAP,             " Beneficiary
       SY-VLINE NO-GAP,
       IT_TAB-NAME2   NO-GAP,
   118 SY-VLINE NO-GAP,
       IT_TAB-ZFREF1 NO-GAP,               " ������?
       SY-VLINE NO-GAP.
* stored value...
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.
  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.
ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POPUP_MESSAGE.

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = 'Local Offer Sheet Create Ȯ��'
             DIAGNOSE_OBJECT = ''
             TEXT_QUESTION   =
                  'Offer Sheet �����۾��� ��� �����Ͻðڽ��ϱ�?'
             TEXT_BUTTON_1   = 'Ȯ    ��'
             TEXT_BUTTON_2   = '�� �� ��'
             DEFAULT_BUTTON  = '1'
             DISPLAY_CANCEL_BUTTON = 'X'
             START_COLUMN    = 30
             START_ROW       = 8
         IMPORTING
             ANSWER          =  W_BUTTON_ANSWER.

ENDFORM.                    " P2000_POPUP_MESSAGE

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'ZPREQNO' FIELD P_ZFREQNO.
   EXPORT 'BES'           TO MEMORY ID 'BES'.
   EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.

   CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_REFRESH_LIST
*&---------------------------------------------------------------------*
FORM P2000_REFRESH_LIST.
* �����Ƿ� ���̺� SELECT
   PERFORM   P1000_GET_ZVREQHD_ST      USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
* ����Ʈ ���� Text Table SELECT
   PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
   PERFORM RESET_LIST.

ENDFORM.                    " P2000_REFRESH_LIST

*&---------------------------------------------------------------------*
*&      Form  P2000_BDC_DATA_MAKE
*&---------------------------------------------------------------------*
FORM P2000_BDC_DATA_MAKE.
   REFRESH : BDCDATA.
   LOOP AT IT_SELECTED.
      LINE = ( SY-TABIX / W_SELECTED_LINES ) * 100.
      OUT_TEXT = 'JOB PROGRESS %99999%%'.
      REPLACE '%99999%' WITH LINE INTO OUT_TEXT.
      PERFORM P2000_SHOW_BAR USING OUT_TEXT LINE.

      REFRESH : BDCDATA.

* �ʱ�ȭ�� CALL
      PERFORM P2000_DYNPRO USING 'X' 'SAPMZIM00' '2100'.
* �ʱ�ȭ�� FIELD
      PERFORM P2000_DYNPRO USING :
*          ' ' 'ZSREQHD-ZFOPNNO' '',                  " ������?
           ' ' 'ZSREQHD-EBELN'   '',                  " P/O No.
           ' ' 'ZSREQHD-ZFREQNO' IT_SELECTED-ZFREQNO, " Import No.
           ' ' 'BDC_OKCODE'      '/00'.               " ENTER
* ��ȭ��   CALL
      PERFORM P2000_DYNPRO USING 'X' 'SAPMZIM00' '2101'.
* ��?
      PERFORM P2000_DYNPRO USING ' ' 'BDC_OKCODE' 'SAVE'.
* ���� Ȯ�� CALL
      PERFORM P2000_DYNPRO USING 'X' 'SAPMZIM00' '0001'.
* ��?
      PERFORM P2000_DYNPRO USING ' ' 'BDC_OKCODE' 'YES'.
* CALL TRANSACTION
      PERFORM P2000_CALL_TRANSACTION  USING 'ZIML1'
                                      CHANGING  W_SUBRC.
* ���� �߻��� LOG
      IF W_SUBRC NE 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         MESSAGE ID SY-MSGID TYPE 'I' NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*         MESSAGE I000 WITH  MESSTXT.
      ENDIF.
   ENDLOOP.

ENDFORM.                    " P2000_BDC_DATA_MAKE
