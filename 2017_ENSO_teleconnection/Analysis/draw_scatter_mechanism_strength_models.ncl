;*************************************************************
;Aim: Draw a scatter plot of the strengths of each mechanisms in each model
;
;Mission:
;
;    1. Read data from dataset
;    2. Post-post process to deserved results
;    3. Draw the plot
;                       Shan He
;                       2018-05-04
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;    var1--------------mnmx
;    var2--------------std
;    var3--------------r
;================================================

;data
in_path = "~/hes/ENSO/NCL/"
in_name0 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
in_name4 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

mnmn = new((/2,3,37+2/), float)
r = new((/2,6,37+2/), float)

;fig
out_path = "~/hes/ENSO/Fig/"
out_name = "scatter_mechanism_strength_models"

;k-means clustering
k = 4      ;number of clusters
opt = True
opt@iter = 64
opt@iseed = 2

;text
text0 = (/"a)","b)","c)","d)"/)
text1 = (/"TIO","TNA","~F35~J~F~C/~F35~J~F~C"/)
text2 = (/"SSTA","~F10~U~B~Surf","~F10~F~B~Rad","~F10~T~B~Trop"/)
text3 = (/"OBS","MMM"/)
text4 = (/"0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)

x = (/.15,.15/)
y = (/.87,.84/)
colors1 = (/"darkgoldenrod4","firebrick4","deepskyblue4","green4"/)
colors2 = (/"red","dodgerblue2","dodgerblue2","orange","orange","orange","cyan","cyan","cyan","cyan","green","green","green","green","green",\
            "purple","purple","purple","purple","purple","purple"/)
colors3 = (/"red","red","dodgerblue2","dodgerblue2","orange","orange","cyan","cyan","cyan","cyan","green","green","green","green","green",\
            "purple","purple","purple","purple","purple","purple"/)
colors4 = (/"green","dodgerblue2","red","orange","black","cyan","yellow3","purple"/)
sizes = (/.025,.02,.02/)
indexes = (/5,16/)
thicknesses = (/6,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in0 = addfile(in_path + in_name0, "r")
in1 = addfile(in_path + in_name1, "r")
in2 = addfile(in_path + in_name2, "r")
in3 = addfile(in_path + in_name3, "r")
in4 = addfile(in_path + in_name4, "r")

z1 = ispan(0, 37+2, 1)
z2 = ispan(0, 37+1, 1)
iM1 = ind(z1 .ne. 1)
iM2 = ind(z2 .ne. 1)

r(:,0,:) = in0->mnmx(:,iM1)
mnmn(:,0,:) = in1->mnmx
mnmn(:,1,:) = (/in2->mnmx(:,iM1)/)
mnmn(:,2,:) = (/in3->mnmx/)
r(:,3:,:) = (/in4->r/)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

r(:,3:,:) = (/mnmn * r(:,3:,:) /)
r(:,1,:) = (/dim_sum_n(r(:,3:,:), 1)/)
r(:,2,:) = (/dim_sum_n(r(:,3:4,:), 1)/)
r(:,:,1) = (/dim_avg_n(r(:,:,2:), 2)/)
ndim = dimsizes(r)

A = r(:,(/0,3,4,5/),iM2)
A(:,0,:) = (/A(:,0,:) / conform(A(:,0,:), dim_stddev(A(:,0,:)), 0)/)
A(:,1:,:) = (/A(:,1:,:) / conform(A(:,1:,:), dim_stddev_n(A(:,1:,:), 2), (/0,1/))/)

;clcnter1 = kmeans_as136(A(0,:,:), k, opt)
;clcnter2 = kmeans_as136(A(1,:,:), k, opt)
;printVarSummary(clcnter1)
;printVarSummary(clcnter2)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(4, graphic)
dum = new(8, graphic)
mod1 = new(ndim(2), graphic)
mod2 = new(ndim(2), graphic)
mod3 = new(ndim(2), graphic)
mod4 = new(ndim(2), graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiXAxisFontHeightF = .023

res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023

res@xyMarkLineMode = "Markers"
res@xyMarkers = indexes
res@xyMarkerSizeF = sizes
res@xyMarkerThicknesses = thicknesses

res@gsnLeftString = text0(0)
res@gsnCenterString = text1(0)
res@gsnRightString = text1(2)
res@tiYAxisString = text2(0)
res@tiXAxisString = text2(3)
res@trYMaxF = .5
res@trYMinF = .1
res@trXMaxF = .12
res@trXMinF = -.01
plot(0) = gsn_csm_xy(wks, transpose((/r(0,5,:1),r(0,5,:1)/)), transpose((/r(0,0,:1),r(0,0,:1)/)), res)

res@gsnLeftString = text0(1)
res@gsnCenterString = text1(1)
res@gsnRightString  = " "
res@trYMaxF = .55
res@trYMinF = .0
res@trXMaxF = .12
res@trXMinF = -.01
plot(1) = gsn_csm_xy(wks, transpose((/r(1,5,:1),r(1,5,:1)/)), transpose((/r(1,0,:1),r(1,0,:1)/)), res)

res@gsnLeftString = text0(2)
res@gsnCenterString = " "
res@tiYAxisString = text2(1)
res@tiXAxisString = text2(2)
res@trYMaxF = .16
res@trYMinF = -.05
res@trXMaxF = .2
res@trXMinF = -.01
plot(2) = gsn_csm_xy(wks, transpose((/r(0,4,:1),r(0,4,:1)/)), transpose((/r(0,3,:1),r(0,3,:1)/)), res)

res@gsnLeftString = text0(3)
res@trYMaxF = .2
res@trYMinF = -.01
res@trXMaxF = .16
res@trXMinF = -.05
plot(3) = gsn_csm_xy(wks, transpose((/r(1,4,:1),r(1,4,:1)/)), transpose((/r(1,3,:1),r(1,3,:1)/)), res)

;--------------------------------------------------------------
;each model
reso = True
reso@txFontHeightF = sizes(2)
do i = 2, ndim(2)-1
;    a = toint(((A(0,0,i-1) - A(0,0,0)) ^ 2. + (A(0,1,i-1) - A(0,1,0)) ^ 2 + (A(0,2,i-1) - A(0,2,0)) ^ 2 + (A(0,3,i-1) - A(0,3,0)) ^ 2) / 2)
    a = ((A(0,0,i-1) - A(0,0,0)) ^ 2. + (A(0,1,i-1) - A(0,1,0)) ^ 2 + (A(0,2,i-1) - A(0,2,0)) ^ 2 + (A(0,3,i-1) - A(0,3,0)) ^ 2) / 2
;    print((/a/))
;    reso@txFontColor = (/0,0,0,a/)
;    reso@txFontColor = colors2(a)
    if(a .le. 1.3)then
        reso@txFontColor = "red"
    else
        reso@txFontColor = "black"
    end if
;    reso@txFontColor = colors4(clcnter1@id(i-1)-1)
    mod1(i) = gsn_add_text(wks, plot(0), text4(i-2), r(0,5,i), r(0,0,i), reso)
    mod3(i) = gsn_add_text(wks, plot(2), text4(i-2), r(0,4,i), r(0,3,i), reso)
;    a = toint(((A(1,0,i-1) - A(1,0,0)) ^ 2. + (A(1,1,i-1) - A(1,1,0)) ^ 2 + (A(1,2,i-1) - A(1,2,0)) ^ 2 + (A(1,3,i-1) - A(1,3,0)) ^ 2) / 2)
    a = ((A(1,0,i-1) - A(1,0,0)) ^ 2. + (A(1,1,i-1) - A(1,1,0)) ^ 2 + (A(1,2,i-1) - A(1,2,0)) ^ 2 + (A(1,3,i-1) - A(1,3,0)) ^ 2) / 2
;    reso@txFontColor = (/0,0,0,a/)
;    reso@txFontColor = colors3(a)
    if(a .le. 2.5)then
        reso@txFontColor = "red"
    else
        reso@txFontColor = "black"
    end if
;    reso@txFontColor = colors4(clcnter2@id(i-1)-1)
    mod2(i) = gsn_add_text(wks, plot(1), text4(i-2), r(1,5,i), r(1,0,i), reso)
    mod4(i) = gsn_add_text(wks, plot(3), text4(i-2), r(1,4,i), r(1,3,i), reso)
end do

;--------------------------------------------------------------
;add the line
resl = True
resl@gsLineThicknessF = 2.
resl@gsLineDashPattern = 1
dum(0) = gsn_add_polyline(wks, plot(0), (/r(0,5,0),r(0,5,0)/), (/-1.,1./), resl)
dum(1) = gsn_add_polyline(wks, plot(1), (/r(1,5,0),r(1,5,0)/), (/-1.,1./), resl)
dum(2) = gsn_add_polyline(wks, plot(2), (/r(0,4,0),r(0,4,0)/), (/-1.,1./), resl)
dum(3) = gsn_add_polyline(wks, plot(3), (/r(1,4,0),r(1,4,0)/), (/-1.,1./), resl)
dum(4) = gsn_add_polyline(wks, plot(0), (/-1.,1./), (/r(0,0,0),r(0,0,0)/), resl)
dum(5) = gsn_add_polyline(wks, plot(1), (/-1.,1./), (/r(1,0,0),r(1,0,0)/), resl)
dum(6) = gsn_add_polyline(wks, plot(2), (/-1.,1./), (/r(0,3,0),r(0,3,0)/), resl)
dum(7) = gsn_add_polyline(wks, plot(3), (/-1.,1./), (/r(1,3,0),r(1,3,0)/), resl)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@gsnFrame = False
resP@txString = "Effect of NDJ CTI on ~F33~D~F~SSTA by Mechanisms"
resP@txFontHeightF = .028

gsn_panel(wks, plot, (/2,2/), resP)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0,1
    gsres@gsMarkerSizeF = sizes(i) * .75
    gsres@gsMarkerIndex = indexes(i)
    gsres@gsMarkerThicknessF = thicknesses(i)
    gsn_polymarker_ndc(wks, x(i), y(i), gsres)
end do

txres = True
txres@txJust = "CenterLeft"
txres@txFontHeightF = 0.014
gsn_text_ndc(wks, text3, x + .022, y, txres)

frame(wks)

end
