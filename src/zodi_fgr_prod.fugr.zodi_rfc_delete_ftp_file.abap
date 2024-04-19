FUNCTION ZODI_RFC_DELETE_FTP_FILE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_FILENAME) TYPE  BAPIEXT-VALUE
*"     VALUE(IV_USER) TYPE  BAPI0012_3-NAME
*"     VALUE(IV_PWD) TYPE  BAPI0012_3-NAME
*"     VALUE(IV_HOST) TYPE  CHAR35
*"     VALUE(IV_PATH) TYPE  CFDAT60
*"  TABLES
*"      ET_FILE_RETURN STRUCTURE  BAPIRET2
*"--------------------------------------------------------------------


*****Start of FTP Specific*****
*Calling FTP program
TYPES: BEGIN OF gs_text,
  line(356) TYPE c,
  END OF gs_text.
DATA:
gc_error   VALUE 'E',
gc_success VALUE 'S',
wa_result TYPE string,
gt_result  TYPE TABLE OF gs_text.
  DATA: lv_hdl TYPE i,
  lv_cmd(120) TYPE c,
  lv_slen TYPE i,
  lv_line TYPE i .
  DATA: lc_dest TYPE rfcdes-rfcdest VALUE 'SAPFTPA',
  lc_key TYPE i VALUE 26101957,
  lc_pasv VALUE 'X',
  lc_cmd1(20) TYPE c VALUE 'set passive on',
  lc_cmd2(5) TYPE c VALUE 'del'.
  TYPES: BEGIN OF ls_blob,
  line(300) TYPE c,
  END OF ls_blob.
  TYPES: BEGIN OF ls_text,
  line(300) TYPE c,
  END OF ls_text.
  DATA: lt_txtdata TYPE TABLE OF ls_text.
  DATA: wa_txtdata LIKE LINE  OF lt_txtdata.
  DATA: lt_result  TYPE TABLE OF ls_text,
        lw_result  TYPE ls_text.
  DATA: t_vers TYPE cvers .
  DATA: path TYPE char35.


SELECT SINGLE * FROM cvers INTO t_vers
WHERE component = 'SAP_ABA'.
lv_slen = STRLEN( iv_pwd ).

IF t_vers-release >= '700'.
*To Scrammble password for ECC 6.0
CALL FUNCTION 'HTTP_SCRAMBLE'
  EXPORTING
    SOURCE      = iv_pwd
    sourcelen   = lv_slen
    key         = lc_key
  IMPORTING
    destination = iv_pwd.
ELSE.
CALL FUNCTION 'SCRAMBLE_STRING'
  EXPORTING
    SOURCE        = iv_pwd
 IMPORTING
   TARGET        = iv_pwd.
ENDIF.
          .


CALL FUNCTION 'FTP_CONNECT'
  EXPORTING
   user            = iv_user
   password        = iv_pwd
   host            = iv_host
   rfc_destination = lc_dest
  IMPORTING
   handle          = lv_hdl
  EXCEPTIONS
   not_connected   = 1
   OTHERS          = 2.
IF sy-subrc <> 0.
CLEAR et_file_return.
et_file_return-type = gc_error.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO
et_file_return-message .
APPEND et_file_return.
ELSE.
IF NOT lc_pasv IS INITIAL.
REFRESH lt_result.
lv_cmd  = lc_cmd1.
CALL FUNCTION 'FTP_COMMAND'
 EXPORTING
  handle        = lv_hdl
  command       = lv_cmd
TABLES
  data          = lt_result
EXCEPTIONS
 tcpip_error   = 1
 command_error = 2
 data_error    = 3.
IF sy-subrc <> 0.
CLEAR et_file_return.
et_file_return-type = gc_error.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO
et_file_return-message .
APPEND et_file_return.
ENDIF.
CONCATENATE lc_cmd2 iv_filename
INTO lv_cmd SEPARATED BY ' '.
REFRESH lt_result.
CONCATENATE 'cd' iv_path INTO path SEPARATED BY space.
CALL FUNCTION 'FTP_COMMAND'
EXPORTING
 handle        = lv_hdl
 command       = path
TABLES
  data          = lt_result
EXCEPTIONS
 tcpip_error   = 1
command_error = 2
data_error    = 3.
IF sy-subrc NE 0.
CLEAR et_file_return.
et_file_return-type = gc_error.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO
et_file_return-message .
APPEND et_file_return.
EXIT.
ELSE.
CLEAR et_file_return.
et_file_return-type = gc_success.
et_file_return-message =
'Directory changed successfully'.
 APPEND et_file_return.
 ENDIF.
CALL FUNCTION 'FTP_COMMAND'
EXPORTING
 handle        = lv_hdl
 command       = lv_cmd
TABLES
 data          = lt_result
EXCEPTIONS
 tcpip_error   = 1
 command_error = 2
 data_error    = 3.
IF sy-subrc NE 0.
 CLEAR et_file_return.
et_file_return-type = gc_error.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO
et_file_return-message .
APPEND et_file_return.
EXIT.
ELSE.
CLEAR et_file_return.
et_file_return-type = gc_success.
et_file_return-message =
'Data Transfer Successful'.
APPEND et_file_return.
CALL FUNCTION 'FTP_DISCONNECT'
EXPORTING
 handle = lv_hdl.
CALL FUNCTION 'RFC_CONNECTION_CLOSE'
EXPORTING
 destination = lc_dest
EXCEPTIONS
 OTHERS      = 1.
 ENDIF.
ELSE.
CLEAR et_file_return.
et_file_return-type = gc_error.
et_file_return-message = 'No data Available'.
APPEND et_file_return.
CALL FUNCTION 'FTP_DISCONNECT'
 EXPORTING
  handle = lv_hdl.
CALL FUNCTION 'RFC_CONNECTION_CLOSE'
 EXPORTING
  destination = lc_dest
 EXCEPTIONS
  OTHERS      = 1.
IF sy-subrc <> 0.
CLEAR et_file_return.
et_file_return-type = gc_error.
MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO
et_file_return-message .
APPEND et_file_return.
ENDIF.
ENDIF.
ENDIF.




ENDFUNCTION.
