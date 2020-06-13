;*************************************************************
;Aim: Draw climatology of zonal wind and potential vorticity anomalies during non-transitional El Nino and difference against transitional one
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-09-14
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
;   var3--------------air
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"
    in_name3 = "air.mon.mean.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2016

    y1 = (/1969,1972,1982,1997,2006,2015/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)
    season = (/"JFM","AMJ","JAS"/)
    seasonClm = (/"SON","DJF","MAM"/)

;region
    latN = 60
    latS = -20
    lonL = 40
    lonR = 280

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "comp_tropic_tran_ElNino_U_PV_anom"

;text
    text1 = (/"a) EP","b)","c) CP","d)"/)
    text2 = (/"Transitional","Non-transitional","hPa, ~F35~J~F~C"/)
    text3 = "SON U and PV Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    time1 = in1->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    year1 = toint(TIME1(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    El1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     El1 = El1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
    end do

    El2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
    do i = 1, ny2 - 1
     El2 = El2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
    end do

    El3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
    do i = 1, ny3 - 1
     El3 = El3 .or. (year.eq.y3(i) .and. month.ge.mS .or. year.eq.y3(i)+1 .and. month.lt.mS)
    end do

    El4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)
    do i = 1, ny4 - 1
     El4 = El4 .or. (year.eq.y4(i) .and. month.ge.mS .or. year.eq.y4(i)+1 .and. month.lt.mS)
    end do

;----------------------------------------------------------

    uwnd = in1->uwnd(iYYYY1,:,::-1,:)
    vwnd = in2->vwnd(iYYYY1,:,::-1,:)
    air = in3->air(iYYYY1,:,::-1,:)
    air = (air + 273.15)
    air@units = "K"
    level = uwnd&level
    level = (/level * 100/)
    level@units = "Pa"
    printVarSummary(air)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
    PV = pot_vort_isobaric(level, uwnd, vwnd, air, uwnd&lat, 1, 0)
    Anom1 = uwnd(:,10,:,:)
    Anom2 = PV(:,10,:,:)
/;
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(PV)

    varClm1 = dim_variance_n_Wrap(month_to_seasonN(uwnd, seasonClm), 1)
    varClm2 = dim_variance_n_Wrap(month_to_seasonN(PV, seasonClm), 1)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(PV, clm2)
    print("Anom")

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom2(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
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
;/
;----------------------------------------------------------
   iMM1 = ind(El1)
   iMM2 = ind(El2)
   iMM3 = ind(El3)
   iMM4 = ind(El4)

   season1 = month_to_seasonN(Anom1(iMM1,:,:), season)
   season2 = month_to_seasonN(Anom2(iMM1,:,:), season)
   season3 = month_to_seasonN(Anom1(iMM2,:,:), season)
   season4 = month_to_seasonN(Anom2(iMM2,:,:), season)
   season5 = month_to_seasonN(Anom1(iMM3,:,:), season)
   season6 = month_to_seasonN(Anom2(iMM3,:,:), season)
   season7 = month_to_seasonN(Anom1(iMM4,:,:), season)
   season8 = month_to_seasonN(Anom2(iMM4,:,:), season)

   ave1 = dim_avg_n_Wrap(season1, 1)
   ave2 = dim_avg_n_Wrap(season2, 1)
   ave3 = dim_avg_n_Wrap(season3, 1)
   ave4 = dim_avg_n_Wrap(season4, 1)
   ave5 = dim_avg_n_Wrap(season5, 1)
   ave6 = dim_avg_n_Wrap(season6, 1)
   ave7 = dim_avg_n_Wrap(season7, 1)
   ave8 = dim_avg_n_Wrap(season8, 1)
/;
   var1 = dim_variance_n_Wrap(season1, 1)
   var2 = dim_variance_n_Wrap(season2, 1)
   var3 = dim_variance_n_Wrap(season3, 1)
   var4 = dim_variance_n_Wrap(season4, 1)
   var5 = dim_variance_n_Wrap(season5, 1)
   var6 = dim_variance_n_Wrap(season6, 1)
   var7 = dim_variance_n_Wrap(season7, 1)
   var8 = dim_variance_n_Wrap(season8, 1)

   ave1 = (/ave1 - ave4/)
   ave2 = (/ave2 - ave5/)
   ave3 = (/ave3 - ave6/)
   ave7 = (/ave7 - ave10/)
   ave8 = (/ave8 - ave11/)
   ave9 = (/ave9 - ave12/)

;---------------------------------------------------------------
;compute probabilities for means difference
   prob1 = ttest(ave1+ave4, var1, ny1, ave4, var4, ny2, False, False)
   prob2 = ttest(ave2+ave5, var2, ny1, ave5, var5, ny2, False, False)
   prob3 = ttest(ave3+ave6, var3, ny1, ave6, var6, ny2, False, False)
   prob4 = ttest(ave4, var4, ny2, ave4*0, varClm1, yE-yS+1, False, False)
   prob5 = ttest(ave5, var5, ny2, ave5*0, varClm2, yE-yS+1, False, False)
   prob6 = ttest(ave6, var6, ny2, ave6*0, varClm3, yE-yS+1, False, False)
   prob7 = ttest(ave7+ave10+ave4, var7, ny3, ave10+ave4, var10, ny4, False, False)
   prob8 = ttest(ave8+ave11+ave5, var8, ny3, ave11+ave5, var11, ny4, False, False)

   copy_VarCoords(ave1, prob1)
   copy_VarCoords(ave2, prob2)
   copy_VarCoords(ave3, prob3)
   copy_VarCoords(ave4, prob4)
   copy_VarCoords(ave5, prob5)
   copy_VarCoords(ave6, prob6)
   copy_VarCoords(ave7, prob7)
   copy_VarCoords(ave8, prob8)

   ave3 = where(prob3.le.0.05, ave3, 0.)
   ave6 = where(prob6.le.0.05, ave6, 0.)
   ave9 = where(prob9.le.0.05, ave9, 0.)
   ave1 = (/mask(ave1, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave2 = (/mask(ave2, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave4 = (/mask(ave4, prob4.le.0.2 .or. prob5.le.0.2, True)/)
   ave5 = (/mask(ave5, prob4.le.0.2 .or. prob5.le.0.2, True)/)
   ave7 = (/mask(ave7, prob7.le.0.2 .or. prob8.le.0.2, True)/)
   ave8 = (/mask(ave8, prob7.le.0.2 .or. prob8.le.0.2, True)/)
;/
; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.024

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-8.,-6.,-4.,-2.,0.,2.,4.,6.,8./)*10.^-6.

res@lbLabelBarOn = False

res@mpFillOn = False
;res@mpLandFillColor = "gray75"
;res@mpOutlineOn = False
res@mpCenterLonF = 160.
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023
res@tmXBTickSpacingF = 45.

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
plot1(0) = gsn_csm_contour_map_ce(wks, ave2(1,:,:), res)

ave4 = (/ave4 - ave2/)
res@cnLevels = (/-8.,-6.,-4.,-2.,0.,2.,4.,6.,8./)*10.^-7.

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_contour_map_ce(wks, ave4(1,:,:), res)

res@cnLevels = (/-8.,-6.,-4.,-2.,0.,2.,4.,6.,8./)*10.^-6.
res@gsnLeftString = text1(2)
res@gsnCenterString = " "
res@gsnRightString = " "
plot1(2) = gsn_csm_contour_map_ce(wks, ave6(1,:,:), res)

res@cnLevels = (/-8.,-6.,-4.,-2.,0.,2.,4.,6.,8./)*10.^-7.
ave8 = (/ave8 - ave6/)
res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_contour_map_ce(wks, ave8(1,:,:), res)

;---------------------------------------------------------------
;plot contour

res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnAddCyclic = True
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 3
res2@gsnContourNegLineDashPattern = 1

res2@cnLevelSelectionMode = "ManualLevels"
;res2@cnMinLevelValF = -4.
;res2@cnMaxLevelValF = 6.
;res2@cnLevelSpacingF = 2.
res2@cnMinLevelValF = -10.
res2@cnMaxLevelValF = 60.
res2@cnLevelSpacingF = 10.
res2@cnInfoLabelOn = False
;res2@cnLineDrawOrder = "PostDraw"
;res2@cnLabelDrawOrder = "PostDraw"
res2@cnLineLabelsOn = False
res2@cnInfoLabelFontHeightF = 0.016
res2@cnInfoLabelOrthogonalPosF = 0.42

plot2(0) = gsn_csm_contour(wks, ave1(1,:,:), res2)
plot2(1) = gsn_csm_contour(wks, ave3(1,:,:), res2)
plot2(2) = gsn_csm_contour(wks, ave5(1,:,:), res2)
res2@cnInfoLabelOn = True
plot2(3) = gsn_csm_contour(wks, ave7(1,:,:), res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.009
resP@txString = text3

gsn_panel(wks, plot1, (/2,2/), resP)

end
