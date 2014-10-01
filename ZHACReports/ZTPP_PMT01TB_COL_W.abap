*&-------------------------------------------------------------*
*& Report ZTPP_PMT01TB_COL_W
*&-------------------------------------------------------------*
*System name         : HMI SYSTEM
*Sub system name     : ARCHIVE
*Program name        : Archiving : ZTPP_PMT01TB_COL (Write)
*Program descrition  : Generated automatically by the ZHACR00800
*Created on   : 20130603          Created by   : T00302
*Changed on :                           Changed by    :
*Changed descrition :
*"-------------------------------------------------------------*
REPORT ZTPP_PMT01TB_COL_W .

***** Include TOP
INCLUDE ZTPP_PMT01TB_COL_T .

***** Selection screen.
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS S_ZBMDL FOR ZTPP_PMT01TB_COL-ZBMDL.
*SELECT-OPTIONS S_ZCOMP FOR ZTPP_PMT01TB_COL-ZCOMP.
SELECT-OPTIONS S_ZDATE FOR ZTPP_PMT01TB_COL-ZDATE.
*SELECT-OPTIONS S_ZDIVI FOR ZTPP_PMT01TB_COL-ZDIVI.
*SELECT-OPTIONS S_ZEXTC FOR ZTPP_PMT01TB_COL-ZEXTC.
*SELECT-OPTIONS S_ZINTC FOR ZTPP_PMT01TB_COL-ZINTC.
*SELECT-OPTIONS S_ZMODL FOR ZTPP_PMT01TB_COL-ZMODL.
*SELECT-OPTIONS S_ZNATN FOR ZTPP_PMT01TB_COL-ZNATN.
*SELECT-OPTIONS S_ZOCN FOR ZTPP_PMT01TB_COL-ZOCN.
*SELECT-OPTIONS S_ZREGI FOR ZTPP_PMT01TB_COL-ZREGI.
*SELECT-OPTIONS S_ZUSEE FOR ZTPP_PMT01TB_COL-ZUSEE.
SELECTION-SCREEN SKIP 1.
PARAMETERS: TESTRUN               AS CHECKBOX,
            CREATE    DEFAULT  'X' AS CHECKBOX,
            OBJECT    LIKE         ARCH_IDX-OBJECT
                      DEFAULT 'ZTPP_PMT0T' NO-DISPLAY .
SELECTION-SCREEN SKIP 1.
PARAMETERS: COMMENT   LIKE ADMI_RUN-COMMENTS OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B2.

***** Main login - common routine of include
PERFORM ARCHIVE_PROCESS.

***** Common routine
INCLUDE ZITARCW.

***** History for each object,
***** processing required for each part defined,
FORM OPEN_CURSOR_FOR_DB.
  OPEN CURSOR WITH HOLD G_CURSOR FOR
SELECT * FROM ZTPP_PMT01TB_COL
*WHERE ZBMDL IN S_ZBMDL
*AND ZCOMP IN S_ZCOMP
WHERE ZDATE IN S_ZDATE.
*AND ZDIVI IN S_ZDIVI
*AND ZEXTC IN S_ZEXTC
*AND ZINTC IN S_ZINTC
*AND ZMODL IN S_ZMODL
*AND ZNATN IN S_ZNATN
*AND ZOCN IN S_ZOCN
*AND ZREGI IN S_ZREGI
*AND ZUSEE IN S_ZUSEE.
ENDFORM.
FORM MAKE_ARCHIVE_OBJECT_ID.



ENDFORM.