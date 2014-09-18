FUNCTION ZIM_VENDOR_AP_CLEARING.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_STAUTS) TYPE  C
*"     VALUE(ZTPMTHD) LIKE  ZTPMTHD STRUCTURE  ZTPMTHD
*"  TABLES
*"      IT_ZSPMTIV STRUCTURE  ZSPMTIV
*"----------------------------------------------------------------------
DATA : TEMP_XBLNR  LIKE BKPF-XBLNR,
       TEMP_BKTXT  LIKE BKPF-BKTXT,
       TEMP_AUGTX  LIKE RF05A-AUGTX.


   TEMP_AUGTX = 'Vendor AP����(BANK)'.

*> ������ȣ...
   IF NOT ZTPMTHD-ZFHBLNO IS INITIAL.
      TEMP_XBLNR = ZTPMTHD-ZFHBLNO.
   ELSE.
      IF NOT ZTPMTHD-ZFOPNNO IS INITIAL.
         TEMP_XBLNR = ZTPMTHD-ZFOPNNO.
      ELSE.
         IF NOT ZTPMTHD-ZFISNO IS INITIAL.
            TEMP_XBLNR = ZTPMTHD-ZFISNO.
         ELSE.
            TEMP_XBLNR = ZTPMTHD-EBELN.
         ENDIF.
      ENDIF.
   ENDIF.

   REFRESH : BDCDATA.

   LOOP AT IT_ZSPMTIV.

      IF IT_ZSPMTIV-ZFCIVRN IS INITIAL.

      ENDIF.
      PERFORM P2000_DYNPRO USING :
                  'X' 'SAPMF05A'    '0122',
                  ' ' 'BKPF-BUKRS'  ZTPMTHD-BUKRS,      ">ȸ���ڵ�.
                  ' ' 'BKPF-BLART'  'RE',               ">��������.
                  ' ' 'BKPF-BLDAT'  IT_ZSPMTIV-BLDAT,   ">��������.
                  ' ' 'BKPF-BUDAT'  IT_ZSPMTIV-BUDAT,   ">��������.
*                  ' ' 'BKPF-WAERS'  IT_ZSPMTIV-ZFPNAMC, ">��ȭ����.
                  ' ' 'BKPF-KURSF'  1,
                  ' ' 'BKPF-XBLNR'  TEMP_XBLNR,
                  ' ' 'BKPF-BKTXT'  TEMP_BKTXT,
                  ' ' 'RF05A-AUGTX' TEMP_AUGTX,
                  ' ' 'RF05A-NEWBS' '31',
                  ' ' 'RF05A-NEWKO' ZTPMTHD-ZFOPBN,
                  ' ' 'BDC_OKCODE'  '=SL'.










   ENDLOOP.


ENDFUNCTION.
