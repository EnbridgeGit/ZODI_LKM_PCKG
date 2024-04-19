FUNCTION ZODI_BG_CONTROLLER.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ACTION) TYPE  CHAR10
*"     VALUE(IV_JOBNAME) TYPE  TBTCJOB-JOBNAME
*"     VALUE(IV_JOBCLASS) TYPE  BTCJOBCLAS
*"     VALUE(IV_JOBCOUNT) TYPE  TBTCJOB-JOBCOUNT OPTIONAL
*"     VALUE(IV_APPOBJ_NAME) TYPE  CHAR20 OPTIONAL
*"     VALUE(IV_SUBOBJ_NAME) TYPE  CHAR20 OPTIONAL
*"     VALUE(IV_DELIMITER) TYPE  CHAR3 OPTIONAL
*"     VALUE(IV_FILENAME) TYPE  CHAR255 OPTIONAL
*"     VALUE(IV_USER) TYPE  CHAR35 OPTIONAL
*"     VALUE(IV_PWD) TYPE  CHAR35 OPTIONAL
*"     VALUE(IV_HOST) TYPE  CHAR35 OPTIONAL
*"     VALUE(IV_HASHVALUE) TYPE  CHAR35 OPTIONAL
*"     VALUE(IV_PATH) TYPE  CHAR255 OPTIONAL
*"     VALUE(IV_MAX_ROW_CNT) TYPE  SYTABIX OPTIONAL
*"     VALUE(IV_FETCH_BATCH_SIZE) TYPE  SYTABIX OPTIONAL
*"     VALUE(IT_ODIVAR) TYPE  ZODI_COND OPTIONAL
*"     VALUE(IV_PROGNAME) TYPE  CPROG OPTIONAL
*"     VALUE(IV_EXT_ID) TYPE  BALHDR-EXTNUMBER OPTIONAL
*"     VALUE(IV_TMP_DIR_PATH) TYPE  CHAR255 OPTIONAL
*"     VALUE(IV_LOG_DIR_PATH) TYPE  CHAR255 OPTIONAL
*"  EXPORTING
*"     VALUE(EV_JOBCOUNT) LIKE  TBTCJOB-JOBCOUNT
*"     VALUE(EV_JOBSTATE) LIKE  TBTCO-JOBGROUP
*"     VALUE(EV_APIVERSION) LIKE  TBTCJOB-JOBCOUNT
*"     VALUE(EV_EXT_ID) LIKE  BALHDR-EXTNUMBER
*"  TABLES
*"      ET_JOBLOGTBL STRUCTURE  TBTC5
*"      ET_FILE_RETURN STRUCTURE  BAPIRET2
*"--------------------------------------------------------------------


DATA: release_status,
 IV_HANDLE TYPE BALMSGHNDL,
 E_S_MSG   TYPE  BAL_S_MSG.

DATA:
lv_aborted     TYPE btcstatus,
lv_finished    TYPE btcstatus,
lv_preliminary TYPE btcstatus,
lv_ready       TYPE btcstatus,
lv_running     TYPE btcstatus,
lv_scheduled   TYPE btcstatus,
lv_cond1       TYPE line,
lv_cond2       TYPE line,
lv_cond3       TYPE line,
lv_cond4       TYPE line,
lv_cond5       TYPE line,
lv_guid        TYPE guid_32.

FIELD-SYMBOLS: <ls_cond> TYPE line.

DATA gt_message TYPE bapiret2.
TYPES: BEGIN OF lty_spool,
         name TYPE rqident,
       END OF lty_spool.

DATA: wa_spool TYPE lty_spool,
      lt_spool TYPE TABLE OF lty_spool,
      lt_tbtcp TYPE TABLE OF tbtcp,
      lv_subrc TYPE sysubrc,
      lv_error TYPE rspoemsg.

FIELD-SYMBOLS: <ls_tbtcp> TYPE tbtcp.

WRITE :'Operation Selected :',iv_action,sy-uzeit.
NEW-LINE.

IF iv_action = 'JOB_SUBMIT'.
CALL FUNCTION 'JOB_OPEN'
  EXPORTING
    jobname          = iv_jobname
    jobclass         = iv_jobclass
  IMPORTING
    jobcount         = ev_jobcount
  EXCEPTIONS
    cant_create_job  = 1
    invalid_job_data = 2
    jobname_missing  = 3
    OTHERS           = 4.
IF sy-subrc <> 0.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
ENDIF.

WRITE :'Job ID is created:',ev_jobcount,sy-uzeit.
NEW-LINE.

DATA:rspar_tab  TYPE TABLE OF rsparams,
     rspar_line LIKE LINE OF rspar_tab,
     wa_odivar    TYPE zodi_cond_str.

RANGES: it_cond FOR line .
LOOP AT it_odivar INTO wa_odivar.
  it_cond-sign = 'I'.
  it_cond-option = 'EQ'.
  it_cond-low = wa_odivar-field.
  APPEND it_cond.
  it_cond-sign = 'I'.
  it_cond-option = 'EQ'.
  it_cond-low = wa_odivar-val.
  APPEND it_cond.
  CLEAR : wa_odivar,it_cond.
ENDLOOP.

CALL FUNCTION 'GUID_CREATE'
 IMPORTING
  EV_GUID_32       =   lv_guid.

EV_EXT_ID = lv_guid.

*********************************
*****Version control code********
*********************************
IF NOT IV_TMP_DIR_PATH IS INITIAL
OR NOT IV_LOG_DIR_PATH IS INITIAL.
**submit report with IV_TMP_DIR_PATH field****
SUBMIT (iv_progname)
AND RETURN
WITH iv_deli = iv_delimiter
WITH iv_file = iv_filename
WITH iv_user  = iv_user
WITH iv_pwd   = iv_pwd
WITH iv_host  = iv_host
WITH iv_hash = iv_hashvalue
WITH iv_path  = iv_path
WITH iv_maxc = iv_max_row_cnt
WITH iv_fetc = iv_fetch_batch_size
WITH IV_app = IV_APPOBJ_NAME
WITH IV_SUb = IV_SUBOBJ_NAME
WITH IV_EXTID        = EV_EXT_ID
WITH IV_TMDIR = IV_TMP_DIR_PATH
WITH IV_LODIR = IV_LOG_DIR_PATH
WITH it_cond IN it_cond
USER sy-uname
VIA JOB iv_jobname
NUMBER ev_jobcount.

ELSE.
**submit report without IV_TMP_DIR_PATH field****
  SUBMIT (iv_progname)
AND RETURN
WITH iv_deli = iv_delimiter
WITH iv_file = iv_filename
WITH iv_user  = iv_user
WITH iv_pwd   = iv_pwd
WITH iv_host  = iv_host
WITH iv_hash = iv_hashvalue
WITH iv_path  = iv_path
WITH iv_maxc = iv_max_row_cnt
WITH iv_fetc = iv_fetch_batch_size
WITH IV_app = IV_APPOBJ_NAME
WITH IV_SUb = IV_SUBOBJ_NAME
WITH IV_EXTID        = EV_EXT_ID
WITH it_cond IN it_cond
USER sy-uname
VIA JOB iv_jobname
NUMBER ev_jobcount.
ENDIF.

WRITE: 'Job Submitted',sy-uzeit.
NEW-LINE.

CALL FUNCTION 'JOB_CLOSE'
  EXPORTING
    jobcount             = ev_jobcount
    jobname              = iv_jobname
    strtimmed            = 'X'
  IMPORTING
    job_was_released     = release_status
  EXCEPTIONS
    cant_start_immediate = 1
    invalid_startdate    = 2
    jobname_missing      = 3
    job_close_failed     = 4
    job_nosteps          = 5
    job_notex            = 6
    lock_failed          = 7
    invalid_target       = 8
    OTHERS               = 9.
IF sy-subrc <> 0.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
ENDIF.

WRITE :'Job Close with release status',release_status.
NEW-LINE.
ELSEIF iv_action = 'JOB_STATE'.

CALL FUNCTION 'SHOW_JOBSTATE'
  EXPORTING
    jobcount         = iv_jobcount
    jobname          = iv_jobname
  IMPORTING
    aborted          = lv_aborted
    finished         = lv_finished
    preliminary      = lv_preliminary
    ready            = lv_ready
    running          = lv_running
    scheduled        = lv_scheduled
  EXCEPTIONS
    jobcount_missing = 1
    jobname_missing  = 2
    job_notex        = 3
    OTHERS           = 4.
IF sy-subrc <> 0.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
ENDIF.

IF sy-subrc = 0.
  IF lv_aborted  = 'X'.
    ev_jobstate = 'ABORTED'.
    WRITE :'Job is aborted',sy-uzeit.
  ELSEIF lv_finished  = 'X'.
    ev_jobstate = 'FINISHED'.
    WRITE :'Job is Finished',sy-uzeit.
  ELSEIF lv_preliminary  = 'X'.
    ev_jobstate = 'PRELIMINARY'.
    WRITE :'Job is Preliminary',sy-uzeit.
  ELSEIF lv_ready  = 'X'.
    ev_jobstate = 'READY'.
    WRITE :'Job is ready',sy-uzeit.
  ELSEIF lv_running  = 'X'.
    ev_jobstate = 'RUNNING'.
    WRITE :'Job is running',sy-uzeit.
  ELSEIF lv_scheduled  = 'X'.
    ev_jobstate = 'SCHEDULED'.
    WRITE :'Job is scheduled',sy-uzeit.
  ENDIF.
ENDIF.

ELSEIF iv_action = 'JOB_LOG'.

CALL FUNCTION 'BP_JOBLOG_READ'
  EXPORTING
    client                = sy-mandt
    jobcount              = iv_jobcount
    joblog                = ' '
    jobname               = iv_jobname
  TABLES
    joblogtbl             = et_joblogtbl
  EXCEPTIONS
    cant_read_joblog      = 1
    jobcount_missing      = 2
    joblog_does_not_exist = 3
    joblog_is_empty       = 4
    joblog_name_missing   = 5
    jobname_missing       = 6
    job_does_not_exist    = 7
    OTHERS                = 8.

IF sy-subrc <> 0.
  CLEAR et_file_return.
  et_file_return-type = 'E'.
  CASE sy-subrc.
    WHEN 1.
      et_file_return-message =
      'Cannot Read the Job log'.
    WHEN 2.
      et_file_return-message =
      'Job Count Missing'.
    WHEN 3.
      et_file_return-message =
      'Job Log does not exist'.
    WHEN 4.
      et_file_return-message =
      'Job Log is empty'.
    WHEN 5.
      et_file_return-message =
      'Job Log name is missing'.
    WHEN 6.
      et_file_return-message =
      'Job name is missing'.
    WHEN 7.
      et_file_return-message =
      'Job does not exist'.
  ENDCASE.
  APPEND et_file_return.
  EXIT.

ENDIF.

LOOP AT et_file_return.
  WRITE :et_file_return-message.
  NEW-LINE.
ENDLOOP.

ELSEIF  iv_action = 'API_VERSION'.
  ev_apiversion = '1.0'.

ELSEIF iv_action = 'JOB_ABORT'.

DATA: ls_tbtco TYPE tbtco,
      lv_procid TYPE WPPID.
CALL FUNCTION 'BP_JOB_ABORT'
  EXPORTING
    jobcount                   = iv_jobcount
    jobname                    = iv_jobname
  EXCEPTIONS
    checking_of_job_has_failed = 1
    job_abort_has_failed       = 2
    job_does_not_exist         = 3
    job_is_not_active          = 4
    no_abort_privilege_given   = 5
    OTHERS                     = 6.
IF sy-subrc <> 0.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
*New Logic
ELSE.
 DO 5 TIMES.
 SELECT SINGLE * from tbtco
 INTO ls_tbtco
 WHERE jobname eq iv_jobname
 AND jobcount eq iv_jobcount.
 IF sy-subrc IS INITIAL.
  IF ls_tbtco-status = 'A'.
WRITE :'Job is forcefully aborted',sy-uzeit.
EXIT.
  ELSE.
  lv_procid = ls_tbtco-wpprocid.
    CALL FUNCTION 'TH_STOP_WP'
      EXPORTING
        WP_PID             = lv_procid.
  ENDIF.

 ENDIF.
 ENDDO.
ENDIF.

ELSEIF iv_action = 'JOB_SPOOL'.
  DATA: lv_spool_num TYPE btclistid,
        lv_spool TYPE rspoid,
        it_spool_xls TYPE TABLE OF LINE,
        wa_spool_xls TYPE line.

  SELECT SINGLE listident
  FROM tbtcp
  INTO lv_spool_num
  WHERE jobname EQ iv_jobname
  AND jobcount  EQ iv_jobcount
  AND stepcount EQ 1.
  IF sy-subrc EQ 0 AND NOT lv_spool_num IS INITIAL.
  lv_spool = lv_spool_num.
  CALL FUNCTION 'RSPO_RETURN_ABAP_SPOOLJOB'
    EXPORTING
      rqident                    = lv_spool
*  FIRST_LINE                 = 1
*  LAST_LINE                  =
    TABLES
      buffer                     = it_spool_xls
   EXCEPTIONS
     no_such_job                = 1
     not_abap_list              = 2
     job_contains_no_data       = 3
     selection_empty            = 4
     no_permission              = 5
     can_not_access             = 6
     read_error                 = 7
     OTHERS                     = 8.
IF sy-subrc <> 0.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
ENDIF.

et_file_return-type = 'S'.
LOOP AT it_spool_xls INTO wa_spool_xls.
  et_file_return-message = wa_spool_xls.
  APPEND et_file_return.
  CLEAR : wa_spool_xls.
ENDLOOP.
ENDIF.
ELSEIF iv_action = 'SPOOL_CLR'.

SELECT * FROM tbtcp
INTO TABLE lt_tbtcp
WHERE jobname EQ iv_jobname
AND JOBCOUNT eq IV_JOBCOUNT.
IF sy-subrc EQ 0.
  LOOP AT lt_tbtcp ASSIGNING <ls_tbtcp>.
    wa_spool-name = <ls_tbtcp>-listident.
    APPEND wa_spool TO lt_spool.
    CLEAR wa_spool.
  ENDLOOP.
ENDIF.

DELETE lt_spool WHERE name IS INITIAL.

LOOP AT lt_spool INTO wa_spool.
  CALL FUNCTION 'RSPO_R_RDELETE_SPOOLREQ'
    EXPORTING
      spoolid             = wa_spool-name
   IMPORTING
     status              = lv_subrc.
  IF lv_subrc NE 0.
 CLEAR et_file_return.
 et_file_return-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER
 SY-MSGNO
 INTO et_file_return-message
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
 ELSE.
 CLEAR et_file_return.
 et_file_return-type = 'S'.
 et_file_return-message = 'Spool is deleted'.
 et_file_return-message_v1 = wa_spool-name.
 APPEND et_file_return.
 ENDIF.
ENDLOOP.

ELSEIF IV_ACTION = 'LOG_DISP'
    OR IV_ACTION = 'LOG_DEL'.

CALL FUNCTION 'ZODI_APPLOG'
  EXPORTING
    IV_ACTION            = IV_ACTION
    IV_APPOBJ_NAME       = IV_APPOBJ_NAME
    IV_SUBOBJ_NAME       = IV_SUBOBJ_NAME
    IV_EXT_ID            = IV_EXT_ID
  TABLES
    ET_FILE_RETURN       = ET_FILE_RETURN.
ENDIF.



ENDFUNCTION.
