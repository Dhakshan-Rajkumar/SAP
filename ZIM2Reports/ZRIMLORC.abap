*&---------------------------------------------------------------------*
*& Report  ZRIMLORC                                                   *
*&---------------------------------------------------------------------*
*&ABAP Name : ZRIMLORC                                                *
*&Created by: ����ȣ INFOLINK.Ltd                                      *
*&Created on: 07/19/2000                                               *
*&Version   : 1.0                                                      *
*&---------------------------------------------------------------------*
* ������/ ���ະ �ŷ����� ������ �����ش�.
* ����� �ŷ� ������ Report ZRIMLORF�� SUBMIT���� ȣ�� �Ͽ� �����ش�.
*&---------------------------------------------------------------------*

REPORT  ZRIMLORC       NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 194
                       LINE-COUNT 65.

TABLES : ZTREQHD,                      " �����Ƿ� Header
         ZTREQST,                      " �����Ƿ� ����(Status)
         EKKO.

DATA : BEGIN OF IT_TAB1 OCCURS 0,
               CODE(10)    TYPE  C,
               ZFMATGB     LIKE ZTREQHD-ZFMATGB,
               ZFREQNO     LIKE ZTREQHD-ZFREQNO,
               WAERS       LIKE ZTREQHD-ZFWAERS,
               ZFOPAMT     LIKE ZTREQHD-ZFOPAMT.
DATA : END   OF IT_TAB1.

DATA : BEGIN OF IT_TEMP OCCURS 0,
       ZFREQNO   LIKE   ZTREQST-ZFREQNO,
       ZFAMDNO   LIKE   ZTREQST-ZFAMDNO.
DATA : END   OF IT_TEMP.

DATA : BEGIN OF IT_TAB2 OCCURS 0,
               CODE(10)    TYPE  C,
               WAERS       LIKE ZTREQHD-ZFWAERS,
               COUNT1(5)   TYPE  I,
               OPAMT1      LIKE ZTREQST-ZFOPAMT,
               COUNT2(5)   TYPE  I,
               OPAMT2      LIKE ZTREQST-ZFOPAMT,
               COUNT3(5)   TYPE  I,
               OPAMT3      LIKE ZTREQST-ZFOPAMT,
               COUNT4(5)   TYPE  I,
               OPAMT4      LIKE ZTREQST-ZFOPAMT,
               COUNT5(5)   TYPE  I,
               OPAMT5      LIKE ZTREQST-ZFOPAMT,
               COUNTS(5)   TYPE  I,
               OPAMTS      LIKE ZTREQST-ZFOPAMT.
DATA : END   OF IT_TAB2.

DATA : BEGIN OF IT_TAB3 OCCURS 0,
               CODE(10)    TYPE  C,
               WAERS       LIKE ZTREQHD-ZFWAERS,
               COUNT1(5)   TYPE  I,
               OPAMT1      LIKE ZTREQST-ZFOPAMT,
               COUNT2(5)   TYPE  I,
               OPAMT2      LIKE ZTREQST-ZFOPAMT,
               COUNT3(5)   TYPE  I,
               OPAMT3      LIKE ZTREQST-ZFOPAMT,
               COUNT4(5)   TYPE  I,
               OPAMT4      LIKE ZTREQST-ZFOPAMT,
               COUNT5(5)   TYPE  I,
               OPAMT5      LIKE ZTREQST-ZFOPAMT,
               COUNTS(5)   TYPE  I,
               OPAMTS      LIKE ZTREQST-ZFOPAMT.
DATA : END   OF IT_TAB3.

DATA : BEGIN OF IT_LAND1 OCCURS 0,
               LAND1       LIKE  T005T-LAND1,
               LANDX       LIKE  T005T-LANDX.
DATA : END   OF IT_LAND1.

DATA : BEGIN OF IT_LIFNR OCCURS 0,
               LIFNR       LIKE  LFA1-LIFNR,
               NAME1       LIKE  LFA1-NAME1.
DATA : END   OF IT_LIFNR.

DATA : W_SUBRC  LIKE  SY-SUBRC,
       W_LINE   TYPE  I,
       W_AMDNO  LIKE  ZTREQST-ZFAMDNO,
       W_OPAMT  LIKE  ZTREQST-ZFOPAMT,
       W_CNT(1),
       SV_CODE(10) TYPE  C,
       SV_WAERS    LIKE  ZTREQHD-ZFWAERS,
       W_TEXT(23)  TYPE  C.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
   SELECT-OPTIONS: S_BURKS    FOR ZTREQHD-BUKRS,     " Company Code
                   S_EKGRP    FOR ZTREQST-EKGRP,     " ���ű׷�.
                   S_WERKS    FOR ZTREQHD-ZFWERKS,   " Plant
                   S_OPNDT    FOR ZTREQST-ZFOPNDT OBLIGATORY.   "����?
   SELECTION-SCREEN SKIP.

   PARAMETER : R_COUN   RADIOBUTTON GROUP GP1,     "������.
               R_BANK   RADIOBUTTON GROUP GP1,     "���ະ.
               R_JEWG   RADIOBUTTON GROUP GP1,     "�����.
               R_VEN    RADIOBUTTON GROUP GP1,     "VENDOR��.
               R_INCO   RADIOBUTTON GROUP GP1,     "�ε�����.
               R_TERM   RADIOBUTTON GROUP GP1.     "��������.
SELECTION-SCREEN END   OF BLOCK B1.

INITIALIZATION.
  PERFORM P1000_INITIALIZATION.

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
*&      Form  P1000_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_INITIALIZATION.
  SET TITLEBAR 'ZIMR05' .
  CONCATENATE SY-DATUM(6) '01' INTO S_OPNDT-LOW.
  S_OPNDT-HIGH = SY-DATUM.
  APPEND S_OPNDT.
ENDFORM.                    " P1000_INITIALIZATION

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_DATA.
* L/C MAX AMEND ��ȣ SELECT.
   SELECT ZFREQNO  MAX( ZFAMDNO ) AS ZFAMDNO
   INTO   CORRESPONDING FIELDS OF TABLE IT_TEMP
   FROM   ZTREQST
   WHERE  ZFDOCST     EQ   'O'
   GROUP BY ZFREQNO.

* ������ ���� ����.
  IF  R_COUN = 'X'.

      SELECT B~ZFREQNO  A~ZFSHCU AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

      SELECT LAND1 LANDX INTO CORRESPONDING FIELDS OF TABLE IT_LAND1
      FROM   T005T FOR ALL ENTRIES IN IT_TAB1
      WHERE  SPRAS EQ  SY-LANGU
      AND    LAND1 EQ  IT_TAB1-CODE(3).

* ���ະ ��������.
  ELSEIF R_BANK = 'X'.

      SELECT B~ZFREQNO  A~ZFOPBN AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

      SELECT LIFNR NAME1 INTO CORRESPONDING FIELDS OF TABLE IT_LIFNR
      FROM   LFA1  FOR ALL ENTRIES IN IT_TAB1
      WHERE  LIFNR EQ IT_TAB1-CODE.

* ����ó�� ���� ����.
  ELSEIF R_VEN = 'X'.

      SELECT B~ZFREQNO  A~LIFNR  AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

      SELECT LIFNR NAME1 INTO CORRESPONDING FIELDS OF TABLE IT_LIFNR
      FROM   LFA1  FOR ALL ENTRIES IN IT_TAB1
      WHERE  LIFNR EQ  IT_TAB1-CODE.

* ������к� ��������.
  ELSEIF R_JEWG = 'X'.

      SELECT B~ZFREQNO  A~ZFJEWGB AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

* �ε����Ǻ� ���� ����.
  ELSEIF R_INCO = 'X'.

      SELECT B~ZFREQNO  A~INCO1 AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

* �������Ǻ� ���� ����.
  ELSEIF R_TERM = 'X'.

      SELECT B~ZFREQNO  A~ZTERM AS CODE A~ZFMATGB
             A~WAERS    A~ZFLASTAM AS ZFOPAMT
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB1
      FROM ( ZTREQST  AS  B  INNER JOIN  ZTREQHD AS A
      ON     B~ZFREQNO       EQ    A~ZFREQNO )
      FOR    ALL  ENTRIES    IN    IT_TEMP
      WHERE  B~ZFREQNO       EQ    IT_TEMP-ZFREQNO
      AND    B~ZFAMDNO       EQ    IT_TEMP-ZFAMDNO
      AND    B~ZFOPNDT       IN    S_OPNDT
      AND    B~EKGRP         IN    S_EKGRP
      AND    A~ZFWERKS       IN    S_WERKS.

      DESCRIBE TABLE IT_TAB1 LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

  ENDIF.

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

  CLEAR IT_TAB2.
  SORT IT_TAB1 BY CODE WAERS.

  LOOP AT IT_TAB1.

    IF SY-TABIX EQ 1.
       MOVE : IT_TAB1-WAERS TO  SV_WAERS,
              IT_TAB1-CODE  TO  SV_CODE.
    ENDIF.

* ������ ���к�, ������ȭ���� SUM �� COUNT.
    IF SV_CODE NE IT_TAB1-CODE.
       MOVE : SV_CODE       TO  IT_TAB2-CODE,
              SV_WAERS      TO  IT_TAB2-WAERS.
       APPEND  IT_TAB2.
       CLEAR   IT_TAB2.
       MOVE : IT_TAB1-CODE  TO  SV_CODE,
              IT_TAB1-WAERS TO  SV_WAERS.
    ELSE.
      IF SV_WAERS NE IT_TAB1-WAERS.
         MOVE : SV_CODE       TO IT_TAB2-CODE,
                SV_WAERS      TO IT_TAB2-WAERS.
         APPEND  IT_TAB2.
         CLEAR   IT_TAB2.
         MOVE : IT_TAB1-CODE  TO SV_CODE,
                IT_TAB1-WAERS TO SV_WAERS.
      ENDIF.
    ENDIF.

    IF IT_TAB1-ZFMATGB = '1'.
       ADD : 1                 TO  IT_TAB2-COUNT1,
             IT_TAB1-ZFOPAMT   TO  IT_TAB2-OPAMT1.
    ELSEIF IT_TAB1-ZFMATGB = '2'.
       ADD : 1                 TO  IT_TAB2-COUNT2,
             IT_TAB1-ZFOPAMT   TO  IT_TAB2-OPAMT2.
    ELSEIF IT_TAB1-ZFMATGB = '3'.
       ADD : 1                 TO  IT_TAB2-COUNT3,
             IT_TAB1-ZFOPAMT   TO  IT_TAB2-OPAMT3.
    ELSEIF IT_TAB1-ZFMATGB = '4'.
       ADD : 1                 TO  IT_TAB2-COUNT4,
             IT_TAB1-ZFOPAMT   TO  IT_TAB2-OPAMT4.
    ELSE.
       ADD : 1                 TO  IT_TAB2-COUNT5,
             IT_TAB1-ZFOPAMT   TO  IT_TAB2-OPAMT5.
    ENDIF.

    ADD : 1               TO  IT_TAB2-COUNTS,
          IT_TAB1-ZFOPAMT TO  IT_TAB2-OPAMTS.

  ENDLOOP.
  MOVE : SV_CODE       TO IT_TAB2-CODE,
         SV_WAERS      TO IT_TAB2-WAERS.
  APPEND IT_TAB2.

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

  SET TITLEBAR  'ZIMR05'.
  SORT IT_TAB2 BY CODE WAERS.

  LOOP AT IT_TAB2.

    IF W_CNT = 1.
       W_CNT = 2.   FORMAT COLOR 2 INTENSIFIED OFF.
    ELSE.
       W_CNT = 1.   FORMAT COLOR 2 INTENSIFIED ON.
    ENDIF.

    CLEAR : W_TEXT, IT_LAND1, IT_LIFNR.
    IF R_COUN = 'X'.
       READ TABLE IT_LAND1 WITH KEY LAND1 = IT_TAB2-CODE.
       W_TEXT = IT_LAND1-LANDX.
    ELSEIF  R_BANK = 'X'.
       READ TABLE IT_LIFNR WITH KEY LIFNR = IT_TAB2-CODE.
       W_TEXT = IT_LIFNR-NAME1.
    ELSEIF  R_VEN = 'X'.
       READ TABLE IT_LIFNR WITH KEY LIFNR = IT_TAB2-CODE.
       W_TEXT = IT_LIFNR-NAME1.
    ELSEIF  R_JEWG EQ 'X'.
       CASE  IT_TAB2-CODE.
          WHEN '1'.
             MOVE '�ڱ��ڱ�'   TO  W_TEXT.
          WHEN '2'.
             MOVE '��ȭ����'   TO  W_TEXT.
          WHEN '3'.
             MOVE '������(Usance)'   TO  W_TEXT.
          WHEN '4'.
             MOVE '�������޼���'   TO  W_TEXT.
          WHEN '5'.
             MOVE '��������'   TO  W_TEXT.
          WHEN '6'.
             MOVE '��븮��'   TO  W_TEXT.
          WHEN '7'.
             MOVE '��ȭ��ä'   TO  W_TEXT.
          WHEN '8'.
             MOVE '��    Ÿ'   TO  W_TEXT.
       ENDCASE.
    ELSEIF R_TERM EQ 'X'.
       SELECT SINGLE ZFTRTX1  INTO W_TEXT
       FROM   ZTIMIMG01
       WHERE  ZTERM      EQ  IT_TAB2-CODE
       AND    ZFAPLDT    EQ  ( SELECT MAX( ZFAPLDT )
                               FROM   ZTIMIMG01
                               WHERE  ZTERM   EQ  IT_TAB2-CODE
                               AND    ZFAPLDT LT  SY-DATUM ).
    ELSE.
       MOVE IT_TAB2-CODE TO W_TEXT.
    ENDIF.

    WRITE:/'|' NO-GAP,
           (23) W_TEXT NO-GAP, '|',
           (05) IT_TAB2-WAERS  NO-GAP, '|',
           (05) IT_TAB2-COUNT1 NO-GAP, '|',
           (18) IT_TAB2-OPAMT1 CURRENCY IT_TAB2-WAERS NO-GAP, '|',
           (05) IT_TAB2-COUNT2 NO-GAP, '|',
           (18) IT_TAB2-OPAMT2 CURRENCY IT_TAB2-WAERS NO-GAP, '|',
           (05) IT_TAB2-COUNT3 NO-GAP, '|',
           (18) IT_TAB2-OPAMT3 CURRENCY IT_TAB2-WAERS NO-GAP, '|',
           (05) IT_TAB2-COUNT4 NO-GAP, '|',
           (18) IT_TAB2-OPAMT4 CURRENCY IT_TAB2-WAERS NO-GAP, '|',
           (05) IT_TAB2-COUNT5 NO-GAP, '|',
           (18) IT_TAB2-OPAMT5 CURRENCY IT_TAB2-WAERS NO-GAP, '|',
           (05) IT_TAB2-COUNTS NO-GAP, '|',
           (18) IT_TAB2-OPAMTS CURRENCY IT_TAB2-WAERS NO-GAP, '|'.

  ENDLOOP.

* ��ȭ���� �Ұ� SUM.
  SORT IT_TAB2 BY WAERS.
  LOOP AT IT_TAB2.

    IF SY-TABIX EQ 1.
       MOVE : IT_TAB2-WAERS TO  SV_WAERS.
    ENDIF.

* ������ ���к�, ������ȭ���� SUM �� COUNT.
    IF SV_WAERS NE IT_TAB2-WAERS.
       MOVE : SV_WAERS      TO IT_TAB3-WAERS.
       APPEND  IT_TAB3.
       CLEAR   IT_TAB3.
       MOVE : IT_TAB2-WAERS TO SV_WAERS.
    ENDIF.

     ADD : IT_TAB2-COUNT1    TO  IT_TAB3-COUNT1,
           IT_TAB2-OPAMT1    TO  IT_TAB3-OPAMT1,
           IT_TAB2-COUNT2    TO  IT_TAB3-COUNT2,
           IT_TAB3-OPAMT2    TO  IT_TAB3-OPAMT2,
           IT_TAB2-COUNT3    TO  IT_TAB3-COUNT3,
           IT_TAB3-OPAMT3    TO  IT_TAB3-OPAMT3,
           IT_TAB2-COUNT4    TO  IT_TAB3-COUNT4,
           IT_TAB3-OPAMT4    TO  IT_TAB3-OPAMT4,
           IT_TAB2-COUNT5    TO  IT_TAB3-COUNT5,
           IT_TAB3-OPAMT5    TO  IT_TAB3-OPAMT5,
           IT_TAB2-COUNTS    TO  IT_TAB3-COUNTS,
           IT_TAB3-OPAMTS    TO  IT_TAB3-OPAMTS.
  ENDLOOP.

  MOVE : SV_WAERS      TO IT_TAB3-WAERS.
  APPEND IT_TAB3.

  PERFORM P3000_TOT_LINE_WRITE.

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
  IF  R_COUN = 'X'.
    WRITE:/65 '   �� �� ��  �� �� �� �� �� ��   '  COLOR 1.
  ELSEIF  R_BANK = 'X'.
    WRITE:/65 '   �� �� ��  �� �� �� �� �� ��   '  COLOR 1.
  ELSEIF  R_JEWG = 'X'.
    WRITE:/65 '   ������к� �� �� �� �� �� ��   ' COLOR 1.
  ELSEIF  R_INCO = 'X'.
    WRITE:/65 '   �ε����Ǻ� �� �� �� �� �� ��   ' COLOR 1.
  ELSEIF  R_TERM = 'X'.
    WRITE:/65 '   �������Ǻ� �� �� �� �� �� ��   ' COLOR 1.
  ENDIF.
  WRITE:/135 'DATE :', SY-DATUM.
  WRITE:/135 'PAGE :', SY-PAGNO.

  WRITE:/6 '�����Ⱓ :', S_OPNDT-LOW, '-', S_OPNDT-HIGH.

  ULINE.
  FORMAT COLOR 1 INTENSIFIED OFF.
  WRITE:/'|' NO-GAP,
         (23) '       ��    ��' NO-GAP, '|',
         (05) '��ȭ'            NO-GAP, '|'.
  SET LEFT SCROLL-BOUNDARY.
  WRITE: (05) ' �Ǽ�' NO-GAP, '|',
         (18) '�������ڱݾ� ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) 'Local'           RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '����������� '   RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '�� �� �� ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '��    ǰ ' RIGHT-JUSTIFIED NO-GAP, '|',
         (05) ' �Ǽ�' NO-GAP, '|',
         (18) '��  ��  �� �� ' RIGHT-JUSTIFIED NO-GAP, '|'.
  ULINE.

ENDFORM.                    " P1000_TOP_PAGE
*&---------------------------------------------------------------------*
*&      Form  P3000_TOT_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_TOT_LINE_WRITE.

  SORT IT_TAB3 BY WAERS.

  LOOP AT IT_TAB3.

    IF W_CNT = 1.
       W_CNT = 2.   FORMAT COLOR 3 INTENSIFIED OFF.
    ELSE.
       W_CNT = 1.   FORMAT COLOR 3 INTENSIFIED ON.
    ENDIF.

    CLEAR : W_TEXT, IT_LAND1, IT_LIFNR.
    IF SY-TABIX EQ 1.
       WRITE : / SY-ULINE.
       MOVE '      ��    ��  '    TO  W_TEXT.
    ELSE.
       CLEAR : W_TEXT.
    ENDIF.
    WRITE:/'|' NO-GAP,
           (23) W_TEXT NO-GAP, '|',
           (05) IT_TAB3-WAERS  NO-GAP, '|',
           (05) IT_TAB3-COUNT1 NO-GAP, '|',
           (18) IT_TAB3-OPAMT1 CURRENCY IT_TAB3-WAERS NO-GAP, '|',
           (05) IT_TAB3-COUNT2 NO-GAP, '|',
           (18) IT_TAB3-OPAMT2 CURRENCY IT_TAB3-WAERS NO-GAP, '|',
           (05) IT_TAB3-COUNT3 NO-GAP, '|',
           (18) IT_TAB3-OPAMT3 CURRENCY IT_TAB3-WAERS NO-GAP, '|',
           (05) IT_TAB3-COUNT4 NO-GAP, '|',
           (18) IT_TAB3-OPAMT4 CURRENCY IT_TAB3-WAERS NO-GAP, '|',
           (05) IT_TAB3-COUNT5 NO-GAP, '|',
           (18) IT_TAB3-OPAMT5 CURRENCY IT_TAB3-WAERS NO-GAP, '|',
           (05) IT_TAB3-COUNTS NO-GAP, '|',
           (18) IT_TAB3-OPAMTS CURRENCY IT_TAB3-WAERS NO-GAP, '|'.

  ENDLOOP.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TOT_LINE_WRITE
