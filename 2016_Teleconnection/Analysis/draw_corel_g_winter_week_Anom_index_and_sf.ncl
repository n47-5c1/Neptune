;*************************************************************
;Aim: Draw correlation between weekly teleconnection index anomalies and global stream function anomalies in the winter-half year
;
;Mission:
;   1. Read data from INDEX, sst and sf datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;
;                       He Shan
;                       2017-06-03
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------INDEX
;   var2--------------sf
;================================================

;data
    in_path = "~/hes/One_Belt_One_Road/NCL/"
    in1     = "PC_square_Index.nc"
    in2     = "sf.weekly.mean.anom_1982-2015.nc"

;time
    mS = 11
    mE = 4
    yS = 1982
    yE = 2015

    opt                = True
    opt@nval_crit      = 4          ;the minimum number of values needed
    opt@segment_length = 7

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "corel_g_winter_week_Anom_index_and_sf"

;text
;    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","n)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f      = addfile (in_path+in1, "r")
    sf_in  = addfile (in_path+in2, "r")

    index = f->INDEX
    sf    = sf_in->sf

    time = f->time

    printVarSummary (index)
    printVarSummary (sf)
    printVarSummary (time)

;----------------------------------------------------------
    TIME  = cd_calendar (time, 0)
    year  = toint (TIME(:,0) )
    month = toint (TIME(:,1) )
    day   = toint (TIME(:,2))

;get the time indexs
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    iMM   = ind (month(iYYYY).lt.mS .and. month(iYYYY).gt.mE)   ;for summer-half year
    printVarSummary (iYYYY)
    printVarSummary (iMM)

;create required yyyyddd
    ddd     = day_of_year (year, month, day)
    yyyyddd = year*1000 + ddd
    printVarSummary (yyyyddd)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    index_p   = conform_dims ((/dimsizes(index),1,1/),index,0)
    index_p   = index
    index_p!1 = "lat"
    index_p!2 = "lon"
    printVarSummary (index_p)

;Daily anomalies
    index_clm  = clmDayTLL (index_p(iYYYY,:,:), yyyyddd(iYYYY))
    index_anom = calcDayAnomTLL (index_p(iYYYY,:,:), yyyyddd(iYYYY),index_clm)

;Calculate segment means
    index_anom(iMM,:,:) = index_anom@_FillValue      ;leave winter-half year alone
    index_seg           = calculate_segment_values (index_anom(:,0,0),"avg",0,opt)
    printVarSummary (index_seg)

;----------------------------------------------------------
;compute cross correlation
    sf_r = sf(lat|:,lon|:,time|:)
    ccr  = escorc (sf_r,index_seg)
    copy_VarCoords_1 (sf_r,ccr)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (ccr)
;   printVarSummary (ccr3)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks   = gsn_open_wks ("svg",out_path+out_name)

;-----------------------------------------------------------------------------
res = True

;res@gsnDraw  = False
;res@gsnFrame = False
res@gsnPolar     = "NH"
res@gsnAddCyclic = True
res@gsnCenterString          = "Nov.-Apr."
res@gsnRightString           = "250 hPa sf"
res@gsnStringFontHeightF     = .02
res@gsnPolarLabelSpacing     = 45
res@gsnPolarLabelDistance    = 1.04
res@gsnPolarLabelFontHeightF = .02
res@gsnContourZeroLineThicknessF   = 2.6
res@gsnContourNegLineDashPattern   = 1
res@gsnContourLineThicknessesScale = 1.8

res@cnLineLabelsOn = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -.06
res@cnMaxLevelValF       = .06
res@cnLevelSpacingF      = 0.06
res@cnLineLabelsOn       = False
;res@cnInfoLabelOrthogonalPosF = -0.28   ;move informational label down

;res@mpFillOn               = False
res@mpCenterLonF           = 0.
res@mpLandFillColor        = "gray90"
;res@mpGeophysicalLineColor = "gray60"   ;change the colour of ontlines

;res@lbOrientation            = "vertical"
;res@lbLabelFontHeightF       = 0.02
;res@pmLabelBarOrthogonalPosF = 0.1    ;move Label Bar

res@tiMainString      = "Correlation of Index Anomalies against SF Anomalies"
res@tiMainFontHeightF = 0.023

plot = gsn_csm_contour_map (wks,ccr,res)

end
