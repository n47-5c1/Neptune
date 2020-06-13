;*************************************************************
;Aim: Draw timeseries of zonal wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2020-05-14
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------uwnd
;================================================

;data
    in_name1 = "~/data/observation/NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"

;time
    mS = 8
    mE = 3
    yS = 1958
    yE = 2017
    x = ispan(mS, mE+12, 1)


    y1 = 1972
    y2 = 1986
    y3 = 1987
    y4 = 1991

;WPW
    latN1 = 10
    latS1 = -10
    lonW1 = 120
    lonE1 = 160

;CPW
;    latN2 = 6
;    latS2 = -10
    latN2 = 13
    latS2 = -3
    lonW2 = 160
    lonE2 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Case/"
    out_name = "timeseries_case_tran_ElNino_WPW_CPW_anom"

;text
    text1 = (/"c) EP","f) CP","i) EP","l) CP"/)
;    text2 = (/"Zonal wind anomalies","Maximum anomaly latitude","m s~S~-1"/)
    text2 = (/"Zonal wind anomalies","Zero value latitude","m s~S~-1"/)
    text3 = (/"9(0)","11(0)","1(+1)","3(+1)"/)
    text4 = (/" Transitional"," Non-transitional"/)
    text5 = "Timeseries of Wind Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_name1, "r")
    lat = in1->lat({latN2:latS2})
    time1 = in1->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    year1_p = toint(TIME1(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1_p(iYYYY1)
    month = month_p(iYYYY1)

    iMM1 = ind(year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
    iMM2 = ind(year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
    iMM3 = ind(year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
    iMM4 = ind(year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

;----------------------------------------------------------
    uwnd = in1->uwnd(iYYYY1,:,:)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat
    gw1 = cos(rad * gw1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(uwnd)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)

;----------------------------------------------------------
   ave1_p = clmMonTLL(Anom1(iMM1,:,:))
   ave2_p = clmMonTLL(Anom1(iMM2,:,:))
   ave3_p = clmMonTLL(Anom1(iMM3,:,:))
   ave4_p = clmMonTLL(Anom1(iMM4,:,:))

   ave1 = wgt_areaave_Wrap(ave1_p(:mE+12-mS,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave2 = wgt_areaave_Wrap(ave2_p(:mE+12-mS,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave3 = wgt_areaave_Wrap(ave3_p(:mE+12-mS,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave4 = wgt_areaave_Wrap(ave4_p(:mE+12-mS,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)

   dim2 = dimsizes(ave1)
   data = new((/4,dim2/), typeof(ave1))
   data(0,:) = (/ave1/)
   data(1,:) = (/ave2/)
   data(2,:) = (/ave3/)
   data(3,:) = (/ave4/)
   copy_VarAtts(ave1, data)

;----------------------------------------------------------
   ave1y = dim_avg_n_Wrap(ave1_p({lat|latN2:latS2},{lon|lonW2:lonE2},month|:mE+12-mS), 1)
   ave2y = dim_avg_n_Wrap(ave2_p({lat|latN2:latS2},{lon|lonW2:lonE2},month|:mE+12-mS), 1)
   ave3y = dim_avg_n_Wrap(ave3_p({lat|latN2:latS2},{lon|lonW2:lonE2},month|:mE+12-mS), 1)
   ave4y = dim_avg_n_Wrap(ave4_p({lat|latN2:latS2},{lon|lonW2:lonE2},month|:mE+12-mS), 1)

   nlat = new((/4,dim2/), typeof(ave1))
   copy_VarAtts(lat, nlat(0,:))
/;
   nlat(0,:) = (/lat(dim_maxind(ave1y,0))/)
   nlat(1,:) = (/lat(dim_maxind(ave2y,0))/)
   nlat(2,:) = (/lat(dim_maxind(ave3y,0))/)
   nlat(3,:) = (/lat(dim_maxind(ave4y,0))/)
;/
   a = where(ave1y.lt.0., True, False)
   a(0,:) = True
   b = where(ave2y.lt.0., True, False)
   b(0,:) = True
   c = where(ave3y.lt.0., True, False)
   c(0,:) = True
   d = where(ave4y.lt.0., True, False)
   d(0,:) = True

   do i = 0, dim2-1
       nlat(0,i) = (/min(lat(ind(a(:,i))))/)
       nlat(1,i) = (/min(lat(ind(b(:,i))))/)
       nlat(2,i) = (/min(lat(ind(c(:,i))))/)
       nlat(3,i) = (/min(lat(ind(d(:,i))))/)
   end do

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(4, graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnYRefLine = .0
res@gsnStringFontHeightF = 0.023
res@gsnYRefLineThicknessF = 2
res@gsnYRefLineDashPattern = 1

;Manually creating a legend
res@pmLegendWidthF = 0.06
res@pmLegendHeightF = 0.07
res@pmLegendSide = "Top"
res@pmLegendParallelPosF = 0.19
res@pmLegendOrthogonalPosF = -1.02

res@lgPerimOn = False
res@lgLabelFontHeightF = 0.019

res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(9,15,2)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.021
res@tmYLLabelFontHeightF = 0.021

res@vpHeightF = 0.3
res@vpWidthF = 0.75

res@xyLineColors = (/"red","black"/)
;res@xyLineColors = (/"red4","orange","blue4","deepskyblue"/)
res@xyDashPattern = 0
res@xyLineThicknessF = 4.
res@xyExplicitLegendLabels = text4
res@xyLabelMode = "Custom"
res@xyLineLabelFontColors = res@xyLineColors
res@xyLineLabelFontHeightF = res@lgLabelFontHeightF

res@gsnLeftString = text1(0)
res@gsnRightString = " "
res@tiYAxisString = text2(0)
res@trYMaxF = 1.6
res@trYMinF = -1.1
;res@pmLegendDisplayMode = "NoCreate"
res@xyExplicitLabels = (/y1,y2/)
res@xyLineDashSegLenF = 0.57
plot(0) = gsn_csm_xy(wks, x, data(:1,:), res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(2)
res@xyExplicitLabels = (/y3,y4/)
res@xyLineDashSegLenF = 0.61
plot(1) = gsn_csm_xy(wks, x, data(2:,:), res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
res@tiYAxisString = text2(1)
res@trYMaxF = 11.
res@trYMinF = -1.
res@xyExplicitLabels = (/y1,y2/)
res@xyLineDashSegLenF = 0.47
plot(2) = gsn_csm_xy(wks, x, nlat(:1,:), res)

res@gsnLeftString = text1(3)
res@pmLegendDisplayMode = "Always"
res@xyExplicitLabels = (/y3,y4/)
res@xyLineDashSegLenF = 0.485
plot(3) = gsn_csm_xy(wks, x, nlat(2:,:), res)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text5
resP@txFontHeightF = 0.026
gsn_panel(wks, plot, (/4,1/), resP)

end
