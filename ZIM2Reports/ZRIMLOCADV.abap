*&--------------------------------------------------------------------*
*& Report  ZRIMLOCADV                                                 *
*&--------------------------------------------------------------------*
*&  ���α׷��� : �����ſ��� ������(Local Credit Advice)               *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.                                 *
*&      �ۼ��� : 2001.07.24                                           *
*&--------------------------------------------------------------------*
*&   DESC.     :  �����ſ��� ������.                                  *
*&--------------------------------------------------------------------*
*& [���泻��]
*&
*&--------------------------------------------------------------------*
REPORT  ZRIMLOCADV   MESSAGE-ID ZIM
                     LINE-SIZE 115
                     NO STANDARD PAGE HEADING.

*----------------------------------------------------------------------
* Tables �� ���� Define
*----------------------------------------------------------------------
TABLES : ZTLLCHD,ZTREQHD, ZTREQST, ZTLLCSG23, ZTLLCOF, DD07T, ZTDHF1.

*----------------------------------------------------------------------
* ������û ���� TABLE
*----------------------------------------------------------------------
DATA : W_ERR_CHK(1),
       W_DOM_TEX1 LIKE DD07T-DDTEXT,
       W_DOM_TEX2 LIKE DD07T-DDTEXT,
       W_FDOCNOR  LIKE ZTREQST-ZFDOCNOR.

DATA : W_INX TYPE I,
       W_USD(30),
       W_KRW(30),
       W_TEM TYPE STRING.

DATA : BEGIN  OF   IT_ZTMLOCAPP_1 OCCURS 100,      "��ǰ�ŵ�Ȯ�༭ IT
          ZFREQNO  LIKE ZTLLCOF-ZFREQNO,           "�����Ƿ� ������ȣ
          ZFLSGOF  LIKE ZTLLCOF-ZFLSGOF,           "�ݺ���
          ZFOFFER  LIKE ZTLLCOF-ZFOFFER,           "��ǰ�ŵ�Ȯ�༭��ȣ
END OF IT_ZTMLOCAPP_1.

DATA: BEGIN OF IT_ZTMLOCAPP_2 OCCURS 200,       "�ֿ䱸�񼭷� IT
      ZDOC TYPE STRING,
      ZDOCNO TYPE I,
END OF IT_ZTMLOCAPP_2.

*----------------------------------------------------------------------
* SELECTION SCREEN ��.
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   PARAMETERS    : P_REQNO   LIKE ZTLLCHD-ZFREQNO.
                   "MEMORY ID  ZPREQNO.
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

*>>�����Ƿ� ����(Status)
     CLEAR ZTREQST.
     SELECT SINGLE * FROM ZTREQST
            WHERE ZFREQNO = P_REQNO
            AND ZFAMDNO = '0'.

     IF SY-SUBRC NE 0.
         P_W_ERR_CHK = 'Y'.
     ENDIF.
     CLEAR ZTREQHD.
     SELECT SINGLE * FROM ZTREQHD
         WHERE ZFREQNO = P_REQNO.
*>>Local L/C Header
     SELECT SINGLE * FROM ZTLLCHD
            WHERE ZFREQNO = P_REQNO.

*>> ǥ�� EDI FLAT FILE.
     SELECT SINGLE * FROM ZTDHF1
            WHERE ZFDHENO = ZTREQST-ZFDOCNO.

*>>Local L/C Seg 2 - 3
     SELECT SINGLE * FROM ZTLLCSG23
            WHERE ZFREQNO = ZTLLCHD-ZFREQNO.

*>> LOCAL L/C ��ǰ�ŵ�Ȯ�༭.
     CLEAR IT_ZTMLOCAPP_1.
     REFRESH IT_ZTMLOCAPP_1.

     SELECT * FROM ZTLLCOF
              WHERE ZFREQNO = ZTLLCHD-ZFREQNO.

     IT_ZTMLOCAPP_1-ZFREQNO = ZTLLCOF-ZFREQNO.
                 " �����Ƿ� ������ȣ.
     IT_ZTMLOCAPP_1-ZFLSGOF = ZTLLCOF-ZFLSGOF.
                 " �ݺ��� ��ǰ�ŵ�Ȯ�༭��ȣ.
     IT_ZTMLOCAPP_1-ZFOFFER = ZTLLCOF-ZFOFFER.
                 " ��ǰ�ŵ�Ȯ�༭ ��ȣ.

     APPEND IT_ZTMLOCAPP_1.
     CLEAR IT_ZTMLOCAPP_1.
     ENDSELECT.

ENDFORM.                    " P1000_GET_DATA

*&--------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&--------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
    SET  TITLEBAR 'LOCADV'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER

*&--------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&--------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.
    SET PF-STATUS 'LOCADV'.           " GUI STATUS SETTING
    SET  TITLEBAR 'LOCADV'.           " GUI TITLE SETTING..
    PERFORM P3000_LINE_WRITE.
ENDFORM.                    " P3000_DATA_WRITE

*&--------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&--------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
    SKIP 2.
    WRITE:/ '<���� ��8-6ȣ ����>',
          /45  '��ҺҴɳ����ſ���'.
    SKIP 1.
    WRITE:/4 '���ڹ�����ȣ :',
             20 W_FDOCNOR,
             85 '�������� : ', ZTDHF1-ZFDHSSD.
    SKIP 1.
    ULINE AT /1(48). WRITE: '< ���� ���� >'. ULINE AT 64(115).

* DOMAIN(�����ſ�������).-------------------------------------------
  CLEAR: W_DOM_TEX1,W_DOM_TEX2.
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDLLCTY' ZTLLCHD-ZFLLCTY
                                       CHANGING   W_DOM_TEX1.
*--------------------------------------------------------------------
    CLEAR W_TEM.
    W_TEM = ZTLLCHD-ZFOPBNCD.
    CONCATENATE W_TEM ZTLLCHD-ZFOBNM INTO W_TEM SEPARATED BY SPACE.
    CONCATENATE W_TEM ZTLLCHD-ZFOBBR INTO W_TEM SEPARATED BY SPACE.

    WRITE:/4 '��������',     25 ':', 27 W_TEM.
    WRITE:/4 '��������',     25 ':', 27 ZTREQST-ZFOPNDT,
          /4 '�ſ����ȣ',   25 ':', 27 ZTREQST-ZFOPNNO."ZTLLCHD-ZFDCNO.

*>> �����Ƿ���.
    CLEAR W_TEM.
    W_TEM = ZTLLCSG23-ZFAPPNM1.

    IF NOT ZTLLCSG23-ZFAPPNM2 IS INITIAL.
        CONCATENATE  W_TEM ZTLLCSG23-ZFAPPNM2 INTO W_TEM
                     SEPARATED BY SPACE.
    ENDIF.
    IF NOT ZTLLCSG23-ZFAPPNM3 IS INITIAL.
        CONCATENATE W_TEM ZTLLCSG23-ZFAPPNM3 INTO W_TEM
                    SEPARATED BY SPACE.
    ENDIF.
    WRITE:/4 '�����Ƿ��� (��ȣ, �ּ�, ��ǥ��, ��ȭ)',
          43 ':', 45 W_TEM.
*>> ������.
    CLEAR W_TEM.
    W_TEM = ZTLLCSG23-ZFBENI1.

    IF NOT ZTLLCSG23-ZFBENI2 IS INITIAL.
        CONCATENATE W_TEM ZTLLCSG23-ZFBENI2 INTO W_TEM
                    SEPARATED BY SPACE.
    ENDIF.

    IF NOT ZTLLCSG23-ZFBENI3 IS INITIAL.
        CONCATENATE W_TEM ZTLLCSG23-ZFBENI3 INTO W_TEM
                    SEPARATED BY SPACE.
    ENDIF.
*>> ������ȭ�ݾ�
    CLEAR W_USD.
    WRITE: ZTLLCHD-ZFOPAMT CURRENCY ZTLLCHD-ZFOPAMTC
                             TO W_USD LEFT-JUSTIFIED.
    CONCATENATE ZTLLCHD-ZFOPAMTC W_USD INTO W_USD
                SEPARATED BY SPACE.

    WRITE:/4 '��  ��  �� (��ȣ, �ּ�, ��ǥ��, ��ȭ)',
          43 ':', 45 W_TEM,
          /4 '�����ſ��� ����', 25 ':', 27 W_DOM_TEX1,
          /4 '������ȭ�ݾ�',    25 ':', 27 W_USD.
*>> ������ȭ�ݾ�
     CLEAR W_KRW.
     WRITE: ZTLLCHD-ZFOPKAM CURRENCY ZTLLCHD-ZFKRW
                           TO W_KRW LEFT-JUSTIFIED.
     CONCATENATE ZTLLCHD-ZFKRW W_KRW INTO W_KRW
                 SEPARATED BY SPACE.

     WRITE :/4 '������ȭ�ݾ�', 25 ':', 27 W_KRW,
            /4 '�Ÿű�����',   25 ':', 27 ZTREQHD-KURSF."ZTLLCHD-ZFEXRT.

     W_INX = 1.

     LOOP AT IT_ZTMLOCAPP_1.
        AT FIRST.
            WRITE:/4 '��ǰ�ŵ�Ȯ�༭��ȣ', 25 ':'.
        ENDAT.

        IF W_INX = 1.
            WRITE: 27 IT_ZTMLOCAPP_1-ZFOFFER.
        ELSE.
            WRITE:/27 IT_ZTMLOCAPP_1-ZFOFFER.
        ENDIF.

        W_INX = W_INX + 1.
     ENDLOOP.

     WRITE:/4 '��ǰ�ε�����', 25 ':', 27 ZTLLCHD-ZFGDDT,
           /4 '��ȿ����',     25 ':', 27 ZTLLCHD-ZFEXDT.
*>> �ֿ䱸�񼭷�.
     W_INX = 1.
     LOOP AT  IT_ZTMLOCAPP_2.
        AT FIRST.
            WRITE:/4 '�ֿ� ���񼭷�', 25 ':'.
        ENDAT.

        IF W_INX EQ 1.
            WRITE:27 IT_ZTMLOCAPP_2-ZDOC,
                  60 IT_ZTMLOCAPP_2-ZDOCNO,
                  71 '��'.
        ELSE.
            WRITE:/27 IT_ZTMLOCAPP_2-ZDOC,
                   60 IT_ZTMLOCAPP_2-ZDOCNO,
                   71 '��'.
        ENDIF.

        W_INX = W_INX + 1.
     ENDLOOP.

     CLEAR IT_ZTMLOCAPP_2.
     REFRESH IT_ZTMLOCAPP_2.
*>> ��Ÿ���񼭷�.
     IF NOT ( ZTLLCSG23-ZFEDOC1 IS INITIAL
             AND ZTLLCSG23-ZFEDOC2 IS INITIAL
             AND ZTLLCSG23-ZFEDOC3 IS INITIAL
             AND ZTLLCSG23-ZFEDOC4 IS INITIAL
             AND ZTLLCSG23-ZFEDOC5 IS INITIAL ).
      WRITE:/4 '��Ÿ ���񼭷�', 25 ':'.
        IF NOT ZTLLCSG23-ZFEDOC1 IS INITIAL.
               WRITE: 27 ZTLLCSG23-ZFEDOC1.
        ENDIF.
        IF NOT ZTLLCSG23-ZFEDOC2 IS INITIAL.
               WRITE:/27 ZTLLCSG23-ZFEDOC2.
        ENDIF.
        IF NOT ZTLLCSG23-ZFEDOC3 IS INITIAL.
               WRITE:/27 ZTLLCSG23-ZFEDOC3.
        ENDIF.
        IF NOT ZTLLCSG23-ZFEDOC4 IS INITIAL.
               WRITE:/27 ZTLLCSG23-ZFEDOC4.
        ENDIF.
        IF NOT ZTLLCSG23-ZFEDOC5 IS INITIAL.
               WRITE:/27 ZTLLCSG23-ZFEDOC5.
        ENDIF.
     ENDIF.

     WRITE:/ SY-ULINE,
           / SY-VLINE, '������ ����(��)�� �� �ݾ��� ���������� �����',
             ' ������ ÷���Ͽ� ������ ������ҷ� �ϰ� �����Ƿ�����',
             ' ���������� ', 115 SY-VLINE,
           / SY-VLINE, '�� ��ǰ��������� �϶����ȯ������ ������',
             ' �� �ִ� ��ҺҴɳ����ſ����� �����մϴ�.',
             '������ �� �ſ��忡 ���Ͽ�', 115 SY-VLINE,
           / SY-VLINE, '����ǰ� ���� �� �ſ����� ���ǿ�',
             ' ��ġ�ϴ� ȯ������ ���࿡ ���õ� ������ �̸� ���Ǿ���',
             '������ ���� ȯ������', 115 SY-VLINE,
           / SY-VLINE, '������, �輭��, ��Ÿ',
             ' ������ �����ο��� Ȯ���մϴ�.', 115 SY-VLINE, SY-ULINE.

     IF NOT ( ZTLLCHD-ZFGDSC1 IS INITIAL
             AND ZTLLCHD-ZFGDSC2 IS INITIAL
             AND ZTLLCHD-ZFGDSC3 IS INITIAL
             AND ZTLLCHD-ZFGDSC4 IS INITIAL
             AND ZTLLCHD-ZFGDSC5 IS INITIAL ).
        WRITE:/4 '��ǥ���޹�ǰ��', 25 ':'.
        IF NOT ZTLLCHD-ZFGDSC1 IS INITIAL.
               WRITE:27 ZTLLCHD-ZFGDSC1.
        ENDIF.
        IF NOT ZTLLCHD-ZFGDSC2 IS INITIAL.
               WRITE:/27 ZTLLCHD-ZFGDSC2.
        ENDIF.
        IF NOT ZTLLCHD-ZFGDSC3 IS INITIAL.
               WRITE:/27 ZTLLCHD-ZFGDSC3.
        ENDIF.
        IF NOT ZTLLCHD-ZFGDSC4 IS INITIAL.
               WRITE:/27 ZTLLCHD-ZFGDSC4.
        ENDIF.
        IF NOT ZTLLCHD-ZFGDSC5 IS INITIAL.
               WRITE:/27 ZTLLCHD-ZFGDSC5.
        ENDIF.
     ENDIF.
* DOMAIN(�����ε���뿩��, �����ٰź��뵵)-----------------------------
    CLEAR: W_DOM_TEX1,W_DOM_TEX2.
    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDPRAL' ZTLLCHD-ZFPRAL
                                         CHANGING   W_DOM_TEX1.
    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDUSG' ZTLLCHD-ZFUSG
                                         CHANGING   W_DOM_TEX2.
*----------------------------------------------------------------------
     WRITE: /4 '�����ε� ��뿩��',   25 ':',  27 W_DOM_TEX1,
            /4 '�������ñⰣ',        25 ':',
            27 '��ǰ�������� �߱��Ϸκ���',
                ZTLLCHD-ZFDPRP, '������ �̳�',
            /4 '�����ٰź� �뵵',     25 ':',  27 W_DOM_TEX2,
            /4 '��       Ÿ',         25 ':',  27 ZTLLCHD-ZFOPCNT,
               '�� �����ſ���'.

* DOMAIN(�����ٰż���)---------------------------------------------
  CLEAR: W_DOM_TEX1.
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDOPRED' ZTLLCHD-ZFOPRED
                                       CHANGING   W_DOM_TEX1.
*------------------------------------------------------------------
    IF NOT W_DOM_TEX1 IS INITIAL
       OR NOT ZTLLCHD-ZFDCNO IS INITIAL
       OR NOT ZTLLCHD-ZFDCAMT IS INITIAL
       OR NOT ZTLLCHD-ZFDEDT IS INITIAL
       OR NOT ZTLLCHD-ZFDEXDT IS INITIAL
       OR NOT ZTLLCHD-ZFEXPR1 IS INITIAL
       OR NOT ZTLLCHD-ZFEXPR2 IS INITIAL
       OR NOT ZTLLCHD-ZFEXPR3 IS INITIAL
       OR NOT ZTLLCHD-ZFEXAR IS INITIAL
       OR NOT ZTLLCHD-ZFISBN IS INITIAL
       OR NOT ZTLLCHD-ZFISBNB IS INITIAL
       OR NOT ZTLLCHD-ZFTOP IS INITIAL
       OR NOT ZTLLCHD-ZFEXGNM1 IS INITIAL
       OR NOT ZTLLCHD-ZFEXGNM2 IS INITIAL
       OR NOT ZTLLCHD-ZFEXGNM3 IS INITIAL
       OR NOT ZTLLCHD-ZFEXGNM4 IS INITIAL
       OR NOT ZTLLCHD-ZFEXGNM5 IS INITIAL.

        SKIP 1.
        ULINE AT /1(45).
        WRITE: '< ������ſ��� �� ���� >'.
        ULINE AT 72(115).
        SKIP 1.
    ENDIF.

    IF NOT W_DOM_TEX1 IS INITIAL.
        WRITE:/4 '�����ٰż��� ����',    25 ':', 27 W_DOM_TEX1.
    ENDIF.

    IF NOT ZTLLCHD-ZFDCNO IS INITIAL.
        WRITE:/4 '�ſ���(��༭)��ȣ',   25 ':', 27 ZTLLCHD-ZFDCNO.
    ENDIF.

    SKIP 1.
    ULINE AT /1(45).
    WRITE: '< �߽ű�� ���ڼ��� >'.
    ULINE AT 69(115).
    SKIP 1.
    WRITE:/4 '�߽ű�� ���ڼ���', 25 ':', 27 ZTLLCHD-ZFOBNM,
                                         /27 ZTLLCHD-ZFOBBR,
                                         /27 ZTLLCHD-ZFOPBN.

    SKIP 1.
    WRITE:/ SY-ULINE,
          / SY-VLINE, '1. �� ���� ������ ���������� �ڵ�ȭ������',
            ' ���� �������� �ǰ� ����� ���ڹ�����ȯ���',
            ' �����ſ������μ�', 115 SY-VLINE,
          / SY-VLINE, '�� ������ ���۹��� �����Ƿ��� �Ǵ� �����ڴ�',
            '�� ���� ������� ��12���� ��ǥ2(������������',
            ' ���� Ư��)', 115 SY-VLINE,
          / SY-VLINE, '��7������ ���� �ٿ� ���� �ſ��� ���鿡',
            ' ����߱޹������� ǥ���ϴ� ���� ������ �����Ͽ���',
            '�մϴ�.', 115 SY-VLINE,
          / SY-VLINE, '2. �� �ſ��忡 ���� ������ �ٸ� Ư����',
            '������ ���� �� �������ȸ�Ǽ����� ȭȯ�ſ������ϱ�Ģ',
            ' �� ���ʿ� �����ϴ�.', 115 SY-VLINE NO-GAP, SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE
