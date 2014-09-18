*&---------------------------------------------------------------------*
*& INCLUDE MZIM04F01 .
*&---------------------------------------------------------------------*
*&  ���α׷��� : �����Ƿ� Main SUB MODULE Include
*&      �ۼ��� : ������ INFOLINK Ltd.
*&      �ۼ��� : 2000.01.25
*&  ����ȸ��PJT:
*&---------------------------------------------------------------------
*&   DESC.     :
*&---------------------------------------------------------------------

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_GUI_TEXT
*&---------------------------------------------------------------------*
FORM P2000_SET_GUI_TEXT.

  CASE W_STATUS.
    WHEN C_REQ_C.   ASSIGN W_CREATE  TO <FS_F>.
    WHEN C_REQ_U.   ASSIGN W_CHANGE  TO <FS_F>.
    WHEN C_REQ_D.   ASSIGN W_DISPLAY TO <FS_F>.
    WHEN C_OPEN_C.  ASSIGN W_OPEN    TO <FS_F>.
    WHEN C_OPEN_U.  ASSIGN W_STAUTS  TO <FS_F>.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_GUI_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PF_STATUS
*&---------------------------------------------------------------------*
FORM P2000_SET_PF_STATUS.
  CASE SY-TCODE.
    WHEN 'ZIMGL1' OR 'ZIMGL2' OR 'ZIMGL3'.
      MOVE 'LCGL' TO W_PFSTAT.
    WHEN OTHERS.
      EXIT.
  ENDCASE.

ENDFORM.                    " P2000_SET_PF_STATUS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_STATUS_TCODE_DISABLE
*&---------------------------------------------------------------------*
FORM P2000_SET_STATUS_TCODE_DISABLE.
  CASE SY-TCODE.
    WHEN 'ZIMGL1'.
      MOVE 'PURLIC' TO IT_EXCL-FCODE.  APPEND IT_EXCL." ���Ž��μ�..
      MOVE 'CRDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'DELE' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_STATUS_TCODE_DISABLE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_STATUS_SCR_DISABLE
*&---------------------------------------------------------------------*
FORM P2000_SET_STATUS_SCR_DISABLE.

  CASE SY-DYNNR.
    WHEN   '0100'.                " �����Ƿ� ���� �ʱ�ȭ?
      PERFORM   P2000_SET_LCGL_INIT_SCR.
      SET TITLEBAR  'LCGL' WITH W_DISPLAY.     W_STATUS = C_REQ_D.
    WHEN   '0101'.
      PERFORM   P2000_SET_LCGL_INIT_SCR.
      SET TITLEBAR  'LCGL' WITH W_DISPLAY.     W_STATUS = C_REQ_D.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_STATUS_SCR_DISABLE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LCGL_INIT_SCR
*&---------------------------------------------------------------------*
FORM P2000_SET_LCGL_INIT_SCR.

ENDFORM.                    " P2000_SET_LCGL_INIT_SCR
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SET_MESSAGE USING    P_SY_UCOMM.
  CASE P_SY_UCOMM.
*    WHEN 'ANZG'.      " CHANGE  ==> DISPLAY
*      PERFORM  P2000_ANZG_MESSAGE.
    WHEN 'SAVE'.      " ����?
      PERFORM  P2000_SAVE_MESSAGE.
    WHEN 'CANC'.      " ���?
      PERFORM  P2000_CANCEL_MESSAGE.
    WHEN 'BACK' OR 'EXIT'.   " ������ or ��?
      PERFORM  P2000_EXIT_MESSAGE.
*    WHEN 'DELE'.      " ����?
*      PERFORM  P2000_DELETE_MESSAGE.
*    WHEN 'REVK'.      " flat DB Create ���?
*      PERFORM  P2000_DEL_CANCEL_MESSAGE.
*    WHEN 'DELR'.      " ���� ���?
*      PERFORM  P2000_REVOCK_MESSAGE.
*    WHEN 'OPCL'.      " Ȯ�� ���?
*      PERFORM  P2000_OPEN_CANCEL_MESSAGE.
*    WHEN 'EDIS'.       " EDI Send
*      PERFORM  P2000_EDI_SEND_MESSAGE.
*    WHEN 'LGIS'.       ">�κ��Ƿ�.
*      PERFORM  P2000_LGI_SEND_MESSAGE.
    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_OK_CODE_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_OK_CODE_PROCESS.
  CASE OK-CODE.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTR' OR 'DDLC'.
    WHEN 'COPY'.
    WHEN 'CRDC'.          " ��?
      CASE SY-TCODE.
        WHEN 'ZIMGL1'.
          LEAVE TO TRANSACTION 'ZIMGL1'.
      ENDCASE.
    WHEN 'CHDC'.         " ��?
      CASE SY-TCODE.
      ENDCASE.
    WHEN 'DISP'.
      CASE SY-TCODE.
      ENDCASE.
    WHEN OTHERS.
      LEAVE TO TRANSACTION OK-CODE.
  ENDCASE.

ENDFORM.                    " P2000_OK_CODE_PROCESS
*&---------------------------------------------------------------------*
*&      Form  P2000_SCR_MODE_SET
*&---------------------------------------------------------------------*
FORM P2000_SCR_MODE_SET.

  DATA : L_CHK   VALUE   'Y'.

  LOOP AT SCREEN.

    CASE W_STATUS.
      WHEN C_REQ_C OR C_REQ_U.              " ����, ��?
        IF SCREEN-GROUP1 = 'IO'
        OR SCREEN-GROUP1 = 'I'.
          SCREEN-INPUT   = '1'.
        ELSE.
          SCREEN-INPUT   = '0'.
        ENDIF.
*        IF SCREEN-GROUP1 = 'I'.
*          SCREEN-INPUT   = '1'.
*        ENDIF.
      WHEN C_REQ_D.                         " ��ȸ.
        IF SCREEN-GROUP1 = 'I'.
          SCREEN-INPUT   = '1'.
        ELSE.
          SCREEN-INPUT   = '0'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

*    IF SY-DYNNR EQ '0102' OR SY-DYNNR EQ '0152'.
*      IF ZTIMIMG00-ZFRELYN1 NE 'X'.
*        IF SCREEN-NAME EQ 'ZTREQST-ZFREQDT' OR
*           SCREEN-NAME EQ 'ZTREQST-ERNAM'.
*          SCREEN-INVISIBLE = '1'.
*          SCREEN-INPUT = '0'.
*        ENDIF.
*      ENDIF.
*      IF ZTREQHD-ZFREQTY EQ 'LO' OR ZTREQHD-ZFREQTY EQ 'PU'.
*        IF SCREEN-NAME EQ 'ZTREQHD-ZFMATGB' OR
*           SCREEN-NAME EQ 'ZTREQHD-ZFLCKN'.
*          ZTREQHD-ZFMATGB = '2'.
*          ZTREQHD-ZFLCKN  = '8'.
*          SCREEN-INPUT = '0'.
*        ENDIF.
*      ENDIF.
*    ENDIF.

    IF SCREEN-NAME(10) EQ 'W_ROW_MARK'.
      SCREEN-INPUT   = '1'.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.                    " P2000_SCR_MODE_SET
*&---------------------------------------------------------------------*
*&      Form  P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SAVE_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                                  '�Էµ� ������ �����մϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'Y'                 " ��� ��ư ��/��.
                                  '1'.                 " default button

ENDFORM.                    " P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_CANCEL_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '��� Ȯ��'             " Ÿ��Ʋ...
                                  '����� ������ ������� ����˴ϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'N'                 " ��� ��ư ��/��.
                                  '2'.                 " default button

ENDFORM.                    " P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_EXIT_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                          '���� �Է³����� �������� �ʽ��ϴ�.'" MSG1
                          '���� �� �����Ͻðڽ��ϱ�?'       " MSG2
                          'Y'                         " ��� ��ư ��/��.
                          '1'.                        " default button

ENDFORM.                    " P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_BOX
*&---------------------------------------------------------------------*
FORM P2000_MESSAGE_BOX USING    TITLE  LIKE SPOP-TITEL
                                TEXT1  LIKE SPOP-TEXTLINE1
                                TEXT2  LIKE SPOP-TEXTLINE2
                                CANCEL LIKE CANCEL_OPTION
                                DEFAULT LIKE OPTION.

  SPOP-TITEL = TITLE.
  SPOP-TEXTLINE1 = TEXT1.
  SPOP-TEXTLINE2 = TEXT2.
  IF CANCEL EQ 'Y'.
    CANCEL_OPTION = 'Y'.
  ELSE.
    CLEAR : CANCEL_OPTION.
  ENDIF.
  OPTION = DEFAULT.
  TEXTLEN = 40.

  CALL SCREEN 0001 STARTING AT 30 6
                   ENDING   AT 78 10.

  IF ANTWORT = 'Y'.       " Cancel
    SET SCREEN 0. LEAVE SCREEN.
  ENDIF.

  IF ANTWORT = 'C'.       " Cancel
    SET SCREEN SY-DYNNR.
  ENDIF.

ENDFORM.                    " P2000_MESSAGE_BOX
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_EXIT_PROCESS.

  IF NOT W_STATUS EQ C_REQ_D.

    CASE ANTWORT.
      WHEN 'Y'.              " Yes...
        PERFORM  P2000_SET_SCREEN_SCRCOM.
        LEAVE SCREEN.
      WHEN OTHERS.
    ENDCASE.

  ELSEIF W_STATUS EQ C_REQ_D.
    CLEAR OK-CODE.
    PERFORM  P2000_SET_SCREEN_SCRCOM.
    LEAVE SCREEN.
  ENDIF.

ENDFORM.                    " P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
FORM P2000_SET_SCREEN_SCRCOM.

  IF SY-CALLD EQ 'X'.
    LEAVE.
  ENDIF.

  CASE W_STATUS.
    WHEN C_REQ_C.     " ����.
      CASE SY-TCODE.
        WHEN 'ZIMGL1'.     SET SCREEN 100. "L/C ������ȸ.
        WHEN OTHERS.       SET SCREEN 100.
      ENDCASE.
    WHEN C_REQ_U.     " ����.
      CASE SY-TCODE.
        WHEN 'ZIMGL1'.     SET SCREEN 100. "L/C ������ȸ.
        WHEN OTHERS.       SET SCREEN 100.
      ENDCASE.
    WHEN C_REQ_D.      " ��ȸ.
      CASE SY-TCODE.
        WHEN 'ZIMGL1'.     SET SCREEN 0. "L/C ������ȸ.
        WHEN OTHERS.       SET SCREEN 100.
      ENDCASE.
    WHEN OTHERS.
      SET SCREEN 0.
  ENDCASE.

* Invoice Processing
  CASE SY-TCODE.
    WHEN 'ZIMGL1'.     SET SCREEN 101.
  ENDCASE.

* �ʱ�ȭ������ exit�� Active Tab�� Clearing.
  CLEAR :  TABSTRIP-ACTIVETAB.

ENDFORM.                    " P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
*&      Form  P2000_AMT_MAKE
*&---------------------------------------------------------------------*
FORM P2000_AMT_MAKE USING    P_AMOUNT
                             P_CURRENCY
                    CHANGING R_AMOUNT.

  DATA : L_TCURC LIKE TCURC.

  WRITE    P_AMOUNT    TO      W_TEXT_AMOUNT
                  CURRENCY     P_CURRENCY.
  PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

*> CURRENCY ISO CODE SELECT.
  CLEAR : L_TCURC.
  SELECT SINGLE * INTO L_TCURC FROM TCURC
                  WHERE WAERS  EQ  P_CURRENCY.
  IF SY-SUBRC NE 0.
    L_TCURC-ISOCD = P_CURRENCY.
  ELSE.
    IF L_TCURC-ISOCD IS INITIAL.
      L_TCURC-ISOCD = P_CURRENCY.
    ENDIF.
  ENDIF.

  MOVE W_TEXT_AMOUNT TO R_AMOUNT.

ENDFORM.                    " P2000_AMT_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_WRITE_NO_MASK
*&---------------------------------------------------------------------*
FORM P2000_WRITE_NO_MASK CHANGING P_TEXT_AMOUNT.

  SELECT SINGLE * FROM USR01 WHERE BNAME EQ SY-UNAME.

  CASE USR01-DCPFM.
    WHEN 'X'.    " Decimal point is period: N,NNN.NN
      PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT ',' ' '.
      CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
    WHEN 'Y'.    " Decimal point is N NNN NNN,NN
      PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  ',' '.'.
      CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
    WHEN OTHERS. " Decimal point is comma: N.NNN,NN
      PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  '.' ' '.
      PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  ',' '.'.
      CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
  ENDCASE.

ENDFORM.                    " P2000_WRITE_NO_MASK
*&---------------------------------------------------------------------*
*&      Form  P2000_CHANGE_SYMBOL
*&---------------------------------------------------------------------*
FORM P2000_CHANGE_SYMBOL USING    P_AMOUNT  P_FROM  P_TO.

  DO.
    REPLACE  P_FROM   WITH   P_TO  INTO    P_AMOUNT.
    IF  SY-SUBRC  <>    0.
      EXIT.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_CHANGE_SYMBOL
