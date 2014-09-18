*&---------------------------------------------------------------------*
*& Report  ZRIMLLCTQ                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Local L/C�� �ŷ�������?
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.06.26                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : Local L/C�� �ŷ�������Ȳ�� ��ȸ�Ѵ�.
*&                                                                     *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMLLCTQ    MESSAGE-ID ZIM
                     LINE-SIZE 105
                     NO STANDARD PAGE HEADING.

DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFGFDYR         LIKE   ZTVTIV-ZFGFDYR,    " ���� ȸ����ǥ��?
       ZFGFDNO         LIKE   ZTVTIV-ZFGFDNO,    " ���� ȸ����ǥ��?
       ZFIVAMT         LIKE   ZTVTIVIT-ZFIVAMT,  " �߻���?
       ZFKAMT          LIKE   ZTVTIVIT-ZFKAMT,   " �߻��ݾ�(��ȭ)
       ZFIVAMT_1       LIKE   ZTVTIVIT-ZFIVAMT,  " ������?
       ZFKAMT_1        LIKE   ZTVTIVIT-ZFKAMT,   " �����ݾ�(��ȭ)
       ZFREDNO         LIKE   ZTVTIV-ZFREDNO,    " �μ��� ������?
       ZFVTNO          LIKE   ZTVTIV-ZFVTNO,     " ���ݰ�꼭 ������?
       ZFDODT          LIKE   ZTVTIV-ZFDODT,     " �μ���(�ۼ���)
       ZFIVAMT_2       LIKE   ZTVTIVIT-ZFIVAMT,  " ������?
       ZFKAMT_2        LIKE   ZTVTIVIT-ZFKAMT.   " �����ݾ�(��ȭ)
DATA : END OF IT_TAB.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMLLCTQTOP.

INCLUDE   ZRIMSORTCOM.    " Sort�� ���� Include

INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(12) TEXT-001, POSITION 15.
        PARAMETERS : P_OPNNO LIKE ZTREQHD-ZFOPNNO.  " L/C No
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.                          " �ʱⰪ SETTING
  PERFORM   P2000_INIT.

* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.
* Import System Config Check
*  PERFORM   P2000_CONFIG_CHECK        USING   W_ERR_CHK.
*  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_TEXT        USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE       USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'DSRQ'.                   " �����Ƿ� ��?
            PERFORM P2000_SHOW_LC USING W_ZFREQNO.
      WHEN 'BAC1' OR 'EXIT' OR 'CANC'.
            LEAVE TO SCREEN 0.                " ��?
      WHEN OTHERS.
   ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /35  '[ Local L/C�� �ŷ����� ��Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM,  87 'Page : ', W_PAGE.
  WRITE : /.
  WRITE : /2  'L/C NO : '   NO-GAP, W_ZFOPNNO,
           40 '������ȣ : ' NO-GAP, W_ZFREQNO,
           86 '������ : '   NO-GAP, W_ZFOPNDT.
  WRITE : /2  '�ŷ��� : '   NO-GAP, W_ZFBENI NO-GAP, W_ZFBENI_NM,
           40 '�������� : ' NO-GAP, W_ZFOPBN NO-GAP, W_ZFOPBN_NM,
           86 '��ȿ�� : '   NO-GAP, W_ZFEXDT.
  WRITE : /2  'ȯ��   : '   NO-GAP, W_ZFEXRT.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE                    NO-GAP,
            '              �����ݾ� '   NO-GAP, SY-VLINE NO-GAP,
            '          �߻��ݾ� '       NO-GAP, SY-VLINE NO-GAP,
            '          �����ݾ� '       NO-GAP, SY-VLINE NO-GAP,
            '              �ܾ� '       NO-GAP, SY-VLINE NO-GAP,
            '        ���԰��ܾ� '       NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-ULINE.
  WRITE : / SY-VLINE                         NO-GAP,
            W_ZFOPAMTC                       NO-GAP,
            W_ZFOPAMT   CURRENCY W_ZFOPAMTC  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPAMT_1 CURRENCY W_ZFOPAMTC  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPAMT_2 CURRENCY W_ZFOPAMTC  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPAMT_3 CURRENCY W_ZFOPAMTC  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPAMT_4 CURRENCY W_ZFOPAMTC  NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-VLINE                    NO-GAP,
            'KRW  '                     NO-GAP,
            W_ZFOPKAM   CURRENCY 'KRW'  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPKAM_1 CURRENCY 'KRW'  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPKAM_2 CURRENCY 'KRW'  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPKAM_3 CURRENCY 'KRW'  NO-GAP, SY-VLINE NO-GAP,
            ' '                              NO-GAP,
            W_ZFOPKAM_4 CURRENCY 'KRW'  NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
            '              ��ǥ��ȣ '     NO-GAP, SY-VLINE NO-GAP,
            '          �߻��ݾ� ' NO-GAP, SY-VLINE NO-GAP,
            '          �����ݾ� ' NO-GAP, SY-VLINE NO-GAP,
            '            �μ��� ' NO-GAP, SY-VLINE NO-GAP,
            '          �����ݾ� ' NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    W_ERR_CHK.

   SET PF-STATUS 'ZIMX3'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMX3'.           " GUI TITLE SETTING..

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

  WRITE:/ SY-VLINE NO-GAP,
       '        '         NO-GAP,
       IT_TAB-ZFGFDYR                       NO-GAP, " ���� ȸ����ǥ��?
       '-'                                  NO-GAP,
       IT_TAB-ZFGFDNO                       NO-GAP, " ���� ȸ����ǥ��?
       SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMT CURRENCY W_ZFOPAMTC   NO-GAP, " �߻���?
       SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMT_1 CURRENCY W_ZFOPAMTC NO-GAP, " ������?
       SY-VLINE NO-GAP,
       '         '                          NO-GAP,
       IT_TAB-ZFDODT                        NO-GAP, " �μ�?
       SY-VLINE NO-GAP,
       IT_TAB-ZFIVAMT_2 CURRENCY W_ZFOPAMTC NO-GAP, " ������?
       SY-VLINE NO-GAP.
* Hide
       MOVE SY-TABIX  TO W_LIST_INDEX.
       HIDE: W_LIST_INDEX, IT_TAB.
       MODIFY IT_TAB INDEX SY-TABIX.

       FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
       WRITE:/ SY-VLINE NO-GAP,
       '                      ', SY-VLINE      NO-GAP,
       IT_TAB-ZFKAMT CURRENCY 'KRW'    NO-GAP, " �߻���?
       SY-VLINE NO-GAP,
       IT_TAB-ZFKAMT_1 CURRENCY 'KRW'  NO-GAP, " ������?
       SY-VLINE NO-GAP,
       '                   '                    NO-GAP,
       SY-VLINE NO-GAP,
       IT_TAB-ZFKAMT_2 CURRENCY 'KRW'  NO-GAP, " ������?
       SY-VLINE NO-GAP.

  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.
  W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / SY-ULINE.    WRITE : / '��', W_COUNT, '��'.
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

  PERFORM P1000_READ_HEAD.

  REFRESH IT_TAB.
  SELECT *
    FROM ZTVTIV.
*   WHERE EBELN = ZTREQHD-EBELN.
         CLEAR IT_TAB.
         MOVE-CORRESPONDING ZTVTIV TO IT_TAB.
         SELECT SUM( ZFIVAMT ) SUM( ZFKAMT )
           INTO (IT_TAB-ZFIVAMT, IT_TAB-ZFKAMT)
           FROM ZTVTIVIT
          WHERE ZFGFDYR  = IT_TAB-ZFGFDYR
            AND ZFGFDNO = IT_TAB-ZFGFDNO.
         IF IT_TAB-ZFREDNO IS INITIAL.
            APPEND  IT_TAB.
            CONTINUE.
         ENDIF.
         CLEAR W_ZFPNNO.
         SELECT MAX( ZFPNNO ) INTO W_ZFPNNO
           FROM ZTPMTIV
          WHERE ZFGFDYR = IT_TAB-ZFGFDYR
            AND ZFGFDNO = IT_TAB-ZFGFDNO.
         IF W_ZFPNNO IS INITIAL.
            APPEND  IT_TAB.
            CONTINUE.
         ENDIF.
         CLEAR ZTPMTHD.
         SELECT SINGLE *
           FROM ZTPMTHD
          WHERE ZFPNNO = W_ZFPNNO.
         IF ZTPMTHD-ZFPYST = 'N'.
            MOVE IT_TAB-ZFIVAMT TO IT_TAB-ZFIVAMT_1. " ������?
            MOVE IT_TAB-ZFKAMT  TO IT_TAB-ZFKAMT_1.  " �����ݾ�-��?
         ENDIF.
         IF ZTPMTHD-ZFPYST = 'C'.
            MOVE IT_TAB-ZFIVAMT TO IT_TAB-ZFIVAMT_1. " ������?
            MOVE IT_TAB-ZFKAMT  TO IT_TAB-ZFKAMT_1.  " �����ݾ�-��?
            MOVE IT_TAB-ZFIVAMT TO IT_TAB-ZFIVAMT_2. " ������?
            MOVE IT_TAB-ZFKAMT  TO IT_TAB-ZFKAMT_2.  " �����ݾ�-��?
         ENDIF.
         APPEND  IT_TAB.
  ENDSELECT.

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
      PERFORM P3000_LINE_WRITE.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_HEAD
*&---------------------------------------------------------------------*
FORM P1000_READ_HEAD.

  CLEAR : W_ZFREQNO,   W_ZFOPNNO,   W_ZFBENI,    W_ZFBENI_NM, W_ZFOPBN,
          W_ZFOPBN_NM, W_ZFOPNDT,   W_ZFEXDT,    W_ZFEXRT,    W_ZFOPAMT,
          W_ZFOPKAM,   W_ZFOPAMT_1, W_ZFOPKAM_1, W_ZFOPAMT_2,
          W_ZFOPKAM_2, W_ZFOPAMT_3, W_ZFOPKAM_3, W_ZFOPAMT_4,
          W_ZFOPKAM_4, W_ZFAMDNO,   W_ZFOPAMTC.

  SELECT MAX( ZFREQNO ) INTO W_ZFREQNO
    FROM ZTREQHD
   WHERE ZFOPNNO = P_OPNNO
     AND ZFREQTY = 'LO'.

  CLEAR ZTREQHD.
  SELECT SINGLE *
    FROM ZTREQHD
   WHERE ZFREQNO = W_ZFREQNO.
  IF SY-SUBRC NE 0.
     MESSAGE E865.
     EXIT.
  ENDIF.

  MOVE ZTREQHD-ZFOPNNO  TO W_ZFOPNNO. "L/C No
  MOVE ZTREQHD-ZFBENI   TO W_ZFBENI. " Vendor
  SELECT SINGLE NAME1   INTO W_ZFBENI_NM
    FROM LFA1
   WHERE LIFNR = W_ZFBENI.
  MOVE ZTREQHD-ZFOPBN TO W_ZFOPBN. " ������?
  SELECT SINGLE NAME1 INTO W_ZFOPBN_NM
    FROM LFA1
   WHERE LIFNR = W_ZFOPBN.
  SELECT MAX( ZFAMDNO ) INTO W_ZFAMDNO
    FROM ZTREQST
   WHERE ZFREQNO = W_ZFREQNO
     AND ZFDOCST = 'O'.
  SELECT SINGLE ZFOPNDT INTO W_ZFOPNDT "����?
    FROM ZTREQST
   WHERE ZFREQNO = W_ZFREQNO
     AND ZFAMDNO = W_ZFAMDNO.
  IF W_ZFAMDNO = 0.
     CLEAR ZTLLCHD.
     SELECT SINGLE *
       FROM ZTLLCHD
      WHERE ZFREQNO = W_ZFREQNO.
     MOVE ZTLLCHD-ZFEXDT   TO W_ZFEXDT.  " ��ȿ��?
     MOVE ZTLLCHD-ZFEXRT   TO W_ZFEXRT.  " ȯ?
     MOVE ZTLLCHD-ZFOPAMT  TO W_ZFOPAMT. " ������?
     MOVE ZTLLCHD-ZFOPAMTC TO W_ZFOPAMTC. " �����ݾ���?
     MOVE ZTLLCHD-ZFOPKAM  TO W_ZFOPKAM. " �����ݾ�(��ȭ)
  ELSE.
     CLEAR ZTLLCAMHD.
     SELECT SINGLE *
       FROM ZTLLCAMHD
      WHERE ZFREQNO = W_ZFREQNO
        AND ZFAMDNO = W_ZFAMDNO.
     MOVE ZTLLCAMHD-ZFNEXDT   TO W_ZFEXDT. " ��ȿ��?
     MOVE ZTLLCAMHD-ZFEXRT    TO W_ZFEXRT. " ȯ?
     MOVE ZTLLCAMHD-ZFNOAMT   TO W_ZFOPAMT. " ������?
     MOVE ZTLLCAMHD-WAERS     TO W_ZFOPAMTC. " �����ݾ���?
     MOVE ZTLLCAMHD-ZFNOPKAM  TO W_ZFOPKAM. " �����ݾ�(��ȭ)
  ENDIF.

  SELECT SUM( ZFIVAMT )  SUM( ZFKAMT ) " �߻���?
    INTO (W_ZFOPAMT_1,  W_ZFOPKAM_1)
    FROM  ZVVTIV_IT
   WHERE  EBELN = ZTREQHD-EBELN.
  W_ZFOPAMT_4 = W_ZFOPAMT - W_ZFOPAMT_1. " ���԰���?
  W_ZFOPKAM_4 = W_ZFOPKAM - W_ZFOPKAM_1. " ���԰��ܾ�(��ȭ)
  SELECT SUM( ZFTIVAM )  SUM( ZFTIVAMK ) " ������?
    INTO (W_ZFOPAMT_2,  W_ZFOPKAM_2)
    FROM  ZTPMTHD
   WHERE  EBELN = ZTREQHD-EBELN
     AND  ZFPYST = 'C'.
  W_ZFOPAMT_3 = W_ZFOPAMT - W_ZFOPAMT_2. " ��?
  W_ZFOPKAM_3 = W_ZFOPKAM - W_ZFOPKAM_2. " �����ܾ�(��ȭ)


ENDFORM.                    " P1000_READ_HEAD

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO.

  SET PARAMETER ID 'ZPREQNO' FIELD P_ZFREQNO.
  EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
  CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_LC
