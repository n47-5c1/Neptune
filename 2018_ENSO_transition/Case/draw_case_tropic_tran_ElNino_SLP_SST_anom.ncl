;*************************************************************
;Aim: Draw tropical surface wind and sea surface temperature anomalies during non-transitional El Nino and difference against transitional one in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2019-11-13
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

    y1 = 1972
    y2 = 1986
    y3 = 1987
;    y4 = 1965
    y4 = 1991

    season = (/"JFM","AMJ","JAS"/)
    seasonClm = (/"SON","DJF","MAM"/)

;region
    latN = 40
    latS = -20
    lonL = 40
    lonR = 260

;fig
    out_path = "~/hes/ENSO/Termination/Case/"
    out_name = "case_tropic_tran_ElNino_SLP_SST_anom"

;text
    text1 = (/"a) Transitional EP, "+y1,"b) Non-transitional EP, "+y2,"e) Transitional CP, "+y3,"f) Non-transitional CP, "+y4,\
              "c) Transitional EP, "+y1,"d) Non-transitional EP, "+y2,"g) Transitional CP, "+y3,"h) Non-transitional CP, "+y4/)
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

    iMM1 = ind(year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
    iMM2 = ind(year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
    iMM3 = ind(year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
    iMM4 = ind(year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

;----------------------------------------------------------
    slp = in1->slp(iYYYY1,:,:)
    sst = lonFlip(in2->sst(iYYYY2,:,:))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(slp)
    clm2 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(slp, clm1)
    Anom2 = calcMonAnomTLL(sst, clm2)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

;----------------------------------------------------------
   season1 = month_to_seasonN(Anom1(iMM1,:,:), season)
   season2 = month_to_seasonN(Anom2(iMM1,:,:), season)
   season3 = month_to_seasonN(Anom1(iMM2,:,:), season)
   season4 = month_to_seasonN(Anom2(iMM2,:,:), season)
   season5 = month_to_seasonN(Anom1(iMM3,:,:), season)
   season6 = month_to_seasonN(Anom2(iMM3,:,:), season)
   season7 = month_to_seasonN(Anom1(iMM4,:,:), season)
   season8 = month_to_seasonN(Anom2(iMM4,:,:), season)

   ave1 = season1(:,0,:,:)
   ave2 = season2(:,0,:,:)
   ave3 = season3(:,0,:,:)
   ave4 = season4(:,0,:,:)
   ave5 = season5(:,0,:,:)
   ave6 = season6(:,0,:,:)
   ave7 = season7(:,0,:,:)
   ave8 = season8(:,0,:,:)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(8, graphic)
plot2 = new(8, graphic)

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
res@cnLevels = (/-3.2,-1.6,-.8,.8,1.6,3.2/)

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
plot1(2) = gsn_csm_contour_map_ce(wks, ave3(1,:,:), res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(1) = gsn_csm_contour_map_ce(wks, ave5(1,:,:), res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_contour_map_ce(wks, ave7(1,:,:), res)

res@cnLevels = (/-1.2,-.6,-.3,.3,.6,1.2/)
res@cnFillPalette = "MPL_coolwarm"
res@mpFillOn = True
res@mpOutlineOn = False
res@mpLandFillColor = "gray75"
res@mpMaxLatF = latN+5

res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_contour_map_ce(wks, ave2(1,:,:), res)

res@gsnLeftString = text1(5)
res@gsnRightString = text2(1)
plot1(6) = gsn_csm_contour_map_ce(wks, ave4(1,:,:), res)

res@gsnLeftString = text1(6)
res@gsnRightString = " "
plot1(5) = gsn_csm_contour_map_ce(wks, ave6(1,:,:), res)

res@gsnLeftString = text1(7)
plot1(7) = gsn_csm_contour_map_ce(wks, ave8(1,:,:), res)

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
plot2(2) = gsn_csm_contour(wks, ave3(1,:,:), res2)
plot2(1) = gsn_csm_contour(wks, ave5(1,:,:), res2)
plot2(3) = gsn_csm_contour(wks, ave7(1,:,:), res2)

plot2(4) = gsn_csm_contour(wks, ave2(1,:,:), res2)
plot2(6) = gsn_csm_contour(wks, ave4(1,:,:), res2)
plot2(5) = gsn_csm_contour(wks, ave6(1,:,:), res2)
plot2(7) = gsn_csm_contour(wks, ave8(1,:,:), res2)

do i = 0, 3
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
resP1@gsnPanelTop = 0.85
resP1@gsnPanelBottom = 0.5
gsn_panel(wks, plot1(:3), (/2,2/), resP1)

resP2 = resP
resP2@gsnPanelTop = 0.5
resP2@gsnPanelBottom = 0.13
gsn_panel(wks, plot1(4:), (/2,2/), resP2)
frame(wks)

end
