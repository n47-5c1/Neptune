;*************************************************************
;Aim: Draw a scatter plot of the strengths of each mechanisms in each model
;
;Mission:
;
;   1. Read data from dataset
;   2. Draw the plot
;                       Shan He
;                       2018-05-14
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
    in_path  = "~/hes/ENSO/NCL/"
    in_name0 = "scatter_asymmetry_SSTA_mechanism.nc"
    in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    in_name4 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

    mnmx = new((/2,3,37+2/),float)
    r    = new((/2,3,37+2/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_name = "scatter_mechanism_strength_models_2"

;text
    text0 = (/"a) ENSO on ~F10~U~B~Surf","b) ENSO on ~F10~F~B~Rad","c) ENSO on ~F10~T~B~Trop",\
              "d) ~F10~U~B~Surf~N~~F~ on ~F33~D~F~SSTA","e) ~F10~F~B~Rad~N~~F~ on ~F33~D~F~SSTA","f) ~F10~T~B~Trop~N~~F~ on ~F33~D~F~SSTA"/)
    text1 = (/"m~F34~W~F~s~S~-1~N~/~F35~J~F~C","W~F34~W~F~m~S~-2~N~/~F35~J~F~C","~F35~J~F~C/~F35~J~F~C",\
              "~F35~J~F~C/m~F34~W~F~s~S~-1~N~","~F35~J~F~C/W~F34~W~F~m~S~-2~N~","~F35~J~F~C/~F35~J~F~C"/)
    text2 = (/"TNA","TIO"/)
    text3 = (/"OBS","MMM"/)
    text4 = (/"0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)

    x       = (/.09,.09/)
    y       = (/.74,.72/)
    colors1 = (/"darkgoldenrod4","firebrick4","deepskyblue4","green4"/)
    colors2 = (/"green","dodgerblue2","red","orange","black","cyan","yellow3","purple"/)
    sizes   = (/.025,.02,.02/)
    indexes = (/5,16/)
    thicknesses = (/6,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in0 = addfile (in_path + in_name0,"r")
    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")
    in4 = addfile (in_path + in_name4,"r")

    z  = ispan (0,37+2,1)
    iM = ind (z.ne.1)

    clcnter     = in0->clcnter
    mnmx(:,0,:) = in1->mnmx
    mnmx(:,1,:) = (/in2->mnmx(:,iM)/)
    mnmx(:,2,:) = (/in3->mnmx/)
    r           = in4->r
    ndim = dimsizes (r)

; ==============================================================
; Mission 2. Draw the timeseries
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)
plot = new (6,graphic)
dum1 = new (6,graphic)
dum2 = new (6*2,graphic)
mod1 = new (ndim(2),graphic)
mod2 = new (ndim(2),graphic)
mod3 = new (ndim(2),graphic)
mod4 = new (ndim(2),graphic)
mod5 = new (ndim(2),graphic)
mod6 = new (ndim(2),graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

res@xyMarkLineMode = "Markers"
res@xyMarkers      = indexes
res@xyMarkerSizeF  = sizes
res@xyMarkerThicknesses = thicknesses

res@gsnLeftString  = text0(0)
res@gsnRightString = text1(0)
res@trYMaxF = .05
res@trYMinF = -.65
res@trXMaxF = .1
res@trXMinF = -.6
plot(0) = gsn_csm_xy (wks, transpose((/mnmx(0,0,:1),mnmx(0,0,:1)/)), transpose((/mnmx(1,0,:1),mnmx(1,0,:1)/)) ,res)

res@gsnLeftString  = text0(1)
res@gsnRightString = text1(1)
res@trYMaxF = 3.
res@trYMinF = -7.
res@trXMaxF = 1.
res@trXMinF = -9.
plot(1) = gsn_csm_xy (wks, transpose((/mnmx(0,1,:1),mnmx(0,1,:1)/)), transpose((/mnmx(1,1,:1),mnmx(1,1,:1)/)) ,res)

res@gsnLeftString  = text0(2)
res@gsnRightString = text1(2)
res@trYMaxF = .7
res@trYMinF = -.1
res@trXMaxF = .7
res@trXMinF = -.1
plot(2) = gsn_csm_xy (wks, transpose((/mnmx(0,2,:1),mnmx(0,2,:1)/)), transpose((/mnmx(1,2,:1),mnmx(1,2,:1)/)) ,res)

res@gsnLeftString  = text0(3)
res@gsnRightString = text1(3)
res@trYMaxF = .05
res@trYMinF = -.4
res@trXMaxF = .05
res@trXMinF = -.4
plot(3) = gsn_csm_xy (wks, transpose((/r(0,0,:1),r(0,0,:1)/)), transpose((/r(1,0,:1),r(1,0,:1)/)) ,res)

res@gsnLeftString  = text0(4)
res@gsnRightString = text1(4)
res@trYMaxF = .01
res@trYMinF = -.05
res@trXMaxF = .01
res@trXMinF = -.05
plot(4) = gsn_csm_xy (wks, transpose((/r(0,1,:1),r(0,1,:1)/)), transpose((/r(1,1,:1),r(1,1,:1)/)) ,res)

res@gsnLeftString  = text0(5)
res@gsnRightString = text1(5)
res@trYMaxF = .25
res@trYMinF = -.05
res@trXMaxF = .25
res@trXMinF = -.05
plot(5) = gsn_csm_xy (wks, transpose((/r(0,2,:1),r(0,2,:1)/)), transpose((/r(1,2,:1),r(1,2,:1)/)) ,res)

;--------------------------------------------------------------
;each model
reso = True
reso@txFontHeightF = sizes(2)
reso@txFontThicknessF = 50
reso@gsMarkerIndex = 4
reso@gsMarkerSizeF = sizes(0)
reso@gsMarkerColor = colors1(1)
reso@gsMarkerThicknessF = thicknesses(0)
do i=2,ndim(2)-1
 reso@txFontColor = colors2(clcnter@id(i-1)-1)
 mod1(i) = gsn_add_text (wks,plot(0),text4(i-2),mnmx(0,0,i),mnmx(1,0,i),reso)
 mod2(i) = gsn_add_text (wks,plot(1),text4(i-2),mnmx(0,1,i),mnmx(1,1,i),reso)
 mod3(i) = gsn_add_text (wks,plot(2),text4(i-2),mnmx(0,2,i),mnmx(1,2,i),reso)
 mod4(i) = gsn_add_text (wks,plot(3),text4(i-2),r(0,0,i),r(1,0,i),reso)
 mod5(i) = gsn_add_text (wks,plot(4),text4(i-2),r(0,1,i),r(1,1,i),reso)
 mod6(i) = gsn_add_text (wks,plot(5),text4(i-2),r(0,2,i),r(1,2,i),reso)
end do

;-------------------------------------------------------------
;add the line
resl = True
resl@gsLineThicknessF  = 2.
resl@gsLineDashPattern = 1

dum1(0) = gsn_add_polyline (wks,plot(0),(/-1.,1./),(/-1.,1./),resl)
dum1(1) = gsn_add_polyline (wks,plot(1),(/-9.,1./),(/-9.,1./),resl)
dum1(2) = gsn_add_polyline (wks,plot(2),(/-.1,1./),(/-.1,1./),resl)
dum1(3) = gsn_add_polyline (wks,plot(3),(/-1.,.1/),(/-1.,.1/),resl)
dum1(4) = gsn_add_polyline (wks,plot(4),(/-1.,1./),(/-1.,1./),resl)
dum1(5) = gsn_add_polyline (wks,plot(5),(/-.1,.3/),(/-.1,.3/),resl)

dum2(0) = gsn_add_polyline (wks,plot(0),(/.0,.0/),(/-1.,1./),resl)
dum2(1) = gsn_add_polyline (wks,plot(1),(/.0,.0/),(/-8.,4./),resl)
dum2(2) = gsn_add_polyline (wks,plot(2),(/.0,.0/),(/-1.,1./),resl)
dum2(3) = gsn_add_polyline (wks,plot(3),(/.0,.0/),(/-1.,1./),resl)
dum2(4) = gsn_add_polyline (wks,plot(4),(/.0,.0/),(/-.1,.1/),resl)
dum2(5) = gsn_add_polyline (wks,plot(5),(/.0,.0/),(/-1.,1./),resl)

dum2(6)  = gsn_add_polyline (wks,plot(0),(/-1.,1./),(/.0,.0/),resl)
dum2(7)  = gsn_add_polyline (wks,plot(1),(/-9.,1./),(/.0,.0/),resl)
dum2(8)  = gsn_add_polyline (wks,plot(2),(/-1.,1./),(/.0,.0/),resl)
dum2(9)  = gsn_add_polyline (wks,plot(3),(/-1.,1./),(/.0,.0/),resl)
dum2(10) = gsn_add_polyline (wks,plot(4),(/-.1,.1/),(/.0,.0/),resl)
dum2(11) = gsn_add_polyline (wks,plot(5),(/-1.,1./),(/.0,.0/),resl)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@gsnFrame      = False
resP@txString      = "Effect of NDJ CTI on ~F33~D~F~SSTA by Mechanisms"
resP@txFontHeightF = 0.022

gsn_panel(wks,plot,(/2,3/),resP)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,1
 gsres@gsMarkerSizeF = sizes(i)*.55
 gsres@gsMarkerIndex = indexes(i)
 gsres@gsMarkerThicknessF = thicknesses(i)
 gsn_polymarker_ndc (wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.012
gsn_text_ndc (wks,text3,x+.02,y,txres)

frame (wks)

end
