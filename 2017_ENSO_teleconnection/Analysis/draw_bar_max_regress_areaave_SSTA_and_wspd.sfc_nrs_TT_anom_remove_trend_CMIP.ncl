;*************************************************************
;Aim: Draw a bar chart of maximum contemporaneous regression between three-month means of area average of regional monthly sea surface temperature
;     and surface wind speed, surface radiative flux, as well as mean 1000-200-hPa tropospheric temperature anomalies removed trend in CMIP models in
;     winter and spring (visualized by being divided by intermodel standard deviation)
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2019-06-08
;
;*************************************************************

begin

;================================================
;Variables List:
;var1--------------sst
;var2--------------wspd
;var4--------------nlwrs
;var5--------------nswrs
;var6--------------air

;var7--------------ts
;var8--------------uas
;var9--------------vas
;var10-------------rlds
;var11-------------rlus
;var12-------------rsds
;var13-------------rsus
;var14-------------ta
;================================================

process = False

;data
;HadISST1 1870/01 - , 1x1
in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5/T62
in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"
in_name4 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
in_name5 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"
in_name6 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"

in_path7 = "~/data-model/CMIP5-hes/ts/historical/"
in_name7 = new(37, string)
in_name7(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
; in_name7(3) = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
; in_name7(4) = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
; in_name7(3) = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
 in_name7(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(7) = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(8) = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(9) = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
in_name7(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
in_name7(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
in_name7(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
in_name7(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
in_name7(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name7(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name7(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;in_name7(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
in_name7(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
in_name7(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
in_name7(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
in_name7(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
in_name7(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
in_name7(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
nmod = dimsizes(in_name7)

in_path8 = "~/data-model/CMIP5-hes/uas/historical/"
in_name8 = new(nmod, string)
in_name8(0) = "uas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(1) = "uas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(2) = "uas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name8(3) = "uas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name8(4) = "uas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(3) = "uas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(4) = "uas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(5) = "uas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(6) = "uas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(7) = "uas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(8) = "uas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(9) = "uas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(10) = "uas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(11) = "uas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name8(12) = "uas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
in_name8(13) = "uas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name8(14) = "uas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name8(15) = "uas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(16) = "uas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name8(17) = "uas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(18) = "uas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name8(19) = "uas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;in_name8(20) = "uas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
in_name8(20) = "uas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name8(21) = "uas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name8(22) = "uas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(23) = "uas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(24) = "uas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(25) = "uas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(26) = "uas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name8(27) = "uas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name8(28) = "uas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(29) = "uas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(30) = "uas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(31) = "uas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(32) = "uas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(33) = "uas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(34) = "uas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name8(35) = "uas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name8(36) = "uas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

in_name9 = new(nmod, string)
in_path9 = "~/data-model/CMIP5-hes/vas/historical/"
in_name9(0) = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(1) = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(2) = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name9(3) = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name9(4) = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(3) = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(4) = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(5) = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(6) = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(7) = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(8) = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(9) = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(10) = "vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(11) = "vas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name9(12) = "vas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
in_name9(13) = "vas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name9(14) = "vas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name9(15) = "vas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(16) = "vas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name9(17) = "vas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(18) = "vas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name9(19) = "vas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;in_name9(20) = "vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
in_name9(20) = "vas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name9(21) = "vas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name9(22) = "vas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(23) = "vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(24) = "vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(25) = "vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(26) = "vas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name9(27) = "vas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name9(28) = "vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(29) = "vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(30) = "vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(31) = "vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(32) = "vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(33) = "vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(34) = "vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name9(35) = "vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name9(36) = "vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

in_path10 = "~/data-model/CMIP5-hes/rlds/historical/"
in_name10 = new(nmod, string)
in_name10(0) = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
in_name10(1) = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
in_name10(2) = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;in_name10(3) = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
in_name10(3) = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;in_name10(4) = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;in_name10(5) = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
in_name10(4) = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
in_name10(5) = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
in_name10(6) = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
in_name10(7) = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
in_name10(8) = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
in_name10(9) = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;in_name10(10) = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
in_name10(10) = "rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
in_name10(11) = "rlds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
in_name10(12) = "rlds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
in_name10(13) = "rlds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
in_name10(14) = "rlds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
in_name10(15) = "rlds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
in_name10(16) = "rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name10(17) = "rlds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
in_name10(18) = "rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name10(19) = "rlds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
in_name10(20) = "rlds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
in_name10(21) = "rlds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
in_name10(22) = "rlds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
in_name10(23) = "rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name10(24) = "rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name10(25) = "rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name10(26) = "rlds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
in_name10(27) = "rlds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
in_name10(28) = "rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
in_name10(29) = "rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
in_name10(30) = "rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name10(31) = "rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name10(32) = "rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
in_name10(33) = "rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
in_name10(34) = "rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
in_name10(35) = "rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
in_name10(36) = "rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

in_path11 = "~/data-model/CMIP5-hes/rlus/historical/"
in_name11 = new(nmod, string)
in_name11(0) = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
in_name11(1) = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
in_name11(2) = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;in_name11(3) = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
in_name11(3) = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;in_name11(4) = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;in_name11(5) = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
in_name11(4) = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
in_name11(5) = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
in_name11(6) = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
in_name11(7) = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
in_name11(8) = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
in_name11(9) = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;in_name11(10) = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
in_name11(10) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
in_name11(11) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
in_name11(12) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
in_name11(13) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
in_name11(14) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
in_name11(15) = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
in_name11(16) = "rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name11(17) = "rlus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
in_name11(18) = "rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name11(19) = "rlus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
in_name11(20) = "rlus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
in_name11(21) = "rlus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
in_name11(22) = "rlus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
in_name11(23) = "rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name11(24) = "rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name11(25) = "rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name11(26) = "rlus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
in_name11(27) = "rlus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
in_name11(28) = "rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
in_name11(29) = "rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
in_name11(30) = "rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name11(31) = "rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name11(32) = "rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
in_name11(33) = "rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
in_name11(34) = "rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
in_name11(35) = "rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
in_name11(36) = "rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

in_path12 = "~/data-model/CMIP5-hes/rsds/historical/"
in_name12 = new(nmod, string)
in_name12(0) = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
in_name12(1) = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
in_name12(2) = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;in_name12(3) = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
in_name12(3) = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;in_name12(4) = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;in_name12(5) = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
in_name12(4) = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
in_name12(5) = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
in_name12(6) = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
in_name12(7) = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
in_name12(8) = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
in_name12(9) = "rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;in_name12(10) = "rsds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
in_name12(10) = "rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
in_name12(11) = "rsds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
in_name12(12) = "rsds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
in_name12(13) = "rsds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
in_name12(14) = "rsds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
in_name12(15) = "rsds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
in_name12(16) = "rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name12(17) = "rsds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
in_name12(18) = "rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name12(19) = "rsds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
in_name12(20) = "rsds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
in_name12(21) = "rsds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
in_name12(22) = "rsds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
in_name12(23) = "rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name12(24) = "rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name12(25) = "rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name12(26) = "rsds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
in_name12(27) = "rsds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
in_name12(28) = "rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
in_name12(29) = "rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
in_name12(30) = "rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name12(31) = "rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name12(32) = "rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
in_name12(33) = "rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
in_name12(34) = "rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
in_name12(35) = "rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
in_name12(36) = "rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

in_path13 = "~/data-model/CMIP5-hes/rsus/historical/"
in_name13 = new(nmod, string)
in_name13(0) = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
in_name13(1) = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
in_name13(2) = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;in_name13(3) = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
in_name13(3) = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;in_name13(4) = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;in_name13(5) = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
in_name13(4) = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
in_name13(5) = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
in_name13(6) = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
in_name13(7) = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
in_name13(8) = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
in_name13(9) = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;in_name13(10) = "rsus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
in_name13(10) = "rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
in_name13(11) = "rsus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
in_name13(12) = "rsus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
in_name13(13) = "rsus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
in_name13(14) = "rsus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
in_name13(15) = "rsus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
in_name13(16) = "rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name13(17) = "rsus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
in_name13(18) = "rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name13(19) = "rsus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
in_name13(20) = "rsus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
in_name13(21) = "rsus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
in_name13(22) = "rsus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
in_name13(23) = "rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name13(24) = "rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name13(25) = "rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name13(26) = "rsus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
in_name13(27) = "rsus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
in_name13(28) = "rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
in_name13(29) = "rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
in_name13(30) = "rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name13(31) = "rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name13(32) = "rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
in_name13(33) = "rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
in_name13(34) = "rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
in_name13(35) = "rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
in_name13(36) = "rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

in_path14 = "~/data-model/CMIP5-hes/ta/historical/"
in_name14 = new(nmod, string)
in_name14(0) = "ta_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(1) = "ta_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(2) = "ta_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name14(2) = "ta_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;in_name14(3) = "ta_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(3) = "ta_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
in_name14(3) = "ta_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(6) = "ta_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(7) = "ta_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(8) = "ta_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(9) = "ta_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(10) = "ta_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(4) = "ta_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(5) = "ta_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(6) = "ta_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(7) = "ta_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name14(8) = "ta_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(9) = "ta_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(10) = "ta_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
in_name14(10) = "ta_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;in_name14(18) = "ta_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(11) = "ta_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name14(12) = "ta_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
in_name14(13) = "ta_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name14(14) = "ta_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name14(15) = "ta_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(16) = "ta_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name14(17) = "ta_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(18) = "ta_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name14(19) = "ta_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;in_name14(28) = "ta_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
in_name14(20) = "ta_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name14(21) = "ta_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name14(22) = "ta_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(23) = "ta_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(24) = "ta_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(25) = "ta_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(26) = "ta_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name14(27) = "ta_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name14(28) = "ta_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(29) = "ta_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(30) = "ta_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(31) = "ta_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(32) = "ta_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(33) = "ta_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(34) = "ta_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name14(35) = "ta_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name14(36) = "ta_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
yS = 1958
yE = 2004
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ"/)
maxlag = dimsizes(season)

;fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./bar_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"
out_name = "bar_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP"

;text
text1 = (/"b) ~F10~U~B~Surf","c) ~F10~F~B~Rad","a) ~F10~T~B~Trop"/)
;text2 = "max/min[~F14~R~B~X~F18~o~F33~D~F~SSTA~N~(~F8~t~F~)]"
text2 = "~F33~D~F~SST responses to atmospheric variables"
text3 = (/"[10~S~-1~N~ ~F35~J~F~C/(m~F34~W~F~s~S~-1~N~)]","[10~S~-2~N~ ~F35~J~F~C/(w~F34~W~F~m~S~-2~N~)]","(10~S~-1~N~ ~F35~J~F~C/~F35~J~F~C)","Data set"/)
;text4 = (/"~F33~a","~F33~b","~F33~g","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
text4 = (/"~F33~a","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
          "J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)
text5 = (/"2.5% "," 97.5%","TIO","TNA"/)

colors = (/"lightpink","red","cyan","blue"/)

if(process)then

;tropical Indian Ocean
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;tropical Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305
    lonE2 = 345

;arguments required by vertical mean
    pnew = (/1000,925,850,700,600,500,400,300,250,200/)
    pver = pnew * 100
    pver@units = "Pa"
    dp = dpres_plevel_Wrap(pver, 100000, 20000, 0)
    sumdp = sum(dp)
    print((/dp/))

    a = 1.0 - 0.4 / 2.0
    CI = new((/2,3,3,2/), float)

    x12 = new((/2,maxlag/), float)
    x13 = new((/2,maxlag/), float)
    x14 = new((/2,maxlag/), float)
    r = new((/2,3,nmod+3,3/), float)
    r!0 = "region"
    r!1 = "variable"
    r!2 = "model"
    r!3 = "value"
    ndim = dimsizes(r)

    do i = 0, nmod-1
        print(i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
        in7 = addfile(in_path7 + in_name7(i), "r")
        in8 = addfile(in_path8 + in_name8(i), "r")
        in9 = addfile(in_path9 + in_name9(i), "r")
        in10 = addfile(in_path10 + in_name10(i), "r")
        in11 = addfile(in_path11 + in_name11(i), "r")
        in12 = addfile(in_path12 + in_name12(i), "r")
        in13 = addfile(in_path13 + in_name13(i), "r")
        in14 = addfile(in_path14 + in_name14(i), "r")

;get the time indexs
        time7 = in7->time
        time8 = in8->time
        time10 = in10->time
        time14 = in14->time
        year7 = cd_calendar(time7, -1) / 100
        year8 = cd_calendar(time8, -1) / 100
        year10 = cd_calendar(time10, -1) / 100
        year14 = cd_calendar(time14, -1) / 100
        iYYYY7 = ind(year7.ge.yS .and. year7.le.yE)
        iYYYY8 = ind(year8.ge.yS .and. year8.le.yE)
        iYYYY10 = ind(year10.ge.yS .and. year10.le.yE)
        iYYYY14 = ind(year14.ge.yS .and. year14.le.yE)

        ts = in7->ts(iYYYY7,:,:)
        uas = in8->uas(iYYYY8,:,:)
        vas = in9->vas(iYYYY8,:,:)
        uas = wind_speed (uas,vas)
        rlds = in10->rlds(iYYYY10,:,:)
        rlus = in11->rlus(iYYYY10,:,:)
        rsds = in12->rsds(iYYYY10,:,:)
        rsus = in13->rsus(iYYYY10,:,:)
        rsus = rlus + rsus - rlds - rsds
        if(i.eq.12)then
            ta = in14->ta(iYYYY14,(/0,1,2,4,5,6,7,8,9,10/),:,:)
        else
            ta = in14->ta(iYYYY14,{:20000},:,:)
        end if

        if(i.eq.0)then
            in1a = addfile(in_name1a, "r")
            in1b = addfile(in_name1b, "r")
            in1c = addfile(in_name1c, "r")
            in2 = addfile(in_name2, "r")
            in4 = addfile(in_name4, "r")
            in5 = addfile(in_name5, "r")
            in6 = addfile(in_name6, "r")
            time1a = in1a->time
            time1b = in1b->time
            time1c = in1c->time
            time2 = in2->time
            lat1 = in1a->lat
            lat2 = in2->lat
            lat4 = in4->lat
            year1a = cd_calendar(time1a, -1) / 100
            year1b = cd_calendar(time1b, -1) / 100
            year1c = cd_calendar(time1c, -1) / 100
            year2 = cd_calendar(time2, -1) / 100
            iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
            iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
            iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
            iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
;            sst1 = lonFlip(in1->sst(iYYYY1,{latN:latS},:))
            sst1 = in1a->sst(iYYYY1a,:,:)
            sst2 = in1b->sst(iYYYY1b,:,:)
            sst3 = in1c->sst(iYYYY1c,:,:)
            wspd  = in2->wspd(iYYYY2,:,:)
            nlwrs = in4->nlwrs(iYYYY2,:,:)
            nswrs = in5->nswrs(iYYYY2,:,:)
            nlwrs = nlwrs+nswrs
            air = in6->air(iYYYY2,{:200},:,:)
;            sst1 = short2flt(in3->sst(iYYYY3,{latN:latS},:))
            printVarSummary(wspd)
            printVarSummary(nlwrs)
            printVarSummary(air)

;-------------------------------------------------------------
;creat weights: cos(lat)
            rad = 4.0 * atan(1.0) / 180.0
;            gw  = in1->latitude({latN:latS})
            gw1 = cos(rad * lat1)
            gw2 = cos(rad * lat2)
            gw4 = cos(rad * lat4)
            copy_VarCoords(lat1, gw1)
            copy_VarCoords(lat2, gw2)
            copy_VarCoords(lat4, gw4)
        end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

        dts = center_finite_diff_n(ts, 1, False, 0, 0)
        copy_VarMeta(ts, dts)

;calculate the vertical mean
        if(i.eq.0)then
            dp_cfm = conform_dims(dimsizes(ta), dp, 1)
        end if
        TT2 = (/dim_sum_n(dp_cfm * ta / sumdp, 1)/)
        if(i.eq.0)then
            copy_VarMeta(ta(:,0,:,:), TT2)
        end if

;monthly anomalies
        clm8d = clmMonTLL(dts)
        clm9 = clmMonTLL(uas)
        clm14 = clmMonTLL(rsus)
        clm15 = clmMonTLL(TT2)
        tsA = calcMonAnomTLL(dts, clm8d)
        uasA = calcMonAnomTLL(uas, clm9)
        rsusA = calcMonAnomTLL(rsus, clm14)
        TTA2 = calcMonAnomTLL (TT2, clm15)
        tsA = (/dtrend_msg_n(tsA&time, tsA, False, False, 0)/)
        uasA = (/dtrend_msg_n(uasA&time, uasA, False, False, 0)/)
        rsusA = (/dtrend_msg_n(rsusA&time, rsusA, False, False, 0)/)
        TTA2 = (/dtrend_msg_n(TTA2&time, TTA2, False, False, 0)/)

        tsA_3M = month_to_seasonN(tsA, season)
        uasA_3M = month_to_seasonN(uasA, season)
        rsusA_3M = month_to_seasonN(rsusA, season)
        TTA2_3M = month_to_seasonN(TTA2, season)

;--------------------------------------------------------------
;tropical Indian Ocean
        ts_TIO = wgt_areaave_Wrap(tsA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
        uas_TIO = wgt_areaave_Wrap(uasA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
        rsus_TIO = wgt_areaave_Wrap(rsusA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1.0, 0)
        TT2_TIO = wgt_areaave_Wrap(TTA2_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        ts_TNA = wgt_areaave_Wrap(tsA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
        uas_TNA = wgt_areaave_Wrap(uasA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
        rsus_TNA = wgt_areaave_Wrap(rsusA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1.0, 0)
        TT2_TNA = wgt_areaave_Wrap(TTA2_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
        x12(0,:) = (/regCoef(uas_TIO, ts_TIO)/)
        x13(0,:) = (/regCoef(rsus_TIO, ts_TIO)/)
        x14(0,:) = (/regCoef(TT2_TIO, ts_TIO)/)
        x12(1,:) = (/regCoef(uas_TNA, ts_TNA)/)
        x13(1,:) = (/regCoef(rsus_TNA, ts_TNA)/)
        x14(1,:) = (/regCoef(TT2_TNA, ts_TNA)/)

        inds = (/minind(x12(0,:))/)
        rc = regline_stats(uas_TIO(inds,:), ts_TIO(inds,:))
        r(0,0,i+3,0) = (/rc/)
        r(0,0,i+3,1:) = (/rc@b95/)
        inds = (/minind(x12(1,:))/)
        rc = regline_stats(uas_TNA(inds,:), ts_TNA(inds,:))
        r(1,0,i+3,0) = (/rc/)
        r(1,0,i+3,1:) = (/rc@b95/)
        inds = (/minind(x13(0,:))/)
        rc = regline_stats(rsus_TIO(inds,:), ts_TIO(inds,:))
        r(0,1,i+3,0) = (/rc/)
        r(0,1,i+3,1:) = (/rc@b95/)
        inds = (/minind(x13(1,:))/)
        rc = regline_stats(rsus_TNA(inds,:), ts_TNA(inds,:))
        r(1,1,i+3,0) = (/rc/)
        r(1,1,i+3,1:) = (/rc@b95/)
        inds = (/maxind(x14(0,:))/)
        rc = regline_stats(TT2_TIO(inds,:), ts_TIO(inds,:))
        r(0,2,i+3,0) = (/rc/)
        r(0,2,i+3,1:) = (/rc@b95/)
        inds = (/maxind(x14(1,:))/)
        rc = regline_stats(TT2_TNA(inds,:), ts_TNA(inds,:))
        r(1,2,i+3,0) = (/rc/)
        r(1,2,i+3,1:) = (/rc@b95/)

        if(i.eq.0)then
            dsst1 = center_finite_diff_n(sst1, 1, False, 0, 0)
            dsst2 = center_finite_diff_n(sst2, 1, False, 0, 0)
            dsst3 = center_finite_diff_n(sst3, 1, False, 0, 0)
            copy_VarMeta(sst1, dsst1)
            copy_VarMeta(sst2, dsst2)
            copy_VarMeta(sst3, dsst3)
            TT1 = dim_sum_n(dp_cfm * air / sumdp, 1)
            copy_VarMeta(air(:,0,:,:), TT1)
            clm1a = clmMonTLL(dsst1)
            clm1b = clmMonTLL(dsst2)
            clm1c = clmMonTLL(dsst3)
            clm2 = clmMonTLL(wspd)
            clm4 = clmMonTLL(nlwrs)
            clm6 = clmMonTLL(TT1)
            sstA1 = calcMonAnomTLL(dsst1, clm1a)
            sstA2 = calcMonAnomTLL(dsst2, clm1b)
            sstA3 = calcMonAnomTLL(dsst3, clm1c)
            wspdA = calcMonAnomTLL(wspd, clm2)
            nlwrsA = calcMonAnomTLL(nlwrs, clm4)
            TTA1 = calcMonAnomTLL(TT1, clm6)
            sstA1 = (/dtrend_msg_n(sstA1&time, sstA1, False, False, 0)/)
            sstA2 = (/dtrend_msg_n(sstA2&time, sstA2, False, False, 0)/)
            sstA3 = (/dtrend_msg_n(sstA3&time, sstA3, False, False, 0)/)
            wspdA = (/dtrend_msg_n(wspdA&time, wspdA, False, False, 0)/)
            nlwrsA = (/dtrend_msg_n(nlwrsA&time, nlwrsA, False, False, 0)/)
            TTA1 = (/dtrend_msg_n(TTA1&time, TTA1, False, False, 0)/)
            sstA1_3M = month_to_seasonN(sstA1, season)
            sstA2_3M = month_to_seasonN(sstA2, season)
            sstA3_3M = month_to_seasonN(sstA3, season)
            wspdA_3M = month_to_seasonN(wspdA, season)
            nlwrsA_3M = month_to_seasonN(nlwrsA, season)
            TTA1_3M = month_to_seasonN(TTA1, season)

            sst1_TIO = wgt_areaave_Wrap(sstA1_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            sst2_TIO = wgt_areaave_Wrap(sstA2_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            sst3_TIO = wgt_areaave_Wrap(sstA3_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            wspd_TIO = wgt_areaave_Wrap(wspdA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            nlwrs_TIO = wgt_areaave_Wrap(nlwrsA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1.0, 0)
            TT1_TIO = wgt_areaave_Wrap(TTA1_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            sst1_TNA = wgt_areaave_Wrap(sstA1_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            sst2_TNA = wgt_areaave_Wrap(sstA2_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            sst3_TNA = wgt_areaave_Wrap(sstA3_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            wspd_TNA = wgt_areaave_Wrap(wspdA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
            nlwrs_TNA = wgt_areaave_Wrap(nlwrsA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1.0, 0)
            TT1_TNA = wgt_areaave_Wrap(TTA1_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
    
            x12(0,:) = (/regCoef(wspd_TIO, sst1_TIO)/)
            x13(0,:) = (/regCoef(nlwrs_TIO, sst1_TIO)/)
            x14(0,:) = (/regCoef(TT1_TIO, sst1_TIO)/)
            x12(1,:) = (/regCoef(wspd_TNA, sst1_TNA)/)
            x13(1,:) = (/regCoef(nlwrs_TNA, sst1_TNA)/)
            x14(1,:) = (/regCoef(TT1_TNA, sst1_TNA)/)
            inds = (/minind(x12(0,:))/)
            rc = regline_stats(wspd_TIO(inds,:), sst1_TIO(inds,:))
            r(0,0,0,0) = (/rc/)
            r(0,0,0,1:) = (/rc@b95/)
            CI(0,0,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,0,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x12(1,:))/)
            rc = regline_stats(wspd_TNA(inds,:), sst1_TNA(inds,:))
            r(1,0,0,0) = (/rc/)
            r(1,0,0,1:) = (/rc@b95/)
            CI(1,0,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,0,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(0,:))/)
            rc = regline_stats(nlwrs_TIO(inds,:), sst1_TIO(inds,:))
            r(0,1,0,0) = (/rc/)
            r(0,1,0,1:) = (/rc@b95/)
            CI(0,1,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,1,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(1,:))/)
            rc = regline_stats(nlwrs_TNA(inds,:), sst1_TNA(inds,:))
            r(1,1,0,0) = (/rc/)
            r(1,1,0,1:) = (/rc@b95/)
            CI(1,1,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,1,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(0,:))/)
            rc = regline_stats(TT1_TIO(inds,:), sst1_TIO(inds,:))
            r(0,2,0,0) = (/rc/)
            r(0,2,0,1:) = (/rc@b95/)
            CI(0,2,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,2,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(1,:))/)
            rc = regline_stats(TT1_TNA(inds,:), sst1_TNA(inds,:))
            r(1,2,0,0) = (/rc/)
            r(1,2,0,1:) = (/rc@b95/)
            CI(1,2,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,2,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            x12(0,:) = (/regCoef(wspd_TIO, sst2_TIO)/)
            x13(0,:) = (/regCoef(nlwrs_TIO, sst2_TIO)/)
            x14(0,:) = (/regCoef(TT1_TIO, sst2_TIO)/)
            x12(1,:) = (/regCoef(wspd_TNA, sst2_TNA)/)
            x13(1,:) = (/regCoef(nlwrs_TNA, sst2_TNA)/)
            x14(1,:) = (/regCoef(TT1_TNA, sst2_TNA)/)
            inds = (/minind(x12(0,:))/)
            rc = regline_stats(wspd_TIO(inds,:), sst2_TIO(inds,:))
            r(0,0,1,0) = (/rc/)
            r(0,0,1,1:) = (/rc@b95/)
            CI(0,0,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,0,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x12(1,:))/)
            rc = regline_stats(wspd_TNA(inds,:), sst2_TNA(inds,:))
            r(1,0,1,0) = (/rc/)
            r(1,0,1,1:) = (/rc@b95/)
            CI(1,0,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,0,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(0,:))/)
            rc = regline_stats(nlwrs_TIO(inds,:), sst2_TIO(inds,:))
            r(0,1,1,0) = (/rc/)
            r(0,1,1,1:) = (/rc@b95/)
            CI(0,1,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,1,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(1,:))/)
            rc = regline_stats(nlwrs_TNA(inds,:), sst2_TNA(inds,:))
            r(1,1,1,0) = (/rc/)
            r(1,1,1,1:) = (/rc@b95/)
            CI(1,1,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,1,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(0,:))/)
            rc = regline_stats(TT1_TIO(inds,:), sst2_TIO(inds,:))
            r(0,2,1,0) = (/rc/)
            r(0,2,1,1:) = (/rc@b95/)
            CI(0,2,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,2,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(1,:))/)
            rc = regline_stats(TT1_TNA(inds,:), sst2_TNA(inds,:))
            r(1,2,1,0) = (/rc/)
            r(1,2,1,1:) = (/rc@b95/)
            CI(1,2,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,2,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            x12(0,:) = (/regCoef(wspd_TIO, sst3_TIO)/)
            x13(0,:) = (/regCoef(nlwrs_TIO, sst3_TIO)/)
            x14(0,:) = (/regCoef(TT1_TIO, sst3_TIO)/)
            x12(1,:) = (/regCoef(wspd_TNA, sst3_TNA)/)
            x13(1,:) = (/regCoef(nlwrs_TNA, sst3_TNA)/)
            x14(1,:) = (/regCoef(TT1_TNA, sst3_TNA)/)
            inds = (/minind(x12(0,:))/)
            rc = regline_stats(wspd_TIO(inds,:), sst3_TIO(inds,:))
            r(0,0,2,0) = (/rc/)
            r(0,0,2,1:) = (/rc@b95/)
            CI(0,0,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,0,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x12(1,:))/)
            rc = regline_stats(wspd_TNA(inds,:), sst3_TNA(inds,:))
            r(1,0,2,0) = (/rc/)
            r(1,0,2,1:) = (/rc@b95/)
            CI(1,0,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,0,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(0,:))/)
            rc = regline_stats(nlwrs_TIO(inds,:), sst3_TIO(inds,:))
            r(0,1,2,0) = (/rc/)
            r(0,1,2,1:) = (/rc@b95/)
            CI(0,1,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,1,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/minind(x13(1,:))/)
            rc = regline_stats(nlwrs_TNA(inds,:), sst3_TNA(inds,:))
            r(1,1,2,0) = (/rc/)
            r(1,1,2,1:) = (/rc@b95/)
            CI(1,1,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,1,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(0,:))/)
            rc = regline_stats(TT1_TIO(inds,:), sst3_TIO(inds,:))
            r(0,2,2,0) = (/rc/)
            r(0,2,2,1:) = (/rc@b95/)
            CI(0,2,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,2,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            inds = (/maxind(x14(1,:))/)
            rc = regline_stats(TT1_TNA(inds,:), sst3_TNA(inds,:))
            r(1,2,2,0) = (/rc/)
            r(1,2,2,1:) = (/rc@b95/)
            CI(1,2,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,2,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            
            do x = 0, 1
                do y = 0, 2
                    print((/r(x,y,:2,0)/))
                    print((/CI(x,y,:,:)/))
                end do
            end do
        end if

        delete([/time7,time8,time10,time14,year7,year8,year10,year14/])

    end do

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","variable","model","value"/)
    dimSizes = ndim
    dimUnlim = (/False,False,False,False/)

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "variable", "integer", "variable")
    filevardef(fout, "model", "integer", "model")
    filevardef(fout, "value", "integer", "value")
    filevardef(fout, "r", typeof(r), getvardims(r))

;Copy attributes associated with each variable to the file
;    filevarattdef(fout, "std", std)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->variable = ispan(1, 3, 1)
    fout->model = ispan(1, nmod+3, 1)
    fout->value = ispan(1, 3, 1)
    fout->r = (/r/)

else

    in = addfile(out_data, "r")
    r = in->r

end if

printVarSummary(r)
print((/r(0,2,:,:)/))
r(:,0,:,:) = (/10.0 * r(:,0,:,:)/)
r(:,1,:,:) = (/100.0 * r(:,1,:,:)/)
r(:,2,:,:) = (/10.0 * r(:,2,:,:)/)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(3, graphic)
dum = new ((/2,3,3/),graphic)

;*******************************************
; plot
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = .018
res@gsnXYBarChart = True
res@gsnXYBarChartBarWidth = 0.35
res@gsnYRefLineColor = "transparent"

res@vpWidthF = 0.8
res@vpHeightF = 0.2

res@trXMaxF = nmod+1
res@trXMinF = -1

res@tiXAxisFontHeightF = .023

res@tmXTOn = False
res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0, nmod+0, 1)
res@tmXBLabels = text4
res@tmXBLabelJust = "CenterCenter"
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.018
res@tmXBMajorLengthF = 0.008
res@tmXBMajorOutwardLengthF = 0.008

min_plot = new((/2,3,nmod+1/), graphic)
max_plot = new((/2,3,nmod+1/), graphic)

r(:,:,1:nmod,:) = (/r(:,:,3:nmod+2,:)/)

do i = 0, nmod+0
    do j = 0,2
        if(j.eq.0)then
            res@trYMaxF = 0.4
            res@trYMinF = -5.4
        else if(j.eq.1)then
            res@trYMaxF = 1.5
            res@trYMinF = -7.0
        else
            res@trYMaxF = 3.6
            res@trYMinF = -1.2
        end if
        end if
        res@gsnYRefLine = r(0,j,i,0)
        res@gsnAboveYRefLineColor = colors(0)
        res@gsnBelowYRefLineColor = colors(1)
        res@tiYAxisString = text3(j)
        res@tiXAxisString = text3(3)
        if(i.eq.0)then
            res@gsnLeftString = text1(j)
            if(j.eq.2)then
                res@gsnCenterString = text2
            end if
            plot(j) = gsn_csm_xy(wks, i-0.175, r(0,j,i,1), res)
            delete(res@gsnLeftString)
            delete(res@gsnCenterString)
            max_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, r(0,j,i,2), res)
            overlay(plot(j), max_plot(0,j,i))
        else
            min_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, r(0,j,i,1), res)
            max_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, r(0,j,i,2), res)
            overlay(plot(j), min_plot(0,j,i))
            overlay(plot(j), max_plot(0,j,i))
        end if
        res@gsnYRefLine = r(1,j,i,0)
        res@gsnAboveYRefLineColor = colors(2)
        res@gsnBelowYRefLineColor = colors(3)
        min_plot(1,j,i) = gsn_csm_xy(wks, i+0.175, r(1,j,i,1), res)
        max_plot(1,j,i) = gsn_csm_xy(wks, i+0.175, r(1,j,i,2), res)
        overlay(plot(j), min_plot(1,j,i))
        overlay(plot(j), max_plot(1,j,i))
    end do
end do

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2
resl@gsLineColor = colors(1)
do i = 0, 2
    dum(0,0,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(0,i,0,0),r(0,i,0,0)/), resl)
    dum(0,1,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(0,i,0,1),r(0,i,0,1)/), resl)
    dum(0,2,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(0,i,0,2),r(0,i,0,2)/), resl)
end do
resl@gsLineDashPattern = 5
resl@gsLineColor = colors(3)
do i = 0, 2
    dum(1,0,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(1,i,0,0),r(1,i,0,0)/), resl)
    dum(1,1,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(1,i,0,1),r(1,i,0,1)/), resl)
    dum(1,2,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/r(1,i,0,2),r(1,i,0,2)/), resl)
end do

;--------------------------------------------------------------
;Manually creating a legend
xbox = (/0.34,0.4,0.4,0.34,0.34/)
ybox = (/0.06,0.06,0.08,0.08,0.06/)

txres = True
gsres = True
txres@txFontHeightF = 0.015

gsres@gsFillColor = colors(1)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = min(xbox)
ypos = (max(ybox) + min(ybox)) / 2.0
txres@txJust = "CenterRight"
gsn_text_ndc(wks, text5(0), xpos, ypos, txres)

xbox = xbox + 0.06
gsres@gsFillColor = colors(0)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = max(xbox)
txres@txJust = "CenterLeft"
gsn_text_ndc(wks, text5(1), xpos, ypos, txres)

xpos = min(xbox)
ypos = min(ybox)
txres@txJust = "TopCenter"
gsn_text_ndc(wks, text5(2), xpos, ypos, txres)

;--------------------------------------------------------------
xbox = xbox + 0.24
gsres@gsFillColor = colors(3)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = min(xbox)
ypos = (max(ybox) + min(ybox)) / 2.0
txres@txJust = "CenterRight"
gsn_text_ndc(wks, text5(0), xpos, ypos, txres)

xbox = xbox + 0.06
gsres@gsFillColor = colors(2)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = max(xbox)
txres@txJust = "CenterLeft"
gsn_text_ndc(wks, text5(1), xpos, ypos, txres)

xpos = min(xbox)
ypos = min(ybox)
txres@txJust = "TopCenter"
gsn_text_ndc(wks, text5(3), xpos, ypos, txres)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString = "Max Regression of ~F33~D~F~SSTA onto Parameters"
resP@txFontHeightF  = 0.025
resP@gsnPanelBottom = 0.1

gsn_panel(wks,plot((/2,0,1/)),(/3,1/),resP)

end
