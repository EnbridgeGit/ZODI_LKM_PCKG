*&---------------------------------------------------------------------*
*&  Include           ZODI_15101_119101_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SET_REPORT_HEADER                            "TR654
*&---------------------------------------------------------------------*
*FORM set_report_header.
**- Set Report Heading, file number
*  IF sy-host+0(3) = 'WEI'.
**      MOVE '0004'                           TO CON_FILE.
*    IF b_opbal = 'X'.
*      MOVE 'Canada West - Opening Balance(C/F) For' TO text_comn.
*    ELSE.
*      MOVE 'Canada West - Trial Balance For' TO text_comn.
*    ENDIF.
*  ELSE.
**      MOVE '0001'                           TO CON_FILE.
*    IF b_opbal = 'X'.
*      MOVE 'Canada East - Opening Balance(C/F) For' TO text_comn.
*    ELSE.
*      MOVE 'Canada East - Trial Balance For' TO text_comn.
*    ENDIF.
*  ENDIF.
*
*  IF p_ledger = '0L'.
*    MOVE '  LEAD LEDGER  ' TO w_ledger.
*  ELSE.
*    IF p_ledger = 'NL'.
*      MOVE 'NON LEAD LEDGER' TO w_ledger.
*    ELSE.
*      CALL FUNCTION 'POPUP_FOR_INTERACTION'
*        EXPORTING
*          headline = '!! ERROR !!'
*          text1    = 'Invalid Ledger Specified'
*          button_1 = 'OK'.
*      STOP.
*    ENDIF.
*  ENDIF.
*
*  CONCATENATE text_comn p_perd '/' p_year INTO text_comn
*                 SEPARATED BY space.
*ENDFORM.                    "SET_REPORT_HEADER
**---------------------------------------------------------------------*
*       FORM SETUP_DATES                                              *
*                                                                     *
*  1. Determine last day of period for which data is being extracted. *
*  2. Determine the first day of next period.                         *
*  3. Period could be from 01 to 13, consider 13 as 12.               *
*---------------------------------------------------------------------*
FORM setup_dates.

  IF p_perd > 12.
    CONCATENATE p_year '1201' INTO first_day.        "For period 13
  ELSE.
    CONCATENATE p_year  p_perd '01' INTO first_day.
  ENDIF.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = first_day
    IMPORTING
      last_day_of_month = last_day
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  IF sy-subrc <> 0.
    WRITE: /5 'INVALID DATA FOR LAST_DAY'.
    STOP.
  ELSE.
    IF p_perd > 11.
      next_period = 01.
      next_year   = p_year + 1.
      MOVE next_period TO first_day+4(2).
      MOVE next_year   TO first_day+0(4).
    ELSE.
      next_period = p_perd + 1.
      MOVE next_period    TO    first_day+4(2).
    ENDIF.
  ENDIF.

ENDFORM.                    "SETUP_DATES

*---------------------------------------------------------------------*
*       FORM CHK_P_PERIOD                                             *
*---------------------------------------------------------------------*
FORM valid_period_check.

*- Check Valid Period entered
  IF p_perd GT 13  OR  p_perd < 01.
    CALL FUNCTION 'POPUP_FOR_INTERACTION'
      EXPORTING
        headline = '!! ERROR !!'
        text1    = 'Invalid Period Selected'
        button_1 = 'OK'.
    STOP.
  ENDIF.

ENDFORM.                    "VALID_PERIOD_CHECK

*----------------------------------------------------------------------*
*       FORM GET_GL_DATA                                               *
*                                                                      *
*  This form reads data from G/L posting summary table FAGLFLEXT.      *
*  Use ZACCTNEW and Ledger Type to determine correct HFM account no.   *
*  to process per SAP Company/G/L account.                             *
*----------------------------------------------------------------------*
FORM get_gl_data.

  DATA: l_bukrs LIKE faglflext-rbukrs.

*- Retrieve all GL data from FAGLFLEXT (TR582 - IFRS)
  SELECT rbukrs ryear racct hsl01 hsl02 hsl03 hsl04 hsl05 hsl06 hsl07
         hsl08 hsl09 hsl10 hsl11 hsl12 hsl13 hsl14 hsl15 hsl16 hslvt
        FROM faglflext INTO CORRESPONDING FIELDS OF TABLE gtfagl
        WHERE rldnr = p_ledger              "Ledger Only
          AND rrcty = '0'                   "Actual            TR105
          AND rbukrs IN s_bukrs             "Company Code
          AND ryear = p_year                "Year
          AND racct IN s_racct.             "G/L Account #

  SORT gtfagl BY rbukrs racct.

**- Loop every G/L Account Transaction
*  LOOP AT gtfagl.
*
**-   Validate Company Code against ZJHDR
*    IF gtfagl-rbukrs NE l_bukrs.
*      company_map = 'YES'.
*      PERFORM check_company_code.
*    ENDIF.
*    l_bukrs = gtfagl-rbukrs.
*
*    IF company_map = 'YES'.
*      IF save_bukrs  = gtfagl-rbukrs AND
*         save_racct = gtfagl-racct AND
*         posted_ind  = 'Y'.
*      ELSE.
*        posted_ind  = 'N'.
*        save_bukrs  = gtfagl-rbukrs.
*        save_racct = gtfagl-racct.
*
**-         Populate Internal Table with valid FAGLFLEXT records
*        PERFORM build_subfagl_table.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.

*- Remove any record with zero qty
*  LOOP AT subfagl.
*    CHECK subfagl-amount = 0.
*    DELETE subfagl.
*  ENDLOOP.

*- Apply PS Account Flipping & Affiliate Rules (ZPSACCT)
*  PERFORM apply_ps_acct_rules.         "<<<Ins. C11K918555 (Iss# TR495)

ENDFORM.                    "GET_GL_DATA

*----------------------------------------------------------------------*
*       FORM     BUILD_SUBFAGL_TABLE.                                  *
*----------------------------------------------------------------------*
FORM build_subfagl_table.
*
*  CLEAR subfagl.
*  MOVE gtfagl-rldnr  TO subfagl-rldnr.
*  MOVE gtfagl-racct  TO subfagl-racct.
*  MOVE w_waers       TO subfagl-rtcur.
*  MOVE gtfagl-rbukrs TO subfagl-rbukrs.
*
**-  Calculate YTD Account Balance + add Balance Carried Forward
*  CLEAR: w_dollars.
*  IF b_opbal = 'X'.                          "TR564
*    w_dollars = w_dollars + gtfagl-hslvt.   "TR564
*  ELSE.
*    IF boy_date = '00000000'.
*      ADD gtfagl-hsl01 FROM 1 TO p_perd GIVING w_dollars.
*      w_dollars = w_dollars + gtfagl-hslvt.
*    ELSE.
*      w_dollars = w_dollars + gtfagl-hslvt * -1.
*    ENDIF.
*  ENDIF.
*
*  PERFORM check_account_mapping.

ENDFORM.                    "BUILD_SUBFAGL_TABLE

*----------------------------------------------------------------------*
*                CHEK_COMPANY_CODE                                     *
*----------------------------------------------------------------------*
*FORM check_company_code.
*
**- Check Journal Header for Consolidation (ZJHDR)
*  SELECT SINGLE * FROM zjhdr INTO zjhdr
*                  WHERE bukrs = gtfagl-rbukrs.
*
*  IF sy-subrc <> 0.
*    MOVE 'NO' TO company_map.
*    PERFORM company_not_found.
*  ELSE.
*    SELECT SINGLE waers INTO w_waers FROM t001
*    "Get comp.currency code
*                         WHERE bukrs = gtfagl-rbukrs.
*  ENDIF.
*
*ENDFORM.                    "CHECK_COMPANY_CODE

*----------------------------------------------------------------------*
*                COMPANY_NOT_FOUND                                     *
*  Creates an internal table of company codes not found on table ZJHDR.*
*----------------------------------------------------------------------*
*FORM company_not_found.
*
*  MOVE gtfagl-rbukrs TO notfound-bukrs.
*  APPEND notfound.
*  CLEAR  notfound.
*
*ENDFORM.                    "COMPANY_NOT_FOUND
**----------------------------------------------------------------------*
*               CHECK_ACOUNT_MAPPING                                   *
*                                                                      *
* Determines how each account is to be handled depending upon the data *
* in ZACCTNEW table.  Mappings are done against a single GTFAGL record *
* from BUILD_SUBFAGL_TABLE                                             *
*----------------------------------------------------------------------*
*FORM  check_account_mapping.
*
*  DATA: dfalt_ind, dbdc_ind, comp_ind, norml_ind, mult_ind, error_ind.
*
*  DATA: lt_zacctnew TYPE STANDARD TABLE OF zacctnew WITH HEADER LINE.
*
*  CLEAR: dfalt_ind,  dbdc_ind, comp_ind, norml_ind,
*         mult_ind, error_ind.
*
**- Select all entries from ZACCTNEW for GTFAGL Account#
*  REFRESH lt_zacctnew.
*  SELECT * FROM zacctnew INTO TABLE lt_zacctnew
*          WHERE glacct = gtfagl-racct.
*
**- For each ZACCTNEW determine Account Type
*  LOOP AT lt_zacctnew.
*
*    IF lt_zacctnew-dbdc = gtfagl-drcrk AND
*       lt_zacctnew-cocode = gtfagl-rbukrs.
*      MOVE 'Y' TO mult_ind.
*
*    ELSEIF lt_zacctnew-cocode = gtfagl-rbukrs AND
*           lt_zacctnew-dbdc  =  space.
*      MOVE 'Y' TO comp_ind.
*
*    ELSEIF lt_zacctnew-dbdc  = gtfagl-drcrk AND
*           lt_zacctnew-cocode = space.
*      MOVE 'Y' TO dbdc_ind.
*
*    ELSEIF lt_zacctnew-cocode =  space  AND
*           lt_zacctnew-dbdc  =  space.
*      MOVE 'Y' TO norml_ind.
*    ELSE.
*      MOVE 'Y' TO error_ind.
*    ENDIF.
*  ENDLOOP.
*
*  IF ( lt_zacctnew[] IS INITIAL ).
*    MOVE 'Y' TO dfalt_ind.
*    MOVE 'NO MAPPING FOUND-DEFAULTS USED' TO subfagl-status.
*  ENDIF.
*
*  MOVE w_dollars TO subfagl-amount.
*
**- Execute FORM based on Account Type determined
*  IF  mult_ind = 'Y'.
*    PERFORM account_by_multi.
*
*  ELSEIF comp_ind = 'Y'.
*    PERFORM account_by_company.
*
*  ELSEIF dbdc_ind = 'Y'.
*    PERFORM account_by_dbdc.
*
*  ELSEIF norml_ind = 'Y'.
*    PERFORM account_normal.
*
*  ELSEIF dfalt_ind = 'Y'.
*    PERFORM account_by_default.
*
**- No Valid Combo in ZACCT Table
*  ELSE.
*    PERFORM account_with_error.
*  ENDIF.
*
*ENDFORM.                    "CHECK_ACCOUNT_MAPPING

*----------------------------------------------------------------------*
*       ACCOUNT_BY_MULTI
*----------------------------------------------------------------------*
*FORM account_by_multi.
*
*  DATA:  multi_fagl_$  LIKE w_dollars,
*         save_drcrk    LIKE gtfagl-drcrk.
*
*  DATA: l_fagl LIKE faglflext.
*
**- Get total for this account from table FAGL
*  SELECT * FROM faglflext INTO l_fagl
*        WHERE rrcty = '0'   "Actual
*          AND rldnr = p_ledger
*          AND rbukrs = save_bukrs
*          AND ryear = p_year
*          AND racct = save_racct.
*
*    CLEAR: w_dollars.
*    IF b_opbal = 'X'.                              "TR564
*      multi_fagl_$ = multi_fagl_$ + l_fagl-hslvt. "TR564
*    ELSE.
*      IF boy_date = '00000000'.
*        ADD l_fagl-hsl01 FROM 1 TO p_perd GIVING w_dollars.
*        multi_fagl_$ = multi_fagl_$ + w_dollars + l_fagl-hslvt.
*      ELSE.
*        multi_fagl_$ = multi_fagl_$ + w_dollars + l_fagl-hslvt * -1.
*      ENDIF.
*    ENDIF.
*  ENDSELECT.
*
*  IF multi_fagl_$ <> 0.
*    MOVE multi_fagl_$  TO subfagl-amount.
*    IF   multi_fagl_$ < 0.
*      MOVE 'H'  TO  save_drcrk.
*    ELSE.
*      MOVE 'S'  TO  save_drcrk.
*    ENDIF.
*
*    SELECT SINGLE * FROM zacctnew INTO zacctnew
*        WHERE glacct = l_fagl-racct
*          AND cocode = l_fagl-rbukrs
*          AND dbdc  = save_drcrk.     "H-Credit, S-Debit
*
*    IF sy-subrc = 0.
*      PERFORM add_this_record.
*      posted_ind = 'Y'.
*      CLEAR subfagl.
*    ELSE.
*      MOVE 'INVALID A/C, DB/DC COMBO-DEF.USED' TO  subfagl-status.
*      PERFORM account_by_default.
*      posted_ind = 'Y'.
*      CLEAR subfagl.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    "ACCOUNT_BY_MULTI

*----------------------------------------------------------------------*
*       ACCOUNT_BY_DBDC
*----------------------------------------------------------------------*
*FORM account_by_dbdc.
*
*  DATA:  dbdc_fagl_$   LIKE w_dollars,
*         save_drcrk    LIKE gtfagl-drcrk.
*
*  DATA: l_fagl LIKE faglflext.
*
**- Get total for this account from table FAGLFLEXT
*  SELECT * FROM faglflext INTO l_fagl
*    WHERE rrcty = '0'                               "Actual     TR105
*      AND rldnr = p_ledger
*      AND rbukrs = save_bukrs
*      AND ryear = p_year
*      AND racct = save_racct.
*
*    CLEAR: w_dollars.
*    IF b_opbal = 'X'.                            "TR564
*      dbdc_fagl_$ = dbdc_fagl_$ + l_fagl-hslvt. "TR564
*    ELSE.
*      IF boy_date = '00000000'.
*        ADD l_fagl-hsl01 FROM 1 TO p_perd GIVING w_dollars.
*        dbdc_fagl_$ = dbdc_fagl_$ + w_dollars + l_fagl-hslvt.
*      ELSE.
*        dbdc_fagl_$ = dbdc_fagl_$ + w_dollars + l_fagl-hslvt * -1.
*      ENDIF.
*    ENDIF.
*  ENDSELECT.
*
*  IF dbdc_fagl_$ <> 0.
*    MOVE dbdc_fagl_$  TO subfagl-amount.
*    IF   dbdc_fagl_$ < 0.
*      MOVE 'H'  TO  save_drcrk.
*    ELSE.
*      MOVE 'S'  TO  save_drcrk.
*    ENDIF.
*
*    SELECT SINGLE * FROM zacctnew INTO zacctnew
*        WHERE glacct = l_fagl-racct
*          AND cocode = space
*          AND dbdc  = save_drcrk.     "H-Credit, S-Debit
*
*    IF sy-subrc = 0.
*      PERFORM add_this_record.
*      posted_ind = 'Y'.
*      CLEAR subfagl.
*    ELSE.
*      MOVE 'INVALID A/C, DB/DC COMBO-DEF.USED' TO  subfagl-status.
*      PERFORM account_by_default.
*      posted_ind = 'Y'.
*      CLEAR subfagl.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    "ACCOUNT_BY_DBDC

*----------------------------------------------------------------------*
*       ACCOUNT_BY_COMPANY
*----------------------------------------------------------------------*
*FORM account_by_company.
*
*  SELECT SINGLE * FROM zacctnew INTO zacctnew
*      WHERE glacct = gtfagl-racct
*        AND cocode = gtfagl-rbukrs
*        AND dbdc  = space.
*
*  IF sy-subrc = 0.
*    PERFORM add_this_record.
*    CLEAR subfagl.
*  ELSE.
*    MOVE 'INVALID A/C, COMPNY COMBO-DEF.USED' TO  subfagl-status.
*    PERFORM account_by_default.
*    CLEAR subfagl.
*  ENDIF.
*
*ENDFORM.                    "ACCOUNT_BY_COMPANY

*----------------------------------------------------------------------*
*       ACCOUNT_NORMAL
*----------------------------------------------------------------------*
*FORM account_normal.
*
*  SELECT SINGLE * FROM zacctnew
*     WHERE glacct = gtfagl-racct
*       AND cocode = space
*       AND dbdc  = space.
*
*  IF sy-subrc = 0.
*    PERFORM add_this_record.
*    CLEAR subfagl.
*  ENDIF.
*
*ENDFORM.                    "ACCOUNT_NORMAL

*----------------------------------------------------------------------*
*       ACCOUNT_BY_DEFAULT                                             *
*                                                                      *
*This routine is performed when account no. is not found in ZACCTNEW   *
*Or when no valid COMBO is found in ZACCTNEW table.                    *
*----------------------------------------------------------------------*
FORM account_by_default.

  MOVE zjhdr-bunit TO subfagl-bunit.
  MOVE zjhdr-bunam TO subfagl-bunam.
  MOVE gc_ps_default TO subfagl-hfmacct.
  COLLECT subfagl.

ENDFORM.                    "ACCOUNT_BY_DEFAULT

*----------------------------------------------------------------------*
*       ACCOUNT_WITH_ERROR
*----------------------------------------------------------------------*
FORM account_with_error.

  MOVE 'NO VALID A/C COMBO-DEFAULTS USED' TO  subfagl-status.
  PERFORM account_by_default.
  CLEAR subfagl.

ENDFORM.                    "ACCOUNT_WITH_ERROR

*----------------------------------------------------------------------*
*        ADD_THIS_RECORD
*----------------------------------------------------------------------*
FORM add_this_record.

  CLEAR: w_hfmacct.

* Get AFFIL & HFM acct number from ZACCTNEW

  MOVE zacctnew-affil TO subfagl-affil.
  IF p_ledger = '0L'.
    MOVE zacctnew-hfmllacct TO w_hfmacct.
  ELSE.
    MOVE zacctnew-hfmnlacct TO w_hfmacct.
  ENDIF.

  MOVE w_hfmacct   TO subfagl-hfmacct.
  MOVE zjhdr-bunit TO subfagl-bunit.
  MOVE zjhdr-bunam TO subfagl-bunam.
  COLLECT subfagl.

ENDFORM.                    "ADD_THIS_RECORD

*----------------------------------------------------------------------*
*        BUILD_DETAIL_RECORD
*----------------------------------------------------------------------*
FORM build_detail_record.

*- Start of Mod. -> C11K918555 (Iss# TR495)
*- New/Simplified File Structure for Hyperion Output

*- Business Unit & YTD Balance
*  MOVE subfagl-bunit   TO detail-business_unit_ln.
*  MOVE subfagl-amount  TO detail-monetary_amount.
**- Account & SubAccount (Affiliate)
*  MOVE subfagl-hfmacct   TO detail-account.
*  MOVE subfagl-affil   TO detail-subaccount.
**- End of Mod. -> C11K918555 (Iss# TR495)
*
*  APPEND: detail.
*  CLEAR:  detail.
*  MOVE subfagl-bunam   TO save_bunam.
*  MOVE subfagl-rtcur   TO save_rtcur.

ENDFORM.                    "BUILD_DETAIL_RECORD

*----------------------------------------------------------------------*
*                 CREATE_OUTPUT_FILE                                   *
*                                                                      *
*Data available in Detail is transfered to Output file on the server   *
*----------------------------------------------------------------------*
FORM create_output_file.

  DATA: msg(100),
        f_length TYPE i,
        lv_string TYPE string.
  CLEAR : gt_fagl,gs_fagl.

*  CHECK NOT ( detail[] IS INITIAL ).
  LOOP AT gtfagl INTO gsfagl.
    MOVE-CORRESPONDING gsfagl TO gs_fagl.
    APPEND gs_fagl TO gt_fagl.
    CLEAR : gs_fagl,gsfagl.
  ENDLOOP.
  OPEN DATASET p_file FOR OUTPUT IN TEXT MODE MESSAGE msg.

  IF sy-subrc NE '0'.
    MESSAGE e002 WITH p_file msg.
    STOP.
  ELSE.
    CONCATENATE text-c01 text-c02 text-c03 text-c04 text-c04
                text-c04 text-c04 text-c04 text-c04 text-c04
                text-c04 text-c04 text-c04 text-c04 text-c04
                text-c04 text-c04 text-c04 text-c04 text-c05
                         INTO lv_string
                         SEPARATED BY '|'.
    TRANSFER lv_string TO p_file.
    CLEAR lv_string.

    LOOP AT gt_fagl ASSIGNING <fs_gtfagl>.
      CONCATENATE <fs_gtfagl>-rbukrs
                  <fs_gtfagl>-ryear
                  <fs_gtfagl>-racct
                  <fs_gtfagl>-hsl01
                  <fs_gtfagl>-hsl02
                  <fs_gtfagl>-hsl03
                  <fs_gtfagl>-hsl04
                  <fs_gtfagl>-hsl05
                  <fs_gtfagl>-hsl06
                  <fs_gtfagl>-hsl07
                  <fs_gtfagl>-hsl08
                  <fs_gtfagl>-hsl09
                  <fs_gtfagl>-hsl10
                  <fs_gtfagl>-hsl11
                  <fs_gtfagl>-hsl12
                  <fs_gtfagl>-hsl13
                  <fs_gtfagl>-hsl14
                  <fs_gtfagl>-hsl15
                  <fs_gtfagl>-hsl16
                  <fs_gtfagl>-hslvt
                  INTO lv_string
                  SEPARATED BY '|'.
      TRANSFER lv_string TO p_file.
      CLEAR lv_string.
    ENDLOOP.
*-   First line in file is 'ACTUAL' or 'IFRS' depending on Ledger

*    IF p_ledger = '0L'.                          "TR831
*      TRANSFER gc_actual TO p_file.             "TR831
*    ELSE.                                        "TR831
*      TRANSFER gc_ifrs TO p_file.               "TR831
*    ENDIF.                                       "TR831
*
**-   Second Line in file is 'Beginning Month'
*    TRANSFER p_perd TO p_file.      "<<<Ins. C11K918555 (Iss# TR495)
*
**-   Third Line in file is 'Ending Month'
*    TRANSFER p_perd TO p_file.      "<<<Ins. C11K918555 (Iss# TR495)
*
**-   Start of Mod. -> C11K918555 (Iss# TR495)
*    PERFORM write_detail_lines.

    CLOSE DATASET p_file.
    MESSAGE text-c06 TYPE 'S'.
  ENDIF.

ENDFORM.                    "CREATE_OUTPUT_FILE

*----------------------------------------------------------------------*
*       FORM PUT_SIGN_IN_FRONT
*----------------------------------------------------------------------*
FORM put_sign_in_front CHANGING value.

  DATA: text1(1) TYPE c.

  SEARCH value FOR '-'.
  IF sy-subrc = 0 AND sy-fdpos <> 0.
    SPLIT value AT '-' INTO value text1.
    CONDENSE value.
    CONCATENATE '-' value INTO value.
  ELSE.
    CONDENSE value.
  ENDIF.

ENDFORM.                    "PUT_SIGN_IN_FRONT

*----------------------------------------------------------------------*
*       FORM PRINT_REPORT
*----------------------------------------------------------------------*
*FORM print_report.
*
*  DATA: tot_amount LIKE subfagl-amount.
*
*  SORT subfagl BY rbukrs racct rtcur hfmacct.
*
*  LOOP AT subfagl.
*    AT NEW rbukrs.
*      SELECT SINGLE * FROM zjhdr
*       WHERE bukrs = subfagl-rbukrs.
*      IF sy-subrc = 0.
*        WRITE: /1 text-116, zjhdr-bunit.
*        WRITE: /1 text-dsh.
*      ENDIF.
*    ENDAT.
*
*    WRITE: /  subfagl-rbukrs UNDER text-104,
*              8(16) subfagl-amount,
*              subfagl-racct  UNDER text-105,
*              subfagl-hfmacct UNDER text-127,
*              subfagl-affil  UNDER text-109,
*              subfagl-status UNDER text-115.
*
*    tot_amount = tot_amount + subfagl-amount.
*
*    IF subfagl-error = 'Y'.
*      DELETE subfagl.
*    ENDIF.
*
*    AT END OF rbukrs.
*      ULINE.
*      WRITE: /1 text-120, 7(17) tot_amount.
*      CLEAR tot_amount.
*      ULINE.
*    ENDAT.
*  ENDLOOP.
*
**- Write error report section for missing Company Codes in ZJHDR
*  SKIP 2.
*  LOOP AT notfound.
*    WRITE: /2 notfound-bukrs, text-118.
*  ENDLOOP.
*  ULINE.
*
**- Start of Ins. -> C11K918555 (Iss# TR495)
**- Write error report section for missing PS Account Rules in ZPSACCT
*  SORT gt_no_psacct.
*  LOOP AT gt_no_psacct.
*    WRITE: /2 gt_no_psacct, text-119.
*  ENDLOOP.
*  ULINE.
**- End of Ins. -> C11K918555 (Iss# TR495)
*
*ENDFORM.                    "PRINT_REPORT

*&---------------------------------------------------------------------*
*&      Form  WRITE_TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM write_top_of_page.
*
*  WRITE: / text-rpt, sy-repid, 42 text-100,                 "Title
*           90 text-dte, sy-datum, text-amp, sy-uzeit.
*  WRITE: / text-clt UNDER text-rpt, sy-mandt, sy-sysid,
**           35 TEXT_COMN, 74 P_PERD, 76 '/', 77 P_YEAR,     "TR654
*           35 text_comn, text-pge UNDER text-dte, sy-pagno. "TR654
*  WRITE: /49 w_ledger.
*  ULINE.
*  WRITE: /1 text-104, 8  text-108, 28 text-105, 38 text-127,
*         51 text-109, 66 text-115.
*  ULINE.

ENDFORM.                    " WRITE_TOP_OF_PAGE

*&---------------------------------------------------------------------*
*&      Form  BUILD_EXTRACT
*&---------------------------------------------------------------------*
FORM build_extract.

*- Build Extract Records
*  LOOP AT subfagl.
*
*    CHECK subfagl-error <> 'Y'.
*
**-   Build Extract Record
*    PERFORM build_detail_record.
*  ENDLOOP.

ENDFORM.                    " BUILD_EXTRACT

*&---------------------------------------------------------------------*
*&      Form  GET_ZPSACCT_REC
*&---------------------------------------------------------------------*
FORM get_zpsacct_rec USING p_acct.

  CLEAR zpsacct.
  SELECT SINGLE * FROM zpsacct INTO zpsacct
                     WHERE psact EQ p_acct.

  CHECK sy-subrc NE 0.

*- Report PeopleSoft Accounts with no mapping in ZPSACCT
  gt_no_psacct = p_acct.
  COLLECT gt_no_psacct.

*- When no ZPSACCT record found use PS Acct '0184007'
  SELECT SINGLE * FROM zpsacct INTO zpsacct
                     WHERE psact EQ gc_ps_default.

  CHECK sy-subrc NE 0.
  gt_no_psacct = gc_ps_default.
  COLLECT gt_no_psacct.

ENDFORM.                    " GET_ZPSACCT_REC

*&---------------------------------------------------------------------*
*&      Form  APPLY_YTD_BALANCE_RULE
*&---------------------------------------------------------------------*
FORM apply_ytd_balance_rule CHANGING p_dollars.

*- Based on the entry in ZPSACCT for Peoplesoft Account#, perform
*- calculation on YTD Balance based on D_IC_ACCT to Flip the sign or not

  CHECK NOT ( p_dollars IS INITIAL ).

  CASE zpsacct-d_ic_acct.

*---FLIP YTD Balace
*   'A' - Not IC Acct - Sign Flipped - Acct Bal * -1
*   'C' - Not IC Acct - Affiliate needed Sign Flipped - Acct Bal * -1
*   'E' - IC Acct     - Not Balancing - Sign Flipped - Acct Bal * -1
*   'G' - IC Acct     - Sign Flipped - Acct Bal * -1
    WHEN 'A' OR 'C' OR 'E' OR 'G'.
      p_dollars = p_dollars * -1.

*---LEAVE YTD Balace "as is"
*   'B' - Not IC Acct - Sign Not Flipped - no change
*   'D' - Not IC Acct - Affiliate needed Sign not Flipped - no change
*   'F' - IC Acct     - Not Balancing Sign not Flipped - no change
*   'H' - IC Acct     - Sign Not Flipped - no change
    WHEN 'B' OR 'D' OR 'F' OR 'H'.
*-     no action

*---SET YTD Balance to Zero as all records with zero balance are not
*extracted
*   'X' - Exclude from Hyperion Extract - Exclude Amounts from file
    WHEN 'X'.
      p_dollars = 0.

  ENDCASE.

ENDFORM.                    " APPLY_YTD_BALANCE_RULE

*&---------------------------------------------------------------------*
*&      Form  WRITE_DETAIL_LINES
*&---------------------------------------------------------------------*
FORM write_detail_lines.

  DATA: l_acct_out(13) TYPE c,
        l_rec(100) TYPE c,
        l_amt(18) TYPE c.

  LOOP AT detail.

*-    Move YTD Balance to sign
    PERFORM put_sign_in_front CHANGING detail-monetary_amount.

*-    Format the YTD Balance -00000000000000.00
    PERFORM format_amount USING detail-monetary_amount
                       CHANGING l_amt.

*-    Format Account.SubAccount field
    IF ( detail-subaccount IS INITIAL ).
      l_acct_out = detail-account.
    ELSE.
      CONCATENATE detail-account '.' detail-subaccount INTO
      l_acct_out.
    ENDIF.

    CLEAR l_rec.
    l_rec+0(5) = detail-business_unit_ln.
    l_rec+5(1) = ','.
    l_rec+6(13) = l_acct_out.
    l_rec+19(1) = ','.
    l_rec+20(19) = l_amt.

*-    Write Detail record to file
    TRANSFER l_rec TO p_file.
  ENDLOOP.

ENDFORM.                    " WRITE_DETAIL_LINES

*&---------------------------------------------------------------------*
*&      Form  FORMAT_AMOUNT
*&---------------------------------------------------------------------*
FORM format_amount USING    p_amt
                   CHANGING p_amt_formatted.

  DATA: l_amt(18) TYPE c.

  l_amt = p_amt.

  IF l_amt CS '-'.
    REPLACE '-' WITH space INTO l_amt.
  ENDIF.

  SHIFT l_amt RIGHT DELETING TRAILING space.
  OVERLAY l_amt WITH gc_zeros.

  IF p_amt CS '-'.
    l_amt+0(1) = '-'.
  ENDIF.

  p_amt_formatted = l_amt.

ENDFORM.                    " FORMAT_AMOUNT

*&---------------------------------------------------------------------*
*&      Form  APPLY_PS_ACCT_RULES
*&---------------------------------------------------------------------*
*FORM apply_ps_acct_rules.
*
*  LOOP AT subfagl.
*
**-  Get the ZPSACCT record to determine PS rule based on PS Account
*    PERFORM get_zpsacct_rec USING subfagl-hfmacct.
*
**-  Perform rule calculation on YTD Balance
*    PERFORM apply_ytd_balance_rule CHANGING subfagl-amount.
*
**-  Remove Affiliate based on rule
*    IF ( zpsacct-d_ic_acct EQ 'A' ) OR ( zpsacct-d_ic_acct EQ 'B' ).
*      CLEAR subfagl-affil.
*    ENDIF.
*
*    IF subfagl-amount EQ 0.
*      DELETE subfagl.
*    ELSE.
*      MODIFY subfagl TRANSPORTING amount affil.
*    ENDIF.
*
*  ENDLOOP.
*
*ENDFORM.                    " APPLY_PS_ACCT_RULES
