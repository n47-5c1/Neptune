;*************************************************************
;Aim: Draw timeseries of zonal wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2019-11-15
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------uwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_taux_1957-2008.nc"
    in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"

;time
    mS = 8
    mE = 3
    yS = 1958
    yE = 2010
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
    latN2 = 10
    latS2 = -0
    lonW2 = 160
    lonE2 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Case/"
    out_name = "timeseries_case_tran_ElNino_WPW_CPW_anom_SODA"

;text
    text1 = (/"c) EP","f) CP","i) EP","l) CP"/)
    text2 = (/"Zonal stress anomalies","Zero value latitude","10~S~-3~N~ N m~S~-2"/)
    text3 = (/"9(0)","11(0)","1(+1)","3(+1)"/)
    text4 = (/" Transitional"," Non-transitional"/)
    text5 = "Timeseries of TAUX Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")

    files2 = systemfunc("ls " + in_path + in_name2)
    setfileoption("cdf", "SuppressClose", False)
    in2 = addfiles(files2, "r")
    ListSetType(in2, "join")

    lat = in1->lat({latN2:latS2})
    time1 = in1->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    year1 = toint(TIME1(12:,0))
    month1 = toint(TIME1(12:,1))
    dimX = dimsizes(year1)

    year = new(dimX+24, typeof(year1))
    month = new(dimX+24, typeof(month1))
    copy_VarMeta(year1, year(:dimX-1))
    copy_VarMeta(month1, month(:dimX-1))
    year(:dimX-1) = (/year1/)
    month(:dimX-1) = (/month1/)
    year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                    2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
    month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

    iMM1 = ind(year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
    iMM2 = ind(year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
    iMM3 = ind(year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
    iMM4 = ind(year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

;----------------------------------------------------------
    taux1 = in1->taux(12:,{latN1:latS1},{lonW1:lonE2})
    TAUX2 = in2[:]->TAUX(:,{latN1:latS1},{lonW1:lonE2})
    dimY = dimsizes(taux1)
    taux = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(taux1))
    copy_VarMeta(taux1, taux(:dimY(0)-1,:,:))
    taux(:dimY(0)-1,:,:) = (/taux1/)
    taux(dimY(0):,:,:) = (/TAUX2/)
    printVarSummary(taux)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat
    gw1 = cos(rad * gw1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(taux)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(taux, clm1)

;----------------------------------------------------------
   ave1_p = clmMonTLL(Anom1(iMM1,:,:))
   ave2_p = clmMonTLL(Anom1(iMM2,:,:))
   ave3_p = clmMonTLL(Anom1(iMM3,:,:))
   ave4_p = clmMonTLL(Anom1(iMM4,:,:))

   ave1 = wgt_areaave_Wrap(ave1_p(:mE+12-mS,:,{:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave2 = wgt_areaave_Wrap(ave2_p(:mE+12-mS,:,{:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave3 = wgt_areaave_Wrap(ave3_p(:mE+12-mS,:,{:lonE1}), gw1({latN1:latS1}), 1., 0)
   ave4 = wgt_areaave_Wrap(ave4_p(:mE+12-mS,:,{:lonE1}), gw1({latN1:latS1}), 1., 0)

   dim2 = dimsizes(ave1)

   data = new((/4,dim2/), typeof(ave1))
   data(0,:) = (/ave1/)
   data(1,:) = (/ave2/)
   data(2,:) = (/ave3/)
   data(3,:) = (/ave4/)
   data = (/data*1000/)
   copy_VarAtts(ave1, data)

   ave1y = dim_avg_n_Wrap(ave1_p({lat|latN2:latS2},{lon|lonW2:},month|:mE+12-mS), 1)
   ave2y = dim_avg_n_Wrap(ave2_p({lat|latN2:latS2},{lon|lonW2:},month|:mE+12-mS), 1)
   ave3y = dim_avg_n_Wrap(ave3_p({lat|latN2:latS2},{lon|lonW2:},month|:mE+12-mS), 1)
   ave4y = dim_avg_n_Wrap(ave4_p({lat|latN2:latS2},{lon|lonW2:},month|:mE+12-mS), 1)

   nlat = new((/4,dim2/), typeof(ave1))
   copy_VarAtts(lat, nlat(0,:))

   a = where(ave1y.le.0, True, False)
   a(0,:) = True
   b = where(ave2y.le.0, True, False)
   b(0,:) = True
   c = where(ave3y.le.0, True, False)
   c(0,:) = True
   d = where(ave4y.le.0, True, False)
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
res@pmLegendOrthogonalPosF = -0.44

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
res@gsnRightString = text2(2)
res@tiYAxisString = text2(0)
res@trYMaxF = 22.
res@trYMinF = -18.
res@pmLegendDisplayMode = "Always"
res@xyExplicitLabels = (/y1,y2/)
res@xyLineDashSegLenF = 0.79
plot(0) = gsn_csm_xy(wks, x, data(:1,:), res)

res@gsnLeftString = text1(1)
res@gsnRightString = " "
res@pmLegendDisplayMode = "NoCreate"
res@xyExplicitLabels = (/y3,y4/)
res@xyLineDashSegLenF = 0.665
plot(1) = gsn_csm_xy(wks, x, data(2:,:), res)

res@gsnLeftString = text1(2)
res@tiYAxisString = text2(1)
res@trYMaxF = 11.
res@trYMinF = -1.
res@xyExplicitLabels = (/y1,y2/)
res@xyLineDashSegLenF = 0.75
plot(2) = gsn_csm_xy(wks, x, nlat(:1,:), res)

res@gsnLeftString = text1(3)
res@xyExplicitLabels = (/y3,y4/)
;res@xyLineDashSegLenF = 0.77
plot(3) = gsn_csm_xy(wks, x, nlat(2:,:), res)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text5
resP@txFontHeightF = 0.026
gsn_panel(wks, plot, (/4,1/), resP)

end
