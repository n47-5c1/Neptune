;*************************************************************
;Aim: Draw climatologies and differences of global JAS vectors for each levels
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and differences
;                       He Shan
;                       2015-03-20
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
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "NC_prate.sfc.mon.mean.nc"

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981
    season = "JAS"      ;choose seasonal mean

;region
    latN = 40
    latS = -20
    lonL = -40
    lonR = 65

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_diff_g_JAS_PREC"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    PREC_file = addfile (in_path+in_name,"r")
    PREC      = PREC_file->prate
    TIME      = PREC_file->time

    printVarSummary (PREC)
    printVarSummary (TIME)

;get the time indexs
    YYYY     = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY_C  = ind (YYYY.ge.yS1 .and. YYYY.le.yE2)

    TIME_r   = TIME(iYYYY_C)
    YYYY_JAS = cd_calendar (TIME_r(8::12),-1)/100   ;for seasonal means data
    iYYYY_1  = ind (YYYY_JAS.ge.yS1 .and. YYYY_JAS.le.yE1)
    iYYYY_2  = ind (YYYY_JAS.ge.yS2 .and. YYYY_JAS.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   PREC_JAS = month_to_season (PREC(iYYYY_C,:,:),season)
   dim      = dimsizes (PREC_JAS)
   printVarSummary (PREC_JAS)

;compute annual climatologies
   PREC_clm = dim_avg_n_Wrap (PREC_JAS,0)
   printVarSummary (PREC_clm)

;--------------------------------------------------------------
;compute 3 monthly climatologies
   PRECave50 = dim_avg_n_Wrap (PREC_JAS(iYYYY_1,:,:),0)
   PRECstd50 = dim_stddev_n_Wrap (PREC_JAS(iYYYY_1,:,:),0)
   PRECave80 = dim_avg_n_Wrap (PREC_JAS(iYYYY_2,:,:),0)
   PRECstd80 = dim_stddev_n_Wrap (PREC_JAS(iYYYY_2,:,:),0)

   printVarSummary (PRECave50)
   printVarSummary (PRECstd50)

;---------------------------------------------------------------
;copy meta data
   prob = PRECave50
   diff = PRECave50

;compute probabilities for means difference
   prob = ttest (PRECave80,PRECstd80^2,dim(0),PRECave50,PRECstd50^2,dim(0),False,False)

;compute differences
   diff = PRECave80 - PRECave50

   printVarSummary (prob)
   printVarSummary (diff)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(2,graphic)      ;creat a plot array

;*******************************************
;  plot climatologies
;*******************************************
res                 = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
res@gsnLeftString   = text1(0)
;res@gsnCenterString = " "

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False   ;turn off cn line labels
res@cnFillPalette  = "WhiteBlue"   ;choose a colormap

res@mpFillOn     = False      ;turn off map fill
res@mpCenterLonF = 110.       ;get the correct map
;map outlines
;res@mpMinLatF    = latS
;res@mpMaxLatF    = latN
;res@mpMinLonF    = lonL
;res@mpMaxLonF    = lonR

;to have a common label bar
;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF       = 1.5           ;set min contour level
;res@cnMaxLevelValF       = 10.5            ;set max contour level
;res@cnLevelSpacingF      = 0.25           ;set contour spacing

res@pmLabelBarOrthogonalPosF = 0.2   ;move Label Bar down

res@tiMainString      = "Climatology and Differences of JAS Rainfall"   ;add title
res@tiMainFontHeightF = 0.035    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@vpXF      = 0.14   ;position and size for contour plots
res@vpYF      = 0.86
;res@vpWidthF  = 0.70
res@vpHeightF = 0.31

plot(0) = gsn_csm_contour_map_ce (wks,PREC_clm,res)

;*******************************************
;  plot differences
;*******************************************
res@gsnLeftString   = text1(1)
res@gsnCenterString = "99%"
res@gsnRightString  = " "

res@tiMainString      = " "   ;add title

res@cnFillPalette = "MPL_RdBu"     ;choose a colormap
symMinMaxPlt (diff,16,False,res)   ;to have a common label bar

res@vpYF = 0.44   ;position and size for contour plots

plot(1) = gsn_csm_contour_map_ce (wks,diff,res)

;---------------------------------------------------------------
;probability plots

res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00             ;set min contour level
res2@cnMaxLevelValF       = 0.10             ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.01    ;set a uniform dot size
res2@cnFillScaleF   = 0.5     ;add extra density

plot2 = gsn_csm_contour (wks,prob,res2)
plot2 = ShadeLtContour (plot2,0.015,17)      ;shade all areas < 0.015 contour
overlay (plot(1),plot2)

;*******************************************
;create panel resources
;*******************************************
resP          = True
maximize_output(wks,resP)
;resP@txString = "Global "+season+" Climatologies and Differences of Wind Vectors"   ;add common title

;gsn_panel(wks,plot,(/3,2/),resP)

end
