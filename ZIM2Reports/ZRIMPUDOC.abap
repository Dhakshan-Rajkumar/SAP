************************************************************************
*                                                                      *
*  ���/������    :        MM / ����                                 *
*  TYPE             :        REPORT                                    *
*  NAME             :        ZRIMPUDOC                                 *
*  T_CODE           :                                                  *
*                                                                      *
*  Description      :        ���Ž��μ� ���                           *
*                                                                      *
************************************************************************
*                        MODIFICATION LOG                              *
*                                                                      *
*  Date.           Authors.        description.                        *
* -----------    -----------    ------------------------------         *
* 2002/02/18      �� �� ��       INITIAL RELEASE                       *
*                                                                      *
************************************************************************
REPORT  ZRIMPUDOC      NO STANDARD PAGE HEADING
                       MESSAGE-ID ZIM
                       LINE-SIZE 120
                       LINE-COUNT 90.

TABLES: ZTPUR,ZTPURSG1,ZTPURSG4,ZTREQST.

*----------------------------------------------------------------------
* ���Ž��μ� INTERNAL TABLE
*----------------------------------------------------------------------

*DATA : BEGIN OF IT_TAB OCCURS 0,
*       ZFREQNO  LIKE    ZTPUR-ZFREQNO,     " �����Ƿ� ������ȣ.
*       ZFAPPNM1 LIKE    ZTPUR-ZFAPPNM1,    " ��ȣ1.
*       ZFAPPNM2 LIKE    ZTPUR-ZFAPPNM2,    " ��ȣ2.
*       ZFAPPNM3 LIKE    ZTPUR-ZFAPPNM3,    " ��ȣ3.
*       ZFAPPAD1 LIKE    ZTPUR-ZFAPPAD1,    " �ּ�.
*       ZFAPPAD2 LIKE    ZTPUR-ZFAPPAD2,    " �ּ�.
*       ZFAPPAD3 LIKE    ZTPUR-ZFAPPAD3,    " �ּ�.
*       ZFBENI   LIKE    ZTPUR-ZFBENI,      " ������.
*       ZFVENNM1 LIKE    ZTPUR-ZFVENNM1,    " �����ڻ�ȣ.
*       ZFVENNM2 LIKE    ZTPUR-ZFVENNM2,    " �����ڻ�ȣ.
*       ZFVENID  LIKE    ZTPUR-ZFVENID,     " �����ڽĺ���.
*       ZFVENAD1 LIKE    ZTPUR-ZFVENAD1,    " ������ �ּ�.
*       ZFVENAD2 LIKE    ZTPUR-ZFVENAD2,    " ������ �ּ�.
*       ZFVENAD3 LIKE    ZTPUR-ZFVENAD3,    " ������ �ּ�.
*       ZFTOCN   LIKE    ZTPUR-ZFTOCN,      " �Ѽ���.
*       ZFTOCNM  LIKE    ZTPUR-ZFTOCNM,     " �Ѽ��� ����.
*       ZFTOAM   LIKE    ZTPUR-ZFTOAM,      " �ѱݾ�.
*       ZFTOAMC  LIKE    ZTPUR-ZFTOAMC,     " �ѱݾ� ����.
*       ZFTOAMU  LIKE    ZTPUR-ZFTOAMU,     " USD�ѱݾ�.
*       ZFUSD    LIKE    ZTPUR-ZFUSD.       " USD�ѱݾ� ����.
*DATA : END OF IT_TAB.

*DATA : BEGIN OF IT_TAB1 OCCURS 0,
*       ZFREQNO  LIKE    ZTPURSG4-ZFREQNO,
*       ZFAMDNO  LIKE    ZTPURSG1-ZFAMDNO,  " AMEND ȸ��.
*       STAWN    LIKE    ZTPURSG1-STAWN,    " HS CODE.
*       ZFHSDESC LIKE    ZTPURSG1-ZFHSDESC, " HS �ڵ� ǰ��.
*       ZFGODS1  LIKE    ZTPURSG1-ZFGODS1,  " ǰ���.
*       MENGE    LIKE    ZTPURSG1-MENGE,    " ����.
*       MEINS    LIKE    ZTPURSG1-MEINS,    " ��������.
*       ZFGOAMT  LIKE    ZTPURSG1-ZFGOAMT,  " �ݾ�.
*       WAERS    LIKE    ZTPURSG1-WAERS,    " �ݾ״���.
*       ZFGOAMTU LIKE    ZTPURSG1-ZFGOAMTU, " ��ȭ�ݾ�.
*       ZFUSD    LIKE    ZTPURSG1-ZFUSD,    " ��ȭ.
*       ZFNETPRU LIKE    ZTPURSG1-ZFNETPRU, " �ܰ���ȭ.
*       NETPR    LIKE    ZTPURSG1-NETPR,    " �ܰ�.
*       PEINH    LIKE    ZTPURSG1-PEINH.    " �ܰ�����.
*DATA : END OF IT_TAB1.

*DATA : BEGIN OF IT_TAB2 OCCURS 0,
*       ZFREQNO  LIKE    ZTPURSG4-ZFREQNO,  " �����Ƿ� ������ȣ.
*       ZFAMDNO  LIKE    ZTPURSG4-ZFAMDNO,  " AMEND ȸ��.
*       STAWN    LIKE    ZTPURSG4-STAWN,    " HS CODE.
*       ZFGOAMT  LIKE    ZTPURSG4-ZFGOAMT,  " �ݾ�.
*       WAERS    LIKE    ZTPURSG4-WAERS,    " �ݾ״���.
*       ZFGODS1  LIKE    ZTPURSG4-ZFGODS1,  " ǰ���.
*       ZFSDOC   LIKE    ZTPURSG4-ZFSDOC,   " �ٰż�����.
*       ZFSDNO   LIKE    ZTPURSG4-ZFSDNO,   " �ٰż�����ȣ.
*       ZFEXDT   LIKE    ZTPURSG4-ZFEXDT,   " ��ȿ����.
*       ZFSPDT   LIKE    ZTPURSG4-ZFSPDT,   " ��������.
*       ZFDOCST  LIKE    ZTREQST-ZFDOCST.   " ��������.
*DATA : END OF IT_TAB2.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,              " ���� LINE COUNT
       W_PAGE            TYPE I,              " Page Counter
       W_LINE            TYPE I,              " �������� LINE COUNT
       LINE(3)           TYPE N,              " �������� LINE COUNT
       W_COUNT           TYPE I,              " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME," �ʵ��.
       W_SUBRC           LIKE SY-UCOMM,
       W_TABIX           LIKE SY-TABIX.       " TABLE INDEX

*----------------------------------------------------------------------
* Selection Screen
*----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
    PARAMETERS : P_REQNO  LIKE ZTPUR-ZFREQNO
                 MEMORY ID  ZPREQNO,
                 P_AMDNO  LIKE ZTPURSG1-ZFAMDNO
                 MEMORY ID ZPAMDNO.
SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------
* INITIALIZATION.
*----------------------------------------------------------------------
INITIALIZATION.                      " �ʱⰪ SETTING
    SET  TITLEBAR 'ZIMRPU'.          " TITLE BAR

*----------------------------------------------------------------------
* START OF SELECTION
*----------------------------------------------------------------------
START-OF-SELECTION.
* ���̺� SELECT
    PERFORM   P1000_READ_DATA.

* ����Ʈ Write
    PERFORM   P3000_DATA_WRITE.

    IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------
*&      Form  P1000_GET_IT_TAB
*&---------------------------------------------------------------------
FORM P1000_READ_DATA.
*  SELECT SINGLE * FROM ZTREQST
*          WHERE ZFREQNO = P_REQNO
*            AND ZFAMDNO = P_AMDNO.
*  IF ZTREQST-ZFRLST2 NE 'R'.
*      MESSAGE S356 WITH P_REQNO.
*      LEAVE TO SCREEN 0.
*  ENDIF.
*  CASE  ZTREQST-ZFDOCST.
*    WHEN 'R' OR 'A' OR 'O'.
*       MESSAGE S356 WITH P_REQNO.
*       LEAVE TO SCREEN 0.
*    WHEN OTHERS.
*  ENDCASE.
*
***>> ZTPURSG1
*  REFRESH IT_TAB1.
*  SELECT  *  FROM ZTPURSG1
*            WHERE  ZFREQNO = P_REQNO
*              AND  ZFAMDNO = P_AMDNO.
*     CLEAR IT_TAB.
*     MOVE-CORRESPONDING ZTPURSG1 TO IT_TAB1.
*     APPEND IT_TAB1.
*  ENDSELECT.
***>> ZTPURSG4
*  REFRESH IT_TAB2.
*  SELECT *  FROM ZTPURSG4
*          WHERE  ZFREQNO = P_REQNO
*            AND  ZFAMDNO = P_AMDNO.
*     CLEAR IT_TAB2.
*     MOVE-CORRESPONDING ZTPURSG4 TO IT_TAB2.
*     APPEND IT_TAB2.
*  ENDSELECT.
***>> ZTPUR
*  SELECT SINGLE * FROM ZTPUR
*                 WHERE ZFREQNO = P_REQNO
*                   AND ZFAMDNO = P_AMDNO.
*  MOVE-CORRESPONDING ZTPUR TO IT_TAB.
*  APPEND IT_TAB.
*  DESCRIBE TABLE IT_TAB LINES W_LINE.
*  IF W_LINE EQ 0.               " Not Found?
*    MESSAGE S356 WITH P_REQNO.
*    LEAVE TO SCREEN 0.
*  ENDIF.
*
ENDFORM.                     " P1000_READ_DATA

*&---------------------------------------------------------------------
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE .
    SET TITLEBAR   'ZIMRPU'.          " TITLE BAR
    PERFORM P3000_LINE_WRITE.
ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
FORM P3000_LINE_WRITE.
    WRITE : / '�غ���......'.

*  SKIP 5.
*  WRITE : /44 '��ȸȹ������(��ǰ)���Ž��ν�û��'.
*  ULINE AT /105(15). WRITE: 120 SY-VLINE.
*  WRITE:/105 SY-VLINE, 106 '  ó���Ⱓ  ',120 SY-VLINE.
*  ULINE AT /105(15). WRITE: 120 SY-VLINE.
*  WRITE:/105  SY-VLINE, 106 '    3 ��    ',120 SY-VLINE.
*  WRITE:/     SY-ULINE,120 SY-VLINE.
*  WRITE:/ SY-VLINE, 59 SY-VLINE, 120 SY-VLINE,
*         /  SY-VLINE, (55) '��û��(��ȣ,�ּ�,����)',
*        59 SY-VLINE, 61 '������(��ȣ,�ּ�,����)',120 SY-VLINE,
*        / SY-VLINE, 59 SY-VLINE, 120 SY-VLINE,
*        /  SY-VLINE, 10 IT_TAB-ZFAPPNM1,
*        59 SY-VLINE, 68 IT_TAB-ZFVENNM1,            120 SY-VLINE,
*        / SY-VLINE, 59 SY-VLINE, 120 SY-VLINE,
*        /  SY-VLINE, 10 IT_TAB-ZFAPPAD1 NO-GAP,(18)IT_TAB-ZFAPPAD2,
*        59 SY-VLINE, 68 IT_TAB-ZFVENAD1 NO-GAP,(18)IT_TAB-ZFVENAD2,
*                                                  120 SY-VLINE,
*        / SY-VLINE, 59 SY-VLINE, 120 SY-VLINE,
*           SY-VLINE, 10 IT_TAB-ZFAPPNM3,43 '����Ǵ� (��)',
*        59 SY-VLINE, 68 IT_TAB-ZFVENID,104'����Ǵ� (��)',120 SY-VLINE,
*        / SY-VLINE, 59 SY-VLINE, 120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-VLINE,'���޹�ǰ��(���������,���ʿ�����,���⹰ǰ��',
*                     '�ش���׿� O ǥ �Ұ�.)', 120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE,
*        /   SY-VLINE, (15) ' ',
*            SY-VLINE, (30) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (20) ' ',120 SY-VLINE,
*        /   SY-VLINE, (15) '  H S   �� ȣ   ',
*            SY-VLINE, (30) '     ǰ ��  ��  �� ��',
*            SY-VLINE, (20) '  �� ��  �� �� �� ',
*            SY-VLINE, (20) '  ��           �� ',
*            SY-VLINE, (20) '  ��           ��',120 SY-VLINE,
*        /   SY-VLINE, (15) ' ',
*            SY-VLINE, (30) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (20) '',
*            SY-VLINE, (20) ' (U S $ ȭ  �� ��)',120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE.
**>> MULTIDATA WRITE.
*  PERFORM P3000_MULTIDATA.
*
*  WRITE:/   SY-ULINE,                  120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-VLINE,45 'T O T A L : ',(41) ' ',
*         (3) IT_TAB-ZFTOAMC,
*        (16) IT_TAB-ZFTOAM  CURRENCY IT_TAB-ZFTOAMC,
*                                       120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-VLINE,'����Ǵ� ���Ž��μ����� ����',120 SY-VLINE,
*        /   SY-VLINE,                  120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE,
*
*        /   SY-VLINE, (20) ' ',
*            SY-VLINE, (15) ' ',
*            SY-VLINE, (26) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (10) '  ',
*            SY-VLINE, (10) ' ',        120 SY-VLINE,
*
*        /   SY-VLINE, (20) ' �ٰż����� �� ��ȣ',
*            SY-VLINE, (15) '  H S   �� ȣ',
*            SY-VLINE, (26) '   ǰ               �� ',
*            SY-VLINE, (20) '   ��          ��',
*            SY-VLINE, (10) '��ȿ ����',
*            SY-VLINE, (10) '���� ����',120 SY-VLINE,
*        /   SY-VLINE, (20) ' ',
*            SY-VLINE, (15) ' ',
*            SY-VLINE, (26) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (10) ' ',
*            SY-VLINE, (10) ' ',        120 SY-VLINE,
*        /   SY-ULINE,                  120 SY-VLINE.
**>> MULTIDATAWRITE.
*  PERFORM P3000_MULTIDATAWRITE.
*
*  WRITE:  /  SY-ULINE,                  120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE,'���ο��',120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-ULINE,                  120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE,'���ι�ȣ',120 SY-VLINE,
*          /  SY-VLINE,'    ',120 SY-VLINE,
*          /  SY-ULINE,                  120 SY-VLINE,
*          /  SY-VLINE,'���� ��û������ ��ܹ�����������',
*             '��4-2-7���� ������ ���Ͽ� �����մϴ�.',120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE, 93 '20001.    .    . ',120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE,80 '��  ��  ��', 113 '(��)', 120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-VLINE,' ',120 SY-VLINE,
*          /  SY-ULINE,                 120 SY-VLINE.
*
ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------
*&      Form  P3000_MULTIDATA
*&---------------------------------------------------------------------
*FORM P3000_MULTIDATA.
* LOOP AT IT_TAB1.
*  WRITE:/   SY-VLINE, (15) ' ',
*            SY-VLINE, (30) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (20) '',
*            SY-VLINE, (20) ' ',120 SY-VLINE,
*        /   SY-VLINE, (15) IT_TAB1-STAWN,
*            SY-VLINE, (30) IT_TAB1-ZFHSDESC,
*            SY-VLINE, (16) IT_TAB1-MENGE UNIT IT_TAB1-MEINS,
*                       (3) IT_TAB1-MEINS,
*            SY-VLINE,  (3) IT_TAB1-WAERS,
*                      (16) IT_TAB1-NETPR CURRENCY IT_TAB1-WAERS,
*            SY-VLINE,  (3)  IT_TAB1-WAERS,
*                      (16) IT_TAB1-ZFGOAMT
*                           CURRENCY IT_TAB1-WAERS,120 SY-VLINE,
*         /  SY-VLINE, (15) ' ',
*            SY-VLINE, (30) ' ',
*            SY-VLINE, (16) ' ',
*                       (3) ' ',
*            SY-VLINE,  (3)  ' ',
*                      (16) ' ',
*            SY-VLINE,  (3) IT_TAB1-ZFUSD,
*                      (16) IT_TAB1-ZFGOAMTU
*                           CURRENCY IT_TAB1-ZFUSD,120 SY-VLINE.
* ENDLOOP.
*
*ENDFORM.                    " P3000_MULTIDATA

*&---------------------------------------------------------------------
*&      Form  P3000_MULTIDATAWRITE
*&---------------------------------------------------------------------
*FORM P3000_MULTIDATAWRITE.
* LOOP AT IT_TAB2.
*   WRITE:/  SY-VLINE, (20) ' ',
*            SY-VLINE, (15) ' ',
*            SY-VLINE, (26) ' ',
*            SY-VLINE, (20) ' ',
*            SY-VLINE, (10) ' ',
*            SY-VLINE, (10) ' ',        120 SY-VLINE,
*        /   SY-VLINE, (20)  IT_TAB2-ZFSDOC,
*            SY-VLINE, (15)  IT_TAB2-STAWN,   "  HS ��ȣ',
*            SY-VLINE, (26)  IT_TAB2-ZFGODS1 ,"  ǰ�� ',
*            SY-VLINE,  (3)  IT_TAB2-WAERS,
*                      (16) IT_TAB2-ZFGOAMT CURRENCY IT_TAB2-WAERS,
*"�ݾ�'
*            SY-VLINE, (10) IT_TAB2-ZFEXDT," ��ȿ����',
*            SY-VLINE, (10) IT_TAB2-ZFSPDT, 120 SY-VLINE,
*        /   SY-VLINE, (20) IT_TAB2-ZFSDNO,
*            SY-VLINE, (15) ' ',  "  HS ��ȣ',
*            SY-VLINE, (26) ' ',"  ǰ�� ',
*            SY-VLINE, (3)  ' ',
*                      (16) ' ',"  �ݾ�'
*            SY-VLINE, (10) ' '," ��ȿ����',
*            SY-VLINE, (10) ' ', 120 SY-VLINE.
* ENDLOOP.
*
*ENDFORM.                    " P3000_MULTIDATAWRITE
