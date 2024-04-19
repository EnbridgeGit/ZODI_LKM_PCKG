************************************************************************
* Report         : ZFFII017B
* Author         : Joanne Harwood
* Create Date    : 2007/11/26
* Description    : FI/GL: Hyperion Interface - Trial Balance Extract
* Category       : Extract & Report
* Modification#  : Issue TR495
* Supporting Doc : ZFFII017 Development Specification Document.doc
* Spec. Author   : Andy Tattersall
*----------------------------------------------------------------------*
* Change History
*----------------------------------------------------------------------*
* Chng.Req#  |Date       |Developer       |Description
*----------------------------------------------------------------------*
* D30K913809 |2007/11/23 |Joanne Harwood  |Issue TR495
*
*----------------------------------------------------------------------*

REPORT zodi_15101_119101 NO STANDARD PAGE HEADING LINE-COUNT 65
                                          LINE-SIZE 120 MESSAGE-ID zs.

INCLUDE zodi_15101_119101_top.
INCLUDE zodi_15101_119101_sel.
INCLUDE zodi_15101_119101_f01.

*----------------------------------------------------------------------*
*   A T    S E L E C T I O N - S C R E E N
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  PERFORM valid_period_check.
*  PERFORM set_report_header.              "TR564

*----------------------------------------------------------------------*
*   S T A R T - O F - S E L E C T I O N
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM setup_dates.
  PERFORM get_gl_data.
*  PERFORM build_extract.

*----------------------------------------------------------------------*
*   E N D - O F - S E L E C T I O N
*----------------------------------------------------------------------*
END-OF-SELECTION.
*  PERFORM print_report.
  PERFORM create_output_file.

*----------------------------------------------------------------------*
*   T O P - O F - P A G E
*----------------------------------------------------------------------*
*TOP-OF-PAGE.
*  PERFORM write_top_of_page.
