;*************************************************************
;Aim: Draw climatology of tropical surface wind, sea surface temperature, and precipitation anomalies during ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-08-02
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
;   var2--------------vwnd
;   var3--------------u
;   var4--------------v
;   var5--------------sst
;   var6--------------precip
;================================================

;data
    in_path = "~/data/observation/"
;    in_name1 = "NCEP_DOE/monthly/uwnd.mon.mean.nc"
;    in_name2 = "NCEP_DOE/monthly/vwnd.mon.mean.nc"
    in_name1 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.surf.mon.mean.nc"
    in_name3 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
    in_name4 = "NCEP_NCAR/monthly/vwnd.surf.mon.mean.nc"
;    in_name1 = "NCEP_DOE/monthly/uwnd.10m.mon.mean.nc"
;    in_name2 = "NCEP_DOE/monthly/vwnd.10m.mon.mean.nc"
;    in_name3 = "ERA-interim/monthly/uwnd.mon.mean.nc"
;    in_name4 = "ERA-interim/monthly/vwnd.mon.mean.nc"
;    in_name5 = "SST/NOAA_ERSST/sst.mnmean.v5.nc"
    in_name5 = "SST/HadISST/HadISST_sst.nc"
    in_name6 = "SST/HadISST/HadISST_sst.nc"
;    in_name7 = "CMAP/precip.mon.mean.std.nc"
;    in_name8 = "GPCP/precip.mon.mean.nc"
    in_name7 = "NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
    in_name8 = "NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"

;time
    mS = 6
    mE = 5
;    yS = 1979
;    yE = 2016
    yS = 1958
    yE = 2017
;    yEl = (/1969,1972,1976,1982,1986,1997,2006,2015/)
    yEl = (/1958,1963,1965,1968,1977,1979,1987,1991,1994,2002,2004,2009,2014/)
;    yEl = (/1994/)
;    yLa = (/1964,1971,1984,1995,2005/)
    yLa = (/1970,1973,1974,1975,1983,1988,1998,1999,2000,2007,2008,2010,2011,2016/)
;    yLa = (/1964,2005,2008/)

;    yEl = (/1982,1997,2006,2015/)
;    yEl = 1986
;    yEl = (/1987,1994,2004,2009/)
;    yEl = (/1979,1991,2002,2014/)
;    yLa = 2005
;    yLa = (/1984,1995/)
;    yLa = 2008
;    yLa = (/1983,1988,1998,1999,2000,2007,2010,2011,2016/)
    ny1 = dimsizes(yEl)
    ny2 = dimsizes(yLa)
    season = (/"JFM","AMJ","JAS","OND"/)
    seasonClm = (/"JJA","SON","DJF","MAM"/)

;region
    latN = 30
    latS = -30
    lonL = 120
    lonR = 290

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name1 = "clm_tropic_ElNino_UV_SST_anom"
    out_name2 = "clm_tropic_LaNina_UV_SST_anom"
    out_name3 = "clm_tropic_ElNino_UV_PREC_anom"
    out_name4 = "clm_tropic_LaNina_UV_PREC_anom"

;text
    text1 = (/"a) JJA(0)","b)","c) SON(0)","d)","e) DJF(0)","f)","g) MAM(+1)","h)"/)
;    text2 = (/"NCEP-DOE, ERSST","ERA-Interim, HadISST","m s~S~-1~N~, ~F35~J~F~C"/)
    text2 = (/"EP","CP","m s~S~-1~N~, ~F35~J~F~C"/)
    text3 = (/"NCEP-DOE, CMAP","ERA-Interim, GPCP","m s~S~-1~N~, mm day~S~-1"/)
    text4 = "UA, VA, & SSTA during El Nino"
    text5 = "UA, VA, & SSTA during La Nina"
;    text4 = "Climatology of UV & SST Anomalies during El Nino"
;    text5 = "Climatology of UV & SST Anomalies during La Nina"
    text6 = "Climatology of UV & PREC Anomalies during El Nino"
    text7 = "Climatology of UV & PREC Anomalies during La Nina"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    in4 = addfile(in_path + in_name4, "r")
    in5 = addfile(in_path + in_name5, "r")
    in6 = addfile(in_path + in_name6, "r")
    in7 = addfile(in_path + in_name7, "r")
    in8 = addfile(in_path + in_name8, "r")
    time1 = in1->time
    time3 = in3->time
    time5 = in5->time
    time6 = in6->time
    time7 = in7->time
    time8 = in8->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    TIME5 = cd_calendar(time5, 0)
    TIME6 = cd_calendar(time6, 0)
    TIME7 = cd_calendar(time7, 0)
    TIME8 = cd_calendar(time8, 0)
    year1 = toint(TIME1(:,0))
    year3 = toint(TIME3(:,0))
    year5 = toint(TIME5(:,0))
    year6 = toint(TIME6(:,0))
    year7 = toint(TIME7(:,0))
    year8 = toint(TIME8(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
    iYYYY5 = ind(year5.ge.yS .and. year5.le.yE)
    iYYYY6 = ind(year6.ge.yS .and. year6.le.yE)
    iYYYY7 = ind(year7.ge.yS .and. year7.le.yE)
    iYYYY8 = ind(year8.ge.yS .and. year8.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    El = (year.eq.yEl(0) .and. month.ge.mS .or. year.eq.yEl(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     El = El .or. (year.eq.yEl(i) .and. month.ge.mS .or. year.eq.yEl(i)+1 .and. month.lt.mS)
    end do

    La = (year.eq.yLa(0) .and. month.ge.mS .or. year.eq.yLa(0)+1 .and. month.lt.mS)
    do i = 1, ny2 - 1
     La = La .or. (year.eq.yLa(i) .and. month.ge.mS .or. year.eq.yLa(i)+1 .and. month.lt.mS)
    end do

;----------------------------------------------------------

    uwnd = in1->uwnd(iYYYY1,:,:)
    vwnd = in2->vwnd(iYYYY1,:,:)
    u = in3->uwnd(iYYYY1,:,:)
    v = in4->vwnd(iYYYY1,:,:)
;    uwnd = short2flt(in1->uwnd(iYYYY1,0,:,:))
;    vwnd = short2flt(in2->vwnd(iYYYY1,0,:,:))
;    u = short2flt(in3->u(iYYYY3,36,:,:))
;    v = short2flt(in4->v(iYYYY3,36,:,:))
    sst1 = in5->sst(iYYYY5,:,:)
    sst2 = in6->sst(iYYYY6,:,:)
;    precip1 = in7->precip(iYYYY7,:,:)
;    precip2 = in8->precip(iYYYY8,:,:)
    precip1 = in7->prate(iYYYY7,:,:)
    precip2 = in8->prate(iYYYY8,:,:)
    precip1 = (/precip1 * 60 * 60 * 24/)
    precip2 = (/precip2 * 60 * 60 * 24/)
    printVarSummary (uwnd)
    printVarSummary (u)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(u)
    clm4 = clmMonTLL(v)
    clm5 = clmMonTLL(sst1)
    clm6 = clmMonTLL(sst2)
    clm7 = clmMonTLL(precip1)
    clm8 = clmMonTLL(precip2)

    varClm1 = dim_variance_n_Wrap(month_to_seasonN(uwnd, seasonClm), 1)
    varClm2 = dim_variance_n_Wrap(month_to_seasonN(vwnd, seasonClm), 1)
    varClm3 = dim_variance_n_Wrap(month_to_seasonN(u, seasonClm), 1)
    varClm4 = dim_variance_n_Wrap(month_to_seasonN(v, seasonClm), 1)
    varClm5 = dim_variance_n_Wrap(month_to_seasonN(sst1, seasonClm), 1)
    varClm6 = dim_variance_n_Wrap(month_to_seasonN(sst2, seasonClm), 1)
    varClm7 = dim_variance_n_Wrap(month_to_seasonN(precip1, seasonClm), 1)
    varClm8 = dim_variance_n_Wrap(month_to_seasonN(precip2, seasonClm), 1)

    print("Climatology")

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)
    Anom3 = calcMonAnomTLL(u, clm3)
    Anom4 = calcMonAnomTLL(v, clm4)
    Anom5 = calcMonAnomTLL(sst1, clm5)
    Anom6 = calcMonAnomTLL(sst2, clm6)
    Anom7 = calcMonAnomTLL(precip1, clm7)
    Anom8 = calcMonAnomTLL(precip2, clm8)

   do j = 0, 1
;----------------------------------------------------------
   if(j.eq.0)then
    iMM = ind(El)
   else
    delete(iMM)
    iMM = ind(La)
   end if
   season1 = month_to_seasonN(Anom1(iMM,:,:), season)
   season2 = month_to_seasonN(Anom2(iMM,:,:), season)
   season3 = month_to_seasonN(Anom3(iMM,:,:), season)
   season4 = month_to_seasonN(Anom4(iMM,:,:), season)
   season5 = month_to_seasonN(Anom5(iMM,:,:), season)
   season6 = month_to_seasonN(Anom6(iMM,:,:), season)
   season7 = month_to_seasonN(Anom7(iMM,:,:), season)
   season8 = month_to_seasonN(Anom8(iMM,:,:), season)
   print("season")

   ave1 = dim_avg_n_Wrap(season1, 1)
   ave2 = dim_avg_n_Wrap(season2, 1)
   ave3 = dim_avg_n_Wrap(season3, 1)
   ave4 = dim_avg_n_Wrap(season4, 1)
   ave5 = dim_avg_n_Wrap(season5, 1)
   ave6 = dim_avg_n_Wrap(season6, 1)
   ave7 = dim_avg_n_Wrap(season7, 1)
   ave8 = dim_avg_n_Wrap(season8, 1)
   var1 = dim_variance_n_Wrap(season1, 1)
   var2 = dim_variance_n_Wrap(season2, 1)
   var3 = dim_variance_n_Wrap(season3, 1)
   var4 = dim_variance_n_Wrap(season4, 1)
   var5 = dim_variance_n_Wrap(season5, 1)
   var6 = dim_variance_n_Wrap(season6, 1)
   var7 = dim_variance_n_Wrap(season7, 1)
   var8 = dim_variance_n_Wrap(season8, 1)

   delete([/season1,season2,season3,season4,season5,season6,season7,season8/])
/;
;---------------------------------------------------------------
;compute probabilities for means difference
   prob1 = ttest(ave1, var1, ny1, ave1*0, varClm1, yE-yS+1, False, False)
   prob2 = ttest(ave2, var2, ny1, ave2*0, varClm2, yE-yS+1, False, False)
   prob3 = ttest(ave3, var3, ny2, ave3*0, varClm3, yE-yS+1, False, False)
   prob4 = ttest(ave4, var4, ny2, ave4*0, varClm4, yE-yS+1, False, False)
   prob5 = ttest(ave5, var5, ny1, ave5*0, varClm5, yE-yS+1, False, False)
   prob6 = ttest(ave6, var6, ny1, ave6*0, varClm6, yE-yS+1, False, False)
   prob7 = ttest(ave7, var7, ny2, ave7*0, varClm7, yE-yS+1, False, False)
   prob8 = ttest(ave8, var8, ny2, ave8*0, varClm8, yE-yS+1, False, False)

   copy_VarCoords(ave1, prob1)
   copy_VarCoords(ave2, prob2)
   copy_VarCoords(ave3, prob3)
   copy_VarCoords(ave4, prob4)
   copy_VarCoords(ave5, prob5)
   copy_VarCoords(ave6, prob6)
   copy_VarCoords(ave7, prob7)
   copy_VarCoords(ave8, prob8)

   ave5 = where(prob5.le.0.05, ave5, 0.)
   ave6 = where(prob6.le.0.05, ave6, 0.)
   ave7 = where(prob7.le.0.05, ave7, 0.)
   ave8 = where(prob8.le.0.05, ave8, 0.)
   ave1 = (/mask(ave1, prob1.le.0.05 .or. prob2.le.0.05, True)/)
   ave2 = (/mask(ave2, prob1.le.0.05 .or. prob2.le.0.05, True)/)
   ave3 = (/mask(ave3, prob3.le.0.05 .or. prob4.le.0.05, True)/)
   ave4 = (/mask(ave4, prob3.le.0.05 .or. prob4.le.0.05, True)/)
;/

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

if(j.eq.0)then
    wks1 = gsn_open_wks("svg", out_path + out_name1)
    wks2 = gsn_open_wks("svg", out_path + out_name3)
else
    wks1 = gsn_open_wks("svg", out_path + out_name2)
    wks2 = gsn_open_wks("svg", out_path + out_name4)
end if
plot1 = new(8, graphic)
plot2 = new(8, graphic)
plot3 = new(8, graphic)
plot4 = new(8, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = " "
res@gsnScalarContour = True       ;contours desired
;res@gsnSpreadColorEnd = 127
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-.8,-.4,-.2,.2,.4,.8/)

res@lbLabelBarOn = False

res@vcGlyphStyle = "CurlyVector"
res@vcRefAnnoOn = False
res@vcRefLengthF = 0.07
res@vcRefMagnitudeF = 5
res@vcRefAnnoOrthogonalPosF = -0.27
res@vcMinDistanceF = 0.035
;res@vcFillArrowsOn = True
;res@vcFillArrowHeadMinFracXF = 0.33
;res@vcFillArrowHeadMinFracYF = 0.33
;res@vcVectorDrawOrder = "PostDraw"
res@vcLineArrowThicknessF = 1.6
res@vcLineArrowHeadMaxSizeF = 0.018
res@vcLineArrowHeadMinSizeF = 0.009
/;
res@stArrowLengthF = 0.015
res@stMinArrowSpacingF = 0.08
res@stLineThicknessF = 1.1
res@stMinDistanceF = 0.07
res@stMinLineSpacingF = 0.004
;/
res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

do i = 0, 3
    res@gsnLeftString = text1(i*2)
    if(i.eq.0)then
        res@gsnCenterString = text2(0)
        res@gsnRightString = " "
    end if
    plot1(i*2) = gsn_csm_vector_scalar_map_ce(wks1, ave1(i,:,:), ave2(i,:,:), ave5(i,:,:), res)
;    plot1(i*2) = gsn_csm_streamline_contour_map_ce(wks1, ave1(i,:,:), ave2(i,:,:), ave5(i,:,:), res)
    res@gsnLeftString = text1(i*2+1)
    if(i.eq.0)then
        res@gsnCenterString = text2(1)
        res@gsnRightString = text2(2)
    end if
    if(i.eq.3)then
        res@vcRefAnnoOn = True
    end if
    plot1(i*2+1) = gsn_csm_vector_scalar_map_ce(wks1, ave3(i,:,:), ave4(i,:,:), ave6(i,:,:), res)
;    plot1(i*2+1) = gsn_csm_streamline_contour_map_ce(wks1, ave3(i,:,:), ave4(i,:,:), ave6(i,:,:), res)
    res@gsnCenterString = " "
    res@gsnRightString = " "
end do

;---------------------------------------------------------------
;plot contours
;res@cnLevels = (/-4.,-2.,-1.,1.,2.,4./)
res@cnLevels = (/-2.,-1.,-.5,.5,1.,2./)
;res@cnFillPalette = "MPL_RdBu"
res@cnFillPalette = "MPL_RdYlBu"
res@vcRefAnnoOn = False
res@mpFillOn = False
res@mpGeophysicalLineColor = "gray40"

do i = 0, 3
    res@gsnLeftString = text1(i*2)
    if(i.eq.0)then
        res@gsnCenterString = text3(0)
        res@gsnRightString = " "
    end if
    plot2(i*2) = gsn_csm_vector_scalar_map_ce(wks2, ave1(i,:,:), ave2(i,:,:), ave7(i,:,:), res)
;    plot2(i*2) = gsn_csm_streamline_contour_map_ce(wks2, ave1(i,:,:), ave2(i,:,:), ave7(i,:,:), res)
    res@gsnLeftString = text1(i*2+1)
    if(i.eq.0)then
        res@gsnCenterString = text3(1)
        res@gsnRightString = text3(2)
    end if
    if(i.eq.3)then
        res@vcRefAnnoOn = True
    end if
    plot2(i*2+1) = gsn_csm_vector_scalar_map_ce(wks2, ave3(i,:,:), ave4(i,:,:), ave8(i,:,:), res)
;    plot2(i*2+1) = gsn_csm_streamline_contour_map_ce(wks2, ave3(i,:,:), ave4(i,:,:), ave8(i,:,:), res)
    res@gsnCenterString = " "
    res@gsnRightString = " "
end do
/;
;---------------------------------------------------------------
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 0
res2@gsnContourNegLineDashPattern = 1
res2@gsnContourLineThicknessesScale = 1.4

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = ispan(-2, 2, 1)
res2@cnLineColor = "grey25"
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False
;res2@cnInfoLabelFontHeightF = 0.014
res2@cnInfoLabelOrthogonalPosF = 0.25

do i = 0, 3
    plot3(i*2) = gsn_csm_contour(wks1, ave1M(i,:,:), res2)
    plot4(i*2) = gsn_csm_contour(wks2, ave1M(i,:,:), res2)
    if(i .eq. 3)then
        res2@cnInfoLabelOn = True
    end if
    plot3(i*2+1) = gsn_csm_contour(wks1, ave3M(i,:,:), res2)
    plot4(i*2+1) = gsn_csm_contour(wks2, ave3M(i,:,:), res2)
    overlay(plot1(i*2), plot3(i*2))
    overlay(plot2(i*2), plot4(i*2))
    overlay(plot1(i*2+1), plot3(i*2+1))
    overlay(plot2(i*2+1), plot4(i*2+1))
end do


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
    resP@txString = text4
else
    resP@txString = text5
end if
gsn_panel(wks1, plot1, (/4,2/), resP)

if(j.eq.0)then
    resP@txString = text6
else
    resP@txString = text7
end if
gsn_panel(wks2, plot2, (/4,2/), resP)

end do

end
