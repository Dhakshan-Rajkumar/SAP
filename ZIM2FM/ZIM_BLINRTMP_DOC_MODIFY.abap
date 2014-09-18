FUNCTION ZIM_BLINRTMP_DOC_MODIFY.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFTBLNO) LIKE  ZTBLINR_TMP-ZFTBLNO
*"     VALUE(ZFSTATUS)
*"     VALUE(W_ZTBLINR_TMP_OLD) LIKE  ZTBLINR_TMP STRUCTURE
*"        ZTBLINR_TMP
*"     VALUE(W_ZTBLINR_TMP) LIKE  ZTBLINR_TMP STRUCTURE  ZTBLINR_TMP
*"     VALUE(W_OK_CODE)
*"  EXCEPTIONS
*"      ERROR_UPDATE
*"      NOT_MODIFY
*"----------------------------------------------------------------------
  DATA : W_ZFBTSEQ   LIKE    ZTBLINR_TMP-ZFBTSEQ.
*>> ������� üũ.
  CLEAR: ZTIV,W_OUYN.
  SELECT ZFCUST INTO ZTIV-ZFCUST UP TO 1 ROWS
      FROM ZTIV
      WHERE ZFBLNO = W_ZTBLINR_TMP-ZFBLNO.
  ENDSELECT.
  IF ZTIV-ZFCUST EQ 'Y'.
    W_OUYN = 'X'.
  ENDIF.
  MOVE-CORRESPONDING : W_ZTBLINR_TMP  TO  ZTBLINR_TMP.
  MOVE : ZFTBLNO     TO     ZTBLINR_TMP-ZFTBLNO,
         SY-MANDT    TO     ZTBLINR_TMP-MANDT,
         SY-UNAME    TO     ZTBLINR_TMP-UNAM,
         SY-DATUM    TO     ZTBLINR_TMP-UDAT,
         SY-UNAME    TO     ZTBLINR-UNAM,
         SY-DATUM    TO     ZTBLINR-UDAT,
         SY-UNAME    TO     ZTBLINOU-UNAM,
         SY-DATUM    TO     ZTBLINOU-UDAT,
         SY-UNAME    TO     ZTBLOUR-UNAM,
         SY-DATUM    TO     ZTBLOUR-UDAT.
  IF W_OK_CODE EQ 'DELE'.
    ZFSTATUS = 'X'.
  ENDIF.
*>> ��ġ�� �Ǿ��� ���.
  IF ZTBLINR_TMP-ZFMCYN EQ 'X'.
    CASE ZFSTATUS.
      WHEN 'C'.
*>> ���Կ�����������.
        MOVE-CORRESPONDING : W_ZTBLINR_TMP  TO  ZTBLINOU.
        MOVE: SY-MANDT    TO     ZTBLINOU-MANDT,
              'X'         TO     ZTBLINOU-ZFBINYN,  " ���ԽŰ���.
              W_OUYN      TO     ZTBLINOU-ZFBOUYN,   " ����Ű���.
              SY-DATUM    TO     ZTBLINOU-ZFTDDT,   " ��۱�����.
              SY-DATUM    TO     ZTBLINOU-ZFRCDT,   " ������.
              SY-UNAME    TO     ZTBLINOU-UNAM,
              SY-DATUM    TO     ZTBLINOU-UDAT.
        MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLINOU-ZFWEIG.
        MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLINOU-ZFWEINM.
        MOVE  SY-UNAME    TO     ZTBLINOU-ERNAM.
        MOVE  SY-DATUM    TO     ZTBLINOU-CDAT.
        IF NOT ZTBLINOU-ZFBLNO IS INITIAL.
          CLEAR W_ZFBTSEQ.
          SELECT MAX( ZFBTSEQ ) INTO W_ZFBTSEQ
            FROM ZTBLINOU
           WHERE ZFBLNO  = ZTBLINR_TMP-ZFBLNO.
          ADD  1 TO  W_ZFBTSEQ.
          MOVE  W_ZFBTSEQ TO  ZTBLINOU-ZFBTSEQ.
        ELSE.
          RAISE  ERROR_UPDATE.
        ENDIF.
        INSERT ZTBLINOU.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
*----------------------------------------------------------------------
*>> ���ԽŰ�.
        MOVE-CORRESPONDING : W_ZTBLINR_TMP  TO  ZTBLINR.
        MOVE-CORRESPONDING : ZTBLINOU     TO  ZTBLINR.
        MOVE:
        ZTBLINOU-ZFBLNO      TO     ZTBLINR-ZFBLNO,   " B/L ������?
        ZTBLINOU-ZFBTSEQ     TO     ZTBLINR-ZFBTSEQ,  " ������� ��?
        ZTBLINOU-ZFABNAR     TO     ZTBLINR-ZFABNAR,  " �������� CD
        ZTBLINOU-ZFABNARC    TO     ZTBLINR-ZFBNARCD, " �������� ID
        SY-DATUM+2(2)        TO     ZTBLINR-ZFYR,     " ����.
        '9'                  TO     ZTBLINR-ZFEDINF,  " ���ڹ�����?
        '33'                 TO     ZTBLINR-ZFINRCD,  " �Ű�.
        '20'                 TO     ZTBLINR-ZFINTY,   " ������?
        'OK'                 TO     ZTBLINR-ZFINACD,  " ���Ի����?
        'A'                  TO     ZTBLINR-ZFPRIN,   " ���ҹ��Ա�?
        ZTBLINOU-ZFPKCNM     TO     ZTBLINR-ZFCT,     " ������?
        SY-DATUM             TO     ZTBLINR-ZFINDT,   " ����?
        SY-UZEIT             TO     ZTBLINR-ZFINTM,   " ���Խ�?
        SY-UNAME             TO     ZTBLINR-ZFGINM,   " ���Դ��?
        ZTBLINOU-ZFABNAR(3)  TO     ZTBLINR-ZFINRC,   " �Ű�����?
        ZTBLINOU-ZFPKCN      TO     ZTBLINR-ZFPKCN,   " �����?
        ZTBLINOU-ZFPKCNM     TO     ZTBLINR-ZFPKCNM,  " ������� ��?
        ZTBLINOU-ZFWEIG      TO     ZTBLINR-ZFINWT,   " ������?
        ZTBLINOU-ZFWEINM     TO     ZTBLINR-ZFKG,     " ���Դ�?
        'O'                  TO     ZTBLINR-ZFDOCST,  " ������?
        'N'                  TO     ZTBLINR-ZFEDIST,  " EDI ��?
        'X'                  TO     ZTBLINR-ZFEDICK,  " EDI CHECK
        SY-UNAME             TO     ZTBLINR-ZFGIRNM.  " ���Դ��?
        MOVE  SY-UNAME       TO     ZTBLINR-ERNAM.
        MOVE  SY-DATUM       TO     ZTBLINR-CDAT.

        INSERT ZTBLINR.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
*>>>>> ����Ű�.
        IF W_OUYN = 'X'.
          MOVE-CORRESPONDING : ZTBLINR  TO  ZTBLOUR.
          MOVE  ZTBLINR-ZFINRNO TO  ZTBLOUR-ZFOURNO. " ����Ű��ȣ.
          MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLOUR-ZFOUWT.
          MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLOUR-ZFKG.
          MOVE  SY-UNAME        TO  ZTBLOUR-ERNAM.
          MOVE  'O'             TO  ZTBLOUR-ZFDOCST.
          MOVE  SY-DATUM        TO  ZTBLOUR-CDAT.
          INSERT ZTBLOUR.
          IF SY-SUBRC NE 0.
            RAISE  ERROR_UPDATE.
          ENDIF.
        ENDIF.
*>>>  ���ԽŰ�TMP
        MOVE  W_ZFBTSEQ       TO  ZTBLINR_TMP-ZFBTSEQ.
        MOVE  SY-UNAME        TO  ZTBLINR_TMP-ERNAM.
        MOVE  SY-DATUM        TO  ZTBLINR_TMP-CDAT.
        INSERT ZTBLINR_TMP.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
* change document -----------------------------------------------------
        CLEAR : W_ZTBLINR_TMP_OLD.
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLINR_TMP'
          EXPORTING
            UPD_CHNGIND   = 'I'
            N_ZTBLINR_TMP = W_ZTBLINR_TMP
            O_ZTBLINR_TMP = W_ZTBLINR_TMP_OLD.
*----------------------------------------------------------------------
*   ����.
*---------------------------------------------------------------------
      WHEN 'U'.
        CLEAR ZTBLINOU.
        SELECT SINGLE *
               FROM  ZTBLINOU
               WHERE ZFBLNO  =  W_ZTBLINR_TMP-ZFBLNO
                 AND ZFBTSEQ =  W_ZTBLINR_TMP-ZFBTSEQ.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
         *ZTBLINOU = ZTBLINOU.
        MOVE-CORRESPONDING : W_ZTBLINR_TMP  TO  ZTBLINOU.
        MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLINOU-ZFWEIG.
        MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLINOU-ZFWEINM.

        UPDATE ZTBLINOU.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
*>> ���ԽŰ�.
        CLEAR ZTBLINR.
        SELECT SINGLE *
               FROM  ZTBLINR
               WHERE ZFBLNO  =  W_ZTBLINR_TMP-ZFBLNO
                 AND ZFBTSEQ =  W_ZTBLINR_TMP-ZFBTSEQ.
         *ZTBLINR = ZTBLINR.
        MOVE-CORRESPONDING  W_ZTBLINR_TMP TO ZTBLINR.
        MOVE-CORRESPONDING  ZTBLINOU TO ZTBLINR.
        MOVE :  '9'          TO     ZTBLINR-ZFEDINF,  " ���ڹ�����?
       '33'                  TO     ZTBLINR-ZFINRCD,  " �Ű�.
        ZTBLINOU-ZFWEIG      TO     ZTBLINR-ZFINWT,   " ������?
        ZTBLINOU-ZFWEINM     TO     ZTBLINR-ZFKG,     " ���Դ�?
        '20'                 TO     ZTBLINR-ZFINTY,   " ������?
        'OK'                 TO     ZTBLINR-ZFINACD,  " ���Ի����?
        'A'                  TO     ZTBLINR-ZFPRIN.   " ���ҹ��Ա�?
        UPDATE ZTBLINR.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.

        CLEAR ZTBLOUR.
        SELECT SINGLE *
               FROM  ZTBLOUR
               WHERE ZFBLNO  =  W_ZTBLINR_TMP-ZFBLNO
                 AND ZFBTSEQ =  W_ZTBLINR_TMP-ZFBTSEQ.
         *ZTBLOUR = ZTBLOUR.
        IF SY-SUBRC EQ 0.
          MOVE-CORRESPONDING : ZTBLINR  TO  ZTBLOUR.
          MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLOUR-ZFOUWT.
          MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLOUR-ZFKG.
          UPDATE ZTBLOUR.
          IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
        ENDIF.
        UPDATE ZTBLINR_TMP.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
* change document -----------------------------------------------------
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLINR_TMP'
          EXPORTING
            UPD_CHNGIND   = 'U'
            N_ZTBLINR_TMP = W_ZTBLINR_TMP
            O_ZTBLINR_TMP = W_ZTBLINR_TMP_OLD.
*----------------------------------------------------------------------
      WHEN 'X'.
        DELETE FROM ZTBLINR_TMP WHERE ZFTBLNO = ZFTBLNO.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.

        DELETE FROM ZTBLINR  WHERE ZFBLNO  = W_ZTBLINR_TMP-ZFBLNO
                               AND ZFBTSEQ = W_ZTBLINR_TMP-ZFBTSEQ.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.

        DELETE FROM ZTBLINOU  WHERE ZFBLNO  = W_ZTBLINR_TMP-ZFBLNO
                                AND ZFBTSEQ = W_ZTBLINR_TMP-ZFBTSEQ.
        IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
        CLEAR ZTBLOUR.
        SELECT SINGLE * FROM ZTBLOUR
                        WHERE ZFBLNO =  W_ZTBLINR_TMP-ZFBLNO
                          AND ZFBTSEQ = W_ZTBLINR_TMP-ZFBTSEQ.

        IF SY-SUBRC EQ 0.
           *ZTBLOUR = ZTBLOUR.
          DELETE FROM ZTBLOUR WHERE ZFBLNO  = W_ZTBLINR_TMP-ZFBLNO
                              AND ZFBTSEQ = W_ZTBLINR_TMP-ZFBTSEQ.
          IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
        ENDIF.
* change document -----------------------------------------------------
        CLEAR : W_ZTBLINR_TMP_OLD.
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLINR_TMP'
          EXPORTING
            UPD_CHNGIND   = 'D'
            N_ZTBLINR_TMP = W_ZTBLINR_TMP
            O_ZTBLINR_TMP = W_ZTBLINR_TMP_OLD.
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLOUR'
          EXPORTING
            UPD_CHNGIND = 'D'
            N_ZTBLOUR   = ZTBLOUR
            O_ZTBLOUR   = *ZTBLOUR.

*----------------------------------------------------------------------
    ENDCASE.
    IF ZFSTATUS NE 'X'.
      SELECT SINGLE * FROM ZTIMIMG00.
      IF ZTIMIMG00-ZFINOU NE 'X'.
        SELECT SINGLE * FROM ZTBL
               WHERE  ZFBLNO EQ ZTBLINR_TMP-ZFBLNO.
        IF NOT ZTBLINR_TMP-ZFETA IS INITIAL.
          MOVE : ZTBLINR_TMP-ZFETA   TO  ZTBL-ZFRETA,
                 ZTBLINR_TMP-ZFINDT  TO  ZTBL-ZFINDT,
                 ZTBLINR_TMP-ZFINRNO TO  ZTBL-ZFINRNO.
*                 '3'                 TO  ZTBL-ZFBLST.
          UPDATE  ZTBL.
        ENDIF.
      ENDIF.
    ELSE.
      IF ZTIMIMG00-ZFINOU NE 'X'.
        SELECT SINGLE * FROM ZTBL
               WHERE  ZFBLNO EQ  ZTBLINR_TMP-ZFBLNO.
        CLEAR : ZTBL-ZFRETA.
        ZTBL-ZFBLST  =  '2'.
        UPDATE  ZTBL.
      ENDIF.
    ENDIF.

*>> ��ġ�� �ȵǾ��� ���.
  ELSE.
    CASE ZFSTATUS.
      WHEN 'C'.
        MOVE  SY-UNAME        TO  ZTBLINR_TMP-ERNAM.
        MOVE  SY-DATUM        TO  ZTBLINR_TMP-CDAT.
        INSERT ZTBLINR_TMP.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
      WHEN 'U'.
        MOVE  SY-UNAME        TO  ZTBLINR_TMP-UNAM.
        MOVE  SY-DATUM        TO  ZTBLINR_TMP-UDAT.
        UPDATE ZTBLINR_TMP.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
      WHEN 'X'.
        DELETE FROM ZTBLINR_TMP WHERE ZFTBLNO = ZFTBLNO.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.

      WHEN 'I'.
*>> ���Կ�����������.
        MOVE-CORRESPONDING : W_ZTBLINR_TMP  TO  ZTBLINOU.
        MOVE: SY-MANDT    TO     ZTBLINOU-MANDT,
              'X'         TO     ZTBLINOU-ZFBINYN,  " ���ԽŰ���.
              W_OUYN      TO     ZTBLINOU-ZFBOUYN,   " ����Ű���.
              SY-DATUM    TO     ZTBLINOU-ZFTDDT,   " ��۱�����.
              SY-DATUM    TO     ZTBLINOU-ZFRCDT,   " ������.
              SY-UNAME    TO     ZTBLINOU-UNAM,
              SY-DATUM    TO     ZTBLINOU-UDAT.
        MOVE  SY-UNAME    TO     ZTBLINOU-ERNAM.
        MOVE  SY-DATUM    TO     ZTBLINOU-CDAT.
        MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLINOU-ZFWEIG.
        MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLINOU-ZFWEINM.

        IF NOT ZTBLINOU-ZFBLNO IS INITIAL.
          CLEAR W_ZFBTSEQ.
          SELECT MAX( ZFBTSEQ ) INTO W_ZFBTSEQ
            FROM ZTBLINOU
           WHERE ZFBLNO  = ZTBLINR_TMP-ZFBLNO.
          ADD  1 TO  W_ZFBTSEQ.
          MOVE  W_ZFBTSEQ TO  ZTBLINOU-ZFBTSEQ.
        ELSE.
          RAISE  ERROR_UPDATE.
        ENDIF.
        INSERT ZTBLINOU.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
*>> ���ԽŰ�.
        MOVE-CORRESPONDING : ZTBLINOU  TO  ZTBLINR.
        MOVE:
        ZTBLINOU-ZFBLNO      TO     ZTBLINR-ZFBLNO,   " B/L ������?
        ZTBLINOU-ZFBTSEQ     TO     ZTBLINR-ZFBTSEQ,  " ������� ��?
        ZTBLINOU-ZFABNAR     TO     ZTBLINR-ZFABNAR,  " �������� CD
        ZTBLINOU-ZFABNARC    TO     ZTBLINR-ZFBNARCD, " �������� ID
        SY-DATUM+2(2)        TO     ZTBLINR-ZFYR,     " ����.
        '9'                  TO     ZTBLINR-ZFEDINF,  " ���ڹ�����?
        '33'                 TO     ZTBLINR-ZFINRCD,  " �Ű�.
        '20'                 TO     ZTBLINR-ZFINTY,   " ������?
        'OK'                 TO     ZTBLINR-ZFINACD,  " ���Ի����?
        'A'                  TO     ZTBLINR-ZFPRIN,   " ���ҹ��Ա�?
        ZTBLINOU-ZFPKCNM     TO     ZTBLINR-ZFCT,     " ������?
        SY-DATUM             TO     ZTBLINR-ZFINDT,   " ����?
        SY-UZEIT             TO     ZTBLINR-ZFINTM,   " ���Խ�?
        SY-UNAME             TO     ZTBLINR-ZFGINM,   " ���Դ��?
        ZTBLINOU-ZFABNAR(3)  TO     ZTBLINR-ZFINRC,   " �Ű�����?
        ZTBLINOU-ZFPKCN      TO     ZTBLINR-ZFPKCN,   " �����?
        ZTBLINOU-ZFPKCNM     TO     ZTBLINR-ZFPKCNM,  " ������� ��?
        ZTBLINOU-ZFWEIG      TO     ZTBLINR-ZFINWT,   " ������?
        ZTBLINOU-ZFWEINM     TO     ZTBLINR-ZFKG,     " ���Դ�?
        'O'                  TO     ZTBLINR-ZFDOCST,  " ������?
        'N'                  TO     ZTBLINR-ZFEDIST,  " EDI ��?
        'X'                  TO     ZTBLINR-ZFEDICK,  " EDI CHECK
        SY-UNAME             TO     ZTBLINR-ZFGIRNM.  " ���Դ��?
        MOVE  SY-UNAME       TO     ZTBLINR-ERNAM.
        MOVE  SY-DATUM       TO     ZTBLINR-CDAT.

        INSERT ZTBLINR.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
*>>>>> ����Ű�.
        IF W_OUYN = 'X'.
          MOVE-CORRESPONDING : ZTBLINR  TO  ZTBLOUR.
          MOVE  ZTBLINR-ZFINRNO TO  ZTBLOUR-ZFOURNO.  " ����Ű��ȣ.
          MOVE  SY-UNAME        TO  ZTBLOUR-ERNAM.
          MOVE  'O'             TO  ZTBLOUR-ZFDOCST.
          MOVE  SY-DATUM        TO  ZTBLOUR-CDAT.
          MOVE W_ZTBLINR_TMP-ZFTOWT  TO ZTBLOUR-ZFOUWT.
          MOVE W_ZTBLINR_TMP-ZFTOWTM TO ZTBLOUR-ZFKG.
          INSERT ZTBLOUR.
          IF SY-SUBRC NE 0.
            RAISE  ERROR_UPDATE.
          ENDIF.
        ENDIF.
*>>>  ���ԽŰ�TMP
        SELECT SINGLE * FROM  ZTBLINR_TMP
                        WHERE ZFTBLNO = ZFTBLNO.
         *ZTBLINR_TMP = ZTBLINR_TMP.

        IF SY-SUBRC NE 0.  RAISE  ERROR_UPDATE. ENDIF.
        MOVE-CORRESPONDING W_ZTBLINR_TMP TO ZTBLINR_TMP.
        MOVE ZTBLINOU-ZFBLNO  TO  ZTBLINR_TMP-ZFBLNO.
        MOVE ZTBLINOU-ZFBTSEQ TO  ZTBLINR_TMP-ZFBTSEQ.
        MOVE  'X'             TO  ZTBLINR_TMP-ZFMCYN.
        MOVE  SY-UNAME        TO  ZTBLINR_TMP-UNAM.
        MOVE  SY-DATUM        TO  ZTBLINR_TMP-UDAT.
        UPDATE ZTBLINR_TMP.
        IF SY-SUBRC NE 0.
          RAISE  ERROR_UPDATE.
        ENDIF.
*>> CHAGE DOCUMENT.-----------------------------------------------------
*>>  ���ԽŰ�
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLINR_TMP'
          EXPORTING
            UPD_CHNGIND   = 'U'
            N_ZTBLINR_TMP = W_ZTBLINR_TMP
            O_ZTBLINR_TMP = *ZTBLINR_TMP.
*>> ����Ű�
        CLEAR: *ZTBLOUR.
        CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_BLOUR'
          EXPORTING
            UPD_CHNGIND = 'U'
            N_ZTBLOUR   = ZTBLOUR
            O_ZTBLOUR   = *ZTBLOUR.
*---------------------------------------------------------------------

*>> B/L UPDATE.
        SELECT SINGLE * FROM ZTIMIMG00.
        IF ZTIMIMG00-ZFINOU NE 'X'.
          SELECT SINGLE * FROM ZTBL
                 WHERE  ZFBLNO EQ ZTBLINR_TMP-ZFBLNO.
          IF NOT ZTBLINR_TMP-ZFETA IS INITIAL.
            MOVE : ZTBLINR_TMP-ZFETA   TO  ZTBL-ZFRETA,
                   ZTBLINR_TMP-ZFINDT  TO  ZTBL-ZFINDT,
                   ZTBLINR_TMP-ZFINRNO TO  ZTBL-ZFINRNO,
                   '3'                 TO  ZTBL-ZFBLST.
            UPDATE  ZTBL.
          ENDIF.
        ENDIF.

    ENDCASE.
  ENDIF.

ENDFUNCTION.
