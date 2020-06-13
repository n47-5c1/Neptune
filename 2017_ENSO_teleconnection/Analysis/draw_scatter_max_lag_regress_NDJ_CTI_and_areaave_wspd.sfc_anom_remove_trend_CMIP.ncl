;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly surface wind speed anomalies removed
;     trend in the tropical Indian Ocean as well as in the tropical North Atlantic onto NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2018-02-05
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------wspd.sfc
;   var3--------------ts
;   var4--------------uas
;   var5--------------vas
;================================================

process = True

;time
yS = 1958
yE = 2004
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
maxlag = dimsizes(season)

;Fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP"

;text
text1 = (/"Surface",yS+"-"+yE,"m~F34~W~F~s~S~-1~N~/~F35~J~F~C"/)
text2 = (/"TNA","TIO"/)
text3 = (/"OBS","MMM","Model Samples"/)

x = (/.24,.24,.24/)
y = (/.76,.72,.68/)
colors = (/"red","blue","black"/)
sizes = (/.025,.025,.04/)
indexes = (/5,5,1/)
thicknesses = (/5,5,1/)

if(process)then

;HadISST1 1870/01 - , 1x1
    in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
    in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"

    in_path3 = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3 = new(37, string)
    in_name3(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(2) = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(3) = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(4) = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(5) = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;   in_name3(6) = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;   in_name3(7) = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;   in_name3(9) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;   in_name3(8) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;   in_name3(9) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(15) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(17) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name3(17) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name3(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name3(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes(in_name3)

    in_path4 = "~/data-model/CMIP5-hes/uas/historical/"
    in_name4 = new(nmod, string)
    in_name4(0) = "uas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1) = "uas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2) = "uas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(2) = "uas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(3) = "uas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(4) = "uas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(3) = "uas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(5) = "uas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6) = "uas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7) = "uas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8) = "uas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9) = "uas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "uas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "uas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "uas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "uas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(8)  = "uas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(9)  = "uas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(15) = "uas_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(10) = "uas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(17) = "uas_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "uas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name4(12) = "uas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(13) = "uas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "uas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(15) = "uas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "uas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "uas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "uas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "uas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name4(17) = "uas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(20) = "uas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(21) = "uas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(22) = "uas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(23) = "uas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(24) = "uas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(25) = "uas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(26) = "uas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(27) = "uas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(28) = "uas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(29) = "uas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(30) = "uas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(31) = "uas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(32) = "uas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(33) = "uas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(34) = "uas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name4(35) = "uas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(36) = "uas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path5 = "~/data-model/CMIP5-hes/vas/historical/"
    in_name5 = new(nmod, string)
    in_name5(0) = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(1) = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(2) = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(2) = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(3) = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(4) = "vas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name5(3) = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(5) = "vas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(6) = "vas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(7) = "vas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(8) = "vas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(9) = "vas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(4) = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(5) = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(6) = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(7) = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(8) = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(9) = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(15) = "vas_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name5(10) = "vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(17) = "vas_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(11) = "vas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name5(12) = "vas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name5(13) = "vas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name5(14) = "vas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name5(15) = "vas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(16) = "vas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(17) = "vas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(18) = "vas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(19) = "vas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name5(17) = "vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name5(20) = "vas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(21) = "vas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(22) = "vas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(23) = "vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(24) = "vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(25) = "vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(26) = "vas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name5(27) = "vas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name5(28) = "vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(29) = "vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(30) = "vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(31) = "vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(32) = "vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(33) = "vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(34) = "vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name5(35) = "vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(36) = "vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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

    rTIO2 = new((/maxlag,nmod/), float)
    rTNA2 = new((/maxlag,nmod/), float)
    mnmx = new((/2,nmod+4/), float)

    do i = 0, nmod-1

        print(i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

        in3 = addfile(in_path3 + in_name3(i), "r")
        in4 = addfile(in_path4 + in_name4(i), "r")
        in5 = addfile(in_path5 + in_name5(i), "r")

;get the time indexes
        time3  = in3->time
        time4  = in4->time
        year3  = cd_calendar(time3, -1) / 100
        year4  = cd_calendar(time4, -1) / 100
        iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
        iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)

        ts = in3->ts(iYYYY3,:,:)
        uas = in4->uas(iYYYY4,:,:)
        vas = in5->vas(iYYYY4,:,:)
;        sst = lonFlip(in->ts(iYYYY,{latN:latS},:))

        if(i.eq.0)then
            in1a = addfile(in_name1a, "r")
            in1b = addfile(in_name1b, "r")
            in1c = addfile(in_name1c, "r")
            in2 = addfile(in_name2, "r")
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

;-------------------------------------------------------------
;creat weights: cos(lat)
            rad = 4.0 * atan(1.0) / 180.0
            gw1 = in3->lat
            gw2 = in4->lat
            gw1 = cos(rad * gw1)
            gw2 = cos(rad * gw2)
        end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;monthly anomalies
        uas = wind_speed(uas, vas)
        clm3 = clmMonTLL(ts)
        clm4 = clmMonTLL(uas)
        tsA = calcMonAnomTLL(ts, clm3)
        uasA = calcMonAnomTLL(uas, clm4)
        tsA = (/dtrend_msg_n(tsA&time, tsA, False, False, 0)/)
        uasA = (/dtrend_msg_n(uasA&time, uasA, False, False, 0)/)

;compute seasonal means
        tsA_S = month_to_season(tsA, season(0))
        uasA_S = month_to_seasonN(uasA, season)

;--------------------------------------------------------------
;cold tongue (NDJ)
        CTI2 = wgt_areaave_Wrap(tsA_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
        dim = dimsizes(CTI2)
;tropical Indian Ocean
        TIO2 = wgt_areaave_Wrap(uasA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        TNA2 = wgt_areaave_Wrap(uasA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
;compute linear regression
        rTIO2(:,i) = (/regCoef(CTI2, TIO2)/)
        rTNA2(:,i) = (/regCoef(CTI2, TNA2)/)
        rTIO2(1:,i) = (/regCoef(CTI2(:dim-2), TIO2(1:,1:))/)
        rTNA2(1:,i) = (/regCoef(CTI2(:dim-2), TNA2(1:,1:))/)

        if(i.eq.0)then
            copy_VarMeta(TIO2, rTIO2(:,0))
            copy_VarMeta(TNA2, rTNA2(:,0))

            clm1a = clmMonTLL(sst1)
            clm1b = clmMonTLL(sst2)
            clm1c = clmMonTLL(sst3)
            clm2 = clmMonTLL(wspd)
            sstA1 = calcMonAnomTLL(sst1, clm1a)
            sstA2 = calcMonAnomTLL(sst2, clm1b)
            sstA3 = calcMonAnomTLL(sst3, clm1c)
            wspdA = calcMonAnomTLL(wspd, clm2)
            sstA1 = (/dtrend_msg_n(sstA1&time, sstA1, False, False, 0)/)
            sstA2 = (/dtrend_msg_n(sstA2&time, sstA2, False, False, 0)/)
            sstA3 = (/dtrend_msg_n(sstA3&time, sstA3, False, False, 0)/)
            wspdA = (/dtrend_msg_n(wspdA&time, wspdA, False, False, 0)/)
            sstA1_S = month_to_season(sstA1, season(0))
            sstA2_S = month_to_season(sstA2, season(0))
            sstA3_S = month_to_season(sstA3, season(0))
            wspdA_S = month_to_seasonN(wspdA, season)
            CTI1a = wgt_areaave_Wrap(sstA1_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI1b = wgt_areaave_Wrap(sstA2_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI1c = wgt_areaave_Wrap(sstA3_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            TIO1 = wgt_areaave_Wrap(wspdA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1.0, 0)
            TNA1 = wgt_areaave_Wrap(wspdA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1.0, 0)
            rTIO1a = regCoef(CTI1a, TIO1)
            rTIO1b = regCoef(CTI1b, TIO1)
            rTIO1c = regCoef(CTI1c, TIO1)
            rTNA1a = regCoef(CTI1a, TNA1)
            rTNA1b = regCoef(CTI1b, TNA1)
            rTNA1c = regCoef(CTI1c, TNA1)
            rTIO1a(1:) = regCoef(CTI1a(:dim-2), TIO1(1:,1:) )
            rTIO1b(1:) = regCoef(CTI1b(:dim-2), TIO1(1:,1:) )
            rTIO1c(1:) = regCoef(CTI1c(:dim-2), TIO1(1:,1:) )
            rTNA1a(1:) = regCoef(CTI1a(:dim-2), TNA1(1:,1:) )
            rTNA1b(1:) = regCoef(CTI1b(:dim-2), TNA1(1:,1:) )
            rTNA1c(1:) = regCoef(CTI1c(:dim-2), TNA1(1:,1:) )
            copy_VarCoords(TIO1, rTIO1a)
            copy_VarCoords(TIO1, rTIO1b)
            copy_VarCoords(TIO1, rTIO1c)
            copy_VarCoords(TNA1, rTNA1a)
            copy_VarCoords(TNA1, rTNA1b)
            copy_VarCoords(TNA1, rTNA1c)
        end if

        delete([/time3,time4,year3,year4/])

    end do

    mnmx(:,0)  = dim_min((/rTIO1a,rTNA1a/))
    mnmx(:,1)  = dim_min((/rTIO1b,rTNA1b/))
    mnmx(:,2)  = dim_min((/rTIO1c,rTNA1c/))
    mnmx(:,4:) = dim_min_n((/rTIO2,rTNA2/), 1)
    mnmx(:,3)  = dim_avg(mnmx(:,4:))
    std = dim_stddev_Wrap(mnmx(:,4:))
    mnmx!0 = "region"
    mnmx!1 = "member"
    std!0 = "region"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    ndim = dimsizes(mnmx)

    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","member"/)
    dimSizes = ndim
    dimUnlim = (/False,False/)   

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "member", "integer", "member")
    filevardef(fout, "mnmx", typeof(mnmx), getvardims(mnmx))
    filevardef(fout, "std", typeof(std), getvardims(std))

;Copy attributes associated with each variable to the file
    filevarattdef(fout, "std", std)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->member = ispan(1, nmod+4, 1)
    fout->mnmx = (/mnmx/)
    fout->std = (/std/)

else

    in = addfile(out_data, "r")
    mnmx = in->mnmx
    std = in->std

end if

printVarSummary(mnmx)
printVarSummary(std)
print((/mnmx(:,:3)/))
; print ( ind( mnmx(1,2:).lt.-.4 ) )
; print ( (/mnmx(1, ind(mnmx(1,:).lt.-.4) )/) )
exit
; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = text1(0)
res@gsnCenterString = text1(1)
res@gsnRightString = text1(2)
res@gsnStringFontHeightF = .024

res@tiYAxisString = text2(0)
res@tiXAxisString = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString = "Max Regression of Regional WSPD onto NDJ CTI"
res@tiMainFontHeightF = .028

res@trYMaxF = 0.2
res@trYMinF = -0.25
res@trXMaxF = 0.05
res@trXMinF = -0.4

res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

res@xyMarkLineMode = "Markers"
res@xyMarker = indexes(2)
res@xyMarkerSizeF = sizes(2)
res@xyMarkerThicknessF = 2
plot = gsn_csm_xy(wks, mnmx(0,2:), mnmx(1,2:), res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2
resl@gsLineDashPattern = 1
duma = gsn_add_polyline(wks, plot, (/-0.4,0.3/),(/-0.4,0.3/), resl)
dumb = gsn_add_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(1,0),mnmx(1,0)/), resl)
dumc = gsn_add_polyline(wks, plot, (/mnmx(0,0),mnmx(0,0)/), (/res@trYMinF,res@trYMaxF/), resl)
resl@gsLineColor = colors(1)
resl@gsLineThicknessF = 3
resl@gsLineDashPattern = 0
a = (res@trYMaxF - res@trYMinF) / 50.0
dum1 = gsn_add_polyline(wks, plot, (/mnmx(0,1) - std(0),mnmx(0,1) + std(0)/), (/mnmx(1,1),mnmx(1,1)/), resl)
dum2 = gsn_add_polyline(wks, plot, (/mnmx(0,1),mnmx(0,1)/), (/mnmx(1,1) - std(1),mnmx(1,1) + std(1)/), resl)
dum3 = gsn_add_polyline(wks, plot, (/mnmx(0,1) - std(0),mnmx(0,1) - std(0)/), (/mnmx(1,1) - a,mnmx(1,1) + a/), resl)
dum4 = gsn_add_polyline(wks, plot, (/mnmx(0,1) + std(0),mnmx(0,1) + std(0)/), (/mnmx(1,1) - a,mnmx(1,1) + a/), resl)
dum5 = gsn_add_polyline(wks, plot, (/mnmx(0,1) - a,mnmx(0,1) + a/), (/mnmx(1,1) - std(1),mnmx(1,1) - std(1)/), resl)
dum6 = gsn_add_polyline(wks, plot, (/mnmx(0,1) - a,mnmx(0,1) + a/), (/mnmx(1,1) + std(1),mnmx(1,1) + std(1)/), resl)

;--------------------------------------------------------------
reso = True
reso@gsnDraw = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkers = indexes
reso@xyMarkerSizes = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknesses = thicknesses
plot1 = gsn_csm_xy(wks, transpose((/mnmx(0,0:1),mnmx(0,0:1)/)), transpose((/mnmx(1,0:1),mnmx(1,0:1)/)) ,reso)

overlay(plot, plot1)

draw(plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0, 2
    gsres@gsMarkerSizeF = sizes(i)
    gsres@gsMarkerColor = colors(i)
    gsres@gsMarkerIndex = indexes(i)
    gsres@gsMarkerThicknessF = thicknesses(i)
    gsn_polymarker_ndc(wks, x(i), y(i), gsres)
end do

txres = True
txres@txJust = "CenterLeft"
txres@txFontHeightF = 0.018
gsn_text_ndc(wks, text3, x+0.025, y, txres)

frame(wks)

end
