*&---------------------------------------------------------------------*
*& Report  ZRIMCLSC                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ� �ڷ� ����                                    *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.05.25                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : Invoice �ڷḦ ��ȸ�Ͽ� ���ԽŰ��ڷ�(���������)?
*&               �����Ѵ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&             : ��������� �� ��������� �Բ� ó���ϵ��� ����.
*&---------------------------------------------------------------------*
REPORT  ZRIMCLSC    MESSAGE-ID ZIM
                    LINE-SIZE 135
                    NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMCLSCTOP.
INCLUDE   ZRIMSORTCOM.    " Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_HBLNO  FOR ZTBL-ZFHBLNO,      " House B/L No
                   S_MBLNO  FOR ZTBL-ZFMBLNO,      " Master B/L No
                   S_BLNO   FOR ZTIV-ZFBLNO,       " B/L ������?
                   S_IVNO   FOR ZTIV-ZFIVNO,       " Invoice  ������?
                   S_ETA    FOR ZTBL-ZFETA.        " ������(ETA)

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
* ��ȯ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(14) TEXT-003, POSITION 1.
     SELECTION-SCREEN : COMMENT 36(4) TEXT-031, POSITION 43.
     PARAMETERS : P_POY    AS CHECKBOX.              " ��?
     SELECTION-SCREEN : COMMENT 46(4) TEXT-032, POSITION 55.
     PARAMETERS : P_PON    AS CHECKBOX.              " ��?
     SELECTION-SCREEN : COMMENT 60(7) TEXT-033, POSITION 69.
     PARAMETERS : P_POM    AS CHECKBOX.              " ��?
  SELECTION-SCREEN END OF LINE.
* �����?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(19) TEXT-004, POSITION 1.
     SELECTION-SCREEN : COMMENT 32(8) TEXT-041, POSITION 43.
     PARAMETERS : P_CU1    AS CHECKBOX.              " ������?
     SELECTION-SCREEN : COMMENT 46(8) TEXT-042, POSITION 55.
     PARAMETERS : P_CU2    AS CHECKBOX.              " �Ƿڴ�?
     SELECTION-SCREEN : COMMENT 60(6) TEXT-043, POSITION 67.
     PARAMETERS : P_CU3    AS CHECKBOX.              " �Ƿ�?
     SELECTION-SCREEN : COMMENT 70(8) TEXT-044, POSITION 79.
     PARAMETERS : P_CUY    AS CHECKBOX.              " �����?
  SELECTION-SCREEN END OF LINE.

* �������.
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(19) TEXT-005, POSITION 1.
     SELECTION-SCREEN : COMMENT 32(10) TEXT-051, POSITION 43.
     PARAMETERS : P_CD1    AS CHECKBOX.              " ���������.
     SELECTION-SCREEN : COMMENT 46(8) TEXT-052, POSITION 55.
     PARAMETERS : P_CD2    AS CHECKBOX.              " �������.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.
   SET  TITLEBAR 'ZIM60'.           " GUI TITLE SETTING..
   SELECT  SINGLE *  FROM  ZTIMIMG00.

* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ����Ʈ ���� TEXT TABLE SELECT
  CLEAR  W_GUBN.
* IF ZTIMIMG00-ZFIMPATH NE '1'.
*    MESSAGE  S564.  EXIT.
* ENDIF.
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
           W_FIELD_NM = 'ZFIVNO'.
           ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
           PERFORM HANDLE_SORT TABLES  IT_TAB
                               USING   SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
            PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'CDRC'.                   " ���ԽŰ� �ڷ� ��?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766. EXIT.
            ENDIF.
            PERFORM P4000_CREATE_DATA        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.
               MESSAGE E473 WITH IT_SELECTED-ZFIVNO W_ZFBLNO W_ZFCLSEQ.
            ENDIF.

            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            MESSAGE S750 WITH W_SELECTED_LINES W_PROC_CNT W_PROC_CNT.
            IF W_ERR_CHK EQ 'Y'.
               LEAVE TO SCREEN 0.
            ENDIF.
            PERFORM RESET_LIST.
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
  P_CU1 = 'X'.
  P_CD1 = 'X'.
  P_CD2 = 'X'.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50  '[ ���ԽŰ� �ڷ� ���� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / ' Date : ', SY-DATUM, 117 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE NO-GAP,
            '�����ȣ  '           NO-GAP, SY-VLINE NO-GAP,
            'B/L       '           NO-GAP, SY-VLINE NO-GAP,
            'House B/L '           NO-GAP,
            '              '       NO-GAP, SY-VLINE NO-GAP,
            '����ݾ�           '  NO-GAP, SY-VLINE NO-GAP,
            '��ȭ '                NO-GAP, SY-VLINE NO-GAP,
            'ȯ��        '         NO-GAP, SY-VLINE NO-GAP,
            '�����ȭ�ݾ�       '  NO-GAP, SY-VLINE NO-GAP,
            '����ȯ����'           NO-GAP, SY-VLINE NO-GAP,
            '���԰ŷ�����'         NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',         SY-VLINE NO-GAP,
            'Vendor      '         NO-GAP,
            '                    ' NO-GAP,
            '              '       NO-GAP, SY-VLINE NO-GAP,
            'Phantom Vendor     '  NO-GAP, SY-VLINE NO-GAP,
            '�������          '   NO-GAP, SY-VLINE NO-GAP,
            '�������           '  NO-GAP, SY-VLINE NO-GAP,
            'G/R ����  '           NO-GAP, SY-VLINE NO-GAP,
            'I/V ����    '         NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIM78'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIM60'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
* Vendor �� Select
      SELECT SINGLE NAME1 INTO W_NAME1 FROM LFA1
      WHERE  LIFNR = IT_TAB-LIFNR .
* ��ȯ, ��ȯ ����.
      IF IT_TAB-ZFPOYN = 'Y'.
         W_POYN = '��ȯ'.
      ELSE.
         W_POYN = '��ȯ'.
      ENDIF.

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
  FORMAT COLOR COL_BACKGROUND.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE NO-GAP,
       IT_TAB-ZFIVNO   NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFBLNO   NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFHBLNO  NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMT  CURRENCY IT_TAB-ZFIVAMC
                       NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMC  NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFEXRT   NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMK  CURRENCY 'KRW'
                       NO-GAP, SY-VLINE NO-GAP,
       W_POYN          NO-GAP,
       '      '        NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFPONC   NO-GAP,
       '         '     NO-GAP, SY-VLINE NO-GAP.
* Hide
       MOVE SY-TABIX  TO W_LIST_INDEX.
       HIDE: W_LIST_INDEX, IT_TAB.
       MODIFY IT_TAB INDEX SY-TABIX.

       FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
       WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
       IT_TAB-LIFNR    NO-GAP, SY-VLINE NO-GAP,
       W_NAME1         NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFPHVN   NO-GAP,
       '         '     NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFCLCD   NO-GAP,
       '            '  NO-GAP,
       '     '         NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFCUST   NO-GAP,
       '            '  NO-GAP,
       '      '        NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFGRST   NO-GAP,
       '         '     NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFCIVST  NO-GAP,
       '           '   NO-GAP, SY-VLINE NO-GAP.
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
     WRITE : / ' ��', W_COUNT, '��'.
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
  W_GUBN  = 'X'.
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
  CLEAR   IT_TAB.
  IF P_POY = ' ' AND P_PON = ' ' AND P_POM = ' '. MESSAGE S738. EXIT.
  ENDIF.
  IF P_CU1 = ' ' AND P_CU2 = ' ' AND P_CU3 = ' ' AND P_CUY = ' '.
     MESSAGE S738. EXIT.
  ENDIF.
  IF P_CD1 IS INITIAL AND P_CD2 IS INITIAL.
     MESSAGE S738. EXIT.
  ENDIF.

* ��ȯ, ��ȯ ���� SETTING!
  REFRESH : R_TERM1.
  IF P_POY = 'X'.
    MOVE : 'I'       TO       R_TERM1-SIGN,
           'EQ'      TO       R_TERM1-OPTION,
           'Y'       TO       R_TERM1-LOW,
           SPACE     TO       R_TERM1-HIGH.
    APPEND    R_TERM1.
  ENDIF.
  IF P_PON = 'X'.
    MOVE : 'I'       TO       R_TERM1-SIGN,
           'EQ'      TO       R_TERM1-OPTION,
           'N'       TO       R_TERM1-LOW,
           SPACE     TO       R_TERM1-HIGH.
    APPEND    R_TERM1.
  ENDIF.
  IF P_POM = 'X'.
    MOVE : 'I'       TO       R_TERM1-SIGN,
           'EQ'      TO       R_TERM1-OPTION,
           'M'       TO       R_TERM1-LOW,
           SPACE     TO       R_TERM1-HIGH.
    APPEND    R_TERM1.
  ENDIF.

* ��� ���� SETTING!
  REFRESH R_TERM2.
  IF P_CU1 = 'X'.
    MOVE : 'I'       TO       R_TERM2-SIGN,
           'EQ'      TO       R_TERM2-OPTION,
           '1'       TO       R_TERM2-LOW,
           SPACE     TO       R_TERM2-HIGH.
    APPEND    R_TERM2.
  ENDIF.
  IF P_CU2 = 'X'.
    MOVE : 'I'       TO       R_TERM2-SIGN,
           'EQ'      TO       R_TERM2-OPTION,
           '2'       TO       R_TERM2-LOW,
           SPACE     TO       R_TERM2-HIGH.
    APPEND    R_TERM2.
  ENDIF.
  IF P_CU3 = 'X'.
    MOVE : 'I'       TO       R_TERM2-SIGN,
           'EQ'      TO       R_TERM2-OPTION,
           '3'       TO       R_TERM2-LOW,
           SPACE     TO       R_TERM2-HIGH.
    APPEND    R_TERM2.
  ENDIF.
  IF P_CUY = 'X'.
    MOVE : 'I'       TO       R_TERM2-SIGN,
           'EQ'      TO       R_TERM2-OPTION,
           'Y'       TO       R_TERM2-LOW,
           SPACE     TO       R_TERM2-HIGH.
    APPEND    R_TERM2.
  ENDIF.
* ������� ���� SETTING
  REFRESH R_TERM3.
  IF P_CD1 = 'X'.
    MOVE : 'I'       TO       R_TERM3-SIGN,
           'EQ'      TO       R_TERM3-OPTION,
           'C'       TO       R_TERM3-LOW,
           SPACE     TO       R_TERM3-HIGH.
    APPEND    R_TERM3.
  ENDIF.
  IF P_CD2 = 'X'.
    MOVE : 'I'       TO       R_TERM3-SIGN,
           'EQ'      TO       R_TERM3-OPTION,
           'A'       TO       R_TERM3-LOW,
           SPACE     TO       R_TERM3-HIGH.
    APPEND    R_TERM3.
  ENDIF.

*>> ���ǿ� �ش��ϴ� DATA SELECT.
  SELECT  H~ZFIVNO  H~ZFBLNO  I~ZFHBLNO  H~ZFIVAMT
          H~ZFIVAMC H~ZFIVAMK H~ZFEXRT   H~ZFPOYN
          H~ZFPONC  H~LIFNR   H~ZFPHVN   H~ZFCLCD
          H~ZFCUST  H~ZFGRST  H~ZFCIVST
  INTO    CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM    ZTIV AS H INNER JOIN ZTBL AS I
  ON      H~ZFBLNO  EQ    I~ZFBLNO
  WHERE   H~ZFIVNO  IN    S_IVNO
  AND     H~ZFBLNO  IN    S_BLNO
  AND     I~ZFHBLNO IN    S_HBLNO
  AND     I~ZFMBLNO IN    S_MBLNO
  AND     I~ZFETA   IN    S_ETA
  AND     H~ZFPOYN  IN    R_TERM1
  AND     H~ZFCUST  IN    R_TERM2
  AND     H~ZFCLCD  IN    R_TERM3 .

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
     W_ERR_CHK = 'Y'.
     IF W_GUBN IS INITIAL. MESSAGE S738. ENDIF.
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
       MOVE 'B'                 TO ZTIDR-ZFITKD.         " ���ԽŰ���?
       MOVE 'ETC'               TO ZTIDR-ZFTRCN.         " ��ۿ�?
*       MOVE ZTIMIMG00-ZFTDNO    TO ZTIDR-ZFTDNO.         " ������ ���?
       MOVE ZTIMIMGTX-ZFTDNM1   TO ZTIDR-ZFTDNM1.        " ������ ��?
       MOVE ZTIMIMGTX-ZFTDNM2   TO ZTIDR-ZFTDNM2.        " ������ ��?
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

       SELECT SINGLE * FROM ZTIMIMGTX
              WHERE BUKRS EQ ZTBL-BUKRS.
       IF SY-SUBRC NE 0.
          MESSAGE E949 WITH ZTBL-BUKRS.
       ENDIF.

       MOVE ZTBL-ZFPONC         TO ZTIDR-ZFPONC.          "���԰ŷ���?
       MOVE ZTBL-ZFAPRTC        TO ZTIDR-ZFAPRTC.         "����?
       MOVE ZTBL-ZFCARC         TO ZTIDR-ZFSCON.          "����?
       MOVE ZTBL-ZFETA          TO ZTIDR-ZFENDT.          "����?
*>> ��ȯ.
       IF ZTBL-ZFPOYN = 'Y'.
          MOVE 'B'              TO ZTIDR-ZFIMCD.          "�����ڱ�?
*          MOVE ZTIMIMGTX-ZFAPNO1 TO ZTIDR-ZFAPNO.   "������ ���������?
*          MOVE ZTIMIMGTX-ZFIAPNM1 TO ZTIDR-ZFIAPNM.  "������ ��?
          MOVE ZTIMIMGTX-ZFAPNO2 TO ZTIDR-ZFAPNO.   "������ ���������?
          MOVE ZTIMIMGTX-ZFIAPNM2 TO ZTIDR-ZFIAPNM.  "������ ��?
       ENDIF.
       IF ZTBL-ZFPOYN = 'N'.
          MOVE 'A'              TO ZTIDR-ZFIMCD.
          MOVE ZTIMIMGTX-ZFAPNO2 TO ZTIDR-ZFAPNO.   "������ ���������?
          MOVE ZTIMIMGTX-ZFIAPNM2 TO ZTIDR-ZFIAPNM.  "������ ��?
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
       MOVE ZTBL-ZFGMNO    TO ZTIDR-ZFGOMNO.             "ȭ��������?
*       MOVE ZTBL-ZFPKCN    TO ZTIDR-ZFPKCNT.             "�����尹?
       MOVE ZTBL-ZFPKCNM   TO ZTIDR-ZFPKNM.              "������?
*       MOVE ZTBL-ZFTOWT    TO ZTIDR-ZFTOWT.              "����?
       MOVE ZTBL-ZFTOWTM   TO ZTIDR-ZFTOWTM.             "���߷���?

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
               MOVE 'KRW'               TO ZTIDRHS-ZFKRW.
               MOVE 'USD'               TO ZTIDRHS-ZFUSD.
               MOVE ZTBL-ZFTOWTM   TO ZTIDR-ZFTOWTM.        "�߷���?

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
                     ADD ZTIVIT-CCMENGE  TO W_MENGE.
              ENDSELECT.
       ENDSELECT.
       CLEAR ZTBL.
       SELECT SINGLE *
         FROM ZTBL
        WHERE ZFBLNO = IT_CUCL-ZFBLNO.
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
                         ZTBL-ZFTOWT * ZTIDRHS-ZFQNT / W_MENGE.
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

       ZTIDR-ZFPKCNT = ZTBL-ZFPKCN * W_ZFQNT / W_MENGE. "�����?

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
*                       MOVE ZTIV-ZFREQNO    TO IT_REQHD-ZFREQNO.
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
               MOVE ZTREQHD-EBELN    TO ZTIDR-ZFREBELN.     "��ǥP/O��?
*>>>KSB
*               SELECT SINGLE ZZBUSTYPE INTO ZTIDR-ZZBUSTYPE " �뵵��?
*                 FROM EKKO
*                WHERE EBELN = ZTIDR-ZFREBELN.
               MOVE ZTREQHD-ZFOPNNO  TO ZTIDR-ZFOPNNO.      "��ǥL/C��?
               MOVE ZTREQHD-INCO1    TO ZTIDR-INCO1.        "Incoterms
               MOVE ZTREQHD-ZFPRNAM  TO ZTIDR-ZFPRNAM.      "P/R���?
               MOVE ZTREQHD-ZFMATGB  TO ZTIDR-ZFMATGB.      "���籸?
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

  ENDLOOP.

ENDFORM.                    " P4000_CREATE_CUIDR
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFIVNO.

  SELECT SINGLE *
    FROM ZTIV
   WHERE ZFIVNO = P_ZFIVNO.
*  SET PARAMETER ID 'ZPREQNO' FIELD ZTIV-ZFREQNO.
*  SET PARAMETER ID 'ZPREQNO' FIELD IT_TAB-ZFREQNO.
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
*&      Form  P4000_CREATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P4000_CREATE_DATA USING    P_W_ERR_CHK.
  MOVE 'N' TO W_ERR_CHK.
  CLEAR W_PROC_CNT.

  LOOP AT IT_SELECTED.
    IF IT_SELECTED-ZFCUST NE '1'. CONTINUE. ENDIF.
    W_PROC_CNT = W_PROC_CNT + 1.
    CALL FUNCTION 'ZIM_CUDATA_CREATE'
       EXPORTING
             W_ZFIVNO            =   IT_SELECTED-ZFIVNO
       IMPORTING
             W_ZFBLNO            =   W_ZFBLNO
             W_ZFCLSEQ           =   W_ZFCLSEQ
       EXCEPTIONS
             ERROR_INSERT.

    IF SY-SUBRC NE 0.
       MOVE 'Y' TO W_ERR_CHK.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " P4000_CREATE_DATA
