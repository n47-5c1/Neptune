;*************************************************************
;Aim: Draw climatologies of global stationary waves total wavenumber and correlation between monthly teleconnection index anomalies and the wavenumber anomalies in the winter-half year
;Mission:
;
;   1. Read data from U datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2017-11-17
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
;   var2--------------uwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
    deg2rad = 0.0174533      ;2*pi/360
    omega   = 7.27*10.^(-5.)
    a       = 6378388.

;time
    mS  = 7
    yS = 1979
    yE = 2015
    yS1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009/)   ;2015!
    yS2 = (/1983,1984,1988,1995,1998,1999,2000,2007,2010,2011/)   ;2016!
    ny1 = dimsizes (yS1)
    ny2 = dimsizes (yS2)

;region
    latN = 50
    latS = 0
    lonL = -40
    lonR = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_diff_winter_mon_Ks_anom"

;text
    text0 = (/"a) U;  El Nino","b) Ks"/)
    text1 = (/"Nov.(0) - Apr.(+1)","El Nino - La Nina"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    U_in = addfile (in_path,"r")
;    U    = U_file->uwnd(:,2,:,:)      ;850hPa
;    U    = U_file->uwnd(:,5,:,:)      ;500hPa
    time = U_in->time

;get the time indexs
    TIME    = cd_calendar (time, 0)
    year_p  = toint (TIME(:,0) )
    month_p = toint (TIME(:,1) )
    iYYYY   = ind (year_p.ge.yS .and. year_p.le.yE)
    year  = year_p(iYYYY)
    month = month_p(iYYYY)

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
;----------------------------------------------------------

    U      = U_in->uwnd(iYYYY,8,:,:)      ;250hPa
    LAT    = U_in->lat

    printVarSummary (U)
    printVarSummary (LAT)

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

;----------------------------------------------------------
   Ks1_p = Ks(iEl,:,:)
   Ks2_p = Ks(iLa,:,:)
   Ks1 = (Ks1_p(::6,:,:) + Ks1_p(1::6,:,:) + Ks1_p(2::6,:,:) + Ks1_p(3::6,:,:) + Ks1_p(4::6,:,:) + Ks1_p(5::6,:,:)) / 6
   Ks2 = (Ks2_p(::6,:,:) + Ks2_p(1::6,:,:) + Ks2_p(2::6,:,:) + Ks2_p(3::6,:,:) + Ks2_p(4::6,:,:) + Ks2_p(5::6,:,:)) / 6
   copy_VarMeta(Ks1_p(0::6,:,:), Ks1)
   copy_VarMeta(Ks2_p(0::6,:,:), Ks2)

   ave1 = dim_avg_n_Wrap(Ks1, 0)
   ave2 = dim_avg_n_Wrap(Ks2, 0)
   var1 = dim_variance_n_Wrap(Ks1, 0)
   var2 = dim_variance_n_Wrap(Ks2, 0)

;---------------------------------------------------------------
;compute probabilities for means difference

   diff = ave1 - ave2
   diff = where(abs(diff) .lt. 2.4, diff, diff@_FillValue)
   prob = ttest(ave2, var2, dimsizes(Ks2(:,0,0)), ave1, var1, dimsizes(Ks1(:,0,0)), False, False)
   copy_VarMeta(ave1, diff)
   copy_VarCoords(ave1, prob)
   printVarSummary(diff)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("svg",out_path+out_name)

;*******************************************
;  plot correlation
;*******************************************
res = True

res@gsnDraw         = False
res@gsnFrame        = False
res@gsnAddCyclic    = True
res@gsnLeftString   = text0(1)
;res@gsnCenterString = text1(0)
;res@gsnRightString  = text1(1)
res@gsnStringFontHeightF    = 0.02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-1.2,-.9,-.6,.6,.9,1.2/)

res@mpFillOn               = False
;res@mpCenterLonF           = 60.
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
res@mpMinLonF    = lonL
res@mpMaxLonF    = lonR
    
res@lbOrientation = "vertical"
;res@lbLabelFontHeightF       = .022
res@pmLabelBarOrthogonalPosF = .003

res@tiMainString      = "Ks and its Difference"
res@tiMainFontHeightF = 0.023

res@tmXBLabelFontHeightF = .018
res@tmYLLabelFontHeightF = .018
;res@tmXBTickSpacingF     = 45.
plot0 = gsn_csm_contour_map (wks,diff,res)

;---------------------------------------------------------------
;plot climatology

res2 = True

res2@gsnDraw         = False
res2@gsnFrame        = False
res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnRightString  = " "
;res2@gsnContourNegLineDashPattern   = 1
res2@gsnContourLineThicknessesScale = 1.8

;res2@cnInfoLabelOn   = False
;res2@cnLineLabelsOn = False
res2@cnLabelDrawOrder = "PostDraw"
res2@cnLineLabelInterval = 1
res2@cnLineLabelDensityF = 0.2
res2@cnLineLabelFontHeightF = 0.013
res2@cnLineLabelPlacementMode = "Computed"
res2@cnInfoLabelFontHeightF = 0.013
res2@cnInfoLabelOrthogonalPosF = 0.32
res2@cnLevelSelectionMode = "ManualLevels"
res2@cnMinLevelValF       = 5.
res2@cnMaxLevelValF       = 7.
res2@cnLevelSpacingF      = 1.

plot1 = gsn_csm_contour (wks,ave1,res2)

;---------------------------------------------------------------
;probability plots
res3 = True
res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnRightString = " "

res3@cnLevelSelectionMode = "ManualLevels"
res3@cnMinLevelValF = 0.00
res3@cnMaxLevelValF = 0.10
res3@cnLevelSpacingF = 0.01
res3@cnInfoLabelOn = False
res3@cnLinesOn = False
res3@cnLineLabelsOn = False
res3@cnFillDotSizeF = 0.004
res3@cnFillScaleF = 1.8

plot2 = gsn_csm_contour (wks, prob, res3)
plot2 = ShadeLtContour (plot2, 0.055, 17)

overlay (plot0,plot2)
overlay (plot0,plot1)

draw (plot0)
frame (wks)

end
