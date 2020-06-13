;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly sea surface temperature
;     anomalies removed trend for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       Shan He
;                       2017-09-26
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;data
    in_path1 = "~/data/observation/SST/"
    in_path2 = "~/hes/ENSO/Regrid/"
;HadISST1   1870/01 - , 1x1
;    in_name1 = "HadISST/HadISST_sst.nc"
    in_name1 = "HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "NOAA_ERSST/sst.mnmean.v4.nc"
;NOAA PISST 1981/12 - , 1x1
;    in_name3 = "NOAA_OISST/sst.mnmean.nc"
;    in_name3 = "NOAA_OISST_sst.mnmean_2x2.nc"
;    in_name4 = "NOAA_OISST/lsmask.nc"

;time
;    yS1 = 1901
    yS1 = 1958
;    yS2 = 1982
    yE  = 2004
    season = (/"MJJ","JJA","JAS","ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)
    nlag   = dimsizes (season)

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
    ypts1 = (/latNI,latNI,latSI,latSI,latNI/)
    xpts1 = (/lonWI,lonEI,lonEI,lonWI,lonWI/)
    ypts2 = (/latN1,latN1,latS1,latS1,latN1/)
    xpts2 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
    ypts3 = (/latN2,latN2,latS2,latS2,latN2/)
    xpts3 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)
;    ypts4 = (/latN3,latN3,latS3,latS3,latN3/)
;    xpts4 = (/lonW3,lonE3,lonE3,lonW3,lonW3/)

;region
    latN = 60
    latS = -60
;    lonW = 120
;    lonE = 280

;fig
    out_path = "~/hes/ENSO/Fig/Animation/"
    out_name = "lag_regress_NDJ_CTI_and_g_SSTA_remove_trend_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) ","c) "/)
    text3 = (/"HadISST","NOAA ERSST","NOAA OISST"/)
    text4 = (/" "+yS1+"-"+yE,"~F35~J~F~C/~F35~J~F~C"/)
    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path2 + in_name1,"r")
    in2 = addfile (in_path1 + in_name2,"r")
;    in3 = addfile (in_path2 + in_name3,"r")
;    in  = addfile (in_path + in_name4,"r")

    time1 = in1->time
    time2 = in2->time
;    time3 = in3->time
;    lmask = in->mask(0,{latN:latS},:)
    printVarSummary (time1)
    printVarSummary (time2)
;    printVarSummary (time3)

;get the time indexs
    year1  = cd_calendar (time1,-1) /100
    year2  = cd_calendar (time2,-1) /100
;    year3  = cd_calendar (time3,-1) /100
    iYYYY1 = ind (year1.ge.yS1 .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS1 .and. year2.le.yE)
;    iYYYY3 = ind (year3.ge.yS2 .and. year3.le.yE)

;    sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
    sst1 = in1->sst(iYYYY1,{latN:latS},:)
    sst2 = in2->sst(iYYYY2,{latN:latS},:)
;    sst3 = short2flt (in3->sst(iYYYY3,{latN:latS},:))
;    sst3 = in3->sst(iYYYY3,{latN:latS},:)

;masking of data
;    sst1 = where (sst1.lt.-1.8,-1.8,sst1)
;    sst3 = mask (sst3, conform(sst3,lmask,(/1,2/)) ,1)

    printVarSummary (sst1)
    printVarSummary (sst2)
;    printVarSummary (sst3)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.

;    gw1 = in1->latitude({latN:latS})
    gw2 = in2->lat({latN:latS})
;    gw1 = cos (rad*gw1)
    gw2 = cos (rad*gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Monthly anomalies removed trend
   clm1 = clmMonTLL (sst1)
   clm2 = clmMonTLL (sst2)
;   clm3 = clmMonTLL (sst3)
   sstAnom1 = calcMonAnomTLL (sst1,clm1)
   sstAnom2 = calcMonAnomTLL (sst2,clm2)
;   sstAnom3 = calcMonAnomTLL (sst3,clm3)
   sstAnom1 = (/dtrend_msg_n (sstAnom1&time,sstAnom1,False,False,0)/)
   sstAnom2 = (/dtrend_msg_n (sstAnom2&time,sstAnom2,False,False,0)/)
;   sstAnom3 = (/dtrend_msg_n (sstAnom3&time,sstAnom3,False,False,0)/)
   printVarSummary(sstAnom1)
   
   I1 = wgt_areaave_Wrap ( sstAnom1(:,{latNI:latSI},{lonWI:lonEI}), gw2({latNI:latSI}), 1., 0)
   I2 = wgt_areaave_Wrap ( sstAnom2(:,{latNI:latSI},{lonWI:lonEI}), gw2({latNI:latSI}), 1., 0)
;   I3 = wgt_areaave_Wrap ( sstAnom3(:,{latNI:latSI},{lonWI:lonEI}), gw2({latNI:latSI}), 1., 0)

;compute seasonal means
   I1_NDJ = month_to_season (I1,season(6))
   I2_NDJ = month_to_season (I2,season(6))
;   I3_NDJ = month_to_season (I3,season(0))
   dim1   = dimsizes (I1_NDJ)
;   dim2   = dimsizes (I3_NDJ)
   printVarSummary(I1_NDJ)

   sst1_s = month_to_seasonN (sstAnom1,season)
   sst2_s = month_to_seasonN (sstAnom2,season)
;   sst3_s = month_to_seasonN (sstAnom3,season)
   printVarSummary(sst1_s)

;compute linear regression
   ccr1 = regCoef_n (I1_NDJ,sst1_s,0,1)
   ccr2 = regCoef_n (I2_NDJ,sst2_s,0,1)
;   ccr3 = regCoef_n (I3_NDJ,sst3_s,0,1)
   ccr1(7:,:,:) = regCoef_n ( I1_NDJ(:dim1-2), sst1_s(7:,1:,:,:), 0,1)
   ccr2(7:,:,:) = regCoef_n ( I2_NDJ(:dim1-2), sst2_s(7:,1:,:,:), 0,1)
;   ccr3(1:,:,:) = regCoef_n ( I3_NDJ(:dim2-2), sst3_s(1:,1:,:,:), 0,1)
   copy_VarCoords (sst1_s(:,0,:,:),ccr1)
   copy_VarCoords (sst2_s(:,0,:,:),ccr2)
;   copy_VarCoords (sst3_s(:,0,:,:),ccr3)

;weighted centered pattern correlation
;    r1 = pattern_cor ( ccr2,ccr3,gw2,1)
    r = pattern_cor ( ccr1,ccr2,gw2,1)
;    r3 = pattern_cor ( ccr1,ccr3,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

    printVarSummary (ccr1)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.4,-.2,-.1,-.05,.05,.1,.2,.4/)

res@lbLabelBarOn = False

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;res@mpFillOn               = False
res@mpCenterLonF           = 200
;res@mpLandFillColor        = "gray80"
;res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 3.0          ; thickness of lines

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  
dum5 = new (4,graphic)  
dum6 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.03
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0,nlag-1

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))
 plot = new (2,graphic)

 res@gsnLeftString   = text2(0)+text3(0)+text4(0)
 res@gsnCenterString = sprintf("%5.3f",r(i))
 res@gsnRightString  = text4(1)
; res@tmXBLabelsOn    = False
 plot(0) = gsn_csm_contour_map_ce (wks,ccr1(i,:,:),res)

 res@gsnLeftString   = text2(1)+text3(1)
; res@gsnCenterString = text4(1)+sprintf("%5.3f",r2(i))
 res@gsnCenterString = " "
 res@gsnRightString  = " "
 plot(1) = gsn_csm_contour_map_ce (wks,ccr2(i,:,:),res)

; res@gsnLeftString   = text2(2)+text3(2)
; res@gsnCenterString = text4(2)+sprintf("%5.3f",r3(i))
; res@tmXBLabelsOn    = True
; plot(2) = gsn_csm_contour_map_ce (wks,ccr3(i,:,:),res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline (wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum2(j) = gsn_add_polyline (wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum3(j) = gsn_add_polyline (wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum4(j) = gsn_add_polyline (wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum5(j) = gsn_add_polyline (wks,plot(0),xpts3(j:j+1),ypts3(j:j+1),resb)
  dum6(j) = gsn_add_polyline (wks,plot(1),xpts3(j:j+1),ypts3(j:j+1),resb)
;  dum4(j) = gsn_add_polyline (wks,plot(0),xpts4(j:j+1),ypts4(j:j+1),resb)
 end do 

 resP@txString = "Regression at lag "+text5(i)+" of SSTA onto NDJ CTI"
 gsn_panel (wks,plot,(/2,1/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
