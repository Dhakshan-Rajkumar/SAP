*&--------------------------------------------------------------------
*& Report  ZRIMCTDTLST
*&--------------------------------------------------------------------
*&  ���α׷��� : �����̳� ��ۻ󼼳���.
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.09.06
*&--------------------------------------------------------------------
*&   DESC.     :
*&
*&--------------------------------------------------------------------
*& [���泻��]
*&
*&--------------------------------------------------------------------
REPORT  ZRIMCTDTLST  MESSAGE-ID ZIM
                       LINE-SIZE 107
                     NO STANDARD PAGE HEADING.
TABLES:  ZTBL,ZTIDS,ZTIMIMG08, T001W,ZTIDR,
         LFA1.
*---------------------------------------------------------------------
*  ����Ʈ�� INTERNAL TABLE
*---------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFBLNO     LIKE     ZTBL-ZFBLNO,     " B/L ������?
       ZFREBELN   LIKE     ZTBL-ZFREBELN,   " P/O No
       ZFHBLNO    LIKE     ZTBL-ZFHBLNO,    " HOUSE B/L ������?
       ZFBNDT     LIKE     ZTBL-ZFBNDT,     " ���������.
       ZFTRQDT    LIKE     ZTBL-ZFTRQDT,    " ��ۿ�û��.
       ZFAPRTC    LIKE     ZTBL-ZFAPRTC,    " PORT.
       ZFAPRT     LIKE     ZTBL-ZFAPRT,     "
       ZF20FT     LIKE     ZTBL-ZF20FT,
       ZF40FT     LIKE     ZTBL-ZF40FT,
       20FT       TYPE I,
       40FT       TYPE I,
       ZFPOYN     LIKE     ZTBL-ZFPOYN,     " ��ȯ����.
       POYN(04),
       ZFBLSDP    LIKE     ZTBL-ZFBLSDP,    " �ۺ�ó.
       BLSDP      LIKE     ZTIMIMG08-ZFCDNM," �ۺ�ó.
       ZFRPTTY    LIKE     ZTBL-ZFRPTTY,    " ���ԽŰ�����.
       RPTTY      LIKE     DD07T-DDTEXT,    " ���ԽŰ�����.
       ZFNEWT     LIKE     ZTBL-ZFNEWT,     " ���߷�.
       ZFNEWTM    LIKE     ZTBL-ZFNEWTM,    " UNIT.
       ZFWERKS    LIKE     ZTBL-ZFWERKS.    " PLANT
DATA : END OF IT_TAB.
DATA :  W_ERR_CHK     TYPE C,
        W_FIELD_NM    TYPE C,
        W_PAGE        TYPE I,
        W_TITLE(50),
        W_TITLE1(50),
        W_DOM_TEX1     LIKE DD07T-DDTEXT,
        W_FNAME        LIKE ZTIMIMG08-ZFCDNM,
        W_CHK_TITLE,
        W_LINE        TYPE I,
        L_COUNT       TYPE I,
        W_GUBUN(50),
        W_COUNT       TYPE I,
        W_DESC(12),
        W_LCOUNT       TYPE I,
        W_SUBRC       LIKE SY-SUBRC,
        W_TABIX       LIKE SY-TABIX,
        W_ZFCLSEQ     LIKE ZTIDS-ZFCLSEQ,
        W_LIST_INDEX  LIKE SY-TABIX.

INCLUDE   ZRIMSORTCOM.    " REPORT Sort
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*---------------------------------------------------------------------
* Selection Screen ?
*---------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS     FOR ZTBL-BUKRS NO-EXTENSION
                                               NO INTERVALS,
                   S_WERKS   FOR ZTBL-ZFWERKS,      " PLANT,
                   S_RPTTY   FOR ZTBL-ZFRPTTY,      " ���ԽŰ�����.
                   S_BLSDP   FOR ZTBL-ZFBLSDP,      " �ۺ�ó.
                   S_TRQDT   FOR ZTBL-ZFTRQDT,      " ��ۿ�û��.
                   S_TRCK    FOR ZTBL-ZFTRCK.
SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

*title Text Write
TOP-OF-PAGE.
 PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*---------------------------------------------------------------------
* START OF SELECTION ?
*---------------------------------------------------------------------
START-OF-SELECTION.
* ���� ���� ��?
   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* B/L ���̺� SELECT
   PERFORM   P1000_READ_DATA USING W_ERR_CHK.
   IF W_ERR_CHK = 'Y'.
      MESSAGE S738. EXIT.
   ENDIF.
* ����Ʈ Write
   PERFORM  P3000_DATA_WRITE.

*---------------------------------------------------------------------
* User Command
*---------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
       WHEN 'STUP' OR 'STDN'.         " SORT ����?
          W_FIELD_NM = 'ZFWERKS'.
          ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
          PERFORM HANDLE_SORT TABLES  IT_TAB
                              USING   SY-UCOMM.
     WHEN 'REFR'.
           W_LCOUNT = 0.
           PERFORM   P1000_READ_DATA USING W_ERR_CHK.
           PERFORM RESET_LIST.
     WHEN 'DISP1'.                       " B/L ��ȸ.
           IF W_TABIX EQ 0.
              MESSAGE S962.EXIT.
           ENDIF.
           PERFORM P2000_DISP_ZTBL(SAPMZIM09) USING IT_TAB-ZFBLNO.
     WHEN 'DISP2'.
          IF W_TABIX EQ 0.
              MESSAGE S962.EXIT.
          ENDIF.
          PERFORM P2000_DISP_ZTIV USING IT_TAB-ZFBLNO.
     WHEN 'DISP3'. " ���ԽŰ�.
           IF W_TABIX EQ 0.
              MESSAGE S962.EXIT.
           ENDIF.
           SELECT MAX( ZFCLSEQ ) INTO W_ZFCLSEQ
              FROM ZTIDR
              WHERE ZFBLNO  = IT_TAB-ZFBLNO.

           IF W_ZFCLSEQ = 0.
              MESSAGE S753. EXIT.
           ENDIF.
           PERFORM P2000_DISP_ZTIDR(SAPMZIM09) USING IT_TAB-ZFBLNO
                                                     W_ZFCLSEQ.
     WHEN 'DISP4'.                       " ���Ը���.
           IF W_TABIX EQ 0.
              MESSAGE S962.EXIT.
           ENDIF.
           SELECT MAX( ZFCLSEQ ) INTO W_ZFCLSEQ
              FROM ZTIDS
              WHERE ZFBLNO  = IT_TAB-ZFBLNO.
           IF W_ZFCLSEQ = 0.
              MESSAGE S782. EXIT.
           ENDIF.

           PERFORM P2000_DISP_ZTIDS(SAPMZIM09) USING IT_TAB-ZFBLNO
                                                      W_ZFCLSEQ.
     WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_TO_PC_DOWNLOAD.
  ENDCASE.

*&--------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&--------------------------------------------------------------------
FORM P3000_TITLE_WRITE.

   CLEAR  T001W.
   SELECT SINGLE *
          FROM  T001W
          WHERE  WERKS = S_WERKS-LOW.

   CLEAR LFA1.
   SELECT SINGLE *
          FROM LFA1
         WHERE LIFNR = S_TRCK-LOW.

  SKIP 1.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /45 '[���� �����̳ʿ�� �󼼳���]'
           COLOR COL_HEADING INTENSIFIED OFF.

  WRITE : / 'Plant :', S_WERKS-LOW,(20)T001W-NAME1,
          / 'Date  :', S_TRQDT-LOW, '~', S_TRQDT-HIGH,
          (02)'','��ۻ�:',S_TRCK-LOW, LFA1-NAME1.

  WRITE : / SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,(20) 'P/O No',
            SY-VLINE,(20) '���ԽŰ�����',
            SY-VLINE,(10) '���������',
            SY-VLINE,(10) '��ۿ�û��',
            SY-VLINE,(20) '������',
            SY-VLINE,(08) '20FT',
            SY-VLINE.


  FORMAT RESET.
  FORMAT COLOR COL_HEADING  INTENSIFIED OFF.
  WRITE : / SY-VLINE,(20) 'B/L NO',
            SY-VLINE,(20) '����ȯ����',
            SY-VLINE,(23) '���߷�',
            SY-VLINE,(20) '�ۺ�ó',
            SY-VLINE,(08) '40FT',
            SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE

*&--------------------------------------------------------------------
*&      Form  P2000_AUTHORITY_CHECK
*&--------------------------------------------------------------------
FORM P2000_AUTHORITY_CHECK USING    W_ERR_CHK.

   W_ERR_CHK = 'N'.
*---------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*---------------------------------------------------------------------
*   AUTHORITY-CHECK OBJECT 'ZI_BL_MGT'
*           ID 'ACTVT' FIELD '*'.
*
*   IF SY-SUBRC NE 0.
*      MESSAGE S960 WITH SY-UNAME 'B/L ���� Ʈ�����'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK

*&--------------------------------------------------------------------
*&      Form  P1000_GET_IT_TAB
*&--------------------------------------------------------------------
FORM P1000_READ_DATA USING W_ERR_CHK.

  W_ERR_CHK = 'N'.

*>>  B/L
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
     FROM ZTBL
     WHERE ZFWERKS IN S_WERKS     " PLANT,
       AND ZFRPTTY IN S_RPTTY     " ���ԽŰ�����.
       AND ZFRPTTY NE SPACE       " ���ԽŰ�����.
       AND BUKRS   IN S_BUKRS
       AND ZFBLSDP IN S_BLSDP     " �ۺ�ó.
       AND ZFTRCK  IN S_TRCK
       AND ZFSHTY  EQ 'F'         " FULL CONTAINER.
       AND ZFTRQDT IN S_TRQDT.
  IF SY-SUBRC <> 0.  W_ERR_CHK = 'Y'.   EXIT.    ENDIF.

  LOOP AT IT_TAB.
     W_TABIX = SY-TABIX.
     PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDRPTTY'
                                           IT_TAB-ZFRPTTY
                               CHANGING   IT_TAB-RPTTY.
*>> �ۺ�ó.
     CLEAR ZTIMIMG08.
     SELECT SINGLE *
            FROM ZTIMIMG08
           WHERE ZFCDTY = '012'
             AND ZFCD   = IT_TAB-ZFBLSDP.
     MOVE ZTIMIMG08-ZFCDNM TO IT_TAB-BLSDP.
*>> ��ȯ, ��ȯ ����.
     IF IT_TAB-ZFPOYN = 'Y'.
        IT_TAB-POYN = '��ȯ'.
     ELSE.
        IT_TAB-POYN = '��ȯ'.
     ENDIF.
     MOVE: IT_TAB-ZF20FT TO IT_TAB-20FT,
           IT_TAB-ZF40FT TO IT_TAB-40FT.
     MODIFY IT_TAB INDEX W_TABIX.
  ENDLOOP.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
     W_ERR_CHK = 'Y'. EXIT.
  ENDIF.

ENDFORM.                    " P1000_READ_DATA

*&--------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&--------------------------------------------------------------------
FORM P3000_DATA_WRITE .

   SET TITLEBAR  'DTCT'.
   SET PF-STATUS 'DTCT'.
   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      PERFORM   P3000_LINE_WRITE.
      AT LAST.
         PERFORM P3000_LINE_TOTAL.
      ENDAT.

   ENDLOOP.
   CLEAR: IT_TAB,W_TABIX.
ENDFORM.                    " P3000_DATA_WRITE
*&--------------------------------------------------------------------
*&      Form  P2000_INIT
*&--------------------------------------------------------------------
FORM P2000_INIT.

  SET TITLEBAR  'DTCT'.

ENDFORM.                    " P2000_INIT
*&--------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&--------------------------------------------------------------------
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE : / SY-VLINE,(20) IT_TAB-ZFREBELN,
            SY-VLINE,(20) IT_TAB-RPTTY,   " ���ԽŰ�����.
            SY-VLINE,(10) IT_TAB-ZFBNDT,  " ���������.
            SY-VLINE,(10) IT_TAB-ZFTRQDT,  " ��ۿ�û��.
            SY-VLINE,(20) IT_TAB-ZFAPRT,
            SY-VLINE,(08) IT_TAB-20FT,
            SY-VLINE.
  HIDE : IT_TAB,W_TABIX.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE : / SY-VLINE,(20) IT_TAB-ZFHBLNO,
            SY-VLINE,(20) IT_TAB-POYN,
            SY-VLINE,(23) IT_TAB-ZFNEWT UNIT IT_TAB-ZFNEWTM,
            SY-VLINE,(20) IT_TAB-BLSDP,
            SY-VLINE,(08) IT_TAB-40FT,
            SY-VLINE.
  HIDE : IT_TAB, W_TABIX.
  WRITE : / SY-ULINE.
  W_COUNT = W_COUNT + 1.

 ENDFORM.

*&--------------------------------------------------------------------
*&      Form  P3000_LINE_TOTAL
*&--------------------------------------------------------------------
FORM P3000_LINE_TOTAL.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  SUM.
  WRITE : / SY-VLINE,(20) 'T O T A L',
            '',(09) 'B/L�Ǽ�:',(10)W_COUNT,   " ���ԽŰ�����.
            '',(10)'' ,  " ���������.
           '',(10) '',  " ��ۿ�û��.
           '',(20) '',
           '',(08) IT_TAB-20FT,
            SY-VLINE.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL  INTENSIFIED OFF.
  WRITE : / SY-VLINE,(20) '',
            '',(20) '',
           '',(23) IT_TAB-ZFNEWT UNIT IT_TAB-ZFNEWTM,
            '',(20) '',
            '',(08) IT_TAB-40FT,
            SY-VLINE.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_LINE_TOTAL
*&--------------------------------------------------------------------
*&      Form  RESET_LIST
*&--------------------------------------------------------------------
FORM RESET_LIST.

  W_CHK_TITLE = 1.
  W_COUNT = 0.
  MOVE 0 TO SY-LSIND.
  PERFORM   P3000_TITLE_WRITE.     " �ش� ���...
  PERFORM   P3000_DATA_WRITE.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------
*
*&      Form  GET_ZTIIMIMG08_SELECT
*&---------------------------------------------------------------------
*
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
*&      Form  P2000_DISP_ZTIV
*&---------------------------------------------------------------------
*
FORM P2000_DISP_ZTIV USING    P_ZFBLNO.

   SELECT COUNT( * ) INTO W_COUNT
      FROM ZTIV
     WHERE ZFBLNO = P_ZFBLNO.

   IF W_COUNT = 0.
      MESSAGE S679 WITH  P_ZFBLNO.
      EXIT.
   ENDIF.

   SET PARAMETER ID 'ZPIVNO'  FIELD ''.
   SET PARAMETER ID 'ZPHBLNO' FIELD ''.
   SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.

   CALL TRANSACTION 'ZIM33'  AND SKIP  FIRST SCREEN.


ENDFORM.                    " P2000_DISP_ZTIV
