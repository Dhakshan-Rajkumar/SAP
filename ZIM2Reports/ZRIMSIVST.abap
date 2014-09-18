*&---------------------------------------------------------------------*
*& Report  ZRIMSIVST                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Simple Invoice ��Ȳ                                   *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.29.                                           *
*&---------------------------------------------------------------------*
*&   DESC. : 1.
*&           2. ���ޱ��� �ִ� Invoice�� �����ֱ� ���� ����Ʈ.
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMSIVST NO STANDARD PAGE HEADING MESSAGE-ID ZIM LINE-SIZE 116.

TABLES: ZTBL,                " Invoice Table..
        ZTIV,                " B/L Table..
        ZTCIVHD,
        ZTREQHD,             " �����Ƿ� HEADER TABLE.
        BAPICURR.

DATA: BEGIN OF IT_TAB OCCURS 1000,         " Internal Table IT_PO..
        ZFIVNO    LIKE   ZTIV-ZFIVNO,      " Invoice ������ȣ.
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,     " �����Ƿ� ������ȣ.
        ZFBLNO    LIKE   ZTIV-ZFBLNO,      " B/L ������ȣ.
        ZFCIVNO   LIKE   ZTCIVHD-ZFCIVNO,     " Commercial Invoice No.
        ZFIVST    LIKE   ZTIV-ZFCIVST,      " Invoice Verify ����.
        ZFIVAMT   LIKE   ZTIV-ZFIVAMT,     " Invoice �ݾ�.
        ZFIVAMC   LIKE   ZTIV-ZFIVAMC,     " Invoice �ݾ� ��ȭ.
        ZFIVAMK   LIKE   ZTIV-ZFIVAMK,     " Invoice �ݾ�(��ȭ).
        ZFKRW     LIKE   ZTIV-ZFKRW,       " ��ȭ��ȭ.
        ZFEXRT    LIKE   ZTIV-ZFEXRT,      " ȯ��.
        ZFPRPYN   LIKE   ZTCIVHD-ZFPRPYN,     " ���ޱ� ����.
        ZFHBLNO   LIKE   ZTBL-ZFHBLNO,     " House B/L No.
        ZFREBELN  LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O No.
        ZFOPNNO   LIKE   ZTBL-ZFOPNNO,     " �ſ���-���ι�ȣ.
      END OF IT_TAB.

DATA: W_ERR_CHK TYPE C,
      W_TABIX   TYPE I,
      TEXT(20)  TYPE C,
      TEMP      TYPE I.
*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_EBELN   FOR ZTBL-ZFREBELN,    " P/O No.
               S_OPNNO   FOR ZTBL-ZFOPNNO,     " L/C ���� No.
               S_HBLNO   FOR ZTBL-ZFHBLNO,     " House B/L No.
               S_BLNO    FOR ZTBL-ZFBLNO,      " B/L ������ȣ.
               S_CIVNO   FOR ZTCIVHD-ZFCIVNO,     " Commercial I/V No.
               S_IVNO    FOR ZTIV-ZFIVNO,      " I/V No.
               S_IVST    FOR ZTIV-ZFCIVST.      " Plant

SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.
*-----------------------------------------------------------------------
* TOP-OF-PAGE.
*-----------------------------------------------------------------------
TOP-OF-PAGE.

   PERFORM P3000_TITLE_WRITE.                "��� ���.

*-----------------------------------------------------------------------
* START-OF-SELECTION STATEMENT.
*-----------------------------------------------------------------------
START-OF-SELECTION.

   PERFORM P1000_READ_IV_DATA USING W_ERR_CHK.
   CHECK W_ERR_CHK NE 'Y'.

   PERFORM P3000_WRITE_IV_DATA.

*-----------------------------------------------------------------------
* END-OF-SELECTION STATEMENT.
*-----------------------------------------------------------------------
END-OF-SELECTION.
   SET TITLEBAR 'TIT1'.
   SET PF-STATUS 'ZIMR41'.

*-----------------------------------------------------------------------
* AT LINE-SELECTION.
*-----------------------------------------------------------------------
AT LINE-SELECTION.

DATA : L_TEXT(20).

  GET CURSOR FIELD L_TEXT.
  CASE L_TEXT.   " �ʵ��..
    WHEN 'IT_TAB-ZFCIVNO'.

       CHECK NOT IT_TAB-ZFIVNO IS INITIAL.
       SET PARAMETER ID 'ZPIVNO'  FIELD IT_TAB-ZFIVNO.
       SET PARAMETER ID 'ZPCIVNO' FIELD ''.
       CALL TRANSACTION 'ZIM33' AND SKIP FIRST SCREEN.

    WHEN 'IT_TAB-ZFREBELN'.
       SET PARAMETER ID 'BES' FIELD IT_TAB-ZFREBELN.
       CALL TRANSACTION 'ME23' AND SKIP FIRST SCREEN.

    WHEN 'IT_TAB-ZFREQNO'.
*       SET PARAMETER ID 'ZPREQNO' FIELD ''.
       SET PARAMETER ID 'ZPREQNO' FIELD IT_TAB-ZFREQNO.
       CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

    WHEN 'IT_TAB-ZFHBLNO'.
       SET PARAMETER ID 'ZPHBLNO' FIELD ''.
       SET PARAMETER ID 'ZPBLNO' FIELD IT_TAB-ZFBLNO.
       CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.

    WHEN 'IT_TAB-ZFIVNO'.
       SET PARAMETER ID 'ZPIVNO'  FIELD IT_TAB-ZFIVNO.
       SET PARAMETER ID 'ZPCIVNO' FIELD ''.
       CALL TRANSACTION 'ZIM33' AND SKIP FIRST SCREEN.

  ENDCASE.
  CLEAR: IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IV_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_IV_DATA USING    P_W_ERR_CHK.

   DATA: L_LINE_COUNT TYPE I.

   W_ERR_CHK = 'N'.

*   SELECT *
*     INTO CORRESPONDING FIELDS OF TABLE IT_TAB
*     FROM   ZTIV AS H INNER JOIN ZTBL AS I
*     ON     H~ZFBLNO EQ I~ZFBLNO
*     WHERE  "  H~ZFPRPYN EQ 'Y'
*       AND  I~ZFHBLNO     IN   S_HBLNO   " House B/L No.
*       AND  I~ZFBLNO      IN   S_BLNO    " B/L ������ȣ.
*       AND  H~ZFCIVNO     IN   S_CIVNO   " Commercial I/V No.
*       AND  H~ZFIVNO      IN   S_IVNO    " I/V No.
*       AND  H~ZFIVST      IN   S_IVST    " Invoice Verify ����.
*       AND  H~ZFREQNO     IN  ( SELECT ZFREQNO
*                              FROM ZTREQHD
*                              WHERE EBELN   IN  S_EBELN
*                              AND   ZFOPNNO IN  S_OPNNO
*                              AND   ZFOPNNO NE  SPACE ).
   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
         EXPORTING
            CURRENCY = IT_TAB-ZFIVAMC
            AMOUNT_INTERNAL = IT_TAB-ZFIVAMT
         IMPORTING
            AMOUNT_EXTERNAL = BAPICURR-BAPICURR.

      IT_TAB-ZFIVAMK = BAPICURR-BAPICURR * IT_TAB-ZFEXRT.
      MODIFY IT_TAB INDEX W_TABIX.
   ENDLOOP.

CLEAR W_TABIX.






ENDFORM.                    " P1000_READ_IV_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

   SKIP 2.
   WRITE: /45
            '[ Simple Invoice ��Ȳ ]' COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE: /100 'Date: ', 106 SY-DATUM.
   ULINE.

   FORMAT RESET.
   FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: /  SY-VLINE, 'Commercial Invoice No.'.
      WRITE: 39 SY-VLINE, 'P/O No.'.
      WRITE: 61 SY-VLINE, 'L/C ���� No.'.
      WRITE: 76 SY-VLINE, 'House B/L No.'.
      WRITE: 103 SY-VLINE.
      WRITE: 'I/V Status', 116 SY-VLINE.

      WRITE: / SY-VLINE, 'Invoice No.', 39 SY-VLINE,
              'Invoice �ݾ�.', 61 SY-VLINE,
               'ȯ��', 76 SY-VLINE, '��ȭ��ȭ.', 116 SY-VLINE.
      ULINE.
   FORMAT RESET.
ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IV_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_IV_DATA.
   FORMAT RESET.
   LOOP AT IT_TAB.
      TEMP = W_TABIX MOD 2.
      IF TEMP EQ 0.
      FORMAT COLOR COL_NORMAL INTENSIFIED ON.
      ELSE.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      ENDIF.
         WRITE: /  SY-VLINE, IT_TAB-ZFCIVNO.
         WRITE:    SY-VLINE, 49 IT_TAB-ZFREBELN.
         WRITE: 61 SY-VLINE, 65 IT_TAB-ZFREQNO.
         WRITE: 76 SY-VLINE, IT_TAB-ZFHBLNO.
         WRITE:    SY-VLINE.

      IF IT_TAB-ZFIVST EQ 'Y'.
         WRITE: IT_TAB-ZFIVST COLOR COL_GROUP INTENSIFIED ON,
            116 SY-VLINE.
      ELSE.
         WRITE: IT_TAB-ZFIVST COLOR COL_GROUP INTENSIFIED OFF,
            116 SY-VLINE.
      ENDIF.
      HIDE: IT_TAB.

      WRITE: / SY-VLINE, IT_TAB-ZFIVNO, 39 SY-VLINE,
               IT_TAB-ZFIVAMT CURRENCY IT_TAB-ZFIVAMC, SY-VLINE,
               IT_TAB-ZFEXRT, SY-VLINE, IT_TAB-ZFIVAMK CURRENCY 'KRW',
                                                        116 SY-VLINE.
      HIDE: IT_TAB.
      CLEAR: IT_TAB.

      ULINE.
      W_TABIX = SY-TABIX.
   ENDLOOP.
   FORMAT RESET.
   DESCRIBE TABLE IT_TAB LINES W_TABIX.
      IF W_TABIX = 0.
         W_ERR_CHK = 'Y'.
         MESSAGE S738.
         EXIT.
      ENDIF.
      WRITE: /100 '��:', 103 W_TABIX, '��'.

ENDFORM.                    " P3000_WRITE_IV_DATA
