FUNCTION z_fmm_get_so_inf.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(ES_ZTCA_IF_LOG) LIKE  ZTCA_IF_LOG STRUCTURE  ZTCA_IF_LOG
*"  TABLES
*"      IT_ZTMM_SO_INF STRUCTURE  ZTMM_SO_INF
*"----------------------------------------------------------------------
* P/VDR�� CCTR���� �۾����ø� sales order�� ��ȯ�ϱ� ���� process��
* ����process�� table 'ztmm_so_inf'�� data�� �������ش�.
* �Ϸ翡 �ѹ� �������� ���ÿ� �۾��ϸ�,
* error line   : zzret = ''��
* success line : zzret = 'S'�� update

* interface log ó��
* Function name : Z_FCA_EAI_INTERFACE_LOG
*  Export Parameter Structure : ZTCA_IF_LOG
*    IFDOC   <= Serial No. for Log. Leave as empty
*    TCODE   <= Present Transaction Code
*    TOTAL   <= Total Execution number
*    ZSUCC   <= Successful occurrences(number) for BDC/BAPI Processing
*    ERROR   <= Failed occurrences(number) for BDC/BAPI Processing
*    ERDAT   <= Created on.
*    ERZET   <= Created time.
*    ERNAM   <= Creator.
*    AEDAT   <= Changed on.
*    AEZET   <= Changed time
*    AENAM   <= the person who change


  DESCRIBE TABLE it_ztmm_so_inf LINES gs_ztca_if_log-total.
  CHECK gs_ztca_if_log-total <> 0.
* table creation
  LOOP AT it_ztmm_so_inf.
    UPDATE ztmm_so_inf FROM it_ztmm_so_inf.
    IF sy-subrc <> 0.
      INSERT ztmm_so_inf FROM it_ztmm_so_inf.
    ENDIF.

    gs_ztca_if_log-zsucc = gs_ztca_if_log-zsucc + 1.
    it_ztmm_so_inf-zzret = 'S'.
    MODIFY it_ztmm_so_inf.
  ENDLOOP.
* interface log
  gs_ztca_if_log-tcode = 'ZMME09'.   "Present Transaction Code
  gs_ztca_if_log-erdat = sy-datum.   "Created on.
  gs_ztca_if_log-erzet = sy-uname.   "Created time.
  gs_ztca_if_log-ernam = sy-uname.   "Created by.

  CALL FUNCTION 'Z_FCA_EAI_INTERFACE_LOG'
       EXPORTING
            i_ztca_if_log        = gs_ztca_if_log
       IMPORTING
            e_ztca_if_log        = es_ztca_if_log
       EXCEPTIONS
            update_failed        = 1
            number_range_error   = 2
            tcode_does_not_exist = 3
            OTHERS               = 4.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFUNCTION.
