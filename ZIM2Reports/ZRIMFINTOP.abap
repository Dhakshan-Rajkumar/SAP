*----------------------------------------------------------------------*
*   INCLUDE ZRIMFINTOP                                                 *
*----------------------------------------------------------------------*


TABLES: ZTFINHD,
        ZTFINIT,
        ZTIMIMG00,
        ZTIMIMG08,
        ZTREQHD,
        ZTREQST,
        ZTBKPF,
        ZSBSEG,
        SPOP,
        ZTIMIMG11,
        ZTBL,
        BKPF,
        *LFA1,
        LFA1,
        VF_KRED,
        tbsl,
        t074u,
        tbslt,
        T007A,
        KONP,
        BAPICURR,
        T163C,
        T052.


DATA: W_ERR_CHK(1),
      W_LINE           TYPE I,
      W_COUNT          TYPE I,
      LINE             TYPE   I,
      W_DV_CT(1),
      MARKFIELD,
      W_DOM_TEX1       LIKE DD07T-DDTEXT,
      W_DOM_TEX2       LIKE DD07T-DDTEXT,
      W_DOM_TEX3       LIKE DD07T-DDTEXT,
      W_COST_TYPE      LIKE DD07T-DDTEXT,
      W_CODE_TYPE(30),
      WINDOW_TITLE(30) TYPE C,
      DYNPROG            LIKE SY-REPID,
      DYNNR              LIKE SY-DYNNR,
      W_PROC_CNT       TYPE I,               " ó���Ǽ�.
      W_SELECTED_LINES TYPE P,               " ���� LINE COUNT
      W_TABIX          LIKE SY-TABIX,
      W_PAGE           TYPE I,
      W_MOD            TYPE   I,
      W_ERR_MODE,
      W_SUBRC          LIKE SY-SUBRC,
      F(20)            TYPE C,             " Field Name Alias
      INCLUDE(8)       TYPE C,
      W_LOOPLINES      LIKE SY-LOOPC,      " loop counter
      OPTION(1)        TYPE C,             " ���� popup Screen���� ��?
      ANTWORT(1)       TYPE C,             " ���� popup Screen���� ��?
      CANCEL_OPTION    TYPE C,             " ���� popup Screen���� ��?
      TEXTLEN          TYPE I,             " ���� popup Screen���� ��?
      W_ROW_MARK       TYPE C,             " RECORD�� ���ÿ�?
      G_PARAM_LINE     LIKE SY-TABIX,      " TABLE�� ����?
      W_OK_CODE        LIKE SY-UCOMM,      " OK-CODE
      OK-CODE          LIKE SY-UCOMM,      " OK-CODE
      W_AMOUNT         LIKE ZTFINHD-ZFTFEE, " TOTAL AMOUNT.
      EGRKZ            LIKE     T007A-EGRKZ,
      W_ROW_MARK1      TYPE C.             " RECORD�� ���ÿ�?

DATA: W_KBETR             LIKE     KONP-KBETR,
      W_KBETR1            LIKE     KONP-KBETR,
      W_KONWA             LIKE     KONP-KONWA,
      W_WMWST             LIKE     ZTBKPF-WMWST,
      W_WMWST1            LIKE     ZTBKPF-WMWST.
CONTROLS: TC_0100    TYPE TABLEVIEW USING SCREEN 0100.

DATA : BEGIN OF IT_ERR_LIST OCCURS 0.
       INCLUDE  STRUCTURE  BDCMSGCOLL.
       DATA : ICON         LIKE BAL_S_DMSG-%_ICON,
              MESSTXT(255) TYPE C,
              ZFIVNO       LIKE ZTIV-ZFIVNO,
              ZFSEQ        LIKE ZSBLCST-ZFSEQ,
              ZFSUBSEQ     TYPE I.
DATA : END OF IT_ERR_LIST.

*>> ����ڵ� HELP.
DATA : BEGIN OF IT_COST_HELP OCCURS 0,
       ZFCD      LIKE ZTIMIMG08-ZFCD,
       ZFCDNM    LIKE ZTIMIMG08-ZFCDNM,
       ZFCD1     LIKE ZTIMIMG08-ZFCD1,
       ZFCD5     LIKE ZTIMIMG08-ZFCD5,
       COND_TYPE LIKE ZTIMIMG08-COND_TYPE,
       END OF IT_COST_HELP.

DATA:   BEGIN OF RETURN OCCURS 0.   ">> RETURN ����.
        INCLUDE STRUCTURE   BAPIRET2.
DATA:   END   OF RETURN.

DATA:   BEGIN OF XRETURN OCCURS 0.   ">> RETURN ����.
        INCLUDE STRUCTURE   BAPIRET2.
DATA:   END   OF XRETURN.

TABLES : BAPIMEPOHEADER,
         BAPIMEPOHEADERX.

*-----------------------------------------------------------------------
* INTERNAL TABLE
*-----------------------------------------------------------------------
DATA : BEGIN OF IT_FINHD OCCURS 0,
       ZFDHENO  LIKE  ZTFINHD-ZFDHENO,	  " ����������ȣ.
       ZFREQNO  LIKE  ZTREQST-ZFREQNO,     " �����Ƿڰ�����ȣ.
       ZFAMDNO  LIKE  ZTREQST-ZFAMDNO,     " AMEND SEQ.
       ZFOPBN   LIKE  ZTREQHD-ZFOPBN,
       ZFBILCD  LIKE  ZTFINHD-ZFBILCD,	  " ��꼭�뵵.
       ZFREFNO  LIKE  ZTFINHD-ZFREFNO,     " ����������ȣ.
       ZFTRDT   LIKE  ZTFINHD-ZFTRDT,      " �ŷ�����.
       ZFRCDT	  LIKE  ZTFINHD-ZFRCDT,	  " ������.
       ZFTERM	  LIKE  ZTFINHD-ZFTERM,      " �������.
       ZFNOTE	  LIKE  ZTFINHD-ZFNOTE,      " ��������.
       BUKRS    LIKE  ZTFINHD-BUKRS,
       GJAHR    LIKE  ZTFINHD-GJAHR,
       BELNR    LIKE  ZTFINHD-BELNR,
       ZFBKCD	  LIKE  ZTFINHD-ZFBKCD,	 " �����ڵ�.
       ZFBKNM	  LIKE  ZTFINHD-ZFBKNM,      " �����.
       ZFBRNM	  LIKE  ZTFINHD-ZFBRNM,	  " �߱����� ������.
       ZFTFEE	  LIKE  ZTFINHD-ZFTFEE,      " ������(����) �հ�.
       WAERS	  LIKE  ZTFINHD-WAERS,       " ��ȭŰ.
       ZFDBYN	  LIKE  ZTFINHD-ZFDBYN,      " ������ �ݿ� ����.
       ZFDBDT	  LIKE  ZTFINHD-ZFDBDT,      " ������ �ݿ� ����.
       OK(1),                              " ��ġ����.
       MAT_OK(4),                          " ��ġ����.
       ZFDBTM	  LIKE  ZTFINHD-ZFDBTM.      " ������ �ݿ� �ð�.
DATA : END OF IT_FINHD.

DATA : BEGIN OF IT_FINIT OCCURS 0,
       ZFDHENO   LIKE  ZTFINIT-ZFDHENO,	" ����������ȣ.
       ZFSEQ	   LIKE  ZTFINIT-ZFSEQ,	" �Ϸù�ȣ.
       ZFCD	   LIKE  ZTFINIT-ZFCD,       " �����ڵ�.
       ZFRATE	   LIKE  ZTFINIT-ZFRATE,     " ������(����) ������.
       ZFAMT	   LIKE  ZTFINIT-ZFAMT,      " �ݾ�.
       WAERS	   LIKE  ZTFINIT-WAERS,      " ��ȭŰ.
       ZFCDNM    LIKE  ZTIMIMG08-ZFCDNM,   " ��볻��.
       COND_TYPE LIKE ZTIMIMG08-COND_TYPE, " �����ڵ�.
       BLART     LIKE ZTIMIMG08-BLART,     " ��������.
       DV_CT(1),                           " DELVERY COST ����.
       ZFFEE	   LIKE  ZTFINIT-ZFFEE,      " ����ݾ�(������,����).
       ZFKRW	   LIKE  ZTFINIT-ZFKRW,      " ��ȭ��ȭ.
       ZFEXRT	   LIKE  ZTFINIT-ZFEXRT,     " ȯ��.
       ZFDAY	   LIKE  ZTFINIT-ZFDAY,      " �����ϼ�.
       ZFFROM	   LIKE  ZTFINIT-ZFFROM,     " ����Ⱓ(FROM).
       ZFEND	   LIKE  ZTFINIT-ZFEND.      " ����Ⱓ(TO).
DATA : END OF IT_FINIT.

DATA : BEGIN OF IT_COSTGB OCCURS 2,
       DV_CT(1),                           " DELVERY COST ����.
       END   OF IT_COSTGB.

DATA: BEGIN OF IT_SELECTED OCCURS 0,
      BUKRS      LIKE  ZTFINHD-BUKRS,
      ZFDHENO    LIKE  ZTFINIT-ZFDHENO,	" ����������ȣ.
      ZFREQNO    LIKE ZTREQST-ZFREQNO,   " �����Ƿ� ������ȣ.
      ZFAMDNO    LIKE ZTREQST-ZFAMDNO,   " Amend Seq.
      ZFBKCD	   LIKE  ZTFINHD-ZFBKCD,   " �����ڵ�.
      ZFTFEE	   LIKE  ZTFINHD-ZFTFEE,   " ������(����) �հ�.
END OF IT_SELECTED.

*>> ��� �׸�� INTENANL TABLE.
DATA: IT_ZSBSEG          LIKE ZSBSEG OCCURS 100 WITH HEADER LINE.
DATA: IT_ZSBSEGC_OLD     LIKE ZSBSEG OCCURS 100 WITH HEADER LINE.
DATA: IT_ZSBSEGV         LIKE ZSBSEG OCCURS 100 WITH HEADER LINE.
DATA: IT_ZSBSEGV_OLD     LIKE ZSBSEG OCCURS 100 WITH HEADER LINE.
DATA: W_OLD_ZFBKCD       LIKE ZTFINHD-ZFBKCD.
DATA: W_OLD_BUKRS        LIKE ZTBKPF-BUKRS.
DATA: IT_ZTFINHD         LIKE ZTFINHD OCCURS 100 WITH HEADER LINE.
DATA: IT_ZTFINIT         LIKE ZTFINIT OCCURS 100 WITH HEADER LINE.

DATA: IT_ZTDHF1          LIKE ZTDHF1  OCCURS 100 WITH HEADER LINE.
