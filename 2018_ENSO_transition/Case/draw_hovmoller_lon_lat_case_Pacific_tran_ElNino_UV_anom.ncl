;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude/latitude) of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2019-11-13
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------taux
;   var2--------------tauy
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.sfc.mon.mean.nc"
    in_name2 = "vwnd.sfc.mon.mean.nc"

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
    out_name = "hovmoller_lon_lat_case_Pacific_tran_ElNino_UV_anom"

;text
    text1 = (/"a) Transitional EP, "+y1,"b) Non-transitional EP, "+y2,"d) Transitional CP, "+y3,"e) Non-transitional CP, "+y4,\
              "g) Transitional EP, "+y1,"h) Non-transitional EP, "+y2,"j) Transitional CP, "+y3,"k) Non-transitional CP, "+y4/)
    text2 = (/"The Western Pacific","The Central Pacific","m s~S~-1"/)
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
    uwnd = in1->uwnd(iYYYY1,{latN:latS},:)
    vwnd = in2->vwnd(iYYYY1,{latN:latS},:)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw = in1->lat({latN:latS})
    gw = cos(rad * gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

;----------------------------------------------------------
   ave1 = clmMonTLL(Anom1(iMM1,:,:))
   ave2 = clmMonTLL(Anom2(iMM1,:,:))
   ave3 = clmMonTLL(Anom1(iMM2,:,:))
   ave4 = clmMonTLL(Anom2(iMM2,:,:))
   ave5 = clmMonTLL(Anom1(iMM3,:,:))
   ave6 = clmMonTLL(Anom2(iMM3,:,:))
   ave7 = clmMonTLL(Anom1(iMM4,:,:))
   ave8 = clmMonTLL(Anom2(iMM4,:,:))

   ave1x = dim_avg_wgt_n_Wrap(ave1(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave2x = dim_avg_wgt_n_Wrap(ave2(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave3x = dim_avg_wgt_n_Wrap(ave3(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave4x = dim_avg_wgt_n_Wrap(ave4(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave5x = dim_avg_wgt_n_Wrap(ave5(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave6x = dim_avg_wgt_n_Wrap(ave6(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave7x = dim_avg_wgt_n_Wrap(ave7(:,:,{lonW1:lonE1}), gw, 1, 1)
   ave8x = dim_avg_wgt_n_Wrap(ave8(:,:,{lonW1:lonE1}), gw, 1, 1)

   ave1y = dim_avg_n_Wrap(ave1(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave2y = dim_avg_n_Wrap(ave2(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave3y = dim_avg_n_Wrap(ave3(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave4y = dim_avg_n_Wrap(ave4(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave5y = dim_avg_n_Wrap(ave5(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave6y = dim_avg_n_Wrap(ave6(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave7y = dim_avg_n_Wrap(ave7(lat|:,{lon|lonW2:lonE2},month|:), 1)
   ave8y = dim_avg_n_Wrap(ave8(lat|:,{lon|lonW2:lonE2},month|:), 1)

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
res@gsnStringFontHeightF = 0.03

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-2.,-1.5,-1.,-0.5,0.5,1.,1.5,2./)

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
;res@gsnRightString = text2(0)
res@gsnRightString = " "
plot1(0) = gsn_csm_hov(wks, ave1x, res)

res@gsnLeftString = text1(1)
;res@gsnRightString = text2(2)
plot1(2) = gsn_csm_hov(wks, ave3x, res)

res@gsnLeftString = text1(2)
;res@gsnRightString = " "
plot1(1) = gsn_csm_hov(wks, ave5x, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave7x, res)

;---------------------------------------------------------------
res1@tmXBMode = "Explicit"
res1@tmXBValues = ispan(0,11,3)
res1@tmXBLabels = text3

res1@gsnLeftString = text1(4)
;res1@gsnRightString = text2(1)
plot1(4) = gsn_csm_hov(wks, ave1y, res1)

res1@gsnLeftString = text1(5)
;res1@gsnRightString = " "
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
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.019
res3@vcRefAnnoOrthogonalPosF = 0.05
res3@vcMinDistanceF = 0.04
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector(wks, ave1x, ave2x, res3)
plot3(2) = gsn_csm_vector(wks, ave3x, ave4x, res3)
plot3(1) = gsn_csm_vector(wks, ave5x, ave6x, res3)
plot3(3) = gsn_csm_vector(wks, ave7x, ave8x, res3)
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
;resP@gsnPanelBottom = 0.06
;resP@txString = text4

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
