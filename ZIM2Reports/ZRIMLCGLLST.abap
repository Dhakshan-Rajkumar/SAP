*&---------------------------------------------------------------------*
*& Report  ZRIMLCGLLST                                                 *
*&---------------------------------------------------------------------*
*&  ���α׷��� : L/C ������� Program.                                 *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.11.25                                            *
*&---------------------------------------------------------------------*
*&   DESC.     : L/C ������� ��Ȳ����Ʈ�� ��ȸ�ϰ� ����ȭ�鿡�� Ȯ��. *
*&---------------------------------------------------------------------*
*& [���泻��]
*&---------------------------------------------------------------------*
REPORT  ZRIMLCGLLST  MESSAGE-ID  ZIM
                     LINE-SIZE   133
                     NO STANDARD PAGE HEADING.
TYPE-POOLS : SLIS.
*-----------------------------------------------------------------------
* Tables �� ���� Definition.
*-----------------------------------------------------------------------
INCLUDE   ZRIMLCGLLSTTOP.
INCLUDE   ZRIMUTIL01.             " Utility function ����.

*-----------------------------------------------------------------------
* Selection Screen Clause.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.                           " 2 LINE SKIP
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS :    P_BUKRS   LIKE ZTREQHD-BUKRS      " ȸ���ڵ�.
                          OBLIGATORY DEFAULT 'PSC'.
SELECT-OPTIONS: S_EBELN   FOR ZTREQHD-EBELN,      " Purchasing document.
                S_REQNO   FOR ZTREQHD-ZFREQNO,    " �����Ƿ� ������ȣ.
                S_OPNNO   FOR ZTREQHD-ZFOPNNO,    " �ſ��� ���ι�ȣ.
                S_LIFNR   FOR ZTREQHD-LIFNR,      " vendor.
                S_ZFBENI  FOR ZTREQHD-ZFBENI,     " Beneficiary.
                S_ZFMAUD  FOR ZTREQHD-ZFMAUD,     " ���糳����.
                S_REQDT   FOR ZTREQST-ZFREQDT,    " �䰳������.
                S_CDAT    FOR ZTREQST-CDAT,       " Created on.
                S_WERKS   FOR ZTREQHD-ZFWERKS.    " Plant.
PARAMETERS :    P_EKGRP   LIKE ZTREQST-EKGRP,     " ���ű׷�.
                P_EKORG   LIKE ZTREQST-EKORG,     " ��������.
                P_ERNAM   LIKE ZTREQST-ERNAM.     " ������.
SELECT-OPTIONS: S_REQTY   FOR ZTREQHD-ZFREQTY.    " �����Ƿ� Type.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
PARAMETERS:     P_ALV     AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B2.
* Parameter �ʱⰪ Setting.
INITIALIZATION.                          " �ʱⰪ SETTING
  PERFORM   P2000_SET_PARAMETER.

*----------------------------------------------------------------------*
* Top of Page.
*----------------------------------------------------------------------*
TOP-OF-PAGE.
  PERFORM P3000_TITLE_WRITE.

*-----------------------------------------------------------------------
* Start of Selection.
*-----------------------------------------------------------------------
START-OF-SELECTION.
* Import System Config Check
  PERFORM   P2000_CONFIG_CHECK        USING   W_ERR_CHK.

  PERFORM  P2000_READ_DATA        USING  W_ERR_CHK.
  IF W_ERR_CHK = 'Y'.  EXIT.   ENDIF.

  PERFORM P3000_WRITE_DATA.

*-----------------------------------------------------------------------
* User Command.
*-----------------------------------------------------------------------
AT USER-COMMAND.
  W_OK_CODE = SY-UCOMM.
  CASE SY-UCOMM.
    WHEN 'LCGL'. " L/C ���� �� ��ȸ.
      SET PARAMETER ID 'ZPREQNO' FIELD IT_ZVREQ-ZFREQNO.
      SET PARAMETER ID 'ZPAMDNO' FIELD IT_ZVREQ-ZFAMDNO.
      CALL TRANSACTION 'ZIMGL1' AND SKIP FIRST SCREEN.
    WHEN 'SHLC'.
      SET PARAMETER ID 'ZPOPNNO' FIELD ''.
      SET PARAMETER ID 'BES'     FIELD ''.
      SET PARAMETER ID 'ZPREQNO' FIELD IT_ZVREQ-ZFREQNO.
      CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.
    WHEN 'SHPO'.
      SET PARAMETER ID 'BES'     FIELD IT_ZVREQ-EBELN.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.

  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
FORM P2000_SET_PARAMETER.
  SET  TITLEBAR 'ZIM10'.          " TITLE BAR
ENDFORM.                    " P2000_SET_PARAMETER
*&---------------------------------------------------------------------*
*&      Form  P2000_READ_DATA
*&---------------------------------------------------------------------*
FORM P2000_READ_DATA USING    P_W_ERR_CHK.

  W_ERR_CHK = 'N'.                     " Error Bit Setting

  SELECT *
    FROM ZVREQHD_ST
   WHERE BUKRS      EQ     P_BUKRS
     AND ZFREQNO    IN     S_REQNO
     AND ZFOPNNO    IN     S_OPNNO
     AND ZFREQTY    IN     S_REQTY
     AND ZFWERKS    IN     S_WERKS
     AND EBELN      IN     S_EBELN
     AND LIFNR      IN     S_LIFNR
     AND ZFBENI     IN     S_ZFBENI
     AND ZFRVDT     GT     '00000000'
     AND ZFDOCST    EQ     'O'
     AND ZFCLOSE    EQ     SPACE.
* 2002.11.11 NSH Insert [Release Check ���� �߰��� Logic].
    IF ZVREQHD_ST-ZFAMDNO IS INITIAL.
      IF ZTIMIMG00-ZFRELYN1 EQ 'X'.
        IF ZVREQHD_ST-ZFRLST1 NE 'R'. CONTINUE. ENDIF.
      ENDIF.
      IF ZTIMIMG00-ZFRELYN2 EQ 'X'.
        IF ZVREQHD_ST-ZFRLST2 NE 'R'. CONTINUE. ENDIF.
      ENDIF.
    ELSE.
      IF ZTIMIMG00-ZFRELYN3 EQ 'X'.
        IF ZVREQHD_ST-ZFRLST1 NE 'R'. CONTINUE. ENDIF.
      ENDIF.
      IF ZTIMIMG00-ZFRELYN4 EQ 'X'.
        IF ZVREQHD_ST-ZFRLST2 NE 'R'. CONTINUE. ENDIF.
      ENDIF.
    ENDIF.

    CLEAR IT_ZVREQ.
    MOVE-CORRESPONDING ZVREQHD_ST TO IT_ZVREQ.
    APPEND IT_ZVREQ.
  ENDSELECT.

  DESCRIBE TABLE IT_ZVREQ LINES W_LINE.
  IF W_LINE EQ 0.
    W_ERR_CHK = 'Y'.  MESSAGE S009.    EXIT.
  ENDIF.

ENDFORM.                    " P2000_READ_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_DATA.

  SET PF-STATUS 'ZIM11'.               " GUI STATUS SETTING
  SET  TITLEBAR 'ZIM10'.               " GUI TITLE SETTING..

  IF P_ALV EQ 'X'.
    PERFORM P3000_ALV_WRITE.
  ELSE.
    W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

    LOOP AT IT_ZVREQ.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
        PERFORM P3000_LAST_WRITE.
      ENDAT.

    ENDLOOP.
  ENDIF.
ENDFORM.                    " P3000_WRITE_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.

  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /55  '[ L/C ������� List ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 101 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE NO-GAP,
        (10)' �����Ƿ� '   NO-GAP,   SY-VLINE NO-GAP,
        (05)'Amend'        NO-GAP,   SY-VLINE NO-GAP,
        (02)'Ty'           NO-GAP,   SY-VLINE NO-GAP,
        (10)'P/O No.'      NO-GAP,   SY-VLINE NO-GAP,
        (04)'Inco'         NO-GAP,   SY-VLINE NO-GAP,
        (35)'L/C No.'      NO-GAP,   SY-VLINE NO-GAP,
        (18)'Material No.' NO-GAP,   SY-VLINE NO-GAP,
        (40)'Description'  NO-GAP,   SY-VLINE NO-GAP.
*  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
*  WRITE : / SY-VLINE, ' ',  SY-VLINE,
*            '���糳��'    ,  SY-VLINE NO-GAP,
*            '�����Ƿ�No'    NO-GAP,  SY-VLINE NO-GAP,
*            'Amend'         NO-GAP,  SY-VLINE NO-GAP,
* '   USD ȯ��ݾ�   '       NO-GAP,  SY-VLINE NO-GAP,
*            'TT'            NO-GAP,  SY-VLINE NO-GAP,
*            'PGr'           NO-GAP,  SY-VLINE NO-GAP,
*            'Plnt'          NO-GAP,  SY-VLINE NO-GAP,
*    '     ��  ��  ��     '  NO-GAP,  SY-VLINE NO-GAP,
*            'VIA'           NO-GAP,  SY-VLINE NO-GAP,
*            'Bene.     '    NO-GAP,  SY-VLINE NO-GAP,
*            'Name',              118 SY-VLINE NO-GAP,
*            'E'             NO-GAP,  SY-VLINE NO-GAP,
*            ' ��������  '   NO-GAP, 138 SY-VLINE NO-GAP.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK           USING   W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select.
  SELECT SINGLE * FROM ZTIMIMG00.

* if Not Found.
  IF SY-SUBRC NE 0.
    W_ERR_CHK = 'Y'.   MESSAGE S961.   LEAVE TO SCREEN 0.
  ENDIF.

  SET PARAMETER ID 'BUK'  FIELD  P_BUKRS.

ENDFORM.                               " P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.
  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE: / SY-VLINE NO-GAP,
       (10)IT_ZVREQ-ZFREQNO NO-GAP,          SY-VLINE NO-GAP,
       (05)IT_ZVREQ-ZFAMDNO NO-GAP,          SY-VLINE NO-GAP,
       (02)IT_ZVREQ-ZFREQTY NO-GAP,          SY-VLINE NO-GAP,
       (10)IT_ZVREQ-EBELN   NO-GAP,          SY-VLINE NO-GAP,
       (04)IT_ZVREQ-INCO1   NO-GAP CENTERED, SY-VLINE NO-GAP,
       (35)IT_ZVREQ-ZFOPNNO NO-GAP,          SY-VLINE NO-GAP,
       (18)IT_ZVREQ-MATNR   NO-GAP,          SY-VLINE NO-GAP,
       (40)IT_ZVREQ-MAKTX   NO-GAP,          SY-VLINE NO-GAP.
  HIDE: IT_ZVREQ.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.
ENDFORM.                    " P3000_LINE_WRITE
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
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " �ش� ���...
* ����Ʈ Write
  PERFORM   P3000_WRITE_DATA.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P3000_ALV_WRITE
*&---------------------------------------------------------------------*
FORM P3000_ALV_WRITE.

  PERFORM P3000_APPEND_FIELDCAT.      " ALV Report TiTle.

  G_REPID = SY-REPID.
  data: SLIS_FORMNAME(30)  type c.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
            I_CALLBACK_PROGRAM       = G_REPID
            IS_LAYOUT                = G_LAYOUT
            IT_FIELDCAT              = GT_FIELDCAT[]
*            I_CALLBACK_PF_STATUS_SET = G_STATUS
*            I_CALLBACK_TOP_OF_PAGE   = SLIS_FORMNAME
*            I_HTML_HEIGHT_TOP        = 0
*            I_CALLBACK_USER_COMMAND = G_USER_COMMAND
            I_GRID_TITLE             = 'L/C ������� ��Ȳ'
            I_SAVE                   = G_SAVE
            IS_VARIANT               = G_VARIANT
*            I_SCREEN_START_COLUMN = 1000
*            I_SCREEN_START_LINE = 30
       TABLES
            T_OUTTAB           = IT_ZVREQ
       EXCEPTIONS
            PROGRAM_ERROR      = 1
            OTHERS             = 2.
  IF SY-SUBRC <> 0.
    MESSAGE E977 WITH 'Grid Dispaly ���� ������ �߻��Ͽ����ϴ�.'.
  ENDIF.

ENDFORM.                    " P3000_ALV_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_APPEND_FIELDCAT
*&---------------------------------------------------------------------*
FORM P3000_APPEND_FIELDCAT.

  CLEAR: GT_FIELDCAT, POS.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'ZFREQNO'.
  LS_FIELDCAT-SELTEXT_M      = '�����Ƿ� ������ȣ'.
  LS_FIELDCAT-OUTPUTLEN      = 10.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'ZFAMDNO'.
  LS_FIELDCAT-SELTEXT_M      = 'Amend ȸ��'.
  LS_FIELDCAT-OUTPUTLEN      = 5.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'ZFREQTY'.
  LS_FIELDCAT-SELTEXT_M      = 'Type'.
  LS_FIELDCAT-OUTPUTLEN      = 2.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'EBELN'.
  LS_FIELDCAT-SELTEXT_M      = 'P/O No.'.
  LS_FIELDCAT-OUTPUTLEN      = 10.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'ZFOPNNO'.
  LS_FIELDCAT-SELTEXT_M      = 'L/C No'.
  LS_FIELDCAT-OUTPUTLEN      = 35.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'MATNR'.
  LS_FIELDCAT-SELTEXT_M      = 'Material No.'.
  LS_FIELDCAT-OUTPUTLEN      = 18.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

  CLEAR LS_FIELDCAT.
  POS = POS + 1.
  LS_FIELDCAT-COL_POS        = POS.
  LS_FIELDCAT-FIELDNAME      = 'MAKTX'.
  LS_FIELDCAT-SELTEXT_M      = 'Description'.
  LS_FIELDCAT-OUTPUTLEN      = 40.
  LS_FIELDCAT-EMPHASIZE      = 'C200'.
  APPEND LS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.                    " P3000_APPEND_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  P2000_ALV_PF_STATUS
*&---------------------------------------------------------------------*
FORM P2000_ALV_PF_STATUS USING  EXTAB TYPE SLIS_T_EXTAB.
    SET PF-STATUS 'ZIM11N'.
ENDFORM.                    " P2000_ALV_PF_STATUS

*&---------------------------------------------------------------------*
*&      Form  P2000_ALV_COMMAND
*&---------------------------------------------------------------------*
FORM P2000_ALV_COMMAND USING R_UCOMM      LIKE SY-UCOMM
                              RS_SELFIELD TYPE SLIS_SELFIELD.
  CASE R_UCOMM.
    WHEN 'LCGL'. " L/C ���� �� ��ȸ.
      SET PARAMETER ID 'ZPREQNO' FIELD IT_ZVREQ-ZFREQNO.
      SET PARAMETER ID 'ZPAMDNO' FIELD IT_ZVREQ-ZFAMDNO.
      CALL TRANSACTION 'ZIMGL1' AND SKIP FIRST SCREEN.
    WHEN 'SHLC'.
      SET PARAMETER ID 'ZPOPNNO' FIELD ''.
      SET PARAMETER ID 'BES'     FIELD ''.
      SET PARAMETER ID 'ZPREQNO' FIELD IT_ZVREQ-ZFREQNO.
      CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.
    WHEN 'SHPO'.
      SET PARAMETER ID 'BES'     FIELD IT_ZVREQ-EBELN.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " P2000_ALV_COMMAND
