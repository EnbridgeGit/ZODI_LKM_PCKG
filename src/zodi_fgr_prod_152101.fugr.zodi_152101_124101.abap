FUNCTION zodi_152101_124101.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_DELIMITER) TYPE  CHAR3
*"     VALUE(IV_FILENAME) TYPE  CHAR255
*"     VALUE(IV_USER) TYPE  CHAR35
*"     VALUE(IV_PWD) TYPE  CHAR35
*"     VALUE(IV_HOST) TYPE  CHAR35
*"     VALUE(IV_HASHVALUE) TYPE  CHAR35
*"     VALUE(IV_PATH) TYPE  CHAR255
*"     VALUE(IV_MAX_ROW_CNT) TYPE  SYTABIX
*"     VALUE(IV_FETCH_BATCH_SIZE) TYPE  SYTABIX
*"     VALUE(IV_TMP_DIR_PATH) TYPE  CHAR255 OPTIONAL
*"  TABLES
*"      RETURN STRUCTURE  BAPIRETURN
*"      ET_FILE_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------


************************
*Final Type declarations
************************
  TYPES : BEGIN OF ty_final,

  c1_ktopl TYPE
   ska1-ktopl,
  c2_saknr TYPE
   ska1-saknr,
  c3_ktoks TYPE
   ska1-ktoks,
  END OF ty_final.
*****************************
*Final Temp Type Declarations
*****************************
  TYPES : BEGIN OF ty_final_tmp,

  c1_ktopl TYPE
   ska1-ktopl,
  c2_saknr TYPE
   ska1-saknr,
  c3_ktoks TYPE
   ska1-ktoks,
  END OF ty_final_tmp.
*******************************
*Final Target Type Declarations
*******************************
  TYPES : BEGIN OF ty_final_target,

  c1_ktopl TYPE
   ska1-ktopl,
  c2_saknr TYPE
   ska1-saknr,
  c3_ktoks TYPE
   ska1-ktoks,
  END OF ty_final_target.

**************************
* Table type for SKA1
**************************
  TYPES : BEGIN OF ty_ska1,

  c1_ktopl TYPE
   ska1-ktopl,
  c2_saknr TYPE
   ska1-saknr,
  c3_ktoks TYPE
   ska1-ktoks,
  END OF ty_ska1.
  TYPES: BEGIN OF gs_text,
  line(37) TYPE c,
  END OF gs_text.
************************
*Structure Declarations
************************
  DATA: wa_final_tmp TYPE ty_final_tmp.
  DATA: wa_final_string TYPE string,
        wa_final TYPE ty_final,
        wa_final_target TYPE ty_final_target,
  wa_ska1 TYPE ty_ska1,
********************
*Table Declarations
********************
  gt_result TYPE TABLE OF gs_text,
  tt_final TYPE STANDARD TABLE OF ty_final,
  tt_final_target TYPE STANDARD
  TABLE OF ty_final_target,
  tt_final_tmp TYPE STANDARD
  TABLE OF ty_final_tmp,
  tt_final_tmp1 TYPE STANDARD
  TABLE OF ty_final,
  tt_ska1 TYPE STANDARD TABLE OF ty_ska1,
***********************
*Variable Declarations
***********************
  lv_flag TYPE char1,
  c1_ktopl
   TYPE string,
  c2_saknr
   TYPE string,
  c3_ktoks
   TYPE string,
  lv_delimiter TYPE string,
  lv_tabix_frm TYPE sy-tabix,
  lv_path TYPE string,
  lv_file TYPE string,
  lv_datum TYPE sy-datum,
  lv_date  TYPE char10,
**17-07-2014
  lv_mesg TYPE string,
  wa_result TYPE string,
  lv_cnt TYPE sytabix,
  lv_path_authority TYPE char255.
  DEFINE authority_check.
    authority-check object 'S_DATASET'
       id 'PROGRAM' field &1
       id 'ACTVT' field '06'
    id 'ACTVT' field '33'
    id 'ACTVT' field '34'
       id 'FILENAME' field lv_path_authority.
    if sy-subrc <> 0.
      clear et_file_return.
      et_file_return-type = 'E'.
      et_file_return-message =
      'Error: Authorization for S_DATASET' .
      et_file_return-message_v1 =
      'or some activity authorization under'.
      et_file_return-message_v2 =
      'S_DATASET is missing.'.
      append et_file_return.

      exit.
    endif.
  END-OF-DEFINITION.
**17-07-2014
*********************
*Cursor Declaration
*********************
  DATA: lv_ska1_dbcur  TYPE cursor.
************************
*Hash value comparison
************************
  lv_delimiter = iv_delimiter.
  "As requested, this hash value comment out because legacy enbridge
  "and spectra call this FM with different hashvalue.
*IF  iv_hashvalue NE '-2052110148'.
*CLEAR et_file_return.
*et_file_return-id = 'CL'.
*et_file_return-type = 'E'.
*et_file_return-number = '000'.
*et_file_return-message =
*'Installed ABAP program does not match interface definition'.
*APPEND et_file_return.
*EXIT.
*ENDIF.
**17-07-2014
*************************
*Open/delete output file
*************************
  CONCATENATE iv_path iv_filename INTO lv_path.
  lv_path_authority = lv_path.
  authority_check 'SAPLSLOG'.
  authority_check 'ZODI*'.
  authority_check 'SAPLZODI*'.
  authority_check 'SAPLSTRF'.
**17-07-2014
*************************
*Open/delete output file
*************************
*CONCATENATE iv_path iv_filename INTO lv_path.
******************************************************
*Check for file existence, if found, delete it
******************************************************
***************************
**Opening a file for input
***************************
  OPEN DATASET lv_path FOR INPUT
       IN TEXT MODE
       ENCODING DEFAULT.
  IF sy-subrc EQ 0.
*******************************
**Deleting file from file path
*******************************
    DELETE DATASET lv_path.

  ENDIF.
***************************
*Open/create output file
***************************
********************************
**Opening a file in append mode
********************************
  OPEN DATASET lv_path FOR APPENDING
       IN TEXT MODE
       ENCODING DEFAULT.
  IF sy-subrc NE 0.
**17-07-2014
    CLEAR: et_file_return, lv_mesg.
    et_file_return-type = 'E'.
    CONCATENATE
    'Error occurred when creating dataset ' lv_path
    INTO lv_mesg.
    et_file_return-message = lv_mesg.
    APPEND et_file_return.
**17-07-2014
*Append et_file_return.
  ENDIF.
*****************
*Batch Processing
*****************
************************************************
*Opening for Database Cursor for Data retrieval
************************************************
  OPEN CURSOR WITH HOLD lv_ska1_dbcur FOR
  SELECT ktopl
  saknr
  ktoks
  FROM  ska1.
  DO.
************************************************
*Check for the counter, only for first batch
*process new line is required...
************************************************
    lv_cnt  = lv_cnt  + 1.
************************************************
**Refreshing the final internal table
************************************************
    REFRESH tt_ska1.
    FETCH NEXT CURSOR lv_ska1_dbcur
    APPENDING TABLE tt_ska1
************************************************************
*Extract Data from database cursor based on FETCH_BATCH_SIZE
************************************************************
    PACKAGE SIZE iv_fetch_batch_size.

    IF tt_ska1 IS INITIAL.
      EXIT.
    ENDIF.
    LOOP AT tt_ska1 INTO wa_ska1.
      MOVE wa_ska1-c1_ktopl
       TO wa_final_tmp-c1_ktopl.
      MOVE wa_ska1-c2_saknr
       TO wa_final_tmp-c2_saknr.
      MOVE wa_ska1-c3_ktoks
       TO wa_final_tmp-c3_ktoks.
      APPEND wa_final_tmp TO tt_final_tmp.
    ENDLOOP.
    FREE :  tt_ska1.
    LOOP AT tt_final_tmp INTO wa_final_tmp.
      MOVE wa_final_tmp-c1_ktopl
       TO wa_final_target-c1_ktopl.
      MOVE wa_final_tmp-c2_saknr
       TO wa_final_target-c2_saknr.
      MOVE wa_final_tmp-c3_ktoks
       TO wa_final_target-c3_ktoks.
      APPEND wa_final_target TO tt_final_target.
    ENDLOOP.
    FREE : tt_final_tmp.
    CLEAR wa_final_target.
*Default value of MAX_ROW_COUNT
    IF iv_max_row_cnt IS INITIAL.
      MOVE 2147483647 TO iv_max_row_cnt.
    ENDIF.
    LOOP AT tt_final_target INTO
    wa_final_target TO iv_max_row_cnt.
      MOVE wa_final_target-c1_ktopl
       TO c1_ktopl.
      MOVE wa_final_target-c2_saknr
       TO c2_saknr.
      MOVE wa_final_target-c3_ktoks
       TO c3_ktoks.
      CONCATENATE
      c1_ktopl
      c2_saknr
      c3_ktoks
      INTO wa_final_string
      SEPARATED BY lv_delimiter.
*******************************
*For first entry no delimiter is kept
*in the beginning
*******************************
      IF sy-tabix EQ 1 AND lv_cnt EQ 1.
        CONCATENATE wa_final_string
        lv_delimiter INTO wa_final_string.
      ELSE.
**************************************
*For remaining entry delimiter is kept
**************************************
        CONCATENATE '' lv_delimiter wa_final_string
        lv_delimiter INTO wa_final_string.
      ENDIF.
      APPEND wa_final_string TO gt_result.
      CLEAR : c1_ktopl,
      c2_saknr,
      c3_ktoks.
    ENDLOOP.
    FREE : tt_final_target.
    IF NOT gt_result IS INITIAL.
*******************************
*Transfer data to a file
*******************************
      CLEAR wa_result.
      LOOP AT gt_result INTO wa_result.
        TRANSFER wa_result TO lv_path.
      ENDLOOP.
    ENDIF.
*************************************
*To get the number of records in the
*final internal table
*************************************
    DESCRIBE TABLE gt_result LINES lv_cnt.
    WRITE : 'No of records in final table is :',lv_cnt.
    REFRESH gt_result.
*******************************
*End of main loop for batching
*******************************
  ENDDO.
*****Close dataset
  CLOSE DATASET lv_path.
************************************
*Error Handling for closing dataset
************************************
  IF sy-subrc NE 0.
    CLEAR et_file_return.
    et_file_return-type = 'E'.
    et_file_return-message =
    'Error occured in closing the dataset'.
    APPEND et_file_return.
  ENDIF.
  CLOSE CURSOR lv_ska1_dbcur.
  DESCRIBE TABLE gt_result LINES lv_cnt.
  WRITE : 'No of records in final table is :',lv_cnt.
************************************
*Error Handling for closing cursor
************************************
*IF SY-SUBRC NE 0.
*CLEAR et_file_return.
*et_file_return-type = 'E'.
*et_file_return-message =
*'Error occured while close cursor command'.
*APPEND et_file_return.
*ENDIF.



ENDFUNCTION.
