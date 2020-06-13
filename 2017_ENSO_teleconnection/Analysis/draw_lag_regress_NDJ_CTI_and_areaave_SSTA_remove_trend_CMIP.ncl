;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly sea surface
;     temperature anomalies removed trend in CMIP data
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2017-10-24
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
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
    in_name3 = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"

    in_path     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name     = new(37,string)
    in_name(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(6)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(7)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(8)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name)

;time
    yS = 1958
    yE = 2004
    season = (/"ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
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

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = -55 
    lonE2 = -15

    rTIO = new((/maxlag,nmod/),float)
;    rNP  = new((/maxlag,nmod/),float)
    rTNA = new((/maxlag,nmod/),float)

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_data = "./lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP"

;text
    text1 = (/"e) ","f) ","a) ","c) "/)
;    text1 = (/"a) ","c) "/)
    text2 = (/"TIO","TNA","NP"/)
    text3 = (/"~F35~J~F~C/~F35~J~F~C","The period of SSTAs"/)
    text4 = (/"HadISST1"," ","NOAA ERSST V5"," ","COBE SST"," ","CMIP5"/)
    text5 = (/"SON(0)","NDJ(0)","JFM(+1)","MAM(+1)","MJJ(+1)"/)

if(process) then

do i=0,nmod-1

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile (in_path + in_name(i),"r")

;get the time indexs
    time  = in->time
    year  = cd_calendar (time,-1) /100
    iYYYY = ind (year.ge.yS .and. year.le.yE)

    sst = in->ts(iYYYY,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    print (min(sst))

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
     sst2   = in2->sst(iYYYY2,:,:)
     sst3   = in3->sst(iYYYY3,:,:)
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = in->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL (sst)
   SSTA = calcMonAnomTLL (sst, clm)
   SSTA = (/dtrend_msg_n (SSTA&time,SSTA,False,False,0)/)

;compute seasonal means
   SSTA_Sea = month_to_seasonN (SSTA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI = wgt_areaave_Wrap ( SSTA_Sea(3,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   dim = dimsizes (CTI)
;tropical Indian Ocean
   TIO = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
;North Pacific
;   NP  = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
;tropical North Atlantic
   SSTA_Sea = lonFlip(SSTA_Sea)
   TNA = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO(:,i) = (/regCoef (CTI,TIO)/)
;   rNP(:,i)  = (/regCoef (CTI,NP)/)
   rTNA(:,i) = (/regCoef (CTI,TNA)/)
   rTIO(4:,i) = (/regCoef ( CTI(:dim-2), TIO(4:,1:) )/)
;   rNP(1:,i)  = (/regCoef ( CTI(:dim-2), NP(1:,1:) )/)
   rTNA(4:,i) = (/regCoef ( CTI(:dim-2), TNA(4:,1:) )/)

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO(:,0))
;    copy_VarCoords (NP, rNP(:,0))
    copy_VarCoords (TNA,rTNA(:,0))

    clm1  = clmMonTLL (sst1)
    clm2  = clmMonTLL (sst2)
    clm3  = clmMonTLL (sst3)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    SSTA2 = calcMonAnomTLL (sst2, clm2)
    SSTA3 = calcMonAnomTLL (sst3, clm3)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    SSTA2 = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
    SSTA3 = (/dtrend_msg_n (SSTA3&time,SSTA3,False,False,0)/)
    SSTA_Sea1 = month_to_seasonN (SSTA1,season)
    SSTA_Sea2 = month_to_seasonN (SSTA2,season)
    SSTA_Sea3 = month_to_seasonN (SSTA3,season)
    CTI1 = wgt_areaave_Wrap ( SSTA_Sea1(3,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    CTI2 = wgt_areaave_Wrap ( SSTA_Sea2(3,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    CTI3 = wgt_areaave_Wrap ( SSTA_Sea3(3,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TIO2 = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TIO3 = wgt_areaave_Wrap ( SSTA_Sea3(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
;    NP1  = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
;    NP2  = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
    SSTA_Sea1 = lonFlip(SSTA_Sea1)
    SSTA_Sea2 = lonFlip(SSTA_Sea2)
    SSTA_Sea3 = lonFlip(SSTA_Sea3)
    TNA1 = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    TNA2 = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    TNA3 = wgt_areaave_Wrap ( SSTA_Sea3(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    rTIO1 = regCoef (CTI1,TIO1)
    rTIO2 = regCoef (CTI2,TIO2)
    rTIO3 = regCoef (CTI3,TIO3)
;    rNP1  = regCoef (CTI1,NP1)
;    rNP2  = regCoef (CTI2,NP2)
    rTNA1 = regCoef (CTI1,TNA1)
    rTNA2 = regCoef (CTI2,TNA2)
    rTNA3 = regCoef (CTI3,TNA3)
    rTIO1(4:) = regCoef ( CTI1(:dim-2), TIO1(4:,1:) )
    rTIO2(4:) = regCoef ( CTI2(:dim-2), TIO2(4:,1:) )
    rTIO3(4:) = regCoef ( CTI3(:dim-2), TIO3(4:,1:) )
;    rNP1(1:)  = regCoef ( CTI1(:dim-2), NP1(1:,1:) )
;    rNP2(1:)  = regCoef ( CTI2(:dim-2), NP2(1:,1:) )
    rTNA1(4:) = regCoef ( CTI1(:dim-2), TNA1(4:,1:) )
    rTNA2(4:) = regCoef ( CTI2(:dim-2), TNA2(4:,1:) )
    rTNA3(4:) = regCoef ( CTI3(:dim-2), TNA3(4:,1:) )
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TIO2,rTIO2)
    copy_VarCoords (TIO3,rTIO3)
;    copy_VarCoords (NP1, rNP1)
;    copy_VarCoords (NP2, rNP2)
    copy_VarCoords (TNA1,rTNA1)
    copy_VarCoords (TNA2,rTNA2)
    copy_VarCoords (TNA3,rTNA3)

   end if

   delete([/time,year/])

end do

   mnmx = new((/2,6,maxlag/),float)
   mnmx(0,2,:) = dim_avg ( rTIO )
   mnmx(0,0,:) = mnmx(0,2,:) - dim_stddev(rTIO)
   mnmx(0,1,:) = mnmx(0,2,:) + dim_stddev(rTIO)
   mnmx(0,3,:) = rTIO1
   mnmx(0,4,:) = rTIO2
   mnmx(0,5,:) = rTIO3
;   mnmx(2,0,:) = dim_min ( rNP )
;   mnmx(2,1,:) = dim_max ( rNP )
;   mnmx(2,2,:) = dim_avg ( rNP )
;   mnmx(2,3,:) = rNP1
;   mnmx(2,4,:) = rNP2
   mnmx(1,2,:) = dim_avg ( rTNA )
   mnmx(1,0,:) = mnmx(1,2,:) - dim_stddev ( rTNA )
   mnmx(1,1,:) = mnmx(1,2,:) + dim_stddev ( rTNA )
   mnmx(1,3,:) = rTNA1
   mnmx(1,4,:) = rTNA2
   mnmx(1,5,:) = rTNA3
   

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
fout->region = ispan(1,2,1)
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

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(2, graphic)
plot1 = new(2, graphic)
lag = ispan(-3, maxlag-4, 1)

;--------------------------------------------------------------
;area filled
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnXYFillColors = "LightBlue"
res@gsnStringFontHeightF = 0.021
res@gsnYRefLine = .0
res@gsnYRefLineThicknessF  = 2
res@gsnYRefLineDashPattern = 1

res@tiXAxisString = text3(1)
res@tiYAxisString = text3(0)
res@tiXAxisFontHeightF = 0.022
res@tiYAxisFontHeightF = 0.022

res@trYMinF = -.05
res@trYMaxF = .4

res@tmXBMinorOn = False
res@tmXTMinorOn = False
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.02
res@tmXBMode = "Explicit"
res@tmXBValues = ispan(-2,6,2)
res@tmXBLabels = text5
res@tmYLFormat = "0@;*.1f"
res@tmYLLabelJust = "CenterLeft"

res@vpHeightF = 0.25

res@xyLineColor = -1       ;not want the line, make it transparent

res@gsnLeftString = text1(0)+text2(0)
plot(0) = gsn_csm_xy(wks, lag, mnmx(0,0:1,:), res)

res@gsnLeftString = text1(1)+text2(1)
;res@tiXAxisString = text3(1)
;res@tiXAxisFontHeightF = 0.021
plot(1) = gsn_csm_xy(wks, lag, mnmx(1,0:1,:), res)

;--------------------------------------------------------------
;plot line
reso = True
reso@gsnDraw = False
reso@gsnFrame = False
;reso@gsnLeftString = " "
reso@xyLineColors  = (/"blue","black","orangered","green"/)
reso@xyDashPattern = 0
reso@xyLineThicknessF = 4.

plot1(0) = gsn_csm_xy(wks, lag, mnmx(0,2:,:), reso)
plot1(1) = gsn_csm_xy(wks, lag, mnmx(1,2:,:), reso)

overlay(plot(0), plot1(0))
overlay(plot(1), plot1(1))

;-------------------------------------------------------------
;Manually creating a legend
gres = True
gres@YPosPercent = 91.
gres@XPosPercent = 6.

lineres = True
lineres@lgLineColors = (/"black","white","orangered","white","green","white","blue"/)
lineres@lgLineThicknesses = 5.
lineres@LineLengthPercent = 5.

textres = True
textres@lgLabels = text4
;textres@lgLabelFontHeights = 0.025

plot(1) = simple_legend (wks,plot(1),gres,lineres,textres)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Regression of Regional SSTA onto NDJ CTI"
resP@txFontHeightF  = 0.03
resP@gsnPanelBottom = 0.06

gsn_panel(wks,plot,(/1,2/),resP)          ; create panel

end
