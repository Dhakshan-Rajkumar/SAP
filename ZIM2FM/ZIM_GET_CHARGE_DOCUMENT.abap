FUNCTION ZIM_GET_CHARGE_DOCUMENT.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(BUKRS) TYPE  ZTBKPF-BUKRS
*"     VALUE(BELNR) TYPE  ZTBKPF-BELNR
*"     VALUE(GJAHR) TYPE  ZTBKPF-GJAHR
*"  EXPORTING
*"     VALUE(W_ZTBKPF) TYPE  ZTBKPF
*"  TABLES
*"      IT_ZSBSEG STRUCTURE  ZSBSEG
*"      IT_ZSBSEG_OLD STRUCTURE  ZSBSEG OPTIONAL
*"      IT_ZSBDIV STRUCTURE  ZSBDIV OPTIONAL
*"      IT_ZSBHIS STRUCTURE  ZSBHIS OPTIONAL
*"  EXCEPTIONS
*"      NOT_FOUND
*"      COMPANDYCODE_NOT_INPUT
*"      DOCUMENT_NO_NOT_INPUT
*"      FISC_YEAR_NOT_INPUT
*"----------------------------------------------------------------------
  REFRESH : IT_ZSBSEG, IT_ZSBDIV, IT_ZSBSEG_OLD, IT_ZSBHIS.

  CLEAR : W_ZTBKPF.

  IF BUKRS IS INITIAL.   RAISE COMPANDYCODE_NOT_INPUT.   ENDIF.
  IF BELNR IS INITIAL.   RAISE DOCUMENT_NO_NOT_INPUT.    ENDIF.
  IF GJAHR IS INITIAL.   RAISE FISC_YEAR_NOT_INPUT.      ENDIF.

*-----------------------------------------------------------------------
*>> ��� ���.
*-----------------------------------------------------------------------
  SELECT SINGLE * INTO W_ZTBKPF
                  FROM ZTBKPF
                  WHERE BUKRS EQ BUKRS
                  AND   BELNR EQ BELNR
                  AND   GJAHR EQ GJAHR.
  IF SY-SUBRC NE 0.    RAISE NOT_FOUND.   ENDIF.

*-----------------------------------------------------------------------
*>> ��� ������.
*-----------------------------------------------------------------------
  REFRESH : IT_ZSBSEG.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBSEG
                FROM ZTBSEG
                WHERE BUKRS EQ BUKRS
                AND   BELNR EQ BELNR
                AND   GJAHR EQ GJAHR.

*-----------------------------------------------------------------------
* ��� ������ ���� TEXT GET.
*-----------------------------------------------------------------------
  LOOP AT IT_ZSBSEG.
     W_TABIX = SY-TABIX.
     SELECT SINGLE ZFCDNM INTO IT_ZSBSEG-ZFCDNM FROM ZTIMIMG08
                          WHERE ZFCDTY EQ IT_ZSBSEG-ZFCSTGRP
                          AND   ZFCD   EQ IT_ZSBSEG-ZFCD.
*>> ��� �׷캰 TEXT.
     CASE IT_ZSBSEG-ZFCSTGRP.
        WHEN '003'.             ">�����Ƿں��.
        WHEN '004' OR '005'.    ">B/L ���ú��.
        WHEN '006'.             ">������ú��.
        WHEN '007'.             ">�Ͽ����ú��.
        WHEN OTHERS.
     ENDCASE.
     MODIFY IT_ZSBSEG INDEX W_TABIX.
  ENDLOOP.
  IT_ZSBSEG_OLD[] = IT_ZSBSEG[].

*-----------------------------------------------------------------------
*>> ����γ���.
*-----------------------------------------------------------------------
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBDIV
                FROM ZTBDIV
                WHERE BUKRS EQ BUKRS
                AND   BELNR EQ BELNR
                AND   GJAHR EQ GJAHR.

*-----------------------------------------------------------------------
*>> ������� �̷�.
*-----------------------------------------------------------------------
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBHIS
                FROM ZTBHIS
                WHERE BUKRS EQ BUKRS
                AND   BELNR EQ BELNR
                AND   GJAHR EQ GJAHR.


ENDFUNCTION.
