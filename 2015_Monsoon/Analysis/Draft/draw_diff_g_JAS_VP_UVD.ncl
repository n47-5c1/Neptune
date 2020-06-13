;*************************************************************
;Aim: Draw differences of global JAS velocity potential and divergent wind for each levels
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the differences
;                       He Shan
;                       2015-05-01
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

    level = (/"1000","925","850","700","600","500","400","300","250","200","150","100","70","50","30","20","10"/)
    nlev  = (/8,1/)

    season = "JAS"      ;choose seasonal mean

;time
    yS1 = 1960
    yE1 = 1969
    yS2 = 1980
    yE2 = 1989

;fig
    out_path = "~/hes/Sahel_Rainfall/final/"
    out_name = "diff_g_JAS_VP_UVD"

;text
    Text1 = (/"a)","b)"/)

;Region
    latN=45
    latS=-15
    lonL=-25
    lonR=145

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file  = addfile ("~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc","r")
    V_file  = addfile ("~/data/observation/NCEP_NCAR/monthly/vwnd.mon.mean.nc","r")
    PS_file = addfile ("~/data/observation/NCEP_NCAR/monthly/pres.mon.mean.nc","r")

    U      = U_file->uwnd(:,nlev,::-1,:)
    V      = V_file->vwnd(:,nlev,::-1,:)
    PS     = PS_file->pres(:,::-1,:)
    TIME   = V_file->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (PS)
    printVarSummary (TIME)

;get the time indexs
    YYYY     = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY    = ind (YYYY.ge.yS1 .and. YYYY.le.yE2)
    iYYYY_S  = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYY_E  = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   U_JAS_S = month_to_season ( U(iYYYY_S,:,:,:) ,season)
   U_JAS_E = month_to_season ( U(iYYYY_E,:,:,:) ,season)
   V_JAS_S = month_to_season ( V(iYYYY_S,:,:,:) ,season)
   V_JAS_E = month_to_season ( V(iYYYY_E,:,:,:) ,season)
   PS_JAS  = month_to_season ( PS(iYYYY,:,:) ,season)
   dim = dimsizes (U_JAS_S)
   printVarSummary (U_JAS_S)
   printVarSummary (V_JAS_S)
   printVarSummary (PS_JAS)

;*******************************************
;computes the divergence and the divergent wind
;*******************************************
   dv_S  = uv2dvG_Wrap (U_JAS_S,V_JAS_S)
   dv_E  = uv2dvG_Wrap (U_JAS_E,V_JAS_E)
   uvd_S = dv2uvG_Wrap (dv_S)
   uvd_E = dv2uvG_Wrap (dv_E)

;--------------------------------------------------------------
;compute seasonal climatologies
   UVDaveS = dim_avg_n_Wrap (uvd_S,1)
   UVDaveE = dim_avg_n_Wrap (uvd_E,1)
   PSave   = dim_avg_n_Wrap (PS_JAS,0)
   UVDstdS = dim_stddev_n_Wrap (uvd_S,1)
   UVDstdE = dim_stddev_n_Wrap (uvd_E,1)

   printVarSummary (UVDaveS)
   printVarSummary (UVDstdS)
   printVarSummary (PSave)

;---------------------------------------------------------------
;copy meta data
   diff_uvd = UVDaveS
;compute probabilities for means difference
   prob_uvd = ttest (UVDaveS,UVDstdS^2,dim(0),UVDaveE,UVDstdE^2,dim(0),False,False)
   copy_VarCoords (UVDaveS,prob_uvd)
;compute differences
   diff_uvd = UVDaveE - UVDaveS

   printVarSummary (prob_uvd)
   printVarSummary (diff_uvd)

;*******************************************
;compute stream function and velocity potential
;*******************************************
   sfvp_S = uv2sfvpG (U_JAS_S,V_JAS_S)
   sfvp_E = uv2sfvpG (U_JAS_E,V_JAS_E)

   sfvp_S!0 = "func"
   sfvp_S!1 = "time"
   sfvp_S!2 = "level"
   sfvp_S!3 = "lat"
   sfvp_S!4 = "lon"
   sfvp_S_r = sfvp_S(time|:,level|:,lat|:,lon|:,func|:)      ;recorder the input data
   copy_VarCoords_1(U_JAS_S,sfvp_S_r)
   sfvp_S_r&lon   = U_JAS_S&lon
   sfvp_S   = sfvp_S_r (func|:,time|:,level|:,lat|:,lon|:)      ;recorder the input data

   sfvp_E!0 = "func"
   sfvp_E!1 = "time"
   sfvp_E!2 = "level"
   sfvp_E!3 = "lat"
   sfvp_E!4 = "lon"
   sfvp_E_r = sfvp_E(time|:,level|:,lat|:,lon|:,func|:)      ;recorder the input data
   copy_VarCoords_1(U_JAS_E,sfvp_E_r)
   sfvp_E_r&lon   = U_JAS_E&lon
   sfvp_E   = sfvp_E_r (func|:,time|:,level|:,lat|:,lon|:)      ;recorder the input data

   printVarSummary (sfvp_S)
   printVarSummary (sfvp_E)

;--------------------------------------------------------------
;compute 3 monthly climatologies
   SFVPaveS = dim_avg_n_Wrap (sfvp_S,1)
   SFVPaveE = dim_avg_n_Wrap (sfvp_E,1)

   printVarSummary(SFVPaveS)

;---------------------------------------------------------------
;copy meta data
   diff_sfvp = SFVPaveS
;compute differences
   diff_sfvp = SFVPaveE-SFVPaveS

   printVarSummary(diff_sfvp)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
 plot = new(2,graphic)                           ; creat a plot array

;*******************************************
res                  = True

res@gsnDraw          = False      ;don't draw
res@gsnFrame         = False      ;don't advance frame
res@gsnScalarContour = True       ;contours desired

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False        ;turn off cn line labels
res@cnFillPalette  = "MPL_RdBu"   ;choose a colormap

res@tiMainString      = "Differences in JAS Divergent Wind"   ;add title
res@tiMainFontHeightF = 0.035    ;change font heights

;res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcRefLengthF            = 0.075           ;the length of the reference magnitude
res@vcMinDistanceF          = 0.04            ;the minimum distance of neighboring vectors
res@vcRefMagnitudeF         = 2               ;the magnitude used as the reference magnitude
res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcLineArrowThicknessF   = 1.4
res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.01
res@vcRefAnnoOrthogonalPosF = -0.168          ;move ref vector

res@vpXF      = 0.14   ;position and size for contour plots
res@vpWidthF  = 0.80
res@vpHeightF = 0.30

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

symMinMaxPlt(diff_sfvp(1,:,{latS:latN},{lonL:lonR}),10,False,res)      ;to have a common label bar
res@lbLabelBarOn = False

res@mpGeophysicalLineColor = "gray30"     ;change the colour of ontlines
res@mpFillOn               = False        ;turn off map fill
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

diff_uvd(0,:,:,:) = mask (diff_uvd(0,:,:,:),(prob_uvd(0,:,:,:).le.0.05).or.(prob_uvd(1,:,:,:).le.0.05),True)   ;draw all areas < 0.01 contour
diff_uvd(1,:,:,:) = mask (diff_uvd(1,:,:,:),(prob_uvd(0,:,:,:).le.0.05).or.(prob_uvd(1,:,:,:).le.0.05),True)

diff_uvd(0,1,:,:) = mask (diff_uvd(0,1,:,:),PSave.ge.925.,True)   ;draw all areas beyond topography
diff_uvd(1,1,:,:) = mask (diff_uvd(1,1,:,:),PSave.ge.925.,True)

do i=0,1
 if (i.eq.0) then      ;turn on the buttom individual cb's
  res@gsnCenterString = level(nlev(i))+"hPa   95%"
  res@gsnRightString  = "m/s"
  res@vcRefAnnoOn     = False   ;not draw the reference vector annotation
  res@vpYF            = 0.86    ;position and size for contour plots
 else
  res@gsnCenterString = level(nlev(i))+"hPa"
  res@gsnRightString  = " "
  res@vcRefAnnoOn     = True   ;not draw the reference vector annotation
  res@vpYF            = 0.44   ;position and size for contour plots
  res@lbLabelBarOn    = True
  res@pmLabelBarOrthogonalPosF = 0.25   ;move Label Bar down
  delete(res@tiMainString)
 end if
 res@gsnLeftString   = Text1(i)
 plot(i) = gsn_csm_vector_scalar_map_ce(wks,diff_uvd(0,i,:,:),diff_uvd(1,i,:,:),diff_sfvp(1,i,:,:),res)
end do

;---------------------------------------------------------------
;mask plots
res2                      = True

res2@gsnDraw              = False            ;don't draw
res2@gsnFrame             = False            ;don't advance frame
res2@gsnLeftString        = " "
res2@gsnRightString       = " "
res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 925.             ;set min contour level
res2@cnMaxLevelValF       = 925.             ;set max contour level
res2@cnLevelSpacingF      = 1.               ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillScaleF   = 2       ;add extra density
res2@cnFillColor    = "grey"

plot2 = gsn_csm_contour (wks,PSave,res2)
plot2 = ShadeLtContour (plot2,925.5,0)      ;shade all areas < 0.055 contour
overlay (plot(1),plot2)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
maximize_output(wks,resP)

;resP@gsnPanelDebug  = True
;resP@txFontHeightF    = 0.04       ;height of text
;resP@txString         = "Differences in JAS Divergent Wind"   ;add common title
;resP@gsnPanelLabelBar = True       ;add common colorbar

;gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
