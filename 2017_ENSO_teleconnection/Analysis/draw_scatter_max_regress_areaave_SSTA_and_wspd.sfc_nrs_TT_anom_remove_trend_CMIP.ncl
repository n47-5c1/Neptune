;*************************************************************
;Aim: Draw a scatter plot of maximum contemporaneous regression between three-month means of area average of regional monthly sea surface temperature
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
;                       2018-04-19
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
;in_name3?
in_name4a = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
in_name5a = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"
in_name6 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"
;ERA5 1979/01 - 2018/12, 0.25x0.25
in_name4b = "~/data/observation/ERA5/mslhf.msnlwrf.msnswrf.msshf.1979-2018.mon.mean.nc"
;oaflux 1984/01 - 2008/12, 1x1
in_path = "~/data/observation/oaflux/"
in_name4c = "lw/lw_isccp_*.nc"
in_name5c = "sw/sw_isccp_*.nc"

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
;ySb = 1979
;yEb = 2016
;ySc = 1984
;yEc = 2008
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ"/)
maxlag = dimsizes(season)

;fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"
out_name = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP"

;text
text1 = "d)"
text2 = "max/min[~F14~R~B~X~F18~o~F33~D~F~SSTA~N~(~F8~t~F~)]"
text3 = (/"TNA","TIO"/)
text4 = (/"OBS","MMM"/)
text5 = (/"~F10~U~B~Surf","~F10~F~B~Rad","~F10~T~B~Trop"/)

x = (/0.24,0.24,0.24/)
y = (/0.76,0.72,0.68/)
colors = (/"red","blue","green"/)
sizes = (/0.022,0.022,0.022,0.018/)
indexes = (/4,8,7,0/)
thickness = (/3,3,3,1/)

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

    x12 = new((/2,3,maxlag/), float)
    x13 = new((/2,3,maxlag/), float)
    x14 = new((/2,3,maxlag/), float)
    r = new((/2,3,nmod+4/), float)
    r!0 = "region"
    r!1 = "variable"
    r!2 = "model"
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
            in4a = addfile(in_name4a, "r")
            in5a = addfile(in_name5a, "r")
/;
            in4b = addfile(in_name4b, "r")
            files4c = systemfunc("ls " + in_path + in_name4c)
            files5c = systemfunc("ls " + in_path + in_name5c)
            setfileoption("nc", "SuppressClose", False)   ;close too many files
            in4c = addfiles(files4c, "r")
            in5c = addfiles(files5c, "r")
            ListSetType(in4c, "cat")
            ListSetType(in5c, "cat")
;/
            in6 = addfile(in_name6, "r")
            time1a = in1a->time
            time1b = in1b->time
            time1c = in1c->time
            time2 = in2->time
;            time4b = in4b->time
            lat1 = in1a->lat
            lat2 = in2->lat
            lat4a = in4a->lat
;            lat4b = in4b->latitude
;            lat4c = in4c[0]->lat
            year1a = cd_calendar(time1a, -1) / 100
            year1b = cd_calendar(time1b, -1) / 100
            year1c = cd_calendar(time1c, -1) / 100
            year2 = cd_calendar(time2, -1) / 100
;            year4b = cd_calendar(time4b, -1) / 100
;            year4c = yyyymm_time(yS2, yE2, "integer") / 100
            iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
            iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
            iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
            iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
;            iYYYY4b = ind(year4b.ge.yS1 .and. year4b.le.yE1)
;            iYYYY4c = ind(year4c.ge.yS2 .and. year4c.le.yE2)
;            sst = lonFlip(in->sst)
;            sst = short2flt(in->sst)
            sst1 = in1a->sst(iYYYY1a,:,:)
            sst2 = in1b->sst(iYYYY1b,:,:)
            sst3 = in1c->sst(iYYYY1c,:,:)
            wspd  = in2->wspd(iYYYY2,:,:)
            nlwrs1 = in4a->nlwrs(iYYYY2,:,:)
            nswrs1 = in5a->nswrs(iYYYY2,:,:)
            nlwrs = (/nlwrs1 + nswrs1/)
            copy_VarCoords(nlwrs1, nlwrs)
/;
            msnlwrf = short2flt(in4b->msnlwrf(iYYYY4b,{30:-30},:))
            msnswrf = short2flt(in4b->msnswrf(iYYYY4b,{30:-30},:))
            nrsb = (/-msnlwrf - msnswrf/)
            copy_VarCoords(msnlwrf, nrsb)
            nlwrs3 = short2flt(in4c[:]->nlwrs(iYYYY4c,:,:))
            nswrs3 = short2flt(in5c[:]->nswrs(iYYYY4c,:,:))
            nrsc = (/nlwrs3 - nswrs3/)
            copy_VarCoords(nlwrs3, nrsc)
            nrsc&lon@units = "degreeE"
            nrsc&lat@units = "degreeN"
;/
            air = in6->air(iYYYY2,{:200},:,:)

;-------------------------------------------------------------
;creat weights: cos(lat)
            rad = 4.0 * atan(1.0) / 180.0
            gw1 = cos(rad * lat1)
            gw2 = cos(rad * lat2)
            gw4a = cos(rad * lat4a)
;            gw4b = cos(rad * lat4b)
;            gw4c = cos(rad * lat4c)
            copy_VarCoords(lat1, gw1)
            copy_VarCoords(lat2, gw2)
            copy_VarCoords(lat4a, gw4a)
;            copy_VarCoords(lat4b, gw4b)
;            copy_VarCoords(lat4c, gw4c)
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
        clm8 = clmMonTLL(dts)
        clm9 = clmMonTLL(uas)
        clm14 = clmMonTLL(rsus)
        clm15 = clmMonTLL(TT2)
        tsA = calcMonAnomTLL(dts, clm8)
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
        rsus_TIO = wgt_areaave_Wrap(rsusA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4a({latN1:latS1}), 1.0, 0)
        TT2_TIO = wgt_areaave_Wrap(TTA2_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        ts_TNA = wgt_areaave_Wrap(tsA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
        uas_TNA = wgt_areaave_Wrap(uasA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
        rsus_TNA = wgt_areaave_Wrap(rsusA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4a({latN2:latS2}), 1.0, 0)
        TT2_TNA = wgt_areaave_Wrap(TTA2_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
        x12(0,0,:) = (/regCoef(uas_TIO, ts_TIO)/)
        x13(0,0,:) = (/regCoef(rsus_TIO, ts_TIO)/)
        x14(0,0,:) = (/regCoef(TT2_TIO, ts_TIO)/)
        x12(1,0,:) = (/regCoef(uas_TNA, ts_TNA)/)
        x13(1,0,:) = (/regCoef(rsus_TNA, ts_TNA)/)
        x14(1,0,:) = (/regCoef(TT2_TNA, ts_TNA)/)

        r(:,0,i+4) = (/dim_min(x12(:,0,:))/)
        r(:,1,i+4) = (/dim_min(x13(:,0,:))/)
        r(:,2,i+4) = (/dim_max(x14(:,0,:))/)

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
            clm4a = clmMonTLL(nlwrs)
;            clm4b = clmMonTLL(nrsb)
;            clm4c = clmMonTLL(nrsc)
            clm6 = clmMonTLL(TT1)
            sstAa = calcMonAnomTLL(dsst1, clm1a)
            sstAb = calcMonAnomTLL(dsst2, clm1b)
            sstAc = calcMonAnomTLL(dsst3, clm1c)
            wspdA = calcMonAnomTLL(wspd, clm2)
            nlwrsA = calcMonAnomTLL(nlwrs, clm4a)
;            nrsAb = calcMonAnomTLL(nrsb, clm4b)
;            nrsAc = calcMonAnomTLL(nrsc, clm4c)
            TTA1 = calcMonAnomTLL(TT1, clm6)
            sstAa = (/dtrend_msg_n(sstAa&time, sstAa, False, False, 0)/)
            sstAb = (/dtrend_msg_n(sstAb&time, sstAb, False, False, 0)/)
            sstAc = (/dtrend_msg_n(sstAc&time, sstAc, False, False, 0)/)
            wspdA = (/dtrend_msg_n(wspdA&time, wspdA, False, False, 0)/)
            nlwrsA = (/dtrend_msg_n(nlwrsA&time, nlwrsA, False, False, 0)/)
;            nrsAb = (/dtrend_msg_n(nrsAb&time, nrsAb, False, False, 0)/)
;            nrsAc = (/dtrend_msg_n(nrsAc&time, nrsAc, False, False, 0)/)
            TTA1 = (/dtrend_msg_n(TTA1&time, TTA1, False, False, 0)/)
            sstAa_3M = month_to_seasonN(sstAa, season)
            sstAb_3M = month_to_seasonN(sstAb, season)
            sstAc_3M = month_to_seasonN(sstAc, season)
            wspdA_3M = month_to_seasonN(wspdA, season)
            nlwrsA_3M = month_to_seasonN(nlwrsA, season)
;            nrsAb_3M = month_to_seasonN(nrsAb, season)
;            nrsAc_3M = month_to_seasonN(nrsAc, season)
            TTA1_3M = month_to_seasonN(TTA1, season)

            ssta_TIO = wgt_areaave_Wrap(sstAa_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            sstb_TIO = wgt_areaave_Wrap(sstAb_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            sstc_TIO = wgt_areaave_Wrap(sstAc_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1.0, 0)
            wspd_TIO = wgt_areaave_Wrap(wspdA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            nlwrs_TIO = wgt_areaave_Wrap(nlwrsA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4a({latN1:latS1}), 1.0, 0)
;            nrsb_TIO = wgt_areaave_Wrap(nrsAb_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4b({latN1:latS1}), 1.0, 0)
;            nrsc_TIO = wgt_areaave_Wrap(nrsAc_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4c({latN1:latS1}), 1.0, 0)
            TT1_TIO = wgt_areaave_Wrap(TTA1_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            ssta_TNA = wgt_areaave_Wrap(sstAa_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            sstb_TNA = wgt_areaave_Wrap(sstAb_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            sstc_TNA = wgt_areaave_Wrap(sstAc_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1.0, 0)
            wspd_TNA = wgt_areaave_Wrap(wspdA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
            nlwrs_TNA = wgt_areaave_Wrap(nlwrsA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4a({latN2:latS2}), 1.0, 0)
;            nrsb_TNA = wgt_areaave_Wrap(nrsAb_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4b({latN2:latS2}), 1.0, 0)
;            nrsc_TNA = wgt_areaave_Wrap(nrsAc_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw4c({latN2:latS2}), 1.0, 0)
            TT1_TNA = wgt_areaave_Wrap(TTA1_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)

            x12(0,0,:) = (/regCoef(wspd_TIO, ssta_TIO)/)
            x12(0,1,:) = (/regCoef(wspd_TIO, sstb_TIO)/)
            x12(0,2,:) = (/regCoef(wspd_TIO, sstc_TIO)/)
            x13(0,0,:) = (/regCoef(nlwrs_TIO, ssta_TIO)/)
            x13(0,1,:) = (/regCoef(nlwrs_TIO, sstb_TIO)/)
            x13(0,2,:) = (/regCoef(nlwrs_TIO, sstc_TIO)/)
            x14(0,0,:) = (/regCoef(TT1_TIO, ssta_TIO)/)
            x14(0,1,:) = (/regCoef(TT1_TIO, sstb_TIO)/)
            x14(0,2,:) = (/regCoef(TT1_TIO, sstc_TIO)/)
            x12(1,0,:) = (/regCoef(wspd_TNA, ssta_TNA)/)
            x12(1,1,:) = (/regCoef(wspd_TNA, sstb_TNA)/)
            x12(1,2,:) = (/regCoef(wspd_TNA, sstc_TNA)/)
            x13(1,0,:) = (/regCoef(nlwrs_TNA, ssta_TNA)/)
            x13(1,1,:) = (/regCoef(nlwrs_TNA, sstb_TNA)/)
            x13(1,2,:) = (/regCoef(nlwrs_TNA, sstc_TNA)/)
            x14(1,0,:) = (/regCoef(TT1_TNA, ssta_TNA)/)
            x14(1,1,:) = (/regCoef(TT1_TNA, sstb_TNA)/)
            x14(1,2,:) = (/regCoef(TT1_TNA, sstc_TNA)/)
            r(:,0,:2) = (/dim_min(x12)/)
            print((/x12(0,:,:)/))
            print((/r(0,0,:2)/))
            exit
            r(:,1,:2) = (/dim_min(x13)/)
            r(:,2,:2) = (/dim_max(x14)/)
/;
            x13(0,:) = (/regCoef(nrsb_TIO, sstb_TIO)/)
            x13(1,:) = (/regCoef(nrsb_TNA, sstb_TNA)/)
            rc1 = dim_min(x13)
            x13(0,:) = (/regCoef(nrsc_TIO, sstc_TIO)/)
            x13(1,:) = (/regCoef(nrsc_TNA, sstc_TNA)/)
            rc2 = dim_min(x13)
            rc1!0 = "region"
            rc2!0 = "region"
;/
        end if

        delete([/time7,time8,time10,time14,year7,year8,year10,year14/])

    end do

;    r(:,:,1) = (/tanh( dim_avg ( .5*log( (1.+r(:,:,2:)) / (1.-r(:,:,2:))  ) ) )/)
    r(:,:,3) = (/dim_avg(r(:,:,4:))/)
    std = dim_stddev_Wrap(r(:,:,4:))
    std!0 = "region"
    std!1 = "variable"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","variable","model"/)
    dimSizes = ndim
    dimUnlim = (/False,False,False/)   

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "variable", "integer", "variable")
    filevardef(fout, "model", "integer", "model")
    filevardef(fout, "r", typeof(r), getvardims(r))
    filevardef(fout, "std", typeof(std), getvardims(std))

;Copy attributes associated with each variable to the file
    filevarattdef(fout, "std", std)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->variable = ispan(1, 3, 1)
    fout->model = ispan(1, nmod+4, 1)
    fout->r = (/r/)
    fout->std = (/std/)

else

    in = addfile(out_data, "r")
    r = in->r
    std = in->std
    ndim = dimsizes(r)

end if

printVarSummary(r)
printVarSummary(std)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

r = (/r / conform_dims(ndim, sqrt((std(0,:)^2.0 + std(1,:)^2.0) / 2.0), 1)/)
;rc1 = (/rc1 / sqrt((std(0,1)^2.0 + std(1,1)^2.0) / 2.0)/)
;rc2 = (/rc2 / sqrt((std(0,1)^2.0 + std(1,1)^2.0) / 2.0)/)
std = (/std / conform_dims(ndim(:1), sqrt((std(0,:)^2.0 + std(1,:)^2.0) / 2.0), 1)/)
print((/r(:,:,:3)/))

wks = gsn_open_wks("svg", out_path + out_name)
plot2 = new(3, graphic)
dum1 = new(3, graphic)
dum2 = new(3, graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = text1
res@gsnCenterString = text2
res@gsnStringFontHeightF = 0.024

res@tiYAxisString = text3(0)
res@tiXAxisString = text3(1)
res@tiXAxisFontHeightF = .023
res@tiMainString = "Regression of ~F33~D~F~SSTA onto Parameters"
res@tiMainFontHeightF = .028

res@trYMaxF = 5.0
res@trYMinF = -5.0
res@trXMaxF = 5.0
res@trXMinF = -5.0

res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

res@xyMarkLineMode = "Markers"
res@xyMarker = indexes
res@xyMarkerSizeF = sizes
res@xyMarkerColors = colors
res@xyMarkerThicknessF = thickness
plot = gsn_csm_xy(wks, transpose((/r(0,:,0),r(0,:,0)/)), transpose((/r(1,:,0),r(1,:,0)/)), res)

poyres = True
poyres@gsMarkerSizeF = sizes
poyres@gsMarkerColor = colors(1)
poyres@gsMarkerThicknessF = thickness

;poyres@gsMarkerIndex = 2
;marker1 = gsn_add_polymarker(wks,plot,rc1(0),rc1(1),poyres)
;marker2 = gsn_add_polymarker(wks,plot,rc2(0),rc2(1),poyres)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2.0
resl@gsLineDashPattern = 1
duma = gsn_add_polyline(wks, plot, (/-5.0,5.0/), (/-5.,5.0/), resl)
dumb = gsn_add_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/0.0,0.0/), resl)
dumc = gsn_add_polyline(wks, plot, (/0.0,0.0/), (/res@trYMinF,res@trYMaxF/), resl)

resl@gsLineDashPattern = 0
a = (res@trYMaxF - res@trYMinF) / 66.0
do i = 0, 2
    resl@gsLineColor = colors(i)
    dum1(i) = gsn_add_polyline(wks, plot, (/r(0,i,3) - std(0,i),r(0,i,3) + std(0,i)/), (/r(1,i,3),r(1,i,3)/), resl)
    dum2(i) = gsn_add_polyline(wks, plot, (/r(0,i,3),r(0,i,3)/), (/r(1,i,3) - std(1,i),r(1,i,3) + std(1,i)/), resl)
end do

;--------------------------------------------------------------
;color for mechanism, shape for model
indexes(3) = NhlNewMarker(wks, "y", 35, 0.0, 0.0, 1.0, 1.0, 0.0)
reso = True
reso@gsnDraw = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkerColors = colors
do i= 0, 2
    reso@xyMarker = indexes(i+1)
    reso@xyMarkerSizeF = sizes(i+1)
    reso@xyMarkerThicknessF = thickness(i+1)
    plot2(i) = gsn_csm_xy(wks, transpose((/r(0,:,i+1),r(0,:,i+1)/)), transpose((/r(1,:,i+1),r(1,:,i+1)/)), reso)
    overlay(plot, plot2(i))
end do

draw(plot)
/;
;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0, 1
    gsres@gsMarkerSizeF = sizes(i)
    gsres@gsMarkerIndex = indexes(i)
    gsn_polymarker_ndc(wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.018

gsn_text_ndc (wks,text3,x(:1)+.025,y(:1),txres)

do i = 0,2
 txres@txFontColor = colors(i)
 gsn_text_ndc(wks,text4(i),x(i),y(i)-.08,txres)
end do
;/
frame (wks)

end
