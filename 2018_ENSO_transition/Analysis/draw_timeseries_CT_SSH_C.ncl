;*************************************************************
;Aim: Draw time series of the monthly sea surface height in the cold tongue in C_NORMAL_YEAR
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-08-24
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------SSH
;================================================


;    in_name = "~/data/model/hes/C_NORMAL_YEAR_1958-2009_T62g16_spin-up/C_NORMAL_YEAR_1958-2009_T62g16_spin-up.pop.h.TEMP_150m.001-150.nc"
    in_name = "~/data/model/hes/C_NORMAL_YEAR_1958-2009_T62g16_spin-up/C_NORMAL_YEAR_1958-2009_T62g16_spin-up.pop.h.SSH.001-150.nc"

;time
    x = fspan(1, 150, 150 * 12)

;cold tongue
    latN = 6
    latS = -6
    lonW = 180
    lonE = 270

;Set up options for regridding
    Opt = True

    Opt@SrcTitle = "POP Grid"
;    Opt@SrcRegional = True
    Opt@SrcFileName = "POP_gx1v6_SCRIP.nc"
    Opt@WgtFileName = "gx1v6_2_T62.nc"

;    Opt@DstRegional = True
    Opt@DstGridLat = latGau(94, "lat", "latitude", "degrees_north")
    Opt@DstGridLon = lonGlobeF(192, "lon", "longitude", "degrees_east")
    Opt@DstFileName = "T62_SCRIP.nc"

    Opt@InterpMethod   = "bilinear"
;    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "timeseries_CT_SSH_C"

;text
    text1 = "001-150"
    text2 = "cm"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_name, "r")

    SSH = in->SSH
;    SSH = in->TEMP_150m
    SSH@lat2d = in->TLAT
    SSH@lon2d = in->TLONG
    printVarSummary(SSH)
;    SSH = lonFlip(in->SSH)

;    Opt@SrcGridLat = in->TLAT
;    Opt@SrcGridLon = in->TLONG
    Opt@SrcMask2D = where(.not.ismissing(SSH(0,:,:)), 1, 0)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    SSH_regrid = ESMF_regrid(SSH, Opt)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw = SSH_regrid(0,:,0)
    gw = (/doubletofloat(SSH_regrid&lat)/)
    gw = cos(rad * gw)

;monthly anomalies
;   clm = clmMonTLL(SSH)
;   SSTA = calcMonAnomTLL(SSH, clm)

;--------------------------------------------------------------
   SSHA = wgt_areaave_Wrap(SSH_regrid(:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   printVarSummary(SSHA)

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

res = True

;res@gsnFrame = False
;res@gsnYRefLine = .0
res@gsnCenterString = text1
res@gsnRightString = text2
res@gsnStringFontHeightF = 0.021
;res@gsnYRefLineColor = "black"
;res@gsnYRefLineThicknessF = 2
;res@gsnYRefLineDashPattern = 1

;res@tiYAxisString = text4(0)
;res@tiXAxisFontHeightF = 0.021
;res@tiYAxisFontHeightF = 0.021

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

;res@trYMinF = 0
;res@trYMaxF = 15

res@txString = "Time series"
res@txFontHeightF = 0.028

res@vpHeightF = 0.25
res@vpWidthF = 0.75

;res@xyLineColors = (/"blue","black","orangered"/)
;res@xyDashPattern = 0
;res@xyLineThicknessF = 2.

plot = gsn_csm_xy(wks, x, SSHA, res)

end
