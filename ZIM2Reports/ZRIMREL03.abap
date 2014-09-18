*&---------------------------------------------------------------------*
*& Report  ZRIMREL03                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� Release ( Approve ) �����Ƿ� Amend Documents     *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.04.17                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : Config���� ���� Released ���θ� Check�Ͽ��߸� �Ѵ�.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMREL03    MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.


*-----------------------------------------------------------------------
* �����Ƿ� ������� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK       TYPE C,                        " MARK
       W_GB01(1)  TYPE C VALUE ';',
       UPDATE_CHK TYPE C,                        " DB �ݿ� ����...
       W_GB02(1)  TYPE C VALUE ';',
       ZFREQDT    LIKE ZTREQST-ZFREQDT,          " �䰳����?
       W_GB03(1)  TYPE C VALUE ';',
       ZFMAUD     LIKE ZTREQHD-ZFMAUD,           " ���糳��?
       W_GB04(1)  TYPE C VALUE ';',
       EBELN      LIKE ZTREQHD-EBELN,            " Purchasing document
       W_GB05(1)  TYPE C VALUE ';',
       ZFREQNO    LIKE ZTREQHD-ZFREQNO,          " �����Ƿ� ��?
       W_GB06(1)  TYPE C VALUE ';',
       ZFAMDNO    LIKE ZTREQST-ZFAMDNO,          " Amend Seq.
       W_GB07(1)  TYPE C VALUE ';',
       ZFOPAMT1(18) TYPE C,                      " �����ݾ� TEXT
       W_GB08(1)  TYPE C VALUE ';',
       WAERS      LIKE ZTREQST-WAERS,            " Currency
       W_GB09(1)  TYPE C VALUE ';',
       ZFUSDAM1(18) TYPE C,                      " USD ȯ��ݾ� TEXT
       W_GB10(1)  TYPE C VALUE ';',
       ZFUSD      LIKE ZTREQST-ZFUSD,            " USD Currency
       W_GB11(1)  TYPE C VALUE ';',
       ZFREQTY    LIKE ZTREQST-ZFREQTY,          " ������?
       W_GB12(1)  TYPE C VALUE ';',
       ZFBACD     LIKE ZTREQHD-ZFBACD,           " ����/���� ��?
       W_GB13(1)  TYPE C VALUE ';',
       EKORG      LIKE ZTREQST-EKORG,            " Purchasing organizati
       W_GB14(1)  TYPE C VALUE ';',
       EKGRP      LIKE ZTREQST-EKGRP,            " Purchasing group
       W_GB15(1)  TYPE C VALUE ';',
       ZFWERKS    LIKE ZTREQHD-ZFWERKS,          " ��ǥ Plant
       W_GB16(1)  TYPE C VALUE ';',
       ERNAM      LIKE ZTREQST-ERNAM,            " ���Ŵ�?
       W_GB17(1)  TYPE C VALUE ';',
       LIFNR      LIKE ZTREQHD-LIFNR,            " Vendor Code
       W_GB18(1)  TYPE C VALUE ';',
*      NAME1(33)  TYPE C,                        " Name 1
       NAME1      LIKE LFA1-NAME1,               " Name 1
       W_GB19(1)  TYPE C VALUE ';',
       ZFBENI     LIKE ZTREQHD-ZFBENI,           " Beneficairy
       W_GB20(1)  TYPE C VALUE ';',
       NAME2      LIKE LFA1-NAME1,               " Name 1
       W_GB21(1)  TYPE C VALUE ';',
       ZFRLST1    LIKE ZTREQST-ZFRLST1,          " �Ƿ� Release ��?
       W_GB22(1)  TYPE C VALUE ';',
       ZFRLDT1    LIKE ZTREQST-ZFRLDT1,          " �Ƿ� Release ��?
       W_GB23(1)  TYPE C VALUE ';',
       ZFRLNM1    LIKE ZTREQST-ZFRLNM1,          " �Ƿ� Release ���?
       W_GB24(1)  TYPE C VALUE ';',
       ZFCLOSE    LIKE ZTREQHD-ZFCLOSE,          " �����Ƿ� ���Ῡ?
       W_GB25(1)  TYPE C VALUE ';',
       ZFRLST2    LIKE ZTREQST-ZFRLST2,          " ���� Release ��?
       W_GB40(1)  TYPE C VALUE ';',
       ZFOPAMT    LIKE ZTREQST-ZFOPAMT,         " ������?
       W_GB41(1)  TYPE C VALUE ';',
       ZFUSDAM    LIKE ZTREQST-ZFUSDAM,          " USD ȯ���?
       W_GB26(1)  TYPE C VALUE ';'.
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
   SELECT-OPTIONS: S_EBELN   FOR ZTREQHD-EBELN,    " Purchasing document
                   S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� ������?
                   S_LIFNR   FOR ZTREQHD-LIFNR,    " vendor
                   S_ZFBENI  FOR ZTREQHD-ZFBENI,   " Beneficiary
                   S_ZFMAUD  FOR ZTREQHD-ZFMAUD,   " ���糳?
                   S_REQDT   FOR ZTREQST-ZFREQDT,  " �䰳����?
                   S_CDAT    FOR ZTREQST-CDAT,     " Created on
                   S_WERKS   FOR ZTREQHD-ZFWERKS,  " Plant
                   S_MATNR   FOR ZTREQIT-MATNR.    " Mateial code
   PARAMETERS :    P_EKGRP   LIKE ZTREQST-EKGRP,
                   P_EKORG   LIKE ZTREQST-EKORG,
                   P_ERNAM   LIKE ZTREQST-ERNAM.
   SELECT-OPTIONS: S_REQTY   FOR ZTREQHD-ZFREQTY.  " �����Ƿ� Type
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
* SORT ����?
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFREQDT'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
* ��ü ���� �� ������?
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'DISP' OR 'DIS1'.    " L/C ��ȸ �� AMEND
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_SHOW_LC USING IT_SELECTED-ZFREQNO
                                        IT_SELECTED-ZFAMDNO.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'RESV'.          " ������ + ��?
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
            PERFORM P3000_RELEASED_UPDATE USING 'R'.
            LOOP AT IT_TAB WHERE UPDATE_CHK EQ 'U'.
               EXIT.
            ENDLOOP.
            IF SY-SUBRC EQ 0.
                PERFORM P2000_POPUP_MESSAGE.     " �޼��� ��?
                IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ��?
                   PERFORM P3000_DATA_UPDATE.    " ����Ÿ ��?
                   PERFORM P2000_DATA_UNLOCK.    " Unlocking
                   LEAVE TO SCREEN 0.
                ENDIF.
            ELSE.
                MESSAGE E032.
            ENDIF.
         ELSE.
            MESSAGE E032.
         ENDIF.
      WHEN 'FRGS'.          " ����?
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
            PERFORM P3000_RELEASED_UPDATE USING 'R'.
            PERFORM RESET_LIST.
         ENDIF.
      WHEN 'FRGR'.          " ������ ��?
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
             PERFORM P2000_POPUP_MESSAGE.     " �޼��� ��?
             IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ��?
                PERFORM P3000_DATA_UPDATE.    " ����Ÿ ��?
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
                PERFORM P3000_DATA_UPDATE.    " ����Ÿ ��?
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
  SET  TITLEBAR 'ZIM14'.          " TITLE BAR
  P_NOOPEN = 'X'.                 " ������ ��?
  CLEAR : P_OPEN.                 " ������ ��� ��?
ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /53  '[ �����Ƿ� Amend ��û ��� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 101 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
            '�䰳����'    ,  SY-VLINE NO-GAP,
            'P/O Number'    NO-GAP,  SY-VLINE NO-GAP,
            'CUR. '         NO-GAP,  SY-VLINE NO-GAP,
 '    ���� �ݾ�     '       NO-GAP,  SY-VLINE NO-GAP,
            'Ty'            NO-GAP,  SY-VLINE NO-GAP,
            'POrg'          NO-GAP,  SY-VLINE NO-GAP,
            ' ��ǥ Plant '  NO-GAP,  SY-VLINE NO-GAP,
            'Vendor    '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
            'S'             NO-GAP,  SY-VLINE NO-GAP.
*            'Release Date'   NO-GAP,  SY-VLINE NO-GAP,
*            'Release �����' NO-GAP,  SY-VLINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',  SY-VLINE,
            '���糳��'    ,  SY-VLINE NO-GAP,
            '�����Ƿ�No'    NO-GAP,  SY-VLINE NO-GAP,
            '     '         NO-GAP,  SY-VLINE NO-GAP,
 '   USD ȯ��ݾ�   '       NO-GAP,  SY-VLINE NO-GAP,
            'TT'            NO-GAP,  SY-VLINE NO-GAP,
            'PGrp'          NO-GAP,  SY-VLINE NO-GAP,
            '  ���Ŵ��  '  NO-GAP,  SY-VLINE NO-GAP,
            'Bene.     '    NO-GAP,  SY-VLINE NO-GAP,
            'Name',              118 SY-VLINE NO-GAP,
            'C'             NO-GAP,  SY-VLINE NO-GAP.
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

  IF P_EKORG IS INITIAL.       P_EKORG = '%'.      ENDIF.
  IF P_EKGRP IS INITIAL.       P_EKGRP = '%'.      ENDIF.
  IF P_ERNAM IS INITIAL.       P_ERNAM = '%'.      ENDIF.
*-----------------------------------------------------------------------
* ������ ��� SETTING
*-----------------------------------------------------------------------
  IF P_NOOPEN EQ 'X'.
     MOVE: 'I'      TO S_STATUS-SIGN,
           'EQ'     TO S_STATUS-OPTION,
           'N'      TO S_STATUS-LOW.
     APPEND S_STATUS.

     MOVE: 'I'      TO S_STATUS-SIGN,
           'EQ'     TO S_STATUS-OPTION,
           'C'      TO S_STATUS-LOW.
     APPEND S_STATUS.
  ENDIF.

*-----------------------------------------------------------------------
* ������ ��� ��� SETTING
*-----------------------------------------------------------------------
  IF P_OPEN EQ 'X'.
     MOVE: 'I'      TO S_STATUS-SIGN,
           'EQ'     TO S_STATUS-OPTION,
           'R'      TO S_STATUS-LOW.
     APPEND S_STATUS.
  ENDIF.

* ���� RELEASE BIT ��뿩�� CHECK....
  IF ZTIMIMG00-ZFRELYN2 EQ 'X'.
     MOVE: 'I'      TO S_STATU2-SIGN,
           'EQ'     TO S_STATU2-OPTION,
           'N'      TO S_STATU2-LOW.
     APPEND S_STATU2.
     MOVE: 'I'      TO S_STATU2-SIGN,
           'EQ'     TO S_STATU2-OPTION,
           'C'      TO S_STATU2-LOW.
     APPEND S_STATU2.
  ELSE.
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
                               WHERE EBELN      IN     S_EBELN
                               AND   ZFREQNO    IN     S_REQNO
                               AND   LIFNR      IN     S_LIFNR
                               AND   ZFBENI     IN     S_ZFBENI
                               AND   ZFMAUD     IN     S_ZFMAUD
                               AND   ZFREQDT    IN     S_REQDT
                               AND   CDAT       IN     S_CDAT
                               AND   ZFWERKS    IN     S_WERKS
*                              AND   MATNR      IN     S_MATNR
                               AND   ZFREQTY    IN     S_REQTY
                               AND   ZFRLST1    IN     S_STATUS
                               AND   ZFRLST2    IN     S_STATU2
                               AND ( ZFRVDT     EQ     '00000000'
                               OR    ZFRVDT     EQ     SPACE
                               OR    ZFRVDT     EQ     '        ' )
                               AND   EKORG      LIKE   P_EKORG
                               AND   EKGRP      LIKE   P_EKGRP
                               AND   ERNAM      LIKE   P_ERNAM
                               AND   ZFAMDNO    GT     '00000'
                               AND   ZFDOCST    EQ     'N'
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

  IF ZTIMIMG00-ZFRELYN3 IS INITIAL.
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
* Material Code Check
*      SELECT COUNT( * ) INTO W_COUNT FROM ZTREQIT
*                        WHERE ZFREQNO  EQ  IT_ZVREQ-ZFREQNO
*                        AND   MATNR    IN  S_MATNR.
*      IF W_COUNT < 1.
*         DELETE IT_ZVREQ INDEX W_TABIX.
*         CONTINUE.
*      ENDIF.

      MOVE-CORRESPONDING IT_ZVREQ  TO  IT_TAB.
*-----------------------------------------------------------------------
* VENDOR MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CLEAR : LFA1.
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
* VENDOR MASTER SELECT( LFA1 )
*-----------------------------------------------------------------------
      CLEAR : LFA1.
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

      WRITE : IT_TAB-ZFOPAMT  CURRENCY IT_TAB-WAERS TO IT_TAB-ZFOPAMT1,
              IT_TAB-ZFUSDAM  CURRENCY IT_TAB-ZFUSD TO IT_TAB-ZFUSDAM1.

      APPEND  IT_TAB.
   ENDLOOP.
ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIM14'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIM14'.           " GUI TITLE SETTING..

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
       IT_TAB-ZFREQDT NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-EBELN   NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-WAERS NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFOPAMT  CURRENCY IT_TAB-WAERS NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFREQTY NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-EKORG   NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFWERKS NO-GAP,               " ��ǥ Plant
       73 SY-VLINE NO-GAP,
       IT_TAB-LIFNR   NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-NAME1   NO-GAP,
   118 SY-VLINE NO-GAP.

  CASE IT_TAB-ZFRLST1.
     WHEN 'N'.
        FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
     WHEN 'R'.
        FORMAT COLOR COL_TOTAL    INTENSIFIED OFF.
     WHEN 'C'.
        FORMAT COLOR COL_GROUP    INTENSIFIED OFF.
     WHEN OTHERS.
        FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
  ENDCASE.
  WRITE : IT_TAB-ZFRLST1 NO-GAP, SY-VLINE NO-GAP.
* hide
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE:/ SY-VLINE, ' ',
       SY-VLINE NO-GAP,
       IT_TAB-ZFMAUD NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFREQNO NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFUSD NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFUSDAM  CURRENCY IT_TAB-ZFUSD NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFBACD,
       SY-VLINE NO-GAP,
       IT_TAB-EKGRP,
       SY-VLINE NO-GAP,
       IT_TAB-ERNAM   NO-GAP,               " ���� ��?
       SY-VLINE NO-GAP,
       IT_TAB-ZFBENI  NO-GAP,               " Beneficiary
       SY-VLINE NO-GAP,
       IT_TAB-NAME2   NO-GAP,
   118 SY-VLINE NO-GAP,
       IT_TAB-ZFCLOSE NO-GAP,
       SY-VLINE.

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
       IF IT_SELECTED-ZFRLST1 EQ 'R'.
          MESSAGE I028 WITH IT_SELECTED-ZFREQNO.
          CONTINUE.
       ENDIF.
    ELSEIF RELEASED EQ 'C'.
       IF IT_SELECTED-ZFRLST1 EQ 'C'.
          MESSAGE I029 WITH IT_SELECTED-ZFREQNO.
          CONTINUE.
       ENDIF.
    ENDIF.

    READ TABLE IT_TAB WITH KEY  ZFREQNO = IT_SELECTED-ZFREQNO
                                ZFAMDNO = IT_SELECTED-ZFAMDNO.
    IF SY-SUBRC NE 0.
       MESSAGE I030 WITH IT_SELECTED-ZFREQNO.
       CONTINUE.
    ENDIF.
    W_TABIX = SY-TABIX.

*-----------------------------------------------------------------------
*   �ļ� �۾� üũ....
*-----------------------------------------------------------------------
    IF RELEASED EQ 'C'.
       SELECT SINGLE * FROM ZTREQST
                       WHERE ZFREQNO EQ IT_SELECTED-ZFREQNO
                       AND   ZFAMDNO EQ IT_SELECTED-ZFAMDNO.
       IF NOT ZTREQST-ZFRVDT IS INITIAL.
          MESSAGE I333 WITH IT_SELECTED-ZFREQNO
                            IT_SELECTED-ZFAMDNO.
          CONTINUE.
       ENDIF.
    ENDIF.

    IF IT_TAB-UPDATE_CHK NE 'U'.
*-----------------------------------------------------------------------
* lock checking...
*-----------------------------------------------------------------------
       CALL FUNCTION 'ENQUEUE_EZ_IM_ZTREQDOC'
          EXPORTING
             ZFREQNO                =     IT_TAB-ZFREQNO
             ZFAMDNO                =     IT_TAB-ZFAMDNO
          EXCEPTIONS
              OTHERS        = 1.
       IF SY-SUBRC <> 0.
          MESSAGE I510 WITH SY-MSGV1 'Import Document'
                            IT_TAB-ZFREQNO IT_TAB-ZFAMDNO
                  RAISING DOCUMENT_LOCKED.
          CONTINUE.
       ENDIF.
    ENDIF.

    IT_TAB-ZFRLST1 = RELEASED.              " ������ ��?
    IT_TAB-UPDATE_CHK = 'U'.                " DB �ݿ� ��?
    IT_TAB-MARK = 'X'.

    IF RELEASED EQ 'R'.
       IT_TAB-ZFRLDT1 = SY-DATUM.            " ������ ��?
       IT_TAB-ZFRLNM1 = SY-UNAME.          " ������ �����.
    ELSEIF RELEASED EQ 'N'.
       CLEAR : IT_TAB-ZFRLDT1, IT_TAB-ZFRLNM1.
    ENDIF.

    MODIFY IT_TAB INDEX W_TABIX.
    W_UPDATE_CNT = W_UPDATE_CNT + 1.
  ENDLOOP.

ENDFORM.                    " P3000_RELEASED_UPDATE
*&---------------------------------------------------------------------*
*&      Form  P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POPUP_MESSAGE.

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = '������(����)�۾� ���� Ȯ��'
             DIAGNOSE_OBJECT = ''
             TEXT_QUESTION   =
                      '������(����) ���� �۾��� ��� �����Ͻðڽ��ϱ�?'
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
*&      Form  P3000_DATA_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_DATA_UPDATE.

  LOOP AT IT_TAB   WHERE UPDATE_CHK EQ 'U'.

     CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_RELEASE'
        EXPORTING
           W_ZFREQNO     =    IT_TAB-ZFREQNO
           W_ZFAMDNO     =    IT_TAB-ZFAMDNO
           W_ZFRLST1     =    IT_TAB-ZFRLST1
           W_ZFRLST2     =    ''.

* �����Ƿ� ���� table Select
*     SELECT SINGLE * FROM   ZTREQST
*                     WHERE  ZFREQNO EQ IT_TAB-ZFREQNO
*                     AND    ZFAMDNO EQ IT_TAB-ZFAMDNO.
*
*-----------------------------------------------------------------------
* ���� data�� Temp Table�� Move
*-----------------------------------------------------------------------

* ���� ����Ÿ Move
*     MOVE : IT_TAB-ZFRLST1  TO  ZTREQST-ZFRLST1,     " ������ ��?
*            IT_TAB-ZFRLDT1  TO  ZTREQST-ZFRLDT1,     " ������ ��?
*            IT_TAB-ZFRLNM1  TO  ZTREQST-ZFRLNM1.     " ���?
*
*     UPDATE ZTREQST.                                 " DATA UPDATE
*     IF SY-SUBRC EQ 0.
*-----------------------------------------------------------------------
* �����̷� ��?
*-----------------------------------------------------------------------
*        PERFORM  SET_LC_HEADER_CHANGE_DOCUMENT.      " ���� ��?
*     ELSE.
*        MESSAGE E031 WITH ZTREQHD-ZFREQNO.
*        ROLLBACK WORK.                               " ����?
*     ENDIF.
*
  ENDLOOP.
*
* IF SY-SUBRC EQ 0.
*    COMMIT WORK.                                   " �������� ��?
* ENDIF.

ENDFORM.                    " P3000_DATA_UPDATE

*&---------------------------------------------------------------------*
*&      Form  P2000_REFRESH_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_REFRESH_POPUP_MESSAGE.

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = '����Ʈ REFRESH Ȯ��'
             DIAGNOSE_OBJECT = ''
            TEXT_QUESTION = '���� ������(����) �۾��� �����Ͻðڽ��ϱ�?'
             TEXT_BUTTON_1   = 'Ȯ    ��'
             TEXT_BUTTON_2   = '�� �� ��'
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

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = '����Ʈ���� Ȯ��'
             DIAGNOSE_OBJECT = ''
            TEXT_QUESTION = '���� ������(����) �۾��� �����Ͻðڽ��ϱ�?'
             TEXT_BUTTON_1   = 'Ȯ    ��'
             TEXT_BUTTON_2   = '�� �� ��'
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
               ZFREQNO                =     IT_TAB-ZFREQNO
               ZFAMDNO                =     IT_TAB-ZFAMDNO.

  ENDLOOP.

ENDFORM.                    " P2000_DATA_UNLOCK
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO   P_ZFAMDNO.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
*   EXPORT 'BES'           TO MEMORY ID 'BES'.
*   EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
*   EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.
   IF SY-UCOMM EQ 'DISP'.
      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
   ELSEIF SY-UCOMM EQ 'DIS1'.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
   ENDIF.
ENDFORM.                    " P2000_SHOW_LC
