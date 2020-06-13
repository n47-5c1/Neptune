;*************************************************************
;Aim: Draw climatologies of global seasonal meridional winds
;Mission:
;
;   1. Read data from V datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2016-05-18
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "vwnd.mon.mean.nc"

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
    out_name = "clm_g_season_V"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    V_file = addfile (in_path+in_name,"r")
;    V      = V_file->vwnd(:,2,:,:)      ;850hPa
;    V      = V_file->vwnd(:,5,:,:)      ;500hPa
    V      = V_file->vwnd(:,8,:,:)      ;250hPa
    TIME   = V_file->time

    printVarSummary (V)
    printVarSummary (TIME)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   V_season = month_to_seasonN (V(iYYYY,:,:),season)
   printVarSummary (V_season)

;compute seasonal climatologies
   V_clm = dim_avg_n_Wrap (V_season,1)
   printVarSummary (V_clm)

;compute seasonal standard deviations
   Vstd = dim_stddev_n_Wrap (V_season,1)
   printVarSummary (Vstd)

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
res@cnMinLevelValF       = .5       ;set min contour level
res@cnMaxLevelValF       = 4.5      ;set max contour level
res@cnLevelSpacingF      = 0.5      ;set contour spacing

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
 plot(i) = gsn_csm_contour_map_ce (wks,Vstd(i,:,:),res)
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
res2@cnMinLevelValF       = -12.             ;set min contour level
res2@cnMaxLevelValF       = 12.              ;set max contour level
res2@cnLevelSpacingF      = 1.5              ;set contour spacing
res2@cnInfoLabelOn        = False
res2@cnLineDrawOrder      = "PostDraw"
res2@cnLabelDrawOrder     = "PostDraw"

;res2@cnLineLabelsOn = False   ;do not draw contour labels

do i=0,3
 plot2(i) = gsn_csm_contour (wks,V_clm(i,:,:),res2)
 overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa Meridional Wind"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True   ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
