*&---------------------------------------------------------------------*
*& Report  ZRIMTTREQ                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���޽�û��                                            *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.07.16                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :  ���޽�û��                                           *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMTTREQ    MESSAGE-ID ZIM
                     LINE-SIZE 116
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* ���������� �ʰ�, ���̺��� ���� ó��....
*-----------------------------------------------------------------------
DATA : W_ERR_CHK,
       W_DOM_SENDTY(20),
       W_DOM_CFRG(40),
       W_AMOUNT(30),
       W_OBNM(80),
       W_APPAD(80),
       W_APPNM(110),
       W_ZFOBNM(80).

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
TABLES : ZTREQHD, ZTREQST, ZTCIVHD, ZTTTHD, ZTIMIMGTX.
      "�����Ƿ� HEADER, �����Ƿ�ǰ��, �����Ƿڻ���, �������ü� HEADER

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

   PARAMETERS    : P_CIVRN LIKE ZTCIVHD-ZFCIVRN. "���������ȣ.

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
    PERFORM   P1000_GET_DATA           USING W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.
      MESSAGE S966.  EXIT.
    ENDIF.
* ����Ʈ Write
    PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'TTREQ'.          " TITLE BAR

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

  SET PF-STATUS 'TTREQ'.           " GUI STATUS SETTING
  SET  TITLEBAR 'TTREQ'.           " GUI TITLE SETTING..
  PERFORM P3000_LINE_WRITE.

ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDSENDTY' ZTTTHD-ZFSENDTY
                                    CHANGING   W_DOM_SENDTY.

  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCFRG1' ZTTTHD-ZFCFRG
                                    CHANGING   W_DOM_CFRG.

  WRITE: ZTTTHD-ZFAMT CURRENCY ZTTTHD-WAERS TO W_AMOUNT LEFT-JUSTIFIED.
  CONCATENATE ZTTTHD-WAERS W_AMOUNT INTO W_AMOUNT SEPARATED BY SPACE.

  WRITE: '��û��:' TO W_APPNM.
  CONCATENATE W_APPNM ZTIMIMGTX-ZFAPPNM INTO W_APPNM SEPARATED BY SPACE.
  CONCATENATE W_APPNM '(�� �Ǵ� ����)' INTO W_APPNM SEPARATED BY SPACE.
  WRITE: W_APPNM TO W_APPNM RIGHT-JUSTIFIED.

  WRITE: ZTTTHD-ZFOBNM TO W_OBNM.
  CONCATENATE W_OBNM '������' INTO W_OBNM SEPARATED BY SPACE.
  WRITE: W_OBNM TO W_OBNM RIGHT-JUSTIFIED.

  WRITE: ZTTTHD-ZFAPPAD1 TO W_APPAD LEFT-JUSTIFIED.       "�ּ�
  CONCATENATE W_APPAD ZTTTHD-ZFAPPAD2 INTO W_APPAD SEPARATED BY SPACE.
  WRITE: W_APPAD TO W_APPAD LEFT-JUSTIFIED.
  CONCATENATE W_APPAD ZTTTHD-ZFAPPAD3 INTO W_APPAD SEPARATED BY SPACE.
  WRITE: W_APPAD TO W_APPAD LEFT-JUSTIFIED.

  SKIP 4.
*  WRITE:/ SY-ULINE+(30), 67 SY-ULINE,
*        / SY-VLINE,'FILE NO:', ZTREQHD-EBELN, 30 SY-VLINE,
*          67 SY-VLINE,
*          73 SY-VLINE, '  ��  ��',
*          88 SY-VLINE, '  ��  �',
*          103 SY-VLINE,'  ��  ��', 116 SY-VLINE,
*        / SY-ULINE+(30), 67 SY-VLINE, '̽', 73 SY-ULINE,
*        /67 SY-VLINE, 73 SY-VLINE, 88 SY-VLINE, 103 SY-VLINE,
*         116 SY-VLINE,
*        /67 SY-VLINE, '�', 73 SY-VLINE, 88 SY-VLINE,
*         103 SY-VLINE, 116 SY-VLINE,
*        /67 SY-VLINE, 73 SY-VLINE, 88 SY-VLINE, 103 SY-VLINE,
*         116 SY-VLINE,
*        /67 SY-ULINE.

  WRITE:/ '<��ħ���� ��3-1ȣ>',
        /, /(116) '�� �� �� û ��' CENTERED,
        /, /(116) '[�ŷ��ܱ�ȯ��������(����)��û�� ���]' CENTERED.

  WRITE:/ SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, '��  ȣ  �Ǵ�  ��  ��', 30 SY-VLINE,
          '��   ��  (KOREA)', 50 SY-VLINE, ZTIMIMGTX-ZFAPPNM,
          116 SY-VLINE,
        / SY-VLINE, '��', 6 SY-VLINE, 50 SY-VLINE,
          30 SY-ULINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '    (Applicant)',  30 SY-VLINE,
          '��   ��  (ENGLISH)', 50 SY-VLINE, ZTIMIMGTX-ZFAPPNML,
          116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,  50 SY-VLINE,
          6 SY-ULINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '��        ��        ��',  30 SY-VLINE,
          '�����  ��� ��ȣ', 50 SY-VLINE, ZTIMIMGTX-ZFELTXN,
          116 SY-VLINE,
        / SY-VLINE, 'û', 6 SY-VLINE, 30 SY-VLINE,
          6 SY-ULINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '��        ��        ��', 30 SY-VLINE,
          '�� �� �� �� �� ȣ', 50 SY-VLINE,
          116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
          6 SY-ULINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '�� �� �� (�� �� �� ��)', 30 SY-VLINE,
          '��   ��   ��   ȣ', 50 SY-VLINE,
          116 SY-VLINE,
        / SY-VLINE, '��', 6 SY-VLINE, 30 SY-VLINE,
          6 SY-ULINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '��                  ��', 30 SY-VLINE,
          W_APPAD, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
          '                                                  ',
          ' (Tel)', ZTTTHD-ZFTELNO,
          116 SY-VLINE, SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, 6 SY-VLINE, ' �� �� �� �� (Send By)', 30 SY-VLINE,
          W_DOM_SENDTY, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 6 SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, ' ��   ��   �� (Amount)', 30 SY-VLINE,
          W_AMOUNT, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 6 SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, '��       �� (Name)',
          50 SY-VLINE, ZTTTHD-ZFBENI1, 85 SY-VLINE,
          '��û�ΰ��� ����',105 SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-ULINE, 30 SY-VLINE,
        / SY-VLINE, '��', 6 SY-VLINE, '��        ��        ��',
          30 SY-VLINE, '��      ��(Address)', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, ZTTTHD-ZFBENI2,
          116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, ZTTTHD-ZFBENI3,
          116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, 116 SY-VLINE,
          30 SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
          '��             ��', 50 SY-VLINE, ZTREQHD-ZFSHCU,
          116 SY-VLINE,
        / SY-VLINE, 'û', 6 SY-VLINE, 30 SY-VLINE,
          116 SY-VLINE, 6 SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
          '������ּ�(Bank Name & Address)', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '�� �� �� �� �� �� ��', 30 SY-VLINE,
          ZTTTHD-ZFOBNM, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '  (BNF''S BANK)', 30 SY-VLINE,
          ZTTTHD-ZFOBBR, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, 30 SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
          '�����ΰ��¹�ȣ(BNF''S A/C No)', 65 SY-VLINE,
          ZTTTHD-ZFOBAK1, 116 SY-VLINE,
        / SY-VLINE, '��', 6 SY-VLINE, 30 SY-VLINE, 60 SY-VLINE,
          6 SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, 6 SY-VLINE, '��    ��    ��    ��', 30 SY-VLINE,
          50 SY-VLINE, ' ���ܼ�����δ�(Charge)', 75 SY-VLINE,
          W_DOM_CFRG, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE,
*-----------------------------------------------------------------------
          50 SY-VLINE, 75 SY-VLINE, 116 SY-VLINE, 6 SY-ULINE,
        / SY-VLINE, 6 SY-VLINE, '���Դ��(��ȭ 2����',
          30 SY-VLINE, ' ǰ�� (H.S. Code)', 50 SY-VLINE,
          '        L/C or ��༭ No.', 85 SY-VLINE,
          '      �������Կ�����', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, 50 SY-VLINE,
          85 SY-VLINE, 116 SY-VLINE, 30 SY-ULINE,
        / SY-VLINE, '��', 6 SY-VLINE, '�ʰ�)�� ������', 30 SY-VLINE,
          50 SY-VLINE, ZTREQHD-EBELN, 85 SY-VLINE, '����:       ',
          '����:      ', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, 50 SY-VLINE,
          85 SY-VLINE, 116 SY-VLINE, 6 SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, '�� �� �� ��:',
           '                    ', 'ü �� ��:', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, '�� �� �� �� �� �� ��',
          30 SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, '����������:',
          '                     ', '��Ÿ���:', 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE,  '   �� �� �� �� �� ��',
          30 SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, '�ؿ����ֺ�:',
          116 SY-VLINE, SY-ULINE,
*        / SY-VLINE, 6 SY-VLINE, 30 SY-VLINE, 116 SY-VLINE, SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, ' �� ������ �������� �Ǵ� ��ȭ 5õ������',
          '�Ҿװ�������� ���� �ŷ��ܱ�ȯ�������� �����ϰ��� �մϴ�.',
          116 SY-VLINE,
        / SY-VLINE, '     (�Ǹ�Ȯ����ǥ�� ���Ͽ� �Ǹ�Ȯ���� �� ����',
         '��ܿ� �Ǹ�Ȯ������ ������ ��)', 116 SY-VLINE,
        / SY-VLINE, ' �� ������ ���� �������� ��ġ�� ��ȯ�ŷ�',
          '�⺻����� �˶��ϰ� �� ���뿡 ���� ���� Ȯ���ϸ� ',
          '���Ͱ���', 116 SY-VLINE,
        / SY-VLINE, '     ���޽�û�մϴ�.', 116 SY-VLINE,
        / SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, W_APPNM, 116 SY-VLINE, SY-ULINE,
*-----------------------------------------------------------------------
        / SY-VLINE, '�� ��û���� �ܱ�ȯ����ڷ�� Ȱ���ϸ� ',
          '�����ڷ�� ����û�� �뺸�� �� �ֽ��ϴ�.',
          116 SY-VLINE, SY-ULINE,
        / SY-VLINE, '�� ����� Ȯ����', 70 SY-VLINE,
          '�� �� Ȯ �� �� ȣ', 90 SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, 70 SY-VLINE, 90 SY-VLINE, 116 SY-VLINE, 70 SY-ULINE,
        / SY-VLINE, 70 SY-VLINE, '��   ��   ��   ��',
          90 SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, 70 SY-VLINE, 90 SY-VLINE, 116 SY-VLINE, 70 SY-ULINE,
        / SY-VLINE, '                                    ',
          '                                             ',
          '��           ��           ��', 116 SY-VLINE,
        / SY-VLINE, 116 SY-VLINE,
        / SY-VLINE, '     ', W_OBNM,
          '                  (��)', 116 SY-VLINE,
        / SY-ULINE,
        / '�� �ſ�ī�� �Ǵ� ����ī�忡 ���Ͽ� �����ϰ���',
          ' �ϴ� ��쿡�� ���� ǥ���� ��'.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_DATA
*&---------------------------------------------------------------------*
FORM P1000_GET_DATA USING W_ERR_CHK.

   W_ERR_CHK = 'N'.
*>>HEADER �б�
*   CLEAR ZTREQHD.
*   SELECT SINGLE *
*     FROM ZTREQHD
*    WHERE ZFREQNO =  P_REQNO.
*>> ����ó���÷� ���� 020619
   SELECT SINGLE * FROM ZTCIVHD WHERE ZFCIVRN = P_CIVRN.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.

*   CLEAR ZTREQST.
*   SELECT SINGLE *
*     FROM ZTREQST
*    WHERE ZFREQNO =  P_REQNO
*      AND ZFAMDNO =  P_AMDNO.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.
*>> IMG �б�
   CLEAR ZTIMIMGTX.
   SELECT SINGLE *
     FROM ZTIMIMGTX
    WHERE BUKRS =  ZTCIVHD-BUKRS.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.

*>>�������ü� HEADER �б�
   CLEAR ZTTTHD.
   SELECT SINGLE *
     FROM ZTTTHD
    WHERE ZFCIVRN =  P_CIVRN.
*>>�۱ݹ��, ������ �δ�
   "IF ZTTTHD-ZFSENDTY EQ

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.

ENDFORM.                    " P1100_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_DD07T_SELECT
*&---------------------------------------------------------------------*
*FORM GET_DD07T_SELECT USING    P_DOMNAME
*                               P_FIELD
*                      CHANGING P_W_NAME.
*  CLEAR : DD07T, P_W_NAME.
*  IF P_FIELD IS INITIAL.   EXIT.   ENDIF.
*
*  SELECT * FROM DD07T WHERE DOMNAME     EQ P_DOMNAME
*                      AND   DDLANGUAGE  EQ SY-LANGU
*                      AND   AS4LOCAL    EQ 'A'
*                      AND   DOMVALUE_L  EQ P_FIELD
*                      ORDER BY AS4VERS DESCENDING.
*    EXIT.
*  ENDSELECT.
*   TRANSLATE DD07T-DDTEXT TO UPPER CASE.
*  P_W_NAME   = DD07T-DDTEXT.
*  TRANSLATE P_W_NAME TO UPPER CASE.
*ENDFORM.                    " GET_DD07T_SELECT
