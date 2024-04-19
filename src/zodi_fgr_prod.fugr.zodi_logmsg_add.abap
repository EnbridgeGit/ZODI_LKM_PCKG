FUNCTION ZODI_LOGMSG_ADD.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ET_FILE_RETURN) TYPE  BAPIRET2
*"     VALUE(I_LOG_HANDLE) TYPE  BALLOGHNDL OPTIONAL
*"     VALUE(LS_LOG) TYPE  BAL_S_LOG OPTIONAL
*"  TABLES
*"      ET_HANDLE TYPE  BAPIRET2_T OPTIONAL
*"--------------------------------------------------------------------


CALL FUNCTION 'ZODI_LOGMSG_ADD_TASK'
  EXPORTING
    ET_FILE_RETURN       = et_file_return
    I_LOG_HANDLE         = i_log_handle
    LS_LOG               = ls_log
 TABLES
   et_HANDLE        = et_HANDLE .



ENDFUNCTION.
