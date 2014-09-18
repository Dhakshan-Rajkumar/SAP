*&-----------------------------------------------------------------
*& Report  ZRIMTRANS
*&-----------------------------------------------------------------
*&  ���α׷��� : Import System Basic Data Client Transferring
*&      �ۼ��� : ������ INFOLINK Ltd.
*&      �ۼ��� : 2001.05.18
*&  ����ȸ��PJT:
*&-----------------------------------------------------------------
*& [���泻��]
*&
*&-----------------------------------------------------------------
REPORT  ZRIETRANS  MESSAGE-ID ZIES.
TABLES: ZTIEPORT,  " ������, ������.
        ZTIMIMG00, " ���Խý��� Basic Configuration.
        ZTIMIMG01, " Payment Term Configuration.
        ZTIMIMG02, " ���� �ڵ�.
        ZTIMIMG03, " �������� �ڵ�.
        ZTIMIMG04, " Planned Cost Rate ����.
        ZTIMIMG05, " ������� ���Ӵܰ� ����.
        ZTIMIMG06, " ����û ���ȯ�� ����.
        ZTIMIMG07, " ����������� ����.
        ZTIMIMG08, " �����ڵ� ����.
        ZTIMIMG09, " HS�ڵ庰 ������ ����.
        ZTIMIMG10, " ������ ����.
        ZTIMIMG11, " G/R, I/V, ���ó�� Configuration.
        ZTIMIMG12, " ��ۼ��� MATCH CODE.
        ZTIMIMG17, " �װ�ȭ���ؿܿ�� ���� ����.
        ZTIMIMG18, " ���Խý��� �������.
        ZTIMIMG19, " ����ں� ������� ����.
        ZTIMIMGTX. " EDI BASIC CONFIG

CONSTANTS MARK VALUE 'X'.

SELECTION-SCREEN BEGIN OF BLOCK OUT WITH FRAME.
   SELECTION-SCREEN BEGIN OF BLOCK ORDER WITH FRAME TITLE TEXT-TL1.
      PARAMETERS : VAL_FROM  LIKE ZTIMIMG00-MANDT  OBLIGATORY,
                   VAL_TO    LIKE ZTIMIMG00-MANDT  OBLIGATORY.
   SELECTION-SCREEN END OF BLOCK ORDER.

   SELECTION-SCREEN BEGIN OF BLOCK TABLE WITH FRAME TITLE TEXT-TL2.
*      SELECTION-SCREEN PUSHBUTTON 71(2) PUBU
*                 USER-COMMAND UCOM_ALL.
*
      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-TT0.
         PARAMETERS   ZT0 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-TT1.
         PARAMETERS   ZT1 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-TT2.
         PARAMETERS   ZT2 AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-TT5.
         PARAMETERS   ZT5 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-TT4.
         PARAMETERS   ZT4 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-TT3.
         PARAMETERS   ZT3 AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-TT6.
         PARAMETERS   ZT6 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-TT7.
         PARAMETERS   ZT7 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-TT8.
         PARAMETERS   ZT8 AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-TT9.
         PARAMETERS   ZT9 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-T11.
         PARAMETERS   ZT11 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-T10.
         PARAMETERS   ZT10 AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-T17.
         PARAMETERS   ZT17 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-T12.
         PARAMETERS   ZT12 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-T13.
         PARAMETERS   ZT13 AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

      SELECTION-SCREEN BEGIN OF LINE.
         SELECTION-SCREEN COMMENT 1(21) TEXT-T18.
         PARAMETERS   ZT18 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 30(20) TEXT-T19.
         PARAMETERS   ZT19 AS CHECKBOX.
         SELECTION-SCREEN COMMENT 57(15) TEXT-TTX.
         PARAMETERS   ZTTX AS CHECKBOX.
      SELECTION-SCREEN END OF LINE .

   SELECTION-SCREEN END OF BLOCK TABLE.

SELECTION-SCREEN END OF BLOCK OUT.

START-OF-SELECTION.

*  Basic Configuration
   IF MARK EQ ZT0.
      SELECT * FROM ZTIMIMG00.
         MOVE VAL_TO TO ZTIMIMG00-MANDT.
         MODIFY ZTIMIMG00 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH 'Basic Configuration'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  Payment Term Configuration
   IF MARK EQ ZT1.
      SELECT * FROM ZTIMIMG01.
         MOVE VAL_TO TO ZTIMIMG01-MANDT.
         MODIFY ZTIMIMG01 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH 'Payment Term Configuration'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ���� �ڵ�.
   IF MARK EQ  ZT2.
      SELECT * FROM ZTIMIMG02.
         MOVE VAL_TO TO ZTIMIMG02-MANDT.
         MODIFY ZTIMIMG02 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '���� �ڵ�'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  �������� �ڵ�.
   IF MARK EQ  ZT3.
      SELECT * FROM ZTIMIMG03.
         MOVE VAL_TO TO ZTIMIMG03-MANDT.
         MODIFY ZTIMIMG03 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '�������� �ڵ�'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  Planned Cost Rate.
   IF MARK EQ ZT4.
      SELECT * FROM ZTIMIMG04.
         MOVE VAL_TO TO ZTIMIMG04-MANDT.
         MODIFY ZTIMIMG04 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH 'Planned Cost Rate'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ������� ���Ӵܰ�.
   IF MARK EQ ZT5.
      SELECT * FROM ZTIMIMG05.
         MOVE VAL_TO TO ZTIMIMG05-MANDT.
         MODIFY ZTIMIMG05 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '������� ���Ӵܰ�'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ����û ���ȯ��.
   IF MARK EQ ZT6.
      SELECT * FROM ZTIMIMG06.
         MOVE VAL_TO TO ZTIMIMG06-MANDT.
         MODIFY ZTIMIMG06 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '����û ���ȯ��'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  �����������.
   IF MARK EQ ZT7.
      SELECT * FROM ZTIMIMG07.
         MOVE VAL_TO TO ZTIMIMG07-MANDT.
         MODIFY ZTIMIMG07 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '�����������'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  �����ڵ�.
   IF MARK EQ ZT8.
      SELECT * FROM ZTIMIMG08.
         MOVE VAL_TO TO ZTIMIMG08-MANDT.
         MODIFY ZTIMIMG08 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '�����ڵ�'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  HS�ڵ庰 ������.
   IF MARK EQ ZT9.
      SELECT * FROM ZTIMIMG09.
         MOVE VAL_TO TO ZTIMIMG09-MANDT.
         MODIFY ZTIMIMG09 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH 'HS�ڵ庰 ������'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ������.
   IF MARK EQ ZT10.
      SELECT * FROM ZTIMIMG10.
         MOVE VAL_TO TO ZTIMIMG10-MANDT.
         MODIFY ZTIMIMG10 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '������'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  G/R, I/V, ���ó�� Configuration.
   IF MARK EQ ZT11.
      SELECT * FROM ZTIMIMG11.
         MOVE VAL_TO TO ZTIMIMG11-MANDT.
         MODIFY ZTIMIMG11 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000.
         ELSE.
            MESSAGE S001 WITH 'G/R, I/V, ���ó�� Configuration'.
         ENDIF.
      ENDIF.
   ENDIF.

*  ��ۼ��� MATCH CODE ����.
   IF MARK EQ ZT12.
      SELECT * FROM ZTIMIMG12.
         MOVE VAL_TO TO ZTIMIMG12-MANDT.
         MODIFY ZTIMIMG12 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000.
         ELSE.
            MESSAGE S001 WITH '��ۼ��� MATCH CODE'.
         ENDIF.
      ENDIF.
   ENDIF.

*  ������, �����װ���.
   IF MARK EQ ZT13.
      SELECT * FROM ZTIEPORT.
         MOVE VAL_TO TO ZTIEPORT-MANDT.
         MODIFY ZTIEPORT CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000.
         ELSE.
            MESSAGE S001 WITH '������, ������ ����'.
         ENDIF.
      ENDIF.
   ENDIF.

*  �װ�ȭ���ؿܿ�� ���� ����.
   IF MARK EQ ZT17.
      SELECT * FROM ZTIMIMG17.
         MOVE VAL_TO TO ZTIMIMG17-MANDT.
         MODIFY ZTIMIMG17 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '�װ�ȭ���ؿܿ�� ���� ����'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ���Խý��� �������.
   IF MARK EQ ZT18.
      SELECT * FROM ZTIMIMG18.
         MOVE VAL_TO TO ZTIMIMG18-MANDT.
         MODIFY ZTIMIMG18 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '���Խý��� �������'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ����ں� ������� ����.
   IF MARK EQ ZT19.
      SELECT * FROM ZTIMIMG19.
         MOVE VAL_TO TO ZTIMIMG19-MANDT.
         MODIFY ZTIMIMG19 CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH '����ں� ������� ����'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.

*  ���Խý��� EDI Basic Config.
   IF MARK EQ ZT19.
      SELECT * FROM ZTIMIMGTX.
         MOVE VAL_TO TO ZTIMIMGTX-MANDT.
         MODIFY ZTIMIMGTX CLIENT SPECIFIED.
      ENDSELECT.
      IF SY-DBCNT > 0.
         IF SY-SUBRC NE 0.
            MESSAGE A000 WITH 'EDI Basic Config'.
         ELSE.
            MESSAGE S001.
         ENDIF.
      ENDIF.
   ENDIF.
