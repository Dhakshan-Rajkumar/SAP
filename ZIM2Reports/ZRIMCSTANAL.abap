*&---------------------------------------------------------------------*
*& Report  ZRIMCSTANAL                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �÷�Ʈ, ���纰 ���м��Ͽ� ������ �ݿ�.              *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.12.05                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : �԰�� ������ �ݿ��Ǵ� �ݾװ� ������ �߻��ϴ� ����?
*&               �� ���̸� �÷�Ʈ, ���纰�� ������ �ݿ��ϴ� REPORT.
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMCSTANAL   MESSAGE-ID ZIM
                      LINE-SIZE 122
                      NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* Tables �� ���� Define
*-----------------------------------------------------------------------
INCLUDE : <ICON>,
          ZRIMCSTANALTOP,
          ZRIMBDCCOM.

DATA : BEGIN OF   IT_TAB OCCURS 0,
       CHECK      TYPE C,                " �����ݿ� CHECK.
       ZFACDO     LIKE ZTBKPF-ZFACDO,    " ��ǥ��ȣ.
       ZFFIYR     LIKE ZTBKPF-ZFFIYR,    " ȸ��⵵.
       BUKRS      LIKE ZTBDIV-BUKRS,     " ȸ���ڵ�.
       WERKS      LIKE ZTIVIT-WERKS,     " �÷�Ʈ.
       JASAN_GB   TYPE C,                " �ڻ걸��.
       MATNR      LIKE ZTREQIT-MATNR,    " ���纰.
       VGABE      LIKE EKBZ-VGABE,       " ���ſ����̷�.
       BEWTP      LIKE T163C-BEWTP,      " �̷�����.
       BEWTK      LIKE T163C-BEWTK,      " �̷���������.
       BEWTL      LIKE T163C-BEWTL,      " �̷���������.
       KSCHL      LIKE EKBZ-KSCHL,       " ��������.
       TEXT(20)   TYPE C,                " TEXT.
       WRBTR      LIKE EKBZ-WRBTR,       " ��ǥ��ȭ�ݾ�.
       WAERS      LIKE EKBZ-WAERS,       " ��ȭŰ.
       SORT       TYPE C.                " SORT.
DATA : END OF IT_TAB.

DATA : BEGIN OF   IT_TAB_SUM OCCURS 0,
       CHECK      TYPE C,                " �����ݿ� CHECK.
       BUKRS      LIKE ZTBDIV-BUKRS,     " ȸ���ڵ�.
       WERKS      LIKE ZTIVIT-WERKS,     " �÷�Ʈ.
       JASAN_GB   TYPE C,                " �ڻ걸��.
       MATNR      LIKE ZTREQIT-MATNR,    " ���纰.
       VGABE      LIKE EKBZ-VGABE,       " ���ſ����̷�.
       BEWTP      LIKE T163C-BEWTP,      " �̷�����.
       BEWTK      LIKE T163C-BEWTK,      " �̷���������.
       BEWTL      LIKE T163C-BEWTL,      " �̷���������.
       KSCHL      LIKE EKBZ-KSCHL,       " ��������.
       TEXT(20)   TYPE C,                " TEXT.
       WRBTR      LIKE EKBZ-WRBTR,       " ��ǥ��ȭ�ݾ�.
       WAERS      LIKE EKBZ-WAERS,       " ��ȭŰ.
       SORT       TYPE C.                " SORT.
DATA : END OF IT_TAB_SUM.

DATA : BEGIN OF   IT_TAB1 OCCURS 0,
       BUKRS      LIKE ZTBDIV-BUKRS,     " ȸ���ڵ�.
       WERKS      LIKE ZTIVIT-WERKS,     " �÷�Ʈ.
       JASAN_GB   TYPE C,                " �ڻ걸��.
       GB_TX(10)  TYPE C,                " �ڻ걸�и�.
       MATNR      LIKE EKPO-MATNR,       " ����.
       TXZ01      LIKE EKPO-TXZ01,       " �����.
       SORT       TYPE C,                " SORT KEY.
       TEXT(20)   TYPE C,                " �̷����� ����.
       BEWTP      LIKE T163C-BEWTP,      " �̷�����.
       VGABE      LIKE EKBZ-VGABE,       " ���ſ����̷�.
       KSCHL      LIKE EKBZ-KSCHL,       " ��������.
       DMBTR      LIKE EKBZ-WRBTR,       " �ݾ�.
       WAERS      LIKE EKBZ-WAERS.       " ��ȭŰ.
DATA : END OF IT_TAB1.

DATA : P_BUKRS    LIKE ZTIMIMG00-ZFBUKRS.
*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS    FOR ZTBCOST-BUKRS NO-EXTENSION
                                                NO INTERVALS,
                   S_MATNR    FOR ZTREQIT-MATNR,         " Material No.
                   S_WERKS    FOR ZTREQHD-ZFWERKS,       " Plant.
                   S_DATE     FOR ZTIVHST-BUDAT.         " Posting Date.
SELECTION-SCREEN END OF BLOCK B1.

*>> �ʱⰪ SETTING.
INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM  P1000_SET_BUKRS.
   SET  TITLEBAR 'ZIMY9'.           " GUI TITLE SETTING..

* Title Text Write
TOP-OF-PAGE.
   IF INCLUDE NE 'POPU'.
      PERFORM P1000_TITLE_WRITE.
   ENDIF.

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

*>> ���� CONFIGURATION CHECK
   PERFORM P1000_CONFIG_CHECK   USING  W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.   EXIT. ENDIF.

*>> DATA SELECT!
   PERFORM P2000_READ_TEXT      USING  W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.  EXIT.  ENDIF.

*-----------------------------------------------------------------------
* END OF SELECTION ?
*-----------------------------------------------------------------------
END-OF-SELECTION.
   PERFORM P3000_DATA_WRITE     USING  W_ERR_CHK.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'COHI'.
*>> �����ݿ� HISTORY TABLE READ.
         PERFORM  P3000_READ_CODATA.
         PERFORM  P2000_COANAL_HISTORY.
      WHEN 'REFR'.
         " REFRESH.
         PERFORM P2000_READ_TEXT      USING  W_ERR_CHK.
         IF W_ERR_CHK EQ 'Y'.
            LEAVE TO SCREEN 0.
         ENDIF.
         MOVE 0 TO SY-LSIND.
         PERFORM P1000_TITLE_WRITE.
         PERFORM P3000_DATA_WRITE     USING  W_ERR_CHK.

      WHEN 'ANAL'.                   " �ش� ��� Document Display
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766.
               EXIT.
            ENDIF.
            IF W_SELECTED_LINES GT 1.
               MESSAGE S965.
               EXIT.
            ENDIF.
            PERFORM  P2000_COST_ADJUSTMENT.
            DESCRIBE  TABLE RETURN   LINES  W_LINE.
            IF W_LINE GT 0.
               INCLUDE = 'POPU'.
               CALL SCREEN 0100 STARTING AT  05   3
                                ENDING   AT  100 12.
               CLEAR : INCLUDE.
            ENDIF.
            " REFRESH.
            PERFORM P2000_READ_TEXT      USING  W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.
               LEAVE TO SCREEN 0.
            ENDIF.
            MOVE 0 TO SY-LSIND.
            PERFORM P1000_TITLE_WRITE.
            PERFORM P3000_DATA_WRITE     USING  W_ERR_CHK.

      WHEN 'MKAL' OR 'MKLO'.         " ��ü ���� �� ������?
            PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.

*------- Abbrechen (CNCL) ----------------------------------------------
      WHEN 'CNCL'.
         SET SCREEN 0.    LEAVE SCREEN.
*------- Suchen (SUCH) -------------------------------------------------
      WHEN 'SUCH'.
*------- Sortieren nach Feldbezeichnung (SORB) -------------------------
      WHEN 'SORB'.
*------- Sortieren nach Feldname (SORF) --------------------------------
      WHEN 'SORF'.
*------- Techn. Name ein/aus (TECH) ------------------------------------
      WHEN 'TECH'.
*------- Weiter suchen (WESU) ------------------------------------------
      WHEN 'WESU'.
      WHEN OTHERS.
   ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P1000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P1000_CONFIG_CHECK USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select
  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

  IF ZTIMIMG00-ZFCSTMD NE 'S'.
     W_ERR_CHK = 'Y'.   MESSAGE S573.   EXIT.
  ENDIF.

ENDFORM.                    " P1000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*&      Form  P2000_READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P2000_READ_TEXT USING    W_ERR_CHK.

   REFRESH : IT_TAB, IT_PO, IT_IV, IT_DIV, IT_EKBZ, IT_TEMP, IT_IV,
             IT_TAB_SUM.
   MOVE  'N'      TO  W_ERR_CHK.

*>> PO NUMBER GET!
   PERFORM P3000_READ_REDATA.
   IF W_ERR_CHK EQ 'Y'.
      MESSAGE  S738.
      EXIT.
   ENDIF.
*>> ��� ���� �ڷ� GET!
   PERFORM P3000_READ_CSTDATA.
*>> LIST UP �� INTERNAL TABLE INSERT
   PERFORM P3000_WRITE_TAB.
*>> ���纰 ���������� SUM.
   PERFORM P3000_SUM_WRITE_TAB.

ENDFORM.                    " P2000_READ_TEXT

*&---------------------------------------------------------------------*
*&      Form  P3000_READ_REDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_READ_REDATA.

   REFRESH : IT_TEMP, IT_IV.

*>> �Ⱓ���� �԰�� PO �ڷ� SELECT!
*   SELECT  ZFIVNO  MAX( ZFIVHST ) AS  ZFIVHST
*   INTO    CORRESPONDING FIELDS OF TABLE IT_TEMP
*   FROM    ZTIVHST
*   WHERE   BUDAT        IN     S_DATE
*   AND     CMBLNR       EQ     SPACE
*   AND     MBLNR        NE     SPACE
*   GROUP BY
*           ZFIVNO.
   SELECT  ZFIVNO  INTO CORRESPONDING FIELDS OF TABLE IT_TEMP
   FROM    ZTIV
   WHERE   ZFINCF       IN     S_DATE
   AND     ZFGRST       EQ     'Y'.
*{ 09/16/11 PaUL ChECK IT_TeMP
   CHECK IT_TEMP IS NOT INITIAL.
*}
*>> �԰�� PO �ڷ� SELECT!
   SELECT  A~BUKRS  A~ZFIVNO B~EBELN  B~EBELP B~ZFMATGB
           B~MATNR  B~WERKS  A~ZFINCF AS BUDAT
   INTO    CORRESPONDING FIELDS OF TABLE IT_IV
   FROM  ( ZTIV  AS  A  INNER  JOIN  ZTIVIT AS B
   ON      A~ZFIVNO     EQ     B~ZFIVNO )
   FOR     ALL  ENTRIES IN     IT_TEMP
   WHERE   A~BUKRS      IN     S_BUKRS
   AND     B~MATNR      IN     S_MATNR
   AND     B~WERKS      IN     S_WERKS
   AND     A~ZFIVNO     EQ     IT_TEMP-ZFIVNO.

*   SELECT  A~BUKRS  A~ZFIVNO B~EBELN  B~EBELP B~ZFMATGB
*           B~MATNR  B~WERKS  C~BUDAT
*   INTO    CORRESPONDING FIELDS OF TABLE IT_IV
*   FROM  ( ZTIV  AS  A  INNER  JOIN  ZTIVIT AS B
*   ON      A~ZFIVNO     EQ     B~ZFIVNO )
*   INNER   JOIN ZTIVHST AS     C
*   ON      A~ZFIVNO     EQ     C~ZFIVNO
*   FOR     ALL  ENTRIES IN     IT_TEMP
*   WHERE   A~BUKRS      IN     S_BUKRS
*   AND     B~MATNR      IN     S_MATNR
*   AND     B~WERKS      IN     S_WERKS
*   AND     A~ZFIVNO     EQ     IT_TEMP-ZFIVNO
*   AND     C~ZFIVHST    EQ     IT_TEMP-ZFIVHST.

*>> �԰�� PO �ڷ�( �ڻ����� .. )
*   SELECT  A~BUKRS  A~ZFIVNO B~EBELN  B~EBELP B~ZFMATGB
*           B~MATNR  B~WERKS  C~BUDAT
*   APPENDING CORRESPONDING FIELDS OF TABLE  IT_IV
*   FROM  ( ( ZTIV  AS  A  INNER  JOIN  ZTIVIT AS B
*   ON      A~ZFIVNO     EQ     B~ZFIVNO )
*   INNER   JOIN ZTIVHST AS     C
*   ON      A~ZFIVNO     EQ     C~ZFIVNO )
*   INNER   JOIN EKKN    AS     D
*   ON      B~EBELN      EQ     D~EBELN
*   AND     B~EBELP      EQ     D~EBELP
*   FOR     ALL  ENTRIES IN     IT_TEMP
*   WHERE   A~BUKRS      IN     S_BUKRS
*   AND     D~ANLN1      IN     S_MATNR
*   AND     B~WERKS      IN     S_WERKS
*   AND     A~ZFIVNO     EQ     IT_TEMP-ZFIVNO
*   AND     C~ZFIVHST    EQ     IT_TEMP-ZFIVHST.

   CLEAR  W_LINE.
   DESCRIBE TABLE IT_IV LINES W_LINE.

   IF W_LINE EQ 0.
      MOVE  'Y'   TO  W_ERR_CHK.
      EXIT.
   ENDIF.

ENDFORM.                    " P3000_READ_REDATA
*&---------------------------------------------------------------------*
*&      Form  P1000_TITLE_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_TITLE_WRITE.
 IF SY-LANGU EQ '3'.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /50  '[ �÷�Ʈ ���纰 ��� �м� ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : /                                          SY-VLINE NO-GAP,
            'PLANT'                          NO-GAP, SY-VLINE NO-GAP,
            '����                '           NO-GAP,
            '                    '           NO-GAP, SY-VLINE NO-GAP,
            '��������                 '      NO-GAP, SY-VLINE NO-GAP,
            '���ǹ���                 '      NO-GAP, SY-VLINE NO-GAP,
            '            �ݾ�     '          NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.
 ELSE.
  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /40  '[ Expense analysis by plant/material ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : /                                          SY-VLINE NO-GAP,
            'PLANT'                          NO-GAP, SY-VLINE NO-GAP,
            'Material            '           NO-GAP,
            '                    '           NO-GAP, SY-VLINE NO-GAP,
            'Condition type           '      NO-GAP, SY-VLINE NO-GAP,
            'Condition Category       '      NO-GAP, SY-VLINE NO-GAP,
            '           Amount    '          NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.
 ENDIF.
ENDFORM.                    " P1000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_READ_CSTDATA
*&---------------------------------------------------------------------*
FORM P3000_READ_CSTDATA.

*{ 09/16/11 PaUL ChECK IT_IV
   CHECK IT_IV IS NOT INITIAL.
*}
*>> �԰�� �ڷῡ ���� ��� POSTING �ڷ� SELECT!
   SELECT  *  INTO CORRESPONDING FIELDS OF TABLE IT_DIV
   FROM    ZTBKPF       AS  A  INNER  JOIN  ZTBDIV  AS  B
   ON      A~BUKRS      EQ  B~BUKRS
   AND     A~GJAHR      EQ  B~GJAHR
   AND     A~BELNR      EQ  B~BELNR
   FOR     ALL ENTRIES  IN  IT_IV
   WHERE   B~EBELN      EQ  IT_IV-EBELN
   AND     B~EBELP      EQ  IT_IV-EBELP
   AND     A~ZFPOSYN    EQ  'Y'
   AND     B~EBELN      NE  SPACE.

   LOOP AT IT_DIV.

      W_TABIX  =  SY-TABIX.

      " ACCOUNT ASINGMENT CODE �� ������ ������ SKIP.
      SELECT SINGLE * FROM  EKPO
                      WHERE EBELN    EQ  IT_DIV-EBELN
                      AND   EBELP    EQ  IT_DIV-EBELP
                      AND   KNTTP    EQ  SPACE.
      IF SY-SUBRC NE 0.
         DELETE  IT_DIV  INDEX  W_TABIX.
         CONTINUE.
      ENDIF.
      MOVE  : EKPO-MATNR        TO   IT_DIV-MATNR,
              EKPO-WERKS        TO   IT_DIV-WERKS.

      MODIFY IT_DIV INDEX W_TABIX.
   ENDLOOP.

*>> ��� POSTING( LIV ) �ڷ� SELECT!
   SELECT  *  INTO CORRESPONDING FIELDS OF TABLE IT_EKBZ
   FROM    EKBZ
   FOR     ALL ENTRIES  IN  IT_IV
   WHERE   EBELN        EQ  IT_IV-EBELN
   AND     EBELP        EQ  IT_IV-EBELP.

ENDFORM.                    " P3000_READ_CSTDATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_TAB.

*>> ���Ժ��� �߿��� ���(AP POSTING)�Ǵ� �ڷḸ LIST UP
   LOOP  AT  IT_DIV  WHERE  ZFDCSTX NE 'X'.

      CLEAR : IT_TAB, W_COUNT, ZTIMIMG08.
      MOVE-CORRESPONDING  IT_DIV  TO  IT_TAB.
      MOVE  'AP'              TO  IT_TAB-BEWTK.
      MOVE  '4'               TO  IT_TAB-SORT.
      MOVE  IT_DIV-BUKRS      TO  IT_TAB-BUKRS.
      MOVE  IT_DIV-WERKS      TO  IT_TAB-WERKS.
      MOVE  IT_DIV-MATNR      TO  IT_TAB-MATNR.
      MOVE  IT_DIV-WRBTR      TO  IT_TAB-WRBTR.
      MOVE  IT_DIV-HWAER      TO  IT_TAB-WAERS.
      MOVE  IT_DIV-MATNR      TO  IT_TAB-MATNR.

*>> �����ݿ� CHECK!
      SELECT COUNT( * ) INTO W_COUNT
      FROM   ZTBCOIT
      WHERE  ZFFIYR    EQ  IT_DIV-ZFFIYR
      AND    ZFACDO    EQ  IT_DIV-ZFACDO.

      IF W_COUNT IS INITIAL OR SY-SUBRC NE 0.
         MOVE  '2'   TO  IT_TAB-CHECK.
      ELSE.
         MOVE  '1'   TO  IT_TAB-CHECK.
      ENDIF.

*>> ��� �׷�� DISPLAY.
      MOVE  'Expense of import'     TO  IT_TAB-BEWTL.

*>>���� SELECT.
      SELECT  SINGLE  *
      FROM    ZTIMIMG08
      WHERE   ZFCDTY  EQ  IT_DIV-ZFCSTGRP
      AND     ZFCD    EQ  IT_DIV-ZFCD.

      MOVE  ZTIMIMG08-COND_TYPE TO   IT_TAB-KSCHL.

*>> ���� ���� SETTING
      SELECT  SINGLE VTEXT  INTO  IT_TAB-TEXT
      FROM    T685T
      WHERE   SPRAS       EQ     SY-LANGU
      AND     KVEWE       EQ     'A'
      AND     KAPPL       EQ     'M'
      AND     KSCHL       EQ     IT_TAB-KSCHL.
      APPEND  IT_TAB.

   ENDLOOP.

*>> ��ǥ TABLE���� LIST UP.
   LOOP  AT  IT_EKBZ.

      CLEAR  : IT_TAB, EKPO, W_COUNT.
      MOVE-CORRESPONDING  IT_EKBZ  TO  IT_TAB.
*>> �����ȣ �� ��Ÿ DATA GET!
      SELECT SINGLE * FROM   EKPO
             WHERE    EBELN  EQ    IT_EKBZ-EBELN
             AND      EBELP  EQ    IT_EKBZ-EBELP.

      MOVE : EKPO-WERKS     TO  IT_TAB-WERKS,
             EKPO-MATNR     TO  IT_TAB-MATNR,
             EKPO-BUKRS     TO  IT_TAB-BUKRS,
             IT_EKBZ-GJAHR  TO  IT_TAB-ZFFIYR,
             IT_EKBZ-BELNR  TO  IT_TAB-ZFACDO.

*>> �����ݿ� ���� CHECK
      SELECT COUNT( * )  INTO  W_COUNT
      FROM   ZTBCOIT
      WHERE  ZFFIYR      EQ    IT_EKBZ-GJAHR
      AND    ZFACDO      EQ    IT_EKBZ-BELNR .

      IF W_COUNT IS INITIAL OR SY-SUBRC NE 0.
         MOVE    '2'     TO    IT_TAB-CHECK.
      ELSE.
         MOVE    '1'     TO    IT_TAB-CHECK.
      ENDIF.

*>> SORT ���� SETTING
      IF IT_EKBZ-BEWTP  EQ  'F'.            " DCGR.
         MOVE  '1'      TO   IT_TAB-SORT.
      ELSEIF  IT_EKBZ-BEWTP  EQ  'M'.       " DCIN.
         MOVE  '2'      TO   IT_TAB-SORT.
      ELSEIF  IT_EKBZ-BEWTP  EQ  'C'.       " NEUR.
         MOVE  '3'      TO   IT_TAB-SORT.
      ELSEIF  IT_EKBZ-BEWTP  EQ  'P'.       " SUB. DEBIT.
         MOVE  '2'      TO   IT_TAB-SORT.
      ENDIF.

*>> ����/ �뺯 ������ �°Բ� �ݾ� MOVE.
      IF IT_EKBZ-VGABE EQ '1'.
         IF IT_EKBZ-SHKZG EQ 'H'.
            MOVE  IT_EKBZ-DMBTR   TO  IT_TAB-WRBTR.
         ELSE.
            IT_TAB-WRBTR  =  IT_EKBZ-DMBTR * ( -1 ).
         ENDIF.
      ELSEIF IT_EKBZ-VGABE EQ '2'.
         IF IT_EKBZ-SHKZG EQ 'H'.
            IT_TAB-WRBTR  =  IT_EKBZ-DMBTR * ( -1 ).
         ELSE.
            MOVE  IT_EKBZ-DMBTR  TO  IT_TAB-WRBTR.
         ENDIF.
      ENDIF.
*>> ���� ���� SETTING
      SELECT  SINGLE BEWTK BEWTL
      INTO    (IT_TAB-BEWTK, IT_TAB-BEWTL)
      FROM    T163C
      WHERE   SPRAS         EQ    SY-LANGU
      AND     BEWTP         EQ    IT_TAB-BEWTP.
*>> ���� ���� SETTING
      SELECT  SINGLE VTEXT  INTO  IT_TAB-TEXT
      FROM    T685T
      WHERE   SPRAS       EQ     SY-LANGU
      AND     KVEWE       EQ     'A'
      AND     KAPPL       EQ     'M'
      AND     KSCHL       EQ     IT_TAB-KSCHL.

      MOVE  IT_EKBZ-HSWAE  TO    IT_TAB-WAERS.
      APPEND  IT_TAB.
   ENDLOOP.

   SORT  IT_TAB  BY  BUKRS  CHECK WERKS  MATNR  KSCHL SORT.

   DESCRIBE  TABLE  IT_TAB  LINES  W_COUNT.
   IF W_COUNT  LE  0.
      MESSAGE  S966.
      W_ERR_CHK  =  'N'.
   ENDIF.

ENDFORM.                    " P3000_WRITE_TAB
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING    W_ERR_CHK.

   CLEAR  :  IT_TAB,   SV_MENGE,  SV_DMBTR,  SV_SUM1,  W_TABIX,
             SV_SUM2,  SV_SUM3,   SV_SUM4,   SV_CHK,   W_LINE.
   CLEAR  :  SV_WERKS, SV_BUKRS,  SV_CHECK,  SV_MATNR, SV_SORT,
             SV_KSCHL, SV_MATGB.

   MOVE  'N'    TO  W_ERR_CHK.
   DESCRIBE TABLE IT_TAB_SUM LINES W_LINE.
   SET PF-STATUS 'ZIMY9A'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMY9'.           " GUI TITLE SETTING..

   LOOP  AT  IT_TAB_SUM.
      W_TABIX = SY-TABIX.
      IF SY-TABIX EQ 1.
         SV_CHK = '1'.
         MOVE  : IT_TAB_SUM-BUKRS    TO  SV_BUKRS,
                 IT_TAB_SUM-CHECK    TO  SV_CHECK,
                 IT_TAB_SUM-WERKS    TO  SV_WERKS,
                 IT_TAB_SUM-MATNR    TO  SV_MATNR,
                 IT_TAB_SUM-SORT     TO  SV_SORT ,
                 IT_TAB_SUM-KSCHL    TO  SV_KSCHL.
      ENDIF.
*>> ȸ���ڵ尡 �޶����� SUM WRITE.
      IF  IT_TAB_SUM-BUKRS NE  SV_BUKRS.
          SV_JUL = 'W'.
          PERFORM  P3000_SUM_WRITE.
          NEW-PAGE.
          SV_CHK = '1'.
*          PERFORM  P1000_TITLE_WRITE.
          MOVE  : IT_TAB_SUM-BUKRS     TO  SV_BUKRS,
                  IT_TAB_SUM-CHECK     TO  SV_CHECK,
                  IT_TAB_SUM-WERKS     TO  SV_WERKS,
                  IT_TAB_SUM-MATNR     TO  SV_MATNR,
                  IT_TAB_SUM-SORT      TO  SV_SORT ,
                  IT_TAB_SUM-KSCHL     TO  SV_KSCHL.
         CLEAR : SV_SUM1, SV_SUM2, SV_SUM3, SV_SUM4, SV_DMBTR, SV_CHA.
     ENDIF.
*>> ���� �ݿ����� Ʋ������ SUM WRITE.
      IF  IT_TAB_SUM-BUKRS EQ  SV_BUKRS  AND
          IT_TAB_SUM-CHECK NE  SV_CHECK  .
          SV_JUL = 'C'.
          PERFORM  P3000_SUM_WRITE.
          SV_CHK = '1'.
          MOVE  : IT_TAB_SUM-BUKRS     TO  SV_BUKRS,
                  IT_TAB_SUM-CHECK     TO  SV_CHECK,
                  IT_TAB_SUM-WERKS     TO  SV_WERKS,
                  IT_TAB_SUM-MATNR     TO  SV_MATNR,
                  IT_TAB_SUM-SORT      TO  SV_SORT ,
                  IT_TAB_SUM-KSCHL     TO  SV_KSCHL.
         CLEAR : SV_SUM1, SV_SUM2, SV_SUM3, SV_SUM4, SV_DMBTR, SV_CHA.
     ENDIF.

     IF   IT_TAB_SUM-BUKRS  EQ  SV_BUKRS  AND
          IT_TAB_SUM-CHECK  EQ  SV_CHECK  AND
          IT_TAB_SUM-WERKS  NE  SV_WERKS.
          SV_JUL = 'W'.
          PERFORM  P3000_SUM_WRITE.
          SV_CHK = '1'.
          MOVE  :  IT_TAB_SUM-WERKS     TO  SV_WERKS ,
                   IT_TAB_SUM-MATNR     TO  SV_MATNR,
                   IT_TAB_SUM-SORT      TO  SV_SORT ,
                   IT_TAB_SUM-KSCHL     TO  SV_KSCHL.
         CLEAR : SV_SUM1, SV_SUM2, SV_SUM3, SV_SUM4, SV_DMBTR, SV_CHA.
      ENDIF.

      IF IT_TAB_SUM-BUKRS  EQ  SV_BUKRS  AND
         IT_TAB_SUM-CHECK  EQ  SV_CHECK  AND
         IT_TAB_SUM-WERKS  EQ  SV_WERKS  AND
         IT_TAB_SUM-MATNR  NE  SV_MATNR.
         SV_JUL = 'M'.
         PERFORM  P3000_SUM_WRITE.
         SV_CHK = '2'.
         MOVE : IT_TAB_SUM-MATNR     TO  SV_MATNR ,
                IT_TAB_SUM-SORT      TO  SV_SORT  ,
                IT_TAB_SUM-KSCHL     TO  SV_KSCHL.
         CLEAR : SV_SUM1, SV_SUM2, SV_SUM3, SV_SUM4, SV_DMBTR, SV_CHA.
      ENDIF.

      IF IT_TAB_SUM-BUKRS  EQ  SV_BUKRS  AND
         IT_TAB_SUM-CHECK  EQ  SV_CHECK  AND
         IT_TAB_SUM-WERKS  EQ  SV_WERKS  AND
         IT_TAB_SUM-MATNR  EQ  SV_MATNR  AND
         IT_TAB_SUM-KSCHL  NE  SV_KSCHL  .
         SV_JUL  =  'X'.
         PERFORM  P3000_SUM_WRITE.
         MOVE : IT_TAB_SUM-KSCHL     TO  SV_KSCHL,
                IT_TAB_SUM-SORT      TO  SV_SORT.
         CLEAR : SV_SUM1, SV_SUM2, SV_SUM3, SV_SUM4, SV_DMBTR, SV_CHA.
      ENDIF.

      IF IT_TAB_SUM-BUKRS  EQ  SV_BUKRS  AND
         IT_TAB_SUM-CHECK  EQ  SV_CHECK  AND
         IT_TAB_SUM-WERKS  EQ  SV_WERKS  AND
         IT_TAB_SUM-MATNR  EQ  SV_MATNR  AND
         IT_TAB_SUM-KSCHL  EQ  SV_KSCHL  AND
         IT_TAB_SUM-SORT   NE  SV_SORT.
         SV_DMBTR = 0.
         MOVE  IT_TAB_SUM-SORT  TO  SV_SORT.
      ENDIF.
*>> LINE WRITE.
      PERFORM   P3000_LINE_WRITE.
      CLEAR  SV_CHK.

*>> ��� GROUP ���� SUM.
      CASE  IT_TAB_SUM-SORT.
         WHEN  '1'.
            ADD  IT_TAB_SUM-WRBTR  TO  SV_SUM1.
         WHEN  '2'.
            ADD  IT_TAB_SUM-WRBTR  TO  SV_SUM2.
         WHEN  '3'.
            ADD  IT_TAB_SUM-WRBTR  TO  SV_SUM3.
         WHEN  '4'.
            ADD  IT_TAB_SUM-WRBTR  TO  SV_SUM4.
      ENDCASE.
      ADD  IT_TAB_SUM-WRBTR   TO  SV_DMBTR.
      MOVE IT_TAB_SUM-WAERS   TO  SV_WAERS.

      AT LAST.
         SV_JUL  = 'L'.
         PERFORM P3000_SUM_WRITE.
         WRITE : / SY-ULINE NO-GAP.
      ENDAT.

   ENDLOOP.

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

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE:/ SY-VLINE                NO-GAP.
  IF SV_CHK  EQ  '1'.

     CLEAR : T001W, MAKT, ANLA.
     SELECT SINGLE * FROM T001W WHERE WERKS EQ SV_WERKS.

     SELECT SINGLE * FROM  MAKT
                     WHERE MATNR  EQ  SV_MATNR
                     AND   SPRAS  EQ  SY-LANGU.

     WRITE : SV_WERKS           NO-GAP,
             ' '                NO-GAP,
             SY-VLINE           NO-GAP,
             (18)SV_MATNR       NO-GAP,
             (22)MAKT-MAKTX     NO-GAP,
             SY-VLINE           NO-GAP.
  ELSEIF SV_CHK EQ '2'.
     CLEAR : MAKT, ANLA.
     SELECT SINGLE * FROM  MAKT
                     WHERE MATNR  EQ  SV_MATNR
                     AND   SPRAS  EQ  SY-LANGU.
     WRITE : '     '            NO-GAP,
             SY-VLINE           NO-GAP,
             (18)SV_MATNR       NO-GAP,
             (22)MAKT-MAKTX     NO-GAP,
             SY-VLINE           NO-GAP.
  ELSE.
     WRITE : '     '            NO-GAP,
             SY-VLINE           NO-GAP,
             '                ' NO-GAP,
             '                ' NO-GAP,
             '        '         NO-GAP,
             SY-VLINE           NO-GAP.
  ENDIF.

  WRITE : IT_TAB_SUM-KSCHL      NO-GAP,
          ' '                   NO-GAP,
          IT_TAB_SUM-TEXT       NO-GAP,
          SY-VLINE              NO-GAP,
          IT_TAB_SUM-BEWTK      NO-GAP,
          ' '                   NO-GAP,
          IT_TAB_SUM-BEWTL      NO-GAP,
          SY-VLINE              NO-GAP,
          IT_TAB_SUM-WRBTR CURRENCY IT_TAB_SUM-WAERS  NO-GAP,
          IT_TAB_SUM-WAERS      NO-GAP,
          SY-VLINE              NO-GAP.

   HIDE  IT_TAB_SUM.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_SUM_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_SUM_WRITE.

 IF SV_SORT EQ '1' OR SV_SORT EQ '3'.
    FORMAT RESET.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    IF SV_JUL  EQ 'X' .
       WRITE:/ SY-VLINE                    NO-GAP,
              '     '                      NO-GAP,
              SY-VLINE                     NO-GAP,
              '                    '       NO-GAP,
              '                    '       NO-GAP,
              48  SY-ULINE.
    ELSEIF SV_JUL EQ 'W' OR SV_JUL EQ 'C'.
       WRITE :/ SY-VLINE        NO-GAP,
              2   SY-ULINE.
    ELSEIF SV_JUL EQ 'M'.
       WRITE:/ SY-VLINE                  NO-GAP,
             '     '                     NO-GAP,
             SY-VLINE                    NO-GAP,
             7  SY-ULINE.
   ENDIF.
 ENDIF.

*>> ���� ���� WRITE.
  IF SV_SORT EQ '2'.

     FORMAT RESET.
     FORMAT COLOR COL_NORMAL INTENSIFIED ON.
     SV_CHA  =  SV_SUM1  -  SV_SUM2.

     WRITE:/ SY-VLINE                  NO-GAP,
          '     '                      NO-GAP,
          SY-VLINE                     NO-GAP,
          '                    '       NO-GAP,
          '                    '       NO-GAP.

     FORMAT RESET.
     FORMAT COLOR COL_KEY INTENSIFIED OFF.
     WRITE : SY-VLINE                NO-GAP,
             '     '                 NO-GAP,
             'Defference'            NO-GAP,
             '               '       NO-GAP,
             '                '      NO-GAP,
             '     '                 NO-GAP,
             SY-VLINE                NO-GAP,
             SV_CHA    CURRENCY     SV_WAERS  NO-GAP,
             SV_WAERS                NO-GAP,
             SY-VLINE                NO-GAP.
     IF SV_JUL EQ 'X'.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE:/ SY-VLINE                  NO-GAP,
             '     '                      NO-GAP,
             SY-VLINE                     NO-GAP,
             '                    '       NO-GAP,
             '                    '       NO-GAP,
             48  SY-ULINE.
     ELSEIF SV_JUL EQ 'W' OR SV_JUL EQ 'C'.
        WRITE :/ SY-VLINE        NO-GAP,
               2 SY-ULINE.
     ELSEIF SV_JUL EQ 'M'.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE:/ SY-VLINE                  NO-GAP,
             '     '                      NO-GAP,
             7  SY-ULINE.

     ENDIF.
  ENDIF.

  IF SV_SORT EQ '4'.

     FORMAT RESET.
     FORMAT COLOR COL_NORMAL INTENSIFIED ON.

     SV_CHA  =  SV_SUM3  -  SV_SUM4.

     WRITE:/ SY-VLINE                  NO-GAP,
          '     '                      NO-GAP,
          SY-VLINE                     NO-GAP,
          '                    '       NO-GAP,
          '                    '       NO-GAP.

     FORMAT RESET.
     FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
     WRITE : SY-VLINE                NO-GAP,
             '  '                    NO-GAP.
*     IF SV_CHECK EQ '2'.
*        WRITE   MARKFIELD AS CHECKBOX   NO-GAP.
*     ELSE.
        WRITE ' '                    NO-GAP.
*     ENDIF.
     WRITE :  '  '                    NO-GAP,
             'Defference'            NO-GAP,
             '               '       NO-GAP,
             '                '      NO-GAP,
             '     '                 NO-GAP,
             SY-VLINE                NO-GAP,
             SV_CHA    CURRENCY     SV_WAERS  NO-GAP,
             SV_WAERS                NO-GAP,
             SY-VLINE                NO-GAP.
     HIDE : SV_BUKRS, SV_WERKS, SV_MATNR, SV_MATGB, SV_CHA, SV_WAERS.
     IF SV_JUL EQ 'X'.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE:/ SY-VLINE                  NO-GAP,
             '     '                      NO-GAP,
             SY-VLINE                     NO-GAP,
             '                    '       NO-GAP,
             '                    '       NO-GAP,
             48  SY-ULINE.
     ELSEIF SV_JUL EQ 'W' OR SV_JUL EQ 'C'.
        WRITE :/ SY-VLINE        NO-GAP,
               2  SY-ULINE.
     ELSEIF SV_JUL EQ 'M'.
        FORMAT RESET.
        FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        WRITE:/ SY-VLINE                  NO-GAP,
             '     '                      NO-GAP,
             7  SY-ULINE.

     ENDIF.
   ENDIF.

   IF SV_JUL EQ 'C'.
      FORMAT RESET.
      FORMAT COLOR COL_GROUP INTENSIFIED ON.

      WRITE : / SY-VLINE                  NO-GAP,
                '��ȹ ��� ���� �ݾ� ���� ���� �ݿ����� ����' NO-GAP,
                '��������   ZERO',
                '              '                     NO-GAP,
                '                                  ' NO-GAP,
                '             ' NO-GAP,
                SY-VLINE                  NO-GAP.
        WRITE:/ SY-VLINE                  NO-GAP,
             2  SY-ULINE.
   ENDIF.

ENDFORM.                    " P3000_SUM_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_SL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_GJAHR  text
*      -->P_IT_TAB_BELNR  text
*----------------------------------------------------------------------*
FORM P2000_SHOW_SL USING    P_GJAHR
                            P_BELNR.

  IF IT_TAB-SORT EQ '0'.
     SET PARAMETER ID 'RBN'  FIELD P_BELNR.
     SET PARAMETER ID 'GJR'  FIELD P_GJAHR.
     CALL TRANSACTION 'MIR4' AND SKIP  FIRST SCREEN.
  ENDIF.

  IF IT_TAB-SORT  EQ  '1'.
     SET PARAMETER ID 'MBN'  FIELD P_BELNR.
     SET PARAMETER ID 'MJA'  FIELD P_GJAHR.
*>> �԰��� ��ȸ FUNCTION CALL.
     CALL FUNCTION 'MIGO_DIALOG'
        EXPORTING
           i_action                  = 'A04'
           i_refdoc                  = 'R02'
           i_notree                  = 'X'
*          I_NO_AUTH_CHECK           =
           i_skip_first_screen       = 'X'
*          I_DEADEND                 = 'X'
           i_okcode                  = 'OK_GO'
*          I_LEAVE_AFTER_POST        =
*          i_new_rollarea            = 'X'
*          I_SYTCODE                 =
*          I_EBELN                   =
*          I_EBELP                   =
           i_mblnr                   = P_BELNR
           i_mjahr                   = P_GJAHR
*          I_ZEILE                   =
        EXCEPTIONS
           illegal_combination       = 1
           OTHERS                    = 2.

  ENDIF.

  IF IT_TAB-SORT EQ '2'.
     SET PARAMETER ID 'RBN'  FIELD P_BELNR.
     SET PARAMETER ID 'GJR'  FIELD P_GJAHR.
     CALL TRANSACTION 'MIR4' AND SKIP  FIRST SCREEN.
  ENDIF.

  IF IT_TAB-SORT  EQ  '3'.
     SET PARAMETER ID 'MBN'  FIELD P_BELNR.
     SET PARAMETER ID 'MJA'  FIELD P_GJAHR.
*>> �԰��� ��ȸ FUNCTION CALL.
     CALL FUNCTION 'MIGO_DIALOG'
        EXPORTING
           i_action                  = 'A04'
           i_refdoc                  = 'R02'
           i_notree                  = 'X'
*          I_NO_AUTH_CHECK           =
           i_skip_first_screen       = 'X'
*          I_DEADEND                 = 'X'
           i_okcode                  = 'OK_GO'
*          I_LEAVE_AFTER_POST        =
*          i_new_rollarea            = 'X'
*          I_SYTCODE                 =
*          I_EBELN                   =
*          I_EBELP                   =
           i_mblnr                   = P_BELNR
           i_mjahr                   = P_GJAHR
*          I_ZEILE                   =
        EXCEPTIONS
           illegal_combination       = 1
           OTHERS                    = 2.
  ENDIF.

  IF IT_TAB-SORT EQ '4'.
     SET PARAMETER ID 'BUK'     FIELD IT_TAB-BUKRS.
     SET PARAMETER ID 'GJR'     FIELD P_GJAHR.
     SET PARAMETER ID 'BLN'     FIELD P_BELNR.
     CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
  ENDIF.

  IF IT_TAB-SORT EQ '9'.
     SET PARAMETER ID 'RBN'  FIELD P_BELNR.
     SET PARAMETER ID 'GJR'  FIELD P_GJAHR.
     CALL TRANSACTION 'MIR4' AND SKIP  FIRST SCREEN.
  ENDIF.

ENDFORM.                    " P2000_SHOW_SL
*&---------------------------------------------------------------------*
*&      Module  D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_STATUS_SCR0100 OUTPUT.

  SET PF-STATUS 'STDLISW'.

  CASE INCLUDE.
     WHEN 'POPU'.
        SET TITLEBAR 'PUPU' WITH 'Status LIST'.
     WHEN OTHERS.
  ENDCASE.

  SUPPRESS DIALOG.

ENDMODULE.                 " D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  P3000_SUM_WRITE_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_SUM_WRITE_TAB.

   CLEAR : SV_BUKRS, SV_WERKS, SV_MATNR, SV_SORT,
           IT_TAB,   SV_KSCHL, SV_DMBTR, SV_CHECK,
           SV_GB,    SV_VGABE, SV_BEWTK, SV_BEWTL,
           SV_BEWTP, SV_TEXT,  SV_WAERS.

   LOOP AT IT_TAB.
      CLEAR : IT_TAB_SUM.
      IF SY-TABIX EQ 1.
         MOVE : IT_TAB-BUKRS    TO  SV_BUKRS,
                IT_TAB-CHECK    TO  SV_CHECK,
                IT_TAB-WERKS    TO  SV_WERKS,
                IT_TAB-MATNR    TO  SV_MATNR,
                IT_TAB-SORT     TO  SV_SORT,
                IT_TAB-KSCHL    TO  SV_KSCHL,
                IT_TAB-VGABE    TO  SV_VGABE,
                IT_TAB-BEWTP    TO  SV_BEWTP,
                IT_TAB-BEWTK    TO  SV_BEWTK,
                IT_TAB-BEWTL    TO  SV_BEWTL,
                IT_TAB-TEXT     TO  SV_TEXT,
                IT_TAB-WAERS    TO  SV_WAERS.
      ENDIF.
      IF IT_TAB-BUKRS    NE  SV_BUKRS  OR
         IT_TAB-CHECK    NE  SV_CHECK  OR
         IT_TAB-WERKS    NE  SV_WERKS  OR
         IT_TAB-MATNR    NE  SV_MATNR  OR
         IT_TAB-SORT     NE  SV_SORT   OR
         IT_TAB-KSCHL    NE  SV_KSCHL.
         MOVE : SV_DMBTR      TO  IT_TAB_SUM-WRBTR,
                SV_BUKRS      TO  IT_TAB_SUM-BUKRS,
                SV_CHECK      TO  IT_TAB_SUM-CHECK,
                SV_WERKS      TO  IT_TAB_SUM-WERKS,
                SV_MATNR      TO  IT_TAB_SUM-MATNR,
                SV_SORT       TO  IT_TAB_SUM-SORT,
                SV_KSCHL      TO  IT_TAB_SUM-KSCHL,
                SV_VGABE      TO  IT_TAB_SUM-VGABE,
                SV_BEWTP      TO  IT_TAB_SUM-BEWTP,
                SV_BEWTL      TO  IT_TAB_SUM-BEWTL,
                SV_BEWTK      TO  IT_TAB_SUM-BEWTK,
                SV_TEXT       TO  IT_TAB_SUM-TEXT,
                SV_WAERS      TO  IT_TAB_SUM-WAERS.
         APPEND  IT_TAB_SUM.
         MOVE : IT_TAB-BUKRS    TO  SV_BUKRS,
                IT_TAB-CHECK    TO  SV_CHECK,
                IT_TAB-WERKS    TO  SV_WERKS,
                IT_TAB-MATNR    TO  SV_MATNR,
                IT_TAB-SORT     TO  SV_SORT,
                IT_TAB-KSCHL    TO  SV_KSCHL,
                IT_TAB-VGABE    TO  SV_VGABE,
                IT_TAB-BEWTP    TO  SV_BEWTP,
                IT_TAB-BEWTK    TO  SV_BEWTK,
                IT_TAB-BEWTL    TO  SV_BEWTL,
                IT_TAB-TEXT     TO  SV_TEXT,
                IT_TAB-WAERS    TO  SV_WAERS.

         CLEAR : SV_DMBTR.

      ENDIF.

      ADD : IT_TAB-WRBTR  TO  SV_DMBTR.
   ENDLOOP.

   MOVE : SV_DMBTR      TO  IT_TAB_SUM-WRBTR,
          SV_BUKRS      TO  IT_TAB_SUM-BUKRS,
          SV_CHECK      TO  IT_TAB_SUM-CHECK,
          SV_WERKS      TO  IT_TAB_SUM-WERKS,
          SV_MATNR      TO  IT_TAB_SUM-MATNR,
          SV_SORT       TO  IT_TAB_SUM-SORT,
          SV_KSCHL      TO  IT_TAB_SUM-KSCHL,
          SV_VGABE      TO  IT_TAB_SUM-VGABE,
          SV_BEWTP      TO  IT_TAB_SUM-BEWTP,
          SV_BEWTL      TO  IT_TAB_SUM-BEWTL,
          SV_BEWTK      TO  IT_TAB_SUM-BEWTK,
          SV_TEXT       TO  IT_TAB_SUM-TEXT,
          SV_WAERS      TO  IT_TAB_SUM-WAERS.
   APPEND  IT_TAB_SUM.

   SORT  IT_TAB_SUM  BY  BUKRS  CHECK WERKS  MATNR  KSCHL SORT.

ENDFORM.                    " P3000_SUM_WRITE_TAB
*&---------------------------------------------------------------------*
*&      Form  P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
FORM P2000_SELECT_RECORD USING    P_SY_UCOMM.
DATA : WL_MARK.
   IF P_SY_UCOMM EQ 'MKAL'.
      WL_MARK = 'X'.
   ELSEIF P_SY_UCOMM EQ 'MKLO'.
      CLEAR : WL_MARK.
   ENDIF.
   DO.
      CLEAR MARKFIELD.
      READ LINE SY-INDEX FIELD VALUE MARKFIELD.
      IF SY-SUBRC NE 0.    EXIT.   ENDIF.
      MODIFY CURRENT LINE FIELD VALUE MARKFIELD FROM WL_MARK.
   ENDDO.

ENDFORM.                    " P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR   W_SELECTED_LINES.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : SV_BUKRS       TO IT_SELECTED-BUKRS,
                SV_WERKS       TO IT_SELECTED-WERKS,
                SV_MATNR       TO IT_SELECTED-MATNR,
                SV_CHA         TO IT_SELECTED-WRBTR,
                SV_WAERS       TO IT_SELECTED-WAERS.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_COST_ADJUSTMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_ADJUSTMENT.

   LOOP AT IT_SELECTED.
      " �����ڻ��� ���� MM TRANSACTION CALL.
      PERFORM  P2000_COST_MM_TRANSACTION.
   ENDLOOP.

ENDFORM.                    " P2000_COST_ADJUSTMENT
*&---------------------------------------------------------------------*
*&      Form  P2000_COST_MM_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_MM_TRANSACTION.

   REFRESH : BDCDATA.

   CLEAR : T001W, J_1BBRANCH, W_KONTS_1, W_KONTS_2, W_KONTS, W_KONTH,
           W_KONTS_M, ZTIMIMG11.

   SELECT SINGLE *  FROM  T001W
                    WHERE WERKS  EQ  IT_SELECTED-WERKS.

   " ��ǰ�� GET!
   SELECT SINGLE * FROM  MARA WHERE MATNR EQ IT_SELECTED-MATNR.

   " ������� GET!
   SELECT SINGLE * FROM  T134G
                   WHERE WERKS  EQ  IT_SELECTED-WERKS
                   AND   SPART  EQ  MARA-SPART.

   " ��������ǥ, �����ڵ� GET!
   SELECT SINGLE * FROM  ZTIMIMG11
                   WHERE BUKRS     EQ  IT_SELECTED-BUKRS.

*   "���Ű���, ���Ż����� GET!
*   SELECT SINGLE    KONTS  INTO  W_KONTS_1     "���Ű���.
*                    FROM   T030
*                    WHERE  KTOPL EQ 'CATP'
*                    AND    KTOSL EQ 'EIN'
*                    AND    BWMOD EQ '0001'.
*   SELECT SINGLE    KONTS  INTO  W_KONTS_2     "���Ż�����.
*                    FROM   T030
*                    WHERE  KTOPL EQ 'CATP'
*                    AND    KTOSL EQ 'EKG'
*                    AND    BWMOD EQ '0001'.

   "��������� ���� GET!
   SELECT SINGLE    KONTS  KONTH  INTO (W_KONTS, W_KONTH)
                    FROM   T030
                    WHERE  KTOPL EQ ZTIMIMG11-KTOPL
                    AND    KTOSL EQ 'UMB'
                    AND    BWMOD EQ '0001'.
   "FREIGHT CLEARING ���� GET
   SELECT SINGLE    KONTS INTO   W_KONTS_M
                    FROM  T030
                    WHERE KTOPL  EQ ZTIMIMG11-KTOPL
                    AND   KTOSL  EQ 'FR1'
                    AND   BWMOD  EQ '0001'.

   IT_SELECTED-WRBTR = IT_SELECTED-WRBTR * ( -1 ).

   WRITE IT_SELECTED-WRBTR TO  TEMP_WRBTR
                CURRENCY  IT_SELECTED-WAERS.

   PERFORM    P2000_WRITE_NO_MASK     CHANGING  TEMP_WRBTR.

*<< ���� ��ü ���� ���� TRANSACTION CALL >>
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
           ' ' 'MR21HEAD-BUDAT'  SY-DATUM,
           ' ' 'MR21HEAD-BUKRS'  IT_SELECTED-BUKRS,
           ' ' 'MR21HEAD-WERKS'  IT_SELECTED-WERKS,
           ' ' 'BDC_OKCODE'      '=ENTR'.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
        ' ' 'MR21HEAD-SCREEN_VARIANT'  'LAGERMATERIAL - OHNE BWKEY_025',
        ' ' 'CKI_MR22_0250-MATNR(01)'  IT_SELECTED-MATNR,
        ' ' 'CKI_MR22_0250-ZUUMB(01)'  TEMP_WRBTR,
        ' ' 'BDC_OKCODE'      '=ENTR'.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
        ' ' 'BDC_OKCODE'      '=SAVE'.

   SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
   SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
*>> BDC CALL.
    CALL TRANSACTION 'MR22'  USING       BDCDATA
                             MODE        'N'
                             UPDATE      'S'
                             MESSAGES    INTO   MESSTAB.
   W_SUBRC = SY-SUBRC.

   IF W_SUBRC NE 0.      ">> ERROR �߻���.
      LOOP AT MESSTAB.
         MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                MESSTAB-MSGID   TO     RETURN-MSGID,
                MESSTAB-MSGNR   TO     RETURN-MSGNR,
                MESSTAB-MSGV1   TO     RETURN-MSGV1,
                MESSTAB-MSGV2   TO     RETURN-MSGV2,
                MESSTAB-MSGV3   TO     RETURN-MSGV3,
                MESSTAB-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ENDLOOP.
      W_SUBRC = 4.
   ELSE.                 ">> SUCCESS ��.
      GET PARAMETER ID 'MLN' FIELD W_BELNR.
      GET PARAMETER ID 'MLJ' FIELD W_GJAHR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
      IF W_BELNR IS INITIAL.

*>>> ����..(����� ���� ��....)
         W_SUBRC = 4.
         MESSAGE S648.
         MOVE : 'E'             TO     RETURN-MSGTYP,
                'ZIM'           TO     RETURN-MSGID,
                '494'           TO     RETURN-MSGNR,
                SPACE           TO     RETURN-MSGV1,
                SPACE           TO     RETURN-MSGV2,
                SPACE           TO     RETURN-MSGV3,
                SPACE           TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ELSE.
         MESSAGE S260(M8) WITH W_BELNR.
         MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                SY-MSGID   TO     RETURN-MSGID,
                SY-MSGNO   TO     RETURN-MSGNR,
                SY-MSGV1   TO     RETURN-MSGV1,
                SY-MSGV2   TO     RETURN-MSGV2,
                SY-MSGV3   TO     RETURN-MSGV3,
                SY-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
         W_SUBRC = 0.
      ENDIF.
   ENDIF.
*---------------------<  ���� ���� ���� END  >-------------------------*

*---------------------<  FI ���� ���� START  >-------------------------*
  IF W_SUBRC EQ 0.

     IF IT_SELECTED-WRBTR LE 0.
        IT_SELECTED-WRBTR = IT_SELECTED-WRBTR * ( -1 ).

        WRITE IT_SELECTED-WRBTR TO  TEMP_WRBTR
                          CURRENCY  IT_SELECTED-WAERS.

        PERFORM    P2000_WRITE_NO_MASK     CHANGING  TEMP_WRBTR.
        IT_SELECTED-WRBTR = IT_SELECTED-WRBTR * ( -1 ).
     ENDIF.

     REFRESH : BDCDATA.
*<< GR/IR �ӽ� ���� BALANCE ����Ű�� ��ǥ �߻� >>
   " ���Ű���.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'       '0100',
           ' ' 'BKPF-BLDAT'      SY-DATUM,
           ' ' 'BKPF-BUDAT'      SY-DATUM,
           ' ' 'BKPF-BLART'      'RE',
           ' ' 'BKPF-BUKRS'      IT_SELECTED-BUKRS,
           ' ' 'BKPF-WAERS'      'KRW'.

   " �԰�� �߻��� GR/IR ���� CLEAR.
   LOOP  AT  IT_TAB  WHERE BUKRS  EQ  IT_SELECTED-BUKRS
                     AND   WERKS  EQ  IT_SELECTED-WERKS
                     AND   MATNR  EQ  IT_SELECTED-MATNR
                     AND   SORT   EQ  '3'
                     AND   CHECK  EQ  '2'.

      IF IT_TAB-WRBTR  GT  0.
         PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'     '50',
              ' ' 'RF05A-NEWKO'      W_KONTS_M,
              ' ' 'BDC_OKCODE'       '/00'.
      ELSE.
         PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'     '40',
              ' ' 'RF05A-NEWKO'      W_KONTS_M,
              ' ' 'BDC_OKCODE'       '/00'.
      ENDIF.
    ENDLOOP.

   " A/P �߻��� GR/IR ���� CLEAR.
   LOOP  AT  IT_TAB  WHERE BUKRS  EQ  IT_SELECTED-BUKRS
                     AND   WERKS  EQ  IT_SELECTED-WERKS
                     AND   MATNR  EQ  IT_SELECTED-MATNR
                     AND   SORT   EQ  '4'
                     AND   CHECK  EQ  '2'.

      IF IT_TAB-WRBTR  GT  0.
         PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'     '40',
              ' ' 'RF05A-NEWKO'      W_KONTS_M,
              ' ' 'BDC_OKCODE'       '/00'.
      ELSE.
         PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'     '50',
              ' ' 'RF05A-NEWKO'      W_KONTS_M,
              ' ' 'BDC_OKCODE'       '/00'.
      ENDIF.
   ENDLOOP.

   " ���� ACTUAL �ݾװ� PLANNED ��� ���� �ݾ�.
   IF IT_SELECTED-WRBTR GT 0.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '40',
           ' ' 'RF05A-NEWKO'      W_KONTH,
           ' ' 'BDC_OKCODE'       '/00'.
   ELSE.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '50',
           ' ' 'RF05A-NEWKO'      W_KONTS,
           ' ' 'BDC_OKCODE'       '/00'.
   ENDIF.

*   IF IT_SELECTED-WRBTR GT 0.
*      PERFORM P2000_DYNPRO USING :
*           ' ' 'RF05A-NEWBS'     '40',
*           ' ' 'RF05A-NEWKO'      W_KONTS_1,
*           ' ' 'BDC_OKCODE'       '/00'.
*   ELSE.
*      PERFORM P2000_DYNPRO USING :
*           ' ' 'RF05A-NEWBS'     '50',
*           ' ' 'RF05A-NEWKO'      W_KONTS_1,
*           ' ' 'BDC_OKCODE'       '/00'.
*   ENDIF.
*   " ���Ż�����.
*   PERFORM P2000_DYNPRO USING :
*           'X' 'SAPMF05A'       '0300',
*           ' ' 'BSEG-BUPLA'      T001W-J_1BBRANCH,
*           ' ' 'BSEG-WRBTR'      TEMP_WRBTR.
*   IF IT_SELECTED-WRBTR GT 0.
*      PERFORM P2000_DYNPRO USING :
*           ' ' 'RF05A-NEWBS'     '50',
*           ' ' 'RF05A-NEWKO'      W_KONTS_2,
*           ' ' 'BDC_OKCODE'       '/00'.
*   ELSE.
*      PERFORM P2000_DYNPRO USING :
*           ' ' 'RF05A-NEWBS'     '40',
*           ' ' 'RF05A-NEWKO'      W_KONTS_2,
*           ' ' 'BDC_OKCODE'       '/00'.
*   ENDIF.
   " �������.
*   PERFORM P2000_DYNPRO USING :
*           'X' 'SAPLKACB'        '0002',
*           ' ' 'COBL-GSBER'      T134G-GSBER,
*           ' ' 'BDC_OKCODE'      '=ENTE'.
   " ���������, �ս� ����.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'       '0300',
           ' ' 'BSEG-BUPLA'      T001W-J_1BBRANCH,
           ' ' 'BSEG-WRBTR'      TEMP_WRBTR.
   IF IT_SELECTED-WRBTR GT 0.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '40',
           ' ' 'RF05A-NEWKO'      W_KONTH,
           ' ' 'BDC_OKCODE'       '/00'.
   ELSE.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '50',
           ' ' 'RF05A-NEWKO'      W_KONTS,
           ' ' 'BDC_OKCODE'       '/00'.
   ENDIF.
   " �������.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPLKACB'        '0002',
           ' ' 'COBL-GSBER'      T134G-GSBER,
           ' ' 'BDC_OKCODE'      '=ENTE'.
   " FREIGH CLEARING ����.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'       '0300',
           ' ' 'BSEG-BUPLA'      T001W-J_1BBRANCH,
           ' ' 'BSEG-WRBTR'      TEMP_WRBTR.
   IF IT_SELECTED-WRBTR GT 0.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '50',
           ' ' 'RF05A-NEWKO'      W_KONTS_M,
           ' ' 'BDC_OKCODE'       '/00'.
   ELSE.
      PERFORM P2000_DYNPRO USING :
           ' ' 'RF05A-NEWBS'     '40',
           ' ' 'RF05A-NEWKO'      W_KONTS_M,
           ' ' 'BDC_OKCODE'       '/00'.
   ENDIF.
   " �������.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPLKACB'        '0002',
           ' ' 'COBL-GSBER'      T134G-GSBER,
           ' ' 'BDC_OKCODE'      '=ENTE'.

   " FREIGH CLEARING ����.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'       '0300',
           ' ' 'BSEG-BUPLA'      T001W-J_1BBRANCH,
           ' ' 'BSEG-WRBTR'      TEMP_WRBTR,
           ' ' 'BDC_OKCODE'      '=BU'.

   " �������.
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPLKACB'        '0002',
           ' ' 'COBL-GSBER'      T134G-GSBER,
           ' ' 'BDC_OKCODE'      '=ENTE'.

   SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
   SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
*>> BDC CALL.
    CALL TRANSACTION 'F-02'  USING       BDCDATA
                             MODE        'N'
                             UPDATE      'S'
                             MESSAGES    INTO   MESSTAB.
   W_SUBRC = SY-SUBRC.

   IF W_SUBRC NE 0.      ">> ERROR �߻���.
      LOOP AT MESSTAB.
         MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                MESSTAB-MSGID   TO     RETURN-MSGID,
                MESSTAB-MSGNR   TO     RETURN-MSGNR,
                MESSTAB-MSGV1   TO     RETURN-MSGV1,
                MESSTAB-MSGV2   TO     RETURN-MSGV2,
                MESSTAB-MSGV3   TO     RETURN-MSGV3,
                MESSTAB-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ENDLOOP.
      W_SUBRC = 4.
   ELSE.                 ">> SUCCESS ��.
      GET PARAMETER ID 'BLN' FIELD W_ACDO.
      GET PARAMETER ID 'GJR' FIELD W_FIYR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
      IF W_BELNR IS INITIAL.

*>>> ����..(����� ���� ��....)
         W_SUBRC = 4.
         MESSAGE S648.
         MOVE : 'E'             TO     RETURN-MSGTYP,
                'ZIM'           TO     RETURN-MSGID,
                '494'           TO     RETURN-MSGNR,
                SPACE           TO     RETURN-MSGV1,
                SPACE           TO     RETURN-MSGV2,
                SPACE           TO     RETURN-MSGV3,
                SPACE           TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ELSE.
         MESSAGE S260(M8) WITH W_BELNR.
         MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                SY-MSGID   TO     RETURN-MSGID,
                SY-MSGNO   TO     RETURN-MSGNR,
                SY-MSGV1   TO     RETURN-MSGV1,
                SY-MSGV2   TO     RETURN-MSGV2,
                SY-MSGV3   TO     RETURN-MSGV3,
                SY-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
         W_SUBRC = 0.
      ENDIF.
   ENDIF.
  ENDIF.
*<< ���� DB �� DATA INSERT >>------------------------------------------*
  IF W_SUBRC EQ 0.

     SELECT MAX( ZFSEQ )  INTO  W_ZFSEQ
     FROM   ZTBCOST
     WHERE  BUKRS    EQ  IT_SELECTED-BUKRS
     AND    WERKS    EQ  IT_SELECTED-WERKS
     AND    MATNR    EQ  IT_SELECTED-MATNR.

     IF SY-SUBRC NE 0 OR W_ZFSEQ IS INITIAL.
        W_ZFSEQ  =  1.
     ELSE.
        W_ZFSEQ  =  W_ZFSEQ  +  1.
     ENDIF.

     CLEAR :  ZTBCOST.
     IF IT_SELECTED-WRBTR GT 0.
        MOVE : '1'                TO  ZTBCOST-ZFGIHO,
               'KRW'              TO  ZTBCOST-ZFKRW,
               IT_SELECTED-WRBTR  TO  ZTBCOST-DMBTR.
     ELSE.
        IT_SELECTED-WRBTR = ( -1 ) * IT_SELECTED-WRBTR.

        MOVE : '2'                TO   ZTBCOST-ZFGIHO,
               'KRW'              TO   ZTBCOST-ZFKRW,
               IT_SELECTED-WRBTR  TO   ZTBCOST-DMBTR.
     ENDIF.

     MOVE  :  IT_SELECTED-BUKRS   TO   ZTBCOST-BUKRS  ,
              IT_SELECTED-WERKS   TO   ZTBCOST-WERKS  ,
              IT_SELECTED-MATNR   TO   ZTBCOST-MATNR  ,
              '1'                 TO   ZTBCOST-ZFMATGB,
              W_ZFSEQ             TO   ZTBCOST-ZFSEQ  ,
              SY-DATUM            TO   ZTBCOST-BUDAT  ,
              W_GJAHR             TO   ZTBCOST-ZFGJAHR ,
              W_BELNR             TO   ZTBCOST-ZFBELNR ,
              W_FIYR              TO   ZTBCOST-ZFFIYR ,
              W_ACDO              TO   ZTBCOST-ZFACDO ,
              SY-UNAME            TO   ZTBCOST-ERNAM  ,
              SY-DATUM            TO   ZTBCOST-CDAT   ,
              SY-UZEIT            TO   ZTBCOST-CTME.

     INSERT  ZTBCOST.

     LOOP AT IT_TAB WHERE BUKRS  EQ  IT_SELECTED-BUKRS
                    AND   WERKS  EQ  IT_SELECTED-WERKS
                    AND   MATNR  EQ  IT_SELECTED-MATNR.

        CLEAR : ZTBCOIT.
        ADD    1                 TO  W_SEQIT.
        MOVE : IT_TAB-BUKRS      TO  ZTBCOIT-BUKRS ,
               IT_TAB-WERKS      TO  ZTBCOIT-WERKS ,
               IT_TAB-MATNR      TO  ZTBCOIT-MATNR ,
               IT_TAB-ZFFIYR     TO  ZTBCOIT-ZFFIYR ,
               IT_TAB-ZFACDO     TO  ZTBCOIT-ZFACDO ,
               W_ZFSEQ           TO  ZTBCOIT-ZFSEQ  ,
               W_SEQIT           TO  ZTBCOIT-ZFSEQIT.

        INSERT  ZTBCOIT.
        IF SY-SUBRC NE 0.
           ROLLBACK WORK.
        ENDIF.

     ENDLOOP.
  ENDIF.

*----------------------< ���� DB �ݿ� END >----------------------------*
ENDFORM.                    " P2000_COST_MM_TRANSACTION
*&---------------------------------------------------------------------*
*&      Form  P2000_COST_FI_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_FI_TRANSACTION.

*<< �����ڻ꿡 ���� GR/IR �ӽ� ���� CLEAR >>---------------------------*
   CLEAR : TEMP_WRBTR, T001W, W_WRBTR, ANLZ.

   " �ڻ� �����Ϳ� �ִ� �������, �ڽ�Ʈ��Ÿ GET!
   SELECT  * FROM  ANLZ UP TO 1 ROWS
   WHERE   BUKRS   EQ   IT_SELECTED-BUKRS
   AND     ANLN1   EQ   IT_SELECTED-MATNR.
   ENDSELECT.

   REFRESH : BDCDATA.

   IF IT_SELECTED-WRBTR < 0.
      W_WRBTR = IT_SELECTED-WRBTR * ( -1 ).
   ENDIF.

   WRITE W_WRBTR  TO  TEMP_WRBTR
                  CURRENCY  IT_SELECTED-WAERS.

   SELECT  SINGLE * FROM   T001W
           WHERE    WERKS  EQ  IT_SELECTED-WERKS.

   PERFORM    P2000_WRITE_NO_MASK     CHANGING  TEMP_WRBTR.

*<< ���� ��ü ���� ���� TRANSACTION CALL >>
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'        '0100',
           ' ' 'BKPF-BLART'      'AA'    ,
           ' ' 'BKPF-BLDAT'      SY-DATUM,
           ' ' 'BKPF-BUDAT'      SY-DATUM,
           ' ' 'BKPF-BUKRS'      IT_SELECTED-BUKRS,
           ' ' 'BKPF-WAERS'      IT_SELECTED-WAERS.

   IF IT_SELECTED-WRBTR GT 0.
      PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'  '70'   ,
              ' ' 'RF05A-NEWKO'  IT_SELECTED-MATNR,
              ' ' 'RF05A-NEWBW'  '100'            ,
              ' ' 'BDC_OKCODE'      '/00'.
   ELSE.
      PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'  '75'   ,
              ' ' 'RF05A-NEWKO'  IT_SELECTED-MATNR,
              ' ' 'RF05A-NEWBW'  '100'            ,
              ' ' 'BDC_OKCODE'      '/00'.
   ENDIF.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'    '0305',
           ' ' 'BSEG-WRBTR'  TEMP_WRBTR,
           ' ' 'COBL-KOSTL'   ANLZ-KOSTL,
           ' ' 'BSEG-BUPLA'  T001W-J_1BBRANCH,
           ' ' 'BSEG-SGTXT'  '���� �����ڻ� �δ�� ����'.

   IF IT_SELECTED-WRBTR GT 0.
      PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'  '50'   ,
              ' ' 'RF05A-NEWKO'  '112080880',
              ' ' 'BDC_OKCODE'      '/00'.
   ELSE.
      PERFORM P2000_DYNPRO USING :
              ' ' 'RF05A-NEWBS'  '40'   ,
              ' ' 'RF05A-NEWKO'  '112080880',
              ' ' 'BDC_OKCODE'      '/00'.
   ENDIF.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPMF05A'    '0300',
           ' ' 'BSEG-WRBTR'  TEMP_WRBTR,
           ' ' 'BSEG-BUPLA'  T001W-J_1BBRANCH,
           ' ' 'BSEG-SGTXT'  '���� �����ڻ� �δ�� ����',
           ' ' 'COBL-GSBER'   ANLZ-GSBER,
           ' ' 'COBL-PRTCR'   ANLZ-KOSTL,
           ' ' 'BDC_OKCODE'      '=SAVE'.

   SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
   SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
*>> BDC CALL.
    CALL TRANSACTION 'F-02'  USING       BDCDATA
                             MODE        'A'
                             UPDATE      'S'
                             MESSAGES    INTO   MESSTAB.
   W_SUBRC = SY-SUBRC.

   IF W_SUBRC NE 0.      ">> ERROR �߻���.
      LOOP AT MESSTAB.
         MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                MESSTAB-MSGID   TO     RETURN-MSGID,
                MESSTAB-MSGNR   TO     RETURN-MSGNR,
                MESSTAB-MSGV1   TO     RETURN-MSGV1,
                MESSTAB-MSGV2   TO     RETURN-MSGV2,
                MESSTAB-MSGV3   TO     RETURN-MSGV3,
                MESSTAB-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ENDLOOP.
      W_SUBRC = 4.
   ELSE.                 ">> SUCCESS ��.
      GET PARAMETER ID 'BLN' FIELD W_BELNR.
      GET PARAMETER ID 'GJR' FIELD W_GJAHR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
      IF W_BELNR IS INITIAL.

*>>> ����..(����� ���� ��....)
         W_SUBRC = 4.
         MESSAGE S648.
         MOVE : 'E'             TO     RETURN-MSGTYP,
                'ZIM'           TO     RETURN-MSGID,
                '494'           TO     RETURN-MSGNR,
                SPACE           TO     RETURN-MSGV1,
                SPACE           TO     RETURN-MSGV2,
                SPACE           TO     RETURN-MSGV3,
                SPACE           TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ELSE.
         MESSAGE S260(M8) WITH W_BELNR.
         MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                SY-MSGID   TO     RETURN-MSGID,
                SY-MSGNO   TO     RETURN-MSGNR,
                SY-MSGV1   TO     RETURN-MSGV1,
                SY-MSGV2   TO     RETURN-MSGV2,
                SY-MSGV3   TO     RETURN-MSGV3,
                SY-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
         W_SUBRC = 0.
      ENDIF.
   ENDIF.
*---------------------<  FI ���� ���� END  >-------------------------*

*<< ���� DB �� DATA INSERT >>------------------------------------------*
  IF W_SUBRC EQ 0.

     SELECT MAX( ZFSEQ )  INTO  W_ZFSEQ
     FROM   ZTBCOST
     WHERE  BUKRS    EQ  IT_SELECTED-BUKRS
     AND    WERKS    EQ  IT_SELECTED-WERKS
     AND    MATNR    EQ  IT_SELECTED-MATNR.

     IF SY-SUBRC NE 0 OR W_ZFSEQ IS INITIAL.
        W_ZFSEQ  =  1.
     ELSE.
        W_ZFSEQ  =  W_ZFSEQ  +  1.
     ENDIF.

     CLEAR :  ZTBCOST.
     MOVE  :  IT_SELECTED-BUKRS   TO   ZTBCOST-BUKRS  ,
              IT_SELECTED-WERKS   TO   ZTBCOST-WERKS  ,
              IT_SELECTED-MATNR   TO   ZTBCOST-MATNR  ,
              IT_SELECTED-MATGB   TO   ZTBCOST-ZFMATGB,
              IT_SELECTED-WRBTR   TO   ZTBCOST-DMBTR,
              'KRW'               TO   ZTBCOST-ZFKRW,
              '1'                 TO   ZTBCOST-ZFGIHO,
              W_ZFSEQ             TO   ZTBCOST-ZFSEQ  ,
              SY-DATUM            TO   ZTBCOST-BUDAT  ,
              W_GJAHR             TO   ZTBCOST-ZFGJAHR ,
              W_BELNR             TO   ZTBCOST-ZFBELNR ,
              W_FIYR              TO   ZTBCOST-ZFFIYR ,
              W_ACDO              TO   ZTBCOST-ZFACDO ,
              SY-UNAME            TO   ZTBCOST-ERNAM  ,
              SY-DATUM            TO   ZTBCOST-CDAT   ,
              SY-UZEIT            TO   ZTBCOST-CTME   .

     INSERT  ZTBCOST.
  ENDIF.

  LOOP AT IT_TAB WHERE BUKRS  EQ  IT_SELECTED-BUKRS
                 AND   WERKS  EQ  IT_SELECTED-WERKS
                 AND   MATNR  EQ  IT_SELECTED-MATNR.

     CLEAR : ZTBCOIT.
     ADD    1                 TO  W_SEQIT.
     MOVE : IT_TAB-BUKRS      TO  ZTBCOIT-BUKRS ,
            IT_TAB-WERKS      TO  ZTBCOIT-WERKS ,
            IT_TAB-MATNR      TO  ZTBCOIT-MATNR ,
            IT_TAB-ZFFIYR     TO  ZTBCOIT-ZFFIYR ,
            IT_TAB-ZFACDO     TO  ZTBCOIT-ZFACDO ,
            W_ZFSEQ           TO  ZTBCOIT-ZFSEQ  ,
            W_SEQIT           TO  ZTBCOIT-ZFSEQIT.

     INSERT  ZTBCOIT.

  ENDLOOP.

*----------------------< ���� DB �ݿ� END >----------------------------*

ENDFORM.                    " P2000_COST_FI_TRANSACTION
*&---------------------------------------------------------------------*
*&      Form  P2000_WRITE_NO_MASK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_TEMP_WRBTR  text
*----------------------------------------------------------------------*
FORM P2000_WRITE_NO_MASK CHANGING P_TEXT_AMOUNT.

  SELECT SINGLE * FROM USR01 WHERE BNAME EQ SY-UNAME.

  CASE USR01-DCPFM.
     WHEN 'X'.    " Decimal point is period: N,NNN.NN
        PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT ',' ' '.
        CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
     WHEN 'Y'.    " Decimal point is N NNN NNN,NN
        PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  ',' '.'.
        CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
     WHEN OTHERS. " Decimal point is comma: N.NNN,NN
        PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  '.' ' '.
        PERFORM    P2000_CHANGE_SYMBOL    USING P_TEXT_AMOUNT  ',' '.'.
        CONDENSE         P_TEXT_AMOUNT    NO-GAPS.
  ENDCASE.


ENDFORM.                    " P2000_WRITE_NO_MASK
*&---------------------------------------------------------------------*
*&      Form  P2000_CHANGE_SYMBOL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_TEXT_AMOUNT  text
*      -->P_2806   text
*      -->P_2807   text
*----------------------------------------------------------------------*
FORM P2000_CHANGE_SYMBOL USING    P_AMOUNT  P_FROM  P_TO.

  DO.
     REPLACE  P_FROM   WITH   P_TO  INTO    P_AMOUNT.
        IF  SY-SUBRC  <>    0.
            EXIT.
        ENDIF.
  ENDDO.

ENDFORM.                    " P2000_CHANGE_SYMBOL
*&---------------------------------------------------------------------*
*&      Form  P3000_READ_CODATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_READ_CODATA.

   SELECT  A~BUKRS  A~WERKS  A~MATNR  A~ZFSEQ
   INTO    CORRESPONDING   FIELDS OF TABLE IT_CO
   FROM    ZTBCOST  AS  A  INNER  JOIN  ZTBCOIT  AS  B
   ON      A~BUKRS         EQ     B~BUKRS
   AND     A~WERKS         EQ     B~WERKS
   AND     A~MATNR         EQ     B~MATNR
   AND     A~ZFSEQ         EQ     B~ZFSEQ
   FOR     ALL    ENTRIES  IN     IT_TAB
   WHERE   B~ZFFIYR        EQ     IT_TAB-ZFFIYR
   AND     B~ZFACDO        EQ     IT_TAB-ZFACDO
   GROUP   BY
           A~BUKRS  A~WERKS  A~MATNR  A~ZFSEQ .

   SELECT *  INTO  CORRESPONDING FIELDS OF TABLE IT_ZSBCOST
   FROM   ZTBCOST
   FOR    ALL  ENTRIES  IN  IT_CO
   WHERE  BUKRS         EQ  IT_CO-BUKRS
   AND    WERKS         EQ  IT_CO-WERKS
   AND    MATNR         EQ  IT_CO-MATNR
   AND    ZFSEQ         EQ  IT_CO-ZFSEQ .

   SORT  IT_ZSBCOST  BY  MATNR BUDAT.

ENDFORM.                    " P3000_READ_CODATA
*&---------------------------------------------------------------------*
*&      Form  P2000_COANAL_HISTORY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COANAL_HISTORY.

  LEAVE TO LIST-PROCESSING.

  G_REPID = SY-REPID.
  CLEAR G_VARIANT.
  G_VARIANT-REPORT = G_REPID.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
            I_CALLBACK_PROGRAM       = G_REPID
            I_STRUCTURE_NAME         = 'ZSBCOST'
            I_CALLBACK_PF_STATUS_SET = G_STATUS
            I_CALLBACK_USER_COMMAND  = G_USER_COMMAND
            I_SAVE                   = G_SAVE
            IS_VARIANT               = G_VARIANT
       TABLES
            T_OUTTAB         = IT_ZSBCOST.

  CLEAR : OK-CODE.

ENDFORM.                    " P2000_COANAL_HISTORY

*---------------------------------------------------------------------*
*       FORM USER_COMMAND                                             *
*---------------------------------------------------------------------*
FORM P2000_USER_COMMAND USING R_UCOMM     LIKE SY-UCOMM
                              RS_SELFIELD TYPE SLIS_SELFIELD.

  CASE  R_UCOMM.
    WHEN  'WAHL'.                      "menubutton
       READ TABLE  IT_ZSBCOST INDEX RS_SELFIELD-TABINDEX. "cursorposit.
       IF SY-SUBRC EQ 0.
         PERFORM  P2000_FI_DOCUMENT_DISPLAY
                                USING   IT_ZSBCOST-ZFMATGB
                                        IT_ZSBCOST-BUKRS
                                        IT_ZSBCOST-ZFGJAHR
                                        IT_ZSBCOST-ZFBELNR.
       ELSE.
          MESSAGE S962.
       ENDIF.
       CLEAR R_UCOMM.
    WHEN 'FB03'.
       READ TABLE  IT_ZSBCOST INDEX RS_SELFIELD-TABINDEX. "cursorposit.
       IF SY-SUBRC EQ 0.
          IF IT_ZSBCOST-ZFACDO IS INITIAL.
             MESSAGE  S589.
          ELSE.
             PERFORM  P2000_FI_DOCUMENT_DISPLAY
                                        USING   '2'
                                                IT_ZSBCOST-BUKRS
                                                IT_ZSBCOST-ZFFIYR
                                                IT_ZSBCOST-ZFACDO.
           ENDIF.
       ELSE.
          MESSAGE S962.
       ENDIF.
       CLEAR R_UCOMM.

    WHEN 'CANC'.
       READ TABLE  IT_ZSBCOST INDEX RS_SELFIELD-TABINDEX. "cursorposit.
       IF SY-SUBRC EQ 0.
          IF NOT IT_ZSBCOST-ZFCNCX IS INITIAL.
             MESSAGE  S426.
          ELSE.
             PERFORM  P2000_COST_ADJUSTMENT_CANCEL.
          ENDIF.
       ELSE.
          MESSAGE S962.
       ENDIF.
       CLEAR R_UCOMM.

    WHEN '&IC1'.                       "doubleclick
       READ TABLE IT_ZSBCOST INDEX RS_SELFIELD-TABINDEX. "cursorposit.
       IF SY-SUBRC EQ 0.
         PERFORM  P2000_FI_DOCUMENT_DISPLAY
                                USING   IT_ZSBCOST-ZFMATGB
                                        IT_ZSBCOST-BUKRS
                                        IT_ZSBCOST-ZFGJAHR
                                        IT_ZSBCOST-ZFBELNR.
       ELSE.
          MESSAGE S962.
       ENDIF.
       CLEAR R_UCOMM.
  ENDCASE.
ENDFORM.

FORM P2000_SET_STATUS  USING  EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'STANDA02' EXCLUDING EXTAB.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_LIST_CHECK_SCR0100 INPUT.

   LEAVE TO LIST-PROCESSING.
   CASE INCLUDE.
      WHEN 'POPU'.
         FORMAT COLOR COL_HEADING INTENSIFIED OFF.
         WRITE : / SY-ULINE(96),    /   SY-VLINE NO-GAP,
                   '����'   NO-GAP,     SY-VLINE NO-GAP,
                   '�޼��� �ؽ�Ʈ',  94 SY-VLINE NO-GAP,
                   'T'      NO-GAP,     SY-VLINE,
                 / SY-ULINE(96).
         LOOP AT RETURN.
            W_MOD  =  SY-TABIX MOD 2.
            FORMAT RESET.
            IF W_MOD EQ 0.
               FORMAT COLOR COL_NORMAL  INTENSIFIED ON.
            ELSE.
               FORMAT COLOR COL_NORMAL  INTENSIFIED OFF.
            ENDIF.
            WRITE : / SY-VLINE NO-GAP, RETURN-ICON(4) NO-GAP,
                      SY-VLINE NO-GAP, RETURN-MESSTXT(87) NO-GAP,
                      SY-VLINE NO-GAP.

            CASE RETURN-MSGTYP.
               WHEN 'E'.
                  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
               WHEN 'W'.
                  FORMAT COLOR COL_KEY      INTENSIFIED OFF.
               WHEN 'I'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
               WHEN 'S'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
            ENDCASE.

            WRITE : RETURN-MSGTYP(1) NO-GAP, SY-VLINE NO-GAP.
*                   / SY-ULINE(96).
            HIDE:RETURN.
         ENDLOOP.
         WRITE : / SY-ULINE(96).
         CLEAR : RETURN.
      WHEN OTHERS.
   ENDCASE.

ENDMODULE.                 " D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_FI_DOCUMENT_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_ZSBHIS_BUKRS  text
*      -->P_IT_ZSBHIS_ZFGJAHR  text
*      -->P_IT_ZSBHIS_ZFBELNR  text
*----------------------------------------------------------------------*
FORM P2000_FI_DOCUMENT_DISPLAY USING    P_GUBUN
                                        P_BUKRS
                                        P_GJAHR
                                        P_BELNR.
   IF P_BELNR IS INITIAL.
      MESSAGE S589.   EXIT.
   ELSE.
      IF P_GUBUN EQ '1'.
         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
         SET PARAMETER ID 'MLJ'    FIELD P_GJAHR.
         SET PARAMETER ID 'MLN'    FIELD P_BELNR.
         CALL TRANSACTION 'CKMPCD' AND SKIP FIRST SCREEN.
      ELSE.
         SET PARAMETER ID 'BLN'    FIELD P_BELNR.
         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
         CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDIF.
   ENDIF.

ENDFORM.                    " P2000_FI_DOCUMENT_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  P2000_COST_ADJUSTMENT_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_ADJUSTMENT_CANCEL.

   " ���а� ����.
   PERFORM P4000_GET_INIVAL.

   " �����ڻ��� ���� MM TRANSACTION CALL.
   IF IT_ZSBCOST-ZFMATGB EQ '1'.
      PERFORM  P2000_COST_MM_CANCEL.
   " �����ڻ��� ���� FI TRANSACTION CALL.
   ELSE.
      PERFORM  P2000_COST_FI_CANCEL.
   ENDIF.

ENDFORM.                    " P2000_COST_ADJUSTMENT_CANCEL
*&---------------------------------------------------------------------*
*&      Form  P2000_COST_MM_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_MM_CANCEL.

   CLEAR : T001W, J_1BBRANCH, W_KONTS_1, W_KONTS_2, W_KONTS, W_KONTH,
           W_KONTS_M.

   REFRESH : BDCDATA, RETURN.

   IF IT_ZSBCOST-ZFGIHO EQ '1'.
      IT_ZSBCOST-DMBTR = IT_ZSBCOST-DMBTR * ( -1 ).
   ENDIF.

   WRITE IT_ZSBCOST-DMBTR TO  TEMP_WRBTR
                CURRENCY  'KRW'.

   PERFORM    P2000_WRITE_NO_MASK     CHANGING  TEMP_WRBTR.

*<< ���� ��ü ���� ���� TRANSACTION CALL >>
   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
           ' ' 'MR21HEAD-BUDAT'  SY-DATUM,
           ' ' 'MR21HEAD-BUKRS'  IT_ZSBCOST-BUKRS,
           ' ' 'MR21HEAD-WERKS'  IT_ZSBCOST-WERKS,
           ' ' 'BDC_OKCODE'      '=ENTR'.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
        ' ' 'CKI_MR22_0250-MATNR(01)'  IT_ZSBCOST-MATNR,
        ' ' 'CKI_MR22_0250-ZUUMB(01)'  TEMP_WRBTR,
        ' ' 'BDC_OKCODE'      '=ENTR'.

   PERFORM P2000_DYNPRO USING :
           'X' 'SAPRCKM_MR22'    '0201',
        ' ' 'BDC_OKCODE'      '=SAVE'.

   SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
   SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.
*>> BDC CALL.
    CALL TRANSACTION 'MR22'  USING       BDCDATA
                             MODE        'A'
                             UPDATE      'S'
                             MESSAGES    INTO   MESSTAB.
   W_SUBRC = SY-SUBRC.

   IF W_SUBRC NE 0.      ">> ERROR �߻���.
      LOOP AT MESSTAB.
         MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                MESSTAB-MSGID   TO     RETURN-MSGID,
                MESSTAB-MSGNR   TO     RETURN-MSGNR,
                MESSTAB-MSGV1   TO     RETURN-MSGV1,
                MESSTAB-MSGV2   TO     RETURN-MSGV2,
                MESSTAB-MSGV3   TO     RETURN-MSGV3,
                MESSTAB-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ENDLOOP.
      W_SUBRC = 4.
   ELSE.                 ">> SUCCESS ��.
      GET PARAMETER ID 'MLN' FIELD W_BELNR.
      GET PARAMETER ID 'MLJ' FIELD W_GJAHR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
      IF W_BELNR IS INITIAL.

*>>> ����..(����� ���� ��....)
         W_SUBRC = 4.
         MESSAGE S648.
         MOVE : 'E'             TO     RETURN-MSGTYP,
                'ZIM'           TO     RETURN-MSGID,
                '494'           TO     RETURN-MSGNR,
                SPACE           TO     RETURN-MSGV1,
                SPACE           TO     RETURN-MSGV2,
                SPACE           TO     RETURN-MSGV3,
                SPACE           TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
      ELSE.
         MESSAGE S260(M8) WITH W_BELNR.
         MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                SY-MSGID   TO     RETURN-MSGID,
                SY-MSGNO   TO     RETURN-MSGNR,
                SY-MSGV1   TO     RETURN-MSGV1,
                SY-MSGV2   TO     RETURN-MSGV2,
                SY-MSGV3   TO     RETURN-MSGV3,
                SY-MSGV4   TO     RETURN-MSGV4.

         CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                   EXPORTING
                         MSGID     = RETURN-MSGID
                         MSGNR     = RETURN-MSGNR
                         MSGV1     = RETURN-MSGV1
                         MSGV2     = RETURN-MSGV2
                         MSGV3     = RETURN-MSGV3
                         MSGV4     = RETURN-MSGV4
                  IMPORTING
                         MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
         APPEND  RETURN.
         W_SUBRC = 0.
      ENDIF.
   ENDIF.
*---------------------<  ���� ���� ���� END  >-------------------------*

*---------------------<  FI ���� ���� START  >-------------------------*
  IF W_SUBRC EQ 0.
*>>> BDC....
      REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
      PERFORM P2000_DYNPRO USING :
          'X' 'SAPMF05A'    '0105',
          ' ' 'RF05A-BELNS' IT_ZSBCOST-ZFACDO,   " ���а��� ��ǥ.
          ' ' 'BKPF-BUKRS'  IT_ZSBCOST-BUKRS,    " Company Code
          ' ' 'RF05A-GJAHS' IT_ZSBCOST-ZFFIYR,   " ȸ�迬��.
          ' ' 'UF05A-STGRD' UF05A-STGRD,         " ���а�����.
          ' ' 'BSIS-BUDAT'  BSIS-BUDAT,          " ��ǥ������.
          ' ' 'BSIS-MONAT'  SPACE,               " ȸ��Ⱓ.
          ' ' 'RF05A-VOIDR' SPACE,               " ��ǥ�������ڵ�.
          ' ' 'BDC_OKCODE'  '=BU'.               " ����.

      SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
      SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.

*>> BDC CALL.
      CALL TRANSACTION 'FB08'  USING       BDCDATA
                               MODE        'A'
                               UPDATE      'S'
                               MESSAGES    INTO   MESSTAB.

      W_SUBRC = SY-SUBRC.

      IF W_SUBRC NE 0.      ">> ERROR �߻���.
         LOOP AT MESSTAB.
            MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                   MESSTAB-MSGID   TO     RETURN-MSGID,
                   MESSTAB-MSGNR   TO     RETURN-MSGNR,
                   MESSTAB-MSGV1   TO     RETURN-MSGV1,
                   MESSTAB-MSGV2   TO     RETURN-MSGV2,
                   MESSTAB-MSGV3   TO     RETURN-MSGV3,
                   MESSTAB-MSGV4   TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                      EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                            MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.
         ENDLOOP.
      ELSE.                 ">> SUCCESS ��.
         GET PARAMETER ID 'BLN' FIELD W_ACDO.
         GET PARAMETER ID 'GJR' FIELD W_FIYR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
         IF IT_ZSBCOST-ZFACDO EQ W_ACDO AND
            IT_ZSBCOST-ZFFIYR EQ W_FIYR.
*>>> ����..(����� ���� ��....)
            W_SUBRC = 4.
            MESSAGE S648.
            MOVE : 'E'             TO     RETURN-MSGTYP,
                   'ZIM'           TO     RETURN-MSGID,
                   '494'           TO     RETURN-MSGNR,
                   SPACE           TO     RETURN-MSGV1,
                   SPACE           TO     RETURN-MSGV2,
                   SPACE           TO     RETURN-MSGV3,
                   SPACE           TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                      EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                           MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.

         ELSE.
            MESSAGE S282(M8) WITH W_ACDO.
            MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                   SY-MSGID   TO     RETURN-MSGID,
                   SY-MSGNO   TO     RETURN-MSGNR,
                   SY-MSGV1   TO     RETURN-MSGV1,
                   SY-MSGV2   TO     RETURN-MSGV2,
                   SY-MSGV3   TO     RETURN-MSGV3,
                   SY-MSGV4   TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                       EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                            MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.

            W_SUBRC = 0.
         ENDIF.
      ENDIF.

  ENDIF.
*<< ���� DB �� DATA UPDATE >>------------------------------------------*
  IF W_SUBRC EQ 0.

     CLEAR : ZTBCOST.
     MOVE-CORRESPONDING IT_ZSBCOST  TO  ZTBCOST.

     MOVE : W_GJAHR             TO   ZTBCOST-ZFCGJAHR ,
            W_BELNR             TO   ZTBCOST-ZFCBELNR ,
            W_FIYR              TO   ZTBCOST-ZFCFIYR ,
            W_ACDO              TO   ZTBCOST-ZFCACDO ,
            SY-UNAME            TO   ZTBCOST-ERNAM  ,
            SY-DATUM            TO   ZTBCOST-CDAT   ,
            SY-UZEIT            TO   ZTBCOST-CTME   .

     UPDATE  ZTBCOST.

     DELETE  FROM  ZTBCOIT WHERE BUKRS  EQ  IT_ZSBCOST-BUKRS
                           AND   WERKS  EQ  IT_ZSBCOST-WERKS
                           AND   MATNR  EQ  IT_ZSBCOST-MATNR
                           AND   ZFSEQ  EQ  IT_ZSBCOST-ZFSEQ.

      IF SY-SUBRC NE 0.
         ROLLBACK WORK.
      ENDIF.

  ENDIF.

*----------------------< ���� DB �ݿ� END >----------------------------*

ENDFORM.                    " P2000_COST_MM_CANCEL

*&---------------------------------------------------------------------*
*&      Form  P2000_COST_FI_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_COST_FI_CANCEL.

*---------------------<  FI ���� ���� START  >-------------------------*
*>>> BDC....
      REFRESH : BDCDATA.
* �ʱ�ȭ�� FIELD
      PERFORM P2000_DYNPRO USING :
          'X' 'SAPLAB01'    '0010',
          ' ' 'RLAB01-ANLN1' IT_ZSBCOST-MATNR,   " ���а��� ��ǥ.
          ' ' 'RLAB01-BUKRS' IT_ZSBCOST-BUKRS,   " Company Code
          ' ' 'RLAB01-GJAHR' IT_ZSBCOST-ZFFIYR,  " ȸ�迬��.
          ' ' 'BDC_OKCODE'  '=WEIT'.               " ����.

* �ʱ�ȭ�� FIELD
      PERFORM P2000_DYNPRO USING :
          'X' 'SAPLAB01'    '0100',
          ' ' 'BDC_OKCODE'  '=STOR'.               " ����.

      PERFORM P2000_DYNPRO USING :
          'X' 'SAPMF05A'    '0105',
          ' ' 'UF05A-STGRD'  UF05A-STGRD,         " ���а��� ��ǥ.
          ' ' 'BDC_OKCODE'  '=CANC'.              " ����.

      SET PARAMETER ID 'BLN' FIELD ''.        " ��ǥ��ȣ.
      SET PARAMETER ID 'GJR' FIELD ''.        " ȸ��⵵.

*>> BDC CALL.
      CALL TRANSACTION 'AB08'  USING       BDCDATA
                               MODE        'A'
                               UPDATE      'S'
                               MESSAGES    INTO   MESSTAB.

      W_SUBRC = SY-SUBRC.

      IF W_SUBRC NE 0.      ">> ERROR �߻���.
         LOOP AT MESSTAB.
            MOVE : MESSTAB-MSGTYP  TO     RETURN-MSGTYP,
                   MESSTAB-MSGID   TO     RETURN-MSGID,
                   MESSTAB-MSGNR   TO     RETURN-MSGNR,
                   MESSTAB-MSGV1   TO     RETURN-MSGV1,
                   MESSTAB-MSGV2   TO     RETURN-MSGV2,
                   MESSTAB-MSGV3   TO     RETURN-MSGV3,
                   MESSTAB-MSGV4   TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                      EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                            MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.
         ENDLOOP.
      ELSE.                 ">> SUCCESS ��.
         GET PARAMETER ID 'BLN' FIELD W_ACDO.
         GET PARAMETER ID 'GJR' FIELD W_FIYR.   " ȸ��⵵.
*>> ��ǥ��ȣ�� ���޵��� ���� ���.
         IF IT_ZSBCOST-ZFACDO EQ W_ACDO AND
            IT_ZSBCOST-ZFFIYR EQ W_FIYR.
*>>> ����..(����� ���� ��....)
            W_SUBRC = 4.
            MESSAGE S648.
            MOVE : 'E'             TO     RETURN-MSGTYP,
                   'ZIM'           TO     RETURN-MSGID,
                   '494'           TO     RETURN-MSGNR,
                   SPACE           TO     RETURN-MSGV1,
                   SPACE           TO     RETURN-MSGV2,
                   SPACE           TO     RETURN-MSGV3,
                   SPACE           TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                      EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                           MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.

         ELSE.
            MESSAGE S282(M8) WITH W_ACDO.
            MOVE : SY-MSGTY   TO     RETURN-MSGTYP,
                   SY-MSGID   TO     RETURN-MSGID,
                   SY-MSGNO   TO     RETURN-MSGNR,
                   SY-MSGV1   TO     RETURN-MSGV1,
                   SY-MSGV2   TO     RETURN-MSGV2,
                   SY-MSGV3   TO     RETURN-MSGV3,
                   SY-MSGV4   TO     RETURN-MSGV4.

            CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                       EXPORTING
                            MSGID     = RETURN-MSGID
                            MSGNR     = RETURN-MSGNR
                            MSGV1     = RETURN-MSGV1
                            MSGV2     = RETURN-MSGV2
                            MSGV3     = RETURN-MSGV3
                            MSGV4     = RETURN-MSGV4
                     IMPORTING
                            MESSAGE_TEXT_OUTPUT = RETURN-MESSTXT.
            APPEND  RETURN.

            W_SUBRC = 0.
         ENDIF.
      ENDIF.

*<< ���� DB �� DATA UPDATE >>------------------------------------------*
  IF W_SUBRC EQ 0.

     CLEAR : ZTBCOST.
     MOVE-CORRESPONDING IT_ZSBCOST  TO  ZTBCOST.

     MOVE : W_GJAHR             TO   ZTBCOST-ZFCGJAHR ,
            W_BELNR             TO   ZTBCOST-ZFCBELNR ,
            W_FIYR              TO   ZTBCOST-ZFCFIYR ,
            W_ACDO              TO   ZTBCOST-ZFCACDO ,
            SY-UNAME            TO   ZTBCOST-ERNAM  ,
            SY-DATUM            TO   ZTBCOST-CDAT   ,
            SY-UZEIT            TO   ZTBCOST-CTME   .

     UPDATE  ZTBCOST.

     DELETE  FROM  ZTBCOIT WHERE BUKRS  EQ  IT_ZSBCOST-BUKRS
                           AND   WERKS  EQ  IT_ZSBCOST-WERKS
                           AND   MATNR  EQ  IT_ZSBCOST-MATNR
                           AND   ZFSEQ  EQ  IT_ZSBCOST-ZFSEQ.

      IF SY-SUBRC NE 0.
         ROLLBACK WORK.
      ENDIF.

  ENDIF.

*----------------------< ���� DB �ݿ� END >----------------------------*

ENDFORM.                    " P2000_COST_FI_CANCEL
*&---------------------------------------------------------------------*
*&      Form  P4000_GET_INIVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P4000_GET_INIVAL.

  MOVE 'Initial Value' TO SPOP-TITEL.
*  MOVE 'X'             TO RADIO_NONE.
  IF BSIS-BUDAT IS INITIAL.
     MOVE SY-DATUM    TO BSIS-BUDAT.
  ENDIF.

  CALL SCREEN 0010 STARTING AT 15 1
                   ENDING   AT 52 9.

ENDFORM.                    " P4000_GET_INIVAL
*&---------------------------------------------------------------------*
*&      Module  P2000_INIT_VALUE_CHECK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE P2000_INIT_VALUE_CHECK INPUT.

  IF OK-CODE NE 'YES' AND OK-CODE NE 'ENTR'.
     EXIT.
  ENDIF.

  IF UF05A-STGRD IS INITIAL.
     PERFORM NO_INPUT(SAPFMMEX) USING 'UF05A' 'STGRD'.
  ENDIF.

  IF BSIS-BUDAT IS INITIAL.
     PERFORM NO_INPUT(SAPFMMEX) USING 'BSIS' 'BUDAT'.
  ENDIF.

ENDMODULE.                 " P2000_INIT_VALUE_CHECK  INPUT
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_STATUS_SCR0010 OUTPUT.

   SET TITLEBAR 'PUPU' WITH SPOP-TITEL.
   SET PF-STATUS 'POPU'.

ENDMODULE.                 " SET_STATUS_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_OK_CODE_SCR0010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE GET_OK_CODE_SCR0010 INPUT.

  IF OK-CODE NE 'YES' AND OK-CODE NE 'ENTR'.
     SET SCREEN 0.
     LEAVE SCREEN.
  ENDIF.

  OK-CODE = 'YES'.
  SET SCREEN 0.   LEAVE SCREEN.

ENDMODULE.                 " GET_OK_CODE_SCR0010  INPUT
*&---------------------------------------------------------------------*
*&      Form  P1000_SET_BUKRS
*&---------------------------------------------------------------------*
FORM P1000_SET_BUKRS.

   CLEAR : ZTIMIMG00, P_BUKRS.
   SELECT SINGLE * FROM ZTIMIMG00.
   IF NOT ZTIMIMG00-ZFBUFIX IS INITIAL.
      MOVE  ZTIMIMG00-ZFBUKRS   TO  P_BUKRS.
   ENDIF.

*>> ȸ���ڵ� SET.
    MOVE: 'I'          TO S_BUKRS-SIGN,
          'EQ'         TO S_BUKRS-OPTION,
          P_BUKRS      TO S_BUKRS-LOW.
    APPEND S_BUKRS.

ENDFORM.                    " P1000_SET_BUKRS
