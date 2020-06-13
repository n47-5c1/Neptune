;*************************************************************
;Aim: Draw climatologies of global seasonal stationary waves total wavenumber
;Mission:
;
;   1. Read data from U datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2016-06-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "uwnd.mon.mean.nc"
    deg2rad = 0.0174533      ;2*pi/360
    omega   = 7.27*10.^(-5.)
    a       = 6378388.

;time
    yS     = 1979
    yE     = 2015
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;region
    latN = 75
    latS = 0
    lonL = -35
    lonR = 145

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_g_season_Ks"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path+in_name,"r")
;    U      = U_file->uwnd(:,2,:,:)      ;850hPa
;    U      = U_file->uwnd(:,5,:,:)      ;500hPa
    U      = U_file->uwnd(:,8,:,:)      ;250hPa
    TIME   = U_file->time
    LAT    = U_file->lat

    printVarSummary (U)
    printVarSummary (TIME)
    printVarSummary (LAT)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)
    printVarSummary (iYYYY)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute Ks
   lat3 = conform (U, LAT*deg2rad, 1)
   u    = U/(a*cos(lat3))
   beta = 2.*omega - center_finite_diff_n( center_finite_diff_n( cos(lat3)^2.*u,lat3,False,0,1 ) ,lat3,False,0,1 )/cos(lat3)^2.
   u    = mask (u, U.le.0., False)
   beta = beta/u
   beta = mask (beta, beta.le.0., False)
   Ks   = sqrt( beta )*cos(lat3)
   copy_VarCoords (U,Ks)
   printVarSummary (Ks)

;compute seasonal means
   Ks_season = month_to_seasonN (Ks(iYYYY,:,:),season)
   printVarSummary (Ks_season)

;compute seasonal climatologies
   Ks_clm = dim_avg_n_Wrap (Ks_season,1)
   printVarSummary (Ks_clm)

;compute seasonal standard deviations
   Ksstd = dim_stddev_n_Wrap (Ks_season,1)
   printVarSummary (Ksstd)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(4,graphic)      ;creat a plot array
 plot2 = new(4,graphic)      ;creat a plot array

;*******************************************
;  plot climatologies
;*******************************************
res                = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame
res@gsnAddCyclic   = True
;res@gsnPolar       = "NH"       ;specify the hemisphere
;res@gsnPolarLabelFontHeightF = .025
res@gsnStringFontHeightF    = 0.024
res@gsnMaskLambertConformal = True            ; turn on lc masking

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels
res@cnFillPalette  = "MPL_YlOrRd"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
res@mpCenterLonF           = 60.        ;get the correct map
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR
res@mpProjection           = "LambertConformal"; choose projection

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 5.        ;set min contour level
res@cnMaxLevelValF       = 9.5       ;set max contour level
res@cnLevelSpacingF      = .5        ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.016   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.016
res@tmXBTickSpacingF     = 60.     ;label spacing

do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = season(i)
; res@gsnRightString  = "10^-6 m^-1"
 if(i.ne.0) then
  res@gsnRightString  = " "
 end if
 plot(i) = gsn_csm_contour_map (wks,Ks_clm(i,:,:),res)
end do

;---------------------------------------------------------------
;plot standard deviations

res2 = True

res2@gsnDraw         = False   ;don't draw
res2@gsnFrame        = False   ;don't advance frame
res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnRightString  = " "

;res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
;res2@cnMinLevelValF       = 15               ;set min contour level
;res2@cnMaxLevelValF       = 50               ;set max contour level
;res2@cnLevelSpacingF      = 5                ;set contour spacing
res2@cnInfoLabelOn        = False

;res2@cnLineLabelsOn = False   ;do not draw contour labels

do i=0,3
 plot2(i) = gsn_csm_contour (wks,Ksstd(i,:,:),res2)
; overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa Ks"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True       ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.008     ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
