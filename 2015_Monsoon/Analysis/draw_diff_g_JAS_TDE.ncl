;*************************************************************
;Aim: Draw climatology and differences of global JAS thermodynamic energy for 700hPa
;Mission:
;
;   1. Read data from U, V, OMEGA, and T datasets
;   2. Post-post process to deserved results
;   3. Draw the differences
;                       He Shan
;                       2015-11-27
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
;   var2--------------omega
;   var2--------------air
;================================================

    level = (/"1000","925","850","700","600","500","400","300","250","200","150","100","70","50","30","20","10"/)
    nlev  = 3

    season = "JAS"      ;choose seasonal mean

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981

;data
    cp = 1.006     ;kJ/(kg*K)
    p0 = 1000.     ;hPa
    R  = 0.28704   ;kJ/(kg*K)
    k  = R/cp

    R      = 6378388.    ;m
    deg2pi = 0.0174533   ;2*pi/360
    per_s2day = 60.*60.*24.

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "diff_g_JAS_TDE"

;text
    Text1 = (/"a)","b)","c)","d)"/)

;Region
    latN=60.
    latS=-60.
    lonL=-25.
    lonR=145.

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file = addfile ("~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc","r")
    V_file = addfile ("~/data/observation/NCEP_NCAR/monthly/vwnd.mon.mean.nc","r")
    W_file = addfile ("~/data/observation/NCEP_NCAR/monthly/omega.mon.mean.nc","r")
    T_file = addfile ("~/data/observation/NCEP_NCAR/monthly/air.mon.mean.nc","r")
    U      = U_file->uwnd(:,nlev,:,:)
    V      = V_file->vwnd(:,nlev,:,:)
    W      = W_file->omega(:,nlev,:,:)
    T      = T_file->air
    pver   = U_file->level
    pver   = pver*100
    p      = U_file->level(nlev)   ;for level used
    TIME   = U_file->time

;potential temperature
    PT = T      ;copy meta data
    PT = ( conform_dims ( dimsizes(T),pver,1) /p0)^k * T

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (W)
    printVarSummary (T)
    printVarSummary (PT)
    printVarSummary (p)
    printVarSummary (TIME)

;--------------------------------------------------------------
;get the time indexs
    YYYY     = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY_S  = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYY_E  = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

    lon  = U&lon
    lat  = U&lat
    dlat = (lat(2)-lat(1))*deg2pi   ;convert to radians
    dy   = R*dlat                   ;convert to dist
    printVarSummary (lon)
    printVarSummary (lat)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   U_JAS_S  = month_to_season ( U(iYYYY_S,:,:) ,season)
   U_JAS_E  = month_to_season ( U(iYYYY_E,:,:) ,season)
   V_JAS_S  = month_to_season ( V(iYYYY_S,:,:) ,season)
   V_JAS_E  = month_to_season ( V(iYYYY_E,:,:) ,season)
   W_JAS_S  = month_to_season ( W(iYYYY_S,:,:) ,season)
   W_JAS_E  = month_to_season ( W(iYYYY_E,:,:) ,season)
   T_JAS_S  = month_to_season ( T(iYYYY_S,:,:,:) ,season)
   T_JAS_E  = month_to_season ( T(iYYYY_E,:,:,:) ,season)
   PT_JAS_S = month_to_season ( PT(iYYYY_S,:,:,:) ,season)
   PT_JAS_E = month_to_season ( PT(iYYYY_E,:,:,:) ,season)
   dim = dimsizes (U_JAS_S)
   printVarSummary (U_JAS_S)
   printVarSummary (V_JAS_S)
   printVarSummary (W_JAS_S)
   printVarSummary (T_JAS_S)
   printVarSummary (PT_JAS_S)

;--------------------------------------------------------------
;vertical-advection term
   dPTdp_S = PT_JAS_S      ;copy metadata
   C_S     = W_JAS_S
   dPTdp_S = center_finite_diff_n (PT_JAS_S,pver,False,0,1)
   C_S     = (p/p0)^k * W_JAS_S * dPTdp_S(:,nlev,:,:)
   printVarSummary (dPTdp_S)
   printVarSummary (C_S)

   dPTdp_E = PT_JAS_E      ;copy metadata
   C_E     = W_JAS_E
   dPTdp_E = center_finite_diff_n (PT_JAS_E,pver,False,0,1)
   C_E     = (p/p0)^k * W_JAS_E * dPTdp_E(:,nlev,:,:)

;horizontal-advection term
   ;dT/dx
   dTdx_S = T_JAS_S(:,nlev,:,:)      ;copy metadata
   dTdx_E = T_JAS_E(:,nlev,:,:)
   lat_c  = conform_dims ( dimsizes(dTdx_S),lat,1)
   lon_c  = conform_dims ( dimsizes(dTdx_S),lon,2)
   x      = R*cos(deg2pi*lat_c)*lon_c

   dTdx_S = center_finite_diff_n (dTdx_S, x , True,0,2)   ;be careful with the dimison downscale
   dTdx_E = center_finite_diff_n (dTdx_E, x , True,0,2)
   printVarSummary (dTdx_S)

   ;dqv/dy
   dTdy_S = T_JAS_S(:,nlev,:,:)      ;copy metadata
   dTdy_E = T_JAS_E(:,nlev,:,:)
   dTdy_S = center_finite_diff_n (dTdy_S, dy , False,0,1)
   dTdy_E = center_finite_diff_n (dTdy_E, dy , False,0,1)
   printVarSummary (dTdy_S)

   D_S = U_JAS_S      ;copy metadata
   D_E = U_JAS_E
   D_S = U_JAS_S*dTdx_S + V_JAS_S*dTdy_S
   D_E = U_JAS_E*dTdx_E + V_JAS_E*dTdy_E
   printVarSummary (D_S)

;--------------------------------------------------------------
;compute seasonal climatologies
   CaveS = dim_avg_n_Wrap (C_S,0)
   CaveE = dim_avg_n_Wrap (C_E,0)
   CstdS = dim_stddev_n_Wrap (C_S,0)
   CstdE = dim_stddev_n_Wrap (C_E,0)
   DaveS = dim_avg_n_Wrap (D_S,0)
   DaveE = dim_avg_n_Wrap (D_E,0)
   DstdS = dim_stddev_n_Wrap (D_S,0)
   DstdE = dim_stddev_n_Wrap (D_E,0)

   CaveS = CaveS * per_s2day
   CaveE = CaveE * per_s2day
   DaveS = DaveS * per_s2day
   DaveE = DaveE * per_s2day

   printVarSummary (CaveS)
   printVarSummary (CstdS)
   printVarSummary (DaveS)
   printVarSummary (DstdS)

;---------------------------------------------------------------
;copy meta data
   diff_C = CaveE
   diff_D = DaveE
;compute differences
   diff_C = CaveE - CaveS
   diff_D = DaveE - DaveS
;compute probabilities for means difference
   prob_C = ttest (CaveS,CstdS^2,dim(0),CaveE,CstdE^2,dim(0),False,False)
   prob_D = ttest (DaveS,DstdS^2,dim(0),DaveE,DstdE^2,dim(0),False,False)
   copy_VarCoords(diff_C,prob_C)
   copy_VarCoords(diff_D,prob_D)

   printVarSummary (diff_C)
   printVarSummary (prob_C)
   printVarSummary (diff_D)
   printVarSummary (prob_D)
   print(prob_C(:,100))
   print(prob_D(:,100))

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
 plot = new(6,graphic)                           ; creat a plot array

;*******************************************
res                  = True

res@gsnDraw          = False      ;don't draw
res@gsnFrame         = False      ;don't advance frame
res@gsnCenterString  = " "
res@gsnRightString   = "K/day"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "BlRe"      ;choose a colormap

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -20.
res@cnMaxLevelValF       = 20.
res@cnLevelSpacingF      = 4.
;res@lbLabelBarOn             = False
res@pmLabelBarOrthogonalPosF = 0.25   ;move Label Bar down

res@mpFillOn     = False        ;turn off map fill
res@mpCenterLonF = 300.
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
;res@mpMinLonF    = lonL
;res@mpMaxLonF    = lonR

ClmC = (CaveS+CaveE)/2
ClmD = (DaveS+DaveE)/2

;symMinMaxPlt(ClmC({latS:latN},:),12,False,res)      ;to have a common label bar
res@gsnLeftString = Text1(0)
plot(0) = gsn_csm_contour_map_ce (wks,ClmC,res)
;symMinMaxPlt(ClmD({latS:latN},:),12,False,res)      ;to have a common label bar
res@cnMinLevelValF  = -3.5
res@cnMaxLevelValF  = 3.5
res@cnLevelSpacingF = .5
res@gsnLeftString   = Text1(2)
res@gsnRightString  = " "
plot(2) = gsn_csm_contour_map_ce (wks,ClmD,res)
;symMinMaxPlt(diff_C({latS:latN},:),12,False,res)      ;to have a common label bar
res@cnMinLevelValF  = -5.
res@cnMaxLevelValF  = 5.
res@cnLevelSpacingF = .5
res@gsnCenterString = "99%"
res@gsnLeftString   = Text1(1)
plot(1) = gsn_csm_contour_map_ce (wks,diff_C,res)
;symMinMaxPlt(diff_D({latS:latN},:),12,False,res)      ;to have a common label bar
res@cnMinLevelValF  = -1.
res@cnMaxLevelValF  = 1.
res@cnLevelSpacingF = .2
res@gsnCenterString = " "
res@gsnLeftString   = Text1(3)
plot(3) = gsn_csm_contour_map_ce (wks,diff_D,res)

;---------------------------------------------------------------
;probability plots
res2 = True

res2@gsnDraw      = False   ;don't draw
res2@gsnFrame     = False   ;don't advance frame
res2@gsnAddCyclic = True    ;add a longitude cyclic point

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00            ;set min contour level
res2@cnMaxLevelValF       = 0.10            ;set max contour level
res2@cnLevelSpacingF      = 0.01            ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.005   ;set a uniform dot size
res2@cnFillScaleF   = 2.5     ;extra density

plot(4) = gsn_csm_contour (wks,prob_C,res2)
plot(4) = ShadeLtContour (plot(4),0.015,17)      ;shade all areas < 0.015 contour
;overlay (plot(2),plot(4))
plot(5) = gsn_csm_contour (wks,prob_D,res2)
plot(5) = ShadeLtContour (plot(5),0.015,17)      ;shade all areas < 0.015 contour
;overlay (plot(3),plot(5))

;*******************************************
;create panel resources
;*******************************************
resP                  = True

resP@txFontHeightF    = 0.03        ;height of text
resP@txString         = "Climatology and Differences in JAS "+p+"hPa TDE"   ;add common title
;resP@gsnPanelLabelBar = True       ;add common colorbar

gsn_panel(wks,plot,(/2,2/),resP)          ; create panel

end
