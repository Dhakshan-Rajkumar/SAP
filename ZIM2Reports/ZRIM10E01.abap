*----------------------------------------------------------------------*
*   INCLUDE ZRIM10E01                                                  *
*----------------------------------------------------------------------*
*&  ���α׷��� : ���� ���۰���  POPUP�� Event Include                  *
*&      �ۼ��� : ���¿� INFOLINK Ltd.                                  *
*&      �ۼ��� : 2002.09.26                                            *
*&  ����ȸ��PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*
AT USER-COMMAND.
  CASE SY-UCOMM.
*------- Abbrechen (CNCL) ----------------------------------------------
    WHEN 'CANC' OR 'CNCL'.
      ANTWORT = 'C'.
      SET SCREEN 0.    LEAVE SCREEN.
  ENDCASE.

*&---------------------------------------------------------------------*
*&   Event AT LINE-SELECTION
*&---------------------------------------------------------------------*
AT LINE-SELECTION.
  CASE INCLUDE.
    WHEN 'POPU'.
      IF NOT IT_ERR_LIST-MSGTYP IS INITIAL.

        CALL FUNCTION 'MASS_MESSAGE_SHOW_LONGTEXT'
             EXPORTING
                  SPRSL     = SY-LANGU
                  ARBGB     = IT_ERR_LIST-MSGID
                  MSGNR     = IT_ERR_LIST-MSGNR
                  MSGV1     = IT_ERR_LIST-MSGV1
                  MSGV2     = IT_ERR_LIST-MSGV2
                  MSGV3     = IT_ERR_LIST-MSGV3
                  MSGV4     = IT_ERR_LIST-MSGV4
             EXCEPTIONS
                  NOT_FOUND = 1
                  OTHERS    = 2.

      ENDIF.
      CLEAR : IT_ERR_LIST.

    WHEN 'TRCHANGE'.
      ANTWORT = 'Y'.
    WHEN 'LGCREATE'.
        W_BLNO      = IT_ZSREQHD-ZFBLNO.
        W_HBLNO     = IT_ZSREQHD-ZFHBLNO.
        ANTWORT = 'Y'.

  ENDCASE.

  SET SCREEN 0.    LEAVE SCREEN.

*&---------------------------------------------------------------------*
*&   Event TOP-OF-PAGE
*&---------------------------------------------------------------------*
TOP-OF-PAGE.

  CASE INCLUDE.
*------- ����â�����(����) -  ( P/O No. �ߺ��� )--------------------
    WHEN 'TRCHANGE'.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.

      CASE W_SRCH.
        WHEN 'PO'.
          WRITE : / 'Purch. Number : ', ZTTRIT-EBELN.
        WHEN 'HB'.
          WRITE : / 'House B/L Number : ', ZTBL-ZFHBLNO.
        WHEN 'BL'.
          WRITE : / 'B/L ������ȣ : ', ZTBL-ZFBLNO.
      ENDCASE.

      WRITE : / SY-ULINE.
      FORMAT COLOR COL_HEADING INTENSIFIED.
      WRITE : / SY-VLINE NO-GAP,
                (10) '������No' NO-GAP,    SY-VLINE NO-GAP,
                (04) 'Plnt'       NO-GAP,    SY-VLINE NO-GAP,
                (10) '��ǥP/O No' NO-GAP,    SY-VLINE NO-GAP,
                (12) '�߼��ڸ�'   NO-GAP,    SY-VLINE NO-GAP,
                (08) '�������'   NO-GAP,    SY-VLINE NO-GAP,
                (08) '���۱���'   NO-GAP,    SY-VLINE NO-GAP,
                (02) 'GB'         NO-GAP,    SY-VLINE NO-GAP,
                (02) 'MT'         NO-GAP,    SY-VLINE NO-GAP.
      FORMAT RESET.
      WRITE : / SY-ULINE.
*------- L/G  CHANGE( B/L No. �ߺ��� )----------------------------------
    WHEN 'LGCREATE'.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE : / 'B/L Number : ', ZTIDRUS-ZFHBLNO.
      WRITE : / SY-ULINE.
      FORMAT COLOR COL_HEADING INTENSIFIED.
      WRITE : / 'B/L Doc.No'            NO-GAP,  SY-VLINE NO-GAP,
                'Cur. '                 NO-GAP,  SY-VLINE NO-GAP,
                '      Amount       '   NO-GAP,  SY-VLINE NO-GAP,
                'Shp'                   NO-GAP,  SY-VLINE NO-GAP,
                'Shipping por'          NO-GAP,  SY-VLINE NO-GAP,
                'Trp'                   NO-GAP,  SY-VLINE NO-GAP,
                'Arrival port'          NO-GAP,  SY-VLINE NO-GAP,
                'In charge'.
      FORMAT RESET.
      WRITE : / SY-ULINE.
  ENDCASE.
