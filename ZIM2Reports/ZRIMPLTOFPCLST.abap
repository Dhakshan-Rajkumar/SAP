*&---------------------------------------------------------------------
*& Report  ZRIMPLTOFPCLST
*&---------------------------------------------------------------------
*&  ���α׷��� : ����κ� �ŷ������Ž���ǥ
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.10.17
*&---------------------------------------------------------------------
*&   DESC.     : �÷�Ʈ�� �ŷ��� ���Ž����� ��ȸ �Ѵ�.
*&
*&
*&---------------------------------------------------------------------
*& [���泻��]
*&
*&---------------------------------------------------------------------
REPORT  ZRIMPLTOFPCLST  MESSAGE-ID ZIM
                     LINE-SIZE 255
                     NO STANDARD PAGE HEADING.
TABLES: ZTIVHST, ZTIVHSTIT,ZTIVIT,ZTREQHD,EKKO,EKBE,EKPO,LFA1,T156,
        T001W.
*----------------------------------------------------------------------
*  ����Ʈ�� INTERNAL TABLE
*----------------------------------------------------------------------
*>> ���.
DATA : BEGIN OF IT_ZTIVHST OCCURS 0,
       WERKS     LIKE  ZTIVHSTIT-WERKS,
       ZFIVNO    LIKE  ZTIVHST-ZFIVNO,	 " �����û/�԰��û ������ȣ.
       ZFIVHST   LIKE  ZTIVHST-ZFIVHST,	 " �԰����.
       ZFGRST	   LIKE  ZTIVHST-ZFGRST,    " Good Receipt ����.
       ZFCIVHST  LIKE  ZTIVHST-ZFCIVHST,  " Verify ����.
       BLDAT	   LIKE  ZTIVHST-BLDAT,     " ��ǥ�� ������.
       SHKZG	   LIKE  ZTIVHST-SHKZG,     " ����/�뺯 ������.
       MBLNR     LIKE  ZTIVHST-MBLNR,     " ���繮����ȣ.
       MJAHR     LIKE  ZTIVHST-MJAHR,     " ���繮������.
       BWART	   LIKE  ZTIVHST-BWART,     " �̵����� (������).
       ZFREQNO   LIKE  ZTREQHD-ZFREQNO,   " �����Ƿڰ�����ȣ.
       EBELN	   LIKE  ZTIVHSTIT-EBELN,   " ���Ź�����ȣ
       ZFIVDNO  LIKE   ZTIVHSTIT-ZFIVDNO, " ���Ź�����ȣ
       EBELP	   LIKE  ZTIVHSTIT-EBELP,   " ���Ź��� ǰ���ȣ
       MATNR	   LIKE  ZTIVHSTIT-MATNR,   " �����ȣ.
       LLIEF     LIKE  EKKO-LLIEF,        " ����.
       NAME1     LIKE  LFA1-NAME1,        " NAME1.
       EKORG	   LIKE  EKKO-EKORG,        " ��������.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       BAMNG1    LIKE  EKBE-BAMNG,        " ����.
       BAMNG2    LIKE  EKBE-BAMNG,        " ����.
       BAMNG3    LIKE  EKBE-BAMNG,        " ����.
       BAMNG4    LIKE  EKBE-BAMNG,        " ����.
       BAMNG5    LIKE  EKBE-BAMNG,        " ����.
       BAMNG6    LIKE  EKBE-BAMNG,        " ����.
       BAMNG7    LIKE  EKBE-BAMNG,        " ����.
       BAMNG8    LIKE  EKBE-BAMNG,        " ����.
       BAMNG9    LIKE  EKBE-BAMNG,        " ����.
       BAMNG10   LIKE  EKBE-BAMNG,        " ����.
       BAMNG11   LIKE  EKBE-BAMNG,        " ����.
       BAMNG12   LIKE  EKBE-BAMNG,        " ����.
       DMBTR     LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR1    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR2    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR3    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR4    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR5    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR6    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR7    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR8    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR9    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR10   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR11   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR12   LIKE  EKBE-DMBTR,        " ������ȭ.
       TXZ01     LIKE  EKPO-TXZ01,        " ǰ��.
       MEINS     LIKE  EKPO-MEINS.        " ��������.
DATA : END OF IT_ZTIVHST.
*>> PLANT �� �ŷ���.
DATA : BEGIN OF IT_TAB OCCURS 0,
       WERKS     LIKE  ZTIVHSTIT-WERKS,
       LLIEF     LIKE  EKKO-LLIEF,        " ����.
       NAME1     LIKE  LFA1-NAME1,
       MATNR	   LIKE  ZTIVHSTIT-MATNR,   " �����ȣ.
       MEINS     LIKE  EKPO-MEINS,        " ��������.
       TXZ01     LIKE  EKPO-TXZ01,        " ǰ��.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       BAMNG1    LIKE  EKBE-BAMNG,        " ����.
       BAMNG2    LIKE  EKBE-BAMNG,        " ����.
       BAMNG3    LIKE  EKBE-BAMNG,        " ����.
       BAMNG4    LIKE  EKBE-BAMNG,        " ����.
       BAMNG5    LIKE  EKBE-BAMNG,        " ����.
       BAMNG6    LIKE  EKBE-BAMNG,        " ����.
       BAMNG7    LIKE  EKBE-BAMNG,        " ����.
       BAMNG8    LIKE  EKBE-BAMNG,        " ����.
       BAMNG9    LIKE  EKBE-BAMNG,        " ����.
       BAMNG10   LIKE  EKBE-BAMNG,        " ����.
       BAMNG11   LIKE  EKBE-BAMNG,        " ����.
       BAMNG12   LIKE  EKBE-BAMNG,        " ����.
       DMBTR1    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR2    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR3    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR4    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR5    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR6    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR7    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR8    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR9    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR10   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR11   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR12   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR     LIKE  EKBE-DMBTR.        " ������ȭ.
DATA : END OF IT_TAB.

*>> �÷�Ʈ.
DATA : BEGIN OF IT_TAB2 OCCURS 0,
       WERKS     LIKE  ZTIVHSTIT-WERKS,
       MEINS     LIKE  EKPO-MEINS,        " ��������.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       BAMNG1    LIKE  EKBE-BAMNG,        " ����.
       BAMNG2    LIKE  EKBE-BAMNG,        " ����.
       BAMNG3    LIKE  EKBE-BAMNG,        " ����.
       BAMNG4    LIKE  EKBE-BAMNG,        " ����.
       BAMNG5    LIKE  EKBE-BAMNG,        " ����.
       BAMNG6    LIKE  EKBE-BAMNG,        " ����.
       BAMNG7    LIKE  EKBE-BAMNG,        " ����.
       BAMNG8    LIKE  EKBE-BAMNG,        " ����.
       BAMNG9    LIKE  EKBE-BAMNG,        " ����.
       BAMNG10   LIKE  EKBE-BAMNG,        " ����.
       BAMNG11   LIKE  EKBE-BAMNG,        " ����.
       BAMNG12   LIKE  EKBE-BAMNG,        " ����.
       DMBTR1    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR2    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR3    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR4    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR5    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR6    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR7    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR8    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR9    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR10   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR11   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR12   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR     LIKE  EKBE-DMBTR.        " ������ȭ.
DATA : END OF IT_TAB2.
*>> ����.
DATA : BEGIN OF IT_TAB3 OCCURS 0,
       MEINS     LIKE  EKPO-MEINS,        " ��������.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       BAMNG1    LIKE  EKBE-BAMNG,        " ����.
       BAMNG2    LIKE  EKBE-BAMNG,        " ����.
       BAMNG3    LIKE  EKBE-BAMNG,        " ����.
       BAMNG4    LIKE  EKBE-BAMNG,        " ����.
       BAMNG5    LIKE  EKBE-BAMNG,        " ����.
       BAMNG6    LIKE  EKBE-BAMNG,        " ����.
       BAMNG7    LIKE  EKBE-BAMNG,        " ����.
       BAMNG8    LIKE  EKBE-BAMNG,        " ����.
       BAMNG9    LIKE  EKBE-BAMNG,        " ����.
       BAMNG10   LIKE  EKBE-BAMNG,        " ����.
       BAMNG11   LIKE  EKBE-BAMNG,        " ����.
       BAMNG12   LIKE  EKBE-BAMNG,        " ����.
       DMBTR1    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR2    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR3    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR4    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR5    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR6    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR7    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR8    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR9    LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR10   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR11   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR12   LIKE  EKBE-DMBTR,        " ������ȭ.
       DMBTR     LIKE  EKBE-DMBTR.        " ������ȭ.
DATA : END OF IT_TAB3.

DATA :  W_ERR_CHK     TYPE C,
        W_FIELD_NM    TYPE C,
        W_GUBUN(02)   TYPE C,
        W_TEXT(10),
        W_TEXT2(10),
        W_TO(04),
        W_FROM(04),
        W_RATE        TYPE P DECIMALS 4,
        W_LINE        TYPE I,
        W_COUNT       TYPE I,
        W_CHEK,
        W_TABIX       LIKE SY-TABIX,
        W_PAGE_CHECK(1),
        W_LIST_INDEX  LIKE SY-TABIX.
*>> LOCALDATA.�ݾ��÷�Ʈ ��Ż.
 DATA: SDMBTR1  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR2  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR3  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR4  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR5  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR6  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR7  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR8  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR9  LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR10 LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR11 LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR12 LIKE  EKBE-DMBTR,        " ������ȭ.
       SDMBTR   LIKE  EKBE-DMBTR.        " ������ȭ.

RANGES: R_BLDAT FOR ZTIVHST-BLDAT OCCURS 05.
INCLUDE   ZRIMSORTCOM.    " REPORT Sort
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*----------------------------------------------------------------------
* Selection Screen ?
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_BUKRS   FOR  EKKO-BUKRS NO-EXTENSION NO INTERVALS,
                   S_WERKS	  FOR  ZTIVHSTIT-WERKS,
                   S_EKGRP   FOR EKKO-EKGRP,        " ���ű׷�..
                   S_EKORG	  FOR  EKKO-EKORG.       " ��������.
 SELECTION-SCREEN END OF BLOCK B1.
 INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

*title Text Write
 W_PAGE_CHECK = 'N'.
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
   PERFORM   P1000_READ_DATA    USING  W_ERR_CHK.
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
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFIDRNO'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
*      WHEN 'REFR'.
*          PERFORM P1000_READ_DATA USING W_ERR_CHK.
*          PERFORM RESET_LIST.
*      WHEN 'DISP'.
*          IF W_TABIX IS INITIAL.
*            MESSAGE S962.    EXIT.
*          ENDIF.
*           PERFORM P2000_PO_DOC_DISPLAY(SAPMZIM01)
*                                     USING IT_TAB-ZFREBELN ''.
*      WHEN 'DISP1'.
*        IF W_TABIX IS INITIAL.
*           MESSAGE S962.    EXIT.
*        ENDIF.
*        PERFORM P2000_DISP_ZTIDS USING IT_TAB-ZFIDRNO.
*      WHEN 'DOWN'.          " FILE DOWNLOAD....
*          PERFORM P3000_TO_PC_DOWNLOAD.
  ENDCASE.
  CLEAR: IT_TAB, W_TABIX.

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------
FORM P3000_TITLE_WRITE.

  SKIP 1.
  IF W_PAGE_CHECK = 'N'.

      WRITE:/105'[P l a n t  ��     ��  ��  ��  ��   ��   ǥ ]'
      COLOR COL_HEADING INTENSIFIED OFF.
      W_PAGE_CHECK = 'Y'.
  ENDIF.

  CLEAR T001W.
  SELECT SINGLE *
         FROM T001W
        WHERE WERKS = IT_TAB-WERKS.

  WRITE:/ '�ݾ�: õ��',
        /'Plant:',IT_TAB-WERKS,T001W-NAME1, 240 'Date:',SY-DATUM.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-ULINE.
  WRITE : / SY-VLINE NO-GAP,(10) '�ŷ����ڵ�'       NO-GAP CENTERED,
            SY-VLINE NO-GAP,(26) '�ŷ�����'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) ''           NO-GAP CENTERED,
            (15) ''           NO-GAP CENTERED,
            (15) ''           NO-GAP CENTERED,
            (15) ''           NO-GAP CENTERED,
            '��        ��          ��            ��' ,
            '(     ��     ��    /     ��     ��     )',
            255 SY-VLINE.
  WRITE:  SY-ULINE.
  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.

  WRITE : / SY-VLINE NO-GAP,(10) '�����ڵ�'       NO-GAP CENTERED,
            SY-VLINE NO-GAP,(26) 'ǰ     ��'   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '1��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '2��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '3��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '4��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '5��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '6��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '7��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '8��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '9��'           NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '10��'          NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '11��'          NO-GAP CENTERED,
            SY-VLINE NO-GAP,(15) '12��'          NO-GAP CENTERED,
            SY-VLINE NO-GAP,(23) '���� ��'       NO-GAP CENTERED,
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
*>> ���س⵵.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTIVHST
            FROM ZTIVHST AS H INNER JOIN ZTIVHSTIT AS I
             ON H~ZFIVNO  = I~ZFIVNO
            AND H~ZFIVHST = I~ZFIVHST
         WHERE  I~ZFGRST  = 'Y'
           AND  I~WERKS   IN S_WERKS.          " ������.
  PERFORM P1000_CURRENCT_BLDAT.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE .

DATA : L_WERKS LIKE  T001W-WERKS,
       L_MEINS LIKE  EKPO-MEINS.


   SORT IT_TAB BY WERKS  LLIEF MEINS.
   SET TITLEBAR  'ZIMR33'.
   SET PF-STATUS 'ZIMR33'.
   CLEAR W_COUNT.

   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      IF W_TABIX EQ 1.
         L_WERKS = IT_TAB-WERKS.
         L_MEINS = IT_TAB-MEINS.
      ENDIF.

      IF L_WERKS NE IT_TAB-WERKS.
          W_CHEK = 'N'.
          LOOP AT IT_TAB2 WHERE WERKS = L_WERKS.
               PERFORM P3000_LINE_WRITE2.
          ENDLOOP.
          PERFORM P3000_TOTAL_LINE_WRITE2.
          WRITE:/ SY-ULINE.
          NEW-PAGE.
      ENDIF.
      PERFORM P3000_LINE_WRITE.

      L_WERKS = IT_TAB-WERKS.
      L_MEINS = IT_TAB-MEINS.
      AT LAST.
         W_CHEK = 'N'.
         LOOP AT IT_TAB2 WHERE WERKS = L_WERKS.
               PERFORM P3000_LINE_WRITE2.
         ENDLOOP.
         PERFORM P3000_TOTAL_LINE_WRITE2.
         WRITE:/ SY-ULINE.
      ENDAT.
   ENDLOOP.

*>> ����.
   WRITE:/ SY-ULINE.
   LOOP AT IT_TAB3.
        PERFORM P3000_LINE_WRITE3.
    AT LAST.
       PERFORM P3000_TOTAL_LINE_WRITE3.
       WRITE:/ SY-ULINE.
    ENDAT.
   ENDLOOP.
   CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------
*&      Form  P2000_INIT
*&---------------------------------------------------------------------
FORM P2000_INIT.

  SET TITLEBAR  'ZIMR33'.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,(10)IT_TAB-LLIEF    NO-GAP,
            SY-VLINE NO-GAP,(26)IT_TAB-NAME1   NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG1 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG2 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG3 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG4 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG5 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG6 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG7 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG8 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG9 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG10 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG11 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-BAMNG12 UNIT IT_TAB-MEINS NO-GAP,
            SY-VLINE NO-GAP,(03) IT_TAB-MEINS,
                           (19)IT_TAB-BAMNG   UNIT IT_TAB-MEINS  NO-GAP,
            SY-VLINE.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE : / SY-VLINE NO-GAP,(10) IT_TAB-MATNR   NO-GAP,
            SY-VLINE NO-GAP,(26) IT_TAB-TXZ01 NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR1 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR2 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR3 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR4 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR5 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR6 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR7 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR8 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR9 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR10 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR11 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(15)IT_TAB-DMBTR12 CURRENCY 'KRW' NO-GAP,
            SY-VLINE NO-GAP,(23)IT_TAB-DMBTR   CURRENCY 'KRW' NO-GAP,
            SY-VLINE.
 WRITE : / SY-ULINE.

ENDFORM.
*&---------------------------------------------------------------------
*&      Form  RESET_LIST
*&---------------------------------------------------------------------
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.
  PERFORM   P3000_TITLE_WRITE.     " �ش� ���...
  PERFORM   P3000_DATA_WRITE.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------
*&      Form  P1000_CURRENCT_BLDAT
*&---------------------------------------------------------------------
FORM P1000_CURRENCT_BLDAT.

  LOOP AT IT_ZTIVHST.
     W_TABIX = SY-TABIX.
*>> GET ZFREQNO.
     CLEAR ZTIVIT.
     SELECT   SINGLE *
        FROM  ZTIVIT
        WHERE ZFIVNO  = IT_ZTIVHST-ZFIVNO
          AND ZFIVDNO = IT_ZTIVHST-ZFIVDNO.
*>> �����Ƿ� Ÿ�� PU.LO ����.
     CLEAR ZTREQHD.
     SELECT   SINGLE *
        FROM  ZTREQHD
        WHERE ZFREQNO = ZTIVIT-ZFREQNO.
     MOVE ZTREQHD-LLIEF TO  IT_ZTIVHST-LLIEF.
     IF SY-SUBRC NE 0.
         DELETE IT_ZTIVHST INDEX W_TABIX.
         CONTINUE.
     ENDIF.
     IF ZTREQHD-ZFREQTY EQ 'PU' OR ZTREQHD-ZFREQTY EQ 'LO'.
        DELETE IT_ZTIVHST INDEX W_TABIX.
        CONTINUE.
     ENDIF.

*>> ����,�������� üũ.
     CLEAR EKKO.
     SELECT   SINGLE *
        FROM  EKKO
        WHERE EBELN  = IT_ZTIVHST-EBELN
          AND BUKRS IN S_BUKRS
          AND EKORG IN  S_EKORG
          AND EKGRP IN  S_EKGRP.
     IF SY-SUBRC NE 0.
        DELETE IT_ZTIVHST INDEX W_TABIX.
        CONTINUE.
     ENDIF.
*>> ����.������ȭ�ݾ�.
     CLEAR EKBE.
     SELECT SINGLE *
       FROM EKBE
      WHERE EBELN  = IT_ZTIVHST-EBELN
        AND EBELP  = IT_ZTIVHST-EBELP
        AND MATNR  = IT_ZTIVHST-MATNR    " �����ȣ.
        AND BELNR  = IT_ZTIVHST-MBLNR    " ���繮����ȣ.
        AND GJAHR  = IT_ZTIVHST-MJAHR    " ���繮������.
        AND BWART  = IT_ZTIVHST-BWART    " �̵�����.
        AND BEWTP  = 'E'.                " �̷�����.
     IF SY-SUBRC NE 0.
        DELETE IT_ZTIVHST INDEX W_TABIX.
        CONTINUE.
     ENDIF.
*>> ����.
     CLEAR EKPO.
     SELECT  SINGLE *
        FROM EKPO
       WHERE EBELN =  IT_ZTIVHST-EBELN
         AND EBELP  =  IT_ZTIVHST-EBELP
         AND MATNR  =  IT_ZTIVHST-MATNR.    " �����ȣ.

     CLEAR T156.
     SELECT SINGLE *
       FROM T156
      WHERE BWART = IT_ZTIVHST-BWART.

     IT_ZTIVHST-DMBTR =  EKBE-DMBTR / 1000.
     IT_ZTIVHST-BAMNG =  EKBE-BAMNG.
     IF T156-SHKZG = 'H'.
        IT_ZTIVHST-DMBTR    =  ( EKBE-DMBTR  ) * -1.
     ENDIF.
     W_GUBUN = IT_ZTIVHST-BLDAT+4(2).
     CASE W_GUBUN.
         WHEN '01'.
           IT_ZTIVHST-DMBTR1  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG1 =   IT_ZTIVHST-BAMNG.
         WHEN '02'.
           IT_ZTIVHST-DMBTR2  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG2 =   IT_ZTIVHST-BAMNG.
         WHEN '03'.
           IT_ZTIVHST-DMBTR3  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG3 =   IT_ZTIVHST-BAMNG.
         WHEN '04'.
           IT_ZTIVHST-DMBTR4  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG4 =   IT_ZTIVHST-BAMNG.
         WHEN '05'.
           IT_ZTIVHST-DMBTR5  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG5 =   IT_ZTIVHST-BAMNG.
         WHEN '06'.
           IT_ZTIVHST-DMBTR6  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG6 =   IT_ZTIVHST-BAMNG.
         WHEN '07'.
           IT_ZTIVHST-DMBTR7  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG7 =   IT_ZTIVHST-BAMNG.
         WHEN '08'.
           IT_ZTIVHST-DMBTR8  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG8 =   IT_ZTIVHST-BAMNG.
         WHEN '09'.
           IT_ZTIVHST-DMBTR9  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG9 =   IT_ZTIVHST-BAMNG.
         WHEN '10'.
           IT_ZTIVHST-DMBTR10  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG10 =   IT_ZTIVHST-BAMNG.
         WHEN '11'.
           IT_ZTIVHST-DMBTR11  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG11 =   IT_ZTIVHST-BAMNG.
         WHEN '12'.
           IT_ZTIVHST-DMBTR12  =  IT_ZTIVHST-DMBTR.
           IT_ZTIVHST-BAMNG12 =   IT_ZTIVHST-BAMNG.
         WHEN OTHERS.
     ENDCASE.

     SELECT SINGLE *
            FROM LFA1
           WHERE LIFNR  = ZTREQHD-LIFNR.

     MOVE: ZTREQHD-LIFNR  TO IT_ZTIVHST-LLIEF,
           LFA1-NAME1     TO IT_ZTIVHST-NAME1,
           EKPO-MEINS     TO IT_ZTIVHST-MEINS,
           EKPO-TXZ01     TO IT_ZTIVHST-TXZ01.

     MODIFY IT_ZTIVHST INDEX W_TABIX.
     MOVE-CORRESPONDING IT_ZTIVHST TO IT_TAB.
     COLLECT IT_TAB.
     MOVE-CORRESPONDING IT_ZTIVHST TO IT_TAB2.
     COLLECT IT_TAB2.
     MOVE-CORRESPONDING IT_ZTIVHST TO IT_TAB3.
     COLLECT IT_TAB3.

  ENDLOOP.
  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
      W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_CURRENCT_BLDAT
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE2
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE2.

  IF W_CHEK EQ 'N'.
     MOVE 'Plant��:' TO  W_TEXT.
     MOVE '����' TO  W_TEXT2.
  ENDIF.
  FORMAT RESET.
  FORMAT COLOR COL_GROUP INTENSIFIED OFF.
  WRITE:/ SY-VLINE NO-GAP,(10) W_TEXT NO-GAP,
                          (27) W_TEXT2   NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG1 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG2 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG3 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG4 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG5 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG6 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG7 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG8 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG9 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG10 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG11 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB2-BAMNG12 UNIT IT_TAB2-MEINS NO-GAP,
          SY-VLINE NO-GAP,(03) IT_TAB2-MEINS,
                          (19)IT_TAB2-BAMNG UNIT IT_TAB2-MEINS  NO-GAP,
          SY-VLINE.
          CLEAR: W_TEXT,W_CHEK,W_TEXT2.

          ADD:IT_TAB2-DMBTR1  TO SDMBTR1,
              IT_TAB2-DMBTR2  TO SDMBTR2,
              IT_TAB2-DMBTR3  TO SDMBTR3,
              IT_TAB2-DMBTR4  TO SDMBTR4,
              IT_TAB2-DMBTR5  TO SDMBTR5,
              IT_TAB2-DMBTR6  TO SDMBTR6,
              IT_TAB2-DMBTR7  TO SDMBTR7,
              IT_TAB2-DMBTR8  TO SDMBTR8,
              IT_TAB2-DMBTR9  TO SDMBTR9,
              IT_TAB2-DMBTR10 TO SDMBTR10,
              IT_TAB2-DMBTR11 TO SDMBTR11,
              IT_TAB2-DMBTR12 TO SDMBTR12,
              IT_TAB2-DMBTR   TO SDMBTR.



ENDFORM.                    " P3000_LINE_WRITE2
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE3
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE3.

  IF SY-TABIX EQ 1.
       MOVE '�����Ѱ�:' TO  W_TEXT.
  ENDIF.
  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
  WRITE:/ SY-VLINE NO-GAP,(10) W_TEXT NO-GAP,
                          (27)''   NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG1 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG2 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG3 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG4 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG5 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG6 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG7 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG8 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG9 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG10 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG11 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-BAMNG12 UNIT IT_TAB3-MEINS NO-GAP,
          SY-VLINE NO-GAP,(03) IT_TAB3-MEINS,
                          (19)IT_TAB3-BAMNG UNIT IT_TAB3-MEINS  NO-GAP,
          SY-VLINE.
  CLEAR W_TEXT.
*  FORMAT RESET.
*  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
*  WRITE:/ SY-VLINE NO-GAP,(10)''   NO-GAP,
*                          (27)'' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR1 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR2 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR3 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR4 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR5 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR6 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR7 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR8 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR9 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR10 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR11 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR12 CURRENCY 'KRW' NO-GAP,
*          SY-VLINE NO-GAP,(23)IT_TAB3-DMBTR   CURRENCY 'KRW' NO-GAP,
*          SY-VLINE.
 ENDFORM.                    " P3000_LINE_WRITE3
*&---------------------------------------------------------------------*
*&      Form  P3000_TOTAL_LINE_WRITE2
*&---------------------------------------------------------------------*
FORM P3000_TOTAL_LINE_WRITE2.

  FORMAT RESET.
  FORMAT COLOR COL_GROUP INTENSIFIED ON.

  WRITE:/ SY-VLINE NO-GAP,(10)''   NO-GAP,
                          (27)'�ݾ�' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR1 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR2 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR3 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR4 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR5 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR6 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR7 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR8 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR9 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR10 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR11 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15) SDMBTR12 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(23) SDMBTR   CURRENCY 'KRW' NO-GAP,
          SY-VLINE.
    CLEAR :SDMBTR1,SDMBTR2,SDMBTR3,SDMBTR4,SDMBTR5,SDMBTR6,SDMBTR7,
           SDMBTR8,SDMBTR9,SDMBTR10,SDMBTR11,SDMBTR12,SDMBTR.


ENDFORM.                    " P3000_TOTAL_LINE_WRITE2
*&---------------------------------------------------------------------*
*&      Form  P3000_TOTAL_LINE_WRITE3
*&---------------------------------------------------------------------*
FORM P3000_TOTAL_LINE_WRITE3.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  SUM.
  WRITE:/ SY-VLINE NO-GAP,(10)'�ݾ� �Ѱ�:'   NO-GAP,
                          (27)'' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR1 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR2 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR3 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR4 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR5 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR6 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR7 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR8 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR9 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR10 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR11 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(15)IT_TAB3-DMBTR12 CURRENCY 'KRW' NO-GAP,
          SY-VLINE NO-GAP,(23)IT_TAB3-DMBTR   CURRENCY 'KRW' NO-GAP,
          SY-VLINE.


ENDFORM.                    " P3000_TOTAL_LINE_WRITE3
