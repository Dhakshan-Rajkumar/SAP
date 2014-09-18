REPORT Z_AR31_1 MESSAGE-ID AB
                LINE-SIZE 130
                NO STANDARD PAGE HEADING.

TABLES: ANLH,
        ANLA0,
        ANLAV,
        ANLB,
        ANEK,
        ANEPV,
        ANLCV,
        t001b,
        RAPAR.

*TABLES RAPAR.
type-pools SHLP.

* ----- Arbeitsvorratsspezifische Tabellen: --------------------------*
TABLES: T080A,             " Zusatzdef. des Arb.vorrates
        GB92T,             " Substitution-Bezeichnung
        TABWT,             " Bewegungsartentext
        HRS1000,           " Aufgabenbezeichnung
        DD07V,             " Dom�nenkurztext.
        SWWSTATEXT.        " Aufgabentext.

* AV Statuskonstanten
CONSTANTS: WI_STATUS_READY    LIKE SWWWIHEAD-WI_STAT VALUE 'READY',
           WI_STATUS_SELECTED LIKE SWWWIHEAD-WI_STAT VALUE 'SELECTED'.

* Auszugebende Felder.
*     Strukturinfos zum Container mit Wert und Bedeutung der Felder.
DATA: BEGIN OF CONT_INFO OCCURS 0.
        INCLUDE STRUCTURE T080A.
DATA:   SCRTEXT_L LIKE DFIES-SCRTEXT_L,
        INTTYPE   LIKE DFIES-INTTYPE,       " Interner Datentyp
        VALUE(20),                          " Wert des Feldes.
        BEZ(40),                            " Text zum Wert.
      END OF CONT_INFO.

*     Kopfinformationen des Arbeitsvorrats.
DATA: BEGIN OF WI_HEADER.
        INCLUDE STRUCTURE SWWWIHEAD.
DATA: END OF WI_HEADER.

* Kopf-Informationen des Arbeitsvorrates.
DATA: BEGIN OF AI_HEADER.
        INCLUDE STRUCTURE SWZAI.
DATA: END OF AI_HEADER.

* Container-Inhalte des Arbeitsvorrates.
DATA: BEGIN OF AI_CONTAINER OCCURS 0.
        INCLUDE STRUCTURE SWCONT.
DATA: END OF AI_CONTAINER.

* Struktur der Container-Daten des Arbeitsvorrates.
DATA: AI_STRUCTURE LIKE DCOBJDEF-NAME.

* Struktur der Container-Daten des Arbeitsvorrates.
DATA: AI_varIANT like mass_variant.
* Zeileninformationen.
DATA: BEGIN OF AI_LINES OCCURS 0.
        INCLUDE STRUCTURE SWZELES.
DATA: END OF AI_LINES.

* Erl�sverteilung aus Struktur ABERL.
DATA: BEGIN OF XABERL OCCURS 0.
        INCLUDE STRUCTURE ABERL.
DATA: END   OF XABERL.

* Statustexte
DATA: BEGIN OF XSTTXT OCCURS 0.
        INCLUDE STRUCTURE SWWSTATEXT.
DATA: END OF XSTTXT.

* Zeilenstatus.
DATA: STAT_TXT LIKE SWWSTATEXT-STATUSTEXT.

* Flag: �berschrift beim ersten Mal unterdr�cken.
DATA: FLG_HEAD(1) TYPE C VALUE ' '.

* Arbeitstabelle f�r �nderungen einzelner Anlagen eines Arbeitsvorrats
* Zeilen sollen gel�scht bzw. hinzugef�gt werden.
DATA: BEGIN OF XASSET_STAT OCCURS 0.
        INCLUDE STRUCTURE ASSET.
*       I-nsert, D-elete
DATA:   KZ,
      END OF XASSET_STAT.
* ----- Ende Arbeitsvorratsspezifische Tabellen: ---------------------*
* Gesamte Zeilenzahl der Liste
DATA: L_LINES TYPE I.

DATA:
*     Arbeitsvorrat kann bearbeitet werden.
*     'X' = AV-Bearbeitung m�glich
*     ' ' = Nur Anzeigen m�glich.
      FLG_UPD(1) TYPE C VALUE ' ',
*     Arbeitsvorrat: Ein Wertfeld pro Zeile mitgegeben.
*     Werte: ' ' = Massenabgang o. Erl�s / Massen�nderung
*     Wert: 'X' = Massenabgang m. Erl�s
*     Wert: '1' = Massenabg. m.Erl�s u. Werte ge�ndert.
      FLG_ERLP(1)  TYPE C VALUE ' ',
*     Arbeitsvorrat:
*     Wert: ' ' = AV spezifische Daten wurden nicht ge�ndert
*     Wert: 'X' = Massenabgang m. Erl�s
      FLG_AVKOPF(1) TYPE C VALUE ' '.
*     Hilfsfeld: Verteilkennzeichen.
DATA: HLP_VERKZ(1).

*     Aufruf �ber WF erfolgt.
*     ' ' = Kein Aufruf ueber Workflow (Normalfall)
*     'E' = Bearbeitung ohne Freigabe �ber WF
*     'R' = Freigabe �ber WF, keine Bearbeitung
*     'A' = Korrektur und Freigabe �ber WF
*     Bei Aufruf ueber Workflow wird sonstige Berechtigung
*     ausgelassen.
DATA: G_WF_CALL(1) TYPE C VALUE ' '.
*     Returnwert, wenn AV �ber WF bearbeitet wird.
*     '0':  AV-Bearbeitung ist abgeschlossen mit ok.
*     '4':  AV-Bearbeitung wurde gecancelled.
DATA: G_WF_RET LIKE SY-SUBRC.

data : begin of it_T001B occurs 0.
        include structure t001b.
data : end of it_t001b.

data : wa_cnt type i.

* FIELDS-Anweisungen.
INCLUDE RASORT00.

* Allgemeine DATA-, TABLES-, ... Anweisungen.
INCLUDE RASORT04.

FIELD-GROUPS: HEADER, DATEN.

DATA:
*     Anzahl der im Anforderungsbild erlaubten AfA-Bereiche.
      SAV_ANZBE(1) TYPE C VALUE '1',
*     Flag: Postenausgabe Ja='1'/Nein='0'.
      FLG_POSTX(1) TYPE C VALUE '0',
*     Summenbericht: Maximale Anzahl Wertfelder/Zeile.
      CON_WRTZL(2) TYPE P VALUE 3.

* Ausgabe-Wertfelder.
DATA: BEGIN OF X,
*       Kumulierter Anschaffungswert einschliesslich Inv-Zus und Aufw.
        KANSW       LIKE ANLCV-GJE_KANSW,
*       Kumulierte Gesamt-AfA einschliesslich Aufw N-AfA.
        KUMAFA      LIKE RAREP-KUMAFA,
*       Restbuchwert einschliesslich Inv-Zus und Aufw.
        BCHWRT      LIKE ANLCV-GJE_BCHWRT,
*       Geplanter Erl�s.
        ERLP        LIKE ANLCV-GJE_BCHWRT,
      END OF X.

* Sortier-Wertfelder.
DATA: BEGIN OF SORT,
*       Kumulierter Anschaffungswert einschliesslich Inv-Zus und Aufw.
        KANSW       LIKE ANLCV-GJE_KANSW,
*       Kumulierte Gesamt-AfA einschliesslich Aufw N-AfA.
        KUMAFA      LIKE RAREP-KUMAFA,
*       Restbuchwert einschliesslich Inv-Zus und Aufw.
        BCHWRT      LIKE ANLCV-GJE_BCHWRT,
*       Geplanter Erl�s.
        ERLP        LIKE ANLCV-GJE_BCHWRT,
      END OF SORT.

* Name und Beschreibung der Massen�nderungsregel
DATA: HLP_SUBSID    LIKE GB92T-SUBSID,
      HLP_SUBSTEXT  LIKE GB92T-SUBSTEXT.

* Beschreibung der Abgangsinformationen
DATA: HLP_BWASL     LIKE ANBZ-BWASL,
      HLP_WAERS     LIKE ANBZ-WAERS,
      HLP_BUDAT     LIKE ANBZ-BUDAT,
      HLP_ERBDM     LIKE ANBZ-ERBDM,
      HLP_VBUND     LIKE ANBZ-VBUND.

SELECTION-SCREEN SKIP.                                     "VCL
SELECTION-SCREEN BEGIN OF BLOCK BL3                        "AB
                 WITH FRAME                                "AB
                 TITLE TEXT-C02.                           "AB

  PARAMETERS:
*             Keine zusaetzlich Sortierung.                "VCL
              PA_SRTW0 LIKE RAREP-SRTWRT   NO-DISPLAY,     "VCL
***                    RADIOBUTTON GROUP RAD1,             "VCL
*             Zusaetzlich Sortierung nach Anschaffungswert.
              PA_SRTW1 LIKE RAREP-SRTWRT   NO-DISPLAY,
***                    RADIOBUTTON GROUP RAD1,             "VCL
*             Zusaetzliche Sortierung nach kumulierter AfA.
              PA_SRTW2 LIKE RAREP-SRTWRT   NO-DISPLAY,
***                    RADIOBUTTON GROUP RAD1,             "VCL
*             Zusaetzlich Sortierung nach Buchwert.
              PA_SRTW3 LIKE RAREP-SRTWRT   NO-DISPLAY,
***                    RADIOBUTTON GROUP RAD1,             "VCL
*             Hitliste: Top nnnnn.
              PA_HITLI LIKE RAREP-HITLI NO-DISPLAY DEFAULT '00000'.
* Pro forma.
  DATA: PA_SRTW4  LIKE RAREP-SRTWRT,
        PA_SRTW5  LIKE RAREP-SRTWRT,
        PA_SRTW6  LIKE RAREP-SRTWRT,
        PA_SRTW7  LIKE RAREP-SRTWRT,
        PA_SRTW8  LIKE RAREP-SRTWRT,
        PA_SRTW9  LIKE RAREP-SRTWRT,
        PA_SRTW10 LIKE RAREP-SRTWRT.
SELECTION-SCREEN END   OF BLOCK BL3.                       "AB


SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK BL4                       "AB
                 WITH FRAME                                "AB
                 TITLE TEXT-C03.                           "AB
  PARAMETERS:
*             Zusatzueberschrift.
              PA_TITEL LIKE RAREP-TITEL NO-DISPLAY DEFAULT SPACE,
*             Flag: Listseparation gemaess Tabelle TLSEP.
              PA_LSSEP LIKE BHDGD-SEPAR NO-DISPLAY,
*             Flag: Mikrofichezeile ausgeben.
              PA_MIKRO LIKE BHDGD-MIFFL NO-DISPLAY.
SELECTION-SCREEN END   OF BLOCK BL4.                       "VCL

parameters : p_frye2 like t001b-frye2 default '2002',
             p_frpe2(3) default '001'.

INITIALIZATION.
* �berschrift setzen (abh. vom Aufruf)
  IF SY-TCODE = 'AR31'.
    SET TITLEBAR 'WRK'.
  ENDIF.

* Sortiervariante vorschlagen.
  MOVE: '0001' TO SRTVR.

* AV vorschlagen
  GET PARAMETER ID 'WQI' FIELD PA_AI_ID.

* Felder ausblenden, da nur f�r AV interessant.
AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
*   Buchungskreis ausblenden.
    IF SCREEN-NAME CS 'BUKRS'.
      SCREEN-ACTIVE = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

* Report wird nicht von au�en aufgerufen. Lesen derPickUp-Informationen
* aus dem Memory d.h. der urspr�nglich eingegebenen Programmabgrenzungen
* Allgemeine Verarbeitung der PA/SO-Eingaben.
INCLUDE RASORT08.
*---------------------------------------------------------------------*


START-OF-SELECTION.

*======2004/05/21 jhs modify
  perform check_t001b.
* clear entries that come from set/get parameters. Correct BUKRS will be
* taken from AV.
  refresh bukrs.

* Sichern der Selektionsoptionen bzw. Einlesen der Sortierwerte bei
* PickUp.
  PERFORM INFO_PICK_UP.
* PF-Status setzen.
*sET PF-STATUS 'LIST'.

* Statustabelle lesen komplett einlesen.
  PERFORM STATUSTAB_LESEN.

* Spezifische Daten des Arbeitsvorrates lesen und ausgeben.
  PERFORM AI_DATEN_AUFBEREITEN.

* Erl�saufteilung nur in Hausw�hrung m�glich; falls Umrechnungsmethode
* gew�hlt wird kommt eine Fehlermeldung; TS00007957 ist Abgang mit Erl�s
  IF NOT umvar IS INITIAL AND ai_header-def_task = 'TS00007957'.">369058
    message i458.                                               ">369058
    exit.                                                       ">369058
  ENDIF.                                                        ">369058

* Summenbericht: Ueberschriften der Wertfelder.
IF SUMMB NE SPACE.
  WRITE  TEXT-W01 TO SFLD-FNAME.
  APPEND SFLD.
* Kein AV mit eigenem Wertfeld.
  IF FLG_ERLP IS INITIAL.
    WRITE  TEXT-W02 TO SFLD-FNAME.
    APPEND SFLD.
    WRITE  TEXT-W03 TO SFLD-FNAME.
    APPEND SFLD.
* AV mit eigenem anzuzeigendem Wertfeld.
  ELSE.
    WRITE  TEXT-W03 TO SFLD-FNAME.
    APPEND SFLD.
    WRITE  TEXT-W04 TO SFLD-FNAME.
    APPEND SFLD.
  ENDIF.

ENDIF.

* Bestimmung des Sortierfeldes auf unterster Gruppenstufe.
ASSIGN SAV_DUMMY TO <B>.
* Zusaetzlich Sortierung nach Wertfeld auf unterster Gruppenstufe.
IF PA_SRTW1 NE SPACE.
  ASSIGN SORT-KANSW  TO <B>.
ENDIF.
IF PA_SRTW2 NE SPACE.
  ASSIGN SORT-KUMAFA TO <B>.
ENDIF.
IF PA_SRTW3 NE SPACE.
  ASSIGN SORT-BCHWRT TO <B>.
ENDIF.

* Hitliste: Wertfelder fuer Summe ueber Hit-Anlagen.
IF NOT PA_HITLI IS INITIAL.
  ASSIGN X-KANSW  TO <H1>.
  ASSIGN X-KUMAFA TO <H2>.
  ASSIGN X-BCHWRT TO <H3>.
  ASSIGN X-ERLP   TO <H4>.
* Nicht benoetigte Summenfelder.
  ASSIGN SAV_WDUMMY TO: <H5>, <H6>, <H7>, <H8>, <H9>, <H10>,
    <H11>, <H12>, <H13>, <H14>, <H15>, <H16>, <H17>, <H18>, <H19>,
    <H20>.
ENDIF.

* Bestimmung des Sortierfeldes fuer Gitterposition oder Einzelposten.
ASSIGN SAV_DUMMY TO <P>.
ASSIGN SAV_DUMMY TO <Q>.

* Allgemeines Coding nach START-OF-SELECTION. Aufbau des HEADERs.
INCLUDE RASORT10.

INSERT
*        Daten zur Anlage.
         ANLAV-ANLN0
         ANLAV-ANLN1        ANLAV-ANLN2        ANLAV-WERKS
         ANLAV-TXT50        ANLAV-KOSTL        ANLAV-MENGE
         ANLAV-POSNR        ANLAV-AKTIV        ANLAV-LIFNR
         ANLAV-MEINS        ANLAV-STORT        ANLAV-TXA50
         ANLAV-ANLHTXT      ANLAV-XANLGR
*        Daten zum AfA-Bereich.
         ANLB-AFASL         ANLB-AFABG         ANLB-SAFBG
         ANLB-NDJAR         ANLB-NDPER         SAV_WAER1
*        Wertfelder.
         X-KANSW            X-KUMAFA           X-BCHWRT
         X-ERLP
*        Zeilenstatus.
         STAT_TXT
         INTO DATEN.


* Steuerungskennzeichen f�r LDB setzen
  *ANLA0-XALOEV = 'X'.
  *ANLA0-XNODBS = 'X'.
GET ANLA0.


GET anlav FIELDS ANLN0 ANLN1 ANLN2 WERKS TXT50 KOSTL MENGE   "no 607927
    POSNR AKTIV LIFNR MEINS STORT TXA50 ANLHTXT XANLGR.      "no 607927

   IF ANLAV-MENGE IS INITIAL.
   CLEAR ANLAV-MEINS.
   ENDIF.

  CHECK SELECT-OPTIONS.
* Nur Anlagen seleketieren, die aktiviert wurden ...
* Alle Anlagen aus Arbeitsvorrat werden angezeigt
* CHECK NOT ANLAV-ZUGDT IS INITIAL.
* ... und zwar vor dem Berichtsdatum.
* CHECK     ANLAV-ZUGDT LE BERDATUM.

* Verarbeitungen ON CHANGE OF ANLAV-XXXXX.
  INCLUDE RASORT14.

* Im VJ deaktivierte Anlagen nicht selektieren.
* Alle Anlagen aus AV anzeigen               n.
* IF NOT ANLAV-DEAKT IS INITIAL.
*   CHECK ANLAV-DEAKT GE SAV_GJBEG.
* ENDIF.

  ON CHANGE OF ANLAV-BUKRS.
*   Individueller Teil des Headers
    WRITE: '-'       TO HEAD-INFO1,
           BEREICH1  TO HEAD-INFO2,
           SAV_AFBE1 TO HEAD-INFO3.
*
    CONDENSE HEAD.
  ENDON.


GET ANLB.

  CHECK SELECT-OPTIONS.


GET ANLCV.

  PERFORM FEHLER_AUSGEBEN.

* Werte berechnen.
  PERFORM WERTE_BERECHNEN.

* Daten gegen Sortierwerte beim PickUp checken.
  PERFORM SORT_CHECK.

GET ANLAV LATE.

  PERFORM FEHLER_AUSGEBEN.
* Zeilenstatus bestimmen.
  PERFORM STATUS_LESEN.
* Keine Unterteilung der extrahierten Saetze ==> Jeder hat Rang '1'.
  RANGE = '1'.
* DATEN extrahieren.
  EXTRACT DATEN.
* Felder reset

  CLEAR: X-KANSW, X-KUMAFA, X-BCHWRT,
         X-ERLP.
*

END-OF-SELECTION.
*---------------------------------------------------------------------*

* Bestand sortieren.
INCLUDE RASORT20.

* Pr�fen, ob WF aktiv ist.
  PERFORM WF_STATUS_PRUEFEN.

* Pr�fen, ob AV bearbeitet werden kann.
* Default: Nur Anzeigen.
  CLEAR FLG_UPD.

* Nur wenn AV bearbeitet werden kann.
  IF FLG_WFAKTIV IS INITIAL.
*   Kein Aufruf �ber Men� AV-Anzeige
    IF SY-TCODE <> 'AR30'.
      PERFORM BERECHTIGUNG_PRUEFEN USING FLG_UPD.
    ENDIF.
  ENDIF.

* Aufruf �ber WF gesondert behandeln.
  PERFORM AV_AUFRUF_UEBER_WF USING FLG_UPD.

* AV Zusatzinformationen ausgeben.
  PERFORM AI_DATEN_AUSGEBEN.

* PF-Status in Abh�ngigkeit der Art neu setzen.
  PERFORM PF_STATUS_SETZEN.


LOOP.

* AT NEW - Allgemeine Steuerungen.
  INCLUDE RASORT24.
* Kein Summenbereicht.
  IF SUMMB EQ SPACE.
    AT DATEN.
*     Hitliste: Hit-Summe hochzaehlen, Hit-Zaehler hochsetzen.
      PERFORM HITSUMME_BILDEN.
*
      PERFORM DATEN_AUSGEBEN.
    ENDAT.
  ENDIF.
* AT END OF - Allgemeine Steuerungen, Summenausgaben.
  INCLUDE RASORT28.
ENDLOOP.

PERFORM NO_RECORDS.


*---------------------------------------------------------------------*
*************************************************************
TOP-OF-PAGE.

* Allgemeine TOP-OF-PAGE-Verarbeitung.
  INCLUDE RASORT30.

*---------------------------------------------------------------------*

* PickUp auf Anlage oder Beleg (AT LINE-SELECTION).
*INCLUDE RASORT50 .
INCLUDE zRASORT50 .


* Allgemeine FORM-Routinen.
INCLUDE RASORT40.

FORM DATEN_AUSGEBEN.

* Hitliste.
  IF NOT PA_HITLI IS INITIAL.
*   Datensatz-Nummer > angeforderte Anzahl ...
    IF CNT_HITLI GT PA_HITLI.
*     ... dann nix ausgeben.
      EXIT.
    ENDIF.
  ENDIF.

* Anlage aus AV l�schen -> Farbe �ndern.
  LOOP AT XASSET_STAT
       WHERE BUKRS = ANLAV-BUKRS
         AND ANLN1 = ANLAV-ANLN1
         AND ANLN2 = ANLAV-ANLN2.
     EXIT.
  ENDLOOP.

* Farbe intensiv schalten
  IF SY-SUBRC = 0.
    FORMAT INVERSE ON.
  ELSE.
    FORMAT INVERSE OFF.
  ENDIF.

  RESERVE 2 LINES.

  WRITE: /001      SY-VLINE NO-GAP,
          002(12)  ANLAV-ANLN0 NO-GAP
                   COLOR COL_KEY INTENSIFIED ON,
          014(01)  SPACE NO-GAP
                   COLOR COL_KEY INTENSIFIED ON,
          015(04)  ANLAV-ANLN2 NO-GAP
                   COLOR COL_KEY INTENSIFIED ON,
          019      SY-VLINE NO-GAP,
          020(10)  ANLAV-AKTIV DD/MM/YYYY NO-GAP
                   COLOR COL_KEY INTENSIFIED OFF,
          030(01)  SPACE NO-GAP
                   COLOR COL_KEY INTENSIFIED OFF,
          031(29)  ANLAV-TXT50 NO-GAP
                   COLOR COL_KEY INTENSIFIED OFF,
          060(01)  SPACE NO-GAP
                   COLOR COL_KEY INTENSIFIED OFF,
          061(20)  STAT_TXT    NO-GAP
                   COLOR COL_KEY INTENSIFIED OFF,
          081      SY-VLINE NO-GAP,
          082(15)  X-KANSW  CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_NORMAL INTENSIFIED OFF.
* Kein Eigenes Wertfeld anzeigen.
IF FLG_ERLP IS INITIAL.
  WRITE:  098(15)  X-KUMAFA CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_NORMAL INTENSIFIED OFF,
          114(15)  X-BCHWRT CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_NORMAL INTENSIFIED OFF.
* Eigenes Wertfeld anzeigen.
ELSE.
  WRITE:  098(15)  X-BCHWRT CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_NORMAL INTENSIFIED OFF,
          114(15)  X-ERLP   CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_NORMAL INTENSIFIED OFF.
ENDIF.
WRITE:    130      SY-VLINE NO-GAP.

* Informationen fuer PickUp.
  FLG_PICK_UP = 'X'.
* PickUp auf Anlage ist m�glich.

  HIDE:           ANLAV-BUKRS,
                  ANLAV-ANLN1,
                  ANLAV-ANLN2,
                  ANLAV-XANLGR,
                  FLG_PICK_UP,
                  RANGE.

  CLEAR FLG_PICK_UP.

ENDFORM.


FORM SUMME_AUSGEBEN USING SUM_STARX
                          SUM_FTEXT
                          SUM_FINHA
                          SUM_FBEZ.

* Summenbericht?
  IF SUMMB NE SPACE.

*   Summentabelle erfrischen.
    REFRESH SWRT.
    CLEAR SWRT.
*   Uebergabe der Summen in der Reihenfolge ihrer Ausgabe.
    WRITE SUM(X-KANSW)  TO SWRT-BETRG
      CURRENCY SAV_WAER1.
    APPEND SWRT.

*   Standardwertfelder.
    IF FLG_ERLP IS INITIAL.
      WRITE SUM(X-KUMAFA) TO SWRT-BETRG
        CURRENCY SAV_WAER1.
      APPEND SWRT.
      WRITE SUM(X-BCHWRT) TO SWRT-BETRG
        CURRENCY SAV_WAER1.
      APPEND SWRT.
*   Eigenes Wertfeld anzeigen.
    ELSE.
      WRITE SUM(X-BCHWRT) TO SWRT-BETRG
        CURRENCY SAV_WAER1.
      APPEND SWRT.
      WRITE SUM(X-ERLP) TO SWRT-BETRG
        CURRENCY SAV_WAER1.
      APPEND SWRT.
    ENDIF.

*
    PERFORM GRUSUMME_AUSGEBEN.

* Kein Summenbericht.
  ELSE.

*   Hitliste?
    IF NOT PA_HITLI IS INITIAL.

*     Dann Summe ueber Hitliste zuerst ausgeben.
      RESERVE 2 LINES.

      WRITE: /001      SY-VLINE,
              002(05)  TEXT-H02 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              007(12)  SPACE NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              019      SY-VLINE,
              020(05)  PA_HITLI NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              025(16)  SPACE NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              041(20)  TEXT-H01 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              061(15)  SPACE NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              076(05)  '    *' NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              081      SY-VLINE NO-GAP,
              082(15)  HITSUM-BETRG1 CURRENCY SAV_WAER1 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON.
* Standardwertfelder.
IF FLG_ERLP IS INITIAL.
    WRITE:    098(15)  HITSUM-BETRG2 CURRENCY SAV_WAER1 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              114(15)  HITSUM-BETRG3 CURRENCY SAV_WAER1 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON.
* Eigenes Wertfeld.
ELSE.
    WRITE:    098(15)  HITSUM-BETRG3 CURRENCY SAV_WAER1 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON,
              114(15)  HITSUM-BETRG4 CURRENCY SAV_WAER1 NO-GAP
                       COLOR COL_TOTAL INTENSIFIED ON.
ENDIF.
    WRITE:    130      SY-VLINE NO-GAP.
       ULINE.
    ENDIF.

    RESERVE 2 LINES.

    WRITE: /001      SY-VLINE NO-GAP,
            002(17)  SUM_FTEXT NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            019      SY-VLINE NO-GAP,
            020(20)  SUM_FINHA NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            040(01)  SPACE NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            041(34)  SUM_FBEZ NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            075(01)  SPACE NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            076(05)  SUM_STARX NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            081      SY-VLINE NO-GAP,
            082(15)  SUM(X-KANSW)  CURRENCY SAV_WAER1 NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON.
* Standardwertfelder.
IF FLG_ERLP IS INITIAL.
    WRITE:  098(15)  SUM(X-KUMAFA) CURRENCY SAV_WAER1 NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            114(15)  SUM(X-BCHWRT) CURRENCY SAV_WAER1 NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON.
* Eigenes Wertfeld.
ELSE.
    WRITE:  098(15)  SUM(X-BCHWRT) CURRENCY SAV_WAER1 NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON,
            114(15)  SUM(X-ERLP) CURRENCY SAV_WAER1 NO-GAP
                     COLOR COL_TOTAL INTENSIFIED ON.
ENDIF.
    WRITE:  130      SY-VLINE NO-GAP.
    ULINE.
  ENDIF.

ENDFORM.


FORM ANLN1_SUMME_AUSGEBEN.

* Feld f�r Sternchen bei Summe
DATA: STARORSPACE(1)  TYPE C    VALUE ' '.

  IF T086-XLEERZL = 'X'.
    STARORSPACE = '*'.
    RESERVE 3 LINES.
  ELSE.
    RESERVE 2 LINES.
  ENDIF.

  WRITE: /001      SY-VLINE NO-GAP,
          002(12)  ANLAV-ANLN0 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          014(01)  SPACE NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          015(04)  CON_ANLN1_SUM NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          019      SY-VLINE NO-GAP,
          020(11)  SPACE NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          031(50)  ANLAV-ANLHTXT NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          081      SY-VLINE NO-GAP,
          082(15)  SUM(X-KANSW)  CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          097      STARORSPACE NO-GAP.
* Standardwertfeld.
IF FLG_ERLP IS INITIAL.
  WRITE:  098(15)  SUM(X-KUMAFA) CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          113      STARORSPACE NO-GAP,
          114(15)  SUM(X-BCHWRT) CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          129      STARORSPACE NO-GAP.
* Eigenes Wertfeld
ELSE.
  WRITE:  098(15)  SUM(X-BCHWRT) CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          113      STARORSPACE NO-GAP,
          114(15)  SUM(X-ERLP) CURRENCY SAV_WAER1 NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          129      STARORSPACE NO-GAP.
ENDIF.
  WRITE:  130      SY-VLINE NO-GAP.

  CHECK T086-XLEERZL = 'X'.

  WRITE: /001      SY-VLINE NO-GAP,
          002(12)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          014(01)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          015(04)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          019      SY-VLINE NO-GAP,
          020(11)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          031(50)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          081      SY-VLINE NO-GAP,
          082(15)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          098(15)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          114(15)  SPACE    NO-GAP
                   COLOR COL_TOTAL INTENSIFIED OFF,
          130      SY-VLINE NO-GAP.

ENDFORM.


FORM UEBERSCHRIFTEN_AUSGEBEN.

* Bei einem Arbeitsvorrat �berschrift erst nach AV spezifischem
* Kopf auf Seite 2 ausgeben.
  IF FLG_HEAD IS INITIAL.
*   �berschrift beim n�chsten Mal ausgeben.
    FLG_HEAD = 'X'.
*   Routine verlassen.
    EXIT.
  ENDIF.

  WRITE: /001      SY-VLINE NO-GAP,
          002(12)  TEXT-001 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          014(01)  SPACE NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          015(04)  TEXT-002 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          019      SY-VLINE NO-GAP,
          020(10)  TEXT-003 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          030(01)  SPACE NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          031(30)  TEXT-004 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          061(20)  TEXT-AI9 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          081      SY-VLINE NO-GAP,
          082(14)  TEXT-W01 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON.
* Standardwertfeld.
IF FLG_ERLP IS INITIAL.
  WRITE:  098(14)  TEXT-W02 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          114(14)  TEXT-W03 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON.
* Eigenes Wertfeld.
ELSE.
  WRITE:  098(14)  TEXT-W03 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON,
          114(14)  TEXT-W04 NO-GAP
                   COLOR COL_HEADING INTENSIFIED ON.
ENDIF.
  WRITE:  130      SY-VLINE NO-GAP.
  ULINE.

ENDFORM.


FORM WERTE_BERECHNEN.

* Kumulierter Anschaffungswert einschliesslich Inv-Zus und Aufw.
  X-KANSW       =
*                 Kumulierter Anschaffungswert.
                  ANLCV-KANSW
*                 Kumulierte Aufwertung
                + ANLCV-KAUFW
*                 Anteilige Bewegungen auf Aufwertung.
                + ANLCV-AUFWV + ANLCV-AUFWL
*                 Anschaffungswertaendernde Bewegungen des GJ.
                + ANLCV-ANSWL
*                 Geplante Aufwertung des GJ.
                + ANLCV-AUFWP.

* Kumulierte Gesamt-AfA einschliesslich Aufw N-AfA.
  X-KUMAFA      =
*                 Kumulierte N-AfA.
                  ANLCV-KNAFA
*                 Kumulierte Aufwertung N-AfA.
                + ANLCV-KAUFN
*                 Kumulierte S-AfA.
                + ANLCV-KSAFA
*                 Kumulierte A-AfA.
                + ANLCV-KAAFA
*                 Kumulierte M-AfA.
                + ANLCV-KMAFA
*                 Geplante N-AfA des GJ.
                + ANLCV-NAFAP
*                 Geplante Aufwertung N-AfA des GJ.
                + ANLCV-AUFNP
*                 Geplante S-AfA des GJ.
                + ANLCV-SAFAP
*                 Geplante A-AfA des GJ.
                + ANLCV-AAFAP
*                 Geplante M-AfA des GJ.
                + ANLCV-MAFAP
*                 Bewegungen auf Wertberichtigungen des GJ.
                + ANLCV-NAFAV + ANLCV-SAFAV
                + ANLCV-AAFAV + ANLCV-MAFAV
                + ANLCV-NAFAL + ANLCV-SAFAL
                + ANLCV-AAFAL + ANLCV-MAFAL
*                 Bewegungen auf Aufwertung N-AfA des GJ.
                + ANLCV-AUFNV + ANLCV-AUFNL
*                 Zuschreibungen des GJ.
                + ANLCV-ZUSNA + ANLCV-ZUSSA
                + ANLCV-ZUSAA + ANLCV-ZUSMA.

* Buchwert GJ-Ende.
  X-BCHWRT      =
*                 Kumulierte Anschaffungswert (wie berechnet).
                  X-KANSW
*                 Kumulierte AfA (wie berechnet).
                + X-KUMAFA.

  IF NOT FLG_ERLP IS INITIAL.
*   Geplanter Erl�s aus dem Arbeitsvorratscontainer.
    LOOP AT XABERL
         WHERE BUKRS = ANLAV-BUKRS
           AND ANLN1 = ANLAV-ANLN1
           AND ANLN2 = ANLAV-ANLN2.
      X-ERLP     = XABERL-ABERL.
      SORT-ERLP  = X-ERLP.
*     Schleife verlassen.
      EXIT.
    ENDLOOP.
  ENDIF.

* Sortier-Wertfelder.
  SORT-KANSW    = X-KANSW.
  SORT-KUMAFA   = 0           - X-KUMAFA.
  SORT-BCHWRT   = X-BCHWRT.

ENDFORM.



* Lesen der Container-Daten des Arbeitsvorrates
* und Ausgeben des Inhalts als Kopf des Reports.
FORM AI_DATEN_AUFBEREITEN.

* Verteilkennzeichen
DATA: L_VERKZ(1).
* Abbruchkennzeichen (nur zum Aufruf)
DATA: LD_ABBRUCH(1).

* Wurde �berhaupt ein Arbeitsvorrat ausgew�hlt,
* ansonsten ist die Routine �berfl�ssig.
  IF PA_AI_ID IS INITIAL.
*   �berschrift schon bei der ersten Seite ausgeben.
    FLG_HEAD = 'X'.
*   Routine verlassen.
    EXIT.
  ENDIF.


* Kopf des Arbeitsvorrates lesen f�r �berschrift lesen.
  CALL FUNCTION 'SWW_WI_HEADER_READ'
       EXPORTING
            WI_ID           = PA_AI_ID
       IMPORTING
            WI_HEADER       = WI_HEADER
       EXCEPTIONS
            READ_FAILED     = 01.

* AV existiert nicht.
  IF SY-SUBRC <> 0.
    MESSAGE E052 WITH PA_AI_ID.
  ENDIF.



* Kopf des Arbeitsvorrates lesen, um die Aufgabe zu ermitteln.
  CALL FUNCTION 'SWZ_AI_HEADER_READ'
       EXPORTING
            WI_ID       = PA_AI_ID
       IMPORTING
            AI_HEADER   = AI_HEADER
       EXCEPTIONS
            READ_FAILED = 01.

  REFRESH CONT_INFO.

* Lesen der Metadaten des AV-Containers aus Tabelle T080A.
  SELECT * FROM T080A
      WHERE TASKID = AI_HEADER-DEF_TASK.
*   Dictionary Informationen zu den Container-Daten besorgen.
    MOVE-CORRESPONDING T080A TO CONT_INFO.
    APPEND CONT_INFO.
  ENDSELECT.


* S�mtliche Container-Inhalte zum Arbeitsvorrat lesen.
  CALL FUNCTION 'SWW_WI_CONTAINER_READ'
       EXPORTING
            WI_ID                    = PA_AI_ID
       TABLES
            WI_CONTAINER             = AI_CONTAINER
       EXCEPTIONS
            CONTAINER_DOES_NOT_EXIST = 01.

* Struktur der zu Workflow-Daten besorgen
  SWC_GET_ELEMENT AI_CONTAINER 'AV_TAB_STRUC' AI_STRUCTURE.

* Beschreibung der Substitution besorgen
  CLEAR HLP_SUBSTEXT.
  IF AI_HEADER-DEF_TASK = 'TS00007958'.
    SWC_GET_ELEMENT AI_CONTAINER 'substid' HLP_SUBSID.
    IF SY-SUBRC = 0.
      CALL FUNCTION 'G_SUBSTITUTION_GET_INFO'
           EXPORTING
                SUBSTID           = HLP_SUBSID
                READ_TEXT         = 'X'
           IMPORTING
                DESCRIPTION       = HLP_SUBSTEXT
           EXCEPTIONS
                NOT_FOUND         = 1
                OTHERS            = 2.
      IF SY-SUBRC NE 0.
        HLP_SUBSTEXT = '?'.
      ENDIF.
    ENDIF.
  ENDIF.

* Informationen zum Massenabgang besorgen
  CLEAR: HLP_BUDAT,
         HLP_BWASL,
         HLP_VBUND,
         HLP_ERBDM.
  IF AI_HEADER-DEF_TASK = 'TS00007956'   OR
     AI_HEADER-DEF_TASK = 'TS00007957'.
    SWC_GET_ELEMENT AI_CONTAINER 'budat' HLP_BUDAT.
    SWC_GET_ELEMENT AI_CONTAINER 'bwasl' HLP_BWASL.
    SWC_GET_ELEMENT AI_CONTAINER 'erbdm' HLP_ERBDM.
    SWC_GET_ELEMENT AI_CONTAINER 'vbund' HLP_VBUND.
  ENDIF.

* Bei Massenabgang mit Erl�s Erl�stabelle besorgen.
  IF AI_HEADER-DEF_TASK = 'TS00007957'.
    SWC_GET_TABLE AI_CONTAINER 'xaberl' XABERL.
*   Arbeitsvorrat hat zu verteilenden Erl�s o. anderes Wertfeld.
    DESCRIBE TABLE XABERL LINES SY-TABIX.
*   Erl�s wurde noch nicht verteilt
*   ->Jetzt Erl�sverteilung durchf�hren
    IF SY-TABIX = 0.
      SWC_GET_ELEMENT AI_CONTAINER 'verkz' L_VERKZ.
*     Pr�fen, ob autom. verteilt werden soll.
      IF L_VERKZ <> 'E'.
        PERFORM ERLOES_NEU_VERTEILEN USING LD_ABBRUCH.
        IF LD_ABBRUCH IS INITIAL.
*          PERFORM DATEN_SICHERN.                 ">>> delete 126352
*   Container�nderung auf DB fortschreiben.       "<<< insert 126352
    CALL FUNCTION 'SWW_WI_CONTAINER_MODIFY'       "<<< insert 126352
         EXPORTING                                "<<< insert 126352
              WI_ID                = PA_AI_ID     "<<< insert 126352
              DO_COMMIT            = 'X'          "<<< insert 126352
              DELETE_OLD_CONTAINER = 'X'          "<<< insert 126352
         TABLES                                   "<<< insert 126352
              WI_CONTAINER         = AI_CONTAINER "<<< insert 126352
         EXCEPTIONS                               "<<< insert 126352
              OTHERS               = 1.           "<<< insert 126352

        ENDIF.
      ENDIF.
    ENDIF.
*   Wertfeld: gepl. Erl�s ausgeben.
    FLG_ERLP = 'X'.
  ENDIF.

* Abmischen der Container-Strukturinformationen mit den Werten.
  LOOP AT CONT_INFO
       WHERE XDRUCK  = 'X'.
*   Feldbezeichnung zum aktuellen Feld lesen.
    PERFORM DDIC_INFO_LESEN USING CONT_INFO.
*
    IF CONT_INFO-XHEADER = 'X'.
*     Wert des auszugebenden Feldes ermitteln.
      SWC_GET_ELEMENT AI_CONTAINER CONT_INFO-FELDNM CONT_INFO-VALUE.
    ELSE.
*     Wert der auszugebenden Tabelle ermitteln.
      SWC_GET_TABLE AI_CONTAINER 'xaberl' XABERL.
    ENDIF.
*   Bezeichnung des auszugebenden Feldes ermitteln.
    PERFORM CONT_INFO_BEZ_GET USING CONT_INFO.

    MODIFY CONT_INFO.
  ENDLOOP.


* Zeileninfos des AV lesen.
  CALL FUNCTION 'SWZ_AI_SHOW'
       EXPORTING
            WI_ID            = PA_AI_ID
       TABLES
            OBJECT_LIST      = AI_LINES
       EXCEPTIONS
            EXECUTION_FAILED = 01.

  IF NOT HLP_BWASL IS INITIAL.
    READ TABLE AI_LINES  INDEX 1.
    CLEAR HLP_WAERS.
    T093B-AFABE  =  BEREICH1.
    T093B-BUKRS  =  AI_LINES-OBJECTID+20(04).

    CALL FUNCTION 'T093B_READ'
         EXPORTING
              F_T093B   = T093B
         IMPORTING
              F_T093B   = T093B
         EXCEPTIONS
              NOT_FOUND = 1
              OTHERS    = 2.
    IF SY-SUBRC = 0.
      HLP_WAERS = T093B-WAERS.
    ENDIF.
  ENDIF.

*
* AV Zusatzinformationen ausgeben.
* perform ai_daten_ausgeben.
*
ENDFORM.



* Vordefinierte Texte zu den Werten lesen.
* Dies ist nur f�r bereits bekannte Felder m�glich.
* Ansonsten vielleicht in Zukunft User-Exit.
FORM CONT_INFO_BEZ_GET USING CONT_INFO STRUCTURE CONT_INFO.

* Hilfsfeld: Dom�nenfestwerte.
DATA: HLP_VALPOS LIKE DD07V-VALPOS.

* Feld: Aufgabenkennung.
  IF CONT_INFO-FELDNM = 'WI_RH_TASK'.
    SELECT SINGLE * FROM HRS1000
           WHERE LANGU   = SY-LANGU
             AND OBJID   = CONT_INFO-VALUE+2(8)
             AND OTYPE   = CONT_INFO-VALUE(2).
*   Text �bertragen
    IF SY-SUBRC = 0.
      CONT_INFO-BEZ = HRS1000-STEXT.
    ENDIF.
  ENDIF.

* Feld: Substitution.
  IF CONT_INFO-FELDNM = 'SUBSTID'.
    SELECT SINGLE * FROM GB92T
           WHERE LANGU   = SY-LANGU
             AND SUBSID = CONT_INFO-VALUE.
*   Text �bertragen
    IF SY-SUBRC = 0.
      CONT_INFO-BEZ = GB92T-SUBSTEXT.
    ENDIF.
  ENDIF.

* Feld: BWA.
  IF CONT_INFO-FELDNM = 'BWASL'.
    SELECT SINGLE * FROM TABWT
           WHERE SPRAS  = SY-LANGU
             AND BWASL  = CONT_INFO-VALUE.
*   Text �bertragen
    IF SY-SUBRC = 0.
      CONT_INFO-BEZ = TABWT-BWATXT.
    ENDIF.
  ENDIF.

* Feld: Verteilkennzeichen
  IF CONT_INFO-FELDNM = 'VERKZ'.
*   Verteilung nach AHK.
    CASE CONT_INFO-VALUE.
      WHEN 'A'.
        HLP_VALPOS = '0001'.
*   Vert. nach Restwerten.
      WHEN 'R'.
        HLP_VALPOS = '0002'.
      WHEN 'E'.
        HLP_VALPOS = '0003'.
    ENDCASE.
    SELECT SINGLE * FROM DD07V
           WHERE DDLANGUAGE = SY-LANGU
             AND DOMNAME    = 'AM_VERKZ'
             AND VALPOS     = HLP_VALPOS.                     .
*   Text �bertragen
    IF SY-SUBRC = 0.
      CONT_INFO-BEZ = DD07V-DDTEXT.
    ENDIF.
  ENDIF.

ENDFORM.



* DDIC-Informationen zu den angegebenen Feldern lesen.
FORM DDIC_INFO_LESEN USING CONT_INFO STRUCTURE CONT_INFO.
*
    PERFORM GET_FIELD(RDDFIE00)
      USING CONT_INFO-TABNM CONT_INFO-FELDNM SY-LANGU
      CHANGING DFIES SY-SUBRC.

*   Langes Schl�sselwort �bertragen.
    CONT_INFO-SCRTEXT_L = DFIES-SCRTEXT_L.
    CONT_INFO-INTTYPE   = DFIES-INTTYPE.

ENDFORM.



* Arbeitsvorratsspezifische Daten zu Beginn des Rep. ausgeben.
FORM AI_DATEN_AUSGEBEN.

* Hilfsfeld: Datum.
DATA: HLP_DAT       TYPE D,
* Hilfsfeld: Wertfeld.
      HLP_WERT(8)   TYPE P.
* Hilfsfeld: Text zur Aufgabe.
DATA: HLP_TASK_TXT LIKE HRS1000-STEXT.
* Hilfsfeld: Text zur Aufgabe.
DATA: HLP_STAT_TXT LIKE HRS1000-STEXT.

* Bezeichnung zur Aufgabe lesen.
  PERFORM TASK_TXT_LESEN USING AI_HEADER-DEF_TASK HLP_TASK_TXT.

* Bezeichnung zum Status des AV lesen.
  PERFORM STAT_TXT_LESEN USING WI_HEADER-WI_STAT HLP_STAT_TXT.

  FORMAT RESET.
* Top-�berschrift ausgeben.
  WRITE: /001 TEXT-AI1 COLOR COL_BACKGROUND INTENSIFIED ON.

  FORMAT RESET.
  WRITE: /         SY-ULINE.

* 1. �berschriftenzeile ausgeben:
  WRITE: /001 SY-VLINE NO-GAP,
          002(14) TEXT-AI5 COLOR COL_HEADING INTENSIFIED ON,
          016(1)  SY-VLINE NO-GAP,
          017(51) TEXT-AI6 COLOR COL_HEADING INTENSIFIED ON,
          068(1)  SY-VLINE NO-GAP,
          069(20) TEXT-AI7 COLOR COL_HEADING INTENSIFIED ON,
          089(1)  SY-VLINE NO-GAP,
          090(8)  TEXT-AI8 COLOR COL_HEADING INTENSIFIED ON,
          098(18) SPACE NO-GAP,
          130(1)  SY-VLINE NO-GAP.

* 1. �berschriftenzeile erg�nzen f�r Regel Massen�nderung
  IF NOT HLP_SUBSID  IS INITIAL.
    WRITE: /001 SY-VLINE NO-GAP,
            002(14) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            016(1)  SY-VLINE NO-GAP,
            017(51) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            068(1)  SY-VLINE NO-GAP,
            069(20) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            089(1)  SY-VLINE NO-GAP,
            090(40) TEXT-AIA COLOR COL_HEADING INTENSIFIED ON,
            130(1)  SY-VLINE NO-GAP.
  ENDIF.

* 1. �berschriftenzeile erg�nzen f�r Massenabgang
  IF NOT HLP_BWASL   IS INITIAL.
    WRITE: /001 SY-VLINE NO-GAP,
            002(14) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            016(1)  SY-VLINE NO-GAP,
            017(51) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            068(1)  SY-VLINE NO-GAP,
            069(20) SPACE    COLOR COL_HEADING INTENSIFIED ON,
            089(1)  SY-VLINE NO-GAP,
            090(40) TEXT-AIB COLOR COL_HEADING INTENSIFIED ON,
            130(1)  SY-VLINE NO-GAP.
  ENDIF.

  WRITE: /         SY-ULINE.

* 2. �berschriftenzeile.
  WRITE: /001  SY-VLINE NO-GAP,
          002(14)  WI_HEADER-WI_ID
                   COLOR COL_NORMAL INTENSIFIED OFF,
          016(1)   SY-VLINE NO-GAP,
          017(51)  WI_HEADER-WI_TEXT
                   COLOR COL_NORMAL INTENSIFIED OFF,
          068(1)   SY-VLINE NO-GAP,
          069(20)  HLP_STAT_TXT
                   COLOR COL_NORMAL INTENSIFIED OFF,
          089(1)   SY-VLINE NO-GAP,
          090(40)  HLP_TASK_TXT
                   COLOR COL_NORMAL INTENSIFIED OFF,
          130(1)   SY-VLINE NO-GAP.


* 2. �berschriftenzeile erg�nzen f�r Regel Massen�nderung
  IF NOT HLP_SUBSID  IS INITIAL.
    WRITE: /001      SY-VLINE NO-GAP,
            002(14)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            002(14)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            016      SY-VLINE NO-GAP,
            017(51)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            068      SY-VLINE NO-GAP,
            069(20)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            089      SY-VLINE NO-GAP,
            090(07)  HLP_SUBSID
                     COLOR COL_NORMAL INTENSIFIED OFF,
            097(01)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            098(32)  HLP_SUBSTEXT
                     COLOR COL_NORMAL INTENSIFIED OFF,
            130(1)   SY-VLINE NO-GAP.
  ENDIF.

* 2. �berschriftenzeile erg�nzen bei Massenabgang
  IF NOT HLP_BWASL   IS INITIAL.
    WRITE: /001      SY-VLINE NO-GAP,
            002(14)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            002(14)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            016      SY-VLINE NO-GAP,
            017(51)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            068      SY-VLINE NO-GAP,
            069(20)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            089      SY-VLINE NO-GAP,
            090(10)  HLP_BUDAT        DD/MM/YYYY
                     COLOR COL_NORMAL INTENSIFIED OFF,
            100(01)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            101(03)  HLP_BWASL
                     COLOR COL_NORMAL INTENSIFIED OFF,
            104(01)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            105(19)  HLP_ERBDM        CURRENCY  HLP_WAERS
                     COLOR COL_NORMAL INTENSIFIED OFF,
            123(01)  SPACE
                     COLOR COL_NORMAL INTENSIFIED OFF,
            124(06)  HLP_VBUND        USING NO EDIT MASK
                     COLOR COL_NORMAL INTENSIFIED OFF,
            130(1)   SY-VLINE NO-GAP.
  ENDIF.

  WRITE: /         SY-ULINE.

  SKIP.

* �berschrift nur ausgeben, wenn Zeile vorhanden.
  LOOP AT CONT_INFO
       WHERE XDRUCK  = 'X'           " Info andrucken.
         AND XHEADER = 'X'.          " Kopf- und keine Zeileninfo.
  ENDLOOP.
  CHECK SY-SUBRC = 0.

* �berschriftenzeile ausgeben.
  FORMAT RESET.
  WRITE: /000(88) SY-ULINE.

* Formatangaben.
  FORMAT COLOR  COL_HEADING INTENSIFIED ON.

    WRITE: /001 SY-VLINE NO-GAP,
            002 TEXT-AI2,
            026 SY-VLINE,
            027 TEXT-AI3,
            047 SY-VLINE,
            048 TEXT-AI4,
            088 SY-VLINE.

  FORMAT RESET.
  WRITE: /00(88) SY-ULINE.


* Erg�nzende Informationen zum Arbeitsvorrat ausgeben.
  LOOP AT CONT_INFO
       WHERE XDRUCK  = 'X'           " Info andrucken.
         AND XHEADER = 'X'.          " Kopf- und keine Zeileninfo.

    WRITE: /001     SY-VLINE NO-GAP,
            002(24) CONT_INFO-SCRTEXT_L
                    COLOR COL_KEY INTENSIFIED ON,
            026     SY-VLINE NO-GAP.

*    Abh. vom Datentyp andere Ausgabenaufbereitung.
     CASE CONT_INFO-INTTYPE.
*      WHEN 'D'.
*         �bertragung in Hilfsfeld.
*         HLP_DAT = CONT_INFO-VALUE(10).
*
*         WRITE: 027(10) HLP_DAT DD/MM/YYYY NO-GAP
*                        COLOR COL_NORMAL INTENSIFIED OFF,
*                037(10) SPACE NO-GAP
*                        COLOR COL_NORMAL INTENSIFIED OFF.
       WHEN 'P'.
*         �bertragung in Hilfsfeld.
          HLP_WERT = CONT_INFO-VALUE.

          WRITE: 027(15) HLP_WERT CURRENCY SAV_WAER1 NO-GAP
                         COLOR COL_NORMAL INTENSIFIED OFF,
                 042(05) SPACE NO-GAP
                         COLOR COL_NORMAL INTENSIFIED OFF.
       WHEN OTHERS.
          WRITE 027(20) CONT_INFO-VALUE NO-GAP
                        COLOR COL_NORMAL  INTENSIFIED OFF.
     ENDCASE.
*    Unabh�ngige Ausgabe.
    WRITE:  047      SY-VLINE NO-GAP,
            048(40)  CONT_INFO-BEZ   COLOR COL_NORMAL INTENSIFIED OFF,
            088      SY-VLINE.
  ENDLOOP.
    FORMAT RESET.
    WRITE  /000(88) SY-ULINE.

ENDFORM.

* Bezeichnung der aktuellen Aufgabe lesen.
FORM TASK_TXT_LESEN USING TASK_ID BEZ.

* Hilfsfeld: Aufgabe.
DATA: HLP_TASK LIKE SWZAI-DEF_TASK.

* Hilfsfeld f�llen.
  HLP_TASK = TASK_ID.

* Feld: Aufgabenkennung.
  SELECT SINGLE * FROM HRS1000
         WHERE LANGU   = SY-LANGU
           AND OBJID   = HLP_TASK+2(8)
           AND OTYPE   = HLP_TASK(2).
* Text �bertragen
  IF SY-SUBRC = 0.
    BEZ = HRS1000-STEXT.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  STAT_TXT_LESEN
*&---------------------------------------------------------------------*
*       Statustext zum Arbeitsvorrat lesen.                            *
*----------------------------------------------------------------------*
*  -->  status    Aktueller Status des AV
*  <--  txt       Text des Arbeitsvorrats.
*----------------------------------------------------------------------*
FORM STAT_TXT_LESEN USING STATUS TXT.

* Holen Statustext.
  READ TABLE XSTTXT WITH KEY LANGUAGE = SY-LANGU
                             WI_STATUS = STATUS.

  IF SY-SUBRC = 0.
    TXT = XSTTXT-STATUSTEXT.
  ENDIF.

ENDFORM.                    " STAT_TXT_LESEN

*&---------------------------------------------------------------------*
*&      Form  STATUS_LESEN
*&---------------------------------------------------------------------*
*       Zeilenstatus lesen.                                            *
*----------------------------------------------------------------------*
FORM STATUS_LESEN.

*     Lokale Hilfsstruktur: Schl�ssel.
DATA: BEGIN OF L_KEY_OBJID,
        LOGSYS LIKE SWOTOBJID-LOGSYS,
        OBJTYPE LIKE SWOTOBJID-OBJTYPE,
        OBJKEY  LIKE SWOTOBJID-OBJKEY,
      END OF L_KEY_OBJID.

*     Lokale Hilfsstruktur: Anlagenkey.
DATA: BEGIN OF L_ASSET_KEY,
        BUKRS LIKE ANLA-BUKRS,
        ANLN1 LIKE ANLA-ANLN1,
        ANLN2 LIKE ANLA-ANLN2,
      END OF L_ASSET_KEY.


* Key f�llen.
  L_ASSET_KEY-BUKRS = ANLAV-BUKRS.
  L_ASSET_KEY-ANLN1 = ANLAV-ANLN1.
  L_ASSET_KEY-ANLN2 = ANLAV-ANLN2.

  L_KEY_OBJID-OBJKEY  = L_ASSET_KEY.
  L_KEY_OBJID-LOGSYS  = SY-SYSID.
  L_KEY_OBJID-OBJTYPE = 'BUS1022'.

  READ TABLE AI_LINES WITH KEY L_KEY_OBJID BINARY SEARCH.
  IF SY-SUBRC = 0.
    PERFORM STAT_TXT_LESEN USING AI_LINES-STATUS STAT_TXT.
  ELSE.
    CLEAR STAT_TXT.
  ENDIF.

ENDFORM.                    " STATUS_LESEN

*&---------------------------------------------------------------------*
*&      Form  STATUSTAB_LESEN
*&---------------------------------------------------------------------*
*       Statustabelle des AV lesen.                                    *
*----------------------------------------------------------------------*
FORM STATUSTAB_LESEN.

  SELECT * FROM SWWSTATEXT INTO TABLE XSTTXT
         WHERE LANGUAGE = SY-LANGU.

ENDFORM.                    " STATUSTAB_LESEN


*&---------------------------------------------------------------------*
*&      Form  ARBVOR_FREIGEBEN
*&---------------------------------------------------------------------*
*       Freigeben des Arbeitsvorrats                                   *
*----------------------------------------------------------------------*
FORM ARBVOR_FREIGEBEN.
*     Antwortfeld.
DATA: L_ANTWORT(1).
*     Indexfeld.
DATA: L_TABIX LIKE SY-TABIX.

* Lokales Hilfsfeld f�r aktuellen Benutzer
DATA: LD_USER LIKE SY-UNAME.

  CHECK REPORT = 'RAWORK01'.

* Nur bei Bearbeitung
  CHECK NOT FLG_UPD IS INITIAL.

* Wenn WF nicht aktiv erfolgt hier ein Jobeinplanung
* f�r den Arbeitsvorrat.
* �nderungen der Zeilen
  DESCRIBE TABLE XASSET_STAT LINES L_TABIX.

* �nderungen durchgef�hrt?
  IF FLG_ERLP = '1' OR
     FLG_AVKOPF = 'X' OR
     L_TABIX > 0.
*   Arbeitsvorrat vor dem Freigeben Sichern.
    MESSAGE I467 WITH PA_AI_ID.
    EXIT.
  ENDIF.

* Arbeitsvorrat freigeben.
  CALL FUNCTION 'SWZ_AI_RELEASE'
       EXPORTING
            WI_ID            = PA_AI_ID
       EXCEPTIONS
            ALREADY_RELEASED = 1
            EXECUTION_FAILED = 2
            READ_FAILED      = 3
            OTHERS           = 4.

* Bei Fehler Systemmeldung ausgeben
  IF SY-SUBRC = 0.
*   Keine weiteren �nderungen mehr.
    CLEAR FLG_UPD.
*   AV freigegeben.
    AI_HEADER-RELEASED = 'X'.
*   Neuen PF-Status setzen.
    PERFORM PF_STATUS_SETZEN.
  ELSE.
    MESSAGE ID SY-MSGID       TYPE SY-MSGTY      NUMBER SY-MSGNO
            WITH SY-MSGV1     SY-MSGV2
                 SY-MSGV3     SY-MSGV4.
*   Routine verlassen, da Fehler aufgetreten.
    EXIT.
  ENDIF.

  IF FLG_WFAKTIV IS INITIAL.

    CALL FUNCTION 'SWW_WI_EXECUTE_NEW'
         IN BACKGROUND TASK
         EXPORTING
              WI_ID                     = PA_AI_ID.
*        importing
*             return                    =
*             wi_result                 =
*        TABLES
*             WI_CONTAINER              =
*        exceptions
*             execution_failed          = 1
*             invalid_status            = 2
*             invalid_type              = 3
*             others                    = 4.
    COMMIT WORK.
  ENDIF.

ENDFORM.                    " ARBVOR_FREIGEBEN

* Fehlernachrichten anzeigen, die beim Ausf�hren des AV aufgetreten
* sind. Verwendung des Message-Handlers.
FORM AV_FEHLER_ANZEIGEN.
TABLES: SWZAIRET.

* Tabelle zur Aufnahme der FM
DATA: XSWZAIRET LIKE SWZAIRET OCCURS 0 WITH HEADER LINE.

* Zeile f�r Message-Handler
DATA: LD_ZEILE LIKE MESG-ZEILE,
      L_MSGNO LIKE MESG-TXTNR,
      L_MSGTY LIKE MESG-MSGTY,
      L_ARBGB LIKE MESG-ARBGB,

      L_ANLN1 LIKE ANLAV-ANLN1,
      L_ANLN2 LIKE ANLAV-ANLN2,
      L_BUKRS LIKE ANLAV-BUKRS.
*
DATA: L_MSGTXT LIKE SYST-MSGV1.

* Fehlertab. lesen.
  SELECT * FROM SWZAIRET INTO TABLE XSWZAIRET
         WHERE AI_ID = PA_AI_ID
         ORDER BY PRIMARY KEY.

* Wurden Fehler gefunden?
  READ TABLE XSWZAIRET INDEX 1.
  IF SY-SUBRC = 0.
     CALL FUNCTION 'MESSAGES_ACTIVE'
          EXCEPTIONS
               NOT_ACTIVE   = 1
               OTHERS       = 2.
*    Message-Handler nur einmal f�llen.
     IF SY-SUBRC <> 0.
*      Pro Anlage eine Zeile ausgeben
       LD_ZEILE = 0.
*      Message Handler aktivieren.
       CALL FUNCTION 'MESSAGES_INITIALIZE'.

*     alle Fehler gesammelt anzeigen.
      LOOP AT XSWZAIRET.
*       Pro Zeile eine Anlage
        ADD 1 TO LD_ZEILE.
*       1 Message pro Anlage
        WRITE TEXT-MH1 TO L_MSGTXT.
        L_BUKRS = XSWZAIRET-OBJECTID+20(004).
        L_ANLN1 = XSWZAIRET-OBJECTID+24(012).
        L_ANLN2 = XSWZAIRET-OBJECTID+36(004).
*       Sammelnachricht ersetzen
        REPLACE '&' WITH L_BUKRS INTO L_MSGTXT.
        REPLACE '&' WITH L_ANLN1 INTO L_MSGTXT.
        REPLACE '&' WITH L_ANLN2 INTO L_MSGTXT.
        CALL FUNCTION 'MESSAGE_STORE'
             EXPORTING
                  ARBGB                   = 'AC'
                  MSGTY                   = 'S'
                  MSGV1                   = L_MSGTXT
                  TXTNR                   = '899'
                  ZEILE                   = LD_ZEILE
             EXCEPTIONS
                  MESSAGE_TYPE_NOT_VALID  = 1
                  NOT_ACTIVE              = 2
                  OTHERS                  = 3.
*       eigentlicher Fehler
        L_MSGNO = XSWZAIRET-MESSAGE.
*       Fehler h�ufig mit Systemcodes angezeigt.
*       Im Zweifel als Fehler ausgeben.
        IF L_MSGTY <> 'E' OR
           L_MSGTY <> 'A' OR
           L_MSGTY <> 'W' OR
           L_MSGTY <> 'I' OR
           L_MSGTY <> 'S'.
          L_MSGTY = 'E'.
        ELSE.
          L_MSGTY = XSWZAIRET-ERRORTYPE.
        ENDIF.
*       Altlast Fehler
        IF L_MSGNO = '801'            AND
           XSWZAIRET-WORKAREA = 'AY'.
          L_MSGNO = XSWZAIRET-VARIABLE2.
          L_ARBGB = XSWZAIRET-VARIABLE1.
          XSWZAIRET-VARIABLE1 = XSWZAIRET-VARIABLE3.
          XSWZAIRET-VARIABLE2 = XSWZAIRET-VARIABLE4.
        ELSE.
          L_ARBGB = XSWZAIRET-WORKAREA.
        ENDIF.
        CALL FUNCTION 'MESSAGE_STORE'
             EXPORTING
                  ARBGB                   = L_ARBGB
                  MSGTY                   = L_MSGTY
                  MSGV1                   = XSWZAIRET-VARIABLE1
                  MSGV2                   = XSWZAIRET-VARIABLE2
                  MSGV3                   = XSWZAIRET-VARIABLE3
                  MSGV4                   = XSWZAIRET-VARIABLE4
                  TXTNR                   = L_MSGNO
                  ZEILE                   = LD_ZEILE
             EXCEPTIONS
                  MESSAGE_TYPE_NOT_VALID  = 1
                  NOT_ACTIVE              = 2
                  OTHERS                  = 3.
         IF SY-SUBRC NE 0.

         ENDIF.
      ENDLOOP.
    ENDIF.
    CALL FUNCTION 'MESSAGES_SHOW'
         EXCEPTIONS
              INCONSISTENT_RANGE    = 1
              NO_MESSAGES           = 2
              OTHERS                = 3.
  ELSE.
    MESSAGE I766(WL).
  ENDIF.

ENDFORM.

* Bei Ver�nderungen am Arbeitsvorrat diese Ver�nderungen
* zeigen.
FORM DATEN_AUFFRISCHEN.

* Tabelle f�r aktuelle Select-Optionen
DATA: L_XSELECTS LIKE RSPARAMS OCCURS 0 WITH HEADER LINE.
* Aktueller Reportname
DATA: L_REPORT LIKE SY-REPID.
* Antwort
DATA: L_ANTWORT(1).


* Zeilen�nderungen durchgef�hrt?
  DESCRIBE TABLE XASSET_STAT LINES L_LINES.

* Bei vorhergehenden �nderungen vorher sichern.
  IF FLG_AVKOPF = 'X' OR
     FLG_ERLP = '1' OR
     L_LINES > 0.
*   Soll gesichert werden?
    CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
         EXPORTING
*             DEFAULTOPTION  = 'Y'
              DIAGNOSETEXT1  = TEXT-SV1
*             DIAGNOSETEXT2  = ' '
*             DIAGNOSETEXT3  = ' '
              TEXTLINE1      = TEXT-SV2
*             TEXTLINE2      = ' '
              TITEL          = TEXT-SV0
         IMPORTING
              ANSWER         = L_ANTWORT
         EXCEPTIONS
              OTHERS         = 1.
    CASE L_ANTWORT.
      WHEN 'J'.
        PERFORM DATEN_SICHERN.
      WHEN 'N'.
*       Nicht sichern, nur auffrischen.
      WHEN 'A'.
*       Routine verlassen.
        EXIT.
    ENDCASE.
  ENDIF.



* Aktuellen Namen besorgen
  L_REPORT = SY-REPID.

* Aktuelle Selektionen besorgen
  CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
       EXPORTING
            CURR_REPORT     = L_REPORT
       TABLES
            SELECTION_TABLE = L_XSELECTS
       EXCEPTIONS
            NOT_FOUND       = 1
            NO_REPORT       = 2
            OTHERS          = 3.
* Report wird neu aufgerufen, um die Daten zu aktualisieren.
  SUBMIT RAWORK01 WITH SELECTION-TABLE L_XSELECTS.


ENDFORM.


* �nderungen des AV auf der DB fortschreiben
FORM DATEN_SICHERN.

*     Abbruchkennzeichen (X=abbrechen).
DATA: L_ABBRUCH(1).
*     Index, ob Anlagen gel�scht wurden.
DATA: LD_TABIX LIKE SY-TABIX.
*     Anzahl der Anlagen im AV
data: hlp_lines type I.                                     "no 359604

* Keine �nderungen durchgef�hrt.
  IF ( FLG_ERLP = 'X'   OR
       FLG_ERLP = ' ' ) AND
     FLG_AVKOPF = ' '.
*
    DESCRIBE TABLE XASSET_STAT LINES LD_TABIX.
    IF LD_TABIX = 0.
      MESSAGE S558.
*     Routine verlassen.
      EXIT.
    ENDIF.
  ENDIF.

* Alle vorgemerkten Anlagen aus dem AV entfernen.
* AV darf aber niemals leer werden
* Zeileninfos des AV lesen.
  CALL FUNCTION 'SWZ_AI_SHOW'
       EXPORTING
            WI_ID            = PA_AI_ID
       TABLES
            OBJECT_LIST      = AI_LINES
       EXCEPTIONS
            EXECUTION_FAILED = 01.
  describe table ai_lines lines hlp_lines.
  LOOP AT XASSET_STAT.
*   Zu l�schende Anlagen aus AV entfernen.
    IF XASSET_STAT-KZ = 'D'.
     if hlp_lines > 1.
      CALL FUNCTION 'AM_ASSET_DELETE_FROM_AI'
           EXPORTING
                I_BUKRS           = XASSET_STAT-BUKRS
                I_ANLN1           = XASSET_STAT-ANLN1
                I_ANLN2           = XASSET_STAT-ANLN2
                I_AI_ID           = PA_AI_ID
                DO_COMMIT         = 'X'
           EXCEPTIONS
                ASSET_NOT_DELETED = 1
                OTHERS            = 2.
        if sy-subrc = 0.
          hlp_lines = hlp_lines - 1.
        endif.
      else.
*       message E471(AB) with XASSET_STAT-ANLN1 XASSET_STAT-ANLN2.
      endif.
     ENDIF.
*    Einzuf�gende Anlagen in AV einf�gen.
     IF XASSET_STAT-KZ = 'I'.
       CALL FUNCTION 'AM_ASSET_INSERT_INTO_AI'
            EXPORTING
                 I_BUKRS            = XASSET_STAT-BUKRS
                 I_ANLN1            = XASSET_STAT-ANLN1
                 I_ANLN2            = XASSET_STAT-ANLN2
                 I_AI_ID            = PA_AI_ID
                 DO_COMMIT          = 'X'
            EXCEPTIONS
                 ASSET_NOT_INSERTED = 1
                 OTHERS             = 2.
       if sy-subrc = 0.
         hlp_lines = hlp_lines + 1.
       endif.
     ENDIF.
   ENDLOOP.


* Bei Abgang mit Erl�s gesonderte Behandlung
  CASE FLG_ERLP.
*   Massen�nderung/abgang ohne Erl�s.
    WHEN ' '.
*   Massenabgang mit Erl�s und autom. Erl�sverteilung.
    WHEN 'X'.
*     Automatische Erl�sverteilung durchf�hren.
      PERFORM ERLOES_NEU_VERTEILEN USING L_ABBRUCH.
*     Bei Auswahl von Abbrechen nichts machen.
      IF L_ABBRUCH = 'X'.
        MESSAGE I455 WITH PA_AI_ID.
        EXIT.
      ENDIF.
*   Manuelle Erl�sverteilung und ge�ndert
    WHEN '1'.
      PERFORM ERLOES_EIGEN_ZURUECKSCHREIBEN USING L_ABBRUCH.
*     Bei Auswahl von Abbrechen nichts machen.
      IF L_ABBRUCH = 'X'.
        MESSAGE I455 WITH PA_AI_ID.
        EXIT.
      ENDIF.
  ENDCASE.


*   Container�nderung auf DB fortschreiben.
    CALL FUNCTION 'SWW_WI_CONTAINER_MODIFY'
         EXPORTING
              WI_ID                = PA_AI_ID
              DO_COMMIT            = 'X'
              DELETE_OLD_CONTAINER = 'X'
         TABLES
              WI_CONTAINER         = AI_CONTAINER
         EXCEPTIONS
              OTHERS               = 1.



* �nderungskennzeichen zur�cknehmen.
* Av-spezifische Daten
  CLEAR FLG_AVKOPF.
* Zeilen�nderungen
  REFRESH XASSET_STAT.
* Verteilte Erl�se.
  FLG_ERLP = 'X'.
* Sichern erfolgreich durchgef�hrt
  MESSAGE S462.
* Automatischer Refresh der Daten
  PERFORM DATEN_AUFFRISCHEN.


ENDFORM.

* Einf�gen einer Zeile in den AV.
* Die Zeile wird nicht sofort einef�gt, sondern nur als
* Einzuf�gen gekennzeichnet. Beim Sichern werden die �nderungen
* auf der Datenbank fortgeschrieben.
FORM RAWORK_ANLAGE_EINFUEGEN_IN_AV.


 DATA: LS_RETURN     TYPE           DDSHRETVAL,
       LT_RETURN     TYPE TABLE OF  DDSHRETVAL.
* DATA: LS_SHLP       TYPE           SHLP_DESCR,
* DATA   WA_SELOPT     LIKE LINE OF   LS_SHLP-SELOPT.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      TABNAME           = 'ANLA'
      FIELDNAME         = 'ANLN2'
      SEARCHHELP        = 'AANL'
      CALLBACK_PROGRAM  = SY-cprog
      CALLBACK_FORM     = 'F4CALLBACK'
    TABLES
      RETURN_TAB        = LT_RETURN
    EXCEPTIONS
      FIELD_NOT_FOUND   = 1
      NO_HELP_FOR_FIELD = 2
      INCONSISTENT_HELP = 3
      NO_VALUES_FOUND   = 4
      OTHERS            = 5.

   if sy-subrc <> 0.
     message E050(AB).
     exit.
   endif.
   read table lt_return with key fieldname = 'ANLN1'
        into ls_return.
   if sy-subrc = 0.
* >>> Begin of change note 573061
     anlav-anln1 = ls_return-fieldval.
     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
       EXPORTING
         input         = anlav-anln1
       IMPORTING
         output        = anlav-anln1.
* <<< End of change note 573061
   else.
     clear anlav-anln1.
     message E050(AB).
     exit.
   endif.
   read table lt_return with key fieldname = 'BUKRS'
        into ls_return.
   if ls_return-fieldval <> anlav-bukrs.
     clear anlav-anln1.
     message I810(AY)
     with anlav-anln1 anlav-bukrs PA_AI_ID ls_return-fieldval.
     exit.
   endif.
   read table lt_return with key fieldname = 'ANLN2'
        into ls_return.
   if sy-subrc = 0.
* >>> Begin of change note 573061
     anlav-anln2 = ls_return-fieldval.
     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
       EXPORTING
         input         = anlav-anln2
       IMPORTING
         output        = anlav-anln2.
* <<< End of change note 573061
   else.
     clear anlav-anln2.
     message E050(AB).
     exit.
   endif.


  READ TABLE XASSET_STAT
        WITH KEY BUKRS = ANLAV-BUKRS
                 ANLN1 = ANLAV-ANLN1
                 ANLN2 = ANLAV-ANLN2 BINARY SEARCH.
* Pr�fen, ob Anlage bereits eingef�gt war.
  CASE SY-SUBRC.
    WHEN 0.
      XASSET_STAT-KZ = 'I'.
      MODIFY XASSET_STAT INDEX SY-TABIX.
*     Anlage wird beim Sichern eingef�gt
      MESSAGE S459 WITH ANLAV-ANLN1 ANLAV-ANLN2.
*   Anlage als zu sichern kennzeichnen.
*   Eintrag neu einf�gen
    WHEN 4.
      XASSET_STAT-BUKRS = ANLAV-BUKRS.
      XASSET_STAT-ANLN1 = ANLAV-ANLN1.
      XASSET_STAT-ANLN2 = ANLAV-ANLN2.
      XASSET_STAT-KZ = 'I'.
      INSERT XASSET_STAT INDEX SY-TABIX.
*     Anlage wird beim Sichern hinzugef�gt.
      MESSAGE S459 WITH ANLAV-ANLN1 ANLAV-ANLN2.
*   Eintrag hinten anh�ngen
    WHEN 8.
      XASSET_STAT-BUKRS = ANLAV-BUKRS.
      XASSET_STAT-ANLN1 = ANLAV-ANLN1.
      XASSET_STAT-ANLN2 = ANLAV-ANLN2.
      XASSET_STAT-KZ = 'I'.
      APPEND XASSET_STAT.
*     Anlage wird beim Sichern hinzugef�gt.
      MESSAGE S459 WITH ANLAV-ANLN1 ANLAV-ANLN2.
  ENDCASE.

* Bei Abgang mit Erl�s, Erl�szeile einf�gen.
  IF FLG_ERLP <> ' '.
*
    READ TABLE XABERL WITH KEY BUKRS = ANLAV-BUKRS
                               ANLN1 = ANLAV-ANLN1
                               ANLN2 = ANLAV-ANLN2 BINARY SEARCH.
*
    IF SY-SUBRC <> 0.
      XABERL-BUKRS = ANLAV-BUKRS.
      XABERL-ANLN1 = ANLAV-ANLN1.
      XABERL-ANLN2 = ANLAV-ANLN2.
      XABERL-ABERL = 0.
      INSERT XABERL INDEX SY-TABIX.
    ENDIF.
  ENDIF.

ENDFORM.


* L�schen einer Zeile aus dem AV.
* Die Zeile wird nicht sofort gel�scht, sondern nur als
* Zu l�schen gekennzeichnet. Beim Sichern werden die �nderungen
* auf der Datenbank fortgeschrieben.
FORM RAWORK_ANLAGE_LOESCHEN_AUS_AV.

* Nur beim Bearbeiten.
  CHECK NOT FLG_UPD IS INITIAL.

  MODIFY CURRENT LINE LINE FORMAT INVERSE ON.

  READ TABLE XASSET_STAT
        WITH KEY BUKRS = ANLAV-BUKRS
                 ANLN1 = ANLAV-ANLN1
                 ANLN2 = ANLAV-ANLN2 BINARY SEARCH.
* Pr�fen, ob Anlage bereits gel�scht war.
  CASE SY-SUBRC.
    WHEN 0.
      XASSET_STAT-KZ = 'D'.
      MODIFY XASSET_STAT INDEX SY-TABIX.
*     Anlage wird beim Sichern gel�scht.
      MESSAGE S454 WITH ANLAV-ANLN1 ANLAV-ANLN2.
*   Anlage als zu l�schen kennzeichnen.
*   Eintrag neu einf�gen
    WHEN 4.
      XASSET_STAT-BUKRS = ANLAV-BUKRS.
      XASSET_STAT-ANLN1 = ANLAV-ANLN1.
      XASSET_STAT-ANLN2 = ANLAV-ANLN2.
      XASSET_STAT-KZ = 'D'.
      INSERT XASSET_STAT INDEX SY-TABIX.
*     Anlage wird beim Sichern aus dem AV entfernt.
      MESSAGE S453 WITH ANLAV-ANLN1 ANLAV-ANLN2.
*   Eintrag hinten anh�ngen
    WHEN 8.
      XASSET_STAT-BUKRS = ANLAV-BUKRS.
      XASSET_STAT-ANLN1 = ANLAV-ANLN1.
      XASSET_STAT-ANLN2 = ANLAV-ANLN2.
      XASSET_STAT-KZ = 'D'.
      APPEND XASSET_STAT.
*     Anlage wird beim Sichern aus dem AV entfernt.
      MESSAGE S453 WITH ANLAV-ANLN1 ANLAV-ANLN2.
  ENDCASE.

* Bei Abgang mit Erl�s->Anlage aus Erl�sverteilung nehmen.
  IF FLG_ERLP <> ' '.
*   Anlage finden.
    LOOP AT XABERL
         WHERE BUKRS = ANLAV-BUKRS
           AND ANLN1 = ANLAV-ANLN1
           AND ANLN2 = ANLAV-ANLN2.
      DELETE XABERL.
      EXIT.
    ENDLOOP.
  ENDIF.

ENDFORM.

* Bei einem Massenabgang mit Erl�s kann der geplante Erl�s
* ge�ndert werden.
FORM AV_ERLOES_PLANEN.

*     Verteiltkennzeichen (A/E/R)
DATA: L_VERKZ(1).
*     Tabellenindex.
DATA: LD_TABIX LIKE SY-TABIX.

* Nur beim Bearbeiten.
  CHECK NOT FLG_UPD IS INITIAL.

* Pr�fen, ob eigene Verteilung durchgef�hrt werden soll.
  SWC_GET_ELEMENT AI_CONTAINER 'verkz' L_VERKZ.

* Sollten Zeilen ge�ndert worden sein,
* muss vorher gesichert werden.
  DESCRIBE TABLE XASSET_STAT LINES LD_TABIX.
  IF LD_TABIX > 0.
    MESSAGE I460.
    EXIT.
  ENDIF.

* Keine eigene Verteilung zulassen.
  IF L_VERKZ <> 'E'.
    MESSAGE I457.
  ELSE.
    IF FLG_ERLP = 'X'.
*     Erl�s kann ver�ndert werden.
      MESSAGE S456.
*     Automatisch geplanter Erl�s ge�ndert.
      FLG_ERLP = '1'.
*     Erl�s-Feld eingabebereit schalten.
      describe list number of lines l_lines.
      DO L_LINES TIMES.
*       Anlagenzeile ausgew�hlt?
        CLEAR RANGE.
*       Nur Anlagenzeilen �ndern.
        READ LINE SY-INDEX.
        IF RANGE = '1'.
          MODIFY LINE SY-INDEX FIELD FORMAT X-ERLP INTENSIFIED INPUT.
        ENDIF.
      ENDDO.
    ENDIF.
  ENDIF.
ENDFORM.

* AV spezifische Informationen, abh. von der Art des AV �ndern.
* Bei Massenabgang m. Erl�s kann BWA / Datum ge�ndert werden
* Bei Massen�nderung die Substitution.
FORM AV_KOPFDATEN_AENDERN.

* Abgang mit/ohne Erl�s.
DATA: FLG_ERL(1).
* AV spezifsche Daten �ndern
DATA:  L_AI_RETURN(1).

* Nur beim Bearbeiten.
  CHECK NOT FLG_UPD IS INITIAL.

  CASE AI_HEADER-DEF_TASK.
*   bei Abgang mit Erl�s.
    WHEN 'TS00007957'.
        FLG_ERL = 'X'.
        PERFORM ABGANG_POPUP_AENDERN  TABLES AI_CONTAINER
                                      USING  FLG_ERL L_AI_RETURN.
*   bei Abgang ohne Erl�s.
    WHEN 'TS00007956'.
        CLEAR FLG_ERL.
        PERFORM ABGANG_POPUP_AENDERN  TABLES AI_CONTAINER
                                      USING  FLG_ERL L_AI_RETURN.
*   bei Massen�nderung.
    WHEN 'TS00007958'.
        PERFORM MASS_POPUP_SCHICKEN TABLES AI_CONTAINER
                                    USING  L_AI_RETURN.
*   bei Massentransfer.
    WHEN 'TS20000303'.
        PERFORM TRANSFER_POPUP_AENDERN TABLES AI_CONTAINER
                                    USING  L_AI_RETURN.
*   die neuen Buchungs-Workflows.
    WHEN OTHERS.
       CHECK NOT AI_STRUCTURE IS INITIAL.
       AI_VARIANT = AI_STRUCTURE(8).
       CALL FUNCTION 'AWFL_CALL_MASS_CHANGE_DATA'
            EXPORTING  I_AI_ID       =  PA_AI_ID
                       I_OBJECT      = 'BUS1022'
                       I_VARIANT     =  AI_VARIANT.
  ENDCASE.

* �nderungen durchf�hren
  IF L_AI_RETURN IS INITIAL.
*   PF-Status neu setzen
    PERFORM PF_STATUS_SETZEN.
    FLG_AVKOPF = 'X'.
* Die Aktion wurde abgebrochen.
  ELSE.
    MESSAGE S050.
  ENDIF.

ENDFORM.


* Beim Verlassen des RAWORK pr�fen, ob der AV
* ge�ndert wurde.
FORM AV_BEARBEITUNG_BEENDEN.

* Tabelle f�r aktuelle Select-Optionen
DATA: L_XSELECTS LIKE RSPARAMS OCCURS 0 WITH HEADER LINE.
* Aktueller Reportname
DATA: L_REPORT LIKE SY-REPID.
*     Antwortfeld.
DATA: L_ANTWORT(1).
*     Antwortfeld.
DATA: L_ANSWER(1).
*     Indexfeld.
DATA: L_TABIX LIKE SY-TABIX.

* Aktuellen Namen besorgen
  L_REPORT = SY-REPID.

* Nur Anzeigen erlaubt.
  IF FLG_UPD IS INITIAL.
*   Bei Aufruf �ber WF grundsaetzlich direkter Ruecksprung.
    IF NOT G_WF_CALL IS INITIAL.
*     R�ckgabewert an rufendes Pgm. im WF zur�ckgeben...
      G_WF_RET = 0.
      EXPORT G_WF_CALL G_WF_RET TO MEMORY ID 'am_ai'.
*     Programm direkt verlassen.
      LEAVE.
    ELSE.
*     Aktuelle Selektionen f�r neuen Aufruf besorgen.
      PERFORM SELECTOPTIONS_BESORGEN TABLES L_XSELECTS
                                      USING L_REPORT.

*     Verzweigung wie F3 zum Selektionsbild.
      SUBMIT RAWORK01 WITH SELECTION-TABLE L_XSELECTS
                      VIA SELECTION-SCREEN.
    ENDIF.
  ENDIF.

* �nderungen der Zeilen
  DESCRIBE TABLE XASSET_STAT LINES L_TABIX.

* �nderungen durchgef�hrt?
  IF FLG_ERLP = '1' OR
     FLG_AVKOPF = 'X' OR
     L_TABIX > 0.
*   Sicherheitsabfrage
    CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
         EXPORTING
              TEXTLINE1    = TEXT-LS2
*             TEXTLINE2    = ' '
              TITEL        = TEXT-LS1
         IMPORTING
              ANSWER       = L_ANTWORT
         EXCEPTIONS
              OTHERS       = 1.

*   Programm verlassen.
    IF L_ANTWORT = 'J'.
    ELSE.
*     Routine verlassen und zur�ckkehren.
      EXIT.
    ENDIF.
  ENDIF.

*  AV ist noch nicht freigegeben.
   IF AI_HEADER-RELEASED IS INITIAL.
*     AV zur�cklegen
      CALL FUNCTION 'SWW_WI_BACK'
           EXPORTING
                WI_ID                       = PA_AI_ID
*             DO_COMMIT                   = 'X'
*        IMPORTING
*             NEW_STATUS                  =
           EXCEPTIONS
                INFEASIBLE_STATE_TRANSITION = 1
                INVALID_TYPE                = 2
                UPDATE_FAILED               = 3
                OTHERS                      = 4.
  ENDIF.

* Keine �nderungen durchgef�hrt-> Routine verlassen.
* Aufruf ueber WF
  IF NOT G_WF_CALL IS INITIAL.
*   AV-Korrektur/abgeschlossen nur bei Editieren ...
    IF G_WF_CALL = 'E' AND
*      Abbrechen angew�hlt.
       SY-UCOMM = 'MCAN'.
     CLEAR L_ANSWER.
     CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
          EXPORTING  DEFAULTOPTION = 'Y'
                     TEXTLINE1     = TEXT-A01
                     TEXTLINE2     = TEXT-A02
                     TITEL         = TEXT-A03
*                    START_COLUMN  = 25
*                    START_ROW     = 6
          IMPORTING  ANSWER        = L_ANSWER.
      CASE L_ANSWER.
         WHEN 'N'.  G_WF_RET = 4.
         WHEN 'Y'.  G_WF_RET = 0.
         WHEN 'J'.  G_WF_RET = 0.
*        Im Programm bleiben
         WHEN OTHERS. CHECK 'A' = 'B'.
      ENDCASE.
    ENDIF.
*   Informationen an WF-Rufer AM_AI zur�ckgeben.
    EXPORT G_WF_CALL G_WF_RET TO MEMORY ID 'am_ai'.
*   Programm verlassen
    LEAVE.
* normaler Ruecksprung.
  ELSE.
*   Aktuelle Selektionen f�r neuen Aufruf besorgen.
    PERFORM SELECTOPTIONS_BESORGEN TABLES L_XSELECTS
                                   USING L_REPORT.

*   Verzweigung wie F3 zum Selektionsbild.
    SUBMIT RAWORK01 WITH SELECTION-TABLE L_XSELECTS
                    VIA SELECTION-SCREEN.
  ENDIF.

ENDFORM.



* Besorgen der aktuellen Selektionen.
FORM SELECTOPTIONS_BESORGEN TABLES U_XSELECTS STRUCTURE RSPARAMS
                            USING  VALUE(U_LD_REPORT).

* Aktuelle Selektionen besorgen
  CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
       EXPORTING
            CURR_REPORT     = U_LD_REPORT
       TABLES
            SELECTION_TABLE = U_XSELECTS
       EXCEPTIONS
            NOT_FOUND       = 1
            NO_REPORT       = 2
            OTHERS          = 3.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM Transfer_POPUP_AENDERN                                   *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  CONTAINER                                                     *
*  -->  AI_RETURN                                                     *
*---------------------------------------------------------------------*
FORM TRANSFER_POPUP_AENDERN  TABLES CONTAINER STRUCTURE SWCONT
                             USING  AI_RETURN.
* Felder
DATA: RETURNCODE LIKE ANLA-ANUPD.
DATA: L_TRPARA LIKE FIAA_TRANS_PARA.

  SWC_GET_ELEMENT CONTAINER 'Trpara'    L_TRPARA.    " Parameter


* Message "Bitte �ndern Sie die Kopfinformationen durch �berschreiben"
  MESSAGE S464.
* Popup aufrufen.
  CALL FUNCTION 'POPUP_TO_GET_AI_VALUES_TRANSF'
       EXPORTING    I_WAERS    = T093B-WAERS
       IMPORTING    ABBRUCH_KZ = RETURNCODE
       CHANGING     F_TRPARA   = L_TRPARA.

  IF RETURNCODE = 'A'.
    " Kennzeichen setzen, AV nicht anzulegen.
    AI_RETURN = 'X'.
                                       " Verlassen der Form-Routine.
    EXIT.
  ENDIF.

* Message: "Kopfinformationen werden beim Sichern ge�ndert"
  MESSAGE S465.
* �bertragen der eingegebenen Werte in den Daten-Container.
  SWC_SET_ELEMENT CONTAINER 'Trpara'    L_TRPARA.    " Parameter

ENDFORM.

*---------------------------------------------------------------------*
*       FORM ABGANG_POPUP_SCHICKEN                                    *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  CONTAINER                                                     *
*  -->  FLG_ERL                                                       *
*  -->  AI_RETURN                                                     *
*---------------------------------------------------------------------*
FORM ABGANG_POPUP_AENDERN  TABLES CONTAINER STRUCTURE SWCONT
                           USING  FLG_ERL AI_RETURN.

* return value.
  DATA  RETURNCODE(1)  TYPE C.
* Felder des Abgangs,
  DATA:
    L_BUDAT LIKE RA01B-BUDAT,
    L_BLDAT LIKE RA01B-BLDAT,
    L_BWASL LIKE ANBZ-BWASL,
    L_ERBDM LIKE ANBZ-ERBDM,
    L_BZDAT LIKE ANBZ-BZDAT,
    L_VBUND LIKE ANBZ-VBUND,
* Verteilkennzeichen.
    L_VERKZ(1).

* �bertragen der Container-Daten auf das Abgangsbild
  SWC_GET_ELEMENT CONTAINER 'bldat'    L_BLDAT.    " Belegdatum
  SWC_GET_ELEMENT CONTAINER 'bwasl'    L_BWASL.    " Bewegungsart
  SWC_GET_ELEMENT CONTAINER 'bzdat'    L_BZDAT.    " Bezugsdatum
  SWC_GET_ELEMENT CONTAINER 'budat'    L_BUDAT.    " Buchungsdatum
  SWC_GET_ELEMENT CONTAINER 'erbdm'    L_ERBDM.    " Erl�sbetrag
  SWC_GET_ELEMENT CONTAINER 'verkz'    L_VERKZ.    " Verteilkennzeichen.
  SWC_GET_ELEMENT CONTAINER 'vbund'    L_VBUND.    " Verbundkennzeichen.

* Message "Bitte �ndern Sie die Kopfinformationen durch �berschreiben"
  MESSAGE S464.

* Popup aufrufen.
  CALL FUNCTION 'POPUP_TO_GET_AI_VALUES'
       EXPORTING
            I_ERLKZ    = FLG_ERL
            I_BUDAT    = L_BUDAT
            I_BLDAT    = L_BLDAT
            I_BWASL    = L_BWASL
            I_ERBDM    = L_ERBDM
            I_BZDAT    = L_BZDAT
            I_VERKZ    = L_VERKZ
            I_VBUND    = L_VBUND
            I_WAERS    = T093B-WAERS
       IMPORTING
            E_BUDAT    = L_BUDAT
            E_BLDAT    = L_BLDAT
            E_BWASL    = L_BWASL
            E_ERBDM    = L_ERBDM
            E_BZDAT    = L_BZDAT
            ABBRUCH_KZ = RETURNCODE
            E_VERKZ    = L_VERKZ
            E_VBUND    = L_VBUND.

  IF RETURNCODE = 'A'.
    " Kennzeichen setzen, AV nicht anzulegen.
    AI_RETURN = 'X'.
                                      " Verlassen der Form-Routine.
    EXIT.
  ENDIF.

* Message: "Kopfinformationen werden beim Sichern ge�ndert"
  MESSAGE S465.

* R�cknahme manuelle Erl�sverteilung, wenn aktiv.
  IF FLG_ERLP = '1' AND
     L_VERKZ <> 'E'.
    PERFORM ERLOES_EIGEN_DEAKTIVIEREN.
  ENDIF.

* �bertragen der eingegebenen Werte in den Daten-Container.
  SWC_SET_ELEMENT CONTAINER 'bldat'    L_BLDAT.    " Belegdatum
  SWC_SET_ELEMENT CONTAINER 'bwasl'    L_BWASL.    " Bewegungsart
  SWC_SET_ELEMENT CONTAINER 'bzdat'    L_BZDAT.    " Bezugsdatum
  SWC_SET_ELEMENT CONTAINER 'budat'    L_BUDAT.    " Buchungsdatum
  SWC_SET_ELEMENT CONTAINER 'erbdm'    L_ERBDM.    " Erl�sbetrag
  SWC_SET_ELEMENT CONTAINER 'verkz'    L_VERKZ.    " Verteilkennzeichen.
  SWC_SET_ELEMENT CONTAINER 'vbund'    L_VBUND.    " Verbundkennzeichen.

ENDFORM.


* Eigene Erl�sverteilung Eingabe zur�cknehmen.
FORM ERLOES_EIGEN_DEAKTIVIEREN.

* Flag: Automatisch geplanter Erl�s ge�ndert zur�cknehmen.
  FLG_ERLP = 'X'.
* Erl�s-Feld eingabebereit schalten.
  DO L_LINES TIMES.
*       Anlagenzeile ausgew�hlt?
        CLEAR RANGE.
*       Nur Anlagenzeilen �ndern.
        READ LINE SY-INDEX.
        IF RANGE = '1'.
          MODIFY LINE SY-INDEX FIELD FORMAT X-ERLP INTENSIFIED OFF
                                                   INPUT OFF.
        ENDIF.
  ENDDO.

ENDFORM.


* Durch �nderungen am AV wird eine Neuverteilung notwendig.
FORM ERLOES_NEU_VERTEILEN USING U_ABBRUCH.

* Felder des Abgangs,
  DATA:
    L_BUDAT LIKE RA01B-BUDAT,
    L_BLDAT LIKE RA01B-BLDAT,
    L_BWASL LIKE ANBZ-BWASL,
    L_ERBDM LIKE ANBZ-ERBDM,
    L_BZDAT LIKE ANBZ-BZDAT,
    L_VBUND LIKE ANBZ-VBUND,
* Verteilkennzeichen.
    L_VERKZ(1).

* Neuer Erl�sbetrag bei eigener Erl�sverteilung.
DATA: LD_GERLBT LIKE ANLCV-GJE_BCHWRT.

* Hilfsfelder f�r W�hrungsausgabe
DATA:  L_ERBDM_CUR(16),
       LD_GERLBT_CUR(16).

* �bertragen der eingegebenen Werte in den Daten-Container.
  SWC_GET_ELEMENT AI_CONTAINER 'bldat'    L_BLDAT.    " Belegdatum
  SWC_GET_ELEMENT AI_CONTAINER 'bwasl'    L_BWASL.    " Bewegungsart
  SWC_GET_ELEMENT AI_CONTAINER 'bzdat'    L_BZDAT.    " Bezugsdatum
  SWC_GET_ELEMENT AI_CONTAINER 'budat'    L_BUDAT.    " Buchungsdatum
  SWC_GET_ELEMENT AI_CONTAINER 'erbdm'    L_ERBDM.    " Erl�sbetrag
  SWC_GET_ELEMENT AI_CONTAINER 'verkz'    L_VERKZ. " Verteilkennzeichen.

* Autom. Erl�sverteilung durchf�hren?
  IF L_VERKZ <> 'E'.

*   Erl�se automatisch neu verteilen
    CALL FUNCTION 'AM_PROFIT_DISTRIBUTION'
         EXPORTING
              I_BWASL = L_BWASL
              I_BZDAT = L_BZDAT
              I_BUDAT = L_BUDAT
              I_BLDAT = L_BLDAT
              I_ERBDM = L_ERBDM
              I_AI_ID = PA_AI_ID
              I_VERKZ = L_VERKZ
         TABLES
              T_ABERL = XABERL
         EXCEPTIONS
              ERROR_MESSAGE = 1
              OTHERS  = 2.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE 'I' NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2
                   SY-MSGV3 SY-MSGV4.
      U_ABBRUCH = 'X'.
    ENDIF.
  ELSE.
*   Pr�fen, Erl�sbtrg. durch Zeilen l�schen ver�ndert wurde
*   und entsprechend anpassen.
    LOOP AT XABERL.
      LD_GERLBT = LD_GERLBT + XABERL-ABERL.
    ENDLOOP.
*         neuer Erl. vs. alter Erl.
    IF LD_GERLBT <> L_ERBDM.
      WRITE LD_GERLBT TO LD_GERLBT_CUR CURRENCY SAV_WAER1.
      WRITE L_ERBDM TO L_ERBDM_CUR CURRENCY SAV_WAER1.
*     Erl�sbetrag wurde ge�ndert.
      MESSAGE I466 WITH L_ERBDM_CUR
                        LD_GERLBT_CUR.
*     Sichern abbrechen.
      U_ABBRUCH = 'X'.
*     Routine verlassen
      EXIT.
    ENDIF.
  ENDIF.

* Erl�sverteilung auf jeden Fall zur�ckschreiben.
  SWC_SET_TABLE AI_CONTAINER 'xaberl' XABERL.

ENDFORM.


*
FORM ERLOES_EIGEN_ZURUECKSCHREIBEN USING U_ABBRUCH.

* Hilfsfeld zur Aufnahme des Erl�ses
DATA: L_ERLP(15).
* Hilfsfeld zur R�ckkonvertierung
DATA: L_ERLBT LIKE ANLCV-GJE_BCHWRT.
* Hilfsfeld: Alter Gesamterl�s
DATA: L_ERBDM LIKE ANLCV-GJE_BCHWRT.
* Hilfsfeld: Neuer Gesamterl�s
DATA: L_GERLBT LIKE ANLCV-GJE_BCHWRT.
* Verteilkennzeichen.
DATA: L_VERKZ(1).
* Hilfsfeld: Antwort.
DATA: L_ANTWORT(1).

* Hilfsfelder zur W�hrungsaufbereitung
DATA: L_ERBDM_CUR(16),
      L_GERLBT_CUR(16).

* Abbruchkennzeichen l�schen.
  CLEAR U_ABBRUCH.
* Pr�fen, ob Erl�s eigen verteilt werden soll,
* sonst Routine verlassen.
  SWC_GET_ELEMENT AI_CONTAINER 'verkz' L_VERKZ.   "Erl�sverteilung
  CHECK L_VERKZ = 'E'.

*   Erl�s-Feld aus Ausgabeliste zur�cklesen.
    DO L_LINES TIMES.
      CLEAR RANGE.
*     Nur Anlagenzeilen auswerten.
      READ LINE SY-INDEX FIELD VALUE X-ERLP INTO L_ERLP.
      IF RANGE = '1'.
        TRANSLATE L_ERLP USING ', . '.
        CONDENSE  L_ERLP NO-GAPS.

        READ TABLE XABERL WITH KEY BUKRS = ANLAV-BUKRS
                                   ANLN1 = ANLAV-ANLN1
                                   ANLN2 = ANLAV-ANLN2 BINARY SEARCH.
*       Erl�s �ndern bei vorh. Anlage
        IF SY-SUBRC = 0.
          XABERL-ABERL = L_ERLP.
          MODIFY XABERL INDEX SY-TABIX.
*       ... sonst Erl�s mit Anlage einf�gen.
        ELSE.
          XABERL-BUKRS = ANLAV-BUKRS.
          XABERL-ANLN1 = ANLAV-ANLN1.
          XABERL-ANLN2 = ANLAV-ANLN2.
          XABERL-ABERL = L_ERLP.
          INSERT XABERL INDEX SY-TABIX.
        ENDIF.
        L_ERLBT = L_ERLP.
        WRITE L_ERLBT TO L_ERLP CURRENCY SAV_WAER1.
*       Feld formatiert ausgeben.
        MODIFY LINE SY-INDEX FIELD VALUE X-ERLP FROM L_ERLP.
*                            field format x-erlp intensified off.
      ENDIF.
    ENDDO.
*   Pr�fung, ob Erl�sbetrag (gesamt) ver�ndert wurde.
*   Gel�schte Zeilen entfernen.
    LOOP AT XABERL.
      L_GERLBT = L_GERLBT + XABERL-ABERL.
    ENDLOOP.
    SWC_GET_ELEMENT AI_CONTAINER 'erbdm' L_ERBDM.
    IF L_ERBDM <> L_GERLBT.
      WRITE L_ERBDM TO L_ERBDM_CUR CURRENCY SAV_WAER1.
      WRITE L_GERLBT TO L_GERLBT_CUR CURRENCY SAV_WAER1.
      MESSAGE I466 WITH L_ERBDM_CUR
                        L_GERLBT_CUR.
*     call function 'POPUP_TO_CONFIRM_WITH_MESSAGE'
*          exporting
*               DEFAULTOPTION  = 'Y'
*               diagnosetext1  = text-er1
*               diagnosetext2  = ' '
*               DIAGNOSETEXT3  = ' '
*               textline1      = text-er2
*               textline2      = text-er3
*               titel          = text-ert
*               START_COLUMN   = 25
*               START_ROW      = 6
*               CANCEL_DISPLAY = 'X'
*          importing
*               answer         = l_antwort
*          exceptions
*               others         = 1.
*     if l_antwort <> 'J'.
        U_ABBRUCH = 'X'.
        EXIT.
*     endif.
    ENDIF.

*   Erl�sverteilung zur�ckschreiben.
    SWC_SET_TABLE AI_CONTAINER 'xaberl' XABERL.
*   Ge�nderter Gesamterl�s zur�ckschreiben.
    SWC_SET_ELEMENT AI_CONTAINER 'erbdm' L_GERLBT.
*   Erl�sverteilung durch Kunden setzen.
*   Dadurch wird sichergestellt, dass keine autom. Verteilung
*   stattfindet.
    SWC_SET_ELEMENT AI_CONTAINER 'verkz' 'E'.


ENDFORM.

* Setzen des PF-Status zum Anzeigen / Bearbeiten des AV
* Der Status wird abweichend zu den normalen Reports gesetzt,
* weil er durch Interaktionen ver�ndert werden kann.
* z.B. Manuelle Erl�sverteilung vs. autom. Erl�sverteilung
FORM PF_STATUS_SETZEN.
* Lokales Statusfeld
DATA: LD_STATUS LIKE RSEU3-STATUS VALUE 'LIST'.

* im Batch kein Status setzen
CHECK SY-BATCH IS INITIAL.

* AV darf nur mit WF bearbeitet werden.
*    Workflow ist aktiv oder...
  IF FLG_UPD IS INITIAL  OR
*    ... freigegeben.
     NOT AI_HEADER-RELEASED IS INITIAL.
    LD_STATUS = 'WORK'.
    EXCLKEY-FUNKTION = 'AIRL'.
    APPEND EXCLKEY.
    EXCLKEY-FUNKTION = 'ERLP'.
    APPEND EXCLKEY.
    EXCLKEY-FUNKTION = 'AIDL'.
    APPEND EXCLKEY.
    EXCLKEY-FUNKTION = 'AIIN'.
    APPEND EXCLKEY.
    EXCLKEY-FUNKTION = 'AIKP'.
    APPEND EXCLKEY.
    EXCLKEY-FUNKTION = 'SAVE'.
    APPEND EXCLKEY.

* AV darf noch nicht freigegeben sein.
* Status (beendet/fehlerhaft).
* sonst wird AV nur angezeigt.
  ELSE.
*   Status bearbeitbar setzen.
    LD_STATUS = 'WORK'.
*   Eigene Erloesvert.
    PERFORM FUNKTION_ERL_VERT_PRUEFEN.
*   Titel und Status abhaengig vom Aufruf setzen.
    CASE G_WF_CALL.
*     Aufruf ohne WF
      WHEN ' '.
*       Titel: Arbeitsvorrat bearbeiten
        SET TITLEBAR 'WRK'.
*     Aufruf ueber WF: "Freigeben"
      WHEN 'R'.
*       Titel: Arbeitsvorrat freigeben
        SET TITLEBAR 'WRR'.
*       Alles bis auf Freigeben entfernen.
        EXCLKEY-FUNKTION = 'ERLP'.
        APPEND EXCLKEY.
        EXCLKEY-FUNKTION = 'AIDL'.
        APPEND EXCLKEY.
        EXCLKEY-FUNKTION = 'AIIN'.
        APPEND EXCLKEY.
        EXCLKEY-FUNKTION = 'AIKP'.
        APPEND EXCLKEY.
        EXCLKEY-FUNKTION = 'SAVE'.
        APPEND EXCLKEY.
*     Aufruf ueber WF: "Alle Funktionen"
      WHEN 'A'.
*       Titel: Arbeitsvorrat bearbeiten
        SET TITLEBAR 'WRK'.
*     Aufruf ueber WF: Korrigieren ohne Freigeben
      WHEN 'E'.
*       Titel: Arbeitsvorrat bearbeiten
        SET TITLEBAR 'WRK'.
        EXCLKEY-FUNKTION = 'AIRL'.
        APPEND EXCLKEY.
    ENDCASE.
  ENDIF.

* Funktionalit�t des MASS_CHANGE_DATA anbieten f�r neue Methoden
  IF NOT AI_STRUCTURE IS INITIAL.
     DELETE EXCLKEY
      WHERE FUNKTION = 'AIKP'.
     FLG_UPD = CON_X.
  ENDIF.

* PF-Status neu setzen.
CALL FUNCTION 'PF_STATUS_SET'
     EXPORTING
          I_STATUS   = LD_STATUS
          I_SUMMB    = SUMMB
          I_SOFORT   = 'X'
     TABLES
          T_EXCLKEY  = EXCLKEY.

ENDFORM.

* Funktion: Eigene Erloesverteilung in Status aufnehmen bzw. loeschen
FORM FUNKTION_ERL_VERT_PRUEFEN.

    SWC_GET_ELEMENT AI_CONTAINER 'verkz' HLP_VERKZ.
*   Bei Massenabgang o.Erl�s/Massenbearbeitung oder...
    IF FLG_ERLP = ' ' OR
*   ... keine eigene Erl�sverteilung aktiv.
       ( FLG_ERLP <> ' ' AND HLP_VERKZ <> 'E' ).
      EXCLKEY-FUNKTION = 'ERLP'.
      APPEND EXCLKEY.
    ELSE.
*     Eigene Erl�sverteilung erm�glichen.
      LOOP AT EXCLKEY
           WHERE FUNKTION = 'ERLP'.
        DELETE EXCLKEY.
      ENDLOOP.
    ENDIF.

ENDFORM.



FORM BERECHTIGUNG_PRUEFEN USING U_FLG_UPD.

* Akt. Bearb. setzen
DATA: LD_BEARB LIKE SY-UNAME.

* Nur Anzeigen erlauben
  CLEAR U_FLG_UPD.

  AUTHORITY-CHECK   OBJECT 'A_PERI_BUK'
                    ID     'AM_ACT_PER'  FIELD CON_40
                    ID     'BUKRS'       FIELD T093C-BUKRS.
* Keine Berechtigung
  IF SY-SUBRC <> 0.
*   Keine Berechtigung zum Bearbeiten.
    MESSAGE S469 WITH PA_AI_ID.
*   Routine verlassen
    EXIT.
  ENDIF.

* Akt. Bearbeiter setzen
  LD_BEARB = SY-UNAME.
* Aktuellen Bearbeiter setzen.
  PERFORM AV_BEARBEITER_SETZEN USING LD_BEARB U_FLG_UPD.

ENDFORM.

* AV durch aktuellen Bearbeiter reservieren.
FORM AV_BEARBEITER_SETZEN USING U_BEARB U_FLG_UPD.

* AV wurde bereits freigegeben.
  IF NOT AI_HEADER-RELEASED IS INITIAL.
*   message s468 with pa_ai_id wi_header-wi_aagent.
*   Routine verlassen
    EXIT.
  ENDIF.

* AV im Status bereit.
  IF WI_HEADER-WI_STAT = WI_STATUS_READY OR
*    AV von sich selber angenommen.
     ( WI_HEADER-WI_STAT = WI_STATUS_SELECTED AND
       WI_HEADER-WI_AAGENT = U_BEARB ).
  ELSE.
*   AV wird bereits von einem anderen Benutzer bearbeitet.
    MESSAGE S470 WITH PA_AI_ID WI_HEADER-WI_AAGENT.
*   Routine verlassen
    EXIT.
  ENDIF.

*   Arbeitsvorrat selektieren vor anderen Benutzern.
    CALL FUNCTION 'SWW_WI_SELECT'
       EXPORTING
            USER                        = U_BEARB
            WI_ID                       = PA_AI_ID
*             DO_COMMIT                   = 'X'
*        IMPORTING
*             NEW_STATUS                  =
       EXCEPTIONS
            INFEASIBLE_STATE_TRANSITION = 1
            INVALID_TYPE                = 2
            UPDATE_FAILED               = 3
            OTHERS                      = 4.
*   Alles ok.
    IF SY-SUBRC = 0.
*     Status angenommen setzen
      WI_HEADER-WI_STAT = WI_STATUS_SELECTED.
*     �nderungen erlauben.
      U_FLG_UPD = 'X'.
*     Bei Fehler Systemmeldung ausgeben
    ELSE.
      MESSAGE ID SY-MSGID       TYPE 'I'           NUMBER SY-MSGNO
              WITH SY-MSGV1     SY-MSGV2
                   SY-MSGV3     SY-MSGV4.
      EXIT.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AV_AUFRUF_UEBER_WF
*&---------------------------------------------------------------------*
*       Bei Aufruf des Reports �ber Workflow soll sichergestellt
*       sein, dass Bearbeitung je nach Anforderungsart durchgefuehrt
*       werden kann
*----------------------------------------------------------------------*
FORM AV_AUFRUF_UEBER_WF USING U_FLG_UPD.

*     Aktueller Bearbeiter
DATA: LD_BEARB LIKE SY-UNAME.

* Aufruf �ber Workflow?
  IMPORT G_WF_CALL G_WF_RET FROM MEMORY ID 'am_ai'.
* ... sonst Routine verlassen
  CHECK SY-SUBRC = 0.

* Erst mal nur Anzeigen.
  CLEAR U_FLG_UPD.

* Akt. Bearb. auf Dummy setzen, damit AV nicht im Eingang
* erscheint.
  LD_BEARB = '     '.
* Aktuellen Bearbeiter setzen.
  PERFORM AV_BEARBEITER_SETZEN USING LD_BEARB U_FLG_UPD.

ENDFORM.                    " AV_AUFRUF_UEBER_WF
FORM F4CALLBACK
     TABLES   RECORD_TAB STRUCTURE SEAHLPRES
     CHANGING SHLP TYPE SHLP_DESCR_T
              CALLCONTROL LIKE DDSHF4CTRL.
  DATA: INTERFACE LIKE LINE OF SHLP-INTERFACE.
  DATA: WA_SELOPT     LIKE LINE OF SHLP-SELOPT.

*   suppress personal list
    CALLCONTROL-PVALUES = 'D'.
*   only assets in actual coco.
    CLEAR WA_SELOPT.
    WA_SELOPT-SIGN   = 'I'.
    WA_SELOPT-OPTION = 'EQ'.
    WA_SELOPT-SHLPFIELD = 'BUKRS'.
    WA_SELOPT-LOW       = anlav-BUKRS.
    APPEND WA_SELOPT TO SHLP-SELOPT.


  INTERFACE-VALFIELD = 'ANLN1'.
  MODIFY SHLP-INTERFACE FROM INTERFACE
         TRANSPORTING VALTABNAME VALFIELD
         WHERE SHLPFIELD = 'ANLN2'.
  INTERFACE-VALFIELD = 'ANLN1'.
  MODIFY SHLP-INTERFACE FROM INTERFACE
         TRANSPORTING VALTABNAME VALFIELD
         WHERE SHLPFIELD = 'BUKRS'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  check_t001b
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form check_t001b.
  clear : it_t001b[].
  select * into table it_t001b
  from t001b
  where BUKRS = 'H201'  "p_bukrs
  and   MKOAR in ('+', 'A').

  describe table it_t001b lines wa_cnt.
  if wa_cnt > 0.
     update t001b set FRYE2 = p_frye2
                      FRPE2 = p_frpe2
     where BUKRS =  'H201' "p_bukrs
     and   MKOAR in ('+', 'A').
     commit work.
  endif.

endform.                    " check_t001b
*&---------------------------------------------------------------------*
*&      Form  change_original_t001b
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form change_original_t001b.
 loop at it_t001b.
    move-corresponding it_t001b to t001b.
    modify t001b.
 endloop.
endform.                    " change_original_t001b
