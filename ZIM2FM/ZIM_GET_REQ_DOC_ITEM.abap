FUNCTION ZIM_GET_REQ_DOC_ITEM.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(EBELN) LIKE  ZTREQHD-EBELN
*"     REFERENCE(KNUMV) LIKE  EKKO-KNUMV
*"     VALUE(KPOSN) LIKE  KONV-KPOSN OPTIONAL
*"     VALUE(KSCHL) LIKE  KONV-KSCHL
*"     VALUE(ZFREQNO) LIKE  ZSREQHD-ZFREQNO
*"     VALUE(ZFAMDNO) LIKE  ZTREQST-ZFAMDNO OPTIONAL
*"  EXPORTING
*"     VALUE(W_ITEM_CNT) LIKE  SY-TABIX
*"     VALUE(W_TOT_AMOUNT) LIKE  ZTREQHD-ZFLASTAM
*"  TABLES
*"      IT_ZSREQIT STRUCTURE  ZSREQIT
*"      IT_ZSREQIT_ORG STRUCTURE  ZSREQIT
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NOT_INPUT
*"      NO_REFERENCE
*"      NO_AMOUNT
*"----------------------------------------------------------------------
DATA : WL_DATE    LIKE SY-DATUM.
DATA : IT_ZTREQIT LIKE ZTREQIT    OCCURS 200 WITH HEADER LINE.

*-----------------------------------------------------------------------
* 2000/03/04    ������ ���� ��?
*  desc : �Ƿ� ǰ���� Amend ������ DB���� �����ʿ� ����?
*         Amend ���� Logic�� ���� ��Ŵ.
*-----------------------------------------------------------------------
  REFRESH : IT_ZSREQIT, IT_ZSREQIT_ORG.
  CLEAR : W_ITEM_CNT, W_TOT_AMOUNT.

  IF ZFREQNO IS INITIAL.   RAISE NOT_INPUT.   ENDIF.

*  IF ZFAMDNO IS INITIAL.
** MAX AMEND Ƚ�� SELECT
*     SELECT MAX( ZFAMDNO ) INTO  ZFAMDNO
*                           FROM  ZTREQST
*                           WHERE ZFREQNO  EQ   ZFREQNO.
*  ENDIF.

  IF EBELN IS INITIAL.
     SELECT SINGLE * FROM ZTREQHD WHERE ZFREQNO  EQ   ZFREQNO.
     MOVE : ZTREQHD-EBELN   TO   EBELN.
  ENDIF.

  SELECT SINGLE * FROM EKKO
         WHERE EBELN EQ EBELN.

  SELECT EBELN INTO CORRESPONDING FIELDS OF TABLE IT_EBELN
  FROM   ZTREQIT
  WHERE  ZFREQNO    EQ  ZFREQNO
  GROUP BY
         EBELN.

************************************************************************
* ��ü SELECT.. ---> LOOP...
************************************************************************
*  SELECT * FROM  ZTREQIT
*           WHERE ZFREQNO  EQ   ZFREQNO
*           ORDER BY ZFITMNO.
*     CLEAR : IT_ZSREQIT, IT_ZSREQIT_ORG.
  REFRESH : IT_ZTREQIT.

* SELECT * INTO TABLE IT_ZTREQIT
  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_ZTREQIT
            FROM ZTREQIT
            WHERE ZFREQNO  EQ   ZFREQNO
            ORDER BY ZFITMNO.

  LOOP AT IT_ZTREQIT.
     CLEAR : IT_ZSREQIT, IT_ZSREQIT_ORG.

*-----------------------------------------------------------------------
* PO ���� SELECT.
*-----------------------------------------------------------------------
     SELECT SINGLE * FROM EKPO WHERE EBELN  EQ   IT_ZTREQIT-EBELN
                               AND   EBELP  EQ   IT_ZTREQIT-EBELP.

     IF SY-SUBRC NE 0.
        MESSAGE S069 WITH EBELN IT_ZTREQIT-ZFITMNO.
     ELSE.
* ���� �� ��ǰ�Ϸ� ���� ����...
        IF SY-TCODE EQ 'ZIM01' OR SY-TCODE EQ 'ZIM11'.
*           IF NOT ( EKPO-LOEKZ IS INITIAL ) OR    " ��������?
*              NOT ( EKPO-ELIKZ IS INITIAL ).      " ��ǰ��?
*              EKPO-MENGE = 0.
*              MESSAGE S070 WITH IT_ZTREQIT-ZFITMNO.
*           ENDIF.
           IF NOT ( EKPO-LOEKZ IS INITIAL ).      ">��������?
              EKPO-MENGE = 0.
              MESSAGE S069 WITH EBELN IT_ZTREQIT-EBELP.
           ENDIF.
        ELSE.
           IF NOT ( EKPO-LOEKZ IS INITIAL ).      " ��������?
              EKPO-MENGE = 0.
              MESSAGE S069 WITH EBELN IT_ZTREQIT-EBELP.
           ENDIF.
        ENDIF.
     ENDIF.

*-----------------------------------------------------------------------
* �����Ƿ� ���� SELECT
*-----------------------------------------------------------------------
     W_TOT_MENGE = 0.
* �����Ƿڹ�ȣ ��ȸ Loop....
     SELECT ZFREQNO ZFITMNO INTO  (W_ZFREQNO, W_ZFITMNO)
                    FROM  ZTREQIT
                    WHERE EBELN = IT_ZTREQIT-EBELN
                    AND   EBELP = IT_ZTREQIT-EBELP
                    GROUP BY
                          ZFREQNO ZFITMNO.
** �����Ƿ��� Max Amend ȸ�� ��ȸ...
*        IF NOT ( W_ZFREQNO IS INITIAL ).
*           SELECT MAX( ZFAMDNO ) INTO  W_ZFAMDNO
*                                 FROM  ZTREQIT
*                                 WHERE ZFREQNO   EQ   W_ZFREQNO
*                                 AND   ZFITMNO   EQ   ZTREQIT-ZFITMNO.
* �����Ƿڴ� Item Sum....
           SELECT SUM( MENGE ) INTO  W_MENGE
                               FROM  ZTREQIT
                               WHERE ZFREQNO EQ W_ZFREQNO
                               AND   ZFITMNO EQ W_ZFITMNO.

           W_TOT_MENGE = W_TOT_MENGE + W_MENGE.    " �����Ƿڼ��� ����..
*       ENDIF.
     ENDSELECT.
*-----------------------------------------------------------------------
* Delivery Date
*    SELECT EINDT INTO WL_DATE  FROM  EKET UP TO 1 ROWS
*-----------------------------------------------------------------------
     SELECT *  FROM  EKET UP TO 1 ROWS
                                WHERE EBELN EQ IT_ZTREQIT-EBELN
                                AND   EBELP EQ IT_ZTREQIT-EBELP
                                ORDER BY EINDT.
        EXIT.
     ENDSELECT.

     IF EKET-EINDT GT 0.
        CALL FUNCTION 'PERIOD_AND_DATE_CONVERT_OUTPUT'
             EXPORTING
                  INTERNAL_DATE   = EKET-EINDT
                  INTERNAL_PERIOD = EKET-LPEIN
             IMPORTING
                  EXTERNAL_DATE   = IT_ZSREQIT-EEIND
                  EXTERNAL_PERIOD = IT_ZSREQIT-LPEIN.
     ENDIF.

*-----------------------------------------------------------------------
* �����Ƿ� Internal Table Append
*-----------------------------------------------------------------------
     MOVE-CORRESPONDING IT_ZTREQIT  TO IT_ZSREQIT.
     MOVE : EKPO-MENGE   TO  IT_ZSREQIT-ZFPOMENGE,  " ���ſ��� ��?
            W_TOT_MENGE  TO  IT_ZSREQIT-ZFLCMENGE,  " �����Ƿ� ��?
*           EKPO-ZZMOGRU TO  IT_ZSREQIT-ZFIRLW,     " ������?
*           EKPO-ZZHSCODE TO IT_ZSREQIT-STAWN,     " H/S CODE
            EKET-EINDT   TO  IT_ZSREQIT-ZFEEIND,    " ��ǰ ����.
            EKPO-BPUMZ   TO  IT_ZSREQIT-BPUMZ,      ">�и�.
            EKPO-BPUMN   TO  IT_ZSREQIT-BPUMN,      ">����.
            EKPO-LOEKZ   TO  IT_ZSREQIT-LOEKZ,      " ��������?
            EKPO-ELIKZ   TO  IT_ZSREQIT-ELIKZ.      " ��ǰ��?

     IF EKKO-BSTYP EQ 'F'.       ">���ſ���.
        MOVE EKPO-MENGE TO IT_ZSREQIT-ZFPOMENGE.  " ���ſ��� ��?
     ELSEIF EKKO-BSTYP EQ 'L'.   ">��ǰ�������.
        MOVE EKPO-KTMNG TO IT_ZSREQIT-ZFPOMENGE.  " ��ǥ����.
     ELSEIF EKKO-BSTYP EQ 'K'.   ">���.
        MOVE EKPO-KTMNG TO IT_ZSREQIT-ZFPOMENGE.  " ��ǥ����.
     ENDIF.

* ������õ ��󿩺�.
     SELECT * FROM ZTIMIMG09
                   WHERE STAWN    EQ IT_ZSREQIT-STAWN
                   AND   ZFAPLDT  <= SY-DATUM ORDER BY ZFAPLDT.
          EXIT.
     ENDSELECT.
     MOVE ZTIMIMG09-ZFIRLW    TO    IT_ZSREQIT-ZFIRLW.
     APPEND IT_ZSREQIT.

*-----------------------------------------------------------------------
* �����Ƿ� Amount
*-----------------------------------------------------------------------
      W_TOT_AMOUNT = W_TOT_AMOUNT +
           ( IT_ZSREQIT-MENGE *
           ( IT_ZSREQIT-BPUMZ / IT_ZSREQIT-BPUMN ) *
           ( IT_ZSREQIT-NETPR / IT_ZSREQIT-PEINH ) ).
      W_ITEM_CNT = W_ITEM_CNT + 1.
  ENDLOOP.

*  IF SY-SUBRC NE 0.
*     RAISE NOT_FOUND.
*  ENDIF.
   W_SY_SUBRC = SY-SUBRC.

  LOOP  AT  IT_EBELN.
     REFRESH : IT_ZSREQIT_OLD.
*-----------------------------------------------------------------------
* P/O ITME TABLE SELECT ( EKPO )
*-----------------------------------------------------------------------
     CALL FUNCTION 'ZIM_GET_PO_ITEM'
            EXPORTING
                  EBELN   =  IT_EBELN-EBELN
                  KNUMV   =  KNUMV
                  KSCHL   =  KSCHL
                  LOEKZ   =  SPACE
                  ELIKZ   =  SPACE
*        IMPORTING
*              W_ITEM_CNT      =   W_ITEM_CNT
*              W_TOT_AMOUNT    =   W_TOT_AMOUNT
*              W_ZFMAUD        =   W_ZFMAUD
*              W_ZFWERKS       =   W_ZFWERKS
*              W_BEDNR         =   W_BEDNR
            TABLES
*               IT_ZSREQIT      =   IT_ZSREQIT_ORG
                  IT_ZSREQIT_ORG  =   IT_ZSREQIT_OLD
            EXCEPTIONS
                   KEY_INCOMPLETE =   1
                   NOT_FOUND      =   2
                   NO_REFERENCE   =   3
                   NO_AMOUNT      =   4.

*  CASE SY-SUBRC.
*     WHEN 1.    MESSAGE E003.
*     WHEN 2.    MESSAGE E006     WITH ZSREQHD-EBELN.
*     WHEN 3.    MESSAGE E006     WITH ZSREQHD-EBELN.
*     WHEN 4.    MESSAGE E007     WITH ZSREQHD-EBELN.
*  ENDCASE.

     LOOP AT IT_ZSREQIT_OLD.
        W_TABIX = SY-TABIX.
* >> ���� �Ƿ� Item Select
        SELECT SINGLE * FROM ZTREQIT WHERE ZFREQNO EQ ZFREQNO
                              AND   ZFITMNO EQ IT_ZSREQIT_OLD-ZFITMNO.
* >> P/O Item Select
*     SELECT SINGLE * FROM EKPO   WHERE EBELN   EQ EBELN
*                                AND   EBELP  EQ IT_ZSREQIT_ORG-ZFITMNO.
        IF SY-SUBRC EQ 0.
           IT_ZSREQIT_OLD-ZFLCMENGE = IT_ZSREQIT_OLD-ZFLCMENGE
                                    - ZTREQIT-MENGE.
*-----------------------------------------------------------------------
*  2000/05/29 : KSB ���� ��?
*        IT_ZSREQIT_ORG-MENGE     = IT_ZSREQIT_ORG-MENGE
*                                 + ZTREQIT-MENGE.

           IT_ZSREQIT_OLD-MENGE     = IT_ZSREQIT_OLD-ZFPOMENGE
                                    - IT_ZSREQIT_OLD-ZFLCMENGE.
*-----------------------------------------------------------------------
           MODIFY IT_ZSREQIT_OLD INDEX W_TABIX.
        ENDIF.
*    IT_ZSREQIT_ORG-STAWN     = ZTREQIT-STAWN.    " H/S CODE
*    IT_ZSREQIT_ORG-ZFIRLW    = EKPO-ZZMOGRU.     " ������?
     ENDLOOP.

     LOOP  AT  IT_ZSREQIT_OLD.
        MOVE-CORRESPONDING  IT_ZSREQIT_OLD  TO  IT_ZSREQIT_ORG.
        APPEND  IT_ZSREQIT_ORG.
     ENDLOOP.
  ENDLOOP.

  IF W_SY_SUBRC NE 0.
     RAISE NOT_FOUND.
  ENDIF.

ENDFUNCTION.
