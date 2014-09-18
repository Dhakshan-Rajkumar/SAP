FUNCTION ZIM_SET_MATERIAL_GUBUN.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(ZZBUSTYPE)
*"  EXPORTING
*"     REFERENCE(ZFMATGB) LIKE  ZTREQHD-ZFMATGB
*"----------------------------------------------------------------------

  CASE ZZBUSTYPE.
     WHEN 'B '.   ZFMATGB = '1'.     " �����������
*     WHEN 'D '.   ZFMATGB = '2'.     " ���ڱ��� ( NOT USED )
     WHEN 'D '.   CLEAR : ZFMATGB.    " ���ڱ��� ( NOT USED )
     WHEN 'E '.   ZFMATGB =  1.      " ����� ������
     WHEN 'L '.   ZFMATGB = '2'.     " ��Į
     WHEN 'N '.   ZFMATGB = '3'.     " ������ ����
     WHEN 'R '.   ZFMATGB = '3'.     " �����ҿ� ����
     WHEN 'F '.   ZFMATGB = '4'.     " �ü���
     WHEN 'C '.   ZFMATGB = '5'.     " ��ǰ
     WHEN 'M '.   ZFMATGB = '5'.     " �߰蹫��
     WHEN 'X '.   ZFMATGB = '5'.     " �ﰢ����
     WHEN OTHERS. CLEAR : ZFMATGB.   " ��Ÿ
  ENDCASE.

ENDFUNCTION.
