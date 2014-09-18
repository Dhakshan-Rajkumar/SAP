FUNCTION ZIM_CUDATA_EDI_CHK.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(MODE) TYPE  C DEFAULT 'N'
*"  TABLES
*"      IT_ZTIDRHS STRUCTURE  ZSIDRHS
*"      IT_ZTIDRHSD STRUCTURE  ZSIDRHSD
*"      IT_ZTIDRHSL STRUCTURE  ZSIDRHSL
*"  CHANGING
*"     VALUE(ZTIDR) LIKE  ZTIDR STRUCTURE  ZTIDR
*"----------------------------------------------------------------------

   ZTIDR-ZFEDICK = 'O'.

*>> ���԰ŷ�����.
   IF ZTIDR-ZFPONC IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '���԰ŷ�����'.
      ENDIF.
      MOVE  'X'     TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ���ԽŰ�����.
   IF ZTIDR-ZFITKD IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '���ԽŰ�����'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �Ű��������.
   IF ZTIDR-ZFIDWDT IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�Ű��������'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �������.
   IF ZTIDR-ZFAMCD IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�������'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ������.
   IF ZTIDR-ZFAPRTC IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '������'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ���ⱹ.
   IF ZTIDR-ZFSCON IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '���ⱹ'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ��ۿ��.
   IF ZTIDR-ZFTRCN IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '��ۿ��'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> HOUSE B/L NO.
   IF ZTIDR-ZFHBLNO IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH 'HOUSE B/L NO'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ��ۼ���.
   IF ZTIDR-ZFTRMET IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '��ۼ���'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����.
   IF ZTIDR-ZFCARNM IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �Ű��Ƿ���.
   IF ZTIDR-ZFAPNM IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�Ű��Ƿ���'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����ǹ���(��ȣ).
   IF ZTIDR-ZFTDNM1 IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����ǹ���(��ȣ)'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����ǹ���(����).
   IF ZTIDR-ZFTDNM2 IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����ǹ���(����)'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����ǹ���(�ּ�).
   IF ZTIDR-ZFTDAD1 IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����ǹ���(�ּ�)'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����ǹ���(����ڵ�Ϲ�ȣ).
   IF ZTIDR-ZFTDTC IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����ǹ���(����ڵ�Ϲ�ȣ)'.
      ENDIF.
      MOVE 'X'      TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ������(��ȣ)
   IF ZTIDR-ZFSUPNM IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '������(��ȣ)'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �ε�����.
   IF ZTIDR-INCO1 IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�ε�����'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����ݾ�.
   IF ZTIDR-ZFSTAMT IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����ݾ�'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> ���߷�.
   IF ZTIDR-ZFTOWT IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '���߷�'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*>> �����尹��.
   IF ZTIDR-ZFPKCNT IS INITIAL.
      IF MODE NE 'N'.
         MESSAGE W167 WITH '�����尹��'.
      ENDIF.
      MOVE 'X'       TO  ZTIDR-ZFEDICK.   EXIT.
   ENDIF.

*-------------------------< �� ���� CHECK >----------------------------*
   LOOP  AT  IT_ZTIDRHS.

*>> HS CODE
      IF IT_ZTIDRHS-STAWN IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '�������� H/S CODE'.
         ENDIF.
         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

*>> ǰ��.
      IF IT_ZTIDRHS-ZFGDNM IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '�������� ǰ��'.
         ENDIF.
         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

*>> �ŷ�ǰ��.
      IF IT_ZTIDRHS-ZFTGDNM IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '�������� �ŷ� ǰ��'.
         ENDIF.
         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

*>> ������< �Ѽ��� �ּ� ó�� >.
*      IF IT_ZTIDRHS-ZFORIG IS INITIAL.
*         IF MODE NE 'N'.
*            MESSAGE W167 WITH '�������� ������'.
*         ENDIF.
*         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
*      ENDIF.

*>> ���߷�.
*      IF IT_ZTIDRHS-ZFWET IS INITIAL.
*         IF MODE NE 'N'.
*            MESSAGE W167 WITH '�������� ���߷�'.
*         ENDIF.
*         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
*      ENDIF.

*>> ��������.
      IF IT_ZTIDRHS-ZFTBAK IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '�������� ��������'.
         ENDIF.
         MOVE 'X'          TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

   ENDLOOP.

*-------------------< �԰� ���� CHECK >--------------------------------*
   LOOP  AT  IT_ZTIDRHSD.

*>> �ܰ�.
      IF IT_ZTIDRHSD-NETPR IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '������� �ܰ�'.
         ENDIF.
         MOVE 'X'           TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

   ENDLOOP.

*-----------------< ��� ���� CHECK >----------------------------------*
   LOOP  AT  IT_ZSIDRHSL.

*>> ������ȣ.
      IF IT_ZTIDRHSL-ZFCNNO IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '��ǻ����� ������ȣ'.
         ENDIF.
         MOVE 'X'           TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

*>> �߱�����.
      IF IT_ZTIDRHSL-ZFISZDT IS INITIAL.
         IF MODE NE 'N'.
            MESSAGE W167 WITH '��ǻ����� �߱�����'.
         ENDIF.
         MOVE  'X'          TO  ZTIDR-ZFEDICK.   EXIT.
      ENDIF.

   ENDLOOP.

*>> ��������, EDI ����, EDI CHECK ����.
*   MOVE SY-DATUM    TO   ZTIDR-UDAT.
*   MOVE SY-UNAME    TO   ZTIDR-UNAM.

ENDFUNCTION.
