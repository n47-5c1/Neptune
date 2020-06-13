;*************************************************************
;Aim: Draw a scatter plot of the western Pacific wind reversal and central Pacific wind shift indexes (normalized by Nino 3.4 index)
;     among transitional and non-transitional EP/CP El Nino
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-11-13
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SST/HadISST/HadISST_sst.nc"
    in_name2 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
;    in_name3 = "~/hes/ENSO/Termination/NCL/EOF_ts_Pac_UV_anom.nc"

;time
    yS = 1958
    yE = 2017
    mS = 8
    mE = 7
    y1 = (/1969,1972,1982,1997,2006,2015/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)
    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)
    season = (/"JFM","AMJ","FMA","MJJ"/)

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;western Pacific
    latN2 = 10
    latS2 = -10
    lonW2 = 120
    lonE2 = 160

;central Pacific
    latN3 = 10
    latS3 = -10
    lonW3 = 160
    lonE3 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "scatter_tran_EP_CP_ElNino_WPwR_CPwS_index"

;text
    text1 = (/"a) WPwR","b) CPwS"/)
    text2 = (/"WP uwnd (m s~S~-1~N~)"/)
    Xtext = (/"Tran EP","Non EP","Tran CP","Non CP"/)

    size = 0.016
    colors = (/"deepskyb"/)

    x = ispan(1, 4, 1)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
;    in3 = addfile(in_name3, "r")

;get the time indexs
    time1 = in1->time
    time2 = in2->time

    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    year1 = toint(TIME1(:,0))
    year2 = toint(TIME2(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
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
    sst = lonFlip(in1->sst(iYYYY1,:,:))
    uwnd = in2->uwnd(iYYYY2,:,:)
;    eof_ts = in3->eof_ts(0,:)
    lat1 = in1->latitude
    lat2 = in2->lat
    lat = in2->lat({latN3:latS3})

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = cos(rad * lat1)
    gw2 = cos(rad * lat2)
    copy_VarCoords(lat1, gw1)
    copy_VarCoords(lat2, gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(sst)
    clm2 = clmMonTLL(uwnd)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(sst, clm1)
    Anom2 = calcMonAnomTLL(uwnd, clm2)

;----------------------------------------------------------
    season1 = month_to_season(Anom1(iMM1,:,:), season(3))
    season2 = month_to_season(Anom1(iMM2,:,:), season(3))
    season3 = month_to_season(Anom1(iMM3,:,:), season(3))
    season4 = month_to_season(Anom1(iMM4,:,:), season(3))
;Nino 3.4 (DJF)
    Nino1 = wgt_areaave_Wrap(season1(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    Nino2 = wgt_areaave_Wrap(season2(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    Nino3 = wgt_areaave_Wrap(season3(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    Nino4 = wgt_areaave_Wrap(season4(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)

    season5 = month_to_seasonN(Anom2(iMM1,:,:), season)
    season6 = month_to_seasonN(Anom2(iMM2,:,:), season)
    season7 = month_to_seasonN(Anom2(iMM3,:,:), season)
    season8 = month_to_seasonN(Anom2(iMM4,:,:), season)

;WPw reversal
    ave1 = wgt_areaave_Wrap(season5(:1,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    ave2 = wgt_areaave_Wrap(season6(:1,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    ave3 = wgt_areaave_Wrap(season7(:1,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    ave4 = wgt_areaave_Wrap(season8(:1,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
;    WPwR1 = (ave1(1,:) - ave1(0,:)) / Nino1
;    WPwR2 = (ave2(1,:) - ave2(0,:)) / Nino2
;    WPwR3 = (ave3(1,:) - ave3(0,:)) / Nino3
;    WPwR4 = (ave4(1,:) - ave4(0,:)) / Nino4
    WPwR1 = ave1(1,:) / Nino1
    WPwR2 = ave2(1,:) / Nino2
    WPwR3 = ave3(1,:) / Nino3
    WPwR4 = ave4(1,:) / Nino4

;CPw shift
    ave5 = wgt_areaave_Wrap(season5(2:,:,{0:latS3},{lonW3:lonE3}), gw2({0:latS3}), 1., 0) - wgt_areaave_Wrap(season5(2:,:,{latN3:0},{lonW3:lonE3}), gw2({latN3:0}), 1., 0)
    ave6 = wgt_areaave_Wrap(season6(2:,:,{0:latS3},{lonW3:lonE3}), gw2({0:latS3}), 1., 0) - wgt_areaave_Wrap(season6(2:,:,{latN3:0},{lonW3:lonE3}), gw2({latN3:0}), 1., 0)
    ave7 = wgt_areaave_Wrap(season7(2:,:,{0:latS3},{lonW3:lonE3}), gw2({0:latS3}), 1., 0) - wgt_areaave_Wrap(season7(2:,:,{latN3:0},{lonW3:lonE3}), gw2({latN3:0}), 1., 0)
    ave8 = wgt_areaave_Wrap(season8(2:,:,{0:latS3},{lonW3:lonE3}), gw2({0:latS3}), 1., 0) - wgt_areaave_Wrap(season8(2:,:,{latN3:0},{lonW3:lonE3}), gw2({latN3:0}), 1., 0)
;    WPwR1 = (ave1(1,:) - ave1(0,:)) / Nino1
;    WPwR2 = (ave2(1,:) - ave2(0,:)) / Nino2
;    WPwR3 = (ave3(1,:) - ave3(0,:)) / Nino3
;    WPwR4 = (ave4(1,:) - ave4(0,:)) / Nino4
    CPwS1 = ave5(1,:) / Nino1
    CPwS2 = ave6(1,:) / Nino2
    CPwS3 = ave7(1,:) / Nino3
    CPwS4 = ave8(1,:) / Nino4
/;

   ave1y = dim_avg_n_Wrap(season5(2:,:,{latN3:latS3},{lonW3:lonE3}), 3)
   ave2y = dim_avg_n_Wrap(season6(2:,:,{latN3:latS3},{lonW3:lonE3}), 3)
   ave3y = dim_avg_n_Wrap(season7(2:,:,{latN3:latS3},{lonW3:lonE3}), 3)
   ave4y = dim_avg_n_Wrap(season8(2:,:,{latN3:latS3},{lonW3:lonE3}), 3)

   CPwS1 = new((/ny1/), float)
   CPwS2 = new((/ny2/), float)
   CPwS3 = new((/ny3/), float)
   CPwS4 = new((/ny4/), float)

   a1 = where(ave1y.le.0, True, False)
   a1(:,:,0) = True
   a2 = where(ave2y.le.0, True, False)
   a2(:,:,0) = True
   a3 = where(ave3y.le.0, True, False)
   a3(:,:,0) = True
   a4 = where(ave4y.le.0, True, False)
   a4(:,:,0) = True

   do i = 0, ny1-1
        b = maxind(ave1y(1,i,:))
        CPwS1(i) = (/lat(b)/)
;       CPwS1(i) = (/min(lat(ind(a1(1,i,:)))) - min(lat(ind(a1(0,i,:))))/)
;       CPwS1(i) = (/min(lat(ind(a1(1,i,:))))/)
   end do
   do i = 0, ny2-1
        b = maxind(ave2y(1,i,:))
        CPwS2(i) = (/lat(b)/)
;       CPwS2(i) = (/min(lat(ind(a2(1,i,:)))) - min(lat(ind(a2(0,i,:))))/)
;       CPwS2(i) = (/min(lat(ind(a2(1,i,:))))/)
   end do
   do i = 0, ny3-1
        b = maxind(ave3y(1,i,:))
        CPwS3(i) = (/lat(b)/)
;       CPwS3(i) = (/min(lat(ind(a3(1,i,:)))) - min(lat(ind(a3(0,i,:))))/)
;       CPwS3(i) = (/min(lat(ind(a3(1,i,:))))/)
   end do
   do i = 0, ny4-1
        b = maxind(ave4y(1,i,:))
        CPwS4(i) = (/lat(b)/)
;       CPwS4(i) = (/min(lat(ind(a4(1,i,:)))) - min(lat(ind(a4(0,i,:))))/)
;       CPwS4(i) = (/min(lat(ind(a4(1,i,:))))/)
   end do

    CPwS1 = eof_ts(iMM1(5::12) / 12) / Nino1
    CPwS2 = eof_ts(iMM2(5::12) / 12) / Nino2
    CPwS3 = eof_ts(iMM3(5::12) / 12) / Nino3
    CPwS4 = eof_ts(iMM4(5::12) / 12) / Nino4
;/
    yval = new((/8,5/),"float",-999.)
    yval(0,0) = min(WPwR1)
    yval(0,1) = avg(WPwR1) - stddev(WPwR1)
    yval(0,2) = avg(WPwR1)
    yval(0,3) = avg(WPwR1) + stddev(WPwR1)
    yval(0,4) = max(WPwR1)
    yval(2,0) = min(WPwR3)
    yval(2,1) = avg(WPwR3) - stddev(WPwR3)
    yval(2,2) = avg(WPwR3)
    yval(2,3) = avg(WPwR3) + stddev(WPwR3)
    yval(2,4) = max(WPwR3)
    yval(3,0) = min(WPwR4)
    yval(3,1) = avg(WPwR4) - stddev(WPwR4)
    yval(3,2) = avg(WPwR4)
    yval(3,3) = avg(WPwR4) + stddev(WPwR4)
    yval(3,4) = max(WPwR4)
    yval(4,0) = min(CPwS1)
    yval(4,1) = avg(CPwS1) - stddev(CPwS1)
    yval(4,2) = avg(CPwS1)
    yval(4,3) = avg(CPwS1) + stddev(CPwS1)
    yval(4,4) = max(CPwS1)
    yval(6,0) = min(CPwS3)
    yval(6,1) = avg(CPwS3) - stddev(CPwS3)
    yval(6,2) = avg(CPwS3)
    yval(6,3) = avg(CPwS3) + stddev(CPwS3)
    yval(6,4) = max(CPwS3)
    yval(7,0) = min(CPwS4)
    yval(7,1) = avg(CPwS4) - stddev(CPwS4)
    yval(7,2) = avg(CPwS4)
    yval(7,3) = avg(CPwS4) + stddev(CPwS4)
    yval(7,4) = max(CPwS4)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(2, graphic)
plot1 = new(4, graphic)
plot2 = new(4, graphic)

;*******************************************
; plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiXAxisFontHeightF = .023

res@tmXBLabels = Xtext
res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023

res@trXMaxF = 5.
res@trXMinF = 0.

;res@tiXAxisString = text1(0)
;res@tiYAxisString = text1(1)

;res@vpWidthF = 1.
;res@vpHeightF = 0.4

res@xyMarkLineMode = "markers"
res@xyMarker = 16
res@xyMarkerColor = "Black"
;res@xyMarkerColor = (/0,0,0,.2/)

res@gsnLeftString = text1(0)
res@trYMaxF = 1.5
res@trYMinF = -1.5

plot(0) = boxplot(wks, x, yval(:3,:), False, res, False)
plot1(0) = gsn_csm_xy (wks, conform(WPwR1, 1, 0), WPwR1, res)
overlay(plot(0), plot1(0))
delete(res@gsnLeftString)
plot1(1) = gsn_csm_xy (wks, conform(WPwR2, 2, 0), WPwR2, res)
overlay(plot(0), plot1(1))
plot1(2) = gsn_csm_xy (wks, conform(WPwR3, 3, 0), WPwR3, res)
overlay(plot(0), plot1(2))
plot1(3) = gsn_csm_xy (wks, conform(WPwR4, 4, 0), WPwR4, res)
overlay(plot(0), plot1(3))

res@gsnLeftString = text1(1)
;res@trYMaxF = 1.5
;res@trYMinF = -1.
res@trYMaxF = 2.5
res@trYMinF = -1.
;res@tiYAxisString = text2(4)
plot(1) = boxplot(wks, x, yval(4:,:), False, res, False)
plot2(0) = gsn_csm_xy (wks, conform(CPwS1, 1, 0), CPwS1, res)
overlay(plot(1), plot2(0))
delete(res@gsnLeftString)
plot2(1) = gsn_csm_xy (wks, conform(CPwS2, 2, 0), CPwS2, res)
overlay(plot(1), plot2(1))
plot2(2) = gsn_csm_xy (wks, conform(CPwS3, 3, 0), CPwS3, res)
overlay(plot(1), plot2(2))
plot2(3) = gsn_csm_xy (wks, conform(CPwS4, 4, 0), CPwS4, res)
overlay(plot(1), plot2(3))

;*******************************************
;create panel resources
;*******************************************
resP = True
;resP@txString = text4
gsn_panel(wks, plot, (/2,1/), resP)

end
