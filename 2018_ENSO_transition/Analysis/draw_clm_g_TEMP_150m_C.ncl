;*************************************************************
;Aim: Draw climatology of the global monthly potential temperature at 150m in C_NORMAL_YEAR
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-08-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------TEMP_150m
;================================================


    in_name = "~/data/model/hes/C_NORMAL_YEAR_1958-2009_T62g16_spin-up/C_NORMAL_YEAR_1958-2009_T62g16_spin-up.pop.h.TEMP_150m.01-60.nc"

;time
    yS = 51
    yE = 60

;map
    latN = 60
    latS = -60
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
    out_name = "clm_g_TEMP_150m_C"

;text
    text1 = "51-60"
    text2 = "deg C"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_name, "r")

;get the time indexs
    time = in->time
    YYYY = cd_calendar(time, -1) / 100
    iYYYY = ind(YYYY.ge.yS .and. YYYY.le.yE)

    TEMP = in->TEMP_150m(iYYYY,:,:)
    TEMP@lat2d = in->TLAT
    TEMP@lon2d = in->TLONG
    printVarSummary(TEMP)

;    Opt@SrcGridLat = in->TLAT
;    Opt@SrcGridLon = in->TLONG
    Opt@SrcMask2D = where(.not.ismissing(TEMP(0,:,:)), 1, 0)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    TEMP_regrid = ESMF_regrid(TEMP, Opt)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw = TEMP_regrid(0,:,0)
    gw = (/doubletofloat(TEMP_regrid&lat)/)
    gw = cos(rad * gw)

;Calculate climatology
   clm = dim_avg_n_Wrap(TEMP, 0)
   printVarSummary(clm)

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

res = True

res@gsnCenterString = text1
res@gsnRightString = text2
;res@gsnScalarContour = True       ;contours desired
;res@gsnSpreadColorEnd = 127
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/0,5,10,15,20,25/)

res@pmLabelBarOrthogonalPosF = 0.12

res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonL
;res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

plot = gsn_csm_contour_map_ce(wks, clm, res)

end
