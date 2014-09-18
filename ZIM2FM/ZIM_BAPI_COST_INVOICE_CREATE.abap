FUNCTION ZIM_BAPI_COST_INVOICE_CREATE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(P_ZFREQNO) LIKE  ZTRECST-ZFREQNO
*"     VALUE(P_ZFCLSEQ) LIKE  ZTCUCLCST-ZFCLSEQ DEFAULT '00000'
*"     VALUE(P_ZFCSQ) LIKE  ZTRECST-ZFCSQ
*"     VALUE(P_ZFIMDTY) LIKE  ZTIVCD-ZFIMDTY
*"     VALUE(P_CHG_MODE) TYPE  C DEFAULT 'X'
*"     VALUE(P_DOC_TYPE) TYPE  BAPI_INCINV_CREATE_HEADER-DOC_TYPE
*"       DEFAULT 'RE'
*"     VALUE(I_INVOICE) LIKE  RBKP-XRECH DEFAULT 'X'
*"     VALUE(I_CREDITMEMO) LIKE  RBKP-XRECH DEFAULT ' '
*"     VALUE(P_BLDAT) LIKE  MKPF-BLDAT DEFAULT SY-DATUM
*"     VALUE(P_BUDAT) LIKE  MKPF-BUDAT DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(INVOICEDOCNUMBER) LIKE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(FISCALYEAR) LIKE  BAPI_INCINV_FLD-FISC_YEAR
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2
*"  EXCEPTIONS
*"      LIV_ERROR
*"----------------------------------------------------------------------
   CLEAR : INVOICEDOCNUMBER, FISCALYEAR,
           HEADERDATA, ITEMDATA,
           TAXDATA,
*-----------------------------------------------------------
*> dreamland remark.
*-----------------------------------------------------------
*           WITHTAXDATA,
*           VENDORITEMSPLITDATA,
*-----------------------------------------------------------

           RETURN,
           ZTREQHD, ZTBL.

DATA : BEGIN OF IT_PO_DATA OCCURS 0,
       EBELN      LIKE   EKPO-EBELN,
       EBELP      LIKE   EKPO-EBELP,
       MENGE      LIKE   EKPO-MENGE,
       MEINS      LIKE   EKPO-MEINS,
       PEINH      LIKE   EKPO-PEINH,
       BPRME      LIKE   EKPO-BPRME,
       NETPR      LIKE   EKPO-NETPR,
       AMOUNT     LIKE   ZTBL-ZFBLAMT,
       WAERS      LIKE   EKKO-WAERS,
       MWSKZ      LIKE   ZTRECST-MWSKZ,
       BPUMN      LIKE   EKPO-BPUMN,
       BPUMZ      LIKE   EKPO-BPUMZ,
       END OF IT_PO_DATA.

DATA : W_AMOUNT       LIKE   ZTBL-ZFBLAMT,
       W_AMOUNT_PO    LIKE   ZTBL-ZFBLAMT,
       W_AMOUNT_SUM   LIKE   ZTBL-ZFBLAMT,
       W_ZFCAMT       LIKE   ZTBL-ZFBLAMT,
       W_ZFCAMT_SUM   LIKE   ZTBL-ZFBLAMT,
       W_ZFCSCD       LIKE   ZTRECST-ZFCSCD,
       W_ZFCDTY       LIKE   ZTIMIMG08-ZFCDTY,
       W_MWSKZ        LIKE   ZTRECST-MWSKZ,
       W_ZTERM        LIKE   ZTRECST-ZTERM,
       W_EBELN        LIKE   EKKO-EBELN.


   REFRESH : ITEMDATA, TAXDATA,
*-----------------------------------------------------------
*> dreamland remark.
*-----------------------------------------------------------
*             WITHTAXDATA,
*             VENDORITEMSPLITDATA,
*-----------------------------------------------------------
             RETURN, IT_PO_DATA.

*>> KEY VALUE CHECK..
   IF P_ZFREQNO IS INITIAL.
      MESSAGE E912  RAISING  LIV_ERROR.
   ENDIF.
   IF P_ZFCSQ IS INITIAL.
      MESSAGE E911  RAISING  LIV_ERROR.
   ENDIF.
*>> ���� ���� ...
   IF P_ZFIMDTY IS INITIAL.
      MESSAGE E913  RAISING  LIV_ERROR.
   ENDIF.

*-----------------------------------------------------------------------
*>>> Fixed value text
*-----------------------------------------------------------------------
   PERFORM   GET_DD07T_SELECT USING      'ZDIMDTY'  P_ZFIMDTY
                              CHANGING   W_TEXT70.

   W_AMOUNT  =  0.
   CASE P_ZFIMDTY.
*-----------------------------------------------------------------------
*>>> �����Ƿ�.
*-----------------------------------------------------------------------
      WHEN 'RD'.       ">�����Ƿ�.
         CALL FUNCTION 'ENQUEUE_EZ_IM_ZTREQDOC'
              EXPORTING
                  ZFREQNO                =     P_ZFREQNO
                  ZFAMDNO                =     '00000'
              EXCEPTIONS
                  OTHERS                 =     1.
         IF SY-SUBRC NE 0.
             MESSAGE E510 WITH SY-MSGV1 'Import Document'
                               P_ZFREQNO '00000'
                          RAISING  LIV_ERROR.
         ENDIF.

         SELECT SINGLE * FROM ZTRECST
                         WHERE ZFREQNO EQ P_ZFREQNO
                         AND   ZFCSQ   EQ P_ZFCSQ.
         IF SY-SUBRC NE 0.
            MESSAGE E431 WITH W_TEXT70 P_ZFREQNO P_ZFCSQ
                         RAISING  LIV_ERROR.
         ENDIF.
*>> ����ڵ�.
         W_ZFCSCD = ZTRECST-ZFCSCD.        "> ����ڵ�.
         W_ZFCDTY = '003'.                 "> ��� Ÿ��.
         W_ZFCAMT = ZTRECST-ZFCAMT.        "> �ݾ�.
         W_ZTERM  = ZTRECST-ZTERM.         "> Terms of Payment.
         W_MWSKZ  = ZTRECST-MWSKZ.         "> TAX CODE.

         WRITE ZTRECST-ZFCAMT TO  W_TEXT_AMOUNT
               CURRENCY  ZTRECST-WAERS.
         PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

         SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSREQIT
                  FROM ZTREQIT
                  WHERE ZFREQNO EQ P_ZFREQNO.
*>> HEADER DATA
         MOVE : ZTRECST-ZTERM   TO  HEADERDATA-PMNTTRMS,
                ZTRECST-BUKRS   TO  HEADERDATA-COMP_CODE,    ">ȸ���ڵ�.
                ZTRECST-ZFPAY   TO  HEADERDATA-DIFF_INV,     ">�������
                W_TEXT_AMOUNT   TO  HEADERDATA-GROSS_AMOUNT, ">�ѱݾ�.
                ZTRECST-WAERS   TO  HEADERDATA-CURRENCY,     ">��ȭ����.
                'B'             TO  HEADERDATA-PMNT_BLOCK.   ">����Ű.

*>>> ȯ��.
         IF ZTRECST-WAERS NE 'KRW'.
            MOVE: ZTRECST-ZFEXRT
                            TO  HEADERDATA-EXCH_RATE,    ">����ȣ��ȯ��.
                  ZTRECST-ZFEXRT
                            TO  HEADERDATA-EXCH_RATE_V.  ">����ȣ��ȯ��.
         ENDIF.

*-----------------------------------------------------------------------
         CLEAR : W_EBELN.
         LOOP AT IT_ZSREQIT.
            CLEAR : IT_PO_DATA.
            IF W_EBELN NE IT_ZSREQIT-EBELN.

            ENDIF.

            MOVE : IT_ZSREQIT-EBELN   TO   IT_PO_DATA-EBELN,
                   IT_ZSREQIT-ZFITMNO TO   IT_PO_DATA-EBELP,
                   IT_ZSREQIT-MENGE   TO   IT_PO_DATA-MENGE,
                   IT_ZSREQIT-MEINS   TO   IT_PO_DATA-MEINS,
                   IT_ZSREQIT-NETPR   TO   IT_PO_DATA-NETPR,
                   IT_ZSREQIT-PEINH   TO   IT_PO_DATA-PEINH,
                   IT_ZSREQIT-BPRME   TO   IT_PO_DATA-BPRME,
                   ZTRECST-WAERS      TO   IT_PO_DATA-WAERS,
                   ZTRECST-MWSKZ      TO   IT_PO_DATA-MWSKZ.

            SELECT SINGLE BPUMN BPUMZ
                   INTO (IT_PO_DATA-BPUMN, IT_PO_DATA-BPUMZ)
                   FROM EKPO
                   WHERE EBELN   EQ    IT_PO_DATA-EBELN
                   AND   EBELP   EQ    IT_PO_DATA-EBELP.

            IT_PO_DATA-AMOUNT =
                   ( ( IT_PO_DATA-NETPR / IT_PO_DATA-PEINH )
                   * ( IT_PO_DATA-BPUMZ / IT_PO_DATA-BPUMN )
                     * IT_PO_DATA-MENGE ).

            W_AMOUNT_PO = W_AMOUNT_PO + IT_PO_DATA-AMOUNT.

            APPEND  IT_PO_DATA.

            MOVE W_EBELN    TO    IT_ZSREQIT-EBELN.
         ENDLOOP.
*-----------------------------------------------------------------------
*>>> B/L ���.
*-----------------------------------------------------------------------
      WHEN 'BL'.       "> B/L ���.
         CALL FUNCTION 'ENQUEUE_EZ_IM_ZTBLDOC'
              EXPORTING
                  ZFBLNO                =     P_ZFREQNO
              EXCEPTIONS
                  OTHERS                 =     1.
         IF SY-SUBRC NE 0.
             MESSAGE E510 WITH SY-MSGV1 'B/L Document'
                               P_ZFREQNO '00000'
                          RAISING  LIV_ERROR.
         ENDIF.

         SELECT SINGLE * FROM ZTBLCST
                         WHERE ZFBLNO  EQ P_ZFREQNO
                         AND   ZFCSQ   EQ P_ZFCSQ.
         IF SY-SUBRC NE 0.
            MESSAGE E431 WITH W_TEXT70 P_ZFREQNO P_ZFCSQ
                         RAISING  LIV_ERROR.
         ENDIF.
*>> ����ڵ�.
         W_ZFCSCD = ZTBLCST-ZFCSCD.        "> ����ڵ�.
         IF P_ZFCSQ GT '10000'.
            W_ZFCDTY = '004'.              "> �ؿܿ���.
         ELSE.
            W_ZFCDTY = '005'.              "> ��Ÿ���.
         ENDIF.
         W_ZFCAMT = ZTBLCST-ZFCAMT.        "> �ݾ�.
         W_ZTERM  = ZTBLCST-ZTERM.         "> Terms of Payment.
         W_MWSKZ  = ZTBLCST-MWSKZ.         "> TAX CODE.

         WRITE W_ZFCAMT TO  W_TEXT_AMOUNT
               CURRENCY  ZTBLCST-WAERS.
         PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

         SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBLIT
                  FROM ZTBLIT
                  WHERE ZFBLNO  EQ P_ZFREQNO.
*>> HEADER DATA
         MOVE : ZTBLCST-ZTERM   TO  HEADERDATA-PMNTTRMS,
                ZTBLCST-BUKRS   TO  HEADERDATA-COMP_CODE,    ">ȸ���ڵ�.
                ZTBLCST-ZFPAY   TO  HEADERDATA-DIFF_INV,     ">�������
                W_TEXT_AMOUNT   TO  HEADERDATA-GROSS_AMOUNT, ">�ѱݾ�.
                ZTBLCST-WAERS   TO  HEADERDATA-CURRENCY,     ">��ȭ����.
                'B'             TO  HEADERDATA-PMNT_BLOCK.   ">����Ű.

*>>> ȯ��.
         IF ZTBLCST-WAERS NE 'KRW'.
            MOVE: ZTBLCST-ZFEXRT
                            TO  HEADERDATA-EXCH_RATE,    ">����ȣ��ȯ��.
                  ZTBLCST-ZFEXRT
                            TO  HEADERDATA-EXCH_RATE_V.  ">����ȣ��ȯ��.
         ENDIF.

*-----------------------------------------------------------------------
         CLEAR : W_EBELN.
         LOOP AT IT_ZSBLIT.
            CLEAR : IT_PO_DATA.
            IF W_EBELN NE IT_ZSBLIT-EBELN.

            ENDIF.

            MOVE : IT_ZSBLIT-EBELN     TO   IT_PO_DATA-EBELN,
                   IT_ZSBLIT-EBELP     TO   IT_PO_DATA-EBELP,
                   IT_ZSBLIT-BLMENGE   TO   IT_PO_DATA-MENGE,
                   IT_ZSBLIT-MEINS     TO   IT_PO_DATA-MEINS,
                   IT_ZSBLIT-NETPR     TO   IT_PO_DATA-NETPR,
                   IT_ZSBLIT-PEINH     TO   IT_PO_DATA-PEINH,
                   IT_ZSBLIT-BPRME     TO   IT_PO_DATA-BPRME,
                   ZTBLCST-WAERS       TO   IT_PO_DATA-WAERS,
                   ZTBLCST-MWSKZ       TO   IT_PO_DATA-MWSKZ.

            SELECT SINGLE BPUMN BPUMZ
                   INTO (IT_PO_DATA-BPUMN, IT_PO_DATA-BPUMZ)
                   FROM EKPO
                   WHERE EBELN   EQ    IT_PO_DATA-EBELN
                   AND   EBELP   EQ    IT_PO_DATA-EBELP.

            IT_PO_DATA-AMOUNT =
                   ( ( IT_PO_DATA-NETPR / IT_PO_DATA-PEINH )
                   * ( IT_PO_DATA-BPUMZ / IT_PO_DATA-BPUMN )
                     * IT_PO_DATA-MENGE ).
            W_AMOUNT_PO = W_AMOUNT_PO + IT_PO_DATA-AMOUNT.

            APPEND  IT_PO_DATA.

            MOVE W_EBELN    TO    IT_ZSBLIT-EBELN.
         ENDLOOP.
*-----------------------------------------------------------------------
*>>> �Ͽ� ���.
*-----------------------------------------------------------------------
      WHEN 'CW'.       "> �Ͽ� ���.
         CALL FUNCTION 'ENQUEUE_EZ_IM_ZTCGHD'
              EXPORTING
                  ZFCGNO                =     P_ZFREQNO
              EXCEPTIONS
                  OTHERS                 =     1.
         IF SY-SUBRC NE 0.
             MESSAGE E510 WITH SY-MSGV1 '�Ͽ� Document'
                               P_ZFREQNO '00000'
                          RAISING  LIV_ERROR.
         ENDIF.

         SELECT SINGLE * FROM ZTCGCST
                         WHERE ZFCGNO  EQ P_ZFREQNO
                         AND   ZFCSQ   EQ P_ZFCSQ.
         IF SY-SUBRC NE 0.
            MESSAGE E431 WITH W_TEXT70 P_ZFREQNO P_ZFCSQ
                         RAISING  LIV_ERROR.
         ENDIF.
*>> ����ڵ�.
         W_ZFCSCD = ZTCGCST-ZFCSCD.        "> ����ڵ�.
         W_ZFCDTY = '007'.                 "> �ؿܿ���.
         W_ZFCAMT = ZTCGCST-ZFCKAMT.       "> �ݾ�.
         W_ZTERM  = ZTCGCST-ZTERM.         "> Terms of Payment.
         W_MWSKZ  = ZTCGCST-MWSKZ.         "> TAX CODE.

         SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSCGIT
                  FROM ZTCGIT
                  WHERE ZFCGNO  EQ P_ZFREQNO.

         WRITE W_ZFCAMT TO  W_TEXT_AMOUNT
               CURRENCY  ZTCGCST-ZFKRW.
         PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

*>> HEADER DATA
         MOVE : ZTCGCST-ZTERM   TO  HEADERDATA-PMNTTRMS,
                ZTCGCST-BUKRS   TO  HEADERDATA-COMP_CODE,    ">ȸ���ڵ�.
                ZTCGCST-ZFPAY   TO  HEADERDATA-DIFF_INV,     ">�������
                W_TEXT_AMOUNT   TO  HEADERDATA-GROSS_AMOUNT, ">�ѱݾ�.
*               'USD'           TO  HEADERDATA-CURRENCY,     ">��ȭ����.
                ZTCGCST-ZFKRW   TO  HEADERDATA-CURRENCY,     ">��ȭ����.
                'B'             TO  HEADERDATA-PMNT_BLOCK.   ">����Ű.

*>>> ȯ��.
*         IF ZTCGCST-ZFKRW NE 'KRW'.
*           MOVE: ZTCGCST-ZFEXRT
*                           TO  HEADERDATA-EXCH_RATE,    ">����ȣ��ȯ��.
*                 ZTCGCST-ZFEXRT
*                           TO  HEADERDATA-EXCH_RATE_V.  ">����ȣ��ȯ��.
*        ENDIF.

*-----------------------------------------------------------------------
         CLEAR : W_EBELN.
         LOOP AT IT_ZSCGIT.
            CLEAR : IT_PO_DATA.
            IF W_EBELN NE IT_ZSCGIT-EBELN.

            ENDIF.
            MOVE : IT_ZSCGIT-EBELN     TO   IT_PO_DATA-EBELN,
                   IT_ZSCGIT-EBELP     TO   IT_PO_DATA-EBELP,
                   IT_ZSCGIT-CGMENGE   TO   IT_PO_DATA-MENGE,
                   IT_ZSCGIT-MEINS     TO   IT_PO_DATA-MEINS,
                   IT_ZSCGIT-NETPR     TO   IT_PO_DATA-NETPR,
                   IT_ZSCGIT-PEINH     TO   IT_PO_DATA-PEINH,
                   IT_ZSCGIT-BPRME     TO   IT_PO_DATA-BPRME,
                   ZTCGCST-ZFKRW       TO   IT_PO_DATA-WAERS,
                   ZTCGCST-MWSKZ       TO   IT_PO_DATA-MWSKZ.

            SELECT SINGLE BPUMN BPUMZ
                   INTO (IT_PO_DATA-BPUMN, IT_PO_DATA-BPUMZ)
                   FROM EKPO
                   WHERE EBELN   EQ    IT_PO_DATA-EBELN
                   AND   EBELP   EQ    IT_PO_DATA-EBELP.

            IT_PO_DATA-AMOUNT =
                   ( ( IT_PO_DATA-NETPR / IT_PO_DATA-PEINH )
                   * ( IT_PO_DATA-BPUMZ / IT_PO_DATA-BPUMN )
                     * IT_PO_DATA-MENGE ).
            W_AMOUNT_PO = W_AMOUNT_PO + IT_PO_DATA-AMOUNT.

            APPEND  IT_PO_DATA.

            MOVE W_EBELN    TO    IT_ZSCGIT-EBELN.
         ENDLOOP.

*-----------------------------------------------------------------------
*>>> ��� ���.
*-----------------------------------------------------------------------
      WHEN 'CC'.       "> ��� ���.
         CALL FUNCTION 'ENQUEUE_EZ_IM_ZTCUCL'
              EXPORTING
                  ZFBLNO                =     P_ZFREQNO
                  ZFCLSEQ               =     P_ZFCLSEQ
              EXCEPTIONS
                  OTHERS                =     1.
         IF SY-SUBRC NE 0.
             MESSAGE E510 WITH SY-MSGV1 '��� Document'
                               P_ZFREQNO P_ZFCLSEQ
                          RAISING  LIV_ERROR.
         ENDIF.

         SELECT SINGLE * FROM ZTCUCLCST
                         WHERE ZFBLNO  EQ P_ZFREQNO
                         AND   ZFCLSEQ EQ P_ZFCLSEQ
                         AND   ZFCSQ   EQ P_ZFCSQ.
         IF SY-SUBRC NE 0.
            MESSAGE E431 WITH W_TEXT70 P_ZFREQNO P_ZFCSQ
                         RAISING  LIV_ERROR.
         ENDIF.
*>> ����ڵ�.
         W_ZFCSCD = ZTCUCLCST-ZFCSCD.        "> ����ڵ�.
         W_ZFCDTY = '006'.                   "> �ؿܿ���.
         W_ZFCAMT = ZTCUCLCST-ZFCAMT.        "> �ݾ�.
*         W_ZFCAMT = ZTCUCLCST-ZFCAMT * 100.  "> �ݾ�.
         W_ZTERM  = ZTCUCLCST-ZTERM.         "> Terms of Payment.
         W_MWSKZ  = ZTCUCLCST-MWSKZ.         "> TAX CODE.

         WRITE W_ZFCAMT TO  W_TEXT_AMOUNT
               CURRENCY  ZTCUCLCST-ZFKRW.
         PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

         SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIVIT
                  FROM ZTIVIT
                  WHERE ZFIVNO  IN (
                        SELECT ZFIVNO FROM ZTCUCLIV
                               WHERE ZFBLNO  EQ  P_ZFREQNO
                               AND   ZFCLSEQ EQ  P_ZFCLSEQ ).

*>> HEADER DATA
         MOVE : ZTCUCLCST-ZTERM   TO  HEADERDATA-PMNTTRMS,
                ZTCUCLCST-BUKRS   TO  HEADERDATA-COMP_CODE,    ">ȸ���ڵ
                ZTCUCLCST-ZFPAY   TO  HEADERDATA-DIFF_INV,     ">������
                W_TEXT_AMOUNT     TO  HEADERDATA-GROSS_AMOUNT, ">�ѱݾ�.
                ZTCUCLCST-ZFKRW   TO  HEADERDATA-CURRENCY,     ">��ȭ���
                'B'               TO  HEADERDATA-PMNT_BLOCK.   ">����Ű.



*>>> ȯ��.
*         IF ZTCUCLCST-WAERS NE 'KRW'.
*           MOVE: ZTCUCLCST-ZFEXRT
*                           TO  HEADERDATA-EXCH_RATE,    ">����ȣ��ȯ��.
*                 ZTCUCLCST-ZFEXRT
*                           TO  HEADERDATA-EXCH_RATE_V.  ">����ȣ��ȯ��.
*        ENDIF.

*-----------------------------------------------------------------------
         CLEAR : W_EBELN.
         LOOP AT IT_ZSIVIT.
            CLEAR : IT_PO_DATA.
            IF W_EBELN NE IT_ZSIVIT-EBELN.

            ENDIF.
            MOVE : IT_ZSIVIT-EBELN   TO   IT_PO_DATA-EBELN,
                   IT_ZSIVIT-EBELP   TO   IT_PO_DATA-EBELP,
                   IT_ZSIVIT-CCMENGE TO   IT_PO_DATA-MENGE,
                   IT_ZSIVIT-MEINS   TO   IT_PO_DATA-MEINS,
                   IT_ZSIVIT-NETPR   TO   IT_PO_DATA-NETPR,
                   IT_ZSIVIT-PEINH   TO   IT_PO_DATA-PEINH,
                   IT_ZSIVIT-BPRME   TO   IT_PO_DATA-BPRME,
                   ZTCUCLCST-ZFKRW   TO   IT_PO_DATA-WAERS,
                   ZTCUCLCST-MWSKZ   TO   IT_PO_DATA-MWSKZ.

            SELECT SINGLE BPUMN BPUMZ
                   INTO (IT_PO_DATA-BPUMN, IT_PO_DATA-BPUMZ)
                   FROM EKPO
                   WHERE EBELN   EQ    IT_PO_DATA-EBELN
                   AND   EBELP   EQ    IT_PO_DATA-EBELP.

            IT_PO_DATA-AMOUNT =
                   ( ( IT_PO_DATA-NETPR / IT_PO_DATA-PEINH )
                   * ( IT_PO_DATA-BPUMZ / IT_PO_DATA-BPUMN )
                   *   IT_PO_DATA-MENGE ).
            W_AMOUNT_PO = W_AMOUNT_PO + IT_PO_DATA-AMOUNT.

            APPEND  IT_PO_DATA.

            MOVE W_EBELN    TO    IT_ZSIVIT-EBELN.
         ENDLOOP.

*-----------------------------------------------------------------------
*>> ��Ÿ ���.
*-----------------------------------------------------------------------
      WHEN OTHERS.
         MESSAGE E432 WITH P_ZFIMDTY W_TEXT70 RAISING  LIV_ERROR.
   ENDCASE.

*-----------------------------------------------------------------------
*>> ����ڵ� ����.
*-----------------------------------------------------------------------
   SELECT SINGLE * FROM ZTIMIMG08
                   WHERE ZFCDTY   EQ    W_ZFCDTY
                   AND   ZFCD     EQ    W_ZFCSCD.

   IF SY-SUBRC NE 0.
      MESSAGE  E430 WITH W_TEXT70 W_ZFCSCD RAISING  LIV_ERROR.
   ENDIF.
   IF ZTIMIMG08-ZFCD1 NE 'Y'.
      MESSAGE  E434 WITH W_TEXT70 W_ZFCSCD RAISING  LIV_ERROR.
   ENDIF.
   IF ZTIMIMG08-COND_TYPE IS INITIAL.
      MESSAGE E435 WITH W_TEXT70 W_ZFCSCD RAISING  LIV_ERROR.
   ENDIF.

*-----------------------------------------------------------------------
*>> ���� �۾�.
*-----------------------------------------------------------------------
   CLEAR : W_AMOUNT_SUM, W_LINE.
   LOOP AT IT_PO_DATA.
      W_TABIX = SY-TABIX.
      IT_PO_DATA-AMOUNT = ( IT_PO_DATA-AMOUNT / W_AMOUNT_PO )
                          * W_ZFCAMT.
      W_ZFCAMT_SUM = W_ZFCAMT_SUM + IT_PO_DATA-AMOUNT.
      MODIFY IT_PO_DATA  INDEX  W_TABIX.
   ENDLOOP.
   IF W_ZFCAMT_SUM NE W_ZFCAMT.
      READ TABLE  IT_PO_DATA  INDEX  W_TABIX.
      IF SY-SUBRC EQ 0.
         IF W_ZFCAMT_SUM GT W_ZFCAMT.
            IT_PO_DATA-AMOUNT = IT_PO_DATA-AMOUNT -
                                (  W_ZFCAMT_SUM - W_ZFCAMT ).
         ELSE.
            IT_PO_DATA-AMOUNT = IT_PO_DATA-AMOUNT +
                                (  W_ZFCAMT - W_ZFCAMT_SUM ).
         ENDIF.
         MODIFY   IT_PO_DATA  INDEX   W_TABIX.
      ENDIF.
   ENDIF.

*-----------------------------------------------------------------------
   W_TEXT_AMOUNT1 = W_TEXT_AMOUNT.
*-----------------------------------------------------------------------
*>> ITEM LEVEL CHECK.
   W_LINE = 0.
   LOOP AT IT_PO_DATA.
      IF NOT IT_PO_DATA-EBELN IS INITIAL.
*>> P/O ����(HEADER).
         SELECT SINGLE * FROM  EKKO              ">P/O HEADER CHECK..
                  WHERE EBELN EQ IT_PO_DATA-EBELN.
         IF EKKO-LOEKZ NE SPACE.       ">������ũ ����.
            MESSAGE E005 WITH IT_PO_DATA-EBELN  RAISING  LIV_ERROR.
         ENDIF.

*>> P/O ����(ITEMS).
         SELECT SINGLE * FROM  EKPO              "> P/O ITEM CHECK..
                         WHERE EBELN EQ IT_PO_DATA-EBELN
                         AND   EBELP EQ IT_PO_DATA-EBELP.
         IF EKPO-LOEKZ NE SPACE.       ">������ũ ����.
            MESSAGE E069 WITH IT_PO_DATA-EBELN IT_PO_DATA-EBELP
                         RAISING  LIV_ERROR.
         ENDIF.
*         IF EKPO-ELIKZ NE SPACE.       ">��ǰ�Ϸ� ����.
*            MESSAGE E359 WITH IT_PO_DATA-EBELN IT_PO_DATA-EBELP
*                         RAISING  LIV_ERROR.
*         ENDIF.
      ELSE.
         MESSAGE E003  RAISING  LIV_ERROR.
      ENDIF.
      CLEAR : KONV.
      SELECT * FROM KONV UP TO 1 ROWS
               WHERE KNUMV   EQ     EKKO-KNUMV
               AND   KPOSN   EQ     EKPO-EBELP
               AND   KSCHL   EQ     ZTIMIMG08-COND_TYPE.
*               AND   KNTYP   EQ     'B'.
      ENDSELECT.

      CLEAR : ITEMDATA.
      ADD    1    TO     W_LINE.

      WRITE IT_PO_DATA-AMOUNT TO  W_TEXT_AMOUNT
            CURRENCY  HEADERDATA-CURRENCY.
      PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.

      MOVE : W_LINE                 TO  ITEMDATA-INVOICE_DOC_ITEM,
             IT_PO_DATA-EBELN       TO  ITEMDATA-PO_NUMBER,
             IT_PO_DATA-EBELP       TO  ITEMDATA-PO_ITEM,
             SPACE                  TO  ITEMDATA-REF_DOC,
             SPACE                  TO  ITEMDATA-REF_DOC_YEAR,
             SPACE                  TO  ITEMDATA-REF_DOC_IT,
             SPACE                  TO  ITEMDATA-DE_CRE_IND,
             IT_PO_DATA-MWSKZ       TO  ITEMDATA-TAX_CODE,
             SPACE                  TO  ITEMDATA-TAXJURCODE,
*             IT_PO_DATA-AMOUNT      TO  ITEMDATA-ITEM_AMOUNT,
             W_TEXT_AMOUNT          TO  ITEMDATA-ITEM_AMOUNT,
             IT_PO_DATA-MENGE       TO  ITEMDATA-QUANTITY,
             IT_PO_DATA-MEINS       TO  ITEMDATA-PO_UNIT,
             SPACE                  TO  ITEMDATA-PO_UNIT_ISO,
*             IT_PO_DATA-PEINH       TO  ITEMDATA-PO_PR_QNT,
             IT_PO_DATA-BPRME       TO  ITEMDATA-PO_PR_UOM,
             SPACE                  TO  ITEMDATA-PO_PR_UOM_ISO,
*             ZTIMIMG08-COND_TYPE    TO  ITEMDATA-COND_TYPE,
             KONV-STUNR             TO  ITEMDATA-COND_ST_NO,
             KONV-ZAEHK             TO  ITEMDATA-COND_COUNT.
*-----------------------------------------------------------
*> dreamland remark.
*-----------------------------------------------------------
*             SPACE                  TO  ITEMDATA-SHEET_NO.
*-----------------------------------------------------------
      APPEND ITEMDATA.
   ENDLOOP.

*>> TAX DATA.
   CLEAR : TAXDATA.
   MOVE : W_MWSKZ   TO   TAXDATA-TAX_CODE.
   APPEND  TAXDATA.

*-----------------------------------------------------------
*> dreamland remark.
*-----------------------------------------------------------
*   CLEAR : VENDORITEMSPLITDATA.
*   MOVE : 1               TO   VENDORITEMSPLITDATA-SPLIT_KEY,
*          W_TEXT_AMOUNT1  TO   VENDORITEMSPLITDATA-SPLIT_AMOUNT,
*          SPACE           TO   VENDORITEMSPLITDATA-PYMT_METH,
*          W_MWSKZ         TO   VENDORITEMSPLITDATA-TAX_CODE,
*          SPACE           TO   VENDORITEMSPLITDATA-PMTMTHSUPL,
*          W_ZTERM         TO   VENDORITEMSPLITDATA-PMNTTRMS.
*
*   APPEND  VENDORITEMSPLITDATA.
*-----------------------------------------------------------

*>> �����Ƿڰ� SELECT.
   READ TABLE  IT_ZSCIVIT INDEX 1.
   IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZTREQHD
                      WHERE ZFREQNO  EQ  IT_ZSCIVIT-ZFREQNO.
   ENDIF.


*-----------------------------------------------------------------------
*>> HEADER DATA.
*   IF NOT I_INVOICE IS INITIAL.
*      MOVE : 'X'         TO  HEADERDATA-INVOICE_IND. ">������/��������.
*   ELSEIF NOT I_CREDITMEMO IS INITIAL.
*      MOVE : SPACE       TO  HEADERDATA-INVOICE_IND. ">������/��������.
*   ELSE.
*      MOVE : 'X'         TO  HEADERDATA-INVOICE_IND. ">������/��������.
*   ENDIF.

   MOVE : P_DOC_TYPE      TO  HEADERDATA-DOC_TYPE,     ">����Ÿ��.
          P_BLDAT         TO  HEADERDATA-DOC_DATE,     ">������.
          P_BUDAT         TO  HEADERDATA-PSTNG_DATE,   ">������.
          P_BLDAT         TO  HEADERDATA-BLINE_DATE,   ">�����.
          SY-UNAME        TO  HEADERDATA-PERSON_EXT,   ">�ܺλ����.
          'ref no'        TO  HEADERDATA-REF_DOC_NO,   ">����������ȣ.
          'header'        TO  HEADERDATA-HEADER_TXT,   ">��ǥ����ؽ�Ʈ.
          P_BLDAT         TO  HEADERDATA-BLINE_DATE,   ">�����.
          0               TO  HEADERDATA-DSCT_DAYS1,   ">�������αⰣ1.
          0               TO  HEADERDATA-DSCT_DAYS2,   ">�������αⰣ2.
          0               TO  HEADERDATA-NETTERMS,   ">�����������ǱⰣ.
          0               TO  HEADERDATA-DSCT_PCT1,    ">���������� 1.
          0               TO  HEADERDATA-DSCT_PCT2,    ">���������� 2.
          SPACE           TO  HEADERDATA-IV_CATEGORY.  ">�����������.

*-----------------------------------------------------------------------
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
     CASE P_ZFIMDTY.
        WHEN 'RD'.         ">�����Ƿ� ���.
           SELECT SINGLE * FROM ZTRECST
                           WHERE ZFREQNO   EQ    P_ZFREQNO
                           AND   ZFCSQ     EQ    P_ZFCSQ.

           MOVE : FISCALYEAR         TO     ZTRECST-ZFFIYR,
                  INVOICEDOCNUMBER   TO     ZTRECST-ZFACDO,
                  SY-UNAME           TO     ZTRECST-UNAM,
                  SY-DATUM           TO     ZTRECST-UDAT,
                  P_BLDAT            TO     ZTRECST-ZFOCDT,
                  P_BUDAT            TO     ZTRECST-ZFPSDT.

           UPDATE ZTRECST.

           CALL FUNCTION 'DEQUEUE_EZ_IM_ZTREQDOC'
                EXPORTING
                   ZFREQNO           =     P_ZFREQNO
                   ZFAMDNO           =     '00000'.

        WHEN 'BL'.         ">B/L ���.
           SELECT SINGLE * FROM ZTBLCST
                           WHERE ZFBLNO    EQ    P_ZFREQNO
                           AND   ZFCSQ     EQ    P_ZFCSQ.

           MOVE : FISCALYEAR         TO     ZTBLCST-ZFFIYR,
                  INVOICEDOCNUMBER   TO     ZTBLCST-ZFACDO,
                  SY-UNAME           TO     ZTBLCST-UNAM,
                  SY-DATUM           TO     ZTBLCST-UDAT,
                  P_BLDAT            TO     ZTBLCST-ZFOCDT,
                  P_BUDAT            TO     ZTBLCST-ZFPSDT.

           UPDATE ZTBLCST.

           CALL FUNCTION 'DEQUEUE_EZ_IM_ZTBLDOC'
                EXPORTING
                   ZFBLNO           =     P_ZFREQNO.

        WHEN 'CW'.         ">�Ͽ� ���.
           SELECT SINGLE * FROM ZTCGCST
                           WHERE ZFCGNO    EQ    P_ZFREQNO
                           AND   ZFCSQ     EQ    P_ZFCSQ.

           MOVE : FISCALYEAR         TO     ZTCGCST-GJAHR,
                  INVOICEDOCNUMBER   TO     ZTCGCST-BELNR,
                  SY-UNAME           TO     ZTCGCST-UNAM,
                  SY-DATUM           TO     ZTCGCST-UDAT,
                  P_BLDAT            TO     ZTCGCST-ZFOCDT,
                  P_BUDAT            TO     ZTCGCST-ZFPSDT.

           UPDATE ZTCGCST.

           CALL FUNCTION 'DEQUEUE_EZ_IM_ZTCGHD'
                EXPORTING
                   ZFCGNO           =     P_ZFREQNO.

        WHEN 'CC'.         ">��� ���.

           SELECT SINGLE * FROM ZTCUCLCST
                           WHERE ZFBLNO    EQ    P_ZFREQNO
                           AND   ZFCLSEQ   EQ    P_ZFCLSEQ
                           AND   ZFCSQ     EQ    P_ZFCSQ.

           MOVE : FISCALYEAR         TO     ZTCUCLCST-ZFFIYR,
                  INVOICEDOCNUMBER   TO     ZTCUCLCST-ZFACDO,
                  SY-UNAME           TO     ZTCUCLCST-UNAM,
                  SY-DATUM           TO     ZTCUCLCST-UDAT,
                  P_BLDAT            TO     ZTCUCLCST-ZFOCDT,
                  P_BUDAT            TO     ZTCUCLCST-ZFPSDT.

           UPDATE ZTCUCLCST.
*-----------------------------------------------------------------------
*<<< ������ �ΰ��� BDC.
*--------------------------------------------------------------------
*           TEMP_WRBTR = IT_SELECTED-ZFCKAMT + IT_SELECTED-ZFVAT.
*           WRITE W_WRBTR CURRENCY 'KRW' TO TEMP_WRBTR.
*           WRITE IT_SELECTED-ZFVAT CURRENCY 'KRW' TO TEMP_WMWST.
*           CLEAR : ZVT001W.
*           SELECT SINGLE * FROM ZVT001W
*                  WHERE WERKS EQ IT_SELECTED-ZFWERKS.
*>> ����ó�� �ٸ� ���.
*           IF NOT ( IT_SELECTED-ZFPAY IS INITIAL ) AND
*                  ( IT_SELECTED-ZFVEN NE IT_SELECTED-ZFPAY ).
*              L_ZFPAY  =  IT_SELECTED-ZFPAY. " Payee
*           ELSE.
*              CLEAR L_ZFPAY.
*           ENDIF.
*
*           REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
*           PERFORM P2000_DYNPRO USING :
*              'X' 'SAPMF05A'    '0100',
*              ' ' 'BKPF-BLDAT'   W_DOCDT,            " Document Date
*              ' ' 'BKPF-BLART'  'KR',                " Type
*              ' ' 'BKPF-BUKRS'   IT_SELECTED-BUKRS,  " Company Code
*              ' ' 'BKPF-BUDAT'   W_POSDT,            " Posting Date
*              ' ' 'BKPF-BLDAT'   W_DOCDT,            " Document Date
*              ' ' 'BKPF-WAERS'  'KRW',               " Currency
*              ' ' 'BKPF-KURSF'  '',                  " ȯ��.
*              ' ' 'BKPF-BELNR'  SPACE,               " ȸ����ǥ��ȣ.
*              ' ' 'BKPF-WWERT'  SPACE,               " ȯ����.
*              ' ' 'BKPF-XBLNR'  SPACE,               " ����������ȣ.
*              ' ' 'BKPF-BVORG'  SPACE,               " ȸ�簣 �ŷ���ȣ.
*              ' ' 'BKPF-BKTXT'  '���� �ΰ���',       " ��ǥ����ؽ�Ʈ.
*              ' ' 'RF05A-PARGB' SPACE,               " ����� �������.
*              ' ' 'RF05A-NEWBS' '31',                " Posting Key
*              ' ' 'RF05A-NEWKO'  IT_SELECTED-ZFVEN,  " Account
*              ' ' 'RF05A-NEWUM'  SPACE,              "
*              ' ' 'RF05A-NEWBW'  SPACE,              " �ڻ�ŷ�����.
*              ' ' 'BDC_OKCODE'  '/00'.               " ENTER

* NEXT SCREEN.
*  PERFORM P2000_DYNPRO USING :
*      'X' 'SAPMF05A'    '0302',
*      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
*      ' ' 'BSEG-WMWST'  TEMP_WMWST,            " Tax
*      ' ' 'BKPF-XMWST'  SPACE,                 " ������ �ڵ����� ���.
*      ' ' 'BSEG-MWSKZ'  IT_SELECTED-MWSKZ,     " Tax Code
*      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
*      ' ' 'BSEG-SECCO'  SPACE,                 " �����ڵ�.
*      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
*      ' ' 'BSEG-ZTERM'  IT_SELECTED-ZTERM,     " Payment Term
**      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
*      ' ' 'BSEG-ZLSPR'  'B',                   " ���޺���.
*      ' ' 'BSEG-SGTXT'  '�����Ƿ� ���',       " �ؽ�Ʈ.
*      ' ' 'RF05A-NEWBS' '40',                  " Posting Key
*      ' ' 'RF05A-NEWKO' ZTIMIMG11-ZFIOCAC1,    " ACCOUNT
*      ' ' 'BDC_OKCODE'  '/00'.                 " ENTER

*  PERFORM P2000_DYNPRO USING :
*      'X' 'SAPMF05A'    '0300',
*      ' ' 'BSEG-WRBTR'  '*',          " Amount
**      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,  " Amount
*      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
**      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
**      ' ' 'COBL-KOSTL'  COBL-KOSTL,            " Cost center.
**      ' ' 'COBL-PRCTR'  COBL-PRCTR,            " ���ͼ���.
*      ' ' 'BSEG-SGTXT'  '�����Ƿ� ���',       " �ؽ�Ʈ.
*      ' ' 'BDC_OKCODE'  'BU'.        " ����.
*
*  PERFORM P2000_DYNPRO USING :
*      'X' 'SAPLKACB'     '0002',
*      ' ' 'COBL-GSBER'   BSEG-GSBER,    " �������.TEST
*      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
*      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " ���ͼ���.
*      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

*     SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
*     SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.

*     PERFORM P2000_CALL_TRANSACTION USING     'F-42'
*                                              W_SUBRC.

           CALL FUNCTION 'DEQUEUE_EZ_IM_ZTCUCL'
                EXPORTING
                    ZFBLNO                =     P_ZFREQNO
                    ZFCLSEQ               =     P_ZFCLSEQ.
        WHEN OTHERS.
     ENDCASE.
  ELSE.
     RAISE   LIV_ERROR.
  ENDIF.

ENDFUNCTION.
