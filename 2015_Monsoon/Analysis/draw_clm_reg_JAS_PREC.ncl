;*************************************************************
;Aim: Draw regional JAS rainfall climatology
;
;Mission:
;   1. Read data from PREC dataset
;   2. Post-post process to deserved results
;   3. Draw the rainfall climatology
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
;   var--------------precip
;================================================

;time
;    yS = 1979
;    yE = 2011
    season = "JAS"      ;choose seasonal mean

;Fig name
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_reg_JAS_PREC"

;Region
    latN = 60
    latS = -30
    lonL = -30
    lonR = 170

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;GPCP 1979-2014
    PREC_file = addfile ("~/data/observation/PRECPT/GPCP_precip.mon.mean.nc","r")
    PREC = PREC_file->precip
    TIME = PREC_file->time
    printVarSummary (PREC)

;get the time indexs
;    YYYY   = cd_calendar (TIME,-1)/100
;    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate JAS PREC Clm
;   PREC_JAS = dim_avg_n_Wrap ( month_to_season ( PREC(iYYYY,:,:) ,season) ,0)
   PREC_JAS = dim_avg_n_Wrap ( month_to_season ( PREC ,season) ,0)
   printVarSummary (PREC_JAS)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)   ;open a eps file

 gsn_define_colormap(wks,"WhiteBlue")   ; choose a colormap

;---------------------------------------------------------------
res                 = True

res@gsnLeftString   = "GPCP"
res@gsnCenterString = season

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
res@cnMinLevelValF       = 1.
res@cnMaxLevelValF       = 14.
res@cnLevelSpacingF      = 1.

;res@tiMainString = "Sahel JAS Rainfall Climatology"   ;add title
;res@tiMainFontHeightF    = 0.04    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@pmLabelBarOrthogonalPosF = 0.2   ;move Label Bar down

plot = gsn_csm_contour_map (wks,PREC_JAS,res)

end
