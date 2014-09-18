*&---------------------------------------------------------------------*
*& Report  ZRIMINSJOB                                                  *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �κ����� Receipt                                      *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.12.23                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&               �κ����� Receipt
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMINSJOB MESSAGE-ID ZIM
                   LINE-SIZE 104
                   NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_TAB OCCURS 0,
       ZFREQNO      LIKE ZTINS-ZFREQNO,     " �����Ƿ� ��ȣ.
       ZFINSEQ      LIKE ZTINS-ZFINSEQ,     " ���� SEQ.
       ZFAMDNO      LIKE ZTINS-ZFAMDNO,     " AMENDNO.
       EBELN        LIKE ZTREQHD-EBELN,     " P/O No.
       ZFETC1       LIKE ZTINS-ZFETC1,      " ��Ÿ����.
       W_AMDNO      LIKE ZTREQST-ZFAMDNO,   " L/C AMDNO.
       ZFREQTY      LIKE ZTREQHD-ZFREQTY,   " ��������.
       REQTY        LIKE DD07T-DDTEXT,
       ZFINSDT      LIKE ZTINS-ZFINSDT,     " ���谳����.
       ZFSHCUNM     LIKE ZTINSSG3-ZFSHCUNM, " ������.
       INCO1        LIKE ZTREQHD-INCO1,     " Incoterms.
       ZFCNCDNM     LIKE ZTINSAGR-ZFCNCDNM, " �κ�����.
       ZFLASTAM     LIKE ZTREQHD-ZFLASTAM,  " �����ݾ�.
       ZFARCUNM     LIKE ZTINSSG3-ZFARCUNM, " ������.
*      ZFDOCST      LIKE ZTINS-ZFDOCST,     " ���� Document Status.
*       DOCST        LIKE DD07T-DDTEXT,
       ZFTRANS      LIKE ZTINS-ZFTRANS,     " ��۱���.
       TRANS        LIKE DD07T-DDTEXT,      " ���.
*       ZFOPCD       LIKE ZTINS-ZFOPCD,       " ����ȸ��.
*       ZFINCOM_NM(20)    TYPE C,            " ����ȸ���.
*       ZFINNO       LIKE ZTINS-ZFINNO,      " �������ǹ�ȣ.
        ZFIVAMT      LIKE ZTINS-ZFIVAMT,     " Invoice Amount(���谡��).
        WAERS        LIKE ZTINS-WAERS.       " Invoice Amount ��ȭ.
*       ZFDSOG1      LIKE ZTINSSG2-ZFDSOG1,  " ��ǰ��.
*       ZFKRWAMT     LIKE ZTINS-ZFKRWAMT,    " �����(��).
*       ZFKRW        LIKE ZTINS-ZFKRW,       " �����(��) ȭ�����.
*        ZFINAMT      LIKE ZTINS-ZFINAMT,     " �����($).
*       ZFINAMTC     LIKE ZTINS-ZFINAMTC,    " �������ȭ.
*       ZFINRT       LIKE ZTINS-ZFINRT,      " AIR,SHIP ����.
*       ZFACDO       LIKE ZTRECST-ZFACDO,    " ��ǥ.
*       LANDX        LIKE T005T-LANDX.       " ������.
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
* Include
*-----------------------------------------------------------------------
INCLUDE   ZRIMISNSTOP.
INCLUDE   ZRIMSORTCOM.    " Report Sort�� ���� Include
INCLUDE   ZRIMUTIL01.     " ��Ÿ��ƿ��Ƽ ����.

*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.
* ����Ʈ ���� Text Table SELECT
   PERFORM   P1000_READ_TEXT           USING   W_ERR_CHK.
   IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

   PERFORM P2000_REQ_INS.


*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.

  SET TITLEBAR 'ZIMR14'.

ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  WRITE : /40  '[ ���Ϻ����Ƿ���Ȳ ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE,'',
            SY-VLINE, (10) 'P/O NO.',
            SY-VLINE, (20) '��������',
            SY-VLINE, (30) '�κ�����',
            SY-VLINE, (14) '������',
            SY-VLINE, (10) 'Incoterms',
            SY-VLINE.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : /  SY-VLINE,'',
             SY-VLINE, (10) '������',
             SY-VLINE, (20) '���谡��',
             SY-VLINE, (30) '��Ÿ����',
             SY-VLINE, (14) '������',
             SY-VLINE, (10) '��۱���',SY-VLINE.
  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB
          FROM ZTREQHD AS R INNER JOIN ZTINS AS I
          ON R~ZFREQNO = I~ZFREQNO
         WHERE I~ZFDOCST   EQ  'R'.

  DESCRIBE TABLE IT_TAB LINES W_LINE.
  IF W_LINE = 0.
     W_ERR_CHK = 'Y'.  MESSAGE S738.    EXIT.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING      W_ERR_CHK.

  SET PF-STATUS 'ZIMR14'.           " GUI STATUS SETTING
  SET  TITLEBAR 'ZIMR14'.           " GUI TITLE SETTING..

  W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

  LOOP AT IT_TAB.
     W_LINE = W_LINE + 1.
     PERFORM P3000_LINE_WRITE.
     AT LAST.
        PERFORM P3000_LAST_WRITE.
     ENDAT.

  ENDLOOP.

ENDFORM.                    " P3000_DATA_WRITE
*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / '��', W_COUNT, '��'.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE : /  SY-VLINE, MARKFIELD AS CHECKBOX,
             SY-VLINE, (10) IT_TAB-EBELN,
             SY-VLINE, (20) IT_TAB-REQTY, " ��������.
             SY-VLINE, (30) IT_TAB-ZFCNCDNM,      " �κ�����.
             SY-VLINE, (14) IT_TAB-ZFSHCUNM, " ������.
             SY-VLINE, (10) IT_TAB-INCO1,
             SY-VLINE.
  HIDE : IT_TAB.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  WRITE : /  SY-VLINE,'',
             SY-VLINE, (10) IT_TAB-ZFINSDT, " ������',
             SY-VLINE, (03) IT_TAB-WAERS,
                       (16) IT_TAB-ZFIVAMT CURRENCY IT_TAB-WAERS,
             SY-VLINE, (30) IT_TAB-ZFETC1,  " ��Ÿ����.
             SY-VLINE, (14) IT_TAB-ZFARCUNM, "������',
             SY-VLINE, (10) IT_TAB-TRANS,    "��۱���.
             SY-VLINE.
* Hide
  HIDE : IT_TAB.
  WRITE : / SY-ULINE.
  W_COUNT = W_COUNT + 1.

ENDFORM.                    " P3000_LINE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_LC
*&---------------------------------------------------------------------*
FORM P2000_SHOW_LC USING   P_ZFREQNO  P_ZFAMDNO.

   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.

   IF P_ZFAMDNO = '00000'.
      CALL TRANSACTION 'ZIM03' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM13' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_LC
*&---------------------------------------------------------------------*
*&      Form  P2000_SHOW_INS
*&---------------------------------------------------------------------*
FORM P2000_SHOW_INS USING    P_ZFREQNO
                             P_ZFINSEQ
                             P_ZFAMDNO.

   SET PARAMETER ID 'ZPOPNNO'   FIELD ''.
   SET PARAMETER ID 'BES'       FIELD ''.
   SET PARAMETER ID 'ZPREQNO'   FIELD P_ZFREQNO.
   SET PARAMETER ID 'ZPINSEQ'   FIELD P_ZFINSEQ.
   SET PARAMETER ID 'ZPAMDNO'   FIELD P_ZFAMDNO.
   EXPORT 'BES'       TO MEMORY ID 'BES'.
   EXPORT 'ZPOPNNO'   TO MEMORY ID 'ZPOPNNO'.
   EXPORT 'ZPREQNO'   TO MEMORY ID 'ZPREQNO'.
   EXPORT 'ZPINSEQ'   TO MEMORY ID 'ZPINSEQ'.
   EXPORT 'ZPAMDNO'   TO MEMORY ID 'ZPAMDNO'.

   IF P_ZFAMDNO > '00000'.
      CALL TRANSACTION 'ZIM47' AND SKIP  FIRST SCREEN.
   ELSE.
      CALL TRANSACTION 'ZIM43' AND SKIP  FIRST SCREEN.
   ENDIF.

ENDFORM.                    " P2000_SHOW_INS
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  REFRESH IT_SELECTED.
  CLEAR W_SELECTED_LINES.
  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
      MOVE : IT_TAB-ZFREQNO   TO IT_SELECTED-ZFREQNO,
             IT_TAB-ZFAMDNO  TO IT_SELECTED-ZFAMDNO,
             IT_TAB-ZFINSEQ  TO IT_SELECTED-ZFINSEQ.

      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
*&      Form  P2000_REQ_INS
*&---------------------------------------------------------------------*
FORM P2000_REQ_INS.

   REFRESH : IT_ERR_LIST.

   LOOP AT IT_TAB.

      W_TABIX = SY-TABIX.
*>>> ������¹�..

      line = ( sy-tabix / W_LINE ) * 100.
      out_text = 'JOB PROGRESS %99999%%'.
      replace '%99999%' with line into out_text.
      perform p2000_show_bar using out_text line.

      W_SUBRC = 0.
      CALL FUNCTION 'ENQUEUE_EZ_IM_ZTINS'
           EXPORTING
                 ZFREQNO = IT_TAB-ZFREQNO
                 ZFINSEQ = IT_TAB-ZFINSEQ
                 ZFAMDNO = IT_TAB-ZFAMDNO
           EXCEPTIONS
                 OTHERS  = 1.

      IF SY-SUBRC NE 0.
         PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
         CONTINUE.
      ENDIF.

      CALL FUNCTION 'ZIM_INSURANCE_LGI_TO_LG'
           EXPORTING
              ZFREQNO   = IT_TAB-ZFREQNO
              ZFINSEQ   = IT_TAB-ZFINSEQ
              ZFAMDNO   = IT_TAB-ZFAMDNO
           EXCEPTIONS
              NOT_FOUND   =  4
              NOT_SELECT  =  8
              RCV_ERROR   =  10.
      W_SUBRC  =  SY-SUBRC.

      CASE W_SUBRC.
         WHEN 0.
           MESSAGE S928 WITH  IT_TAB-ZFREQNO IT_TAB-ZFINSEQ
                              IT_TAB-ZFAMDNO.
         WHEN 4.
           MESSAGE S169 WITH  IT_TAB-ZFREQNO.
         WHEN 8.
           MESSAGE S929 WITH  IT_TAB-ZFREQNO IT_TAB-ZFINSEQ
                              IT_TAB-ZFAMDNO.
         WHEN 10.
           MESSAGE S930 WITH  IT_TAB-ZFREQNO IT_TAB-ZFINSEQ
                              IT_TAB-ZFAMDNO.
      ENDCASE.

      PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.

      CALL FUNCTION 'DEQUEUE_EZ_IM_ZTINS'
           EXPORTING
                 ZFREQNO = IT_TAB-ZFREQNO
                 ZFINSEQ = IT_TAB-ZFINSEQ
                 ZFAMDNO = IT_TAB-ZFAMDNO
           EXCEPTIONS
                 OTHERS  = 1.

   ENDLOOP.

*   INCLUDE = 'POPU'.
*   CALL SCREEN 0100 STARTING AT  04   3
*                    ENDING   AT 100  12.
*   CLEAR : INCLUDE.
*
*   LEAVE TO SCREEN 0.

ENDFORM.                    " P2000_REQ_INS
*&---------------------------------------------------------------------*
*&      Module  D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_STATUS_SCR0100 OUTPUT.
*  IF W_STATUS_CHK = 'D'.
*     SET PF-STATUS 'STDLISA'.
*  ELSE.
     SET PF-STATUS 'STDLISW'.
*  ENDIF.

  CASE INCLUDE.
     WHEN 'POPU'.
        SET TITLEBAR 'POPU' WITH '�޽��� LIST'.
     WHEN OTHERS.
  ENDCASE.

  SUPPRESS DIALOG.

ENDMODULE.                 " D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_LIST_CHECK_SCR0100 INPUT.
   LEAVE TO LIST-PROCESSING.
   CASE INCLUDE.
      WHEN 'POPU'.
         FORMAT COLOR COL_HEADING INTENSIFIED OFF.
         WRITE : / SY-ULINE(96), / SY-VLINE NO-GAP,
                   '����'   NO-GAP, SY-VLINE NO-GAP,
*                   ' �����û ' NO-GAP, SY-VLINE NO-GAP,
                   '�޼��� �ؽ�Ʈ', 94 SY-VLINE NO-GAP,
                   'T'      NO-GAP, SY-VLINE,
                 / SY-ULINE(96).
*         MESSAGE
         LOOP AT IT_ERR_LIST.
            W_MOD  =  SY-TABIX MOD 2.
            FORMAT RESET.
            IF W_MOD EQ 0.
               FORMAT COLOR COL_NORMAL  INTENSIFIED ON.
            ELSE.
               FORMAT COLOR COL_NORMAL  INTENSIFIED OFF.
            ENDIF.
            WRITE : / SY-VLINE NO-GAP, IT_ERR_LIST-ICON(4) NO-GAP,
*                      SY-VLINE NO-GAP, IT_ERR_LIST-ZFIVNO  NO-GAP,
                      SY-VLINE NO-GAP, IT_ERR_LIST-MESSTXT(87) NO-GAP,
                      SY-VLINE NO-GAP.

            CASE IT_ERR_LIST-MSGTYP.
               WHEN 'E' OR 'A'.
                  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
               WHEN 'W'.
                  FORMAT COLOR COL_KEY      INTENSIFIED OFF.
               WHEN 'I'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
               WHEN 'S'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
            ENDCASE.

            WRITE : IT_ERR_LIST-MSGTYP(1) NO-GAP, SY-VLINE NO-GAP.
*                   / SY-ULINE(96).
            HIDE:IT_ERR_LIST.
         ENDLOOP.
         WRITE : / SY-ULINE(96).
         CLEAR : IT_ERR_LIST.
      WHEN OTHERS.
   ENDCASE.

ENDMODULE.                 " D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST  STRUCTURE IT_ERR_LIST.

   MOVE : SY-MSGTY            TO     IT_ERR_LIST-MSGTYP,
          SY-MSGID            TO     IT_ERR_LIST-MSGID,
          SY-MSGNO            TO     IT_ERR_LIST-MSGNR,
          SY-MSGV1            TO     IT_ERR_LIST-MSGV1,
          SY-MSGV2            TO     IT_ERR_LIST-MSGV2,
          SY-MSGV3            TO     IT_ERR_LIST-MSGV3,
          SY-MSGV4            TO     IT_ERR_LIST-MSGV4.

   IF W_SUBRC NE 0.
      IT_ERR_LIST-MSGTYP = 'E'.
   ENDIF.
*          IT_SELECTED-ZFIVNO  TO     IT_ERR_LIST-ZFIVNO.

    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
         EXPORTING
                MSGID               = IT_ERR_LIST-MSGID
                MSGNR               = IT_ERR_LIST-MSGNR
                MSGV1               = IT_ERR_LIST-MSGV1
                MSGV2               = IT_ERR_LIST-MSGV2
                MSGV3               = IT_ERR_LIST-MSGV3
                MSGV4               = IT_ERR_LIST-MSGV4
         IMPORTING
                MESSAGE_TEXT_OUTPUT = IT_ERR_LIST-MESSTXT.

   CASE IT_ERR_LIST-MSGTYP.
      WHEN 'E' OR 'A'.
         MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
      WHEN 'I'.
         MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'S'.
         MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
      WHEN 'W'.
         MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
   ENDCASE.

   APPEND  IT_ERR_LIST.

ENDFORM.                    " P2000_MESSAGE_MAKE
