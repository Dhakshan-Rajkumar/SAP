*&---------------------------------------------------------------------*
*& Title: Program for correction wrong status                          *
*&---------------------------------------------------------------------*

REPORT ZZCORR00  LINE-SIZE 99.

TABLES: FEBKO, FEBEP.
DATA FLAG.
SELECTION-SCREEN BEGIN OF BLOCK BL0 WITH FRAME.
  PARAMETERS XFF67 RADIOBUTTON GROUP RGR.
  SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME.
    PARAMETERS:
      STNUMBER  LIKE FEBMKA-AZNUM,
      STDATE    LIKE FEBMKA-AZDAT.
  SELECTION-SCREEN END OF BLOCK BL1.
  PARAMETERS XFF68 RADIOBUTTON GROUP RGR.
  SELECTION-SCREEN BEGIN OF BLOCK BL2 WITH FRAME.
    PARAMETERS:
      CHUSER    LIKE FEBSCA-UNAME,
      CHDATE    LIKE FEBSCA-SYDAT.
  SELECTION-SCREEN END OF BLOCK BL2.
SELECTION-SCREEN END OF BLOCK BL0.

START-OF-SELECTION.
  IF XFF67 = 'X'.
    FEBKO-ANWND = '0001'.
    FEBKO-AZIDT(4) = STDATE.
    FEBKO-AZIDT+4(5) = STNUMBER.
  ELSE.
    FEBKO-ANWND = '0002'.
    FEBKO-AZIDT(8) = CHDATE.
    FEBKO-AZIDT+8(12) = CHUSER.
  ENDIF.
  SELECT * FROM FEBKO WHERE ANWND = FEBKO-ANWND
                      AND   AZIDT = FEBKO-AZIDT.
    CLEAR FLAG.
    IF FEBKO-VB1OK = 'X'.
      SELECT * FROM FEBEP WHERE KUKEY = FEBKO-KUKEY
                          AND   VB1OK = SPACE.
        EXIT.
      ENDSELECT.
      IF SY-SUBRC = 0.
        FLAG = 'X'.
        FEBKO-VB1OK = SPACE.
      ENDIF.
    ENDIF.
    IF FEBKO-VB2OK = 'X'.
      SELECT * FROM FEBEP WHERE KUKEY = FEBKO-KUKEY
                          AND   VB2OK = SPACE.
        EXIT.
      ENDSELECT.
      IF SY-SUBRC = 0.
        FLAG = 'X'.
        FEBKO-VB2OK = SPACE.
      ENDIF.
    ENDIF.
    IF FEBKO-ASTAT = '4'.
      FEBKO-ASTAT = '2'.
      FLAG = 'X'.
    ENDIF.
    IF FLAG = 'X'.
      UPDATE FEBKO.
      WRITE: / FEBKO-ABSND, FEBKO-AZIDT, FEBKO-EMKEY.
    ENDIF.
  ENDSELECT.