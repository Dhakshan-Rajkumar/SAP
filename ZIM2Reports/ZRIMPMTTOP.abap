*----------------------------------------------------------------------*
*   INCLUDE ZRIMPMTTOP                                                 *
*----------------------------------------------------------------------*
TABLES: ZTPMTEDI," EDI ���� Payment Notice ����.
        ZTPMTHD, " Payment Notice Header
        ZTRED,
        EKKO,
        ZTBL,
        ZTREQST,
        ZTPMTIV. " Payment Notice Invoice

DATA:   BEGIN OF IT_TAB OCCURS 0.   ">> RETURN ����.
        INCLUDE STRUCTURE   ZTPMTEDI.
DATA:   END   OF IT_TAB.
DATA: BEGIN OF IT_SELECTED OCCURS 0,
       ZFDHENO    LIKE ZTPMTEDI-ZFDHENO,
       ZFPNNO     LIKE ZTPMTEDI-ZFPNNO,
       ZFREQNO    LIKE ZTREQST-ZFREQNO,          " �����Ƿ� ������ȣ.
       ZFAMDNO    LIKE ZTREQST-ZFAMDNO,          " Amend Seq.
       EBELN      LIKE ZTPMTEDI-EBELN,
       ZFOPNNO    LIKE ZTPMTEDI-ZFOPNNO,
       ZFHBLNO    LIKE ZTPMTEDI-ZFHBLNO,
       ZFISNO     LIKE ZTPMTEDI-ZFISNO,
END OF IT_SELECTED.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " ���� LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_LINE            TYPE I,                 " �������� LINE COUNT
       LINE(3)           TYPE N,                 " �������� LINE COUNT
       W_COUNT           TYPE I,                 " ��ü COUNT
       W_ITCOUNT(3),                             " ǰ�� COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME.   " �ʵ��.
