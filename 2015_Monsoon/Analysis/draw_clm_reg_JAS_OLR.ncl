;*************************************************************
;Aim: Draw regional JAS OLR climatology
;
;Mission:
;   1. Read data from OLR dataset
;   2. Post-post process to deserved results
;   3. Draw the OLR climatology
;                       He Shan
;                       2015-10-19
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------olr
;================================================

;time
    yS = 1979
    yE = 2010
    season = "JAS"      ;choose seasonal mean

;Fig name
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_reg_JAS_OLR"

;Region
    latN = 40
    latS = -20
    lonL = 50
    lonR = 170

;text
    text1 = (/"A","W","E"/)
    x     = (/145,75,145/)
    y     = (/26,25,15/)

;SAM
    latN_1 = 32.
    latS_1 = -12.
    lonL_1 = 68.
    lonR_1 = 150.
;create points for box
    ypts_1 = (/latN_1,latN_1,latS_1,latS_1,latN_1/)
    xpts_1 = (/lonL_1,lonR_1,lonR_1,lonL_1,lonL_1/)

;W_SAM
    latN_2 = 30.
    latS_2 = -10.
    lonL_2 = 70.
    lonR_2 = 110.
    ypts_2 = (/latN_2,latN_2,latS_2,latS_2,latN_2/)
    xpts_2 = (/lonL_2,lonR_2,lonR_2,lonL_2,lonL_2/)

;ES_SAM
    latN_3 = 20.
    latS_3 = 0.
    lonL_3 = 110.
    lonR_3 = 150.
    ypts_3 = (/latN_3,latN_3,latS_3,latS_3,latN_3/)
    xpts_3 = (/lonL_3,lonR_3,lonR_3,lonL_3,lonL_3/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;GPCP 1979-2012
    OLR_file = addfile ("~/data/observation/NOAA-OLR/olr1979-2012.nc","r")
    OLR = OLR_file->olr
    TIME = OLR_file->time
    printVarSummary (OLR)

;get the time indexs
    YYYY   = cd_calendar (TIME,-1)/100
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate JAS OLR climatology
   OLR_JAS = dim_avg_n_Wrap ( month_to_season ( OLR(iYYYY,:,:) ,season) ,0)
;   OLR_JAS = dim_avg_n_Wrap ( month_to_season ( OLR ,season) ,0)
   printVarSummary (OLR_JAS)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)   ;open a eps file

 gsn_define_colormap(wks,"matlab_hot")   ; choose a colormap

;---------------------------------------------------------------
res                 = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame

res@gsnLeftString   = " "
res@gsnCenterString = " "

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels

res@mpFillOn         = False         ;turn off map fill
;res@mpOceanFillColor = "Gray80"      ;changing the color of the oceans
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

;res@mpGridAndLimbOn = True        ;turn on grid lines
;res@mpGridLineColor = "Gray30"

;to have a label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 195.
res@cnMaxLevelValF       = 245.
res@cnLevelSpacingF      = 5.

res@tiMainString = "Climatology of JAS OLR"   ;add title
res@tiMainFontHeightF    = 0.035   ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@pmLabelBarOrthogonalPosF = 0.19   ;move Label Bar down

plot = gsn_csm_contour_map (wks,OLR_JAS,res)

;************************************************
; add the box and attach text
;************************************************
resp                   = True         ; polyline mods desired
resp@gsLineThicknessF  = 5.0          ; thickness of lines

;create array of dummy graphic variables. This is required, b/c each line must be associated with a unique dummy variable.

dum = new (4*4,graphic)

;draw each line separately. Each line must contain two points.
do i = 0,3
 dum(4*i)   = gsn_add_polyline (wks,plot,xpts_1(i:i+1),ypts_1(i:i+1),resp)
 dum(4*i+1) = gsn_add_polyline (wks,plot,xpts_2(i:i+1),ypts_2(i:i+1),resp)
 dum(4*i+2) = gsn_add_polyline (wks,plot,xpts_3(i:i+1),ypts_3(i:i+1),resp)
end do

;---------------------------------------------------------------
txres               = True      ; text mods desired
txres@txFontHeightF = 0.03

txdum = new (4,graphic)

do i = 0,2
 txdum = gsn_add_text (wks,plot,text1(i),x(i),y(i),txres)
end do

draw(plot)
frame(wks)

end
