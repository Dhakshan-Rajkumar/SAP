FUNCTION ZIM_RCV_FR_EDIFEP.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFDHDOC) LIKE  ZTDHF1-ZFDHDOC
*"     VALUE(ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXPORTING
*"     VALUE(RETURN_CODE) LIKE  SY-SUBRC
*"----------------------------------------------------------------------
*-----------------------------------------------------------------------
* RETURN CODE :
*      0  : Success
*      4  : UPDATE ERROR
*      8  : NOT FOUND
*     10  : NO REFERENCE
*     12  : DOCUMENT LOCKED
*     14  : Date Convert Error
*     99  : Not Document Type
*     98  : Application DB Update
*     18  : Not Process
*-----------------------------------------------------------------------
CLEAR : RETURN_CODE.
DATA : W_TEXT100(100) TYPE C.

  SELECT SINGLE * FROM ZTDHF1 WHERE ZFDHENO EQ ZFDHENO.
  IF SY-SUBRC NE 0.   RETURN_CODE = 8.   EXIT.   ENDIF.

  CASE  ZFDHDOC.
     WHEN 'INF700' OR 'INF707' OR 'LOCADV' OR 'PURLIC' OR 'CIPADV' OR
          'ENDADV' OR 'LOGUAR' OR 'LOCAMA'.
        IF ZTDHF1-ZFDHAPP EQ 'Y'.
           CONCATENATE '���ڹ���(' ZFDHENO
               ')�� �̹� �ݿ��� �����Դϴ�. �簻�� �۾��� �Ͻðڽ��ϱ�?'
               INTO W_TEXT100.
           PERFORM   P2000_MESSAGE_BOX  USING '���� Ȯ��'
                     W_TEXT100
                     ''                  " ��� ��ư
                     '1'                 " default b
                     W_BUTTON.

           IF W_BUTTON NE '1'.
              RETURN_CODE = 98.   EXIT.
           ENDIF.
        ENDIF.
     WHEN 'SAITIN'.   " B/L ���� �۾�
        IF ZTDHF1-ZFDHAPP EQ 'Y'.
           MESSAGE I248 WITH ZFDHENO.
           RETURN_CODE = 98.   EXIT.
        ENDIF.
*-----------------------------------------------------------------------
* �ߺ� ���� ��ȸ
        SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTBL
                 FROM    ZTBL
                 WHERE   ZFHBLNO  EQ   ZTDHF1-ZFDHREF.

        IF SY-SUBRC EQ 0.
           CALL SCREEN 0100 STARTING AT  07 3
                            ENDING   AT  86 15.
           IF ANTWORT NE 'Y'.   RETURN_CODE = 18.     EXIT.    ENDIF.
        ENDIF.

     WHEN 'FINBIL' OR 'VATBIL'.    " ��꼭/���ݰ�꼭
        IF ZTDHF1-ZFDHAPP EQ 'Y'.
           MESSAGE I248 WITH ZFDHENO.
           RETURN_CODE = 98.   EXIT.
        ENDIF.
     WHEN OTHERS.
  ENDCASE.

  CASE ZFDHDOC.
     WHEN 'INF700'.           " �������伭
        CALL FUNCTION 'ZIM_INF700_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12
                    DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'INF707'.           " ���� �������伭
        CALL FUNCTION 'ZIM_INF707_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12
                    DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'LOCADV'.           " �����ſ��� ������
        CALL FUNCTION 'ZIM_LOCADV_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12.
*                   DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'LOCAMA'.           " �����ſ��� ���Ǻ���������
        CALL FUNCTION 'ZIM_LOCAMA_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12.
*                   DATE_ERROR      =   14.

        RETURN_CODE = SY-SUBRC.

     WHEN 'PURLIC'.           " ��ȭȹ��� ���ᱸ�Ž��μ�
        CALL FUNCTION 'ZIM_PURLIC_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12.
        RETURN_CODE = SY-SUBRC.

     WHEN 'CIPADV'.           " ���Ϻ��� ����
        CALL FUNCTION 'ZIM_CIPADV_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12.
*                   DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'ENDADV'.           " ���Ϻ��� �輭 ����
        CALL FUNCTION 'ZIM_ENDADV_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12.
*                   DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'SAITIN'.           " B/L ����
        CALL FUNCTION 'ZIM_SAITIN_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8.
        RETURN_CODE = SY-SUBRC.

     WHEN 'LOGUAR'.           " L/G ����
        CALL FUNCTION 'ZIM_LOGUAR_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8.
        RETURN_CODE = SY-SUBRC.

     WHEN 'CUSINF'.           " ���Կ�������
        CALL FUNCTION 'ZIM_CUSINF_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10.
        RETURN_CODE = SY-SUBRC.

     WHEN 'FINBIL'.           " ��꼭 ����
        CALL FUNCTION 'ZIM_FINBIL_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12
                    DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN 'VATBIL'.           " ���ݰ�꼭 ����
        CALL FUNCTION 'ZIM_VATBIL_EDI_DATA_RECEIVE'
             EXPORTING
                    W_ZFDHENO       =   ZFDHENO
             EXCEPTIONS
                    UPDATE_ERROR    =   4
                    NOT_FOUND       =   8
                    NO_REFERENCE    =   10
                    DOCUMENT_LOCKED =   12
                    DATE_ERROR      =   14.
        RETURN_CODE = SY-SUBRC.

     WHEN OTHERS.
        RETURN_CODE = 99.
  ENDCASE.

ENDFUNCTION.
