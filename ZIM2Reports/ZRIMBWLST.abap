*&---------------------------------------------------------------------*
*& Report  ZRIMBWLST                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����â�������ȸ                                      *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.08.25                                            *
*$     ����ȸ��: LG ȭ��
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��] 2001.01.31 �迵��
*&            : �������� , SORT �� EXCEL ȭ����� �߰�
*&---------------------------------------------------------------------*
REPORT  ZRIMBWLST   MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE   ZRIMBWLSTTOP.
INCLUDE   ZRIMUTIL01.     " Utility function ����.
INCLUDE   ZRIMOLECOM.     " OLE ������.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: S_BUKRS     FOR ZTBWHD-BUKRS NO-EXTENSION
                                            NO INTERVALS,
                S_EBELN FOR ZTBWHD-ZFREBELN,
                S_BNARCD FOR ZTBWHD-ZFBNARCD, " ��������.
                S_HBLNO FOR ZTBL-ZFHBLNO,
                S_BLNO  FOR ZTBWHD-ZFBLNO,
                S_IVNO  FOR ZTBWHD-ZFIVNO,
                S_GISEQ FOR ZTBWHD-ZFGISEQ,
                S_SHNO  FOR ZTBWHD-ZFSHNO,    " ��������.
                S_TRCO  FOR ZTBWHD-ZFTRCO,    " ��۾�ü.
                S_SEND  FOR ZTBWHD-ZFSENDER,  " �߼��ڸ�.
                S_GIDT  FOR ZTBWHD-ZFGIDT,    " �������.
                S_IDSDT FOR ZTBWHD-ZFIDSDT.   " �Ű�����.

SELECTION-SCREEN END OF BLOCK B1.
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

* ���� ���� �Լ�.
*   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
*   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*  ���̺� SELECT
  PERFORM   P1000_GET_ZTBW      USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'. MESSAGE S738.   EXIT.    ENDIF.
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE       USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.  EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
  CASE SY-UCOMM.
    WHEN 'MKAL' OR 'MKLO'.          " ��ü ���� �� ��������.
      PERFORM P2000_SELECT_RECORD USING   SY-UCOMM.

    WHEN 'DISP'.                     " ����â�����.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM  P2000_DISP_ZTBWHD USING IT_SELECTED-ZFIVNO
                                         IT_SELECTED-ZFGISEQ.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.

    WHEN 'DISP1'.                       " B/L ��ȸ.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_DISP_ZTBL(SAPMZIM09) USING IT_SELECTED-ZFBLNO.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.

    WHEN 'DISP2'.                     " �����û.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_DISP_ZTIV(SAPMZIM09) USING IT_SELECTED-ZFIVNO.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.
    WHEN 'DISP3'.                     " ���ԽŰ�.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_DISP_ZTIDR(SAPMZIM09) USING IT_SELECTED-ZFBLNO
                                             IT_SELECTED-ZFCLSEQ.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.
    WHEN 'DISP4'.                     " ���Ը���.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_DISP_ZTIDS(SAPMZIM09) USING IT_SELECTED-ZFBLNO
                                            IT_SELECTED-ZFCLSEQ.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.
    WHEN 'BWPRT'.                     " �������۸���.
      PERFORM P2000_MULTI_SELECTION.
      IF W_SELECTED_LINES EQ 1.
        READ TABLE IT_SELECTED INDEX 1.
        PERFORM P2000_PRINT_ZTBW(SAPMZIM09) USING IT_SELECTED-ZFIVNO
                                            IT_SELECTED-ZFGISEQ.
      ELSEIF W_SELECTED_LINES GT 1.
        MESSAGE E965.
      ENDIF.

    WHEN 'STUP' OR 'STDN'.
*            W_FIELD_NM = 'ZFETA'.
      GET CURSOR FIELD W_FIELD_NM.
*           ASSIGN W_FIELD_NM   TO <SORT_FIELD>.

      PERFORM SORT_DATA  USING   SY-UCOMM.

    WHEN 'EXCEL'.
      PERFORM P3000_EXCEL_DOWNLOAD.

    WHEN 'REFR'.
*          ���̺� SELECT
      PERFORM   P1000_GET_ZTBW       USING   W_ERR_CHK.
      IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
      PERFORM RESET_LIST.
    WHEN OTHERS.
  ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIMR61'.          " TITLE BAR

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

  IF SY-LANGU EQ '3'.
    WRITE : /50 '[ ����â�������Ȳ ]'
                 COLOR COL_HEADING INTENSIFIED OFF.
    WRITE : /3 'Date : ', SY-DATUM.
    WRITE : / SY-ULINE.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE : / SY-VLINE, ' ' ,
              SY-VLINE, (13) '�÷�Ʈ' NO-GAP,
              SY-VLINE,(15) 'P/O No' NO-GAP,
*            SY-VLINE,(10)  '�����û No' NO-GAP,
*            SY-VLINE,(06) 'Seq' NO-GAP,
              SY-VLINE,(20) '��۾�ü' NO-GAP,
              SY-VLINE,(13) '�߼��ڸ�' NO-GAP,
              SY-VLINE,(16) '������' NO-GAP,
              SY-VLINE,(12) '�����' NO-GAP,
              SY-VLINE,(12) '�����' NO-GAP,
              SY-VLINE.

    FORMAT COLOR COL_HEADING INTENSIFIED OFF.
    WRITE :/  SY-VLINE, ' ' ,
              SY-VLINE,(30) 'House B/L No' NO-GAP,
*            SY-VLINE,(06) 'No' NO-GAP,
              SY-VLINE,(20) '������' NO-GAP,
              SY-VLINE,(12) '�ܰ�',
              SY-VLINE,(16) '�����ȣ' NO-GAP,
              SY-VLINE,(26) '����' NO-GAP,
              SY-VLINE.
  ELSEIF SY-LANGU EQ 'E'.
    WRITE : /50 '[ Bonded warehouse G/I status ]'
                  COLOR COL_HEADING INTENSIFIED OFF.
    WRITE : /3 'Date : ', SY-DATUM.
    WRITE : / SY-ULINE.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE : / SY-VLINE, ' ' ,
              SY-VLINE, (13) 'Plant' NO-GAP,
              SY-VLINE,(15) 'P/O No' NO-GAP,
*            SY-VLINE,(10)  '�����û No' NO-GAP,
*            SY-VLINE,(06) 'Seq' NO-GAP,
              SY-VLINE,(20) 'Transportation agent' NO-GAP,
              SY-VLINE,(13) 'Sender' NO-GAP,
              SY-VLINE,(16) 'Driver' NO-GAP,
              SY-VLINE,(12) 'Clearance date' NO-GAP,
              SY-VLINE,(12) 'G/I date' NO-GAP,
              SY-VLINE.

    FORMAT COLOR COL_HEADING INTENSIFIED OFF.
    WRITE :/  SY-VLINE, ' ' ,
              SY-VLINE,(30) 'House B/L No' NO-GAP,
*            SY-VLINE,(06) 'No' NO-GAP,
              SY-VLINE,(20) 'G/I quantity' NO-GAP,
              SY-VLINE,(12) 'Price unit',
              SY-VLINE,(16) 'Material No' NO-GAP,
              SY-VLINE,(26) 'Particulars' NO-GAP,
              SY-VLINE.
  ENDIF.

  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
  AUTHORITY-CHECK OBJECT 'ZI_LC_REL'
           ID 'ACTVT' FIELD '*'.

  IF SY-SUBRC NE 0.
    MESSAGE S960 WITH SY-UNAME 'Request Release Transaction'.
    W_ERR_CHK = 'Y'.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTBW
*&---------------------------------------------------------------------*
FORM P1000_GET_ZTBW   USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.
  REFRESH IT_BWHD.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_BWHD
     FROM ZTBWHD   AS R INNER JOIN ZTBL AS I
               ON  R~ZFBLNO = I~ZFBLNO
     WHERE R~ZFREBELN IN S_EBELN
       AND R~BUKRS    IN S_BUKRS
       AND R~ZFBNARCD IN S_BNARCD
       AND R~ZFBLNO   IN S_BLNO
       AND I~ZFHBLNO  IN S_HBLNO
       AND R~ZFIVNO   IN S_IVNO
       AND R~ZFGISEQ  IN S_GISEQ
       AND R~ZFSHNO   IN S_SHNO   " ��������.
       AND R~ZFTRCO   IN S_TRCO   " ��۾�ü.
       AND R~ZFSENDER IN S_SEND   " �߼��ڸ�.
       AND R~ZFGIDT   IN S_GIDT   " �������.
       AND R~ZFIDSDT  IN S_IDSDT. " �Ű�����.
  IF SY-SUBRC NE 0.
    W_ERR_CHK = 'Y'. EXIT.
  ENDIF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_BWIT
           FROM ZTBWIT
           FOR ALL ENTRIES IN IT_BWHD
           WHERE ZFIVNO  = IT_BWHD-ZFIVNO
             AND ZFGISEQ = IT_BWHD-ZFGISEQ.
*>> MODIFY.
  PERFORM   P1000_GET_TEXT.

ENDFORM.                    " P1000_GET_ZTBW.
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

  SET PF-STATUS 'ZIMR61'.           " GUI STATUS SETTING
  SET  TITLEBAR 'ZIMR61'.           " GUI TITLE SETTING..

  W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

  LOOP AT IT_BWHD.
    W_LINE = W_LINE + 1.
*     PERFORM P2000_PAGE_CHECK.
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

  IF SY-LANGU EQ '3'.
    IF W_COUNT GT 0.
      WRITE : / '��', W_COUNT, '��'.
    ENDIF.
  ELSEIF SY-LANGU EQ 'E'.
    IF W_COUNT GT 0.
      WRITE : / 'Total', W_COUNT, 'Case'.
    ENDIF.
  ENDIF.

  ENDFORM.                    " P3000_LAST_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE : / SY-VLINE, MARKFIELD  AS CHECKBOX,
            SY-VLINE,(13) IT_BWHD-WERKS    NO-GAP,
            SY-VLINE,(15) IT_BWHD-W_EBELN  NO-GAP,
*             SY-VLINE,(10) IT_BWHD-ZFIVNO   NO-GAP,
*             SY-VLINE,(06) IT_BWHD-ZFGISEQ  NO-GAP,
            SY-VLINE,(20) IT_BWHD-NAME1    NO-GAP,
            SY-VLINE,(13) IT_BWHD-ZFSENDER NO-GAP,
            SY-VLINE,(16) IT_BWHD-ZFDRVNM  NO-GAP,
            SY-VLINE,(12) IT_BWHD-ZFIDSDT  NO-GAP,
            SY-VLINE,(12) IT_BWHD-ZFGIDT   NO-GAP,
            SY-VLINE.
* hide
  HIDE: IT_BWHD.
  W_COUNT = W_COUNT + 1.
  PERFORM P2000_IT_LINE_WRITE.
  WRITE :/  SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IDS
*&---------------------------------------------------------------------*
FORM P2000_SHOW_IDS USING    P_ZFBLNO P_ZFCLSEQ.

  SET PARAMETER ID 'ZPBLNO'    FIELD  P_ZFBLNO.
  SET PARAMETER ID 'ZPCLSEQ'   FIELD  P_ZFCLSEQ.
  SET PARAMETER ID 'ZPHBLNO'    FIELD ''.
  SET PARAMETER ID 'ZPIDRNO'   FIELD ''.

  CALL TRANSACTION 'ZIM76' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_IDS

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_TEXT
*&---------------------------------------------------------------------*
FORM P1000_GET_TEXT.

  LOOP AT IT_BWHD.
    W_TABIX = SY-TABIX.
    CLEAR LFA1.
    SELECT SINGLE *
           FROM LFA1
          WHERE LIFNR = IT_BWHD-ZFTRCO.
    MOVE LFA1-NAME1 TO IT_BWHD-NAME1.
    IF NOT IT_BWHD-ZFSHNO IS INITIAL.
      CONCATENATE IT_BWHD-ZFREBELN '-' IT_BWHD-ZFSHNO
                  INTO IT_BWHD-W_EBELN.
    ELSE.
      MOVE  IT_BWHD-ZFREBELN  TO  IT_BWHD-W_EBELN.
    ENDIF.

    MODIFY  IT_BWHD INDEX W_TABIX.

  ENDLOOP.

ENDFORM.                    " P1000_GET_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_IT_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P2000_IT_LINE_WRITE.
  W_FIRST_CHECK = 0.
  LOOP AT IT_BWIT WHERE ZFIVNO  = IT_BWHD-ZFIVNO
                   AND ZFGISEQ  = IT_BWHD-ZFGISEQ.
    ADD 1 TO W_FIRST_CHECK.
    W_TABIX = SY-TABIX.
    PERFORM  P3000_IT_LINE_WRITE.
  ENDLOOP.

ENDFORM.                    " P2000_IT_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_IT_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_IT_LINE_WRITE.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

  IF W_FIRST_CHECK = 1.
    WRITE :/ SY-VLINE,'' ,
             SY-VLINE,(30) IT_BWHD-ZFHBLNO  NO-GAP.
  ELSE.
    WRITE :/ SY-VLINE,'' ,
              SY-VLINE,(30) ''  NO-GAP.
  ENDIF.

  WRITE:    " SY-VLINE,(06)IT_BWIT-ZFIVDNO NO-GAP,
            SY-VLINE,(03) IT_BWIT-MEINS,
                     (16) IT_BWIT-GIMENGE
                          UNIT IT_BWIT-MEINS NO-GAP, " ������
*            SY-VLINE,(13) IT_BWIT-PEINH
*                          UNIT IT_BWIT-BPRME NO-GAP, " ���ݴ���
            SY-VLINE, (13) IT_BWIT-NETPR
                           CURRENCY IT_BWHD-WAERS NO-GAP,
            SY-VLINE,(16) IT_BWIT-MATNR NO-GAP,      " �����ȣ'
            SY-VLINE,(26) IT_BWIT-TXZ01 NO-GAP,      " ����,
                                       SY-VLINE.

ENDFORM.                    " P3000_IT_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      MOVE : IT_BWHD-ZFIVNO  TO IT_SELECTED-ZFIVNO,
             IT_BWHD-ZFGISEQ TO IT_SELECTED-ZFGISEQ,
             IT_BWHD-ZFBLNO  TO IT_SELECTED-ZFBLNO,
             IT_BWHD-ZFCLSEQ  TO IT_SELECTED-ZFCLSEQ.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
    MESSAGE S951.
  ENDIF.


ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTBWHD
*&---------------------------------------------------------------------*
FORM P2000_DISP_ZTBWHD USING    P_ZFIVNO P_ZFGISEQ.

  SET PARAMETER ID 'ZPIVNO'  FIELD P_ZFIVNO.
  SET PARAMETER ID 'ZPGISEQ' FIELD P_ZFGISEQ.
  SET PARAMETER ID 'ZPHBLNO' FIELD ''.
  SET PARAMETER ID 'ZPBLNO'  FIELD ''.

  CALL TRANSACTION 'ZIMBG3'  AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_DISP_ZTBWHD
*&---------------------------------------------------------------------*
*&      Form  P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
FORM P2000_SELECT_RECORD USING    P_SY_UCOMM.

  DATA : WL_MARK.

  IF P_SY_UCOMM EQ 'MKAL'.
    WL_MARK = 'X'.
  ELSEIF P_SY_UCOMM EQ 'MKLO'.
    CLEAR : WL_MARK.
  ENDIF.
  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.    EXIT.   ENDIF.
    MODIFY CURRENT LINE FIELD VALUE MARKFIELD FROM WL_MARK.
  ENDDO.

ENDFORM.                    " P2000_SELECT_RECORD

*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM RESET_LIST.
*   MOVE 0 TO SY-LSIND.
*   PERFORM P3000_TITLE_WRITE.
*   PERFORM P3000_DATA_WRITE.
*ENDFORM.                    " RESET_LIST

*&---------------------------------------------------------------------*
*&      Form  P3000_EXCEL_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_EXCEL_DOWNLOAD.
  DATA : L_COL        TYPE I,
         L_ROW        TYPE I,
         L_WRBTR(20)  TYPE C,
         L_EBELN(12)  TYPE C.

  PERFORM P2000_EXCEL_INITIAL  USING  '����ü'
                                       10.

  PERFORM P2000_FIT_CELL    USING 1 6 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 1 '�÷�Ʈ'.
  PERFORM P2000_FIT_CELL    USING 2 12 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 2 'P/O No.'.
  PERFORM P2000_FIT_CELL    USING 3 25 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 3 'B/L No.'.
  PERFORM P2000_FIT_CELL    USING 4 20 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 4 '��۾�ü'.
  PERFORM P2000_FIT_CELL    USING 5 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 5 '�߼��ڸ�'.
  PERFORM P2000_FIT_CELL    USING 6 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 6 '������'.
  PERFORM P2000_FIT_CELL    USING 7 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 7 '�����'.
  PERFORM P2000_FIT_CELL    USING 8 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 8 '�����'.
  PERFORM P2000_FIT_CELL    USING 9 13 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 9 '���߷�'.
  PERFORM P2000_FIT_CELL    USING 10 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 10 '�߷�����'.
  PERFORM P2000_FIT_CELL    USING 11 13 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 11 '�ѿ���'.
  PERFORM P2000_FIT_CELL    USING 12 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 12 '��������'.

  LOOP AT IT_BWHD.
    CLEAR: L_EBELN.
    L_ROW = SY-TABIX + 1.

    CONCATENATE IT_BWHD-ZFREBELN '-' IT_BWHD-ZFSHNO
                 INTO L_EBELN.

    PERFORM P2000_FILL_CELL   USING L_ROW 1 IT_BWHD-WERKS.
    PERFORM P2000_FILL_CELL   USING L_ROW 2 L_EBELN.
    PERFORM P2000_FILL_CELL   USING L_ROW 3 IT_BWHD-ZFHBLNO.
    PERFORM P2000_FILL_CELL   USING L_ROW 4 IT_BWHD-NAME1.
    PERFORM P2000_FILL_CELL   USING L_ROW 5 IT_BWHD-ZFSENDER.
    PERFORM P2000_FILL_CELL   USING L_ROW 6 IT_BWHD-ZFDRVNM.
    PERFORM P2000_FILL_CELL   USING L_ROW 7 IT_BWHD-ZFIDSDT.
    PERFORM P2000_FILL_CELL   USING L_ROW 8 IT_BWHD-ZFGIDT.
    PERFORM P2000_FILL_CELL   USING L_ROW 9 IT_BWHD-ZFTOWT.
    PERFORM P2000_FILL_CELL   USING L_ROW 10 IT_BWHD-ZFTOWTM.
    PERFORM P2000_FILL_CELL   USING L_ROW 11 IT_BWHD-ZFTOVL.
    PERFORM P2000_FILL_CELL   USING L_ROW 12 IT_BWHD-ZFTOVLM.
  ENDLOOP.

  SET PROPERTY OF EXCEL 'VISIBLE' = 1.
ENDFORM.                    " P3000_EXCEL_DOWNLOAD

*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
FORM SORT_DATA USING    P_SY_UCOMM.
  CASE P_SY_UCOMM.
    WHEN 'STUP'.
      IF W_FIELD_NM EQ 'IT_BWHD-WERKS'.
        SORT IT_BWHD BY WERKS  ASCENDING.
      ENDIF.

      IF W_FIELD_NM EQ 'IT_BWHD-W_EBELN'.
        SORT IT_BWHD BY W_EBELN  ASCENDING.
      ENDIF.

      IF W_FIELD_NM EQ 'IT_BWHD-ZFHBLNO'.
        SORT IT_BWHD BY ZFHBLNO  ASCENDING.
      ENDIF.

    WHEN 'STDN'.
      IF W_FIELD_NM EQ 'IT_BWHD-WERKS'.
        SORT IT_BWHD BY WERKS  DESCENDING.
      ENDIF.

      IF W_FIELD_NM EQ 'IT_BWHD-W_EBELN'.
        SORT IT_BWHD BY W_EBELN  DESCENDING.
      ENDIF.

      IF W_FIELD_NM EQ 'IT_BWHD-ZFHBLNO'.
        SORT IT_BWHD BY ZFHBLNO  DESCENDING.
      ENDIF.
  ENDCASE.

  MOVE 0 TO SY-LSIND.
  PERFORM P3000_TITLE_WRITE.
  PERFORM P3000_DATA_WRITE USING W_ERR_CHK.

ENDFORM.                    " SORT_DATA
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
