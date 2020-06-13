;*******************************:******************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly mean 1000-200-hPa surface wind speed
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
;   var2--------------wspd.sfc
;   var3--------------ts
;   var4--------------uas
;   var5--------------vas
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.sfc.mon.mean.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(37,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name3(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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
    nmod = dimsizes (in_name3)

    in_path4     = "~/data-model/CMIP5-hes/uas/historical/"
    in_name4     = new(nmod,string)
    in_name4(0)  = "uas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "uas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "uas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(2)  = "uas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(3)  = "uas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(4)  = "uas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(3)  = "uas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(5)  = "uas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6)  = "uas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7)  = "uas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8)  = "uas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9)  = "uas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
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

    in_path5     = "~/data-model/CMIP5-hes/vas/historical/"
    in_name5     = new(nmod,string)
    in_name5(0)  = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(1)  = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(2)  = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(2)  = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(3)  = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(4)  = "vas_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name5(3)  = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(5)  = "vas_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(6)  = "vas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(7)  = "vas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(8)  = "vas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(9)  = "vas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(4)  = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(5)  = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(6)  = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(7)  = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(8)  = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(9)  = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
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
    out_data = "./lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)"/)
    text2 = (/"Tropical Indian Ocean","Tropical Atlantic Ocean"/)
    text3 = yS+"-"+yE
    text4 = (/"m~F34~W~F~s~S~-1~N~/~F35~J~F~C","Lag (months)"/)
    text5 = (/"MMM","OBS"/)
    text6 = (/"-2","0","2","4","6"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in3 = addfile (in_path3 + in_name3(i),"r")
    in4 = addfile (in_path4 + in_name4(i),"r")
    in5 = addfile (in_path5 + in_name5(i),"r")

;get the time indexs
    time3  = in3->time
    time4  = in4->time
    year3  = cd_calendar (time3,-1) /100
    year4  = cd_calendar (time4,-1) /100
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    ts  = in3->ts(iYYYY3,:,:)
    uas = in4->uas(iYYYY4,:,:)
    vas = in5->vas(iYYYY4,:,:)
;     sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat
     lat2   = in2->lat
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst    = in1->sst(iYYYY1,:,:)
     wspd   = in2->wspd(iYYYY2,:,:)

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
   uas  = wind_speed (uas,vas)
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLL (uas)
   tsA  = calcMonAnomTLL (ts, clm3)
   uasA = calcMonAnomTLL (uas,clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   uasA = (/dtrend_msg_n (uasA&time,uasA,False,False,0)/)

;compute seasonal means
   tsA_S  = month_to_season (tsA,season(3))
   uasA_S = month_to_seasonN (uasA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2  = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
   dim = dimsizes (I2)

;   rTIO(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN2:latS2}), 1., 0) /)
;   rTIO(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)

;tropical Indian Ocean
   TIO2 = wgt_areaave_Wrap ( uasA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;tropical North Atlantic
   uasA_S = lonFlip(uasA_S)
   TNA2 = wgt_areaave_Wrap ( uasA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)

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
    clm2   = clmMonTLL (wspd)
    sstA   = calcMonAnomTLL (sst,clm1)
    wspdA  = calcMonAnomTLL (wspd,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    wspdA  = (/dtrend_msg_n (wspdA&time,wspdA,False,False,0)/)
    sstA_S  = month_to_season (sstA,season(3))
    wspdA_S = month_to_seasonN (wspdA,season)
    I1   = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( wspdA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    wspdA_S = lonFlip(wspdA_S)
    TNA1 = wgt_areaave_Wrap ( wspdA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
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

   delete([/time3,time4,year3,year4/])

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
res@trYMinF = -.4
res@trYMaxF = .2

res@vpHeightF = 0.25

res@xyLineColor = -1       ;not want the line, make it transparent

res@gsnLeftString   = text1(0)+" Surface"
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
reso@pmLegendSide           = "Top"
reso@pmLegendParallelPosF   = .86
reso@pmLegendOrthogonalPosF = -0.42

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

resP@txString       = "Regression of Regional WSPD onto NDJ CTI"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
