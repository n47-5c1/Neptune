;*************************************************************
;Aim: Draw differences of global J\A\S geopotential height
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the differences
;                       He Shan
;                       2015-10-05
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------hgt
;================================================

;time
    yS1   = 1950
    yE1   = 1969
    yS2   = 1970
    yE2   = 1989
    nyear = 20


;data
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "diff_g_mon_hgt"

;text
    text1 = (/"a)","b)","c)"/)

;Region
;    latN=40
;    latS=-20
;    lonL=-40
;    lonR=65

    nmon  = 6   ;July
    level = (/"1000","925","850","700","600","500","400","300","250","200","150","100","70","50","30","20","10"/)
    nlev  = 5

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;PREC 1948-01~2012-01
    hgt_file = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_hgt.mon.mean.nc","r")
    hgt = hgt_file->hgt
    TIME = hgt_file->time
    printVarSummary (hgt)

;get the time indexs
    YYYY   = cd_calendar (TIME,-1)/100
    iYYYYS = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYYE = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

; compute monthly climatologies
   hgtAVE50 = clmMonTLLL (hgt(iYYYYS,:,:,:))
   hgtAVE80 = clmMonTLLL (hgt(iYYYYE,:,:,:))
   hgtSTD50 = stdMonTLLL (hgt(iYYYYS,:,:,:))
   hgtSTD80 = stdMonTLLL (hgt(iYYYYE,:,:,:))
   printVarSummary(hgtAVE50)
   printVarSummary(hgtSTD50)

;copy meta data
   prob = hgtAVE50
   diff = hgtAVE50
;compute probabilities for means difference
   prob = ttest (hgtAVE80,hgtSTD80^2,nyear,hgtAVE50,hgtSTD50^2,nyear,False,False)
;compute differences
   diff = hgtAVE80 - hgtAVE50
   printVarSummary (prob)
   printVarSummary (diff)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 gsn_define_colormap(wks,"BrownBlue12")        ; choose a colormap
 plot0 = new(3,graphic)                         ; creat a plot array
 plot1 = new(3,graphic)

;---------------------------------------------------------------
res              = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
res@gsnCenterString = "99% stippled"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False   ;turn off cn line labels

res@mpCenterLonF     = 110           ;get the correct map
res@mpFillOn         = False         ;turn off map fill
;res@mpOceanFillColor = "Gray80"      ;changing the color of the oceans
;map outlines
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonL
;res@mpMaxLonF = lonR

;to have a common label bari
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -40       ;set min contour level
res@cnMaxLevelValF       = 40        ;set max contour level
res@cnLevelSpacingF      = 10        ;set contour spacing

;res@tiMainString      = "Differences of Sahel JAS Rainfall"   ;add title
;res@tiMainFontHeightF = 0.04    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 40.     ;label spacing

res@pmLabelBarOrthogonalPosF = 0.15   ;move Label Bar down

do i = 0,2
 res@gsnLeftString = text1(i)
 plot0(i) = gsn_csm_contour_map_ce (wks,diff(i+nmon,nlev,:,:),res)
end do

;---------------------------------------------------------------
;probability plots
res1                = True

res1@gsnDraw        = False   ;don't draw
res1@gsnFrame       = False   ;don't advance frame
res1@gsnLeftString  = " "
res1@gsnRightString = " "

res1@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res1@cnMinLevelValF       = 0.00             ;set min contour level
res1@cnMaxLevelValF       = 0.10             ;set max contour level
res1@cnLevelSpacingF      = 0.01             ;set contour spacing
res1@cnInfoLabelOn        = False

res1@cnLinesOn      = False   ;do not draw contour lines
res1@cnLineLabelsOn = False   ;do not draw contour labels
res1@cnFillDotSizeF = 0.003   ;set a uniform dot size
res1@cnFillScaleF   = 1.2     ;add extra density

do i = 0,2
 plot1(i) = gsn_csm_contour (wks,prob(i+nmon,nlev,:,:),res1)
 plot1(i) = ShadeLtContour (plot1(i),0.015,17)      ;shade all areas < 0.015 contour
 overlay (plot0(i),plot1(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.04       ;height of text
resP@txString         = "Differences of monthly hgt"   ;add common title
resP@gsnPanelLabelBar = True       ;add common colorbar

gsn_panel(wks,plot0,(/3,1/),resP)          ; create panel

end
