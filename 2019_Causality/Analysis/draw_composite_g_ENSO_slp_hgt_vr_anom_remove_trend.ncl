;*************************************************************
;Aim: Draw composites during ENSO years of global monthly sea level pressure/850 hPa geopotential height/surface and 850 hPa vorticity
;     anomalies removed trend
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       Shan He
;                       2019-05-29
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------slp
;   var3--------------hgt
;   var4--------------uwnd
;   var5--------------vwnd
;================================================

;NOAA ERSST 1854/01 - , 2x2
in_name1 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;NCEP-NCAR Reanalysis 1 1948/01 - , 2.5x2.5
in_path = "~/data-observation/NCEP_NCAR/monthly/"
in_name2 = "slp.mon.mean.nc"
in_name3 = "hgt.mon.mean.nc"
in_name4 = "uwnd.sfc.mon.mean.nc"
in_name5 = "vwnd.sfc.mon.mean.nc"
in_name6 = "uwnd.mon.mean.nc"
in_name7 = "vwnd.mon.mean.nc"

yS = 1958
yE = 2018
mS = 5
mE = 9
nM = mE - mS + 1
y1 = (/1959,1964,1966,1969,1970,1973,1977,1978,1980,1983,1987,1988,1992,1995,1998,2003,2005,2007,2010,2015,2016/)
;       1965,1971,1972,1974,1975,1976,1984,1985,1989,1996,1999,2000,2001,2006,2008,2009,2011,2012,2017,2018/)
season = "NDJ"
nY = dimsizes(y1)

;Nino3.4
latNI = 5
latSI = -5
lonWI = 190
lonEI = 240

;tropical Indian Ocean
latN1 = 10
latS1 = -10
lonW1 = 50
lonE1 = 100

;tropical North Atlantic
latN2 = 25
latS2 = 5
lonW2 = 305 
lonE2 = 345

; create points for box
ypts1 = (/latNI,latNI,latSI,latSI,latNI/)
xpts1 = (/lonWI,lonEI,lonEI,lonWI,lonWI/)
ypts2 = (/latN1,latN1,latS1,latS1,latN1/)
xpts2 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
ypts3 = (/latN2,latN2,latS2,latS2,latN2/)
xpts3 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)

;region
latN = 50
latS = -30

;fig
out_path = "~/hes/ENSO/Causality/Fig/"
out_name = "comp_g_ENSO_slp_hgt_vr_anom_remove_trend"

;text
text1 = (/"a) MAY-SEP","b)","c)","d)"/)
text2 = (/"slp","hgt850","vr.sfc","vr850"/)
text3 = (/"hPa","m","/s "/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_name1, "r")
in2 = addfile(in_path + in_name2, "r")
in3 = addfile(in_path + in_name3, "r")
in4 = addfile(in_path + in_name4, "r")
in5 = addfile(in_path + in_name5, "r")
in6 = addfile(in_path + in_name6, "r")
;in7 = addfile(in_path + in_name7, "r")

time1 = in1->time
time2 = in2->time

;get the time indexs
year1 = cd_calendar (time1,-1) /100
iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)

TIME2 = cd_calendar(time2, 0)
year_p = toint(TIME2(:,0))
iYYYY2 = ind(year_p.ge.yS .and. year_p.le.yE)
month_p = toint(TIME2(:,1))
year2 = year_p(iYYYY2)
month2 = month_p(iYYYY2)

bENSO = year2.eq.y1(0) .and. month2.ge.mS .and. month2.le.mE
do i = 1, nY - 1
    bENSO = bENSO .or. year2.eq.y1(i) .and. month2.ge.mS .and. month2.le.mE
end do
;bENSO = month2.ge.mS .or. month2.le.mE

iENSO = ind(bENSO)

;----------------------------------------------------------
;sst = lonFlip(in->sst(iYYYY,{latN:latS},:))
sst = in1->sst(iYYYY1,{latNI:latSI},{lonWI:lonEI})
slp = in2->slp(iYYYY2,{latN:latS},:)
hgt = in3->hgt(iYYYY2,2,{latN:latS},:)
uwnd_sfc = in4->uwnd(iYYYY2,{-90:90},:)
vwnd_sfc = in5->vwnd(iYYYY2,{-90:90},:)
uwnd = in6->uwnd(iYYYY2,2,{-90:90},:)
;vwnd = in7->vwnd(iYYYY2,2,{-90:90},:)

;-------------------------------------------------------------
;creat weights: cos(lat)
rad = 4.0 * atan(1.0) / 180.0
gw = in1->lat({latNI:latSI})
;gw = in->latitude({latN:latS})
gw = (/cos(rad * gw)/)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
vr_sfc_p = uv2vrF_Wrap(uwnd_sfc, vwnd_sfc)
;vr_p = uv2vrF_Wrap(uwnd, vwnd)
vr_sfc = vr_sfc_p(:,{latN:latS},:)
;vr = vr_p(:,{latN:latS},:)

vr = vr_sfc

;Monthly anomalies removed trend
clm1 = clmMonTLL(sst)
clm2 = clmMonTLL(slp)
clm3 = clmMonTLL(hgt)
clm4 = clmMonTLL(vr_sfc)
clm5 = clmMonTLL(vr)
Anom1 = calcMonAnomTLL(sst, clm1)
Anom2 = calcMonAnomTLL(slp, clm2)
Anom3 = calcMonAnomTLL(hgt, clm3)
Anom4 = calcMonAnomTLL(vr_sfc, clm4)
Anom5 = calcMonAnomTLL(vr, clm5)
Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)
Anom4 = (/dtrend_msg_n(Anom4&time, Anom4, False, False, 0)/)
Anom5 = (/dtrend_msg_n(Anom5&time, Anom5, False, False, 0)/)

;Nino 3.4 index
N34 = wgt_areaave_Wrap(Anom1, gw, 1., 0)
N34_NDJ = month_to_season(N34, season)
dimN = dimsizes(N34_NDJ)
do i = 9, 20
    if(i .le. 11) then
;        N34(i::12) = (/N34_NDJ(:dimN-1)/)
        N34(i::12) = (/N34_NDJ(:dimN-1) / abs(N34_NDJ(:dimN-1))/)
    else
;        N34(i::12) = (/N34_NDJ(:dimN-2)/)
        N34(i::12) = (/N34_NDJ(:dimN-2) / abs(N34_NDJ(:dimN-2))/)
    end if
end do

Anom2 = (/Anom2 / conform(Anom2, N34, 0)/)
Anom3 = (/Anom3 / conform(Anom2, N34, 0)/)
Anom4 = (/Anom4 / conform(Anom3, N34, 0)/)
Anom5 = (/Anom5 / conform(Anom4, N34, 0)/)
Anom2_ENSO = Anom2(iENSO,:,:)
Anom3_ENSO = Anom3(iENSO,:,:)
Anom4_ENSO = Anom4(iENSO,:,:)
Anom5_ENSO = Anom5(iENSO,:,:)
comp1 = dim_avg_n_Wrap(Anom2_ENSO, 0)
comp2 = dim_avg_n_Wrap(Anom3_ENSO, 0)
comp3 = dim_avg_n_Wrap(Anom4_ENSO, 0)
comp4 = dim_avg_n_Wrap(Anom5_ENSO, 0)
copy_VarMeta(clm2(0,:,:), comp1)
copy_VarMeta(clm3(0,:,:), comp2)
copy_VarMeta(clm4(0,:,:), comp3)
copy_VarMeta(clm5(0,:,:), comp4)

printMinMax(comp1, 0)
printMinMax(comp2, 0)
printMinMax(comp3, 0)
printMinMax(comp4, 0)

;determine the statistical significance
;prob = ccr      ;copy meta data
;prob = rtest (ccr,dim(0),0)
;prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the composite
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(4, graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = True
res@gsnStringFontHeightF = .02

res@cnFillOn = True
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillPalette = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"

res@lbLabelBarOn = False

res@tmXBTickSpacingF = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@mpCenterLonF = 200
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString = text3(0)
res@cnLevels = (/-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4/)
plot(0) = gsn_csm_contour_map_ce(wks, comp1, res)
res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text3(1)
res@cnLevels = (/-4.0,-3.0,-2.0,-1.0,1.0,2.0,3.0,4.0/)
plot(1) = gsn_csm_contour_map_ce(wks, comp2, res)
res@gsnLeftString = text1(2)
res@gsnCenterString = text2(2)
res@gsnRightString = text3(2)
res@cnLevels = (/-1.2,-0.9,-0.6,-0.3,0.3,0.6,0.9,1.2/)*10.0^-6.0
plot(2) = gsn_csm_contour_map_ce(wks, comp3, res)
res@gsnLeftString = text1(3)
res@gsnCenterString = text2(3)
res@gsnRightString = " "
plot(3) = gsn_csm_contour_map_ce(wks, comp4, res)
/;
;************************************************
; add the box
;************************************************
resb = True
resb@gsLineThicknessF = 3.0

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  
dum5 = new (4,graphic)  
dum6 = new (4,graphic)  

do j = 0, 3
    dum1(j) = gsn_add_polyline(wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
    dum2(j) = gsn_add_polyline(wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
    dum3(j) = gsn_add_polyline(wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
    dum4(j) = gsn_add_polyline(wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
    dum5(j) = gsn_add_polyline(wks,plot(0),xpts3(j:j+1),ypts3(j:j+1),resb)
    dum6(j) = gsn_add_polyline(wks,plot(1),xpts3(j:j+1),ypts3(j:j+1),resb)
end do 
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF = 0.03
resP@txString = "Composite of WNPAC during ENSO"
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008
gsn_panel(wks, plot, (/4,1/), resP)

end
