*&---------------------------------------------------------------------*
*& report  ZRSYSID_UPDATE                                              *
*& writer : ������                                                     *
*& date   : 2000/01/03                                                 *
*& title  : original system to be changed                              *
*& �Ҽ�   : infolink ltd.                                              *
*&---------------------------------------------------------------------*
REPORT  ZRSYSID_UPDATE MESSAGE-ID ZIM.



TABLES : TADIR.              " R/3 ����ҿ�����Ʈ�� ����?

  SELECT *
    FROM TADIR
   WHERE PGMID  EQ 'R3TR'
     AND OBJECT EQ 'NROB'.
  ENDSELECT.
  IF SY-SUBRC EQ 0.
    DELETE FROM TADIR
          WHERE PGMID  EQ 'R3TR'
            AND OBJECT EQ 'NROB'.
  ENDIF.
