;*******************************:******************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly mean net surface radiation
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-03-07
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

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

    process = False       ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR  1948/01 - , T64
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"

    in_path4     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name4     = new(37,string)
    in_name4(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name4(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name4(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name4(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name4(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name4(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name4(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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
    nmod = dimsizes (in_name4)

    in_path5     = "~/data-model/CMIP5-hes/rlds/historical/"
    in_name5     = new(nmod,string)
    in_name5(0)  = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(1)  = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(2)  = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name5(2)  = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name5(3)  = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(3)  = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(4)  = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(4)  = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(5)  = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(6)  = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(7)  = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(8)  = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name5(9)  = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name5(7)  = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path6     = "~/data-model/CMIP5-hes/rlus/historical/"
    in_name6     = new(nmod,string)
    in_name6(0)  = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(1)  = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(2)  = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name6(2)  = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name6(3)  = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(3)  = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(4)  = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(4)  = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(5)  = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(6)  = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(7)  = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(8)  = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(9)  = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    in_name6(7)  = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(10) = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(11) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    in_name6(12) = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    in_name6(13) = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    in_name6(14) = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    in_name6(15)  = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path7     = "~/data-model/CMIP5-hes/rsds/historical/"
    in_name7     = new(nmod,string)
    in_name7(0)  = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(1)  = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(2)  = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name7(3)  = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name7(3)  = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(4)  = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name7(5)  = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(4)  = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(5)  = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(6)  = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(7)  = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name7(8)  = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
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

    in_path8     = "~/data-model/CMIP5-hes/rsus/historical/"
    in_name8     = new(nmod,string)
    in_name8(0)  = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(1)  = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(2)  = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    in_name8(3)  = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
    in_name8(3)  = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(4)  = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    in_name8(5)  = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(4)  = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(5)  = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(6)  = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(7)  = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(8)  = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name8(9)  = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
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
;    latN1 = 10
;    latS1 = -10
;    lonW1 = 50
;    lonE1 = 100
    latN1 = 30
    latS1 = -30
    lonW1 = 40
    lonE1 = 120

;tropical North Atlantic
;    latN2 = 10
;    latS2 = -10
;    lonW2 = -30 
;    lonE2 = 10
    latN2 = 30
    latS2 = -30
    lonW2 = -70 
    lonE2 = 20
;    latN2 = 25
;    latS2 = 5
;    lonW2 = 305 
;    lonE2 = 345

    rTIO2 = new((/maxlag,nmod/),float)
    rTNA2 = new((/maxlag,nmod/),float)

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_data = "./lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)"/)
    text2 = (/"Tropical Indian Ocean","Tropical Atlantic Ocean"/)
    text3 = yS+"-"+yE
    text4 = (/"W~F34~W~F~m~S~-2~N~/~F35~J~F~C","Lag (months)"/)
    text5 = (/"MMM","OBS"/)
    text6 = (/"-2","0","2","4","6"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in4 = addfile (in_path4 + in_name4(i),"r")
    in5 = addfile (in_path5 + in_name5(i),"r")
    in6 = addfile (in_path6 + in_name6(i),"r")
    in7 = addfile (in_path7 + in_name7(i),"r")
    in8 = addfile (in_path8 + in_name8(i),"r")

;get the time indexs
    time4  = in4->time
    time5  = in5->time
    year4  = cd_calendar (time4,-1) /100
    year5  = cd_calendar (time5,-1) /100
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)
    iYYYY5 = ind (year5.ge.yS .and. year5.le.yE)

    ts   = in4->ts(iYYYY4,:,:)
    rlds = in5->rlds(iYYYY5,:,:)
    rlus = in6->rlus(iYYYY5,:,:)
    rsds = in7->rsds(iYYYY5,:,:)
    rsus = in8->rsus(iYYYY5,:,:)
    nrs2 = rlus+rsus-rlds-rsds
    copy_VarCoords (rlds,nrs2)
;     sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat
     lat2   = in2->lat
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst    = in1->sst(iYYYY1,:,:)
     nlwrs  = in2->nlwrs(iYYYY2,:,:)
     nswrs  = in3->nswrs(iYYYY2,:,:)
     nrs1   = nlwrs+nswrs
     copy_VarCoords (nlwrs,nrs1)

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
   clm3  = clmMonTLL (ts)
   clm4  = clmMonTLL (nrs2)
   tsA   = calcMonAnomTLL (ts, clm3)
   nrsA2 = calcMonAnomTLL (nrs2,clm4)
   tsA   = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   nrsA2 = (/dtrend_msg_n (nrsA2&time,nrsA2,False,False,0)/)

;compute seasonal means
   tsA_S   = month_to_season (tsA,season(3))
   nrsA2_S = month_to_seasonN (nrsA2,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2  = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
   dim = dimsizes (I2)

;   rTIO(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN2:latS2}), 1., 0) /)
;   rTIO(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)

;tropical Indian Ocean
   TIO2 = wgt_areaave_Wrap ( nrsA2_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;tropical North Atlantic
   nrsA2_S = lonFlip(nrsA2_S)
   TNA2 = wgt_areaave_Wrap ( nrsA2_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO2(:,i)  = (/regCoef (I2,TIO2)/)
   rTNA2(:,i)  = (/regCoef (I2,TNA2)/)
   rTIO2(4:,i) = (/regCoef ( I2(:dim-2), TIO2(4:,1:) )/)
   rTNA2(4:,i) = (/regCoef ( I2(:dim-2), TNA2(4:,1:) )/)

   if(i.eq.0)then

    copy_VarCoords (TIO2,rTIO2(:,0))
    copy_VarCoords (TNA2,rTNA2(:,0))

    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (nrs1)
    sstA   = calcMonAnomTLL (sst,clm1)
    nrsA1  = calcMonAnomTLL (nrs1,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    nrsA1  = (/dtrend_msg_n (nrsA1&time,nrsA1,False,False,0)/)
    sstA_S  = month_to_season (sstA,season(3))
    nrsA1_S = month_to_seasonN (nrsA1,season)
    I1   = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( nrsA1_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    nrsA1_S = lonFlip(nrsA1_S)
    TNA1 = wgt_areaave_Wrap ( nrsA1_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    rTIO1 = regCoef (I1,TIO1)
    rTNA1 = regCoef (I1,TNA1)
    rTIO1(4:) = regCoef ( I1(:dim-2), TIO1(4:,1:) )
    rTNA1(4:) = regCoef ( I1(:dim-2), TNA1(4:,1:) )
;    rTIO1  = (/wgt_areaave_Wrap ( regCoef_n (I1,TTA1_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;    rTNA1  = (/wgt_areaave_Wrap ( regCoef_n (I1,TTA1_S(:,:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)
;    rTIO1(4:) = (/wgt_areaave_Wrap ( regCoef_n (I1(:dim-2),TTA1_S(4:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;    rTNA1(4:) = (/wgt_areaave_Wrap ( regCoef_n (I1(:dim-2),TTA1_S(4:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TNA1,rTNA1)

   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time4,time5,year4,year5/])

end do

   mnmx = new((/2,4,maxlag/),float)
   mnmx(0,0,:) = dim_min ( rTIO2 )
   mnmx(0,1,:) = dim_max ( rTIO2 )
   mnmx(0,2,:) = dim_avg ( rTIO2 )
   mnmx(0,3,:) = rTIO1
   mnmx(1,0,:) = dim_min ( rTNA2 )
   mnmx(1,1,:) = dim_max ( rTNA2 )
   mnmx(1,2,:) = dim_avg ( rTNA2 )
   mnmx(1,3,:) = rTNA1

   mnmx!0 = "region"
   mnmx!1 = "value"
   mnmx!2 = "season"

   printVarSummary (mnmx)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","value","season"/)
dimSizes = dimsizes (mnmx)
dimUnlim = (/False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"value", "integer","value")
filevardef (fout,"season","integer","season")
filevardef (fout,"mnmx",  typeof(mnmx),getvardims(mnmx))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"mnmx",mnmx)

;output only the data values
fout->region = ispan(1,2,1)
fout->value  = ispan(1,4,1)
fout->season = (/toint(lag)/)
fout->mnmx   = (/mnmx/)

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

res@tiYAxisString      = text4(0)
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
res@trYMinF = -5.
res@trYMaxF = 1.

res@vpHeightF = 0.25

res@xyLineColor = -1       ;not want the line, make it transparent

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = text3
plot(0) = gsn_csm_xy (wks,lag,mnmx(0,0:1,:),res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
res@tiXAxisString   = text4(1)
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

resP@txString       = "Regression of Regional NRS onto NDJ CTI"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
