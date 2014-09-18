FUNCTION ZIM_LG_PAYORD_EDI_DOC .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFREQNO) LIKE  ZTREQHD-ZFREQNO
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"     VALUE(W_BAHNS) LIKE  LFA1-BAHNS
*"  EXPORTING
*"     REFERENCE(W_EDI_RECORD)
*"  EXCEPTIONS
*"      CREATE_ERROR
*"----------------------------------------------------------------------
DATA : L_TEXT         LIKE     DD07T-DDTEXT,
       L_TEXT280(280) TYPE     C,
       L_TEXT350(350) TYPE     C,
       L_BOOLEAN      TYPE     C,
       L_TYPE(002)    TYPE     C,
       L_TYPE_TEMP    LIKE     L_TYPE,
       L_CODE(003)    TYPE     C,
       L_ZFDSOG1      LIKE     IT_ZSMLCSG7G-ZFDSOG1,
       L_ZFDSOG2      LIKE     IT_ZSMLCSG7G-ZFDSOG1,
       L_ZFDSOG3      LIKE     IT_ZSMLCSG7G-ZFDSOG1,
       L_ZFDSOG4      LIKE     IT_ZSMLCSG7G-ZFDSOG1,
       L_ZFDSOG5      LIKE     IT_ZSMLCSG7G-ZFDSOG1.

*> TT DATA GET.
*   CALL FUNCTION 'ZIM_GET_PAYORD_DOC_DATA'
*        EXPORTING
*              ZFREQNO           =       W_ZFREQNO
*        IMPORTING
*              W_ZTTTHD          =       ZTTTHD
*        TABLES
*              IT_ZSTTSG5        =       IT_ZSTTSG5
*              IT_ZSTTSG5_ORG    =       IT_ZSTTSG5_ORG
*        EXCEPTIONS
*              NOT_FOUND     =       4
*              NOT_INPUT     =       8.

   CASE SY-SUBRC.
      WHEN 4.
         MESSAGE E018 WITH W_ZFREQNO RAISING  CREATE_ERROR.
      WHEN 8.
         MESSAGE E019 RAISING  CREATE_ERROR.
   ENDCASE.
*>> �����Ƿ� HEADER TABLE
   SELECT SINGLE * FROM ZTREQHD
          WHERE    ZFREQNO  EQ   W_ZFREQNO.

*>> �����Ƿ� ���� TABLE
   SELECT SINGLE * FROM ZTREQST
          WHERE    ZFREQNO  EQ  W_ZFREQNO
          AND      ZFAMDNO  EQ  W_ZFAMDNO.

*-----------------------------------------------------------------------
* FLAT-FILE RECORD CREATE
*-----------------------------------------------------------------------
   L_TYPE  =  '00'.

*>> FLAT FILE HEADER MAKE.
   PERFORM  P3000_HEADER_MAKE    USING    'PAYORD'
                                          ZTREQHD-BUKRS
                                          ZTREQHD-ZFOPBN
                                          W_ZFDHENO
                                 CHANGING W_EDI_RECORD.

*>> FLAT FILE BEG MAKE.(���ڹ��� ����)
   L_TYPE = '01'.
   PERFORM  P3000_BGM_MAKE       USING    '450'
                                          W_ZFDHENO
                                          ZTTTHD-ZFEDFN
                                          'AB'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE DTM MAKE(��û����).
   L_TYPE = '02'.
   PERFORM  P3000_DTM_MAKE       USING    '2AA'
                                          ZTREQST-ZFAPPDT
                                          '101'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE DTM MAKE(��ü�������).
   IF NOT ZTTTHD-ZFHOPEDT IS INITIAL.
      L_TYPE = '02'.
      PERFORM  P3000_DTM_MAKE       USING    '203'
                                             ZTTTHD-ZFHOPEDT
                                             '101'
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE RFF MAKE ( ��Ÿ��ȣ-���ڹ�����ȣ )
   L_TYPE = '03'.
   PERFORM  P3000_RFF_MAKE       USING    'ACD'
                                          W_ZFDHENO
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE BUS MAKE.(�������ü� �뵵-�ؿܼ۱�(��ȭ))
   L_TYPE = '04'.
   PERFORM  P3000_BUS_1_MAKE     USING    ZTTTHD-ZFBUSFUN
                                          ZTTTHD-ZFCOMMTY
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE FTX MAKE( �۱ݳ��� ).
   IF NOT ( ZTTTHD-ZFSEND1 IS INITIAL AND
            ZTTTHD-ZFSEND2 IS INITIAL AND
            ZTTTHD-ZFSEND3 IS INITIAL AND
            ZTTTHD-ZFSEND4 IS INITIAL AND
            ZTTTHD-ZFSEND5 IS INITIAL ).
      L_TYPE = '05'.
      PERFORM  P3000_FTX_MAKE       USING    'PMD'
                                             ZTTTHD-ZFSEND1
                                             ZTTTHD-ZFSEND2
                                             ZTTTHD-ZFSEND3
                                             ZTTTHD-ZFSEND4
                                             ZTTTHD-ZFSEND5
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE PAI MAKE (�۱ݹ��).
   L_TYPE = '06'.
   PERFORM  P3000_PAI_MAKE       USING    ZTTTHD-ZFSENDTY
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE FCA MAKE (�ΰ������� �δ���).
   L_TYPE = '07'.
   PERFORM  P3000_FCA_MAKE       USING    ZTTTHD-ZFCFRG
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE MOA MAKE (���ޱݾ�).
   L_TYPE = '08'.
   PERFORM  P3000_MOA_MAKE       USING    '9'
                                          ZTTTHD-ZFAMT
                                          ZTTTHD-WAERS
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE FII MAKE.(����(�Ƿ�)����).
   L_TYPE = '09'.
   PERFORM  P3000_FII_1_MAKE     USING    'OR'
                                          ZTTTHD-ZFOPBNCD
                                          ZTTTHD-ZFOBNM
                                          ZTTTHD-ZFOBBR
                                          ZTTTHD-ZFOBAK
                                          ZTTTHD-WAERS
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> ������ ����.
   L_TYPE = '09'.
   PERFORM  P3000_FII_1_MAKE     USING    'BF'
                                          ZTTTHD-ZFBENCD
                                          ZTTTHD-ZFBENM
                                          ZTTTHD-ZFBEBR
                                          ZTTTHD-ZFOBAK1
                                          ZTTTHD-WAERS
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE NAD MAKE.(�����Ƿ���).
   IF NOT ( ZTTTHD-ZFAPPNM  IS INITIAL OR
            ZTTTHD-ZFAPPAD1 IS INITIAL ).

      L_TYPE = '10'.
      PERFORM  P3000_NAD_PAY       USING    'OY'
                                             ZTTTHD-ZFELEID
                                             ZTTTHD-ZFAPPNM
                                             SPACE
                                             SPACE
                                             ZTTTHD-ZFAPPAD1
                                             ZTTTHD-ZFAPPAD2
                                             ZTTTHD-ZFAPPAD3
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.

*>> FLAT FILE FII MAKE.(����(�Ƿ�)����).
      IF NOT ZTTTHD-ZFTELNO IS INITIAL.
         L_TYPE = '11'.
         PERFORM  P3000_COM_MAKE        USING     ZTTTHD-ZFTELNO
                                                 'TE'
                                        CHANGING L_TYPE
                                                 W_EDI_RECORD.
      ENDIF.
   ENDIF.

*>> FLAT FILE NAD MAKE.(������).
   IF NOT ( ZTTTHD-ZFBENI1 IS INITIAL AND
            ZTTTHD-ZFBENI2 IS INITIAL AND
            ZTTTHD-ZFBENI3 IS INITIAL ).
      L_TYPE = '10'.
      PERFORM  P3000_NAD_PAY       USING    'BE'
                                             SPACE
                                             ZTTTHD-ZFBENI1
                                             SPACE
                                             SPACE
                                             ZTTTHD-ZFBENI2
                                             ZTTTHD-ZFBENI3
                                             SPACE
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE NAD MAKE.(���ڼ���).
   L_TYPE = '10'.
   PERFORM  P3000_NAD_PAY       USING    'AX'
                                          SPACE
                                          ZTTTHD-ZFELENM
                                          ZTTTHD-ZFREPRE
                                          ZTTTHD-ZFELEID
                                          SPACE
                                          SPACE
                                          SPACE
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> ���ô����.
   L_TYPE = '12'.
   PERFORM  P3000_INP_PAY_MAKE   USING    'OY'
                                          'OR'
*                                          SPACE
*                                          SPACE
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> ��Ÿ����.
   IF NOT ( ZTTTHD-ZFETC1 IS INITIAL AND
            ZTTTHD-ZFETC2 IS INITIAL AND
            ZTTTHD-ZFETC3 IS INITIAL AND
            ZTTTHD-ZFETC4 IS INITIAL AND
            ZTTTHD-ZFETC5 IS INITIAL    ).
      L_TYPE = '13'.
      PERFORM  P3000_FTX_MAKE     USING    'ACB'
                                           ZTTTHD-ZFETC1
                                           ZTTTHD-ZFETC2
                                           ZTTTHD-ZFETC3
                                           ZTTTHD-ZFETC4
                                           ZTTTHD-ZFETC5
                                  CHANGING L_TYPE
                                           W_EDI_RECORD.
   ENDIF.

*>> �Աݰ��� ���� ����.
   LOOP  AT  IT_ZSTTSG5.
*>> FLAT FILE MAKE( �Ա� ���� ���� )
      L_TYPE = '14'.
      PERFORM  P3000_DOC_MAKE_1   USING     IT_ZSTTSG5-ZFDOCCD
                                            IT_ZSTTSG5-ZFDOCNO
                                            SPACE
                                   CHANGING L_TYPE
                                            W_EDI_RECORD.
*>> FLAT FILE MAKE( ���� ���� ���� )
      L_TYPE = '15'.
      PERFORM  P3000_DTM_MAKE      USING    '171'
                                            IT_ZSTTSG5-ZFISSDT
                                            '101'
                                   CHANGING L_TYPE
                                            W_EDI_RECORD.
   ENDLOOP.

*>> ������ New Line Char. Cut.
   PERFORM P3000_EDI_RECORD_ADJUST  CHANGING W_EDI_RECORD.

ENDFUNCTION.
