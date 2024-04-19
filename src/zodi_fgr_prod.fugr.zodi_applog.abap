FUNCTION ZODI_APPLOG.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ACTION) TYPE  CHAR10
*"     VALUE(IV_APPOBJ_NAME) TYPE  BALHDR-OBJECT
*"     VALUE(IV_SUBOBJ_NAME) TYPE  BALHDR-SUBOBJECT
*"     VALUE(IV_EXT_ID) TYPE  BALHDR-EXTNUMBER
*"  TABLES
*"      ET_FILE_RETURN STRUCTURE  BAPIRET2
*"--------------------------------------------------------------------


DATA : E_S_MSG   TYPE  BAL_S_MSG,
    lv_lognumber type balognr,
    lv_loghandle type balloghndl,
    messages   type table of  balm,
    wa_messages type balm,
    header_data type table of balhdr,
    wa_header type balhdr,
    dateto type baldate,
    timeto type baltime.

SELECT SINGLE lognumber FROM BALHDR INTO
lv_lognumber WHERE OBJECT = IV_APPOBJ_NAME
AND SUBOBJECT = IV_SUBOBJ_NAME
AND EXTNUMBER = IV_EXT_ID.

SELECT SINGLE LOG_HANDLE FROM BALHDR INTO
lv_loghandle WHERE OBJECT = IV_APPOBJ_NAME
AND SUBOBJECT = IV_SUBOBJ_NAME
AND EXTNUMBER = IV_EXT_ID.

IF IV_ACTION = 'LOG_DISP'.

wa_header-lognumber = lv_lognumber.
append wa_header to header_data.

CALL FUNCTION 'APPL_LOG_READ_DB'
 EXPORTING
  OBJECT                   = IV_APPOBJ_NAME
  SUBOBJECT                = IV_SUBOBJ_NAME
  EXTERNAL_NUMBER          = IV_EXT_ID
 TABLES
   HEADER_DATA              = header_data
  MESSAGES                 =  messages.

  if sy-subrc is initial.
    clear et_file_return.
    loop at messages into wa_messages.
      et_file_return-type =  wa_messages-msgty.
      et_file_return-id =   wa_messages-msgid.
      et_file_return-number = wa_messages-msgnumber.
      et_file_return-message_v1 = wa_messages-msgv1.
      et_file_return-message_v2 = wa_messages-msgv2.
      et_file_return-message_v3 = wa_messages-msgv3.
      et_file_return-message_v4 = wa_messages-msgv4.
      append et_file_return .
    endloop.
  endif.

ELSEIF IV_ACTION = 'LOG_DEL'.

CALL FUNCTION 'APPL_LOG_DELETE'
  EXPORTING
    OBJECT                          = IV_APPOBJ_NAME
    SUBOBJECT                        =  IV_SUBOBJ_NAME
    EXTERNAL_NUMBER                  =  IV_EXT_ID
    DATE_TO                         =  dateto
   TIME_TO                          =  timeto
   LOG_CLASS                        = '1'
   I_WITH_COMMIT_WORK               = 'X'
   I_PACKAGE_SIZE                   = 100
 EXCEPTIONS
   NO_AUTHORITY                     = 1
   OTHERS                           = 2.

 IF SY-SUBRC <> 0.
CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'E'.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
 INTO ET_FILE_RETURN-MESSAGE
 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 APPEND et_file_return.
 EXIT.
ELSE.
 CLEAR ET_FILE_RETURN.
 ET_FILE_RETURN-type = 'S'.
 ET_FILE_RETURN-MESSAGE = 'Application Log Deleted'.
 APPEND et_file_return.
 ENDIF.
ENDIF.




ENDFUNCTION.
