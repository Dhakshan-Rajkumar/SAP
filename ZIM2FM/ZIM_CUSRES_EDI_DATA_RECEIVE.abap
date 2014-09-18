FUNCTION ZIM_CUSRES_EDI_DATA_RECEIVE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"      NO_REFERENCE
*"      NOT_TYPE
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       WL_VIA(1)        TYPE C,
       WL_TYPE(3)       TYPE C,
       WL_DOC_NO(70)    TYPE C,
       WL_DOC_TY(3)     TYPE C.

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
  CLEAR : ZTBLINOU.
  ZTBL-MANDT   = SY-MANDT.      " Client
  ZTBL-ZFDOCNO = W_ZFDHENO.     " ���ڹ��� ��ȣ

  LOOP AT IT_SAITIN_S.
    CASE IT_SAITIN_S-ZFDDFDA.
* BGM Seg. ===> ������� �Ű�/��û��ȣ
      WHEN '{10'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
* 5DF : �Ϸ��뺸
* 5AF : �����뺸
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '5DF'.      ">�Ϸ��뺸
           WHEN '5AF'.      ">�����뺸
           WHEN OTHERS.     ">ERROR
              RAISE   NOT_TYPE.
        ENDCASE.
        WL_TYPE = IT_SAITIN_A-ZFDDFDA(3).
*>>> NEXT LINE( ������ȣ )
        PERFORM READ_TABLE_1   TABLES   IT_SAITIN_A
                               CHANGING Z_ZFDDSEQ.
        WL_DOC_NO = IT_SAITIN_A-ZFDDFDA.
* ���� ����( SEND�� ������ ���� --> ����ڴ� SKIP )
      WHEN '{11'.
* �뺸���� ���� --> SKIP
      WHEN '{12'.
* ����û�뺸�Ͻ� �� ����(�Ϸ�)�Ͻ� --> SKIP
      WHEN '{13'.
* �۾� ���� --> SKIP
      WHEN '{14'.
* �ɻ������� --> SKIP
      WHEN '{15'.
* ������ ��û�� ������ �ο��� ������ȣ --> SKIP
      WHEN '{1A'.
* ��������(��û����) -->
*>> 5DA:ȯ�޽�û��,     5DB:���ʿ���ᳳ������
*>> 5DC:��ռ�������  5DD:����Ű�
*>> 5DE:��������
      WHEN '{1B'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        WL_DOC_TY = IT_SAITIN_A-ZFDDFDA.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

*>> �ش� ���� SELECT
  CASE WL_DOC_TY.
     WHEN '5DA'.  "ȯ�޽�û
     WHEN '5DB'.  "���ʿ���ᳳ������
     WHEN '5DC'.  "��ռ�������
     WHEN '5DD'.  "����Ű�
     WHEN '5DE'.  "��������
     WHEN OTHERS. "
  ENDCASE.








* ������
  MOVE : SY-DATUM    TO    ZTBLINOU-ZFRCDT,
         SY-UNAME    TO    ZTBLINOU-ERNAM,
         SY-DATUM    TO    ZTBLINOU-CDAT,
         SY-UNAME    TO    ZTBLINOU-UNAM,
         SY-DATUM    TO    ZTBLINOU-UDAT,
         W_ZFDHENO   TO    ZTBLINOU-ZFDOCNO.

  INSERT ZTBLINOU.

  IF SY-SUBRC NE  0.
     RAISE    UPDATE_ERROR.
  ELSE.
     MESSAGE  S042  WITH  ZTBLINOU-ZFBLNO ZTBLINOU-ZFBTSEQ.
  ENDIF.

  ZTDHF1-ZFDHAPP = 'Y'.
  UPDATE  ZTDHF1.

ENDFUNCTION.
