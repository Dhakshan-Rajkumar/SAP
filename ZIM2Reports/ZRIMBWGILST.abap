*&---------------------------------------------------------------------*
*& Report  ZRIMBWGILST                                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ����â�� ����Ƿ� LIST                                *
*&      �ۼ��� : �̽��� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.09.13                                            *
*&---------------------------------------------------------------------*
*&  DESC.      :  ����μ� ���ԽŰ� �Ƿڰ� ������� ����â����
*&                LIST-UP�Ͽ�  ����غ�
*&---------------------------------------------------------------------*
*& [���泻��]
*& 2001.11.07 �迵��(LG-EDS): ����Ϸ� �� ���, �÷�Ʈ �� �������� ����.
*&                            Indentation.
*&---------------------------------------------------------------------*

REPORT  ZRIMBWGILST  MESSAGE-ID ZIM
                     LINE-SIZE 130
                     NO STANDARD PAGE HEADING.

*----------------------------------------------------------------------*
* TABLES �� ���� DEFINE.                                               *
*----------------------------------------------------------------------*
*>> TABLE DEFINE.
TABLES : ZTBL,
         ZTBWHD,
         ZTCUCL,
         ZTIDR,
         ZTBLINR.

*>> ���� DEFINE.
DATA : W_ERR_CHK TYPE C VALUE 'N',   "ERROR CHECK.
       MAX LIKE ZTBLINR-ZFBTSEQ,     "ZFBTSEQ�� �ִ밪.
       WA_LINE TYPE I,               "IT_TAB LINE ��.
       ZFTOWT1 TYPE I,               "�հ��.
       W_LINE  TYPE I,                "SUB LINE ��
       W_MOD LIKE SY-TABIX,          "MOD ��.
       W_TABIX LIKE SY-TABIX,        "HIDE ��.
       MARKFIELD TYPE C.             "CHECKBOX��,

*>>CONTROL LEVEL GROUP��.
FIELD-GROUPS: HEADER.

*>> IT_TAB DEFINE.
DATA: BEGIN OF IT_TAB OCCURS 0,
***> GROUP KEY
      ZFBLSDP  LIKE ZTBL-ZFBLSDP,   "����-B/L�ۺ�ó
      ZFBNARCD LIKE ZTBL-ZFBNARCD,  "��ġ���-���������ڵ�
      ZFCLSEQ  LIKE ZTIDR-ZFCLSEQ,
***> KEY WORD
      ZFIVNO   LIKE ZTBWHD-ZFIVNO,   "�������۸�����.
      ZFGISEQ  LIKE ZTBWHD-ZFGISEQ,  "�������۸�����.
      ZFBLNO   LIKE  ZTBWHD-ZFBLNO,  " B/L ����NO
      ZFBTSEQ  LIKE  ZTBLINR-ZFBTSEQ, "������� �Ϸù�ȣ
***> WRITE FILED.
      ZFREBELN LIKE  ZTBWHD-ZFREBELN, "��ǥP/O NO.
      ZFSHNO   LIKE  ZTBWHD-ZFSHNO,   "��������.
*      ZFIDSDT  LIKE ZTBWHD-ZFIDSDT,  "��������-�Ű������
      ZFIDWDT  LIKE ZTBWHD-ZFIDWDT,  "�����-�Ű������
      ZFNEWT   LIKE ZTBL-ZFNEWT ,    "���߷�
      ZFNEWTM  LIKE ZTBL-ZFNEWTM,    "���߷�����
      ZFTOWT   LIKE ZTBWHD-ZFTOWT ,  "���߷�
      ZFTOWTM  LIKE ZTBWHD-ZFTOWTM,  "����
      ZFPKCN   LIKE ZTBWHD-ZFPKCN ,  "�����尳��
      ZFPKCN_I TYPE I,               "SUM��.
      ZFPKCNM  LIKE ZTBWHD-ZFPKCNM,  "���� ����
      ZFCARNM  LIKE ZTBL-ZFCARNM,    "�����
      ZFRGDSR  LIKE ZTBL-ZFRGDSR,    "��ǥǰ��
      ZFHBLNO  LIKE ZTBL-ZFHBLNO,    "HOUSE B/L NO
      ZFINRNO  LIKE ZTBLINR-ZFINRNO, "���ԽŰ��ȣ
      ZFLOC    LIKE ZTBLINR-ZFLOC,   "������ġ
      ZFWERKS    LIKE ZTBL-ZFWERKS.    "�÷�Ʈ
DATA : END OF IT_TAB.

DATA : IT_T001W    LIKE    T001W       OCCURS 0 WITH HEADER LINE.
DATA : WA_TAB LIKE IT_TAB.

*----------------------------------------------------------------------*
*          SELECTION-SCREEN                                            *
*----------------------------------------------------------------------*

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS:
    S_BUKRS     FOR ZTBL-BUKRS NO-EXTENSION
                               NO INTERVALS,
    S_BLSDP  FOR ZTBWHD-ZFBLSDP,  "����-B/L�ۺ�ó
    S_BNARCD FOR ZTBWHD-ZFBNARCD, "��ġ���-���������ڵ�
    S_REBELN FOR ZTBWHD-ZFREBELN, "��ǥP/O NO.
*   S_IDSDT  FOR ZTBWHD-ZFIDSDT,  "��������-�Ű������
    S_IDWDT  FOR ZTBWHD-ZFIDWDT.  "�����-�Ű������
SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLSDP-LOW.
    PERFORM   P1000_BL_SDP_HELP  USING  S_BLSDP-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLSDP-HIGH.
    PERFORM   P1000_BL_SDP_HELP  USING  S_BLSDP-HIGH.

*----------------------------------------------------------------------*
*          INITIALIZATION.                                             *
*----------------------------------------------------------------------*
INITIALIZATION.                          " �ʱⰪ SETTING
    PERFORM   P2000_SET_PARAMETER.

*----------------------------------------------------------------------*
*          START-OF-SELECTION.                                         *
*----------------------------------------------------------------------*
START-OF-SELECTION.

*>>INTERNAL TABLE CLEAR.
    REFRESH IT_TAB.
    CLEAR IT_TAB.

*>> READ TABLE ZTBWHD
    PERFORM   P1000_READ_ZTBWHD        USING   W_ERR_CHK.

    LOOP AT IT_TAB.
        W_TABIX = SY-TABIX.

*       SELECT SINGLE ZFBNARCD INTO IT_TAB-ZFBNARCD
*              FROM   ZTIDR
*              WHERE  ZFBLNO  EQ  IT_TAB-ZFBLNO
*              AND    ZFCLSEQ EQ ( SELECT MAX( ZFCLSEQ )
*                                         FROM ZTIDR
*                                       WHERE ZFBLNO EQ IT_TAB-ZFBLNO ).

*>>   GET ZTBLINR-ZFBTSEQD �� MAX��
        PERFORM   P_1000_GET_ZFBTSEQD    USING   W_ERR_CHK.
        PERFORM   P_1000_READ_ZTBLINR    USING   W_ERR_CHK.
        PERFORM   P_1000_READ_ZTBL       USING   W_ERR_CHK.
        MOVE IT_TAB-ZFPKCN TO IT_TAB-ZFPKCN_I.
        MODIFY IT_TAB INDEX W_TABIX.
    ENDLOOP.

    CLEAR W_TABIX.
*>> WRITE IT_TAB.
    PERFORM   P_3000_WRITE_IT        USING W_ERR_CHK.

*-----------------------------------------------------------------------
* User Command
*         -ZRIMBWLST [Report] ����â�������Ȳ ����.
*-----------------------------------------------------------------------
AT USER-COMMAND.
    CASE SY-UCOMM.
        WHEN 'DISP'.                     " ����â�����.
            IF W_TABIX EQ 0.
                MESSAGE E962 .
            ELSE.
                PERFORM  P2000_DISP_ZTBWHD USING IT_TAB-ZFHBLNO
                                                 IT_TAB-ZFBLNO.
            ENDIF.

        WHEN 'DISP1'.                       " B/L ��ȸ.
            IF W_TABIX NE 0.
                PERFORM P2000_DISP_ZTBL(SAPMZIM09) USING IT_TAB-ZFBLNO.
            ELSE.
                MESSAGE E962.
            ENDIF.

        WHEN 'DISP2'.                       " �����û.
            IF W_TABIX NE 0.
                PERFORM P2000_DISP_ZTIV           USING IT_TAB-ZFHBLNO
                                                 IT_TAB-ZFBLNO.
            ELSE.
                MESSAGE E962.
            ENDIF.

        WHEN 'DISP3'.                        " ���ԽŰ�.
            IF W_TABIX NE 0.
                PERFORM P2000_DISP_ZTIDR        USING IT_TAB-ZFBLNO
                                                      IT_TAB-ZFHBLNO.
            ELSE.
                MESSAGE E962.
            ENDIF.

        WHEN 'DISP4'.                        " ���Ը���.
            IF W_TABIX NE 0.
                PERFORM P2000_DISP_ZTIDS            USING IT_TAB-ZFBLNO
                                                         IT_TAB-ZFHBLNO.
            ELSE.
                MESSAGE E962.
            ENDIF.

        WHEN 'BWPRT'.                       " �������۸���.
            IF W_TABIX NE 0.
                PERFORM P2000_PRINT_ZTBW(SAPMZIM09) USING IT_TAB-ZFIVNO
                                                        IT_TAB-ZFGISEQ.
            ELSE.
                MESSAGE E962.
            ENDIF.
    ENDCASE.

    CLEAR: IT_TAB ,W_TABIX.

*----------------------------------------------------------------------*
*           TOP-OF-PAGE                                                *
*----------------------------------------------------------------------*
TOP-OF-PAGE.
    FORMAT RESET.

    WRITE : /55 '[ ����â�� ����Ƿ� LIST ]'
            COLOR COL_HEADING INTENSIFIED OFF.

*-----------------------FORM ����--------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
    SET TITLEBAR 'ZIMR65'.                     " TITLE BAR
    REFRESH IT_TAB.
    CLEAR IT_TAB.
ENDFORM.                                     " P2000_SET_PARAMETER

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_ZTBWHD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_ZTBWHD USING  W_ERR_CHK.
    W_ERR_CHK = 'N'.                " Error Bit Setting
*MODIFIED BY SEUNGYEON.(2002.08.30)
    SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
             FROM ( ZTBL AS H INNER JOIN ZTIDR AS S
                    ON   H~ZFBLNO    EQ S~ZFBLNO )
                     INNER JOIN ZTIV AS I
                     ON S~ZFIVNO   EQ   I~ZFIVNO
*                    INNER JOIN ZTCUCL AS I
*                    ON   S~ZFBLNO    EQ  I~ZFBLNO
*                    AND  S~ZFCLSEQ   EQ  I~ZFCLSEQ
            WHERE  H~ZFBLSDP  IN S_BLSDP
              AND  H~BUKRS    IN S_BUKRS
              AND  S~ZFBNARCD IN S_BNARCD
              AND  H~ZFREBELN IN S_REBELN
              AND  I~ZFCUST   IN ('3', 'Y')
*             AND  S~ZFDOCST  EQ 'R'
              AND  H~ZFRPTTY  IN ('B', 'N')
*             AND  S~ZFIDSDT  IN S_IDSDT.
              AND  S~ZFIDWDT  IN S_IDWDT.

*  SELECT * FROM ZTBWHD INTO CORRESPONDING FIELDS OF TABLE IT_TAB
*          WHERE  ZFBLSDP  IN S_BLSDP
*            AND  ZFBNARCD IN S_BNARCD
*            AND  ZFREBELN IN S_REBELN
*            AND  ZFIDSDT  IN S_IDSDT
*            AND  ZFIDWDT  IN S_IDWDT.

    IF SY-SUBRC NE 0.               " Not Found?
        W_ERR_CHK = 'Y'.  MESSAGE S738. EXIT.
    ENDIF.

    SELECT * INTO TABLE IT_T001W FROM T001W
             FOR ALL ENTRIES IN IT_TAB
             WHERE  WERKS EQ IT_TAB-ZFWERKS.

ENDFORM.                    " P1000_READ_ZTBWHD

*&---------------------------------------------------------------------*
*&      Form  P_1000_GET_ZFBTSEQD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P_1000_GET_ZFBTSEQD USING    P_W_ERR_CHK.
    W_ERR_CHK = 'N'.                " Error Bit Setting

    SELECT MAX( ZFBTSEQ ) INTO MAX FROM ZTBLINR
           WHERE  ZFBLNO = IT_TAB-ZFBLNO
           GROUP BY ZFBLNO.
    ENDSELECT.

    IF SY-SUBRC NE 0.               " Not Found?
        W_ERR_CHK = 'Y'.  MESSAGE S738. EXIT.
    ENDIF.

    MOVE MAX TO IT_TAB-ZFBTSEQ.
    CLEAR MAX.
ENDFORM.                    " P_1000_GET_ZFBTSEQD

*&---------------------------------------------------------------------*
*&      Form  P_1000_READ_ZTBLINR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P_1000_READ_ZTBLINR USING    P_W_ERR_CHK.
    W_ERR_CHK = 'N'.                " Error Bit Setting
    CLEAR ZTBLINR.

    SELECT SINGLE * FROM ZTBLINR
         WHERE ZFBTSEQ = IT_TAB-ZFBTSEQ
           AND ZFBLNO  = IT_TAB-ZFBLNO.

    IF SY-SUBRC EQ 0.
        MOVE  ZTBLINR-ZFINRNO TO IT_TAB-ZFINRNO.
        MOVE  ZTBLINR-ZFLOC   TO IT_TAB-ZFLOC.
    ENDIF.

    IF SY-SUBRC NE 0.               " Not Found?
        W_ERR_CHK = 'Y'.  MESSAGE S738. EXIT.
    ENDIF.
ENDFORM.                    " P_1000_READ_ZTBLINR

*&---------------------------------------------------------------------*
*&      Form  P_1000_READ_ZTBL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P_1000_READ_ZTBL USING    P_W_ERR_CHK.
    W_ERR_CHK = 'N'.                " Error Bit Setting
    CLEAR ZTBL.

    SELECT SINGLE * FROM ZTBL
           WHERE  ZFBLNO  = IT_TAB-ZFBLNO.

    IF SY-SUBRC EQ 0.
        SELECT SUM( BLMENGE ) INTO IT_TAB-ZFNEWT
               FROM ZTBLIT
               WHERE ZFBLNO EQ IT_TAB-ZFBLNO.

        SELECT MEINS INTO IT_TAB-ZFNEWTM
               FROM  ZTBLIT  UP TO 1 ROWS
               WHERE ZFBLNO EQ IT_TAB-ZFBLNO.

        ENDSELECT.

        MOVE   ZTBL-ZFBLSDP  TO IT_TAB-ZFBLSDP.
        MOVE   ZTBL-ZFBNARCD TO IT_TAB-ZFBNARCD.
        MOVE   ZTBL-ZFRGDSR  TO IT_TAB-ZFRGDSR.
*       MOVE   ZTBL-ZFNEWT   TO IT_TAB-ZFNEWT.
*       MOVE   ZTBL-ZFNEWTM  TO IT_TAB-ZFNEWTM.
        MOVE   ZTBL-ZFCARNM  TO IT_TAB-ZFCARNM.
        MOVE   ZTBL-ZFHBLNO  TO IT_TAB-ZFHBLNO.
    ENDIF.

    IF SY-SUBRC NE 0.               " Not Found?
        W_ERR_CHK = 'Y'.  MESSAGE S738. EXIT.
    ENDIF.
ENDFORM.                    " P_1000_READ_ZTBL

*&---------------------------------------------------------------------*
*&      Form  P_3000_WRITE_IT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P_3000_WRITE_IT USING    P_W_ERR_CHK.
    SET  PF-STATUS 'ZIMR65'.
    SET  TITLEBAR 'ZIMR65'.
    SORT IT_TAB BY ZFBLSDP ZFBNARCD.
    CLEAR WA_LINE.
    DESCRIBE TABLE IT_TAB LINES WA_LINE.
    PERFORM P3000_LINE_WRITE.
ENDFORM.                     " P_3000_WRITE_IT

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
    DATA : W_TEXT1(20),
           W_TEXT2(20),
           W_PO(15).

    W_LINE = 0.

    LOOP AT IT_TAB.
        W_LINE = W_LINE + 1.
        W_TABIX = SY-TABIX.

        FORMAT RESET.
*>>     ���������ڵ尡 �ٲ𶧸�.

        AT NEW ZFBNARCD.
            SKIP.
            CLEAR : W_TEXT1, W_TEXT2.

            IF NOT IT_TAB-ZFBLSDP IS INITIAL.
                SELECT SINGLE ZFCDNM INTO W_TEXT1 FROM   ZTIMIMG08
                       WHERE  ZFCDTY   EQ   '012'
                       AND    ZFCD     EQ   IT_TAB-ZFBLSDP.
            ENDIF.

            IF NOT IT_TAB-ZFBNARCD IS INITIAL.
                SELECT ZFBNARM INTO W_TEXT2 FROM   ZTIMIMG03
                       WHERE  ZFBNARCD  EQ  IT_TAB-ZFBNARCD.

                ENDSELECT.
            ENDIF.

            WRITE :  /3 '�ۺ�ó : ', IT_TAB-ZFBLSDP, W_TEXT1,
                      33 '��ġ��� : ', IT_TAB-ZFBNARCD, W_TEXT2,
                      110 'TODAY : ', SY-DATUM.

            PERFORM P3000_TITLE_WRITE.
        ENDAT.

        READ TABLE IT_T001W WITH KEY WERKS = IT_TAB-ZFWERKS.

        CLEAR W_PO.
        CONCATENATE IT_TAB-ZFREBELN '-' IT_TAB-ZFSHNO INTO W_PO.

        IF W_PO EQ '-'.
            W_PO = ''.
        ENDIF.

*>>     �Ϲ�FIELD.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE : /
               SY-VLINE, (12) W_PO,                   "��ǥP/O NO.
*              SY-VLINE, (8) IT_TAB-ZFIDSDT NO-GAP, "��������-�Ű������
               SY-VLINE, (14) IT_TAB-ZFIDWDT,         "�����-�Ű������
               SY-VLINE, (12) IT_TAB-ZFNEWT UNIT IT_TAB-ZFNEWTM
                                              NO-GAP,   "���߷�
                         (4) IT_TAB-ZFNEWTM   NO-GAP,   "���߷�����
               SY-VLINE,(12) IT_TAB-ZFTOWT UNIT IT_TAB-ZFTOWTM
                                              NO-GAP,   "���߷�
                         (4) IT_TAB-ZFTOWTM   NO-GAP,   "����
               SY-VLINE,(12) IT_TAB-ZFPKCN_I  UNIT IT_TAB-ZFPKCNM
                                              NO-GAP,   "�����尳��
                         (4) IT_TAB-ZFPKCNM   NO-GAP,   "���� ����
               SY-VLINE,(15) IT_TAB-ZFCARNM   NO-GAP,   "�����
               SY-VLINE,(25) IT_T001W-NAME1   NO-GAP,   "�÷�Ʈ��
               AT 130 SY-VLINE.
*>>>    HIDE
        HIDE: IT_TAB, W_TABIX.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE : /
               SY-VLINE,(30) IT_TAB-ZFRGDSR  NO-GAP,   "��ǥǰ��
               SY-VLINE,(34) IT_TAB-ZFHBLNO  NO-GAP,   "HOUSE B/L NO
               SY-VLINE,(16) IT_TAB-ZFINRNO  NO-GAP,   "���ԽŰ��ȣ
               SY-VLINE,(15) IT_TAB-ZFLOC    NO-GAP,   "������ġ
               SY-VLINE,(25) '     ',
               AT 130 SY-VLINE , SY-ULINE(130).
*>>>    HIDE
        HIDE: IT_TAB, W_TABIX.

*>>>    �Ұ�,�Ѱ�,�Ǽ�.
*>>     ��ġ��Һ�
        INSERT  IT_TAB-ZFNEWT IT_TAB-ZFTOWT IT_TAB-ZFPKCN_I INTO HEADER.

        AT END OF ZFBNARCD.
            SUM.
            FORMAT COLOR 3 INTENSIFIED OFF.
            WRITE : /
                    SY-VLINE, (10) 'SUB TOTAL:'       NO-GAP,
                    SY-VLINE, (18) ''                 NO-GAP,
                    SY-VLINE, (12)  IT_TAB-ZFNEWT
                                    UNIT  IT_TAB-ZFNEWTM NO-GAP,
                               (4) ''                 NO-GAP,
                    SY-VLINE, (12) IT_TAB-ZFTOWT
                                    UNIT  IT_TAB-ZFTOWTM NO-GAP,
                               (4) ''                 NO-GAP,
                    SY-VLINE, (12) IT_TAB-ZFPKCN_I    NO-GAP,
                               (4) ''                 NO-GAP,
                    SY-VLINE, 100(4) W_LINE, '��',
                    AT 130 SY-VLINE , SY-ULINE(130).
            W_LINE = 0.
        ENDAT.

*>>     ��������
        AT LAST.
            SUM.
            FORMAT COLOR 3 INTENSIFIED ON.
            WRITE :/ SY-ULINE(130),
                   / SY-VLINE, (10) '  TOTAL  :'       NO-GAP,
                     SY-VLINE, (18) ''                 NO-GAP,
                     SY-VLINE, (12)  IT_TAB-ZFNEWT
                                     UNIT  IT_TAB-ZFTOWTM NO-GAP,
                                (4) ''                 NO-GAP,
                     SY-VLINE, (12) IT_TAB-ZFTOWT
                                     UNIT  IT_TAB-ZFTOWTM NO-GAP,
                                (4) ''                 NO-GAP,
                     SY-VLINE, (12) IT_TAB-ZFPKCN_I    NO-GAP,
                                (4) ''                 NO-GAP,
                     SY-VLINE,
                     95 '�Ѱ˻��Ǽ�',(4) WA_LINE,
                     AT 130 SY-VLINE , SY-ULINE(130).
            FORMAT RESET.
        ENDAT.
  ENDLOOP.

  CLEAR: IT_TAB,W_TABIX.
ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
    WRITE : / SY-ULINE(130).
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE : / SY-VLINE,(12)  '��ǥP/O NO'          CENTERED,
*             SY-VLINE,(10)  '��������-�Ű������' CENTERED NO-GAP,
              SY-VLINE,(14)   '�Ű������'         CENTERED,
              SY-VLINE,(12)  '���߷�'              CENTERED NO-GAP,
              (4) '����'                           CENTERED NO-GAP,
              SY-VLINE,(12)  '���߷�'              CENTERED NO-GAP,
              (4) '����'                           CENTERED NO-GAP,
              SY-VLINE,(12)  '�����尳��'          CENTERED NO-GAP,
              (4) '����'                           CENTERED NO-GAP,
              SY-VLINE,(15)  '�� �� ��'            CENTERED NO-GAP,
              SY-VLINE,(25)  '�� �� Ʈ'            CENTERED NO-GAP,
              AT 130 SY-VLINE .
    FORMAT COLOR COL_HEADING INTENSIFIED OFF.
    WRITE : / SY-VLINE,(30)    '��ǥǰ��'          CENTERED NO-GAP,
              SY-VLINE,(34)    ' B/L NO '          CENTERED NO-GAP,
              SY-VLINE,(16)    '���ԽŰ��ȣ'      CENTERED NO-GAP,
              SY-VLINE,(15)    '������ġ'          CENTERED NO-GAP,
              SY-VLINE,(25)    '        '          CENTERED NO-GAP,
              AT 130 SY-VLINE, SY-ULINE(130).
ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTBWHD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFHBLNO  text
*      -->P_IT_TAB_ZFBLNO  text
*----------------------------------------------------------------------*
FORM P2000_DISP_ZTBWHD USING    P_ZFHBLNO
                                P_ZFBLNO.
    SET PARAMETER ID 'ZPIVNO'  FIELD ''.
    SET PARAMETER ID 'ZPGISEQ' FIELD ''.
    SET PARAMETER ID 'ZPHBLNO' FIELD P_ZFHBLNO.
    SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.

   CALL TRANSACTION 'ZIMBG3'  AND SKIP  FIRST SCREEN.
ENDFORM.                    " P2000_DISP_ZTBWHD

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFHBLNO  text
*      -->P_IT_TAB_ZFBLNO  text
*----------------------------------------------------------------------*
FORM P2000_DISP_ZTIV USING    P_ZFHBLNO
                              P_ZFBLNO.
    SET PARAMETER ID 'ZPIVNO'  FIELD ''.
    SET PARAMETER ID 'ZPHBLNO' FIELD P_ZFHBLNO.
    SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.

    CALL TRANSACTION 'ZIM33'  AND SKIP  FIRST SCREEN.
ENDFORM.                    " P2000_DISP_ZTIV

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIDR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFBLNO  text
*      -->P_IT_TAB_ZPHBLNO  text
*----------------------------------------------------------------------*
FORM P2000_DISP_ZTIDR USING    P_ZFBLNO
                               P_ZPHBLNO.
    SET PARAMETER ID 'ZPHBLNO' FIELD  P_ZPHBLNO.
    SET PARAMETER ID 'ZPBLNO'  FIELD  P_ZFBLNO.
    SET PARAMETER ID 'ZPCLSEQ' FIELD  ''.
    SET PARAMETER ID 'ZPIDRNO' FIELD  ''.

    CALL TRANSACTION 'ZIM63' AND SKIP  FIRST SCREEN.
ENDFORM.                    " P2000_DISP_ZTIDR

*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFBLNO  text
*      -->P_IT_TAB_ZPHBLNO  text
*----------------------------------------------------------------------*
FORM P2000_DISP_ZTIDS USING    P_ZFBLNO
                               P_ZPHBLNO.
    SET PARAMETER ID 'ZPHBLNO' FIELD  P_ZPHBLNO.
    SET PARAMETER ID 'ZPBLNO'  FIELD  P_ZFBLNO.
    SET PARAMETER ID 'ZPCLSEQ' FIELD ' '.
    SET PARAMETER ID 'ZPIDRNO' FIELD ' '.

    CALL TRANSACTION 'ZIM76' AND SKIP  FIRST SCREEN.
ENDFORM.                    " P2000_DISP_ZTIDS

*&---------------------------------------------------------------------*
*&      Form  P1000_BL_SDP_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_BLSDP_LOW  text
*----------------------------------------------------------------------*
FORM P1000_BL_SDP_HELP USING    P_S_BLSDP.
    TABLES : ZTIMIMG08.

    DATA : DYNPROG            LIKE SY-REPID,
           DYNNR              LIKE SY-DYNNR,
           WINDOW_TITLE(30)   TYPE C,
           L_DISPLAY          TYPE C.

    DATA : BEGIN OF RETURN_TAB OCCURS 0.
           INCLUDE STRUCTURE DDSHRETVAL.

    DATA : END OF RETURN_TAB.

    DATA : BEGIN OF IT_BLSDP_HELP OCCURS 0,
           ZFBLSDP   LIKE ZTIMIMG08-ZFCD,
           ZFCDNM    LIKE ZTIMIMG08-ZFCDNM,
           END OF IT_BLSDP_HELP.

    REFRESH : IT_BLSDP_HELP.

    SELECT *
      FROM   ZTIMIMG08
     WHERE  ZFCDTY   EQ   '012'.

        MOVE : ZTIMIMG08-ZFCD   TO   IT_BLSDP_HELP-ZFBLSDP,
               ZTIMIMG08-ZFCDNM TO   IT_BLSDP_HELP-ZFCDNM.
        APPEND IT_BLSDP_HELP.
    ENDSELECT.

    IF SY-SUBRC NE 0.
        MESSAGE S406.
        EXIT.
    ENDIF.

    DYNPROG = SY-REPID.
    DYNNR   = SY-DYNNR.

    WINDOW_TITLE = 'B/L �ۺ�ó'.
    CONCATENATE WINDOW_TITLE '�ڵ� HELP' INTO WINDOW_TITLE
                SEPARATED BY SPACE.

    CLEAR: L_DISPLAY.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
        EXPORTING
*                RETFIELD        = 'OTYPE'
                RETFIELD        = 'ZFBLSDP'
                DYNPPROG        = DYNPROG
                DYNPNR          = DYNNR
*                DYNPROFIELD     = 'ZFBLSDP'
                WINDOW_TITLE    = WINDOW_TITLE
                VALUE_ORG       = 'S'
                DISPLAY         = L_DISPLAY
        TABLES
                VALUE_TAB       = IT_BLSDP_HELP
                RETURN_TAB      = RETURN_TAB
        EXCEPTIONS
                PARAMETER_ERROR = 1
                NO_VALUES_FOUND = 2
                OTHERS          = 3.

    IF SY-SUBRC <> 0.
        EXIT.
    ENDIF.

    READ TABLE RETURN_TAB INDEX 1.
    P_S_BLSDP = RETURN_TAB-FIELDVAL.
ENDFORM.                    " P1000_BL_SDP_HELP
