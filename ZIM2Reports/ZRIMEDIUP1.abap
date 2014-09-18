*&---------------------------------------------------------------------*
*& Report  ZRIMEDIUP1                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : READY KOREA LTD. EDI Document Receipt                 *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.08                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : READY Korea Interface��( EDI Document Receipt )
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMEDIUP1   MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.

*TABLES: ZTDHF1.

*------ EDI
DATA  :  UPLOAD_PATH(300)     TYPE       C     " loading data
                              VALUE      '/ABAP/EDI/bin/skcimport'.
DATA  :  FILE_NAME(300)       TYPE       C.

DATA : W_OK_CODE    LIKE   SY-UCOMM,
       W_ZFDHENO         LIKE   ZTDHF1-ZFDHENO,
       W_ZFCDDOC         LIKE   ZTCDF1-ZFCDDOC,
       W_ZFDHSRO         LIKE   ZTDHF1-ZFDHSRO,
       W_ZFDHREF         LIKE   ZTDHF1-ZFDHREF.
*       W_ZFDHDDB         LIKE   ZTDHF1-ZFDHDDB.

DATA  W_EDI_RECORD(65535).
DATA: BEGIN OF IT_TAB OCCURS 0,
      W_RECORD   LIKE     W_EDI_RECORD,
      END OF IT_TAB.

DATA: BEGIN OF IT_TAB1 OCCURS 0,
      ZFDHENO     LIKE     ZTDHF1-ZFDHENO,  " ����������ȣ.
      ZFDHDOC     LIKE     ZTDHF1-ZFDHDOC,  " ���� ����.
      ZFFILE(100),
      END OF IT_TAB1.

DATA: BEGIN OF IT_SELECT OCCURS 0,
      ZFDHENO     LIKE     ZTDHF1-ZFDHENO,  " ����������ȣ.
      ZFDHDOC     LIKE     ZTDHF1-ZFDHDOC,  " ���� ����.
      END OF IT_SELECT.

DATA: TEXT100(100),
      TEXT50(50).

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMPRELTOP.    " ���� Released  Report Data Define�� Include
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ��?
INCLUDE   ZRIMBDCCOM.     " �����Ƿ� BDC ���� Include

*-----------------------------------------------------------------------
* Selection Screen ��.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_DHENO FOR ZTDHF1-ZFDHENO,  " ����������ȣ.
                   S_DHDOC FOR ZTDHF1-ZFDHDOC.  " ���ڹ��� ����.
SELECTION-SCREEN END OF BLOCK B1.

*&---------------------------------------------------------------------*
*&  BDC MODE ���� �߰�...
*&---------------------------------------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-004.
*selection-screen: begin of line,  comment 1(13) text-021, position 1.
*      selection-screen: comment 32(1) text-022, position 34.
*         parameters j1 radiobutton group rad1.              " Display
*      selection-screen: comment 40(1) text-023, position 42.
*         parameters j2 radiobutton group rad1 default 'X'.  " Backgroud
*     selection-screen: comment 48(1) text-024, position 50.
*        parameters j3 radiobutton group rad1.               " Error
*selection-screen end of line.
*selection-screen: comment /1(79) text-025.
*selection-screen end of block b4.

* Screen Selection
*at selection-screen.
*   if j1 = 'X'. disp_mode = 'A'. endif.
*   if j2 = 'X'. disp_mode = 'N'. endif.
*   if j3 = 'X'. disp_mode = 'E'. endif.

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

* ���� ����.
   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* UPLOAD�� FILENAME�� �����ϴ� �����ƾ.
   PERFORM   P1000_GET_UPLOAD_FILE     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   W_OK_CODE = SY-UCOMM.
   CASE SY-UCOMM.
* SORT ����.
      WHEN 'STUP' OR 'STDN'.         " SORT ���ý�...
*         W_FIELD_NM = 'ZFOPBN'.
*         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
*         PERFORM HANDLE_SORT TABLES  IT_TAB
*                             USING   SY-UCOMM.
* ��ü ���� �� ��������.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������ü.
         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'DISP'.          " L/C ��ȸ.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECT INDEX 1.
            PERFORM P2000_GET_DOC_KEY.
            PERFORM P2000_SHOW_DOCUMENT.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'EDII'.     " EDI RECEIPT.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
            TEXT50  = 'EDI File Receipt Ȯ��'.
            TEXT100 = 'EDI File Receipt �۾��� ��� �����Ͻðڽ��ϱ�?'.
            PERFORM P2000_POPUP_MESSAGE USING TEXT50 TEXT100.
            IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ���.
               PERFORM P3000_DATA_UPDATE USING W_OK_CODE. " ����Ÿ �ݿ�.
               LEAVE TO SCREEN 0.
            ENDIF.
         ENDIF.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
* UPLOAD�� FILENAME�� �����ϴ� �����ƾ.
         PERFORM   P1000_GET_UPLOAD_FILE     USING   W_ERR_CHK.
         IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
         PERFORM RESET_LIST.
      WHEN OTHERS.
   ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
  SET  TITLEBAR 'ZIME10'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
*  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /55  '[ EDI RECEIPT DOCUMENT ��� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.

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

   if disp_mode ne 'N'.            " BACKGROUND�� �ƴ� ���.
      authority-check object 'ZM_BDC_MGT'
              id 'ACTVT' field '*'.
      if sy-subrc ne 0.
         message s960 with sy-uname 'BDC ������'.
         w_err_chk = 'Y'.   exit.
      ENDIF.
   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK           USING   W_ERR_CHK.
*  W_ERR_CHK = 'N'.
** Import Config Select
*  SELECT SINGLE * FROM ZTIMIMG00.
** Not Found
*  IF SY-SUBRC NE 0.
*     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
*  ENDIF.
*
*  IF ZTIMIMG00-ZFRECV IS INITIAL.
*     W_ERR_CHK = 'Y'.   MESSAGE S978.   EXIT.
*  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIME10'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIME10'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   SORT IT_TAB1 BY ZFDHDOC ZFFILE ZFDHENO.
   CLEAR : IT_TAB1.

   LOOP AT IT_TAB1.
      W_LINE = W_LINE + 1.
*     PERFORM P2000_PAGE_CHECK.
*>>> File Name�� �ٲ𶧸���.
      ON CHANGE OF IT_TAB1-ZFFILE.
         PERFORM P3000_FILE_NAME_WRITE.
      ENDON.
*>>> Line Record Write.
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

  DATA: ZFDHENO LIKE ZTDHF1-ZFDHENO,
        ZFDHDOC LIKE ZTDHF1-ZFDHDOC.

  REFRESH IT_SELECT.
  CLEAR W_SELECTED_LINES.

  MOVE: IT_TAB1-ZFDHENO  TO   ZFDHENO,
        IT_TAB1-ZFDHDOC  TO   ZFDHDOC.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      MOVE : IT_TAB1-ZFDHENO  TO IT_SELECT-ZFDHENO,
             IT_TAB1-ZFDHDOC  TO IT_SELECT-ZFDHDOC.

      APPEND IT_SELECT.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
    IF NOT ZFDHENO IS INITIAL.
      MOVE : ZFDHENO TO IT_SELECT-ZFDHENO,
             ZFDHDOC TO IT_SELECT-ZFDHDOC.

      APPEND IT_SELECT.
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

     WRITE : / SY-ULINE,
             / '��', W_COUNT, '��'.
  ENDIF.


ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

   WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
         5 SY-VLINE,
           IT_TAB1-ZFDHDOC,            " ��������.
           SY-VLINE,
           IT_TAB1-ZFDHENO,            " ������ȣ.
       120 SY-VLINE.
** stored value...
   HIDE: IT_TAB1.
   W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE

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
FORM P2000_POPUP_MESSAGE  USING   P_HEADER   P_TEXT.

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = P_HEADER
             DIAGNOSE_OBJECT = ''
             TEXT_QUESTION   = P_TEXT
             TEXT_BUTTON_1   = 'Ȯ    ��'
             TEXT_BUTTON_2   = '�� �� ��'
             DEFAULT_BUTTON  = '1'
             DISPLAY_CANCEL_BUTTON = ' '
             START_COLUMN    = 30
             START_ROW       = 8
         IMPORTING
             ANSWER          =  W_BUTTON_ANSWER.

ENDFORM.                    " P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_DATA_UPDATE   USING   W_GUBUN.
DATA : L_REQTY   LIKE   ZTREQHD-ZFREQTY,
       L_RETURN  LIKE   SY-SUBRC,
       O_ZTREQST LIKE   ZTREQST,
       L_COUNT   TYPE   C.

   CLEAR : L_REQTY, L_COUNT.

   LOOP AT IT_SELECT.
      W_TABIX = SY-TABIX.
*>>> ������¹�..
      line = ( sy-tabix / w_selected_lines ) * 100.
      out_text = 'JOB PROGRESS %99999%%'.
      replace '%99999%' with line into out_text.
      perform p2000_show_bar using out_text line.

*>>> �����Ƿ� ���, ���� ���̺� ��ȸ...
      PERFORM P2000_GET_DOC_KEY.

      SELECT SINGLE * FROM ZTREQHD
                      WHERE ZFREQNO EQ ZTREQST-ZFREQNO.

*>>> Receipt�� ������ ���� ����...
      IF ZTREQHD-ZFCLOSE EQ 'X'.
         MESSAGE I354 WITH ZTREQST-ZFREQNO. CONTINUE.
      ENDIF.
      IF ZTREQST-ZFRTNYN EQ 'X'.
         MESSAGE I355 WITH ZTREQST-ZFREQNO ZTREQST-ZFAMDNO. CONTINUE.
      ENDIF.
      IF ZTREQST-ZFDOCST EQ 'O'.
         TEXT50  = '���۾� ���� Ȯ��'.
         TEXT100 = '�̹� ������ �����Դϴ�. ��� �����Ͻðڽ��ϱ�?'.
         PERFORM P2000_POPUP_MESSAGE USING TEXT50 TEXT100.
         IF W_BUTTON_ANSWER NE '1'.       " Ȯ���� ���.
            CONTINUE.
         ENDIF.
      ENDIF.

*>> �����̷�..
      O_ZTREQST = ZTREQST.

* LOCK CHECK
      PERFORM   P2000_LOCK_MODE_SET  USING    'L'
                                              ZTREQST-ZFREQNO
                                              ZTREQST-ZFAMDNO
                                              L_RETURN.
      CHECK L_RETURN EQ 0.

* ���� ����
*>>>>> .....
      MOVE : SY-UNAME    TO    ZTREQST-UNAM,
             SY-DATUM    TO    ZTREQST-UDAT,
             'O'         TO    ZTREQST-ZFDOCST,
             'R'         TO    ZTREQST-ZFEDIST,
*>>>>>>> ���� �����۾� ====> �������ι�ȣ/��������...

             IT_SELECT-ZFDHENO TO ZTREQST-ZFOPNNO,
             SY-DATUM          TO ZTREQST-ZFOPNDT,
             ZTREQST-ZFOPNNO   TO ZTREQHD-ZFOPNNO,
             ZTREQHD-ZFREQED   TO ZTREQHD-ZFLASTSD,
             ZTREQHD-ZFREQSD   TO ZTREQHD-ZFLASTED,
             W_ZFDHENO   TO    ZTREQST-ZFDOCNOR.


*>>> ����...
     UPDATE ZTREQHD.
     UPDATE ZTREQST.

* CHANGE DOCUMENT
     CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_STATUS'
     EXPORTING
        W_ZFREQNO      =     ZTREQST-ZFREQNO
        W_ZFAMDNO      =     ZTREQST-ZFAMDNO
        N_ZTREQST      =     ZTREQST
        O_ZTREQST      =     O_ZTREQST.

*>>> UNLOCK SETTTING.
     PERFORM   P2000_LOCK_MODE_SET  USING    'U'
                                              IT_SELECTED-ZFREQNO
                                              IT_SELECTED-ZFAMDNO
                                              L_RETURN.

     L_REQTY = IT_SELECTED-ZFREQTY.

   ENDLOOP.

ENDFORM.                    " P3000_DATA_UPDATE

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO  P_ZFAMDNO.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.

   EXPORT 'BES'           TO MEMORY ID 'BES'.
   EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPAMDNO'       TO MEMORY ID 'ZPAMDNO'.
   EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.

   IF P_ZFAMDNO IS INITIAL.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_LOCK_MODE_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_2559   text
*----------------------------------------------------------------------*
FORM P2000_LOCK_MODE_SET USING    VALUE(P_MODE)
                                  VALUE(P_REQNO)
                                  VALUE(P_AMDNO)
                                  P_RETURN.
* LOCK CHECK
   IF P_MODE EQ 'L'.
      CALL FUNCTION 'ENQUEUE_EZ_IM_ZTREQDOC'
           EXPORTING
                ZFREQNO                =     P_REQNO
                ZFAMDNO                =     P_AMDNO
           EXCEPTIONS
                OTHERS        = 1.

      MOVE SY-SUBRC     TO     P_RETURN.
      IF SY-SUBRC NE 0.
         MESSAGE I510 WITH SY-MSGV1 'Import Document' P_REQNO P_AMDNO
                      RAISING DOCUMENT_LOCKED.
      ENDIF.
   ELSEIF P_MODE EQ 'U'.
      CALL FUNCTION 'DEQUEUE_EZ_IM_ZTREQDOC'
           EXPORTING
             ZFREQNO                =     P_REQNO
             ZFAMDNO                =     P_AMDNO.
   ENDIF.
ENDFORM.                    " P2000_LOCK_MODE_SET


*&---------------------------------------------------------------------*
*&      Form  P1000_GET_UPLOAD_FILE
*&---------------------------------------------------------------------*
*       UPLOAD�� FILENAME�� �����ϴ� �����ƾ.
*----------------------------------------------------------------------*
FORM P1000_GET_UPLOAD_FILE USING    W_ERR_CHK.
DATA : L_COUNT    TYPE   I.

  FREE : IT_TAB, IT_TAB1.
  CLEAR : IT_TAB, IT_TAB1.

  MOVE 'N'        TO     W_ERR_CHK.

  OPEN    DATASET    UPLOAD_PATH   FOR   INPUT   IN  TEXT  MODE.
  DO.
      READ     DATASET     UPLOAD_PATH    INTO    FILE_NAME.
      IF       SY-SUBRC    =      4.
               EXIT.
      ENDIF.
*>>   file ---> internal table
      PERFORM  P1000_FILE_TO_ITAB.
*>>   FILE COUNTER ����.
      ADD    1    TO    L_COUNT.
  ENDDO.

  CLOSE    DATASET   UPLOAD_PATH.

  IF L_COUNT EQ 0.
     MOVE 'Y'        TO     W_ERR_CHK.
     MESSAGE  S920.  EXIT.
  ENDIF.

ENDFORM.                    " P1000_GET_UPLOAD_FILE

*&---------------------------------------------------------------------*
*&      Form  P1000_FILE_TO_ITAB
*&---------------------------------------------------------------------*
*       SAM-FILE ������ Internal Table�� Append
*----------------------------------------------------------------------*
FORM P1000_FILE_TO_ITAB.

  OPEN    DATASET    FILE_NAME     FOR     INPUT   IN  TEXT  MODE.
  DO.
      READ    DATASET    FILE_NAME     INTO    W_EDI_RECORD.
      IF       SY-SUBRC    =      4.
               EXIT.
      ENDIF.

      MOVE    W_EDI_RECORD             TO      IT_TAB-W_RECORD.
      APPEND  IT_TAB.

      MOVE:   FILE_NAME                TO      IT_TAB1-ZFFILE,
              IT_TAB(14)               TO      IT_TAB1-ZFDHENO,
              IT_TAB(06)               TO      IT_TAB1-ZFDHDOC.
      APPEND  IT_TAB1.
  ENDDO.

ENDFORM.                    " P1000_FILE_TO_ITAB

*&---------------------------------------------------------------------*
*&      Form  P3000_FILE_NAME_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_FILE_NAME_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
   WRITE : / SY-ULINE.
*   WRITE:/ SY-VLINE, MARKFIELD1  AS CHECKBOX,
   WRITE:/ SY-VLINE,
      5 SY-VLINE,
        IT_TAB1-ZFFILE NO-GAP,
    120 SY-VLINE.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE :/  SY-VLINE,
           5 SY-VLINE,
           6 SY-ULINE.

ENDFORM.                    " P3000_FILE_NAME_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_GET_DOC_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_GET_DOC_KEY.

  CASE IT_SELECT-ZFDHDOC.
     WHEN 'INF700' OR 'INF707' OR           " MASTER L/C
          'PURLIC' OR                       " ���Ž��μ�.
          'LOCADV' OR 'LOCAMR'              " LOCAL L/C
          OR 'APP700'.

        SELECT * FROM ZTREQST UP TO 1 ROWS
                 WHERE ZFDOCNO EQ IT_SELECT-ZFDHENO
                 AND   ZFAMDNO EQ '00000'.
        ENDSELECT.

     WHEN OTHERS.                           ">> ��Ÿ �ٸ� ������ �߰�.
  ENDCASE.

  W_SY_SUBRC = SY-SUBRC.

ENDFORM.                    " P2000_GET_DOC_KEY

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_DOCUMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SHOW_DOCUMENT.
  CASE IT_SELECT-ZFDHDOC.
     WHEN 'INF700' OR 'INF707' OR           " MASTER L/C
          'PURLIC' OR                       " ���Ž��μ�.
          'LOCADV' OR 'LOCAMR'              " LOCAL L/C
          OR 'APP700'.
        IF W_SY_SUBRC EQ 0.
           PERFORM P2000_SHOW_LC USING   ZTREQST-ZFREQNO
                                         ZTREQST-ZFAMDNO.
        ENDIF.

     WHEN OTHERS.                           ">> ��Ÿ �ٸ� ������ �߰�.
  ENDCASE.

ENDFORM.                    " P2000_SHOW_DOCUMENT
