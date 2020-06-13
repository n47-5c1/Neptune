;*************************************************************
;Aim: Draw cross regression of three-month means of tropical monthly pressure/height zonal wind anomalies removed trend
;     onto November-December-January cold tongue index in CMIP model for animations

;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-02-07
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
;   var4--------------ua
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(43,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(3)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(10) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(12) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(14) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(15) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(17) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(19) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(20) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
;    in_name3(22) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
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

;time
    yS = 1958
    yE = 2004
    season = (/"MJJ","JJA","JAS","ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)

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
    lonW1 = 50
    lonE1 = 100

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical North Atlantic
;    latN2 = 25
;    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

;region
    latN = 10
    latS = -10
    levU = 100
    levL = 1000

; create points for box
    ypts1 = (/levU,levU,levL,levL,levU/)
    xpts1 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
    ypts2 = (/levU,levU,levL,levL,levU/)
    xpts2 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)

;fig
    out_path = "~/hes/ENSO/Fig/Animation/"
    out_data = "./lag_regress_NDJ_CTI_and_lat_p_h_ua_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_lat_p_h_ua_anom_remove_trend_CMIP_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) ","c) "/)
    text3 = (/"OBS","MMM"/)
    text4 = (/" "+yS+"-"+yE,"m~F34~W~F~s~S~-1~N~/~F35~J~F~C"/)
    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

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

    ts = in3->ts(iYYYY3,:,:)
    if(i.eq.10 .or. i.eq.12 .or. i.eq.35 .or. i.eq.36)then
     ua = in4->ua(iYYYY4,(/0,1,2,3,4,5,6,7,8,9,11,14/),{latN:latS},:)
    else if(i.eq.18)then
     ua = in4->ua(iYYYY4,(/0,1,2,4,5,6,7,8,9,10,11,12/),{latN:latS},:)
    else
     ua = in4->ua(iYYYY4,{:10000},{latN:latS},:)
    end if
    end if
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
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst    = in1->sst(iYYYY1,:,:)
     uwnd   = in2->uwnd(iYYYY2,{:100},{latN:latS},:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
     lat3 = in3->lat
     lat4 = in4->lat
     lon  = in4->lon
     plev = in4->plev({:10000})

;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw3 = cos (rad*lat3)
     gw4 = cos (rad*lat4)
     copy_VarCoords (lat3,gw3)
     copy_VarCoords (lat4,gw4)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLLL (ua)
   tsA  = calcMonAnomTLL (ts,clm3)
   uaA  = calcMonAnomTLLL (ua,clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   uaA  = (/dtrend_msg_n (uaA&time,uaA,False,False,0)/)

;compute seasonal means
   tsA_S = month_to_season (tsA,season(6))
   uaA_S = month_to_seasonN (uaA,season)
   dim   = dimsizes (uaA_S)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2_NDJ = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw3({latNI:latSI}), 1., 0)
;tropical
   uaA_T  = dim_avg_wgt_n_Wrap ( uaA_S, gw4({latN:latS}), 1, 3)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr2 = new((/dim(0),dim(2),dim(4),nmod/),float)
    copy_VarMeta (uaA_T(:,0,:,:),ccr2(:,:,:,0))
   end if

;compute linear regression
   ccr2(:,:,:,i)  = (/regCoef_n (I2_NDJ,uaA_T,0,1)/)
   ccr2(7:,:,:,i) = (/regCoef_n (I2_NDJ(:dim(1)-2),uaA_T(7:,1:,:,:),0,1)/)

   if(i.eq.0)then
    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLLL (uwnd)
    sstA   = calcMonAnomTLL (sst,clm1)
    uwndA  = calcMonAnomTLLL (uwnd,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    uwndA  = (/dtrend_msg_n (uwndA&time,uwndA,False,False,0)/)
    sstA_S  = month_to_season (sstA,season(6))
    uwndA_S = month_to_seasonN (uwndA,season)
    I1_NDJ  = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw3({latNI:latSI}), 1., 0)
    uwndA_T = dim_avg_wgt_n_Wrap ( uwndA_S, gw4({latN:latS}), 1, 3)
    ccr1         = regCoef_n (I1_NDJ,uwndA_T,0,1)
    ccr1(7:,:,:) = regCoef_n (I1_NDJ(:dim(1)-2),uwndA_T(7:,1:,:,:), 0,1)
    copy_VarMeta (uwndA_T(:,0,:,:),ccr1)
    ccr1!1 = "plev"
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

   mnmn = dim_avg ( ccr2 )
   copy_VarMeta (ccr2(:,:,:,0),mnmn)
   printVarSummary (mnmn)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","plev","lon"/)
dimSizes = (/dim(0),dim(2),dim(4)/) 
dimUnlim = (/True,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer", "season")
filevardef (fout,"plev",  typeof(plev),getvardims(plev))
filevardef (fout,"lon",   typeof(lon),getvardims(lon))
filevardef (fout,"ccr1",  typeof(ccr1),getvardims(ccr1))
filevardef (fout,"mnmn",  typeof(mnmn),getvardims(mnmn))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"plev",plev)
filevarattdef (fout,"lon",lon)
filevarattdef (fout,"ccr1",ccr1)
filevarattdef (fout,"mnmn",mnmn)

;output only the data values
fout->season = ispan(1,dim(0),1)
fout->plev   = (/plev/)
fout->lon    = (/lon/)
fout->ccr1   = (/ccr1/)
fout->mnmn   = (/mnmn/)

else

 in   = addfile (out_data,"r")
 ccr1 = in->ccr1
 mnmn = in->mnmn
 dim  = dimsizes (ccr1)
 printVarSummary (ccr1)
 printVarSummary (mnmn)

end if

; ==============================================================
; Mission 4. Draw the differences
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .018

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-2.,-1.,-.5,-.25,.25,.5,1.,2./)

res@lbLabelBarOn = False

res@vpHeightF = 0.25

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 3.0          ; thickness of lines

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.028
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.02
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0,dim(0)-1

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))
 plot = new (2,graphic)

 res@gsnLeftString   = text2(0)+text3(0)
 res@gsnCenterString = text4(0)
 res@gsnRightString  = text4(1)
; res@tmXBLabelsOn    = False
 plot(0) = gsn_csm_pres_hgt (wks,ccr1(i,:,:),res)

 res@gsnLeftString   = text2(1)+text3(1)
; res@gsnCenterString = text4(1)+sprintf("%5.3f",r2(i))
 res@gsnCenterString = " "
 res@gsnRightString  = " "
 plot(1) = gsn_csm_pres_hgt (wks,mnmn(i,:,:),res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline (wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum2(j) = gsn_add_polyline (wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum3(j) = gsn_add_polyline (wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum4(j) = gsn_add_polyline (wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
 end do 

 resP@txString = "Regression at "+text5(i)+" of UWND onto NDJ CTI"
 gsn_panel (wks,plot,(/2,1/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
