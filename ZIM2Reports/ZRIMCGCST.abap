*&---------------------------------------------------------------------*
*& Report  ZRIMCGCST                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �Ͽ���� A/P Posting
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.03.23                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : �Ͽ� ����� ��ȸ�Ͽ� BDC�� Posting�Ѵ�.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&   1. 2000/03/24 : Posting BDC Function���� ����.
*&---------------------------------------------------------------------*
REPORT  ZRIMCGCST    MESSAGE-ID ZIM
                     LINE-SIZE 133
                     NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE : <ICON>,
          ZRIMCGCSTTOP,
          ZRIMBDCCOM,
          ZRIMBAIPTOP.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK            TYPE   C,
       ZFMSNM(25)      TYPE   C,
       ZFMSNO          LIKE   ZTCGHD-ZFMSNO,
       ZFCGPT          LIKE   ZTCGHD-ZFCGPT,
       ZFCGNO          LIKE   ZTCGCST-ZFCGNO,
       ZFCSQ           LIKE   ZTCGCST-ZFCSQ,
       BUKRS           LIKE   ZTCGCST-BUKRS,    ">ȸ���ڵ�.
       ZFCSCD          LIKE   ZTCGCST-ZFCSCD,   " ��뱸?
       ZFCSCD_NM(10)   TYPE   C,                " ����?
       ZFCAMT          LIKE   ZTCGCST-ZFCAMT,   " ����?
       WAERS           LIKE   ZTCGCST-WAERS,    " ��?
       ZFCKAMT         LIKE   ZTCGCST-ZFCKAMT,  " ����ȭ��?
       KRW             LIKE   ZTCGCST-ZFKRW,    " ��ȭ��?
       ZFEXRT          LIKE   ZTCGCST-ZFEXRT,   " Exchange Rate
       ZFVAT           LIKE   ZTCGCST-ZFVAT,    " V.A.T
       ZFOCDT          LIKE   ZTCGCST-ZFOCDT,   " ����?
       LIFNR           LIKE   ZTCGCST-LIFNR,    " Vendor
       ZFVEN_NM(20)    TYPE   C,                " Vendor ?
       ZFPAY           LIKE   ZTCGCST-ZFPAY,    " ����?
       ZFPAY_NM(20)    TYPE   C,                " ����ó?
       ZTERM           LIKE   ZTCGCST-ZTERM,    " Terms of Payment
       MWSKZ           LIKE   ZTCGCST-MWSKZ,    " Tax Code
       WERKS           LIKE   ZTCGCST-WERKS,  " Plant
       SUM_MARK        TYPE   C.
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_VEN    FOR ZTCGCST-LIFNR,     " Vendor
                   S_PAY    FOR ZTCGCST-ZFPAY,     " ����?
                   S_WERKS  FOR ZTCGCST-WERKS,     " Plant
                   S_OCDT   FOR ZTCGCST-ZFOCDT,    " �߻�?
                   S_MSNM   FOR ZTMSHD-ZFMSNM,     " �𼱸�.
                   S_CGPT   FOR ZTCGHD-ZFCGPT,     " �Ͽ���.
                   S_ZTERM  FOR ZTCGCST-ZTERM,     " Terms Of Payment
                   S_MWSKZ  FOR ZTCGCST-MWSKZ,     " Tax Code
                   S_CSCD   FOR ZTCGCST-ZFCSCD     " ��뱸��.
                            MATCHCODE OBJECT ZIC9.
SELECTION-SCREEN END OF BLOCK B1.

*>> �ʱⰪ SETTING.
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-LOW.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_ZTERM-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-HIGH.
   PERFORM   P1000_PAY_TERM_HELP  USING  S_ZTERM-HIGH.

* Title Text Write
TOP-OF-PAGE.
  IF INCLUDE NE 'POPU'.
     PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
  ENDIF.

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* Import System Configuration Check
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
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
            PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'POST'.                  " ���ó�� Posting
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766. EXIT.
            ENDIF.
            PERFORM P4000_COST_POST         USING W_ERR_CHK.
            DESCRIBE  TABLE IT_ERR_LIST   LINES  W_LINE.
            IF W_LINE GT 0.
               INCLUDE = 'POPU'.
               CALL SCREEN 0100 STARTING AT  05   3
                                ENDING   AT  100 12.
               CLEAR : INCLUDE.
            ENDIF.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            PERFORM RESET_LIST.
            IF W_ERR_CHK EQ 'Y'.
               MESSAGE S826 WITH W_PROC_CNT.
               LEAVE TO SCREEN 0.
            ENDIF.
            MESSAGE S826 WITH W_PROC_CNT.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
*            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
            PERFORM RESET_LIST.
            IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
*------- Abbrechen (CNCL) ----------------------------------------------
      WHEN 'CNCL'.
         SET SCREEN 0.    LEAVE SCREEN.
*------- Suchen (SUCH) -------------------------------------------------
      WHEN 'SUCH'.
*------- Sortieren nach Feldbezeichnung (SORB) -------------------------
      WHEN 'SORB'.
*------- Sortieren nach Feldname (SORF) --------------------------------
      WHEN 'SORF'.
*------- Techn. Name ein/aus (TECH) ------------------------------------
      WHEN 'TECH'.
*------- Weiter suchen (WESU) ------------------------------------------
      WHEN 'WESU'.
      WHEN OTHERS.
   ENDCASE.

*-----------------------------------------------------------------------
*&   Event AT LINE-SELECTION
*-----------------------------------------------------------------------
AT LINE-SELECTION.
   CASE INCLUDE.
      WHEN 'POPU'.
         IF NOT IT_ERR_LIST-MSGTYP IS INITIAL.
            MESSAGE ID IT_ERR_LIST-MSGID TYPE IT_ERR_LIST-MSGTYP
                    NUMBER IT_ERR_LIST-MSGNR
                    WITH   IT_ERR_LIST-MSGV1
                           IT_ERR_LIST-MSGV2
                           IT_ERR_LIST-MSGV3
                           IT_ERR_LIST-MSGV4.
         ENDIF.
         CLEAR : IT_ERR_LIST.
     WHEN OTHERS.
  ENDCASE.


*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.
   SET  TITLEBAR 'ZIMV8'.           " GUI TITLE SETTING..

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50  '[ �Ͽ� ��� A/P POSTING ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 115 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE NO-GAP,
            '�𼱸�                   '      NO-GAP, SY-VLINE NO-GAP,
            '��뱸��      '                 NO-GAP, SY-VLINE NO-GAP,
            '          �߻��ݾ�      '       NO-GAP, SY-VLINE NO-GAP,
            '              V.A.T'            NO-GAP, SY-VLINE NO-GAP,
            '������    '                     NO-GAP, SY-VLINE NO-GAP,
            'Vendor                        ' NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',                           SY-VLINE NO-GAP,
            '�Ͽ���ȣ  '                     NO-GAP, SY-VLINE NO-GAP,
            '�Ͽ���        '                 NO-GAP, SY-VLINE NO-GAP,
            'ȯ��          '                 NO-GAP, SY-VLINE NO-GAP,
            '          ��ȭ�ݾ�      '       NO-GAP, SY-VLINE NO-GAP,
            'Comp/Term/Tax/Plant'            NO-GAP,
            '           '                    NO-GAP, SY-VLINE NO-GAP,
            '����ó                        ' NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

  CLEAR : SV_ZFVEN, SV_ZFPAY, SV_ZTERM, SV_MWSKZ, SV_ZFWERKS,
          SUM_ZFCKAMT, SUM_ZFVAT, W_LOOP_CNT.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIMV8'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMV8'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
*      PERFORM P2000_PAGE_CHECK.
*>> �ʱ� �񱳰� MOVE.
      IF W_LINE  =  1.
         MOVE   IT_TAB-BUKRS    TO  SV_BUKRS.
         MOVE   IT_TAB-LIFNR    TO  SV_ZFVEN.
         MOVE   IT_TAB-ZFPAY    TO  SV_ZFPAY.
         MOVE   IT_TAB-ZTERM    TO  SV_ZTERM.
         MOVE   IT_TAB-MWSKZ    TO  SV_MWSKZ.
         MOVE   IT_TAB-WERKS    TO  SV_ZFWERKS.
         MOVE   IT_TAB-ZFVEN_NM TO  SV_ZFVEN_NM.
         MOVE   IT_TAB-ZFPAY_NM TO  SV_ZFPAY_NM.
      ENDIF.
*>> �񱳰��� Ʋ���� SUM WRITE.
      IF SV_ZFVEN    NE  IT_TAB-LIFNR  OR
         SV_ZFPAY    NE  IT_TAB-ZFPAY  OR
         SV_ZTERM    NE  IT_TAB-ZTERM  OR
         SV_MWSKZ    NE  IT_TAB-MWSKZ  OR
         SV_BUKRS    NE  IT_TAB-BUKRS  OR
         SV_ZFWERKS  NE  IT_TAB-WERKS.

         PERFORM P3000_SUM_LINE_WRITE.

         MOVE   IT_TAB-BUKRS    TO  SV_BUKRS.
         MOVE   IT_TAB-LIFNR    TO  SV_ZFVEN.
         MOVE   IT_TAB-ZFPAY    TO  SV_ZFPAY.
         MOVE   IT_TAB-ZTERM    TO  SV_ZTERM.
         MOVE   IT_TAB-MWSKZ    TO  SV_MWSKZ.
         MOVE   IT_TAB-WERKS    TO  SV_ZFWERKS.
         MOVE   IT_TAB-ZFVEN_NM TO  SV_ZFVEN_NM.
         MOVE   IT_TAB-ZFPAY_NM TO  SV_ZFPAY_NM.
         MOVE   0               TO  SUM_ZFCKAMT.
         MOVE   0               TO  SUM_ZFVAT.
      ENDIF.

      PERFORM P3000_LINE_WRITE.
      ADD       IT_TAB-ZFCKAMT  TO  SUM_ZFCKAMT.
      ADD       IT_TAB-ZFVAT    TO  SUM_ZFVAT.

      AT LAST.
         PERFORM P3000_SUM_LINE_WRITE.
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
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

  WRITE:/ SY-VLINE, '  '       NO-GAP,
       SY-VLINE                NO-GAP,
       IT_TAB-ZFMSNM           NO-GAP, " L/C No
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCSCD           NO-GAP, " ��뱸?
       ' '                     NO-GAP,
       IT_TAB-ZFCSCD_NM        NO-GAP, " ����?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCAMT CURRENCY IT_TAB-WAERS NO-GAP, " ����?
       IT_TAB-WAERS            NO-GAP, " �ݾ���?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFVAT  CURRENCY IT_TAB-KRW   NO-GAP, " V.A.T
       SY-VLINE                NO-GAP,
       IT_TAB-ZFOCDT           NO-GAP, " ����?
       SY-VLINE                NO-GAP,
       IT_TAB-LIFNR            NO-GAP, " Vendor
       IT_TAB-ZFVEN_NM         NO-GAP, " Vendor ?
       SY-VLINE                NO-GAP.

       FORMAT COLOR COL_BACKGROUND.
       WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
       IT_TAB-ZFCGNO           NO-GAP, " �����Ƿ� ������?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCGPT           NO-GAP, " ����?
       '           '           NO-GAP,
       SY-VLINE                NO-GAP,
       '  '                    NO-GAP,
       IT_TAB-ZFEXRT           NO-GAP, " Exchange Rate
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCKAMT  CURRENCY IT_TAB-KRW NO-GAP, " ����ȭ��?
       IT_TAB-KRW              NO-GAP, " ��ȭ��?
       SY-VLINE                NO-GAP,
       IT_TAB-BUKRS            NO-GAP, " COMPANY CODE.
       '/'                     NO-GAP,
       IT_TAB-ZTERM            NO-GAP, " Terms Of Payment
       '/'                     NO-GAP,
       IT_TAB-MWSKZ            NO-GAP, " Tax Code
       ' /'                    NO-GAP,
       IT_TAB-WERKS            NO-GAP, " Plant
       '            '          NO-GAP,
       SY-VLINE                NO-GAP,
       IT_TAB-ZFPAY            NO-GAP, " ����?
       IT_TAB-ZFPAY_NM         NO-GAP, " ����ó ?
       SY-VLINE                NO-GAP.

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

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 1.
     MESSAGE S738.   EXIT.
  ENDIF.

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

  REFRESH : IT_TAB.

* ������ �𼱸� �ش��ϴ� �𼱹�ȣ SELECT.
  SELECT ZFMSNO  ZFMSNM
  INTO   CORRESPONDING FIELDS OF TABLE IT_MSNO
  FROM   ZTMSHD
  WHERE  ZFMSNM    IN  S_MSNM .

* �ش� ȭ���� ���ǿ� �ش��ϴ� DATA SETTING!
  SELECT I~ZFMSNO  I~ZFCGPT  I~ZFCGNO  H~ZFCSQ    H~BUKRS
         H~ZFCSCD  H~ZFCAMT  H~WAERS   H~ZFCKAMT  H~ZFKRW
         H~ZFEXRT  H~ZFVAT   H~ZFOCDT  H~LIFNR    H~ZFPAY
         H~ZTERM   H~MWSKZ   H~WERKS
  INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM   ZTCGCST AS H INNER JOIN ZTCGHD AS I
  ON     H~ZFCGNO     EQ    I~ZFCGNO
  FOR ALL ENTRIES     IN    IT_MSNO
  WHERE  H~LIFNR      IN    S_VEN
  AND    H~ZFPAY      IN    S_PAY
  AND    H~WERKS      IN    S_WERKS
  AND    H~ZFOCDT     IN    S_OCDT
  AND    I~ZFCGPT     IN    S_CGPT
  AND    H~MWSKZ      IN    S_MWSKZ
  AND    H~ZTERM      IN    S_ZTERM
  AND    H~ZFCSCD     IN    S_CSCD
  AND    I~ZFMSNO     EQ    IT_MSNO-ZFMSNO
  AND    H~ZFCKAMT    GT    0
  AND    ( H~BELNR    EQ    SPACE
  OR       H~BELNR    IS    NULL  ).

  SELECT  *  INTO CORRESPONDING FIELDS OF TABLE IT_ZTIMIMG08
  FROM       ZTIMIMG08
  WHERE      ZFCDTY  =  '007'   AND  ZFCD1  =  'N'.

*>> INTERNAL TABLE �� VENDOR ��, ����ó��, ���� DISPLAY
  LOOP  AT  IT_TAB.

    W_TABIX  =  SY-TABIX.
    SELECT SINGLE  NAME1  INTO  IT_TAB-ZFVEN_NM
    FROM   LFA1    WHERE  LIFNR EQ  IT_TAB-LIFNR.

    SELECT SINGLE  NAME1  INTO  IT_TAB-ZFPAY_NM
    FROM   LFA1    WHERE  LIFNR EQ  IT_TAB-ZFPAY.

    READ  TABLE  IT_MSNO  WITH KEY ZFMSNO = IT_TAB-ZFMSNO.
    IF SY-SUBRC  EQ  0.
       MOVE  IT_MSNO-ZFMSNM  TO  IT_TAB-ZFMSNM.
    ENDIF.

    READ TABLE IT_ZTIMIMG08  WITH KEY ZFCD = IT_TAB-ZFCSCD.
    IF  SY-SUBRC NE 0.
        DELETE  IT_TAB  INDEX  W_TABIX.
        CONTINUE.
    ELSE.
        MOVE  IT_ZTIMIMG08-ZFCDNM   TO  IT_TAB-ZFCSCD_NM.
    ENDIF.
    MOVE  'KRW'   TO  IT_TAB-KRW.
    MODIFY  IT_TAB  INDEX  W_TABIX.

  ENDLOOP.
*>> �������� ���� DATA GET!
  SELECT  SINGLE *  FROM  ZTIMIMG11.

  SORT  IT_TAB  BY  BUKRS  LIFNR  ZFPAY  ZTERM  MWSKZ  WERKS.

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
     MESSAGE S738.   W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : SV_BUKRS       TO IT_SELECTED-BUKRS,
                SV_ZFVEN       TO IT_SELECTED-ZFVEN,
                SV_ZFPAY       TO IT_SELECTED-ZFPAY,
                SV_ZTERM       TO IT_SELECTED-ZTERM,
                SV_MWSKZ       TO IT_SELECTED-MWSKZ,
                SV_ZFWERKS     TO IT_SELECTED-ZFWERKS,
                SUM_ZFCKAMT    TO IT_SELECTED-ZFCKAMT,
                SUM_ZFVAT      TO IT_SELECTED-ZFVAT.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION

*&---------------------------------------------------------------------*
*&      Form  P3000_SUM_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_SUM_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE         NO-GAP,
       '                         '  NO-GAP,
       '               '            NO-GAP,
       SY-VLINE         NO-GAP,
       SUM_ZFCKAMT CURRENCY 'KRW'   NO-GAP, " ����?
       'KRW  '          NO-GAP,
       SY-VLINE         NO-GAP,
       SUM_ZFVAT   CURRENCY 'KRW'   NO-GAP,   " VAT
       SY-VLINE         NO-GAP,
       '          '     NO-GAP,
       SY-VLINE         NO-GAP,
       SV_ZFVEN         NO-GAP,                  " Vendor
       SV_ZFVEN_NM      NO-GAP,                  " Vendor ?
       SY-VLINE         NO-GAP.
* Hide
       HIDE: SV_BUKRS, SV_ZTERM, SV_MWSKZ, SV_ZFWERKS, SV_ZFVEN,
             SV_ZFPAY, SUM_ZFCKAMT, SUM_ZFVAT.

       WRITE : / SY-VLINE, ' ', SY-VLINE  NO-GAP,
       '                         '        NO-GAP,
       '               '         NO-GAP,
       SY-VLINE   NO-GAP,
       '            '            NO-GAP,
       '            '            NO-GAP,
       SY-VLINE   NO-GAP,
       SV_BUKRS                  NO-GAP, " COMPANY CODE.
       '/'                       NO-GAP,
       SV_ZTERM                  NO-GAP, " Terms Of Payment
       '/'                       NO-GAP,
       SV_MWSKZ                  NO-GAP, " Tax Code
       ' /'                      NO-GAP,
       SV_ZFWERKS                NO-GAP, " Plant
       ' '                       NO-GAP,
       SY-VLINE                  NO-GAP,
       '          '              NO-GAP,
       SY-VLINE                  NO-GAP,
       SV_ZFPAY                  NO-GAP, " ����?
       SV_ZFPAY_NM               NO-GAP, " ����ó ?
       SY-VLINE                  NO-GAP.


  HIDE: SV_BUKRS, SV_ZTERM, SV_MWSKZ, SV_ZFWERKS, SV_ZFVEN,
        SV_ZFPAY, SUM_ZFCKAMT, SUM_ZFVAT.

  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_SUM_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P4000_COST_POST
*&---------------------------------------------------------------------*
FORM P4000_COST_POST USING    P_W_ERR_CHK.
  REFRESH : IT_ERR_LIST.
  MOVE 'N' TO W_ERR_CHK.
  CLEAR W_PROC_CNT.

*>> MESSAGE BOX.
  PERFORM P4000_GET_INIVAL.
  IF ANWORT NE 'Y'.
     EXIT.
  ENDIF.

  LOOP AT IT_SELECTED.
     REFRESH : IT_LOCKED.
*>> ���� ����....
     IF IT_SELECTED-BUKRS IS INITIAL.
        MESSAGE S167 WITH 'Company code'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED-ZTERM IS INITIAL.
        MESSAGE S167 WITH 'Payment notice'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED-ZFVEN IS INITIAL.
        MESSAGE S167 WITH 'Vendor code'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED-ZFWERKS IS INITIAL.
        MESSAGE S167 WITH 'Plant'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
*>> �ش� ���Ժ��.
     REFRESH  : IT_ZTCGCST.
     LOOP AT IT_TAB WHERE  BUKRS   EQ   IT_SELECTED-BUKRS
                    AND    LIFNR   EQ   IT_SELECTED-ZFVEN
                    AND    ZFPAY   EQ   IT_SELECTED-ZFPAY
                    AND    ZTERM   EQ   IT_SELECTED-ZTERM
                    AND    MWSKZ   EQ   IT_SELECTED-MWSKZ
                    AND    WERKS   EQ   IT_SELECTED-ZFWERKS.

        SELECT *  APPENDING TABLE IT_ZTCGCST
                  FROM   ZTCGCST
                  WHERE  ZFCGNO   EQ   IT_TAB-ZFCGNO
                  AND    ZFCSQ    EQ   IT_TAB-ZFCSQ.

     ENDLOOP.
*>> LOCK MODE.
    CLEAR : W_LOCK_CHK.
    SORT IT_ZTCGCST BY ZFCGNO.
    LOOP AT IT_ZTCGCST.
       ON CHANGE OF IT_ZTCGCST-ZFCGNO.
           PERFORM  P2000_SET_LOCK_MODE   USING IT_ZTCGCST-ZFCGNO
                                               'L'    W_SUBRC.
         IF SY-SUBRC EQ 0.
            MOVE IT_ZTCGCST-ZFCGNO TO IT_LOCKED-ZFCGNO.
            APPEND IT_LOCKED.
         ELSE.
            W_LOCK_CHK = 'Y'.
            PERFORM  P2000_SINGLE_MESS_MAKE.
            EXIT.
         ENDIF.
      ENDON.
   ENDLOOP.

     IF W_LOCK_CHK EQ 'Y'.
        CONTINUE.
     ENDIF.
*>> BAPIs Function
*     PERFORM  P2000_GL_DATA_MAKE    USING   W_SUBRC.
**>> BDC DATA MAKE.
     PERFORM COST_BDC_INSERT.
*>>PARAMETER CLEAR.
     SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
     SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.

*>> BDC CALL.
     PERFORM P2000_CALL_TRANSACTION USING     'F-42'
                                              W_SUBRC.

     IF W_SUBRC NE 0.      ">> ERROR �߻���.
        PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
        ADD    1    TO    W_ERR_CNT.
        CONTINUE.
     ELSE.                 ">> SUCCESS ��.
        GET PARAMETER ID 'BLN' FIELD ZFACDO.        " ��ǥ��ȣ.
        GET PARAMETER ID 'GJR' FIELD ZFFIYR.        " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
        IF ZFACDO IS INITIAL AND ZFFIYR IS INITIAL.
*>>> ����..(����� ���� ��....)
           MESSAGE S494.
           PERFORM  P2000_SINGLE_MESS_MAKE.
           CONTINUE.
        ENDIF.

        LOOP AT IT_ZTCGCST.
           MOVE : ZFACDO      TO     IT_ZTCGCST-BELNR,
                  ZFFIYR      TO     IT_ZTCGCST-GJAHR,
                  W_POSDT     TO     IT_ZTCGCST-ZFPSDT,
                  W_DOCDT     TO     IT_ZTCGCST-ZFOCDT,
                  SY-UNAME    TO     IT_ZTCGCST-UNAM,
                  SY-DATUM    TO     IT_ZTCGCST-UDAT.
           MODIFY  IT_ZTCGCST  INDEX   SY-TABIX.
        ENDLOOP.
        MODIFY ZTCGCST FROM TABLE IT_ZTCGCST.
        PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
       ENDIF.
       ADD 1       TO W_PROC_CNT.
  ENDLOOP.

ENDFORM.                    " P4000_COST_POST

*&---------------------------------------------------------------------*
*&      Form  P4000_GET_INIVAL
*&---------------------------------------------------------------------*
FORM P4000_GET_INIVAL.

  MOVE 'Initial Value' TO SPOP-TITEL.
*  MOVE 'X'             TO RADIO_NONE.
  IF W_POSDT IS INITIAL.
     MOVE SY-DATUM    TO W_POSDT.
  ENDIF.
  IF W_DOCDT IS INITIAL.
     MOVE SY-DATUM    TO W_DOCDT.
  ENDIF.

  CALL SCREEN 0010 STARTING AT 15 1
                   ENDING   AT 56 14.

  IF RADIO_NONE = 'X'.
     DISP_MODE = 'N'.
  ENDIF.
  IF RADIO_ALL = 'X'.
     DISP_MODE = 'A'.
  ENDIF.
  IF RADIO_ERROR = 'X'.
     DISP_MODE = 'E'.
  ENDIF.


ENDFORM.                    " P4000_GET_INIVAL

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
  IF OK-CODE EQ 'ENTR' OR OK-CODE EQ 'YES'.
     ANWORT = 'Y'.
     SET SCREEN 0.
     LEAVE SCREEN.
  ELSEIF OK-CODE EQ 'CANC' OR OK-CODE EQ 'NO'.
     ANWORT = 'N'.
     SET SCREEN 0.   LEAVE SCREEN.
  ENDIF.
ENDMODULE.                 " GET_OK_CODE_SCR0010  INPUT

*&---------------------------------------------------------------------*
*&      Form  COST_BDC_INSERT
*&---------------------------------------------------------------------*
FORM COST_BDC_INSERT.
DATA :   L_ZFPAY     LIKE   IT_SELECTED-ZFPAY,
         L_ZFIOCAC1  LIKE   ZTIMIMG11-ZFIOCAC1.

  L_ZFIOCAC1 = ZTIMIMG11-ZFIOCAC12.

  W_WRBTR = IT_SELECTED-ZFCKAMT + IT_SELECTED-ZFVAT.
  WRITE W_WRBTR CURRENCY 'KRW' TO TEMP_WRBTR.
  WRITE IT_SELECTED-ZFVAT CURRENCY 'KRW' TO TEMP_WMWST.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View�� �ƴϱ� ������ Select�� ������ �߻��ϴ� �� ����????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.
  SELECT SINGLE * FROM ZVT001W
                  WHERE WERKS EQ IT_SELECTED-ZFWERKS.
*>> ����ó�� �ٸ� ���.
  IF NOT ( IT_SELECTED-ZFPAY IS INITIAL ) AND
         ( IT_SELECTED-ZFVEN NE IT_SELECTED-ZFPAY ).
     L_ZFPAY  =  IT_SELECTED-ZFPAY. " Payee
  ELSE.
     CLEAR L_ZFPAY.
  ENDIF.

  REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   W_DOCDT,            " Document Date
      ' ' 'BKPF-BLART'  'KR',                " Type
      ' ' 'BKPF-BUKRS'   IT_SELECTED-BUKRS,  " Company Code
      ' ' 'BKPF-BUDAT'   W_POSDT,            " Posting Date
      ' ' 'BKPF-BLDAT'   W_DOCDT,            " Document Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " ȯ��.
      ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
      ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
      ' ' 'BKPF-XBLNR'  SPACE,               " ����������ȣ.
      ' ' 'BKPF-BVORG'  SPACE,               " ȸ���ڵ尣 �ŷ���ȣ.
      ' ' 'BKPF-BKTXT'  '�Ͽ� ���',          " ��ǥ����ؽ�Ʈ.
      ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
      ' ' 'RF05A-NEWBS' '31',                " Posting Key
      ' ' 'RF05A-NEWKO'  IT_SELECTED-ZFVEN,  " Account
      ' ' 'RF05A-NEWUM'  SPACE,              "���� �����׸�Ư�� G/L����.
      ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

* NEXT SCREEN.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0302',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
      ' ' 'BSEG-WMWST'  TEMP_WMWST,            " Tax
      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
      ' ' 'BSEG-MWSKZ'  IT_SELECTED-MWSKZ,     " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
      ' ' 'BSEG-ZTERM'  IT_SELECTED-ZTERM,     " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '�Ͽ� ���',             " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '40',                  " Posting Key
      ' ' 'RF05A-NEWKO' L_ZFIOCAC1,            " ACCOUNT
      ' ' 'BDC_OKCODE'  '/00'.                 " ENTER

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0300',
      ' ' 'BSEG-WRBTR'  '*',          " Amount
*      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,  " Amount
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'COBL-KOSTL'  COBL-KOSTL,            " Cost center.
*      ' ' 'COBL-PRCTR'  COBL-PRCTR,            " ���ͼ���.
      ' ' 'BSEG-SGTXT'  '�Ͽ� ���',              " �ؽ�Ʈ.
      ' ' 'BDC_OKCODE'  'BU'.                   " ����.

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
*      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " COST_BDC_INSERT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_SCREEN_SCR0010 OUTPUT.

  AUTHORITY-CHECK OBJECT 'ZM_BDC_MGT'
                  ID 'ACTVT' FIELD '*'.
  W_SY_SUBRC = SY-SUBRC.

  LOOP AT SCREEN.

    IF W_SY_SUBRC NE 0 AND SY-DYNNR EQ '0010'.
       IF SCREEN-NAME(10) EQ 'RADIO_NONE'  OR
          SCREEN-NAME(09) EQ 'RADIO_ALL'   OR
          SCREEN-NAME(11) EQ 'RADIO_ERROR' OR
          SCREEN-NAME(06) EQ 'BLOCK2'.
          SCREEN-INVISIBLE = 1.
       ENDIF.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.

ENDMODULE.                 " MODIFY_SCREEN_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT_FIELD_SCR0010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_INPUT_FIELD_SCR0010 INPUT.

  IF NOT ( OK-CODE EQ 'YES' OR OK-CODE EQ 'ENTR' ).
     EXIT.
  ENDIF.

   IF W_POSDT IS INITIAL.
      MESSAGE E167 WITH 'Evidence date'.
   ENDIF.
   IF W_DOCDT IS INITIAL.
      MESSAGE E167 WITH 'Posting date'.
   ENDIF.
   IF BSEG-GSBER IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'BSEG' 'GSBER'.
   ENDIF.

ENDMODULE.                 " CHECK_INPUT_FIELD_SCR0010  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_ERR_LIST  text
*----------------------------------------------------------------------*
FORM P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST  STRUCTURE IT_ERR_LIST.

   LOOP AT MESSTAB.

      MOVE : MESSTAB-MSGTYP           TO     IT_ERR_LIST-MSGTYP,
             MESSTAB-MSGID            TO     IT_ERR_LIST-MSGID,
             MESSTAB-MSGNR            TO     IT_ERR_LIST-MSGNR,
             MESSTAB-MSGV1            TO     IT_ERR_LIST-MSGV1,
             MESSTAB-MSGV2            TO     IT_ERR_LIST-MSGV2,
             MESSTAB-MSGV3            TO     IT_ERR_LIST-MSGV3,
             MESSTAB-MSGV4            TO     IT_ERR_LIST-MSGV4.

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
         WHEN 'E'.
            MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
         WHEN 'I'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'S'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'W'.
            MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
         WHEN OTHERS.
            MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
      ENDCASE.

      APPEND  IT_ERR_LIST.

   ENDLOOP.
*>> UNLOCKED.
   LOOP AT IT_LOCKED.
      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFCGNO
                                           'U'    W_SUBRC.
   ENDLOOP.


ENDFORM.                    " P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*&      Module  D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_STATUS_SCR0100 OUTPUT.
  SET PF-STATUS 'STDLISW'.

  CASE INCLUDE.
     WHEN 'POPU'.
        SET TITLEBAR 'POPU' WITH 'Error LIST'.
     WHEN OTHERS.
  ENDCASE.

  SUPPRESS DIALOG.

ENDMODULE.                 " D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_LIST_CHECK_SCR0100 INPUT.
   LEAVE TO LIST-PROCESSING.
   CASE INCLUDE.
      WHEN 'POPU'.
         FORMAT COLOR COL_HEADING INTENSIFIED OFF.
         WRITE : / SY-ULINE(96),    /   SY-VLINE NO-GAP,
                   'Type'   NO-GAP,     SY-VLINE NO-GAP,
                   'Message Text',  94 SY-VLINE NO-GAP,
                   'T'      NO-GAP,     SY-VLINE,
                 / SY-ULINE(96).
         LOOP AT IT_ERR_LIST.
            W_MOD  =  SY-TABIX MOD 2.
            FORMAT RESET.
            IF W_MOD EQ 0.
               FORMAT COLOR COL_NORMAL  INTENSIFIED ON.
            ELSE.
               FORMAT COLOR COL_NORMAL  INTENSIFIED OFF.
            ENDIF.
            WRITE : / SY-VLINE NO-GAP, IT_ERR_LIST-ICON(4) NO-GAP,
                      SY-VLINE NO-GAP, IT_ERR_LIST-MESSTXT(87) NO-GAP,
                      SY-VLINE NO-GAP.

            CASE IT_ERR_LIST-MSGTYP.
               WHEN 'E'.
                  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
               WHEN 'W'.
                  FORMAT COLOR COL_KEY      INTENSIFIED OFF.
               WHEN 'I'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
               WHEN 'S'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
            ENDCASE.

            WRITE : IT_ERR_LIST-MSGTYP(1) NO-GAP, SY-VLINE NO-GAP.
*                   / SY-ULINE(96).
            HIDE:IT_ERR_LIST.
         ENDLOOP.
         WRITE : / SY-ULINE(96).
         CLEAR : IT_ERR_LIST.
      WHEN OTHERS.
   ENDCASE.

ENDMODULE.                 " D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_SINGLE_MESS_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SINGLE_MESS_MAKE.

   REFRESH : MESSTAB.
   MOVE : 'E'                 TO     MESSTAB-MSGTYP,
          SY-MSGID            TO     MESSTAB-MSGID,
          SY-MSGNO            TO     MESSTAB-MSGNR,
          SY-MSGV1            TO     MESSTAB-MSGV1,
          SY-MSGV2            TO     MESSTAB-MSGV2,
          SY-MSGV3            TO     MESSTAB-MSGV3,
          SY-MSGV4            TO     MESSTAB-MSGV4.
   APPEND MESSTAB.

   PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.

*>> UNLOCKED.
   LOOP AT IT_LOCKED.
      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFCGNO
                                           'U'    W_SUBRC.
   ENDLOOP.

ENDFORM.                    " P2000_SINGLE_MESS_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1489   text
*      -->P_W_SUBRC  text
*----------------------------------------------------------------------*
FORM P2000_SET_LOCK_MODE USING    P_ZFCGNO
                                  PA_MODE
                                  W_SUBRC.
  IF PA_MODE EQ 'L'.
    CALL FUNCTION 'ENQUEUE_EZ_IM_ZTCGHD'
         EXPORTING
              ZFCGNO = P_ZFCGNO
         EXCEPTIONS
              OTHERS  = 1.

    W_SUBRC = SY-SUBRC.

    IF W_SUBRC <> 0.
       MESSAGE S510 WITH SY-MSGV1 'Loading/Unloading Doc'
                         P_ZFCGNO ''
                    RAISING DOCUMENT_LOCKED.
    ENDIF.
  ELSEIF PA_MODE EQ 'U'.

    CALL FUNCTION 'DEQUEUE_EZ_IM_ZTCGHD'
         EXPORTING
              ZFCGNO = P_ZFCGNO.

    W_SUBRC = SY-SUBRC.
    IF W_SUBRC <> 0.
       MESSAGE S510 WITH SY-MSGV1 'Loading/Unloading Doc'
                         P_ZFCGNO ''
                    RAISING DOCUMENT_LOCKED.
    ENDIF.
  ENDIF.

ENDFORM.                    " P2000_SET_LOCK_MODE
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
*&      Form  P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
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
     W_ERR_CHK = 'Y'.   MESSAGE S573.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK
