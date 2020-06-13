;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly zonal wind temperature anomalies
;     removed trend in CMIP data
;
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-03
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;   var3--------------ts
;   var3--------------ua
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"

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

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./lag_regress_NDJ_CTI_and_areaave_U_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_areaave_U_anom_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"Tropical Indian Ocean","Tropical North Atlantic"/)
    text3 = yS+"-"+yE
    text4 = (/"m/s/~F35~J~F~C","Lag (months)"/)
    text5 = (/"OBS"," ","CMIP5"/)

if(process) then

do i=0,nmod-1

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in3 = addfile (in_path1 + in_name3(i),"r")
    in4 = addfile (in_path2 + in_name4(i),"r")

;get the time indexes
    time3  = in3->time
    time4  = in4->time
    year3  = cd_calendar (time3,-1) /100
    year4  = cd_calendar (time4,-1) /100
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    sst2 = in3->ts(iYYYY3,:,:)
    ua  = in4->ua(iYYYY4,lev,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    print (min(sst2))

    if(i.eq.0)then 
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time1  = in1->time
     time2  = in2->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst1    = in1->sst(iYYYY1,:,:)
     uwnd   = in2->uwnd(iYYYY2,lev,:,:)
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw1 = in3->lat
    gw2 = in4->lat
    gw1 = cos (rad*gw1)
    gw2 = cos (rad*gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
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

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO(:,0))
    copy_VarCoords (TNA,rTNA(:,0))

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

   end if

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

   printVarSummary (mnmx)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
/;
cc!0  = "region"
rat!0 = "region"
cc!1  = "model"
rat!1 = "model"
ndim  = dimsizes (cc)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","model"/)
dimSizes = (/ndim(0),ndim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"model", "integer","model")
filevardef (fout,"cc", typeof(cc), getvardims(cc))
filevardef (fout,"rat",typeof(rat),getvardims(rat))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)

;output only the data values
fout->region = ispan(1,3,1)
fout->model  = ispan(0,nmod,1)
fout->cc     = (/cc/)
fout->rat    = (/rat/)

else

 in   = addfile (out_data,"r")
 cc   = in->cc
 rat  = in->rat
 ndim = dimsizes (cc)
 printVarSummary (cc)
 printVarSummary (rat)
;/
end if

; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

wks   = gsn_open_wks ("svg",out_path+out_name)
plot  = new (2,graphic)        
plot0 = new (2,graphic)        
lag   = fspan (0,maxlag-1,maxlag)

res = True

res@gsnDraw     = False
res@gsnFrame    = False
res@gsnYRefLine = .0
res@gsnStringFontHeightF   = 0.021
res@gsnYRefLineThicknessF  = 2
res@gsnYRefLineDashPattern = 1

res@tiYAxisString      = text4(0)
res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMinorOn = False
res@tmXTMinorOn = False
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@vpHeightF = 0.25

res@xyLineColors  = (/"blue","orangered"/)
res@xyDashPattern = 0
res@xyLineThicknessF = 4.

;--------------------------------------------------------------
res@trYMinF = -2.5
res@trYMaxF = .5
;res@tmXBLabelsOn    = False
plot0(0) = gsn_csm_xy (wks,lag,mnmx(0,2:3,:),res)

res@trYMinF = -1.
res@trYMaxF = 2.
plot0(1) = gsn_csm_xy (wks,lag,mnmx(1,2:3,:),res)

;--------------------------------------------------------------
;area filled
delete (res@xyLineColors)
res@trYMinF = -2.5
res@trYMaxF = .5
res@xyLineColor     = -1       ;not want the line, make it transparent
;res@tmXBLabelsOn    = False
res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = text3
res@gsnXYFillColors = "LightBlue"
plot(0) = gsn_csm_xy (wks,lag,mnmx(0,0:1,:),res)

res@trYMinF = -1.
res@trYMaxF = 2.
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
res@tiXAxisString   = text4(1)
plot(1) = gsn_csm_xy (wks,lag,mnmx(1,0:1,:),res)

overlay (plot(0),plot0(0))
overlay (plot(1),plot0(1))

;-------------------------------------------------------------
;Manually creating a legend
gres = True
gres@YPosPercent = 22.
gres@XPosPercent = 78.

lineres = True
lineres@lgLineColors = (/"orangered","white","blue"/)
lineres@lgLineThicknesses = 5.
lineres@LineLengthPercent = 5.

textres = True
textres@lgLabels = text5
;textres@lgLabelFontHeights = 0.025

plot(0) = simple_legend (wks,plot(0),gres,lineres,textres)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Regression of Regional U onto NDJ CTI"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
