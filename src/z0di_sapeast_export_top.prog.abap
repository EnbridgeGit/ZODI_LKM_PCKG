*&---------------------------------------------------------------------*
*&  Include           Z0DI_SAPEAST_EXPORT_TOP
*&---------------------------------------------------------------------*
TABLES : faglflext.
************************
*Final Type declarations
************************
TYPES : BEGIN OF ty_final,

d1_land1 TYPE
 t001-land1,
d2_land1 TYPE
 t005-land1,
d3_waers TYPE
 t001-waers,
d4_waers TYPE
 tcurt-waers,
d5_bukrs TYPE
 t001-bukrs,
d6_rbukrs TYPE
 faglflext-rbukrs,
d7_rclnt TYPE
 faglflext-rclnt,
d8_mandt TYPE
 t000-mandt,
c1_butxt TYPE
 t001-butxt,
c2_fikrs TYPE
 t001-fikrs,
c4_ktopl TYPE
 t001-ktopl,
c5_ltext TYPE
 tcurt-ltext,
c7_rbusa TYPE
 faglflext-rbusa,
c8_rfarea TYPE
 faglflext-rfarea,
c9_segment TYPE
 faglflext-segment,
c10_prctr TYPE
 faglflext-prctr,
c11_rassc TYPE
 faglflext-rassc,
c12_ryear TYPE
 faglflext-ryear,
c13_sbusa TYPE
 faglflext-sbusa,
c14_sfarea TYPE
 faglflext-sfarea,
c15_pprctr TYPE
 faglflext-pprctr,
c16_rpmax TYPE
 faglflext-rpmax,
c17_racct TYPE
 faglflext-racct,
c18_rvers TYPE
 faglflext-rvers,
c19_rldnr TYPE
 faglflext-rldnr,
c20_logsys TYPE
 faglflext-logsys,
c21_cost_elem TYPE
 faglflext-cost_elem,
c22_rcntr TYPE
 faglflext-rcntr,
c23_kokrs TYPE
 faglflext-kokrs,
c24_hsl01 TYPE
 faglflext-hsl01,
c25_hsl02 TYPE
 faglflext-hsl02,
c26_hsl03 TYPE
 faglflext-hsl03,
c27_hsl04 TYPE
 faglflext-hsl04,
c28_hsl05 TYPE
 faglflext-hsl05,
c29_hsl06 TYPE
 faglflext-hsl06,
c30_hsl07 TYPE
 faglflext-hsl07,
c31_hsl08 TYPE
 faglflext-hsl08,
c32_hsl09 TYPE
 faglflext-hsl09,
c33_hsl10 TYPE
 faglflext-hsl10,
c34_hsl11 TYPE
 faglflext-hsl11,
c35_hsl12 TYPE
 faglflext-hsl12,
c36_hsl13 TYPE
 faglflext-hsl13,
c37_hsl14 TYPE
 faglflext-hsl14,
c38_hsl15 TYPE
 faglflext-hsl15,
c39_hsl16 TYPE
 faglflext-hsl16,
c40_drcrk TYPE
 faglflext-drcrk,
c41_hslvt TYPE
 faglflext-hslvt,
c42_tslvt TYPE
 faglflext-tslvt,
c43_kslvt TYPE
 faglflext-kslvt,
c44_rtcur TYPE
 faglflext-rtcur,
c45_tsl05 TYPE
 faglflext-tsl05,
c46_tsl01 TYPE
 faglflext-tsl01,
c47_tsl06 TYPE
 faglflext-tsl06,
c48_tsl02 TYPE
 faglflext-tsl02,
c49_tsl04 TYPE
 faglflext-tsl04,
c50_tsl03 TYPE
 faglflext-tsl03,
c51_tsl07 TYPE
 faglflext-tsl07,
c52_tsl12 TYPE
 faglflext-tsl12,
c53_tsl08 TYPE
 faglflext-tsl08,
c54_tsl11 TYPE
 faglflext-tsl11,
c55_tsl09 TYPE
 faglflext-tsl09,
c56_tsl10 TYPE
 faglflext-tsl10,
c57_tsl13 TYPE
 faglflext-tsl13,
c58_tsl16 TYPE
 faglflext-tsl16,
c59_tsl14 TYPE
 faglflext-tsl14,
c60_tsl15 TYPE
 faglflext-tsl15,
c61_rrcty TYPE
 faglflext-rrcty,
c62_ksl11 TYPE
 faglflext-ksl11,
c63_ksl02 TYPE
 faglflext-ksl02,
c64_ksl10 TYPE
 faglflext-ksl10,
c65_ksl15 TYPE
 faglflext-ksl15,
c66_ksl07 TYPE
 faglflext-ksl07,
c67_ksl09 TYPE
 faglflext-ksl09,
c68_ksl03 TYPE
 faglflext-ksl03,
c69_ksl08 TYPE
 faglflext-ksl08,
c70_ksl14 TYPE
 faglflext-ksl14,
c71_ksl04 TYPE
 faglflext-ksl04,
c72_ksl05 TYPE
 faglflext-ksl05,
c73_ksl01 TYPE
 faglflext-ksl01,
c74_ksl12 TYPE
 faglflext-ksl12,
c75_ksl13 TYPE
 faglflext-ksl13,
c76_ksl06 TYPE
 faglflext-ksl06,
c77_ksl16 TYPE
 faglflext-ksl16,
c79_mwaer TYPE
 t000-mwaer,
c80_objnr00 TYPE
 faglflext-objnr00,
c81_objnr01 TYPE
 faglflext-objnr01,
c82_objnr02 TYPE
 faglflext-objnr02,
c83_objnr03 TYPE
 faglflext-objnr03,
c84_objnr04 TYPE
 faglflext-objnr04,
c85_objnr05 TYPE
 faglflext-objnr05,
c86_objnr06 TYPE
 faglflext-objnr06,
c87_objnr07 TYPE
 faglflext-objnr07,
c88_objnr08 TYPE
 faglflext-objnr08,
c89_activ TYPE
 faglflext-activ,
c90_rmvct TYPE
 faglflext-rmvct,
c91_runit TYPE
 faglflext-runit,
c92_awtyp TYPE
 faglflext-awtyp,
c93_scntr TYPE
 faglflext-scntr,
c94_psegment TYPE
 faglflext-psegment,
c95_oslvt TYPE
 faglflext-oslvt,
c96_osl01 TYPE
 faglflext-osl01,
c97_osl02 TYPE
 faglflext-osl02,
c98_osl03 TYPE
 faglflext-osl03,
c99_osl04 TYPE
 faglflext-osl04,
c100_osl05 TYPE
 faglflext-osl05,
c101_osl06 TYPE
 faglflext-osl06,
c102_osl07 TYPE
 faglflext-osl07,
c103_osl08 TYPE
 faglflext-osl08,
c104_osl09 TYPE
 faglflext-osl09,
c105_osl10 TYPE
 faglflext-osl10,
c106_osl11 TYPE
 faglflext-osl11,
c107_osl12 TYPE
 faglflext-osl12,
c108_osl13 TYPE
 faglflext-osl13,
c109_osl14 TYPE
 faglflext-osl14,
c110_osl15 TYPE
 faglflext-osl15,
c111_osl16 TYPE
 faglflext-osl16,
c112_mslvt TYPE
 faglflext-mslvt,
c113_msl01 TYPE
 faglflext-msl01,
c114_msl02 TYPE
 faglflext-msl02,
c115_msl03 TYPE
 faglflext-msl03,
c116_msl04 TYPE
 faglflext-msl04,
c117_msl05 TYPE
 faglflext-msl05,
c118_msl06 TYPE
 faglflext-msl06,
c119_msl07 TYPE
 faglflext-msl07,
c120_msl08 TYPE
 faglflext-msl08,
c121_msl09 TYPE
 faglflext-msl09,
c122_msl10 TYPE
 faglflext-msl10,
c123_msl11 TYPE
 faglflext-msl11,
c124_msl12 TYPE
 faglflext-msl12,
c125_msl13 TYPE
 faglflext-msl13,
c126_msl14 TYPE
 faglflext-msl14,
c127_msl15 TYPE
 faglflext-msl15,
c128_msl16 TYPE
 faglflext-msl16,
c129_timestamp TYPE
 faglflext-timestamp,
c130_curin TYPE
 t005-curin,
c131_curha TYPE
 t005-curha,
c132_waers TYPE
 t005-waers,
END OF ty_final.
*****************************
*Final Temp Type Declarations
*****************************
TYPES : BEGIN OF ty_final_tmp,

c1_butxt TYPE
 t001-butxt,
c2_fikrs TYPE
 t001-fikrs,
d3_waers TYPE
 t001-waers,
c4_ktopl TYPE
 t001-ktopl,
c5_ltext TYPE
 tcurt-ltext,
d6_rbukrs TYPE
 faglflext-rbukrs,
c7_rbusa TYPE
 faglflext-rbusa,
c8_rfarea TYPE
 faglflext-rfarea,
c9_segment TYPE
 faglflext-segment,
c10_prctr TYPE
 faglflext-prctr,
c11_rassc TYPE
 faglflext-rassc,
c12_ryear TYPE
 faglflext-ryear,
c13_sbusa TYPE
 faglflext-sbusa,
c14_sfarea TYPE
 faglflext-sfarea,
c15_pprctr TYPE
 faglflext-pprctr,
c16_rpmax TYPE
 faglflext-rpmax,
c17_racct TYPE
 faglflext-racct,
c18_rvers TYPE
 faglflext-rvers,
c19_rldnr TYPE
 faglflext-rldnr,
c20_logsys TYPE
 faglflext-logsys,
c21_cost_elem TYPE
 faglflext-cost_elem,
c22_rcntr TYPE
 faglflext-rcntr,
c23_kokrs TYPE
 faglflext-kokrs,
c24_hsl01 TYPE
 faglflext-hsl01,
c25_hsl02 TYPE
 faglflext-hsl02,
c26_hsl03 TYPE
 faglflext-hsl03,
c27_hsl04 TYPE
 faglflext-hsl04,
c28_hsl05 TYPE
 faglflext-hsl05,
c29_hsl06 TYPE
 faglflext-hsl06,
c30_hsl07 TYPE
 faglflext-hsl07,
c31_hsl08 TYPE
 faglflext-hsl08,
c32_hsl09 TYPE
 faglflext-hsl09,
c33_hsl10 TYPE
 faglflext-hsl10,
c34_hsl11 TYPE
 faglflext-hsl11,
c35_hsl12 TYPE
 faglflext-hsl12,
c36_hsl13 TYPE
 faglflext-hsl13,
c37_hsl14 TYPE
 faglflext-hsl14,
c38_hsl15 TYPE
 faglflext-hsl15,
c39_hsl16 TYPE
 faglflext-hsl16,
c40_drcrk TYPE
 faglflext-drcrk,
c41_hslvt TYPE
 faglflext-hslvt,
c42_tslvt TYPE
 faglflext-tslvt,
c43_kslvt TYPE
 faglflext-kslvt,
c44_rtcur TYPE
 faglflext-rtcur,
c45_tsl05 TYPE
 faglflext-tsl05,
c46_tsl01 TYPE
 faglflext-tsl01,
c47_tsl06 TYPE
 faglflext-tsl06,
c48_tsl02 TYPE
 faglflext-tsl02,
c49_tsl04 TYPE
 faglflext-tsl04,
c50_tsl03 TYPE
 faglflext-tsl03,
c51_tsl07 TYPE
 faglflext-tsl07,
c52_tsl12 TYPE
 faglflext-tsl12,
c53_tsl08 TYPE
 faglflext-tsl08,
c54_tsl11 TYPE
 faglflext-tsl11,
c55_tsl09 TYPE
 faglflext-tsl09,
c56_tsl10 TYPE
 faglflext-tsl10,
c57_tsl13 TYPE
 faglflext-tsl13,
c58_tsl16 TYPE
 faglflext-tsl16,
c59_tsl14 TYPE
 faglflext-tsl14,
c60_tsl15 TYPE
 faglflext-tsl15,
c61_rrcty TYPE
 faglflext-rrcty,
c62_ksl11 TYPE
 faglflext-ksl11,
c63_ksl02 TYPE
 faglflext-ksl02,
c64_ksl10 TYPE
 faglflext-ksl10,
c65_ksl15 TYPE
 faglflext-ksl15,
c66_ksl07 TYPE
 faglflext-ksl07,
c67_ksl09 TYPE
 faglflext-ksl09,
c68_ksl03 TYPE
 faglflext-ksl03,
c69_ksl08 TYPE
 faglflext-ksl08,
c70_ksl14 TYPE
 faglflext-ksl14,
c71_ksl04 TYPE
 faglflext-ksl04,
c72_ksl05 TYPE
 faglflext-ksl05,
c73_ksl01 TYPE
 faglflext-ksl01,
c74_ksl12 TYPE
 faglflext-ksl12,
c75_ksl13 TYPE
 faglflext-ksl13,
c76_ksl06 TYPE
 faglflext-ksl06,
c77_ksl16 TYPE
 faglflext-ksl16,
d7_rclnt TYPE
 faglflext-rclnt,
c79_mwaer TYPE
 t000-mwaer,
c80_objnr00 TYPE
 faglflext-objnr00,
c81_objnr01 TYPE
 faglflext-objnr01,
c82_objnr02 TYPE
 faglflext-objnr02,
c83_objnr03 TYPE
 faglflext-objnr03,
c84_objnr04 TYPE
 faglflext-objnr04,
c85_objnr05 TYPE
 faglflext-objnr05,
c86_objnr06 TYPE
 faglflext-objnr06,
c87_objnr07 TYPE
 faglflext-objnr07,
c88_objnr08 TYPE
 faglflext-objnr08,
c89_activ TYPE
 faglflext-activ,
c90_rmvct TYPE
 faglflext-rmvct,
c91_runit TYPE
 faglflext-runit,
c92_awtyp TYPE
 faglflext-awtyp,
c93_scntr TYPE
 faglflext-scntr,
c94_psegment TYPE
 faglflext-psegment,
c95_oslvt TYPE
 faglflext-oslvt,
c96_osl01 TYPE
 faglflext-osl01,
c97_osl02 TYPE
 faglflext-osl02,
c98_osl03 TYPE
 faglflext-osl03,
c99_osl04 TYPE
 faglflext-osl04,
c100_osl05 TYPE
 faglflext-osl05,
c101_osl06 TYPE
 faglflext-osl06,
c102_osl07 TYPE
 faglflext-osl07,
c103_osl08 TYPE
 faglflext-osl08,
c104_osl09 TYPE
 faglflext-osl09,
c105_osl10 TYPE
 faglflext-osl10,
c106_osl11 TYPE
 faglflext-osl11,
c107_osl12 TYPE
 faglflext-osl12,
c108_osl13 TYPE
 faglflext-osl13,
c109_osl14 TYPE
 faglflext-osl14,
c110_osl15 TYPE
 faglflext-osl15,
c111_osl16 TYPE
 faglflext-osl16,
c112_mslvt TYPE
 faglflext-mslvt,
c113_msl01 TYPE
 faglflext-msl01,
c114_msl02 TYPE
 faglflext-msl02,
c115_msl03 TYPE
 faglflext-msl03,
c116_msl04 TYPE
 faglflext-msl04,
c117_msl05 TYPE
 faglflext-msl05,
c118_msl06 TYPE
 faglflext-msl06,
c119_msl07 TYPE
 faglflext-msl07,
c120_msl08 TYPE
 faglflext-msl08,
c121_msl09 TYPE
 faglflext-msl09,
c122_msl10 TYPE
 faglflext-msl10,
c123_msl11 TYPE
 faglflext-msl11,
c124_msl12 TYPE
 faglflext-msl12,
c125_msl13 TYPE
 faglflext-msl13,
c126_msl14 TYPE
 faglflext-msl14,
c127_msl15 TYPE
 faglflext-msl15,
c128_msl16 TYPE
 faglflext-msl16,
c129_timestamp TYPE
 faglflext-timestamp,
c130_curin TYPE
 t005-curin,
c131_curha TYPE
 t005-curha,
c132_waers TYPE
 t005-waers,
END OF ty_final_tmp.
*******************************
*Final Target Type Declarations
*******************************
TYPES : BEGIN OF ty_final_target,

c1_butxt TYPE
 t001-butxt,
c2_fikrs TYPE
 t001-fikrs,
c3_waers TYPE
 t001-waers,
c4_ktopl TYPE
 t001-ktopl,
c5_ltext TYPE
 tcurt-ltext,
c6_rbukrs TYPE
 faglflext-rbukrs,
c7_rbusa TYPE
 faglflext-rbusa,
c8_rfarea TYPE
 faglflext-rfarea,
c9_segment TYPE
 faglflext-segment,
c10_prctr TYPE
 faglflext-prctr,
c11_rassc TYPE
 faglflext-rassc,
c12_ryear TYPE
 faglflext-ryear,
c13_sbusa TYPE
 faglflext-sbusa,
c14_sfarea TYPE
 faglflext-sfarea,
c15_pprctr TYPE
 faglflext-pprctr,
c16_rpmax TYPE
 faglflext-rpmax,
c17_racct TYPE
 faglflext-racct,
c18_rvers TYPE
 faglflext-rvers,
c19_rldnr TYPE
 faglflext-rldnr,
c20_logsys TYPE
 faglflext-logsys,
c21_cost_elem TYPE
 faglflext-cost_elem,
c22_rcntr TYPE
 faglflext-rcntr,
c23_kokrs TYPE
 faglflext-kokrs,
c24_hsl01 TYPE
 faglflext-hsl01,
c25_hsl02 TYPE
 faglflext-hsl02,
c26_hsl03 TYPE
 faglflext-hsl03,
c27_hsl04 TYPE
 faglflext-hsl04,
c28_hsl05 TYPE
 faglflext-hsl05,
c29_hsl06 TYPE
 faglflext-hsl06,
c30_hsl07 TYPE
 faglflext-hsl07,
c31_hsl08 TYPE
 faglflext-hsl08,
c32_hsl09 TYPE
 faglflext-hsl09,
c33_hsl10 TYPE
 faglflext-hsl10,
c34_hsl11 TYPE
 faglflext-hsl11,
c35_hsl12 TYPE
 faglflext-hsl12,
c36_hsl13 TYPE
 faglflext-hsl13,
c37_hsl14 TYPE
 faglflext-hsl14,
c38_hsl15 TYPE
 faglflext-hsl15,
c39_hsl16 TYPE
 faglflext-hsl16,
c40_drcrk TYPE
 faglflext-drcrk,
c41_hslvt TYPE
 faglflext-hslvt,
c42_tslvt TYPE
 faglflext-tslvt,
c43_kslvt TYPE
 faglflext-kslvt,
c44_rtcur TYPE
 faglflext-rtcur,
c45_tsl05 TYPE
 faglflext-tsl05,
c46_tsl01 TYPE
 faglflext-tsl01,
c47_tsl06 TYPE
 faglflext-tsl06,
c48_tsl02 TYPE
 faglflext-tsl02,
c49_tsl04 TYPE
 faglflext-tsl04,
c50_tsl03 TYPE
 faglflext-tsl03,
c51_tsl07 TYPE
 faglflext-tsl07,
c52_tsl12 TYPE
 faglflext-tsl12,
c53_tsl08 TYPE
 faglflext-tsl08,
c54_tsl11 TYPE
 faglflext-tsl11,
c55_tsl09 TYPE
 faglflext-tsl09,
c56_tsl10 TYPE
 faglflext-tsl10,
c57_tsl13 TYPE
 faglflext-tsl13,
c58_tsl16 TYPE
 faglflext-tsl16,
c59_tsl14 TYPE
 faglflext-tsl14,
c60_tsl15 TYPE
 faglflext-tsl15,
c61_rrcty TYPE
 faglflext-rrcty,
c62_ksl11 TYPE
 faglflext-ksl11,
c63_ksl02 TYPE
 faglflext-ksl02,
c64_ksl10 TYPE
 faglflext-ksl10,
c65_ksl15 TYPE
 faglflext-ksl15,
c66_ksl07 TYPE
 faglflext-ksl07,
c67_ksl09 TYPE
 faglflext-ksl09,
c68_ksl03 TYPE
 faglflext-ksl03,
c69_ksl08 TYPE
 faglflext-ksl08,
c70_ksl14 TYPE
 faglflext-ksl14,
c71_ksl04 TYPE
 faglflext-ksl04,
c72_ksl05 TYPE
 faglflext-ksl05,
c73_ksl01 TYPE
 faglflext-ksl01,
c74_ksl12 TYPE
 faglflext-ksl12,
c75_ksl13 TYPE
 faglflext-ksl13,
c76_ksl06 TYPE
 faglflext-ksl06,
c77_ksl16 TYPE
 faglflext-ksl16,
c78_rclnt TYPE
 faglflext-rclnt,
c79_mwaer TYPE
 t000-mwaer,
c80_objnr00 TYPE
 faglflext-objnr00,
c81_objnr01 TYPE
 faglflext-objnr01,
c82_objnr02 TYPE
 faglflext-objnr02,
c83_objnr03 TYPE
 faglflext-objnr03,
c84_objnr04 TYPE
 faglflext-objnr04,
c85_objnr05 TYPE
 faglflext-objnr05,
c86_objnr06 TYPE
 faglflext-objnr06,
c87_objnr07 TYPE
 faglflext-objnr07,
c88_objnr08 TYPE
 faglflext-objnr08,
c89_activ TYPE
 faglflext-activ,
c90_rmvct TYPE
 faglflext-rmvct,
c91_runit TYPE
 faglflext-runit,
c92_awtyp TYPE
 faglflext-awtyp,
c93_scntr TYPE
 faglflext-scntr,
c94_psegment TYPE
 faglflext-psegment,
c95_oslvt TYPE
 faglflext-oslvt,
c96_osl01 TYPE
 faglflext-osl01,
c97_osl02 TYPE
 faglflext-osl02,
c98_osl03 TYPE
 faglflext-osl03,
c99_osl04 TYPE
 faglflext-osl04,
c100_osl05 TYPE
 faglflext-osl05,
c101_osl06 TYPE
 faglflext-osl06,
c102_osl07 TYPE
 faglflext-osl07,
c103_osl08 TYPE
 faglflext-osl08,
c104_osl09 TYPE
 faglflext-osl09,
c105_osl10 TYPE
 faglflext-osl10,
c106_osl11 TYPE
 faglflext-osl11,
c107_osl12 TYPE
 faglflext-osl12,
c108_osl13 TYPE
 faglflext-osl13,
c109_osl14 TYPE
 faglflext-osl14,
c110_osl15 TYPE
 faglflext-osl15,
c111_osl16 TYPE
 faglflext-osl16,
c112_mslvt TYPE
 faglflext-mslvt,
c113_msl01 TYPE
 faglflext-msl01,
c114_msl02 TYPE
 faglflext-msl02,
c115_msl03 TYPE
 faglflext-msl03,
c116_msl04 TYPE
 faglflext-msl04,
c117_msl05 TYPE
 faglflext-msl05,
c118_msl06 TYPE
 faglflext-msl06,
c119_msl07 TYPE
 faglflext-msl07,
c120_msl08 TYPE
 faglflext-msl08,
c121_msl09 TYPE
 faglflext-msl09,
c122_msl10 TYPE
 faglflext-msl10,
c123_msl11 TYPE
 faglflext-msl11,
c124_msl12 TYPE
 faglflext-msl12,
c125_msl13 TYPE
 faglflext-msl13,
c126_msl14 TYPE
 faglflext-msl14,
c127_msl15 TYPE
 faglflext-msl15,
c128_msl16 TYPE
 faglflext-msl16,
c129_timestamp TYPE
 faglflext-timestamp,
c130_curin TYPE
 t005-curin,
c131_curha TYPE
 t005-curha,
c132_waers TYPE
 t005-waers,
END OF ty_final_target.
**************************
* TABLE type for T001
**************************
TYPES : BEGIN OF ty_t001,

d1_land1 TYPE
 t001-land1,
d3_waers TYPE
 t001-waers,
d5_bukrs TYPE
 t001-bukrs,
c1_butxt TYPE
 t001-butxt,
c2_fikrs TYPE
 t001-fikrs,
c4_ktopl TYPE
 t001-ktopl,
END OF ty_t001.
**************************
* TABLE type for TCURT
**************************
TYPES : BEGIN OF ty_tcurt,

d4_waers TYPE
 tcurt-waers,
c5_ltext TYPE
 tcurt-ltext,
END OF ty_tcurt.
**************************
* TABLE type for FAGLFLEXT
**************************
TYPES : BEGIN OF ty_faglflext,

d6_rbukrs TYPE
 faglflext-rbukrs,
d7_rclnt TYPE
 faglflext-rclnt,
c7_rbusa TYPE
 faglflext-rbusa,
c8_rfarea TYPE
 faglflext-rfarea,
c9_segment TYPE
 faglflext-segment,
c10_prctr TYPE
 faglflext-prctr,
c11_rassc TYPE
 faglflext-rassc,
c12_ryear TYPE
 faglflext-ryear,
c13_sbusa TYPE
 faglflext-sbusa,
c14_sfarea TYPE
 faglflext-sfarea,
c15_pprctr TYPE
 faglflext-pprctr,
c16_rpmax TYPE
 faglflext-rpmax,
c17_racct TYPE
 faglflext-racct,
c18_rvers TYPE
 faglflext-rvers,
c19_rldnr TYPE
 faglflext-rldnr,
c20_logsys TYPE
 faglflext-logsys,
c21_cost_elem TYPE
 faglflext-cost_elem,
c22_rcntr TYPE
 faglflext-rcntr,
c23_kokrs TYPE
 faglflext-kokrs,
c24_hsl01 TYPE
 faglflext-hsl01,
c25_hsl02 TYPE
 faglflext-hsl02,
c26_hsl03 TYPE
 faglflext-hsl03,
c27_hsl04 TYPE
 faglflext-hsl04,
c28_hsl05 TYPE
 faglflext-hsl05,
c29_hsl06 TYPE
 faglflext-hsl06,
c30_hsl07 TYPE
 faglflext-hsl07,
c31_hsl08 TYPE
 faglflext-hsl08,
c32_hsl09 TYPE
 faglflext-hsl09,
c33_hsl10 TYPE
 faglflext-hsl10,
c34_hsl11 TYPE
 faglflext-hsl11,
c35_hsl12 TYPE
 faglflext-hsl12,
c36_hsl13 TYPE
 faglflext-hsl13,
c37_hsl14 TYPE
 faglflext-hsl14,
c38_hsl15 TYPE
 faglflext-hsl15,
c39_hsl16 TYPE
 faglflext-hsl16,
c40_drcrk TYPE
 faglflext-drcrk,
c41_hslvt TYPE
 faglflext-hslvt,
c42_tslvt TYPE
 faglflext-tslvt,
c43_kslvt TYPE
 faglflext-kslvt,
c44_rtcur TYPE
 faglflext-rtcur,
c45_tsl05 TYPE
 faglflext-tsl05,
c46_tsl01 TYPE
 faglflext-tsl01,
c47_tsl06 TYPE
 faglflext-tsl06,
c48_tsl02 TYPE
 faglflext-tsl02,
c49_tsl04 TYPE
 faglflext-tsl04,
c50_tsl03 TYPE
 faglflext-tsl03,
c51_tsl07 TYPE
 faglflext-tsl07,
c52_tsl12 TYPE
 faglflext-tsl12,
c53_tsl08 TYPE
 faglflext-tsl08,
c54_tsl11 TYPE
 faglflext-tsl11,
c55_tsl09 TYPE
 faglflext-tsl09,
c56_tsl10 TYPE
 faglflext-tsl10,
c57_tsl13 TYPE
 faglflext-tsl13,
c58_tsl16 TYPE
 faglflext-tsl16,
c59_tsl14 TYPE
 faglflext-tsl14,
c60_tsl15 TYPE
 faglflext-tsl15,
c61_rrcty TYPE
 faglflext-rrcty,
c62_ksl11 TYPE
 faglflext-ksl11,
c63_ksl02 TYPE
 faglflext-ksl02,
c64_ksl10 TYPE
 faglflext-ksl10,
c65_ksl15 TYPE
 faglflext-ksl15,
c66_ksl07 TYPE
 faglflext-ksl07,
c67_ksl09 TYPE
 faglflext-ksl09,
c68_ksl03 TYPE
 faglflext-ksl03,
c69_ksl08 TYPE
 faglflext-ksl08,
c70_ksl14 TYPE
 faglflext-ksl14,
c71_ksl04 TYPE
 faglflext-ksl04,
c72_ksl05 TYPE
 faglflext-ksl05,
c73_ksl01 TYPE
 faglflext-ksl01,
c74_ksl12 TYPE
 faglflext-ksl12,
c75_ksl13 TYPE
 faglflext-ksl13,
c76_ksl06 TYPE
 faglflext-ksl06,
c77_ksl16 TYPE
 faglflext-ksl16,
c80_objnr00 TYPE
 faglflext-objnr00,
c81_objnr01 TYPE
 faglflext-objnr01,
c82_objnr02 TYPE
 faglflext-objnr02,
c83_objnr03 TYPE
 faglflext-objnr03,
c84_objnr04 TYPE
 faglflext-objnr04,
c85_objnr05 TYPE
 faglflext-objnr05,
c86_objnr06 TYPE
 faglflext-objnr06,
c87_objnr07 TYPE
 faglflext-objnr07,
c88_objnr08 TYPE
 faglflext-objnr08,
c89_activ TYPE
 faglflext-activ,
c90_rmvct TYPE
 faglflext-rmvct,
c91_runit TYPE
 faglflext-runit,
c92_awtyp TYPE
 faglflext-awtyp,
c93_scntr TYPE
 faglflext-scntr,
c94_psegment TYPE
 faglflext-psegment,
c95_oslvt TYPE
 faglflext-oslvt,
c96_osl01 TYPE
 faglflext-osl01,
c97_osl02 TYPE
 faglflext-osl02,
c98_osl03 TYPE
 faglflext-osl03,
c99_osl04 TYPE
 faglflext-osl04,
c100_osl05 TYPE
 faglflext-osl05,
c101_osl06 TYPE
 faglflext-osl06,
c102_osl07 TYPE
 faglflext-osl07,
c103_osl08 TYPE
 faglflext-osl08,
c104_osl09 TYPE
 faglflext-osl09,
c105_osl10 TYPE
 faglflext-osl10,
c106_osl11 TYPE
 faglflext-osl11,
c107_osl12 TYPE
 faglflext-osl12,
c108_osl13 TYPE
 faglflext-osl13,
c109_osl14 TYPE
 faglflext-osl14,
c110_osl15 TYPE
 faglflext-osl15,
c111_osl16 TYPE
 faglflext-osl16,
c112_mslvt TYPE
 faglflext-mslvt,
c113_msl01 TYPE
 faglflext-msl01,
c114_msl02 TYPE
 faglflext-msl02,
c115_msl03 TYPE
 faglflext-msl03,
c116_msl04 TYPE
 faglflext-msl04,
c117_msl05 TYPE
 faglflext-msl05,
c118_msl06 TYPE
 faglflext-msl06,
c119_msl07 TYPE
 faglflext-msl07,
c120_msl08 TYPE
 faglflext-msl08,
c121_msl09 TYPE
 faglflext-msl09,
c122_msl10 TYPE
 faglflext-msl10,
c123_msl11 TYPE
 faglflext-msl11,
c124_msl12 TYPE
 faglflext-msl12,
c125_msl13 TYPE
 faglflext-msl13,
c126_msl14 TYPE
 faglflext-msl14,
c127_msl15 TYPE
 faglflext-msl15,
c128_msl16 TYPE
 faglflext-msl16,
c129_timestamp TYPE
 faglflext-timestamp,
END OF ty_faglflext.
**************************
* TABLE type for T000
**************************
TYPES : BEGIN OF ty_t000,

d8_mandt TYPE
 t000-mandt,
c79_mwaer TYPE
 t000-mwaer,
END OF ty_t000.
**************************
* TABLE type for T005
**************************
TYPES : BEGIN OF ty_t005,

d2_land1 TYPE
 t005-land1,
c130_curin TYPE
 t005-curin,
c131_curha TYPE
 t005-curha,
c132_waers TYPE
 t005-waers,
END OF ty_t005.
TYPES: BEGIN OF gs_text,
line TYPE string,
END OF gs_text.
************************
*Structure Declarations
************************
DATA: wa_final_tmp TYPE ty_final_tmp.
DATA: wa_final_string TYPE string,
      wa_final TYPE ty_final,
      wa_final_target TYPE ty_final_target,
wa_t001 TYPE ty_t001,
wa_tcurt TYPE ty_tcurt,
wa_faglflext TYPE ty_faglflext,
wa_t000 TYPE ty_t000,
wa_t005 TYPE ty_t005,
********************
*TABLE Declarations
********************
gt_result TYPE TABLE OF string,
tt_final TYPE STANDARD TABLE OF ty_final,
tt_final_target TYPE STANDARD
TABLE OF ty_final_target,
tt_final_tmp TYPE STANDARD
TABLE OF ty_final_tmp,
tt_final_tmp1 TYPE STANDARD
TABLE OF ty_final,
*Intermediate Output Internal TABLE for join 1
tt_final1 TYPE STANDARD TABLE OF ty_final,
*Intermediate Output Internal TABLE for join 2
tt_final2 TYPE STANDARD TABLE OF ty_final,
*Intermediate Output Internal TABLE for join 3
tt_final3 TYPE STANDARD TABLE OF ty_final,
*Intermediate Output Internal TABLE for join 4
tt_final4 TYPE STANDARD TABLE OF ty_final,
tt_t001 TYPE STANDARD TABLE OF ty_t001,
tt_tcurt TYPE STANDARD TABLE OF ty_tcurt,
tt_faglflext TYPE STANDARD TABLE OF ty_faglflext,
tt_t000 TYPE STANDARD TABLE OF ty_t000,
tt_t005 TYPE STANDARD TABLE OF ty_t005,
***********************
*Variable Declarations
***********************
lv_flag TYPE char1,
c1_butxt
 TYPE string,
c2_fikrs
 TYPE string,
c3_waers
 TYPE string,
c4_ktopl
 TYPE string,
c5_ltext
 TYPE string,
c6_rbukrs
 TYPE string,
c7_rbusa
 TYPE string,
c8_rfarea
 TYPE string,
c9_segment
 TYPE string,
c10_prctr
 TYPE string,
c11_rassc
 TYPE string,
c12_ryear
 TYPE string,
c13_sbusa
 TYPE string,
c14_sfarea
 TYPE string,
c15_pprctr
 TYPE string,
c16_rpmax
 TYPE string,
c17_racct
 TYPE string,
c18_rvers
 TYPE string,
c19_rldnr
 TYPE string,
c20_logsys
 TYPE string,
c21_cost_elem
 TYPE string,
c22_rcntr
 TYPE string,
c23_kokrs
 TYPE string,
c24_hsl01
 TYPE string,
c25_hsl02
 TYPE string,
c26_hsl03
 TYPE string,
c27_hsl04
 TYPE string,
c28_hsl05
 TYPE string,
c29_hsl06
 TYPE string,
c30_hsl07
 TYPE string,
c31_hsl08
 TYPE string,
c32_hsl09
 TYPE string,
c33_hsl10
 TYPE string,
c34_hsl11
 TYPE string,
c35_hsl12
 TYPE string,
c36_hsl13
 TYPE string,
c37_hsl14
 TYPE string,
c38_hsl15
 TYPE string,
c39_hsl16
 TYPE string,
c40_drcrk
 TYPE string,
c41_hslvt
 TYPE string,
c42_tslvt
 TYPE string,
c43_kslvt
 TYPE string,
c44_rtcur
 TYPE string,
c45_tsl05
 TYPE string,
c46_tsl01
 TYPE string,
c47_tsl06
 TYPE string,
c48_tsl02
 TYPE string,
c49_tsl04
 TYPE string,
c50_tsl03
 TYPE string,
c51_tsl07
 TYPE string,
c52_tsl12
 TYPE string,
c53_tsl08
 TYPE string,
c54_tsl11
 TYPE string,
c55_tsl09
 TYPE string,
c56_tsl10
 TYPE string,
c57_tsl13
 TYPE string,
c58_tsl16
 TYPE string,
c59_tsl14
 TYPE string,
c60_tsl15
 TYPE string,
c61_rrcty
 TYPE string,
c62_ksl11
 TYPE string,
c63_ksl02
 TYPE string,
c64_ksl10
 TYPE string,
c65_ksl15
 TYPE string,
c66_ksl07
 TYPE string,
c67_ksl09
 TYPE string,
c68_ksl03
 TYPE string,
c69_ksl08
 TYPE string,
c70_ksl14
 TYPE string,
c71_ksl04
 TYPE string,
c72_ksl05
 TYPE string,
c73_ksl01
 TYPE string,
c74_ksl12
 TYPE string,
c75_ksl13
 TYPE string,
c76_ksl06
 TYPE string,
c77_ksl16
 TYPE string,
c78_rclnt
 TYPE string,
c79_mwaer
 TYPE string,
c80_objnr00
 TYPE string,
c81_objnr01
 TYPE string,
c82_objnr02
 TYPE string,
c83_objnr03
 TYPE string,
c84_objnr04
 TYPE string,
c85_objnr05
 TYPE string,
c86_objnr06
 TYPE string,
c87_objnr07
 TYPE string,
c88_objnr08
 TYPE string,
c89_activ
 TYPE string,
c90_rmvct
 TYPE string,
c91_runit
 TYPE string,
c92_awtyp
 TYPE string,
c93_scntr
 TYPE string,
c94_psegment
 TYPE string,
c95_oslvt
 TYPE string,
c96_osl01
 TYPE string,
c97_osl02
 TYPE string,
c98_osl03
 TYPE string,
c99_osl04
 TYPE string,
c100_osl05
 TYPE string,
c101_osl06
 TYPE string,
c102_osl07
 TYPE string,
c103_osl08
 TYPE string,
c104_osl09
 TYPE string,
c105_osl10
 TYPE string,
c106_osl11
 TYPE string,
c107_osl12
 TYPE string,
c108_osl13
 TYPE string,
c109_osl14
 TYPE string,
c110_osl15
 TYPE string,
c111_osl16
 TYPE string,
c112_mslvt
 TYPE string,
c113_msl01
 TYPE string,
c114_msl02
 TYPE string,
c115_msl03
 TYPE string,
c116_msl04
 TYPE string,
c117_msl05
 TYPE string,
c118_msl06
 TYPE string,
c119_msl07
 TYPE string,
c120_msl08
 TYPE string,
c121_msl09
 TYPE string,
c122_msl10
 TYPE string,
c123_msl11
 TYPE string,
c124_msl12
 TYPE string,
c125_msl13
 TYPE string,
c126_msl14
 TYPE string,
c127_msl15
 TYPE string,
c128_msl16
 TYPE string,
c129_timestamp
 TYPE string,
c130_curin
 TYPE string,
c131_curha
 TYPE string,
c132_waers
 TYPE string,
lv_delimiter TYPE string,
lv_tabix_frm TYPE sy-tabix,
lv_path TYPE string,
lv_file TYPE string,
lv_datum TYPE sy-datum,
lv_date  TYPE char10,
wa_result TYPE string,
lv_cnt TYPE sytabix.
*********************
*Cursor Declaration
*********************
DATA: lv_t001_dbcur  TYPE cursor.
DATA : et_file_return LIKE TABLE OF bapiret2 WITH HEADER LINE,
       return LIKE bapireturn.
