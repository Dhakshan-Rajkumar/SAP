FUNCTION ZIM_BAPI_COST_INVOICEVERIFY.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(P_ZFIVNO) LIKE  ZTIV-ZFIVNO
*"     REFERENCE(P_CHG_MODE) TYPE  C DEFAULT 'X'
*"     REFERENCE(P_DOC_TYPE) TYPE  BAPI_INCINV_CREATE_HEADER-DOC_TYPE
*"       DEFAULT 'RE'
*"     REFERENCE(I_INVOICE) LIKE  RBKP-XRECH
*"     REFERENCE(I_CREDITMEMO) LIKE  RBKP-XRECH
*"     REFERENCE(P_BLDAT) LIKE  MKPF-BLDAT
*"     REFERENCE(P_BUDAT) LIKE  MKPF-BUDAT
*"  EXPORTING
*"     VALUE(INVOICEDOCNUMBER) LIKE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(FISCALYEAR) LIKE  BAPI_INCINV_FLD-FISC_YEAR
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2
*"  EXCEPTIONS
*"      LIV_ERROR
*"----------------------------------------------------------------------
DATA : W_TEXT70(70).

DATA : W_AMOUNT   LIKE   ZSIVIT-ZFIVAMT,
       W_TOT_AMT  LIKE   ZSIVIT-ZFIVAMT.

   CLEAR : INVOICEDOCNUMBER, FISCALYEAR,
           HEADERDATA, ITEMDATA,
           TAXDATA,
*--------------------------------------------------------------
*> dreamland remark.
*--------------------------------------------------------------
*           WITHTAXDATA,
*           VENDORITEMSPLITDATA,
*--------------------------------------------------------------
           RETURN,
           ZTREQHD, ZTBL.

   REFRESH : ITEMDATA, TAXDATA,
*--------------------------------------------------------------
*> dreamland remark.
*--------------------------------------------------------------
*             WITHTAXDATA,
*             VENDORITEMSPLITDATA,
*--------------------------------------------------------------
             RETURN.

*>> KEY VALUE CHECK..
   IF P_ZFIVNO IS INITIAL.
      MESSAGE E412 RAISING LIV_ERROR.
   ENDIF.

*>> ��� ��û HEADER SELECT.
   SELECT SINGLE * FROM   ZTIV
                   WHERE  ZFIVNO  EQ   P_ZFIVNO.
   IF SY-SUBRC NE 0.
      MESSAGE  E413 WITH P_ZFIVNO RAISING LIV_ERROR.
   ENDIF.

*>>> ������� üũ.
  CASE ZTIV-ZFCUST.
     WHEN '1' OR '2' OR '3'.
        PERFORM   GET_DD07T_SELECT(SAPMZIM01)
                  USING      'ZDCUST'  ZTIV-ZFCUST
                  CHANGING    W_TEXT70.
        MESSAGE E419 WITH P_ZFIVNO W_TEXT70 '����� ó��'
                           RAISING LIV_ERROR.

     WHEN 'Y' OR 'N'.
  ENDCASE.

*>>> ����� ���� üũ.
  CASE ZTIV-ZFCDST.
     WHEN 'X' OR 'N'.     ">��κҰ�..(����)
        PERFORM   GET_DD07T_SELECT(SAPMZIM01)
                  USING      'ZDCDST'  ZTIV-ZFCDST
                  CHANGING    W_TEXT70.
        MESSAGE E420 WITH P_ZFIVNO W_TEXT70 '����� ó��'
                           RAISING LIV_ERROR.

     WHEN 'Y'.     ">��οϷ�. (MESSAGE)
     WHEN OTHERS.  ">���� ����.(����)
        MESSAGE E420 WITH P_ZFIVNO '���Է»���' '����� ó��'
                           RAISING LIV_ERROR.
   ENDCASE.

*>>> �԰� ���� üũ.
   CASE ZTIV-ZFGRST.
      WHEN 'N'.     ">�԰���.(����)
         PERFORM   GET_DD07T_SELECT(SAPMZIM01)
                   USING      'ZDGRST'  ZTIV-ZFGRST
                   CHANGING    W_TEXT70.
         MESSAGE E422 WITH P_ZFIVNO W_TEXT70 '����� ó��'
                           RAISING LIV_ERROR.
   ENDCASE.
*>>> ����� ���� üũ.
   CASE ZTIV-ZFCIVST.
      WHEN 'Y' OR 'X'.     ">ó���Ϸ�.(����) OR �Ұ�����(����).
         PERFORM   GET_DD07T_SELECT(SAPMZIM01)
                   USING      'ZDCIVST'  ZTIV-ZFCIVST
                   CHANGING    W_TEXT70.

         MESSAGE E423 WITH P_ZFIVNO W_TEXT70 '����� ó��'
                           RAISING LIV_ERROR.
      WHEN 'N'.     ">�����ó�����.(NONE)
   ENDCASE.

*>> �����û ITEM SELECT.
   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTIVIT
            FROM  ZTIVIT
            WHERE ZFIVNO   EQ   P_ZFIVNO.

*>> ITEM LEVEL CHECK.
   W_LINE = 0.
   W_TOT_AMT = 0.
   LOOP AT IT_ZTIVIT.
*>> P/O ����(HEADER).
      IF NOT IT_ZTIVIT-EBELN IS INITIAL.
         SELECT SINGLE * FROM  EKKO              ">P/O HEADER CHECK..
                  WHERE EBELN EQ IT_ZTIVIT-EBELN.
         IF EKKO-LOEKZ NE SPACE.       ">������ũ ����.
            MESSAGE E005 WITH IT_ZTIVIT-EBELN
                              RAISING LIV_ERROR.
         ENDIF.

         SELECT SINGLE * FROM  EKPO              "> P/O ITEM CHECK..
                         WHERE EBELN EQ IT_ZTIVIT-EBELN
                         AND   EBELP EQ IT_ZTIVIT-EBELP.
         IF EKPO-LOEKZ NE SPACE.       ">������ũ ����.
            MESSAGE E069 WITH IT_ZTIVIT-EBELN IT_ZTIVIT-EBELP
                         RAISING LIV_ERROR.
         ENDIF.
         IF EKPO-ELIKZ NE SPACE.       ">��ǰ�Ϸ� ����.
            MESSAGE E359 WITH IT_ZTIVIT-EBELN IT_ZTIVIT-EBELP
                         RAISING LIV_ERROR.
         ENDIF.
      ENDIF.
*>>
      W_AMOUNT = IT_ZTIVIT-ZFUPCST + IT_ZTIVIT-ZFPCST.
      W_TOT_AMT = W_TOT_AMT + W_AMOUNT.

      WRITE W_AMOUNT TO  W_TEXT_AMOUNT
            CURRENCY    'KRW'.
      PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

      CLEAR : ITEMDATA.
      ADD    1    TO     W_LINE.
      MOVE : W_LINE                 TO  ITEMDATA-INVOICE_DOC_ITEM,
             IT_ZTIVIT-EBELN        TO  ITEMDATA-PO_NUMBER,
             IT_ZTIVIT-EBELP        TO  ITEMDATA-PO_ITEM,
             SPACE                  TO  ITEMDATA-REF_DOC,
             SPACE                  TO  ITEMDATA-REF_DOC_YEAR,
             SPACE                  TO  ITEMDATA-REF_DOC_IT,
             'X'                    TO  ITEMDATA-DE_CRE_IND, ">�ļ�����.
             'V0'                   TO  ITEMDATA-TAX_CODE,
             SPACE                  TO  ITEMDATA-TAXJURCODE,
             W_TEXT_AMOUNT          TO  ITEMDATA-ITEM_AMOUNT,
             IT_ZTIVIT-CCMENGE      TO  ITEMDATA-QUANTITY,
             IT_ZTIVIT-MEINS        TO  ITEMDATA-PO_UNIT,
             SPACE                  TO  ITEMDATA-PO_UNIT_ISO,
             IT_ZTIVIT-PEINH        TO  ITEMDATA-PO_PR_QNT,
             IT_ZTIVIT-BPRME        TO  ITEMDATA-PO_PR_UOM,
             SPACE                  TO  ITEMDATA-PO_PR_UOM_ISO,
             SPACE                  TO  ITEMDATA-COND_TYPE,
             SPACE                  TO  ITEMDATA-COND_ST_NO,
             SPACE                  TO  ITEMDATA-COND_COUNT.
*--------------------------------------------------------------
*> dreamland remark.
*--------------------------------------------------------------
*             SPACE                  TO  ITEMDATA-SHEET_NO.
*--------------------------------------------------------------

      APPEND ITEMDATA.
   ENDLOOP.

*>> TAX DATA.
   WRITE W_TOT_AMT TO  W_TEXT_AMOUNT
         CURRENCY  'KRW'.
   PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

   CLEAR : TAXDATA.
   MOVE : 'V0'   TO   TAXDATA-TAX_CODE.
   APPEND  TAXDATA.

*--------------------------------------------------------------
*> dreamland remark.
*--------------------------------------------------------------
*   CLEAR : VENDORITEMSPLITDATA.
*   MOVE : 1               TO   VENDORITEMSPLITDATA-SPLIT_KEY,
*          W_TEXT_AMOUNT   TO   VENDORITEMSPLITDATA-SPLIT_AMOUNT,
*          SPACE           TO   VENDORITEMSPLITDATA-PYMT_METH,
*          'V0'            TO   VENDORITEMSPLITDATA-TAX_CODE,
*          SPACE           TO   VENDORITEMSPLITDATA-PMTMTHSUPL,
*          ZTIV-ZTERM      TO   VENDORITEMSPLITDATA-PMNTTRMS.
*
*   APPEND  VENDORITEMSPLITDATA.
*--------------------------------------------------------------

*>> �����Ƿڰ� SELECT.
   READ TABLE  IT_ZTIVIT INDEX 1.
   IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZTREQHD
                      WHERE ZFREQNO  EQ  IT_ZSIVIT-ZFREQNO.
   ENDIF.

*>> B/L�� SELECT.
   CLEAR TEMP_BKTXT.
   LOOP AT IT_ZTIVIT WHERE ZFBLNO <> SPACE.
      SELECT SINGLE * FROM  ZTBL
                      WHERE ZFBLNO  EQ  IT_ZSIVIT-ZFBLNO.
      TEMP_BKTXT = ZTBL-ZFHBLNO.
   ENDLOOP.

*>> CURRENCY ISO CODE SELECT.
   SELECT SINGLE * FROM   TCURC
                   WHERE  WAERS   EQ   ZTIV-ZFIVAMC.

*-----------------------------------------------------------------------
*>> HEADER DATA.
   IF NOT I_INVOICE IS INITIAL.
      MOVE : 'X'         TO  HEADERDATA-INVOICE_IND. ">������/��������.
   ELSEIF NOT I_CREDITMEMO IS INITIAL.
      MOVE : SPACE       TO  HEADERDATA-INVOICE_IND. ">������/��������.
   ELSE.
      MOVE : 'X'         TO  HEADERDATA-INVOICE_IND. ">������/��������.
   ENDIF.

   MOVE : P_DOC_TYPE      TO  HEADERDATA-DOC_TYPE,     ">����Ÿ��.
          P_BLDAT         TO  HEADERDATA-DOC_DATE,     ">������.
          P_BUDAT         TO  HEADERDATA-PSTNG_DATE,   ">������.
          ZTREQHD-ZFOPNNO TO  HEADERDATA-REF_DOC_NO,   ">����������ȣ.
          ZTIV-BUKRS      TO  HEADERDATA-COMP_CODE,    ">ȸ���ڵ�.
*>>> �ٸ��������ó.(INVOICE PARTY or OPEN BANK) --> OPEN BANK(DEFAULT)
*         ZTCIVHD-ZFMAVN  TO  HEADERDATA-DIFF_INV,     ">�ٸ��������ó.
          ZTIV-ZFPHVN     TO  HEADERDATA-DIFF_INV,     ">�ٸ��������ó.
          'KRW'           TO  HEADERDATA-CURRENCY,     ">��ȭ����.
          'KRW'           TO  HEADERDATA-CURRENCY_ISO. ">ISO ��ȭ.

*>>> ȯ��.
*   IF ZTIV-ZFIVAMC NE 'KRW'.
*      MOVE: ZTIV-ZFEXRT   TO  HEADERDATA-EXCH_RATE,    ">����ȣ��ȯ��.
*            ZTIV-ZFEXRT   TO  HEADERDATA-EXCH_RATE_V.  ">����ȣ��ȯ��.
*   ENDIF.

   MOVE : W_TEXT_AMOUNT   TO  HEADERDATA-GROSS_AMOUNT, ">�Ѽ���ݾ�.
          ' '             TO  HEADERDATA-CALC_TAX_IND, ">�����ڵ����.
          ZTIV-ZTERM      TO  HEADERDATA-PMNTTRMS,     ">��������Ű.
*         SPACE           TO  HEADERDATA-PMNTTRMS,     ">��������Ű.
*>>> ����� <--- ������(������ �� 2001/02/27)
          P_BLDAT         TO  HEADERDATA-BLINE_DATE,   ">�����.
          0               TO  HEADERDATA-DSCT_DAYS1,   ">�������αⰣ1.
          0               TO  HEADERDATA-DSCT_DAYS2,   ">�������αⰣ2.
          0               TO  HEADERDATA-NETTERMS,   ">�����������ǱⰣ.
          0               TO  HEADERDATA-DSCT_PCT1,    ">���������� 1.
          0               TO  HEADERDATA-DSCT_PCT2,    ">���������� 2.
          SPACE           TO  HEADERDATA-IV_CATEGORY,  ">�����������.
*>>> B/L No. -->
          TEMP_BKTXT      TO  HEADERDATA-HEADER_TXT,   ">��ǥ����ؽ�Ʈ.
*>>> ���޺���Ű <--- 'B' (������ �� 2001/02/27)
          'B'             TO  HEADERDATA-PMNT_BLOCK.   ">���޺���Ű.

*-----------------------------------------------------------------------
*>> ���ȹ��ۺ��.
   W_ZFIVAMT = 0.
*   W_ZFIVAMT = ZTCIVHD-ZFPKCHGP + ZTCIVHD-ZFHDCHGP.

   MOVE : W_ZFIVAMT     TO  HEADERDATA-DEL_COSTS,      ">���ȹ��ۺ��.
          SPACE         TO  HEADERDATA-DEL_COSTS_TAXC, ">��ۺ��TAX.
          SPACE         TO  HEADERDATA-DEL_COSTS_TAXJ, ">��������.
          SPACE         TO  HEADERDATA-PERSON_EXT.     ">�ܺνý���.
*--------------------------------------------------
*> dreamland remark.
*--------------------------------------------------
*          SPACE         TO  HEADERDATA-PYMT_METH,      ">���޹��.
*          SPACE         TO  HEADERDATA-PMTMTHSUPL.     ">���޹������.
*--------------------------------------------------

*>> FUNCTION CALL
   CALL FUNCTION 'MRM_XMLBAPI_INCINV_CREATE'
        EXPORTING
            HEADERDATA             = HEADERDATA
            I_INVOICE              = I_INVOICE
            I_CREDITMEMO           = I_CREDITMEMO
        IMPORTING
            INVOICEDOCNUMBER       = INVOICEDOCNUMBER
            FISCALYEAR             = FISCALYEAR
        TABLES
            ITEMDATA               = ITEMDATA
*            ACCOUNTINGDATA         =
            TAXDATA                = TAXDATA
*            WITHTAXDATA            = WITHTAXDATA
*            VENDORITEMSPLITDATA    = VENDORITEMSPLITDATA
            RETURN                 = RETURN.

  IF RETURN[] IS INITIAL.        "> SUCCESS

     SELECT SINGLE * FROM ZTIV
                     WHERE ZFIVNO   EQ    P_ZFIVNO.

     CLEAR : ZTIVHST1.
*>> INVOICE VERIFY�� ���..
     IF NOT I_INVOICE IS INITIAL.
        MOVE : 'Y'               TO      ZTIV-ZFCIVST.
        UPDATE    ZTIV.
        MOVE    'S'              TO      ZTIVHST1-SHKZG.
*>> CREDIT MEMO�� ���.
     ELSE.           "> CREDIT MEMO.
        MOVE : 'N'               TO      ZTIV-ZFCIVST.
        UPDATE    ZTIV.
        MOVE    'H'              TO      ZTIVHST1-SHKZG.
     ENDIF.
  ENDIF.

*>> �̷� ���̺�.
  IF P_CHG_MODE EQ 'X'.
     IF RETURN[] IS INITIAL.        "> SUCCESS

        MOVE : SY-MANDT           TO     ZTIVHST1-MANDT,
               P_ZFIVNO           TO     ZTIVHST1-ZFIVNO,
               P_BLDAT            TO     ZTIVHST1-BLDAT,
               P_BUDAT            TO     ZTIVHST1-BUDAT,
               ZTIV-BUKRS         TO     ZTIVHST1-BUKRS,
               W_TOT_AMT          TO     ZTIVHST1-ZFIVAMK,
               'KRW'              TO     ZTIVHST1-ZFKRW,
*               ZTCIVHD-ZFIVAMP    TO     ZTIVHST1-ZFIVAMP,
*               ZTCIVHD-ZFIVAMC    TO     ZTIVHST1-WAERS,
               ZTIV-ZFEXRT        TO     ZTIVHST1-ZFEXRT,
               SY-UNAME           TO     ZTIVHST1-ERNAM,
               SY-DATUM           TO     ZTIVHST1-CDAT,
               SY-UZEIT           TO     ZTIVHST1-CTME,
               FISCALYEAR         TO     ZTIVHST1-GJAHR,
               INVOICEDOCNUMBER   TO     ZTIVHST1-BELNR.

        SELECT MAX( ZFCIVHST ) INTO ZTIVHST1-ZFCIVHST
               FROM   ZTIVHST1
               WHERE  ZFIVNO    EQ    P_ZFIVNO.

        ADD    1                 TO    ZTIVHST1-ZFCIVHST.

        INSERT   ZTIVHST1.

        IF NOT ZTIV-ZFIVHST IS INITIAL.
           UPDATE ZTIVHST
                  SET  ZFIVHST  =  ZTIVHST1-ZFCIVHST
                  WHERE ZFIVNO  =  ZTIV-ZFIVNO
                  AND   ZFIVHST =  ZTIV-ZFIVHST.
        ENDIF.

        MOVE : ZTIVHST1-ZFCIVHST TO    ZTIV-ZFCIVHST.

        UPDATE   ZTIV.

     ELSE.
        RAISE   LIV_ERROR.
     ENDIF.
  ELSE.
     IF NOT RETURN[] IS INITIAL.        "> ERROR
        RAISE   LIV_ERROR.
     ENDIF.
  ENDIF.

ENDFUNCTION.
