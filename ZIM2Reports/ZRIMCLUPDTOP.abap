*----------------------------------------------------------------------*
*   INCLUDE ZRIMCLUPDTOP                                               *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���Ը��� �ڷ��� Upload�� ���� Include                 *
*&      �ۼ��� : �迬�� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2000.04.12                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
TABLES : ZTIDS,           " ���Ը�?
         ZTIDSHS,         " ���Ը��� ����?
         ZTIDSHSD,        " ���Ը��� �԰�(��)��?
         ZTIDSHSL,        " ���Ը��� ���Ȯ?
         ZTIDRCR,         " ���԰�?
         ZTIDRCRIT,       " �����㰡ǰ?
         ZTCUCL,          " ��?
         ZTCUCLCST,       " �����?
         ZTCUCLIV,        " ��� Invoice
         ZTIDR,           " ���Խ�?
         ZTIV,            " Invoice
         ZTIVIT,          " Invoice Item
         ZTBL,            " Bill Of Lading
         ZTBLOUR,         " B/L �����?
         ZTBLINR,         " B/L ���Խ�?
         ZTIMIMG02,       " ������?
         ZTIMIMG06,       " ����û ���ȯ?
         ZTIMIMG07,       " ���������?
         ZTIMIMG10,       " ��������?
         LFA1,            " Vendor
         SPOP.     " POPUP_TO_CONFIRM_... function ��� �˾�ȭ�� ��?
*-----------------------------------------------------------------------
* Upload ?
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_ZTIDS OCCURS 0,
      ZFIDRNO(14)         TYPE C,                " ���ԽŰ��?
      ZFIDWDT(8)          TYPE C,                " ���ԽŰ����?
      ZFINAMTC(3)         TYPE C,                " ����� ��?
      ZFINAMT(17)         TYPE C,                " ����?
      ZFINAMTS(17)        TYPE C,                " �Ѻ���?
      ZFTFAC(3)           TYPE C,                " ���� A ��?
      ZFTFA(17)           TYPE C,                " ���� A
      ZFTFBC(3)           TYPE C,                " ���� B ��?
      ZFTFB(17)           TYPE C,                " ���� B
      ZFTRT(17)           TYPE C,                " �ѿ�?
      ZFADAMC(5)          TYPE C,                " ����ݱ�?
      ZFADAMCU(3)         TYPE C,                " ����� ��?
      ZFADAM(17)          TYPE C,                " �����?
      ZFADAMK(17)         TYPE C,                " ����ݾ�(��ȭ)
      ZFDUAMC(5)          TYPE C,                " �����ݱ�?
      ZFDUAMCU(3)         TYPE C,                " ������ ��?
      ZFDUAM(17)          TYPE C,                " ������?
      ZFDUAMK(17)         TYPE C,                " �����ݾ�(��ȭ)
      ZFPONC(2)           TYPE C,                " ���԰ŷ���?
      ZFITKD(1)           TYPE C,                " ���ԽŰ���?
      ZFINRC(3)           TYPE C,                " �Ű��� ��?
      ZFINRCD(2)          TYPE C,                " ������ ��� ����?
      ZFAPRTC(4)          TYPE C,                " ��������?
      ZFSCON(2)           TYPE C,                " ����?
      ZFISPL(18)          TYPE C,                " �˻���� ��ġ�� ��?
      ZFENDT(8)           TYPE C,                " ����?
      ZFINDT(8)           TYPE C,                " ����?
      ZFIMCD(1)           TYPE C,                " �����ڱ�?
      ZFIDRCD(1)          TYPE C,                " �Ű�?
      ZFAMCD(2)           TYPE C,                " ��ݰ�����?
      ZFCTW(3)            TYPE C,                " ������ �����?
      ZFCOCD(2)           TYPE C,                " ����¡����?
      ZFCUPR(1)           TYPE C,                " �����ȹ��?
      ZFTRCN(3)           TYPE C,                " ��ۿ�?
      ZFHBLNO(20)         TYPE C,                " House B/L No
      ZFGOMNO(18)         TYPE C,                " ȭ��������?
      ZFIMCR(20)          TYPE C,                " ������ü ������?
      ZFTRMET(2)          TYPE C,                " ��ۼ�?
      ZFCARNM(20)         TYPE C,                " ����?
      ZFCAC(2)            TYPE C,                " ���ⱹ?
      ZFAPNM(28)          TYPE C,                " �Ű��ڻ�?
      ZFAPNO(8)           TYPE C,                " ������ ��������Ϲ�?
      ZFIAPNM(28)         TYPE C,                " �����ڻ�?
      ZFTDNO(15)          TYPE C,                " ������ ���������?
      ZFTDNM1(28)         TYPE C,                " ������ ��?
      ZFTDNM2(12)         TYPE C,                " ������ ��?
      ZFTDAD1(20)         TYPE C,                " ������ �ּ� 1
      ZFTDAD2(20)         TYPE C,                " ������ �ּ� 2
      ZFTDTC(13)          TYPE C,                " ������ ����ڵ�Ϲ�?
      ZFTRDNO(7)          TYPE C,                " �����븮�� ��?
      ZFTRDNM(28)         TYPE C,                " �����븮�� ��?
      ZFSUPNO(10)         TYPE C,                " �����ں�?
      ZFSUPNM(26)         TYPE C,                " �����ڻ�?
      ZFSUPC(2)           TYPE C,                " ������ ������?
      ZFSTRCD(2)          TYPE C,                " Ư�۾�ü��?
      INCO1(3)            TYPE C,                " Incoterms (part 1)
      ZFSTAMT(12)         TYPE C,                " ������?
      ZFSTAMC(3)          TYPE C,                " �����ݾ���?
      ZFPKCNT(8)          TYPE C,                " �����尳?
      ZFPKNM(2)           TYPE C,                " ������?
      ZFTOWT(10)          TYPE C,                " ����?
      ZFTOWTMM(2)         TYPE C,                " ���߷���?
      ZFCUAMTS(12)        TYPE C,                " �Ѱ�?
      ZFSCAMTS(12)        TYPE C,                " ��Ư��?
      ZFDRAMTS(12)        TYPE C,                " ����?
      ZFTRAMTS(12)        TYPE C,                " �ѱ���?
      ZFEDAMTS(12)        TYPE C,                " �ѱ���?
      ZFAGAMTS(12)        TYPE C,                " �ѳ�Ư?
      ZFVAAMTS(12)        TYPE C,                " �Ѻΰ�?
      ZFIDAMTS(12)        TYPE C,                " �ѽŰ����� ����?
      ZFTXAMTS(12)        TYPE C,                " �Ѽ�?
      ZFTBAK(12)          TYPE C,                " ��������-��?
      ZFTBAU(12)          TYPE C,                " ��������-��?
      ZFCTW1(60)          TYPE C,                " ������ ����� 1
      ZFCTW2(60)          TYPE C,                " ������ ����� 2
      ZFCTW3(60)          TYPE C,                " ������ ����� 3
      ZFCTW4(60)          TYPE C,                " ������ ����� 4
      ZFCTW5(60)          TYPE C,                " ������ ����� 5
      ZFIDSDT(8)          TYPE C,                " �Ű����?
      ZFCR_LF(1)          TYPE C,
END OF IT_ZTIDS.

DATA: BEGIN OF IT_ZTIDSHS OCCURS 0,
      ZFIDRNO(14)         TYPE C,                " ���ԽŰ��?
      ZFCONO(3)           TYPE C,                " ����?
      ZFCURT(6)           TYPE C,                " ����?
      ZFTXPER(10)         TYPE C,                " ������ ��?
      ZFHSAM(17)          TYPE C,                " ���Ű��?
      STAWN(10)           TYPE C,                " Commodity code / Impo
      ZFGDNM(50)          TYPE C,                " ǰ?
      ZFTGDNM(50)         TYPE C,                " �ŷ�ǰ?
      ZFGCNM(50)          TYPE C,                " ��ǥǰ?
      ZFGCCD(50)          TYPE C,                " ��ǥ��?
      ZFORIG(2)           TYPE C,                " Material's country of
      ZFWETM(2)           TYPE C,                " �߷���?
      ZFWET(10)           TYPE C,                " ��?
      ZFQNTM(2)           TYPE C,                " ������?
      ZFQNT(10)           TYPE C,                " ��?
      ZFORYN(1)           TYPE C,                " ������ ǥ����?
      ZFORME(1)           TYPE C,                " ������ ǥ�ù�?
      ZFORTY(1)           TYPE C,                " ������ ǥ����?
      ZFSTCS(1)           TYPE C,                " Ư�۾�üC/S
      ZFTXCD(2)           TYPE C,                " ������?
      ZFRDRT(6)           TYPE C,                " ��������?
      ZFTXAMCD(1)         TYPE C,                " �����ױ�?
      ZFCDPCD(3)          TYPE C,                " ��������/�г���?
      ZFCDPNO(12)         TYPE C,                " ��������/�г���?
      ZFCUAMT(12)         TYPE C,                " ��?
      ZFCCAMT(12)         TYPE C,                " ��������?
      ZFHMTCD(2)          TYPE C,                " ��������?
      ZFHMTRT(6)          TYPE C,                " ������?
      ZFHMTTY(6)          TYPE C,                " ������ ������?
      ZFHMAMT(12)         TYPE C,                " ����?
      ZFHCAMT(12)         TYPE C,                " ������ ����?
      ZFSCCD(7)           TYPE C,                " Ư�Ҽ� �鼼��?
      ZFETXCD(1)          TYPE C,                " ������ ��?
      ZFEDAMT(12)         TYPE C,                " ����?
      ZFECAMT(12)         TYPE C,                " ������ ����?
      ZFATXCD(1)          TYPE C,                " ��Ư�� ��?
      ZFAGAMT(12)         TYPE C,                " ��Ư?
      ZFVTXCD(1)          TYPE C,                " �ΰ��� ��?
      ZFVTXTY(7)          TYPE C,                " �ΰ��� �����?
      ZFVAAMT(12)         TYPE C,                " �ΰ�?
      ZFVCAMT(12)         TYPE C,                " �ΰ��� ����?
      ZFSCCS(8)           TYPE C,                " Ư������ ����?
      ZFMOR1(3)           TYPE C,                " ����Ȯ�α��1
      ZFMOR2(3)           TYPE C,                " ����Ȯ�α��2
      ZFMOR3(3)           TYPE C,                " ����Ȯ�α��3
      ZFREQN(13)          TYPE C,                " ȯ�޹�?
      ZFREQNM(2)          TYPE C,                " ȯ�޹��� ��?
      ZFTBAK(12)          TYPE C,                " ��������-��?
      ZFTBAU(12)          TYPE C,                " ��������-��?
      ZFCR_LF(1)          TYPE C,
END OF IT_ZTIDSHS.

DATA: BEGIN OF IT_ZTIDSHSD OCCURS 0,
      ZFIDRNO(14)         TYPE C,                " ���ԽŰ��?
      ZFCONO(3)           TYPE C,                " ����?
      ZFRONO(3)           TYPE C,                " �԰�(��)��?
      ZFSTCD(30)          TYPE C,                " �԰���?
      ZFGDDS1(30)         TYPE C,                " �԰�1
      ZFGDDS2(30)         TYPE C,                " �԰�2
      ZFGDDS3(30)         TYPE C,                " �԰�3
      ZFGDIN1(25)         TYPE C,                " ����1
      ZFGDIN2(25)         TYPE C,                " ����2
      ZFQNT(15)           TYPE C,                " ��?
      ZFQNTM(3)           TYPE C,                " ������?
      NETPR(16)           TYPE C,                " Net price
      ZFAMT(15)           TYPE C,                " ��?
      ZFCR_LF(1)          TYPE C,
END OF IT_ZTIDSHSD.

DATA: BEGIN OF IT_ZTIDSHSL OCCURS 0,
      ZFIDRNO(14)         TYPE C,                " ���ԽŰ��?
      ZFCONO(3)           TYPE C,                " ����?
      ZFCNDC(3)           TYPE C,                " ���Ȯ�α�?
      ZFCNNO(20)          TYPE C,                " ��ǹ�?
      ZFLACD(2)           TYPE C,                " ������?
      ZFISZDT(8)          TYPE C,                " �߱�?
      ZFCUQN(10)          TYPE C,                " �������?
      ZFCUQNM(3)          TYPE C,                " �����������?
      ZFCR_LF(1)          TYPE C,
END OF IT_ZTIDSHSL.

DATA   W_ZFBTSEQ         LIKE ZTBLINR-ZFBTSEQ.

DATA : W_PROC_CNT        TYPE I,             " ó����?
       OPTION(1)         TYPE C,
       ANTWORT(1)        TYPE C,
       CANCEL_OPTION     TYPE C,
       TEXTLEN           TYPE I,
       DIGITS            TYPE I VALUE 20,
       W_ZFAPLDT         LIKE ZTIMIMG06-ZFAPLDT,
       W_ZFCAMT          LIKE ZTCUCLCST-ZFCAMT,
       W_TMP(1)          TYPE N,
       W_ZFCSQ           LIKE ZTCUCLCST-ZFCSQ,
       W_ZFIVAMT         LIKE BAPICURR-BAPICURR,
       W_ZFTBAK          LIKE BAPICURR-BAPICURR,
       W_DATE            LIKE SY-DATUM.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,             " ���� LINE COUNT
       W_PAGE            TYPE I,             " Page Counter
       W_LINE            TYPE I,             " �������� LINE COUNT
       W_COUNT           TYPE I,             " ��ü COUNT
       W_LIST_INDEX      LIKE SY-TABIX,
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " �ʵ�?
       W_TABIX           LIKE SY-TABIX,      " TABLE INDEX
       W_UPDATE_CNT      TYPE I,
       W_BUTTON_ANSWER   TYPE C.
