;*************************************************************
;Aim: Draw differences of Africa JAS rainfall
;Mission:
;
;   1. Read data from PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the differences
;                       He Shan
;                       2015-03-27
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------precip
;================================================

;    GRAY = True      ;colour?
    GRAY = False      ;colour?

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981
    season = "JAS"      ;choose seasonal mean

;data
    out_path = "~/hes/Sahel_Rainfall/final/"
    if(GRAY)then
     out_name = "diff_Sahel_JAS_PREC_gray"
    else
     out_name = "diff_Sahel_JAS_PREC"
    end if

;Africa
    latN=40
    latS=-20
    lonL=-40
    lonR=65

;Sahel
    latN_2=20.
    latS_2=10.
    lonL_2=-20.
    lonR_2=35.
; create points for box
    ypts = (/latN_2,latN_2,latS_2,latS_2,latN_2/)
    xpts = (/lonL_2,lonR_2,lonR_2,lonL_2,lonL_2/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;PREC 1948-01~2012-01
    PREC_file = addfile ("~/data/observation/PRECPT/precip-land.mon.mean.0.5x0.5.nc","r")
    PREC = PREC_file->precip
    TIME = PREC_file->time
    printVarSummary (PREC)

;get the time indexs
    YYYY   = cd_calendar (TIME,-1)/100
    iYYYYS = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYYE = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   PREC_JAS_S = month_to_season ( PREC(iYYYYS,:,:) ,season)
   PREC_JAS_E = month_to_season ( PREC(iYYYYE,:,:) ,season)
   dim = dimsizes (PREC_JAS_S)
   printVarSummary (PREC_JAS_S)
   printVarSummary (PREC_JAS_E)

; compute climatologies
   PRECave50 = dim_avg_n_Wrap (PREC_JAS_S,0)
   PRECave80 = dim_avg_n_Wrap (PREC_JAS_E,0)
   PRECstd50 = dim_stddev_n_Wrap (PREC_JAS_S,0)
   PRECstd80 = dim_stddev_n_Wrap (PREC_JAS_E,0)
   printVarSummary(PRECave50)
   printVarSummary(PRECstd50)

;---------------------------------------------------------------
;copy meta data
   prob = PRECave50
   diff = PRECave50
;compute probabilities for means difference
   prob = ttest (PRECave80,PRECstd80^2,dim(0),PRECave50,PRECstd50^2,dim(0),False,False)
;compute differences
   diff = PRECave80 - PRECave50
   printVarSummary (prob)
   printVarSummary (diff)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 if(GRAY)then
  gsn_define_colormap(wks,"MPL_Greys")      ; choose a colormap
 else
  gsn_define_colormap(wks,"MPL_RdBu")   ; choose a colormap
 end if

;---------------------------------------------------------------
res              = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
res@gsnLeftString   = "a)"
res@gsnCenterString = "95% stippled"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False   ;turn off cn line labels

res@mpFillOn         = False         ;turn off map fill
;res@mpOceanFillColor = "Gray80"      ;changing the color of the oceans
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

;to have a common label bari
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -1.5           ;set min contour level
res@cnMaxLevelValF       = 1.5            ;set max contour level
res@cnLevelSpacingF      = 0.25           ;set contour spacing

;res@tiMainString      = "Differences of Sahel JAS Rainfall"   ;add title
;res@tiMainFontHeightF = 0.04    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@pmLabelBarOrthogonalPosF = 0.15   ;move Label Bar down

plot0 = gsn_csm_contour_map_ce (wks,diff,res)

;---------------------------------------------------------------
;plot zero line

res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

if(GRAY)then
 res2@cnLineLabelsOn       = False   ;turn off cn line labels
 res2@cnInfoLabelOn        = False   ;turn off cn info labels
 res2@cnLevelSelectionMode = "ExplicitLevels"
 res2@cnLevels             = (/0/)      ;Use a value that's between the two values
 plot1 = gsn_csm_contour(wks,diff,res2)
 overlay (plot0,plot1)
end if

;---------------------------------------------------------------
;probability plots

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00             ;set min contour level
res2@cnMaxLevelValF       = 0.10             ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.006   ;set a uniform dot size
res2@cnFillScaleF   = 2.6     ;add extra density

plot2 = gsn_csm_contour (wks,prob,res2)
plot2 = ShadeLtContour (plot2,0.055,17)      ;shade all areas < 0.055 contour
overlay (plot0,plot2)

;draw(plot0)

;************************************************
; add the box
;************************************************
resp                   = True         ; polyline mods desired
;resp@gsLineColor       = "grey57"
resp@gsLineThicknessF  = 1.5          ; thickness of lines

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

dum = new (4,graphic)  

; draw each line separately. Each line must contain two points.
do i =0,3
 dum(i) = gsn_add_polyline (wks,plot0,xpts(i:i+1),ypts(i:i+1),resp)      
end do 

draw(wks)

end
