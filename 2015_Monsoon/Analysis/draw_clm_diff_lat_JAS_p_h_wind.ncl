;*************************************************************
;Aim: Draw climatologies and differences of global JAS pressure/height vectors across Sahel
;Mission:
;
;   1. Read data from U&OMEGA datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and difference
;                       He Shan
;                       2016-04-22
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
;   var2--------------omega
;================================================

    nyear = 16      ;number of the years used

    season = "JAS"      ;choose seasonal mean

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_diff_lat_JAS_p_h_wind"

;text
    Text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
;    U_file = addfile("~/data/observation/NCEP_NCAR/monthly/NC_uwnd.mon.mean.nc","r")
;    W_file = addfile("~/data/observation/NCEP_NCAR/monthly/NC_omega.mon.mean.nc","r")
;    U      = U_file->uwnd(:,0:11,{5:25},:)
;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file = addfile("~/data/observation/NOAA_CIRES/20CR-V2_uwnd.mon.mean.nc","r")
    W_file = addfile("~/data/observation/NOAA_CIRES/20CR-V2_omega.mon.mean.nc","r")
    U      = U_file->uwnd(:,0:18,{5:25},:)
    W      = W_file->omega(:,:,{5:25},:)
    TIME   = U_file->time

    U = lonPivot(U, 290)   ;reorder
    W = lonPivot(W, 290)

    printVarSummary(U)
    printVarSummary(W)
    printVarSummary(TIME)

;get the time indexs
    YYYY     = cd_calendar(TIME,-1)/100          ;for original data
    iYYYY_1  = ind(YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYY_2  = ind(YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;*******************************************
;compute pressure/height vectors
;*******************************************
;compute seasonal means and meridional means
   U_JAS_1 = dim_avg_n_Wrap( month_to_season(U(iYYYY_1,:,:,:),season) ,2)
   W_JAS_1 = dim_avg_n_Wrap( month_to_season(W(iYYYY_1,:,:,:),season) ,2)

   U_JAS_2 = dim_avg_n_Wrap( month_to_season(U(iYYYY_2,:,:,:),season) ,2)
   W_JAS_2 = dim_avg_n_Wrap( month_to_season(W(iYYYY_2,:,:,:),season) ,2)

; Omega is significantly smaller than v, so we will scale it so that some vertical motion is visible
   W_JAS_1 = -200*W_JAS_1      ;now scale
   W_JAS_2 = -200*W_JAS_2      ;now scale

   printVarSummary(U_JAS_1)
   printVarSummary(W_JAS_1)

;--------------------------------------------------------------
;compute 3 monthly climatologies
   Uave50 = dim_avg_n_Wrap(U_JAS_1,0)
   Ustd50 = dim_stddev_n_Wrap(U_JAS_1,0)
   Uave80 = dim_avg_n_Wrap(U_JAS_2,0)
   Ustd80 = dim_stddev_n_Wrap(U_JAS_2,0)

   Wave50 = dim_avg_n_Wrap(W_JAS_1,0)
   Wstd50 = dim_stddev_n_Wrap(W_JAS_1,0)
   Wave80 = dim_avg_n_Wrap(W_JAS_2,0)
   Wstd80 = dim_stddev_n_Wrap(W_JAS_2,0)

   printVarSummary(Uave50)
   printVarSummary(Ustd50)
   printVarSummary(Wave50)
   printVarSummary(Wstd50)

;compute annual climatologies
   U_clm = Uave50
   W_clm = Wave50
   U_clm = Uave50 + Uave80
   W_clm = Wave50 + Wave80
   printVarSummary(U_clm)
   printVarSummary(W_clm)

;---------------------------------------------------------------
;copy meta data
   diff_U = Uave50
   diff_W = Wave50

;compute probabilities for means difference
   prob_U = ttest(Uave80,Ustd80^2,nyear,Uave50,Ustd50^2,nyear,False,False)
   prob_W = ttest(Wave80,Wstd80^2,nyear,Wave50,Wstd50^2,nyear,False,False)
   copy_VarCoords_1(Uave50,prob_U)
   copy_VarCoords_1(Wave50,prob_W)

;compute differences
   diff_U = Uave80-Uave50
   diff_W = Wave80-Wave50

   printVarSummary(prob_U)
   printVarSummary(diff_U)
   printVarSummary(prob_W)
   printVarSummary(diff_W)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(2,graphic)       ;creat a plot array

;*******************************************
;  plot climatologies
;*******************************************
res              = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame

res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels
res@cnInfoLabelOn  = False      ;turn off contour information label

res@vcRefLengthF            = 0.05            ;the length of the reference magnitude
res@vcRefMagnitudeF         = 7               ;the magnitude used as the reference magnitude
res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.01
res@vcLineArrowThicknessF   = 1.5
res@vcMapDirection          = False           ;vectors to be pointing in the right direction
res@vcRefAnnoOn             = False           ;turn on vector reference box

res@vpHeightF = 0.3        ;change aspect ratio of plot
res@vpClipOn  = False      ;turn off vector clipping

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@gsnRightString = " "
res@gsnLeftString  = Text1(0)
res@vcMinDistanceF = 0.05            ;the minimum distance of neighboring vectors
plot(0) = gsn_csm_pres_hgt_vector(wks,U_clm,U_clm,W_clm,res)

;*******************************************
;  plot differences
;*******************************************
res@gsnLeftString  = Text1(1)
;res@gsnRightString = "90% stippled"

;res@vcRefMagnitudeF = 4         ;the magnitude used as the reference magnitude
res@vcMinDistanceF  = 0.03      ;the minimum distance of neighboring vectors

;diff_U = mask (diff_U,(prob_U.le.0.1).or.(prob_W.le.0.1),True)   ;draw all areas < 0.05 contour
;diff_W = mask (diff_W,(prob_U.le.0.1).or.(prob_W.le.0.1),True)

plot(1) = gsn_csm_pres_hgt_vector(wks,U_clm,diff_U,diff_W,res)

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "Lat "+" Pressure/Height "+season+" Vector Climatologies and Differences"   ;add common title

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
