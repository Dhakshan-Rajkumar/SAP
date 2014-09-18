*&---------------------------------------------------------------------
*& Report  ZRIMCCVTDOC
*&---------------------------------------------------------------------
*&  ���α׷��� : ���� ����/�ΰ���/����� �ϰ�ǥ.
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.10.06
*&---------------------------------------------------------------------
*&   DESC.     :
*&
*&---------------------------------------------------------------------
*& [���泻��]
*&
*&---------------------------------------------------------------------
REPORT  ZRIMCCVTDOC  MESSAGE-ID ZIM
                     LINE-SIZE 195
                     NO STANDARD PAGE HEADING.

TABLES: ZTBKPF,
        ZTBSEG,
        ZTBL,
        ZTIDS,
        ZTIMIMG10,
        LFA1,
        ZTIV,
        ZTCUCLIV,
        T001,
        ZTIMIMG02.

*----------------------------------------------------------------------
*  ����Ʈ�� INTERNAL TABLE
*----------------------------------------------------------------------

DATA : BEGIN OF IT_TAB OCCURS 0,
       BUKRS     LIKE    ZTBKPF-BUKRS,
       BELNR     LIKE    ZTBKPF-BELNR,
       GJAHR     LIKE    ZTBKPF-GJAHR,
       ZFIMDNO   LIKE    ZTBSEG-ZFIMDNO,    " ���Թ�����ȣ.
       ZFACDO    LIKE    ZTBKPF-ZFACDO,      " ȸ����ǥ��ȣ.
       WAERS     LIKE    ZTBKPF-WAERS,
       HWAER     LIKE    ZTBKPF-HWAER,
       ZFREBELN  LIKE    ZTBL-ZFREBELN,      " P/O NO
       ZFSHNO    LIKE    ZTBL-ZFSHNO,        " ��������.
       ZFHBLNO   LIKE    ZTBL-ZFHBLNO,       " B/L NO
       GUBUN     TYPE C,
       ZFCD      LIKE    ZTBSEG-ZFCD,        " �����ڵ�.
       LIFNR     LIKE    ZTBKPF-LIFNR,       " ����ó.
       NAME1     LIKE    LFA1-NAME1,         " �ŷ���.
       BUDAT     LIKE    ZTBKPF-BUDAT,       " ������.
       ZFBDT     LIKE    ZTBKPF-ZFBDT,       " ������.
       ZFRVSX    LIKE    ZTBKPF-ZFRVSX,      " ����ǥ.
       ZFCSTGRP  LIKE    ZTBSEG-ZFCSTGRP,    " ���׷�.
       WRBTR     LIKE    ZTBSEG-WRBTR,
       DMBTR     LIKE    ZTBSEG-DMBTR,
       WMWST     LIKE    ZTBSEG-WMWST,       ">�ΰ���.
       FWBAS     LIKE    ZTBSEG-FWBAS,       " �ΰ�����ǥ��.
       CSTGRP    LIKE    DD07T-DDTEXT,
       BUPLA     LIKE    ZTBKPF-BUPLA,       " �ͼӻ����.
       CPUDT     LIKE    ZTBKPF-CPUDT,       " ��ǥ�Է���.
       CPUTM     LIKE    ZTBKPF-CPUTM,       " ��ǥ�Է½ð�.
       UTME      LIKE    ZTBKPF-UTME,        " ��������ð�.
       ZFCNAME   LIKE    ZTBKPF-ZFCNAME,     " �����.
       ZFIDRNO   LIKE    ZTIDS-ZFIDRNO,
       ZFCUTAMT  LIKE    ZTIDS-ZFCUTAMT,     " ������ ����?
       ZFCUAMTS  LIKE    ZTIDS-ZFCUAMTS,     " �Ѱ�?
       ZFVAAMTS  LIKE    ZTIDS-ZFVAAMTS,     " �Ѻΰ�?
       ZFIDSDT   LIKE    ZTIDS-ZFIDSDT,      " �Ű���.
       ZFCOCD	   LIKE    ZTIDS-ZFCOCD.       " ����¡������.
DATA : END OF IT_TAB.

DATA : W_STCD2   LIKE    LFA1-STCD2,         " ����ڵ�Ϲ�ȣ.
       W_ZFACTNO LIKE    ZTIMIMG02-ZFACTNO.  " ���¹�ȣ.

DATA :  W_ERR_CHK     TYPE C,
        W_LCOUNT      TYPE I,
        W_FIELD_NM    TYPE C,
        W_PAGE        TYPE I,
        W_CHECK_PAGE(1) TYPE C,
        W_LINE        TYPE I,
        W_COUNT       TYPE I,
        W_TABIX       LIKE SY-TABIX.

*----------------------------------------------------------------------
* Selection Screen ?
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

   SELECT-OPTIONS: S_BUKRS   FOR  ZTBKPF-BUKRS NO-EXTENSION
                                               NO INTERVALS,
                   S_DAT     FOR  ZTBKPF-CPUDT NO-EXTENSION NO INTERVALS
                                           OBLIGATORY ,
                   S_TIME    FOR  ZTBKPF-CPUTM,
                   S_CNAME   FOR  ZTBKPF-ZFCNAME NO-EXTENSION
                                                 NO INTERVALS.
                                                 "OBLIGATORY.

 SELECTION-SCREEN END OF BLOCK B1.
 INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

*title Text Write
W_CHECK_PAGE = 'X'.
TOP-OF-PAGE.
 PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

*----------------------------------------------------------------------
* START OF SELECTION ?
*----------------------------------------------------------------------
START-OF-SELECTION.
* ���� ���� ��?
   PERFORM   P2000_AUTHORITY_CHECK     USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* B/L ���̺� SELECT
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
     WHEN 'DISP'.
       IF W_TABIX IS INITIAL.
          MESSAGE S962.
       ELSE.
          IF NOT IT_TAB-BELNR IS INITIAL.
              PERFORM P2000_DISPLAY_COST_DOCUMENT USING  IT_TAB-BUKRS
                                                         IT_TAB-GJAHR
                                                         IT_TAB-BELNR.
          ELSE.
             MESSAGE S962.
          ENDIF.

       ENDIF.
   ENDCASE.
   CLEAR : W_TABIX, IT_TAB.

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------
FORM P3000_TITLE_WRITE.

  SKIP 2.
  WRITE:/80 '���԰���/�ΰ���/����� �ϰ�ǥ'.
  SKIP 2.

*    ULINE AT 169(195).
*     WRITE:/169 SY-VLINE NO-GAP, 170 '����'  CENTERED,
*            174 SY-VLINE, 175 '��  ��'  CENTERED,
*            181 SY-VLINE, 182 '��  ��'  CENTERED,
*            188 SY-VLINE, 189 'Ȯ  ��' CENTERED,
*            195 SY-VLINE.
*     ULINE AT /169(195).
*     WRITE:/169 SY-VLINE NO-GAP, 170 '��'  CENTERED,
*            174 SY-VLINE, 175 ''  CENTERED,
*            181 SY-VLINE, 182 ''  CENTERED,
*            188 SY-VLINE, 189 '' CENTERED,
*            195 SY-VLINE.
*     WRITE:80 '���԰���/�ΰ���/����� �ϰ�ǥ'.
*
*     WRITE:/169 SY-VLINE NO-GAP, 170 '��'  CENTERED,
*            174 SY-VLINE, 175 ''  CENTERED,
*            181 SY-VLINE, 182 ''  CENTERED,
*            188 SY-VLINE, 189 '' CENTERED,
*            195 SY-VLINE.
*     ULINE AT /169(195).
*     WRITE:/169 SY-VLINE NO-GAP, 170 '��'  CENTERED,
*            174 SY-VLINE, 175 ''  CENTERED,
*            181 SY-VLINE, 182 ''  CENTERED,
*            188 SY-VLINE, 189 '' CENTERED,
*            195 SY-VLINE.
*     WRITE:/169 SY-VLINE NO-GAP, 170 '��'  CENTERED,
*            174 SY-VLINE, 175 ''  CENTERED,
*            181 SY-VLINE, 182 ''  CENTERED,
*            188 SY-VLINE, 189 '' CENTERED,
*            195 SY-VLINE.
*     ULINE AT /169(195).
*
** WRITE:/80 '���԰���/�ΰ���/����� �ϰ�ǥ'.
*  SKIP 2.
  WRITE:/ '�����:',S_CNAME-LOW,
         140 '������:',S_DAT-LOW NO-GAP,'.' NO-GAP,
                       S_TIME-LOW,'~',
                       S_DAT-LOW NO-GAP,'.' NO-GAP,
                       S_TIME-HIGH.
  WRITE:/ SY-ULINE.

  WRITE:/(10) 'ȸ���ȣ'    CENTERED,
          (13) '���Ź���'   CENTERED,
          (20) 'B/L NO'     CENTERED,
          (10) '�����ȣ'   CENTERED,
          (08) '¡������'   CENTERED,
          (12) '�Ű���'     CENTERED,
          (12) '������'     CENTERED,
          (17) '��ǥ��'     RIGHT-JUSTIFIED,
          (20) '�ŷ���'     CENTERED,
          (17) '����'       RIGHT-JUSTIFIED,
          (17) '�ΰ���'     RIGHT-JUSTIFIED,
          (17) '���������' RIGHT-JUSTIFIED,
          (9) '�ͼӻ����'  CENTERED.
*  WRITE:/ SY-ULINE.

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
*      MESSAGE S960 WITH SY-UNAME 'B/L Doc transaction'.
*      W_ERR_CHK = 'Y'.   EXIT.
*   ENDIF.

ENDFORM.                    " P2000_AUTHORITY_CHECK

*&---------------------------------------------------------------------
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------
FORM P1000_READ_DATA USING W_ERR_CHK.

  W_ERR_CHK = 'N'.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
            FROM ZTBKPF AS R INNER JOIN ZTBSEG AS I
             ON R~BUKRS = I~BUKRS
            AND R~BELNR = I~BELNR
            AND R~GJAHR = I~GJAHR
         WHERE  R~ZFPOSYN  = 'Y'              " ���⿩��.
           AND  R~BUKRS    IN  S_BUKRS
           AND  R~UDAT     IN  S_DAT          " ������.
           AND  R~ZFCNAME  IN  S_CNAME
           AND  R~UTME     IN  S_TIME
           AND  I~ZFCSTGRP = '006'.
  IF SY-SUBRC NE 0.  W_ERR_CHK = 'Y'. EXIT.  ENDIF.

  SORT IT_TAB BY ZFACDO ZFCNAME CPUDT.

  LOOP AT IT_TAB.
     W_TABIX = SY-TABIX.
     CLEAR ZTIV.
*     SELECT  SINGLE *
*        FROM  ZTIV
*        WHERE ZFIVNO = IT_TAB-ZFIMDNO.
*    CLEAR ZTCUCLIV.
*    SELECT SINGLE *
*        FROM ZTCUCLIV
*        WHERE ZFIVNO = ZTIV-ZFIVNO.
*>> ���Ը���.
     CLEAR ZTIDS.
     SELECT SINGLE *
        FROM ZTIDS
       WHERE ZFIVNO   = IT_TAB-ZFIMDNO.
*         AND ZFCLSEQ = ZTCUCLIV-ZFCLSEQ.
     IF SY-SUBRC EQ 0.
        MOVE: ZTIDS-ZFIDRNO  TO IT_TAB-ZFIDRNO,
              ZTIDS-ZFIDSDT  TO IT_TAB-ZFIDSDT,      " �Ű���.
              ZTIDS-ZFCOCD   TO IT_TAB-ZFCOCD.       " ����¡������.
     ENDIF.
*>> ���� �ڵ�.
     CASE IT_TAB-ZFCD.
        WHEN '001'.  " ����.
          IT_TAB-GUBUN = '1'.
*          MOVE: ZTIDS-ZFCUAMTS TO IT_TAB-ZFCUAMTS.     " �Ѱ�?
          MOVE IT_TAB-WRBTR     TO IT_TAB-ZFCUAMTS.     " �Ѱ�?
        WHEN '002'.  " ���������.
          IT_TAB-GUBUN = '3'.
*          MOVE: ZTIDS-ZFCUTAMT TO IT_TAB-ZFCUTAMT.     " ������ ����?
          MOVE IT_TAB-WRBTR     TO IT_TAB-ZFCUTAMT.     " �Ѱ�?
        WHEN '003'.  " �ΰ���.
          IT_TAB-GUBUN = '2'.
*          MOVE: ZTIDS-ZFVAAMTS TO IT_TAB-ZFVAAMTS.     " �Ѻΰ�?
          MOVE IT_TAB-WMWST     TO IT_TAB-ZFVAAMTS.     " �Ѱ�?
        WHEN OTHERS.
          DELETE IT_TAB INDEX W_TABIX.
          CONTINUE.
     ENDCASE.

*>> B/L DATA MOVE
     CLEAR ZTBL.
     SELECT SINGLE *
         FROM ZTBL
        WHERE ZFBLNO  = ZTIDS-ZFBLNO.
     IF SY-SUBRC EQ 0.
        MOVE: ZTBL-ZFREBELN  TO   IT_TAB-ZFREBELN,      " P/O NO
              ZTBL-ZFHBLNO   TO   IT_TAB-ZFHBLNO,       " B/L NO
              ZTBL-ZFSHNO    TO   IT_TAB-ZFSHNO.        " ������?
     ENDIF.
     CLEAR LFA1.
     SELECT SINGLE *
            FROM  LFA1
            WHERE  LIFNR = IT_TAB-LIFNR.
     IT_TAB-NAME1 = LFA1-NAME1.

*> ����ǥ.
     IF IT_TAB-ZFRVSX EQ 'X'.
        IT_TAB-DMBTR    = IT_TAB-DMBTR    * -1.
        IT_TAB-WRBTR    = IT_TAB-WRBTR    * -1.
        IT_TAB-ZFCUAMTS = IT_TAB-ZFCUAMTS * -1.
        IT_TAB-ZFCUTAMT = IT_TAB-ZFCUTAMT * -1.
        IT_TAB-ZFVAAMTS = IT_TAB-ZFVAAMTS * -1.
        IT_TAB-WMWST    = IT_TAB-WMWST    * -1.
        IT_TAB-FWBAS    = IT_TAB-FWBAS    * -1.
     ENDIF.

     MODIFY IT_TAB INDEX W_TABIX.

  ENDLOOP.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE .

   SET TITLEBAR  'ZIMR82'.
   SET PF-STATUS 'ZIMR82'.

   SORT IT_TAB BY  ZFCNAME  UTME GUBUN.
   LOOP AT IT_TAB.
        ON CHANGE OF IT_TAB-ZFIMDNO .
            WRITE:/ SY-ULINE.
            PERFORM P3000_TOP_LINE_WRITE.
        ENDON.
        PERFORM   P3000_LINE_WRITE.
        AT LAST.
           PERFORM P3000_LAST_WRITE.
        ENDAT.
   ENDLOOP.

   CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------
*&      Form  P2000_INIT
*&---------------------------------------------------------------------
FORM P2000_INIT.

  SET TITLEBAR  'ZIMR82'.
  MOVE :    'I'          TO  S_DAT-SIGN,
            'EQ'         TO  S_DAT-OPTION,
            SY-DATUM     TO  S_DAT-LOW.

  APPEND S_DAT.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------
*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
*
FORM P3000_LINE_WRITE.
   DATA: W_TEXT(13).

   IF IT_TAB-ZFSHNO IS INITIAL.
       MOVE IT_TAB-ZFREBELN TO W_TEXT.
   ELSE.
       CONCATENATE IT_TAB-ZFREBELN '-' IT_TAB-ZFSHNO INTO W_TEXT.
   ENDIF.

   WRITE:/(10) IT_TAB-ZFACDO CENTERED,"ȸ����ǥ��ȣ.
         (13) W_TEXT         CENTERED, " P/O NO
         (20) IT_TAB-ZFHBLNO CENTERED, " B/L NO
         (10) IT_TAB-ZFIDRNO CENTERED,
         (08) IT_TAB-ZFCOCD CENTERED, " ����¡������.
         (12) IT_TAB-ZFIDSDT CENTERED," �Ű���.
         (12) IT_TAB-ZFBDT CENTERED,  " ������.
         (17) IT_TAB-FWBAS CURRENCY IT_TAB-WAERS,"��ǥ��.
         (20) IT_TAB-NAME1 CENTERED,         " �ŷ���.
         (17) IT_TAB-ZFCUAMTS CURRENCY IT_TAB-WAERS ,"��?
         (17) IT_TAB-ZFVAAMTS CURRENCY IT_TAB-WAERS,"�ΰ�?
         (17) IT_TAB-ZFCUTAMT CURRENCY IT_TAB-WAERS, "����?
         (9) IT_TAB-BUPLA CENTERED.  " �ͼӻ����.
   HIDE: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------
*
*&      Form  P3000_TOP_LINE_WRITE
*&---------------------------------------------------------------------
*
FORM P3000_TOP_LINE_WRITE.



ENDFORM.                    " P3000_TOP_LINE_WRITE
*&---------------------------------------------------------------------
*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------
*
FORM P3000_LAST_WRITE.

   SUM.
   WRITE:/ SY-ULINE.
   WRITE:/(10) '',
         (13) '',
         (20) '',
         (10) '',
         (08) '',
         (12) '',
         (12) '��',
         (17) IT_TAB-FWBAS CURRENCY 'KRW',"��ǥ��.
         (20) '',
         (17) IT_TAB-ZFCUAMTS CURRENCY 'KRW' ,"��?
         (17) IT_TAB-ZFVAAMTS CURRENCY 'KRW',"�ΰ�?
         (17) IT_TAB-ZFCUTAMT  CURRENCY 'KRW', "����?
         (9) ''.
   WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_DISPLAY_COST_DOCUMENT
*&---------------------------------------------------------------------*
FORM P2000_DISPLAY_COST_DOCUMENT USING    P_BUKRS
                                          P_GJAHR
                                          P_BELNR.

 SET  PARAMETER ID  'BUK'       FIELD   P_BUKRS.
 SET  PARAMETER ID  'GJR'       FIELD   P_GJAHR.
 SET  PARAMETER ID  'ZPBENR'    FIELD   P_BELNR.
 CALL TRANSACTION 'ZIMY3'.

ENDFORM.                    " P2000_DISPLAY_COST_DOCUMENT
