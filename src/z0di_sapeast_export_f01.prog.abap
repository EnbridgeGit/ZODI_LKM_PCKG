*&---------------------------------------------------------------------*
*&  Include           Z0DI_SAPEAST_EXPORT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  OPEN DATASET p_file FOR INPUT
     IN TEXT MODE
     ENCODING DEFAULT.
  IF sy-subrc EQ 0.
    DELETE DATASET p_file.
  ENDIF.
*Open/CREATE output file
  OPEN DATASET p_file FOR APPENDING
       IN TEXT MODE
       ENCODING DEFAULT.
  IF sy-subrc NE 0.
    DATA: lv_mesg TYPE string.
    CLEAR et_file_return.
    et_file_return-type = 'E'.
    CONCATENATE
    'Error occurred when creating dataset' p_file
    INTO lv_mesg.
    et_file_return-message = lv_mesg.
    APPEND et_file_return.
  ENDIF.
*****************
*Batch Processing
*****************
  OPEN CURSOR WITH HOLD lv_t001_dbcur FOR
  SELECT land1
  waers
  bukrs
  butxt
  fikrs
  ktopl
  FROM  t001
  WHERE bukrs IN s_bukrs.
  DO.
*CHECK for the counter, only for first batch
*process new line is required...
    lv_cnt  = lv_cnt  + 1.
    REFRESH tt_t001.
    FETCH NEXT CURSOR lv_t001_dbcur
    APPENDING TABLE tt_t001.
*    PACKAGE SIZE iv_fetch_batch_size.
    IF NOT tt_t001 IS INITIAL.
************************************
*Read data FROM child TABLE TCURT
************************************
      REFRESH tt_tcurt.
      SELECT waers
      ltext
      FROM   tcurt
      INTO TABLE tt_tcurt
      FOR ALL ENTRIES IN tt_t001
      WHERE waers =
      tt_t001-d3_waers
      AND   spras = p_spras.
      .
      IF NOT tt_tcurt IS INITIAL.
************************************
*Read data FROM child TABLE FAGLFLEXT
************************************
        REFRESH tt_faglflext.
        SELECT rbukrs
        rclnt
        rbusa
        rfarea
        segment
        prctr
        rassc
        ryear
        sbusa
        sfarea
        pprctr
        rpmax
        racct
        rvers
        rldnr
        logsys
        cost_elem
        rcntr
        kokrs
        hsl01
        hsl02
        hsl03
        hsl04
        hsl05
        hsl06
        hsl07
        hsl08
        hsl09
        hsl10
        hsl11
        hsl12
        hsl13
        hsl14
        hsl15
        hsl16
        drcrk
        hslvt
        tslvt
        kslvt
        rtcur
        tsl05
        tsl01
        tsl06
        tsl02
        tsl04
        tsl03
        tsl07
        tsl12
        tsl08
        tsl11
        tsl09
        tsl10
        tsl13
        tsl16
        tsl14
        tsl15
        rrcty
        ksl11
        ksl02
        ksl10
        ksl15
        ksl07
        ksl09
        ksl03
        ksl08
        ksl14
        ksl04
        ksl05
        ksl01
        ksl12
        ksl13
        ksl06
        ksl16
        objnr00
        objnr01
        objnr02
        objnr03
        objnr04
        objnr05
        objnr06
        objnr07
        objnr08
        activ
        rmvct
        runit
        awtyp
        scntr
        psegment
        oslvt
        osl01
        osl02
        osl03
        osl04
        osl05
        osl06
        osl07
        osl08
        osl09
        osl10
        osl11
        osl12
        osl13
        osl14
        osl15
        osl16
        mslvt
        msl01
        msl02
        msl03
        msl04
        msl05
        msl06
        msl07
        msl08
        msl09
        msl10
        msl11
        msl12
        msl13
        msl14
        msl15
        msl16
        timestamp
        FROM   faglflext
        INTO TABLE tt_faglflext
        FOR ALL ENTRIES IN tt_t001
        WHERE rbukrs =
        tt_t001-d5_bukrs
        AND   rldnr = p_ledger
         AND ryear = p_year
         AND rrcty = p_record.
        .
        IF NOT tt_faglflext IS INITIAL.
************************************
*Read data FROM child TABLE T000
************************************
          REFRESH tt_t000.
          SELECT mandt
          mwaer
          FROM   t000
          INTO TABLE tt_t000
          FOR ALL ENTRIES IN tt_faglflext
          WHERE mandt =
          tt_faglflext-d7_rclnt
          .
          IF NOT tt_t000 IS INITIAL.
************************************
*Read data FROM child TABLE T005
************************************
            REFRESH tt_t005.
            SELECT land1
            curin
            curha
            waers
            FROM   t005
            INTO TABLE tt_t005
            FOR ALL ENTRIES IN tt_t001
            WHERE land1 =
            tt_t001-d1_land1
            .
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      EXIT.
    ENDIF.
****First Order: INNER JOIN
****First & 2nd TABLE
    SORT tt_t001 BY d3_waers.
    SORT tt_tcurt BY d4_waers.
    CLEAR wa_t001.
    LOOP AT tt_t001
    INTO wa_t001.
      CLEAR : wa_tcurt.
      READ TABLE tt_tcurt
      WITH KEY d4_waers =
       wa_t001-d3_waers
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
      IF sy-subrc = 0.
        lv_tabix_frm = sy-tabix.
        LOOP AT tt_tcurt
        INTO wa_tcurt
        FROM lv_tabix_frm.
          IF wa_tcurt-d4_waers =
           wa_t001-d3_waers.
            MOVE wa_tcurt-d4_waers
             TO wa_final-d4_waers.
            MOVE wa_tcurt-c5_ltext
             TO wa_final-c5_ltext.
            MOVE wa_t001-d1_land1
             TO wa_final-d1_land1.
            MOVE wa_t001-d3_waers
             TO wa_final-d3_waers.
            MOVE wa_t001-d5_bukrs
             TO wa_final-d5_bukrs.
            MOVE wa_t001-c1_butxt
             TO wa_final-c1_butxt.
            MOVE wa_t001-c2_fikrs
             TO wa_final-c2_fikrs.
            MOVE wa_t001-c4_ktopl
             TO wa_final-c4_ktopl.
            APPEND wa_final
            TO tt_final1.
            CLEAR : wa_tcurt.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
*CLEAR wa_T001.
    ENDLOOP.
    FREE : tt_t001, tt_tcurt.
****Join Order 2 : INNER JOIN
    SORT tt_final1 BY d5_bukrs.
    SORT tt_faglflext BY d6_rbukrs.
    CLEAR wa_final.
    LOOP AT tt_final1
    INTO wa_final.
      CLEAR : wa_faglflext.
      READ TABLE tt_faglflext
      WITH KEY d6_rbukrs =
       wa_final-d5_bukrs
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
      IF sy-subrc = 0.
        lv_tabix_frm = sy-tabix.
        LOOP AT tt_faglflext
        INTO wa_faglflext
        FROM lv_tabix_frm.
          IF wa_faglflext-d6_rbukrs
           = wa_final-d5_bukrs.
            MOVE wa_faglflext-d6_rbukrs
             TO wa_final-d6_rbukrs.
            MOVE wa_faglflext-d7_rclnt
             TO wa_final-d7_rclnt.
            MOVE wa_faglflext-c7_rbusa
             TO wa_final-c7_rbusa.
            MOVE wa_faglflext-c8_rfarea
             TO wa_final-c8_rfarea.
            MOVE wa_faglflext-c9_segment
             TO wa_final-c9_segment.
            MOVE wa_faglflext-c10_prctr
             TO wa_final-c10_prctr.
            MOVE wa_faglflext-c11_rassc
             TO wa_final-c11_rassc.
            MOVE wa_faglflext-c12_ryear
             TO wa_final-c12_ryear.
            MOVE wa_faglflext-c13_sbusa
             TO wa_final-c13_sbusa.
            MOVE wa_faglflext-c14_sfarea
             TO wa_final-c14_sfarea.
            MOVE wa_faglflext-c15_pprctr
             TO wa_final-c15_pprctr.
            MOVE wa_faglflext-c16_rpmax
             TO wa_final-c16_rpmax.
            MOVE wa_faglflext-c17_racct
             TO wa_final-c17_racct.
            MOVE wa_faglflext-c18_rvers
             TO wa_final-c18_rvers.
            MOVE wa_faglflext-c19_rldnr
             TO wa_final-c19_rldnr.
            MOVE wa_faglflext-c20_logsys
             TO wa_final-c20_logsys.
            MOVE wa_faglflext-c21_cost_elem
             TO wa_final-c21_cost_elem.
            MOVE wa_faglflext-c22_rcntr
             TO wa_final-c22_rcntr.
            MOVE wa_faglflext-c23_kokrs
             TO wa_final-c23_kokrs.
            MOVE wa_faglflext-c24_hsl01
             TO wa_final-c24_hsl01.
            MOVE wa_faglflext-c25_hsl02
             TO wa_final-c25_hsl02.
            MOVE wa_faglflext-c26_hsl03
             TO wa_final-c26_hsl03.
            MOVE wa_faglflext-c27_hsl04
             TO wa_final-c27_hsl04.
            MOVE wa_faglflext-c28_hsl05
             TO wa_final-c28_hsl05.
            MOVE wa_faglflext-c29_hsl06
             TO wa_final-c29_hsl06.
            MOVE wa_faglflext-c30_hsl07
             TO wa_final-c30_hsl07.
            MOVE wa_faglflext-c31_hsl08
             TO wa_final-c31_hsl08.
            MOVE wa_faglflext-c32_hsl09
             TO wa_final-c32_hsl09.
            MOVE wa_faglflext-c33_hsl10
             TO wa_final-c33_hsl10.
            MOVE wa_faglflext-c34_hsl11
             TO wa_final-c34_hsl11.
            MOVE wa_faglflext-c35_hsl12
             TO wa_final-c35_hsl12.
            MOVE wa_faglflext-c36_hsl13
             TO wa_final-c36_hsl13.
            MOVE wa_faglflext-c37_hsl14
             TO wa_final-c37_hsl14.
            MOVE wa_faglflext-c38_hsl15
             TO wa_final-c38_hsl15.
            MOVE wa_faglflext-c39_hsl16
             TO wa_final-c39_hsl16.
            MOVE wa_faglflext-c40_drcrk
             TO wa_final-c40_drcrk.
            MOVE wa_faglflext-c41_hslvt
             TO wa_final-c41_hslvt.
            MOVE wa_faglflext-c42_tslvt
             TO wa_final-c42_tslvt.
            MOVE wa_faglflext-c43_kslvt
             TO wa_final-c43_kslvt.
            MOVE wa_faglflext-c44_rtcur
             TO wa_final-c44_rtcur.
            MOVE wa_faglflext-c45_tsl05
             TO wa_final-c45_tsl05.
            MOVE wa_faglflext-c46_tsl01
             TO wa_final-c46_tsl01.
            MOVE wa_faglflext-c47_tsl06
             TO wa_final-c47_tsl06.
            MOVE wa_faglflext-c48_tsl02
             TO wa_final-c48_tsl02.
            MOVE wa_faglflext-c49_tsl04
             TO wa_final-c49_tsl04.
            MOVE wa_faglflext-c50_tsl03
             TO wa_final-c50_tsl03.
            MOVE wa_faglflext-c51_tsl07
             TO wa_final-c51_tsl07.
            MOVE wa_faglflext-c52_tsl12
             TO wa_final-c52_tsl12.
            MOVE wa_faglflext-c53_tsl08
             TO wa_final-c53_tsl08.
            MOVE wa_faglflext-c54_tsl11
             TO wa_final-c54_tsl11.
            MOVE wa_faglflext-c55_tsl09
             TO wa_final-c55_tsl09.
            MOVE wa_faglflext-c56_tsl10
             TO wa_final-c56_tsl10.
            MOVE wa_faglflext-c57_tsl13
             TO wa_final-c57_tsl13.
            MOVE wa_faglflext-c58_tsl16
             TO wa_final-c58_tsl16.
            MOVE wa_faglflext-c59_tsl14
             TO wa_final-c59_tsl14.
            MOVE wa_faglflext-c60_tsl15
             TO wa_final-c60_tsl15.
            MOVE wa_faglflext-c61_rrcty
             TO wa_final-c61_rrcty.
            MOVE wa_faglflext-c62_ksl11
             TO wa_final-c62_ksl11.
            MOVE wa_faglflext-c63_ksl02
             TO wa_final-c63_ksl02.
            MOVE wa_faglflext-c64_ksl10
             TO wa_final-c64_ksl10.
            MOVE wa_faglflext-c65_ksl15
             TO wa_final-c65_ksl15.
            MOVE wa_faglflext-c66_ksl07
             TO wa_final-c66_ksl07.
            MOVE wa_faglflext-c67_ksl09
             TO wa_final-c67_ksl09.
            MOVE wa_faglflext-c68_ksl03
             TO wa_final-c68_ksl03.
            MOVE wa_faglflext-c69_ksl08
             TO wa_final-c69_ksl08.
            MOVE wa_faglflext-c70_ksl14
             TO wa_final-c70_ksl14.
            MOVE wa_faglflext-c71_ksl04
             TO wa_final-c71_ksl04.
            MOVE wa_faglflext-c72_ksl05
             TO wa_final-c72_ksl05.
            MOVE wa_faglflext-c73_ksl01
             TO wa_final-c73_ksl01.
            MOVE wa_faglflext-c74_ksl12
             TO wa_final-c74_ksl12.
            MOVE wa_faglflext-c75_ksl13
             TO wa_final-c75_ksl13.
            MOVE wa_faglflext-c76_ksl06
             TO wa_final-c76_ksl06.
            MOVE wa_faglflext-c77_ksl16
             TO wa_final-c77_ksl16.
            MOVE wa_faglflext-c80_objnr00
             TO wa_final-c80_objnr00.
            MOVE wa_faglflext-c81_objnr01
             TO wa_final-c81_objnr01.
            MOVE wa_faglflext-c82_objnr02
             TO wa_final-c82_objnr02.
            MOVE wa_faglflext-c83_objnr03
             TO wa_final-c83_objnr03.
            MOVE wa_faglflext-c84_objnr04
             TO wa_final-c84_objnr04.
            MOVE wa_faglflext-c85_objnr05
             TO wa_final-c85_objnr05.
            MOVE wa_faglflext-c86_objnr06
             TO wa_final-c86_objnr06.
            MOVE wa_faglflext-c87_objnr07
             TO wa_final-c87_objnr07.
            MOVE wa_faglflext-c88_objnr08
             TO wa_final-c88_objnr08.
            MOVE wa_faglflext-c89_activ
             TO wa_final-c89_activ.
            MOVE wa_faglflext-c90_rmvct
             TO wa_final-c90_rmvct.
            MOVE wa_faglflext-c91_runit
             TO wa_final-c91_runit.
            MOVE wa_faglflext-c92_awtyp
             TO wa_final-c92_awtyp.
            MOVE wa_faglflext-c93_scntr
             TO wa_final-c93_scntr.
            MOVE wa_faglflext-c94_psegment
             TO wa_final-c94_psegment.
            MOVE wa_faglflext-c95_oslvt
             TO wa_final-c95_oslvt.
            MOVE wa_faglflext-c96_osl01
             TO wa_final-c96_osl01.
            MOVE wa_faglflext-c97_osl02
             TO wa_final-c97_osl02.
            MOVE wa_faglflext-c98_osl03
             TO wa_final-c98_osl03.
            MOVE wa_faglflext-c99_osl04
             TO wa_final-c99_osl04.
            MOVE wa_faglflext-c100_osl05
             TO wa_final-c100_osl05.
            MOVE wa_faglflext-c101_osl06
             TO wa_final-c101_osl06.
            MOVE wa_faglflext-c102_osl07
             TO wa_final-c102_osl07.
            MOVE wa_faglflext-c103_osl08
             TO wa_final-c103_osl08.
            MOVE wa_faglflext-c104_osl09
             TO wa_final-c104_osl09.
            MOVE wa_faglflext-c105_osl10
             TO wa_final-c105_osl10.
            MOVE wa_faglflext-c106_osl11
             TO wa_final-c106_osl11.
            MOVE wa_faglflext-c107_osl12
             TO wa_final-c107_osl12.
            MOVE wa_faglflext-c108_osl13
             TO wa_final-c108_osl13.
            MOVE wa_faglflext-c109_osl14
             TO wa_final-c109_osl14.
            MOVE wa_faglflext-c110_osl15
             TO wa_final-c110_osl15.
            MOVE wa_faglflext-c111_osl16
             TO wa_final-c111_osl16.
            MOVE wa_faglflext-c112_mslvt
             TO wa_final-c112_mslvt.
            MOVE wa_faglflext-c113_msl01
             TO wa_final-c113_msl01.
            MOVE wa_faglflext-c114_msl02
             TO wa_final-c114_msl02.
            MOVE wa_faglflext-c115_msl03
             TO wa_final-c115_msl03.
            MOVE wa_faglflext-c116_msl04
             TO wa_final-c116_msl04.
            MOVE wa_faglflext-c117_msl05
             TO wa_final-c117_msl05.
            MOVE wa_faglflext-c118_msl06
             TO wa_final-c118_msl06.
            MOVE wa_faglflext-c119_msl07
             TO wa_final-c119_msl07.
            MOVE wa_faglflext-c120_msl08
             TO wa_final-c120_msl08.
            MOVE wa_faglflext-c121_msl09
             TO wa_final-c121_msl09.
            MOVE wa_faglflext-c122_msl10
             TO wa_final-c122_msl10.
            MOVE wa_faglflext-c123_msl11
             TO wa_final-c123_msl11.
            MOVE wa_faglflext-c124_msl12
             TO wa_final-c124_msl12.
            MOVE wa_faglflext-c125_msl13
             TO wa_final-c125_msl13.
            MOVE wa_faglflext-c126_msl14
             TO wa_final-c126_msl14.
            MOVE wa_faglflext-c127_msl15
             TO wa_final-c127_msl15.
            MOVE wa_faglflext-c128_msl16
             TO wa_final-c128_msl16.
            MOVE wa_faglflext-c129_timestamp
             TO wa_final-c129_timestamp.
            APPEND wa_final
            TO tt_final2.
            CLEAR : wa_faglflext.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    FREE : tt_final1, tt_faglflext.
****Join Order 3 : INNER JOIN
    SORT tt_final2 BY d7_rclnt.
    SORT tt_t000 BY d8_mandt.
    CLEAR wa_final.
    LOOP AT tt_final2
    INTO wa_final.
      CLEAR : wa_t000.
      READ TABLE tt_t000
      WITH KEY d8_mandt =
       wa_final-d7_rclnt
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
      IF sy-subrc = 0.
        lv_tabix_frm = sy-tabix.
        LOOP AT tt_t000
        INTO wa_t000
        FROM lv_tabix_frm.
          IF wa_t000-d8_mandt
           = wa_final-d7_rclnt.
            MOVE wa_t000-d8_mandt
             TO wa_final-d8_mandt.
            MOVE wa_t000-c79_mwaer
             TO wa_final-c79_mwaer.
            APPEND wa_final
            TO tt_final3.
            CLEAR : wa_t000.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    FREE : tt_final2, tt_t000.
****Join Order 4 : INNER JOIN
    SORT tt_final3 BY d1_land1.
    SORT tt_t005 BY d2_land1.
    CLEAR wa_final.
    LOOP AT tt_final3
    INTO wa_final.
      CLEAR : wa_t005.
      READ TABLE tt_t005
      WITH KEY d2_land1 =
       wa_final-d1_land1
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
      IF sy-subrc = 0.
        lv_tabix_frm = sy-tabix.
        LOOP AT tt_t005
        INTO wa_t005
        FROM lv_tabix_frm.
          IF wa_t005-d2_land1
           = wa_final-d1_land1.
            MOVE wa_t005-d2_land1
             TO wa_final-d2_land1.
            MOVE wa_t005-c130_curin
             TO wa_final-c130_curin.
            MOVE wa_t005-c131_curha
             TO wa_final-c131_curha.
            MOVE wa_t005-c132_waers
             TO wa_final-c132_waers.
            APPEND wa_final
            TO tt_final4.
            CLEAR : wa_t005.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    FREE : tt_final3, tt_t005.
***** END OF INNER/LEFT OUTER JOIN *****
    LOOP AT tt_final4 INTO wa_final.
      MOVE-CORRESPONDING wa_final TO wa_final_tmp.
      APPEND wa_final_tmp TO tt_final_tmp.
*CLEAR wa_final.
    ENDLOOP.
    FREE : tt_final4.
    LOOP AT tt_final_tmp INTO wa_final_tmp.
      MOVE wa_final_tmp-c1_butxt
       TO wa_final_target-c1_butxt.
      MOVE wa_final_tmp-c2_fikrs
       TO wa_final_target-c2_fikrs.
      MOVE wa_final_tmp-d3_waers
       TO wa_final_target-c3_waers.
      MOVE wa_final_tmp-c4_ktopl
       TO wa_final_target-c4_ktopl.
      MOVE wa_final_tmp-c5_ltext
       TO wa_final_target-c5_ltext.
      MOVE wa_final_tmp-d6_rbukrs
       TO wa_final_target-c6_rbukrs.
      MOVE wa_final_tmp-c7_rbusa
       TO wa_final_target-c7_rbusa.
      MOVE wa_final_tmp-c8_rfarea
       TO wa_final_target-c8_rfarea.
      MOVE wa_final_tmp-c9_segment
       TO wa_final_target-c9_segment.
      MOVE wa_final_tmp-c10_prctr
       TO wa_final_target-c10_prctr.
      MOVE wa_final_tmp-c11_rassc
       TO wa_final_target-c11_rassc.
      MOVE wa_final_tmp-c12_ryear
       TO wa_final_target-c12_ryear.
      MOVE wa_final_tmp-c13_sbusa
       TO wa_final_target-c13_sbusa.
      MOVE wa_final_tmp-c14_sfarea
       TO wa_final_target-c14_sfarea.
      MOVE wa_final_tmp-c15_pprctr
       TO wa_final_target-c15_pprctr.
      MOVE wa_final_tmp-c16_rpmax
       TO wa_final_target-c16_rpmax.
      MOVE wa_final_tmp-c17_racct
       TO wa_final_target-c17_racct.
      MOVE wa_final_tmp-c18_rvers
       TO wa_final_target-c18_rvers.
      MOVE wa_final_tmp-c19_rldnr
       TO wa_final_target-c19_rldnr.
      MOVE wa_final_tmp-c20_logsys
       TO wa_final_target-c20_logsys.
      MOVE wa_final_tmp-c21_cost_elem
       TO wa_final_target-c21_cost_elem.
      MOVE wa_final_tmp-c22_rcntr
       TO wa_final_target-c22_rcntr.
      MOVE wa_final_tmp-c23_kokrs
       TO wa_final_target-c23_kokrs.
      MOVE wa_final_tmp-c24_hsl01
       TO wa_final_target-c24_hsl01.
      MOVE wa_final_tmp-c25_hsl02
       TO wa_final_target-c25_hsl02.
      MOVE wa_final_tmp-c26_hsl03
       TO wa_final_target-c26_hsl03.
      MOVE wa_final_tmp-c27_hsl04
       TO wa_final_target-c27_hsl04.
      MOVE wa_final_tmp-c28_hsl05
       TO wa_final_target-c28_hsl05.
      MOVE wa_final_tmp-c29_hsl06
       TO wa_final_target-c29_hsl06.
      MOVE wa_final_tmp-c30_hsl07
       TO wa_final_target-c30_hsl07.
      MOVE wa_final_tmp-c31_hsl08
       TO wa_final_target-c31_hsl08.
      MOVE wa_final_tmp-c32_hsl09
       TO wa_final_target-c32_hsl09.
      MOVE wa_final_tmp-c33_hsl10
       TO wa_final_target-c33_hsl10.
      MOVE wa_final_tmp-c34_hsl11
       TO wa_final_target-c34_hsl11.
      MOVE wa_final_tmp-c35_hsl12
       TO wa_final_target-c35_hsl12.
      MOVE wa_final_tmp-c36_hsl13
       TO wa_final_target-c36_hsl13.
      MOVE wa_final_tmp-c37_hsl14
       TO wa_final_target-c37_hsl14.
      MOVE wa_final_tmp-c38_hsl15
       TO wa_final_target-c38_hsl15.
      MOVE wa_final_tmp-c39_hsl16
       TO wa_final_target-c39_hsl16.
      MOVE wa_final_tmp-c40_drcrk
       TO wa_final_target-c40_drcrk.
      MOVE wa_final_tmp-c41_hslvt
       TO wa_final_target-c41_hslvt.
      MOVE wa_final_tmp-c42_tslvt
       TO wa_final_target-c42_tslvt.
      MOVE wa_final_tmp-c43_kslvt
       TO wa_final_target-c43_kslvt.
      MOVE wa_final_tmp-c44_rtcur
       TO wa_final_target-c44_rtcur.
      MOVE wa_final_tmp-c45_tsl05
       TO wa_final_target-c45_tsl05.
      MOVE wa_final_tmp-c46_tsl01
       TO wa_final_target-c46_tsl01.
      MOVE wa_final_tmp-c47_tsl06
       TO wa_final_target-c47_tsl06.
      MOVE wa_final_tmp-c48_tsl02
       TO wa_final_target-c48_tsl02.
      MOVE wa_final_tmp-c49_tsl04
       TO wa_final_target-c49_tsl04.
      MOVE wa_final_tmp-c50_tsl03
       TO wa_final_target-c50_tsl03.
      MOVE wa_final_tmp-c51_tsl07
       TO wa_final_target-c51_tsl07.
      MOVE wa_final_tmp-c52_tsl12
       TO wa_final_target-c52_tsl12.
      MOVE wa_final_tmp-c53_tsl08
       TO wa_final_target-c53_tsl08.
      MOVE wa_final_tmp-c54_tsl11
       TO wa_final_target-c54_tsl11.
      MOVE wa_final_tmp-c55_tsl09
       TO wa_final_target-c55_tsl09.
      MOVE wa_final_tmp-c56_tsl10
       TO wa_final_target-c56_tsl10.
      MOVE wa_final_tmp-c57_tsl13
       TO wa_final_target-c57_tsl13.
      MOVE wa_final_tmp-c58_tsl16
       TO wa_final_target-c58_tsl16.
      MOVE wa_final_tmp-c59_tsl14
       TO wa_final_target-c59_tsl14.
      MOVE wa_final_tmp-c60_tsl15
       TO wa_final_target-c60_tsl15.
      MOVE wa_final_tmp-c61_rrcty
       TO wa_final_target-c61_rrcty.
      MOVE wa_final_tmp-c62_ksl11
       TO wa_final_target-c62_ksl11.
      MOVE wa_final_tmp-c63_ksl02
       TO wa_final_target-c63_ksl02.
      MOVE wa_final_tmp-c64_ksl10
       TO wa_final_target-c64_ksl10.
      MOVE wa_final_tmp-c65_ksl15
       TO wa_final_target-c65_ksl15.
      MOVE wa_final_tmp-c66_ksl07
       TO wa_final_target-c66_ksl07.
      MOVE wa_final_tmp-c67_ksl09
       TO wa_final_target-c67_ksl09.
      MOVE wa_final_tmp-c68_ksl03
       TO wa_final_target-c68_ksl03.
      MOVE wa_final_tmp-c69_ksl08
       TO wa_final_target-c69_ksl08.
      MOVE wa_final_tmp-c70_ksl14
       TO wa_final_target-c70_ksl14.
      MOVE wa_final_tmp-c71_ksl04
       TO wa_final_target-c71_ksl04.
      MOVE wa_final_tmp-c72_ksl05
       TO wa_final_target-c72_ksl05.
      MOVE wa_final_tmp-c73_ksl01
       TO wa_final_target-c73_ksl01.
      MOVE wa_final_tmp-c74_ksl12
       TO wa_final_target-c74_ksl12.
      MOVE wa_final_tmp-c75_ksl13
       TO wa_final_target-c75_ksl13.
      MOVE wa_final_tmp-c76_ksl06
       TO wa_final_target-c76_ksl06.
      MOVE wa_final_tmp-c77_ksl16
       TO wa_final_target-c77_ksl16.
      MOVE wa_final_tmp-d7_rclnt
       TO wa_final_target-c78_rclnt.
      MOVE wa_final_tmp-c79_mwaer
       TO wa_final_target-c79_mwaer.
      MOVE wa_final_tmp-c80_objnr00
       TO wa_final_target-c80_objnr00.
      MOVE wa_final_tmp-c81_objnr01
       TO wa_final_target-c81_objnr01.
      MOVE wa_final_tmp-c82_objnr02
       TO wa_final_target-c82_objnr02.
      MOVE wa_final_tmp-c83_objnr03
       TO wa_final_target-c83_objnr03.
      MOVE wa_final_tmp-c84_objnr04
       TO wa_final_target-c84_objnr04.
      MOVE wa_final_tmp-c85_objnr05
       TO wa_final_target-c85_objnr05.
      MOVE wa_final_tmp-c86_objnr06
       TO wa_final_target-c86_objnr06.
      MOVE wa_final_tmp-c87_objnr07
       TO wa_final_target-c87_objnr07.
      MOVE wa_final_tmp-c88_objnr08
       TO wa_final_target-c88_objnr08.
      MOVE wa_final_tmp-c89_activ
       TO wa_final_target-c89_activ.
      MOVE wa_final_tmp-c90_rmvct
       TO wa_final_target-c90_rmvct.
      MOVE wa_final_tmp-c91_runit
       TO wa_final_target-c91_runit.
      MOVE wa_final_tmp-c92_awtyp
       TO wa_final_target-c92_awtyp.
      MOVE wa_final_tmp-c93_scntr
       TO wa_final_target-c93_scntr.
      MOVE wa_final_tmp-c94_psegment
       TO wa_final_target-c94_psegment.
      MOVE wa_final_tmp-c95_oslvt
       TO wa_final_target-c95_oslvt.
      MOVE wa_final_tmp-c96_osl01
       TO wa_final_target-c96_osl01.
      MOVE wa_final_tmp-c97_osl02
       TO wa_final_target-c97_osl02.
      MOVE wa_final_tmp-c98_osl03
       TO wa_final_target-c98_osl03.
      MOVE wa_final_tmp-c99_osl04
       TO wa_final_target-c99_osl04.
      MOVE wa_final_tmp-c100_osl05
       TO wa_final_target-c100_osl05.
      MOVE wa_final_tmp-c101_osl06
       TO wa_final_target-c101_osl06.
      MOVE wa_final_tmp-c102_osl07
       TO wa_final_target-c102_osl07.
      MOVE wa_final_tmp-c103_osl08
       TO wa_final_target-c103_osl08.
      MOVE wa_final_tmp-c104_osl09
       TO wa_final_target-c104_osl09.
      MOVE wa_final_tmp-c105_osl10
       TO wa_final_target-c105_osl10.
      MOVE wa_final_tmp-c106_osl11
       TO wa_final_target-c106_osl11.
      MOVE wa_final_tmp-c107_osl12
       TO wa_final_target-c107_osl12.
      MOVE wa_final_tmp-c108_osl13
       TO wa_final_target-c108_osl13.
      MOVE wa_final_tmp-c109_osl14
       TO wa_final_target-c109_osl14.
      MOVE wa_final_tmp-c110_osl15
       TO wa_final_target-c110_osl15.
      MOVE wa_final_tmp-c111_osl16
       TO wa_final_target-c111_osl16.
      MOVE wa_final_tmp-c112_mslvt
       TO wa_final_target-c112_mslvt.
      MOVE wa_final_tmp-c113_msl01
       TO wa_final_target-c113_msl01.
      MOVE wa_final_tmp-c114_msl02
       TO wa_final_target-c114_msl02.
      MOVE wa_final_tmp-c115_msl03
       TO wa_final_target-c115_msl03.
      MOVE wa_final_tmp-c116_msl04
       TO wa_final_target-c116_msl04.
      MOVE wa_final_tmp-c117_msl05
       TO wa_final_target-c117_msl05.
      MOVE wa_final_tmp-c118_msl06
       TO wa_final_target-c118_msl06.
      MOVE wa_final_tmp-c119_msl07
       TO wa_final_target-c119_msl07.
      MOVE wa_final_tmp-c120_msl08
       TO wa_final_target-c120_msl08.
      MOVE wa_final_tmp-c121_msl09
       TO wa_final_target-c121_msl09.
      MOVE wa_final_tmp-c122_msl10
       TO wa_final_target-c122_msl10.
      MOVE wa_final_tmp-c123_msl11
       TO wa_final_target-c123_msl11.
      MOVE wa_final_tmp-c124_msl12
       TO wa_final_target-c124_msl12.
      MOVE wa_final_tmp-c125_msl13
       TO wa_final_target-c125_msl13.
      MOVE wa_final_tmp-c126_msl14
       TO wa_final_target-c126_msl14.
      MOVE wa_final_tmp-c127_msl15
       TO wa_final_target-c127_msl15.
      MOVE wa_final_tmp-c128_msl16
       TO wa_final_target-c128_msl16.
      MOVE wa_final_tmp-c129_timestamp
       TO wa_final_target-c129_timestamp.
      MOVE wa_final_tmp-c130_curin
       TO wa_final_target-c130_curin.
      MOVE wa_final_tmp-c131_curha
       TO wa_final_target-c131_curha.
      MOVE wa_final_tmp-c132_waers
       TO wa_final_target-c132_waers.
      APPEND wa_final_target TO tt_final_target.
    ENDLOOP.
    FREE : tt_final_tmp.
    CLEAR wa_final_target.
*    IF iv_max_row_cnt IS INITIAL.
*      MOVE 2147483647 TO iv_max_row_cnt.
*    ENDIF.
    LOOP AT tt_final_target INTO
    wa_final_target.
      MOVE wa_final_target-c1_butxt
       TO c1_butxt.
      MOVE wa_final_target-c2_fikrs
       TO c2_fikrs.
      MOVE wa_final_target-c3_waers
       TO c3_waers.
      MOVE wa_final_target-c4_ktopl
       TO c4_ktopl.
      MOVE wa_final_target-c5_ltext
       TO c5_ltext.
      MOVE wa_final_target-c6_rbukrs
       TO c6_rbukrs.
      MOVE wa_final_target-c7_rbusa
       TO c7_rbusa.
      MOVE wa_final_target-c8_rfarea
       TO c8_rfarea.
      MOVE wa_final_target-c9_segment
       TO c9_segment.
      MOVE wa_final_target-c10_prctr
       TO c10_prctr.
      MOVE wa_final_target-c11_rassc
       TO c11_rassc.
      MOVE wa_final_target-c12_ryear
       TO c12_ryear.
      MOVE wa_final_target-c13_sbusa
       TO c13_sbusa.
      MOVE wa_final_target-c14_sfarea
       TO c14_sfarea.
      MOVE wa_final_target-c15_pprctr
       TO c15_pprctr.
      MOVE wa_final_target-c16_rpmax
       TO c16_rpmax.
      MOVE wa_final_target-c17_racct
       TO c17_racct.
      MOVE wa_final_target-c18_rvers
       TO c18_rvers.
      MOVE wa_final_target-c19_rldnr
       TO c19_rldnr.
      MOVE wa_final_target-c20_logsys
       TO c20_logsys.
      MOVE wa_final_target-c21_cost_elem
       TO c21_cost_elem.
      MOVE wa_final_target-c22_rcntr
       TO c22_rcntr.
      MOVE wa_final_target-c23_kokrs
       TO c23_kokrs.
      MOVE wa_final_target-c24_hsl01
       TO c24_hsl01.
      MOVE wa_final_target-c25_hsl02
       TO c25_hsl02.
      MOVE wa_final_target-c26_hsl03
       TO c26_hsl03.
      MOVE wa_final_target-c27_hsl04
       TO c27_hsl04.
      MOVE wa_final_target-c28_hsl05
       TO c28_hsl05.
      MOVE wa_final_target-c29_hsl06
       TO c29_hsl06.
      MOVE wa_final_target-c30_hsl07
       TO c30_hsl07.
      MOVE wa_final_target-c31_hsl08
       TO c31_hsl08.
      MOVE wa_final_target-c32_hsl09
       TO c32_hsl09.
      MOVE wa_final_target-c33_hsl10
       TO c33_hsl10.
      MOVE wa_final_target-c34_hsl11
       TO c34_hsl11.
      MOVE wa_final_target-c35_hsl12
       TO c35_hsl12.
      MOVE wa_final_target-c36_hsl13
       TO c36_hsl13.
      MOVE wa_final_target-c37_hsl14
       TO c37_hsl14.
      MOVE wa_final_target-c38_hsl15
       TO c38_hsl15.
      MOVE wa_final_target-c39_hsl16
       TO c39_hsl16.
      MOVE wa_final_target-c40_drcrk
       TO c40_drcrk.
      MOVE wa_final_target-c41_hslvt
       TO c41_hslvt.
      MOVE wa_final_target-c42_tslvt
       TO c42_tslvt.
      MOVE wa_final_target-c43_kslvt
       TO c43_kslvt.
      MOVE wa_final_target-c44_rtcur
       TO c44_rtcur.
      MOVE wa_final_target-c45_tsl05
       TO c45_tsl05.
      MOVE wa_final_target-c46_tsl01
       TO c46_tsl01.
      MOVE wa_final_target-c47_tsl06
       TO c47_tsl06.
      MOVE wa_final_target-c48_tsl02
       TO c48_tsl02.
      MOVE wa_final_target-c49_tsl04
       TO c49_tsl04.
      MOVE wa_final_target-c50_tsl03
       TO c50_tsl03.
      MOVE wa_final_target-c51_tsl07
       TO c51_tsl07.
      MOVE wa_final_target-c52_tsl12
       TO c52_tsl12.
      MOVE wa_final_target-c53_tsl08
       TO c53_tsl08.
      MOVE wa_final_target-c54_tsl11
       TO c54_tsl11.
      MOVE wa_final_target-c55_tsl09
       TO c55_tsl09.
      MOVE wa_final_target-c56_tsl10
       TO c56_tsl10.
      MOVE wa_final_target-c57_tsl13
       TO c57_tsl13.
      MOVE wa_final_target-c58_tsl16
       TO c58_tsl16.
      MOVE wa_final_target-c59_tsl14
       TO c59_tsl14.
      MOVE wa_final_target-c60_tsl15
       TO c60_tsl15.
      MOVE wa_final_target-c61_rrcty
       TO c61_rrcty.
      MOVE wa_final_target-c62_ksl11
       TO c62_ksl11.
      MOVE wa_final_target-c63_ksl02
       TO c63_ksl02.
      MOVE wa_final_target-c64_ksl10
       TO c64_ksl10.
      MOVE wa_final_target-c65_ksl15
       TO c65_ksl15.
      MOVE wa_final_target-c66_ksl07
       TO c66_ksl07.
      MOVE wa_final_target-c67_ksl09
       TO c67_ksl09.
      MOVE wa_final_target-c68_ksl03
       TO c68_ksl03.
      MOVE wa_final_target-c69_ksl08
       TO c69_ksl08.
      MOVE wa_final_target-c70_ksl14
       TO c70_ksl14.
      MOVE wa_final_target-c71_ksl04
       TO c71_ksl04.
      MOVE wa_final_target-c72_ksl05
       TO c72_ksl05.
      MOVE wa_final_target-c73_ksl01
       TO c73_ksl01.
      MOVE wa_final_target-c74_ksl12
       TO c74_ksl12.
      MOVE wa_final_target-c75_ksl13
       TO c75_ksl13.
      MOVE wa_final_target-c76_ksl06
       TO c76_ksl06.
      MOVE wa_final_target-c77_ksl16
       TO c77_ksl16.
      MOVE wa_final_target-c78_rclnt
       TO c78_rclnt.
      MOVE wa_final_target-c79_mwaer
       TO c79_mwaer.
      MOVE wa_final_target-c80_objnr00
       TO c80_objnr00.
      MOVE wa_final_target-c81_objnr01
       TO c81_objnr01.
      MOVE wa_final_target-c82_objnr02
       TO c82_objnr02.
      MOVE wa_final_target-c83_objnr03
       TO c83_objnr03.
      MOVE wa_final_target-c84_objnr04
       TO c84_objnr04.
      MOVE wa_final_target-c85_objnr05
       TO c85_objnr05.
      MOVE wa_final_target-c86_objnr06
       TO c86_objnr06.
      MOVE wa_final_target-c87_objnr07
       TO c87_objnr07.
      MOVE wa_final_target-c88_objnr08
       TO c88_objnr08.
      MOVE wa_final_target-c89_activ
       TO c89_activ.
      MOVE wa_final_target-c90_rmvct
       TO c90_rmvct.
      MOVE wa_final_target-c91_runit
       TO c91_runit.
      MOVE wa_final_target-c92_awtyp
       TO c92_awtyp.
      MOVE wa_final_target-c93_scntr
       TO c93_scntr.
      MOVE wa_final_target-c94_psegment
       TO c94_psegment.
      MOVE wa_final_target-c95_oslvt
       TO c95_oslvt.
      MOVE wa_final_target-c96_osl01
       TO c96_osl01.
      MOVE wa_final_target-c97_osl02
       TO c97_osl02.
      MOVE wa_final_target-c98_osl03
       TO c98_osl03.
      MOVE wa_final_target-c99_osl04
       TO c99_osl04.
      MOVE wa_final_target-c100_osl05
       TO c100_osl05.
      MOVE wa_final_target-c101_osl06
       TO c101_osl06.
      MOVE wa_final_target-c102_osl07
       TO c102_osl07.
      MOVE wa_final_target-c103_osl08
       TO c103_osl08.
      MOVE wa_final_target-c104_osl09
       TO c104_osl09.
      MOVE wa_final_target-c105_osl10
       TO c105_osl10.
      MOVE wa_final_target-c106_osl11
       TO c106_osl11.
      MOVE wa_final_target-c107_osl12
       TO c107_osl12.
      MOVE wa_final_target-c108_osl13
       TO c108_osl13.
      MOVE wa_final_target-c109_osl14
       TO c109_osl14.
      MOVE wa_final_target-c110_osl15
       TO c110_osl15.
      MOVE wa_final_target-c111_osl16
       TO c111_osl16.
      MOVE wa_final_target-c112_mslvt
       TO c112_mslvt.
      MOVE wa_final_target-c113_msl01
       TO c113_msl01.
      MOVE wa_final_target-c114_msl02
       TO c114_msl02.
      MOVE wa_final_target-c115_msl03
       TO c115_msl03.
      MOVE wa_final_target-c116_msl04
       TO c116_msl04.
      MOVE wa_final_target-c117_msl05
       TO c117_msl05.
      MOVE wa_final_target-c118_msl06
       TO c118_msl06.
      MOVE wa_final_target-c119_msl07
       TO c119_msl07.
      MOVE wa_final_target-c120_msl08
       TO c120_msl08.
      MOVE wa_final_target-c121_msl09
       TO c121_msl09.
      MOVE wa_final_target-c122_msl10
       TO c122_msl10.
      MOVE wa_final_target-c123_msl11
       TO c123_msl11.
      MOVE wa_final_target-c124_msl12
       TO c124_msl12.
      MOVE wa_final_target-c125_msl13
       TO c125_msl13.
      MOVE wa_final_target-c126_msl14
       TO c126_msl14.
      MOVE wa_final_target-c127_msl15
       TO c127_msl15.
      MOVE wa_final_target-c128_msl16
       TO c128_msl16.
      MOVE wa_final_target-c129_timestamp
       TO c129_timestamp.
      MOVE wa_final_target-c130_curin
       TO c130_curin.
      MOVE wa_final_target-c131_curha
       TO c131_curha.
      MOVE wa_final_target-c132_waers
       TO c132_waers.
      SHIFT c24_hsl01 UP TO '-' LEFT CIRCULAR.
      SHIFT c25_hsl02 UP TO '-' LEFT CIRCULAR.
      SHIFT c26_hsl03 UP TO '-' LEFT CIRCULAR.
      SHIFT c27_hsl04 UP TO '-' LEFT CIRCULAR.
      SHIFT c28_hsl05 UP TO '-' LEFT CIRCULAR.
      SHIFT c29_hsl06 UP TO '-' LEFT CIRCULAR.
      SHIFT c30_hsl07 UP TO '-' LEFT CIRCULAR.
      SHIFT c31_hsl08 UP TO '-' LEFT CIRCULAR.
      SHIFT c32_hsl09 UP TO '-' LEFT CIRCULAR.
      SHIFT c33_hsl10 UP TO '-' LEFT CIRCULAR.
      SHIFT c34_hsl11 UP TO '-' LEFT CIRCULAR.
      SHIFT c35_hsl12 UP TO '-' LEFT CIRCULAR.
      SHIFT c36_hsl13 UP TO '-' LEFT CIRCULAR.
      SHIFT c37_hsl14 UP TO '-' LEFT CIRCULAR.
      SHIFT c38_hsl15 UP TO '-' LEFT CIRCULAR.
      SHIFT c39_hsl16 UP TO '-' LEFT CIRCULAR.
      SHIFT c41_hslvt UP TO '-' LEFT CIRCULAR.
      SHIFT c42_tslvt UP TO '-' LEFT CIRCULAR.
      SHIFT c43_kslvt UP TO '-' LEFT CIRCULAR.
      SHIFT c45_tsl05 UP TO '-' LEFT CIRCULAR.
      SHIFT c46_tsl01 UP TO '-' LEFT CIRCULAR.
      SHIFT c47_tsl06 UP TO '-' LEFT CIRCULAR.
      SHIFT c48_tsl02 UP TO '-' LEFT CIRCULAR.
      SHIFT c49_tsl04 UP TO '-' LEFT CIRCULAR.
      SHIFT c50_tsl03 UP TO '-' LEFT CIRCULAR.
      SHIFT c51_tsl07 UP TO '-' LEFT CIRCULAR.
      SHIFT c52_tsl12 UP TO '-' LEFT CIRCULAR.
      SHIFT c53_tsl08 UP TO '-' LEFT CIRCULAR.
      SHIFT c54_tsl11 UP TO '-' LEFT CIRCULAR.
      SHIFT c55_tsl09 UP TO '-' LEFT CIRCULAR.
      SHIFT c56_tsl10 UP TO '-' LEFT CIRCULAR.
      SHIFT c57_tsl13 UP TO '-' LEFT CIRCULAR.
      SHIFT c58_tsl16 UP TO '-' LEFT CIRCULAR.
      SHIFT c59_tsl14 UP TO '-' LEFT CIRCULAR.
      SHIFT c60_tsl15 UP TO '-' LEFT CIRCULAR.
      SHIFT c62_ksl11 UP TO '-' LEFT CIRCULAR.
      SHIFT c63_ksl02 UP TO '-' LEFT CIRCULAR.
      SHIFT c64_ksl10 UP TO '-' LEFT CIRCULAR.
      SHIFT c65_ksl15 UP TO '-' LEFT CIRCULAR.
      SHIFT c66_ksl07 UP TO '-' LEFT CIRCULAR.
      SHIFT c67_ksl09 UP TO '-' LEFT CIRCULAR.
      SHIFT c68_ksl03 UP TO '-' LEFT CIRCULAR.
      SHIFT c69_ksl08 UP TO '-' LEFT CIRCULAR.
      SHIFT c70_ksl14 UP TO '-' LEFT CIRCULAR.
      SHIFT c71_ksl04 UP TO '-' LEFT CIRCULAR.
      SHIFT c72_ksl05 UP TO '-' LEFT CIRCULAR.
      SHIFT c73_ksl01 UP TO '-' LEFT CIRCULAR.
      SHIFT c74_ksl12 UP TO '-' LEFT CIRCULAR.
      SHIFT c75_ksl13 UP TO '-' LEFT CIRCULAR.
      SHIFT c76_ksl06 UP TO '-' LEFT CIRCULAR.
      SHIFT c77_ksl16 UP TO '-' LEFT CIRCULAR.
      SHIFT c80_objnr00 UP TO '-' LEFT CIRCULAR.
      SHIFT c81_objnr01 UP TO '-' LEFT CIRCULAR.
      SHIFT c82_objnr02 UP TO '-' LEFT CIRCULAR.
      SHIFT c83_objnr03 UP TO '-' LEFT CIRCULAR.
      SHIFT c84_objnr04 UP TO '-' LEFT CIRCULAR.
      SHIFT c85_objnr05 UP TO '-' LEFT CIRCULAR.
      SHIFT c86_objnr06 UP TO '-' LEFT CIRCULAR.
      SHIFT c87_objnr07 UP TO '-' LEFT CIRCULAR.
      SHIFT c88_objnr08 UP TO '-' LEFT CIRCULAR.
      SHIFT c95_oslvt UP TO '-' LEFT CIRCULAR.
      SHIFT c96_osl01 UP TO '-' LEFT CIRCULAR.
      SHIFT c97_osl02 UP TO '-' LEFT CIRCULAR.
      SHIFT c98_osl03 UP TO '-' LEFT CIRCULAR.
      SHIFT c99_osl04 UP TO '-' LEFT CIRCULAR.
      SHIFT c100_osl05 UP TO '-' LEFT CIRCULAR.
      SHIFT c101_osl06 UP TO '-' LEFT CIRCULAR.
      SHIFT c102_osl07 UP TO '-' LEFT CIRCULAR.
      SHIFT c103_osl08 UP TO '-' LEFT CIRCULAR.
      SHIFT c104_osl09 UP TO '-' LEFT CIRCULAR.
      SHIFT c105_osl10 UP TO '-' LEFT CIRCULAR.
      SHIFT c106_osl11 UP TO '-' LEFT CIRCULAR.
      SHIFT c107_osl12 UP TO '-' LEFT CIRCULAR.
      SHIFT c108_osl13 UP TO '-' LEFT CIRCULAR.
      SHIFT c109_osl14 UP TO '-' LEFT CIRCULAR.
      SHIFT c110_osl15 UP TO '-' LEFT CIRCULAR.
      SHIFT c111_osl16 UP TO '-' LEFT CIRCULAR.
      SHIFT c112_mslvt UP TO '-' LEFT CIRCULAR.
      SHIFT c113_msl01 UP TO '-' LEFT CIRCULAR.
      SHIFT c114_msl02 UP TO '-' LEFT CIRCULAR.
      SHIFT c115_msl03 UP TO '-' LEFT CIRCULAR.
      SHIFT c116_msl04 UP TO '-' LEFT CIRCULAR.
      SHIFT c117_msl05 UP TO '-' LEFT CIRCULAR.
      SHIFT c118_msl06 UP TO '-' LEFT CIRCULAR.
      SHIFT c119_msl07 UP TO '-' LEFT CIRCULAR.
      SHIFT c120_msl08 UP TO '-' LEFT CIRCULAR.
      SHIFT c121_msl09 UP TO '-' LEFT CIRCULAR.
      SHIFT c122_msl10 UP TO '-' LEFT CIRCULAR.
      SHIFT c123_msl11 UP TO '-' LEFT CIRCULAR.
      SHIFT c124_msl12 UP TO '-' LEFT CIRCULAR.
      SHIFT c125_msl13 UP TO '-' LEFT CIRCULAR.
      SHIFT c126_msl14 UP TO '-' LEFT CIRCULAR.
      SHIFT c127_msl15 UP TO '-' LEFT CIRCULAR.
      SHIFT c128_msl16 UP TO '-' LEFT CIRCULAR.
      SHIFT c129_timestamp UP TO '-' LEFT CIRCULAR.
      CONCATENATE
      c1_butxt
      c2_fikrs
      c3_waers
      c4_ktopl
      c5_ltext
      c6_rbukrs
      c7_rbusa
      c8_rfarea
      c9_segment
      c10_prctr
      c11_rassc
      c12_ryear
      c13_sbusa
      c14_sfarea
      c15_pprctr
      c16_rpmax
      c17_racct
      c18_rvers
      c19_rldnr
      c20_logsys
      c21_cost_elem
      c22_rcntr
      c23_kokrs
      c24_hsl01
      c25_hsl02
      c26_hsl03
      c27_hsl04
      c28_hsl05
      c29_hsl06
      c30_hsl07
      c31_hsl08
      c32_hsl09
      c33_hsl10
      c34_hsl11
      c35_hsl12
      c36_hsl13
      c37_hsl14
      c38_hsl15
      c39_hsl16
      c40_drcrk
      c41_hslvt
      c42_tslvt
      c43_kslvt
      c44_rtcur
      c45_tsl05
      c46_tsl01
      c47_tsl06
      c48_tsl02
      c49_tsl04
      c50_tsl03
      c51_tsl07
      c52_tsl12
      c53_tsl08
      c54_tsl11
      c55_tsl09
      c56_tsl10
      c57_tsl13
      c58_tsl16
      c59_tsl14
      c60_tsl15
      c61_rrcty
      c62_ksl11
      c63_ksl02
      c64_ksl10
      c65_ksl15
      c66_ksl07
      c67_ksl09
      c68_ksl03
      c69_ksl08
      c70_ksl14
      c71_ksl04
      c72_ksl05
      c73_ksl01
      c74_ksl12
      c75_ksl13
      c76_ksl06
      c77_ksl16
      c78_rclnt
      c79_mwaer
      c80_objnr00
      c81_objnr01
      c82_objnr02
      c83_objnr03
      c84_objnr04
      c85_objnr05
      c86_objnr06
      c87_objnr07
      c88_objnr08
      c89_activ
      c90_rmvct
      c91_runit
      c92_awtyp
      c93_scntr
      c94_psegment
      c95_oslvt
      c96_osl01
      c97_osl02
      c98_osl03
      c99_osl04
      c100_osl05
      c101_osl06
      c102_osl07
      c103_osl08
      c104_osl09
      c105_osl10
      c106_osl11
      c107_osl12
      c108_osl13
      c109_osl14
      c110_osl15
      c111_osl16
      c112_mslvt
      c113_msl01
      c114_msl02
      c115_msl03
      c116_msl04
      c117_msl05
      c118_msl06
      c119_msl07
      c120_msl08
      c121_msl09
      c122_msl10
      c123_msl11
      c124_msl12
      c125_msl13
      c126_msl14
      c127_msl15
      c128_msl16
      c129_timestamp
      c130_curin
      c131_curha
      c132_waers
      INTO wa_final_string
      SEPARATED BY '|'.
*      IF sy-tabix EQ 1 AND lv_cnt EQ 1.
*        CONCATENATE wa_final_string
*        lv_delimiter INTO wa_final_string.
*      ELSE.
*        CONCATENATE '' lv_delimiter wa_final_string
*        lv_delimiter INTO wa_final_string.
*      ENDIF.
      APPEND wa_final_string TO gt_result.
      CLEAR : c1_butxt,
      c2_fikrs,
      c3_waers,
      c4_ktopl,
      c5_ltext,
      c6_rbukrs,
      c7_rbusa,
      c8_rfarea,
      c9_segment,
      c10_prctr,
      c11_rassc,
      c12_ryear,
      c13_sbusa,
      c14_sfarea,
      c15_pprctr,
      c16_rpmax,
      c17_racct,
      c18_rvers,
      c19_rldnr,
      c20_logsys,
      c21_cost_elem,
      c22_rcntr,
      c23_kokrs,
      c24_hsl01,
      c25_hsl02,
      c26_hsl03,
      c27_hsl04,
      c28_hsl05,
      c29_hsl06,
      c30_hsl07,
      c31_hsl08,
      c32_hsl09,
      c33_hsl10,
      c34_hsl11,
      c35_hsl12,
      c36_hsl13,
      c37_hsl14,
      c38_hsl15,
      c39_hsl16,
      c40_drcrk,
      c41_hslvt,
      c42_tslvt,
      c43_kslvt,
      c44_rtcur,
      c45_tsl05,
      c46_tsl01,
      c47_tsl06,
      c48_tsl02,
      c49_tsl04,
      c50_tsl03,
      c51_tsl07,
      c52_tsl12,
      c53_tsl08,
      c54_tsl11,
      c55_tsl09,
      c56_tsl10,
      c57_tsl13,
      c58_tsl16,
      c59_tsl14,
      c60_tsl15,
      c61_rrcty,
      c62_ksl11,
      c63_ksl02,
      c64_ksl10,
      c65_ksl15,
      c66_ksl07,
      c67_ksl09,
      c68_ksl03,
      c69_ksl08,
      c70_ksl14,
      c71_ksl04,
      c72_ksl05,
      c73_ksl01,
      c74_ksl12,
      c75_ksl13,
      c76_ksl06,
      c77_ksl16,
      c78_rclnt,
      c79_mwaer,
      c80_objnr00,
      c81_objnr01,
      c82_objnr02,
      c83_objnr03,
      c84_objnr04,
      c85_objnr05,
      c86_objnr06,
      c87_objnr07,
      c88_objnr08,
      c89_activ,
      c90_rmvct,
      c91_runit,
      c92_awtyp,
      c93_scntr,
      c94_psegment,
      c95_oslvt,
      c96_osl01,
      c97_osl02,
      c98_osl03,
      c99_osl04,
      c100_osl05,
      c101_osl06,
      c102_osl07,
      c103_osl08,
      c104_osl09,
      c105_osl10,
      c106_osl11,
      c107_osl12,
      c108_osl13,
      c109_osl14,
      c110_osl15,
      c111_osl16,
      c112_mslvt,
      c113_msl01,
      c114_msl02,
      c115_msl03,
      c116_msl04,
      c117_msl05,
      c118_msl06,
      c119_msl07,
      c120_msl08,
      c121_msl09,
      c122_msl10,
      c123_msl11,
      c124_msl12,
      c125_msl13,
      c126_msl14,
      c127_msl15,
      c128_msl16,
      c129_timestamp,
      c130_curin,
      c131_curha,
      c132_waers.
    ENDLOOP.
    FREE : tt_final_target.
    IF NOT gt_result IS INITIAL.
      CLEAR wa_result.
      LOOP AT gt_result INTO wa_result.
        TRANSFER wa_result TO p_file.
      ENDLOOP.
    ENDIF.
    DESCRIBE TABLE gt_result LINES lv_cnt.
    WRITE : 'No of records in final table is :',lv_cnt.
    REFRESH gt_result.
*END of main loop for batching
  ENDDO.
*Close dataset
  CLOSE DATASET p_file.
**Error Handling for closing dataset
  IF sy-subrc NE 0.
    CLEAR et_file_return.
    et_file_return-type = 'E'.
    et_file_return-message =
    'Error occured in closing the dataset'.
    APPEND et_file_return.
  ENDIF.
  CLOSE CURSOR lv_t001_dbcur.
  DESCRIBE TABLE gt_result LINES lv_cnt.
  WRITE : 'No of records in final table is :',lv_cnt.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  INITIALISE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialise .

  CONCATENATE text-003 text-002 p_year '.txt' INTO p_file.

ENDFORM.                    " INITIALISE
