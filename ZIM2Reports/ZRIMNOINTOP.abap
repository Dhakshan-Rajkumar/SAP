*----------------------------------------------------------------------*
*   INCLUDE ZRIMNOINTOP                                                *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   TABLE ����                                                         *
*----------------------------------------------------------------------*
TABLES : ZTBKPF,               " ��빮�� HEADER
         ZTBSEG,               " ��빮�� ITEM
         ZTBDIV,               " ��� ��� ����.
         ZTBHIS,               " ��� HISTORY
         ZTIMIMG00 ,
         ZTIMIMG08 ,
         ZTREQHD   ,
         ZTREQIT   ,
         EKKO,
         EKPO,
         MAKT,
         ZTIV,
         ZTIVHST,
         ZTIVIT,
         ZTIVHSTIT,
         RV61A.

*----------------------------------------------------------------------*
*   INTERNAL TABLE ����                                                *
*----------------------------------------------------------------------*
DATA : BEGIN OF IT_REQ OCCURS 0,
       EBELN           LIKE   ZTREQIT-EBELN,
       EBELP           LIKE   ZTREQIT-EBELP,
       CUR             LIKE   ZTREQHD-WAERS,
       MENGE           LIKE   ZTREQIT-MENGE,
       MEINS           LIKE   ZTREQIT-MEINS,
       GRMENGE         LIKE   ZTREQIT-MENGE.
DATA : END   OF IT_REQ.

*----------------------------------------------------------------------*
*   VARIABLE ����                                                      *
*----------------------------------------------------------------------*
DATA : W_ERR_CHK         TYPE C,
       W_TABIX           LIKE SY-TABIX,
       W_LINE            TYPE I,
       SV_CHK            TYPE C,
       SV_EBELN          LIKE EKPO-EBELN,
       SV_EBELP          LIKE EKPO-EBELP,
       W_MENGE           LIKE ZTIVHSTIT-GRMENGE,
       SV_AMT            LIKE ZTBDIV-ZFAMT,
       TOT_AMT           LIKE ZTBDIV-ZFAMT,
       SV_WAERS          LIKE ZTBDIV-WAERS,
       SV_CUR            LIKE ZTBDIV-WAERS,
       SV_OPAMT          LIKE ZTBDIV-WRBTR,
       SV_GRAMT          LIKE ZTBDIV-WRBTR,
       SV_REAMT          LIKE ZTBDIV-WRBTR,
       TOT_OPAMT         LIKE ZTBDIV-WRBTR,
       TOT_GRAMT         LIKE ZTBDIV-WRBTR,
       TOT_REAMT         LIKE ZTBDIV-WRBTR.
