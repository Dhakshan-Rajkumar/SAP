FUNCTION ZIM_SAITIN_EDI_DATA_RECEIVE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       WL_VIA(1)        TYPE C.
  REFRESH : IT_CHARGE.

  SELECT SINGLE * FROM ZTDHF1 WHERE ZFDHENO EQ W_ZFDHENO.
  IF SY-SUBRC NE 0.
     RAISE   NOT_FOUND.
  ENDIF.

  REFRESH: IT_SAITIN_A, IT_SAITIN_S.
* ��ü SELECT
  SELECT *  FROM ZTDDF1
            APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_A
            WHERE ZFDDENO = W_ZFDHENO.
* ������ SELECT
  C_ZFDDFDA1 = '{1%'.
  SELECT *  APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_S
            FROM ZTDDF1
            WHERE ZFDDENO EQ    W_ZFDHENO
            AND   ZFDDFDA LIKE  C_ZFDDFDA1.

*-----------------------------------------------------------------------
* DATA MOVE
*-----------------------------------------------------------------------
  CLEAR : ZTBL.
  ZTBL-MANDT   = SY-MANDT.      " Client
  ZTBL-ZFDOCNO = W_ZFDHENO.     " ���ڹ��� ��ȣ

  LOOP AT IT_SAITIN_S.
    CASE IT_SAITIN_S-ZFDDFDA.
* BGM Seg.
      WHEN '{10'.
* DTM Seg.( B/L �������� )
      WHEN '{11'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 2.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
             EXPORTING
                  DATE_EXTERNAL = IT_SAITIN_A-ZFDDFDA
             IMPORTING
                  DATE_INTERNAL = ZTBL-ZFBLDT.

        IF SY-SUBRC <> 0.
           MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
* FTX Seg. ( ȭ����޻��� )
      WHEN '{12'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 2.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        ZTBL-ZFRMK1     = IT_SAITIN_A-ZFDDFDA.
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
        ZTBL-ZFRMK2     = IT_SAITIN_A-ZFDDFDA.
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
        ZTBL-ZFRMK3     = IT_SAITIN_A-ZFDDFDA.
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
        ZTBL-ZFRMK4    = IT_SAITIN_A-ZFDDFDA.
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
*        ZTBL-ZFRMK5    = IT_SAITIN_A-ZFDDFDA.
*        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
*                               CHANGING Z_ZFDDSEQ.
* REF Seg. ( H B/L NO, L/C NO ��... )
      WHEN '{13'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.

        CASE IT_SAITIN_A-ZFDDFDA.
          WHEN 'HWB'.                        " H. B/L No. : 1
            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            ZTBL-ZFHBLNO = IT_SAITIN_A-ZFDDFDA.
            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                            IT_SAITIN_S
                                   CHANGING Z_ZFDDSEQ.
          WHEN 'MWB'.                        " M. B/L No. : 3
            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            ZTBL-ZFMBLNO = IT_SAITIN_A-ZFDDFDA.
          WHEN 'AAC'.                        " L/C No. : 10
            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            ZTBL-ZFOPNNO  = IT_SAITIN_A-ZFDDFDA.
          WHEN 'ON'.                         " P/O No.
            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            ZTBL-ZFREBELN = IT_SAITIN_A-ZFDDFDA.
          WHEN 'IV'.
            PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                   CHANGING Z_ZFDDSEQ.
            PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                            IT_SAITIN_S
                                   CHANGING Z_ZFDDSEQ.
*-----------------------------------------------------------------------
*  Seal No. DB �ݿ� ����.(
*-----------------------------------------------------------------------
*         WHEN 'SN'.
        ENDCASE.                             " * IT_SAITIN_A-ZFDDFDA
*-----------------------------------------------------------------------
* ���
*-----------------------------------------------------------------------
      WHEN '{14'.
        CLEAR: Z_ZFDDSEQ.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.

        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '6TM'.                                 " �����ޱ�
             PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             ZTBL-ZFTRTPM    = IT_SAITIN_A-ZFDDFDA.    " �������ҹ��
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                             IT_SAITIN_S
                                    CHANGING Z_ZFDDSEQ.
           WHEN '6WL'.                " Chargeable W/T�� ��ݳ���(Rate)
             PERFORM READ_TABLE_3   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                             IT_SAITIN_S
                                    CHANGING Z_ZFDDSEQ.
*������ �� ��ȭ
             ZTBL-ZFTRTEC = IT_CHARGE-AMTCUR.
             ZTBL-ZFTRTE  = IT_CHARGE-AMOUNT.

           WHEN '6WM'.                " H.D.C
             PERFORM READ_TABLE_3   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                             IT_SAITIN_S
                                    CHANGING Z_ZFDDSEQ.
*-----------------------------------------------------------------------
* EDI�� ���ŵ��� ����(�����ޱ�)
*-----------------------------------------------------------------------
* Others Charge
           WHEN OTHERS.
             PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             ZTBL-ZFOTHPM    = IT_SAITIN_A-ZFDDFDA.
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                             IT_SAITIN_S
                                    CHANGING Z_ZFDDSEQ.
      ENDCASE.                             " * IT_SAITIN_A-ZFDDFDA

      WHEN '{15'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.

        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '20'.            " AIR / VSSL ����
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             ZTBL-ZFCARNM = IT_SAITIN_A-ZFDDFDA.    " ����/���
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             CASE IT_SAITIN_A-ZFDDFDA.
               WHEN '40'.
                   ZTBL-ZFVIA = 'AIR'.
               WHEN 'VE'.
                   ZTBL-ZFVIA = 'VSL'.
             ENDCASE.
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             CONCATENATE IT_SAITIN_A-ZFDDFDA ZTBL-ZFCARNM
                 INTO ZTBL-ZFCARNM.          " ����/��� �ڵ�
             PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                             IT_SAITIN_S
                                    CHANGING Z_ZFDDSEQ.
        ENDCASE.                             " * IT_SAITIN_A-ZFDDFDA

      WHEN '{16'.
         CLEAR: Z_ZFDDSEQ.
         Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
         READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.

         CASE IT_SAITIN_A-ZFDDFDA.
* ������
*          WHEN 'SE'.
* ������
*          WHEN 'CN'.
* ����ȸ��
*          WHEN 'CA'.
* ������
     WHEN 'CG'.
*            PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
*                                   CHANGING Z_ZFDDSEQ.
*            PERFORM READ_TABLE_2.
*            IT_SAITIN-F30_1 = IT_SAITIN_A-ZFDDFDA.
*            PERFORM READ_TABLE_1.
*            IT_SAITIN-F30_2 = IT_SAITIN_A-ZFDDFDA.
*            PERFORM READ_TABLE_1.
*            IT_SAITIN-F30_3 = IT_SAITIN_A-ZFDDFDA.
*            PERFORM READ_TABLE_1.
*            IT_SAITIN-F30_4 = IT_SAITIN_A-ZFDDFDA.
*            PERFORM READ_TABLE_1.
*            IT_SAITIN-F30_5 = IT_SAITIN_A-ZFDDFDA.
*            PERFORM READ_TABLE_1.

         ENDCASE.                             " * IT_SAITIN_A-ZFDDFDA

      WHEN '{17'.
         Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
         READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
         CASE IT_SAITIN_A-ZFDDFDA.
*-----------------------------------------------------------------------
* DATABASE �̹ݿ�
*-----------------------------------------------------------------------
*          WHEN '1'.         " �����̳� ����
*          WHEN '2'.         " MASTER PKG ����
*            PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
*                                   CHANGING Z_ZFDDSEQ.
*            IF SY-SUBRC EQ 0.
*              ZTBL-ZFPKCN   = IT_SAITIN_A-ZFDDFDA.
*              PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
*                                     CHANGING Z_ZFDDSEQ.
*              PERFORM PROCESS_{2%    TABLES   IT_SAITIN_A
*                                              IT_SAITIN_S
*                                     CHANGING Z_ZFDDSEQ.
*            ENDIF.
*          WHEN '3'.         " PKG ����
           WHEN '4'.         " B/L TOTAL PKG ����
             PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                    CHANGING Z_ZFDDSEQ.
             IF SY-SUBRC EQ 0.
               ZTBL-ZFPKCN   = IT_SAITIN_A-ZFDDFDA.
*-----------------------------------------------------------------------
* HARD CODING ( PC )  ===> 2000/03/31  ������ �븮 DEFINE
*-----------------------------------------------------------------------
               ZTBL-ZFPKCNM  = 'PCE'.
*-----------------------------------------------------------------------
               PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                      CHANGING Z_ZFDDSEQ.
               PERFORM PROCESS_2%    TABLES   IT_SAITIN_A
                                               IT_SAITIN_S
                                      CHANGING Z_ZFDDSEQ.
             ENDIF.
         ENDCASE.                             " * IT_SAITIN_A-ZFDDFDA

    ENDCASE.                           " *  IT_SAITIN_S-ZFDDFDA
  ENDLOOP.                             " ** IT_SAITIN_S
* ---> FWDR SELECT( ���߽� �ĺ��ڷ� SELECT )
  CLEAR : LFA1.
  SELECT SINGLE * FROM LFA1 WHERE BAHNS EQ ZTDHF1-ZFDHSRO.
  IF SY-SUBRC EQ 0.
     ZTBL-ZFFORD = LFA1-LIFNR.
  ELSE.
     CLEAR : ZTBL-ZFFORD.
  ENDIF.

*-----------------------------------------------------------------------
* ������ ���� ���� �ڵ�� ��ȯ
*-----------------------------------------------------------------------
*>>> B/L �ݾ�
  PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING ZTBL-ZFBLAMT
                                                ZTBL-ZFBLAMC.
* RATE(������)
  IF NOT  ZTBL-ZFTRTE IS INITIAL.
     PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING ZTBL-ZFTRTE
                                                   ZTBL-ZFTRTEC.
  ENDIF.
*>>> UNIT ISO CODE ===> �����ڵ�� ��ȯ( PKG    ���� )
  PERFORM    SET_UNIT_CONV_TO_INTERNAL CHANGING ZTBL-ZFPKCNM.
*>>> UNIT ISO CODE ===> �����ڵ�� ��ȯ( ���߷� ���� )
  PERFORM    SET_UNIT_CONV_TO_INTERNAL CHANGING ZTBL-ZFNEWTM.
*>>> UNIT ISO CODE ===> �����ڵ�� ��ȯ( ���߷� ���� )
  PERFORM    SET_UNIT_CONV_TO_INTERNAL CHANGING ZTBL-ZFTOWTM.
*>>> UNIT ISO CODE ===> �����ڵ�� ��ȯ( ������ ���� )
  PERFORM    SET_UNIT_CONV_TO_INTERNAL CHANGING ZTBL-ZFTOVLM.

  IF ZTBL-ZFVIA EQ 'AIR'.
     WL_VIA  =  'A'.
  ELSEIF ZTBL-ZFVIA EQ 'VSL'.
     WL_VIA  =  'O'.
  ENDIF.
* B/L �ؿ� ����
*----> Partner Function >>>>>
  CLEAR : LFA1.
  IF NOT ZTBL-ZFFORD IS INITIAL.
     SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZTBL-ZFFORD.
  ENDIF.

  REFRESH : IT_ZSIMIMG08.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIMIMG08
                                              FROM ZTIMIMG08
                                              WHERE ZFCDTY EQ '004'
                                              AND   ZFCD4  EQ WL_VIA
                                              ORDER BY ZFCD2.
  REFRESH : IT_ZSBLCST.
  LOOP AT IT_ZSIMIMG08.
     CLEAR : IT_ZSBLCST.
     IT_ZSBLCST-ZFCSQ    =   ( SY-TABIX * 10 ) + 10000.
     IT_ZSBLCST-ZFCSCD   =    IT_ZSIMIMG08-ZFCD.
     IT_ZSBLCST-ZFCDNM   =    IT_ZSIMIMG08-ZFCDNM.
     IT_ZSBLCST-ZFAOCD   =    IT_ZSIMIMG08-ZFCD1.
     IT_ZSBLCST-KRW      =    'KRW'.
     IT_ZSBLCST-ZFEXRT   =    ZTBL-ZFEXRT.            " ȯ��
*-----------------------------------------------------------------------
* 2000/06/19  ������ �븮 DEFINE
     IF WL_VIA  =  'A'.            " AIR
* Handling Charge�� ���, ��ȭ�� SET
        IF IT_ZSBLCST-ZFCSCD EQ 'AHC'.              " HANDLING CHARGE
           MOVE 'KRW'               TO    IT_ZSBLCST-WAERS.
        ELSE.
           MOVE ZTBL-ZFTRTEC        TO    IT_ZSBLCST-WAERS.
        ENDIF.
     ELSEIF WL_VIA  =  'O'.        " OCEAN
        CASE IT_ZSBLCST-ZFCSCD.
* ü���� / W.F.G / T.H.C / C.F.S / Cont'R Tax / Doc. Fee
           WHEN 'DTC' OR 'WFG' OR 'THC' OR 'CFS' OR 'CTT' OR 'DCF'.
              MOVE 'KRW'               TO    IT_ZSBLCST-WAERS.
           WHEN OTHERS.
              MOVE ZTBL-ZFTRTEC        TO    IT_ZSBLCST-WAERS.
        ENDCASE.
     ENDIF.
*-----------------------------------------------------------------------
* IMG�� ��Ÿ�ΰ������� CODE 3�� SETTING
*-----------------------------------------------------------------------
     IF IT_ZSIMIMG08-ZFCD3 EQ 'OTC'.
        CASE WL_VIA.
           WHEN 'A'.            " �װ� B/L�� ���
              LOOP AT IT_CHARGE WHERE CODE NE '6UA'       " BASIC
                                AND   CODE NE '6WM'       " H.D.C
                                AND   CODE NE '6WL'.      " RATE
*-----------------------------------------------------------------------
* ���� �ݿ� CODE ���ľ�
*-----------------------------------------------------------------------
*                               AND   CODE NE '???'.      " C.C.F
                 IT_ZSBLCST-ZFCAMT = IT_ZSBLCST-ZFCAMT
                                   + IT_CHARGE-AMOUNT.
                 IT_ZSBLCST-WAERS  = IT_CHARGE-AMTCUR.
              ENDLOOP.
           WHEN 'O'.            " �ػ� B/L�� ���
              LOOP AT IT_CHARGE WHERE CODE NE '6UA'       " BASIC
                                AND   CODE NE '6WM'       " H.D.C
                                AND   CODE NE '6VT'       " Con't Tax
                                AND   CODE NE '6VK'       " Doc. Fee
                                AND   CODE NE '6VS'       " T.H.C
                                AND   CODE NE '6VR'       " W.F.G
                                AND   CODE NE '6WL'.      " RATE
*-----------------------------------------------------------------------
* ���� �ݿ� CODE ���ľ�
*-----------------------------------------------------------------------
*                               AND   CODE NE '???'       " C.A.F
*                               AND   CODE NE '???'       " B.A.F
*                               AND   CODE NE '???'       " C.F.S
*                               AND   CODE NE '???'       " ü����
                 IT_ZSBLCST-ZFCAMT = IT_ZSBLCST-ZFCAMT
                                   + IT_CHARGE-AMOUNT.
                 IT_ZSBLCST-WAERS  = IT_CHARGE-AMTCUR.
              ENDLOOP.
        ENDCASE.
     ELSE.
        LOOP AT IT_CHARGE WHERE CODE = IT_ZSIMIMG08-ZFCD3.
           IT_ZSBLCST-ZFCAMT = IT_ZSBLCST-ZFCAMT
                             + IT_CHARGE-AMOUNT.
           IT_ZSBLCST-WAERS  = IT_CHARGE-AMTCUR.
        ENDLOOP.
     ENDIF.
* 2000/06/19  ������ �븮 DEFINE VALUE ����(PAYMENT TERM, PLANT, TAX)
     IT_ZSBLCST-ZTERM    =    'A001'.
     IT_ZSBLCST-ZFWERKS  =    ZTBL-ZFWERKS.
     IT_ZSBLCST-MWSKZ    =    IT_ZSIMIMG08-ZFCD5.
* ===> TAX RATE
     IF IT_ZSBLCST-MWSKZ IS INITIAL.
        CLEAR : IT_ZSBLCST-KBETR, IT_ZSBLCST-KONWA, IT_ZSBLCST-ZFVAT.
     ELSE.
        PERFORM   P1000_READ_KONP   USING   IT_ZSBLCST-MWSKZ
                                            IT_ZSBLCST-KBETR
                                            IT_ZSBLCST-KONWA.
     ENDIF.

     IT_ZSBLCST-ZFVEN    =    ZTBL-ZFFORD.
*----> Partner Function >>>>>
     IT_ZSBLCST-ZFPAY    =    LFA1-LNRZA.

     APPEND IT_ZSBLCST.
  ENDLOOP.

  LOOP AT IT_ZSBLCST.
     W_TABIX = SY-TABIX.
*>>> �ݾ�
     W_AMOUNT           = IT_ZSBLCST-ZFCAMT.
     PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING IT_ZSBLCST-ZFCAMT
                                                   IT_ZSBLCST-WAERS.
     IF NOT ZTBL-ZFEXRT IS INITIAL.
         W_AMOUNT          = ZTBL-ZFEXRT * W_AMOUNT.
        IT_ZSBLCST-ZFCKAMT = ZTBL-ZFEXRT * IT_ZSBLCST-ZFCAMT.
        IT_ZSBLCST-ZFEXRT  = ZTBL-ZFEXRT.
     ENDIF.
*-----------------------------------------------------------------------
* TAX CODE  ===> �ΰ��� ������ ����
* DESC : ����� ���� DEFINE (E&Y)
     IF IT_ZSBLCST-ZFVAT IS INITIAL.
        IF NOT IT_ZSBLCST-KBETR IS INITIAL.
            W_AMOUNT = W_AMOUNT * IT_ZSBLCST-KBETR / 10.
            COMPUTE W_AMOUNT = TRUNC( W_AMOUNT ).
            W_AMOUNT = W_AMOUNT * 10.
            IT_ZSBLCST-ZFVAT = W_AMOUNT.
            PERFORM    SET_CURR_CONV_TO_INTERNAL USING IT_ZSBLCST-ZFVAT
                                                      'KRW'.
        ENDIF.
     ENDIF.
*-----------------------------------------------------------------------
* MODIFY
     MODIFY IT_ZSBLCST INDEX W_TABIX.
  ENDLOOP.

* B/L ���� ����
*----> Partner Function >>>>>
  CLEAR : LFA1.
  IF NOT ZTBL-ZFTRCK IS INITIAL.
     SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ ZTBL-ZFTRCK.
  ENDIF.
  REFRESH : IT_ZSIMIMG08.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIMIMG08
                                              FROM ZTIMIMG08
                                              WHERE ZFCDTY EQ '005'
                                              AND   ZFCD4  EQ WL_VIA
                                              ORDER BY ZFCD2.
  REFRESH : IT_ZSBLCST1.
  LOOP AT IT_ZSIMIMG08.
     CLEAR : IT_ZSBLCST1.
     IT_ZSBLCST1-ZFCSQ    =    SY-TABIX * 10.
     IT_ZSBLCST1-ZFCSCD   =    IT_ZSIMIMG08-ZFCD.
     IT_ZSBLCST1-ZFCDNM   =    IT_ZSIMIMG08-ZFCDNM.
     IT_ZSBLCST1-ZFAOCD   =    IT_ZSIMIMG08-ZFCD1.
     IT_ZSBLCST1-KRW      =    'KRW'.
     IT_ZSBLCST1-ZFEXRT   =    ZTBL-ZFEXRT.            " ȯ��
     IT_ZSBLCST1-WAERS    =    ZTBL-ZFTRTEC.           " ������ ��ȭ
*-----------------------------------------------------------------------
* 2000/06/19  ������ �븮 DEFINE VALUE ����(PAYMENT TERM, PLANT, TAX)
     IT_ZSBLCST1-ZTERM    =    'A001'.
     IT_ZSBLCST1-ZFWERKS  =    ZTBL-ZFWERKS.
     IT_ZSBLCST1-MWSKZ    =    IT_ZSIMIMG08-ZFCD5.
     IT_ZSBLCST1-ZFVEN    =    ZTBL-ZFTRCK.
* ===> TAX RATE
     IF IT_ZSBLCST1-MWSKZ IS INITIAL.
        CLEAR : IT_ZSBLCST1-KBETR, IT_ZSBLCST1-KONWA, IT_ZSBLCST1-ZFVAT.
     ELSE.
        PERFORM   P1000_READ_KONP   USING   IT_ZSBLCST1-MWSKZ
                                            IT_ZSBLCST1-KBETR
                                            IT_ZSBLCST1-KONWA.
     ENDIF.

*----> Partner Function >>>>>
     IT_ZSBLCST1-ZFPAY    =    LFA1-LNRZA.

     APPEND IT_ZSBLCST1.
  ENDLOOP.
* DOCUMENT NO GET
  PERFORM   P2000_GET_NUMBER_NEXT  USING  'BL'  ZTBL-ZFBLNO
                                          '0000' SPACE.
* MODIFY
  CLEAR : *ZTBL.

  CALL FUNCTION 'ZIM_BL_DOC_MODIFY'
       EXPORTING
             W_OK_CODE           =   ''
             ZFBLNO              =   ZTBL-ZFBLNO
             ZFSTATUS            =   'C'
             W_ZTBL              =   ZTBL
             W_ZTBL_OLD          =  *ZTBL
       TABLES
             IT_ZSBLCST1        =    IT_ZSBLCST1
             IT_ZSBLCST         =    IT_ZSBLCST
             IT_ZSBLCON         =    IT_ZSBLCON
       EXCEPTIONS
              ERROR_UPDATE.

  IF SY-SUBRC NE  0.
*    MESSAGE  E041.
     RAISE    UPDATE_ERROR.
  ELSE.
     MESSAGE  S037  WITH  ZTBL-ZFBLNO.
  ENDIF.

  ZTDHF1-ZFDHAPP = 'Y'.
  UPDATE  ZTDHF1.

ENDFUNCTION.
