FUNCTION ZIM_LOCAMA_EDI_DATA_RECEIVE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      UPDATE_ERROR
*"      NOT_FOUND
*"      NO_REFERENCE
*"      DOCUMENT_LOCKED
*"      DATE_ERROR
*"----------------------------------------------------------------------
DATA : C_ZFDDFDA1(3),
       WL_VIA(1)        TYPE C,
       WL_NOREF         TYPE C    VALUE   'Y'.

  SELECT SINGLE * FROM ZTDHF1 WHERE ZFDHENO EQ W_ZFDHENO.
  IF SY-SUBRC NE 0.   RAISE   NOT_FOUND.   ENDIF.

  REFRESH: IT_SAITIN_A, IT_SAITIN_S.
* ��ü SELECT
  SELECT *  FROM ZTDDF1
            APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_A
            WHERE ZFDDENO = W_ZFDHENO.
* ������ SELECT
  SELECT *  APPENDING CORRESPONDING FIELDS OF TABLE IT_SAITIN_S
            FROM ZTDDF1
            WHERE ZFDDENO EQ    W_ZFDHENO
            AND ( ZFDDFDA LIKE  '{11%'
            OR    ZFDDFDA LIKE  '{12%' ).
* HEADER SELECT.
  CLEAR : ZTDHF1.
  SELECT SINGLE * FROM ZTDHF1 WHERE ZFDHENO EQ W_ZFDHENO.
  IF SY-SUBRC NE 0.   RAISE   NOT_FOUND.   ENDIF.

*-----------------------------------------------------------------------
* DATA MOVE
*-----------------------------------------------------------------------
  LOOP AT IT_SAITIN_S.
    CASE IT_SAITIN_S-ZFDDFDA.
* �����ſ��� ��ȣ
      WHEN '{11'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
*           WHEN 'LC'.               " �����ſ��� ��ȣ
*              Z_ZFDDSEQ = Z_ZFDDSEQ + 1.
*              READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
*              W_ZFOPNNO = IT_SAITIN_A-ZFDDFDA.
           WHEN 'DM'.                " �߽��� ������ȣ
              WL_NOREF  = 'N'.
              Z_ZFDDSEQ = Z_ZFDDSEQ + 1.
              READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
* �����Ƿ� ���� SELECT
              SELECT * FROM ZTREQST UP TO 1 ROWS
                        WHERE ( ZFDOCNO  EQ ZTDHF1-ZFDHREF
                        OR      ZFDOCNOR EQ W_ZFDHENO )
                        ORDER BY ZFREQNO DESCENDING
                                 ZFAMDNO DESCENDING.
                 EXIT.
              ENDSELECT.
              IF SY-SUBRC NE 0.   RAISE   NO_REFERENCE.   ENDIF.

* LOCK CHECK
              CALL FUNCTION 'ENQUEUE_EZ_IM_ZTREQDOC'
                   EXPORTING
                      ZFREQNO                =     ZTREQST-ZFREQNO
                      ZFAMDNO                =     ZTREQST-ZFAMDNO
                   EXCEPTIONS
                      OTHERS                 =     1.

              IF SY-SUBRC <> 0.
                 MESSAGE E510 WITH SY-MSGV1 'Import Document'
                         ZTREQST-ZFREQNO ZTREQST-ZFAMDNO
                         RAISING DOCUMENT_LOCKED.
              ENDIF.
*-----------------------------------------------------------------------
* �����̷��� ����
              O_ZTREQST = ZTREQST.
*-----------------------------------------------------------------------
        ENDCASE.
      WHEN '{12'.
        Z_ZFDDSEQ = IT_SAITIN_S-ZFDDSEQ + 1.
        READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
        CASE IT_SAITIN_A-ZFDDFDA.
           WHEN '182'.               " ��������
              Z_ZFDDSEQ = Z_ZFDDSEQ + 1.
              READ TABLE IT_SAITIN_A WITH KEY ZFDDSEQ = Z_ZFDDSEQ.
*-----------------------------------------------------------------------
* DATE CONVERT
*-----------------------------------------------------------------------
              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                   EXPORTING
                        DATE_EXTERNAL = IT_SAITIN_A-ZFDDFDA
                   IMPORTING
                        DATE_INTERNAL = ZTREQST-ZFOPNDT.

              IF SY-SUBRC <> 0.
                 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
                         RAISING DATE_ERROR.
              ENDIF.
        ENDCASE.
    ENDCASE.                           " *  IT_SAITIN_S-ZFDDFDA
  ENDLOOP.                             " ** IT_SAITIN_S

  IF WL_NOREF EQ 'Y'.
     RAISE   NO_REFERENCE.
  ENDIF.

* ���� ����
  MOVE : SY-UNAME    TO    ZTREQST-UNAM,
         SY-DATUM    TO    ZTREQST-UDAT,
         'O'         TO    ZTREQST-ZFDOCST,
         'R'         TO    ZTREQST-ZFEDIST,
         W_ZFDHENO   TO    ZTREQST-ZFDOCNOR,
         W_ZFOPNNO   TO    ZTREQST-ZFOPNNO.
*         SY-DATUM    TO    ZTREQST-ZFOPNDT.

  UPDATE ZTREQST.
  IF SY-SUBRC NE  0.   RAISE    UPDATE_ERROR.   ENDIF.

* CHANGE DOCUMENT
  CALL FUNCTION 'ZIM_CHANGE_DOCUMENT_STATUS'
     EXPORTING
        W_ZFREQNO      =     ZTREQST-ZFREQNO
        W_ZFAMDNO      =     ZTREQST-ZFAMDNO
        N_ZTREQST      =     ZTREQST
        O_ZTREQST      =     O_ZTREQST.

  CALL FUNCTION 'DEQUEUE_EZ_IM_ZTREQDOC'
         EXPORTING
             ZFREQNO                =     ZTREQST-ZFREQNO
             ZFAMDNO                =     ZTREQST-ZFAMDNO.

  ZTDHF1-ZFDHAPP = 'Y'.
  UPDATE  ZTDHF1.

  MESSAGE  S124  WITH  ZTREQST-ZFREQNO ZTREQST-ZFAMDNO '����'.

ENDFUNCTION.
