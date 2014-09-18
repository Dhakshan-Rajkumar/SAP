*&---------------------------------------------------------------------*
*& Report  ZRIMLORF                                                    *
*&---------------------------------------------------------------------*
*&ABAP Name : ZRIMLORF                                                 *
*&Created by: ����ȣ INFOLINK.Ltd                                      *
*&Created on: 07/20/2000                                               *
*&Version   : 1.0                                                      *
*&---------------------------------------------------------------------*
* ����� L/C �ŷ������� �����ش�.
* Report ZRIMLORC���� SUBMIT ���� ȣ�� �ȴ�.
*&---------------------------------------------------------------------*

REPORT  ZRIMLORF       NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 125
                       LINE-COUNT 65.

TABLES : ZTREQHD,                      " �����Ƿ� Header
         ZTREQST.                      " �����Ƿ� ����(Status)

DATA : BEGIN OF IT_TAB1 OCCURS 0,
               ZFJEWGB     LIKE ZTREQHD-ZFJEWGB,
               ZFMATGB     LIKE ZTREQHD-ZFMATGB,
               ZFREQNO     LIKE ZTREQHD-ZFREQNO.
DATA : END   OF IT_TAB1.

DATA : BEGIN OF IT_TAB2 OCCURS 0,
               ZFJEWGB     LIKE ZTREQHD-ZFJEWGB,
               COUNT1(5)   TYPE  I,
               OPAMT1      LIKE ZTREQST-ZFOPAMT,      " ����?
               COUNT2(5)   TYPE  I,
               OPAMT2      LIKE ZTREQST-ZFOPAMT,      " �ü�?
               COUNT3(5)   TYPE  I,
               OPAMT3      LIKE ZTREQST-ZFOPAMT,      " ��?
               COUNTS(5)   TYPE  I,
               OPAMTS      LIKE ZTREQST-ZFOPAMT.      " ��?
DATA : END   OF IT_TAB2.

DATA : W_SUBRC  LIKE  SY-SUBRC,
       W_AMDNO  LIKE  ZTREQST-ZFAMDNO,
       W_OPAMT  LIKE  ZTREQST-ZFOPAMT,
       W_CNT(1),
       W_TEXT(21)  TYPE  C.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
   SELECT-OPTIONS: S_WERKS    FOR ZTREQHD-ZFWERKS,   "Plant
                   S_OPNDT    FOR ZTREQST-ZFOPNDT OBLIGATORY.   "����?
   SELECTION-SCREEN SKIP.
SELECTION-SCREEN END   OF BLOCK B1.

START-OF-SELECTION.
  PERFORM P1000_READ_DATA.
  IF W_SUBRC = 4.
     MESSAGE S191 WITH '�����Ƿڹ���'.  EXIT.
  ENDIF.

  PERFORM P1000_CHECK_DATA.

  PERFORM P1000_WRITE_DATA.

TOP-OF-PAGE.
  PERFORM P1000_TOP_PAGE.


*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_DATA.
   SELECT B~ZFREQNO A~ZFJEWGB A~ZFMATGB
    INTO (IT_TAB1-ZFREQNO, IT_TAB1-ZFJEWGB, IT_TAB1-ZFMATGB)
     FROM ZTREQST AS B INNER JOIN ZTREQHD AS A
       ON B~ZFREQNO = A~ZFREQNO
    WHERE B~ZFOPNDT IN S_OPNDT AND
          B~ZFAMDNO = '00000' AND
          A~ZFWERKS IN S_WERKS.
    APPEND IT_TAB1.  CLEAR IT_TAB1.
   ENDSELECT.

   IF SY-SUBRC <> 0.  W_SUBRC = 4.   EXIT.    ENDIF.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_CHECK_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_CHECK_DATA.
  SORT IT_TAB1.

  LOOP AT IT_TAB1.
    SELECT MAX( ZFAMDNO ) INTO W_AMDNO FROM ZTREQST
     WHERE ZFREQNO = IT_TAB1-ZFREQNO AND ZFOPNDT > '1'.

    SELECT SINGLE ZFUSDAM  INTO W_OPAMT FROM ZTREQST
     WHERE ZFREQNO = IT_TAB1-ZFREQNO AND ZFAMDNO = W_AMDNO.

    MOVE IT_TAB1-ZFJEWGB TO  IT_TAB2-ZFJEWGB.

    CASE IT_TAB1-ZFMATGB.
      WHEN '1' OR '2' OR '3'.
           MOVE 1           TO  IT_TAB2-COUNT1.
           MOVE W_OPAMT     TO  IT_TAB2-OPAMT1.
      WHEN '4'.
           MOVE 1           TO  IT_TAB2-COUNT2.
           MOVE W_OPAMT     TO  IT_TAB2-OPAMT2.
      WHEN '5'.
           MOVE 1           TO  IT_TAB2-COUNT3.
           MOVE W_OPAMT     TO  IT_TAB2-OPAMT3.
    ENDCASE.

    MOVE 1           TO  IT_TAB2-COUNTS.
    MOVE W_OPAMT     TO  IT_TAB2-OPAMTS.

    COLLECT IT_TAB2.  CLEAR IT_TAB2.

  ENDLOOP.

ENDFORM.                    " P1000_CHECK_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_WRITE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_WRITE_DATA.
  SORT IT_TAB2.
  LOOP AT IT_TAB2.
    IF W_CNT = 1.
       W_CNT = 2.   FORMAT COLOR 2 INTENSIFIED OFF.
    ELSE.
       W_CNT = 1.   FORMAT COLOR 2 INTENSIFIED ON.
    ENDIF.

    CLEAR : W_TEXT.
    CASE IT_TAB2-ZFJEWGB.
      WHEN '1'.    W_TEXT = '�ڱ��ڱ�'.
      WHEN '2'.    W_TEXT = '��ȭ����'.
      WHEN '3'.    W_TEXT = '������(USANCE)'.
      WHEN '4'.    W_TEXT = '�������޼���'.
      WHEN '5'.    W_TEXT = '��������'.
      WHEN '6'.    W_TEXT = '��븮��'.
      WHEN '7'.    W_TEXT = '��ȭ��ä'.
      WHEN '8'.    W_TEXT = '��    Ÿ'.
      WHEN OTHERS. W_TEXT = '*******'.
    ENDCASE.

    WRITE:/'|' NO-GAP,
           (15) W_TEXT NO-GAP, '|',
           (05) IT_TAB2-COUNT1 NO-GAP, '|',
           (18) IT_TAB2-OPAMT1 CURRENCY 'USD' NO-GAP, '|',
           (05) IT_TAB2-COUNT2 NO-GAP, '|',
           (18) IT_TAB2-OPAMT2 CURRENCY 'USD' NO-GAP, '|',
           (05) IT_TAB2-COUNT3 NO-GAP, '|',
           (18) IT_TAB2-OPAMT3 CURRENCY 'USD' NO-GAP, '|',
           (05) IT_TAB2-COUNTS NO-GAP, '|',
           (18) IT_TAB2-OPAMTS CURRENCY 'USD' NO-GAP, '|'.

    AT LAST.
       SUM.
       W_TEXT = '     ��    ��'.
       ULINE.
       FORMAT COLOR 3 INTENSIFIED OFF.
       WRITE:/'|' NO-GAP,
              (15) W_TEXT NO-GAP, '|',
              (05) IT_TAB2-COUNT1 NO-GAP, '|',
              (18) IT_TAB2-OPAMT1 CURRENCY 'USD' NO-GAP, '|',
              (05) IT_TAB2-COUNT2 NO-GAP, '|',
              (18) IT_TAB2-OPAMT2 CURRENCY 'USD' NO-GAP, '|',
              (05) IT_TAB2-COUNT3 NO-GAP, '|',
              (18) IT_TAB2-OPAMT3 CURRENCY 'USD' NO-GAP, '|',
              (05) IT_TAB2-COUNTS NO-GAP, '|',
              (18) IT_TAB2-OPAMTS CURRENCY 'USD' NO-GAP, '|'.
       ULINE.
    ENDAT.
  ENDLOOP.
ENDFORM.                    " P1000_WRITE_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_TOP_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_TOP_PAGE.
  SKIP 1.
  WRITE:/45 '   �� �� �� L/C �� �� �� ��   ' COLOR 1.
  WRITE:/105 'DATE :', SY-DATUM.
  WRITE:/105 'PAGE :', SY-PAGNO.

  WRITE:/6 '�����Ⱓ :', S_OPNDT-LOW, '-', S_OPNDT-HIGH,
        90 'Currency : USD'.

  ULINE.
  FORMAT COLOR 1 INTENSIFIED OFF.
  WRITE:/'|' NO-GAP,
         (15) '     ��    ��' NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '�� �� �� �� �� ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '�� �� �� �� �� ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '��  ǰ  ��  �� ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '��  ��  �� �� ' RIGHT-JUSTIFIED NO-GAP, '|'.
  ULINE.

ENDFORM.                    " P1000_TOP_PAGE
