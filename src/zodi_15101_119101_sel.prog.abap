*&---------------------------------------------------------------------*
*&  Include           ZODI_15101_119101_SEL
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*   S E L E C T I O N - S C R E E N
*---------------------------------------------------------------------*
*- General Data Selection
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001."StrtTR654
*SELECTION-SCREEN BEGIN OF LINE.
*PARAMETERS:     b_opbal RADIOBUTTON GROUP rept.
*SELECTION-SCREEN COMMENT 3(33) text-125.
*SELECTION-SCREEN END OF LINE.
*
*SELECTION-SCREEN BEGIN OF LINE.
*PARAMETERS:   b_trbal RADIOBUTTON GROUP rept.
*SELECTION-SCREEN COMMENT 3(27) text-126.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN SKIP 1.                              "End of TR654
PARAMETERS:
  p_ledger LIKE faglflext-rldnr
                DEFAULT '0L' OBLIGATORY,                  "Ledger TR582
  p_year LIKE faglflext-ryear
                DEFAULT sy-datum+0(4) OBLIGATORY,         "Fiscal year
  p_perd(2) TYPE n DEFAULT sy-datum+4(2) OBLIGATORY.      "Period
SELECT-OPTIONS:
  s_bukrs  FOR faglflext-rbukrs NO INTERVALS,             "CompanyCode
  s_racct  FOR faglflext-racct.                                "Acct #
PARAMETERS:
  p_file        LIKE rfpdo-rfbifile.                      "File name
*  def_cflg(01)  TYPE c  DEFAULT 'Y'.             "Upload/Validate Flag
SELECTION-SCREEN END OF BLOCK b1.                         "TR654
SELECTION-SCREEN END OF BLOCK a1.

*-      Start of Del. -> (Iss# TR582)
*SELECTION-SCREEN SKIP 1.

*- Constant Data
*SELECTION-SCREEN BEGIN OF BLOCK A3 WITH FRAME TITLE TEXT-003.
*PARAMETERS:
*   CON_RECT(02)  TYPE C  DEFAULT 'JE',      "Record Type
*   CON_TTCD(02)  TYPE C  DEFAULT '04',      "Transmission Traking Code
*   CON_FILE(04)  TYPE C,                    "File Number
*   CON_RVRS(01)  TYPE C  DEFAULT 'D',       "Revere Journal Code
*   CON_SRCE(03)  TYPE C  DEFAULT 'SAP',     "Source
*   CON_OPID(08)  TYPE C  DEFAULT 'SAPFIA',  "Operator ID
*   CON_SSRC(03)  TYPE C  DEFAULT 'EXT',     "System Source
*   CON_LGRP(10)  TYPE C  DEFAULT 'ACTUALS', "Ledger Group
*   CON_JIDM(06)  TYPE C  DEFAULT 'DEGTWT',  "Journal mask identifier
*   CON_EXCH(05)  TYPE C  DEFAULT 'CRRNT'.   "Exchange Rate %
*SELECTION-SCREEN END OF BLOCK A3.
*-      End of Del. -> (Iss# TR582)

*- Default Data
*SELECTION-SCREEN BEGIN OF BLOCK a4 WITH FRAME TITLE text-004.
*PARAMETERS:
*   def_acct(07)  TYPE c  DEFAULT '0184007'.  "PS Account #
**   DEF_REST(05)  TYPE C  DEFAULT '99810'.   "Resource Type - Del TR582
*SELECTION-SCREEN END OF BLOCK a4.

*- Begin of Year
*SELECTION-SCREEN BEGIN OF BLOCK A41 WITH FRAME TITLE TEXT-005. "TR654
*PARAMETERS: boy_date TYPE sy-datum NO-DISPLAY.                  "TR654
*SELECTION-SCREEN END OF BLOCK A41.                             "TR654

*SELECTION-SCREEN BEGIN OF BLOCK a5 WITH FRAME.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT  1(62) text-123.
*PARAMETERS: abendflg   AS CHECKBOX DEFAULT 'X'.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN END OF BLOCK a5.
*SELECTION-SCREEN END OF BLOCK a1.
