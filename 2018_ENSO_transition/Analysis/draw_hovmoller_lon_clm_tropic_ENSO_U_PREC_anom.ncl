;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of climatology of tropical surface zonal wind and precipitation rate anomalies during ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-08-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var1--------------u
;   var3--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_DOE/monthly/uwnd.10m.mon.mean.nc"
    in_name2 = "ERA-interim/monthly/uwnd.mon.mean.nc"
    in_name3 = "CMAP/precip.mon.mean.std.nc"
    in_name4 = "GPCP/precip.mon.mean.nc"

;time
    mS = 9
    mE = 8
    yS = 1979
    yE = 2016
    yEl1 = (/1982,1997,2006,2015/)
    yEl2 = 1986
    yEl3 = (/1987,1994,2004,2009/)
    yEl4 = (/1979,1991,2002,2014/)
    yLa1 = 2005
    yLa2 = (/1984,1995/)
    yLa3 = 2008
    yLa4 = (/1983,1988,1998,1999,2000,2007,2010,2011/)
    ny1 = dimsizes(yEl1)
    ny2 = dimsizes(yEl2)
    ny3 = dimsizes(yEl3)
    ny4 = dimsizes(yEl4)
    ny5 = dimsizes(yLa1)
    ny6 = dimsizes(yLa2)
    ny7 = dimsizes(yLa3)
    ny8 = dimsizes(yLa4)

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = (/"hovmoller_lon_clm_tropic_ElNino_U_PREC_anom","hovmoller_lon_clm_tropic_LaNina_U_PREC_anom"/)

;text
    text1 = (/"a) Tran EP","b)","c) Non EP","d)","e) Tran CP","f)","g) Non CP","h)"/)
    text2 = (/"NCEP-DOE, CMAP","ERA-Interim, GPCP","m s~S~-1~N~, mm day~S~-1"/)
    text3 = (/"9(0)","12(0)","3(+1)","6(+1)"/)
    text4 = (/"Hovmoller of Climatology of El Nino U & PREC Anomalies","Hovmoller of Climatology of La Nina U & PREC Anomalies"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    in4 = addfile(in_path + in_name4, "r")
    time1 = in1->time
    time2 = in2->time
    time3 = in3->time
    time4 = in4->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    TIME3 = cd_calendar(time3, 0)
    TIME4 = cd_calendar(time4, 0)
    year1 = toint(TIME1(:,0))
    year2 = toint(TIME2(:,0))
    year3 = toint(TIME3(:,0))
    year4 = toint(TIME4(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
    iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    El1 = (year.eq.yEl1(0) .and. month.ge.mS .or. year.eq.yEl1(0)+1 .and. month.lt.mS)
    El2 = (year.eq.yEl2(0) .and. month.ge.mS .or. year.eq.yEl2(0)+1 .and. month.lt.mS)
    El3 = (year.eq.yEl3(0) .and. month.ge.mS .or. year.eq.yEl3(0)+1 .and. month.lt.mS)
    El4 = (year.eq.yEl4(0) .and. month.ge.mS .or. year.eq.yEl4(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     El1 = El1 .or. (year.eq.yEl1(i) .and. month.ge.mS .or. year.eq.yEl1(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny2 - 1
     El2 = El2 .or. (year.eq.yEl2(i) .and. month.ge.mS .or. year.eq.yEl2(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny3 - 1
     El3 = El3 .or. (year.eq.yEl3(i) .and. month.ge.mS .or. year.eq.yEl3(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny4 - 1
     El4 = El4 .or. (year.eq.yEl4(i) .and. month.ge.mS .or. year.eq.yEl4(i)+1 .and. month.lt.mS)
    end do

    La1 = (year.eq.yLa1(0) .and. month.ge.mS .or. year.eq.yLa1(0)+1 .and. month.lt.mS)
    La2 = (year.eq.yLa2(0) .and. month.ge.mS .or. year.eq.yLa2(0)+1 .and. month.lt.mS)
    La3 = (year.eq.yLa3(0) .and. month.ge.mS .or. year.eq.yLa3(0)+1 .and. month.lt.mS)
    La4 = (year.eq.yLa4(0) .and. month.ge.mS .or. year.eq.yLa4(0)+1 .and. month.lt.mS)
    do i = 1, ny5 - 1
     La1 = La1 .or. (year.eq.yLa1(i) .and. month.ge.mS .or. year.eq.yLa1(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny6 - 1
     La2 = La2 .or. (year.eq.yLa2(i) .and. month.ge.mS .or. year.eq.yLa2(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny7 - 1
     La3 = La3 .or. (year.eq.yLa3(i) .and. month.ge.mS .or. year.eq.yLa3(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny8 - 1
     La4 = La4 .or. (year.eq.yLa4(i) .and. month.ge.mS .or. year.eq.yLa4(i)+1 .and. month.lt.mS)
    end do

;----------------------------------------------------------

    uwnd = short2flt(in1->uwnd(iYYYY1,0,{latN:latS},{lonW:lonE}))
    u = short2flt(in2->u(iYYYY2,36,{latN:latS},{lonW:lonE}))
    precip1 = in3->precip(iYYYY3,{latN:latS},{lonW:lonE})
    precip2 = in4->precip(iYYYY4,{latN:latS},{lonW:lonE})

;----------------------------------------------------------
    rad = 4.*atan(1.)/180.
    gw1 = in1->lat({latN:latS})
    gw2 = in2->latitude({latN:latS})
    gw3 = in3->lat({latN:latS})
    gw4 = in4->lat({latN:latS})
    gw1 = cos(rad * gw1)
    gw2 = cos(rad * gw2)
    gw3 = cos(rad * gw3)
    gw4 = cos(rad * gw4)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(u)
    clm3 = clmMonTLL(precip1)
    clm4 = clmMonTLL(precip2)

    varClm1 = stdMonTLL(uwnd)
    varClm2 = stdMonTLL(u)
    varClm3 = stdMonTLL(precip1)
    varClm4 = stdMonTLL(precip2)

    print("Climatology")

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(u, clm2)
    Anom3 = calcMonAnomTLL(precip1, clm3)
    Anom4 = calcMonAnomTLL(precip2, clm4)

    clm1 = (/clm1((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    clm2 = (/clm2((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    clm3 = (/clm3((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    clm4 = (/clm4((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)

    varClm1 = (/varClm1((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    varClm2 = (/varClm2((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    varClm3 = (/varClm3((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)
    varClm4 = (/varClm4((/8,9,10,11,0,1,2,3,4,5,6,7/),:,:)/)

do j = 0, 1
;----------------------------------------------------------
    if(j.eq.0)then
        iMM1 = ind(El1)
        iMM2 = ind(El2)
        iMM3 = ind(El3)
        iMM4 = ind(El4)
    else
        iMM1 = ind(La1)
        iMM2 = ind(La2)
        iMM3 = ind(La3)
        iMM4 = ind(La4)
    end if
   ave1 = clmMonTLL(Anom1(iMM1,:,:))
   ave2 = clmMonTLL(Anom2(iMM1,:,:))
   ave3 = clmMonTLL(Anom3(iMM1,:,:))
   ave4 = clmMonTLL(Anom4(iMM1,:,:))
   ave5 = clmMonTLL(Anom1(iMM2,:,:))
   ave6 = clmMonTLL(Anom2(iMM2,:,:))
   ave7 = clmMonTLL(Anom3(iMM2,:,:))
   ave8 = clmMonTLL(Anom4(iMM2,:,:))
   ave9 = clmMonTLL(Anom1(iMM3,:,:))
   ave10 = clmMonTLL(Anom2(iMM3,:,:))
   ave11 = clmMonTLL(Anom3(iMM3,:,:))
   ave12 = clmMonTLL(Anom4(iMM3,:,:))
   ave13 = clmMonTLL(Anom1(iMM4,:,:))
   ave14 = clmMonTLL(Anom2(iMM4,:,:))
   ave15 = clmMonTLL(Anom3(iMM4,:,:))
   ave16 = clmMonTLL(Anom4(iMM4,:,:))

   var1 = stdMonTLL(Anom1(iMM1,:,:))
   var2 = stdMonTLL(Anom2(iMM1,:,:))
   var3 = stdMonTLL(Anom3(iMM1,:,:))
   var4 = stdMonTLL(Anom4(iMM1,:,:))

   ave1x = dim_avg_wgt_n_Wrap(ave1, gw1, 1, 1)
   ave2x = dim_avg_wgt_n_Wrap(ave2, gw2, 1, 1)
   ave3x = dim_avg_wgt_n_Wrap(ave3, gw3, 1, 1)
   ave4x = dim_avg_wgt_n_Wrap(ave4, gw4, 1, 1)
   ave5x = dim_avg_wgt_n_Wrap(ave5, gw1, 1, 1)
   ave6x = dim_avg_wgt_n_Wrap(ave6, gw2, 1, 1)
   ave7x = dim_avg_wgt_n_Wrap(ave7, gw3, 1, 1)
   ave8x = dim_avg_wgt_n_Wrap(ave8, gw4, 1, 1)
   ave9x = dim_avg_wgt_n_Wrap(ave9, gw1, 1, 1)
   ave10x = dim_avg_wgt_n_Wrap(ave10, gw2, 1, 1)
   ave11x = dim_avg_wgt_n_Wrap(ave11, gw3, 1, 1)
   ave12x = dim_avg_wgt_n_Wrap(ave12, gw4, 1, 1)
   ave13x = dim_avg_wgt_n_Wrap(ave13, gw1, 1, 1)
   ave14x = dim_avg_wgt_n_Wrap(ave14, gw2, 1, 1)
   ave15x = dim_avg_wgt_n_Wrap(ave15, gw3, 1, 1)
   ave16x = dim_avg_wgt_n_Wrap(ave16, gw4, 1, 1)

   var1x = dim_avg_wgt_n_Wrap(var1, gw1, 1, 1)
   var2x = dim_avg_wgt_n_Wrap(var2, gw2, 1, 1)
   var3x = dim_avg_wgt_n_Wrap(var3, gw3, 1, 1)
   var4x = dim_avg_wgt_n_Wrap(var4, gw4, 1, 1)

   varClm1x = dim_avg_wgt_n_Wrap(varClm1, gw1, 1, 1)
   varClm2x = dim_avg_wgt_n_Wrap(varClm2, gw2, 1, 1)
   varClm3x = dim_avg_wgt_n_Wrap(varClm3, gw3, 1, 1)
   varClm4x = dim_avg_wgt_n_Wrap(varClm4, gw4, 1, 1)
/;
;---------------------------------------------------------------
;compute probabilities for means difference
   prob1 = ttest(ave1x, var1x, ny1, ave1x*0, varClm1x, yE-yS+1, False, False)
   prob2 = ttest(ave2x, var2x, ny1, ave2x*0, varClm2x, yE-yS+1, False, False)
   prob5 = ttest(ave5x, var5x, ny1, ave5x*0, varClm1x, yE-yS+1, False, False)
   prob6 = ttest(ave6x, var6x, ny1, ave6x*0, varClm2x, yE-yS+1, False, False)
   copy_VarCoords(ave1x, prob1)
   copy_VarCoords(ave2x, prob2)
   copy_VarCoords(ave5x, prob5)
   copy_VarCoords(ave6x, prob6)
   printVarSummary(prob1)

   z1 = ave1x
   z2 = ave2x
   z5 = ave5x
   z6 = ave6x

   ave1x = (/mask(ave1x, prob1.le.0.05, True)/)
   ave2x = (/mask(ave2x, prob2.le.0.05, True)/)
   ave5x = (/mask(ave5x, prob5.le.0.05, True)/)
   ave6x = (/mask(ave6x, prob6.le.0.05, True)/)
;/
; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
if(j.eq.0)then
    wks = gsn_open_wks("svg", out_path + out_name(0))
else
    wks = gsn_open_wks("svg", out_path + out_name(1))
end if
plot1 = new(8, graphic)
plot2 = new(8, graphic)
plot3 = new(8, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_RdYlBu"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-6.,-4.,-2.,2.,4.,6./)

res@lbLabelBarOn = False

res@tmYLMode = "Explicit"
res@tmYLValues = ispan(0,11,3)
res@tmYLLabels = text3
;res@tmYLMinorOn = False
;res@tmYRMinorOn = False
;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@vpWidthF = 1.
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString = " "
plot1(0) = gsn_csm_hov(wks, ave3x, res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_hov(wks, ave4x, res)

res@gsnLeftString = text1(2)
res@gsnCenterString = " "
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave7x, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave8x, res)
res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_hov(wks, ave11x, res)
res@gsnLeftString = text1(5)
plot1(5) = gsn_csm_hov(wks, ave12x, res)
res@gsnLeftString = text1(6)
plot1(6) = gsn_csm_hov(wks, ave15x, res)
res@gsnLeftString = text1(7)
plot1(7) = gsn_csm_hov(wks, ave16x, res)

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
plot2(1) = gsn_csm_hov(wks, ave2x, res2)
plot2(2) = gsn_csm_hov(wks, ave5x, res2)
plot2(3) = gsn_csm_hov(wks, ave6x, res2)
plot2(4) = gsn_csm_hov(wks, ave9x, res2)
plot2(5) = gsn_csm_hov(wks, ave10x, res2)
plot2(6) = gsn_csm_hov(wks, ave13x, res2)
plot2(7) = gsn_csm_hov(wks, ave14x, res2)

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
res3@vcRefMagnitudeF = 5
res3@vcRefAnnoString2On = False
res3@vcRefAnnoOrthogonalPosF = -0.34
res3@vcMinDistanceF = 0.05
;res@vcVectorDrawOrder = "PostDraw"
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector(wks, ave1x, ave1x*0, res3)
plot3(1) = gsn_csm_vector(wks, ave2x, ave2x*0, res3)
plot3(2) = gsn_csm_vector(wks, ave5x, ave5x*0, res3)
plot3(3) = gsn_csm_vector(wks, ave6x, ave6x*0, res3)
plot3(4) = gsn_csm_vector(wks, ave9x, ave9x*0, res3)
plot3(5) = gsn_csm_vector(wks, ave10x, ave10x*0, res3)
plot3(6) = gsn_csm_vector(wks, ave13x, ave13x*0, res3)
res3@vcRefAnnoOn = True
plot3(7) = gsn_csm_vector(wks, ave14x, ave6x*0, res3)
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
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008

if(j.eq.0)then
    resP@txString = text4(0)
    gsn_panel(wks, plot1, (/4,2/), resP)
else
    resP@txString = text4(1)
    gsn_panel(wks, plot1, (/4,2/), resP)
end if

delete([/iMM1,iMM2,iMM3,iMM4,plot1,plot2,plot3/])

end do

end
