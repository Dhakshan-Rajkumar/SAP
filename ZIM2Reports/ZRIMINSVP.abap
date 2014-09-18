*&---------------------------------------------------------------------*
*& Report  ZRIMINSVP                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : VP ��Ȳ���� ���α׷�                                  *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.3.28                                             *
*&---------------------------------------------------------------------*
*&   DESC. :
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*

REPORT  ZRIMINSVP    NO STANDARD PAGE HEADING MESSAGE-ID ZIM
                     LINE-SIZE 140.

*-----------------------------------------------------------------------
* Table Declaration for Program Configuration.
*-----------------------------------------------------------------------
TABLES: EKKO,                              " ABAP Standard Header Table.
        ZTREQHD,                           " �����Ƿ� Header Table.
        ZTREQIT,                           " �����Ƿ� Item Table.
        LFA1,                              " �ŷ�ó Master Table.
        ZTINS,                             " ����κ�.
        ZTINSRSP,                          " ����κ� Response.
        ZTMSHD,                            " �𼱰��� Header Table.
        ZTMSIT,                            " �𼱰��� ITEM Table.
        ZTREQORJ,                          " �����Ƿ� ������ ���� Table.
        T005T.                             " �����̸� Table.

*-----------------------------------------------------------------------
* Logic for P/O Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_PO OCCURS 1000,
        EBELN    LIKE   EKKO-EBELN,        " P/O Header No..
        EKGRP    LIKE   EKKO-EKGRP,        " ���ű׷�.
        LIFNR    LIKE   EKKO-LIFNR,        " Vendor's Account No..
        NAME1    LIKE   LFA1-NAME1,        " �̸�1.
      END OF IT_PO.

*-----------------------------------------------------------------------
* Logic for L/C Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_RN OCCURS 1000,
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ.
        EBELN     LIKE   ZTREQHD-EBELN,    " Purchasing Document Number.
        EBELP     LIKE   ZTREQIT-EBELP,    " P/O Item Number.
        LIFNR     LIKE   ZTREQHD-LIFNR,    " Vendor's Account Number.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFOPNNO   LIKE   ZTREQHD-ZFOPNNO,  " �ſ���-���ι�ȣ.
        BUKRS     LIKE   ZTREQHD-BUKRS,    " ȸ���ڵ�.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ���Թ��� ǰ���ȣ.
        MATNR     LIKE   ZTREQIT-MATNR,    " Material Number.
        MENGE     LIKE   ZTREQIT-MENGE,    " �����Ƿڼ���.
        MEINS     LIKE   ZTREQIT-MEINS,    " Base Unit of Measure.
        NETPR     LIKE   ZTREQIT-NETPR,    " Net Price.
        PEINH     LIKE   ZTREQIT-PEINH,    " Price Unit.
        BPRME     LIKE   ZTREQIT-BPRME,    " Order Price Unit.
        TXZ01     LIKE   ZTREQIT-TXZ01,    " ����.
        ZFORIG    LIKE   ZTREQORJ-ZFORIG,  " ������걹..
        LANDX     LIKE   T005T-LANDX,      " �����̸�..
      END OF IT_RN.

*-----------------------------------------------------------------------
* Logic for Insurance Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_INS_TMP OCCURS 1000,
        ZFREQNO   LIKE   ZTINS-ZFREQNO, " �����Ƿ� ������ȣ..
        ZFINSEQ   LIKE   ZTINS-ZFINSEQ,
        ZFAMDNO   LIKE   ZTINS-ZFAMDNO, " Amend Seq..
      END OF IT_INS_TMP.

*-----------------------------------------------------------------------
* Logic for Insurance Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_INS OCCURS 1000,
        ZFREQNO   LIKE   ZTINSRSP-ZFREQNO, " �����Ƿ� ������ȣ..
        ZFAMDNO   LIKE   ZTINSRSP-ZFAMDNO, " Amend Seq..
        ZFEXRT    LIKE   ZTINSRSP-ZFEXRT,  " ȯ��..
        ZFTAMI    LIKE   ZTINSRSP-ZFTAMI,  " �Ѻ���ݾ�..
        ZFTAMIC   LIKE   ZTINSRSP-ZFTAMIC, " �Ѻ���ݾ� ��ȭ..
        ZFCAMI    LIKE   ZTINSRSP-ZFCAMI,  " Cargo ��..
        ZFCAMIC   LIKE   ZTINSRSP-ZFCAMIC, " Cargo �� ��ȭ..
        ZFDAMI    LIKE   ZTINSRSP-ZFDAMI,  " Duty ��..
        ZFDAMIC   LIKE   ZTINSRSP-ZFDAMIC, " Duty �� ��ȭ..
        ZFTPR     LIKE   ZTINSRSP-ZFTPR,   " Total Premium..
        ZFTPRC    LIKE   ZTINSRSP-ZFTPRC,  " Total Premium ��ȭ..
        ZFCPR     LIKE   ZTINSRSP-ZFCPR,   " Cargo Premium..
        ZFCPRC    LIKE   ZTINSRSP-ZFCPRC,  " Cargo Premium ��ȭ..
        ZFDPR     LIKE   ZTINSRSP-ZFDPR,   " Duty Premium..
        ZFDPRC    LIKE   ZTINSRSP-ZFDPRC,  " Duty Primium ��ȭ..
        ZFVPR     LIKE   ZTINSRSP-ZFVPR,   " V/P Premium..
        ZFVPRC    LIKE   ZTINSRSP-ZFVPRC,  " V/P Premium ��ȭ..
        ZFIPR     LIKE   ZTINSRSP-ZFIPR,   " ITE Premium..
        ZFIPRC    LIKE   ZTINSRSP-ZFIPRC,  " ITE Premium ��ȭ..
        ZFSCANU   LIKE   ZTINSRSP-ZFSCANU, " ������ۼ��� ����..
        ZFILN     LIKE   ZTINSRSP-ZFILN,   " ���������� ����..
        ZFLINM    LIKE   ZTINSRSP-ZFLINM,  " ������������..
        ZFISDT    LIKE   ZTINSRSP-ZFISDT, " �������ǹ߱���..
        ZFISLO    LIKE   ZTINSRSP-ZFISLO,  " �������ǹ߱���..
        ZFINNO    LIKE   ZTINS-ZFINNO,     " �������ǹ�ȣ.
        ZFINAMT   LIKE   ZTINS-ZFINAMT,    " �����.
        ZFINAMTC  LIKE   ZTINS-ZFINAMTC,   " �������ȭ.
*        ZFINSDT   LIKE   ZTINS-ZFINSDT,    " ���谳����.
        ZFIVAMT   LIKE   ZTINS-ZFIVAMT,    " Invoice �ݾ�.
        WAERS     LIKE   ZTINS-WAERS,      " ��ȭŰ.
      END OF IT_INS.

*-----------------------------------------------------------------------
* Logic for Mother Ship Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_MS OCCURS 1000,
        ZFMSNO    LIKE   ZTMSHD-ZFMSNO,    " �𼱰�����ȣ..
        ZFMSNM    LIKE   ZTMSHD-ZFMSNM,    " �𼱸�..
        ZFREQNO   LIKE   ZTMSIT-ZFREQNO,   " �����Ƿڰ�����ȣ..
        ZFSHSDF   LIKE   ZTMSHD-ZFSHSDF,   " ������(From)..
        ZFSHSDT   LIKE   ZTMSHD-ZFSHSDT,   " ������(To)..
      END OF IT_MS.

*-----------------------------------------------------------------------
* Logic for Vendor Master Data Reference.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_LFA OCCURS 1000,
        LIFNR     LIKE   LFA1-LIFNR,
        NAME1     LIKE   LFA1-NAME1,
      END OF IT_LFA.

*-----------------------------------------------------------------------
* Other Data Declaration.
*-----------------------------------------------------------------------
DATA: W_ERR_CHK   TYPE C,
      W_TABIX     TYPE I.
*-----------------------------------------------------------------------
* Search Condition Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               BUKRS     FOR ZTREQHD-BUKRS,          " ȸ���ڵ�.
               S_EBELN   FOR EKKO-EBELN,             " P/O No.
               S_ISDT    FOR ZTINSRSP-ZFISDT,        " ���� �߱���.
               S_REQNO   FOR ZTREQHD-ZFREQNO,        " �����Ƿ� No.
               S_OPNNO   FOR ZTREQHD-ZFOPNNO,        " �ſ���-���ι�ȣ.
               S_LIFNR   FOR ZTREQHD-LIFNR.          " Vendor.
SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* Initialization.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.

*-----------------------------------------------------------------------
* Start-Of-Selection.
*-----------------------------------------------------------------------
START-OF-SELECTION.

* Read L/C Internal Table.
   PERFORM P1000_READ_RN_DATA.

* Read P/O Internal Table.
   PERFORM P1000_READ_PO_DATA.

* Read Mother Ship Internal Table.
   PERFORM P1000_READ_MS_DATA.

* Read Insurance Internal Table.
   PERFORM P1000_READ_INS_DATA.

* Read Vendor Master Internal Table.
   PERFORM P1000_READ_LFA_DATA.

*-----------------------------------------------------------------------
* Top-Of-Page.
*-----------------------------------------------------------------------
TOP-OF-PAGE.

   PERFORM P3000_WRITE_TITLE.

*-----------------------------------------------------------------------
* End-Of-Selection.
*-----------------------------------------------------------------------
END-OF-SELECTION.
   CHECK W_ERR_CHK NE 'Y'.
* Title Text Write.
   SET TITLEBAR 'TIT1'.
   SET PF-STATUS 'ZIMR15'.

   PERFORM P2000_SORT_RESULT_DATA.

   PERFORM P3000_WRITE_RESULT_DATA.


*-----------------------------------------------------------------------
* At User-Command.
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'INS'.
         IF NOT IT_INS-ZFREQNO IS INITIAL.
            SET PARAMETER ID 'ZPREQNO' FIELD IT_INS-ZFREQNO.
            SET PARAMETER ID 'ZPOPNNO' FIELD ''.
            SET PARAMETER ID 'BES' FIELD ''.
            CALL TRANSACTION 'ZIM43' AND SKIP FIRST SCREEN.
         ENDIF.
   ENDCASE.
   CLEAR: IT_INS.

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_PO_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_PO_DATA.

   SELECT *
     INTO   CORRESPONDING FIELDS OF TABLE IT_PO
     FROM   EKKO
     FOR    ALL  ENTRIES  IN  IT_RN
     WHERE  EBELN    IN S_EBELN
     AND    LIFNR    IN S_LIFNR
     AND    EBELN    EQ IT_RN-EBELN.

   IF SY-SUBRC NE 0.
   WRITE 'NOT A VALID INPUT.'.
   EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_PO_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_RN_DATA.

   W_ERR_CHK = 'N'.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_RN
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO
     AND    H~ZFOPNNO  IN  S_OPNNO
     AND    H~EBELN    IN  S_EBELN
     AND    H~LIFNR    IN  S_LIFNR
     AND    I~ZFITMNO  EQ  '00010'
     AND    H~ZFINSYN  NE  SPACE.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

   LOOP AT IT_RN.
      ON CHANGE OF IT_RN-ZFREQNO.
         SELECT SINGLE * FROM ZTREQORJ
                        WHERE ZFREQNO = IT_RN-ZFREQNO
                          AND ZFLSG7O = '00010'.

         SELECT SINGLE * FROM T005T
                        WHERE LAND1   = ZTREQORJ-ZFORIG
                          AND SPRAS   = SY-LANGU.
      ENDON.

      MOVE: ZTREQORJ-ZFORIG TO IT_RN-ZFORIG,
            T005T-LANDX     TO IT_RN-LANDX.
      MODIFY IT_RN.
   ENDLOOP.

ENDFORM.                    " P1000_READ_RN_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_MS_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_MS
     FROM   ZTMSHD AS H INNER JOIN ZTMSIT AS I
     ON     H~ZFMSNO EQ I~ZFMSNO
     FOR ALL ENTRIES   IN  IT_RN
     WHERE  I~ZFREQNO  EQ  IT_RN-ZFREQNO.

ENDFORM.                    " P1000_READ_MS_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_INS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_INS_DATA.

   SELECT H~ZFREQNO MAX( H~ZFINSEQ ) AS ZFINSEQ
                    MAX( H~ZFAMDNO ) AS ZFAMDNO
   INTO   CORRESPONDING FIELDS OF TABLE IT_INS_TMP
   FROM   ZTINS AS H INNER JOIN ZTREQHD  AS I
   ON     H~ZFREQNO     EQ  I~ZFREQNO
   WHERE  I~ZFREQNO     IN  S_REQNO
   AND    I~ZFOPNNO     IN  S_OPNNO
   AND    I~EBELN       IN  S_EBELN
   AND    I~LIFNR       IN  S_LIFNR
   GROUP BY
         H~ZFREQNO.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_INS
     FROM   ZTINSRSP AS H INNER JOIN ZTINS AS I
     ON     H~ZFREQNO  EQ  I~ZFREQNO
     AND    H~ZFINSEQ  EQ  I~ZFINSEQ
     AND    H~ZFAMDNO  EQ  I~ZFAMDNO
     FOR ALL ENTRIES   IN  IT_INS_TMP
     WHERE  H~ZFREQNO  EQ  IT_INS_TMP-ZFREQNO
     AND    H~ZFINSEQ  EQ  IT_INS_TMP-ZFINSEQ
     AND    H~ZFAMDNO  EQ  IT_INS_TMP-ZFAMDNO.


ENDFORM.                    " P1000_READ_INS_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_LFA_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_LFA_DATA.

   SELECT *
     INTO   CORRESPONDING FIELDS OF TABLE IT_LFA
     FROM   LFA1
     FOR ALL ENTRIES IN IT_RN
     WHERE  LIFNR EQ IT_RN-LIFNR.

ENDFORM.                    " P1000_READ_LFA_DATA

*&---------------------------------------------------------------------*
*&      Form  P2000_SORT_RESULT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P2000_SORT_RESULT_DATA.

ENDFORM.                    " P2000_SORT_RESULT_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_TITLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_TITLE.
   WRITE: 65 '[V/P ��Ȳ]' NO-GAP COLOR COL_HEADING INTENSIFIED ON.
   SKIP.
   WRITE: 125 'DATE:' NO-GAP, SY-DATUM(4) NO-GAP, '/' NO-GAP,
                  SY-DATUM+4(2) NO-GAP, '/' NO-GAP,
                  SY-DATUM+6(2) NO-GAP.
   FORMAT COLOR COL_HEADING INTENSIFIED OFF.
   WRITE: / SY-ULINE, SY-VLINE NO-GAP,
            'L/C ��ȣ' NO-GAP,
            37 SY-VLINE NO-GAP, '���޻�' NO-GAP,
            73 SY-VLINE NO-GAP, '������' NO-GAP,
            84 SY-VLINE NO-GAP, '�����' NO-GAP,
           115 SY-VLINE NO-GAP, 'V/P �ݾ�' NO-GAP,
           140 SY-VLINE NO-GAP,
          / SY-VLINE NO-GAP, '�𼱸�' NO-GAP,
            37 SY-VLINE NO-GAP, '�������ǹ�ȣ' NO-GAP,
            73 SY-VLINE NO-GAP, '�߱���' NO-GAP,
            84 SY-VLINE NO-GAP, '�����' NO-GAP,
           115 SY-VLINE NO-GAP, 'Invoice Amount' NO-GAP,
           140 SY-VLINE NO-GAP,
            SY-ULINE.
ENDFORM.                    " P3000_WRITE_TITLE

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_RESULT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_RESULT_DATA.

   W_TABIX = 0.
   LOOP AT IT_RN.
*      LOOP AT IT_PO
*         WHERE EBELN EQ IT_RN-EBELN.
         READ TABLE IT_PO   WITH KEY EBELN   = IT_RN-EBELN.
         READ TABLE IT_LFA  WITH KEY LIFNR   = IT_PO-LIFNR.
         IF SY-SUBRC NE 0. CLEAR IT_LFA. ENDIF.
         READ TABLE IT_MS   WITH KEY ZFREQNO = IT_RN-ZFREQNO.
         IF SY-SUBRC NE 0. CLEAR IT_MS.  ENDIF.
         READ TABLE IT_INS    WITH KEY ZFREQNO = IT_RN-ZFREQNO.
         IF SY-SUBRC NE 0. CONTINUE.     ENDIF.
         IF NOT IT_INS-ZFVPR IS INITIAL.
            FORMAT COLOR COL_NORMAL INTENSIFIED ON.
            WRITE: / SY-VLINE NO-GAP, IT_RN-ZFOPNNO NO-GAP,
                     SY-VLINE NO-GAP, IT_LFA-NAME1 NO-GAP,
                     SY-VLINE NO-GAP, IT_RN-LANDX NO-GAP,
                  84 SY-VLINE NO-GAP, IT_INS-ZFINAMTC NO-GAP,
                  96 IT_INS-ZFINAMT CURRENCY IT_INS-ZFINAMTC NO-GAP,
                 115 SY-VLINE NO-GAP, IT_INS-ZFVPRC NO-GAP,
                     IT_INS-ZFVPR CURRENCY IT_INS-ZFVPRC NO-GAP,
                 140 SY-VLINE NO-GAP.
            HIDE: IT_INS.
            FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
            WRITE: / SY-VLINE NO-GAP, IT_MS-ZFMSNM NO-GAP,
                  37 SY-VLINE NO-GAP, IT_INS-ZFINNO NO-GAP,
                     SY-VLINE NO-GAP, IT_INS-ZFISDT NO-GAP,
                     SY-VLINE NO-GAP, IT_RN-TXZ01(30) NO-GAP,
                     SY-VLINE NO-GAP, IT_INS-WAERS NO-GAP,
                     IT_INS-ZFIVAMT CURRENCY IT_INS-WAERS NO-GAP,
                     SY-VLINE NO-GAP.
            HIDE: IT_INS.
            WRITE: SY-ULINE.
            W_TABIX = W_TABIX + 1.
         ENDIF.
*      ENDLOOP.
   ENDLOOP.
   CLEAR: IT_INS.
   FORMAT RESET.
   WRITE: /125 '��:' NO-GAP, W_TABIX NO-GAP, '��'.
ENDFORM.                    " P3000_WRITE_RESULT_DATA
