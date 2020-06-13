;*************************************************************
;Aim: Draw differences of global JAS diabatic heating
;Mission:
;
;   1. Read data from radiation (dswrf, uswrf, ulwrf, nswrs, and nlwrs), latent heating (prate), and sensible heat flux (shtfl) datasets
;   2. Post-post process to deserved results
;   3. Draw the differences
;                       He Shan
;                       2015-12-12
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;----------------------------------------------------------------------
; This function sets the gsnSpreadXXX resources necessary to correctly span a two-color colortable.
;
; lower  = cnMinLevelValF
; upper  = cnMaxLevelValF
; step   = cnLevelSpacingF
; center = The numerical value the colormap is centered on. For anomalies or trends, it's common to use 0.0, so blue means
;          cold or cooling and red means warm or warming.
; color_end = The number of colors in colormap (ex. 97 for BlRe, 253 for BlueRed)
; center_color = Color value on the left of the "center" value (see above).
;----------------------------------------------------------------------
undef("gsnColorRange")
function gsnColorRange(lower:numeric, upper:numeric, step:numeric, center:numeric, color_end:integer, center_color:integer)
local nboxes_left, nboxes_right, ncolors_left, ncolors_right, output, color_start

begin

 color_start = 2 ; All of the color maps begin with 2.
;Calculate the number of color bar boxes to the left and right of the "center" value.
 nboxes_left  = (center - (lower - step))/step
 nboxes_right = ((upper + step) - center)/step

;Calculate the number of colors in the map on the left and right hand sides.
 ncolors_left = (center_color - color_start + 1)
 ncolors_right = (color_end - center_color)

 output = True

;Either the lower or upper extent of the color map will be adjusted. If the magnitude of the lower limit is less than the magnitude of the
;upper limit, then the lower limit has to be "moved in" towards the center color. Oppositely, the upper limit will be moved. If both the
;lower and upper numerical values are the same, then pass back 2 as the lower extent and color_end (number of colors) as the upper extent (use
;the whole map in other words).

 if(abs(lower) .lt. abs(upper))then
 output@ColorStart = round(center_color - (ncolors_right/nboxes_right)*nboxes_left, 3)
 output@ColorEnd   = color_end
 else
;---no "else if" in NCL :(
  if(abs(lower) .gt. abs(upper))then
   output@ColorStart = 2
   output@ColorEnd   = round(center_color + (ncolors_left/nboxes_left)*nboxes_right, 3)
  else
   output@ColorStart = 2
   output@ColorEnd   = color_end
  end if
 end if

 return(output)

end

;*************************************************************
; Main code
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------dswrf
;   var2--------------uswrf
;   var3--------------ulwrf
;   var4--------------nswrs
;   var5--------------nlwrs
;   var6--------------prate
;   var7--------------shtfl
;================================================

    season  = "JAS"     ;choose seasonal mean
    prec2lh = 2.5*10^6   ;2.5*10^6J/Kg * Kg/m^2/s -> W/m^2
;    prec2lh = 60*60*24   ;Kg/m^2/s -> mm/day

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "diff_g_JAS_DH"

;text
    Text1 = (/"a)","b)","c)","d)","e)","f)"/)

;Region
    latNm = 40
    latSm = -20
    lonLm = 50
    lonRm = 160

;SAM
    latN = 30.
    latS = -10.
    lonL = 70.
    lonR = 150.
; create points for box
    ypts = (/latN,latN,latS,latS,latN/)
    xpts = (/lonL,lonR,lonR,lonL,lonL/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    file1 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_dswrf.ntat.mon.mean.nc","r")
    file2 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_uswrf.ntat.mon.mean.nc","r")
    file3 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_ulwrf.ntat.mon.mean.nc","r")
    file4 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_nswrs.sfc.mon.mean.nc","r")
    file5 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_nlwrs.sfc.mon.mean.nc","r")
    file6 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_prate.sfc.mon.mean.nc","r")
    file7 = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_shtfl.sfc.mon.mean.nc","r")

    dswrf = file1->dswrf
    uswrf = file2->uswrf
    ulwrf = file3->ulwrf
    nswrs = file4->nswrs
    nlwrs = file5->nlwrs
    prate = file6->prate
    shtfl = file7->shtfl
    TIME  = file6->time

    RF = nswrs      ;copy meta data
    RF = dswrf - uswrf - ulwrf + nswrs + nlwrs

    printVarSummary (dswrf)
    printVarSummary (uswrf)
    printVarSummary (ulwrf)
    printVarSummary (nswrs)
    printVarSummary (nlwrs)
    printVarSummary (prate)
    printVarSummary (shtfl)
    printVarSummary (RF)
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
   RF_JAS   = month_to_season ( RF(iYYYY,:,:) ,season)
   RF_JAS_S = month_to_season ( RF(iYYYY_S,:,:) ,season)
   RF_JAS_E = month_to_season ( RF(iYYYY_E,:,:) ,season)

   PREC_JAS   = month_to_season ( prate(iYYYY,:,:) ,season)
   PREC_JAS_S = month_to_season ( prate(iYYYY_S,:,:) ,season)
   PREC_JAS_E = month_to_season ( prate(iYYYY_E,:,:) ,season)
   dim = dimsizes (PREC_JAS_S)

   SHF_JAS   = month_to_season ( shtfl(iYYYY,:,:) ,season)
   SHF_JAS_S = month_to_season ( shtfl(iYYYY_S,:,:) ,season)
   SHF_JAS_E = month_to_season ( shtfl(iYYYY_E,:,:) ,season)

   printVarSummary (PREC_JAS)
   printVarSummary (PREC_JAS_S)
   printVarSummary (PREC_JAS_E)

;--------------------------------------------------------------
;compute seasonal climatologies
   RFave  = dim_avg_n_Wrap (RF_JAS,0)
   RFaveS = dim_avg_n_Wrap (RF_JAS_S,0)
   RFaveE = dim_avg_n_Wrap (RF_JAS_E,0)
   RFstdS = dim_stddev_n_Wrap (RF_JAS_S,0)
   RFstdE = dim_stddev_n_Wrap (RF_JAS_E,0)

   LHave    = dim_avg_n_Wrap (PREC_JAS,0)
   LHave    = prec2lh * LHave
   PRECaveS = dim_avg_n_Wrap (PREC_JAS_S,0)
   PRECaveE = dim_avg_n_Wrap (PREC_JAS_E,0)
   PRECstdS = dim_stddev_n_Wrap (PREC_JAS_S,0)
   PRECstdE = dim_stddev_n_Wrap (PREC_JAS_E,0)

   SHFave  = dim_avg_n_Wrap (SHF_JAS,0)
   SHFaveS = dim_avg_n_Wrap (SHF_JAS_S,0)
   SHFaveE = dim_avg_n_Wrap (SHF_JAS_E,0)
   SHFstdS = dim_stddev_n_Wrap (SHF_JAS_S,0)
   SHFstdE = dim_stddev_n_Wrap (SHF_JAS_E,0)

   printVarSummary (RFave)
   printVarSummary (LHave)
   printVarSummary (SHFave)
   printVarSummary (PRECaveS)
   printVarSummary (PRECstdS)

;---------------------------------------------------------------
;copy meta data
   diff_RF  = RFave
   diff_LH  = LHave
   diff_SHF = SHFave
   diff_LH@units = "W/m^2"
;compute differences
   diff_RF  = RFaveE - RFaveS
   diff_LH  = prec2lh * (PRECaveE - PRECaveS)
   diff_SHF = SHFaveE - SHFaveS
;compute probabilities for means difference
   prob_RF  = ttest (RFaveS,RFstdS^2,dim(0),RFaveE,RFstdE^2,dim(0),False,False)
   prob_LH  = ttest (PRECaveS,PRECstdS^2,dim(0),PRECaveE,PRECstdE^2,dim(0),False,False)
   prob_SHF = ttest (SHFaveS,SHFstdS^2,dim(0),SHFaveE,SHFstdE^2,dim(0),False,False)
   copy_VarCoords (RFave,prob_RF)
   copy_VarCoords (LHave,prob_LH)
   copy_VarCoords (SHFave,prob_SHF)

   printVarSummary (diff_LH)
   printVarSummary (prob_LH)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks   = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
 plot1 = new(6,graphic)                           ; creat a plot array
 plot2 = new(3,graphic)                           ; creat a plot array

;*******************************************
res                  = True

res@gsnDraw          = False      ;don't draw
res@gsnFrame         = False      ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False            ;turn off cn line labels
res@cnFillPalette  = "BlRe"           ;choose a colormap
;res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

;res@tiMainString      = "Differences in JAS Diabatic Heating"   ;add title
res@tiMainFontHeightF = 0.02    ;change font heights

;res@vpXF      = 0.14   ;position and size for contour plots
;res@vpHeightF = 0.075

res@tmXBLabelFontHeightF = 0.024   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.024

;symMinMaxPlt(diff_LH({latS:latN},:),16,False,res)      ;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -315.       ;set min contour level
res@cnMaxLevelValF       = 315.      ;set max contour level
res@cnLevelSpacingF      = 35.       ;set contour spacing

;res@lbLabelBarOn             = False
res@pmLabelBarOrthogonalPosF = 0.155   ;move Label Bar down

res@mpFillOn               = False        ;turn off map fill
;res@mpCenterLonF           = 110.         ;get the correct map
res@mpMinLatF              = latSm
res@mpMaxLatF              = latNm
res@mpMinLonF              = lonLm
res@mpMaxLonF              = lonRm

;res@gsnLeftString   = Text1(0)
;res@gsnCenterString = " "
;res@vpYF            = 0.86    ;position and size for contour plots
;plot1(0) = gsn_csm_contour_map_ce(wks,RFave,res)

;delete(res@tiMainString)
;res@gsnLeftString   = Text1(1)
;res@gsnRightString  = " "
;res@vpYF            = 0.75    ;position and size for contour plots
;plot1(1) = gsn_csm_contour_map_ce(wks,LHave,res)

;res@gsnLeftString   = Text1(2)
;res@lbLabelBarOn    = True
;res@vpYF            = 0.64    ;position and size for contour plots
;plot1(2) = gsn_csm_contour_map_ce(wks,SHFave,res)

gsn_range           = gsnColorRange(-120,90,15,0.,97,48)
;gsn_range           = gsnColorRange(-100,80,10,0.,129,65)
res@cnMinLevelValF  = -120      ;set min contour level
res@cnMaxLevelValF  = 90        ;set max contour level
res@cnLevelSpacingF = 15        ;set contour spacing

res@gsnSpreadColorStart = gsn_range@ColorStart
res@gsnSpreadColorEnd   = gsn_range@ColorEnd

;res@gsnLeftString   = Text1(3)
res@gsnCenterString = "95% stippled"
;res@lbLabelBarOn    = False
;res@vpYF            = 0.50    ;position and size for contour plots
;plot1(3) = gsn_csm_contour_map_ce(wks,diff_RF,res)

;res@gsnLeftString   = Text1(4)
res@gsnLeftString   = "b)"
;res@gsnCenterString = " "
;res@vpYF            = 0.39    ;position and size for contour plots
plot1(4) = gsn_csm_contour_map_ce(wks,diff_LH,res)

;res@gsnLeftString   = Text1(5)
;res@lbLabelBarOn    = True
;res@vpYF            = 0.28    ;position and size for contour plots
;plot1(5) = gsn_csm_contour_map_ce(wks,diff_SHF,res)

;---------------------------------------------------------------
;draw probability
res2                      = True

res2@gsnDraw              = False            ;don't draw
res2@gsnFrame             = False            ;don't advance frame
res2@gsnLeftString        = " "
res2@gsnRightString       = " "

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = .00              ;set min contour level
res2@cnMaxLevelValF       = .10              ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False
res2@cnLinesOn            = False            ;do not draw contour lines
res2@cnLineLabelsOn       = False            ;do not draw contour labels
res2@cnFillDotSizeF       = 0.007            ;set a uniform dot size
res2@cnFillScaleF         = 2.4              ;add extra density

;plot2(0) = gsn_csm_contour (wks,prob_RF,res2)
;plot2(0) = ShadeLtContour (plot2(0),.015,17)      ;shade all areas < 0.015 contour
;overlay (plot1(3),plot2(0))

plot2(1) = gsn_csm_contour (wks,prob_LH,res2)
plot2(1) = ShadeLtContour (plot2(1),.055,17)      ;shade all areas < 0.015 contour
overlay (plot1(4),plot2(1))

;plot2(2) = gsn_csm_contour (wks,prob_SHF,res2)
;plot2(2) = ShadeLtContour (plot2(2),.015,17)      ;shade all areas < 0.015 contour
;overlay (plot1(5),plot2(2))

;************************************************
; add the box
;************************************************
resp                   = True         ; polyline mods desired
resp@gsLineThicknessF  = 4.0          ; thickness of lines

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

dum = new (4,graphic)

; draw each line separately. Each line must contain two points.
do i =0,3
 dum(i) = gsn_add_polyline (wks,plot1(4),xpts(i:i+1),ypts(i:i+1),resp)
end do

draw(plot1(4))
frame(wks)

;*******************************************
;create panel resources
;*******************************************
;resP                  = True
;maximize_output(wks,resP)

;resP@txFontHeightF    = 0.04       ;height of text
;resP@txString         = "Differences in JAS Diabatic Heating"   ;add common title
;resP@gsnPanelLabelBar = True       ;add common colorbar

;gsn_panel(wks,plot1(0),(/1,1/),resP)          ; create panel

end
