*&---------------------------------------------------------------------*
*& Report  ZRIMISNS                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : Insurance policy application                          *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.07.18                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   DESC.     : �̺κ�, �κ� ��Ȳ�� ���ÿ� ��ȸ �� �� �ְ�,
*&               �̺κ� ���� �κ���û���� ����Ͽ� �ۼ��� �� �ִ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMISNS   MESSAGE-ID ZIM
                   LINE-SIZE 141
                   NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFOPNNO      LIKE ZTREQHD-ZFOPNNO,   " Approval no
       ZFOPBN       LIKE ZTREQHD-ZFOPBN,    " open bank
       ZFOPBN_NM(20)     TYPE C,            " open bank name
       ZFBENI       LIKE ZTREQHD-ZFBENI,    " Beneficiary.
       ZFBENI_NM(20)     TYPE C,            " Beneficiary name.
       ZFOPNDT      LIKE ZTREQST-ZFOPNDT,   " open date
       W_AMDNO      LIKE ZTREQST-ZFAMDNO,   " import request AMEND NO.
       EBELN        LIKE ZTREQHD-EBELN,     " P/O No.
       INCO1        LIKE ZTREQHD-INCO1,     " Incoterms.
       ZFREQTY      LIKE ZTREQHD-ZFREQTY,   " payment type
       ZFREQNO      LIKE ZTINS-ZFREQNO,     " import request no
       ZFAMDNO      LIKE ZTINS-ZFAMDNO,     " insurance Amend Seq.
       ZFINSEQ      LIKE ZTINS-ZFINSEQ,     " insurance SEQ.
       ZFDOCST      LIKE ZTINS-ZFDOCST,     " insurance Document Status.
       DOCST        LIKE DD07T-DDTEXT,      " status text
       ZFINSDT      LIKE ZTINS-ZFINSDT,     " effective date
       ZFOPCD      LIKE ZTINS-ZFOPCD,       " insurance company
       ZFINCOM_NM(20)    TYPE C,            " company name
       ZFINNO       LIKE ZTINS-ZFINNO,      " policy no.
       ZFIVAMT      LIKE ZTINS-ZFIVAMT,     " Invoice Amount
       WAERS        LIKE ZTINS-WAERS,       " Invoice Amount currency
       ZFSHCUNM     LIKE ZTINSSG3-ZFSHCUNM, " loading port
       ZFARCUNM     LIKE ZTINSSG3-ZFARCUNM, " arriving port
       ZFCNCDNM     LIKE ZTINSAGR-ZFCNCDNM, " insurance condition
       ZFDSOG1      LIKE ZTINSSG2-ZFDSOG1,  " goods description
       ZFLASTAM     LIKE ZTREQHD-ZFLASTAM,  " open amount
       ZFKRWAMT     LIKE ZTINS-ZFKRWAMT,    " premium(local)
       ZFKRW        LIKE ZTINS-ZFKRW,       " local currency
       ZFINAMT      LIKE ZTINS-ZFINAMT,     " premium
       ZFINAMTC     LIKE ZTINS-ZFINAMTC,    " premium currency
       ZFINRT       LIKE ZTINS-ZFINRT,      " AIR,SHIP rate
       ZFTRANS      LIKE ZTINS-ZFTRANS,     " transportation
       TRANS        LIKE DD07T-DDTEXT,      " transportation text
       ZFACDO       LIKE ZTRECST-ZFACDO,    " account document
       LANDX        LIKE T005T-LANDX.       " origin
DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TAB_DOWN OCCURS 0,
       ZFOPNNO      LIKE ZTREQHD-ZFOPNNO,   " approval no
       ZFOPBN       LIKE ZTREQHD-ZFOPBN,    " open bank
       ZFOPBN_NM(20)     TYPE C,            " open bank name
       ZFBENI       LIKE ZTREQHD-ZFBENI,    " Beneficiary.
       ZFBENI_NM(20)     TYPE C,            " Beneficiary name.
       ZFOPNDT      LIKE ZTREQST-ZFOPNDT,   " open date
       W_AMDNO      LIKE ZTREQST-ZFAMDNO,   " import request AMEND NO.
       EBELN        LIKE ZTREQHD-EBELN,     " P/O No.
       INCO1        LIKE ZTREQHD-INCO1,     " Incoterms.
       ZFREQTY      LIKE ZTREQHD-ZFREQTY,   " payment type.
       ZFREQNO      LIKE ZTINS-ZFREQNO,     " import request no.
       ZFAMDNO      LIKE ZTINS-ZFAMDNO,     " insurance Amend Seq.
       ZFDOCST      LIKE ZTINS-ZFDOCST,     " insurance Document Status.
       ZFINSDT      LIKE ZTINS-ZFINSDT,     " effective date.
       ZFINCOM      LIKE ZTINS-ZFINCOM,     " insurance company.
       ZFINCOM_NM(20)    TYPE C,            " insurance company name
       ZFINNO       LIKE ZTINS-ZFINNO,      " policy no
       ZFIVAMT(14),                         " Invoice Amount
       WAERS        LIKE ZTINS-WAERS,       " Invoice Amount currency
       ZFSHCUNM     LIKE ZTINSSG3-ZFSHCUNM, " loading port
       ZFARCUNM     LIKE ZTINSSG3-ZFARCUNM, " arriving port
       ZFCNCDNM     LIKE ZTINSAGR-ZFCNCDNM, " insurance condition
       ZFDSOG1      LIKE ZTINSSG2-ZFDSOG1,  " goods description
       ZFLASTAM(14),                        " open amount
       ZFKRWAMT(14),                        " premium(local)
       ZFKRW        LIKE ZTINS-ZFKRW,       " local currency
       ZFINAMT(14),                         " premium
       ZFINAMTC     LIKE ZTINS-ZFINAMTC,    " premium rate
       ZFINRT       LIKE ZTINS-ZFINRT,      " AIR,SHIP rate
       ZFTRANS      LIKE ZTINS-ZFTRANS,     " transportation
       ZFACDO       LIKE ZTRECST-ZFACDO,    " account document
       LANDX        LIKE T005T-LANDX.       " origin
DATA : END OF IT_TAB_DOWN.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE   ZRIMISNSTOP.
INCLUDE   ZRIMSORTCOM.
INCLUDE   ZRIMUTIL01.
*-----------------------------------------------------------------------
* Selection Screen.
*-----------------------------------------------------------------------

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS:   S_BUKRS   FOR  ZTREQHD-BUKRS NO-EXTENSION
                                               NO INTERVALS,
                    S_OPNNO     FOR ZTREQHD-ZFOPNNO,
                    S_OPBN      FOR ZTREQHD-ZFOPBN,
                    S_BENI      FOR ZTREQHD-ZFBENI,
                    S_EBELN     FOR ZTREQHD-EBELN,
                    S_INCO1     FOR ZTREQHD-INCO1,
                    S_REQTY     FOR ZTREQHD-ZFREQTY,
                    S_REQNO     FOR ZTINS-ZFREQNO,
                    S_INSDT     FOR ZTINS-ZFINSDT,
                    S_INCOM     FOR ZTINS-ZFINCOM,
                    S_OPNO      FOR ZTINS-ZFOPNO.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.

  SELECTION-SCREEN : BEGIN OF LINE, COMMENT 1(14) TEXT-002.",POSITION 1.
     SELECTION-SCREEN : COMMENT 33(2) TEXT-021, POSITION 36.
     PARAMETERS : P_NO    AS CHECKBOX.              " No
     SELECTION-SCREEN : COMMENT 48(3) TEXT-022, POSITION 52.
     PARAMETERS : P_YES   AS CHECKBOX.              " Yes
  SELECTION-SCREEN : END OF LINE.
SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.
   PERFORM   P1000_SET_BUKRS.
   PERFORM   P2000_SET_PARAMETER.
   SET TITLEBAR 'ZIMR17'.
* Title Text Write
TOP-OF-PAGE.
   IF SY-LANGU EQ '3'.
      PERFORM   P3000_TITLE_WRITE.
   ELSE.
      PERFORM   P3000_TITLE_WRITE_EN.
   ENDIF.
*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* ����Ʈ ���� Text Table SELECT
   PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'STUP' OR 'STDN'.              " SORT ����?
         W_FIELD_NM = 'ZFOPBN'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
      WHEN 'DSIN'.                       " Insurance ��ȸ.
            PERFORM P2000_SHOW_INS USING IT_TAB-ZFREQNO
                                         IT_TAB-ZFINSEQ
                                         IT_TAB-ZFAMDNO.
      WHEN 'DSRQ'.                       " L/C ��ȸ.
            PERFORM P2000_SHOW_LC USING IT_TAB-ZFREQNO
                                        IT_TAB-W_AMDNO.

      WHEN 'DOWN'.          " FILE DOWNLOAD....
            PERFORM P3000_CREATE_DOWNLOAD_FILE.
            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'BAC1' OR 'EXIT' OR 'CANC'.    " ����.
            LEAVE TO SCREEN 0.
      WHEN 'PRT'.                       " ���Ϻ���κ� ���.
            PERFORM P2000_SHOW_ZTRED.

      WHEN OTHERS.
   ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_ZTRED
*&---------------------------------------------------------------------*
FORM P2000_SHOW_ZTRED.

*   EXPORT IT_TAB TO MEMORY ID 'ZPITSEL'.
*   CALL TRANSACTION 'ZIMR12' AND SKIP FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_ZTRED

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  P_NO = 'X'.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
  SKIP 2.

  WRITE : /57  '[ ���Ϻ��� �κ� ��û ��Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 123 'Page : ', W_PAGE.

  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : /  SY-VLINE, (20) 'L/C���ι�ȣ',
             SY-VLINE, (20) '��������',
             SY-VLINE, (8) 'Incoterms',
             SY-VLINE, (10) '������',
             SY-VLINE, (14) '������',
             SY-VLINE, (19) '�����ݾ�',
             SY-VLINE, (15) '��ǰ',
             SY-VLINE, (10) 'REQ No',
             SY-VLINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /  SY-VLINE, (20)'�������ǹ�ȣ',
             SY-VLINE, (20)'Beneficiary',
             SY-VLINE, (8)'��������',
             SY-VLINE, (10)'������',
             SY-VLINE, (14)'������',
             SY-VLINE, (19)'������ȭ',
             SY-VLINE, (15)'������',
             SY-VLINE, (10)'�κ�����',
             SY-VLINE.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  WRITE : / SY-VLINE, (20)'P/O NO.',
            SY-VLINE, (20)'����ȸ��',
            SY-VLINE, (8)'��۱���',
            SY-VLINE, (10)'����',
            SY-VLINE, (14)'��������',
            SY-VLINE, (19)'�����',
            SY-VLINE, (15)'�κ�����',
            SY-VLINE, (10)'��ǥ��ȣ',
            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH : IT_TAB.
  IF P_YES = ' ' AND P_NO = ' '.
     MESSAGE S738.
     EXIT.
  ENDIF.

  SELECT *
          FROM ZTINS
         WHERE ZFINCOM IN  S_INCOM
           AND ZFOPNO  IN  S_OPNO
           AND ZFREQNO IN  S_REQNO
           AND ZFINSDT IN  S_INSDT.

        CASE ZTINS-ZFDOCST.
           WHEN 'O' OR 'A'.
                 IF P_YES = ' '.
                    CONTINUE.
                 ENDIF.
           WHEN OTHERS.
                 IF P_NO = ' '.
                    CONTINUE.
                 ENDIF.
        ENDCASE.
        MOVE-CORRESPONDING ZTINS  TO  IT_TAB.

        SELECT MAX( ZFDSOG1 ) INTO IT_TAB-ZFDSOG1
           FROM ZTINSSG2
          WHERE ZFREQNO = IT_TAB-ZFREQNO
            AND ZFAMDNO = IT_TAB-ZFAMDNO.
        SELECT MAX( ZFSHCUNM ) MAX( ZFARCUNM )
           INTO (IT_TAB-ZFSHCUNM, IT_TAB-ZFARCUNM)
           FROM ZTINSSG3
          WHERE ZFREQNO = ZTREQHD-ZFREQNO
            AND ZFINSEQ = ZTINS-ZFINSEQ
            AND ZFAMDNO = IT_TAB-ZFAMDNO.
        SELECT MAX( ZFCNCDNM ) INTO IT_TAB-ZFCNCDNM
          FROM ZTINSAGR
         WHERE ZFREQNO = IT_TAB-ZFREQNO
           AND ZFINSEQ = ZTINS-ZFINSEQ
           AND ZFAMDNO = IT_TAB-ZFAMDNO.

        SELECT SINGLE NAME1 INTO IT_TAB-ZFINCOM_NM
          FROM LFA1
         WHERE LIFNR = ZTINS-ZFOPCD.
        SELECT  SINGLE *
           FROM ZTREQHD
          WHERE ZFOPNNO   IN S_OPNNO
            AND BUKRS     IN S_BUKRS
            AND ZFOPBN    IN S_OPBN
            AND ZFBENI    IN S_BENI
            AND EBELN     IN S_EBELN
            AND INCO1     IN S_INCO1
            AND ZFREQTY   IN S_REQTY
            AND ZFINSYN   EQ 'A'
            AND ZFREQNO   EQ ZTINS-ZFREQNO.
        IF SY-SUBRC NE 0.
           CONTINUE.
        ENDIF.
        SELECT MAX( ZFAMDNO ) INTO W_MAX_ZFAMDNO
          FROM ZTREQST
         WHERE ZFREQNO = ZTREQHD-ZFREQNO
           AND ZFDOCST = 'O'
           OR  ZFREQNO = ZTREQHD-ZFREQNO
           AND ZFDOCST = 'A'.

        SELECT SINGLE *
          FROM ZTREQST
         WHERE ZFREQNO = ZTREQHD-ZFREQNO
           AND ZFAMDNO = W_MAX_ZFAMDNO.

        MOVE: ZTREQST-ZFAMDNO  TO IT_TAB-W_AMDNO,
              ZTREQST-ZFOPNDT  TO IT_TAB-ZFOPNDT.

        SELECT SINGLE NAME1 INTO IT_TAB-ZFOPBN_NM
                    FROM LFA1
              WHERE LIFNR = ZTREQHD-ZFOPBN.

        SELECT SINGLE NAME1 INTO IT_TAB-ZFBENI_NM
          FROM LFA1
         WHERE LIFNR = ZTREQHD-ZFBENI.

        SELECT MAX( ZFORIG ) INTO W_ZFORIG
          FROM ZTMLCSG7O
         WHERE ZFREQNO = ZTREQHD-ZFREQNO.

        SELECT SINGLE LANDX INTO IT_TAB-LANDX
           FROM T005T
          WHERE SPRAS EQ SY-LANGU
            AND LAND1 EQ W_ZFORIG.

        SELECT MAX( ZFACDO ) INTO IT_TAB-ZFACDO
           FROM ZTRECST
          WHERE ZFREQNO = ZTREQHD-ZFREQNO
            AND ZFCSCD = '1AB'.

        MOVE ZTREQHD-EBELN    TO IT_TAB-EBELN.
        MOVE ZTREQHD-INCO1    TO IT_TAB-INCO1.
        MOVE ZTREQHD-ZFREQTY  TO IT_TAB-ZFREQTY.
        MOVE ZTREQHD-ZFREQNO  TO IT_TAB-ZFREQNO.
        MOVE ZTREQHD-ZFLASTAM TO IT_TAB-ZFLASTAM.
        MOVE ZTREQHD-ZFOPNNO  TO IT_TAB-ZFOPNNO.
        MOVE ZTREQHD-ZFBENI   TO IT_TAB-ZFBENI.
        MOVE ZTREQHD-ZFOPBN   TO IT_TAB-ZFOPBN.
        PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDDOCST'
                                             ZTINS-ZFDOCST
                                   CHANGING  IT_TAB-DOCST.
        PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDTRANS'
                                             ZTINS-ZFTRANS
                                   CHANGING  IT_TAB-TRANS.

        APPEND IT_TAB.

  ENDSELECT.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
     W_ERR_CHK = 'Y'.  MESSAGE S738.    EXIT.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIMR17'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMR17'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   SORT IT_TAB BY EBELN.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P2000_PAGE_CHECK.
      PERFORM P3000_LINE_WRITE.
      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.

   ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  IF SY-LANGU EQ '3'.
     PERFORM   P3000_TITLE_WRITE.
  ELSE.
     PERFORM   P3000_TITLE_WRITE_EN.
  ENDIF.
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE: / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / 'Total', W_COUNT, 'Case'.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE:/ SY-VLINE, (20)IT_TAB-ZFOPNNO,       "L/C���ι�ȣ.
          SY-VLINE, (7)IT_TAB-ZFOPBN,         "��������.
                    (12)IT_TAB-ZFOPBN_NM(20), "���������.
          SY-VLINE, (8)IT_TAB-INCO1,          "Incorterms.
          SY-VLINE, (10)IT_TAB-ZFOPNDT,       "������.
          SY-VLINE, (14)IT_TAB-ZFSHCUNM,      "������.
          SY-VLINE, (5)IT_TAB-WAERS,(13) IT_TAB-ZFLASTAM
                    CURRENCY IT_TAB-WAERS,    "�����ݾ�.
          SY-VLINE, (15)IT_TAB-ZFDSOG1,       "��ǰ.
          SY-VLINE, (10)IT_TAB-ZFREQNO,       "�����Ƿڰ�����ȣ.
          SY-VLINE.
* Hide
  HIDE : IT_TAB.

  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE : / SY-VLINE, (20)IT_TAB-ZFINNO,         "�������ǹ�ȣ.
            SY-VLINE, (7)IT_TAB-ZFBENI,          "Beneficiary.
                      (12)IT_TAB-ZFBENI_NM(20),  "Beneficiary��.
            SY-VLINE, (8)IT_TAB-ZFREQTY,         "��������.
            SY-VLINE, (10)IT_TAB-ZFINSDT,        "������.
            SY-VLINE, (14)IT_TAB-ZFARCUNM,       "������.
            SY-VLINE, (5)IT_TAB-ZFKRW,(13)IT_TAB-ZFKRWAMT
                       CURRENCY IT_TAB-ZFKRW,    "�����(��).
            SY-VLINE, (15)IT_TAB-LANDX,          "������.
            SY-VLINE, (10)IT_TAB-ZFINSEQ,         " Seq.
            SY-VLINE.
*hide.
   HIDE : IT_TAB.

  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
  WRITE : / SY-VLINE, (20)IT_TAB-EBELN,          "P/O NO.
            SY-VLINE, (7)IT_TAB-ZFOPCD,          "����ȸ��.
                      (12)IT_TAB-ZFINCOM_NM(20), "����ȸ���.
            SY-VLINE, (8)IT_TAB-TRANS,           "��۱���.
            SY-VLINE, (10)IT_TAB-ZFINRT
                           RIGHT-JUSTIFIED,        "AIR ����.
            SY-VLINE, (14)IT_TAB-DOCST,
            SY-VLINE, (5)IT_TAB-ZFINAMTC,(13)IT_TAB-ZFINAMT
                      CURRENCY IT_TAB-ZFINAMTC,   "�����($).
            SY-VLINE, (15)IT_TAB-ZFCNCDNM,        "�κ�����.
            SY-VLINE, (10)IT_TAB-ZFACDO,          "��ǥ.
            SY-VLINE.

*hide.
  HIDE : IT_TAB-ZFREQNO, IT_TAB-ZFAMDNO, IT_TAB-W_AMDNO.
  W_COUNT = W_COUNT + 1.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING   P_ZFREQNO  P_ZFAMDNO.

   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
   EXPORT 'ZPREQNO'   TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPOPNNO'   TO MEMORY ID 'ZPOPNNO'.
   EXPORT 'BES'       TO MEMORY ID 'BES'.
   EXPORT 'ZPAMDNO'   TO MEMORY ID 'ZPAMDNO'.

   IF P_ZFAMDNO = '00000'.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_INS
*&---------------------------------------------------------------------*
FORM P2000_SHOW_INS USING    P_ZFREQNO
                             P_ZFINSEQ
                             P_ZFAMDNO.

   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPINSEQ'   FIELD P_ZFINSEQ.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
   EXPORT 'BES'       TO MEMORY ID 'BES'.
   EXPORT 'ZPOPNNO'   TO MEMORY ID 'ZPOPNNO'.
   EXPORT 'ZPREQNO'   TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPINSEQ'   TO MEMORY ID 'ZPINSEQ'.
   EXPORT 'ZPAMDNO'   TO MEMORY ID 'ZPAMDNO'.

   IF P_ZFAMDNO > '00000'.
      CALL TRANSACTION 'ZIM47' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM43' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_INS
*&---------------------------------------------------------------------*
*&      Form  P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
FORM P3000_CREATE_DOWNLOAD_FILE.

  REFRESH IT_TAB_DOWN.
  LOOP AT IT_TAB.
    CLEAR IT_TAB_DOWN.

    MOVE-CORRESPONDING IT_TAB TO IT_TAB_DOWN.
    WRITE : IT_TAB-ZFIVAMT CURRENCY IT_TAB-WAERS TO IT_TAB_DOWN-ZFIVAMT,
            IT_TAB-ZFLASTAM CURRENCY IT_TAB-WAERS TO
                                                  IT_TAB_DOWN-ZFLASTAM,
            IT_TAB-ZFKRWAMT CURRENCY IT_TAB-ZFKRW TO
                                                  IT_TAB_DOWN-ZFKRWAMT,
            IT_TAB-ZFINAMT CURRENCY IT_TAB-ZFINAMTC TO
                                                  IT_TAB_DOWN-ZFINAMT.

    APPEND IT_TAB_DOWN.
  ENDLOOP.

ENDFORM.                    " P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*&      Form  P1000_SET_BUKRS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_SET_BUKRS.

   DATA   : P_BUKRS    LIKE  ZTINS-BUKRS.

   CLEAR : ZTIMIMG00, P_BUKRS.
   SELECT SINGLE * FROM ZTIMIMG00.
   IF NOT ZTIMIMG00-ZFBUFIX IS INITIAL.
      MOVE  ZTIMIMG00-ZFBUKRS   TO  P_BUKRS.
   ENDIF.

*>> Company code SET.
    MOVE: 'I'          TO S_BUKRS-SIGN,
          'EQ'         TO S_BUKRS-OPTION,
          P_BUKRS      TO S_BUKRS-LOW.
    APPEND S_BUKRS.

ENDFORM.                    " P1000_SET_BUKRS
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE_EN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_TITLE_WRITE_EN.

  SKIP 2.

  WRITE : /57  '[ Insurance policy application ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 123 'Page : ', W_PAGE.

  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : /  SY-VLINE, (20) 'Approval No',
             SY-VLINE, (20) 'Open bank',
             SY-VLINE, (8) 'Incoterms',
             SY-VLINE, (10) 'Open date',
             SY-VLINE, (14) 'Loading port',
             SY-VLINE, (19) 'Open amount',
             SY-VLINE, (15) 'Goods descrip.',
             SY-VLINE, (10) 'Imp.Req.No',
             SY-VLINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /  SY-VLINE, (20)'Policy Number',
             SY-VLINE, (20)'Beneficiary',
             SY-VLINE, (8)'Payment',
             SY-VLINE, (10)'Effect.DT',
             SY-VLINE, (14)'Arriving port',
             SY-VLINE, (19)'Premium(Local)',
             SY-VLINE, (15)'Origin',
             SY-VLINE, (10)'Sequence',
             SY-VLINE.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  WRITE : / SY-VLINE, (20)'P/O NO.',
            SY-VLINE, (20)'Insurance Company',
            SY-VLINE, (8)'Trans.',
            SY-VLINE, (10)'Rate',
            SY-VLINE, (14)'Document Status',
            SY-VLINE, (19)'Premium',
            SY-VLINE, (15)'Insurance Cond.',
            SY-VLINE, (10)'Acct. Doc.',
            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE_EN
