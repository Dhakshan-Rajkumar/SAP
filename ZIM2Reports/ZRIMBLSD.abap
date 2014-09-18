*&--------------------------------------------------------------------*
*& Report  ZRIMBLSD                                                   *
*&--------------------------------------------------------------------*
*&  ���α׷��� : [Report] ���� ���� �ۺ� �뺸��.                      *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.                                 *
*&      �ۼ��� : 2001.07.24                                           *
*&--------------------------------------------------------------------*
*&   DESC.     :                                  .                   *
*&--------------------------------------------------------------------*
*& [���泻��]
*&
*&--------------------------------------------------------------------*

REPORT  ZRIMBLSD   MESSAGE-ID ZIM
                   LINE-SIZE 115
                   NO STANDARD PAGE HEADING.

*----------------------------------------------------------------------
* Tables �� ���� Define
*----------------------------------------------------------------------
TABLES : ZTBL, T024, LFA1, ZTIMIMG08, ZTBLIT, T001.

*----------------------------------------------------------------------
* ������û ���� TABLE
*----------------------------------------------------------------------
DATA : W_ERR_CHK(1),
       W_EKNAM     LIKE T024-EKNAM,               "���ű׷� ��.
       W_CDNM(55),                                "���������ۺ�ó.
       W_VENDOR(35),                              "���޾�ü.
       W_IMPORTER  LIKE T001-BUTXT,               "���Ծ�ü.
       W_IMPORT(60),                              "������.
       W_EXPORT(60),                              "������.
       W_TEM TYPE  I,
       W_TEM2(15).

DATA : IT_ZTBLIT LIKE ZTBLIT OCCURS 10 WITH HEADER LINE.
*---------------------------------------------------------------------
* SELECTION SCREEN ��.
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   PARAMETERS    : P_BLNO    LIKE ZTBL-ZFBLNO OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                                    " �ʱⰪ SETTING
    PERFORM   P2000_SET_PARAMETER.

*----------------------------------------------------------------------
* START OF SELECTION ��.
*----------------------------------------------------------------------
START-OF-SELECTION.
*  ���̺� SELECT
    PERFORM   P1000_GET_DATA           USING W_ERR_CHK.

    IF W_ERR_CHK EQ 'Y'.
        MESSAGE S966.
        EXIT.
    ENDIF.

* ����Ʈ Write
    PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

    IF W_ERR_CHK EQ 'Y'.
        EXIT.
    ENDIF.

*&--------------------------------------------------------------------*
*&      Form  P1000_GET_DATA
*&--------------------------------------------------------------------*
FORM P1000_GET_DATA USING    P_W_ERR_CHK.

*>>Bill of Lading Header
   CLEAR ZTBL.
   SELECT SINGLE * FROM ZTBL
          WHERE ZFBLNO = P_BLNO.

   IF SY-SUBRC NE 0.
       W_ERR_CHK = 'Y'. EXIT.
   ENDIF.

*--->������
   WRITE: ZTBL-ZFCARC TO W_EXPORT LEFT-JUSTIFIED.
   CONCATENATE W_EXPORT '-' INTO W_EXPORT.
   CONCATENATE W_EXPORT ZTBL-ZFSPRTC INTO W_EXPORT.
   CONCATENATE W_EXPORT '-' INTO W_EXPORT.
   CONCATENATE W_EXPORT ZTBL-ZFSPRT INTO W_EXPORT.
*   WRITE: W_EXPORT TO W_EXPORT LEFT-JUSTIFIED.
*--->������
   WRITE: ZTBL-ZFAPPC TO W_IMPORT LEFT-JUSTIFIED.
   CONCATENATE W_IMPORT '-' INTO W_IMPORT.
   CONCATENATE W_IMPORT ZTBL-ZFAPRTC INTO W_IMPORT.
   CONCATENATE W_IMPORT '-' INTO W_IMPORT.
   CONCATENATE W_IMPORT ZTBL-ZFAPRT INTO W_IMPORT.
*   WRITE: W_IMPORT TO W_IMPORT LEFT-JUSTIFIED.

*>>B/L ǰ��(Item)
   CLEAR ZTBLIT.
   SELECT * INTO TABLE IT_ZTBLIT FROM ZTBLIT
            WHERE ZFBLNO = P_BLNO.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'. EXIT.
   ENDIF.
*>> ����ó.
   CLEAR LFA1.
   SELECT SINGLE * FROM LFA1
          WHERE LIFNR = ZTBL-LIFNR.
   WRITE: LFA1-NAME1 TO W_VENDOR LEFT-JUSTIFIED.

**>> ������.
   CALL FUNCTION 'ZIM_GET_COMPANY_DATA'
        EXPORTING
           BUKRS    =   ZTBL-BUKRS
           IMTRD    =   ZTBL-IMTRD
        IMPORTING
           XT001    =   T001.

   W_IMPORTER = T001-BUTXT.

*   CLEAR LFA1.
*   SELECT SINGLE BUTXT INTO W_IMPORTER FROM T001
*          WHERE BUKRS = ZTBL-BUKRS.

*>>���ű׷� �б�.
   CLEAR T024.
   SELECT SINGLE EKNAM INTO (W_EKNAM) FROM T024
          WHERE EKGRP = ZTBL-EKGRP.

*>>�������� �ۺ�ó�б�.
   SELECT SINGLE ZFCDNM INTO (W_CDNM) FROM ZTIMIMG08
          WHERE ZFCD = ZTBL-ZFBLSDP
          AND   ZFCDTY = '012'.
ENDFORM.                    " P1000_GET_DATA

*&--------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&--------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
    SET  TITLEBAR 'BLSD'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER

*&--------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&--------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.
    SET PF-STATUS 'BLSD'.           " GUI STATUS SETTING
    SET  TITLEBAR 'BLSD'.           " GUI TITLE SETTING..
    PERFORM P3000_LINE_WRITE.
ENDFORM.                    " P3000_DATA_WRITE

*&--------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&--------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

    SKIP 2.
    WRITE:/45  '���� ���� �ۺ� �뺸��',
          /45 SY-ULINE(21).
    SKIP 1.
    WRITE:/42 '��ǥ P/O NO : ', ZTBL-ZFREBELN.
    IF NOT ZTBL-ZFSHNO IS INITIAL.
        WRITE: '-', ZTBL-ZFSHNO.
    ENDIF.

    WRITE:/4 '������ȣ', ZTBL-ZFBLNO, 100 SY-DATUM.

    WRITE:/ SY-ULINE.
    WRITE:/ SY-VLINE, '�� �� �� ��',  15 SY-VLINE, ZTBL-EKGRP,
            ' - ', W_EKNAM,
         45 SY-VLINE, '��������',  55 SY-VLINE, ZTBL-INCO1,
         80 SY-VLINE, '��   ȭ', 90 SY-VLINE, ZTBL-ZFBLAMC,
        115 SY-VLINE, SY-ULINE.

    WRITE:/ SY-VLINE, '�� �� �� ü',  15 SY-VLINE, W_VENDOR,
         45 SY-VLINE, 49 'ETD',  55 SY-VLINE, ZTBL-ZFETD,
         80 SY-VLINE, 84 'ETA', 90 SY-VLINE, ZTBL-ZFETA,
        115 SY-VLINE, SY-ULINE.

    WRITE:/ SY-VLINE, 'Vessel Name',  15 SY-VLINE, ZTBL-ZFCARNM,
         45 SY-VLINE, '�� �� ��', 55 SY-VLINE, 57 W_EXPORT,
         80 SY-VLINE, '�� �� ��', 90 SY-VLINE, 92 W_IMPORT,
        115 SY-VLINE, SY-ULINE.

    WRITE:/ SY-VLINE, 'B/L NO.',  20 SY-VLINE, ZTBL-ZFHBLNO,
         55 SY-VLINE, '������',   65 SY-VLINE, W_IMPORTER,
        115 SY-VLINE, SY-ULINE.

    WRITE:/ SY-VLINE, 'Package',  20 SY-VLINE.
    IF NOT ZTBL-ZFPKCN IS INITIAL.
       MOVE ZTBL-ZFPKCN TO W_TEM.
       WRITE: 22 ZTBL-ZFPKCNM,W_TEM.
    ENDIF.

    WRITE: 37 SY-VLINE, 'Measurement',  55 SY-VLINE.
    IF NOT ZTBL-ZFTOVL IS INITIAL.
         WRITE:  56 ZTBL-ZFTOVL UNIT ZTBL-ZFTOVLM,ZTBL-ZFTOVLM.
    ENDIF.

    WRITE: 77 SY-VLINE NO-GAP,'Chageable Weight' NO-GAP, 94 SY-VLINE.
    IF NOT ZTBL-ZFTOWT IS INITIAL.
       WRITE: 95 ZTBL-ZFTOWT UNIT ZTBL-ZFTOWTM, ZTBL-ZFTOWTM.
    ENDIF.

    WRITE: 115 SY-VLINE, SY-ULINE.

    WRITE:/ SY-VLINE, '���������ۺ���',  20 SY-VLINE, ZTBL-ZFBLSDT,
         37 SY-VLINE, '���������ۺ�ó',  55 SY-VLINE, W_CDNM,
        115 SY-VLINE, SY-ULINE.
    SKIP 1.
    WRITE:/ SY-ULINE.
    WRITE:/ SY-VLINE, 'P/O No.', 14 SY-VLINE, 'Item', 21 SY-VLINE,
            '����', 30 SY-VLINE,'��  ��  ��  ��', 55 SY-VLINE,
             '��          ��', 95 SY-VLINE,
              '��      ��', 115 SY-VLINE, SY-ULINE.

    LOOP AT IT_ZTBLIT.
         WRITE:/ SY-VLINE,
               IT_ZTBLIT-EBELN, 14 SY-VLINE,
               IT_ZTBLIT-EBELP, 21 SY-VLINE,
               IT_ZTBLIT-ZFSHNO,30 SY-VLINE,
               IT_ZTBLIT-MATNR, 55 SY-VLINE,
               (35)IT_ZTBLIT-TXZ01, 95 SY-VLINE,
               (14)IT_ZTBLIT-BLMENGE UNIT IT_ZTBLIT-MEINS,
               (03)IT_ZTBLIT-MEINS,
               115 SY-VLINE, SY-ULINE.
    ENDLOOP.

    WRITE:  / SY-VLINE,
           9 'ATTACHED :', 20 '1. INVOICE', 50 '4. CERTIFICATE',
           80 '7. ����������꼭', 115 SY-VLINE,
            / SY-VLINE, 20 '2. PACKING LIST', 50 '5. L/G',
           80 '8. �ŷ������ǽŰ�', 115 SY-VLINE,
            / SY-VLINE, 20 '3. B/L', 50 '6. INSURANCY POLICY',
           80 '9. OFFER', 115 SY-VLINE,
            / SY-VLINE, 79 '10. OTHERS', 115 SY-VLINE, SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE
