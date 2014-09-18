*& Report  ZRIMEDIR01                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : EDI RECEIPT(���Ը� ��)                                *
*&      �ۼ��� : ������                                                *
*&      �ۼ��� : 2003.01.16                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : 1. Local Directory �� FILE �� UPLOAD.
*&               2. FILE ���� DB ����.
*&---------------------------------------------------------------------*
*& [���泻��]
*&---------------------------------------------------------------------*
REPORT  ZRIMEDIR02  MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* REPORT ��ȸ �� DATA UPDATE �Ǳ� ���� TABLE ����.
*-----------------------------------------------------------------------
TABLES : ZTBL,
         ZTIDS,
        *ZTIDS,
         ZTIDSHS,
         ZTIDSHSD,
         ZTIDR,
         ZTIDRHS,
         ZTIDRHSD.

*-----------------------------------------------------------------------
* EDI �����ϱ� ���� ����ü ����.
*-----------------------------------------------------------------------
TABLES : ZSRECHS,
         ZSRECHSD,
         BAPICURR.

INCLUDE : <ICON>.

DATA : W_OK_CODE         LIKE   SY-UCOMM,
       W_READ_CNT        TYPE   I,
       W_ZFDHENO         LIKE   ZTDHF1-ZFDHENO,
       W_ZFCDDOC         LIKE   ZTCDF1-ZFCDDOC,
       W_ZFDHSRO         LIKE   ZTDHF1-ZFDHSRO,
       W_ZFDHREF         LIKE   ZTDHF1-ZFDHREF,
       W_FILENAME        LIKE   RLGRAP-FILENAME,
       W_SUBRC           LIKE   SY-SUBRC,
       W_ERR_CHK         TYPE   C,
       W_PAGE            TYPE   I,
       W_LINE            TYPE   I,
       W_COUNT           TYPE   I,
       DIGITS            TYPE   I,
       W_KRW             LIKE   ZTBL-ZFBLAMC  VALUE 'KRW',
       W_USD             LIKE   ZTBL-ZFBLAMC  VALUE 'USD'.

SELECT-OPTIONS : S_ZFBLNO FOR ZTBL-ZFBLNO NO INTERVALS NO-DISPLAY.

*-----------------------------------------------------------------------
* REPORT WRITE ���� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA:   BEGIN OF IT_TAB OCCURS 0,   ">> ����.
        ZFBLNO    LIKE ZTBL-ZFBLNO,
        ZFSHNO    LIKE ZTBL-ZFSHNO,
        W_EBELN(15),
        ZFHBLNO   LIKE ZTBL-ZFHBLNO,
        ZFRGDSR   LIKE ZTBL-ZFRGDSR,   " ��ǥǰ��.
        ZFIDRNO   LIKE ZTIDS-ZFIDRNO,  "
        ZFCLSEQ   LIKE ZTIDS-ZFCLSEQ,
        ZFOPNNO   LIKE ZTIDS-ZFOPNNO,  " L/C NO.
        ZFREBELN  LIKE ZTIDS-ZFREBELN, " FILE NO.
        ZFIDSDT   LIKE ZTIDS-ZFIDSDT,  " �����.
        ZFCHGDT   LIKE ZTIDS-ZFCHGDT,  " ������.
        ZFIDWDT   LIKE ZTIDS-ZFIDWDT,  " �Ű������.
        ZFINRC    LIKE ZTIDS-ZFINRC,   " ����
        DOMTEXT   LIKE DD07T-DDTEXT,   " ������.
        ZFCUT     LIKE ZTIDS-ZFCUT,    " ������,
        NAME1     LIKE LFA1-NAME1,     " �������.
        ZFSTAMT   LIKE ZTIDS-ZFSTAMT,  " �����ݾ�.
        ZFSTAMC   LIKE ZTIDS-ZFSTAMC,  " ��ȭ.
        ZFINAMT  LIKE ZTIDS-ZFINAMT,   " �����.
        ZFINAMTC  LIKE ZTIDS-ZFINAMTC, " ��ȭ.
        INCO1     LIKE ZTIDS-INCO1,    " INCO.
        ZFTFA     LIKE ZTIDS-ZFTFA,    " ����.
        ZFTFAC    LIKE ZTIDS-ZFTFAC,   " ��ȭ.
        ZFPRNAM   LIKE ZTIDS-ZFPRNAM.  " û����.
DATA:   END   OF IT_TAB.

*-----------------------------------------------------------------------
* EDI �����ϱ� ���� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA  W_EDI_RECORD(9000).

" ���ԽŰ� MAIN.
DATA: BEGIN OF IT_EDI OCCURS 0,
      W_RECORD   LIKE     W_EDI_RECORD,
END OF IT_EDI.

" ���ԽŰ� HS MAIN.
DATA: BEGIN OF IT_EDIHS OCCURS 0,
      W_RECORD   LIKE     W_EDI_RECORD,
END OF IT_EDIHS.

" ���ԽŰ� HS MAIN.
DATA: BEGIN OF IT_EDIHSD OCCURS 0,
      W_RECORD   LIKE     W_EDI_RECORD,
END OF IT_EDIHSD.

" ���Ը��� HEADER DATA.
DATA : BEGIN OF IT_HEADER  OCCURS  0,
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
DATA : END   OF IT_HEADER.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_HS OCCURS 0.
      INCLUDE STRUCTURE  ZSRECHS.
DATA : END OF IT_HS.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_HSD OCCURS 0.
      INCLUDE STRUCTURE  ZSRECHSD.
DATA : END OF IT_HSD.

*-----------------------------------------------------------------------
* DB UPDATE �ϱ� ���� INTERNAL TABLE
*-----------------------------------------------------------------------
" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZTIDSHS OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHS.
DATA : END OF IT_ZTIDSHS.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZTIDSHSD OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHSD.
DATA : END OF IT_ZTIDSHSD.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZSIDSHS OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHS.
DATA : END OF IT_ZSIDSHS.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZSIDSHSD OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHSD.
DATA : END OF IT_ZSIDSHSD.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZSIDSHS_ORG OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHS.
DATA : END OF IT_ZSIDSHS_ORG.

" ���ԽŰ� �� ����.
DATA: BEGIN OF IT_ZSIDSHSD_ORG OCCURS 0.
      INCLUDE STRUCTURE  ZSIDSHSD.
DATA : END OF IT_ZSIDSHSD_ORG.

*>>> ERROR ó����.
DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON         LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(266) TYPE C.
DATA : END OF IT_ERR_LIST.

DATA: MI_HANDLE       TYPE I,
      ANTWORT(1)      TYPE C,             " ���� popup Screen���� ��?
      L_LEN           TYPE I,
      L_STRLEN        TYPE I,
      L_SIZE          TYPE I,
      W_MOD           TYPE I,
      L_DATE          TYPE SY-DATUM,
      INCLUDE(8)      TYPE C,             "
      L_TIME          TYPE SY-UZEIT,
      W_BUKRS         LIKE ZTIMIMGTX-BUKRS.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*-----------------------------------------------------------------------
* Selection Screen ��.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    PARAMETERS: P_BUKRS LIKE ZTIMIMGTX-BUKRS OBLIGATORY
                        DEFAULT 'KHNP'.
SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
   PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ��.
*-----------------------------------------------------------------------
START-OF-SELECTION.

* Import System Config Check
   W_BUKRS = P_BUKRS.

* LOCAL FILE DATA UPLOAD.
   PERFORM   P1000_GET_UPLOAD_FILE  USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* DB Write
   PERFORM   P3000_DB_DATA_WRITE.

* REPORT WRITE.
   PERFORM   P3000_DATA_WRITE       USING    W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'. MESSAGE S738.   EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   W_OK_CODE = SY-UCOMM.
   CASE SY-UCOMM.
*------- Abbrechen (CNCL) ----------------------------------------------
      WHEN 'CNCL'.
         ANTWORT = 'C'.
         SET SCREEN 0.    LEAVE SCREEN.
      WHEN 'DISP'.
         PERFORM P2000_SHOW_IDS USING  IT_TAB-ZFBLNO
                                       IT_TAB-ZFCLSEQ.

      WHEN OTHERS.
   ENDCASE.
   CLEAR : IT_TAB.

*&---------------------------------------------------------------------*
*&   Event AT LINE-SELECTION
*&---------------------------------------------------------------------*
AT LINE-SELECTION.
  CASE INCLUDE.
    WHEN 'POPU'.
       IF NOT IT_ERR_LIST-MSGTYP IS INITIAL.
          MESSAGE ID IT_ERR_LIST-MSGID TYPE IT_ERR_LIST-MSGTYP
                  NUMBER IT_ERR_LIST-MSGNR
                  WITH   IT_ERR_LIST-MSGV1
                         IT_ERR_LIST-MSGV2
                         IT_ERR_LIST-MSGV3
                         IT_ERR_LIST-MSGV4.
       ENDIF.
       CLEAR : IT_ERR_LIST.
  ENDCASE.

  SET SCREEN 0.    LEAVE SCREEN.


*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIME10'.          " TITLE BAR

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50 '[ ���ԽŰ������� ��ȸ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /3 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,(15) '���Ź���' NO-GAP,  SY-VLINE,
            (21) 'House B/L No'      NO-GAP,  SY-VLINE,
            (20) '�����ݾ�'          NO-GAP,  SY-VLINE,
            (20) '�����'            NO-GAP , SY-VLINE,
            (20) '����'              NO-GAP,  SY-VLINE,
            (11) '�����'            NO-GAP,  SY-VLINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE :/ SY-VLINE,(15)  '�����ȣ' NO-GAP,  SY-VLINE,
            (21)  '��ǥ L/C ������ȣ' NO-GAP, SY-VLINE,
            (20)  '��ǥǰ��'         NO-GAP,  SY-VLINE,
            (20)  '����'             NO-GAP,  SY-VLINE,
            (20)  '������'           NO-GAP,  SY-VLINE,
            (11)  '�Ű������'       NO-GAP,  SY-VLINE.
  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   PERFORM   P4000_SET_SELETE_OPTION.
   IF S_ZFBLNO[] IS INITIAL.
      W_ERR_CHK  =  'Y'.
      EXIT.
   ENDIF.

   PERFORM   P4000_GET_ZTIDS      USING   W_ERR_CHK.
   IF  W_ERR_CHK  EQ  'Y'. EXIT.  ENDIF.

   PERFORM   P4000_ZTIDS_WRITE    USING   W_ERR_CHK.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

   IF W_COUNT GT 0.
      WRITE : / '��', W_COUNT, '��'.
   ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED ON.

   SELECT SINGLE * FROM ZTBL WHERE ZFBLNO EQ IT_TAB-ZFBLNO.
   CONCATENATE IT_TAB-ZFREBELN ZTBL-ZFSHNO INTO IT_TAB-W_EBELN
               SEPARATED BY '-'.

   WRITE :/ SY-VLINE,
           (15) IT_TAB-W_EBELN NO-GAP,           SY-VLINE, "PO No.
           (21) IT_TAB-ZFHBLNO NO-GAP,           SY-VLINE, "House B/L No
           (03) IT_TAB-ZFSTAMC,                            "������ȭ.
           (16) IT_TAB-ZFSTAMT CURRENCY IT_TAB-ZFSTAMC NO-GAP,
                                                 SY-VLINE, "�����ݾ�.
           (03) IT_TAB-ZFINAMTC,                           "�������ȭ.
           (16) IT_TAB-ZFINAMT CURRENCY IT_TAB-ZFINAMTC NO-GAP,
                                                 SY-VLINE, "�����
           (20) IT_TAB-DOMTEXT NO-GAP,           SY-VLINE, "����.
           (11) IT_TAB-ZFIDSDT NO-GAP,           SY-VLINE. "�����.
* HIDE.
   HIDE: IT_TAB.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE :/ SY-VLINE,
           (15)  IT_TAB-ZFIDRNO NO-GAP,        SY-VLINE,  "�����ȣ.
           (21)  IT_TAB-ZFOPNNO NO-GAP,        SY-VLINE,  "��ǥ L/C No
           (20)  IT_TAB-ZFRGDSR NO-GAP,        SY-VLINE,  "��ǥǰ��.
           (03)  IT_TAB-ZFTFAC,                           "������ȭ.
           (16)  IT_TAB-ZFTFA CURRENCY IT_TAB-ZFTFAC NO-GAP,
                                               SY-VLINE,  "�� ��.
           (20)  IT_TAB-NAME1   NO-GAP,        SY-VLINE,  "������.
           (11)  IT_TAB-ZFIDWDT NO-GAP,        SY-VLINE.  "�Ű������.
   WRITE:/ SY-ULINE.
* HIDE
   HIDE: IT_TAB.
   W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_UNRELEASE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_UNRELEASE_CHECK USING    P_ZFREQNO.
* Amend ���翩�� ü?

* Invoice ü?

ENDFORM.                    " P2000_UNRELEASE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_UPLOAD_FILE
*&---------------------------------------------------------------------*
*       UPLOAD�� FILENAME�� �����ϴ� �����ƾ.
*----------------------------------------------------------------------*
FORM P1000_GET_UPLOAD_FILE USING    W_ERR_CHK.

  " ���Ը��� HEADER DATA UPLOAD.
  MOVE  'C:\����Data\import_h.TXT'  TO  W_FILENAME.

  CALL FUNCTION 'WS_UPLOAD'
    EXPORTING
      FILENAME = W_FILENAME
      FILETYPE = 'DAT'
    TABLES
      DATA_TAB = IT_EDI.

  IF SY-SUBRC NE 0.
     MESSAGE E977 WITH 'File �� Upload �ϴ� ���� Error�� �߻��߽��ϴ�.'.
  ENDIF.

  " ���Ը��� �� ���� DATA UPLOAD.
  MOVE  'C:\����Data\import_d.TXT' TO W_FILENAME.
  CALL FUNCTION 'WS_UPLOAD'
    EXPORTING
      FILENAME = W_FILENAME
      FILETYPE = 'DAT'
    TABLES
      DATA_TAB = IT_EDIHS.

  IF SY-SUBRC NE 0.
     MESSAGE E977 WITH 'File �� Upload �ϴ� ���� Error�� �߻��߽��ϴ�.'.
  ENDIF.

  " ���Ը��� �� ���� DATA UPLOAD.
  MOVE  'C:\����Data\import_m.TXT' TO W_FILENAME.
  CALL FUNCTION 'WS_UPLOAD'
    EXPORTING
      FILENAME = W_FILENAME
      FILETYPE = 'DAT'
    TABLES
      DATA_TAB = IT_EDIHSD.

  IF SY-SUBRC NE 0.
     MESSAGE E977 WITH 'File �� Upload �ϴ� ���� Error�� �߻��߽��ϴ�.'.
  ENDIF.

ENDFORM.                    " P1000_GET_UPLOAD_FILE
*&---------------------------------------------------------------------*
*&      Form  SET_CURR_CONV_TO_INTERNAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ZTIDS_ZFTBAK  text
*      <--P_ZTIDS_ZFSTAMC  text
*----------------------------------------------------------------------*
FORM SET_CURR_CONV_TO_INTERNAL  CHANGING P_AMOUNT
                                         P_WAERS.
   BAPICURR-BAPICURR = P_AMOUNT.

   CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
        EXPORTING
           CURRENCY              =   P_WAERS
           AMOUNT_EXTERNAL       =   BAPICURR-BAPICURR
           MAX_NUMBER_OF_DIGITS  =   DIGITS
        IMPORTING
           AMOUNT_INTERNAL       =   P_AMOUNT
        EXCEPTIONS
           OTHERS                =   1.

ENDFORM.                    " SET_CURR_CONV_TO_INTERNAL

*&---------------------------------------------------------------------*
*&      Form  P4000_HEADER_INSERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P4000_HEADER_INSERT .

   REFRESH : IT_ZSIDSHS, IT_ZSIDSHSD.

   " INTERNAL TABLE ���� DB�� ����.
   LOOP  AT  IT_EDI.

      CLEAR : IT_HEADER.
      MOVE  IT_EDI  TO  IT_HEADER.

      CLEAR : ZTIDS.
      " KEY FIELD CHECK.
      MOVE : IT_HEADER-REC_028(10)    TO  ZTIDS-ZFBLNO,
             IT_HEADER-REC_028+10(5)  TO  ZTIDS-ZFCLSEQ.

      CLEAR : ZTIDR.
      SELECT SINGLE * FROM ZTIDR
             WHERE    ZFBLNO  EQ  ZTIDS-ZFBLNO
             AND      ZFCLSEQ EQ  ZTIDS-ZFCLSEQ.
      IF SY-SUBRC NE 0.
         CONTINUE.
      ENDIF.

      " ���� �ڷ� ������ SKIP.
      SELECT SINGLE * FROM ZTIDS
             WHERE    ZFBLNO   EQ  ZTIDS-ZFBLNO
             AND      ZFCLSEQ  EQ  ZTIDS-ZFCLSEQ.

      " ���ԽŰ��Ƿ� ���� ���� DATA SKIP.
      IF SY-SUBRC EQ 0.
         CONTINUE.
      ENDIF.

      " ���� DATA �� ���� KEY �� SET.
      MOVE-CORRESPONDING  ZTIDR  TO  ZTIDS.

      MOVE : IT_HEADER-REC_001   TO  ZTIDS-ZFIDRNO,     "���ԽŰ��ȣ.
             IT_HEADER-REC_002   TO  ZTIDS-ZFIDRCD,     "�Ű���.
             IT_HEADER-REC_004   TO  ZTIDS-ZFIAPNM,     "�����ڻ�ȣ.
             IT_HEADER-REC_005   TO  ZTIDS-ZFIAPCD,     "�����ں�ȣ.
             IT_HEADER-REC_006   TO  ZTIDS-ZFTDNM1,     "�����ڻ�ȣ.
             IT_HEADER-REC_007   TO  ZTIDS-ZFTDNM2,     "�����ڴ�ǥ��.
             IT_HEADER-REC_008   TO  ZTIDS-ZFTDNO,      "�������������.
             IT_HEADER-REC_009   TO  ZTIDS-ZFTDAD1,     "�������ּ�.
             IT_HEADER-REC_010   TO  ZTIDS-ZFTDTC,      "�����ڻ����.
             IT_HEADER-REC_011   TO  ZTIDS-ZFSUPNM,     "�����ڻ�ȣ.
             IT_HEADER-REC_012   TO  ZTIDS-ZFSUPNO,     "�����ں�ȣ.
             IT_HEADER-REC_013   TO  ZTIDS-ZFINRC,      "�Ű�������.
             IT_HEADER-REC_014   TO  ZTIDS-ZFINRCD,     "�Ű���������.
             IT_HEADER-REC_015   TO  ZTIDS-ZFPONC,      "���԰ŷ�����.
             IT_HEADER-REC_016   TO  ZTIDS-ZFITKD,      "���ԽŰ�����.
             IT_HEADER-REC_018   TO  ZTIDS-ZFAPRTC,     "������CD.
             IT_HEADER-REC_020   TO  ZTIDS-ZFLOCA,      "��ġ��ġ.
             IT_HEADER-REC_022   TO  ZTIDS-ZFCOCD,      "¡������.
             IT_HEADER-REC_023   TO  ZTIDS-ZFCARNM,     "�����.
             IT_HEADER-REC_024   TO  ZTIDS-ZFTRMET,     "�������.
             IT_HEADER-REC_025   TO  ZTIDS-ZFTRCN,      "��ۿ��.
             IT_HEADER-REC_026   TO  ZTIDS-ZFHBLNO,     "HOUSE B/L NO.
             IT_HEADER-REC_027   TO  ZTIDS-ZFIMCR,      "ȭ��������ȣ.
             IT_HEADER-REC_029   TO  ZTIDS-INCO1,       "�ε�����.
             IT_HEADER-REC_030   TO  ZTIDS-ZFSTAMC,     "������ȭ.
             IT_HEADER-REC_032   TO  ZTIDS-ZFTFAC,      "������ȭ.
             IT_HEADER-REC_034   TO  ZTIDS-ZFINAMTC,    "�������ȭ.
             IT_HEADER-REC_036   TO  ZTIDS-ZFPKNM,      "��������.
             IT_HEADER-REC_037   TO  ZTIDS-ZFPKCNT,     "�����.
             IT_HEADER-REC_038   TO  ZTIDS-ZFTOWT,      "���߷�.
             IT_HEADER-REC_042   TO  ZTIDS-ZFRFFNO,     "���ι�ȣ.
             IT_HEADER-REC_044   TO  ZTIDS-ZFOPNNO,     "L/C ��ȣ.
             IT_HEADER-REC_045   TO  ZTIDS-ZFMBLNO,     "MASTER B/L
             IT_HEADER-REC_046   TO  ZTIDS-ZFTRDNM,     "������ȣ.
             IT_HEADER-REC_047   TO  ZTIDS-ZFTRDNO,     "������ȣ.
             IT_HEADER-REC_048   TO  ZTIDS-ZFIAPCD,     "�����ں�ȣ.
             IT_HEADER-REC_049   TO  ZTIDS-ZFIMCD,      "����������.
             IT_HEADER-REC_050   TO  ZTIDS-ZFTDCD,      "�����ں�ȣ.
             IT_HEADER-REC_052   TO  ZTIDS-ZFCUPR,      "�����ȹ��ȣ.
             IT_HEADER-REC_053   TO  ZTIDS-ZFPLNM,      "��ġ���.
             IT_HEADER-REC_054   TO  ZTIDS-ZFAMCD,      "������.
             IT_HEADER-REC_055   TO  ZTIDS-ZFSUPC,      "�����ڱ�.
             IT_HEADER-REC_057   TO  ZTIDS-ZFCAC,       "���ⱹ.
             IT_HEADER-REC_059   TO  ZTIDS-ZFSCON,      "���ⱹ.
             IT_HEADER-REC_061   TO  ZTIDS-ZFORGYN,     "����������.
             IT_HEADER-REC_064   TO  ZTIDS-ZFSTRCD,     "Ư�۾�üCD.
             IT_HEADER-REC_066   TO  ZTIDS-ZFEXUS,      "�޷�ȯ��.
             IT_HEADER-REC_068   TO  ZTIDS-ZFADAMC,     "����ݱ���.
             IT_HEADER-REC_069   TO  ZTIDS-ZFADRT,      "������.
             IT_HEADER-REC_070   TO  ZTIDS-ZFADAMCU,    "�������ȭ.
             IT_HEADER-REC_071   TO  ZTIDS-ZFADAMX,     "����ȯ��.
             IT_HEADER-REC_074   TO  ZTIDS-ZFDUAMC,     "�����ݱ���.
             IT_HEADER-REC_075   TO  ZTIDS-ZFDURT,      "������.
             IT_HEADER-REC_076   TO  ZTIDS-ZFDUAMCU,    "��������ȭ.
             IT_HEADER-REC_077   TO  ZTIDS-ZFEXDU,      "������ȯ��.
             IT_HEADER-REC_087   TO  ZTIDS-ZFCHNAM.     "�����.

      " DATE CONVERT.
      "�Ű���.
      IF NOT IT_HEADER-REC_003  IS  INITIAL.
         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                  DATE_EXTERNAL = IT_HEADER-REC_003
              IMPORTING
                  DATE_INTERNAL = ZTIDS-ZFIDWDT.
      ENDIF.

      "������.
      IF NOT IT_HEADER-REC_017 IS INITIAL.
         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                  DATE_EXTERNAL = IT_HEADER-REC_017
              IMPORTING
                  DATE_INTERNAL = ZTIDS-ZFENDT.
      ENDIF.

      "�԰���.
      IF NOT IT_HEADER-REC_021 IS INITIAL.
         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                  DATE_EXTERNAL = IT_HEADER-REC_021
              IMPORTING
                  DATE_INTERNAL = ZTIDS-ZFINDT.
      ENDIF.

      "�Ű���.
      IF NOT IT_HEADER-REC_043 IS INITIAL.
         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
              EXPORTING
                  DATE_EXTERNAL = IT_HEADER-REC_043
              IMPORTING
                  DATE_INTERNAL = ZTIDS-ZFIDSDT.
      ENDIF.

*      "������.
*      IF NOT IT_HEADER-REC_088 IS INITIAL.
*         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
*              EXPORTING
*                  DATE_EXTERNAL = IT_HEADER-REC_088
*              IMPORTING
*                  DATE_INTERNAL = ZTIDS-ZFCTDT.
*      ENDIF.
*
*      "������.
*      IF NOT IT_HEADER-REC_089 IS INITIAL.
*         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
*              EXPORTING
*                  DATE_EXTERNAL = IT_HEADER-REC_089
*              IMPORTING
*                  DATE_INTERNAL = ZTIDS-ZFTXDT.
*      ENDIF.

      " �ݾ� FILED CONVERT.
      "�����ݾ�.
      MOVE IT_HEADER-REC_031 TO ZTIDS-ZFTBAK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFTBAK ZTIDS-ZFSTAMC.

      "���ӱݾ�.
      MOVE IT_HEADER-REC_033 TO ZTIDS-ZFTFA.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFTFA ZTIDS-ZFTFAC.

      "����ݾ�.
      MOVE IT_HEADER-REC_035 TO ZTIDS-ZFINAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFINAMT ZTIDS-ZFINAMTC.

      "��������.
      MOVE IT_HEADER-REC_040 TO ZTIDS-ZFTBAK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFTBAK  W_KRW .

      "�Ű� $.
      MOVE IT_HEADER-REC_041 TO ZTIDS-ZFTBAU.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFTBAU W_USD.

      "����ݾ�.
      MOVE IT_HEADER-REC_072 TO ZTIDS-ZFADAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFADAM ZTIDS-ZFADAMCU.

      "����ݾ׿�ȭ.
      MOVE IT_HEADER-REC_073 TO ZTIDS-ZFADAMK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFADAMK W_KRW.

      "�����ݾ�.
      MOVE IT_HEADER-REC_078 TO ZTIDS-ZFDUAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFDUAM ZTIDS-ZFDUAMCU.

      "�����ݾ׿�ȭ.
      MOVE IT_HEADER-REC_079 TO ZTIDS-ZFDUAMK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFDUAMK W_KRW.

      "����.
      MOVE IT_HEADER-REC_081 TO ZTIDS-ZFCUAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFCUAMTS W_KRW.

      "Ư�Ҽ�.
      MOVE IT_HEADER-REC_082 TO ZTIDS-ZFSCAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFSCAMTS W_KRW.

      "������.
      MOVE IT_HEADER-REC_083 TO ZTIDS-ZFEDAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING  ZTIDS-ZFEDAMTS W_KRW.

      "�ΰ���.
      MOVE IT_HEADER-REC_084 TO ZTIDS-ZFVAAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFVAAMTS W_KRW.

      "��Ư��.
      MOVE IT_HEADER-REC_085 TO ZTIDS-ZFAGAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFAGAMTS W_KRW .

      "�ּ�.
      MOVE IT_HEADER-REC_086 TO ZTIDS-ZFDRAMTS.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING ZTIDS-ZFDRAMTS W_KRW .

      " ������ DATA �ɸ���.
      LOOP  AT IT_ZTIDSHS WHERE ZFBLNO  EQ  ZTIDS-ZFBLNO
                          AND   ZFCLSEQ EQ  ZTIDS-ZFCLSEQ.
         MOVE-CORRESPONDING  IT_ZTIDSHS TO  IT_ZSIDSHS.
         APPEND  IT_ZSIDSHS.
      ENDLOOP.

      " ����� DATA �ɸ���.
      LOOP  AT IT_ZTIDSHSD WHERE ZFBLNO  EQ  ZTIDS-ZFBLNO
                           AND   ZFCLSEQ EQ  ZTIDS-ZFCLSEQ.
         MOVE-CORRESPONDING  IT_ZTIDSHSD TO  IT_ZSIDSHSD.
         APPEND  IT_ZSIDSHSD.
      ENDLOOP.

      " DB UPDATE.
      CALL FUNCTION 'ZIM_ZTIDS_DOC_MODIFY'
           EXPORTING
              W_OK_CODE        = W_OK_CODE
              ZFBLNO           = ZTIDS-ZFBLNO
              ZFCLSEQ          = ZTIDS-ZFCLSEQ
              ZFSTATUS         = 'C'
              W_ZTIDS_OLD      = *ZTIDS
              W_ZTIDS          = ZTIDS
           TABLES
             IT_ZSIDSHS_OLD   = IT_ZSIDSHS_ORG
             IT_ZSIDSHS       = IT_ZSIDSHS
             IT_ZSIDSHSD_OLD  = IT_ZSIDSHSD_ORG
             IT_ZSIDSHSD      = IT_ZSIDSHSD
           EXCEPTIONS
             ERROR_UPDATE     = 1
             ERROR_DELETE     = 2
             ERROR_INSERT     = 3.
      APPEND IT_HEADER.
   ENDLOOP.

ENDFORM.                    " P4000_HEADER_INSERT
*&---------------------------------------------------------------------*
*&      Form  P4000_HS_INSERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P4000_HS_INSERT .

   REFRESH : IT_ZTIDSHS.
   LOOP  AT  IT_EDIHS.

      CLEAR : IT_HS.
      MOVE  IT_EDIHS   TO  IT_HS.

      CLEAR : IT_ZTIDSHS.
      " KEY FIELD CHECK.
      MOVE : IT_HS-REC_024(10)    TO  IT_ZTIDSHS-ZFBLNO,
             IT_HS-REC_024+10(5)  TO  IT_ZTIDSHS-ZFCLSEQ.

      SELECT SINGLE * FROM ZTIDS
             WHERE    ZFBLNO   EQ  IT_ZTIDSHS-ZFBLNO
             AND      ZFCLSEQ  EQ  IT_ZTIDSHS-ZFCLSEQ.
      W_SUBRC = SY-SUBRC.
      " ���ԽŰ��Ƿ� ���� ���� DATA SKIP.
      CLEAR : ZTIDR.
      SELECT SINGLE * FROM ZTIDR
             WHERE    ZFBLNO  EQ  IT_ZTIDSHS-ZFBLNO
             AND      ZFCLSEQ EQ  IT_ZTIDSHS-ZFCLSEQ.
      IF SY-SUBRC NE 0.
         CONTINUE.
      ENDIF.

      MOVE : IT_HS-REC_002   TO  IT_ZTIDSHS-ZFCONO,     "������.
             IT_HS-REC_003   TO  IT_ZTIDSHS-STAWN,      "������ȣ.
             IT_HS-REC_004   TO  IT_ZTIDSHS-ZFWETM,     "�߷�����.
             IT_HS-REC_005   TO  IT_ZTIDSHS-ZFWET,      "���߷�.
             IT_HS-REC_006   TO  IT_ZTIDSHS-ZFQNTM,     "��������.
             IT_HS-REC_007   TO  IT_ZTIDSHS-ZFQNT,      "����.
             IT_HS-REC_012   TO  IT_ZTIDSHS-ZFGDNM,     "ǥ��ǰ��.
             IT_HS-REC_020   TO  IT_ZTIDSHS-ZFTXGB,     "��������.
             IT_HS-REC_021   TO  IT_ZTIDSHS-ZFCURT1,    "��������.
             IT_HS-REC_023   TO  IT_ZTIDSHS-ZFINRT1,    "����������.
             IT_HS-REC_027   TO  IT_ZTIDSHS-ZFTGDNM,    "�ŷ�ǰ��.
             IT_HS-REC_028   TO  IT_ZTIDSHS-ZFGCCD,     "��ǥ�ڵ�.
             IT_HS-REC_029   TO  IT_ZTIDSHS-ZFGCNM,     "��ǥǰ��.
             IT_HS-REC_031   TO  IT_ZTIDSHS-ZFATTYN,    "÷�μ�������.
             IT_HS-REC_032   TO  IT_ZTIDSHS-ZFREQNM,    "ȯ�޴���.
             IT_HS-REC_033   TO  IT_ZTIDSHS-ZFREQN,     "ȯ�޼���.
             IT_HS-REC_034   TO  IT_ZTIDSHS-ZFTXAMCD,   "�������.
             IT_HS-REC_035   TO  IT_ZTIDSHS-ZFCDPCD,    "�������鱸��.
             IT_HS-REC_037   TO  IT_ZTIDSHS-ZFCUDIV,    "���������ȣ.
             IT_HS-REC_038   TO  IT_ZTIDSHS-ZFRDRT,     "����������.
             IT_HS-REC_039   TO  IT_ZTIDSHS-ZFHMTCD,    "����������.
             IT_HS-REC_040   TO  IT_ZTIDSHS-ZFSCCD,     "Ư�Ҽ���ȣ.
             IT_HS-REC_041   TO  IT_ZTIDSHS-ZFHMTTY,    "��������ȣ.
             IT_HS-REC_042   TO  IT_ZTIDSHS-ZFVTXCD,    "�ΰ�������.
             IT_HS-REC_043   TO  IT_ZTIDSHS-ZFVTXTY,    "�ΰ��������ȣ.
             IT_HS-REC_044   TO  IT_ZTIDSHS-ZFVTRT,     "�ΰ�������.
             IT_HS-REC_045   TO  IT_ZTIDSHS-ZFETXCD,    "����������.
             IT_HS-REC_046   TO  IT_ZTIDSHS-ZFATXCD,    "��Ư������.
             IT_HS-REC_047   TO  IT_ZTIDSHS-ZFADGB,     "����ݱ���.
             IT_HS-REC_048   TO  IT_ZTIDSHS-ZFADRT,     "������.
             IT_HS-REC_049   TO  IT_ZTIDSHS-ZFADC,      "������ȭ.
             IT_HS-REC_050   TO  IT_ZTIDSHS-ZFEXAD,     "����ȯ��.
             IT_HS-REC_053   TO  IT_ZTIDSHS-ZFDUAMC,    "��������.
             IT_HS-REC_054   TO  IT_ZTIDSHS-ZFDURT,     "������.
             IT_HS-REC_055   TO  IT_ZTIDSHS-ZFDUAMCU,   "������ȭ.
             IT_HS-REC_056   TO  IT_ZTIDSHS-ZFEXDU,     "����ȯ��.
             IT_HS-REC_058   TO  IT_ZTIDSHS-ZFORYN,     "��������.
             IT_HS-REC_059   TO  IT_ZTIDSHS-ZFORME,     "������.
             IT_HS-REC_060   TO  IT_ZTIDSHS-ZFORTY,     "��������.
             IT_HS-REC_061   TO  IT_ZTIDSHS-ZFTRRL,     "�����ŷ�����.
             IT_HS-REC_062   TO  IT_ZTIDSHS-ZFGDAL,     "ǰ�񼼹�.
             IT_HS-REC_063   TO  IT_ZTIDSHS-ZFEXOP,     "�����˻�.
             IT_HS-REC_064   TO  IT_ZTIDSHS-ZFCTW1,     "���������1.
             IT_HS-REC_065   TO  IT_ZTIDSHS-ZFCTW2,     "���������2.
             IT_HS-REC_066   TO  IT_ZTIDSHS-ZFCTW3,     "���������3.
             IT_HS-REC_067   TO  IT_ZTIDSHS-ZFCTW4,     "���������4.
             IT_HS-REC_068   TO  IT_ZTIDSHS-ZFSTCS,     "Ư�� C/S.
             IT_HS-REC_069   TO  IT_ZTIDSHS-ZFCSGB,     "C/S ����.
             IT_HS-REC_070   TO  IT_ZTIDSHS-ZFCSCH.     "�˻纯��.

      "�ݾ� FILED CONVERT.
      "�Ű�� $.
      MOVE IT_HS-REC_010 TO IT_ZTIDSHS-ZFTBAU.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFTBAU W_USD.

      "�Ű�� ��ȭ.
      MOVE IT_HS-REC_011 TO IT_ZTIDSHS-ZFTBAK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFTBAK W_KRW.

      "������.
      MOVE IT_HS-REC_013 TO IT_ZTIDSHS-ZFCUAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFCUAMT W_KRW.

      "��������.
      MOVE IT_HS-REC_014 TO IT_ZTIDSHS-ZFHMAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFHMAMT W_KRW.

      "������.
      MOVE IT_HS-REC_015 TO IT_ZTIDSHS-ZFEDAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFEDAMT W_KRW.

      "�ΰ���.
      MOVE IT_HS-REC_017 TO IT_ZTIDSHS-ZFVAAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFVAAMT W_KRW.

      "�����.
      MOVE IT_HS-REC_018 TO IT_ZTIDSHS-ZFCUAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFCUAMT W_KRW.

      "�����ݾ�.
      MOVE IT_HS-REC_022 TO IT_ZTIDSHS-ZFSTAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFSTAMT W_KRW.

      "��Ư��.
      MOVE IT_HS-REC_023 TO IT_ZTIDSHS-ZFAGAMT.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFAGAMT W_KRW.

      "����ݾ�
      MOVE IT_HS-REC_051 TO IT_ZTIDSHS-ZFADAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFADAM IT_ZTIDSHS-ZFADC.

      "����ݾ׿�ȭ
      MOVE IT_HS-REC_052 TO IT_ZTIDSHS-ZFADAMK.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFADAMK W_KRW.

      "�����ݾ�.
      MOVE IT_HS-REC_057 TO IT_ZTIDSHS-ZFDUAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFDUAM IT_ZTIDSHS-ZFDUAMCU.

      "�����д��.
      MOVE IT_HS-REC_079 TO IT_ZTIDSHS-ZFCDIVAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFCDIVAM W_KRW.

      "�����Ѻм�.
      MOVE IT_HS-REC_080 TO IT_ZTIDSHS-ZFTDIVAM.
      PERFORM SET_CURR_CONV_TO_INTERNAL
                       CHANGING IT_ZTIDSHS-ZFTDIVAM IT_ZTIDSHS-ZFDUAMCU.

      APPEND  IT_ZTIDSHS.

   ENDLOOP.

ENDFORM.                    " P4000_HS_INSERT

*&---------------------------------------------------------------------*
*&      Form  P4000_HSD_INSERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P4000_HSD_INSERT .

   REFRESH : IT_ZSIDSHSD.
   LOOP  AT  IT_EDIHSD.

      CLEAR : IT_HSD.
      MOVE  IT_EDIHSD   TO  IT_HSD.

      CLEAR : ZTIDSHSD.
      " KEY FIELD CHECK.
      MOVE : IT_HSD-REC_009(10)    TO  IT_ZTIDSHSD-ZFBLNO,
             IT_HSD-REC_009+10(5)  TO  IT_ZTIDSHSD-ZFCLSEQ.

      SELECT SINGLE * FROM ZTIDS
             WHERE    ZFBLNO   EQ  IT_ZTIDSHSD-ZFBLNO
             AND      ZFCLSEQ  EQ  IT_ZTIDSHSD-ZFCLSEQ.
      W_SUBRC = SY-SUBRC.
      " ���ԽŰ��Ƿ� ���� ���� DATA SKIP.
      CLEAR : ZTIDR.
      SELECT SINGLE * FROM ZTIDR
             WHERE    ZFBLNO  EQ  IT_ZTIDSHSD-ZFBLNO
             AND      ZFCLSEQ EQ  IT_ZTIDSHSD-ZFCLSEQ.
      IF SY-SUBRC NE 0.
         CONTINUE.
      ENDIF.

      MOVE : IT_HSD-REC_002   TO  IT_ZTIDSHSD-ZFCONO,    "����ȣ.
             IT_HSD-REC_003   TO  IT_ZTIDSHSD-ZFRONO,    "���ȣ.
             IT_HSD-REC_006   TO  IT_ZTIDSHSD-ZFQNT,     "����.
             IT_HSD-REC_007   TO  IT_ZTIDSHSD-ZFQNTM,    "��������.
             IT_HSD-REC_023   TO  IT_ZTIDSHSD-STAWN,     "HSCODE.
             IT_HSD-REC_025   TO  IT_ZTIDSHSD-ZFGDDS1,   "�԰�1.
             IT_HSD-REC_026   TO  IT_ZTIDSHSD-ZFGDDS2,   "�԰�2.
             IT_HSD-REC_027   TO  IT_ZTIDSHSD-ZFGDDS3,   "�԰�3.
             IT_HSD-REC_028   TO  IT_ZTIDSHSD-ZFGDIN1,   "����1.
             IT_HSD-REC_029   TO  IT_ZTIDSHSD-ZFGDIN2.   "����2.

      " ���ԽŰ�� �� �������� CHECK.
      SELECT SINGLE * FROM ZTIDRHSD
             WHERE  ZFBLNO  EQ  IT_ZTIDSHSD-ZFBLNO
             AND    ZFCLSEQ EQ  IT_ZTIDSHSD-ZFCLSEQ
             AND    ZFCONO  EQ  IT_ZTIDSHSD-ZFCONO
             AND    ZFRONO  EQ  IT_ZTIDSHSD-ZFRONO.
      IF SY-SUBRC EQ 0.
         MOVE  : ZTIDRHSD-ZFIVNO  TO  IT_ZTIDSHSD-ZFIVNO,
                 ZTIDRHSD-ZFIVDNO TO  IT_ZTIDSHSD-ZFIVDNO.
      ENDIF.

      " �� TABLE �������� CHECK.
      SELECT SINGLE * FROM ZTIDSHSD
             WHERE  ZFBLNO  EQ  IT_ZTIDSHSD-ZFBLNO
             AND    ZFCLSEQ EQ  IT_ZTIDSHSD-ZFCLSEQ
             AND    ZFCONO  EQ  IT_ZTIDSHSD-ZFCONO
             AND    ZFRONO  EQ  IT_ZTIDSHSD-ZFRONO.
      APPEND  IT_ZTIDSHSD.

   ENDLOOP.

ENDFORM.                    " P4000_HSD_INSERT
*&---------------------------------------------------------------------*
*&      Form  P3000_DB_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_DB_DATA_WRITE .

   " HS �� ���� TABLE INSERT.
   PERFORM  P4000_HS_INSERT.

   " HS �� ���� TABLE INSERT.
   PERFORM  P4000_HSD_INSERT.

   " MAIN HEADER TABLE INSERT.
   PERFORM  P4000_HEADER_INSERT.

ENDFORM.                    " P3000_DB_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P4000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P4000_SET_SELETE_OPTION .

   REFRESH : S_ZFBLNO.
   LOOP  AT  IT_HEADER.

      MOVE : IT_HEADER-REC_028(10)    TO  S_ZFBLNO-LOW,
             'I'                      TO  S_ZFBLNO-SIGN,
             'EQ'                     TO  S_ZFBLNO-OPTION.
      APPEND  S_ZFBLNO.
   ENDLOOP.

ENDFORM.                    " P4000_SET_SELETE_OPTION
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTIDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P4000_GET_ZTIDS  USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
  REFRESH IT_TAB.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM  ZTIDS
  WHERE ZFBLNO    IN  S_ZFBLNO.
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'. EXIT.
  ENDIF.

ENDFORM.                    " P4000_GET_ZTIDS
*&---------------------------------------------------------------------*
*&      Form  P4000_ZTIDS_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P4000_ZTIDS_WRITE  USING    W_ERR_CHK.

   SET PF-STATUS 'ZIMR51'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMR51'.           " GUI TITLE SETTING..

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.
   ENDLOOP.

ENDFORM.                    " P4000_ZTIDS_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P2000_SHOW_IDS  USING    P_ZFBLNO
                              P_ZFCLSEQ.

   SET PARAMETER ID 'ZPBLNO'    FIELD  P_ZFBLNO.
   SET PARAMETER ID 'ZPCLSEQ'   FIELD  P_ZFCLSEQ.
   SET PARAMETER ID 'ZPHBLNO'    FIELD ''.
   SET PARAMETER ID 'ZPIDRNO'   FIELD ''.

   CALL TRANSACTION 'ZIM76' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_IDS
