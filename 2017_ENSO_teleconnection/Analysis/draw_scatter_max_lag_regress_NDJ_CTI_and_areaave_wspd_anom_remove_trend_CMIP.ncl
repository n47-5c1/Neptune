;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly wind speed anomalies removed trend
;     in the tropical Indian Ocean as well as in the tropical North Atlantic onto NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2018-01-03
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
;   var2--------------uwnd
;   var3--------------ts
;   var3--------------ua
;================================================

    process = False      ;Statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name0 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name1 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/vwnd.mon.mean.nc"

    in_path1     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(43,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(3)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(4)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(10) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(12) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(14) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(15) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(16) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(17) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(19) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(20) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(21) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(22) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(23) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(24) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(25) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    in_name3(26) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(27) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(28) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(29) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(30) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(31) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(32) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(33) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name3(34) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(35) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(36) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(37) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(38) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(39) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(40) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(41) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(42) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name3)

    in_path2     = "~/data-model/CMIP5-hes/ua/historical/"
    in_name4     = new(nmod,string)
    in_name4(0)  = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "ua_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(3)  = "ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(4)  = "ua_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(4)  = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "ua_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "ua_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(8)  = "ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(9)  = "ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(10) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(12) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(13) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(14) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(15) = "ua_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(16) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(17) = "ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(19) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name4(18) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name4(19) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(20) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(21) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(22) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(23) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(24) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(25) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name4(26) = "ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(27) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(28) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(29) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(30) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(31) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(32) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(33) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(34) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(35) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(36) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(37) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(38) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(39) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(40) = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(41) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(42) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

    in_path3     = "~/data-model/CMIP5-hes/va/historical/"
    in_name5     = new(nmod,string)
    in_name5(0)  = "va_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(1)  = "va_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(2)  = "va_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name5(3)  = "va_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(4)  = "va_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name5(4)  = "va_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(5)  = "va_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(6)  = "va_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(7)  = "va_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(8)  = "va_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(9)  = "va_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(10) = "va_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(11) = "va_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(12) = "va_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(13) = "va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name5(14) = "va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(15) = "va_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name5(16) = "va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(17) = "va_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name5(19) = "va_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name5(18) = "va_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name5(19) = "va_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name5(20) = "va_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name5(21) = "va_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(22) = "va_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(23) = "va_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(24) = "va_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name5(25) = "va_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name5(26) = "va_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name5(27) = "va_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(28) = "va_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name5(29) = "va_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(30) = "va_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(31) = "va_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(32) = "va_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(33) = "va_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name5(34) = "va_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name5(35) = "va_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(36) = "va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(37) = "va_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(38) = "va_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(39) = "va_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(40) = "va_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(41) = "va_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name5(42) = "va_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
    yS = 1958
    yE = 2004
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

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

    rTIO = new((/maxlag,nmod/),float)
    rTNA = new((/maxlag,nmod/),float)

;Fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd_anom_remove_trend_CMIP.nc"
    out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd_anom_remove_trend_CMIP"

;text
;    text1 = (/yS+"-"+yE,"m/(s~F34~W~F35~J~F~C)"/)
    text1 = (/yS+"-"+yE,"m~F34~W~F~s~S~-1~N~/~F35~J~F~C"/)
    text2 = (/"TNA","TIO"/)
    text3 = (/"Obs.","MMM","Model Samples"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors  = (/"red3","dodgerblue2","black"/)
    sizes   = (/.025,.025,.04/)
    indexes = (/5,5,1/)
    thicknesses = (/5,5,1/)

if (process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in3 = addfile (in_path1 + in_name3(i),"r")
    in4 = addfile (in_path2 + in_name4(i),"r")
    in5 = addfile (in_path3 + in_name5(i),"r")

;get the time indexes
    time3  = in3->time
    time4  = in4->time
    year3  = cd_calendar (time3,-1) /100
    year4  = cd_calendar (time4,-1) /100
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    sst2 = in3->ts(iYYYY3,:,:)
    ua   = in4->ua(iYYYY4,lev,:,:)
    va   = in5->va(iYYYY4,lev,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in0    = addfile (in_name0,"r")
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time0  = in0->time
     time1  = in1->time
     time2  = in2->time
     year0  = cd_calendar (time0,-1) /100
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY0 = ind (year0.ge.yS .and. year0.le.yE)
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst1   = in0->sst(iYYYY0,:,:)
     uwnd   = in1->uwnd(iYYYY1,lev,:,:)
     vwnd   = in2->vwnd(iYYYY2,lev,:,:)

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw1 = in3->lat
     gw2 = in4->lat
     gw1 = cos (rad*gw1)
     gw2 = cos (rad*gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   ua    = wind_speed (ua,va)
   clm3  = clmMonTLL (sst2)
   clm4  = clmMonTLL (ua)
   SSTA2 = calcMonAnomTLL (sst2,clm3)
   uaA   = calcMonAnomTLL (ua,  clm4)
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
;tropical North Atlantic
   TNA = wgt_areaave_Wrap ( uaA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO(:,i) = (/regCoef (CTI,TIO)/)
   rTNA(:,i) = (/regCoef (CTI,TNA)/)
   rTIO(1:,i) = (/regCoef ( CTI(:dim-2), TIO(1:,1:) )/)
   rTNA(1:,i) = (/regCoef ( CTI(:dim-2), TNA(1:,1:) )/)

;test
ccr1     = wgt_areaave_Wrap( regCoef_n( CTI, uaA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), 0,1 ), gw2({latN1:latS1}), 1.,0 )
ccr1(1:) = (/wgt_areaave_Wrap( regCoef_n( CTI(:dim-2), uaA_3M(1:,1:,{latN1:latS1},{lonW1:lonE1}), 0,1), gw2({latN1:latS1}), 1.,0 ) /)
ccr2     = wgt_areaave_Wrap( regCoef_n( CTI, uaA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), 0,1 ), gw2({latN2:latS2}), 1.,0 )
ccr2(1:) = (/wgt_areaave_Wrap( regCoef_n( CTI(:dim-2), uaA_3M(1:,1:,{latN2:latS2},{lonW2:lonE2}), 0,1), gw2({latN2:latS2}), 1.,0 ) /)
print ( min(ccr1)+" "+min(rTIO(:,i))+" "+min(ccr2)+" "+min(rTNA(:,i)) )

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO(:,0))
    copy_VarCoords (TNA,rTNA(:,0))

    uwnd  = wind_speed (uwnd,vwnd)
    clm1  = clmMonTLL (sst1)
    clm2  = clmMonTLL (uwnd)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    uwndA = calcMonAnomTLL (uwnd, clm2)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    uwndA = (/dtrend_msg_n (uwndA&time,uwndA,False,False,0)/)
    SSTA1_3M = month_to_season (SSTA1,season(0))
    uwndA_3M = month_to_seasonN (uwndA,season)
    CTI1 = wgt_areaave_Wrap ( SSTA1_3M(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( uwndA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    TNA1 = wgt_areaave_Wrap ( uwndA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    rTIO1 = regCoef (CTI1,TIO1)
    rTNA1 = regCoef (CTI1,TNA1)
    rTIO1(1:) = regCoef ( CTI1(:dim-2), TIO1(1:,1:) )
    rTNA1(1:) = regCoef ( CTI1(:dim-2), TNA1(1:,1:) )
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TNA1,rTNA1)

;test
ccr1     = wgt_areaave_Wrap( regCoef_n( CTI1, uwndA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), 0,1 ), gw2({latN1:latS1}), 1.,0 )
ccr1(1:) = (/wgt_areaave_Wrap( regCoef_n( CTI1(:dim-2), uwndA_3M(1:,1:,{latN1:latS1},{lonW1:lonE1}), 0,1), gw2({latN1:latS1}), 1.,0 ) /)
ccr2     = wgt_areaave_Wrap( regCoef_n( CTI1, uwndA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), 0,1 ), gw2({latN2:latS2}), 1.,0 )
ccr2(1:) = (/wgt_areaave_Wrap( regCoef_n( CTI1(:dim-2), uwndA_3M(1:,1:,{latN2:latS2},{lonW2:lonE2}), 0,1), gw2({latN2:latS2}), 1.,0 ) /)
print ( min(ccr1)+" "+min(rTIO1)+" "+min(ccr2)+" "+min(rTNA1) )

   end if

   delete([/time3,time4,year3,year4/])

end do
exit
   mnmx = new((/2,nmod+2/),float)
   mnmx(0,0)  = min (rTIO1)
   mnmx(0,2:) = dim_min_n (rTIO,0)
   mnmx(0,1)  = dim_avg ( mnmx(0,2:) )
   mnmx(1,0)  = min (rTNA1)
   mnmx(1,2:) = dim_min_n (rTNA,0)
   mnmx(1,1)  = dim_avg ( mnmx(1,2:) )

   printVarSummary (mnmx)

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

 print ((/mnmx(:,:1)/))
 print ( ind( mnmx(0,2:).lt.-.6 ) )
 print ( (/mnmx(0, ind(mnmx(0,:).lt.-.6) )/) )

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
res@tiMainString       = "Max Regression of Regional WSPD onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = .1
res@trYMinF = -1.1
res@trXMaxF = .0
res@trXMinF = -1.2

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
dum1 = gsn_add_polyline (wks,plot,(/-1.1,.0/),(/-1.1,.0/),resl)
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
