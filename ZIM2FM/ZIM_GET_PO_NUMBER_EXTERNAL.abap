FUNCTION ZIM_GET_PO_NUMBER_EXTERNAL.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_WERKS) LIKE  ZTREQHD-ZFWERKS
*"     VALUE(W_EBELN) LIKE  EKKO-EBELN
*"  EXPORTING
*"     VALUE(W_ADD_EBELN)
*"----------------------------------------------------------------------
*DATA : W_ZZBUSTYPE  LIKE  EKKO-ZZBUSTYPE.
DATA : W_ZZBUSTYPE  TYPE C.

*-----------------------------------------------------------------------
*>>> 2000/12/27 KSB �����۾�
   W_ADD_EBELN = W_EBELN.
   EXIT.
*-----------------------------------------------------------------------

*   SELECT SINGLE ZZBUSTYPE INTO W_ZZBUSTYPE FROM EKKO
*                           WHERE EBELN EQ W_EBELN.

   CASE W_WERKS.
      WHEN '1010'.   " ��õ
         CONCATENATE 'H' 'I' W_ZZBUSTYPE(1)
                             W_EBELN INTO W_ADD_EBELN.
      WHEN '1020'.   " û��
         CONCATENATE 'H' 'C' W_ZZBUSTYPE(1)
                             W_EBELN INTO W_ADD_EBELN.
      WHEN '1030'.   " ����
         CONCATENATE 'H' 'K' W_ZZBUSTYPE(1)
                             W_EBELN INTO W_ADD_EBELN.
      WHEN '1040'.   " ����
         CONCATENATE 'H' 'S' W_ZZBUSTYPE(1)
                             W_EBELN INTO W_ADD_EBELN.
      WHEN OTHERS.   " ��Ÿ
         CONCATENATE 'H' 'C' W_ZZBUSTYPE(1)
                             W_EBELN INTO W_ADD_EBELN.
      ENDCASE.

ENDFUNCTION.
