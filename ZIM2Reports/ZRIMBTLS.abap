*&---------------------------------------------------------------------*
*& Report  ZRIMBTLS                                                    *
*&---------------------------------------------------------------------*
*&ABAP Name : ZRIMBTLS                                                 *
*&Created by: ����ȣ INFOLINK.Ltd                                      *
*&Created on: 07/22/2000                                               *
*&Version   : 1.0                                                      *
*&---------------------------------------------------------------------*
* ���� ��� LIST
*&---------------------------------------------------------------------*

REPORT  ZRIMBTLS       NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 145
                       LINE-COUNT 65.

TABLES : ZTBL,                         " Bill of Lading Head
         ZTBLINOU,                     " B/L �������(���Կ�������)
         ZTBLINR,                      " /L ���ԽŰ�.
         WMTO_S.

DATA : BEGIN OF IT_TAB1 OCCURS 0,
               ZFTRCK      LIKE ZTBL-ZFTRCK,
               ZFWERKS     LIKE ZTBL-ZFWERKS,
               ZFBNARCD    LIKE ZTBL-ZFBNARCD,
               ZFBLNO      LIKE ZTBL-ZFBLNO,
               ZFETA       LIKE ZTBL-ZFETA,
               ZFBNDT      LIKE ZTBL-ZFBNDT,
               ZFPKCN      LIKE ZTBL-ZFPKCN,
               ZFPKCNM     LIKE ZTBL-ZFPKCNM,
               ZFTOVL      LIKE ZTBL-ZFTOVL,
               ZFTOVLM     LIKE ZTBL-ZFTOVLM,
               W_ZFPKCN    TYPE I,
               ZFTOWT      LIKE ZTBL-ZFTOWT,
               ZFTOWTM     LIKE ZTBL-ZFTOWTM,
               ZFBLAMT     LIKE ZTBL-ZFBLAMT,
               ZFBLAMC     LIKE ZTBL-ZFBLAMC,
               ZFCARNO     LIKE ZTBL-ZFCARNO,
               ZFBLSDT     LIKE ZTBL-ZFBLSDT,
               ZFVIA       LIKE ZTBL-ZFVIA,
               ZFCARNM     LIKE ZTBL-ZFCARNM,
               ZFBTRNO     LIKE ZTBLINOU-ZFBTRNO,
               ZFTDDT      LIKE ZTBLINOU-ZFTDDT,
               ZFINDT      LIKE ZTBLINR-ZFINDT,
               ZFGIRNM     LIKE ZTBLINR-ZFGIRNM,
               ZFFORD      LIKE ZTBL-ZFFORD,
               ZFSPRT      LIKE ZTBL-ZFSPRT,
               ZFRGDSR     LIKE ZTBL-ZFRGDSR,
               ZFRMK1      LIKE ZTBL-ZFRMK1,
               ZFRMK2      LIKE ZTBL-ZFRMK2,
               ZFRMK3      LIKE ZTBL-ZFRMK3,
               ZFRMK4      LIKE ZTBL-ZFRMK4.
DATA : END   OF IT_TAB1.

DATA : BEGIN OF IT_TAB2 OCCURS 0,
               ZFBLNO      LIKE ZTBLINOU-ZFBLNO,
               ZFBTRNO     LIKE ZTBLINOU-ZFBTRNO,
               ZFTDDT      LIKE ZTBLINOU-ZFTDDT.
DATA : END   OF IT_TAB2.

DATA : BEGIN OF IT_TAB3 OCCURS 0,
               ZFBLNO      LIKE ZTBLINR-ZFBLNO,
               ZFINDT      LIKE ZTBLINR-ZFINDT,
               ZFGIRNM     LIKE ZTBLINR-ZFGIRNM.
DATA : END   OF IT_TAB3.

DATA : BEGIN OF IT_CODE  OCCURS 0,
               ZFBNARCD    LIKE  ZTIMIMG03-ZFBNARCD,
               ZFBNARM     LIKE  ZTIMIMG03-ZFBNARM.
DATA : END   OF IT_CODE.

DATA : BEGIN OF IT_LIFNR OCCURS 0,
               LIFNR       LIKE  LFA1-LIFNR,
               NAME1       LIKE  LFA1-NAME1.
DATA : END   OF IT_LIFNR.

DATA : W_SUBRC  LIKE  SY-SUBRC,
       W_NAME(20)  TYPE C,
       W_TEXT(60)  TYPE C,
       W_TABIX(5),
       W_CNT(1).

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
   SELECT-OPTIONS: S_TRCK     FOR ZTBL-ZFTRCK,       "Trucker
                   S_FORD     FOR ZTBL-ZFFORD,       "Forwarder
                   S_WERKS    FOR ZTBL-ZFWERKS,      "Plant
                   S_BNDT     FOR ZTBL-ZFBNDT,       "����?
                   S_VIA      FOR ZTBL-ZFVIA.        "VIA
   SELECTION-SCREEN SKIP.
   PARAMETER : C_BOX1   AS CHECKBOX,         "������������� ���� B/L
               C_BOX2   AS CHECKBOX,         "���������� ���� B/L
               C_BOX3   AS CHECKBOX.         "B/L �ۺ����� ���� B/L
SELECTION-SCREEN END   OF BLOCK B1.


START-OF-SELECTION.
   PERFORM P1000_READ_DATA.
   IF W_SUBRC = 4.
      MESSAGE S738.  EXIT.
   ENDIF.

   PERFORM P1000_CHECK_DATA.
   IF W_SUBRC = 4.
      MESSAGE S738.  EXIT.
   ENDIF.

   SET PF-STATUS  'PF1000'.
   SET TITLEBAR   'TI1000'.
   PERFORM P1000_WRITE_DATA.

TOP-OF-PAGE.
  PERFORM P1000_TOP_PAGE.

AT USER-COMMAND.
   CHECK  SY-UCOMM = 'DOWN'.
   PERFORM P1000_DOWNLOAD.

INITIALIZATION.
   SET TITLEBAR 'TI1000'.
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA.
**  B/L
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB1 FROM ZTBL
    WHERE ZFTRCK IN S_TRCK  AND ZFWERKS IN S_WERKS AND
          ZFBNDT IN S_BNDT  AND ZFVIA IN S_VIA AND ZFFORD IN S_FORD.

  CLEAR : W_SUBRC.
  IF SY-SUBRC <> 0.  W_SUBRC = 4.   EXIT.    ENDIF.
** B/L ������?
  SELECT ZFBLNO ZFBTRNO ZFTDDT
    INTO CORRESPONDING FIELDS OF TABLE IT_TAB2
    FROM ZTBLINOU FOR ALL ENTRIES IN IT_TAB1
   WHERE ZFBLNO = IT_TAB1-ZFBLNO AND ZFBTSEQ = '00001'.
** B/L ��?
  SELECT ZFBLNO ZFINDT ZFGIRNM
    INTO CORRESPONDING FIELDS OF TABLE IT_TAB3
    FROM ZTBLINR FOR ALL ENTRIES IN IT_TAB1
   WHERE ZFBLNO = IT_TAB1-ZFBLNO AND ZFBTSEQ = '00001'.

** ������ Name
  SELECT ZFBNARCD ZFBNARM INTO CORRESPONDING FIELDS OF TABLE IT_CODE
    FROM ZTIMIMG03 FOR ALL ENTRIES IN IT_TAB1
   WHERE ZFBNARCD = IT_TAB1-ZFBNARCD.

** Trucker Name
  SELECT LIFNR NAME1 INTO CORRESPONDING FIELDS OF TABLE IT_LIFNR
    FROM LFA1 FOR ALL ENTRIES IN IT_TAB1
   WHERE LIFNR = IT_TAB1-ZFTRCK.

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
    CLEAR : IT_TAB2, IT_TAB3.

    READ TABLE IT_TAB2 WITH KEY ZFBLNO = IT_TAB1-ZFBLNO.
    MOVE : IT_TAB2-ZFBTRNO     TO  IT_TAB1-ZFBTRNO,
           IT_TAB2-ZFTDDT      TO  IT_TAB1-ZFTDDT.

    READ TABLE IT_TAB3 WITH KEY ZFBLNO = IT_TAB1-ZFBLNO.
    MOVE : IT_TAB3-ZFINDT      TO  IT_TAB1-ZFINDT,
           IT_TAB1-ZFPKCN      TO  IT_TAB1-W_ZFPKCN,
           IT_TAB3-ZFGIRNM     TO  IT_TAB1-ZFGIRNM.


    MODIFY IT_TAB1.
  ENDLOOP.

  IF C_BOX1 = 'X'.
     DELETE IT_TAB1 WHERE NOT ZFBTRNO IS INITIAL.
  ENDIF.

  IF C_BOX2 = 'X'.
     DELETE IT_TAB1 WHERE NOT ZFINDT IS INITIAL.
  ENDIF.

  IF C_BOX3 = 'X'.
     DELETE IT_TAB1 WHERE NOT ZFBNDT IS INITIAL.
  ENDIF.

  CLEAR : W_SUBRC.
  IF IT_TAB1[] IS INITIAL.  W_SUBRC = 4.   ENDIF.

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
  SORT IT_TAB1.
  LOOP AT IT_TAB1.
    W_TABIX = W_TABIX + 1.
    AT NEW ZFTRCK.
       NEW-PAGE.
    ENDAT.
    AT NEW ZFBNARCD.
       CLEAR : IT_CODE, W_NAME.
       READ TABLE IT_CODE WITH KEY ZFBNARCD = IT_TAB1-ZFBNARCD.
       W_NAME = IT_CODE-ZFBNARM.
    ENDAT.

    IF W_CNT = 1.
       W_CNT = 2.   FORMAT COLOR 2 INTENSIFIED OFF.
    ELSE.
       W_CNT = 1.   FORMAT COLOR 2 INTENSIFIED ON.
    ENDIF.
    CLEAR : W_TEXT.
    IF NOT IT_TAB1-ZFRMK1 IS INITIAL.
       MOVE   IT_TAB1-ZFRMK1   TO  W_TEXT.
    ENDIF.
    IF NOT IT_TAB1-ZFRMK2 IS INITIAL.
       CONCATENATE W_TEXT '/' IT_TAB1-ZFRMK2  INTO W_TEXT.
    ENDIF.
    IF NOT IT_TAB1-ZFRMK3 IS INITIAL.
       CONCATENATE W_TEXT '/' IT_TAB1-ZFRMK3  INTO W_TEXT.
    ENDIF.
    IF NOT IT_TAB1-ZFRMK4 IS INITIAL.
       CONCATENATE W_TEXT '/' IT_TAB1-ZFRMK4  INTO W_TEXT.
    ENDIF.

    WRITE:/'|' NO-GAP,
           (05) W_TABIX,
           (04) IT_TAB1-ZFWERKS,
           (02) IT_TAB1-ZFBNARCD,
           (10) IT_TAB1-ZFBLNO,
           (10) IT_TAB1-ZFETA,
           (10) IT_TAB1-ZFBNDT,
           (16) IT_TAB1-W_ZFPKCN,
           (16) IT_TAB1-ZFTOWT UNIT IT_TAB1-ZFTOWTM,
           (16) IT_TAB1-ZFTOVL UNIT IT_TAB1-ZFTOVLM,
           (18) IT_TAB1-ZFBLAMT CURRENCY IT_TAB1-ZFBLAMC,
           (05) IT_TAB1-ZFBLAMC,
           (20) IT_TAB1-ZFCARNO NO-GAP, '|' NO-GAP.
    WRITE:/ '|'  NO-GAP,
         13(24) W_NAME,
           (10) IT_TAB1-ZFBLSDT,
           (03) IT_TAB1-ZFVIA,
           (36) IT_TAB1-ZFCARNM,
           (20) IT_TAB1-ZFBTRNO,
           (10) IT_TAB1-ZFTDDT,
           (10) IT_TAB1-ZFINDT,
           (12) IT_TAB1-ZFGIRNM  NO-GAP, '|' NO-GAP.
    WRITE:/ '|'  NO-GAP,
         38(10) IT_TAB1-ZFFORD,
           (20) IT_TAB1-ZFSPRT,
           (34) IT_TAB1-ZFRGDSR,
           (40) W_TEXT  NO-GAP, '|' NO-GAP.
    ULINE.
    AT END OF ZFBNARCD.
       SUM.
       FORMAT COLOR 3 INTENSIFIED OFF.
       WRITE: '|' NO-GAP,
            13(23) 'Carry-in area Sum',
            49(16) IT_TAB1-W_ZFPKCN,
              (16) IT_TAB1-ZFTOWT UNIT IT_TAB1-ZFTOWTM,
              (16) IT_TAB1-ZFTOVL UNIT IT_TAB1-ZFTOVLM
                                  NO-GAP, 145 '|' NO-GAP.
       ULINE.
    ENDAT.
    AT END OF ZFWERKS.
       SUM.
       FORMAT COLOR 3 INTENSIFIED OFF.
       WRITE:/'|' NO-GAP,
             8(23) 'Plant Sum',
            49(16) IT_TAB1-W_ZFPKCN,
              (16) IT_TAB1-ZFTOWT UNIT IT_TAB1-ZFTOWTM,
              (16) IT_TAB1-ZFTOVL UNIT IT_TAB1-ZFTOVLM
                                  NO-GAP, 145 '|' NO-GAP.
       ULINE.
    ENDAT.
    AT END OF ZFTRCK.
       SUM.
       FORMAT COLOR 3 INTENSIFIED OFF.
       WRITE:/'|' NO-GAP,
             (23) 'Trucker  Sum',
           49(16) IT_TAB1-W_ZFPKCN,
             (16) IT_TAB1-ZFTOWT UNIT IT_TAB1-ZFTOWTM,
             (16) IT_TAB1-ZFTOVL UNIT IT_TAB1-ZFTOVLM
                                 NO-GAP, 145 '|' NO-GAP.
       ULINE.
    ENDAT.
    AT LAST.
       SUM.
       FORMAT COLOR 3 INTENSIFIED OFF.
       WRITE:/'|' NO-GAP,
              (23) 'Total',
            49(16) IT_TAB1-W_ZFPKCN,
              (16) IT_TAB1-ZFTOWT UNIT IT_TAB1-ZFTOWTM,
              (16) IT_TAB1-ZFTOVL UNIT IT_TAB1-ZFTOVLM
                                  NO-GAP, 145 '|' NO-GAP.
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

  IF SY-LANGU EQ '3'.
  WRITE:/55 '   �� �� �� ��  �� �� Ʈ   ' COLOR 1.
  WRITE:/125 'DATE :', SY-DATUM.
  WRITE:/125 'PAGE :', SY-PAGNO.

  CLEAR : IT_LIFNR.
  READ TABLE IT_LIFNR WITH KEY LIFNR = IT_TAB1-ZFTRCK.
  WRITE:/6 'Trucker :', IT_TAB1-ZFTRCK, IT_LIFNR-NAME1.

  ULINE.
  FORMAT COLOR 1 INTENSIFIED OFF.
  WRITE:/'|' NO-GAP,
        (05) ' Seq.',
        (04) 'Plan',
        (02) 'PL',
        (10) 'B/L ��ȣ'.
  SET LEFT SCROLL-BOUNDARY.
  WRITE: (10) '  ������',
         (10) '���������',
         (16) '���԰���  ' RIGHT-JUSTIFIED,
         (16) '�� �߷�  ' RIGHT-JUSTIFIED,
         (16) '�ѿ���  ' RIGHT-JUSTIFIED,
         (18) 'B/L �ݾ�  ' RIGHT-JUSTIFIED,
         (05) 'CURR',
         (20) '������ȣ' NO-GAP, '|' NO-GAP.
  WRITE:/ '|' NO-GAP,
       13(24) '���� ��� ��',
         (10) 'B/L �ۺ���',
         (03) 'VIA',
         (36) 'FLT/V. Name',
         (20) '������۽Ű��ȣ',
         (10) '��۱�����',
         (10) '  ������',
         (12) '���Դ����' NO-GAP, '|' NO-GAP.
    WRITE:/ '|'  NO-GAP,
         38(10) 'Forwarder',
           (20) '�� �� ��',
           (34) '��ǥǰ��',
           (40) '��     ��' NO-GAP, '|' NO-GAP.
 ELSEIF SY-LANGU EQ 'E'.
 WRITE:/55 '   Bonded transportation list   ' COLOR 1.
  WRITE:/125 'DATE :', SY-DATUM.
  WRITE:/125 'PAGE :', SY-PAGNO.

  CLEAR : IT_LIFNR.
  READ TABLE IT_LIFNR WITH KEY LIFNR = IT_TAB1-ZFTRCK.
  WRITE:/6 'Trucker :', IT_TAB1-ZFTRCK, IT_LIFNR-NAME1.

  ULINE.
  FORMAT COLOR 1 INTENSIFIED OFF.
  WRITE:/'|' NO-GAP,
        (05) 'Seq.',
        (04) 'Plan',
        (02) 'PL',
        (10) 'B/L No'.
  SET LEFT SCROLL-BOUNDARY.
  WRITE: (10) 'Arrival date  ',
         (10) 'Bonded transportation date',
         (16) 'Carry-in No' RIGHT-JUSTIFIED,
         (16) 'Total weight' RIGHT-JUSTIFIED,
         (16) 'Total capacity' RIGHT-JUSTIFIED,
         (18) 'B/L amount  ' RIGHT-JUSTIFIED,
         (05) 'CURR',
         (20) 'Vehicle No' NO-GAP, '|' NO-GAP.
  WRITE:/ '|' NO-GAP,
       13(24) 'Carry-in place name',
         (10) 'B/L sending date',
         (03) 'VIA',
         (36) 'FLT/V. Name',
         (20) 'Bonded transportation declaration No',
         (10) 'Transportation expiration date',
         (10) 'Carry-in date',
         (12) 'Carry-in manager' NO-GAP, '|' NO-GAP.
    WRITE:/ '|'  NO-GAP,
         38(10) 'Forwarder',
           (20) 'Loading port',
           (34) 'Rep goods name',
           (40) 'Remarks' NO-GAP, '|' NO-GAP.

  ENDIF.

  ULINE.

ENDFORM.                    " P1000_TOP_PAGE

*&---------------------------------------------------------------------*
*&      Form  P1000_DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_DOWNLOAD.

  LOOP AT IT_TAB1.
     WMTO_S-AMOUNT =  IT_TAB1-ZFBLAMT.
     CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
           EXPORTING
               CURRENCY  = IT_TAB1-ZFBLAMC
               AMOUNT_INTERNAL = WMTO_S-AMOUNT
           IMPORTING
               AMOUNT_DISPLAY  = WMTO_S-AMOUNT
           EXCEPTIONS
               INTERNAL_ERROR = 1.
     IT_TAB1-ZFBLAMT = WMTO_S-AMOUNT.
     MODIFY IT_TAB1.
  ENDLOOP.

  CALL FUNCTION 'DOWNLOAD'
        EXPORTING
        FILENAME = 'C:\TEMP\TEMP.TXT'
        FILETYPE = 'DAT'
   TABLES
       DATA_TAB = IT_TAB1.

ENDFORM.                    " P1000_DOWNLOAD
