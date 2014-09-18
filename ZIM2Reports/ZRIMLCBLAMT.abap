*&---------------------------------------------------------------------*
*& Report  ZRIMLCBLAMT                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : L/C �ܾ� ����Ʈ                                       *
*&      �ۼ��� : �ͼ�ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.12.05                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : L/C �ݾ׿��� B/L �ݾ��� ������ �ܾ��� ��ȸ�Ѵ�.
*&---------------------------------------------------------------------*
*& [���泻��]
*&---------------------------------------------------------------------*
REPORT ZRIMLCBLAMT   MESSAGE-ID ZIM
                     NO STANDARD PAGE HEADING
                     LINE-SIZE 175.

*-----------------------------------------------------------------------
* Variable Declarartion.
*-----------------------------------------------------------------------
TABLES : LFA1,
         ZTREQHD,                      " �����Ƿ� Header Table.
         ZTREQST,                      " �����Ƿ� Status Table.
         ZTREQIT,                      " �����Ƿ� Item Table.
         ZTBL,                         " B/L Header Table.
         ZTBLIT.                       " B/L Item Table.
TYPE-POOLS : SLIS.

DATA : BEGIN OF IT_TAB OCCURS 0,
       BUKRS           LIKE   ZTREQHD-BUKRS,      " ȸ���ڵ�.
       ZFREQNO         LIKE   ZTREQHD-ZFREQNO,    " �����Ƿ� ������ȣ.
       EBELN           LIKE   ZTREQHD-EBELN,      " ���Ź��� ��ȣ.
       ZTERM           LIKE   ZTREQHD-ZTERM,      " ��������.
       ZFOPNNO         LIKE   ZTREQHD-ZFOPNNO,    " �ſ��� ���ι�ȣ.
       ZFOPNDT         LIKE   ZTREQST-ZFOPNDT,    " ��������.
       ZFAMDNO         LIKE   ZTREQST-ZFAMDNO,    " Amend Seq.
       ZFOPBN          LIKE   ZTREQHD-ZFOPBN,     " �������� �ڵ�.
       ZFOPBN_NM(35)   TYPE   C,
       WAERS           LIKE   ZTREQHD-WAERS,      " ��ȭŰ.
       ZFLASTAM        LIKE   ZTREQHD-ZFLASTAM,   " ���������ݾ�.
       ZFBENI          LIKE   ZTREQHD-ZFBENI,     " Beneficiary
       NAME1(35)       TYPE   C,
       ZFREQTY         LIKE   ZTREQHD-ZFREQTY,    " �����Ƿ� Type.
       ZFBLNO          LIKE   ZTBLIT-ZFBLNO,      " B/L ������ȣ.
       ZFHBLNO         LIKE   ZTBL-ZFHBLNO,       " House B/L No.
       ZFBLAMC         LIKE   ZTBL-ZFBLAMC,       " B/L �ݾ� ��ȭ.
       ZFBLAMT         LIKE   ZTBL-ZFBLAMT,       " B/L �ݾ�.
       ZFLCAMT         LIKE   ZTBL-ZFBLAMT,       " L/C �ܷ�.
       W_ZFLCBL        TYPE   C.
DATA : END OF IT_TAB.

DATA : W_PROG LIKE SY-REPID,
       GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
       G_REPID LIKE SY-REPID,
       G_LAYOUT TYPE SLIS_LAYOUT_ALV,
       LS_FIELDCAT  TYPE SLIS_FIELDCAT_ALV.

DATA : V_COLUMN(30)      TYPE C,                  " Column Name
       V_COUNT(2)        TYPE C,                  " Page Count
       V_PRODS(1)        TYPE C,                  " �⺻/������
       POS               TYPE I,
       V_ITAB(10)        TYPE C,
       V_LINE            TYPE I,
       V_DIV             TYPE I,
       V_PCNT            TYPE I,
       V_OLD_PCNT        TYPE I,
       V_CPCNT(3)        TYPE C.

DATA: W_ERR_CHK(1)      TYPE C,
      W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
      W_PAGE            TYPE I,             " Page Counter
      W_LINE            TYPE I,             " �������� LINE COUNT
      W_COUNT           TYPE I,             " ��ü COUNT
      W_MOD             TYPE I,
      W_LIST_INDEX      LIKE SY-TABIX,
      W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
      W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
      W_UPDATE_CNT      TYPE I,
      W_BUTTON_ANSWER   TYPE C.
DATA: W_ZFREQNO         LIKE ZTREQHD-ZFREQNO.
DATA: W_ZFLCAMT         LIKE ZTBL-ZFBLAMT.

*-----------------------------------------------------------------------
* SELECTION SCREEN.
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_BUKRS  FOR ZTREQHD-BUKRS NO-EXTENSION
                             NO INTERVALS DEFAULT 'PSC',
                S_BELN   FOR ZTREQHD-EBELN,         " ���Ź���.
                S_OPNNO  FOR ZTREQHD-ZFOPNNO,       " L/C ��ȣ.
                S_REQNO  FOR ZTREQHD-ZFREQNO,       " �����Ƿڹ�ȣ.
                S_ZTERM  FOR ZTREQHD-ZTERM,         " ��������.
                S_OPBN   FOR ZTREQHD-ZFOPBN,        " ��������.
                S_OPNDT  FOR ZTREQST-ZFOPNDT.       " ��������.
SELECTION-SCREEN END OF BLOCK B1.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
  SET TITLEBAR  'ZIMR88'.                 " GUI TITLE SETTING..

*-----------------------------------------------------------------------
* TOP-OF-PAGE.
*-----------------------------------------------------------------------
TOP-OF-PAGE.

*-----------------------------------------------------------------------
* START OF SELECTION.
*-----------------------------------------------------------------------
START-OF-SELECTION.

  SET TITLEBAR  'ZIMR88'.                " GUI TITLE SETTING..
  SET PF-STATUS 'ZIMR88'.                " GUI STATUS SETTING

* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_TEXT     USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'. EXIT.    ENDIF.

* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE   USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.  EXIT.  ENDIF.

*&----------------------------------------------------------------------
*&      Form  P3000_APPEND_FIELDCAT
*&----------------------------------------------------------------------
FORM P3000_APPEND_FIELDCAT.

  CLEAR: GT_FIELDCAT, POS.
  PERFORM P3000_FMAKE USING 'ZFREQNO'   '�����Ƿ�'           10 'C200'.
  PERFORM P3000_FMAKE USING 'ZFAMDNO'   'Amend'               5 'C200'.
  PERFORM P3000_FMAKE USING 'ZFOPNNO'   'L/C No.'            20 'C200'.
  PERFORM P3000_FMAKE USING 'ZFOPNDT'   '������'             10 'C200'.
  PERFORM P3000_FMAKE USING 'ZFOPBN_NM' '��������'           20 'C200'.
  PERFORM P3000_FMAKE USING 'WAERS'     '��ȭ'                4 'C200'.
  PERFORM P3000_FMAKE USING 'ZFLASTAM'  'L/C �����ݾ�'       15 'C200'.
  PERFORM P3000_FMAKE USING 'ZFBLNO'    'B/L No.'            10 'C200'.
  PERFORM P3000_FMAKE USING 'ZFHBLNO'   'House B/L No.'      15 'C200'.
  PERFORM P3000_FMAKE USING 'ZFBLAMC'   '��ȭ'                4 'C200'.
  PERFORM P3000_FMAKE USING 'ZFBLAMT'   'B/L �ݾ�'           15 'C200'.
  PERFORM P3000_FMAKE USING 'ZFLCAMT'   'L/C �ܾ�'           15 'C500'.
  PERFORM P3000_FMAKE USING 'NAME1'     'Beneficiary'        20 'C200'.

ENDFORM.                    " P3000_APPEND_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH : IT_TAB.

  SELECT *
    FROM ZTREQHD
   WHERE BUKRS      IN S_BUKRS
     AND EBELN      IN S_BELN
     AND ZFOPNNO    IN S_OPNNO
     AND ZFREQNO    IN S_REQNO
     AND ZTERM      IN S_ZTERM
     AND ZFOPBN     IN S_OPBN
     AND ZFOPNNO    NE SPACE.

    IF SY-SUBRC EQ 0.
      MOVE-CORRESPONDING ZTREQHD TO IT_TAB.

* �������� Name Select.
      CLEAR LFA1.
      SELECT SINGLE *
               FROM LFA1
              WHERE LIFNR = IT_TAB-ZFOPBN.
      MOVE LFA1-NAME1 TO IT_TAB-ZFOPBN_NM.

* Beneficiary Name Select.
      CLEAR LFA1.
      SELECT SINGLE *
               FROM LFA1
              WHERE LIFNR = IT_TAB-ZFBENI.
      MOVE LFA1-NAME1 TO IT_TAB-NAME1.

* �����Ƿ� ���� Table Select.
      SELECT *
        FROM ZTREQST
       WHERE ZFREQNO EQ IT_TAB-ZFREQNO
         AND ZFOPNDT IN S_OPNDT
         AND ZFAMDNO = ( SELECT MAX( ZFAMDNO )
                 FROM ZTREQST
                WHERE ZFREQNO = IT_TAB-ZFREQNO ).

        MOVE-CORRESPONDING ZTREQST TO IT_TAB.

* B/L Item Table Select..
        SELECT *
          FROM ZTBLIT
         WHERE ZFREQNO = IT_TAB-ZFREQNO.
          MOVE-CORRESPONDING ZTBLIT TO IT_TAB.

          SELECT SINGLE *
                   FROM ZTBL
                  WHERE ZFBLNO = IT_TAB-ZFBLNO.

          ZTBL-ZFBLAMT = ZTBLIT-BLMENGE * ZTBLIT-NETPR.
          MOVE-CORRESPONDING ZTBL TO IT_TAB.
          IT_TAB-ZFLCAMT = IT_TAB-ZFLASTAM - IT_TAB-ZFBLAMT.
          IF SY-SUBRC EQ 0.
            APPEND IT_TAB.
          ENDIF.
        ENDSELECT.
      ENDSELECT.
    ENDIF.
  ENDSELECT.

  SORT IT_TAB BY ZFREQNO ZFAMDNO ZFOPNNO ASCENDING.

  CLEAR: W_ZFREQNO.
  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX - 1.
    IF W_ZFREQNO = IT_TAB-ZFREQNO.
      IT_TAB-ZFLCAMT = W_ZFLCAMT - IT_TAB-ZFBLAMT.
      MODIFY IT_TAB INDEX SY-TABIX.
      DELETE IT_TAB INDEX W_TABIX.
    ENDIF.
    MOVE IT_TAB-ZFREQNO TO W_ZFREQNO.
    MOVE IT_TAB-ZFLCAMT TO W_ZFLCAMT.
  ENDLOOP.
ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    W_ERR_CHK.

  MOVE 'N' TO W_ERR_CHK.

  PERFORM P3000_APPEND_FIELDCAT.      " ALV Report TiTle.

  G_REPID = SY-REPID.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
           I_CALLBACK_PROGRAM       = G_REPID
*          I_CALLBACK_PF_STATUS_SET = G_STATUS
*          I_CALLBACK_USER_COMMAND  = G_USER_COMMAND
           IS_LAYOUT                = G_LAYOUT
           IT_FIELDCAT              = GT_FIELDCAT[]
       TABLES
           T_OUTTAB                 = IT_TAB
       EXCEPTIONS
           PROGRAM_ERROR            = 1
           OTHERS                   = 2.
  IF SY-SUBRC <> 0.
    MESSAGE E988 WITH 'Grid Dispaly ���� ������ �߻��Ͽ����ϴ�.'.
  ENDIF.


ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  p3000_fmake
*&---------------------------------------------------------------------*
FORM P3000_FMAKE USING    FIELD TEXT LEN EMP.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = FIELD.
  LS_FIELDCAT-SELTEXT_M      = TEXT.
  LS_FIELDCAT-OUTPUTLEN      = LEN.
  LS_FIELDCAT-EMPHASIZE      = EMP.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.                    " p3000_field_make
