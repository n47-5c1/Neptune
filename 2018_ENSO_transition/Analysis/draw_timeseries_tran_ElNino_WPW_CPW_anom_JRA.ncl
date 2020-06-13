;*************************************************************
;Aim: Draw hovmoller diagram (time vs. latitude) of climatology of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2020-05-13
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "JRA55/monthly/surface/uwnd.10m.mon.mean.nc"
    in_name2 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 8
    mE = 3
    yS = 1958
    yE = 2012
    x = ispan(mS, mE+12, 1)


    y1 = (/1969,1972,1982,1997,2006/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;WPW
    latN2 = 10
    latS2 = -10
    lonW2 = 120
    lonE2 = 160

;CPW
    latN3 = 15
    latS3 = -3
    lonW3 = 160
    lonE3 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "timeseries_tran_ElNino_WPW_CPW_anom_JRA"

;text
    text1 = (/"c) EP","f) CP","i) EP","l) CP"/)
    text2 = (/"Zonal wind anomalies","Zero value latitude","m s~S~-1"/)
;    text2 = (/"Zonal stress anomalies","Maximum anomaly latitude","m s~S~-1"/)
    text3 = (/"9(0)","11(0)","1(+1)","3(+1)"/)
    text4 = (/" Transitional"," Non-transitional"/)
    text5 = "Timeseries of Wind Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    lat = in1->lat({latN3:latS3})
    time1 = in1->time
    time2 = in2->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    year1_p = toint(TIME1(:,0))
    year2_p = toint(TIME2(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)
    iYYYY2 = ind(year2_p.ge.yS .and. year2_p.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1_p(iYYYY1)
    month = month_p(iYYYY1)

    E1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
    E2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
    E3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
    E4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)

    do i = 1, ny1 - 1
     E1 = E1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny2 - 1
     E2 = E2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny3 - 1
     E3 = E3 .or. (year.eq.y3(i) .and. month.ge.mS .or. year.eq.y3(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny4 - 1
     E4 = E4 .or. (year.eq.y4(i) .and. month.ge.mS .or. year.eq.y4(i)+1 .and. month.lt.mS)
    end do

    iMM1 = ind(E1)
    iMM2 = ind(E2)
    iMM3 = ind(E3)
    iMM4 = ind(E4)

;----------------------------------------------------------
    uwnd = in1->uwnd(iYYYY1,:,:)
    sst = lonFlip(in2->sst(iYYYY2,:,:))

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat
    gw2 = in2->latitude
    gw1 = cos(rad * gw1)
    gw2 = cos(rad * gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(sst, clm2)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom2(:,{latN1:latS1},{lonW1:lonE1}), gw2({latN1:latS1}), 1., 0)
;    Nino34 = (/-Nino34/)
    dim1 = dimsizes(Nino34)
    Nino34(12::12) = (/(Nino34(11:dim1-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            Nino34(i::12) = (/Nino34(12::12)/)
        else
            Nino34(i:dim1-13:12) = (/Nino34(12::12)/)
        end if
    end do

;Normalize
    Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)

;----------------------------------------------------------
   ave1_p = clmMonTLL(Anom1(iMM1,:,:))
   ave2_p = clmMonTLL(Anom1(iMM2,:,:))
   ave3_p = clmMonTLL(Anom1(iMM3,:,:))
   ave4_p = clmMonTLL(Anom1(iMM4,:,:))

   ave1 = wgt_areaave_Wrap(ave1_p(:mE+12-mS,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave2 = wgt_areaave_Wrap(ave2_p(:mE+12-mS,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave3 = wgt_areaave_Wrap(ave3_p(:mE+12-mS,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave4 = wgt_areaave_Wrap(ave4_p(:mE+12-mS,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)

   dim2 = dimsizes(ave1)

   data = new((/4,dim2/), typeof(ave1))
   data(0,:) = (/ave1/)
   data(1,:) = (/ave2/)
   data(2,:) = (/ave3/)
   data(3,:) = (/ave4/)
   copy_VarAtts(ave1, data)

;----------------------------------------------------------
   ave1y = dim_avg_n_Wrap(ave1_p({lat|latN3:latS3},{lon|lonW3:lonE3},month|:mE+12-mS), 1)
   ave2y = dim_avg_n_Wrap(ave2_p({lat|latN3:latS3},{lon|lonW3:lonE3},month|:mE+12-mS), 1)
   ave3y = dim_avg_n_Wrap(ave3_p({lat|latN3:latS3},{lon|lonW3:lonE3},month|:mE+12-mS), 1)
   ave4y = dim_avg_n_Wrap(ave4_p({lat|latN3:latS3},{lon|lonW3:lonE3},month|:mE+12-mS), 1)

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
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.023
res@gsnYRefLineThicknessF = 2
res@gsnYRefLineDashPattern = 1

;Manually creating a legend
res@pmLegendWidthF = 0.06
res@pmLegendHeightF = 0.07
res@pmLegendSide = "Top"
res@pmLegendParallelPosF = 0.23
res@pmLegendOrthogonalPosF = -1.01

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

res@gsnLeftString = text1(0)
res@tiYAxisString = text2(0)
res@trYMaxF = 1.6
res@trYMinF = -0.6
plot(0) = gsn_csm_xy(wks, x, data(:1,:), res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(2)
plot(1) = gsn_csm_xy(wks, x, data(2:,:), res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
res@tiYAxisString = text2(1)
;res@trYMaxF = 5.
;res@trYMinF = -8.
res@trYMaxF = 11.
res@trYMinF = -1.
plot(2) = gsn_csm_xy(wks, x, nlat(:1,:), res)

res@gsnLeftString = text1(3)
res@pmLegendDisplayMode = "Always"
plot(3) = gsn_csm_xy(wks, x, nlat(2:,:), res)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text5
resP@txFontHeightF = 0.026
gsn_panel(wks, plot, (/4,1/), resP)

end
