;*************************************************************
;Aim: Draw variance of daily anomalous stream function deviations from zonal mean with 10-30-day bandpass filters and ratio of bandpass variance
;     to the unfiltered variance
;Mission:
;
;   1. Read data from U & V datasets
;   2. Post-post process to deserved results
;   3. Draw the variance and ratio
;                       He Shan
;                       2016-09-09
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

;the filter
    nwt    = 61
    fca    = 1./30.
    fcb    = 1./10.
    ihp1   = 2      ;band pass
    ihp2   = 0      ;low pass
    nsigma = 1.
    wts1   = filwgts_lanczos (nwt, ihp1, fca, fcb, nsigma)
    wts2   = filwgts_lanczos (nwt, ihp2, fcb, 1/999., nsigma)

;regiion
    latN = 65
    latS = 0
    lonW = -50
    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "variance_ratio_g_seasonal_daily_sf_anom_x_t_BP"

;text
    text1 = (/"a)","b)","c)","d)"/)
    text2 = (/"FMA","MJJ","ASO","NDJ"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis2
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files,"r")
    V_in = addfiles (V_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
;    U    = short2flt (V_file->hgt(:,2,:,:))                ;850hPa
;    U    = short2flt (V_file->hgt(:,5,:,:))                ;500hPa
    U    = short2flt (U_in[:]->uwnd(:,8,::-1,:))           ;250hPa
    V    = short2flt (V_in[:]->vwnd(:,8,::-1,:))
    TIME = U_in[:]->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME)

;create required yyyyddd
    YYYY    = cd_calendar (TIME,0)       ;for original data
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))
    day     = floattointeger (YYYY(:,2))
    ddd     = day_of_year (year, month, day) 
    yyyyddd = year*1000 + ddd            ;needed for input
    iMAM    = ind (month.ge.2 .and. month.le.4)
    iJJA    = ind (month.ge.5 .and. month.le.7)
    iSON    = ind (month.ge.8 .and. month.le.10)
    iDJF    = ind (month.le.1 .or.  month.ge.11)

    printVarSummary (yyyyddd)
    printVarSummary (iMAM)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;-------------------------------------------------------------
;calculate deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Compute daily climatology
   sfClmDay = clmDayTLL (sf_xAnom, yyyyddd)
   printVarSummary(sfClmDay)

;Compute daily anomalies
   sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   printVarSummary(sf_tAnom)

;-------------------------------------------------------------
;Compute unfiltered seasonal variances
   sf_LPF        = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts2,0)
   sf_var        = sf_LPF (:,:,0:3)
   sf_var(:,:,0) = dim_variance_Wrap ( sf_LPF(:,:,iMAM) ) 
   sf_var(:,:,1) = dim_variance_Wrap ( sf_LPF(:,:,iJJA) ) 
   sf_var(:,:,2) = dim_variance_Wrap ( sf_LPF(:,:,iSON) ) 
   sf_var(:,:,3) = dim_variance_Wrap ( sf_LPF(:,:,iDJF) ) 
   sf_var        = where(sf_var.eq.0,sf_var@_FillValue,sf_var)
   printVarSummary (sf_var)

;Compute filtered seasonal variances
   sf_BPF            = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts1,0)
   sf_BPF_var        = sf_BPF (:,:,0:3)
   sf_BPF_var(:,:,0) = dim_variance_Wrap ( sf_BPF(:,:,iMAM) ) 
   sf_BPF_var(:,:,1) = dim_variance_Wrap ( sf_BPF(:,:,iJJA) ) 
   sf_BPF_var(:,:,2) = dim_variance_Wrap ( sf_BPF(:,:,iSON) ) 
   sf_BPF_var(:,:,3) = dim_variance_Wrap ( sf_BPF(:,:,iDJF) ) 
   printVarSummary (sf_BPF_var)

;Compute ratio
   Ratio = sf_BPF_var
   do i=0,3
    Ratio(:,:,i) = ( sf_BPF_var(:,:,i)/sf_var(:,:,i) )*100
   end do
   printVarSummary (Ratio)

; ==============================================================
; Mission 3. Draw the variance and ratio
; ==============================================================

 wks  = gsn_open_wks("svg",out_path+out_name)
 plot = new(2,graphic)

;---------------------------------------------------------------
;plot ratio
res = True

res@gsnDraw        = False
res@gsnFrame       = False
res@gsnStringFontHeightF = .02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "sunshine_9lev"
;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 36
res@cnMaxLevelValF       = 56
res@cnLevelSpacingF      = 4

res@mpFillOn               = False
;res@mpCenterLonF           = 80.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.018
;res@tmXBTickSpacingF     = 45.     ;label spacing

/;
do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = text2(i)
 if (i.eq.3) then
  res@tmXBLabelsOn = True    ;draw lon labels
 else
  res@tmXBLabelsOn = False   ;do not draw lon labels
 end if
 plot(i) = gsn_csm_contour_map (wks,Ratio(:,:,i),res)
end do
;/

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(3)
res@gsnRightString  = "10^12"
res@tmXBLabelsOn    = False   ;do not draw lon labels
plot(0) = gsn_csm_contour_map (wks,Ratio(:,:,3),res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(0)
res@gsnRightString  = " "
res@tmXBLabelsOn    = True    ;draw lon labels
plot(1) = gsn_csm_contour_map (wks,Ratio(:,:,0),res)

;----------------------------------------------------------
;draw variance
ores               = True
ores@gsnDraw       = False
ores@gsnFrame      = False
ores@gsnAddCyclic  = True
ores@gsnLeftString = " "
ores@gsnContourLineThicknessesScale = 2

ores@cnLevelSelectionMode = "ExplicitLevels"
ores@cnLevels             = ispan(30,80,10 )
;ores@cnLabelDrawOrder = "PostDraw"
ores@cnLineLabelInterval = 1
ores@cnLineLabelDensityF = 0.4
ores@cnLineLabelFontHeightF = 0.01
ores@cnLineLabelPlacementMode = "computed"
ores@cnInfoLabelFontHeightF = 0.013
ores@cnInfoLabelOrthogonalPosF = 0.24

/;
do i=0,3
 if(i.eq.0)
  ores@cnInfoLabelOn = True
 else
  ores@cnInfoLabelOn = False
 end if
 plot_ov = gsn_csm_contour (wks,sf_BPF_var(:,:,i),ores)
 overlay (plot(i),plot_ov)

 delete(plot_ov)      ;will change next iteration
end do
;/

ores@cnInfoLabelOn = False
plot_ov1 = gsn_csm_contour (wks,sf_BPF_var(:,:,3),ores)
overlay (plot(0),plot_ov1)
ores@cnInfoLabelOn = True
plot_ov2 = gsn_csm_contour (wks,sf_BPF_var(:,:,0),ores)
overlay (plot(1),plot_ov2)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Variance of 250 hPa Daily SF Anomalies and its Ratio"   ;add common title
resP@txFontHeightF            = 0.028
resP@gsnPanelBottom           = 0.18
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.02
resP@pmLabelBarOrthogonalPosF = -0.006    ;move Label Bar down

gsn_panel(wks,plot,(/2,1/),resP)

end
