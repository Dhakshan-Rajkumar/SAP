*&---------------------------------------------------------------------*
*& Report  ZRIMBWGILST                                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �ⳳ�� ��Ȳ                                           *
*&      �ۼ��� : �̽��� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.09.19                                            *
*&---------------------------------------------------------------------*
*&  DESC.      :
*&                LIST-UP
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMTAXBKLST   MESSAGE-ID ZIM
                       LINE-SIZE 130
                       NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------*
*          TABLE,DATA, DEFINE                                          *
*----------------------------------------------------------------------*

TABLES : ZTTAXBKHD,
         EKKO,
         EKPO,
         ZTTAXBKIT.

DATA   : W_ERR_CHK TYPE C VALUE 'N',   "ERROR CHECK.
         W_LINE  TYPE I,               "IT_TAB LINE ��.
         W_LINE1 TYPE I,              "�Ұ�� LINE ��.
         W_SUM   LIKE ZTREQHD-ZFLASTAM, "��ȭ �Ұ��.
         W_TOTAL LIKE ZTREQHD-ZFLASTAM, "��ȭ �Ѱ��.
         W_WERKS LIKE EKPO-WERKS,     "�����.
         W_PRI LIKE ZTREQIT-NETPR,    "�ܰ�.
         W_FOR LIKE ZTREQHD-ZFLASTAM, "��ȭ.
         W_WON LIKE ZTREQHD-ZFLASTAM, "��ȭ.
         W_MOD LIKE SY-TABIX,         "Ȧ¦.
         W_TABIX LIKE SY-TABIX.


DATA   : BEGIN OF IT_TAB OCCURS 0,
        ZFTBNO   LIKE ZTTAXBKHD-ZFTBNO,    "CHAR10�ⳳ�� ������ȣ
*>>��� MAIN.
        ZFEBELN  LIKE ZTTAXBKHD-EBELN,     "10���Ź�����ȣ
        EBELN    LIKE ZTTAXBKHD-EBELN,     "10���Ź�����ȣ
        BASISNO  LIKE ZTTAXBKHD-BASISNO,   "22�ٰż�����ȣ(���μ� ��ȣ)
        ZFTRNSNM LIKE ZTTAXBKHD-ZFTRNSNM,  "40�絵�� ��ȣ
        ZFRVDT   LIKE ZTTAXBKHD-ZFRVDT,    "8������
        ZFBUYMN  LIKE ZTTAXBKHD-ZFBUYMN,   "QUAN13.3�絵(����)����
        MEINS    LIKE ZTTAXBKHD-MEINS,	  "UNIT3�⺻����
        ZFTBAK   LIKE ZTTAXBKHD-ZFTBAK, "CURR14.2��������-��ȭ(���ް���)
        ZFKRW    LIKE ZTTAXBKHD-ZFKRW,     "CUKY5��ȭ��ȭ
        ZFREQNO  LIKE ZTTAXBKHD-ZFREQNO,   "10�����Ƿ� ������ȣ
        ZFTBPNO  LIKE ZTTAXBKHD-ZFTBPNO,
                            "12������ȣ[����(3)+����(2)+�Ϸù�ȣ(7)]
        ZFSELSNM LIKE ZTTAXBKHD-ZFSELSNM,  "40����� ��ȣ
        ZFBUYDT  LIKE ZTTAXBKHD-ZFBUYDT,   "8�絵(����)����
        STAWN    LIKE ZTTAXBKHD-STAWN,     "17�ؿܹ����ǻ�ǰ�����ڵ��ȣ
        ZFCUAMT  LIKE ZTTAXBKHD-ZFCUAMT,   "CURR14.2����
*>> HD ����
        BUKRS    LIKE ZTTAXBKHD-BUKRS,	  "CHAR4ȸ���ڵ�
        ZFPOSYN  LIKE ZTTAXBKHD-ZFPOSYN,   "1  ��ǥó������
        ZFACDO   LIKE ZTTAXBKHD-ZFACDO,    "10 ȸ����ǥ ��ȣ
        BELNR    LIKE ZTTAXBKHD-BELNR,     "10 ȸ����ǥ��ȣ
        ZFFIYR   LIKE ZTTAXBKHD-ZFFIYR,    "ȸ����ǥ ����
        GJAHR    LIKE ZTTAXBKHD-GJAHR,     "ȸ�迬��
*>> KEY---ZTTAXBKIT
        ZFTBIT   LIKE ZTTAXBKIT-ZFTBIT,    "�ⳳ�� Item No.(���ȣ)
*>>��� SUB.
        MATNR    LIKE ZTTAXBKIT-MATNR,     "18 �����ȣ
        TXZ01    LIKE ZTTAXBKIT-TXZ01,     "40 ����(ǰ��)
        BKMENGE  LIKE ZTTAXBKIT-BKMENGE,   "QUAN13.3�ⳳ�� ����
*> ���� ����.
        MEINS_IT  LIKE ZTTAXBKIT-MEINS,     "UNIT3�⺻����
        ZFTBAK_IT LIKE ZTTAXBKIT-ZFTBAK,"CURR14.2��������-��ȭ(���ް���)
        ZFCUAMT_IT LIKE ZTTAXBKIT-ZFCUAMT,   "����
*>> IT ����
        EBELP    LIKE ZTTAXBKIT-EBELP.     "���Ź��� ǰ���ȣ
*>> ���� �� ����.
*       EBELN     ���Ź�����ȣ
*       ZFREQNO  �����Ƿ� ������ȣ
*       ZFITMNO  ���Թ��� ǰ���ȣ
*       STAWN    �ؿܹ����� ��ǰ�ڵ�/�����ڵ��ȣ
DATA   : END OF IT_TAB.


*----------------------------------------------------------------------*
*          SELECTION-SCREEN                                            *
*----------------------------------------------------------------------*

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS :
            S_BUKRS  FOR ZTTAXBKHD-BUKRS,    "ȸ���ڵ�
            S_EBELN  FOR ZTTAXBKHD-EBELN,    "P/O
            S_EKGRP  FOR EKKO-EKGRP,
            S_WERKS  FOR EKPO-WERKS,
            S_REQNO  FOR ZTTAXBKHD-ZFREQNO,  "�����Ƿ�
            S_BASIS  FOR ZTTAXBKHD-BASISNO,  "�ٰż���(���ι�ȣ)
            S_TBPNO  FOR ZTTAXBKHD-ZFTBPNO,  "������ȣ
            S_TRNSNM FOR ZTTAXBKHD-ZFTRNSNM, "�絵��

            S_ACDO   FOR ZTTAXBKHD-ZFACDO,   "��빮�� ��ȣ
            S_BELNR  FOR ZTTAXBKHD-BELNR,    "��ǥ��ȣ
            S_BUYDT  FOR ZTTAXBKHD-ZFBUYDT,  "��������
            S_POSYN  FOR ZTTAXBKHD-ZFPOSYN.  "���⿩��

SELECTION-SCREEN END OF BLOCK B1.

*----------------------------------------------------------------------*
*          INITIALIZATION.                                             *
*----------------------------------------------------------------------*

INITIALIZATION.                          " �ʱⰪ SETTING
  CLEAR IT_TAB.
  REFRESH IT_TAB.

*----------------------------------------------------------------------*
*          START-OF-SELECTION.                                         *
*----------------------------------------------------------------------*
START-OF-SELECTION.

*>>> READ TABLE
  PERFORM   P1000_READ_TAB.
*>>> SORT-GROUP:
  SORT IT_TAB BY ZFTBNO EBELN ZFREQNO ZFTBIT.
*>>> WRITE LIST
  PERFORM   P3000_WRITE_IT.

*----------------------------------------------------------------------*
*           TOP-OF-PAGE                                                *
*----------------------------------------------------------------------*
TOP-OF-PAGE.

  FORMAT RESET.
  WRITE : /50 '[   �� �� ��   �� Ȳ   ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  SKIP.
      FORMAT COLOR 1 INTENSIFIED ON.
      WRITE :/ SY-ULINE(130).
      WRITE :/ SY-VLINE NO-GAP,(10) 'P/O ��ȣ'  CENTERED  NO-GAP,
               SY-VLINE NO-GAP,(22) '�ٰż���'  CENTERED  NO-GAP,
               SY-VLINE NO-GAP,(35) '�� �� ��'  CENTERED  NO-GAP,
               SY-VLINE NO-GAP, (14) '��������'  CENTERED  NO-GAP,
               SY-VLINE NO-GAP,(18) '���Թ���'  CENTERED  NO-GAP,
               SY-VLINE NO-GAP,(21) '���ް���' CENTERED  NO-GAP.
      WRITE : 130 SY-VLINE.
      FORMAT COLOR 1 INTENSIFIED OFF.
      WRITE :/
               SY-VLINE NO-GAP,(10) '�����Ƿ�' CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(22) '������ȣ' CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(35) '�� �� ��'   CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(14)  '��������' CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(18) 'H/S CODE' CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(21) '��    ��' CENTERED   NO-GAP.
      WRITE : 130 SY-VLINE.

      FORMAT COLOR 2 INTENSIFIED ON.
      WRITE :/
               SY-VLINE NO-GAP,(10) 'Item'                      NO-GAP,
               SY-VLINE NO-GAP,(22) '�����ڵ�'   CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(35) 'ǰ    ��'   CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(14) '��    ��'   CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(18) '���ް���'   CENTERED   NO-GAP,
               SY-VLINE NO-GAP,(21) '��    ��'   CENTERED   NO-GAP.
      WRITE : 130 SY-VLINE.
      WRITE :/ SY-ULINE(130).


*-----------------------------------------------------------------------
* User Command
*
*-----------------------------------------------------------------------
AT USER-COMMAND.

 CASE SY-UCOMM.
*>>>>P/O CALL
      WHEN 'PODP'.
          IF W_TABIX EQ 0. MESSAGE E962 .
          ELSE.
             IF NOT IT_TAB-EBELN IS INITIAL.
                PERFORM  P2000_PO_DOC_DISPLAY(SAPMZIM01)
                         USING IT_TAB-EBELN ''.
             ENDIF.
          ENDIF.
*>>>>�����Ƿ� CALL
      WHEN 'LCDP'.
          IF W_TABIX EQ 0. MESSAGE E962.
          ELSE.
          PERFORM P2000_SHOW_LC USING  IT_TAB-ZFREQNO.
          ENDIF.
*>> �ⳳ�� CALL
      WHEN 'TBDP'.
          IF W_TABIX EQ 0. MESSAGE E962.
          ELSE.
             SET PARAMETER ID 'BES'     FIELD ''.
             SET PARAMETER ID 'ZPREQNO' FIELD ''.
             SET PARAMETER ID 'ZPOPNNO' FIELD ''.
             SET PARAMETER ID 'ZPTBNO'  FIELD IT_TAB-ZFTBNO.
             CALL TRANSACTION 'ZIMZ3' AND SKIP FIRST SCREEN.
          ENDIF.

*>>>>��빮�� CALL
*--> BUKRS  CHAR4ȸ���ڵ�
*--> ZFACDO CHAR10 ȸ����ǥ ��ȣ
*--> ZFFIYR ȸ����ǥ ����


      WHEN 'ZIMY'.
          IF W_TABIX EQ 0. MESSAGE E962.
          ELSE.
          PERFORM P2000_SHOW_ZIMY3 USING IT_TAB-BUKRS
                                         IT_TAB-ZFFIYR
                                         IT_TAB-ZFACDO.
          ENDIF.

*>>>>ȸ����ǥ CALL
*--> BELNR CHAR10 ȸ����ǥ��ȣ
*--> GJAHR ȸ�迬��
      WHEN 'FIDS'.
          IF W_TABIX EQ 0. MESSAGE E962.
          ELSE.
          PERFORM P2000_FI_MIR4_FB03 USING IT_TAB-BUKRS
                                           IT_TAB-GJAHR
                                           IT_TAB-BELNR.
          ENDIF.
 ENDCASE.
 CLEAR: IT_TAB ,W_TABIX.

*>>>>P/O CALL
*--->EBELN     ���Ź�����ȣ
*--->EBELP     ���Ź��� ǰ���ȣ
*WHEN 'PODP'.
*        IF NOT IT_TAB-EBELN IS INITIAL.
*            SET PARAMETER ID 'BES' FIELD IT_TAB-EBELN.
*            CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
*         ENDIF.
*

*>>>>�����Ƿ� CALL
*--->ZFREQNO  �����Ƿ� ������ȣ
*PERFORM P2000_SHOW_LC USING  IT_SELECTED-ZFREQNO
*                                         IT_SELECTED-ZFAMDNO.
*FORM P2000_SHOW_LC USING    P_ZFREQNO P_ZFAMDNO.
*
*  SET PARAMETER ID 'BES'       FIELD ''.
*  SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
*  SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
*  SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
*  EXPORT 'BES'           TO MEMORY ID 'BES'.
*  EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
*  EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.
*  EXPORT 'ZPAMDNO'       TO MEMORY ID 'ZPAMDNO'.
*
*  IF P_ZFAMDNO = '00000'.
*      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
*  ELSE.
*      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
*  ENDIF.
*
*ENDFORM.                    " P2000_SHOW_LC

*>>>>��빮�� CALL
*--->*s BUKRS	  "CHAR4ȸ���ڵ�
*--->#*s ZFACDO         "CHAR10 ȸ����ǥ ��ȣ
*---> ZFFIYRȸ����ǥ ����
*---> GJAHRȸ�迬��
*FORM P4000_DISPLAY_DOCUMENT.
*
*   LOOP  AT  IT_SELECTED.
*
*      SET  PARAMETER ID  'BUK'       FIELD   IT_SELECTED-BUKRS.
*      SET  PARAMETER ID  'GJR'       FIELD   IT_SELECTED-GJAHR.
*      SET  PARAMETER ID  'ZPBENR'    FIELD   IT_SELECTED-BELNR.
*      CALL TRANSACTION 'ZIMY3'.
*
*   ENDLOOP.
*
*ENDFORM.                    " P4000_DISPLAY_DOCUMENT

*>>>>ȸ����ǥ CALL
*--->BELNR          "CHAR10 ȸ����ǥ��ȣ


*FORM P2000_FI_DOCUMENT_DISPLAY USING    P_BUKRS
*                                        P_GJAHR
*                                        P_BELNR.
*
*   IF P_BELNR IS INITIAL.
*      MESSAGE S589.   EXIT.
*   ELSE.
**>>> LIV ��ǥ��ȣ����, ȸ����ǥ������ ����.
*      SELECT * FROM EKBZ UP TO 1 ROWS
*               WHERE BELNR EQ P_BELNR
*               AND   GJAHR EQ P_GJAHR.
*      ENDSELECT.
*      IF SY-SUBRC NE 0.
*         SELECT * FROM EKBE UP TO 1 ROWS
*                  WHERE BELNR EQ P_BELNR
*                  AND   GJAHR EQ P_GJAHR.
*         ENDSELECT.
*      ENDIF.
*      IF SY-SUBRC EQ 0.
*         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
*         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
*         SET PARAMETER ID 'RBN'    FIELD P_BELNR.
*         CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
*      ELSE.
*         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
*         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
*         SET PARAMETER ID 'BLN'    FIELD P_BELNR.
*         CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
*      ENDIF.
*   ENDIF.
*
*ENDFORM.                    " P2000_FI_DOCUMENT_DISPLAY











*DATA : W_COUNT    TYPE I,
*       saupja_no(15),
*       pre_dty_val(17),
*       zfblno(10) type c,
*       bank_nm(20) type c,
*       cntr_nm(50) type c,
*       objt_cd(840) type c,
*       arr_area_txt(70) type c,
*       st_area_txt(70) type c,
*       last_area_txt(70) type c,
*       clm_agent(300) type c,
*       svy_agent(300) type c,
*       yak_cd(005)    type c,
*       yak_nm_yak(30) type c,
*       inga_nm(300)   type c,
*
*       cont_date(9)   type c,
*       prt_bal_date   type d,
*       pre_inv_val(30)    type c.
**  EXEC SQL PERFORMING  loop_output.
**     SELECT count( * )
**            INTO :w_count
**            FROM  ztbl
**            WHERE zfblno >= :'1000000000'
**  ENDEXEC.
**   EXEC SQL PERFORMING  loop_output1.
**      SELECT yak_id, yak_nm_yak, inga_nm
**            INTO :yak_cd, :yak_nm_yak, :inga_nm
**            FROM zlgitmva0
**   ENDEXEC.
*   EXEC SQL PERFORMING  loop_output.
*     SELECT  saupja_no,
*             bank_nm, cntr_nm, objt_cd, arr_area_txt, st_area_txt,
*             last_area_txt, clm_agent, svy_agent, cont_date,
*             pre_inv_val, prt_bal_date, pre_dty_val
*         INTO :saupja_no,
*              :bank_nm, :cntr_nm, :objt_cd, :arr_area_txt
*              :st_area_txt, :last_area_txt, :clm_agent,
*              :svy_agent, :cont_date, :pre_inv_val, :prt_bal_date,
*              :pre_dty_val
*         FROM zlgitmv20
*   ENDEXEC.
**         FROM tmv20@lgi.world
**            FROM tmv20@lgc_to_lgi
**         FROM tmv20@lgc_to_lgi
*form loop_output.
*  WRITE : / saupja_no, cont_date, pre_inv_val, prt_bal_date,
*            pre_dty_val.
**      bank_nm, cntr_nm, objt_cd, arr_area_txt, st_area_txt,
**              last_area_txt, clm_agent, svy_agent.
*endform.
*
*form loop_output1.
*  WRITE : / inga_nm.
*
*endform.
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P1000_READ_TAB.
*  CLEAR IT_TAB.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
           FROM ZTTAXBKHD AS H JOIN ZTTAXBKIT AS I
             ON H~ZFTBNO EQ I~ZFTBNO
           WHERE H~BUKRS    IN S_BUKRS
             AND H~EBELN    IN S_EBELN
             AND H~ZFREQNO  IN S_REQNO
             AND H~BASISNO  IN S_BASIS
             AND H~ZFTBPNO  IN S_TBPNO
             AND H~ZFTRNSNM IN S_TRNSNM
             AND H~ZFACDO   IN S_ACDO
             AND H~BELNR    IN S_BELNR
             AND H~ZFBUYDT  IN S_BUYDT
             AND H~ZFPOSYN  IN S_POSYN.
  IF SY-SUBRC NE 0.  MESSAGE S738. EXIT. ENDIF.
  LOOP AT IT_TAB.
      W_TABIX = SY-TABIX.
      CLEAR ZTTAXBKIT.
      SELECT SINGLE * FROM ZTTAXBKIT
              WHERE ZFTBNO EQ IT_TAB-ZFTBNO
                AND ZFTBIT EQ IT_TAB-ZFTBIT.
     CLEAR EKKO.
     SELECT SINGLE *
            FROM  EKKO
           WHERE EBELN = IT_TAB-EBELN
             AND EKGRP IN S_EKGRP.
     IF SY-SUBRC NE 0.
        DELETE IT_TAB INDEX W_TABIX.
        CONTINUE.
     ENDIF.
     SELECT SINGLE *
            FROM EKPO
           WHERE EBELN = IT_TAB-EBELN
             AND EBELP = IT_TAB-EBELP
             AND WERKS  IN S_WERKS.
     IF SY-SUBRC NE 0.
         DELETE IT_TAB INDEX W_TABIX.
         CONTINUE.
     ENDIF.

     SELECT SINGLE * FROM ZTTAXBKHD
            WHERE  ZFTBNO EQ IT_TAB-ZFTBNO.

     MOVE  ZTTAXBKHD-EBELN TO IT_TAB-ZFEBELN.
     MOVE  ZTTAXBKIT-MEINS TO IT_TAB-MEINS_IT.
     MOVE  ZTTAXBKIT-ZFTBAK TO IT_TAB-ZFTBAK_IT.
     MOVE  ZTTAXBKIT-ZFCUAMT TO IT_TAB-ZFCUAMT_IT.
     MODIFY IT_TAB INDEX W_TABIX.
     CLEAR W_TABIX.
  ENDLOOP.

ENDFORM.                    " P1000_READ_TAB
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_IT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P3000_WRITE_IT.

  SET TITLEBAR 'ZIMZ4'.
  SET PF-STATUS 'ZIMZ4'.
  DESCRIBE TABLE IT_TAB LINES W_LINE.
  CLEAR : IT_TAB,W_TABIX.
  LOOP AT IT_TAB.
    W_TABIX = SY-TABIX.
    FORMAT RESET.
    ON CHANGE OF IT_TAB-ZFTBNO.
      FORMAT COLOR 1 INTENSIFIED ON.
      IF W_TABIX NE 1.
         WRITE :/ SY-ULINE(130).
      ENDIF.
      WRITE :/ SY-VLINE NO-GAP,(10) IT_TAB-ZFEBELN    NO-GAP,
               SY-VLINE NO-GAP,(22) IT_TAB-BASISNO    NO-GAP,
               SY-VLINE NO-GAP,(35) IT_TAB-ZFTRNSNM   NO-GAP,
               SY-VLINE NO-GAP, (14) IT_TAB-ZFRVDT     NO-GAP,
               SY-VLINE NO-GAP,(15) IT_TAB-ZFBUYMN
                               UNIT IT_TAB-MEINS      NO-GAP,
                                (3) IT_TAB-MEINS      NO-GAP,
               SY-VLINE NO-GAP,(16) IT_TAB-ZFTBAK
                               CURRENCY IT_TAB-ZFKRW  NO-GAP,
                                (5) IT_TAB-ZFKRW      NO-GAP.
       WRITE : 130 SY-VLINE.
      HIDE: IT_TAB, W_TABIX.
      FORMAT COLOR 1 INTENSIFIED OFF.
      WRITE :/
               SY-VLINE NO-GAP,(10) IT_TAB-ZFREQNO    NO-GAP,
               SY-VLINE NO-GAP,(22) IT_TAB-ZFTBPNO    NO-GAP,
               SY-VLINE NO-GAP,(35) IT_TAB-ZFSELSNM   NO-GAP,
               SY-VLINE NO-GAP, (14) IT_TAB-ZFBUYDT    NO-GAP,
               SY-VLINE NO-GAP,(18) IT_TAB-STAWN      NO-GAP,
               SY-VLINE NO-GAP,(16) IT_TAB-ZFCUAMT
                               CURRENCY IT_TAB-ZFKRW  NO-GAP,
                                (5) IT_TAB-ZFKRW      NO-GAP.
      WRITE : 130 SY-VLINE.

      HIDE: IT_TAB, W_TABIX.
    ENDON.
    W_MOD = SY-TABIX MOD 2.
    IF W_MOD = 1.
       FORMAT RESET.
       FORMAT COLOR 2 INTENSIFIED ON.
    ELSE.
       FORMAT RESET.
       FORMAT COLOR 2 INTENSIFIED OFF.
    ENDIF.
    WRITE :/
             SY-VLINE NO-GAP,(10) IT_TAB-ZFTBIT      NO-GAP,
             SY-VLINE NO-GAP,(22) IT_TAB-MATNR       NO-GAP,
             SY-VLINE NO-GAP,(35) IT_TAB-TXZ01 NO-GAP, "ZFTRNSNM
             SY-VLINE NO-GAP,(12) IT_TAB-BKMENGE
                                UNIT IT_TAB-MEINS    NO-GAP,
                              (2) IT_TAB-MEINS_IT    NO-GAP,
             SY-VLINE NO-GAP,(15) IT_TAB-ZFTBAK_IT
                               CURRENCY IT_TAB-ZFKRW NO-GAP,
                               (3) IT_TAB-ZFKRW      NO-GAP,
             SY-VLINE NO-GAP,(16) IT_TAB-ZFCUAMT_IT
                               CURRENCY IT_TAB-ZFKRW NO-GAP,
                              (3) IT_TAB-ZFKRW       NO-GAP.
    WRITE : 130 SY-VLINE.
    HIDE: IT_TAB, W_TABIX.
    AT LAST.
       WRITE :/ SY-ULINE(130).
       WRITE : /5 W_LINE , '��'.
    ENDAT.
  ENDLOOP.
  CLEAR: IT_TAB, W_TABIX.

ENDFORM.                    " P3000_WRITE_IT
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_ZFREQNO  text
*      -->P_ENDIF  text
*----------------------------------------------------------------------*
FORM P2000_SHOW_LC USING    P_ZFREQNO.
*                            P_ZFAMDNO.

  SET PARAMETER ID 'BES'       FIELD ''.
  SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
  SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
  SET PARAMETER ID 'ZPAMDNO'   FIELD ''.
  EXPORT 'BES'           TO MEMORY ID 'BES'.
  EXPORT 'ZPREQNO'       TO MEMORY ID 'ZPREQNO'.
  EXPORT 'ZPOPNNO'       TO MEMORY ID 'ZPOPNNO'.
  EXPORT 'ZPAMDNO'       TO MEMORY ID 'ZPAMDNO'.

*  IF P_ZFAMDNO = '00000'.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
*  ELSE.
*      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
*  ENDIF.


ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_ZIMY3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_BUKRS  text
*      -->P_IT_TAB_ZFFIYR  text
*      -->P_IT_TAB_ZFACDO  text
*----------------------------------------------------------------------*
FORM P2000_SHOW_ZIMY3 USING    P_BUKRS
                               P_ZFFIYR
                               P_ZFACDO.
       IF P_ZFACDO IS INITIAL.
          MESSAGE S589.   EXIT.
       ELSE.
       SET  PARAMETER ID  'BUK'       FIELD   P_BUKRS.
       SET  PARAMETER ID  'GJR'       FIELD   P_ZFFIYR.
       SET  PARAMETER ID  'ZPBENR'    FIELD   P_ZFACDO.
       CALL TRANSACTION 'ZIMY3'.
       ENDIF.

ENDFORM.                    " P2000_SHOW_ZIMY3
*&---------------------------------------------------------------------*
*&      Form  P2000_FI_MIR4_FB03
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_TAB_BUKRS  text
*      -->P_IT_TAB_GJAHR  text
*      -->P_IT_TAB_BELNR  text
*----------------------------------------------------------------------*
FORM P2000_FI_MIR4_FB03 USING    P_BUKRS
                                 P_GJAHR
                                 P_BELNR.
   IF P_BELNR IS INITIAL.
      MESSAGE S589.   EXIT.
   ELSE.
*>>> LIV ��ǥ��ȣ����, ȸ����ǥ������ ����.
*      SELECT * FROM EKBZ UP TO 1 ROWS
*               WHERE BELNR EQ P_BELNR
*               AND   GJAHR EQ P_GJAHR.
*      ENDSELECT.
*      IF SY-SUBRC NE 0.
*         SELECT * FROM EKBE UP TO 1 ROWS
*                  WHERE BELNR EQ P_BELNR
*                  AND   GJAHR EQ P_GJAHR.
*         ENDSELECT.
*      ENDIF.
*      IF SY-SUBRC EQ 0.
*         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
*         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
*         SET PARAMETER ID 'RBN'    FIELD P_BELNR.
*         CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
*      ELSE.
         SET PARAMETER ID 'BUK'    FIELD P_BUKRS.
         SET PARAMETER ID 'GJR'    FIELD P_GJAHR.
         SET PARAMETER ID 'BLN'    FIELD P_BELNR.
         CALL TRANSACTION 'FB03' AND SKIP  FIRST SCREEN.
*      ENDIF.
   ENDIF.
ENDFORM.                    " P2000_FI_MIR4_FB03
