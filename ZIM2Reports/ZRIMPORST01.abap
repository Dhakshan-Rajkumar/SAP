*&---------------------------------------------------------------------*
*& Report  ZRIMPORST01                                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  ���α׷��� :[Report] ���Ž��� ��Ȳǥ(��ȭ��)                       *
*&      �ۼ��� : �̽���                                                *
*&      �ۼ��� : 2001.09.22                                            *
*&---------------------------------------------------------------------*
*&  DESC.      :  �����Ⱓ ���Ž����� ��ȭ�� ��ȸ,�� ��ȭ�� ���Ž�����
*&                �����ϴ� ������ LIST�� ������.
*&---------------------------------------------------------------------*
*& [���泻��]
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*


REPORT  ZRIMPORST01  MESSAGE-ID ZIM
                     LINE-SIZE 150
                     NO STANDARD PAGE HEADING.

TABLES : EKBE,                     "���Ź����� �̷�
         EKKO,                     "���Ź������
         ZTREQHD,                  "�����Ƿ� �ش�.
         ZTREQIT,                  "�����Ƿ� ITEM.
         T001W.                    "����θ�.

*>>> ���� DEFINE.
DATA   : SI_LINE TYPE I VALUE 150,
         W_ERR_CHK TYPE C VALUE 'N',   "ERROR CHECK.
         W_LINE  TYPE I,               "IT_TAB LINE ��.
         W_SUM   LIKE ZTREQHD-ZFLASTAM, "��ȭ �Ұ��.
         W_TOTAL LIKE ZTREQHD-ZFLASTAM, "��ȭ �Ѱ��.
         W_WERKS LIKE EKPO-WERKS,     "�����.
         W_MOD LIKE SY-TABIX,        "Ȧ¦.
         W_TABIX LIKE SY-TABIX.

DATA : BEGIN OF IT_TAB OCCURS 0,

      EBELN   LIKE EKBE-EBELN,    "10���Ź�����ȣ
      EBELP   LIKE EKBE-EBELP,     "NUMC5���Ź��� ǰ���ȣ
      BUDAT   LIKE EKBE-BUDAT,     "DATS8��ǥ������(�Ⱓ)
      DMBTR   LIKE EKBE-DMBTR,     "CURR13.2������ȭ�ݾ�(��ȭ)
      WRBTR   LIKE EKBE-WRBTR,     "CURR13.2��ǥ��ȭ�ݾ�(��ȭ)
      WAERS   LIKE EKBE-WAERS,     "CUKY5��ȭŰ
      WERKS   LIKE EKBE-WERKS,     "4�÷�Ʈ(�����)
      BUKRS   LIKE EKKO-BUKRS,     "4ȸ���ڵ�
      BSTYP   LIKE EKKO-BSTYP,     "1���Ź�������
      BSART   LIKE EKKO-BSART,     "4���Ź�������
      ZFREQNO LIKE ZTREQIT-ZFREQNO,"10�����Ƿ� ������ȣ
      ZFITMNO LIKE ZTREQIT-ZFITMNO,"NUMC5���Թ��� ǰ���ȣ

      ZFREQTY LIKE ZTREQHD-ZFREQTY."2�����Ƿ� Type(��������)

DATA : END OF IT_TAB.

DATA : BEGIN OF IT_TEMP1 OCCURS 0,

      EBELN   LIKE EKBE-EBELN,     "10���Ź�����ȣ
      EBELP   LIKE EKBE-EBELP,     "NUMC5���Ź��� ǰ���ȣ
      BUDAT   LIKE EKBE-BUDAT,     "DATS8��ǥ������(�Ⱓ)
      DMBTR   LIKE EKBE-DMBTR,     "CURR13.2������ȭ�ݾ�(��ȭ)
      WRBTR   LIKE EKBE-WRBTR,     "CURR13.2��ǥ��ȭ�ݾ�(��ȭ)
      WAERS   LIKE EKBE-WAERS,     "CUKY5��ȭŰ
      WERKS   LIKE EKBE-WERKS,     "4�÷�Ʈ(�����)
      BUKRS   LIKE EKKO-BUKRS,     "4ȸ���ڵ�
      BSTYP   LIKE EKKO-BSTYP,     "1���Ź�������
      BSART   LIKE EKKO-BSART.     "4���Ź�������
*      ZFREQNO LIKE ZTREQIT-ZFREQNO,"10�����Ƿ� ������ȣ
*      ZFITMNO LIKE ZTREQIT-ZFITMNO,"NUMC5���Թ��� ǰ���ȣ
*      ZFREQNO LIKE ZTREQHD-ZFREQNO,"10�����Ƿ� ������ȣ
*      ZFREQTY LIKE ZTREQHD-ZEREQTY,"2�����Ƿ� Type(��������)

DATA : END OF IT_TEMP1.

DATA : BEGIN OF IT_TEMP2 OCCURS 0,

      EBELN   LIKE EKBE-EBELN,    "10���Ź�����ȣ
      EBELP   LIKE EKBE-EBELP,     "NUMC5���Ź��� ǰ���ȣ
      BUDAT   LIKE EKBE-BUDAT,     "DATS8��ǥ������(�Ⱓ)
      DMBTR   LIKE EKBE-DMBTR,     "CURR13.2������ȭ�ݾ�(��ȭ)
      WRBTR   LIKE EKBE-WRBTR,     "CURR13.2��ǥ��ȭ�ݾ�(��ȭ)
      WAERS   LIKE EKBE-WAERS,     "CUKY5��ȭŰ
      WERKS   LIKE EKBE-WERKS,     "4�÷�Ʈ(�����)
      BUKRS   LIKE EKKO-BUKRS,     "4ȸ���ڵ�
      BSTYP   LIKE EKKO-BSTYP,     "1���Ź�������
      BSART   LIKE EKKO-BSART,     "4���Ź�������
      ZFREQNO LIKE ZTREQIT-ZFREQNO,"10�����Ƿ� ������ȣ
      ZFITMNO LIKE ZTREQIT-ZFITMNO."NUMC5���Թ��� ǰ���ȣ
*      ZFREQNO LIKE ZTREQHD-ZFREQNO,"10�����Ƿ� ������ȣ
*      ZFREQTY LIKE ZTREQHD-ZEREQTY,"2�����Ƿ� Type(��������)

DATA : END OF IT_TEMP2.

DATA : BEGIN OF IT_COL OCCURS 0,

      DMBTR   LIKE EKBE-DMBTR,     "CURR13.2������ȭ�ݾ�(��ȭ)
      WRBTR   LIKE EKBE-WRBTR,     "CURR13.2��ǥ��ȭ�ݾ�(��ȭ)
      WAERS   LIKE EKBE-WAERS,     "CUKY5��ȭŰ
      WERKS   LIKE EKBE-WERKS,     "4�÷�Ʈ(�����)
      BUKRS   LIKE EKKO-BUKRS.     "4ȸ���ڵ�

DATA : END OF IT_COL.

DATA : BEGIN OF IT_MAIN OCCURS 0,
**>>"4�÷�Ʈ(�����)-->COL���� �̸� ������
      WERKS   LIKE EKBE-WERKS,
      USD TYPE P DECIMALS 2,
      JPY TYPE P DECIMALS 2,
      DEM TYPE P DECIMALS 2,
      CHF TYPE P DECIMALS 2,
      CFP TYPE P DECIMALS 2,
      GBP TYPE P DECIMALS 2,
*>>OTHER:���ʿ�.�� �̰����� ��ȭ������ ���� W_OTHER�� �Է¿�.
      W_USD TYPE P DECIMALS 2,
      W_JPY TYPE P DECIMALS 2,
      W_DEM TYPE P DECIMALS 2,
      W_CHF TYPE P DECIMALS 2,
      W_CFP TYPE P DECIMALS 2,
      W_GBP TYPE P DECIMALS 2,
      W_OTHER TYPE P DECIMALS 2,
*>>W_TOTAL:W_�� �Ǿ��ִ� ������ ��.
      W_TOTAL TYPE P DECIMALS 2.
*>> %�� WRITE�ÿ� W_### / W_TOTAL * 100���� ���.
DATA : END OF IT_MAIN.

*----------------------------------------------------------------------*
*          SELECTION-SCREEN                                            *
*----------------------------------------------------------------------*

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS:
      S_BUKRS   FOR  EKKO-BUKRS NO-EXTENSION NO INTERVALS OBLIGATORY,
                                     "4ȸ���ڵ�
      S_BUDAT   FOR  EKBE-BUDAT,     "DATS8��ǥ������(�Ⱓ)
      S_BSTYP   FOR  EKKO-BSTYP,     "1���Ź�������
      S_BSART   FOR  EKKO-BSART.     "4���Ź�������

SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------*
*          INITIALIZATION.                                             *
*----------------------------------------------------------------------*

INITIALIZATION.                          " �ʱⰪ SETTING
  SET TITLEBAR 'ZIMR72'.
  CLEAR : IT_TEMP1, IT_TEMP2, IT_TAB, IT_COL, IT_MAIN.
  REFRESH : IT_TEMP1, IT_TEMP2, IT_TAB, IT_COL, IT_MAIN.

*----------------------------------------------------------------------*
*          START-OF-SELECTION.                                         *
*----------------------------------------------------------------------*
START-OF-SELECTION.

***> READ TABLE
**>JOIN���� EKBE�� EKKO�� MAKE.
  PERFORM   P1000_READ_TEMP1.
**>ZTREQIT���� ZFREQNO�߰�.
  PERFORM   P1000_READ_TEMP2.
**>ZTREQHD���� �����Ƿ� TYPE LO,PU SKIP.
  PERFORM   P1000_READ_TAB.
**>WERKS,WAERS�������� COLLECT.
  PERFORM   P1000_READ_COL.
**>��� �������� TABLE ����.-->������ MAIN�� WERKS�� ���� ������
**                             MAIN TAB�� LOOP �ϸ鼭 COL TAB��
**                             WERKS KEY�� ���ϸ鼭 READ TABLE.
**                             CASE ������ MOVE MAIN.
  PERFORM   P1000_READ_MAIN.

*>>> SORT-GROUP:WERKS EBERN TXZ01 MENGE.
  SORT IT_TAB BY WERKS.

*>>> WRITE LIST
  PERFORM   P3000_WRITE_IT.

*----------------------------------------------------------------------*
*           TOP-OF-PAGE                                                *
*----------------------------------------------------------------------*
TOP-OF-PAGE.
  FORMAT RESET.
  WRITE : /50 '[  ���Ž��� ��Ȳǥ(��ȭ��)  ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE :/75 '�Ⱓ : '.
  IF NOT S_BUDAT IS INITIAL.
    WRITE : S_BUDAT-LOW ,' ~ ', S_BUDAT-HIGH.
  ENDIF.
  SKIP.
  FORMAT COLOR 1 INTENSIFIED ON.
    WRITE :/ SY-ULINE(SI_LINE).
    WRITE :/
             SY-VLINE NO-GAP, (10) '�����'  NO-GAP,
             SY-VLINE NO-GAP, (10) 'USD'  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) 'JPY'  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) 'DEM'  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) 'CHF'  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) 'CFP'  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) 'GBP'  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) '��Ÿ' NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (17) ''     NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
    FORMAT COLOR 1 INTENSIFIED OFF.
    WRITE :/
             SY-VLINE NO-GAP, (10) ''      NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (6)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (5)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (5)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (5)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (5)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (5)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (10) '��ȭ'  NO-GAP,
             SY-VLINE NO-GAP, (6)  '%'    NO-GAP,
             SY-VLINE NO-GAP, (17) '���԰�'  NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
    WRITE :/ SY-ULINE(SI_LINE).


*----------------------------------------------------------------------*
*           AT USER-COMMAND                                            *
*----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEMP1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_TEMP1.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TEMP1
           FROM EKKO AS O JOIN EKBE AS B
           ON O~EBELN EQ B~EBELN
           WHERE      B~BUDAT IN S_BUDAT
             AND      O~BUKRS IN S_BUKRS
             AND      O~BSTYP IN S_BSTYP
             AND      O~BSART IN S_BSART.
  IF SY-SUBRC NE 0.  MESSAGE S738. EXIT. ENDIF.

ENDFORM.                    " P1000_READ_TEMP1
*
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEMP2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_TEMP2.

  LOOP AT IT_TEMP1.
     SELECT * FROM ZTREQIT
         INTO CORRESPONDING FIELDS OF IT_TEMP2
*         FOR ALL ENTRIES IN IT_TEMP1
         WHERE EBELN EQ IT_TEMP1-EBELN
           AND EBELP EQ IT_TEMP1-EBELP.
     MOVE-CORRESPONDING IT_TEMP1 TO IT_TEMP2.
     APPEND IT_TEMP2.
     ENDSELECT.
   ENDLOOP.
  IF SY-SUBRC NE 0.  MESSAGE S738. EXIT. ENDIF.

ENDFORM.                    " P1000_READ_TEMP2
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_TAB.

  LOOP AT IT_TEMP2.
     SELECT * FROM ZTREQHD
         INTO CORRESPONDING FIELDS OF IT_TAB
*         FOR ALL ENTRIES IN IT_TEMP2
         WHERE ZFREQNO EQ IT_TEMP2-ZFREQNO
           AND ZFREQTY NE 'PU'
           AND ZFREQTY NE 'LO'.
      MOVE-CORRESPONDING IT_TEMP2 TO IT_TAB.
      APPEND IT_TAB.
      ENDSELECT.
  ENDLOOP.
  IF SY-SUBRC NE 0.  MESSAGE S738. EXIT. ENDIF.

ENDFORM.                    " P1000_READ_TAB
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_COL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_COL.

  LOOP AT IT_TAB.
    MOVE-CORRESPONDING IT_TAB TO IT_COL.
    COLLECT IT_COL.
  ENDLOOP.

ENDFORM.                    " P1000_READ_COL
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_MAIN.
  SORT IT_COL BY WERKS.
*>>  WERKS�� �ٸ� ���� COL���� �̾Ƽ� MAIN�� �ִ´�.
  LOOP AT IT_COL.

      ON CHANGE OF IT_COL-WERKS.
      MOVE IT_COL-WERKS TO IT_MAIN-WERKS.
      APPEND IT_MAIN.
      ENDON.

  ENDLOOP.
*>>  COL�� ���� ���¸� PRINT�� �� �ֵ��� MAIN�� ���·� ��ȯ�Ѵ�.
  LOOP AT IT_MAIN.
    W_TABIX = SY-TABIX.
    READ TABLE IT_COL WITH KEY WERKS = IT_MAIN-WERKS.

    CASE IT_COL-WAERS.
       WHEN 'USD'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_USD.
         MOVE IT_COL-WRBTR TO IT_MAIN-USD.

       WHEN 'JPY'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_JPY.
         MOVE IT_COL-WRBTR TO IT_MAIN-JPY.

       WHEN 'DEM'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_DEM.
         MOVE IT_COL-WRBTR TO IT_MAIN-DEM.

       WHEN 'CHF'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_CHF.
         MOVE IT_COL-WRBTR TO IT_MAIN-CHF.

       WHEN 'CFP'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_CFP.
         MOVE IT_COL-WRBTR TO IT_MAIN-CFP.

       WHEN 'GBP'.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_GBP.
         MOVE IT_COL-WRBTR TO IT_MAIN-GBP.

       WHEN OTHERS.
         MOVE IT_COL-DMBTR TO IT_MAIN-W_OTHER.

    ENDCASE.
    IT_MAIN-W_TOTAL = IT_MAIN-W_USD + IT_MAIN-W_JPY + IT_MAIN-W_DEM +
                IT_MAIN-W_CHF + IT_MAIN-W_CFP + IT_MAIN-W_GBP +
                                               IT_MAIN-W_OTHER .
    MODIFY IT_MAIN INDEX W_TABIX.
  ENDLOOP.


ENDFORM.                    " P1000_READ_MAIN
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_IT.
  DATA : L_USD LIKE IT_MAIN-USD,
         L_JPY LIKE IT_MAIN-JPY,
         L_DEM LIKE IT_MAIN-DEM,
         L_CHF LIKE IT_MAIN-CHF,
         L_CFP LIKE IT_MAIN-CFP,
         L_GBP LIKE IT_MAIN-GBP,
         L_OTHER LIKE IT_MAIN-W_OTHER.
  SET TITLEBAR 'ZIMR72'.
*  SET PF-STATUS 'ZIMR72'.
  LOOP AT IT_MAIN.
    W_TABIX = SY-TABIX.
    FORMAT RESET.
**>����θ� �������
    PERFORM P1000_GET_NAME.

    FORMAT COLOR 2 INTENSIFIED ON.
*    WRITE :/ SY-ULINE(SI_LINE).
    WRITE :/
             SY-VLINE NO-GAP, (10) IT_MAIN-WERKS  NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-USD  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-JPY NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-DEM  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-CHF  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-CFP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-GBP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) ''  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (17) ''  NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
    FORMAT COLOR 2 INTENSIFIED OFF.
*>> %
    L_USD = IT_MAIN-W_USD / IT_MAIN-W_TOTAL * 100.
    L_JPY = IT_MAIN-W_JPY / IT_MAIN-W_TOTAL * 100.
    L_DEM = IT_MAIN-W_DEM / IT_MAIN-W_TOTAL * 100.
    L_CHF = IT_MAIN-W_CHF / IT_MAIN-W_TOTAL * 100.
    L_CFP = IT_MAIN-W_CFP / IT_MAIN-W_TOTAL * 100.
    L_GBP = IT_MAIN-W_GBP / IT_MAIN-W_TOTAL * 100.
    L_OTHER = IT_MAIN-W_OTHER / IT_MAIN-W_TOTAL * 100.
    WRITE :/
             SY-VLINE NO-GAP, (10) T001W-NAME1    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_USD  NO-GAP,
             SY-VLINE NO-GAP, (6)  L_USD            NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_JPY  NO-GAP,
             SY-VLINE NO-GAP, (5)  L_JPY   NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_DEM  NO-GAP,
             SY-VLINE NO-GAP, (5)  L_DEM    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_CHF  NO-GAP,
             SY-VLINE NO-GAP, (5)  L_CHF     NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_CFP  NO-GAP,
             SY-VLINE NO-GAP, (5)  L_CFP    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_GBP  NO-GAP,
             SY-VLINE NO-GAP, (5)  L_GBP    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_OTHER  NO-GAP,
             SY-VLINE NO-GAP, (6)  L_OTHER    NO-GAP,
             SY-VLINE NO-GAP, (17) IT_MAIN-W_TOTAL  NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
    WRITE :/ SY-ULINE(SI_LINE).
    AT LAST.
      SUM.

      FORMAT RESET.
      FORMAT COLOR 3 INTENSIFIED ON.
*      WRITE :/ SY-ULINE(SI_LINE).
      WRITE :/
             SY-VLINE NO-GAP, (10) '��ȭ�Ѱ�'  NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-USD  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-JPY NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-DEM  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-CHF  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-CFP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-GBP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) ''  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (17) ''  NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
      FORMAT COLOR 3 INTENSIFIED OFF.
      WRITE :/
             SY-VLINE NO-GAP, (10) '��ȭ�Ѱ�'  NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_USD  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_JPY NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_DEM  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_CHF  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_CFP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_GBP  NO-GAP,
             SY-VLINE NO-GAP, (5)  ''    NO-GAP,
             SY-VLINE NO-GAP, (10) IT_MAIN-W_OTHER  NO-GAP,
             SY-VLINE NO-GAP, (6)  ''    NO-GAP,
             SY-VLINE NO-GAP, (17) IT_MAIN-W_TOTAL  NO-GAP,
             AT SI_LINE SY-VLINE NO-GAP.
      WRITE :/ SY-ULINE(SI_LINE).
      FORMAT RESET.
    ENDAT.
  ENDLOOP.

ENDFORM.                    " P3000_WRITE_IT
*&---------------------------------------------------------------------*
*&      Form  P1000_GET_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_GET_NAME.

SELECT SINGLE * FROM T001W
      WHERE WERKS = IT_MAIN-WERKS.

ENDFORM.                    " P1000_GET_NAME
