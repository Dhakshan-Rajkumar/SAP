
REPORT ZRIM_DATA_MIGRATION_ZIM21
        NO STANDARD PAGE HEADING LINE-SIZE 255.

INCLUDE ZRIM_DATA_MIG_F01.

TABLES : ZTREQHD, ZTREQIT.

DATA: BEGIN OF IT_BLIT OCCURS 0,
       ZFSHNO LIKE ZTBLIT-ZFSHNO,
       EBELN  LIKE ZTBLIT-EBELN,
       EBELP  LIKE ZTBLIT-EBELP,
       BLMENGE(17).
DATA: END OF IT_BLIT.

DATA: BEGIN OF IT_BL OCCURS 0,
       ZFSHNO   LIKE ZTBL-ZFSHNO,
       ZFREBELN LIKE ZTBL-ZFREBELN,
       ZFSHTY   LIKE ZTBL-ZFSHTY,
*       ZFFORD   LIKE ZTBL-ZFFORD,
       ZFVIA    LIKE ZTBL-ZFVIA,
       ZFCARNM  LIKE ZTBL-ZFCARNM,
       ZF20FT(02),
       ZF40FT(02),
       ZFGITA(02),
       ZFGTPK   LIKE ZTBL-ZFGTPK,
       ZFNEWT(17),
       ZFNEWTM  LIKE ZTBL-ZFNEWTM,
       ZFTOVL(17),
       ZFTOVLM  LIKE ZTBL-ZFTOVLM,
       ZFETD(10),
       ZFCARC   LIKE ZTBL-ZFCARC,
       ZFSPRTC  LIKE ZTBL-ZFSPRTC,
       ZFAPRTC  LIKE ZTBL-ZFAPRTC,
       ZFHBLNO  LIKE ZTBL-ZFHBLNO,
       ZFMBLNO  LIKE ZTBL-ZFMBLNO,
       ZFBLDT(10).
DATA: END OF IT_BL.


DATA : W_ERROR_FLAG,
       W_REMARK(70),
       W_LINE        TYPE   I,
       W_LINE_CNT(4),
       W_ZFREQNO(25),   " �����Ƿڹ�ȣ.
       W_ZFITMNO(25),   " �����Ƿ� ǰ���ȣ.
       W_BLMENGE(25).   " B/L����.




*==============================================
PARAMETERS : P_PATH1 LIKE RLGRAP-FILENAME,
             P_PATH2 LIKE RLGRAP-FILENAME.
PARAMETERS : P_MODE TYPE C.
*===============================================
START-OF-SELECTION.

  PERFORM READ_DATA_FILE TABLES IT_BLIT
                         USING  P_PATH2.
  PERFORM READ_DATA_FILE TABLES IT_BL
                         USING  P_PATH1.

* HEADER DATA LOOP ���鼭 ���� �����ϱ�.
  LOOP AT IT_BL.

    CLEAR : W_ERROR_FLAG.
*   BDC �����.
    READ TABLE IT_BLIT WITH KEY EBELN = IT_BL-ZFREBELN
                                ZFSHNO = IT_BL-ZFSHNO.
    IF SY-SUBRC NE 0.
      WRITE :/ '���Ͽ� Item data�� �����ϴ�.(���Ź�����ȣ :',
               IT_BL-ZFREBELN, IT_BL-ZFSHNO, ')'.
      CONTINUE.
    ENDIF.

    CLEAR IT_BLIT.
    PERFORM P2000_MAKE_BDC_DATA.
    IF W_ERROR_FLAG = 'X'.
      CONTINUE.
    ENDIF.

*>> BDC CALL.
    PERFORM BDC_TRANSACTION USING 'ZIM21' P_MODE
                         CHANGING  W_SUBRC.

    IF W_SUBRC NE 0.
      WRITE : 'BDC ERROR(���Ź�����ȣ :',
               IT_BL-ZFREBELN, IT_BL-ZFSHNO, ')'.
      CONTINUE.
    ENDIF.

  ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  P2000_MAKE_BDC_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_MAKE_BDC_DATA .
  REFRESH : BDCDATA. CLEAR : BDCDATA.

*>> B/L���� �ʱ�ȭ��.==========================================>
  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'           '0100',
         ' ' 'BDC_OKCODE'          '=ENTR',
         ' ' 'ZSREQHD-ZFHBLNO'     IT_BL-ZFHBLNO.   "HouseB/L.

    PERFORM P2000_DYNPRO USING :   " �Ϲ�P/O�� B/L����.
           ' ' 'RADIO_PO'            'X',
           ' ' 'ZSREQHD-EBELN'       IT_BL-ZFREBELN. "P/O��ȣ.
*>> B/L �Ϲ�����.==============================================>
  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'        '0101',
         ' ' 'BDC_OKCODE'       '=ITM6',
         ' ' 'ZTBL-ZFSHTY'      IT_BL-ZFSHTY,
         ' ' 'ZTBL-ZFVIA'       IT_BL-ZFVIA,
         ' ' 'ZTBL-ZFCARNM'     IT_BL-ZFCARNM,
         ' ' 'ZTBL-ZF20FT'      IT_BL-ZF20FT,
         ' ' 'ZTBL-ZF40FT'      IT_BL-ZF40FT,
         ' ' 'ZTBL-ZFGITA'      IT_BL-ZFGITA,     " ��Ÿ.
         ' ' 'ZTBL-ZFGTPK'      IT_BL-ZFGTPK,  " ��Ÿ����.
         ' ' 'ZTBL-ZFETD'       IT_BL-ZFETD,
*         ' ' 'ZTBL-ZFETA'
*         ' ' 'ZTBL-ZFFORD'      IT_BL-IFWD_COD,       "Forwarder
         ' ' 'ZTBL-ZFCARC'      IT_BL-ZFCARC,       " ������.
         ' ' 'ZTBL-ZFSPRTC'     IT_BL-ZFSPRTC,
         ' ' 'ZTBL-ZFAPRTC'     IT_BL-ZFAPRTC,
*         ' ' 'ZTBL-ZFFRE'       IT_BL-MCLS_DRN,      " ���ǿ��Ӵܰ�.
*         ' ' 'ZTBL-ZFRGDSR'     IT_BLIT-NMFN_SIZ(70), "��ǥǰ��.
*         ' ' 'ZTBL-ZFBLAMC'     IT_BL-ICTR_CUY,
*         ' ' 'ZTBL-ZFBLAMT'     IT_BL-MLOD_MOY,
         ' ' 'ZTBL-ZFMBLNO'     IT_BL-ZFMBLNO,
         ' ' 'ZTBL-ZFBLDT'      IT_BL-ZFBLDT.     " �Ǽ�����.


*>> B/L ���系��.============================================>
  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'           '0101',
         ' ' 'BDC_OKCODE'          '=MKA1',
         ' ' 'ZTBL-ZFNEWT'         IT_BL-ZFNEWT,  "�߷�.
         ' ' 'ZTBL-ZFNEWTM'        IT_BL-ZFNEWTM,
         ' ' 'ZTBL-ZFTOVL'         IT_BL-ZFTOVL,  "����.
         ' ' 'ZTBL-ZFTOVLM'        IT_BL-ZFTOVLM.
  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'           '0101',
         ' ' 'BDC_OKCODE'          '=DEL1'.

  CLEAR : W_LINE, W_LINE_CNT, IT_BLIT.

* ���系�����̺� ä���.
  LOOP AT IT_BLIT WHERE EBELN = IT_BL-ZFREBELN
                    AND ZFSHNO = IT_BL-ZFSHNO.

    ADD 1 TO W_LINE.
    IF W_LINE GT 14.
*   >>PAGE DOWN.
      PERFORM P2000_DYNPRO USING :
             'X' 'SAPMZIM01'           '0101',
             ' ' 'BDC_OKCODE'          '=PGDN'.
      W_LINE = 1.
    ENDIF.

    W_LINE_CNT = W_LINE.
    PERFORM P2000_GENERAL_ITEM_BDC.

  ENDLOOP.
*>> B/L ����.  ============================================>
  IF W_ERROR_FLAG EQ 'X'.
    EXIT.
  ELSE.
    PERFORM P2000_DYNPRO USING :
           'X' 'SAPMZIM01'           '0101',
           ' ' 'BDC_OKCODE'          '=SAVE'.

    PERFORM P2000_DYNPRO USING :
           'X' 'SAPMZIM01'           '0001',
           ' ' 'BDC_OKCODE'          '=YES'.

  ENDIF.



ENDFORM.                    " P2000_MAKE_BDC_DATA
*&---------------------------------------------------------------------*
*&      Form  P2000_GENERAL_ITEM_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P2000_GENERAL_ITEM_BDC .

  CLEAR : W_ZFREQNO, W_ZFITMNO, W_BLMENGE, ZTREQIT.

  SELECT SINGLE * FROM ZTREQIT
                 WHERE EBELN   =   IT_BLIT-EBELN
                   AND EBELP   =   IT_BLIT-EBELP.

  IF SY-SUBRC NE 0.
    WRITE : / '�����Ƿڿ� ���� �����Դϴ�.',
              IT_BLIT-EBELN,  IT_BLIT-EBELP.
    W_ERROR_FLAG = 'X'.
    EXIT.
  ENDIF.
  CONDENSE W_LINE_CNT.
  CONCATENATE 'ZSBLIT-ZFREQNO(' W_LINE_CNT ')' INTO W_ZFREQNO.
  CONCATENATE 'ZSBLIT-ZFITMNO(' W_LINE_CNT ')' INTO W_ZFITMNO.
  CONCATENATE 'ZSBLIT-BLMENGE(' W_LINE_CNT ')' INTO W_BLMENGE.
*  CONCATENATE 'ZSBLIT-SERNR(' W_LINE_CNT ')'   INTO W_SERNR.

  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'           '0101',
         ' ' 'BDC_OKCODE'          '=ENTR',
         ' '  W_ZFREQNO            ZTREQIT-ZFREQNO,
         ' '  W_ZFITMNO            ZTREQIT-ZFITMNO.

  PERFORM P2000_DYNPRO USING :
         'X' 'SAPMZIM01'           '0101',
         ' ' 'BDC_OKCODE'          '=ENTR',
*        ' '  W_SERNR              IT_WEBBLIT-STAG_SEQ,  "TAG����.
         ' '  W_BLMENGE            IT_BLIT-BLMENGE.

ENDFORM.                    " P2000_GENERAL_ITEM_BDC
