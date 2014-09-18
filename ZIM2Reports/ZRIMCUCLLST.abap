*&---------------------------------------------------------------------*
*& Report  ZRIMCUCLLST                                                 *
*&---------------------------------------------------------------------*
*&  Program Name : Customs Clearance Progress Status                   *
*&  Created By   : Na Hyun Ju  INFOLINK Ltd.                           *
*&  Created on   : 2001.09.30                                          *
*&---------------------------------------------------------------------*
*&   DESC.       : Customs Clearance Progress DIsplay
*&
*&---------------------------------------------------------------------*
*& [Change Log]
*&
*&---------------------------------------------------------------------*
REPORT ZRIMCUCLLST   MESSAGE-ID ZIM
                     LINE-SIZE 176
                     NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* TABLE & INTERNAL TABLE, Variable Define
*-----------------------------------------------------------------------
TABLES : ZTCGHD,
         ZTCGIT,
         ZTMSHD ,
         ZTREQHD,
         ZTREQST,
         ZTBLINR,
         ZVIVHD_IT,
         ZTIDSUS,
         ZVBLIT,
         MARA,
         LFA1,
         EKPO,
         ZTIDS,
         ZTIV,
         ZTIVIT,
         ZTIVHST,
         ZTIMIMG00,
         ZTBL,
         ZTBLIT,
         T024.

DATA : BEGIN OF IT_ZVBLIT OCCURS 0.
       INCLUDE STRUCTURE ZVBLIT.
DATA : END   OF IT_ZVBLIT.

DATA : BEGIN OF IT_ZVIVIT OCCURS 0.
       INCLUDE STRUCTURE ZVIVHD_IT.
DATA : END   OF IT_ZVIVIT.

DATA : BEGIN OF IT_MSNO OCCURS 0,
       ZFMSNO   LIKE   ZTMSHD-ZFMSNO.
DATA : END   OF IT_MSNO.

DATA : BEGIN OF IT_SELECTED OCCURS 0,
       ZFBLNO   LIKE ZTBL-ZFBLNO,
       ZFCGNO   LIKE ZTCGHD-ZFCGNO,
END OF IT_SELECTED.

DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFIVNO          LIKE   ZTIV-ZFIVNO,
       ZFCLSEQ         LIKE   ZTIDSUS-ZFCLSEQ,
       ZFMBLNO         LIKE   ZTBL-ZFMBLNO,
       ZFCGHNO         LIKE   ZTBL-ZFCGHNO,
       ZFEDT           LIKE   ZTIDSUS-ZFEDT,
       ZFMSNO          LIKE   ZTCGHD-ZFMSNO,
       WERKS           LIKE   ZTCGHD-WERKS,
       LGORT           LIKE   ZTIVIT-LGORT,
       ZFCCDT          LIKE   ZTIV-ZFCCDT,
       ZFCUNAM         LIKE   ZTIV-ZFCUNAM,
       ERNAM           LIKE   ZTIV-ERNAM,
       LGOBE           LIKE   T001L-LGOBE,
       NAME(15)        TYPE   C,
       ZFKEYM          LIKE   ZTCGHD-ZFKEYM,
       CDAT            LIKE   ZTCGHD-CDAT,
       ZFREQNO         LIKE   ZTCGIT-ZFREQNO,
       ZFOPNNO         LIKE   ZTREQST-ZFOPNNO,
       ZFBLNO          LIKE   ZTCGIT-ZFBLNO,
       ZFHBLNO         LIKE   ZTBL-ZFHBLNO,
       MATNR           LIKE   ZTCGIT-MATNR,
       TXZ01           LIKE   ZTBLIT-TXZ01,
       NAME2(20)       TYPE   C,
       ZFCUT           LIKE   ZTIV-ZFCUT,
       EBELN           LIKE   ZTBLIT-EBELN,
       EBELP           LIKE   ZTBLIT-EBELP,
       MEINS           LIKE   ZTBLIT-MEINS,
       CGMENGE         LIKE   ZTCGIT-CGMENGE,
       CCMENGE         LIKE   ZTIVIT-CCMENGE,
       CCMENGE1        LIKE   ZTIVIT-CCMENGE,
       GRMENGE         LIKE   ZTIVIT-GRMENGE,
       NETPR           LIKE   ZTBLIT-NETPR,
       PEINH           LIKE   ZTBLIT-PEINH,
       BPRME           LIKE   ZTBLIT-BPRME,
       ZFBLAMT         LIKE   ZTBL-ZFBLAMT,
       ZFBLAMC         LIKE   ZTBL-ZFBLAMC,
       ZFNOCCMN        LIKE   ZSIVIT-ZFNOCCMN,
       ZFBNARCD        LIKE   ZTCGIT-ZFBNARCD,
       NAME3(15)       TYPE   C,
       ZFMSNM          LIKE   ZTMSHD-ZFMSNM,
       EKGRP           LIKE   ZTMSHD-EKGRP,
       NAME4(20)       TYPE   C,
       LIFNR           LIKE   ZTREQHD-LIFNR,
       NAME1           LIKE   LFA1-NAME1,
       ZFBLIT          LIKE   ZTBLIT-ZFBLIT,
       ZFINDT          LIKE   ZTBL-ZFINDT,
       MBLNR           LIKE   ZTIVHST-MBLNR,
       MJAHR           LIKE   ZTIVHST-MJAHR,
       BLMENGE         LIKE   ZTBLIT-BLMENGE.
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
* Variable Define
*-----------------------------------------------------------------------
DATA : W_ERR_CHK         TYPE  C,
       W_PAGE            TYPE  I,
       W_LINE            TYPE  I,
       W_FLAG            TYPE  C,
       W_COUNT           TYPE  I,
       W_COLOR           TYPE  I,
       W_LIST_INDEX      LIKE  SY-TABIX,
       W_TABIX           LIKE  SY-TABIX,
       W_LINES           TYPE  I,
       W_SELECTED_LINES  TYPE  P,
       W_JUL             TYPE  C,
       W_SUBRC           LIKE  SY-SUBRC,
       W_FIELD_NM        LIKE  DD03D-FIELDNAME,
       W_ZFBLIT          LIKE  ZTBLIT-ZFBLIT,
       W_LIFNR           LIKE  LFA1-LIFNR,
       P_BUKRS           LIKE  ZTIV-BUKRS.

INCLUDE   ZRIMUTIL01.
INCLUDE   ZRIMSORTCOM.

*-----------------------------------------------------------------------
* Selection Screen
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS  FOR ZTIV-BUKRS  NO-EXTENSION NO INTERVALS,
                   S_CCDT   FOR ZTIV-ZFCCDT,
                   S_IDSDT  FOR ZTIDS-ZFIDSDT,
                   S_EKORG  FOR ZTBL-EKORG,
                   S_EKGRP  FOR ZTBL-EKGRP,
                   S_CUNAM  FOR ZTIV-ZFCUNAM,
                   S_ZFCUT  FOR ZTIV-ZFCUT,
                   S_MATKL  FOR MARA-MATKL,
                   S_MATNR  FOR ZTIVIT-MATNR,
                   S_WERKS  FOR ZTBLIT-WERKS.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-R01.
  SELECTION-SCREEN : BEGIN OF LINE,
                     COMMENT 01(31) TEXT-R01.
    SELECTION-SCREEN : COMMENT 33(4) TEXT-R04.
    PARAMETERS : P_ALL RADIOBUTTON GROUP RDG.
    SELECTION-SCREEN : COMMENT 42(13) TEXT-R02.
    PARAMETERS : P_YES RADIOBUTTON GROUP RDG.
    SELECTION-SCREEN : COMMENT 63(11) TEXT-R03.
    PARAMETERS : P_NO  RADIOBUTTON GROUP RDG.
  SELECTION-SCREEN : END OF LINE.
SELECTION-SCREEN END OF BLOCK B3.

*-----------------------------------------------------------------------
* Initialization.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET  TITLEBAR 'ZIMR49'.
   PERFORM   P1000_SET_BUKRS.
   PERFORM   P2000_INIT.

*-----------------------------------------------------------------------
* Top-Of-Page.
*-----------------------------------------------------------------------
TOP-OF-PAGE.
  IF SY-LANGU EQ '3'.
     PERFORM   P3000_TITLE_WRITE.
  ELSE.
     PERFORM   P3000_TITLE_WRITE_EN.
  ENDIF.
*-----------------------------------------------------------------------
* Start Of Selection
*-----------------------------------------------------------------------
START-OF-SELECTION.

* Import System Configuration Check
  PERFORM   P2000_CONFIG_CHECK     USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* TABLE SELECT
  PERFORM   P1000_READ_TABLE        USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* Write
  PERFORM   P3000_DATA_WRITE       USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.

     WHEN 'STUP' OR 'STDN'.
           W_FIELD_NM = 'ZFBLNO'.
           ASSIGN  W_FIELD_NM  TO <SORT_FIELD>.
           PERFORM HANDLE_SORT TABLES IT_TAB
                               USING  SY-UCOMM.
           PERFORM RESET_LIST.
      WHEN 'ZIM23'.
         IF IT_TAB-ZFBLNO IS INITIAL.
            MESSAGE S962.
         ELSE.
            PERFORM P2000_SHOW_BL USING IT_TAB-ZFBLNO.
         ENDIF.
      WHEN 'ZIM33'.
         IF IT_TAB-ZFIVNO IS INITIAL.
            MESSAGE S962.
         ELSE.
            PERFORM P2000_SHOW_ZTIV USING IT_TAB-ZFIVNO.
         ENDIF.
      WHEN 'ZIM76'.
         IF IT_TAB-ZFCLSEQ IS INITIAL.
            MESSAGE S962.
         ELSE.
            PERFORM P2000_SHOW_IDS USING IT_TAB-ZFIVNO
                                         IT_TAB-ZFCLSEQ.
         ENDIF.
      WHEN 'DOWN'.                            " FILE DOWNLOAD....
            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TABLE        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
            PERFORM RESET_LIST.
      WHEN OTHERS.
   ENDCASE.
   CLEAR : IT_TAB.

*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.
*  P_V = 'X'.
*  P_Y = 'X'.

ENDFORM.                                     " P2000_INIT

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /60  '[ ��� ���� ��Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
*  WRITE : / 'DATE : ',  SY-DATUM, 115 'PAGE : ', W_PAGE.
  WRITE : / 'DATE : '.
  WRITE : / SY-ULINE.

  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
            (20) '����    ' NO-GAP,           SY-VLINE NO-GAP,
            (20) 'House B/L ',                SY-VLINE NO-GAP,
            (04) 'Unit' NO-GAP,               SY-VLINE NO-GAP,
            (14) 'B/L ����  ',                SY-VLINE NO-GAP,
            (14) '��û����  ',                SY-VLINE NO-GAP,
            (18) '�ܰ�',                      SY-VLINE NO-GAP,
            (04) 'Plnt' NO-GAP,               SY-VLINE NO-GAP,
            (10) '������' NO-GAP,             SY-VLINE NO-GAP,
            (10) '�����' NO-GAP,             SY-VLINE NO-GAP,
            (10) '���Ŵ����' NO-GAP,         SY-VLINE NO-GAP,
            (17) '���Ź���' NO-GAP,           SY-VLINE NO-GAP,
            (17) '��������',                  SY-VLINE NO-GAP.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,
            (20) '����ó' NO-GAP,             SY-VLINE NO-GAP,
            (20) '�𼱸�',                    SY-VLINE NO-GAP,
            (04) '��ȭ' NO-GAP,               SY-VLINE NO-GAP,
            (14) '�Ͽ����� ',                 SY-VLINE NO-GAP,
            (14) '�԰����  ',                SY-VLINE NO-GAP,
            (18) '�ݾ�',                      SY-VLINE NO-GAP,
            (04) 'Sloc' NO-GAP,               SY-VLINE NO-GAP,
            (10) '�����û��' NO-GAP,         SY-VLINE NO-GAP,
            (10) '���繮��' NO-GAP,           SY-VLINE NO-GAP,
            (10) '��������' NO-GAP,         SY-VLINE NO-GAP,
            (17) 'L/C NO' NO-GAP,             SY-VLINE NO-GAP,
            (17) '������',                    SY-VLINE NO-GAP.

  WRITE : / SY-ULINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.

ENDFORM.                                        " P3000_Title_Write

*-----------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIMR49'.                     " GUI STATUS SETTING
   SET TITLEBAR  'ZIMR49'.                     " GUI TITLE SETTING

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE   = W_LINE  + 1.

      " Broker Name Get.
      CLEAR : LFA1-NAME1.
      SELECT SINGLE B~NAME1   INTO  LFA1-NAME1
      FROM   ZTIMIMG10 AS A INNER JOIN LFA1 AS B
      ON     A~ZFVEN   EQ  B~LIFNR
      WHERE  A~ZFCUT   EQ  IT_TAB-ZFCUT.

      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.

   ENDLOOP.
ENDFORM.                                       " P3000_Data_Write

*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                                      " P2000_Page_Check

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   FORMAT RESET.
   FORMAT COLOR COL_NORMAL INTENSIFIED ON.

   WRITE : / SY-VLINE NO-GAP,
           (20) IT_TAB-TXZ01 NO-GAP,                 SY-VLINE NO-GAP,
           (20) IT_TAB-ZFHBLNO,                      SY-VLINE NO-GAP,
           (03) IT_TAB-MEINS,                        SY-VLINE NO-GAP,
           (15) IT_TAB-BLMENGE UNIT IT_TAB-MEINS NO-GAP,
                                                     SY-VLINE NO-GAP,
           (15) IT_TAB-CCMENGE UNIT IT_TAB-MEINS NO-GAP,
                                                     SY-VLINE NO-GAP,
           (15) IT_TAB-NETPR   CURRENCY IT_TAB-ZFBLAMC NO-GAP,
                '/' NO-GAP,
           (03) IT_TAB-PEINH   NO-GAP,
                                                     SY-VLINE NO-GAP,
           (04) IT_TAB-WERKS  NO-GAP,                SY-VLINE NO-GAP,
           (10) IT_TAB-ZFINDT NO-GAP,                SY-VLINE NO-GAP,
           (10) IT_TAB-ZFEDT  NO-GAP,                SY-VLINE NO-GAP,
           (10) IT_TAB-EKGRP  NO-GAP,                SY-VLINE NO-GAP,
                IT_TAB-EBELN  NO-GAP, '-' NO-GAP,
                IT_TAB-EBELP,                        SY-VLINE NO-GAP,
           (17) IT_TAB-NAME3,                        SY-VLINE.
   HIDE IT_TAB.

   FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
   WRITE : / SY-VLINE  NO-GAP,
           (20) IT_TAB-NAME1  NO-GAP,                SY-VLINE NO-GAP,
           (20) IT_TAB-ZFMSNM,                       SY-VLINE NO-GAP,
           (03) IT_TAB-ZFBLAMC,                      SY-VLINE NO-GAP,
           (15) IT_TAB-CGMENGE UNIT IT_TAB-MEINS NO-GAP,
                                                     SY-VLINE NO-GAP,
           (15) IT_TAB-GRMENGE UNIT IT_TAB-MEINS NO-GAP,
                                                     SY-VLINE NO-GAP,
           (19) IT_TAB-ZFBLAMT CURRENCY IT_TAB-ZFBLAMC NO-GAP,
                                                     SY-VLINE NO-GAP,
           (04) IT_TAB-LGORT   NO-GAP,               SY-VLINE NO-GAP,
           (10) IT_TAB-ZFCCDT  NO-GAP,               SY-VLINE NO-GAP,
           (10) IT_TAB-MBLNR   NO-GAP,               SY-VLINE NO-GAP,
           (10) IT_TAB-ERNAM   NO-GAP,               SY-VLINE NO-GAP,
           (17) IT_TAB-ZFOPNNO NO-GAP,               SY-VLINE NO-GAP,
           (03) IT_TAB-ZFCUT   NO-GAP,
           (01) ' '            NO-GAP,
           (13) LFA1-NAME1     NO-GAP,               SY-VLINE NO-GAP.

* Stored value...
   MOVE SY-TABIX  TO W_LIST_INDEX.
   HIDE IT_TAB.
   W_COUNT = W_COUNT + 1.

   WRITE: / SY-ULINE.

ENDFORM.                                     " P3000_Line_Write

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM  P3000_LAST_WRITE.

   IF W_COUNT GT 0.
      FORMAT RESET.
      IF SY-LANGU EQ '3'.
         WRITE : / '�� :' , W_COUNT , '��'.
      ELSE.
         WRITE : / 'Total :' , W_COUNT , 'Case'.
      ENDIF.
   ENDIF.

ENDFORM.                                     " P3000_Last_Write

*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE  = 1.
  W_LINE  = 1.
  W_COUNT = 0.
  IF SY-LANGU EQ '3'.
     PERFORM   P3000_TITLE_WRITE.
  ELSE.
     PERFORM   P3000_TITLE_WRITE_EN.
  ENDIF.
  PERFORM   P3000_DATA_WRITE  USING   W_ERR_CHK.

ENDFORM.                                     " Reset_List

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TABLE  USING   W_ERR_CHK.
   MOVE 'N' TO W_ERR_CHK.
   REFRESH IT_ZVBLIT.

   SELECT * INTO  CORRESPONDING FIELDS OF TABLE IT_ZVBLIT
            FROM  ZVBLIT
            WHERE EKORG    IN   S_EKORG
            AND   EKGRP    IN   S_EKGRP
            AND   MATNR    IN   S_MATNR
            AND   WERKS    IN   S_WERKS
            AND   MATKL    IN   S_MATKL.

   SORT IT_ZVBLIT BY ZFHBLNO ZFBLNO ZFBLIT.

   LOOP AT IT_ZVBLIT.
      CLEAR IT_TAB.
      MOVE-CORRESPONDING IT_ZVBLIT TO IT_TAB.

      ">> Storage Location
      SELECT * FROM ZTIVIT UP TO 1 ROWS
               WHERE  ZFBLNO EQ IT_TAB-ZFBLNO
               AND    ZFBLIT EQ IT_TAB-ZFBLIT.
      ENDSELECT.

      W_SUBRC = SY-SUBRC.

      IF  W_SUBRC  EQ 0.
         IF S_CCDT[]  IS INITIAL AND S_CUNAM[] IS INITIAL AND
            S_ZFCUT[] IS INITIAL.
            SELECT SINGLE * FROM ZTIV
                   WHERE   ZFIVNO EQ ZTIVIT-ZFIVNO.
         ELSE.
            SELECT SINGLE * FROM ZTIV
                   WHERE   ZFIVNO  EQ ZTIVIT-ZFIVNO
                   AND     ZFCCDT  IN S_CCDT
                   AND     ZFCUNAM IN S_CUNAM
                   AND     ZFCUT   IN S_ZFCUT.
         ENDIF.

         IF SY-SUBRC EQ 0.
            MOVE : ZTIVIT-LGORT TO IT_TAB-LGORT,
                   ZTIV-ZFCCDT  TO IT_TAB-ZFCCDT,
                   ZTIV-ZFCUNAM TO IT_TAB-ZFCUNAM,
                   ZTIV-ZFCUT   TO IT_TAB-ZFCUT,
                   ZTIV-ERNAM   TO IT_TAB-ERNAM,
                   ZTIV-ZFIVNO  TO IT_TAB-ZFIVNO.
         ELSE.
            IF NOT ( S_CCDT[]  IS INITIAL AND
                     S_CUNAM[] IS INITIAL AND
                     S_ZFCUT[] IS INITIAL ).
               CONTINUE.
            ENDIF.
         ENDIF.
         ">> Material Document No
         SELECT * FROM ZTIVHST
                  WHERE ZFIVNO EQ ZTIVIT-ZFIVNO
                  AND   SHKZG  EQ 'S'
                  AND ( CMBLNR IS NULL
                  OR    CMBLNR NE SPACE ).
         ENDSELECT.
         IF SY-SUBRC EQ 0.
            MOVE : ZTIVHST-MBLNR   TO   IT_TAB-MBLNR,
                   ZTIVHST-MJAHR   TO   IT_TAB-MJAHR.
         ENDIF.

         ">> Entry Summary Data
         IF S_IDSDT[] IS INITIAL.
            SELECT SINGLE * FROM ZTIDSUS
                   WHERE  ZFIVNO EQ ZTIVIT-ZFIVNO.
         ELSE.
            SELECT SINGLE * FROM ZTIDSUS
                   WHERE  ZFIVNO  EQ ZTIVIT-ZFIVNO
                   AND    ZFEDT   IN S_IDSDT.
         ENDIF.
         IF SY-SUBRC EQ 0.
            MOVE : ZTIDSUS-ZFEDT    TO  IT_TAB-ZFEDT,
                   ZTIDSUS-ZFCLSEQ  TO  IT_TAB-ZFCLSEQ.
         ELSE.
            IF NOT S_IDSDT[] IS INITIAL.
               CONTINUE.
            ENDIF.
         ENDIF.

         ">> TEXT
         PERFORM   P1000_GET_TEXT.

         IF P_ALL EQ 'X'.
            APPEND IT_TAB.
         ELSEIF P_YES EQ 'X'.

            IF IT_TAB-BLMENGE > IT_TAB-CCMENGE1.
               APPEND IT_TAB.
            ENDIF.
         ELSEIF P_NO  EQ 'X'.
            IF IT_TAB-GRMENGE < IT_TAB-CCMENGE .
               APPEND IT_TAB.
            ENDIF.
         ENDIF.
      ELSE.
         IF NOT ( S_CCDT[]  IS INITIAL AND
                  S_IDSDT[] IS INITIAL AND
                  S_ZFCUT[] IS INITIAL ).
            CONTINUE.
         ENDIF.
      ENDIF.

      IF SY-SUBRC NE 0.
         PERFORM   P1000_GET_TEXT.
         APPEND IT_TAB.
      ENDIF.

   ENDLOOP.

   DESCRIBE TABLE IT_TAB LINES W_COUNT.
   IF W_COUNT = 0.
      MESSAGE S738.
   ENDIF.

   SORT IT_TAB BY ZFBLNO ZFBLIT.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_BL
*&---------------------------------------------------------------------*
FORM P2000_SHOW_BL USING    P_ZFBLNO.

   SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.
   SET PARAMETER ID 'ZPHBLNO' FIELD ''.

   CALL TRANSACTION 'ZIM23'   AND SKIP FIRST SCREEN.

ENDFORM.                                      " P2000_SHOW_BL

*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_CG
*&---------------------------------------------------------------------*
FORM P2000_SHOW_ZTIV USING    P_ZFIVNO.

   SET PARAMETER ID 'ZPBLNO'   FIELD ''.
   SET PARAMETER ID 'ZPHBLNO'  FIELD ''.
   SET PARAMETER ID 'ZPIVNO'   FIELD P_ZFIVNO.

   CALL TRANSACTION 'ZIM33'    AND SKIP FIRST SCREEN.

ENDFORM.                                     " P2000_SHOW_CG

*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select
  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_GET_TEXT.

*> B/L NO.
      IF NOT IT_TAB-ZFBLNO IS INITIAL.
         IT_TAB-ZFHBLNO = IT_TAB-ZFHBLNO.
      ELSE.
         IF NOT IT_TAB-ZFMBLNO IS INITIAL.
            IT_TAB-ZFHBLNO = IT_TAB-ZFMBLNO.
         ELSE.
            IF NOT IT_TAB-ZFCGHNO IS INITIAL.
               IT_TAB-ZFHBLNO = IT_TAB-ZFCGHNO.
            ELSE.
               IT_TAB-ZFHBLNO = IT_TAB-ZFBLNO.
            ENDIF.
         ENDIF.
      ENDIF.

*> MotherShip Name
      CLEAR : IT_TAB-ZFMSNM.
      SELECT SINGLE * FROM ZTMSHD
             WHERE ZFMSNO  EQ  IT_TAB-ZFMSNO.
      IF SY-SUBRC EQ 0.
         MOVE ZTMSHD-ZFMSNM TO IT_TAB-ZFMSNM.
      ENDIF.

*> Amount Compute
      CLEAR : IT_TAB-ZFBLAMT.
      IF IT_TAB-EBELN IS INITIAL.
         SELECT SINGLE * FROM EKPO
                WHERE EBELN  EQ  IT_TAB-EBELN
                AND   EBELP  EQ  IT_TAB-EBELP.
         IF IT_TAB-PEINH IS INITIAL.
            IT_TAB-PEINH  =  1.
         ENDIF.
         IF EKPO-BPUMN IS INITIAL.
            EKPO-BPUMN = 1.
         ENDIF.
         IF SY-SUBRC EQ 0.
            IT_TAB-ZFBLAMT =
           ( IT_TAB-BLMENGE * ( EKPO-BPUMZ / EKPO-BPUMN )
         * ( IT_TAB-NETPR / IT_TAB-PEINH ) ).
         ELSE.
            IT_TAB-ZFBLAMT =
           ( IT_TAB-BLMENGE * ( IT_TAB-NETPR / IT_TAB-PEINH ) ).
         ENDIF.
      ENDIF.

**  Plant Name SELECT!
      SELECT  SINGLE NAME1  INTO IT_TAB-NAME
              FROM  T001W
              WHERE  WERKS    EQ  IT_TAB-WERKS.

**  Storage Location Name SELECT!
      SELECT  SINGLE LGOBE  INTO IT_TAB-LGOBE
              FROM  T001L
              WHERE WERKS    EQ  IT_TAB-WERKS
              AND   LGORT    EQ  IT_TAB-LGORT.

*  Bonded warehouse name SELECT!
      IF NOT IT_TAB-ZFBNARCD IS INITIAL.
        SELECT  SINGLE ZFBNARM  INTO IT_TAB-NAME3
          FROM  ZTIMIMG03
         WHERE  ZFBNARCD    EQ  IT_TAB-ZFBNARCD.
      ENDIF.

*> Vendor Name
      CLEAR : IT_TAB-NAME1.
      IF NOT IT_TAB-LIFNR IS INITIAL.
         SELECT SINGLE * FROM LFA1
                WHERE LIFNR EQ IT_TAB-LIFNR.
         IF SY-SUBRC EQ 0.
            MOVE LFA1-NAME1 TO IT_TAB-NAME1.
         ENDIF.
      ENDIF.

**> Unloading Quantity
      SELECT SUM( CGMENGE ) INTO IT_TAB-CGMENGE
             FROM   ZTCGIT
             WHERE  ZFBLNO        EQ     IT_TAB-ZFBLNO
             AND    ZFBLIT        EQ     IT_TAB-ZFBLIT.


**> Customs Clearance Request Qty
      SELECT SUM( CCMENGE ) INTO IT_TAB-CCMENGE
             FROM   ZTIV   AS  H  INNER  JOIN  ZTIVIT   AS  I
             ON     H~ZFIVNO        EQ     I~ZFIVNO
             WHERE  I~ZFBLNO        EQ     IT_TAB-ZFBLNO
             AND    I~ZFBLIT        EQ     IT_TAB-ZFBLIT.

**> Clearance Qty
      SELECT SUM( CCMENGE ) INTO IT_TAB-CCMENGE1
             FROM   ZTIV   AS  H  INNER  JOIN  ZTIVIT   AS  I
             ON     H~ZFIVNO        EQ     I~ZFIVNO
             WHERE  I~ZFBLNO        EQ     IT_TAB-ZFBLNO
             AND    I~ZFBLIT        EQ     IT_TAB-ZFBLIT
             AND    H~ZFCUST        EQ     'Y'.

*>> G/R Qty
      SELECT SUM( GRMENGE ) INTO IT_TAB-GRMENGE
             FROM   ZTIV   AS  H  INNER  JOIN  ZTIVIT   AS  I
             ON     H~ZFIVNO        EQ     I~ZFIVNO
             WHERE  I~ZFBLNO        EQ     IT_TAB-ZFBLNO
             AND    I~ZFBLIT        EQ     IT_TAB-ZFBLIT
             AND    H~ZFGRST        EQ     'Y'.

ENDFORM.                    " P1000_GET_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_IDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFBLNO  text
*      -->P_IT_TAB_ZFCLSEQ  text
*----------------------------------------------------------------------*
FORM P2000_SHOW_IDS USING    P_ZFIVNO
                             P_ZFCLSEQ.

   SET PARAMETER ID 'ZPIVNO'    FIELD P_ZFIVNO.
   SET PARAMETER ID 'ZPCLSEQ'   FIELD P_ZFCLSEQ.
   SET PARAMETER ID 'ZPENTNO'   FIELD ''.

   CALL TRANSACTION 'ZIMCC3'    AND SKIP FIRST SCREEN.

ENDFORM.                    " P2000_SHOW_IDS
*&---------------------------------------------------------------------*
*&      Form  P1000_SET_BUKRS
*&---------------------------------------------------------------------*
FORM P1000_SET_BUKRS.

   CLEAR : ZTIMIMG00.
   SELECT SINGLE * FROM ZTIMIMG00.
   IF NOT ZTIMIMG00-ZFBUFIX IS INITIAL.
      MOVE  ZTIMIMG00-ZFBUKRS   TO  P_BUKRS.
   ENDIF.

*>> Company Code SET.
    MOVE: 'I'          TO S_BUKRS-SIGN,
          'EQ'         TO S_BUKRS-OPTION,
          P_BUKRS      TO S_BUKRS-LOW.
    APPEND S_BUKRS.

ENDFORM.                    " P1000_SET_BUKRS

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE_EN
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE_EN.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /60  '[ Customs Clearance Progress Status ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'DATE : '.
  WRITE : / SY-ULINE.

  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
            (20) 'Material    ' NO-GAP,       SY-VLINE NO-GAP,
            (20) 'House B/L ',                SY-VLINE NO-GAP,
            (04) 'Unit' NO-GAP,               SY-VLINE NO-GAP,
            (14) '  B/L Quantity',            SY-VLINE NO-GAP,
            (14) 'Request Quantity',          SY-VLINE NO-GAP,
            (18) 'Net Price',                 SY-VLINE NO-GAP,
            (04) 'Plnt' NO-GAP,               SY-VLINE NO-GAP,
            (10) 'Carry-in' NO-GAP,           SY-VLINE NO-GAP,
            (10) 'Entry Date' NO-GAP,         SY-VLINE NO-GAP,
            (10) 'Person' NO-GAP,             SY-VLINE NO-GAP,
            (17) 'Purchasing Doc.' NO-GAP,    SY-VLINE NO-GAP,
            (17) 'Bonded Area',               SY-VLINE NO-GAP.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,
            (20) 'Vendor' NO-GAP,             SY-VLINE NO-GAP,
            (20) 'Name of Mothership',        SY-VLINE NO-GAP,
            (04) 'Cur.' NO-GAP,               SY-VLINE NO-GAP,
            (14) ' Unloading Qty.',           SY-VLINE NO-GAP,
            (14) '       G/R Qty',            SY-VLINE NO-GAP,
            (18) 'Amount',                    SY-VLINE NO-GAP,
            (04) 'Sloc' NO-GAP,               SY-VLINE NO-GAP,
            (10) 'C/C Date' NO-GAP,           SY-VLINE NO-GAP,
            (10) 'Material Doc.' NO-GAP,      SY-VLINE NO-GAP,
            (10) 'In Charge ' NO-GAP,         SY-VLINE NO-GAP,
            (17) 'L/C Approve No' NO-GAP,     SY-VLINE NO-GAP,
            (17) 'Customs Broker',            SY-VLINE NO-GAP.

  WRITE : / SY-ULINE.

  FORMAT COLOR COL_HEADING INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE_EN
