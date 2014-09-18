FUNCTION Z_HR_ESS_GET_EMP_BANK_INFO .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(EMPLOYEE_NUMBER) LIKE  BAPI7004-PERNR
*"  TABLES
*"      ZESS_EMP_BANK_DETAIL STRUCTURE  ZESS_EMP_BANK_DETAIL
*"      RETURN STRUCTURE  BAPIRETURN
*"----------------------------------------------------------------------

  __CLS : ZESS_EMP_BANK_DETAIL, P0009,P0001,P0006.

  CALL FUNCTION 'HR_READ_INFOTYPE'
       EXPORTING
            PERNR         = EMPLOYEE_NUMBER
            INFTY         = '0009'
            BEGDA         = SY-DATUM
            ENDDA         = '99991231'
            BYPASS_BUFFER = 'X'
       TABLES
            INFTY_TAB     = P0009.
  CALL FUNCTION 'HR_READ_INFOTYPE'
       EXPORTING
            PERNR         = EMPLOYEE_NUMBER
            INFTY         = '0001'
            BEGDA         = SY-DATUM
            ENDDA         = '99991231'
            BYPASS_BUFFER = 'X'
       TABLES
            INFTY_TAB     = P0001.
  CALL FUNCTION 'HR_READ_INFOTYPE'
       EXPORTING
            PERNR         = EMPLOYEE_NUMBER
            INFTY         = '0006'
            BEGDA         = SY-DATUM
            ENDDA         = '99991231'
            BYPASS_BUFFER = 'X'
       TABLES
            INFTY_TAB     = P0006.


  IF SY-SUBRC NE 0.
    RETURN-TYPE = 'E'.
    RETURN-MESSAGE = 'Invalid Employee Number'.
    APPEND RETURN.
    EXIT.
  ENDIF.

  LOOP AT P0009.
    CHECK P0009-SPRPS IS INITIAL.
    CHECK P0009-endda eq '99991231'.
    CLEAR ZESS_EMP_BANK_DETAIL.

    ZESS_EMP_BANK_DETAIL-BANK_TYPE_CODE = P0009-SUBTY.
    SELECT SINGLE STEXT INTO ZESS_EMP_BANK_DETAIL-BANK_TYPE_TEXT
    FROM T591S WHERE SPRSL EQ SY-LANGU
                 AND INFTY EQ P0009-INFTY
                 AND SUBTY EQ P0009-SUBTY.

    IF P0009-EMFTX IS INITIAL.
      ZESS_EMP_BANK_DETAIL-PAYEE = P0001-ENAME.
    ELSE.
      ZESS_EMP_BANK_DETAIL-PAYEE = P0009-EMFTX.
    ENDIF.

    IF P0009-BKPLZ IS INITIAL.
      ZESS_EMP_BANK_DETAIL-ZIP_CODE = P0006-PSTLZ.
    ELSE.
      ZESS_EMP_BANK_DETAIL-ZIP_CODE = P0009-BKPLZ.
    ENDIF.

    IF P0009-BKORT IS INITIAL.
      ZESS_EMP_BANK_DETAIL-CITY = P0006-ORT01.
    ELSE.
      ZESS_EMP_BANK_DETAIL-CITY = P0009-BKPLZ.
    ENDIF.

    SELECT SINGLE LAND1 LANDX INTO
    (ZESS_EMP_BANK_DETAIL-BANK_COUNTRY,
ZESS_EMP_BANK_DETAIL-BANK_CNTRY_NAME)
     FROM T005T WHERE SPRAS EQ SY-LANGU
                 AND LAND1 EQ P0009-BANKS.
    SELECT SINGLE BANKL BANKA
    INTO (ZESS_EMP_BANK_DETAIL-BANK_KEY,ZESS_EMP_BANK_DETAIL-BANK_NAME)
FROM BNKA
    WHERE BANKS EQ P0009-BANKS
      AND BANKL EQ P0009-BANKL .

    ZESS_EMP_BANK_DETAIL-BANK_ACCOUNT = P0009-BANKN.
    ZESS_EMP_BANK_DETAIL-PURPOSE = P0009-ZWECK.
    IF P0009-SUBTY EQ '0'.
    ELSE.
      ZESS_EMP_BANK_DETAIL-AMOUNT = P0009-BETRG.
      ZESS_EMP_BANK_DETAIL-PERCENTAGE = P0009-ANZHL.
    ENDIF.

    APPEND  ZESS_EMP_BANK_DETAIL.

  ENDLOOP.


  RETURN-TYPE = 'S'.
  RETURN-MESSAGE = 'Success!'.
  APPEND RETURN.


ENDFUNCTION.