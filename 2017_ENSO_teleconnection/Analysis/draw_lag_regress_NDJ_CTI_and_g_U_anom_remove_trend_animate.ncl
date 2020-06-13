;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly zonal wind anomalies
;     at 850 and 200 hPa removed trend for animations
;Mission:
;
;   1. Read data from sst & uwind dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       Shan He
;                       2018-01-02
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
;================================================

;HadISST1   1870/01 - , 1x1
    in_path1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR
    in_path2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
;    in_path2 = "~/data/observation/NCEP_NCAR/monthly/wspd.mon.mean.nc"
;    in_path2 = "~/data/observation/NCEP_NCAR/monthly/lhtfl.sfc.mon.mean.nc"
;    in_path3 = "~/data/observation/NCEP_NCAR/monthly/shtfl.sfc.mon.mean.nc"
;    in_path2 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
;    in_path3 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"

;time
    yS = 1958
    yE = 2004
    maxlag = 9
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)

    lev = (/2,9/)    ;850, 200

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

; create points for box
    ypts1 = (/latNI,latNI,latSI,latSI,latNI/)
    xpts1 = (/lonWI,lonEI,lonEI,lonWI,lonWI/)
    ypts2 = (/latN1,latN1,latS1,latS1,latN1/)
    xpts2 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
    ypts3 = (/latN2,latN2,latS2,latS2,latN2/)
    xpts3 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)

;region
    latN = 60
    latS = -60
;    lonW = 120
;    lonE = 280

;fig
    out_path = "~/hes/ENSO/Fig/Animation/"
    out_name = "lag_regress_NDJ_CTI_and_g_U_anom_remove_trend_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) "/)
    text3 = (/"U850","U200"/)
    text4 = (/" "+yS+"-"+yE,"m/(s*~F35~J~F~C)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path1,"r")
    in2 = addfile (in_path2,"r")
;    in3 = addfile (in_path3,"r")

    time1 = in1->time
    time2 = in2->time
    printVarSummary (time1)
    printVarSummary (time2)

;get the time indexs
    year1  = cd_calendar (time1,-1) /100
    year2  = cd_calendar (time2,-1) /100
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)

;    sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
    sst  = in1->sst(iYYYY1,{latN:latS},:)
    uwnd = in2->uwnd(iYYYY2,lev,{latN:latS},:)
;    uwnd = in2->wspd(iYYYY2,lev,{latN:latS},:)
;    uwnd = in2->lhtfl(iYYYY2,{latN:latS},:)
;    vwnd = in3->shtfl(iYYYY2,{latN:latS},:)
;    uwnd = uwnd+vwnd
;    sst3 = short2flt (in3->sst(iYYYY3,{latN:latS},:))

    printVarSummary (sst)
    printVarSummary (uwnd)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.

    gw = in1->lat({latN:latS})
    gw = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Monthly anomalies
   clm1 = clmMonTLL (sst)
   clm2 = clmMonTLLL (uwnd)
;   clm2 = clmMonTLL (uwnd)
   sstAnom  = calcMonAnomTLL (sst,clm1)
   uwndAnom = calcMonAnomTLLL (uwnd,clm2)
;   uwndAnom = calcMonAnomTLL (uwnd,clm2)
   sstAnom  = (/dtrend_msg_n (sstAnom&time,sstAnom,False,False,0)/)
   uwndAnom = (/dtrend_msg_n (uwndAnom&time,uwndAnom,False,False,0)/)
   printVarSummary(sstAnom)
   
   I = wgt_areaave_Wrap ( sstAnom(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;compute seasonal means
   I_NDJ = month_to_season (I,season(0))
   dim   = dimsizes (I_NDJ)
;   iMM   = ind (abs(I_NDJ).lt..5)
;   I_NDJ(iMM) = I_NDJ@_missing_value
;   printVarSummary (I_NDJ)

   uwnd_s = month_to_seasonN (uwndAnom,season)
   printVarSummary(uwnd_s)

;compute linear regression
   ccr = regCoef_n (I_NDJ,uwnd_s,0,1)
   ccr(1:,:,:,:) = regCoef_n ( I_NDJ(:dim-2), uwnd_s(1:,1:,:,:,:), 0,1)
   copy_VarCoords (uwnd_s(:,0,:,:,:),ccr)
;   ccr = escorc_n (I_NDJ,uwnd_s,0,1)
;   ccr(1:,:,:) = escorc_n ( I_NDJ(:dim-2), uwnd_s(1:,1:,:,:), 0,1)
;   copy_VarCoords (uwnd_s(:,0,:,:),ccr)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

    printVarSummary (ccr)
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
res@cnLevels             = (/-2.4,-1.2,-.6,-.3,.3,.6,1.2,2.4/)
;res@cnLevels             = (/-.6,-.3,-.15,.15,.3,.6/)

;res@lbLabelBarOn = False
res@lbLabelFontHeightF       = 0.02
res@pmLabelBarOrthogonalPosF = 0.2

res@tiMainFontHeightF = 0.026

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

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.022
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.016
resP@pmLabelBarOrthogonalPosF = -0.01

;----------------------------------------------------------
do i = 0,maxlag

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))

 res@gsnLeftString   = text3(0)
 res@gsnCenterString = text4(0)
 res@gsnRightString  = text4(1)
; res@tmXBLabelsOn    = False
 res@tiMainString = "Lagged Corr. at "+text1(i)+" of NDJ CTI against U"
 plot = gsn_csm_contour_map_ce (wks,ccr(i,0,:,:),res)
; plot = gsn_csm_contour_map_ce (wks,ccr(i,:,:),res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline (wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum2(j) = gsn_add_polyline (wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum3(j) = gsn_add_polyline (wks,plot(0),xpts3(j:j+1),ypts3(j:j+1),resb)
 end do 

draw  (plot)
frame (wks)

; resP@txString = "Lagged Corr. at "+text1(i)+" of NDJ CTI against DV"
; gsn_panel (wks,plot,(/3,1/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
