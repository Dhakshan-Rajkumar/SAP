*&---------------------------------------------------------------------*
*& Report  ZRIMLGPRT                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : L/G �߱޽�û��                                        *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.07.13                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :  L/G �߱޽�û�� �μ�.                                 *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMLGPRT   MESSAGE-ID ZIM
                     LINE-SIZE 116
                     NO STANDARD PAGE HEADING.
TABLES : ZTLG,ZTREQHD,LFA1,ZTREQST,ZTBL,ZTBLIT,ZTLGGOD.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMLGLSTTOP.
INCLUDE   ZRIMUTIL01.     " Utility function ����.


*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   PARAMETERS    : P_ZFBLNO   LIKE ZTLG-ZFBLNO,
                   P_LGSEQ  LIKE ZTLG-ZFLGSEQ.

SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
    PERFORM   P2000_SET_PARAMETER.

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.
* ���� ���� ��?
    PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
*  ���̺� SELECT
    PERFORM   P1000_GET_ZTLG           USING W_ERR_CHK.

* ����Ʈ Write
    PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

   SET  TITLEBAR 'ZRIMLG'.          " TITLE BAR

ENDFORM.                    " P2000_SET_PARAMETER

*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

*   W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_BL_MGT'
*           ID 'ACTVT' FIELD '*'.

*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'B/L ���� Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK


*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZRIMLG'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZRIMLG'.           " GUI TITLE SETTING..

   CASE ZTBL-ZFVIA.
      WHEN 'VSL'.
        PERFORM P3000_LINE_WRITE_VSL.
      WHEN 'AIR'.
        PERFORM P3000_LINE_WRITE_AIR.
      WHEN OTHERS.
   ENDCASE.

ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE_VSL.
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE_VSL.
  SKIP 2.
  WRITE:/3 'P/O No.:',W_PONO.
  WRITE:/48  ' LETTER OF GUARANTEE'.
  SKIP 1.
  WRITE:/3 'To',8 ZTLG-ZFCARR1.
  WRITE  : 75 'L/G No',85 '  '. ULINE AT /5(30).
*  WRITE:  85 SY-ULINE.
  WRITE:/10 '[Shipping Company]', 75 'Date',85 ' '.
*  WRITE:/85 SY-ULINE.
  SKIP 1.
  WRITE:/  SY-ULINE.
  WRITE:/  SY-VLINE, (55) 'Vessel Name/Voyage No.',
         59 SY-VLINE,  61  'L/C No.',
         89 SY-VLINE,  91  'Date of Issue       ',116 SY-VLINE,
         /  SY-VLINE,   8   ZTLG-ZFCARNM,
         59 SY-VLINE,  63   ZTLG-ZFDCNO ,
         89 SY-VLINE,  93   ZTREQST-ZFOPNDT,       116 SY-VLINE,
         /  SY-ULINE,
         /  SY-VLINE, (55) 'Port of Loading  ',
            SY-VLINE, (55) 'Invoice Value',       116 SY-VLINE,
         /  SY-VLINE,   8   ZTLG-ZFSHCUNM,
         59 SY-VLINE,  63   ZTLG-ZFCIAMC ,
                       67   ZTLG-ZFCIAM CURRENCY ZTLG-ZFCIAMC
                                                 LEFT-JUSTIFIED,
                                                  116 SY-VLINE,
        /  SY-ULINE,
        /  SY-VLINE, (55) 'Port of Discharge(or Place of Delivery)',
           SY-VLINE, (55) 'Description of Cargo',116 SY-VLINE,
        /  SY-VLINE,   8   ZTLG-ZFARCUNM,
        59 SY-VLINE, 116 SY-VLINE.
 ULINE AT /1(58).
 WRITE: 63 W_GODS1.
 WRITE: 59 SY-VLINE,                             116 SY-VLINE.
 WRITE:/ SY-VLINE, (30) 'Bill of lading No.',
        30 SY-VLINE,  32  'Date of Issue',
        59 SY-VLINE,  63   W_GODS2,              116 SY-VLINE,
        /  SY-VLINE,   8   ZTLG-ZFHBLNO,
        30 SY-VLINE,  34   ZTLG-ZFTBIDT,
        59 SY-VLINE,  63   W_GODS3,       116 SY-VLINE.
 ULINE AT /1(58).
 WRITE: 59 SY-VLINE,63 W_GODS4,116 SY-VLINE.

 SELECT SINGLE *
          FROM LFA1
         WHERE LIFNR = ZTLG-ZFCARIR.

 WRITE:/  SY-VLINE, (55) 'Shipper',  59 SY-VLINE,
          63 W_GODS5,116 SY-VLINE,
        /  SY-VLINE,     8 LFA1-NAME1, 59 SY-VLINE,
          116 SY-VLINE.
 WRITE: 59 SY-VLINE,     116 SY-VLINE.
 WRITE:/ SY-ULINE.
 WRITE:/ SY-VLINE, (55) 'Consignee',
        59 SY-VLINE,  61 'No.of Packages',
        89 SY-VLINE,  91 'Marks & Nos.    ',    116 SY-VLINE,
        /  SY-VLINE, 8  W_Consignee,
        59 SY-VLINE,
        89 SY-VLINE,  116 SY-VLINE.

 ULINE AT /1(58).
 WRITE: 59 SY-VLINE, 63 ZTLG-ZFPKCN UNIT ZTLG-ZFPKCNM RIGHT-JUSTIFIED,
                     72 ZTLG-ZFPKCNM,
                      89 SY-VLINE,116 SY-VLINE.
 WRITE:/   SY-VLINE, (55) 'Party to be delivered',
        59 SY-VLINE,  61 '         ',89 SY-VLINE,116 SY-VLINE,
           SY-VLINE,  8 ' ',59 SY-VLINE,89 SY-VLINE,
       116 SY-VLINE.
 WRITE:/   SY-ULINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.

 WRITE:/ SY-VLINE,6
'Whereas you have issued a Bill of Lading covering the above',
 'shipment and the above cargo has been arrived ',116
SY-VLINE,
 / SY-VLINE,'at the above port',
'of discharge(or the above place of',
'delivery),we hereby request you to give delivery of the ',
116 SY-VLINE,
/ SY-VLINE,
'said cargo to the above ',
'mentioned party without',
'production of the original Bill of Lading.',116 SY-VLINE,
/ SY-VLINE,
 '',116 SY-VLINE.
WRITE:/ SY-VLINE,6
'In consideration of your complying with our above request,',
'we hereby agree as follows;',116 SY-VLINE.

 WRITE:/ SY-VLINE,116 SY-VLINE,
  / SY-VLINE,
'1. To indemnify, your servants and agents and to hold all',
 'of you harmless in respect of liablity, loss, damage ',116 SY-VLINE,
 / SY-VLINE,
'   or expenses which you may sustain by reason of delivering the',
'cargo in accordance with our request, provided',116 SY-VLINE,
/ SY-VLINE,
'   that the undersigned bank shall be exempt from liability',
  'for freight,demurrage or expenses in respect of the',116 SY-VLINE,
/ SY-VLINE,
'   contact of carrage.', 116 SY-VLINE.
WRITE:/ SY-VLINE, 116 SY-VLINE.
WRITE:/ SY-VLINE,
'2. AS soon as the original Bill of Lading corresponding to',
'the above cargo comes into our possession,We shall ',116 SY-VLINE,
/ SY-VLINE,
'   surrender the same to you,  whereupon our',
'liability hereunder shall cease.',116 SY-VLINE.
WRITE:/ SY-VLINE, 116 SY-VLINE.
WRITE: / SY-VLINE,
'3. The liability of each and every person under this',
'guarantee shall be joint and several and shall not be',116 SY-VLINE,
/ SY-VLINE,
'   condition upon your proceeding first against any person,',
'whether or not such person is party to or liable',116 SY-VLINE,
/ SY-VLINE,
'   under this guarantee.',116 SY-VLINE.
WRITE:/ SY-VLINE, 116 SY-VLINE.

WRITE: / SY-VLINE,
'4. This guarantee shall be governed by and construed in',
'accordance with US law and the jurisdiction of', 116 SY-VLINE,
/ SY-VLINE,
 6 'the competent court in US.',116 SY-VLINE.

WRITE:/ SY-VLINE, 116 SY-VLINE,
/ SY-VLINE,
6 'Should the Bill of lading holder file claim or bring a',
'lawsuit against you,you shall notify the undesigned',116 SY-VLINE,
/ SY-VLINE,
'Bank as soon as possible.',116 SY-VLINE.

 WRITE:/ SY-VLINE, 116 SY-VLINE,
       / SY-VLINE, 116 SY-VLINE,
       / SY-VLINE, 116 SY-VLINE.

 WRITE:/ SY-VLINE,
 6 'Yours faithfully,',116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.

 WRITE:/ SY-VLINE,
 6 'For and on behalf of',
 65 'For and on behalf of',116 SY-VLINE,
 / SY-VLINE,
 6'[Name of Requestor]',
 65 '[Name of bank]',116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE,6 ZTLG-ZFELENM,65 ZTLG-ZFISBNM, 116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.
 WRITE:/ SY-VLINE,116 SY-VLINE.

 WRITE:/ SY-VLINE,116 SY-VLINE.
 ULINE AT 6(40).
 ULINE AT 65(40).
 WRITE: 116 SY-VLINE.
*       /5 'Authorized Signature', 65 'Authorized Signature'.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.
 WRITE:/ SY-VLINE, 116 SY-VLINE.

 WRITE:/ SY-ULINE.
 SKIP 9.
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
*  WRITE:/3 'P/O No:',W_PONO.
*  WRITE:/47  '�� �� ȭ �� �� �� �� �� ��'.
*  SKIP 1.
*  WRITE :/3 '����:', 8 ZTLG-ZFCARR1, 95 '��������ȣ:'.
*  ULINE AT /3(40).
*  ULINE AT 95(40).
*  WRITE :/3 '[����ȸ���]',  95 '��������'.
*  ULINE AT /95(40).
*  WRITE:  SY-ULINE.
**----------------------------------
**-------------------------------------
*  WRITE:/  SY-VLINE, (55) '���� / ������ȣ',
*         59 SY-VLINE,  61  '�ſ����ȣ',
*         89 SY-VLINE,  91  '������    ',116 SY-VLINE,
*         /  SY-VLINE,   8   ZTLG-ZFCARNM,
*         59 SY-VLINE,  63   ZTLG-ZFDCNO ,
*         89 SY-VLINE,  93   ZTREQST-ZFOPNDT,       116 SY-VLINE,
*         /  SY-ULINE,
*         /  SY-VLINE, (55) '������ ',
*            SY-VLINE, (55) '����ݾ�',       116 SY-VLINE,
*         /  SY-VLINE,   8   ZTLG-ZFSHCUNM,
*         59 SY-VLINE,  63   ZTLG-ZFCIAMC ,
*                       67   ZTLG-ZFCIAM CURRENCY ZTLG-ZFCIAMC
*                            LEFT-JUSTIFIED,116 SY-VLINE,
*        /  SY-ULINE,
*        /  SY-VLINE, (55) '������(�Ǵ� �ε����)',
*           SY-VLINE, (55) 'ȭ����',116 SY-VLINE,
*        /  SY-VLINE,   8   ZTLG-ZFARCUNM,
*        59 SY-VLINE,  116 SY-VLINE.
* ULINE AT /1(58).
* WRITE: 59 SY-VLINE, 63   W_GODS1,116 SY-VLINE.
* WRITE:/ SY-VLINE, (30) '�������ǹ�ȣ',
*        30 SY-VLINE,  32  '������',
*        59 SY-VLINE,  63  W_GODS2,              116 SY-VLINE,
*        /  SY-VLINE,   8   ZTLG-ZFHBLNO,
*        30 SY-VLINE,  34   ZTLG-ZFTBIDT,
*        59 SY-VLINE,  63   W_GODS3,       116 SY-VLINE.
* ULINE AT /1(58).
* WRITE: 59 SY-VLINE,63 W_GODS4,116 SY-VLINE.
*
* WRITE:/  SY-VLINE, (55) '������',  59 SY-VLINE,63 W_GODS5,
*          116 SY-VLINE,
*       /  SY-VLINE,     8 ZTLG-ZFGSNM1, 59 SY-VLINE, 116 SY-VLINE.
* WRITE: 59 SY-VLINE,                                  116 SY-VLINE.
* WRITE:/ SY-ULINE.
*
* WRITE:/ SY-VLINE, (55) '������',
*        59 SY-VLINE,  61 '���尳��',
*        89 SY-VLINE,  91 'ȭ�� �� ��ȣ',116 SY-VLINE,
*        /  SY-VLINE, 8  W_Consignee,
*        59 SY-VLINE,
*        89 SY-VLINE, 116 SY-VLINE.
*
* ULINE AT /1(58).
* WRITE: 59 SY-VLINE, 63 ZTLG-ZFPKCN UNIT ZTLG-ZFPKCNM RIGHT-JUSTIFIED,
*                     72 ZTLG-ZFPKCNM,89 SY-VLINE,116 SY-VLINE.
* WRITE:/   SY-VLINE, (55) '�μ�������',
*        59 SY-VLINE,  61 '         ',89 SY-VLINE,116 SY-VLINE,
*           SY-VLINE,  8 ' ',59 SY-VLINE,89 SY-VLINE,
*       116 SY-VLINE.
* WRITE:/   SY-ULINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,6 '���� �ͻ簡 ��� ����ȭ���� ���� ����������',
*'�����Ͽ��� ���ȭ���� ��� ������(�Ǵ� �ε����)�� �����Ͽ���,'
* ,116 SY-VLINE.
* WRITE:/ SY-VLINE,'�츮�� �������ǿ����� �������� ���� ���'
* ,'����ڿ��� ���ȭ���� �ε��� �� ���� �ͻ翡�� ��û�մϴ�.',
*  116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,6
*   '�ͻ簡 ���� ���� ����� ��û�� ���� ��� �츮��',
*  '�Ʒ��� ���� ���� �մϴ�.',116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,
*   '1. �ͻ�� �ͻ簡 ������ �����,�븮�� ��δ� �����',
* '��û�� ���Ͽ� ȭ���� �ε������ν� �߻� ������ �� ä��,'
* ,116 SY-VLINE.
* WRITE:/ SY-VLINE,6 '�ս�,���� �Ǵ� ��뿡 ���Ͽ� ��å�Ѵ�.',
* '�ٸ� ������ ��۰��� �����Ͽ� �߻��ϴ� ä��, ����, ü����,'
* , 116 SY-VLINE.
* WRITE:/ SY-VLINE,6 '��Ÿ����� å���� ���� �ʴ´�.'
* ,116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,'2. ���ȭ���� �������ǿ����� �Լ��ϴ´�� �ͻ翡��',
*'�����ϰ�����, �� �� ����� å���� ����ȴ�.',116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,
*   '3. �� �������� �ϱ� ������ ����, �׸��� ��ΰ� ����',
* '�� �ܵ� å���� ������ �ͻ簡 �ϱ� �������� �� ������� ����',
* 116 SY-VLINE.
* WRITE:/ SY-VLINE,6 '�Ҽ��� ���� �Ͽ��� �� �� ��������'
* ,'�ش���(�ǰ���)�� ����̵� å���� �ֵ� ���� ���Ǻΰ� �ƴϴ�.',
* 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,'4. �� �������� �ذŹ� �� ���� ������ �ѱ��� ��',
*'�ѱ��������� �Ѵ�.',116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,6'�������� �������� ���� �Ǵ� �Ҽ��� �����ϴ�',
*'��쿡��, ������ ���� ���࿡ �뺸�Ͽ��� �Ѵ�.', 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,6 'ȭ           ��',
*         65 '��           ��',116 SY-VLINE.
* WRITE:/ SY-VLINE,116 SY-VLINE.
* WRITE:/ SY-VLINE,6 ZTLG-ZFELENM,65 ZTLG-ZFISBNM,116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE, 116 SY-VLINE.
* WRITE:/ SY-VLINE,116 SY-VLINE.
* ULINE AT 6(40).
* ULINE AT 65(40).
* WRITE:/ SY-VLINE,116 SY-VLINE.
* WRITE:/ SY-VLINE,116 SY-VLINE.
* WRITE:/ SY-VLINE,116 SY-VLINE.
* WRITE:/ SY-VLINE,116 SY-VLINE.
* WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE_VSL.

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTLG
*&---------------------------------------------------------------------*
FORM P1000_GET_ZTLG USING W_ERR_CHK.

   W_ERR_CHK = 'N'.
   CLEAR ZTLG.
   SELECT SINGLE *
     FROM ZTLG
    WHERE ZFBLNO  =  P_ZFBLNO
      AND ZFLGSEQ =  P_LGSEQ.
   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.

   CLEAR ZTBL.
   SELECT SINGLE *
      FROM ZTBL
     WHERE ZFBLNO = P_ZFBLNO.

   IF NOT ZTBL-ZFSHNO IS INITIAL.
      CONCATENATE ZTBL-ZFREBELN '-' ZTBL-ZFSHNO INTO W_PONO.
   ELSE.
      MOVE ZTBL-ZFREBELN TO W_PONO.
   ENDIF.

   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTLGGOD
      FROM  ZTLGGOD
      WHERE ZFBLNO = P_ZFBLNO
        AND ZFLGSEQ = P_LGSEQ.
   SORT IT_ZTLGGOD BY ZFLGOD.
   READ TABLE IT_ZTLGGOD INDEX 1.
   IF SY-SUBRC EQ 0.
      MOVE IT_ZTLGGOD-ZFGODS  TO W_GODS1.
   ENDIF.
   READ TABLE IT_ZTLGGOD INDEX 2.
   IF SY-SUBRC EQ 0.
      MOVE IT_ZTLGGOD-ZFGODS  TO W_GODS2.
   ENDIF.
    READ TABLE IT_ZTLGGOD INDEX 3.
   IF SY-SUBRC EQ 0.
      MOVE IT_ZTLGGOD-ZFGODS  TO W_GODS3.
   ENDIF.
    READ TABLE IT_ZTLGGOD INDEX 4.
   IF SY-SUBRC EQ 0.
      MOVE IT_ZTLGGOD-ZFGODS  TO W_GODS4.
   ENDIF.
    READ TABLE IT_ZTLGGOD INDEX 5.
   IF SY-SUBRC EQ 0.
      MOVE IT_ZTLGGOD-ZFGODS  TO W_GODS5.
   ENDIF.

   CLEAR ZTREQHD.
   SELECT SINGLE *
          FROM ZTREQHD
         WHERE ZFREQNO = ZTLG-ZFREQNO.
   CLEAR LFA1.
   SELECT SINGLE *
          FROM LFA1
         WHERE LIFNR = ZTLG-ZFGSCD.

   IF ZTREQHD-ZFREQTY = 'LC'.
      MOVE  LFA1-NAME1   TO W_Consignee.
   ELSE.
      MOVE  ZTLG-ZFELENM TO W_Consignee.
   ENDIF.
*>>�����Ƿ� Status
   SELECT MAX( ZFAMDNO ) INTO W_MAX_ZFAMDNO
     FROM  ZTREQST
     WHERE ZFREQNO = ZTLG-ZFREQNO
       AND ZFDOCST = 'O'.

   SELECT SINGLE *
     FROM ZTREQST
    WHERE ZFREQNO = ZTLG-ZFREQNO
      AND ZFAMDNO = W_MAX_ZFAMDNO.

   CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
       EXPORTING
             INPUT   =   ZTLG-ZFPKCN
       IMPORTING
             OUTPUT  =   ZTLG-ZFPKCN.

 ENDFORM.                    " P1000_GET_ZTLG
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE_AIR
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE_AIR.

  WRITE:/3 'P/O No:',W_PONO.
  WRITE:/35 '�װ�ȭ������忡���Ѽ���ȭ���ε��¶�(��û)��'.
  ULINE AT /35(44).
  SKIP 3.
  WRITE:/ SY-ULINE.
  WRITE:/ SY-VLINE,'���ȸ���',58 SY-VLINE,
        62 '�ſ�����ȣ',76 SY-VLINE,80 ZTLG-ZFDCNO,116 SY-VLINE.
  WRITE:/ SY-VLINE,58 SY-ULINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,6 ZTLG-ZFCARR1,58 SY-VLINE,
        72 '�װ�ȭ�� ����� ����',116 SY-VLINE.
  WRITE:/ SY-VLINE,6 ZTLG-ZFCARR2,58 SY-ULINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,6 ZTLG-ZFCARR3,58 SY-VLINE, 116 SY-VLINE.
  ULINE AT 1(57).
  WRITE: 58 SY-VLINE, 62 '������ȣ',76 SY-VLINE,80 ZTLG-ZFHBLNO,
  116 SY-VLINE.
  WRITE:/ SY-VLINE,'��  ��  ��',58 SY-VLINE,59 SY-ULINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,58 SY-VLINE,62 '��  ��  ��',
  76 SY-VLINE, 80 ZTLG-ZFTBIDT, 116 SY-VLINE.

  WRITE:/ SY-VLINE,6 ZTLG-ZFGSNM1,58 SY-ULINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,6 ZTLG-ZFGSNM2,58 SY-VLINE,
  62 '�������ȣ',76 SY-VLINE,
  80 ZTLG-ZFCARNM,116 SY-VLINE.

  WRITE:/ SY-VLINE,6 ZTLG-ZFGSNM3,58 SY-ULINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,58 SY-VLINE, 116 SY-VLINE.
  ULINE AT 1(57).
  WRITE: 58 SY-VLINE, 62 '��  ��  ��',76 SY-VLINE,80 ZTLG-ZFETA,
  116 SY-VLINE.
  WRITE:/ SY-VLINE, 58 SY-ULINE,116 SY-VLINE.
  WRITE:/ SY-VLINE,'�� �� �� ��',58 SY-VLINE,62 '��  ��  ��',
  76 SY-VLINE,80 ZTBL-ZFETD,116 SY-VLINE.
  WRITE:/ SY-VLINE, 58 SY-ULINE,116 SY-VLINE.
  WRITE:/ SY-VLINE,6 ZTLG-ZFCIAMC,
         10 ZTLG-ZFCIAM CURRENCY ZTLG-ZFCIAMC LEFT-JUSTIFIED,
  58 SY-VLINE,62 '��  ��  ��',76 SY-VLINE,80 ZTLG-ZFARCUNM,116 SY-VLINE.
  WRITE:/ SY-ULINE.
  READ TABLE IT_ZTLGGOD INDEX 1.
  WRITE:/ SY-VLINE,8 SY-VLINE,12 '��ǰ��',20 SY-VLINE,
  22 W_GODS1,76 SY-VLINE,80 'ȭ��ǥ�� �� ��ȣ',
  116 SY-VLINE.
  WRITE:/ SY-VLINE,5 '��', 8 SY-VLINE,20 SY-VLINE,76 SY-VLINE,
  116 SY-VLINE.
  ULINE AT 8(69).
  WRITE:/ SY-VLINE,5'ǰ',8 SY-VLINE,12 '����',20 SY-VLINE,
  22 ZTLG-ZFPKCN UNIT ZTLG-ZFPKCNM RIGHT-JUSTIFIED,
  32 ZTLG-ZFPKCNM,
  76 SY-VLINE,80 W_GODS2, 116 SY-VLINE.
  WRITE:/ SY-VLINE,5'��',116 SY-VLINE.
  ULINE AT 8(69).
  WRITE: 80 IT_ZTLGGOD-ZFGODS.
  WRITE:/ SY-VLINE,5'��',8 SY-VLINE,12 '�ܰ�',20 SY-VLINE,
  76 SY-VLINE,80 W_GODS3,116 SY-VLINE.

  WRITE:/ SY-VLINE, 116 SY-VLINE.
  ULINE AT 8(69).
  WRITE: 80 W_GODS4.
  WRITE:/ SY-VLINE,8 SY-VLINE,12'�ݾ�',20 SY-VLINE,22 ZTLG-ZFCIAMC,
  26 ZTLG-ZFCIAM CURRENCY ZTLG-ZFCIAMC
                  LEFT-JUSTIFIED, 76 SY-VLINE,80 W_GODS5,
  116 SY-VLINE.
  WRITE:/ SY-ULINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,6 '������ �� �ſ��� � ���Ͽ� �̹� ������',
        '����ȭ���� ���輱�������� ���࿡ �����ϱ��� �װ�ȭ�� �����',
        116 SY-VLINE,
  / SY-VLINE ,'�� �輭�ε��� ���Ͽ� �����ϰ��� ��û�ϸ� �������׿�'
     ,'���� ���� Ȯ�� �մϴ�.',
          116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,'1. ������ ����ȭ�����뺸������ ���������ν�',
  '�߻��ϴ� ����� å�� �� ����� ���','������ �δ��ϰڽ��ϴ�.',
  116 SY-VLINE.

  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,'2. ������ �� ����ȭ���� ���Ͽ��� ���࿡ ��������',
  '������ Ȯ���ϸ� ������ ����ȭ�� ���뺸������ ���� ����ä����',
  116 SY-VLINE.
  WRITE:/ SY-VLINE,6 '�����Ͽ��� �� ���� �����',
  '��� �Ǵ� ���ο� ���Ͽ�  ���࿩�Űŷ� �⺻��� ��7�� ��1��- ��5��',
  '��ȣ�� ������', 116 SY-VLINE.
  WRITE:/ SY-VLINE,6 '������',
  '���,������ û���� �޴� ��� �� ����ȭ���� ���࿡ �ε��ϰ�����',
   '����ȭ���� �ε��� �Ұ����� ��쿡��',
   116 SY-VLINE.
  WRITE:/ SY-VLINE,6
 '�� ����ȭ���� ����ϴ� �������',
 '��ȯ�ϰڽ��ϴ�.', 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,'3. ������ �� ����ȭ���� ���� ���輱��������',
  '�� 3�ڿ��� �㺸�� �������� �ʾ����� Ȯ���ϸ�,',
  '���� ������ ���鵿��', 116 SY-VLINE.
  WRITE:/ SY-VLINE,6'���� �̸� �㺸�� ��������',
  '�ʰڽ��ϴ�.', 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,'4. ������ �� ����ȭ���� ���� ���� ����������',
  '������ ������ �ſ������ǰ��� ����ġ �� ��� ��ῡ�� �ұ��ϰ� ',
  116 SY-VLINE.
  WRITE:/ SY-VLINE,6'�� ������ �ݵ�� �μ��ϰڽ��ϴ�. ',
  116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  ULINE AT 100(11).
  WRITE:/ SY-VLINE, 100 SY-VLINE,103'�ΰ���',110 SY-VLINE,116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  ULINE AT 100(11).
  WRITE:/ SY-VLINE,50 '��', 65 '��', 80 '��',
  100 SY-VLINE,110 SY-VLINE,116 SY-VLINE.
  WRITE:/ SY-VLINE,6 '��û��:',17 ZTLG-ZFELENM,
  100 SY-VLINE,110 SY-VLINE,116 SY-VLINE.
  DATA: W_ADD(70) TYPE C.
  CONCATENATE: ZTLG-ZFAPPAD1 ZTLG-ZFAPPAD2
               ZTLG-ZFAPPAD3 INTO W_ADD  SEPARATED BY SPACE.

  WRITE:/ SY-VLINE,6 '��  ��:',17 W_ADD NO-GAP,
  100 SY-VLINE,110 SY-VLINE,116 SY-VLINE.
  ULINE AT 100(11).
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  ULINE AT 70(41).
  WRITE:/ SY-VLINE, 25 '��',70 SY-VLINE,73'�߱޹�ȣ',83 SY-VLINE,
  110 SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  ULINE AT 6(22).
  ULINE AT 70(41).
  WRITE:/ SY-VLINE, 116 SY-VLINE.

  WRITE:/ SY-VLINE, 6'��� ��û����� ���� ����ȭ���� �ε��� ����',
  '�³��մϴ�.',116 SY-VLINE.

  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,50 '��', 65 '��', 80 '��',
  116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  DATA: W_ZFISBNM(45) TYPE C.
  CONCATENATE ZTLG-ZFISBNM ' ' INTO W_ZFISBNM.
  WRITE:/ SY-VLINE,3 W_ZFISBNM RIGHT-JUSTIFIED,
  50'�� �� ��', 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE,55'(IL���� �ΰ��� ����)', 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-VLINE, 116 SY-VLINE.
  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE_AIR
