FUNCTION ZIM_DOANTC_EDI_DATA_RECEIVE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"      NO_REFERENCE
*"      DATE_ERROR
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       WL_DOC_NO        LIKE IT_SAITIN_A-ZFDDFDA,
       WL_DOC_TY(3)     TYPE C,
       W_ZFPNNO         LIKE ZTPMTHD-ZFPNNO.

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
  C_ZFDDFDA1 = '{%'.
  SELECT *  APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_S
            FROM ZTDDF1
            WHERE ZFDDENO EQ    W_ZFDHENO
            AND   ZFDDFDA LIKE  C_ZFDDFDA1.

*-----------------------------------------------------------------------
* DATA MOVE
*-----------------------------------------------------------------------
  CLEAR : ZTPMTHD.
  ZTPMTHD-MANDT   = SY-MANDT.      " Client

  LOOP AT IT_SAITIN_S.
    CASE IT_SAITIN_S-ZFDDFDA.
* BGM Seg. ===> ���ڹ�����ȣ ( SKIP )
      WHEN '{10'.
* ���ž�ü, �������� TEXT ( SKIP )
      WHEN '{11'.
* �ſ����ȣ(AAC) �� ��༭��ȣ(CT)
      WHEN '{12'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN 'AAC'.   " �ſ����ȣ
              WL_DOC_TY = 'AAC'.
           WHEN 'CT'.    " ��༭��ȣ
              WL_DOC_TY = 'CT'.
           WHEN 'AWB'.   " �װ�ȭ�������===>(SKIP)
              CONTINUE.
           WHEN 'BM'.    " �������ǹ�ȣ  ===>(SKIP)
              CONTINUE.
           WHEN OTHERS.
              CONTINUE.
        ENDCASE.
*>> ���� ��ȣ
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
        WL_DOC_NO           = IT_SAITIN_A-ZFDDFDA.
* �ݾװ��� ����
      WHEN '{13'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '154'.     " �����ݾ�
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFPNAM      = IT_SAITIN_A-ZFDDFDA.
*>>>>>> CURRENCY
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFPNAMC     = IT_SAITIN_A-ZFDDFDA.
           WHEN '304'.     " ��Ÿ������
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFBKCH      = IT_SAITIN_A-ZFDDFDA.
*>>>>>> CURRENCY
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFBKCHC     = IT_SAITIN_A-ZFDDFDA.
        ENDCASE.
* DTM ( ��������, ����������, �������� )
      WHEN '{14'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE  IT_SAITIN_A-ZFDDFDA.
           WHEN '184'.   "��������
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFNTDT      = IT_SAITIN_A-ZFDDFDA.
           WHEN '265'.   "����������
              PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                                     CHANGING Z_ZFDDSEQ.
              ZTPMTHD-ZFPYDT      = IT_SAITIN_A-ZFDDFDA.
        ENDCASE.
* ��Ÿ����   ===> SKIP
      WHEN '{15'.
* ��������� ===> SKIP
      WHEN '{16'.
    ENDCASE.                           " *  IT_SAITIN_S-ZFDDFDA
  ENDLOOP.                             " ** IT_SAITIN_S
*-----------------------------------------------------------------------
* ���ſ��� �� �����Ƿ� ���� SELECT ���� �߰��� �κ�
*   ----> SELECT �� �ش� �ʵ� MOVEó�� �߰�...
* IF WL_DOC_TY EQ 'AAC'. --> L/C
* ELSEIF WL_DOC_TY EQ 'CT' --> P/O
* ENDIF.
* WL_DOC_NO
*
* IF SY-SUBRC NE 0.
*    RAISE  NO_REFERENCE.   " NOT FOUND�� ���� ?????
* ENDIF.
*-----------------------------------------------------------------------
*>>> �ݾ� ���� �ʵ尪���� ����...
  IF NOT ZTPMTHD-ZFPNAM IS INITIAL.
     PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING ZTPMTHD-ZFPNAM
                                                   ZTPMTHD-ZFPNAMC.
  ENDIF.
  IF NOT ZTPMTHD-ZFUSIT IS INITIAL.
     PERFORM    SET_CURR_CONV_TO_INTERNAL CHANGING ZTPMTHD-ZFUSIT
                                                   ZTPMTHD-ZFUSITC.
  ENDIF.
*-----------------------------------------------------------------------
* DATE CONVERT
*-----------------------------------------------------------------------
  IF NOT ZTPMTHD-ZFPYDT IS INITIAL. "--> �����Ϸ���
     CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
                     DATE_EXTERNAL = ZTPMTHD-ZFPYDT
          IMPORTING
                     DATE_INTERNAL = ZTPMTHD-ZFPYDT.

     IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
               RAISING DATE_ERROR.
     ENDIF.
  ENDIF.

  IF NOT ZTPMTHD-ZFNTDT IS INITIAL. "--> ��������
     CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
                     DATE_EXTERNAL = ZTPMTHD-ZFNTDT
          IMPORTING
                     DATE_INTERNAL = ZTPMTHD-ZFNTDT.

     IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
               RAISING DATE_ERROR.
     ENDIF.
  ENDIF.

*>>> FIELD MOVE
  IF WL_DOC_TY EQ 'AAC'.   "--> L/C
     MOVE : WL_DOC_NO   TO    ZTPMTHD-ZFOPNNO.  " ������ȣ
  ELSEIF WL_DOC_TY EQ 'CT'."--> P/O
     MOVE : WL_DOC_NO   TO    ZTPMTHD-EBELN.    " ������ȣ
  ENDIF.

  MOVE : SY-UNAME    TO    ZTPMTHD-ERNAM,
         SY-DATUM    TO    ZTPMTHD-CDAT,
         SY-UNAME    TO    ZTPMTHD-UNAM,
         SY-DATUM    TO    ZTPMTHD-UDAT.
*>>> ���ڹ��� ��ȣ �������� ����.
*        W_ZFDHENO   TO    ZTBLINOU-ZFDOCNO.

  SELECT MAX( ZFPNNO ) INTO W_ZFPNNO FROM ZTPMTHD.
  IF W_ZFPNNO IS INITIAL.
     W_ZFPNNO = '0000000001'.
  ELSE.
     W_ZFPNNO = W_ZFPNNO + 1.
  ENDIF.

  INSERT ZTPMTHD.

  IF SY-SUBRC NE  0.
     RAISE    UPDATE_ERROR.
  ELSE.
     MESSAGE  S261  WITH  ZTPMTHD-ZFPNNO.
  ENDIF.

ENDFUNCTION.
