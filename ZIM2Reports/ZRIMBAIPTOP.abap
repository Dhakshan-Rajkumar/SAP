*&---------------------------------------------------------------------*
*&  INCLUDE ZRIMBAIPTOP                                                *
*&---------------------------------------------------------------------*
*&  ���α׷��� : BAPIs Function�� ���� Include                         *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.03.27                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

TABLES : BAPIACHE08,
         BAPIACHE02,
         BAPIACGL08,
         BAPIACCR08,
         BAPIRET2,
         BAPIEXTC.


DATA : DOCUMENTHEADER  LIKE  BAPIACHE08,
       OBJ_TYPE        LIKE  BAPIACHE02-OBJ_TYPE,
       OBJ_KEY         LIKE  BAPIACHE02-OBJ_KEY,
       OBJ_SYS         LIKE  BAPIACHE02-OBJ_SYS.


DATA:   BEGIN OF ACCOUNTGL OCCURS 0.        ">> ȸ������: �Ϲ�����.
        INCLUDE STRUCTURE   BAPIACGL08.
DATA:   END   OF ACCOUNTGL.

DATA:   BEGIN OF CURRENCYAMOUNT OCCURS 0.   ">> ȸ������: ���û������ .
        INCLUDE STRUCTURE   BAPIACCR08.
DATA:   END   OF CURRENCYAMOUNT.

DATA:   BEGIN OF EXTENSION1 OCCURS 0.       ">>'Customer Exit' �Ű�����.
        INCLUDE STRUCTURE   BAPIEXTC.
DATA:   END   OF EXTENSION1.

DATA:   BEGIN OF RETURN OCCURS 0.          ">> RETURN ����.
        INCLUDE STRUCTURE   BAPIRET2.
DATA:   END   OF RETURN.
