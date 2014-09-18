FUNCTION ZIM_GET_PO_HEADER.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(EBELN) LIKE  EKKO-EBELN
*"  EXPORTING
*"     VALUE(W_EKKO) LIKE  EKKO STRUCTURE  EKKO
*"  EXCEPTIONS
*"      NOT_INPUT
*"      NOT_FOUND
*"      NOT_RELEASED
*"      NOT_TYPE
*"      NO_TRANSACTION
*"      PO_DELETION
*"----------------------------------------------------------------------
  CLEAR : W_EKKO.
  CLEAR : EKKO, T160, LFA1.

*-----------------------------------------------------------------------
* ���� ������ȣ�� �Է� ���� ����
*-----------------------------------------------------------------------
  IF EBELN IS INITIAL.
     RAISE NOT_INPUT.
  ENDIF.

*-----------------------------------------------------------------------
* ���Ź��� HEADER SELECT
*-----------------------------------------------------------------------
  SELECT SINGLE * FROM EKKO WHERE EBELN EQ EBELN.
  IF SY-SUBRC NE 0.
     RAISE NOT_FOUND.
*    MESSAGE E001 WITH EBELN.
  ENDIF.

*-----------------------------------------------------------------------
* ������ ����
*-----------------------------------------------------------------------
  IF NOT EKKO-LOEKZ IS INITIAL.
     RAISE PO_DELETION.
  ENDIF.

*-----------------------------------------------------------------------
* ���Ź��� ���� ����
*-----------------------------------------------------------------------
  SELECT SINGLE * FROM T160 WHERE TCODE EQ 'ME23'.
  IF SY-SUBRC NE 0.
     RAISE NO_TRANSACTION.
*    MESSAGE E000 WITH 'ME23'.
  ENDIF.

*-----------------------------------------------------------------------
* ���Ź������ְ� SPACE�� ���
*-----------------------------------------------------------------------
*  IF T160-BSTYP EQ SPACE.
*     IF EKKO-BSTYP NE BSTYP-KONT AND
*        EKKO-BSTYP NE BSTYP-LFPL.
*        RAISE NOT_TYPE.
**        MESSAGE E002 WITH EBELN EKKO-BSTYP.
*     ENDIF.
*  ELSE.
*     IF EKKO-BSTYP NE T160-BSTYP.
*        RAISE NOT_TYPE.
**        MESSAGE E002 WITH EBELN EKKO-BSTYP.
*     ENDIF.
*  ENDIF.
   IF NOT ( EKKO-BSTYP EQ  BSTYP-LFPL OR        ">��ǰ������ȹ.
            EKKO-BSTYP EQ  BSTYP-BEST OR        ">���ſ���.
            EKKO-BSTYP EQ  BSTYP-KONT OR        ">�ϰ����.
            EKKO-BSTYP EQ  BSTYP-LERF ).        ">����
      RAISE NOT_TYPE.
   ENDIF.

*-----------------------------------------------------------------------
* ���ſ������� ������ üũ...
* 2000/04/04   ===> E&Y ����� ���� DEFINE
*-----------------------------------------------------------------------
* IF NOT ( EKKO-FRGKE EQ '2' OR EKKO-FRGKE EQ SPACE ).
*> < 2002.11.05 NHJ > P/O RELEASE CHECK ���� �ּ�ó��.
*  IF EKKO-FRGRL EQ 'X'.
*     RAISE NOT_RELEASED.
*  ENDIF.

  MOVE EKKO TO W_EKKO.

ENDFUNCTION.
