;*************************************************************
;Aim: Draw a bar chart of maximum cross regression coefficients of three-month means of area average of regional monthly sea surface temperature and
;     surface wind speed, surface radiative flux, as well as mean 1000-200-hPa tropospheric temperature anomalies removed trend in the tropical Indian
;     Ocean as well as in the tropical North Atlantic onto the NDJ cold tongue index in CMIP models (visualized by being divided by intermodel standard
;     deviation)
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2019-06-10
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------wspd.sfc
;   var3--------------nlwrs
;   var4--------------nswrs
;   var5--------------air

;   var6--------------ts
;   var7--------------uas
;   var8--------------vas
;   var9--------------rlds
;   var10-------------rlus
;   var11-------------rsds
;   var12-------------rsus
;   var13-------------ta
;================================================

process = False

;time
yS = 1958
yE = 2004
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
maxlag = dimsizes(season)

;fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./bar_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"
out_name = "bar_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_nrs_TT_anom_remove_trend_CMIP"

;text
text1 = (/"b) ~F10~U~B~Surf","c) ~F10~F~B~Rad","a) ~F10~T~B~Trop"/)
;text2 = "max/min[~F14~R~BF~CTI~F18~o~F14~X~F~(~F8~t~F~)~N~]"
text2 = "Atmospheric responses to ENSO"
text3 = (/"(10~S~-1~N~ m~F34~W~F~s~S~-1~N~/~F35~J~F~C)","(w~F34~W~F~m~S~-2~N~/~F35~J~F~C)","(10~S~-1~N~ ~F35~J~F~C/~F35~J~F~C)","Data set"/)
;text4 = (/"~F33~a","~F33~b","~F33~g","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
text4 = (/"~F33~a","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
          "J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)
text5 = (/"2.5% "," 97.5%","TIO","TNA"/)

colors = (/"lightpink","red","cyan","blue"/)

if(process)then

;HadISST1 1870/01 - , 1x1
    in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
    in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc";T62
    in_name4 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc";T62
    in_name5 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"

    in_path6 = "~/data-model/CMIP5-hes/ts/historical/"
    in_name6 = new(37, string)
    in_name6(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name6(2) = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name6(3) = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(4) = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name6(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(5) = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(6) = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(7) = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(9) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(8) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(9) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(15) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name6(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(17) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name6(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name6(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name6(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name6(17) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name6(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name6(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name6(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name6(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name6(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name6(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes(in_name6)

    in_path7 = "~/data-model/CMIP5-hes/uas/historical/"
    in_name7 = new(nmod, string)
    in_name7(0) = "uas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(1) = "uas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(2) = "uas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name7(2) = "uas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name7(3) = "uas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(4) = "uas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name7(3) = "uas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(5) = "uas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(6) = "uas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(7) = "uas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(8) = "uas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(9) = "uas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(4)  = "uas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(5)  = "uas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(6)  = "uas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(7)  = "uas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(8)  = "uas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(9)  = "uas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(15) = "uas_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name7(10) = "uas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(17) = "uas_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(11) = "uas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name7(12) = "uas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name7(13) = "uas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name7(14) = "uas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name7(15) = "uas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(16) = "uas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name7(17) = "uas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(18) = "uas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name7(19) = "uas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name7(17) = "uas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name7(20) = "uas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name7(21) = "uas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name7(22) = "uas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(23) = "uas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(24) = "uas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(25) = "uas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(26) = "uas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name7(27) = "uas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name7(28) = "uas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(29) = "uas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(30) = "uas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(31) = "uas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(32) = "uas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(33) = "uas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(34) = "uas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name7(35) = "uas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(36) = "uas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path8 = "~/data-model/CMIP5-hes/vas/historical/"
    in_name8 = new(nmod, string)
    in_name8(0) = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(1) = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(2) = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name8(2) = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name8(3) = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(4) = "vas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name8(3) = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(5) = "vas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(6) = "vas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(7) = "vas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(8) = "vas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(9) = "vas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(4) = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(5) = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(6) = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(7) = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(8) = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(9) = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(15) = "vas_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name8(10) = "vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name8(17) = "vas_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(11) = "vas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name8(12) = "vas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name8(13) = "vas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name8(14) = "vas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name8(15) = "vas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(16) = "vas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name8(17) = "vas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(18) = "vas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name8(19) = "vas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name8(17) = "vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name8(20) = "vas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name8(21) = "vas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name8(22) = "vas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(23) = "vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(24) = "vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(25) = "vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(26) = "vas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name8(27) = "vas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name8(28) = "vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(29) = "vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(30) = "vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(31) = "vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(32) = "vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(33) = "vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(34) = "vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name8(35) = "vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name8(36) = "vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path9 = "~/data-model/CMIP5-hes/rlds/historical/"
    in_name9 = new(nmod, string)
    in_name9(0) = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(1) = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(2) = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name9(2) = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name9(3) = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(3) = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(4) = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(4) = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(5) = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(6) = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(7) = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(8) = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(9) = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(7) = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(10) = "rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(11) = "rlds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name9(12) = "rlds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name9(13) = "rlds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name9(14) = "rlds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name9(15) = "rlds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(16) = "rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name9(17) = "rlds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(18) = "rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name9(19) = "rlds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name9(20) = "rlds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name9(21) = "rlds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name9(22) = "rlds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(23) = "rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(24) = "rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(25) = "rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(26) = "rlds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name9(27) = "rlds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name9(28) = "rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(29) = "rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(30) = "rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(31) = "rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(32) = "rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(33) = "rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(34) = "rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name9(35) = "rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(36) = "rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path10 = "~/data-model/CMIP5-hes/rlus/historical/"
    in_name10 = new(nmod, string)
    in_name10(0) = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(1) = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(2) = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name10(2) = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name10(3) = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(3) = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(4) = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(4) = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(5) = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(6) = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(7) = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(8) = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(9) = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(7) = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(10) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(11) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name10(12) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name10(13) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(14) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(15) = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(16) = "rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name10(17) = "rlus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(18) = "rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name10(19) = "rlus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name10(20) = "rlus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name10(21) = "rlus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name10(22) = "rlus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(23) = "rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(24) = "rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(25) = "rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(26) = "rlus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name10(27) = "rlus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name10(28) = "rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(29) = "rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(30) = "rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(31) = "rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(32) = "rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(33) = "rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(34) = "rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name10(35) = "rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(36) = "rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path11 = "~/data-model/CMIP5-hes/rsds/historical/"
    in_name11 = new(nmod, string)
    in_name11(0) = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(1) = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(2) = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name11(3) = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name11(3) = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(4) = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(5) = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(4) = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(5) = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(6) = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(7) = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(8) = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(9) = "rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(10) = "rsds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(10) = "rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(11) = "rsds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name11(12) = "rsds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name11(13) = "rsds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name11(14) = "rsds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name11(15) = "rsds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(16) = "rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name11(17) = "rsds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(18) = "rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name11(19) = "rsds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name11(20) = "rsds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name11(21) = "rsds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name11(22) = "rsds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(23) = "rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(24) = "rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(25) = "rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(26) = "rsds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name11(27) = "rsds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name11(28) = "rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(29) = "rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(30) = "rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(31) = "rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(32) = "rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(33) = "rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(34) = "rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name11(35) = "rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(36) = "rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path12 = "~/data-model/CMIP5-hes/rsus/historical/"
    in_name12 = new(nmod, string)
    in_name12(0) = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(1) = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(2) = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name12(3) = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name12(3) = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(4) = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(5) = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(4) = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(5) = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(6) = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(7) = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(8) = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(9) = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(10) = "rsus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(10) = "rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(11) = "rsus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name12(12) = "rsus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name12(13) = "rsus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name12(14) = "rsus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name12(15) = "rsus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(16) = "rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name12(17) = "rsus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(18) = "rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name12(19) = "rsus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name12(20) = "rsus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name12(21) = "rsus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name12(22) = "rsus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(23) = "rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(24) = "rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(25) = "rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(26) = "rsus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name12(27) = "rsus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name12(28) = "rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(29) = "rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(30) = "rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(31) = "rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(32) = "rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(33) = "rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(34) = "rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name12(35) = "rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(36) = "rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path13 = "~/data-model/CMIP5-hes/ta/historical/"
    in_name13 = new(nmod, string)
    in_name13(0) = "ta_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(1) = "ta_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(2) = "ta_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name13(2) = "ta_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name13(3) = "ta_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(3) = "ta_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name13(3) = "ta_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(6) = "ta_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(7) = "ta_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(8) = "ta_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(9) = "ta_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(10) = "ta_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(4) = "ta_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(5) = "ta_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(6) = "ta_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(7) = "ta_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name13(8) = "ta_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(9) = "ta_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(10) = "ta_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name13(10) = "ta_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name13(18) = "ta_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(11) = "ta_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name13(12) = "ta_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name13(13) = "ta_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name13(14) = "ta_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name13(15) = "ta_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(16) = "ta_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name13(17) = "ta_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(18) = "ta_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name13(19) = "ta_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name13(28) = "ta_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name13(20) = "ta_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name13(21) = "ta_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name13(22) = "ta_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(23) = "ta_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(24) = "ta_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(25) = "ta_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(26) = "ta_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name13(27) = "ta_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name13(28) = "ta_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(29) = "ta_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(30) = "ta_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(31) = "ta_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(32) = "ta_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(33) = "ta_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(34) = "ta_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name13(35) = "ta_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name13(36) = "ta_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;cold tongue
    latN = 6
    latS = -6
    lonW = 180
    lonE = 270

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

    rTIO = new((/3,maxlag/), float)
    rTNA = new((/3,maxlag/), float)
    mnmx = new((/2,3,nmod+3,3/), float)
    mnmx!0 = "region"
    mnmx!1 = "variable"
    mnmx!2 = "member"
    mnmx!3 = "value"
    ndim = dimsizes(mnmx)

    do i = 0, nmod-1

        print(i + " ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
        in6 = addfile(in_path6 + in_name6(i), "r")
        in7 = addfile(in_path7 + in_name7(i), "r")
        in8 = addfile(in_path8 + in_name8(i), "r")
        in9 = addfile(in_path9 + in_name9(i), "r")
        in10 = addfile(in_path10 + in_name10(i), "r")
        in11 = addfile(in_path11 + in_name11(i), "r")
        in12 = addfile(in_path12 + in_name12(i), "r")
        in13 = addfile(in_path13 + in_name13(i), "r")

;get the time indexes
        time6 = in6->time
        time7 = in7->time
        time9 = in9->time
        time13 = in13->time
        year6 = cd_calendar(time6, -1) / 100
        year7 = cd_calendar(time7, -1) / 100
        year9 = cd_calendar(time9, -1) / 100
        year13 = cd_calendar(time13, -1) / 100
        iYYYY6 = ind(year6.ge.yS .and. year6.le.yE)
        iYYYY7 = ind(year7.ge.yS .and. year7.le.yE)
        iYYYY9 = ind(year9.ge.yS .and. year9.le.yE)
        iYYYY13 = ind(year13.ge.yS .and. year13.le.yE)

        ts = in6->ts(iYYYY6,:,:)
        uas = in7->uas(iYYYY7,:,:)
        vas = in8->vas(iYYYY7,:,:)
        rlds = in9->rlds(iYYYY9,:,:)
        rlus = in10->rlus(iYYYY9,:,:)
        rsds = in11->rsds(iYYYY9,:,:)
        rsus = in12->rsus(iYYYY9,:,:)
        nrs2 = (/rlus + rsus - rlds - rsds/)
        copy_VarCoords(rlds, nrs2)
        if(i.eq.12)then
            ta = in13->ta(iYYYY13,(/0,1,2,4,5,6,7,8,9,10/),:,:)
        else
            ta = in13->ta(iYYYY13,{:20000},:,:)
        end if
;        sst = lonFlip(in->ts)

        if(i.eq.0)then
            in1a = addfile(in_name1a, "r")
            in1b = addfile(in_name1b, "r")
            in1c = addfile(in_name1c, "r")
            in2 = addfile(in_name2, "r")
            in3 = addfile(in_name3, "r")
            in4 = addfile(in_name4, "r")
            in5 = addfile(in_name5, "r")
            time1a = in1a->time
            time1b = in1b->time
            time1c = in1c->time
            time2 = in2->time
            year1a = cd_calendar(time1a, -1) / 100
            year1b = cd_calendar(time1b, -1) / 100
            year1c = cd_calendar(time1c, -1) / 100
            year2 = cd_calendar(time2, -1) / 100
            iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
            iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
            iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
            iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
            sst1 = in1a->sst(iYYYY1a,:,:)
            sst2 = in1b->sst(iYYYY1b,:,:)
            sst3 = in1c->sst(iYYYY1c,:,:)
            wspd = in2->wspd(iYYYY2,:,:)
            nlwrs = in3->nlwrs(iYYYY2,:,:)
            nswrs = in4->nswrs(iYYYY2,:,:)
            nrs1 = (/nlwrs + nswrs/)
            copy_VarCoords(nlwrs, nrs1)
            air = in5->air(iYYYY2,{:200},:,:)

;-------------------------------------------------------------
;creat weights: cos(lat)
            rad = 4.0 * atan(1.0) / 180.0
            gw1 = in6->lat
            gw2 = in7->lat
            gw3 = in9->lat
            gw1 = cos(rad * gw1)
            gw2 = cos(rad * gw2)
            gw3 = cos(rad * gw3)
        end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;calculate the vertical mean
        if(i.eq.0)then
            dp_cfm = conform_dims(dimsizes(ta), dp, 1)
        end if
        TT2 = dim_sum_n(dp_cfm * ta / sumdp, 1)
        if(i.eq.0)then
            copy_VarMeta(ta(:,0,:,:), TT2)
        end if

;monthly anomalies
        uas = wind_speed(uas, vas)
        clm6 = clmMonTLL(ts)
        clm7 = clmMonTLL(uas)
        clm9 = clmMonTLL(nrs2)
        clm13 = clmMonTLL(TT2)
        tsA = calcMonAnomTLL(ts, clm6)
        uasA = calcMonAnomTLL(uas, clm7)
        nrsA2 = calcMonAnomTLL(nrs2, clm9)
        TTA2 = calcMonAnomTLL(TT2, clm13)
        tsA = (/dtrend_msg_n(tsA&time, tsA, False, False, 0)/)
        uasA = (/dtrend_msg_n(uasA&time, uasA, False, False, 0)/)
        nrsA2 = (/dtrend_msg_n(nrsA2&time, nrsA2, False, False, 0)/)
        TTA2 = (/dtrend_msg_n(TTA2&time, TTA2, False, False, 0)/)

;compute seasonal means
        tsA_S = month_to_season(tsA, season(0))
        uasA_S = month_to_seasonN(uasA, season)
        nrsA2_S = month_to_seasonN(nrsA2, season)
        TTA2_S = month_to_seasonN(TTA2, season)

;--------------------------------------------------------------
;cold tongue (NDJ)
        CTI2 = wgt_areaave_Wrap(tsA_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
        dim = dimsizes(CTI2)
;tropical Indian Ocean
        uas_TIO = wgt_areaave_Wrap(uasA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
        nrs2_TIO = wgt_areaave_Wrap(nrsA2_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw3({latN1:latS1}), 1.0, 0)
        TT2_TIO = wgt_areaave_Wrap(TTA2_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        uas_TNA = wgt_areaave_Wrap(uasA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
        nrs2_TNA = wgt_areaave_Wrap(nrsA2_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw3({latN2:latS2}), 1.0, 0)
        TT2_TNA = wgt_areaave_Wrap(TTA2_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
;compute linear regression
        rTIO(0,:) = (/regCoef(CTI2, uas_TIO)/)
        rTNA(0,:) = (/regCoef(CTI2, uas_TNA)/)
        rTIO(1,:) = (/regCoef(CTI2, nrs2_TIO)/)
        rTNA(1,:) = (/regCoef(CTI2, nrs2_TNA)/)
        rTIO(2,:) = (/regCoef(CTI2, TT2_TIO)/)
        rTNA(2,:) = (/regCoef(CTI2, TT2_TNA)/)
        rTIO(0,1:) = (/regCoef(CTI2(:dim-2), uas_TIO(1:,1:))/)
        rTNA(0,1:) = (/regCoef(CTI2(:dim-2), uas_TNA(1:,1:))/)
        rTIO(1,1:) = (/regCoef(CTI2(:dim-2), nrs2_TIO(1:,1:))/)
        rTNA(1,1:) = (/regCoef(CTI2(:dim-2), nrs2_TNA(1:,1:))/)
        rTIO(2,1:) = (/regCoef(CTI2(:dim-2), TT2_TIO(1:,1:))/)
        rTNA(2,1:) = (/regCoef(CTI2(:dim-2), TT2_TNA(1:,1:))/)

        inds = (/minind(rTIO(0,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, uas_TIO(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), uas_TIO(inds,1:))
        end if
        mnmx(0,0,i+3,0) = (/rc/)
        mnmx(0,0,i+3,1:) = (/rc@b95/)

        inds = (/minind(rTNA(0,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, uas_TNA(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), uas_TNA(inds,1:))
        end if
        mnmx(1,0,i+3,0) = (/rc/)
        mnmx(1,0,i+3,1:) = (/rc@b95/)

        inds = (/minind(rTIO(1,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, nrs2_TIO(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), nrs2_TIO(inds,1:))
        end if
        mnmx(0,1,i+3,0) = (/rc/)
        mnmx(0,1,i+3,1:) = (/rc@b95/)

        inds = (/minind(rTNA(1,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, nrs2_TNA(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), nrs2_TNA(inds,1:))
        end if
        mnmx(1,1,i+3,0) = (/rc/)
        mnmx(1,1,i+3,1:) = (/rc@b95/)

        inds = (/maxind(rTIO(2,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, TT2_TIO(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), TT2_TIO(inds,1:))
        end if
        mnmx(0,2,i+3,0) = (/rc/)
        mnmx(0,2,i+3,1:) = (/rc@b95/)

        inds = (/maxind(rTNA(2,:))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI2, TT2_TNA(inds,:))
        else 
            rc = regline_stats(CTI2(:dim-2), TT2_TNA(inds,1:))
        end if
        mnmx(1,2,i+3,0) = (/rc/)
        mnmx(1,2,i+3,1:) = (/rc@b95/)

        if(i.eq.0)then
            TT1 = dim_sum_n(dp_cfm * air / sumdp, 1)
            copy_VarMeta(air(:,0,:,:), TT1)
            clm1a = clmMonTLL(sst1)
            clm1b = clmMonTLL(sst2)
            clm1c = clmMonTLL(sst3)
            clm2 = clmMonTLL(wspd)
            clm3 = clmMonTLL(nrs1)
            clm5 = clmMonTLL(TT1)
            sstA1 = calcMonAnomTLL(sst1, clm1a)
            sstA2 = calcMonAnomTLL(sst2, clm1b)
            sstA3 = calcMonAnomTLL(sst3, clm1c)
            wspdA = calcMonAnomTLL(wspd, clm2)
            nrsA1 = calcMonAnomTLL(nrs1, clm3)
            TTA1 = calcMonAnomTLL(TT1, clm5)
            sstA1 = (/dtrend_msg_n(sstA1&time, sstA1, False, False, 0)/)
            sstA2 = (/dtrend_msg_n(sstA2&time, sstA2, False, False, 0)/)
            sstA3 = (/dtrend_msg_n(sstA3&time, sstA3, False, False, 0)/)
            wspdA = (/dtrend_msg_n(wspdA&time, wspdA, False, False, 0)/)
            nrsA1 = (/dtrend_msg_n(nrsA1&time, nrsA1, False, False, 0)/)
            TTA1 = (/dtrend_msg_n(TTA1&time, TTA1, False, False, 0)/)
            sstA1_S = month_to_season(sstA1, season(0))
            sstA2_S = month_to_season(sstA2, season(0))
            sstA3_S = month_to_season(sstA3, season(0))
            wspdA_S = month_to_seasonN(wspdA, season)
            nrsA1_S = month_to_seasonN(nrsA1, season)
            TTA1_S = month_to_seasonN(TTA1, season)
            CTI1 = wgt_areaave_Wrap(sstA1_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI2 = wgt_areaave_Wrap(sstA2_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI3 = wgt_areaave_Wrap(sstA3_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            wspd_TIO = wgt_areaave_Wrap(wspdA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            wspd_TNA = wgt_areaave_Wrap(wspdA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
            nrs1_TIO = wgt_areaave_Wrap(nrsA1_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw3({latN1:latS1}), 1.0, 0)
            nrs1_TNA = wgt_areaave_Wrap(nrsA1_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw3({latN2:latS2}), 1.0, 0)
            TT1_TIO = wgt_areaave_Wrap(TTA1_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            TT1_TNA = wgt_areaave_Wrap(TTA1_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
            rTIO(0,:) = (/regCoef(CTI1, wspd_TIO)/)
            rTNA(0,:) = (/regCoef(CTI1, wspd_TNA)/)
            rTIO(1,:) = (/regCoef(CTI1, nrs1_TIO)/)
            rTNA(1,:) = (/regCoef(CTI1, nrs1_TNA)/)
            rTIO(2,:) = (/regCoef(CTI1, TT1_TIO)/)
            rTNA(2,:) = (/regCoef(CTI1, TT1_TNA)/)
            rTIO(0,1:) = (/regCoef(CTI1(:dim-2), wspd_TIO(1:,1:))/)
            rTNA(0,1:) = (/regCoef(CTI1(:dim-2), wspd_TNA(1:,1:))/)
            rTIO(1,1:) = (/regCoef(CTI1(:dim-2), nrs1_TIO(1:,1:))/)
            rTNA(1,1:) = (/regCoef(CTI1(:dim-2), nrs1_TNA(1:,1:))/)
            rTIO(2,1:) = (/regCoef(CTI1(:dim-2), TT1_TIO(1:,1:))/)
            rTNA(2,1:) = (/regCoef(CTI1(:dim-2), TT1_TNA(1:,1:))/)
            inds = minind(rTIO(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, wspd_TIO(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), wspd_TIO(inds,1:))
            end if
            mnmx(0,0,0,0) = (/rc/)
            mnmx(0,0,0,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, wspd_TNA(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), wspd_TNA(inds,1:))
            end if
            mnmx(1,0,0,0) = (/rc/)
            mnmx(1,0,0,1:) = (/rc@b95/);***next***
            inds = minind(rTIO(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, nrs1_TIO(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), nrs1_TIO(inds,1:))
            end if
            mnmx(0,1,0,0) = (/rc/)
            mnmx(0,1,0,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, nrs1_TNA(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), nrs1_TNA(inds,1:))
            end if
            mnmx(1,1,0,0) = (/rc/)
            mnmx(1,1,0,1:) = (/rc@b95/);***next***
            inds = maxind(rTIO(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, TT1_TIO(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), TT1_TIO(inds,1:))
            end if
            mnmx(0,2,0,0) = (/rc/)
            mnmx(0,2,0,1:) = (/rc@b95/);***next***
            inds = maxind(rTNA(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI1, TT1_TNA(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), TT1_TNA(inds,1:))
            end if
            mnmx(1,2,0,0) = (/rc/)
            mnmx(1,2,0,1:) = (/rc@b95/)

            rTIO(0,:) = (/regCoef(CTI2, wspd_TIO)/)
            rTNA(0,:) = (/regCoef(CTI2, wspd_TNA)/)
            rTIO(1,:) = (/regCoef(CTI2, nrs1_TIO)/)
            rTNA(1,:) = (/regCoef(CTI2, nrs1_TNA)/)
            rTIO(2,:) = (/regCoef(CTI2, TT1_TIO)/)
            rTNA(2,:) = (/regCoef(CTI2, TT1_TNA)/)
            rTIO(0,1:) = (/regCoef(CTI2(:dim-2), wspd_TIO(1:,1:))/)
            rTNA(0,1:) = (/regCoef(CTI2(:dim-2), wspd_TNA(1:,1:))/)
            rTIO(1,1:) = (/regCoef(CTI2(:dim-2), nrs1_TIO(1:,1:))/)
            rTNA(1,1:) = (/regCoef(CTI2(:dim-2), nrs1_TNA(1:,1:))/)
            rTIO(2,1:) = (/regCoef(CTI2(:dim-2), TT1_TIO(1:,1:))/)
            rTNA(2,1:) = (/regCoef(CTI2(:dim-2), TT1_TNA(1:,1:))/)
            inds = minind(rTIO(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, wspd_TIO(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), wspd_TIO(inds,1:))
            end if
            mnmx(0,0,1,0) = (/rc/)
            mnmx(0,0,1,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, wspd_TNA(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), wspd_TNA(inds,1:))
            end if
            mnmx(1,0,1,0) = (/rc/)
            mnmx(1,0,1,1:) = (/rc@b95/);***next***
            inds = minind(rTIO(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, nrs1_TIO(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), nrs1_TIO(inds,1:))
            end if
            mnmx(0,1,1,0) = (/rc/)
            mnmx(0,1,1,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, nrs1_TNA(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), nrs1_TNA(inds,1:))
            end if
            mnmx(1,1,1,0) = (/rc/)
            mnmx(1,1,1,1:) = (/rc@b95/);***next***
            inds = maxind(rTIO(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, TT1_TIO(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), TT1_TIO(inds,1:))
            end if
            mnmx(0,2,1,0) = (/rc/)
            mnmx(0,2,1,1:) = (/rc@b95/);***next***
            inds = maxind(rTNA(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI2, TT1_TNA(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), TT1_TNA(inds,1:))
            end if
            mnmx(1,2,1,0) = (/rc/)
            mnmx(1,2,1,1:) = (/rc@b95/)

            rTIO(0,:) = (/regCoef(CTI3, wspd_TIO)/)
            rTNA(0,:) = (/regCoef(CTI3, wspd_TNA)/)
            rTIO(1,:) = (/regCoef(CTI3, nrs1_TIO)/)
            rTNA(1,:) = (/regCoef(CTI3, nrs1_TNA)/)
            rTIO(2,:) = (/regCoef(CTI3, TT1_TIO)/)
            rTNA(2,:) = (/regCoef(CTI3, TT1_TNA)/)
            rTIO(0,1:) = (/regCoef(CTI3(:dim-2), wspd_TIO(1:,1:))/)
            rTNA(0,1:) = (/regCoef(CTI3(:dim-2), wspd_TNA(1:,1:))/)
            rTIO(1,1:) = (/regCoef(CTI3(:dim-2), nrs1_TIO(1:,1:))/)
            rTNA(1,1:) = (/regCoef(CTI3(:dim-2), nrs1_TNA(1:,1:))/)
            rTIO(2,1:) = (/regCoef(CTI3(:dim-2), TT1_TIO(1:,1:))/)
            rTNA(2,1:) = (/regCoef(CTI3(:dim-2), TT1_TNA(1:,1:))/)
            inds = minind(rTIO(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, wspd_TIO(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), wspd_TIO(inds,1:))
            end if
            mnmx(0,0,2,0) = (/rc/)
            mnmx(0,0,2,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(0,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, wspd_TNA(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), wspd_TNA(inds,1:))
            end if
            mnmx(1,0,2,0) = (/rc/)
            mnmx(1,0,2,1:) = (/rc@b95/);***next***
            inds = minind(rTIO(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, nrs1_TIO(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), nrs1_TIO(inds,1:))
            end if
            mnmx(0,1,2,0) = (/rc/)
            mnmx(0,1,2,1:) = (/rc@b95/);***next***
            inds = minind(rTNA(1,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, nrs1_TNA(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), nrs1_TNA(inds,1:))
            end if
            mnmx(1,1,2,0) = (/rc/)
            mnmx(1,1,2,1:) = (/rc@b95/);***next***
            inds = maxind(rTIO(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, TT1_TIO(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), TT1_TIO(inds,1:))
            end if
            mnmx(0,2,2,0) = (/rc/)
            mnmx(0,2,2,1:) = (/rc@b95/);***next***
            inds = maxind(rTNA(2,:))
            if(inds.eq.0)then
                rc = regline_stats(CTI3, TT1_TNA(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), TT1_TNA(inds,1:))
            end if
            mnmx(1,2,2,0) = (/rc/)
            mnmx(1,2,2,1:) = (/rc@b95/)
        end if

        delete([/time6,time7,time9,time13,year6,year7,year9,year13/])

    end do

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","variable","member","value"/)
    dimSizes = ndim
    dimUnlim = (/False,False,False,False/)

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "variable", "integer", "variable")
    filevardef(fout, "member", "integer", "member")
    filevardef(fout, "value", "integer", "value")
    filevardef(fout, "mnmx", typeof(mnmx), getvardims(mnmx))

;Copy attributes associated with each variable to the file
;    filevarattdef(fout, "std", std)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->variable = ispan(1, 3, 1)
    fout->member = ispan(1, nmod+3, 1)
    fout->value = ispan(1, 3, 1)
    fout->mnmx = (/mnmx/)

else

    in = addfile(out_data, "r")
    mnmx = in->mnmx
    nmod = dimsizes(mnmx(0,0,:,0))-3

end if

printVarSummary(mnmx)
print((/mnmx(0,2,:,:)/))
mnmx(:,0,:,:) = (/10.0 * mnmx(:,0,:,:)/)
;mnmx(:,1,:,:) = (/10.0 * mnmx(:,1,:,:)/)
mnmx(:,2,:,:) = (/10.0 * mnmx(:,2,:,:)/)

; ==============================================================
; Mission 4. Draw the chart
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

mnmx(:,:,1:nmod,:) = (/mnmx(:,:,3:nmod+2,:)/)

do i = 0, nmod+0
    do j = 0,2
        if(j.eq.0)then
            res@trYMaxF = 2.0
            res@trYMinF = -8.0
        else if(j.eq.1)then
            res@trYMaxF = 2.0
            res@trYMinF = -8.0
        else
            res@trYMaxF = 8.5
            res@trYMinF = 0.5
        end if
        end if
        res@gsnYRefLine = mnmx(0,j,i,0)
        res@gsnAboveYRefLineColor = colors(0)
        res@gsnBelowYRefLineColor = colors(1)
        res@tiYAxisString = text3(j)
        res@tiXAxisString = text3(3)
        if(i.eq.0)then
            res@gsnLeftString = text1(j)
            if(j.eq.2)then
                res@gsnCenterString = text2
            end if
            plot(j) = gsn_csm_xy(wks, i-0.175, mnmx(0,j,i,1), res)
            delete(res@gsnLeftString)
            delete(res@gsnCenterString)
            max_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,j,i,2), res)
            overlay(plot(j), max_plot(0,j,i))
        else
            min_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,j,i,1), res)
            max_plot(0,j,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,j,i,2), res)
            overlay(plot(j), min_plot(0,j,i))
            overlay(plot(j), max_plot(0,j,i))
        end if
        res@gsnYRefLine = mnmx(1,j,i,0)
        res@gsnAboveYRefLineColor = colors(2)
        res@gsnBelowYRefLineColor = colors(3)
        min_plot(1,j,i) = gsn_csm_xy(wks, i+0.175, mnmx(1,j,i,1), res)
        max_plot(1,j,i) = gsn_csm_xy(wks, i+0.175, mnmx(1,j,i,2), res)
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
    dum(0,0,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(0,i,0,0),mnmx(0,i,0,0)/), resl)
    dum(0,1,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(0,i,0,1),mnmx(0,i,0,1)/), resl)
    dum(0,2,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(0,i,0,2),mnmx(0,i,0,2)/), resl)
end do
resl@gsLineDashPattern = 5
resl@gsLineColor = colors(3)
do i = 0, 2
    dum(1,0,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(1,i,0,0),mnmx(1,i,0,0)/), resl)
    dum(1,1,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(1,i,0,1),mnmx(1,i,0,1)/), resl)
    dum(1,2,i) = gsn_add_polyline(wks, plot(i), (/res@trXMinF,res@trXMaxF/), (/mnmx(1,i,0,2),mnmx(1,i,0,2)/), resl)
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

resP@txString = "Max Regression of Parameters onto NDJ CTI"
resP@txFontHeightF = 0.025
resP@gsnPanelBottom = 0.1

gsn_panel(wks,plot((/2,0,1/)),(/3,1/),resP)

end
