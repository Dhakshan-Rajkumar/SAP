*&---------------------------------------------------------------------
*& Report  ZRIMMCCLLST
*&---------------------------------------------------------------------
*&  ���α׷��� : �����̳ʿ�� ��Ȳ
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.09.10
*&---------------------------------------------------------------------
*&   DESC.     :
*&
*&---------------------------------------------------------------------
*& [���泻��]
*&
*&---------------------------------------------------------------------
REPORT  ZRIMCCTLST  MESSAGE-ID ZIM
                    LINE-SIZE 111
                    NO STANDARD PAGE HEADING.
TABLES: ZTBLINR, ZTBL,ZTIDS,ZTIMIMG08, T001W,LFA1.
*----------------------------------------------------------------------
*  ����Ʈ�� INTERNAL TABLE
*----------------------------------------------------------------------
DATA : BEGIN OF IT_BL OCCURS 0,
       ZFBLNO       LIKE     ZTBL-ZFBLNO,     " B/L ������
       NAME1        LIKE     T001W-NAME1,     " �÷�Ʈ��.
       ZFTRCK       LIKE     ZTBL-ZFTRCK,
       ZFBNDT       LIKE     ZTBL-ZFBNDT,     " ���������.
       ZFRPTTY      LIKE     ZTBL-ZFRPTTY,    " ���ԽŰ�����.
       ZF20FT       LIKE     ZTBL-ZF20FT,
       ZF40FT       LIKE     ZTBL-ZF20FT,
       ZF20FT1      TYPE I,     " 20
       ZF20FT2      TYPE I,
       ZF20FT3      TYPE I,
       ZF20FT4      TYPE I,
       ZF20FT5      TYPE I,
       ZF20FT6      TYPE I,
       ZFL20FT      TYPE I,     " 20 FEET TOTAL.
       ZF40FT1      TYPE I,     " 40
       ZF40FT2      TYPE I,
       ZF40FT3      TYPE I,
       ZF40FT4      TYPE I,
       ZF40FT5      TYPE I,
       ZFL40FT      TYPE I,     " 40 FEET TOTAL.
       ZFWERKS      LIKE     ZTBL-ZFWERKS.    " PLANT
DATA : END OF IT_BL.

DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFWERKS      LIKE     ZTBL-ZFWERKS,    " PLANT
       ZFTRCK       LIKE     ZTBL-ZFTRCK,     " TRCK
       ZF20FT1      TYPE I,     " 20
       ZF20FT2      TYPE I,
       ZF20FT3      TYPE I,
       ZF20FT4      TYPE I,
       ZF20FT5      TYPE I,
       ZF20FT6      TYPE I,
       ZFL20FT      TYPE I,     " 20 FEET TOTAL.
       ZF40FT1      TYPE I,     " 40
       ZF40FT2      TYPE I,
       ZF40FT3      TYPE I,
       ZF40FT4      TYPE I,
       ZF40FT5      TYPE I,
       ZFL40FT      TYPE I.     " 40 FEET TOTAL.
DATA : END OF IT_TAB.

DATA :  W_ERR_CHK     TYPE C,
        W_LCOUNT      TYPE I,
        W_FIELD_NM    TYPE C,
        W_PAGE        TYPE I,
        W_TITLE(50),
        W_TITLE1(50),
        W_DOM_TEX1     LIKE DD07T-DDTEXT,
        W_FNAME        LIKE ZTIMIMG08-ZFCDNM,
        W_CHK_TITLE,
        W_PAGE_CHK,
        W_LINE        TYPE I,
        W_GUBUN(50),
        W_COUNT       TYPE I,
        W_SUBRC       LIKE SY-SUBRC,
        W_TABIX       LIKE SY-TABIX,
        W_ZFCLSEQ     LIKE ZTIDS-ZFCLSEQ,
        W_LIST_INDEX  LIKE SY-TABIX.

INCLUDE   ZRIMSORTCOM.    " REPORT Sort
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*----------------------------------------------------------------------
* Selection Screen ?
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS   FOR ZTBL-BUKRS NO-EXTENSION NO INTERVALS,
                   S_TRQDT   FOR ZTBL-ZFTRQDT,      " ��ۿ�û��.
                   S_BLSDP   FOR ZTBL-ZFBLSDP,       " �ۺ�ó.
                   S_WERKS   FOR ZTBL-ZFWERKS,      " PLANT,
                   S_TRCK    FOR ZTBL-ZFTRCK.       " ��ۻ�.
SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLSDP-LOW.
   PERFORM   P1000_BL_SDP_HELP(ZRIMBWGILST)  USING  S_BLSDP-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_BLSDP-HIGH.
   PERFORM   P1000_BL_SDP_HELP(ZRIMBWGILST)  USING  S_BLSDP-HIGH.


INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

*title Text Write
TOP-OF-PAGE.
 PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*----------------------------------------------------------------------
* START OF SELECTION ?
*----------------------------------------------------------------------
START-OF-SELECTION.
* ���� ���� ��?
   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* ���̺� SELECT
   PERFORM   P1000_READ_DATA USING W_ERR_CHK.
   IF W_ERR_CHK = 'Y'.
      MESSAGE S738.  EXIT.
   ENDIF.

* ����Ʈ Write
   PERFORM  P3000_DATA_WRITE.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*----------------------------------------------------------------------
* User Command
*----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
*      WHEN 'STUP' OR 'STDN'.         " SORT ����?
*         W_FIELD_NM = 'ZFWERKS'.
*         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
*         PERFORM HANDLE_SORT TABLES  IT_TAB
*                             USING   SY-UCOMM.
*    WHEN 'REFR'.
*          PERFORM P1000_READ_DATA.
*          PERFORM RESET_LIST.
     WHEN 'DISP'.
        IF W_TABIX IS INITIAL.
           MESSAGE S962.    EXIT.
        ENDIF.
        PERFORM P2000_TO_DISP_DETAIL USING IT_TAB-ZFWERKS
                                           IT_TAB-ZFTRCK.

     WHEN 'DOWN'.          " FILE DOWNLOAD....
          PERFORM P3000_TO_PC_DOWNLOAD.
  ENDCASE.
  CLEAR: IT_TAB, W_TABIX.

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------
FORM P3000_TITLE_WRITE.

  SKIP 1.
  IF W_PAGE_CHK EQ 'Y'.
     WRITE : /45 '[ �����̳ʿ�� ��Ȳ ]'
     COLOR COL_HEADING INTENSIFIED OFF.
     IF NOT S_TRQDT[] IS INITIAL.
        WRITE : / 'Date   : ', S_TRQDT-LOW,'~',S_TRQDT-HIGH.
     ENDIF.
     W_PAGE_CHK = 'N'.
  ENDIF.
  CLEAR LFA1.
  SELECT SINGLE *
    FROM LFA1
   WHERE LIFNR = IT_TAB-ZFTRCK.
  IF SY-SUBRC EQ 0.
     WRITE : /(06) IT_TAB-ZFTRCK,':',LFA1-NAME1.
  ELSE.
     WRITE: /(06)'���Է�'.
  ENDIF.
  WRITE : / SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,(25) '     ' NO-GAP CENTERED
            COLOR COL_NORMAL INTENSIFIED OFF,
            SY-VLINE NO-GAP,(13) '�������Ű�' NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '�ε����'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '�������'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '�ڰ��԰�'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '����â��'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(13) '��' NO-GAP CENTERED,
            SY-VLINE.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE :/ SY-VLINE,27 SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.

  WRITE : / SY-VLINE NO-GAP,(25) '   ' NO-GAP CENTERED
            COLOR COL_NORMAL INTENSIFIED OFF,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " ������.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " �ε����.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " �������.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " �ڰ��԰�.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " ����â��.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '20'  NO-GAP CENTERED, " ��.
            SY-VLINE NO-GAP,(06) '40'  NO-GAP CENTERED,
            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------
FORM P2000_AUTHORITY_CHECK USING    W_ERR_CHK.

   W_ERR_CHK = 'N'.
*----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*----------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_BL_MGT'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'B/L ���� Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK

*&---------------------------------------------------------------------
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------
FORM P1000_READ_DATA USING W_ERR_CHK.

  W_ERR_CHK = 'N'.

**  B/L
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_BL
      FROM ZTBL
     WHERE ZFRPTTY NE SPACE       " �����.
       AND BUKRS   IN S_BUKRS
       AND ZFTRQDT IN S_TRQDT     " �����̳ʿ�ۿ�û��.
       AND ZFBLSDP IN S_BLSDP     " �ۺ�ó.
       AND ZFTRCK  IN S_TRCK      " ��ۻ�.            " ����Ǿ
       AND ZFSHTY  EQ 'F'         " FULL CONTAINER.
       AND ZFWERKS IN S_WERKS.    " PLANT,

  IF SY-SUBRC <> 0.  W_ERR_CHK = 'Y'.   EXIT.    ENDIF.

 LOOP AT IT_BL.
     W_TABIX = SY-TABIX.
     CASE IT_BL-ZFRPTTY.
        WHEN  'A'.	" ������ ���.
          MOVE: IT_BL-ZF20FT  TO IT_BL-ZF20FT1,
                IT_BL-ZF40FT  TO IT_BL-ZF40FT1.
        WHEN  'D'.	" �ε�(����) ���.
          MOVE: IT_BL-ZF20FT  TO IT_BL-ZF20FT2,
                IT_BL-ZF40FT  TO IT_BL-ZF40FT2.
        WHEN  'B'.	" ������� ���.
          MOVE: IT_BL-ZF20FT  TO IT_BL-ZF20FT3,
                IT_BL-ZF40FT  TO IT_BL-ZF40FT3.
        WHEN  'N'.	" �ڰ���ġ�� ���.
          MOVE: IT_BL-ZF20FT  TO IT_BL-ZF20FT4,
                IT_BL-ZF40FT  TO IT_BL-ZF40FT4.
        WHEN  'W'.	" ������ġ�� ���.
          MOVE: IT_BL-ZF20FT  TO IT_BL-ZF20FT5,
                IT_BL-ZF40FT  TO IT_BL-ZF40FT5.
        WHEN OTHERS.
     ENDCASE.
     IT_BL-ZFL20FT =
        IT_BL-ZF20FT1 + IT_BL-ZF20FT2 + IT_BL-ZF20FT3 +
        IT_BL-ZF20FT4 + IT_BL-ZF20FT5.
     IT_BL-ZFL40FT =
        IT_BL-ZF40FT1 + IT_BL-ZF40FT2 + IT_BL-ZF40FT3 +
        IT_BL-ZF40FT4 + IT_BL-ZF40FT5.
     MODIFY IT_BL INDEX W_TABIX.
     MOVE-CORRESPONDING IT_BL TO IT_TAB.
     COLLECT IT_TAB.
  ENDLOOP.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
     MESSAGE S738.  W_ERR_CHK = 'Y'.EXIT.
  ENDIF.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE .

   SET TITLEBAR  'ZIMR64'.
   SET PF-STATUS 'ZIMR64'.
   SORT IT_TAB BY ZFTRCK.
   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      ON CHANGE OF IT_TAB-ZFTRCK.
        NEW-PAGE.
      ENDON.
      PERFORM   P3000_LINE_WRITE.
      AT LAST.
         PERFORM P3000_LINE_TOTAL.
      ENDAT.

   ENDLOOP.
   CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------
*&      Form  P2000_INIT
*&---------------------------------------------------------------------
FORM P2000_INIT.

  SET TITLEBAR  'ZIMR64'.
  W_PAGE_CHK = 'Y'.
  MOVE :    'I'          TO  S_TRQDT-SIGN,
            'BT'         TO  S_TRQDT-OPTION,
            SY-DATUM     TO  S_TRQDT-HIGH.
  CONCATENATE SY-DATUM(6) '01' INTO S_TRQDT-LOW.
  APPEND S_TRQDT.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
FORM P3000_LINE_WRITE.

  CLEAR  T001W.
  SELECT SINGLE *
   FROM  T001W
  WHERE  WERKS = IT_TAB-ZFWERKS.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE : / SY-VLINE NO-GAP,(04)IT_TAB-ZFWERKS,
            (20) T001W-NAME1     NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT1  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT1  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT2  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT2  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT3  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT3  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT4  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT4  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT5  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT5  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZFL20FT  NO-GAP,
            SY-VLINE NO-GAP,(06) IT_TAB-ZFL40FT  NO-GAP,
            SY-VLINE.
  HIDE : IT_TAB,W_TABIX.
  WRITE:/ SY-ULINE .

ENDFORM.

*&---------------------------------------------------------------------
*&      Form  P3000_LINE_TOTAL
*&---------------------------------------------------------------------
FORM P3000_LINE_TOTAL.

  WRITE:/ SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  SUM.
  WRITE :/ SY-VLINE NO-GAP,(25) '��         ��' NO-GAP CENTERED,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT1  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT1  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT2  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT2  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT3  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT3  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT4  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT4  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF20FT5  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZF40FT5  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZFL20FT  NO-GAP,
           SY-VLINE NO-GAP,(06) IT_TAB-ZFL40FT  NO-GAP,
           SY-VLINE.
  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LINE_TOTAL
*&---------------------------------------------------------------------
*&      Form  GET_ZTIIMIMG08_SELECT
*&---------------------------------------------------------------------
FORM GET_ZTIIMIMG08_SELECT USING  P_KEY
                                  P_ZFCD
                           CHANGING P_NAME.
  CLEAR ZTIMIMG08.
  SELECT SINGLE *
         FROM ZTIMIMG08
         WHERE ZFCDTY = P_KEY
           AND ZFCD =  P_ZFCD.

  P_NAME = ZTIMIMG08-ZFCDNM.

ENDFORM.                    " GET_ZTIIMIMG08_SELECT
*&---------------------------------------------------------------------
*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------
*
FORM RESET_LIST.

  W_CHK_TITLE = 1.
  MOVE 0 TO SY-LSIND.
  PERFORM   P3000_TITLE_WRITE.     " �ش� ���...
  PERFORM   P3000_DATA_WRITE.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------
*
*&      Form  P2000_TO_DISP_DETAIL
*&---------------------------------------------------------------------
*
FORM P2000_TO_DISP_DETAIL USING P_ZFWERKS P_ZFTRCK.

  DATA: SELTAB     TYPE TABLE OF RSPARAMS,
         SELTAB_WA  LIKE LINE OF SELTAB.

  IF NOT P_ZFWERKS IS  INITIAL.
      MOVE: 'S_WERKS'  TO SELTAB_WA-SELNAME,
         'S'        TO SELTAB_WA-KIND,      " SELECT-OPTION
         'I'        TO SELTAB_WA-SIGN,
         'EQ'       TO SELTAB_WA-OPTION,
         P_ZFWERKS  TO SELTAB_WA-LOW,
         SPACE      TO SELTAB_WA-HIGH.
     APPEND SELTAB_WA TO SELTAB.
  ENDIF.
*  IF NOT P_ZFTRCK IS INITIAL.
       MOVE: 'S_TRCK'   TO SELTAB_WA-SELNAME,
         'S'        TO SELTAB_WA-KIND,      " SELECT-OPTION
         'I'        TO SELTAB_WA-SIGN,
         'EQ'       TO SELTAB_WA-OPTION,
         P_ZFTRCK   TO SELTAB_WA-LOW,
         SPACE      TO SELTAB_WA-HIGH.
       APPEND SELTAB_WA TO SELTAB.
*  ENDIF.

**> ��������.
*  IF NOT S_IDSDT[] IS INITIAL.
*      LOOP AT S_IDSDT.
*         MOVE: 'S_IDSDT'      TO SELTAB_WA-SELNAME,
*            'S'            TO SELTAB_WA-KIND,      " SELECT-OPTION
*            S_IDSDT-SIGN   TO SELTAB_WA-SIGN,
*            S_IDSDT-OPTION TO SELTAB_WA-OPTION,
*            S_IDSDT-LOW    TO SELTAB_WA-LOW,
*            S_IDSDT-HIGH   TO SELTAB_WA-HIGH.
*        APPEND SELTAB_WA TO SELTAB.
*     ENDLOOP.
*  ENDIF.
*> ȸ���ڵ�.
  IF NOT S_BUKRS[] IS INITIAL.
      LOOP AT S_BUKRS.
         MOVE: 'S_BUKRS'         TO SELTAB_WA-SELNAME,
               'S'               TO SELTAB_WA-KIND,
               S_BUKRS-SIGN      TO SELTAB_WA-SIGN,
               S_BUKRS-OPTION    TO SELTAB_WA-OPTION,
               S_BUKRS-LOW       TO SELTAB_WA-LOW,
               S_BUKRS-HIGH      TO SELTAB_WA-HIGH.
        APPEND SELTAB_WA TO SELTAB.
      ENDLOOP.
  ENDIF.
*>> SELECTION ���� �Ѱ��ֱ�.

  IF NOT S_WERKS[] IS INITIAL.
      LOOP AT S_WERKS.
         MOVE: 'S_WERKS'      TO SELTAB_WA-SELNAME,
               'S'            TO SELTAB_WA-KIND,      " SELECT-OPTION
               S_WERKS-SIGN   TO SELTAB_WA-SIGN,
               S_WERKS-OPTION TO SELTAB_WA-OPTION,
               S_WERKS-LOW    TO SELTAB_WA-LOW,
               S_WERKS-HIGH   TO SELTAB_WA-HIGH.
         APPEND SELTAB_WA TO SELTAB.
      ENDLOOP.
  ENDIF.
  IF NOT S_TRCK[] IS INITIAL.
      LOOP AT S_TRCK.
         MOVE: 'S_TRCK'      TO SELTAB_WA-SELNAME,
               'S'            TO SELTAB_WA-KIND,      " SELECT-OPTION
               S_TRCK-SIGN   TO SELTAB_WA-SIGN,
               S_TRCK-OPTION TO SELTAB_WA-OPTION,
               S_TRCK-LOW    TO SELTAB_WA-LOW,
               S_TRCK-HIGH   TO SELTAB_WA-HIGH.
         APPEND SELTAB_WA TO SELTAB.
      ENDLOOP.
  ENDIF.
  IF NOT S_BLSDP[] IS INITIAL.
      LOOP AT S_TRCK.
         MOVE: 'S_BLSDP'      TO SELTAB_WA-SELNAME,
               'S'            TO SELTAB_WA-KIND,      " SELECT-OPTION
               S_BLSDP-SIGN   TO SELTAB_WA-SIGN,
               S_BLSDP-OPTION TO SELTAB_WA-OPTION,
               S_BLSDP-LOW    TO SELTAB_WA-LOW,
               S_BLSDP-HIGH   TO SELTAB_WA-HIGH.
         APPEND SELTAB_WA TO SELTAB.
      ENDLOOP.
  ENDIF.
  IF NOT S_TRQDT[] IS INITIAL.
      LOOP AT S_TRQDT.
         MOVE: 'S_TRQDT'      TO SELTAB_WA-SELNAME,
               'S'            TO SELTAB_WA-KIND,      " SELECT-OPTION
               S_TRQDT-SIGN   TO SELTAB_WA-SIGN,
               S_TRQDT-OPTION TO SELTAB_WA-OPTION,
               S_TRQDT-LOW    TO SELTAB_WA-LOW,
               S_TRQDT-HIGH   TO SELTAB_WA-HIGH.
         APPEND SELTAB_WA TO SELTAB.
      ENDLOOP.
  ENDIF.


  SUBMIT ZRIMCTDTLST
          WITH  SELECTION-TABLE SELTAB
          AND RETURN.

ENDFORM.                    " P2000_TO_DISP_DETAIL
