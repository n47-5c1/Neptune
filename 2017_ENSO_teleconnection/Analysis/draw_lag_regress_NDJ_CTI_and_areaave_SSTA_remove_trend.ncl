;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of area average of monthly sea surface
;     temperature anomalies removed trend
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the scatter plot
;                       He Shan
;                       2017-09-28
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var2--------------sst
;================================================

;data
    in_path1 = "~/data/observation/SST/"
    in_path2 = "~/hes/ENSO/Regrid/"
;HadISST1   1870/01 - , 1x1
    in_name1 = "HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "NOAA_ERSST/sst.mnmean.v4.nc"
;NOAA PISST 1981/12 - , 1x1
    in_name3 = "NOAA_OISST_sst.mnmean_2x2.nc"

;time
    yS1 = 1900
    yS2 = 1982
    yE  = 2015
    maxlag = 7
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    nS     = dimsizes (season)

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
    latN2 = 48
    latS2 = 32
    lonW2 = 176
    lonE2 = 218

;tropical Atlantic
    latN3 = 10
    latS3 = -10
    lonW3 = -20
    lonE3 = 0

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_name = "lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"Tropical Indian Ocean","North Pacific","Tropical Atlantic"/)
    text3 = "a=0.05"
    text4 = (/"(deg C/deg C)","Lag (months)"/)
    text5 = (/"HadISST"," ","NOAA ERSST"," ","NOAA OISST"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in1 = addfile (in_path2 + in_name1,"r")
    in2 = addfile (in_path1 + in_name2,"r")
    in3 = addfile (in_path2 + in_name3,"r")

    time1 = in1->time
    time2 = in2->time
    time3 = in3->time
    printVarSummary (time1)
    printVarSummary (time2)
    printVarSummary (time3)

;get the time indexs
    year1  = cd_calendar (time1,-1) /100
    year2  = cd_calendar (time2,-1) /100
    year3  = cd_calendar (time3,-1) /100
    iYYYY1 = ind (year1.ge.yS1 .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS1 .and. year2.le.yE)
    iYYYY3 = ind (year3.ge.yS2 .and. year3.le.yE)

    sst1 = in1->sst(iYYYY1,:,:)
    sst2 = in2->sst(iYYYY2,:,:)
    sst3 = in3->sst(iYYYY3,:,:)

    printVarSummary (sst1)
    printVarSummary (sst2)
    printVarSummary (sst3)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.

    gw = in1->lat
    gw = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Monthly anomalies
   clm1 = clmMonTLL (sst1)
   clm2 = clmMonTLL (sst2)
   clm3 = clmMonTLL (sst3)
   sstAnom1 = calcMonAnomTLL (sst1,clm1)
   sstAnom2 = calcMonAnomTLL (sst2,clm2)
   sstAnom3 = calcMonAnomTLL (sst3,clm3)
   sstAnom1 = (/dtrend_msg_n (sstAnom1&time,sstAnom1,False,False,0)/)
   sstAnom2 = (/dtrend_msg_n (sstAnom2&time,sstAnom2,False,False,0)/)
   sstAnom3 = (/dtrend_msg_n (sstAnom3&time,sstAnom3,False,False,0)/)
   printVarSummary(sstAnom1)
   
;compute seasonal means
   sst1_p = month_to_seasonN (sstAnom1,season)
   sst2_p = month_to_seasonN (sstAnom2,season)
   sst3_p = month_to_seasonN (sstAnom3,season)
   printVarSummary (sst1_p)

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI1 = wgt_areaave_Wrap ( sst1_p(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   CTI2 = wgt_areaave_Wrap ( sst2_p(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   CTI3 = wgt_areaave_Wrap ( sst3_p(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   dim1 = dimsizes (CTI1)
   dim2 = dimsizes (CTI3)
;tropical Indian Ocean
   TIO1 = wgt_areaave_Wrap ( sst1_p(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
   TIO2 = wgt_areaave_Wrap ( sst2_p(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
   TIO3 = wgt_areaave_Wrap ( sst3_p(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
;North Pacific
   NP1 = wgt_areaave_Wrap ( sst1_p(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
   NP2 = wgt_areaave_Wrap ( sst2_p(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
   NP3 = wgt_areaave_Wrap ( sst3_p(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
;tropical Atlantic
   sst1_p = lonFlip(sst1_p)
   sst2_p = lonFlip(sst2_p)
   sst3_p = lonFlip(sst3_p)
   TNA1 = wgt_areaave_Wrap ( sst1_p(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
   TNA2 = wgt_areaave_Wrap ( sst2_p(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
   TNA3 = wgt_areaave_Wrap ( sst3_p(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
   printVarSummary (CTI1)
   printVarSummary (TIO1)
   printVarSummary (NP1)
   printVarSummary (TNA1)

;--------------------------------------------------------------
;compute linear regression
   rTIO1 = regCoef (CTI1,TIO1)
   rTIO2 = regCoef (CTI2,TIO2)
   rTIO3 = regCoef (CTI3,TIO3)
   rNP1  = regCoef (CTI1,NP1)
   rNP2  = regCoef (CTI2,NP2)
   rNP3  = regCoef (CTI3,NP3)
   rTNA1 = regCoef (CTI1,TNA1)
   rTNA2 = regCoef (CTI2,TNA2)
   rTNA3 = regCoef (CTI3,TNA3)
   rTIO1(1:) = regCoef ( CTI1(:dim1-2), TIO1(1:,1:) )
   rTIO2(1:) = regCoef ( CTI2(:dim1-2), TIO2(1:,1:) )
   rTIO3(1:) = regCoef ( CTI3(:dim2-2), TIO3(1:,1:) )
   rNP1(1:)  = regCoef ( CTI1(:dim1-2), NP1(1:,1:) )
   rNP2(1:)  = regCoef ( CTI2(:dim1-2), NP2(1:,1:) )
   rNP3(1:)  = regCoef ( CTI3(:dim2-2), NP3(1:,1:) )
   rTNA1(1:) = regCoef ( CTI1(:dim1-2), TNA1(1:,1:) )
   rTNA2(1:) = regCoef ( CTI2(:dim1-2), TNA2(1:,1:) )
   rTNA3(1:) = regCoef ( CTI3(:dim2-2), TNA3(1:,1:) )
   copy_VarCoords_1 (TIO1,rTIO1)
   copy_VarCoords_1 (TIO2,rTIO2)
   copy_VarCoords_1 (TIO3,rTIO3)
   copy_VarCoords_1 (NP1,rNP1)
   copy_VarCoords_1 (NP2,rNP2)
   copy_VarCoords_1 (NP3,rNP3)
   copy_VarCoords_1 (TNA1,rTNA1)
   copy_VarCoords_1 (TNA2,rTNA2)
   copy_VarCoords_1 (TNA3,rTNA3)

;weighted centered pattern correlation
;    r1 = pattern_cor ( ccr2(season|:,lat|:,lon|:), ccr3(season|:,lat|:,lon|:) ,gw2,0)
;    r2 = pattern_cor ( ccr1(season|:,lat|:,lon|:), ccr2(season|:,lat|:,lon|:) ,gw2,0)
;    r3 = pattern_cor ( ccr1(season|:,lat|:,lon|:), ccr3(season|:,lat|:,lon|:) ,gw2,0)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

    printVarSummary (rTIO1)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the cross linear regression
; ==============================================================
lag = fspan (0,nS-1,nS)

data1 = new((/3,nS/), typeof(rTIO1))
data2 = new((/3,nS/), typeof(rNP1))
data3 = new((/3,nS/), typeof(rTNA1))

data1(0,:) = (/rTIO1/)
data1(1,:) = (/rTIO2/)
data1(2,:) = (/rTIO3/)
data2(0,:) = (/rNP1/)
data2(1,:) = (/rNP2/)
data2(2,:) = (/rNP3/)
data3(0,:) = (/rTNA1/)
data3(1,:) = (/rTNA2/)
data3(2,:) = (/rTNA3/)

;--------------------------------------------------------------
wks  = gsn_open_wks ("svg",out_path+out_name)
plot = new (3,graphic)

res = True

res@gsnDraw     = False
res@gsnFrame    = False
;res@gsnYRefLine = .066
;res@gsnRightString         = text3
res@gsnStringFontHeightF   = 0.022
;res@gsnYRefLineDashPattern = 1

res@tiYAxisString      = text4(0)
res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMinorOn = False
res@tmXTMinorOn = False
res@tmXBLabelFontHeightF = 0.021
res@tmYLLabelFontHeightF = 0.021

res@vpHeightF = 0.25

res@xyLineColors  = (/"black","orangered","deepskyblue"/)
res@xyDashPattern = 0

res@trYMinF = .0
res@trYMaxF = .4
res@tmXBLabelsOn    = False
res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
plot(0) = gsn_csm_xy (wks,lag,data1,res)

res@trYMinF = -.4
res@trYMaxF = .0
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
plot(1) = gsn_csm_xy (wks,lag,data2,res)

res@trYMinF = .0
res@trYMaxF = .4
res@tmXBLabelsOn    = True
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
res@tiXAxisString   = text4(1)
plot(2) = gsn_csm_xy (wks,lag,data3,res)

;-------------------------------------------------------------
;Manually creating a legend
gres = True
gres@YPosPercent = 92.
gres@XPosPercent = 68.

lineres = True
lineres@lgLineColors = (/"black","white","orangered","white","deepskyblue"/)
lineres@lgLineThicknesses = 2.5
lineres@LineLengthPercent = 5.

textres = True
textres@lgLabels = text5
;textres@lgLabelFontHeights = 0.025

plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Regression between NDJ CTI and Seasonal SSTA"
resP@txFontHeightF  = 0.025      ;height of text
resP@gsnPanelBottom = 0.04

gsn_panel(wks,plot,(/3,1/),resP)          ; create panel

end
