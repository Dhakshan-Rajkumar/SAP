*----------------------------------------------------------------------*
*   INCLUDE ZRIMTCHGLSTTOP                                             *
*----------------------------------------------------------------------*
tables : ztreqhd,         " �����Ƿ� Header..
         ztreqit,         " �����Ƿ� Item..
         ztreqst,         " �����Ƿ� Status..
         ztpmthd,         " Payment Notice Header..
         ztpmtiv,         " Payment Notice Invoice..
         ztblinr,         " ���ԽŰ�..
         ztids,           " ���Ը���..
         ztcucliv,        " ��� Invoice..
         dd03d,           " Dynpro fields for table fields..
         t024e,           " ��������..
         t024,            " ���ű׷�..
         lfa1,            " ����ó������ (�Ϲݼ���)..
         tinc,            " ��: �ε�����..
         ekpo,            " Purchasing Document Item..
         zvreqhd_st,      " �����Ƿ� Header + Status View..
         zvekko_reqhd_st, " EKKO + �����Ƿ� Header + Status View..
         ztoff,           " Offer Sheet..
         ztoffftx,        " Offer Sheet FTX..
         ztimimgtx,       " EDI Text..
         ztdhf1,          " ǥ�� EDI Flat Head..
         ztcdf1,          " ���ڹ�����ȣ ä��(EDI)..
         ztimimg03,       " �������� �ڵ�..
         ztimimg00,       " ���Խý��� Basic Config..
         ztbkpf,          " ���Ժ�빮�� Header..
         ztbseg.          " ���Ժ�빮�� Item..

*----------------------------------------------------------------------*
* Internal Table Select.
*----------------------------------------------------------------------*
data  it_zvreq      like zvreqhd_st occurs 0  with header line.
data  it_bkpf       like ztbkpf     occurs 0  with header line.
data: begin of      it_tab occurs 0,
        name1         like lfa1-name1,
        zfopndt       like ztreqst-zfopndt,
        zfamdno       like ztreqst-zfamdno,
        zfpnam        like ztpmthd-zfpnam,
        zfpnamc       like ztpmthd-zfpnamc,
        zfpwdt        like ztpmthd-zfpwdt,
*        zftcedt       like ztbseg-zftcedt,               "NCW ����
        period1       type i,
        period2       type i.
        include  structure ztreqhd.
data: end of        it_tab.

data: w_list_index      like sy-tabix.
data: w_lfa1            like lfa1,
      w_adrc            like adrc,
      g_param_line      type i.
data: w_page            type i.             " Page Counter
data: w_err_chk(1)      type c,
      cancel_option     type c,
      w_rowmark         type c,
      option(1)         type c,
      f(20)             type c,             " Field Name Alias
      w_count           type i,             " ��ü COUNT
      w_line            type i,             " �������� LINE COUNT
      w_update_cnt      type i,
      line              type i,
      textlen           type i,
      w_button_answer   type c,
      w_gubun           type c,
      antwort           type c,
      w_item_cnt        like sy-tabix,          " ǰ�� count
      w_max_zfamdno     like ztreqst-zfamdno,
      w_yn1             like ztimimg00-zfrelyn1,
      w_yn2             like ztimimg00-zfrelyn1,
      g_parm_line       like sy-tabix,
      w_tabix           like sy-tabix,
      w_field_nm        like dd03d-fieldname,   " �ʵ�?
      w_reqno           like ztreqhd-zfreqno,
*> 2001.06.18 KSB INSERT START
      w_subrc           like sy-subrc,
*> 2001.06.18 KSB INSERT END.
      w_looplines       like sy-loopc,
      w_counter1        like sy-loopc,
      w_counter         like sy-loopc,
      ok-code           like sy-ucomm,
      w_ok_code         like sy-ucomm.

data: g_repid like sy-repid.
data: g_layout          type slis_layout_alv.
data: g_status          type slis_formname value 'P2000_ALV_PF_STATUS'.
data: gt_fieldcat       type slis_t_fieldcat_alv.
data: ls_fieldcat       type slis_fieldcat_alv.
data: pos               type i.
data: g_save(1)         type c.
data: g_variant         like disvariant.
data: g_user_command    type slis_formname value 'P2000_ALV_COMMAND'.
