*&---------------------------------------------------------------------*
*& Report  ZRIMLOCAMR                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ��ҺҴɳ����ſ��尳����û��(Local Credit Application)*
*&      �ۼ��� : �迵�� LG-EDS                                         *
*&      �ۼ��� : 2001.07.11                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :  ��ҺҴɳ����ſ������Ǻ����û��.                    *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMLOCAMR   MESSAGE-ID ZIM
                     LINE-SIZE 115
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
TABLES : ZTREQST, ZTLLCHD, ZTLLCAMHD, ZTLLCSG23, ZTLLCAMSGOF, DD07T.

*-----------------------------------------------------------------------
* ������û ���� TABLE
*-----------------------------------------------------------------------
DATA : W_ERR_CHK(1),
       W_DOM_TEX1 LIKE DD07T-DDTEXT,
       W_DOM_TEX2 LIKE DD07T-DDTEXT,
       W_FOPNNO LIKE ZTREQST-ZFOPNNO,
       W_FAPPDT LIKE ZTREQST-ZFAPPDT,
       W_FDOCNO LIKE ZTREQST-ZFDOCNO,
       W_INX TYPE I,
       W_TEM TYPE STRING.

DATA : BEGIN  OF    IT_ZTMLOCAMR_1 OCCURS 100,    "��ǰ�ŵ�Ȯ�༭ IT
       ZFREQNO  LIKE ZTLLCAMSGOF-ZFREQNO,           "�����Ƿ� ������ȣ
       ZFLSGOF  LIKE ZTLLCAMSGOF-ZFLSGOF,           "�ݺ���
       ZFSGOF   LIKE ZTLLCAMSGOF-ZFSGOF,            "��ǰ�ŵ�Ȯ�༭��ȣ
END OF IT_ZTMLOCAMR_1.

*---------------------------------------------------------------------
* SELECTION SCREEN ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   PARAMETERS    : P_REQNO   LIKE ZTLLCHD-ZFREQNO,
                   "MEMORY ID  ZPREQNO.
                   P_AMDNO   LIKE ZTLLCAMHD-ZFAMDNO.
SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                                    " �ʱⰪ SETTING
    PERFORM   P2000_SET_PARAMETER.

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
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

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P1000_GET_DATA USING    P_W_ERR_CHK.
     SELECT SINGLE *
       FROM ZTLLCAMHD
      WHERE ZFREQNO = P_REQNO
        AND ZFAMDNO = P_AMDNO.

     IF SY-SUBRC NE 0.
         P_W_ERR_CHK = 'Y'.
     ENDIF.

     SELECT SINGLE *
       FROM ZTLLCHD
      WHERE ZFREQNO = P_REQNO.

     SELECT SINGLE *
       FROM ZTLLCSG23
      WHERE ZFREQNO = P_REQNO.

     SELECT SINGLE ZFOPNNO ZFAPPDT ZFDOCNO
       INTO (W_FOPNNO, W_FAPPDT, W_FDOCNO)
       FROM ZTREQST
      WHERE ZFREQNO = P_REQNO
        AND ZFAMDNO = P_AMDNO.


     CLEAR IT_ZTMLOCAMR_1.
     REFRESH IT_ZTMLOCAMR_1.

     SELECT *
       FROM ZTLLCAMSGOF
      WHERE ZFREQNO = P_REQNO
        AND ZFAMDNO = P_AMDNO.

     IT_ZTMLOCAMR_1-ZFREQNO = ZTLLCAMSGOF-ZFREQNO.
     IT_ZTMLOCAMR_1-ZFLSGOF = ZTLLCAMSGOF-ZFLSGOF.
     IT_ZTMLOCAMR_1-ZFSGOF = ZTLLCAMSGOF-ZFSGOF.

     APPEND IT_ZTMLOCAMR_1.
     CLEAR IT_ZTMLOCAMR_1.

     ENDSELECT.

ENDFORM.                    " P1000_GET_DATA

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
    SET  TITLEBAR 'LOCAMR'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.
    SET PF-STATUS 'LOCAMR'.           " GUI STATUS SETTING
    SET  TITLEBAR 'LOCAMR'.           " GUI TITLE SETTING..
    PERFORM P3000_LINE_WRITE.
ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
    SKIP 2.
    WRITE:/45  TEXT-002,         "��ҺҴɳ����ſ������Ǻ����û��
          /43  TEXT-003.         "(Local Credit Amendment Application)
    SKIP 1.
    WRITE:/ SY-ULINE,
          / SY-VLINE,4 TEXT-004, 115 SY-VLINE,
          / SY-VLINE,4 TEXT-005, 115 SY-VLINE.
    WRITE:/ SY-ULINE.
    SKIP 2.
    WRITE:/4 '���ڹ��� ��ȣ',  26 ':',
             28 W_FDOCNO,
             84 '���Ǻ����û���� : ', 103 W_FAPPDT.

    SKIP 2.
    ULINE AT /1(47). WRITE: '< ���Ǻ����û ���� >'. ULINE AT 70(115).
    SKIP 1.

* DOMAIN.-----------------------------------------------------------
    CLEAR: W_DOM_TEX1.
    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDLLCTY' ZTLLCHD-ZFLLCTY
                                    CHANGING   W_DOM_TEX1.
*--------------------------------------------------------------------

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

    WRITE:/4 '�����Ƿ���',         26 ':', 28 W_TEM.


    CLEAR W_TEM.
    W_TEM = ZTLLCAMHD-ZFBENI1.

    IF NOT ZTLLCAMHD-ZFBENI2 IS INITIAL.
        CONCATENATE W_TEM ZTLLCAMHD-ZFBENI2 INTO W_TEM SEPARATED BY
                    SPACE.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFBENI3 IS INITIAL.
        CONCATENATE W_TEM ZTLLCAMHD-ZFBENI3 INTO W_TEM SEPARATED BY
                    SPACE.
    ENDIF.

    WRITE:/4 '������',             26 ':', 28 W_TEM.

    CLEAR W_TEM.
    W_TEM = ZTLLCHD-ZFOPBNCD.
    CONCATENATE W_TEM ZTLLCHD-ZFOBNM INTO W_TEM SEPARATED BY SPACE.
    CONCATENATE W_TEM ZTLLCHD-ZFOBBR INTO W_TEM SEPARATED BY SPACE.

    WRITE:/4 '��������',           26 ':', 28 W_TEM.

    CLEAR W_TEM.
    W_TEM = ZTLLCHD-ZFOPAMT .
    CONCATENATE ZTLLCAMHD-WAERS W_TEM INTO W_TEM SEPARATED BY SPACE.

    WRITE:/4 '�����ſ��� ����',       26 ':', 28 W_DOM_TEX1,
          /4 '������ ��ȭ(��ȭ)�ݾ�', 26 ':', 28 W_TEM,
          /4 '�����ſ����ȣ',        26 ':', 28 W_FOPNNO.

    W_INX = 1.

    LOOP AT IT_ZTMLOCAMR_1.
        AT FIRST.
            WRITE:/4 '������ǰ�ŵ�Ȯ�༭��ȣ', 26 ':'.
        ENDAT.

        IF W_INX = 1.
            WRITE: 28 IT_ZTMLOCAMR_1-ZFSGOF.
        ELSE.
            WRITE:/28 IT_ZTMLOCAMR_1-ZFSGOF.
        ENDIF.

        W_INX = W_INX + 1.
    ENDLOOP.

    CLEAR IT_ZTMLOCAMR_1.
    REFRESH IT_ZTMLOCAMR_1.

    WRITE:/4 '��������',              26 ':',  28 ZTREQST-ZFOPNDT,
          /4 '���Ǻ���Ƚ��',          26 ':',  28 ZTLLCAMHD-ZFAMDNO,
          /4 '������ ��ǰ�ε�����',   26 ':',  28 ZTLLCAMHD-ZFNGDDT,
          /4 '������ ��ȿ����',       26 ':',  28 ZTLLCAMHD-ZFNEXDT.


    IF NOT ZTLLCAMHD-ZFECON1 IS INITIAL
       OR NOT ZTLLCAMHD-ZFECON2 IS INITIAL
       OR NOT ZTLLCAMHD-ZFECON3 IS INITIAL
       OR NOT ZTLLCAMHD-ZFECON4 IS INITIAL
       OR NOT ZTLLCAMHD-ZFECON5 IS INITIAL.
         WRITE:/4 '��Ÿ ���Ǻ������', 26 ':'.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFECON1 IS INITIAL.
        WRITE: 28 ZTLLCAMHD-ZFECON1.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFECON2 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFECON2.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFECON3 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFECON3.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFECON4 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFECON4.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFECON5 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFECON5.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFETC1 IS INITIAL
       OR NOT ZTLLCAMHD-ZFETC2 IS INITIAL
       OR NOT ZTLLCAMHD-ZFETC3 IS INITIAL
       OR NOT ZTLLCAMHD-ZFETC4 IS INITIAL
       OR NOT ZTLLCAMHD-ZFETC5 IS INITIAL.
         WRITE:/4 '��Ÿ����', 26 ':'.
     ENDIF.

    IF NOT ZTLLCAMHD-ZFETC1 IS INITIAL.
        WRITE: 28 ZTLLCAMHD-ZFETC1.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFETC2 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFETC2.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFETC3 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFETC3.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFETC4 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFETC4.
    ENDIF.

    IF NOT ZTLLCAMHD-ZFETC5 IS INITIAL.
        WRITE:/28 ZTLLCAMHD-ZFETC5.
    ENDIF.

    SKIP 2.
    ULINE AT /1(47). WRITE: '< �߽ű�� ���ڼ��� >'.ULINE AT 70(115).
    SKIP 1.
    WRITE:/4 '�߽ű�� ���ڼ���', 26 ':', 28 ZTLLCSG23-ZFELENM,
                                         /28 ZTLLCSG23-ZFREPRE,
                                         /28 ZTLLCSG23-ZFELEID.

    SKIP 2.
    WRITE:/ SY-ULINE,
          / SY-VLINE, 4 TEXT-006, 115 SY-VLINE,
          / SY-VLINE, 4 TEXT-007, 115 SY-VLINE.
    WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE
