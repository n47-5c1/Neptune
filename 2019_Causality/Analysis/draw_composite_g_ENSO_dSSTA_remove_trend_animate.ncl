;*************************************************************
;Aim: Draw composites during ENSO years of global monthly sea surface temperature anomaly tendencies removed trend for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       Shan He
;                       2019-05-22
;
;*************************************************************

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;NOAA ERSST 1854/01 - , 2x2
in_name = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"

;time
yS = 1979
yE = 2018
mS = 9
mE = 5
nM = mE + 12 - mS + 1
season = "NDJ"
y1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015,\
       1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011,2016,2017/)
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
latN = 60
latS = -60

;fig
out_path = "~/hes/ENSO/Causality/Fig/Animation/"
out_name = "comp_g_ENSO_dSSTA_remove_trend_"

;text
text1 = (/"00","01","02","03","04","05","06","07","08"/)
text2 = "~F35~J~F~C~F34~W~F~mon~S~-1~N~~F34~W~F35~J~F~C~S~-1"
text3 = (/"SEP","OCT","NOV","DEC","JAN","FEB","MAR","APR","MAY"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in = addfile(in_name, "r")

time = in->time

;get the time indexs
TIME = cd_calendar(time, 0)
year_p = toint(TIME(:,0))
iYYYY = ind(year_p.ge.yS .and. year_p.le.yE)

month_p = toint(TIME(:,1))
year = year_p(iYYYY)
month = month_p(iYYYY)

bENSO = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.le.mE)
do i = 1, nY - 1
    bENSO = bENSO .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.le.mE)
end do
iENSO = ind(bENSO)

;----------------------------------------------------------
;sst = lonFlip(in->sst(iYYYY,{latN:latS},:))
;sst = short2flt(in->sst(iYYYY,{latN:latS},:))
sst = in->sst(iYYYY,{latN:latS},:)

;-------------------------------------------------------------
;creat weights: cos(lat)
rad = 4.0 * atan(1.0) / 180.0
gw = in->lat({latNI:latSI})
;gw = in->latitude({latN:latS})
gw = (/cos(rad * gw)/)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Monthly anomalies removed trend
clm = clmMonTLL(sst)
SSTA = calcMonAnomTLL(sst, clm)
SSTA = (/dtrend_msg_n(SSTA&time, SSTA, False, False, 0)/)

dSSTA = center_finite_diff_n(SSTA, 1, False, 0, 0)
;dSSTA = (/SSTA/)
copy_VarMeta(SSTA, dSSTA)

N34 = wgt_areaave_Wrap( SSTA(:,{latNI:latSI},{lonWI:lonEI}), gw, 1., 0)
N34_NDJ = month_to_season(N34, season)
dimN = dimsizes(N34_NDJ)
do i = 5, 16
    if(i .le. 11) then
        N34(i::12) = (/N34_NDJ(:dimN-1)/)
;        N34(i::12) = (/N34_NDJ(:dimN-1) / abs(N34_NDJ(:dimN-1))/)
    else
        N34(i::12) = (/N34_NDJ(:dimN-2)/)
;        N34(i::12) = (/N34_NDJ(:dimN-2) / abs(N34_NDJ(:dimN-2))/)
    end if
end do

dSSTA = (/dSSTA / conform(dSSTA, N34, 0)/)
dSSTA_ENSO = dSSTA(iENSO,:,:)
comp = clm(:nM-1,:,:)
do i = 0, nM-1
    comp(i,:,:) = dim_avg_n_Wrap(dSSTA_ENSO(i::nM,:,:), 0)
end do

printVarSummary(comp)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the composite
; ==============================================================

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
res@cnLevels = (/-0.2,-0.1,-0.05,-0.025,0.025,0.05,0.1,0.2/)

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
    res@gsnLeftString   = " "
;    res@gsnCenterString = " "
    res@gsnRightString = text2
    plot = gsn_csm_contour_map_ce(wks, comp(i,:,:), res)
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
    resP@txString = "Composite of "+text3(i)+" dSSTA during ENSO"
    gsn_panel(wks, plot, (/1,1/), resP)

    delete([/wks, plot/])
end do

end
