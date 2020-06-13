;*************************************************************
;Aim: Draw difference in global monthly sea surface temperature for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       Shan He
;                       2018-08-07
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;data
    in_path = "~/hes/input/SST/"
    in_name1 = "sst_HadOIBl_bc_1.9x2.5_1950_2014_clim.nc"
;    in_name2 = "sst_HadOIBl_bc_1.9x2.5_1982_1997_clim.nc"
    in_name2 = "sst_HadOIBl_bc_1.9x2.5_1982_1997_27degC.nc"
    in_name3 = "sst_HadOIBl_bc_1.9x2.5_1982_1997_27degC_neg.nc"

;time
    season = (/"JFM","AMJ","JAS","OND"/)

;region
    latN = 30
    latS = -30
    lonW = 180
    lonE = 300

;fig
    out_path = "~/hes/ENSO/Complexity/Fig/Animation/"
    out_name = "diff_g_SST_trend_"

;text
    text1 = (/"00","01","02","03","04","05","06","07"/)
;    text2 = (/"a) SEN1 - CON","b) SEN2 - SEN1"/)
    text2 = (/"a) SEN2 - CON","b) SEN3 - CON"/)
    text3 = (/"JFM(0)","AMJ(0)","JAS(0)","OND(0)","JFM(+1)","AMJ(+1)","JAS(+1)","OND(+1)"/)
    text4 = "deg C"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")

;    sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
    sst1 = in1->SST_cpl
    sst2 = in2->SST_cpl
    sst3 = in3->SST_cpl
;    sst3 = short2flt (in3->sst(iYYYY3,{latN:latS},:))
printVarSummary(sst1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   sst1_S = month_to_seasonN(sst1, season)
   sst2_S = month_to_seasonN(sst2, season)
   sst3_S = month_to_seasonN(sst3, season)
   dim = dimsizes(sst2_S)
   dim(1) = dim(1) * dim(0)

   diff1 = new((/dim(1),dim(2),dim(3)/), float)
   diff2 = new((/dim(1),dim(2),dim(3)/), float)
   copy_VarMeta(sst1(0,:,:), diff1(0,:,:))
   copy_VarMeta(sst1(0,:,:), diff2(0,:,:))

   do i = 0, dim(1) - 1
      if(i .lt. dim(0))
         diff1(i,:,:) = (/sst2_S(i,0,:,:) - sst1_S(i,0,:,:)/)
;         diff2(i,:,:) = (/sst3_S(i,0,:,:) - sst2_S(i,0,:,:)/)
         diff2(i,:,:) = (/sst3_S(i,0,:,:) - sst1_S(i,0,:,:)/)
;         diff1(i,:,:) = (/sst2_S(i,0,:,:)/)
;         diff2(i,:,:) = (/sst3_S(i,0,:,:)/)
      else
         diff1(i,:,:) = (/sst2_S(i-dim(0),1,:,:) - sst1_S(i-dim(0),0,:,:)/)
;         diff2(i,:,:) = (/sst3_S(i-dim(0),1,:,:) - sst2_S(i-dim(0),1,:,:)/)
         diff2(i,:,:) = (/sst3_S(i-dim(0),1,:,:) - sst1_S(i-dim(0),0,:,:)/)
;         diff1(i,:,:) = (/sst2_S(i-dim(0),1,:,:)/)
;         diff2(i,:,:) = (/sst3_S(i-dim(0),1,:,:)/)
      end if
   end do

   printVarSummary(diff1)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = True
res@gsnStringFontHeightF = .02

res@cnFillOn = True
res@mpFillDrawOrder = "PostDraw"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillPalette = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-2.,-1.5,-1.,-.5,.5,1.,1.5,2./)
;res@cnLevels = (/26,26.5,27,27.5,28,28.5,29/)

res@lbLabelBarOn = False

res@tmXBTickSpacingF = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;res@mpFillOn = False
res@mpCenterLonF = 200
;res@mpLandFillColor = "gray80"
;res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = "Difference in SST"
resP@txFontHeightF = 0.03
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0, dim(1) - 1

 wks = gsn_open_wks("svg", out_path + out_name + text1(i))
 plot = new(2, graphic)

 res@gsnLeftString = text2(0)
 res@gsnCenterString = text3(i)
 res@gsnRightString = text4
; res@tmXBLabelsOn = False
 plot(0) = gsn_csm_contour_map_ce(wks, diff1(i,:,:), res)

 res@gsnLeftString = text2(1)
 res@gsnCenterString = " "
 res@gsnRightString = " "
 plot(1) = gsn_csm_contour_map_ce(wks, diff2(i,:,:), res)

 gsn_panel(wks, plot, (/2,1/), resP)

 delete([/wks,plot/])
end do

end
