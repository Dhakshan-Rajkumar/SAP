FUNCTION ZIM_KHNP_CUSDEC_HS_EDI_DOC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFBLNO) LIKE  ZTIDS-ZFBLNO
*"     VALUE(W_ZFCLSEQ) LIKE  ZTIDS-ZFCLSEQ
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXPORTING
*"     REFERENCE(W_EDI_RECORD)
*"  TABLES
*"      REC_HS STRUCTURE  ZSRECHS
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
       W_HS_CNT       TYPE     I.

DATA : W_ZERO3(03)      TYPE     C  VALUE '000',
       W_ZERO6(06)      TYPE     C  VALUE '000000',
       W_ZERO8(08)      TYPE     C  VALUE '00000000',
       W_ZERO9(09)      TYPE     C  VALUE '000000000',
       W_ZERO10(10)     TYPE     C  VALUE '0000000000',
       W_ZERO11(11)     TYPE     C  VALUE '00000000000',
       W_ZERO12(12)     TYPE     C  VALUE '000000000000',
       W_ZERO13(13)     TYPE     C  VALUE '0000000000000',
       W_ZERO14(14)     TYPE     C  VALUE '00000000000000',
       W_ZERO15(15)     TYPE     C  VALUE '000000000000000'.
REFRESH : REC_HS.

*DATA : BEGIN OF REC_HS,
*       REC_001(015)   TYPE     C,          " �Ű��ȣ.
*       REC_002(003)   TYPE     C,          " ����ȣ.
*       REC_003(010)   TYPE     C,          " ������ȣ.
*       REC_004(002)   TYPE     C,          " �߷�����.
*       REC_005(014)   TYPE     C,          " ���߷�.
*       REC_006(002)   TYPE     C,          " ��������.
*       REC_007(010)   TYPE     C,          " ����.
*       REC_008(007)   TYPE     C,          " ��������.
*       REC_009(002)   TYPE     C,          " ������ CD.
*       REC_010(013)   TYPE     C,          " �Ű�� �޷�.
*       REC_011(013)   TYPE     C,          " �Ű�� ��ȭ.
*       REC_012(050)   TYPE     C,          " ǥ��ǰ��.
*       REC_013(011)   TYPE     C,          " ������.
*       REC_014(011)   TYPE     C,          " ������.
*       REC_015(011)   TYPE     C,          " ������.
*       REC_016(011)   TYPE     C,          " ���ް���.
*       REC_017(011)   TYPE     C,          " �ΰ���.
*       REC_018(011)   TYPE     C,          " �����.
*       REC_019(011)   TYPE     C,          " ����.
*       REC_020(002)   TYPE     C,          " ��������.
*       REC_021(006)   TYPE     C,          " ��������.
*       REC_022(015)   TYPE     C,          " �����ݾ�.
*       REC_023(006)   TYPE     C,          " ��������.
*       REC_024(020)   TYPE     C,          " KEY.
*       REC_025(011)   TYPE     C,          " ��Ư��.
*       REC_026(011)   TYPE     C,          " �ּ�.
*       REC_027(050)   TYPE     C,          " �ŷ�ǰ��.
*       REC_028(004)   TYPE     C,          " ��ǰ�ڵ�.
*       REC_029(050)   TYPE     C,          " ��ǥ��.
*       REC_030(003)   TYPE     C,          " �԰ݼ�.
*       REC_031(001)   TYPE     C,          " ÷�ο���.
*       REC_032(002)   TYPE     C,          " ȯ�޴���.
*       REC_033(010)   TYPE     C,          " ȯ�޼���.
*       REC_034(001)   TYPE     C,          " ���������.
*       REC_035(001)   TYPE     C,          " �������鱸��.
*       REC_036(010)   TYPE     C,          " �����г�����.
*       REC_037(012)   TYPE     C,          " ���������.
*       REC_038(007)   TYPE     C,          " ����������.
*       REC_039(002)   TYPE     C,          " ��������.
*       REC_040(007)   TYPE     C,          " Ư�鼼��.
*       REC_041(006)   TYPE     C,          " ��������.
*       REC_042(001)   TYPE     C,          " �ΰ�����.
*       REC_043(007)   TYPE     C,          " �ΰ������.
*       REC_044(007)   TYPE     C,          " �ΰ�����.
*       REC_045(001)   TYPE     C,          " ��������.
*       REC_046(001)   TYPE     C,          " ��Ư����.
*       REC_047(001)   TYPE     C,          " ���걸��.
*       REC_048(006)   TYPE     C,          " ������.
*       REC_049(003)   TYPE     C,          " ������ȭ.
*       REC_050(009)   TYPE     C,          " ����ȯ��.
*       REC_051(015)   TYPE     C,          " ����ݾ�.
*       REC_052(015)   TYPE     C,          " �����(��).
*       REC_053(001)   TYPE     C,          " ��������.
*       REC_054(006)   TYPE     C,          " ������.
*       REC_055(003)   TYPE     C,          " ������ȭ.
*       REC_056(009)   TYPE     C,          " ����ȯ��.
*       REC_057(015)   TYPE     C,          " �����ݾ�.
*       REC_058(001)   TYPE     C,          " ��������.
*       REC_059(001)   TYPE     C,          " ������.
*       REC_060(001)   TYPE     C,          " ��������.
*       REC_061(001)   TYPE     C,          " �����ŷ�.
*       REC_062(001)   TYPE     C,          " ����ǰ��.
*       REC_063(001)   TYPE     C,          " �����˻�.
*       REC_064(050)   TYPE     C,          " ��������.
*       REC_065(050)   TYPE     C,          " ��������.
*       REC_066(050)   TYPE     C,          " ��������.
*       REC_067(050)   TYPE     C,          " ��������.
*       REC_068(031)   TYPE     C,          " ��������.
*       REC_069(031)   TYPE     C,          " ��������.
*       REC_070(031)   TYPE     C,          " ��������.
*       REC_071(031)   TYPE     C,          " ��������.
*       REC_072(031)   TYPE     C,          " ��������.
*       REC_073(031)   TYPE     C,          " ��������.
*       REC_074(031)   TYPE     C,          " ��������.
*       REC_075(031)   TYPE     C,          " ��������.
*       REC_076(031)   TYPE     C,          " ��������.
*       REC_077(031)   TYPE     C,          " ��������.
*       REC_078(010)   TYPE     C,          " ���г�ȸ.
*       REC_079(011)   TYPE     C,          " ���д��.
*       REC_080(010)   TYPE     C,          " ���Ѻм�.
*       REC_081(001)   TYPE     C,          " Ư�� C/S.
*       REC_082(001)   TYPE     C,          " C/S �˻�.
*       REC_083(001)   TYPE     C.          " �˻纯��.
**       CR_LF          TYPE     X        VALUE '0A'.
*DATA : END   OF REC_HS.

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
   LOOP  AT  IT_ZSIDRHS.
      CLEAR : REC_HS, W_EDI_RECORD.

      CONCATENATE  ZTIDR-ZFBLNO  ZTIDR-ZFCLSEQ INTO  REC_HS-REC_024.
      WRITE  IT_ZSIDRHS-ZFCONO  TO REC_HS-REC_002.

      MOVE : IT_ZSIDRHS-STAWN    TO  REC_HS-REC_003,   " ������ȣ.
             SPACE               TO  REC_HS-REC_004,   " �߷�����.
             '000000000000.0'    TO  REC_HS-REC_005,   " �߷�.
             SPACE               TO  REC_HS-REC_006,   " ��������.
             '0000000000'        TO  REC_HS-REC_007,   " ����.
             SPACE               TO  REC_HS-REC_008,   " ������ ���.
             IT_ZSIDRHS-ZFORIG   TO  REC_HS-REC_009,   " ������ CD.
             '0000000000000'     TO  REC_HS-REC_010,   " �Ű�� $
             '0000000000000'     TO  REC_HS-REC_011,   " �Ű�� \
             IT_ZSIDRHS-ZFGDNM   TO  REC_HS-REC_012,   " ǰ��.
             '00000000000'       TO  REC_HS-REC_013,   " ������.
             '00000000000'       TO  REC_HS-REC_014,   " ������.
             '00000000000'       TO  REC_HS-REC_015,   " ������.
             '00000000000'       TO  REC_HS-REC_016,   " ���ް���.
             '00000000000'       TO  REC_HS-REC_017,   " �ΰ���.
             '00000000000'       TO  REC_HS-REC_018,   " �����.
             '00000000000'       TO  REC_HS-REC_019,   " ����.
             IT_ZSIDRHS-ZFTXGB   TO  REC_HS-REC_020,   " ��������.
             '000.00'            TO  REC_HS-REC_021,   " ��������.
             '000000000000.00'   TO  REC_HS-REC_022,   " �����ݾ�.
             '000.00'            TO  REC_HS-REC_023,   " ��������.
             '00000000000'       TO  REC_HS-REC_025,   " ��Ư��.
             '00000000000'       TO  REC_HS-REC_026,   " �ּ�.
             IT_ZSIDRHS-ZFTGDNM  TO  REC_HS-REC_027,   " �ŷ�ǰ��.
             IT_ZSIDRHS-ZFGCCD   TO  REC_HS-REC_028,   " ��ǥ�ڵ�.
             IT_ZSIDRHS-ZFGCNM   TO  REC_HS-REC_029,   " ��ǥ�ڵ��.
             '000'               TO  REC_HS-REC_030,   " �԰ݼ�.
             IT_ZSIDRHS-ZFATTYN  TO  REC_HS-REC_031,   " ÷�μ�������.
             SPACE               TO  REC_HS-REC_032,   " ȯ�޴���.
             '0000000000'        TO  REC_HS-REC_033,   " ȯ�޼���.
             IT_ZSIDRHS-ZFTXMT   TO  REC_HS-REC_034,   " ���������.
             IT_ZSIDRHS-ZFCDPCD  TO  REC_HS-REC_035,   " �������鱸��.
             IT_ZSIDRHS-ZFCUDIV  TO  REC_HS-REC_036,   " �����г���ȣ.
             IT_ZSIDRHS-ZFCDPNO  TO  REC_HS-REC_037,   " ���������ȣ.
             '000.000'           TO  REC_HS-REC_038,   " ����������.
             IT_ZSIDRHS-ZFHMTCD  TO  REC_HS-REC_039,   " ����������.
             SPACE               TO  REC_HS-REC_040,   " Ư�鼼��ȣ.
             SPACE               TO  REC_HS-REC_041,   " ����������.
             IT_ZSIDRHS-ZFVTXCD  TO  REC_HS-REC_042,   " �ΰ�������.
             SPACE               TO  REC_HS-REC_043,   " �ΰ��������ȣ.
             '000.000'           TO  REC_HS-REC_044,   " �ΰ���������.
             SPACE               TO  REC_HS-REC_045,   " ��������.
             SPACE               TO  REC_HS-REC_046,   " ��Ư����.
             SPACE               TO  REC_HS-REC_047,   " ���걸��.
             '000.00'            TO  REC_HS-REC_048,   " ������.
             SPACE               TO  REC_HS-REC_049,   " ������ȭ.
             '0000.0000'         TO  REC_HS-REC_050,   " ����ȯ��.
             '000000000000.00'   TO  REC_HS-REC_051,   " ����ݾ�.
             '000000000000000'   TO  REC_HS-REC_052,   " ����ݾ׿�ȭ.
             SPACE               TO  REC_HS-REC_053,   " ��������.
             '000.00'            TO  REC_HS-REC_054,   " ������.
             SPACE               TO  REC_HS-REC_055,   " ������ȭ.
             '0000.0000'         TO  REC_HS-REC_056,   " ����ȯ��.
             '000000000000.00'   TO  REC_HS-REC_057,   " �����ݾ�.
             IT_ZSIDRHS-ZFORYN   TO  REC_HS-REC_058,   " ��������.
             IT_ZSIDRHS-ZFORME   TO  REC_HS-REC_059,   " ������.
             IT_ZSIDRHS-ZFORTY   TO  REC_HS-REC_060,   " ��������.
             IT_ZSIDRHS-ZFTRRL   TO  REC_HS-REC_061,   " �����ŷ�.
             IT_ZSIDRHS-ZFGDAL   TO  REC_HS-REC_062,   " ����ǰ��.
             IT_ZSIDRHS-ZFEXOP   TO  REC_HS-REC_063,   " �����˻�.
             IT_ZSIDRHS-ZFCTW1   TO  REC_HS-REC_064,   " ���������1.
             IT_ZSIDRHS-ZFCTW2   TO  REC_HS-REC_065,   " ���������2.
             IT_ZSIDRHS-ZFCTW3   TO  REC_HS-REC_066,   " ���������3.
             IT_ZSIDRHS-ZFCTW4   TO  REC_HS-REC_067,   " ���������4.
             SPACE               TO  REC_HS-REC_068,   " ��������1.
             SPACE               TO  REC_HS-REC_069,   " ��������2.
             SPACE               TO  REC_HS-REC_070,   " ��������3.
             SPACE               TO  REC_HS-REC_071,   " ��������4.
             SPACE               TO  REC_HS-REC_072,   " ��������5.
             SPACE               TO  REC_HS-REC_073,   " ��������6.
             SPACE               TO  REC_HS-REC_074,   " ��������7.
             SPACE               TO  REC_HS-REC_075,   " ��������8.
             SPACE               TO  REC_HS-REC_076,   " ��������9.
             SPACE               TO  REC_HS-REC_077,   " ��������10.
             '0000000000'        TO  REC_HS-REC_078,   " ���г�ȸ.
             '00000000000'       TO  REC_HS-REC_079,   " �����д��.
             '0000000000'        TO  REC_HS-REC_080,   " �����Ѻг���.
             IT_ZSIDRHS-ZFSTCS   TO  REC_HS-REC_081,   " Ư�� C/S.
             IT_ZSIDRHS-ZFCSGB   TO  REC_HS-REC_082,   " C/S ����.
             IT_ZSIDRHS-ZFCSCH   TO  REC_HS-REC_083.   " ���汸��.

      APPEND  REC_HS.
   ENDLOOP.

ENDFUNCTION.
