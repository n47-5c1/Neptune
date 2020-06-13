;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude/latitude) of climatology of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2020-05-13
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var3--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "JRA55/monthly/surface/uwnd.10m.mon.mean.nc"
    in_name2 = "JRA55/monthly/surface/vwnd.10m.mon.mean.nc"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2012


    y1 = (/1969,1972,1982,1997,2006/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)

;region
    latN = 10
    latS = -10
;WP
    lonW1 = 120
    lonE1 = 160
;CP
    lonW2 = 160
    lonE2 = 240

;Nino 3.4
    latNI = 5
    latSI = -5
    lonWI = 190
    lonEI = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "hovmoller_lon_lat_comp_Pacific_tran_ElNino_UV_anom_JRA"

;text
    text1 = (/"a) Transitional EP","b) Non-transitional EP","d) Transitional CP","e) Non-transitional CP",\
              "g) Transitional EP","h) Non-transitional EP","j) Transitional CP","k) Non-transitional CP"/)
    text2 = (/"The Western Pacific","The Central Pacific","m s~S~-1"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Composites of Wind Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    time1 = in1->time
    time3 = in3->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    year1_p = toint(TIME1(:,0))
    year3_p = toint(TIME3(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)
    iYYYY3 = ind(year3_p.ge.yS .and. year3_p.le.yE)

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
    vwnd = in2->vwnd(iYYYY1,:,:)
    sst = lonFlip(in3->sst(iYYYY3,:,:))

    printVarSummary(uwnd)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw1 = in1->lat
    gw3 = in3->latitude
    gw1 = cos(rad * gw1)
    gw3 = cos(rad * gw3)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)
    Anom3 = calcMonAnomTLL(sst, clm3)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
    Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom3(:,{latNI:latSI},{lonWI:lonEI}), gw3({latNI:latSI}), 1., 0)
;    Nino34 = (/-Nino34/)
    dim = dimsizes(Nino34)
    Nino34(12::12) =  (/(Nino34(11:dim-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            Nino34(i::12) = (/Nino34(12::12)/)
        else
            Nino34(i:dim-13:12) = (/Nino34(12::12)/)
        end if
    end do

;Normalize
    Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)
    Anom2 = (/Anom2 / conform(Anom2, Nino34, 0)/)

;----------------------------------------------------------
   ave1 = clmMonTLL(Anom1(iMM1,:,:))
   ave2 = clmMonTLL(Anom2(iMM1,:,:))
   ave3 = clmMonTLL(Anom1(iMM2,:,:))
   ave4 = clmMonTLL(Anom2(iMM2,:,:))
   ave5 = clmMonTLL(Anom1(iMM3,:,:))
   ave6 = clmMonTLL(Anom2(iMM3,:,:))
   ave7 = clmMonTLL(Anom1(iMM4,:,:))
   ave8 = clmMonTLL(Anom2(iMM4,:,:))

   ave1x = dim_avg_wgt_n_Wrap(ave1(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave2x = dim_avg_wgt_n_Wrap(ave2(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave3x = dim_avg_wgt_n_Wrap(ave3(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave4x = dim_avg_wgt_n_Wrap(ave4(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave5x = dim_avg_wgt_n_Wrap(ave5(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave6x = dim_avg_wgt_n_Wrap(ave6(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave7x = dim_avg_wgt_n_Wrap(ave7(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)
   ave8x = dim_avg_wgt_n_Wrap(ave8(:,{latN:latS},{lonW1:lonE1}), gw1({latN:latS}), 1, 1)

   ave1y = dim_avg_n_Wrap(ave1({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave2y = dim_avg_n_Wrap(ave2({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave3y = dim_avg_n_Wrap(ave3({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave4y = dim_avg_n_Wrap(ave4({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave5y = dim_avg_n_Wrap(ave5({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave6y = dim_avg_n_Wrap(ave6({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave7y = dim_avg_n_Wrap(ave7({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave8y = dim_avg_n_Wrap(ave8({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(8, graphic)
plot2 = new(8, graphic)
plot3 = new(8, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.03

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-1.6,-1.2,-.8,-.4,.4,.8,1.2,1.6/)
;res@cnLevels = (/-2.,-1.5,-1.,-.5,.5,1.,1.5,2./)

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.028
res@tmYLLabelFontHeightF = 0.028

res@vpWidthF = 1.
res@vpHeightF = 0.4

res1 = res

;---------------------------------------------------------------
res@tmYLMode = "Explicit"
res@tmYLValues = ispan(0,11,3)
res@tmYLLabels = text3
res@tmXBTickSpacingF = 10.
res@tiYAxisOn = False
res@tiXAxisString = " "

res@gsnLeftString = text1(0)
plot1(0) = gsn_csm_hov(wks, ave1x, res)

res@gsnLeftString = text1(1)
plot1(2) = gsn_csm_hov(wks, ave3x, res)

res@gsnLeftString = text1(2)
plot1(1) = gsn_csm_hov(wks, ave5x, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave7x, res)

;---------------------------------------------------------------
res1@tmXBMode = "Explicit"
res1@tmXBValues = ispan(0,11,3)
res1@tmXBLabels = text3

res1@gsnLeftString = text1(4)
plot1(4) = gsn_csm_hov(wks, ave1y, res1)

res1@gsnLeftString = text1(5)
plot1(6) = gsn_csm_hov(wks, ave3y, res1)

res1@gsnLeftString = text1(6)
res1@gsnRightString = text2(2)
plot1(5) = gsn_csm_hov(wks, ave5y, res1)

res1@gsnLeftString = text1(7)
res1@gsnRightString = " "
plot1(7) = gsn_csm_hov(wks, ave7y, res1)

;---------------------------------------------------------------

res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 2

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0/)
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False

plot2(0) = gsn_csm_hov(wks, ave1x, res2)
plot2(2) = gsn_csm_hov(wks, ave3x, res2)
plot2(1) = gsn_csm_hov(wks, ave5x, res2)
plot2(3) = gsn_csm_hov(wks, ave7x, res2)
plot2(4) = gsn_csm_hov(wks, ave1y, res2)
plot2(6) = gsn_csm_hov(wks, ave3y, res2)
plot2(5) = gsn_csm_hov(wks, ave5y, res2)
plot2(7) = gsn_csm_hov(wks, ave7y, res2)

do i = 0, 7
    overlay(plot1(i), plot2(i))
end do

;---------------------------------------------------------------
res3 = True

res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "

res3@vcRefAnnoOn = False
res3@vcRefLengthF = 0.07
res3@vcRefMagnitudeF = 2.5
;res3@vcRefMagnitudeF = 3.
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.019
res3@vcRefAnnoOrthogonalPosF = 0.05
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

res3@vcMinDistanceF = 0.04
plot3(0) = gsn_csm_vector(wks, ave1x, ave2x, res3)
plot3(2) = gsn_csm_vector(wks, ave3x, ave4x, res3)
plot3(1) = gsn_csm_vector(wks, ave5x, ave6x, res3)
plot3(3) = gsn_csm_vector(wks, ave7x, ave8x, res3)
res3@vcMinDistanceF = 0.038
plot3(4) = gsn_csm_vector(wks, ave1y, ave2y, res3)
plot3(6) = gsn_csm_vector(wks, ave3y, ave4y, res3)
plot3(5) = gsn_csm_vector(wks, ave5y, ave6y, res3)
res3@vcRefAnnoOn = True
plot3(7) = gsn_csm_vector(wks, ave7y, ave8y, res3)

do i = 0, 7
    overlay(plot1(i), plot3(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnFrame = False

resP@txString = text2(0)
resP@gsnPanelTop = 1.
resP@gsnPanelBottom = 0.516
gsn_panel(wks, plot1(:3), (/2,2/), resP)

resP@txString = text2(1)
resP@gsnPanelTop = 0.476
resP@gsnPanelBottom = 0.0
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.012
resP@pmLabelBarOrthogonalPosF = 0.009
gsn_panel(wks, plot1(4:), (/2,2/), resP)

frame(wks)

end
