FUNCTION ZIM_LG_IMPRES_EDI_DOC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_FILENAME) LIKE  ZTDHF1-FILENAME
*"     REFERENCE(BACK_PATH) LIKE  ZTIMIMGTX-ZFRBAK
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"      NO_REFERENCE
*"      DOCUMENT_LOCKED
*"      DATE_ERROR
*"      NOT_FILE_OPEN
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       L_SUBRC          LIKE SY-SUBRC,
       W_STATUS         TYPE C,
       WL_VIA(1)        TYPE C,
       L_ZFDHDOC        LIKE ZTDHF1-ZFDHDOC,
       L_NOT_FOUND      TYPE C VALUE 'N',
       W_FIRST_YN       TYPE C VALUE 'Y',
       W_FIRST_DETAIL   TYPE C VALUE 'Y',
       W_TAX_GUBN(3)    TYPE C,
       W_SY_SUBRC       LIKE SY-SUBRC,
       W_TABIX1         LIKE SY-TABIX,
       W_COUNT          TYPE I,
       W_HS_CNT         TYPE I,
       W_DET_CNT        TYPE I,
       W_HS_IDR         TYPE I,
       W_DET_IDR        TYPE I,
       W_EDI_RECORD(65535).

  REFRESH : IT_EDI_TAB, RETURN, IT_ZSIDSHS, IT_ZSIDSHSD, IT_ZSIDSHSL.
  CLEAR : L_ZFDHDOC,  W_TABIX, IT_EDI_TAB, RETURN.
  L_NOT_FOUND = 'N'.

  OPEN    DATASET   W_FILENAME     FOR     INPUT   IN  TEXT  MODE.
  IF SY-SUBRC NE 0.
     MESSAGE E970 WITH W_FILENAME RAISING NOT_FILE_OPEN.
     EXIT.
  ENDIF.

  L_SUBRC = 0.

  DO.
     READ    DATASET   W_FILENAME     INTO    W_EDI_RECORD.
     IF SY-SUBRC    EQ    4.
        EXIT.
     ENDIF.

**>> ������ ����.
*     IF W_EDI_RECORD(2) EQ '<<'.
*        CLEAR: IT_EDI_TAB.
*        MOVE : W_FILENAME              TO IT_EDI_TAB-FILENAME,
*               W_EDI_RECORD+65(06)     TO L_ZFDHDOC,   "���ڹ�����.
*               W_EDI_RECORD+24(30)     TO IT_EDI_TAB-ZFDOCNOR.
*        APPEND  IT_EDI_TAB.
*        W_TABIX = SY-TABIX.
*        L_NOT_FOUND = 'N'.


      CASE  W_EDI_RECORD(02).
*>> ������ ����.
         WHEN '<<'.
           MOVE : W_EDI_RECORD+24(30)     TO ZTIDS-ZFDOCNO.
*>> �߽� ���� ���� ��ȣ.
         WHEN '01'.
            MOVE  W_EDI_RECORD+5(35) TO W_ZFDHENO.
*>> �۽Ź��� ���� ���� CHECK!
            SELECT SINGLE * FROM  ZTDHF1
                   WHERE ZFDHENO  EQ W_ZFDHENO.
            IF SY-SUBRC NE 0.      ">������..
               MESSAGE S250 WITH W_ZFDHENO.
               PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
                                           USING   'E'.
               L_SUBRC = 4.
               EXIT.
            ENDIF.
*>> �۽Ź����� �ش� KEY SELECT!
            SELECT * FROM ZTIDR   UP TO 1 ROWS
                     WHERE   ZFDOCNO  EQ W_ZFDHENO
                     ORDER BY ZFBLNO ZFCLSEQ DESCENDING.
                     EXIT.
            ENDSELECT.

            IF SY-SUBRC NE 0.
               MESSAGE S250 WITH W_ZFDHENO.
               PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
                                           USING   'E'.
               L_SUBRC = 4.
               EXIT.
            ENDIF.

*>> �ش� ���ԽŰ� ���̺� ����Ÿ GET ---->
            SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDRHS
                                        FROM   ZTIDRHS
                                        WHERE  ZFBLNO  EQ ZTIDR-ZFBLNO
                                        AND    ZFCLSEQ EQ ZTIDR-ZFCLSEQ.

            SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDRHSD
                                        FROM   ZTIDRHSD
                                        WHERE  ZFBLNO  EQ ZTIDR-ZFBLNO
                                        AND    ZFCLSEQ EQ ZTIDR-ZFCLSEQ.
*>> �ش� ���Ը��� ���̺� ����Ÿ GET ---->
            SELECT SINGLE * FROM  ZTIDS
                            WHERE ZFBLNO   EQ  ZTIDR-ZFBLNO
                            AND   ZFCLSEQ  EQ  ZTIDR-ZFCLSEQ.

            IF SY-SUBRC EQ 0.
               L_NOT_FOUND = 'N'.
               W_STATUS    = 'U'.         "> UPDATE.

               SELECT *
                       INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDSHS_ORG
                       FROM   ZTIDSHS
                       WHERE  ZFBLNO  EQ ZTIDR-ZFBLNO
                       AND    ZFCLSEQ EQ ZTIDR-ZFCLSEQ.

               SELECT *
                   INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDSHSD_ORG
                   FROM   ZTIDSHSD
                   WHERE  ZFBLNO  EQ ZTIDR-ZFBLNO
                   AND    ZFCLSEQ EQ ZTIDR-ZFCLSEQ.

               SELECT *
                   INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDSHSL_ORG
                   FROM   ZTIDSHSL
                   WHERE  ZFBLNO  EQ ZTIDR-ZFBLNO
                   AND    ZFCLSEQ EQ ZTIDR-ZFCLSEQ.

               MOVE-CORRESPONDING : ZTIDS      TO  *ZTIDS.
            ELSE.
               W_STATUS    = 'C'.        "> ����.
               L_NOT_FOUND = 'Y'.
               CLEAR : *ZTIDS.
               MOVE-CORRESPONDING : ZTIDR      TO  ZTIDS.
               REFRESH : IT_ZSIDSHS_ORG, IT_ZSIDSHSD_ORG,
                         IT_ZSIDSHSL_ORG.
            ENDIF.
*>> ¡������.
         WHEN '02'.
            IF W_EDI_RECORD+5(03) EQ '132'.
               MOVE : W_EDI_RECORD+2(02)  TO  ZTIDS-ZFCOCD.
            ENDIF.
*>> ���� �� �˻� ���.
        WHEN '03'.
            IF W_EDI_RECORD+2(02) EQ '41'.
               MOVE : W_EDI_RECORD+5(3)   TO  ZTIDS-ZFINRC,
                      W_EDI_RECORD+36(2)  TO  ZTIDS-ZFINRCD.
            ELSEIF W_EDI_RECORD+2(02) EQ '43'.
               MOVE : W_EDI_RECORD+5(18)  TO  ZTIDS-ZFISPL.
            ENDIF.
*>> �Ű�����, ��������.
        WHEN '04'.
            IF W_EDI_RECORD+2(02) EQ '58'.   "> ��������.
               CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                    EXPORTING
                        DATE_EXTERNAL = W_EDI_RECORD+5(08)
                    IMPORTING
                        DATE_INTERNAL = ZTIDS-ZFIDSDT.

            ELSEIF W_EDI_RECORD+2(03) EQ '146'. "> ��������.
               CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                    EXPORTING
                        DATE_EXTERNAL = W_EDI_RECORD+5(08)
                    IMPORTING
                        DATE_INTERNAL = ZTIDS-ZFINDT.

            ENDIF.
*>> �Ű��ȣ, ������ü��ȣ, HOUSE BL NO, ȭ��������ȣ.
        WHEN '05'.
            CASE W_EDI_RECORD+2(03).
               WHEN 'ABT'.     ">�Ű��ȣ.
                  MOVE W_EDI_RECORD+5(20)   TO  ZTIDS-ZFIDRNO.
               WHEN 'ABQ'. ">������ü ����.
                  MOVE W_EDI_RECORD+5(20)   TO  ZTIDS-ZFIMCR.
               WHEN 'BH '.  ">House B/L.
                  MOVE W_EDI_RECORD+5(20)  TO  ZTIDS-ZFHBLNO.
               WHEN 'XC '.  ">ȭ��������ȣ.
                  MOVE W_EDI_RECORD+5(20)  TO  ZTIDS-ZFGOMNO.
               WHEN 'ABA'.  ">���ΰ�����ȣ.
                  MOVE W_EDI_RECORD+5(20)  TO  ZTIDS-ZFRFFNO.
               WHEN OTHERS.
            ENDCASE.

*>> �Ű��Ƿ��� ��ȣ.
        WHEN '06'.
            CASE W_EDI_RECORD+2(02).
               WHEN 'AE'.       ">
                  MOVE W_EDI_RECORD+5(28)  TO  ZTIDS-ZFAPNM.
               WHEN 'MS'.
                  MOVE W_EDI_RECORD+5(28)  TO  ZTIDS-ZFIAPNM.
               WHEN 'IM'.
               WHEN 'PR'.
               WHEN 'SR'.
               WHEN 'SU'.
               WHEN OTHERS.
            ENDCASE.

*>> ���������հ�(��ȭ),���������հ�(��ȭ),����,�����,����ݾ�,����.
        WHEN '07'.
            CASE W_EDI_RECORD+2(03).
               WHEN '43 '.
                  IF W_EDI_RECORD+23(03) EQ 'KRW'.     ">��ȭ.
                    MOVE W_EDI_RECORD+5(18) TO ZTIDS-ZFTBAK.
                    PERFORM SET_CURR_CONV_TO_INTERNAL
                            CHANGING ZTIDS-ZFTBAK
                                     ZTIDS-ZFKRW.
                  ELSEIF W_EDI_RECORD+23(03) EQ 'USD'.  ">��ȭ.
                     MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFTBAU.
                     PERFORM SET_CURR_CONV_TO_INTERNAL
                             CHANGING ZTIDS-ZFTBAU
                                      ZTIDS-ZFUSD.
                  ENDIF.
               WHEN '144'.                            ">����.
                  MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFTFB.
                  MOVE W_EDI_RECORD+23(3) TO  ZTIDS-ZFTFBC.
                  PERFORM SET_CURR_CONV_TO_INTERNAL
                          CHANGING ZTIDS-ZFTFB
                                   ZTIDS-ZFTFBC.

               WHEN '70 '.   ">�����.
                  MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFINAMT.
                  PERFORM SET_CURR_CONV_TO_INTERNAL
                          CHANGING ZTIDS-ZFINAMT
                                   ZTIDS-ZFKRW.

               WHEN '160'.  ">����ݾ�.
                  MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFADAMK.
                  PERFORM SET_CURR_CONV_TO_INTERNAL
                          CHANGING ZTIDS-ZFADAMK
                                   ZTIDS-ZFKRW.

               WHEN '46 '.   ">�����.
                  MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFDUAMK.
                  PERFORM SET_CURR_CONV_TO_INTERNAL
                          CHANGING ZTIDS-ZFDUAMK
                                   ZTIDS-ZFKRW.
               WHEN OTHERS.
            ENDCASE.
         WHEN '08'.
            MOVE : W_EDI_RECORD+2(9)  TO  ZTIDS-ZFEXRT,
                   1                  TO  ZTIDS-FFACT.
*-----------------------< �� ���� GET >--------------------------------*
*>> ����ȣ, HS CODE.
         WHEN '10'.
*             IF W_FIRST_YN EQ 'N'.
*             ENDIF.
             CLEAR IT_ZSIDSHS.
             MOVE : IT_EDI_TAB-ZFBLNO  TO  IT_ZSIDSHS-ZFBLNO,
                    IT_EDI_TAB-ZFCLSEQ TO  IT_ZSIDSHS-ZFCLSEQ,
                    W_EDI_RECORD+5(3)  TO  IT_ZSIDSHS-ZFCONO,
                    W_EDI_RECORD+8(35) TO  IT_ZSIDSHS-STAWN,
                    'KRW'              TO  IT_ZSIDSHS-ZFKRW.
             APPEND  IT_ZSIDSHS.
             W_TABIX = SY-TABIX.
*>> ǰ��, �ŷ�ǰ��, ��ǥ�ڵ�, ��ǥǰ��.
         WHEN '11'.
             IF W_EDI_RECORD+2(03) EQ 'AAA'.
                MOVE : W_EDI_RECORD+5(50)   TO IT_ZSIDSHS-ZFGDNM,
                       W_EDI_RECORD+75(50)  TO IT_ZSIDSHS-ZFTGDNM,
                       W_EDI_RECORD+145(4)  TO IT_ZSIDSHS-ZFGCCD,
                       W_EDI_RECORD+215(50) TO IT_ZSIDSHS-ZFGCNM.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ENDIF.
*>> ȯ�޹���, ȯ�޹��� ����.
         WHEN '12'.
             IF W_EDI_RECORD+2(03) EQ '5DA'.
                MOVE : W_EDI_RECORD+8(03)  TO IT_ZSIDSHS-ZFREQNM,
                       W_EDI_RECORD+11(13) TO IT_ZSIDSHS-ZFREQN.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+2(03) EQ 'CT '.  ">�ѱ԰ݼ�.

             ENDIF.
*>> ��������(��ȭ), ��������(��ȭ).
         WHEN '13'.
             IF W_EDI_RECORD+2(02)  EQ '40' AND
                W_EDI_RECORD+23(03) EQ 'KRW'.
                MOVE: W_EDI_RECORD+5(18)  TO  IT_ZSIDSHS-ZFTBAK,
                      W_EDI_RECORD+23(03) TO  IT_ZSIDSHS-ZFKRW.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                            USING IT_ZSIDSHS-ZFTBAK
                                  IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_EDI_RECORD+2(02)  EQ '40' AND
                    W_EDI_RECORD+23(03) EQ 'USD'.
                MOVE: W_EDI_RECORD+5(18)  TO  IT_ZSIDSHS-ZFTBAU,
                      W_EDI_RECORD+23(03) TO  IT_ZSIDSHS-ZFUSD.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFTBAU
                                 IT_ZSIDSHS-ZFUSD.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ENDIF.
*>> ���ݱ���.
         WHEN '14'.
             IF W_EDI_RECORD+5(03) EQ 'CUD'.       ">����.
                MOVE : W_EDI_RECORD+8(02)  TO IT_ZSIDSHS-ZFTXCD,">����
                       W_EDI_RECORD+20(15) TO IT_ZSIDSHS-ZFCURT,">������
                       W_EDI_RECORD+48(17) TO IT_ZSIDSHS-ZFRDRT,">������
                       W_EDI_RECORD+65(01) TO IT_ZSIDSHS-ZFTXAMCD.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+5(03) EQ 'PRF'.  ">������.
                MOVE : W_EDI_RECORD+8(02)  TO IT_ZSIDSHS-ZFHMTCD,"����.
                       W_EDI_RECORD+20(15) TO IT_ZSIDSHS-ZFHMTRT,"����.
                       W_EDI_RECORD+35(07) TO IT_ZSIDSHS-ZFHMTTY,"����.
                       W_EDI_RECORD+68(07) TO IT_ZSIDSHS-ZFSCCD.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+5(03) EQ '5AB'.  ">������.
                MOVE : W_EDI_RECORD+8(01)  TO IT_ZSIDSHS-ZFETXCD.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+5(03) EQ 'CAP'.  ">��Ư��.
                MOVE : W_EDI_RECORD+8(01)  TO IT_ZSIDSHS-ZFATXCD.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+5(03) EQ 'VAT'.  ">�ΰ���.
                MOVE : W_EDI_RECORD+8(01)  TO IT_ZSIDSHS-ZFVTXCD,
                       W_EDI_RECORD+20(15) TO IT_ZSIDSHS-FWBAS,"����ǥ��
                       W_EDI_RECORD+35(07) TO IT_ZSIDSHS-ZFVTXTY.

                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-FWBAS
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.


                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+2(01) EQ '9'.   ">Ư�����ױ���.
                MOVE : W_EDI_RECORD+20(15)  TO IT_ZSIDSHS-ZFSCCS.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ENDIF.
             W_TAX_GUBN = W_EDI_RECORD+5(03).
*>> ������ ���ݾ�.
         WHEN '15'.
             IF W_TAX_GUBN EQ 'CUD' AND         ">������.
                W_EDI_RECORD+2(02)  EQ  '55'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFCUAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFCUAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ 'CUD' AND    ">��������.
                    W_EDI_RECORD+2(02) EQ '46'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFCCAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFCCAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ 'PRF' AND   ">������.
                    W_EDI_RECORD+2(02) EQ '56'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFHMAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFHMAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ '5AB' AND   ">������.
                    W_EDI_RECORD+2(02) EQ '56'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFEDAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFEDAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ 'CAP' AND   ">��Ư��.
                    W_EDI_RECORD+2(02) EQ '56'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFAGAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFAGAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ 'VAT' AND   ">�ΰ���.
*                    W_EDI_RECORD+2(01) EQ '1'.
                    W_EDI_RECORD+2(02) EQ '56'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFVAAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFVAAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.

             ELSEIF W_TAX_GUBN EQ 'VAT' AND   ">�ΰ�������.
                    W_EDI_RECORD+2(02) EQ '46'.
                MOVE W_EDI_RECORD+5(18) TO  IT_ZSIDSHS-ZFVCAMT.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING IT_ZSIDSHS-ZFVCAMT
                                 IT_ZSIDSHS-ZFKRW.
                MODIFY IT_ZSIDSHS INDEX W_TABIX.
             ENDIF.
*------------------------< �԰� ���� GET >-----------------------------*
*>> �԰ݹ�ȣ.
         WHEN '16'.
*             IF NOT IT_ZSIDSHS-ZFCONO IS INITIAL.
*                APPEND IT_ZSIDSHS.
*             ENDIF.
*             IF W_FIRST_DETAIL EQ 'N'.
*             ENDIF.
             CLEAR : IT_ZSIDSHSD.
             MOVE : IT_EDI_TAB-ZFBLNO   TO  IT_ZSIDSHSD-ZFBLNO,
                    IT_EDI_TAB-ZFCLSEQ  TO  IT_ZSIDSHSD-ZFCLSEQ,
                    IT_ZSIDSHS-ZFCONO   TO  IT_ZSIDSHSD-ZFCONO,
                    IT_ZSIDSHS-STAWN    TO  IT_ZSIDSHSD-STAWN,
                    W_EDI_RECORD+2(03)  TO  IT_ZSIDSHSD-ZFRONO.
             APPEND IT_ZSIDSHSD.
             W_TABIX1 = SY-TABIX.
*>> �԰�, ����.
         WHEN '17'.
             IF W_EDI_RECORD+2(01) EQ '1'.      ">�԰�.
                MOVE : W_EDI_RECORD+5(30)  TO IT_ZSIDSHSD-ZFGDDS1,
                       W_EDI_RECORD+40(30) TO IT_ZSIDSHSD-ZFGDDS2,
                       W_EDI_RECORD+75(30) TO IT_ZSIDSHSD-ZFGDDS3.
                MODIFY IT_ZSIDSHSD INDEX W_TABIX1.
             ELSEIF W_EDI_RECORD+2(01) EQ '5'.  ">����.
                MOVE : W_EDI_RECORD+5(30)  TO IT_ZSIDSHSD-ZFGDIN1,
                       W_EDI_RECORD+40(30) TO IT_ZSIDSHSD-ZFGDIN2.
                MODIFY IT_ZSIDSHSD INDEX W_TABIX1.
             ENDIF.
*>> ��������, ����.
         WHEN '18'.
             IF W_EDI_RECORD+2(03) EQ '5AA'.
                MOVE : W_EDI_RECORD+05(03) TO IT_ZSIDSHSD-ZFQNTM,
                       W_EDI_RECORD+08(14) TO IT_ZSIDSHSD-ZFQNT.
                MODIFY IT_ZSIDSHSD INDEX W_TABIX1.
             ENDIF.
*>> �ܰ�.
        WHEN '19'.
            IF W_EDI_RECORD+2(03) EQ '146'.
               MOVE W_EDI_RECORD+5(18)    TO IT_ZSIDSHSD-NETPR.
               MODIFY IT_ZSIDSHSD INDEX W_TABIX1.
            ELSEIF W_EDI_RECORD+2(03) EQ '203'.
               MOVE W_EDI_RECORD+5(16)    TO IT_ZSIDSHSD-ZFAMT.
               MODIFY IT_ZSIDSHSD INDEX W_TABIX1.
            ENDIF.
*--------------------< ���ι� RETURN >-------------------------------*
*>> ���ι�.
*         WHEN '20'.
*             IF NOT IT_ZSIDSHSD-ZFRONO IS INITIAL.
*                APPEND IT_ZSIDSHSD.
*             ENDIF.
*>> ���߷�, �����尹��.
         WHEN '21'.
             IF W_EDI_RECORD+2(01) EQ '7'.      ">���߷�.
                MOVE : W_EDI_RECORD+5(18)  TO ZTIDS-ZFTOWT,
                       W_EDI_RECORD+23(03) TO ZTIDS-ZFTOWTM.
                MODIFY  IT_ZSIDSHS INDEX W_TABIX.
             ELSEIF W_EDI_RECORD+2(02) EQ '11'. ">�������.
                MOVE : W_EDI_RECORD+5(18)  TO ZTIDS-ZFPKCNT,
                       W_EDI_RECORD+23(03) TO ZTIDS-ZFPKNM.
                MODIFY  IT_ZSIDSHS INDEX W_TABIX.
             ENDIF.
*>> TAX GUBUN.
         WHEN '22'.
             W_TAX_GUBN = W_EDI_RECORD+5(03).
             CASE W_TAX_GUBN.
                WHEN 'VAT'.
                   MOVE W_EDI_RECORD+8(18) TO  ZTIDS-FWBAS.
                   PERFORM SET_CURR_CONV_TO_INTERNAL
                           CHANGING ZTIDS-FWBAS
                                    ZTIDS-ZFKRW.
                WHEN OTHERS.
             ENDCASE.
*>> �� ���� �հ�.
         WHEN '23'.
             IF W_TAX_GUBN EQ 'CUD' AND        ">������.
                W_EDI_RECORD+2(03)  EQ  '55 '.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFCUAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFCUAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_TAX_GUBN EQ 'CST' AND    ">Ư�Ҽ�.
                    W_EDI_RECORD+2(03) EQ '161'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFSCAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFSCAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_TAX_GUBN EQ '5AA' AND   ">���뼼.
                    W_EDI_RECORD+2(03) EQ '161'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFTRAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFTRAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_TAX_GUBN EQ 'TAC' AND   ">�ּ�.
                    W_EDI_RECORD+2(03) EQ '161'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFDRAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFDRAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_TAX_GUBN EQ 'CAP' AND   ">��Ư��.
                    W_EDI_RECORD+2(03) EQ '161'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFAGAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFAGAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_TAX_GUBN EQ 'VAT' AND   ">�ΰ���.
                    W_EDI_RECORD+2(03) EQ '150'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFVAAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFVAAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_EDI_RECORD+2(02) EQ '58'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFIDAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFIDAMTS
                                 ZTIDS-ZFKRW.

             ELSEIF W_EDI_RECORD+2(03) EQ '128'.
                MOVE W_EDI_RECORD+5(18) TO  ZTIDS-ZFTXAMTS.
                PERFORM SET_CURR_CONV_TO_INTERNAL
                        CHANGING ZTIDS-ZFTXAMTS
                                 ZTIDS-ZFKRW.
             ENDIF.
*             MODIFY  IT_EDI_TAB INDEX W_TABIX.

         WHEN OTHERS.
      ENDCASE.

  ENDDO.

  CLOSE DATASET    W_FILENAME.

  IF L_SUBRC NE 0.
     EXIT.
  ENDIF.

  CLEAR : ZTIDS-ZFDOCNO.
*  CALL FUNCTION 'ZIM_EDI_NUMBER_GET_NEXT'
*          EXPORTING
*             W_ZFCDDOC = 'IMPRES'
*             W_ZFDHSRO = SPACE
*             W_ZFDHREF = W_ZFDHREF
*             W_BUKRS   = ZTIDS-BUKRS
*             W_LOG_ID  = 'N'
*          CHANGING
*             W_ZFDHENO = ZTIDS-ZFDOCNO
*          EXCEPTIONS
*             DB_ERROR  = 4
*             NO_TYPE   = 8.
*
*  IF SY-SUBRC NE 0.
*     MESSAGE S508(ZIM1).
*     PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
*                                 USING   'E'.
*     EXIT.
*  ENDIF.

*> MODIFY...
*> ����ȯ�޿����� ��ġ�۾�....
  LOOP AT IT_ZSIDRHSD.
     W_TABIX = SY-TABIX.
     READ TABLE IT_ZSIDSHSD INDEX W_TABIX.
     W_TABIX = SY-TABIX.
     IF SY-SUBRC EQ 0.

        MOVE : IT_ZSIDRHSD-MATNR   TO IT_ZSIDSHSD-MATNR,
               IT_ZSIDRHSD-ZFSTCD  TO IT_ZSIDSHSD-ZFSTCD,
               IT_ZSIDRHSD-ZFMENGE TO IT_ZSIDSHSD-ZFMENGE,
               IT_ZSIDRHSD-ZFCUR   TO IT_ZSIDSHSD-ZFCUR,
               IT_ZSIDRHSD-PEINH   TO IT_ZSIDSHSD-PEINH,
               IT_ZSIDRHSD-BPRME   TO IT_ZSIDSHSD-BPRME,
               IT_ZSIDRHSD-ZFRMNT  TO IT_ZSIDSHSD-ZFRMNT,
               IT_ZSIDRHSD-ZFIVNO  TO IT_ZSIDSHSD-ZFIVNO,
               IT_ZSIDRHSD-ZFIVDNO TO IT_ZSIDSHSD-ZFIVDNO.

        MODIFY IT_ZSIDSHSD INDEX W_TABIX.
     ENDIF.
  ENDLOOP.

*  IF W_STATUS EQ 'C'.
     CALL FUNCTION 'ZIM_ZTIDS_DOC_MODIFY'
       EXPORTING
            W_OK_CODE        = 'SAVE'
            ZFBLNO           = ZTIDS-ZFBLNO
            ZFCLSEQ          = ZTIDS-ZFCLSEQ
            ZFSTATUS         = W_STATUS
            W_ZTIDS_OLD      = *ZTIDS
            W_ZTIDS          = ZTIDS
            W_EDI            = 'X'
       TABLES
            IT_ZSIDSHS       = IT_ZSIDSHS
            IT_ZSIDSHS_OLD   = IT_ZSIDSHS_ORG
            IT_ZSIDSHSD      = IT_ZSIDSHSD
            IT_ZSIDSHSD_OLD  = IT_ZSIDSHSD_ORG
            IT_ZSIDSHSL      = IT_ZSIDSHSL
            IT_ZSIDSHSL_OLD  = IT_ZSIDSHSL_ORG
       EXCEPTIONS
            ERROR_UPDATE     = 1
            ERROR_DELETE     = 2
            ERROR_INSERT     = 3.

     IF SY-SUBRC NE 0.
        MESSAGE S778.
        PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
                                    USING   'E'.
        EXIT.
     ENDIF.
*   ENDIF.

**>> INTERNAL TABLE SORT.
*  SORT  IT_EDI_TAB  BY  ZFBLNO  ZFCLSEQ.
*  SORT  IT_ZSIDSHS  BY  ZFBLNO  ZFCLSEQ   ZFCONO.
*  SORT  IT_ZSIDSHSD BY  ZFBLNO  ZFCLSEQ   ZFCONO  ZFRONO.
*
*  LOOP AT IT_EDI_TAB.
*
*     W_TABIX = SY-TABIX.
*
** ���Ը��� ���� ���� CHECK!
*     CLEAR  ZTIDS.
*     SELECT SINGLE * FROM ZTIDS WHERE  ZFBLNO   EQ  IT_EDI_TAB-ZFBLNO
*                                AND    ZFCLSEQ  EQ  IT_EDI_TAB-ZFCLSEQ.
*     W_SY_SUBRC  =    SY-SUBRC.
*
**>> DATA MOVE
*     MOVE-CORRESPONDING  IT_EDI_TAB   TO  ZTIDS.
*
** LOCK CHECK
*     IF W_SY_SUBRC EQ 0.
*        CALL FUNCTION 'ENQUEUE_EZ_IM_ZTIDS'
*             EXPORTING
*                ZFBLNO                 =     ZTIDS-ZFBLNO
*                ZFCLSEQ                =     ZTIDS-ZFCLSEQ
*          EXCEPTIONS
*                OTHERS        = 1.
*
*
*        IF SY-SUBRC <> 0.
*           MESSAGE S510 WITH SY-MSGV1 '���Ը��㹮��'
*                               ZTIDS-ZFBLNO  ZTIDS-ZFCLSEQ.
**                  RAISING DOCUMENT_LOCKED.
*           PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
*                                       USING   'E'.
*           CONTINUE.
*        ENDIF.
*     ENDIF.
*
*----------------------------------------------------------------------
* �����̷��� ����
**----------------------------------------------------------------------
**----------------------------------------------------------------------
** DATA MOVE
**----------------------------------------------------------------------
**     MOVE : IT_EDI_TAB-ZFDOCNOR     TO    ZTIDS-ZFDOCNOR,
*     MOVE : 'N'                     TO    ZTIDS-ZFCHGYN,
*            SPACE                   TO    ZTIDS-ZFCHGCD,
*            SPACE                   TO    ZTIDS-ZFCHGDT.
*
**--------------------< �� ���� INSERT OR UPDATE >--------------------*
*     LOOP  AT  IT_ZSIDSHS    WHERE   ZFBLNO  EQ  IT_EDI_TAB-ZFBLNO
*                             AND     ZFCLSEQ EQ  IT_EDI_TAB-ZFCLSEQ.
*
*        MOVE-CORRESPONDING  IT_ZSIDSHS    TO  ZTIDSHS.
*
**>> TABLE ���翩�� CHECK!
*        SELECT COUNT( * )    INTO   W_COUNT
*        FROM   ZTIDSHS
*        WHERE  ZFBLNO   EQ   IT_EDI_TAB-ZFBLNO
*        AND    ZFCLSEQ  EQ   IT_EDI_TAB-ZFCLSEQ
*        AND    ZFCONO   EQ   IT_ZSIDSHS-ZFCONO.
*
*        IF W_COUNT EQ 0.
*           INSERT  ZTIDSHS.
*        ELSE.
*           UPDATE  ZTIDSHS.
*        ENDIF.
*
*        W_HS_CNT = W_HS_CNT + 1.
*
**--------------------< ��� ���� INSERT ---------------------------*
*        SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIDSHSL
*        FROM   ZTIDRHSL
*        WHERE  ZFBLNO  EQ  IT_ZSIDSHS-ZFBLNO
*        AND    ZFCLSEQ EQ  IT_ZSIDSHS-ZFCLSEQ
*        AND    ZFCONO  EQ  IT_ZSIDSHS-ZFCONO.
*
*        LOOP  AT  IT_ZSIDSHSL.
*
*           MOVE-CORRESPONDING IT_ZSIDSHSL   TO  ZTIDSHSL.
*           INSERT  ZTIDSHSL.
*
*        ENDLOOP.
*
**--------------------< �԰� ���� INSERT OR UPDATE >------------------*
*        LOOP  AT  IT_ZSIDSHSD  WHERE  ZFBLNO  EQ  IT_EDI_TAB-ZFBLNO
*                               AND    ZFCLSEQ EQ  IT_EDI_TAB-ZFCLSEQ
*                               AND    ZFCONO  EQ  IT_ZSIDSHS-ZFCONO.
*
*           MOVE-CORRESPONDING  IT_ZSIDSHSD    TO  ZTIDSHSD.
*
**>> ���ԽŰ� TABLE �� �ڷ� MATCH ���� CHECK!
*           SELECT  *       FROM   ZTIDRHSD
*                           WHERE  ZFBLNO      EQ  IT_EDI_TAB-ZFBLNO
*                           AND    ZFCLSEQ     EQ  IT_EDI_TAB-ZFCLSEQ
*                           AND    ZFCONO      EQ  IT_ZSIDSHS-ZFCONO.
*
**>> �����ȣ�� ��.
*              IF IT_ZSIDSHSD-ZFSTCD      EQ  ZTIDRHSD-ZFSTCD.
*                 IF IT_ZSIDSHSD-ZFRONO   EQ  ZTIDRHSD-ZFRONO.
*                    MOVE  'Y'            TO  IT_EDI_TAB-ZFMATYN.
*                 ELSE.
*                    MOVE  'N'            TO  IT_EDI_TAB-ZFMATYN.
*                 ENDIF.
*              ELSE.
*                 MOVE  'N'          TO   IT_EDI_TAB-ZFMATYN.
*              ENDIF.
*           ENDSELECT.
*
**>> ���Ը��� �԰� TABLE ���� ���� CHECK!
*           CLEAR W_COUNT.
*           SELECT COUNT( * )    INTO  W_COUNT
*           FROM   ZTIDSHSD
*           WHERE  ZFBLNO   EQ   IT_EDI_TAB-ZFBLNO
*           AND    ZFCLSEQ  EQ   IT_EDI_TAB-ZFCLSEQ
*           AND    ZFCONO   EQ   IT_ZSIDSHS-ZFCONO
*           AND    ZFRONO   EQ   IT_ZSIDSHSD-ZFRONO.
*
*           IF W_COUNT EQ 0.
*              INSERT  ZTIDSHSD.
*           ELSE.
*              UPDATE  ZTIDSHSD.
*           ENDIF.
*
*           W_DET_CNT = W_DET_CNT + 1.
*
*        ENDLOOP.
*
*     ENDLOOP.
*
**>> ���ԽŰ�� ���� CHECK!
*     SELECT  COUNT( * )  INTO  W_HS_IDR
*     FROM    ZTIDRHS
*     WHERE   ZFBLNO      EQ    IT_EDI_TAB-ZFBLNO
*     AND     ZFCLSEQ     EQ    IT_EDI_TAB-ZFCLSEQ.
*
*     IF W_HS_IDR  NE  W_HS_CNT.
*        MOVE  'N'       TO    ZTIDS-ZFMATYN.
*     ENDIF.
*
**>> ���ԽŰ�� ��� CHECK!
*     SELECT  COUNT( * )  INTO  W_DET_IDR
*     FROM    ZTIDRHSD
*     WHERE   ZFBLNO      EQ    IT_EDI_TAB-ZFBLNO
*     AND     ZFCLSEQ     EQ    IT_EDI_TAB-ZFCLSEQ.
*
*     IF W_DET_IDR  NE  W_DET_CNT.
*        MOVE  'N'        TO    ZTIDS-ZFMATYN.
*     ENDIF.
*
**>> TABLE DATA ����.
*     IF W_SY_SUBRC NE 0.
*        MOVE : SY-UNAME        TO  ZTIDS-ERNAM,
*               SY-DATUM        TO  ZTIDS-CDAT.
*        INSERT  ZTIDS.
*     ELSE.
*        MOVE : SY-UNAME        TO  ZTIDS-UNAM,
*               SY-DATUM        TO  ZTIDS-UDAT.
*        UPDATE  ZTIDS.
*     ENDIF.
*
** CHANGE DOCUMENT
*
** LOCK Ǯ��.
*     CALL FUNCTION 'DEQUEUE_EZ_IM_ZTIDS'
*            EXPORTING
*                ZFBLNO                 =     ZTIDS-ZFBLNO
*                ZFCLSEQ                =     ZTIDS-ZFCLSEQ.

     UPDATE  ZTDHF1
     SET     ZFDOCNOR =  ZTIDS-ZFDOCNO
             ZFDHAPP  =  'Y'
             ZFDHSSD  =  SY-DATUM
             ZFDHSST  =  SY-UZEIT
             FILENAME =  W_FILENAME
     WHERE   ZFDHENO  =  W_ZFDHENO.

     MESSAGE  S124  WITH  ZTIDS-ZFBLNO ZTIDS-ZFCLSEQ '����'.
     PERFORM P2000_SINGLE_MAKE   TABLES  RETURN
                                 USING   'S'.

     CALL FUNCTION 'ZIM_INBOUND_DATA_BACKUP'
          EXPORTING
             FILE_NAME   =   W_FILENAME
             BACK_PATH   =   BACK_PATH
          EXCEPTIONS
             NOT_FOUND   =   4
             NO_DATA     =   8.


*   ENDLOOP.

ENDFUNCTION.
