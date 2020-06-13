;*************************************************************
;Aim: Draw climatologies of global zonal winds and correlation between weekly teleconnection index anomalies and global zonal wind anomalies in the winter-half year
;
;Mission:
;   1. Read data from INDEX and U datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;
;                       He Shan
;                       2017-11-16
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
;   var2--------------uwind
;================================================

;data
    in_path1 = "~/hes/One_Belt_One_Road/NCL/PC_square_Index.nc"
    in_path2 = "~/data/observation/NCEP_DOE/daily/uwnd/uwnd.*.nc"

;time
    mS = 11
    mE = 4
    yS = 1979
    yE = 2015
    season = (/10,11,0,1,2,3/)

    opt                = True
    opt@nval_crit      = 4          ;the minimum number of values needed
    opt@segment_length = 7

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_corel_g_winter_week_Anom_index_and_U"

;text
;    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","n)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    U_files = systemfunc ("ls "+in_path2)
    setfileoption ("nc","SuppressClose",False)   ;close too many files

    f_in = addfile (in_path1, "r")
    U_in = addfiles (U_files, "r")

    index = f_in->INDEX
    U     = short2flt (U_in[:]->uwnd(:,8,::-1,:))   ;250 hPa

    time1 = f_in->time
    time2 = U_in[:]->time

    printVarSummary (index)
    printVarSummary (U)
    printVarSummary (time1)

;----------------------------------------------------------
    TIME1  = cd_calendar (time1, 0)
    year1  = toint (TIME1(:,0) )
    month1 = toint (TIME1(:,1) )
    day1   = toint (TIME1(:,2))

    TIME2  = cd_calendar (time2, 0)
    year2  = toint (TIME2(:,0) )
    month2 = toint (TIME2(:,1) )
    day2   = toint (TIME2(:,2))

;get the time indexs
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
    iMM1   = ind (month1(iYYYY1).lt.mS .and. month1(iYYYY1).gt.mE)   ;for summer-half year
    iMM2   = ind (month2(iYYYY2).lt.mS .and. month2(iYYYY2).gt.mE)
    printVarSummary (iYYYY1)
    printVarSummary (iMM1)

;create required yyyyddd
    ddd1     = day_of_year (year1, month1, day1)
    ddd2     = day_of_year (year2, month2, day2)
    yyyyddd1 = year1*1000 + ddd1
    yyyyddd2 = year2*1000 + ddd2
    printVarSummary (yyyyddd1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    index_p   = conform_dims ((/dimsizes(index),1,1/),index,0)
    index_p   = index
    index_p!1 = "lat"
    index_p!2 = "lon"
    printVarSummary (index_p)

;Daily anomalies
    index_clm  = clmDayTLL (index_p(iYYYY1,:,:), yyyyddd1(iYYYY1))
    index_anom = calcDayAnomTLL (index_p(iYYYY1,:,:), yyyyddd1(iYYYY1),index_clm)

    U_clm  = clmDayTLL (U(iYYYY2,:,:), yyyyddd2(iYYYY2))
    U_anom = calcDayAnomTLL (U(iYYYY2,:,:), yyyyddd2(iYYYY2),U_clm)

;Calculate climatology
    U_mon = calculate_monthly_values (U(iYYYY2,:,:), "avg", 0, False)
    clm   = clmMonTLL (U_mon)
    Clm   = dim_avg_n_Wrap (clm(season,:,:),0)

;Calculate segment means
    index_anom(iMM1,:,:) = index_anom@_FillValue      ;leave winter-half year alone
    index_seg            = calculate_segment_values (index_anom(:,0,0),"avg",0,opt)
    U_anom(iMM2,:,:) = U_anom@_FillValue
    U_seg            = calculate_segment_values (U_anom,"avg",0,opt)
    printVarSummary (index_seg)
    printVarSummary (U_seg)

;----------------------------------------------------------
;compute cross correlation
    U_r = U_seg(lat|:,lon|:,time|:)
    ccr  = escorc (U_r,index_seg)
    copy_VarCoords_1 (U_r,ccr)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (ccr)
;   printVarSummary (ccr3)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the plot
; ==============================================================

 wks   = gsn_open_wks ("svg",out_path+out_name)

;-----------------------------------------------------------------------------
;plot the correlation
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnPolar     = "NH"
res@gsnAddCyclic = True
res@gsnCenterString          = "Nov.-Apr."
res@gsnRightString           = " "
res@gsnStringFontHeightF     = .021
res@gsnPolarLabelSpacing     = 45
res@gsnPolarLabelDistance    = 1.06
res@gsnPolarLabelFontHeightF = .021

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.12,-.09,-.06,.06,.09,.12/)

res@mpFillOn               = False
res@mpCenterLonF           = 0.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines

;res@lbOrientation            = "vertical"
res@lbLabelFontHeightF       = .022
res@pmLabelBarOrthogonalPosF = .06    ;move Label Bar

res@tiMainString      = "CLM of U and Corr. of Index Anomalies against U Anomalies"
res@tiMainFontHeightF = 0.023

plot0 = gsn_csm_contour_map (wks,ccr,res)

;---------------------------------------------------------------
;plot the climatology
res2 = True

res2@gsnDraw         = False
res2@gsnFrame        = False
res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnRightString  = " "
res2@gsnContourZeroLineThicknessF   = 2.6
;res2@gsnContourNegLineDashPattern   = 1
res2@gsnContourLineThicknessesScale = 1.8

res2@cnInfoLabelOn  = True
res2@cnLineLabelsOn = False
res2@cnInfoLabelFontHeightF    = .019
res2@cnInfoLabelOrthogonalPosF = -.3        ;move informational label down
res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0                ;set min contour level
res2@cnMaxLevelValF       = 60               ;set max contour level
res2@cnLevelSpacingF      = 20               ;set contour spacing

plot1 = gsn_csm_contour (wks,Clm,res2)
overlay (plot0,plot1)

draw (plot0)
frame (wks)

end
