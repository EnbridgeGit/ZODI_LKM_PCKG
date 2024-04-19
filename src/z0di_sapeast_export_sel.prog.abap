*&---------------------------------------------------------------------*
*&  Include           Z0DI_SAPEAST_EXPORT_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_ledger LIKE faglflext-rldnr DEFAULT '0L' OBLIGATORY,
            p_year LIKE faglflext-ryear DEFAULT sy-datum+0(4) OBLIGATORY,
            p_record TYPE rrcty DEFAULT '0' OBLIGATORY,
            p_spras  TYPE spras DEFAULT 'E' OBLIGATORY.
SELECT-OPTIONS: s_bukrs  FOR faglflext-rbukrs NO INTERVALS.
PARAMETERS: p_file        LIKE rfpdo-rfbifile.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN END OF BLOCK a1.
