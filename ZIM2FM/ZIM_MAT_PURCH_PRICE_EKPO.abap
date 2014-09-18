FUNCTION ZIM_MAT_PURCH_PRICE_EKPO.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(IP_WERKS) LIKE  MARC-WERKS
*"     VALUE(IP_MATNR) LIKE  MARA-MATNR
*"     VALUE(IP_EKORG) LIKE  EORD-EKORG
*"     VALUE(IP_LIFNR) LIKE  EKKO-LIFNR OPTIONAL
*"     VALUE(IP_GUBUN) LIKE  EKKO-ABGRU
*"     VALUE(IP_BEDAT) LIKE  EKKO-BEDAT DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(EP_LIFNR) LIKE  EKKO-LIFNR
*"     VALUE(EP_WAERS) LIKE  EKKO-WAERS
*"     VALUE(EP_PRICE) LIKE  EKPO-NETPR
*"     VALUE(EP_PEINH) LIKE  EKPO-PEINH
*"     VALUE(EP_KTMNG) LIKE  EKPO-KTMNG
*"     VALUE(EP_IDNLF) LIKE  EKPO-IDNLF
*"     VALUE(EP_BEDAT) LIKE  EKKO-BEDAT
*"     VALUE(EP_BPRME) LIKE  EKPO-BPRME
*"----------------------------------------------------------------------

*-----------------------------------------------------------------------
*  [ �� �� �� �� ]
*   - 1999/10/11 ������ �߰�
*   - �÷�Ʈ ���Է½� ��ü �÷�Ʈ�� ã�� ���� ( �ֱ� ���Ŵܰ� ���� )
*-----------------------------------------------------------------------
*  [ �� �� �� �� ]
*   - 1999/11/09 ������ �߰�
*   - �ֱٱ��Ŵܰ� ����� ����� ����ָ� �˻��ϴ� ������
*     ����� ���޾�ü�� �˻��ϴ� �������� ����
*-----------------------------------------------------------------------

    IF  IP_GUBUN  = 'CF'.             "<ZMMP_POC11;�ֱٱ��Ŵܰ� ����.
        PERFORM  PRICE_UNIT_SELECT_PO USING
                       IP_WERKS IP_MATNR IP_EKORG IP_BEDAT IP_LIFNR
                       EP_LIFNR  EP_WAERS
                       EP_PRICE  EP_PEINH
                       EP_KTMNG  EP_IDNLF
                       EP_BEDAT  EP_BPRME.
    ELSEIF  IP_GUBUN  = 'GR'.         "<ZMMP_POC11;�ֱ��԰�ܰ� ����.
        PERFORM  PRICE_UNIT_SELECT_GR USING
                       IP_WERKS IP_MATNR IP_EKORG IP_BEDAT
                       EP_LIFNR  EP_WAERS
                       EP_PRICE  EP_PEINH
                       EP_KTMNG  EP_IDNLF
                       EP_BEDAT.
    ELSEIF  IP_GUBUN  = 'IF'.         "<ZMMP_IVG08;���籸��ǰ�Ǽ�
        PERFORM  PRICE_UNIT_SELECT_INFO USING
                       IP_WERKS IP_MATNR IP_EKORG IP_LIFNR
                       EP_LIFNR  EP_WAERS
                       EP_PRICE  EP_PEINH
                       EP_KTMNG.
    ELSEIF  IP_GUBUN  = 'BF'.         "<ZMMP_IVG08
        PERFORM  PRICE_UNIT_SELECT_BFPO USING
                       IP_WERKS IP_MATNR IP_EKORG IP_LIFNR
                       EP_LIFNR  EP_WAERS
                       EP_PRICE  EP_PEINH
                       EP_KTMNG.
    ELSE.                             "<��ü�������ȿ�ܰ�
        PERFORM  PRICE_UNIT_SELECT USING
                       IP_WERKS IP_MATNR IP_EKORG
                       EP_LIFNR  EP_WAERS
                       EP_PRICE  EP_PEINH.
                      "ep_ktmng.
    ENDIF.

ENDFUNCTION.
*
