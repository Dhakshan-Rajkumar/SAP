FUNCTION YTEST_Z_LABEL_001.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(P_HANGUL) TYPE  CHAR200
*"     REFERENCE(P_X) TYPE  NUM4
*"     REFERENCE(P_Y) TYPE  NUM4
*"     REFERENCE(P_X_SIZE) TYPE  NUM2 DEFAULT '1'
*"     REFERENCE(P_Y_SIZE) TYPE  NUM2 DEFAULT '1'
*"     REFERENCE(P_WIDTH) TYPE  NUM4 DEFAULT '15'
*"     REFERENCE(P_PRINT) TYPE  CHAR1 DEFAULT 'X'
*"  TABLES
*"      P_SCRIPT STRUCTURE  YTEST_ZLAB01S OPTIONAL
*"----------------------------------------------------------------------
  TABLES : YTEST_ZLAB01.

  DATA: STA TYPE I,          " HEXA�� ������ġ
        POS TYPE I,          " Space�� ������ ��ġ
        FLG,                 " ���� 2Byte Pair ����
        LEN TYPE I,          " Input String ����
        HAN(2).              " �ѱ� 1 ��

  FIELD-SYMBOLS: <F>,        " Input String�� Hexa Value
                 <S> TYPE X. " ���� 1byte Charater�� Hexa��

  DATA : TP_X(4),   "���� ��ġ X
         TP_Y(4),   "���� ��ġ Y
         TP_X_SIZE TYPE NUM4, "���� X SIZE
         TP_Y_SIZE TYPE NUM4. "���� Y SIZE

* ���� �ʱ�ȭ
  CLEAR : STA, POS, FLG, LEN, HAN," <F>, <S>,
          TP_X, TP_Y.
  REFRESH : P_SCRIPT. CLEAR : P_SCRIPT.

* ���� ������ ��ü ���� ���
  LEN = STRLEN( P_HANGUL ).
  CHECK LEN > 0.

* �Է� ���� ���� ���� ��ȯ (�ѱ۰� ���� ������ ����)
  ASSIGN P_HANGUL TO <F> TYPE 'X'.

* LOOPING ����
  DO LEN TIMES. "��ü ���� ��ŭ ȸ��

*   ���� ����Ʈ
    STA = SY-INDEX - 1.

*   1 BYTE �д´�.
    ASSIGN <F>+STA(1) TO <S>.

*   ���� ���� 2 BYTE ���� 1 BYTE ������ �����Ͽ�
*   �ش� �������� ó���Ѵ�.
    IF <S> >= '80'.  " 2 BYTE ����
*     2 BYTE �� ��� : 2 BYTE ���ۿ����� �׳� SKIP �ϰ�
*                      2 BYTE�� ������ �������� �а� ����.
      IF FLG = SPACE.  " 2 byte ���� ���� (�׳� Return)
        FLG = 'X'.
      ELSE.            " 2 byte �� ���� (�μ�)
        FLG = SPACE.
*       ���� ��ġ ���
        POS = STA - 1.
*       �ѱ� 1��(2byte)�� �д´�.
        HAN = P_HANGUL+POS(2).
*       �ش� �ѱ��� Image���� �о� �´�.
        SELECT SINGLE * FROM YTEST_ZLAB01
          WHERE ZFONT = '1'
          AND   ZHANG = HAN.
*       ���� �ѱ� Image�� �����ͷ� ������.
        WRITE : / YTEST_ZLAB01-ZHANC(50) NO-GAP,
                / YTEST_ZLAB01-ZHANC+50(50) NO-GAP,
                / YTEST_ZLAB01-ZHANC+100(50) NO-GAP,
                / YTEST_ZLAB01-ZHANC+150(18) NO-GAP.
*       �ش� �ѱ� Image �� �󺧷� ����Ѵ�.
        TP_X = P_X + POS * P_WIDTH. "���� ��ġ
        TP_Y = P_Y.                 "���� ��ġ
        IF P_PRINT = 'X'.
          WRITE : / '^FO'         NO-GAP,
                     TP_X         NO-GAP,
                    ','           NO-GAP,
                     TP_Y         NO-GAP,
                  / '^XGR:'       NO-GAP,
                     YTEST_ZLAB01-ZINDX NO-GAP,
                    ','           NO-GAP,
                     P_X_SIZE     NO-GAP,
                    ','           NO-GAP,
                     P_Y_SIZE     NO-GAP,
                    '^FS'         NO-GAP.
        ELSE.
          CONCATENATE '^FO' TP_X ',' TP_Y INTO P_SCRIPT-SCRIPT.
          APPEND P_SCRIPT.
          CONCATENATE '^XGR:' YTEST_ZLAB01-ZINDX ',' P_X_SIZE ','
                      P_Y_SIZE '^FS' INTO P_SCRIPT-SCRIPT.
          APPEND P_SCRIPT.
        ENDIF.
      ENDIF.
    ELSE.            " 1 BYTE ����
*     1 BYTE �� ��� : 1 BYTE ���ۿ��� �׳� �μ�.
*     ���� ��ġ ���
      POS = STA.
*     1��(1byte)�� �д´�.
      HAN = P_HANGUL+POS(1).
*     �ش� ���ڸ� �󺧷� ����Ѵ�.
      TP_X = P_X + POS * P_WIDTH. "���� ��ġ
      TP_Y = P_Y + 2.             "���� ��ġ
      TP_X_SIZE = P_X_SIZE * '14'.
      TP_Y_SIZE = P_Y_SIZE * '28'.
      IF P_PRINT = 'X'.
        WRITE : / '^FO'         NO-GAP,
                   TP_X         NO-GAP,
                  ','           NO-GAP,
                   TP_Y         NO-GAP,
                / '^A0'         NO-GAP,
                   TP_X_SIZE    NO-GAP, "14 ���
                   ','          NO-GAP,
                   TP_Y_SIZE    NO-GAP,  "28 ���
                / '^FD'         NO-GAP,
                   HAN(1)       NO-GAP,
                  '^FS'         NO-GAP.
      ELSE.
        CONCATENATE '^FO' TP_X ',' TP_Y INTO P_SCRIPT-SCRIPT.
        APPEND P_SCRIPT.
        CONCATENATE '^A0' TP_X_SIZE ',' TP_Y_SIZE
                    INTO P_SCRIPT-SCRIPT.
        APPEND P_SCRIPT.
        CONCATENATE '^FD' HAN(1) '^FS' INTO P_SCRIPT-SCRIPT.
        APPEND P_SCRIPT.
      ENDIF.
    ENDIF.

  ENDDO.
ENDFUNCTION.
