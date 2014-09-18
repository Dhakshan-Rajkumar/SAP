*&---------------------------------------------------------------------*
*& Report            ZRIMTRPLAN                                        *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���۰�ȹ�� (����â�����)                             *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.07                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

PROGRAM  ZRIMTRPLAN  MESSAGE-ID ZIM
                     LINE-SIZE 103
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------

INCLUDE   ZRIMTRPLANTOP.
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ����.

*-----------------------------------------------------------------------
* Selection Screen .
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
*>> �˻�����
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS :   P_ZFTRNO  LIKE  ZTTRHD-ZFTRNO
                         OBLIGATORY MEMORY ID ZPTRNO.    " ����ȣ.
SELECTION-SCREEN END OF BLOCK B1.

*---------------------------------------------------------------------*
* EVENT INITIALIZATION.
*---------------------------------------------------------------------*
INITIALIZATION.                                 " �ʱⰪ SETTING
  PERFORM   P2000_SET_PARAMETER.
  SET TITLEBAR 'TRPL'.


*---------------------------------------------------------------------*
* EVENT TOP-OF-PAGE.
*---------------------------------------------------------------------*
TOP-OF-PAGE.
*
  PERFORM WF.                  "Workflow ���� �ڵ�
*
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*---------------------------------------------------------------------*
* EVENT START-OF-SELECTION.
*---------------------------------------------------------------------*
START-OF-SELECTION.


  PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE .
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
  CLEAR : IT_TAB.
*-----------------------------------------------------------------------
* EVENT AT USER-COMMAND.
*-----------------------------------------------------------------------
AT USER-COMMAND.

  CASE SY-UCOMM.
*    WHEN 'STUP' OR 'STDN'.              " SORT ����?
*      IF IT_TAB-ZFTRNO IS INITIAL.
*        MESSAGE S962.
*      ELSE.
*        W_FIELD_NM = 'ZFTRNO'.
*        ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
*        PERFORM HANDLE_SORT TABLES  IT_TAB
*                            USING   SY-UCOMM.
*      ENDIF.
*    WHEN 'MKAL' OR 'MKLO'.          " ��ü ���� �� ��������.
*      PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
*
    WHEN 'REFR'.
      PERFORM   P1000_READ_TEXT  USING W_ERR_CHK.
      IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
      PERFORM   RESET_LIST.

    WHEN 'BAC1' OR 'EXIT' OR 'CANC'.    " ����.
      LEAVE TO SCREEN 0.
* Workflow code                "NCW ����
*    WHEN 'APPR'.                        "����
*      SELECT SINGLE * INTO *ZMMT5900
*        FROM ZMMT5900
*        WHERE PGM = GL_PGM AND
*              VAR = GL_VAR.
*      IF SY-SUBRC = 0.
** ����ܰ� ����
*         *ZMMT5900-APP_PRN = *ZMMT5900-APP_PRN + 1.
**���� ������ UPDATE��
*        CASE *ZMMT5900-APP_PRN.
*          WHEN '2'.
*            MOVE SY-DATUM TO *ZMMT5900-APP2_D.
*            MOVE SY-UZEIT TO *ZMMT5900-APP2_T.
*          WHEN '3'.
*            MOVE SY-DATUM TO *ZMMT5900-APP3_D.
*            MOVE SY-UZEIT TO *ZMMT5900-APP3_T.
*            MOVE 'A' TO *ZMMT5900-ZFLAG.
*        ENDCASE.
*
*        MODIFY ZMMT5900 FROM *ZMMT5900.
*
**W/F�� �Ѱ��� ������ �����ϰ� ���α׷� ����
*        SET PARAMETER ID 'AR' FIELD 'A'.
*        SET PARAMETER ID 'ZPGM' FIELD *ZMMT5900-PGM.
*        SET PARAMETER ID 'ZVAR' FIELD *ZMMT5900-VAR.
*        LEAVE PROGRAM.
*      ENDIF.
*
    WHEN OTHERS.
  ENDCASE.
  CLEAR IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.


ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  IF W_PAGE EQ 1.
    SELECT SINGLE * FROM ZTTRHD
                   WHERE ZFTRNO = IT_TAB-ZFTRNO.

*> ���۱���.
    IF NOT ZTTRHD-ZFTRGB IS INITIAL.
      PERFORM   GET_DD07T_SELECT USING      'ZDTRGB'  ZTTRHD-ZFTRGB
                                 CHANGING    W_TRGB  W_SY_SUBRC.
    ENDIF.


    SKIP 2.
    FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
    WRITE : /44  '[ �� �� �� ȹ �� ]'
                 COLOR COL_HEADING INTENSIFIED OFF.
    WRITE : /46  '(', ZTTRHD-ZFGIDT , ')'.
    SKIP 2.
    WRITE : / '�� �� �� ȣ : ', ZTTRHD-ZFTRNO,
            / '�� �� �� �� : ',  W_TRGB,
            / '��        ��: ', '�� �� �� ��',
            / '�Ʒ��� ���縦 �����ϰ��� �մϴ�.'.
    SKIP .
  ENDIF.
ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_SUB_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_SUB_TITLE_WRITE.

  WRITE : / '��  ��  ��:', IT_TAB-W_WERKS,
          / '���  ��ȣ:', IT_TAB-EBELN,
         35 '��������:',   IT_TAB-ZFSHNO.

  IF W_PAGE EQ 1.
    WRITE :  55 '�߷�:',
             (15) ZTTRHD-ZFTOWT UNIT ZTTRHD-ZFTOWTM RIGHT-JUSTIFIED,
              ZTTRHD-ZFTOWTM.
  ENDIF.

  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP, (20) '����ĺ���ȣ' CENTERED NO-GAP,
            SY-VLINE NO-GAP, (40) 'ǰ�� �� �԰�' CENTERED NO-GAP,
            SY-VLINE NO-GAP, (20) '���    ����' CENTERED NO-GAP,
            SY-VLINE NO-GAP, (18) '��        ��' CENTERED NO-GAP,
            SY-VLINE.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_SUB_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    P_W_ERR_CHK.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
           FROM ZTTRIT
          WHERE ZFTRNO = P_ZFTRNO.

  IF SY-SUBRC NE 0.
    W_ERR_CHK = 'Y'.
    MESSAGE S738.
    EXIT.
  ENDIF.

  LOOP AT IT_TAB.
    W_TABIX  = SY-TABIX.
*> ����ó.
    IF NOT IT_TAB-WERKS IS INITIAL.
      SELECT SINGLE NAME1 INTO IT_TAB-W_WERKS
                          FROM T001W
                         WHERE WERKS = IT_TAB-WERKS.
    ENDIF.

*> �ݾ�.
    IT_TAB-AMOUNT = IT_TAB-GIMENGE * IT_TAB-NETPR.

*> Storage Location.
*      IF NOT IT_TAB-LGORT IS INITIAL.
*        SELECT SINGLE LGOBE INTO IT_TAB-W_LGORT
*                            FROM T001L
*                           WHERE WERKS = IT_TAB-WERKS
*                             AND LGORT = IT_TAB-LGORT.
*      ENDIF.

    MODIFY IT_TAB INDEX W_TABIX.

  ENDLOOP.
ENDFORM.                    " P1000_READ_TEXT

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE.

  SET PF-STATUS 'TRPL'.

** Begin of Workflow programming
  DATA: FL_FROMWF.
* Workflow�� ���� �ҷ��� ���̶�� fl_fromwf = 'X'�� �ȴ�.
  PERFORM CHECK_FROM_WF(ZMM_WF5930) CHANGING FL_FROMWF. "Whether from WF
  IF FL_FROMWF = 'X'.
    SET PF-STATUS 'PS_WF'.
  ENDIF.
** End of Workflow programming
  W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.
  LOOP AT IT_TAB.
    W_LINE = W_LINE + 1.
    ON CHANGE OF IT_TAB-WERKS OR IT_TAB-EBELN.
      IF SY-TABIX NE 1.
        PERFORM P3000_SUB_TOTAL.
        ADD 1 TO W_PAGE.
      ENDIF.
      PERFORM P3000_SUB_TITLE_WRITE.
    ENDON.
    PERFORM P3000_LINE_WRITE.

    AT LAST.
      PERFORM P3000_SUB_TOTAL.
      PERFORM P3000_LAST_WRITE.
    ENDAT.

  ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE
*&----------------------------------------------------------------------
*&      Form  RESET_LIST
*&----------------------------------------------------------------------
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE .

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  TEMP = W_LINE MOD 2.
  IF TEMP EQ 0.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ELSE.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.

  WRITE : / SY-VLINE NO-GAP, 3(19) IT_TAB-MATNR     NO-GAP,
            SY-VLINE NO-GAP,  (40) IT_TAB-TXZ01     NO-GAP,
            SY-VLINE NO-GAP,
            (17) IT_TAB-GIMENGE UNIT IT_TAB-MEINS
                                  RIGHT-JUSTIFIED    NO-GAP,
            (03) IT_TAB-MEINS                        NO-GAP,
            SY-VLINE NO-GAP,
            (18) IT_TAB-AMOUNT CURRENCY IT_TAB-ZFIVAMC
                                  RIGHT-JUSTIFIED    NO-GAP,
            SY-VLINE NO-GAP.

  ADD IT_TAB-AMOUNT TO W_SUB_AMT.   " SUB TOTAL.
  W_SUB_CUR = IT_TAB-ZFIVAMC .

  CLEAR IT_TOT.                       " GRAND TOTAL.
  MOVE : IT_TAB-ZFIVAMC TO IT_TOT-ZFIVAMC,
         IT_TAB-AMOUNT  TO IT_TOT-AMOUNT.
  COLLECT IT_TOT.

  W_COUNT  = W_COUNT  + 1. " ��ü COUNT.
ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
    FORMAT RESET.
    WRITE : /63 SY-ULINE.
    WRITE : /65 '�ݾ��Ѱ� : ' NO-GAP.

    LOOP AT IT_TOT.
      WRITE : 80(05) IT_TOT-ZFIVAMC NO-GAP,
              85(18) IT_TOT-AMOUNT CURRENCY  IT_TOT-ZFIVAMC
                              RIGHT-JUSTIFIED NO-GAP.
      NEW-LINE.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&----------------------------------------------------------------------
*&      Form P3000_SUB_TOTAL
*&----------------------------------------------------------------------
FORM P3000_SUB_TOTAL.

  ULINE.
  FORMAT RESET.

  WRITE: /65 '�ݾ��հ� : ' NO-GAP,
          80(05) W_SUB_CUR    NO-GAP,
          85(18) W_SUB_AMT CURRENCY  W_SUB_CUR
                       RIGHT-JUSTIFIED NO-GAP.
  SKIP.
  CLEAR: W_SUB_CUR, W_SUB_AMT.

ENDFORM.                    " SUB_TOTAL
*&---------------------------------------------------------------------*
*&      Form  wf
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WF.
***** BEGIN OF CODE FOR WORKFLOW ***************************************

* Workflow�� ���� �ҷ��� ���̶�� fl_fromwf = 'X'�� �ȴ�.
  PERFORM CHECK_FROM_WF(ZMM_WF5930) CHANGING FL_FROMWF. "Whether from WF
  IF FL_FROMWF = 'X'.
    GET PARAMETER ID 'ZPGM' FIELD GL_PGM.  "PROGRAM ID
    GET PARAMETER ID 'ZVAR' FIELD GL_VAR.  "VARIABLE
*
*    SELECT SINGLE * INTO *ZMMT5900            "NCW ����
*      FROM ZMMT5900
*      WHERE PGM = GL_PGM AND
*            VAR = GL_VAR.
** ��������� �����.
*    PERFORM HD_APPROVALLINE(ZMM_WF5930) USING *ZMMT5900-APP1_H
*                                              *ZMMT5900-APP1_D
*                                              *ZMMT5900-APP2_H
*                                              *ZMMT5900-APP2_D
*                                              *ZMMT5900-APP3_H
*                                              *ZMMT5900-APP3_D.
  ENDIF.

***** END OF CODE FOR WORKFLOW******************************************

ENDFORM.                    " wf
