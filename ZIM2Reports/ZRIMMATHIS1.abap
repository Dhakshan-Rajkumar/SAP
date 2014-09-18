*&---------------------------------------------------------------------*
*& Report ZRIMMATHIS                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �������纰 ��Ȳ���� PROGRAM                           *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.12.21                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1. ����ȣ�� ����° ����Ʈ ���α׷� ����~ .
*&
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT ZRIMMATHIS NO STANDARD PAGE HEADING MESSAGE-ID ZIM
                     LINE-SIZE 293.

tables: EKKO,                " ABAP Standard Header Table..
        EKPO,                " ABAP Standard Item Table..
        ZTREQHD,             " �����Ƿ� Header Table..
        ZTREQIT,             " �����Ƿ� Item Table..
        ZTBL,                " B/L Table..
        ZTBLIT,              " B/L  Item Table..
        LFA1,                " �ŷ�ó Master Table..
        ZTMSHD,              " �𼱰��� Header Table..
        ZTCGHD,              " �Ͽ� Header Table..
        ZTCGIT,              " �Ͽ� ���� Table..
        ZTREQORJ,            " �����Ƿ� ������ ���� Table..
        ZTIMIMG03,           " �������� �ڵ� Table..
        T005T.               " �����̸� Table..

*------------------------------------------*
* P/O ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*------------------------------------------*

DATA: BEGIN OF IT_PO OCCURS 1000,
        EBELN    LIKE   EKKO-EBELN,      " P/O Header No..
        LIFNR    LIKE   EKKO-LIFNR,      " Vendor's Account No..
        AEDAT    LIKE   EKKO-AEDAT,      " ���ڵ������..
        WAERS    LIKE   EKKO-WAERS,      " ��ȭŰ..
        EBELP    LIKE   EKPO-EBELP,      " P/O Item No..
        MATNR    LIKE   EKPO-MATNR,      " �����ȣ..
        BUKRS    LIKE   EKPO-BUKRS,      " ȸ���ڵ�..
        WERKS    LIKE   EKPO-WERKS,      " �÷�Ʈ..
        TXZ01    LIKE   EKPO-TXZ01,      " ����..
        MENGE    LIKE   EKPO-MENGE,      " ���ſ�������..
        MEINS    LIKE   EKPO-MEINS,      " ��������..
        NETPR    LIKE   EKPO-NETPR,      " ���Ź����� �ܰ� (������ȭ).
        PEINH    LIKE   EKPO-PEINH,      " ���ݴ���..
        NAME1    LIKE   LFA1-NAME1,      " �̸�1..
      END OF IT_PO.

*-----------------------------------------------*
* �����Ƿ� ��ȣ ��ȸ�� ���� INTERNAL TABLE ���� *
*-----------------------------------------------*

DATA: BEGIN OF IT_RN OCCURS 1000,
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ.
        EBELN     LIKE   ZTREQHD-EBELN,    " Purchasing Document Number.
        EBELP     LIKE   ZTREQIT-EBELP,    " P/O Item Number.
        LIFNR     LIKE   ZTREQHD-LIFNR,    " Vendor's Account Number.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFOPNNO   LIKE   ZTREQHD-ZFOPNNO,  " �ſ���-���ι�ȣ.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ���Թ��� ǰ���ȣ.
        MATNR     LIKE   ZTREQIT-MATNR,    " Material Number.
        MENGE     LIKE   ZTREQIT-MENGE,    " �����Ƿڼ���.
        MEINS     LIKE   ZTREQIT-MEINS,    " Base Unit of Measure.
        NETPR     LIKE   ZTREQIT-NETPR,    " Net Price.
        PEINH     LIKE   ZTREQIT-PEINH,    " Price Unit.
        BPRME     LIKE   ZTREQIT-BPRME,    " Order Price Unit.
        ZFORIG    LIKE   ZTREQORJ-ZFORIG,  " ������걹..
        LANDX     LIKE   T005T-LANDX,      " �����̸�..
        END OF IT_RN.

*-----------------------------------------------------------------------
* B/L ��ȣ ��ȸ�� ���� Internal Table Declaration.
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_BL OCCURS 1000,
        ZFBLNO    LIKE   ZTBL-ZFBLNO,      " B/L ���� ��ȣ..
        ZFMSNO    LIKE   ZTBL-ZFMSNO,      " �𼱰�����ȣ..
        ZFFORD    LIKE   ZTBL-ZFFORD,      " Forwarder..
        ZFAPRTC   LIKE   ZTBL-ZFAPRTC,     " ������ �ڵ�..
        ZFAPRT    LIKE   ZTBL-ZFAPRT,      " ������..
        ZFHBLNO   LIKE   ZTBL-ZFHBLNO,     " House B/L No..
        ZFREBELN  LIKE   ZTBL-ZFREBELN,    " ��ǥ P/O No..
        LIFNR     LIKE   ZTBL-LIFNR,       " Account No..
        ZFOPNNO   LIKE   ZTBL-ZFOPNNO,     " �ſ���-���ι�ȣ.
        ZFETA     LIKE   ZTBL-ZFETA,       " ������(ETD)..
        ZFBLIT    LIKE   ZTBLIT-ZFBLIT,    " B/L ǰ���ȣ..
        EBELN     LIKE   ZTBLIT-EBELN,     " ���Ź�����ȣ..
        EBELP     LIKE   ZTBLIT-EBELP,     " ���Ź��� ǰ���ȣ..
        ZFREQNO   LIKE   ZTBLIT-ZFREQNO,   " �����Ƿ� ������ȣ..
        ZFITMNO   LIKE   ZTBLIT-ZFITMNO,   " ���Թ��� ǰ���ȣ..
        MATNR     LIKE   ZTBLIT-MATNR,     " �����ȣ..
        BLMENGE   LIKE   ZTBLIT-BLMENGE,   " B/L ����..
        MEINS     LIKE   ZTBLIT-MEINS,     " �⺻����..
      END OF IT_BL.

*-----------------------------------------------------------------------
* �𼱰����� ���� Internal Table ����..
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_MS OCCURS 1000,
        ZFMSNO    LIKE   ZTMSHD-ZFMSNO,    " �𼱰�����ȣ..
        ZFMSNM    LIKE   ZTMSHD-ZFMSNM,    " �𼱸�..
        ZFREQNO   LIKE   ZTMSIT-ZFREQNO,   " �����Ƿڰ�����ȣ..
        ZFSHSDF   LIKE   ZTMSHD-ZFSHSDF,   " ������(From)..
        ZFSHSDT   LIKE   ZTMSHD-ZFSHSDT,   " ������(To)..
      END OF IT_MS.

*-----------------------------------------------------------------------
* �Ͽ��� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_CG OCCURS 1000,
        ZFCGNO    LIKE   ZTCGHD-ZFCGNO,    " �Ͽ�������ȣ..
        ZFMSNO    LIKE   ZTCGHD-ZFMSNO,    " �𼱰�����ȣ..
        ZFETA     LIKE   ZTCGHD-ZFETA,     " ������(ETA)..
        ZFCGPT    LIKE   ZTCGHD-ZFCGPT,    " �Ͽ���..
        ZFCGIT    LIKE   ZTCGIT-ZFCGIT,    " �Ͽ��������..
        EBELN     LIKE   ZTCGIT-EBELN,     " ���Ź�����ȣ..
        EBELP     LIKE   ZTCGIT-EBELP,     " ���Ź��� ǰ���ȣ..
        ZFREQNO   LIKE   ZTCGIT-ZFREQNO,   " �����Ƿ� ������ȣ..
        ZFITMNO   LIKE   ZTCGIT-ZFITMNO,   " ���Թ��� ǰ���ȣ..
        ZFBLNO    LIKE   ZTCGIT-ZFBLNO,    " B/L ������ȣ..
        ZFBLIT    LIKE   ZTCGIT-ZFBLIT,    " B/L ǰ���ȣ..
        MATNR     LIKE   ZTCGIT-MATNR,     " �����ȣ..
        CGMENGE   LIKE   ZTCGIT-CGMENGE,   " �Ͽ��������..
        MEINS     LIKE   ZTCGIT-MEINS,     " �⺻����..
        ZFBNARCD  LIKE   ZTCGIT-ZFBNARCD,  " �������� ���ΰ����ڵ�..
      END OF IT_CG.

*-----------------------------------------------------------------------
* �ŷ�ó������ ���̺� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_LFA OCCURS 1000,
         LIFNR    LIKE   LFA1-LIFNR,
         NAME1    LIKE   LFA1-NAME1,
      END OF IT_LFA.

*-----------------------------------------------------------------------
* ���������ڵ� ���̺� ��ȸ�� ���� Internal Table ����...
*-----------------------------------------------------------------------

DATA: BEGIN OF IT_IMG03 OCCURS 1000.
      INCLUDE STRUCTURE ZTIMIMG03.
DATA  END OF IT_IMG03.

*-----------------------------------------------------------------------
* ���̺��� ��뿡 ���õ� ���� ����..
*-----------------------------------------------------------------------
DATA: W_TABIX     LIKE SY-TABIX,
      W_BEWTP     LIKE EKBE-BEWTP,
      W_ERR_CHK   TYPE C,
      W_PAGE      TYPE I.
*-----------------------------------------------------------------------
* ON CHANGE OF ����� ����ϱ� ���� ���� ����..
*-----------------------------------------------------------------------
DATA: TEMP_MATNR  LIKE EKPO-MATNR,         " �����ȣ�� �ӽ÷� ����..
      TEMP_TXZ01  LIKE EKPO-TXZ01,         " ���系���� �ӽ÷� ����..
      TEMP_EBELN  LIKE EKPO-EBELN,         " P/O ��ȣ�� �ӽ÷� ����..
      TEMP_EBELP  LIKE EKPO-EBELP,         " Item ��ȣ�� �ӽ÷� ����..
      TEMP_REQNO  LIKE ZTREQHD-ZFREQNO,    " �����Ƿڰ�����ȣ ����..
      TEMP_ITMNO  LIKE ZTREQIT-ZFITMNO,    " Item ��ȣ�� �ӽ÷� ����..
      TEMP_BLNO   LIKE ZTBL-ZFBLNO,        " B/L ��ȣ�� �ӽ÷� ����..
      TEMP_BLIT   LIKE ZTBLIT-ZFBLIT,      " B/L Item ��ȣ �ӽ�����..
      TEMP_CGNO   LIKE ZTCGHD-ZFCGNO,      " �Ͽ�������ȣ�� �ӽ�����..
      TEMP_CGIT   LIKE ZTCGIT-ZFCGIT.      " �Ͽ���������� �ӽ�����..

*-----------------------------------------------------------------------
* HIDE VARIABLE.
*-----------------------------------------------------------------------

DATA: BEGIN OF DOCU,
        TYPE(2)   TYPE C,
        CODE      LIKE EKKO-EBELN,
        ITMNO     LIKE EKPO-EBELP,
        YEAR      LIKE BKPF-GJAHR,
      END OF DOCU.

*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
               S_EBELN   FOR EKKO-EBELN,       " P/O No.
               S_MATNR   FOR EKPO-MATNR,       " ���� No.
               S_REQNO   FOR ZTREQHD-ZFREQNO,  " �����Ƿ� No.
               S_OPNNO   FOR ZTREQHD-ZFOPNNO,  " �ſ���-���ι�ȣ.
               S_LIFNR   FOR ZTREQHD-LIFNR.    " Vendor.
SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION.
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.

*-----------------------------------------------------------------------
* START-OF-SELECTION.
*-----------------------------------------------------------------------
START-OF-SELECTION.

* �����Ƿ� No.
   PERFORM P1000_READ_RN_DATA USING W_ERR_CHK.
   CHECK W_ERR_CHK NE 'Y'.

* P/O Table Select..
   PERFORM P1000_READ_PO_DATA.

* ���������ڵ� Table Select..
   PERFORM P1000_READ_IMG03_DATA.

* ����ó Table Select..
   PERFORM P1000_READ_LFA_DATA.

* �� Table Select..
   PERFORM P1000_READ_MS_DATA.

* B/L Table Select..
   PERFORM P1000_READ_BL_DATA.

* �Ͽ� Table Select..
   PERFORM P1000_READ_CG_DATA.

*-----------------------------------------------------------------------
* END-OF-SELECTION.
*-----------------------------------------------------------------------
END-OF-SELECTION.
   CHECK W_ERR_CHK NE 'Y'.
* Title Text Write.
   SET TITLEBAR 'TIT1'.
   SET PF-STATUS 'ZIMH1'.

   PERFORM P3000_TITLE_WRITE.             "��� ���...

* Sort P/O, Request No. Internal Table.
   PERFORM P2000_SORT_IT_DATA.

* List Write...
   PERFORM P3000_WRITE_PO_DATA.

*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT LINE-SELECTION.

DATA : L_TEXT_AEDAT(20),
       L_TEXT_PO(20),
       L_TEXT_RN(20),
       L_TEXT_BL(24).
DATA : MM03_START_SICHT(15) TYPE C  VALUE 'BDEKLPQSVXZA'.

   GET CURSOR FIELD MM03_START_SICHT.
   CASE MM03_START_SICHT.   " �ʵ��..

      WHEN 'IT_PO-MATNR' OR 'IT_PO-TXZ01'.
         SET PARAMETER ID 'MAT' FIELD IT_PO-MATNR.
         SET PARAMETER ID 'BUK' FIELD IT_PO-BUKRS.
         SET PARAMETER ID 'WRK' FIELD IT_PO-WERKS.
         SET PARAMETER ID 'LAG' FIELD ''.
         SET PARAMETER ID 'MXX' FIELD MM03_START_SICHT.
         CALL TRANSACTION 'MM03' AND SKIP  FIRST SCREEN.

   ENDCASE.

   GET CURSOR FIELD L_TEXT_AEDAT.
   CASE L_TEXT_AEDAT.   " �ʵ��..

      WHEN 'L_DATE'.
         SET PARAMETER ID 'BES'  FIELD IT_PO-EBELN.
         CALL TRANSACTION 'ME23' AND SKIP FIRST SCREEN.
   ENDCASE.

   GET CURSOR FIELD L_TEXT_PO.
   CASE L_TEXT_PO.   " �ʵ��..

      WHEN 'IT_PO-EBELN' OR 'IT_PO-EBELP'.
         SET PARAMETER ID 'BES'  FIELD IT_PO-EBELN.
         CALL TRANSACTION 'ME23' AND SKIP FIRST SCREEN.
   ENDCASE.
   CLEAR: IT_PO.

   GET CURSOR FIELD L_TEXT_RN.
   CASE L_TEXT_RN.   " �ʵ��..

      WHEN 'IT_RN-ZFOPNNO'.
         SET PARAMETER ID 'ZPREQNO' FIELD IT_RN-ZFREQNO.
         CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.

   ENDCASE.
   CLEAR: IT_RN.

   GET CURSOR FIELD L_TEXT_BL.
   CASE L_TEXT_BL.   " �ʵ��..

      WHEN 'IT_BL-ZFHBLNO'.
         SET PARAMETER ID 'ZPBLNO' FIELD IT_BL-ZFBLNO.
         CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.

   ENDCASE.
   CLEAR: IT_BL.

*   GET CURSOR FIELD L_TEXT_CG.
*   CASE L_TEXT_CG.   " �ʵ��..
*
*      WHEN '' OR ''
*        OR '' OR ''
*        OR '' OR ''.
*         SET PARAMETER ID 'ZPBLNO' FIELD IT_BL-ZFBLNO.
*         CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.
*
*   ENDCASE.
*   CLEAR: IT_CG.


*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
*AT USER-COMMAND.
*   CASE SY-UCOMM.
*      WHEN 'DISP'.
*      CASE DOCU-TYPE.
*         WHEN 'VD'.     " Vendor
*            MESSAGE I977 WITH DOCU-CODE.
*
*            SET PARAMETER ID 'KDY' FIELD '/110/120/130'.
*            SET PARAMETER ID 'LIF' FIELD DOCU-CODE.
*            SET PARAMETER ID 'EKO' FIELD ''.
*            CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.
*         WHEN 'PO'.     " P/O
*            SET PARAMETER ID 'BES' FIELD DOCU-CODE.
*            SET PARAMETER ID 'BSP' FIELD DOCU-ITMNO.
*            CALL TRANSACTION 'ME23' AND SKIP FIRST SCREEN.
*
*         WHEN 'RN'.     " L/C
*            SET PARAMETER ID 'ZPREQNO' FIELD DOCU-CODE.
*            SET PARAMETER ID 'ZPAMDNO' FIELD DOCU-ITMNO.
*            SET PARAMETER ID 'ZPOPNNO' FIELD ''.
*            SET PARAMETER ID 'BES'     FIELD ''.
*            IF DOCU-ITMNO IS INITIAL.
*            CALL TRANSACTION 'ZIM03' AND SKIP FIRST SCREEN.
*            ELSE.
*            CALL TRANSACTION 'ZIM13' AND SKIP FIRST SCREEN.
*            ENDIF.
*
*         WHEN 'BL'.     "  Bill of Lading.
*            SET PARAMETER ID 'ZPHBLNO' FIELD ''.
*            SET PARAMETER ID 'ZPBLNO' FIELD DOCU-CODE.
*            CALL TRANSACTION 'ZIM23' AND SKIP FIRST SCREEN.
*
*         WHEN 'IV'.     "  Invoice
*            SET PARAMETER ID 'ZPCIVNO' FIELD ''.
*            SET PARAMETER ID 'ZPIVNO' FIELD DOCU-CODE.
*            CALL TRANSACTION 'ZIM58' AND SKIP FIRST SCREEN.
*
*   WHEN 'MD'.     " ���繮��.
**>>> ����.
*      SET PARAMETER ID 'MJA'     FIELD DOCU-YEAR.
**>>> ������ȣ.
*      SET PARAMETER ID 'MBN'     FIELD DOCU-CODE.
*      SET PARAMETER ID 'POS'     FIELD ''.
*      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
*
*      ENDCASE.
*   ENDCASE.
*
*   CLEAR DOCU.
*
*&------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&------------------------------------------------------------------*
FORM P1000_READ_RN_DATA USING W_ERR_CHK.

   W_ERR_CHK = 'N'.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_RN
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO
     AND    H~ZFOPNNO  IN  S_OPNNO
     AND    H~EBELN    IN  S_EBELN
     AND    I~MATNR    IN  S_MATNR
     AND    H~LIFNR    IN  S_LIFNR.

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
*&      Form  P1000_READ_PO_DATA
*&---------------------------------------------------------------------*
FORM P1000_READ_PO_DATA.

   SELECT *
     INTO   CORRESPONDING FIELDS OF TABLE IT_PO
     FROM   EKKO AS H INNER JOIN EKPO AS I
     ON     H~EBELN EQ I~EBELN
     FOR ALL ENTRIES IN IT_RN
     WHERE  H~EBELN EQ IT_RN-EBELN
     AND    I~MATNR EQ IT_RN-MATNR
     AND    H~LIFNR EQ IT_RN-LIFNR.

   IF SY-SUBRC NE 0.
   WRITE 'NOT A VALID INPUT.'.
   EXIT.
   ENDIF.

ENDFORM.                    " P1000_READ_PO_DATA

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

   SELECT *
     APPENDING  CORRESPONDING FIELDS OF TABLE IT_LFA
     FROM   LFA1
     FOR ALL ENTRIES IN IT_IMG03
     WHERE  LIFNR EQ IT_IMG03-LIFNR.

ENDFORM.                    " P1000_READ_LFA_DATA

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
*&      Form  P1000_READ_BL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_BL_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_BL
     FROM   ZTBL AS H INNER JOIN ZTBLIT AS I
     ON     H~ZFBLNO  EQ I~ZFBLNO
     FOR ALL ENTRIES IN IT_RN
     WHERE  I~EBELN   EQ IT_RN-EBELN
     AND    I~MATNR   EQ IT_RN-MATNR
     AND    I~ZFREQNO EQ IT_RN-ZFREQNO
     AND    H~ZFOPNNO EQ IT_RN-ZFOPNNO.

ENDFORM.                    " P1000_READ_BL_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_CG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_CG_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_CG
     FROM   ZTCGHD AS H INNER JOIN ZTCGIT AS I
     ON     H~ZFCGNO EQ I~ZFCGNO
     FOR ALL ENTRIES   IN  IT_BL
     WHERE  I~EBELN    EQ  IT_BL-EBELN
     AND    I~EBELP    EQ  IT_BL-EBELP
     AND    I~ZFREQNO  EQ  IT_BL-ZFREQNO
     AND    I~ZFITMNO  EQ  IT_BL-ZFITMNO
     AND    I~ZFBLNO   EQ  IT_BL-ZFBLNO
     AND    I~ZFBLIT   EQ  IT_BL-ZFBLIT
     AND    I~MATNR    EQ  IT_BL-MATNR.

ENDFORM.                    " P1000_READ_CG_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_IMG03_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P1000_READ_IMG03_DATA.

   SELECT *
     INTO   CORRESPONDING FIELDS OF TABLE IT_IMG03
     FROM   ZTIMIMG03
     FOR ALL ENTRIES IN IT_CG
     WHERE  ZFBNARCD EQ IT_CG-ZFBNARCD.

ENDFORM.                    " P1000_READ_IMG03_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.
   SKIP 2.
   FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
   WRITE: /55 '[���纰 ������Ȳ]'
              COLOR COL_HEADING INTENSIFIED OFF.

   WRITE: / 'Date: ' COLOR COL_NORMAL INTENSIFIED ON,
             SY-DATUM COLOR COL_NORMAL INTENSIFIED OFF.

ENDFORM.                    " P3000_TITLE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_SORT_IT_DATA
*&---------------------------------------------------------------------*
*       SORTING INTERNAL TABLE..
*----------------------------------------------------------------------*
FORM P2000_SORT_IT_DATA.

   SORT IT_PO BY MATNR EBELN EBELP.
   SORT IT_RN BY MATNR EBELN ZFITMNO ZFREQNO.

ENDFORM.                    " P2000_SORT_IT_DATA

*----------------------------------------------------------------------*
* ���ȭ�� ��ȸ�� ���� PERFORM ��..
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  P3000_WEITE_PO_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_PO_DATA.
DATA : L_FIRST_LINE   VALUE  'Y',
       L_DATE(10).

*>>> �ӽú����� ������ �ʱ�ȭ..
   CLEAR: TEMP_MATNR,
          TEMP_EBELN,
          TEMP_EBELP,
          TEMP_TXZ01.
   SKIP.
   LOOP AT IT_PO.
      IF TEMP_TXZ01 NE IT_PO-TXZ01.
         FORMAT COLOR COL_HEADING INTENSIFIED ON.
         ULINE.
         WRITE: / IT_PO-MATNR NO-GAP, IT_PO-TXZ01 NO-GAP.
         HIDE: IT_PO.
         FORMAT RESET.
      ENDIF.

      IF IT_PO-EBELN NE TEMP_EBELN.
         READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
         FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
         CONCATENATE  IT_PO-AEDAT(4)  IT_PO-AEDAT+4(2)
                       IT_PO-AEDAT+6(2)
                       INTO L_DATE
                       SEPARATED BY '/'.
         WRITE: / L_DATE.
         WRITE: 12 IT_PO-EBELN NO-GAP.

         READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
         FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
         WRITE: 23 IT_PO-EBELP NO-GAP.
         WRITE: 29 IT_PO-NETPR CURRENCY IT_PO-WAERS NO-GAP,
                43 IT_PO-WAERS NO-GAP,
                49 IT_PO-PEINH NO-GAP, 55 IT_LFA-NAME1(20) NO-GAP.
         HIDE: IT_PO.

      ELSEIF IT_PO-EBELP NE TEMP_EBELP.
         READ TABLE IT_LFA WITH KEY LIFNR = IT_PO-LIFNR.
         FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
         WRITE: /23 IT_PO-EBELP NO-GAP.
         WRITE:  29 IT_PO-NETPR CURRENCY IT_PO-WAERS NO-GAP,
                 43 IT_PO-WAERS NO-GAP,
                 49 IT_PO-PEINH NO-GAP, 55 IT_LFA-NAME1(20) NO-GAP.
         HIDE: IT_PO.
      ENDIF.
      PERFORM P3000_WRITE_RN_DATA.
      TEMP_MATNR = IT_PO-MATNR.
      TEMP_TXZ01 = IT_PO-TXZ01.
      TEMP_EBELN = IT_PO-EBELN.
      TEMP_EBELP = IT_PO-EBELP.
      CLEAR: IT_PO.
   ENDLOOP.

ENDFORM.                    " P3000_WEITE_PO_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_RN_DATA
*&---------------------------------------------------------------------*
FORM P3000_WRITE_RN_DATA.
DATA : L_FIRST_LINE   VALUE  'Y',
       L_DATE_F(10),
       L_DATE_T(10).

*>>> �ӽú����� ������ �ʱ�ȭ..
CLEAR: TEMP_REQNO,
       TEMP_ITMNO.

   LOOP AT IT_RN
      WHERE EBELN = IT_PO-EBELN
        AND EBELP = IT_PO-EBELP.
      IF TEMP_REQNO NE IT_RN-ZFREQNO.
         IF L_FIRST_LINE = 'Y'.
            WRITE: 76 IT_RN-ZFOPNNO(20) NO-GAP.
            HIDE: IT_RN.
         ELSE.
            WRITE:/76 IT_RN-ZFOPNNO(20) NO-GAP.
            HIDE: IT_RN.
         ENDIF.
         L_FIRST_LINE = 'N'.

         WRITE: 97 IT_RN-ZFITMNO NO-GAP,
                104 IT_RN-LANDX NO-GAP,
                120 IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP,
                138 IT_RN-MEINS NO-GAP.
         HIDE: IT_RN.
      ELSEIF TEMP_ITMNO NE IT_RN-ZFITMNO.
         WRITE: /97 IT_RN-ZFITMNO NO-GAP,
                104 IT_RN-LANDX NO-GAP,
                120 IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP,
                138 IT_RN-MEINS NO-GAP.
         HIDE: IT_RN.
      ENDIF.

      LOOP AT IT_MS
            WHERE ZFREQNO = IT_RN-ZFREQNO.
            CONCATENATE IT_MS-ZFSHSDF(4)
                         IT_MS-ZFSHSDF+4(2)
                         IT_MS-ZFSHSDF+6(2)
                         INTO L_DATE_F
                         SEPARATED BY '/'.

            CONCATENATE IT_MS-ZFSHSDT(4)
                         IT_MS-ZFSHSDT+4(2)
                         IT_MS-ZFSHSDT+6(2)
                         INTO L_DATE_T
                         SEPARATED BY '/'.

            WRITE: 142 IT_MS-ZFMSNM(18) NO-GAP,
                   161 L_DATE_F NO-GAP,
                   172 L_DATE_T NO-GAP.

            PERFORM P3000_WRITE_BL_DATA.
         CLEAR: IT_RN.
      ENDLOOP.
      IF SY-SUBRC NE 0.
         PERFORM P3000_WRITE_BL_DATA.
      ENDIF.

      TEMP_REQNO = IT_RN-ZFREQNO.
      TEMP_ITMNO = IT_RN-ZFITMNO.
   ENDLOOP.

ENDFORM.                    " P3000_WRITE_RN_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_BL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_BL_DATA.
DATA : L_FIRST_LINE   VALUE  'Y'.

*>>> �ӽú����� ������ �ʱ�ȭ..
CLEAR : TEMP_BLNO,
        TEMP_BLIT.

   LOOP AT IT_BL
      WHERE ZFREQNO = IT_RN-ZFREQNO
        AND ZFITMNO = IT_RN-ZFITMNO.
      IF TEMP_BLNO NE IT_BL-ZFBLNO.
         WRITE: 183 IT_BL-ZFHBLNO NO-GAP,
                208 IT_BL-ZFBLIT NO-GAP, 214 IT_BL-ZFFORD NO-GAP,
                225 IT_BL-BLMENGE UNIT IT_BL-MEINS NO-GAP,
                239 IT_BL-MEINS NO-GAP, 243 IT_BL-ZFAPRTC NO-GAP.
         HIDE: IT_BL.
      ELSEIF TEMP_BLIT NE IT_BL-ZFBLIT.
         WRITE: /208 IT_BL-ZFBLIT NO-GAP, 214 IT_BL-ZFFORD NO-GAP,
                 225 IT_BL-BLMENGE UNIT IT_BL-MEINS NO-GAP,
                 239 IT_BL-MEINS NO-GAP, 243 IT_BL-ZFAPRTC NO-GAP.
         HIDE: IT_BL.
      ENDIF.

      PERFORM P3000_WRITE_CG_DATA.
      CLEAR: IT_BL.
   ENDLOOP.

ENDFORM.                    " P3000_WRITE_BL_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_CG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_WRITE_CG_DATA.

CLEAR : TEMP_CGNO,
        TEMP_CGIT.

   LOOP AT IT_CG
      WHERE ZFBLNO = IT_BL-ZFBLNO
        AND ZFBLIT = IT_BL-ZFBLIT.
      READ TABLE IT_IMG03 WITH KEY ZFBNARCD = IT_CG-ZFBNARCD.
      IF SY-SUBRC EQ 0.
         READ TABLE IT_LFA   WITH KEY LIFNR    = IT_IMG03-LIFNR.
         IF SY-SUBRC NE 0.
            CLEAR : IT_LFA.
         ENDIF.
      ELSE.
         CLEAR : IT_LFA.
      ENDIF.

      IF TEMP_CGNO NE IT_CG-ZFCGNO.
         WRITE 247 IT_CG-ZFCGPT NO-GAP.
         WRITE: 251 IT_LFA-NAME1(20) NO-GAP,
                272 IT_CG-CGMENGE UNIT IT_CG-MEINS NO-GAP,
                289 IT_CG-MEINS NO-GAP.
         HIDE: IT_CG.

      ELSEIF TEMP_CGIT NE IT_CG-ZFCGIT.
         WRITE: /251 IT_LFA-NAME1(20) NO-GAP,
                 272 IT_CG-CGMENGE UNIT IT_CG-MEINS NO-GAP,
                 289 IT_CG-MEINS NO-GAP.
         HIDE: IT_CG.
         TEMP_CGNO = IT_CG-ZFCGNO.
         TEMP_CGIT = IT_CG-ZFCGIT.
      ENDIF.

   ENDLOOP.


ENDFORM.                    " P3000_WRITE_CG_DATA
