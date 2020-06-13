;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of cross regression between November-December-January cold tongue index and three-month means of the sea surface temperature
;     anomalies removed trend at the Pacific equator in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-05-15
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

;data

    iM = (/9,26,27,28,29/)
;    iM =(/0,1,4,9,16,19,26,28,29,36/)
;    iM =(/5,6,7,11,14,26,27,28,31,32/)

;time
    yS = 1958
    yE = 2004

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
    lonW1 = 50
    lonE1 = 100

;tropical North Atlantic
    lonW2 = 305 
    lonE2 = 345

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 290

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_data = "./hovmoller_lon_lag_regress_NDJ_CTI_and_Pac_SSTA_remove_trend_CMIP.nc"
    out_name = "hovmoller_lon_lag_regress_NDJ_CTI_and_Pac_SSTA_remove_trend_model"

;text
    text1 = (/"a) HadISST","b) MMM","c) Cluster","d) CSIRO-Mk3-6-0","e) MIROC4h","f) MIROC5","g) MIROC-ESM","h) MIROC-ESM-CHEM"/)
    text2 = (/"5~F35~J~F~S - 5~F35~J~F~N","~F35~J~F~C/~F35~J~F~C"/)
;    text3 = (/"-6","-3","0","3","6","9"/)
    text3 = (/"MJJ(0)","ASO(0)","NDJ(0)","FMA(+1)","MJJ(+1)","ASO(+1)"/)
    text4 = "The period of SSTAs"

 in  = addfile (out_data,"r")
 ccr = in->ccr
 dim = dimsizes (ccr)
 printVarSummary (ccr)

 ccr(:,:,1) = (/ccr(:,:,3)/)
 ccr(:,:,2) = (/dim_avg_n (ccr(:,:,iM+4),2)/)
 ccr(:,:,3:7) = (/ccr(:,:,iM+4)/)

 ccr(season|:,model|:,lon|:) = lonPivot (ccr(season|:,model|:,lon|:),25)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks  = gsn_open_wks ("svg",out_path + out_name)
plot = new (8,graphic)
dum1 = new (8,graphic)
dum2 = new (8,graphic)
;dum3 = new (8,graphic)
;dum4 = new (8,graphic)
;dum5 = new (8,graphic)
;dum6 = new (8,graphic)

res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .021

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;res@cnFillPalette  = "CBR_coldhot"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.8,-.4,-.2,-.1,.1,.2,.4,.8/)

res@lbLabelBarOn = False

res@tmYLMode             = "Explicit"
res@tmYLValues           = ispan(0,dim(0)-1,3)
res@tmYLLabels           = text3
res@tmYLLabelJust        = "CenterCenter"
res@tmYLMinorOn          = False
res@tmYRMinorOn          = False
;res@tmXBTickSpacingF     = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisString = text4
res@tiYAxisFontHeightF = 0.021

;res@vpWidthF  = 1.
res@vpHeightF = 0.35

res@gsnLeftString   = text1(0)
res@gsnRightString  = text2(0)
plot(0) = gsn_csm_hov (wks,ccr(:,{lonW:lonE},0),res)

res@gsnLeftString   = text1(1)
res@gsnRightString  = text2(1)
plot(1) = gsn_csm_hov (wks,ccr(:,{lonW:lonE},1),res)

res@gsnRightString = " "
do i = 2, 7
 res@gsnLeftString = text1(i)
 plot(i) = gsn_csm_hov (wks,ccr(:,{lonW:lonE},i),res)
end do

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
;resl@gsLineDashPattern = 1
do i = 0, 7
    dum1(i) = gsn_add_polyline(wks,plot(i),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
    dum2(i) = gsn_add_polyline(wks,plot(i),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
;    dum3(i) = gsn_add_polyline(wks,plot(i),(/lonW1,lonW1/),(/0,dim(0)-1/),resl)
;    dum4(i) = gsn_add_polyline(wks,plot(i),(/lonE1,lonE1/),(/0,dim(0)-1/),resl)
;    dum5(i) = gsn_add_polyline(wks,plot(i),(/lonW2,lonW2/),(/0,dim(0)-1/),resl)
;    dum6(i) = gsn_add_polyline(wks,plot(i),(/lonE2,lonE2/),(/0,dim(0)-1/),resl)
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.023
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.011
resP@pmLabelBarOrthogonalPosF = -0.008
resP@txString = "Regression of SSTA onto NDJ CTI"

gsn_panel (wks,plot,(/4,2/),resP)


end
