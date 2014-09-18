*&---------------------------------------------------------------------*
*& Report  ZRIMAMDREQ                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : LC Amend ��û��.                                      *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.23                                            *
*&    ����ȸ�� : ��������                                              *
*&---------------------------------------------------------------------*
*&   DESC.     : L/C Amend ��û���� ����ϱ� ���� ����Ʈ.              *
*                Nashinho's 8th Report Program ssi-ik ^^;              *
*&---------------------------------------------------------------------*
*& [���泻��]  :                                                       *
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMAMDREQ   MESSAGE-ID ZIM NO STANDARD PAGE HEADING
                     LINE-SIZE 120.

TABLES : ZTREQHD_TMP,                  " �����Ƿ� Header Amend�� Temp..
         ZTMLCAMNARR,                  " MLC Amend ��Ÿ���Ǻ������..
         ZTMLCAMHD,                    " Master L/C Amend Header..
         ZTREQHD,                      " �����Ƿ� Header Table..
*         ZTREQIT,                      " �����Ƿ� Item   Table..
         ZTREQST,                      " �����Ƿ� ����   Table..
         ZTMLCHD,                      " Master L/C Header Table..
         ZTMLCSG2.                     " Master L/C Seg 2..

*>>> �����Ƿ� Header Amend�� Temp Table Declaration.
DATA: BEGIN OF IT_REQ_TMP OCCURS 1000,
        ZFREQNO    LIKE  ZTREQHD_TMP-ZFREQNO,  " �����Ƿڰ�����ȣ..
        ZFAMDNO    LIKE  ZTREQHD_TMP-ZFAMDNO,  " Amend Seq..
        ZFREQED    LIKE  ZTREQHD_TMP-ZFREQED,  " �Ƿ� ��ȿ��..
        ZFLASTAM   LIKE  ZTREQHD_TMP-ZFLASTAM, " ���������ݾ�..
        WAERS      LIKE  ZTREQHD_TMP-WAERS,    " ��ȭŰ..
      END OF IT_REQ_TMP.

*>>> Master L/C Amend Header Table Declaration.
DATA: BEGIN OF IT_MLCAMD OCCURS 1000,
        ZFREQNO    LIKE  ZTMLCAMHD-ZFREQNO,    " �����Ƿڰ�����ȣ..
        ZFAMDNO    LIKE  ZTMLCAMHD-ZFAMDNO,    " Amend Seq..
        ZFNEXDT    LIKE  ZTMLCAMHD-ZFNEXDT,    " ��ȿ���Ϻ���..
        ZFIDCD     LIKE  ZTMLCAMHD-ZFIDCD,     " �ݾ׺��� ����..
        ZFIDAM     LIKE  ZTMLCAMHD-ZFIDAM,     " �ݾ׺�����.
        WAERS      LIKE  ZTMLCAMHD-WAERS,
        ZFNDAMT    LIKE  ZTMLCAMHD-ZFNDAMT,    " ������ �����ݾ�..
        ZFALCQ     LIKE  ZTMLCAMHD-ZFALCQ,     " ����������� ��뿩��..
        ZFALCP     LIKE  ZTMLCAMHD-ZFALCP,     " �����������..
        ZFNSPRT    LIKE  ZTMLCAMHD-ZFNSPRT,    " �����׺���..
        ZFNAPRT    LIKE  ZTMLCAMHD-ZFNAPRT,    " �����׺���..
        ZFNLTSD    LIKE  ZTMLCAMHD-ZFNLTSD,    " ���������� ����..
        ZFBENI1    LIKE  ZTMLCAMHD-ZFBENI1,    " ������ ��ȣ/�ּ� 1..
        ZFBENI2    LIKE  ZTMLCAMHD-ZFBENI2,    " ������ ��ȣ/�ּ� 2..
        ZFBENI3    LIKE  ZTMLCAMHD-ZFBENI3,    " ������ ��ȣ/�ּ� 3..
        ZFBENI4    LIKE  ZTMLCAMHD-ZFBENI4,    " ������ ��ȣ/�ּ� 4..
*>>> DF=Full Cable, DG=Short Cable, DD=Air Mail..
        ZFOPME     LIKE  ZTMLCAMHD-ZFOPME,     " �������..
      END OF IT_MLCAMD.

*>>> �����Ƿ� Header Table Declaration.
DATA: BEGIN OF IT_REQHD OCCURS 1000,
        ZFREQNO    LIKE  ZTREQHD-ZFREQNO,      " �����Ƿڰ�����ȣ..
        ZFREQED    LIKE  ZTREQHD-ZFREQED,      " �Ƿ���ȿ��..
      END OF IT_REQHD.

*>>> Master L/C Header Table Declaration.
DATA: BEGIN OF IT_MLCHD OCCURS 1000,
        ZFREQNO    LIKE  ZTMLCHD-ZFREQNO,      " �����Ƿڰ�����ȣ..
        ZFOBNM     LIKE  ZTMLCHD-ZFOBNM,       " ���������..
      END OF IT_MLCHD.

*DATA: BEGIN OF IT_REQIT OCCURS 1000,


*>>> �����Ƿ� ����(Status) Table Declaration.
DATA: BEGIN OF IT_REQST OCCURS 1000,
        ZFREQNO    LIKE  ZTREQST-ZFREQNO,      " �����Ƿڰ�����ȣ..
        ZFAMDNO    LIKE  ZTREQST-ZFAMDNO,      " Amend ȸ��..
        ZFOPNNO    LIKE  ZTREQST-ZFOPNNO,      " �ſ���-���ι�ȣ..
        ZFAPPDT    LIKE  ZTREQST-ZFAPPDT,      " ���濹����..
        ZFOPNDT    LIKE  ZTREQST-ZFOPNDT,      " ������..
        ZFDOCST    LIKE  ZTREQST-ZFDOCST,      " ��������..
      END OF IT_REQST.

*>>> Master L/C Amend ��Ÿ���� ������� Table Declaration.
DATA: BEGIN OF IT_MLCAMNARR OCCURS 1000,
        ZFREQNO     LIKE  ZTMLCAMNARR-ZFREQNO, " �����Ƿڰ�����ȣ..
        ZFAMDNO     LIKE  ZTMLCAMNARR-ZFAMDNO, " Amend ȸ��..
        ZFLNARR     LIKE  ZTMLCAMNARR-ZFLNARR, " Seq ��Ÿ���Ǻ������..
        ZFNARR      LIKE  ZTMLCAMNARR-ZFNARR,  " ��Ÿ���Ǻ������..
*        ZFFIELD     LIKE  ZTMLCAMNARR-ZFFIELD, " �ʵ��̸�..
      END OF IT_MLCAMNARR.

DATA: BEGIN OF IT_MLCSG2 OCCURS 1000,
        ZFREQNO     LIKE  ZTMLCSG2-ZFREQNO,    " �����Ƿڰ�����ȣ..
*        ZFELEAD1    LIKE  ZTMLCSG2-ZFELEAD1,   " App ���ڼ��� �ּ�1..
*        ZFELEAD2    LIKE  ZTMLCSG2-ZFELEAD2,   " App ���ڼ��� �ּ�2..
        ZFAPPNM     LIKE  ZTMLCSG2-ZFAPPNM,    " App ��ȣ/����..
        ZFTELNO     LIKE  ZTMLCSG2-ZFTELNO,    " Applicant ��ȭ��ȣ..
        ZFAPPAD1    LIKE  ZTMLCSG2-ZFAPPAD1,   " Applicant �ּ�1..
        ZFAPPAD2    LIKE  ZTMLCSG2-ZFAPPAD2,   " Applicant �ּ�2..
      END OF IT_MLCSG2.

DATA: TEMP    LIKE  ZTREQST-ZFAMDNO,
      LINE    TYPE  I.
*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.

*   SELECT-OPTIONS:
*      S_REQNO  FOR  ZTREQHD-ZFREQNO NO INTERVALS NO-EXTENSION,
*      S_AMDNO  FOR  ZTREQST-ZFAMDNO NO INTERVALS NO-EXTENSION.
*      NO INTERVALS NO-EXTENSION OBLIGATORY
   PARAMETERS: P_REQNO  LIKE  ZTREQHD-ZFREQNO,
               P_AMDNO  LIKE  ZTREQST-ZFAMDNO.
SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION: �˻�ȭ�� ������ �߻��ϴ� �̺�Ʈ..
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.          " Title: '���Խſ������Ǻ����û��'.

*-----------------------------------------------------------------------
* START-OF-SELECTION: �˻�ȭ���� �����ϱ����� �̺�Ʈ..
*-----------------------------------------------------------------------
START-OF-SELECTION.

   PERFORM P1000_READ_MLCHD_DATA.     " Master L/C Header..
   PERFORM P1000_READ_MLCAMD_DATA.    " Master L/C Amend Header..
   PERFORM P1000_READ_MLCAMNARR_DATA. " Master L/C Amend ��Ÿ���Ǻ����.
   PERFORM P1000_READ_REQHD_DATA.     " �����Ƿ� Header..
   PERFORM P1000_READ_REQST_DATA.     " �����Ƿ� ����(Status)..
   PERFORM P1000_READ_REQ_TEMP_DATA.  " �����Ƿ� Header Amend�� Temp..
   PERFORM P1000_READ_MLCSG2_DATA.

*-----------------------------------------------------------------------
* END-OF-SELECTION.
*-----------------------------------------------------------------------
END-OF-SELECTION.

   SET TITLEBAR 'TIT1'.
   PERFORM P3000_WRITE_MLCAMD_DATA.
*   PERFORM P3000_WRITE_MLCAMNARR_DATA.
*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT USER-COMMAND.


*-----------------------------------------------------------------------
* From Now On Only Perform Statement Will Be Appeared.
*-----------------------------------------------------------------------

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MLCHD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MLCHD_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MLCHD
            FROM ZTMLCHD
           WHERE ZFREQNO EQ P_REQNO.

ENDFORM.                    " P1000_READ_MLCHD_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MLCAMD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MLCAMD_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MLCAMD
            FROM ZTMLCAMHD
           WHERE ZFREQNO EQ P_REQNO
             AND ZFAMDNO EQ P_AMDNO.
ENDFORM.                    " P1000_READ_MLCAMD_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MLCAMNARR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MLCAMNARR_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MLCAMNARR
            FROM ZTMLCAMNARR
           WHERE ZFREQNO EQ P_REQNO
             AND ZFAMDNO EQ P_AMDNO.
ENDFORM.                    " P1000_READ_MLCAMNARR_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_REQHD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_REQHD_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_REQHD
            FROM ZTREQHD
           WHERE ZFREQNO EQ P_REQNO.

ENDFORM.                    " P1000_READ_REQHD_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_REQST_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_REQST_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_REQST
            FROM ZTREQST
           WHERE ZFREQNO EQ P_REQNO.

ENDFORM.                    " P1000_READ_REQST_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_REQ_TEMP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_REQ_TEMP_DATA.

   TEMP = P_AMDNO - 1.
   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_REQ_TMP
            FROM ZTREQHD_TMP
           WHERE ZFREQNO EQ P_REQNO
             AND ZFAMDNO EQ TEMP.

ENDFORM.                    " P1000_READ_REQ_TEMP_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MLCSG2_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MLCSG2_DATA.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MLCSG2
            FROM ZTMLCSG2
           WHERE ZFREQNO EQ P_REQNO.

ENDFORM.                    " P1000_READ_MLCSG2_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_MLCAMD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_MLCAMD_DATA.

LOOP AT IT_MLCAMD.
   READ TABLE IT_REQST      WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = IT_MLCAMD-ZFAMDNO.
   READ TABLE IT_REQHD      WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO.
   READ TABLE IT_REQ_TMP    WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = TEMP.
   READ TABLE IT_MLCHD      WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO.
   READ TABLE IT_MLCSG2     WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO.
   READ TABLE IT_MLCAMD     WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = TEMP.
   READ TABLE IT_MLCAMNARR  WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = IT_MLCAMD-ZFAMDNO.
   SKIP 2.
   WRITE: /50 '���Խſ������Ǻ����û��' NO-GAP,
          /30 'APPLICATION FOR AMENDMENT TO ' NO-GAP,
              'IREEVOCABLE DOCUMENTARY CREDIT' NO-GAP.

   SKIP 2.
   WRITE: / 'TO : ' NO-GAP, IT_MLCHD-ZFOBNM,
         91 'DATE : ' NO-GAP, 110 IT_REQST-ZFAPPDT NO-GAP.

   READ TABLE IT_REQST      WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = TEMP.

   SKIP 2.
   WRITE: / 'CREDIT NO.  : ' NO-GAP, IT_REQST-ZFOPNNO NO-GAP,
         82 'DATE OF ISSUE : ' NO-GAP, 110 IT_REQST-ZFOPNDT NO-GAP.
   SKIP.
   WRITE: / 'EXPIRY DATE : ' NO-GAP, IT_REQ_TMP-ZFREQED NO-GAP,
         89 'AMOUNT : ' NO-GAP, IT_REQ_TMP-WAERS NO-GAP,
             IT_REQ_TMP-ZFLASTAM CURRENCY IT_REQ_TMP-WAERS.
   SKIP.
   WRITE: / 'BENEFICIARY : ' NO-GAP, IT_MLCAMD-ZFBENI1 NO-GAP.

   READ TABLE IT_MLCAMD     WITH KEY ZFREQNO = IT_MLCAMD-ZFREQNO
                                     ZFAMDNO = IT_MLCAMD-ZFAMDNO.

   SKIP 2.
   WRITE: / 'We request you to amend by ' NO-GAP.
      IF IT_MLCAMD-ZFOPME EQ 'DF'.
         WRITE: 'Full Cable' NO-GAP.
      ELSEIF IT_MLCAMD-ZFOPME EQ 'DG'.
         WRITE: 'Short Cable' NO-GAP.
      ELSE.
         WRITE: 'Airmail' NO-GAP.
      ENDIF.
   WRITE: ' the Captioned documentary credit' NO-GAP.

   SKIP 2.

*>>> ��ȿ���� �����׸��� ǥ���ϱ� ���� ����..
   IF NOT IT_MLCAMD-ZFNEXDT IS INITIAL.
      WRITE: / '�� Expiry date of credit extended to : ' NO-GAP,
               IT_MLCAMD-ZFNEXDT NO-GAP.
   ELSE.
      WRITE: / '�� Expiry date of credit extended to : ' NO-GAP.
   ENDIF.
   SKIP.
*>>>�����ݾ� �����׸��� ǥ���ϱ� ���� ����..
   IF IT_MLCAMD-ZFIDCD EQ '+'.
      WRITE: / '�� Increase of L/C amount : ' NO-GAP,
               IT_MLCAMD-ZFIDAM CURRENCY IT_MLCAMD-WAERS NO-GAP.
      SKIP.
      WRITE: / '�� Decrease of L/C amount : ' NO-GAP.
      SKIP.
      WRITE: / '�� New credit amount after amendment : ' NO-GAP,
               IT_MLCAMD-ZFNDAMT CURRENCY IT_MLCAMD-WAERS NO-GAP.
   ELSEIF IT_MLCAMD-ZFIDCD EQ '-'.
      WRITE: / '�� Increase of L/C amount : ' NO-GAP.
      SKIP.
      WRITE: / '�� Decrease of L/C amount : ' NO-GAP,
               IT_MLCAMD-ZFIDAM  CURRENCY IT_MLCAMD-WAERS NO-GAP.
      SKIP.
      WRITE: / '�� New credit amount after amendment : ' NO-GAP,
               IT_MLCAMD-ZFNDAMT  CURRENCY IT_MLCAMD-WAERS NO-GAP.
   ELSE.
      WRITE: / '�� Increase of L/C amount : ' NO-GAP.
      SKIP.
      WRITE: / '�� Decrease of L/C amount : ' NO-GAP.
      SKIP.
      WRITE: / '�� New credit amount after amendment : ' NO-GAP.

   ENDIF.
   SKIP.
*>>> �����ݾ� �����׸�(����������)�� ǥ���ϱ� ���� ����..
   IF IT_MLCAMD-ZFALCQ EQ 'T'.
      WRITE: / '�� New percentage credit after amendment : ' NO-GAP,
               '(' NO-GAP, IT_MLCAMD-ZFALCP NO-GAP, '% ' NO-GAP,
               'Plus/Minus' NO-GAP, ')' NO-GAP.
   ELSEIF IT_MLCAMD-ZFALCQ EQ 'X'.
      WRITE: / '�� New percentage credit after amendment : ' NO-GAP,
               '(' NO-GAP, IT_MLCAMD-ZFALCP NO-GAP, '% ' NO-GAP,
               'Maximum' NO-GAP, ')' NO-GAP.
   ELSEIF IT_MLCAMD-ZFALCQ EQ '2AA'.
      WRITE: / '�� New percentage credit after amendment : ' NO-GAP,
               '(' NO-GAP, IT_MLCAMD-ZFALCP NO-GAP, '% ' NO-GAP,
               'Up To' NO-GAP, ')' NO-GAP.
   ELSEIF IT_MLCAMD-ZFALCQ EQ '2AB'.
      WRITE: / '�� New percentage credit after amendment : ' NO-GAP,
               '(' NO-GAP, IT_MLCAMD-ZFALCP NO-GAP, '% ' NO-GAP,
               'Not Exceeding' NO-GAP, ')' NO-GAP.
   ELSE.
      WRITE: / '�� New percentage credit after amendment : ' NO-GAP.

   ENDIF.
   SKIP.
*>>> ������, ������ ���濩�θ� ǥ���ϱ� ���� ����..
   IF NOT IT_MLCAMD-ZFNSPRT IS INITIAL.
      WRITE: / '�� New shipment from : ' NO-GAP,
               IT_MLCAMD-ZFNSPRT NO-GAP.
   ELSE.
      WRITE: / '�� New shipment from : ' NO-GAP.
   ENDIF.
   SKIP.
   IF NOT IT_MLCAMD-ZFNAPRT IS INITIAL.
      WRITE: / '�� New shipment to : ' NO-GAP,
               IT_MLCAMD-ZFNAPRT NO-GAP.
   ELSE.
      WRITE: / '�� New shipment to : ' NO-GAP.
   ENDIF.
   SKIP.
*>>> �������°� ������� ���θ� ǥ���ϱ� ���� ����..
   IF IT_REQST-ZFDOCST EQ 'C'.
      WRITE: / '�� Credit is cancelled subjected ' NO-GAP,
               'to beneficiary`s consent : ' NO-GAP.

   ELSE.
      WRITE: / '�� Credit is cancelled subjected ' NO-GAP,
               'to beneficiary`s consent : ' NO-GAP.
   ENDIF.
   SKIP.
*>>> ��Ÿ ���������� ǥ���ϱ� ���� ����..
   IF NOT IT_MLCAMNARR-ZFNARR IS INITIAL.
      WRITE: / '�� Other amendments' NO-GAP.
   ELSE.
      WRITE: / '�� Other amendments' NO-GAP.
   ENDIF.

   LOOP AT IT_MLCAMNARR.
      SORT IT_MLCAMNARR BY ZFNARR.
      LINE = 0.
      ULINE.
      WRITE: / SY-VLINE NO-GAP, '  ' NO-GAP,IT_MLCAMNARR-ZFNARR NO-GAP,
           120 SY-VLINE NO-GAP.
      LINE = LINE + 1.
   ENDLOOP.

   WHILE LINE LT 15.
      WRITE: / SY-VLINE NO-GAP, 120 SY-VLINE NO-GAP.
      LINE = LINE + 1.
   ENDWHILE.
   ULINE.

   SKIP 5.
   WRITE: /50 '��    �� : ' NO-GAP, IT_MLCSG2-ZFAPPAD1 NO-GAP.
   IF NOT IT_MLCSG2-ZFAPPAD2 IS INITIAL.
      WRITE: /61 IT_MLCSG2-ZFAPPAD2 NO-GAP, 105 SY-ULINE(15).
   ELSE.
      WRITE /105 SY-ULINE(15).
   ENDIF.


   WRITE: /50 '�� û �� : ' NO-GAP, IT_MLCSG2-ZFAPPNM NO-GAP,
          105 SY-VLINE NO-GAP, '  �ΰ�����  ' NO-GAP,
          119 SY-VLINE NO-GAP,
         /105 SY-ULINE(15).
   WRITE: /50 '��ȭ��ȣ : ' NO-GAP, IT_MLCSG2-ZFTELNO NO-GAP,
          105 SY-VLINE NO-GAP, 119 SY-VLINE,
         /105 SY-VLINE NO-GAP, 119 SY-VLINE,
         /105 SY-VLINE NO-GAP, 119 SY-VLINE,
         /105 SY-ULINE(15).
ENDLOOP.

ENDFORM.                    " P3000_WRITE_MLCAMD_DATA
