;*************************************************************
;Aim: Draw hovmoller diagram (time vs. latitude) of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2019-11-13
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var1--------------vwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2017


    y1 = 1972
    y2 = 1986
    y3 = 1987
;    y4 = 1965
    y4 = 1991

;region
    latN = 10
    latS = -10
;WP
    lonW1 = 120
    lonE1 = 160
;CP
    lonW2 = 160
    lonE2 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Case/"
    out_name = "hovmoller_lat_case_Pacific_tran_ElNino_UV_anom"

;text
    text1 = (/"a) Transitional EP, "+y1,"b) Non-transitional EP, "+y2,"d) Transitional CP, "+y3,"e) Non-transitional CP, "+y4,\
              "g) Transitional EP, "+y1,"h) Non-transitional EP, "+y2,"j) Transitional CP, "+y3,"k) Non-transitional CP, "+y4/)
    text2 = (/"The western Pacific","The central Pacific","m s~S~-1"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Wind Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
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
    vwnd = in2->vwnd(iYYYY1,:,:)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)

;----------------------------------------------------------
   ave1 = clmMonTLL(Anom1(iMM1,:,:))
   ave2 = clmMonTLL(Anom2(iMM1,:,:))
   ave3 = clmMonTLL(Anom1(iMM2,:,:))
   ave4 = clmMonTLL(Anom2(iMM2,:,:))
   ave5 = clmMonTLL(Anom1(iMM3,:,:))
   ave6 = clmMonTLL(Anom2(iMM3,:,:))
   ave7 = clmMonTLL(Anom1(iMM4,:,:))
   ave8 = clmMonTLL(Anom2(iMM4,:,:))

   ave1y1 = dim_avg_n_Wrap(ave1({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave2y1 = dim_avg_n_Wrap(ave2({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave3y1 = dim_avg_n_Wrap(ave3({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave4y1 = dim_avg_n_Wrap(ave4({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave5y1 = dim_avg_n_Wrap(ave5({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave6y1 = dim_avg_n_Wrap(ave6({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave7y1 = dim_avg_n_Wrap(ave7({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)
   ave8y1 = dim_avg_n_Wrap(ave8({lat|latN:latS},{lon|lonW1:lonE1},month|:), 1)

   ave1y2 = dim_avg_n_Wrap(ave1({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave2y2 = dim_avg_n_Wrap(ave2({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave3y2 = dim_avg_n_Wrap(ave3({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave4y2 = dim_avg_n_Wrap(ave4({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave5y2 = dim_avg_n_Wrap(ave5({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave6y2 = dim_avg_n_Wrap(ave6({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave7y2 = dim_avg_n_Wrap(ave7({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)
   ave8y2 = dim_avg_n_Wrap(ave8({lat|latN:latS},{lon|lonW2:lonE2},month|:), 1)

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
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-2.,-1.5,-1.,-.5,.5,1.,1.5,2./)

res@lbLabelBarOn = False

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0,11,3)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@vpWidthF = 1.
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
res@gsnRightString = text2(0)
plot1(0) = gsn_csm_hov(wks, ave1y1, res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_hov(wks, ave3y1, res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave5y1, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave7y1, res)

res@gsnLeftString = text1(4)
res@gsnRightString = text2(1)
plot1(4) = gsn_csm_hov(wks, ave1y2, res)

res@gsnLeftString = text1(5)
res@gsnRightString = " "
plot1(5) = gsn_csm_hov(wks, ave3y2, res)

res@gsnLeftString = text1(6)
plot1(6) = gsn_csm_hov(wks, ave5y2, res)

res@gsnLeftString = text1(7)
plot1(7) = gsn_csm_hov(wks, ave7y2, res)

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

plot2(0) = gsn_csm_hov(wks, ave1y1, res2)
plot2(1) = gsn_csm_hov(wks, ave3y1, res2)
plot2(2) = gsn_csm_hov(wks, ave5y1, res2)
plot2(3) = gsn_csm_hov(wks, ave7y1, res2)
plot2(4) = gsn_csm_hov(wks, ave1y2, res2)
plot2(5) = gsn_csm_hov(wks, ave3y2, res2)
plot2(6) = gsn_csm_hov(wks, ave5y2, res2)
plot2(7) = gsn_csm_hov(wks, ave7y2, res2)

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
res3@vcRefMagnitudeF = 3.
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.018
res3@vcRefAnnoOrthogonalPosF = 0.05
res3@vcMinDistanceF = 0.03
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector(wks, ave1y1, ave2y1, res3)
plot3(1) = gsn_csm_vector(wks, ave3y1, ave4y1, res3)
plot3(2) = gsn_csm_vector(wks, ave5y1, ave6y1, res3)
plot3(3) = gsn_csm_vector(wks, ave7y1, ave8y1, res3)
plot3(4) = gsn_csm_vector(wks, ave1y2, ave2y2, res3)
plot3(5) = gsn_csm_vector(wks, ave3y2, ave4y2, res3)
plot3(6) = gsn_csm_vector(wks, ave5y2, ave6y2, res3)
res3@vcRefAnnoOn = True
plot3(7) = gsn_csm_vector(wks, ave7y2, ave8y2, res3)

do i = 0, 7
    overlay(plot1(i), plot3(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.012
resP@pmLabelBarOrthogonalPosF = 0.038
resP@txString = text4
gsn_panel(wks, plot1, (/4,2/), resP)
print("Done!")

end
