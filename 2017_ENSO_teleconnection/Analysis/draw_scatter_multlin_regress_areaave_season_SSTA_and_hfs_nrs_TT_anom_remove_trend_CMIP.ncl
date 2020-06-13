;*******************************:******************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly mean 1000-200-hPa tropospheric temperature
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-02-25
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
;   var4--------------nlwrs
;   var5--------------nswrs
;   var6--------------air

;   var7--------------ts
;   var8--------------hfls
;   var9--------------hfss
;   var10-------------rlds
;   var11-------------rlus
;   var12-------------rsds
;   var13-------------rsus
;   var14-------------ta
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/lhtfl.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/shtfl.sfc.mon.mean.nc"
    in_name4 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
    in_name5 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"
    in_name6 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"

    in_path7     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name7     = new(38,string)
    in_name7(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name7(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name7(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name7(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name7(11) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name7(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(12) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name7(13) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name7(14) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name7(15) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name7(16) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(17) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name7(18) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(19) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name7(20) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name7(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name7(21) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name7(22) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name7(23) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(24) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(25) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(26) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(27) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name7(28) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name7(29) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(30) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(31) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(32) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(33) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(34) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(35) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name7(36) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name7(37) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name7)

    in_path8     = "~/data-model/CMIP5-hes/hfls/historical/"
    in_name8     = new(nmod,string)
    in_name8(0)  = "hfls_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(1)  = "hfls_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(2)  = "hfls_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(3)  = "hfls_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(4)  = "hfls_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(3)  = "hfls_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name8(3)  = "hfls_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(7)  = "hfls_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(8)  = "hfls_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(9)  = "hfls_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(10) = "hfls_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(11) = "hfls_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(12) = "hfls_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(4)  = "hfls_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(5)  = "hfls_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(6)  = "hfls_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(7)  = "hfls_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(8)  = "hfls_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(9)  = "hfls_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(10) = "hfls_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
    in_name8(11) = "hfls_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(19) = "hfls_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(12) = "hfls_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(13) = "hfls_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name8(14) = "hfls_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(15) = "hfls_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name8(16) = "hfls_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(17) = "hfls_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(18) = "hfls_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(19) = "hfls_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name8(20) = "hfls_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    in_name8(27) = "hfls_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    in_name8(21) = "hfls_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(22) = "hfls_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name8(23) = "hfls_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(24) = "hfls_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(25) = "hfls_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(26) = "hfls_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(27) = "hfls_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
    in_name8(28) = "hfls_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name8(29) = "hfls_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(30) = "hfls_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(31) = "hfls_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(32) = "hfls_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(33) = "hfls_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(34) = "hfls_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(35) = "hfls_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name8(36) = "hfls_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(37) = "hfls_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path9     = "~/data-model/CMIP5-hes/hfss/historical/"
    in_name9     = new(nmod,string)
    in_name9(0)  = "hfss_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(1)  = "hfss_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(2)  = "hfss_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name9(3)  = "hfss_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    in_name9(4)  = "hfss_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(3)  = "hfss_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name9(3)  = "hfss_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(7)  = "hfss_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(8)  = "hfss_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(9)  = "hfss_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(10) = "hfss_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(11) = "hfss_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(12) = "hfss_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(4)  = "hfss_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(5)  = "hfss_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(6)  = "hfss_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(7)  = "hfss_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(8)  = "hfss_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(9)  = "hfss_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(10) = "hfss_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
    in_name9(11) = "hfss_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(19) = "hfss_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(12) = "hfss_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    in_name9(13) = "hfss_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name9(14) = "hfss_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name9(15) = "hfss_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name9(16) = "hfss_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(17) = "hfss_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name9(18) = "hfss_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(19) = "hfss_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name9(20) = "hfss_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    in_name9(28) = "hfss_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    in_name9(21) = "hfss_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name9(22) = "hfss_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name9(23) = "hfss_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(24) = "hfss_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(25) = "hfss_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(26) = "hfss_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(27) = "hfss_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
    in_name9(28) = "hfss_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name9(29) = "hfss_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(30) = "hfss_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(31) = "hfss_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(32) = "hfss_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(33) = "hfss_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(34) = "hfss_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(35) = "hfss_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name9(36) = "hfss_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(37) = "hfss_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path10     = "~/data-model/CMIP5-hes/rlds/historical/"
    in_name10     = new(nmod,string)
    in_name10(0)  = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(1)  = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(2)  = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name10(3)  = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name10(3)  = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(4)  = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(5)  = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(4)  = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(5)  = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(6)  = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(7)  = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(8)  = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(9)  = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(10) = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(11) = "rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(12) = "rlds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name10(13) = "rlds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name10(14) = "rlds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(15) = "rlds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(16) = "rlds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(17) = "rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name10(18) = "rlds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(19) = "rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name10(20) = "rlds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name10(21) = "rlds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name10(22) = "rlds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name10(23) = "rlds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(24) = "rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(25) = "rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(26) = "rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(27) = "rlds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name10(28) = "rlds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name10(29) = "rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(30) = "rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(31) = "rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(32) = "rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(33) = "rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(34) = "rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(35) = "rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name10(36) = "rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(37) = "rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path11     = "~/data-model/CMIP5-hes/rlus/historical/"
    in_name11     = new(nmod,string)
    in_name11(0)  = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(1)  = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(2)  = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name11(3)  = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name11(3)  = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(4)  = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(5)  = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(4)  = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(5)  = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(6)  = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(7)  = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(8)  = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(9)  = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(10) = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(11) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(12) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name11(13) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name11(14) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name11(15) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name11(16) = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(17) = "rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name11(18) = "rlus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(19) = "rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name11(20) = "rlus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name11(21) = "rlus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name11(22) = "rlus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name11(23) = "rlus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(24) = "rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(25) = "rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(26) = "rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(27) = "rlus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name11(28) = "rlus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name11(29) = "rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(30) = "rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(31) = "rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(32) = "rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(33) = "rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(34) = "rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(35) = "rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name11(36) = "rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(37) = "rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path12     = "~/data-model/CMIP5-hes/rsds/historical/"
    in_name12     = new(nmod,string)
    in_name12(0)  = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(1)  = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(2)  = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name12(3)  = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name12(3)  = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(4)  = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(5)  = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(4)  = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(5)  = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(6)  = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(7)  = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(8)  = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(9) = "rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(10) = "rsds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(11) = "rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(12) = "rsds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name12(13) = "rsds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name12(14) = "rsds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name12(15) = "rsds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name12(16) = "rsds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(17) = "rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name12(18) = "rsds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(19) = "rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name12(20) = "rsds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name12(21) = "rsds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name12(22) = "rsds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name12(23) = "rsds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(24) = "rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(25) = "rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(26) = "rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(27) = "rsds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name12(28) = "rsds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name12(29) = "rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(30) = "rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(31) = "rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(32) = "rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(33) = "rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(34) = "rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(35) = "rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name12(36) = "rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(37) = "rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path13     = "~/data-model/CMIP5-hes/rsus/historical/"
    in_name13     = new(nmod,string)
    in_name13(0)  = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(1)  = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(2)  = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name13(3)  = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name13(3)  = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name13(4)  = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name13(5)  = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(4)  = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(5)  = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(6)  = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(7)  = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(8)  = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(9)  = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(10) = "rsus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(11) = "rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(12) = "rsus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name13(13) = "rsus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name13(14) = "rsus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name13(15) = "rsus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name13(16) = "rsus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(17) = "rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name13(18) = "rsus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(19) = "rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    in_name13(20) = "rsus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    in_name13(21) = "rsus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    in_name13(22) = "rsus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    in_name13(23) = "rsus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(24) = "rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(25) = "rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(26) = "rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(27) = "rsus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    in_name13(28) = "rsus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    in_name13(29) = "rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(30) = "rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(31) = "rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(32) = "rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(33) = "rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(34) = "rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(35) = "rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    in_name13(36) = "rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    in_name13(37) = "rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    in_path14    = "~/data-model/CMIP5-hes/ta/historical/"
    in_name14    = new(nmod,string)
    in_name14(0)  = "ta_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(1)  = "ta_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(2)  = "ta_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name14(3)  = "ta_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(3)  = "ta_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name14(3)  = "ta_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(6)  = "ta_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(7)  = "ta_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(8)  = "ta_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(9)  = "ta_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(10) = "ta_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(4)  = "ta_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(5)  = "ta_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(6)  = "ta_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(7)  = "ta_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name14(8)  = "ta_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(9)  = "ta_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(10) = "ta_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name14(11) = "ta_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name14(18) = "ta_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(12) = "ta_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name14(13) = "ta_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name14(14) = "ta_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name14(15) = "ta_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name14(16) = "ta_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(17) = "ta_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name14(18) = "ta_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(19) = "ta_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name14(20) = "ta_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name14(28) = "ta_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name14(21) = "ta_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name14(22) = "ta_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name14(23) = "ta_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(24) = "ta_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(25) = "ta_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(26) = "ta_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(27) = "ta_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name14(28) = "ta_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name14(29) = "ta_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(30) = "ta_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(31) = "ta_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(32) = "ta_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(33) = "ta_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(34) = "ta_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(35) = "ta_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name14(36) = "ta_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name14(37) = "ta_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
    yS = 1958
    yE = 2004
    season = (/"ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    nlag   = dimsizes (season)

;cold tongue
;    latNI = 6
;    latSI = -6
;    lonWI = 180
;    lonEI = 270
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

    rTIO1 = new((/nlag,4/),float)
    rTNA1 = new((/nlag,4/),float)
    rTIO2 = new((/nlag,4,nmod/),float)
    rTNA2 = new((/nlag,4,nmod/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_multlin_regress_areaave_season_SSTA_and_hfs_nrs_TT_anom_remove_trend_CMIP.nc"
    out_name = "scatter_multlin_regress_areaave_season_SSTA_and_hfs_nrs_TT_anom_remove_trend_CMIP"

;text
    text1 = yS+"-"+yE
    text2 = (/"TNA","TIO"/)
    text3 = (/"OBS","MMM","Model Samples"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors  = (/"red3","dodgerblue2","black"/)
    sizes   = (/.025,.025,.04/)
    indexes = (/5,5,1/)
    thicknesses = (/5,5,1/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in7  = addfile (in_path7 + in_name7(i),"r")
    in8  = addfile (in_path8 + in_name8(i),"r")
    in9  = addfile (in_path9 + in_name9(i),"r")
    in10 = addfile (in_path10 + in_name10(i),"r")
    in11 = addfile (in_path11 + in_name11(i),"r")
    in12 = addfile (in_path12 + in_name12(i),"r")
    in13 = addfile (in_path13 + in_name13(i),"r")
    in14 = addfile (in_path14 + in_name14(i),"r")

;get the time indexs
    time7   = in7->time
    time8   = in8->time
    time10  = in10->time
    time14  = in14->time
    year7   = cd_calendar (time7,-1) /100
    year8   = cd_calendar (time8,-1) /100
    year10  = cd_calendar (time10,-1) /100
    year14  = cd_calendar (time14,-1) /100
    iYYYY7  = ind (year7.ge.yS .and. year7.le.yE)
    iYYYY8  = ind (year8.ge.yS .and. year8.le.yE)
    iYYYY10 = ind (year10.ge.yS .and. year10.le.yE)
    iYYYY14 = ind (year14.ge.yS .and. year14.le.yE)

    ts   = in7->ts(iYYYY7,:,:)
    hfls = in8->hfls(iYYYY7,:,:)
    hfss = in9->hfss(iYYYY7,:,:)
    hfls = hfls+hfss
    rlds = in10->rlds(iYYYY10,:,:)
    rlus = in11->rlus(iYYYY10,:,:)
    rsds = in12->rsds(iYYYY10,:,:)
    rsus = in13->rsus(iYYYY10,:,:)
    rsus = rlus+rsus-rlds-rsds
    if(i.eq.13)then
     ta = in14->ta(iYYYY14,(/0,1,2,4,5,6,7,8,9,10/),:,:)
    else
     ta = in14->ta(iYYYY14,{:20000},:,:)
    end if

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     in4    = addfile (in_name4,"r")
     in5    = addfile (in_name5,"r")
     in6    = addfile (in_name6,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat
     lat2   = in2->lat
     lat6   = in6->lat
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst    = in1->sst(iYYYY1,:,:)
     lhtfl  = in2->lhtfl(iYYYY2,:,:)
     shtfl  = in3->shtfl(iYYYY2,:,:)
     lhtfl  = lhtfl+shtfl
     nlwrs  = in4->nlwrs(iYYYY2,:,:)
     nswrs  = in5->nswrs(iYYYY2,:,:)
     nlwrs  = nlwrs+nswrs
     air    = in6->air(iYYYY2,{:200},:,:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1  = cos (rad*lat1)
     gw2  = cos (rad*lat2)
     gw6  = cos (rad*lat6)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)
     copy_VarCoords (lat6,gw6)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate the vertical mean
   dp_cfm = conform_dims ( dimsizes(ta), dp,1)
   TT2    = dim_sum_n (dp_cfm*ta/sumdp,1)
   copy_VarMeta (ta(:,0,:,:),TT2)

;monthly anomalies
   clm8  = clmMonTLL (ts)
   clm9  = clmMonTLL (hfls)
   clm14 = clmMonTLL (rsus)
   clm15 = clmMonTLL (TT2)
   tsA   = calcMonAnomTLL (ts,clm8)
   hflsA = calcMonAnomTLL (hfls,clm9)
   rsusA = calcMonAnomTLL (rsus,clm14)
   TTA2  = calcMonAnomTLL (TT2,clm15)
   tsA   = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   hflsA = (/dtrend_msg_n (hflsA&time,hflsA,False,False,0)/)
   rsusA = (/dtrend_msg_n (rsusA&time,rsusA,False,False,0)/)
   TTA2  = (/dtrend_msg_n (TTA2&time,TTA2,False,False,0)/)

;compute seasonal means
   tsA_S   = month_to_seasonN (tsA,season)
   hflsA_S = month_to_seasonN (hflsA,season)
   rsusA_S = month_to_seasonN (rsusA,season)
   TTA2_S  = month_to_seasonN (TTA2,season)

;--------------------------------------------------------------
;tropical Indian Ocean
   ts_TIO   = wgt_areaave_Wrap ( tsA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
   hfls_TIO = wgt_areaave_Wrap ( hflsA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
   rsus_TIO = wgt_areaave_Wrap ( rsusA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
   TT2_TIO  = wgt_areaave_Wrap ( TTA2_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw6({latN1:latS1}), 1., 0)
;tropical North Atlantic
   ts_TNA   = wgt_areaave_Wrap ( tsA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
   hfls_TNA = wgt_areaave_Wrap ( hflsA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
   rsus_TNA = wgt_areaave_Wrap ( rsusA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
   TT2_TNA  = wgt_areaave_Wrap ( TTA2_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw6({latN2:latS2}), 1., 0)
   dim = dimsizes (ts_TNA)

;--------------------------------------------------------------
;compute multiple linear regression
   if(i.eq.0)then
    TIO2 = new((/nlag,dim(1),3/),float)
    TNA2 = new((/nlag,dim(1),3/),float)
   end if

   TIO2(:,:,0) = (/hfls_TIO/)
   TIO2(:,:,1) = (/rsus_TIO/)
   TIO2(:,:,2) = (/TT2_TIO/)
   TNA2(:,:,0) = (/hfls_TNA/)
   TNA2(:,:,1) = (/rsus_TNA/)
   TNA2(:,:,2) = (/TT2_TNA/)

   do j=0,nlag-1
    rTIO2(j,:,i)  = (/reg_multlin_stats (ts_TIO(j,:),TIO2(j,:,:),False)/)
    rTNA2(j,:,i)  = (/reg_multlin_stats (ts_TNA(j,:),TNA2(j,:,:),False)/)
   end do

   S2_TIO  = dim_stddev_n (TIO2,1)
   S2_TNA  = dim_stddev_n (TNA2,1)
   S_tsTIO = conform_dims ( dimsizes(S2_TIO), dim_stddev_n(ts_TIO,1), 0)
   S_tsTNA = conform_dims ( dimsizes(S2_TNA), dim_stddev_n(ts_TNA,1), 0)
   rTIO2(:,1:,i) = rTIO2(:,1:,i)*S2_TIO/S_tsTIO
   rTNA2(:,1:,i) = rTNA2(:,1:,i)*S2_TNA/S_tsTNA

   if(i.eq.0)then
    dp_cfm = conform_dims ( dimsizes(air), dp,1)
    TT1    = dim_sum_n (dp_cfm*air/sumdp,1)
    copy_VarMeta (air(:,0,:,:),TT1)
    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (lhtfl)
    clm4   = clmMonTLL (nlwrs)
    clm6   = clmMonTLL (TT1)
    sstA   = calcMonAnomTLL (sst,clm1)
    lhtflA = calcMonAnomTLL (lhtfl,clm2)
    nlwrsA = calcMonAnomTLL (nlwrs,clm4)
    TTA1   = calcMonAnomTLL (TT1,clm6)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    lhtflA = (/dtrend_msg_n (lhtflA&time,lhtflA,False,False,0)/)
    nlwrsA = (/dtrend_msg_n (nlwrsA&time,nlwrsA,False,False,0)/)
    TTA1   = (/dtrend_msg_n (TTA1&time,TTA1,False,False,0)/)
    sstA_S   = month_to_seasonN (sstA,season)
    lhtflA_S = month_to_seasonN (lhtflA,season)
    nlwrsA_S = month_to_seasonN (nlwrsA,season)
    TTA1_S   = month_to_seasonN (TTA1,season)
    sst_TIO   = wgt_areaave_Wrap ( sstA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    lhtfl_TIO = wgt_areaave_Wrap ( lhtflA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    nlwrs_TIO = wgt_areaave_Wrap ( nlwrsA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    TTA1_TIO  = wgt_areaave_Wrap ( TTA1_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw6({latN1:latS1}), 1., 0)
    sst_TNA   = wgt_areaave_Wrap ( sstA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
    lhtfl_TNA = wgt_areaave_Wrap ( lhtflA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    nlwrs_TNA = wgt_areaave_Wrap ( nlwrsA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    TTA1_TNA  = wgt_areaave_Wrap ( TTA1_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw6({latN2:latS2}), 1., 0)
    TIO1 = new((/nlag,dim(1),3/),float)
    TNA1 = new((/nlag,dim(1),3/),float)
    TIO1(:,:,0) = (/lhtfl_TIO/)
    TIO1(:,:,1) = (/nlwrs_TIO/)
    TIO1(:,:,2) = (/TT2_TIO/)
    TNA1(:,:,0) = (/lhtfl_TNA/)
    TNA1(:,:,1) = (/nlwrs_TNA/)
    TNA1(:,:,2) = (/TT2_TNA/)
    do j=0,nlag-1
     rTIO1(j,:) = (/reg_multlin_stats (sst_TIO(j,:),TIO1(j,:,:),False)/)
     rTNA1(j,:) = (/reg_multlin_stats (sst_TNA(j,:),TNA1(j,:,:),False)/)
    end do
   S1_TIO   = dim_stddev_n(TIO1,1)
   S1_TNA   = dim_stddev_n(TNA1,1)
   S_sstTIO = conform_dims ( dimsizes(S1_TIO), dim_stddev_n(sst_TIO,1), 0)
   S_sstTNA = conform_dims ( dimsizes(S1_TNA), dim_stddev_n(sst_TNA,1), 0)
   rTIO1(:,1:) = rTIO1(:,1:)*S1_TIO/S_sstTIO
   rTNA1(:,1:) = rTNA1(:,1:)*S1_TNA/S_sstTNA
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time7,time8,time10,time14,year7,year8,year10,year14/])

end do

   B = new((/2,nlag,3,nmod+2/),float)
   B(0,:,:,0)  = rTIO1(:,1:)
   B(0,:,:,2:) = rTIO2(:,1:,:)
   B(0,:,:,1)  = dim_avg ( B(0,:,:,2:) )
   B(1,:,:,0)  = rTNA1(:,1:)
   B(1,:,:,2:) = rTNA2(:,1:,:)
   B(1,:,:,1)  = dim_avg ( B(1,:,:,2:) )

   B!0 = "region"
   B!1 = "season"
   B!2 = "variable"
   B!3 = "model"
   ndim = dimsizes (B)
   printVarSummary (B)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================


system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","season","variable","model"/)
dimSizes = ndim
dimUnlim = (/False,False,False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"season","integer","season")
filevardef (fout,"variable","integer","variable")
filevardef (fout,"model","integer","model")
filevardef (fout,"B",typeof(B),getvardims(B))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)

;output only the data values
fout->region   = ispan (1,2,1)
fout->season   = ispan (1,nlag,1)
fout->variable = ispan (1,3,1)
fout->model    = ispan (1,nmod+2,1)
fout->B        = (/B/)

else

 in = addfile (out_data,"r")
 B  = in->B
 printVarSummary (B)

end if

 print ((/B(:,:,:,:1)/))
 print ((/B(:,:,:,5:6)/))
exit
; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================
wks  = gsn_open_wks ("svg",out_path+out_name)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnCenterString = text1(0)
res@gsnRightString  = text1(1)
res@gsnStringFontHeightF   = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Max Regression of Regional TT onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = 2.2
res@trYMinF = .0
res@trXMaxF = 2.2
res@trXMinF = .0

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(2)
res@xyMarkerSizeF  = sizes(2)
res@xyMarkerThicknessF = 2
plot = gsn_csm_xy (wks,mnmx(0,2:),mnmx(1,2:),res)

;--------------------------------------------------------------
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarker       = indexes
reso@xyMarkerSizeF  = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknessF = thicknesses
plot1 = gsn_csm_xy (wks, transpose((/mnmx(0,0:1),mnmx(0,0:1)/)), transpose((/mnmx(1,0:1),mnmx(1,0:1)/)) ,reso)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
dum1 = gsn_add_polyline (wks,plot,(/.0,2.2/),(/.0,2.2/),resl)
dum2 = gsn_add_polyline (wks,plot,(/res@trXMinF,res@trXMaxF/),(/mnmx(1,0),mnmx(1,0)/),resl)
dum3 = gsn_add_polyline (wks,plot,(/mnmx(0,0),mnmx(0,0)/),(/res@trYMinF,res@trYMaxF/),resl)

overlay (plot,plot1)

draw  (plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,2
gsres@gsMarkerSizeF = sizes(i)
gsres@gsMarkerColor = colors(i)
gsres@gsMarkerIndex = indexes(i)
gsres@gsMarkerThicknessF = thicknesses(i)

gsn_polymarker_ndc (wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.018

gsn_text_ndc (wks,text3,x+.025,y,txres)

frame (wks)

end
