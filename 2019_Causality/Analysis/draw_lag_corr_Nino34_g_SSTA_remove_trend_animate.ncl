;*************************************************************
;Aim: Draw cross-correlation during ENSO years between Nino 3.4 index and global monthly sea surface temperature anomalies removed trend for animations
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
;   var--------------sst
;================================================

;NOAA ERSST 1854/01 - , 2x2
in_name = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"

;time
yS = 1979
yE = 2018
mS = 12
mE = 5
nM = mE + 12 - mS + 1
y1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015,\
       1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011,2016,2017/)
nY = dimsizes(y1)
mxlag = 5

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
out_name = "lag_corr_Nino34_g_SSTA_remove_trend_"

;text
text1 = (/"00","01","02","03","04","05"/)
text2 = "DEC(0)-MAY(+1)"
text3 = (/"-5","-4","-3","-2","-1","0"/)

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

bENSO = year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.le.mE
do i = 1, nY - 1
    bENSO = bENSO .or. year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.le.mE
end do
;bENSO = month.ge.mS .or. month.le.mE

nonENSO = ind(.not.bENSO)

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

;dSSTA = center_finite_diff_n(SSTA, 1, False, 0, 0)
;copy_VarMeta(SSTA, dSSTA)

;Nino 3.4 index
N34 = wgt_areaave_Wrap(SSTA(:,{latNI:latSI},{lonWI:lonEI}), gw, 1., 0)

;cross-correlation
SSTA(nonENSO,:,:) = SSTA@_FillValue
ccr = esccr(N34, SSTA(lat|:,lon|:,time|:), mxlag)
ccr = ccr(:,:,::-1)
copy_VarCoords(SSTA(lat|:,lon|:,time|:mxlag), ccr)

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

;----------------------------------------------------------
do i = 0, mxlag
    wks = gsn_open_wks("svg", out_path + out_name + text1(i))
    plot = gsn_csm_contour_map_ce(wks, ccr(:,:,i), res)
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
    resP@txString = "Correlation between N34 at "+text3(i)+" and SSTA"
    gsn_panel(wks, plot, (/1,1/), resP)

    delete([/wks, plot/])
end do

end
