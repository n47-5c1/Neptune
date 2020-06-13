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
;                       2018-01-26
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------air
;   var3--------------ts
;   var4--------------ta
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc"

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

    in_path4     = "~/data-model/CMIP5-hes/ta/historical/"
    in_name4     = new(nmod,string)
    in_name4(0)  = "ta_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "ta_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "ta_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(2)  = "ta_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(3)  = "ta_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(3)  = "ta_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(3)  = "ta_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6)  = "ta_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7)  = "ta_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8)  = "ta_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9)  = "ta_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(10) = "ta_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "ta_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "ta_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "ta_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "ta_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(8)  = "ta_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(9)  = "ta_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(10) = "ta_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(10) = "ta_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(18) = "ta_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "ta_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name4(12) = "ta_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name4(13) = "ta_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "ta_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(15) = "ta_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "ta_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "ta_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "ta_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "ta_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name4(28) = "ta_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(20) = "ta_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(21) = "ta_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(22) = "ta_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(23) = "ta_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(24) = "ta_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(25) = "ta_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(26) = "ta_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(27) = "ta_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(28) = "ta_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(29) = "ta_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(30) = "ta_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(31) = "ta_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(32) = "ta_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(33) = "ta_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(34) = "ta_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name4(35) = "ta_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(36) = "ta_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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

;arguments required by vertical mean
    pnew       = (/1000,925,850,700,600,500,400,300,250,200/)
    pver       = pnew*100
    pver@units = "Pa"
    dp         = dpres_plevel_Wrap (pver,100000,20000,0)   ;caculate dp
    sumdp      = sum(dp)
    print ((/dp/))

    rTIO = new((/maxlag,nmod/),float)
    rTNA = new((/maxlag,nmod/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)"/)
    text2 = (/"Tropical Indian Ocean","Tropical North Atlantic"/)
    text3 = yS+"-"+yE
    text4 = (/"~F35~J~F~C/~F35~J~F~C","Lag (months)"/)
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

;get the time indexs
    time3  = in3->time
    time4  = in4->time
    year3  = cd_calendar (time3,-1) /100
    year4  = cd_calendar (time4,-1) /100
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    ts  = in3->ts(iYYYY3,:,:)
    if(i.eq.12)then
     ta = in4->ta(iYYYY4,(/0,1,2,4,5,6,7,8,9,10/),:,:)
    else
     ta = in4->ta(iYYYY4,{:20000},:,:)
;     sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    end if

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
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst    = in1->sst(iYYYY1,:,:)
     air    = in2->air(iYYYY2,{:200},:,:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1  = cos (rad*lat1)
     gw2  = cos (rad*lat2)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate the vertical mean
   if(i.eq.0)then
    dp_cfm = conform_dims ( dimsizes(ta), dp,1)
   end if
   TT = dim_sum_n (dp_cfm*ta/sumdp,1)
   if(i.eq.0)then
    copy_VarMeta (ta(:,0,:,:),TT)
   end if

;monthly anomalies
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLL (TT)
   tsA  = calcMonAnomTLL (ts, clm3)
   TTA  = calcMonAnomTLL (TT,clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   TTA  = (/dtrend_msg_n (TTA&time,TTA,False,False,0)/)

;compute seasonal means
   tsA_S = month_to_season (tsA,season(3))
   TTA_S = month_to_seasonN (TTA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I   = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
   dim = dimsizes (I)

;   rTIO(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(:,i)  = (/wgt_areaave_Wrap ( regCoef_n (I,TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN2:latS2}), 1., 0) /)
;   rTIO(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN1:latS1},{lonW1:lonE1}),0,1), gw2({latN1:latS1}), 1., 0) /)
;   rTNA(1:,i) = (/wgt_areaave_Wrap ( regCoef_n (I(:dim-2),TTA_S(1:,1:,{latN2:latS2},{lonW2:lonE2}),0,1), gw2({latN2:latS2}), 1., 0) /)

;tropical Indian Ocean
   TIO = wgt_areaave_Wrap ( TTA_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;tropical North Atlantic
   TNA = wgt_areaave_Wrap ( TTA_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO(:,i)  = (/regCoef (I,TIO)/)
   rTNA(:,i)  = (/regCoef (I,TNA)/)
   rTIO(4:,i) = (/regCoef ( I(:dim-2), TIO(4:,1:) )/)
   rTNA(4:,i) = (/regCoef ( I(:dim-2), TNA(4:,1:) )/)

   if(i.eq.0)then

    copy_VarCoords (TIO,rTIO(:,0))
    copy_VarCoords (TNA,rTNA(:,0))

    TT1    = dim_sum_n (dp_cfm*air/sumdp,1)
    copy_VarMeta (air(:,0,:,:),TT1)
    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (TT1)
    sstA   = calcMonAnomTLL (sst,clm1)
    TTA1   = calcMonAnomTLL (TT1,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    TTA1   = (/dtrend_msg_n (TTA1&time,TTA1,False,False,0)/)
    sstA_S = month_to_season (sstA,season(3))
    TTA1_S = month_to_seasonN (TTA1,season)
    I1   = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( TTA1_S(:,:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
    TNA1 = wgt_areaave_Wrap ( TTA1_S(:,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
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
   mnmx(0,0,:) = dim_min ( rTIO )
   mnmx(0,1,:) = dim_max ( rTIO )
   mnmx(0,2,:) = dim_avg ( rTIO )
   mnmx(0,3,:) = rTIO1
   mnmx(1,0,:) = dim_min ( rTNA )
   mnmx(1,1,:) = dim_max ( rTNA )
   mnmx(1,2,:) = dim_avg ( rTNA )
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
dimSizes = dimsizes(mnmx)
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
res@gsnXYFillColors      = "LightBlue"
res@gsnStringFontHeightF = 0.021

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
res@trYMinF = .0
res@trYMaxF = .8

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
reso@pmLegendWidthF         = 0.06
reso@pmLegendHeightF        = 0.12
reso@pmLegendSide           = "Top"
reso@pmLegendParallelPosF   = .14
reso@pmLegendOrthogonalPosF = -0.42

reso@lgPerimOn              = False
reso@lgLabelFontHeightF     = .014

reso@pmLegendDisplayMode = "Always"
plot0(0) = gsn_csm_xy (wks,lag,mnmx(0,2:3,:),reso)

reso@pmLegendDisplayMode = "NoCreate"
plot0(1) = gsn_csm_xy (wks,lag,mnmx(1,2:3,:),reso)

overlay (plot(0),plot0(0))
overlay (plot(1),plot0(1))

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Regression of Regional TT onto NDJ CTI"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
