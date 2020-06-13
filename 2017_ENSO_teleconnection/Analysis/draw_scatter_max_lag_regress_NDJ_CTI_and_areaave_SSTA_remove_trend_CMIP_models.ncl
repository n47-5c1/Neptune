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
;                       2018-05-04
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
    in_name1 = "./scatter_asymmetry_SSTA_mechanism.nc"
    in_name2 = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"

;time
    yS = 1958
    yE = 2004

;Fig
    out_path = "~/hes/ENSO/Fig/"
    out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP_models"

;text
    text1 = (/yS+"-"+yE,"~F35~J~F~C/~F35~J~F~C"/)
    text2 = (/"TNA","TIO"/)
    text3 = (/"HadISST1","NOAA ERSST","MMM"/)
    text4 = (/"0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    sizes   = (/.022,.025,.02,.02/)
    colors  = (/"green","dodgerblue2","red","orange","black","cyan","yellow3","purple"/)
    indexes = (/5,2,16/)
    thicknesses = (/5.5,5.5,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in1  = addfile (in_name1,"r")
    in2  = addfile (in_name2,"r")
    clcnter = in1->clcnter
    mnmx    = in2->mnmx
    ndim = dimsizes (mnmx)

; print ((/mnmx(:,(/0,2/))/))
; print ( ind( abs( mnmx(0,3:)-mnmx(0,0) ).lt.2.*std(0) .and. abs( mnmx(1,3:)-mnmx(1,0) ).lt.2.*std(1) ) )
; print ( (/mnmx(1, ind(mnmx(1,:).lt..1) )/) )

; ==============================================================
; Mission 2. Draw the scatter
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

res@trYMaxF = .52
res@trYMinF = .04
res@trXMaxF = .5
res@trXMinF = .02

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarkers      = indexes
res@xyMarkerSizes  = sizes
;res@xyMarkerColor  = color
res@xyMarkerThicknesses = thicknesses
plot = gsn_csm_xy (wks, transpose((/mnmx(0,:2),mnmx(0,:2)/)), transpose((/mnmx(1,:2),mnmx(1,:2)/)), res)
;res@xyMarker       = indexes(3)
;res@xyMarkerSizeF  = sizes(3)
;res@xyMarkerColor  = "black"
;plot = gsn_csm_xy (wks,mnmx(0,3:),mnmx(1,3:),res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
dum = gsn_add_polyline (wks,plot,(/0,.55/),(/0,.55/),resl)
;dum0 = gsn_add_polyline (wks,plot,(/0,.5/),(/0,.24/),resl)

draw(plot)

;--------------------------------------------------------------
reso = True
reso@txFontHeightF = sizes(3)
do i=3,ndim(1)-1
 reso@txFontColor = colors(clcnter@id(i-2)-1)
 gsn_text (wks,plot,text4(i-3),mnmx(0,i),mnmx(1,i),reso)
end do

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,2
 gsres@gsMarkerSizeF = sizes(i)
; gsres@gsMarkerColor = color
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
