*&---------------------------------------------------------------------*
*& Report  ZRIMIMPREQ                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���ԽŰ�                                            *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.10.30                                            *
*$     ����ȸ��: (��)ǳ��                                              *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMIMPREQ   MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* ���ԽŰ� ������� INTERNAL TABLE
*-----------------------------------------------------------------------
TABLES: ZTIDR,ZTIDRHS,ZTIDRHSD,ZTBL,
        ZTIDRHSL,T005T.


DATA:  W_ERR_CHK(1) TYPE C VALUE 'N',
       W_PAGE       TYPE I,
       W_LINE       TYPE I,
       W_CONO       TYPE I,
       W_FONO       TYPE I,
       W_CNNO       TYPE I,
       W_TCONO      TYPE I,
       W_TFONO      TYPE I,
       W_TCNNO      TYPE I,
       W_NEED_LINE  TYPE I,
       W_DOM_TEX1   LIKE DD07T-DDTEXT,
       W_ZFPKCNT(8) TYPE I,
       W_DOM_TEX2   LIKE DD07T-DDTEXT.


DATA:   BEGIN OF IT_IDSHS OCCURS 0.   ">> �� ����.
        INCLUDE STRUCTURE   ZTIDRHS.
DATA:   END   OF IT_IDSHS.

DATA:   BEGIN OF IT_IDSHSD OCCURS 0.   ">> �� ����.
        INCLUDE STRUCTURE   ZTIDRHSD.
DATA:   END   OF IT_IDSHSD.

DATA:   BEGIN OF IT_IDSHSL OCCURS 0.   ">> ��ǳ���.
        INCLUDE STRUCTURE   ZTIDRHSL.
DATA:   END   OF IT_IDSHSL.


*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
         PARAMETERS: P_BLNO  LIKE  ZTIDR-ZFBLNO,
                     P_CLSEQ LIKE  ZTIDR-ZFCLSEQ.

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
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.
* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE       USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET  TITLEBAR 'IMPREQ'.          " TITLE BAR
*  W_HT  = 11.
*  W_HB  = 17.
*  W_IB1 = 22.
*  W_IB2 = 22.
*  W_BT  = 4.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  IF W_PAGE EQ 1.
     WRITE : /45  '��  ��  ��  �� (�Ű�����) '.
     WRITE : / 'File No :',ZTIDR-ZFREBELN,100 'Page: ', W_PAGE.
  ELSE.
     SKIP 1.
     WRITE:/100 'Page: ', W_PAGE.
  ENDIF.
  WRITE : / SY-ULINE.

  WRITE : / SY-VLINE NO-GAP,'�Ű��ȣ',
         40 SY-VLINE NO-GAP,'�Ű���',
         60 SY-VLINE NO-GAP,'����.��',
         80 SY-VLINE NO-GAP,'������',
        100 SY-VLINE NO-GAP,'*ó���Ⱓ:3��',
        120 SY-VLINE NO-GAP.
  WRITE : / SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFIDRNO,
         40 SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFIDSDT,
         60 SY-VLINE,(4)SPACE,
         ZTIDR-ZFINRC NO-GAP,'-' NO-GAP,ZTIDR-ZFINRCD,
         80 SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFENDT,
        100 SY-VLINE NO-GAP,
        120 SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.
* DOMAIN.-----------------------------------------------------------
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCOCD' ZTIDR-ZFCOCD
                                   CHANGING   W_DOM_TEX1.

  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCUPR' ZTIDR-ZFCUPR
                                   CHANGING   W_DOM_TEX2.
*--------------------------------------------------------------------

  WRITE : / SY-VLINE NO-GAP,'B/L(AWB)��ȣ',
         40 SY-VLINE NO-GAP,'ȭ��������ȣ',
         80 SY-VLINE NO-GAP,'������',
         100 SY-VLINE NO-GAP,'¡�� ����',ZTIDR-ZFCOCD,
         120 SY-VLINE NO-GAP.
  WRITE : / SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFHBLNO,
         40 SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFGOMNO,
         80 SY-VLINE NO-GAP,(4)SPACE,ZTIDR-ZFINDT,
        100 SY-VLINE NO-GAP,(20)W_DOM_TEX1,  " DOMAIN.
        120 SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.

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
*&      Form  P1000_GET_ZTIDR
*&---------------------------------------------------------------------*
FORM P1000_GET_ZTIDR   USING   W_ERR_CHK.

   W_ERR_CHK = 'N'.
   SELECT SINGLE *
      FROM  ZTBL
      WHERE ZFBLNO = P_BLNO.

   SELECT  SINGLE *
       FROM ZTIDR
       WHERE ZFBLNO   = P_BLNO
         AND ZFCLSEQ  = P_CLSEQ.
   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      EXIT.
   ENDIF.
   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_IDSHS
     FROM ZTIDRHS
     WHERE ZFBLNO   = P_BLNO
       AND ZFCLSEQ  = P_CLSEQ.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_IDSHSD
       FROM ZTIDRHSD
     WHERE ZFBLNO   = P_BLNO
       AND ZFCLSEQ  = P_CLSEQ.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_IDSHSL
      FROM ZTIDRHSL
      WHERE ZFBLNO  = P_BLNO
        AND ZFCLSEQ = P_CLSEQ.

ENDFORM.                    " P1000_GET_ZTREQST
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

   SET PF-STATUS 'IMPREQ'.           " GUI STATUS SETTING
   SET  TITLEBAR 'IMPREQ'.           " GUI TITLE SETTING..

   CLEAR : W_TCONO, W_TFONO, W_TCNNO, W_NEED_LINE, W_LINE.

   W_PAGE = 1.     W_LINE = 0.
   W_CONO = 0. " �Ѷ���.
   DESCRIBE TABLE IT_IDSHS LINES W_CONO.
*   DESCRIBE TABLE IT_IDSHSD LINES W_FONO.
*   DESCRIBE TABLE IT_IDSHSL LINES W_CNNO.
*   W_TCONO = W_CONO * 22.
*   W_TFONO = W_FONO * 2.
*   W_TCNNO = W_CNNO * 3.
*   W_LINE =   W_TCONO +  W_TFONO +  W_TCNNO.

   PERFORM P3000_HEAD_WRITE.

   LOOP AT IT_IDSHS.
*     PERFORM P2000_PAGE_CHECK.
     IF SY-TABIX EQ 1.
        W_LINE = 53.
     ENDIF.
*>> �ʿ��� LINE �� ���ϱ�.
     SELECT COUNT( * ) INTO  W_TFONO
     FROM   ZTIDRHSD
     WHERE  ZFBLNO  EQ  IT_IDSHS-ZFBLNO
     AND    ZFCLSEQ EQ  IT_IDSHS-ZFCLSEQ
     AND    ZFCONO  EQ  IT_IDSHS-ZFCONO.

     SELECT COUNT( * ) INTO W_TCNNO
     FROM   ZTIDRHSL
     WHERE  ZFBLNO  EQ  IT_IDSHS-ZFBLNO
     AND    ZFCLSEQ EQ  IT_IDSHS-ZFCLSEQ
     AND    ZFCONO  EQ  IT_IDSHS-ZFCONO.

     W_NEED_LINE  =  21 + W_TFONO + ( W_TCNNO * 3 ).
     IF W_LINE >= W_NEED_LINE.
        PERFORM P3000_ITEM_WRITE.
        W_LINE = W_LINE - W_NEED_LINE.
     ELSE.
        SKIP W_LINE.
        PERFORM P3000_END_LINE_WRITE.
        W_LINE = 70.
        W_PAGE = W_PAGE + 1.
        NEW-PAGE.
        PERFORM P3000_ITEM_WRITE.
        W_LINE = W_LINE - W_NEED_LINE.
     ENDIF.
      AT LAST.
        IF W_LINE < 22.
           W_PAGE = W_PAGE + 1.
           W_LINE = 70.
           NEW-PAGE.
         ENDIF.
         PERFORM P3000_LAST_WRITE.
         W_LINE = W_LINE - 22.
         SKIP W_LINE.
         PERFORM P3000_END_LINE_WRITE.
     ENDAT.
   ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  PERFORM P3000_ITEM_WRITE.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_HSD_DATE
*&---------------------------------------------------------------------*
FORM P3000_HSD_DATE.

  WRITE:/   SY-VLINE,(4)SPACE,IT_IDSHSD-ZFGDDS1,
         40 SY-VLINE,(4)SPACE,IT_IDSHSD-ZFGDIN1,
         60 SY-VLINE NO-GAP,IT_IDSHSD-ZFQNT
         UNIT IT_IDSHSD-ZFQNTM NO-GAP,IT_IDSHSD-ZFQNTM,
         80 SY-VLINE,(1)SPACE,IT_IDSHSD-NETPR CURRENCY IT_IDSHSD-ZFCUR,
        100 SY-VLINE NO-GAP,IT_IDSHSD-ZFAMT CURRENCY IT_IDSHSD-ZFCUR,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

ENDFORM.                    " P3000_HSD_DATE
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  DATA: W_TEXT1(30) TYPE C, "�ε�����-��ȭ����-�ݾ�-�������.
        W_ZFSTAMT(16),      "�����ݾ�.
        W_ZFAAMT   LIKE ZTIDR-ZFVAAMTS. " �ΰ���ġ����ǥ.

  WRITE: ZTIDR-ZFSTAMT CURRENCY ZTIDR-ZFSTAMC TO W_ZFSTAMT.
  SHIFT W_ZFSTAMT LEFT  DELETING LEADING  SPACE.
  CONCATENATE ZTIDR-INCO1 '-' ZTIDR-ZFSTAMC '-' W_ZFSTAMT '-'
              ZTIDR-ZFAMCD INTO W_TEXT1.

  W_ZFAAMT = ZTIDR-ZFVAAMTS * 10.
  WRITE:/ SY-VLINE NO-GAP,'�����ݾ�',
                          '(�ε�����-��ȭ����-�ݾ�-�������)',
       50 SY-VLINE,W_TEXT1,
       90 SY-VLINE NO-GAP,'ȯ��',
      100 SY-VLINE NO-GAP,(5)SPACE,ZTIDR-ZFEXRT,
      120 SY-VLINE.
  WRITE:/ SY-ULINE.
*>>>�Ѱ���.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,'$'NO-GAP,ZTIDR-ZFTBAU CURRENCY ZTIDR-ZFUSD,
       35 SY-VLINE NO-GAP,'����',
       42 SY-VLINE NO-GAP,  ZTIDR-ZFTFB CURRENCY ZTIDR-ZFTFBC,
       62 SY-VLINE NO-GAP,'����ݾ�',
       72 SY-VLINE NO-GAP, ZTIDR-ZFADAM CURRENCY ZTIDR-ZFADAMCU,
       92 SY-VLINE NO-GAP,'����No' NO-GAP,
*      100 SY-VLINE NO-GAP,ZTIDR-ZFRFFNO NO-GAP,
      120 SY-VLINE.
  WRITE:/ SY-VLINE NO-GAP,'�Ѱ�������',
       14 SY-VLINE NO-GAP,
       14 SY-ULINE,
       35 SY-VLINE NO-GAP,
       42 SY-VLINE NO-GAP,
       62 SY-VLINE NO-GAP,
       72 SY-VLINE NO-GAP,
       92 SY-VLINE NO-GAP,
      100 SY-VLINE NO-GAP,
      120 SY-VLINE.

  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,'��'NO-GAP,ZTIDR-ZFTBAK CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,'�����',
       42 SY-VLINE NO-GAP, ZTIDR-ZFINAMT CURRENCY ZTIDR-ZFINAMTC,
       62 SY-VLINE NO-GAP,'�����ݾ�',
       72 SY-VLINE NO-GAP,ZTIDR-ZFDUAM CURRENCY ZTIDR-ZFDUAMCU,
       92 SY-VLINE NO-GAP,'��-��ǥ',
      100 SY-VLINE NO-GAP,W_ZFAAMT CURRENCY ZTIDR-ZFKRW,
      120 SY-VLINE.
  WRITE:/ SY-ULINE.
*>> ����.
  WRITE:/ SY-VLINE NO-GAP,'����',
       14 SY-VLINE NO-GAP,'����',
       35 SY-VLINE NO-GAP,'�ذ���������',
       75 SY-VLINE NO-GAP,'�ؼ��������',
      120 SY-VLINE.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'��    ��'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFCUAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,(40)ZTIDR-ZFCTW1,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'Ư �� ��'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFSCAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,(40)ZTIDR-ZFCTW2,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.

  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'�� �� ��'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFTRAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,(40)ZTIDR-ZFCTW3,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.

  WRITE:/ SY-VLINE NO-GAP,'��     ��'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFDRAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,(40)ZTIDR-ZFCTW4,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'�� �� ��' CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFTRAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,(40)ZTIDR-ZFCTW5,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'�� �� ��'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFVAAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  ULINE AT 1(35).
  WRITE:/ SY-VLINE NO-GAP,'�Ű��������꼼'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFIDAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,
       75 SY-VLINE NO-GAP,
      120 SY-VLINE.
  WRITE:SY-ULINE.

*  SELECT SINGLE *
*         FROM USR03
*         WHERE BNAME = ZTIDR-UNAM.

  WRITE:/ SY-VLINE NO-GAP,'�Ѽ����հ�'CENTERED,
       14 SY-VLINE NO-GAP,ZTIDR-ZFTXAMTS CURRENCY ZTIDR-ZFKRW,
       35 SY-VLINE NO-GAP,'�����'CENTERED,
       50 SY-VLINE NO-GAP,"(10)USR03-NAME1,     " ������? �ϴܺ�����.
       65 SY-VLINE NO-GAP,'�����Ͻ�'CENTERED,
       75 SY-VLINE NO-GAP,
       95 SY-VLINE NO-GAP,'��������'CENTERED,
      105 SY-VLINE NO-GAP, ZTIDR-ZFIDSDT,
      120 SY-VLINE.
  WRITE:SY-ULINE.


ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_HSL_DATE
*&---------------------------------------------------------------------*
FORM P3000_HSL_DATE.

  WRITE:/ SY-VLINE NO-GAP,
       20 SY-VLINE,IT_IDSHSL-ZFCNDC,  " ���Ȯ�� ����.
       45 SY-VLINE NO-GAP,
       70 SY-VLINE,
       95 SY-VLINE NO-GAP,
      120 SY-VLINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
* DOMAIN.-----------------------------------------------------------
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCNDC' IT_IDSHSL-ZFCNDC
                                 CHANGING   W_DOM_TEX1.

  WRITE:/ SY-VLINE ,6'(�߱޼�����)',
       20 SY-VLINE, (20)W_DOM_TEX1,
       45 SY-VLINE NO-GAP,
       70 SY-VLINE,
       95 SY-VLINE NO-GAP,
      120 SY-VLINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-VLINE NO-GAP,
       20 SY-VLINE,IT_IDSHSL-ZFCNNO, " ��ǹ�ȣ.
       45 SY-VLINE NO-GAP,
       70 SY-VLINE,
       95 SY-VLINE NO-GAP,
      120 SY-VLINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

ENDFORM.                    " P3000_HSL_DATE
*&---------------------------------------------------------------------*
*&      Form  P3000_HEAD_WRITE
*&---------------------------------------------------------------------*
FORM P3000_HEAD_WRITE.

  WRITE : / SY-VLINE NO-GAP,'��  ��  ��:',ZTIDR-ZFAPNM,
         60 SY-VLINE NO-GAP,'�����ȹ',ZTIDR-ZFCUPR,
         80 SY-VLINE NO-GAP,'����������',
        100 SY-VLINE NO-GAP,'��  ��  ��',ZTIDR-ZFTOWTM,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,
         60 SY-VLINE NO-GAP,(15)W_DOM_TEX2, " D0MAIN.
         80 SY-VLINE NO-GAP,
        100 SY-VLINE NO-GAP,(1)SPACE,ZTIDR-ZFTOWT
                     UNIT ZTIDR-ZFTOWTM NO-GAP,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,'��  ��  ��:',ZTIDR-ZFIAPNM,
         60 SY-ULINE,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

* DOMAIN.-----------------------------------------------------------
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDIDRCD' ZTIDR-ZFIDRCD
                                   CHANGING   W_DOM_TEX1.
  MOVE ZTIDR-ZFPKCNT TO W_ZFPKCNT.
  WRITE : / SY-VLINE NO-GAP,
         60 SY-VLINE NO-GAP,'�Ű���',ZTIDR-ZFIDRCD,
         80 SY-VLINE NO-GAP,'���ݽŰ�',
        100 SY-VLINE NO-GAP,'�����尹��',ZTIDR-ZFPKNM,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,'�����ǹ���:',ZTIDR-ZFTDNM1,
         60 SY-VLINE NO-GAP,(20)W_DOM_TEX1,    " DOMAIN.
         80 SY-VLINE NO-GAP,
        100 SY-VLINE,(6)SPACE,
        W_ZFPKCNT UNIT ZTIDR-ZFPKNM,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,6'(�ּ�):',ZTIDR-ZFTDAD1,ZTIDR-ZFTDAD2,
          60 SY-ULINE,
         120 SY-VLINE NO-GAP.
* DOMAIN.-----------------------------------------------------------
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZEAPRTC' ZTIDR-ZFAPRTC
                                   CHANGING   W_DOM_TEX1.

  WRITE : / SY-VLINE NO-GAP,6'(��ȣ):',ZTIDR-ZFTDNM1,
         60 SY-VLINE NO-GAP,'�ŷ�����',
         80 SY-VLINE NO-GAP,'����������',ZTIDR-ZFAPRTC,
        100 SY-VLINE NO-GAP,'��� ����',ZTIDR-ZFTRMET,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,6'(����):',ZTIDR-ZFTDNM2,
         60 SY-VLINE NO-GAP, (4)SPACE,ZTIDR-ZFPONC,
         80 SY-VLINE NO-GAP, (20)W_DOM_TEX1,
        100 SY-VLINE NO-GAP," DOMAIN
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,
         60 SY-ULINE,120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  SELECT SINGLE *
         FROM T005T
         WHERE LAND1 = ZTIDR-ZFSCON.

  WRITE : / SY-VLINE NO-GAP,'�����븮��:',ZTIDR-ZFTRDNM,
         60 SY-VLINE NO-GAP,'����',ZTIDR-ZFITKD,  " ������.
         80 SY-VLINE NO-GAP,'���ⱹ',ZTIDR-ZFSCON,T005T-LANDX,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,(4)SPACE,
         60 SY-VLINE NO-GAP,(4)SPACE,  " ������.
         80 SY-ULINE,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
* DOMAIN.-----------------------------------------------------------
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDITKD' ZTIDR-ZFITKD
                                   CHANGING   W_DOM_TEX1.

  WRITE : / SY-VLINE NO-GAP,'��  ��  ��:',ZTIDR-ZFSUPNM,
         60 SY-VLINE NO-GAP, W_DOM_TEX1,
         80 SY-VLINE NO-GAP,'�����',(20)ZTIDR-ZFCARNM,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,
         60 SY-ULINE,
         120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,
         60 SY-VLINE NO-GAP,'MASTER B/L ��ȣ',(20)ZTBL-ZFMBLNO,
        100 SY-VLINE NO-GAP,'��������ȣ',
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE : / SY-VLINE NO-GAP,'�˻�(����)���',ZTIDR-ZFISPL,
         60 SY-VLINE NO-GAP,(4)SPACE,ZTBL-ZFMBLNO,
        100 SY-VLINE NO-GAP,(4)SPACE,ZTBL-ZFTRCK,
        120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:   SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

ENDFORM.                    " P3000_HEAD_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_END_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_END_LINE_WRITE.

  WRITE:/ '*���ԽŰ������� ���� ���δ� ��������������ý���(KCIS)��',
  '��ȸ�Ͽ� Ȯ���Ͻñ� �ٶ��ϴ�.(http://kcis.ktnet.co.kr)',
  /'*�� ���ԽŰ������� �������� �������� ��Ǹ��� �ɻ��� ���̹Ƿ�'
    ,'�Ű����� ��ǰ� �ٸ� ������ �Ű��� �Ǵ� ����ȭ�ְ�'
   ,/'å���� �����մϴ�.'.
  SKIP 4.    " ���� �������� �Ѿ�� ����Ǵ� ���� ���� ������ ����.

ENDFORM.                    " P3000_END_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_ITEM_WRITE
*&---------------------------------------------------------------------*
FORM P3000_ITEM_WRITE.

  DATA: W_ZFCONO TYPE I.
  MOVE IT_IDSHS-ZFCONO TO W_ZFCONO.

  WRITE:/ SY-VLINE NO-GAP,'��ǰ��.�԰�  (����ȣ/�Ѷ���:'NO-GAP,
  W_ZFCONO NO-GAP,'/',(2)W_CONO,')',
  120 SY-VLINE NO-GAP.
*  PERFORM P2000_PAGE_CHECK.
*  ADD 1 TO W_LINE.
*  PERFORM P2000_PAGE_CHECK.

  WRITE:/ SY-ULINE.
*  ADD 1 TO W_LINE.
*  PERFORM P2000_PAGE_CHECK.
*
  WRITE:/ SY-VLINE NO-GAP,'ǰ    ��:    ',IT_IDSHS-ZFGDNM,
       70 SY-VLINE NO-GAP,'��ǥ',
      120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.
*  PERFORM P2000_PAGE_CHECK.

  WRITE:/ SY-VLINE NO-GAP,'�ŷ�ǰ��:',IT_IDSHS-ZFTGDNM,
       70 SY-VLINE NO-GAP,IT_IDSHS-ZFGCNM,
      120 SY-VLINE.
*  ADD 1 TO W_LINE.
*  PERFORM P2000_PAGE_CHECK.
  WRITE:  SY-ULINE.
*  ADD 1 TO W_LINE.
*  PERFORM P2000_PAGE_CHECK.
*
*>> ������� ���� ��� Ÿ��Ʋ ����.
   WRITE:/ SY-VLINE NO-GAP,'��.�԰�',
        40 SY-VLINE NO-GAP,'����',
        60 SY-VLINE NO-GAP,'����',
        80 SY-VLINE NO-GAP,'�ܰ�',IT_IDSHSD-ZFCUR,
        100 SY-VLINE NO-GAP,'�ݾ�',IT_IDSHSD-ZFCUR,
        120 SY-VLINE NO-GAP.
*      ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
      WRITE: SY-ULINE.
*      ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  LOOP AT IT_IDSHSD WHERE ZFBLNO  = IT_IDSHS-ZFBLNO
                      AND ZFCLSEQ = IT_IDSHS-ZFCLSEQ
                      AND ZFCONO  = IT_IDSHS-ZFCONO.

       PERFORM P3000_HSD_DATE.
  ENDLOOP.
  WRITE: SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-VLINE NO-GAP,'������ȣ',
       14 SY-VLINE NO-GAP,IT_IDSHS-STAWN,
       36 SY-VLINE NO-GAP,'���߷�',
       45 SY-VLINE NO-GAP,(3)SPACE, IT_IDSHS-ZFWET
        UNIT IT_IDSHS-ZFWETM NO-GAP,IT_IDSHS-ZFWETM,
       70 SY-VLINE NO-GAP,'C/S�˻�',
       85 SY-VLINE NO-GAP,'S ûCS�˻����',
      105 SY-VLINE NO-GAP,'���ı��',
      120 SY-VLINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  ULINE AT /1(105).
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE: 120 SY-VLINE.
  WRITE:/ SY-VLINE,
       14 SY-VLINE NO-GAP,'$',IT_IDSHS-ZFTBAU CURRENCY IT_IDSHS-ZFUSD
                              RIGHT-JUSTIFIED,
       36 SY-VLINE NO-GAP,'����',
       45 SY-VLINE NO-GAP,(3)SPACE,IT_IDSHS-ZFQNT UNIT
                   IT_IDSHS-ZFQNTM NO-GAP,IT_IDSHS-ZFQNTM,
       70 SY-VLINE NO-GAP,'�˻纯��',
       85 SY-VLINE,
      105 SY-VLINE NO-GAP,IT_IDSHS-ZFMOR1,
      120 SY-VLINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-VLINE NO-GAP,'��������',
       14 SY-ULINE,
       14 SY-VLINE,
       36 SY-VLINE NO-GAP,
       45 SY-VLINE NO-GAP,
       70 SY-VLINE NO-GAP,
       85 SY-VLINE NO-GAP,
      120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-VLINE NO-GAP,
       14 SY-VLINE NO-GAP,'��',IT_IDSHS-ZFTBAK CURRENCY IT_IDSHS-ZFKRW,
       36 SY-VLINE NO-GAP,'ȯ�޹���',
       45 SY-VLINE NO-GAP,(3)SPACE,IT_IDSHS-ZFREQN
                   UNIT IT_IDSHS-ZFREQNM NO-GAP,
                   IT_IDSHS-ZFREQNM,
       70 SY-VLINE NO-GAP,'������ǥ��',
       85 SY-VLINE NO-GAP,IT_IDSHS-ZFORIG NO-GAP,'-'NO-GAP,
                   IT_IDSHS-ZFORYN NO-GAP,'-'NO-GAP,
                   IT_IDSHS-ZFORME NO-GAP,'-'NO-GAP,(1)IT_IDSHS-ZFORTY,
       95 SY-VLINE NO-GAP,'Ư������',(6)SPACE,IT_IDSHS-ZFSCCS
                                     CURRENCY IT_IDSHS-ZFKRW,
      120 SY-VLINE NO-GAP.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  WRITE:/ SY-VLINE NO-GAP,'���Կ��Ȯ��',
       20 SY-VLINE NO-GAP,
       45 SY-VLINE NO-GAP,
       70 SY-VLINE NO-GAP,
       95 SY-VLINE NO-GAP,
      120 SY-VLINE NO-GAP.

*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  LOOP AT IT_IDSHSL WHERE ZFBLNO  = IT_IDSHS-ZFBLNO
                      AND ZFCLSEQ = IT_IDSHS-ZFCLSEQ
                      AND ZFCONO  = IT_IDSHS-ZFCONO.

       PERFORM P3000_HSL_DATE.
  ENDLOOP.
  WRITE:/ SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

*>>>> ����.
*  IF NOT IT_IDSHS-ZFCUAMT IS INITIAL
*   OR NOT IT_IDSHS-ZFVAAMT IS INITIAL
*   OR NOT IT_IDSHS-ZFHMAMT IS INITIAL
*   OR NOT IT_IDSHS-ZFEDAMT IS INITIAL. "�����ǰ����ͺΰ����� ���.
      WRITE:/ SY-VLINE NO-GAP,'����',
           10 SY-VLINE NO-GAP,'����(����)',
           30 SY-VLINE NO-GAP,'������',
           40 SY-VLINE NO-GAP,'����',
           60 SY-VLINE NO-GAP,'����г���ȣ',
           80 SY-VLINE NO-GAP,'�����',
          100 SY-VLINE NO-GAP,'*����������ȣ',
          120 SY-VLINE.
*      ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

      WRITE:/ SY-ULINE.
*      ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

*  ENDIF.
*> ����.
*  IF NOT IT_IDSHS-ZFCUAMT IS INITIAL.
     WRITE:/ SY-VLINE NO-GAP,'����',
          10 SY-VLINE NO-GAP,(6)SPACE,IT_IDSHS-ZFTXCD,
          30 SY-VLINE NO-GAP,IT_IDSHS-ZFRDRT,
          40 SY-VLINE NO-GAP,IT_IDSHS-ZFCUAMT CURRENCY IT_IDSHS-ZFKRW,
          60 SY-VLINE NO-GAP,IT_IDSHS-ZFCDPNO,
          80 SY-VLINE NO-GAP,IT_IDSHS-ZFCCAMT CURRENCY IT_IDSHS-ZFKRW,
         100 SY-VLINE NO-GAP,
         120 SY-VLINE.
*     ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

*  ENDIF.
*>�ΰ���.
*  IF NOT IT_IDSHS-ZFVAAMT IS INITIAL.
     WRITE:/ SY-VLINE NO-GAP,'�ΰ���',
          10 SY-VLINE NO-GAP,' 10.00', IT_IDSHS-ZFVTXCD, " �ΰ�������.
          30 SY-VLINE NO-GAP,                  " �ΰ���������.
          40 SY-VLINE NO-GAP,IT_IDSHS-ZFVAAMT
             CURRENCY IT_IDSHS-ZFKRW,          " �ΰ���.
          60 SY-VLINE NO-GAP,                  " �г���ȣ.
          80 SY-VLINE NO-GAP,IT_IDSHS-ZFVCAMT
                    CURRENCY IT_IDSHS-ZFKRW,   " �����.
         100 SY-VLINE NO-GAP,
         120 SY-VLINE.
*     ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

*  ENDIF.
*>������
  IF NOT IT_IDSHS-ZFHMAMT IS INITIAL.
     WRITE:/ SY-VLINE NO-GAP,'������',
       10 SY-VLINE NO-GAP,IT_IDSHS-ZFHMTRT, " ����.
                          IT_IDSHS-ZFHMTCD, " ������.
       30 SY-VLINE NO-GAP,                  " ������.
       40 SY-VLINE NO-GAP,IT_IDSHS-ZFHMAMT
          CURRENCY IT_IDSHS-ZFKRW,          " ��.
       60 SY-VLINE NO-GAP,                  " �г���ȣ.
       80 SY-VLINE NO-GAP,IT_IDSHS-ZFHCAMT
          CURRENCY IT_IDSHS-ZFKRW,          " �����.
      100 SY-VLINE NO-GAP,IT_IDSHS-ZFHMTTY, " ��������.
      120 SY-VLINE.
*     ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  ENDIF.

*>������.
  IF NOT IT_IDSHS-ZFEDAMT IS INITIAL.
     WRITE:/ SY-VLINE NO-GAP,'������',
          10 SY-VLINE NO-GAP,(6)SPACE, IT_IDSHS-ZFETXCD, " ������.
          30 SY-VLINE NO-GAP,                  " ������.
          40 SY-VLINE NO-GAP,IT_IDSHS-ZFEDAMT
             CURRENCY IT_IDSHS-ZFKRW,          " ��.
          60 SY-VLINE NO-GAP,                  " �г���ȣ.
          80 SY-VLINE NO-GAP,IT_IDSHS-ZFECAMT
             CURRENCY IT_IDSHS-ZFKRW,         " �����.
         100 SY-VLINE NO-GAP,
         120 SY-VLINE.
*    ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.
  ENDIF.
*>��Ư.
  IF NOT IT_IDSHS-ZFAGAMT IS INITIAL.
     WRITE:/ SY-VLINE NO-GAP,'��Ư��',
          10 SY-VLINE NO-GAP,(6)SPACE,IT_IDSHS-ZFATXCD, " ������.
          30 SY-VLINE NO-GAP,                  " ������.
          40 SY-VLINE NO-GAP,IT_IDSHS-ZFAGAMT
             CURRENCY IT_IDSHS-ZFKRW,          " ��.
          60 SY-VLINE NO-GAP,                  " �г���ȣ.
          80 SY-VLINE NO-GAP,                  " �����.
         100 SY-VLINE NO-GAP,
         120 SY-VLINE.
*    ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

  ENDIF.

  WRITE:/ SY-ULINE.
*  ADD 1 TO W_LINE.PERFORM P2000_PAGE_CHECK.

ENDFORM.                    " P3000_ITEM_WRITE
