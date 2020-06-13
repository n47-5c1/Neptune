;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly SSTAs removed trend in the tropical
;     Indian Ocean as well as in the tropical North Atlantic onto the NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2018-04-04
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
;   var2--------------ts
;================================================

    process = False      ;Statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name0 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"

    in_path1     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name1     = new(27,string)
    in_name1(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name1(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name1(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name1(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(6)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(7)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(8)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(4)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(5)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(6)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
;    in_name1(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(7)  = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name1(7)  = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name1(8)  = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name1(9)  = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
;    in_name1(4)  = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(10) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name1(11) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(12) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
;    in_name1(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name1(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name1(13) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name1(14) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name1(15) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(16) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(17) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(18) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name1(19) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name1(20) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(21) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(22) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(23) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(24) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name1(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name1(25) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name1(26) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name1)

    in_path2     = "~/data-model/CMIP5-hes/ts/rcp45/"
    in_name2     = new(nmod,string)
    in_name2(0)  = "ts_Amon_ACCESS1-0_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(1)  = "ts_Amon_ACCESS1-3_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(2)  = "ts_Amon_bcc-csm1-1_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(3)  = "ts_Amon_CanESM2_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(4)  = "ts_Amon_CMCC-CM_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(5)  = "ts_Amon_CMCC-CMS_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(6)  = "ts_Amon_CSIRO-Mk3-6-0_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(7)  = "ts_Amon_GFDL-CM3_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(8)  = "ts_Amon_GFDL-ESM2G_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(9)  = "ts_Amon_GFDL-ESM2M_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(10) = "ts_Amon_GISS-E2-H-CC_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(11) = "ts_Amon_GISS-E2-R_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(12) = "ts_Amon_GISS-E2-R-CC_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(13) = "ts_Amon_HadGEM2-CC_rcp45_r1i1p1_200512-210012_2x2.nc"
    in_name2(14) = "ts_Amon_HadGEM2-ES_rcp45_r1i1p1_200512-229912_2x2.nc"
    in_name2(15) = "ts_Amon_inmcm4_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(16) = "ts_Amon_IPSL-CM5A-LR_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(17) = "ts_Amon_IPSL-CM5A-MR_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(18) = "ts_Amon_IPSL-CM5B-LR_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(19) = "ts_Amon_MIROC5_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(20) = "ts_Amon_MIROC-ESM_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(21) = "ts_Amon_MIROC-ESM-CHEM_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(22) = "ts_Amon_MPI-ESM-LR_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(23) = "ts_Amon_MPI-ESM-MR_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(24) = "ts_Amon_MRI-CGCM3_rcp45_r1i1p1_200601-210012_2x2.nc"
    in_name2(25) = "ts_Amon_NorESM1-M_rcp45_r1i1p1_200601-230012_2x2.nc"
    in_name2(26) = "ts_Amon_NorESM1-ME_rcp45_r1i1p1_200601-210212_2x2.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/rcp85/"
    in_name3     = new(27,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(3)  = "ts_Amon_CanESM2_rcp85_r1i1p1_200601-210012_2x2.nc"
;    in_name3(4)  = "ts_Amon_CMCC-CESM_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(4)  = "ts_Amon_CMCC-CM_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(5)  = "ts_Amon_CMCC-CMS_rcp85_r1i1p1_200601-210012_2x2.nc"
 ;   in_name3(7)  = "ts_Amon_CNRM-CM5_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(6)  = "ts_Amon_CSIRO-Mk3-6-0_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(7)  = "ts_Amon_GFDL-CM3_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(8)  = "ts_Amon_GFDL-ESM2G_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(9)  = "ts_Amon_GFDL-ESM2M_rcp85_r1i1p1_200601-210012_2x2.nc"
;    in_name3(12) = "ts_Amon_GISS-E2-H_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(10) = "ts_Amon_GISS-E2-H-CC_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(11) = "ts_Amon_GISS-E2-R_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(12) = "ts_Amon_GISS-E2-R-CC_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(13) = "ts_Amon_HadGEM2-CC_rcp85_r1i1p1_200512-210012_2x2.nc"
    in_name3(14) = "ts_Amon_HadGEM2-CC_rcp85_r1i1p1_200512-210012_2x2.nc"
;/!    in_name3(14) = "ts_Amon_HadGEM2-ES_rcp85_r1i1p1_200512-229912_2x2.nc"
    in_name3(15) = "ts_Amon_inmcm4_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(16) = "ts_Amon_IPSL-CM5A-LR_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(17) = "ts_Amon_IPSL-CM5A-MR_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(18) = "ts_Amon_IPSL-CM5B-LR_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(19) = "ts_Amon_MIROC5_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(20) = "ts_Amon_MIROC-ESM_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(21) = "ts_Amon_MIROC-ESM-CHEM_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(22) = "ts_Amon_MPI-ESM-LR_rcp85_r1i1p1_200601-230012_2x2.nc"
    in_name3(23) = "ts_Amon_MPI-ESM-MR_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(24) = "ts_Amon_MRI-CGCM3_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(25) = "ts_Amon_NorESM1-M_rcp85_r1i1p1_200601-210012_2x2.nc"
    in_name3(26) = "ts_Amon_NorESM1-ME_rcp85_r1i1p1_200601-210012_2x2.nc"

;    bTIO = (/True,True,False,True,True,False,False,True,True,True,False,False,True,True,False,False,True,True/)
;    bTNA = (/False,False,True,False,True,True,True,False,False,False,True,True,True,False,True,True,True,False/)
    iM =(/0,13,22,25,26/)+2

;time
    yS1 = 1958
    yS2 = 2054
    yE1 = 2004
    yE2 = 2100
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    maxlag = dimsizes (season)

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

    rTIO = new((/3,maxlag,nmod/),float)
    rTNA = new((/3,maxlag,nmod/),float)

;Fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP_RCP.nc"
    out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP_RCP"

;text
    text1 = (/"a)","b)"/)
    text2 = (/yS1+"-"+yE1+" & "+yS2+"-"+yE2,"~F35~J~F~C/~F35~J~F~C"/)
    text3 = (/"RCP4.5","Historical"/)
    text4 = (/"RCP8.5","Historical"/)
;    text2 = (/"RCP4.5","RCP8.5"/)
    text5 = (/"OBS (TIO)","MMM","MSs"/)
    text6 = (/"OBS (TNA)","MMM","MSs"/)

    x       = (/.13,.13,.13/)
    y       = (/.69,.67,.65/)
    colors  = (/"red2","dodgerblue2"/)
    sizes   = (/.022,.025,.04/)
    indexes = (/1,5,1/)
    thicknesses = (/3.,5,1./)

if (process) then

do i=0,nmod-1

    print (i+" ing...")
; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
     in1 = addfile (in_path1 + in_name1(i),"r")
     in2 = addfile (in_path2 + in_name2(i),"r")
     in3 = addfile (in_path3 + in_name3(i),"r")

;get the time indexes
     time1  = in1->time
     time2  = in2->time
     time3  = in3->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     year3  = cd_calendar (time3,-1) /100
     iYYYY1 = ind (year1.ge.yS1 .and. year1.le.yE1)
     iYYYY2 = ind (year2.ge.yS2 .and. year2.le.yE2)
     iYYYY3 = ind (year3.ge.yS2 .and. year3.le.yE2)

     sst1 = in1->ts(iYYYY1,:,:)
     sst2 = in2->ts(iYYYY2,:,:)
     sst3 = in3->ts(iYYYY3,:,:)
;     sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then 
     in0    = addfile (in_name0,"r")
     time0  = in0->time
     year0  = cd_calendar (time0,-1) /100
     iYYYY0 = ind (year0.ge.yS1 .and. year0.le.yE1)
     sst0   = in0->sst(iYYYY0,:,:)
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = in1->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm1  = clmMonTLL (sst1)
   clm2  = clmMonTLL (sst2)
   clm3  = clmMonTLL (sst3)
   SSTA1 = calcMonAnomTLL (sst1, clm1)
   SSTA2 = calcMonAnomTLL (sst2, clm2)
   SSTA3 = calcMonAnomTLL (sst3, clm3)
   SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
   SSTA2 = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
   SSTA3 = (/dtrend_msg_n (SSTA3&time,SSTA3,False,False,0)/)

;compute seasonal means
   SSTA1_3M = month_to_seasonN (SSTA1,season)
   SSTA2_3M = month_to_seasonN (SSTA2,season)
   SSTA3_3M = month_to_seasonN (SSTA3,season)

;--------------------------------------------------------------
;compute linear regression

;cold tongue (NDJ)
   CTI1 = wgt_areaave_Wrap ( SSTA1_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   CTI2 = wgt_areaave_Wrap ( SSTA2_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   CTI3 = wgt_areaave_Wrap ( SSTA3_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   dim = dimsizes (CTI1)
;tropical Indian Ocean
;   if (bTIO(i)) then
    TIO1 = wgt_areaave_Wrap ( SSTA1_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TIO2 = wgt_areaave_Wrap ( SSTA2_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TIO3 = wgt_areaave_Wrap ( SSTA3_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    rTIO(0,:,i)  = (/regCoef (CTI1,TIO1)/)
    rTIO(1,:,i)  = (/regCoef (CTI2,TIO2)/)
    rTIO(2,:,i)  = (/regCoef (CTI3,TIO3)/)
    rTIO(0,1:,i) = (/regCoef ( CTI1(:dim-2), TIO1(1:,1:) )/)
    rTIO(1,1:,i) = (/regCoef ( CTI2(:dim-2), TIO2(1:,1:) )/)
    rTIO(2,1:,i) = (/regCoef ( CTI3(:dim-2), TIO3(1:,1:) )/)
;   end if
;tropical North Atlantic
;   if (bTNA(i)) then
    TNA1 = wgt_areaave_Wrap ( SSTA1_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    TNA2 = wgt_areaave_Wrap ( SSTA2_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    TNA3 = wgt_areaave_Wrap ( SSTA3_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    rTNA(0,:,i)  = (/regCoef (CTI1,TNA1)/)
    rTNA(1,:,i)  = (/regCoef (CTI2,TNA2)/)
    rTNA(2,:,i)  = (/regCoef (CTI3,TNA3)/)
    rTNA(0,1:,i) = (/regCoef ( CTI1(:dim-2), TNA1(1:,1:) )/)
    rTNA(1,1:,i) = (/regCoef ( CTI2(:dim-2), TNA2(1:,1:) )/)
    rTNA(2,1:,i) = (/regCoef ( CTI3(:dim-2), TNA3(1:,1:) )/)
;   end if

   if(i.eq.0)then
;    copy_VarCoords (TIO1,rTIO(0,:,0))
;    copy_VarCoords (TNA1,rTNA(0,:,0))

    clm0  = clmMonTLL (sst0)
    SSTA0 = calcMonAnomTLL (sst0, clm0)
    SSTA0 = (/dtrend_msg_n (SSTA0&time,SSTA0,False,False,0)/)
    SSTA0_3M = month_to_seasonN (SSTA0,season)
    CTI0 = wgt_areaave_Wrap ( SSTA0_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    TIO0 = wgt_areaave_Wrap ( SSTA0_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TNA0 = wgt_areaave_Wrap ( SSTA0_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    rTIO0 = regCoef (CTI0,TIO0)
    rTNA0 = regCoef (CTI0,TNA0)
    rTIO0(1:) = regCoef ( CTI0(:dim-2), TIO0(1:,1:) )
    rTNA0(1:) = regCoef ( CTI0(:dim-2), TNA0(1:,1:) )
    copy_VarCoords (TIO0,rTIO0)
    copy_VarCoords (TNA0,rTNA0)

   end if

   delete([/time1,time2,time3,year1,year2,year3/])

end do

   mnmx = new((/2,3,nmod+2/),float)
   mnmx(0,:,0)  = max (rTIO0)
   mnmx(0,:,2:) = dim_max_n (rTIO,1)
   mnmx(0,:,1)  = dim_avg ( mnmx(0,:,2:) )
   mnmx(1,:,0)  = max (rTNA0)
   mnmx(1,:,2:) = dim_max_n (rTNA,1)
   mnmx(1,:,1)  = dim_avg ( mnmx(1,:,2:) )

   std = dim_stddev_Wrap (mnmx(:,:,2:))

   mnmx!0 = "region"
   mnmx!1 = "period"
   mnmx!2 = "member"
   std!0  = "region"
   std!1  = "period"

   printVarSummary (mnmx)
   printVarSummary (std)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

ndim   = dimsizes (mnmx)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","period","member"/)
dimSizes = ndim
dimUnlim = (/False,False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"period","integer","period")
filevardef (fout,"member","integer","member")
filevardef (fout,"mnmx",typeof(mnmx),getvardims(mnmx))
filevardef (fout,"std",typeof(std),getvardims(std))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)
filevarattdef (fout,"std",std)

;output only the data values
fout->region = ispan (1,2,1)
fout->period = ispan (1,3,1)
fout->member = ispan (1,nmod+2,1)
fout->mnmx   = (/mnmx/)
fout->std    = (/std/)

else

 in   = addfile (out_data,"r")
 mnmx = in->mnmx
 std  = in->std
 printVarSummary (mnmx)
 printVarSummary (std)

end if

; print ((/mnmx(:,(/0,2/))/))
; print ( ind( mnmx(1,3:).lt..1 ) )
; print ( (/mnmx(1, ind(mnmx(1,:).lt..1) )/) )

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks = gsn_open_wks ("svg",out_path+out_name)

plot  = new (2,graphic)        
plot1 = new (2,graphic)        
plot2 = new (2,graphic)        
plot3 = new (2,graphic)        
plot4 = new (2,graphic)        

dum1 = new (2,graphic)        
dum2 = new (2,graphic)        
dum3 = new (2,graphic)        

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiXAxisFontHeightF = .023

res@trYMaxF = .55
res@trYMinF = .0
res@trXMaxF = .55
res@trXMinF = .0

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(2)
res@xyMarkerSizeF  = sizes(2)
res@xyMarkerColor  = colors(0)

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = text2(1)
res@tiYAxisString   = text3(0)
res@tiXAxisString   = text3(1)
plot(0) = gsn_csm_xy (wks,mnmx(0,0,2:),mnmx(0,1,2:),res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
res@tiYAxisString   = text4(0)
res@tiXAxisString   = text4(1)
plot(1) = gsn_csm_xy (wks,mnmx(0,0,2:),mnmx(0,2,2:),res)

res@gsnLeftString = " "
res@xyMarker      = 2
res@xyMarkerSizeF      = sizes(1)
res@xyMarkerThicknessF = thicknesses(0)
plot1(0) = gsn_csm_xy (wks,mnmx(0,0,iM),mnmx(0,1,iM),res)
plot1(1) = gsn_csm_xy (wks,mnmx(0,0,iM),mnmx(0,2,iM),res)

overlay (plot(0),plot1(0))
overlay (plot(1),plot1(1))

;--------------------------------------------------------------
; add the line
resl                   = True
resl@gsLineThicknessF  = 2.
resl@gsLineDashPattern = indexes(0)
dum1(0) = gsn_add_polyline (wks,plot(0),(/0,.6/),(/0,.6/),resl)
dum1(1) = gsn_add_polyline (wks,plot(1),(/0,.6/),(/0,.6/),resl)

resl@gsLineColor      = colors(0)
resl@gsLineThicknessF = thicknesses(0)
dum2(0) = gsn_add_polyline (wks,plot(0),(/mnmx(0,0,0),mnmx(0,0,0)/),(/res@trYMinF,res@trYMaxF/),resl)
dum2(1) = gsn_add_polyline (wks,plot(1),(/mnmx(0,0,0),mnmx(0,0,0)/),(/res@trYMinF,res@trYMaxF/),resl)

resl@gsLineColor = colors(1)
dum3(0) = gsn_add_polyline (wks,plot(0),(/mnmx(1,0,0),mnmx(1,0,0)/),(/res@trYMinF,res@trYMaxF/),resl)
dum3(1) = gsn_add_polyline (wks,plot(1),(/mnmx(1,0,0),mnmx(1,0,0)/),(/res@trYMinF,res@trYMaxF/),resl)

;resl@gsLineColor       = colors(2)
;resl@gsLineThicknessF  = 3
;resl@gsLineDashPattern = 0
;a = (res@trYMaxF-res@trYMinF)/50.
;dum1 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2),mnmx(1,2)/),resl)
;dum2 = gsn_add_polyline (wks,plot,(/mnmx(0,2),mnmx(0,2)/),(/mnmx(1,2)-std(1),mnmx(1,2)+std(1)/),resl)
;dum3 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)-std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
;dum4 = gsn_add_polyline (wks,plot,(/mnmx(0,2)+std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
;dum5 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)-std(1),mnmx(1,2)-std(1)/),resl)
;dum6 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)+std(1),mnmx(1,2)+std(1)/),resl)

;--------------------------------------------------------------
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"

reso@xyMarker      = indexes(2)
reso@xyMarkerSizeF = sizes(2)
reso@xyMarkerColor = colors(1)
plot2(0) = gsn_csm_xy (wks,mnmx(1,0,2:),mnmx(1,1,2:),reso)
plot2(1) = gsn_csm_xy (wks,mnmx(1,0,2:),mnmx(1,2,2:),reso)

reso@xyMarker = 2
reso@xyMarkerSizeF      = sizes(1)
reso@xyMarkerThicknessF = thicknesses(0)
plot3(0) = gsn_csm_xy (wks,mnmx(1,0,iM),mnmx(1,1,iM),reso)
plot3(1) = gsn_csm_xy (wks,mnmx(1,0,iM),mnmx(1,2,iM),reso)

reso@xyMarker       = indexes(1)
reso@xyMarkerSizeF  = sizes(1)
reso@xyMarkerColors = colors
reso@xyMarkerThicknessF = thicknesses(1)
plot4(0) = gsn_csm_xy (wks, transpose((/mnmx(:,0,1),mnmx(:,0,1)/)), transpose((/mnmx(:,1,1),mnmx(:,1,1)/)), reso)
plot4(1) = gsn_csm_xy (wks, transpose((/mnmx(:,0,1),mnmx(:,0,1)/)), transpose((/mnmx(:,2,1),mnmx(:,2,1)/)), reso)

overlay (plot(0),plot2(0))
overlay (plot(1),plot2(1))
overlay (plot(0),plot3(0))
overlay (plot(1),plot3(1))
overlay (plot(0),plot4(0))
overlay (plot(1),plot4(1))

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@gsnFrame       = False
resP@gsnPanelBottom = 0.08

resP@txString      = "Max Regression of Regional SSTA onto NDJ CTI"
resP@txFontHeightF = 0.024

gsn_panel(wks,plot,(/1,2/),resP)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=1,2
 do j=0,1
  gsres@gsMarkerSizeF = sizes(i)*.7
  gsres@gsMarkerColor = colors(j)
  gsres@gsMarkerIndex = indexes(i)
  gsres@gsMarkerThicknessF = thicknesses(i)
  gsn_polymarker_ndc (wks,x(i),y(i)-j*.07,gsres)
 end do
end do

lgres = True
lgres@vpWidthF     = 0.05
lgres@vpHeightF    = 0.146
lgres@lgPerimOn        = False
lgres@lgDashIndexes    = (/indexes(0),indexes(0)/)
lgres@lgLineColors     = colors(::-1)
lgres@lgLineThicknessF = thicknesses(0)
gsn_legend_ndc(wks,2,(/" "," "/),x(0)-.025,y(0)+.04,lgres)

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.013

gsn_text_ndc (wks,text5,x+.024,y,txres)
gsn_text_ndc (wks,text6,x+.024,y-.07,txres)

frame (wks)

end
