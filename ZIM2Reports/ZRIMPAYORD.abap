*&---------------------------------------------------------------------*
*& Report  ZRIMPAYORD                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �������ü�(Payment Order)                             *
*&      �ۼ��� : �迵�� LG-EDS                                         *
*&      �ۼ��� : 2001.07.13                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : �������ü�.                                           *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMPAYORD   MESSAGE-ID ZIM
                     LINE-SIZE 115
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
TABLES : ZTTTHD, ZTTTSG5, ZTREQST,  DD07T.

DATA : W_ERR_CHK(1),
       W_DOM_TEX1 LIKE DD07T-DDTEXT,
       W_DOM_TEX2 LIKE DD07T-DDTEXT,
       W_FAPPDT   LIKE ZTREQST-ZFAPPDT,
       W_FDOCNO   LIKE ZTREQST-ZFDOCNO.

DATA : W_INX   TYPE I,
       W_TEM   TYPE STRING,
       W_TEM_1 TYPE STRING,
       W_COUNT TYPE I.

DATA : BEGIN  OF    IT_PAYORD_1 OCCURS 100,  "�Աݰ��ü��� IT
       ZFREQNO   LIKE ZTTTSG5-ZFCIVRN,    "�����Ƿ� ������ȣ
       ZFLSG5    LIKE ZTTTSG5-ZFLSG5,            "�ݺ���
       ZFDOCCD   LIKE ZTTTSG5-ZFDOCCD,          "�Աݰ��ü����ڵ�
       ZFDOCNO   LIKE ZTTTSG5-ZFDOCNO,           "�Աݰ��ü�����ȣ
       ZFISSDT   LIKE ZTTTSG5-ZFISSDT,           "�߱���
END OF IT_PAYORD_1.

*---------------------------------------------------------------------
* SELECTION SCREEN ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 1 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   PARAMETERS    : P_REQNO   LIKE ZTLLCHD-ZFREQNO.
                   "MEMORY ID  ZPREQNO.
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
       FROM ZTTTHD
      WHERE ZFCIVRN = P_REQNO.

     IF SY-SUBRC NE 0.
         P_W_ERR_CHK = 'Y'.
     ENDIF.

     SELECT SINGLE ZFAPPDT ZFDOCNO
       INTO (W_FAPPDT, W_FDOCNO)
       FROM ZTREQST
      WHERE ZFREQNO = P_REQNO
        AND ZFAMDNO = 0.

     SELECT *
       FROM ZTTTSG5
      WHERE ZFCIVRN = P_REQNO.

     IT_PAYORD_1-ZFREQNO = ZTTTSG5-ZFCIVRN.
     IT_PAYORD_1-ZFLSG5 =  ZTTTSG5-ZFLSG5.
     IT_PAYORD_1-ZFDOCCD = ZTTTSG5-ZFDOCCD.
     IT_PAYORD_1-ZFDOCNO = ZTTTSG5-ZFDOCNO.
     IT_PAYORD_1-ZFISSDT = ZTTTSG5-ZFISSDT.

     APPEND IT_PAYORD_1.
     CLEAR IT_PAYORD_1.

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
    SET  TITLEBAR 'PAYORD'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    P_W_ERR_CHK.
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

    SET PF-STATUS 'PAYORD'.           " GUI STATUS SETTING
    SET TITLEBAR 'PAYORD'.            " GUI TITLE SETTING..
    SKIP 2.
    WRITE:/53  TEXT-002,           "�������ü�
          /53  TEXT-003.           "(Payment Order)
    SKIP 2.
    WRITE:/4 '���ڹ�����ȣ', 21 ':',
             23 W_FDOCNO,
             85 '������û���� : ', W_FAPPDT.

    SKIP 2.
    ULINE AT /1(52). WRITE: '< �Ϲ����� >'. ULINE AT 67(115).
    SKIP 1.

* DOMAIN.-----------------------------------------------------------
    CLEAR: W_DOM_TEX1, W_DOM_TEX2.
    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDBUSFUN'
             ZTTTHD-ZFBUSFUN CHANGING   W_DOM_TEX1.

    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCFRG1'
             ZTTTHD-ZFCFRG CHANGING   W_DOM_TEX2.
*--------------------------------------------------------------------
    CLEAR W_TEM.
    W_TEM = ZTTTHD-ZFAMT.
    CONCATENATE ZTTTHD-WAERS W_TEM INTO W_TEM SEPARATED BY SPACE.

    WRITE:/4 '�������ü� �뵵',   21 ':', 23 W_DOM_TEX1.
    WRITE:/4 '���ޱݾ�',          21 ':', 23 W_TEM.
    WRITE:/4 '�ΰ������� �δ���', 21 ':', 23 W_DOM_TEX2.

    SKIP 1.
    ULINE AT /1(52). WRITE: '< ������ >'. ULINE AT 67(115).
    SKIP 1.

    WRITE:/4 '�����Ƿ���',         21 ':', 23 ZTTTHD-ZFAPPNM.

    IF NOT ZTTTHD-ZFAPPAD1 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFAPPAD1.
    ENDIF.

    IF NOT ZTTTHD-ZFAPPAD2 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFAPPAD2.
    ENDIF.

    IF NOT ZTTTHD-ZFAPPAD3 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFAPPAD3.
    ENDIF.

    IF NOT ZTTTHD-ZFTELNO IS INITIAL.
        CLEAR W_TEM.
        W_TEM = '[��ȭ��ȣ]'.
        CONCATENATE W_TEM ZTTTHD-ZFTELNO INTO W_TEM SEPARATED BY SPACE.

        WRITE:/23 W_TEM.
    ENDIF.

    WRITE:/4 '������', 21 ':', 23 ZTTTHD-ZFBENI.

    IF NOT ZTTTHD-ZFBENI1 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFBENI1.
    ENDIF.

    IF NOT ZTTTHD-ZFBENI2 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFBENI2.
    ENDIF.

    IF NOT ZTTTHD-ZFBENI3 IS INITIAL.
        WRITE:/23 ZTTTHD-ZFBENI3.
    ENDIF.

    WRITE:/4 '�����Ƿ�������', 21 ':', 23 ZTTTHD-ZFOPBNCD.

    CLEAR W_TEM.
    W_TEM = ZTTTHD-ZFOBNM.

    IF NOT ZTTTHD-ZFOBBR IS INITIAL.
        CONCATENATE W_TEM ZTTTHD-ZFOBBR INTO W_TEM SEPARATED BY
                    SPACE.
    ENDIF.

    WRITE:/23 W_TEM.

    IF NOT ZTTTHD-ZFOBAK IS INITIAL.
        CLEAR W_TEM.
        W_TEM = '[���¹�ȣ]'.
        CONCATENATE W_TEM ZTTTHD-ZFOBAK INTO W_TEM SEPARATED BY SPACE.

        WRITE:/23 W_TEM.
    ENDIF.

    WRITE:/4 '����������', 21 ':', 23 ZTTTHD-ZFBENCD.

    CLEAR W_TEM.
    W_TEM = ZTTTHD-ZFBENM.

    IF NOT ZTTTHD-ZFBEBR IS INITIAL.
        CONCATENATE W_TEM ZTTTHD-ZFBEBR INTO W_TEM SEPARATED BY
                    SPACE.
    ENDIF.

    WRITE:/23 W_TEM.

    IF NOT ZTTTHD-ZFOBAK1 IS INITIAL.
        CLEAR W_TEM.
        W_TEM = '[���¹�ȣ]'.
        CONCATENATE W_TEM ZTTTHD-ZFOBAK1 INTO W_TEM SEPARATED BY SPACE.

        WRITE:/23 W_TEM.
    ENDIF.

    DESCRIBE TABLE IT_PAYORD_1 LINES W_COUNT.

    IF W_COUNT > 0.
        W_INX = 1.

        LOOP AT IT_PAYORD_1.
            AT FIRST.
                WRITE:/4 '�Աݰ��� ����', 21 ':'.
            ENDAT.

            CLEAR W_TEM.
            W_TEM = '[������ȣ]'.
            CONCATENATE W_TEM IT_PAYORD_1-ZFDOCNO INTO W_TEM SEPARATED
                               BY SPACE.
            CLEAR W_TEM_1.
            W_TEM_1 = '[��������]'.
            CONCATENATE W_TEM_1 IT_PAYORD_1-ZFISSDT INTO W_TEM_1
                               SEPARATED BY SPACE.

            IF W_INX = 1.
                WRITE:23  IT_PAYORD_1-ZFDOCCD,
                      /23 W_TEM,
                      /23 W_TEM_1.
            ELSE.
                WRITE:/23 IT_PAYORD_1-ZFDOCCD,
                      /23 W_TEM,
                      /23 W_TEM_1.
            ENDIF.

            W_INX = W_INX + 1.
        ENDLOOP.
    ENDIF.

* DOMAIN.-----------------------------------------------------------
    CLEAR: W_DOM_TEX1.
    PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDSENDTY'
             ZTTTHD-ZFSENDTY CHANGING   W_DOM_TEX1.
*--------------------------------------------------------------------


    IF NOT ZTTTHD-ZFSENDTY IS INITIAL.
        WRITE:/4 '�۱ݳ���', 21 ':', 23 W_DOM_TEX1.

        IF NOT ZTTTHD-ZFSEND1 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFSEND1.
        ENDIF.

        IF NOT ZTTTHD-ZFSEND2 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFSEND2.
        ENDIF.

        IF NOT ZTTTHD-ZFSEND3 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFSEND3.
        ENDIF.

        IF NOT ZTTTHD-ZFSEND4 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFSEND4.
        ENDIF.

        IF NOT ZTTTHD-ZFSEND5 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFSEND5.
        ENDIF.
    ENDIF.

    IF NOT ZTTTHD-ZFETC1 IS INITIAL
       OR NOT ZTTTHD-ZFETC2 IS INITIAL
       OR NOT ZTTTHD-ZFETC3 IS INITIAL
       OR NOT ZTTTHD-ZFETC4 IS INITIAL
       OR NOT ZTTTHD-ZFETC5 IS INITIAL.

        WRITE:/4 '��Ÿ����', 21 ':'.

        IF NOT ZTTTHD-ZFETC1 IS INITIAL.
            WRITE:23 ZTTTHD-ZFETC1.
        ENDIF.

        IF NOT ZTTTHD-ZFETC2 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFETC2.
        ENDIF.

        IF NOT ZTTTHD-ZFETC3 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFETC3.
        ENDIF.

        IF NOT ZTTTHD-ZFETC4 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFETC4.
        ENDIF.

        IF NOT ZTTTHD-ZFETC5 IS INITIAL.
            WRITE:/23 ZTTTHD-ZFETC5.
        ENDIF.
    ENDIF.


    SKIP 1.
    ULINE AT /1(52). WRITE: '< ���ڼ��� >'.ULINE AT 67(115).
    SKIP 1.
    WRITE:/4 '���ڼ���', 21 ':', 23 ZTTTHD-ZFELENM,
                                /23 ZTTTHD-ZFREPRE,
                                /23 ZTTTHD-ZFELEID.

    SKIP 1.
    WRITE:/ SY-ULINE,
          / SY-VLINE, 4 TEXT-004, 115 SY-VLINE,
          / SY-VLINE, 4 TEXT-005, 115 SY-VLINE.
    WRITE:/ SY-ULINE.

ENDFORM.
