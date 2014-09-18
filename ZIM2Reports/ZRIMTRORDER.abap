*&---------------------------------------------------------------------*
*& Report          ZRIMTRORDER                                         *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����������ü�(����â�����)                          *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.06                                            *
*&     ����ȸ��: �Ѽ���.
*&---------------------------------------------------------------------*
*&   DESC.     :���� ��Ź���� ���ۺ� ���γ����� ����.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

PROGRAM  ZRIMTRORDER  MESSAGE-ID ZIM
                     LINE-SIZE 152
                     NO STANDARD PAGE HEADING.
*
**----------------------------------
**-------------------------------------
** Include
**----------------------------------
**-------------------------------------
*
*INCLUDE   ZRIMTRORDERTOP.
**INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
*INCLUDE   ZRIMUTIL01.     " Utility function ����.
*
**----------------------------------
**-------------------------------------
** Selection Screen .
**----------------------------------
**-------------------------------------
*SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
**>> �˻�����
*SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*PARAMETERS :   P_ZFTRNO  LIKE  ZTTRHD-ZFTRNO
*                         OBLIGATORY MEMORY ID ZPTRNO.    " ����ȣ.
*SELECTION-SCREEN END OF BLOCK B1.
*
**---------------------------------------------------------------------*
** EVENT INITIALIZATION.
**---------------------------------------------------------------------*
*INITIALIZATION.                                 " �ʱⰪ SETTING
*  PERFORM   P2000_SET_PARAMETER.
*  SET TITLEBAR 'TRPL'.
*
*
**---------------------------------------------------------------------*
** EVENT START-OF-SELECTION.
**---------------------------------------------------------------------*
*START-OF-SELECTION.
*
*  PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
*  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
*
** ����Ʈ Write
*  PERFORM   P3000_DATA_WRITE .
*  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
**  CLEAR : IT_TAB.
**----------------------------------
**-------------------------------------
** EVENT AT USER-COMMAND.
**----------------------------------
**-------------------------------------
*AT USER-COMMAND.
*
*  CASE SY-UCOMM.
**    WHEN 'STUP' OR 'STDN'.              " SORT ����?
**      IF IT_TAB-ZFTRNO IS INITIAL.
**        MESSAGE S962.
**      ELSE.
**        W_FIELD_NM = 'ZFTRNO'.
**        ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
**        PERFORM HANDLE_SORT TABLES  IT_TAB
**                            USING   SY-UCOMM.
**      ENDIF.
**    WHEN 'MKAL' OR 'MKLO'.          " ��ü ���� �� ��������.
**      PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
**
*    WHEN 'REFR'.
*      PERFORM   P1000_READ_TEXT  USING W_ERR_CHK.
*      IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
*      PERFORM   RESET_LIST.
*
*    WHEN 'AREQ'.
*      PERFORM P2000_RELEASE_REQ.
*
*    WHEN 'BAC1' OR 'EXIT' OR 'CANC'.    " ����.
*      LEAVE TO SCREEN 0.
*    WHEN OTHERS.
*  ENDCASE.
**  CLEAR IT_TAB.
*
**&---------------------------------
**------------------------------------*
**&      Form  P2000_SET_PARAMETER
**&---------------------------------
**------------------------------------*
*FORM P2000_SET_PARAMETER.
*
*
*ENDFORM.                    " P2000_SET_PARAMETER
**&---------------------------------
**------------------------------------*
**&      Form  P1000_READ_TEXT
**&---------------------------------
**------------------------------------*
*FORM P1000_READ_TEXT USING    P_W_ERR_CHK.
*
**>> ��� �б�. (���� �������ü�)
*  PERFORM P1000_READ_TRHD.
*  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
*
**>> ���ۺ� ���� �б�.
*  PERFORM P1000_READ_COST.
*
*ENDFORM.                    " P1000_READ_TEXT
*
**&---------------------------------
**------------------------------------*
**&      Form  P3000_DATA_WRITE
**&---------------------------------
**------------------------------------*
*FORM P3000_DATA_WRITE.
*
*  SET PF-STATUS 'TRPL'.
**>> �������ü� HEAD.
*  PERFORM P3000_HEAD_WRITE.
*
*  NEW-PAGE.
*
**>> ���ۺ� ���γ����� .
*  PERFORM P3000_COST_WRITE.
*
*ENDFORM.                    " P3000_DATA_WRITE
**&---------------------------------
**-------------------------------------
**&      Form  RESET_LIST
**&---------------------------------
**-------------------------------------
*FORM RESET_LIST.
*
*  MOVE 0 TO SY-LSIND.
*
*  W_PAGE = 1.
*  W_LINE = 1.
*  W_COUNT = 0.
** ����Ʈ Write
*  PERFORM   P3000_DATA_WRITE .
*
*ENDFORM.                    " RESET_LIST
**&---------------------------------
**------------------------------------*
**&      Form  P1000_READ_TRHD
**&---------------------------------
**------------------------------------*
**       text
**----------------------------------
**------------------------------------*
*FORM P1000_READ_TRHD .
*
**> �����������.
*  SELECT SINGLE * INTO CORRESPONDING FIELDS OF ST_TAB_HD
*                  FROM ZTTRHD
*                 WHERE ZFTRNO = P_ZFTRNO.
*
*  IF SY-SUBRC NE 0.
*    W_ERR_CHK = 'Y'.
*    MESSAGE S738.
*    EXIT.
*  ENDIF.
*
**> �ΰ���, ��ǥ�Ѿ�.
*  SELECT SINGLE WMWST WRBTR WAERS
*           INTO (ST_TAB_HD-WMWST,
*                 ST_TAB_HD-WRBTR, ST_TAB_HD-WAERS)
*           FROM ZTBKPF
*          WHERE BUKRS = ST_TAB_HD-BUKRS
*            AND BELNR = ST_TAB_HD-BELNR
*            AND GJAHR = ST_TAB_HD-GJAHR .
*
**> ���۹����.
*  IF NOT ST_TAB_HD-ZFDRMT IS INITIAL.
*    PERFORM   GET_DD07T_SELECT USING  'ZDDRMT'  ST_TAB_HD-ZFDRMT
*                            CHANGING   ST_TAB_HD-W_DRMT  W_SY_SUBRC.
*  ENDIF.
*
**> ��۾�ü��.
*  IF NOT ST_TAB_HD-ZFTRCO IS INITIAL.
*    PERFORM  P1000_GET_VENDOR   USING   ST_TAB_HD-ZFTRCO
*                             CHANGING   ST_TAB_HD-W_TRCO.
*  ENDIF.
*
**> ���ް���.
*  SELECT SUM( WRBTR ) INTO ST_TAB_HD-AMOUNT
*                      FROM ZTBSEG
*                     WHERE BUKRS = ST_TAB_HD-BUKRS
*                       AND BELNR = ST_TAB_HD-BELNR
*                       AND GJAHR = ST_TAB_HD-GJAHR .
**> ��ݺ�.
*  SELECT SINGLE WRBTR INTO ST_TAB_HD-TRS_AMT
*                      FROM ZTBSEG
*                     WHERE BUKRS = ST_TAB_HD-BUKRS
*                       AND BELNR = ST_TAB_HD-BELNR
*                       AND GJAHR = ST_TAB_HD-GJAHR
*                       AND ZFCSTGRP = '009'
*                       AND ZFCD     = '001'.
**> �ΰǺ�.
*  SELECT SINGLE WRBTR INTO ST_TAB_HD-MAN_AMT
*                      FROM ZTBSEG
*                     WHERE BUKRS = ST_TAB_HD-BUKRS
*                       AND BELNR = ST_TAB_HD-BELNR
*                       AND GJAHR = ST_TAB_HD-GJAHR
*                       AND ZFCSTGRP = '009'
*                       AND ZFCD     = '002'.
**>��Ÿ���.
*  ST_TAB_HD-ETC_AMT = ST_TAB_HD-AMOUNT
*                        - ( ST_TAB_HD-TRS_AMT + ST_TAB_HD-MAN_AMT ).
*
**> ��ǥǰ��.
*  SELECT SINGLE TXZ01 INTO ST_TAB_HD-TXZ01
*                      FROM ZTTRIT
*                     WHERE ZFTRNO = ST_TAB_HD-ZFTRNO.
**> ǰ���.
*  SELECT COUNT( * ) INTO ST_TAB_HD-W_ITM_CN
*                    FROM ZTTRIT
*                   WHERE ZFTRNO = ST_TAB_HD-ZFTRNO.
*
*  ST_TAB_HD-W_ITM_CN = ST_TAB_HD-W_ITM_CN - 1.
*
**> ����ó.
*  SELECT DISTINCT WERKS
*             INTO CORRESPONDING FIELDS OF TABLE IT_TAB_WERKS
*             FROM ZTTRIT
*            WHERE ZFTRNO = ST_TAB_HD-ZFTRNO.
*
*  LOOP AT IT_TAB_WERKS.
*    W_TABIX  = SY-TABIX.
*    SELECT SINGLE NAME1 INTO IT_TAB_WERKS-W_WERKS
*                        FROM T001W
*                       WHERE WERKS = IT_TAB_WERKS-WERKS.
*    MODIFY IT_TAB_WERKS INDEX W_TABIX.
*  ENDLOOP.
*ENDFORM.                    " P1000_READ_TRHD
*
**&---------------------------------
**------------------------------------*
**&      Form  P1000_READ_COST
**&---------------------------------
**------------------------------------*
**       text
**----------------------------------
**------------------------------------*
*FORM P1000_READ_COST .
*
**> ���γ���.
*  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB_CST
*           FROM ZTTRCST
*          WHERE ZFTRNO = P_ZFTRNO.
*
**> ���⳻��.
**>> ��ݺ�, �ΰǺ�.
*  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB_DTL
*           FROM ZTTRCSTIT
*          WHERE ZFTRNO = P_ZFTRNO.
*
*  LOOP AT IT_TAB_DTL.
*    W_TABIX = SY-TABIX.
*    READ TABLE IT_TAB_CST WITH KEY ZFSEQ = IT_TAB_DTL-ZFSEQ.
*    IF SY-SUBRC EQ 0.
*      IT_TAB_DTL-ZFHBLNO = IT_TAB_CST-ZFHBLNO.
*      MODIFY IT_TAB_DTL INDEX W_TABIX.
*    ENDIF.
*  ENDLOOP.
*
**>> ��Ÿ���.
*  SELECT M~ZFCDNM B~WRBTR
*          INTO CORRESPONDING FIELDS OF TABLE IT_TAB_BSEG
*          FROM ZTBSEG AS B INNER JOIN ZTIMIMG08 AS M
*            ON B~ZFCSTGRP = M~ZFCDTY
*           AND B~ZFCD     = M~ZFCD
*         WHERE B~BUKRS = ST_TAB_HD-BUKRS
*           AND B~BELNR = ST_TAB_HD-BELNR
*           AND B~GJAHR = ST_TAB_HD-GJAHR
*           AND B~ZFCSTGRP = '009'
*           AND B~ZFCD NOT IN ('001', '002').
*
*ENDFORM.                    " P1000_READ_COST
**&---------------------------------
**------------------------------------*
**&      Form  P3000_HEAD_WRITE
**&---------------------------------
**------------------------------------*
*FORM P3000_HEAD_WRITE.
*
*  SKIP 2.
*  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
*  WRITE : /70  '[ ����������ü� ]'
*               COLOR COL_HEADING INTENSIFIED OFF.
*
*  SKIP 2.
*  WRITE : 102 SY-ULINE,
*         /102 SY-VLINE NO-GAP, (4) '��'     CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '��  ��' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '��  ��' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '��  ��' CENTERED NO-GAP,
*              SY-VLINE NO-GAP,
*         /102 SY-VLINE NO-GAP, (4) '  ' CENTERED NO-GAP,
*          107 SY-ULINE NO-GAP,
*         /102 SY-VLINE NO-GAP, (4) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP,
*         /102 SY-VLINE NO-GAP, (4) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP,
*         /102 SY-VLINE NO-GAP, (4) '��' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP, (14) '  ' CENTERED NO-GAP,
*              SY-VLINE NO-GAP,
*          / ' �������ù�ȣ : ' NO-GAP,
*              ST_TAB_HD-ZFTRNO NO-GAP,
*          102 SY-ULINE.
*  SKIP 2 .
*  WRITE AT (MAX-LINE) SY-ULINE.
**> 1.
*  WRITE : / SY-VLINE NO-GAP, (20) '��  ��   ��  ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*           ' �Ʒ��� ����(���� ��ǥ����) ���� �����۾��� �����մϴ�.'.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**> 2.
*  DATA : W_LEN TYPE I.
*  W_LEN = STRLEN( ST_TAB_HD-TXZ01 ).
*  WRITE : / SY-VLINE NO-GAP, (20) '��  ��   ǰ  ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*        AT (W_LEN) ST_TAB_HD-TXZ01, ' �� ' NO-GAP,
*       (05) ST_TAB_HD-W_ITM_CN NO-GAP, '��' NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**> 3.
*  WRITE : / SY-VLINE NO-GAP, (20) '��           ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*       (19) ST_TAB_HD-ZFTOWT UNIT ST_TAB_HD-ZFTOWTM
*                             RIGHT-JUSTIFIED NO-GAP NO-ZERO,
*       (03) ST_TAB_HD-ZFTOWTM NO-GAP, SY-VLINE NO-GAP,
*       (20) '��  ��   ��  ��' CENTERED NO-GAP, SY-VLINE NO-GAP,
*            '������ -> ' NO-GAP.
**-----< ���۱��� ���� >--------------------->>
*  LOOP AT IT_TAB_WERKS.
*    IF SY-TABIX NE '1'.
*      WRITE : ', ' NO-GAP.
*    ENDIF.
*    WRITE : IT_TAB_WERKS-W_WERKS NO-GAP.
*  ENDLOOP.
**------------------------------------------>>
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**>4
*  WRITE : / SY-VLINE NO-GAP, (20) '��  ��   ��  ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*       (10) ST_TAB_HD-ZFGIDT NO-GAP, ' ~ ' NO-GAP,
*       (10) ST_TAB_HD-ZFDRDT NO-GAP,
*        66  SY-VLINE NO-GAP,
*       (20) '��  ��   ��  ��' CENTERED NO-GAP, SY-VLINE NO-GAP,
*            ST_TAB_HD-W_DRMT NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**>5
*  WRITE : / SY-VLINE NO-GAP, (20) '��  ��   ��  ü' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*       (43) ST_TAB_HD-W_TRCO NO-GAP,
*        66  SY-VLINE NO-GAP,
*       (20) '��  ��   ��  ��' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (50) ST_TAB_HD-ZFTRTERM NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**>6~7
*  WRITE : / SY-VLINE NO-GAP, (20) ' ' NO-GAP, SY-VLINE NO-GAP,
*       (20) '���ް���' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (17) ST_TAB_HD-AMOUNT CURRENCY ST_TAB_HD-WAERS
*                             RIGHT-JUSTIFIED NO-GAP,
*       (05) ST_TAB_HD-WAERS  NO-GAP, SY-VLINE NO-GAP,
*       (20) '�� �� ��' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (17) ST_TAB_HD-WMWST  CURRENCY ST_TAB_HD-WAERS
*                             RIGHT-JUSTIFIED NO-GAP,
*       (05) ST_TAB_HD-WAERS  NO-GAP, SY-VLINE NO-GAP,
*       (19) '��    ��' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (17) ST_TAB_HD-WRBTR  CURRENCY ST_TAB_HD-WAERS
*                             RIGHT-JUSTIFIED NO-GAP,
*       (05) ST_TAB_HD-WAERS  NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (20) '��    ��    ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  WRITE AT 22 SY-ULINE.
*  WRITE : / SY-VLINE NO-GAP, (20) ' ' NO-GAP, SY-VLINE NO-GAP,
*            '���ް� ���� (��ݺ�: ' NO-GAP,
*        (16) ST_TAB_HD-TRS_AMT  CURRENCY ST_TAB_HD-WAERS
*                                  RIGHT-JUSTIFIED NO-GAP,
*            '   �ΰǺ�: ' NO-GAP,
*        (16) ST_TAB_HD-MAN_AMT  CURRENCY ST_TAB_HD-WAERS
*                                  RIGHT-JUSTIFIED NO-GAP,
*            '   ��Ÿ��� : ' NO-GAP,
*        (16) ST_TAB_HD-ETC_AMT  CURRENCY ST_TAB_HD-WAERS
*                                  RIGHT-JUSTIFIED NO-GAP,
*            ' )' NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**>8~12
*  WRITE : / SY-VLINE NO-GAP, (20) '��          ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,  ST_TAB_HD-ZFRMK1 NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (20) '��'    CENTERED NO-GAP,
*            SY-VLINE NO-GAP,  ST_TAB_HD-ZFRMK2 NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (20) '��    ��    ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,  ST_TAB_HD-ZFRMK3 NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (20) '��          ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,  ST_TAB_HD-ZFRMK4 NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (20) '��          ��' CENTERED NO-GAP,
*            SY-VLINE NO-GAP,  ST_TAB_HD-ZFRMK5 NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**> ����..
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*      (150) '�̿Ͱ��� ���� �۾��� ������.'     CENTERED NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*      (150) '2002��     ��     ��'             CENTERED NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*      (150) '�� �� �� �� �� �� �� �� �� �� ��' CENTERED NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*      (150) '�������                  (��)'   CENTERED NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
**> TAIL.
*  WRITE : / SY-VLINE NO-GAP,
*       (49) ' ' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (50) ' ' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (49) '����� �����μ���' CENTERED NO-GAP, SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*       (49) '÷�� : �߼���ǥ      ��' CENTERED NO-GAP,
*             SY-VLINE NO-GAP,
*       (50) '�۾�����ó' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (49) '          ' CENTERED NO-GAP, SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP,
*       (49) ' ' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (50) ' ' CENTERED NO-GAP, SY-VLINE NO-GAP,
*       (49) '015-726-2836' CENTERED NO-GAP, SY-VLINE NO-GAP.
*  WRITE AT MAX-LINE SY-VLINE NO-GAP.
*  WRITE AT (MAX-LINE) SY-ULINE.
*
*ENDFORM.                    " P3000_HEAD_WRITE
**&---------------------------------
**------------------------------------*
**&      Form  P3000_COST_WRITE
**&---------------------------------
**------------------------------------*
*FORM P3000_COST_WRITE .
*
*  SKIP 2.
*  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
*  WRITE : /70  '[ ���� ��Ź���� ���ۺ� ���γ����� ]'
*               COLOR COL_HEADING INTENSIFIED OFF.
*
*  SKIP 2.
**================< ���� ���� >=============>>>>>
*  WRITE : / '1) ���� ���� '.
*  ULINE.
*  WRITE : / SY-VLINE NO-GAP, (24) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) '��  ��'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (37) '��   ��   ��'  CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (37) '��   ��   ��'  CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (24) 'House B/L No.' CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) '��  ��'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) ' '             CENTERED NO-GAP,
*       (76) SY-ULINE NO-GAP,
*            SY-VLINE NO-GAP, (16) '��Ÿ�ݾ�'      CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) '�� �հ�'       CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (24) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (07) '��  ��'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (15) '��   ��'       CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (04) '����'          CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) '��   ��'       CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (15) '��   ��'       CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (04) '����'          CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) '��   ��'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (16) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  ULINE.
**> ���⳻�� WRITE.
*  PERFORM P3000_CALC_WRITE.
*
**================< ���� ���� >=============>>>>>
*  SKIP 2.
*  WRITE : / '2) ���� ���� '.
*  ULINE.
*  WRITE : / SY-VLINE NO-GAP, (24) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (71) '��        ��'  CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (24) 'House B/L No.' CENTERED NO-GAP,
*       (72) SY-ULINE NO-GAP,
*            SY-VLINE NO-GAP, (17) '������'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '�߷���'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '�����'        CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  WRITE : / SY-VLINE NO-GAP, (24) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '��    ��'      CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '��    ��'      CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '��    ��'      CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) '�� �� ��'      CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP, (17) ' '             CENTERED NO-GAP,
*            SY-VLINE NO-GAP.
*  ULINE.
*
**> ���⳻�� WRITE.
*  PERFORM P3000_DETAIL_WRITE.
*
*
*ENDFORM.                    " P3000_COST_WRITE
*
**&---------------------------------
**------------------------------------*
**&      Form  P3000_CALC_WRITE
**&---------------------------------
**------------------------------------*
**       text
**----------------------------------
**------------------------------------*
*FORM P3000_CALC_WRITE .
*
*  CLEAR: W_TRS_TOT, W_MAN_TOT, W_ROW_TOT, W_ETC_TOT,
*         W_GRD_TOT, W_WAERS.
*
**>> ��ݺ�, �ΰǺ�.
*  LOOP AT IT_TAB_DTL.
*    W_WAERS = IT_TAB_DTL-WAERS.
*    WRITE : / SY-VLINE NO-GAP, (24) IT_TAB_DTL-ZFHBLNO    NO-GAP,
*              SY-VLINE NO-GAP,
*        (06) IT_TAB_DTL-ZFTRATE  RIGHT-JUSTIFIED NO-GAP, '%' NO-GAP,
*              SY-VLINE NO-GAP,
*        (07) IT_TAB_DTL-ZFDTON  RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (15) IT_TAB_DTL-NETPR   CURRENCY IT_TAB_DTL-WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (04) IT_TAB_DTL-ZFTADD  RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (16) IT_TAB_DTL-ZFTRAMT CURRENCY IT_TAB_DTL-WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (15) IT_TAB_DTL-NETPR   CURRENCY IT_TAB_DTL-WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (04) IT_TAB_DTL-ZFMADD  RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (16) IT_TAB_DTL-ZFMAMT CURRENCY IT_TAB_DTL-WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP, (16) ' '        NO-GAP.
**--> SUM.
*    W_TRS_TOT = W_TRS_TOT + IT_TAB_DTL-ZFTRAMT.  " ��ݺ� �հ�.
*    W_MAN_TOT = W_MAN_TOT + IT_TAB_DTL-ZFMAMT.   " �ΰǺ� �հ�.
*    W_ROW_TOT = IT_TAB_DTL-ZFTRAMT + IT_TAB_DTL-ZFMAMT. "ROW SUM.
*
*    WRITE : SY-VLINE NO-GAP,
*        (16)  W_ROW_TOT        CURRENCY IT_TAB_DTL-WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*            SY-VLINE NO-GAP.
*    ULINE.
*    CLEAR : W_ROW_TOT.
*  ENDLOOP.
*
**>> ��Ÿ���.
*  LOOP AT IT_TAB_BSEG.
*    WRITE : / SY-VLINE NO-GAP, (32) IT_TAB_BSEG-ZFCDNM NO-GAP,
*              SY-VLINE NO-GAP, (07) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (15) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (04) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (16) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (15) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (04) ' '                NO-GAP,
*              SY-VLINE NO-GAP, (16) ' '                NO-GAP,
*              SY-VLINE NO-GAP,
*        (16) IT_TAB_BSEG-WRBTR  CURRENCY W_WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP,
*        (16) IT_TAB_BSEG-WRBTR  CURRENCY W_WAERS
*                                RIGHT-JUSTIFIED NO-GAP,
*              SY-VLINE NO-GAP.
**--> SUM.
*    W_ETC_TOT = W_ETC_TOT + IT_TAB_BSEG-WRBTR.
*
*    ULINE.
*  ENDLOOP.
*
**====>>> TOTOAL.
*  W_GRD_TOT = W_TRS_TOT + W_MAN_TOT + W_ETC_TOT.
*
*  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
*  WRITE : / SY-VLINE NO-GAP, (40) '��      ��'    CENTERED NO-GAP,
*            SY-VLINE NO-GAP,
*      (37) W_TRS_TOT CURRENCY W_WAERS  RIGHT-JUSTIFIED NO-GAP,
*            SY-VLINE NO-GAP,
*      (37) W_MAN_TOT CURRENCY W_WAERS  RIGHT-JUSTIFIED NO-GAP,
*            SY-VLINE NO-GAP,
*      (16) W_ETC_TOT CURRENCY W_WAERS  RIGHT-JUSTIFIED NO-GAP,
*            SY-VLINE NO-GAP,
*      (16) W_GRD_TOT CURRENCY W_WAERS  RIGHT-JUSTIFIED NO-GAP,
*            SY-VLINE NO-GAP.
*  ULINE.
*  FORMAT RESET.
*ENDFORM.                    " P3000_CALC_WRITE
**&---------------------------------
**------------------------------------*
**&      Form  P3000_DETAIL_WRITE
**&---------------------------------
**------------------------------------*
**       text
**----------------------------------
**------------------------------------*
*FORM P3000_DETAIL_WRITE .
*
*  LOOP AT IT_TAB_CST.
*    WRITE : / SY-VLINE NO-GAP,
*         (24) IT_TAB_CST-ZFHBLNO                  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFGARO  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFSERO  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFNOPI  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFRWET  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFYTON  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFWTON  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP,
*         (17) IT_TAB_CST-ZFCTON  RIGHT-JUSTIFIED  NO-GAP,
*              SY-VLINE NO-GAP.
*    ULINE.
*  ENDLOOP.
*ENDFORM.                    " P3000_DETAIL_WRITE
*
**&---------------------------------
**------------------------------------*
**&      Form  P1000_GET_VENDOR
**&---------------------------------
**------------------------------------*
*FORM P1000_GET_VENDOR USING    P_LIFNR
*                      CHANGING P_NAME1.
*  DATA : L_TEXT(35).
*
*  CLEAR : P_NAME1, W_LFA1.
*  IF P_LIFNR IS INITIAL.
*    EXIT.
*  ENDIF.
*
** VENDOR MASTER SELECT( LFA1 )----------------------->
*  CALL FUNCTION 'READ_LFA1'
*    EXPORTING
*      XLIFNR         = P_LIFNR
*    IMPORTING
*      XLFA1          = W_LFA1
*    EXCEPTIONS
*      KEY_INCOMPLETE = 01
*      NOT_AUTHORIZED = 02
*      NOT_FOUND      = 03.
*
*  CASE SY-SUBRC.
*    WHEN 01.     MESSAGE I025.
*    WHEN 02.     MESSAGE E950.
*    WHEN 03.     MESSAGE E020   WITH    P_LIFNR.
*  ENDCASE.
**   TRANSLATE W_LFA1 TO UPPER CASE.
*  MOVE: W_LFA1-NAME1   TO   L_TEXT.
*  TRANSLATE L_TEXT TO UPPER CASE.
*  P_NAME1 = L_TEXT.
*
*ENDFORM.                    " P1000_GET_VENDOR
**&---------------------------------
**------------------------------------*
**&      Form  P2000_RELEASE_REQ
**&---------------------------------
**------------------------------------*
**       text
**----------------------------------
**------------------------------------*
*FORM P2000_RELEASE_REQ .
*
**  DATA: rel_indicator LIKE eban-frgkz.
** SELECT SINGLE frgkz INTO rel_indicator
**    FROM eban
**    WHERE banfn = io_docno AND
**          frgkz <> 'X'.    "����������
*
**  DATA: WL_RELST LIKE ZTTRHD-ZFRELST.
**  CLEAR WL_RELST.
**  SELECT SINGLE ZFRELST INTO WL_RELST
**     FROM ZTTRHD
**     WHERE ZFTRNO = P_ZFTRNO.
**
**    CASE WL_RELST.
**     WHEN 'W'.
**      MESSAGE I999(ZIM1)
**         WITH '�� ������ �ѹ� �̻� ���� ��û�� �����Դϴ�. '.
**     WHEN 'D'.
**      MESSAGE I999(ZIM1)
**         WITH '�� ������ �̹� ���� �Ϸ�� �����Դϴ�. '.
**    ENDCASE.
*
**  DATA: APPTYPE LIKE ZWF00-APPTYPE, "���ڰ���������� NCW����APPTYPE
**  DATA: BUKRS   LIKE ZWF00-BUKRS,   "Company Code
**        GJAHR   LIKE ZWF00-GJAHR,
**        "������ȣ: ���ڰ��縦 ��û�� ���������� �Ϸù�ȣ
**        CTRLNO  LIKE ZWF00-CTRLNO,
**        "������ȣ: ���ڰ��縦 ��û�� ���������� Lineitem No.
**        CTRLPG  TYPE ZZ_CTRLPG,
**        "������ȣ: ���ڰ��縦 ��û�� ���������� Lineitem No.
**        KEY(10).
*
**  APPTYPE = 'MTR'.
**  CTRLNO = P_ZFTRNO.
*
**  CALL FUNCTION 'Z_WF_APPROVAL_REQUEST'       "NCW ����
**    EXPORTING
**      APPTYPE            = APPTYPE          "���繮�� ����
**      CTRLNO             = CTRLNO           "�Ϸù�ȣ
**    EXCEPTIONS
**      LOGIN_FAILED       = 1
**      APPROVER_NOT_FOUND = 2
**      DATA_NOT_FOUND     = 3
**      DATA_DUPLICATED    = 4
**      ERROR_FOUND        = 5
**      OTHERS             = 6.
*
*  IF SY-SUBRC <> 0.
*    CASE SY-SUBRC.
*      WHEN 1.      MESSAGE I999(ZMMM) WITH 'LOGIN_FAILED'.
*      WHEN 2.      MESSAGE I999(ZMMM) WITH 'APPROVER_NOT_FOUND'.
*      WHEN 3.      MESSAGE I999(ZMMM) WITH 'DATA_NOT_FOUND'.
*      WHEN 4.      MESSAGE I999(ZMMM) WITH 'DATA_DUPLICATED'.
*      WHEN 5.      MESSAGE I999(ZMMM) WITH 'ERROR_FOUND'.
*      WHEN OTHERS. MESSAGE I999(ZMMM) WITH 'OTHERS'.
*    ENDCASE.
*  ELSE.
*    UPDATE ZTTRHD SET ZFRELST = 'W' WHERE ZFTRNO = P_ZFTRNO.
*    MESSAGE S999(ZIM1) WITH '���� ��û �Ǿ����ϴ�.'.
*  ENDIF.
*
*ENDFORM.                    " P2000_RELEASE_REQ
