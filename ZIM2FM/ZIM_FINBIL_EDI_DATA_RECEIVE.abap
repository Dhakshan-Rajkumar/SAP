FUNCTION ZIM_FINBIL_EDI_DATA_RECEIVE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"      DOCUMENT_LOCKED
*"      DATE_ERROR
*"      NO_REFERENCE
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       WL_VIA(1)        TYPE C,
       W_COUNT          TYPE I,
       W_AAC_DATA       LIKE  ZTDDF1-ZFDDFDA,
       W_DM_DATA        LIKE  ZTDDF1-ZFDDFDA,
       W_ACK_DATA       LIKE  ZTDDF1-ZFDDFDA,
       W_ACD_DATA       LIKE  ZTDDF1-ZFDDFDA,
       W_DOC_TY         LIKE  ZTREQHD-ZFREQTY,
       W_DTM_97         LIKE  SY-DATUM,
       W_DTM_137        LIKE  SY-DATUM,
       W_ZFCSQ          LIKE  ZTRECST-ZFCSQ.

  CLEAR : W_AAC_DATA, W_DM_DATA, W_ACK_DATA, W_ACD_DATA.

  REFRESH : IT_CHARGE, IT_ZTRECST.   " ���

  SELECT SINGLE * FROM ZTDHF1 WHERE ZFDHENO EQ W_ZFDHENO.
  IF SY-SUBRC NE 0.
     RAISE   NOT_FOUND.
  ENDIF.

* VENDOR CODE SELECT
  W_COUNT = 0.
  SELECT * FROM LFA1 WHERE BAHNS EQ ZTDHF1-ZFDHSRO.
     W_COUNT = W_COUNT + 1.
  ENDSELECT.
  IF W_COUNT NE 1.
     MESSAGE E256 WITH ZTDHF1-ZFDHSRO W_COUNT.
  ENDIF.

  REFRESH: IT_SAITIN_A, IT_SAITIN_S.
* ��ü SELECT
  SELECT *  FROM ZTDDF1
            APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_A
            WHERE ZFDDENO = W_ZFDHENO.
* ������ SELECT
  C_ZFDDFDA1 = '{%'.
  SELECT *  APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_S
            FROM ZTDDF1
            WHERE ZFDDENO EQ    W_ZFDHENO
            AND ( ZFDDFDA EQ    '{11'
            OR    ZFDDFDA EQ    '{12'
            OR    ZFDDFDA EQ    '{13'
            OR    ZFDDFDA EQ    '{24' ).

*-----------------------------------------------------------------------
* DATA MOVE
*-----------------------------------------------------------------------
  CLEAR : ZTRECST.
  ZTRECST-MANDT   = SY-MANDT.      " Client
  ZTRECST-ZFDOCNO = W_ZFDHENO.     " ���ڹ��� ��ȣ

  LOOP AT IT_SAITIN_S.
    CASE IT_SAITIN_S-ZFDDFDA.
* {10 �ݿ����� ����.
* ��꼭 �뵵
      WHEN '{11'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '2BA'.    " ����ȯ����
              EXIT.
           WHEN '2BB'.    " �����ſ��� ��������(�߽�)
              W_DOC_TY = 'TT'.
           WHEN '2BC'.    " ��ȭ��ǥ����(�߽�)
              W_DOC_TY = 'LC'.
           WHEN '2BD'.    " ����ȯ����(�߽�)
              W_DOC_TY = 'TT'.
           WHEN '2BE'.    " ���Խſ����������
              W_DOC_TY = 'LC'.
           WHEN '2BF'.    " �����ſ����������
              W_DOC_TY = 'LO'.
           WHEN '2BG'.    " ���Խſ��尳��(����)
              W_DOC_TY = 'LC'.
           WHEN '2BH'.    " �����ſ��尳��(����)
              W_DOC_TY = 'LO'.
           WHEN 'ZZZ'.    " ���� ����ǥ �ܼ�����(û��)
              W_DOC_TY = 'TT'.
        ENDCASE.

* REF Seg.( ������ȣ(Reference) )
* �ſ���(��༭)��ȣ, ��û��ȣ, ��꼭��ȣ, ��Ÿ��ȣ�� ǥ��
      WHEN '{12'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN 'AAC'.        " �ſ���(��༭)��ȣ
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              W_AAC_DATA = IT_SAITIN_A-ZFDDFDA.
           WHEN 'DM'.         " ��û��ȣ
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              W_DM_DATA = IT_SAITIN_A-ZFDDFDA.
           WHEN 'ACK'.        " ��꼭��ȣ
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              W_ACK_DATA = IT_SAITIN_A-ZFDDFDA.
           WHEN 'ACD'.        " ��Ÿ��ȣ
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              W_ACD_DATA = IT_SAITIN_A-ZFDDFDA.
        ENDCASE.
* DTM Seg. ( �ŷ����� / �������� )
      WHEN '{13'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '97'.      " �ŷ�����
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                   EXPORTING
                        DATE_EXTERNAL = IT_SAITIN_A-ZFDDFDA
                   IMPORTING
                        DATE_INTERNAL = W_DTM_97.
              IF SY-SUBRC <> 0.
                 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
                       RAISING DATE_ERROR.
              ENDIF.
           WHEN '137'.     " ��������
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                   EXPORTING
                        DATE_EXTERNAL = IT_SAITIN_A-ZFDDFDA
                   IMPORTING
                        DATE_INTERNAL = W_DTM_137.

              IF SY-SUBRC <> 0.
                 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
                       RAISING DATE_ERROR.
              ENDIF.
        ENDCASE.
* {14 �ݿ����� ����. : ������� �ڵ� / �������� �ڵ�
* {15 �ݿ����� ����. : ���ڿ��� / ����Կ��� �ڵ�
* {16 �ݿ����� ����. : ������ü�� �⺻����
* {17 �ݿ����� ����. : �߱�����
* {18 �ݿ����� ����  : �ŷ��� ��ȣ
* {19 �ݿ����� ����  : ��ȭ �Ѿ�
*    {20 �ݿ����� ����  : FOB ȯ����/������������
*    {21 �ݿ����� ����  : ��ȭ �ݾ�/��ȭ�ݾ�
*    {22 �ݿ����� ����  : ����ȯ��
* {1A �ݿ����� ����  : ������ �Ǵ� ���ںδ���
*    {23 �ݿ����� ����  : �������޾�(����), ������, ���ڵ��� �հ�
*-----------------------------------------------------------------------
* ���
*-----------------------------------------------------------------------
      WHEN '{24'.            " ������(����)�� �ڵ�
         CLEAR: Z_ZFDDSEQ.
         Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 3.
         READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
         CLEAR : IT_ZTRECST.
* ��� �ڵ�>>>>
         MOVE IT_SAITIN_A-ZFDDFDA    TO    IT_ZTRECST-ZFCSCD.
         PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                CHANGING Z_ZFDDSEQ.

         DO.
            CASE IT_SAITIN_A-ZFDDFDA.
               WHEN '{30'.         " ������
                  PERFORM READ_TABLE_4   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
               WHEN '{31'.
                  PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
                  IF IT_SAITIN_A-ZFDDFDA EQ '25'.     " ��ȭ
                     PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                            CHANGING Z_ZFDDSEQ.
                     IT_ZTRECST-ZFCAMT = IT_SAITIN_A-ZFDDFDA.

                     PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                            CHANGING Z_ZFDDSEQ.
                     IT_ZTRECST-WAERS  = IT_SAITIN_A-ZFDDFDA.
                  ELSEIF IT_SAITIN_A-ZFDDFDA EQ '23'. " ��ȭ
                     PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                            CHANGING Z_ZFDDSEQ.
                     IT_ZTRECST-ZFCKAMT = IT_SAITIN_A-ZFDDFDA.

                     PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                            CHANGING Z_ZFDDSEQ.
                     IT_ZTRECST-ZFKRW   = IT_SAITIN_A-ZFDDFDA.
                  ENDIF.
                  PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
               WHEN '{32'.
                  PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
                  IT_ZTRECST-ZFEXRT     = IT_SAITIN_A-ZFDDFDA.
                  PERFORM READ_TABLE_2   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
               WHEN '{33'.         " ������
                  PERFORM READ_TABLE_5   TABLES   IT_SAITIN_A
                                         CHANGING Z_ZFDDSEQ.
               WHEN OTHERS.
                  EXIT.
            ENDCASE.
         ENDDO.
         APPEND  IT_ZTRECST.
      WHEN OTHERS.
    ENDCASE.                           " *  IT_SAITIN_S-ZFDDFDA
  ENDLOOP.                             " ** IT_SAITIN_S

* �ش� ���� SELECT.....
  SELECT ZFREQNO INTO W_ZFREQNO FROM ZTREQST
         WHERE ZFOPNNO EQ W_AAC_DATA
         OR    ZFOPNNO EQ W_ACK_DATA
         OR    ZFOPNNO EQ W_ACD_DATA
         OR    ZFDOCNO EQ W_DM_DATA.
      EXIT.
  ENDSELECT.

  IF SY-SUBRC NE 0.
     RAISE   NO_REFERENCE.
  ENDIF.

  SELECT SINGLE * FROM ZTREQHD WHERE ZFREQNO EQ W_ZFREQNO.

  CALL FUNCTION 'ENQUEUE_EZ_IM_ZTRECST'
         EXPORTING
                 MANDT              =     SY-MANDT
                 ZFREQNO            =     ZTREQHD-ZFREQNO
         EXCEPTIONS
              OTHERS        = 1.
  IF SY-SUBRC NE 0.
     MESSAGE E510 WITH SY-MSGV1 'L/C Cost'
                       ZTREQHD-ZFREQNO    ' '
                       RAISING DOCUMENT_LOCKED.
  ENDIF.
* ����....
  SELECT MAX( ZFCSQ ) INTO W_ZFCSQ FROM ZTRECST
                      WHERE ZFREQNO  EQ  ZTREQHD-ZFREQNO.

*-----------------------------------------------------------------------
* ������ ���� ���� �ڵ�� ��ȯ
*-----------------------------------------------------------------------
  LOOP AT IT_ZTRECST.
     W_TABIX = SY-TABIX.

     W_ZFCSQ = W_ZFCSQ + 10.
     IT_ZTRECST-ZFCSQ = W_ZFCSQ.
*>>> ��ȭ�ݾ�
     IF NOT IT_ZTRECST-ZFCAMT IS INITIAL.
        PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING IT_ZTRECST-ZFCAMT
                                                      IT_ZTRECST-WAERS.
     ENDIF.
     IF NOT IT_ZTRECST-ZFCKAMT IS INITIAL.
        PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING IT_ZTRECST-ZFCKAMT
                                                      IT_ZTRECST-ZFKRW.
     ENDIF.
     MOVE : SY-DATUM            TO    IT_ZTRECST-CDAT,
            SY-DATUM            TO    IT_ZTRECST-UDAT,
            SY-UNAME            TO    IT_ZTRECST-ERNAM,
            SY-UNAME            TO    IT_ZTRECST-UNAM,
            SY-MANDT            TO    IT_ZTRECST-MANDT,
            ZTREQHD-ZFREQNO     TO    IT_ZTRECST-ZFREQNO,
            W_ZFDHENO           TO    IT_ZTRECST-ZFDOCNO,
            'A001'              TO    IT_ZTRECST-ZTERM,   " PAYMENT TERM
            ZTREQHD-ZFWERKS     TO    IT_ZTRECST-ZFWERKS. " PLANT
* TAX CODE
     CLEAR : ZTIMIMG08.
     SELECT  SINGLE * FROM ZTIMIMG08
                      WHERE ZFCDTY  EQ '003'
                      AND   ZFCD    EQ IT_ZTRECST-ZFCSCD.
* MATCH CODE
     IF SY-SUBRC NE 0.
        IT_ZTRECST-ZFCSCD = 'ZZZ'.        " ��Ÿ �ڵ� (  )...
     ENDIF.

     MOVE : ZTIMIMG08-ZFCD5   TO    IT_ZTRECST-MWSKZ.
* VENDOR �� ����ó / ��������  ---->
     MOVE : LFA1-LIFNR        TO    IT_ZTRECST-ZFVEN,
            LFA1-LIFNR        TO    IT_ZTRECST-ZFPAY.

     MODIFY IT_ZTRECST INDEX W_TABIX.
  ENDLOOP.
*--------------------> L/C ��� MODIFY
  LOOP AT IT_ZTRECST.
     MOVE-CORRESPONDING IT_ZTRECST TO ZTRECST.
     INSERT ZTRECST.

     CLEAR : *ZTRECST.
     OBJECID = ZTRECST(18).

     CALL FUNCTION 'ZTRECST_WRITE_DOCUMENT'
         EXPORTING
            OBJECTID           =    OBJECID
            TCODE              =    SY-TCODE
            UTIME              =    SY-UZEIT
            UDATE              =    SY-DATUM
            USERNAME           =    SY-UNAME
            N_ZTRECST          =    ZTRECST
            O_ZTRECST          =   *ZTRECST
            UPD_ZTRECST        =    'I'
*           CDOC_UPD_OBJECT    =    'I'
            OBJECT_CHANGE_INDICATOR = 'U'
            PLANNED_OR_REAL_CHANGES = ''
            NO_CHANGE_POINTERS      = ''
            UPD_ICDTXT_ZTRECST      = ''
        TABLES
            ICDTXT_ZTRECST     =    IT_CDTXT.

  ENDLOOP.

  IF SY-SUBRC NE  0.
*    MESSAGE  E041.
     RAISE    UPDATE_ERROR.
  ELSE.
     MESSAGE  S257  WITH  ZTREQHD-ZFREQNO.
  ENDIF.

  ZTDHF1-ZFDHAPP = 'Y'.
  UPDATE  ZTDHF1.

  CALL FUNCTION 'DEQUEUE_EZ_IM_ZTRECST'
         EXPORTING
                 MANDT              =     SY-MANDT
                 ZFREQNO            =     ZTREQHD-ZFREQNO.


ENDFUNCTION.
















