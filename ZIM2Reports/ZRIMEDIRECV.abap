*&---------------------------------------------------------------------*
*& Report  ZRIMEDISECV                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� EDI Receipt�� Report Program                     *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.15                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMEDISECV  MESSAGE-ID ZIM
                     LINE-SIZE 119
                     NO STANDARD PAGE HEADING.

TABLES : ZTDDF1,     " ǥ�� EDI FLAT DETAIL
         ZTDHF1,     " ǥ�� EDI FLAT HEAD
         DD03D,      " Dynpro fields for table fields
         ZTREQST.    " �����Ƿ� ��?

*-----------------------------------------------------------------------
* Internal Table Define
*-----------------------------------------------------------------------
DATA : IT_ZTDHF1  LIKE ZTDHF1 OCCURS 0 WITH HEADER LINE.

*-----------------------------------------------------------------------
* Error�� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_ERR_TEXT OCCURS 0,
       ZFDHENO    LIKE ZTDHF1-ZFDHENO,
       ZFDHDOC    LIKE ZTDHF1-ZFDHDOC,
       ZFDHREF    LIKE ZTDHF1-ZFDHREF,
       ERROR_TEXT(67)   TYPE   C.                  " MARK
DATA : END OF IT_ERR_TEXT.

*-----------------------------------------------------------------------
* EDI Send�� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK       TYPE C,                        " MARK
       W_GB01(1)  TYPE C VALUE ';',
       UPDATE_CHK TYPE C,                        " DB �ݿ� ����...
       W_GB02(1)  TYPE C VALUE ';',
       ZFDHENO    LIKE ZTDHF1-ZFDHENO,           " ����������?
       W_GB03(1)  TYPE C VALUE ';',
       ZFDHDOC    LIKE ZTDHF1-ZFDHDOC,           " ���ڹ���?
       W_GB04(1)  TYPE C VALUE ';',
       ZFDHSRO    LIKE ZTDHF1-ZFDHSRO,           " �ŷ����� ID
       W_GB05(1)  TYPE C VALUE ';',
       ZFDHREF    LIKE ZTDHF1-ZFDHREF,           " �߽����� �ο��� ��?
       W_GB06(1)  TYPE C VALUE ';',
*       ZFDHDDB    LIKE ZTDHF1-ZFDHDDB,           " ��������?
*       W_GB07(1)  TYPE C VALUE ';',
       ZFDHJSD(8) TYPE C,                        " IBM <-> FEP ����/��?
*      ZFDHJSD    LIKE ZTDHF1-ZFDHJSD,           " IBM <-> FEP ����/��?
       W_GB08(1)  TYPE C VALUE ';',
       ZFDHJSH(8) TYPE C,                        " IBM <-> FEP ����/��?
*      ZFDHJSH    LIKE ZTDHF1-ZFDHJSH,           " IBM <-> FEP ����/��?
       W_GB09(1)  TYPE C VALUE ';',
       ZFDHJSC    LIKE ZTDHF1-ZFDHJSC,
       W_GB10(1)  TYPE C VALUE ';',
       ZFDHTRA    LIKE ZTDHF1-ZFDHTRA,
       W_GB11(1)  TYPE C VALUE ';',
       ZFDHSSD    LIKE ZTDHF1-ZFDHSSD,
       W_GB12(1)  TYPE C VALUE ';',
       ZFDHSST    LIKE ZTDHF1-ZFDHSST,
       W_GB13(1)  TYPE C VALUE ';',
       ZFDHAPP    LIKE ZTDHF1-ZFDHAPP,
       W_GB14(1)  TYPE C VALUE ';',
       ZFDHPRT    LIKE ZTDHF1-ZFDHPRT,
*       W_GB15(1)  TYPE C VALUE ';',
*       ZFDHPTI    LIKE ZTDHF1-ZFDHPTI,
*       W_GB16(1)  TYPE C VALUE ';',
*       ZFDHPTE    LIKE ZTDHF1-ZFDHPTE,
*       W_GB17(1)  TYPE C VALUE ';',
*       ZFDHRSO    LIKE ZTDHF1-ZFDHRSO,
       W_GB18(1)  TYPE C VALUE ';'.
DATA : END OF IT_TAB.
DATA : W_TEXT(80)      TYPE C.
DATA : W_ZFBLNO        LIKE ZTBL-ZFBLNO,
       W_SUBRC         LIKE SY-SUBRC.
DATA  W_BUTTON_ANSWER.


*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMMESSAGE.    " MESSAGE FUNCTION
INCLUDE   ZRIMUTIL01.     " Utility function ��?


*-----------------------------------------------------------------------
* SELECT RECORD?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       GUBUN      TYPE C,                        " ���� ��?
       ZFDHENO    LIKE ZTDHF1-ZFDHENO,
       ZFDHDOC    LIKE ZTDHF1-ZFDHDOC,
       ZFDHREF    LIKE ZTDHF1-ZFDHREF,
END OF IT_SELECTED.

*-----------------------------------------------------------------------
* DATA DEFINE
*-----------------------------------------------------------------------
DATA : W_ERR_CHK         TYPE C,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_COUNT1          TYPE I,                 " COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_NMOD            TYPE I,
       W_SELECTED_LINES  TYPE P.             " ���� LINE COUNT

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_DHJSD FOR ZTDHF1-ZFDHJSD,  " �۽���?
                   S_DHENO FOR ZTDHF1-ZFDHENO,  " ����������?
                   S_DHSST FOR ZTDHF1-ZFDHSST   " �����۽� ��?
                           NO INTERVALS    NO-EXTENSION,
                   S_DHTRA FOR ZTDHF1-ZFDHTRA   " ��ȯ��?
                           NO INTERVALS    NO-EXTENSION,
                   S_DHDOC FOR ZTDHF1-ZFDHDOC,  " ���ڹ��� ��?
                   S_DHREF FOR ZTDHF1-ZFDHREF.  " �߽����ڹ��� ��?
*   SELECTION-SCREEN SKIP 1.                     " 1 LINE SKIP
** ��� ��?
*   PARAMETERS : P_PRTYN  AS CHECKBOX   DEFAULT   'X'.
SELECTION-SCREEN END OF BLOCK B1.

*-----------------------------------------------------------------------
* PARAMETER �ʱⰪ Setting
*-----------------------------------------------------------------------
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_SET_PARAMETER.

*-----------------------------------------------------------------------
* Title Text Write
*-----------------------------------------------------------------------
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
   PERFORM   P1000_GET_ZTDHF1          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.


*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   CASE SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFDHENO'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
         CLEAR : W_LIST_INDEX, IT_TAB.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'ERRL'.                      " ERROR LOG
         PERFORM P3000_LOG_DISPLAY.
      WHEN 'CLEA'.                      " ERROR LOG
         REFRESH : IT_ERR_TEXT.
      WHEN 'EDII'.                      " EDI RECEIVE
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 0.
            MESSAGE E951.
         ELSE.
* Message Box
            PERFORM P2000_POPUP_MESSAGE USING
                    'Send Confirmation'
                    '������ ���ڹ����� Receive�Ͻðڽ��ϱ�?'
                    'Ȯ    ��'
                    '�� �� ��'
                    '1'
                    W_BUTTON_ANSWER.

            IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ��?
               PERFORM P3000_EDI_DATA_RECEIVE.
               IF W_COUNT EQ 0.
                  MESSAGE S258 WITH W_COUNT1.
                  LEAVE TO SCREEN 0.
               ELSE.
* �����Ƿ� ���̺� SELECT
                  PERFORM   P1000_GET_ZTDHF1          USING   W_ERR_CHK.
                  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* REPORT REWRITE.
                  PERFORM RESET_LIST.
               ENDIF.
            ENDIF.
         ENDIF.
      WHEN 'DISP' OR 'EDIR' OR 'FLAT'.  " L/C ��ȸ  OR EDI REPORT
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            IF SY-UCOMM EQ 'DISP'.
               PERFORM P2000_SHOW_DOCUMENT USING IT_SELECTED-ZFDHENO
                                                 IT_SELECTED-ZFDHDOC
                                                 IT_SELECTED-ZFDHREF.
            ELSEIF SY-UCOMM EQ 'EDIR'.
               PERFORM P2000_SHOW_REPORT   USING IT_SELECTED-ZFDHENO
                                                 IT_SELECTED-ZFDHDOC
                                                 IT_SELECTED-ZFDHREF.
            ELSEIF SY-UCOMM EQ 'FLAT'.
               PERFORM P2000_SHOW_FLAT     USING IT_SELECTED-ZFDHENO.
            ENDIF.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
         PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.          " REFRESH
* �����Ƿ� ���̺� SELECT
         PERFORM   P1000_GET_ZTDHF1          USING   W_ERR_CHK.
         IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* REPORT REWRITE.
         PERFORM RESET_LIST.
      WHEN OTHERS.
   ENDCASE.


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
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

   SET  TITLEBAR 'ZIME2'.           " GUI TITLE SETTING..

   MOVE: 'I'                TO S_DHJSD-SIGN,
         'EQ'               TO S_DHJSD-OPTION,
         SY-DATUM+2(6)      TO S_DHJSD-LOW,
         SY-DATUM+2(6)      TO S_DHJSD-HIGH.
   APPEND S_DHJSD.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50  '[ �� �� �� �� �� Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 101 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',           SY-VLINE,
            ' ����������ȣ ',        SY-VLINE,
            'Doc.Ty',                SY-VLINE,
            '    ��   ��   ó    ',  SY-VLINE,
            '�۽�����',              SY-VLINE,
            '�۽Žð�',              SY-VLINE,
            '��ȯ',                  SY-VLINE,
            '�۽�',                  SY-VLINE,
            '    ���ΰ�����ȣ    ',  SY-VLINE,
            'PRN',                   SY-VLINE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.


ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTDHF1
*&---------------------------------------------------------------------*
FORM P1000_GET_ZTDHF1 USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting

  SELECT * INTO TABLE IT_ZTDHF1 FROM ZTDHF1
                               WHERE ( ZFDHJSD    IN   S_DHJSD
                               OR      ZFDHJSD    EQ     SPACE   )
                               AND   ZFDHENO    IN     S_DHENO
                               AND   ZFDHSST    IN     S_DHSST
                               AND   ZFDHTRA    IN     S_DHTRA
                               AND   ZFDHDOC    IN     S_DHDOC
                               AND   ZFDHREF    IN     S_DHREF
                               AND   ZFDHSRG    EQ     'R'.

  IF SY-SUBRC NE 0.               " Not Found?
     W_ERR_CHK = 'Y'.  MESSAGE S966.    EXIT.
  ENDIF.

  REFRESH : IT_TAB.
  LOOP AT IT_ZTDHF1.
     MOVE-CORRESPONDING   IT_ZTDHF1    TO     IT_TAB.
     IF NOT IT_ZTDHF1-ZFDHJSD IS INITIAL.
        MOVE : IT_ZTDHF1-ZFDHJSD(2)    TO  IT_TAB-ZFDHJSD(2),
               '/'                     TO  IT_TAB-ZFDHJSD+2(1),
               IT_ZTDHF1-ZFDHJSD+2(2)  TO  IT_TAB-ZFDHJSD+3(2),
               '/'                     TO  IT_TAB-ZFDHJSD+5(1),
               IT_ZTDHF1-ZFDHJSD+4(2)  TO  IT_TAB-ZFDHJSD+6(2).
     ENDIF.
     IF NOT IT_ZTDHF1-ZFDHJSH IS INITIAL.
        MOVE : IT_ZTDHF1-ZFDHJSH(2)    TO  IT_TAB-ZFDHJSH(2),
               ':'                     TO  IT_TAB-ZFDHJSH+2(1),
               IT_ZTDHF1-ZFDHJSH+2(2)  TO  IT_TAB-ZFDHJSH+3(2),
               ':'                     TO  IT_TAB-ZFDHJSH+5(1),
               IT_ZTDHF1-ZFDHJSH+4(2)  TO  IT_TAB-ZFDHJSH+6(2).
     ENDIF.
     APPEND IT_TAB.
  ENDLOOP.

ENDFORM.                    " P1000_GET_ZTDHF1
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    W_ERR_CHK.

   SET PF-STATUS 'ZIME2'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIME2'.           " GUI TITLE SETTING..

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
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 1.
      NEW-PAGE.
   ENDIF.


ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

* IF SY-UCOMM EQ 'EDIS' OR SY-UCOMM EQ 'FRGR'.
*    IF IT_TAB-MARK EQ 'X' AND IT_TAB-UPDATE_CHK EQ 'U'.
*       MARKFIELD = 'X'.
*    ELSE.
*       CLEAR : MARKFIELD.
*    ENDIF.
* ENDIF.

  FORMAT RESET.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX
       COLOR COL_NORMAL INTENSIFIED OFF,
       SY-VLINE.

  W_NMOD = W_LINE MOD 2.
  IF W_NMOD EQ 1.
     FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ELSE.
     FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ENDIF.

  WRITE : IT_TAB-ZFDHENO,             " ����������?
       SY-VLINE,
       IT_TAB-ZFDHDOC,                " ���� ��?
       SY-VLINE,
       IT_TAB-ZFDHSRO,                " ����?
       SY-VLINE,
       IT_TAB-ZFDHJSD,                " �����۽���?
       SY-VLINE,
       IT_TAB-ZFDHJSH,                " �����۽Ž�?
       SY-VLINE,
       IT_TAB-ZFDHTRA,                " ��ȯ ��?
       SY-VLINE,
       IT_TAB-ZFDHSST,                " �۽Ż�?
       SY-VLINE,
       IT_TAB-ZFDHREF,                " ���� ������?
       SY-VLINE,
       IT_TAB-ZFDHPRT,                " ���Ƚ?
       SY-VLINE.

* stored value...
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.
  W_COUNT = W_COUNT + 1.
  CLEAR : W_LIST_INDEX, IT_TAB.
ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.
   CLEAR : W_LIST_INDEX, IT_TAB.
   FORMAT RESET.
   WRITE : / SY-ULINE.
   WRITE : / 'Total Count :', W_COUNT NO-GAP, '��'.
ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK USING    W_ERR_CHK.

   W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_LC_REL'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'EDI �۽�'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: INDEX      TYPE P,
        ZFDHENO    LIKE ZTDHF1-ZFDHENO,
        ZFDHDOC    LIKE ZTDHF1-ZFDHDOC,
        ZFDHREF    LIKE ZTDHF1-ZFDHREF.

  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFDHENO  TO ZFDHENO,
         IT_TAB-ZFDHDOC  TO ZFDHDOC,
         IT_TAB-ZFDHREF  TO ZFDHREF.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      MOVE : IT_TAB-ZFDHENO  TO IT_SELECTED-ZFDHENO,
             IT_TAB-ZFDHDOC  TO IT_SELECTED-ZFDHDOC,
             IT_TAB-ZFDHREF  TO IT_SELECTED-ZFDHREF.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
    IF INDEX GT 0.
      MOVE : ZFDHENO TO IT_SELECTED-ZFDHENO,
             ZFDHREF TO IT_SELECTED-ZFDHREF,
             ZFDHDOC TO IT_SELECTED-ZFDHDOC.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ELSE.
      MESSAGE S962.
    ENDIF.
  ENDIF.
  CLEAR : W_LIST_INDEX, IT_TAB.
ENDFORM.                    " P2000_MULTI_SELECTION

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_DOCUMENT
*&---------------------------------------------------------------------*
FORM P2000_SHOW_DOCUMENT USING    P_ZFDHENO   P_ZFDHDOC    P_ZFDHREF.
DATA : LW_DHREF    LIKE    ZTDHF1-ZFDHREF.

   MOVE : P_ZFDHREF   TO   LW_DHREF.

   CASE   P_ZFDHDOC.
      WHEN 'APP700'.
         SET PARAMETER ID 'ZPREQNO' FIELD P_ZFDHREF.
         SET PARAMETER ID 'ZPOPNNO' FIELD ''.
         SET PARAMETER ID 'ZPAMDNO' FIELD ''.
         SET PARAMETER ID 'BES'     FIELD ''.
         CALL TRANSACTION 'ZIM03'   AND SKIP FIRST SCREEN.
      WHEN 'INF700'.
* �����Ƿ� ���� SELECT
         SELECT * FROM ZTREQST UP TO 1 ROWS
                        WHERE ZFDOCNO EQ P_ZFDHREF
                        AND   ZFAMDNO EQ '00000'
                        ORDER BY ZFREQNO DESCENDING.
            EXIT.
         ENDSELECT.
*        IF SY-SUBRC NE 0.
*           RAISE   NO_REFERENCE.
*        ENDIF.

         SET PARAMETER ID 'ZPREQNO' FIELD ZTREQST-ZFREQNO.
         SET PARAMETER ID 'ZPOPNNO' FIELD ''.
         SET PARAMETER ID 'ZPOPNNO' FIELD 'BES'.
         CALL TRANSACTION 'ZIM03'   AND SKIP FIRST SCREEN.
      WHEN 'APP707'.
         SET PARAMETER ID 'ZPREQNO' FIELD LW_DHREF(10).
         SET PARAMETER ID 'ZPAMDNO' FIELD LW_DHREF+11(5).
         SET PARAMETER ID 'ZPOPNNO' FIELD ''.
         SET PARAMETER ID 'BES'     FIELD ''.

         CALL TRANSACTION 'ZIM13'   AND SKIP FIRST SCREEN.
      WHEN 'SAITIN'.
         SELECT MAX( ZFBLNO ) INTO W_ZFBLNO FROM ZTBL
                              WHERE ZFHBLNO EQ P_ZFDHREF
                              AND   ZFDOCNO EQ P_ZFDHENO.
*        IF W_ZFBLNO IS INITIAL.
*           MESSSAGE E100 WITH P_ZFDHREF.
*        ENDIF.

         SET PARAMETER ID 'ZPHBLNO' FIELD P_ZFDHREF.
         SET PARAMETER ID 'ZPBLNO'  FIELD W_ZFBLNO.

         CALL TRANSACTION 'ZIM23'   AND SKIP FIRST SCREEN.
      WHEN OTHERS.
         MESSAGE E033 WITH  P_ZFDHDOC.
   ENDCASE.

ENDFORM.                    " P2000_SHOW_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
FORM P2000_SET_SELETE_OPTION USING    W_ERR_CHK.
*
  W_ERR_CHK = 'N'.

  IF S_DHSST IS INITIAL.
     MOVE: 'I'                TO S_DHSST-SIGN,
           'EQ'               TO S_DHSST-OPTION,
           'S_OK'             TO S_DHSST-LOW.
   APPEND S_DHSST.
     MOVE: 'I'                TO S_DHSST-SIGN,
           'EQ'               TO S_DHSST-OPTION,
           ''                 TO S_DHSST-LOW.
   APPEND S_DHSST.
  ENDIF.

  IF S_DHTRA IS INITIAL.
     MOVE: 'I'                TO S_DHTRA-SIGN,
           'EQ'               TO S_DHTRA-OPTION,
           'T_OK'             TO S_DHTRA-LOW.
   APPEND S_DHTRA.
     MOVE: 'I'                TO S_DHTRA-SIGN,
           'EQ'               TO S_DHTRA-OPTION,
           ''                 TO S_DHTRA-LOW.
   APPEND S_DHTRA.
  ENDIF.

ENDFORM.                    " P2000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_REPORT
*&---------------------------------------------------------------------*
FORM P2000_SHOW_REPORT USING     P_ZFDHENO   P_ZFDHDOC   P_ZFDHREF.

   CASE   P_ZFDHDOC.
      WHEN 'CIPADV'.      " ���Ϻ���κ� ��û ��?
*        SUBMIT  ZRIMCARG02  WITH P_ZFDHNO EQ P_ZFDHENO SIGN 'I'
*                 AND RETURN.
      WHEN 'CUSCRA'.      " ������γ��� ��?
*        SUBMIT  ZRIMCARG02  WITH P_DDENO  EQ P_ZFDHENO SIGN 'I'
*                 AND RETURN.
      WHEN 'DISCHG'.      " ���Ծ��� DISCOUNT �����뺸?
*        SUBMIT  ZRIMDISCHG  WITH S_ZFDNO EQ P_ZFDHDOC SIGN 'I'
*                 AND RETURN.
      WHEN 'DOANTC'.      " �������������뺸�� ��?
*        SUBMIT  ZRIMDOANTC  WITH S_ZFDNO EQ P_ZFDHDOC SIGN 'I'
*                 AND RETURN.
      WHEN 'IMPRES'.      " ���ԽŰ����� ��?
*        SUBMIT  ZRIMIMPRES  WITH P_DDENO EQ P_ZFDHENO SIGN 'I'
*                 AND RETURN.
      WHEN 'INF700'.      " L/C Open ��û ��?
*        SUBMIT  ZRIMMLCO02  WITH S_ZFDNO EQ P_ZFDHREF SIGN 'I'
*                 AND RETURN.
      WHEN 'INF707'.      " L/C Amend ��û ��?
*        SUBMIT  ZRIMMLCA02  WITH S_ZFDNO EQ P_ZFDHREF SIGN 'I'
*                 AND RETURN.
      WHEN 'PURLIC'.      " ���Ž��μ� ��?
*        SUBMIT  ZRIMPURO02  WITH S_ZFDNO EQ P_ZFDHREF SIGN 'I'
*                 AND RETURN.
      WHEN 'SAITIN'.      " B/L ��?
*        SUBMIT  ZRIMSAITIN  WITH S_ZFDNO EQ P_ZFDHENO SIGN 'I'
*                 AND RETURN.
      WHEN 'VATBIL'.      " ���ݰ��?
*        SUBMIT  ZRIMVATBIL  WITH S_ZFDNO EQ P_ZFDHENO SIGN 'I'
*                 AND RETURN.
      WHEN OTHERS.
         MESSAGE E033 WITH  P_ZFDHDOC.
   ENDCASE.

ENDFORM.                    " P2000_SHOW_REPORT
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_FLAT
*&---------------------------------------------------------------------*
FORM P2000_SHOW_FLAT USING    P_ZFDHENO.
    SUBMIT  ZRIMFLAT_DISP  WITH P_DDENO  EQ P_ZFDHENO
            AND RETURN.

ENDFORM.                    " P2000_SHOW_FLAT
*&---------------------------------------------------------------------*
*&      Form  P3000_EDI_DATA_RECEIVE
*&---------------------------------------------------------------------*
FORM P3000_EDI_DATA_RECEIVE.

  REFRESH : IT_ERR_TEXT.
  W_COUNT1 = 0.
  LOOP AT IT_SELECTED.
*-----------------------------------------------------------------------
* EDI DATA RECEIVE
*-----------------------------------------------------------------------
     CALL FUNCTION 'ZIM_RCV_FR_EDIFEP'
        EXPORTING
            ZFDHDOC      =     IT_SELECTED-ZFDHDOC
            ZFDHENO      =     IT_SELECTED-ZFDHENO
        IMPORTING
            RETURN_CODE  =     W_SUBRC.

     IF W_SUBRC EQ 0.
        W_COUNT1 = W_COUNT1 + 1.
     ENDIF.

     PERFORM   P2000_ERROR_ROUTINE   USING   W_SUBRC
                                             IT_SELECTED-ZFDHENO.
  ENDLOOP.

  DESCRIBE TABLE IT_ERR_TEXT  LINES W_COUNT.
  IF W_COUNT > 0.
     MESSAGE I144 WITH W_COUNT.
  ENDIF.

ENDFORM.                    " P3000_EDI_DATA_RECEIVE
*&---------------------------------------------------------------------*
*&      Form  P3000_SET_ERROR_TEXT
*&---------------------------------------------------------------------*
FORM P3000_SET_ERROR_TEXT USING    P_SELECTED    P_TEXT.

  CLEAR : IT_ERR_TEXT.
  MOVE : P_SELECTED+1(14)     TO    IT_ERR_TEXT-ZFDHENO,
         P_SELECTED+15(6)     TO    IT_ERR_TEXT-ZFDHDOC,
         P_SELECTED+21(20)    TO    IT_ERR_TEXT-ZFDHREF,
         P_TEXT               TO    IT_ERR_TEXT-ERROR_TEXT.
  APPEND    IT_ERR_TEXT.
ENDFORM.                    " P3000_SET_ERROR_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_LOG_DISPLAY
*&---------------------------------------------------------------------*
FORM P3000_LOG_DISPLAY.
  DESCRIBE TABLE IT_ERR_TEXT  LINES W_COUNT.
  IF W_COUNT EQ 0.
     MESSAGE E145.
  ENDIF.

  SET PF-STATUS 'ZIMLG'.           " GUI STATUS SETTING
  SET  TITLEBAR 'ZIMLG'.           " GUI TITLE SETTING..
  FORMAT RESET.
  SKIP 2.
  WRITE : /50  ' [ ERROR LOG ��Ȳ ] '
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ����������ȣ ',
            SY-VLINE, 'Doc.Ty',
            SY-VLINE, '    ���ΰ�����ȣ    ',
            SY-VLINE, 80 '    LOG    ',   119 SY-VLINE.
  WRITE : / SY-ULINE.
  LOOP AT IT_ERR_TEXT.
     W_LINE = SY-TABIX.
     W_NMOD = W_LINE MOD 2.
     IF W_NMOD EQ 1.    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
     ELSE.              FORMAT COLOR COL_NORMAL INTENSIFIED ON.
     ENDIF.

     WRITE:/ SY-VLINE, IT_ERR_TEXT-ZFDHENO,
             SY-VLINE, IT_ERR_TEXT-ZFDHDOC,
             SY-VLINE, IT_ERR_TEXT-ZFDHREF,
             SY-VLINE, IT_ERR_TEXT-ERROR_TEXT NO-GAP,
             SY-VLINE.
  ENDLOOP.
  WRITE : / SY-ULINE.
  FORMAT RESET.
  WRITE : / 'Total Count :', W_LINE NO-GAP, '��'.
ENDFORM.                    " P3000_LOG_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  P2000_ERROR_ROUTINE
*&---------------------------------------------------------------------*
FORM P2000_ERROR_ROUTINE USING    P_SY_SUBRC   P_ZFDHENO.

  CASE P_SY_SUBRC.
    WHEN 4.             " LOG
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� ���� �� ������ '
                   '�߻��Ͽ����ϴ�.'      INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 8.             " LOG
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� �������� �ʽ��ϴ�.'
                                          INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 10.            " LOG
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� �ش� ������ '
                'ã�� �� �����ϴ�.'       INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 12.            " LOG
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� User ' SY-MSGV1
                '��(��) ���� ���Դϴ�.'       INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 14.            " LOG
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� �������ڸ� ��ȯ �� '
                '������ �߻��Ͽ����ϴ�.'  INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 18.            " Not Process
       CONCATENATE '���ڹ���[' P_ZFDHENO ']�� Receive�� ����Ͽ����ϴ�.'
                 INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 98.            " LOG
       CONCATENATE '�̹� ���ŵ� ����[' IT_SELECTED-ZFDHENO ']'
                '�Դϴ�.'      INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
    WHEN 99.            " LOG
       CONCATENATE '���ǵ��� ���� ����[' IT_SELECTED-ZFDHDOC ']'
                '�Դϴ�.'      INTO W_TEXT.
       PERFORM   P3000_SET_ERROR_TEXT  USING IT_SELECTED W_TEXT.
  ENDCASE.

ENDFORM.                    " P2000_ERROR_ROUTINE
