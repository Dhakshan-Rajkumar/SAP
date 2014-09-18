FUNCTION ZIM_INSURANCE_LGI_DATA_CHECK.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFREQNO) LIKE  ZTINS-ZFREQNO
*"     VALUE(ZFINSEQ) LIKE  ZTINS-ZFINSEQ
*"     VALUE(ZFAMDNO) LIKE  ZTINS-ZFAMDNO
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NOT_SELECT
*"----------------------------------------------------------------------
DATA : BUFFER_POINTER     TYPE     I.
DATA : PARA_LENG          TYPE     I.
DATA : W_INDEX            TYPE     I.
DATA : W_MOD              TYPE     I.
DATA : L_YAK(005)         TYPE     C.
DATA : W_AMEND_MARK.

DATA : L_TCURC            LIKE TCURC.

DATA : BEGIN OF WA,
       NETWORK_GB(002)    TYPE C,   ">��뱸��(VAN '01', CERTI '02')
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
       INV_VAL            TYPE F,   ">ȭ������
       INV_PRO_RATE       TYPE F,   ">ȭ�� ���������
       INV_AMT_CURR(003)  TYPE C,   ">ȭ������ ȭ���ڵ�
       INV_AMT            TYPE F,    ">ȭ�����Աݾ�
       DTY_VAL_CURR(003)  TYPE C,    ">�������� ����ȭ���ڵ�
       DTY_VAL            TYPE F,    ">�������� ����
       DTY_PRO_RATE       TYPE F,    ">������
       REF_CD1(002)       TYPE C,   ">�����ڵ�1
       REF_CD2(002)       TYPE C,   ">�����ڵ�2
       REF_CD3(002)       TYPE C,   ">�����ڵ�3
       REF_TXT1(020)      TYPE C,   ">������ȣ1
       REF_TXT2(020)      TYPE C,   ">������ȣ2
       REF_TXT3(025)      TYPE C,   ">������ȣ3
       GOOD_CD(002)       TYPE C,   ">�����ڵ�
       TOOL_NM(030)       TYPE C,   ">��ۿ뱸��
       START_DATE(009)    TYPE C,   ">�������
       HULL_TON           TYPE F,   ">�����
       HULL_BUILT_DATE    TYPE C,   ">������
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
       PRT_ORG_CNT        TYPE F,   ">������
       PRT_COPY_CNT       TYPE F,   ">�纻��
       PRT_BAL_DATE(9)    TYPE C,   ">���ǹ߱�����
       PRT_AREA_CD(004)   TYPE C,   ">���ǹ߱���
       VAN_USER(030)      TYPE C,   ">�����
       INPUT_DATE(9)      TYPE C,   ">�Է�����
       PROC_STATUS(002)   TYPE C,   ">���±���
       ERR_CODE(002)      TYPE C,   ">ERROR_CODE
       PROC_USER_ID(008)  TYPE C.   ">ó�� LGȭ�� �����
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
   MOVE : '01'          TO  WA-NETWORK_GB,        ">��뱸��(VAN '01')
          ZTINS-ZFELTXN TO  WA-SAUPJA_NO,         ">��ǥ����ڹ�ȣ
          'I'           TO  WA-BOJONG,            ">�����Ա���
          ZTINS-ZFREQNO TO  WA-REF_NO(10),        ">����������ȣ(PK)
          ZTINS-ZFINSEQ TO  WA-REF_NO+10(5),      ">����������ȣ(PK)
          ZTINS-ZFAMDNO+3(2) TO WA-REF_CHNG_NO.   ">����������ȣ ����
**

*----------------------------------------------------------------------
*> Native SQL LG ȭ�� ���̺�(TMV20)
*>   DESC : DB Link �� Synonym Create �� �۾���.
*----------------------------------------------------------------------
  EXEC SQL.
      SELECT *
         INTO :WA
         FROM ZLGITMV10
         WHERE NETWORK_GB     =    :WA-NETWORK_GB
         AND   SAUPJA_NO      =    :WA-SAUPJA_NO
         AND   BOJONG         =    :WA-BOJONG
         AND   REF_NO         =    :WA-REF_NO
         AND   REF_CHNG_NO    =    :WA-REF_CHNG_NO
   ENDEXEC.

   IF SY-SUBRC NE 0.
      RAISE NOT_SELECT.
   ENDIF.


ENDFUNCTION.
