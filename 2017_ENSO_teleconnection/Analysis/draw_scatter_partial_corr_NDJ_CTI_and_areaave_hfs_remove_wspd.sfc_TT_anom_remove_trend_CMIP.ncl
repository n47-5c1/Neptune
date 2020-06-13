;*******************************:******************************
;Aim: Draw a scatter plot of partial correlation between November-December-January cold tongue index and three-month means of area average of monthly
;     surface heat flux anomalies with those of monthly surface wind speed, and mean 1000-200-hPa tropospheric temperature anomalies removed, removed
;     trend in CMIP model
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-03-14
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------lhtfl
;   var3--------------shtfl
;   var4--------------wspd
;   var5--------------air

;   var6--------------ts
;   var7--------------hfls
;   var8--------------hfss
;   var9--------------uas
;   var10-------------vas
;   var11-------------ta
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
    in_name0 = "./lag_corr_NDJ_CTI_and_areaave_hfs_nrs_anom_remove_trend_CMIP.nc"
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR  1948/01 - , T64
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/lhtfl.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/shtfl.sfc.mon.mean.nc"
;NCEP/NCAR 2.5x2.5
    in_name4 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"
    in_name5 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"

    in_path6     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name6     = new(37,string)
    in_name6(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name6(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name6(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name6(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name6(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name6(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name6(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name6(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name6(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name6(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name6(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name6(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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
    nmod = dimsizes (in_name6)

    in_path7     = "~/data-model/CMIP5-hes/hfls/historical/"
    in_name7     = new (nmod,string)
    in_name7(0)  = "hfls_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(1)  = "hfls_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(2)  = "hfls_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name7(3)  = "hfls_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    in_name7(4)  = "hfls_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(5)  = "hfls_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name7(3)  = "hfls_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(6)  = "hfls_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(7)  = "hfls_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(8)  = "hfls_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(9)  = "hfls_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(10) = "hfls_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(11) = "hfls_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(4)  = "hfls_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(5)  = "hfls_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(6)  = "hfls_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(7)  = "hfls_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(8)  = "hfls_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(9)  = "hfls_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(16) = "hfls_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
    in_name7(10) = "hfls_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(18) = "hfls_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(11) = "hfls_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    in_name7(12) = "hfls_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name7(13) = "hfls_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name7(14) = "hfls_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name7(15) = "hfls_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(16) = "hfls_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name7(17) = "hfls_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(18) = "hfls_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name7(19) = "hfls_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    in_name7(26) = "hfls_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    in_name7(20) = "hfls_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name7(21) = "hfls_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name7(22) = "hfls_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(23) = "hfls_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(24) = "hfls_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(25) = "hfls_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(26) = "hfls_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
    in_name7(27) = "hfls_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name7(28) = "hfls_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(29) = "hfls_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(30) = "hfls_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(31) = "hfls_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(32) = "hfls_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(33) = "hfls_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(34) = "hfls_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name7(35) = "hfls_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(36) = "hfls_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_name8     = new (nmod,string)
    in_path8     = "~/data-model/CMIP5-hes/hfss/historical/"
    in_name8(0)  = "hfss_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(1)  = "hfss_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(2)  = "hfss_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(3)  = "hfss_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(4)  = "hfss_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(5)  = "hfss_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name8(3)  = "hfss_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(6)  = "hfss_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(7)  = "hfss_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(8)  = "hfss_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(9)  = "hfss_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(10) = "hfss_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(11) = "hfss_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(4)  = "hfss_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(5)  = "hfss_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(6)  = "hfss_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(7)  = "hfss_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(8)  = "hfss_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(9)  = "hfss_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(16) = "hfss_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
    in_name8(10) = "hfss_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(18) = "hfss_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(11) = "hfss_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(12) = "hfss_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name8(13) = "hfss_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(14) = "hfss_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(15) = "hfss_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(16) = "hfss_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(17) = "hfss_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(18) = "hfss_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(19) = "hfss_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    in_name8(26) = "hfss_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    in_name8(20) = "hfss_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(21) = "hfss_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(22) = "hfss_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(23) = "hfss_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(24) = "hfss_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(25) = "hfss_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(26) = "hfss_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
    in_name8(27) = "hfss_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name8(28) = "hfss_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(29) = "hfss_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(30) = "hfss_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(31) = "hfss_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(32) = "hfss_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(33) = "hfss_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(34) = "hfss_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name8(35) = "hfss_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(36) = "hfss_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path9     = "~/data-model/CMIP5-hes/uas/historical/"
    in_name9     = new (nmod,string)
    in_name9(0)  = "uas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(1)  = "uas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(2)  = "uas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name9(3)  = "uas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name9(4)  = "uas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(3)  = "uas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(4)  = "uas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(5)  = "uas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(6)  = "uas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(7)  = "uas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(8)  = "uas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(9)  = "uas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(10) = "uas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(11) = "uas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name9(12) = "uas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name9(13) = "uas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name9(14) = "uas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name9(15) = "uas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(16) = "uas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name9(17) = "uas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(18) = "uas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name9(19) = "uas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name9(20) = "uas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name9(20) = "uas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name9(21) = "uas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name9(22) = "uas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(23) = "uas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(24) = "uas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(25) = "uas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(26) = "uas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name9(27) = "uas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name9(28) = "uas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(29) = "uas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(30) = "uas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(31) = "uas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(32) = "uas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(33) = "uas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(34) = "uas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name9(35) = "uas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name9(36) = "uas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path10     = "~/data-model/CMIP5-hes/vas/historical/"
    in_name10     = new (nmod,string)
    in_name10(0)  = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(1)  = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(2)  = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name10(3)  = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name10(4)  = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(3)  = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(4)  = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(5)  = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(6)  = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(7)  = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(8)  = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(9)  = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(10) = "vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(11) = "vas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name10(12) = "vas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name10(13) = "vas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name10(14) = "vas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name10(15) = "vas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(16) = "vas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name10(17) = "vas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(18) = "vas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name10(19) = "vas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name10(20) = "vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name10(20) = "vas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name10(21) = "vas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name10(22) = "vas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(23) = "vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(24) = "vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(25) = "vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(26) = "vas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name10(27) = "vas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name10(28) = "vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(29) = "vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(30) = "vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(31) = "vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(32) = "vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(33) = "vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(34) = "vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name10(35) = "vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name10(36) = "vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path11    = "~/data-model/CMIP5-hes/ta/historical/"
    in_name11    = new(nmod,string)
    in_name11(0)  = "ta_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(1)  = "ta_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(2)  = "ta_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name11(2)  = "ta_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name11(3)  = "ta_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(3)  = "ta_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name11(3)  = "ta_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(6)  = "ta_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(7)  = "ta_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(8)  = "ta_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(9)  = "ta_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(10) = "ta_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(4)  = "ta_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(5)  = "ta_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(6)  = "ta_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(7)  = "ta_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name11(8)  = "ta_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(9)  = "ta_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(10) = "ta_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name11(10) = "ta_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name11(18) = "ta_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(11) = "ta_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name11(12) = "ta_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name11(13) = "ta_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name11(14) = "ta_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name11(15) = "ta_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(16) = "ta_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name11(17) = "ta_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(18) = "ta_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name11(19) = "ta_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name11(28) = "ta_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name11(20) = "ta_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name11(21) = "ta_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name11(22) = "ta_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(23) = "ta_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(24) = "ta_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(25) = "ta_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(26) = "ta_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name11(27) = "ta_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name11(28) = "ta_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(29) = "ta_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(30) = "ta_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(31) = "ta_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(32) = "ta_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(33) = "ta_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(34) = "ta_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name11(35) = "ta_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name11(36) = "ta_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
    yS = 1958
    yE = 2004
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ"/)

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

;arguments required by vertical mean
    pnew       = (/1000,925,850,700,600,500,400,300,250,200/)
    pver       = pnew*100
    pver@units = "Pa"
    dp         = dpres_plevel_Wrap (pver,100000,200,0)   ;caculate dp
    sumdp      = sum(dp)
    printVarSummary (dp)
    print ((/sumdp/))

    x12 = new (2,float)
    x13 = new (2,float)
    x14 = new (2,float)
    x23 = new (2,float)
    x24 = new (2,float)
    r   = new ((/2,3,nmod+2/),float)
    r!0 = "region"
    r!1 = "variable"
    r!2 = "model"
    ndim = dimsizes (r)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_partial_corr_NDJ_CTI_and_areaave_hfs_remove_wspd.sfc_TT_anom_remove_trend_CMIP.nc"
    out_name = "scatter_partial_corr_NDJ_CTI_and_areaave_hfs_remove_wspd.sfc_TT_anom_remove_trend_CMIP"

;text
    text1 = yS+"-"+yE
    text2 = (/"TNA","TIO"/)
    text3 = (/"OBS","MMM","MSs"/)
    text4 = (/"Total","WSPD","TTM"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors1 = (/"firebrick4","deepskyblue4","green4"/)
    colors2 = (/"firebrick1","deepskyblue1","green2"/)
    sizes   = (/.024,.025,.03/)
    indexes = (/15,2,1/)
    thicknesses = (/4,5,1/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in6  = addfile (in_path6 + in_name6(i),"r")
    in7  = addfile (in_path7 + in_name7(i),"r")
    in8  = addfile (in_path8 + in_name8(i),"r")
    in9  = addfile (in_path9 + in_name9(i),"r")
    in10 = addfile (in_path10 + in_name10(i),"r")
    in11 = addfile (in_path11 + in_name11(i),"r")

;get the time indexs
    time6   = in6->time
    time7   = in7->time
    time9   = in9->time
    time11  = in11->time
    year6   = cd_calendar (time6,-1) /100
    year7   = cd_calendar (time7,-1) /100
    year9   = cd_calendar (time9,-1) /100
    year11  = cd_calendar (time11,-1) /100
    iYYYY6  = ind (year6.ge.yS .and. year6.le.yE)
    iYYYY7  = ind (year7.ge.yS .and. year7.le.yE)
    iYYYY9  = ind (year9.ge.yS .and. year9.le.yE)
    iYYYY11 = ind (year11.ge.yS .and. year11.le.yE)

    ts   = in6->ts(iYYYY6,:,:)
    hfls = in7->hfls(iYYYY7,:,:)
    hfss = in8->hfss(iYYYY7,:,:)
    hfls = hfls + hfss
    uas  = in9->uas(iYYYY9,:,:)
    vas  = in10->vas(iYYYY9,:,:)
    uas  = wind_speed (uas,vas)
    if(i.eq.12)then
     ta = in11->ta(iYYYY11,(/0,1,2,4,5,6,7,8,9,10/),:,:)
    else
     ta = in11->ta(iYYYY11,{:20000},:,:)
    end if

    if(i.eq.0)then

     in0    = addfile (in_name0,"r")
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     in4    = addfile (in_name4,"r")
     in5    = addfile (in_name5,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat
     lat2   = in2->lat
     lat4   = in4->lat
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     nmin  = in0->nmin
     sst   = in1->sst(iYYYY1,:,:)
     lhtfl = in2->lhtfl(iYYYY2,:,:)
     shtfl = in3->shtfl(iYYYY2,:,:)
     lhtfl = lhtfl + shtfl
     wspd  = in4->wspd(iYYYY2,0,:,:)
     air   = in5->air(iYYYY2,{:200},:,:)
;     sst1  = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1 = cos (rad*lat1)
     gw2 = cos (rad*lat2)
     gw4 = cos (rad*lat4)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)
     copy_VarCoords (lat4,gw4)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate the vertical mean
   dp_cfm = conform_dims ( dimsizes(ta), dp,1)
   TT2    = dim_sum_n (dp_cfm*ta/sumdp,1)
   copy_VarMeta (ta(:,0,:,:),TT2)

;monthly anomalies
   clm6  = clmMonTLL (ts)
   clm7  = clmMonTLL (hfls)
   clm9  = clmMonTLL (uas)
   clm11 = clmMonTLL (TT2)
   tsA   = calcMonAnomTLL (ts,clm6)
   hflsA = calcMonAnomTLL (hfls,clm7)
   uasA  = calcMonAnomTLL (uas,clm9)
   TTA2  = calcMonAnomTLL (TT2,clm11)
   tsA   = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   hflsA = (/dtrend_msg_n (hflsA&time,hflsA,False,False,0)/)
   uasA  = (/dtrend_msg_n (uasA&time,uasA,False,False,0)/)
   TTA2  = (/dtrend_msg_n (TTA2&time,TTA2,False,False,0)/)

;compute seasonal means
   tsA_NDJ   = month_to_season (tsA,season(0))
   hflsA_3M1 = month_to_season (hflsA,season(nmin(0,i+1)))
   uasA_3M1  = month_to_season (uasA,season(nmin(0,i+1)))
   TTA2_3M1  = month_to_season (TTA2,season(nmin(0,i+1)))
   hflsA_3M2 = month_to_season (hflsA,season(nmin(1,i+1)))
   uasA_3M2  = month_to_season (uasA,season(nmin(1,i+1)))
   TTA2_3M2  = month_to_season (TTA2,season(nmin(1,i+1)))
   nT = dimsizes (tsA_NDJ(:,0,0))

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI2 = wgt_areaave_Wrap ( tsA_NDJ(:nT-2,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
;tropical Indian Ocean
   if(nmin(0,i+1).eq.0)then
    hfls_TIO = wgt_areaave_Wrap ( hflsA_3M1(:nT-2,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    uas_TIO  = wgt_areaave_Wrap ( uasA_3M1(:nT-2,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
    TT2_TIO  = wgt_areaave_Wrap ( TTA2_3M1(:nT-2,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
   else
    hfls_TIO = wgt_areaave_Wrap ( hflsA_3M1(1:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    uas_TIO  = wgt_areaave_Wrap ( uasA_3M1(1:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
    TT2_TIO  = wgt_areaave_Wrap ( TTA2_3M1(1:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
   end if
;tropical North Atlantic
   if(nmin(1,i+1).eq.0)then
    hfls_TNA = wgt_areaave_Wrap ( hflsA_3M2(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    uas_TNA  = wgt_areaave_Wrap ( uasA_3M2(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
    TT2_TNA  = wgt_areaave_Wrap ( TTA2_3M2(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
   else
    hfls_TNA = wgt_areaave_Wrap ( hflsA_3M2(1:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    uas_TNA  = wgt_areaave_Wrap ( uasA_3M2(1:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
    TT2_TNA  = wgt_areaave_Wrap ( TTA2_3M2(1:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
   end if
   dim2 = dimsizes (hfls_TIO)

;--------------------------------------------------------------
;compute partial correlation

   x12(0) = (/escorc (CTI2,hfls_TIO)/)
   x13(0) = (/escorc (CTI2,uas_TIO)/)
   x14(0) = (/escorc (CTI2,TT2_TIO)/)
   x23(0) = (/escorc (hfls_TIO,uas_TIO)/)
   x24(0) = (/escorc (hfls_TIO,TT2_TIO)/)
   x12(1) = (/escorc (CTI2,hfls_TNA)/)
   x13(1) = (/escorc (CTI2,uas_TNA)/)
   x14(1) = (/escorc (CTI2,TT2_TNA)/)
   x23(1) = (/escorc (hfls_TNA,uas_TNA)/)
   x24(1) = (/escorc (hfls_TNA,TT2_TNA)/)

   r(:,0,i+2) = (/x12/)
   r(:,1,i+2) = (/ (x12-x14*x24) / sqrt((1.-x14^2.)*(1.-x24^2.)) /)
   r(:,2,i+2) = (/ (x12-x13*x23) / sqrt((1.-x13^2.)*(1.-x23^2.)) /)

   if(i.eq.0)then

    dp_cfm = conform_dims ( dimsizes(air), dp,1)
    TT1    = dim_sum_n (dp_cfm*air/sumdp,1)
    copy_VarMeta (air(:,0,:,:),TT1)
    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (lhtfl)
    clm4   = clmMonTLL (wspd)
    clm5   = clmMonTLL (TT1)
    sstA   = calcMonAnomTLL (sst,clm1)
    lhtflA = calcMonAnomTLL (lhtfl,clm2)
    wspdA  = calcMonAnomTLL (wspd,clm4)
    TTA1   = calcMonAnomTLL (TT1,clm5)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    lhtflA = (/dtrend_msg_n (lhtflA&time,lhtflA,False,False,0)/)
    wspdA  = (/dtrend_msg_n (wspdA&time,wspdA,False,False,0)/)
    TTA1   = (/dtrend_msg_n (TTA1&time,TTA1,False,False,0)/)

    sstA_NDJ  = month_to_season (sstA,season(0))
    lhtflA_3M = month_to_season (lhtflA,season(nmin(1,0)))
    wspdA_3M  = month_to_season (wspdA,season(nmin(1,0)))
    TTA1_3M   = month_to_season (TTA1,season(nmin(1,0)))

    CTI1      = wgt_areaave_Wrap ( sstA_NDJ(:nT-2,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
;    lhtfl_TIO = wgt_areaave_Wrap ( lhtflA_3M(1:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;    wspd_TIO  = wgt_areaave_Wrap ( wspdA_3M(1:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
;    TT1_TIO   = wgt_areaave_Wrap ( TTA1_3M(1:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
    if(nmin(1,0).eq.0)then
     lhtfl_TNA = wgt_areaave_Wrap ( lhtflA_3M(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
     wspd_TNA  = wgt_areaave_Wrap ( wspdA_3M(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
     TT1_TNA   = wgt_areaave_Wrap ( TTA1_3M(:nT-2,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
    else
     lhtfl_TNA = wgt_areaave_Wrap ( lhtflA_3M(1:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
     wspd_TNA  = wgt_areaave_Wrap ( wspdA_3M(1:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
     TT1_TNA   = wgt_areaave_Wrap ( TTA1_3M(1:,{latN2:latS2},{lonW2:lonE2}), gw4({latN2:latS2}), 1., 0)
    end if

;    x12(0) = (/escorc (CTI1,lhtfl_TIO)/)
;    x13(0) = (/escorc (CTI1,wspd_TIO)/)
;    x14(0) = (/escorc (CTI1,TT1_TIO)/)
;    x23(0) = (/escorc (lhtfl_TIO,wspd_TIO)/)
;    x24(0) = (/escorc (lhtfl_TIO,TT1_TIO)/)
    x12(0) = 0
    x13(0) = 0
    x14(0) = 0
    x23(0) = 0
    x24(0) = 0
    x12(1) = (/escorc (CTI1,lhtfl_TNA)/)
    x13(1) = (/escorc (CTI1,wspd_TNA)/)
    x14(1) = (/escorc (CTI1,TT1_TNA)/)
    x23(1) = (/escorc (lhtfl_TNA,wspd_TNA)/)
    x24(1) = (/escorc (lhtfl_TNA,TT1_TNA)/)
    r(:,0,0) = (/x12/)
    r(:,1,0) = (/ (x12-x14*x24) / sqrt((1.-x14^2.)*(1.-x24^2.)) /)
    r(:,2,0) = (/ (x12-x13*x23) / sqrt((1.-x13^2.)*(1.-x23^2.)) /)

print((/r(:,:,0)/))
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time6,time7,time9,time11,year6,year7,year9,year11/])

end do

   r(:,:,1) = dim_avg ( r(:,:,2:) )
   std = dim_stddev_Wrap ( r(:,:,2:) )

   std!0 = "region"
   std!1 = "variable"

   printVarSummary (r)
   printVarSummary (std)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================


system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","variable","model"/)
dimSizes = ndim
dimUnlim = (/False,False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"variable","integer","variable")
filevardef (fout,"model","integer","model")
filevardef (fout,"r",typeof(r),getvardims(r))
filevardef (fout,"std",typeof(std),getvardims(std))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)
filevarattdef (fout,"std",std)

;output only the data values
fout->region   = ispan (1,2,1)
fout->variable = ispan (1,3,1)
fout->model    = ispan (1,nmod+2,1)
fout->r        = (/r/)
fout->std      = (/std/)

else

 in  = addfile (out_data,"r")
 r   = in->r
 std = in->std
 printVarSummary (r)
 printVarSummary (std)

end if

print((/r(:,:,:1)/))

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================
wks   = gsn_open_wks ("svg",out_path+out_name)
plot1 = new (2,graphic)
dum1  = new (3,graphic)
dum2  = new (3,graphic)
dum3  = new (3,graphic)
dum4  = new (3,graphic)
dum5  = new (3,graphic)
dum6  = new (3,graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnCenterString = text1(0)
;res@gsnRightString  = text1(1)
res@gsnStringFontHeightF   = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Partial Correlation of HFS onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = .8
res@trYMinF = -1.
res@trXMaxF = .8
res@trXMinF = -1.

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(2)
res@xyMarkerSizeF  = sizes(2)
res@xyMarkerColor  = colors2(0)
res@xyMarkerThicknessF = thicknesses(2)
plot = gsn_csm_xy (wks,r(0,0,2:),r(1,0,2:),res)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2.
resl@gsLineDashPattern = 1
duma = gsn_add_polyline (wks,plot,(/-1.,1./),(/-1.,1./),resl)
dumb = gsn_add_polyline (wks,plot,(/res@trXMinF,res@trXMaxF/),(/.0,.0/),resl)
dumc = gsn_add_polyline (wks,plot,(/.0,.0/),(/res@trYMinF,res@trYMaxF/),resl)

resl@gsLineThicknessF  = thicknesses(1)
resl@gsLineDashPattern = 0
a = (res@trYMaxF-res@trYMinF)/66.
do i=0,2
 resl@gsLineColor = colors1(i)
 dum1(i) = gsn_add_polyline (wks,plot,(/r(0,i,1)-std(0,i),r(0,i,1)+std(0,i)/),(/r(1,i,1),r(1,i,1)/),resl)
 dum2(i) = gsn_add_polyline (wks,plot,(/r(0,i,1),r(0,i,1)/),(/r(1,i,1)-std(1,i),r(1,i,1)+std(1,i)/),resl)
end do

;--------------------------------------------------------------
;color for mechanism, shape for model
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarker       = indexes(2)
reso@xyMarkerSizeF  = sizes(2)
reso@xyMarkerThicknessF = thicknesses(2)
do i=1,2
 reso@xyMarkerColor = colors2(i)
 plot1(i-1) = gsn_csm_xy (wks,r(0,i,2:),r(1,i,2:),reso)
overlay (plot,plot1(i-1))
end do

delete([/reso@xyMarker,reso@xyMarkerSizeF,reso@xyMarkerThicknessF/])
reso@xyMarker       = indexes
reso@xyMarkerSizeF  = sizes
reso@xyMarkerColors = colors1
reso@xyMarkerThicknessF = thicknesses
plot2 = gsn_csm_xy (wks, transpose((/r(0,:,0),r(0,:,0)/)), transpose((/r(1,:,0),r(1,:,0)/)) ,reso)
overlay (plot,plot2)

draw  (plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
gsres@gsMarkerColor = "black"
do i=0,2
 gsres@gsMarkerSizeF = sizes(i)
 gsres@gsMarkerIndex = indexes(i)
 gsres@gsMarkerThicknessF = thicknesses(i)
 gsn_polymarker_ndc (wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.018

gsn_text_ndc (wks,text3,x+.025,y,txres)

do i=0,2
 txres@txFontColor = colors1(i)
 gsn_text_ndc (wks,text4(i),x(i),y(i)-.12,txres)
end do

frame (wks)

end
