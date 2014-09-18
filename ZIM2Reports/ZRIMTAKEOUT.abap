*&---------------------------------------------------------------------*
*& Report  ZRIMTAKEOUT                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����Ű� Report Program                               *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.07.11                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMTAKEOUT   MESSAGE-ID ZIM
                      LINE-SIZE 144
                      NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* ���Կ���/����/���� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFBLNO      LIKE     ZTBLOUR-ZFBLNO,   "B/L ������?
       ZFHBLNO     LIKE     ZTBL-ZFHBLNO,     "HOUSE BL NO.
       ZFBTSEQ     LIKE     ZTBLOUR-ZFBTSEQ,  "������� �Ϸ�?
       ZFINRNO     LIKE     ZTBLOUR-ZFOURNO,  "����Ű��?
       ZFABNAR     LIKE     ZTBLOUR-ZFABNAR,  "�������� CODE
       ZFBNARM     LIKE     ZTIMIMG03-ZFBNARM,"����������.
       ZFBNARCD    LIKE     ZTBLOUR-ZFBNARCD, "�������� ID
       ZFYR        LIKE     ZTBLOUR-ZFYR,     "��?
       ZFSEQ       LIKE     ZTBLOUR-ZFSEQ,    "�Ϸù�ȣ.
       ZFEDINF     LIKE     ZTBLOUR-ZFEDINF,  "���ڹ�����?
       ZFINRC      LIKE     ZTBLOUR-ZFINRC,   "�Ű��� ��?
       INRC        LIKE     DD07T-DDTEXT,     "������.
       ZFINRCD     LIKE     ZTBLOUR-ZFINRCD,  "������ ��� ��?
       ZFPINS      LIKE     ZTBLOUR-ZFPOUS,   "���ҹ��� ��?
       ZFPRIN      LIKE     ZTBLOUR-ZFPROU,   "���ҹ��ⱸ?
       ZFPRDS      LIKE     ZTBLOUR-ZFPRDS,   "����Ⱓ ����?
       ZFCYCFS     LIKE     ZTBLOUR-ZFCYCFS,  "CY/CFS ��?
       ZFPKCN      LIKE     ZTBLOUR-ZFOUQN,   "�ѹ��ⰳ?
       ZFPKCNM     LIKE     ZTBLOUR-ZFOUQNM,  "�ѹ��ⰳ�� ��?
       ZFINWT      LIKE     ZTBLOUR-ZFOUWT,   "������?
       ZFINTWT     LIKE     ZTBLOUR-ZFOUTWT,  "���������?
       ZFINTQN     LIKE     ZTBLOUR-ZFOUTQN,  "������ⰳ?
       ZFKG        LIKE     ZTBLOUR-ZFKG,     "���Դ�?
       ZFCT        LIKE     ZTBLOUR-ZFCT,     "������?
       ZFUSCD      LIKE     ZTBLINR-ZFUSCD,   "�뵵.
       USCD        LIKE     DD07T-DDTEXT,
       ZFINDT      LIKE     ZTBLINR-ZFINDT,   "������.
       ZFEDIST     LIKE     ZTBLINR-ZFEDIST,   " EDI STATUS
       EDIST       LIKE     DD07T-DDTEXT,
       ZFEDICK     LIKE     ZTBLINR-ZFEDICK,   " EDI CHECK
       EDICK       LIKE     DD07T-DDTEXT,
       CHECK(1)    VALUE 'N',                 "�����������.
     END OF IT_TAB.
*-----------------------------------------------------------------------
* BDC �� Table
*-----------------------------------------------------------------------
DATA:    BEGIN OF ZBDCDATA OCCURS 0.
         INCLUDE STRUCTURE BDCDATA.
DATA     END OF ZBDCDATA.

DATA : W_ZFUSCD        LIKE    ZTBLINR-ZFUSCD,
       W_ZFOTDT        LIKE    ZTBLOUR-ZFOTDT,
       OK-CODE         LIKE    SY-UCOMM,
       DISPMODE(1)     TYPE C,
       W_PROC_CNT      TYPE I,        " ó���Ǽ�.
       UMODE           VALUE 'S'.     " Async, Sync


*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
TABLES: ZTIMIMG03.
INCLUDE   ZRIMBLTOP01.    " B/L ���� Data Define�� Include
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ��?
INCLUDE   ZRIMMESSAGE.    " Message


*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BNARCD  FOR ZTBLINR-ZFBNARCD,  " ����?
                   S_BLNO    FOR ZTBLINR-ZFBLNO,   " B/L ������?
                   S_HBLNO   FOR ZTBL-ZFHBLNO,      " House B/L No.
                   S_ZFYR    FOR ZTBLINR-ZFYR       " �������� ���Գ�?
                             NO-EXTENSION
                             NO INTERVALS,
                   S_INRCD   FOR ZTBLINR-ZFINRCD,   " ����.
                   S_ZFSEQ   FOR ZTBLINR-ZFSEQ,     " �������� ����SEQ
                   S_INDT    FOR ZTBLINR-ZFINDT,    " ������?
                   S_EDIST   FOR ZTBLINR-ZFEDIST,   " EDI STATUS
                   S_EDICK   FOR ZTBLINR-ZFEDICK,   " EDI CHECK
                   S_USCD    FOR ZTBLINR-ZFUSCD.    " �뵵��?
*   PARAMETERS :    P_BNAME   LIKE USR02-BNAME.      " �Է�?
   SELECTION-SCREEN SKIP 1.                         " 1 LINE SKIP
   PARAMETERS : P_OPEN     AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B1.
*-----------------------------------------------------------------------
* ���ԽŰ� SELECT ���� PARAMETER
*-----------------------------------------------------------------------

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

* ���ԽŰ� SELECT
   PERFORM   P1000_GET_ZTBL_INR        USING   W_ERR_CHK.
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
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFGMNO'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'DISP' OR 'DIS1' OR 'DIS2' OR 'DIS3'.         " ��ȸ.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_SHOW_DOC  USING IT_SELECTED-ZFBLNO
                                          IT_SELECTED-ZFBTSEQ
                                          IT_SELECTED-CHECK.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
         PERFORM   P1000_GET_ZTBL_INR        USING   W_ERR_CHK.
         IF W_ERR_CHK EQ 'Y'.
            LEAVE TO SCREEN 0.
         ELSE.
            PERFORM RESET_LIST.
         ENDIF.

      WHEN 'OUCR1' .          " ����Ű� ����.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
            PERFORM P4000_GET_INIVAL.
* ���ԽŰ����� SELECT
            PERFORM   P1000_GET_ZTBL_INR        USING   W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.
               LEAVE TO SCREEN 0.
            ELSE.
               PERFORM RESET_LIST.
            ENDIF.
         ENDIF.
      WHEN 'OUCR2' .          " ����Ű���� �� EDI CREATE
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES NE 0.
* BDC CALL.
            PERFORM P4000_GET_INIVAL.

* ���Կ������� SELECT
            PERFORM   P1000_GET_ZTBL_INR        USING   W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.
               LEAVE TO SCREEN 0.
            ELSE.
               PERFORM RESET_LIST.
            ENDIF.
         ENDIF.

      WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
* ���Կ������� SELECT
           PERFORM   P1000_GET_ZTBL_INR        USING   W_ERR_CHK.
           IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
           PERFORM RESET_LIST.
      WHEN OTHERS.
   ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIMO0'.          " TITLE BAR
  S_ZFYR = SY-DATUM(2).

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /60  '  [ Carry-in Declaration List ]  '
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 125 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,
            ' ',                  SY-VLINE,
            (24)  'Carry-in No.', SY-VLINE,
            (14)  'Carry-out Y/N', SY-VLINE,
            (06)  'Car.in',        SY-VLINE,
            (18)  'Bonded Area',     SY-VLINE,
            (15)  'Customs.of.Decl',   SY-VLINE,
            (10)  'Car.in Amt',
            (04)  '  ',     SY-VLINE,
            (13)  'EDI Status',    SY-VLINE,
            (10)  'Usage Type', SY-VLINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',        SY-VLINE,
            (24)  'B/L No',       SY-VLINE,
            (14)  'Bond.Trans.Seq',  SY-VLINE,
            (06)  'Year',         SY-VLINE,
            (10)  'Code',
            (07)  'ID',           SY-VLINE,
            (10)  'Code',
            (04)  'Sign',         SY-VLINE,
            (10)  'Car.in.Wt',
            (04)  ' ',     SY-VLINE,
            (13)  'EDI Check',    SY-VLINE,
            (10)  'Car.in.Dat',       SY-VLINE.
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
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIMO0'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMO0'.           " GUI TITLE SETTING..

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
        ZFBLNO  LIKE ZTBLINOU-ZFBLNO,
        ZFHBLNO LIKE ZTBL-ZFHBLNO,
        ZFBTSEQ LIKE ZTBLINOU-ZFBTSEQ,
        CHECK(1).


  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFBLNO   TO ZFBLNO,
         IT_TAB-ZFHBLNO  TO ZFHBLNO,
         IT_TAB-ZFBTSEQ  TO ZFBTSEQ,
         IT_TAB-CHECK    TO CHECK.

  DO.
    CLEAR: MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.

    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      W_TABIX = SY-INDEX + 1.
      MOVE : IT_TAB-ZFBLNO   TO IT_SELECTED-ZFBLNO,
             IT_TAB-ZFHBLNO  TO IT_SELECTED-ZFHBLNO,
             IT_TAB-ZFBTSEQ  TO IT_SELECTED-ZFBTSEQ,
             IT_TAB-CHECK    TO IT_SELECTED-CHECK.


      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
    IF INDEX GT 0.
      MOVE : ZFBLNO  TO IT_SELECTED-ZFBLNO,
             ZFHBLNO TO IT_SELECTED-ZFHBLNO,
             ZFBTSEQ TO IT_SELECTED-ZFBTSEQ,
             CHECK   TO IT_SELECTED-CHECK.

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
     WRITE : / 'Total', W_COUNT, 'Case'.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

  WRITE : / SY-VLINE,
            MARKFIELD  AS CHECKBOX
            COLOR COL_NORMAL INTENSIFIED OFF, SY-VLINE,
            (24) IT_TAB-ZFINRNO,    SY-VLINE, " ���ԽŰ��ȣ.
            (14) IT_TAB-CHECK,      SY-VLINE, " �������.
            (06) IT_TAB-ZFSEQ,      SY-VLINE, " �Ϸù�ȣ.
            (18) IT_TAB-ZFBNARM,    SY-VLINE, " ��������.
            (15) IT_TAB-INRC,       SY-VLINE, " �Ű�������.
            (10) IT_TAB-ZFPKCN UNIT IT_TAB-ZFCT,  " �ѹ��԰���.
            (04) IT_TAB-ZFPKCNM,     SY-VLINE,  " ��������.
            (13) IT_TAB-EDIST,       SY-VLINE,
            (10) IT_TAB-USCD,        SY-VLINE.  " �뵵����.

  HIDE: IT_TAB.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',          SY-VLINE,
            (24) IT_TAB-ZFHBLNO,    SY-VLINE,
            (14) IT_TAB-ZFBTSEQ,    SY-VLINE,
            (06) IT_TAB-ZFYR,       SY-VLINE,  " ����.
            (10) IT_TAB-ZFABNAR,               " ��������.
            (07) IT_TAB-ZFBNARCD,   SY-VLINE,  " ��������ID.
            (10) IT_TAB-ZFINRC,                " CODE.
            (04) IT_TAB-ZFINRCD,    SY-VLINE,  " ��������ȣ.
            (10) IT_TAB-ZFINWT UNIT IT_TAB-ZFKG,   " �����߷�
            (04) IT_TAB-ZFKG,       SY-VLINE,  " �߷�����.
            (13) IT_TAB-EDICK,      SY-VLINE,
            (10) IT_TAB-ZFINDT,     SY-VLINE.

  WRITE: SY-ULINE.
  HIDE: IT_TAB.
  W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_UPDATE
*&---------------------------------------------------------------------*
FORM P3000_DATA_UPDATE.

*  LOOP AT IT_TAB   WHERE UPDATE_CHK EQ 'U'.
* �����Ƿ� ���� table Select
*     SELECT SINGLE * FROM   ZTREQST
*                     WHERE  ZFREQNO EQ IT_TAB-ZFREQNO
*                     AND    ZFAMDNO EQ '00'.

*-----------------------------------------------------------------------
* ���� data�� Temp Table�� Move
*-----------------------------------------------------------------------

* ���� ����Ÿ Move
*     MOVE : IT_TAB-ZFRLST1  TO  ZTREQST-ZFRLST1,     " ������ ��?
*            IT_TAB-ZFRLDT1  TO  ZTREQST-ZFRLDT1,     " ������ ��?
*            IT_TAB-ZFRLNM1  TO  ZTREQST-ZFRLNM1.     " ���?

*     UPDATE ZTREQST.                                 " DATA UPDATE
*      IF SY-SUBRC EQ 0.
*-----------------------------------------------------------------------
* �����̷� ��?
**----------------------------------------------------------------------
**        PERFORM  SET_LC_HEADER_CHANGE_DOCUMENT.      " ���� ��?
*      ELSE.
**        MESSAGE E031 WITH ZTREQHD-ZFREQNO.
*         ROLLBACK WORK.                               " ����?
*      ENDIF.
*
*  ENDLOOP.
*
*  IF SY-SUBRC EQ 0.
*     COMMIT WORK.                                   " �������� ��?
*  ENDIF.

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
*&      Form  P1000_GET_ZTBL_INR
*&---------------------------------------------------------------------*
FORM P1000_GET_ZTBL_INR  USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting
  REFRESH IT_TAB.
  CLEAR IT_TAB.
  SELECT  *
     FROM ZTBLINR
     WHERE ZFBLNO   IN S_BLNO
       AND ZFBNARCD IN S_BNARCD  " ����?
       AND ZFBLNO   IN S_BLNO    " B/L ������?
       AND ZFYR     IN S_ZFYR    " �������� ���Գ�?
       AND ZFSEQ    IN S_ZFSEQ   " �������� ����SEQ
       AND ZFINRCD  IN S_INRCD   " ����.
       AND ZFINDT   IN S_INDT    " ������?
       AND ZFEDIST  IN S_EDIST   " EDI STATUS
       AND ZFEDICK  IN S_EDICK   " EDI CHECK
       AND ZFUSCD   IN S_USCD.    " �뵵����.
*      AND ERNAM    =  P_BNAME.   " ������.
     SELECT  SINGLE *
        FROM ZTBL
        WHERE ZFBLNO  = ZTBLINR-ZFBLNO
         AND  ZFHBLNO IN S_HBLNO.
     IT_TAB-CHECK = 'N'.
     IF SY-SUBRC NE 0.
        CONTINUE.
     ENDIF.
     SELECT SINGLE *
       FROM ZTBLOUR
      WHERE ZFBLNO  = ZTBLINR-ZFBLNO
        AND ZFBTSEQ = ZTBLINR-ZFBTSEQ.
     IF SY-SUBRC EQ 0.
        IF P_OPEN  EQ 'X'.    " ���ⵥ��Ÿ ���Խ�.
           IT_TAB-CHECK = 'Y'.
        ELSE.
           CONTINUE.
        ENDIF.
     ENDIF.

     PERFORM GET_DD07T_SELECT(SAPMZIM00) USING 'ZDUSCD' ZTBLINR-ZFUSCD
                                   CHANGING   IT_TAB-USCD.

     PERFORM GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCOTM' ZTBLINR-ZFINRC
                                   CHANGING   IT_TAB-INRC.
     PERFORM GET_DD07T_SELECT(SAPMZIM00) USING 'ZDEDIST'
                                   ZTBLINR-ZFEDIST
                                   CHANGING   IT_TAB-EDIST.
     PERFORM GET_DD07T_SELECT(SAPMZIM00) USING 'ZDOX' ZTBLINR-ZFEDICK
                                   CHANGING   IT_TAB-EDICK.
     SELECT SINGLE *
         FROM ZTIMIMG03
         WHERE ZFBNAR = ZTBLINR-ZFABNAR.

     MOVE-CORRESPONDING ZTBLINR TO IT_TAB.
     MOVE: ZTBL-ZFHBLNO      TO IT_TAB-ZFHBLNO,
           ZTIMIMG03-ZFBNARM TO IT_TAB-ZFBNARM.

     APPEND IT_TAB.
  ENDSELECT.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE EQ 0.
      MESSAGE S738.
      W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_GET_ZTBL_INR
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_DOC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_DOC USING    P_ZFBLNO P_ZFBTSEQ P_CHECK.

   SET PARAMETER ID 'ZPBLNO'   FIELD P_ZFBLNO.
   SET PARAMETER ID 'ZPHBLNO'  FIELD ''.
   SET PARAMETER ID 'ZPBTSEQ'  FIELD P_ZFBTSEQ.
   EXPORT 'ZPHBLNO'       TO MEMORY ID 'ZPHBLNO'.
   EXPORT 'ZPBLNO'        TO MEMORY ID 'ZPBLNO'.
   EXPORT 'ZPBTSEQ'       TO MEMORY ID 'ZPBTSEQ'.

   IF SY-UCOMM EQ 'DISP'.               " ���Կ�����?
      CALL TRANSACTION 'ZIMI3' AND SKIP  FIRST SCREEN.
   ELSEIF SY-UCOMM EQ 'DIS1'.           " ���Խ�?
      CALL TRANSACTION 'ZIMI8' AND SKIP  FIRST SCREEN.
   ELSEIF SY-UCOMM EQ 'DIS2'.           " �����?
      IF P_CHECK EQ 'N'.
         MESSAGE E055 WITH P_ZFBLNO P_ZFBTSEQ.
      ENDIF.
      CALL TRANSACTION 'ZIMO3' AND SKIP  FIRST SCREEN.

   ELSEIF SY-UCOMM EQ 'DIS3'.           " B/L
      CALL TRANSACTION 'ZIM23' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_DOC
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
MODULE SET_STATUS_SCR0001 OUTPUT.

*  SET TITLEBAR 'POPU' WITH '����Ű�'.
*  SET PF-STATUS 'POPU'.

ENDMODULE.                 " SET_STATUS_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_OK_CODE_SCR0001  INPUT
*&---------------------------------------------------------------------*
MODULE GET_OK_CODE_SCR0001 INPUT.

  IF OK-CODE NE 'YES'.
     SET SCREEN 0.
     LEAVE SCREEN.
  ENDIF.

 IF W_ZFOTDT IS INITIAL.
     MOVE SY-DATUM    TO W_ZFOTDT.
  ENDIF.

  SET SCREEN 0.   LEAVE SCREEN.

ENDMODULE.                 " GET_OK_CODE_SCR0001  INPUT
*&---------------------------------------------------------------------*
*&      Form  P4000_GET_INIVAL
*&---------------------------------------------------------------------*
FORM P4000_GET_INIVAL.

  PERFORM P2000_POPUP_MESSAGE USING
                    'Confirmation'
                    'Do you apply with selected document?'
*                    '������ ������ �ݿ��Ͻðڽ��ϱ�?'
                    '  Yes   '
                    '   No   '
                    '1'
                    W_BUTTON_ANSWER.
  CLEAR W_PROC_CNT.
  IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ��?
     LOOP AT IT_SELECTED.

        PERFORM P4000_BDC_VALID_CHECK.
        PERFORM ZTBLOUR_BDC_INSERT.
        DISPMODE = 'N'.
        CALL TRANSACTION 'ZIMO1'
                  USING       ZBDCDATA
                  MODE        DISPMODE
                  UPDATE      UMODE.
       IF SY-SUBRC <> 0.
          MESSAGE I952.
          W_ERR_CHK = 'Y'.
          EXIT.
        ENDIF.
        ADD 1       TO W_PROC_CNT.
     ENDLOOP.
     MESSAGE S924 WITH W_PROC_CNT.
     EXIT.
  ENDIF.

ENDFORM.                    " P4000_GET_INIVAL
*&---------------------------------------------------------------------*
*&      Form  P4000_BDC_VALID_CHECK
*&---------------------------------------------------------------------*
FORM P4000_BDC_VALID_CHECK.

  IF IT_SELECTED-CHECK EQ 'Y'. " �̹� ����Ű� �ִ� ���.
     DELETE  FROM ZTBLOUR WHERE ZFBLNO  = IT_SELECTED-ZFBLNO
                            AND ZFBTSEQ = IT_SELECTED-ZFBTSEQ.

  ENDIF.

ENDFORM.                    " P4000_BDC_VALID_CHECK
*&---------------------------------------------------------------------*
*&      Form  ZTBLOUR_BDC_INSERT
*&---------------------------------------------------------------------*
FORM ZTBLOUR_BDC_INSERT.

  REFRESH ZBDCDATA.
  PERFORM A_ZBDCDATA USING 'X' 'SAPMZIM01' '9221'.

  PERFORM A_ZBDCDATA USING :
      ' ' 'BDC_CURSOR' 'ZSREQHD-ZFBLNO',
      ' ' 'BDC_OKCODE' '=ENTR',                   " ENTER
      ' ' 'ZSREQHD-ZFBLNO'   IT_SELECTED-ZFBLNO,  " B/L NUMBER.
      ' ' 'ZSREQHD-ZFBTSEQ'	  IT_SELECTED-ZFBTSEQ.

  PERFORM A_ZBDCDATA USING 'X' 'SAPMZIM01' '9220'.
  PERFORM A_ZBDCDATA USING :
     ' ' 'BDC_CURSOR'	'ZTBLOUR-ZFINRCD',
     ' ' 'BDC_OKCODE'	'=SAVE'.
  PERFORM A_ZBDCDATA USING 'X' 'SAPMZIM01' '0001'.
  PERFORM A_ZBDCDATA USING :
     ' ' 'BDC_OKCODE'	'=YES'.

ENDFORM.                    " ZTBLOUR_BDC_INSERT
*&---------------------------------------------------------------------*
*&      Form  A_ZBDCDATA
*&---------------------------------------------------------------------*
FORM A_ZBDCDATA USING   BEGIN_CHECK OBJNAM VALUE.

  CLEAR ZBDCDATA.
  IF BEGIN_CHECK = 'X'.
     MOVE : OBJNAM TO ZBDCDATA-PROGRAM,
            VALUE  TO ZBDCDATA-DYNPRO,
            BEGIN_CHECK TO ZBDCDATA-DYNBEGIN.
  ELSE.
     MOVE : OBJNAM TO ZBDCDATA-FNAM,
            VALUE  TO ZBDCDATA-FVAL.
  ENDIF.
  APPEND ZBDCDATA.

ENDFORM.                    " A_ZBDCDATA
