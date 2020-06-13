;*******************************:******************************
;Aim: Draw cross correlation between November-December-January cold tongue index and three-month means of area average of monthly mean net surface flux
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-03-15
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

;   var6--------------ts
;   var7--------------hfls
;   var8--------------hfss
;   var9--------------rlds
;   var10-------------rlus
;   var11-------------rsds
;   var12-------------rsus
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR  1948/01 - , T64
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/lhtfl.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/shtfl.sfc.mon.mean.nc"
    in_name4 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
    in_name5 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"

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

    in_path9     = "~/data-model/CMIP5-hes/rlds/historical/"
    in_name9     = new(nmod,string)
    in_name9(0)  = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(1)  = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(2)  = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name9(2)  = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name9(3)  = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(3)  = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(4)  = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(4)  = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(5)  = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(6)  = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(7)  = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(8)  = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name9(9)  = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name9(7)  = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path10     = "~/data-model/CMIP5-hes/rlus/historical/"
    in_name10     = new(nmod,string)
    in_name10(0)  = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(1)  = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(2)  = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name10(2)  = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name10(3)  = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(3)  = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(4)  = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(4)  = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(5)  = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(6)  = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(7)  = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(8)  = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(9)  = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name10(7)  = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(10) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name10(11) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name10(12) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name10(13) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(14) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name10(15)  = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path11     = "~/data-model/CMIP5-hes/rsds/historical/"
    in_name11     = new(nmod,string)
    in_name11(0)  = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(1)  = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(2)  = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name11(3)  = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name11(3)  = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(4)  = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name11(5)  = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(4)  = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(5)  = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(6)  = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(7)  = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name11(8)  = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path12     = "~/data-model/CMIP5-hes/rsus/historical/"
    in_name12     = new(nmod,string)
    in_name12(0)  = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(1)  = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(2)  = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name12(3)  = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name12(3)  = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(4)  = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name12(5)  = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(4)  = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(5)  = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(6)  = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(7)  = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(8)  = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name12(9)  = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
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

;time
    yS = 1958
    yE = 2004
    season = (/"ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ"/)
    maxlag = dimsizes (season)
    lag    = fspan (-3,maxlag-4,maxlag)

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

    rTIO2 = new((/maxlag,nmod/),float)
    rTNA2 = new((/maxlag,nmod/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./lag_corr_NDJ_CTI_and_areaave_hfs_nrs_anom_remove_trend_CMIP.nc"
    out_name = "lag_corr_NDJ_CTI_and_areaave_hfs_nrs_anom_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)"/)
    text2 = (/"Tropical Indian Ocean","Tropical North Atlantic"/)
    text3 = yS+"-"+yE
    text4 = "Lag (months)"
    text5 = (/"MMM","OBS"/)
    text6 = (/"-2","0","2","4","6"/)

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
    in12 = addfile (in_path12 + in_name12(i),"r")

;get the time indexs
    time6  = in6->time
    time7  = in7->time
    time9  = in9->time
    year6  = cd_calendar (time6,-1) /100
    year7  = cd_calendar (time7,-1) /100
    year9  = cd_calendar (time9,-1) /100
    iYYYY6 = ind (year6.ge.yS .and. year6.le.yE)
    iYYYY7 = ind (year7.ge.yS .and. year7.le.yE)
    iYYYY9 = ind (year9.ge.yS .and. year9.le.yE)

    ts   = in6->ts(iYYYY6,:,:)
    hfls = in7->hfls(iYYYY7,:,:)
    hfss = in8->hfss(iYYYY7,:,:)
    rlds = in9->rlds(iYYYY9,:,:)
    rlus = in10->rlus(iYYYY9,:,:)
    rsds = in11->rsds(iYYYY9,:,:)
    rsus = in12->rsus(iYYYY9,:,:)
    nfs2 = hfls+hfss+rlus+rsus-rlds-rsds
    copy_VarCoords (hfls,nfs2)
;     sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     in4    = addfile (in_name4,"r")
     in5    = addfile (in_name5,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat
     lat2   = in2->lat
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst    = in1->sst(iYYYY1,:,:)
     lhtfl  = in2->lhtfl(iYYYY2,:,:)
     shtfl  = in3->shtfl(iYYYY2,:,:)
     nlwrs  = in4->nlwrs(iYYYY2,:,:)
     nswrs  = in5->nswrs(iYYYY2,:,:)
     nfs1   = lhtfl+shtfl+nlwrs+nswrs
     copy_VarCoords (lhtfl,nfs1)

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw1 = cos (rad*lat1)
     gw2 = cos (rad*lat2)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm6  = clmMonTLL (ts)
   clm7  = clmMonTLL (nfs2)
   tsA   = calcMonAnomTLL (ts, clm6)
   nfsA2 = calcMonAnomTLL (nfs2,clm7)
   tsA   = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   nfsA2 = (/dtrend_msg_n (nfsA2&time,nfsA2,False,False,0)/)

;compute seasonal means
   tsA_NDJ   = month_to_season (tsA,season(3))
   nfsA2_3M = month_to_seasonN (nfsA2,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2  = wgt_areaave_Wrap ( tsA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
   dim = dimsizes (I2)

;   rTIO(:,i)  = (/wgt_areaave_Wrap ( escorc_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(:,i)  = (/wgt_areaave_Wrap ( escorc_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN2:latS2}), 1., 0) /)
;   rTIO(1:,i) = (/wgt_areaave_Wrap ( escorc_n (I(:dim-2),TTA_S(1:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(1:,i) = (/wgt_areaave_Wrap ( escorc_n (I(:dim-2),TTA_S(1:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)

;tropical Indian Ocean
   TIO2 = wgt_areaave_Wrap ( nfsA2_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;tropical North Atlantic
   TNA2 = wgt_areaave_Wrap ( nfsA2_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO2(:,i)  = (/escorc (I2,TIO2)/)
   rTNA2(:,i)  = (/escorc (I2,TNA2)/)
   rTIO2(4:,i) = (/escorc ( I2(:dim-2), TIO2(4:,1:) )/)
   rTNA2(4:,i) = (/escorc ( I2(:dim-2), TNA2(4:,1:) )/)

   if(i.eq.0)then

    copy_VarCoords (TIO2,rTIO2(:,0))
    copy_VarCoords (TNA2,rTNA2(:,0))

    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (nfs1)
    sstA   = calcMonAnomTLL (sst,clm1)
    nfsA1  = calcMonAnomTLL (nfs1,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    nfsA1  = (/dtrend_msg_n (nfsA1&time,nfsA1,False,False,0)/)
    sstA_NDJ = month_to_season (sstA,season(3))
    nfsA1_3M = month_to_seasonN (nfsA1,season)
    I1   = wgt_areaave_Wrap ( sstA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( nfsA1_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    TNA1 = wgt_areaave_Wrap ( nfsA1_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    rTIO1 = escorc (I1,TIO1)
    rTNA1 = escorc (I1,TNA1)
    rTIO1(4:) = escorc ( I1(:dim-2), TIO1(4:,1:) )
    rTNA1(4:) = escorc ( I1(:dim-2), TNA1(4:,1:) )
;    rTIO1  = (/wgt_areaave_Wrap ( escorc_n (I1,TTA1_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;    rTNA1  = (/wgt_areaave_Wrap ( escorc_n (I1,TTA1_S(:,:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)
;    rTIO1(4:) = (/wgt_areaave_Wrap ( escorc_n (I1(:dim-2),TTA1_S(4:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;    rTNA1(4:) = (/wgt_areaave_Wrap ( escorc_n (I1(:dim-2),TTA1_S(4:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TNA1,rTNA1)

   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time6,time7,time9,year6,year7,year9/])

end do

   mnmx   = new((/2,4,maxlag/),float)
   mnmx!0 = "region"
   mnmx!1 = "value"
   mnmx!2 = "season"

   mnmx(0,0,:) = (/dim_min ( rTIO2 )/)
   mnmx(0,1,:) = (/dim_max ( rTIO2 )/)
   mnmx(0,2,:) = (/dim_avg ( rTIO2 )/)
   mnmx(0,3,:) = (/rTIO1/)
   mnmx(1,0,:) = (/dim_min ( rTNA2 )/)
   mnmx(1,1,:) = (/dim_max ( rTNA2 )/)
   mnmx(1,2,:) = (/dim_avg ( rTNA2 )/)
   mnmx(1,3,:) = (/rTNA1/)

   nmin   = new((/2,nmod+1/),integer)
   nmin!0 = "region"
   nmin!1 = "model"

   nmin(0,1:) = (/dim_minind (rTIO2(3:,:),0)/)
   nmin(1,1:) = (/dim_minind (rTNA2(3:,:),0)/)
   nmin(0,0)  = (/dim_minind (rTIO1(3:),0)/)
   nmin(1,0)  = (/dim_minind (rTNA1(3:),0)/)

   printVarSummary (mnmx)
   printVarSummary (nmin)
   indmn   = new((/2,5/),integer)
   indmn!0 = "region"
   indmn!1 = "model2"
   indmn(0,:) = (/ind (dim_min_n(rTIO2(3:,:),0).ge.-.282)/)
   indmn(1,:) = (/ind (dim_min_n(rTNA2(3:,:),0).ge.-.282)/)

   printVarSummary (mnmx)
   printVarSummary (nmin)
   print ((/indmn/))

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","value","season","model","model2"/)
dimSizes = (/2,4,maxlag,nmod+1,5/)
dimUnlim = (/False,False,False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"value", "integer","value")
filevardef (fout,"season","integer","season")
filevardef (fout,"model","integer","model")
filevardef (fout,"model","integer","model2")
filevardef (fout,"mnmx",  typeof(mnmx),getvardims(mnmx))
filevardef (fout,"nmin",  typeof(nmin),getvardims(nmin))
filevardef (fout,"indmn", typeof(indmn),getvardims(indmn))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"mnmx",mnmx)
filevarattdef (fout,"nmin",nmin)
filevarattdef (fout,"indmn",indmn)

;output only the data values
fout->region = ispan(1,2,1)
fout->value  = ispan(1,4,1)
fout->season = (/toint(lag)/)
fout->model  = ispan(1,nmod+1,1)
fout->model2  = ispan(1,5,1)
fout->mnmx   = (/mnmx/)
fout->nmin   = (/nmin/)
fout->indmn  = (/indmn/)

else

 in   = addfile (out_data,"r")
 mnmx = in->mnmx
 printVarSummary (mnmx)

end if

; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

wks   = gsn_open_wks ("svg",out_path+out_name)
plot  = new (2,graphic)        
plot0 = new (2,graphic)        

res = True

res@gsnDraw     = False
res@gsnFrame    = False
res@gsnYRefLine = .0
res@gsnXYFillColors        = "LightBlue"
res@gsnStringFontHeightF   = 0.021
res@gsnYRefLineThicknessF  = 2
res@gsnYRefLineDashPattern = 1

;res@tiYAxisString      = text4(0)
res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMode    = "Explicit"
res@tmXBValues  = fspan (-2.,6.,5)
res@tmXBLabels  = text6
res@tmXBMinorOn = False
res@tmXTMinorOn = False
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@trXMinF = -3.
res@trXMaxF = 6.
res@trYMinF = -1.
res@trYMaxF = .5

res@vpHeightF = 0.25

res@xyLineColor = -1       ;not want the line, make it transparent

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = text3
plot(0) = gsn_csm_xy (wks,lag,mnmx(0,0:1,:),res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
res@tiXAxisString   = text4
plot(1) = gsn_csm_xy (wks,lag,mnmx(1,0:1,:),res)

;--------------------------------------------------------------
reso = True

reso@gsnDraw       = False
reso@gsnFrame      = False

reso@xyLineColors  = (/"blue","orangered"/)
reso@xyDashPattern = 0
reso@xyLineThicknessF       = 4.
reso@xyExplicitLegendLabels = text5

;Manually creating a legend
reso@pmLegendDisplayMode    = "Always"
reso@pmLegendWidthF         = 0.06
reso@pmLegendHeightF        = 0.12
reso@pmLegendSide           = "Bottom"
reso@pmLegendParallelPosF   = .86
reso@pmLegendOrthogonalPosF = -.6

reso@lgPerimOn              = False
reso@lgLabelFontHeightF     = .014

plot0(0) = gsn_csm_xy (wks,lag,mnmx(0,2:3,:),reso)

reso@pmLegendDisplayMode    = "NoCreate"
plot0(1) = gsn_csm_xy (wks,lag,mnmx(1,2:3,:),reso)

overlay (plot(0),plot0(0))
overlay (plot(1),plot0(1))

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Correlation of Regional NFS onto NDJ CTI"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
