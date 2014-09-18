FUNCTION ZIM_INSURANCE_LGI_TO_LG.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFREQNO) LIKE  ZTINS-ZFREQNO
*"     VALUE(ZFINSEQ) LIKE  ZTINS-ZFINSEQ
*"     VALUE(ZFAMDNO) LIKE  ZTINS-ZFAMDNO
*"  EXCEPTIONS
*"      RCV_ERROR
*"      NOT_FOUND
*"      NOT_SELECT
*"----------------------------------------------------------------------
DATA : BUFFER_POINTER     TYPE     I.
DATA : PARA_LENG          TYPE     I.
DATA : W_INDEX            TYPE     I.
DATA : W_MOD              TYPE     I.
DATA : L_YAK(005)         TYPE     C.
DATA : W_AMEND_MARK.
DATA : L_ZFLAGR           LIKE     ZTINSAGR-ZFLAGR.


DATA : BEGIN OF TEXT_RECORD,
       REC_TEXT(70)          VALUE   SPACE,
       CR_LF    TYPE   X     VALUE   '0A'.
DATA : END   OF TEXT_RECORD.

DATA : L_TCURC            LIKE TCURC.

DATA : BEGIN OF WA,
       NETWORK_GB(002),    ">��뱸��.
       SAUPJA_NO(025),     ">��ǥ ����ڵ�Ϲ�ȣ.
       BOJONG(001),        ">�����Ա���
       REF_NO(020),        ">����������ȣ
       REF_CHNG_NO(002),   ">����������ȣ ����
       CONT_DATE(009),     ">���ü������.
       CONT_GB(001),       ">��౸��
       POL_NO(015),        ">���ǹ�ȣ
       CHNG_SER(003),      ">����ȸ��
       ENDS_SER(004),      ">�輭ȸ��
       OP_POL_NO(015),     ">OP���ǹ�ȣ
       CNTR_ID(015),       ">��������
       CNTR_NM(050),       ">�������� ��
       REL_ID(015),        ">�Ǻ����� �ڵ�
       REL_NM(050),        ">�Ǻ����� ��
       OBJT_CD(007),       ">������ �ڵ�
       OBJT_TEXT(840),     ">������ ����
       HS_CD(010),         ">�����з��ڵ�
       ST_AREA_CD(002),    ">����� �ڵ�
       ST_AREA_TXT(070),   ">����� ��
       TRAN_AREA_CD(002),  ">ȯ���� �ڵ�
       TRAN_AREA_TXT(070), ">ȯ���� ��
       ARR_AREA_CD(002),   ">������ �ڵ�
       ARR_AREA_TXT(070),  ">������ ��
       LAST_AREA_CD(002),  ">���������� �ڵ�
       LAST_AREA_TXT(070),    ">���������� ��
       CLM_AGENT(300),        ">CLAIM AGENT
       SVY_AGENT(300),        ">SURVEY AGENT
       PRE_INV_VAL_CURR(003), ">ȭ������ ȭ���ڵ�(��)
       PRE_INV_VAL(020),      ">ȭ������  (��)
       PRE_INV_PRO_RATE(011), ">ȭ�� ��������� (��)
       PRE_INV_EXCH_RATE(011),">ȭ�����Աݾ� ȯ��(��)
       PRE_INV_AMT_CURR(003), ">ȭ������ ȭ���ڵ�(��)
       PRE_INV_AMT(020),      ">ȭ�����Աݾ�(��)
       PRE_DTY_VAL_CURR(003), ">���� ����ȭ���ڵ�(��)
       PRE_DTY_VAL(020),      ">���� ���� (��)
       PRE_DTY_PRO_RATE(011), ">������ (��)
       PRE_DTY_AMT_CURR(003), ">���� ����ȭ���ڵ�(��)
       PRE_DTY_AMT(020),      ">���� ���Աݾ� (��)
       INV_VAL_CURR(003),     ">ȭ������ ȭ���ڵ�(��)
       INV_VAL(020),          ">ȭ������  (��)
       INV_PRO_RATE(011),     ">ȭ�� ��������� (��)
       INV_EXCH_RATE(011),    ">ȭ�����Աݾ� ȯ��(��)
       INV_AMT_CURR(003),     ">ȭ������ ȭ���ڵ�(��)
       INV_AMT(020),          ">ȭ�����Աݾ�(��)
       DTY_VAL_CURR(003),     ">���� ����ȭ���ڵ�(��)
       DTY_VAL(020),          ">���� ���� (��)
       DTY_PRO_RATE(011),     ">������ (��)
       DTY_AMT_CURR(003),     ">���� ����ȭ���ڵ�(��)
       DTY_AMT(020),          ">���� ���Աݾ� (��)
       INV_DIFF_AMT(020),     ">ȭ�����Աݾ� �߻���
       DTY_DIFF_AMT(020),     ">�������Աݾ� �߻���
       REF_CD1(002),          ">�����ڵ�1
       REF_CD2(002),          ">�����ڵ�2
       REF_CD3(002),          ">�����ڵ�3
       REF_TXT1(020),         ">������ȣ1
       REF_TXT2(020),         ">������ȣ2
       REF_TXT3(025),         ">������ȣ3
       TOOL_NM(030),          ">��ۿ뱸��
       START_DATE(009),       ">�������
       BANK_CD(006),          ">���Ǳ��
       BANK_NM(020),          ">���Ǳ�� ��
       YAK_CD1(005),          ">��������1
       YAK_CD2(005),          ">��������2
       YAK_CD3(005),          ">��������3
       YAK_CD4(005),          ">��������4
       YAK_CD5(005),          ">��������5
       YAK_CD6(005),          ">��������6
       YAK_CD7(005),          ">��������7
       YAK_CD8(005),          ">��������8
       YAK_CD9(005),          ">��������9
       YAK_CD10(005),         ">��������10
       PRE_INV_PROD_RATE(011),  ">ȭ������ (��)
       PRE_VP_PROD_RATE(011),   ">VP���� (��)
       PRE_DTY_PROD_RATE(011),  ">�������� (��)
       PRE_PROD_RATE(011),      ">�հ����(��)
       PRE_PREM_EXCHG(011),     ">����� ����ȯ��(��)
       PRE_INV_E_PREM(020),     ">��ȭ ȭ�������(��)
       PRE_VP_E_PREM(020),      ">��ȭ VP�����(��)
       PRE_DTY_E_PREM(020),     ">��ȭ ���������(��)
       PRE_E_PREM(020),         ">��ȭ �հ� ����� (��)
       PRE_INV_K_PREM(020),     ">��ȭ ȭ�������(��)
       PRE_VP_K_PREM(020),      ">��ȭ VP�����(��)
       PRE_DTY_K_PREM(020),     ">��ȭ ���������(��)
       PRE_K_PREM(020),         ">��ȭ �հ� ����� (��)
       INV_PROD_RATE(011),      ">ȭ������ (��)
       VP_PROD_RATE(011),       ">VP���� (��)
       DTY_PROD_RATE(011),      ">�������� (��)
       PROD_RATE(011),          ">�հ����(��)
       PREM_EXCHG(011),         ">����� ����ȯ��(��)
       INV_E_PREM(020),         ">��ȭ ȭ�������(��)
       VP_E_PREM(020),          ">��ȭ VP�����(��)
       DTY_E_PREM(020),         ">��ȭ ���������(��)
       E_PREM(020),             ">��ȭ �հ� ����� (��)
       INV_K_PREM(020),         ">��ȭ ȭ�������(��)
       VP_K_PREM(020),          ">��ȭ VP�����(��)
       DTY_K_PREM(020),         ">��ȭ ���������(��)
       K_PREM(020),             ">��ȭ �հ� ����� (��)
       INV_E_DIFF_PREM(020),    ">��ȭ ȭ�������(����)
       VP_E_DIFF_PREM(020),     ">��ȭ VP�����(����)
       DTY_E_DIFF_PREM(020),    ">��ȭ ���������(����)
       E_DIFF_PREM(020),        ">��ȭ �հ� ����� (����)
       INV_K_DIFF_PREM(020),    ">��ȭ ȭ�������(����)
       VP_K_DIFF_PREM(020),     ">��ȭ VP�����(����)
       DTY_K_DIFF_PREM(020),    ">��ȭ ���������(����)
       K_DIFF_PREM(020),        ">��ȭ �հ� ����� (����)
       PRT_ORG_CNT(002),        ">������
       PRT_COPY_CNT(002),       ">�纻��
       PRT_BAL_DATE(009),       ">���ǹ߱�����
       PRT_AREA_CD(004),        ">���ǹ߱���
       INV_BAL_DATE(009),       ">�κ��̽� ������
       INPUT_DATE(009),         ">�Է�����
       USD_EX_RATE(11),         ">USD ȯ��
       USD_E_DIFF_PREM(020),    ">USD �հ� ����� (����)
       RCV_MARK(001).           ">����Ȯ�ο���
DATA : END OF WA.

*-----------------------------------------------------------------
*>> ���� ���̺� SEELCT.
*-----------------------------------------------------------------
   CALL  FUNCTION 'ZIM_GET_INSURANCE_DOC'
         EXPORTING
             ZFREQNO             =          ZFREQNO
             ZFINSEQ             =          ZFINSEQ
             ZFAMDNO             =          ZFAMDNO
         IMPORTING
             W_ZTINS             =          ZTINS
             W_ZTINSRSP          =          ZTINSRSP
             W_ZTINSSG3          =          ZTINSSG3
         TABLES
             IT_ZSINSAGR        =          IT_ZSINSAGR
             IT_ZSINSAGR_ORG    =          IT_ZSINSAGR_ORG
             IT_ZSINSSG2        =          IT_ZSINSSG2
             IT_ZSINSSG2_ORG    =          IT_ZSINSSG2_ORG
             IT_ZSINSSG5        =          IT_ZSINSSG5
             IT_ZSINSSG5_ORG    =          IT_ZSINSSG5_ORG
         EXCEPTIONS
             NOT_FOUND         =    4
             NOT_INPUT         =    8.

   IF SY-SUBRC NE 0.
      RAISE   NOT_FOUND.
   ENDIF.

   MOVE-CORRESPONDING : ZTINS     TO   *ZTINS,
                        ZTINSRSP  TO   *ZTINSRSP,
                        ZTINSSG3  TO   *ZTINSSG3.

*> DATA MOVE LOGIC.
*   MOVE : '01'          TO  WA-NETWORK_GB,        ">��뱸��(VAN '01')
*          '1168118600'  TO  WA-SAUPJA_NO,         ">��ǥ����ڹ�ȣ
*          'I'           TO  WA-BOJONG,            ">�����Ա���
*          'EID110860'   TO  WA-REF_NO(10),        ">����������ȣ(PK)
*          '00'          TO WA-REF_CHNG_NO.   ">����������ȣ ����

   MOVE : '01'          TO  WA-NETWORK_GB,        ">��뱸��(VAN '01')
          ZTINS-ZFELTXN TO  WA-SAUPJA_NO,         ">��ǥ����ڹ�ȣ
          'I'           TO  WA-BOJONG,            ">�����Ա���
          ZTINS-ZFREQNO TO  WA-REF_NO(10),        ">����������ȣ(PK)
          ZTINS-ZFINSEQ TO  WA-REF_NO+10(5),      ">����������ȣ(PK)
*          ZTINS-ZFAMDNO TO  WA-REF_NO+15(5),      ">����������ȣ(PK)
          ZTINS-ZFAMDNO+3(2) TO WA-REF_CHNG_NO.   ">����������ȣ ����
**

*----------------------------------------------------------------------
*> Native SQL LG ȭ�� ���̺�(TMV20)
*>   DESC : DB Link �� Synonym Create �� �۾���.
*----------------------------------------------------------------------
  EXEC SQL.
      SELECT *
         INTO :WA
         FROM ZLGITMV20
         WHERE NETWORK_GB     =    :WA-NETWORK_GB
         AND   SAUPJA_NO      =    :WA-SAUPJA_NO
         AND   BOJONG         =    :WA-BOJONG
         AND   REF_NO         =    :WA-REF_NO
         AND   REF_CHNG_NO    =    :WA-REF_CHNG_NO
   ENDEXEC.

   IF SY-SUBRC NE 0.
      RAISE NOT_SELECT.
   ENDIF.

*> �κ�����.
   ZTINS-ZFBSINS = WA-YAK_CD1.   ">�⺻ ����.

   REFRESH : IT_ZSINSAGR.
   CLEAR : L_ZFLAGR, IT_ZSINSAGR.

   IF WA-YAK_CD2 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD2 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD3 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD3 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD4 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD4 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD5 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD5 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD6 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD6 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD7 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD7 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD8 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD8 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD9 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD9 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.

   IF WA-YAK_CD10 IS INITIAL.
      ADD 10 TO L_ZFLAGR.
      MOVE : L_ZFLAGR   TO IT_ZSINSAGR-ZFLAGR,
             WA-YAK_CD10 TO IT_ZSINSAGR-ZFINSCD.
      PERFORM   GET_DD07T_SELECT(SAPMZIM00)
                USING     'ZDINSCD'  IT_ZSINSAGR-ZFINSCD
                CHANGING  IT_ZSINSAGR-ZFCNCDNM.
      APPEND  IT_ZSINSAGR.
   ENDIF.


*>> TEST...
   MOVE : WA-OBJT_CD      TO   ZTINSRSP-ZFMJM,   ">�������ڵ�.
          WA-INV_VAL_CURR TO   ZTINS-ZFINAMTC,   ">�������ȭ.
          ZTINS-ZFINAMTC  TO   ZTINSRSP-ZFDAMIC,
          ZTINS-ZFINAMTC  TO   ZTINSRSP-ZFCAMIC,
          ZTINS-ZFINAMTC  TO   ZTINSRSP-ZFTAMIC.

*>��ȭ �����
*   ZTINS-ZFINAMT = WA-INV_VAL+1.
   ZTINS-ZFINAMT = WA-E_DIFF_PREM+1.
   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                CHANGING ZTINS-ZFINAMT
                                         ZTINS-ZFINAMTC.
   MOVE : ZTINS-ZFINAMTC  TO   ZTINSRSP-ZFTAMIC,
          ZTINS-ZFINAMT   TO   ZTINSRSP-ZFTAMI.

*>���������.
   MOVE : WA-INV_PRO_RATE+1  TO   ZTINS-ZFPEIV.

*> ����ȯ��.
   MOVE : WA-INV_EXCH_RATE+1 TO   ZTINSRSP-ZFEXRT,
          1                  TO   ZTINSRSP-FFACT.

*>��ȭ.
   MOVE : 'KRW'              TO   ZTINS-ZFKRW,
          WA-K_DIFF_PREM+1   TO   ZTINS-ZFKRWAMT,   ">
*          WA-INV_AMT+1       TO   ZTINS-ZFKRWAMT,
          'KRW'              TO   ZTINSRSP-ZFTPRC,
          'KRW'              TO   ZTINSRSP-ZFCPRC,
          'KRW'              TO   ZTINSRSP-ZFDPRC,
          'KRW'              TO   ZTINSRSP-ZFVPRC,
          'KRW'              TO   ZTINSRSP-ZFIPRC.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                CHANGING ZTINS-ZFKRWAMT
                                         ZTINS-ZFKRW.

*>>����ȯ��.
   MOVE : WA-PREM_EXCHG+1   TO    ZTINSRSP-ZFEXRT,
          1                  TO   ZTINSRSP-FFACT.

*-----------------------------------------------------------
*> �κ�����(�հ����)
* ----> ������ �������� ���� ����.
*-------> �����ݾ��� �������� ���� ����.
*-----------------------------------------------------------
   MOVE : WA-PROD_RATE+1       TO    ZTINS-ZFINRT,
          WA-E_DIFF_PREM+1     TO    ZTINSRSP-ZFTAMI,   ">��ȭ�հ�.
          WA-INV_E_DIFF_PREM+1 TO    ZTINSRSP-ZFCAMI,   ">Cargo ��ȭ.
          WA-DTY_E_DIFF_PREM+1 TO    ZTINSRSP-ZFDAMI,   ">���� ��ȭ.
          WA-INV_K_DIFF_PREM+1 TO    ZTINSRSP-ZFCPR,    ">��ȭ CARGO
          WA-VP_K_DIFF_PREM+1  TO    ZTINSRSP-ZFVPR,    ">��ȭ VP
          WA-DTY_K_DIFF_PREM+1 TO    ZTINSRSP-ZFDPR,    ">��ȯ ����
          WA-K_DIFF_PREM+1     TO    ZTINSRSP-ZFTPR.    ">��ȭ ��Ż.
*>>>>>> ���� �ݾ��� ������.
*  MOVE : WA-E_PREM+1       TO    ZTINSRSP-ZFTAMI,   ">��ȭ�հ�.
*         WA-INV_E_PREM+1   TO    ZTINSRSP-ZFCAMI,   ">Cargo ��ȭ.
*         WA-DTY_E_PREM+1   TO    ZTINSRSP-ZFDAMI,   ">���� ��ȭ.
*         WA-INV_K_PREM+1   TO    ZTINSRSP-ZFCPR,    ">��ȭ CARGO
*         WA-VP_K_PREM+1    TO    ZTINSRSP-ZFVPR,    ">��ȭ VP
*         WA-DTY_K_PREM+1   TO    ZTINSRSP-ZFDPR,    ">��ȯ ����
*         WA-K_PREM+1       TO    ZTINSRSP-ZFTPR.    ">��ȭ ��Ż.

*>��ȭ.
   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFCPR
                                         ZTINS-ZFKRW.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFVPR
                                         ZTINS-ZFKRW.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFDPR
                                         ZTINS-ZFKRW.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFTPR
                                         ZTINS-ZFKRW.

*>��ȭ.
   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFTAMI
                                         ZTINSRSP-ZFTAMIC.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFCAMI
                                         ZTINSRSP-ZFTAMIC.

   PERFORM  SET_CURR_CONV_TO_INTERNAL(SAPLZIM4)
                                USING    ZTINSRSP-ZFDAMI
                                         ZTINSRSP-ZFTAMIC.

   CALL FUNCTION 'ZIM_DATE_CONVERT_INTERNAL'
        EXPORTING
            I_DATE     =      WA-CONT_DATE    ">�������
        IMPORTING
            E_DATE     =      ZTINSRSP-ZFISDT
        EXCEPTIONS
            OTHERS     =      4.
   IF SY-SUBRC NE 0.
      EXIT.
   ENDIF.

   MOVE : WA-POL_NO  TO  ZTINS-ZFINNO,
          'O'        TO  ZTINS-ZFDOCST,
          'R'        TO  ZTINS-ZFEDIST.


*   WRITE : / WA-CONT_DATE,
*/,             WA-CONT_GB,
*/,             WA-POL_NO,
*  /,           WA-CHNG_SER,
*/,             WA-ENDS_SER,
*  /,           WA-OP_POL_NO,
*    /,         WA-CNTR_ID,
*      /,       WA-CNTR_NM,
*        /,     WA-REL_ID,
*/,             WA-REL_NM,
*  /,           WA-OBJT_CD,
*    /,         WA-OBJT_TEXT,
*      /,       WA-HS_CD,
*        /,     WA-ST_AREA_CD,
*          /,   WA-ST_AREA_TXT,
*/,             WA-TRAN_AREA_CD,
*  /,           WA-TRAN_AREA_TXT,
*    /,         WA-ARR_AREA_CD,
*      /,       WA-ARR_AREA_TXT,
*        /,     WA-LAST_AREA_CD,
*          /,   WA-LAST_AREA_TXT,
*/,             WA-CLM_AGENT,
*  /,           WA-SVY_AGENT,
*    /,         WA-PRE_INV_VAL_CURR,
*      /,       WA-PRE_INV_VAL ,
*        /,     WA-PRE_INV_PRO_RATE,
*          /,   WA-PRE_INV_EXCH_RATE,
*            /, WA-PRE_INV_AMT_CURR,
*/,             WA-PRE_INV_AMT ,
*  /,           WA-PRE_DTY_VAL_CURR,
*    /,         WA-PRE_DTY_VAL ,
*      /,       WA-PRE_DTY_PRO_RATE,
*        /,     WA-PRE_DTY_AMT_CURR,
*          /,   WA-PRE_DTY_AMT,
*            /, WA-INV_VAL_CURR,
*/,             WA-INV_VAL ,
*  /,           WA-INV_PRO_RATE,
*    /,         WA-INV_EXCH_RATE,
*      /,       WA-INV_AMT_CURR,
*        /,     WA-INV_AMT,
*          /,   WA-DTY_VAL_CURR,
*            /, WA-DTY_VAL,
*/,             WA-DTY_PRO_RATE,
*  /,           WA-DTY_AMT_CURR,
*    /,         WA-DTY_AMT,
*      /,       WA-INV_DIFF_AMT,
*        /,     WA-DTY_DIFF_AMT,
*          /,   WA-REF_CD1,
*            /, WA-REF_CD2,
*/,             WA-REF_CD3,
*  /,           WA-REF_TXT1,
*    /,         WA-REF_TXT2,
*/,             WA-REF_TXT3,
*/,             WA-TOOL_NM,
*  /,           WA-START_DATE,
*    /,         WA-BANK_CD,
*      /,       WA-BANK_NM,
*        /,     WA-YAK_CD1,
*/,             WA-YAK_CD2,
*  /,           WA-YAK_CD3,
*    /,         WA-YAK_CD4,
*      /,       WA-YAK_CD5,
*        /,     WA-YAK_CD6,
*          /,   WA-YAK_CD7,
*            /, WA-YAK_CD8,
*/,             WA-YAK_CD9,
*  /,           WA-YAK_CD10,
*    /,         WA-PRE_INV_PROD_RATE,
*      /,       WA-PRE_VP_PROD_RATE,
*        /,     WA-PRE_DTY_PROD_RATE,
*          /,   WA-PRE_PROD_RATE,
*            /, WA-PRE_PREM_EXCHG,
*/,             WA-PRE_INV_E_PREM,
*/,             WA-PRE_VP_E_PREM,
*/,             WA-PRE_DTY_E_PREM,
*  /,           WA-PRE_E_PREM,
*/,             WA-PRE_INV_K_PREM,
*  /,           WA-PRE_VP_K_PREM,
*    /,         WA-PRE_DTY_K_PREM,
*      /,       WA-PRE_K_PREM,
*        /,     WA-INV_PROD_RATE,
*          /,   WA-VP_PROD_RATE,
*            /, WA-DTY_PROD_RATE,
*/,             WA-PROD_RATE,
*  /,           WA-PREM_EXCHG,
*/,             WA-INV_E_PREM,
*  /,           WA-VP_E_PREM,
*    /,         WA-DTY_E_PREM,
*      /,       WA-E_PREM,
*        /,     WA-INV_K_PREM,
*          /,   WA-VP_K_PREM,
*            /, WA-DTY_K_PREM,
*/,             WA-K_PREM,
*  /,           WA-INV_E_DIFF_PREM,
*    /,         WA-VP_E_DIFF_PREM,
*      /,       WA-DTY_E_DIFF_PREM,
*        /,     WA-E_DIFF_PREM,
*/,             WA-INV_K_DIFF_PREM,
*  /,           WA-VP_K_DIFF_PREM,
*/,             WA-DTY_K_DIFF_PREM,
*  /,           WA-K_DIFF_PREM,
*    /,         WA-PRT_ORG_CNT,
*      /,       WA-PRT_COPY_CNT,
*        /,     WA-PRT_BAL_DATE,
*          /,   WA-PRT_AREA_CD,
*            /, WA-INV_BAL_DATE,
*/,             WA-INPUT_DATE,
*  /,           WA-USD_EX_RATE,
*/,             WA-USD_E_DIFF_PREM,
*  /,           WA-RCV_MARK.


  CALL FUNCTION 'ZIM_INSURANCE_MODIFY'
       EXPORTING
            W_OK_CODE      = 'SAVE'
            ZFREQNO        = ZTINS-ZFREQNO
            ZFINSEQ        = ZTINS-ZFINSEQ
            ZFAMDNO        = ZTINS-ZFAMDNO
            ZFSTATUS       = 'U'
            W_ZTINS        = ZTINS
            W_ZTINS_OLD    = *ZTINS
            W_ZTINSRSP     = ZTINSRSP
            W_ZTINSRSP_OLD = *ZTINSRSP
            W_ZTINSSG3     = ZTINSSG3
            W_ZTINSSG3_OLD = *ZTINSSG3
            W_AMEND        = W_AMEND_MARK
       TABLES
            IT_ZSINSAGR    = IT_ZSINSAGR
            IT_ZSINSSG2    = IT_ZSINSSG2
            IT_ZSINSSG5    = IT_ZSINSSG5
       EXCEPTIONS
            ERROR_UPDATE.

  IF SY-SUBRC NE  0.
     RAISE RCV_ERROR.
  ENDIF.

ENDFUNCTION.
