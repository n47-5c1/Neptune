;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of composite of tropical thermodynamic energy anomalies during El Nino for transisitonal and non-transistional events
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the hovmoller
;
;                       Shan He
;                       2018-11-08
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------temp
;   var2--------------u
;   var3--------------v
;   var4--------------w
;   var5--------------lhtfl
;   var6--------------shtfl
;   var7--------------nlwrs
;   var8--------------nswrs
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_temp_1957-2008.nc"
    in_name2 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_u_1957-2008.nc"
    in_name3 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_v_1957-2008.nc"
    in_name4 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_w_1957-2008.nc"
    in_name5 = "NCEP_NCAR/monthly/hflx/lhtfl.sfc.mon.mean.nc"
    in_name5 = "NCEP_NCAR/monthly/hflx/shtfl.sfc.mon.mean.nc"
    in_name5 = "NCEP_NCAR/monthly/hflx/nlwrs.sfc.mon.mean.nc"
    in_name5 = "NCEP_NCAR/monthly/hflx/nswrs.sfc.mon.mean.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2017

    y1 = (/1969,1972,1982,1997,2006,2015, 1963,1987,1994,2004,2009/);Tran El Nino
    y2 = (/1976,1986, 1958,1965,1968,1977,1979,1991,2002,2014/);Non-tran El Nino
    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)

;region
    latN = 10
    latS = -10
    lonW = 100
    lonE = 300

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "hovmoller_lon_clm_tropic_tran_ElNino_U_anom"

;text
    text1 = (/"a) Tran","b)","c) Non","d)","e) Tran - Non","f)"/)
    text2 = (/"Avg","S - N","m s~S~-1~N~"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Climatology of El Nino U Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_path, "r")
    time = in->time

;get the time indexs
    TIME = cd_calendar(time, 0)
    year_p = toint(TIME(:,0))
    iYYYY = ind(year_p.ge.yS .and. year_p.le.yE)

    month_p = toint(TIME(:,1))
    year = year_p(iYYYY)
    month = month_p(iYYYY)

    E1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
    E2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     E1 = E1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny2 - 1
     E2 = E2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
    end do

    iMM1 =ind(E1)
    iMM2 =ind(E2)

;----------------------------------------------------------
    uwnd = in->uwnd(iYYYY,{latN:latS},{lonW:lonE})

;----------------------------------------------------------
    rad = 4. * atan(1.) / 180.
    gw = in->lat({latN:latS})
    gw = cos(rad * gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm = clmMonTLL(uwnd)
    varClm = stdMonTLL(uwnd)

;Monthly anomalies
    Anom = calcMonAnomTLL(uwnd, clm)

    clm = (/clm((/5,6,7,8,9,10,11,0,1,2,3,4/),:,:)/)
    varClm = (/varClm((/5,6,7,8,9,10,11,0,1,2,3,4/),:,:)/)

;----------------------------------------------------------
   ave1 = clmMonTLL(Anom(iMM1,:,:))
   ave2 = clmMonTLL(Anom(iMM2,:,:))
   var1 = stdMonTLL(Anom(iMM1,:,:))
   var2 = stdMonTLL(Anom(iMM2,:,:))

   ave1x = dim_avg_wgt_n_Wrap(ave1, gw, 1, 1)
   ave2x = dim_avg_wgt_n_Wrap(ave2, gw, 1, 1)
   ave3x = (/dim_avg_wgt_n_Wrap(ave1(:,{0:latS},:), gw({0:latS}), 1, 1) - dim_avg_wgt_n_Wrap(ave1(:,{latN:0},:), gw({latN:0}), 1, 1)/)
   ave4x = (/dim_avg_wgt_n_Wrap(ave2(:,{0:latS},:), gw({0:latS}), 1, 1) - dim_avg_wgt_n_Wrap(ave2(:,{latN:0},:), gw({latN:0}), 1, 1)/)
   copy_VarMeta(ave1x, ave3x)
   copy_VarMeta(ave2x, ave4x)

   diff1 = (/ave1x - ave2x/)
   diff2 = (/ave3x - ave4x/)
   copy_VarMeta(ave1x, diff1)
   copy_VarMeta(ave1x, diff2)
/;
   var1x = dim_avg_wgt_n_Wrap(var1, gw1, 1, 1)
   var2x = dim_avg_wgt_n_Wrap(var2, gw2, 1, 1)
   varClm1x = dim_avg_wgt_n_Wrap(varClm1, gw1, 1, 1)
   varClm2x = dim_avg_wgt_n_Wrap(varClm2, gw2, 1, 1)

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
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(6, graphic)
plot2 = new(6, graphic)
plot3 = new(6, graphic)

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
res@cnLevels = (/-1.2,-.8,-.4,.4,.8,1.2/)

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
plot1(0) = gsn_csm_hov(wks, ave1x, res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_hov(wks, ave3x, res)

res@gsnLeftString = text1(2)
res@gsnCenterString = " "
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave2x, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave4x, res)
res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_hov(wks, diff1, res)
res@gsnLeftString = text1(5)
plot1(5) = gsn_csm_hov(wks, diff2, res)

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
plot2(2) = gsn_csm_hov(wks, ave2x, res2)
plot2(3) = gsn_csm_hov(wks, ave4x, res2)
plot2(4) = gsn_csm_hov(wks, diff1, res2)
plot2(5) = gsn_csm_hov(wks, diff2, res2)

do i = 0, 5
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
res3@vcRefMagnitudeF = 2
res3@vcRefAnnoString2On = False
res3@vcRefAnnoOrthogonalPosF = -0.34
res3@vcMinDistanceF = 0.05
;res@vcVectorDrawOrder = "PostDraw"
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector(wks, ave1x, ave1x*0, res3)
plot3(1) = gsn_csm_vector(wks, ave3x, ave3x*0, res3)
plot3(2) = gsn_csm_vector(wks, ave2x, ave2x*0, res3)
plot3(3) = gsn_csm_vector(wks, ave4x, ave4x*0, res3)
plot3(4) = gsn_csm_vector(wks, diff1, diff1*0, res3)
res3@vcRefAnnoOn = True
plot3(5) = gsn_csm_vector(wks, diff2, diff2*0, res3)

do i = 0, 5
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
resP@txString = text4
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008
gsn_panel(wks, plot1, (/3,2/), resP)

end
