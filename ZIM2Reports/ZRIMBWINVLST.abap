*&---------------------------------------------------------------------*
*& Report  ZRIMBWINVLST                                                *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����â�� �����Ȳ                                     *
*&      �ۼ��� : ��ä��                                                *
*&      �ۼ��� : 2001.10.05                                            *
*$     ����ȸ��: LG ȭ��
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*& 2001.11.11 �迵��
*&      : ������ ���԰� �������, ������ȸ �߰�.
*&---------------------------------------------------------------------*
REPORT  ZRIMBWINVLST MESSAGE-ID ZIM
*                     LINE-SIZE 93
                     NO STANDARD PAGE HEADING.

TABLES: ZTBLINR,
        ZTBLOUR,
        ZTBL,
        ZTBLINR_TMP,
        ZTTRHD,
        ZTTRIT.

DATA: CURSORFIELD(20).

DATA: LS_DAY_ATTRIBUTES      LIKE CASDAYATTR OCCURS 0
                                  WITH HEADER LINE.

*----------------------------------------------------------------------*
* ���ͳ����̺�.
*----------------------------------------------------------------------*

DATA : BEGIN OF IT_INR OCCURS 0,
       ZFINDT  LIKE ZTBLINR-ZFINDT,
       COUNT1  TYPE I,       " ����.
       ZFINWT  LIKE ZTBLINR-ZFINWT.
DATA : END OF IT_INR.

DATA : BEGIN OF IT_INR_TMP OCCURS 0,
       ZFINDT  LIKE ZTBLINR_TMP-ZFINDT,
       COUNT1  TYPE I,       " ����.
       ZFINWT  LIKE ZTBLINR_TMP-ZFTOWT.
DATA : END OF IT_INR_TMP.

DATA : BEGIN OF IT_OUR OCCURS 0,
       ZFOTDT  LIKE ZTBLOUR-ZFOTDT,
       COUNT2  TYPE I,       " ����.
       ZFOUWT  LIKE ZTBLOUR-ZFOUWT.
DATA : END OF IT_OUR.

DATA : COUNT1     TYPE I,                  " ����.
       COUNT1_TMP TYPE I,                  " ����������
       ZFINWT     LIKE ZTBLINR-ZFINWT,     " �����߷�.
       ZFINWT_TMP LIKE ZTBLINR_TMP-ZFTOWT, " �����������߷�.
       COUNT2     TYPE I,                  " ����.
       ZFOUWT     LIKE ZTBLOUR-ZFOUWT,     " �����߷�.
       COUNT3     TYPE I,                  " ���.
       INVWT      LIKE ZTBLOUR-ZFOUWT.     " ����߷�.

DATA : BEGIN OF IT_TAB OCCURS 0,
       COUNT1  TYPE I,       " ����.
       COUNT2  TYPE I,       " ����.
       COUNT3  TYPE I,       " ���.
       ZFINWT  LIKE ZTBLINR-ZFINWT,    " �����߷�.
       ZFOUWT  LIKE ZTBLOUR-ZFOUWT,    " �����߷�.
       INVWT   LIKE ZTBLOUR-ZFOUWT,    " ����߷�.
       ZFOTDT  LIKE ZTBLOUR-ZFOTDT.    " ������.
DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TAB_TMP OCCURS 0,
       ZFLOC      LIKE ZTBLINR_TMP-ZFLOC,        "������ġ
       ZFBLNO     LIKE ZTBLINR_TMP-ZFBLNO,       "B/L������ȣ
       ZFTOWT     LIKE ZTBLINR_TMP-ZFTOWT,       "�����߷�
       ZFREBELN   LIKE ZTBLINR_TMP-ZFREBELN,     "��ǥPO
       ZFSHNO     LIKE ZTBLINR_TMP-ZFSHNO,       "��������
       ZFRGDSR    LIKE ZTBL-ZFRGDSR,             "��ǥǰ��
       ZFPKCN     LIKE ZTBLINR_TMP-ZFPKCN,       "����-�����尹��
       ZFPKCNM    LIKE ZTBLINR_TMP-ZFPKCNM,      "�������
       ZFTOWTM    LIKE ZTBLINR_TMP-ZFTOWTM,      "�߷�����
       ZFETA      LIKE ZTBLINR_TMP-ZFETA,        "��������
       ZFINDT     LIKE ZTBLINR_TMP-ZFINDT,       "������(�԰���)
       ZFCARNM    LIKE ZTBLINR_TMP-ZFCARNM,      "����
       ZFHBLNO    LIKE ZTBLINR_TMP-ZFHBLNO,      "House B/L
       ZFSHTY     LIKE ZTBLINR_TMP-ZFSHTY,       "��۱���
       ZFINRNO    LIKE ZTBLINR_TMP-ZFINRNO.      "���Թ�ȣ
DATA : END OF IT_TAB_TMP.

DATA : BEGIN OF IT_TAB_INV OCCURS 0,
       ZFLOC      LIKE ZTBLINR_TMP-ZFLOC,        "������ġ
       ZFBLNO     LIKE ZTBLINR_TMP-ZFBLNO,       "B/L������ȣ
       ZFTOWT     LIKE ZTBLINR_TMP-ZFTOWT,       "�����߷�
       ZFREBELN   LIKE ZTBLINR_TMP-ZFREBELN,     "��ǥPO
       ZFSHNO     LIKE ZTBLINR_TMP-ZFSHNO,       "��������
       ZFRGDSR    LIKE ZTBL-ZFRGDSR,             "��ǥǰ��
       ZFPKCN     LIKE ZTBLINR_TMP-ZFPKCN,       "����-�����尹��
       ZFPKCNM    LIKE ZTBLINR_TMP-ZFPKCNM,      "�������
       ZFTOWTM    LIKE ZTBLINR_TMP-ZFTOWTM,      "�߷�����
       ZFETA      LIKE ZTBLINR_TMP-ZFETA,        "��������
       ZFINDT     LIKE ZTBLINR_TMP-ZFINDT,       "������(�԰���)
       ZFCARNM    LIKE ZTBLINR_TMP-ZFCARNM,      "����
       ZFHBLNO    LIKE ZTBLINR_TMP-ZFHBLNO,      "House B/L
       ZFSHTY     LIKE ZTBLINR_TMP-ZFSHTY,       "��۱���
       ZFINRNO    LIKE ZTBLINR_TMP-ZFINRNO,      "���Թ�ȣ
       W_COUNT    TYPE I.
DATA : END OF IT_TAB_INV.

DATA:  S_LOC   LIKE ZTBLINR_TMP-ZFLOC,
       S_TOWT  LIKE ZTBLINR_TMP-ZFTOWT,
       S_COUNT TYPE I.

DATA: W_TABIX   LIKE SY-TABIX,
      W_LINE    TYPE I,
      W_ERR_CHK TYPE C,
      W_MOD     TYPE I,
      W_COUNT   TYPE I.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: S_OTDT  FOR ZTBLOUR-ZFOTDT NO-EXTENSION
                                           OBLIGATORY.
PARAMETERS:     P_ABNAR LIKE ZTBLINR-ZFABNAR OBLIGATORY. " ��������.
SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_ABNAR.
  PERFORM   P1000_CODE_HELP  USING  P_ABNAR  'P_ABNAR'.


* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
  PERFORM   P2000_SET_PARAMETER.
* Title Text Write
TOP-OF-PAGE.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

*>> ���� ���� �Լ�.
*   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
*   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*  ���̺� SELECT
  PERFORM   P1000_GET_ZTBW      USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'. MESSAGE S738.   EXIT.    ENDIF.
* ����Ʈ Write
  NEW-PAGE LINE-SIZE 93 NO-HEADING .

  PERFORM   P3000_DATA_WRITE       USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.  EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
  CASE SY-UCOMM.

    WHEN 'DOWN'.          " FILE DOWNLOAD....
      PERFORM P3000_CREATE_DOWNLOAD_FILE.
*           PERFORM P3000_TO_PC_DOWNLOAD.
    WHEN 'INV_DETL'.
      PERFORM P1000_DISP_INVT.
    WHEN OTHERS.
  ENDCASE.

*---------------------------------------------------------------------
* AT LINE-SELECTION.
*----------------------------------------------------------------------
AT LINE-SELECTION.
  IF IT_TAB-ZFOTDT IS INITIAL.
    MESSAGE S962.
  ELSE.
    GET CURSOR FIELD CURSORFIELD.
    IF SY-SUBRC EQ 0.
      CASE CURSORFIELD.
        WHEN 'IT_TAB-COUNT1' OR 'IT_TAB-ZFINWT'.
          IF IT_TAB-COUNT1 IS INITIAL.
            MESSAGE S962.EXIT.
          ENDIF.
          PERFORM P1000_READ_ZTBLINR USING IT_TAB-ZFOTDT
                                           P_ABNAR.

        WHEN 'IT_TAB-COUNT2' OR 'IT_TAB-ZFOUWT'.
          IF IT_TAB-COUNT2 IS INITIAL.
            MESSAGE S962.EXIT.
          ENDIF.
          PERFORM P1000_READ_DATE_ZTBLOUR USING IT_TAB-ZFOTDT
                                                P_ABNAR.

        WHEN 'IT_TAB-COUNT3' OR 'IT_TAB-ZINVWT'.
          IF IT_TAB-COUNT3 IS INITIAL.
            MESSAGE S962. EXIT.
          ENDIF.

          PERFORM P1000_DISP_INVT.

        WHEN OTHERS.
          MESSAGE S962.
      ENDCASE.
    ELSE.
      MESSAGE S962.
    ENDIF.

  ENDIF.
  CLEAR : IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIMR68'.          " TITLE BAR
  MOVE :    'I'          TO  S_OTDT-SIGN,
            'BT'         TO  S_OTDT-OPTION,
            SY-DATUM     TO  S_OTDT-HIGH.
  CONCATENATE SY-DATUM(6) '01' INTO S_OTDT-LOW.
  APPEND S_OTDT.


ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.
  WRITE : /35 '[ ����â�������Ȳ ]'.
  SKIP 1.
  WRITE : /3 '��ȸ�Ⱓ',S_OTDT-LOW,'~',S_OTDT-HIGH.
  WRITE:/3 '��ġ�� ��ȣ',P_ABNAR.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-ULINE.
  WRITE : / SY-VLINE NO-GAP,(10) '     ' NO-GAP CENTERED
                            COLOR COL_NORMAL INTENSIFIED OFF,
            SY-VLINE NO-GAP,(26) '����'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(26) '����'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(26) '���'  NO-GAP CENTERED,
            SY-VLINE.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE :/ SY-VLINE,12 SY-ULINE.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,(10) '   ' NO-GAP CENTERED
                              COLOR COL_NORMAL INTENSIFIED OFF,
            SY-VLINE NO-GAP,(05) '�Ǽ�'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(20) '�߷�'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(05) '�Ǽ�'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(20) '�߷�'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(05) '�Ǽ�'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(20) '�߷�'  NO-GAP CENTERED,
            SY-VLINE.
  WRITE : / SY-ULINE.

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

  DATA : FROM_DATE LIKE    SY-DATUM,
         TO_DATE   LIKE    SY-DATUM.
  CLEAR: W_COUNT.

  W_ERR_CHK = 'N'.

  FROM_DATE = S_OTDT-LOW.
  TO_DATE   = S_OTDT-HIGH.

*        get attributes of day.
  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
       EXPORTING
*              factory_calendar           = factory_calendar
*              holiday_calendar           = holiday_calendar
             DATE_FROM                  = FROM_DATE
             DATE_TO                    = TO_DATE
             LANGUAGE                   = SY-LANGU
       TABLES
             DAY_ATTRIBUTES             = LS_DAY_ATTRIBUTES
       EXCEPTIONS
             FACTORY_CALENDAR_NOT_FOUND = 1
             HOLIDAY_CALENDAR_NOT_FOUND = 2
             DATE_HAS_INVALID_FORMAT    = 3
             DATE_INCONSISTENCY         = 4
             OTHERS                     = 5.
*       send error messages
  IF SY-SUBRC <> 0.
    W_ERR_CHK = 'N'.
    MESSAGE ID SY-MSGID TYPE 'S' NUMBER SY-MSGNO
                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    EXIT.
  ENDIF.

*  ls_day_attributes

  REFRESH: IT_INR, IT_OUR, IT_TAB.

  SELECT ZFINDT COUNT( * ) AS COUNT1 SUM( ZFINWT ) AS ZFINWT
         INTO CORRESPONDING FIELDS OF TABLE IT_INR
         FROM ZTBLINR
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFINDT  IN S_OTDT
         GROUP BY ZFINDT.

* ������ ���԰� ����.
  SELECT ZFINDT COUNT( * ) AS COUNT1 SUM( ZFTOWT ) AS ZFINWT
         INTO CORRESPONDING FIELDS OF TABLE IT_INR_TMP
         FROM ZTBLINR_TMP
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFINDT  IN S_OTDT
         AND    ZFMCYN  NE 'X'
         GROUP BY ZFINDT.

  IF SY-SUBRC = 0.
    LOOP AT IT_INR.
      W_TABIX = SY-TABIX.

      READ TABLE IT_INR_TMP WITH KEY ZFINDT = IT_INR-ZFINDT.

      IF SY-SUBRC = 0.
        W_COUNT = IT_INR-COUNT1 + IT_INR_TMP-COUNT1.
        IT_INR-COUNT1 = W_COUNT.
        IT_INR-ZFINWT = IT_INR-ZFINWT + IT_INR_TMP-ZFINWT.

        MODIFY IT_INR  INDEX W_TABIX.
      ELSE.
        IT_INR-ZFINDT = IT_INR_TMP-ZFINDT.
        IT_INR-COUNT1 = IT_INR_TMP-COUNT1.
        IT_INR-ZFINWT = IT_INR_TMP-ZFINWT.

        APPEND IT_INR.
      ENDIF.

    ENDLOOP.
  ENDIF.

  SELECT ZFOTDT COUNT( * ) AS COUNT2 SUM( ZFOUWT ) AS ZFOUWT
         INTO CORRESPONDING FIELDS OF TABLE IT_OUR
         FROM ZTBLOUR
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFOTDT  IN S_OTDT
         GROUP BY ZFOTDT.

  SELECT COUNT( * ) AS COUNT1 SUM( ZFINWT ) AS ZFINWT
         INTO (COUNT1, ZFINWT)
         FROM ZTBLINR
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFINDT  <  FROM_DATE.

* ������ ���԰�
  SELECT COUNT( * ) AS COUNT1 SUM( ZFTOWT ) AS ZFINWT
         INTO (COUNT1_TMP, ZFINWT_TMP)
         FROM ZTBLINR_TMP
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFINDT  <  FROM_DATE
         AND    ZFMCYN  <> 'X'.

  IF SY-SUBRC = 0.
    COUNT1 = COUNT1 + COUNT1_TMP.
    ZFINWT = ZFINWT + ZFINWT_TMP.
  ENDIF.

  SELECT COUNT( * ) AS COUNT2 SUM( ZFOUWT ) AS ZFOUWT
         INTO (COUNT2, ZFOUWT)
         FROM ZTBLOUR
         WHERE  ZFABNAR EQ P_ABNAR
         AND    ZFOTDT  <  FROM_DATE.

  REFRESH : IT_TAB.
  CLEAR : IT_TAB.

  IT_TAB-COUNT3 = COUNT1 - COUNT2.
  IT_TAB-INVWT  = ZFINWT - ZFOUWT.

  APPEND IT_TAB.

  MOVE : IT_TAB-INVWT   TO INVWT,
         IT_TAB-COUNT3  TO COUNT3.

  LOOP AT LS_DAY_ATTRIBUTES.
    CLEAR : IT_TAB.
    MOVE LS_DAY_ATTRIBUTES-DATE TO IT_TAB-ZFOTDT.
    READ TABLE IT_INR WITH KEY ZFINDT = LS_DAY_ATTRIBUTES-DATE.

    IF SY-SUBRC EQ 0.
      MOVE : IT_INR-ZFINWT  TO IT_TAB-ZFINWT,
             IT_INR-COUNT1  TO IT_TAB-COUNT1.
    ENDIF.

    READ TABLE IT_OUR WITH KEY ZFOTDT = LS_DAY_ATTRIBUTES-DATE.
    IF SY-SUBRC EQ 0.
      MOVE : IT_OUR-ZFOUWT  TO IT_TAB-ZFOUWT,
             IT_OUR-COUNT2  TO IT_TAB-COUNT2.
    ENDIF.

    INVWT   = INVWT  + IT_TAB-ZFINWT - IT_TAB-ZFOUWT.
    COUNT3  = COUNT3 + IT_TAB-COUNT1 - IT_TAB-COUNT2.

    MOVE : INVWT   TO  IT_TAB-INVWT,
           COUNT3  TO  IT_TAB-COUNT3.

    APPEND IT_TAB.
  ENDLOOP.

ENDFORM.                    " P1000_GET_ZTBW.

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

  SET PF-STATUS 'ZIMR68'.           " GUI STATUS SETTING
  SET  TITLEBAR 'ZIMR68'.           " GUI TITLE SETTING..

  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.
    W_MOD = SY-TABIX MOD 2.
    PERFORM P3000_LINE_WRITE.
    AT LAST.
      PERFORM P3000_LAST_WRITE.
    ENDAT.
  ENDLOOP.
  CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LAST_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
  FORMAT RESET.

  IF W_MOD EQ 0.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ELSE.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ENDIF.

  IF W_TABIX = 1.
    WRITE : / SY-VLINE NO-GAP,(10) '�����̿�' NO-GAP.
  ELSE.
    WRITE : / SY-VLINE NO-GAP,(10) IT_TAB-ZFOTDT NO-GAP.
  ENDIF.
  WRITE: SY-VLINE NO-GAP,(05) IT_TAB-COUNT1  NO-GAP,
         SY-VLINE NO-GAP,(20) IT_TAB-ZFINWT UNIT 'KG' NO-GAP,
         SY-VLINE NO-GAP,(05) IT_TAB-COUNT2   NO-GAP,
         SY-VLINE NO-GAP,(20) IT_TAB-ZFOUWT UNIT 'KG' NO-GAP,
         SY-VLINE NO-GAP,(05) IT_TAB-COUNT3  NO-GAP,
         SY-VLINE NO-GAP,(20) IT_TAB-INVWT UNIT 'KG'  NO-GAP,
         SY-VLINE.
* hide
  HIDE: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
FORM P3000_CREATE_DOWNLOAD_FILE.

*  REFRESH IT_TAB_DOWN.
*  LOOP AT IT_TAB.
*    CLEAR IT_TAB_DOWN.
*    MOVE-CORRESPONDING IT_TAB TO IT_TAB_DOWN.
*    WRITE : IT_TAB-MENGE   UNIT     IT_TAB-MEINS TO IT_TAB_DOWN-MENGE,
*        IT_TAB-ZFUSDAM CURRENCY IT_TAB-ZFUSD TO IT_TAB_DOWN-ZFUSDAM,
*         IT_TAB-ZFOPAMT CURRENCY IT_TAB-WAERS TO IT_TAB_DOWN-ZFOPAMT.
*    APPEND IT_TAB_DOWN.
*  ENDLOOP.

ENDFORM.                    " P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*&  FORM P1000_READ_ZTBLINR USING    P_ZFOTDT.
*&---------------------------------------------------------------------*
FORM P1000_READ_ZTBLINR USING    P_ZFOTDT P_ZFABNAR.
  PERFORM P3000_ZTBLINR_TITILE.

  SELECT *
    FROM ZTBLINR_TMP
   WHERE ZFINDT EQ P_ZFOTDT
     AND ZFABNAR EQ P_ZFABNAR.

    CLEAR ZTBL.

    SELECT SINGLE *
      FROM ZTBL
     WHERE ZFBLNO = ZTBLINR_TMP-ZFBLNO.

    W_COUNT = W_COUNT + 1.
    W_MOD = W_COUNT MOD 2.

    PERFORM P3000_ZTBLINR_WRITE.
  ENDSELECT.

  WRITE : / SY-ULINE.

ENDFORM.                    " P1000_READ_ZTBLINR
*&---------------------------------------------------------------------*
*&      Form  P3000_ZTBLINR_TITILE
*&---------------------------------------------------------------------*
FORM P3000_ZTBLINR_TITILE.
  NEW-PAGE LINE-SIZE 95 NO-HEADING .

  SKIP 2.
  WRITE : /40 '[���Ի󼼳���]'.
  SKIP 1.
  WRITE :/ '������:',IT_TAB-ZFOTDT.
  WRITE : / SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,(12) 'P/O No' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(18) 'B/L No'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(18) '���Թ�ȣ' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(10) '������' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '�߷�' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(08) 'PKG����' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(04) '����' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(03) 'SLo' NO-GAP CENTERED,
            SY-VLINE.
  WRITE : / SY-ULINE.


ENDFORM.                    " P3000_ZTBLINR_TITILE
*&---------------------------------------------------------------------*
*&      Form  P3000_ZTBLINR_WRITE
*&---------------------------------------------------------------------*
FORM P3000_ZTBLINR_WRITE.
  DATA : W_TEXT(15) TYPE C.

  SET PF-STATUS 'DTINR'.           " GUI STATUS SETTING
  SET  TITLEBAR 'DTINR' WITH 'Carry-in'. " GUI TITLE SETTING..

  IF W_MOD EQ 0.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ELSE.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ENDIF.

  CONCATENATE ZTBL-ZFREBELN '-' ZTBL-ZFSHNO INTO W_TEXT.
  WRITE :/ SY-VLINE NO-GAP,(12) W_TEXT NO-GAP,
           SY-VLINE NO-GAP,(18) ZTBLINR_TMP-ZFHBLNO  NO-GAP,
           SY-VLINE NO-GAP,(18) ZTBLINR_TMP-ZFINRNO NO-GAP,
           SY-VLINE NO-GAP,(10) ZTBLINR_TMP-ZFINDT  NO-GAP,
           SY-VLINE NO-GAP,(13) ZTBLINR_TMP-ZFTOWT
                                UNIT ZTBLINR_TMP-ZFTOWTM NO-GAP,
           SY-VLINE NO-GAP,(08) ZTBLINR_TMP-ZFPKCN NO-ZERO NO-GAP,
           SY-VLINE NO-GAP,(04) ZTBLINR_TMP-ZFPKCNM NO-GAP,
           SY-VLINE NO-GAP,(03) ZTBLINR_TMP-ZFLOC   NO-GAP,  "������ġ.
           SY-VLINE.

ENDFORM.                    " P3000_ZTBLINR_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATE_ZTBLOUR
*&---------------------------------------------------------------------*
FORM P1000_READ_DATE_ZTBLOUR USING    P_ZFOTDT P_ZFABNAR.

  PERFORM P3000_ZTBLOUR_TITILE.
  W_COUNT = 0.

  SELECT *
    FROM ZTBLOUR
   WHERE ZFOTDT EQ P_ZFOTDT
     AND ZFABNAR EQ P_ZFABNAR.

    CLEAR ZTBL.
    SELECT SINGLE *
      FROM ZTBL
     WHERE ZFBLNO = ZTBLOUR-ZFBLNO.

    SELECT SINGLE *
      FROM ZTBLINR_TMP
     WHERE ZFBLNO  = ZTBLOUR-ZFBLNO
       AND ZFBTSEQ = ZTBLOUR-ZFBTSEQ.

    W_COUNT = W_COUNT + 1.
    W_MOD = W_COUNT MOD 2.
    PERFORM P3000_ZTBLOUR_WRITE.

  ENDSELECT.

  WRITE : / SY-ULINE.

ENDFORM.                    " P1000_READ_DATE_ZTBLOUR
*&---------------------------------------------------------------------*
*&      Form  P3000_ZTBLOUR_TITILE
*&---------------------------------------------------------------------*
FORM P3000_ZTBLOUR_TITILE.
  NEW-PAGE LINE-SIZE 95 NO-HEADING .

  SKIP 2.
  WRITE : /40 '[����󼼳���]'.
  SKIP 1.
  WRITE :/ '������:',IT_TAB-ZFOTDT.
  WRITE :/  SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,(12) 'P/O No' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(20) 'B/L No'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(18) '�����ȣ' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(10) '������' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '�߷�' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(08) 'PKG����' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(04) '����' NO-GAP CENTERED,
            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_ZTBLOUR_TITILE
*&---------------------------------------------------------------------*
*&      Form  P3000_ZTBLOUR_WRITE
*&---------------------------------------------------------------------*
FORM P3000_ZTBLOUR_WRITE.
  DATA : W_TEXT(15) TYPE C.

  SET PF-STATUS 'DTINR'.           " GUI STATUS SETTING
  SET  TITLEBAR 'DTINR' WITH 'Carry-out'. " GUI TITLE SETTING..

  IF W_MOD EQ 0.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ELSE.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ENDIF.

  CONCATENATE ZTBL-ZFREBELN '-' ZTBL-ZFSHNO INTO W_TEXT.
  WRITE :/ SY-VLINE NO-GAP,(12) W_TEXT NO-GAP,
           SY-VLINE NO-GAP,(20) ZTBL-ZFHBLNO  NO-GAP,
           SY-VLINE NO-GAP,(18) ZTBLINR_TMP-ZFINRNO NO-GAP,
           SY-VLINE NO-GAP,(10) ZTBLOUR-ZFOTDT NO-GAP,
           SY-VLINE NO-GAP,(15) ZTBLOUR-ZFOUWT UNIT ZTBLOUR-ZFKG NO-GAP,
           SY-VLINE NO-GAP,(08) ZTBLOUR-ZFOUQN NO-ZERO NO-GAP,
           SY-VLINE NO-GAP,(04) ZTBLOUR-ZFOUQNM NO-GAP,
           SY-VLINE.

ENDFORM.                    " P3000_ZTBLOUR_WRITE


*&---------------------------------------------------------------------*
*&      Form  P1000_DISP_INVT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_DISP_INVT.
  NEW-PAGE LINE-SIZE 161 NO-HEADING.

  PERFORM P1000_GET_INV.
  PERFORM P3000_INV_TITLE_WRITE.
  PERFORM P3000_INV_LINE_WRITE.

ENDFORM.                    " P1000_DISP_INVT
*&---------------------------------------------------------------------*
*&      Form  P3000_INV_TITLE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_INV_TITLE_WRITE.
  SKIP 2.

  WRITE : /70 '[B/L�� �����]' COLOR COL_HEADING INTENSIFIED ON.
  SKIP 1.
  WRITE :/ '������:',S_OTDT-HIGH.
  WRITE :/  SY-ULINE.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.

  WRITE : / SY-VLINE NO-GAP, (12) 'P/O No'   CENTERED,
            SY-VLINE NO-GAP, (15) 'ǰ��'     CENTERED,
            SY-VLINE NO-GAP, (10) '���尹��' CENTERED,
            SY-VLINE NO-GAP, (16) '�߷�'     CENTERED,
            SY-VLINE NO-GAP,  (8) '������'   CENTERED,
            SY-VLINE NO-GAP,  (8) '�԰���'   CENTERED,
            SY-VLINE NO-GAP, (12) '����'     CENTERED,
            SY-VLINE NO-GAP, (15) 'B/L No'   CENTERED,
            SY-VLINE NO-GAP,  (6) '��ü��'   CENTERED,
            SY-VLINE NO-GAP,  (8) '��۱���' CENTERED,
            SY-VLINE NO-GAP,  (8) '������ġ' CENTERED,
            SY-VLINE NO-GAP, (18) '���Թ�ȣ' CENTERED,

            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_INV_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_INV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_GET_INV.
  DATA : W_FINDT_LOW LIKE ZTBLINR-ZFINDT,
         W_COUNT TYPE I,
         W_TEMP  TYPE I,
         W_TEXT(4)  TYPE C,
         W_TEMP_VAL LIKE ZTBLINR-ZFINWT.

  CLEAR :IT_TAB_INV.
  REFRESH: IT_TAB_INV.

  MOVE S_OTDT-HIGH(4) TO W_TEMP.
  W_TEMP = W_TEMP - 2 .
  MOVE W_TEMP TO W_TEXT.
  MOVE W_TEXT TO W_FINDT_LOW.
  CONCATENATE W_FINDT_LOW(4) S_OTDT-HIGH+4(4) INTO W_FINDT_LOW.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_TAB_TMP
    FROM ZTBLINR_TMP
   WHERE ZFABNAR EQ P_ABNAR
     AND ZFINDT BETWEEN W_FINDT_LOW AND S_OTDT-HIGH .

  LOOP AT IT_TAB_TMP.
    W_TABIX = SY-TABIX.

    SELECT COUNT(*)
      INTO W_COUNT
      FROM ZTBLOUR
     WHERE ZFBLNO = IT_TAB_TMP-ZFBLNO.

    IF W_COUNT EQ 0.
      IT_TAB_INV = IT_TAB_TMP.

      SELECT SINGLE ZFRGDSR
        INTO IT_TAB_INV-ZFRGDSR
        FROM ZTBL
       WHERE ZFBLNO = IT_TAB_INV-ZFBLNO.

      IT_TAB_INV-W_COUNT = 1.
      APPEND IT_TAB_INV.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " P1000_GET_INV
*&---------------------------------------------------------------------*
*&      Form  P3000_INV_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_INV_LINE_WRITE.
  DATA : W_TEMP_DATE TYPE I,
         W_TEMP_TEXT(15) TYPE C.

  FORMAT RESET.
  SORT IT_TAB_INV BY ZFLOC ZFINDT.

  LOOP AT IT_TAB_INV.
    ON CHANGE OF IT_TAB_INV-ZFLOC.
      IF SY-TABIX NE 1.
        PERFORM P3000_WRITE_SUB_TOTL.
      ENDIF.
    ENDON.

    FORMAT RESET.
    FORMAT COLOR 2.
    W_TEMP_DATE =  S_OTDT-HIGH - IT_TAB_INV-ZFINDT.
    CONCATENATE IT_TAB_INV-ZFREBELN '-' IT_TAB_INV-ZFSHNO
                INTO W_TEMP_TEXT.

    WRITE : / SY-VLINE NO-GAP, (12) W_TEMP_TEXT          CENTERED,
              SY-VLINE NO-GAP, (15) IT_TAB_INV-ZFRGDSR   CENTERED,
              SY-VLINE NO-GAP,  (7) IT_TAB_INV-ZFPKCN    NO-ZERO
                                    RIGHT-JUSTIFIED,
                                (2) IT_TAB_INV-ZFPKCNM
                                    LEFT-JUSTIFIED,
              SY-VLINE NO-GAP, (12) IT_TAB_INV-ZFTOWT
                                    UNIT IT_TAB_INV-ZFTOWTM
                                    RIGHT-JUSTIFIED,
                                (3) IT_TAB_INV-ZFTOWTM
                                    LEFT-JUSTIFIED,
              SY-VLINE NO-GAP,  (8) IT_TAB_INV-ZFETA     CENTERED,
              SY-VLINE NO-GAP,  (8) IT_TAB_INV-ZFINDT    CENTERED,
              SY-VLINE NO-GAP, (12) IT_TAB_INV-ZFCARNM
                                    LEFT-JUSTIFIED,
              SY-VLINE NO-GAP, (15) IT_TAB_INV-ZFHBLNO
                                    LEFT-JUSTIFIED,
              SY-VLINE NO-GAP,  (6) W_TEMP_DATE
                                    RIGHT-JUSTIFIED,
              SY-VLINE NO-GAP,  (8) IT_TAB_INV-ZFSHTY    CENTERED,
              SY-VLINE NO-GAP,  (8) IT_TAB_INV-ZFLOC     CENTERED,
              SY-VLINE NO-GAP, (18) IT_TAB_INV-ZFINRNO   CENTERED,
              SY-VLINE.
    WRITE : / SY-ULINE.

    ADD: IT_TAB_INV-ZFTOWT  TO S_TOWT,
         IT_TAB_INV-W_COUNT TO S_COUNT.

    AT LAST.
      PERFORM P3000_WRITE_SUB_TOTL.
      SUM.
      PERFORM P3000_WRITE_SUM_TOTL.
    ENDAT.
  ENDLOOP.

  REFRESH: IT_TAB_TMP, IT_TAB_INV.

ENDFORM.                    " P3000_INV_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_SUB_TOTL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_SUB_TOTL.
  FORMAT RESET.
  FORMAT COLOR 1.

  WRITE:/  SY-VLINE,
           '[�Ұ�] ' NO-GAP, S_COUNT NO-GAP, '��',
        28 '�Ұ� �߷�: ', S_TOWT UNIT ZTBLINR_TMP-ZFTOWTM, 'TON',
        161 SY-VLINE.
  WRITE:/  SY-ULINE.
  WRITE:/  SY-ULINE.
  S_COUNT = 0.
  S_TOWT  = 0.
ENDFORM.                    " P3000_WRITE_SUB_TOTL
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_SUM_TOTL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_SUM_TOTL.
  DATA : W_COUNT   TYPE I.

  DESCRIBE TABLE IT_TAB_INV LINES W_COUNT.

  FORMAT RESET.
  FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.

  WRITE:/    SY-VLINE,
             '[��]   ' NO-GAP,W_COUNT NO-GAP, '��',
          31 '���߷�: ', IT_TAB_INV-ZFTOWT UNIT IT_TAB_INV-ZFTOWTM
                       , 'TON',
         161 SY-VLINE.
  WRITE:/ SY-ULINE.
ENDFORM.                    " P3000_WRITE_SUM_TOTL
*&---------------------------------------------------------------------*
*&      Form  P1000_CODE_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_ABNAR  text
*----------------------------------------------------------------------*
FORM P1000_CODE_HELP USING    P_ABNAR P_FIELDNAME.
  DATA : L_DISPLAY.

  DATA: DYNPROG            LIKE SY-REPID,
        DYNNR              LIKE SY-DYNNR,
        WINDOW_TITLE(30)   TYPE C.
*>> ����ڵ� HELP.
  DATA : BEGIN OF IT_COST_HELP OCCURS 0,
         ZFBNAR    LIKE ZTIMIMG03-ZFBNAR,
         ZFBNARM   LIKE ZTIMIMG03-ZFBNARM,
         END OF IT_COST_HELP.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_COST_HELP
             FROM   ZTIMIMG03.

  IF SY-SUBRC NE 0.
    MESSAGE S406.
    EXIT.
  ENDIF.

  DYNPROG = SY-REPID.
  DYNNR   = SY-DYNNR.
*  W_FIELDNAME = 'ZTBSEG-ZFCD'.
*  W_FIELDNAME = P_FIELDNAME.
  WINDOW_TITLE = '����â�� �ڵ� Help'.
  CLEAR: L_DISPLAY.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
           EXPORTING
**                RETFIELD        = 'OTYPE'
                RETFIELD        = 'ZFBNAR'
                DYNPPROG        = DYNPROG
                DYNPNR          = DYNNR
                DYNPROFIELD     = P_FIELDNAME
                WINDOW_TITLE    = WINDOW_TITLE
                VALUE_ORG       = 'S'
*                DISPLAY         = L_DISPLAY
           TABLES
                VALUE_TAB       = IT_COST_HELP
           EXCEPTIONS
                PARAMETER_ERROR = 1
                NO_VALUES_FOUND = 2
                OTHERS          = 3.
  IF SY-SUBRC <> 0.
    EXIT.
  ENDIF.

ENDFORM.                    " P1000_CODE_HELP
