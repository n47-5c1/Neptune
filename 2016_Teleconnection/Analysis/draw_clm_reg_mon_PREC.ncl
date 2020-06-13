;*************************************************************
;Aim: Draw climatologies of Afro-Eurasia monthly precipitation
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2017-01-18
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------prate
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/monthly/"
    in_name = "prate.sfc.mon.mean.nc"
    prate2p = 60*60*24      ;kg/(m^2*s) -> mm/day

;time
    yE     = 2015
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;region
    latN = 60
    latS = -10
    lonL = -40
    lonR = 160

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_reg_mon_PREC"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis
    P_file = addfile (in_path+in_name,"r")
    P_p    = P_file->prate
    P      = short2flt (P_p)
    P      = prate2p*P
    TIME   = P_file->time
    printVarSummary (P)
    printVarSummary (TIME)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY = ind (YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute seasonal means
   P_season = month_to_seasonN (P(iYYYY,:,:),season)
   printVarSummary (P_season)

;compute seasonal climatologies
   P_clm = dim_avg_n_Wrap (P_season,1)
   printVarSummary (P_clm)

;compute seasonal standard deviations
   Pstd = dim_stddev_n_Wrap (P_season,1)
   printVarSummary (Pstd)

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
;res@gsnAddCyclic   = True

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False         ;turn off cn line labels
res@cnFillPalette  = "hotres"      ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.       ;get the correct map
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 1.       ;set min contour level
res@cnMaxLevelValF       = 10.      ;set max contour level
res@cnLevelSpacingF      = 1.       ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.    ;label spacing

do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = season(i)
 res@gsnRightString  = "mm/day"
 if(i.ne.0) then
  res@gsnRightString  = " "
 end if
 plot(i) = gsn_csm_contour_map_ce (wks,P_clm(i,:,:),res)
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

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 2.               ;set min contour level
res2@cnMaxLevelValF       = 6.               ;set max contour level
res2@cnLevelSpacingF      = 2.               ;set contour spacing
res2@cnInfoLabelOn        = False

;res2@cnLineLabelsOn = False   ;do not draw contour labels

do i=0,3
 plot2(i) = gsn_csm_contour (wks,Pstd(i,:,:),res2)
; overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of Precipitation"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True       ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002     ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
