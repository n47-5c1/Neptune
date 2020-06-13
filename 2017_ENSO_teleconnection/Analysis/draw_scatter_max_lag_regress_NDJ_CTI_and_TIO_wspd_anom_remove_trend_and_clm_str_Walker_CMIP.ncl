;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients between NDJ cold tongue index and 3-month means of area average of monthly wind speed anomalies removed trend
;     in the tropical Indian Ocean as well as the climatology of the strength of the Walker cell
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2018-01-16
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------wspd
;   var3--------------slp
;   var4--------------ts
;   var5--------------ua
;   var6--------------va
;   var7--------------psl
;================================================

    process = True      ;Statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/slp.mon.mean.nc"

    in_path1     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name4     = new(41,string)
    in_name4(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name4(2)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    in_name4(3)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(4)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name4(4)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(5)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(6)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(7)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(8)  = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(9)  = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(10) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(11) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(12) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(13) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(13) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(14) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name4(15) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(16) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(17) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name4(18) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
;    in_name4(19) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(19) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(20) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(21) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(22) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(23) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    in_name4(24) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name4(25) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name4(26) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name4(27) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(28) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(29) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(30) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(31) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name4(32) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name4(33) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(34) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(35) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(36) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(37) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(38) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(39) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(40) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name4)

    in_path2     = "~/data-model/CMIP5-hes/ua/historical/"
    in_name5     = new(nmod,string)
    in_name5(0)  = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(1)  = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(2)  = "ua_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name5(3)  = "ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(4)  = "ua_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name5(4)  = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(5)  = "ua_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(6)  = "ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(7)  = "ua_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(8)  = "ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(9)  = "ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(10) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(11) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(12) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(13) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name5(13) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(14) = "ua_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name5(15) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(16) = "ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(19) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name5(17) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name5(18) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name5(19) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name5(19) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(20) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(21) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(22) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(23) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name5(24) = "ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name5(25) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(26) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(27) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(28) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(29) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(30) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(31) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name5(32) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name5(33) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(34) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(35) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(36) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(37) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(38) = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(39) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(40) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path3     = "~/data-model/CMIP5-hes/va/historical/"
    in_name6     = new(nmod,string)
    in_name6(0)  = "va_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(1)  = "va_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(2)  = "va_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name6(3)  = "va_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(4)  = "va_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name6(4)  = "va_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(5)  = "va_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(6)  = "va_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(7)  = "va_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(8)  = "va_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(9)  = "va_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(10) = "va_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(11) = "va_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(12) = "va_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(13) = "va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name6(13) = "va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(14) = "va_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name6(15) = "va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(16) = "va_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(19) = "va_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name6(17) = "va_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name6(18) = "va_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name6(19) = "va_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name6(19) = "va_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(20) = "va_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name6(21) = "va_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(22) = "va_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name6(23) = "va_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name6(24) = "va_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name6(25) = "va_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name6(26) = "va_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name6(27) = "va_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(28) = "va_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(29) = "va_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(30) = "va_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(31) = "va_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name6(32) = "va_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name6(33) = "va_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(34) = "va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(35) = "va_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(36) = "va_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(37) = "va_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(38) = "va_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(39) = "va_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(40) = "va_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path4     = "~/data-model/CMIP5-hes/psl/historical/"
    in_name7     = new(nmod,string)
    in_name7(0)  = "psl_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(1)  = "psl_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(2)  = "psl_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name7(2)  = "psl_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name7(3)  = "psl_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(5)  = "psl_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name7(4)  = "psl_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(5)  = "psl_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(6)  = "psl_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(7)  = "psl_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(8)  = "psl_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(8)  = "psl_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(9)  = "psl_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(10) = "psl_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(11) = "psl_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(12) = "psl_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(16) = "psl_Amon_CNRM-CM5_historical_r2i1p1_185001-200512_2.5x2.5.nc"
    in_name7(13) = "psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(15) = "psl_Amon_EC-EARTH_historical_r1i1p1_185001-200912.nc"
    in_name7(14) = "psl_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name7(15) = "psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(16) = "psl_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name7(22) = "psl_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012.nc"
    in_name7(17) = "psl_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name7(18) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name7(19) = "psl_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(20) = "psl_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name7(21) = "psl_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(22) = "psl_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name7(23) = "psl_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name7(24) = "psl_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name7(25) = "psl_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name7(26) = "psl_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name7(27) = "psl_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(28) = "psl_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(29) = "psl_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(30) = "psl_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(31) = "psl_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name7(32) = "psl_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name7(33) = "psl_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(34) = "psl_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(35) = "psl_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(36) = "psl_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(37) = "psl_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(38) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(39) = "psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name7(40) = "psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"
 
;time
    yS = 1958
    yE = 2004
    month  = (/0,1,2,3,4,11/)
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    maxlag = dimsizes (season)

    lev = 2    ;850 hPa

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

;the Walker cell
    latN2 = 5
    latS2 = -5
;    lonW2 = 210
;    lonE2 = 270
    lonW2 = 200
    lonE2 = 280

    latN3 = 5
    latS3 = -5
;    lonW3 = 90
;    lonE3 = 150
    lonW3 = 80
    lonE3 = 160

    rTIO = new ((/maxlag,nmod/),float)
    W2   = new (nmod,float)

;Fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_max_lag_regress_NDJ_CTI_and_TIO_wspd_anom_remove_trend_and_clm_str_Walker_CMIP.nc"
    out_name = "scatter_max_lag_regress_NDJ_CTI_and_TIO_wspd_anom_remove_trend_and_clm_str_Walker_CMIP"

;text
    text1 = yS+"-"+yE
    text2 = (/"TIO (m/s/~F35~J~F~C)","Walker (Pa)"/)
    text3 = (/"Obs.","MMM","Model Samples"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors  = (/"red3","dodgerblue2","black"/)
    sizes   = (/.025,.025,.04/)
    indexes = (/5,5,1/)
    thicknesses = (/5,5,1/)

if (process) then

do i=0,nmod-1

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in4 = addfile (in_path1 + in_name4(i),"r")
    in5 = addfile (in_path2 + in_name5(i),"r")
    in6 = addfile (in_path3 + in_name6(i),"r")
    in7 = addfile (in_path4 + in_name7(i),"r")

;get the time indexes
    time4  = in4->time
    time5  = in5->time
    time7  = in7->time
    year4  = cd_calendar (time4,-1) /100
    year5  = cd_calendar (time5,-1) /100
    year7  = cd_calendar (time7,-1) /100
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)
    iYYYY5 = ind (year5.ge.yS .and. year5.le.yE)
    iYYYY7 = ind (year7.ge.yS .and. year7.le.yE)

    sst2 = in4->ts(iYYYY4,:,:)
    ua   = in5->ua(iYYYY5,lev,:,:)
    va   = in6->va(iYYYY5,lev,:,:)
    psl  = in7->psl(iYYYY7,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    print (i+" "+min(sst2))

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     time1  = in1->time
     time2  = in2->time
     time3  = in3->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     year3  = cd_calendar (time3,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
     sst1   = in1->sst(iYYYY1,:,:)
     wspd   = in2->wspd(iYYYY2,lev,:,:)
     slp    = in3->slp(iYYYY3,:,:)

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw1 = in4->lat
     gw2 = in5->lat
     gw1 = cos (rad*gw1)
     gw2 = cos (rad*gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

   clm7_p = clmMonTLL (psl)
   clm7   = dim_avg_n_Wrap (clm7_p(month,:,:),0)

;monthly anomalies
   ua    = wind_speed (ua,va)
   clm4  = clmMonTLL (sst2)
   clm5  = clmMonTLL (ua)
   SSTA2 = calcMonAnomTLL (sst2,clm4)
   uaA   = calcMonAnomTLL (ua,  clm5)
   SSTA2 = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
   uaA   = (/dtrend_msg_n (uaA&time,  uaA  ,False,False,0)/)

;compute seasonal means
   SSTA2_3M = month_to_season (SSTA2,season(0))
   uaA_3M   = month_to_seasonN (uaA  ,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI = wgt_areaave_Wrap ( SSTA2_3M(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1., 0)
   dim = dimsizes (CTI)
;tropical Indian Ocean
   TIO = wgt_areaave_Wrap ( uaA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;the Walker cell
   W2(i) = wgt_areaave_Wrap ( clm7({latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
   W2(i) = W2(i) - wgt_areaave_Wrap ( clm7({latN3:latS3},{lonW3:lonE3}), gw2({latN3:latS3}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO(:,i) = (/regCoef (CTI,TIO)/)
   rTIO(1:,i) = (/regCoef ( CTI(:dim-2), TIO(1:,1:) )/)

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO(:,0))

    clm1   = clmMonTLL (sst1)
    clm2   = clmMonTLL (wspd)
    clm3_p = clmMonTLL (slp)
    clm3   = dim_avg_n_Wrap (clm3_p(month,:,:),0)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    wspdA = calcMonAnomTLL (wspd, clm2)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    wspdA = (/dtrend_msg_n (wspdA&time,wspdA,False,False,0)/)
    SSTA1_3M = month_to_season (SSTA1,season(0))
    wspdA_3M = month_to_seasonN (wspdA,season)
    CTI1 = wgt_areaave_Wrap ( SSTA1_3M(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( wspdA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    W1 = wgt_areaave_Wrap ( clm3({latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    W1 = W1 - wgt_areaave_Wrap ( clm3({latN3:latS3},{lonW3:lonE3}), gw2({latN3:latS3}), 1., 0)
    rTIO1 = regCoef (CTI1,TIO1)
    rTIO1(1:) = regCoef ( CTI1(:dim-2), TIO1(1:,1:) )
    copy_VarCoords (TIO1,rTIO1)

   end if

   delete([/time4,time5,time7,year4,year5,year7/])

end do

   mnmx = new((/2,nmod+2/),float)
   mnmx(0,0)  = W1*100
   mnmx(0,2:) = W2
   mnmx(0,1)  = dim_avg (W2)
   mnmx(1,0)  = min (rTIO1)
   mnmx(1,2:) = dim_min_n (rTIO,0)
   mnmx(1,1)  = dim_avg ( mnmx(1,2:) )

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

mnmx!0 = "region"
mnmx!1 = "member"
ndim   = dimsizes (mnmx)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","member"/)
dimSizes = (/ndim(0),ndim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"member","integer","member")
filevardef (fout,"mnmx",typeof(mnmx),getvardims(mnmx))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)

;output only the data values
fout->region = ispan (1,2,1)
fout->member = ispan (1,nmod+2,1)
fout->mnmx   = (/mnmx/)

else

 in   = addfile (out_data,"r")
 mnmx = in->mnmx
 printVarSummary (mnmx)

end if

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
res@gsnStringFontHeightF   = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Max Regression against WSPD and DJFMAM Walker"
res@tiMainFontHeightF  = .028

res@trYMaxF = .075
res@trYMinF = -1.2
res@trXMaxF = 300.
res@trXMinF = -200.

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
reso@gsnXRefLine    = mnmx(0,0)
reso@gsnYRefLine    = mnmx(1,0)

reso@xyMarkLineMode = "Markers"
reso@xyMarker       = indexes
reso@xyMarkerSizeF  = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknessF = thicknesses

plot1 = gsn_csm_xy (wks, transpose((/mnmx(0,0:1),mnmx(0,0:1)/)), transpose((/mnmx(1,0:1),mnmx(1,0:1)/)) ,reso)

;--------------------------------------------------------------
; add the line
;rc = regline(mnmx(0,2:),mnmx(1,2:))
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
;dum = gsn_add_polyline (wks,plot,(/min(mnmx(0,2:)),max(mnmx(0,2:))/),(/min( rc*(mnmx(0,2:)-rc@xave)+rc@yave ), max( rc*(mnmx(0,2:)-rc@xave)+rc@yave )/),resl)
dum1 = gsn_add_polyline (wks,plot,(/mnmx(0,0),mnmx(0,0)/),(/res@trYMinF,res@trYMaxF/),resl)
dum2 = gsn_add_polyline (wks,plot,(/res@trXMinF,res@trXMaxF/),(/mnmx(1,0),mnmx(1,0)/),resl)

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
