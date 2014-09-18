*&---------------------------------------------------------------------*
*& Report  ZRIMREL02                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� Release ( Approve ) �����Ƿ� Documents           *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.01.28                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : Config���� ���� Released ���θ� Check�Ͽ��߸� �Ѵ�.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMREL02    MESSAGE-ID ZIM
                     LINE-SIZE 132
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* �����Ƿ� ������� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK       TYPE C,                        " MARK
       UPDATE_CHK TYPE C,                        " DB �ݿ� ����...
       ZFAPPDT    LIKE ZTREQST-ZFAPPDT,          " �䰳����?
       ZFREQDT    LIKE ZTREQST-ZFREQDT,          " �䰳����?
       ZFMAUD     LIKE ZTREQHD-ZFMAUD,           " ���糳��?
       EBELN      LIKE ZTREQHD-EBELN,            " Purchasing document
       ZFREQNO    LIKE ZTREQHD-ZFREQNO,          " �����Ƿ� ��?
       ZFAMDNO    LIKE ZTREQST-ZFAMDNO,          " Amend Seq.
       ZFOPAMT1(18) TYPE C,                      " �����ݾ� TEXT
       WAERS      LIKE ZTREQST-WAERS,            " Currency
       ZFUSDAM1(18) TYPE C,                      " USD ȯ��ݾ� TEXT
       ZFUSD      LIKE ZTREQST-ZFUSD,            " USD Currency
       ZFREQTY    LIKE ZTREQST-ZFREQTY,          " ������?
       ZFMATGB    LIKE ZTREQHD-ZFMATGB,          " ���籸?
       ZFBACD     LIKE ZTREQHD-ZFBACD,           " ����/���� ��?
       EKORG      LIKE ZTREQST-EKORG,            " Purchasing organizati
       EKGRP      LIKE ZTREQST-EKGRP,            " Purchasing group
       ZTERM      LIKE ZTREQHD-ZTERM,            " Terms of Payment
       ZFWERKS    LIKE ZTREQHD-ZFWERKS,          " ��ǥ Plant
       ERNAM      LIKE ZTREQST-ERNAM,            " ���Ŵ�?
       LIFNR      LIKE ZTREQHD-LIFNR,            " Vendor Code
       NAME1(17),                                " Name 1
       ZFBENI     LIKE ZTREQHD-ZFBENI,           " Beneficairy
       NAME2(17),                                " Name 1
       ZFOPBN     LIKE ZTREQHD-ZFBENI,           " Open Bank
       NAME3(17),                                " Name 1
       ZFRLST2    LIKE ZTREQST-ZFRLST2,          " ���� Release ��?
       ZFRLDT2    LIKE ZTREQST-ZFRLDT2,          " ���� Release ��?
       ZFRLNM2    LIKE ZTREQST-ZFRLNM2,          " ���� Release ���?
       ZFCLOSE    LIKE ZTREQHD-ZFCLOSE,          " �����Ƿ� ���Ῡ?
       ZFRLST1    LIKE ZTREQST-ZFRLST1,          " ���� Release ��?
       ZFSPRT(18) TYPE C,                        " ����?
       ZFAPRT(18) TYPE C,                        " ����?
       INCO1      LIKE ZTREQHD-INCO1,            " Incoterms
       ZFTRANS    LIKE ZTREQHD-ZFTRANS,          " VIA
       ZFLEVN     LIKE ZTREQHD-ZFLEVN,           " ���Ա�?
       NAME4(11),                                " Name 1
       ZFREF1(11),                               " remark
       ZFOPAMT    LIKE ZTREQST-ZFOPAMT,          " ������?
       ZFUSDAM    LIKE ZTREQST-ZFUSDAM.          " USD ȯ���?
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMPRELTOP.    " ���� Released  Report Data Define�� Include

INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?


*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_BUKRS   FOR ZTREQHD-BUKRS NO-EXTENSION
                                            NO INTERVALS,
                S_APPDT   FOR ZTREQST-ZFAPPDT,  " ������?
                S_OPBN    FOR ZTREQHD-ZFOPBN,   " ������?
                S_MATGB   FOR ZTREQHD-ZFMATGB,  " ���籸?
                S_REQTY   FOR ZTREQHD-ZFREQTY,  " �����Ƿ� Type
                S_WERKS   FOR ZTREQHD-ZFWERKS,  " ��ǥ plant
                S_EKORG   FOR ZTREQST-EKORG.    " Purch. Org.

SELECT-OPTIONS: S_EBELN   FOR ZTREQHD-EBELN,    " P/O Number
                S_LIFNR   FOR ZTREQHD-LIFNR,    " vendor
                S_ZFBENI  FOR ZTREQHD-ZFBENI,   " Beneficiary
                S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
                S_REQNO   FOR ZTREQHD-ZFREQNO.  " �����Ƿ� ������?
PARAMETERS :    P_NAME    LIKE USR02-BNAME.      " ���?
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
PARAMETERS : P_NOOPEN   AS CHECKBOX.
PARAMETERS : P_OPEN     AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B2.
*
*-----------------------------------------------------------------------
* L/C ������ ���� SELECT ���� PARAMETER
*-----------------------------------------------------------------------
SELECT-OPTIONS : S_STATUS FOR ZTREQST-ZFRLST1 NO INTERVALS NO-DISPLAY.
SELECT-OPTIONS : S_STATU2 FOR ZTREQST-ZFRLST2 NO INTERVALS NO-DISPLAY.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
  PERFORM   P1000_SET_BUKRS.
  PERFORM   P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.
* Import System Config Check
  PERFORM   P2000_CONFIG_CHECK        USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

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
* SORT ����.
    WHEN 'STUP' OR 'STDN'.         " SORT ����.
      W_FIELD_NM = 'ZFOPBN'.
      ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
      PERFORM HANDLE_SORT TABLES  IT_TAB
                          USING   SY-UCOMM.
* ��ü ���� �� ��������.
    WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ��������.
      PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
    WHEN 'DISP'.          " L/C ��ȸ.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_SHOW_LC USING IT_SELECTED-ZFREQNO.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.
    WHEN 'RESV'.          " ������ + ����.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES NE 0.
        PERFORM P3000_RELEASED_UPDATE USING 'R'.
        LOOP AT IT_TAB WHERE UPDATE_CHK EQ 'U'.
          EXIT.
        ENDLOOP.
        IF SY-SUBRC EQ 0.
          PERFORM P2000_POPUP_MESSAGE.     " �޼��� �ڽ�.
          IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ���.
            PERFORM P3000_DATA_UPDATE.    " ����Ÿ �ݿ�.
            PERFORM P2000_DATA_UNLOCK.    " Unlocking
            LEAVE TO SCREEN 0.
          ENDIF.
        ELSE.
          MESSAGE E032.
        ENDIF.
      ENDIF.
    WHEN 'FRGS'.          " ������.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES NE 0.
        PERFORM P3000_RELEASED_UPDATE USING 'R'.
        PERFORM RESET_LIST.
      ENDIF.
    WHEN 'FRGR'.          " ������ ���.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES NE 0.
        PERFORM P3000_RELEASED_UPDATE USING 'C'.
        PERFORM RESET_LIST.
      ENDIF.
    WHEN 'SAVE'.          " FILE DOWNLOAD....
      LOOP AT IT_TAB WHERE UPDATE_CHK EQ 'U'.
        EXIT.
      ENDLOOP.
      IF SY-SUBRC EQ 0.
        PERFORM P2000_POPUP_MESSAGE.     " �޼��� �ڽ�.
        IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ���.
          PERFORM P3000_DATA_UPDATE.    " ����Ÿ �ݿ�.
          PERFORM P2000_DATA_UNLOCK.    " Unlocking
          LEAVE TO SCREEN 0.
        ENDIF.
      ELSE.
        MESSAGE E032.
      ENDIF.
    WHEN 'DOWN'.          " FILE DOWNLOAD....
      PERFORM P3000_TO_PC_DOWNLOAD.
    WHEN 'REFR'.
      LOOP AT IT_TAB WHERE UPDATE_CHK EQ 'U'.
        EXIT.
      ENDLOOP.
      IF SY-SUBRC EQ 0.
        PERFORM P2000_REFRESH_POPUP_MESSAGE.
        IF W_BUTTON_ANSWER EQ '1'.       " ���� �� ��������.
          PERFORM P3000_DATA_UPDATE.    " ����Ÿ �ݿ�.
          PERFORM P2000_DATA_UNLOCK.    " Unlocking
* �����Ƿ� ���̺� SELECT
          PERFORM   P1000_GET_ZVREQHD_ST      USING   W_ERR_CHK.
          IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* ����Ʈ ���� Text Table SELECT
          PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
          IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
          PERFORM RESET_LIST.
        ELSEIF W_BUTTON_ANSWER EQ '2'.    " �������� �ʰ� ��������.
          PERFORM P2000_DATA_UNLOCK.    " Unlocking
* �����Ƿ� ���̺� SELECT
          PERFORM   P1000_GET_ZVREQHD_ST      USING   W_ERR_CHK.
          IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* ����Ʈ ���� Text Table SELECT
          PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
          IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
          PERFORM RESET_LIST.
        ENDIF.
      ELSE.
* �����Ƿ� ���̺� SELECT
        PERFORM   P1000_GET_ZVREQHD_ST      USING   W_ERR_CHK.
        IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* ����Ʈ ���� Text Table SELECT
        PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
        IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
        PERFORM RESET_LIST.
      ENDIF.
    WHEN 'BAC1' OR 'EXIT' OR 'CANC'.
      LOOP AT IT_TAB WHERE UPDATE_CHK EQ 'U'.  " ������ ����Ÿ ����?
        EXIT.
      ENDLOOP.

      IF SY-SUBRC EQ 0.                     " DATA ����?
        PERFORM P2000_EXIT_POPUP_MESSAGE.  " �޼��� ��?
        IF W_BUTTON_ANSWER EQ '1'.         " ���� �� ���������� ��?
          PERFORM P3000_DATA_UPDATE.      " ����Ÿ ��?
          LEAVE TO SCREEN 0.              " ��?
        ELSEIF W_BUTTON_ANSWER EQ '2'.     " �������� �ʰ� ��������.
          LEAVE TO SCREEN 0.
        ENDIF.
      ELSE.
        LEAVE TO SCREEN 0.                " ��?
      ENDIF.
    WHEN OTHERS.
  ENDCASE.


*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
  SET  TITLEBAR 'ZIM06'.          " TITLE BAR
  P_NOOPEN = 'X'.                 " ������ ���.
  CLEAR : P_OPEN.                 " ������ ��� ���.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /55  '[ Open release(approve) ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 101 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
*           '��������'    ,  SY-VLINE NO-GAP,
            'Open dte'    ,  SY-VLINE NO-GAP,
            'P/O Number'    NO-GAP,  SY-VLINE NO-GAP,
            'CUR. '         NO-GAP,  SY-VLINE NO-GAP,
*'    ���� �ݾ�     '       NO-GAP,  SY-VLINE NO-GAP,
 '  Open amount     '       NO-GAP,  SY-VLINE NO-GAP,
            'Ty'            NO-GAP,  SY-VLINE NO-GAP,
            'Mat'           NO-GAP,  SY-VLINE NO-GAP,
            'Pay.'          NO-GAP,  SY-VLINE NO-GAP,
*   '     ��  ��  ��     '  NO-GAP,  SY-VLINE NO-GAP,
    '   Port of loading  '  NO-GAP,  SY-VLINE NO-GAP,
            'Inc'           NO-GAP,  SY-VLINE NO-GAP,
            'Vendor    '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
            'S'             NO-GAP,  SY-VLINE NO-GAP,
*           ' ���Ա��  '   NO-GAP,  SY-VLINE NO-GAP.
            'Loan organz'   NO-GAP,  SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
            'Req deli'    , SY-VLINE NO-GAP,
*           '���糳��'    , SY-VLINE NO-GAP,
*           '�����Ƿ�No'    NO-GAP,  SY-VLINE NO-GAP,
            'Imp req No'    NO-GAP,  SY-VLINE NO-GAP,
            '     '         NO-GAP,  SY-VLINE NO-GAP,
 '   USD Conv amt   '       NO-GAP,  SY-VLINE NO-GAP,
*'   USD ȯ��ݾ�   '       NO-GAP,  SY-VLINE NO-GAP,
            'TT'            NO-GAP,  SY-VLINE NO-GAP,
            'PGr'           NO-GAP,  SY-VLINE NO-GAP,
            'Plnt'          NO-GAP,  SY-VLINE NO-GAP,
    '    Arrival port    '  NO-GAP,  SY-VLINE NO-GAP,
*   '     ��  ��  ��     '  NO-GAP,  SY-VLINE NO-GAP,
            'VIA'           NO-GAP,  SY-VLINE NO-GAP,
            'Bene.     '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
            'C'             NO-GAP,  SY-VLINE NO-GAP,
            '  Remark   '   NO-GAP,  SY-VLINE NO-GAP.
*           ' ��������  '   NO-GAP,  SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_LC_REL'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME '�Ƿ� Release Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
FORM P2000_SET_SELETE_OPTION   USING    W_ERR_CHK.
*
  W_ERR_CHK = 'N'.

  IF P_NOOPEN IS INITIAL AND P_OPEN IS INITIAL.
    W_ERR_CHK = 'Y'.   MESSAGE S008.   EXIT.
  ENDIF.

* IF P_ERNAM IS INITIAL.       P_ERNAM = '%'.      ENDIF.
  IF P_NAME IS INITIAL.       P_NAME  =  '%'.      ENDIF.
*-----------------------------------------------------------------------
* ���� ������ ��� ��?
*-----------------------------------------------------------------------
  IF  ZTIMIMG00-ZFRELYN1 EQ 'X'.
    MOVE: 'I'      TO S_STATUS-SIGN,
          'EQ'     TO S_STATUS-OPTION,
          'R'      TO S_STATUS-LOW.
    APPEND S_STATUS.
  ELSE.
    MOVE: 'I'      TO S_STATUS-SIGN,
          'EQ'     TO S_STATUS-OPTION,
          'N'      TO S_STATUS-LOW.
    APPEND S_STATUS.
  ENDIF.
*-----------------------------------------------------------------------
* ������ ��� SETTING
*-----------------------------------------------------------------------
  IF P_NOOPEN EQ 'X'.
    MOVE: 'I'      TO S_STATU2-SIGN,
          'EQ'     TO S_STATU2-OPTION,
          'N'      TO S_STATU2-LOW.
    APPEND S_STATU2.

    MOVE: 'I'      TO S_STATU2-SIGN,
          'EQ'     TO S_STATU2-OPTION,
          'C'      TO S_STATU2-LOW.
    APPEND S_STATU2.
  ENDIF.

*-----------------------------------------------------------------------
* ������ ��� ��� SETTING
*-----------------------------------------------------------------------
  IF P_OPEN EQ 'X'.
    MOVE: 'I'      TO S_STATU2-SIGN,
          'EQ'     TO S_STATU2-OPTION,
          'R'      TO S_STATU2-LOW.
    APPEND S_STATU2.
  ENDIF.

ENDFORM.                    " P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZVREQHD_ST
*&---------------------------------------------------------------------*
FORM P1000_GET_ZVREQHD_ST   USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting

  SELECT * INTO TABLE IT_ZVREQ FROM ZVREQHD_ST
                               WHERE ZFAPPDT    IN     S_APPDT
                               AND   ZFOPBN     IN     S_OPBN
                               AND   ZFMATGB    IN     S_MATGB
                               AND   ZFREQTY    IN     S_REQTY
                               AND   ZFOPBN     NE     SPACE
                               AND   ZFWERKS    IN     S_WERKS
                               AND   EKORG      IN     S_EKORG
                               AND   ERNAM      LIKE   P_NAME
                               AND   ZFRLST1    IN     S_STATUS
                               AND   ZFRLST2    IN     S_STATU2
                               AND   EBELN      IN     S_EBELN
                               AND   LIFNR      IN     S_LIFNR
                               AND   ZFBENI     IN     S_ZFBENI
                               AND   EKGRP      IN     S_EKGRP
                               AND   ZFREQNO    IN     S_REQNO
                               AND   ZFRVDT     GT     '00000000'
                               AND   ZFDOCST    EQ     'N'
                               AND   ZFAMDNO    EQ     '00000'
                               AND   ZFCLOSE    EQ     SPACE.
*                              AND   LOEKZ      EQ     SPACE.

  IF SY-SUBRC NE 0.               " Not Found?
    W_ERR_CHK = 'Y'.  MESSAGE S009.    EXIT.
  ENDIF.

ENDFORM.                    " P1000_GET_ZVREQHD_ST
*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK           USING   W_ERR_CHK.
  W_ERR_CHK = 'N'.
* Import Config Select
  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
    W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

  IF ZTIMIMG00-ZFRELYN2 IS INITIAL.
    W_ERR_CHK = 'Y'.   MESSAGE S959.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.
  REFRESH : IT_TAB.

  LOOP AT IT_ZVREQ.

    W_TABIX = SY-TABIX.

    MOVE-CORRESPONDING IT_ZVREQ  TO  IT_TAB.
    MOVE : IT_ZVREQ-ZFLEVN       TO  IT_TAB-ZFLEVN,
           IT_ZVREQ-ZFOPBN       TO  IT_TAB-ZFOPBN.

*-----------------------------------------------------------------------
* VENDOR MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
    CLEAR : LFA1.
    CALL FUNCTION 'READ_LFA1'
         EXPORTING
              XLIFNR         = IT_TAB-LIFNR
         IMPORTING
              XLFA1          = LFA1
         EXCEPTIONS
              KEY_INCOMPLETE = 01
              NOT_AUTHORIZED = 02
              NOT_FOUND      = 03.

    CASE SY-SUBRC.
      WHEN 01.     MESSAGE E022.
      WHEN 02.     MESSAGE E950.
      WHEN 03.     MESSAGE E020   WITH    IT_TAB-LIFNR.
    ENDCASE.
    MOVE: LFA1-NAME1   TO   IT_TAB-NAME1.
*-----------------------------------------------------------------------
* Bene. MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
    CLEAR : LFA1.
    CALL FUNCTION 'READ_LFA1'
         EXPORTING
              XLIFNR         = IT_TAB-ZFBENI
         IMPORTING
              XLFA1          = LFA1
         EXCEPTIONS
              KEY_INCOMPLETE = 01
              NOT_AUTHORIZED = 02
              NOT_FOUND      = 03.

    CASE SY-SUBRC.
      WHEN 01.     MESSAGE E022.
      WHEN 02.     MESSAGE E950.
      WHEN 03.     MESSAGE E020   WITH    IT_TAB-LIFNR.
    ENDCASE.
    MOVE: LFA1-NAME1   TO   IT_TAB-NAME2.

*-----------------------------------------------------------------------
* Opeb Bank. MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
    CLEAR : LFA1.
    CALL FUNCTION 'READ_LFA1'
         EXPORTING
              XLIFNR         = IT_TAB-ZFOPBN
         IMPORTING
              XLFA1          = LFA1
         EXCEPTIONS
              KEY_INCOMPLETE = 01
              NOT_AUTHORIZED = 02
              NOT_FOUND      = 03.

    CASE SY-SUBRC.
*        WHEN 01.     MESSAGE E022.
      WHEN 02.     MESSAGE E950.
      WHEN 03.     MESSAGE E020   WITH    IT_TAB-ZFOPBN.
    ENDCASE.
    MOVE: LFA1-NAME1   TO   IT_TAB-NAME3.
*-----------------------------------------------------------------------
* ���Ա��   MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
    CLEAR : LFA1.
    CALL FUNCTION 'READ_LFA1'
         EXPORTING
              XLIFNR         = IT_TAB-ZFLEVN
         IMPORTING
              XLFA1          = LFA1
         EXCEPTIONS
              KEY_INCOMPLETE = 01
              NOT_AUTHORIZED = 02
              NOT_FOUND      = 03.

    CASE SY-SUBRC.
*        WHEN 01.     MESSAGE E022.
      WHEN 02.     MESSAGE E950.
      WHEN 03.     MESSAGE E020   WITH    IT_TAB-ZFLEVN.
    ENDCASE.
    MOVE: LFA1-NAME1   TO   IT_TAB-NAME4.

    WRITE : IT_TAB-ZFOPAMT  CURRENCY IT_TAB-WAERS TO IT_TAB-ZFOPAMT1,
            IT_TAB-ZFUSDAM  CURRENCY IT_TAB-ZFUSD TO IT_TAB-ZFUSDAM1.

    APPEND  IT_TAB.
  ENDLOOP.
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
    WRITE : / 'Total', W_COUNT, 'case'.
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
       IT_TAB-ZFAPPDT NO-GAP,            " ������û?
       SY-VLINE NO-GAP,
       IT_TAB-EBELN   NO-GAP,            " ���Ź�?
       SY-VLINE NO-GAP,
       IT_TAB-WAERS NO-GAP,              " currency
       SY-VLINE NO-GAP,
       IT_TAB-ZFOPAMT CURRENCY IT_TAB-WAERS NO-GAP,
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

  CASE IT_TAB-ZFRLST2.
    WHEN 'N'.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
    WHEN 'R'.
      FORMAT COLOR COL_TOTAL    INTENSIFIED OFF.
    WHEN 'C'.
      FORMAT COLOR COL_GROUP    INTENSIFIED OFF.
    WHEN OTHERS.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
  ENDCASE.
  WRITE : IT_TAB-ZFRLST2 NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE : IT_TAB-NAME4 NO-GAP, SY-VLINE.         " ���Ա��?

* hide
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE:/ SY-VLINE, ' ',
       SY-VLINE NO-GAP,
*       IT_TAB-NAME3 ,                       " ���� ��?
       IT_TAB-ZFMAUD,                       " ���糳?
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
       ' ' NO-GAP,
       SY-VLINE NO-GAP,
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
*&      Form  P3000_RELEASED_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_RELEASED_UPDATE USING    RELEASED.

  LOOP  AT   IT_SELECTED.
    IF RELEASED EQ 'R'.
      IF IT_SELECTED-ZFRLST2 EQ 'R'.
        MESSAGE I028 WITH IT_SELECTED-ZFREQNO.
        CONTINUE.
      ENDIF.
    ELSEIF RELEASED EQ 'C'.
      IF IT_SELECTED-ZFRLST2 EQ 'C'.
        MESSAGE I029 WITH IT_SELECTED-ZFREQNO.
        CONTINUE.
      ENDIF.
    ENDIF.

    READ TABLE IT_TAB WITH KEY  ZFREQNO = IT_SELECTED-ZFREQNO.
    IF SY-SUBRC NE 0.
      MESSAGE I030 WITH IT_SELECTED-ZFREQNO.
      CONTINUE.
    ENDIF.
    W_TABIX = SY-TABIX.

*-----------------------------------------------------------------------
*   �ļ� �۾� üũ....
*-----------------------------------------------------------------------
    IF RELEASED EQ 'C'.
      PERFORM P2000_UNRELEASE_CHECK USING IT_TAB-ZFREQNO.
    ENDIF.

    IF IT_TAB-UPDATE_CHK NE 'U'.
*-----------------------------------------------------------------------
* lock checking...
*-----------------------------------------------------------------------
      CALL FUNCTION 'ENQUEUE_EZ_IM_ZTREQDOC'
           EXPORTING
                ZFREQNO = IT_TAB-ZFREQNO
                ZFAMDNO = '00000'
           EXCEPTIONS
                OTHERS  = 1.
      IF SY-SUBRC <> 0.
        MESSAGE I510 WITH SY-MSGV1 'Import Document'
                          IT_TAB-ZFREQNO '00000'
                RAISING DOCUMENT_LOCKED.
        CONTINUE.
      ENDIF.
    ENDIF.

    IT_TAB-UPDATE_CHK = 'U'.                " DB �ݿ� ��?
    IT_TAB-MARK = 'X'.
    IT_TAB-ZFRLST2 = RELEASED.              " ������ ��?
    IF RELEASED EQ 'R'.
      IT_TAB-ZFRLDT2 = SY-DATUM.            " ������ ��?
      IT_TAB-ZFRLNM2 = SY-UNAME.          " ������ �����.
    ELSEIF RELEASED EQ 'N'.
      CLEAR : IT_TAB-ZFRLDT2, IT_TAB-ZFRLNM2.
    ENDIF.

    MODIFY IT_TAB INDEX W_TABIX.
    W_UPDATE_CNT = W_UPDATE_CNT + 1.
  ENDLOOP.

ENDFORM.                    " P3000_RELEASED_UPDATE
*&---------------------------------------------------------------------*
*&      Form  P2000_UNRELEASE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_UNRELEASE_CHECK USING    P_ZFREQNO.
* Amend ���翩�� ü?

* Invoice ü?

ENDFORM.                    " P2000_UNRELEASE_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POPUP_MESSAGE.

* CALL  FUNCTION  'POPUP_TO_CONFIRM'
*       EXPORTING
*           TITLEBAR        = '������(����)�۾� ���� Ȯ��'
*           DIAGNOSE_OBJECT = ''
*           TEXT_QUESTION   =
*                    '������(����) ���� �۾��� ��� �����Ͻðڽ��ϱ�?'
*           TEXT_BUTTON_1   = 'Ȯ    ��'
*           TEXT_BUTTON_2   = '�� �� ��'
*           DEFAULT_BUTTON  = '1'
*           DISPLAY_CANCEL_BUTTON = 'X'
*           START_COLUMN    = 30
*           START_ROW       = 8
*       IMPORTING
*           ANSWER          =  W_BUTTON_ANSWER.

  CALL  FUNCTION  'POPUP_TO_CONFIRM'
        EXPORTING
            TITLEBAR        = 'Release(Approve) confirm'
            DIAGNOSE_OBJECT = ''
            TEXT_QUESTION   =
                   'Do you want to continue with release and save job?'
            TEXT_BUTTON_1   = 'Yes'
            TEXT_BUTTON_2   = 'No'
            DEFAULT_BUTTON  = '1'
            DISPLAY_CANCEL_BUTTON = 'X'
            START_COLUMN    = 30
            START_ROW       = 8
        IMPORTING
            ANSWER          =  W_BUTTON_ANSWER.

ENDFORM.                    " P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_DATA_UPDATE.

  LOOP AT IT_TAB   WHERE UPDATE_CHK EQ 'U'.

    CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_RELEASE'
         EXPORTING
              W_ZFREQNO = IT_TAB-ZFREQNO
              W_ZFAMDNO = '00000'
              W_ZFRLST1 = ''
              W_ZFRLST2 = IT_TAB-ZFRLST2.

* �����Ƿ� ���� table Select
*      SELECT SINGLE * FROM   ZTREQST
*                      WHERE  ZFREQNO EQ IT_TAB-ZFREQNO
*                      AND    ZFAMDNO EQ '00'.
*
*-----------------------------------------------------------------------
* ���� data�� Temp Table�� Move
*-----------------------------------------------------------------------

* ���� ����Ÿ Move
*      MOVE : IT_TAB-ZFRLST2  TO  ZTREQST-ZFRLST2,     " ������ ��?
*             IT_TAB-ZFRLDT2  TO  ZTREQST-ZFRLDT2,     " ������ ��?
*             IT_TAB-ZFRLNM2  TO  ZTREQST-ZFRLNM2.     " ���?
*
*      UPDATE ZTREQST.                                 " DATA UPDATE
*      IF SY-SUBRC EQ 0.
*-----------------------------------------------------------------------
* �����̷� ��?
*-----------------------------------------------------------------------
*        PERFORM  SET_LC_HEADER_CHANGE_DOCUMENT.      " ���� ��?
*      ELSE.
*         MESSAGE E031 WITH ZTREQHD-ZFREQNO.
*         ROLLBACK WORK.                               " ����?
*      ENDIF.

  ENDLOOP.

*  IF SY-SUBRC EQ 0.
*     COMMIT WORK.                                   " �������� ��?
*  ENDIF.

ENDFORM.                    " P3000_DATA_UPDATE

*&---------------------------------------------------------------------*
*&      Form  P2000_REFRESH_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_REFRESH_POPUP_MESSAGE.

* CALL  FUNCTION  'POPUP_TO_CONFIRM'
*       EXPORTING
*           TITLEBAR        = '����Ʈ REFRESH Ȯ��'
*           DIAGNOSE_OBJECT = ''
*           TEXT_QUESTION = '���� ������(����) �۾��� �����Ͻðڽ��ϱ�?'
*           TEXT_BUTTON_1   = 'Ȯ    ��'
*           TEXT_BUTTON_2   = '�� �� ��'
*           DEFAULT_BUTTON  = '1'
*           DISPLAY_CANCEL_BUTTON = 'X'
*           START_COLUMN    = 30
*           START_ROW       = 8
*       IMPORTING
*           ANSWER          =  W_BUTTON_ANSWER.

  CALL  FUNCTION  'POPUP_TO_CONFIRM'
        EXPORTING
           TITLEBAR        = 'List refresh confirm'
           DIAGNOSE_OBJECT = ''
           TEXT_QUESTION = 'Do you want to save first of all?'
           TEXT_BUTTON_1   = 'Yes'
           TEXT_BUTTON_2   = 'No'
           DEFAULT_BUTTON  = '1'
           DISPLAY_CANCEL_BUTTON = 'X'
           START_COLUMN    = 30
           START_ROW       = 8
        IMPORTING
           ANSWER          =  W_BUTTON_ANSWER.

ENDFORM.                    " P2000_REFRESH_POPUP_MESSAGE

*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_EXIT_POPUP_MESSAGE.

* CALL  FUNCTION  'POPUP_TO_CONFIRM'
*       EXPORTING
*           TITLEBAR        = '����Ʈ���� Ȯ��'
*           DIAGNOSE_OBJECT = ''
*           TEXT_QUESTION = '���� ������(����) �۾��� �����Ͻðڽ��ϱ�?'
*           TEXT_BUTTON_1   = 'Ȯ    ��'
*           TEXT_BUTTON_2   = '�� �� ��'
*           DEFAULT_BUTTON  = '1'
*           DISPLAY_CANCEL_BUTTON = 'X'
*           START_COLUMN    = 30
*           START_ROW       = 8
*       IMPORTING
*           ANSWER          =  W_BUTTON_ANSWER.
  CALL  FUNCTION  'POPUP_TO_CONFIRM'
        EXPORTING
           TITLEBAR        = 'End confirm'
           DIAGNOSE_OBJECT = ''
           TEXT_QUESTION = 'Do you want to save first of all?'
           TEXT_BUTTON_1   = 'Yes'
           TEXT_BUTTON_2   = 'No'
           DEFAULT_BUTTON  = '1'
           DISPLAY_CANCEL_BUTTON = 'X'
           START_COLUMN    = 30
           START_ROW       = 8
        IMPORTING
           ANSWER          =  W_BUTTON_ANSWER.

ENDFORM.                    " P2000_EXIT_POPUP_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_DATA_UNLOCK
*&---------------------------------------------------------------------*
FORM P2000_DATA_UNLOCK.

  LOOP AT IT_TAB   WHERE UPDATE_CHK EQ 'U'.

    CALL FUNCTION 'DEQUEUE_EZ_IM_ZTREQDOC'
         EXPORTING
              ZFREQNO = IT_TAB-ZFREQNO
              ZFAMDNO = '00000'.

  ENDLOOP.

ENDFORM.                    " P2000_DATA_UNLOCK
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
*&      Form  P1000_SET_BUKRS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_SET_BUKRS.

   CLEAR : ZTIMIMG00, P_BUKRS.
   SELECT SINGLE * FROM ZTIMIMG00.
   IF NOT ZTIMIMG00-ZFBUFIX IS INITIAL.
      MOVE  ZTIMIMG00-ZFBUKRS   TO  P_BUKRS.
   ENDIF.

*>> ȸ���ڵ� SET.
    MOVE: 'I'          TO S_BUKRS-SIGN,
          'EQ'         TO S_BUKRS-OPTION,
          P_BUKRS      TO S_BUKRS-LOW.
    APPEND S_BUKRS.

ENDFORM.                    " P1000_SET_BUKRS
