;*************************************************************
;Aim: Draw climatologies of global seasonal geopotential height deviations from the zonal mean
;Mission:
;
;   1. Read data from hgt datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2016-05-22
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------hgt
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "hgt.mon.mean.nc"

;time
    yS     = 1979
    yE     = 2014
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;region
    latN = 40
    latS = 0
    lonL = -40
    lonR = 65

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_g_season_hgt_dev_zonal"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    hgt_file = addfile (in_path+in_name,"r")
;    hgt      = V_file->hgt(:,2,:,:)      ;850hPa
;    hgt      = V_file->hgt(:,5,:,:)      ;500hPa
    hgt      = hgt_file->hgt(:,8,:,:)      ;250hPa
    TIME     = hgt_file->time

    printVarSummary (hgt)
    printVarSummary (TIME)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   hgt_season = month_to_seasonN (hgt(iYYYY,:,:),season)
   printVarSummary (hgt_season)

;calculate deviation from zonal mean
   hgt_anom = dim_rmvmean_Wrap (hgt_season)
   printVarSummary (hgt_anom)

;compute seasonal climatologies
   hgt_clm = dim_avg_n_Wrap (hgt_anom,1)
   printVarSummary (hgt_clm)

;compute seasonal standard deviations
   hgtstd = dim_stddev_n_Wrap (hgt_anom,1)
   printVarSummary (hgtstd)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(4,graphic)      ;creat a plot array
 plot2 = new(4,graphic)      ;creat a plot array

;plot standard deviations
res = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame
res@gsnAddCyclic = True

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.       ;get the correct map
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
;res@mpMinLonF              = lonL
;res@mpMaxLonF              = lonR

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 9       ;set min contour level
res@cnMaxLevelValF       = 56      ;set max contour level
res@cnLevelSpacingF      = 9       ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.     ;label spacing

do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = season(i)
 if(i.eq.1) then
  res@gsnRightString = " "
 end if
 plot(i) = gsn_csm_contour_map_ce (wks,hgtstd(i,:,:),res)
end do

;---------------------------------------------------------------
;  plot climatologies

res2 = True

res2@gsnDraw                      = False   ;don't draw
res2@gsnFrame                     = False   ;don't advance frame
res2@gsnAddCyclic                 = True
res2@gsnLeftString                = " "
res2@gsnCenterString              = " "
res2@gsnRightString               = " "
res2@gsnContourZeroLineThicknessF = 3       ;sets thickness of zero contour
res2@gsnContourNegLineDashPattern = 1       ;sets negative contours to dash lines

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = -150             ;set min contour level
res2@cnMaxLevelValF       = 150              ;set max contour level
res2@cnLevelSpacingF      = 30               ;set contour spacing
res2@cnInfoLabelOn        = False
res2@cnLineDrawOrder      = "PostDraw"
res2@cnLabelDrawOrder     = "PostDraw"

;res2@cnLineLabelsOn = False   ;do not draw contour labels

do i=0,3
 plot2(i) = gsn_csm_contour (wks,hgt_clm(i,:,:),res2)
 overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa HGT Deviations from Zonal Mean"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True   ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
