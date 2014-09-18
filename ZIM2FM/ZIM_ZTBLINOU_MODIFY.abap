FUNCTION ZIM_ZTBLINOU_MODIFY.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_OK_CODE)
*"     VALUE(ZFBLNO) LIKE  ZTBLINOU-ZFBLNO
*"     VALUE(ZFBTSEQ) LIKE  ZTBLINOU-ZFBTSEQ
*"     VALUE(ZFSTATUS)
*"     VALUE(N_ZTBLINOU) LIKE  ZTBLINOU STRUCTURE  ZTBLINOU
*"     VALUE(O_ZTBLINOU) LIKE  ZTBLINOU STRUCTURE  ZTBLINOU OPTIONAL
*"  EXCEPTIONS
*"      ERROR_UPDATE
*"----------------------------------------------------------------------
* ���� ������ ����
   IF W_OK_CODE EQ 'DELE'.   ZFSTATUS = 'X'.  ENDIF.

   MOVE : ZFBLNO   TO    ZTBLINOU-ZFBLNO,     "
          ZFBTSEQ  TO    ZTBLINOU-ZFBTSEQ,
          SY-DATUM TO    ZTBLINOU-UDAT,
          SY-UNAME TO    ZTBLINOU-UNAM.

   MOVE-CORRESPONDING N_ZTBLINOU  TO    ZTBLINOU.

* MODIFY
   CASE ZFSTATUS.
      WHEN 'C'.               " ����
         INSERT ZTBLINOU.
         IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
* change document -----------------------------------------------------
         call function 'ZIM_CHANGE_DOCUMENT_BLINOU'
              exporting
                      upd_chngind    =    'I'
                      N_ZTBLINOU     =    N_ZTBLINOU
                      O_ZTBLINOU     =    O_ZTBLINOU.
*----------------------------------------------------------------------

      WHEN 'U'.               " ����
         UPDATE ZTBLINOU.
         IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
* change document -----------------------------------------------------
         call function 'ZIM_CHANGE_DOCUMENT_BLINOU'
              exporting
                      upd_chngind    =    'U'
                      N_ZTBLINOU     =    N_ZTBLINOU
                      O_ZTBLINOU     =    O_ZTBLINOU.
*----------------------------------------------------------------------
      WHEN 'X'.               " ����
         DELETE ZTBLINOU.
         IF SY-SUBRC NE 0.    RAISE ERROR_UPDATE.   ENDIF.
* change document -----------------------------------------------------
         call function 'ZIM_CHANGE_DOCUMENT_BLINOU'
              exporting
                      upd_chngind    =    'D'
                      N_ZTBLINOU     =    N_ZTBLINOU
                      O_ZTBLINOU     =    O_ZTBLINOU.
*----------------------------------------------------------------------

      WHEN OTHERS.
  ENDCASE.
*>>>>>> SAP MODULE �̻����� CHANGE DOCUMENT�� �ݿ����� ����......

ENDFUNCTION.
