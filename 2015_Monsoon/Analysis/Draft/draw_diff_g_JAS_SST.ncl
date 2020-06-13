;*************************************************************
;Aim: Draw correlation between JAS global SST
;Mission:
;
;   1. Read data from SST and PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the difference
;                       He Shan
;                       2015-10-23
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var--------------sst
;================================================

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981
    season = "JAS"      ;choose seasonal mean

;data
    out_path = "/home/yangsong3/yuexing/"
    out_name = "diff_JAS_g_SST"

    latS = -15.
    latN = 35.
    lonL = -70.
    lonR = 200

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;HadISST 1870-01~2015-10
    SST_file  = addfile ("/home/yangsong3/data/observation/SST/HadISST_sst-187001-201510.nc","r")

    SST     = SST_file->sst
    printVarSummary (SST)

;---------------------------------------------------------------
;get the time indexs
    TIME = SST_file->time

    YYYY   = cd_calendar (TIME,-1)/100
    iYYYYS = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYYE = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   SST       = mask (SST,SST.le.0,False)      ;set SST that are less than 0 to the _FillValue
   SST_JAS_S = month_to_season ( SST(iYYYYS,:,:) ,season)
   SST_JAS_E = month_to_season ( SST(iYYYYE,:,:) ,season)
   dim       = dimsizes (SST_JAS_S)
   printVarSummary (SST_JAS_S)
   printVarSummary (SST_JAS_E)

; compute climatologies
   SSTave50 = dim_avg_n_Wrap (SST_JAS_S,0)
   SSTave80 = dim_avg_n_Wrap (SST_JAS_E,0)
   SSTstd50 = dim_stddev_n_Wrap (SST_JAS_S,0)
   SSTstd80 = dim_stddev_n_Wrap (SST_JAS_E,0)
   printVarSummary(SSTave50)
   printVarSummary(SSTstd50)

;---------------------------------------------------------------
;copy meta data
   prob = SSTave50      ;copy meta data
   diff = SSTave50
;compute probabilities for means difference
   prob = ttest (SSTave80,SSTstd80^2,dim(0),SSTave50,SSTstd50^2,dim(0),False,False)
   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;compute differences
   diff = SSTave80 - SSTave50
   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)  ; open a ps file
 plot = new(2,graphic)       ;creat a plot array

 gsn_define_colormap(wks,"MPL_coolwarm") ; choose a colormap

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame

;res@mpGridAndLimbOn       = True        ;turn on grid lines
;res@mpGridLineColor       = "Gray30"
;res@mpCenterLonF          = 110         ;get the correct map
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR


res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels

res@tiMainString      = "Differences in JAS SST"   ;add title
res@tiMainFontHeightF = 0.02                       ;change font heights

res@tmXBLabelFontHeightF = 0.015   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.015
res@tmXBTickSpacingF     = 30.    ;label spacing

res@pmLabelBarOrthogonalPosF = 0.3   ;move Label Bar down

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -.42
res@cnMaxLevelValF       = .42
res@cnLevelSpacingF      = 0.06

res@gsnLeftString   = " "
res@gsnCenterString = "99% stippled"
;res@gsnRightString  = "C"
plot(0) = gsn_csm_contour_map (wks,diff,res)

;---------------------------------------------------------------
;probability plots
res2                = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00             ;set min contour level
res2@cnMaxLevelValF       = 0.10             ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.002   ;set a uniform dot size
res2@cnFillScaleF   = 0.9     ;add extra density

plot(1) = gsn_csm_contour (wks,prob,res2)
plot(1) = ShadeLtContour (plot(1),0.015,17)      ;shade all areas < 0.015 contour
overlay (plot(0),plot(1))

draw(plot(0))
frame(wks)

end
