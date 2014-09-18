*&---------------------------------------------------------------------*
*& Report  ZRIMSKLOCRCT
*&---------------------------------------------------------------------*
*&  ���α׷��� : �����ſ��� ��ǰ���� ����(�μ���)                    *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.15                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : �μ����� ������ �ϱ����� ����Ʈ ���.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*


REPORT  ZRIMSKLOCRCT MESSAGE-ID ZIM
                     LINE-SIZE 120
                     NO STANDARD PAGE HEADING.

TABLES: ZTRED, ZTREDSG1,ZVREQHD_ST,ZTREQIT.
*-----------------------------------------------------------------------
* ��ǰ���� ���� INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFREQNO  LIKE    ZTREQIT-ZFREQNO,   "�����Ƿ� ������ȣ.
       STAWN    LIKE    ZTREQIT-STAWN,     "HS CODE.
       ZFOPNDT  LIKE    ZVREQHD_ST-ZFOPNDT,"������.
       ZFREDNO  LIKE    ZTRED-ZFREDNO,     "�μ���������ȣ.
       ZFISNO   LIKE    ZTRED-ZFISNO,      "�μ��� �߱޹�ȣ.
       EBELN    LIKE    ZTRED-EBELN,       "P/O ��ȣ.
       ZFREVDT  LIKE    ZTRED-ZFREVDT,     "�μ���.
       ZFISUDT  LIKE    ZTRED-ZFISUDT,     "�߱���.
       ZFREXDT  LIKE    ZTRED-ZFREXDT,     "�μ��� ��ȿ����.
       ZFSCONM  LIKE    ZTRED-ZFSCONM,     "������ ��ȣ.
       ZFRCONM  LIKE    ZTRED-ZFRCONM,     "������ ��ȣ.
       ZFGDDT   LIKE    ZTRED-ZFGDDT,      "��ǰ�ε�����.
       ZFEXDT   LIKE    ZTRED-ZFEXDT,      "��ȿ����"
       ZFTXN4   LIKE    ZTRED-ZFTXN4,      "������ ����ڵ�� ��ȣ.
       ZFRCHNM  LIKE    ZTRED-ZFRCHNM,     "������ ��ǥ�ڸ�.
       ZFREAMF  LIKE    ZTRED-ZFREAMF,     "�μ��ݾ� ��ȭ.
       ZFREAMFC LIKE    ZTRED-ZFREAMFC,    "�μ��ݾ� ��ȭ ��ȭ.
       ZFREAMK  LIKE    ZTRED-ZFREAMK,     "�μ��ݾ� ��ȭ.
       ZFKRW    LIKE    ZTRED-ZFKRW,       "��ȭ ��ȭ.
       ZFTOTAM  LIKE    ZTRED-ZFTOTAM,     "�ѱݾ�.
       ZFTOTAMC LIKE    ZTRED-ZFTOTAMC,    "  ��ȭ.
       ZFETCD1  LIKE    ZTRED-ZFETCD1,     "��Ÿ����.
       ZFLLCON  LIKE    ZTRED-ZFLLCON,     "LOCAL LC NO
       ZFOBNEID LIKE    ZTRED-ZFOBNEID,    "�������� BANK KEY
       ZFOBNM   LIKE    ZTRED-ZFOBNM,      "�������� �ĺ���.
       ZFOBBR   LIKE    ZTRED-ZFOBBR,      "�������� ������.
       ZFOPAMF  LIKE    ZTRED-ZFOPAMF,     "�����ݾ� ��ȭ.
       ZFOPAMFC LIKE    ZTRED-ZFOPAMFC,    "�������� ��ȭ.
       ZFREMK1  LIKE    ZTRED-ZFREMK1,     "��������.
       ZFREMK2  LIKE    ZTRED-ZFREMK2,     "��������.
       ZFREMK3  LIKE    ZTRED-ZFREMK3,     "��������.
       ZFREMK4  LIKE    ZTRED-ZFREMK4,     "��������.
       ZFREMK5  LIKE    ZTRED-ZFREMK5,     "��������.
       ZFDOCNO  LIKE    ZTRED-ZFDOCNO,     "���ڹ��� ��ȣ.
       MAKTX    LIKE    ZTREDSG1-MAKTX,    "ǰ��.
       ZFLSG1   LIKE    ZTREDSG1-ZFLSG1,   "����.
       ZFGOSD1  LIKE    ZTREDSG1-ZFGOSD1,  "�԰�.
       ZFQUN    LIKE    ZTREDSG1-ZFQUN,    "����.
       ZFQUNM   LIKE    ZTREDSG1-ZFQUNM,   "�����ܰ�.
       NETPR    LIKE    ZTREDSG1-NETPR,    "�ܰ�.
       ZFNETPRC LIKE    ZTREDSG1-ZFNETPRC, "�ܰ� ��ȭ.
       ZFREAM   LIKE    ZTREDSG1-ZFREAM,   "�μ��ݾ�.
       ZFREAMC  LIKE    ZTREDSG1-ZFREAMC.  "�μ��ݾ� ��ȭ.
DATA : END OF IT_TAB.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       LINE(3)           TYPE N,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME," �ʵ��.
       W_SUBRC           LIKE SY-UCOMM,
       W_TABIX           LIKE SY-TABIX.    " TABLE INDEX



*-----------------------------------------------------------------------
* Selection Screen
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 2.  " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
      PARAMETERS : P_REDNO  LIKE ZTRED-ZFREDNO
                   MEMORY ID  ZPREDNO.
SELECTION-SCREEN END OF BLOCK B1.

   INITIALIZATION.                    " �ʱⰪ SETTING
   SET  TITLEBAR 'ZRIML'.          " TITLE BAR


*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

*  ���̺� SELECT
   PERFORM   P1000_READ_DATA.
   IF SY-SUBRC NE 0.               " Not Found?
     MESSAGE S738.    EXIT.
   ENDIF.
* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_DATA.
** ZTRED
  REFRESH IT_TAB.
  SELECT *  FROM ZTRED
            WHERE   ZFREDNO = P_REDNO.
    MOVE-CORRESPONDING ZTRED TO IT_TAB.
    APPEND IT_TAB.
    CLEAR IT_TAB.
  ENDSELECT.

  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.
**>> ZTRED
    SELECT SINGLE * FROM ZTREDSG1
                   WHERE ZFREDNO = IT_TAB-ZFREDNO .
    IF SY-SUBRC EQ 0.
      MOVE:   ZTREDSG1-MAKTX    TO IT_TAB-MAKTX,    "ǰ��.
              ZTREDSG1-ZFLSG1   TO IT_TAB-ZFLSG1,   "����.
              ZTREDSG1-ZFGOSD1  TO IT_TAB-ZFGOSD1,  "�԰�.
              ZTREDSG1-ZFQUN    TO IT_TAB-ZFQUN,    "����.
              ZTREDSG1-ZFQUNM   TO IT_TAB-ZFQUNM,  "�����ܰ�.
              ZTREDSG1-NETPR    TO IT_TAB-NETPR,    "�ܰ�.
              ZTREDSG1-ZFNETPRC TO IT_TAB-ZFNETPRC, "�ܰ� ��ȭ.
              ZTREDSG1-ZFREAM   TO IT_TAB-ZFREAM,   "�μ��ݾ�.
              ZTREDSG1-ZFREAMC  TO IT_TAB-ZFREAMC.  "�μ��ݾ� ��ȭ.
    ENDIF.

**>> ZVREQHD_ST
    SELECT SINGLE * FROM ZVREQHD_ST
                   WHERE EBELN = IT_TAB-EBELN .
    IF SY-SUBRC EQ 0.
       MOVE: ZVREQHD_ST-ZFOPNDT TO IT_TAB-ZFOPNDT,
             ZVREQHD_ST-ZFREQNO  TO IT_TAB-ZFREQNO .
    ENDIF.
**> ZTREQIT
    SELECT SINGLE * FROM ZTREQIT
                   WHERE ZFREQNO = IT_TAB-ZFREQNO .
    IF SY-SUBRC EQ 0.
       MOVE ZTREQIT-STAWN TO IT_TAB-STAWN.
    ENDIF.

    MODIFY IT_TAB INDEX W_TABIX.
  ENDLOOP.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P3000_DATA_WRITE .
*   SET PF-STATUS  'ZRIML'.
   SET TITLEBAR 'ZRIML'.          " TITLE BAR
   PERFORM P3000_LINE_WRITE.
ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

   SKIP 8.
   WRITE : 54 'SKC �ֽ�ȸ��'.
   WRITE : / SY-ULINE,120 SY-VLINE.
   WRITE : / SY-VLINE,40 ' ',120 SY-VLINE,
           / SY-VLINE,50 '�����ſ��幰ǰ��������',120 SY-VLINE,
           / SY-VLINE                              ,120 SY-VLINE,
           / SY-VLINE,50 '(No. ', 73 ')' ,120 SY-VLINE,
             SY-ULINE,                   120 SY-VLINE,
           / SY-VLINE,'',25 SY-VLINE, 120 SY-VLINE,
     / SY-VLINE,'    ��ǰ  ������',25 SY-VLINE,
            30 IT_TAB-ZFSCONM,120 SY-VLINE,
          / SY-VLINE,'',25 SY-VLINE,   120 SY-VLINE,
            SY-ULINE,                  120 SY-VLINE,
          / SY-VLINE,'',25 SY-VLINE, 60 SY-VLINE,
                     '',85 SY-VLINE, 120 SY-VLINE,
          / SY-VLINE, '    ��ǰ�μ�����',25 SY-VLINE,
                      30 IT_TAB-ZFREVDT,60 SY-VLINE,
                      61 '     ��ǰ�μ��ݾ�',85 SY-VLINE,
                      90 IT_TAB-ZFREAMFC,
                      95 IT_TAB-ZFREAMF CURRENCY IT_TAB-ZFREAMFC,
                                           120 SY-VLINE,
         / SY-VLINE,'',25 SY-VLINE,   60 SY-VLINE,
                     '',85 SY-VLINE, 120 SY-VLINE,
           SY-ULINE,                       120 SY-VLINE,
         / SY-VLINE,'    �μ�ǰ����',25 SY-VLINE,     120 SY-VLINE,
         / SY-VLINE,'           ',25 SY-VLINE,     120 SY-VLINE,
         / SY-VLINE,'           ',25 SY-VLINE,     120 SY-VLINE,
         / SY-VLINE,'           ',25 SY-VLINE,30 'HS Code:',
           43 IT_TAB-STAWN,                       120 SY-VLINE,
        / SY-VLINE,'           ',25 SY-VLINE, 30  IT_TAB-MAKTX,
                                                   120 SY-VLINE.
*>> MULTI DATA WRITE.
 PERFORM P3000_MULTIDATA.

 WRITE: / SY-VLINE,'           ',25 SY-VLINE,     120 SY-VLINE,
        / SY-VLINE,' ',25 SY-VLINE,26 SY-ULINE,   120 SY-VLINE,
        / SY-VLINE,' ',25 SY-VLINE,50 ' ',120 SY-VLINE,
        / SY-VLINE,' ',25 SY-VLINE,50 'TOTAL:',58 IT_TAB-ZFTOTAMC,
                       61 IT_TAB-ZFTOTAM CURRENCY IT_TAB-ZFTOTAMC,
                                                   120 SY-VLINE,
        / SY-VLINE,' ',25 SY-VLINE,50 ' ',120 SY-VLINE,
          SY-ULINE,                               120 SY-VLINE,
        / SY-VLINE,40'',     120 SY-VLINE,
        / SY-VLINE,50'��  ��  ��  ��  �� �� �� ',     120 SY-VLINE,
        / SY-VLINE,40' ',     120 SY-VLINE,
          SY-ULINE,                              120 SY-VLINE,
        / SY-VLINE,'',25 SY-VLINE,26'',49 SY-VLINE,
                      52'',73 SY-VLINE,78 '',97 SY-VLINE,
                     104 '',120 SY-VLINE,
        / SY-VLINE,'    �� �� �� ��',25 SY-VLINE,26'      L / C  No',
                     49 SY-VLINE, 52'    ��      ��',73 SY-VLINE,
                     78 ' �� ȿ �� ��',
                     97 SY-VLINE,
                    103 '�� �� �� ��',120 SY-VLINE,
        / SY-VLINE,'',25 SY-VLINE,26'',49 SY-VLINE,
                     52'',73 SY-VLINE,78 '',97 SY-VLINE,
                    104 '',120 SY-VLINE,
          SY-ULINE,                              120 SY-VLINE,
       / SY-VLINE,'',25 SY-VLINE,26'',49 SY-VLINE,
                     52'',73 SY-VLINE,78 '',97 SY-VLINE,
                    104 '',120 SY-VLINE,
      / SY-VLINE, 6 IT_TAB-ZFOBNM,25 SY-VLINE,30 IT_TAB-ZFLLCON,
                     49 SY-VLINE, 52 IT_TAB-ZFOPAMFC,
                     55 IT_TAB-ZFOPAMF CURRENCY IT_TAB-ZFOPAMFC,
                     73 SY-VLINE,
                     80 IT_TAB-ZFEXDT,97 SY-VLINE,
                    103 IT_TAB-ZFGDDT,120 SY-VLINE,
      / SY-VLINE,'', 25 SY-VLINE,26'',49 SY-VLINE,
                     52'',73 SY-VLINE,78 '',97 SY-VLINE,
                   104 '',120 SY-VLINE,
       SY-ULINE,                              120 SY-VLINE,
     / SY-VLINE,' ',25 SY-VLINE, 26 '',120 SY-VLINE,
     / SY-VLINE,'    ��       Ÿ',25 SY-VLINE, 50 'Local open DATE:',
                    68 IT_TAB-ZFOPNDT,        120 SY-VLINE,
     / SY-VLINE,' ',25 SY-VLINE, 26 '',       120 SY-VLINE,
       SY-ULINE,                              120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
/ SY-VLINE,40'�� ��ǰ�� Ʋ������ �����Ͽ����� ������.',120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
     / SY-VLINE,40'                    ',     120 SY-VLINE,
     / SY-VLINE,60'�߱�����  :',80'��',90'��',100'��',120 SY-VLINE,
     / SY-VLINE,40'',     120 SY-VLINE,
     / SY-VLINE,60'��ǰ������:',              120 SY-VLINE,
     / SY-VLINE,40'',                         120 SY-VLINE,
     / SY-VLINE,40'',                         120 SY-VLINE,
     / SY-VLINE,40'',                         120 SY-VLINE,
       SY-ULINE,                              120 SY-VLINE,
     / SY-VLINE,40'',                         120 SY-VLINE,
     / SY-VLINE,40'',                         120 SY-VLINE,
     / SY-VLINE,5'*���ǻ���.',                 120 SY-VLINE,
/ SY-VLINE,5 '1.��ǰ���������� ���� ���ݰ�꼭 �Ǻ��� �����Ͽ�',
                                '�߱��Ͽ��� ��.',120 SY-VLINE,
/ SY-VLINE,5 '  �ٸ�,�����ſ��� ���ǿ� ���� ���������縦 ����',
'���޹޴�',
'��쿡�� �Źݿ� �Ǵ� ���Ͽ����� ������ �ϴ�',120 SY-VLINE,
/ SY-VLINE,5 '  ��쿡 ���Ͽ� �� �Ⱓ�� ���� ���޽ø��� ���ε�',
'���ݰ�꼭���� ���ް����� �ϰ��Ͽ� ��ǰ����������',120 SY-VLINE ,
/ SY-VLINE,5 '  �߱� �� �� ����.',120 SY-VLINE,
/ SY-VLINE,5'2.������ �߼ұ������ ���� ��ǰ�� �μ��ϴ� ��쿡��',
'������ ���༼�ݰ�꼭���� �߱��Ϸ� ���� 10�� ��',120 SY-VLINE ,
/ SY-VLINE,5'  ���� �߱��Ͽ��� ��.',120 SY-VLINE ,
/ SY-VLINE,5'3.��ǰ���� ������ ��ǰ���� ���� �����ſ�����',
'��ǰ���� ��ġ�Ͽ��� ��.',120 SY-VLINE,
/ SY-VLINE,5'4.��ǰ���� �������� ��ǰ�������� ���� �Ǵ� �ΰ���',
'���ó����ſ����� �����Ƿڽ� �Ű��� ���� �Ǵ� �ΰ�',120 SY-VLINE,
/ SY-VLINE,5'  (��ǰ�ŵ� Ȯ�༭���� ����Ǵ� �ΰ��� �������� ��)��',
'��ġ�Ͽ��� ��.',120 SY-VLINE,
/ SY-VLINE,5'5.��ǰ���� �������� ��ǰ�μ����ڴ� ���ü��� ��꼭����',
'�������ڸ� ��� ���� �Ͽ��� ��.',120 SY-VLINE,
/ SY-VLINE,40'',                            120 SY-VLINE,
/ SY-VLINE,40'',                            120 SY-VLINE,
 SY-ULINE,                                  120 SY-VLINE.
  SKIP 1.
   WRITE:/108 '�������� �ֽ�ȸ��'.
   IF W_COUNT >= 6.
     PERFORM P3000_LAST_WRITE."��÷ ����.
   ENDIF.
ENDFORM.                    " P3000_LINE_WRITE


*&---------------------------------------------------------------------*
*&      Form  P3000_MULTIDATA
*&---------------------------------------------------------------------*
FORM P3000_MULTIDATA.

  W_COUNT = SY-TABIX.
  W_COUNT = 0.
  LOOP AT IT_TAB.
     W_COUNT = W_COUNT + 1.
     IF W_COUNT >= 6.
       MESSAGE S378. CONTINUE.
     ENDIF.
     WRITE: / SY-VLINE,'           ',25 SY-VLINE,30 IT_TAB-EBELN,
            40 IT_TAB-ZFGOSD1,60 IT_TAB-ZFQUN UNIT IT_TAB-ZFQUNM,
            75 IT_TAB-ZFQUNM,
            78 IT_TAB-ZFNETPRC,
            81 IT_TAB-NETPR  CURRENCY IT_TAB-ZFNETPRC,
            90 IT_TAB-ZFTOTAMC,
            95 IT_TAB-ZFTOTAM CURRENCY IT_TAB-ZFTOTAMC,
           120 SY-VLINE.
  ENDLOOP.
ENDFORM.                    " P3000_MULTIDATA

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_LAST_WRITE.
  SKIP 5.
  WRITE:/40 '[ �� ÷  �� �� ǰ  �� �� �� ]'.
  SKIP 3.
  WRITE:/  SY-ULINE,                                 120 SY-VLINE,
        /  SY-VLINE,'�μ�ǰ����',25 SY-VLINE,      120 SY-VLINE,
        /  SY-VLINE,'            ',25 SY-VLINE,      120 SY-VLINE,
        /  SY-VLINE,'            ',25 SY-VLINE,      120 SY-VLINE,
        /  SY-VLINE,'            ',25 SY-VLINE,26 'HS Code:',
            36 IT_TAB-STAWN,                         120 SY-VLINE,
        /  SY-VLINE,'             ',25 SY-VLINE,26  IT_TAB-MAKTX,
                                                    120 SY-VLINE.
  W_LINE = SY-TABIX.
  W_LINE = 0.
LOOP AT IT_TAB.
  W_LINE = W_LINE + 1.

  IF W_LINE <= 5. "������ �ִ� ����Ÿ ����.
    CONTINUE.
  ENDIF.
  WRITE: / SY-VLINE,'           ',25 SY-VLINE,26 IT_TAB-EBELN,
           40 IT_TAB-ZFGOSD1,55 IT_TAB-ZFQUN UNIT IT_TAB-ZFQUNM,
           70,IT_TAB-NETPR  CURRENCY IT_TAB-ZFNETPRC,
           85 IT_TAB-ZFREAMC,90 IT_TAB-ZFREAM CURRENCY IT_TAB-ZFREAMC,
                                                     120 SY-VLINE.
ENDLOOP.

  WRITE:/ SY-ULINE, 120 SY-VLINE.

ENDFORM.                    " P3000_LAST_WRITE
