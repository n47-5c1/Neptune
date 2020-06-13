;*************************************************************
;Aim: Draw regional monthly mean, symmetric, and asymmetric OLR component climatology
;
;Mission:
;   1. Read data from OLR dataset
;   2. Post-post process to deserved results
;   3. Draw the OLR climatology
;                       He Shan
;                       2015-12-22
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

;Fig name
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_reg_mon_sym_asym_OLR"

;Region
    latN = 40
    latS = -40
    lonL = -30
    lonR = 180

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)"/)
    text2 = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
    text3 = (/"Mean","Symmetric","Asymmetric"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;GPCP 1979-2012
    OLR_file = addfile ("~/data/observation/NOAA-OLR/olr1979-2012.nc","r")
    OLR = OLR_file->olr
;    TIME = OLR_file->time
    printVarSummary (OLR)

;get the time indexs
;    YYYY   = cd_calendar (TIME,-1)/100
;    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate monnthly OLR climatology
    OLR_mon = clmMonTLL (OLR)
    printVarSummary (OLR_mon)

;calculate symmetric and asymmetric component
    OLR_sym  = OLR_mon       ;copy meta data
    OLR_asym = OLR_mon

    OLR_sym(month|:,{lat|0:90},lon|:)  = ( OLR_mon(month|:,{lat|0:90},lon|:) + OLR_mon(month|:,{lat|0:-90},lon|:) )/2.
    OLR_sym(month|:,{lat|0:-90},lon|:) = OLR_sym(month|:,{lat|0:90},lon|:)
    OLR_sym&lat = OLR_mon&lat      ;correct the coordinate variables
    OLR_asym = OLR_mon - OLR_sym
    printVarSummary (OLR_sym)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)   ;open a eps file
 plot = new(12,graphic)      ;creat a plot array

;---------------------------------------------------------------
res                 = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels
res@cnFillPalette  = "matlab_hot"   ;choose a colormap

res@mpFillOn         = False         ;turn off map fill
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

;to have a label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 190.
res@cnMaxLevelValF       = 320.
res@cnLevelSpacingF      = 10.

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@pmLabelBarOrthogonalPosF = 0.19   ;move Label Bar down

res@gsnLeftString   = text1(0)+text3(0)
res@gsnCenterString = text2(4)
plot(0) = gsn_csm_contour_map (wks,OLR_mon(4,:,:),res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(5)
plot(1) = gsn_csm_contour_map (wks,OLR_mon(5,:,:),res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(6)
plot(2) = gsn_csm_contour_map (wks,OLR_mon(6,:,:),res)
res@gsnLeftString   = text1(3)
res@gsnCenterString = text2(7)
plot(3) = gsn_csm_contour_map (wks,OLR_mon(7,:,:),res)

res@gsnLeftString   = text1(4)+text3(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(4) = gsn_csm_contour_map (wks,OLR_sym(4,:,:),res)
res@gsnLeftString   = text1(5)
plot(5) = gsn_csm_contour_map (wks,OLR_sym(5,:,:),res)
res@gsnLeftString   = text1(6)
plot(6) = gsn_csm_contour_map (wks,OLR_sym(6,:,:),res)
res@gsnLeftString   = text1(7)
plot(7) = gsn_csm_contour_map (wks,OLR_sym(7,:,:),res)

res@cnFillPalette   = "MPL_RdBu"   ;choose a colormap
res@cnMinLevelValF  = -42.
res@cnMaxLevelValF  = 42.
res@cnLevelSpacingF = 7.

res@gsnLeftString   = text1(8)+text3(2)
plot(8)  = gsn_csm_contour_map (wks,OLR_asym(4,:,:),res)
res@gsnLeftString   = text1(9)
plot(9)  = gsn_csm_contour_map (wks,OLR_asym(5,:,:),res)
res@gsnLeftString   = text1(10)
plot(10) = gsn_csm_contour_map (wks,OLR_asym(6,:,:),res)
res@gsnLeftString   = text1(11)
plot(11) = gsn_csm_contour_map (wks,OLR_asym(7,:,:),res)

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "Monthly Climatology of OLR"   ;add common title

gsn_panel(wks,plot,(/3,4/),resP)

end
