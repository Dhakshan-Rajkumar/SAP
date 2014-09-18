FUNCTION ZIM_RFC_INSERT_ZTBLINR.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  TABLES
*"      IT_ZTBLINR_TMP STRUCTURE  ZTBLINR_TMP
*"----------------------------------------------------------------------
*&  ���α׷��� : ����EDI ����Ÿ SAP�� �Է�.                            *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.28                                            *
*&     ����ȸ��: �Ѽ���.*
*&---------------------------------------------------------------------*
*&   DESC.     : ���ԽŰ� EDI����Ÿ�� SAP�� DB�� �ø��� ����
*&               VB���α׷����� CALL�ϰ� �Ǵ� RFC FUNCTION
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
  DATA : W_BLCNT TYPE I.

  LOOP AT IT_ZTBLINR_TMP.
    CLEAR : ZTBLINR_TMP.
*> �̹� �Էµ� ����Ÿ���� CHECK.
    IF IT_ZTBLINR_TMP-ZFSIBG IS INITIAL.
      CONTINUE.
    ENDIF.

    SELECT SINGLE * FROM ZTBLINR_TMP
                   WHERE ZFSIBG = IT_ZTBLINR_TMP-ZFSIBG.
    IF SY-SUBRC EQ 0.
      CONTINUE.
    ENDIF.

*> �Է��ؾ� �ϴ� ����Ÿ�� ����.
    CLEAR : ZTBLINR_TMP, *ZTBLINR_TMP, ZTBL.
    MOVE-CORRESPONDING IT_ZTBLINR_TMP TO ZTBLINR_TMP.
*> B/L���� MATCH.
    SELECT COUNT( * ) INTO W_BLCNT FROM ZTBL
                     WHERE ZFHBLNO = IT_ZTBLINR_TMP-ZFHBLNO.
    IF W_BLCNT EQ 0.
      CLEAR ZTBLINR_TMP-ZFMCYN.
    ELSEIF W_BLCNT EQ 1.
      SELECT SINGLE * FROM ZTBL
                     WHERE ZFHBLNO = IT_ZTBLINR_TMP-ZFHBLNO.
      IF SY-SUBRC EQ 0.
        MOVE : ZTBL-BUKRS     TO   ZTBLINR_TMP-BUKRS,
               ZTBL-ZFBLNO    TO   ZTBLINR_TMP-ZFBLNO,
               ZTBL-ZFMATGB   TO   ZTBLINR_TMP-ZFMATGB,
               ZTBL-LIFNR     TO   ZTBLINR_TMP-LIFNR,
               ZTBL-ZFREBELN  TO   ZTBLINR_TMP-ZFREBELN,
               ZTBL-ZFSHNO    TO   ZTBLINR_TMP-ZFSHNO,
               ZTBL-ZFPKCN    TO   ZTBLINR_TMP-ZFPKCN,
               ZTBL-ZFTOWT    TO   ZTBLINR_TMP-ZFTOWT,
               ZTBL-ZFTOWTM   TO   ZTBLINR_TMP-ZFTOWTM,
               ZTBL-ZFTOVL    TO   ZTBLINR_TMP-ZFTOVL,
               ZTBL-ZFTOVLM   TO   ZTBLINR_TMP-ZFTOVLM,
               SY-UNAME       TO   ZTBLINR_TMP-ZFGINM,
               ZTBL-ZF20FT    TO   ZTBLINR_TMP-ZF20FT,
               ZTBL-ZF40FT    TO   ZTBLINR_TMP-ZF40FT,
               ZTBL-ZFSHTY    TO   ZTBLINR_TMP-ZFSHTY,
               ZTBL-ZFFORD    TO   ZTBLINR_TMP-ZFFORD,
               'X'            TO   ZTBLINR_TMP-ZFMCYN.

      ELSE.
        CLEAR ZTBLINR_TMP-ZFMCYN.
      ENDIF.

    ELSEIF W_BLCNT GT 1.
*> House B/L�� �ߺ��϶�, ȭ��������ȣ�� ã��.
      SELECT SINGLE * FROM ZTBL
                     WHERE ZFGMNO = IT_ZTBLINR_TMP-ZFGMNO
                       AND ZFMSN  = IT_ZTBLINR_TMP-ZFMSN
                       AND ZFHSN  = IT_ZTBLINR_TMP-ZFHSN.
      IF SY-SUBRC EQ 0.
        MOVE : ZTBL-BUKRS     TO   ZTBLINR_TMP-BUKRS,
               ZTBL-ZFBLNO    TO   ZTBLINR_TMP-ZFBLNO,
               ZTBL-ZFMATGB   TO   ZTBLINR_TMP-ZFMATGB,
               ZTBL-LIFNR     TO   ZTBLINR_TMP-LIFNR,
               ZTBL-ZFREBELN  TO   ZTBLINR_TMP-ZFREBELN,
               ZTBL-ZFSHNO    TO   ZTBLINR_TMP-ZFSHNO,
               ZTBL-ZFPKCN    TO   ZTBLINR_TMP-ZFPKCN,
               ZTBL-ZFTOWT    TO   ZTBLINR_TMP-ZFTOWT,
               ZTBL-ZFTOWTM   TO   ZTBLINR_TMP-ZFTOWTM,
               ZTBL-ZFTOVL    TO   ZTBLINR_TMP-ZFTOVL,
               ZTBL-ZFTOVLM   TO   ZTBLINR_TMP-ZFTOVLM,
               SY-UNAME       TO   ZTBLINR_TMP-ZFGINM,
               ZTBL-ZF20FT    TO   ZTBLINR_TMP-ZF20FT,
               ZTBL-ZF40FT    TO   ZTBLINR_TMP-ZF40FT,
               ZTBL-ZFSHTY    TO   ZTBLINR_TMP-ZFSHTY,
               ZTBL-ZFFORD    TO   ZTBLINR_TMP-ZFFORD,
               'X'            TO   ZTBLINR_TMP-ZFMCYN.

      ELSE.
        CLEAR ZTBLINR_TMP-ZFMCYN.
      ENDIF.
    ENDIF.

    CLEAR ZTBL.

*> ������������ ���ΰ����ڵ� ��������.
    SELECT SINGLE ZFBNARCD INTO ZTBLINR_TMP-ZFBNARCD
                           FROM ZTIMIMG03
                          WHERE ZFBNAR = ZTBLINR_TMP-ZFABNAR.

*> ���԰�����ȣ ����.
    PERFORM P2000_GET_NUMBER_NEXT USING 'BI' ZTBLINR_TMP-ZFTBLNO.
*> DB�� �ֱ�.
    CALL FUNCTION 'ZIM_BLINRTMP_DOC_MODIFY'
      EXPORTING
        ZFTBLNO           = ZTBLINR_TMP-ZFTBLNO
        ZFSTATUS          = 'C'
        W_ZTBLINR_TMP_OLD = *ZTBLINR_TMP
        W_ZTBLINR_TMP     = ZTBLINR_TMP
        W_OK_CODE         = 'SAVE'
      EXCEPTIONS
        ERROR_UPDATE      = 4
        NOT_MODIFY        = 8.

    IF SY-SUBRC EQ 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDLOOP.
  CLEAR : ZTBLINR_TMP, *ZTBLINR_TMP, ZTBL.
ENDFUNCTION.
