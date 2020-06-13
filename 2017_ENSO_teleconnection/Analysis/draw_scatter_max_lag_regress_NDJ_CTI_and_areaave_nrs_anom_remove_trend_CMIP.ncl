;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly net surface radiation
;     removed trend in the tropical Indian Ocean as well as in the tropical North Atlantic onto NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2017-01-08
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------nlwrs
;   var3--------------nswrs
;   var4--------------ts
;   var5--------------rlds
;   var6--------------rlus
;   var7--------------rsds
;   var8--------------rsus
;================================================

process = True

;time
yS = 1958
yE = 2004
;yS1 = 1979
;yE1 = 2016
;yS2 = 1984
;yE2 = 2008
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
maxlag = dimsizes(season)

;Fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP"

;text
text1 = (/yS+"-"+yE,"W~F34~W~F~m~S~-2~N~/~F35~J~F~C"/)
text2 = (/"TNA","TIO"/)
text3 = (/"NCEP/NCAR","ERA5","ISCCP","MMM","Samples"/)

x = (/0.24,0.24,0.24,0.24,0.24/)
y = (/0.76,0.72,0.68,0.64,0.6/)
colors = (/"red","green","blue","grey","black"/)
sizes = (/0.025,0.025,0.025,0.025,0.04/)
indexes = (/5,5,5,5,1/)
thicknesses = (/5.5,5.5,5.5,5.5,1/)

if(process)then

;HadISST1 1870/01 - , 1x1
in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 1948/01 - , T64
in_name2a = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
in_name3a = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"
;ERA5 1979/01 - 2018/12, 0.25x0.25
in_name2b = "~/data/observation/ERA5/mslhf.msnlwrf.msnswrf.msshf.1979-2018.mon.mean.nc"
;oaflux 1984/01 - 2008/12, 1x1
in_path = "~/data/observation/oaflux/"
in_name2c = "lw/lw_isccp_*.nc"
in_name3c = "sw/sw_isccp_*.nc"
/;
;20thCRV2 1871/01 - 2012/12, T62
    in_name2b = "~/data/observation/20thCRV2/dlwrf.sfc.mon.mean.nc"
    in_name3b = "~/data/observation/20thCRV2/dswrf.sfc.mon.mean.nc"
    in_name22b = "~/data/observation/20thCRV2/ulwrf.sfc.mon.mean.nc"
    in_name32b = "~/data/observation/20thCRV2/uswrf.sfc.mon.mean.nc"
;/
    in_name4 = new(37, string)
    in_name5 = new(37, string)
    in_name6 = new(37, string)
    in_name7 = new(37, string)
    in_name8 = new(37, string)

    in_path1 = "~/data-model/CMIP5-hes/ts/historical/"
    in_name4(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(3) = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(4) = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(5) = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name4(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(3) = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(7) = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(4) = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(9) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(7) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name4(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name4(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name4(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name4(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name4(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name4(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name4(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name4(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name4(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes(in_name4)

    in_path2 = "~/data-model/CMIP5-hes/rlds/historical/"
    in_name5(0) = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(1) = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(2) = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name5(2) = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name5(3) = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(3) = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(4) = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(4) = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(5) = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(6) = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(7) = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(8) = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(9) = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(7) = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(10) = "rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(11) = "rlds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name5(12) = "rlds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name5(13) = "rlds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name5(14) = "rlds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name5(15) = "rlds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(16) = "rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name5(17) = "rlds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(18) = "rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name5(19) = "rlds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name5(20) = "rlds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name5(21) = "rlds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name5(22) = "rlds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(23) = "rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(24) = "rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(25) = "rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(26) = "rlds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name5(27) = "rlds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name5(28) = "rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(29) = "rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(30) = "rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(31) = "rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(32) = "rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(33) = "rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(34) = "rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name5(35) = "rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(36) = "rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path3 = "~/data-model/CMIP5-hes/rlus/historical/"
    in_name6(0) = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(1) = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(2) = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name6(2) = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name6(3) = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(3) = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(4) = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(4) = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(5) = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(6) = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(7) = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(8) = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(9) = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(7) = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(10) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(11) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name6(12) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name6(13) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name6(14) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name6(15) = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(16) = "rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name6(17) = "rlus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(18) = "rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name6(19) = "rlus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name6(20) = "rlus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name6(21) = "rlus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name6(22) = "rlus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(23) = "rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(24) = "rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(25) = "rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(26) = "rlus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name6(27) = "rlus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name6(28) = "rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(29) = "rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(30) = "rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(31) = "rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(32) = "rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(33) = "rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(34) = "rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name6(35) = "rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(36) = "rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path4 = "~/data-model/CMIP5-hes/rsds/historical/"
    in_name7(0) = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(1) = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(2) = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name7(3) = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name7(3) = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(4) = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(5) = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(4) = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(5) = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(6) = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(7) = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(8) = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(9) = "rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(10) = "rsds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(10) = "rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(11) = "rsds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name7(12) = "rsds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name7(13) = "rsds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name7(14) = "rsds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name7(15) = "rsds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(16) = "rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name7(17) = "rsds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(18) = "rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name7(19) = "rsds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name7(20) = "rsds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name7(21) = "rsds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name7(22) = "rsds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(23) = "rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(24) = "rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(25) = "rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(26) = "rsds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name7(27) = "rsds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name7(28) = "rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(29) = "rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(30) = "rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(31) = "rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(32) = "rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(33) = "rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(34) = "rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name7(35) = "rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(36) = "rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path5 = "~/data-model/CMIP5-hes/rsus/historical/"
    in_name8(0) = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(1) = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(2) = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(3) = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name8(3) = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(4) = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(5) = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(4) = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(5) = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(6) = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(7) = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(8) = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(9) = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(10) = "rsus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(10) = "rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(11) = "rsus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name8(12) = "rsus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name8(13) = "rsus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(14) = "rsus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(15) = "rsus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(16) = "rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(17) = "rsus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(18) = "rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(19) = "rsus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name8(20) = "rsus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(21) = "rsus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(22) = "rsus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(23) = "rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(24) = "rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(25) = "rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(26) = "rsus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name8(27) = "rsus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name8(28) = "rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(29) = "rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(30) = "rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(31) = "rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(32) = "rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(33) = "rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(34) = "rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name8(35) = "rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(36) = "rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

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

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

    rTIO = new((/maxlag,nmod/), float)
    rTNA = new((/maxlag,nmod/), float)
    mnmx = new((/2,nmod+4/), float)

    do i = 0, nmod-1

        print (i+" step...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
        in4 = addfile(in_path1 + in_name4(i), "r")
        in5 = addfile(in_path2 + in_name5(i), "r")
        in6 = addfile(in_path3 + in_name6(i), "r")
        in7 = addfile(in_path4 + in_name7(i), "r")
        in8 = addfile(in_path5 + in_name8(i), "r")

;get the time indexes
        time4 = in4->time
        time5 = in5->time
        year4 = cd_calendar(time4, -1) / 100
        year5 = cd_calendar(time5, -1) / 100
        iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)
        iYYYY5 = ind(year5.ge.yS .and. year5.le.yE)

        sst = in4->ts(iYYYY4,:,:)
        rlds = in5->rlds(iYYYY5,:,:)
        rlus = in6->rlus(iYYYY5,:,:)
        rsds = in7->rsds(iYYYY5,:,:)
        rsus = in8->rsus(iYYYY5,:,:)
        nrs = (/rlus + rsus - rlds - rsds/)
        copy_VarCoords(rlds, nrs)
;        sst = lonFlip(in->ts(iYYYY,{latN:latS},:))

        if(i.eq.0)then 
            in1a = addfile(in_name1a, "r")
            in1b = addfile(in_name1b, "r")
            in1c = addfile(in_name1c, "r")
            in2a = addfile(in_name2a, "r")
            in3a = addfile(in_name3a, "r")
/;
            in2b = addfile(in_name2b, "r")
            files2c = systemfunc("ls " + in_path + in_name2c)
            files3c = systemfunc("ls " + in_path + in_name3c)
            setfileoption("nc", "SuppressClose", False)   ;close too many files
            in2c = addfiles(files2c, "r")
            in3c = addfiles(files3c, "r")
            ListSetType(in2c, "cat")
            ListSetType(in3c, "cat")

            in3b = addfile(in_name3b, "r")
            in22b = addfile(in_name22b, "r")
            in32b = addfile(in_name32b, "r")
;/
            time1a = in1a->time
            time1b = in1b->time
            time1c = in1c->time
            time2a = in2a->time
;            time2b = in2b->time
            year1a = cd_calendar(time1a, -1) / 100
            year1b = cd_calendar(time1b, -1) / 100
            year1c = cd_calendar(time1c, -1) / 100
            year2a = cd_calendar(time2a, -1) / 100
;            year2b = cd_calendar(time2b, -1) / 100
;            year2c = yyyymm_time(yS2, yE2, "integer") / 100
            iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
            iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
            iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
            iYYYY2a = ind(year2a.ge.yS .and. year2a.le.yE)
;            iYYYY2b = ind(year2b.ge.yS1 .and. year2b.le.yE1)
;            iYYYY2c = ind(year2c.ge.yS2 .and. year2c.le.yE2)
            sst1 = in1a->sst(iYYYY1a,:,:)
            sst2 = in1b->sst(iYYYY1b,:,:)
            sst3 = in1c->sst(iYYYY1c,:,:)
            nlwrs = in2a->nlwrs(iYYYY2a,:,:)
            nswrs = in3a->nswrs(iYYYY2a,:,:)
            nrsa = (/nlwrs + nswrs/)
            copy_VarCoords(nlwrs, nrsa)
/;
            msnlwrf = short2flt(in2b->msnlwrf(iYYYY2b,{30:-30},:))
            msnswrf = short2flt(in2b->msnswrf(iYYYY2b,{30:-30},:))
            nrsb = (/-msnlwrf - msnswrf/)
            copy_VarCoords(msnlwrf, nrsb)
            nlwrs2 = short2flt(in2c[:]->nlwrs(iYYYY2c,:,:))
            nswrs2 = short2flt(in3c[:]->nswrs(iYYYY2c,:,:))
            nrsc = (/nlwrs2 - nswrs2/)
            copy_VarCoords(nlwrs2, nrsc)
            nrsc&lon@units = "degreeE"
            nrsc&lat@units = "degreeN"

            dlwrf = in2b->dlwrf(iYYYY2b,:,:)
            dswrf = in3b->dswrf(iYYYY2b,:,:)
            ulwrf = in22b->ulwrf(iYYYY2b,:,:)
            uswrf = in32b->uswrf(iYYYY2b,:,:)
            nrsb = (/ulwrf + uswrf - dlwrf - dswrf/)
            copy_VarCoords(dlwrf, nrsb)
;/
;-------------------------------------------------------------
;creat weights: cos(lat)
            rad = 4.0 * atan(1.0) / 180.0
            gw1 = in1a->lat
            gw2a = in2a->lat
;            gw2b = in2b->latitude
;            gw2c = in2c[0]->lat
            gw1 = cos(rad * gw1)
            gw2a = cos(rad * gw2a)
;            gw2b = cos(rad * gw2b)
;            gw2c = cos(rad * gw2c)
        end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;monthly anomalies
        clm3 = clmMonTLL(sst)
        clm4 = clmMonTLL(nrs)
        SSTA = calcMonAnomTLL(sst, clm3)
        nrsA = calcMonAnomTLL(nrs, clm4)
        SSTA = (/dtrend_msg_n(SSTA&time, SSTA, False, False, 0)/)
        nrsA = (/dtrend_msg_n(nrsA&time, nrsA, False, False, 0)/)

;compute seasonal means
        SSTA_NDJ = month_to_season(SSTA, season(0))
        nrsA_3M = month_to_seasonN(nrsA, season)

;--------------------------------------------------------------
;cold tongue (NDJ)
        CTI = wgt_areaave_Wrap(SSTA_NDJ(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
        dim = dimsizes(CTI)
;tropical Indian Ocean
        TIO = wgt_areaave_Wrap(nrsA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2a({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        TNA = wgt_areaave_Wrap(nrsA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2a({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
;compute linear regression
        rTIO(:,i) = (/regCoef(CTI, TIO)/)
        rTNA(:,i) = (/regCoef(CTI, TNA)/)
        rTIO(1:,i) = (/regCoef(CTI(:dim-2), TIO(1:,1:))/)
        rTNA(1:,i) = (/regCoef(CTI(:dim-2), TNA(1:,1:))/)

        if(i.eq.0)then
            copy_VarCoords(TIO, rTIO(:,0))
            copy_VarCoords(TNA, rTNA(:,0))

            clm1a = clmMonTLL(sst1)
            clm1b = clmMonTLL(sst2)
            clm1c = clmMonTLL(sst3)
            clm2a = clmMonTLL(nrsa)
;            clm2b = clmMonTLL(nrsb)
;            clm2c = clmMonTLL(nrsc)
            SSTA1 = calcMonAnomTLL(sst1, clm1a)
            SSTA2 = calcMonAnomTLL(sst2, clm1b)
            SSTA3 = calcMonAnomTLL(sst3, clm1c)
            nrsAa = calcMonAnomTLL(nrsa, clm2a)
;            nrsAb = calcMonAnomTLL(nrsb, clm2b)
;            nrsAc = calcMonAnomTLL(nrsc, clm2c)
            SSTA1 = (/dtrend_msg_n(SSTA1&time, SSTA1, False, False, 0)/)
            SSTA2 = (/dtrend_msg_n(SSTA2&time, SSTA2, False, False, 0)/)
            SSTA3 = (/dtrend_msg_n(SSTA3&time, SSTA3, False, False, 0)/)
            nrsAa = (/dtrend_msg_n(nrsAa&time, nrsAa, False, False, 0)/)
;            nrsAb = (/dtrend_msg_n(nrsAb&time, nrsAb, False, False, 0)/)
;            nrsAc = (/dtrend_msg_n(nrsAc&time, nrsAc, False, False, 0)/)
            SSTA1_NDJ = month_to_season(SSTA1, season(0))
            SSTA2_NDJ = month_to_season(SSTA2, season(0))
            SSTA3_NDJ = month_to_season(SSTA3, season(0))
            nrsAa_3M = month_to_seasonN(nrsAa, season)
;            nrsAb_3M = month_to_seasonN(nrsAb, season)
;            nrsAc_3M = month_to_seasonN(nrsAc, season)
            CTI1 = wgt_areaave_Wrap(SSTA1_NDJ(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI2 = wgt_areaave_Wrap(SSTA2_NDJ(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            CTI3 = wgt_areaave_Wrap(SSTA3_NDJ(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1.0, 0)
            TIOa = wgt_areaave_Wrap(nrsAa_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2a({latN1:latS1}), 1.0, 0)
;            TIOb = wgt_areaave_Wrap(nrsAb_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2b({latN1:latS1}), 1.0, 0)
;            TIOc = wgt_areaave_Wrap(nrsAc_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2c({latN1:latS1}), 1.0, 0)
            TNAa = wgt_areaave_Wrap(nrsAa_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2a({latN2:latS2}), 1.0, 0)
;            TNAb = wgt_areaave_Wrap(nrsAb_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2b({latN2:latS2}), 1.0, 0)
;            TNAc = wgt_areaave_Wrap(nrsAc_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2c({latN2:latS2}), 1.0, 0)
            rTIOa = regCoef(CTI1, TIOa)
            rTIOb = regCoef(CTI2, TIOa)
            rTIOc = regCoef(CTI3, TIOa)
            rTNAa = regCoef(CTI1, TNAa)
            rTNAb = regCoef(CTI2, TNAa)
            rTNAc = regCoef(CTI3, TNAa)
            rTIOa(1:) = regCoef(CTI1(:dim-2), TIOa(1:,1:))
            rTIOb(1:) = regCoef(CTI2(:dim-2), TIOa(1:,1:))
            rTIOc(1:) = regCoef(CTI3(:dim-2), TIOa(1:,1:))
            rTNAa(1:) = regCoef(CTI1(:dim-2), TNAa(1:,1:))
            rTNAb(1:) = regCoef(CTI2(:dim-2), TNAa(1:,1:))
            rTNAc(1:) = regCoef(CTI3(:dim-2), TNAa(1:,1:))
            copy_VarCoords(TIOa, rTIOa)
            copy_VarCoords(TIOa, rTIOb)
            copy_VarCoords(TIOa, rTIOc)
            copy_VarCoords(TNAa, rTNAa)
            copy_VarCoords(TNAa, rTNAb)
            copy_VarCoords(TNAa, rTNAc)
        end if

        delete([/time4,year4,time5,year5/])

    end do

    mnmx = new((/2,nmod+4/), float)
    mnmx(:,0) = dim_min((/rTIOa,rTNAa/))
    mnmx(:,1) = dim_min((/rTIOb,rTNAb/))
    mnmx(:,2) = dim_min((/rTIOc,rTNAc/))
    mnmx(:,4:) = dim_min_n((/rTIO,rTNA/), 1)
    mnmx(:,3) = dim_avg(mnmx(:,4:))
    std = dim_stddev_Wrap(mnmx(:,4:))
    mnmx!0 = "region"
    mnmx!1 = "member"
    std!0 = "region"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    ndim = dimsizes(mnmx)

    system ("rm -f " + out_data)
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
; print ( ind( abs( mnmx(0,3:)-mnmx(0,0) ).lt.1.5*std(0) .and. abs( mnmx(1,3:)-mnmx(1,0) ).lt.1.5*std(1) ) )
; print ( (/mnmx(0, ind(mnmx(0,:).lt.-7.) )/) )
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
res@gsnCenterString = text1(0)
res@gsnRightString = text1(1)
res@gsnStringFontHeightF = 0.024

res@tiYAxisString = text2(0)
res@tiXAxisString = text2(1)
res@tiXAxisFontHeightF = 0.023
res@tiMainString = "Max Regression of Regional NRS onto NDJ CTI"
res@tiMainFontHeightF  = 0.028

res@trYMaxF = 3.0
res@trYMinF = -7.0
res@trXMaxF = 1.0
res@trXMinF = -9.0

res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

res@xyMarkLineMode = "Markers"
res@xyMarker = indexes(4)
res@xyMarkerSizeF = sizes(4)
;res@xyMarkerColor  = "black"
plot = gsn_csm_xy(wks, mnmx(0,4:), mnmx(1,4:), res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2
resl@gsLineDashPattern = 1
duma = gsn_add_polyline(wks, plot, (/-7.0,1.0/),(/-7.0,1.0/), resl)
resl@gsLineColor = colors(3)
resl@gsLineThicknessF = 3
resl@gsLineDashPattern = 0
a = (res@trYMaxF - res@trYMinF) / 50.0
dum1 = gsn_add_polyline(wks, plot, (/mnmx(0,3) - std(0),mnmx(0,3) + std(0)/), (/mnmx(1,3),mnmx(1,3)/), resl)
dum2 = gsn_add_polyline(wks, plot, (/mnmx(0,3),mnmx(0,3)/), (/mnmx(1,3) - std(1),mnmx(1,3) + std(1)/), resl)
dum3 = gsn_add_polyline(wks, plot, (/mnmx(0,3) - std(0),mnmx(0,3) - std(0)/), (/mnmx(1,3) - a,mnmx(1,3) + a/), resl)
dum4 = gsn_add_polyline(wks, plot, (/mnmx(0,3) + std(0),mnmx(0,3) + std(0)/), (/mnmx(1,3) - a,mnmx(1,3) + a/), resl)
dum5 = gsn_add_polyline(wks, plot, (/mnmx(0,3) - a,mnmx(0,3) + a/), (/mnmx(1,3) - std(1),mnmx(1,3) - std(1)/), resl)
dum6 = gsn_add_polyline(wks, plot, (/mnmx(0,3) - a,mnmx(0,3) + a/), (/mnmx(1,3) + std(1),mnmx(1,3) + std(1)/), resl)

;--------------------------------------------------------------
reso = True
reso@gsnDraw = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkers = indexes
reso@xyMarkerSizes = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknesses = thicknesses
plot1 = gsn_csm_xy(wks, transpose((/mnmx(0,0:3),mnmx(0,0:3)/)), transpose((/mnmx(1,0:3),mnmx(1,0:3)/)), reso)
overlay(plot, plot1)

draw (plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0, 4
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
