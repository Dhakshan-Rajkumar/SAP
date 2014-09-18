*&---------------------------------------------------------------------*
*& Report  ZRIMBLCSTLST                                               *
*&---------------------------------------------------------------------*
*&  ���α׷��� : B/L ��� ȸ��ó�� ��Ȳ                                *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.09.26                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : B/L����� ��ȸ�Ѵ�.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMBLCSTLST    MESSAGE-ID ZIM
                        LINE-SIZE 135
                        NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMBLCSTLSTTOP.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK            TYPE   C,
       ZFHBLNO(16)     TYPE   C,                " House B/L No
       ZFBLNO          LIKE   ZTBLCST-ZFBLNO,   " B/L ������?
       ZFCSQ           LIKE   ZTBLCST-ZFCSQ,    " ����?
       ZFCSCD          LIKE   ZTBLCST-ZFCSCD,   " ��뱸?
       ZFCSCD_NM(10)   TYPE   C,                " ����?
       ZFCAMT          LIKE   ZTBLCST-ZFCAMT,   " ����?
       WAERS           LIKE   ZTBLCST-WAERS,    " ��?
       ZFCKAMT         LIKE   ZTBLCST-ZFCKAMT,  " ����ȭ��?
       KRW             LIKE   ZTBLCST-KRW,      " ��ȭ��?
       ZFVAT           LIKE   ZTBLCST-ZFVAT,    " �ΰ���.
       BUKRS           LIKE   ZTBLCST-BUKRS,    " ȸ���ڵ�.
       ZFOCDT          LIKE   ZTBLCST-ZFOCDT,   " �߻�?
       ZFPSDT          LIKE   ZTBLCST-ZFPSDT,   " ȸ��ó��?
       ZFFIYR          LIKE   ZTBLCST-ZFFIYR,   " ȸ����ǥ ��?
       ZFACDO          LIKE   ZTBLCST-ZFACDO,   " ȸ����ǥ ��?
       ZFVEN           LIKE   ZTBLCST-ZFVEN,    " Vendor
       ZFVEN_NM(20)    TYPE   C,                " Vendor ?
       ZFPAY           LIKE   ZTBLCST-ZFPAY,    " ����?
       ZFPAY_NM(20)    TYPE   C,                " ����ó?
       ZTERM           LIKE   ZTBLCST-ZTERM,    " Terms of Payment
       MWSKZ           LIKE   ZTBLCST-MWSKZ,    " Tax Code
       ZFWERKS         LIKE   ZTBLCST-ZFWERKS,  " Plant
       ZFWERKS_NM      LIKE   T001W-NAME1,      " Plant Name
       UNAM            LIKE   ZTBLCST-UNAM,     " Last changed by
       UDAT            LIKE   ZTBLCST-UDAT,     " Last changed on
       ZFREBELN        LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O
       ZFSHNO          LIKE   ZTBL-ZFSHNO,      " ��������
       ZFOPNNO(23)     TYPE   C,                " ��ǥ L/C
       SUM_MARK        TYPE   C.
DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TAB_TMP OCCURS 0,
       ZFHBLNO(16)     TYPE   C,                " House B/L No
       ZFBLNO          LIKE   ZTBLCST-ZFBLNO,   " B/L ������?
       ZFCSQ           LIKE   ZTBLCST-ZFCSQ,    " ����?
       ZFCSCD          LIKE   ZTBLCST-ZFCSCD,   " ��뱸?
       ZFCSCD_NM(10)   TYPE   C,                " ����?
       ZFCAMT          LIKE   ZTBLCST-ZFCAMT,   " ����?
       WAERS           LIKE   ZTBLCST-WAERS,    " ��?
       ZFCKAMT         LIKE   ZTBLCST-ZFCKAMT,  " ����ȭ��?
       KRW             LIKE   ZTBLCST-KRW,      " ��ȭ��?
       ZFOCDT          LIKE   ZTBLCST-ZFOCDT,   " �߻�?
       ZFPSDT          LIKE   ZTBLCST-ZFPSDT,   " ȸ��ó��?
       ZFVAT           LIKE   ZTBLCST-ZFVAT,    " �ΰ���.
       BUKRS           LIKE   ZTBLCST-BUKRS,    " ȸ���ڵ�.
       ZFFIYR          LIKE   ZTBLCST-ZFFIYR,   " ȸ����ǥ ��?
       ZFACDO          LIKE   ZTBLCST-ZFACDO,   " ȸ����ǥ ��?
       ZFVEN           LIKE   ZTBLCST-ZFVEN,    " Vendor
       ZFVEN_NM(20)    TYPE   C,                " Vendor ?
       ZFPAY           LIKE   ZTBLCST-ZFPAY,    " ����?
       ZFPAY_NM(20)    TYPE   C,                " ����ó?
       ZTERM           LIKE   ZTBLCST-ZTERM,    " Terms of Payment
       MWSKZ           LIKE   ZTBLCST-MWSKZ,    " Tax Code
       ZFWERKS         LIKE   ZTBLCST-ZFWERKS,  " Plant
       ZFWERKS_NM      LIKE   T001W-NAME1,      " Plant Name
       UNAM            LIKE   ZTBLCST-UNAM,     " Last changed by
       UDAT            LIKE   ZTBLCST-UDAT,     " Last changed on
       ZFREBELN        LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O
       ZFSHNO          LIKE   ZTBL-ZFSHNO,      " ��������
       ZFOPNNO(23)     TYPE   C.                " ��ǥ L/C
DATA : END OF IT_TAB_TMP.

INCLUDE   ZRIMSORTCOM.    " Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS  FOR ZTBL-BUKRS NO-EXTENSION NO INTERVALS,
                   S_VEN    FOR ZTBLCST-ZFVEN,     " Vendor
                   S_PAY    FOR ZTBLCST-ZFPAY,     " ����?
                   S_WERKS  FOR ZTBLCST-ZFWERKS,   " Plant
                   S_OCDT   FOR ZTBLCST-ZFOCDT,    " �߻�?
                   S_PSDT   FOR ZTBLCST-ZFPSDT,    " ȸ��ó��?
                   S_HBLNO  FOR ZTBL-ZFHBLNO,      " House B/L No
                   S_REBELN FOR ZTBL-ZFREBELN,     " ��ǥ P/O
                   S_OPNNO  FOR ZTBL-ZFOPNNO,      " ��ǥ L/C
                   S_ZTERM  FOR ZTBLCST-ZTERM,     " Terms Of Payment
                   S_MWSKZ  FOR ZTBLCST-MWSKZ,     " Tax Code
                   S_CSCD   FOR ZTBLCST-ZFCSCD     " ��뱸��.
                            MATCHCODE OBJECT ZIC8,
                   S_CSCD1  FOR ZTBLCST-ZFCSCD     " ��������ڵ�.
                            MATCHCODE OBJECT ZIC6A.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
* ȸ��ó�� ��?
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-002, POSITION 1.
     SELECTION-SCREEN : COMMENT 36(3) TEXT-021, POSITION 40.
     PARAMETERS : P_Y   RADIOBUTTON GROUP RDG.  " Yes
     SELECTION-SCREEN : COMMENT 51(2) TEXT-022, POSITION 54.
     PARAMETERS : P_N   RADIOBUTTON GROUP RDG.  " No
     SELECTION-SCREEN : COMMENT 64(3) TEXT-023, POSITION 68.
     PARAMETERS : P_A   RADIOBUTTON GROUP RDG.  " ALL
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
* Sort By
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(17) TEXT-003, POSITION 1.
     SELECTION-SCREEN : COMMENT 23(6) TEXT-030, POSITION 30.
     PARAMETERS : P_T   RADIOBUTTON GROUP RDG1. " �÷�Ʈ
     SELECTION-SCREEN : COMMENT 33(6) TEXT-031, POSITION 40.
     PARAMETERS : P_V   RADIOBUTTON GROUP RDG1. " Vendor?
     SELECTION-SCREEN : COMMENT 43(6) TEXT-032, POSITION 50.
     PARAMETERS : P_P   RADIOBUTTON GROUP RDG1. " ����ó?
     SELECTION-SCREEN : COMMENT 53(8) TEXT-033, POSITION 62.
     PARAMETERS : P_S   RADIOBUTTON GROUP RDG1. " ��ǥ?
     SELECTION-SCREEN : COMMENT 65(8) TEXT-034, POSITION 74.
     PARAMETERS : P_C   RADIOBUTTON GROUP RDG1. " ���?
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B3.

INITIALIZATION.                           " �ʱⰪ SETTING

   SET  TITLEBAR 'ZIMR03'.           " GUI TITLE SETTING..
   PERFORM   P2000_INIT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-LOW.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_ZTERM-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-HIGH.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_ZTERM-HIGH.


* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ���� CONFIGURATION CHECK!
  PERFORM   P2000_CONFIG_CHECK        USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

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
      WHEN 'DOWN'.          " FILE DOWNLOAD....
            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM RESET_LIST.
      WHEN 'DSBL'.                    " B/L ��?
            PERFORM P2000_SHOW_BL USING IT_TAB-ZFBLNO.
      WHEN 'FB03'.                    " ȸ����ǥ ��?
            IF IT_TAB-ZFACDO EQ SPACE.
               MESSAGE S252. EXIT.
            ENDIF.
            PERFORM P2000_SHOW_SL USING IT_TAB-BUKRS
                                        IT_TAB-ZFFIYR
                                        IT_TAB-ZFACDO.
      WHEN 'BAC1' OR 'EXIT' OR 'CANC'.
            LEAVE TO SCREEN 0.                " ��?
      WHEN OTHERS.
   ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.

  P_N = 'X'.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /57  '[ B/L ��� ȸ��ó�� ��Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / ' Date : ', SY-DATUM, 113 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
            (15) '���'                  NO-GAP, SY-VLINE NO-GAP,
            (20) '�߻��ݾ�'              NO-GAP, SY-VLINE NO-GAP,
            (20) '�ΰ���'                NO-GAP, SY-VLINE NO-GAP,
            (10) '�߻���'                NO-GAP, SY-VLINE NO-GAP,
            (10) 'Vendor'                NO-GAP, SY-VLINE NO-GAP,
            (20) 'House B/L No.'         NO-GAP, SY-VLINE NO-GAP,
            (15) '��ǥ P/O'              NO-GAP, SY-VLINE NO-GAP,
            (16) '��ǥ L/C'              NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,
            (15) ''                      NO-GAP, SY-VLINE NO-GAP,
            (20) '��ȭ�ݾ�'              NO-GAP, SY-VLINE NO-GAP,
            (20) '��ǥ��ȣ'              NO-GAP, SY-VLINE NO-GAP,
            (10) 'ȸ��ó����'            NO-GAP, SY-VLINE NO-GAP,
            (10) '����ó'                NO-GAP, SY-VLINE NO-GAP,
            (20) 'B/L ����No'            NO-GAP, SY-VLINE NO-GAP,
            (15) 'Plnt/Tx/Term'          NO-GAP, SY-VLINE NO-GAP,
            (16) 'Last Changed'          NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIMR03'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMR03'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P2000_PAGE_CHECK.
      IF IT_TAB-SUM_MARK = 'Y'.
         PERFORM P3000_SUM_LINE_WRITE.
      ELSE.
         PERFORM P3000_LINE_WRITE.
      ENDIF.

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
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
  DATA: L_EBELN(12),
        L_FANO(20),
        L_TEXT(15).

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

  CONCATENATE IT_TAB-ZFREBELN '-' IT_TAB-ZFSHNO INTO L_EBELN.

  WRITE:/      SY-VLINE             NO-GAP,
          (15) IT_TAB-ZFCSCD_NM     NO-GAP, SY-VLINE NO-GAP,
          (16) IT_TAB-ZFCAMT CURRENCY IT_TAB-WAERS,
          (3)  IT_TAB-WAERS         NO-GAP, SY-VLINE NO-GAP,
          (20) IT_TAB-ZFVAT  CURRENCY 'KRW' NO-GAP, SY-VLINE NO-GAP,
          (10) IT_TAB-ZFOCDT        NO-GAP, SY-VLINE NO-GAP,
          (10) IT_TAB-ZFVEN         NO-GAP, SY-VLINE NO-GAP,
          (20) IT_TAB-ZFHBLNO       NO-GAP, SY-VLINE NO-GAP,
          (15) L_EBELN              NO-GAP, SY-VLINE NO-GAP,
          (16) IT_TAB-ZFOPNNO       NO-GAP, SY-VLINE NO-GAP.
* Hide
  HIDE: IT_TAB.
  FORMAT COLOR COL_BACKGROUND.
  CONCATENATE IT_TAB-ZFFIYR '-' IT_TAB-ZFACDO INTO L_FANO.
  CONCATENATE IT_TAB-ZFWERKS '/' IT_TAB-MWSKZ '/' IT_TAB-ZTERM
              INTO L_TEXT.

  WRITE :/     SY-VLINE      NO-GAP,
          (15) IT_TAB-ZFCSCD        NO-GAP, SY-VLINE NO-GAP,
          (16) IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW,
          (3)  IT_TAB-KRW           NO-GAP, SY-VLINE NO-GAP,
          (20) L_FANO               NO-GAP, SY-VLINE NO-GAP,
          (10) IT_TAB-ZFPSDT        NO-GAP, SY-VLINE NO-GAP,
          (10) IT_TAB-ZFPAY         NO-GAP, SY-VLINE NO-GAP,
          (20) IT_TAB-ZFBLNO        NO-GAP, SY-VLINE NO-GAP,
          (15) L_TEXT               NO-GAP, SY-VLINE NO-GAP,
          (7)  IT_TAB-UNAM,
          (8)  IT_TAB-UDAT          NO-GAP, SY-VLINE NO-GAP.

* Stored value...
  HIDE: IT_TAB.
  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.
  IF W_COUNT GT 0.
     FORMAT RESET.
     FORMAT COLOR COL_TOTAL INTENSIFIED ON.

     WRITE:/ SY-VLINE NO-GAP,
             (15) '�Ѱ�'          NO-GAP, SY-VLINE NO-GAP,
             (16) TOT_ZFCKAMT CURRENCY 'KRW',
             (3)  'KRW',
             135  SY-VLINE.
     WRITE :/ SY-ULINE.

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
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH IT_TAB_TMP.

  SELECT *
    FROM ZTBLCST
   WHERE ZFVEN     IN S_VEN
     AND ZFPAY     IN S_PAY
     AND ZFWERKS   IN S_WERKS
     AND ZFOCDT    IN S_OCDT
     AND ZFOCDT    IN S_OCDT
     AND ZFPSDT    IN S_PSDT
     AND ZTERM     IN S_ZTERM
     AND MWSKZ     IN S_MWSKZ
     AND ZFCSCD    IN S_CSCD
     AND ZFCSCD    IN S_CSCD1
     AND ZFCAMT    GT 0.
         IF P_Y = 'X'.  "ȸ��ó�� Yes
            IF ZTBLCST-ZFFIYR IS INITIAL OR ZTBLCST-ZFACDO IS INITIAL.
               CONTINUE.
            ENDIF.
         ENDIF.
         IF P_N = 'X'.  "ȸ��ó�� No
            IF NOT ( ZTBLCST-ZFFIYR IS INITIAL ).
               CONTINUE.
            ENDIF.
         ENDIF.
         CLEAR ZTBL.
         SELECT SINGLE *
           FROM ZTBL
          WHERE ZFBLNO = ZTBLCST-ZFBLNO
            AND BUKRS   IN S_BUKRS
            AND ZFHBLNO IN S_HBLNO
            AND ZFREBELN IN S_REBELN
            AND ZFOPNNO IN S_OPNNO.
         IF SY-SUBRC NE 0.
            CONTINUE.
         ENDIF.
         CLEAR IT_TAB_TMP.
         MOVE-CORRESPONDING ZTBLCST TO IT_TAB_TMP.
         MOVE ZTBL-ZFWERKS  TO IT_TAB_TMP-ZFWERKS.
         MOVE ZTBL-ZFHBLNO  TO IT_TAB_TMP-ZFHBLNO.
         MOVE ZTBL-ZFREBELN TO IT_TAB_TMP-ZFREBELN.
         MOVE ZTBL-ZFSHNO TO IT_TAB_TMP-ZFSHNO.
         MOVE ZTBL-ZFOPNNO  TO IT_TAB_TMP-ZFOPNNO.

         SELECT SINGLE NAME1 INTO IT_TAB_TMP-ZFWERKS_NM
               FROM T001W
              WHERE WERKS = IT_TAB_TMP-ZFWERKS.

         SELECT SINGLE ZFCDNM INTO IT_TAB_TMP-ZFCSCD_NM
           FROM ZTIMIMG08
          WHERE ( ZFCDTY = '004' OR ZFCDTY = '005' )
            AND ZFCD = IT_TAB_TMP-ZFCSCD.
         SELECT SINGLE NAME1 INTO IT_TAB_TMP-ZFVEN_NM
           FROM LFA1
          WHERE LIFNR = IT_TAB_TMP-ZFVEN.
         SELECT SINGLE NAME1 INTO IT_TAB_TMP-ZFPAY_NM
           FROM LFA1
          WHERE LIFNR = IT_TAB_TMP-ZFPAY.
         APPEND  IT_TAB_TMP.
  ENDSELECT.

  DESCRIBE TABLE IT_TAB_TMP LINES W_COUNT.
  IF W_COUNT = 0.
     MESSAGE S738.
  ENDIF.

  IF P_T = 'X'.  "Sort By Plant
     SORT IT_TAB_TMP BY ZFWERKS ASCENDING.
  ENDIF.

  IF P_V = 'X'.  "Sort By Vendor
     SORT IT_TAB_TMP BY ZFVEN ZFFIYR ZFACDO ASCENDING.
  ENDIF.

  IF P_P = 'X'.  "Sort By ����?
     SORT IT_TAB_TMP BY ZFPAY ZFFIYR ZFACDO ASCENDING.
  ENDIF.

  IF P_S = 'X'.  "Sort By ��ǥ��?
     SORT IT_TAB_TMP BY ZFFIYR ZFACDO ZFCSCD ASCENDING.
  ENDIF.

  IF P_C = 'X'.  "Sort By �����?
     SORT IT_TAB_TMP BY ZFCSCD ZFVEN ZFFIYR ZFACDO ASCENDING.
  ENDIF.

  CLEAR : SV_ZFWERKS, SV_ZFVEN, SV_ZFVEN, SV_ZFFIYR, SV_ZFACDO,
          SV_ZFCSCD,  SUM_ZFCKAMT, TOT_ZFCKAMT.

  REFRESH IT_TAB.
  LOOP AT IT_TAB_TMP.
       ADD 1   TO W_LOOP_CNT.

       IF SV_ZFWERKS NE IT_TAB_TMP-ZFWERKS.
          IF P_T = 'X'.
             CLEAR  IT_TAB.
             MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
             MOVE   'KRW'       TO IT_TAB-KRW.
             MOVE   SV_ZFWERKS  TO IT_TAB-ZFWERKS.

             SELECT SINGLE NAME1 INTO IT_TAB-ZFWERKS_NM
               FROM T001W
              WHERE WERKS = IT_TAB-ZFWERKS.

             MOVE   'Y'        TO IT_TAB-SUM_MARK.
             IF W_LOOP_CNT NE 1. APPEND IT_TAB. ENDIF.
             CLEAR  SUM_ZFCKAMT.
          ENDIF.
       ENDIF.

       IF SV_ZFVEN NE IT_TAB_TMP-ZFVEN.
          IF P_V = 'X'.
             CLEAR  IT_TAB.
             MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
             MOVE   'KRW'       TO IT_TAB-KRW.
             MOVE   SV_ZFVEN    TO IT_TAB-ZFVEN.
             SELECT SINGLE NAME1 INTO IT_TAB-ZFVEN_NM
               FROM LFA1
             WHERE LIFNR = IT_TAB-ZFVEN.
             MOVE   'Y'        TO IT_TAB-SUM_MARK.
             IF W_LOOP_CNT NE 1. APPEND IT_TAB. ENDIF.
             CLEAR  SUM_ZFCKAMT.
          ENDIF.
       ENDIF.
       IF SV_ZFPAY NE IT_TAB_TMP-ZFPAY.
          IF P_P = 'X'.
             CLEAR  IT_TAB.
             MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
             MOVE   'KRW'       TO IT_TAB-KRW.
             MOVE   SV_ZFPAY    TO IT_TAB-ZFPAY.
             SELECT SINGLE NAME1 INTO IT_TAB-ZFPAY_NM
               FROM LFA1
             WHERE LIFNR = IT_TAB-ZFPAY.
             MOVE   'Y'        TO IT_TAB-SUM_MARK.
             IF W_LOOP_CNT NE 1. APPEND IT_TAB. ENDIF.
             CLEAR  SUM_ZFCKAMT.
          ENDIF.
       ENDIF.
       IF ( SV_ZFFIYR  NE IT_TAB_TMP-ZFFIYR ) OR
          ( SV_ZFACDO  NE IT_TAB_TMP-ZFACDO ).
          IF P_S = 'X'.
             CLEAR  IT_TAB.
             MOVE   SUM_ZFCKAMT  TO IT_TAB-ZFCKAMT.
             MOVE   'KRW'        TO IT_TAB-KRW.
             MOVE   SV_ZFFIYR    TO IT_TAB-ZFFIYR.
             MOVE   SV_ZFACDO    TO IT_TAB-ZFACDO.
             MOVE   'Y'          TO IT_TAB-SUM_MARK.
             IF W_LOOP_CNT NE 1. APPEND IT_TAB. ENDIF.
             CLEAR  SUM_ZFCKAMT.
          ENDIF.
       ENDIF.
       IF SV_ZFCSCD  NE IT_TAB_TMP-ZFCSCD.
          IF P_C = 'X'.
             CLEAR  IT_TAB.
             MOVE   SUM_ZFCKAMT  TO IT_TAB-ZFCKAMT.
             MOVE   'KRW'        TO IT_TAB-KRW.
             MOVE   SV_ZFCSCD    TO IT_TAB-ZFCSCD.
             SELECT SINGLE ZFCDNM INTO IT_TAB-ZFCSCD_NM
               FROM ZTIMIMG08
              WHERE ( ZFCDTY = '004' OR ZFCDTY = '005' )
                AND ZFCD = IT_TAB-ZFCSCD.
             MOVE   'Y'         TO IT_TAB-SUM_MARK.
             IF W_LOOP_CNT NE 1. APPEND IT_TAB. ENDIF.
             CLEAR  SUM_ZFCKAMT.
          ENDIF.
       ENDIF.

       CLEAR   IT_TAB.
       MOVE-CORRESPONDING IT_TAB_TMP TO IT_TAB.
       APPEND  IT_TAB.
       ADD  IT_TAB-ZFCKAMT TO SUM_ZFCKAMT.
       ADD  IT_TAB-ZFCKAMT TO TOT_ZFCKAMT.
       MOVE IT_TAB-ZFWERKS TO SV_ZFWERKS.
       MOVE IT_TAB-ZFVEN   TO SV_ZFVEN.
       MOVE IT_TAB-ZFPAY   TO SV_ZFPAY.
       MOVE IT_TAB-ZFFIYR  TO SV_ZFFIYR.
       MOVE IT_TAB-ZFACDO  TO SV_ZFACDO.
       MOVE IT_TAB-ZFCSCD  TO SV_ZFCSCD.
   ENDLOOP.

   IF P_T = 'X'.
      CLEAR  IT_TAB.
      MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
      MOVE   'KRW'       TO IT_TAB-KRW.
      MOVE   SV_ZFWERKS  TO IT_TAB-ZFWERKS.

      SELECT SINGLE NAME1 INTO IT_TAB-ZFWERKS_NM
        FROM T001W
       WHERE WERKS = IT_TAB-ZFWERKS.

      MOVE   'Y'        TO IT_TAB-SUM_MARK.
      APPEND IT_TAB.
   ENDIF.

   IF P_V = 'X'.
      CLEAR  IT_TAB.
      MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
      MOVE   'KRW'       TO IT_TAB-KRW.
      MOVE   SV_ZFVEN    TO IT_TAB-ZFVEN.
      SELECT SINGLE NAME1 INTO IT_TAB-ZFVEN_NM
        FROM LFA1
       WHERE LIFNR = IT_TAB-ZFVEN.
      MOVE   'Y'        TO IT_TAB-SUM_MARK.
      APPEND IT_TAB.
   ENDIF.
   IF P_P = 'X'.
      CLEAR  IT_TAB.
      MOVE   SUM_ZFCKAMT TO IT_TAB-ZFCKAMT.
      MOVE   'KRW'       TO IT_TAB-KRW.
      MOVE   SV_ZFPAY    TO IT_TAB-ZFPAY.
      SELECT SINGLE NAME1 INTO IT_TAB-ZFPAY_NM
        FROM LFA1
       WHERE LIFNR = IT_TAB-ZFPAY.
      MOVE   'Y'        TO IT_TAB-SUM_MARK.
      APPEND IT_TAB.
   ENDIF.
   IF P_S = 'X'.
      CLEAR  IT_TAB.
      MOVE   SUM_ZFCKAMT  TO IT_TAB-ZFCKAMT.
      MOVE   'KRW'        TO IT_TAB-KRW.
      MOVE   SV_ZFFIYR    TO IT_TAB-ZFFIYR.
      MOVE   SV_ZFACDO    TO IT_TAB-ZFACDO.
      MOVE   'Y'          TO IT_TAB-SUM_MARK.
      APPEND IT_TAB.
   ENDIF.
   IF P_C = 'X'.
      CLEAR  IT_TAB.
      MOVE   SUM_ZFCKAMT  TO IT_TAB-ZFCKAMT.
      MOVE   'KRW'        TO IT_TAB-KRW.
      MOVE   SV_ZFCSCD    TO IT_TAB-ZFCSCD.
      SELECT SINGLE ZFCDNM INTO IT_TAB-ZFCSCD_NM
        FROM ZTIMIMG08
       WHERE ( ZFCDTY = '004' OR ZFCDTY = '005' )
         AND ZFCD = IT_TAB-ZFCSCD.
      MOVE   'Y'         TO IT_TAB-SUM_MARK.
      APPEND IT_TAB.
   ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  DATA: INDEX       TYPE P,
        ZFBLNO      LIKE ZTCUCLCST-ZFBLNO,
        ZFFIYR      LIKE ZTCUCLCST-ZFFIYR,
        ZFACDO      LIKE ZTCUCLCST-ZFACDO.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  MOVE : W_LIST_INDEX       TO INDEX,
         IT_TAB-ZFBLNO      TO ZFBLNO,
         IT_TAB-ZFFIYR      TO ZFFIYR,
         IT_TAB-ZFACDO      TO ZFACDO.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : W_LIST_INDEX       TO INDEX,
                IT_TAB-ZFBLNO      TO IT_SELECTED-ZFBLNO,
                IT_TAB-ZFFIYR      TO IT_SELECTED-ZFFIYR,
                IT_TAB-ZFACDO      TO IT_SELECTED-ZFACDO.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_BL
*&---------------------------------------------------------------------*
FORM P2000_SHOW_BL USING    P_ZFBLNO.

  SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.
  SET PARAMETER ID 'ZPHBLNO' FIELD ''.

  EXPORT 'ZPBLNO'            TO MEMORY ID 'ZPBLNO'.
  CALL TRANSACTION 'ZIM23'   AND SKIP FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_BL

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_SL
*&---------------------------------------------------------------------*
FORM P2000_SHOW_SL USING    P_BUKRS  P_ZFFIYR P_ZFACDO.
DATA : L_AWKEY   LIKE   BKPF-AWKEY.

  CLEAR  : L_AWKEY, W_COUNT.
*>> �ļӹ��� ���翩�� CHECK!
  SELECT  COUNT( * )  INTO  W_COUNT
  FROM    EKBZ
  WHERE   GJAHR     EQ   P_ZFFIYR
  AND     BELNR     EQ   P_ZFACDO.
  IF W_COUNT GE 1.
     MOVE : P_ZFACDO  TO   L_AWKEY(10),
            P_ZFFIYR  TO   L_AWKEY+10(4).

     CLEAR : BKPF.
     SELECT * FROM BKPF UP TO 1 ROWS
              WHERE  AWKEY  EQ  L_AWKEY.
     ENDSELECT.
     IF SY-SUBRC EQ 0.
        SET  PARAMETER ID  'BUK'   FIELD   BKPF-BUKRS.
        SET  PARAMETER ID  'BLN'   FIELD   BKPF-BELNR.
        SET  PARAMETER ID  'GJR'   FIELD   BKPF-GJAHR.
        CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
     ENDIF.

  ELSE.
     SET PARAMETER ID 'BUK'     FIELD P_BUKRS.
     SET PARAMETER ID 'GJR'     FIELD P_ZFFIYR.
     SET PARAMETER ID 'BLN'     FIELD P_ZFACDO.
     CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
  ENDIF.

ENDFORM.                    " P2000_SHOW_SL

*&---------------------------------------------------------------------*
*&      Form  P3000_SUM_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_SUM_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.

  IF P_T = 'X'.  "Sort By Plant
     WRITE:/ SY-VLINE NO-GAP,
             (15) '�հ�'          NO-GAP, SY-VLINE NO-GAP,
             (16) IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW ,
             (3)  IT_TAB-KRW      NO-GAP, SY-VLINE NO-GAP,
                  IT_TAB-ZFWERKS,
                  IT_TAB-ZFWERKS_NM NO-GAP,
             135  SY-VLINE.
     WRITE :/ SY-ULINE.
  ENDIF.

  IF P_V = 'X'.  "Sort By Vendor
     WRITE:/ SY-VLINE NO-GAP,
             (15) '�հ�'          NO-GAP, SY-VLINE NO-GAP,
             (16) IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW ,
             (3)  IT_TAB-KRW      NO-GAP, SY-VLINE NO-GAP,
                  IT_TAB-ZFVEN,
                  IT_TAB-ZFVEN_NM NO-GAP,
             135  SY-VLINE.
     WRITE :/ SY-ULINE.
  ENDIF.

  IF P_P = 'X'.  "Sort By ����?
     WRITE:/ SY-VLINE NO-GAP,
             (15) '�հ�'          NO-GAP, SY-VLINE NO-GAP,
             (16) IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW ,
             (3)  IT_TAB-KRW      NO-GAP, SY-VLINE NO-GAP,
                  IT_TAB-ZFPAY,
                  IT_TAB-ZFPAY_NM NO-GAP,
             135  SY-VLINE.
     WRITE :/ SY-ULINE.
  ENDIF.

*  IF P_S = 'X'.  "Sort By ��ǥ��?
*     WRITE:/ SY-VLINE NO-GAP,
*       '�հ�      '            NO-GAP,
*       SY-VLINE                NO-GAP,
*       IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW NO-GAP, " ��ȭ��?
*       ' '                     NO-GAP,
*       IT_TAB-KRW              NO-GAP, " ��ȭ��?
*       SY-VLINE                NO-GAP,
*       IT_TAB-ZFFIYR           NO-GAP, " ȸ����ǥ ��?
*       '-'                     NO-GAP,
*       IT_TAB-ZFACDO           NO-GAP, " ȸ����ǥ ��?
*       '           '           NO-GAP,
*       SY-VLINE                NO-GAP,
*       '                                           ' NO-GAP,
*       '                                          '  NO-GAP,
*       SY-VLINE                NO-GAP.
*     WRITE : / SY-ULINE.
*  ENDIF.

  IF P_C = 'X'.  "Sort By �����?
     WRITE:/ SY-VLINE NO-GAP,
             (15) '�հ�'          NO-GAP, SY-VLINE NO-GAP,
             (16) IT_TAB-ZFCKAMT CURRENCY IT_TAB-KRW ,
             (3)  IT_TAB-KRW      NO-GAP, SY-VLINE NO-GAP,
                  IT_TAB-ZFCSCD,
                  IT_TAB-ZFCSCD_NM NO-GAP,
             135  SY-VLINE.
     WRITE :/ SY-ULINE.
  ENDIF.

ENDFORM.                    " P3000_SUM_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_PAY_TERM_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_ZTERM_LOW  text
*----------------------------------------------------------------------*
FORM P1000_PAY_TERM_HELP USING    P_ZTERM.

   TABLES : T052.

   CALL FUNCTION 'FI_F4_ZTERM'
         EXPORTING
              I_KOART       = 'K'
              I_ZTERM       = P_ZTERM
              I_XSHOW       = ' '
         IMPORTING
              E_ZTERM       = T052-ZTERM
         EXCEPTIONS
              NOTHING_FOUND = 01.

  IF SY-SUBRC NE 0.
*   message e177 with ekko-zterm.
    MESSAGE S177(06) WITH P_ZTERM.
    EXIT.
  ENDIF.

  IF T052-ZTERM NE SPACE.
     P_ZTERM = T052-ZTERM.
  ENDIF.

ENDFORM.                    " P1000_PAY_TERM_HELP
*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select
  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

  IF ZTIMIMG00-ZFPSMS NE 1.
     IF ZTIMIMG00-BLCSTMD NE 'X'.
        W_ERR_CHK = 'Y'.   MESSAGE S573.   EXIT.
     ENDIF.
  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK
