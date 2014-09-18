
REPORT ZRIM_DATA_MIGRATION_ZIM35_2
                 NO STANDARD PAGE HEADING LINE-SIZE 255.

INCLUDE ZRIM_DATA_MIG_F01.

TABLES : ZTREQHD.

DATA: BEGIN OF IT_REQIT OCCURS 0.
        INCLUDE STRUCTURE ZTREQIT.
DATA: END OF IT_REQIT.

DATA: BEGIN OF IT_CIVHD OCCURS 0,
        EBELN(010),
      END OF IT_CIVHD.

*DATA: BEGIN OF IT_CIVIT OCCURS 0,
*        EBELN(010),
*        EBELP(005),
*        ZFPRQN(017),
*      END OF IT_CIVIT.


DATA : W_ERROR_FLAG,
       W_REMARK(70),
       W_LINE        TYPE   I,
       W_LINE_CNT(4),
       W_ZFPRQN(25).

*==============================================
PARAMETERS : P_PATH1 LIKE RLGRAP-FILENAME.
*             P_PATH2 LIKE RLGRAP-FILENAME.
PARAMETERS : P_MODE TYPE C.
*===============================================
START-OF-SELECTION.

  PERFORM READ_DATA_FILE TABLES IT_CIVHD
                         USING  P_PATH1.
*  PERFORM READ_DATA_FILE TABLES IT_CIVIT
*                         USING  P_PATH2.

  LOOP AT IT_CIVHD.
    REFRESH : BDCDATA. CLEAR BDCDATA.
*>> ���� ���� �ʱ�ȭ��.
    PERFORM P2000_DYNPRO USING :
                  'X' 'SAPMZIM01'        '3500',
                  ' ' 'BDC_OKCODE'       '=ENTR',
                  ' ' 'ZSCIVHD-ZFCIVNO'  IT_CIVHD-EBELN,
                  ' ' 'ZSCIVHD-ZFPOYN'   'Y',
                  ' ' 'ZSCIVHD-ZFPRPYN'  'Y'.

    CLEAR ZTREQHD.
    SELECT SINGLE * FROM ZTREQHD
                   WHERE EBELN = IT_CIVHD-EBELN.

    IF SY-SUBRC NE 0.
      WRITE : / '���Ź�����ȣ ',
                IT_CIVHD-EBELN ,
                '�� �ش��ϴ� �����Ƿڹ����� �������� �ʽ��ϴ�.',
                '(�����������)'.
      CONTINUE.
    ENDIF.

*    READ TABLE IT_CIVIT WITH KEY EBELN = IT_CIVHD-EBELN.
*    IF SY-SUBRC NE 0.
*      WRITE : / '���Ź�����ȣ ',
*                IT_CIVHD-EBELN ,
*                '�� Lecacy Data�� ���系���� ���� ���� �ʽ��ϴ�.',
*                '(�����������)'.
*      CONTINUE.
*    ENDIF.


    PERFORM P2000_DYNPRO USING :
                   'X' 'SAPMZIM01'        '3514',
                   ' ' 'BDC_OKCODE'       '=YES',
                   ' ' 'ZSREQHD-ZFREQNO'  ZTREQHD-ZFREQNO.

*>> ���� ���� �Ϲݻ���.
    PERFORM P2000_DYNPRO USING :
                 'X' 'SAPMZIM01'        '3510',
                 ' ' 'BDC_OKCODE'       '=ENTR',
                 ' ' 'ZTCIVHD-ZFPRTE'   '100',
                 ' ' 'ZTCIVHD-ZFCIDT'   '20030130',
                 ' ' 'ZTCIVHD-BUDAT'    '20030130'.

*    SELECT  * INTO CORRESPONDING FIELDS OF TABLE IT_REQIT
*              FROM ZTREQIT
*             WHERE EBELN = IT_CIVHD-EBELN.
*
*    CLEAR : W_LINE, W_LINE_CNT, IT_REQIT, IT_CIVIT.
*    SORT IT_REQIT BY ZFREQNO ZFITMNO.
*    LOOP AT IT_REQIT .
**>> L/C ���� ���系��.
*      ADD 1 TO W_LINE.
*      IF W_LINE GT 5.
**   >>PAGE DOWN.
*        PERFORM P2000_DYNPRO USING :
*               'X' 'SAPMZIM01'           '3510',
*               ' ' 'BDC_OKCODE'          '/00'.
*        W_LINE = 1.
*      ENDIF.
*
*      W_LINE_CNT = W_LINE.
*      CLEAR : W_ZFPRQN, IT_CIVIT.
*      CONDENSE W_LINE_CNT.
*      CONCATENATE 'ZSCIVIT-ZFPRQN(' W_LINE_CNT ')' INTO W_ZFPRQN.
*      PERFORM P2000_DYNPRO USING :
*                      'X' 'SAPMZIM01'         '3510',
*                      ' ' 'BDC_OKCODE'        '=ENTR'.
*
*      READ TABLE IT_CIVIT WITH KEY EBELN = IT_REQIT-EBELN
*                                   EBELP = IT_REQIT-EBELP.
*      IF SY-SUBRC EQ 0.
*        PERFORM P2000_DYNPRO USING ' '  W_ZFPRQN IT_CIVIT-ZFPRQN.
*      ELSE.
*        PERFORM P2000_DYNPRO USING ' '  W_ZFPRQN '0'.
*      ENDIF.
*    ENDLOOP.

    PERFORM P2000_DYNPRO USING :
                    'X' 'SAPMZIM01'         '3510',
                    ' ' 'BDC_OKCODE'        'CALC'.
    PERFORM P2000_DYNPRO USING :
                    'X' 'SAPMZIM01'         '3510',
                    ' ' 'BDC_OKCODE'        '=MIRO'.

*>> SAVE DIALOG BOX.
    PERFORM P2000_DYNPRO USING :
                    'X' 'SAPMZIM01'         '3515',
                    ' ' 'BDC_OKCODE'        '=YES',
                    ' ' 'ZSCIVHD-BLDAT'     '2003.01.30',
                    ' ' 'ZSCIVHD-ZFBDT'     '2003.01.30',
                    ' ' 'ZSCIVHD-BUDAT'     '2003.01.30'.

    PERFORM BDC_TRANSACTION USING 'ZIM35' P_MODE
                         CHANGING  W_SUBRC.
    IF W_SUBRC NE 0.
       WRITE : '(���Ź�����ȣ :', IT_CIVHD-EBELN, ')'.
    ENDIF.
    WAIT UP TO 3 SECONDS.
*    IF W_SUBRC EQ 0.
*      REFRESH : BDCDATA.
**>> ���� ��ȸ �ʱ�ȭ��.
*      PERFORM P2000_DYNPRO USING :
*                    'X' 'SAPMZIM01'        '3700',
*                    ' ' 'BDC_OKCODE'       '=ENTR',
*                    ' ' 'ZSCIVHD-ZFCIVNO'  IT_CIVHD-EBELN.
**>> �����û.
*      PERFORM P2000_DYNPRO USING :
*                    'X' 'SAPMZIM01'        '3510',
*                    ' ' 'BDC_OKCODE'       '=RERQ'.
**>> �����û POPUPȭ��.
*      PERFORM P2000_DYNPRO USING :
*                    'X' 'SAPLZWF1'           '0300',
*                    ' ' 'BDC_OKCODE'         '=SELE',
*                    ' ' 'IT_D1-APPROVER(01)' 'ABAP0036'.
*
*      PERFORM BDC_TRANSACTION USING 'ZIM37' W_SUBRC.
*
*    ENDIF.

  ENDLOOP.
