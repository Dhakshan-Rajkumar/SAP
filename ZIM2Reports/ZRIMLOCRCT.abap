*&---------------------------------------------------------------------*
*& Report  ZRIMLOCRCT1
*&---------------------------------------------------------------------*
*&  ���α׷��� : �����ſ��� ��ǰ���� ����                            *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.15                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : �μ����� ���� �ϱ����� �μ��� ��ȸ.
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*


REPORT  ZRIMLOCRCT1  MESSAGE-ID ZIM
                     LINE-SIZE 116
                     NO STANDARD PAGE HEADING.
TABLES: ZTRED, ZTREDSG1,ZTREQST,ZTREQHD.
*-----------------------------------------------------------------------
* ��ǰ���� ���� INTERNAL TABLE
*-----------------------------------------------------------------------

DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFREDNO  LIKE    ZTRED-ZFREDNO,     "�μ���������ȣ.
       ZFGDNO   LIKE    ZTREDSG1-ZFGDNO,   "��ǰ��ȣ.
       MAKTX    LIKE    ZTREDSG1-MAKTX,    "ǰ��.
       ZFLSG1   LIKE    ZTREDSG1-ZFLSG1,   "����.
       ZFGOSD1  LIKE    ZTREDSG1-ZFGOSD1,  "�԰�.
       ZFQUN    LIKE    ZTREDSG1-ZFQUN,    "����.
       ZFQUNM   LIKE    ZTREDSG1-ZFQUNM,   "��������.
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
       W_MAX_ZFREQNO     LIKE ZTREQHD-ZFREQNO,
       W_MAX_ZFAMDNO     LIKE ZTREQST-ZFAMDNO,
       W_SUBRC           LIKE SY-UCOMM,
       W_TABIX           LIKE SY-TABIX.    " TABLE INDEX

DATA  SUM_ZFQUN  LIKE   ZTREDSG1-ZFQUN.
DATA  SUM_ZFREAM LIKE   ZTREDSG1-ZFREAM.

*-----------------------------------------------------------------------
* Selection Screen
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 2.  " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
      PARAMETERS : P_REDNO  LIKE ZTRED-ZFREDNO.

SELECTION-SCREEN END OF BLOCK B1.

   INITIALIZATION.                    " �ʱⰪ SETTING
   SET  TITLEBAR 'ZIML4'.          " TITLE BAR


*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

*  ���̺� SELECT
   PERFORM   P1000_READ_DATA.
   DESCRIBE TABLE IT_TAB LINES W_LINE.
   IF W_LINE EQ 0.               " Not Found.
     MESSAGE S738.
     EXIT.
   ENDIF.
* ����Ʈ Write
   PERFORM   P3000_DATA_WRITE.

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA.

  REFRESH: IT_TAB.
  SELECT SINGLE *
    FROM ZTRED
   WHERE ZFREDNO = P_REDNO.

*>> SELECT LOCAL L/C ������.
  SELECT MAX( ZFREQNO )  INTO W_MAX_ZFREQNO
    FROM ZTREQHD
   WHERE EBELN = ZTRED-EBELN.

  SELECT MAX( ZFAMDNO ) INTO W_MAX_ZFAMDNO
    FROM ZTREQST
   WHERE ZFREQNO = W_MAX_ZFREQNO.

  SELECT SINGLE *
    FROM ZTREQST
   WHERE ZFREQNO = W_MAX_ZFREQNO
     AND ZFAMDNO = W_MAX_ZFAMDNO.

*>> SELECT ITEM

  SELECT * FROM ZTREDSG1
           WHERE ZFREDNO =  P_REDNO.
    CLEAR IT_TAB.
    MOVE-CORRESPONDING ZTREDSG1 TO IT_TAB.
    APPEND IT_TAB.
  ENDSELECT.
  CLEAR: SUM_ZFQUN, SUM_ZFREAM.
  SELECT SUM( ZFQUN ) INTO SUM_ZFQUN
         FROM ZTREDSG1
        WHERE ZFREDNO = P_REDNO.
  SELECT SUM( ZFREAM ) INTO SUM_ZFREAM
         FROM ZTREDSG1
        WHERE ZFREDNO = P_REDNO.


ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE .

   SET PF-STATUS 'ZIML4'.
   SET TITLEBAR  'ZIML4'.          " TITLE BAR
   PERFORM P3000_LINE_WRITE.

ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  SKIP 2.
  WRITE:/50 '�����ſ��幰ǰ��������'.
  SKIP 5.
  WRITE:/4 '�߱޹�ȣ     :', ZTRED-ZFISNO,
        /4 '�߱�����     :', ZTRED-ZFISUDT,
        /4 '������       :', ZTRED-ZFSCONM,
        /4 '�μ�����     :', ZTRED-ZFREVDT,
        /4 '�μ��ݾ�     :', ZTRED-ZFREAMFC,
                             ZTRED-ZFREAMF CURRENCY ZTRED-ZFREAMFC
                             LEFT-JUSTIFIED,
                             ZTRED-ZFKRW,
                             ZTRED-ZFREAMK CURRENCY ZTRED-ZFKRW
                             LEFT-JUSTIFIED.
  IF NOT ZTRED-ZFREXDT IS INITIAL.
     WRITE:/4 '������ȿ���� :',ZTRED-ZFREXDT.
  ENDIF.
  IF  NOT ZTRED-ZFETCD1 IS INITIAL
   OR NOT ZTRED-ZFETCD2 IS INITIAL
   OR NOT ZTRED-ZFETCD3 IS INITIAL
   OR NOT ZTRED-ZFETCD4 IS INITIAL
   OR NOT ZTRED-ZFETCD5 IS INITIAL.

      WRITE: /4 '��Ÿ����     :'.
      IF  NOT ZTRED-ZFETCD1 IS INITIAL.
          WRITE:19 ZTRED-ZFETCD1.
      ENDIF.
      IF  NOT ZTRED-ZFETCD3 IS INITIAL.
          WRITE: /19 ZTRED-ZFETCD2.
      ENDIF.
      IF  NOT ZTRED-ZFETCD3 IS INITIAL.
          WRITE: /19 ZTRED-ZFETCD3.
      ENDIF.
      IF  NOT ZTRED-ZFETCD4 IS INITIAL.
          WRITE: /19 ZTRED-ZFETCD4.
      ENDIF.
       IF  NOT ZTRED-ZFETCD5 IS INITIAL.
          WRITE: /19 ZTRED-ZFETCD5.
      ENDIF.

  ENDIF.
  SKIP 2.
*>> MULTI DATA WRITE.
  WRITE:/4 SY-ULINE,50 '<�μ���ǰ����>',65 SY-ULINE.
  SKIP 1.
  PERFORM P3000_MULTIDATA.
  SKIP 2.
  WRITE:/4 SY-ULINE,46 '<���� �����ſ��� ����>',69 SY-ULINE.
  WRITE:/4 '��������     :',ZTRED-ZFOBNM.
  IF NOT ZTRED-ZFOBNEID IS INITIAL.
      WRITE:/4 '�����������ڼ���:',ZTRED-ZFOBNEID.
  ENDIF.
  WRITE:/4 '�ſ��� ��ȣ  :',ZTRED-ZFLLCON.

  IF NOT ZTRED-ZFOPAMFC IS INITIAL.
     WRITE: /4 '�ſ��� �ݾ�  :',ZTRED-ZFOPAMFC,
                               ZTRED-ZFOPAMF CURRENCY ZTRED-ZFOPAMFC
                               LEFT-JUSTIFIED.
  ENDIF.
  IF NOT ZTRED-ZFOPAMK IS INITIAL.
     IF NOT ZTRED-ZFOPAMFC IS INITIAL.SKIP 1. ENDIF.
     WRITE: ZTRED-ZFKRW,
            ZTRED-ZFOPAMK CURRENCY ZTRED-ZFKRW
                            LEFT-JUSTIFIED.
  ENDIF.
  WRITE:/4 '�ε�����     :',ZTRED-ZFGDDT,
        /4 '��ȿ����     :',ZTRED-ZFEXDT.
  IF   NOT ZTRED-ZFREMK1 IS INITIAL
    OR NOT ZTRED-ZFREMK2 IS INITIAL
    OR NOT ZTRED-ZFREMK3 IS INITIAL
    OR NOT ZTRED-ZFREMK4 IS INITIAL.
    WRITE:/4 '��������     :'.
  ENDIF.
  IF NOT ZTRED-ZFREMK1 IS INITIAL.
    WRITE:19 ZTRED-ZFREMK1.
  ENDIF.
  IF NOT ZTRED-ZFREMK2 IS INITIAL.
    WRITE:/19 ZTRED-ZFREMK2.
  ENDIF.
  IF NOT ZTRED-ZFREMK3 IS INITIAL.
    WRITE:/19 ZTRED-ZFREMK3.
  ENDIF.
  IF NOT ZTRED-ZFREMK4 IS INITIAL.
    WRITE:/19 ZTRED-ZFREMK4.
  ENDIF.
  SKIP 2.
  WRITE:/4 SY-ULINE,50 '<��ǰ ������>',65 SY-ULINE.
  SKIP 1.
  WRITE:/4 '��   ��  ��  :',ZTRED-ZFRCONM,
        /4 '�� ǥ �� ��  :',ZTRED-ZFRCHNM,
        /4 '�� �� �� ��  :',ZTRED-ZFTXN4.
  SKIP 2.
  WRITE:/4 SY-ULINE.
  WRITE:/4 SY-VLINE,'*���ǻ���.',116 SY-VLINE.
  WRITE:/4 SY-VLINE, 116 SY-VLINE.
  WRITE:/4 SY-VLINE,'1. �� ��ǰ���������� �߱����� ���� �����ſ�����',
  '��ǰ �ε����� �����̾�� �մϴ�.', 116 SY-VLINE.
  WRITE:/4 SY-VLINE, 116 SY-VLINE.
  WRITE:/4 SY-VLINE,'2. �� ��ǰ���������� �������� ���ݰ�꼭',
  '�����Ϸκ��� 10�� �̳��� �߱��Ͽ��� �մϴ�.', 116 SY-VLINE.
  WRITE:/4 SY-VLINE, 116 SY-VLINE.
  WRITE:/4 SY-VLINE,'3. �� ��ǰ���������� ��ǰ���� ����',
  '�����ſ����� ��ǰ���� ��ġ�Ͽ��� �մϴ�.', 116 SY-VLINE.
  WRITE:/4 SY-VLINE, 116 SY-VLINE.
  WRITE:/4 SY-VLINE,'4. �� ��ǰ���������� ��ǰ �������� �ΰ� �Ǵ�',
  '������ ���� �����ſ����� �����Ƿڽ� �Ű��� �ΰ� �Ǵ� ����',
  116 SY-VLINE.
  WRITE:/4 SY-VLINE,'   (��ǰ�ŵ�Ȯ�༭���� �ΰ� �Ǵ� ������',
 '����������)�� ��ġ�Ͽ��� �մϴ�.', 116 SY-VLINE.
  WRITE:/4 SY-VLINE, 116 SY-VLINE.
  WRITE:/4 SY-VLINE,'5. �� ��ǰ���������� ��ǰ �μ����ڴ� �����ڰ�',
  '������ ���ݰ�꼭���� ���� ���ڿ� ��ġ�Ͽ��� �մϴ�.', 116 SY-VLINE.
  WRITE:/4 SY-VLINE,116 SY-VLINE.
  WRITE:/4 SY-ULINE.
  SKIP 1.
  WRITE:/4 SY-ULINE.
  WRITE:/4 SY-VLINE,'�� ���ڹ�����  "���������ڵ�ȭ ���������ѹ���" ��',
  '�ǰ� ���ڹ�����ȯ������� ����� ��ǰ ���������μ�',116 SY-VLINE.
  WRITE:/4 SY-VLINE,'�������ڴ� �� ���� ������� ��12����',
  '��ǥ2 ��1�� ��7������ ���� �ٿ� ���� ���������� �����Ͽ��� �մϴ�.'
  ,116 SY-VLINE.
  WRITE:/4 SY-VLINE,116 SY-VLINE.
  WRITE:/4 SY-ULINE.
  SKIP 1.
  IF W_COUNT >= 10.
      PERFORM P3000_LAST_WRITE."��÷ ����.
  ENDIF.
ENDFORM.                    " P3000_LINE_WRITE


*&---------------------------------------------------------------------*
*&      Form  P3000_MULTIDATA
*&---------------------------------------------------------------------*
FORM P3000_MULTIDATA.

  W_COUNT = 0.
  WRITE:/04 SY-ULINE.
  WRITE:/04 SY-VLINE,(45) '��ǥǰ��'CENTERED,
            SY-VLINE,(25) '��   ��' CENTERED,
*           SY-VLINE,(20) '�ܰ�',
            SY-VLINE,(35) '��   ��' CENTERED,116 SY-VLINE.
  WRITE:/04 SY-ULINE.

  LOOP AT IT_TAB.
     W_COUNT = W_COUNT + 1.
     IF W_COUNT >= 10.
       MESSAGE S656. CONTINUE.
     ENDIF.
*>> 2002.1.9 ��ä�� ����.
     WRITE:/4 SY-VLINE,(45)IT_TAB-MAKTX,
              SY-VLINE,53 SUM_ZFQUN UNIT IT_TAB-ZFQUNM,
                       76 IT_TAB-ZFQUNM,
              SY-VLINE,90 IT_TAB-ZFREAMC,
              95 SUM_ZFREAM CURRENCY IT_TAB-ZFREAMC,116 SY-VLINE.
     WRITE:/04 SY-ULINE.
*     WRITE:/4 SY-VLINE,(35)IT_TAB-MAKTX,
*            SY-VLINE,(16)IT_TAB-ZFQUN UNIT IT_TAB-ZFQUNM,
*                     (03)IT_TAB-ZFQUNM,
*            SY-VLINE,(20)IT_TAB-NETPR  CURRENCY IT_TAB-ZFNETPRC,
*            SY-VLINE,(03) IT_TAB-ZFREAMC,
*                     (20)IT_TAB-ZFREAM CURRENCY IT_TAB-ZFREAMC,
*            116 SY-VLINE.
*    WRITE:/04 SY-ULINE.
*    AT LAST.
*       WRITE:/4 SY-VLINE,'TOTAL',43 ZTRED-ZFTQUN UNIT ZTRED-ZFTQUNM,
*             61 ZTRED-ZFTQUNM,
*             90 ZTRED-ZFTOTAMC,
*             95 ZTRED-ZFTOTAM CURRENCY ZTRED-ZFTOTAMC,116 SY-VLINE.
*       WRITE:/04 SY-ULINE.
*    ENDAT.
     EXIT.
  ENDLOOP.

ENDFORM.                    " P3000_MULTIDATA

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  SKIP 5.
  WRITE:/40 '[ �� ÷  �� �� ǰ  �� �� ��]'.
  SKIP 3.
  WRITE:/04 SY-VLINE,(35)'ǰ��/�԰�',
            SY-VLINE,(20) '����',
            SY-VLINE,(20) '�ܰ�',
            SY-VLINE,(20) '�ݾ�',116 SY-VLINE.
  WRITE:/04 SY-ULINE.

  W_LINE = SY-TABIX.
  W_LINE = 0.
  LOOP AT IT_TAB.
     W_LINE = W_LINE + 1.
     IF W_LINE <= 9. "������ �ִ� ����Ÿ ����.
       CONTINUE.
     ENDIF.
      WRITE:/4 SY-VLINE,(35)IT_TAB-MAKTX,
            SY-VLINE,(16)IT_TAB-ZFQUN UNIT IT_TAB-ZFQUNM,
                     (03)IT_TAB-ZFQUNM,
            SY-VLINE,(20)IT_TAB-NETPR  CURRENCY IT_TAB-ZFNETPRC,
            SY-VLINE,(03) IT_TAB-ZFREAMC,
                     (20)IT_TAB-ZFREAM CURRENCY IT_TAB-ZFREAMC,
            116 SY-VLINE.
    WRITE:/04 SY-ULINE.
  ENDLOOP.

  WRITE:/ SY-ULINE, 116 SY-VLINE.

ENDFORM.                    " P3000_LAST_WRITE
