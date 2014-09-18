*&---------------------------------------------------------------------
*& Report  ZRIMORGPCLST
*&---------------------------------------------------------------------
*&  ���α׷��� : ���Ž�����Ȳǥ(��ȭ��)
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&      �ۼ��� : 2001.10.08
*&---------------------------------------------------------------------
*&   DESC.     :
*&
*&---------------------------------------------------------------------
*& [���泻��]
*&
*&---------------------------------------------------------------------
REPORT  ZRIMORGPCLST  MESSAGE-ID ZIM
                     LINE-SIZE 255
                     NO STANDARD PAGE HEADING.
TABLES: ZTIVHST,ZTIVHSTIT,ZTIVIT,ZTREQHD,ZTREQST,
        EKKO,EKBE,EKPO,LFA1,ZTREQORJ,
        T001W,T005T,T156.
*----------------------------------------------------------------------
*  ����Ʈ�� INTERNAL TABLE
*----------------------------------------------------------------------

DATA : BEGIN OF IT_ZTIVHST OCCURS 0,
       ZFIVNO    LIKE  ZTIVHST-ZFIVNO,	" �����û/�԰��û ������ȣ.
       ZFIVHST   LIKE  ZTIVHST-ZFIVHST,	" �԰����.
       ZFREQTY   LIKE  ZTREQHD-ZFREQTY,  " ��������.
       WERKS     LIKE  ZTIVHSTIT-WERKS,   " �÷�Ʈ.
       ZFGRST	   LIKE  ZTIVHST-ZFGRST,    " Good Receipt ����.
       ZFCIVHST  LIKE  ZTIVHST-ZFCIVHST,  " Verify ����.
       BLDAT	   LIKE  ZTIVHST-BLDAT,     " ��ǥ�� ������.
       SHKZG	   LIKE  ZTIVHST-SHKZG,     " ����/�뺯 ������.
       MBLNR     LIKE  ZTIVHST-MBLNR,     " ���繮����ȣ.
       MJAHR     LIKE  ZTIVHST-MJAHR,     " ���繮������.
       BWART	   LIKE  ZTIVHST-BWART,     " �̵����� (������).
       ZFREQNO   LIKE  ZTREQHD-ZFREQNO,   " �����Ƿڰ�����ȣ.
       EBELN	   LIKE  ZTIVHSTIT-EBELN,   " ���Ź�����ȣ
       ZFIVDNO   LIKE   ZTIVHSTIT-ZFIVDNO," ���Ź�����ȣ
       EBELP	   LIKE  ZTIVHSTIT-EBELP,   " ���Ź��� ǰ���ȣ
       MATNR	   LIKE  ZTIVHSTIT-MATNR,   " �����ȣ.
       LLIEF     LIKE  EKKO-LLIEF,        " ����.
       NAME1     LIKE  LFA1-NAME1,        " NAME1.
       EKORG	   LIKE  EKKO-EKORG,        " ��������.
       USDDMBTR  LIKE  EKBE-DMBTR,        " �̱�.
       JPYDMBTR  LIKE  EKBE-DMBTR,        " �Ϻ�.
       DMDMBTR   LIKE  EKBE-DMBTR,        " ����.
       SFRDMBTR  LIKE  EKBE-DMBTR,        " ������.
       FFRDMBTR  LIKE  EKBE-DMBTR,        " ������.
       BDPDMBTR  LIKE  EKBE-DMBTR,        " ����.
       EURDMBTR  LIKE  EKBE-DMBTR,        " ���ο�ȭ.
       ETCDMBTR  LIKE  EKBE-DMBTR,        " ��Ÿ.
       FUSDDMBTR LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR  LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR  LIKE  EKBE-DMBTR,        " ������ȭ.
       FETCDMBTR LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR   LIKE  EKBE-DMBTR,        " ����������ȭ.
       LOKRW     LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       ZFUSDAM   LIKE  ZTREQHD-ZFUSDAM,   " USD ȯ��ݾ�.
       FLOKRW    LIKE  EKBE-DMBTR,       " LOCAL ��ȭ.
       LOUSD     LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       FLOUSD    LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       ZFLASTAM  LIKE  ZTREQHD-ZFLASTAM,  " �����ݾ�.
       DMBTR     LIKE  EKBE-DMBTR,        " ������ȭ.
       TXZ01     LIKE  EKPO-TXZ01,        " ǰ��.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       MEINS     LIKE  EKPO-MEINS.        " ��������.
DATA : END OF IT_ZTIVHST.
*>> ITEM ����.
DATA : BEGIN OF IT_TAB OCCURS 0,
       WERKS       LIKE  ZTIVHSTIT-WERKS,     " �÷�Ʈ.
       USDDMBTR    LIKE  EKBE-DMBTR,          " �̱�.
       JPYDMBTR    LIKE  EKBE-DMBTR,          " �Ϻ�.
       DMDMBTR     LIKE  EKBE-DMBTR,          " ����.
       SFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       FFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       BDPDMBTR    LIKE  EKBE-DMBTR,          " ����.
       EURDMBTR    LIKE  EKBE-DMBTR,         " ���ο�ȭ.
       ETCDMBTR    LIKE  EKBE-DMBTR,          " ��Ÿ.
       FUSDDMBTR   LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR   LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR    LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR   LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR  LIKE  EKBE-DMBTR,           " ������ȭ.
       FETCDMBTR   LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR    LIKE  EKBE-DMBTR,          " ����������ȭ.
       LOKRW     LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       FLOKRW     LIKE  EKBE-DMBTR,          " LOCAL ��ȭ.
       LOUSD     LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       FLOUSD    LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       DMBTR      LIKE  EKBE-DMBTR.          " ������ȭ.
DATA : END OF IT_TAB.

*>> �������TOTAL.
DATA : BEGIN OF IT_CTOTAL OCCURS 0,
       USDDMBTR    LIKE  EKBE-DMBTR,          " �̱�.
       JPYDMBTR    LIKE  EKBE-DMBTR,          " �Ϻ�.
       DMDMBTR     LIKE  EKBE-DMBTR,          " ����.
       SFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       FFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       BDPDMBTR    LIKE  EKBE-DMBTR,          " ����.
       EURDMBTR    LIKE  EKBE-DMBTR,         " ���ο�ȭ.
       ETCDMBTR    LIKE  EKBE-DMBTR,          " ��Ÿ.
       FUSDDMBTR   LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR   LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR    LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR   LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR    LIKE  EKBE-DMBTR,         " ������ȭ.
       FETCDMBTR   LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR     LIKE  EKBE-DMBTR,         " ����������ȭ.
       LOKRW       LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       FLOKRW      LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       LOUSD       LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       FLOUSD      LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       DMBTR       LIKE  EKBE-DMBTR.          " ������ȭ.
DATA : END OF IT_CTOTAL.


DATA : BEGIN OF IT_ZTIVHST1 OCCURS 0,
       ZFIVNO    LIKE  ZTIVHST-ZFIVNO,	" �����û/�԰��û ������ȣ.
       ZFIVHST   LIKE  ZTIVHST-ZFIVHST,	" �԰����.
       ZFREQTY   LIKE  ZTREQHD-ZFREQTY,  " ��������.
       WERKS     LIKE  ZTIVHSTIT-WERKS,   " �÷�Ʈ.
       ZFGRST	   LIKE  ZTIVHST-ZFGRST,    " Good Receipt ����.
       ZFCIVHST  LIKE  ZTIVHST-ZFCIVHST,  " Verify ����.
       BLDAT	   LIKE  ZTIVHST-BLDAT,     " ��ǥ�� ������.
       SHKZG	   LIKE  ZTIVHST-SHKZG,     " ����/�뺯 ������.
       MBLNR     LIKE  ZTIVHST-MBLNR,     " ���繮����ȣ.
       MJAHR     LIKE  ZTIVHST-MJAHR,     " ���繮������.
       BWART	   LIKE  ZTIVHST-BWART,     " �̵����� (������).
       ZFREQNO   LIKE  ZTREQHD-ZFREQNO,   " �����Ƿڰ�����ȣ.
       EBELN	   LIKE  ZTIVHSTIT-EBELN,   " ���Ź�����ȣ
       ZFIVDNO   LIKE   ZTIVHSTIT-ZFIVDNO," ���Ź�����ȣ
       EBELP	   LIKE  ZTIVHSTIT-EBELP,   " ���Ź��� ǰ���ȣ
       MATNR	   LIKE  ZTIVHSTIT-MATNR,   " �����ȣ.
       LLIEF     LIKE  EKKO-LLIEF,        " ����.
       NAME1     LIKE  LFA1-NAME1,        " NAME1.
       EKORG	   LIKE  EKKO-EKORG,        " ��������.
       USDDMBTR  LIKE  EKBE-DMBTR,        " �̱�.
       JPYDMBTR  LIKE  EKBE-DMBTR,        " �Ϻ�.
       DMDMBTR   LIKE  EKBE-DMBTR,        " ����.
       SFRDMBTR  LIKE  EKBE-DMBTR,        " ������.
       FFRDMBTR  LIKE  EKBE-DMBTR,        " ������.
       BDPDMBTR  LIKE  EKBE-DMBTR,        " ����.
       EURDMBTR  LIKE  EKBE-DMBTR,        " ���ο�ȭ.
       ETCDMBTR  LIKE  EKBE-DMBTR,        " ��Ÿ.
       FUSDDMBTR LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR  LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR  LIKE  EKBE-DMBTR,        " ������ȭ.
       FETCDMBTR LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR   LIKE  EKBE-DMBTR,        " ����������ȭ.
       LOKRW     LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       ZFUSDAM   LIKE  ZTREQHD-ZFUSDAM,   " USD ȯ��ݾ�.
       FLOKRW    LIKE  EKBE-DMBTR,       " LOCAL ��ȭ.
       LOUSD     LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       FLOUSD    LIKE  EKBE-DMBTR,        " LOCAL ��ȭ.
       ZFLASTAM  LIKE  ZTREQHD-ZFLASTAM,  " �����ݾ�.
       DMBTR     LIKE  EKBE-DMBTR,        " ������ȭ.
       TXZ01     LIKE  EKPO-TXZ01,        " ǰ��.
       BAMNG     LIKE  EKBE-BAMNG,        " ����.
       MEINS     LIKE  EKPO-MEINS.        " ��������.
DATA : END OF IT_ZTIVHST1.
*>> ���⵵ Plant.
DATA : BEGIN OF IT_TAB1 OCCURS 0,
         WERKS       LIKE  ZTIVHSTIT-WERKS,     " �÷�Ʈ.
       USDDMBTR    LIKE  EKBE-DMBTR,          " �̱�.
       JPYDMBTR    LIKE  EKBE-DMBTR,          " �Ϻ�.
       DMDMBTR     LIKE  EKBE-DMBTR,          " ����.
       SFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       FFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       BDPDMBTR    LIKE  EKBE-DMBTR,          " ����.
       EURDMBTR    LIKE  EKBE-DMBTR,         " ���ο�ȭ.
       ETCDMBTR    LIKE  EKBE-DMBTR,          " ��Ÿ.
       FUSDDMBTR   LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR   LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR    LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR   LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR  LIKE  EKBE-DMBTR,           " ������ȭ.
       FETCDMBTR   LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR    LIKE  EKBE-DMBTR,          " ����������ȭ.
       LOKRW     LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       FLOKRW     LIKE  EKBE-DMBTR,          " LOCAL ��ȭ.
       LOUSD     LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       FLOUSD    LIKE  EKBE-DMBTR,           " LOCAL ��ȭ.
       DMBTR      LIKE  EKBE-DMBTR.          " ������ȭ.
DATA : END OF IT_TAB1.
*>> ��������TOTAL.
DATA : BEGIN OF IT_OTOTAL OCCURS 0,
       USDDMBTR    LIKE  EKBE-DMBTR,          " �̱�.
       JPYDMBTR    LIKE  EKBE-DMBTR,          " �Ϻ�.
       DMDMBTR     LIKE  EKBE-DMBTR,          " ����.
       SFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       FFRDMBTR    LIKE  EKBE-DMBTR,          " ������.
       BDPDMBTR    LIKE  EKBE-DMBTR,          " ����.
       EURDMBTR    LIKE  EKBE-DMBTR,         " ���ο�ȭ.
       ETCDMBTR    LIKE  EKBE-DMBTR,          " ��Ÿ.
       FUSDDMBTR   LIKE  EKBE-DMBTR,         " �̱���ȭ.
       FJPYDMBTR   LIKE  EKBE-DMBTR,         " �Ϻ���ȭ.
       FDMDMBTR    LIKE  EKBE-DMBTR,         " ���Ͽ�ȭ.
       FSFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FFFRDMBTR   LIKE  EKBE-DMBTR,         " ��������ȭ.
       FBDPDMBTR   LIKE  EKBE-DMBTR,         " ������ȭ.
       FEURDMBTR    LIKE  EKBE-DMBTR,         " ������ȭ.
       FETCDMBTR   LIKE  EKBE-DMBTR,         " ��Ÿ��ȭ.
       IMDMBTR     LIKE  EKBE-DMBTR,         " ����������ȭ.
       LOKRW       LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       FLOKRW      LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       LOUSD       LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       FLOUSD      LIKE  EKBE-DMBTR,         " LOCAL ��ȭ.
       DMBTR       LIKE  EKBE-DMBTR.          " ������ȭ.
DATA : END OF IT_OTOTAL.
*>> ��� �÷�Ʈ ��ȭ ����.
DATA : USDDMBTR    TYPE P  DECIMALS 2,           " �̱�.
       JPYDMBTR    TYPE P  DECIMALS 2,           " �Ϻ�.
       DMDMBTR     TYPE P  DECIMALS 2,           " ����.
       SFRDMBTR    TYPE P  DECIMALS 2,           " ������.
       FFRDMBTR    TYPE P  DECIMALS 2,           " ������.
       BDPDMBTR    TYPE P  DECIMALS 2,           " ����.
       EURDMBTR    TYPE P  DECIMALS 2,           " ����.
       ETCDMBTR    TYPE P  DECIMALS 2,           " ��Ÿ.
       IMDMBTR     TYPE P  DECIMALS 2,         " ����������ȭ.
       LOKRW       TYPE P  DECIMALS 2,
       LOUSD       TYPE P  DECIMALS 2.

*>> ���� �÷�Ʈ��ȭ ����.
DATA : USDDMBTR1    TYPE P  DECIMALS 2,           " �̱�.
       JPYDMBTR1    TYPE P  DECIMALS 2,           " �Ϻ�.
       DMDMBTR1     TYPE P  DECIMALS 2,           " ����.
       SFRDMBTR1    TYPE P  DECIMALS 2,           " ������.
       FFRDMBTR1    TYPE P  DECIMALS 2,           " ������.
       BDPDMBTR1    TYPE P  DECIMALS 2,           " ����.
       EURDMBTR1    TYPE P  DECIMALS 2,           " ����.
       ETCDMBTR1    TYPE P  DECIMALS 2,           " ��Ÿ.
       IMDMBTR1     TYPE P  DECIMALS 2,           " ����������ȭ.
       LOKRW1       TYPE P  DECIMALS 2,
       LOUSD1       TYPE P  DECIMALS 2.


*>> ������ ��ȭ ����.
DATA : USDDMBTR2    TYPE P  DECIMALS 2,           " �̱�.
       JPYDMBTR2    TYPE P  DECIMALS 2,           " �Ϻ�.
       DMDMBTR2     TYPE P  DECIMALS 2,           " ����.
       SFRDMBTR2    TYPE P  DECIMALS 2,           " ������.
       FFRDMBTR2    TYPE P  DECIMALS 2,           " ������.
       BDPDMBTR2    TYPE P  DECIMALS 2,           " ����.
       EURDMBTR2    TYPE P  DECIMALS 2,           " ����.
       ETCDMBTR2    TYPE P  DECIMALS 2,           " ��Ÿ.
       IMDMBTR2     TYPE P  DECIMALS 2,         " ����������ȭ.
       LOKRW2       TYPE P  DECIMALS 2,
       LOUSD2       TYPE P  DECIMALS 2.

*>> ���� ��ȭ ����.
DATA : USDDMBTR3    TYPE P  DECIMALS 2,           " �̱�.
       JPYDMBTR3    TYPE P  DECIMALS 2,           " �Ϻ�.
       DMDMBTR3     TYPE P  DECIMALS 2,           " ����.
       SFRDMBTR3    TYPE P  DECIMALS 2,           " ������.
       FFRDMBTR3    TYPE P  DECIMALS 2,           " ������.
       BDPDMBTR3    TYPE P  DECIMALS 2,           " ����.
       EURDMBTR3    TYPE P  DECIMALS 2,           " ����.
       ETCDMBTR3    TYPE P  DECIMALS 2,           " ��Ÿ.
       IMDMBTR3     TYPE P  DECIMALS 2,         " ����������ȭ.
       LOKRW3       TYPE P  DECIMALS 2,
       LOUSD3       TYPE P  DECIMALS 2.

DATA :  W_ERR_CHK     TYPE C,
        W_FIELD_NM    TYPE C,
        W_TO(04),
        W_FROM(04),
        ST_DMBTR      LIKE  EKBE-DMBTR,        " ���⵵�Ѿ�.
        ST_BAMNG      LIKE  EKBE-BAMNG,        " ���⵵����.
        W_LINE        TYPE I,
        W_COUNT       TYPE I,
        W_CHEK,
        W_CHECK_BIT   TYPE C,
        W_SINGN(1),
        W_TABIX       LIKE SY-TABIX,
        W_PAGE        TYPE I,
        W_LIST_INDEX  LIKE SY-TABIX.
RANGES: R_BLDAT FOR ZTIVHST-BLDAT OCCURS 05.

INCLUDE   ZRIMSORTCOM.    " REPORT Sort
INCLUDE   ZRIMUTIL01.     " Utility function ��?

*----------------------------------------------------------------------
* Selection Screen ?
*----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

     SELECT-OPTIONS:
     S_BUKRS   FOR  EKKO-BUKRS NO-EXTENSION NO INTERVALS,
     S_WERKS   FOR  EKPO-WERKS,
     S_BLDAT   FOR  EKBE-BUDAT OBLIGATORY,     "������(�Ⱓ)
     S_EKGRP   FOR EKKO-EKGRP,        " ���ű׷�..
     S_EKORG	 FOR  EKKO-EKORG,       " ��������.
     S_BSTYP   FOR  EKKO-BSTYP,     "1���Ź�������
     S_BSART   FOR  EKKO-BSART.     "4���Ź�������
 SELECTION-SCREEN END OF BLOCK B1.
 INITIALIZATION.                          " �ʱⰪ SETTING
   PERFORM   P2000_INIT.

*title Text Write
W_PAGE = 1.
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
   IF W_ERR_CHK = 'S'.
      MESSAGE S977 WITH '�԰����� ������ �������� �ʽ��ϴ�.'.
      EXIT.
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
*          PERFORM  P2000_TOP_END_IT_TAB.
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
*  CLEAR: IT_TAB, W_TABIX.

*&---------------------------------------------------------------------
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------
FORM P3000_TITLE_WRITE.


  SKIP 1.
  WRITE:/100'[    ��  ��  ��  ��   ��  Ȳ  ǥ  ( �� ȭ �� )     ]'
      COLOR COL_HEADING INTENSIFIED OFF.
  SKIP 2.
  WRITE:/ '��⵵�Ⱓ:',S_BLDAT-LOW,'~',S_BLDAT-HIGH.
  WRITE:/ '���⵵�Ⱓ:',R_BLDAT-LOW,'~',R_BLDAT-HIGH .

  WRITE:/ '��      ��:','��ȭ�ݾ�(�鸸��)',',','��ȭ�ݾ�(õ)'.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-ULINE.
  WRITE : / SY-VLINE NO-GAP,(20) 'Plant'     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '�̱�$'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '�Ϻ���'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '����DM'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '������SF'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '������FF'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '����LB'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '����EUR'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��Ÿ'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '���԰�'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��Local DL' NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '$ Local DL' NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) 'Total '  NO-GAP CENTERED,
            SY-VLINE.
   FORMAT RESET.
   FORMAT COLOR COL_HEADING INTENSIFIED OFF.
   WRITE : / SY-VLINE NO-GAP,(20) ''     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��'      NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ' ��'    NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '��Local ��'   NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '$ Local �� '  NO-GAP CENTERED,
            SY-VLINE NO-GAP, (06) '����'      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ' ��'  NO-GAP CENTERED,
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

  W_TO   =  S_BLDAT-LOW(04) - S_BLDAT-HIGH(04).
  W_FROM =  S_BLDAT-LOW(04) - 0001.
*>> ��⵵ ���� ���� üũ.
  IF W_TO NE 0.
      W_ERR_CHK = 'S'.
      EXIT.
  ENDIF.
*>> ���⵵ ��������.
  MOVE : 'I'               TO  R_BLDAT-SIGN,
         'BT'              TO  R_BLDAT-OPTION.
  CONCATENATE  W_FROM  S_BLDAT-LOW+4(04) INTO   R_BLDAT-LOW.
  CONCATENATE  W_FROM  S_BLDAT-HIGH+4(04) INTO   R_BLDAT-HIGH.
  APPEND R_BLDAT.
*>> ���س⵵.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTIVHST
            FROM ZTIVHST AS R INNER JOIN ZTIVHSTIT AS I
             ON R~ZFIVNO  = I~ZFIVNO
            AND R~ZFIVHST = I~ZFIVHST
         WHERE  I~ZFGRST  = 'Y'
           AND  I~WERKS   IN S_WERKS
           AND  R~BLDAT   IN S_BLDAT.    " ������.
*>> ����.
 CLEAR IT_ZTIVHST.
 SELECT * APPENDING CORRESPONDING FIELDS OF TABLE  IT_ZTIVHST
            FROM ( ZTREQHD AS R INNER JOIN ZTREQST AS I
             ON   R~ZFREQNO  = I~ZFREQNO )
             INNER JOIN ZTREQIT AS M
             ON   R~ZFREQNO  = M~ZFREQNO
          WHERE I~ZFDOCST  = 'O'
           AND  R~ZFREQTY  = 'LO'.
  PERFORM P1000_CURRENCT_BLDAT.
*>> ���⵵.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTIVHST1
            FROM ZTIVHST AS R INNER JOIN ZTIVHSTIT AS I
             ON R~ZFIVNO  = I~ZFIVNO
            AND R~ZFIVHST = I~ZFIVHST
         WHERE  I~ZFGRST  = 'Y'
           AND  I~WERKS   IN S_WERKS
           AND  R~BLDAT   IN R_BLDAT.          " ������.
*>> LOCAL.
 CLEAR IT_ZTIVHST1.
 SELECT * APPENDING CORRESPONDING FIELDS OF TABLE  IT_ZTIVHST1
            FROM ( ZTREQHD AS R INNER JOIN ZTREQST AS I
             ON   R~ZFREQNO  = I~ZFREQNO )
             INNER JOIN ZTREQIT AS M
             ON   R~ZFREQNO  = M~ZFREQNO
          WHERE I~ZFDOCST  = 'O'
           AND  R~ZFREQTY  = 'LO'.

  PERFORM P1000_OLDDAT_BLDAT.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE .

   SET TITLEBAR  'ZIMR30'.
   SET PF-STATUS 'ZIMR30'.
   CLEAR W_COUNT.
   DESCRIBE TABLE IT_TAB LINES W_LINE.
   LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      PERFORM  P3000_LINE_WRITE.
   ENDLOOP.
   WRITE:/ SY-ULINE.
   PERFORM P3000_LINE_TOTAL.

*  CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------
*&      Form  P2000_INIT
*&---------------------------------------------------------------------
FORM P2000_INIT.

  SET TITLEBAR  'ZIMR30'.

  MOVE : 'I'               TO  S_BLDAT-SIGN,
         'BT'              TO  S_BLDAT-OPTION,
         SY-DATUM          TO  S_BLDAT-HIGH.
  CONCATENATE SY-DATUM(4) '01' '01' INTO S_BLDAT-LOW.

  APPEND S_BLDAT.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
FORM P3000_LINE_WRITE.
*>> ��������.
 DATA : L_USDDMBTR   TYPE P  DECIMALS 2,           " �̱�.
        L_JPYDMBTR    TYPE P  DECIMALS 2,           " �Ϻ�.
        L_DMDMBTR     TYPE P  DECIMALS 2,           " ����.
        L_SFRDMBTR    TYPE P  DECIMALS 2,           " ������.
        L_FFRDMBTR    TYPE P  DECIMALS 2,           " ������.
        L_BDPDMBTR    TYPE P  DECIMALS 2,           " ����.
        L_EURDMBTR    TYPE P  DECIMALS 2,           " ����.
        L_ETCDMBTR    TYPE P  DECIMALS 2,           " ��Ÿ.
        L_IMDMBTR     TYPE P  DECIMALS 2,         " ����������ȭ.
        L_LOKRW       TYPE P  DECIMALS 2,
        L_LOUSD       TYPE P  DECIMALS 2.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
*>> ��� ��ȭ.
  WRITE : / SY-VLINE NO-GAP,(20) IT_TAB-WERKS NO-GAP,    " Plant'
            SY-VLINE NO-GAP,(12) IT_TAB-FUSDDMBTR
                     CURRENCY 'USD' NO-GAP," �̱�
                      SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FJPYDMBTR
                     CURRENCY 'JPY' NO-GAP,"�Ϻ�
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FDMDMBTR
                     CURRENCY 'DEM' NO-GAP," ����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FSFRDMBTR
                     CURRENCY 'CHF' NO-GAP,"'������
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FFFRDMBTR
                     CURRENCY 'CFP' NO-GAP,"'������
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FBDPDMBTR
                     CURRENCY 'GBP' NO-GAP,"'����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FEURDMBTR
                     CURRENCY 'EUR' NO-GAP,"����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FLOKRW
                     CURRENCY 'USD' NO-GAP,
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FLOUSD
                     CURRENCY 'USD' NO-GAP, " $ Local '  ,
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
            SY-VLINE.
  CLEAR T001W.
  SELECT SINGLE *
         FROM T001W
        WHERE WERKS = IT_TAB-WERKS.
*>> ��⵵����.
  CLEAR: USDDMBTR,JPYDMBTR,DMDMBTR,SFRDMBTR,FFRDMBTR,BDPDMBTR,
         ETCDMBTR,IMDMBTR,LOKRW,LOUSD.
  IF NOT IT_TAB-DMBTR IS INITIAL.
    USDDMBTR  =  IT_TAB-USDDMBTR / IT_TAB-DMBTR * 100.  " �̱�.
    JPYDMBTR  =  IT_TAB-JPYDMBTR / IT_TAB-DMBTR * 100.  " �Ϻ�.
    DMDMBTR   =  IT_TAB-DMDMBTR  / IT_TAB-DMBTR * 100.  " ����.
    SFRDMBTR  =  IT_TAB-SFRDMBTR / IT_TAB-DMBTR * 100.  " ������.
    FFRDMBTR  =  IT_TAB-FFRDMBTR / IT_TAB-DMBTR * 100.  " ������.
    BDPDMBTR  =  IT_TAB-BDPDMBTR / IT_TAB-DMBTR * 100.  " ����.
    EURDMBTR  =  IT_TAB-EURDMBTR / IT_TAB-DMBTR * 100.  " ����.
    ETCDMBTR  =  IT_TAB-ETCDMBTR / IT_TAB-DMBTR * 100.   " ��Ÿ.
    IMDMBTR   =  IT_TAB-IMDMBTR  / IT_TAB-DMBTR * 100.  " ����������ȭ.
    LOKRW     =  IT_TAB-LOKRW    / IT_TAB-DMBTR * 100.
    LOUSD     =  IT_TAB-LOUSD    / IT_TAB-DMBTR * 100.
  ENDIF.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

*>> ��� ������ȭ.
  WRITE : / SY-VLINE NO-GAP,(20) T001W-NAME1 NO-GAP,    " Plant'
            SY-VLINE NO-GAP,(12) IT_TAB-USDDMBTR
                     CURRENCY 'KRW' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) USDDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-JPYDMBTR
                     CURRENCY 'KRW' NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) JPYDMBTR    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-DMDMBTR
                     CURRENCY 'KRW' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) DMDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-SFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) SFRDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-FFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) FFRDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-BDPDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) BDPDMBTR     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-EURDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) EURDMBTR     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-ETCDMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06) ETCDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-IMDMBTR
                     CURRENCY 'KRW' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) IMDMBTR    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-LOKRW
                     CURRENCY 'KRW' NO-GAP,
                     SY-VLINE NO-GAP,(06) LOKRW    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-LOUSD
                     CURRENCY 'KRW' NO-GAP, " $ Local '
                     SY-VLINE NO-GAP,(06) LOUSD   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB-DMBTR
                     CURRENCY 'KRW' NO-GAP,  " ��Ż'
            SY-VLINE.
 CLEAR IT_TAB1.
 READ TABLE IT_TAB1 WITH KEY WERKS = IT_TAB-WERKS.
*>> ���⵵����.
  CLEAR: USDDMBTR1,JPYDMBTR1,DMDMBTR1,SFRDMBTR1,FFRDMBTR1,BDPDMBTR1,
         ETCDMBTR1,IMDMBTR1,LOKRW1,LOUSD1.
  IF NOT IT_TAB1-DMBTR IS INITIAL.
    USDDMBTR1  =  IT_TAB1-USDDMBTR / IT_TAB1-DMBTR * 100.  " �̱�.
    JPYDMBTR1  =  IT_TAB1-JPYDMBTR / IT_TAB1-DMBTR * 100.  " �Ϻ�.
    DMDMBTR1   =  IT_TAB1-DMDMBTR  / IT_TAB1-DMBTR * 100.  " ����.
    SFRDMBTR1  =  IT_TAB1-SFRDMBTR / IT_TAB1-DMBTR * 100.  " ������.
    FFRDMBTR1  =  IT_TAB1-FFRDMBTR / IT_TAB1-DMBTR * 100.  " ������.
    BDPDMBTR1  =  IT_TAB1-BDPDMBTR / IT_TAB1-DMBTR * 100.  " ����.
    EURDMBTR1  =  IT_TAB1-EURDMBTR / IT_TAB1-DMBTR * 100.  " ����.
    ETCDMBTR1  =  IT_TAB1-ETCDMBTR / IT_TAB1-DMBTR * 100.   " ��Ÿ.
    IMDMBTR1  =  IT_TAB1-IMDMBTR  / IT_TAB1-DMBTR * 100. " ����������ȭ.
    LOKRW1     =  IT_TAB1-LOKRW    / IT_TAB1-DMBTR * 100.
    LOUSD1     =  IT_TAB1-LOUSD    / IT_TAB1-DMBTR * 100.
  ENDIF.
*>> ���⵵ ������ȭ.
 FORMAT RESET.
 FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

 WRITE : / SY-VLINE NO-GAP,(20) '' NO-GAP,    " Plant'
            SY-VLINE NO-GAP,(12) IT_TAB1-USDDMBTR
                     CURRENCY 'KRW' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) USDDMBTR1  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-JPYDMBTR
                     CURRENCY 'KRW' NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) JPYDMBTR1 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-DMDMBTR
                     CURRENCY 'KRW' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) DMDMBTR1 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-SFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                    SY-VLINE NO-GAP,(06)SFRDMBTR1    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-FFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) FFRDMBTR1     NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-BDPDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) BDPDMBTR1    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-EURDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) EURDMBTR1    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-ETCDMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06)ETCDMBTR1   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-IMDMBTR
                     CURRENCY 'KRW' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) IMDMBTR1      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-LOKRW
                     CURRENCY 'KRW' NO-GAP,
                     SY-VLINE NO-GAP,(06)LOKRW1      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_TAB1-LOUSD
                     CURRENCY 'KRW' NO-GAP, " $ Local '
                     SY-VLINE NO-GAP,(06) LOUSD1  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
            SY-VLINE.
 L_USDDMBTR  =  USDDMBTR -  USDDMBTR1.           " �̱�.
 L_JPYDMBTR  =  JPYDMBTR -  JPYDMBTR1.       " �Ϻ�.
 L_DMDMBTR   =  DMDMBTR -   DMDMBTR1.        " ����.
 L_SFRDMBTR  =  SFRDMBTR -  SFRDMBTR1.       "����.
 L_FFRDMBTR  =  FFRDMBTR -  FFRDMBTR1.    " ������.
 L_BDPDMBTR  =  BDPDMBTR -  BDPDMBTR1.    " ����
 L_EURDMBTR  =  EURDMBTR -  EURDMBTR1.    " ����
 L_ETCDMBTR  =  ETCDMBTR -  ETCDMBTR1.   " ��Ÿ.
 L_IMDMBTR   =  IMDMBTR  -  IMDMBTR1.  " ����������ȭ.
 L_LOKRW     =  LOKRW -     LOKRW1.
 L_LOUSD     =  LOUSD -     LOUSD1.

 FORMAT RESET.
 FORMAT COLOR COL_GROUP INTENSIFIED OFF.

 WRITE : / SY-VLINE NO-GAP,(20) '' NO-GAP,    " Plant'
            SY-VLINE NO-GAP,(12) '' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) L_USDDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ''NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) L_JPYDMBTR NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) L_DMDMBTR NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'������'
                    SY-VLINE NO-GAP,(06) L_SFRDMBTR    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) L_FFRDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) L_BDPDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) L_EURDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06) L_ETCDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) L_IMDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     SY-VLINE NO-GAP,(06) L_LOKRW    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ''NO-GAP, " $ Local '
                     SY-VLINE NO-GAP,(06) L_LOUSD  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
            SY-VLINE.

* HIDE : IT_TAB,W_TABIX.

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
*>> ȸ���ڵ�üũ.
     CLEAR EKKO.
     SELECT   SINGLE *
        FROM  EKKO
        WHERE EBELN  =  IT_ZTIVHST-EBELN
          AND BUKRS IN S_BUKRS
          AND BSTYP IN S_BSTYP
          AND BSART IN S_BSART
          AND EKORG IN  S_EKORG
          AND EKGRP IN  S_EKGRP.
     IF SY-SUBRC NE 0.
        DELETE IT_ZTIVHST INDEX W_TABIX.
        CONTINUE.
     ENDIF.

     IF IT_ZTIVHST-ZFREQTY = 'LO'.
        CLEAR EKBE.
        SELECT SINGLE *
          FROM EKBE
         WHERE EBELN  = IT_ZTIVHST-EBELN
           AND EBELP  = IT_ZTIVHST-EBELP
           AND WERKS   IN S_WERKS
           AND BLDAT   IN S_BLDAT.    " ������.
        IF SY-SUBRC NE 0.
           DELETE IT_ZTIVHST INDEX W_TABIX.
           CONTINUE.
        ENDIF.
        MOVE:  EKBE-MATNR  TO IT_ZTIVHST-MATNR,    " �����ȣ.
               EKBE-BELNR  TO IT_ZTIVHST-MBLNR,    " ���繮����ȣ.
               EKBE-GJAHR  TO IT_ZTIVHST-MJAHR,    " ���繮������.
               EKBE-BWART  TO IT_ZTIVHST-BWART,    " �̵�����.
               EKBE-WERKS  TO IT_ZTIVHST-WERKS.    " PLANT.
     ELSE.
*>> GET ZFREQNO.
        CLEAR ZTIVIT.
        SELECT   SINGLE *
           FROM  ZTIVIT
           WHERE ZFIVNO  = IT_ZTIVHST-ZFIVNO
             AND ZFIVDNO = IT_ZTIVHST-ZFIVDNO.
        IT_ZTIVHST-ZFREQNO = ZTIVIT-ZFREQNO.
     ENDIF.
*>> �����Ƿ� Ÿ�� PU ����.
     CLEAR ZTREQHD.
     SELECT   SINGLE *
        FROM  ZTREQHD
        WHERE ZFREQNO = IT_ZTIVHST-ZFREQNO.
     IF ZTREQHD-ZFREQTY EQ 'PU' .
        DELETE IT_ZTIVHST INDEX W_TABIX.
        CONTINUE.
     ENDIF.
*>> ����.������ȭ�ݾ�.
*>> ���Ź������̷�.
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
     CLEAR T156.
     SELECT SINGLE *
       FROM T156
      WHERE BWART = IT_ZTIVHST-BWART.
*>> �̵� ������ ���� ��/�뺯 ������.
     IT_ZTIVHST-DMBTR    =  EKBE-DMBTR / 1000000.
     IT_ZTIVHST-ZFLASTAM =  ZTREQHD-ZFLASTAM / 1000.
     IT_ZTIVHST-ZFUSDAM  =  ZTREQHD-ZFUSDAM / 1000.

     IF T156-SHKZG = 'H'.
        IT_ZTIVHST-DMBTR    =  ( EKBE-DMBTR  ) * -1.
        IT_ZTIVHST-ZFLASTAM =  ( ZTREQHD-ZFLASTAM ) * -1.
        IT_ZTIVHST-ZFUSDAM  =  ( ZTREQHD-ZFUSDAM ) * -1.
     ENDIF.

*>> ��ȭ����.
     IF ZTREQHD-ZFREQTY EQ 'LO'.
         CASE ZTREQHD-WAERS.
           WHEN 'KRW'.
              IT_ZTIVHST-LOKRW =  IT_ZTIVHST-DMBTR.   " ������ȭ�ݾ�
              IT_ZTIVHST-FLOKRW = IT_ZTIVHST-ZFUSDAM. " USD ȯ��ݾ�.
           WHEN OTHERS.
              IT_ZTIVHST-LOUSD = IT_ZTIVHST-DMBTR .
              IT_ZTIVHST-FLOUSD = IT_ZTIVHST-ZFUSDAM.
        ENDCASE.
     ELSE.
        IT_ZTIVHST-IMDMBTR = IT_ZTIVHST-DMBTR.    " ���԰�.
        CASE ZTREQHD-WAERS.
           WHEN 'USD'.
                IT_ZTIVHST-USDDMBTR = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FUSDDMBTR = IT_ZTIVHST-ZFLASTAM.  " �����ݾ�.
           WHEN 'JPY'.
                IT_ZTIVHST-JPYDMBTR = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FJPYDMBTR = IT_ZTIVHST-ZFLASTAM.
           WHEN 'DEM'.
                IT_ZTIVHST-DMDMBTR = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FJPYDMBTR = IT_ZTIVHST-ZFLASTAM.
           WHEN 'CHF'.
                 IT_ZTIVHST-SFRDMBTR  = IT_ZTIVHST-DMBTR.
                 IT_ZTIVHST-FJPYDMBTR = IT_ZTIVHST-ZFLASTAM.
           WHEN 'CFP'.
                IT_ZTIVHST-FFRDMBTR  = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FFFRDMBTR  = IT_ZTIVHST-ZFLASTAM.
           WHEN 'GBP'.
                IT_ZTIVHST-BDPDMBTR  = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FBDPDMBTR  = IT_ZTIVHST-ZFLASTAM.
           WHEN 'EUR'.
                IT_ZTIVHST-EURDMBTR   = IT_ZTIVHST-DMBTR.
                IT_ZTIVHST-FEURDMBTR  = IT_ZTIVHST-ZFLASTAM.
           WHEN OTHERS.
                IT_ZTIVHST-ETCDMBTR = IT_ZTIVHST-DMBTR.
       ENDCASE.
    ENDIF.

    MODIFY IT_ZTIVHST INDEX W_TABIX.
    MOVE-CORRESPONDING IT_ZTIVHST TO IT_TAB.
    MOVE-CORRESPONDING IT_ZTIVHST TO IT_CTOTAL.
    COLLECT IT_TAB.
    COLLECT IT_CTOTAL.
  ENDLOOP.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
      W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_CURRENCT_BLDAT
*&---------------------------------------------------------------------
*
*&      Form  P1000_OLDDAT_BLDAT
*&---------------------------------------------------------------------
*
FORM P1000_OLDDAT_BLDAT.

   LOOP AT IT_ZTIVHST1.

     W_TABIX = SY-TABIX.
*>> ȸ���ڵ�üũ.
     CLEAR EKKO.
     SELECT   SINGLE *
        FROM  EKKO
        WHERE EBELN  =  IT_ZTIVHST1-EBELN
          AND BUKRS IN S_BUKRS
          AND BSTYP IN S_BSTYP
          AND BSART IN S_BSART
          AND EKORG IN S_EKORG
          AND EKGRP IN S_EKGRP.

     IF SY-SUBRC NE 0.
        DELETE IT_ZTIVHST1 INDEX W_TABIX.
        CONTINUE.
     ENDIF.

     IF IT_ZTIVHST1-ZFREQTY = 'LO'.
        CLEAR EKBE.
        SELECT SINGLE *
          FROM EKBE
         WHERE EBELN  = IT_ZTIVHST1-EBELN
           AND EBELP  = IT_ZTIVHST1-EBELP
           AND WERKS   IN S_WERKS
           AND BLDAT   IN R_BLDAT.    " ������.
        IF SY-SUBRC NE 0.
           DELETE IT_ZTIVHST1 INDEX W_TABIX.
           CONTINUE.
        ENDIF.
        MOVE:  EKBE-MATNR  TO IT_ZTIVHST1-MATNR,    " �����ȣ.
               EKBE-BELNR  TO IT_ZTIVHST1-MBLNR,    " ���繮����ȣ.
               EKBE-GJAHR  TO IT_ZTIVHST1-MJAHR,    " ���繮������.
               EKBE-BWART  TO IT_ZTIVHST1-BWART,    " �̵�����.
               EKBE-WERKS  TO IT_ZTIVHST1-WERKS.    " PLANT.
     ELSE.
*>> GET ZFREQNO.
        CLEAR ZTIVIT.
        SELECT   SINGLE *
           FROM  ZTIVIT
           WHERE ZFIVNO  = IT_ZTIVHST1-ZFIVNO
             AND ZFIVDNO = IT_ZTIVHST1-ZFIVDNO.
        IT_ZTIVHST1-ZFREQNO = ZTIVIT-ZFREQNO.
     ENDIF.
*>> �����Ƿ� Ÿ�� PU ����.
     CLEAR ZTREQHD.
     SELECT   SINGLE *
        FROM  ZTREQHD
        WHERE ZFREQNO = IT_ZTIVHST1-ZFREQNO.
     IF ZTREQHD-ZFREQTY EQ 'PU' .
        DELETE IT_ZTIVHST1 INDEX W_TABIX.
        CONTINUE.
     ENDIF.
*>> ����.������ȭ�ݾ�.
     CLEAR EKBE.
     SELECT SINGLE *
       FROM EKBE
      WHERE EBELN  = IT_ZTIVHST1-EBELN
        AND EBELP  = IT_ZTIVHST1-EBELP
        AND MATNR  = IT_ZTIVHST1-MATNR    " �����ȣ.
        AND BELNR  = IT_ZTIVHST1-MBLNR    " ���繮����ȣ.
        AND GJAHR  = IT_ZTIVHST1-MJAHR    " ���繮������.
        AND BWART  = IT_ZTIVHST1-BWART    " �̵�����.
        AND BEWTP  = 'E'.                " �̷�����.
     IF SY-SUBRC NE 0.
        DELETE IT_ZTIVHST1 INDEX W_TABIX.
        CONTINUE.
     ENDIF.
     CLEAR T156.
     SELECT SINGLE *
       FROM T156
      WHERE BWART = IT_ZTIVHST1-BWART.
*>> �̵� ������ ���� ��/�뺯 ������.
     IT_ZTIVHST1-DMBTR    =  EKBE-DMBTR / 1000000.
     IT_ZTIVHST1-ZFLASTAM =  ZTREQHD-ZFLASTAM / 1000.
     IT_ZTIVHST1-ZFUSDAM  =  ZTREQHD-ZFUSDAM / 1000.

     IF T156-SHKZG = 'H'.
        IT_ZTIVHST1-DMBTR    =  ( EKBE-DMBTR  ) * -1.
        IT_ZTIVHST1-ZFLASTAM =  ( ZTREQHD-ZFLASTAM ) * -1.
        IT_ZTIVHST1-ZFUSDAM  =  ( ZTREQHD-ZFUSDAM ) * -1.
     ENDIF.

*>> ��ȭ����.
     IF ZTREQHD-ZFREQTY EQ 'LO'.
         CASE ZTREQHD-WAERS.
           WHEN 'KRW'.
              IT_ZTIVHST1-LOKRW =  IT_ZTIVHST1-DMBTR.   " ������ȭ�ݾ�
              IT_ZTIVHST1-FLOKRW = IT_ZTIVHST1-ZFUSDAM. " USD ȯ��ݾ�.
           WHEN OTHERS.
              IT_ZTIVHST1-LOUSD =  IT_ZTIVHST1-DMBTR .
              IT_ZTIVHST1-FLOUSD = IT_ZTIVHST1-ZFUSDAM.
        ENDCASE.
     ELSE.
        IT_ZTIVHST1-IMDMBTR = IT_ZTIVHST1-DMBTR.    " ���԰�.
        CASE ZTREQHD-WAERS.
           WHEN 'USD'.
              IT_ZTIVHST1-USDDMBTR = IT_ZTIVHST1-DMBTR.
              IT_ZTIVHST1-FUSDDMBTR = IT_ZTIVHST1-ZFLASTAM.  " �����ݾ�.
           WHEN 'JPY'.
              IT_ZTIVHST1-JPYDMBTR = IT_ZTIVHST1-DMBTR.
              IT_ZTIVHST1-FJPYDMBTR = IT_ZTIVHST1-ZFLASTAM.
           WHEN 'DEM'.
                IT_ZTIVHST1-DMDMBTR = IT_ZTIVHST1-DMBTR.
                IT_ZTIVHST1-FJPYDMBTR = IT_ZTIVHST1-ZFLASTAM.
           WHEN 'CHF'.
                 IT_ZTIVHST1-SFRDMBTR  = IT_ZTIVHST1-DMBTR.
                 IT_ZTIVHST1-FJPYDMBTR = IT_ZTIVHST1-ZFLASTAM.
           WHEN 'CFP'.
                IT_ZTIVHST1-FFRDMBTR  = IT_ZTIVHST1-DMBTR.
                IT_ZTIVHST1-FFFRDMBTR  = IT_ZTIVHST1-ZFLASTAM.
           WHEN 'GBP'.
                IT_ZTIVHST1-BDPDMBTR  = IT_ZTIVHST1-DMBTR.
                IT_ZTIVHST1-FBDPDMBTR  = IT_ZTIVHST1-ZFLASTAM.
           WHEN 'EUR'.
                IT_ZTIVHST1-EURDMBTR   = IT_ZTIVHST1-DMBTR.
                IT_ZTIVHST1-FEURDMBTR  = IT_ZTIVHST1-ZFLASTAM.
           WHEN OTHERS.
                IT_ZTIVHST1-ETCDMBTR = IT_ZTIVHST1-DMBTR.
       ENDCASE.
    ENDIF.
    MODIFY IT_ZTIVHST1 INDEX W_TABIX.
    MOVE-CORRESPONDING IT_ZTIVHST1 TO IT_TAB1.
    MOVE-CORRESPONDING IT_ZTIVHST1 TO IT_OTOTAL.
    COLLECT IT_TAB1.
    COLLECT IT_OTOTAL.
  ENDLOOP.

ENDFORM.                    " P1000_OLDDAT_BLDAT
*&---------------------------------------------------------------------
*&      Form  P3000_LINE_TOTAL
*&---------------------------------------------------------------------
FORM P3000_LINE_TOTAL.

*>> ��������.
 DATA : L_USDDMBTR   TYPE P  DECIMALS 2,           " �̱�.
        L_JPYDMBTR    TYPE P  DECIMALS 2,           " �Ϻ�.
        L_DMDMBTR     TYPE P  DECIMALS 2,           " ����.
        L_SFRDMBTR    TYPE P  DECIMALS 2,           " ������.
        L_FFRDMBTR    TYPE P  DECIMALS 2,           " ������.
        L_BDPDMBTR    TYPE P  DECIMALS 2,           " ����.
        L_EURDMBTR    TYPE P  DECIMALS 2,           " ����.
        L_ETCDMBTR    TYPE P  DECIMALS 2,           " ��Ÿ.
        L_IMDMBTR     TYPE P  DECIMALS 2,         " ����������ȭ.
        L_LOKRW       TYPE P  DECIMALS 2,
        L_LOUSD       TYPE P  DECIMALS 2.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED ON.

  READ TABLE IT_CTOTAL INDEX 1.

*>> ��� ��ȭ.
  WRITE : / SY-VLINE NO-GAP,(20) '�����(��ȭ��)' NO-GAP,    " Plant
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FUSDDMBTR
                     CURRENCY 'USD' NO-GAP," �̱�
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FJPYDMBTR
                     CURRENCY 'JPY' NO-GAP,"�Ϻ�
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FDMDMBTR
                     CURRENCY 'DEM' NO-GAP," ����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FSFRDMBTR
                     CURRENCY 'CHF' NO-GAP,"'������
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FFFRDMBTR
                     CURRENCY 'CFP' NO-GAP,"'������
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FBDPDMBTR
                     CURRENCY 'GBP' NO-GAP,"'����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FEURDMBTR
                     CURRENCY 'EUR' NO-GAP,"'����
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     " CURRENCY 'USD' NO-GAP,"��Ÿ
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FLOKRW
                       CURRENCY 'USD' NO-GAP,
                       SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FLOUSD
                     CURRENCY 'USD' NO-GAP, " $ Local
                       SY-VLINE NO-GAP,(06) ''      NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
            SY-VLINE.
*>> ��� ������ȭ.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
*>> ���� ��⵵����.
  CLEAR: USDDMBTR2,JPYDMBTR2,DMDMBTR2,SFRDMBTR2,FFRDMBTR2,BDPDMBTR2,
         ETCDMBTR2,IMDMBTR2,LOKRW2,LOUSD2.
  IF NOT IT_CTOTAL-DMBTR IS INITIAL.
    USDDMBTR2  =  IT_CTOTAL-USDDMBTR / IT_CTOTAL-DMBTR * 100.  " �̱�.
    JPYDMBTR2  =  IT_CTOTAL-JPYDMBTR / IT_CTOTAL-DMBTR * 100.  " �Ϻ�.
    DMDMBTR2   =  IT_CTOTAL-DMDMBTR  / IT_CTOTAL-DMBTR * 100.  " ����.
    SFRDMBTR2  =  IT_CTOTAL-SFRDMBTR / IT_CTOTAL-DMBTR * 100.  " ������.
    FFRDMBTR2  =  IT_CTOTAL-FFRDMBTR / IT_CTOTAL-DMBTR * 100.  " ������.
    BDPDMBTR2  =  IT_CTOTAL-BDPDMBTR / IT_CTOTAL-DMBTR * 100.  " ����.
    EURDMBTR2  =  IT_CTOTAL-EURDMBTR / IT_CTOTAL-DMBTR * 100.  " ����.
    ETCDMBTR2  =  IT_CTOTAL-ETCDMBTR / IT_CTOTAL-DMBTR * 100.   " ��Ÿ.
    IMDMBTR2   =  IT_CTOTAL-IMDMBTR  / IT_CTOTAL-DMBTR * 100. "������ȭ.
    LOKRW2     =  IT_CTOTAL-LOKRW    / IT_CTOTAL-DMBTR * 100.
    LOUSD2     =  IT_CTOTAL-LOUSD    / IT_CTOTAL-DMBTR * 100.
  ENDIF.

  WRITE : / SY-VLINE NO-GAP,(20) '������(��ȭ)' NO-GAP," Plant'
            SY-VLINE NO-GAP,(12) IT_CTOTAL-USDDMBTR
                     CURRENCY 'KRW' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) USDDMBTR2  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-JPYDMBTR
                     CURRENCY 'KRW' NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) JPYDMBTR2   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-DMDMBTR
                     CURRENCY 'KRW' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) DMDMBTR2   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-SFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) SFRDMBTR2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-FFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) FFRDMBTR2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-BDPDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) BDPDMBTR2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-EURDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) EURDMBTR2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-ETCDMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06) ETCDMBTR2  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-IMDMBTR
                     CURRENCY 'KRW' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) IMDMBTR2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-LOKRW
                     CURRENCY 'KRW' NO-GAP,
                     SY-VLINE NO-GAP,(06) LOKRW2 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-LOUSD
                     CURRENCY 'KRW' NO-GAP, " $ Local
                     SY-VLINE NO-GAP,(06)LOUSD2  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_CTOTAL-DMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ż'
            SY-VLINE.

  FORMAT RESET.
  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

  READ TABLE IT_OTOTAL INDEX 1.
*>> ���� ���⵵����.
  CLEAR: USDDMBTR3,JPYDMBTR3,DMDMBTR3,SFRDMBTR3,FFRDMBTR3,BDPDMBTR3,
         ETCDMBTR3,IMDMBTR3,LOKRW3,LOUSD3.
  IF NOT IT_OTOTAL-DMBTR IS INITIAL.
    USDDMBTR3  =  IT_OTOTAL-USDDMBTR / IT_OTOTAL-DMBTR * 100.  " �̱�.
    JPYDMBTR3  =  IT_OTOTAL-JPYDMBTR / IT_OTOTAL-DMBTR * 100.  " �Ϻ�.
    DMDMBTR3   =  IT_OTOTAL-DMDMBTR  / IT_OTOTAL-DMBTR * 100.  " ����.
    SFRDMBTR3  =  IT_OTOTAL-SFRDMBTR / IT_OTOTAL-DMBTR * 100.  " ������.
    FFRDMBTR3  =  IT_OTOTAL-FFRDMBTR / IT_OTOTAL-DMBTR * 100.  " ������.
    BDPDMBTR3  =  IT_OTOTAL-BDPDMBTR / IT_OTOTAL-DMBTR * 100.  " ����.
    EURDMBTR3  =  IT_OTOTAL-EURDMBTR / IT_OTOTAL-DMBTR * 100.   " ����.
    ETCDMBTR3  =  IT_OTOTAL-ETCDMBTR / IT_OTOTAL-DMBTR * 100.   " ��Ÿ.
    IMDMBTR3   =  IT_OTOTAL-IMDMBTR  / IT_OTOTAL-DMBTR * 100. "������ȭ.
    LOKRW3     =  IT_OTOTAL-LOKRW    / IT_OTOTAL-DMBTR * 100.
    LOUSD3     =  IT_OTOTAL-LOUSD    / IT_OTOTAL-DMBTR * 100.
  ENDIF.

  WRITE : / SY-VLINE NO-GAP,(20) '��������(��ȭ)' NO-GAP,    " Plant'
            SY-VLINE NO-GAP,(12) IT_OTOTAL-USDDMBTR
                     CURRENCY 'KRW' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) USDDMBTR3 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-JPYDMBTR
                     CURRENCY 'KRW' NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) JPYDMBTR3 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-DMDMBTR
                     CURRENCY 'KRW' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) DMDMBTR3 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-SFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) SFRDMBTR3 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-FFRDMBTR
                     CURRENCY 'KRW' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) FFRDMBTR3 NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-BDPDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) BDPDMBTR3  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-EURDMBTR
                     CURRENCY 'KRW' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) EURDMBTR3  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-ETCDMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06) ETCDMBTR3  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-IMDMBTR
                     CURRENCY 'KRW' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) IMDMBTR3    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-LOKRW
                     CURRENCY 'KRW' NO-GAP,
                     SY-VLINE NO-GAP,(06) LOKRW3   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-LOUSD
                     CURRENCY 'KRW' NO-GAP, " $ Local '
                     SY-VLINE NO-GAP,(06) LOUSD3  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) IT_OTOTAL-DMBTR
                     CURRENCY 'KRW' NO-GAP,"��Ż'
            SY-VLINE.
 L_USDDMBTR  =  USDDMBTR2 -  USDDMBTR3.           " �̱�.
 L_JPYDMBTR  =  JPYDMBTR2 -  JPYDMBTR3.       " �Ϻ�.
 L_DMDMBTR   =  DMDMBTR2 -   DMDMBTR3.        " ����.
 L_SFRDMBTR  =  SFRDMBTR2 -  SFRDMBTR3.       "����.
 L_FFRDMBTR  =  FFRDMBTR2 -  FFRDMBTR3.    " ������.
 L_BDPDMBTR  =  BDPDMBTR2 -  BDPDMBTR3.    " ����
 L_EURDMBTR  =  EURDMBTR2 -  EURDMBTR3.    " ����.
 L_ETCDMBTR  =  ETCDMBTR2 -  ETCDMBTR3.   " ��Ÿ.
 L_IMDMBTR   =  IMDMBTR2  -  IMDMBTR3.  " ����������ȭ.
 L_LOKRW     =  LOKRW2 -     LOKRW3.
 L_LOUSD     =  LOUSD2 -     LOUSD3.

 FORMAT RESET.
 FORMAT COLOR COL_GROUP INTENSIFIED OFF.
*>> ��⵵ /���⵵ ��������.
 WRITE : / SY-VLINE NO-GAP,(20) ' 'NO-GAP, " Plant'
            SY-VLINE NO-GAP,(12) '' NO-GAP," �̱�'
                     SY-VLINE NO-GAP,(06) L_USDDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ''NO-GAP,"�Ϻ�'
                     SY-VLINE NO-GAP,(06) L_JPYDMBTR NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP," ����'
                     SY-VLINE NO-GAP,(06) L_DMDMBTR NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'������'
                    SY-VLINE NO-GAP,(06) L_SFRDMBTR    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'������'
                     SY-VLINE NO-GAP,(06) L_FFRDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) L_BDPDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"'����'
                     SY-VLINE NO-GAP,(06) L_EURDMBTR  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,"��Ÿ'
                     SY-VLINE NO-GAP,(06) L_ETCDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP, " ���԰�.
                     SY-VLINE NO-GAP,(06) L_IMDMBTR   NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
                     SY-VLINE NO-GAP,(06) L_LOKRW    NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) ''NO-GAP, " $ Local '
                     SY-VLINE NO-GAP,(06) L_LOUSD  NO-GAP CENTERED,
            SY-VLINE NO-GAP,(12) '' NO-GAP,
            SY-VLINE.

   WRITE:/ SY-ULINE.

ENDFORM.                    " P3000_LINE_TOTAL
