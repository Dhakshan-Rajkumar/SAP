FUNCTION Z_HR_ESS_GET_ABSENCE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(EMPLOYEE_NUMBER) LIKE  BAPI7004-PERNR
*"     VALUE(BEGDA) TYPE  BEGDA OPTIONAL
*"     VALUE(ENDDA) TYPE  ENDDA OPTIONAL
*"  TABLES
*"      ZESS_ABSENCE STRUCTURE  ZESS_ABSENCE
*"      RETURN STRUCTURE  BAPIRETURN
*"----------------------------------------------------------------------

  DATA : $FR_DATE TYPE DATUM,
         $TO_DATE TYPE DATUM.

  IF BEGDA IS INITIAL AND ENDDA IS INITIAL.
    CONCATENATE SY-DATUM(4) '0101' INTO $FR_DATE.
    CONCATENATE SY-DATUM(4) '1231' INTO $TO_DATE.
  ELSE.
    $FR_DATE = BEGDA.
    $TO_DATE = ENDDA.
  ENDIF.

  __CLS : ZESS_ABSENCE.

  SELECT SINGLE * FROM PA0001 WHERE PERNR EQ EMPLOYEE_NUMBER
                                AND ENDDA EQ '99991231'.
  IF SY-SUBRC NE 0.
    RETURN-TYPE = 'E'.
    RETURN-MESSAGE = 'Invalid Employee Number.'.
    APPEND RETURN.
    EXIT.
  ENDIF.

  SELECT SINGLE * FROM T001P WHERE WERKS EQ PA0001-WERKS
                               AND BTRTL EQ PA0001-BTRTL.

  SELECT * FROM PA2001
  WHERE PERNR EQ EMPLOYEE_NUMBER
    AND SPRPS EQ SPACE
    AND ( BEGDA BETWEEN $FR_DATE AND $TO_DATE )
    ORDER BY BEGDA DESCENDING.
    ZESS_ABSENCE-START_DATE = PA2001-BEGDA.
    ZESS_ABSENCE-END_DATE   = PA2001-ENDDA.
    ZESS_ABSENCE-ABS_TYPE   = PA2001-AWART.
    SELECT SINGLE ATEXT INTO ZESS_ABSENCE-ABS_TYPE_TEXT
           FROM T554T WHERE SPRSL EQ SY-LANGU
                        AND MOABW EQ T001P-MOABW
                        AND AWART EQ PA2001-AWART.

    ZESS_ABSENCE-ABS_HOURS = PA2001-STDAZ.
    APPEND ZESS_ABSENCE.
    CLEAR ZESS_ABSENCE.

  ENDSELECT.

  RETURN-TYPE = 'S'.
  RETURN-MESSAGE = 'Success!'.
  APPEND RETURN.

ENDFUNCTION.