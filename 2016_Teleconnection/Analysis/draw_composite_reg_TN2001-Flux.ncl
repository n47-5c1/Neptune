;*************************************************************
;Aim: Draw climatologies of global seasonal TN2001 wave activity flux
;Mission:
;
;   1. Read data from Fx & Fy datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2017-06-23
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
    out_name = "comp_reg_TN2001-Flux"

;text
    text1 = (/"a)","b)","c)","d)"/)

 wks   = gsn_open_wks("svg",out_path+out_name)
 plot  = new(4,graphic)      ;creat a plot array

res = True

res@gsnDraw           = False
res@gsnFrame          = False
res@gsnAddCyclic      = False
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

res@stArrowLengthF     = 0.008      ;size of the arrows.
res@stMinArrowSpacingF = 0.08       ;arrow spacing.
res@stLineThicknessF   = 1.1        ;changes the line thickness
res@stMinDistanceF     = 0.06       ;distance between streamlines
res@stMinLineSpacingF  = 0.004

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -.004
res@cnMaxLevelValF       = .004
res@cnLevelSpacingF      = .001

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.

do i = 1,4

;data
    in_name1 = "./TN2001-Fx.daily.P"+i+".nc"
    in_name2 = "./TN2001-Fy.daily.P"+i+".nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;TN2001 Flux
    Fx_file = addfile (in_name1,"r")
    Fy_file = addfile (in_name2,"r")
    Fx      = Fx_file->Fx(:,1,:,:)
    Fy      = Fy_file->Fy(:,1,:,:)

    lat = Fx_file->lat
    lon = Fx_file->lon

    printVarSummary (Fx)
    printVarSummary (Fy)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute composite
   xClm = dim_avg_n_Wrap (Fx,0)
   yClm = dim_avg_n_Wrap (Fy,0)
   dv   = uv2dv_cfd (xClm, yClm, lat, lon, 1)
   copy_VarCoords (xClm, dv)
   printVarSummary (xClm)
   printVarSummary (dv)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

n = i-1

res@gsnLeftString   = text1(n)
res@gsnCenterString = " "
if(n.eq.1) then
 res@gsnRightString = " "
end if
plot(n) = gsn_csm_streamline_contour_map_ce (wks,xClm(:,:),yClm(:,:),dv({:40},:),res)

delete ([/Fx,Fy/])

end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa TN01-Flux"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True   ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
