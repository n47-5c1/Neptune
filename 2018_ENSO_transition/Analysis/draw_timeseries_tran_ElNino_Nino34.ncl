;*************************************************************
;Aim: Draw time series of the monthly Nino 3.4 index during EP- and CP-ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the time series
;                       Shan He
;                       2019-12-29
;
;*************************************************************

begin

;================================================
;Variables List:
;   var--------------uwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 4
    mE = 3
    yS = 1958
    yE = 2017
    x = ispan(mS, mE+12, 1)


    y1 = (/1969,1972,1982,1997,2006,2015/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "timeseries_tran_ElNino_Nino34"

;text
    text1 = (/"SST","CP El Nino","~F35~J~F~C"/)
    text2 = (/"5(0)","8(0)","11(0)","2(+1)"/)
;    text3 = (/" Transitional EP"," Non-transitional EP"," Transitional CP"," Non-transitional CP"/)
    text3 = (/" Transitional"," Non-transitional"/)
    text4 = "Timeseries of NINO3.4 Index"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    time1 = in1->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    year1_p = toint(TIME1(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)

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
    sst = lonFlip(in1->sst(iYYYY1,:,:))

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->latitude
    gw1 = cos(rad * gw1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(sst, clm1)

;Nino 3.4 (DJF)
    Anom1(:,0,0) = wgt_areaave_Wrap(Anom1(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    N34 = wgt_areaave_Wrap(Anom1(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    dim1 = dimsizes(N34)
    N34(12::12) = (/(N34(11:dim1-13:12) + N34(12::12) + N34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            N34(i::12) = (/N34(12::12)/)
        else
            N34(i:dim1-13:12) = (/N34(12::12)/)
        end if
    end do

;Normalize
    Anom1(:,0,0) = (/Anom1(:,0,0) / N34/)

;----------------------------------------------------------
   ave1_p = clmMonTLL(Anom1(iMM1,0:0,0:0))
   ave2_p = clmMonTLL(Anom1(iMM2,0:0,0:0))
   ave3_p = clmMonTLL(Anom1(iMM3,0:0,0:0))
   ave4_p = clmMonTLL(Anom1(iMM4,0:0,0:0))
   ave1 = ave1_p(:mE+12-mS,0,0)
   ave2 = ave2_p(:mE+12-mS,0,0)
   ave3 = ave3_p(:mE+12-mS,0,0)
   ave4 = ave4_p(:mE+12-mS,0,0)

   dim2 = dimsizes(ave1)
   data = new((/4,dim2/), typeof(ave1))
   data(0,:) = (/ave1/)
   data(1,:) = (/ave2/)
   data(2,:) = (/ave3/)
   data(3,:) = (/ave4/)
   copy_VarMeta(ave1, data(0,:))

; ==============================================================
; Mission 3. Draw the time series
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

res = True

;res@gsnDraw = False
;res@gsnFrame = False
res@gsnYRefLine = .0
res@gsnLeftString = text1(1)
res@gsnCenterString = " "
res@gsnRightString = text1(2)
res@gsnStringFontHeightF = 0.023
res@gsnYRefLineThicknessF = 2
res@gsnYRefLineDashPattern = 5

;Manually creating a legend
res@pmLegendWidthF = 0.06
res@pmLegendHeightF = 0.06
res@pmLegendSide = "Top"
res@pmLegendDisplayMode = "Always"
res@pmLegendParallelPosF = 0.81
res@pmLegendOrthogonalPosF = -1.13

res@lgPerimOn = False
res@lgLabelFontHeightF = 0.016

;res@trYMaxF = 2.
res@trYMaxF = 1.4
;res@trYMinF = -0.6
res@trYMinF = -0.2

res@tiMainString = text4
res@tiMainFontHeightF = 0.028
res@tiYAxisString = text1(0)
res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(5,mE+12,3)
res@tmXBLabels = text2
res@tmXBLabelFontHeightF = 0.021
res@tmYLLabelFontHeightF = 0.021

res@vpHeightF = 0.3
res@vpWidthF = 0.7

;res@xyLineColors = (/"red","red","blue","blue"/)
res@xyDashPatterns = (/0,16,0,16/)
res@xyLineThicknessF = 4.
res@xyExplicitLegendLabels = text3

plot = gsn_csm_xy(wks, x, data(2:3,:), res)

end
