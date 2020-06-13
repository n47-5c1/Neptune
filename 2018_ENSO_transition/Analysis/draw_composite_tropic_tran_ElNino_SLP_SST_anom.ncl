;*************************************************************
;Aim: Draw climatology of tropical surface wind and sea surface temperature anomalies during non-transitional El Nino and difference against transitional one
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
;   var1--------------slp
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/slp.mon.mean.nc"
    in_name2 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 9
    mE = 8
    yS = 1958
    yE = 2017

    y1 = (/1969,1972,1982,1997,2006,2015/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)
    season = (/"JFM","AMJ","JAS"/)
;    season = (/"JFM","JJA","JAS"/)
    seasonClm = (/"SON","DJF","MAM"/)

;region
    latN = 30
    latS = -20
    lonL = 40
    lonR = 260

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "comp_tropic_tran_ElNino_SLP_SST_anom"

;text
    text1 = (/"a) Transitional EP","g) Transitional CP","b) Non-transitional EP","h) Non-transitional CP",\
              "c) Transitional - Non-transitional, EP","i) Transitional - Non-transitional, CP",\
              "d) Transitional EP","j) Transitional CP","e) Non-transitional EP","k) Non-transitional CP",\
              "f) Transitional - Non-transitional, EP","l) Transitional - Non-transitional, CP"/)
    text2 = (/"SLPA (hPa)","SSTA (~F35~J~F~C)"/)
    text3 = "DJF SLPA and SSTA during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    time1 = in1->time
    time2 = in2->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    year1 = toint(TIME1(:,0))
    year2 = toint(TIME2(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)

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

    slp = in1->slp(iYYYY1,:,:)
    sst = lonFlip(in2->sst(iYYYY2,:,:))

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw = in2->latitude
    gw = cos(rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(slp)
    clm2 = clmMonTLL(sst)

    varClm1 = dim_variance_n_Wrap(month_to_seasonN(slp, seasonClm), 1)
    varClm2 = dim_variance_n_Wrap(month_to_seasonN(sst, seasonClm), 1)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(slp, clm1)
    Anom2 = calcMonAnomTLL(sst, clm2)
    print("Anom")

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

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

   diff1 = (/ave1 - ave3/)
   diff2 = (/ave5 - ave7/)
   diff3 = (/ave2 - ave4/)
   diff4 = (/ave6 - ave8/)
   copy_VarMeta(ave1, diff1)
   copy_VarMeta(ave5, diff2)
   copy_VarMeta(ave2, diff3)
   copy_VarMeta(ave6, diff4)
/;
;---------------------------------------------------------------
;compute probabilities for means difference
   var1 = dim_variance_n_Wrap(season1, 1)
   var2 = dim_variance_n_Wrap(season2, 1)
   var3 = dim_variance_n_Wrap(season3, 1)
   var4 = dim_variance_n_Wrap(season4, 1)
   var5 = dim_variance_n_Wrap(season5, 1)
   var6 = dim_variance_n_Wrap(season6, 1)
   var7 = dim_variance_n_Wrap(season7, 1)
   var8 = dim_variance_n_Wrap(season8, 1)

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
plot1 = new(12, graphic)
plot2 = new(12, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.024

res@cnFillOn = True
res@cnFillPalette = "MPL_RdYlBu"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-1.2,-.6,-.3,.3,.6,1.2/)

res@lbLabelBarOn = False

res@mpFillOn = False
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
plot1(0) = gsn_csm_contour_map_ce(wks, ave1(1,:,:), res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(0)
plot1(1) = gsn_csm_contour_map_ce(wks, ave5(1,:,:), res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(2) = gsn_csm_contour_map_ce(wks, ave3(1,:,:), res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_contour_map_ce(wks, ave7(1,:,:), res)

res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_contour_map_ce(wks, diff1(1,:,:), res)

res@gsnLeftString = text1(5)
plot1(5) = gsn_csm_contour_map_ce(wks, diff2(1,:,:), res)

res@cnLevels = (/-.8,-.4,-.2,.2,.4,.8/)
res@cnFillPalette = "MPL_coolwarm"
res@mpFillOn = True
res@mpOutlineOn = False
res@mpLandFillColor = "gray75"

res@gsnLeftString = text1(6)
plot1(6) = gsn_csm_contour_map_ce(wks, ave2(1,:,:), res)

res@gsnLeftString = text1(7)
res@gsnRightString = text2(1)
plot1(7) = gsn_csm_contour_map_ce(wks, ave6(1,:,:), res)

res@gsnLeftString = text1(8)
res@gsnRightString = " "
plot1(8) = gsn_csm_contour_map_ce(wks, ave4(1,:,:), res)

res@gsnLeftString = text1(9)
plot1(9) = gsn_csm_contour_map_ce(wks, ave8(1,:,:), res)

res@gsnLeftString = text1(10)
plot1(10) = gsn_csm_contour_map_ce(wks, diff3(1,:,:), res)

res@gsnLeftString = text1(11)
plot1(11) = gsn_csm_contour_map_ce(wks, diff4(1,:,:), res)

;---------------------------------------------------------------
;plot contour

res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnAddCyclic = True
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 2

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0/)
res2@cnInfoLabelOn = False
res2@cnLineLabelsOn = False

plot2(0) = gsn_csm_contour(wks, ave1(1,:,:), res2)
plot2(1) = gsn_csm_contour(wks, ave5(1,:,:), res2)
plot2(2) = gsn_csm_contour(wks, ave3(1,:,:), res2)
plot2(3) = gsn_csm_contour(wks, ave7(1,:,:), res2)
plot2(4) = gsn_csm_contour(wks, diff1(1,:,:), res2)
plot2(5) = gsn_csm_contour(wks, diff2(1,:,:), res2)
/;
plot2(4) = gsn_csm_contour(wks, ave2(1,:,:), res2)
plot2(5) = gsn_csm_contour(wks, ave4(1,:,:), res2)
plot2(6) = gsn_csm_contour(wks, ave6(1,:,:), res2)
plot2(7) = gsn_csm_contour(wks, ave8(1,:,:), res2)
;/
do i = 0, 5
    overlay(plot1(i), plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnFrame = False
resP@gsnPanelLabelBar = True
resP@lbOrientation = "vertical"
resP@lbLabelFontHeightF = 0.014

resP1 = resP
resP1@txString = text3
resP1@gsnPanelBottom = 0.5
gsn_panel(wks, plot1(:5), (/3,2/), resP1)

resP2 = resP
resP2@gsnPanelTop = 0.5
resP2@gsnPanelBottom = 0.05
gsn_panel(wks, plot1(6:), (/3,2/), resP2)
frame(wks)

end
