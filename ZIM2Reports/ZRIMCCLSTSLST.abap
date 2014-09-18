*&---------------------------------------------------------------------*
*& Report  ZRIMCCLSTSLST                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �����ûȮ��                                          *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.10.15                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&  ���� ����μ� �Ǵ� ���� ���źμ����� �����û�� �Է��ϰ�, ����μ�
*& ���� �����û�� ���� ��ȸ �Ҽ� �ִ� ȭ��.
*&---------------------------------------------------------------------*
*& [���泻��]
*&  2001.12.27 �迵��
*&             : ���Ȯ�� ��� �����û�� Display.
*&---------------------------------------------------------------------*
REPORT  ZRIMCCLSTSLST MESSAGE-ID ZIM
*                     LINE-SIZE 105
                     NO STANDARD PAGE HEADING.

TABLES : ZTBL,ZTBLIT,EKKO,MBEW,MARA, ZTIMIMG00, ZTBLINR, ZTBLINR_TMP.

*-----------------------------------------------------------------------
* B/L �Լ����� ����Ʈ�� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFWERKS    LIKE ZTBL-ZFWERKS,             " PLANT.
       EBELN      LIKE ZTBLIT-EBELN,             " P/O.
       ZFBLIT     LIKE ZTBLIT-ZFBLIT,            " ǰ�� ITEM.
       ZFSHNO     LIKE ZTBL-ZFSHNO,              " ��������.
       ZFAPRT     LIKE ZTBL-ZFAPRT,              " ������.
       MATNR      LIKE ZTBLIT-MATNR,             " �����ڵ�.
       ZFRGDSR    LIKE ZTBL-ZFRGDSR,             " ��ǥǰ��.
       ZFBLNO     LIKE ZTBL-ZFBLNO,              " B/L DOCUMENT NO.
       ZFHBLNO    LIKE ZTBL-ZFHBLNO,             " HOUSE
       ZFETA      LIKE ZTBL-ZFETA,               " ������(ETA)
       BLMENGE    LIKE ZTBLIT-BLMENGE,           " B/L ����.
       LBKUM      LIKE MBEW-LBKUM,               " ��������.
       MEINS2     LIKE MARA-MEINS,               " ��������.
       MEINS      LIKE ZTBLIT-MEINS,             " ��������.
       ZFCCRDT    LIKE ZTBL-ZFCCRDT,             " �����û��
       ZFINRNO    LIKE ZTBL-ZFINRNO,             " ���Թ�ȣ.
       ZFCCNO     LIKE ZTBL-ZFCCNO,              " ���������ȣ.
       ZFCCCNAM   LIKE ZTBL-ZFCCCNAM.            " ���� �����.
DATA : END OF IT_TAB.
*-----------------------------------------------------------------------
* Menu Statsu Function�� Inactive�ϱ� ���� Internal Table
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_EXCL OCCURS 20,
       FCODE    LIKE RSMPE-FUNC.
DATA: END   OF IT_EXCL.
DATA : BEGIN OF IT_SELECTED OCCURS 0,
       ZFBLNO     LIKE ZTBL-ZFBLNO,              " B/L DOCUMENT NO.
       ZFCCRST    LIKE ZTBL-ZFCCRST,             " �����û����.
       ZFCCNAM    LIKE ZTBL-ZFCCNAM,             " �����û��.
       ZFCCRDT    LIKE ZTBL-ZFCCRDT,             " �����û����.
       ZFCCCNAM   LIKE ZTBL-ZFCCCNAM,            " ���Ȯ����.
       ZFCCCDT    LIKE ZTBL-ZFCCCDT,             " ���Ȯ������.
       ZFINRNO    LIKE ZTBL-ZFINRNO.             " ���Թ�ȣ.
DATA : END OF IT_SELECTED.

DATA : BEGIN OF IT_BL OCCURS 0.
       INCLUDE STRUCTURE ZTBL.
       DATA : LOCK     TYPE C VALUE 'N'.
DATA : END   OF IT_BL.

DATA :  W_ERR_CHK         TYPE C,
        W_LINE_CHK        TYPE C,
        W_GUBUN(08)       TYPE C,
        W_SUBRC           LIKE SY-SUBRC,
        W_SY_UCOMM        LIKE SY-UCOMM,
        W_UPDATE_CNT      TYPE I,
        W_SELECTED_LINES  TYPE P,
        W_PAGE            TYPE I,
        EGRKZ             LIKE T007A-EGRKZ,
        W_INRNO           LIKE ZTBL-ZFINRNO,
        W_CNAM            LIKE SY-UNAME,
        W_LINE            TYPE I,
        W_KRWAMT(18)      TYPE C,
        W_ZFCCRDT(10)     TYPE C,
        W_COUNT           TYPE I,
        W_TABIX           LIKE SY-TABIX,
        W_FIELD_NM        LIKE DD03D-FIELDNAME,
        W_LIST_INDEX      LIKE SY-TABIX,
        W_BUTTON_ANSWER   TYPE C.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ����.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BEDAT   FOR  EKKO-BEDAT,        " ����������.
                   S_MATNR   FOR  ZTBLIT-MATNR,      " �����ڵ�.
                   S_EKORG   FOR  EKKO-EKORG,        " ��������.
                   S_EKGRP   FOR  EKKO-EKGRP,        " ���ű׷�.
                   S_WERKS   FOR ZTBL-ZFWERKS NO INTERVALS  " ȸ���ڵ�.
                             NO-EXTENSION,
                   S_EBELN   FOR ZTBLIT-EBELN,     " P/O ��ȣ.
                   S_BLSDP   FOR ZTBL-ZFBLSDP,     " SD �ۺ�ó.
                   S_CCRDT   FOR ZTBL-ZFCCRDT.     " �����û��.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
  SELECTION-SCREEN : BEGIN OF LINE,POSITION 1.
     SELECTION-SCREEN : COMMENT 4(18) TEXT-021, POSITION 1.
     PARAMETERS : P_CREQ  RADIOBUTTON GROUP RDG.     " �����û.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN : BEGIN OF LINE,POSITION 1.
     SELECTION-SCREEN : COMMENT 4(18) TEXT-022, POSITION 1.
     PARAMETERS : P_CCFM      RADIOBUTTON GROUP RDG. " ���Ȯ��.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B2.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                                 " �ʱⰪ SETTING
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

* BL SELECT
   PERFORM   P1000_GET_IT_TAB          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.MESSAGE S738.    EXIT.    ENDIF.

   IF P_CCFM = 'X'.
       NEW-PAGE LINE-SIZE 154 NO-HEADING .
   ELSE.
       NEW-PAGE LINE-SIZE 118 NO-HEADING .
   ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.


*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   CASE SY-UCOMM.
     WHEN 'STUP' OR 'STDN'.         " SORT ����.
          W_FIELD_NM = 'ZFBLNO'.
          ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
          PERFORM HANDLE_SORT TABLES  IT_TAB
                              USING   SY-UCOMM.
* ��ü ���� �� ��������.
     WHEN 'MKAL' OR 'MKLO'.          " ��ü ���� �� ��������.
         PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
     WHEN 'REFR'.
         PERFORM   P1000_GET_IT_TAB          USING   W_ERR_CHK.
         IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
         PERFORM RESET_LIST.
     WHEN 'DISP1'.                       " B/L ��ȸ.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 0.
            MESSAGE S951.EXIT.
         ENDIF.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_DISP_ZTBL(SAPMZIM09) USING IT_SELECTED-ZFBLNO.
          ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
     WHEN 'CCCNF' OR 'CCREQ'.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 0.
            MESSAGE S951.EXIT.
         ENDIF.
         W_SY_UCOMM = SY-UCOMM.
         IF SY-UCOMM = 'CCCNF'.
            PERFORM P2000_POPUP_MESSAGE USING
                    'Confirmation'
                    '������ ������ �������ó�� �Ͻðڽ��ϱ�?'
                    'Ȯ    ��'
                    '�� �� ��'
                    '1'
                    W_BUTTON_ANSWER.
            MOVE '�������' TO W_GUBUN.
         ELSE.
            PERFORM P2000_POPUP_MESSAGE USING
                    'Confirmation'
                    '������ ������ �����û �Ͻðڽ��ϱ�?'
                    'Ȯ    ��'
                    '�� �� ��'
                    '1'
                    W_BUTTON_ANSWER.
            MOVE '�����û' TO W_GUBUN.
         ENDIF.
         IF W_BUTTON_ANSWER EQ '1'.       " Ȯ���� ��?
* B/L ����.
            PERFORM P3000_INPUT_DATA_SAVE.
            MESSAGE   S000(ZIM1) WITH W_UPDATE_CNT W_GUBUN .
* ���� �ٽ� �б�.
            PERFORM   P1000_GET_IT_TAB          USING   W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.
               LEAVE TO SCREEN 0.
            ELSE.
               PERFORM RESET_LIST.
            ENDIF.
         ENDIF.
     WHEN OTHERS.
  ENDCASE.


*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIMR70' WITH 'Clearance request'.      " TITLE BAR

  IF SY-TCODE EQ 'ZIMR70'.
     MOVE  'X'   TO  P_CREQ.
  ELSE.
     MOVE  'X'   TO  P_CCFM.
  ENDIF.

ENDFORM.                    " P2000_SET_PARAMETER

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  IF P_CCFM EQ 'X'.
     SKIP 2.
     FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
     WRITE : /53  ' [  Clearance Registration  ] '
                  COLOR COL_HEADING INTENSIFIED OFF.
     WRITE : /'Date : ', SY-DATUM.
     WRITE : / SY-ULINE.
     FORMAT COLOR COL_HEADING INTENSIFIED ON.
     WRITE:/ SY-VLINE,'',
             SY-VLINE,(15) 'P/O Doc',
             SY-VLINE,(15) 'B/L No',
             SY-VLINE,(25) 'Product name',
             SY-VLINE,(20) 'Port of discharge',
             SY-VLINE,(10) 'ETA',
             SY-VLINE,(10) 'Request date',
             SY-VLINE,(18) 'Registration No',
             SY-VLINE,(12) 'Person in charge',
             SY-VLINE.

     FORMAT COLOR COL_HEADING INTENSIFIED OFF.
     WRITE:/ SY-VLINE,'',
             SY-VLINE,(15) 'Material No',
             SY-VLINE,(15) 'Item No',
             SY-VLINE,(25) 'Quantity',
             SY-VLINE,(20) 'Current stock',
             SY-VLINE,(10) 'Shipping balance',
             SY-VLINE,(10) ' ',
             SY-VLINE,(18) ' ',
             SY-VLINE,(12) ' ',
             SY-VLINE.

     FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  ELSE.
     SKIP 2.
     FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
     WRITE : /53  ' [  Clearance request  ] '
                  COLOR COL_HEADING INTENSIFIED OFF.
     WRITE : /'Date : ', SY-DATUM.
     WRITE : / SY-ULINE.
     FORMAT COLOR COL_HEADING INTENSIFIED ON.
     WRITE:/ SY-VLINE,'',
             SY-VLINE,(15) 'P/O',
             SY-VLINE,(15) 'B/L No',
             SY-VLINE,(25) 'Product name',
             SY-VLINE,(20) 'Port of discharge',
             SY-VLINE,(10) 'ETA',
             SY-VLINE.
     WRITE: (10) 'Request date',
             SY-VLINE.

     FORMAT COLOR COL_HEADING INTENSIFIED OFF.
     WRITE:/ SY-VLINE,'',
             SY-VLINE,(15) 'Material No',
             SY-VLINE,(15) 'Item No',
             SY-VLINE,(25) 'Quantity',
             SY-VLINE,(20) 'Current stock',
             SY-VLINE,(10) 'Shipping balance',
             SY-VLINE.
     WRITE: (10) ' ',
            SY-VLINE.

     FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  ENDIF.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

   W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_BL_MGT'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'B/L ���� Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

*   SET PF-STATUS 'ZIM24'.           " GUI STATUS SETTING
   IF P_CCFM = 'X'.
       MOVE 'CCREQ' TO IT_EXCL-FCODE. APPEND IT_EXCL.   " ������.
       SET  TITLEBAR 'ZIMR70' WITH '�����û����'. " GUI TITLE SETTING..
   ENDIF.
   IF P_CREQ = 'X'.
       MOVE 'CCCNF' TO IT_EXCL-FCODE. APPEND IT_EXCL.   " ������.
       SET  TITLEBAR 'ZIMR70' WITH '�����û'.    " GUI TITLE SETTING..
   ENDIF.
*   SET PF-STATUS 'ZIMR70' EXCLUDING IT_EXCL. " TEMP

   W_COUNT = 0.

   IF P_CCFM = 'X'.
      SORT IT_TAB BY ZFCCRDT.
   ELSE.
      SORT IT_TAB BY ZFBLNO.
   ENDIF.

   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
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

   IF P_CCFM = 'X'.
       NEW-PAGE LINE-SIZE 154 NO-HEADING .
   ELSE.
       NEW-PAGE LINE-SIZE 118 NO-HEADING .
   ENDIF.

  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST

*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*FORM P2000_MULTI_SELECTION.
*
*  DATA: INDEX   TYPE P,
*        ZFREQNO LIKE ZTREQST-ZFREQNO,
*        ZFAMDNO LIKE ZTREQST-ZFAMDNO,
*        ZFRLST1 LIKE ZTREQST-ZFRLST1,
*        ZFRLST2 LIKE ZTREQST-ZFRLST2.
*
*  REFRESH IT_SELECTED.
*  CLEAR W_SELECTED_LINES.
*
*  MOVE : W_LIST_INDEX    TO INDEX,
*         IT_TAB-ZFBLNO   TO ZFREQNO.
*
*  DO.
*    CLEAR MARKFIELD.
*    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
*    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
*    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
*       MOVE : IT_TAB-ZFBLNO  TO IT_SELECTED-ZFREQNO.
**
*      APPEND IT_SELECTED.
*      ADD 1 TO W_SELECTED_LINES.
*    ENDIF.
*  ENDDO.
*
*  IF W_SELECTED_LINES EQ 0.
*    IF INDEX GT 0.
*      MOVE : ZFREQNO TO IT_SELECTED-ZFREQNO.
*
*      APPEND IT_SELECTED.
*      ADD 1 TO W_SELECTED_LINES.
*    ELSE.
*      MESSAGE S962.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  WRITE : / SY-ULINE.
  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / '��', W_COUNT, '��'.
*    WRITE : / SY-ULINE.    WRITE : / '��', W_COUNT, '��'.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  MOVE : IT_TAB-ZFINRNO  TO  W_INRNO,
         SY-UNAME        TO  W_CNAM.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ON CHANGE OF IT_TAB-ZFBLNO.
     WRITE:/ SY-ULINE.
     WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
             SY-VLINE,(15)IT_TAB-EBELN,   " P/O No',
             SY-VLINE,(15)IT_TAB-ZFHBLNO, " B/L No',
             SY-VLINE,(25)IT_TAB-ZFRGDSR, " ǰ   ��',
             SY-VLINE,(20)IT_TAB-ZFAPRT,  " ������
             SY-VLINE,(10)IT_TAB-ZFETA,   " ETA'   ,
             SY-VLINE.

     IF P_CCFM = 'X'.
         WRITE: (10) IT_TAB-ZFCCRDT,  SY-VLINE,
                (18) W_INRNO INPUT ON COLOR COL_POSITIVE
                                      INTENSIFIED ON,
                SY-VLINE,
                (12) W_CNAM  INPUT ON COLOR COL_POSITIVE
                                      INTENSIFIED ON,
                SY-VLINE.
     ELSE.
         WRITE SY-DATUM TO W_ZFCCRDT.
         WRITE: (10) W_ZFCCRDT INPUT ON
                                    COLOR COL_POSITIVE
                                    INTENSIFIED ON,
                SY-VLINE.
     ENDIF.

     HIDE: IT_TAB.
     W_COUNT = W_COUNT + 1.
  ENDON.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE:/ SY-VLINE,'',
          SY-VLINE,(15)IT_TAB-MATNR,  " �����ȣ',
          SY-VLINE,(15)IT_TAB-ZFBLIT, " Item No',
          SY-VLINE,(21)IT_TAB-BLMENGE
                        UNIT IT_TAB-MEINS ," ����',
                   (03)IT_TAB-MEINS,
          SY-VLINE,(16)IT_TAB-LBKUM  UNIT IT_TAB-MEINS2,  " �����',
                   (03)IT_TAB-MEINS2,
          SY-VLINE,(10)IT_TAB-ZFSHNO,  " ����' ,
          SY-VLINE,(10)' ',
          SY-VLINE.
     IF P_CCFM = 'X'.
         WRITE: (18) ' ', SY-VLINE,
                (12) ' ', SY-VLINE.
     ENDIF.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------*
FORM P1000_GET_IT_TAB USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting
  REFRESH : IT_TAB.
  W_ERR_CHK = 'N'.

  SELECT SINGLE * FROM ZTIMIMG00.
  RANGES: R_ZFCCRST FOR ZTBL-ZFCCRST OCCURS 5.
*>> ���� üũ.
  IF P_CREQ = 'X'.
       MOVE :    'I'       TO  R_ZFCCRST-SIGN,
                 'EQ'      TO  R_ZFCCRST-OPTION,
                 SPACE     TO  R_ZFCCRST-LOW,
                 SPACE     TO  R_ZFCCRST-HIGH.
       APPEND  R_ZFCCRST.
  ENDIF.
  IF P_CCFM = 'X'.
     MOVE :    'I'       TO  R_ZFCCRST-SIGN,
               'EQ'      TO  R_ZFCCRST-OPTION,
               'R'       TO  R_ZFCCRST-LOW,
               SPACE     TO  R_ZFCCRST-HIGH.
     APPEND  R_ZFCCRST.
  ENDIF.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
            FROM ZTBL AS H INNER JOIN ZTBLIT AS I
             ON H~ZFBLNO = I~ZFBLNO
            WHERE I~EBELN   IN S_EBELN
              AND I~MATNR   IN S_MATNR
              AND H~ZFCCRST IN R_ZFCCRST
              AND H~ZFWERKS IN S_WERKS.
  IF SY-SUBRC NE 0.  W_ERR_CHK = 'Y'. EXIT.  ENDIF.

*>> ����Ÿ üũ.
  LOOP AT IT_TAB.
     W_TABIX = SY-TABIX.

*> �����û����.
     IF P_CCFM = 'X'.
        IF NOT IT_TAB-ZFCCRDT IN S_CCRDT.
           DELETE IT_TAB INDEX W_TABIX.
           CONTINUE.
        ENDIF.
        IF ZTIMIMG00-ZFINOU NE 'X'.
           SELECT *  FROM  ZTBLINR_TMP UP TO 1 ROWS
           WHERE  ZFBLNO   EQ    IT_TAB-ZFBLNO.
              MOVE  ZTBLINR_TMP-ZFINRNO  TO  IT_TAB-ZFINRNO.
           ENDSELECT.
        ELSE.
           SELECT *  FROM  ZTBLINR UP TO 1 ROWS
           WHERE  ZFBLNO   EQ    IT_TAB-ZFBLNO.
              MOVE  ZTBLINR_TMP-ZFINRNO  TO  IT_TAB-ZFINRNO.
           ENDSELECT.
        ENDIF.
     ENDIF.

     SELECT SINGLE *
            FROM EKKO
           WHERE EBELN = IT_TAB-EBELN
             AND EKGRP IN  S_EKGRP
             AND EKORG IN  S_EKORG
             AND BEDAT IN  S_BEDAT.
     IF SY-SUBRC NE 0.
        DELETE IT_TAB INDEX W_TABIX.
        CONTINUE.
     ENDIF.

     IF NOT IT_TAB-ZFWERKS IS INITIAL AND NOT IT_TAB-MATNR IS INITIAL.
            SELECT * FROM MBEW UP TO 1 ROWS
                    WHERE MATNR EQ IT_TAB-MATNR
                    AND   BWKEY EQ IT_TAB-ZFWERKS.
            ENDSELECT.
            IF SY-SUBRC EQ 0.
               IT_TAB-LBKUM = MBEW-LBKUM.
            ELSE.
               IT_TAB-LBKUM = 0.
            ENDIF.
            CLEAR MARA.
            SELECT SINGLE *
                   FROM   MARA
                   WHERE  MATNR = IT_TAB-MATNR.
            IF SY-SUBRC EQ 0.
               MOVE MARA-MEINS TO IT_TAB-MEINS2.
            ENDIF.
     ELSE.
       IT_TAB-LBKUM = 0.
     ENDIF.
     MODIFY IT_TAB INDEX W_TABIX.
  ENDLOOP.
  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE EQ 0.
     W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_GET_IT_TAB
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  CLEAR   IT_SELECTED.
  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.
  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
       READ LINE SY-INDEX FIELD VALUE  W_ZFCCRDT.
       READ LINE SY-INDEX FIELD VALUE  W_INRNO.
       READ LINE SY-INDEX FIELD VALUE  W_CNAM.
       MOVE : IT_TAB-ZFBLNO   TO IT_SELECTED-ZFBLNO,
              W_ZFCCRDT(4)    TO IT_SELECTED-ZFCCRDT,
              W_ZFCCRDT+5(2)  TO IT_SELECTED-ZFCCRDT+4(2),
              W_ZFCCRDT+8(2)  TO IT_SELECTED-ZFCCRDT+6(2),
              W_INRNO         TO IT_SELECTED-ZFINRNO,
              W_CNAM          TO IT_SELECTED-ZFCCCNAM.
       APPEND IT_SELECTED.
       ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POPUP_MESSAGE  USING VALUE(P_TITLE)
                                VALUE(P_QUESTION)
                                VALUE(P_BUTTON1)
                                VALUE(P_BUTTON2)
                                VALUE(P_DEFAULT)
                          CHANGING    P_ANSWER.

   CLEAR : P_ANSWER.

   CALL  FUNCTION  'POPUP_TO_CONFIRM'
         EXPORTING
             TITLEBAR        = P_TITLE
             DIAGNOSE_OBJECT = ''
             TEXT_QUESTION   = P_QUESTION
             TEXT_BUTTON_1   = P_BUTTON1
             TEXT_BUTTON_2   = P_BUTTON2
             DEFAULT_BUTTON  = P_DEFAULT
             DISPLAY_CANCEL_BUTTON = 'X'
             START_COLUMN    = 30
             START_ROW       = 8
         IMPORTING
             ANSWER          =  P_ANSWER.

ENDFORM.                    " P2000_POPUP_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P3000_INPUT_DATA_SAVE
*&---------------------------------------------------------------------*
FORM P3000_INPUT_DATA_SAVE.

  REFRESH IT_BL.
  RANGES: R_ZFBLNO FOR ZTBL-ZFBLNO OCCURS 5.
*>> ���� üũ.
  LOOP AT IT_SELECTED.
       MOVE :    'I'                 TO  R_ZFBLNO-SIGN,
                 'EQ'                TO  R_ZFBLNO-OPTION,
                 IT_SELECTED-ZFBLNO  TO  R_ZFBLNO-LOW,
                 SPACE               TO  R_ZFBLNO-HIGH.
       APPEND  R_ZFBLNO.
  ENDLOOP.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_BL
              FROM ZTBL
             WHERE ZFBLNO IN R_ZFBLNO.

  CLEAR: W_UPDATE_CNT.
  LOOP AT IT_BL.
    W_TABIX = SY-TABIX.
    IF  W_SY_UCOMM EQ 'CCREQ'.
        READ TABLE IT_SELECTED WITH KEY ZFBLNO = IT_BL-ZFBLNO.
        IF SY-SUBRC EQ 0.
*-----------------------------------------------------------------------
* CHECK DATE
*-----------------------------------------------------------------------
           CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
                EXPORTING
                   DATE                      = IT_SELECTED-ZFCCRDT
                EXCEPTIONS
                   PLAUSIBILITY_CHECK_FAILED = 4.
           IF SY-SUBRC NE 0.
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*               MESSAGE ID SY-MSGID TYPE 'E' NUMBER SY-MSGNO
*                        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
*                        RAISING PLAUSIBILITY_CHECK_FAILED.
                MESSAGE E422(ZIM1) WITH IT_BL-ZFBLNO
                                        IT_SELECTED-ZFCCRDT.
                EXIT.
           ENDIF.
        ENDIF.
        MOVE:  'R'       TO IT_BL-ZFCCRST,             " �����û.
                SY-UNAME TO IT_BL-ZFCCNAM,             " �����û��.
                IT_SELECTED-ZFCCRDT TO IT_BL-ZFCCRDT,  " �����û����.
                SY-UNAME TO IT_BL-UNAM,                " ����������.
                SY-DATUM TO IT_BL-UDAT.                " ����������.

    ENDIF.
    IF W_SY_UCOMM EQ 'CCCNF'.
       MOVE:  'C'                  TO IT_BL-ZFCCRST,      " ���Ȯ��.
              IT_SELECTED-ZFCCCNAM TO IT_BL-ZFCCCNAM,     " ���Ȯ����.
              IT_SELECTED-ZFINRNO  TO IT_BL-ZFCCNO,       " �����ȣ.
              SY-DATUM             TO IT_BL-ZFCCCDT,      " ���Ȯ����.
              SY-UNAME             TO IT_BL-UNAM,         " ����������.
              SY-DATUM             TO IT_BL-UDAT.         " ����������.

    ENDIF.
    MODIFY IT_BL INDEX W_TABIX.
    ADD 1 TO  W_UPDATE_CNT.
  ENDLOOP.
  PERFORM   P2000_LOCK_EXEC  USING   'L'.
  MODIFY    ZTBL FROM TABLE  IT_BL.
  PERFORM   P2000_LOCK_EXEC  USING   'U'.

ENDFORM.                    " P3000_INPUT_DATA_SAVE
*&---------------------------------------------------------------------*
*&      Form  P2000_LOCK_EXEC
*&---------------------------------------------------------------------*
FORM P2000_LOCK_EXEC USING    VALUE(PA_LOCK).

DATA : L_TABIX  LIKE SY-TABIX,
       WL_SUBRC LIKE SY-SUBRC.

  LOOP AT IT_BL.
     L_TABIX = SY-TABIX.
     IF PA_LOCK EQ 'L'.
        CALL FUNCTION 'ENQUEUE_EZ_IM_ZTBLDOC'
           EXPORTING
               ZFBLNO        =     IT_BL-ZFBLNO
           EXCEPTIONS
               OTHERS        = 1.

       IF SY-SUBRC <> 0.
          MESSAGE I510 WITH SY-MSGV1 'B/L Document'
                       IT_BL-ZFBLNO ''
                       RAISING DOCUMENT_LOCKED.
          DELETE IT_BL INDEX L_TABIX.
          CONTINUE.
       ENDIF.

       IT_BL-LOCK = 'Y'.
       MODIFY IT_BL INDEX L_TABIX.
     ELSEIF PA_LOCK EQ 'U'.
       CALL FUNCTION 'ENQUEUE_EZ_IM_ZTBLDOC'
            EXPORTING
                     ZFBLNO    =    IT_BL-ZFBLNO.

     ENDIF.
  ENDLOOP.

 ENDFORM.
