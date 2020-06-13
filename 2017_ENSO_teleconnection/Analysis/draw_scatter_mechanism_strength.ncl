;*************************************************************
;Aim: Draw a scatter plot of the strengths of each mechanisms
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-04-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------mnmx
;   var2--------------std
;   var3--------------r
;================================================

;data
    in_path  = "~/hes/ENSO/Asymmetry/NCL/"
    in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    in_name4 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

    mnmn = new((/2,3,37+4/),float)
    r    = new((/2,4,37+4/),float)

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_name = "scatter_mechanism_strength"

;text
    text1 = "b)"
    text2 = "(c) ~F34~4~F~ (d)"
    text3 = "~F35~J~F~C/~F35~J~F~C"
    text4 = (/"TNA","TIO"/)
    text5 = (/"OBS","MMM"/)
    text6 = (/"ABM","~F10~U~B~Surf","~F10~F~B~Rad","TTM"/)

    x1 = (/.67,.67/)
    y1 = (/.36,.32/)
    x2 = (/.64,.64,.72,.72/)
    y2 = (/.28,.24,.24,.28/)
    colors = (/"black","red","blue","green"/)
    sizesP = (/0.03,0.018,0.018,0.03/)
    sizes = (/(/sizesP/),(/sizesP/),(/sizesP/),(/sizesP - 0.007/)/)
    indexes = (/4,8,7,0/)
    thicknesses = (/3,3,3,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")
    in4 = addfile (in_path + in_name4,"r")

;    z  = ispan (0,37+3,1)
;    iM = ind (z.ne.1 .and. z.ne.2)

    mnmn(:,0,:) = in1->mnmx
    mnmn(:,1,:) = in2->mnmx
    mnmn(:,2,:) = in3->mnmx
    r(:,1:,:) = in4->r

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

r(:,1:,:) = (/mnmn*r(:,1:,:)/)

r(:,0,:) = (/dim_sum_n (r(:,1:2,:),1)/)
r(:,:,3) = (/dim_avg_n (r(:,:,4:),2)/)
std = dim_stddev_Wrap (r(:,:,4:))

print((/r(:,:,:2)/))


; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks  = gsn_open_wks("svg", out_path + out_name)
dum1 = new(4, graphic)
dum2 = new(4, graphic)
plot2 = new(4, graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = text1
res@gsnCenterString = text2
res@gsnRightString = text3
res@gsnStringFontHeightF = .024

res@tiYAxisString = text4(0)
res@tiXAxisString = text4(1)
res@tiXAxisFontHeightF = .023
res@tiMainString = "Effect of NDJ CTI on ~F33~D~F~SSTA by Mechanisms"
res@tiMainFontHeightF = .028

res@trYMaxF = .14
res@trYMinF = -.01
res@trXMaxF = .14
res@trXMinF = -.01

res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023

res@xyMarkLineMode = "Markers"
res@xyMarker = indexes
res@xyMarkerSizes = sizes(0,:)
res@xyMarkerColors = colors
res@xyMarkerThicknessF = thicknesses
plot = gsn_csm_xy(wks, transpose((/r(0,:,0),r(0,:,0)/)), transpose((/r(1,:,0),r(1,:,0)/)), res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2.
resl@gsLineDashPattern = 1
duma = gsn_add_polyline(wks, plot, (/-1.,1./), (/-1.,1./), resl)

resl@gsLineDashPattern = 0
do i = 0, 3
    resl@gsLineColor = colors(i)
    dum1(i) = gsn_add_polyline(wks, plot, (/r(0,i,3)-std(0,i),r(0,i,3)+std(0,i)/), (/r(1,i,3),r(1,i,3)/), resl)
    dum2(i) = gsn_add_polyline(wks, plot, (/r(0,i,3),r(0,i,3)/), (/r(1,i,3)-std(1,i),r(1,i,3)+std(1,i)/), resl)
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
    reso@xyMarkerSizes = sizes(i,:)
    reso@xyMarkerThicknessF = thicknesses(i)
    plot2(i-1) = gsn_csm_xy(wks, transpose((/r(0,:,i),r(0,:,i)/)), transpose((/r(1,:,i),r(1,:,i)/)), reso)
    overlay(plot, plot2(i-1))
end do

draw(plot)

;--------------------------------------------------------------
;Manually creating a legend
/;
gsres = True
gsres@gsMarkerThicknessF = thickness
do i = 0, 1
    gsres@gsMarkerSizeF = sizes(i,0)
    gsres@gsMarkerIndex = indexes(i)
    gsn_polymarker_ndc(wks, x1(i), y1(i), gsres)
end do
;/
txres = True
txres@txJust = "CenterLeft"
txres@txFontHeightF = 0.018

;gsn_text_ndc(wks, text5, x1 + 0.025, y1, txres)

do i = 0, 3
    txres@txFontColor = colors(i)
    gsn_text_ndc(wks, text6(i), x2(i), y2(i), txres)
end do

frame(wks)

end
