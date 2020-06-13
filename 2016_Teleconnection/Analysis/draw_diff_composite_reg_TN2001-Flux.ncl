;*************************************************************
;Aim: Draw climatologies of global seasonal TN2001 wave activity flux
;Mission:
;
;   1. Read data from Fx & Fy datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2017-06-27
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------Fx
;   var--------------Fy
;================================================

;region
    latN = 65
    latS = 0
    lonL = -50
    lonR = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "diff_comp_reg_TN2001-Flux"

;text
    text1 = (/"a)","b)","c)","d)"/)

 wks   = gsn_open_wks("svg",out_path+out_name)
 plot  = new(4,graphic)      ;creat a plot array

res = True

res@gsnDraw           = False
res@gsnFrame          = False
res@gsnAddCyclic      = False
res@gsnScalarContour  = True
res@gsnSpreadColorEnd = 125        ; end at color XXX

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

res@mpFillOn               = False
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

res@vcRefLengthF            = 0.04            ;the length of the reference magnitude
res@vcMinDistanceF          = 0.05            ;the minimum distance of neighboring vectors
res@vcRefMagnitudeF         = 10.^2         ;the magnitude used as the reference magnitude
res@vcLineArrowThicknessF   = 1.4
res@vcLineArrowHeadMaxSizeF = 0.02            ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.008
res@vcRefAnnoOrthogonalPosF = -0.168          ;move ref vector

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -.001
res@cnMaxLevelValF       = .001
res@cnLevelSpacingF      = .0002

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.

do i = 1,4

;data
    in_name1x = "./TN2001-Fx.daily.P"+i+"_ElNino.nc"
    in_name1y = "./TN2001-Fy.daily.P"+i+"_ElNino.nc"
    in_name2x = "./TN2001-Fx.daily.P"+i+"_LaNina.nc"
    in_name2y = "./TN2001-Fy.daily.P"+i+"_LaNina.nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;TN2001 Flux
    Fx_file1 = addfile (in_name1x,"r")
    Fy_file1 = addfile (in_name1y,"r")
    Fx_file2 = addfile (in_name2x,"r")
    Fy_file2 = addfile (in_name2y,"r")
    Fx1      = Fx_file1->Fx(:,1,:,:)
    Fy1      = Fy_file1->Fy(:,1,:,:)
    Fx2      = Fx_file2->Fx(:,1,:,:)
    Fy2      = Fy_file2->Fy(:,1,:,:)

    lat  = Fx_file1->lat
    lon  = Fx_file1->lon

    printVarSummary (Fx1)
    printVarSummary (Fy1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute composite
   xClm1 = dim_avg_n_Wrap (Fx1,0)
   yClm1 = dim_avg_n_Wrap (Fy1,0)
   dv1   = uv2dv_cfd (xClm1, yClm1, lat, lon, 1)
   xClm2 = dim_avg_n_Wrap (Fx2,0)
   yClm2 = dim_avg_n_Wrap (Fy2,0)
   dv2   = uv2dv_cfd (xClm2, yClm2, lat, lon, 1)
   copy_VarCoords (xClm1, dv1)
   copy_VarCoords (xClm2, dv2)
   printVarSummary (xClm1)
   printVarSummary (dv1)

;Difference
   xDiff = xClm1-xClm2
   yDiff = yClm1-yClm2
   dDiff = dv1-dv2
   copy_VarMeta (xClm1,xDiff)
   copy_VarMeta (yClm1,yDiff)
   copy_VarMeta (dv1,dDiff)
   xDiff = mask (xDiff, abs(xDiff).gt.10.^2,False)
   yDiff = mask (yDiff, abs(yDiff).gt.10.^2,False)
   printVarSummary (xDiff)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

n = i-1

res@gsnLeftString   = text1(n)
res@gsnCenterString = " "
if(n.eq.1) then
 res@gsnRightString = " "
end if
plot(n) = gsn_csm_vector_scalar_map (wks,xDiff,yDiff,dDiff({:40},:),res)

delete ([/Fx1,Fy1,Fx2,Fy2/])

end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Differences of 250 hPa TN01-Flux"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True   ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
