*&---------------------------------------------------------------------*
*& Report  ZRIMLCPLST                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���Խ���(�����ϱ���)                                  *
*&      �ۼ��� : ȫ��ǳ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.22                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :                                                       *
*&
*&---------------------------------------------------------------------*
*& [���泻��]                                                          *
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMLCPLST   MESSAGE-ID ZIM
                     LINE-SIZE 140
                     NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------*
* �����Ƿ� ������� INTERNAL TABLE                                     *
*----------------------------------------------------------------------*
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFPNAMC      LIKE      ZTPMTHD-ZFPNAMC,      "�����ݾ���ȭ.
       ZFTIVAM1(18) TYPE      C,
       ZFUSD        LIKE      ZTREQST-ZFUSD,        "ȯ��ݾ���ȭ.
       ZFUSDAM1(18) TYPE      C,                    "US$ ȯ��ݾ�.
       MENGE1(18)   TYPE      C,
       ZFOPAMT1(18) TYPE      C,
       MEINS        LIKE      ZTREQIT-Meins,        "����.
       WAERS        LIKE      ZTREQST-WAERS,        "��ȭ.
       TXZ01        LIKE      ZTREQIT-TXZ01,        "ǰ�񳻿�.
       ZFITMNO      LIKE      ZTREQIT-ZFITMNO,      "ǰ���ȣ.
       ZFOPNNO      LIKE      ZTPMTHD-ZFOPNNO,      "L/C.
       OPNAME1      LIKE      LFA1-NAME1,           "���������.
       ZFOPBN       LIKE      ZTPMTHD-ZFOPBN,       "���������ڵ�.
       PNNAME1      LIKE      LFA1-NAME1,           "���������.
       ZFPNBN       LIKE      ZTPMTHD-ZFPNBN,       "���������ڵ�.
       ZFPYDT       LIKE      ZTPMTHD-ZFPYDT,       "������.
       ZFOPNDT      LIKE      ZTREQST-ZFOPNDT,      "������.
       ZFAMDNO      LIKE      ZTREQST-ZFAMDNO,      "AMEND ȸ��.
       ZFREQNO      LIKE      ZTPMTHD-ZFREQNO,      "�����Ƿڰ�����ȣ.
       ZFTIVAM      LIKE      ZTPMTHD-ZFTIVAM,      "�����ݾ�.
       ZFUSDAM      LIKE      ZTREQST-ZFUSDAM,      "US$ ȯ��ݾ�.
       MENGE        LIKE      ZTREQIT-MENGE,        "����.
       ZFPNNO       LIKE      ZTPMTHD-ZFPNNO,       "Payment Notice.
       ZFOPAMT      LIKE      ZTREQST-ZFOPAMT.      "�����ݾ�.
DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TAB_DOWN OCCURS 0,
       ZFPNAMC      LIKE      ZTPMTHD-ZFPNAMC,      "�����ݾ���ȭ.
       ZFTIVAM(18)  TYPE      C,
       ZFUSD        LIKE      ZTREQST-ZFUSD,        "ȯ��ݾ���ȭ.
       ZFUSDAM(18)  TYPE      C,                    "US$ ȯ��ݾ�.
       MENGE(18)    TYPE      C,
       ZFOPAMT(18) TYPE       C,
       WAERS        LIKE      ZTREQST-WAERS,        "��ȭ.
       TXZ01        LIKE      ZTREQIT-TXZ01,        "ǰ�񳻿�.
       ZFITMNO      LIKE      ZTREQIT-ZFITMNO,      "ǰ���ȣ.
       ZFOPNNO      LIKE      ZTPMTHD-ZFOPNNO,      "L/C.
       OPNAME1      LIKE      LFA1-NAME1,           "���������.
       ZFOPBN       LIKE      ZTPMTHD-ZFOPBN,       "���������ڵ�.
       PNNAME1      LIKE      LFA1-NAME1,           "���������.
       ZFPNBN       LIKE      ZTPMTHD-ZFPNBN,       "���������ڵ�.
       ZFPYDT       LIKE      ZTPMTHD-ZFPYDT,       "������.
       ZFOPNDT      LIKE      ZTREQST-ZFOPNDT,      "������.
       ZFAMDNO      LIKE      ZTREQST-ZFAMDNO,      "AMEND ȸ��.
       ZFREQNO      LIKE      ZTPMTHD-ZFREQNO.      "�����Ƿڰ�����ȣ.
DATA : END OF IT_TAB_DOWN.

*----------------------------------------------------------------------*
* INCLUDE.                                                             *
*----------------------------------------------------------------------*
INCLUDE   ZRIMLCPLSTTOP.
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.

*----------------------------------------------------------------------*
* SELECTION SCREEN.                                                    *
*----------------------------------------------------------------------*
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS   FOR ZTREQHD-BUKRS NO-EXTENSION
                                                NO INTERVALS,
                   S_RLDT    FOR ZTREQST-ZFOPNDT,  " ������.
                   S_OPBN    FOR ZTPMTHD-ZFOPBN,   " ��������.
                   S_MATGB   FOR ZTREQHD-ZFMATGB,  " ���籸��.
                   S_REQTY   FOR ZTREQHD-ZFREQTY,  " �����Ƿ� Type
                   S_WERKS   FOR ZTREQHD-ZFWERKS,  " ��ǥ plant
                   S_EKORG   FOR ZTREQST-EKORG,    " Purch. Org.
                   S_EBELN   FOR ZTPMTHD-EBELN,    " P/O Number
                   S_LIFNR   FOR ZTREQHD-LIFNR,    " vendor
                   S_ZFBENI  FOR ZTPMTHD-ZFBENI,   " Beneficiary
                   S_EKGRP   FOR ZTREQST-EKGRP,    " Purch. Grp.
                   S_ZFPYDT  FOR ZTPMTHD-ZFPYDT,   " ������.
                   S_REQNO   FOR ZTPMTHD-ZFREQNO.  " �����Ƿ� ������ȣ.
SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------*
* INITIALIZATION.                                                      *
*----------------------------------------------------------------------*
INITIALIZATION.
  SET TITLEBAR  'ZIMR22'.                      "Ÿ��Ʋ��.
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*----------------------------------------------------------------------*
* START OF SELECTION.                                                  *
*----------------------------------------------------------------------*
START-OF-SELECTION.
   PERFORM   P1000_READ_DATA.
   PERFORM   P3000_DATA_WRITE.

*----------------------------------------------------------------------*
* FORM  P1000_READ_DATA.                                               *
*----------------------------------------------------------------------*
FORM P1000_READ_DATA.

  REFRESH IT_TAB.
  SELECT *
    FROM ZTPMTHD
   WHERE ZFOPBN   IN S_OPBN        "��������.
     AND EBELN    IN S_EBELN       "P/O Num.
     AND ZFBENI   IN S_ZFBENI      "Beneficiary.
     AND ZFREQNO  IN S_REQNO       "�����Ƿڰ�����ȣ.
     AND ZFPYDT   IN S_ZFPYDT.     "������.

        SELECT SINGLE *
          FROM ZTREQHD
         WHERE ZFREQNO  EQ  ZTPMTHD-ZFREQNO
           AND BUKRS    IN  S_BUKRS
           AND ZFOPBN   IN  S_OPBN      "��������.
           AND ZFMATGB  IN  S_MATGB     "���籸��.
           AND ZFREQTY  IN  S_REQTY     "�����Ƿ� type.
           AND ZFWERKS  IN  S_WERKS     "��ǥ plant.
           AND LIFNR    IN  S_LIFNR.    "vendor.
        IF SY-SUBRC NE 0.
           CONTINUE.
        ENDIF.

        CLEAR IT_TAB.
        MOVE-CORRESPONDING ZTPMTHD TO IT_TAB.

        SELECT MAX( ZFAMDNO ) INTO IT_TAB-ZFAMDNO          "AMEND.
          FROM ZTREQST
         WHERE ZFREQNO = IT_TAB-ZFREQNO.
        SELECT SINGLE *
          FROM ZTREQST
         WHERE ZFAMDNO     =     IT_TAB-ZFAMDNO
           AND ZFREQNO     =     IT_TAB-ZFREQNO
           AND ZFOPNDT    IN     S_RLDT      "������.
           AND EKORG      IN     S_EKORG     "PURCH.ORG.
           AND EKGRP      IN     S_EKGRP.    "PURCH GRP.

        IF SY-SUBRC NE 0.
           CONTINUE.
        ENDIF.

        MOVE ZTREQST-ZFOPNDT    TO      IT_TAB-ZFOPNDT.   "������.
        MOVE ZTREQST-WAERS      TO      IT_TAB-WAERS.     "��ȭ.
        MOVE ZTREQST-ZFOPAMT    TO      IT_TAB-ZFOPAMT.   "�����ݾ�.
        MOVE ZTREQST-ZFUSDAM    TO      IT_TAB-ZFUSDAM.   "US$ ȯ��.

        IF NOT IT_TAB-ZFPNBN IS INITIAL.
           SELECT SINGLE NAME1 INTO IT_TAB-PNNAME1            "��������.
             FROM LFA1
            WHERE LIFNR = IT_TAB-ZFPNBN.
        ENDIF.

        IF NOT IT_TAB-ZFOPBN IS INITIAL.
           SELECT SINGLE NAME1 INTO IT_TAB-OPNAME1            "��������.
             FROM LFA1
            WHERE LIFNR = IT_TAB-ZFOPBN.
        ENDIF.

        IF NOT IT_TAB-ZFREQNO IS INITIAL.
           SELECT MIN( ZFITMNO ) INTO IT_TAB-ZFITMNO
             FROM ZTREQIT
            WHERE ZFREQNO = IT_TAB-ZFREQNO.                   "ǰ���ȣ.
        ENDIF.

        IF NOT IT_TAB-ZFREQNO IS INITIAL AND
           NOT IT_TAB-ZFITMNO IS INITIAL.
           SELECT SINGLE *
             FROM ZTREQIT
            WHERE ZFREQNO = IT_TAB-ZFREQNO
              AND ZFITMNO = IT_TAB-ZFITMNO.
           MOVE ZTREQIT-TXZ01      TO      IT_TAB-TXZ01.   "ǰ�񳻿�.
           MOVE ZTREQIT-MENGE      TO      IT_TAB-MENGE.   "����.
           MOVE ZTREQIT-MEINS      TO      IT_TAB-MEINS.   "����.
        ENDIF.
        APPEND IT_TAB.
   ENDSELECT.

   DESCRIBE TABLE IT_TAB LINES W_LINE.
   IF W_LINE = 0.
      MESSAGE S009.
      EXIT.
   ENDIF.
ENDFORM.                                       "P1000_READ_DATA.

*----------------------------------------------------------------------*
* FORM P3000_DATA_WRITE                                                *
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE.
   SET TITLEBAR 'ZIMR22'.
   SET PF-STATUS 'ZIMR22'.                      " GUI STATUS SETTING
   W_LINE = 0.
   W_PAGE = 1.
   W_COUNT = 0.
   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P2000_PAGE_CHECK.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.
   ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE

*----------------------------------------------------------------------*
* FORM P2000_PAGE_CHECK                                                *
*----------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK.

*----------------------------------------------------------------------*
* FORM P3000_LAST_WRITE                                                *
*----------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

   FORMAT RESET.
*   FORMAT COLOR COL_NORMAL INTENSIFIED ON.
   SUM.
   WRITE:/ SY-VLINE,114 'TOTAL:',
          121 IT_TAB-ZFUSDAM CURRENCY IT_TAB-ZFUSD,
          140 SY-VLINE.
   WRITE:/ SY-ULINE.
   FORMAT COLOR OFF.
   IF W_COUNT GT 0.
      WRITE : / '��', W_COUNT, '��'.
   ENDIF.

ENDFORM.                    " P3000_LAST_WRITE

*----------------------------------------------------------------------*
* FORM P3000_LINE_WRITE.                                               *
*----------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED ON.
   WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX, SY-VLINE ,
          (10) IT_TAB-ZFPYDT,    SY-VLINE,   "������.
          (25) IT_TAB-PNNAME1,   SY-VLINE,   "��������.
          (35) IT_TAB-ZFOPNNO,   SY-VLINE,   "L/C NO.
           (5) IT_TAB-WAERS,     SY-VLINE,   "��ȭ.
           (5) IT_TAB-WAERS,
          (15) IT_TAB-ZFOPAMT CURRENCY IT_TAB-WAERS,SY-VLINE,
           (5) IT_TAB-ZFUSD,
          (15) IT_TAB-ZFUSDAM CURRENCY IT_TAB-ZFUSD,SY-VLINE.

   HIDE:IT_TAB.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE:/ SY-VLINE, ' ', SY-VLINE ,
          (10) IT_TAB-ZFOPNDT,   SY-VLINE,   "������.
          (25) IT_TAB-OPNAME1,   SY-VLINE,   "��������.
          (35) IT_TAB-TXZ01,     SY-VLINE,   "ǰ��.
           (5) IT_TAB-MEINS,     SY-VLINE,   "����.
          (21) IT_TAB-MENGE UNIT IT_TAB-MEINS,SY-VLINE, "����.
           (5) IT_TAB-ZFPNAMC,
          (15) IT_TAB-ZFTIVAM CURRENCY IT_TAB-ZFPNAMC,SY-VLINE.

*   FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
*   WRITE : / SY-ULINE.
*   W_COUNT = W_COUNT + 1.


  HIDE: IT_TAB.
  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.
ENDFORM.                    " P3000_LINE_WRITE

*----------------------------------------------------------------------*
* P3000_TITLE_WRITE.                                                   *
*----------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /56  '[ ���Խ��� List (�����ϱ���) ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /2 'Date : ', SY-DATUM, 122 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,  ' ',                        SY-VLINE,
                 (10)  '������',                   SY-VLINE,
                 (25)  '��������',                 SY-VLINE,
                 (35)  'L/C NO',                   SY-VLINE,
                  (5)  '��ȭ',                     SY-VLINE,
                 (21)  '            �����ݾ�',     SY-VLINE,
                 (21)  '         US$ȯ��ݾ�',     SY-VLINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE,  ' ',                    SY-VLINE,
                 (10)  '������',               SY-VLINE,
                 (25)  '��������',             SY-VLINE,
                 (35)  'ǰ��',                 SY-VLINE,
                  (5)  '����  ',               SY-VLINE,
                 (21)  '                ����', SY-VLINE,
                 (21)  '            �����ݾ�', SY-VLINE.

  FORMAT COLOR COL_TOTAL INTENSIFIED.
  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE.

*----------------------------------------------------------------------*
* FORM RESET_LIST                                                      *
*----------------------------------------------------------------------*
FORM RESET_LIST.

   MOVE 0 TO SY-LSIND.

   W_PAGE = 1.
   PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
   PERFORM   P3000_DATA_WRITE.

ENDFORM.                    " RESET_LIST

*----------------------------------------------------------------------*
* USER COMMAND.                                                        *
*----------------------------------------------------------------------*
AT USER-COMMAND.
   CASE SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.
         W_FIELD_NM = 'ZFOPBN'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES IT_TAB USING SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.
         PERFORM P2000_SELECT_RECORD USING SY-UCOMM.
      WHEN 'DISPLC'.
         PERFORM P2000_MULTI_SELECTION.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_SHOW_LC USING  IT_SELECTED-ZFREQNO
                                         IT_SELECTED-ZFAMDNO.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'DISPPN'.
         PERFORM P2000_MULTI_SELECTION_PN.
         IF W_SELECTED_LINES EQ 1.
            READ TABLE IT_SELECTED INDEX 1.
            PERFORM P2000_SHOW_PN USING IT_SELECTED_PN-ZFPNNO.
            CALL TRANSACTION 'ZIMP4' AND SKIP FIRST SCREEN.
         ELSEIF W_SELECTED_LINES GT 1.
            MESSAGE E965.
         ENDIF.
      WHEN 'DOWN'.
         PERFORM P3000_CREATE_DOWNLOAD_FILE.
         PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
         PERFORM P1000_READ_DATA.
         PERFORM RESET_LIST.
      WHEN OTHERS.
   ENDCASE.

*----------------------------------------------------------------------*
* P2000_MULTI_SELECTIOIN.                                              *
*----------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

   DATA : ZFREQNO LIKE ZTREQST-ZFREQNO,
          ZFAMDNO LIKE ZTREQST-ZFAMDNO.

   REFRESH IT_SELECTED.
   CLEAR W_SELECTED_LINES.

   MOVE : IT_TAB-ZFREQNO  TO ZFREQNO,
          IT_TAB-ZFAMDNO  TO ZFAMDNO.
   DO.
     CLEAR MARKFIELD.
     READ LINE SY-INDEX FIELD VALUE MARKFIELD.
     IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
     IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
        MOVE : IT_TAB-ZFREQNO  TO IT_SELECTED-ZFREQNO,
               IT_TAB-ZFAMDNO  TO IT_SELECTED-ZFAMDNO.
        APPEND IT_SELECTED.
        ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

  IF W_SELECTED_LINES EQ 0.
     MESSAGE S951.
  ENDIF.

ENDFORM.                    " P2000_MULTI_SELECTION

*----------------------------------------------------------------------*
* FORM P2000_MULTI_SELECTION_PN.                                       *
*----------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION_PN.

  DATA: INDEX   TYPE P,
        ZFPNNO  LIKE ZTPMTHD-ZFPNNO.

  REFRESH IT_SELECTED_PN.
  CLEAR   IT_SELECTED_PN.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX    TO INDEX,
         IT_TAB-ZFPNNO   TO ZFPNNO.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : W_LIST_INDEX    TO INDEX,
                IT_TAB-ZFPNNO   TO IT_SELECTED_PN-ZFPNNO.

      APPEND IT_SELECTED_PN.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION_PN.

*----------------------------------------------------------------------*
* FORM P2000_SHOW_LC                                                   *
*----------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO P_ZFAMDNO.

   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
   EXPORT 'BES'           TO MEMORY ID 'BES'.
   EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.
   EXPORT 'ZPAMDNO'       TO MEMORY ID 'ZPAMDNO'.

   IF P_ZFAMDNO = '00000'.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_LC.

*----------------------------------------------------------------------*
* FORM P2000_SHOW_PMTHD                                                *
*----------------------------------------------------------------------*
FORM P2000_SHOW_PN USING    P_ZFPNNO.

   SET PARAMETER ID 'ZPPNNO'  FIELD P_ZFPNNO.
   EXPORT 'ZPPNNO'        TO MEMORY ID 'ZPPNNO'.

ENDFORM.                    " P2000_SHOW_PN.

*&---------------------------------------------------------------------*
*&      Form  P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
FORM P3000_CREATE_DOWNLOAD_FILE.

  REFRESH IT_TAB_DOWN.
  LOOP AT IT_TAB.
    CLEAR IT_TAB_DOWN.
    MOVE-CORRESPONDING IT_TAB TO IT_TAB_DOWN.
    WRITE : IT_TAB-MENGE   UNIT     IT_TAB-MEINS TO IT_TAB_DOWN-MENGE,
            IT_TAB-ZFTIVAM CURRENCY IT_TAB-ZFPNAMC TO
                                                    IT_TAB_DOWN-ZFUSDAM,
            IT_TAB-ZFUSDAM CURRENCY IT_TAB-ZFUSD TO IT_TAB_DOWN-ZFUSDAM,
            IT_TAB-ZFOPAMT CURRENCY IT_TAB-WAERS TO IT_TAB_DOWN-ZFOPAMT.
    APPEND IT_TAB_DOWN.
  ENDLOOP.

ENDFORM.                    " P3000_CREATE_DOWNLOAD_FILE
