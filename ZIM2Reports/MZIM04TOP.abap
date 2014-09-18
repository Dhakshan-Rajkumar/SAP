*&---------------------------------------------------------------------*
*& Include MZIM04TOP                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : L/C ���� ���� Main Data Define Include                *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.01.25                                            *
*&  ����ȸ��PJT: Poong-San                                             *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&---------------------------------------------------------------------*

*-----------------------------------------------------------------------
* DESC : Table Define.
*-----------------------------------------------------------------------
TABLES: LFA1,                     " Vendor Master Table.
        SPOP,                     " POPUP_TO_CONFIRM.
        TCURC,                    " ��ȭ�ڵ�.
        USR01,                    " ����ڸ����ͷ��ڵ� (����õ���Ÿ).
        ZTREQHD,                  " �����Ƿ� Header Table.
        ZTBKPF,                   " ��빮�� Header Table.
        ZTBSEG,                   " ��빮�� Item Table.
        ZTIMIMG08,                " �����ڵ� ���� Table.
        ZTPMTHD.                  " Payment Notice Header Table.

*-----------------------------------------------------------------------
* DESC : Structure Define.
*-----------------------------------------------------------------------
TABLES: ZSREQHD,                  " �����Ƿ� Header�� Structure.
        ZSBSEG,                   " ���Խý��� ��빮�� Item Structure.
        ZSBSEG2,                  " ���Խý��� ��빮�� Item Structure.
        ZSIMIMG08,                " �����ڵ� Structure.
        ZSPMTHD.                  " Payment Notice Head Structure.

*-----------------------------------------------------------------------
*  DESC : View Define.
*-----------------------------------------------------------------------
TABLES: ZVREQHD_ST.               " �����Ƿ� Header + Status View.

DATA: BEGIN OF IT_EXCL OCCURS 20,
      FCODE    LIKE RSMPE-FUNC.
DATA: END   OF IT_EXCL.

DATA: IT_ZSBSEG       LIKE ZSBSEG    OCCURS 0 WITH HEADER LINE.
DATA: IT_ZSBSEG1      LIKE ZSBSEG2   OCCURS 0 WITH HEADER LINE.
DATA: IT_ZSPMTHD      LIKE ZSPMTHD   OCCURS 0 WITH HEADER LINE.
DATA: IT_ZSIMIMG08    LIKE ZSIMIMG08 OCCURS 0 WITH HEADER LINE.

DATA: C_REQ_C   VALUE 'C',         " ��?
      C_REQ_U   VALUE 'U',         " ��?
      C_REQ_D   VALUE 'D',         " ��?
      C_ADD_U   VALUE 'A',         " ����(�߰�)
      C_ADD_D   VALUE 'B',         " ��?
      C_OPEN_C  VALUE 'O',         " Ȯ?
      C_OPEN_U  VALUE 'G',         " Ȯ�� ����/���º�?
      C_OPEN_D  VALUE 'R',         " Ȯ�� ��?
      C_INSU_I  VALUE 'I',         " �����?
      C_BL_SEND VALUE 'S',        " �������� �ۺ�.
      C_BL_COST VALUE 'T',        " ����Է�..
      C_BL_REAL VALUE 'E'.        " ������ �Է�.

DATA: W_PFSTAT(4)     TYPE C.             " PF-STATUS

FIELD-SYMBOLS : <FS_F>.
* Data Declaration.
DATA: W_CREATE(6)        TYPE     C     VALUE   'Create',
      W_CHANGE(6)        TYPE     C     VALUE   'Change',
      W_DISPLAY(7)       TYPE     C     VALUE   'Display',
      W_ADD_CHG(17)      TYPE     C     VALUE   'Additional Change',
      W_ADD_DIS(18)      TYPE     C     VALUE   'Additional Display',
      W_OPEN(7)          TYPE     C     VALUE   'Opennig',
      W_OPEN_CHANGE(11)  TYPE     C     VALUE   'Open Change',
      W_STAUTS(13)       TYPE     C     VALUE   'Status Change',
      W_OPEN_DISPLAY(12) TYPE     C     VALUE   'Open Display',
      W_INSURANCE(12)    TYPE     C     VALUE   'Insurance'.

* Data Declaration.
data: G_PARAM_LINE      LIKE  SY-TABIX.    " Table�� ������.
DATA: CANCEL_OPTION     TYPE  C.           " ���� popup Screen���� ���.
DATA: W_STATUS          TYPE  C.           " MENU STATUS.
DATA: OK-CODE           LIKE  SY-UCOMM.    " OK-CODE
DATA: W_OK_CODE         LIKE  SY-UCOMM.    " OK-CODE
DATA: W_COUNT           TYPE  I.           " Line Count.
DATA: ANTWORT(1)        TYPE  C.           " ���� popup Screen���� ���.
data: OPTION(1)         TYPE  C.           " ���� popup Screen���� ���.
data: TEXTLEN           TYPE  I.           " ���� popup Screen���� ���.
DATA: W_ROW_MARK        TYPE  C.           " RECORD�� ���ÿ���.
DATA: W_ROW_MARK1       TYPE  C.           " RECORD�� ���ÿ���.
DATA: W_ROW_MARK2       TYPE  C.           " RECORD�� ���ÿ���.
DATA: W_LOOPLINES       LIKE  SY-LOOPC.    " Loop Counter.
DATA: W_TEXT_AMOUNT(18) TYPE  C.

* Screen Text ���� ����.
data: W_LIFNR_NM(35)    TYPE  C.
DATA: W_ZFBENI_NM(35)   TYPE  C.
DATA: W_LLIEF_NM(35)    TYPE  C.
DATA: W_ZFOPBN_NM(35)   TYPE  C.
DATA: W_OPEN_NM(35)     TYPE  C.

CONTROLS TABSTRIP    TYPE TABSTRIP.
CONTROLS: TC_101A    TYPE TABLEVIEW USING SCREEN 0101.
CONTROLS: TC_101B    TYPE TABLEVIEW USING SCREEN 0101.
CONTROLS: TC_101C    TYPE TABLEVIEW USING SCREEN 0101.
