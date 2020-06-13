;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude/latitude) of climatology of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-09-26
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------taux
;   var2--------------tauy
;   var3--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_taux_1957-2008.nc"
    in_name2 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_tauy_1957-2008.nc"
    in_name3 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"
    in_name4 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2010


    y1 = (/1969,1972,1982,1997,2006/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002/)
;    y1 = (/1964,1971,2005/)
;    y2 = (/1984,1995/)
;    y3 = 1975
;    y4 = (/1970,1973,1974,1983,1988,1998,1999,2000,2007/)

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
    out_name = "hovmoller_lon_lat_comp_Pacific_tran_ElNino_UV_anom_SODA"

;text
    text1 = (/"a) Transitional EP","b) Non-transitional EP","d) Transitional CP","e) Non-transitional CP",\
              "g) Transitional EP","h) Non-transitional EP","j) Transitional CP","k) Non-transitional CP"/)
    text2 = (/"The western Pacific","The central Pacific","10~S~-2~N~ N m~S~-2"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Composites of TAUX/Y Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in4 = addfile(in_path + in_name4, "r")

    files3 = systemfunc("ls " + in_path + in_name3)
    setfileoption("cdf", "SuppressClose", False)
    in3 = addfiles(files3, "r")
    ListSetType(in3, "join")

    time1 = in1->time
    time4 = in4->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME4 = cd_calendar(time4, 0)
    year1 = toint(TIME1(12:,0))
    month1 = toint(TIME1(12:,1))
    dimX = dimsizes(year1)
    year4 = toint(TIME4(:,0))
    iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)

    year = new(dimX+24, typeof(year1))
    month = new(dimX+24, typeof(month1))
    copy_VarMeta(year1, year(:dimX-1))
    copy_VarMeta(month1, month(:dimX-1))
    year(:dimX-1) = (/year1/)
    month(:dimX-1) = (/month1/)
    year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                    2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
    month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

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

;    taux = in1->taux(iYYYY1,:,:)
;    tauy = in2->tauy(iYYYY1,:,:)
    taux1 = in1->taux(12:,{latN:latS},{lonW1:lonE2})
    tauy2 = in2->tauy(12:,{latN:latS},{lonW1:lonE2})
    TAUX3 = in3[:]->TAUX(:,{latN:latS},{lonW1:lonE2})
    TAUY3 = in3[:]->TAUY(:,{latN:latS},{lonW1:lonE2})
    taux1 = (/100 * taux1/)
    tauy2 = (/100 * tauy2/)
    TAUX3 = (/100 * TAUX3/)
    TAUY3 = (/100 * TAUY3/)
    dimY = dimsizes(taux1)
    taux = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(taux1))
    tauy = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(tauy2))
    copy_VarMeta(taux1, taux(:dimY(0)-1,:,:))
    copy_VarMeta(tauy2, tauy(:dimY(0)-1,:,:))
    taux(:dimY(0)-1,:,:) = (/taux1/)
    tauy(:dimY(0)-1,:,:) = (/tauy2/)
    taux(dimY(0):,:,:) = (/TAUX3/)
    tauy(dimY(0):,:,:) = (/TAUY3/)
    sst = lonFlip(in4->sst(iYYYY4,:,:))

    printVarSummary(taux)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw1 = in1->lat
    gw4 = in4->latitude
    gw1 = cos(rad * gw1)
    gw4 = cos(rad * gw4)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(taux)
    clm2 = clmMonTLL(tauy)
    clm4 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(taux, clm1)
    Anom2 = calcMonAnomTLL(tauy, clm2)
    Anom4 = calcMonAnomTLL(sst, clm4)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom4(:,{latNI:latSI},{lonWI:lonEI}), gw4({latNI:latSI}), 1., 0)
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
/;
;----------------------------------------------------------
   Anom1(:,:,0) = dim_avg_n_Wrap(Anom1(:,:,{lonW:lonE}), 2)
   Anom2(:,:,0) = dim_avg_n_Wrap(Anom2(:,:,{lonW:lonE}), 2)

   var1_p = stdMonLLT(Anom1({lat|latN:latS},lon|0:0,time|iMM1))
   var2_p = stdMonLLT(Anom2({lat|latN:latS},lon|0:0,time|iMM1))
   var3_p = stdMonLLT(Anom1({lat|latN:latS},lon|0:0,time|iMM2))
   var4_p = stdMonLLT(Anom2({lat|latN:latS},lon|0:0,time|iMM2))
   var5_p = stdMonLLT(Anom1({lat|latN:latS},lon|0:0,time|iMM3))
   var6_p = stdMonLLT(Anom2({lat|latN:latS},lon|0:0,time|iMM3))
   var7_p = stdMonLLT(Anom1({lat|latN:latS},lon|0:0,time|iMM4))
   var8_p = stdMonLLT(Anom2({lat|latN:latS},lon|0:0,time|iMM4))

   var1 = var1_p(:,0,:)
   var2 = var2_p(:,0,:)
   var3 = var3_p(:,0,:)
   var4 = var4_p(:,0,:)
   var5 = var5_p(:,0,:)
   var6 = var6_p(:,0,:)
   var7 = var7_p(:,0,:)
   var8 = var8_p(:,0,:)
   var9 = var9_p(:,0,:)
   var10 = var10_p(:,0,:)
   var11 = var11_p(:,0,:)
   var12 = var12_p(:,0,:)
   var13 = var13_p(:,0,:)
   var14 = var14_p(:,0,:)
   var15 = var15_p(:,0,:)
   var16 = var16_p(:,0,:)

;---------------------------------------------------------------
;compute probabilities for means difference
;   prob1 = ttest(ave1y, var1, ny1, ave1y*0, var1*0, yE-yS+1, False, False)
;   prob2 = ttest(ave2y, var2, ny1, ave2y*0, var2*0, yE-yS+1, False, False)
;   prob3 = ttest(ave3y, var3, ny2, ave3y*0, var3*0, yE-yS+1, False, False)
;   prob4 = ttest(ave4y, var4, ny2, ave4y*0, var4*0, yE-yS+1, False, False)
   prob1 = ttest(ave1y, var1, ny1, ave3y, var3, ny2, False, False)
   prob2 = ttest(ave2y, var2, ny1, ave4y, var4, ny2, False, False)
   prob3 = ttest(ave5y, var5, ny3, ave7y, var7, ny4, False, False)
   prob4 = ttest(ave6y, var6, ny3, ave8y, var8, ny4, False, False)
   prob5 = ttest(ave1y, var1, ny1, ave5y, var5, ny3, False, False)
   prob6 = ttest(ave2y, var2, ny1, ave6y, var6, ny3, False, False)
   prob7 = ttest(ave3y, var3, ny2, ave7y, var7, ny4, False, False)
   prob8 = ttest(ave4y, var4, ny2, ave8y, var8, ny4, False, False)
   copy_VarCoords(ave1y, prob1)
   copy_VarCoords(ave2y, prob2)
   copy_VarCoords(ave1y, prob3)
   copy_VarCoords(ave2y, prob4)
   copy_VarCoords(ave1y, prob5)
   copy_VarCoords(ave2y, prob6)
   copy_VarCoords(ave1y, prob7)
   copy_VarCoords(ave2y, prob8)
   printVarSummary(prob1)

   ave1y = (/mask(diff1, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave2y = (/mask(diff2, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave3y = (/mask(diff3, prob3.le.0.1 .or. prob4.le.0.1, True)/)
   ave4y = (/mask(diff4, prob3.le.0.1 .or. prob4.le.0.1, True)/)
   ave5y = (/mask(diff5, prob5.le.0.1 .or. prob6.le.0.1, True)/)
   ave6y = (/mask(diff6, prob5.le.0.1 .or. prob6.le.0.1, True)/)
   ave7y = (/mask(diff7, prob7.le.0.1 .or. prob8.le.0.1, True)/)
   ave8y = (/mask(diff8, prob7.le.0.1 .or. prob8.le.0.1, True)/)
;/
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
res@cnLevels = (/-2.,-1.5,-1.,-.5,.5,1.,1.5,2./)

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
res@gsnRightString = text2(0)
plot1(0) = gsn_csm_hov(wks, ave1x, res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_hov(wks, ave3x, res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave5x, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave7x, res)

;---------------------------------------------------------------
res1@tmXBMode = "Explicit"
res1@tmXBValues = ispan(0,11,3)
res1@tmXBLabels = text3

res1@gsnLeftString = text1(4)
res1@gsnRightString = text2(1)
plot1(4) = gsn_csm_hov(wks, ave1y, res1)

res1@gsnLeftString = text1(5)
res1@gsnRightString = " "
plot1(5) = gsn_csm_hov(wks, ave3y, res1)

res1@gsnLeftString = text1(6)
plot1(6) = gsn_csm_hov(wks, ave5y, res1)

res1@gsnLeftString = text1(7)
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
plot2(1) = gsn_csm_hov(wks, ave3x, res2)
plot2(2) = gsn_csm_hov(wks, ave5x, res2)
plot2(3) = gsn_csm_hov(wks, ave7x, res2)
plot2(4) = gsn_csm_hov(wks, ave1y, res2)
plot2(5) = gsn_csm_hov(wks, ave3y, res2)
plot2(6) = gsn_csm_hov(wks, ave5y, res2)
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
res3@vcRefMagnitudeF = 3.
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.019
res3@vcRefAnnoOrthogonalPosF = 0.05
res3@vcMinDistanceF = 0.04
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector(wks, ave1x, ave2x, res3)
plot3(1) = gsn_csm_vector(wks, ave3x, ave4x, res3)
plot3(2) = gsn_csm_vector(wks, ave5x, ave6x, res3)
plot3(3) = gsn_csm_vector(wks, ave7x, ave8x, res3)
plot3(4) = gsn_csm_vector(wks, ave1y, ave2y, res3)
plot3(5) = gsn_csm_vector(wks, ave3y, ave4y, res3)
plot3(6) = gsn_csm_vector(wks, ave5y, ave6y, res3)
res3@vcRefAnnoOn = True
plot3(7) = gsn_csm_vector(wks, ave7y, ave8y, res3)

do i = 0, 7
    overlay(plot1(i), plot3(i))
end do
/;
;---------------------------------------------------------------
;probability plots
res3 = True
res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "

res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLevels = fspan(0.01, 0.1, 10)
res3@cnInfoLabelOn = False
res3@cnLinesOn = False
res3@cnLineLabelsOn = False
res3@cnFillDotSizeF = 0.004
res3@cnFillScaleF = 2.

do i = 0, 3
    plot3(i*2) = gsn_csm_contour(wks1, prob5(i,:,:), res3)
    plot3(i*2) = ShadeLtContour(plot3(i*2), 0.055, 17)
    plot4(i*2) = gsn_csm_contour(wks2, prob7(i,:,:), res3)
    plot4(i*2) = ShadeLtContour(plot4(i*2), 0.055, 17)
    plot3(i*2+1) = gsn_csm_contour(wks1, prob6(i,:,:), res3)
    plot3(i*2+1) = ShadeLtContour(plot3(i*2+1), 0.055, 17)
    plot4(i*2+1) = gsn_csm_contour(wks2, prob8(i,:,:), res3)
    plot4(i*2+1) = ShadeLtContour(plot4(i*2+1), 0.055, 17)
    overlay(plot1(i*2), plot3(i*2))
    overlay(plot2(i*2), plot4(i*2))
    overlay(plot1(i*2+1), plot3(i*2+1))
    overlay(plot2(i*2+1), plot4(i*2+1))
end do
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.012
resP@pmLabelBarOrthogonalPosF = 0.039
resP@txString = text4
gsn_panel(wks, plot1, (/4,2/), resP)

end
