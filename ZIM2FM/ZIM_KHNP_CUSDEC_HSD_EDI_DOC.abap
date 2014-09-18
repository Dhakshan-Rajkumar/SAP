FUNCTION ZIM_KHNP_CUSDEC_HSD_EDI_DOC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFBLNO) LIKE  ZTIDS-ZFBLNO
*"     VALUE(W_ZFCLSEQ) LIKE  ZTIDS-ZFCLSEQ
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXPORTING
*"     REFERENCE(W_EDI_RECORD)
*"  TABLES
*"      REC_HSD STRUCTURE  ZSRECHSD
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
       W_LIN_CNT      TYPE     I,
       W_DET_CNT      TYPE     I,
       W_HS_CNT       TYPE     I,
       W_RONO(2)      TYPE     C.

DATA : W_TEXT_AMT06(06) TYPE     C,
       W_TEXT_AMT11(11) TYPE     C,
       W_TEXT_AMT15(15) TYPE     C,
       W_ZERO3(03)      TYPE     C  VALUE '000',
       W_ZERO6(06)      TYPE     C  VALUE '000000',
       W_ZERO8(08)      TYPE     C  VALUE '00000000',
       W_ZERO9(09)      TYPE     C  VALUE '000000000',
       W_ZERO10(10)     TYPE     C  VALUE '0000000000',
       W_ZERO11(11)     TYPE     C  VALUE '00000000000',
       W_ZERO12(12)     TYPE     C  VALUE '000000000000',
       W_ZERO13(13)     TYPE     C  VALUE '0000000000000',
       W_ZERO14(14)     TYPE     C  VALUE '00000000000000',
       W_ZERO15(15)     TYPE     C  VALUE '000000000000000'.

*DATA : BEGIN OF REC_HSD,
*       REC_001(015)   TYPE     C,          " �Ű��ȣ.
*       REC_002(003)   TYPE     C,          " ����ȣ.
*       REC_003(003)   TYPE     C,          " �׹�ȣ.
*       REC_004(012)   TYPE     C,          " PART NO.
*       REC_005(050)   TYPE     C,          " ǰ��.
*       REC_006(011)   TYPE     C,          " ����.
*       REC_007(002)   TYPE     C,          " ��������.
*       REC_008(011)   TYPE     C,          " �ܰ�.
*       REC_009(020)   TYPE     C,          " KEY FIELD.
*       REC_010(011)   TYPE     C,          " ����.
*       REC_011(011)   TYPE     C,          " Ư�Ҽ�.
*       REC_012(011)   TYPE     C,          " ������.
*       REC_013(011)   TYPE     C,          " ��Ư��.
*       REC_014(011)   TYPE     C,          " �ּ�.
*       REC_015(011)   TYPE     C,          " �ΰ���.
*       REC_016(011)   TYPE     C,          " �������.
*       REC_017(011)   TYPE     C,          " ��������.
*       REC_018(015)   TYPE     C,          " �ݾ�.
*       REC_019(011)   TYPE     C,          " ����.
*       REC_020(011)   TYPE     C,          " �����.
*       REC_021(013)   TYPE     C,          " ������ȭ.
*       REC_022(013)   TYPE     C,          " �����޷�.
*       REC_023(010)   TYPE     C,          " ������ȣ.
*       REC_024(100)   TYPE     C,          " SPEC.
*       REC_025(030)   TYPE     C,          " �԰�1.
*       REC_026(030)   TYPE     C,          " �԰�2.
*       REC_027(030)   TYPE     C,          " �԰�3.
*       REC_028(025)   TYPE     C,          " ����1.
*       REC_029(025)   TYPE     C.          " ����2.
**       CR_LF          TYPE     X        VALUE '0A'.
*DATA : END   OF REC_HSD.

*> CUSTOM CLEARANCE DATA GET
   CALL FUNCTION 'ZIM_GET_IDR_DOCUMENT'
        EXPORTING
              ZFBLNO             =       W_ZFBLNO
              ZFCLSEQ            =       W_ZFCLSEQ
        IMPORTING
              W_ZTIDR            =       ZTIDR
        TABLES
              IT_ZSIDRHS         =       IT_ZSIDRHS
              IT_ZSIDRHS_ORG     =       IT_ZSIDRHS_ORG
              IT_ZSIDRHSD        =       IT_ZSIDRHSD
              IT_ZSIDRHSD_ORG    =       IT_ZSIDRHSD_ORG
              IT_ZSIDRHSL        =       IT_ZSIDRHSL
              IT_ZSIDRHSL_ORG    =       IT_ZSIDRHSL_ORG
        EXCEPTIONS
              NOT_FOUND     =       4
              NOT_INPUT     =       8.

   CASE SY-SUBRC.
      WHEN 4.
         MESSAGE E018 WITH W_ZFREQNO RAISING  CREATE_ERROR.
      WHEN 8.
         MESSAGE E019 RAISING  CREATE_ERROR.
   ENDCASE.

*>> BL �ڷ� GET!
   CLEAR ZTBL.
   SELECT SINGLE * FROM ZTBL      WHERE ZFBLNO EQ W_ZFBLNO.

*-----------------------------------------------------------------------
* FLAT-FILE RECORD CREATE
*-----------------------------------------------------------------------
   LOOP  AT  IT_ZSIDRHSD.
      CLEAR : REC_HSD, W_EDI_RECORD.

      CONCATENATE  ZTIDR-ZFBLNO  ZTIDR-ZFCLSEQ INTO  REC_HSD-REC_009.

      WRITE : IT_ZSIDRHSD-ZFCONO  TO REC_HSD-REC_002
                                     NO-ZERO RIGHT-JUSTIFIED,
              IT_ZSIDRHSD-ZFRONO  TO W_RONO NO-ZERO RIGHT-JUSTIFIED.
      OVERLAY : REC_HSD-REC_002  WITH '00',
                W_RONO           WITH '00'.

      CONCATENATE :  W_RONO '0'          INTO REC_HSD-REC_003,
                     W_RONO '          ' INTO REC_HSD-REC_004.

      MOVE : SPACE                TO  REC_HSD-REC_005,   " ǰ��.
             'EA'                 TO  REC_HSD-REC_007,   " ��������.
             '00000000000'        TO  REC_HSD-REC_010,   " ����.
             '00000000000'        TO  REC_HSD-REC_011,   " Ư�Ҽ�.
             '00000000000'        TO  REC_HSD-REC_012,   " ������.
             '00000000000'        TO  REC_HSD-REC_013,   " ��Ư��.
             '00000000000'        TO  REC_HSD-REC_014,   " �ּ�.
             '00000000000'        TO  REC_HSD-REC_015,   " �ΰ���.
             '00000000000'        TO  REC_HSD-REC_016,   " �������.
             '00000000000'        TO  REC_HSD-REC_017,   " ��������.
             '00000000000'        TO  REC_HSD-REC_019,   " ����.
             '00000000000'        TO  REC_HSD-REC_020,   " �����.
             '0000000000000'      TO  REC_HSD-REC_021,   " ������ȭ.
             '0000000000000'      TO  REC_HSD-REC_022,   " �����޷�.
             IT_ZSIDRHSD-STAWN    TO  REC_HSD-REC_023,   " ������ȣ.
             SPACE                TO  REC_HSD-REC_024,   " SPEC.
             IT_ZSIDRHSD-ZFGDDS1  TO  REC_HSD-REC_025,   " �԰�1.
             IT_ZSIDRHSD-ZFGDDS2  TO  REC_HSD-REC_026,   " �԰�2.
             IT_ZSIDRHSD-ZFGDDS3  TO  REC_HSD-REC_027,   " �԰�3.
             IT_ZSIDRHSD-ZFGDIN1  TO  REC_HSD-REC_028,   " ����1.
             IT_ZSIDRHSD-ZFGDIN2  TO  REC_HSD-REC_029.   " ����2.

      " ����.
      IF IT_ZSIDRHSD-ZFQNT IS INITIAL.
         MOVE  '00000000.00'  TO  REC_HSD-REC_006.
      ELSE.
         WRITE    IT_ZSIDRHSD-ZFQNT  TO  W_TEXT_AMT11 DECIMALS 2.
         PERFORM  P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
         WRITE    W_TEXT_AMT11  TO  REC_HSD-REC_006 RIGHT-JUSTIFIED.
         OVERLAY  REC_HSD-REC_006  WITH  W_ZERO11.
      ENDIF.

      " �ܰ�.
      IF IT_ZSIDRHSD-NETPR IS INITIAL.
         MOVE  '00000000.00'  TO  REC_HSD-REC_008.
      ELSE.
         WRITE    IT_ZSIDRHSD-NETPR  TO  W_TEXT_AMT11 DECIMALS 2.
         PERFORM  P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
         WRITE    W_TEXT_AMT11 TO REC_HSD-REC_008 RIGHT-JUSTIFIED.
         OVERLAY  REC_HSD-REC_008  WITH  W_ZERO11.
      ENDIF.

      " �ݾ�.
      IF IT_ZSIDRHSD-ZFAMT IS INITIAL.
         MOVE  '000000000000.00'  TO  REC_HSD-REC_018.
      ELSE.
         WRITE    IT_ZSIDRHSD-ZFAMT  TO  W_TEXT_AMT15 DECIMALS 2.
         PERFORM  P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT15.
         WRITE    W_TEXT_AMT15 TO REC_HSD-REC_018 RIGHT-JUSTIFIED.
         OVERLAY  REC_HSD-REC_018  WITH  W_ZERO15.
      ENDIF.
      APPEND  REC_HSD.
*      BUFFER_POINTER    =   STRLEN( W_EDI_RECORD ).
*      PARA_LENG         =   STRLEN( REC_HSD ).
*      MOVE  REC_HSD    TO   W_EDI_RECORD+BUFFER_POINTER(PARA_LENG).

   ENDLOOP.

ENDFUNCTION.
