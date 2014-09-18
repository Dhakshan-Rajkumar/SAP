FUNCTION ZIM_LG_APP707_EDI_DOC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFREQNO) LIKE  ZTREQHD-ZFREQNO
*"     VALUE(W_ZFAMDNO) LIKE  ZTREQST-ZFAMDNO
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
       L_ZFDSOG5      LIKE     IT_ZSMLCSG7G-ZFDSOG1,
       L_ZFAMDNO      LIKE     ZTREQST-ZFAMDNO,
       L_ZFOPNDT      LIKE     ZTREQST-ZFOPNDT.

*> MASTER L/C AMEND READ.
   CALL FUNCTION 'ZIM_GET_MASTER_LC_AMEND_DATA'
        EXPORTING
              ZFREQNO            =       W_ZFREQNO
              ZFAMDNO            =       W_ZFAMDNO
        IMPORTING
              W_ZTMLCAMHD        =       ZTMLCAMHD
        TABLES
              IT_ZSMLCAMNARR     =       IT_ZSMLCAMNARR
              IT_ZSMLCAMNARR_ORG =       IT_ZSMLCAMNARR_ORG
        EXCEPTIONS
              NOT_FOUND     =       4
              NOT_INPUT     =       8.

   CASE SY-SUBRC.
      WHEN 4.
         MESSAGE E018 WITH W_ZFREQNO RAISING  CREATE_ERROR.
      WHEN 8.
         MESSAGE E019 RAISING  CREATE_ERROR.
   ENDCASE.

*>> �����Ƿ� HEADER TABLE.
   SELECT SINGLE * FROM ZTREQHD
          WHERE    ZFREQNO  EQ   W_ZFREQNO.

*>> �����Ƿ� ���� TABLE
   SELECT SINGLE * FROM ZTREQST
          WHERE    ZFREQNO  EQ   W_ZFREQNO
          AND      ZFAMDNO  EQ   W_ZFAMDNO.

*>> LC HEADER TABLE
   SELECT SINGLE * FROM ZTMLCHD
          WHERE    ZFREQNO   EQ   W_ZFREQNO.

*>> [����] Master L/C Seg 2.
   SELECT SINGLE * FROM ZTMLCSG2
          WHERE    ZFREQNO   EQ   W_ZFREQNO.

*   L_ZFAMDNO = W_ZFAMDNO - 1.
   L_ZFAMDNO = '00000'.   ">��������...

*-----------------------------------------------------------------------
* FLAT-FILE RECORD CREATE
*-----------------------------------------------------------------------
   L_TYPE  =  '00'.

*>> FLAT FILE HEADER MAKE.
   PERFORM  P3000_HEADER_MAKE    USING    'APP707'
                                          ZTREQHD-BUKRS
                                          ZTREQHD-ZFOPBN
                                          W_ZFDHENO
                                 CHANGING W_EDI_RECORD.

*>> FLAT FILE BEG MAKE.(���ڹ��� ����)
   L_TYPE = '01'.
   PERFORM  P3000_BGM_MAKE       USING    '469'
                                          W_ZFDHENO
                                          ZTMLCAMHD-ZFEDFN
                                          'AB'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE INP MAKE(�������)
   L_TYPE = '02'.
   PERFORM  P3000_INP_MAKE       USING    '1'
                                          '5'
                                          ZTMLCAMHD-ZFOPME
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE RFF MAKE(�ſ����ȣ).
   L_TYPE = '03'.
   PERFORM  P3000_RFF_MAKE       USING    '2AD'
                                          ZTREQST-ZFOPNNO
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE RFF MAKE(���Ǻ���Ƚ��).
   L_TYPE = '03'.
   PERFORM  P3000_RFF_MAKE       USING    '2AB'
                                          W_ZFAMDNO
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE DTM MAKE(���Ǻ����û����).
   L_TYPE = '04'.
   PERFORM  P3000_DTM_MAKE       USING    '2AA'
                                          ZTREQST-ZFAPPDT
                                          '101'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE DTM MAKE(��������).
   SELECT SINGLE ZFOPNDT INTO  L_ZFOPNDT
   FROM   ZTREQST
   WHERE  ZFREQNO        EQ    W_ZFREQNO
   AND    ZFAMDNO        EQ    L_ZFAMDNO.

   L_TYPE = '04'.
   PERFORM  P3000_DTM_MAKE       USING    '182'
                                          L_ZFOPNDT
                                          '101'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE DTM MAKE(��ȿ���� ����).
   IF NOT ZTMLCAMHD-ZFNEXDT IS INITIAL.
      L_TYPE = '04'.
      PERFORM  P3000_DTM_MAKE    USING    '123'
                                          ZTMLCAMHD-ZFNEXDT
                                          '101'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE BUS MAKE.(���� ������ ����).
   IF NOT ZTMLCAMHD-ZFNLTSD IS INITIAL.
      L_TYPE = '04'.
      PERFORM  P3000_DTM_MAKE    USING    '38'
                                          ZTMLCAMHD-ZFNLTSD
                                          '101'
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE LOC MAKE( ������ ����).
   IF NOT ZTMLCAMHD-ZFNSPRT IS INITIAL.
      L_TYPE = '05'.
      PERFORM  P3000_LOC_MAKE    USING    '149'
                                          ZTMLCAMHD-ZFNSPRT
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE LOC MAKE( ������ ����).
   IF NOT ZTMLCAMHD-ZFNAPRT IS INITIAL.
      L_TYPE = '05'.
      PERFORM  P3000_LOC_MAKE    USING    '148'
                                          ZTMLCAMHD-ZFNAPRT
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE FTX MAKE(��Ÿ����).
   IF NOT ( ZTMLCAMHD-ZFETC1 IS INITIAL AND
            ZTMLCAMHD-ZFETC2 IS INITIAL AND
            ZTMLCAMHD-ZFETC3 IS INITIAL AND
            ZTMLCAMHD-ZFETC4 IS INITIAL AND
            ZTMLCAMHD-ZFETC5 IS INITIAL ).
      L_TYPE = '06'.
      PERFORM  P3000_FTX_MAKE    USING    'ACB'
                                          ZTMLCAMHD-ZFETC1
                                          ZTMLCAMHD-ZFETC2
                                          ZTMLCAMHD-ZFETC3
                                          ZTMLCAMHD-ZFETC4
                                          ZTMLCAMHD-ZFETC5
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE FTX MAKE( �ΰ��ݾ� ���� ).
   IF NOT ( ZTMLCAMHD-ZFNAMT1 IS INITIAL AND
            ZTMLCAMHD-ZFNAMT2 IS INITIAL AND
            ZTMLCAMHD-ZFNAMT3 IS INITIAL AND
            ZTMLCAMHD-ZFNAMT4 IS INITIAL ).
      L_TYPE = '06'.
      PERFORM  P3000_FTX_MAKE     USING    'ABT'
                                           ZTMLCAMHD-ZFNAMT1
                                           ZTMLCAMHD-ZFNAMT2
                                           ZTMLCAMHD-ZFNAMT3
                                           ZTMLCAMHD-ZFNAMT4
                                           SPACE
                                  CHANGING L_TYPE
                                           W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE FTX MAKE( �����Ⱓ ���� ).
   IF NOT ( ZTMLCAMHD-ZFNSHPR1 IS INITIAL AND
            ZTMLCAMHD-ZFNSHPR2 IS INITIAL AND
            ZTMLCAMHD-ZFNSHPR3 IS INITIAL ).
      L_TYPE = '06'.
      PERFORM  P3000_FTX_MAKE     USING    '2AF'
                                           ZTMLCAMHD-ZFNSHPR1
                                           ZTMLCAMHD-ZFNSHPR2
                                           ZTMLCAMHD-ZFNSHPR3
                                           SPACE
                                           SPACE
                                  CHANGING L_TYPE
                                           W_EDI_RECORD.
   ENDIF.

*>> ��Ÿ ���Ǻ������.
   CLEAR : W_MOD.
   L_TYPE = '06'.
   LOOP AT IT_ZSMLCAMNARR.
      PERFORM  P2000_SPACE_AND_CHANGE_SYMBOL
               CHANGING IT_ZSMLCAMNARR-ZFNARR.

      W_MOD = SY-TABIX MOD 5.
      CASE W_MOD.
         WHEN 1.
            CLEAR:L_ZFDSOG1, L_ZFDSOG2, L_ZFDSOG3,
                  L_ZFDSOG4, L_ZFDSOG5.

            MOVE  IT_ZSMLCAMNARR-ZFNARR(50) TO L_ZFDSOG1.
         WHEN 2.
            MOVE  IT_ZSMLCAMNARR-ZFNARR(50) TO L_ZFDSOG2.
         WHEN 3.
            MOVE  IT_ZSMLCAMNARR-ZFNARR(50) TO L_ZFDSOG3.
         WHEN 4.
            MOVE  IT_ZSMLCAMNARR-ZFNARR(50) TO L_ZFDSOG4.
         WHEN 0.
            MOVE  IT_ZSMLCAMNARR-ZFNARR(50) TO L_ZFDSOG5.
            PERFORM  P3000_FTX_MAKE       USING    '2AD'
                                                   L_ZFDSOG1
                                                   L_ZFDSOG2
                                                   L_ZFDSOG3
                                                   L_ZFDSOG4
                                                   L_ZFDSOG5
                                          CHANGING L_TYPE
                                                   W_EDI_RECORD.
      ENDCASE.
      IF W_MOD NE 0.
         PERFORM  P3000_FTX_MAKE       USING    '2AD'
                                                L_ZFDSOG1
                                                L_ZFDSOG2
                                                L_ZFDSOG3
                                                L_ZFDSOG4
                                                L_ZFDSOG5
                                       CHANGING L_TYPE
                                                W_EDI_RECORD.
      ENDIF.
   ENDLOOP.

*>> FLAT FILE FTX MAKE( ������ ��ȣ/�ּ� ���� ).
*   IF NOT ( ZTMLCAMHD-ZFBENI   IS INITIAL AND
*            ZTMLCAMHD-ZFBENI2  IS INITIAL AND
*            ZTMLCAMHD-ZFBENI3  IS INITIAL AND
*            ZTMLCAMHD-ZFBENI4  IS INITIAL AND
*            ZTMLCAMHD-ZFBENIA  IS INITIAL ).
*      L_TYPE = '06'.
*      PERFORM  P3000_FTX_MAKE     USING    '2AF'
*                                           ZTMLCAMHD-ZFBENI
*                                           ZTMLCAMHD-ZFBENI2
*                                           ZTMLCAMHD-ZFBENI3
*                                           ZTMLCAMHD-ZFBENI4
*                                           ZTMLCAMHD-ZFBENIA
*                                  CHANGING L_TYPE
*                                           W_EDI_RECORD.
*   ENDIF.
*
*   LOOP AT IT_ZSMLCSG7G.
*   ENDLOOP.

*>> FLAT FILE FII MAKE.(����(�Ƿ�)����).
   L_TYPE = '07'.
   PERFORM  P3000_FII_MAKE       USING    'AW'
                                          ZTMLCHD-ZFOPBNCD
                                          ZTMLCHD-ZFOBNM
                                          ZTMLCHD-ZFOBBR
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE FII MAKE.(����(�Ƿ�)���� ��ȭ��ȣ).
   IF NOT ZTMLCHD-ZFOBPH IS INITIAL.
      L_TYPE = '08'.
      PERFORM  P3000_COM_MAKE       USING    ZTMLCHD-ZFOBPH(14)
                                             'TE'
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE FII MAKE.(��������).
   IF NOT ZTMLCHD-ZFABNM IS INITIAL.
      L_TYPE = '07'.
      PERFORM  P3000_FII_MAKE       USING    '2AA'
                                             SPACE
                                             ZTMLCHD-ZFABNM
                                             ZTMLCHD-ZFABBR
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE NAD MAKE.(�����Ƿ���).
   L_TYPE = '09'.
   PERFORM  P3000_NAD_MAKE       USING    'DF'
                                          ZTMLCSG2-ZFAPPNM
                                          ZTMLCSG2-ZFAPPAD1
                                          ZTMLCSG2-ZFAPPAD2
                                          ZTMLCSG2-ZFAPPAD3
                                          SPACE
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE FII MAKE.(����(�Ƿ�) ��ȭ��ȣ).
   IF NOT ZTMLCSG2-ZFTELNO IS INITIAL.
      L_TYPE = '10'.
      PERFORM  P3000_COM_MAKE        USING     ZTMLCSG2-ZFTELNO(14)
                                              'TE'
                                     CHANGING L_TYPE
                                              W_EDI_RECORD.
   ENDIF.

*>> FLAT FILE NAD MAKE.(������).
   L_TYPE = '09'.
   PERFORM  P3000_NAD_MAKE       USING    'DG'
                                          ZTMLCSG2-ZFBENI1
                                          ZTMLCSG2-ZFBENI2
                                          ZTMLCSG2-ZFBENI3
                                          ZTMLCSG2-ZFBENI4
                                          ZTMLCSG2-ZFBENIA
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> FLAT FILE NAD MAKE.(�����Ƿ��� ���ڼ���).
   L_TYPE = '09'.
   PERFORM  P3000_NAD_MAKE       USING    '2AE'
                                          ZTMLCSG2-ZFELENM
                                          ZTMLCSG2-ZFREPRE
                                          ZTMLCSG2-ZFELEID
                                          ZTMLCSG2-ZFELEAD1
                                          ZTMLCSG2-ZFELEAD2
                                 CHANGING L_TYPE
                                          W_EDI_RECORD.

*>> �ſ��� �ݾ� �����.
   IF NOT ZTMLCAMHD-ZFIDCD IS INITIAL.
*>> FLAT FILE MOA MAKE( ���׺� ).
      IF ZTMLCAMHD-ZFIDCD EQ '+'.
         L_TYPE = '11'.
         PERFORM  P3000_MOA_MAKE    USING    '2AA'
                                             ZTMLCAMHD-ZFIDAM
                                             ZTMLCAMHD-WAERS
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
*>> FLAT FILE MOA MAKE( ���׺� ).
      ELSE.
         L_TYPE = '11'.
         PERFORM  P3000_MOA_MAKE    USING    '2AB'
                                             ZTMLCAMHD-ZFIDAM
                                             ZTMLCAMHD-WAERS
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
      ENDIF.
*>> FLAT FILE MOA MAKE( ��������ݾ�).
      L_TYPE = '11'.
      PERFORM  P3000_MOA_MAKE        USING    '212'
                                              ZTMLCAMHD-ZFNDAMT
                                              ZTMLCAMHD-WAERS
                                     CHANGING L_TYPE
                                              W_EDI_RECORD.
   ENDIF.

*>> ������ �����.
   IF NOT ZTMLCAMHD-ZFALCQ  IS  INITIAL.
*>>  FLAT FILE ALC MAKE( ������ ���).
      L_TYPE = '12'.
      PERFORM  P3000_ALC_MAKE        USING    ZTMLCAMHD-ZFALCQ
                                     CHANGING L_TYPE
                                              W_EDI_RECORD.
*>> FLAT FILE PCD MAKE( ��������)
      L_TYPE = '13'.
      PERFORM  P3000_PCD_MAKE        USING    '13'
                                              ZTMLCAMHD-ZFALCP
                                              ZTMLCAMHD-ZFALCM
                                     CHANGING L_TYPE
                                              W_EDI_RECORD.
   ENDIF.

*>> ���Խ��ι�ȣ.
   IF NOT ZTMLCAMHD-ZFILNO IS INITIAL.
      L_TYPE = '14'.
      PERFORM  P3000_RFF_MAKE       USING    'IP'
                                             ZTMLCAMHD-ZFILNO
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.
      L_TYPE = '15'.
      PERFORM  P3000_MOA_MAKE       USING    '2AC'
                                             ZTMLCAMHD-ZFILAMT
                                             ZTMLCAMHD-ZFILCUR
                                    CHANGING L_TYPE
                                             W_EDI_RECORD.

   ENDIF.

*>> ������ New Line Char. Cut.
   PERFORM P3000_EDI_RECORD_ADJUST  CHANGING W_EDI_RECORD.

ENDFUNCTION.
