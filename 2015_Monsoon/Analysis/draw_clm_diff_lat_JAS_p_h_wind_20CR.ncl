;*************************************************************
;Aim: Draw climatologies and differences of global JAS pressure/height vectors across Sahel
;Mission:
;
;   1. Read data from U&OMEGA datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and difference
;                       He Shan
;                       2015-04-20
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

    ndiff = 3       ;number of the differences
    nyear = 15      ;number of the years used

    season = "JAS"      ;choose seasonal mean

;time
    yS1 = 1951
    yE1 = 1965
    yS2 = 1971
    yE2 = 1985
    yS3 = 1996
    yE3 = 2010

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_diff_lat_JAS_p_h_wind_20CR"

;text
    Text1 = (/"a)","b)","c)","d)"/)
    Text2 = (/"7185-5165: ","9610-5165: ","9610-7185: "/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file = addfile("~/data/observation/NOAA_CIRES/20CR-V2_uwnd.mon.mean.nc","r")
    W_file = addfile("~/data/observation/NOAA_CIRES/20CR-V2_omega.mon.mean.nc","r")
    U      = U_file->uwnd(:,0:18,{0:30},:)
    W      = W_file->omega(:,:,{0:30},:)
    TIME   = U_file->time

    U = lonPivot(U, 290)   ;reorder
    W = lonPivot(W, 290)

    printVarSummary(U)
    printVarSummary(W)
    printVarSummary(TIME)

;get the time indexs
    YYYY     = cd_calendar(TIME,-1)/100          ;for original data
    YYYY_JAS = cd_calendar(TIME(8::12),-1)/100   ;for seasonal means data
    iYYYY_1  = ind(YYYY_JAS.ge.yS1 .and. YYYY_JAS.le.yE1)
    iYYYY_2  = ind(YYYY_JAS.ge.yS2 .and. YYYY_JAS.le.yE2)
    iYYYY_3  = ind(YYYY_JAS.ge.yS3 .and. YYYY_JAS.le.yE3)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;*******************************************
;compute pressure/height vectors
;*******************************************
;compute seasonal means and meridional means
   U_JAS = dim_avg_n_Wrap( month_to_season(U,season) ,2)
   W_JAS = dim_avg_n_Wrap( month_to_season(W,season) ,2)

; Omega is significantly smaller than v, so we will scale it so that some vertical motion is visible
   W_JAS = -200*W_JAS      ;now scale

   printVarSummary(U_JAS)
   printVarSummary(W_JAS)

;compute annual climatologies
   U_clm = dim_avg_n_Wrap(U_JAS,0)
   W_clm = dim_avg_n_Wrap(W_JAS,0)
   printVarSummary(U_clm)
   printVarSummary(W_clm)

;--------------------------------------------------------------
;compute 3 monthly climatologies
   Uave50 = dim_avg_n_Wrap(U_JAS(iYYYY_1,:,:),0)
   Ustd50 = dim_stddev_n_Wrap(U_JAS(iYYYY_1,:,:),0)
   Uave80 = dim_avg_n_Wrap(U_JAS(iYYYY_2,:,:),0)
   Ustd80 = dim_stddev_n_Wrap(U_JAS(iYYYY_2,:,:),0)
   Uave00 = dim_avg_n_Wrap(U_JAS(iYYYY_3,:,:),0)
   Ustd00 = dim_stddev_n_Wrap(U_JAS(iYYYY_3,:,:),0)

   Wave50 = dim_avg_n_Wrap(W_JAS(iYYYY_1,:,:),0)
   Wstd50 = dim_stddev_n_Wrap(W_JAS(iYYYY_1,:,:),0)
   Wave80 = dim_avg_n_Wrap(W_JAS(iYYYY_2,:,:),0)
   Wstd80 = dim_stddev_n_Wrap(W_JAS(iYYYY_2,:,:),0)
   Wave00 = dim_avg_n_Wrap(W_JAS(iYYYY_3,:,:),0)
   Wstd00 = dim_stddev_n_Wrap(W_JAS(iYYYY_3,:,:),0)

   printVarSummary(Uave50)
   printVarSummary(Ustd50)
   printVarSummary(Wave50)
   printVarSummary(Wstd50)

;---------------------------------------------------------------
;copy meta data
   dim_U  = dimsizes(Uave50)
   prob_U = new((/dim_U(0),dim_U(1),ndiff/),float)
   diff_U = new((/dim_U(0),dim_U(1),ndiff/),float)
   copy_VarCoords_1(Uave50,prob_U)
   copy_VarCoords_1(Uave50,diff_U)
   copy_VarAtts(Uave50,diff_U)
   prob_U!1    = "lon"
   prob_U&lon  = Uave50&lon
   diff_U!1    = "lon"
   diff_U&lon  = Uave50&lon

   prob_W = new((/dim_U(0),dim_U(1),ndiff/),float)
   diff_W = new((/dim_U(0),dim_U(1),ndiff/),float)
   copy_VarCoords_1(Wave50,prob_W)
   copy_VarCoords_1(Wave50,diff_W)
   copy_VarAtts(Wave50,diff_W)
   prob_W!1    = "lon"
   prob_W&lon  = Wave50&lon
   diff_W!1    = "lon"
   diff_W&lon  = Wave50&lon

;compute probabilities for means difference
   prob_U(:,:,0) = ttest(Uave80,Ustd80^2,nyear,Uave50,Ustd50^2,nyear,False,False)
   prob_U(:,:,1) = ttest(Uave00,Ustd00^2,nyear,Uave50,Ustd50^2,nyear,False,False)
   prob_U(:,:,2) = ttest(Uave00,Ustd00^2,nyear,Uave80,Ustd80^2,nyear,False,False)

   prob_W(:,:,0) = ttest(Wave80,Wstd80^2,nyear,Wave50,Wstd50^2,nyear,False,False)
   prob_W(:,:,1) = ttest(Wave00,Wstd00^2,nyear,Wave50,Wstd50^2,nyear,False,False)
   prob_W(:,:,2) = ttest(Wave00,Wstd00^2,nyear,Wave80,Wstd80^2,nyear,False,False)

;compute differences
   diff_U(:,:,0) = Uave80-Uave50
   diff_U(:,:,1) = Uave00-Uave50
   diff_U(:,:,2) = Uave00-Uave80

   diff_W(:,:,0) = Wave80-Wave50
   diff_W(:,:,1) = Wave00-Wave50
   diff_W(:,:,2) = Wave00-Wave80

   printVarSummary(prob_U)
   printVarSummary(diff_U)
   printVarSummary(prob_W)
   printVarSummary(diff_W)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(4,graphic)       ;creat a plot array

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
res@vcRefMagnitudeF         = 10              ;the magnitude used as the reference magnitude
res@vcMinDistanceF          = 0.04            ;the minimum distance of neighboring vectors
res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcRefAnnoOrthogonalPosF = -1.095          ;move ref vector
res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.008
res@vcLineArrowThicknessF   = 1.5
res@vcMapDirection          = False           ;vectors to be pointing in the right direction
;res@vpClipOn                = False           ;turn off vector clipping

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@gsnRightString = " "
res@gsnLeftString  = Text1(0)
plot(0) = gsn_csm_pres_hgt_vector(wks,U_clm,U_clm,W_clm,res)

;*******************************************
;  plot differences
;*******************************************
res@gsnRightString = "95%"

res@vcRefMagnitudeF = 4         ;the magnitude used as the reference magnitude
res@vcMinDistanceF  = 0.02      ;the minimum distance of neighboring vectors

diff_U = mask (diff_U,(prob_U.le.0.05).or.(prob_W.le.0.05),True)   ;draw all areas < 0.05 contour
diff_W = mask (diff_W,(prob_U.le.0.05).or.(prob_W.le.0.05),True)

do i=0,ndiff-1
 res@gsnLeftString   = Text1(i+1)
 res@gsnCenterString = Text2(i)
 plot(i+1) = gsn_csm_pres_hgt_vector(wks,U_clm,diff_U(:,:,i),diff_W(:,:,i),res)
end do

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "Lat "+" Pressure/Height "+season+" Vector Climatologies and Differences"   ;add common title

gsn_panel(wks,plot,(/2,2/),resP)          ; create panel

end
