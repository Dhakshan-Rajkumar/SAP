*&---------------------------------------------------------------------*
*& Report  ZRIMLCREQ                                                   *
*&---------------------------------------------------------------------*
*&  ���α׷��� : LC ������û��.                                        *
*&      �ۼ��� : ����ȣ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.02.12                                            *
*&    ����ȸ�� : ��������                                              *
*&---------------------------------------------------------------------*
*&   DESC.     : L/C ������û���� ����ϱ� ���� ����Ʈ.                *
*
*&---------------------------------------------------------------------*
*& [���泻��]  :
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMLCREQ    MESSAGE-ID ZIM NO STANDARD PAGE HEADING
                     LINE-SIZE 120.

TABLES : ZTREQHD,                      " �����Ƿ� Header Table..
         ZTREQIT,                      " �����Ƿ� Item   Table..
         ZTREQST,                      " �����Ƿ� ����   Table..
         ZTRECST,                      " �����Ƿ� ���   Table..
         ZTMLCSG7O,                    " Master L/C Seg 7 ������ Table..
         ZTMLCHD,                      " Master L/C Header Table..
         ZTMLCSG7G,                    " Master L/C Seg 7 ��ǰ��..
         ZTMLCSG8E,                    " Master L/C Seg 8 ��Ÿ�ΰ�����..
         ZTMLCSG2,                     " Master L/C Seg 2..
         ZTMLCSG910,                   " Master L/C Seg 9-10..
         ZTMLCSG9O,                    " Master L/C Seg 9 ��Ÿ���񼭷�..
         T005T,                        " �����̸�..
         T005.                         " ����..

*----------------------------------------------------------------------*
* Internal Table ����... Master L/C ���û��� �Է�..                    *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_MLC OCCURS 1000,
        ZFREQNO    LIKE  ZTMLCHD-ZFREQNO,    " �����Ƿڰ�����ȣ..
*        ZFOPBN     LIKE  ZTMLCHD-ZFOPBN,     " �������� �ŷ�ó�ڵ�..
        ZFOBNM     LIKE  ZTMLCHD-ZFOBNM,     " ���������..
        ZFABNM     LIKE  ZTMLCHD-ZFABNM,     " ���������..
        ZFTRMB     LIKE  ZTMLCHD-ZFTRMB,     " ȭȯ/ȥ��/������ ����VV..
        ZFALCQ     LIKE  ZTMLCHD-ZFALCQ,     " ����������� ��뿩��..
        ZFALCP     LIKE  ZTMLCHD-ZFALCP,     " �����������..
        ZFPRMT     LIKE  ZTMLCHD-ZFPRMT,     " ���Ҽ�����뿩��..
        ZFTRMT     LIKE  ZTMLCHD-ZFTRMT,     " ȯ����뿩��..
        ZFAPRT     LIKE  ZTMLCHD-ZFAPRT,     " ������..
        ZFSPRT     LIKE  ZTMLCHD-ZFSPRT,     " ������..
        ZFOPME     LIKE  ZTMLCHD-ZFOPME,     " �������..
        ZFCARR     LIKE  ZTMLCHD-ZFCARR,     " ����ȸ��/���ڸ�..
        ZFUSAT     LIKE  ZTMLCHD-ZFUSAT,     " Usance/At Sight ����..
        ZFADCD1    LIKE  ZTMLCHD-ZFADCD1,    " �ֿ�ΰ�����1.
        ZFADCD2    LIKE  ZTMLCHD-ZFADCD2,    " �ֿ�ΰ�����2.
        ZFADCD3    LIKE  ZTMLCHD-ZFADCD3,    " �ֿ�ΰ�����3.
        ZFADCD4    LIKE  ZTMLCHD-ZFADCD4,    " �ֿ�ΰ�����4.
        ZFLCTY     LIKE  ZTMLCHD-ZFLCTY,     " �ſ��� ����..
        ZFADCD5    LIKE  ZTMLCHD-ZFADCD5,    " �ֿ�ΰ�����5..
        ZFLTSD     LIKE  ZTMLCHD-ZFLTSD,     " ����������..
        ZFEXDT     LIKE  ZTMLCHD-ZFEXDT,     " ��ȿ����..
        WAERS      LIKE  ZTMLCHD-WAERS,      " ��ȭŰ..
        ZFOPAMT    LIKE  ZTMLCHD-ZFOPAMT,    " �����ݾ�..
        INCO1      LIKE  ZTMLCHD-INCO1,      " �ε����� (Part 1)..
        ZFTRTX1    LIKE  ZTMLCHD-ZFTRTX1,    " �������Ǹ�1..
        ZFTRTX2    LIKE  ZTMLCHD-ZFTRTX2,    " �������Ǹ�2..
        ZFTRTX3    LIKE  ZTMLCHD-ZFTRTX3,    " �������Ǹ�3..
        ZFTRTX4    LIKE  ZTMLCHD-ZFTRTX4,    " �������Ǹ�4..
        ZFUSPR     LIKE  ZTMLCHD-ZFUSPR,     " Usance �Ⱓ..
        ZFABBR     LIKE  ZTMLCHD-ZFABBR,     " �������� ������..
        ZFAPPNM    LIKE  ZTMLCSG2-ZFAPPNM,   " Applicant ��ȣ/����..
        ZFAPPAD1   LIKE  ZTMLCSG2-ZFAPPAD1,  " Applicant �ּ� 1..
        ZFAPPAD2   LIKE  ZTMLCSG2-ZFAPPAD2,  " Applicant �ּ� 2..
        ZFAPPAD3   LIKE  ZTMLCSG2-ZFAPPAD3,  " Applicant �ּ� 3..
        ZFBENI1    LIKE  ZTMLCSG2-ZFBENI1,   " ������ ��ȣ/�ּ� 1..
        ZFBENI2    LIKE  ZTMLCSG2-ZFBENI2,   " ������ ��ȣ/�ּ� 2..
        ZFBENI3    LIKE  ZTMLCSG2-ZFBENI3,   " ������ ��ȣ/�ּ� 3..
        ZFBENI4    LIKE  ZTMLCSG2-ZFBENI4,   " ������ ��ȣ/�ּ� 4..
        ZFBENIA    LIKE  ZTMLCSG2-ZFBENIA,   " ������ Account No..
        ZFOCEYN    LIKE  ZTMLCSG910-ZFOCEYN, " Ocean Bill ÷�ο���..
        ZFOCEAC    LIKE  ZTMLCSG910-ZFOCEAC, " Ocean Bill �������ҿ���..
        ZFOCEC1    LIKE  ZTMLCSG910-ZFOCEC1, " Ocean Bill �ϼ���1..
        ZFOCEC2    LIKE  ZTMLCSG910-ZFOCEC2, " Ocean Bill �ϼ���2..
        ZFOCEAN    LIKE  ZTMLCSG910-ZFOCEAN, " Ocean Bill ����ó..
        ZFCOMYN    LIKE  ZTMLCSG910-ZFCOMYN, " ������� ÷�ο���..
        ZFNOCOM    LIKE  ZTMLCSG910-ZFNOCOM, " ������� ���..
        ZFAIRYN    LIKE  ZTMLCSG910-ZFAIRYN, " Air Bill ÷�ο���..
        ZFAIRC1    LIKE  ZTMLCSG910-ZFAIRC1, " Air Bill �ϼ��� 1..
        ZFAIRC2    LIKE  ZTMLCSG910-ZFAIRC2, " Air Bill �ϼ��� 2..
        ZFAIRAC    LIKE  ZTMLCSG910-ZFAIRAC, " Air Bill �������ҿ���..
        ZFAIRAN    LIKE  ZTMLCSG910-ZFAIRAN, " Air Bill ����ó..
        ZFINYN     LIKE  ZTMLCSG910-ZFINYN,  " �������� ÷�ο���..
        ZFINCO1    LIKE  ZTMLCSG910-ZFINCO1, " �κ����� 1..
        ZFINCO2    LIKE  ZTMLCSG910-ZFINCO2, " �κ����� 2..
        ZFPACYN    LIKE  ZTMLCSG910-ZFPACYN, " Packing List ÷�ο���..
        ZFNOPAC    LIKE  ZTMLCSG910-ZFNOPAC, " Packing List ���..
        ZFCEOYN    LIKE  ZTMLCSG910-ZFCEOYN, " ���������� ÷�ο���..
        ZFOTDYN    LIKE  ZTMLCSG910-ZFOTDYN, " ��Ÿ���񼭷� ÷�ο���..
      END OF IT_MLC.

*----------------------------------------------------------------------*
* Internal Table ����... �����Ƿڰ��� ���̺�..                         *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_RN OCCURS 1000,
        ZFREQNO   LIKE   ZTREQHD-ZFREQNO,  " �����Ƿڹ�ȣ..
        ZFREQED   LIKE   ZTREQHD-ZFREQED,  " �Ƿ� ��ȿ��..
        ZFREQSD   LIKE   ZTREQHD-ZFREQSD,  " �Ƿڼ��� ��ȿ��..
        ZFREQTY   LIKE   ZTREQHD-ZFREQTY,  " �����Ƿ� Type.
        EBELN     LIKE   ZTREQHD-EBELN,    " Purchasing Document Number.
        LIFNR     LIKE   ZTREQHD-LIFNR,    " Vendor's Account Number.
        LLIEF     LIKE   ZTREQHD-LLIEF,    " Supplying Vendor.
        ZFBENI    LIKE   ZTREQHD-ZFBENI,   " Different Invoicing Party.
        ZTERM     LIKE   ZTREQHD-ZTERM,    " Terms of Payment Key.
        INCO1     LIKE   ZTREQHD-INCO1,    " Incoterms (Part1).
        ZFLASTAM  LIKE   ZTREQHD-ZFLASTAM, " ���������ݾ�.
        WAERS     LIKE   ZTREQHD-WAERS,    " Currency Key.
        ZFUSDAM   LIKE   ZTREQHD-ZFUSDAM,  " USD ȯ��ݾ�.
        ZFMATGB   LIKE   ZTREQHD-ZFMATGB,  " ���籸��.
        ZFUSD     LIKE   ZTREQHD-ZFUSD,    " ��ȭ��ȭ.
        ZFSPRT    LIKE   ZTREQHD-ZFSPRT,   " ������.
        ZFAPRT    LIKE   ZTREQHD-ZFAPRT,   " ������.
        ZFITMNO   LIKE   ZTREQIT-ZFITMNO,  " ���Թ��� ǰ���ȣ.
        MATNR     LIKE   ZTREQIT-MATNR,    " Material Number.
        STAWN     LIKE   ZTREQIT-STAWN,    " Commodity Code.
        MENGE     LIKE   ZTREQIT-MENGE,    " �����Ƿڼ���.
        MEINS     LIKE   ZTREQIT-MEINS,    " Base Unit of Measure.
        NETPR     LIKE   ZTREQIT-NETPR,    " Net Price.
        PEINH     LIKE   ZTREQIT-PEINH,    " Price Unit.
        BPRME     LIKE   ZTREQIT-BPRME,    " Order Price Unit.
        TXZ01     LIKE   ZTREQIT-TXZ01,    " Short Text.
        ZFAMDNO   LIKE   ZTREQST-ZFAMDNO,  " Amend Seq.
        ZFDOCST   LIKE   ZTREQST-ZFDOCST,  " ���� ����.
        ZFRTNYN   LIKE   ZTREQST-ZFRTNYN,  " ���� �ݷ� ����.
        ZFRLST1   LIKE   ZTREQST-ZFRLST1,  " �Ƿ� Release ����.
        ZFRLST2   LIKE   ZTREQST-ZFRLST2,  " ���� Release ����.
        CDAT      LIKE   ZTREQST-CDAT,     " Created on.
        ZFREQDT   LIKE   ZTREQST-ZFREQDT,  " �䰳������.
        ERNAM     LIKE   ZTREQST-ERNAM,    " Creater.
        EKORG     LIKE   ZTREQST-EKORG,    " Purch. Org.
        EKGRP     LIKE   ZTREQST-EKGRP,    " Purch. Grp.
        ZFOPNNO   LIKE   ZTREQST-ZFOPNNO,  " �ſ���-���ι�ȣ.
        ZFOPAMT   LIKE   ZTREQST-ZFOPAMT,  " ���� �ݾ�.
      END OF IT_RN.

*----------------------------------------------------------------------*
* Internal Table ����.. �ݺ��� Seg 8 ��Ÿ�ΰ������� �б����� Table..   *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_SG8E OCCURS 500,
        ZFREQNO   LIKE   ZTMLCSG8E-ZFREQNO, " �����Ƿڰ�����ȣ..
        ZFLSG8E   LIKE   ZTMLCSG8E-ZFLSG8E, " �ݺ��� Seg 8 ��Ÿ�ΰ�����.
        ZFOACD1   LIKE   ZTMLCSG8E-ZFOACD1, " ��Ÿ �ΰ�����..
      END OF IT_SG8E.

*----------------------------------------------------------------------*
* Internal Table ����.. �ݺ��� Seg 7 ��ǰ���� �б� ���� Table..      *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_SG7G OCCURS 500,
        ZFREQNO   LIKE   ZTMLCSG7G-ZFREQNO, " �����Ƿڰ�����ȣ..
        ZFLSG7G   LIKE   ZTMLCSG7G-ZFLSG7G, " �ݺ��� Seg 7 ��ǰ��..
        ZFDSOG1   LIKE   ZTMLCSG7G-ZFDSOG1, " ��ǰ�뿪��..
      END OF IT_SG7G.

*----------------------------------------------------------------------*
* Internal Table ����.. Master L/C Seg 7 �������� �б� ���� Table..    *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_SG7O OCCURS 500,
        ZFREQNO   LIKE   ZTMLCSG7O-ZFREQNO, " �����Ƿڰ�����ȣ..
        ZFLSG7O   LIKE   ZTMLCSG7O-ZFLSG7O, " �ݺ��� Seg 7 ������..
        ZFORIG    LIKE   ZTMLCSG7O-ZFORIG,  " ������걹..
      END OF IT_SG7O.

*----------------------------------------------------------------------*
* Internal Table ����.. Master L/C Seg 7 �������� �б� ���� Table..    *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_SG9O OCCURS 500,
        ZFREQNO   LIKE   ZTMLCSG9O-ZFREQNO, " �����Ƿڰ�����ȣ..
        ZFLSG9O   LIKE   ZTMLCSG9O-ZFLSG9O, " �ݺ��� Seg 9 ��Ÿ���񼭷�.
        ZFODOC1   LIKE   ZTMLCSG9O-ZFODOC1, " ��Ÿ���񼭷� 1..
      END OF IT_SG9O.

*----------------------------------------------------------------------*
* Internal Table ����.. �����̸��� �б� ���� Table..                   *
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_T005T OCCURS 500,
        LAND1     LIKE   T005T-LAND1,       " ����Ű..
        LANDX     LIKE   T005T-LANDX,       " �����̸�..
      END OF IT_T005T.

*----------------------------------------------------------------------*
* Error Check�� Table Index�� �б����� ���� ����..
*----------------------------------------------------------------------*
DATA: W_ERR_CHK   TYPE  C,
      W_TABIX     TYPE  I,
      TEMP        TYPE  I,
      NETPR(8)    TYPE  C.

*-----------------------------------------------------------------------
* �˻����� Selection Window.
*-----------------------------------------------------------------------
SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: S_REQNO   FOR ZTREQHD-ZFREQNO      " �����Ƿڰ�����ȣ..
                NO INTERVALS NO-EXTENSION OBLIGATORY.

SELECTION-SCREEN END OF BLOCK B2.

*-----------------------------------------------------------------------
* INITIALIZATION: �˻�ȭ�� ������ �߻��ϴ� �̺�Ʈ..
*-----------------------------------------------------------------------
INITIALIZATION.
   SET TITLEBAR 'TIT1'.          " Title: '�ſ��� ���� ��û��'.

*-----------------------------------------------------------------------
* START-OF-SELECTION: �˻�ȭ���� �����ϱ����� �̺�Ʈ..
* IT_MLC �� IT_RN ���� �����͸� �о���̱� ���� Logic..
*-----------------------------------------------------------------------
START-OF-SELECTION.

   PERFORM P1000_READ_RN_DATA.
   CHECK W_ERR_CHK EQ 'N'.
   PERFORM P1000_READ_MLC_DATA.
   PERFORM P1000_READ_SG7O_DATA.
   PERFORM P1000_READ_SG7G_DATA.
   PERFORM P1000_READ_SG8E_DATA.
   PERFORM P1000_READ_SG9O_DATA.
   PERFORM P1000_READ_T005T_DATA.


*-----------------------------------------------------------------------
* END-OF-SELECTION.
*-----------------------------------------------------------------------
END-OF-SELECTION.
   CHECK W_ERR_CHK EQ 'N'.
* Title Text Write.
   SET TITLEBAR 'TIT1'.
   PERFORM P3000_WRITE_DATA.

*-----------------------------------------------------------------------
* AT USER-COMMAND.
*-----------------------------------------------------------------------
AT USER-COMMAND.


*&---------------------------------------------------------------------*
*&      Form  P1000_READ_MLC_DATA
*&---------------------------------------------------------------------*
*       Master L/C Data�� ������� ���� Logic.
*----------------------------------------------------------------------*
FORM P1000_READ_MLC_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_MLC
     FROM   ZTMLCHD AS H INNER JOIN ZTMLCSG2 AS I
     ON     H~ZFREQNO  EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN S_REQNO.

*>>> ZTMLCSG910 Table�� IT_MLC Table�� ����..
   LOOP AT IT_MLC.
      W_TABIX = SY-TABIX.
      SELECT SINGLE  ZFOCEYN ZFOCEAC ZFOCEC1 ZFOCEC2
                     ZFCOMYN ZFNOCOM ZFOCEAN ZFAIRYN
                     ZFAIRC1 ZFAIRC2 ZFAIRAC ZFINYN
                     ZFINCO1 ZFINCO2 ZFPACYN ZFNOPAC
                     ZFCEOYN ZFOTDYN
               INTO  (IT_MLC-ZFOCEYN, IT_MLC-ZFOCEAC,
                     IT_MLC-ZFOCEC1, IT_MLC-ZFOCEC2,
                     IT_MLC-ZFCOMYN, IT_MLC-ZFNOCOM,
                     IT_MLC-ZFOCEAN, IT_MLC-ZFAIRYN,
                     IT_MLC-ZFAIRC1, IT_MLC-ZFAIRC1,
                     IT_MLC-ZFAIRAC, IT_MLC-ZFINYN,
                     IT_MLC-ZFINCO1, IT_MLC-ZFINCO2,
                     IT_MLC-ZFPACYN, IT_MLC-ZFNOPAC,
                     IT_MLC-ZFCEOYN, IT_MLC-ZFOTDYN)
               FROM  ZTMLCSG910
              WHERE  ZFREQNO EQ IT_MLC-ZFREQNO.

      MODIFY IT_MLC  INDEX W_TABIX.
   ENDLOOP.

ENDFORM.                    " P1000_READ_MLC_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_RN_DATA
*&---------------------------------------------------------------------*
*       �����Ƿ� ���� Data�� ������� ���� Logic.
*----------------------------------------------------------------------*
FORM P1000_READ_RN_DATA.

   W_ERR_CHK = 'N'.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_RN
     FROM   ZTREQHD AS H INNER JOIN ZTREQIT AS I
     ON     H~ZFREQNO  EQ I~ZFREQNO
     WHERE  H~ZFREQNO  IN  S_REQNO.

   IF SY-SUBRC NE 0.
      W_ERR_CHK = 'Y'.
      MESSAGE S738.
      EXIT.
   ENDIF.

   READ TABLE IT_RN INDEX 1.
   IF SY-SUBRC EQ 0.
      IF IT_RN-ZFREQTY NE 'LC'.
         W_ERR_CHK = 'Y'.
         MESSAGE S385 WITH IT_RN-ZFREQNO IT_RN-ZFREQTY.
         EXIT.
      ENDIF.
   ENDIF.

ENDFORM.                    " P1000_READ_RN_DATA.

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_SG7O_DATA
*&---------------------------------------------------------------------*
*       Master L/C Seg 7 ������ �����͸� �б����� ����..
*----------------------------------------------------------------------*
FORM P1000_READ_SG7O_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_SG7O
     FROM  ZTMLCSG7O
     WHERE ZFREQNO IN S_REQNO.

ENDFORM.                    " P1000_READ_SG7O_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_SG7G_DATA
*&---------------------------------------------------------------------*
*       Master L/C Seg 7 ��ǰ�� �����͸� �б����� ����..
*----------------------------------------------------------------------*
FORM P1000_READ_SG7G_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_SG7G
     FROM  ZTMLCSG7G
     WHERE ZFREQNO IN S_REQNO.

ENDFORM.                    " P1000_READ_SG7G_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_SG8E_DATA
*&---------------------------------------------------------------------*
*       Master L/C Seg 8 ��Ÿ�ΰ����� �����͸� �б����� ����..
*----------------------------------------------------------------------*
FORM P1000_READ_SG8E_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_SG8E
     FROM  ZTMLCSG8E
     WHERE ZFREQNO IN S_REQNO.

ENDFORM.                    " P1000_READ_SG8E_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_SG9O_DATA
*&---------------------------------------------------------------------*
*       Master L/C Seg 9 ��Ÿ���񼭷� �����͸� �б����� ����..
*----------------------------------------------------------------------*
FORM P1000_READ_SG9O_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_SG9O
     FROM  ZTMLCSG9O
     WHERE ZFREQNO IN S_REQNO.

ENDFORM.                    " P1000_READ_SG9O_DATA

*&---------------------------------------------------------------------*
*&      Form  P1000_READ_T005T_DATA
*&---------------------------------------------------------------------*
*       �����̸� �����͸� �б����� ����..
*----------------------------------------------------------------------*
FORM P1000_READ_T005T_DATA.

   SELECT *
     INTO CORRESPONDING FIELDS OF TABLE IT_T005T
     FROM  T005T
     FOR ALL ENTRIES IN IT_SG7O
     WHERE LAND1 EQ IT_SG7O-ZFORIG
     AND   SPRAS EQ 'EN'.

ENDFORM.                    " P1000_READ_T005T_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_DATA
*&---------------------------------------------------------------------*
*       �ſ��� ���� ��û���� �ۼ��ϱ����� Write ����.
*----------------------------------------------------------------------*
FORM P3000_WRITE_DATA.
   LOOP AT IT_MLC.
      PERFORM P3000_TITLE_WRITE.    " Ÿ��Ʋ ����� ���� ����..
      PERFORM P3000_HIGH_WRITE.     " ���κ� ����� ���� ����..
      PERFORM P3000_USANCE_WRITE.   " Usance ����� ���� ����..
      PERFORM P3000_DSCRTN_WRITE.   " Description ����� ���� ����..
      PERFORM P3000_ITEM_WRITE.     " Item ����� ���� ����..
      PERFORM P3000_ORIG_WRITE.     " ������ ���ޱⰣ ����� ���� ����..
      PERFORM P3000_OTHER_WRITE.    " ������ ������ ����� ���� ����..
      PERFORM P3000_ADD_WRITE.      " Additional Data ����� ���� ����..
   ENDLOOP.

ENDFORM.                    " P3000_WRITE_DATA

*&---------------------------------------------------------------------*
*&      Form  P3000_WRITE_AL_DATA
*&---------------------------------------------------------------------*
*       ���������� Data ����� ���� ����..
*----------------------------------------------------------------------*
FORM P3000_WRITE_AL_DATA.

   IF NOT IT_MLC-ZFALCP IS INITIAL AND NOT IT_MLC-ZFALCQ IS INITIAL.
      WRITE: '(' NO-GAP, IT_MLC-ZFALCP NO-GAP, '% ' NO-GAP.

      IF IT_MLC-ZFALCQ EQ 'T'.
        WRITE 'Plus/Minus' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ 'X'.
         WRITE 'Maximum' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ '2AA'.
         WRITE 'Up To' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ '2AB'.
         WRITE 'Not Exceeding' NO-GAP.
      ENDIF.
      WRITE ')' NO-GAP.
   ENDIF.

   IF NOT IT_MLC-ZFALCP IS INITIAL AND IT_MLC-ZFALCQ IS INITIAL.
      WRITE: '(' NO-GAP, IT_MLC-ZFALCP NO-GAP,
             '% ' NO-GAP, ')' NO-GAP.
   ENDIF.

   IF IT_MLC-ZFALCP IS INITIAL AND NOT IT_MLC-ZFALCQ IS INITIAL.
      WRITE '(' NO-GAP.

      IF IT_MLC-ZFALCQ EQ 'T'.
        WRITE 'Plus/Minus' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ 'X'.
         WRITE 'Maximum' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ '2AA'.
         WRITE 'Up To' NO-GAP.
      ELSEIF IT_MLC-ZFALCQ EQ '2AB'.
         WRITE 'Not Exceeding' NO-GAP.
      ENDIF.
      WRITE ')' NO-GAP.
   ENDIF.

ENDFORM.                    " P3000_WRITE_AL_DATA
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*       �����׷��� Ÿ��Ʋ�� ����ϱ� ���� �����ƾ.
*----------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

   SKIP.
   IF IT_MLC-ZFLCTY EQ '5'.          " '��Ұ���/�Ҵ�'�� �����Ϸ���..
      WRITE 50 '��ҺҴ�' NO-GAP.
   ELSE.
      WRITE 50 '��Ұ���' NO-GAP.
   ENDIF.

   WRITE: 'ȭȯ�ſ��� ���� ��û��' NO-GAP,
      /43 'APPLICATION FOR ' NO-GAP.

   IF IT_MLC-ZFLCTY EQ '5'.
      WRITE 'IRREVOCABLE ' NO-GAP.
   ELSE.
      WRITE 'IRREVOCABLE TRANSFER'.
   ENDIF.
   WRITE 'DOCUMENTARY CREDIT' NO-GAP.

   SKIP.
   WRITE: 'TO:' NO-GAP, IT_MLC-ZFOBNM NO-GAP,
        / 'HAVE REQUEST YOU TO ESTABLISH BY ' NO-GAP.

   IF IT_MLC-ZFOPME EQ 'DF'.        " ������� �����Ϸ���..
      WRITE 'Full Cable' NO-GAP.
   ELSEIF IT_MLC-ZFOPME EQ 'DG'.
      WRITE 'Short Cable' NO-GAP.
   ELSEIF IT_MLC-ZFOPME EQ 'DD'.
      WRITE 'Air Mail' NO-GAP.
   ENDIF.

   WRITE: 105 'DATE: ' NO-GAP, SY-DATUM.
   ULINE.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_HIGH_WRITE
*&---------------------------------------------------------------------*
*       ���α׷��� ���κ��� ����ϱ����� ����.
*----------------------------------------------------------------------*
FORM P3000_HIGH_WRITE.

   WRITE: / SY-VLINE NO-GAP, 'CREDIT NUMBER' NO-GAP,
         30 SY-VLINE NO-GAP, 120 SY-VLINE NO-GAP, SY-ULINE NO-GAP,
          / SY-VLINE NO-GAP, 'ADVISING BANK' NO-GAP,
         30 SY-VLINE NO-GAP, IT_MLC-ZFABNM NO-GAP,
        120 SY-VLINE NO-GAP.

*>>> �������� �������� ����ϱ� ���� ����..
   IF  NOT IT_MLC-ZFABBR IS INITIAL.
      WRITE:
          / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP, IT_MLC-ZFABBR NO-GAP,
        120 SY-VLINE NO-GAP.
   ENDIF.

*>>> Beneficiary(������) ���� Data ����� ���� ����..
   WRITE:   SY-ULINE NO-GAP,
          / SY-VLINE NO-GAP, 'BENEFICIARY' NO-GAP,
         30 SY-VLINE NO-GAP.

   IF NOT IT_MLC-ZFBENI1 IS INITIAL.
      WRITE: IT_MLC-ZFBENI1 NO-GAP.
   ENDIF.
   WRITE 120 SY-VLINE NO-GAP.

   IF NOT IT_MLC-ZFBENI2 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFBENI2 NO-GAP.
      IF NOT IT_MLC-ZFBENI3 IS INITIAL.
         WRITE: IT_MLC-ZFBENI3 NO-GAP.
      ENDIF.
      WRITE: 120 SY-VLINE NO-GAP.
   ENDIF.

   IF NOT IT_MLC-ZFBENI4 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFBENI4 NO-GAP.
      IF NOT IT_MLC-ZFBENIA IS INITIAL.
         WRITE: IT_MLC-ZFBENIA.
      ENDIF.
      WRITE: 120 SY-VLINE NO-GAP, SY-ULINE.
   ENDIF.

   WRITE: / SY-VLINE NO-GAP, 'APPLICANT' NO-GAP,
         30 SY-VLINE NO-GAP.

   IF NOT IT_MLC-ZFAPPNM IS INITIAL.
      WRITE: IT_MLC-ZFAPPNM NO-GAP.
   ENDIF.

   IF NOT IT_MLC-ZFAPPAD1 IS INITIAL.
      WRITE: IT_MLC-ZFAPPAD1 NO-GAP, 120 SY-VLINE NO-GAP.
   ENDIF.

   IF NOT IT_MLC-ZFAPPAD2 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFAPPAD2 NO-GAP, 120 SY-VLINE NO-GAP.
   ENDIF.

   IF NOT IT_MLC-ZFAPPAD3 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFAPPAD3 NO-GAP, 120 SY-VLINE NO-GAP.
   ENDIF.
   ULINE.

   WRITE: / SY-VLINE NO-GAP, 'AMOUNT' NO-GAP,
         30 SY-VLINE NO-GAP, IT_MLC-WAERS NO-GAP,
            IT_MLC-ZFOPAMT CURRENCY IT_MLC-WAERS.

   PERFORM P3000_WRITE_AL_DATA.

   WRITE: 120 SY-VLINE NO-GAP, SY-ULINE NO-GAP,
            / SY-VLINE NO-GAP, 'EXPIRY DATE' NO-GAP,
           30 SY-VLINE NO-GAP, IT_MLC-ZFEXDT(4) NO-GAP,
              '/' NO-GAP, IT_MLC-ZFEXDT+4(2) NO-GAP,
              '/' NO-GAP, IT_MLC-ZFEXDT+6(2) NO-GAP,
          120 SY-VLINE NO-GAP, SY-ULINE NO-GAP,
            / SY-VLINE NO-GAP, 'SHIPPING DATE' NO-GAP,
           30 SY-VLINE NO-GAP, IT_MLC-ZFLTSD(4) NO-GAP,
              '/' NO-GAP, IT_MLC-ZFLTSD+4(2) NO-GAP,
              '/' NO-GAP, IT_MLC-ZFLTSD+6(2) NO-GAP,
          120 SY-VLINE NO-GAP, SY-ULINE NO-GAP,
            / SY-VLINE NO-GAP, 'DRAFT`S TENOR' NO-GAP,
           30 SY-VLINE NO-GAP.

   IF NOT IT_MLC-ZFTRTX1 IS INITIAL.
      WRITE: IT_MLC-ZFTRTX1 NO-GAP.
   ENDIF.
   WRITE: 120 SY-VLINE NO-GAP.

   IF NOT IT_MLC-ZFTRTX2 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFTRTX2 NO-GAP, 120 SY-VLINE.
   ENDIF.

   IF NOT IT_MLC-ZFTRTX3 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFTRTX3 NO-GAP, 120 SY-VLINE.
   ENDIF.

   IF NOT IT_MLC-ZFTRTX4 IS INITIAL.
      WRITE: / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
               IT_MLC-ZFTRTX4 NO-GAP, 120 SY-VLINE.
   ENDIF.

   WRITE: SY-ULINE.
   WRITE: / SY-VLINE NO-GAP, 5 SY-VLINE NO-GAP,
           'USANCE L/C ONLY' NO-GAP, 50 SY-VLINE.

ENDFORM.                    " P3000_HIGH_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_USANCE_WRITE
*&---------------------------------------------------------------------*
*       USANCE ����� ���� ����..
*----------------------------------------------------------------------*
FORM P3000_USANCE_WRITE.

   IF IT_MLC-ZFUSAT EQ 'US'.
      WRITE 'SHIPPER`S' NO-GAP.
   ELSEIF IT_MLC-ZFUSAT EQ 'UB'.
      WRITE 'BANKER`S' NO-GAP.
   ENDIF.

   WRITE: 120 SY-VLINE NO-GAP, SY-ULINE.

ENDFORM.                    " P3000_USANCE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_DSCRTN_WRITE
*&---------------------------------------------------------------------*
*       Description ����� ���� ����..
*----------------------------------------------------------------------*
FORM P3000_DSCRTN_WRITE.

   IF IT_MLC-ZFOCEYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP,
              ' ��FULL SET OF CLEAN ON BOARD OCEAN BILLS OF ' NO-GAP,
              'LOADING MADE OUT TO THE ORDER OF ' NO-GAP,
               IT_MLC-ZFOCEC1 NO-GAP, 120 SY-VLINE NO-GAP,
             / SY-VLINE NO-GAP, '   ' NO-GAP,IT_MLC-ZFOCEC2 NO-GAP,
              ' MARKED FREIGHT ' NO-GAP.

*>>> Ocean Bill �������ҿ��� Check.
      IF IT_MLC-ZFOCEAC EQ '31'.
         WRITE 'Prepaid ' NO-GAP.
      ELSEIF IT_MLC-ZFOCEAC EQ '32'.
         WRITE 'Collect ' NO-GAP.
      ENDIF.
      WRITE: 'AND NOTIFY ' NO-GAP, IT_MLC-ZFOCEAN NO-GAP,
          120 SY-VLINE NO-GAP.
   ENDIF.

*>>> Commercial Invoice ÷�ο��� Check.
   IF IT_MLC-ZFCOMYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��INVOICE IN ' NO-GAP.
      IF IT_MLC-ZFNOCOM GE 10.
         WRITE: IT_MLC-ZFNOCOM NO-GAP, ' COPIES' NO-GAP.
      ELSEIF IT_MLC-ZFNOCOM LT 10.
         WRITE: IT_MLC-ZFNOCOM+1(1) NO-GAP, ' COPIES' NO-GAP.
      ENDIF.
      WRITE 120 SY-VLINE NO-GAP.
   ENDIF.

*>>> Air Bill ÷�ο��� Check.
   IF IT_MLC-ZFAIRYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��AIRWAY BILL CONSIGNED OT ' NO-GAP,
               IT_MLC-ZFAIRC1 NO-GAP, IT_MLC-ZFAIRC1 NO-GAP,
             / ' MARKED FREIGHT ' NO-GAP.
      IF IT_MLC-ZFAIRAC EQ '31'.
         WRITE 'PREPAID '.
      ELSE.
         WRITE 'COLLECT '.
      ENDIF.
      WRITE: 'AND NOTIFY ', IT_MLC-ZFAIRAN, 120 SY-VLINE.
   ENDIF.

*>>> �������� ÷�ο��� Check.
   IF IT_MLC-ZFINYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP,
               ' ��FULL SET OF INSURANCE POLICIES OR ' NO-GAP,
               'CERTIFICATES, ENDORDED IN BANK' NO-GAP,
           120 SY-VLINE NO-GAP,
             / SY-VLINE NO-GAP,
               '   FOR 110% OF INVOICE VALUE, EXPRESSLY' NO-GAP,
               ' STIPULATING THAT CLAIMS' NO-GAP,
           120 SY-VLINE NO-GAP,
             / SY-VLINE NO-GAP,
               '   ARE PAYABLE IN KOREA AND IT MUST INCLUDE' NO-GAP,
               ' : INSTITUTE CARGO CLAUSE' NO-GAP,
           120 SY-VLINE NO-GAP,
             / SY-VLINE NO-GAP, '  ', IT_MLC-ZFINCO1 NO-GAP,
           120 SY-VLINE NO-GAP,
             / SY-VLINE NO-GAP, '  ', IT_MLC-ZFINCO2 NO-GAP,
           120 SY-VLINE NO-GAP.
   ENDIF.

*>>> Packing List ÷�ο��� Check.
   IF IT_MLC-ZFPACYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��PACKING LIST IN ' NO-GAP.
      IF IT_MLC-ZFNOPAC GE 10.
         WRITE IT_MLC-ZFNOPAC NO-GAP.
      ELSEIF IT_MLC-ZFNOPAC LT 10.
         WRITE IT_MLC-ZFNOPAC+1(1) NO-GAP.
      ENDIF.
      WRITE: ' Copies ' NO-GAP, 120 SY-VLINE.
   ENDIF.

*>>> ���������� ÷�ο��� Check.
   IF IT_MLC-ZFCEOYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��CERTIFICATE OF ORIGIN' NO-GAP,
           120 SY-VLINE NO-GAP.
   ENDIF.

*>>> ��Ÿ���񼭷�÷�ο��� Check.
   IF IT_MLC-ZFOTDYN EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��OTHER DOCUMENT(S) [if any]' NO-GAP,
           120 SY-VLINE NO-GAP.

      SORT IT_SG8E BY ZFLSG8E.

      LOOP AT IT_SG8E WHERE ZFREQNO = IT_MLC-ZFREQNO.
         WRITE: / SY-VLINE NO-GAP, '   ' NO-GAP,
                  IT_SG8E-ZFOACD1 NO-GAP, 120 SY-VLINE NO-GAP.
      ENDLOOP.

   ENDIF.

ENDFORM.                    " P3000_DSCRTN_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_ITEM_WRITE
*&---------------------------------------------------------------------*
*       Item Description ����� ���� ����...
*----------------------------------------------------------------------*
FORM P3000_ITEM_WRITE.

   WRITE: / SY-VLINE NO-GAP, 3 SY-ULINE(116) NO-GAP,
        120 SY-VLINE NO-GAP,
          / SY-VLINE NO-GAP, 3 SY-VLINE NO-GAP, 'HS CODE' NO-GAP,
         18 SY-VLINE NO-GAP, 'DESCRIPTION' NO-GAP,
         54 SY-VLINE NO-GAP, 'QUANTITY' NO-GAP,
         75 SY-VLINE NO-GAP, 'UNIT PRICE' NO-GAP,
         98 SY-VLINE NO-GAP, 'AMOUNT' NO-GAP,
        118 SY-VLINE NO-GAP, 120 SY-VLINE NO-GAP,
          / SY-VLINE NO-GAP, 3 SY-ULINE(116) NO-GAP,
        120 SY-VLINE NO-GAP.

   LOOP AT IT_RN WHERE ZFREQNO = IT_MLC-ZFREQNO.

      IF IT_RN-PEINH EQ 1.
         TEMP = IT_RN-MENGE * IT_RN-NETPR.
      ELSE.
         TEMP = ( IT_RN-MENGE * IT_RN-NETPR ) / IT_RN-PEINH.
      ENDIF.

      NETPR(8) = IT_RN-NETPR.
      WRITE: / SY-VLINE NO-GAP, 3 SY-VLINE NO-GAP, IT_RN-STAWN NO-GAP,
            18 SY-VLINE NO-GAP, IT_RN-TXZ01,
            54 SY-VLINE NO-GAP,
               IT_RN-MENGE UNIT IT_RN-MEINS NO-GAP, IT_RN-MEINS NO-GAP,
            75 SY-VLINE NO-GAP, IT_MLC-WAERS NO-GAP,
               NETPR(8) CURRENCY IT_RN-WAERS NO-GAP.
*            IT_RN-NETPR CURRENCY IT_RN-WAERS NO-GAP.

      IF IT_RN-PEINH EQ 1.
         WRITE: '/' NO-GAP, IT_RN-BPRME NO-GAP.
      ELSE.
         WRITE: '/' NO-GAP, IT_RN-PEINH NO-GAP,
                IT_RN-BPRME NO-GAP.
      ENDIF.

      WRITE: 98 SY-VLINE NO-GAP, IT_MLC-WAERS NO-GAP, TEMP NO-GAP,
            118 SY-VLINE NO-GAP, 120 SY-VLINE,
              / SY-VLINE NO-GAP, 3 SY-VLINE NO-GAP,
             18 SY-VLINE NO-GAP,
             54 SY-VLINE NO-GAP.

      PERFORM P3000_WRITE_AL_DATA.
      WRITE:  75 SY-VLINE NO-GAP, 98 SY-VLINE NO-GAP.

      PERFORM P3000_WRITE_AL_DATA.
      WRITE: 118 SY-VLINE NO-GAP, 120 SY-VLINE NO-GAP.

   ENDLOOP.

   WRITE: / SY-VLINE NO-GAP, 3 SY-ULINE(116),
        120 SY-VLINE NO-GAP, SY-ULINE.

ENDFORM.                    " P3000_ITEM_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_ORIG_WRITE
*&---------------------------------------------------------------------*
*       �������� PRICE TERM�� ����ϱ����� Logic.
*----------------------------------------------------------------------*
FORM P3000_ORIG_WRITE.

   WRITE: / SY-VLINE NO-GAP, 'PRICE TERM' NO-GAP,
         25 SY-VLINE NO-GAP, IT_MLC-INCO1 NO-GAP,
         59 SY-VLINE NO-GAP, 'COUNTRY OF ORIGIN' NO-GAP,
         89 SY-VLINE NO-GAP.

   READ TABLE IT_SG7O WITH KEY ZFREQNO  = IT_MLC-ZFREQNO
                               ZFLSG7O  = '00010'.

   READ TABLE IT_T005T WITH KEY LAND1 = IT_SG7O-ZFORIG.
   WRITE: IT_T005T-LANDX NO-GAP.

   WRITE: 120 SY-VLINE NO-GAP, SY-ULINE,
            / SY-VLINE NO-GAP,
             'DESCRIPTION OF GOODS / SERVICE :' NO-GAP,
          120 SY-VLINE NO-GAP.
   LOOP AT IT_SG7G.
      WRITE: / SY-VLINE NO-GAP, 34 IT_SG7G-ZFDSOG1 NO-GAP,
           120 SY-VLINE NO-GAP.
   ENDLOOP.
   WRITE: SY-ULINE.

ENDFORM.                    " P3000_ORIG_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_OTHER_WRITE
*&---------------------------------------------------------------------*
*       ������ ������ ����� ���� ����..
*----------------------------------------------------------------------*
FORM P3000_OTHER_WRITE.

*>>> SHIPMENT ����� �����͸� ����ϱ����� ����..
   WRITE: / SY-VLINE NO-GAP, 'SHIPMENT' NO-GAP,
         30 SY-VLINE NO-GAP, 'FROM' NO-GAP,
         45 SY-VLINE NO-GAP, IT_RN-ZFSPRT NO-GAP,
        120 SY-VLINE NO-GAP,
          / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
         30 SY-ULINE, 120 SY-VLINE NO-GAP,
          / SY-VLINE NO-GAP, 30 SY-VLINE NO-GAP,
            'TO' NO-GAP, 45 SY-VLINE NO-GAP,
            IT_RN-ZFAPRT NO-GAP, 120 SY-VLINE NO-GAP, SY-ULINE.

*>>> ���Ҽ���, ȯ�����θ� ����ϱ����� ����...
   WRITE:  SY-VLINE NO-GAP, 'PARTIAL SHIPMENT :' NO-GAP.

      IF IT_MLC-ZFPRMT EQ 10.
         WRITE: 'PROHIBITED' NO-GAP.
      ELSE.
         WRITE: 'ALLOWED' NO-GAP.
      ENDIF.

   WRITE: 59 SY-VLINE NO-GAP, 'TRANSHIPMENT :' NO-GAP.

      IF IT_MLC-ZFTRMT EQ 8.
         WRITE: 'PROHIBITED' NO-GAP.
      ELSE.
         WRITE: 'ALLOWED' NO-GAP.
      ENDIF.

   WRITE: 120 SY-VLINE NO-GAP, SY-ULINE.

ENDFORM.                    " P3000_OTHER_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_ADD_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM P3000_ADD_WRITE.

*>>> ADDITIONAL CONDITION ����� ���� ����...
   WRITE: / SY-VLINE NO-GAP, 'ADDITIONAL CONDITION :' NO-GAP,
        120 SY-VLINE NO-GAP.
   WRITE: / SY-VLINE NO-GAP, 120 SY-VLINE.

   IF IT_MLC-ZFADCD1 EQ 'X'.
      WRITE: / SY-VLINE NO-GAP, ' ��SHIPMENT BY' NO-GAP,
               IT_MLC-ZFCARR, 120 SY-VLINE NO-GAP.
   ENDIF.

   IF IT_MLC-ZFADCD2 EQ 'X'.
      WRITE: / SY-VLINE NO-GAP,
               ' ��ACCEPTANCE COMMISSION AND DISCOUNT ' NO-GAP,
               'CHARGES ARE FOR BUYER`S ACCOUNT' NO-GAP,
           120 SY-VLINE.
   ENDIF.

   IF IT_MLC-ZFADCD3 EQ 'X'.
     WRITE: / SY-VLINE NO-GAP,
              ' ��ALL DOCUMENT MUST BEAR OUR CREDIT NUMBER' NO-GAP,
          120 SY-VLINE.
   ENDIF.

   IF IT_MLC-ZFADCD4 EQ 'X'.
      WRITE: / SY-VLINE NO-GAP,
              ' ��LATE PRESENTATION B/L ACCEPTANCE.' NO-GAP,
           120 SY-VLINE.
   ENDIF.

   IF IT_MLC-ZFADCD5 EQ 'X'.
*         READ TABLE IT_SG9O WITH KEY ZFREQNO = IT_MLC-ZFREQNO.
      SORT IT_SG9O BY ZFLSG9O.
      WRITE: / SY-VLINE NO-GAP,
             ' ��Other Additional Conditions [If Any]' NO-GAP,
           120 SY-VLINE.
      LOOP AT IT_SG9O WHERE ZFREQNO = IT_MLC-ZFREQNO.
         WRITE: / SY-VLINE NO-GAP, '   ' NO-GAP,
                  IT_SG9O-ZFODOC1 NO-GAP,
              120 SY-VLINE NO-GAP.
      ENDLOOP.
   ENDIF.
      ULINE.

ENDFORM.                    " P3000_ADD_WRITE
