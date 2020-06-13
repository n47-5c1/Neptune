;*************************************************************
;Aim: Draw a scatter plot of the asymmetry in regional SSTA and strength of the mechanisms between TIO and TNA in each model
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-05-07
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
    in_name0 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
    in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    in_name4 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

    mnmn = new((/2,3,37+2/),float)
    r    = new((/2,6,37+2/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_asymmetry_SSTA_mechanism.nc"
    out_name = "scatter_asymmetry_SSTA_mechanism"

;k-means clustering
    k         = 5      ;number of clusters
    opt       = True
    opt@iter  = 64
    opt@iseed = 2

;text
;    text0 = (/"a) Total","b) ~F10~U~B~Surf","c) ~F10~F~B~Rad","d) ~F10~T~B~Trop"/)
    text1 = (/"a)","b)","c)"/)
    text2 = (/"SSTA","Mechanism","ABM","TTM","~F10~U~B~Surf","~F10~F~B~Rad"/)
    text3 = (/"OBS","MMM"/)
    text4 = (/"0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)

;    model = (/6,10,26,27,30/)
    model = (/1,4,8,17,18,19,20,22,23,25/)

    x       = (/.08,.08/)
    y       = (/.59,.57/)
    colors1 = (/"darkgoldenrod4","firebrick4","deepskyblue4","green4"/)
    colors2 = (/"green","dodgerblue2","red","orange","black","cyan","yellow3","purple"/)
    sizes   = (/0.025,0.018,0.02/)
    indexes = (/16,0/)

    rad = atan(1)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in0 = addfile (in_path + in_name0,"r")
    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")
    in4 = addfile (in_path + in_name4,"r")

    z1  = ispan (0,37+2,1)
    z2  = ispan (0,37+1,1)
    iM1 = ind (z1.ne.1)
    iM2 = ind (z2.ne.1)

    r(:,0,:)    = in0->mnmx(:,iM1)
    mnmn(:,0,:) = in1->mnmx
    mnmn(:,1,:) = (/in2->mnmx(:,iM1)/)
    mnmn(:,2,:) = (/in3->mnmx/)
    r(:,3:,:)   = (/in4->r/)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    r(:,3:,:) = (/ mnmn*r(:,3:,:) /)
    r(:,1,:)  = (/dim_sum_n (r(:,3:,:),1)/)
    r(:,2,:)  = (/dim_sum_n (r(:,(/3,4/),:),1)/)
    r(:,:,1)  = (/dim_avg_n (r(:,:,2:),2)/)
    ndim = dimsizes (r)

    A = atan2 (r(1,:,:),r(0,:,:))
    B = A((/0,3,4,5/),iM2)
;    B = A((/0,2,5/),iM2)

    clcnter   = kmeans_as136 (B,k,opt)
    clcnter!0 = "cluster"
    clcnter!1 = "variable"
    
;    clcnter = (/clcnter-rad/)

    printVarSummary (clcnter)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

dim = dimsizes (clcnter)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"cluster","variable"/)
dimSizes = dim
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"cluster","integer","cluster")
filevardef (fout,"variable","integer","variable")
filevardef (fout,"clcnter",typeof(clcnter),getvardims(clcnter))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"clcnter",clcnter)

;output only the data values
fout->cluster  = ispan (1,dim(0),1)
fout->variable = ispan (1,dim(1),1)
fout->cnter    = (/clcnter/)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)
plot = new (3,graphic)
dum1 = new (3,graphic)
dum2 = new (3,graphic)
mod1 = new (ndim(2),graphic)
mod2 = new (ndim(2),graphic)
mod3 = new (ndim(2),graphic)
HL1 = new (ndim(2),graphic)
HL2 = new (ndim(2),graphic)
HL3 = new (ndim(2),graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiXAxisFontHeightF = .023

res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023

indexes(1) = NhlNewMarker(wks, "y", 35, 0.0, 0.0, 1.0, 1.0, 0.0)
res@xyMarkLineMode = "Markers"
res@xyMarkers      = indexes
res@xyMarkerSizeF  = sizes

res@gsnLeftString = text1(0)
res@trYMaxF = 1.6
res@trYMinF = .0
res@trXMaxF = 1.6
res@trXMinF = .0
res@tiYAxisString = text2(0)
res@tiXAxisString = text2(1)
plot(0) = gsn_csm_xy (wks, transpose((/A(1,:1),A(1,:1)/)), transpose((/A(0,:1),A(0,:1)/)) ,res)

res@gsnLeftString = text1(1)
res@gsnCenterString = " "
res@trYMaxF = 1.8
res@trYMinF = .0
res@trXMaxF = 1.8
res@trXMinF = .0
res@tiYAxisString = text2(2)
res@tiXAxisString = text2(3)
plot(1) = gsn_csm_xy (wks, transpose((/A(5,:1),A(5,:1)/)), transpose((/A(2,:1),A(2,:1)/)) ,res)

res@gsnLeftString = text1(2)
res@trYMaxF = 1.7
res@trYMinF = .0
res@trXMaxF = 1.6
res@trXMinF = -.1
res@tiYAxisString = text2(4)
res@tiXAxisString = text2(5)
plot(2) = gsn_csm_xy (wks, transpose((/A(4,:1),A(4,:1)/)), transpose((/A(3,:1),A(3,:1)/)) ,res)

;--------------------------------------------------------------
;each model
reso = True
reso@txFontHeightF = sizes(2)
do i=2,ndim(2)-1
 reso@txFontColor = colors2(clcnter@id(i-1)-1)
 mod1(i) = gsn_add_text (wks,plot(0),text4(i-2),A(1,i),A(0,i),reso)
 mod2(i) = gsn_add_text (wks,plot(1),text4(i-2),A(5,i),A(2,i),reso)
 mod3(i) = gsn_add_text (wks,plot(2),text4(i-2),A(4,i),A(3,i),reso)
end do

;--------------------------------------------------------------
;add the line
resl = True
resl@gsLineThicknessF  = 2.
resl@gsLineDashPattern = 1
do i=0,2
 dum1(i) = gsn_add_polyline (wks,plot(i),(/-1.,2./),(/rad,rad/),resl)
 dum2(i) = gsn_add_polyline (wks,plot(i),(/rad,rad/),(/-1.,2./),resl)
end do

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@gsnFrame      = False
resP@txString      = "Asymmetry in SSTA and Mechanisms"
resP@txFontHeightF = 0.02

gsn_panel(wks,plot,(/1,3/),resP)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,1
 gsres@gsMarkerSizeF = sizes(i)*.5
 gsres@gsMarkerIndex = indexes(i)
 gsn_polymarker_ndc (wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.01
gsn_text_ndc (wks,text3,x+.016,y,txres)

frame (wks)

end
