*----------------------------------------------------------------------*
*   INCLUDE ZRIMLCGLLSTTOP                                             *
*----------------------------------------------------------------------*
TABLES : ZTREQHD,         " �����Ƿ� Header
         ZTREQIT,         " �����Ƿ� Item
         ZTREQST,         " �����Ƿ� Status
         ZTPMTHD,         " Payment Notice Header
         ZTPMTIV,         " Payment Notice Invoice
         ZTBLINR,         " ���ԽŰ�.
         ZTIDS,           " ���Ը���.
         ZTCUCLIV,        " ��� INVOICE....
         DD03D,           " Dynpro fields for table fields
         T024E,           " ��������.
         T024,            " ���ű׷�.
         LFA1,            " ����ó������ (�Ϲݼ���)
         TINC,            " ��: �ε�����.
         EKPO,            " Purchasing Document Item
         ZVREQHD_ST,      " �����Ƿ� Header + Status View
         ZVEKKO_REQHD_ST, " EKKO + �����Ƿ� Header + Status View
         ZTOFF,           " OFFER SHEET
         ZTOFFFTX,        " OFFER SHEET FTX
         ZTIMIMGTX,       " EDI TEXT.
         ZTDHF1,          " ǥ�� EDI Flat Head
         ZTCDF1,          " ���ڹ�����ȣ ä��(EDI)
         ZTIMIMG03,       " �������� �ڵ�.
         ZTIMIMG00,       " ���Խý��� Basic Config
         ZTBKPF.          " ���Ժ�빮�� Header

*----------------------------------------------------------------------*
* Internal Table Select.
*----------------------------------------------------------------------*
DATA : IT_ZVREQ      LIKE ZVREQHD_ST OCCURS 0  WITH HEADER LINE.

data: W_LIST_INDEX      LIKE SY-TABIX.
DATA: W_LFA1            LIKE LFA1,
      W_ADRC            LIKE ADRC,
      G_PARAM_LINE      TYPE I.
data: W_PAGE            TYPE I.             " Page Counter
DATA: W_ERR_CHK(1)      TYPE C,
      CANCEL_OPTION     TYPE C,
      W_ROWMARK         TYPE C,
      OPTION(1)         TYPE C,
      F(20)             TYPE C,             " Field Name Alias
      W_COUNT           TYPE I,             " ��ü COUNT
      W_LINE            TYPE I,             " �������� LINE COUNT
      W_UPDATE_CNT      TYPE I,
      LINE              TYPE I,
      TEXTLEN           TYPE I,
      W_BUTTON_ANSWER   TYPE C,
      W_GUBUN           TYPE C,
      ANTWORT           TYPE C,
      W_ITEM_CNT        LIKE SY-TABIX,          " ǰ�� count
      W_MAX_ZFAMDNO     LIKE ZTREQST-ZFAMDNO,
      W_YN1             LIKE ZTIMIMG00-ZFRELYN1,
      W_YN2             LIKE ZTIMIMG00-ZFRELYN1,
      G_PARM_LINE       LIKE SY-TABIX,
      W_TABIX           LIKE SY-TABIX,
*      W_SY_SUBRC        LIKE SY-SUBRC,
      W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
*> 2001.06.18 KSB INSERT START
      W_SUBRC           LIKE SY-SUBRC,
*> 2001.06.18 KSB INSERT END.
      W_LOOPLINES       LIKE SY-LOOPC,
      W_COUNTER1        LIKE SY-LOOPC,
      W_COUNTER         LIKE SY-LOOPC,
      OK-CODE           LIKE SY-UCOMM,
      W_OK_CODE         LIKE SY-UCOMM.

DATA: G_REPID LIKE SY-REPID.
DATA: G_LAYOUT          TYPE SLIS_LAYOUT_ALV.
DATA: G_STATUS          TYPE SLIS_FORMNAME VALUE 'P2000_ALV_PF_STATUS'.
DATA: GT_FIELDCAT       TYPE SLIS_T_FIELDCAT_ALV.
DATA: LS_FIELDCAT       TYPE SLIS_FIELDCAT_ALV.
DATA: POS               TYPE I.
DATA: G_SAVE(1)         TYPE C.
DATA: G_VARIANT         LIKE DISVARIANT.
DATA: G_USER_COMMAND    TYPE SLIS_FORMNAME VALUE 'P2000_ALV_COMMAND'.
