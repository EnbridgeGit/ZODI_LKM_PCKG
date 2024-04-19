*&---------------------------------------------------------------------*
*& Report  Z0DI_SAPEAST_EXPORT
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* Program Name       :  Z0DI_SAPEAST_EXPORT                            *
* Author             :  Manvitha Dadi                                  *
* Date               :  29-03-2022                                     *
* Change Request     :  CHG0245367                                     *
* Purpose            :  SAP EAST data export                           *
*----------------------------------------------------------------------*
*                      Modification Log                                *
*                                                                      *
* Changed On   Changed By  CTS         Description                     *
* ---------------------------------------------------------------------*
* 29-Mar-2022  DADIM      CHG0245367 - SAP EAST data export automation *
*&---------------------------------------------------------------------*

REPORT  z0di_sapeast_export.

INCLUDE z0di_sapeast_export_top.
INCLUDE z0di_sapeast_export_sel.
INCLUDE z0di_sapeast_export_evt.
INCLUDE z0di_sapeast_export_f01.
