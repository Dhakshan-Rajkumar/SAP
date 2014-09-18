*&---------------------------------------------------------------------
*& Report  ZRIMCUST
*&---------------------------------------------------------------------
*& ���α׷��� : ZRIMCUST
*&     �ۼ��� : �ͼ�ȣ INFOLINK.Ltd
*&     �ۼ��� : 01/07/2002
*&---------------------------------------------------------------------
*& Desc.      : ���纰/ �÷�Ʈ��/ ������ ���Խ����� �����ش�.
*&---------------------------------------------------------------------

REPORT  ZRIMCUST       NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 300
                       LINE-COUNT 65.

TABLES : ZTIDS,                                    " ���Ը���.
         ZTCUCLCST,                                " ������.
         ZTBL,                                     " B/L ���.
         LFA1,
         T001W.

DATA : MAX_LINSZ TYPE I.
DATA : BEGIN OF IT_TAB OCCURS  0,
       CODE(10)         TYPE    C,
       ZFSUPC           LIKE    ZTIDS-ZFSUPC,      " ������ ������ȣ.
       ZFTBAU           LIKE    ZTIDS-ZFTBAU,      " ��������-��ȭ.
       ZFUSD            LIKE    ZTIDS-ZFUSD,       " ��ȭ��ȭ.
       ZFMATGB          LIKE    ZTIDS-ZFMATGB,     " ���籸��.
       ZFMATGBNM(15)    TYPE    C,
       ZFIDSDT          LIKE    ZTIDS-ZFIDSDT,     " �Ű������.
       ZFBLNO           LIKE    ZTIDS-ZFBLNO,      " B/L ������ȣ.
       BUKRS            LIKE    ZTIDS-BUKRS,       " ȸ���ڵ�.
       ZFWERKS          LIKE    ZTBL-ZFWERKS,      " �÷�Ʈ.
       NAME1(20)        TYPE    C,
       LIFNR            LIKE    ZTBL-LIFNR.        " ����ó �ڵ�.
DATA : END  OF IT_TAB.

DATA : BEGIN OF IT_LIFNR OCCURS 0,
       LIFNR            LIKE  LFA1-LIFNR,
       NAME1            LIKE  LFA1-NAME1.
DATA : END   OF IT_LIFNR.

DATA : BEGIN OF IT_LAND1 OCCURS 0,
       LAND1            LIKE  T005T-LAND1,
       LANDX            LIKE  T005T-LANDX.
DATA : END   OF IT_LAND1.

*----------------------------------------------------------------------
* ���� ����.
*----------------------------------------------------------------------
DATA : W_ERR_CHK         TYPE   C,
       W_SUBRC           LIKE   SY-SUBRC,
       W_PAGE            TYPE   I,               " Page Counter
       W_LINE            TYPE   I,               " �������� Line Count
       W_FLAG            TYPE   C,
       W_COUNT           TYPE   I,               " ��ü COUNT
       W_COLOR           TYPE   I,
       W_CODE(15)        TYPE   C,
       W_LIST_INDEX      LIKE   SY-TABIX,
       W_TABIX           LIKE   SY-TABIX,        " Table Index
       W_CNT(1),
       W_TEXT(20)        TYPE   C,
       W_TOTSUM(20)      TYPE   C,
       W_LINES           TYPE   I,
       W_WERKSNM(20)     TYPE   C,
       SV_JUL            TYPE   C,
       SV_CHK            TYPE   C,
       SV_CODE(10)       TYPE   C,
       SV_AMOUNT         LIKE   ZTIDS-ZFTBAU,
       SV_MATGB          LIKE   ZTIDS-ZFMATGB,
       SV_BUKRS          LIKE   ZTIDS-BUKRS,
       SV_WERKS          LIKE   ZTBL-ZFWERKS,
       SV_TBAU1          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU2          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU3          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU4          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU5          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU6          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU7          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU8          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU9          LIKE   ZTIDS-ZFTBAU,
       SV_TBAU10         LIKE   ZTIDS-ZFTBAU,
       SV_TBAU11         LIKE   ZTIDS-ZFTBAU,
       SV_TBAU12         LIKE   ZTIDS-ZFTBAU,
       SV_TBAUS          LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU1      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU2      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU3      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU4      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU5      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU6      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU7      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU8      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU9      LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU10     LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU11     LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAU12     LIKE   ZTIDS-ZFTBAU,
       SV_TOT_TBAUS      LIKE   ZTIDS-ZFTBAU.
*----------------------------------------------------------------------
* Selection Screen ��.
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.

SELECT-OPTIONS : S_BUKRS  FOR ZTIDS-BUKRS DEFAULT '  ', "ȸ���ڵ�.
                 S_MATGB  FOR ZTIDS-ZFMATGB,       " ���籸��.
                 S_WERKS  FOR ZTBL-ZFWERKS,        " Plant
                 S_IDSDT  FOR ZTIDS-ZFIDSDT.       " �Ⱓ.
SELECTION-SCREEN SKIP.

PARAMETER : R_MATE   RADIOBUTTON GROUP GP1,       " ����/������.
            R_TERM   RADIOBUTTON GROUP GP1,       " ����/�Ⱓ��.
            R_COUN   RADIOBUTTON GROUP GP1.       " ����/�Ⱓ��.

SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------
* Top-Of-Page.
*----------------------------------------------------------------------
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " ��� ���...

*----------------------------------------------------------------------
* Initialization.
*----------------------------------------------------------------------
INITIALIZATION.                                  " �ʱⰪ SETTING
  SET  TITLEBAR 'ZIMR50'.                       " GUI TITLE SETTING..
  PERFORM P1000_INITIALIZATION.

*----------------------------------------------------------------------
* Start Of Selection ��.
*----------------------------------------------------------------------
START-OF-SELECTION.

  IF S_IDSDT-LOW(04) NE S_IDSDT-HIGH(04).
    MESSAGE S597.  EXIT.
  ENDIF.

* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_DATA        USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
  SET PF-STATUS 'ZIMR50'.                   " GUI STATUS SETTING
  SET TITLEBAR  'ZIMR50'.                   " GUI TITLE SETTING
  IF R_MATE = 'X'  OR
     R_TERM = 'X'.
    PERFORM   P3000_WRITE_DATA1.
  ENDIF.
  IF R_COUN = 'X'.
    PERFORM   P3000_WRITE_DATA2.
  ENDIF.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
*----------------------------------------------------------------------
* User Command
*----------------------------------------------------------------------
AT USER-COMMAND.

  CASE SY-UCOMM.

    WHEN 'REFR'.
      PERFORM   P1000_READ_DATA        USING W_ERR_CHK.
      IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
      PERFORM RESET_LIST.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.                " ����.
    WHEN OTHERS.

  ENDCASE.

*&---------------------------------------------------------------------
*&      Form  P1000_INITIALIZATION
*&---------------------------------------------------------------------
FORM P1000_INITIALIZATION.
  CONCATENATE SY-DATUM(6) '01' INTO S_IDSDT-LOW.
  S_IDSDT-HIGH = SY-DATUM.
  APPEND S_IDSDT.
*  IF NOT S_IDSDT-LOW+2(02) EQ S_IDSDT-HIGH+2(02).
*     MESSAGE E597.
*  ENDIF.
ENDFORM.                          " P1000_INITIALIZATION

*&---------------------------------------------------------------------
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------
FORM P1000_READ_DATA  USING W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

* ���� ���� SELECT.
  REFRESH : IT_TAB.

  SELECT A~ZFMATGB  B~ZFWERKS  B~LIFNR
         A~ZFTBAU   A~ZFIDSDT  A~BUKRS
  INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM ( ZTIDS  AS  A  INNER JOIN  ZTBL AS B
  ON     A~ZFBLNO        EQ    B~ZFBLNO )
  WHERE  A~ZFMATGB       IN    S_MATGB
  AND    A~BUKRS         IN    S_BUKRS
  AND    A~ZFIDSDT       IN    S_IDSDT
  AND    B~ZFWERKS       IN    S_WERKS
  AND    A~ZFMATGB       NE    SPACE.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

  SORT  IT_TAB BY  ZFMATGB  ZFWERKS.

ENDFORM.                    " P1000_READ_DATA

*&----------------------------------------------------------------------
*&      Form  P3000_WRITE_DATA1
*&----------------------------------------------------------------------
FORM P3000_WRITE_DATA1.

  CLEAR IT_TAB.

  LOOP AT IT_TAB.

    CLEAR LFA1.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ IT_TAB-LIFNR.

    IF SY-TABIX EQ 1.
      MOVE : IT_TAB-ZFMATGB TO  SV_MATGB,
             IT_TAB-ZFWERKS TO  SV_WERKS.
    ENDIF.

* ������ ���к�, �����ݾ׺��� SUM.
    IF SV_MATGB NE IT_TAB-ZFMATGB.
      PERFORM  P2000_SUM_LINE_WRITE1.
      PERFORM  P3000_TOTAL_LINE_WRITE.
      MOVE : IT_TAB-ZFMATGB  TO SV_MATGB,
             IT_TAB-ZFWERKS  TO SV_WERKS.
      CLEAR : SV_TBAU1, SV_TBAU2,     SV_TBAU3,  SV_TBAU4,
              SV_TBAU5, SV_TBAU6,     SV_TBAU7,  SV_TBAU8,
              SV_TBAU9, SV_TBAU10,    SV_TBAU11, SV_TBAU12,
              SV_TBAUS, SV_TOT_TBAU1, SV_TOT_TBAU2,
              SV_TOT_TBAU3,  SV_TOT_TBAU4,  SV_TOT_TBAU5,
              SV_TOT_TBAU6,  SV_TOT_TBAU7,  SV_TOT_TBAU8,
              SV_TOT_TBAU9,  SV_TOT_TBAU10, SV_TOT_TBAU11,
              SV_TOT_TBAU12, SV_TOT_TBAUS.
    ENDIF.

    IF SV_MATGB  EQ  IT_TAB-ZFMATGB AND
       SV_WERKS  NE  IT_TAB-ZFWERKS .
      PERFORM  P2000_SUM_LINE_WRITE1.
      MOVE : IT_TAB-ZFWERKS  TO  SV_WERKS.
      CLEAR : SV_TBAU1, SV_TBAU2,   SV_TBAU3,  SV_TBAU4,
              SV_TBAU5, SV_TBAU6,   SV_TBAU7,  SV_TBAU8,
              SV_TBAU9, SV_TBAU10,  SV_TBAU11, SV_TBAU12,
              SV_TBAUS.
    ENDIF.
* ���� / ������ ���Խ���.
    IF  R_MATE = 'X'.

      IF IT_TAB-LIFNR = 'X0201'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU1,  SV_TOT_TBAU1.
      ENDIF.
      IF IT_TAB-LIFNR = 'X0401'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU2,  SV_TOT_TBAU2.
      ENDIF.
      IF IT_TAB-LIFNR = 'X0301'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU3,  SV_TOT_TBAU3.
      ENDIF.
      IF LFA1-LAND1 = 'JP'  AND
         IT_TAB-LIFNR  NE 'X0201'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU4,  SV_TOT_TBAU4.
      ENDIF.
      IF LFA1-LAND1 = 'US'  AND
         IT_TAB-LIFNR  NE 'X0401'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU5,  SV_TOT_TBAU5.
      ENDIF.
      IF LFA1-LAND1 = 'FR'  AND
         IT_TAB-LIFNR  NE 'X0301'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU6,  SV_TOT_TBAU6.
      ENDIF.
      IF LFA1-LAND1 = 'GB'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU7,  SV_TOT_TBAU7.
      ENDIF.
      IF LFA1-LAND1 = 'DE'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU8,  SV_TOT_TBAU8.
      ENDIF.
      IF LFA1-LAND1 = 'CH'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU9,  SV_TOT_TBAU9.
      ENDIF.
      IF LFA1-LAND1 = 'IT'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU10, SV_TOT_TBAU10.
      ENDIF.
      IF LFA1-LAND1 = 'CN'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU11, SV_TOT_TBAU11.
      ENDIF.
      IF LFA1-LAND1 NE 'JP'  AND
         LFA1-LAND1 NE 'US'  AND
         LFA1-LAND1 NE 'FR'  AND
         LFA1-LAND1 NE 'GB'  AND
         LFA1-LAND1 NE 'DE'  AND
         LFA1-LAND1 NE 'CH'  AND
         LFA1-LAND1 NE 'IT'  AND
         LFA1-LAND1 NE 'CN'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU12, SV_TOT_TBAU12.
      ENDIF.

      ADD   IT_TAB-ZFTBAU  TO : SV_TBAUS,  SV_TOT_TBAUS.
* ���� / �Ⱓ�� ���Խ���.
    ELSEIF R_TERM = 'X'.

      IF IT_TAB-ZFIDSDT+4(02) = '01'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU1,  SV_TOT_TBAU1.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '02'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU2,  SV_TOT_TBAU2.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '03'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU3,  SV_TOT_TBAU3.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '04'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU4,  SV_TOT_TBAU4.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '05'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU5,  SV_TOT_TBAU5.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '06'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU6,  SV_TOT_TBAU6.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '07'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU7,  SV_TOT_TBAU7.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '08'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU8,  SV_TOT_TBAU8.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '09'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU9,  SV_TOT_TBAU9.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '10'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU10, SV_TOT_TBAU10.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '11'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU11, SV_TOT_TBAU11.
      ENDIF.
      IF IT_TAB-ZFIDSDT+4(02) = '12'.
        ADD  IT_TAB-ZFTBAU   TO : SV_TBAU12, SV_TOT_TBAU12.
      ENDIF.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAUS,  SV_TOT_TBAUS.

    ENDIF.

  ENDLOOP.
  PERFORM  P2000_SUM_LINE_WRITE1.
  PERFORM  P3000_TOTAL_LINE_WRITE.

ENDFORM.                    " P3000_WRITE_DATA1

*&----------------------------------------------------------------------
*&      Form  P3000_WRITE_DATA2
*&----------------------------------------------------------------------
FORM P3000_WRITE_DATA2.

  CLEAR IT_TAB.

  LOOP AT IT_TAB.

    CLEAR LFA1.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ IT_TAB-LIFNR.

    IF IT_TAB-LIFNR = 'X0201'.
      MOVE  'A'   TO  IT_TAB-CODE.
    ENDIF.
    IF IT_TAB-LIFNR = 'X0401'.
      MOVE  'B'   TO  IT_TAB-CODE.
    ENDIF.
    IF IT_TAB-LIFNR = 'X0301'.
      MOVE  'C'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'JP'  AND
       IT_TAB-LIFNR  NE 'X0201'.
      MOVE  'D'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'US'  AND
       IT_TAB-LIFNR  NE 'X0401'.
      MOVE  'E'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'FR'  AND
       IT_TAB-LIFNR  NE 'X0301'.
      MOVE  'F'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'GB'.
      MOVE  'G'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'DE'.
      MOVE  'H'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'CH'.
      MOVE  'I'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'IT'.
      MOVE  'J'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 = 'CN'.
      MOVE  'K'   TO  IT_TAB-CODE.
    ENDIF.
    IF LFA1-LAND1 NE 'JP'  AND
       LFA1-LAND1 NE 'US'  AND
       LFA1-LAND1 NE 'FR'  AND
       LFA1-LAND1 NE 'GB'  AND
       LFA1-LAND1 NE 'DE'  AND
       LFA1-LAND1 NE 'CH'  AND
       LFA1-LAND1 NE 'IT'  AND
       LFA1-LAND1 NE 'CN'.
      MOVE  'L'   TO  IT_TAB-CODE.
    ENDIF.
    MODIFY IT_TAB INDEX SY-TABIX.

  ENDLOOP.

  SORT IT_TAB BY CODE ZFMATGB.

  LOOP AT IT_TAB.

    CLEAR LFA1.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ IT_TAB-LIFNR.

    IF SY-TABIX EQ 1.
      MOVE : IT_TAB-CODE    TO  SV_CODE,
             IT_TAB-ZFMATGB TO  SV_MATGB.
    ENDIF.

* ������ ���к�, �����ݾ׺��� SUM.
    IF SV_CODE NE IT_TAB-CODE.
      PERFORM  P2000_SUM_LINE_WRITE2.
      PERFORM  P3000_TOTAL_LINE_WRITE.
      MOVE : IT_TAB-CODE     TO SV_CODE,
             IT_TAB-ZFMATGB  TO SV_MATGB.
      CLEAR : SV_TBAU1, SV_TBAU2,     SV_TBAU3,  SV_TBAU4,
              SV_TBAU5, SV_TBAU6,     SV_TBAU7,  SV_TBAU8,
              SV_TBAU9, SV_TBAU10,    SV_TBAU11, SV_TBAU12,
              SV_TBAUS, SV_TOT_TBAU1, SV_TOT_TBAU2,
              SV_TOT_TBAU3,  SV_TOT_TBAU4,  SV_TOT_TBAU5,
              SV_TOT_TBAU6,  SV_TOT_TBAU7,  SV_TOT_TBAU8,
              SV_TOT_TBAU9,  SV_TOT_TBAU10, SV_TOT_TBAU11,
              SV_TOT_TBAU12, SV_TOT_TBAUS.
    ENDIF.

    IF SV_CODE   EQ  IT_TAB-CODE     AND
       SV_MATGB  NE  IT_TAB-ZFMATGB.
      PERFORM  P2000_SUM_LINE_WRITE2.
      MOVE : IT_TAB-ZFMATGB  TO  SV_MATGB.

      CLEAR : SV_TBAU1, SV_TBAU2,   SV_TBAU3,  SV_TBAU4,
              SV_TBAU5, SV_TBAU6,   SV_TBAU7,  SV_TBAU8,
              SV_TBAU9, SV_TBAU10,  SV_TBAU11, SV_TBAU12,
              SV_TBAUS.
    ENDIF.
* ���� / �Ⱓ�� ���Խ���.
    IF IT_TAB-ZFIDSDT+4(02) = '01'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU1,  SV_TOT_TBAU1.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '02'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU2,  SV_TOT_TBAU2.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '03'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU3,  SV_TOT_TBAU3.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '04'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU4,  SV_TOT_TBAU4.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '05'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU5,  SV_TOT_TBAU5.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '06'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU6,  SV_TOT_TBAU6.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '07'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU7,  SV_TOT_TBAU7.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '08'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU8,  SV_TOT_TBAU8.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '09'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU9,  SV_TOT_TBAU9.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '10'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU10, SV_TOT_TBAU10.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '11'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU11, SV_TOT_TBAU11.
    ENDIF.
    IF IT_TAB-ZFIDSDT+4(02) = '12'.
      ADD  IT_TAB-ZFTBAU   TO : SV_TBAU12, SV_TOT_TBAU12.
    ENDIF.
    ADD  IT_TAB-ZFTBAU   TO : SV_TBAUS,  SV_TOT_TBAUS.

  ENDLOOP.
  PERFORM  P2000_SUM_LINE_WRITE2.
  PERFORM  P3000_TOTAL_LINE_WRITE.

ENDFORM.                    " P3000_WRITE_DATA2
*&----------------------------------------------------------------------
*&      Form  RESET_LIST
*&----------------------------------------------------------------------
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " ��� ���...
* ����Ʈ Write
  IF R_MATE = 'X'  OR
     R_TERM = 'X'.
    PERFORM   P3000_WRITE_DATA1.
  ENDIF.
  IF R_COUN = 'X'.
    PERFORM   P3000_WRITE_DATA2.
  ENDIF.
ENDFORM.                              " RESET_LIST

*&---------------------------------------------------------------------
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------

FORM P2000_PAGE_CHECK.

  IF W_LINE >= 53.
    WRITE : / SY-ULINE.
    W_PAGE = W_PAGE + 1.    W_LINE = 0.
    NEW-PAGE.
  ENDIF.

ENDFORM.                              " P2000_Page_Check

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------

FORM P3000_TITLE_WRITE.
  SKIP 1.

* ���� / ������ ���Խ���.
  IF  R_MATE = 'X'.
    MAX_LINSZ = 240.
    WRITE : /50 '   [ ���籸�� / ������ ���Խ��� ]   ' COLOR 1.
    SKIP 1.
    WRITE : /216 'DATE :', SY-DATUM.
    WRITE : /3 'CIF(USD)',
             15 '�����Ⱓ :', S_IDSDT-LOW, '-', S_IDSDT-HIGH,
            216 'PAGE :', SY-PAGNO.
    NEW-LINE. ULINE AT 1(MAX_LINSZ).

    FORMAT COLOR 1 INTENSIFIED OFF.
    WRITE : / SY-VLINE,
        (15) '���籸��'      CENTERED,        SY-VLINE,
        (15) '�÷�Ʈ'        CENTERED,        SY-VLINE,
*         (17) '��������'      CENTERED,        SY-VLINE,
*         (17) 'ROYAL MAXIM '  CENTERED,        SY-VLINE,
*         (17) 'P B S'         CENTERED,        SY-VLINE,
        (17) '��  ��'        CENTERED,        SY-VLINE,
        (17) '��  ��'        CENTERED,        SY-VLINE,
        (17) '������'        CENTERED,        SY-VLINE,
        (17) '��  ��'        CENTERED,        SY-VLINE,
        (17) '��  ��'        CENTERED,        SY-VLINE,
        (17) '������'        CENTERED,        SY-VLINE,
        (17) '���¸�'        CENTERED,        SY-VLINE,
        (17) '��  ��'        CENTERED,        SY-VLINE,
        (17) '��  Ÿ'        CENTERED,        SY-VLINE,
        (20) '��  ��'        CENTERED,        SY-VLINE.
    NEW-LINE. ULINE AT 1(MAX_LINSZ).

* ���� / �Ⱓ�� ���Խ���.
  ELSEIF R_TERM = 'X'.
    MAX_LINSZ = 300.
    WRITE : /65 '   [ ���籸�� / �Ⱓ�� ���Խ��� ]   ' COLOR 1.
    SKIP 1.
    WRITE : /270 'DATE :', SY-DATUM.
    WRITE : /3 'CIF(USD)',
             15 '�����Ⱓ :', S_IDSDT-LOW, '-', S_IDSDT-HIGH,
            270 'PAGE :', SY-PAGNO.
    WRITE : / SY-ULINE.

    FORMAT COLOR 1 INTENSIFIED OFF.
    WRITE : / SY-VLINE,
        (15) '���籸��'      CENTERED,        SY-VLINE,
        (15) '�÷�Ʈ'        CENTERED,        SY-VLINE,
        (17) '1  ��'         CENTERED,        SY-VLINE,
        (17) '2  ��'         CENTERED,        SY-VLINE,
        (17) '3  ��'         CENTERED,        SY-VLINE,
        (17) '4  ��'         CENTERED,        SY-VLINE,
        (17) '5  ��'         CENTERED,        SY-VLINE,
        (17) '6  ��'         CENTERED,        SY-VLINE,
        (17) '7  ��'         CENTERED,        SY-VLINE,
        (17) '8  ��'         CENTERED,        SY-VLINE,
        (17) '9  ��'         CENTERED,        SY-VLINE,
        (17) '10 ��'         CENTERED,        SY-VLINE,
        (17) '11 ��'         CENTERED,        SY-VLINE,
        (17) '12 ��'         CENTERED,        SY-VLINE,
        (20) '��  ��'        CENTERED,        SY-VLINE.
    WRITE : / SY-ULINE.

* ���� / �Ⱓ�� ���Խ���.
  ELSEIF R_COUN = 'X'.
    MAX_LINSZ = 300.
    WRITE : /65 '   [ �������� / �Ⱓ�� ���Խ��� ]   ' COLOR 1.
    SKIP 1.
    WRITE : /270 'DATE :', SY-DATUM.
    WRITE : /3 'CIF(USD)',
             15 '�����Ⱓ :', S_IDSDT-LOW, '-', S_IDSDT-HIGH,
            270 'PAGE :', SY-PAGNO.
    WRITE : / SY-ULINE.

    FORMAT COLOR 1 INTENSIFIED OFF.
    WRITE : / SY-VLINE,
        (15) '��    ��'      CENTERED,        SY-VLINE,
        (15) '���籸��'      CENTERED,        SY-VLINE,
        (17) '1  ��'         CENTERED,        SY-VLINE,
        (17) '2  ��'         CENTERED,        SY-VLINE,
        (17) '3  ��'         CENTERED,        SY-VLINE,
        (17) '4  ��'         CENTERED,        SY-VLINE,
        (17) '5  ��'         CENTERED,        SY-VLINE,
        (17) '6  ��'         CENTERED,        SY-VLINE,
        (17) '7  ��'         CENTERED,        SY-VLINE,
        (17) '8  ��'         CENTERED,        SY-VLINE,
        (17) '9  ��'         CENTERED,        SY-VLINE,
        (17) '10 ��'         CENTERED,        SY-VLINE,
        (17) '11 ��'         CENTERED,        SY-VLINE,
        (17) '12 ��'         CENTERED,        SY-VLINE,
        (20) '��  ��'        CENTERED,        SY-VLINE.
    WRITE : / SY-ULINE.

  ENDIF.

ENDFORM.                             " FORM P3000_TITLE_WRITE
*&----------------------------------------------------------------------
*&      Form  P2000_SUM_LINE_WRITE1
*&----------------------------------------------------------------------
FORM P2000_SUM_LINE_WRITE1.

  CASE SV_MATGB.
    WHEN '1'.
      MOVE  '����� ������'  TO W_TEXT.
    WHEN '2'.
      MOVE  'Local'          TO W_TEXT.
    WHEN '3'.
      MOVE  '������ ������'  TO W_TEXT.
    WHEN '4'.
      MOVE  '�ü���'         TO W_TEXT.
    WHEN '5'.
      MOVE  '��   ǰ'        TO W_TEXT.
    WHEN '6'.
      MOVE  '��   ǰ'        TO W_TEXT.
  ENDCASE.

  SELECT SINGLE NAME1 INTO W_WERKSNM
    FROM T001W
   WHERE WERKS  EQ SV_WERKS.

  WRITE : / SY-VLINE,
         (15) W_TEXT,                            SY-VLINE,
         (15) W_WERKSNM,                         SY-VLINE.
  IF R_MATE NE 'X'.
    WRITE : (17) SV_TBAU1      CURRENCY 'USD',      SY-VLINE,
            (17) SV_TBAU2      CURRENCY 'USD',      SY-VLINE,
            (17) SV_TBAU3      CURRENCY 'USD',      SY-VLINE.
  ENDIF.
  WRITE : (17) SV_TBAU4      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU5      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU6      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU7      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU8      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU9      CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU10     CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU11     CURRENCY 'USD',      SY-VLINE,
          (17) SV_TBAU12     CURRENCY 'USD',      SY-VLINE,
          (20) SV_TBAUS      CURRENCY 'USD',      SY-VLINE.
  NEW-LINE. ULINE AT 1(MAX_LINSZ).

ENDFORM.                    " P2000_SUM_LINE_WRITE1
*&----------------------------------------------------------------------
*&      Form  P2000_SUM_LINE_WRITE2
*&----------------------------------------------------------------------
FORM P2000_SUM_LINE_WRITE2.

  CASE SV_CODE.
*      WHEN 'A'.
*         MOVE  '��������'       TO W_CODE.
*      WHEN 'B'.
*         MOVE  'ROYAL MAXIM'    TO W_CODE.
*      WHEN 'C'.
*         MOVE  'PBS'            TO W_CODE.
    WHEN 'D'.
      MOVE  '��  ��'         TO W_CODE.
    WHEN 'E'.
      MOVE  '��  ��'         TO W_CODE.
    WHEN 'F'.
      MOVE  '������'         TO W_CODE.
    WHEN 'G'.
      MOVE  '��  ��'         TO W_CODE.
    WHEN 'H'.
      MOVE  '��  ��'         TO W_CODE.
    WHEN 'I'.
      MOVE  '������'         TO W_CODE.
    WHEN 'J'.
      MOVE  '���¸�'         TO W_CODE.
    WHEN 'K'.
      MOVE  '��  ��'         TO W_CODE.
    WHEN 'L'.
      MOVE  '��  Ÿ'         TO W_CODE.

  ENDCASE.

  CASE SV_MATGB.
    WHEN '1'.
      MOVE '����� ������'   TO W_TEXT.
    WHEN '2'.
      MOVE  'Local'          TO W_TEXT.
    WHEN '3'.
      MOVE  '������ ������'  TO W_TEXT.
    WHEN '4'.
      MOVE  '�ü���'         TO W_TEXT.
    WHEN '5'.
      MOVE  '��   ǰ'        TO W_TEXT.
    WHEN '6'.
      MOVE  '��   ǰ'        TO W_TEXT.
  ENDCASE.

  WRITE : / SY-VLINE,
         (15) W_CODE,                            SY-VLINE,
         (15) W_TEXT,                            SY-VLINE,
         (17) SV_TBAU1      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU2      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU3      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU4      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU5      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU6      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU7      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU8      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU9      CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU10     CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU11     CURRENCY 'USD',      SY-VLINE,
         (17) SV_TBAU12     CURRENCY 'USD',      SY-VLINE,
         (20) SV_TBAUS      CURRENCY 'USD',      SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P2000_SUM_LINE_WRITE2

*&----------------------------------------------------------------------
*&      Form  P3000_TOTAL_LINE_WRITE
*&----------------------------------------------------------------------
FORM P3000_TOTAL_LINE_WRITE.
  WRITE : / SY-VLINE,
         (33) '��      ��'  CENTERED,            SY-VLINE.
  IF R_MATE NE 'X'.
    WRITE : (17) SV_TOT_TBAU1  CURRENCY 'USD',      SY-VLINE,
            (17) SV_TOT_TBAU2  CURRENCY 'USD',      SY-VLINE,
            (17) SV_TOT_TBAU3  CURRENCY 'USD',      SY-VLINE.
  ENDIF.
  WRITE : (17) SV_TOT_TBAU4  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU5  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU6  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU7  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU8  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU9  CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU10 CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU11 CURRENCY 'USD',      SY-VLINE,
          (17) SV_TOT_TBAU12 CURRENCY 'USD',      SY-VLINE,
          (20) SV_TOT_TBAUS  CURRENCY 'USD',      SY-VLINE.
  NEW-LINE. ULINE AT 1(MAX_LINSZ).
ENDFORM.                    " P3000_TOTAL_LINE_WRITE
