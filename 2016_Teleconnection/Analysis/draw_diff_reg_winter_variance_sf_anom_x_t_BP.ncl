;*************************************************************
;Aim: Draw difference in regional variance of daily anomalous stream function deviations from zonal mean with 10-30-day bandpass filters for El Niño
;     and La Niña Years in the winter-half year 
;Mission:
;
;   1. Read data from uwnd & vwnd datasets
;   2. Post-post process to deserved results
;   3. Draw the variance
;                       He Shan
;                       2017-05-10
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/daily/"

;time
    mS  = 7
    yS1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2015/)
    yS2 = (/1983,1984,1988,1995,1998,1999,2000,2007,2010,2011/)   ;2016!
    ny1 = dimsizes (yS1)
    ny2 = dimsizes (yS2)

; create the filter weights
    nwt    = 61
    fca    = 1./30.
    fcb    = 1./10.
    ihp    = 2          
    nsigma = 1.
    wts    = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

;regiion
    latN = 65
    latS = 0
    lonW = -50
    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "diff_reg_winter_variance_sf_anom_x_t_BP"

;text
    text1 = (/"El Nino","Nov.(0) - Apr.(+1)","El Nino - La Nina"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis 2
    U_files = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files,"r")
    V_in = addfiles (V_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
;    U    = short2flt (V_in[:]->uwnd(:,2,::-1,:))      ;850hPa
;    U    = short2flt (V_in[:]->uwnd(:,5,::-1,:))      ;500hPa
    U    = short2flt (U_in[:]->uwnd(:,8,::-1,:))      ;250hPa
    V    = short2flt (V_in[:]->vwnd(:,8,::-1,:))
    TIME = U_in[:]->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME)

;----------------------------------------------------------
;create required yyyyddd
    YYYY    = cd_calendar (TIME,0)
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))
    day     = floattointeger (YYYY(:,2))
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd
    printVarSummary (yyyyddd)

;get the time indexs
    El = (year.eq.yS1(0) .and. month.ge.mS .or. year.eq.yS1(0)+1 .and. month.lt.mS)
    do i=1,ny1-1
     El = El.or.(year.eq.yS1(i) .and. month.ge.mS .or. year.eq.yS1(i)+1 .and. month.lt.mS)
    end do

    La = (year.eq.yS2(0) .and. month.ge.mS .or. year.eq.yS2(0)+1 .and. month.lt.mS)
    do i=1,ny2-1
     La = La.or.(year.eq.yS2(i) .and. month.ge.mS .or. year.eq.yS2(i)+1 .and. month.lt.mS)
    end do

    iEl = ind ((month.ge.11 .or. month.le.4) .and. El)
    iLa = ind ((month.ge.11 .or. month.le.4) .and. La)

    printVarSummary (iEl)
    printVarSummary (iLa)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;Deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
   sfClmDay = clmDayTLL (sf_xAnom, yyyyddd)
   sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   printVarSummary (sf_tAnom)

;Filter
   sfAnom_BP = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
;   sfAnom_BP   = sfAnom_BP_p (time|:,lat|:,lon|:)
   dim = dimsizes (sfAnom_BP)
   printVarSummary (sfAnom_BP)

;Compute seasonal variances
   var1 = dim_variance_Wrap (sfAnom_BP(:,:,iEl))
   var2 = dim_variance_Wrap (sfAnom_BP(:,:,iLa))

   printVarSummary (var1)

;Difference
   diff = var1-var2
   copy_VarMeta (var1,diff)
   printVarSummary (diff)

; ==============================================================w; Mission 3. Draw the variance
; Mission 3. Draw the variance
; ==============================================================

 wks  = gsn_open_wks ("svg",out_path+out_name)
 plot = new (2,graphic)

;----------------------------------------------------------
;draw difference
res = True

res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = text1(0)
res@gsnCenterString = text1(1)
res@gsnRightString  = text1(2)
res@gsnStringFontHeightF = .02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-15,-10,-5,5,10,15/)

res@mpFillOn     = False
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
res@mpMinLonF    = lonW
res@mpMaxLonF    = lonE
;res@mpCenterLonF = 60.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines

;res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.36    ;move Label Bar down

res@tiMainString      = "Variance of 250 hPa Daily SF Anomalies and its Difference"
res@tiMainFontHeightF = 0.023

;res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = .018
res@tmYLLabelFontHeightF = .018

plot(0) = gsn_csm_contour_map_ce (wks,diff,res)

;----------------------------------------------------------
;draw climatology
ores = True
 
ores@gsnDraw       = False
ores@gsnFrame      = False
ores@gsnAddCyclic  = True
ores@gsnLeftString = " "
ores@gsnContourLineThicknessesScale = 2

ores@cnLevelSelectionMode = "ExplicitLevels"
ores@cnLevels             = ispan(40,80,10)
;ores@cnLineLabelsOn = False
ores@cnLineLabelInterval = 1
;ores@cnLineLabelDensityF = 0.8
;ores@cnLineLabelFontHeightF = 0.012
ores@cnLineLabelPlacementMode = "Computed"
ores@cnInfoLabelFontHeightF = 0.013
ores@cnInfoLabelOrthogonalPosF = -0.42

plot(1) = gsn_csm_contour (wks,var1,ores)
overlay (plot(0),plot(1))

draw (plot(0))
frame (wks)

end
