*&---------------------------------------------------------------------*
*& Report  ZRIMIDRLST                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �������                                              *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.07                                            *
*$     ����ȸ��: �Ѽ���
*&---------------------------------------------------------------------*
*&   DESC.     : ��������� ���ԽŰ��Ƿ��� �ڷ��� LIST.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMIDRLST   MESSAGE-ID ZIM
                     LINE-SIZE 181
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE   ZRIMIDRLSTTOP.
INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " Utility function ����.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BELN  FOR ZTIDR-ZFREBELN, " ����ȣ.
                   S_BLNO  FOR ZTBL-ZFBLNO,    " B/L ������ȣ.
                   S_HBLNO FOR ZTBL-ZFHBLNO,   " HOUSE B/L NO.
                   S_IDWDT FOR ZTIDR-ZFIDWDT,  " �Ű���.
                   S_INRC  FOR ZTIDR-ZFINRC,   " ����
                   S_CCNAM FOR ZTBL-ZFCCCNAM.  " ��������.
SELECTION-SCREEN END OF BLOCK B1.

* PARAMETER �ʱⰪ Setting
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_SET_PARAMETER.

* Title Text Write
TOP-OF-PAGE.
   PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

*  ���̺� SELECT
   PERFORM   P1000_GET_ZTIDR      USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'. MESSAGE S738.   EXIT.    ENDIF.
* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE       USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.  EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.
   CASE SY-UCOMM.
* SORT ����.
      WHEN 'STUP' OR 'STDN'.         " SORT ����.
         W_FIELD_NM = 'ZFIDRNO'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
      WHEN 'DISP'.                    " ���ԽŰ� ��ȸ.
            PERFORM P2000_SHOW_IDS USING  IT_TAB-ZFBLNO
                                          '001'.
      WHEN 'DSBL'.                    " B/L ��ȸ.
            PERFORM P2000_SHOW_BL USING  IT_TAB-ZFBLNO.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_CREATE_DOWNLOAD_FILE.
           PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
*  ���̺� SELECT
           PERFORM   P1000_GET_ZTIDR       USING   W_ERR_CHK.
           IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
           PERFORM RESET_LIST.
      WHEN OTHERS.
  ENDCASE.
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'ZIMR51'.          " TITLE BAR

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /80 '[ �� �� �� �� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /3 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
            (4)  '�Ϸ�'            NO-GAP,    SY-VLINE NO-GAP,
            (10) ' ��    �� '      NO-GAP,    SY-VLINE NO-GAP,
            (16) '�� �� �� ȣ'     NO-GAP,    SY-VLINE NO-GAP,
            (4)  '����'            NO-GAP,    SY-VLINE NO-GAP,
            (20) '�� �� �� ȣ'     NO-GAP,    SY-VLINE NO-GAP,
            (24) 'HOUSE  B/L ��ȣ' NO-GAP,    SY-VLINE NO-GAP,
            (19) '     ����ݾ�(WON)'         NO-GAP,
                                              SY-VLINE NO-GAP,
            (11) '�������'        NO-GAP,    SY-VLINE NO-GAP,
            (10)  '  ������  '     NO-GAP,    SY-VLINE NO-GAP,
            (10)  '  �Ű���  '     NO-GAP,    SY-VLINE NO-GAP,
            (20) '������'          NO-GAP,    SY-VLINE NO-GAP,
            (20) '�����'          NO-GAP,    SY-VLINE NO-GAP.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,
            (4)  '��ȣ'            NO-GAP,    SY-VLINE NO-GAP,
            (10) ' ��    ȣ '      NO-GAP,    SY-VLINE NO-GAP,
            (16) '�� �� �� ȣ'     NO-GAP,    SY-VLINE NO-GAP,
            (4)  '����'            NO-GAP,    SY-VLINE NO-GAP,
            (20) '�� (��) ��'      NO-GAP,    SY-VLINE NO-GAP,
            (24) 'MASTER B/L ��ȣ' NO-GAP,    SY-VLINE NO-GAP,
            (19) '             '   NO-GAP,    SY-VLINE NO-GAP,
            (11) '��    ��'        NO-GAP,    SY-VLINE NO-GAP,
            (10)  '  �԰���  '     NO-GAP,    SY-VLINE NO-GAP,
            (10)  '  ������  '     NO-GAP,    SY-VLINE NO-GAP,
            (20) '������'          NO-GAP,    SY-VLINE NO-GAP,
            (20) '      '          NO-GAP,    SY-VLINE NO-GAP.
  WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
FORM P2000_AUTHORITY_CHECK          USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.
*-----------------------------------------------------------------------
*  �ش� ȭ�� AUTHORITY CHECK
*-----------------------------------------------------------------------
  AUTHORITY-CHECK OBJECT 'ZI_LC_REL'
           ID 'ACTVT' FIELD '*'.

  IF SY-SUBRC NE 0.
      MESSAGE S960 WITH SY-UNAME '�Ƿ� Release Ʈ�����'.
      W_ERR_CHK = 'Y'.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'ZIMR51'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMR51'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.

      W_LINE = W_LINE + 1.
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
   PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

   IF W_COUNT GT 0.
      WRITE : / '��', W_COUNT, '��'.
   ENDIF.

ENDFORM.                    " P3000_LAST_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED ON.

   WRITE :/ SY-VLINE NO-GAP,
            (4)  W_LINE                 NO-GAP, SY-VLINE NO-GAP,
            (10) IT_TAB-ZFCCNO          NO-GAP, SY-VLINE NO-GAP,
            (16) IT_TAB-ZFINRNO         NO-GAP, SY-VLINE NO-GAP,
            (4)  IT_TAB-ZFSHNO CENTERED NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-ZFIDRNO         NO-GAP, SY-VLINE NO-GAP,
            (24) IT_TAB-ZFHBLNO         NO-GAP, SY-VLINE NO-GAP,
            (19) IT_TAB-ZFIVAMK CURRENCY 'KRW'  NO-GAP,
                                                SY-VLINE NO-GAP,
            (7)  IT_TAB-ZFPKCNT NO-ZERO NO-GAP,
            (1)  ' '                    NO-GAP,
            (3)  IT_TAB-ZFPKNM          NO-GAP, SY-VLINE NO-GAP,
            (10) IT_TAB-ZFENDT          NO-GAP, SY-VLINE NO-GAP,
            (10) IT_TAB-ZFIDWDT         NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-IN_NM           NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-ZFCCCNAM        NO-GAP, SY-VLINE NO-GAP.

* HIDE
   HIDE: IT_TAB.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE :/ SY-VLINE NO-GAP,
            (4)  '    '                 NO-GAP, SY-VLINE NO-GAP,
            (10) '    '                 NO-GAP, SY-VLINE NO-GAP,
            (16) IT_TAB-ZFREBELN        NO-GAP, SY-VLINE NO-GAP,
            (4)  '    '                 NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-ZFCARNM         NO-GAP, SY-VLINE NO-GAP,
            (24) IT_TAB-ZFMBLNO         NO-GAP, SY-VLINE NO-GAP,
            (19) '       '              NO-GAP, SY-VLINE NO-GAP,
            (8)  IT_TAB-ZFTOWT UNIT IT_TAB-ZFTOWTM NO-GAP,
            (3)  IT_TAB-ZFTOWTM         NO-GAP, SY-VLINE NO-GAP,
            (10) IT_TAB-ZFINDT          NO-GAP, SY-VLINE NO-GAP,
            (10) IT_TAB-ZFIDSDT         NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-EINDT           NO-GAP, SY-VLINE NO-GAP,
            (20) IT_TAB-PS_NM           NO-GAP, SY-VLINE NO-GAP.
   WRITE:/ SY-ULINE.
* HIDE
   HIDE: IT_TAB.
   W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IDS
*&---------------------------------------------------------------------*
FORM P2000_SHOW_IDS USING    P_ZFBLNO P_ZFCLSEQ.

   SET PARAMETER ID 'ZPBLNO'    FIELD  P_ZFBLNO.
   SET PARAMETER ID 'ZPCLSEQ'   FIELD  P_ZFCLSEQ.
   SET PARAMETER ID 'ZPHBLNO'   FIELD ''.
   SET PARAMETER ID 'ZPIDRNO'   FIELD ''.

   CALL TRANSACTION 'ZIM63' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_IDS

*&---------------------------------------------------------------------*
*&      Form  P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
FORM P3000_CREATE_DOWNLOAD_FILE.

*  REFRESH IT_TAB_DOWN.
*  LOOP AT IT_TAB.
*    CLEAR IT_TAB_DOWN.
*    MOVE-CORRESPONDING IT_TAB TO IT_TAB_DOWN.
*    WRITE : IT_TAB-MENGE   UNIT     IT_TAB-MEINS TO IT_TAB_DOWN-MENGE,
*        IT_TAB-ZFUSDAM CURRENCY IT_TAB-ZFUSD TO IT_TAB_DOWN-ZFUSDAM,
*         IT_TAB-ZFOPAMT CURRENCY IT_TAB-WAERS TO IT_TAB_DOWN-ZFOPAMT.
*    APPEND IT_TAB_DOWN.
*  ENDLOOP.

ENDFORM.                    " P3000_CREATE_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_ZTIDR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P1000_GET_ZTIDR  USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
  REFRESH IT_TAB.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM   ZTIDR
  WHERE  ZFREBELN    IN  S_BELN
  AND    ZFBLNO      IN  S_BLNO
  AND    ZFHBLNO     IN  S_HBLNO
  AND    ZFIDWDT     IN  S_IDWDT
  AND    ZFINRC      IN  S_INRC.

  IF SY-SUBRC NE 0. W_ERR_CHK = 'Y'. EXIT. ENDIF.

  LOOP  AT  IT_TAB.

     W_TABIX  =  SY-TABIX.

     " B/L DATA GET.
     CLEAR : ZTBL, ZTIDS, ZTIMIMG02.
     SELECT SINGLE * FROM   ZTBL
            WHERE  ZFBLNO   EQ   IT_TAB-ZFBLNO
            AND    ZFCCCNAM IN   S_CCNAM
            AND    ZFCCRST  EQ   'C'.
     IF SY-SUBRC NE 0.
        DELETE  IT_TAB  INDEX  W_TABIX.
        CONTINUE.
     ENDIF.

     MOVE : ZTBL-ZFCCNO     TO   IT_TAB-ZFCCNO,
            ZTBL-ZFSHNO     TO   IT_TAB-ZFSHNO,
            ZTBL-ZFHBLNO    TO   IT_TAB-ZFHBLNO,
            ZTBL-ZFMBLNO    TO   IT_TAB-ZFMBLNO,
            ZTBL-ZFCCCNAM   TO   IT_TAB-ZFCCCNAM,
            ZTBL-ZFPKCN     TO   IT_TAB-ZFPKCNT.

     WRITE  IT_TAB-ZFPKCNT  TO   IT_TAB-PKCT.

     " ����ݾ� GET.
     SELECT SUM( ZFIVAMK )  INTO  IT_TAB-ZFIVAMK
     FROM   ZTCIVIT
     WHERE  ZFBLNO          EQ    IT_TAB-ZFBLNO.
     IF SY-SUBRC NE 0 OR IT_TAB-ZFIVAMK IS INITIAL.
        SELECT SUM( ZFIVAMK ) INTO IT_TAB-ZFIVAMK
        FROM   ZTCIVIT
        WHERE  EBELN          EQ   IT_TAB-ZFREBELN
        AND    ZFPRPYN        EQ   'Y'.
     ENDIF.

     " ���� DATA GET.
     SELECT SINGLE * FROM  ZTIDS
            WHERE  ZFBLNO  EQ    IT_TAB-ZFBLNO.
     IF SY-SUBRC EQ 0.
        MOVE : ZTIDS-ZFIDRNO   TO  IT_TAB-ZFIDRNO,
               ZTIDS-ZFIDSDT   TO  IT_TAB-ZFIDSDT.
     ENDIF.

     " ������ GET.
     SELECT SINGLE * FROM  ZTIMIMG02
            WHERE  ZFCOTM   EQ    IT_TAB-ZFINRC
            AND    ZFWERKS  EQ    ZTBL-ZFWERKS.
     IF SY-SUBRC EQ 0.
        SELECT SINGLE NAME1  INTO  IT_TAB-IN_NM
        FROM   LFA1
        WHERE  LIFNR  EQ    ZTIMIMG02-ZFVEN.
     ELSE.
        CLEAR : IT_TAB-IN_NM.
     ENDIF.

     " ������ GET.
     SELECT * FROM  EKET UP TO 1 ROWS
              WHERE EBELN EQ IT_TAB-ZFREBELN
              ORDER BY EINDT.
        EXIT.
     ENDSELECT.
     IF SY-SUBRC EQ 0.
        MOVE  EKET-EINDT  TO  IT_TAB-EINDT.
     ELSE.
        CLEAR : IT_TAB-EINDT.
     ENDIF.

     " �������ڸ� GET!
     CLEAR : USR21, ADRP.
     SELECT SINGLE A~NAME_TEXT  INTO  IT_TAB-PS_NM
     FROM   ADRP  AS  A  INNER  JOIN  USR21 AS B
     ON     A~PERSNUMBER EQ     B~PERSNUMBER
     WHERE  B~BNAME      EQ     IT_TAB-ZFCCCNAM.

     MODIFY  IT_TAB  INDEX  W_TABIX.
  ENDLOOP.

ENDFORM.                    " P1000_GET_ZTIDR
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_BL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFBLNO  text
*----------------------------------------------------------------------*
FORM P2000_SHOW_BL  USING    P_ZFBLNO.

   SET PARAMETER ID 'ZPBLNO'    FIELD  P_ZFBLNO.
   SET PARAMETER ID 'ZPHBLNO'   FIELD ''.

   CALL TRANSACTION 'ZIM23' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_BL
