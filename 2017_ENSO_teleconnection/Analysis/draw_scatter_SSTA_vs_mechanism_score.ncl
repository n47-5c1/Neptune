;*************************************************************
;Aim: Draw a scatter plot of ENSO-related SSTA score versus mechanisms score
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-03-20
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------mnmx
;   var2--------------std
;   var3--------------r
;================================================
;data
    in_path  = "~/hes/ENSO/NCL/"
    in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
    in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    in_name4 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    in_name5 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

    mnmn = new((/2,4,37+2/),float)
    r    = new((/2,3,37+2/),float)
    rank = new((/2,5,37+1/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_name = "scatter_SSTA_vs_mechanism_score"

;text
    text1 = (/"a)","b)","c)","d)"/)
    text2 = (/"Total","WSPD","NRS","TTM"/)
    text3 = (/"ENSO-Driven SSTA","Mechanism-Related ~F33~D~F~SSTA"/)
    text4 = (/"MMM (TIO)","MSs","MMM (TNA)","MSs"/)

;    XF      = (/.3,-.15,.15,-.1,.2,-.05,.1,-.1/)
    XF      = (/.3,-.15,.15,-.1,.2,-.05,.13,-.12/)
    x       = (/.15,.15,.15,.15/)
    y       = (/.87,.85,.83,.81/)
    colors  = (/"red3","dodgerblue2"/)
    sizes   = (/.025,.04/)
    indexes = (/5,1/)
    thicknesses = (/5.5,1/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")
    in4 = addfile (in_path + in_name4,"r")
    in5 = addfile (in_path + in_name5,"r")

    n = ispan(1,37+3,1)
    N = ind(n.ne.2)

    mnmn(:,0,:) = in1->mnmx(:,N)
    mnmn(:,1,:) = in2->mnmx
    mnmn(:,2,:) = in3->mnmx
    mnmn(:,3,:) = in4->mnmx
    r = in5->r

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
     
    r = (/ mnmn(:,1:,:)*r /)

    rank(:,0,:)  = mnmn(:,0,1:) - conform_dims( dimsizes( mnmn(:,0,1:) ), mnmn(:,0,0), 0 )
    rank(:,2:,:) = r(:,:,1:) - conform_dims( dimsizes( r(:,:,1:) ), r(:,:,0), (/0,1/) )
    rank(:,1,:)  = dim_sum_n (rank(:,2:,:),1)
    rank(:,1:,0) = dim_avg_n (rank(:,1:,1:),2)
    print((/rank(:,2:,0)+r(:,:,0)/))

;    a = ind (rank(0,0,1:)^2. + rank(0,1,1:)^2. .le. 1.2)
;    b = ind (rank(1,0,1:)^2. + rank(1,1,1:)^2. .le. .56)
;    a = ind (abs(rank(0,0,1:)) .le. .9)
;    b = ind (abs(rank(1,0,1:)) .le. .643)
;    print((/a/))
;    print((/b/))

    cfm = conform_dims( dimsizes( rank(:,1:,1:) ),rank(:,0,1:),(/0,2/) )

    ccr = escorc ( cfm ,rank(:,1:,1:))
    print((/ccr/))

;calculate the regression coefficient
   rc1 = regline (rank(0,1,1:),rank(0,0,1:))
   rc2 = regline (rank(1,1,1:),rank(1,0,1:))
   rc3 = regline (rank(0,2,1:),rank(0,0,1:))
   rc4 = regline (rank(1,2,1:),rank(1,0,1:))
   rc5 = regline (rank(0,3,1:),rank(0,0,1:))
   rc6 = regline (rank(1,3,1:),rank(1,0,1:))
   rc7 = regline (rank(0,4,1:),rank(0,0,1:))
   rc8 = regline (rank(1,4,1:),rank(1,0,1:))

;Create an array
   data1 = rc1*(rank(0,1,1:)-rc1@xave) + rc1@yave
   data2 = rc2*(rank(1,1,1:)-rc2@xave) + rc2@yave
   data3 = rc3*(rank(0,2,1:)-rc3@xave) + rc3@yave
   data4 = rc4*(rank(1,2,1:)-rc4@xave) + rc4@yave
   data5 = rc5*(rank(0,3,1:)-rc5@xave) + rc5@yave
   data6 = rc6*(rank(1,3,1:)-rc6@xave) + rc6@yave
   data7 = rc7*(rank(0,4,1:)-rc7@xave) + rc7@yave
   data8 = rc8*(rank(1,4,1:)-rc8@xave) + rc8@yave

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

wks   = gsn_open_wks ("svg",out_path+out_name)
plot  = new (4,graphic)        
plot1 = new (4,graphic)        
plot2 = new (4,graphic)        

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF      = .028
res@gsnRightStringFontHeightF = .025

res@tiYAxisString      = text3(0)
res@tiXAxisString      = text3(1)
res@tiXAxisFontHeightF = .027

res@trYMaxF = .3
res@trYMinF = -.25

res@tmXBLabelFontHeightF = .027    ;font height of tick labels
res@tmYLLabelFontHeightF = .027

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineModes  = (/"Markers","Lines"/)
res@xyMarker         = indexes(1)
res@xyMarkerSizeF    = sizes(1)
res@xyMarkerColor    = colors(0)
res@xyLineColor      = colors(0)
res@xyDashPatterns   = 1
res@xyLineThicknessF = 3

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = sprintf("%4.2f",ccr(0,0))+", "+sprintf("%4.2f",ccr(1,0))
res@tiXAxisOn = False
res@trXMaxF   = XF(0)
res@trXMinF   = XF(1)
plot(0) = gsn_csm_xy (wks,(/rank(0,1,1:),rank(0,1,1:)/),(/rank(0,0,1:),data1/),res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
res@tiYAxisOn = False
res@trXMaxF   = XF(2)
res@trXMinF   = XF(3)
;plot(1) = gsn_csm_xy (wks,(/rank(0,2,1:),rank(0,2,1:)/),(/rank(0,0,1:),data3/),res)
plot(1) = gsn_csm_xy (wks,(/rank(0,2,1:)/),(/rank(0,0,1:)/),res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
res@tiXAxisOn = True
res@tiYAxisOn = True
res@trXMaxF   = XF(4)
res@trXMinF   = XF(5)
;plot(2) = gsn_csm_xy (wks,(/rank(0,3,1:),rank(0,3,1:)/),(/rank(0,0,1:),data5/),res)
plot(2) = gsn_csm_xy (wks,(/rank(0,3,1:)/),(/rank(0,0,1:)/),res)
res@gsnLeftString   = text1(3)
res@gsnCenterString = text2(3)
res@tiYAxisOn = False
res@trXMaxF   = XF(6)
res@trXMinF   = XF(7)
;plot(3) = gsn_csm_xy (wks,(/rank(0,4,1:),rank(0,4,1:)/),(/rank(0,0,1:),data7/),res)
plot(3) = gsn_csm_xy (wks,(/rank(0,4,1:)/),(/rank(0,0,1:)/),res)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
;dum1 = gsn_add_polyline (wks,plot,(/-2.,3./),(/-2.,3./),resl)
dum1 = gsn_add_polyline (wks,plot(0),(/0.,0./),(/-1.,1./),resl)
dum2 = gsn_add_polyline (wks,plot(0),(/-1.,1./),(/0.,0./),resl)
dum3 = gsn_add_polyline (wks,plot(1),(/0.,0./),(/-1.,1./),resl)
dum4 = gsn_add_polyline (wks,plot(1),(/-1.,1./),(/0.,0./),resl)
dum5 = gsn_add_polyline (wks,plot(2),(/0.,0./),(/-1.,1./),resl)
dum6 = gsn_add_polyline (wks,plot(2),(/-1.,1./),(/0.,0./),resl)
dum7 = gsn_add_polyline (wks,plot(3),(/0.,0./),(/-1.,1./),resl)
dum8 = gsn_add_polyline (wks,plot(3),(/-1.,1./),(/0.,0./),resl)
;resl@gsLineColor       = colors(2)
resl@gsLineThicknessF  = 3
resl@gsLineDashPattern = 0
;a = (res@trYMaxF-res@trYMinF)/50.
;dum1 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2),mnmx(1,2)/),resl)
;dum2 = gsn_add_polyline (wks,plot,(/mnmx(0,2),mnmx(0,2)/),(/mnmx(1,2)-std(1),mnmx(1,2)+std(1)/),resl)
;dum3 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)-std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
;dum4 = gsn_add_polyline (wks,plot,(/mnmx(0,2)+std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
;dum5 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)-std(1),mnmx(1,2)-std(1)/),resl)
;dum6 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)+std(1),mnmx(1,2)+std(1)/),resl)

;--------------------------------------------------------------
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False

reso@xyMarkLineModes  = (/"Markers","Lines"/)
reso@xyMarker         = indexes(1)
reso@xyMarkerSizeF    = sizes(1)
reso@xyMarkerColor    = colors(1)
reso@xyLineColor      = colors(1)
reso@xyDashPatterns   = 1
reso@xyLineThicknessF = 3
plot1(0) = gsn_csm_xy (wks,(/rank(1,1,1:),rank(1,1,1:)/),(/rank(1,0,1:),data2/),reso)
;plot1(1) = gsn_csm_xy (wks,(/rank(1,2,1:),rank(1,2,1:)/),(/rank(1,0,1:),data4/),reso)
;plot1(2) = gsn_csm_xy (wks,(/rank(1,3,1:),rank(1,3,1:)/),(/rank(1,0,1:),data6/),reso)
;plot1(3) = gsn_csm_xy (wks,(/rank(1,4,1:),rank(1,4,1:)/),(/rank(1,0,1:),data8/),reso)
;plot1(0) = gsn_csm_xy (wks,(/rank(1,1,1:)/),(/rank(1,0,1:)/),reso)
plot1(1) = gsn_csm_xy (wks,(/rank(1,2,1:)/),(/rank(1,0,1:)/),reso)
plot1(2) = gsn_csm_xy (wks,(/rank(1,3,1:)/),(/rank(1,0,1:)/),reso)
plot1(3) = gsn_csm_xy (wks,(/rank(1,4,1:)/),(/rank(1,0,1:)/),reso)

delete(reso@xyMarkLineModes)
reso@xyMarkLineMode = "Markers"
reso@xyMarker       = indexes(0)
reso@xyMarkerSizeF  = sizes(0)
reso@xyMarkerColors = colors
reso@xyMarkerThicknessF = thicknesses
plot2(0) = gsn_csm_xy (wks, transpose((/rank(:,1,0),rank(:,1,0)/)), transpose((/rank(:,0,0),rank(:,0,0)/)), reso)
plot2(1) = gsn_csm_xy (wks, transpose((/rank(:,2,0),rank(:,2,0)/)), transpose((/rank(:,0,0),rank(:,0,0)/)), reso)
plot2(2) = gsn_csm_xy (wks, transpose((/rank(:,3,0),rank(:,3,0)/)), transpose((/rank(:,0,0),rank(:,0,0)/)), reso)
plot2(3) = gsn_csm_xy (wks, transpose((/rank(:,4,0),rank(:,4,0)/)), transpose((/rank(:,0,0),rank(:,0,0)/)), reso)

overlay (plot(0),plot1(0))
overlay (plot(1),plot1(1))
overlay (plot(2),plot1(2))
overlay (plot(3),plot1(3))
overlay (plot(0),plot2(0))
overlay (plot(1),plot2(1))
overlay (plot(2),plot2(2))
overlay (plot(3),plot2(3))

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,1
 do j=0,1
  gsres@gsMarkerSizeF = sizes(i)*.6
  gsres@gsMarkerColor = colors(j)
  gsres@gsMarkerIndex = indexes(i)
  gsres@gsMarkerThicknessF = thicknesses(i)
  gsn_polymarker_ndc (wks,x(i+2*j),y(i+2*j),gsres)
 end do
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.01

gsn_text_ndc (wks,text4,x+.02,y,txres)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "ENSO's SSTA vs Mechanism Strength"
resP@txFontHeightF  = 0.028      ;height of text
resP@gsnPanelBottom = 0.08

gsn_panel(wks,plot,(/2,2/),resP)          ; create panel

end
