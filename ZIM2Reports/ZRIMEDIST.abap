*&---------------------------------------------------------------------*
*& Report  ZRIMEDIST                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : EDI �ۼ��� ��Ȳ                                       *
*&      �ۼ��� : �̼�ö INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.07.18                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT ZRIMEDIST     MESSAGE-ID ZIM
                     LINE-SIZE 116
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Menu Statsu Function�� Inactive�ϱ� ���� Internal Table
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_EXCL OCCURS 20,
      FCODE    LIKE RSMPE-FUNC.
DATA: END   OF IT_EXCL.

*-----------------------------------------------------------------------
* INTERNAL TABLE�̻�
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       MANDT      LIKE   ZTDHF1-MANDT,        "Ŭ���̾�Ʈ
       ZFDHENO    LIKE   ZTDHF1-ZFDHENO,      "����������ȣ
       BUKRS      LIKE   ZTDHF1-BUKRS,        "ȸ���ڵ�
       ZFDHDOC    LIKE   ZTDHF1-ZFDHDOC,      "���ڹ�����
       ZFDHSRG    LIKE   ZTDHF1-ZFDHSRG,      "�ۼ��ű���(S:�۽�,R:����)
       ZFDHSRO    LIKE   ZTDHF1-ZFDHSRO,      "�ŷ����� ID
       ZFDHREF    LIKE   ZTDHF1-ZFDHREF,      "�߽����� �ο��� ������ȣ
       ZFDHJSD    LIKE   ZTDHF1-ZFDHJSD,      "��������
       ZFDHJSH    LIKE   ZTDHF1-ZFDHJSH,      "���۽ð�
       ZFDHJSC    LIKE   ZTDHF1-ZFDHJSC,      "���� �����ڵ�(ACK)
       ZFDHTRA    LIKE   ZTDHF1-ZFDHTRA,      "��ȯ��� �����ڵ�(ACK)
       ZFDOCNOR   LIKE   ZTDHF1-ZFDOCNOR,     "Receive ���ڹ�����ȣ
       ZFDHSSD    LIKE   ZTDHF1-ZFDHSSD,      "��������(YYMMDD)
       ZFDHSST    LIKE   ZTDHF1-ZFDHSST,      "���Žð�(HHMMSS)
       ZFDHAPP    LIKE   ZTDHF1-ZFDHAPP,
                        "���ŵ� ������ Application DB Update ����("Y")
       ZFDHPRT    LIKE   ZTDHF1-ZFDHPRT,      "������� ȸ��(���� : 0)
       FILENAME   LIKE   ZTDHF1-FILENAME.     "�۽�ȭ�ϸ�
DATA : END OF IT_TAB.

DATA : W_LINE(4),
       W_CNT(4),
       W_ERR_CHK,
       W_MOD       TYPE   I,
       W_BUTXT(60).

*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE   ZRIMSORTCOM.           " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.            " Utility function ���.

TABLES: ZTDHF1, T001.                   " ǥ�� EDI FLAT HEADER

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS:  S_BUKRS   FOR  ZTDHF1-BUKRS  "ȸ���ڵ�.
                              OBLIGATORY MEMORY ID BUK,
                    S_DHDOC   FOR  ZTDHF1-ZFDHDOC,  "���ڹ�����.
                    S_DHENO   FOR  ZTDHF1-ZFDHENO,  "������ȣ.
                    S_DHJSD   FOR  ZTDHF1-ZFDHJSD,  "��������.
                    S_DHJSH   FOR  ZTDHF1-ZFDHJSH,  "���۽ð�.
                    S_DHREF   FOR  ZTDHF1-ZFDHREF,  "������ȣ.
                    S_DHAPP   FOR  ZTDHF1-ZFDHAPP,  "���俩��.
                    S_DHSSD   FOR  ZTDHF1-ZFDHSSD,  "��������(YYMMDD).
                    S_DHSST   FOR  ZTDHF1-ZFDHSST.  "���Žð�(HHMMSS).
SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
   PERFORM   P3000_TITLE_WRITE.          " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ǥ�� EDI FLAT HEAD ���̺� SELECT
   PERFORM   P1000_GET_EDI_DATA      USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.     ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE        USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.     ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'DISP'.
         IF IT_TAB IS INITIAL.
            MESSAGE S962.
         ELSE.
            CASE IT_TAB-ZFDHDOC.
               WHEN 'APP700' OR 'LOCAPP' OR 'PAYORD' OR 'APPPUR' OR
                    'APP707' OR 'LOCAMR'.
                  SET PARAMETER ID 'BES'       FIELD ''.  "P/O.
                  SET PARAMETER ID 'ZPOPNNO'   FIELD ''.  "L/C.
                  SET PARAMETER ID 'ZPREQNO'   FIELD IT_TAB-ZFDHREF(10).
                                               "�����Ƿڰ�����ȣ.
                  SET PARAMETER ID 'ZPAMDNO'
                                FIELD IT_TAB-ZFDHREF+11(5). "AMEND ȸ��

                  IF IT_TAB-ZFDHREF+11(5) EQ '00000'.
                     CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
                  ELSE.
                     CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
                  ENDIF.

               WHEN 'IMPREQ'.
                  SET PARAMETER ID 'ZPHBLNO'    FIELD ''.  "HOUSE B/L.
                  SET PARAMETER ID 'ZPBLNO'
                                FIELD IT_TAB-ZFDHREF(10).  "L/C.
                  SET PARAMETER ID 'ZPIDRNO'
                                FIELD ''.          "�����Ƿڰ�����ȣ.
                  SET PARAMETER ID 'ZPCLSEQ'
                                FIELD IT_TAB-ZFDHREF+11(5). "AMEND ȸ��
                  IF IT_TAB-ZFDHAPP EQ 'Y'.
                     CALL TRANSACTION 'ZIM76' AND SKIP  FIRST SCREEN.
                  ELSE.
                     CALL TRANSACTION 'ZIM63' AND SKIP  FIRST SCREEN.
                  ENDIF.

               WHEN OTHERS.
            ENDCASE.
         ENDIF.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_TO_PC_DOWNLOAD.
* *     WHEN 'REFR'.
*           PERFORM  P1000_RESET_LIST.
*      WHEN OTHERS.
      WHEN 'FVIEW'.          "EDI FLAT FILE ��ȸ
         IF NOT IT_TAB IS INITIAL.
            PERFORM P3000_VIEW_FLATFILE.
         ENDIF.
   ENDCASE.
   CLEAR : IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
  SET TITLEBAR  'ZIM40'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /51  '[ EDI �ۼ��� ��Ȳ]'
               COLOR COL_POSITIVE INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_EDI_DATA
*&---------------------------------------------------------------------*
FORM P1000_GET_EDI_DATA   USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.                " Error Bit Setting
  REFRESH IT_TAB.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB FROM ZTDHF1
                              WHERE BUKRS IN S_BUKRS
                              AND ZFDHDOC IN S_DHDOC
                              AND ZFDHENO IN S_DHENO
                              AND ZFDHJSD IN S_DHJSD
                              AND ZFDHJSH IN S_DHJSH
                              AND ZFDHREF IN S_DHREF
                              AND ZFDHAPP IN S_DHAPP
                              AND ZFDHSSD IN S_DHSSD
                              AND ZFDHSST IN S_DHSST.

  IF SY-SUBRC NE 0.            " Not Found?
     W_ERR_CHK = 'Y'.  MESSAGE S009.    EXIT.
  ENDIF.
ENDFORM.            " P1000_GET_EDI_DATA
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.
  PERFORM   P3000_TITLE_WRITE.                  "��� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIM06'.           " GUI STATUS SETTING.
   SET TITLEBAR  'ZIM40'.           " GUI TITLE SETTING..

   W_LINE = 0.
   W_CNT  = 0.
   SORT IT_TAB BY BUKRS ZFDHDOC ZFDHENO ZFDHJSD.

   LOOP AT IT_TAB.
*> 2001.09.03 KSB MODIFY
     IF SY-TABIX EQ 1 AND IT_TAB-BUKRS IS INITIAL.
       PERFORM  P3000_HEADER_WRITE.
     ENDIF.

     ON CHANGE OF IT_TAB-BUKRS.

       IF W_LINE NE 0.
           FORMAT RESET.
           WRITE:/ SY-ULINE,
                 / SY-VLINE, 98 'ȸ�纰 �Ǽ�:', W_CNT, 116 SY-VLINE,
                  SY-ULINE.
       ENDIF.
*> 2001.09.03 KSB MODIFY
       PERFORM  P3000_HEADER_WRITE.

     ENDON.

     W_MOD = ( W_CNT MOD 2 ).
     IF W_MOD EQ 0.
         FORMAT RESET.
         FORMAT COLOR COL_NORMAL INTENSIFIED.
     ELSE.
         FORMAT RESET.
         FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
     ENDIF.

     IF IT_TAB-ZFDHAPP EQ 'Y'.
        WRITE: / SY-VLINE, IT_TAB-ZFDHDOC,
              15 SY-VLINE, IT_TAB-ZFDHENO,
              35 SY-VLINE, IT_TAB-ZFDHREF,
              55 SY-VLINE, IT_TAB-ZFDHJSD,
              68 SY-VLINE, IT_TAB-ZFDHJSH,
              80 SY-VLINE, 85 IT_TAB-ZFDHAPP,
              91 SY-VLINE, IT_TAB-ZFDHSSD,
             104 SY-VLINE, IT_TAB-ZFDHSST, 116 SY-VLINE.
     ELSE.
        WRITE: / SY-VLINE, IT_TAB-ZFDHDOC,
              15 SY-VLINE, IT_TAB-ZFDHENO,
              35 SY-VLINE, IT_TAB-ZFDHREF,
              55 SY-VLINE, IT_TAB-ZFDHJSD,
              68 SY-VLINE, IT_TAB-ZFDHJSH,
              80 SY-VLINE, 85 IT_TAB-ZFDHAPP,
              91 SY-VLINE,
             104 SY-VLINE, 116 SY-VLINE.
     ENDIF.

     HIDE IT_TAB.

     W_LINE = W_LINE + 1.
     W_CNT  = W_CNT + 1.

     AT LAST.
*        W_CNT = '9999'.
        FORMAT RESET.
        WRITE:/ SY-ULINE,
              / SY-VLINE, 98 'ȸ�纰 �Ǽ�:', W_CNT, 116 SY-VLINE,
                SY-ULINE.
     ENDAT.
   ENDLOOP.
   CLEAR : IT_TAB.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_VIEW_FLATFILE
*&---------------------------------------------------------------------*
FORM P3000_VIEW_FLATFILE.

   DATA:W_EDI_RECORD(500),
        W_LCNT(4),
        W_FNAME2(80),
        W_LMOD(1)    VALUE  '0'.

   REFRESH : IT_EXCL.              " Inactive Function�� Internal Table

   MOVE 'REFR'  TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE 'DISP'  TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE 'DOWN'  TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE 'FVIEW' TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE '%EX'   TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE 'RW'    TO IT_EXCL-FCODE.     APPEND IT_EXCL.
   MOVE 'ENTR'  TO IT_EXCL-FCODE.     APPEND IT_EXCL.

   SET PF-STATUS 'ZIM06' EXCLUDING IT_EXCL.
   SET TITLEBAR  'ZIM41'.           " GUI TITLE SETTING..

   SKIP 2.
   FORMAT RESET.
   WRITE:/50 '[ FLAT FILE ���� ]' COLOR COL_POSITIVE INTENSIFIED OFF.
   SKIP 1.
   FORMAT RESET.
   FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
   WRITE: IT_TAB-FILENAME TO W_FNAME2 LEFT-JUSTIFIED.
   WRITE:/ SY-ULINE,
         / SY-VLINE, 'FLAT File ��: ', W_FNAME2, 116 SY-VLINE,
         / SY-ULINE.

*   SKIP 1.
*   WRITE:/ SY-ULINE.
*>> ������ ������ �б����� Data Set�� ����
   OPEN    DATASET   IT_TAB-FILENAME    FOR     INPUT   IN  TEXT  MODE.
   IF SY-SUBRC NE 0.
      EXIT.
   ENDIF.
*>> ���� ������ ������ ������ ���� ��´�.
   DO.
      READ    DATASET   IT_TAB-FILENAME INTO    W_EDI_RECORD.
      IF SY-SUBRC    EQ    4.
         EXIT.
      ENDIF.

      W_LMOD = W_LCNT MOD 2.

      IF W_LMOD EQ '0'.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE :/ SY-VLINE, W_EDI_RECORD(114), 116 SY-VLINE.
      ELSE.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE : / SY-VLINE, W_EDI_RECORD(114), 116 SY-VLINE.
      ENDIF.
      W_LCNT = W_LCNT + 1.
   ENDDO.
      WRITE: SY-ULINE.

ENDFORM.                    " P3000_VIEW_FLATFILE
*&---------------------------------------------------------------------*
*&      Form  P3000_HEADER_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_HEADER_WRITE.
       SELECT SINGLE * FROM T001 WHERE BUKRS EQ IT_TAB-BUKRS.

       CONCATENATE '(' T001-BUTXT INTO W_BUTXT.
       WRITE: W_BUTXT TO W_BUTXT LEFT-JUSTIFIED.
       CONCATENATE W_BUTXT ')' INTO W_BUTXT.
       WRITE: W_BUTXT TO W_BUTXT LEFT-JUSTIFIED.

       FORMAT RESET.
       WRITE:/3 'ȸ���ڵ�:', IT_TAB-BUKRS, W_BUTXT,
             96 'Date : ', SY-DATUM.

       FORMAT COLOR COL_HEADING INTENSIFIED OFF.
       WRITE:/ SY-ULINE,
             / SY-VLINE, '���ڹ�������',
            15 SY-VLINE, '���ڹ�����ȣ',
            35 SY-VLINE, '����������ȣ',
            55 SY-VLINE, '�ۼ�������',
            68 SY-VLINE, '�ۼ��Žð�',
            80 SY-VLINE, '�ݿ�����',
            91 SY-VLINE, '�ݿ�����',
           104 SY-VLINE, '�ݿ��ð�', 116 SY-VLINE, SY-ULINE.
       W_CNT = 0.

ENDFORM.                    " P3000_HEADER_WRITE
