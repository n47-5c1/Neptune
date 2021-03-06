;*************************************************************
;Aim: Draw composites during ENSO years of global monthly mean surface flux anomalies removed trend for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       Shan He
;                       2019-05-23
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------mslhf
;   var3--------------msnlwrf
;   var4--------------msnswrf
;   var5--------------msshf
;================================================

a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
;NOAA ERSST 1854/01 - , 2x2
in_name1 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;ERA5 1979/01 - 2018/12, 0.25x0.25
in_name2 = "~/data/observation/ERA5/mslhf.msnlwrf.msnswrf.msshf.1979-2018.mon.mean.nc"

;time
yS = 1979
yE = 2018
mS = 9
mE = 5
nM = mE + 12 - mS + 1
season = "NDJ"
y1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015/)
;       1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011,2016,2017/)
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
latN = 40
latS = -40

;fig
out_path = "~/hes/ENSO/Causality/Fig/Animation/"
out_name = "comp_g_ENSO_mslhf_msnlwrf_msnswrf_msshf_anom_remove_trend_"

;text
text1 = (/"00","01","02","03","04","05","06","07","08"/)
text2 = (/"a)","b)","c)","d)","e)"/)
text3 = (/"Latent heat","Longwave radiation","Shortwave radiation","Sensible heat","Total"/)
text4 = "W~F34~W~F~m~S~-2~N~~F34~W~F35~J~F~C~S~-1"
text5 = (/"SEP","OCT","NOV","DEC","JAN","FEB","MAR","APR","MAY"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
print("Add files...")

in1 = addfile(in_name1, "r")
in2 = addfile(in_name2, "r")

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

bENSO = year2.eq.y1(0) .and. month2.ge.mS .or. year2.eq.y1(0)+1 .and. month2.le.mE
do i = 1, nY - 1
    bENSO = bENSO .or. year2.eq.y1(i) .and. month2.ge.mS .or. year2.eq.y1(i)+1 .and. month2.le.mE
end do
;bENSO = month2.ge.mS .or. month2.le.mE

iENSO = ind(bENSO)

;----------------------------------------------------------
;sst = lonFlip(in->sst(iYYYY,{latN:latS},:))
sst = in1->sst(iYYYY1,{latN:latS},:)
mslhf = short2flt(in2->mslhf(iYYYY2,{latN:latS},:))
msnlwrf = short2flt(in2->msnlwrf(iYYYY2,{latN:latS},:))
msnswrf = short2flt(in2->msnswrf(iYYYY2,{latN:latS},:))
msshf = short2flt(in2->msshf(iYYYY2,{latN:latS},:))

lsdata = a->LSMASK
lsm = landsea_mask(lsdata, mslhf&latitude, mslhf&longitude)
mslhf = mask(mslhf, lsm.eq.0, True)
msnlwrf = mask(msnlwrf, lsm.eq.0, True)
msnswrf = mask(msnswrf, lsm.eq.0, True)
msshf = mask(msshf, lsm.eq.0, True)

;-------------------------------------------------------------
;creat weights: cos(lat)
rad = 4.0 * atan(1.0) / 180.0
gw = in1->lat({latNI:latSI})
;gw = in->latitude({latN:latS})
gw = (/cos(rad * gw)/)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
print("Anomalies...")

;Monthly anomalies removed trend
clm1 = clmMonTLL(sst)
clm2 = clmMonTLL(mslhf)
clm3 = clmMonTLL(msnlwrf)
clm4 = clmMonTLL(msnswrf)
clm5 = clmMonTLL(msshf)
Anom1 = calcMonAnomTLL(sst, clm1)
Anom2 = calcMonAnomTLL(mslhf, clm2)
Anom3 = calcMonAnomTLL(msnlwrf, clm3)
Anom4 = calcMonAnomTLL(msnswrf, clm4)
Anom5 = calcMonAnomTLL(msshf, clm5)
Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)
Anom4 = (/dtrend_msg_n(Anom4&time, Anom4, False, False, 0)/)
Anom5 = (/dtrend_msg_n(Anom5&time, Anom5, False, False, 0)/)

;Nino 3.4 index
N34 = wgt_areaave_Wrap(Anom1(:,{latNI:latSI},{lonWI:lonEI}), gw, 1., 0)
N34_NDJ = month_to_season(N34, season)
dimN = dimsizes(N34_NDJ)
do i = 5, 16
    if(i .le. 11) then
        N34(i::12) = (/N34_NDJ(:dimN-1)/)
        N34(i::12) = (/N34_NDJ(:dimN-1) / abs(N34_NDJ(:dimN-1))/)
    else
        N34(i::12) = (/N34_NDJ(:dimN-2)/)
        N34(i::12) = (/N34_NDJ(:dimN-2) / abs(N34_NDJ(:dimN-2))/)
    end if
end do

print("Composite...")
Anom2 = (/Anom2 / conform(Anom2, N34, 0)/)
Anom3 = (/Anom3 / conform(Anom2, N34, 0)/)
Anom4 = (/Anom4 / conform(Anom3, N34, 0)/)
Anom5 = (/Anom5 / conform(Anom4, N34, 0)/)
Anom2_ENSO = Anom2(iENSO,:,:)
Anom3_ENSO = Anom3(iENSO,:,:)
Anom4_ENSO = Anom4(iENSO,:,:)
Anom5_ENSO = Anom5(iENSO,:,:)
comp1 = clm2(:nM-1,:,:)
comp2 = clm3(:nM-1,:,:)
comp3 = clm4(:nM-1,:,:)
comp4 = clm5(:nM-1,:,:)
comp5 = clm5(:nM-1,:,:)
do i = 0, nM-1
    comp1(i,:,:) = dim_avg_n_Wrap(Anom2_ENSO(i::nM,:,:), 0)
    comp2(i,:,:) = dim_avg_n_Wrap(Anom3_ENSO(i::nM,:,:), 0)
    comp3(i,:,:) = dim_avg_n_Wrap(Anom4_ENSO(i::nM,:,:), 0)
    comp4(i,:,:) = dim_avg_n_Wrap(Anom5_ENSO(i::nM,:,:), 0)
end do
comp5 = (/comp1 + comp2 + comp3 + comp4/)
copy_VarMeta(comp1, comp5)

;determine the statistical significance
;prob = ccr      ;copy meta data
;prob = rtest (ccr,dim(0),0)
;prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the composite
; ==============================================================
print("Draw...")

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
res@cnLevels = (/-24,-18,-12,-6,6,12,18,24/)

res@lbLabelBarOn = False

res@tmXBTickSpacingF = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@mpCenterLonF = 200
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 3.0          ; thickness of lines

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  
dum5 = new (4,graphic)  
dum6 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF = 0.03
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0, nM-1
    wks = gsn_open_wks("svg", out_path + out_name + text1(i))
    plot = new(5, graphic)
    res@gsnLeftString = text2(0)
    res@gsnCenterString = text3(0)
    res@gsnRightString = text4
    plot(0) = gsn_csm_contour_map_ce(wks, comp1(i,:,:), res)
    res@gsnLeftString = text2(1)
    res@gsnCenterString = text3(1)
    res@gsnRightString = " "
    plot(1) = gsn_csm_contour_map_ce(wks, comp2(i,:,:), res)
    res@gsnLeftString = text2(2)
    res@gsnCenterString = text3(2)
    plot(2) = gsn_csm_contour_map_ce(wks, comp3(i,:,:), res)
    res@gsnLeftString = text2(3)
    res@gsnCenterString = text3(3)
    plot(3) = gsn_csm_contour_map_ce(wks, comp4(i,:,:), res)
    res@gsnLeftString = text2(4)
    res@gsnCenterString = text3(4)
    plot(4) = gsn_csm_contour_map_ce(wks, comp5(i,:,:), res)
/;
;----------------------------------------------------------
    do j = 0, 3
        dum1(j) = gsn_add_polyline(wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
        dum2(j) = gsn_add_polyline(wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
        dum3(j) = gsn_add_polyline(wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
        dum4(j) = gsn_add_polyline(wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
        dum5(j) = gsn_add_polyline(wks,plot(0),xpts3(j:j+1),ypts3(j:j+1),resb)
        dum6(j) = gsn_add_polyline(wks,plot(1),xpts3(j:j+1),ypts3(j:j+1),resb)
    end do 
;/
    resP@txString = "Composite of "+text5(i)+" Surface Fluxes during ENSO"
    gsn_panel(wks, plot, (/5,1/), resP)

    delete([/wks, plot/])
end do

end
