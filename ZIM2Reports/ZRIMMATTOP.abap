*&---------------------------------------------------------------------*
*& Report ZRIMMAT01                                                    *
*&---------------------------------------------------------------------*
*&  ���α׷��� : ������� ��Ȳ                                         *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.01.26                                            *
*&---------------------------------------------------------------------*
*&   DESC. : 1. �����Ƿ� �Ǻ��� ������� ��Ȳ�� ��ȸ�Ѵ�.              *
*&---------------------------------------------------------------------*
*& [���泻��]
*&
*&---------------------------------------------------------------------*
REPORT ZRIMMAT01 NO STANDARD PAGE HEADING MESSAGE-ID ZIM.

*-----------------------------------------------------------------------
* ��� TABLE DECLARE
*-----------------------------------------------------------------------
TABLES: EKKO,                " ABAP Standard Header Table..
        EKPO,                " ABAP Standard Item Table..
        ZTREQHD,             " �����Ƿ� Header Table..
        ZTREQST,             " �����Ƿ� ���� Table..
        ZTREQIT,             " �����Ƿ� Item Table..
        ZTIV,                " Invoice Table..
        ZTIVIT,              " Invoice Item Table..
        ZTBL,                " B/L Table -ZTIVIT Table�� Item Table..
        LFA1,                " �ŷ�ó Master Table..
        ZTCUCL,              " ��� Table..
        ZTCUCLIV,            " ��� Invoice Table..
        ZTCUCLIVIT,          " ��� Invoice Item..
        ZTIDR,               " ���ԽŰ� Table..
        ZTIDS,               " ���Ը��� Table..
        EKET.                " ������ ���� Table..

*-----------------------------------------------------------------------
* PO ���� INTERNAL TABLE DECLARE
*-----------------------------------------------------------------------
DATA:   BEGIN OF IT_PO OCCURS 1000,       " Internal Table IT_PO..
          EBELN    LIKE   EKKO-EBELN,     " P/O Header No..
          BSART    LIKE   EKKO-BSART,     " Purchasing Document Type..
          LOEKZ    LIKE   EKKO-LOEKZ,     " Deletion indicator..
          ERNAM    LIKE   EKKO-ERNAM,     " Creator..
          LIFNR    LIKE   EKKO-LIFNR,     " Vendor's Account No..
          ZTERM    LIKE   EKKO-ZTERM,     " Terms of Payment Key..
          EKORG    LIKE   EKKO-EKORG,     " Purchasing Organization..
          EKGRP    LIKE   EKKO-EKGRP,     " Purchasing Group..
          WAERS    LIKE   EKKO-WAERS,     " Current Key..
          BEDAT    LIKE   EKKO-BEDAT,     " Purchasing Document Data..
          LLIEF    LIKE   EKKO-LLIEF,     " Supplying Vensor..
          INCO1    LIKE   EKKO-INCO1,     " Incoterms (Part1)..
          LIFRE    LIKE   EKKO-LIFRE,     " Difference Invoicing Party.
          EBELP    LIKE   EKPO-EBELP,     " P/O Item No..
          TXZ01    LIKE   EKPO-TXZ01,     " Short Text..
          MATNR    LIKE   EKPO-MATNR,     " Material No..
          WERKS    LIKE   EKPO-WERKS,     " Plant..
          LGORT    LIKE   EKPO-LGORT,     " Storage Location..
          MENGE    LIKE   EKPO-MENGE,     " Purchase Order Quantity..
          MEINS    LIKE   EKPO-MEINS,     " Order Unit..
          BPRME    LIKE   EKPO-BPRME,     " Order Price Unit..
          NETPR    LIKE   EKPO-NETPR,     " Net Price..
          PEINH    LIKE   EKPO-PEINH,     " Price Unit..
          ELIKZ    LIKE   EKPO-ELIKZ,     " Delivery Comience Indicator

        END OF IT_PO.
