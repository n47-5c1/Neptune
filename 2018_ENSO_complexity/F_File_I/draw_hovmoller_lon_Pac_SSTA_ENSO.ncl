;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of cross regression between November-December-January cold tongue index and three-month means of the sea surface temperature
;     anomalies removed trend at the Pacific equator in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-29
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================


;data
    in_name = "~/hes/input/SST/sst_HadOIBl_bc_1.9x2.5_1850_2014_c150416.nc"

;time
    yS = 1950
    yE = 2014

;region
    latN = 5
    latS = -5
    lonW = 240
    lonE = 280

;fig
    out_path = "~/hes/input/SST/"
;    out_data = "./sst_HadOIBl_bc_1.9x2.5_ENSO.nc"
    out_name = "hovmoller_lon_Pac_SSTA_ENSO"

;text
    text1 = (/"a) ","b) ","c) "/)
    text2 = (/"Super El Ninos","Strong El Ninos"/)
    text3 = (/"5~F35~J~F~S - 5~F35~J~F~N","~F35~J~F~C"/)
    text4 = (/"1 (0)","4 (0)","7 (0)","10 (0)","1 (+1)","4 (+1)","7 (+1)","10 (+1)"/)
    text5 = "Month"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_name, "r")

;get the time indexs
    time = in->time
    year0 = cd_calendar(time, -1) / 100
    iYYYY = ind(year0 .ge. yS .and. year0 .le. yE)
    year = year0(iYYYY)
    iEl11 = ind(year .eq. 1982 .or. year .eq. 1997)
    iEl12 = ind(year .eq. 1983 .or. year .eq. 1998)
    iEl21 = ind(year .eq. 1972 .or. year .eq. 1991 .or. year .eq. 2009)
    iEl22 = ind(year .eq. 1973 .or. year .eq. 1992 .or. year .eq. 2010)

    ice   = in->ice_cov
    ice_p = in->ice_cov_prediddle
    SST   = in->SST_cpl
    SST_p = in->SST_cpl_prediddle
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
;    gw  = in1->latitude({latN:latS})
    gw  = in->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL(SST(iYYYY,:,:))
   SSTA = calcMonAnomTLL(SST(iYYYY,:,:), clm)

;--------------------------------------------------------------
;the Pacific
   SSTA11 = dim_avg_wgt_n_Wrap(clmMonTLL(SSTA(iEl11,{latN:latS},:)), gw({latN:latS}), 1, 1)
   SSTA12 = dim_avg_wgt_n_Wrap(clmMonTLL(SSTA(iEl12,{latN:latS},:)), gw({latN:latS}), 1, 1)
   SSTA21 = dim_avg_wgt_n_Wrap(clmMonTLL(SSTA(iEl21,{latN:latS},:)), gw({latN:latS}), 1, 1)
   SSTA22 = dim_avg_wgt_n_Wrap(clmMonTLL(SSTA(iEl22,{latN:latS},:)), gw({latN:latS}), 1, 1)
   dim = dimsizes (SSTA11)

;--------------------------------------------------------------
   SSTA1 = new((/24,dim(1)/),float)
   SSTA2 = new((/24,dim(1)/),float)

;compute linear regression
   SSTA1(:11,:) = SSTA11
   SSTA1(12:,:) = SSTA12
   SSTA2(:11,:) = SSTA21
   SSTA2(12:,:) = SSTA22

/;
; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","lon","model"/)
dimSizes = dimsizes (ccr)
dimUnlim = (/False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer","season")
filevardef (fout,"lon",typeof(lon1),getvardims(lon1))
filevardef (fout,"model","integer","model")
filevardef (fout,"ccr",typeof(ccr),getvardims(ccr))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lon",lon1)
filevarattdef (fout,"ccr",ccr)

;output only the data values
fout->season = ispan(0,dim(0)-1,1)
;fout->lon   = (/lon1({lonW:lonE})/)
fout->lon    = (/lon1/)
fout->model  = ispan(0,nmod+1,1)
fout->ccr    = (/ccr/)

;/
SSTA = lonPivot(SSTA, 25.)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(2, graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False
;res@gsnAddCyclic = True
res@gsnStringFontHeightF = .021

res@cnFillOn = True
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillPalette = "MPL_coolwarm"
res@cnInfoLabelOn = False
;res@cnFillPalette = "CBR_coldhot"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-1.6,-.8,-.4,-.2,.2,.4,.8,1.6/)

res@lbLabelBarOn = False

res@tmYLMode = "Explicit"
res@tmYLValues = ispan(0,23,3)
res@tmYLLabels = text4
res@tmYLMinorOn = False
res@tmYRMinorOn = False
;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisString = text5
res@tiYAxisFontHeightF = 0.018

res@vpWidthF = 1.
;res@vpHeightF = 0.5

res@gsnLeftString = text1(0) + text2(0)
res@gsnCenterString = text3(0)
res@gsnRightString = text3(1)
plot(0) = gsn_csm_hov(wks, SSTA1, res)

res@gsnLeftString = text1(1) + text2(1)
res@gsnCenterString = " "
res@gsnRightString = " "
plot(1) = gsn_csm_hov(wks, SSTA2, res)

;--------------------------------------------------------------
; add the line
resl = True
;resl@gsLineColor = "grey60"
resl@gsLineThicknessF  = 2
;resl@gsLineDashPattern = 1
dum1 = gsn_add_polyline(wks, plot(0), (/lonW,lonW/), (/0,23/), resl)
dum2 = gsn_add_polyline(wks, plot(1), (/lonW,lonW/), (/0,23/), resl)
dum3 = gsn_add_polyline(wks, plot(0), (/lonE,lonE/), (/0,23/), resl)
dum4 = gsn_add_polyline(wks, plot(1), (/lonE,lonE/), (/0,23/), resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF = 0.028
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.02
resP@pmLabelBarOrthogonalPosF = -0.008
resP@txString = "ENSO's SSTA"

gsn_panel(wks, plot, (/2,1/), resP)

end
