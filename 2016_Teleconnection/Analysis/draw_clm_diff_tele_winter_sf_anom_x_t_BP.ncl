;*************************************************************
;Aim: Draw difference in teleconnectivity of stream function for El Nino and La Nina years in the winter-half year
;Mission:
;
;   1. Read data from teleconnectivity datasets
;   2. Draw the teleconnectivity
;                       He Shan
;                       2017-05-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var--------------tele
;================================================

;datas
    in_path = "~/hes/One_Belt_One_Road/NCL/"
    in_name1 = "tele_winter_sf_anom_x_t_10_30_BP_ElNino.nc"
    in_name2 = "tele_winter_sf_anom_x_t_10_30_BP_LaNina.nc"

;Region
    latN = 65
    latS = 0
    lonL = -50
    lonR = 150

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_diff_tele_winter_sf_anom_x_t_BP"

    text1 = (/"El Nino","Nov.(0) - Apr.(+1)","El Nino - La Nina"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    tele_in1 = addfile (in_path+in_name1, "r")
    tele_in2 = addfile (in_path+in_name2, "r")

    tele1 = tele_in1->tele({latN:latS},:)
    tele1 = -100.*tele1

    tele2 = tele_in2->tele({latN:latS},:)
    tele2 = -100.*tele2

    printVarSummary (tele_in1)
    printVarSummary (tele1)

    diff = tele1 - tele2
    copy_VarMeta (tele1,diff)
    printVarSummary (diff)

; ==============================================================
; Mission 2. Draw the teleconnectivity
; ==============================================================
 wks  = gsn_open_wks ("svg",out_path+out_name)
 plot = new(2,graphic)

;-----------------------------------------------------------------------------
;draw difference
res = True

res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = text1(0)
res@gsnCenterString = text1(1)
res@gsnRightString  = text1(2)
res@gsnStringFontHeightF = .02

res@mpFillOn     = False
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
res@mpMinLonF    = lonL
res@mpMaxLonF    = lonR
;res@mpCenterLonF = 60.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

res@tiMainString      = "Teleconnectivity and its Difference"
res@tiMainFontHeightF = 0.025

res@tmXBLabelFontHeightF = .018
res@tmYLLabelFontHeightF = .018
;res@tmXBTickSpacingF     = 60.

res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-12,-8,-4,4,8,12/)

;res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.36    ;move Label Bar down

plot(0) = gsn_csm_contour_map (wks,diff,res)

;----------------------------------------------------------
;draw climatology
ores = True
 
ores@gsnDraw       = False
ores@gsnFrame      = False
ores@gsnAddCyclic  = True
ores@gsnLeftString = " "
ores@gsnContourLineThicknessesScale = 2

ores@cnLevelSelectionMode = "ExplicitLevels"
ores@cnLevels             = ispan(45,65,5)
;ores@cnLineLabelsOn = False
ores@cnLineLabelInterval = 1
ores@cnLineLabelDensityF = 0.5
;ores@cnLineLabelFontHeightF = 0.012
ores@cnLineLabelPlacementMode = "Computed"
ores@cnInfoLabelFontHeightF = 0.013
ores@cnInfoLabelOrthogonalPosF = -0.42   ;move informational label down

plot(1) = gsn_csm_contour (wks,tele1,ores)
overlay (plot(0),plot(1))

draw (plot(0))
frame (wks)

/;
;---------------------------------------------------------------
;probability plots
res2 = True

res2@gsnDraw              = False
res2@gsnFrame             = False
res2@gsnLeftString        = " "
res2@gsnRightString       = " "

res2@cnLevelSelectionMode = "ManualLevels"
res2@cnMinLevelValF       = 0.00
res2@cnMaxLevelValF       = 0.10
res2@cnLevelSpacingF      = 0.01
res2@cnInfoLabelOn        = False
res2@cnLinesOn            = False
res2@cnLineLabelsOn       = False
res2@cnFillDotSizeF       = 0.003            ;set a uniform dot size
res2@cnFillScaleF         = 1.2              ;add extra density

plot2 = gsn_csm_contour (wks,prob,res2)
plot2 = ShadeLtContour (plot2,0.015,17)      ;shade all areas < 0.015 contour
overlay (plot(1),plot3)
;/

end
