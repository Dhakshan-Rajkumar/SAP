*----------------------------------------------------------------------*
*   INCLUDE ZAPM09_CLASS_IMPLEMENTATION                                *
*----------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS lcl_application IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS LCL_APPLICATION IMPLEMENTATION.
*---------------------------------------------------------------------*
*       METHOD HANDLE_NODE_DOUBLE_CLICK
*---------------------------------------------------------------------*
*                                                             *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_DOUBLE_CLICK.
    DATA: WA_ACCUM_NODE_ITAB   TYPE NODE_STR,
          WA_ACCUM_NODE_ITAB_2 TYPE NODE_STR.

    CLEAR : WA_INIT_FLG, WA_NODE_KEY.

    WA_NODE_KEY = NODE_KEY.
    WA_TMP_NODE_KEY = WA_NODE_KEY.

    PERFORM CHECK_NODE_N_NODE_BACK.

    PERFORM CHK_AND_CHANGE_NODE USING WA_NODE_KEY.

    IF WA_NODE_KEY NE WA_FIRST_ROOT.
      IF NOT EQUI_TREE IS INITIAL.
        PERFORM FREE_EQUI_TREE.
      ENDIF.
      IF WA_TOGGLE EQ 'MHRC'.
        CLEAR : WA_ACCUM_NODE_ITAB.
        READ TABLE ACCUM_NODE_ITAB WITH KEY NODE_KEY = WA_TMP_NODE_KEY
                                   INTO WA_ACCUM_NODE_ITAB
                                   TRANSPORTING ISFOLDER.
        IF SY-SUBRC EQ 0.
          IF WA_ACCUM_NODE_ITAB-ISFOLDER EQ 'X'.
            PERFORM CREATE_PICTURE_OBJECT USING WA_NODE_KEY.
          ELSE.
            PERFORM CREATE_PICTURE_OBJECT USING WA_NODE_KEY.
            CLEAR WA_LAST_TPLNR.
            WA_LAST_TPLNR = WA_NODE_KEY.
            PERFORM CREATE_EQUI_TREE_OBJECT USING WA_NODE_KEY.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    WA_INIT_FLG = 'X'.
  ENDMETHOD.

*---------------------------------------------------------------------*
*       METHOD HANDLE_NODE_CONTEXT_MENU_REQ
*---------------------------------------------------------------------*
*       START                                                         *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_CONTEXT_MENU_REQ.
    CHECK WA_TOGGLE EQ 'MHRC'.
    CHECK NODE_KEY+0(4) NE WA_FIRST_ROOT.

    CLEAR WA_CUR_CXT_MENU.
    CLEAR WA_NODE_KEY.

    WA_NODE_KEY = NODE_KEY.

    PERFORM CHECK_NODE_N_NODE_BACK.

    PERFORM CHK_AND_CHANGE_NODE USING WA_NODE_KEY.

    READ TABLE IT_T001 WITH KEY BUKRS = WA_NODE_KEY
                       TRANSPORTING NO FIELDS.
    CHECK SY-SUBRC NE 0.
    REFRESH IT_PFTAB.
    CLEAR WA_SIZE_OF_KEY.
    WA_SIZE_OF_KEY = STRLEN( WA_NODE_KEY ).

    IF WA_SIZE_OF_KEY LT 5.
      CLEAR WA_FCODE.
      MOVE 'UPLD' TO WA_FCODE.
      APPEND WA_FCODE TO IT_PFTAB.

      CLEAR WA_FCODE.
      MOVE 'DELE' TO WA_FCODE.
      APPEND WA_FCODE TO IT_PFTAB.

      CLEAR WA_FCODE.
      MOVE 'DISP' TO WA_FCODE.
      APPEND WA_FCODE TO IT_PFTAB.
    ENDIF.

    PERFORM HANDLE_NODE_CXT_MENU_NEW  USING MENU
                                            WA_CXT_MHRC.
    CHECK SY-SUBRC = 0.
    WA_CUR_CXT_MENU = WA_CXT_MHRC.
  ENDMETHOD.

*---------------------------------------------------------------------*
*       METHOD HANDLE_NODE_CONTEXT_MENU_SEL.
*---------------------------------------------------------------------*
*       START                                                         *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_CONTEXT_MENU_SEL.
    CHECK WA_TOGGLE EQ 'MHRC'.

    CLEAR WA_NODE_KEY.
    WA_NODE_KEY = NODE_KEY.
    PERFORM CHK_AND_CHANGE_NODE USING WA_NODE_KEY.

    PERFORM CALL_TRANSACTION_MHRC USING FCODE
                                        WA_NODE_KEY.
  ENDMETHOD.

*---------------------------------------------------------------------*
*       METHOD HANDLE_NODE_CONTEXT_MENU_REQ2.
*---------------------------------------------------------------------*
*       START                                                         *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_CONTEXT_MENU_REQ2.

    CLEAR WA_NODE_KEY.
    WA_NODE_KEY = NODE_KEY.

    PERFORM CHECK_NODE_N_NODE_BACK.
    IF WA_TOGGLE EQ 'MHRC'.
      CHECK WA_NODE_KEY NE WA_LAST_ROOT.
    ENDIF.

    PERFORM CHECK_MTART_TYPE USING    WA_NODE_KEY
                                      WA_MTART.
    REFRESH IT_PFTAB.

    CASE WA_MTART.
*-- Func Loc
      WHEN 'TPLN'.

*-- Equipment
      WHEN 'EQUI'.
        PERFORM HANDLE_NODE_CXT_MENU_NEW  USING MENU
                                                WA_CXT_EQUI.
        CHECK SY-SUBRC = 0.
        WA_CUR_CXT_MENU = WA_CXT_EQUI.

*--  ASS'Y
      WHEN 'IBAU'.
        PERFORM HANDLE_NODE_CXT_MENU_NEW  USING MENU
                                                WA_CXT_IBAU.
        CHECK SY-SUBRC = 0.
        WA_CUR_CXT_MENU = WA_CXT_ERSA.

*-- Material
      WHEN 'ERSA'.
        PERFORM HANDLE_NODE_CXT_MENU_NEW  USING MENU
                                                WA_CXT_ERSA.
        CHECK SY-SUBRC = 0.
        WA_CUR_CXT_MENU = WA_CXT_ERSA.

      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

*---------------------------------------------------------------------*
*       METHOD HANDLE_NODE_CONTEXT_MENU_SEL2
*---------------------------------------------------------------------*
*  ����/���纰 EQUI_TREE���� CONTEXT MENU�� ���Ű ���ý�           *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_CONTEXT_MENU_SEL2.

    CLEAR WA_NODE_KEY.
    WA_NODE_KEY = NODE_KEY.         "EQUI tree���� suffix�� �����Ƿ�

**-- ����� Ʈ������ ��忡 �ش��ϴ� ������ ����/ASSY/����
**-- �ڵ带 �о�´�.(G_NODE_KKEY�� ������ �ڵ带 �����´�.)
    PERFORM CHECK_MTART_TYPE USING    WA_NODE_KEY
                                      WA_MTART.
**-- ����� ����� Ʈ���� ��� ������ �ڵ�.
    PERFORM CALL_TRANSACTION_EQUI USING FCODE
                                        WA_NODE_KEY
                                        WA_MTART.

  ENDMETHOD.

*---------------------------------------------------------------------*
*        METHOD HANDLE_EXPAND_NO_CHILDREN
*---------------------------------------------------------------------*
*        �ڽĳ�� ���� ��尡 ������ �����Ǿ������                   *
*---------------------------------------------------------------------*
  METHOD HANDLE_EXPAND_NO_CHILDREN.

    CLEAR WA_NODE_KEY.
    WA_NODE_KEY = NODE_KEY.

*--���ó�� ���濡 ���� �׸��� ������Ʈ FREE-SLLEE
    PERFORM CHECK_NODE_N_NODE_BACK.  "//

    PERFORM GET_FUNCTION_LOCATION USING WA_NODE_KEY.

    IF WA_TOGGLE EQ 'MHRC'.
      CALL METHOD FUNC_TREE->ADD_NODES
        EXPORTING NODE_TABLE = FUNC_NODE_ITAB
                  TABLE_STRUCTURE_NAME = 'NODE_STR'.
    ENDIF.

    WA_INIT_FLG = 'X'.
  ENDMETHOD.

*---------------------------------------------------------------------*
*        METHOD HANDLE_NODE_DOUBLE_CLICK2
*---------------------------------------------------------------------*
*                        *
*---------------------------------------------------------------------*
  METHOD HANDLE_NODE_DOUBLE_CLICK2.
    CLEAR WA_NODE_KEY.
    WA_NODE_KEY = NODE_KEY.         "suffix�� �״�� ��

*--���ó�� ���濡 ���� �׸��� ������Ʈ FREE-SLLEE
    PERFORM CHECK_NODE_N_NODE_BACK.  "//

    IF WA_TOGGLE EQ 'MHRC'.
      CHECK     WA_NODE_KEY NE WA_LAST_ROOT.
    ENDIF.

**-- ����� Ʈ������ ��忡 �ش��ϴ� ������ ����/ASSY/����
**-- �ڵ带 �о�´�.(G_NODE_KKEY�� ������ �ڵ带 �����´�.)
    PERFORM CHECK_MTART_TYPE USING    WA_NODE_KEY
                                      WA_MTART.

    IF WA_TOGGLE EQ 'MHRC'.
      CHECK WA_NODE_KEY NE WA_LAST_ROOT.
    ELSE.
      CHECK NOT WA_NODE_KEY IN RG_LAST_ROOT.
    ENDIF.

    PERFORM CALL_TRANSACTION_EQ_N_MAT USING WA_NODE_KEY
                                            WA_MTART.
  ENDMETHOD.
ENDCLASS.
