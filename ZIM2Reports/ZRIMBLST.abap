*&---------------------------------------------------------------------*
*& Report  ZRIMBLST                                                    *
*&---------------------------------------------------------------------*
*&   ���α׷��� : B/L ���º� ��Ȳ.                                     *
*&       �ۼ��� : �̼�ö INFOLINK.Ltd                                  *
*&       �ۼ��� : 2000.08.17                                           *
*&---------------------------------------------------------------------*
*& DESC:                                                               *
*&---------------------------------------------------------------------*
*& [���泻��]                                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
REPORT  ZRIMBLST  MESSAGE-ID ZIM
                  LINE-SIZE 135
                  NO STANDARD PAGE HEADING.

*&----------------------------------------------------------------------
*&    Tables �� ���� Define
*&----------------------------------------------------------------------
TABLES : ZTBL, T001, DD03D, ZTIDR.

*& INTERNAL TABLE ����-------------------------------------------------*

DATA : BEGIN OF IT_TAB OCCURS 0.
       INCLUDE STRUCTURE ZTBL.
DATA   W_RETA(10)  TYPE    C.
DATA   W_BUTXT     LIKE    T001-BUTXT.
DATA   W_PONO(13)  TYPE    C.
DATA   W_PORT(8)   TYPE    C.
DATA: END OF IT_TAB.

DATA: BEGIN OF IT_EXCL OCCURS 20,
      FCODE    LIKE RSMPE-FUNC.
DATA: END   OF IT_EXCL.

DATA : W_PONO(20),
       W_TABIX           LIKE      SY-TABIX,
       W_ERR_CHK(1)      TYPE C,
       W_BLST(1)         TYPE C,
       W_LINE            TYPE I,             " LINE COUNT
       W_PAGE            TYPE I,
       W_COUNT           TYPE I,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_MOD             TYPE I.             " ������ ����.

RANGES : R_BLST          FOR  ZTBL-ZFBLST OCCURS 5.

INCLUDE   ZRIMSORTCOM.    " �����Ƿ� Report Sort�� ���� Include

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_BUKRS   FOR   ZTBL-BUKRS,        "ȸ���ڵ�.
                S_REBELN  FOR   ZTBL-ZFREBELN,     " ��ǥ P/O No.
                S_OPNNO   FOR   ZTBL-ZFOPNNO,      " ��ǥ L/C No.
                S_INCO1   FOR   ZTBL-INCO1,        " ��������.
                S_LIFNR   FOR   ZTBL-LIFNR,        " Vendor.
                S_IMTRD   FOR   ZTBL-IMTRD,        " �����ڱ���
                S_WERKS   FOR   ZTBL-ZFWERKS,      " �÷�Ʈ.
                S_RGDSR   FOR   ZTBL-ZFRGDSR,      " ��ǥǰ��.
                S_HBLNO   FOR   ZTBL-ZFHBLNO,      " House B/L No.
                S_BLNO    FOR   ZTBL-ZFBLNO,       " B/L ������ȣ.
                S_INRNO   FOR   ZTBL-ZFINRNO,      " ���Թ�ȣ.(�Ѽ���)
                S_EKORG   FOR   ZTBL-EKORG,        " ��������.
                S_EKGRP   FOR   ZTBL-EKGRP,        " ���ű׷�.
                S_CARC    FOR   ZTBL-ZFCARC,       " ������.
                S_ETA     FOR   ZTBL-ZFETA,        " ������(ETA).
                S_VIA     FOR   ZTBL-ZFVIA,        " Via.
                S_SHTY    FOR   ZTBL-ZFSHTY,       " ��۱���.
                S_ERNAM   FOR   ZTBL-ERNAM,        " ����� ID.
                S_CDAT    FOR   ZTBL-CDAT.         " ������.

SELECTION-SCREEN END OF BLOCK B1.
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
      PARAMETERS: R1 RADIOBUTTON GROUP RAD1 DEFAULT 'X',
                  R2 RADIOBUTTON GROUP RAD1,
                  R3 RADIOBUTTON GROUP RAD1,
                  R4 RADIOBUTTON GROUP RAD1.
SELECTION-SCREEN END OF BLOCK B2.

AT SELECTION-SCREEN.
       IF R1 = 'X'. W_BLST = '1'.
   ELSEIF R2 = 'X'. W_BLST = '2'.
   ELSEIF R3 = 'X'. W_BLST = '3'.
   ELSEIF R4 = 'X'. W_BLST = '4'. ENDIF.

INITIALIZATION.
     SET  TITLEBAR  'BLST' WITH TEXT-001.

TOP-OF-PAGE.
     PERFORM P3000_TITLE_WRITE.           "��� ���.
*&---------------------------------------------------------------
*&    START-OF-SELECTION ��.
*&--------------------------------------------------------------------

START-OF-SELECTION.
* ����Ʈ ���� TEXT TABLE SELECT
  PERFORM   P1000_READ_DATA        USING   W_ERR_CHK.
     IF W_ERR_CHK EQ 'Y'.    MESSAGE S966. EXIT.    ENDIF.

* ����Ʈ Write
  PERFORM P3000_DATA_WRITE    USING W_ERR_CHK.
    IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*&---------------------------------------------------------------------
*&      AT USER-COMMAND
*&---------------------------------------------------------------------

AT USER-COMMAND.

  CASE SY-UCOMM.
     WHEN 'DISP'.
           IF IT_TAB-ZFBLNO IS INITIAL.
              MESSAGE S962.
           ELSE.
              SET PARAMETER ID 'ZPHBLNO' FIELD SPACE.
              SET PARAMETER ID 'ZPBLNO'  FIELD IT_TAB-ZFBLNO.
              CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.
           ENDIF.
           CLEAR IT_TAB.
     WHEN 'DOCSE'.
           IF IT_TAB-ZFBLNO IS INITIAL.
              MESSAGE S962.
           ELSE.
              SET PARAMETER ID 'ZPHBLNO' FIELD SPACE.
              SET PARAMETER ID 'ZPBLNO'  FIELD IT_TAB-ZFBLNO.
              CALL TRANSACTION 'ZIM221' AND SKIP FIRST SCREEN.
              PERFORM   REFRESH_LIST           USING W_ERR_CHK.
           ENDIF.
           CLEAR IT_TAB.
     WHEN 'ETAI'.
           IF IT_TAB-ZFBLNO IS INITIAL.
              MESSAGE S962.
           ELSE.
              SET PARAMETER ID 'ZPHBLNO' FIELD SPACE.
              SET PARAMETER ID 'ZPBLNO'  FIELD IT_TAB-ZFBLNO.

              CALL TRANSACTION 'ZIM222' AND SKIP FIRST SCREEN.
              PERFORM   REFRESH_LIST           USING W_ERR_CHK.
           ENDIF.
           CLEAR IT_TAB.
     WHEN 'IMPO'.
           IF IT_TAB-ZFBLNO IS INITIAL.
              MESSAGE S962.
           ELSE.
              IF IT_TAB-ZFRPTTY IS INITIAL.              ">�������.
                 MESSAGE S939 WITH IT_TAB-ZFHBLNO.
                 EXIT.
              ENDIF.

              SELECT MAX( ZFCLSEQ ) INTO ZTIDR-ZFCLSEQ
                     FROM ZTIDR
                     WHERE ZFBLNO = IT_TAB-ZFBLNO.
              ADD 1 TO ZTIDR-ZFCLSEQ.

              SET PARAMETER ID 'ZPHBLNO' FIELD SPACE.
              SET PARAMETER ID 'ZPBLNO'  FIELD IT_TAB-ZFBLNO.
              SET PARAMETER ID 'ZPCLSEQ' FIELD ZTIDR-ZFCLSEQ.
              SET PARAMETER ID 'ZPIDRNO' FIELD ''.

              CALL TRANSACTION 'ZIM62' AND SKIP FIRST SCREEN.

*              SET PARAMETER ID 'ZPHBLNO' FIELD SPACE.
*              SET PARAMETER ID 'ZPBLNO'  FIELD IT_TAB-ZFBLNO.
*
*              CASE IT_TAB-ZFRPTTY.              ">�������.
*                 WHEN 'B' OR 'N'.               ">������� ���.
*                    SET PARAMETER ID 'ZPCLCD'  FIELD 'A'.
*                 WHEN 'A' OR 'D' OR 'W' OR 'I'. ">�������.
*                    SET PARAMETER ID 'ZPCLCD'  FIELD 'C'.
*                 WHEN OTHERS.                   ">�����.
*                    SET PARAMETER ID 'ZPCLCD'  FIELD 'X'.
*              ENDCASE.
*              CALL TRANSACTION 'ZIM31' AND SKIP FIRST SCREEN.
              PERFORM   REFRESH_LIST           USING W_ERR_CHK.
           ENDIF.
           CLEAR IT_TAB.
* SORT ����?
      WHEN 'STUP' OR 'STDN'.         " SORT ����?
         W_FIELD_NM = 'ZFREBELN'.
         ASSIGN W_FIELD_NM   TO <SORT_FIELD>.
         PERFORM HANDLE_SORT TABLES  IT_TAB
                             USING   SY-UCOMM.
           CLEAR IT_TAB.
      WHEN 'REFR'.
            PERFORM   REFRESH_LIST           USING W_ERR_CHK.
            CLEAR IT_TAB.
     WHEN OTHERS.
  ENDCASE.                              "AT USER-COMMMAND
*  CLEAR IT_TAB.
*
*&---------------------------------------------------------------------
*&    Form P3000_DATA_WRITE.        " ��� ���� ���.
*&---------------------------------------------------------------------
FORM P3000_DATA_WRITE   USING W_ERR_CHK.

  REFRESH : IT_EXCL.

  IF W_BLST EQ '1'.
*  GUI STATUS SETTING
     SET  TITLEBAR  'BLST' WITH TEXT-011.

     MOVE 'ETAI' TO IT_EXCL-FCODE. APPEND IT_EXCL.
     MOVE 'IMPO' TO IT_EXCL-FCODE. APPEND IT_EXCL.

  ELSEIF W_BLST EQ '2'.
*  GUI STATUS SETTING
     SET  TITLEBAR  'BLST' WITH TEXT-012.

     MOVE 'DOCSE' TO IT_EXCL-FCODE. APPEND IT_EXCL.
     MOVE 'IMPO'  TO IT_EXCL-FCODE. APPEND IT_EXCL.

  ELSEIF W_BLST EQ '3'.
*  GUI STATUS SETTING
     SET  TITLEBAR  'BLST' WITH TEXT-013.

     MOVE 'DOCSE' TO IT_EXCL-FCODE. APPEND IT_EXCL.
     MOVE 'ETAI'  TO IT_EXCL-FCODE. APPEND IT_EXCL.

  ELSEIF W_BLST EQ '4'.
*  GUI STATUS SETTING
     SET  TITLEBAR  'BLST' WITH TEXT-014.

     MOVE 'DOCSE' TO IT_EXCL-FCODE. APPEND IT_EXCL.
     MOVE 'ETAI'  TO IT_EXCL-FCODE. APPEND IT_EXCL.
     MOVE 'IMPO'  TO IT_EXCL-FCODE. APPEND IT_EXCL.
   ENDIF.

*  PF-STATUS ����.
   SET PF-STATUS 'BLST' EXCLUDING IT_EXCL.

   CLEAR W_LINE.
   LOOP AT IT_TAB.

      PERFORM P3000_LINE_WRITE.
      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.
   ENDLOOP.
   CLEAR IT_TAB.
ENDFORM.                                  "FORM P3000_DATA_WRITE

*&---------------------------------------------------------------------
*&    Form P3000_LAST_WRITE.
*&---------------------------------------------------------------------

FORM P3000_LAST_WRITE.

  IF  W_LINE GT 0.
      FORMAT RESET.
      WRITE : /97 '��', W_LINE,'��'.

  ENDIF.
ENDFORM.                                 "FORM P3000_LAST_WRITE.
*
*&---------------------------------------------------------------------
*&    Form P1000_READ_DATA           " �Ƿ� ���� ��ȸ.
*&---------------------------------------------------------------------

FORM P1000_READ_DATA             USING W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

*>> 2001/08/20 KSB MODIFY..
   MOVE : 'I'    TO     R_BLST-SIGN,
          'EQ'   TO     R_BLST-OPTION,
          W_BLST TO     R_BLST-LOW,
          SPACE  TO     R_BLST-HIGH.
   APPEND  R_BLST.

  IF W_BLST EQ '2'.
     MOVE : 'I'    TO     R_BLST-SIGN,
            'EQ'   TO     R_BLST-OPTION,
            '1'    TO     R_BLST-LOW,
            SPACE  TO     R_BLST-HIGH.
     APPEND  R_BLST.
  ENDIF.

  IF W_BLST EQ '3' OR W_BLST EQ '4'.
     MOVE : 'I'    TO     R_BLST-SIGN,
            'EQ'   TO     R_BLST-OPTION,
            'P'    TO     R_BLST-LOW,
            SPACE  TO     R_BLST-HIGH.
     APPEND  R_BLST.
  ENDIF.

  REFRESH :  IT_TAB.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_TAB FROM ZTBL
                WHERE   BUKRS      IN    S_BUKRS      "ȸ���ڵ�.
                   AND  ZFREBELN   IN    S_REBELN     " ��ǥ P/O No.
                   AND  ZFOPNNO    IN    S_OPNNO      " ��ǥ L/C No.
                   AND  INCO1      IN    S_INCO1      " ��������.
                   AND  LIFNR      IN    S_LIFNR      " Vendor.
                   AND  IMTRD      IN    S_IMTRD      " �����ڱ���
                   AND  ZFWERKS    IN    S_WERKS      " �÷�Ʈ.
                   AND  ZFRGDSR    IN    S_RGDSR      " ��ǥǰ��.
                   AND  ZFHBLNO    IN    S_HBLNO      " House B/L No.
                   AND  ZFBLNO     IN    S_BLNO       " B/L ������ȣ.
                   AND  ZFINRNO    IN    S_INRNO      " ���Թ�ȣ.
                   AND  EKORG      IN    S_EKORG      " �� ������.
                   AND  EKGRP      IN    S_EKGRP      " ���ű׷�.
                   AND  ZFCARC     IN    S_CARC       " ������.
                   AND  ZFETA      IN    S_ETA        " ������(ETA).
                   AND  ZFVIA      IN    S_VIA        " Via.
                   AND  ZFSHTY     IN    S_SHTY       " ��۱���.
                   AND  ERNAM      IN    S_ERNAM      " ����� ID.
                   AND  CDAT       IN    S_CDAT       " ������.
                   AND  ZFBLST     IN    R_BLST.      " B/L ����.
   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'. EXIT.
   ENDIF.
 LOOP AT IT_TAB.
   W_TABIX = SY-TABIX.

   CALL FUNCTION 'ZIM_GET_COMPANY_DATA'
        EXPORTING
          BUKRS = IT_TAB-BUKRS
          IMTRD = IT_TAB-IMTRD
        IMPORTING
          XT001 = T001
        EXCEPTIONS
          NOT_FOUND = 4.
   MOVE T001-BUTXT TO IT_TAB-W_BUTXT.
   CLEAR W_PONO.

   CONCATENATE IT_TAB-ZFCARC '-' IT_TAB-ZFSPRTC INTO IT_TAB-W_PORT.

   IF NOT IT_TAB-ZFSHNO IS INITIAL.
      WRITE IT_TAB-ZFREBELN TO W_PONO LEFT-JUSTIFIED.
      CONCATENATE W_PONO '-' IT_TAB-ZFSHNO INTO IT_TAB-W_PONO.
   ELSE.
      WRITE IT_TAB-ZFREBELN TO IT_TAB-W_PONO LEFT-JUSTIFIED.
   ENDIF.

   IF IT_TAB-ZFRETA IS INITIAL.
      MOVE '' TO IT_TAB-W_RETA.
   ELSE.
      WRITE IT_TAB-ZFRETA TO IT_TAB-W_RETA.
   ENDIF.

   MODIFY IT_TAB INDEX W_TABIX.
 ENDLOOP.

   SORT IT_TAB BY ZFREBELN.
ENDFORM.                                  "FORM P1000_READ_DATA

*&---------------------------------------------------------------------
*&    Form P3000_TITLE_WRITE         "��� ���.
*&---------------------------------------------------------------------
FORM P3000_TITLE_WRITE.
  SKIP 2.
  IF W_BLST EQ '1'.
     WRITE: /50 '[ �������� �ۺ� ��� ]'  COLOR 5 INTENSIFIED.
  ELSEIF W_BLST EQ '2'.
     WRITE: /50 '[ ������ �Է� ��� ]'    COLOR 5 INTENSIFIED.
  ELSEIF W_BLST EQ '3'.
     WRITE: /50 '[ ���ԽŰ� �Ƿ� ���]'   COLOR 5 INTENSIFIED.
  ELSEIF W_BLST EQ '4'.
     WRITE: /50 '[ ���ԽŰ� �Ƿ� ��Ȳ]'   COLOR 5 INTENSIFIED.
  ENDIF.
  WRITE: /104 SY-DATUM, / SY-ULINE.
  FORMAT COLOR 5 INTENSIFIED OFF.
  WRITE: / SY-VLINE,
           (20)'��ǥ ���Ź���' CENTERED,   SY-VLINE,
           (20)'Vessel Name'   CENTERED,   SY-VLINE,
           (15)'��ǥ L/C No.'  CENTERED,   SY-VLINE,
            (8)'������'        CENTERED,   SY-VLINE,
           (10)'�� �� ��'      CENTERED,   SY-VLINE,
           (10)'��������'      CENTERED,   SY-VLINE,
           (18)'�� �� ��'      CENTERED,   SY-VLINE,
            (9)'������'        CENTERED,   SY-VLINE.

  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE: / SY-VLINE,
            (20)'House B/L No.'       CENTERED,   SY-VLINE,
            (20)'B/L ������ȣ'        CENTERED,   SY-VLINE,
            (26)'��   ǥ   ǰ   ��'   CENTERED,   SY-VLINE,
            (10)'INCOTERMS'           CENTERED,   SY-VLINE,
            (10)'Vendor'              CENTERED,   SY-VLINE,
            (18)'�� �� �� ȣ'         CENTERED,   SY-VLINE,
             (9)'�����'              CENTERED,   SY-VLINE.
  WRITE: / SY-ULINE.

ENDFORM.                                 "FORM P3000_TITLE_WRITE.
*&---------------------------------------------------------------------
*&    Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------
FORM P3000_LINE_WRITE.
 FORMAT COLOR COL_NORMAL INTENSIFIED.
 WRITE:/ SY-VLINE,
        (20)IT_TAB-W_PONO, SY-VLINE,
        (20)IT_TAB-ZFCARNM, SY-VLINE,
        (15)IT_TAB-ZFOPNNO, SY-VLINE,
         (8)IT_TAB-W_PORT, SY-VLINE,
        (10)IT_TAB-ZFETA NO-ZERO, SY-VLINE,
*        (10)IT_TAB-ZFRETA, SY-VLINE,
*        (12)W_RETA, SY-VLINE,
        (10)IT_TAB-W_RETA NO-ZERO, SY-VLINE,
        (18)IT_TAB-ZFINDT CENTERED NO-ZERO, SY-VLINE,
         (9)T001-BUTXT, SY-VLINE.

 HIDE IT_TAB.

 FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
 WRITE:/ SY-VLINE,
         (20)IT_TAB-ZFHBLNO, SY-VLINE,
         (20)IT_TAB-ZFBLNO, SY-VLINE,
         (26)IT_TAB-ZFRGDSR, SY-VLINE,
         (10)IT_TAB-INCO1, SY-VLINE,
         (10)IT_TAB-LIFNR, SY-VLINE,
         (18)IT_TAB-ZFINRNO, SY-VLINE,
          (9)IT_TAB-ERNAM, SY-VLINE.

 HIDE IT_TAB.
 WRITE:/ SY-ULINE.
 W_LINE = W_LINE + 1.
ENDFORM.                                 "FORM P3000_LINE_WRITE
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
*&      Form  REFRESH_LIST
*&---------------------------------------------------------------------*
FORM REFRESH_LIST USING    W_ERR_CHK.

  PERFORM   P1000_READ_DATA        USING W_ERR_CHK.
     IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
  PERFORM RESET_LIST.
     IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.

ENDFORM.                    " REFRESH_LIST
