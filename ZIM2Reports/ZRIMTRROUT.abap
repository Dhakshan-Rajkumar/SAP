*&---------------------------------------------------------------------*
*& Report           ZRIMTRROUT                                         *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ������(����â�����)                                  *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.12.02                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

PROGRAM  ZRIMTRROUT  MESSAGE-ID ZIM
                     LINE-SIZE 129
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------

INCLUDE   ZRIMTRROUTTOP.
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ����.

*-----------------------------------------------------------------------
* Selection Screen .
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
*>> �˻�����
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS :   P_ZFTRNO  LIKE ZTTRHD-ZFTRNO.

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
  PERFORM   P3000_TITLE_WRITE.                  " ��� ���...

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

    SELECT SINGLE * FROM ZTTRHD
                   WHERE ZFTRNO = IT_TAB-ZFTRNO.

    SKIP 2.
    FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
    WRITE : /60  '[ ��      ��      �� ]'
                 COLOR COL_HEADING INTENSIFIED OFF.

    SKIP 2 .
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP, (08) '�Ϸù�ȣ'       CENTERED NO-GAP,
            SY-VLINE NO-GAP, (24) 'House B/L No.'  CENTERED NO-GAP,
            SY-VLINE NO-GAP, (10) '��� ��ȣ'      CENTERED NO-GAP,
            SY-VLINE NO-GAP, (20) '����ĺ���ȣ'   CENTERED NO-GAP,
            SY-VLINE NO-GAP, (40) 'ǰ�� �� �԰�'   CENTERED NO-GAP,
            SY-VLINE NO-GAP, (20) '����    ����'   CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (20) '��        ��'   CENTERED NO-GAP,
            SY-VLINE.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    P_W_ERR_CHK.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
           FROM ZTTRIT
          WHERE ZFTRNO  EQ P_ZFTRNO.

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

*>> House B/L, B/L �߷� ��������.
    IF NOT IT_TAB-ZFBLNO IS INITIAL.
       SELECT SINGLE ZFHBLNO ZFNEWT ZFNEWTM
              INTO (IT_TAB-ZFHBLNO, IT_TAB-ZFNEWT, IT_TAB-ZFNEWTM)
              FROM ZTBL
             WHERE ZFBLNO = IT_TAB-ZFBLNO.
    ENDIF.

    MODIFY IT_TAB INDEX W_TABIX.

  ENDLOOP.
ENDFORM.                    " P1000_READ_TEXT

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE.

  SET PF-STATUS 'TRPL'.
  SORT IT_TAB BY ZFTRNO ZFBLNO EBELN  MATNR.

  W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.
  LOOP AT IT_TAB.
    W_LINE = W_LINE + 1.
    PERFORM P3000_LINE_WRITE.
  ENDLOOP.

  PERFORM   P3000_SUB_TOTAL.
  PERFORM   P3000_TAIL_WRITE.

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

  WRITE : / SY-VLINE NO-GAP, (08) W_LINE RIGHT-JUSTIFIED NO-GAP,
            SY-VLINE NO-GAP, (24) IT_TAB-ZFHBLNO   NO-GAP,
            SY-VLINE NO-GAP, (10) IT_TAB-EBELN     NO-GAP,
            SY-VLINE NO-GAP, (20) IT_TAB-MATNR     NO-GAP,
            SY-VLINE NO-GAP, (40) IT_TAB-TXZ01     NO-GAP,
            SY-VLINE NO-GAP,
            (17) IT_TAB-GIMENGE UNIT IT_TAB-MEINS
                                  RIGHT-JUSTIFIED    NO-GAP,
            (03) IT_TAB-MEINS                        NO-GAP,
*            SY-VLINE NO-GAP,
*            (17) IT_TAB-ZFNEWT  UNIT IT_TAB-ZFNEWTM INPUT ON
*                                  RIGHT-JUSTIFIED    NO-GAP,
*            (03) IT_TAB-ZFNEWTM                      NO-GAP,
            SY-VLINE NO-GAP.
 ULINE.

  CLEAR IT_TOT.                       " TOTAL.
  MOVE : IT_TAB-MEINS    TO IT_TOT-MEINS,
         IT_TAB-GIMENGE  TO IT_TOT-GIMENGE.
  COLLECT IT_TOT.

ENDFORM.                    " P3000_LINE_WRITE
*&----------------------------------------------------------------------
*&      Form P3000_SUB_TOTAL
*&----------------------------------------------------------------------
FORM P3000_SUB_TOTAL.

    FORMAT RESET.

    LOOP AT IT_TOT.
    IF SY-TABIX EQ '1'.
       WRITE : SY-VLINE NO-GAP, (08) '��   ��' CENTERED NO-GAP.
    ELSE.
      WRITE : SY-VLINE NO-GAP.
    ENDIF.
      WRITE : 108(17) IT_TOT-GIMENGE  UNIT IT_TOT-MEINS
                              RIGHT-JUSTIFIED NO-GAP,
                 (03) IT_TOT-MEINS NO-GAP, 129 SY-VLINE.
      NEW-LINE.
    ENDLOOP.
    WRITE : SY-ULINE.

ENDFORM.                    " P3000_SUB_TOTAL
*&---------------------------------------------------------------------*
*&      Form  P3000_TAIL_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_TAIL_WRITE.

 SKIP 2.
 WRITE :   ' �� ����� : ',
          (13) ZTTRHD-ZFPKCN UNIT ZTTRHD-ZFPKCNM NO-ZERO
                  RIGHT-JUSTIFIED , ZTTRHD-ZFPKCNM,
         / ' �� ��  �� : ',
          (13) ZTTRHD-ZFTOWT UNIT ZTTRHD-ZFTOWTM NO-ZERO
                  RIGHT-JUSTIFIED , ZTTRHD-ZFTOWTM,
         / ' �� ��  �� : ',
          (13) ZTTRHD-ZFTOVL UNIT ZTTRHD-ZFTOVLM NO-ZERO
                  RIGHT-JUSTIFIED , ZTTRHD-ZFTOVLM.
* SKIP 2.
* WRITE : ' ���� ���� ���۵� ǰ�� ���� ������ Ȯ���մϴ�.'.
* SKIP.
* WRITE : ' ������ :                ',
*         ' �Ҽ� :               ',
*         ' ���� :               '.

ENDFORM.                    " P3000_TAIL_WRITE
