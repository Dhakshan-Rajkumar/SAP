*&---------------------------------------------------------------------*
*& Report  ZRIMEDIR01N                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� ��ȯ�󿪹��� EDI Receipt(Matrix2B).              *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.09                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1.
*&---------------------------------------------------------------------*
*& [���泻��]
*&---------------------------------------------------------------------*
REPORT  ZRIMEDIR01N NO STANDARD PAGE HEADING
                    MESSAGE-ID ZIM
                    LINE-SIZE 103.

INCLUDE : <ICON>.

*-----------------------------------------------------------------------
* Internal Table and Field Definition.
*-----------------------------------------------------------------------
DATA : IT_ZTDHF1  LIKE ZTDHF1 OCCURS 0 WITH HEADER LINE.

DATA  W_EDI_RECORD(7000).
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFFILE(100),                             " EDI ���ϸ�.
       ZFDHENO       LIKE     ZTDHF1-ZFDHENO,
       ZFDHREF       LIKE     ZTDHF1-ZFDHREF,
       ZFDHDOC       LIKE     ZTDHF1-ZFDHDOC,
       ZFDHDOCNM(28) TYPE     C,
       ZFOPNNO       LIKE     ZTREQHD-ZFOPNNO,
       ZFOPNDT       LIKE     ZTREQST-ZFOPNDT,
       ZFRDATE       LIKE     SY-DATUM,
       ZFRTIME       LIKE     SY-UZEIT,
       W_RECORD      LIKE     W_EDI_RECORD,
       ZFBLYN(3)     TYPE     C,
       END OF IT_TAB.

DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
INCLUDE  STRUCTURE  BDCMSGCOLL.
DATA : ICON         LIKE BAL_S_DMSG-%_ICON,
       MESSTXT(266) TYPE C.
DATA : END OF IT_ERR_LIST.

DATA: BEGIN OF IT_SELECT OCCURS 0,
        FILENAME(100),
      END OF IT_SELECT.

DATA: BEGIN OF IT_FLATFILE OCCURS 0,
        FILENAME(100),
      END OF IT_FLATFILE.

DATA: BEGIN OF IT_DHF1 OCCURS 0.
        INCLUDE STRUCTURE ZTDHF1.
DATA: END OF IT_DHF1.

DATA: BEGIN OF IT_BL OCCURS 0.
        INCLUDE STRUCTURE ZTBL.
DATA: END OF IT_BL.

DATA: BEGIN OF MTAB_DATA OCCURS 0,
        LINE(132)   TYPE C,
      END OF MTAB_DATA.

* Internal Table Declaration for Storing EDI File Received Data.
DATA: BEGIN OF IT_EDI OCCURS 0,
      RECORD   LIKE     W_EDI_RECORD,
      END OF IT_EDI.

*-----------------------------------------------------------------------
* Define Tables and Variable.
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
*INCLUDE   ZRIMMESSAGE.    " MESSAGE FUNCTION
INCLUDE   ZRIMUTIL01.     " Utility function ��?
INCLUDE   ZRIMPRELTOP.

*-----------------------------------------------------------------------
* Define Fields.
*-----------------------------------------------------------------------
DATA: UPLOAD_PATH(300)   TYPE   C.     " Variable for Upload Path.
DATA: FILE_NAME(300)     TYPE   C.     " Variable for File Name.
DATA: MI_HANDLE          TYPE   I,
      MC_PASSWORD(20)    TYPE   C,
      MI_KEY             TYPE   I  VALUE 26101957,
      MI_PWD_LEN         TYPE   I,
      ANTWORT(1)         TYPE   C,         " ���� Popup Screen���� ���.
      L_LEN              TYPE   I,
      L_STRLEN           TYPE   I,
      L_SIZE             TYPE   I,
      W_MOD              TYPE   I,
      L_DATE             TYPE   SY-DATUM,
      INCLUDE(8)         TYPE   C,             "
      L_TIME             TYPE   SY-UZEIT,
      W_BUKRS            LIKE   ZTIMIMGTX-BUKRS,  " Company Code.
      W_SUBRC            LIKE   SY-SUBRC.

DATA: L_DEL              TYPE   C.                "Recv File Del YN.
DATA: W_READ_CNT         TYPE   I.                "Data Rec Count.
DATA: TEXT100(100),
      TEXT50(50).

DATA : W_OK_CODE         LIKE   SY-UCOMM,
       W_ZFDHENO         LIKE   ZTDHF1-ZFDHENO,
       W_ZFCDDOC         LIKE   ZTCDF1-ZFCDDOC,
       W_ZFDHSRO         LIKE   ZTDHF1-ZFDHSRO,
       W_ZFDHREF         LIKE   ZTDHF1-ZFDHREF.

*-----------------------------------------------------------------------
* Selection Screen ��.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS: S_BUKRS LIKE ZTIMIMGTX-BUKRS OBLIGATORY DEFAULT 'PSC'.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
PARAMETERS: P_DEL AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
PARAMETERS: P_NA AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK B3.
*----------------------------------------------------------------------*
* Parameter �ʱⰪ Setting.
*----------------------------------------------------------------------*
INITIALIZATION.

*----------------------------------------------------------------------*
* Top-Of-Page.
*----------------------------------------------------------------------*
TOP-OF-PAGE.
  PERFORM P3000_TITLE_WRITE.

*----------------------------------------------------------------------*
* Start-Of-Selection.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM P1000_GET_UPLOAD_FILE USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'. MESSAGE S738. EXIT. ENDIF.

  PERFORM P3000_DATA_WRITE USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'. EXIT. ENDIF.

*----------------------------------------------------------------------*
* At User-Command.
*----------------------------------------------------------------------*
AT USER-COMMAND.

  CASE SY-UCOMM.

* '���' ��, ó�� Logic.
    WHEN 'CNCL'.
      ANTWORT = 'C'. SET SCREEN 0. LEAVE SCREEN.

* ��ü���� �� �������� Function Code�� ���� ó�� Logic.
    WHEN 'MKAL' OR 'MKLO'.
      PERFORM  P2000_SELECT_RECORD USING  SY-UCOMM.

* EDI ���� ��, ó�� Logic.
    WHEN 'EDII'.                                     " EDI Receipt.
      PERFORM P3000_RECEIVE_FLAT_FILE.
*
    WHEN 'DOWN'.                                     " FILE DOWNLOAD....
      PERFORM P3000_TO_PC_DOWNLOAD.

* ������ȸ �� ó������.
    WHEN 'DISP'.
      PERFORM P3000_DISPLAY_DOCUMENT.

    WHEN 'REFR'.
* Upload�� Filename�� �����ϴ� �����ƾ.
      CLEAR: IT_TAB.
      REFRESH: IT_TAB.
      PERFORM   P1000_GET_UPLOAD_FILE USING   W_ERR_CHK.

      IF W_ERR_CHK EQ 'Y'.
        LEAVE TO SCREEN 0.
      ENDIF.

      PERFORM RESET_LIST.

    WHEN OTHERS.
  ENDCASE.
  CLEAR : IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  WRITE : /35  '[ EDI ���Ŵ�� ����  ]'
                   COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /85 'Date : ', SY-DATUM.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  WRITE : / SY-ULINE,
          / SY-VLINE,
          5 SY-VLINE       NO-GAP,
        (35)'File Name'    NO-GAP, SY-VLINE NO-GAP,
        (10)'Doc. Type'    NO-GAP, SY-VLINE NO-GAP,
        (50)'Descriptions' NO-GAP, SY-VLINE NO-GAP.
  WRITE   / SY-ULINE.

  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE : / SY-VLINE,
          5 SY-VLINE               NO-GAP,
        (35)'��û���� ������ȣ'    NO-GAP, SY-VLINE NO-GAP,
        (10)'         '            NO-GAP, SY-VLINE NO-GAP,
        (50)'       '              NO-GAP, SY-VLINE NO-GAP.
  FORMAT RESET.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.

  SET PF-STATUS 'ZIME11'.           " GUI STATUS SETTING
  SET TITLEBAR  'ZIME11'.           " GUI TITLE SETTING..

  W_PAGE = 1.
  W_LINE = 0.
  W_COUNT = 0.

  SORT IT_TAB BY ZFFILE.
  CLEAR : IT_TAB.

  LOOP AT IT_TAB.
    W_LINE = W_LINE + 1.
*>>> File Name�� �ٲ𶧸���.
    ON CHANGE OF IT_TAB-ZFFILE.
      PERFORM P3000_FILE_NAME_WRITE.
    ENDON.
*>>> Line Record Write.
    PERFORM P3000_LINE_WRITE.
    AT LAST.
      PERFORM P3000_LAST_WRITE.
    ENDAT.
  ENDLOOP.
  CLEAR : IT_TAB.


ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_DATA_UPDATE USING    P_W_OK_CODE.
* ������ EDI ������ ���� �˱����� ���� ����.
  DATA: L_DATNO TYPE I VALUE 0.

  REFRESH : IT_ERR_LIST.
  CLEAR   : IT_ERR_LIST.
  DATA: L_COMMAND(100) TYPE C.
  CLEAR W_COUNT.
  LOOP AT IT_SELECT.
    W_TABIX = SY-TABIX.
*>>> ������¹�..
    LINE = ( SY-TABIX / W_SELECTED_LINES ) * 100.
    OUT_TEXT = 'JOB PROGRESS %99999%%'.
    REPLACE '%99999%' WITH LINE INTO OUT_TEXT.
    PERFORM P2000_SHOW_BAR USING OUT_TEXT LINE.
    PERFORM P2000_RECEIVE_DATA USING W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.
      EXIT.
*      CONTINUE.
    ENDIF.

    L_DATNO = L_DATNO + 1.
  ENDLOOP.

  MESSAGE S289 WITH L_DATNO.

ENDFORM.                    " P3000_DATA_UPDATE
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
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  W_COUNT = W_COUNT + 1.
  WRITE: / SY-VLINE NO-GAP,
         5 SY-VLINE NO-GAP,
       (35)IT_TAB-ZFDHENO NO-GAP, SY-VLINE NO-GAP,
       (10)IT_TAB-ZFOPNDT NO-GAP, SY-VLINE NO-GAP,
       (50)IT_TAB-ZFOPNNO NO-GAP, SY-VLINE NO-GAP.

  HIDE: IT_TAB.
ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_UPLOAD_FILE
*&---------------------------------------------------------------------*
FORM P1000_GET_UPLOAD_FILE USING    P_W_ERR_CHK.
  DATA L_COUNT TYPE I.

  MOVE 'N'  TO  W_ERR_CHK.

  SELECT SINGLE * FROM ZTIMIMGTX WHERE BUKRS EQ  S_BUKRS.
  IF SY-SUBRC NE 0. MESSAGE S963. EXIT. ENDIF.
  MOVE ZTIMIMGTX-ZFRECV TO UPLOAD_PATH.

*> Find Current directory.
  PERFORM  P2000_GET_CURRENT_DIR USING  UPLOAD_PATH.
  CHECK : W_ERR_CHK EQ 'N'.

*> File List Get.
  PERFORM  P2000_GET_FILE_LIST.
  CHECK : W_ERR_CHK EQ 'N'.

  REFRESH: IT_TAB.
  SORT IT_FLATFILE BY FILENAME.
  LOOP AT IT_FLATFILE.
    IF ( IT_FLATFILE-FILENAME+18(6) EQ 'INF700' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'INF707' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOCADV' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOCAMA' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOGUAR' ).
      MOVE IT_FLATFILE-FILENAME TO FILE_NAME.
      PERFORM  P1000_FILE_TO_ITAB.
      ADD    1    TO    L_COUNT.
    ENDIF.
  ENDLOOP.

  IF L_COUNT EQ 0.
    MOVE 'Y' TO W_ERR_CHK.
    MESSAGE S738. EXIT.
  ENDIF.

ENDFORM.                    " P1000_GET_UPLOAD_FILE
*&---------------------------------------------------------------------*
*&      Form  P2000_GET_FILE_LIST
*&---------------------------------------------------------------------*
FORM P2000_GET_FILE_LIST.
  REFRESH : IT_FLATFILE.
  DESCRIBE TABLE MTAB_DATA LINES W_LINE.
  IF W_LINE LT 15.
    MOVE 'Y' TO W_ERR_CHK.
    MESSAGE S027. EXIT.
  ENDIF.
  W_LINE = W_LINE - 2.
  SELECT * INTO TABLE IT_DHF1 FROM ZTDHF1.

  LOOP AT MTAB_DATA FROM 14 TO W_LINE.
    CLEAR : IT_FLATFILE.
    CONCATENATE UPLOAD_PATH MTAB_DATA-LINE+39 INTO IT_FLATFILE.
    IF ( IT_FLATFILE-FILENAME+18(6) EQ 'INF700' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'INF707' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOCADV' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOCAMA' )
    OR ( IT_FLATFILE-FILENAME+18(6) EQ 'LOGUAR' ).
      READ TABLE IT_DHF1 WITH KEY BUKRS   = S_BUKRS
                                  ZFDHDOC = IT_FLATFILE-FILENAME+18(6).
      MOVE SY-SUBRC TO W_SUBRC.
      IF P_NA EQ 'X'.
        IF W_SUBRC NE 0. APPEND IT_FLATFILE. ENDIF.
      ELSE.
        IF W_SUBRC EQ 0. APPEND IT_FLATFILE. ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SORT IT_FLATFILE BY FILENAME.

ENDFORM.                    " P2000_GET_FILE_LIST
*&---------------------------------------------------------------------*
*&      Form  P1000_FILE_TO_ITAB
*&---------------------------------------------------------------------*
FORM P1000_FILE_TO_ITAB.
  DATA : L_FIRST_CHK  TYPE C VALUE 'N',
         L_ZFDHDOC    LIKE ZTDHF1-ZFDHDOC.

  CLEAR : L_ZFDHDOC,  W_TABIX.
*  REFRESH: IT_TAB.
  OPEN DATASET FILE_NAME  FOR INPUT  IN TEXT MODE.
  IF SY-SUBRC NE 0.
    MESSAGE S977 WITH 'File Server�κ��� File�� �� �� �����ϴ�.'.
    EXIT.
  ENDIF.

  DO.
    READ DATASET FILE_NAME  INTO W_EDI_RECORD.
    IF SY-SUBRC    EQ    4.
      EXIT.
    ENDIF.

    W_READ_CNT = W_READ_CNT + 1.

    IF W_EDI_RECORD(6) EQ 'INF700' OR W_EDI_RECORD(6) EQ 'INF707' OR
       W_EDI_RECORD(6) EQ 'LOCADV' OR W_EDI_RECORD(6) EQ 'LOCAMA' OR
       W_EDI_RECORD(6) EQ 'LOGUAR'.

      L_ZFDHDOC   = W_EDI_RECORD(06).
      W_READ_CNT = 1.

    ELSE.
      CLEAR:   IT_EDI, IT_TAB.
      REFRESH: IT_EDI.
      IF W_READ_CNT GE 3.
        MOVE: FILE_NAME  TO  IT_TAB-ZFFILE.
        MOVE: L_ZFDHDOC  TO  IT_TAB-ZFDHDOC.
        APPEND  IT_TAB.
      ENDIF.
      W_TABIX = SY-TABIX.

      CASE L_ZFDHDOC.
* In case of Master L/C Advising.
        WHEN 'INF700'.
          IF W_READ_CNT GE 3.

            SPLIT W_EDI_RECORD AT '|' INTO TABLE IT_EDI.

            "������ȣ.
            READ TABLE IT_EDI INDEX 3.
            MOVE IT_EDI-RECORD(17)  TO  IT_TAB-ZFDHENO.

            " ������ȣ.
            READ TABLE IT_EDI  INDEX 26.
            MOVE IT_EDI-RECORD(16) TO   IT_TAB-ZFOPNNO.

            "��������.
            READ TABLE IT_EDI INDEX 28.
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                 EXPORTING
                      DATE_EXTERNAL = IT_EDI-RECORD(8)
                 IMPORTING
                      DATE_INTERNAL = IT_TAB-ZFOPNDT.
            MODIFY  IT_TAB INDEX  W_TABIX.
          ENDIF.
* In case of Master L/C Amend Advising.
        WHEN 'INF707'.
          IF W_READ_CNT GE 3.

            SPLIT W_EDI_RECORD AT '|' INTO TABLE IT_EDI.

            "������ȣ.
            READ TABLE IT_EDI INDEX 3.
            MOVE IT_EDI-RECORD(17)  TO  IT_TAB-ZFDHENO.

            " ������ȣ.
            READ TABLE IT_EDI  INDEX 26.
            MOVE IT_EDI-RECORD(16) TO   IT_TAB-ZFOPNNO.

            "��������.
            READ TABLE IT_EDI INDEX 34.
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                 EXPORTING
                      DATE_EXTERNAL = IT_EDI-RECORD(8)
                 IMPORTING
                      DATE_INTERNAL = IT_TAB-ZFOPNDT.
            MODIFY  IT_TAB INDEX  W_TABIX.
          ENDIF.
* In case of Local L/C Advising.
        WHEN 'LOCADV'.
          IF W_READ_CNT GE 3.
            SPLIT W_EDI_RECORD AT '|' INTO TABLE IT_EDI.

            READ TABLE IT_EDI INDEX 3.                        "������ȣ.
            MOVE IT_EDI-RECORD(17)  TO  IT_TAB-ZFDHENO.

            READ TABLE IT_EDI  INDEX 9.                     " ������ȣ.
            MOVE IT_EDI-RECORD(35) TO   IT_TAB-ZFOPNNO.

            READ TABLE IT_EDI INDEX 21.                       "��������.
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                 EXPORTING
                      DATE_EXTERNAL = IT_EDI-RECORD(8)
                 IMPORTING
                      DATE_INTERNAL = IT_TAB-ZFOPNDT.
            MODIFY  IT_TAB INDEX  W_TABIX.
          ENDIF.
        WHEN 'LOCAMA'.
          IF W_READ_CNT GE 3.
            SPLIT W_EDI_RECORD AT '|' INTO TABLE IT_EDI.
            READ TABLE IT_EDI INDEX 3.                 "������ȣ.
            MOVE IT_EDI-RECORD(17)  TO  IT_TAB-ZFDHENO.

            READ TABLE IT_EDI  INDEX 9.                " ������ȣ.
            MOVE IT_EDI-RECORD(16) TO   IT_TAB-ZFOPNNO.

            READ TABLE IT_EDI INDEX 19.                " ���Ǻ�������.
            CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                 EXPORTING
                      DATE_EXTERNAL = IT_EDI-RECORD(8)
                 IMPORTING
                      DATE_INTERNAL = IT_TAB-ZFOPNDT.

          ENDIF.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.
  ENDDO.
  CLOSE DATASET    FILE_NAME.

ENDFORM.                    " P1000_FILE_TO_ITAB
*&---------------------------------------------------------------------*
*&      Form  P2000_GET_CURRENT_DIR
*&---------------------------------------------------------------------*
FORM P2000_GET_CURRENT_DIR USING    P_UPLOAD_PATH.
  DATA : L_COMMAND(50)     TYPE C.

  CLEAR: MTAB_DATA.
  REFRESH: MTAB_DATA.

  CONCATENATE 'cmd /c dir *.itf' P_UPLOAD_PATH
         INTO L_COMMAND SEPARATED BY SPACE.

  PERFORM P2000_SHOW_BAR
          USING 'Receipt�� Flat Files ������ �д� ���Դϴ�...' 0.

*> Inbound Directory�� �̵�.
  CALL FUNCTION  'RFC_REMOTE_PIPE'  DESTINATION  'INFOLINK_FTP'
     EXPORTING
        COMMAND  =  L_COMMAND
        READ     =  'X'
     TABLES
        PIPEDATA =  MTAB_DATA.

ENDFORM.                    " P2000_GET_CURRENT_DIR
*&---------------------------------------------------------------------*
*&      Form  P3000_FILE_NAME_WRITE
*&---------------------------------------------------------------------*
FORM P3000_FILE_NAME_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
  MARKFIELD = SPACE.
  CASE IT_TAB-ZFFILE+18(6).
      MOVE IT_TAB-ZFFILE+18(6) TO IT_TAB-ZFDHDOC .
    WHEN 'INF700'.
      MOVE '���Խſ��� �������伭'        TO IT_TAB-ZFDHDOCNM.
    WHEN 'INF707'.
      MOVE '���Խſ��� ���Ǻ������伭'    TO IT_TAB-ZFDHDOCNM.
    WHEN 'LOCADV'.
      MOVE '�����ſ��� �������伭'        TO IT_TAB-ZFDHDOCNM.
    WHEN 'LOCAMA'.
      MOVE '�����ſ��� ���Ǻ������伭'    TO IT_TAB-ZFDHDOCNM.
    WHEN 'LOGUAR'.
      MOVE '����ȭ�� ���뺸����û ���伭' TO IT_TAB-ZFDHDOCNM.
    WHEN OTHERS.
  ENDCASE.

  WRITE:/ SY-ULINE.
  WRITE:/  SY-VLINE, MARKFIELD AS CHECKBOX,
         5 SY-VLINE NO-GAP,
        (35)IT_TAB-ZFFILE+18(30) NO-GAP,    SY-VLINE NO-GAP,
        (10)IT_TAB-ZFDHDOC CENTERED NO-GAP, SY-VLINE NO-GAP,
        (50)IT_TAB-ZFDHDOCNM NO-GAP,        SY-VLINE NO-GAP.
  HIDE : IT_TAB.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
*  WRITE :/(5) SY-ULINE.

ENDFORM.                    " P3000_FILE_NAME_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
    FORMAT RESET.

    WRITE : / SY-ULINE,
            /86'��', W_COUNT, '��'.
  ENDIF.
  CLEAR W_MOD.
ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: ZFDHENO  LIKE ZTDHF1-ZFDHENO,
        ZFDHDOC  LIKE ZTDHF1-ZFDHDOC,
        FILENAME LIKE ZTDHF1-FILENAME.

  REFRESH IT_SELECT.
  CLEAR   IT_SELECT.
  CLEAR   W_SELECTED_LINES.
  MOVE IT_TAB-ZFDHDOC TO ZFDHENO.
  W_COUNT = 1.
  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0. EXIT. ENDIF.
    IF ( MARKFIELD EQ 'x') OR ( MARKFIELD EQ 'X').
      READ TABLE IT_TAB INDEX W_COUNT.
      MOVE IT_TAB-ZFFILE TO IT_SELECT-FILENAME.
      APPEND IT_SELECT.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
    ADD 1 TO W_COUNT.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POPUP_MESSAGE USING    P_HEADER   P_TEXT.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
       EXPORTING
            TITLEBAR              = P_HEADER
            DIAGNOSE_OBJECT       = ''
            TEXT_QUESTION         = P_TEXT
            TEXT_BUTTON_1         = 'Ȯ    ��'
            TEXT_BUTTON_2         = '�� �� ��'
            DEFAULT_BUTTON        = '1'
            DISPLAY_CANCEL_BUTTON = ' '
            START_COLUMN          = 30
            START_ROW             = 8
       IMPORTING
            ANSWER                = W_BUTTON_ANSWER.

ENDFORM.                    " P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_SINGLE_MSG_MAKE
*&---------------------------------------------------------------------*
FORM P2000_SINGLE_MSG_MAKE.

  MOVE : SY-MSGTY            TO     IT_ERR_LIST-MSGTYP,
         SY-MSGID            TO     IT_ERR_LIST-MSGID,
         SY-MSGNO            TO     IT_ERR_LIST-MSGNR,
         SY-MSGV1            TO     IT_ERR_LIST-MSGV1,
         SY-MSGV2            TO     IT_ERR_LIST-MSGV2,
         SY-MSGV3            TO     IT_ERR_LIST-MSGV3,
         SY-MSGV4            TO     IT_ERR_LIST-MSGV4.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
       EXPORTING
            MSGID               = IT_ERR_LIST-MSGID
            MSGNR               = IT_ERR_LIST-MSGNR
            MSGV1               = IT_ERR_LIST-MSGV1
            MSGV2               = IT_ERR_LIST-MSGV2
            MSGV3               = IT_ERR_LIST-MSGV3
            MSGV4               = IT_ERR_LIST-MSGV4
       IMPORTING
            MESSAGE_TEXT_OUTPUT = IT_ERR_LIST-MESSTXT.

  CASE IT_ERR_LIST-MSGTYP.
    WHEN 'E' OR 'A'.
      MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
    WHEN 'I'.
      MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
    WHEN 'S'.
      MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
    WHEN 'W'.
      MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
  ENDCASE.

  APPEND  IT_ERR_LIST.

ENDFORM.                    " P2000_SINGLE_MSG_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_MSG_MAKE
*&---------------------------------------------------------------------*
FORM P2000_MULTI_MSG_MAKE.

  LOOP AT  RETURN.

    MOVE : RETURN-TYPE         TO     IT_ERR_LIST-MSGTYP,
           RETURN-ID           TO     IT_ERR_LIST-MSGID,
           RETURN-NUMBER       TO     IT_ERR_LIST-MSGNR,
           RETURN-MESSAGE_V1   TO     IT_ERR_LIST-MSGV1,
           RETURN-MESSAGE_V2   TO     IT_ERR_LIST-MSGV2,
           RETURN-MESSAGE_V3   TO     IT_ERR_LIST-MSGV3,
           RETURN-MESSAGE_V4   TO     IT_ERR_LIST-MSGV4,
           RETURN-MESSAGE      TO     IT_ERR_LIST-MESSTXT.

    CASE IT_ERR_LIST-MSGTYP.
      WHEN 'E' OR 'A'.
        MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
      WHEN 'I'.
        MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'S'.
        MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'W'.
        MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
    ENDCASE.
    APPEND  IT_ERR_LIST.
  ENDLOOP.

ENDFORM.                    " P2000_MULTI_MSG_MAKE
*&---------------------------------------------------------------------*
*&      Form  P3000_RECEIVE_FLAT_FILE
*&---------------------------------------------------------------------*
FORM P3000_RECEIVE_FLAT_FILE.

  PERFORM P2000_MULTI_SELECTION.
  IF W_SELECTED_LINES EQ 0.
    MESSAGE S977 WITH '�Ѱ� �̻��� �ڷḦ �����Ͻʽÿ�.'.
    EXIT.
  ENDIF.

  TEXT50  = 'EDI File Receipt Ȯ��'.
  TEXT100 = 'EDI File Receipt �۾��� ��� �����Ͻðڽ��ϱ�?'.

  PERFORM P2000_POPUP_MESSAGE USING TEXT50 TEXT100.

  IF W_BUTTON_ANSWER EQ '1'.                     " Ȯ���� ���.
    PERFORM P3000_DATA_UPDATE USING W_OK_CODE.   " ����Ÿ �ݿ�.
    DESCRIBE  TABLE IT_ERR_LIST   LINES  W_LINE.

    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.                    " P3000_RECEIVE_FLAT_FILE
*&---------------------------------------------------------------------*
*&      Form  P2000_RECEIVE_DATA
*&---------------------------------------------------------------------*
FORM P2000_RECEIVE_DATA USING W_ERR_CHK.

  CLEAR W_ERR_CHK.
  IF P_DEL EQ 'X'. MOVE 'X' TO L_DEL. ENDIF.      " File �������� Check.

  CASE IT_SELECT-FILENAME+18(6).
    WHEN 'INF700'.    ">L/C �������伭.
      CALL FUNCTION 'ZIM_MAT_INF700_EDI_DOC'
           EXPORTING
                W_FILENAME   = IT_SELECT-FILENAME
                BACK_PATH    = ZTIMIMGTX-ZFRBAK
                W_DEL        = L_DEL
           TABLES
                RETURN       = RETURN
           EXCEPTIONS
                UPDATE_ERROR = 4
                OTHERS       = 8.

    WHEN 'INF707'.    ">L/C ���Ǻ������伭.
      CALL FUNCTION 'ZIM_MAT_INF707_EDI_DOC'
           EXPORTING
                W_FILENAME   = IT_SELECT-FILENAME
                BACK_PATH    = ZTIMIMGTX-ZFRBAK
                W_DEL        = L_DEL
           TABLES
                RETURN       = RETURN
           EXCEPTIONS
                UPDATE_ERROR = 4
                OTHERS       = 8.

    WHEN 'LOCADV'.    ">Local L/C �������伭.       NCW Ǯ����
*      CALL FUNCTION 'ZIM_MAT_LOCADV_EDI_DOC'
*           EXPORTING
*                W_FILENAME   = IT_SELECT-FILENAME
*                BACK_PATH    = ZTIMIMGTX-ZFRBAK
*                W_DEL        = L_DEL
*           TABLES
*                RETURN       = RETURN
*           EXCEPTIONS
*                UPDATE_ERROR = 4
*                OTHERS       = 8.

    WHEN 'LOCAMA'.    ">Local L/C ���Ǻ������伭.  NCW Ǯ����
*      CALL FUNCTION 'ZIM_MAT_LOCAMA_EDI_DOC'
*           EXPORTING
*                W_FILENAME   = IT_SELECT-FILENAME
*                BACK_PATH    = ZTIMIMGTX-ZFRBAK
*                W_DEL        = L_DEL
*           TABLES
*                RETURN       = RETURN
*           EXCEPTIONS
*                UPDATE_ERROR = 4
*                OTHERS       = 8.

    WHEN 'LOGUAR'.    ">����ȭ�����뺸����.
*      CALL FUNCTION 'ZIM_MAT_LOGUAR_EDI_DOC'
*           EXPORTING
*                W_FILENAME   = IT_SELECT-FILENAME
*                BACK_PATH    = ZTIMIMGTX-ZFRBAK
*                W_DEL        = L_DEL
*           TABLES
*                RETURN       = RETURN
*           EXCEPTIONS
*                UPDATE_ERROR = 4
*                OTHERS       = 8.

    WHEN OTHERS.

  ENDCASE.

  CASE SY-SUBRC.
    WHEN 0.
      COMMIT WORK.
    WHEN 4.
      MESSAGE E771 WITH IT_SELECT-FILENAME.
      ROLLBACK WORK.
    WHEN OTHERS.
      MESSAGE E323 WITH IT_SELECT-FILENAME.
      ROLLBACK WORK.
  ENDCASE.

ENDFORM.                    " P2000_RECEIVE_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_DISPLAY_DOCUMENT
*&---------------------------------------------------------------------*
FORM P3000_DISPLAY_DOCUMENT.
  SELECT SINGLE * FROM ZTDHF1
                 WHERE ZFDHENO = IT_TAB-ZFDHENO.

  IF SY-SUBRC EQ 0.
    CASE IT_TAB-ZFDHDOC.
      WHEN 'INF700' OR 'LOCADV'.
        SET PARAMETER ID 'ZPREQNO' FIELD ZTDHF1-ZFDHREF(10).
        SET PARAMETER ID 'ZPOPNNO' FIELD ''.
        SET PARAMETER ID 'BES'     FIELD ''.
        CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.
      WHEN 'INF707' OR 'LOCAMA'.
        SET PARAMETER ID 'ZPOPNNO' FIELD ''.
        SET PARAMETER ID 'BES'     FIELD ''.
        SET PARAMETER ID 'ZPREQNO' FIELD ZTDHF1-ZFDHREF(10).
        SET PARAMETER ID 'ZPAMDNO' FIELD ZTDHF1-ZFDHREF+11(5).
        CALL TRANSACTION 'ZIM13' AND SKIP FIRST SCREEN.
      WHEN 'LOGUAR'.
        SET PARAMETER ID 'ZPHBLNO' FIELD ''.
        SET PARAMETER ID 'ZPBLNO' FIELD ZTDHF1-ZFDHREF(10).
        SET PARAMETER ID 'ZPLGSEQ' FIELD ZTDHF1-ZFDHREF+11(5).
        CALL TRANSACTION 'ZIM28' AND SKIP FIRST SCREEN.
      WHEN OTHERS.
    ENDCASE.
  ELSE.
    MESSAGE S263.
  ENDIF.
ENDFORM.                    " P3000_DISPLAY_DOCUMENT
