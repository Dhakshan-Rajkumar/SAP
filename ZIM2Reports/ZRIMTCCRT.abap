*&---------------------------------------------------------------------*
*& Report  ZRIMTCCRT
*&---------------------------------------------------------------------*
*&  ���α׷��� : ���ݰ�꼭 ��ȸ                                       *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.11.13                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*


REPORT  ZRIMTCCRT    MESSAGE-ID ZIM
                     LINE-SIZE 116
                     NO STANDARD PAGE HEADING.
TABLES: ZTVT, ZTVTSG1,ZTVTSG3.
*-----------------------------------------------------------------------
* ���ݰ�꼭  INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFVTNO  LIKE ZTVT-ZFVTNO ,   " ���ݰ�꼭 ������ȣ"
       ZFTXAMT LIKE ZTVTSG3-ZFTXAMT," ����
*       ZFVERC  LIKE ZTVTSG3-ZFVERC, " ������.
       ZFSUDT  LIKE ZTVTSG3-ZFSUDT, " ������"
*       ZFVCDT  LIKE ZTVTSG3-ZFVCDT, " �ۼ���.
       ZFGONM  LIKE ZTVTSG3-ZFGONM, " ǰ���"
       ZFKRW   LIKE ZTVTSG3-ZFKRW,
       ZFGOSD1 LIKE ZTVTSG3-ZFGOSD1," �԰�1
       ZFGOSD2 LIKE ZTVTSG3-ZFGOSD2," �԰�2
       ZFGOSD3 LIKE ZTVTSG3-ZFGOSD3,
       ZFGOSD4 LIKE ZTVTSG3-ZFGOSD4,
       ZFREMK1 LIKE ZTVTSG3-ZFREMK1," ��������"
       ZFREMK2 LIKE ZTVTSG3-ZFREMK2,
       ZFREMK3 LIKE ZTVTSG3-ZFREMK3,
       ZFREMK4 LIKE ZTVTSG3-ZFREMK4,
       ZFREMK5 LIKE ZTVTSG3-ZFREMK5,
       ZFQUN   LIKE ZTVTSG3-ZFQUN,  " ����"
       ZFQUNM  LIKE ZTVTSG3-ZFQUNM, " ��������"
       ZFQUNSM  LIKE ZTVTSG3-ZFQUNSM," ����"
       NETPR   LIKE ZTVTSG3-NETPR,  " �ܰ�"
       PEINH   LIKE ZTVTSG3-PEINH,  " �ܰ� ����"
       BPRME   LIKE ZTVTSG3-BPRME,  " Order price unit
       ZFSAMK  LIKE ZTVTSG3-ZFSAMK, " ���ް��� ��ȭ"
       ZFSAMF  LIKE ZTVTSG3-ZFSAMF, " ���ް��� ��ȭ"
       ZFEXRT  LIKE ZTVTSG3-ZFEXRT. "  ȯ��"
DATA : END OF IT_TAB.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,               " ���� LINE COUNT
       W_PAGE            TYPE I,               " Page Counter
       W_LINE            TYPE I,               " �������� LINE COUNT
       LINE(3)           TYPE N,               " �������� LINE COUNT
       W_COUNT           TYPE I,               " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME, " �ʵ��.
       W_SUBRC           LIKE SY-UCOMM,
       W_DOM_TEX1        LIKE DD07T-DDTEXT,
       W_TABIX           LIKE SY-TABIX.    " TABLE INDEX

*-----------------------------------------------------------------------
* Selection Screen
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 2.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
 PARAMETERS : P_ZFVTNO  LIKE ZTVT-ZFVTNO      "������ȣ "
              MEMORY ID ZPVTNO.
SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.                    " �ʱⰪ SETTING
   SET  TITLEBAR 'ZIMA9'.          " TITLE BAR
*title Text Write
TOP-OF-PAGE.
 PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...

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

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.

     WHEN 'DOWN'.          " FILE DOWNLOAD....
           PERFORM P3000_TO_PC_DOWNLOAD.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.


ENDFORM.                    " P3000_TITLE_WRITE


*&---------------------------------------------------------------------*
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA.
** ZTVT

  SELECT  SINGLE *
     FROM ZTVT
    WHERE ZFVTNO = P_ZFVTNO.

 IF SY-SUBRC NE 0.               " Not Found?
         W_ERR_CHK = 'Y'.  MESSAGE S966.    EXIT.
  ENDIF.
  SELECT  SINGLE *
     FROM ZTVTSG1
    WHERE ZFVTNO = P_ZFVTNO.

** ZTVTSG3
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
     FROM ZTVTSG3
    WHERE ZFVTNO = P_ZFVTNO.

ENDFORM.                    " P1000_READ_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE .

  SET PF-STATUS 'ZIMA9'.
  SET  TITLEBAR 'ZIMA9'.          " TITLE BAR

  SORT IT_TAB BY ZFVTNO.
  PERFORM P3000_LINE_WRITE.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  SKIP 2.
  WRITE :/40  ' [ �� �� �� �� ��  ] '.
  WRITE :/45  ' (�����ڿ�) '.
  WRITE :/85 'Date : ', SY-DATUM.
  SKIP 3.
  WRITE :/  '���ڹ�����ȣ     :', ZTVT-ZDREINO.
  WRITE :/  'å��ȣ           :',  ZTVT-ZFVTKW.
  WRITE :/  'ȣ��ȣ           :',  ZTVT-ZFVTHO.
  WRITE :/  '�Ϸù�ȣ         :',  ZTVT-ZFVTSEQ.
  WRITE :/  '����������ȣ     :',  ZTVT-ZFVTRNO.
  WRITE :/  '(-)���ݰ�꼭��ȣ:',  ZTVTSG1-ZFVTNO.
  SKIP 2.
  WRITE : / '������           :',20  '<��Ϲ�ȣ>',ZTVTSG1-ZFTXN1.
  WRITE :                 /20  '<�� ȣ>', ZTVTSG1-ZFCONM1.
  WRITE :                 /20  '<��ǥ�ڸ�>',ZTVTSG1-ZFCHNM1.
  IF NOT ZTVTSG1-ZFADD11 IS INITIAL OR
     NOT ZTVTSG1-ZFADD21 IS INITIAL OR
     NOT ZTVTSG1-ZFADD31 IS INITIAL.
     WRITE : /20  '<��   ��>'.
     IF NOT ZTVTSG1-ZFADD11 IS INITIAL.
        WRITE : 32  ZTVTSG1-ZFADD11.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD21 IS INITIAL.
        WRITE : /32 ZTVTSG1-ZFADD21.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD31 IS INITIAL.
        WRITE :/32  ZTVTSG1-ZFADD31.
     ENDIF.
  ENDIF.
  IF NOT ZTVTSG1-ZFLEID1 IS INITIAL.
     WRITE : /20  '<���ڼ���>',ZTVTSG1-ZFLEID1.
  ENDIF.
  SKIP 2.
  WRITE : / '���޹޴���       :',20  '<��Ϲ�ȣ>',ZTVTSG1-ZFTXN2,
                          /20  '<��    ȣ>',ZTVTSG1-ZFCONM2,
                          /20  '<��ǥ�ڸ�>',ZTVTSG1-ZFCHNM2.
  IF NOT ZTVTSG1-ZFADD12 IS INITIAL OR
     NOT ZTVTSG1-ZFADD22 IS INITIAL OR
     NOT ZTVTSG1-ZFADD32 IS INITIAL.
     WRITE:/20  '<��    ��>'.
     IF NOT ZTVTSG1-ZFADD12 IS INITIAL.
        WRITE: 32 ZTVTSG1-ZFADD12.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD22 IS INITIAL.
        WRITE:/32  ZTVTSG1-ZFADD22.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD32 IS INITIAL.
        WRITE:/32  ZTVTSG1-ZFADD32.
     ENDIF.
     IF NOT ZTVTSG1-ZFTXN2 IS INITIAL.
        WRITE:/20 '<���ڼ���>',ZTVTSG1-ZFTXN2.
     ENDIF.
  ENDIF.
   SKIP 1.
  IF NOT ZTVTSG1-ZFTXN3 IS INITIAL.
         WRITE : / '�� Ź ��       :',20  '<��Ϲ�ȣ>',ZTVTSG1-ZFTXN3,
                               /20  '<��    ȣ>',ZTVTSG1-ZFCONM3,
                               /20  '<��ǥ�ڸ�>',ZTVTSG1-ZFCHNM3.
  ENDIF.
  IF NOT ZTVTSG1-ZFADD13 IS INITIAL OR
     NOT ZTVTSG1-ZFADD23 IS INITIAL OR
     NOT ZTVTSG1-ZFADD33 IS INITIAL.
     WRITE:/20  '<��    ��>'.
     IF NOT ZTVTSG1-ZFADD13 IS INITIAL.
        WRITE: 32 ZTVTSG1-ZFADD13.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD22 IS INITIAL.
        WRITE:/32  ZTVTSG1-ZFADD23.
     ENDIF.
     IF NOT ZTVTSG1-ZFADD32 IS INITIAL.
        WRITE:/32  ZTVTSG1-ZFADD33.
     ENDIF.
     IF NOT ZTVTSG1-ZFTXN3 IS INITIAL.
        WRITE:/20 '<���ڼ���>',ZTVTSG1-ZFTXN3.
     ENDIF.
  ENDIF.

  WRITE: / SY-ULINE ,50 '< ǰ     �� >'.
  SKIP 1.
  WRITE :/(20) 'ǰ     ��',
          (15) '��������',
          (19) '��       ��' RIGHT-JUSTIFIED,
          (19) '��ȭ���ް���' RIGHT-JUSTIFIED,
          (15) '��       ��' RIGHT-JUSTIFIED .
  WRITE: /(20) '��     ��',
          (15) '�� �� ��',
          (19)'(�ܰ�/����)'RIGHT-JUSTIFIED,
          (19) '��ȭ���ް���'RIGHT-JUSTIFIED,
          (15) 'ȯ       ��'RIGHT-JUSTIFIED.

  LOOP AT IT_TAB.
       WRITE :/(20) IT_TAB-ZFGONM, " ǰ���.
               (15) IT_TAB-ZFREMK1," ��������.
               (15) IT_TAB-ZFQUN
                    UNIT IT_TAB-ZFQUNM,      " ����.
                    IT_TAB-ZFQUNM,
               (15) IT_TAB-ZFSAMK
                    CURRENCY IT_TAB-ZFKRW,   " ���ް���.
               (03) IT_TAB-ZFKRW,
               (15) IT_TAB-ZFTXAMT
                   CURRENCY IT_TAB-ZFKRW.   " ����.

       WRITE :/(20) IT_TAB-ZFGOSD1," �԰�1.
               (15) IT_TAB-ZFSUDT, " ������.
               (15) IT_TAB-NETPR
                        CURRENCY ZTVT-ZFTSAMFC,
                             IT_TAB-BPRME,
               (15) IT_TAB-ZFSAMF
                    CURRENCY ZTVT-ZFTSAMFC,        " ���ް��׿�.
                     (03) ZTVT-ZFTSAMFC,
                80  IT_TAB-ZFEXRT RIGHT-JUSTIFIED. " ȯ��.

  ENDLOOP.

  SKIP 2.
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDVPTB' ZTVT-ZFVPTB
                                        CHANGING   W_DOM_TEX1.

  WRITE :/ '�Ѱ��ް���  :',ZTVT-ZFVTAMT CURRENCY ZTVT-ZFKRW
                            LEFT-JUSTIFIED.

  WRITE :/ '�Ѽ���      :',ZTVT-ZFTQUN UNIT ZTVT-ZFTQUNM
                           LEFT-JUSTIFIED.
  WRITE :/ '�ѱݾ�      :',ZTVT-ZFTOTAM CURRENCY ZTVT-ZFKRW
                           LEFT-JUSTIFIED,
         / '�������    :', (08)W_DOM_TEX1.
  IF NOT ZTVT-ZFVPAMK IS INITIAL.
     WRITE:/'�����ݾ�    :', ZTVT-ZFKRW,ZTVT-ZFVPAMK
                             CURRENCY ZTVT-ZFKRW
                             LEFT-JUSTIFIED.
  ENDIF.
  IF NOT ZTVT-ZFVPAMF IS INITIAL.
     WRITE:/'            :', ZTVT-ZFTSAMFC,
                             ZTVT-ZFVPAMF CURRENCY ZTVT-ZFTSAMFC
                             LEFT-JUSTIFIED.
  ENDIF.
  SKIP 1.
  WRITE: / SY-ULINE .
  SKIP 1.
  WRITE:/ '�� �ݾ��� û����.',
        / '*�� ��꼭�� �ΰ���ġ���� ����� ��53 �� 3�׹� 4���� ������',
      '���Ͽ� ������ ���ݰ�꼭�� ������ ����� ���Դϴ�.'.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_TO_PC_DOWNLOAD
*&---------------------------------------------------------------------*
FORM P3000_TO_PC_DOWNLOAD.

   CALL FUNCTION 'DOWNLOAD'
        EXPORTING
        FILENAME = 'C:\TEMP\TEMP.XLS'
        FILETYPE = 'ASC'
   TABLES
       DATA_TAB = IT_TAB.

ENDFORM.                    " P3000_TO_PC_DOWNLOAD
