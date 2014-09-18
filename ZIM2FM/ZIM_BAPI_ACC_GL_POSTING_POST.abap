FUNCTION ZIM_BAPI_ACC_GL_POSTING_POST.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(DOCUMENTHEADER) LIKE  BAPIACHE08 STRUCTURE  BAPIACHE08
*"  EXPORTING
*"     VALUE(OBJ_TYPE) LIKE  BAPIACHE02-OBJ_TYPE
*"     VALUE(OBJ_KEY) LIKE  BAPIACHE02-OBJ_KEY
*"     VALUE(OBJ_SYS) LIKE  BAPIACHE02-OBJ_SYS
*"  TABLES
*"      ACCOUNTGL STRUCTURE  BAPIACGL08
*"      CURRENCYAMOUNT STRUCTURE  BAPIACCR08
*"      RETURN STRUCTURE  BAPIRET2
*"      EXTENSION1 STRUCTURE  BAPIEXTC OPTIONAL
*"  EXCEPTIONS
*"      NOT_POSTING
*"----------------------------------------------------------------------
TABLES : T000.

   REFRESH : ACCOUNTGL, CURRENCYAMOUNT, RETURN, EXTENSION1.
   CLEAR : DOCUMENTHEADER.

   SELECT SINGLE * FROM T000
                   WHERE MANDT EQ SY-MANDT.

   MOVE : 'IDOC'      TO DOCUMENTHEADER-OBJ_TYPE,
          '1'          TO DOCUMENTHEADER-OBJ_KEY,
          T000-LOGSYS  TO DOCUMENTHEADER-OBJ_SYS,
          SY-UNAME     TO DOCUMENTHEADER-USERNAME,
          'BAPIs Test' TO DOCUMENTHEADER-HEADER_TXT,
          SPACE        TO DOCUMENTHEADER-OBJ_KEY_R,
          'C100'       TO DOCUMENTHEADER-COMP_CODE,
          SPACE        TO DOCUMENTHEADER-AC_DOC_NO,
          '2001'       TO DOCUMENTHEADER-FISC_YEAR,
          '20010731'   TO DOCUMENTHEADER-DOC_DATE,
          '20010731'   TO DOCUMENTHEADER-PSTNG_DATE,
          SPACE        TO DOCUMENTHEADER-TRANS_DATE,
          '07'         TO DOCUMENTHEADER-FIS_PERIOD,
          'RE'         TO DOCUMENTHEADER-DOC_TYPE,
          ''           TO DOCUMENTHEADER-REF_DOC_NO,
          ''           TO DOCUMENTHEADER-COMPO_ACC,
          ''           TO DOCUMENTHEADER-REASON_REV.



   MOVE: 1             TO ACCOUNTGL-ITEMNO_ACC, "ȸ����ǥ �����׸��ȣ
         '0000700003'      TO ACCOUNTGL-GL_ACCOUNT, "�Ѱ����������
         'C100'        TO ACCOUNTGL-COMP_CODE,  "ȸ���ڵ�
         '20000731'    TO ACCOUNTGL-PSTNG_DATE, "��ǥ������
         'RE'          TO ACCOUNTGL-DOC_TYPE,   "��ǥ����
         SPACE         TO ACCOUNTGL-AC_DOC_NO,  "ȸ����ǥ��ȣ
         '2001'        TO ACCOUNTGL-FISC_YEAR,  "ȸ�迬��
         '07'          TO ACCOUNTGL-FIS_PERIOD, "ȸ��Ⱓ
         'X'           TO ACCOUNTGL-STAT_CON,   "���� �����׸�������
         SPACE         TO ACCOUNTGL-REF_KEY_1,  "�ŷ�ó����Ű
         SPACE         TO ACCOUNTGL-REF_KEY_2,  "�ŷ�ó����Ű
         SPACE         TO ACCOUNTGL-REF_KEY_3,  "�����׸�����Ű
         SPACE         TO ACCOUNTGL-CUSTOMER,   "����ȣ
         SPACE         TO ACCOUNTGL-VENDOR_NO,  "����ó.
         '����'        TO ACCOUNTGL-ALLOC_NMBR, "������ȣ
         'ǰ��'        TO ACCOUNTGL-ITEM_TEXT,  "ǰ���ؽ�Ʈ
         SPACE         TO ACCOUNTGL-BUS_AREA,   "�������
         SPACE         TO ACCOUNTGL-COSTCENTER, "�ڽ�Ʈ����
         SPACE         TO ACCOUNTGL-ACTTYPE,    "��Ƽ��Ƽ����
         SPACE         TO ACCOUNTGL-ORDERID,    "������ȣ
         SPACE         TO ACCOUNTGL-ORIG_GROUP,
                                          "������Һ��ҷμ��� �������׷�
         SPACE         TO ACCOUNTGL-COST_OBJ,   "�����������
         SPACE         TO ACCOUNTGL-PROFIT_CTR, "���ͼ���
         SPACE         TO ACCOUNTGL-PART_PRCTR, "��Ʈ�� ���ͼ���
         SPACE         TO ACCOUNTGL-WBS_ELEMENT,
                                            "�۾����ұ������ (WBS ���)
         SPACE         TO ACCOUNTGL-NETWORK,    "�������� ��Ʈ����ȣ
         SPACE         TO ACCOUNTGL-ROUTING_NO, "������ �۾�������ȣ
         SPACE         TO ACCOUNTGL-ORDER_ITNO. "����ǰ���ȣ
   APPEND ACCOUNTGL.


   MOVE: 2             TO ACCOUNTGL-ITEMNO_ACC, "ȸ����ǥ �����׸��ȣ
         '0002151120'     TO ACCOUNTGL-GL_ACCOUNT, "�Ѱ����������
         'C100'        TO ACCOUNTGL-COMP_CODE,  "ȸ���ڵ�
         '20000731'    TO ACCOUNTGL-PSTNG_DATE, "��ǥ������
         'RE'          TO ACCOUNTGL-DOC_TYPE,   "��ǥ����
         SPACE         TO ACCOUNTGL-AC_DOC_NO,  "ȸ����ǥ��ȣ
         '2001'        TO ACCOUNTGL-FISC_YEAR,  "ȸ�迬��
         '07'          TO ACCOUNTGL-FIS_PERIOD, "ȸ��Ⱓ
         'X'           TO ACCOUNTGL-STAT_CON,   "���� �����׸�������
         SPACE         TO ACCOUNTGL-REF_KEY_1,  "�ŷ�ó����Ű
         SPACE         TO ACCOUNTGL-REF_KEY_2,  "�ŷ�ó����Ű
         SPACE         TO ACCOUNTGL-REF_KEY_3,  "�����׸�����Ű
         SPACE         TO ACCOUNTGL-CUSTOMER,   "����ȣ
         SPACE         TO ACCOUNTGL-VENDOR_NO,  "����ó.
         '����'        TO ACCOUNTGL-ALLOC_NMBR, "������ȣ
         'ǰ��'        TO ACCOUNTGL-ITEM_TEXT,  "ǰ���ؽ�Ʈ
         SPACE         TO ACCOUNTGL-BUS_AREA,   "�������
         SPACE         TO ACCOUNTGL-COSTCENTER, "�ڽ�Ʈ����
         SPACE         TO ACCOUNTGL-ACTTYPE,    "��Ƽ��Ƽ����
         SPACE         TO ACCOUNTGL-ORDERID,    "������ȣ
         SPACE         TO ACCOUNTGL-ORIG_GROUP,
                                          "������Һ��ҷμ��� �������׷�
         SPACE         TO ACCOUNTGL-COST_OBJ,   "�����������
         SPACE         TO ACCOUNTGL-PROFIT_CTR, "���ͼ���
         SPACE         TO ACCOUNTGL-PART_PRCTR, "��Ʈ�� ���ͼ���
         SPACE         TO ACCOUNTGL-WBS_ELEMENT,
                                            "�۾����ұ������ (WBS ���)
         SPACE         TO ACCOUNTGL-NETWORK,    "�������� ��Ʈ����ȣ
         SPACE         TO ACCOUNTGL-ROUTING_NO, "������ �۾�������ȣ
         SPACE         TO ACCOUNTGL-ORDER_ITNO. "����ǰ���ȣ
   APPEND ACCOUNTGL.


   MOVE: 1       TO CURRENCYAMOUNT-ITEMNO_ACC,  "ȸ����ǥ �����׸��ȣ
         '00'    TO CURRENCYAMOUNT-CURR_TYPE,   "��ȭ���� �� �򰡺�
         'KRW'   TO CURRENCYAMOUNT-CURRENCY,    "��ȭŰ
         SPACE   TO CURRENCYAMOUNT-CURRENCY_ISO,"ISO �ڵ���ȭ
         '139854.0000'  TO CURRENCYAMOUNT-AMT_DOCCUR,  "��ǥ��ȭ�ݾ�
         0 TO CURRENCYAMOUNT-EXCH_RATE,   "ȯ��
         0 TO CURRENCYAMOUNT-EXCH_RATE_V. "����ȣ��ȯ��
   APPEND CURRENCYAMOUNT.

   MOVE: 2       TO CURRENCYAMOUNT-ITEMNO_ACC,  "ȸ����ǥ �����׸��ȣ
         '00'    TO CURRENCYAMOUNT-CURR_TYPE,   "��ȭ���� �� �򰡺�
         'KRW'   TO CURRENCYAMOUNT-CURRENCY,    "��ȭŰ
         SPACE   TO CURRENCYAMOUNT-CURRENCY_ISO,"ISO �ڵ���ȭ
         '139854.0000'  TO CURRENCYAMOUNT-AMT_DOCCUR,  "��ǥ��ȭ�ݾ�
         0 TO CURRENCYAMOUNT-EXCH_RATE,   "ȯ��
         0 TO CURRENCYAMOUNT-EXCH_RATE_V. "����ȣ��ȯ��
   APPEND CURRENCYAMOUNT.










   CALL FUNCTION 'BAPI_ACC_GL_POSTING_POST'
       EXPORTING
         DOCUMENTHEADER = DOCUMENTHEADER
       IMPORTING
         OBJ_TYPE       =  OBJ_TYPE
         OBJ_KEY        =  OBJ_KEY
         OBJ_SYS        =  OBJ_SYS
       TABLES
         ACCOUNTGL      = ACCOUNTGL
         CURRENCYAMOUNT = CURRENCYAMOUNT
         RETURN         = RETURN
         EXTENSION1     = EXTENSION1
       EXCEPTIONS
         OTHERS         =  1.

  IF SY-SUBRC <> 0.
     ROLLBACK WORK.
  ELSE.
     COMMIT WORK.
  ENDIF.

ENDFUNCTION.
