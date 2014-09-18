*&---------------------------------------------------------------------*
*& Report            ZRIMBTDLY                                         *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���� ���� ȭ�� ���� ����                            *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.28                                            *
*&     ����ȸ��: �ѱ����¿��ڷ�(��).                                   *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMBTDLY   NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 131.

TABLES : ZTBL,                       " Bill of Lading Header
         ZTBLINR_TMP,                " B/L ���ԽŰ� TEMP
         ZTIMIMG03,                  " �������� �ڵ�.
         ZTIMIMG00,                  " IMG
         DD07T,
         ZSBLINR_TMP.

DATA: BEGIN OF IT_TAB OCCURS 0,
           ZFTBLNO        LIKE ZTBLINR_TMP-ZFTBLNO,     "���԰�����ȣ.
           ZFGMNO         LIKE ZTBLINR_TMP-ZFGMNO,      "ȭ��������ȣ.
           ZFMSN          LIKE ZTBLINR_TMP-ZFMSN,       " (MSN)
           ZFHSN          LIKE ZTBLINR_TMP-ZFHSN,       " (HSN)
           W_MHSN(10)     TYPE C,
           ZFINDT         LIKE ZTBLINR_TMP-ZFINDT,       "������.
           ZFREBELN       LIKE ZTBLINR_TMP-ZFREBELN,     "��ǥ PO NO.
           ZFHBLNO        LIKE ZTBLINR_TMP-ZFHBLNO,      "HOUST BL NO.
           ZFBLNO         LIKE ZTBLINR_TMP-ZFBLNO,      "BL ������ȣ.
           ZFHSCL         LIKE ZTBLINR_TMP-ZFHSCL,      "ǰ��з�.
           W_HSCL(25)     TYPE C,
           ZFOKPK         LIKE ZTBLINR_TMP-ZFOKPK,      "���԰���.
           ZFPKCNM        LIKE ZTBLINR_TMP-ZFPKCNM,     "�������.
           ZFINWT         LIKE ZTBLINR_TMP-ZFINWT,      "�����߷�.
           ZFTOWTM        LIKE ZTBLINR_TMP-ZFTOWTM,     "�߷�����.
           ZFINTY         LIKE ZTBLINR_TMP-ZFINTY,      "��������.
           W_INTY(24)     TYPE C,
           ZFBTRNO        LIKE ZTBLINR_TMP-ZFBTRNO,     "����Ű��ȣ.
           ZFACPK         LIKE ZTBLINR_TMP-ZFACPK,      "�����.
           ZFACWT         LIKE ZTBLINR_TMP-ZFACWT,      "����߷�.
           ZFINACD        LIKE ZTBLINR_TMP-ZFINACD,     "�������.
           W_INACD(24)    TYPE C.
DATA: END OF IT_TAB.

DATA : W_SUBRC         LIKE  SY-SUBRC,
       W_TABIX         LIKE  SY-TABIX,
       W_ERR_CHK(1)    TYPE C,
       W_DOM_TEX1(10)  TYPE C,
       W_TMP_TEXT(18)  TYPE C,
       W_CNT(4),
       L_FNAME(30).

DATA: W_FIELD_NM        LIKE DD03D-FIELDNAME.   " �ʵ�?

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMOLECOM.     " OLE ������.
*-----------------------------------------------------------------------
* Selection Screen .
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.

SELECT-OPTIONS: S_PO   FOR  ZTBL-ZFREBELN NO-EXTENSION,
                S_INDT FOR  ZTBLINR_TMP-ZFINDT NO-EXTENSION OBLIGATORY.

PARAMETERS    : P_ABNAR     LIKE ZTBLINR_TMP-ZFABNAR  OBLIGATORY.

SELECT-OPTIONS: S_LOC       FOR  ZTBLINR_TMP-ZFLOC NO-EXTENSION,
                S_INRNO     FOR  ZTBLINR_TMP-ZFINRNO NO-EXTENSION,
                S_HBL       FOR  ZTBL-ZFHBLNO NO-EXTENSION,
                S_ETA       FOR  ZTBLINR_TMP-ZFETA NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK B1.
*---------------------------------------------------------------------*
* EVENT AT SELECTION-SCREEN ON VALUE-REQUEST.
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_ABNAR.
  PERFORM   P1000_CODE_HELP(ZRIMBWINVLST)
                           USING  P_ABNAR  'P_ABNAR'.
*---------------------------------------------------------------------*
* EVENT INITIALIZATION.
*---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM P1000_INITIALIZATION.
*---------------------------------------------------------------------*
* EVENT START-OF-SELECTION.
*---------------------------------------------------------------------*
START-OF-SELECTION.
  SET TITLEBAR 'TI1000'.
  SET PF-STATUS 'PF1000'.

  PERFORM P1000_READ_DATA.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

  PERFORM P1000_WRITE_DATA.

*---------------------------------------------------------------------*
* EVENT TOP-OF-PAGE.
*---------------------------------------------------------------------*
TOP-OF-PAGE.
  PERFORM P1000_TOP_PAGE.
*-----------------------------------------------------------------------
* EVENT AT USER-COMMAND.
*-----------------------------------------------------------------------
AT USER-COMMAND.
  CASE SY-UCOMM.
    WHEN 'DISP_BL'.
      PERFORM P2000_DISP_BL.

    WHEN 'DISP_IN'.
      PERFORM P2000_DISP_IN.

    WHEN 'STUP' OR 'STDN'.
      GET CURSOR FIELD W_FIELD_NM.
      ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
      PERFORM HANDLE_SORT TABLES  IT_TAB
                           USING   SY-UCOMM.
      CLEAR : IT_TAB.

    WHEN 'REFR'.
      PERFORM   P1000_READ_DATA.
      IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
      PERFORM RESET_LIST.

    WHEN 'EXCEL'.
      PERFORM P3000_EXCEL_DOWNLOAD.

    WHEN OTHERS.
  ENDCASE.

*&---------------------------------------------------------------------
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------
FORM P1000_READ_DATA.
  REFRESH IT_TAB.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE IT_TAB
    FROM ZTBLINR_TMP
   WHERE ZFREBELN IN S_PO
     AND ZFINDT IN S_INDT
     AND ZFABNAR = P_ABNAR
     AND ZFLOC IN S_LOC
     AND ZFINRNO IN S_INRNO
     AND ZFHBLNO IN S_HBL
     AND ZFETA IN S_ETA.

  IF SY-SUBRC NE 0.
    W_ERR_CHK = 'Y'.
    MESSAGE S738.
    EXIT.
  ENDIF.

  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.
*> (MSN - HSN).
    CONCATENATE IT_TAB-ZFMSN '-' IT_TAB-ZFHSN
                INTO IT_TAB-W_MHSN SEPARATED BY SPACE.
*>  ǰ��з���.
    PERFORM  GET_DD07T_SELECT USING 'ZDHSCL' IT_TAB-ZFHSCL
                              CHANGING   IT_TAB-W_HSCL.
*>  ����������.
    PERFORM  GET_DD07T_SELECT USING 'ZDINTY' IT_TAB-ZFINTY
                              CHANGING   IT_TAB-W_INTY.
*>  ���������.
    PERFORM  GET_DD07T_SELECT USING 'ZDINACD' IT_TAB-ZFINACD
                              CHANGING   IT_TAB-W_INACD.

    MODIFY IT_TAB INDEX W_TABIX.
  ENDLOOP.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P1000_TOP_PAGE
*&---------------------------------------------------------------------
FORM P1000_TOP_PAGE.
  SKIP 1.
  WRITE:/50 '[ ���� ���� ȭ�� ���� ��Ȳ ]' COLOR 1.
  SKIP 1.
  WRITE: /86 '��ġ��  No. : ', P_ABNAR.

  SELECT SINGLE * FROM ZTIMIMG03 WHERE ZFBNAR = P_ABNAR.
  WRITE: /86 '�� ġ �� �� : ', (25) ZTIMIMG03-ZFBNARM.
  WRITE: / '�۾����� : ', SY-DATUM, SY-UZEIT.

  IF S_INDT-HIGH IS INITIAL.
    IF S_INDT-LOW NE SY-DATUM.
      WRITE: 86 '�˻� ������ : ', (10) S_INDT-LOW.
    ENDIF.
  ELSE.
    WRITE: 86 '�˻����ԱⰣ: ', (10) S_INDT-LOW,
            '~', (10) S_INDT-HIGH.
  ENDIF.

  FORMAT RESET.
  ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE:/ SY-VLINE NO-GAP,
         (10) '��������'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (28) 'House B/L'  CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (10) '���尳��'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (16) '��    ��'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (28) '��������'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (20) '�ٰŹ�ȣ'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (11) 'ȭ������No' CENTERED NO-GAP,  SY-VLINE NO-GAP.

  WRITE:/ SY-VLINE NO-GAP,
         (10) '���Ź���'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (28) 'ǰ��з�'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (10) '�����'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (16) '����߷�'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (28) '�������'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (20) '��    ��'   CENTERED NO-GAP,  SY-VLINE NO-GAP,
         (11) ' '          CENTERED NO-GAP,  SY-VLINE NO-GAP.

  ULINE.

ENDFORM.                    " P1000_TOP_PAGE

*&---------------------------------------------------------------------
*&      Form  P1000_WRITE_DATA
*&---------------------------------------------------------------------
FORM P1000_WRITE_DATA.

  CLEAR : W_SUBRC.

  SORT  IT_TAB  BY  ZFINDT  ZFREBELN.

  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.

    IF W_SUBRC EQ 1.
      W_SUBRC = 2.    FORMAT COLOR 2 INTENSIFIED OFF.
    ELSE.
      W_SUBRC = 1.    FORMAT COLOR 2 INTENSIFIED ON.
    ENDIF.

    W_CNT = W_CNT + 1.

    WRITE:/ SY-VLINE NO-GAP,
           (10) IT_TAB-ZFINDT    NO-GAP,  SY-VLINE NO-GAP,
           (28) IT_TAB-ZFHBLNO   NO-GAP,  SY-VLINE NO-GAP,
           (08) IT_TAB-ZFOKPK    UNIT IT_TAB-ZFPKCNM NO-ZERO
                                 RIGHT-JUSTIFIED   NO-GAP,
           (02) IT_TAB-ZFPKCNM   NO-GAP,  SY-VLINE NO-GAP,
           (13) IT_TAB-ZFINWT    UNIT IT_TAB-ZFTOWTM
                                 RIGHT-JUSTIFIED   NO-GAP,
           (03) IT_TAB-ZFTOWTM   NO-GAP,  SY-VLINE NO-GAP,
           (04) IT_TAB-ZFINTY    NO-GAP,
           (24) IT_TAB-W_INTY    NO-GAP,  SY-VLINE NO-GAP,
           (20) IT_TAB-ZFBTRNO   NO-GAP,  SY-VLINE NO-GAP,
           (11) IT_TAB-ZFGMNO    NO-GAP,  SY-VLINE NO-GAP.

    HIDE: IT_TAB.

    WRITE:/ SY-VLINE NO-GAP,
           (10) IT_TAB-ZFREBELN  NO-GAP,  SY-VLINE NO-GAP,
           (03) IT_TAB-ZFHSCL    NO-GAP,
           (25) IT_TAB-W_HSCL    NO-GAP,  SY-VLINE NO-GAP,
           (08) IT_TAB-ZFACPK    UNIT IT_TAB-ZFPKCNM NO-ZERO
                                 RIGHT-JUSTIFIED   NO-GAP,
           (02) IT_TAB-ZFPKCNM   NO-GAP,  SY-VLINE NO-GAP,
           (13) IT_TAB-ZFACWT    UNIT IT_TAB-ZFTOWTM
                                 RIGHT-JUSTIFIED   NO-GAP,
           (03) IT_TAB-ZFTOWTM   NO-GAP,  SY-VLINE NO-GAP,
           (04) IT_TAB-ZFINACD   NO-GAP,
           (24) IT_TAB-W_INACD   NO-GAP,  SY-VLINE NO-GAP,
           (20) ' '              NO-GAP,  SY-VLINE NO-GAP,
           (11) IT_TAB-W_MHSN    CENTERED NO-GAP,  SY-VLINE NO-GAP.

    HIDE: IT_TAB.
    ULINE.

    IF W_CNT >= 26.
      NEW-PAGE.
      W_CNT = 0.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " P1000_WRITE_DATA
*&---------------------------------------------------------------------
*&      Form  P1000_INITIALIZATION
*&---------------------------------------------------------------------
FORM P1000_INITIALIZATION.
*    CONCATENATE SY-DATUM(6) '01' INTO S_INDT-LOW.
  S_INDT-LOW = SY-DATUM.
  APPEND S_INDT.
ENDFORM.                    " P1000_INITIALIZATION

*&---------------------------------------------------------------------*
*&      Form  GET_DD07T_SELECT
*&---------------------------------------------------------------------*
FORM GET_DD07T_SELECT USING    P_DOMNAME
                               P_FIELD
                      CHANGING P_W_NAME.
  CLEAR : DD07T, P_W_NAME.

  IF P_FIELD IS INITIAL.   EXIT.   ENDIF.

  SELECT * FROM DD07T WHERE DOMNAME     EQ P_DOMNAME
                      AND   DDLANGUAGE  EQ SY-LANGU
                      AND   AS4LOCAL    EQ 'A'
                      AND   DOMVALUE_L  EQ P_FIELD
                      ORDER BY AS4VERS DESCENDING.
    EXIT.
  ENDSELECT.

*   TRANSLATE DD07T-DDTEXT TO UPPER CASE.
  P_W_NAME   = DD07T-DDTEXT.
  TRANSLATE P_W_NAME TO UPPER CASE.
ENDFORM.                    " GET_DD07T_SELECT

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_BL
*&---------------------------------------------------------------------*
*&      B/L ������ȸ.
*&---------------------------------------------------------------------*
FORM P2000_DISP_BL.
  IF IT_TAB-ZFBLNO IS INITIAL.
    MESSAGE S951.
    STOP.
  ENDIF.

  SET PARAMETER ID 'ZPHBLNO'   FIELD ''.
  SET PARAMETER ID 'ZPBLNO'    FIELD IT_TAB-ZFBLNO.
  EXPORT 'ZPBLNO'        TO MEMORY ID 'ZPBLNO'.
  EXPORT 'ZPHBLNO'       TO MEMORY ID 'ZPHBLNO'.

* READ ZTIMIMG00.
  SELECT SINGLE * FROM ZTIMIMG00.

  IF ZTIMIMG00-BLSTYN EQ 'X'.
    CALL TRANSACTION 'ZIM23' AND SKIP  FIRST SCREEN.
  ELSE.
    CALL TRANSACTION 'ZIM22' AND SKIP  FIRST SCREEN.
  ENDIF.

ENDFORM.                    " P2000_DISP_BL

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_IN
*&---------------------------------------------------------------------*
*&      �������� ���Թ��� ��ȸ.
*&---------------------------------------------------------------------*
FORM P2000_DISP_IN.
  IF IT_TAB-ZFHBLNO IS INITIAL.
    MESSAGE S951.
    STOP.
  ENDIF.

  SET PARAMETER ID 'BES'       FIELD ''.
  SET PARAMETER ID 'ZPHBLNO'   FIELD IT_TAB-ZFHBLNO.
  SET PARAMETER ID 'ZPBLNO'    FIELD ''.
  SET PARAMETER ID 'ZPBTSEQ'   FIELD ''.

  EXPORT 'BES'           TO MEMORY ID 'BES'.
  EXPORT 'ZPBLNO'        TO MEMORY ID 'ZPBLNO'.
  EXPORT 'ZPHBLNO'       TO MEMORY ID 'ZPHBLNO'.
  EXPORT 'ZPBTSEQ'       TO MEMORY ID 'ZPBTSEQ'.

  CALL TRANSACTION 'ZIMI8' AND SKIP FIRST SCREEN.

ENDFORM.                    " P2000_DISP_IN

*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.
  MOVE 0 TO SY-LSIND.
  SET PF-STATUS 'PF1000'.
  SET TITLEBAR  'TI1000'.
  PERFORM P1000_TOP_PAGE.
  PERFORM P1000_WRITE_DATA.
ENDFORM.                    " RESET_LIST

*&---------------------------------------------------------------------*
*&      Form  P3000_EXCEL_DOWNLOAD
*&---------------------------------------------------------------------*
FORM P3000_EXCEL_DOWNLOAD.

   DATA : L_COL        TYPE I,
          L_ROW        TYPE I,
          L_WRBTR(20)  TYPE C,
          L_EBELN(12)  TYPE C.

  PERFORM P2000_EXCEL_INITIAL  USING  '����ü'
                                       10.

  PERFORM P2000_FIT_CELL    USING 1 12 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 1 'ȭ��������ȣ'.
  PERFORM P2000_FIT_CELL    USING 2 12 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 2 'MSN - HSN'.
  PERFORM P2000_FIT_CELL    USING 3 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 3 '��������'.
  PERFORM P2000_FIT_CELL    USING 4 10 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 4 'P/O No'.
  PERFORM P2000_FIT_CELL    USING 5 24 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 5 'B/L No.'.
  PERFORM P2000_FIT_CELL    USING 6 5 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 6 'ǰ��з��ڵ�'.
  PERFORM P2000_FIT_CELL    USING 7 25 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 7 'ǰ��з�'.
  PERFORM P2000_FIT_CELL    USING 8 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 8 '���尹��'.
  PERFORM P2000_FIT_CELL    USING 9 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 9 '�������'.
  PERFORM P2000_FIT_CELL    USING 10 13 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 10 '�߷�'.
  PERFORM P2000_FIT_CELL    USING 11 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 11 '�߷�����'.
  PERFORM P2000_FIT_CELL    USING 12 12 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 12 '���������ڵ�'.
  PERFORM P2000_FIT_CELL    USING 13 25 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 13 '��������'.
  PERFORM P2000_FIT_CELL    USING 14 18 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 14 '�ٰŹ�ȣ'.
  PERFORM P2000_FIT_CELL    USING 15 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 15 '�����'.
  PERFORM P2000_FIT_CELL    USING 16 13 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 16 '����߷�'.
  PERFORM P2000_FIT_CELL    USING 17 12 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 17 '��������ڵ�'.
  PERFORM P2000_FIT_CELL    USING 18 25 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 18 '�������'.
  PERFORM P2000_FIT_CELL    USING 19 8 'C'.  "COLUMN����.
  PERFORM P2000_FILL_CELL   USING 1 19 '���'.

  LOOP AT IT_TAB.
    L_ROW = SY-TABIX + 1.
    PERFORM P2000_FILL_CELL   USING L_ROW 1 IT_TAB-ZFBTRNO.
    PERFORM P2000_FILL_CELL   USING L_ROW 2 IT_TAB-W_MHSN.
    PERFORM P2000_FILL_CELL   USING L_ROW 3 IT_TAB-ZFINDT.
    PERFORM P2000_FILL_CELL   USING L_ROW 4 IT_TAB-ZFREBELN.
    PERFORM P2000_FILL_CELL   USING L_ROW 5 IT_TAB-ZFHBLNO.
    PERFORM P2000_FILL_CELL   USING L_ROW 6 IT_TAB-ZFHSCL.
    PERFORM P2000_FILL_CELL   USING L_ROW 7 IT_TAB-W_HSCL.
    PERFORM P2000_FILL_CELL   USING L_ROW 8 IT_TAB-ZFOKPK.
    PERFORM P2000_FILL_CELL   USING L_ROW 9 IT_TAB-ZFPKCNM.
    PERFORM P2000_FILL_CELL   USING L_ROW 10 IT_TAB-ZFINWT.
    PERFORM P2000_FILL_CELL   USING L_ROW 11 IT_TAB-ZFTOWTM.
    PERFORM P2000_FILL_CELL   USING L_ROW 12 IT_TAB-ZFINTY.
    PERFORM P2000_FILL_CELL   USING L_ROW 13 IT_TAB-W_INTY.
    PERFORM P2000_FILL_CELL   USING L_ROW 14 IT_TAB-ZFBTRNO.
    PERFORM P2000_FILL_CELL   USING L_ROW 15 IT_TAB-ZFACPK.
    PERFORM P2000_FILL_CELL   USING L_ROW 16 IT_TAB-ZFACWT.
    PERFORM P2000_FILL_CELL   USING L_ROW 17 IT_TAB-ZFINACD.
    PERFORM P2000_FILL_CELL   USING L_ROW 18 IT_TAB-W_INACD.
    PERFORM P2000_FILL_CELL   USING L_ROW 19 ' '.
  ENDLOOP.

  SET PROPERTY OF EXCEL 'VISIBLE' = 1.

ENDFORM.                    " P3000_EXCEL_DOWNLOAD
