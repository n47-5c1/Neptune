;*******************************:******************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly mean surface wind speed and surface radiative flux 
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2019-12-06
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;   var3--------------vwnd
;   var4--------------wspd
;   var5--------------nlwrs
;   var6--------------nswrs

;   var7--------------ts
;   var8--------------uas
;   var9--------------vas
;   var10-------------rlds
;   var11-------------rlus
;   var12-------------rsds
;   var13-------------rsus
;================================================

process = False      ; Pertinent statistics? Plot?

;data
in_mask = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
;HadISST1   1870/01 - , 1x1
in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5/T62
in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
in_name3 = "~/data/observation/NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"
in_name4 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"
in_name5 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
in_name6 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"

in_path7     = "~/data-model/CMIP5-hes/ts/historical/"
in_name7     = new(37,string)
in_name7(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;in_name7(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;in_name7(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
in_name7(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;in_name7(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
in_name7(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
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
nmod = dimsizes (in_name7)

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

;time
    yS = 1958
    yE = 2004
    season = (/"MJJ","JJA","JAS","ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270
;Nino3
;    latNI = 5
;    latSI = -5
;    lonWI = 210
;    lonEI = 270
;Nino3.4
;    latNI = 5
;    latSI = -5
;    lonWI = 190
;    lonEI = 240

;tropical Indian Ocean
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

; create points for box
    ypts1 = (/latN1,latN1,latS1,latS1,latN1/)
    xpts1 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
    ypts2 = (/latN2,latN2,latS2,latS2,latN2/)
    xpts2 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)

;region
    latN = 45
    latS = -30
;    lonW = 120
;    lonE = 280

;arguments required by vertical mean
    pnew       = (/1000,925,850,700,600,500,400,300,250,200/)
    pver       = pnew*100
    pver@units = "Pa"
    dp         = dpres_plevel_Wrap (pver,100000,20000,0)   ;caculate dp
    sumdp      = sum(dp)
    print ((/dp/))

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/Animation/"
    out_data1 = "./lag_regress_NDJ_CTI_and_g_wspd.sfc_anom_remove_trend_CMIP.nc"
    out_data2 = "./lag_regress_NDJ_CTI_and_g_nrs_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_g_wspd.sfc_nrs_anom_remove_trend_CMIP_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) ","c) ","d)","e) ","f)","c) ","d) "/)
    text3 = (/"HadISST","ERSST","COBE","MMM"/)
    text4 = (/"Regress "," ~F10~U~B~Surf~FN~ onto NDJ CTI"," ~F10~F~B~Rad~FN~ onto NDJ CTI",\
              "m~F34~W~F~s~S~-1~N~/~F35~J~F~C","w~F34~W~F~m~S~-2~N~/~F35~J~F~C"/)
;    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

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

;get the time indexs
    time7 = in7->time
    time8 = in8->time
    time9 = in9->time
    time10 = in10->time
    time11 = in11->time
    time12 = in12->time
    time13 = in13->time
    year7 = cd_calendar(time7, -1) / 100
    year8 = cd_calendar(time8, -1) / 100
    year9 = cd_calendar(time9, -1) / 100
    year10 = cd_calendar(time10, -1) / 100
    year11 = cd_calendar(time11, -1) / 100
    year12 = cd_calendar(time12, -1) / 100
    year13 = cd_calendar(time13, -1) / 100
    iYYYY7 = ind(year7.ge.yS .and. year7.le.yE)
    iYYYY8 = ind(year8.ge.yS .and. year8.le.yE)
    iYYYY9 = ind(year9.ge.yS .and. year9.le.yE)
    iYYYY10 = ind(year10.ge.yS .and. year10.le.yE)
    iYYYY11 = ind(year11.ge.yS .and. year11.le.yE)
    iYYYY12 = ind(year12.ge.yS .and. year12.le.yE)
    iYYYY13 = ind(year13.ge.yS .and. year13.le.yE)

    ts = in7->ts(iYYYY7,{latN:latS},:)
    uas = in8->uas(iYYYY8,:,:)
    vas = in9->vas(iYYYY9,:,:)
    speed = wind_speed(uas, vas)
    rlds = in10->rlds(iYYYY10,:,:)
    rlus = in11->rlus(iYYYY11,:,:)
    rsds = in12->rsds(iYYYY12,:,:)
    rsus = in13->rsus(iYYYY13,:,:)
    rsus = (/rlus + rsus - rlds - rsds/)

    if(i.eq.0)then

     in1a = addfile(in_name1a, "r")
     in1b = addfile(in_name1b, "r")
     in1c = addfile(in_name1c, "r")
     in2 = addfile(in_name2, "r")
     in3 = addfile(in_name3, "r")
     in4 = addfile(in_name4, "r")
     in5 = addfile(in_name5, "r")
     in6 = addfile(in_name6, "r")
     time1a = in1a->time
     time1b = in1b->time
     time1c = in1c->time
     time2 = in2->time
     time3 = in3->time
     time4 = in4->time
     time5 = in5->time
     time6 = in6->time
     lat1 = in1a->lat({latN:latS})
     lat2 = in2->lat(::-1)
     lat5 = in5->lat(::-1)
     lon2 = in2->lon
     lon5 = in5->lon
     year1a = cd_calendar(time1a, -1) / 100
     year1b = cd_calendar(time1b, -1) / 100
     year1c = cd_calendar(time1c, -1) / 100
     year2 = cd_calendar(time2, -1) / 100
     year3 = cd_calendar(time3, -1) / 100
     year4 = cd_calendar(time4, -1) / 100
     year5 = cd_calendar(time5, -1) / 100
     year6 = cd_calendar(time6, -1) / 100
     iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
     iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
     iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
     iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
     iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
     iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)
     iYYYY5 = ind(year5.ge.yS .and. year5.le.yE)
     iYYYY6 = ind(year6.ge.yS .and. year6.le.yE)
;     sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst1 = in1a->sst(iYYYY1a,{latN:latS},:)
     sst2 = in1b->sst(iYYYY1b,{latN:latS},:)
     sst3 = in1c->sst(iYYYY1c,{latN:latS},:)
     uwnd = in2->uwnd(iYYYY2,::-1,:)
     vwnd = in3->vwnd(iYYYY3,::-1,:)
     wspd = in4->wspd(iYYYY4,::-1,:)
     nlwrs = in5->nlwrs(iYYYY5,::-1,:)
     nswrs = in6->nswrs(iYYYY6,::-1,:)
     nlwrs = (/nlwrs + nswrs/)
;     sst1 = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw  = cos(rad * lat1)
     copy_VarCoords(lat1, gw)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
    clm7 = clmMonTLL(ts)
    clm8 = clmMonTLL(uas)
    clm9 = clmMonTLL(vas)
    clm89 = clmMonTLL(speed)
    clm10 = clmMonTLL(rsus)
    tsA = calcMonAnomTLL(ts, clm7)
    uasA = calcMonAnomTLL(uas, clm8)
    vasA = calcMonAnomTLL(vas, clm9)
    speedA = calcMonAnomTLL(speed, clm89)
    rsusA = calcMonAnomTLL(rsus, clm10)
    tsA  = (/dtrend_msg_n(tsA&time, tsA, False, False, 0)/)
    uasA = (/dtrend_msg_n(uasA&time, uasA, False, False, 0)/)
    vasA = (/dtrend_msg_n(vasA&time, vasA, False, False, 0)/)
    speedA = (/dtrend_msg_n(speedA&time, speedA, False, False, 0)/)
    rsusA = (/dtrend_msg_n(rsusA&time, rsusA, False, False, 0)/)

;compute seasonal means
    tsA_S = month_to_season(tsA, season(6))
    uasA_S = month_to_seasonN(uasA, season)
    vasA_S = month_to_seasonN(vasA, season)
    speedA_S = month_to_seasonN(speedA, season)
    rsusA_S = month_to_seasonN(rsusA, season)

;--------------------------------------------------------------
;cold tongue (NDJ)
    I_NDJ = wgt_areaave_Wrap(tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;--------------------------------------------------------------
   if(i.eq.0)then
    dim1 = dimsizes(uasA_S)
    dim2 = dimsizes(rsusA_S)
    mnmn1 = new((/dim1(0),dim1(2),dim1(3),3,nmod+4/),float)
    mnmn2 = new((/dim2(0),dim2(2),dim2(3),nmod+4/),float)
    copy_VarCoords(uasA_S(:,0,:,:), mnmn1(:,:,:,0,0))
    copy_VarCoords(rsusA_S(:,0,:,:), mnmn2(:,:,:,0))
    mnmn1!3 = "variable"
    mnmn1!4 = "nmod"
    mnmn2!3 = "nmod"
   end if

;compute linear regression
   mnmn1(:,:,:,0,i+4) = (/regCoef_n(I_NDJ,uasA_S,0,1)/)
   mnmn1(:,:,:,1,i+4) = (/regCoef_n(I_NDJ,vasA_S,0,1)/)
   mnmn1(:,:,:,2,i+4) = (/regCoef_n(I_NDJ,speedA_S,0,1)/)
   mnmn2(:,:,:,i+4) = (/regCoef_n(I_NDJ,rsusA_S,0,1)/)
   mnmn1(7:,:,:,0,i+4) = (/regCoef_n(I_NDJ(:dim1(1)-2),uasA_S(7:,1:,:,:),0,1)/)
   mnmn1(7:,:,:,1,i+4) = (/regCoef_n(I_NDJ(:dim1(1)-2),vasA_S(7:,1:,:,:),0,1)/)
   mnmn1(7:,:,:,2,i+4) = (/regCoef_n(I_NDJ(:dim1(1)-2),speedA_S(7:,1:,:,:),0,1)/)
   mnmn2(7:,:,:,i+4) = (/regCoef_n(I_NDJ(:dim1(1)-2),rsusA_S(7:,1:,:,:),0,1)/)

   if(i.eq.0)then
    clm1a = clmMonTLL(sst1)
    clm1b = clmMonTLL(sst2)
    clm1c = clmMonTLL(sst3)
    clm2 = clmMonTLL(uwnd)
    clm3 = clmMonTLL(vwnd)
    clm4 = clmMonTLL(wspd)
    clm5 = clmMonTLL(nlwrs)
    sstA1 = calcMonAnomTLL(sst1, clm1a)
    sstA2 = calcMonAnomTLL(sst2, clm1b)
    sstA3 = calcMonAnomTLL(sst3, clm1c)
    uwndA = calcMonAnomTLL(uwnd, clm2)
    vwndA = calcMonAnomTLL(vwnd, clm3)
    wspdA = calcMonAnomTLL(wspd, clm4)
    nlwrsA = calcMonAnomTLL(nlwrs, clm5)
    sstA1 = (/dtrend_msg_n(sstA1&time, sstA1, False, False, 0)/)
    sstA2 = (/dtrend_msg_n(sstA2&time, sstA2, False, False, 0)/)
    sstA3 = (/dtrend_msg_n(sstA3&time, sstA3, False, False, 0)/)
    uwndA = (/dtrend_msg_n(uwndA&time, uwndA, False, False, 0)/)
    vwndA = (/dtrend_msg_n(vwndA&time, vwndA, False, False, 0)/)
    wspdA = (/dtrend_msg_n(wspdA&time, wspdA, False, False, 0)/)
    nlwrsA = (/dtrend_msg_n(nlwrsA&time, nlwrsA, False, False, 0)/)
    sstA1_S = month_to_season(sstA1, season(6))
    sstA2_S = month_to_season(sstA2, season(6))
    sstA3_S = month_to_season(sstA3, season(6))
    uwndA_S = month_to_seasonN(uwndA, season)
    vwndA_S = month_to_seasonN(vwndA, season)
    wspdA_S = month_to_seasonN(wspdA, season)
    nlwrsA_S = month_to_seasonN(nlwrsA, season)
    I1_NDJ = wgt_areaave_Wrap(sstA1_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I2_NDJ = wgt_areaave_Wrap(sstA2_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I3_NDJ = wgt_areaave_Wrap(sstA3_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    mnmn1(:,:,:,0,0) = (/regCoef_n(I1_NDJ, uwndA_S, 0, 1)/)
    mnmn1(:,:,:,1,0) = (/regCoef_n(I1_NDJ, vwndA_S, 0, 1)/)
    mnmn1(:,:,:,2,0) = (/regCoef_n(I1_NDJ, wspdA_S, 0, 1)/)
    mnmn2(:,:,:,0) = (/regCoef_n(I1_NDJ, nlwrsA_S, 0, 1)/)
    mnmn1(:,:,:,0,1) = (/regCoef_n(I2_NDJ, uwndA_S, 0, 1)/)
    mnmn1(:,:,:,1,1) = (/regCoef_n(I2_NDJ, vwndA_S, 0, 1)/)
    mnmn1(:,:,:,2,1) = (/regCoef_n(I2_NDJ, wspdA_S, 0, 1)/)
    mnmn2(:,:,:,1) = (/regCoef_n(I2_NDJ, nlwrsA_S, 0, 1)/)
    mnmn1(:,:,:,0,2) = (/regCoef_n(I3_NDJ, uwndA_S, 0, 1)/)
    mnmn1(:,:,:,1,2) = (/regCoef_n(I3_NDJ, vwndA_S, 0, 1)/)
    mnmn1(:,:,:,2,2) = (/regCoef_n(I3_NDJ, wspdA_S, 0, 1)/)
    mnmn2(:,:,:,2) = (/regCoef_n(I3_NDJ, nlwrsA_S, 0, 1)/)
    mnmn1(7:,:,:,0,0) = (/regCoef_n(I1_NDJ(:dim1(1)-2), uwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,1,0) = (/regCoef_n(I1_NDJ(:dim1(1)-2), vwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,2,0) = (/regCoef_n(I1_NDJ(:dim1(1)-2), wspdA_S(7:,1:,:,:), 0, 1)/)
    mnmn2(7:,:,:,0) = (/regCoef_n(I1_NDJ(:dim1(1)-2), nlwrsA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,0,1) = (/regCoef_n(I2_NDJ(:dim1(1)-2), uwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,1,1) = (/regCoef_n(I2_NDJ(:dim1(1)-2), vwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,2,1) = (/regCoef_n(I2_NDJ(:dim1(1)-2), wspdA_S(7:,1:,:,:), 0, 1)/)
    mnmn2(7:,:,:,1) = (/regCoef_n(I2_NDJ(:dim1(1)-2), nlwrsA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,0,2) = (/regCoef_n(I3_NDJ(:dim1(1)-2), uwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,1,2) = (/regCoef_n(I3_NDJ(:dim1(1)-2), vwndA_S(7:,1:,:,:), 0, 1)/)
    mnmn1(7:,:,:,2,2) = (/regCoef_n(I3_NDJ(:dim1(1)-2), wspdA_S(7:,1:,:,:), 0, 1)/)
    mnmn2(7:,:,:,2) = (/regCoef_n(I3_NDJ(:dim1(1)-2), nlwrsA_S(7:,1:,:,:), 0, 1)/) 
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time7,time8,time9,time10,time11,time12,time13,year7,year8,year9,year10,year11,year12,year13/])

end do

   mnmn1(:,:,:,:,3) = (/dim_avg(mnmn1(:,:,:,:,4:))/)
   mnmn2(:,:,:,3) = (/dim_avg(mnmn2(:,:,:,4:))/)
   printVarSummary(mnmn1)
   printVarSummary(mnmn2)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system("rm -f " + out_data1)
system("rm -f " + out_data2)
fout1 = addfile(out_data1, "c")
fout2 = addfile(out_data2, "c")
setfileoption(fout1, "DefineMode", True)
setfileoption(fout2, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames1 = (/"season","lat","lon","variable","nmod"/)
dimNames2 = (/"season","lat","lon","nmod"/)
dimSizes1 = dimsizes(mnmn1)
dimSizes2 = dimsizes(mnmn2)
dimUnlim1 = (/True,False,False,False,False/)
dimUnlim2 = (/True,False,False,False/)

filedimdef(fout1, dimNames1, dimSizes1, dimUnlim1)
filedimdef(fout2, dimNames2, dimSizes2, dimUnlim2)

;predefine the the dimensionality of the variables to be written out
filevardef(fout1, "season", "integer", "season")
filevardef(fout2, "season", "integer", "season")
filevardef(fout1, "lat", typeof(lat2), getvardims(lat2))
filevardef(fout2, "lat", typeof(lat5), getvardims(lat5))
filevardef(fout1, "lon", typeof(lon2), getvardims(lon2))
filevardef(fout2, "lon", typeof(lon5), getvardims(lon5))
filevardef(fout1, "variable", "integer", "variable")
filevardef(fout1, "nmod", "integer", "nmod")
filevardef(fout2, "nmod", "integer", "nmod")
filevardef(fout1, "mnmn", typeof(mnmn1), getvardims(mnmn1))
filevardef(fout2, "mnmn", typeof(mnmn2), getvardims(mnmn2))

;Copy attributes associated with each variable to the file
filevarattdef(fout1, "lat", lat2)
filevarattdef(fout2, "lat", lat5)
filevarattdef(fout1, "lon", lon2)
filevarattdef(fout2, "lon", lon5)
filevarattdef(fout1, "mnmn", mnmn1)
filevarattdef(fout2, "mnmn", mnmn2)

;output only the data values
fout1->season = ispan(1, dim1(0), 1)
fout2->season = ispan(1, dim1(0), 1)
fout1->lat = (/lat2/)
fout2->lat = (/lat5/)
fout1->lon = (/lon2/)
fout2->lon = (/lon5/)
fout1->variable = ispan(1, 3, 1)
fout1->nmod = ispan(1, nmod+4, 1)
fout2->nmod = ispan(1, nmod+4, 1)
fout1->mnmn = (/mnmn1/)
fout2->mnmn = (/mnmn2/)

else

 in1 = addfile(out_data1,"r")
 in2 = addfile(out_data2,"r")
 mnmn1 = in1->mnmn
 mnmn2 = in2->mnmn
 dim1 = dimsizes (mnmn1)
 printVarSummary (mnmn1)

end if

lsdata = in_mask->LSMASK
lsm1 = landsea_mask(lsdata, mnmn1&lat, mnmn1&lon)
lsm2 = landsea_mask(lsdata, mnmn2&lat, mnmn2&lon)
mnmn1 = (/mask(mnmn1, conform(mnmn1,lsm1,(/1,2/)).eq.0, True)/)
mnmn2 = (/mask(mnmn2, conform(mnmn2,lsm2,(/1,2/)).eq.0, True)/)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"

res@lbLabelFontHeightF       = 0.02
res@pmLabelBarOrthogonalPosF = 0.36

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;res@mpFillOn               = False
res@mpCenterLonF           = 200
;res@mpCenterLonF           = 30
;res@mpLandFillColor        = "gray80"
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

;---------------------------------------------------------------
;plot vector
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "

;res2@vcRefAnnoOn = False
res2@vcRefLengthF = 0.05
res2@vcRefMagnitudeF = 1.2
res2@vcRefAnnoString2On = False
res2@vcRefAnnoFontHeightF = 0.014
res2@vcRefAnnoOrthogonalPosF = -0.36
res2@vcMinDistanceF = 0.03
res2@vcLineArrowThicknessF = 1.6
res2@vcLineArrowHeadMaxSizeF = 0.015
res2@vcLineArrowHeadMinSizeF = 0.008

;************************************************
; add the box
;************************************************
resb                   = True
resb@gsLineThicknessF  = 3

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnFrame = False
resP@gsnPanelBottom = 0.01
resP@txString = "Regression of WSPD and NRS onto NDJ CTI"
resP@txFontHeightF = 0.023

;----------------------------------------------------------
do i = 0, dim1(0)-1

    wks = gsn_open_wks("svg", out_path + out_name + text1(i))
    plot = new(8, graphic)
    plot0 = new(4, graphic)

    do j = 0, 3
        res@gsnLeftString = text2(2*j) + text3(j)
        if(j.eq.0)then
            res@gsnCenterString = text4(0) + season(i) + text4(1)
;            res@gsnCenterString = text4(1) + sprintf("%5.3f", r2(i))
            res@gsnRightString  = text4(3)
        else
            res@gsnCenterString = " "
            res@gsnRightString  = " "
        end if
        if(j.eq.3)then
            res@lbLabelBarOn = True
        else
            res@lbLabelBarOn = False
        end if
        res@cnLevels = (/-.6,-.3,-.15,.15,.3,.6/)
        res@cnFillPalette = "MPL_coolwarm"
        plot(2*j) = gsn_csm_contour_map_ce(wks, mnmn1(i,:,:,2,j), res)
        if(j .eq. 3)then
            res2@vcRefAnnoOn = True
        else
            res2@vcRefAnnoOn = False
        end if
        plot0(j) = gsn_csm_vector(wks, mnmn1(i,:,:,0,j), mnmn1(i,:,:,1,j), res2)
        overlay(plot(2*j), plot0(j))

        res@gsnLeftString = text2(2*j+1) + text3(j)
        if(j.eq.0)then
            res@gsnCenterString = text4(0) + season(i) + text4(2)
            res@gsnRightString = text4(4)
        end if
        res@cnLevels = (/-4.,-2.,-1.,1.,2.,4./)
        res@cnFillPalette = "MPL_RdYlBu"
        plot(2*j+1) = gsn_csm_contour_map_ce(wks, mnmn2(i,:,:,j), res)

    end do

;----------------------------------------------------------
    do j =0,3
        dum1(j) = gsn_add_polyline (wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
        dum2(j) = gsn_add_polyline (wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
        dum3(j) = gsn_add_polyline (wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
        dum4(j) = gsn_add_polyline (wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
    end do 

;    gsn_panel(wks, plot, (/4,2/), resP)
    gsn_panel(wks, plot((/0,1,6,7/)), (/2,2/), resP)
    frame(wks)

    delete([/wks,plot/])
end do

end
