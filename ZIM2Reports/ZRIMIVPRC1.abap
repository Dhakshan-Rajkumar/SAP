*&---------------------------------------------------------------------*
*& Report  ZRIMIVPRC1                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Invoice Processing - ����� Invoice Verification
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.02.23                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : �԰�ó��,�����,I/V BDC, G/R BDC
*&               Invoice�� ó������ ������� ���� Invoice�� ��ȸ�Ѵ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMIVPRC1  MESSAGE-ID ZIM
                    LINE-SIZE 145
                    NO STANDARD PAGE HEADING.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK            TYPE   C,
*      ZFHBLNO         like   ztbl-zfhblno,        " House B/L No
       ZFHBLNO(13)     TYPE   C,
*      ZFBLNO          like   ZTIV-ZFBLNO,         " B/L ������?
       ZFBLNO(17)      TYPE   C,
*      ZFCIVNO         LIKE   ZTIV-ZFCIVNO,        " Commercial Invoice
       ZFCIVNO(16)     TYPE   C,
       ZFETA           LIKE   ZTBL-ZFETA,          " ������(ETA)
       CDAT            LIKE   ZTIV-CDAT,           " Invoice �Է�?
*      ZFMBLNO         LIKE   ZTBL-ZFMBLNO,        " Master B/L No
       ZFMBLNO(13)     TYPE   C,
       ZFMATGB         LIKE   ZTBL-ZFMATGB,        " ���籸?
       ZFCUST          LIKE   ZTIV-ZFCUST,         " �����?
       ZFCDST          LIKE   ZTIV-ZFCDST,         " �δ��� ��λ�?
*      ZFIVST          LIKE   ZTIV-ZFIVST,         " Invoice Verify ��?
       ZFCIVST         LIKE   ZTIV-ZFCIVST,        " ��������� IV ��?
       ZFWERKS         LIKE   ZTBL-ZFWERKS,        " Plant
*      ZFOPNNO         LIKE   ZTREQST-ZFOPNNO,     " L/C No
       ZFOPNNO(13)     TYPE   C,
*      ZFREQNO         LIKE   ZTIV-ZFREQNO,        " �����Ƿ� ������?
       ZFREQNO(17)     TYPE   C,
*      ZFIVNO          LIKE   ZTIV-ZFIVNO,         " Invoice ������?
       ZFIVNO(16)      TYPE   C,
       ZFOPNDT         LIKE   ZTREQST-ZFOPNDT,     " L/C ����?
*      ZFMAVN          LIKE   ZTIV-ZFMAVN,         " Vendor
       ZFMAVN_NME(17)  TYPE   C,                   " Vendor ?
       ZFPOYN          LIKE   ZTIV-ZFPOYN,         " ��ȯ��?
*      ZFPAYYN         LIKE   ZTIV-ZFPAYYN,        " Payment ��?
       ZFGRST          LIKE   ZTIV-ZFGRST,         " Good Receipt ��?
       ZFPONMA         LIKE   ZTIV-ZFPONMA,        " ��ȯ�����Կ�?
*      ZFPRPYN         LIKE   ZTIV-ZFPRPYN,        " ���ޱݿ�?
       EKORG           LIKE   ZTBL-EKORG,          " ������?
       EKGRP           LIKE   ZTBL-EKGRP.          " ���ű�?
DATA : END OF IT_TAB.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMIVPRC1TOP.

INCLUDE   ZRIMSORTCOM.    " Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_HBLNO  FOR ZTBL-ZFHBLNO,      " House B/L No
                   S_OPNNO  FOR ZTREQST-ZFOPNNO,   " L/C No
*                  S_CIVNO  FOR ZTIV-ZFCIVNO,      " Commercial Invoice
                   S_ETA    FOR ZTBL-ZFETA,        " ������(ETA)
                   S_CDAT   FOR ZTIV-CDAT,         " Invoice �Է�?
                   S_BLNO   FOR ZTIV-ZFBLNO,       " B/L ������?
*                  S_REQNO  FOR ZTIV-ZFREQNO,      " �����Ƿ� ������?
                   S_IVNO   FOR ZTIV-ZFIVNO,       " Invoice  ������?
                   S_MBLNO  FOR ZTBL-ZFMBLNO,      " Master B/L No
*                  S_MAVN   FOR ZTIV-ZFMAVN,       " ���� Vendor
                   S_MATGB  FOR ZTBL-ZFMATGB,      " ���籸?
                   S_WERKS  FOR ZTBL-ZFWERKS,      " Plant
                   S_EKORG  FOR ZTBL-EKORG,        " ������?
                   S_EKGRP  FOR ZTBL-EKGRP.        " ���ű�?

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
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(19) TEXT-007, POSITION 1.
     SELECTION-SCREEN : COMMENT 32(8) TEXT-071, POSITION 41.
     PARAMETERS : P_CUY    AS CHECKBOX.              " �����?
     SELECTION-SCREEN : COMMENT 44(8) TEXT-072, POSITION 53.
     PARAMETERS : P_CU1    AS CHECKBOX.              " ������?
     SELECTION-SCREEN : COMMENT 56(8) TEXT-073, POSITION 65.
     PARAMETERS : P_CU2    AS CHECKBOX.              " �Ƿڴ�?
     SELECTION-SCREEN : COMMENT 70(6) TEXT-074, POSITION 77.
     PARAMETERS : P_CU3    AS CHECKBOX.              " �Ƿ�?
  SELECTION-SCREEN END OF LINE.

* �δ��� ��ο�?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-004, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-041, POSITION 41.
     PARAMETERS : P_CDN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-042, POSITION 53.
     PARAMETERS : P_CDY    AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* I/V ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(19) TEXT-005, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-051, POSITION 41.
     PARAMETERS : P_IVN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-052, POSITION 53.
     PARAMETERS : P_IVY    AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* G/R ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-006, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-061, POSITION 41.
     PARAMETERS : P_GRN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-062, POSITION 53.
     PARAMETERS : P_GRY    AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* ��������� I/V ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(26) TEXT-011, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-111, POSITION 41.
     PARAMETERS : P_CIVN   AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-112, POSITION 53.
     PARAMETERS : P_CIVY   AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* ���ޱݿ�?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-009, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-091, POSITION 41.
     PARAMETERS : P_PRPN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-092, POSITION 53.
     PARAMETERS : P_PRPY    AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* ��ȯ�����Կ�?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-010, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-101, POSITION 41.
     PARAMETERS : P_POMN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-102, POSITION 53.
     PARAMETERS : P_POMY    AS CHECKBOX.              " Yes
  SELECTION-SCREEN END OF LINE.

* Payment ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-008, POSITION 1.
     SELECTION-SCREEN : COMMENT 38(2) TEXT-081, POSITION 41.
     PARAMETERS : P_PYN    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 49(3) TEXT-082, POSITION 53.
     PARAMETERS : P_PYY    AS CHECKBOX.              " Yes
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
   PERFORM   P3000_DATA_WRITE       USING W_ERR_CHK.
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
      WHEN 'IVBD'.                   " Invoice Verify BDC
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               PERFORM P4000_INVO_VERIF         USING W_ERR_CHK.
               IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
               PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
               IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
               PERFORM RESET_LIST.
               MESSAGE S757 WITH W_PROC_CNT.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
      WHEN 'AMTF'.                    " Invoice �ݾ�Ȯ?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_IV USING IT_SELECTED-ZFIVNO.
               CALL TRANSACTION 'ZIM34' AND SKIP FIRST SCREEN.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
      WHEN 'AMTI'.                    " Invoice �ݾ���?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_IV USING IT_SELECTED-ZFIVNO.
               CALL TRANSACTION 'ZIM34' AND SKIP FIRST SCREEN.
            ELSEIF W_SELECTED_LINES GT 1.
               MESSAGE E965.
            ENDIF.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
      WHEN 'STCG'.                    " Invoice ���º�?
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 1.
               READ TABLE IT_SELECTED INDEX 1.
               PERFORM P2000_SHOW_IV USING IT_SELECTED-ZFIVNO.
               CALL TRANSACTION 'ZIM34' AND SKIP FIRST SCREEN.
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
  P_CUY = 'X'.
  P_CDY = 'X'.
  P_CDN = 'X'.
  P_IVN = 'X'.
  P_GRN = 'X'.
  P_CIVN = 'X'.
  P_PRPN = 'X'.
  P_POMN = 'X'.
  P_PYN = 'X'.
  P_PYY = 'X'.
  SELECT SINGLE *
    FROM ZTIMIMG11.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /60  '[ Invoice Processing ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 118 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE NO-GAP,
            'House B/L No '       NO-GAP, SY-VLINE NO-GAP,
            'B/L ������ȣ     '   NO-GAP, SY-VLINE NO-GAP,
            'Invoice No      '    NO-GAP, SY-VLINE NO-GAP,
            'B/L ������'          NO-GAP, SY-VLINE NO-GAP,
            'Invoice �Է���'      NO-GAP, SY-VLINE NO-GAP,
            'Master B/L No'       NO-GAP, SY-VLINE NO-GAP,
            '���籸��'            NO-GAP, SY-VLINE NO-GAP,
            '�������'            NO-GAP, SY-VLINE NO-GAP,
            '�δ���'            NO-GAP, SY-VLINE NO-GAP,
            'Pay.����'            NO-GAP, SY-VLINE NO-GAP,
            'POrg    '            NO-GAP, SY-VLINE NO-GAP,
            'Plant'               NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
            'L/C No       '       NO-GAP, SY-VLINE NO-GAP,
            '�����Ƿ� ������ȣ'   NO-GAP, SY-VLINE NO-GAP,
            'Invoice ������ȣ'    NO-GAP, SY-VLINE NO-GAP,
            'L/C ������'          NO-GAP, SY-VLINE NO-GAP,
            'Vendor                      '   NO-GAP, SY-VLINE NO-GAP,
            '����ȯ  '            NO-GAP, SY-VLINE NO-GAP,
            'I/V ����'            NO-GAP, SY-VLINE NO-GAP,
            'G/R ����'            NO-GAP, SY-VLINE NO-GAP,
            '���ޱ�  '            NO-GAP, SY-VLINE NO-GAP,
            '��ȯ����'            NO-GAP, SY-VLINE NO-GAP,
            'PGp  '               NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIM59'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIM59'.           " GUI TITLE SETTING..

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
       IT_TAB-ZFHBLNO  NO-GAP,
       SY-VLINE NO-GAP,               " House B/L No
       IT_TAB-ZFBLNO   NO-GAP,
       SY-VLINE NO-GAP,               " B/L ������?
       IT_TAB-ZFCIVNO  NO-GAP,
       SY-VLINE NO-GAP,                " Commercial Invoice No
       IT_TAB-ZFETA    NO-GAP,
       SY-VLINE NO-GAP,                " ������(ETA)
       IT_TAB-CDAT     NO-GAP,
       '    '          NO-GAP,
       SY-VLINE NO-GAP,                " Invoice �Է�?
       IT_TAB-ZFMBLNO  NO-GAP,
       SY-VLINE NO-GAP,                " Master B/L No
       IT_TAB-ZFMATGB  NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " ���籸?
       IT_TAB-ZFCUST   NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " �����?
       IT_TAB-ZFCDST   NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " �δ��� ��λ�?
*      IT_TAB-ZFPAYYN  NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " Payment ��?
       IT_TAB-EKORG    NO-GAP,
       '    '          NO-GAP,
       SY-VLINE NO-GAP,                " ������?
       IT_TAB-ZFWERKS  NO-GAP,
       ' '             NO-GAP,
       SY-VLINE NO-GAP.               " Plant
* Hide
       MOVE SY-TABIX  TO W_LIST_INDEX.
       HIDE: W_LIST_INDEX, IT_TAB.
       MODIFY IT_TAB INDEX SY-TABIX.

       FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
       WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
       IT_TAB-ZFOPNNO  NO-GAP,
       SY-VLINE NO-GAP,                " L/C No
       IT_TAB-ZFREQNO  NO-GAP,
       SY-VLINE NO-GAP,                " �����Ƿ� ������?
       IT_TAB-ZFIVNO   NO-GAP,
       SY-VLINE NO-GAP,                " Invoice ������?
       IT_TAB-ZFOPNDT  NO-GAP,
       SY-VLINE NO-GAP,                " L/C ����?
*      IT_TAB-ZFMAVN   NO-GAP,
       ' '             NO-GAP,
       IT_TAB-ZFMAVN_NME NO-GAP,
       SY-VLINE NO-GAP,                " Vendor
       IT_TAB-ZFPOYN   NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " ����ȯ ��?
*      IT_TAB-ZFIVST   NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,               " Invoice Verify ��?
       IT_TAB-ZFGRST   NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " Good Receipt ��?
*      IT_TAB-ZFPRPYN  NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " ���ޱݿ�?
       IT_TAB-ZFPONMA  NO-GAP,
       '       '       NO-GAP,
       SY-VLINE NO-GAP,                " ��ȯ�����Կ�?
       IT_TAB-EKGRP    NO-GAP,
       '  '            NO-GAP,
       SY-VLINE NO-GAP.                " ���ű�?

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
  IF P_CUY = ' ' AND P_CU1 = ' ' AND P_CU2 = ' ' AND P_CU3 = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_IVN = ' ' AND P_IVY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_GRN = ' ' AND P_GRY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_CIVN = ' ' AND P_CIVY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_PRPN = ' ' AND P_PRPY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_POMN = ' ' AND P_POMY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.
  IF P_PYN = ' ' AND P_PYY = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.

  SELECT *
    FROM ZTIV
   WHERE  " ZFCIVNO    IN S_CIVNO
         CDAT       IN S_CDAT
     AND ZFBLNO     IN S_BLNO
*    AND ZFREQNO    IN S_REQNO
     AND ZFIVNO     IN S_IVNO.
*    AND ZFMAVN     IN S_MAVN.
         CLEAR   IT_TAB.
         MOVE-CORRESPONDING ZTIV TO IT_TAB.

         CASE IT_TAB-ZFPOYN.                       " ��ȯ��?
              WHEN 'Y'.                            " ��?
                   IF P_POY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'N'.                            " ��?
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

         CASE IT_TAB-ZFCDST.                       " �δ��� ��ο�?
              WHEN 'Y'.
                   IF P_CDY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'N'.
                   IF P_CDN = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

*        CASE IT_TAB-ZFIVST.                       " I/V ��?
*             WHEN 'Y'.                            " ó����?
*                  IF P_IVY = ' '.
*                     CONTINUE.
*                  ENDIF.
*             WHEN 'N'.                            " I/V ó����?
*                  IF P_IVN = ' '.
*                     CONTINUE.
*                  ENDIF.
*             WHEN OTHERS.
*                  CONTINUE.
*        ENDCASE.

         CASE IT_TAB-ZFGRST.                       " G/R ��?
              WHEN 'Y'.                            " G/R ��?
                   IF P_GRY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'N'.                            " G/R ��?
                   IF P_GRN = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

         CASE IT_TAB-ZFCIVST.                      " ����� I/V ��?
              WHEN 'Y'.                            " ó����?
                   IF P_CIVY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'N'.                            " I/V ó����?
                   IF P_CIVN = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

*        CASE IT_TAB-ZFPRPYN.                      " ���ޱݿ�?
*             WHEN 'Y'.                            " Yes
*                  IF P_PRPY = ' '.
*                     CONTINUE.
*                  ENDIF.
*             WHEN 'N'.                            " No
*                  IF P_PRPN = ' '.
*                     CONTINUE.
*                  ENDIF.
*             WHEN OTHERS.
*                  CONTINUE.
*        ENDCASE.

         CASE IT_TAB-ZFPONMA.                      " ��ȯ�����Կ�?
              WHEN 'Y'.                            " Yes
                   IF P_POMY = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN 'N'.                            " No
                   IF P_POMN = ' '.
                      CONTINUE.
                   ENDIF.
              WHEN OTHERS.
                   CONTINUE.
         ENDCASE.

         CLEAR ZTBL.
         SELECT SINGLE *
           FROM ZTBL
          WHERE ZFBLNO = IT_TAB-ZFBLNO
            AND ZFETA   IN S_ETA
            AND ZFHBLNO IN S_HBLNO
            AND EKORG   IN S_EKORG
            AND EKGRP   IN S_EKGRP.
         IF SY-SUBRC NE 0.
            CONTINUE.
         ENDIF.
         MOVE-CORRESPONDING ZTBL TO IT_TAB.
         MOVE ZTIV-ZFPOYN        TO IT_TAB-ZFPOYN.

         IF IT_TAB-ZFPOYN EQ 'Y'.
            SELECT SINGLE *
              FROM ZTREQHD
             WHERE ZFREQNO = IT_TAB-ZFREQNO
               AND ZFOPNNO IN S_OPNNO
               AND ZFWERKS IN S_WERKS
               AND ZFMATGB IN S_MATGB.
            IF SY-SUBRC NE 0.
               CONTINUE.
            ENDIF.

            SELECT MAX( ZFOPNDT ) INTO IT_TAB-ZFOPNDT         " ����?
              FROM ZTREQST
             WHERE ZFREQNO = IT_TAB-ZFREQNO.

            MOVE ZTREQHD-ZFOPNNO TO IT_TAB-ZFOPNNO.
         ENDIF.

*        SELECT SINGLE NAME1 INTO IT_TAB-ZFMAVN_NME
*          FROM LFA1
*         WHERE LIFNR = IT_TAB-ZFMAVN.
*
         APPEND  IT_TAB.

  ENDSELECT.

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
     MESSAGE S738.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IV
*&---------------------------------------------------------------------*
FORM P2000_SHOW_IV USING    P_ZFIVNO.

   SET PARAMETER ID 'ZPIVNO'  FIELD P_ZFIVNO.
   SET PARAMETER ID 'ZPCIVNO' FIELD ''.

   EXPORT 'ZPIVNO'        TO MEMORY ID 'ZPIVNO'.

ENDFORM.                    " P2000_SHOW_IV
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: INDEX   TYPE P,
        ZFIVNO  LIKE ZTIV-ZFIVNO.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFIVNO   TO ZFIVNO.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : W_LIST_INDEX    TO INDEX,
                IT_TAB-ZFIVNO   TO IT_SELECTED-ZFIVNO.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P4000_INVO_VERIF
*&---------------------------------------------------------------------*
FORM P4000_INVO_VERIF USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.
  CLEAR W_PROC_CNT.
  PERFORM P4000_GET_IV_INIVAL.
  IF OK-CODE NE 'YES'.
     EXIT.
  ENDIF.

  LOOP AT IT_SELECTED.
       SELECT SINGLE *
         FROM ZTIV
        WHERE ZFIVNO = IT_SELECTED-ZFIVNO.
       IF SY-SUBRC NE 0.
          CONTINUE.
       ENDIF.

       PERFORM P4000_IV_VALID_CHECK.
       IF W_ERR_CHK EQ 'Y'.
          EXIT.
       ENDIF.

       PERFORM P4000_IV_BDC.
       IF W_ERR_CHK EQ 'Y'.
          EXIT.
       ENDIF.
       ADD 1       TO W_PROC_CNT.
  ENDLOOP.

ENDFORM.                    " P4000_INVO_VERIF
*&---------------------------------------------------------------------*
*&      Form  P4000_IV_VALID_CHECK
*&---------------------------------------------------------------------*
FORM P4000_IV_VALID_CHECK.

  IF ZTIV-ZFCUST NE 'N'.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E600 WITH '��� �Ϸ�'.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.
  IF ZTIV-ZFCDST NE 'N'.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E600 WITH '�δ����� �Ϸ�'.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.
* IF ZTIV-ZFIVST NE 'N'.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E600 WITH 'Invoice Verification �Ϸ�'.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.
  IF ZTIV-ZFGRST NE 'N'.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E600 WITH 'Good Receipt �Ϸ�'.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.
  IF ZTIV-ZFCIVST NE 'N'.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E600 WITH '��������� Invoice Verification �Ϸ�'.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.
* IF ZTIV-ZFPAYYN NE 'N'.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E600 WITH 'Payment �Ϸ�'.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.
  IF ZTIV-ZFPOYN NE 'Y'.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E600 WITH '��ȯ Invoice'.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.

  SELECT SINGLE *
    FROM ZTBL
   WHERE ZFBLNO = ZTIV-ZFBLNO.
  IF SY-SUBRC NE 0.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E038 WITH ZTIV-ZFBLNO.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.

* W_ZFIVDDT = ZTBL-ZFETD.
* IF ZTBL-ZFETD > SY-DATUM.
*    W_ZFIVDDT = SY-DATUM.
* ENDIF.

* IF W_ZFIVPDT IS INITIAL.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E793.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.

* IF W_ZFIVDDT IS INITIAL.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E794.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.

* SELECT SINGLE *
*   FROM ZTREQHD
*  WHERE ZFREQNO = ZTIV-ZFREQNO.
* IF SY-SUBRC NE 0.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E018 WITH ZTIV-ZFREQNO.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.


  SELECT *
    FROM ZTIVIT
   WHERE ZFIVNO = ZTIV-ZFIVNO
   ORDER BY ZFIVDNO.
         SELECT SINGLE *
           FROM EKPO
          WHERE EBELN EQ ZTREQHD-EBELN
            AND EBELP EQ ZTIVIT-ZFIVDNO.
         IF SY-SUBRC NE 0.
            MESSAGE I787 WITH ZTIV-ZFIVNO.
            MESSAGE E786 WITH ZTIVIT-ZFIVDNO.
            W_ERR_CHK = 'Y'.
            EXIT.
         ELSE.
            IF NOT ( EKPO-LOEKZ IS INITIAL ).   " ���� ��?
*               NOT ( EKPO-ELIKZ IS INITIAL ).   " ��ǰ�Ϸ� ��?
               MESSAGE I787 WITH ZTIV-ZFIVNO.
               MESSAGE E788 WITH ZTIVIT-ZFIVDNO.
               W_ERR_CHK = 'Y'.
               EXIT.
            ENDIF.
*           IF EKPO-MWSKZ IS INITIAL.               " Tax Code
*              MESSAGE I787 WITH ZTIV-ZFIVNO.
*              MESSAGE E796 WITH ZTIVIT-ZFIVDNO.
*              W_ERR_CHK = 'Y'.
*              EXIT.
*           ENDIF.
        ENDIF.
  ENDSELECT.
*
  IF SY-SUBRC NE 0.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     MESSAGE E789.
     W_ERR_CHK = 'Y'.
     EXIT.
  ENDIF.

* IF ZTIV-ZFMAVN IS INITIAL.                              " Vendor
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E136.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.

*  IF ZTIV-ZFIVAMP IS INITIAL. " ó����?
*     MESSAGE I787 WITH ZTIV-ZFIVNO.
*     MESSAGE E791.
*     W_ERR_CHK = 'Y'.
*     EXIT.
*  ENDIF.

* SELECT SUM( ZFIVAMP ) INTO W_ZFIVAMP
*   FROM ZTIVIT
*  WHERE ZFIVNO = ZTIV-ZFIVNO.
* ADD ZTIV-ZFHDCHGP TO W_ZFIVAMP.
* ADD ZTIV-ZFPKCHGP TO W_ZFIVAMP.
* IF W_ZFIVAMP NE ZTIV-ZFIVAMP.
*    MESSAGE I787 WITH ZTIV-ZFIVNO.
*    MESSAGE E795.
*    W_ERR_CHK = 'Y'.
*    EXIT.
* ENDIF.

* Non-GR ����� ����� ����� I/V��?
ENDFORM.                                  " P4000_IV_VALID_CHECK
*&---------------------------------------------------------------------*
*&      Form  P4000_IV_BDC
*&---------------------------------------------------------------------*
FORM P4000_IV_BDC.

  CLEAR SY-SUBRC.
* IF ZTIV-ZFIVAMP > 0.
*    CASE ZTIMIMG11-ZFIVTY.
*         WHEN 'C'.                            " CIV
*               PERFORM P4000_CIV_BDC_INSERT.
*               CALL TRANSACTION 'MRHR'
*                    USING       ZBDCDATA
*                    MODE        DISPMODE
*                    UPDATE      UMODE.
*         WHEN 'L'.                            " LIV
*               PERFORM P4000_LIV_BDC_INSERT.
*               CALL TRANSACTION 'MIRO'
*                    USING       ZBDCDATA
*                    MODE        DISPMODE
*                    UPDATE      UMODE.
*         WHEN  OTHERS.
*               MESSAGE I787 WITH ZTIV-ZFIVNO.
*               W_ERR_CHK = 'Y'.
*               EXIT.
*    ENDCASE.
* ENDIF.

  IF SY-SUBRC <> 0.
     MESSAGE I787 WITH ZTIV-ZFIVNO.
     W_ERR_CHK = 'Y'.
     EXIT.
  ELSE.
*    CLEAR : ZFGFDNO, ZFGFDYR.
*     CASE ZTIMIMG11-ZFIVTY.
*          WHEN 'C'.                            " CIV
**               WHILE ZFGFDNO IS INITIAL AND ZFGFDYR IS INITIAL.
**                 GET PARAMETER ID 'BLN' FIELD ZFGFDNO. " ��ǥ��ȣ.
**                 GET PARAMETER ID 'GJR' FIELD ZFGFDYR. " ȸ��⵵.
**               ENDWHILE.
*          WHEN 'L'.                            " LIV
**               WHILE ZFGFDNO IS INITIAL AND ZFGFDYR IS INITIAL.
**                 GET PARAMETER ID 'RBN' FIELD ZFGFDNO. " ���幮����ȣ.
**                 GET PARAMETER ID 'GJR' FIELD ZFGFDYR. " ȸ��⵵.
**               ENDWHILE.
*          WHEN  OTHERS.
*                MESSAGE I787 WITH ZTIV-ZFIVNO.
*                W_ERR_CHK = 'Y'.
*                EXIT.
*     ENDCASE.
*    ZTIV-ZFIVST  = 'Y'.            " Invoice Verify ����.

     CLEAR W_WEPOS.
     SELECT MAX( WEPOS ) INTO W_WEPOS
       FROM EKPO
      WHERE EBELN = ZTREQHD-EBELN.
     IF W_WEPOS IS INITIAL. " Non-GR ��?
        ZTIV-ZFGRST = 'Y'.
     ENDIF.
*    IF ZTIV-ZFPRPYN = 'Y'. " ���ޱ�.
*       ZTIV-ZFGRST = 'Y'.
*       ZTIV-ZFCIVST = 'Y'.
*       IF ZTIV-ZFPRTE = 100. " �����۱�.
*          PERFORM P2000_PAYMENT_NOTICE_INSERT USING W_ERR_CHK.
*          IF W_ERR_CHK = 'Y'.
*             MESSAGE E893.
*             EXIT.
*          ENDIF.
*       ENDIF.
*    ENDIF.

*    CLEAR : ZTIV-ZFGFDNO, ZTIV-ZFGFDYR.
*    IF ZTIV-ZFIVAMP > 0.
*       ZTIV-ZFGFDNO = ZFGFDNO.        " ��ǥ��ȣ.
*       ZTIV-ZFGFDYR = ZFGFDYR.        " ȸ��⵵.
*       ZTIV-ZFIVPDT = W_ZFIVPDT.      " Posting Date
*       ZTIV-ZFIVDDT = W_ZFIVDDT.      " Document Date
*    ENDIF.
     ZTIV-UNAM    = SY-UNAME.
     ZTIV-UDAT    = SY-DATUM.
     UPDATE ZTIV.
  ENDIF.

ENDFORM.                    " P4000_IV_BDC
*&---------------------------------------------------------------------*
*&      Form  P4000_GET_IV_INIVAL
*&---------------------------------------------------------------------*
FORM P4000_GET_IV_INIVAL.

  MOVE 'Initial Value' TO SPOP-TITEL.
*  MOVE 'X'            TO RADIO_NONE.
* IF W_ZFIVPDT IS INITIAL.
*    MOVE SY-DATUM    TO W_ZFIVPDT.
* ENDIF.

  CALL SCREEN 0010 STARTING AT 15 1
                   ENDING   AT 56 13.

  IF RADIO_NONE = 'X'.
     DISPMODE = 'N'.
  ENDIF.
  IF RADIO_ALL = 'X'.
     DISPMODE = 'A'.
  ENDIF.
  IF RADIO_ERROR = 'X'.
     DISPMODE = 'E'.
  ENDIF.

ENDFORM.                    " P4000_GET_iv_inival
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
MODULE SET_STATUS_SCR0010 OUTPUT.

   SET TITLEBAR 'POPU' WITH SPOP-TITEL.
   SET PF-STATUS 'POPU'.

ENDMODULE.                 " SET_STATUS_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_OK_CODE_SCR0010  INPUT
*&---------------------------------------------------------------------*
MODULE GET_OK_CODE_SCR0010 INPUT.

  IF OK-CODE NE 'YES'.
     SET SCREEN 0.
     LEAVE SCREEN.
  ENDIF.

* IF W_ZFIVPDT IS INITIAL.
*    MOVE SY-DATUM    TO W_ZFIVPDT.
* ENDIF.
  SET SCREEN 0.   LEAVE SCREEN.

ENDMODULE.                 " GET_OK_CODE_SCR0010  INPUT
*&---------------------------------------------------------------------*
*&      Form  A_ZBDCDATA
*&---------------------------------------------------------------------*
FORM A_ZBDCDATA USING BEGIN_CHECK OBJNAM VALUE.

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
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFIVNO.

  SELECT SINGLE *
    FROM ZTIV
   WHERE ZFIVNO = P_ZFIVNO.
* SET PARAMETER ID 'ZPREQNO' FIELD ZTIV-ZFREQNO.
  SET PARAMETER ID 'ZPOPNNO' FIELD ''.
  SET PARAMETER ID 'BES'     FIELD ''.

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
  SET PARAMETER ID 'ZPHBLNO' FIELD ZTIV-ZFBLNO.

  EXPORT 'ZPBLNO'        TO MEMORY ID 'ZPBLNO'.

ENDFORM.                    " P2000_SHOW_BL
*&---------------------------------------------------------------------*
*&      Form  P3000_DOCUMENT_TYPE
*&---------------------------------------------------------------------*
FORM P3000_DOCUMENT_TYPE.

  CLEAR TEMP_BLART.
  IF ZTREQHD-ZFJEWGB NE '1'.  " Ÿ����?
     MOVE 'RF' TO TEMP_BLART.
     EXIT.
  ENDIF.
* IF ZTREQHD-ZTERM = ZTIMIMG11-ZTERM3  OR  " ���ļ�?
*    ZTREQHD-ZFREQTY = 'DA'  OR  " D/A
*    ZTREQHD-ZFREQTY = 'DP'.     " D/P
*    MOVE 'RG' TO TEMP_BLART.
*    EXIT.
* ENDIF.
  IF ZTREQHD-ZTERM = 'LC' . " At Sight
     MOVE 'RG' TO TEMP_BLART.
     EXIT.
  ENDIF.
  MOVE 'RH' TO TEMP_BLART.

ENDFORM.                    " P3000_DOCUMENT_TYPE

*&---------------------------------------------------------------------*
*&      Form  P2000_PAYMENT_NOTICE_INSERT
*&---------------------------------------------------------------------*
FORM P2000_PAYMENT_NOTICE_INSERT USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.
  CLEAR : ZTPMTHD.

  MOVE ZTREQHD-ZFREQNO TO ZTPMTHD-ZFREQNO. " �����Ƿ� ������?
  MOVE ZTREQHD-EBELN   TO ZTPMTHD-EBELN. " P/O No
  MOVE ZTREQHD-ZTERM   TO ZTPMTHD-ZTERM. " Payment Term

  CLEAR ZTIMIMG01.
  SELECT SINGLE *
    FROM ZTIMIMG01
   WHERE ZTERM = ZTPMTHD-ZTERM.
  IF SY-SUBRC = 0.
    MOVE ZTIMIMG01-ZFLCKN TO ZTPMTHD-ZFLCKN. " L/C Type
  ELSE.
    MOVE '9'              TO ZTPMTHD-ZFLCKN. " L/C Type
  ENDIF.
  MOVE ZTREQHD-ZFJEWGB TO ZTPMTHD-ZFJEWGB. " �����?
  MOVE '5' TO ZTPMTHD-ZFTRTY.
  IF ZTREQHD-ZFMATGB = '1' OR
     ZTREQHD-ZFMATGB = '3' OR
     ZTREQHD-ZFMATGB = '5'.
    MOVE '1' TO ZTPMTHD-ZFTRTY.
  ENDIF.
  IF ZTREQHD-ZFMATGB = '4'.
    MOVE '2' TO ZTPMTHD-ZFTRTY.
  ENDIF.
* IF ZTREQHD-ZTERM = ZTIMIMG11-ZTERM4.
*   MOVE '3' TO ZTPMTHD-ZFTRTY.
* ENDIF.
* IF ZTREQHD-ZTERM = ZTIMIMG11-ZTERM3.
*   MOVE '4' TO ZTPMTHD-ZFTRTY.
* ENDIF.

  MOVE ZTREQHD-ZFBENI  TO ZTPMTHD-ZFBENI. " Benificiary
  MOVE ZTREQHD-ZFOPBN  TO ZTPMTHD-ZFPNBN. " ������?
  MOVE ZTREQHD-ZFOPBN  TO ZTPMTHD-ZFOPBN. " ������?
  SELECT MAX( BANKL )  INTO ZTPMTHD-ZFOPBNK
    FROM LFBK
   WHERE LIFNR = ZTPMTHD-ZFOPBN.
  MOVE ZTPMTHD-ZFOPBNK TO ZTPMTHD-ZFPNBNK. " ������?

  SELECT MAX( ZFPNNO ) INTO ZTPMTHD-ZFPNNO      " ������?
    FROM ZTPMTHD.
  ADD   1               TO ZTPMTHD-ZFPNNO.
  MOVE 'N'              TO ZTPMTHD-ZFBKCHT.
  MOVE 'N'              TO ZTPMTHD-ZFBKCHA.
  MOVE 'C'              TO ZTPMTHD-ZFPYST.
  MOVE 'N'              TO ZTPMTHD-ZFPYT.
  MOVE 'N'              TO ZTPMTHD-ZFPYL.
  MOVE 'N'              TO ZTPMTHD-ZFPYA.
  MOVE SY-UNAME         TO ZTPMTHD-UNAM.
  MOVE SY-DATUM         TO ZTPMTHD-UDAT.
  MOVE SY-UNAME         TO ZTPMTHD-ERNAM.
  MOVE SY-DATUM         TO ZTPMTHD-CDAT.
* MOVE ZTIV-ZFIVAMP     TO ZTPMTHD-ZFPNAM.                  "Notice Amt
* MOVE ZTIV-ZFIVAMP     TO ZTPMTHD-ZFTIVAM. "Invoice Amt
  MOVE ZTIV-ZFIVAMC     TO ZTPMTHD-ZFPNAMC. "Notice Amt Curr
  CLEAR W_ZFAMDNO.
  SELECT MAX( ZFAMDNO ) INTO W_ZFAMDNO
    FROM ZTREQST
   WHERE ZFREQNO = ZTREQHD-ZFREQNO.
  CLEAR ZTREQST.
  SELECT SINGLE *
    FROM ZTREQST
   WHERE ZFREQNO = ZTREQHD-ZFREQNO
     AND ZFAMDNO = W_ZFAMDNO.
  MOVE ZTREQST-ZFOPNDT  TO ZTPMTHD-ZFNTDT. "����?
  MOVE ZTREQST-ZFOPNDT  TO ZTPMTHD-ZFPWDT. "����?

  INSERT ZTPMTHD.
  IF SY-SUBRC NE 0.
    MOVE 'Y' TO W_ERR_CHK.
    EXIT.
  ENDIF.

  MOVE  ZTIV-ZFIVNO     TO ZTPMTIV-ZFIVNO.  "������?
* MOVE  ZTIV-ZFCIVNO    TO ZTPMTIV-ZFCIVNO. "Commercial I/V NO
* MOVE  ZTIV-ZFIVAMP    TO ZTPMTIV-ZFIVAMT. "Invoice Amt
* MOVE  ZTIV-ZFIVAMP    TO ZTPMTIV-ZFPBAMT. "Payable Amt
* MOVE  ZTIV-ZFIVAMP    TO ZTPMTIV-ZFPNAM.  "Notice Amt
* MOVE  ZTIV-ZFIVAMC    TO ZTPMTIV-ZFIVAMC. "Invoice Amt Curr
  MOVE 'N'              TO ZTPMTIV-ZFPPYYN. "Partial Payment
  MOVE  ZTPMTHD-ZFPNNO  TO ZTPMTIV-ZFPNNO.
  MOVE  10              TO ZTPMTIV-ZFPNIT.
  INSERT   ZTPMTIV.
  IF SY-SUBRC NE 0.
    MOVE 'Y' TO W_ERR_CHK.
    EXIT.
  ENDIF.

ENDFORM.                    " P2000_PAYMENT_NOTICE_INSERT
*&---------------------------------------------------------------------*
*&      Form  P4000_CIV_BDC_INSERT
*&---------------------------------------------------------------------*
FORM P4000_CIV_BDC_INSERT.

  REFRESH ZBDCDATA.
  CLEAR  W_ZFIVDNO.
  SELECT MIN( ZFIVDNO ) INTO W_ZFIVDNO
    FROM ZTIVIT
   WHERE ZFIVNO  = ZTIV-ZFIVNO.
  SELECT SINGLE *
    FROM ZTIVIT
   WHERE ZFIVNO  = ZTIV-ZFIVNO
     AND ZFIVDNO = W_ZFIVDNO.

  PERFORM P3000_DOCUMENT_TYPE.
* MOVE ZTIV-ZFCIVNO         TO TEMP_XBLNR.
  CONCATENATE ZTREQHD-ZFOPNNO '/' ZTREQHD-ZFJEWGB INTO TEMP_BKTXT.
  PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0100'.
  PERFORM A_ZBDCDATA USING :
*     ' ' 'BKPF-BLDAT' W_ZFIVDDT,            " Document Date
*     ' ' 'BKPF-BLART' TEMP_BLART,           " Document Type
*      ' ' 'BKPF-BUKRS' '1000',               " Company Code
      ' ' 'BKPF-BUKRS' ZTREQHD-BUKRS,        " Company Code
*     ' ' 'BKPF-BUDAT' W_ZFIVPDT,            " Posting Date
      ' ' 'BKPF-WAERS' ZTIV-ZFIVAMC,         " Currency
      ' ' 'BKPF-XBLNR' TEMP_XBLNR,           " Reference
      ' ' 'BKPF-BKTXT' TEMP_BKTXT,           " Reference Header Text
      ' ' 'RM08R-EBELN' ZTREQHD-EBELN,       " Purchase Order
*     ' ' 'RM08R-EBELP' W_ZFIVDNO,           " Purchase Order Item
*     ' ' 'RM08R-KONTO' ZTIV-ZFMAVN,         " Vendor
      ' ' 'BDC_OKCODE' '/00'.                " ENTER

* WRITE ZTIV-ZFIVAMP CURRENCY ZTIV-ZFIVAMC TO TEMP_WRBTR.
  PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '2110'.
  PERFORM A_ZBDCDATA USING :
      ' ' 'BSEG-WRBTR' TEMP_WRBTR,           " ��ü �ݾ�.
*     ' ' 'BSEG-ZFBDT'           ,           " Baseline Date
      ' ' 'BSEG-ZLSPR' 'R',                  " Payment Block
      ' ' 'BSEG-SGTXT' ZTBL-ZFHBLNO,         " Text
      ' ' 'BDC_OKCODE' '/00'.                " ENTER

  PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0150'.
* ����������.
  CONCATENATE 'EK08R-SELKZ' '(01)' INTO TEMP_FNAM.
  PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM 'X'.
* �ݾ�.
  CONCATENATE 'EK08R-WRBTR' '(01)' INTO TEMP_FNAM.
* WRITE ZTIVIT-ZFIVAMP CURRENCY ZTIVIT-ZFIVAMC TO TEMP_WRBTR.
  PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM TEMP_WRBTR.
* ����.
  CONCATENATE 'EK08R-MENGE' '(01)' INTO TEMP_FNAM.
* WRITE ZTIVIT-ZFPRQN UNIT ZTIVIT-MEINS TO TEMP_MENGE.
  PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM TEMP_MENGE.

  SELECT *
    FROM ZTIVIT
   WHERE ZFIVNO  = ZTIV-ZFIVNO
     AND ZFIVDNO NE W_ZFIVDNO.

    PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' '=ESEL'.
    PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0200'.
    PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' '=NBES'.
    PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0505'.
    PERFORM A_ZBDCDATA USING :
      ' ' 'RM08R-EBELN' ZTREQHD-EBELN,       " Purchase Order
      ' ' 'RM08R-EBELP' ZTIVIT-ZFIVDNO,      " Purchase Order Item
      ' ' 'BDC_OKCODE' '/00'.                " ENTER
    PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0150'.
* ����������.
    CONCATENATE 'EK08R-SELKZ' '(01)' INTO TEMP_FNAM.
    PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM 'X'.
* �ݾ�.
    CONCATENATE 'EK08R-WRBTR' '(01)' INTO TEMP_FNAM.
*   WRITE ZTIVIT-ZFIVAMP CURRENCY ZTIVIT-ZFIVAMC TO TEMP_WRBTR.
    PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM TEMP_WRBTR.
* ����.
    CONCATENATE 'EK08R-MENGE' '(01)' INTO TEMP_FNAM.
*   WRITE ZTIVIT-ZFPRQN UNIT ZTIVIT-MEINS TO TEMP_MENGE.
    PERFORM A_ZBDCDATA USING ' ' TEMP_FNAM TEMP_MENGE.
  ENDSELECT.
* ����.
  PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' '=ESEL'.
  PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0200'.
* W_ZFIVAMT = ZTIV-ZFPKCHGP + ZTIV-ZFHDCHGP.
  IF W_ZFIVAMT > 0.
    PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' '=BNEI'.
    PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '1800'.
    WRITE W_ZFIVAMT CURRENCY ZTIV-ZFIVAMC TO TEMP_WRBTR.
    PERFORM A_ZBDCDATA USING :
            ' ' 'RM08R-BEZNK' TEMP_WRBTR,           " Unplanned Cost
            ' ' 'BDC_OKCODE' '=OK'.                         " ENTER
    PERFORM A_ZBDCDATA USING 'X' 'SAPMM08R' '0200'.
  ENDIF.
  PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' 'BU'.


ENDFORM.                    " P4000_CIV_BDC_INSERT

*&---------------------------------------------------------------------*
*&      Form  P4000_LIV_BDC_INSERT
*&---------------------------------------------------------------------*
FORM P4000_LIV_BDC_INSERT.
DATA : L_BUKRS   LIKE   BKPF-BUKRS.

  REFRESH ZBDCDATA.

  PERFORM P3000_DOCUMENT_TYPE.

* WRITE ZTIV-ZFIVAMP CURRENCY ZTIV-ZFIVAMC TO TEMP_WRBTR.
*>> COMPANY CODE.
  GET PARAMETER ID 'BUK' FIELD L_BUKRS.
  IF L_BUKRS IS INITIAL.
     PERFORM A_ZBDCDATA USING 'X' 'SAPLACHD' '1000'.
     PERFORM A_ZBDCDATA USING :
         ' ' 'BKPF-BUKRS' ZTREQHD-BUKRS,        " Company Code.
         ' ' 'BDC_OKCODE' '/00'.                " ENTER
  ENDIF.

* �⺻����Ÿ.
  PERFORM A_ZBDCDATA USING 'X' 'SAPLMR1M' '6000'.
  PERFORM A_ZBDCDATA USING :
      ' ' 'RM08M-VORGANG' '1',               " Sub DB/CR
*     ' ' 'INVFO-BLDAT' W_ZFIVDDT,           " Document Date
*     ' ' 'INVFO-BUDAT' W_ZFIVPDT,           " Posting Date
      ' ' 'INVFO-WRBTR' TEMP_WRBTR,          " �ݾ�.
      ' ' 'INVFO-WAERS' ZTIV-ZFIVAMC,        " Currency
      ' ' 'BDC_OKCODE' '=HEADER_PAY'.
* ����.
  PERFORM A_ZBDCDATA USING 'X' 'SAPLMR1M' '6000'.
  PERFORM A_ZBDCDATA USING :
      ' ' 'INVFO-ZLSPR' 'R',                 " Payment Block
      ' ' 'BDC_OKCODE' 'HEADER_FI'.          " ���λ���.
* ���λ���.
  PERFORM A_ZBDCDATA USING 'X' 'SAPLMR1M' '6000'.
  CONCATENATE ZTREQHD-ZFOPNNO '/' ZTREQHD-ZFJEWGB INTO TEMP_BKTXT.
* W_ZFIVAMT = ZTIV-ZFPKCHGP + ZTIV-ZFHDCHGP.
  IF W_ZFIVAMT > 0.
    WRITE W_ZFIVAMT CURRENCY ZTIV-ZFIVAMC TO TEMP_WRBTR.
    PERFORM A_ZBDCDATA USING :
            ' ' 'RM08R-BEZNK' TEMP_WRBTR.    " Unplanned Cost
  ENDIF.

*  IF ZTIV-ZFIVAMC NE 'KRW'.
*     MOVE ZTIV-ZFEXRT       TO TEMP_KURSF.
*     PERFORM A_ZBDCDATA USING :
*        ' ' 'INVFO-KURSF' TEMP_KURSF.        " Exchange Rate
*  ENDIF.
  PERFORM A_ZBDCDATA USING :
*     ' ' 'INVFO-LIFRE' ZTIV-ZFMAVN,         " Vendor
      ' ' 'INVFO-BKTXT' TEMP_BKTXT,          " Reference Header Text
      ' ' 'RM08M-EBELN' ZTREQHD-EBELN,       " Purchase Order
      ' ' 'BDC_OKCODE' '/00'.                " ENTER
* Text, Reference,

  CLEAR LOOP_CNT.
  PERFORM A_ZBDCDATA USING 'X' 'SAPLMR1M' '6000'.
  SELECT *
    FROM EKPO
   WHERE EBELN = ZTREQHD-EBELN
     AND LOEKZ = '' "����������.
   ORDER BY EBELP.
*    and elikz = ''. "��ǰ�Ϸ�������.
     ADD 1 TO LOOP_CNT.

     SELECT SINGLE *
       FROM ZTIVIT
      WHERE ZFIVNO  = ZTIV-ZFIVNO
        AND ZFIVDNO = EKPO-EBELP.

     IF SY-SUBRC = 0.
        PERFORM A_ZBDCDATA USING :
            ' ' 'RM08M-SKIP_TO' LOOP_CNT,          " Skip-To
            ' ' 'BDC_OKCODE' '=POS'.               " Position
        PERFORM A_ZBDCDATA USING 'X' 'SAPLMR1M' '6000'.
* �ݾ�.
        CONCATENATE 'DRSEG-WRBTR' '(1)' INTO TEMP_FNAM.
*       WRITE ZTIVIT-ZFIVAMP CURRENCY ZTIVIT-ZFIVAMC TO TEMP_WRBTR.
        PERFORM A_ZBDCDATA USING ' '    TEMP_FNAM TEMP_WRBTR.
* ����.
        CONCATENATE 'DRSEG-MENGE' '(1)' INTO TEMP_FNAM.
*       WRITE ZTIVIT-ZFPRQN UNIT ZTIVIT-MEINS TO TEMP_MENGE.
        PERFORM A_ZBDCDATA USING ' '    TEMP_FNAM TEMP_MENGE.
* ����������.
        CONCATENATE 'DRSEG-OK' '(1)'   INTO TEMP_FNAM.
        PERFORM A_ZBDCDATA USING ' '   TEMP_FNAM 'X'.
     ENDIF.
  ENDSELECT.
  PERFORM A_ZBDCDATA USING ' ' 'BDC_OKCODE' 'BU'.

ENDFORM.                    " P4000_LIV_BDC_INSERT
