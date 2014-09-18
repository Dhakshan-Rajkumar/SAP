FUNCTION ZIM_INSURANCE_LG_TO_LGI.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFREQNO) LIKE  ZTINS-ZFREQNO
*"     VALUE(ZFINSEQ) LIKE  ZTINS-ZFINSEQ
*"     VALUE(ZFAMDNO) LIKE  ZTINS-ZFAMDNO
*"  EXCEPTIONS
*"      SEND_ERROR
*"----------------------------------------------------------------------
DATA : BUFFER_POINTER     TYPE     I.
DATA : PARA_LENG          TYPE     I.
DATA : W_INDEX            TYPE     I.
DATA : W_MOD              TYPE     I.
DATA : L_INV_VAL(20).
DATA : L_YAK(005)         TYPE     C.
DATA : L_ZFAMDNO          LIKE     ZTINS-ZFAMDNO.
DATA : L_ZFIVAMT          LIKE     ZTINS-ZFIVAMT.

DATA : OLD_ZTINS          LIKE     ZTINS.
DATA : OLD_ZTINSRSP       LIKE     ZTINSRSP.

DATA : BEGIN OF TEXT_RECORD,
       REC_TEXT(69)          VALUE   SPACE,
       CR_LF    TYPE   X     VALUE   '0A'.
DATA : END   OF TEXT_RECORD.

DATA : L_TCURC            LIKE TCURC.

DATA : NETWORK_GB(002)    TYPE C,   ">��뱸��(VAN '01', CERTI '02')
       SAUPJA_NO(015)     TYPE C,   ">��ǥ����ڹ�ȣ
       BOJONG(001)        TYPE C,   ">�����Ա���('I'����,'E'����)
       REF_NO(020)        TYPE C,   ">����������ȣ(PK)
       REF_CHNG_NO(002)   TYPE C,   ">����������ȣ ����
       CHUNG_DATE(009)    TYPE C,   ">û������
       CONT_GB(001)       TYPE C,   ">��౸��
       CHNG_GB_CD(002)    TYPE C,   ">�������
       POL_NO(015)        TYPE C,   ">���ǹ�ȣ
       CHUNG_NO(020)      TYPE C,   ">û���ȣ
       OP_NO(002)         TYPE C,   ">OP��ȣ
       CNTR_ID(015)       TYPE C,   ">��������
       CNTR_NM(050)       TYPE C,   ">�������� ��
       REL_ID(015)        TYPE C,   ">�Ǻ����� �ڵ�
       REL_NM(050)        TYPE C,   ">�Ǻ����� ��
       OBJT_CD(007)       TYPE C,   ">������ �ڵ�
       OBJT_TEXT(840)     TYPE C,   ">������ ����
       HS_CD(010)         TYPE C,   ">�����з��ڵ�
       ST_AREA_CD(002)    TYPE C,   ">����� �ڵ�
       ST_AREA_TXT(070)   TYPE C,   ">����� ��
       TRAN_AREA_CD(002)  TYPE C,   ">ȯ���� �ڵ�
       TRAN_AREA_TXT(070) TYPE C,   ">ȯ���� ��
       ARR_AREA_CD(002)   TYPE C,   ">������ �ڵ�
       ARR_AREA_TXT(070)  TYPE C,   ">������ ��
       LAST_AREA_CD(002)  TYPE C,   ">���������� �ڵ�
       LAST_AREA_TXT(070) TYPE C,   ">���������� ��
       CLM_AGENT(006)     TYPE C,   ">CLAIM AGENT
       SVY_AGENT(006)     TYPE C,   ">SURVEY AGENT
       INV_VAL_CURR(003)  TYPE C,   ">ȭ������ ȭ���ڵ�
*       INV_VAL(17)        TYPE C,   ">ȭ������
*       INV_PRO_RATE(11)   TYPE C,   ">ȭ�� ���������
       INV_VAL            TYPE F,   ">ȭ������
       INV_PRO_RATE       TYPE F,   ">ȭ�� ���������
*       INV_VAL(17,2)                ">ȭ������
*       INV_PRO_RATE(11,6)           ">ȭ�� ���������
       INV_AMT_CURR(003)  TYPE C,   ">ȭ������ ȭ���ڵ�
*       INV_AMT(17,2)                ">ȭ�����Աݾ�
*       INV_AMT(17)        TYPE C,    ">ȭ�����Աݾ�
       INV_AMT            TYPE F,    ">ȭ�����Աݾ�
       DTY_VAL_CURR(003)  TYPE C,    ">�������� ����ȭ���ڵ�
*       DTY_VAL(17)        TYPE C,    ">�������� ����
*       DTY_PRO_RATE(11)   TYPE C,    ">������
       DTY_VAL            TYPE F,    ">�������� ����
       DTY_PRO_RATE       TYPE F,    ">������
*       DTY_VAL(17,2)                ">�������� ����
*       DTY_PRO_RATE(11,6)           ">������
       REF_CD1(002)       TYPE C,   ">�����ڵ�1
       REF_CD2(002)       TYPE C,   ">�����ڵ�2
       REF_CD3(002)       TYPE C,   ">�����ڵ�3
       REF_TXT1(020)      TYPE C,   ">������ȣ1
       REF_TXT2(020)      TYPE C,   ">������ȣ2
       REF_TXT3(025)      TYPE C,   ">������ȣ3
       GOOD_CD(002)       TYPE C,   ">�����ڵ�
       TOOL_NM(030)       TYPE C,   ">��ۿ뱸��
       START_DATE(009)    TYPE C,   ">�������
*       HULL_TON,         6,0        ">�����
*       HULL_TON(6)        TYPE C,   ">�����
       HULL_TON           TYPE F,   ">�����
       HULL_BUILT_DATE    TYPE C,   ">������
*       HULL_YEAR(3)       TYPE C,   ">����
       HULL_YEAR          TYPE F,   ">����
       HULL_NATIONAL(2)   TYPE C,   ">����
       HULL_CLASS(2)      TYPE C,   ">����
       BANK_CD(006)       TYPE C,   ">���Ǳ��
       YAK_CD1(005)       TYPE C,   ">��������1
       YAK_CD2(005)       TYPE C,   ">��������2
       YAK_CD3(005)       TYPE C,   ">��������3
       YAK_CD4(005)       TYPE C,   ">��������4
       YAK_CD5(005)       TYPE C,   ">��������5
       YAK_CD6(005)       TYPE C,   ">��������6
       YAK_CD7(005)       TYPE C,   ">��������7
*       PRT_ORG_CNT,      2,0        ">������
*       PRT_COPY_CNT,     2,0        ">�纻��
*       PRT_ORG_CNT(2)     TYPE C,   ">������
*       PRT_COPY_CNT(2)    TYPE C,   ">�纻��
       PRT_ORG_CNT        TYPE F,   ">������
       PRT_COPY_CNT       TYPE F,   ">�纻��
       PRT_BAL_DATE(9)    TYPE C,   ">���ǹ߱�����
       PRT_AREA_CD(004)   TYPE C,   ">���ǹ߱���
       VAN_USER(030)      TYPE C,   ">�����
       INPUT_DATE(9)      TYPE C,   ">�Է�����
       PROC_STATUS(002)   TYPE C,   ">���±���
       ERR_CODE(002)      TYPE C,   ">ERROR_CODE
       PROC_USER_ID(008)  TYPE C.   ">ó�� LGȭ�� �����

*>> TEST�� �κ���û ����Ÿ �̻����� �Ͽ���.
*>> GO LIVE�� ���� ��.
*--->2001.11.26 INSERT KSB
   EXIT.



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
      RAISE   SEND_ERROR.
   ENDIF.

*> DATA MOVE LOGIC.
   MOVE : '01'          TO  NETWORK_GB,        ">��뱸��(VAN '01')
          ZTINS-ZFELTXN TO  SAUPJA_NO,         ">��ǥ����ڹ�ȣ
          'I'           TO  BOJONG,            ">�����Ա���
          ZTINS-ZFREQNO TO  REF_NO(10),        ">����������ȣ(PK)
          ZTINS-ZFINSEQ TO  REF_NO+10(5),      ">����������ȣ(PK)
*          ZTINS-ZFAMDNO TO  REF_NO+15(5),      ">����������ȣ(PK)
          ZTINS-ZFAMDNO+3(2) TO REF_CHNG_NO.   ">����������ȣ ����

   CALL FUNCTION 'ZIM_DATE_CONVERT_EXTERNAL'
        EXPORTING
            I_DATE     =      ZTINS-ZFINSDT    ">û������
        IMPORTING
            E_DATE     =      CHUNG_DATE
        EXCEPTIONS
            OTHERS     =      4.
   IF SY-SUBRC NE 0.
      EXIT.
   ENDIF.


*>>��౸��
   CASE ZTINS-ZFEDFU.
      WHEN '2'.                           ">���.
         MOVE '2' TO CONT_GB.
      WHEN OTHERS.
         IF ZTINS-ZFAMDNO GT '00000'.     ">����.
            MOVE '1' TO CONT_GB.
         ELSE.                            ">�����.
            MOVE '0' TO CONT_GB.
         ENDIF.
   ENDCASE.

*>">�������. ���ǹ�ȣ.

   IF ZTINS-ZFAMDNO GT '00000'.     ">����.
      L_ZFAMDNO = ZTINS-ZFAMDNO - 1.

      SELECT SINGLE * INTO OLD_ZTINS
             FROM ZTINS
             WHERE    ZFREQNO EQ ZFREQNO
             AND      ZFINSEQ EQ ZFINSEQ
             AND      ZFAMDNO EQ L_ZFAMDNO.

      SELECT SINGLE * INTO OLD_ZTINSRSP
             FROM  ZTINSRSP
             WHERE    ZFREQNO EQ ZFREQNO
             AND      ZFINSEQ EQ ZFINSEQ
             AND      ZFAMDNO EQ L_ZFAMDNO.


      MOVE : '05'              TO   CHNG_GB_CD,  ">�������.
             OLD_ZTINS-ZFINNO  TO   POL_NO.      ">���ǹ�ȣ.
   ELSE.
      CLEAR : CHNG_GB_CD, POL_NO.
   ENDIF.

   CLEAR : CHUNG_NO,                    ">û���ȣ .
           OBJT_CD,                     ">������ �ڵ�
           ST_AREA_CD,                  ">����� �ڵ�
           TRAN_AREA_CD,                ">ȯ���� �ڵ�
           ARR_AREA_CD,                 ">������ �ڵ�
           LAST_AREA_CD,                ">���������� �ڵ�
           CLM_AGENT,                   ">CLAIM AGENT
           SVY_AGENT,                   ">SURVEY AGENT
           INV_AMT_CURR,                ">ȭ������ ȭ���ڵ�
           INV_AMT.                     ">ȭ�����Աݾ�

*-------------------------------------------------------
*> ������ ����...
* DESC : 70BYTE * 12 ==> 70BYTE�� NewLine Character.
*-------------------------------------------------------
   CLEAR : OBJT_TEXT, W_INDEX.
   LOOP AT IT_ZSINSSG2.
      IF IT_ZSINSSG2-ZFDSOG1 IS INITIAL.
         CONTINUE.
      ENDIF.
      ADD 1 TO W_INDEX.
      TEXT_RECORD-REC_TEXT = IT_ZSINSSG2-ZFDSOG1.

      BUFFER_POINTER    =   STRLEN( OBJT_TEXT ).
      PARA_LENG         =   STRLEN( TEXT_RECORD ).
      MOVE  TEXT_RECORD TO OBJT_TEXT+BUFFER_POINTER(PARA_LENG).

      IF W_INDEX GE 12.
         EXIT.
      ENDIF.
   ENDLOOP.

   IF SY-SUBRC EQ 0.
      PERFORM P3000_EDI_RECORD_ADJUST(SAPLZIM4)  CHANGING OBJT_TEXT.
   ENDIF.

   MOVE : ZTINS-ZFOPNO+7(2) TO OP_NO,         ">OP��ȣ( 8~9�ڸ� )
          ZTINS-ZFELTXN     TO CNTR_ID,       ">����ڵ�Ϲ�ȣ.
          ZTINS-ZFELENM     TO CNTR_NM,       ">�������� ��.
          ZTINS-ZFELTXN     TO REL_ID,        ">�Ǻ����� �ڵ�.
          ZTINS-ZFELENM     TO REL_NM,        ">�Ǻ����� ��.
          ZTINS-ZFRSTAW     TO HS_CD,         ">�����з��ڵ�.
          ZTINSSG3-ZFSHCUNM TO ST_AREA_TXT,   ">����� ��
          ZTINSSG3-ZFTRCUNM TO TRAN_AREA_TXT, ">ȯ���� ��
          ZTINSSG3-ZFARCUNM TO ARR_AREA_TXT,  ">������ ��
          ZTINSSG3-ZFLACUNM TO LAST_AREA_TXT. ">���������� ��

*> CURRENCY ISO CODE SELECT.
   CLEAR : L_TCURC.
   SELECT SINGLE * INTO L_TCURC FROM TCURC
                   WHERE WAERS  EQ  ZTINS-WAERS.
   IF SY-SUBRC NE 0.
      L_TCURC-ISOCD = ZTINS-WAERS.
   ELSE.
      IF L_TCURC-ISOCD IS INITIAL.
         L_TCURC-ISOCD = ZTINS-WAERS.
      ENDIF.
   ENDIF.

   MOVE L_TCURC-ISOCD       TO INV_VAL_CURR.  ">ȭ������ ȭ���ڵ�.

*>> ȭ������.
   WRITE : ZTINS-ZFIVAMT    TO L_INV_VAL CURRENCY ZTINS-WAERS.
   PERFORM    P2000_WRITE_NO_MASK      CHANGING  L_INV_VAL.
   INV_VAL = L_INV_VAL.

*> �������� �ѱ��..
*   IF ZTINS-ZFAMDNO IS INITIAL.
*      L_ZFIVAMT = ZTINS-ZFIVAMT.
*   ELSE.
*      L_ZFIVAMT = ZTINS-ZFIVAMT - OLD_ZTINS-ZFIVAMT.
*   ENDIF.
*
*   WRITE : L_ZFIVAMT    TO L_INV_VAL CURRENCY ZTINS-WAERS.
*   PERFORM    P2000_WRITE_NO_MASK     CHANGING  L_INV_VAL.


*   IF L_ZFIVAMT LE 0.
*>���� ��ȣ ������ ������...
*      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*           CHANGING
*              VALUE   =   L_INV_VAL.
*   ENDIF.
*
*   INV_VAL = L_INV_VAL.

*>>ȭ�� ���������
*   WRITE : ZTINS-ZFPEIV     TO INV_PRO_RATE.
   INV_PRO_RATE = ZTINS-ZFPEIV.
*   INV_PRO_RATE =
*   PERFORM    P2000_WRITE_NO_MASK     CHANGING  INV_PRO_RATE.


   CLEAR : DTY_VAL_CURR,    ">�������� ����ȭ���ڵ�
           DTY_VAL,         ">�������� ����
           DTY_PRO_RATE,    ">������
           REF_CD1,         ">�����ڵ�1
           REF_CD2,         ">�����ڵ�2 (INVOICE NO.)
           REF_TXT1,        ">������ȣ1
           REF_TXT2,        ">������ȣ2
           GOOD_CD,         ">�����ڵ�
           TOOL_NM,         ">��ۿ뱸��
           START_DATE,      ">�������
           HULL_TON,        ">�����
           HULL_BUILT_DATE, ">������
           HULL_YEAR,       ">����
           HULL_NATIONAL,   ">����
           HULL_CLASS,      ">����
           BANK_CD,         ">���Ǳ��
           YAK_CD1,         ">��������1
           YAK_CD2,         ">��������2
           YAK_CD3,         ">��������3
           YAK_CD4,         ">��������4
           YAK_CD5,         ">��������5
           YAK_CD6,         ">��������6
           YAK_CD7.         ">��������7

*-------------------------------------------------------
*> ��������....
* DESC : �ִ� 7�� �ݺ�...
*-------------------------------------------------------
   YAK_CD1 = ZTINS-ZFBSINS.

   CLEAR : W_INDEX.
   LOOP AT IT_ZSINSAGR.
      ADD 1 TO W_INDEX.
      CASE W_INDEX.
         WHEN 1.   YAK_CD2 = IT_ZSINSAGR-ZFINSCD.
         WHEN 2.   YAK_CD3 = IT_ZSINSAGR-ZFINSCD.
         WHEN 3.   YAK_CD4 = IT_ZSINSAGR-ZFINSCD.
         WHEN 4.   YAK_CD5 = IT_ZSINSAGR-ZFINSCD.
         WHEN 5.   YAK_CD6 = IT_ZSINSAGR-ZFINSCD.
         WHEN 6.   YAK_CD7 = IT_ZSINSAGR-ZFINSCD.
      ENDCASE.
      IF W_INDEX GE 6.
         EXIT.
      ENDIF.
   ENDLOOP.

   IF NOT ZTINS-ZFREDON2 IS INITIAL.
      MOVE :  '01'            TO REF_CD1,    ">�����ڵ�2
              ZTINS-ZFREDON2  TO REF_TXT1.   ">������ȣ1(LC NO)
   ENDIF.
*>

   MOVE :  '07'            TO REF_CD3,        ">�����ڵ�3
           REF_NO          TO REF_TXT3,       ">������ȣ3
           ZTINS-ZFNUOD    TO PRT_ORG_CNT,    ">������
           ZTINS-ZFNUCD    TO PRT_COPY_CNT,   ">�纻��
*>> ���� ������.
*          '�̸�/TEL'      TO VAN_USER,       ">�����

           '00'            TO PROC_STATUS.    ">���±���

   CALL FUNCTION 'ZIM_DATE_CONVERT_EXTERNAL'
        EXPORTING
            I_DATE     =      SY-DATUM     ">�Է�����.
        IMPORTING
            E_DATE     =      INPUT_DATE
        EXCEPTIONS
            OTHERS     =      4.
   IF SY-SUBRC NE 0.
      EXIT.
   ENDIF.

*>> ������ �ڵ�.
   MOVE SPACE TO OBJT_CD.

*----------------------------------------------------------------------
*> Native SQL LG ȭ�� ���̺�(TMV10)
*>   DESC : DB Link �� Synonym Create �� �۾���.
*----------------------------------------------------------------------
*        CNTR_NM,       REL_ID,        REL_NM,          OBJT_CD,
  EXEC SQL.
      INSERT  INTO ZLGITMV10
      ( NETWORK_GB,    SAUPJA_NO,     BOJONG,          REF_NO,
        REF_CHNG_NO,   CHUNG_DATE,    CONT_GB,         CHNG_GB_CD,
        POL_NO,        CHUNG_NO,      OP_NO,           CNTR_ID,
        CNTR_NM,       REL_ID,        REL_NM,          OBJT_CD,
        OBJT_TEXT,     HS_CD,         ST_AREA_CD,      ST_AREA_TXT,
        TRAN_AREA_CD,  TRAN_AREA_TXT, ARR_AREA_CD,     ARR_AREA_TXT,
        LAST_AREA_CD,  LAST_AREA_TXT, CLM_AGENT,       SVY_AGENT,
        INV_VAL_CURR,  INV_VAL,       INV_PRO_RATE,    INV_AMT_CURR,
        INV_AMT,       DTY_VAL_CURR,  DTY_VAL,         DTY_PRO_RATE,
        REF_CD1,       REF_CD2,       REF_CD3,         REF_TXT1,
        REF_TXT2,      REF_TXT3,      GOOD_CD,         TOOL_NM,
                       HULL_TON,                       HULL_YEAR,
        HULL_NATIONAL, HULL_CLASS,    BANK_CD,         YAK_CD1,
        YAK_CD2,       YAK_CD3,       YAK_CD4,         YAK_CD5,
        YAK_CD6,       YAK_CD7,       PRT_ORG_CNT,     PRT_COPY_CNT,
                       PRT_AREA_CD,   VAN_USER,
        PROC_STATUS,   ERR_CODE,      PROC_USER_ID )
      VALUES
      ( :NETWORK_GB,    :SAUPJA_NO,     :BOJONG,          :REF_NO,
        :REF_CHNG_NO,   :CHUNG_DATE,    :CONT_GB,         :CHNG_GB_CD,
        :POL_NO,        :CHUNG_NO,      :OP_NO,           :CNTR_ID,
        :CNTR_NM,       :REL_ID,        :REL_NM,          :OBJT_CD,
        :OBJT_TEXT,     :HS_CD,         :ST_AREA_CD,      :ST_AREA_TXT,
        :TRAN_AREA_CD,  :TRAN_AREA_TXT, :ARR_AREA_CD,     :ARR_AREA_TXT,
        :LAST_AREA_CD,  :LAST_AREA_TXT, :CLM_AGENT,       :SVY_AGENT,
        :INV_VAL_CURR,  :INV_VAL,       :INV_PRO_RATE,    :INV_AMT_CURR,
        :INV_AMT,       :DTY_VAL_CURR,  :DTY_VAL,         :DTY_PRO_RATE,
        :REF_CD1,       :REF_CD2,       :REF_CD3,         :REF_TXT1,
        :REF_TXT2,      :REF_TXT3,      :GOOD_CD,         :TOOL_NM,
                        :HULL_TON,                        :HULL_YEAR,
        :HULL_NATIONAL, :HULL_CLASS,    :BANK_CD,         :YAK_CD1,
        :YAK_CD2,       :YAK_CD3,       :YAK_CD4,         :YAK_CD5,
        :YAK_CD6,       :YAK_CD7,       :PRT_ORG_CNT,     :PRT_COPY_CNT,
                        :PRT_AREA_CD,   :VAN_USER,
        :PROC_STATUS,   :ERR_CODE,      :PROC_USER_ID )
   ENDEXEC.

*      INSERT  INTO ZLGITMV10
*      ( NETWORK_GB,    SAUPJA_NO,     BOJONG,          REF_NO,
*        REF_CHNG_NO,   CHUNG_DATE,    CONT_GB,         CHNG_GB_CD,
*        POL_NO,        CHUNG_NO,      OP_NO,           CNTR_ID,
*        CNTR_NM,       REL_ID,        REL_NM,          OBJT_CD,
*        OBJT_TEXT,     HS_CD,         ST_AREA_CD,      ST_AREA_TXT,
*        TRAN_AREA_CD,  TRAN_AREA_TXT, ARR_AREA_CD,     ARR_AREA_TXT,
*        LAST_AREA_CD,  LAST_AREA_TXT, CLM_AGENT,       SVY_AGENT,
*        INV_VAL_CURR,  INV_VAL,       INV_PRO_RATE,    INV_AMT_CURR,
*        INV_AMT,       DTY_VAL_CURR,  DTY_VAL,         DTY_PRO_RATE,
*        REF_CD1,       REF_CD2,       REF_CD3,         REF_TXT1,
*        REF_TXT2,      REF_TXT3,      GOOD_CD,         TOOL_NM,
*                       HULL_TON,                       HULL_YEAR,
*        HULL_NATIONAL, HULL_CLASS,    BANK_CD,         YAK_CD1,
*        YAK_CD2,       YAK_CD3,       YAK_CD4,         YAK_CD5,
*        YAK_CD6,       YAK_CD7,       PRT_ORG_CNT,     PRT_COPY_CNT,
*                       PRT_AREA_CD,   VAN_USER,        INPUT_DATE,
*        PROC_STATUS,   ERR_CODE,      PROC_USER_ID )
*      VALUES
*      ( :NETWORK_GB,    :SAUPJA_NO,     :BOJONG,          :REF_NO,
*        :REF_CHNG_NO,   :CHUNG_DATE,    :CONT_GB,         :CHNG_GB_CD,
*        :POL_NO,        :CHUNG_NO,      :OP_NO,           :CNTR_ID,
*        :CNTR_NM,       :REL_ID,        :REL_NM,          :OBJT_CD,
*        :OBJT_TEXT,     :HS_CD,         :ST_AREA_CD,      :ST_AREA_TXT,
*        :TRAN_AREA_CD,  :TRAN_AREA_TXT, :ARR_AREA_CD,     :ARR_AREA_TXT
*
*        :LAST_AREA_CD,  :LAST_AREA_TXT, :CLM_AGENT,       :SVY_AGENT,
*        :INV_VAL_CURR,  :INV_VAL,       :INV_PRO_RATE,    :INV_AMT_CURR
*
*        :INV_AMT,       :DTY_VAL_CURR,  :DTY_VAL,         :DTY_PRO_RATE
*
*        :REF_CD1,       :REF_CD2,       :REF_CD3,         :REF_TXT1,
*        :REF_TXT2,      :REF_TXT3,      :GOOD_CD,         :TOOL_NM,
*                        :HULL_TON,                        :HULL_YEAR,
*        :HULL_NATIONAL, :HULL_CLASS,    :BANK_CD,         :YAK_CD1,
*        :YAK_CD2,       :YAK_CD3,       :YAK_CD4,         :YAK_CD5,
*        :YAK_CD6,       :YAK_CD7,       :PRT_ORG_CNT,     :PRT_COPY_CNT
*
*                        :PRT_AREA_CD,   :VAN_USER,        :INPUT_DATE,
*        :PROC_STATUS,   :ERR_CODE,      :PROC_USER_ID )


*>> UPDATE SUCCESS��...
   IF SY-SUBRC EQ 0.
      CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_INS_BEFORE'
                 EXPORTING
                      W_ZFREQNO     =     ZFREQNO
                      W_ZFINSEQ     =     ZFINSEQ
                      W_ZFAMDNO     =     ZFAMDNO
                      W_ZFDOCST     =     'R'
                      W_ZFEDIST     =     'S'.
   ELSE.
*>> ������..
      RAISE SEND_ERROR.
   ENDIF.

ENDFUNCTION.
