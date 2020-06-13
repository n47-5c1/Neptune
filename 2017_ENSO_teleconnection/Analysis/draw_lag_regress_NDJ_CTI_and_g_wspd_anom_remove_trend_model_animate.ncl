;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly wind speed anomalies
;     removed trend in certain models for animations
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-02-01
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------wspd
;   var3--------------ts
;   var4--------------ua
;   var5--------------va
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
;in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/vwnd.mon.mean.nc"

    in_path4     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name4     = new(8,string)
;    in_name4(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(2)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(3)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(4)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name4(0)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(1)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(2)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(3)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(4)  = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(5)  = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(10) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(11) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(12) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(13) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(14) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(15) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
;    in_name4(16) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(6)  = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(18) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
;    in_name4(19) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
;    in_name4(20) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
;    in_name4(21) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(22) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
;    in_name4(23) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(24) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
;    in_name4(25) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name4(26) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
;    in_name4(27) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
;    in_name4(28) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
;    in_name4(29) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(30) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(31) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(32) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(33) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
;    in_name4(34) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name4(35) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(36) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(37) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(38) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(39) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name4(7)  = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(41) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name4(42) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name4)

    in_path5     = "~/data-model/CMIP5-hes/ua/historical/"
    in_name5     = new(nmod,string)
;    in_name5(0)  = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(1)  = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(2)  = "ua_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(3)  = "ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(4)  = "ua_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name5(0)  = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(1)  = "ua_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(2)  = "ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(3)  = "ua_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(4)  = "ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(5)  = "ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(10) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(11) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(12) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(13) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    in_name5(14) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(15) = "ua_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    in_name5(16) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(6)  = "ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(19) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
;    in_name5(18) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
;    in_name5(19) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name5(20) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name5(21) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(22) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    in_name5(23) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(24) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    in_name5(25) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name5(26) = "ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    in_name5(27) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    in_name5(28) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    in_name5(29) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(30) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(31) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(32) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(33) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    in_name5(34) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name5(35) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(36) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(37) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(38) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(39) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(7)  = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(41) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(42) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path6     = "~/data-model/CMIP5-hes/va/historical/"
    in_name6     = new(nmod,string)
;    in_name6(0)  = "va_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(1)  = "va_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(2)  = "va_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name6(3)  = "va_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(4)  = "va_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name6(0)  = "va_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(1)  = "va_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(2)  = "va_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(3)  = "va_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(4)  = "va_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(5)  = "va_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(10) = "va_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(11) = "va_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(12) = "va_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(13) = "va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    in_name6(14) = "va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(15) = "va_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    in_name6(16) = "va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(6)  = "va_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(19) = "va_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
;    in_name6(18) = "va_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
;    in_name6(19) = "va_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name6(20) = "va_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    in_name6(21) = "va_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(22) = "va_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    in_name6(23) = "va_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(24) = "va_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    in_name6(25) = "va_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name6(26) = "va_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    in_name6(27) = "va_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    in_name6(28) = "va_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    in_name6(29) = "va_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(30) = "va_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(31) = "va_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(32) = "va_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(33) = "va_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    in_name6(34) = "va_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name6(35) = "va_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(36) = "va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(37) = "va_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(38) = "va_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(39) = "va_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(7)  = "va_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(41) = "va_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name6(42) = "va_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
    yS = 1958
    yE  = 2004
    season = (/"MJJ","JJA","JAS","ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)

    lev = 2    ;850 hPa

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

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

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
    latN = 60
    latS = -60
    lonW = -90
    lonE = 150

;fig
    out_path = "~/hes/ENSO/Fig/Animation/"
    out_data = "./lag_regress_NDJ_CTI_and_g_wspd_anom_remove_trend_model.nc"
    out_name = "lag_regress_NDJ_CTI_and_g_wspd_anom_remove_trend_model_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
    text3 = (/"OBS","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","FIO-ESM","MRI-CGCM3"/)
    text4 = (/" "+yS+"-"+yE,"m~F34~W~F~s~S~-1~N~/~F35~J~F~C"/)
    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in4 = addfile (in_path4 + in_name4(i),"r")
    in5 = addfile (in_path5 + in_name5(i),"r")
    in6 = addfile (in_path6 + in_name6(i),"r")

;get the time indexes
    time4  = in4->time
    time5  = in5->time
    year4  = cd_calendar (time4,-1) /100
    year5  = cd_calendar (time5,-1) /100
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)
    iYYYY5 = ind (year5.ge.yS .and. year5.le.yE)

    ts = in4->ts(iYYYY4,:,:)
    ua = in5->ua(iYYYY5,lev,:,:)
    va = in6->va(iYYYY5,lev,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then
     lat4 = in4->lat
     lat5 = in5->lat
     lon5 = in5->lon

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
     sst    = in1->sst(iYYYY1,:,:)
     uwnd   = in2->uwnd(iYYYY2,lev,::-1,:)
     vwnd   = in3->vwnd(iYYYY3,lev,::-1,:)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw  = cos (rad*lat4)
     copy_VarCoords (lat4,gw)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   ua  = wind_speed (ua,va)
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLL (ua)
   tsA = calcMonAnomTLL (ts,clm3)
   uaA = calcMonAnomTLL (ua,clm4)
   tsA = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   uaA = (/dtrend_msg_n (uaA&time,uaA,False,False,0)/)

;compute seasonal means
   tsA_S = month_to_season (tsA,season(6))
   uaA_S = month_to_seasonN (uaA,season)
   dim   = dimsizes (uaA_S)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2_NDJ = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr   = new((/dim(0),dim(2),dim(3),nmod+1/),float)
    ccr!3 = "model"
    copy_VarMeta (uaA_S(:,0,:,:),ccr(:,:,:,0))
   end if

;compute linear regression
   ccr(:,:,:,i+1)  = (/regCoef_n (I2_NDJ,uaA_S,0,1)/)
   ccr(7:,:,:,i+1) = (/regCoef_n (I2_NDJ(:dim(1)-2),uaA_S(7:,1:,:,:),0,1)/)
/;
;test
print ( (/ min( wgt_areaave_Wrap( ccr(6:,{latN1:latS1},{lonW1:lonE1},i+1), cos(rad*lat5({latN1:latS1})), 1.,0 ) ) /) )
print ( (/ min( wgt_areaave_Wrap( ccr(6:,{latN2:latS2},{lonW2:lonE2},i+1), cos(rad*lat5({latN2:latS2})), 1.,0 ) ) /) )
TIO1 = wgt_areaave_Wrap ( uaA_S(:,:,{latN1:latS1},{lonW1:lonE1}), cos(rad*lat5({latN2:latS2})), 1., 0)
TNA1 = wgt_areaave_Wrap ( uaA_S(:,:,{latN2:latS2},{lonW2:lonE2}), cos(rad*lat5({latN2:latS2})), 1., 0)
rTIO1 = regCoef (I2_NDJ,TIO1)
rTNA1 = regCoef (I2_NDJ,TNA1)
rTIO1(7:) = (/regCoef ( I2_NDJ(:dim(1)-2), TIO1(7:,1:) )/)
rTNA1(7:) = (/regCoef ( I2_NDJ(:dim(1)-2), TNA1(7:,1:) )/)
print ( (/ min (rTIO1(6:)) /) )
print ( (/ min (rTNA1(6:)) /) )

;--------------------------------------------------------------
TIO = wgt_areaave_Wrap ( uaA_S(:,:,{latN1:latS1},{lonW1:lonE1}), cos(rad*lat5({latN1:latS1})), 1., 0)
TNA = wgt_areaave_Wrap ( uaA_S(:,:,{latN2:latS2},{lonW2:lonE2}), cos(rad*lat5({latN2:latS2})), 1., 0)
rTIO = (/regCoef (I2_NDJ,TIO)/)
rTNA = (/regCoef (I2_NDJ,TNA)/)
rTIO(7:) = (/regCoef ( I2_NDJ(:dim(1)-2), TIO(7:,1:) )/)
rTNA(7:) = (/regCoef ( I2_NDJ(:dim(1)-2), TNA(7:,1:) )/)
ccr1     = wgt_areaave_Wrap( regCoef_n( I2_NDJ, uaA_S(:,:,{latN1:latS1},{lonW1:lonE1}), 0,1 ), cos(rad*lat5({latN1:latS1})), 1.,0 )
ccr1(7:) = (/wgt_areaave_Wrap( regCoef_n( I2_NDJ(:dim(1)-2), uaA_S(7:,1:,{latN1:latS1},{lonW1:lonE1}), 0,1), cos(rad*lat5({latN1:latS1})), 1.,0 ) /)
ccr2     = wgt_areaave_Wrap( regCoef_n( I2_NDJ, uaA_S(:,:,{latN2:latS2},{lonW2:lonE2}), 0,1 ), cos(rad*lat5({latN2:latS2})), 1.,0 )
ccr2(7:) = (/wgt_areaave_Wrap( regCoef_n( I2_NDJ(:dim(1)-2), uaA_S(7:,1:,{latN2:latS2},{lonW2:lonE2}), 0,1), cos(rad*lat5({latN2:latS2})), 1.,0 ) /)
print ( min(ccr1(6:))+" "+min(rTIO(6:))+" "+min(ccr2(6:))+" "+min(rTNA(6:)) )
;/
   if(i.eq.0)then
    uwnd  = wind_speed (uwnd,vwnd)
    clm1  = clmMonTLL (sst)
    clm2  = clmMonTLL (uwnd)
    sstA  = calcMonAnomTLL (sst,clm1)
    uwndA = calcMonAnomTLL (uwnd,clm2)
    sstA  = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    uwndA = (/dtrend_msg_n (uwndA&time,uwndA,False,False,0)/)
    sstA_S  = month_to_season (sstA,season(6))
    uwndA_S = month_to_seasonN (uwndA,season)
    I1_NDJ  = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    ccr(:,:,:,0)  = (/regCoef_n (I1_NDJ,uwndA_S,0,1)/)
    ccr(7:,:,:,0) = (/regCoef_n (I1_NDJ(:dim(1)-2),uwndA_S(7:,1:,:,:),0,1)/)
    copy_VarMeta (uwndA_S(:,0,:,:),ccr(:,:,:,0))
    dim1 = dimsizes (ccr)
    printVarSummary (ccr)
/;
;test
print ( (/ min( wgt_areaave_Wrap( ccr0(6:,{latN1:latS1},{lonW1:lonE1}), cos(rad*lat5({latN1:latS1})), 1.,0 ) ) /) )
print ( (/ min( wgt_areaave_Wrap( ccr0(6:,{latN2:latS2},{lonW2:lonE2}), cos(rad*lat5({latN2:latS2})), 1.,0 ) ) /) )
TIO1 = wgt_areaave_Wrap ( uwndA_S(:,:,{latN1:latS1},{lonW1:lonE1}), cos(rad*lat5({latN2:latS2})), 1., 0)
TNA1 = wgt_areaave_Wrap ( uwndA_S(:,:,{latN2:latS2},{lonW2:lonE2}), cos(rad*lat5({latN2:latS2})), 1., 0)
rTIO1 = (/regCoef (I1_NDJ,TIO1)/)
rTNA1 = (/regCoef (I1_NDJ,TNA1)/)
rTIO1(7:) = (/regCoef ( I1_NDJ(:dim(1)-2), TIO1(7:,1:) )/)
rTNA1(7:) = (/regCoef ( I1_NDJ(:dim(1)-2), TNA1(7:,1:) )/)
print ( (/ min (rTIO1(6:)) /) )
print ( (/ min (rTNA1(6:)) /) )

;--------------------------------------------------------------
TIO = wgt_areaave_Wrap ( uwndA_S(:,:,{latN1:latS1},{lonW1:lonE1}), cos(rad*lat5({latN1:latS1})), 1., 0)
TNA = wgt_areaave_Wrap ( uwndA_S(:,:,{latN2:latS2},{lonW2:lonE2}), cos(rad*lat5({latN2:latS2})), 1., 0)
rTIO = (/regCoef (I1_NDJ,TIO)/)
rTNA = (/regCoef (I1_NDJ,TNA)/)
rTIO(7:) = (/regCoef ( I1_NDJ(:dim(1)-2), TIO(7:,1:) )/)
rTNA(7:) = (/regCoef ( I1_NDJ(:dim(1)-2), TNA(7:,1:) )/)
ccr1     = wgt_areaave_Wrap( regCoef_n( I1_NDJ, uwndA_S(:,:,{latN1:latS1},{lonW1:lonE1}), 0,1 ), cos(rad*lat5({latN1:latS1})), 1.,0 )
ccr1(7:) = (/wgt_areaave_Wrap( regCoef_n( I1_NDJ(:dim(1)-2), uwndA_S(7:,1:,{latN1:latS1},{lonW1:lonE1}), 0,1), cos(rad*lat5({latN1:latS1})), 1.,0 ) /)
ccr2     = wgt_areaave_Wrap( regCoef_n( I1_NDJ, uwndA_S(:,:,{latN2:latS2},{lonW2:lonE2}), 0,1 ), cos(rad*lat5({latN2:latS2})), 1.,0 )
ccr2(7:) = (/wgt_areaave_Wrap( regCoef_n( I1_NDJ(:dim(1)-2), uwndA_S(7:,1:,{latN2:latS2},{lonW2:lonE2}), 0,1), cos(rad*lat5({latN2:latS2})), 1.,0 ) /)
print ( min(ccr1(6:))+" "+min(rTIO(6:))+" "+min(ccr2(6:))+" "+min(rTNA(6:)) )
;/
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time4,time5,year4,year5/])

end do

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","lat","lon","model"/)
dimSizes = dim1
dimUnlim = (/True,False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer",   "season")
filevardef (fout,"lat",   typeof(lat5),getvardims(lat5))
filevardef (fout,"lon",   typeof(lon5),getvardims(lon5))
filevardef (fout,"model", "integer",   "model")
filevardef (fout,"ccr",   typeof(ccr), getvardims(ccr))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"lat",lat5)
filevarattdef (fout,"lon",lon5)
filevarattdef (fout,"ccr",ccr)

;output only the data values
fout->season = ispan(-6,dim(0)-7,1)
fout->lat    = (/lat5/)
fout->lon    = (/lon5/)
fout->model  = ispan(1,dim1(3),1) 
fout->ccr    = (/ccr/)

else

 in   = addfile (out_data,"r")
 ccr  = in->ccr
 dim1 = dimsizes (ccr)
 printVarSummary (ccr)

end if

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .026

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-1.2,-.6,-.3,-.15,.15,.3,.6,1.2/)

res@lbLabelBarOn = False

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.025
res@tmYLLabelFontHeightF = 0.025

res@mpFillOn               = False
;res@mpCenterLonF           = 20
;res@mpLandFillColor        = "gray80"
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 2.0          ; thickness of lines

dum1 = new ((/4,dim1(3)/),graphic)  
dum2 = new ((/4,dim1(3)/),graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.022
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.016
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0,dim1(0)-1

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))
 plot = new (dim1(3),graphic)

 do j = 0,dim1(3)-1

  res@gsnLeftString   = text2(j)+" "+text3(j)
;  res@gsnCenterString = sprintf("%5.3f",r(i))
  if (j.eq.0)then
   res@gsnCenterString = text4(0)
   res@gsnRightString  = text4(1)
  else
   res@gsnCenterString = " "
   res@gsnRightString  = " "
  end if

  if (j.ge.6)then
   res@tmXBLabelsOn = True
  else
   res@tmXBLabelsOn = False
  end if
  if (mod(j,3).eq.0)then
   res@tmYLLabelsOn = True
  else
   res@tmYLLabelsOn = False
  end if

  plot(j) = gsn_csm_contour_map_ce (wks,ccr(i,:,:,j),res)

;----------------------------------------------------------
  do k =0,3
   dum1(k,j) = gsn_add_polyline (wks,plot(j),xpts1(k:k+1),ypts1(k:k+1),resb)
   dum2(k,j) = gsn_add_polyline (wks,plot(j),xpts2(k:k+1),ypts2(k:k+1),resb)
  end do

 end do

 resP@txString = "Regression at "+text5(i)+" of WSPD onto NDJ CTI"
 gsn_panel (wks,plot,(/3,3/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
