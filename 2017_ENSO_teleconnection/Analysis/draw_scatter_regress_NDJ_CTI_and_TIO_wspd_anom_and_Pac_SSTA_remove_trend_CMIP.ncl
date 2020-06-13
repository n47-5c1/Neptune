;*************************************************************
;Aim: Draw a scatter plot of regression between November-December-January cold tongue index and three-month means of the sea surface temperature
;     anomalies removed trend at the Pacific equator in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-29
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------ts
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/wspd.mon.mean.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
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

    in_path4     = "~/data-model/CMIP5-hes/ua/historical/"
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

    in_path5     = "~/data-model/CMIP5-hes/va/historical/"
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
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)
    nlag   = dimsizes (season)

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

;region
    latN = 5
    latS = -5
    lonW = 140
    lonE = 180

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_regress_NDJ_CTI_and_TIO_wspd_anom_and_Pac_SSTA_remove_trend_CMIP.nc"
    out_name = "scatter_regress_NDJ_CTI_and_TIO_wspd_anom_and_Pac_SSTA_remove_trend_CMIP"

;text
    text1 = (/yS+"-"+yE,"m/s/~F35~J~F~C"/)
    text2 = (/"CT","TIO"/)
    text3 = (/"Obs.","MMM","Model Samples"/)

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

    ts = in3->ts(iYYYY3,:,:)
    ua  = in4->ua(iYYYY4,lev,:,:)
    va  = in5->va(iYYYY4,lev,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time1  = in1->time
     time2  = in2->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst    = in1->sst(iYYYY1,:,:)
     wspd   = in2->wspd(iYYYY2,lev,:,:)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1 = in3->lat
     gw2 = in4->lat
     gw1 = cos (rad*gw1)
     gw2 = cos (rad*gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   ua   = wind_speed (ua,va)
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLL (ua)
   tsA  = calcMonAnomTLL (ts,clm3)
   uaA  = calcMonAnomTLL (ua, clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   uaA  = (/dtrend_msg_n (uaA&time,uaA ,False,False,0)/)

;compute seasonal means
   tsA_S = month_to_season (tsA,season(0))
   uaA_S = month_to_seasonN (uaA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I_NDJ = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
   dim   = dimsizes (I_NDJ)
;tropical Indian Ocean
   TIO   = wgt_areaave_Wrap ( uaA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;the Pacific
   tsA_P = dim_avg_wgt_n_Wrap ( tsA_S(:,{latN:latS},{lonW:lonE}), gw1({latN:latS}), 1, 1)

;--------------------------------------------------------------
   ccr = new(nmod,float)
   rTIO = new((/nlag,nmod/),float)

;compute linear regression
   ccr(i)     = (/avg ( regCoef_n (I_NDJ,tsA_P,0,0) )/)
   rTIO(:,i)  = (/regCoef (I_NDJ,TIO)/)
   rTIO(1:,i) = (/regCoef ( I_NDJ(:dim-2), TIO(1:,1:) )/)

   if(i.eq.0)then
    copy_VarAtts (I_NDJ,ccr)
    copy_VarCoords (TIO,rTIO(:,0))

    clm1    = clmMonTLL (sst)
    clm2    = clmMonTLL (wspd)
    SSTA    = calcMonAnomTLL (sst, clm1)
    wspdA   = calcMonAnomTLL (wspd, clm2)
    SSTA    = (/dtrend_msg_n (SSTA&time,SSTA,False,False,0)/)
    wspdA   = (/dtrend_msg_n (wspdA&time,wspdA,False,False,0)/)
    SSTA_S  = month_to_season (SSTA,season(0))
    wspdA_S = month_to_seasonN (wspdA,season)

    I1_NDJ = wgt_areaave_Wrap ( SSTA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
    TIO1   = wgt_areaave_Wrap ( wspdA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    SSTA_P = dim_avg_wgt_n_Wrap ( SSTA_S(:,{latN:latS},{lonW:lonE}), gw2({latN:latS}), 1, 1)
    ccr1      = avg ( regCoef_n (I1_NDJ,SSTA_P,0,0) )
    rTIO1     = regCoef (I1_NDJ,TIO1)
    rTIO1(1:) = regCoef ( I1_NDJ(:dim-2), TIO1(1:,1:) )
    copy_VarAtts (I1_NDJ,ccr1)
    copy_VarCoords (TIO1,rTIO1)
    printVarSummary (ccr1)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time3,time4,year3,year4/])

end do

   mnmx = new((/2,nmod+2/),float)
   mnmx(0,0)  = min (rTIO1)
   mnmx(0,2:) = dim_min_n (rTIO,0)
   mnmx(0,1)  = dim_avg ( mnmx(0,2:) )
   mnmx(1,0)  = max (ccr1)
   mnmx(1,2:) = dim_max_n (ccr,0)
   mnmx(1,1)  = dim_avg ( mnmx(1,2:) )

   copy_VarAtts (I_NDJ,ccr)

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
res@gsnXRefLine     = mnmx(0,0)
res@gsnYRefLine     = mnmx(1,0)
res@gsnCenterString = text1(0)
res@gsnRightString  = text1(1)
res@gsnStringFontHeightF   = .024
res@gsnXRefLineThicknessF  = 2
res@gsnYRefLineThicknessF  = 2
res@gsnXRefLineDashPattern = 1
res@gsnYRefLineDashPattern = 1

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Max Regression between NDJ CTI and Regional WSPD"
res@tiMainFontHeightF  = .028

res@trYMaxF = 1.3
res@trYMinF = -.9
res@trXMaxF = 1.0
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
dum = gsn_add_polyline (wks,plot,(/-.9,.0/),(/-.9,.0/),resl)

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
