FUNCTION ZODI_LOGMSG_ADD_TASK.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ET_FILE_RETURN) TYPE  BAPIRET2
*"     VALUE(I_LOG_HANDLE) TYPE  BALLOGHNDL OPTIONAL
*"     VALUE(LS_LOG) TYPE  BAL_S_LOG OPTIONAL
*"  TABLES
*"      ET_HANDLE TYPE  BAPIRET2_T OPTIONAL
*"--------------------------------------------------------------------


DATA : I_S_MSG TYPE BAL_S_MSG ,
       E_S_MSG_HANDLE TYPE BALMSGHNDL,
       es_file_return TYPE BAPIRET2,
       T1 TYPE CHAR10,
       ls_handle TYPE bapiret2.

DATA: lt_handle TYPE BAL_T_LOGH.

IF i_log_handle IS INITIAL.
CALL FUNCTION 'BAL_LOG_CREATE'
EXPORTING
 I_S_LOG                 = ls_log
IMPORTING
 E_LOG_HANDLE            = i_log_handle
EXCEPTIONS
 LOG_HEADER_INCONSISTENT = 1
OTHERS                  = 2.
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ELSE.
 ls_handle-message = i_log_handle.
 APPEND ls_handle TO et_handle.
 CLEAR ls_handle.
ENDIF.
ENDIF.

IF et_file_return-ID IS INITIAL.
 et_file_return-ID = 'CL'.
ENDIF.

IF et_file_return-NUMBER IS INITIAL.
  et_file_return-NUMBER = '000'.
ENDIF.

I_S_MSG-MSGTY = et_file_return-TYPE.
I_S_MSG-MSGID = et_file_return-ID.
I_S_MSG-MSGNO = et_file_return-NUMBER.
I_S_MSG-MSGV1 = et_file_return-MESSAGE.
I_S_MSG-MSGV2 = et_file_return-MESSAGE_V1.
I_S_MSG-MSGV3 = et_file_return-MESSAGE_V2.
I_S_MSG-MSGV4 = et_file_return-MESSAGE_V3.
I_S_MSG-PROBCLASS = '1'.

CALL FUNCTION 'BAL_LOG_MSG_ADD'
  EXPORTING
    I_S_MSG                  = I_S_MSG
 EXCEPTIONS
   LOG_NOT_FOUND             = 1
   MSG_INCONSISTENT          = 2
   LOG_IS_FULL               = 3
   OTHERS                    = 4
          .
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ELSE.

CLEAR lt_handle.

append I_LOG_handle TO lt_handle.

CALL FUNCTION 'BAL_DB_SAVE'
 EXPORTING
   I_CLIENT               = SY-MANDT
   I_SAVE_ALL             = 'X'
   I_T_LOG_HANDLE         = lt_handle
 EXCEPTIONS
   LOG_NOT_FOUND          = 1
   SAVE_NOT_ALLOWED       = 2
   NUMBERING_ERROR        = 3
   OTHERS                 = 4 .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
ENDIF.



ENDFUNCTION.
