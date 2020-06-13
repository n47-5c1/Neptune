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
;   var1--------------uwnd
;   var2--------------vwnd
;   var3--------------prate
;   var4--------------sst
;================================================

;data
in_path = "~/data/observation/"
in_name1 = "NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
in_name2 = "NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"
in_name3 = "NCEP_NCAR/monthly/ulwrf.ntat.mon.mean.nc"
in_name4 = "SST/HadISST/HadISST_sst.nc"

;time
mS = 6
mE = 5
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
season = (/"JFM","AMJ","JAS","OND"/)

;region
latN = 60
latS = -20
lonL = 90
lonR = 280

;Nino 3.4
latN1 = 5
latS1 = -5
lonW1 = 190
lonE1 = 240

;fig
out_path = "~/hes/ENSO/Termination/Fig/"
out_name = "comp_tropic_tran_ElNino_UV_PREC_SST_anom"

;text
text1 = (/"a) EP","b)","c) CP","d)"/)
text2 = (/"Transitional","Non-transitional","m/s, ~F35~J~F~C"/)
text3 = "SON UV, OLR and SST Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_path + in_name1, "r")
in2 = addfile(in_path + in_name2, "r")
in3 = addfile(in_path + in_name3, "r")
in4 = addfile(in_path + in_name4, "r")
time1 = in1->time
time4 = in4->time

;get the time indexs
TIME1 = cd_calendar(time1, 0)
TIME4 = cd_calendar(time4, 0)
year1 = toint(TIME1(:,0))
year4 = toint(TIME4(:,0))
iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
iYYYY4 = ind(year4.ge.yS .and. year4.le.yE)

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
uwnd = in1->uwnd(iYYYY1,:,:)
vwnd = in2->vwnd(iYYYY1,:,:)
prate = in3->ulwrf(iYYYY1,:,:)
sst = lonFlip(in4->sst(iYYYY4,:,:))

;-------------------------------------------------------------
;creat weights: cos(lat)
rad = 4.*atan(1.)/180.
gw = in4->latitude
gw = cos(rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
clm1 = clmMonTLL(uwnd)
clm2 = clmMonTLL(vwnd)
clm3 = clmMonTLL(prate)
clm4 = clmMonTLL(sst)

;Monthly anomalies
Anom1 = calcMonAnomTLL(uwnd, clm1)
Anom2 = calcMonAnomTLL(vwnd, clm2)
Anom3 = calcMonAnomTLL(prate, clm3)
Anom4 = calcMonAnomTLL(sst, clm4)
print("Anom")
/;
;Nino 3.4 (DJF)
Nino34 = wgt_areaave_Wrap(Anom4(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
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
Anom3 = (/Anom3 / conform(Anom3, Nino34, 0)/)
Anom4 = (/Anom4 / conform(Anom4, Nino34, 0)/)
;/
;----------------------------------------------------------
iMM1 = ind(El1)
iMM2 = ind(El2)
iMM3 = ind(El3)
iMM4 = ind(El4)

season11 = month_to_seasonN(Anom1(iMM1,:,:), season)
season21 = month_to_seasonN(Anom2(iMM1,:,:), season)
season31 = month_to_seasonN(Anom3(iMM1,:,:), season)
season41 = month_to_seasonN(Anom4(iMM1,:,:), season)
season12 = month_to_seasonN(Anom1(iMM2,:,:), season)
season22 = month_to_seasonN(Anom2(iMM2,:,:), season)
season32 = month_to_seasonN(Anom3(iMM2,:,:), season)
season42 = month_to_seasonN(Anom4(iMM2,:,:), season)
season13 = month_to_seasonN(Anom1(iMM3,:,:), season)
season23 = month_to_seasonN(Anom2(iMM3,:,:), season)
season33 = month_to_seasonN(Anom3(iMM3,:,:), season)
season43 = month_to_seasonN(Anom4(iMM3,:,:), season)
season14 = month_to_seasonN(Anom1(iMM4,:,:), season)
season24 = month_to_seasonN(Anom2(iMM4,:,:), season)
season34 = month_to_seasonN(Anom3(iMM4,:,:), season)
season44 = month_to_seasonN(Anom4(iMM4,:,:), season)

ave11 = dim_avg_n_Wrap(season11, 1)
ave21 = dim_avg_n_Wrap(season21, 1)
ave31 = dim_avg_n_Wrap(season31, 1)
ave41 = dim_avg_n_Wrap(season41, 1)
ave12 = dim_avg_n_Wrap(season12, 1)
ave22 = dim_avg_n_Wrap(season22, 1)
ave32 = dim_avg_n_Wrap(season32, 1)
ave42 = dim_avg_n_Wrap(season42, 1)
ave13 = dim_avg_n_Wrap(season13, 1)
ave23 = dim_avg_n_Wrap(season23, 1)
ave33 = dim_avg_n_Wrap(season33, 1)
ave43 = dim_avg_n_Wrap(season43, 1)
ave14 = dim_avg_n_Wrap(season14, 1)
ave24 = dim_avg_n_Wrap(season24, 1)
ave34 = dim_avg_n_Wrap(season34, 1)
ave44 = dim_avg_n_Wrap(season44, 1)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)
plot3 = new(4, graphic)

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
res@cnLevels = (/-12.,-6.,-3.,3.,6.,12./)
;res@cnLevels = (/-1.5,-1.,-.5,.5,1.,1.5/)*10.^-5.

res@lbLabelBarOn = False

res@mpFillOn = False
;res@mpLandFillColor = "gray75"
;res@mpOutlineOn = False
res@mpCenterLonF = 160.
;res@mpGeophysicalLineColor = "gray40"
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
plot1(0) = gsn_csm_contour_map_ce(wks, ave31(1,:,:), res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text2(2)
plot1(1) = gsn_csm_contour_map_ce(wks, ave32(1,:,:), res)

res@gsnLeftString = text1(2)
res@gsnCenterString = " "
res@gsnRightString = " "
plot1(2) = gsn_csm_contour_map_ce(wks, ave33(1,:,:), res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_contour_map_ce(wks, ave34(1,:,:), res)

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
res2@cnMinLevelValF = -0.9
res2@cnMaxLevelValF = 0.9
res2@cnLevelSpacingF = 0.3
res2@cnInfoLabelOn = False
res2@cnLineColor = "gray30"
;res2@cnLineDrawOrder = "PostDraw"
;res2@cnLabelDrawOrder = "PostDraw"
res2@cnLineLabelsOn = False
res2@cnInfoLabelFontHeightF = 0.016
res2@cnInfoLabelParallelPosF = 0.8
res2@cnInfoLabelOrthogonalPosF = 0.42

plot2(0) = gsn_csm_contour(wks, ave41(1,:,:), res2)
plot2(1) = gsn_csm_contour(wks, ave42(1,:,:), res2)
plot2(2) = gsn_csm_contour(wks, ave43(1,:,:), res2)
res2@cnInfoLabelOn = True
plot2(3) = gsn_csm_contour(wks, ave44(1,:,:), res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do

;---------------------------------------------------------------
;plot vector

res3 = True

res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "

res3@vcGlyphStyle = "FillArrow"
res3@vcRefAnnoOn = False
res3@vcRefLengthF = 0.08
res3@vcRefMagnitudeF = 3.
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.018
res3@vcRefAnnoOrthogonalPosF = -0.26
res3@vcMinDistanceF = 0.035
;res3@vcLineArrowColor = "green4"
;res3@vcLineArrowThicknessF = 1.6
;res3@vcLineArrowHeadMaxSizeF = 0.036
;res3@vcLineArrowHeadMinSizeF = 0.015
res3@vcFillArrowWidthF = 0.05
res3@vcFillArrowHeadMinFracYF =0.5
res3@vcFillArrowMinFracWidthF = 0.5
res3@vcFillArrowEdgeThicknessF = 3

plot3(0) = gsn_csm_vector(wks, ave11(1,:,:), ave21(1,:,:), res3)
plot3(1) = gsn_csm_vector(wks, ave12(1,:,:), ave22(1,:,:), res3)
plot3(2) = gsn_csm_vector(wks, ave13(1,:,:), ave23(1,:,:), res3)
res3@vcRefAnnoOn = True
plot3(3) = gsn_csm_vector(wks, ave14(1,:,:), ave24(1,:,:), res3)

do i = 0, 3
    overlay(plot1(i), plot3(i))
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
