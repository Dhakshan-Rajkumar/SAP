*&---------------------------------------------------------------------*
*& Report  ZRIMMANST                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� ������ ��Ȳ.                                     *
*&      �ۼ��� : �ͼ�ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.11.16                                            *
*&---------------------------------------------------------------------*
*&   DESC.    : ���� ��ǰ�� �������� ���纰, �������� �����Ͽ� ��Ȳ��.
*&              �ľ��Ѵ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMMANST    MESSAGE-ID ZIM
                     LINE-SIZE 114
                     NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------
* TABLE �� INTERNAL TABLE, ���� Define
*----------------------------------------------------------------------
TABLES : ZTREQHD,
         ZTREQIT,
         LFA1,
         ZTREQST,
         EKPO,
         MAKT.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MATNR           LIKE   ZTREQIT-MATNR,        " �����ȣ.
       MFRNR           LIKE   ZTREQIT-MFRNR,
       LIFNR           LIKE   ZTREQHD-LIFNR,        " Vendor
       ZFREQNO         LIKE   ZTREQIT-ZFREQNO,      " �����Ƿڹ�ȣ.
       NAME3(25)       TYPE   C,                    " ��������.
       NAME2(25)       TYPE   C,                    " �����.
       LAND1           LIKE   LFA1-LAND1,           " �����ڵ�.
       NAME1(25)       TYPE   C,
       ZFOPNDT         LIKE   ZTREQST-ZFOPNDT,      " ������.
       EMATN           LIKE   EKPO-EMATN,           " ����ǰ��ȣ.
       EBELN           LIKE   EKPO-EBELN,           " P/O No.
       CODE(10)        TYPE   C.

DATA : END OF IT_TAB.

*DATA : BEGIN OF IT_LAND1 OCCURS 0,
*       LAND1          LIKE   T005T-LAND1,           " �����ڵ�.
*       LANDX          LIKE   T005T-LANDX.
*DATA : END   OF IT_LAND1.

*----------------------------------------------------------------------
* ���� ����.
*----------------------------------------------------------------------
DATA : W_ERR_CHK         TYPE  C,
       W_SUBRC           LIKE  SY-SUBRC,
       W_PAGE            TYPE  I,                  " Page Counter
       W_LINE            TYPE  I,                  " Line Count
       W_FLAG            TYPE  C,
       W_COUNT           TYPE  I,                  " ��ü COUNT
       W_COLOR           TYPE  I,
       W_LIST_INDEX      LIKE  SY-TABIX,
       W_TABIX           LIKE  SY-TABIX,           " Table Index
       W_LINES           TYPE  I,
       W_SELECTED_LINES  TYPE  P,                  " ���� Line Count
       W_JUL             TYPE  C,
       W_TEXT(20)        TYPE  C,
       WRITE_CHK         TYPE  C,
       W_MOD             TYPE  I,
       W_LIFNR           LIKE  LFA1-LIFNR,
       SV_LIFNR          LIKE  ZTREQHD-LIFNR,
       SV_MATNR          LIKE  ZTREQIT-MATNR,
       SV_MFRNR          LIKE  ZTREQIT-MFRNR.

INCLUDE   ZRIMUTIL01.                        " Utility function ���.
INCLUDE   ZRIMSORTCOM.                       " Sort�� ���� Include

*----------------------------------------------------------------------
* Selection Screen ��.
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

   SELECT-OPTIONS: S_MATNR  FOR ZTREQIT-MATNR,     " �����ȣ.
                   S_MFRNR  FOR ZTREQIT-MFRNR,     " ������.
                   S_LIFNR  FOR ZTREQHD-LIFNR,     " ����.
                   S_OPNDT  FOR ZTREQST-ZFOPNDT.   " ������.
   SELECTION-SCREEN SKIP.

   PARAMETER : R_MAT   RADIOBUTTON GROUP GP1,      " ���纰.
               R_MAN   RADIOBUTTON GROUP GP1,      " ��������.
               R_VEN   RADIOBUTTON GROUP GP1.      " ������.

SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------
* Initialization.
*----------------------------------------------------------------------
INITIALIZATION.                                 " �ʱⰪ SETTING
   SET  TITLEBAR 'ZIMR06'.                      " GUI TITLE SETTING..
   PERFORM   P2000_INIT.

*----------------------------------------------------------------------
* Top-Of-Page.
*----------------------------------------------------------------------
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " ��� ���...

*----------------------------------------------------------------------
* Start Of Selection ��.
*----------------------------------------------------------------------
START-OF-SELECTION.

* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE       USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*----------------------------------------------------------------------
* User Command
*----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.

      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM RESET_LIST.
      WHEN 'BACK' OR 'EXIT' OR 'CANC'.
            LEAVE TO SCREEN 0.                " ����.

      WHEN OTHERS.
   ENDCASE.
*&---------------------------------------------------------------------
*&      Form  P2000_INIT
*&---------------------------------------------------------------------

FORM P2000_INIT.
*  P_V = 'X'.
*  P_Y = 'X'.

ENDFORM.                                     " P2000_INIT

*----------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------

FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIMR06'.                   " GUI STATUS SETTING
   SET TITLEBAR  'ZIMR06'.                   " GUI TITLE SETTING

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   IF R_MAT = 'X'.
      LOOP  AT  IT_TAB.

         W_COUNT = W_COUNT + 1.
         W_MOD   = W_COUNT MOD 2.

         IF SY-TABIX = 1.
            R_MAT = 'X'.
            MOVE  IT_TAB-MATNR  TO  SV_MATNR.
         ENDIF.

         IF IT_TAB-MATNR NE SV_MATNR.
            MOVE  IT_TAB-MATNR  TO  SV_MATNR.
            CLEAR WRITE_CHK.
            NEW-PAGE.
            R_MAT = 'X'.
         ENDIF.

         PERFORM  P3000_LINE_WRITE.

       ENDLOOP.
   ELSEIF R_MAN = 'X'.
      LOOP  AT  IT_TAB.

         W_COUNT = W_COUNT + 1.
         W_MOD   = W_COUNT MOD 2.

         IF SY-TABIX = 1.
            R_MAN = 'X'.
            MOVE  IT_TAB-MFRNR  TO  SV_MFRNR.
         ENDIF.

         IF IT_TAB-MFRNR NE SV_MFRNR.
            MOVE  IT_TAB-MFRNR  TO  SV_MFRNR.
            CLEAR WRITE_CHK.
            NEW-PAGE.
            R_MAN = 'X'.
         ENDIF.

         PERFORM  P3000_LINE_WRITE.

       ENDLOOP.
   ELSEIF R_VEN = 'X'.
      LOOP  AT  IT_TAB.

         W_COUNT = W_COUNT + 1.
         W_MOD   = W_COUNT MOD 2.

         IF SY-TABIX = 1.
            R_VEN = 'X'.
            MOVE  IT_TAB-LIFNR  TO  SV_LIFNR.
         ENDIF.

         IF IT_TAB-LIFNR NE SV_LIFNR.
            MOVE  IT_TAB-LIFNR  TO  SV_LIFNR.
            CLEAR WRITE_CHK.
            NEW-PAGE.
            R_VEN = 'X'.
         ENDIF.

         PERFORM  P3000_LINE_WRITE.

       ENDLOOP.

   ENDIF.

ENDFORM.                                       " P3000_Data_Write

*&---------------------------------------------------------------------
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------

FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                                      " P2000_Page_Check

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------

FORM P3000_TITLE_WRITE.
   SKIP 1.
   IF R_MAT = 'X'.

      WRITE : /45 '  [ ���� ���纰 ������ ��Ȳ ] ' COLOR 1.
      SKIP 1.
      WRITE : /95 'DATE :', SY-DATUM.

      CLEAR : MAKT.
      SELECT SINGLE *
        FROM MAKT   WHERE MATNR EQ SV_MATNR
                    AND   SPRAS EQ SY-LANGU.

      WRITE : /4  '�����ȣ :', SV_MATNR, MAKT-MAKTX,
             95 'PAGE :', SY-PAGNO.
      WRITE : / SY-ULINE.
      FORMAT COLOR 1 INTENSIFIED OFF.
      WRITE : / SY-VLINE,
                (10) '�������ڵ�',               SY-VLINE,
                (25) '������ ��' CENTERED,       SY-VLINE,
                (10) '�����ڵ�',                 SY-VLINE,
                (25) '���� ��'   CENTERED,       SY-VLINE,
                (08) '�����ڵ�'  CENTERED,       SY-VLINE,
                (17) 'MPN No.'   CENTERED,       SY-VLINE.

      WRITE : / SY-ULINE.

   ELSEIF  R_MAN = 'X'.
     WRITE : /45 '   ���� �������� ���� ��Ȳ  ' COLOR 1.
     SKIP 1.
     WRITE : /95 'DATE :', SY-DATUM.

     CLEAR : LFA1.
     SELECT SINGLE *
       FROM ZTREQIT   WHERE MFRNR  EQ SV_MFRNR.

     WRITE : /4  '�� �� �� :', SV_MFRNR, LFA1-NAME1,
             95 'PAGE :', SY-PAGNO.
     WRITE : / SY-ULINE.
     FORMAT COLOR 1 INTENSIFIED OFF.
     WRITE : / SY-VLINE,
               (10) '�����ڵ�',                SY-VLINE,
               (25) '���� ��'   CENTERED,      SY-VLINE,
               (08) '�����ڵ�'  CENTERED,      SY-VLINE,
               (10) '�����ȣ',                SY-VLINE,
               (25) '���� ��'   CENTERED,      SY-VLINE,
               (17) 'MPN No.'   CENTERED,      SY-VLINE.

     WRITE : / SY-ULINE.

  ELSEIF  R_VEN = 'X'.
     WRITE : /45 '   ���� ������ ������ ��Ȳ  ' COLOR 1.
     SKIP 1.
     WRITE : /95 'DATE :', SY-DATUM.

     CLEAR : LFA1.
     SELECT SINGLE *
       FROM LFA1   WHERE LIFNR  EQ  SV_LIFNR.

     WRITE : /4  '�� �� :', SV_LIFNR, LFA1-NAME1,
              95 'PAGE :', SY-PAGNO.
     WRITE : / SY-ULINE.
     FORMAT COLOR 1 INTENSIFIED OFF.
     WRITE : / SY-VLINE,
               (10) '�������ڵ�',              SY-VLINE,
               (25) '������ ��' CENTERED,      SY-VLINE,
               (08) '�����ڵ�'  CENTERED,      SY-VLINE,
               (10) '�����ȣ',                SY-VLINE,
               (25) '���� ��'   CENTERED,      SY-VLINE,
               (17) 'MPN No.'   CENTERED,      SY-VLINE.

     WRITE : / SY-ULINE.

  ENDIF.

ENDFORM.                                   " Form P3000_TITLE_WRITE
*&---------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------

FORM P3000_LINE_WRITE.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED ON.

*   SELECT SINGLE MATNR INTO IT_TAB-BMATN
*     FROM MARA
*    WHERE BMATN  EQ IT_TAB-BMATN
*      AND MFRNR  EQ IT_TAB-MFRNR.

   IF R_MAT = 'X'.

     WRITE : / SY-VLINE,
            (10) IT_TAB-MATNR,               SY-VLINE,
            (25) IT_TAB-NAME3,               SY-VLINE,
            (10) IT_TAB-LIFNR,               SY-VLINE,
            (25) IT_TAB-NAME1,               SY-VLINE,
            (08) IT_TAB-LAND1   CENTERED,    SY-VLINE,
            (17) IT_TAB-EMATN   CENTERED,    SY-VLINE.
     WRITE : / SY-ULINE.

   ELSEIF  R_MAN = 'X'.
     WRITE : / SY-VLINE,
            (10) IT_TAB-LIFNR,               SY-VLINE,
            (25) IT_TAB-NAME1,               SY-VLINE,
            (08) IT_TAB-LAND1   CENTERED,    SY-VLINE,
            (10) IT_TAB-MATNR,               SY-VLINE,
            (25) IT_TAB-NAME2,               SY-VLINE,
            (17) IT_TAB-EMATN   CENTERED,    SY-VLINE.
     WRITE : / SY-ULINE.

  ELSEIF  R_VEN = 'X'.
     WRITE : / SY-VLINE,
            (10) IT_TAB-MFRNR,               SY-VLINE,
            (25) IT_TAB-NAME3,               SY-VLINE,
            (08) IT_TAB-LAND1   CENTERED,    SY-VLINE,
            (10) IT_TAB-MATNR,               SY-VLINE,
            (25) IT_TAB-NAME2,               SY-VLINE,
            (17) IT_TAB-EMATN   CENTERED,    SY-VLINE.
     WRITE : / SY-ULINE.

  ENDIF.

* Stored value...
   MOVE SY-TABIX  TO W_LIST_INDEX.
   HIDE IT_TAB.
*   W_COUNT = W_COUNT + 1.

*   WRITE: / SY-ULINE.

ENDFORM.                                     " P3000_Line_Write

*&---------------------------------------------------------------------
*&      Form  RESET_LIST
*&---------------------------------------------------------------------

FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE  = 1.
  W_LINE  = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.               " ��� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE  USING   W_ERR_CHK.

ENDFORM.                                     " Reset_List

*&---------------------------------------------------------------------
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------

FORM P1000_READ_TEXT    USING W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   REFRESH : IT_TAB.

   IF R_MAT = 'X'.

      SELECT B~MATNR A~LIFNR  B~MFRNR    MAX( D~EMATN ) AS EMATN
             MAX( B~MEINS )   AS MEINS   MAX( B~TXZ01 ) AS NAME2
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
      FROM ( ZTREQHD  AS  A   INNER JOIN  ZTREQIT AS B
      ON     A~ZFREQNO        EQ    B~ZFREQNO )
      INNER  JOIN     ZTREQST AS    C
      ON     A~ZFREQNO        EQ    C~ZFREQNO
      INNER  JOIN     EKPO    AS    D
      ON     A~EBELN          EQ    D~EBELN
      AND    B~EBELP          EQ    D~EBELP
      WHERE  B~MFRNR          IN    S_MFRNR
      AND    B~MATNR          IN    S_MATNR
      AND    A~LIFNR          IN    S_LIFNR
      AND    C~ZFOPNDT        IN    S_OPNDT
      GROUP  BY
             B~MATNR B~MFRNR  A~LIFNR.

   ELSEIF R_MAN = 'X'.

      SELECT A~LIFNR  B~MATNR  B~MFRNR  MAX( D~EMATN ) AS EMATN
             MAX( B~MEINS )   AS MEINS  MAX( B~TXZ01 ) AS NAME2
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
      FROM ( ( ZTREQHD  AS  A   INNER JOIN  ZTREQIT AS B
      ON     A~ZFREQNO        EQ    B~ZFREQNO )
      INNER  JOIN     ZTREQST AS    C
      ON     A~ZFREQNO        EQ    C~ZFREQNO )
      INNER  JOIN     EKPO    AS    D
      ON     B~EBELN          EQ    D~EBELN
      AND    B~EBELP          EQ    D~EBELP
      WHERE  B~MFRNR          IN    S_MFRNR
      AND    B~MATNR          IN    S_MATNR
      AND    A~LIFNR          IN    S_LIFNR
      AND    C~ZFOPNDT        IN    S_OPNDT
      GROUP  BY
             B~MFRNR  A~LIFNR  B~MATNR .

   ELSEIF R_VEN = 'X'.

      SELECT A~LIFNR B~MATNR  B~MFRNR   MAX( D~EMATN ) AS EMATN
             MAX( B~MEINS )   AS MEINS  MAX( B~TXZ01 ) AS NAME2
      INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
      FROM ( ( ZTREQHD  AS  A   INNER JOIN  ZTREQIT AS B
      ON     A~ZFREQNO        EQ    B~ZFREQNO )
      INNER  JOIN     ZTREQST AS    C
      ON     A~ZFREQNO        EQ    C~ZFREQNO )
      INNER  JOIN     EKPO    AS    D
      ON     B~EBELN          EQ    D~EBELN
      AND    B~EBELP          EQ    D~EBELP
      WHERE  B~MFRNR          IN    S_MFRNR
      AND    B~MATNR          IN    S_MATNR
      AND    A~LIFNR          IN    S_LIFNR
      AND    C~ZFOPNDT        IN    S_OPNDT
      GROUP  BY
             A~LIFNR B~MFRNR B~MATNR  .
   ENDIF.

      DESCRIBE TABLE IT_TAB LINES W_LINE.
      IF W_LINE EQ 0. W_SUBRC = 4. EXIT. ENDIF.

*>> INTERNAL TABLE �� VENDOR ��, ��������, ����� DISPLAY
      LOOP AT IT_TAB.

         W_TABIX = SY-TABIX.

         SELECT SINGLE NAME1 LAND1
           INTO (IT_TAB-NAME3, IT_TAB-LAND1)
           FROM LFA1   WHERE LIFNR EQ IT_TAB-MFRNR.

*         SELECT SINGLE MAKTX INTO IT_TAB-NAME2
*          FROM MAKT   WHERE MATNR EQ IT_TAB-MATNR
*                      AND   SPRAS EQ SY-LANGU.

         SELECT SINGLE NAME1 INTO IT_TAB-NAME1
           FROM LFA1   WHERE LIFNR EQ IT_TAB-LIFNR.

         MODIFY IT_TAB INDEX W_TABIX.

      ENDLOOP.

ENDFORM.                    " P1000_READ_TEXT

*&---------------------------------------------------------------------
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------
*       text
*----------------------------------------------------------------------
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------

FORM P2000_CONFIG_CHECK USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select
*  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

*  IF ZTIMIMG00-ZFCGYN IS INITIAL.
*     W_ERR_CHK = 'Y'.   MESSAGE S573.   EXIT.
*  ENDIF.


ENDFORM.                    " P2000_CONFIG_CHECK
