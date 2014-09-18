*&---------------------------------------------------------------------*
*& Report  ZRIMCLIC                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ�(�������) �ڷ� ����                          *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.25                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : Invoice �ڷḦ ��ȸ�Ͽ� ���ԽŰ��ڷ�(�������)?
*&               �����Ѵ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMCLIC    MESSAGE-ID ZIM
                    LINE-SIZE 124
                    NO STANDARD PAGE HEADING.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK            TYPE   C,
*      ZFHBLNO         LIKE   ZTBL-ZFHBLNO,        " House B/L No
       ZFHBLNO(18)     TYPE   C,
       ZFBLNO          LIKE   ZTIV-ZFBLNO,         " B/L ������?
       EBELN           LIKE   ZTREQHD-EBELN,       " P/O No
       ZFETA           LIKE   ZTBL-ZFETA,          " ����?
*      ZFRGDSR         LIKE   ZTBL-ZFRGDSR,        " ��ǥǰ?
       ZFRGDSR(40)     TYPE   C,
       ZFMATGB         LIKE   ZTREQHD-ZFMATGB,     " ���籸?
       ZFCUST          LIKE   ZTIV-ZFCUST,         " �����?
       ZFWERKS         LIKE   ZTREQHD-ZFWERKS,     " Plant
       ZFINRNO         LIKE   ZTBLINR-ZFINRNO,     " �������ԽŰ��?
       ZFIVNO          LIKE   ZTIV-ZFIVNO,         " Invoice ������?
*      ZFOPNNO         LIKE   ZTREQHD-ZFOPNNO,     " L/C No
       ZFOPNNO(21)     TYPE   C,
       ZFREQNO         LIKE   ZTREQHD-ZFREQNO,     " �����Ƿ� ������?
       ZFINDT          LIKE   ZTBLINR-ZFINDT,      " ����?
       ZFMAVN          LIKE   ZTIV-LIFNR,          " Vendor
       ZFMAVN_NME(16)  TYPE   C,                   " Vendor ?
       ZFPOYN          LIKE   ZTIV-ZFPOYN,         " ��ȯ��?
       EKORG           LIKE   ZTBL-EKORG.          " ������?
DATA : END OF IT_TAB.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMCLICTOP.

INCLUDE   ZRIMSORTCOM.    " Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BNARCD FOR ZTBLINR-ZFBNARCD,  " ������?
                   S_HBLNO  FOR ZTBL-ZFHBLNO,      " House B/L No
                   S_MBLNO  FOR ZTBL-ZFMBLNO,      " Master B/L No
                   S_BLNO   FOR ZTIV-ZFBLNO,       " B/L ������?
                   S_EBELN  FOR ZTREQHD-EBELN,     " P/O No
                   S_OPNNO  FOR ZTREQHD-ZFOPNNO,   " L/C No
                   S_IVNO   FOR ZTIV-ZFIVNO,       " Invoice  ������?
                   S_ETA    FOR ZTBL-ZFETA,        " ������(ETA)
                   S_INDT   FOR ZTBLINR-ZFINDT,    " ����?
                   S_INRNO  FOR ZTBLINR-ZFINRNO,   " ���ԽŰ��?
                   S_MATGB  FOR ZTREQHD-ZFMATGB.   " ���籸?

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
* ��ȯ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(14) TEXT-003, POSITION 1.
     SELECTION-SCREEN : COMMENT 36(4) TEXT-031, POSITION 41.
     PARAMETERS : P_POY    AS CHECKBOX.              " ��?
     SELECTION-SCREEN : COMMENT 48(4) TEXT-032, POSITION 53.
     PARAMETERS : P_PON    AS CHECKBOX.              " ��?
  SELECTION-SCREEN END OF LINE.

* �����?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(19) TEXT-004, POSITION 1.
     SELECTION-SCREEN : COMMENT 32(8) TEXT-041, POSITION 41.
     PARAMETERS : P_CU1    AS CHECKBOX.              " ������?
     SELECTION-SCREEN : COMMENT 44(8) TEXT-042, POSITION 53.
     PARAMETERS : P_CU2    AS CHECKBOX.              " �Ƿڴ�?
     SELECTION-SCREEN : COMMENT 58(6) TEXT-043, POSITION 65.
     PARAMETERS : P_CU3    AS CHECKBOX.              " �Ƿ�?
     SELECTION-SCREEN : COMMENT 68(8) TEXT-044, POSITION 77.
     PARAMETERS : P_CUY    AS CHECKBOX.              " �����?
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE      USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
     WHEN 'STUP' OR 'STDN'.         " SORT ����?
           W_FIELD_NM = 'ZFREQDT'.
           ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
           PERFORM HANDLE_SORT TABLES  IT_TAB
                               USING   SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
            PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'CDRC'.                   " ���ԽŰ� �ڷ� ��?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
            PERFORM P4000_CREATE_CUCLIV      USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM P4000_CREATE_CUCL        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM P4000_CREATE_CUIDR       USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM RESET_LIST.
            MESSAGE S750 WITH W_SELECTED_LINES W_PROC_CNT .
      WHEN 'DISP'.                    " Invoice Application ��?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_IV USING IT_SELECTED-ZFIVNO.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
               IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
   WHEN 'DSRQ'.                    " L/C ��?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_LC USING IT_SELECTED-ZFIVNO.
               CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
      WHEN 'DSBL'.                    " B/L ��?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_BL USING IT_SELECTED-ZFIVNO.
               CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM RESET_LIST.
      WHEN 'BAC1' OR 'EXIT' OR 'CANC'.
            LEAVE TO SCREEN 0.                " ��?
      WHEN OTHERS.
   ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.

  P_POY = 'X'.
  P_PON = 'X'.
  P_CU1 = 'X'.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50  '[ ������� �ڷ� ���� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 100 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE NO-GAP,
            'House B/L No      '   NO-GAP, SY-VLINE NO-GAP,
            'B/L ������ȣ'         NO-GAP, SY-VLINE NO-GAP,
            'P/O No    '           NO-GAP, SY-VLINE NO-GAP,
            '������-ETA'           NO-GAP, SY-VLINE NO-GAP,
            '��ǥǰ��            ' NO-GAP,
            '                    ' NO-GAP, SY-VLINE NO-GAP,
            '���籸��'             NO-GAP, SY-VLINE NO-GAP,
            '�������'             NO-GAP, SY-VLINE NO-GAP,
            'Plant'                NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
            '�������Թ�ȣ      '            NO-GAP, SY-VLINE NO-GAP,
            'I/V ������ȣ'                  NO-GAP, SY-VLINE NO-GAP,
            '�����Ƿ�  '                    NO-GAP, SY-VLINE NO-GAP,
            '������    '                    NO-GAP, SY-VLINE NO-GAP,
            'L/C No               '         NO-GAP, SY-VLINE NO-GAP,
            'Vendor                     '   NO-GAP, SY-VLINE NO-GAP,
            '��ȯ����'                      NO-GAP, SY-VLINE NO-GAP,
            'POrg '                         NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIM60'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIM60'.           " GUI TITLE SETTING..

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
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE NO-GAP,
       IT_TAB-ZFHBLNO  NO-GAP,        " House B/L No
       SY-VLINE NO-GAP,
       IT_TAB-ZFBLNO   NO-GAP,        " B/L ������?
       '  '            NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-EBELN  NO-GAP,          " P/O No.
       SY-VLINE NO-GAP,
       IT_TAB-ZFETA    NO-GAP,        " ����?
       SY-VLINE NO-GAP,
       IT_TAB-ZFRGDSR  NO-GAP,        " ��ǥǰ?
       SY-VLINE NO-GAP,
       IT_TAB-ZFMATGB  NO-GAP,        " ���籸?
       '       '       NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFCUST   NO-GAP,        " �����?
       '       '       NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFWERKS  NO-GAP,        " Plant
       ' '             NO-GAP,
       SY-VLINE NO-GAP.
* Hide
       MOVE SY-TABIX  TO W_LIST_INDEX.
       HIDE: W_LIST_INDEX, IT_TAB.
       MODIFY IT_TAB INDEX SY-TABIX.

       FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
       WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
       IT_TAB-ZFINRNO  NO-GAP,        " �������� �Ű��?
       SY-VLINE NO-GAP,
       IT_TAB-ZFIVNO   NO-GAP,        " Invoice ������?
       '  '            NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFREQNO  NO-GAP,        " �����Ƿ� ������?
       SY-VLINE NO-GAP,
       IT_TAB-ZFINDT   NO-GAP,        " ����?
       SY-VLINE NO-GAP,
       IT_TAB-ZFOPNNO  NO-GAP,        " L/C No
       SY-VLINE NO-GAP,
       IT_TAB-ZFMAVN   NO-GAP,        " Vendor
       ' '             NO-GAP,
       IT_TAB-ZFMAVN_NME NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFPOYN   NO-GAP,        " ��ȯ ��?
       '       '       NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-EKORG    NO-GAP,        " ������?
       ' '             NO-GAP,
       SY-VLINE NO-GAP.

* Stored value...
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.
  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE

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
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH IT_TAB.
  IF P_POY = ' ' AND P_PON = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_CU1 = ' ' AND P_CU2 = ' ' AND P_CU3 = ' ' AND P_CUY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.

  SELECT *
    FROM ZTIV
   WHERE ZFIVNO    IN S_IVNO
     AND ZFBLNO    IN S_BLNO.
*     AND ZFPRPYN = 'N'.
         CLEAR     IT_TAB.
         MOVE ZTIV-ZFBLNO    TO IT_TAB-ZFBLNO.
         MOVE ZTIV-ZFCUST    TO IT_TAB-ZFCUST.
         MOVE ZTIV-ZFIVNO    TO IT_TAB-ZFIVNO.
*         MOVE ZTIV-ZFREQNO   TO IT_TAB-ZFREQNO.
*         MOVE ZTIV-ZFMAVN    TO IT_TAB-ZFMAVN.
         MOVE ZTIV-ZFPOYN    TO IT_TAB-ZFPOYN.
         CASE IT_TAB-ZFPOYN.                       " ���ѿ�?
              WHEN 'Y'.                            " ��?
                   IF P_POY = ' '.
                      CONTINUE.
                   ENDIF.
             WHEN 'N'.                           " ��?
                   IF P_PON = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

         CASE IT_TAB-ZFCUST.                       " �����?
              WHEN '1'.                            " ������?
                   IF P_CU1 = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN '2'.                            " �Ƿڴ�?
                   IF P_CU2 = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN '3'.                            " �Ƿ�?
                   IF P_CU3 = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'Y'.                            " �����?
                   IF P_CUY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

         CLEAR ZTBL.
         SELECT SINGLE *
           FROM ZTBL
          WHERE ZFBLNO = IT_TAB-ZFBLNO
            AND ZFHBLNO IN S_HBLNO
            AND ZFMBLNO IN S_MBLNO
            AND ZFETA   IN S_ETA.
         IF SY-SUBRC NE 0.
            CONTINUE.
         ENDIF.
         CLEAR ZTBLINR.
         SELECT MAX( ZFBTSEQ ) INTO W_ZFBTSEQ
           FROM ZTBLINR
          WHERE ZFBLNO = ZTBL-ZFBLNO
            AND ZFBNARCD IN S_BNARCD
            AND ZFINRNO IN S_INRNO
            AND ZFINDT  IN S_INDT
            AND ZFDOCST = 'O'.
         SELECT SINGLE *
           FROM ZTBLINR
          WHERE ZFBLNO = ZTBL-ZFBLNO
            AND ZFBTSEQ = W_ZFBTSEQ.
         IF SY-SUBRC NE 0.
            CONTINUE.
         ENDIF.
         MOVE ZTBLINR-ZFINRNO TO IT_TAB-ZFINRNO.
         MOVE ZTBLINR-ZFINDT  TO IT_TAB-ZFINDT.
         MOVE ZTBL-ZFHBLNO    TO IT_TAB-ZFHBLNO.
         MOVE ZTBL-ZFETA      TO IT_TAB-ZFETA.
         MOVE ZTBL-ZFRGDSR    TO IT_TAB-ZFRGDSR.
         MOVE ZTBL-EKORG      TO IT_TAB-EKORG.
         IF IT_TAB-ZFPOYN EQ 'Y'.
            SELECT SINGLE *
              FROM ZTREQHD
             WHERE ZFREQNO = IT_TAB-ZFREQNO
               AND EBELN  IN S_EBELN
               AND ZFMATGB IN S_MATGB
               AND ZFOPNNO IN S_OPNNO.
            IF SY-SUBRC NE 0.
               CONTINUE.
            ENDIF.
            MOVE ZTREQHD-EBELN   TO IT_TAB-EBELN.
            MOVE ZTREQHD-ZFMATGB TO IT_TAB-ZFMATGB.
            MOVE ZTREQHD-ZFWERKS TO IT_TAB-ZFWERKS.
            MOVE ZTREQHD-ZFOPNNO TO IT_TAB-ZFOPNNO.
         ENDIF.
         SELECT SINGLE NAME1 INTO IT_TAB-ZFMAVN_NME
           FROM LFA1
          WHERE LIFNR = IT_TAB-ZFMAVN.

         APPEND  IT_TAB.

  ENDSELECT.

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
     MESSAGE S738.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: INDEX   TYPE P,
        ZFIVNO  LIKE ZTIV-ZFIVNO,
        ZFBLNO  LIKE ZTIV-ZFBLNO,
        ZFCUST  LIKE ZTIV-ZFCUST.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFIVNO   TO ZFIVNO,
         IT_TAB-ZFBLNO   TO ZFBLNO,
         IT_TAB-ZFCUST   TO ZFCUST.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : W_LIST_INDEX    TO INDEX,
                IT_TAB-ZFIVNO   TO IT_SELECTED-ZFIVNO,
                IT_TAB-ZFBLNO   TO IT_SELECTED-ZFBLNO,
                IT_TAB-ZFCUST   TO IT_SELECTED-ZFCUST.
       SELECT COUNT( DISTINCT ZFIVAMC ) INTO W_COUNT
         FROM ZTIV
        WHERE ZFBLNO = IT_SELECTED-ZFBLNO
          AND ZFCUST = '1'.
       IF W_COUNT > 1.      " ������ B/L ���� I/V���� ��ȭ�� �ٸ�?
          MOVE 'X'              TO IT_SELECTED-ZFCUST.
       ENDIF.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IV
*&---------------------------------------------------------------------*
FORM P2000_SHOW_IV USING  P_ZFIVNO.

   SET PARAMETER ID 'ZPIVNO'  FIELD P_ZFIVNO.
   EXPORT 'ZPIVNO'        TO MEMORY ID 'ZPIVNO'.

   CALL TRANSACTION 'ZIM33' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_IV
*&---------------------------------------------------------------------*
*&      Form  P2000_CREATE_CUCL
*&---------------------------------------------------------------------*
FORM P4000_CREATE_CUCL USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH IT_CUCL.
  CLEAR   IT_CUCL.
  LOOP AT IT_SELECTED.
       IF IT_SELECTED-ZFCUST NE '1'.
          CONTINUE.
       ENDIF.

       CLEAR : ZTCUCLIV, ZTCUCL.
       SELECT SINGLE *
         FROM ZTCUCLIV
        WHERE ZFIVNO = IT_SELECTED-ZFIVNO.
       IF SY-SUBRC NE 0.
          CONTINUE.
       ENDIF.

       MOVE SY-UNAME TO ZTCUCLIV-UNAM.
       MOVE SY-DATUM TO ZTCUCLIV-UDAT.
       MOVE '2'      TO ZTCUCLIV-ZFCUST.
       UPDATE ZTCUCLIV.
       IF SY-SUBRC NE 0.
          MESSAGE E739 WITH ZTCUCLIV-ZFIVNO.
          MOVE 'Y' TO W_ERR_CHK.
          EXIT.
       ENDIF.

       SELECT SINGLE *
         FROM ZTCUCL
        WHERE ZFBLNO = ZTCUCLIV-ZFBLNO
          AND ZFCLSEQ = ZTCUCLIV-ZFCLSEQ.
       IF SY-SUBRC = 0.
                 " �Ű�ݾ׵� add..
       ELSE.
          MOVE ZTCUCLIV-ZFBLNO  TO ZTCUCL-ZFBLNO.
          MOVE ZTCUCLIV-ZFCLSEQ TO ZTCUCL-ZFCLSEQ.
          MOVE 'USD'            TO ZTCUCL-ZFUSD.
          MOVE 'KRW'            TO ZTCUCL-ZFKRW.
          MOVE ZTCUCLIV-ZFCLCD TO ZTCUCL-ZFCLCD.   " ������� = ������?
          MOVE '2'              TO ZTCUCL-ZFCUST.  " ������� = �Ƿڴ�?
          MOVE SY-UNAME         TO ZTCUCL-ERNAM.
          MOVE SY-DATUM         TO ZTCUCL-CDAT.
          MOVE SY-UNAME         TO ZTCUCL-UNAM.
          MOVE SY-DATUM         TO ZTCUCL-UDAT.
          INSERT ZTCUCL.
          IF SY-SUBRC NE 0.
             MESSAGE E739 WITH ZTCUCLIV-ZFIVNO.
             MOVE 'Y' TO W_ERR_CHK.
             EXIT.
          ENDIF.
          MOVE ZTCUCLIV-ZFBLNO  TO IT_CUCL-ZFBLNO.
          MOVE ZTCUCLIV-ZFCLSEQ TO IT_CUCL-ZFCLSEQ.
          APPEND IT_CUCL.
       ENDIF.

  ENDLOOP.

ENDFORM.                    " P4000_CREATE_CUCL
*&---------------------------------------------------------------------*
*&      Form  P2000_CREATE_CUCLIV
*&---------------------------------------------------------------------*
FORM P4000_CREATE_CUCLIV USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.
  CLEAR W_PROC_CNT.
* ���ȯ�� �� Invoice ��ȭ�ݾ� ���. -> ����Ϸ�ÿ� ��?
  LOOP AT IT_SELECTED.
       IF IT_SELECTED-ZFCUST NE '1'.
          CONTINUE.
       ENDIF.
       ADD 1 TO W_PROC_CNT.
       SELECT SINGLE *
         FROM ZTIV
        WHERE ZFIVNO = IT_SELECTED-ZFIVNO.
       IF SY-SUBRC NE 0.
          CONTINUE.
       ENDIF.
       MOVE SY-UNAME TO ZTIV-UNAM.
       MOVE SY-DATUM TO ZTIV-UDAT.
       MOVE '2'      TO ZTIV-ZFCUST.
       UPDATE ZTIV.
       IF SY-SUBRC NE 0.
          MESSAGE E739 WITH ZTIV-ZFIVNO.
          MOVE 'Y' TO W_ERR_CHK.
          EXIT.
       ENDIF.
*
  ENDLOOP.

  REFRESH IT_SELECTED_TMP.
  LOOP AT IT_SELECTED.                                  "���������?
       IF IT_SELECTED-ZFCUST NE '1'.
          CONTINUE.
       ENDIF.
       SELECT SINGLE * FROM ZTIV
              WHERE ZFIVNO = IT_SELECTED-ZFIVNO.
       IF SY-SUBRC NE 0.
          CONTINUE.
       ENDIF.

       SELECT MAX( ZFCLSEQ ) INTO IT_SELECTED-ZFCLSEQ
              FROM ZTCUCLIV
       WHERE ZFBLNO = ZTIV-ZFBLNO.

       ADD  1               TO IT_SELECTED-ZFCLSEQ.
       CLEAR   IT_SELECTED_TMP.
       MOVE-CORRESPONDING IT_SELECTED TO IT_SELECTED_TMP.
       APPEND IT_SELECTED_TMP.
  ENDLOOP.
  REFRESH IT_SELECTED.
  LOOP AT IT_SELECTED_TMP.
       CLEAR   IT_SELECTED.
       MOVE-CORRESPONDING IT_SELECTED_TMP TO IT_SELECTED.
       APPEND IT_SELECTED.
  ENDLOOP.

  LOOP AT IT_SELECTED.
       IF IT_SELECTED-ZFCUST NE '1'.
          CONTINUE.
       ENDIF.
       CLEAR : ZTIV, ZTCUCLIV.
       SELECT SINGLE *
         FROM ZTIV
        WHERE ZFIVNO = IT_SELECTED-ZFIVNO.
       IF SY-SUBRC NE 0.
          CONTINUE.
       ENDIF.

       MOVE-CORRESPONDING ZTIV    TO ZTCUCLIV.
       MOVE IT_SELECTED-ZFCLSEQ   TO ZTCUCLIV-ZFCLSEQ.
       MOVE 'A'                   TO ZTCUCLIV-ZFCLCD.
       MOVE '1'                   TO ZTCUCLIV-ZFCUST.
       MOVE SY-UNAME              TO ZTCUCLIV-UNAM.
       MOVE SY-DATUM              TO ZTCUCLIV-UDAT.
       MOVE SY-UNAME              TO ZTCUCLIV-ERNAM.
       MOVE SY-DATUM              TO ZTCUCLIV-CDAT.
       INSERT ZTCUCLIV.
       IF SY-SUBRC NE 0.
          MESSAGE E739 WITH ZTIV-ZFIVNO.
          MOVE 'Y' TO W_ERR_CHK.
          EXIT.
       ENDIF.

       SELECT *
         FROM ZTIVIT
        WHERE ZFIVNO = ZTIV-ZFIVNO.
              MOVE-CORRESPONDING ZTIVIT TO ZTCUCLIVIT.
              INSERT ZTCUCLIVIT.
              IF SY-SUBRC NE 0.
                 MESSAGE E739 WITH ZTIV-ZFIVNO.
                 MOVE 'Y' TO W_ERR_CHK.
                 EXIT.
              ENDIF.
       ENDSELECT.

  ENDLOOP.

ENDFORM.                    " P4000_CREATE_CUCLIV
*&---------------------------------------------------------------------*
*&      Form  P4000_CREATE_CUIDR
*&---------------------------------------------------------------------*
FORM P4000_CREATE_CUIDR USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.
  CLEAR W_CRET_CNT.
  SELECT SINGLE *
    FROM ZTIMIMG00.
*
  LOOP AT IT_CUCL.                              " ���ԽŰ� �ڷ� ��?
       CLEAR ZTIDR.
       MOVE IT_CUCL-ZFBLNO      TO ZTIDR-ZFBLNO.         " B/L ������?
       MOVE IT_CUCL-ZFCLSEQ     TO ZTIDR-ZFCLSEQ.        " �����?
       MOVE 'KRW'               TO ZTIDR-ZFINAMTC.       " �������?
       MOVE 'ETC'               TO ZTIDR-ZFTRCN.         " ��ۿ�?
*       MOVE ZTIMIMG00-ZFTDNO    TO ZTIDR-ZFTDNO.         " ������ ���?
*       MOVE ZTIMIMG00-ZFTDNM1   TO ZTIDR-ZFTDNM1.        " ������ ��?
*       MOVE ZTIMIMG00-ZFTDNM2   TO ZTIDR-ZFTDNM2.        " ������ ��?
*       MOVE ZTIMIMG00-ZFTDAD1   TO ZTIDR-ZFTDAD1.        " ������ �ּ�1
*       MOVE ZTIMIMG00-ZFTDAD2   TO ZTIDR-ZFTDAD2.        " ������ �ּ�2
*       MOVE ZTIMIMG00-ZFTDTC    TO ZTIDR-ZFTDTC.         " ������ ���?
       MOVE 'KRW'               TO ZTIDR-ZFKRW.          " ��ȭ��?
       MOVE 'USD'               TO ZTIDR-ZFUSD.          " ��ȭ��?
       MOVE 'N'                 TO ZTIDR-ZFDNCD.         " Download ��?
       MOVE SY-UNAME            TO ZTIDR-ERNAM.
       MOVE SY-DATUM            TO ZTIDR-CDAT.
       MOVE SY-UNAME            TO ZTIDR-UNAM.
       MOVE SY-DATUM            TO ZTIDR-UDAT.
*
       CLEAR ZTBL.
       SELECT SINGLE *
         FROM ZTBL
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
       MOVE ZTBL-ZFPONC         TO ZTIDR-ZFPONC.          "���԰ŷ���?
       MOVE ZTBL-ZFAPRTC        TO ZTIDR-ZFAPRTC.         "����?
       MOVE ZTBL-ZFCARC         TO ZTIDR-ZFSCON.          "����?
       MOVE ZTBL-ZFETA          TO ZTIDR-ZFENDT.          "����?
       IF ZTBL-ZFPOYN = 'Y'.
          MOVE 'B'              TO ZTIDR-ZFIMCD.          "�����ڱ�?
*          MOVE ZTIMIMG00-ZFAPNO1 TO ZTIDR-ZFAPNO.   "������ ���������?
*          MOVE ZTIMIMG00-ZFIAPNM1 TO ZTIDR-ZFIAPNM.  "������ ��?
       ENDIF.
       IF ZTBL-ZFPOYN = 'N'.
          MOVE 'A'              TO ZTIDR-ZFIMCD.
*          MOVE ZTIMIMG00-ZFAPNO2 TO ZTIDR-ZFAPNO.   "������ ���������?
*          MOVE ZTIMIMG00-ZFIAPNM2 TO ZTIDR-ZFIAPNM.  "������ ��?
       ENDIF.
       MOVE ZTBL-ZFHBLNO        TO ZTIDR-ZFHBLNO.         "House B/L No
       IF ZTBL-ZFVIA = 'AIR'.
          MOVE '40'             TO ZTIDR-ZFTRMET.         "��ۼ�?
       ENDIF.
       IF ZTBL-ZFVIA = 'VSL'.
          MOVE '10'             TO ZTIDR-ZFTRMET.
       ENDIF.
       MOVE ZTBL-ZFCARNM        TO ZTIDR-ZFCARNM.         "����?
*
       CLEAR ZTBLINR.
       SELECT MAX( ZFBTSEQ ) INTO ZTBLINR-ZFBTSEQ
         FROM ZTBLINR
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFDOCST = 'O'.
       SELECT SINGLE *
         FROM ZTBLINR
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFBTSEQ = ZTBLINR-ZFBTSEQ.
       IF SY-SUBRC EQ 0.
          MOVE ZTBLINR-ZFINRC      TO ZTIDR-ZFINRC.     "�Ű�����?
*          MOVE ZTBLINR-ZFINRCD     TO ZTIDR-ZFINRCD.    "�Ű���������?
          PERFORM P2000_CHUNGJOO_GOOMI_PROCESS.  " û��/���� Process
          MOVE '10'                TO ZTIDR-ZFINRCD.    "�Ű���������?
          MOVE ZTBLINR-ZFGIRDT     TO ZTIDR-ZFINDT.     "����?
          IF ZTBLINR-ZFTXYN = 'X'.
             MOVE '00'              TO ZTIDR-ZFCOCD.    "����¡����?
          ELSE.
             MOVE '13'              TO ZTIDR-ZFCOCD.
          ENDIF.
          CONCATENATE ZTBLINR-ZFABNAR+0(8) ZTBLINR-ZFYR ZTBLINR-ZFSEQ
                 INTO ZTIDR-ZFISPL. "�˻���ġ���?
*          MOVE ZTBLINR-ZFABNAR     TO ZTIDR-ZFISPL.     "�˻���ġ���?
          MOVE ZTBLINR-ZFINRNO     TO ZTIDR-ZFINRNO.    "���ԽŰ��?
          MOVE ZTBLINR-ZFBNARCD    TO ZTIDR-ZFBNARCD.  "��������������?
       ENDIF.
*
       CLEAR ZTBLINOU.
       SELECT MAX( ZFBTSEQ ) INTO ZTBLINOU-ZFBTSEQ
         FROM ZTBLINOU
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
       SELECT SINGLE *
         FROM ZTBLINOU
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFBTSEQ = ZTBLINOU-ZFBTSEQ.
       IF SY-SUBRC EQ 0.
          MOVE ZTBLINOU-ZFGMNO    TO ZTIDR-ZFGOMNO.       "ȭ��������?
*         MOVE ZTBLINOU-ZFPKCN    TO ZTIDR-ZFPKCNT.       "�����尹?
          MOVE ZTBLINOU-ZFPKCNM   TO ZTIDR-ZFPKNM.        "������?
*         MOVE ZTBLINOU-ZFWEIG    TO ZTIDR-ZFTOWT.        "����?
          MOVE ZTBLINOU-ZFWEINM   TO ZTIDR-ZFTOWTM.       "���߷���?
          MOVE ZTBLINOU-ZFBTRNO   TO ZTIDR-ZFBTRNO.       "����Ű��?
       ENDIF.
       SELECT MAX( WAERS ) INTO ZTIDR-ZFTFAC               " ���� A ��?
         FROM ZTBLCST
        WHERE ZFBLNO = ZTIDR-ZFBLNO
          AND WAERS NE 'KRW'
          AND ZFCSCD IN ('ABC', 'ACF').
*          AND ZFCSCD IN ( SELECT ZFCD
*                            FROM ZTIMIMG08
*                           WHERE ZFCDTY = '004').
       SELECT SUM( ZFCAMT ) INTO ZTIDR-ZFTFA               " ���� A ��?
         FROM ZTBLCST
        WHERE ZFBLNO = ZTIDR-ZFBLNO
          AND WAERS = ZTIDR-ZFTFAC
          AND ZFCSCD IN ('ABC', 'ACF').
*          AND ZFCSCD IN ( SELECT ZFCD
*                            FROM ZTIMIMG08
*                           WHERE ZFCDTY = '004').
       SELECT MAX( WAERS ) INTO ZTIDR-ZFTFBC               " ���� B ��?
         FROM ZTBLCST
        WHERE ZFBLNO = ZTIDR-ZFBLNO
          AND WAERS NE ZTIDR-ZFTFAC
          AND WAERS NE 'KRW'
          AND ZFCSCD IN ('ABC', 'ACF').
*          AND ZFCSCD IN ( SELECT ZFCD
*                            FROM ZTIMIMG08
*                           WHERE ZFCDTY = '004').
       SELECT SUM( ZFCAMT ) INTO ZTIDR-ZFTFB               " ���� B ��?
         FROM ZTBLCST
        WHERE ZFBLNO = ZTIDR-ZFBLNO
          AND WAERS = ZTIDR-ZFTFBC
          AND ZFCSCD IN ('ABC', 'ACF').
*          AND ZFCSCD IN ( SELECT ZFCD
*                            FROM ZTIMIMG08
*                           WHERE ZFCDTY = '004').

       INSERT ZTIDR.
       IF SY-SUBRC NE 0.
          MESSAGE E749 WITH ZTIDR-ZFBLNO.
          MOVE 'Y' TO W_ERR_CHK.
          EXIT.
       ENDIF.
       ADD 1       TO W_CRET_CNT.
*
       REFRESH IT_IDRIT.
       SELECT *
         FROM ZTCUCLIV
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
              SELECT *
                FROM ZTCUCLIVIT
               WHERE ZFIVNO = ZTCUCLIV-ZFIVNO.
                     CLEAR IT_IDRIT.
                     IF ZTCUCLIV-ZFCLCD = 'A'.
                        SELECT SINGLE *
                          FROM ZTIV
                         WHERE ZFIVNO = ZTCUCLIV-ZFIVNO.
*                        MOVE ZTIV-ZFREQNO TO IT_IDRIT-ZFREQNO.
                     ENDIF.
                     MOVE-CORRESPONDING ZTCUCLIVIT  TO IT_IDRIT.
                     APPEND IT_IDRIT.
              ENDSELECT.
       ENDSELECT.
*
       LOOP AT IT_IDRIT.
            CLEAR ZTIDRHS.
            SELECT SINGLE *
              FROM ZTIDRHS
             WHERE ZFBLNO = IT_CUCL-ZFBLNO
               AND ZFCLSEQ = IT_CUCL-ZFCLSEQ
               AND STAWN = IT_IDRIT-STAWN.

            IF SY-SUBRC NE 0.
               SELECT MAX( ZFCONO ) INTO ZTIDRHS-ZFCONO
                 FROM ZTIDRHS
                WHERE ZFBLNO = IT_CUCL-ZFBLNO
                  AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
               MOVE IT_CUCL-ZFBLNO      TO ZTIDRHS-ZFBLNO.
               MOVE IT_CUCL-ZFCLSEQ     TO ZTIDRHS-ZFCLSEQ.
               ADD  1                   TO ZTIDRHS-ZFCONO.    "?
               MOVE IT_IDRIT-STAWN      TO ZTIDRHS-STAWN.     "HS Code
               SELECT MAX( TEXT1 ) INTO ZTIDRHS-ZFTGDNM       "�ŷ�ǰ?
                 FROM T604T
                WHERE SPRAS = SY-LANGU
                  AND STAWN = IT_IDRIT-STAWN.
               SELECT SINGLE *
                 FROM ZTIV
                WHERE ZFIVNO = IT_IDRIT-ZFIVNO.
               IF SY-SUBRC EQ 0.
                  SELECT SINGLE NAME1 INTO ZTIDRHS-ZFGCNM     "��ǥǰ?
                    FROM LFA1
                   WHERE LIFNR = ZTIV-LIFNR.
               ENDIF.
               MOVE 'KRW'               TO ZTIDRHS-ZFKRW.
               MOVE 'USD'               TO ZTIDRHS-ZFUSD.
               MOVE ZTBLINOU-ZFWEINM    TO ZTIDRHS-ZFWETM.    "�߷���?

               INSERT ZTIDRHS.
               IF SY-SUBRC NE 0.
                  MESSAGE E749 WITH IT_CUCL-ZFBLNO.
                  MOVE 'Y' TO W_ERR_CHK.
                  EXIT.
               ENDIF.
            ENDIF.

            CLEAR ZTIDRHSD.
            SELECT MAX( ZFRONO ) INTO ZTIDRHSD-ZFRONO
              FROM ZTIDRHSD
             WHERE ZFBLNO = ZTIDRHS-ZFBLNO
               AND ZFCLSEQ = ZTIDRHS-ZFCLSEQ
               AND ZFCONO = ZTIDRHS-ZFCONO.
            MOVE ZTIDRHS-ZFBLNO      TO ZTIDRHSD-ZFBLNO.
            MOVE ZTIDRHS-ZFCLSEQ     TO ZTIDRHSD-ZFCLSEQ.
            MOVE ZTIDRHS-ZFCONO      TO ZTIDRHSD-ZFCONO.      "?
            ADD  1                   TO ZTIDRHSD-ZFRONO.      "?
            MOVE IT_IDRIT-ZFIVNO     TO ZTIDRHSD-ZFIVNO.     "������?
            MOVE IT_IDRIT-ZFIVDNO    TO ZTIDRHSD-ZFIVDNO.    "�Ϸù�?
            MOVE IT_IDRIT-MATNR      TO ZTIDRHSD-ZFSTCD.     "�԰���?
            MOVE IT_IDRIT-TXZ01      TO ZTIDRHSD-ZFGDDS1.     "�԰�1
            MOVE IT_IDRIT-MENGE      TO ZTIDRHSD-ZFQNT.       "��?
            MOVE IT_IDRIT-MEINS      TO ZTIDRHSD-ZFQNTM.      "������?
            MOVE IT_IDRIT-NETPR      TO ZTIDRHSD-NETPR.       "��?
            MOVE IT_IDRIT-PEINH      TO ZTIDRHSD-PEINH.       "Price uni
            MOVE IT_IDRIT-BPRME      TO ZTIDRHSD-BPRME.       "Order pri
*            IF ZTIDRHSD-PEINH > 0.
*               ZTIDRHSD-ZFAMT = ZTIDRHSD-NETPR * ZTIDRHSD-ZFQNT
*                                               / ZTIDRHSD-PEINH. "��?
*            ELSE.
*               ZTIDRHSD-ZFAMT = 0.
*            ENDIF.
            MOVE IT_IDRIT-ZFIVAMT    TO ZTIDRHSD-ZFAMT.       "��?
            MOVE IT_IDRIT-ZFIVAMC    TO ZTIDRHSD-ZFCUR.       "��?
            MOVE IT_IDRIT-STAWN      TO ZTIDRHSD-STAWN.       "HS Code
            IF NOT ( IT_IDRIT-ZFREQNO IS INITIAL ).       " �����Ƿڼ�?
               SELECT SINGLE MENGE INTO ZTIDRHSD-ZFMENGE
                 FROM ZTREQIT
                WHERE ZFREQNO = IT_IDRIT-ZFREQNO
                  AND ZFITMNO = IT_IDRIT-ZFIVDNO.
            ENDIF.
            INSERT ZTIDRHSD.
            IF SY-SUBRC NE 0.
               MESSAGE E749 WITH IT_CUCL-ZFBLNO.
               MOVE 'Y' TO W_ERR_CHK.
               EXIT.
            ENDIF.
       ENDLOOP.                      " IT_IDRIT

  ENDLOOP.                           " IT_CUCL

  LOOP AT IT_CUCL.

       SELECT SINGLE *
         FROM ZTIDR
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.

       CLEAR W_MENGE.
       SELECT *
         FROM ZTIV
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
              SELECT *
                FROM ZTIVIT
               WHERE ZFIVNO = ZTIV-ZFIVNO.
*                     ADD ZTIVIT-MENGE  TO W_MENGE.
              ENDSELECT.
       ENDSELECT.
       CLEAR ZTBLINOU.
       SELECT MAX( ZFBTSEQ ) INTO ZTBLINOU-ZFBTSEQ
         FROM ZTBLINOU
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
       SELECT SINGLE *
         FROM ZTBLINOU
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFBTSEQ = ZTBLINOU-ZFBTSEQ.
*
       CLEAR ZTIDRHS.
       SELECT *
         FROM ZTIDRHS
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
              SELECT SUM( ZFQNT ) MAX( ZFQNTM )            " ������ ��?
                INTO (ZTIDRHS-ZFQNT, ZTIDRHS-ZFQNTM)
                FROM ZTIDRHSD
               WHERE ZFBLNO  = ZTIDRHS-ZFBLNO
                 AND ZFCLSEQ = ZTIDRHS-ZFCLSEQ
                 AND ZFCONO  = ZTIDRHS-ZFCONO.
              IF ( ZTIDRHS-ZFQNTM NE 'L'  ) AND
                 ( ZTIDRHS-ZFQNTM NE 'KG' ) AND
                 ( ZTIDRHS-ZFQNTM NE 'G'  ).
                 MOVE 'U'    TO ZTIDRHS-ZFQNTM.
              ENDIF.
              IF W_MENGE > 0.                              " ������ ��?
                 ZTIDRHS-ZFWET =
                         ZTBLINOU-ZFWEIG * ZTIDRHS-ZFQNT / W_MENGE.
              ELSE.
                 ZTIDRHS-ZFWET = 0.
              ENDIF.
              UPDATE ZTIDRHS.
              IF SY-SUBRC NE 0.
                 MESSAGE E749 WITH IT_CUCL-ZFBLNO.
                 MOVE 'Y' TO W_ERR_CHK.
                 EXIT.
              ENDIF.
       ENDSELECT.
*

       SELECT SUM( ZFWET )  SUM( ZFQNT )         "������� ����?
         INTO (ZTIDR-ZFTOWT, W_ZFQNT)
         FROM ZTIDRHS
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.

       ZTIDR-ZFPKCNT = ZTBLINOU-ZFPKCN * W_ZFQNT / W_MENGE. "�����?

       SELECT SUM( ZFAMT ) MAX( ZFCUR )  "������� �����ݾ�/��?
         INTO (ZTIDR-ZFSTAMT, ZTIDR-ZFSTAMC)
         FROM ZTIDRHSD
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
       MOVE ZTIDR-ZFSTAMC TO ZTIDR-ZFADAMCU. " ����ݾ� ��?
       MOVE ZTIDR-ZFSTAMC TO ZTIDR-ZFDUAMCU. " �����ݾ� ��?
       CLEAR W_ZFIVAMT.
       SELECT SUM( ZFIVAMT ) INTO W_ZFIVAMT
         FROM ZTCUCLIV
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
       IF W_ZFIVAMT > 0.
          ZTIDR-ZFTFA = ZTIDR-ZFTFA * ZTIDR-ZFSTAMT / W_ZFIVAMT. " ����A
          ZTIDR-ZFTFB = ZTIDR-ZFTFB * ZTIDR-ZFSTAMT / W_ZFIVAMT. " ����B
       ENDIF.

       REFRESH IT_REQHD.
       SELECT SINGLE *
         FROM ZTCUCL
        WHERE ZFBLNO = IT_CUCL-ZFBLNO
          AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
       IF ZTCUCL-ZFCLCD = 'A'.
          SELECT *
            FROM ZTCUCLIV
           WHERE ZFBLNO = IT_CUCL-ZFBLNO
             AND ZFCLSEQ = IT_CUCL-ZFCLSEQ.
                 CLEAR ZTIV.
                 SELECT SINGLE *
                   FROM ZTIV
                  WHERE ZFIVNO = ZTCUCLIV-ZFIVNO.
                 ADD ZTIV-ZFPKCHG       TO ZTIDR-ZFADAM. " �����?
                 ADD ZTIV-ZFHDCHG       TO ZTIDR-ZFADAM.
                 CLEAR W_ZFDUAM.
                 SELECT SUM( KWERT )  " ������?
                   INTO W_ZFDUAM
                   FROM ZTIVIT
                  WHERE ZFIVNO = ZTCUCLIV-ZFIVNO.
                 ADD W_ZFDUAM TO ZTIDR-ZFDUAM.
                 IF ZTIV-ZFPOYN = 'Y'.
*                   READ TABLE IT_REQHD WITH KEY ZFREQNO = ZTIV-ZFREQNO.
                    IF SY-SUBRC NE 0.
*                      MOVE ZTIV-ZFREQNO    TO IT_REQHD-ZFREQNO.
                       APPEND IT_REQHD.
                    ENDIF.
                 ENDIF.
          ENDSELECT.

          CLEAR : W_ZFINAMT, W_ZFLASTAM, W_LOOP_CNT.
          MOVE 'GN'      TO ZTIDR-ZFAMCD.         "��ݰ�����?
          LOOP AT IT_REQHD.
               CLEAR ZTREQIL.
               SELECT *
                 FROM ZTREQIL
                WHERE ZFREQNO = IT_REQHD-ZFREQNO.
                      IF NOT ( ZTREQIL-ZFRECNO IS INITIAL ).
                         CLEAR ZTIDRHSL.
                         MOVE IT_CUCL-ZFBLNO  TO ZTIDRHSL-ZFBLNO.
                         MOVE IT_CUCL-ZFCLSEQ TO ZTIDRHSL-ZFCLSEQ.
                         MOVE 1               TO ZTIDRHSL-ZFCONO.
                         MOVE '911'           TO ZTIDRHSL-ZFCNDC.
                         MOVE ZTREQIL-ZFRECNO TO ZTIDRHSL-ZFCNNO.
                         INSERT ZTIDRHSL.
                         IF SY-SUBRC NE 0.
                            MESSAGE E749 WITH IT_CUCL-ZFBLNO.
                            MOVE 'Y' TO W_ERR_CHK.
                            EXIT.
                         ENDIF.
                      ENDIF.
               ENDSELECT.
               SELECT MAX( ZFAPLDT ) INTO W_ZFAPLDT
                 FROM ZTIMIMG01
                WHERE ZTERM = ZTREQHD-ZTERM.
               SELECT SINGLE *
                 FROM ZTIMIMG01
                 WHERE ZTERM = ZTREQHD-ZTERM
                   AND ZFAPLDT = W_ZFAPLDT.
               IF ZTIMIMG01-ZFREQTY = 'DP'.
                  MOVE 'DP'      TO ZTIDR-ZFAMCD.
               ENDIF.

               SELECT SINGLE *
                 FROM ZTREQHD
                WHERE ZFREQNO = IT_REQHD-ZFREQNO.
               MOVE ZTREQHD-EBELN    TO ZTIDR-ZFREBELN.   "��ǥP/O��?
*>>>KSB
*               SELECT SINGLE ZZBUSTYPE INTO ZTIDR-ZZBUSTYPE " �뵵��?
*                 FROM EKKO
*                WHERE EBELN = ZTIDR-ZFREBELN.
               MOVE ZTREQHD-ZFOPNNO  TO ZTIDR-ZFOPNNO.    "��ǥL/C��?
               MOVE ZTREQHD-INCO1    TO ZTIDR-INCO1.      "Incoterms
               MOVE ZTREQHD-ZFPRNAM  TO ZTIDR-ZFPRNAM.    "P/R���?
               MOVE ZTREQHD-ZFMATGB  TO ZTIDR-ZFMATGB.    "���籸?
               IF ZTIDR-ZFMATGB = '1'.
                 MOVE 'B'   TO ZTIDR-ZFITKD.     " ���ԽŰ���?
               ELSE.
                 MOVE 'K'   TO ZTIDR-ZFITKD.     " ���ԽŰ���?
               ENDIF.
               ADD ZTREQHD-ZFLASTAM  TO W_ZFLASTAM.
               ADD  1  TO  W_LOOP_CNT.
               IF W_LOOP_CNT = 1.
                  CONCATENATE ZTREQHD-EBELN '-' ZTREQHD-ZFOPNNO
                                                INTO ZTIDR-ZFCTW1.
               ENDIF.
               IF W_LOOP_CNT = 2.
                  CONCATENATE ZTREQHD-EBELN '-' ZTREQHD-ZFOPNNO
                                                INTO ZTIDR-ZFCTW2.
               ENDIF.
               IF W_LOOP_CNT = 3.
                  CONCATENATE ZTREQHD-EBELN '-' ZTREQHD-ZFOPNNO
                                                INTO ZTIDR-ZFCTW3.
               ENDIF.
               IF W_LOOP_CNT = 4.
                  CONCATENATE ZTREQHD-EBELN '-' ZTREQHD-ZFOPNNO
                                                INTO ZTIDR-ZFCTW4.
               ENDIF.
               IF W_LOOP_CNT = 5.
                  CONCATENATE ZTREQHD-EBELN '-' ZTREQHD-ZFOPNNO
                                                INTO ZTIDR-ZFCTW5.
               ENDIF.
               CLEAR W_ZFCKAMT.
               SELECT SUM( ZFCKAMT ) INTO W_ZFCKAMT
                 FROM ZTRECST
                WHERE ZFREQNO = IT_REQHD-ZFREQNO
                  AND ZFCSCD = '1AB'.
               ADD W_ZFCKAMT    TO W_ZFINAMT. " ����?
          ENDLOOP.
          ZTIDR-ZFINAMT = W_ZFINAMT * ZTIDR-ZFSTAMT / W_ZFLASTAM.
       ENDIF.

       UPDATE ZTIDR.
       IF SY-SUBRC NE 0.
          MESSAGE E749 WITH IT_CUCL-ZFBLNO.
          MOVE 'Y' TO W_ERR_CHK.
          EXIT.
       ENDIF.
*

  ENDLOOP.

ENDFORM.                    " P4000_CREATE_CUIDR
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFIVNO.

  SELECT SINGLE *
    FROM ZTIV
   WHERE ZFIVNO = P_ZFIVNO.
* SET PARAMETER ID 'ZPREQNO' FIELD ZTIV-ZFREQNO.
  EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.

ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_BL
*&---------------------------------------------------------------------*
FORM P2000_SHOW_BL USING    P_ZFIVNO.

  SELECT SINGLE *
    FROM ZTIV
   WHERE ZFIVNO = P_ZFIVNO.
  SET PARAMETER ID 'ZPBLNO'  FIELD ZTIV-ZFBLNO.
  EXPORT 'ZPBLNO'        TO MEMORY ID 'ZPBLNO'.

ENDFORM.                    " P2000_SHOW_BL
*&---------------------------------------------------------------------*
*&      Form  P2000_CHUNGJOO_GOOMI_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_CHUNGJOO_GOOMI_PROCESS.

  IF ZTIDR-ZFINRC = '151'.
*    MOVE ZTIMIMG00-ZFTDNO1    TO ZTIDR-ZFTDNO.         " ������ ��?
*    MOVE ZTIMIMG00-ZFTDAD11   TO ZTIDR-ZFTDAD1.        " ������ �ּ�1
*    MOVE ZTIMIMG00-ZFTDAD12   TO ZTIDR-ZFTDAD2.        " ������ �ּ�2
*    MOVE ZTIMIMG00-ZFTDTC1    TO ZTIDR-ZFTDTC.         " ������ ���?
  ENDIF.
  IF ZTIDR-ZFINRC = '121'.
*    MOVE ZTIMIMG00-ZFTDNO2    TO ZTIDR-ZFTDNO.         " ������ ���?
*    MOVE ZTIMIMG00-ZFTDAD21   TO ZTIDR-ZFTDAD1.        " ������ �ּ�1
*    MOVE ZTIMIMG00-ZFTDAD22   TO ZTIDR-ZFTDAD2.        " ������ �ּ�2
*    MOVE ZTIMIMG00-ZFTDTC2    TO ZTIDR-ZFTDTC.         " ������ ���?
  ENDIF.

ENDFORM.                    " P2000_CHUNGJOO_GOOMI_PROCESS
