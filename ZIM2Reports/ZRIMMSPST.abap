*&---------------------------------------------------------------------*
*& Report  ZRIMTCTOT                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����/ü���� ȸ�� ��ǥ �а�                            *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.22                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&  2001.03.30(������) : FI BDC Module �߰�.
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMMSPST   MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.
INCLUDE: <ICON>,
         ZRIMBDCCOM.

*-----------------------------------------------------------------------
* ����� TABLE DECLRAE
*-----------------------------------------------------------------------
TABLES : ZTMSHD,          "�� Header
         ZTMSCST,         "����/ü��
         ZTIMIMG11,
         ZVT001W,
         BKPF,
         BSEG,
         COBL,
         LFA1,
         SPOP,
         ZSMSCST.

*-----------------------------------------------------------------------
* ����/ü�� INTERNAL TABLE & VARIABLE DECLARE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS  0,
       MARK           TYPE     C,
       ZFMSNM         LIKE     ZTMSHD-ZFMSNM,       " �𼱸�.
       ZFMSNO         LIKE     ZTMSCST-ZFMSNO,
       ZFAPRTC        LIKE     ZTMSCST-ZFAPRTC,     " ������.
       ZFETA          LIKE     ZTMSCST-ZFETA,       " ������.
       LIFNR          LIKE     ZTMSCST-LIFNR,       " ���޻�(����).
       NAME1          LIKE     LFA1-NAME1,          " ���޻��.
       ZFCARGO        LIKE     ZTMSCST-ZFCARGO,     " �Ͽ���.
       NAME2(18)      TYPE     C,          " �Ͽ����.
       ZFCCGB         LIKE     ZTMSCST-ZFCCGB,      " ��/�� ����.
       ZFCCNM(4)      TYPE     C,                   " ��/�� ��.
       ZFVAT          LIKE     ZTMSCST-ZFVAT,
       ZFSHAMT        LIKE     ZTMSCST-ZFSHAMT,     " ����/ü����.
       ZFUNCO         LIKE     ZTMSCST-ZFUNCO,      " �̼���.
       ZFNOPY         LIKE     ZTMSCST-ZFNOPY,      " ������.
       ZFOCDT         LIKE     ZTMSCST-ZFOCDT,      " �߻���.
       BUKRS          LIKE     ZTMSCST-BUKRS,       " ȸ���ڵ�.
       BELNR          LIKE     ZTMSCST-BELNR,       " ��ǥ��ȣ.
       GJAHR          LIKE     ZTMSCST-GJAHR,       " ȸ��⵵.
       BELNRV         LIKE     ZTMSCST-BELNR,       " vat ��ǥ��ȣ.
       GJAHRV         LIKE     ZTMSCST-GJAHR,       " vat ȸ��⵵.
       ZFWERKS        LIKE     ZTMSCST-ZFWERKS,     " PLANT.
       ZFKOSTL        LIKE     ZTMSCST-ZFKOSTL,     " COST CENTER.
       ZFPSDT         LIKE     ZTMSCST-ZFPSDT.      " Posting Date.
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
*>> MESSAGE ��¿�.
TABLES : BAL_S_DMSG.
*>>> ERROR ó����.
DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON       LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(255) TYPE C.
DATA : END OF IT_ERR_LIST.
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
* SELECT RECORD
*-----------------------------------------------------------------------
DATA: BEGIN OF    IT_SELECTED OCCURS 0,
      ZFMSNO         LIKE     ZTMSCST-ZFMSNO,
      ZFAPRTC        LIKE     ZTMSCST-ZFAPRTC,     " ������.
      ZFWERKS        LIKE     ZTMSCST-ZFWERKS,     " PLANT.
      ZFKOSTL        LIKE     ZTMSCST-ZFKOSTL,     " COST CENTER.
      ZFPSDT         LIKE     ZTMSCST-ZFPSDT,      " �Ա���.
END OF IT_SELECTED.
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
*>> LOCKED OBJECT.
DATA:    BEGIN OF IT_LOCKED OCCURS 0,
         ZFMSNO         LIKE     ZTMSCST-ZFMSNO,
         ZFAPRTC        LIKE     ZTMSCST-ZFAPRTC.     " ������.
DATA     END OF IT_LOCKED.
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
DATA:    BEGIN OF IT_ZTMSCST OCCURS 0.
         INCLUDE STRUCTURE ZTMSCST.
DATA     END OF IT_ZTMSCST.
*-----------------------------------------------------------------------

*
DATA : W_LINE         TYPE     I,
       W_COUNT        TYPE     I,
       TEXTLEN        TYPE     I,
       TEMP_WRBTR(16),
       TEMP_WRBTR1(16),
       W_MOD          TYPE     I,
       W_PROC_CNT     TYPE     I,
       W_LIFNR_NM(24) TYPE     C,
       ANTWORT        TYPE     C,
       OPTION(1)      TYPE     C,
       CANCEL_OPTION  TYPE     C,
       RADIO_NONE     TYPE     C,
       RADIO_ALL      TYPE     C,
       RADIO_ERROR    TYPE     C,
       INCLUDE(8)     TYPE     C,             "
       W_FIELD_NM     LIKE     DD03D-FIELDNAME,   " �ʵ�?
       W_PSDT         LIKE     ZTMSCST-ZFPSDT,
       W_OCDT         LIKE     ZTMSCST-ZFOCDT,
       W_ZFMSNM       LIKE     ZTMSHD-ZFMSNM,
       W_NOAMT        LIKE     ZTMSCST-ZFSHAMT,
       W_SY_SUBRC     LIKE     SY-SUBRC,
       W_ERR_CNT      TYPE     I,
       ZFFIYR         LIKE     ZTRECST-ZFFIYR,
       ZFACDO         LIKE     ZTRECST-ZFACDO,
       OK-CODE        LIKE     SY-UCOMM,
       W_TABIX        LIKE     SY-TABIX.

*>> SORT COMMON INCLUDE.
INCLUDE ZRIMSORTCOM.

*--------------------------------------------------------------------
* �˻����� WINDOW CREATE
*--------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_MSNM    FOR  ZTMSHD-ZFMSNM,   "�𼱸�.
                   S_ETA     FOR  ZTMSCST-ZFETA,   "������.
                   S_LIFNR   FOR  ZTMSCST-LIFNR,   "���޻�(����).
                   S_CARGO   FOR  ZTMSCST-ZFCARGO, "�Ͽ���.
                   S_OCDT    FOR  ZTMSCST-ZFOCDT,  "�߻���.
*>> 2001.03.20 KSB INSERT
                   S_ZFCCGB  FOR  ZTMSCST-ZFCCGB.  ">��ü�� ����.
  SELECTION-SCREEN SKIP 1.                        " 1 LINE SKIP

  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(16) TEXT-002, POSITION 33.
     PARAMETERS : P_YN    AS CHECKBOX.              " ���۾�����..
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK B1.

*-----------------------------------------------------------------------
* ȭ�� INITIALIZATION
*-----------------------------------------------------------------------
INITIALIZATION.
   SET  TITLEBAR 'ZIMMS2'.           " GUI TITLE SETTING..

*-----------------------------------------------------------------------
* REPORT WRITE �� PAGE�� TOP EVENT
*-----------------------------------------------------------------------
TOP-OF-PAGE.
  IF INCLUDE NE 'POPU'.
     PERFORM P2000_TITLE_WRITE.
  ENDIF.

*-----------------------------------------------------------------------
* START-OF-SELECTION ��..
*-----------------------------------------------------------------------
START-OF-SELECTION.

   SET PF-STATUS 'ZIMMS2'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMMS2'.           " GUI TITLE SETTING..
   PERFORM P1000_READ_TEXT.

   IF W_LINE EQ 0. MESSAGE S738. EXIT. ENDIF.

*-----------------------------------------------------------------------
* SELECT ������ EVENT.
*-----------------------------------------------------------------------
END-OF-SELECTION.
   CHECK W_LINE  GT 0.
   PERFORM P3000_DATA_WRITE.

*----------------------------------------------------------------------
* User Command
*----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
         PERFORM P3000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFREQDT'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
      WHEN 'POST'.
         CLEAR : ANTWORT, W_PROC_CNT, W_SUBRC, W_PSDT, W_OCDT.
         PERFORM P3000_POST_LINE_COUNT.
         IF W_PROC_CNT < 1. MESSAGE S766. EXIT. ENDIF.
         PERFORM P3000_EXEC_MAT_INVOICE_VERIFY
                                         USING IT_TAB-ZFWERKS "�÷�Ʈ
                                               IT_TAB-ZFKOSTL "COST CENT
                                               IT_TAB-ZFPSDT. "�Ա���

         IF ANTWORT = 'Y'.
            PERFORM P3000_BDC_SCREEN_CALL.
            DESCRIBE  TABLE IT_ERR_LIST   LINES  W_LINE.
            IF W_LINE GT 0.
               INCLUDE = 'POPU'.
               CALL SCREEN 0200 STARTING AT  05   3
                                ENDING   AT  100 12.
               CLEAR : INCLUDE.
            ENDIF.
            PERFORM P1000_READ_TEXT.
            IF W_LINE EQ 0.
               MESSAGE S826 WITH W_PROC_CNT.
               LEAVE TO SCREEN 0.
            ENDIF.
            PERFORM RESET_LIST.
            MESSAGE S826 WITH W_PROC_CNT.
         ENDIF.
      WHEN 'DETA'.
         PERFORM P2000_GET_SELECT_LINE.
         IF  W_PROC_CNT GT 1. MESSAGE S965. EXIT. ENDIF.
         IF  W_PROC_CNT EQ 0. MESSAGE S766. EXIT. ENDIF.
         MOVE-CORRESPONDING ZTMSCST TO ZSMSCST.
         PERFORM P2000_DOC_CHANGE.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT.
            IF W_LINE EQ 0.    LEAVE TO SCREEN 0.    ENDIF.
            PERFORM RESET_LIST.
            IF W_LINE EQ 0.    LEAVE TO SCREEN 0.    ENDIF.
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
   CLEAR : IT_TAB.

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
*&      Form  P2000_TITLE_WRITE
*&---------------------------------------------------------------------*
*       ȭ��� TITLE WRITE �Ѵ�.
*----------------------------------------------------------------------*
FORM P2000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /55  '[ ����/ü���� Posting ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',        SY-VLINE NO-GAP,
            '�𼱸�    '          NO-GAP,
            '          '          NO-GAP,
            '          '          NO-GAP, SY-VLINE NO-GAP,
            '�߻���    '          NO-GAP, SY-VLINE NO-GAP,
            '����'                NO-GAP, SY-VLINE NO-GAP,
            '����/ü����       '  NO-GAP, SY-VLINE NO-GAP,
            '�̼�/������ �ݾ�   ' NO-GAP, SY-VLINE NO-GAP,
            'ȸ��⵵-��ȣ  '     NO-GAP, SY-VLINE NO-GAP,
            'Posting Date'        NO-GAP, SY-VLINE NO-GAP,
            / SY-VLINE, ' ',      SY-VLINE NO-GAP,
            '������    '          NO-GAP,
            '             '       NO-GAP, SY-VLINE NO-GAP,
            '������'              NO-GAP, SY-VLINE NO-GAP,
            '���޻�    '          NO-GAP,
            '          '          NO-GAP,
            '              '      NO-GAP, SY-VLINE NO-GAP,
            'VAT                ' NO-GAP, SY-VLINE NO-GAP,
            '�Ͽ���    '          NO-GAP,
            '          '          NO-GAP,
            '        '            NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_TEXT.

* ��ȸ���ǿ� �ش��ϴ� �ڷ� SELECT.
  SELECT B~ZFMSNM  A~ZFOCDT A~ZFCCGB  A~ZFSHAMT A~ZFUNCO
         A~ZFNOPY  A~GJAHR  A~BELNR   A~ZFPSDT  A~ZFETA
         A~ZFAPRTC A~LIFNR  A~ZFCARGO A~ZFVAT   A~ZFMSNO
         A~GJAHRV  A~BELNRV A~ZFWERKS A~ZFKOSTL
  INTO   CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM   ZTMSCST AS A INNER JOIN ZTMSHD AS B
  ON     A~ZFMSNO  EQ  B~ZFMSNO
  WHERE  B~ZFMSNM  IN  S_MSNM
  AND    A~ZFETA   IN  S_ETA
  AND    A~ZFOCDT  IN  S_OCDT
  AND    A~LIFNR   IN  S_LIFNR
  AND    A~ZFCARGO IN  S_CARGO
  AND    A~ZFCCGB  IN  S_ZFCCGB
  AND    A~GJAHR   EQ  SPACE
  AND    A~BELNR   EQ  SPACE .

* ȸ�� POSTING �� �ڷ� ���� ���ο� ���� FILTERING!
  IF P_YN  NE  'X'.
*>> ü������ ���.
     DELETE IT_TAB WHERE BELNR  NE SPACE
                   AND   ZFCCGB EQ 'D'.
*>> ������� ���(�ΰ��� �����).
     DELETE IT_TAB WHERE BELNR  NE SPACE   ">FI  DOCUMENT.
                   AND   BELNRV NE SPACE   ">VAT DOCUMENT.
                   AND   ZFVAT  NE 0       ">�ΰ����� �����ϴ� ���.
                   AND   ZFCCGB EQ 'A'.
*>> ������� ���(�ΰ��� ���� ���).
     DELETE IT_TAB WHERE BELNR  NE SPACE   ">FI  DOCUMENT.
                   AND   ZFVAT  EQ 0       ">�ΰ����� �����ϴ� ���.
                   AND   ZFCCGB EQ 'A'.

  ENDIF.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  SORT  IT_TAB BY ZFMSNM ZFETA.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE.
  CLEAR : W_COUNT, IT_TAB, W_ZFMSNM.

  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.
    W_COUNT = W_COUNT + 1.

* ���޻�� SELECT.
    SELECT SINGLE  NAME1  INTO   IT_TAB-NAME1
    FROM   LFA1           WHERE  LIFNR = IT_TAB-LIFNR.

    MOVE IT_TAB-NAME1 TO W_LIFNR_NM.

* �Ͽ���� SELECT.
    SELECT SINGLE NAME1   INTO   IT_TAB-NAME2
    FROM   LFA1           WHERE  LIFNR = IT_TAB-ZFCARGO.

* ���ⱸ�п� ���� TEXT SETTING.
    IF IT_TAB-ZFCCGB EQ 'A'.
       MOVE '����' TO IT_TAB-ZFCCNM.
       MOVE IT_TAB-ZFNOPY TO W_NOAMT.
    ELSE.
       MOVE 'ü��' TO IT_TAB-ZFCCNM.
       MOVE IT_TAB-ZFUNCO TO W_NOAMT.
    ENDIF.

    PERFORM P3000_LINE_WRITE.
  ENDLOOP.
  CLEAR : IT_TAB.
ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

     FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

     WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE NO-GAP,
       IT_TAB-ZFMSNM     NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFOCDT     NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFCCNM     NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFSHAMT    CURRENCY 'KRW'
                         NO-GAP, SY-VLINE NO-GAP.
    IF IT_TAB-ZFCCGB = 'D'.
       WRITE :  ' '        COLOR COL_POSITIVE INTENSIFIED OFF NO-GAP.
       WRITE :  W_NOAMT    CURRENCY 'KRW'
                           COLOR COL_POSITIVE INTENSIFIED OFF
                           NO-GAP, SY-VLINE NO-GAP.
    ELSE.
       WRITE :  ' '        COLOR COL_NEGATIVE INTENSIFIED OFF NO-GAP.
       WRITE :  W_NOAMT    CURRENCY 'KRW'
                           COLOR COL_NEGATIVE INTENSIFIED OFF
                           NO-GAP, SY-VLINE NO-GAP.
    ENDIF.

    WRITE : IT_TAB-GJAHR      NO-GAP,
       '-'               NO-GAP,
       IT_TAB-BELNR      NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFPSDT     NO-GAP,
       '  '              NO-GAP, SY-VLINE NO-GAP.
    HIDE    IT_TAB.

   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
   WRITE: / SY-VLINE, ' '  ,SY-VLINE NO-GAP,
       IT_TAB-ZFETA      NO-GAP,
       '             '   NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFAPRTC    NO-GAP,
       '   '             NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-LIFNR      NO-GAP,
       W_LIFNR_NM        NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFVAT      CURRENCY 'KRW' NO-GAP, SY-VLINE NO-GAP,
       IT_TAB-ZFCARGO    NO-GAP,
       IT_TAB-NAME2      NO-GAP, SY-VLINE NO-GAP.
   HIDE    IT_TAB.
   WRITE / SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_SELECT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
FORM P3000_SELECT_RECORD USING    P_SY_UCOMM.

DATA : WL_MARK.

   IF P_SY_UCOMM EQ 'MKAL'. WL_MARK = 'X'.
   ELSEIF P_SY_UCOMM EQ 'MKLO'. CLEAR : WL_MARK. ENDIF.

   DO.
      CLEAR MARKFIELD.
      READ LINE SY-INDEX FIELD VALUE MARKFIELD.
      IF SY-SUBRC NE 0. EXIT. ENDIF.
      MODIFY CURRENT LINE FIELD VALUE MARKFIELD FROM WL_MARK.
   ENDDO.

ENDFORM.                    " P3000_SELECT_RECORD
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_STATUS_SCR0001 OUTPUT.

   SET TITLEBAR 'POPU' WITH SPOP-TITEL.
   SET PF-STATUS 'POPU'.

   IF OPTION = '1'.
      SET CURSOR FIELD 'SPOP-OPTION1'.
   ELSE.
      SET CURSOR FIELD 'SPOP-OPTION2'.
   ENDIF.


ENDMODULE.                 " SET_STATUS_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_SCREEN_SCR0001 OUTPUT.

  AUTHORITY-CHECK OBJECT 'ZM_BDC_MGT'
                  ID 'ACTVT' FIELD '*'.
  W_SY_SUBRC = SY-SUBRC.

  LOOP AT SCREEN.
    IF SCREEN-NAME = 'SPOP-OPTION_CAN'.
      IF CANCEL_OPTION = SPACE.
        SCREEN-ACTIVE = 0.
      ENDIF.
    ELSEIF SCREEN-NAME = 'SPOP-TEXTLINE1'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-TEXTLINE2'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-TEXTLINE3'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-DIAGNOSE'.                   "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-DIAGNOSE1'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-DIAGNOSE2'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ELSEIF SCREEN-NAME = 'SPOP-DIAGNOSE3'.                  "B20K058946
      SCREEN-LENGTH = TEXTLEN.                              "B20K058946
    ENDIF.

    IF W_SY_SUBRC NE 0 AND SY-DYNNR EQ '3515'.
       IF SCREEN-NAME(10) EQ 'RADIO_NONE'  OR
          SCREEN-NAME(09) EQ 'RADIO_ALL'   OR
          SCREEN-NAME(11) EQ 'RADIO_ERROR' OR
          SCREEN-NAME(06) EQ 'BLOCK2'.
          SCREEN-INVISIBLE = 1.
       ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.                 " MODIFY_SCREEN_SCR0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_SCR0002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_EXIT_SCR0002 INPUT.

  ANTWORT = 'N'.
  SET SCREEN 0.   LEAVE SCREEN.

ENDMODULE.                 " USER_EXIT_SCR0002  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_OK_CODE_SCR0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE GET_OK_CODE_SCR0001 INPUT.

  CASE SY-UCOMM.
    WHEN 'CANC'.   ANTWORT = 'N'.
    WHEN 'ENTR'.   ANTWORT = 'Y'.
    WHEN 'YES'.    ANTWORT = 'Y'.
    WHEN 'NO'.     ANTWORT = 'N'.
    WHEN 'OPT1'.   ANTWORT = '1'.
    WHEN 'OPT2'.   ANTWORT = '2'.
    WHEN OTHERS.
       ANTWORT = 'Y'.
  ENDCASE.

  IF ANTWORT EQ 'Y' OR ANTWORT EQ 'N'.
     SET SCREEN 0.   LEAVE SCREEN.
  ENDIF.

ENDMODULE.                 " GET_OK_CODE_SCR0001  INPUT
*&---------------------------------------------------------------------*
*&      Form  P3000_EXEC_MAT_INVOICE_VERIFY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_EXEC_MAT_INVOICE_VERIFY
                USING  P_WERKS
                       P_ZFKOSTL
                       P_ZFPSDT.

   SPOP-TITEL = '����/ü���� FI Posting'.
   SPOP-TEXTLINE1 = 'FI�� Posting �մϴ�.'.
   SPOP-TEXTLINE2 = 'Posting �Ͻðڽ��ϱ�?'.
   CANCEL_OPTION = 'Y'.
   OPTION = '1'.
   TEXTLEN = 40.
* �������
   SELECT DISTINCT GSBER
     INTO BSEG-GSBER
     FROM T134G
    WHERE WERKS = P_WERKS.
   ENDSELECT.
* ���ͼ���
   SELECT DISTINCT PRCTR
     INTO COBL-PRCTR
     FROM CSKS      "�ڽ�Ʈ���� �����͵���Ÿ
    WHERE KOKRS = 'CJ00'
      AND KOSTL = P_ZFKOSTL.
   ENDSELECT.
   MOVE SY-DATUM  TO ZSMSCST-ZFOCDT.  " ������
   MOVE P_ZFKOSTL TO COBL-KOSTL.      " COST CENTER.
   MOVE P_ZFPSDT  TO ZSMSCST-ZFPSDT.  " ȸ��ó����/�Ա���

   AUTHORITY-CHECK OBJECT 'ZM_BDC_MGT'
                   ID 'ACTVT' FIELD '*'.

   RADIO_NONE = 'X'.
   CLEAR : RADIO_ERROR, RADIO_ALL.

   CALL SCREEN 0100 STARTING AT 12 3
                    ENDING   AT 86 15.

   IF RADIO_NONE = 'X'. DISP_MODE = 'N'. ENDIF.
   IF RADIO_ALL = 'X'.  DISP_MODE = 'A'. ENDIF.
   IF RADIO_ERROR = 'X'.DISP_MODE = 'E'. ENDIF.

ENDFORM.                    " P3000_EXEC_MAT_INVOICE_VERIFY
*&---------------------------------------------------------------------*
*&      Form  P3000_POST_LINE_COUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_POST_LINE_COUNT.

  REFRESH : IT_SELECTED, IT_ERR_LIST.
  DATA    : W_ZFWERKS  LIKE   ZTMSCST-ZFWERKS, " PLANT
            W_ZFKOSTL  LIKE   ZTMSCST-ZFKOSTL, " COST CENTER
            W_ZFPSDT   LIKE   ZTMSCST-ZFPSDT . " �Ա���

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
* �̹� ȸ��ó���� �ڷ�� SKIP.
       IF IT_TAB-ZFCCGB EQ 'A'.         ">����.
          IF IT_TAB-BELNR  NE SPACE AND
             IT_TAB-BELNRV NE SPACE.
             MESSAGE S509 WITH '�����' IT_TAB-ZFMSNO IT_TAB-ZFAPRTC.
             PERFORM  P2000_SINGLE_MESS_MAKE.
             CONTINUE.
          ENDIF.
       ELSEIF IT_TAB-ZFCCGB EQ 'D'.     ">ü��.
          IF IT_TAB-BELNR NE SPACE.
             MESSAGE S509 WITH 'ü����' IT_TAB-ZFMSNO IT_TAB-ZFAPRTC.
             PERFORM  P2000_SINGLE_MESS_MAKE.
             CONTINUE.
          ENDIF.
       ENDIF.
* PLANT�� �ٸ��� SKIP.
       IF IT_TAB-ZFWERKS NE W_ZFWERKS AND
          NOT W_ZFWERKS IS INITIAL.
          MESSAGE S586 WITH '�÷�Ʈ' IT_TAB-ZFMSNO IT_TAB-ZFAPRTC.
          PERFORM  P2000_SINGLE_MESS_MAKE.
          CONTINUE.
       ENDIF.

* COST CENTER�� �ٸ��� SKIP.
       IF IT_TAB-ZFKOSTL NE W_ZFKOSTL AND
          NOT W_ZFKOSTL IS INITIAL.
          MESSAGE S586 WITH 'COST CENTER' IT_TAB-ZFMSNO IT_TAB-ZFAPRTC.
          PERFORM  P2000_SINGLE_MESS_MAKE.
          CONTINUE.
       ENDIF.

* �Ա����� �ٸ��� SKIP.
       IF IT_TAB-ZFPSDT NE W_ZFPSDT AND
          NOT W_ZFPSDT IS INITIAL.
          MESSAGE S586 WITH '�Ա���' IT_TAB-ZFMSNO IT_TAB-ZFAPRTC.
          PERFORM  P2000_SINGLE_MESS_MAKE.
          CONTINUE.
       ENDIF.

       MOVE : IT_TAB-ZFMSNO    TO IT_SELECTED-ZFMSNO,       " ��ǥ
              IT_TAB-ZFAPRTC   TO IT_SELECTED-ZFAPRTC.
       APPEND  IT_SELECTED.

       MOVE : IT_TAB-ZFWERKS TO W_ZFWERKS.
       MOVE : IT_TAB-ZFKOSTL TO W_ZFKOSTL.
       MOVE : IT_TAB-ZFPSDT  TO W_ZFPSDT.

       W_PROC_CNT  =  W_PROC_CNT  +  1.
    ENDIF.
  ENDDO.

ENDFORM.                    " P3000_POST_LINE_COUNT
*&---------------------------------------------------------------------*
*&      Form  P3000_BDC_SCREEN_CALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_BDC_SCREEN_CALL.
  REFRESH : IT_LOCKED, IT_ZTMSCST.
  CLEAR : W_PROC_CNT.

  SELECT SINGLE * FROM ZTIMIMG11.

  LOOP AT IT_SELECTED.
     SELECT SINGLE * FROM  ZTMSCST
                     WHERE ZFMSNO   EQ   IT_SELECTED-ZFMSNO
                     AND   ZFAPRTC  EQ   IT_SELECTED-ZFAPRTC.
*>> ���� ����....
     IF ZTMSCST-BUKRS IS INITIAL.
        MESSAGE S167 WITH 'ȸ���ڵ�'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF ZTMSCST-ZTERM IS INITIAL.
        MESSAGE S167 WITH '���� ����'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF ZTMSCST-LIFNR IS INITIAL.
        MESSAGE S167 WITH '���޻� �ڵ�'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF ZTMSCST-ZFCARGO IS INITIAL.
        MESSAGE S167 WITH '�Ͽ��� �ڵ�'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF ZTMSCST-ZFWERKS IS INITIAL.
        MESSAGE S167 WITH '�÷�Ʈ'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
*>> LOCK
     PERFORM  P2000_SET_LOCK_MODE   USING ZTMSCST-ZFMSNO
                                          'L'   W_SUBRC.
     IF W_SUBRC EQ 0.
        MOVE: ZTMSCST-ZFMSNO  TO IT_LOCKED-ZFMSNO,
              ZTMSCST-ZFAPRTC TO IT_LOCKED-ZFAPRTC.
        APPEND IT_LOCKED.
*>> INTERNAL TABLE APPENDING.
        MOVE-CORRESPONDING  ZTMSCST   TO   IT_ZTMSCST.
        APPEND IT_ZTMSCST.
     ELSE.
        PERFORM  P2000_SINGLE_MESS_MAKE.
     ENDIF.

     REFRESH : BDCDATA.
     CLEAR : W_SUBRC, BDCDATA.

     IF ZTMSCST-BELNR IS INITIAL.
        IF ZTMSCST-ZFCCGB EQ 'A'.          ">�����.
**>> BDC DATA MAKE(����).
           IF ZTMSCST-ZFVAT EQ 0.   ">> �ΰ����� �������� �������.
                 PERFORM P2000_BDC_DATA_MAKE_1.
           ELSE.                    ">> �ΰ����� ������ ���.
                 PERFORM P2000_BDC_DATA_MAKE_2.
           ENDIF.
        ELSEIF ZTMSCST-ZFCCGB EQ 'D'.      ">ü����.
**>> BDC DATA MAKE(ü��).
           PERFORM P2000_BDC_DATA_MAKE.
        ENDIF.
*>>PARAMETER CLEAR.
        SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
        SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
* �ѰǾ� BDC SCREEN CALL.
        PERFORM P2000_CALL_TRANSACTION  USING 'FB01'
                                        CHANGING W_SUBRC.
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
           READ TABLE IT_ZTMSCST WITH KEY ZFMSNO  = ZTMSCST-ZFMSNO
                                          ZFAPRTC = ZTMSCST-ZFAPRTC.
           IF SY-SUBRC EQ 0.
              MOVE : ZFACDO         TO     IT_ZTMSCST-BELNR,
                     ZFFIYR         TO     IT_ZTMSCST-GJAHR,
                     ZSMSCST-ZFPSDT TO     IT_ZTMSCST-ZFPSDT,
                     ZSMSCST-ZFOCDT TO     IT_ZTMSCST-ZFOCDT,
                     SY-UNAME       TO     IT_ZTMSCST-UNAM,
                     SY-DATUM       TO     IT_ZTMSCST-UDAT.
              MODIFY IT_ZTMSCST  INDEX   SY-TABIX.
           ENDIF.
           PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
        ENDIF.
     ENDIF.
*-----------------------------------------------------------------------
* ������̸鼭, �ΰ����� ������ ���.
*-----------------------------------------------------------------------
     IF ZTMSCST-BELNRV IS INITIAL AND ">��ǥ��ȣ.
        ZTMSCST-ZFCCGB EQ 'A'     AND ">�����.
        ZTMSCST-ZFVAT  NE  0.         ">> �ΰ����� �������� �������.
        PERFORM P2000_BDC_DATA_MAKE_3.
*>>PARAMETER CLEAR.
        SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
        SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
* �ѰǾ� BDC SCREEN CALL.
        PERFORM P2000_CALL_TRANSACTION  USING 'FB01'
                                        CHANGING W_SUBRC.
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
           READ TABLE IT_ZTMSCST WITH KEY ZFMSNO  = ZTMSCST-ZFMSNO
                                          ZFAPRTC = ZTMSCST-ZFAPRTC.
           IF SY-SUBRC EQ 0.
              MOVE : ZFACDO         TO     IT_ZTMSCST-BELNRV,
                     ZFFIYR         TO     IT_ZTMSCST-GJAHRV,
                     ZSMSCST-ZFPSDT TO     IT_ZTMSCST-ZFVPSDT,
                     SY-UNAME       TO     IT_ZTMSCST-UNAM,
                     SY-DATUM       TO     IT_ZTMSCST-UDAT.
              MODIFY IT_ZTMSCST  INDEX   SY-TABIX.
           ENDIF.
           PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
        ENDIF.
     ENDIF.
     ADD    1    TO    W_PROC_CNT.
  ENDLOOP.

  MODIFY ZTMSCST FROM TABLE IT_ZTMSCST.

*>> UNLOCKED.
  LOOP AT IT_LOCKED.
     PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFMSNO
                                          'U'    W_SUBRC.
  ENDLOOP.


ENDFORM.                    " P3000_BDC_SCREEN_CALL
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_COUNT = 0.
  PERFORM   P2000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT_FIELD_SCR0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_INPUT_FIELD_SCR0100 INPUT.

  IF NOT ( OK-CODE EQ 'YES' OR OK-CODE EQ 'ENTR' ).
     EXIT.
  ENDIF.

   IF ZSMSCST-ZFOCDT IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'ZSMSCST' 'ZFOCDT'.
   ENDIF.
   IF ZSMSCST-ZFPSDT IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'ZSMSCST' 'ZFPSDT'.
   ENDIF.
   IF BSEG-GSBER IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'BSEG' 'GSBER'.
   ENDIF.

   IF COBL-KOSTL IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'COBL' 'KOSTL'.
   ENDIF.

   IF COBL-PRCTR IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'COBL' 'PRCTR'.
   ENDIF.

ENDMODULE.                 " CHECK_INPUT_FIELD_SCR0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_BDC_DATA_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_BDC_DATA_MAKE.
*>> �� ���.
  SELECT SINGLE * FROM ZTMSHD
                  WHERE ZFMSNO EQ ZTMSCST-ZFMSNO.
*>> ������ȣ.
  CONCATENATE ZTMSCST-ZFMSNO '-' ZTMSCST-ZFAPRTC INTO BKPF-XBLNR.
*>> �𼱸�Ī.
  MOVE : ZTMSHD-ZFMSNM TO BKPF-BKTXT.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View�� �ƴϱ� ������ Select�� ������ �߻��ϴ� �� ����????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.
* MKIM ���� FROM
*  SELECT SINGLE * FROM ZVT001W
*                  WHERE WERKS EQ ZTMSCST-ZFWERKS.
* MKIM ���� TO
  MOVE ZTMSCST-BUPLA TO ZVT001W-J_1BBRANCH.

  SELECT SINGLE * FROM LFA1
                  WHERE LIFNR EQ ZTMSCST-ZFCARGO.

  REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   ZSMSCST-ZFOCDT,     " Document Date
      ' ' 'BKPF-BLART'  'SA',                " Type
      ' ' 'BKPF-BUKRS'   ZTMSCST-BUKRS,      " Company Code
      ' ' 'BKPF-BUDAT'   ZSMSCST-ZFPSDT,     " Posting Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " ȯ��.
      ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
      ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
      ' ' 'BKPF-XBLNR'  BKPF-XBLNR,          " ����������ȣ.
      ' ' 'BKPF-BVORG'  SPACE,               " ȸ���ڵ尣 �ŷ���ȣ.
      ' ' 'BKPF-BKTXT'  BKPF-BKTXT,          " ��ǥ����ؽ�Ʈ.
      ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
      ' ' 'RF05A-NEWBS' '01',                " Posting Key
      ' ' 'RF05A-NEWKO'  LFA1-KUNNR,         " Account(�Ͽ���).
      ' ' 'RF05A-NEWUM'  SPACE,              "���� �����׸�Ư�� G/L����.
      ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

*>> �̼���.
  WRITE ZTMSCST-ZFUNCO    CURRENCY 'KRW' TO TEMP_WRBTR.

* NEXT SCREEN.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0301',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '�̼���',              " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '31',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTMSCST-LIFNR,         " ACCOUNT(ü����)
      ' ' 'BDC_OKCODE'  '/00'.                 " ENTER

*>> ü����(������).
  WRITE ZTMSCST-ZFNOPY    CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0302',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,          " Amount
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'COBL-KOSTL'  COBL-KOSTL,            " Cost center.
*      ' ' 'COBL-PRCTR'  COBL-PRCTR,            " ���ͼ���.
      ' ' 'BSEG-SGTXT'  'ü����(�����ޱ�)',    " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '40',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFMSCST4,    " ACCOUNT(������ ���)
      ' ' 'BDC_OKCODE'  '/00         '.        " ENTER.

*>> ������ ���.
  WRITE ZTMSCST-ZFCST    CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0300',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
*      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
*      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
*      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '������ ���',         " �ؽ�Ʈ.
      ' ' 'BDC_OKCODE'  '=BU'.                 " ENTER

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " P2000_BDC_DATA_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ZTMSCST_ZFMSNO  text
*----------------------------------------------------------------------*
FORM P2000_SET_LOCK_MODE USING    P_ZFMSNO
                                  PA_MODE
                                  W_SUBRC.
  IF PA_MODE EQ 'L'.
     CALL FUNCTION 'ENQUEUE_EZ_ZTMSHD'
         EXPORTING
              ZFMSNO = P_ZFMSNO
         EXCEPTIONS
              OTHERS  = 1.

    W_SUBRC = SY-SUBRC.

    IF W_SUBRC <> 0.
       MESSAGE S510 WITH SY-MSGV1 '��'
                         P_ZFMSNO ''
                    RAISING DOCUMENT_LOCKED.
    ENDIF.
  ELSEIF PA_MODE EQ 'U'.

     CALL FUNCTION 'DEQUEUE_EZ_ZTMSHD'
         EXPORTING
              ZFMSNO = P_ZFMSNO.

     W_SUBRC = SY-SUBRC.
  ENDIF.

ENDFORM.                    " P2000_SET_LOCK_MODE
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
*   LOOP AT IT_LOCKED.
*      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFMSNO
*                                           'U'    W_SUBRC.
*   ENDLOOP.


ENDFORM.                    " P2000_SINGLE_MESS_MAKE

*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
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
*   LOOP AT IT_LOCKED.
*      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFMSNO
*                                           'U'    W_SUBRC.
*   ENDLOOP.


ENDFORM.                    " P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*&      Module  D0200_STATUS_SCR0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0200_STATUS_SCR0200 OUTPUT.
  SET PF-STATUS 'STDLISW'.

  CASE INCLUDE.
     WHEN 'POPU'.
        SET TITLEBAR 'POPU' WITH 'Message LIST'.
     WHEN OTHERS.
  ENDCASE.

  SUPPRESS DIALOG.


ENDMODULE.                 " D0200_STATUS_SCR0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  D0200_LIST_CHECK_SCR0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0200_LIST_CHECK_SCR0200 INPUT.
   LEAVE TO LIST-PROCESSING.

   CASE INCLUDE.
      WHEN 'POPU'.
         FORMAT COLOR COL_HEADING INTENSIFIED OFF.
         WRITE : / SY-ULINE(96),    /   SY-VLINE NO-GAP,
                   '����'   NO-GAP,     SY-VLINE NO-GAP,
                   '�޼��� �ؽ�Ʈ',  94 SY-VLINE NO-GAP,
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

ENDMODULE.                 " D0200_LIST_CHECK_SCR0200  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_BDC_DATA_MAKE_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_BDC_DATA_MAKE_1.
*>> �� ���.
  SELECT SINGLE * FROM ZTMSHD
                  WHERE ZFMSNO EQ ZTMSCST-ZFMSNO.
*>> ������ȣ.
  CONCATENATE ZTMSCST-ZFMSNO '-' ZTMSCST-ZFAPRTC INTO BKPF-XBLNR.
*>> �𼱸�Ī.
  MOVE : ZTMSHD-ZFMSNM TO BKPF-BKTXT.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View�� �ƴϱ� ������ Select�� ������ �߻��ϴ� �� ����????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.

* MKIM ����
*  SELECT SINGLE * FROM ZVT001W
*                  WHERE WERKS EQ ZTMSCST-ZFWERKS.
  MOVE ZTMSCST-BUPLA TO ZVT001W-J_1BBRANCH.

  SELECT SINGLE * FROM LFA1
                  WHERE LIFNR EQ ZTMSCST-LIFNR.

  REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   ZSMSCST-ZFOCDT,     " Document Date
      ' ' 'BKPF-BLART'  'SA',                " Type
      ' ' 'BKPF-BUKRS'   ZTMSCST-BUKRS,      " Company Code
      ' ' 'BKPF-BUDAT'   ZSMSCST-ZFPSDT,     " Posting Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " ȯ��.
      ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
      ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
      ' ' 'BKPF-XBLNR'  BKPF-XBLNR,          " ����������ȣ.
      ' ' 'BKPF-BVORG'  SPACE,               " ȸ���ڵ尣 �ŷ���ȣ.
      ' ' 'BKPF-BKTXT'  BKPF-BKTXT,          " ��ǥ����ؽ�Ʈ.
      ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
      ' ' 'RF05A-NEWBS' '01',                " Posting Key
      ' ' 'RF05A-NEWKO'  LFA1-KUNNR,         " Account(���޻�).
      ' ' 'RF05A-NEWUM'  SPACE,              "���� �����׸�Ư�� G/L����.
      ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

*>> �̼���.
  WRITE ZTMSCST-ZFUNCO    CURRENCY 'KRW' TO TEMP_WRBTR.
* NEXT SCREEN.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0301',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '�̼���(�����)',      " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '31',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTMSCST-ZFCARGO,       " ACCOUNT(�Ͽ���)
      ' ' 'BDC_OKCODE'  '/00'.                 " ENTER

*>> (������-�Ͽ���).
  WRITE ZTMSCST-ZFNOPY    CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0302',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,          " Amount
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'COBL-KOSTL'  COBL-KOSTL,            " Cost center.
*      ' ' 'COBL-PRCTR'  COBL-PRCTR,            " ���ͼ���.
      ' ' 'BSEG-SGTXT'  '�Ͽ���(�����ޱ�)',    " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '50',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFMSCST3,    " ACCOUNT(������ ����)
      ' ' 'BDC_OKCODE'  '/00         '.        " ENTER.

*>> ������ ����.
  WRITE ZTMSCST-ZFPROF    CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0300',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
*      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
*      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
*      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '������ ����',         " �ؽ�Ʈ.
      ' ' 'BDC_OKCODE'  '=BU'.                 " ENTER

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " P2000_BDC_DATA_MAKE_1
*&---------------------------------------------------------------------*
*&      Form  P2000_BDC_DATA_MAKE_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_BDC_DATA_MAKE_2.
*>> �� ���.
  SELECT SINGLE * FROM ZTMSHD
                  WHERE ZFMSNO EQ ZTMSCST-ZFMSNO.
*>> ������ȣ.
  CONCATENATE ZTMSCST-ZFMSNO '-' ZTMSCST-ZFAPRTC INTO BKPF-XBLNR.
*>> �𼱸�Ī.
  MOVE : ZTMSHD-ZFMSNM TO BKPF-BKTXT.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View�� �ƴϱ� ������ Select�� ������ �߻��ϴ� �� ����????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.
* MKIM ����
*  SELECT SINGLE * FROM ZVT001W
*                  WHERE WERKS EQ ZTMSCST-ZFWERKS.
  MOVE ZTMSCST-BUPLA TO ZVT001W-J_1BBRANCH.
  SELECT SINGLE * FROM LFA1
                  WHERE LIFNR EQ ZTMSCST-LIFNR.

*-----------------------------------------------------------------------
*>> �ΰ����� ������ ���, ������ �߻��ϹǷ�..
*   2001.03.30  KSB INSERT
  ZTMSCST-MWSKZ = 'V0'.
*-----------------------------------------------------------------------

  REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   ZSMSCST-ZFOCDT,     " Document Date
      ' ' 'BKPF-BLART'  'SA',                " Type
      ' ' 'BKPF-BUKRS'   ZTMSCST-BUKRS,      " Company Code
      ' ' 'BKPF-BUDAT'   ZSMSCST-ZFPSDT,     " Posting Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " ȯ��.
      ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
      ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
      ' ' 'BKPF-XBLNR'  BKPF-XBLNR,          " ����������ȣ.
      ' ' 'BKPF-BVORG'  SPACE,               " ȸ���ڵ尣 �ŷ���ȣ.
      ' ' 'BKPF-BKTXT'  BKPF-BKTXT,          " ��ǥ����ؽ�Ʈ.
      ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
      ' ' 'RF05A-NEWBS' '01',                " Posting Key
      ' ' 'RF05A-NEWKO'  LFA1-KUNNR,         " Account(���޻�).
      ' ' 'RF05A-NEWUM'  SPACE,              "���� �����׸�Ư�� G/L����.
      ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

*>> �̼���.
  WRITE ZTMSCST-ZFUNCO    CURRENCY 'KRW' TO TEMP_WRBTR.
* NEXT SCREEN.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0301',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
*      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '�̼���(�����)',      " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '50',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFMSCST3,    " ACCOUNT(������ ����)
      ' ' 'BDC_OKCODE'  '/00'.                 " ENTER

*>> ������ ����.
  WRITE ZTMSCST-ZFPROF    CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0300',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  SPACE,                 " Tax
*      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
*      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
*      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '������ ����',         " �ؽ�Ʈ.
      ' ' 'BDC_OKCODE'  '=BU'.                 " ENTER

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " P2000_BDC_DATA_MAKE_2
*&---------------------------------------------------------------------*
*&      Form  P2000_BDC_DATA_MAKE_3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_BDC_DATA_MAKE_3.
*>> �� ���.
  SELECT SINGLE * FROM ZTMSHD
                  WHERE ZFMSNO EQ ZTMSCST-ZFMSNO.
*>>>
  SELECT SINGLE * FROM  ZTMSCST
                  WHERE ZFMSNO   EQ   IT_SELECTED-ZFMSNO
                  AND   ZFAPRTC  EQ   IT_SELECTED-ZFAPRTC.

*>> ������ȣ.
  CONCATENATE ZTMSCST-ZFMSNO '-' ZTMSCST-ZFAPRTC INTO BKPF-XBLNR.
*>> �𼱸�Ī.
  MOVE : ZTMSHD-ZFMSNM TO BKPF-BKTXT.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View�� �ƴϱ� ������ Select�� ������ �߻��ϴ� �� ����????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.
* MKIM ����
*  SELECT SINGLE * FROM ZVT001W
*                  WHERE WERKS EQ ZTMSCST-ZFWERKS.
  MOVE ZTMSCST-BUPLA TO ZVT001W-J_1BBRANCH.

*  SELECT SINGLE * FROM LFA1
*                  WHERE LIFNR EQ ZTMSCST-ZFCARGO.

  REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   ZSMSCST-ZFOCDT,     " Document Date
      ' ' 'BKPF-BLART'  'SA',                " Type
      ' ' 'BKPF-BUKRS'   ZTMSCST-BUKRS,      " Company Code
      ' ' 'BKPF-BUDAT'   ZSMSCST-ZFPSDT,     " Posting Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " ȯ��.
      ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
      ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
      ' ' 'BKPF-XBLNR'  BKPF-XBLNR,          " ����������ȣ.
      ' ' 'BKPF-BVORG'  SPACE,               " ȸ���ڵ尣 �ŷ���ȣ.
      ' ' 'BKPF-BKTXT'  BKPF-BKTXT,          " ��ǥ����ؽ�Ʈ.
      ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
*      ' ' 'RF05A-NEWBS' '40',                " Posting Key
*      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFMSCST4,  " ACCOUNT(������ ���)
      ' ' 'RF05A-NEWBS' '31',                " Posting Key
      ' ' 'RF05A-NEWKO'  ZTMSCST-ZFCARGO,    " ACCOUNT(�����ޱ�).
      ' ' 'RF05A-NEWUM'  SPACE,              "���� �����׸�Ư�� G/L����.
      ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

*>> �����(������).
  WRITE ZTMSCST-ZFNOPY    CURRENCY 'KRW' TO TEMP_WRBTR.
*  WRITE ZTMSCST-ZFVAT    CURRENCY 'KRW' TO TEMP_WRBTR1.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0302',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  TEMP_WRBTR1,           " Tax
      ' ' 'BKPF-XMWST'  'X',                   " ������ �ڵ����� ���.
      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'COBL-KOSTL'  COBL-KOSTL,            " Cost center.
*      ' ' 'COBL-PRCTR'  COBL-PRCTR,            " ���ͼ���.
      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '�����(�����ޱ�)',    " �ؽ�Ʈ.
      ' ' 'RF05A-NEWBS' '40',                  " Posting Key
      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFMSCST4,    " ACCOUNT(������ ���)
      ' ' 'BDC_OKCODE'  '/00'.                 " enter

*>> ������ ���.
  WRITE ZTMSCST-ZFNOPY   CURRENCY 'KRW' TO TEMP_WRBTR.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0300',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  'X',                  " Tax
*      ' ' 'BKPF-XMWST'  'X',                   " ������ �ڵ����� ���.
      ' ' 'BSEG-MWSKZ'  ZTMSCST-MWSKZ,         " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'BSEG-ZTERM'  ZTMSCST-ZTERM,         " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
*      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
      ' ' 'BSEG-SGTXT'  '������ ���',         " �ؽ�Ʈ.
*      ' ' 'RF05A-NEWBS' '31',                  " Posting Key
*      ' ' 'RF05A-NEWKO'  ZTMSCST-ZFCARGO,      " ACCOUNT(�����ޱ�).
      ' ' 'BDC_OKCODE'  '=BU'.                 " SAVE

  PERFORM P2000_DYNPRO USING :
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " P2000_BDC_DATA_MAKE_3
*&---------------------------------------------------------------------*
*&      Form  P2000_GET_SELECT_LINE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_GET_SELECT_LINE.
DATA : L_ZFMSNO  LIKE   ZTMSCST-ZFMSNO,
       L_ZFAPRTC LIKE   ZTMSCST-ZFAPRTC.
  CLEAR W_PROC_CNT.

  MOVE : IT_TAB-ZFMSNO   TO   L_ZFMSNO,
         IT_TAB-ZFAPRTC  TO   L_ZFAPRTC.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
       SELECT SINGLE * FROM ZTMSCST
              WHERE    ZFMSNO  EQ   IT_TAB-ZFMSNO
              AND      ZFAPRTC EQ   IT_TAB-ZFAPRTC.
       W_PROC_CNT  =  W_PROC_CNT  +  1.
    ENDIF.
  ENDDO.

  IF W_PROC_CNT EQ 0.
     IF NOT L_ZFMSNO IS INITIAL.
        SELECT SINGLE * FROM ZTMSCST
               WHERE    ZFMSNO  EQ   L_ZFMSNO
               AND      ZFAPRTC EQ   L_ZFAPRTC.
        W_PROC_CNT  =  W_PROC_CNT  +  1.
     ENDIF.
  ENDIF.

ENDFORM.                    " P2000_GET_SELECT_LINE
*&---------------------------------------------------------------------*
*&      Form  P2000_DOC_CHANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_DOC_CHANGE.
  SPOP-TITEL = '����/ü���� ���º��� �� ��ȸ'.
  OPTION = 1.

  SELECT SINGLE * FROM ZTMSHD
         WHERE  ZFMSNO   EQ   ZTMSCST-ZFMSNO.

  CALL SCREEN 0300 STARTING AT 5  3
                   ENDING   AT 85 18.

ENDFORM.                    " P2000_DOC_CHANGE
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_SCR0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_EXIT_SCR0300 INPUT.
  ANTWORT = 'N'.
  SET SCREEN 0.   LEAVE SCREEN.
ENDMODULE.                 " USER_EXIT_SCR0300  INPUT
