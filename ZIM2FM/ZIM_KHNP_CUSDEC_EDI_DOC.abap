FUNCTION ZIM_KHNP_CUSDEC_EDI_DOC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFBLNO) LIKE  ZTIDS-ZFBLNO
*"     VALUE(W_ZFCLSEQ) LIKE  ZTIDS-ZFCLSEQ
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXPORTING
*"     REFERENCE(W_EDI_RECORD)
*"  EXCEPTIONS
*"      CREATE_ERROR
*"----------------------------------------------------------------------
DATA : L_TEXT           LIKE     DD07T-DDTEXT,
       L_TEXT280(280)   TYPE     C,
       L_TEXT350(350)   TYPE     C,
       L_BOOLEAN        TYPE     C,
       L_TYPE(002)      TYPE     C,
       L_TYPE_TEMP      LIKE     L_TYPE,
       L_CODE(003)      TYPE     C,
       W_LIN_CNT        TYPE     I,
       W_DET_CNT        TYPE     I,
       W_HS_CNT         TYPE     I,
       W_TEXT_AMT14(14) TYPE     C,
       W_TEXT_AMT13(13) TYPE     C,
       W_TEXT_AMT15(15) TYPE     C,
       W_TEXT_AMT12(12) TYPE     C,
       W_TEXT_AMT11(11) TYPE     C,
       W_TEXT_AMT10(10) TYPE     C,
       W_TEXT_AMT09(09) TYPE     C,
       W_TEXT_AMT08(08) TYPE     C,
       W_TEXT_AMT06(06) TYPE     C,
       W_TEXT_AMT03(03) TYPE     C.

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

DATA : BEGIN OF REC_CUSDEC,
       REC_001(015)   TYPE     C,          " �Ű��ȣ.
       REC_002(001)   TYPE     C,          " �Ű���.
       REC_003(008)   TYPE     C,          " �Ű�����.
       REC_004(028)   TYPE     C,          " ���Ի�ȣ.
       REC_005(008)   TYPE     C,          " ���Ժ�ȣ.
       REC_006(028)   TYPE     C,          " ������ȣ.
       REC_007(012)   TYPE     C,          " ������ǥ.
       REC_008(015)   TYPE     C,          " �������.
       REC_009(040)   TYPE     C,          " �����ּ�.
       REC_010(010)   TYPE     C,          " ��������ڵ��.
       REC_011(026)   TYPE     C,          " �����ڻ�ȣ.
       REC_012(010)   TYPE     C,          " ������ CD.
       REC_013(003)   TYPE     C,          " ����.
       REC_014(002)   TYPE     C,          " ��.
       REC_015(002)   TYPE     C,          " �ŷ�����.
       REC_016(002)   TYPE     C,          " ��������.
       REC_017(008)   TYPE     C,          " ��������.
       REC_018(003)   TYPE     C,          " ������CD.
       REC_019(008)   TYPE     C,          " ������ CD.
       REC_020(006)   TYPE     C,          " ��ġ��ġ.
       REC_021(008)   TYPE     C,          " �԰�����.
       REC_022(002)   TYPE     C,          " ¡������.
       REC_023(020)   TYPE     C,          " �����.
       REC_024(002)   TYPE     C,          " �������.
       REC_025(003)   TYPE     C,          " ��ۿ��.
       REC_026(020)   TYPE     C,          " HOUSE B/L.
       REC_027(020)   TYPE     C,          " ȭ����ȣ.
       REC_028(020)   TYPE     C,          " KEY FIELD.
       REC_029(003)   TYPE     C,          " �ε�����.
       REC_030(003)   TYPE     C,          " ������ȭ.
       REC_031(014)   TYPE     C,          " �����ݾ�.
       REC_032(003)   TYPE     C,          " ������ȭ.
       REC_033(013)   TYPE     C,          " ���ӱݾ�.
       REC_034(003)   TYPE     C,          " ������ȭ.
       REC_035(013)   TYPE     C,          " ����ݾ�.
       REC_036(002)   TYPE     C,          " �������.
       REC_037(008)   TYPE     C,          " ���尹��.
       REC_038(014)   TYPE     C,          " �߷�.
       REC_039(003)   TYPE     C,          " �Ѷ���.
       REC_040(012)   TYPE     C,          " ��������.
       REC_041(010)   TYPE     C,          " �Ű� $.
       REC_042(015)   TYPE     C,          " ���ι�ȣ.
       REC_043(008)   TYPE     C,          " ��������.
       REC_044(020)   TYPE     C,          " LC NO.
       REC_045(020)   TYPE     C,          " MASTER B/L.
       REC_046(028)   TYPE     C,          " ������ȣ.
       REC_047(007)   TYPE     C,          " ����CD.
       REC_048(004)   TYPE     C,          " ������ CD.
       REC_049(001)   TYPE     C,          " ������ KD.
       REC_050(004)   TYPE     C,          " ������ CD.
       REC_051(003)   TYPE     C,          " ������ ����.
       REC_052(001)   TYPE     C,          " �����ȹ.
       REC_053(030)   TYPE     C,          " ��ġ���.
       REC_054(002)   TYPE     C,          " ������.
       REC_055(002)   TYPE     C,          " �����ڱ�.
       REC_056(013)   TYPE     C,          " �����׸�.
       REC_057(002)   TYPE     C,          " ���ⱹ CD.
       REC_058(012)   TYPE     C,          " ���ⱹ��.
       REC_059(002)   TYPE     C,          " ���ⱹ CD.
       REC_060(010)   TYPE     C,          " ���ⱹ��.
       REC_061(001)   TYPE     C,          " ������ YN.
       REC_062(004)   TYPE     C,          " ��� CD.
       REC_063(020)   TYPE     C,          " �����.
       REC_064(002)   TYPE     C,          " Ư�� CD.
       REC_065(020)   TYPE     C,          " Ư�۸�.
       REC_066(009)   TYPE     C,          " �޷�ȯ��.
       REC_067(009)   TYPE     C,          " ����ȯ��.
       REC_068(001)   TYPE     C,          " ���걸��.
       REC_069(006)   TYPE     C,          " ������.
       REC_070(003)   TYPE     C,          " ������ȭ.
       REC_071(009)   TYPE     C,          " ����ȯ��.
       REC_072(015)   TYPE     C,          " ����ݾ�.
       REC_073(015)   TYPE     C,          " �����ȭ.
       REC_074(001)   TYPE     C,          " ��������.
       REC_075(006)   TYPE     C,          " ������.
       REC_076(003)   TYPE     C,          " ������ȭ.
       REC_077(009)   TYPE     C,          " ����ȯ��.
       REC_078(015)   TYPE     C,          " �����ݾ�.
       REC_079(015)   TYPE     C,          " ������ȭ.
       REC_080(012)   TYPE     C,          " �Ű�� ��ȭ.
       REC_081(011)   TYPE     C,          " ����.
       REC_082(011)   TYPE     C,          " Ư�Ҽ�.
       REC_083(011)   TYPE     C,          " ������.
       REC_084(011)   TYPE     C,          " �ΰ���.
       REC_085(011)   TYPE     C,          " ��Ư��.
       REC_086(011)   TYPE     C,          " �ּ�.
       REC_087(012)   TYPE     C,          " �����.
       REC_088(012)   TYPE     C,          " ��������.
       REC_089(008)   TYPE     C.          " ��������.
DATA : END   OF REC_CUSDEC.

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
   CLEAR : REC_CUSDEC, W_EDI_RECORD.

   CONCATENATE  ZTIDR-ZFTDAD1  ZTIDR-ZFTDAD2  INTO  REC_CUSDEC-REC_009.
   CONCATENATE  ZTIDR-ZFBLNO   ZTIDR-ZFCLSEQ  INTO  REC_CUSDEC-REC_028.

   MOVE : ZTIDR-ZFIDWDT   TO  REC_CUSDEC-REC_003,   " �Ű�����.
          ZTIDR-ZFIAPNM   TO  REC_CUSDEC-REC_004,   " ���Ի�ȣ.
          SPACE           TO  REC_CUSDEC-REC_005,   " ���Ժ�ȣ.
          ZTIDR-ZFTDNM1   TO  REC_CUSDEC-REC_006,   " ������ȣ.
          ZTIDR-ZFTDNM2   TO  REC_CUSDEC-REC_007,   " ������ǥ.
          ZTIDR-ZFTDNO    TO  REC_CUSDEC-REC_008,   " �������.
          ZTIDR-ZFTDTC    TO  REC_CUSDEC-REC_010,   " ����ڵ�Ϲ�ȣ.
          ZTIDR-ZFSUPNM   TO  REC_CUSDEC-REC_011,   " ������ ��ȣ.
          ZTIDR-ZFSUPNO   TO  REC_CUSDEC-REC_012,   " ������ ��ȣ.
          ZTIDR-ZFINRC    TO  REC_CUSDEC-REC_013,   " ����.
          ZTIDR-ZFINRCD   TO  REC_CUSDEC-REC_014,   " ��.
          ZTIDR-ZFPONC    TO  REC_CUSDEC-REC_015,   " �ŷ�����.
          ZTIDR-ZFITKD    TO  REC_CUSDEC-REC_016,   " ��������.
          ZTIDR-ZFENDT    TO  REC_CUSDEC-REC_017,   " ��������.
          ZTIDR-ZFAPRTC   TO  REC_CUSDEC-REC_018,   " ������ CD.
          ZTIDR-ZFISPL    TO  REC_CUSDEC-REC_019,   " ������ CD.
          ZTIDR-ZFLOCA    TO  REC_CUSDEC-REC_020,   " ��ġ��ġ.
          ZTIDR-ZFINDT    TO  REC_CUSDEC-REC_021,   " �԰�����.
          ZTIDR-ZFCOCD    TO  REC_CUSDEC-REC_022,   " ¡������.
          ZTIDR-ZFCARNM   TO  REC_CUSDEC-REC_023,   " �����.
          ZTIDR-ZFTRMET   TO  REC_CUSDEC-REC_024,   " �������.
          ZTIDR-ZFTRCN    TO  REC_CUSDEC-REC_025,   " ��ۿ��.
          ZTIDR-ZFHBLNO   TO  REC_CUSDEC-REC_026,   " HOUSE B/L.
          ZTIDR-ZFGOMNO   TO  REC_CUSDEC-REC_027,   " ȭ��������ȣ.
          ZTIDR-INCO1     TO  REC_CUSDEC-REC_029,   " �ε�����.
          ZTIDR-ZFSTAMC   TO  REC_CUSDEC-REC_030,   " ������ȭ.
          ZTIDR-ZFTFAC    TO  REC_CUSDEC-REC_032,   " ������ȭ.
          'KRW'           TO  REC_CUSDEC-REC_034,   " ������ȭ.
          ZTIDR-ZFPKNM    TO  REC_CUSDEC-REC_036,   " �������.
          '000000000000'  TO  REC_CUSDEC-REC_040,   " ��������.
          SPACE           TO  REC_CUSDEC-REC_042,   " ���ι�ȣ.
          SPACE           TO  REC_CUSDEC-REC_043,   " ��������.
          ZTIDR-ZFOPNNO   TO  REC_CUSDEC-REC_044,   " L/C NO.
          ZTIDR-ZFMBLNO   TO  REC_CUSDEC-REC_045,   " MASTER B/L.
          ZTIDR-ZFTRDNM   TO  REC_CUSDEC-REC_046,   " ������ȣ.
          ZTIDR-ZFTRDNO   TO  REC_CUSDEC-REC_047,   " �����ڵ�.
          ZTIDR-ZFIAPCD   TO  REC_CUSDEC-REC_048,   " ������ CD.
          ZTIDR-ZFIMCD    TO  REC_CUSDEC-REC_049,   " ������ ����.
          ZTIDR-ZFTDCD    TO  REC_CUSDEC-REC_050,   " ������ CD.
          SPACE           TO  REC_CUSDEC-REC_051,   " ��������.
          ZTIDR-ZFCUPR    TO  REC_CUSDEC-REC_052,   " �����ȹ.
          ZTIDR-ZFPLNM    TO  REC_CUSDEC-REC_053,   " ��ġ���.
          ZTIDR-ZFAMCD    TO  REC_CUSDEC-REC_054,   " �������.
          ZTIDR-ZFSUPC    TO  REC_CUSDEC-REC_055,   " �����ڱ�.
          ZTIDR-ZFCAC     TO  REC_CUSDEC-REC_057,   " ���ⱹCD.
          ZTIDR-ZFSCON    TO  REC_CUSDEC-REC_059,   " ���ⱹCD.
          ZTIDR-ZFORGYN   TO  REC_CUSDEC-REC_061,   " ������ ����.
          ZTIDR-ZFFWORG   TO  REC_CUSDEC-REC_062,   " ��� CODE.
          SPACE           TO  REC_CUSDEC-REC_063,   " �����.
          ZTIDR-ZFSTRCD   TO  REC_CUSDEC-REC_064,   " Ư�� CD.
          SPACE           TO  REC_CUSDEC-REC_065,   " Ư�۸�.
          ZTIDR-ZFADAMC   TO  REC_CUSDEC-REC_068,   " ���걸��.
          ZTIDR-ZFADAMCU  TO  REC_CUSDEC-REC_070,   " ������ȭ.
          ZTIDR-ZFDUAMC   TO  REC_CUSDEC-REC_074,   " ��������.
          ZTIDR-ZFDUAMCU  TO  REC_CUSDEC-REC_076.   " ������ȭ.

   " ���� GET!
   " ���ⱹ��.
   SELECT  SINGLE  LANDX  INTO  REC_CUSDEC-REC_058
   FROM    T005T
   WHERE   SPRAS   EQ   SY-LANGU
   AND     LAND1   EQ   ZTIDR-ZFCAC.

   " ���ⱹ��.
   SELECT  SINGLE  LANDX  INTO  REC_CUSDEC-REC_060
   FROM    T005T
   WHERE   SPRAS   EQ   SY-LANGU
   AND     LAND1   EQ   ZTIDR-ZFSCON.

   " �����׸�.
   SELECT  SINGLE  DDTEXT  INTO  REC_CUSDEC-REC_056
   FROM    DD07T
   WHERE   DOMNAME     EQ  'ZEAPRTC'
   AND     DDLANGUAGE  EQ  SY-LANGU
   AND     VALPOS      EQ  ZTIDR-ZFAPRTC.

   " �ݾ�, �� TEXT ȭ.
   " �����ݾ�.
   IF ZTIDR-ZFSTAMT IS INITIAL.
      MOVE   '00000000000.00'   TO  REC_CUSDEC-REC_031.
   ELSE.
      WRITE      ZTIDR-ZFSTAMT  TO  W_TEXT_AMT14  DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT14.
      WRITE      W_TEXT_AMT14   TO  REC_CUSDEC-REC_031 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_031  WITH  W_ZERO14.
   ENDIF.

   " ���ӱݾ�.
   IF ZTIDR-ZFTFA  IS INITIAL.
      MOVE   '0000000000.00'   TO  REC_CUSDEC-REC_033.
   ELSE.
      WRITE      ZTIDR-ZFTFA  TO  W_TEXT_AMT13 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT13.
      WRITE      W_TEXT_AMT13  TO  REC_CUSDEC-REC_033 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_033   WITH  W_ZERO13.
   ENDIF.

   " ����ݾ�.
   IF ZTIDR-ZFINAMT  IS  INITIAL.
      MOVE  '0000000000.00'   TO  REC_CUSDEC-REC_035.
   ELSE.
      WRITE      ZTIDR-ZFINAMT  TO  W_TEXT_AMT13 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT13.
      WRITE      W_TEXT_AMT13   TO  REC_CUSDEC-REC_035 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_035   WITH  W_ZERO13.
   ENDIF.

   " ���尹��.
   IF ZTIDR-ZFPKCNT  IS INITIAL.
      MOVE  '00000000'   TO  REC_CUSDEC-REC_037.
   ELSE.
      WRITE      ZTIDR-ZFPKCNT  TO  W_TEXT_AMT08 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT08.
      WRITE      W_TEXT_AMT08  TO  REC_CUSDEC-REC_037 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_037   WITH  W_ZERO8.
   ENDIF.

   " �߷�.
   IF ZTIDR-ZFTOWT  IS  INITIAL.
      MOVE  '000000000000.0'   TO  REC_CUSDEC-REC_038.
   ELSE.
      WRITE      ZTIDR-ZFTOWT  TO  W_TEXT_AMT14 DECIMALS 1.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT14.
      WRITE      W_TEXT_AMT14  TO  REC_CUSDEC-REC_038 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_038   WITH  W_ZERO14.
   ENDIF.

   " �Ѷ���.
   DESCRIBE TABLE  IT_ZSIDRHS  LINES  W_LINE.
   WRITE      W_LINE        TO  W_TEXT_AMT03  DECIMALS  0.
   PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT03.
   WRITE      W_TEXT_AMT03  TO  REC_CUSDEC-REC_039 RIGHT-JUSTIFIED.
   OVERLAY    REC_CUSDEC-REC_039   WITH  W_ZERO3.

   " �Ű�$.
   IF ZTIDR-ZFTBAU  IS  INITIAL.
      MOVE  '0000000000'   TO  REC_CUSDEC-REC_041.
   ELSE.
      WRITE      ZTIDR-ZFTBAU  TO  W_TEXT_AMT10 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT10.
      WRITE      W_TEXT_AMT10  TO  REC_CUSDEC-REC_041 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_041   WITH  W_ZERO10.
   ENDIF.

   " �޷�ȯ��.
   IF  ZTIDR-ZFEXUS  IS  INITIAL.
       MOVE  '0000.0000'    TO   REC_CUSDEC-REC_066.
   ELSE.
       WRITE      ZTIDR-ZFEXUS  TO  W_TEXT_AMT09 DECIMALS 4.
       PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT09.
       WRITE      W_TEXT_AMT09  TO  REC_CUSDEC-REC_066 RIGHT-JUSTIFIED.
       OVERLAY    REC_CUSDEC-REC_066   WITH  W_ZERO9.
   ENDIF.

   " ����ȯ��.
   IF ZTIDR-ZFEXRT  IS  INITIAL.
      MOVE  '0000.0000'   TO  REC_CUSDEC-REC_067.
   ELSE.
      WRITE      ZTIDR-ZFEXRT  TO  W_TEXT_AMT09 DECIMALS 4.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT09.
      WRITE      W_TEXT_AMT09  TO  REC_CUSDEC-REC_067 LEFT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_067   WITH  W_ZERO9.
   ENDIF.

   " ������.
   IF ZTIDR-ZFADRT  IS INITIAL.
      MOVE  '000.00'  TO  REC_CUSDEC-REC_069.
   ELSE.
      WRITE      ZTIDR-ZFADRT  TO  W_TEXT_AMT06 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT06.
      WRITE      W_TEXT_AMT06  TO  REC_CUSDEC-REC_069 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_069   WITH  W_ZERO6.
   ENDIF.

   " ����ȯ��.
   IF ZTIDR-ZFEXAD  IS  INITIAL.
      MOVE  '0000.0000'  TO  REC_CUSDEC-REC_071.
   ELSE.
      WRITE      ZTIDR-ZFEXAD  TO  W_TEXT_AMT09 DECIMALS 4.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT09.
      WRITE      W_TEXT_AMT09  TO  REC_CUSDEC-REC_071 LEFT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_071   WITH  W_ZERO9.
   ENDIF.

   " ����ݾ�.
   IF ZTIDR-ZFADAM  IS  INITIAL.
      MOVE  '000000000000.00'  TO  REC_CUSDEC-REC_072.
   ELSE.
      WRITE      ZTIDR-ZFADAM  TO  W_TEXT_AMT15 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT15.
      WRITE      W_TEXT_AMT15  TO  REC_CUSDEC-REC_072 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_072   WITH  W_ZERO15.
   ENDIF.

   " ����ݾ�(��).
   IF ZTIDR-ZFADAMK IS INITIAL.
      MOVE  '000000000000000'   TO  REC_CUSDEC-REC_073.
   ELSE.
      WRITE      ZTIDR-ZFADAMK  TO  W_TEXT_AMT15 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT15.
      WRITE      W_TEXT_AMT15  TO  REC_CUSDEC-REC_073 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_073   WITH  W_ZERO15.
   ENDIF.

   " ������.
   IF ZTIDR-ZFDURT IS INITIAL.
      MOVE  '000.00'  TO  REC_CUSDEC-REC_075.
   ELSE.
      WRITE      ZTIDR-ZFDURT  TO  W_TEXT_AMT06 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT06.
      WRITE      W_TEXT_AMT06  TO  REC_CUSDEC-REC_075 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_075   WITH  W_ZERO6.
   ENDIF.

   " ����ȯ��.
   IF ZTIDR-ZFEXDU IS INITIAL.
      MOVE  '0000.0000'  TO  REC_CUSDEC-REC_077.
   ELSE.
      WRITE      ZTIDR-ZFEXDU  TO  W_TEXT_AMT09 DECIMALS 4.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT09.
      WRITE      W_TEXT_AMT09  TO  REC_CUSDEC-REC_077 LEFT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_077   WITH  W_ZERO9.
   ENDIF.

   " �����ݾ�.
   IF ZTIDR-ZFDUAM IS INITIAL.
      MOVE  '000000000000.00'  TO  REC_CUSDEC-REC_078.
   ELSE.
      WRITE      ZTIDR-ZFDUAM  TO  W_TEXT_AMT15 DECIMALS 2.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT15.
      WRITE      W_TEXT_AMT15  TO  REC_CUSDEC-REC_078 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_078   WITH  W_ZERO15.
   ENDIF.

   " �����ݾ�(��).
   IF ZTIDR-ZFDUAMK IS INITIAL.
      MOVE  '000000000000000'  TO  REC_CUSDEC-REC_079.
   ELSE.
      WRITE      ZTIDR-ZFDUAMK  TO  W_TEXT_AMT15 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT15.
      WRITE      W_TEXT_AMT15  TO  REC_CUSDEC-REC_079 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_079   WITH  W_ZERO15.
   ENDIF.

   " �Ű��(��).
   IF ZTIDR-ZFTBAK IS INITIAL.
      MOVE  '000000000000'  TO  REC_CUSDEC-REC_080.
   ELSE.
      WRITE      ZTIDR-ZFTBAK  TO  W_TEXT_AMT12 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT12.
      WRITE      W_TEXT_AMT12  TO  REC_CUSDEC-REC_080 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_080   WITH  W_ZERO12.
   ENDIF.

   " ����.
   IF ZTIDR-ZFCUAMTS IS INITIAL.
      MOVE  '00000000000'  TO  REC_CUSDEC-REC_081.
   ELSE.
      WRITE      ZTIDR-ZFCUAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_081 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_081   WITH  W_ZERO11.
   ENDIF.

   " Ư�Ҽ�.
   IF ZTIDR-ZFSCAMTS IS INITIAL.
      MOVE  '00000000000'  TO  REC_CUSDEC-REC_082.
   ELSE.
      WRITE      ZTIDR-ZFSCAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_082 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_082   WITH  W_ZERO11.
   ENDIF.

   " ������.
   IF ZTIDR-ZFTRAMTS IS INITIAL.
      MOVE '00000000000'  TO  REC_CUSDEC-REC_083.
   ELSE.
      WRITE      ZTIDR-ZFTRAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_083 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_083   WITH  W_ZERO11.
   ENDIF.

   " �ΰ���.
   IF ZTIDR-ZFVAAMTS IS INITIAL.
      MOVE  '00000000000'  TO  REC_CUSDEC-REC_084.
   ELSE.
      WRITE      ZTIDR-ZFVAAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_084 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_084   WITH  W_ZERO11.
   ENDIF.

   " ��Ư��.
   IF ZTIDR-ZFAGAMTS IS INITIAL.
      MOVE  '00000000000'  TO  REC_CUSDEC-REC_085.
   ELSE.
      WRITE      ZTIDR-ZFAGAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_085 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_085   WITH  W_ZERO11.
   ENDIF.

   " �ּ�.
   IF ZTIDR-ZFDRAMTS IS INITIAL.
      MOVE  '00000000000'  TO  REC_CUSDEC-REC_086.
   ELSE.
      WRITE      ZTIDR-ZFDRAMTS  TO  W_TEXT_AMT11 DECIMALS 0.
      PERFORM    P2000_WRITE_NO_MASK  CHANGING  W_TEXT_AMT11.
      WRITE      W_TEXT_AMT11  TO  REC_CUSDEC-REC_086 RIGHT-JUSTIFIED.
      OVERLAY    REC_CUSDEC-REC_086   WITH  W_ZERO11.
   ENDIF.

   MOVE   REC_CUSDEC  TO  W_EDI_RECORD.

ENDFUNCTION.
