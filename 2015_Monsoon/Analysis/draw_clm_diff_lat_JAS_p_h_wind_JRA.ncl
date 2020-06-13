;*************************************************************
;Aim: Draw climatologies and differences of global JAS pressure/height vectors across Sahel
;Mission:
;
;   1. Read data from U&OMEGA datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and difference
;                       He Shan
;                       2015-04-22
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------UGRD_GDS0_ISBL_S123
;   var2--------------VVEL_GDS0_ISBL_S123
;================================================

    nyear = 10      ;number of the years used

    season = "JAS"      ;choose seasonal mean

;time
    yS1 = 1958
    yE1 = 1967
    yS2 = 1968
    yE2 = 1977

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_diff_lat_JAS_p_h_wind_JRA"

;text
    Text1 = (/"a)","b)"/)
    Text2 = "6877-5867"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;JRA-55 1958-01~2012-12
    U_files = systemfunc ("ls ~/data/observation/JRA/JRA-55/*033_ugrd*")
    W_files = systemfunc ("ls ~/data/observation/JRA/JRA-55/*039_vvel*")
	
    U_in = addfiles (U_files, "r")   ;note the "s" of addfile
    W_in = addfiles (W_files, "r")
    ListSetType (U_in, "cat")   ;concatenate or "merge" (default)
    ListSetType (W_in, "cat")

    U    = U_in[:]->UGRD_GDS0_ISBL_S123(:,{1000:100},{0:30},:)
    W    = W_in[:]->VVEL_GDS0_ISBL_S123(:,{1000:100},{0:30},:)
    TIME = U_in[:]->initial_time0_hours

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

   Wave50 = dim_avg_n_Wrap(W_JAS(iYYYY_1,:,:),0)
   Wstd50 = dim_stddev_n_Wrap(W_JAS(iYYYY_1,:,:),0)
   Wave80 = dim_avg_n_Wrap(W_JAS(iYYYY_2,:,:),0)
   Wstd80 = dim_stddev_n_Wrap(W_JAS(iYYYY_2,:,:),0)

   printVarSummary(Uave50)
   printVarSummary(Ustd50)
   printVarSummary(Wave50)
   printVarSummary(Wstd50)

;---------------------------------------------------------------
;copy meta data
   prob_U = Uave50
   diff_U = Uave50
   prob_W = Wave50
   diff_W = Wave50

;compute probabilities for means difference
   prob_U = ttest(Uave80,Ustd80^2,nyear,Uave50,Ustd50^2,nyear,False,False)
   prob_W = ttest(Wave80,Wstd80^2,nyear,Wave50,Wstd50^2,nyear,False,False)

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
res@gsnLeftString   = Text1(1)
res@gsnCenterString = Text2
res@gsnRightString  = "95%"

res@vcRefMagnitudeF = 4         ;the magnitude used as the reference magnitude
res@vcMinDistanceF  = 0.02      ;the minimum distance of neighboring vectors

diff_U = mask (diff_U,(prob_U.le.0.05).or.(prob_W.le.0.05),True)   ;draw all areas < 0.05 contour
diff_W = mask (diff_W,(prob_U.le.0.05).or.(prob_W.le.0.05),True)

plot(1) = gsn_csm_pres_hgt_vector(wks,U_clm,diff_U,diff_W,res)

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "Pressure/Height "+season+" Vector Climatologies and Differences"   ;add common title

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
