;*************************************************************
;Aim: Draw cross-correlation during ENSO years between Nino 3.4 index and global monthly sea level pressure/850 hPa geopotential height/
;     surface and 850 hPa vorticity anomalies removed trend for animations
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

;time
yS = 1958
yE = 2018
mS = 5
mE = 9
nM = mE - mS + 1
y1 = (/1959,1964,1966,1969,1970,1973,1977,1978,1980,1983,1987,1988,1992,1995,1998,2003,2005,2007,2010,2015,2016/)
;       1965,1971,1972,1974,1975,1976,1984,1985,1989,1996,1999,2000,2001,2006,2008,2009,2011,2012,2017,2018/)
nY = dimsizes(y1)
mxlag = 5+3

;Nino3.4
latNI = 5
latSI = -5
lonWI = 190
lonEI = 240
;latNI = 30
;latSI = 5
;lonWI = 180
;lonEI = 120

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
out_path = "~/hes/ENSO/Causality/Fig/Animation/"
out_name = "lag_corr_Nino34_g_slp_hgt_vr_anom_remove_trend_"

;text
text1 = (/"00","01","02","03","04","05"/)
text2 = (/"a)","b)","c)","d)"/)
text3 = (/"slp","hgt850","vr.sfc","vr850"/)
text4 = "MAY-SEP"
text5 = (/"-5","-4","-3","-2","-1","0"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_name1, "r")
in2 = addfile(in_path + in_name2, "r")
in3 = addfile(in_path + in_name3, "r")
in4 = addfile(in_path + in_name4, "r")
in5 = addfile(in_path + in_name5, "r")
in6 = addfile(in_path + in_name6, "r")
in7 = addfile(in_path + in_name7, "r")

time1 = in1->time
time2 = in2->time

;get the time indexs
year1 = cd_calendar(time1, -1) / 100
iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)

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
;bENSO = month2.ge.mS .and. month2.le.mE

nonENSO = ind(.not.bENSO)

printVarSummary(iYYYY1)

;----------------------------------------------------------
;sst = lonFlip(in->sst(iYYYY,{latN:latS},:))
;sst = short2flt(in->sst(iYYYY,{latN:latS},:))
sst = in1->sst(iYYYY1,{latNI:latSI},{lonWI:lonEI})
slp = in2->slp(iYYYY2,{latN:latS},:)
hgt = in3->hgt(iYYYY2,2,{latN:latS},:)
uwnd_sfc = in4->uwnd(iYYYY2,{-90:90},:)
vwnd_sfc = in5->vwnd(iYYYY2,{-90:90},:)
uwnd = in6->uwnd(iYYYY2,2,{-90:90},:)
vwnd = in7->vwnd(iYYYY2,2,{-90:90},:)

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
vr_p = uv2vrF_Wrap(uwnd, vwnd)
vr_sfc = vr_sfc_p(:,{latN:latS},:)
vr = vr_p(:,{latN:latS},:)

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

;cross-correlation
Anom2(nonENSO,:,:) = Anom2@_FillValue
Anom3(nonENSO,:,:) = Anom3@_FillValue
Anom4(nonENSO,:,:) = Anom4@_FillValue
Anom5(nonENSO,:,:) = Anom5@_FillValue
ccr1 = esccr(N34, Anom2(lat|:,lon|:,time|:), mxlag)
ccr2 = esccr(N34, Anom3(lat|:,lon|:,time|:), mxlag)
ccr3 = esccr(N34, Anom4(lat|:,lon|:,time|:), mxlag)
ccr4 = esccr(N34, Anom5(lat|:,lon|:,time|:), mxlag)
copy_VarCoords(Anom2(lat|:,lon|:,time|:mxlag), ccr1)
copy_VarCoords(Anom3(lat|:,lon|:,time|:mxlag), ccr2)
copy_VarCoords(Anom4(lat|:,lon|:,time|:mxlag), ccr3)
copy_VarCoords(Anom5(lat|:,lon|:,time|:mxlag), ccr4)
ccr1 = (/ccr1(:,:,::-1)/)
ccr2 = (/ccr2(:,:,::-1)/)
ccr3 = (/ccr3(:,:,::-1)/)
ccr4 = (/ccr4(:,:,::-1)/)

;determine the statistical significance
;prob = ccr      ;copy meta data
;prob = rtest (ccr,dim(0),0)
;prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the composite
; ==============================================================

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = True
res@gsnStringFontHeightF = .02
res@gsnLeftString = " "
res@gsnCenterString = text2
res@gsnRightString = " "

res@cnFillOn = True
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillPalette = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-0.8,-0.6,-0.4,-0.2,0.2,0.4,0.6,0.8/)

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
delete(res@gsnCenterString)

;----------------------------------------------------------
do i = 0, mxlag-3
    wks = gsn_open_wks("svg", out_path + out_name + text1(i))
    plot = new(4, graphic)
    res@gsnLeftString = text2(0)
    res@gsnCenterString = text3(0)
    res@gsnRightString = text4
    plot(0) = gsn_csm_contour_map_ce(wks, ccr1(:,:,i), res)
    res@gsnLeftString = text2(1)
    res@gsnCenterString = text3(1)
    res@gsnRightString = " "
    plot(1) = gsn_csm_contour_map_ce(wks, ccr2(:,:,i), res)
    res@gsnLeftString = text2(2)
    res@gsnCenterString = text3(2)
    plot(2) = gsn_csm_contour_map_ce(wks, ccr3(:,:,i), res)
    res@gsnLeftString = text2(3)
    res@gsnCenterString = text3(3)
    plot(3) = gsn_csm_contour_map_ce(wks, ccr4(:,:,i), res)
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
    resP@txString = "Correlation with N34 at "+text5(i)
    gsn_panel(wks, plot, (/4,1/), resP)

    delete([/wks, plot/])
end do

end
