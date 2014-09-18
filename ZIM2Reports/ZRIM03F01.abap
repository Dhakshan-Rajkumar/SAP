*----------------------------------------------------------------------*
*INCLUDE ZRIM03F01 .
*----------------------------------------------------------------------*
*&  ���α׷��� : ���԰���/�ΰ��� ��� Main SUB MODULE Include
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.06.10
*&  ����ȸ��PJT: LG ȭ��.
*&---------------------------------------------------------------------
*&   DESC.     :
*&
*&---------------------------------------------------------------------

*&---------------------------------------------------------------------*
*&      Form  P2000_DATA_INITIALIZE
*&---------------------------------------------------------------------*
FORM P2000_DATA_INITIALIZE.

  CLEAR : ZTCCHD, *ZTCCHD, W_ZFDCNM, W_COST_TYPE,
          IT_ZSCCIT, IT_ZSCCIT_OLD, IT_ZSBDIV, IT_ZSBHIS,
          *LFA1.

  REFRESH : IT_ZSCCIT, IT_ZSCCIT_OLD, IT_ZSBDIV,IT_ZSBHIS.

  W_EDIT_CHECK = 'N'.

  MOVE: 0                  TO RF05A-AZSAL,
         ICON_YELLOW_LIGHT TO RF05A-AMPEL,
         '�ܾ��� ���� �������� �ʾ���' TO TEXT_080.

  PERFORM SET_OBJ_ICON        USING RF05A-AMPEL
                              RF05A-AMPEL TEXT_080.

  MOVE: 0                  TO RF05A-AZHAB,
         ICON_YELLOW_LIGHT TO W_AMPEL,
         '�ܾ��� ���� �������� �ʾ���' TO TEXT_090.

  PERFORM SET_OBJ_ICON        USING RF05A-AMPEL
                              W_AMPEL TEXT_090.

ENDFORM.                    " P2000_DATA_INITIALIZE
*&---------------------------------------------------------------------*
*&      Form  SET_OBJ_ICON
*&---------------------------------------------------------------------*
FORM SET_OBJ_ICON USING    P_ICON
                           P_FIELD
                           P_INFO.
  call function 'ICON_CREATE'
       exporting
            name                  = p_icon
            info                  = p_info
*           ADD_STDINF            = 'X'
       importing
       result                =  p_field.


ENDFORM.                    " SET_OBJ_ICON
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_CREATE_FIELD_VALUE
*&---------------------------------------------------------------------*
FORM P2000_SET_CREATE_FIELD_VALUE.

   IF W_STATUS NE C_REQ_C.
      GET PARAMETER ID 'ZPCCNO'    FIELD ZTCCHD-ZFCCNO.
   ENDIF.

   IF NOT ZTCCHD-BUKRS IS INITIAL.
*>> COMMPANY CODE CHECK.
      PERFORM  P1000_GET_COMPANY_CODE USING ZTCCHD-BUKRS.
   ENDIF.

   MOVE : SY-MANDT    TO      ZTCCHD-MANDT,
          SY-DATUM    TO      ZTCCHD-BUDAT,   " ��ǥ������.
          'RE'        TO      ZTCCHD-BLART,   " ��ǥ����.
          SPACE       TO      ZTCCHD-ZLSPR,   " ���޺���Ű.
          'N'         TO      ZTCCHD-ZFPOSYN, " ��ǥó�� ����.
          'KRW'       TO      ZTCCHD-WAERS.

   MOVE: 0                 TO RF05A-AZSAL,
         ICON_YELLOW_LIGHT TO RF05A-AMPEL,
         '�ܾ��� ���� �������� �ʾ���' TO TEXT_080,
         0                 TO RF05A-AZHAB,
         ICON_YELLOW_LIGHT TO W_AMPEL,
         '�ܾ��� ���� �������� �ʾ���' TO TEXT_090.

   PERFORM SET_OBJ_ICON        USING RF05A-AMPEL
                               RF05A-AMPEL TEXT_080.

   PERFORM SET_OBJ_ICON        USING RF05A-AMPEL
                               W_AMPEL TEXT_090.

   MOVE-CORRESPONDING  ZTCCHD  TO  *ZTCCHD.

ENDFORM.                    " P2000_SET_CREATE_FIELD_VALUE
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_COMPANY_CODE
*&---------------------------------------------------------------------*
FORM P1000_GET_COMPANY_CODE USING    P_BUKRS   LIKE  BKPF-BUKRS.

  DATA : L_BUKRS  LIKE   BKPF-BUKRS.

  MOVE P_BUKRS  TO L_BUKRS.

  CALL FUNCTION 'COMPANY_CODE_READ'
       EXPORTING
            I_BUKRS = L_BUKRS
       IMPORTING
            E_T001  = T001
            E_T004  = T004
            E_T005  = T005
            E_T014  = T014
            E_T043  = T043
            E_T043T = T043T.

  CALL FUNCTION 'FI_CURRENCY_INFORMATION'
       EXPORTING
            I_BUKRS = T001-BUKRS
            I_LAND1 = T001-LAND1
            I_RCOMP = T001-RCOMP
       IMPORTING
            E_X001  = X001.

*------- Externe Buchungskreise ablehnen -------------------------------
  IF T001-XEXTB NE SPACE.
    MESSAGE E571(F5).
  ENDIF.

  IF T043T-BUKRS = SPACE.
    MESSAGE W103(F5) WITH P_BUKRS.
  ENDIF.

*  AUTHORITY-CHECK OBJECT F_BKPF_BUK
*    ID 'ACTVT' FIELD ACT_HINZ
*    ID 'BUKRS' FIELD BKPF-BUKRS.
*  IF SY-SUBRC NE 0.
*    MESSAGE E083(F5) WITH BKPF-BUKRS.
*  ENDIF.

*------- Kalkulationsschema lesen --------------------------------------
  IF TAX-BUKRS = SPACE.
    CALL FUNCTION 'FIND_TAX_SPREADSHEET'
         EXPORTING
              BUCHUNGSKREIS = T001-BUKRS
         IMPORTING
              SCHEMA        = T005-KALSM
         EXCEPTIONS
              NOT_FOUND     = 04.

    IF SY-SUBRC NE 0.
      MESSAGE E470(F5) WITH T001-BUKRS.
    ENDIF.
    CLEAR TTXD.
    SELECT SINGLE * FROM TTXD WHERE KALSM = T005-KALSM.
    T007A-KALSM = T005-KALSM.
  ELSE.
    T005-KALSM = T007A-KALSM.
  ENDIF.

  SET PARAMETER ID 'BUK' FIELD P_BUKRS.

*>> IMG �������ڵ�.
  SELECT SINGLE * FROM ZTIMIMG11 WHERE BUKRS EQ P_BUKRS.
  IF SY-SUBRC NE 0.
     MESSAGE S987 WITH P_BUKRS.
     LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.                    " P1000_GET_COMPANY_CODE
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

  CASE SY-DYNNR.
     WHEN '0100'.
        MOVE '100' TO W_PFSTAT.
     WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_PF_STATUS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_STATUS_TCODE_DISABLE
*&---------------------------------------------------------------------*
FORM P2000_SET_STATUS_TCODE_DISABLE.

  CASE SY-TCODE.
* ���� t-code
    WHEN 'ZIMC5'.
      MOVE 'OTDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ��Ÿ����.
      MOVE 'CRDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'DELE' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'CCDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " �������.
      MOVE 'CCCD' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   "
      MOVE 'VTCD' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'CCFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'VTFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'HIST' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " HEAD CHAN
      MOVE 'HIIT' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ITEM CHAN
      SET TITLEBAR  '100' WITH 'Cutoms/VAT Doc : Create'.
* ���� t-code
    WHEN 'ZIMC6'.
*      MOVE 'OPDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  " ����.
      MOVE 'CCDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " �������.
      MOVE 'CHDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      SET TITLEBAR  '100' WITH 'Cutoms/VAT Doc : Change'.
* ��ȸ t-code
    WHEN 'ZIMC7'.
      MOVE 'DISP' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ��ȸ.
      MOVE 'SAVE' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      SET TITLEBAR  '100' WITH 'Cutoms/VAT Doc : Display'.
    WHEN OTHERS.
  ENDCASE.

  IF ZTCCHD-ZFPOSYN NE 'Y'.
     MOVE 'CCFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ��ǥ��ȸ.
     MOVE 'VTFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ��ǥ��ȸ.
     MOVE 'FIHI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  " >�̷�.
     MOVE 'CCDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " �������.
  ELSEIF ZTCCHD-ZFPOSYN EQ 'Y'.
     MOVE 'OPDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
  ENDIF.
  IF ZTCCHD-BELNR1 IS INITIAL.
     MOVE 'CCCD' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  " ������빮��.
*     MOVE 'OPDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
  ENDIF.
  IF ZTCCHD-LIFNR IS INITIAL.
     MOVE 'MK03' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  " ����ó.
  ENDIF.
  IF ZTCCHD-BELNR2 IS INITIAL.
     MOVE 'VTCD' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  " �ΰ�����빮��.
  ENDIF.
  IF ZTCCHD-ZFCCAN IS INITIAL OR ZTCCHD-ZFFYCC IS INITIAL.
     MOVE 'CCFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
  ENDIF.
  IF ZTCCHD-ZFVTAN IS INITIAL OR ZTCCHD-ZFFYVT IS INITIAL.
     MOVE 'VTFI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   "
  ENDIF.

  DESCRIBE TABLE IT_ZSCCIT  LINES W_LINE.
  IF W_LINE EQ 0.
      MOVE 'SAVE' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'DELE' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " ����.
      MOVE 'IMDC' TO IT_EXCL-FCODE.    APPEND IT_EXCL.   " �����۹�.
  ENDIF.

*  DESCRIBE TABLE IT_ZSBHIS  LINES W_LINE.
*  IF W_LINE EQ 0.
*     MOVE 'FIHI' TO IT_EXCL-FCODE.    APPEND IT_EXCL.  ">�̷�.
*  ENDIF.

ENDFORM.                    " P2000_SET_STATUS_TCODE_DISABLE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SET_MESSAGE USING    P_SY_UCOMM.

  W_COMMAND =  P_SY_UCOMM.

  CASE P_SY_UCOMM.
    WHEN 'ANZG'.      " CHANGE  ==> DISPLAY
      PERFORM  P2000_ANZG_MESSAGE.
    WHEN 'SAVE'.      " ����?
      PERFORM  P2000_SAVE_MESSAGE.
    WHEN 'CANC'.      " ���?
      PERFORM  P2000_CANCEL_MESSAGE.
    WHEN 'BACK' OR 'EXIT'.   " ������ or ����.
      PERFORM  P2000_EXIT_MESSAGE.
    WHEN 'DELE'.      " ����?
      PERFORM  P2000_DELETE_MESSAGE.
    WHEN 'OPDC'.
      PERFORM  P2000_POSTING_MESSAGE.
    WHEN 'CCDC'.
      PERFORM  P2000_FI_CANCEL_MESSAGE.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_ANZG_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_ANZG_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '�̵� Ȯ��'             " Ÿ��Ʋ...
                                  '���� �Է³����� �������� �ʽ��ϴ�.'
                                  '���� �� �̵��Ͻðڽ��ϱ�?'" MSG2
                                  'Y'                 " ��� ��?
                                  '1'.                      " default


ENDFORM.                    " P2000_ANZG_MESSAGE
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

  IF W_COMMAND EQ 'CCDC'.
     IF BSIS-BUDAT IS INITIAL.
        BSIS-BUDAT = SY-DATUM.
     ENDIF.

     CALL SCREEN 0020 STARTING AT 30 2
                      ENDING   AT 78 11.

  ELSE.
     CALL SCREEN 0001 STARTING AT 30 6
                      ENDING   AT 78 10.

  ENDIF.

  IF ANTWORT = 'C'.                                         " Cancel
    SET SCREEN SY-DYNNR.
  ENDIF.

ENDFORM.                    " P2000_MESSAGE_BOX
*&---------------------------------------------------------------------*
*&      Form  P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SAVE_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                                  '�Էµ� ������ �����մϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'Y'                 " ��� ��?
                                  '1'.                      " default


ENDFORM.                    " P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_CANCEL_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '��� Ȯ��'             " Ÿ��Ʋ...
                                  '����� ������ ������� ����˴ϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'N'                 " ��� ��?
                                  '2'.                      " default

  CASE ANTWORT.
    WHEN 'Y'.                                               " Yes...
      MESSAGE  S957.
      LEAVE TO SCREEN 0.  " " PROGRAM LEAVING
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_EXIT_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                          '���� �Է³����� �������� �ʽ��ϴ�.'   "
                          '���� �� �����Ͻðڽ��ϱ�?'       " MSG2
                          'Y'                         " ��� ��ư ?
                          '1'.                        " default button


ENDFORM.                    " P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_DELETE_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_DELETE_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                          '���� Document�� �����մϴ�.'
                          '�����Ͻðڽ��ϱ�?'               " MSG2
                          'N'                 " ��� ��ư ��/?
                          '1'.                " default button

ENDFORM.                    " P2000_DELETE_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_POSTING_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_POSTING_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'
                                  '����� ������ ������ ����˴ϴ�.'
                                  '�����Ͻðڽ��ϱ�?'
                                  'N'
                                  '1'.

ENDFORM.                    " P2000_POSTING_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_FI_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_FI_CANCEL_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '������� Ȯ��'
                                  '����� ������ ���а��� �����մϴ�.'
                                  '�����Ͻðڽ��ϱ�?'
                                  'N'
                                  '1'.

ENDFORM.                    " P2000_FI_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_DDLC_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_DDLC_PROCESS.

  ASSIGN (F)  TO    <FS_F>.

  CASE F.
     WHEN 'ZTCCHD-LIFNR'.
         PERFORM   P2000_VENDOR_DISPLAY USING ZTCCHD-LIFNR
                                              '����ó'.
     WHEN 'ZTCCHD-BELNR1'.
         PERFORM P2000_DISPLAY_DOCUMEMT USING ZTCCHD-BELNR1
                                              ZTCCHD-GJAHR1
                                              ZTCCHD-BUKRS.
     WHEN 'ZTCCHD-BELNR2'.
        PERFORM P2000_DISPLAY_DOCUMEMT USING ZTCCHD-BELNR2
                                              ZTCCHD-GJAHR2
                                              ZTCCHD-BUKRS.
     WHEN 'ZTCCHD-ZFCCAN'.
        PERFORM  P2000_FI_DOCUMENT_DISPLAY
                           USING   ZTCCHD-BUKRS
                                   ZTCCHD-ZFFYCC
                                   ZTCCHD-ZFCCAN.
     WHEN 'ZTCCHD-ZFVTAN'.
        PERFORM  P2000_FI_DOCUMENT_DISPLAY
                           USING   ZTCCHD-BUKRS
                                   ZTCCHD-ZFFYVT
                                   ZTCCHD-ZFVTAN.
     WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " P2000_DDLC_PROCESS
*&---------------------------------------------------------------------*
*&      Form  P2000_VENDOR_DISPLAY
*&---------------------------------------------------------------------*
FORM P2000_VENDOR_DISPLAY USING    P_VENDOR_CODE
                                   P_TEXT.
  IF P_VENDOR_CODE IS INITIAL.
      MESSAGE S167 WITH P_TEXT.   EXIT.
  ENDIF.
* ȭ�� PARAMETER ID
*  SET PARAMETER ID 'KDY' FIELD '/320/310/130/120/110'.
  SET PARAMETER ID 'KDY' FIELD '/110/120/130'.
  SET PARAMETER ID 'LIF' FIELD P_VENDOR_CODE.
  SET PARAMETER ID 'EKO' FIELD ''.
*   EXPORT 'LIF'   TO MEMORY ID 'LIF'.
*   EXPORT 'EKO'   TO MEMORY ID 'EKO'.

  CALL TRANSACTION 'MK03' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_VENDOR_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_INIT_SCREEN
*&---------------------------------------------------------------------*
FORM P2000_SET_INIT_SCREEN.

  W_OK_CODE = OK-CODE.
  ANTWORT = 'N'.

  IF W_EDIT_CHECK EQ 'Y'.
     IF NOT ( W_STATUS EQ C_REQ_D ).
        PERFORM P2000_SET_MESSAGE USING  'ANZG'.
        CASE ANTWORT.
           WHEN 'Y'.              " Yes...
              PERFORM  P3000_DB_MODIFY_SCRCOM.
              IF W_EDIT_CHECK NE 'Y'.
                 MESSAGE S211.
              ENDIF.

              CLEAR OK-CODE.
           WHEN 'N'.              " No...
              MESSAGE  S957.
              CLEAR OK-CODE.
           WHEN OTHERS.
              EXIT.
        ENDCASE.
     ENDIF.
  ELSE.
     MESSAGE S211.
  ENDIF.
* LEAVE TO TRANSACTION
  PERFORM   P2000_SET_TRANSACTION.

ENDFORM.                    " P2000_SET_INIT_SCREEN
*&---------------------------------------------------------------------*
*&      Form  P3000_DB_MODIFY_SCRCOM
*&---------------------------------------------------------------------*
FORM P3000_DB_MODIFY_SCRCOM.

  CASE SY-TCODE.
      WHEN 'ZIMC5' OR 'ZIMC6' OR 'ZIMC7'.
         PERFORM P3000_CHARGE_DOC_MODIFY.
      WHEN OTHERS.
   ENDCASE.

ENDFORM.                    " P3000_DB_MODIFY_SCRCOM
*&---------------------------------------------------------------------*
*&      Form  P3000_CHARGE_DOC_MODIFY
*&---------------------------------------------------------------------*
FORM P3000_CHARGE_DOC_MODIFY.

  IF RF05A-AZSAL NE 0 AND W_OK_CODE NE 'DELE'.
        MESSAGE W592.   EXIT.
  ENDIF.
  IF RF05A-AZHAB NE 0 AND W_OK_CODE NE 'DELE'.
        MESSAGE W592.   EXIT.
  ENDIF.

*-----------------------------------------------------------------------
* internal Table Append (  )
*-----------------------------------------------------------------------
  REFRESH: IT_ZSBSEGC,IT_ZSBSEGV.
  LOOP AT IT_ZSCCIT.
*>> ����.
    IF W_STATUS NE C_REQ_C.
       MOVE: ZTCCHD-BELNR2     TO IT_ZSBSEGV-BELNR, " �����.
             ZTCCHD-GJAHR2     TO IT_ZSBSEGV-GJAHR.
    ELSE.
        MOVE ZTCCHD-GJAHR      TO IT_ZSBSEGV-GJAHR.
    ENDIF.
    PERFORM P2000_ITEMDATA_MOVE_CC.

*>> �ΰ���.
    IF W_STATUS NE C_REQ_C.
        MOVE: ZTCCHD-BELNR2     TO IT_ZSBSEGV-BELNR, " �����.
              ZTCCHD-GJAHR2     TO IT_ZSBSEGV-GJAHR.
    ELSE.
        MOVE ZTCCHD-GJAHR      TO IT_ZSBSEGV-GJAHR.
    ENDIF.
    PERFORM P2000_ITEMDATA_MOVE_VT.

  ENDLOOP.
*-----------------------------------------------------------------------
* ����
*-----------------------------------------------------------------------
  REFRESH IT_ZSBSEGC_OLD.
  CLEAR: ZTBKPF,*ZTBKPF.
*>> OLD �� MOVE.
  IF W_STATUS EQ C_REQ_C.
     CLEAR ZTBKPF.
  ELSE.
     PERFORM P2000_RESELECT_ZTBKPF_CC.
  ENDIF.
  PERFORM P2000_MOVE_DATA_ZTCCHD_CC.

  CALL FUNCTION 'ZIM_CHARGE_DOCUMENT_MODIFY'
    EXPORTING
             W_OK_CODE           =   W_OK_CODE
             BUKRS               =   ZTBKPF-BUKRS
             GJAHR               =   ZTBKPF-GJAHR
             ZFSTATUS            =   W_STATUS
             W_ZTBKPF_OLD        =  *ZTBKPF
             W_ZTBKPF            =   ZTBKPF
    TABLES
             IT_ZSBSEG_OLD       =   IT_ZSBSEGC_OLD
             IT_ZSBSEG           =   IT_ZSBSEGC
*            IT_ZSBDIV           =  IT_ZSBDIV
*            IT_ZSBHIS           =  IT_ZSBHIS
    CHANGING
             BELNR               =   ZTBKPF-BELNR
    EXCEPTIONS
             ERROR_UPDATE.

  IF SY-SUBRC EQ 0.
*>> ��ǥ��ȣ MOVE
    MOVE: ZTBKPF-BELNR   TO ZTCCHD-BELNR1,
*         ZTBKPF-ZFFIYR  TO ZTCCHD-ZFFYCC,
          ZTBKPF-GJAHR   TO ZTCCHD-GJAHR1.
  ELSE.
*     DELETE FROM ZTBKPF
*       WHERE BELNR = ZTCCHD-BELNR1
*        AND  GJAHR = ZTCCHD-GJAHR1
*        AND  BUKRS = ZTCCHD-BUKRS.
*     UPDATE ZTBKPF.
     ROLLBACK WORK.
     MESSAGE S208.
     EXIT.
  ENDIF.
*-----------------------------------------------------------------------
* �ΰ���
*-----------------------------------------------------------------------
*>> OLD �� MOVE.
  REFRESH IT_ZSBSEGV_OLD.
  CLEAR: ZTBKPF,*ZTBKPF,IT_ZSBSEGV.
  IF W_STATUS EQ C_REQ_C.
     CLEAR : ZTBKPF.
  ELSE.
    PERFORM P2000_RESELECT_ZTBKPF_VT.
  ENDIF.
  PERFORM P2000_MOVE_DATA_ZTCCHD_VT.

  CALL FUNCTION 'ZIM_CHARGE_DOCUMENT_MODIFY'
     EXPORTING
             W_OK_CODE           =   W_OK_CODE
             BUKRS               =   ZTBKPF-BUKRS
             GJAHR               =   ZTBKPF-GJAHR
             ZFSTATUS            =   W_STATUS
             W_ZTBKPF_OLD        =  *ZTBKPF
             W_ZTBKPF            =   ZTBKPF
     TABLES
             IT_ZSBSEG_OLD       =   IT_ZSBSEGV_OLD
             IT_ZSBSEG           =   IT_ZSBSEGV
*            IT_ZSBDIV           =   IT_ZSBDIV
*            IT_ZSBHIS           =   IT_ZSBHIS
    CHANGING
             BELNR               =   ZTBKPF-BELNR
    EXCEPTIONS
             ERROR_UPDATE.

  IF SY-SUBRC EQ 0.
*>> ��ǥ��ȣ MOVE
    MOVE: ZTBKPF-BELNR   TO ZTCCHD-BELNR2,
          ZTBKPF-GJAHR   TO ZTCCHD-GJAHR2.
  ELSE.
*     DELETE FROM ZTBKPF
*       WHERE BELNR = ZTCCHD-BELNR2
*        AND  GJAHR = ZTCCHD-GJAHR2
*        AND  BUKRS = ZTCCHD-BUKRS.
*     UPDATE ZTBKPF.
     ROLLBACK WORK.
     MESSAGE S208.
     EXIT.
  ENDIF.

*>>> ���������� �������� ���./...../.

*-----------------------------------------------------------------------
*> ���� �ΰ��� Header Data Move.
*-----------------------------------------------------------------------
 CALL FUNCTION 'ZIM_CCCOST_DOCUMENT_MODIFY'
    EXPORTING
             W_OK_CODE           =   W_OK_CODE
             ZFCCNO              =   ZTCCHD-ZFCCNO
             ZFSTATUS            =   W_STATUS
             W_ZTCCHD_OLD        =  *ZTCCHD
             W_ZTCCHD            =   ZTCCHD
    TABLES
             IT_ZSCCIT_OLD       =   IT_ZSCCIT_OLD
             IT_ZSCCIT           =   IT_ZSCCIT
             IT_ZSBDIV           =   IT_ZSBDIV
             IT_ZSBHIS           =   IT_ZSBHIS
    CHANGING
             W_ZFCCNO            =   ZTCCHD-ZFCCNO
    EXCEPTIONS
             ERROR_UPDATE.

  IF SY-SUBRC EQ 0.
     COMMIT WORK.
  ELSE.
     ROLLBACK WORK.
     MESSAGE S208.
     EXIT.
  ENDIF.

  IF W_OK_CODE EQ 'DELE'.
     IF SY-SUBRC NE  0.
        MESSAGE  E313.
     ELSE.
        MESSAGE  S124 WITH  ZTCCHD-ZFCCNO ' '  'delete'.
        CASE SY-TCODE.
           WHEN 'ZIMC5'.
              PERFORM P2000_DATA_INITIALIZE.
              PERFORM   P2000_SET_CREATE_FIELD_VALUE.
           WHEN 'ZIMC6' OR 'ZIMC7'.
              SET PARAMETER ID 'ZPCCNO'    FIELD ZTCCHD-ZFCCNO.
              PERFORM P2000_DATA_INITIALIZE.
        ENDCASE.
     ENDIF.
  ELSE.
     IF SY-SUBRC NE  0.
        MESSAGE  E764.
     ELSE.
        SET PARAMETER ID 'ZPCCNO'    FIELD ZTCCHD-ZFCCNO.
        MESSAGE  S765.
        IF SY-TCODE EQ 'ZIMC5'.
*>> INITIALIZE.
           IF W_OK_CODE NE 'OPDC'.
              LEAVE TO TRANSACTION 'ZIMC7'.
           ENDIF.
        ELSEIF SY-TCODE EQ 'ZIMC6'.
           IF W_OK_CODE NE 'OPDC'.
              PERFORM   P2000_SET_LOCK_MODE USING 'U'.
              LEAVE TO TRANSACTION 'ZIMC7'.
           ENDIF.
        ELSE.
           W_EDIT_CHECK = 'N'.
        ENDIF.
     ENDIF.
  ENDIF.

ENDFORM.                    " P3000_CHARGE_DOC_MODIFY
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_TRANSACTION
*&---------------------------------------------------------------------*
FORM P2000_SET_TRANSACTION.

  CASE SY-TCODE.
    WHEN 'ZIMC5' OR 'ZIMC6' OR 'ZIMC7'.          " B/L
      CASE W_OK_CODE.
         WHEN 'OTDC'.   " OTHERS DOCUMENT
            CALL SCREEN 0010 STARTING AT 30 6
                             ENDING   AT 78 10.
         WHEN 'CRDC'.   " CREATE
            W_FIRST_SCR0100  = 'Y'.
            LEAVE TO TRANSACTION 'ZIMC5'.
         WHEN 'CHDC'.   " CHANGE
            W_FIRST_SCR0100  = 'Y'.
            LEAVE TO TRANSACTION 'ZIMC6'.
         WHEN 'DISP'.   " DISPLAY
            W_FIRST_SCR0100  = 'Y'.
            LEAVE TO TRANSACTION 'ZIMC7'.
         WHEN OTHERS.
      ENDCASE.
  ENDCASE.

ENDFORM.                    " P2000_SET_TRANSACTION
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_EXIT_PROCESS.

  IF NOT W_STATUS EQ C_REQ_D.
     PERFORM P2000_SET_MESSAGE USING  OK-CODE.
     CASE ANTWORT.
        WHEN 'Y'.              " Yes...
*-----------------------------------------------------------------------
* DB Write
*-----------------------------------------------------------------------
           PERFORM  P3000_DB_MODIFY_SCRCOM.
           CLEAR OK-CODE.
*           PERFORM  P2000_SET_LOCK_MODE USING 'U'.
*           PERFORM  P2000_SET_SCREEN_SCRCOM.
*           LEAVE SCREEN.
        WHEN 'N'.              " No...
           MESSAGE  S957.
           CLEAR OK-CODE.
           IF W_STATUS NE C_REQ_D.
              PERFORM  P2000_SET_LOCK_MODE USING 'U'.
           ENDIF.
           PERFORM  P2000_SET_SCREEN_SCRCOM.
           LEAVE SCREEN.
        WHEN 'C'.              " Cancel
        WHEN OTHERS.
     ENDCASE.

  ELSE.
     CLEAR OK-CODE.
     PERFORM  P2000_SET_SCREEN_SCRCOM.
     LEAVE SCREEN.
  ENDIF.

ENDFORM.                    " P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
FORM P2000_SET_LOCK_MODE USING    PA_MODE.

  CASE SY-TCODE.
     WHEN 'ZIMC5' OR 'ZIMC6' OR 'ZIMC7'.    " CHARGE DOC.
        PERFORM P2000_SET_CHARGE_DOC_LOCK    USING   PA_MODE.
     WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_CHARGE_DOC_LOCK
*&---------------------------------------------------------------------*
FORM P2000_SET_CHARGE_DOC_LOCK USING   PA_MODE.

   IF PA_MODE EQ 'L'.
      CALL FUNCTION 'ENQUEUE_EZ_ZTCCHD'
         EXPORTING
             ZFCCNO   =  ZTCCHD-ZFCCNO
         EXCEPTIONS
             OTHERS        = 1.

      IF SY-SUBRC <> 0.
         MESSAGE E510 WITH SY-MSGV1 'Charge Document'
                              ZTCCHD-ZFCCNO
                     RAISING DOCUMENT_LOCKED.
      ENDIF.

*      CALL FUNCTION 'ENQUEUE_EZ_IM_ZTBKPF'
*         EXPORTING
*             BUKRS         =  ZTBKPF-BUKRS
*             GJAHR         =  ZTBKPF-GJAHR
*             BELNR         =  ZTBKPF-BELNR
*         EXCEPTIONS
*             OTHERS        = 1.
*
*      IF SY-SUBRC <> 0.
*        MESSAGE E510 WITH SY-MSGV1 'Charge Document'
*                              ZTBKPF-BUKRS ZTBKPF-BELNR
*      ENDIF.

   ELSEIF PA_MODE EQ 'U'.

      CALL FUNCTION 'DEQUEUE_EZ_ZTCCHD'
         EXPORTING
             ZFCCNO   =  ZTCCHD-ZFCCNO.

*      CALL FUNCTION 'DEQUEUE_EZ_IM_ZTBKPF'
*         EXPORTING
*             BUKRS         =  ZTBKPF-BUKRS
*             GJAHR         =  ZTBKPF-GJAHR
*             BELNR         =  ZTBKPF-BELNR.

   ENDIF.

ENDFORM.                    " P2000_SET_CHARGE_DOC_LOCK
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
FORM P2000_SET_SCREEN_SCRCOM.

  LEAVE TO SCREEN 0.

ENDFORM.                    " P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_INDICATE
*&---------------------------------------------------------------------*
FORM P2000_SET_INDICATE.

  IF RF05A-AZSAL NE 0 AND OK-CODE NE 'DELE'.
     MESSAGE E592.   EXIT.
  ENDIF.
  IF RF05A-AZHAB NE 0 AND OK-CODE NE 'DELE'.
     MESSAGE E592.   EXIT.
  ENDIF.

  W_OK_CODE = OK-CODE.
  IF OK-CODE EQ 'DELE' AND ZTCCHD-ZFPOSYN EQ 'Y'.
     MESSAGE E584 WITH ZTCCHD-BUKRS ZTCCHD-ZFCCNO ZTCCHD-GJAHR.
  ENDIF.

*-----------------------------------------------------------------------
* AUTHORITY CHECK
*-----------------------------------------------------------------------
*  PERFORM P2000_AUTHORITY_CHECK USING W_OK_CODE.

*  IF W_OK_CODE NE 'DELE'.
*     IF W_EDIT_CHECK NE 'Y'.
*        MESSAGE S211.   EXIT.
*     ENDIF.
*  ENDIF.
*
  IF W_STATUS EQ C_REQ_D.
     PERFORM  P2000_SET_LOCK_MODE  USING  'L'.
  ENDIF.

* MESSAGE BOX
  PERFORM P2000_SET_MESSAGE USING  OK-CODE.

  CASE ANTWORT.
    WHEN 'Y'.                                               " Yes...
      IF W_OK_CODE EQ 'OPDC'.
         IF W_STATUS NE C_REQ_D.
            PERFORM  P3000_DB_MODIFY_SCRCOM.
         ENDIF.
         PERFORM  P3000_FI_POSTING.
      ELSEIF W_OK_CODE EQ 'CCDC'.
         PERFORM  P3000_FI_DOC_CANCEL.
      ELSEIF W_OK_CODE EQ 'DELE'.
        PERFORM  P3000_DB_MODIFY_SCRCOM.
        LEAVE TO SCREEN 0.
      ELSE.
         CLEAR OK-CODE.
         PERFORM  P2000_SET_LOCK_MODE USING 'U'.
      ENDIF.
      LEAVE SCREEN.
    WHEN OTHERS.              " No...
      PERFORM  P2000_SET_LOCK_MODE USING 'U'.
  ENDCASE.

ENDFORM.                    " P2000_SET_INDICATE
*&---------------------------------------------------------------------*
*&      Form  P3000_FI_POSTING
*&---------------------------------------------------------------------*
FORM P3000_FI_POSTING.
  REFRESH : IT_ERR_LIST, RETURN.

  DATA: L_STATUSBIT      LIKE  ZTCCHD-ZFPOSYN,
        L_STATUSBIT_OLD  LIKE  ZTCCHD-ZFPOSYN,
        INVOICEDOCNUMBER TYPE  BAPI_INCINV_FLD-INV_DOC_NO,
        FISCALYEAR       TYPE  BAPI_INCINV_FLD-FISC_YEAR.

  REFRESH : XRETURN, RETURN, IT_ERR_LIST.
  CLEAR : W_SUBRC, XRETURN, RETURN, IT_ERR_LIST.

  IF W_READ_ERROR EQ 'Y' OR
     ZTCCHD-ZFCCNO IS INITIAL.
     MESSAGE  S587.
     PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST
                                  USING   'E'.
     EXIT.
  ENDIF.

  IF ZTCCHD-ZFPOSYN EQ 'Y'.
     MESSAGE S578.
     PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST
                                  USING   'E'.
     EXIT.
  ENDIF.

*>> �������� �õ尪 �־� ����.
  *ZTCCHD = ZTCCHD.
  MOVE: ZTCCHD-ZFPOSYN TO  L_STATUSBIT,
        ZTCCHD-ZFPOSYN TO  L_STATUSBIT_OLD.

  IF L_STATUSBIT EQ 'N'. "*>>  �����ÿ���.
*> ����
     CALL FUNCTION 'ZIM_CHARGE_DOCUMENT_POST'
          EXPORTING
            BUKRS             =     ZTCCHD-BUKRS
            BELNR             =     ZTCCHD-BELNR1
            GJAHR             =     ZTCCHD-GJAHR1
         IMPORTING
            INVOICEDOCNUMBER  =     INVOICEDOCNUMBER
            FISCALYEAR        =     FISCALYEAR
         TABLES
            RETURN            =     RETURN
         EXCEPTIONS
            POST_ERROR        =     4.

     W_SUBRC = SY-SUBRC.

     IF W_SUBRC NE 0.
        ROLLBACK WORK.
        IF RETURN[] IS INITIAL.
           PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'E'.
        ELSE.
           PERFORM  P2000_MULTI_MSG_MAKE  TABLES  IT_ERR_LIST.
        ENDIF.
     ELSE.
        COMMIT WORK.
        PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'S'.
*>> ��ǥ���� �ٲٰ�.
        ZTCCHD-ZFPOSYN = '1'.
        MOVE: INVOICEDOCNUMBER TO ZTCCHD-ZFCCAN,
              FISCALYEAR       TO ZTCCHD-ZFFYCC,
              SY-UNAME         TO ZTCCHD-UNAM,
              SY-DATUM         TO ZTCCHD-UDAT,
              SY-UZEIT         TO ZTCCHD-UTME,
              ZTCCHD-ZFPOSYN   TO L_STATUSBIT.

        CLEAR: INVOICEDOCNUMBER ,FISCALYEAR.
        REFRESH : RETURN.
     ENDIF.
  ENDIF.

  IF W_SUBRC NE 0.
     DESCRIBE  TABLE IT_ERR_LIST  LINES  W_LINE.
     IF W_LINE GT 0.
        INCLUDE = 'POPU'.
        CALL SCREEN 0014 STARTING AT  05   3
                         ENDING   AT  100 12.
        CLEAR : INCLUDE.
     ENDIF.

     IF W_STATUS EQ C_REQ_D.
        PERFORM  P2000_SET_LOCK_MODE  USING  'U'.
     ELSE.
        IF SY-TCODE EQ 'ZIMC5'.
           LEAVE TO TRANSACTION 'ZIMC7'.
        ENDIF.
     ENDIF.
     EXIT.
  ENDIF.

*>>>>> �ΰ���.------------------------------------
  IF L_STATUSBIT EQ '1'. " �����ÿ���.
     REFRESH : RETURN.  CLEAR : RETURN.
      CALL FUNCTION 'ZIM_CHARGE_DOCUMENT_POST'
           EXPORTING
               BUKRS             =     ZTCCHD-BUKRS
               BELNR             =     ZTCCHD-BELNR2
               GJAHR             =     ZTCCHD-GJAHR2
           IMPORTING
*>> ������ ��ǥ ��ȣ �ް�.
               INVOICEDOCNUMBER  =   INVOICEDOCNUMBER
               FISCALYEAR        =   FISCALYEAR
           TABLES
               RETURN            =   RETURN
           EXCEPTIONS
               POST_ERROR        =     4.

      W_SUBRC = SY-SUBRC.

      IF W_SUBRC NE 0.
         ROLLBACK WORK.
         IF L_STATUSBIT_OLD NE ZTCCHD-ZFPOSYN.
            UPDATE   ZTCCHD.
* change document -----------------------------------------------------
            CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_ZTCCHD'
                 EXPORTING
                    UPD_CHNGIND    =    'U'
                    N_ZTCCHD       =    ZTCCHD
                    O_ZTCCHD       =    *ZTCCHD.
*----------------------------------------------------------------------
         ENDIF.
         IF RETURN[] IS INITIAL.
            PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'E'.
         ELSE.
            PERFORM  P2000_MULTI_MSG_MAKE  TABLES  IT_ERR_LIST.
         ENDIF.
      ELSE.
         COMMIT WORK.
*>> ��ǥ���� �ٲٰ�.
         ZTCCHD-ZFPOSYN = 'Y'.
         MOVE: INVOICEDOCNUMBER TO ZTCCHD-ZFVTAN,
               FISCALYEAR       TO ZTCCHD-ZFFYVT,
               SY-UNAME         TO ZTCCHD-UNAM,
               SY-DATUM         TO ZTCCHD-UDAT,
               SY-UZEIT         TO ZTCCHD-UTME.

         UPDATE   ZTCCHD.
         IF SY-SUBRC NE 0.
            MESSAGE S952.
         ENDIF.
* change document -----------------------------------------------------
         CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_ZTCCHD'
              EXPORTING
                 UPD_CHNGIND    =    'U'
                 N_ZTCCHD       =    ZTCCHD
                 O_ZTCCHD       =    *ZTCCHD.
*----------------------------------------------------------------------
      ENDIF.
   ENDIF.

   DESCRIBE  TABLE IT_ERR_LIST  LINES  W_LINE.
   IF W_LINE GT 0.
      INCLUDE = 'POPU'.
      CALL SCREEN 0014 STARTING AT  05   3
                       ENDING   AT  100 12.
      CLEAR : INCLUDE.
   ENDIF.

   IF W_SUBRC EQ 0.
      PERFORM  P2000_SET_LOCK_MODE  USING  'U'.
      LEAVE TO TRANSACTION 'ZIMC7'.
   ELSE.
      IF W_STATUS EQ C_REQ_D.
         PERFORM  P2000_SET_LOCK_MODE  USING  'U'.
      ELSE.
         IF SY-TCODE EQ 'ZIMC5'.
            LEAVE TO TRANSACTION 'ZIMC7'.
         ENDIF.
      ENDIF.
   ENDIF.

ENDFORM.                    " P3000_FI_POSTING
*&---------------------------------------------------------------------*
*&      Form  P3000_FI_DOC_CANCEL
*&---------------------------------------------------------------------*
FORM P3000_FI_DOC_CANCEL.

*>> �ΰ���.------------------------------------------------------------
  REFRESH : IT_ERR_LIST.

  IF W_READ_ERROR EQ 'Y' OR
     ZTCCHD-BELNR2 IS INITIAL.
     MESSAGE  S587.
     PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST
                                  USING   'E'.
     EXIT.
  ENDIF.

  IF ZTCCHD-ZFPOSYN EQ 'N'.
     MESSAGE  S588.
     PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST
                                  USING   'E'.
     EXIT.
  ENDIF.
  IF ZTCCHD-ZFPOSYN EQ 'Y'.  " �ΰ��� ��ǥ���.
     PERFORM P2000_VTCOST_CANCEL.
  ENDIF.

*>> ����----------------------------------------------------------------
  IF ZTCCHD-ZFPOSYN EQ '1'.
     PERFORM P2000_CCCOST_CANCEL.
  ENDIF.
  DESCRIBE  TABLE IT_ERR_LIST  LINES  W_LINE.
  IF W_LINE GT 0.
     INCLUDE = 'POPU'.
     CALL SCREEN 0014 STARTING AT  05   3
                       ENDING   AT  100 12.
      CLEAR : INCLUDE.
  ENDIF.
  IF W_SUBRC EQ 0.
      PERFORM  P2000_SET_LOCK_MODE  USING  'U'.
      LEAVE TO TRANSACTION SY-TCODE.
      W_FIRST_SCR0100 = 'Y'.
  ELSE.
      IF W_STATUS EQ C_REQ_D.
         PERFORM  P2000_SET_LOCK_MODE  USING  'L'.
      ENDIF.
  ENDIF.

ENDFORM.                    " P3000_FI_DOC_CANCEL
*&---------------------------------------------------------------------*
*&      Form  PERIODE_ERMITTELN
*&---------------------------------------------------------------------*
FORM PERIODE_ERMITTELN USING I_BUDAT LIKE BKPF-BUDAT
                             E_GJAHR LIKE BKPF-GJAHR
                             E_MONAT LIKE BKPF-MONAT.
  CALL FUNCTION 'FI_PERIOD_DETERMINE'
       EXPORTING
            I_BUKRS = T001-BUKRS
            I_BUDAT = I_BUDAT
            I_MONAT = E_MONAT
            I_GJAHR = E_GJAHR
       IMPORTING
            E_GJAHR = E_GJAHR
            E_MONAT = E_MONAT.

ENDFORM.                    " PERIODE_ERMITTELN
*&---------------------------------------------------------------------*
*&      Form  P2000_BALANCE_CALCULATE
*&---------------------------------------------------------------------*
FORM P2000_BALANCE_CALCULATE.

   DATA: W_ZFCCAMT LIKE ZTCCIT-ZFCCAMT,
         W_ZFCVAMT LIKE ZTCCIT-ZFCVAMT,
         W_FWBAS   LIKE ZTCCIT-FWBAS.   " ���� ǥ�ؾ�.

   LOOP AT IT_ZSCCIT.
      ADD: IT_ZSCCIT-ZFCCAMT TO W_ZFCCAMT, " ����.
           IT_ZSCCIT-ZFCVAMT TO W_ZFCVAMT, " �ΰ���.
           IT_ZSCCIT-FWBAS   TO W_FWBAS.   " ���� ǥ�ؾ�.
   ENDLOOP.

   RF05A-AZSAL = ZTCCHD-ZFCCAMT - W_ZFCCAMT.     " ����.
   RF05A-AZHAB = ( ZTCCHD-ZFCVAMT - W_ZFCVAMT ). " �ΰ���.
*>> ����.
   IF RF05A-AZSAL NE 0.
      MOVE : ICON_RED_LIGHT         TO RF05A-AMPEL,
             '�ܾ��� 0�� �ƴմϴ�.' TO TEXT_080.
   ELSE.
      MOVE : ICON_GREEN_LIGHT  TO RF05A-AMPEL.
      MOVE     '�ܾ��� 0�Դϴ�.' TO TEXT_080.
   ENDIF.
   PERFORM SET_OBJ_ICON        USING RF05A-AMPEL
                               RF05A-AMPEL TEXT_080.
*>> �ΰ���.
   IF RF05A-AZHAB NE 0.
      MOVE : ICON_RED_LIGHT         TO W_AMPEL,
             '�ܾ��� 0�� �ƴմϴ�.' TO TEXT_090.
   ELSE.
      MOVE : ICON_GREEN_LIGHT  TO W_AMPEL,
             '�ܾ��� 0�Դϴ�.' TO TEXT_090.
   ENDIF.
   PERFORM SET_OBJ_ICON        USING W_AMPEL
                               W_AMPEL TEXT_090.


ENDFORM.                    " P2000_BALANCE_CALCULATE

*&---------------------------------------------------------------------*
*&      Form  P2000_POSTING_HISTORY
*&---------------------------------------------------------------------*
FORM P2000_POSTING_HISTORY.

  REFRESH: IT_ZSBDIV,IT_ZSBHIS.
  CLEAR  : IT_ZSBHIS.
*  SELECT *
*     FROM  ZTBDIV APPENDING CORRESPONDING FIELDS OF TABLE IT_ZSBDIV
*     WHERE BUKRS = ZTCCHD-BUKRS
*       AND BELNR = ZTCCHD-BELNR1
*       AND GJAHR = ZTCCHD-GJAHR1.
*  SELECT *
*     FROM  ZTBDIV APPENDING CORRESPONDING FIELDS OF TABLE IT_ZSBDIV
*     WHERE BUKRS = ZTCCHD-BUKRS
*       AND BELNR = ZTCCHD-BELNR2
*       AND GJAHR = ZTCCHD-GJAHR2.
*
  SELECT *
     FROM  ZTBHIS INTO CORRESPONDING FIELDS OF TABLE IT_ZSBHIS
     WHERE BUKRS = ZTCCHD-BUKRS
       AND BELNR = ZTCCHD-BELNR1
       AND GJAHR = ZTCCHD-GJAHR1.
  SELECT *
     FROM  ZTBHIS APPENDING CORRESPONDING FIELDS OF TABLE IT_ZSBHIS
     WHERE BUKRS = ZTCCHD-BUKRS
       AND BELNR = ZTCCHD-BELNR2
       AND GJAHR = ZTCCHD-GJAHR2.

  DESCRIBE TABLE IT_ZSBHIS LINES W_LINE.
  IF W_LINE GT 0.
     INCLUDE = '110'.

     LEAVE TO SCREEN 0110 .

  ENDIF.

ENDFORM.                    " P2000_POSTING_HISTORY
*&---------------------------------------------------------------------*
*&      Form  P2000_HEADER_CHANGE_DOC
*&---------------------------------------------------------------------*
FORM P2000_HEADER_CHANGE_DOC.

  CASE SY-DYNNR.
     WHEN '0100'.          "> CHARGE DOC.
         OBJECTCLASS   =   'ZTCCHD'.
         OBJEKTID      =   ZTCCHD+3(10).
     WHEN OTHERS.   EXIT.
  ENDCASE.

  SUBMIT  RCS00120 WITH  OBJEKT   =   OBJECTCLASS
                   WITH  OBJEKTID =   OBJEKTID
                   AND   RETURN.

ENDFORM.                    " P2000_HEADER_CHANGE_DOC
*&---------------------------------------------------------------------*
*&      Form  P2000_SELECT_ITEM
*&---------------------------------------------------------------------*
FORM P2000_SELECT_ITEM.

   CLEAR : W_COUNT.
   LOOP AT IT_ZSCCIT WHERE ZFMARK = 'X'.
      W_TMP_TABIX = SY-TABIX.
      ADD 1   TO   W_COUNT.
      MOVE-CORRESPONDING IT_ZSCCIT  TO   ZTCCIT.
      MOVE: ZTCCHD-ZFCCNO           TO   ZTCCIT-ZFCCNO,
            IT_ZSCCIT-ZFIDRNO       TO   ZSCCIT-ZFIDRNO.
   ENDLOOP.

   CASE W_COUNT.
      WHEN 0.        MESSAGE S951. EXIT.
      WHEN 1.
      WHEN OTHERS.   MESSAGE S965. EXIT.
   ENDCASE.

ENDFORM.                    " P2000_SELECT_ITEM
*&---------------------------------------------------------------------*
*&      Form  P2000_ITEM_CHANGE_DOC
*&---------------------------------------------------------------------*
FORM P2000_ITEM_CHANGE_DOC.

  CHECK : W_COUNT EQ 1.
  CASE SY-DYNNR.
     WHEN '0100'.          "> CHARGE DOC.
         OBJECTCLASS   =   'ZTCCIT'.
         OBJEKTID      =   ZTCCIT+3(15).
     WHEN OTHERS.   EXIT.
  ENDCASE.

  SUBMIT  RCS00120 WITH  OBJEKT   =   OBJECTCLASS
                   WITH  OBJEKTID =   OBJEKTID
                   AND   RETURN.

ENDFORM.                    " P2000_ITEM_CHANGE_DOC
*&---------------------------------------------------------------------*
*&      Form  P2000_ITEM_REF_DOC_DISPLAY
*&---------------------------------------------------------------------*
FORM P2000_ITEM_REF_DOC_DISPLAY.

  CHECK : W_COUNT EQ 1.
  IF ZSCCIT-ZFIDRNO IS INITIAL.
     MESSAGE E639.
  ENDIF.
  SET PARAMETER ID 'ZPIDRNO' FIELD ZSCCIT-ZFIDRNO.
  SET PARAMETER ID 'ZPHBLNO' FIELD ' '.
  SET PARAMETER ID 'ZPBLNO'  FIELD ' '.

  CALL TRANSACTION 'ZIM76' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_ITEM_REF_DOC_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_CHARGE_DOCUMENT
*&---------------------------------------------------------------------*
FORM P1000_GET_CHARGE_DOCUMENT USING   P_MODE.

  IF SY-DYNNR EQ '0010'.
     SELECT SINGLE * INTO W_ZTCCHD FROM ZTCCHD
              WHERE ZFCCNO  EQ  ZSCCHD-ZFCCNO.

     IF SY-SUBRC NE 0.
        W_READ_ERROR = 'Y'.
        MESSAGE E597 WITH ZSCCHD-ZFCCNO.
     ENDIF.
     IF SY-TCODE EQ 'ZIMC6'.
        IF W_ZTCCHD-ZFPOSYN EQ 'Y' OR W_ZTCCHD-ZFPOSYN EQ '1'.
           W_READ_ERROR = 'Y'.
           MESSAGE E999 WITH W_ZTCCHD-ZFCCNO 'Posting' 'Change'.
        ENDIF.
     ENDIF.
  ENDIF.

  W_READ_ERROR = 'N'.
  PERFORM P2000_DATA_INITIALIZE.
  CALL FUNCTION 'ZIM_GET_CCCOST_DOCUMENT'
        EXPORTING
                    ZFCCNO          =    ZSCCHD-ZFCCNO

        IMPORTING
                    W_ZTCCHD        =    ZTCCHD
        TABLES
                    IT_ZSCCIT       =    IT_ZSCCIT
                    IT_ZSCCIT_OLD   =    IT_ZSCCIT_OLD
                    IT_ZSBDIV       =    IT_ZSBDIV
                    IT_ZSBHIS       =    IT_ZSBHIS
        EXCEPTIONS
                    NOT_FOUND               =    4
                    COMPANDYCODE_NOT_INPUT  =    6
                    DOCUMENT_NO_NOT_INPUT   =    8
                    FISC_YEAR_NOT_INPUT     =   10.

   W_SUBRC = SY-SUBRC.

   CASE W_SUBRC.
      WHEN  0.
         SET PARAMETER ID 'ZPCCNO'    FIELD ZSCCHD-ZFCCNO.

         CASE SY-TCODE.
            WHEN 'ZIMC6'.       ">������ ���.
               IF ZTCCHD-ZFPOSYN EQ 'Y'.
                  MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 999
                         WITH ZSCCHD-ZFCCNO 'posting' 'change'.

                  IF P_MODE EQ 'S'.
*>> INITIALIZE.
                     PERFORM P2000_DATA_INITIALIZE.
                     PERFORM   P2000_SET_CREATE_FIELD_VALUE.
                     W_READ_ERROR = 'Y'.
                     EXIT.
                  ENDIF.
               ENDIF.
               CALL FUNCTION 'ENQUEUE_EZ_ZTCCHD'
                    EXPORTING
                        ZFCCNO         =  ZSCCHD-ZFCCNO
                    EXCEPTIONS
                        OTHERS        = 1.

              IF SY-SUBRC <> 0.
                 MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 510
                     WITH SY-MSGV1 'Customs/VAT Document'
                                       ZSCCHD-BUKRS ZSCCHD-ZFCCNO
                                 RAISING DOCUMENT_LOCKED.
                 IF P_MODE EQ 'S'.
*>> INITIALIZE.
                     PERFORM P2000_DATA_INITIALIZE.
                     PERFORM   P2000_SET_CREATE_FIELD_VALUE.
                     W_READ_ERROR = 'Y'.
                     EXIT.
                 ENDIF.
              ENDIF.
            WHEN OTHERS.
         ENDCASE.
         PERFORM P2000_CHANGE_READ_TEXT.

      WHEN  4.
         W_READ_ERROR = 'Y'.
         MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 597
                 WITH ZSCCHD-ZFCCNO.
      WHEN  6.
         W_READ_ERROR = 'Y'.
         MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 583
                 WITH 'Company code'.
*      WHEN  8.
*         W_READ_ERROR = 'Y'.
*         MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 583
*                 WITH 'Import expense Doc No'.
      WHEN 10.
         W_READ_ERROR = 'Y'.
         MESSAGE ID 'ZIM' TYPE P_MODE NUMBER 583
                 WITH 'Fiscal year'.
      WHEN OTHERS.
   ENDCASE.

ENDFORM.                    " P1000_GET_CHARGE_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  P2000_READ_DOCUMENT
*&---------------------------------------------------------------------*
FORM P2000_READ_DOCUMENT.

  REFRESH : IT_ZSCCIT, IT_ZSBDIV, IT_ZSCCIT_OLD, IT_ZSBHIS.

ENDFORM.                    " P2000_READ_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  P2000_BELEGART_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_BELEGART_AUTHORITY_CHECK.

  CHECK T003-BRGRU NE SPACE.

  AUTHORITY-CHECK OBJECT F_BKPF_BLA
    ID 'ACTVT' FIELD ACT_HINZ
    ID 'BRGRU' FIELD T003-BRGRU.

  CHECK SY-SUBRC NE 0.
  MESSAGE E087(F5) WITH ZTCCHD-BLART.

ENDFORM.                    " P2000_BELEGART_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_CACULATION
*&---------------------------------------------------------------------*
FORM P2000_CACULATION.

   DATA: W_ZFCCAMT LIKE ZTCCIT-ZFCCAMT,
         W_ZFCVAMT LIKE ZTCCIT-ZFCVAMT,
         W_FWBAS   LIKE ZTCCIT-FWBAS.   " ���� ǥ�ؾ�.

   LOOP AT IT_ZSCCIT.
      ADD: IT_ZSCCIT-ZFCCAMT TO W_ZFCCAMT, " ����.
           IT_ZSCCIT-ZFCVAMT TO W_ZFCVAMT, " �ΰ���.
           IT_ZSCCIT-FWBAS   TO W_FWBAS.   " ���� ǥ�ؾ�.
   ENDLOOP.

  ZTCCHD-ZFCCAMT = W_ZFCCAMT. " ����.
  ZTCCHD-ZFCVAMT = W_ZFCVAMT. " �ΰ���.

ENDFORM.                    " P2000_CACULATION
*&---------------------------------------------------------------------*
*&      Form  P2000_RESELECT_ZTBKPF
*&---------------------------------------------------------------------*
FORM P2000_RESELECT_ZTBKPF_CC.

  SELECT SINGLE *
      FROM  ZTBKPF
      WHERE BELNR EQ ZTCCHD-BELNR1
      AND   GJAHR EQ ZTCCHD-GJAHR1
      AND   BUKRS EQ ZTCCHD-BUKRS.

  MOVE-CORRESPONDING ZTBKPF TO *ZTBKPF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBSEGC_OLD
           FROM ZTBSEG
           WHERE BELNR EQ ZTCCHD-BELNR1
           AND   GJAHR EQ ZTCCHD-GJAHR1
           AND   BUKRS EQ ZTCCHD-BUKRS.
  MOVE:  ZTCCHD-BELNR1   TO ZTBKPF-BELNR,
         ZTCCHD-GJAHR1   TO ZTBKPF-GJAHR,
         ZTCCHD-BUKRS    TO ZTBKPF-BUKRS.

ENDFORM.                    " P2000_RESELECT_ZTBKPF_CC.
*&---------------------------------------------------------------------*
*&      Form  P2000_RESELECT_ZTBKPF_VT
*&---------------------------------------------------------------------*
FORM P2000_RESELECT_ZTBKPF_VT.

  SELECT SINGLE *
      FROM  ZTBKPF
      WHERE BELNR EQ ZTCCHD-BELNR2
      AND   GJAHR EQ ZTCCHD-GJAHR2
      AND   BUKRS EQ ZTCCHD-BUKRS.

  MOVE-CORRESPONDING ZTBKPF TO *ZTBKPF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBSEGC_OLD
           FROM ZTBSEG
           WHERE BELNR EQ ZTCCHD-BELNR2
           AND   GJAHR EQ ZTCCHD-GJAHR2
           AND   BUKRS EQ ZTCCHD-BUKRS.

  MOVE: ZTCCHD-BELNR2   TO ZTBKPF-BELNR,
        ZTCCHD-GJAHR2   TO ZTBKPF-GJAHR,
        ZTCCHD-BUKRS    TO ZTBKPF-BUKRS.

ENDFORM.                    " P2000_RESELECT_ZTBKPF_VT
*&---------------------------------------------------------------------*
*&      Form  P2000_MOVE_DATA_ZTCCHD_CC
*&---------------------------------------------------------------------*
FORM P2000_MOVE_DATA_ZTCCHD_CC.

  MOVE-CORRESPONDING ZTCCHD TO ZTBKPF.
  READ TABLE IT_ZSBSEGC INDEX 1.
  MOVE IT_ZSBSEGC-ZFIMDNO    TO ZTBKPF-ZFIMDNO.  " ���Թ�����ȣ.
  MOVE:      'X'             TO ZTBKPF-ZFDCSTX, " DELIVERY COST.
             'Y'             TO ZTBKPF-ZFPOYN,   " ��ȯ����.
             '1'             TO ZTBKPF-KURSF,    " ȯ��.
             '006'           TO ZTBKPF-ZFCSTGRP, " ���׷�.
             SY-DATUM        TO ZTBKPF-WWERT,    " ȯ����.
             'X'             TO ZTBKPF-ZFPCUR,   " ������ȭ���⿩��.
             ZTCCHD-ZFCCAMT  TO ZTBKPF-WRBTR,    " ��ǥ��ȭ�ݾ�.
             ZTCCHD-WAERS    TO ZTBKPF-HWAER,    " ������ȭ.
             ZTCCHD-ZFCCAMT  TO ZTBKPF-DMBTR,    " ������ȭ�ݾ�.
             ZTCCHD-LIFNR    TO ZTBKPF-ZFVEN.    " ����ó(<->����ó)

ENDFORM.                    " P2000_MOVE_DATA_ZTCCHD_CC
*&---------------------------------------------------------------------*
*&      Form  P2000_MOVE_DATA_ZTCCHD_VT
*&---------------------------------------------------------------------*
FORM P2000_MOVE_DATA_ZTCCHD_VT.

  MOVE-CORRESPONDING ZTCCHD  TO ZTBKPF.
  READ TABLE IT_ZSBSEGV INDEX 1.
  MOVE IT_ZSBSEGV-ZFIMDNO    TO ZTBKPF-ZFIMDNO.  " ���Թ�����ȣ.
  MOVE:      ' '             TO ZTBKPF-ZFDCSTX,  " DELIVERY COST.
             'Y'             TO ZTBKPF-ZFPOYN,   " ��ȯ����.
             '006'           TO ZTBKPF-ZFCSTGRP, " ���׷�.
             '1'             TO ZTBKPF-KURSF,    " ȯ��.
             SY-DATUM        TO ZTBKPF-WWERT,    " ȯ����.
             'X'             TO ZTBKPF-ZFPCUR,   " ������ȭ���⿩��.
             ZTCCHD-ZFCVAMT  TO ZTBKPF-WRBTR,    " ��ǥ��ȭ�ݾ�.
             ZTCCHD-WAERS    TO ZTBKPF-HWAER,    " ������ȭ.
             ZTCCHD-ZFCVAMT  TO ZTBKPF-DMBTR,    " ������ȭ�ݾ�.
             ZTCCHD-LIFNR    TO ZTBKPF-ZFVEN.    " ����ó(<->����ó).

ENDFORM.                    " P2000_MOVE_DATA_ZTCCHD_VT
*&---------------------------------------------------------------------*
*&      Form  P2000_ITEMDATA_MOVE_VT
*&---------------------------------------------------------------------*
FORM P2000_ITEMDATA_MOVE_VT.

   SELECT SINGLE *
         FROM ZTIMIMG08
        WHERE ZFCD  EQ '003'.      " �ΰ���.
   MOVE-CORRESPONDING  IT_ZSCCIT TO IT_ZSBSEGC.
   MOVE: ZTCCHD-BUKRS      TO IT_ZSBSEGV-BUKRS,
         IT_ZSCCIT-ZFIVNO  TO IT_ZSBSEGV-ZFIMDNO,
         '006'             TO IT_ZSBSEGV-ZFCSTGRP,
         ZTIMIMG08-ZFCD1   TO IT_ZSBSEGC-ZFDCSTX,
         IT_ZSCCIT-ZFCOND2 TO IT_ZSBSEGV-COND_TYPE,
         '003'             TO IT_ZSBSEGV-ZFCD,
        IT_ZSCCIT-MWSKZ    TO IT_ZSBSEGV-MWSKZ,
         '40'              TO IT_ZSBSEGV-NEWBS,
        IT_ZSCCIT-NEWKO2   TO IT_ZSBSEGV-NEWKO,
         'S'               TO IT_ZSBSEGV-SHKZG,
        IT_ZSCCIT-ZFCVAMT  TO IT_ZSBSEGV-WRBTR,   " ��ǥ��ȭ�ݾ�.
        '0'                TO IT_ZSBSEGV-WMWST,
        IT_ZSCCIT-ZFCVAMT  TO IT_ZSBSEGV-DMBTR,   " ������ȭ�ݾ�.
        IT_ZSCCIT-FWBAS    TO IT_ZSBSEGV-FWBAS,   " ����ǥ�ؾ�.
        SY-DATUM           TO IT_ZSBSEGV-WWERT,
        '0'                TO IT_ZSBSEGV-ZFVPR,
        IT_ZSCCIT-ZFIDRNO  TO IT_ZSBSEGV-ZUONR,   " ������ȣ.
        IT_ZSCCIT-SGTXT2   TO IT_ZSBSEGV-SGTXT,   " ǰ���ؽ�Ʈ.
        ' '                TO IT_ZSBSEGV-ZFINSEQ,
        IT_ZSCCIT-ZFPOYN   TO IT_ZSBSEGV-ZFPOYN,  " ����ȯ����.
       '1'                 TO IT_ZSBSEGV-KURSF.   " ȯ��.
   APPEND IT_ZSBSEGV.

ENDFORM.                    " P2000_ITEMDATA_MOVE_VT
*&---------------------------------------------------------------------*
*&      Form  P2000_ITEMDATA_MOVE_CC
*&---------------------------------------------------------------------*
FORM P2000_ITEMDATA_MOVE_CC.

  SELECT SINGLE *
         FROM ZTIMIMG08
        WHERE ZFCD  EQ '001'.      " ����.
  MOVE-CORRESPONDING  IT_ZSCCIT TO IT_ZSBSEGC.
  MOVE: ZTCCHD-BUKRS            TO IT_ZSBSEGC-BUKRS,
        ZTCCHD-GJAHR            TO IT_ZSBSEGC-GJAHR,
        ZTCCHD-BELNR1           TO IT_ZSBSEGC-BELNR,
        IT_ZSCCIT-ZFIVNO        TO IT_ZSBSEGC-ZFIMDNO,
        '006'                   TO IT_ZSBSEGC-ZFCSTGRP,
        ZTIMIMG08-ZFCD1         TO IT_ZSBSEGC-ZFDCSTX,
        IT_ZSCCIT-ZFCOND1       TO IT_ZSBSEGC-COND_TYPE,
        '001'                   TO IT_ZSBSEGC-ZFCD,
        IT_ZSCCIT-MWSKZ         TO IT_ZSBSEGC-MWSKZ,
        '40'                    TO IT_ZSBSEGC-NEWBS,
        IT_ZSCCIT-NEWKO1        TO IT_ZSBSEGC-NEWKO,
        'S'                     TO IT_ZSBSEGC-SHKZG,
        IT_ZSCCIT-ZFCCAMT       TO IT_ZSBSEGC-WRBTR,   " ��ǥ��ȭ�ݾ�.
        '0'                     TO IT_ZSBSEGC-WMWST,
        IT_ZSCCIT-ZFCCAMT       TO IT_ZSBSEGC-DMBTR,   " ������ȭ�ݾ�.
        SY-DATUM                TO IT_ZSBSEGC-WWERT,
        '0'                     TO IT_ZSBSEGC-ZFVPR,
        IT_ZSCCIT-ZFIDRNO       TO IT_ZSBSEGC-ZUONR,   " ������ȣ.
        IT_ZSCCIT-SGTXT1        TO IT_ZSBSEGC-SGTXT,   " ǰ���ؽ�Ʈ.
        ' '                     TO IT_ZSBSEGC-ZFINSEQ,
        IT_ZSCCIT-ZFPOYN        TO IT_ZSBSEGC-ZFPOYN,  " ����ȯ����.
        '1'                     TO IT_ZSBSEGC-KURSF.   " ȯ��.
  APPEND IT_ZSBSEGC.

ENDFORM.                    " P2000_ITEMDATA_MOVE_CC
*&---------------------------------------------------------------------*
*&      Form  P2000_DISPLAY_DOCUMEMT
*&---------------------------------------------------------------------*
FORM P2000_DISPLAY_DOCUMEMT USING   P_BELNR  P_GJAHR P_BUKRS.

  SET PARAMETER ID 'ZPBENR' FIELD P_BELNR.
  SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
  SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
  CALL TRANSACTION 'ZIMY3' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_DISPLAY_DOCUMEMT
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZFIVNO_HELP
*&---------------------------------------------------------------------*
FORM P1000_GET_ZFIVNO_HELP USING  ZSCCIT-ZFIVNO.

   CLEAR : ZSCCIT-ZFIVNO.
   SPOP-TITEL = '�����û��ȣ HELP'.
   OPTION = '1'.
   CALL SCREEN 0050 STARTING AT 20 6
                    ENDING   AT 75 10.

   IF ANTWORT EQ 'Y'.
      IF W_STATUS NE C_REQ_D.
         ZSCCIT-ZFIVNO = ZSIV-ZFIVNO.
      ENDIF.
   ENDIF.

ENDFORM.                    " P1000_GET_ZFIVNO_HELP
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_DOC_SELECT
*&---------------------------------------------------------------------*
FORM P2000_MULTI_DOC_SELECT.

  TABLES INDX.

  DATA: INDXKEY  LIKE INDX-SRTFD VALUE 'ZKEYVALUE',
        INDXKEY1 LIKE INDX-SRTFD VALUE 'ZKEYVALUE1',
        WA_INDX  TYPE INDX.

*>>> MEMOFY ID SET
  EXPORT ZFCSTGRP = '006'
         TO DATABASE INDX(ST)  FROM WA_INDX ID INDXKEY.

*>> ���� ���� ���� ���α׷� CALL.
  SUBMIT ZRIMCSTDOC VIA SELECTION-SCREEN
                    AND RETURN.

*>>> MEMOFY ID GET
  IMPORT IT_ZFIMDNO = IT_ZFIMDNO
         FROM DATABASE INDX(ST)  ID INDXKEY1 TO WA_INDX.
  FREE MEMORY ID INDXKEY1.

*>> ���� ������ ROW GET
  DESCRIBE TABLE IT_ZSCCIT LINES W_LINE.
  IF W_LINE GT 0.
     READ TABLE IT_ZSCCIT INDEX W_LINE.
  ELSE.
     CLEAR : IT_ZSCCIT.
  ENDIF.

*>> �ش� �� SET.
  CLEAR W_COUNT.
  LOOP AT IT_ZFIMDNO.
    CLEAR IT_ZSCCIT.
    MOVE-CORRESPONDING IT_ZFIMDNO TO IT_ZSCCIT.
    MOVE '����'                   TO  IT_ZSCCIT-SGTXT1.
    MOVE '�ΰ���'                 TO  IT_ZSCCIT-SGTXT2.
    MOVE: IT_ZFIMDNO-ZFIMDNO   TO IT_ZSCCIT-ZFIVNO,
           IT_ZFIMDNO-ZUONR    TO IT_ZSCCIT-ZFIDRNO,
           IT_ZFIMDNO-ZFPOYN   TO IT_ZSCCIT-ZFPOYN.
    MOVE : ZTCCHD-MWSKZ        TO IT_ZSCCIT-MWSKZ,
            SY-DATUM           TO IT_ZSCCIT-WWERT,
            '1'                TO IT_ZSCCIT-KURSF.

    CLEAR: W_ZFBLNO,ZTIV,ZTCUCLIV.
    SELECT SINGLE *
      FROM ZTIV
     WHERE ZFIVNO = IT_ZSCCIT-ZFIVNO.

    IF SY-SUBRC NE 0.    " ���� ����ϰ��.
       SELECT SINGLE *
         FROM ZTCUCLIV
        WHERE ZFIVNO = IT_ZSCCIT-ZFIVNO.

       IF SY-SUBRC NE 0. " �Ѵ� ���� ��츸 ��������.
           CONTINUE.
       ELSE.
           MOVE ZTCUCLIV-ZFBLNO TO W_ZFBLNO.
       ENDIF.
    ELSE.
       IF ZTIV-ZFREQTY EQ 'LO' OR ZTIV-ZFREQTY EQ  'PU'.
          MESSAGE W989 WITH ZTIV-ZFREQTY.
       ENDIF.
       MOVE ZTIV-ZFBLNO TO W_ZFBLNO.
       SELECT SINGLE *
          FROM ZTCUCLIV
         WHERE ZFIVNO = IT_ZSCCIT-ZFIVNO.
    ENDIF.


*>> ����� �ΰ���/�����ݾ�.
*    CLEAR ZTCUCL.
*    SELECT SINGLE *
*      FROM ZTCUCL
*     WHERE ZFBLNO   EQ ZTCUCLIV-ZFBLNO
*       AND ZFCLSEQ  EQ ZTCUCLIV-ZFCLSEQ.
*    IF SY-SUBRC EQ 0.
*       IF ZTCUCL-ZFCUST EQ 'N'. " ����Ұ���.
*          CONTINUE.
*       ENDIF.
*    ENDIF.

    SELECT SINGLE *
         FROM ZTIDS
        WHERE ZFBLNO   EQ ZTCUCLIV-ZFBLNO
          AND ZFCLSEQ  EQ ZTCUCLIV-ZFCLSEQ.
    IF SY-SUBRC NE 0.
       CLEAR: ZTIDS-ZFCUAMTS,ZTIDS-ZFVAAMTS,ZTIDS-ZFTBAK.
    ELSE.
       MOVE: ZTIDS-ZFCUAMTS TO IT_ZSCCIT-ZFCCAMT,
             ZTIDS-ZFVAAMTS TO IT_ZSCCIT-ZFCVAMT,
             ZTIDS-ZFTBAK   TO IT_ZSCCIT-FWBAS.   " ���� ���� ��ȭ.
    ENDIF.
    PERFORM P2000_GETDATA_IMG.                 " IMG SETTING ����.
    ADD 1 TO W_COUNT.
    APPEND IT_ZSCCIT.

  ENDLOOP.

  DESCRIBE TABLE IT_ZFIMDNO LINES LINE.
  W_LINE =  LINE - W_COUNT.

  IF W_COUNT NE LINE.
     MESSAGE I636 WITH W_LINE.
  ENDIF.
  IF W_COUNT EQ 0.
     MESSAGE S629.EXIT.
  ENDIF.

ENDFORM.                    " P2000_MULTI_DOC_SELECT
*&---------------------------------------------------------------------*
*&      Form  P2000_GETDATA_IMG
*&---------------------------------------------------------------------*
FORM P2000_GETDATA_IMG.

  SELECT SINGLE *
         FROM ZTIMIMG11
         WHERE BUKRS =  ZTCCHD-BUKRS.
  IF IT_ZSCCIT-NEWKO2 IS INITIAL.
     MOVE ZTIMIMG11-ZFIOCAC6 TO IT_ZSCCIT-NEWKO2. " �ΰ��� �����ڵ�.
  ENDIF.
  SELECT SINGLE *
         FROM ZTBL
         WHERE ZFBLNO = W_ZFBLNO.
  MOVE ZTBL-ZFPOYN TO IT_ZSCCIT-ZFPOYN.
  CASE ZTBL-ZFPOYN.
     WHEN  'Y'.
       IF IT_ZSCCIT-NEWKO1 IS INITIAL.
          MOVE ZTIMIMG11-ZFIOCAC8 TO IT_ZSCCIT-NEWKO1. " ����(��ȯ)
       ENDIF.
     WHEN  'N'.
       IF IT_ZSCCIT-NEWKO1 IS INITIAL.
          MOVE ZTIMIMG11-ZFIOCAC9 TO IT_ZSCCIT-NEWKO1. " ����(��ȯ)
       ENDIF.
     WHEN OTHERS.
  ENDCASE.
*>> �������� ������ ����.
  SELECT SINGLE *
         FROM ZTIMIMG08
        WHERE ZFCD  EQ '001'.      " ����.
  IF ZTBL-ZFPOYN EQ 'Y'.
     IF IT_ZSCCIT-ZFCOND1 IS INITIAL.
        MOVE ZTIMIMG08-COND_TYPE TO IT_ZSCCIT-ZFCOND1.
     ENDIF.
  ENDIF.
  SELECT SINGLE *
         FROM ZTIMIMG08
        WHERE ZFCD  EQ '003'.      " �ΰ���.
  IF ZTBL-ZFPOYN EQ 'Y'.           " ���ѿ���.
     IF IT_ZSCCIT-ZFCOND2 IS INITIAL.
        MOVE ZTIMIMG08-COND_TYPE TO IT_ZSCCIT-ZFCOND2.
     ENDIF.
  ENDIF.

ENDFORM.                    " P2000_GETDATA_IMG
*&---------------------------------------------------------------------*
*&      Form  P2000_CHECK_AMT
*&---------------------------------------------------------------------*
FORM P2000_CHECK_AMT.

  IF IT_ZSCCIT-FWBAS NE SPACE AND IT_ZSCCIT-ZFCVAMT NE SPACE.
*>> TO AMOUNT EXTERNAL FORMAT..
     PERFORM SET_CURR_CONV_TO_EXTERNAL(SAPMZIM01)
             USING IT_ZSCCIT-FWBAS
                   'KRW'
                   W_FWBAS.
     W_ZFCVAMT = W_FWBAS / 10.          "> �ΰ��� = ����ǥ�ؾ� * 10% .
     W_AMT_TMP = W_ZFCVAMT MOD 10.      "> 10���� ������ �ݾ�(2)
     W_ZFCVAMT = W_ZFCVAMT - W_AMT_TMP. "> �ΰ��� = �ΰ��� - (2).
     PERFORM SET_CURR_CONV_TO_INTERNAL(SAPMZIM01)
             USING W_ZFCVAMT 'KRW'.

     IF IT_ZSCCIT-ZFCVAMT  NE W_ZFCVAMT.
       MESSAGE W977 WITH
               'Amount difference with taxable standard expense rate'.
     ENDIF.
  ENDIF.

ENDFORM.                    " P2000_CHECK_AMT
*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST  STRUCTURE IT_ERR_LIST
                         USING   P_MSGTY.

   MOVE : P_MSGTY             TO     IT_ERR_LIST-MSGTYP,
          SY-MSGID            TO     IT_ERR_LIST-MSGID,
          SY-MSGNO            TO     IT_ERR_LIST-MSGNR,
          SY-MSGV1            TO     IT_ERR_LIST-MSGV1,
          SY-MSGV2            TO     IT_ERR_LIST-MSGV2,
          SY-MSGV3            TO     IT_ERR_LIST-MSGV3,
          SY-MSGV4            TO     IT_ERR_LIST-MSGV4.
*          IT_SELECTED-BELNR   TO     IT_ERR_LIST-BELNR,
*          IT_SELECTED-GJAHR   TO     IT_ERR_LIST-GJAHR.

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
      WHEN 'E' OR 'A'.
         MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
      WHEN 'I'.
         MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'S'.
         MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'W'.
         MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
   ENDCASE.

   APPEND  IT_ERR_LIST.

ENDFORM.                    " P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_MSG_MAKE
*&---------------------------------------------------------------------*
FORM P2000_MULTI_MSG_MAKE TABLES   IT_ERR_LIST STRUCTURE IT_ERR_LIST.

   LOOP AT  RETURN.

      MOVE : RETURN-TYPE         TO     IT_ERR_LIST-MSGTYP,
             RETURN-ID           TO     IT_ERR_LIST-MSGID,
             RETURN-NUMBER       TO     IT_ERR_LIST-MSGNR,
             RETURN-MESSAGE_V1   TO     IT_ERR_LIST-MSGV1,
             RETURN-MESSAGE_V2   TO     IT_ERR_LIST-MSGV2,
             RETURN-MESSAGE_V3   TO     IT_ERR_LIST-MSGV3,
             RETURN-MESSAGE_V4   TO     IT_ERR_LIST-MSGV4,
             RETURN-MESSAGE      TO     IT_ERR_LIST-MESSTXT.
*             IT_SELECTED-GJAHR   TO     IT_ERR_LIST-GJAHR,
*             IT_SELECTED-BELNR   TO     IT_ERR_LIST-BELNR.

      CASE IT_ERR_LIST-MSGTYP.
         WHEN 'E' OR 'A'.
            MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
         WHEN 'I'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'S'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'W'.
            MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
      ENDCASE.

      APPEND  IT_ERR_LIST.

   ENDLOOP.

ENDFORM.                    " P2000_MULTI_MSG_MAKE





*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   CASE SY-UCOMM.
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

      WHEN 'FB03'.
         IF NOT IT_ZSBHIS IS INITIAL.
            PERFORM P2000_FI_DOCUMENT_DISPLAY USING IT_ZSBHIS-BUKRS
                                                    IT_ZSBHIS-ZFGJAHR
                                                    IT_ZSBHIS-ZFBELNR.
         ENDIF.
     WHEN 'COCD'. " ��빮��.
         IF NOT IT_ZSBHIS IS INITIAL.
           PERFORM P2000_DISPLAY_DOCUMEMT USING IT_ZSBHIS-BELNR
                                                IT_ZSBHIS-GJAHR
                                                IT_ZSBHIS-BUKRS.
         ENDIF.

   ENDCASE.
   CLEAR : IT_ZSBHIS.

*-----------------------------------------------------------------------
*&   Event AT LINE-SELECTION
*-----------------------------------------------------------------------
AT LINE-SELECTION.
   CASE INCLUDE.
      WHEN 'POPU'.
         IF NOT IT_ERR_LIST-MSGTYP IS INITIAL.
*            MESSAGE ID IT_ERR_LIST-MSGID TYPE IT_ERR_LIST-MSGTYP
            MESSAGE ID IT_ERR_LIST-MSGID TYPE 'I'
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
*&      Form  P2000_VTCOST_CANCEL
*&---------------------------------------------------------------------*
FORM P2000_VTCOST_CANCEL.

  CALL FUNCTION 'ZIM_BAPI_COST_INVOICES_CANCEL'
       EXPORTING
          P_ZFIMDTY        =     'CS'
          P_BUKRS          =     ZTCCHD-BUKRS
          INVOICEDOCNUMBER =     ZTCCHD-ZFVTAN " �ΰ�����ǥ��ȣ.
          FISCALYEAR       =     ZTCCHD-ZFFYVT " �ΰ�����ǥ����.
          REASONREVERSAL   =     UF05A-STGRD
          POSTINGDATE      =     BSIS-BUDAT
*      IMPORTING
*         INVOICEDOCNUMBER =     ZFVTAN
*         FISCALYEAR       =     ZFFYVT
       TABLES
          RETURN           =     RETURN
       EXCEPTIONS
          LIV_ERROR        =     4.

  W_SUBRC = SY-SUBRC.

  IF SY-SUBRC NE 0.           ">> ���� �߻���...
      IF RETURN[] IS INITIAL.
         PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'E'.
      ELSE.
         PERFORM  P2000_MULTI_MSG_MAKE  TABLES  IT_ERR_LIST.
      ENDIF.
  ELSE.
      PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'S'.
      CLEAR: ZTCCHD-ZFVTAN,ZTCCHD-ZFFYVT.
      MOVE: SY-UNAME         TO ZTCCHD-UNAM,
            '1'              TO ZTCCHD-ZFPOSYN,
            SY-DATUM         TO ZTCCHD-UDAT,
            SY-UZEIT         TO ZTCCHD-UTME.

      REFRESH : RETURN.

  ENDIF.

ENDFORM.                    " P2000_VTCOST_CANCEL
*&---------------------------------------------------------------------*
*&      Form  P2000_CCCOST_CANCEL
*&---------------------------------------------------------------------*
FORM P2000_CCCOST_CANCEL.

  REFRESH :RETURN.

*>> AP POSTING FUNCTION CALL
  CALL FUNCTION 'ZIM_BAPI_COST_INVOICES_CANCEL'
       EXPORTING
          P_ZFIMDTY        =     'CS'
          P_BUKRS          =     ZTCCHD-BUKRS
          INVOICEDOCNUMBER =     ZTCCHD-ZFCCAN    " ������ǥ��ȣ.
          FISCALYEAR       =     ZTCCHD-ZFFYCC    " ������ǥ����.
          REASONREVERSAL   =     UF05A-STGRD
          POSTINGDATE      =     BSIS-BUDAT
*       IMPORTING
*          INVOICEDOCNUMBER =     ZFVTAN
*          FISCALYEAR       =     ZFFYVT
       TABLES
          RETURN           =     RETURN
       EXCEPTIONS
          LIV_ERROR        =     4.

  W_SUBRC = SY-SUBRC.

  IF SY-SUBRC NE 0.           ">> ���� �߻���...
         UPDATE   ZTCCHD.
* change document -----------------------------------------------------
         CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_ZTCCHD'
              EXPORTING
                 UPD_CHNGIND    =    'U'
                 N_ZTCCHD       =    ZTCCHD
                 O_ZTCCHD       =    *ZTCCHD.
*----------------------------------------------------------------------

      IF RETURN[] IS INITIAL.
         PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'E'.
      ELSE.
         PERFORM  P2000_MULTI_MSG_MAKE  TABLES  IT_ERR_LIST.
      ENDIF.
   ELSE.
      CLEAR: ZTCCHD-ZFCCAN,ZTCCHD-ZFFYCC.
      ZTCCHD-ZFPOSYN = 'N'.
      MOVE: SY-UNAME         TO ZTCCHD-UNAM,
            SY-DATUM         TO ZTCCHD-UDAT,
            SY-UZEIT         TO ZTCCHD-UTME.
      UPDATE ZTCCHD.
      PERFORM  P2000_MESSAGE_MAKE TABLES IT_ERR_LIST USING 'S'.
  ENDIF.

ENDFORM.                    " P2000_CCCOST_CANCEL
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  ULINE AT /1(90).
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,(04) '����',
            SY-VLINE,(10) '������',
            SY-VLINE,(05) '��/��',
            SY-VLINE,(04) '����',
            SY-VLINE,(10) '��ǥ��ȣ',
            SY-VLINE,(01) 'D',
            SY-VLINE,(08) '������ ',
            SY-VLINE,(10) '���� ',
            SY-VLINE,(10) '�ð�',SY-VLINE.
  ULINE AT /1(90).

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  IF W_MOD EQ 0.
     FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ELSE.
     FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
  WRITE:/  SY-VLINE,(04) IT_ZSBHIS-ZFPSTSQ,
           SY-VLINE,(10) IT_ZSBHIS-BUDAT,
           SY-VLINE,(05) IT_ZSBHIS-SHKZG,
           SY-VLINE,(04) IT_ZSBHIS-ZFGJAHR,
           SY-VLINE,(10) IT_ZSBHIS-ZFBELNR,
           SY-VLINE,(01) IT_ZSBHIS-ZFDCSTX,
           SY-VLINE,(08) IT_ZSBHIS-ERNAM,
           SY-VLINE,(10) IT_ZSBHIS-CDAT,
           SY-VLINE,(10) IT_ZSBHIS-CTME, SY-VLINE.
* Hide
*   MOVE SY-TABIX  TO W_LIST_INDEX1.
   HIDE: IT_ZSBHIS.

*   HIDE:  IT_ZSBHISCC-BUKRS,IT_ZSBHISCC-BELNR,IT_ZSBHISCC-GJAHR.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_FI_DOCUMENT_DISPLAY
*&---------------------------------------------------------------------*
FORM P2000_FI_DOCUMENT_DISPLAY USING   P_BUKRS
                                       P_GJAHR
                                       P_BELNR.

  IF P_BELNR IS INITIAL.
      MESSAGE S589.   EXIT.
  ELSE.
*>>> LIV ��ǥ��ȣ����, ȸ����ǥ������ ����.
      SELECT * FROM EKBZ UP TO 1 ROWS
               WHERE BELNR EQ P_BELNR
               AND   GJAHR EQ P_GJAHR.
      ENDSELECT.
      IF SY-SUBRC NE 0.
         SELECT * FROM EKBE UP TO 1 ROWS
                  WHERE BELNR EQ P_BELNR
                  AND   GJAHR EQ P_GJAHR.
         ENDSELECT.
      ENDIF.
      IF SY-SUBRC EQ 0.
         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
         SET PARAMETER ID 'RBN'    FIELD P_BELNR.
         CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
      ELSE.
         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
         SET PARAMETER ID 'BLN'    FIELD P_BELNR.
         CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
      ENDIF.
  ENDIF.

ENDFORM.                    " P2000_CCFI_DOCUMENT_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION_CC.

  DATA:  INDEX     TYPE P,
         BUKRS     LIKE ZSBHIS-BUKRS,
         GJAHR   LIKE ZSBHIS-ZFGJAHR,
         BELNR   LIKE ZSBHIS-ZFBELNR.

   REFRESH IT_SELECTED. CLEAR IT_SELECTED.

   MOVE : W_LIST_INDEX1       TO INDEX,
          IT_ZSBHISCC-BUKRS   TO BUKRS,
          IT_ZSBHISCC-ZFGJAHR TO GJAHR,
          IT_ZSBHISCC-ZFBELNR TO BELNR.
   IF INDEX GT 0.
      MOVE : BUKRS   TO IT_SELECTED-BUKRS,
             GJAHR   TO IT_SELECTED-ZFGJAHR,
             BELNR   TO IT_SELECTED-ZFBELNR.
      APPEND IT_SELECTED.
   ELSE.
      MESSAGE S962.
      EXIT.
   ENDIF.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_CHANGE_READ_TEXT
*&---------------------------------------------------------------------*
FORM P2000_CHANGE_READ_TEXT.

  W_EDIT_CHECK = 'N'.

*> �ŷ�ó �ڵ�.
  IF ZTCCHD-LIFNR IS INITIAL.
  CLEAR : *LFA1.
  ELSE.
  SELECT SINGLE * INTO *LFA1
          FROM LFA1
         WHERE LIFNR EQ ZTCCHD-LIFNR.
  ENDIF.

  W_FIRST_SCR0100 = 'N'.
  MOVE-CORRESPONDING   ZTCCHD  TO   *ZTCCHD.
  IT_ZSCCIT_OLD[] = IT_ZSCCIT[].
  IF ZTCCHD-ZFPOSYN  EQ 'Y'.
     IF SY-TCODE NE 'ZIMC7'.
         LEAVE TO TRANSACTION 'ZIMC7'.
     ENDIF.
  ENDIF.

ENDFORM.                    " P2000_CHANGE_READ_TEXT
