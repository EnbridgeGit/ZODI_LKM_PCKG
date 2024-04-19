*&---------------------------------------------------------------------*
*&  Include           ZODI_15101_119101_TOP
*&---------------------------------------------------------------------*
TABLES: glt0,    "G/L Account Master record transaction figures
        bsis,    "Accounting: Secondary Index for G/L Accounts
        lfc1,    "Vendor Master (Transaction Figures)
        t001,    "Company Codes
        zjhdr,   "Journal Header for Consolidation
        zpsacct, "<<<Ins. TR495 (D30K913809)
        faglflext,    "G/L Account Master table replacement TR582 (IFRS)
        zacctnew.     "G/L to HFM Account mapping table     TR582 (IFRS)

TYPES: BEGIN OF i_fagl,
        rbukrs LIKE faglflext-rbukrs,
        ryear  LIKE faglflext-ryear,
        racct  LIKE faglflext-racct,
        hsl01  LIKE faglflext-hsl01,
        hsl02  LIKE faglflext-hsl02,
        hsl03  LIKE faglflext-hsl03,
        hsl04  LIKE faglflext-hsl04,
        hsl05  LIKE faglflext-hsl05,
        hsl06  LIKE faglflext-hsl06,
        hsl07  LIKE faglflext-hsl07,
        hsl08  LIKE faglflext-hsl08,
        hsl09  LIKE faglflext-hsl09,
        hsl10  LIKE faglflext-hsl10,
        hsl11  LIKE faglflext-hsl11,
        hsl12  LIKE faglflext-hsl12,
        hsl13  LIKE faglflext-hsl13,
        hsl14  LIKE faglflext-hsl14,
        hsl15  LIKE faglflext-hsl15,
        hsl16  LIKE faglflext-hsl16,
        hslvt  LIKE faglflext-hslvt,
       END OF i_fagl.

TYPES: BEGIN OF gty_fagl,
        rbukrs TYPE string,
        ryear  TYPE string,
        racct  TYPE string,
        hsl01  TYPE string,
        hsl02  TYPE string,
        hsl03  TYPE string,
        hsl04  TYPE string,
        hsl05  TYPE string,
        hsl06  TYPE string,
        hsl07  TYPE string,
        hsl08  TYPE string,
        hsl09  TYPE string,
        hsl10  TYPE string,
        hsl11  TYPE string,
        hsl12  TYPE string,
        hsl13  TYPE string,
        hsl14  TYPE string,
        hsl15  TYPE string,
        hsl16  TYPE string,
        hslvt  TYPE string,
       END OF gty_fagl.
*- Global Interal Table for FAGLFLEXT records to remove nested SELECTs
DATA: gtfagl TYPE STANDARD TABLE OF i_fagl,
      gsfagl TYPE i_fagl,
      gt_fagl TYPE STANDARD TABLE OF gty_fagl,
      gs_fagl TYPE gty_fagl,
      gt_no_psacct TYPE STANDARD TABLE OF z_psact WITH HEADER LINE.
FIELD-SYMBOLS: <fs_gtfagl> LIKE LINE OF gt_fagl.

*- Detail Record
DATA: BEGIN OF detail OCCURS 0,
        business_unit_ln(5)         TYPE c,  "Bus. Unit in Peoplesoft
        account(7)                  TYPE c,  "Account
        subaccount(5)               TYPE c,  "SubAccount / Affiliate
        monetary_amount(18)         TYPE c,  "YTD Balance
      END OF detail.

DATA: BEGIN OF subfagl OCCURS 0,
            rldnr   LIKE faglflext-rldnr,     "Ledger Type
            rbukrs  LIKE faglflext-rbukrs,    "Company code
            racct   LIKE faglflext-racct,     "SAP account #
            hfmacct LIKE zacctnew-hfmllacct,  "HFM account #
            rtcur   LIKE faglflext-rtcur,     "Currency code
            amount  LIKE faglflext-hsl01,     "Dollars
            bunit   LIKE zjhdr-bunit,         "Business Unit
            bunam   LIKE zjhdr-bunam,         "Business Unit Name
            affil   LIKE zacctnew-affil,      "Affiliate-Countr Party BU
            status(34) TYPE c,                "Current status
            error      TYPE c,                "Error Record - Print Only
      END   OF subfagl.

DATA: BEGIN OF itab OCCURS 0,        "Used for accounts by cost centers
        kostl LIKE bsis-kostl,
        dmbtr LIKE bsis-dmbtr,
      END   OF itab.

DATA: BEGIN OF notfound OCCURS 0,   "Company code not found:table ZJHDR
        bukrs LIKE faglflext-rbukrs,
      END   OF notfound.

DATA: w_dollars        LIKE faglflext-hsl01,
      w_waers          LIKE t001-waers,
      noncc$           LIKE bsis-dmbtr,
      w_month          LIKE t247-ltx,
*      TEXT_COMN(30)  TYPE C,          "TR654
      text_comn(48)    TYPE c,           "TR654
      posted_ind       TYPE c,  "A/C posted/unposted as vendor or CC A/C
      vendor_default   TYPE c,
      default_values   VALUE 'N',
      line_count       TYPE i,
      jhead_count      TYPE i,
      file_tot_recs    TYPE i,
      next_period(2)   TYPE n,
      next_year(4)     TYPE n,
      first_day        LIKE sy-datum,
      last_day         LIKE sy-datum,
      start_rec        TYPE i VALUE 1,
      end_rec          TYPE i VALUE 0,
      save_bunam       LIKE zjhdr-bunam,
      save_rtcur       LIKE faglflext-rtcur,
      first_row(10)    TYPE c VALUE 'Heade8ftp',
      second_row(7)    TYPE c VALUE 'Header',
      third_row(7)     TYPE c VALUE 'Header',
      save_bukrs       LIKE faglflext-rbukrs,
      save_racct       LIKE faglflext-racct,
      company_map(3)   TYPE c,
      w_hfmacct        LIKE zacctnew-hfmllacct,
      w_ledger(15)     TYPE c.
*      W_ZACCTNEW_FOUND TYPE C.

DATA: detl_rec TYPE string,
      file_rec TYPE string,
      jrnl_rec TYPE string,
      full_rec TYPE string.

DATA: BEGIN OF struc1,
       um01h LIKE lfc1-um01h,
       um02h LIKE lfc1-um01h,
       um03h LIKE lfc1-um01h,
       um04h LIKE lfc1-um01h,
       um05h LIKE lfc1-um01h,
       um06h LIKE lfc1-um01h,
       um07h LIKE lfc1-um01h,
       um08h LIKE lfc1-um01h,
       um09h LIKE lfc1-um01h,
       um10h LIKE lfc1-um01h,
       um11h LIKE lfc1-um01h,
       um12h LIKE lfc1-um01h,
       um13h LIKE lfc1-um01h,
       um14h LIKE lfc1-um01h,
      END OF struc1.

DATA: BEGIN OF struc2,
       um01s LIKE lfc1-um01s,
       um02s LIKE lfc1-um01s,
       um03s LIKE lfc1-um01s,
       um04s LIKE lfc1-um01s,
       um05s LIKE lfc1-um01s,
       um06s LIKE lfc1-um01s,
       um07s LIKE lfc1-um01s,
       um08s LIKE lfc1-um01s,
       um09s LIKE lfc1-um01s,
       um10s LIKE lfc1-um01s,
       um11s LIKE lfc1-um01s,
       um12s LIKE lfc1-um01s,
       um13s LIKE lfc1-um01s,
       um14s LIKE lfc1-um01s,
      END OF struc2.

CONSTANTS:  h_dmtr  TYPE x VALUE '09',
            trn_field1(2) TYPE c VALUE ' #',
            trn_field2(2) TYPE c VALUE '# ',
            gc_ps_default LIKE zpsacct-psact VALUE '0184007',
            gc_actual(6)  TYPE c VALUE 'ACTUAL',
            gc_ifrs(4)    TYPE c VALUE 'IFRS',           "TR831
            gc_zeros(18)  TYPE c VALUE ' 00000000000000000'.
