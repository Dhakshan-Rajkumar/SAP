*----------------------------------------------------------------------*
*   INCLUDE ZRIM09F01                                                  *
*----------------------------------------------------------------------*
*&  ���α׷��� : ����â�� ������ SUB MODULE Include                  *
*&      �ۼ��� : ��ä�� INFOLINK Ltd.
*&
*&      �ۼ��� : 2001.08.17                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_GUI_TEXT
*&---------------------------------------------------------------------*
FORM P2000_SET_GUI_TEXT.

   CASE W_STATUS.
      WHEN C_REQ_C.   ASSIGN W_CREATE  TO <FS_F>.
      WHEN C_REQ_U.   ASSIGN W_CHANGE  TO <FS_F>.
      WHEN C_REQ_D.   ASSIGN W_DISPLAY TO <FS_F>.
      WHEN OTHERS.
   ENDCASE.

ENDFORM. "  P2000_SET_GUI_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PF_STATUS
*&---------------------------------------------------------------------*
FORM P2000_SET_PF_STATUS.

   CASE SY-TCODE.
      WHEN 'ZIMBG1' OR 'ZIMBG2' OR 'ZIMBG3' .      " ����,����,��ȸ.
         MOVE '0101' TO W_PFSTAT.
      WHEN OTHERS.
   ENDCASE.

ENDFORM.                    " P2000_SET_PF_STATUS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_STATUS_SCR_DISABLE
*&---------------------------------------------------------------------*
FORM P2000_SET_STATUS_SCR_DISABLE.

  CASE SY-DYNNR.
     WHEN  0101.              " ����ȭ��.
            IF SY-TCODE = 'ZIMBG1'.
               MOVE 'Create bonded warehouse G/I : details' TO W_TITLE.
               SET TITLEBAR  'TITLE' WITH W_TITLE.
               MOVE 'HIST' TO IT_EXCL-FCODE. APPEND IT_EXCL. " �������.
               MOVE 'HIIT' TO IT_EXCL-FCODE. APPEND IT_EXCL.   " ������.
               MOVE 'CRDC' TO IT_EXCL-FCODE. APPEND IT_EXCL.   " ����.
               MOVE 'DELE' TO IT_EXCL-FCODE. APPEND IT_EXCL.   " ����.
            ENDIF.
            IF SY-TCODE = 'ZIMBG2'.
               MOVE 'Change bonded warehouse G/I : details' TO W_TITLE.
               MOVE 'CHDC' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
               SET TITLEBAR  'TITLE' WITH W_TITLE.
            ENDIF.
            IF SY-TCODE = 'ZIMBG3'.
               MOVE 'Display bonded warehouse G/I : details' TO W_TITLE.
               SET TITLEBAR  'TITLE' WITH W_TITLE.
               MOVE 'DISP' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
               MOVE 'DELE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
               MOVE 'SAVE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            ENDIF.
      WHEN  0100.
            MOVE 'Create bonded warehouse G/I : initials' TO W_TITLE.
            SET TITLEBAR  'TITLE' WITH W_TITLE.
            MOVE 'HIST' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " �������.
            MOVE 'HIIT' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ������.
            MOVE 'CRDC' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'DELE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'SAVE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'DISP1' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP2' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP3' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP4' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'PRI'   TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.

      WHEN  0200.
            MOVE 'Change bonded warehouse G/I : initials' TO W_TITLE.
            SET TITLEBAR  'TITLE' WITH W_TITLE.
            MOVE 'HIST' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " �������.
            MOVE 'HIIT' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ������.
            MOVE 'CHDC' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'DELE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'SAVE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'DISP1' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP2' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP3' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP4' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'PRI'   TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
      WHEN  0300.
            MOVE 'Display bonded warehouse G/I : initials' TO W_TITLE.
            SET TITLEBAR  'TITLE' WITH W_TITLE.
            MOVE 'HIST' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " �������.
            MOVE 'HIIT' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ������.
            MOVE 'DISP' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DELE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'SAVE' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ����.
            MOVE 'DISP1' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP2' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP3' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'DISP4' TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.
            MOVE 'PRI'   TO IT_EXCL-FCODE.  APPEND IT_EXCL.   " ��ȸ.

      ENDCASE.

ENDFORM.                    " P2000_SET_STATUS_SCR_DISABLE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_BG_INIT_SCR
*&---------------------------------------------------------------------*
FORM P2000_SET_BG_INIT_SCR.

   MOVE 'DELE' TO IT_EXCL-FCODE.    APPEND IT_EXCL. " IMPORT IMG
   MOVE 'SAVE' TO IT_EXCL-FCODE.    APPEND IT_EXCL. " ����.

ENDFORM.                    " P2000_SET_BG_INIT_SCR
*&---------------------------------------------------------------------*
*&      Form  P2000_CC_DOC_ITEM_SELECT
*&---------------------------------------------------------------------*
FORM P2000_CC_DOC_ITEM_SELECT.

   W_ZFIVNO    = ZSIV-ZFIVNO.

   REFRESH IT_ZSIV.
* Table Multi-Select
   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIV
            FROM   ZVBL_IV
            WHERE  ZFHBLNO EQ ZSIV-ZFHBLNO.

  DESCRIBE TABLE IT_ZSIV LINES TFILL.
  IF TFILL = 0.
    MESSAGE E406.
  ENDIF.
* PERFORM   P2000_GET_POSITION.
  W_STATUS_CHK = 'C'.
  INCLUDE = 'CCHBL'.                 ">�����û ��ȸ.
  CALL SCREEN 0014 STARTING AT  07 3
                   ENDING   AT  70 15.

ENDFORM.                    " P2000_CC_DOC_ITEM_SELECT
*&---------------------------------------------------------------------*
*&      Form  P2000_CHECK_ZTIV
*&---------------------------------------------------------------------*
FORM P2000_CHECK_VALUES USING    P_ZFIVNO.

*>> �������
  SELECT SINGLE *
          FROM ZTIV
         WHERE ZFIVNO = P_ZFIVNO.
  IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE E679 WITH ZTIV-ZFBLNO.
  ENDIF.

  ZSIV-ZFBLNO = ZTIV-ZFBLNO.
  IF ZTIV-ZFCLCD NE 'A'.
      W_ERR_CHK = 'Y'.
      MESSAGE E445 WITH ZTIV-ZFBLNO.
  ENDIF.
*>> �������.
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDCUST' ZTIV-ZFCUST
                             CHANGING   W_DOM_TEX1.
  IF NOT ( ZTIV-ZFCUST = 'Y' OR ZTIV-ZFCUST = '3' ) .
     W_ERR_CHK = 'Y'.
     MESSAGE E419 WITH ZSIV-ZFIVNO W_DOM_TEX1 'Follow-up'.
  ENDIF.
*>> �԰����.
  PERFORM  GET_DD07T_SELECT(SAPMZIM00) USING 'ZDGRST' ZTIV-ZFGRST
                             CHANGING   W_DOM_TEX1.
  IF ZTIV-ZFGRST EQ 'Y'.
     W_ERR_CHK = 'Y'.
     MESSAGE E422 WITH ZSIV-ZFIVNO W_DOM_TEX1 'Follow-up'.
  ENDIF.

ENDFORM.                    " P2000_CHECK_VALUES
*&---------------------------------------------------------------------*
*&      Form  P2000_DATA_LISTING
*&---------------------------------------------------------------------*
FORM P2000_DATA_LISTING.

  CASE INCLUDE.
    WHEN 'CCHBL' OR 'CCBL'.   "> �����û.(HOUSE B/L �Է½�)
       PERFORM P3000_ZTIV_TITLELIST.
       LOOP AT IT_ZSIV.
          W_MOD = SY-TABIX MOD 2.
          PERFORM P2000_ZTIV_DUP_LIST_1.
       ENDLOOP.
       WRITE : / SY-ULINE(61).
       CLEAR : IT_ZSIV.
    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " P2000_DATA_LISTING
*&---------------------------------------------------------------------*
*&      Form  P2000_ZTIV_DUP_LIST_1
*&---------------------------------------------------------------------*
FORM P2000_ZTIV_DUP_LIST_1.

  FORMAT RESET.
  WRITE : / SY-VLINE, IT_ZSIV-ZFIVNO COLOR COL_KEY INTENSIFIED,
             SY-VLINE.
  IF W_MOD EQ 0.
     FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  ELSE.
     FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.

  WRITE : IT_ZSIV-ZFCCDT,   SY-VLINE.

*>> ��� ����.
  CASE IT_ZSIV-ZFCLCD.
     WHEN 'A'.
        WRITE : '�������', SY-VLINE.
     WHEN 'B'.
        WRITE : '�������', SY-VLINE.
     WHEN 'C'.
        WRITE : '������  ', SY-VLINE.
     WHEN 'X'.
        WRITE : '�����  ', SY-VLINE.
     WHEN OTHERS.
        WRITE : '        ', SY-VLINE.
  ENDCASE.
*>> �������.
  CASE IT_ZSIV-ZFCUST.
     WHEN '1'.
        WRITE : '�Ƿڻ���', SY-VLINE.
     WHEN '2'.
        WRITE : '�Ƿڴ��', SY-VLINE.
     WHEN '3'.
        WRITE : '�Ƿ� �� ', SY-VLINE.
     WHEN 'Y'.
        WRITE : '����Ϸ�', SY-VLINE.
     WHEN 'N'.
        WRITE : '����Ұ�', SY-VLINE.
  ENDCASE.
*>> ����� ����.
*  CASE IT_ZSIV-ZFCDST.
*     WHEN 'N'.
*        WRITE : '��� ���', SY-VLINE.
*     WHEN 'Y'.
*        WRITE : '��� �Ϸ�', SY-VLINE.
*     WHEN 'X'.
*        WRITE : '��� �Ұ�', SY-VLINE.
*  ENDCASE.
*>> �԰����.
  CASE IT_ZSIV-ZFGRST.
     WHEN 'Y'.
        WRITE : '�԰� �Ϸ�', SY-VLINE.
     WHEN 'N'.
        WRITE : '�԰� ���', SY-VLINE.
     WHEN 'P'.
        WRITE : '���� �԰�', SY-VLINE.
     WHEN 'X'.
        WRITE : '�԰� �Ұ�', SY-VLINE.
  ENDCASE.
  HIDE IT_ZSIV.

ENDFORM.                    " P2000_ZTIV_DUP_LIST_1
*&---------------------------------------------------------------------*
*&      Form  P2000_SEARCH_FIELD_MOVE
*&---------------------------------------------------------------------*
FORM P2000_SEARCH_FIELD_MOVE.

  ZSIV-ZFIVNO  = W_ZFIVNO.

ENDFORM.                    " P2000_SEARCH_FIELD_MOVE
*&---------------------------------------------------------------------*
*&      Form  P2000_CC_DOC_ITEM_SELECT_1
*&---------------------------------------------------------------------*
FORM P2000_CC_DOC_ITEM_SELECT_1.

  W_ZFIVNO    = ZSIV-ZFIVNO.

  REFRESH IT_ZSIV.
* Table Multi-Select
   SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSIV
            FROM   ZTIV
            WHERE  ZFBLNO EQ ZSIV-ZFBLNO.
  DESCRIBE TABLE IT_ZSIV LINES TFILL.
  IF TFILL = 0.
    MESSAGE E406.
  ENDIF.
* PERFORM   P2000_GET_POSITION.
  W_STATUS_CHK = 'C'.
  INCLUDE = 'CCBL'.                 ">�����û ��ȸ.

  CALL SCREEN 0014 STARTING AT  07 3
                   ENDING   AT  70 10.

ENDFORM.                    " P2000_CC_DOC_ITEM_SELECT_1
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IV_DOC
*&---------------------------------------------------------------------*
FORM P1000_READ_BW_DOC.

  CASE SY-TCODE.
    WHEN 'ZIMBG1'.
         PERFORM P1000_READ_DATA_SRREEN100.
    WHEN 'ZIMBG2' OR 'ZIMBG3'.
         PERFORM P1000_READ_DATA_SRREEN200_300.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P1000_READ_BW_DOC
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA_SRREEN100
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA_SRREEN100.

  IF OK-CODE NE 'REF1'.  " ITEM �缱�ý�.
     CLEAR ZTBL.
     CLEAR ZTIV.
     SELECT SINGLE *
            FROM  ZTIV
            WHERE ZFIVNO = ZSIV-ZFIVNO.

     IF SY-SUBRC NE 0.
        MESSAGE E413 WITH ZSIV-ZFIVNO.
     ENDIF.
*>> 2002.4.table ����. �Ǿ ZTCUCLIV ZTCUCL  ZTCUCLHST ��� ����.
*     CLEAR ZTCUCLIV.
*     SELECT SINGLE *
*            FROM  ZTCUCLIV
*            WHERE ZFIVNO  = ZSIV-ZFIVNO.
*
     CLEAR ZTIDR.
     SELECT SINGLE *
            FROM  ZTIDR
            WHERE ZFIVNO = ZSIV-ZFIVNO.
*---------------------------------------------------------------------
     CLEAR ZTBL.
     SELECT SINGLE *
            FROM  ZTBL
            WHERE ZFBLNO = ZTIDR-ZFBLNO.
     ZSIV-ZFHBLNO = ZTBL-ZFHBLNO.

     CLEAR ZTBWHD.
     SELECT *
       FROM ZTBWHD
      WHERE ZFIVNO = ZSIV-ZFIVNO
        AND ZFBLNO = ZTBL-ZFBLNO.
        ADD ZTBWHD-ZFPKCN TO  W_ZFPKCN.
     ENDSELECT.
     CLEAR ZTBWHD.
     SELECT SUM( ZFTOWT )
            INTO W_ZFTOWT
            FROM ZTBWHD
            WHERE ZFIVNO = ZSIV-ZFIVNO
              AND ZFBLNO = ZTBL-ZFBLNO .
     SELECT SUM( ZFTOVL )
            INTO W_ZFTOVL
            FROM ZTBWHD
            WHERE ZFIVNO = ZSIV-ZFIVNO
              AND ZFBLNO = ZTBL-ZFBLNO .
     CLEAR ZTBLINR.
*>> ���߷�, ���尳��,����. B/L���� ���������� ���Ժ���.(2001.10.13)
     SELECT MAX( ZFBTSEQ )
            INTO W_ZFBTSEQ
            FROM ZTBLINR
            WHERE ZFBLNO = ZTBL-ZFBLNO.
     SELECT SINGLE *
             FROM  ZTBLINR
            WHERE ZFBLNO  = ZTBL-ZFBLNO
              AND ZFBTSEQ = W_ZFBTSEQ.

*     CLEAR ZTIDR.
*     SELECT SINGLE *
*        FROM ZTIDR
*       WHERE ZFBLNO  = ZTBL-ZFBLNO
*         AND ZFCLSEQ = ZTCUC-ZFCLSEQ.

     CLEAR ZTIDS.
     SELECT SINGLE *
           FROM  ZTIDS
           WHERE ZFIVNO  = ZSIV-ZFIVNO.

     ZTBWHD-ZFPKCN = ZTBLINR-ZFPKCN - W_ZFPKCN.
     IF ZTBWHD-ZFPKCN < 0.
        ZTBWHD-ZFPKCN = 0.
     ENDIF.
     ZTBWHD-ZFTOVL = ZTBL-ZFTOVL - W_ZFTOVL.
     IF ZTBWHD-ZFTOVL < 0.
        ZTBWHD-ZFTOVL = 0.
     ENDIF.
     ZTBWHD-ZFTOWT = ZTBLINR-ZFINWT - W_ZFTOWT.
     IF ZTBWHD-ZFTOWT < 0.
        ZTBWHD-ZFTOWT = 0.
     ENDIF.
     MOVE: ZSIV-ZFIVNO       TO  ZTBWHD-ZFIVNO,
           ZTIV-ZFIVAMC      TO  ZTBWHD-WAERS,     " NO
           ZTBL-ZFBLNO       TO  ZTBWHD-ZFBLNO,
           ZTBL-BUKRS        TO  ZTBWHD-BUKRS,
           ZTIDS-ZFCLSEQ     TO  ZTBWHD-ZFCLSEQ,
           ZTBL-ZFREBELN     TO  ZTBWHD-ZFREBELN,
           ZTBL-ZFBLSDP      TO  ZTBWHD-ZFBLSDP,   " �ۺ�ó.
           ZTIDR-ZFBNARCD    TO  ZTBWHD-ZFBNARCD,  " ���������ڵ�.
           ZTBLINR-ZFABNAR   TO  ZTBWHD-ZFABNAR,   " ������������
           ZTIDS-ZFIDWDT     TO  ZTBWHD-ZFIDWDT,   " �Ű������.
           ZTBL-ZFSHNO       TO  ZTBWHD-ZFSHNO,    " NO.
           ZTIDS-ZFIDSDT     TO  ZTBWHD-ZFIDSDT,   " NO.
           ZTBL-ZFPKCNM      TO  ZTBWHD-ZFPKCNM,   " �������.
           ZTBL-ZFTOWTM      TO  ZTBWHD-ZFTOWTM,   " ���߷�����.
           ZTBL-ZFTOVLM      TO  ZTBWHD-ZFTOVLM,   " �ѿ�������.
           SY-DATUM          TO  ZTBWHD-ZFGIDT.
      *ZTBWHD  = ZTBWHD.
  ENDIF.
*>> ITEM SELECT.
  REFRESH: IT_ZSBWIT.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBWIT
         FROM ZTIVIT
         WHERE ZFIVNO = ZTBWHD-ZFIVNO.


  LOOP AT IT_ZSBWIT.
     W_TABIX = SY-TABIX.

*>> �������.
        SELECT SUM( CCMENGE ) INTO IT_ZSBWIT-CCMENGE
            FROM ZTIVIT
            WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
              AND ZFIVDNO = IT_ZSBWIT-ZFIVDNO.
*>> �԰����.
        SELECT SUM( GRMENGE ) INTO IT_ZSBWIT-GRMENGE
            FROM ZTIVIT
            WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
              AND ZFIVDNO = IT_ZSBWIT-ZFIVDNO.

*>> B/L ����.
        SELECT SUM( BLMENGE )  INTO  IT_ZSBWIT-BLMENGE
           FROM ZTBLIT
           WHERE ZFBLNO = IT_ZSBWIT-ZFBLNO
             AND ZFBLIT = IT_ZSBWIT-ZFBLIT.

*>> ����� ����.
        SELECT SUM( GIMENGE ) INTO  IT_ZSBWIT-BWMENGE2
           FROM ZTBWIT
           WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
             AND ZFIVDNO = IT_ZSBWIT-ZFIVDNO.

*>> �ܷ����.(2001.11.08 ��ȯ���ö����� �԰���� ->> �������)
        IT_ZSBWIT-BWMENGE1 =
             IT_ZSBWIT-CCMENGE     " �������.
           - IT_ZSBWIT-BWMENGE2.   " �����

        IF IT_ZSBWIT-BWMENGE1 =< 0.
           DELETE IT_ZSBWIT INDEX W_TABIX.
           CONTINUE.
        ENDIF.

*>> ����� �⺻������ �ܷ����� �־���.
        MOVE  IT_ZSBWIT-BWMENGE1 TO IT_ZSBWIT-GIMENGE.
        CLEAR IT_ZSBWIT-BWMENGE1.
        MODIFY IT_ZSBWIT INDEX W_TABIX.
   ENDLOOP.

   DESCRIBE TABLE IT_ZSBWIT LINES W_LINE.
   IF W_LINE = 0.
      MESSAGE E676 WITH IT_ZSBWIT-ZFIVNO.
   ENDIF.
*>> ù��° ������ �÷�Ʈ �����´�.
   READ TABLE IT_ZSBWIT INDEX 1.
   SELECT SINGLE *
        FROM ZTBLIT
        WHERE ZFBLNO = IT_ZSBWIT-ZFBLNO
          AND ZFBLIT = IT_ZSBWIT-ZFBLIT.

   MOVE ZTBLIT-WERKS TO ZTBWHD-WERKS.
   IT_ZSBWIT_OLD[] = IT_ZSBWIT[].

ENDFORM.                    " P1000_READ_DATA_SRREEN100
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_DATA_SRREEN200_300
*&---------------------------------------------------------------------*
FORM P1000_READ_DATA_SRREEN200_300.

  IF OK-CODE NE 'REF1'.    " ITEM REFRESH ��.
     IF ZTBWHD-ZFGISEQ IS INITIAL.
        SELECT MAX( ZFGISEQ ) INTO ZTBWHD-ZFGISEQ
           FROM  ZTBWHD
           WHERE ZFIVNO = ZSIV-ZFIVNO.
     ENDIF.
     MOVE ZTBWHD-ZFGISEQ TO W_ZFGISEQ.

     CLEAR ZTBWHD.
     SELECT SINGLE *
            FROM  ZTBWHD
            WHERE ZFIVNO  = ZSIV-ZFIVNO
              AND ZFGISEQ = W_ZFGISEQ.
     ZTBWHD-ZFGISEQ = W_ZFGISEQ.
     IF SY-SUBRC NE 0.
        MESSAGE E673 WITH ZSIV-ZFIVNO ZTBWHD-ZFGISEQ.
     ENDIF.

*> LOCK OBJECT.....
     PERFORM  P2000_SET_LOCK_MODE USING 'L'.
     *ZTBWHD = ZTBWHD.

  ENDIF.
  REFRESH IT_ZSBWIT.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZSBWIT
            FROM  ZTBWIT
            WHERE ZFIVNO  = ZSIV-ZFIVNO
              AND ZFGISEQ = ZTBWHD-ZFGISEQ.

  LOOP AT IT_ZSBWIT.
        W_TABIX = SY-TABIX.
*>> �������.
        SELECT SUM( CCMENGE ) INTO IT_ZSBWIT-CCMENGE
            FROM ZTIVIT
            WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
              AND ZFIVDNO = IT_ZSBWIT-ZFIVDNO.
*>> �԰����.
        SELECT SUM( GRMENGE ) INTO IT_ZSBWIT-GRMENGE
            FROM ZTIVIT
            WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
              AND ZFIVDNO = IT_ZSBWIT-ZFIVDNO.

*>> B/L ����.
        SELECT SUM( BLMENGE )  INTO  IT_ZSBWIT-BLMENGE
           FROM ZTBLIT
           WHERE ZFBLNO = IT_ZSBWIT-ZFBLNO
             AND ZFBLIT = IT_ZSBWIT-ZFBLIT.
*>> ����� ����.
        SELECT SUM( GIMENGE ) INTO  IT_ZSBWIT-BWMENGE2
           FROM ZTBWIT
           WHERE ZFIVNO  = IT_ZSBWIT-ZFIVNO
             AND ZFIVDNO  = IT_ZSBWIT-ZFIVDNO.
*>> �ܷ�.(2001.11.9 ��ä�� ��ȯ �԰���� => �������)
        IT_ZSBWIT-BWMENGE1 = IT_ZSBWIT-CCMENGE -
                             IT_ZSBWIT-BWMENGE2.

        MODIFY IT_ZSBWIT INDEX W_TABIX.
  ENDLOOP.
  IT_ZSBWIT_OLD[] = IT_ZSBWIT[].  " CHANGE DOCUENT ��.

ENDFORM.                    " P1000_READ_DATA_SRREEN200_300
*&---------------------------------------------------------------------*
*&      Form  OK_CODE_0100
*&---------------------------------------------------------------------*
FORM OK_CODE_0100.

  CASE OK-CODE.
     WHEN  'CRDC'.
        LEAVE TO TRANSACTION 'ZIMBG1'.
     WHEN  'CHDC'.
        LEAVE TO TRANSACTION 'ZIMBG2'.
     WHEN 'DISP'.
        LEAVE TO TRANSACTION 'ZIMBG3'.
     WHEN 'DELE'.
        PERFORM  P2000_EXIT_PROCESS.
     WHEN 'DISP1'.  " B/L.
        PERFORM  P2000_DISP_ZTBL USING ZTBWHD-ZFBLNO.
     WHEN  'DISP2'.  " �����û.
        PERFORM  P2000_DISP_ZTIV USING ZTBWHD-ZFIVNO.
     WHEN  'DISP3'.  " ���ԽŰ�.
        PERFORM  P2000_DISP_ZTIDR USING ZTBWHD-ZFBLNO ZTBWHD-ZFCLSEQ.
     WHEN  'DISP4'.  " ���Ը���.
        PERFORM  P2000_DISP_ZTIDS USING ZTBWHD-ZFBLNO ZTBWHD-ZFCLSEQ.
     WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " OK_CODE_0100
*&---------------------------------------------------------------------*
*&      Form  OK_CODE_BACK_EXIT
*&---------------------------------------------------------------------*
FORM OK_CODE_BACK_EXIT.

  CASE OK-CODE.
    WHEN 'BACK' OR 'EXIT'.
       IF SY-DYNNR EQ '0101'.
          PERFORM  P2000_EXIT_PROCESS.
       ELSE.
          SET SCREEN 0. LEAVE TO SCREEN 0.
       ENDIF.
    WHEN  'PRI'.
        IF SY-TCODE EQ 'ZIMBG3'.
            PERFORM P2000_PRINT_ZTBW USING ZTBWHD-ZFIVNO ZTBWHD-ZFGISEQ.
        ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " OK_CODE_BACK_EXIT
*&---------------------------------------------------------------------*
*&      Form  P2000_SCR_MODE_SET
*&---------------------------------------------------------------------*
FORM P2000_SCR_MODE_SET.

  LOOP AT SCREEN.
    CASE W_STATUS.
       WHEN C_REQ_C OR C_REQ_U.   " ����, ����.
         IF SCREEN-GROUP1 = 'IO'.   SCREEN-INPUT   = '1'.
         ELSE.                      SCREEN-INPUT   = '0'.
         ENDIF.
         IF SCREEN-GROUP1 = 'I'.    SCREEN-INPUT   = '1'.   ENDIF.
       WHEN C_REQ_D.              " ��ȸ.
         IF SCREEN-GROUP1 = 'I'.    SCREEN-INPUT   = '1'.
         ELSE.                      SCREEN-INPUT   = '0'.
         ENDIF.
       WHEN OTHERS.
    ENDCASE.
    IF SCREEN-NAME(10) EQ 'W_ROW_MARK'.
       SCREEN-INPUT   = '1'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.                    " P2000_SCR_MODE_SET
*&---------------------------------------------------------------------*
*&      Form  P200_LEAV_SCREEN
*&---------------------------------------------------------------------*
FORM P200_LEAV_SCREEN.

  CASE SY-DYNNR.
     WHEN '100'.
       LEAVE TO TRANSACTION 'ZIMBG1'.
     WHEN '200'.
       LEAVE TO TRANSACTION 'ZIMBG2'.
     WHEN '300'.
       LEAVE TO TRANSACTION 'ZIMBG3'.
     WHEN OTHERS.
  ENDCASE.


ENDFORM.                    " P200_LEAV_SCREEN
*&---------------------------------------------------------------------*
*&      Form  P3000_DELETE_SCR0100
*&---------------------------------------------------------------------*
FORM P3000_DELETE_SCR0100.

ENDFORM.                    " P3000_DELETE_SCR0100
*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTBL
*&---------------------------------------------------------------------*
FORM P2000_DISP_ZTBL USING    P_ZFBLNO.

   SET PARAMETER ID 'ZPBLNO'  FIELD P_ZFBLNO.
   SET PARAMETER ID 'ZPHBLNO' FIELD ''.
   CALL TRANSACTION 'ZIM23'  AND SKIP  FIRST SCREEN.


ENDFORM.                    " P2000_DISP_ZTBL
*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIV
*&---------------------------------------------------------------------*
FORM P2000_DISP_ZTIV USING    P_ZFIVNO.

   SET PARAMETER ID 'ZPIVNO'  FIELD P_ZFIVNO.
   SET PARAMETER ID 'ZPHBLNO' FIELD ''.
   SET PARAMETER ID 'ZPBLNO'  FIELD ''.

   CALL TRANSACTION 'ZIM33'  AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_DISP_ZTIV
*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIDR
*&---------------------------------------------------------------------*
FORM P2000_DISP_ZTIDR USING    P_ZFBLNO
                               P_ZFCLSEQ.
  SET PARAMETER ID 'ZPHBLNO' FIELD ''.
  SET PARAMETER ID 'ZPBLNO'  FIELD  P_ZFBLNO.
  SET PARAMETER ID 'ZPCLSEQ' FIELD  P_ZFCLSEQ.
  CALL TRANSACTION 'ZIMCD2' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_DISP_ZTIDR
*&---------------------------------------------------------------------*
*&      Form  P2000_DISP_ZTIDS
*&---------------------------------------------------------------------*
FORM P2000_DISP_ZTIDS USING    P_ZFBLNO
                               P_ZFCLSEQ.

  SET PARAMETER ID 'ZPHBLNO' FIELD ''.
  SET PARAMETER ID 'ZPBLNO'  FIELD  P_ZFBLNO.
  SET PARAMETER ID 'ZPCLSEQ' FIELD  P_ZFCLSEQ.
  SET PARAMETER ID 'ZPENTNO' FIELD ' '.
  CALL TRANSACTION 'ZIMCC3' AND SKIP  FIRST SCREEN.

ENDFORM.                    " P2000_DISP_ZTIDS
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
FORM P2000_EXIT_PROCESS.

  IF NOT W_STATUS EQ C_REQ_D.
     PERFORM P2000_SET_MESSAGE USING  OK-CODE.
     CASE ANTWORT.
        WHEN 'Y'.              " Yes...
*-----------------------------------------------------------------------
* DB Write
*-----------------------------------------------------------------------
           PERFORM  P3000_DB_MODIFY_SCRCOM.
           IF W_OK_CODE = 'PRI'.
              PERFORM P2000_PRINT_ZTBW USING
                                      ZTBWHD-ZFIVNO ZTBWHD-ZFGISEQ.
           ENDIF.
           CLEAR OK-CODE.
           PERFORM  P2000_SET_LOCK_MODE USING 'U'.
           PERFORM  P2000_SET_SCREEN_SCRCOM.
           LEAVE SCREEN.
        WHEN 'N'.              " No...
           MESSAGE  S957.
           CLEAR OK-CODE.
           IF W_STATUS NE C_REQ_D.
              PERFORM  P2000_SET_LOCK_MODE USING 'U'.
           ENDIF.
           PERFORM  P2000_SET_SCREEN_SCRCOM.
           LEAVE SCREEN.
        WHEN 'C'.              " Cancel
        WHEN OTHERS.
     ENDCASE.

  ELSE.
     CLEAR OK-CODE.
     PERFORM  P2000_SET_SCREEN_SCRCOM.
     LEAVE SCREEN.
  ENDIF.

ENDFORM.                    " P2000_EXIT_PROCESS
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SET_MESSAGE USING     P_SY_UCOMM.

  W_OK_CODE =  P_SY_UCOMM.
  CASE P_SY_UCOMM.
    WHEN 'SAVE' OR 'PRI'.      " ����?
      PERFORM  P2000_SAVE_MESSAGE.
    WHEN 'CANC'.      " ���?
      PERFORM  P2000_CANCEL_MESSAGE.
    WHEN 'BACK' OR 'EXIT'.   " ������ or ����.
      PERFORM  P2000_EXIT_MESSAGE.
    WHEN 'DELE'.      " ����?
      PERFORM  P2000_DELETE_MESSAGE.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_SAVE_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                                  '�Էµ� ������ �����մϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'Y'                 " ��� ��?
                                  '1'.                      " default

ENDFORM.                    " P2000_SAVE_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_BOX
*&---------------------------------------------------------------------*
FORM P2000_MESSAGE_BOX USING    TITLE  LIKE SPOP-TITEL
                                TEXT1  LIKE SPOP-TEXTLINE1
                                TEXT2  LIKE SPOP-TEXTLINE2
                                CANCEL LIKE CANCEL_OPTION
                                DEFAULT LIKE OPTION.

  SPOP-TITEL = TITLE.
  SPOP-TEXTLINE1 = TEXT1.
  SPOP-TEXTLINE2 = TEXT2.
  IF CANCEL EQ 'Y'.
    CANCEL_OPTION = 'Y'.
  ELSE.
    CLEAR : CANCEL_OPTION.
  ENDIF.
  OPTION = DEFAULT.
  TEXTLEN = 40.

  CALL SCREEN 0001 STARTING AT 30 6
                      ENDING   AT 78 10.

  IF ANTWORT = 'C'.                                         " Cancel
    SET SCREEN SY-DYNNR.
  ENDIF.

ENDFORM.                    " P2000_MESSAGE_BOX
*&---------------------------------------------------------------------*
*&      Form  P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_CANCEL_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '��� Ȯ��'             " Ÿ��Ʋ...
                                  '����� ������ ������� ����˴ϴ�.'
                                  '�����Ͻðڽ��ϱ�?' " Message #2
                                  'N'                 " ��� ��?
                                  '2'.                      " default

  CASE ANTWORT.
    WHEN 'Y'.                                               " Yes...
      MESSAGE  S957.
      LEAVE TO SCREEN 0.  " " PROGRAM LEAVING
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_CANCEL_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_EXIT_MESSAGE.

  PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                          '���� �Է³����� �������� �ʽ��ϴ�.'   "
                          '���� �� �����Ͻðڽ��ϱ�?'       " MSG2
                          'Y'                         " ��� ��ư ?
                          '1'.                        " default button


ENDFORM.                    " P2000_EXIT_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P2000_DELETE_MESSAGE
*&---------------------------------------------------------------------*
FORM P2000_DELETE_MESSAGE.

   PERFORM P2000_MESSAGE_BOX USING '���� Ȯ��'             " Ÿ��Ʋ...
                          '���� Document�� �����մϴ�.'
                          '�����Ͻðڽ��ϱ�?'               " MSG2
                          'N'                 " ��� ��ư ��/?
                          '1'.                " default button


ENDFORM.                    " P2000_DELETE_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  P3000_DB_MODIFY_SCRCOM
*&---------------------------------------------------------------------*
FORM P3000_DB_MODIFY_SCRCOM.

   CASE SY-TCODE.
      WHEN 'ZIMBG1' OR 'ZIMBG2'.
         PERFORM P3000_CHARGE_DOC_MODIFY.
      WHEN OTHERS.
   ENDCASE.

ENDFORM.                    " P3000_DB_MODIFY_SCRCOM
*&---------------------------------------------------------------------*
*&      Form  P3000_CHARGE_DOC_MODIFY
*&---------------------------------------------------------------------*
FORM P3000_CHARGE_DOC_MODIFY.


  CLEAR W_COUNT.
  LOOP AT IT_ZSBWIT.
    W_TABIX = SY-TABIX.
    W_COUNT = W_COUNT + 1.
    IF IT_ZSBWIT-GIMENGE IS INITIAL.
       DELETE IT_ZSBWIT INDEX W_TABIX.
    ENDIF.

  ENDLOOP.
  DESCRIBE TABLE IT_ZSBWIT LINES W_LINE.
  IF W_LINE EQ 0.
     MESSAGE E977 WITH 'Input quantity!'.
  ENDIF.

  CALL FUNCTION 'ZIM_BW_DOC_MODIFY'
      EXPORTING
             ZFIVNO        =   ZTBWHD-ZFIVNO
             ZFGISEQ       =   ZTBWHD-ZFGISEQ
             ZFSTATUS      =   W_STATUS
             W_ZTBWHD_OLD  =   *ZTBWHD
             W_ZTBWHD      =   ZTBWHD
             W_OK_CODE     =   W_OK_CODE
      TABLES
             IT_ZSBWIT     =   IT_ZSBWIT
             IT_ZSBWIT_OLD =   IT_ZSBWIT_OLD
      CHANGING
             P_ZFGISEQ       =   ZTBWHD-ZFGISEQ

      EXCEPTIONS
             ERROR_UPDATE  = 9
             NOT_MODIFY    = 8.

  IF SY-SUBRC EQ 0.
     MESSAGE S765.
     EXIT.
  ELSE.
     ROLLBACK WORK.
     MESSAGE S208.
     EXIT.
  ENDIF.

ENDFORM.                    " P3000_CHARGE_DOC_MODIFY
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
FORM P2000_SET_LOCK_MODE USING     PA_MODE.

  CASE SY-TCODE.
     WHEN 'ZIMBG1' OR 'ZIMBG2' OR 'ZIMBG3'.    " CHARGE DOC.
        PERFORM P2000_SET_CHARGE_DOC_LOCK    USING   PA_MODE.
     WHEN OTHERS.
  ENDCASE.


ENDFORM.                    " P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_CHARGE_DOC_LOCK
*&---------------------------------------------------------------------*
FORM P2000_SET_CHARGE_DOC_LOCK USING PA_MODE.


   IF PA_MODE EQ 'L'.
      CALL FUNCTION 'ENQUEUE_EZ_IM_ZTBWHD'
         EXPORTING
             ZFIVNO   =  ZTBWHD-ZFIVNO
             ZFGISEQ  =  ZTBWHD-ZFGISEQ
         EXCEPTIONS
             OTHERS        = 1.

      IF SY-SUBRC <> 0.
         MESSAGE E510 WITH SY-MSGV1
                              'Bonded warehouse G/I Document'
                              ZTBWHD-ZFIVNO
                              ZTBWHD-ZFGISEQ.
*                     RAISING DOCUMENT_LOCKED.
      ENDIF.
   ELSE.
      CALL FUNCTION 'DEQUEUE_EZ_IM_ZTBWHD'
         EXPORTING
             ZFIVNO   =  ZTBWHD-ZFIVNO
             ZFGISEQ  =  ZTBWHD-ZFGISEQ.

   ENDIF.

ENDFORM.                    " P2000_SET_CHARGE_DOC_LOCK
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
FORM P2000_SET_SCREEN_SCRCOM.

  CASE SY-TCODE.
       WHEN 'ZIMBG1'.     SET SCREEN 0100.
       WHEN 'ZIMBG2'.     SET SCREEN 0200.
       WHEN 'ZIMBG3'.     SET SCREEN 0300.
       WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " P2000_SET_SCREEN_SCRCOM
*&---------------------------------------------------------------------*
*&      Form  P2000_HEADER_CHANGE_DOC
*&---------------------------------------------------------------------*
FORM P2000_HEADER_CHANGE_DOC.

  CASE SY-DYNNR.
     WHEN '0101'.          "> CHARGE DOC.
         OBJECTCLASS   =   'ZTBWHD'.
         OBJEKTID      =   ZTBWHD+3(13).
     WHEN OTHERS.   EXIT.
  ENDCASE.

  SUBMIT  RCS00120 WITH  OBJEKT   =   OBJECTCLASS
                   WITH  OBJEKTID =   OBJEKTID
                   AND   RETURN.

ENDFORM.                    " P2000_HEADER_CHANGE_DOC
*&---------------------------------------------------------------------*
*&      Form  P2000_SELECT_ITEM
*&---------------------------------------------------------------------*
FORM P2000_SELECT_ITEM.

   CLEAR : W_COUNT.
   LOOP AT IT_ZSBWIT WHERE ZFMARK = 'X'.
      ADD 1   TO   W_COUNT.
      MOVE-CORRESPONDING IT_ZSBWIT  TO   ZTBWIT.
      MOVE: ZTBWHD-ZFIVNO           TO   ZTBWIT-ZFIVNO.
   ENDLOOP.

   CASE W_COUNT.
      WHEN 0.        MESSAGE W951.
      WHEN 1.
      WHEN OTHERS.   MESSAGE W965.
   ENDCASE.

ENDFORM.                    " P2000_SELECT_ITEM
*&---------------------------------------------------------------------*
*&      Form  P2000_ITEM_CHANGE_DOC
*&---------------------------------------------------------------------*
FORM P2000_ITEM_CHANGE_DOC.

  CHECK : W_COUNT EQ 1.
  CASE SY-DYNNR.
     WHEN '0101'.          "> CHARGE DOC.
         OBJECTCLASS   =   'ZTBWIT'.
         OBJEKTID      =   ZTBWIT+3(18).
     WHEN OTHERS.   EXIT.
  ENDCASE.

  SUBMIT  RCS00120 WITH  OBJEKT   =   OBJECTCLASS
                   WITH  OBJEKTID =   OBJEKTID
                   AND   RETURN.

ENDFORM.                    " P2000_ITEM_CHANGE_DOC
*&---------------------------------------------------------------------*
*&      Form  P2000_PRINT_ZTBW
*&---------------------------------------------------------------------*
FORM P2000_PRINT_ZTBW USING    P_ZFIVNO
                               P_ZFGISEQ.

  SUBMIT ZRIMBWPRT WITH P_IVNO  EQ P_ZFIVNO
                   WITH P_GISEQ EQ P_ZFGISEQ
                   AND RETURN.

ENDFORM.                    " P2000_PRINT_ZTBW
*&---------------------------------------------------------------------*
*&      Form  P3000_ZTIV_TITLELIST
*&---------------------------------------------------------------------*
FORM P3000_ZTIV_TITLELIST.

  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-ULINE(61).
  WRITE : / SY-VLINE, '�����ûNo',
            SY-VLINE, ' �� �� �� ',
            SY-VLINE, '�������',
            SY-VLINE, '�������',
            SY-VLINE, '�԰� ����',SY-VLINE.

  WRITE:/ SY-ULINE(61).

ENDFORM.                    " P3000_ZTIV_TITLELIST
