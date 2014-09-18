FUNCTION ZIM_GAIN_DOCUMENT_CANCEL.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFIVNO) TYPE  ZTIV-ZFIVNO
*"     VALUE(REASONREVERSAL) LIKE  BAPI_INCINV_FLD-REASON_REV
*"     VALUE(POSTINGDATE) LIKE  BAPI_INCINV_FLD-PSTNG_DATE DEFAULT
*"       SY-DATUM
*"     VALUE(MODE) TYPE  C DEFAULT 'N'
*"  EXPORTING
*"     VALUE(INVOICEDOCNUMBER_REVERSAL) TYPE
*"        BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(FISCALYEAR_REVERSAL) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      POST_ERROR
*"----------------------------------------------------------------------
DATA: L_SUBRC    LIKE SY-SUBRC,
      W_ZFIVHST  LIKE ZTIVHST-ZFIVHST.

DATA: CTU_PARAMS LIKE CTU_PARAMS.

    CTU_PARAMS-DISMODE  = MODE.
    CTU_PARAMS-UPDMODE  = 'V'.
    CTU_PARAMS-CATTMODE = ' '.
    CTU_PARAMS-DEFSIZE  = ' '.
    CTU_PARAMS-RACOMMIT = 'X'.
    CTU_PARAMS-NOBINPT  = 'X'.
    CTU_PARAMS-NOBIEND  = 'X'.

   REFRESH : BDCDATA, MESSTAB, RETURN.

   SELECT SINGLE * FROM ZTIV
          WHERE    ZFIVNO EQ ZFIVNO.
   IF SY-SUBRC NE 0.
      MESSAGE E413 WITH ZFIVNO   RAISING    POST_ERROR.
   ENDIF.

   SELECT MAX( ZFIVHST ) INTO W_ZFIVHST
          FROM  ZTIVHST
          WHERE ZFIVNO EQ ZFIVNO
          AND   ZFGAIN EQ 'X'
          AND ( CMBLNR IS NULL
          OR    CMBLNR EQ SPACE ).

   SELECT SINGLE * FROM ZTIVHST
          WHERE ZFIVNO  EQ ZFIVNO
          AND   ZFIVHST EQ W_ZFIVHST.
   IF SY-SUBRC NE 0.
      MESSAGE E414(ZIM1) WITH ZFIVNO W_ZFIVHST  RAISING    POST_ERROR.
   ENDIF.

* �ʱ�ȭ�� FIELD
   PERFORM P2000_DYNPRO USING :
          'X' 'SAPMF05A'    '0105',
          ' ' 'RF05A-BELNS' ZTIVHST-MBLNR,       " ���а��� ��ǥ.
          ' ' 'BKPF-BUKRS'  ZTIV-BUKRS,          " Company Code
          ' ' 'RF05A-GJAHS' ZTIVHST-MJAHR,       " ȸ�迬��.
          ' ' 'UF05A-STGRD' REASONREVERSAL,      " ���а�����.
          ' ' 'BSIS-BUDAT'  POSTINGDATE,         " ��ǥ������.
          ' ' 'BSIS-MONAT'  SPACE,               " ȸ��Ⱓ.
          ' ' 'RF05A-VOIDR' SPACE,               " ��ǥ�������ڵ�.
          ' ' 'BDC_OKCODE'  '=BU'.               " ����.

   SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
   SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
*>> BDC CALL.

   CALL TRANSACTION 'FB08'  USING       BDCDATA
                            OPTIONS FROM CTU_PARAMS
*                               MODE        MODE
*                               UPDATE      'V'
                            MESSAGES    INTO   MESSTAB.

   L_SUBRC = SY-SUBRC.

   IF L_SUBRC NE 0.      ">> ERROR �߻���.
      LOOP AT MESSTAB.
         MOVE : MESSTAB-MSGTYP  TO     RETURN-TYPE,
                MESSTAB-MSGID   TO     RETURN-ID,
                MESSTAB-MSGNR   TO     RETURN-NUMBER,
                MESSTAB-MSGV1   TO     RETURN-MESSAGE_V1,
                MESSTAB-MSGV2   TO     RETURN-MESSAGE_V2,
                MESSTAB-MSGV3   TO     RETURN-MESSAGE_V3,
                MESSTAB-MSGV4   TO     RETURN-MESSAGE_V4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                EXPORTING
                      MSGID     = RETURN-ID
                      MSGNR     = RETURN-NUMBER
                      MSGV1     = RETURN-MESSAGE_V1
                      MSGV2     = RETURN-MESSAGE_V2
                      MSGV3     = RETURN-MESSAGE_V3
                      MSGV4     = RETURN-MESSAGE_V4
               IMPORTING
                      MESSAGE_TEXT_OUTPUT = RETURN-MESSAGE.
         APPEND  RETURN.
      ENDLOOP.
   ELSE.                 ">> SUCCESS ��.
      GET PARAMETER ID 'BLN' FIELD INVOICEDOCNUMBER_REVERSAL.
      GET PARAMETER ID 'GJR' FIELD FISCALYEAR_REVERSAL.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
      IF INVOICEDOCNUMBER_REVERSAL EQ ZTIVHST-MBLNR AND
         FISCALYEAR_REVERSAL       EQ ZTIVHST-MJAHR.

*>>> ����..(����� ���� ��....)
         L_SUBRC = 4.
         MESSAGE S494.
         MOVE : 'E'             TO     RETURN-TYPE,
                'ZIM'           TO     RETURN-ID,
                '494'           TO     RETURN-NUMBER,
                SPACE           TO     RETURN-MESSAGE_V1,
                SPACE           TO     RETURN-MESSAGE_V2,
                SPACE           TO     RETURN-MESSAGE_V3,
                SPACE           TO     RETURN-MESSAGE_V4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                EXPORTING
                      MSGID     = RETURN-ID
                      MSGNR     = RETURN-NUMBER
                      MSGV1     = RETURN-MESSAGE_V1
                      MSGV2     = RETURN-MESSAGE_V2
                      MSGV3     = RETURN-MESSAGE_V3
                      MSGV4     = RETURN-MESSAGE_V4
               IMPORTING
                      MESSAGE_TEXT_OUTPUT = RETURN-MESSAGE.
         APPEND  RETURN.
      ELSE.
         MESSAGE S282(M8) WITH INVOICEDOCNUMBER_REVERSAL.
         MOVE : SY-MSGTY   TO     RETURN-TYPE,
                SY-MSGID   TO     RETURN-ID,
                SY-MSGNO   TO     RETURN-NUMBER,
                SY-MSGV1   TO     RETURN-MESSAGE_V1,
                SY-MSGV2   TO     RETURN-MESSAGE_V2,
                SY-MSGV3   TO     RETURN-MESSAGE_V3,
                SY-MSGV4   TO     RETURN-MESSAGE_V4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                EXPORTING
                      MSGID     = RETURN-ID
                      MSGNR     = RETURN-NUMBER
                      MSGV1     = RETURN-MESSAGE_V1
                      MSGV2     = RETURN-MESSAGE_V2
                      MSGV3     = RETURN-MESSAGE_V3
                      MSGV4     = RETURN-MESSAGE_V4
               IMPORTING
                      MESSAGE_TEXT_OUTPUT = RETURN-MESSAGE.
         APPEND  RETURN.
         L_SUBRC = 0.
      ENDIF.
   ENDIF.

   IF L_SUBRC EQ 0.
      MOVE: INVOICEDOCNUMBER_REVERSAL TO ZTIVHST-CMBLNR,
            FISCALYEAR_REVERSAL       TO ZTIVHST-CMJAHR,
            POSTINGDATE               TO ZTIVHST-CBUDAT,
            SY-UNAME                  TO ZTIVHST-UNAM,
            SY-DATUM                  TO ZTIVHST-UDAT,
            SY-UZEIT                  TO ZTIVHST-UTME.
      UPDATE ZTIVHST.
      IF SY-SUBRC NE 0.
         MESSAGE E644 RAISING    POST_ERROR.
      ENDIF.

      SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIVHSTIT
               FROM ZTIVHSTIT
               WHERE ZFIVNO  EQ ZFIVNO
               AND   ZFIVHST EQ W_ZFIVHST.

      SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIVIT
               FROM ZTIVIT
               FOR ALL ENTRIES IN IT_ZSIVHSTIT
               WHERE ZFIVNO  EQ IT_ZSIVHSTIT-ZFIVNO
               AND   ZFIVDNO EQ IT_ZSIVHSTIT-ZFIVDNO
               AND   ZFPOTY  EQ 'S'
               AND   NDFTX   EQ 'X'.

      LOOP AT IT_ZSIVIT.
         W_TABIX = SY-TABIX.
         CLEAR : IT_ZSIVIT-NDFTX.
         MODIFY IT_ZSIVIT INDEX W_TABIX.
      ENDLOOP.

      MODIFY ZTIVIT FROM TABLE IT_ZSIVIT.
      IF SY-SUBRC NE 0.
         MESSAGE E646   RAISING    POST_ERROR.
      ENDIF.

*      MOVE : SY-UNAME          TO   ZTIV-UNAM,
*             SY-DATUM          TO   ZTIV-UDAT.

      UPDATE  ZTIV SET: UNAM = SY-UNAME,
                        UDAT = SY-DATUM
                   WHERE ZFIVNO EQ ZFIVNO.
      IF SY-SUBRC NE 0.
         MESSAGE E952   RAISING    POST_ERROR.
      ENDIF.
   ENDIF.

ENDFUNCTION.
