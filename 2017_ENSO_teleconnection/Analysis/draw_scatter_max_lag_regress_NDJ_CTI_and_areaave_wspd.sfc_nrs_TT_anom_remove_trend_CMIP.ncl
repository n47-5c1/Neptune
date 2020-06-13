;*************************************************************
;Aim: Draw a scatter plot of maximum cross regression coefficients of three-month means of area average of regional monthly sea surface temperature and surface wind speed,
;     surface radiative flux, as well as mean 1000-200-hPa tropospheric temperature anomalies removed trend in the tropical Indian Ocean as well as in the tropical North
;     Atlantic onto the NDJ cold tongue index in CMIP models (visualized by being divided by intermodel standard deviation)
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-04-27
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------mnmx
;   var2--------------std
;================================================

;data
in_path = "~/hes/ENSO/Asymmetry/NCL/"
in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"

mnmn = new((/2,3,37+4/), float)
std = new((/2,3/), float)

;fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_nrs_TT_anom_remove_trend_CMIP"

;text
text1 = "c)"
text2 = "max/min[~F14~R~BF~CTI~F18~o~F14~X~F~(~F8~t~F~)~N~]"
text3 = (/"TNA","TIO"/)
text4 = (/"HadISST","ERSST","COBE","CMIP5"/)
text5 = (/"~F10~U~B~Surf","~F10~F~B~Rad","~F10~T~B~Trop"/)

x = (/.24,.24,.24/)
y = (/.76,.72,.68/)
colors = (/"red","blue","green"/)
sizes = (/0.022,0.022,0.022,0.018/)
indexes = (/4,8,7,0/)
thicknesses = (/3,3,3,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
in1 = addfile(in_path + in_name1, "r")
in2 = addfile(in_path + in_name2, "r")
in3 = addfile(in_path + in_name3, "r")

;z = ispan(0, 37+3, 1)
;iM = ind(z.ne.1 .and. z.ne.2)

mnmn(:,0,:) = in1->mnmx
mnmn(:,1,:) = in2->mnmx
mnmn(:,2,:) = in3->mnmx
std(:,0) = in1->std
std(:,1) = in2->std
std(:,2) = in3->std

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
ndim = dimsizes(mnmn)

mnmn = mnmn / conform_dims(ndim, sqrt((std(0,:)^2.0 + std(1,:)^2.0) / 2.0), 1)
std = std / conform_dims(ndim(:1), sqrt((std(0,:)^2.0 + std(1,:)^2.0) / 2.0), 1)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot2 = new(3, graphic)
dum1 = new(3, graphic)
dum2 = new(3, graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = text1
res@gsnCenterString = text2
res@gsnStringFontHeightF = 0.024

res@tiYAxisString = text3(0)
res@tiXAxisString = text3(1)
res@tiXAxisFontHeightF = 0.023
res@tiMainString = "Max Regression of Parameters onto NDJ CTI"
res@tiMainFontHeightF = 0.028

res@trYMaxF = 6.0
res@trYMinF = -4.0
res@trXMaxF = 6.0
res@trXMinF = -4.0

res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

res@xyMarkLineMode = "Markers"
res@xyMarker = indexes
res@xyMarkerSizeF = sizes
res@xyMarkerColors = colors
res@xyMarkerThicknessF = thicknesses
plot = gsn_csm_xy(wks, transpose((/mnmn(0,:,0),mnmn(0,:,0)/)), transpose((/mnmn(1,:,0),mnmn(1,:,0)/)), res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2.0
resl@gsLineDashPattern = 1
duma = gsn_add_polyline(wks, plot, (/-8.,8./), (/-8.,8./), resl)
dumb = gsn_add_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/.0,.0/), resl)
dumc = gsn_add_polyline(wks, plot, (/.0,.0/), (/res@trYMinF,res@trYMaxF/), resl)

resl@gsLineDashPattern = 0
do i = 0, 2
    resl@gsLineColor = colors(i)
    dum1(i) = gsn_add_polyline(wks, plot, (/mnmn(0,i,3)-std(0,i),mnmn(0,i,3)+std(0,i)/), (/mnmn(1,i,3),mnmn(1,i,3)/), resl)
    dum2(i) = gsn_add_polyline(wks, plot, (/mnmn(0,i,3),mnmn(0,i,3)/), (/mnmn(1,i,3)-std(1,i),mnmn(1,i,3)+std(1,i)/), resl)
end do

;--------------------------------------------------------------
;color for mechanism, shape for model
indexes(3) = NhlNewMarker(wks, "y", 35, 0.0, 0.0, 1.0, 1.0, 0.0)
reso = True
reso@gsnDraw = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkerColors = colors

do i = 1, 3
    reso@xyMarker = indexes(i)
    reso@xyMarkerSizeF = sizes(i)
    reso@xyMarkerThicknessF = thicknesses(i)
    plot2(i-1) = gsn_csm_xy(wks, transpose((/mnmn(0,:,i),mnmn(0,:,i)/)), transpose((/mnmn(1,:,i),mnmn(1,:,i)/)), reso)
    overlay(plot, plot2(i-1))
end do

draw(plot)
/;
;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0, 1
    gsres@gsMarkerSizeF = sizes(i,0)
    gsres@gsMarkerIndex = indexes(i)
    gsn_polymarker_ndc(wks, x(i), y(i), gsres)
end do

txres = True
txres@txJust = "CenterLeft"
txres@txFontHeightF = 0.018

gsn_text_ndc(wks, text3, x(:1)+0.025, y(:1), txres)

do i = 0, 2
    txres@txFontColor = colors(i)
    gsn_text_ndc(wks, text4(i), x(i), y(i)-0.08, txres)
end do
;/
frame(wks)

end
