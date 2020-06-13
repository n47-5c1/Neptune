;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly SSTAs removed trend in the tropical
;     Indian Ocean as well as in the tropical North Atlantic onto the NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the scatter plot
;                       Shan He
;                       2018-04-10
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

;data
;    in_name = "~/data-observation/MLD/mld_DT02_c1m_reg2.0.nc"
;    in_name = "~/data-observation/MLD/mld_DR003_c1m_reg2.0.nc"
    in_name = "~/data-observation/MLD/mld_DReqDTm02_c1m_reg2.0.nc"

;time
    yS = 1941
    yE = 2008

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

;Fig
    out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP"

;text
    text1 = (/yS+"-"+yE,"~F35~J~F~C/~F35~J~F~C"/)
    text2 = (/"TNA","TIO"/)
    text3 = (/"HadISST1","NOAA ERSST","MMM","Model Samples"/)

    x       = (/.24,.24,.24,.24/)
    y       = (/.76,.72,.68,.64/)
    colors  = (/"red3","forestgreen","dodgerblue2","black"/)
    sizes   = (/.025,.025,.025,.04/)
    indexes = (/5,5,5,1/)
    thicknesses = (/5.5,5.5,5.5,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in  = addfile ( in_name,"r")
    mld = in->mld
    sea = in->mask
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    mld = mask (mld,sea,1)

    printVarSummary (mld)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = in->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;tropical Indian Ocean
   TIO = dim_avg_Wrap ( wgt_areaave_Wrap ( mld((/11,0,1,2,3,4/),{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) )
;tropical North Atlantic
   TNA = dim_avg_Wrap ( wgt_areaave_Wrap ( mld((/11,0,1,2,3,4/),{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0) )

   print("TIO: "+TIO)
   print("TNA: "+TNA)
exit

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================
wks  = gsn_open_wks ("svg",out_path+out_name)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnCenterString       = text1(0)
res@gsnRightString        = text1(1)
res@gsnStringFontHeightF  = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Max Regression of Regional SSTA onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = .55
res@trYMinF = .0
res@trXMaxF = .55
res@trXMinF = .0

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(3)
res@xyMarkerSizeF  = sizes(3)
;res@xyMarkerColor  = "black"
plot = gsn_csm_xy (wks,mnmx(0,3:),mnmx(1,3:),res)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
dum  = gsn_add_polyline (wks,plot,(/0,.55/),(/0,.55/),resl)
resl@gsLineColor       = colors(2)
resl@gsLineThicknessF  = 3
resl@gsLineDashPattern = 0
a = (res@trYMaxF-res@trYMinF)/50.
dum1 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2),mnmx(1,2)/),resl)
dum2 = gsn_add_polyline (wks,plot,(/mnmx(0,2),mnmx(0,2)/),(/mnmx(1,2)-std(1),mnmx(1,2)+std(1)/),resl)
dum3 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)-std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
dum4 = gsn_add_polyline (wks,plot,(/mnmx(0,2)+std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
dum5 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)-std(1),mnmx(1,2)-std(1)/),resl)
dum6 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)+std(1),mnmx(1,2)+std(1)/),resl)

;--------------------------------------------------------------
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkers      = indexes
reso@xyMarkerSizes  = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknesses = thicknesses
plot1 = gsn_csm_xy (wks, transpose((/mnmx(0,0:2),mnmx(0,0:2)/)), transpose((/mnmx(1,0:2),mnmx(1,0:2)/)), reso)

overlay (plot,plot1)

draw (plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,3
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
