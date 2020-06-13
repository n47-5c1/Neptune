;*************************************************************
;Aim: Draw Sahel JAS rainfall climatology
;
;Mission:
;   1. Read data from PREC dataset
;   2. Post-post process to deserved results
;   3. Draw the rainfall climatology
;                       He Shan
;                       2015-04-26
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

    GRAY = False      ;colour?
;    GRAY = True       ;colour?

;time
    yS = 1950
    yE = 1981
    season = "JAS"      ;choose seasonal mean

;Fig name
    out_path = "~/hes/Sahel_Rainfall/final/"
    if(GRAY) then
     out_name = "Sahel_JAS_PREC_Clm_gray"
    else
     out_name = "Sahel_JAS_PREC_Clm"
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
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate JAS PREC Clm
   PREC_JAS = dim_avg_n_Wrap ( month_to_season ( PREC(iYYYY,:,:) ,season) ,0)
   printVarSummary (PREC_JAS)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)   ;open a eps file

 if(GRAY)then
  gsn_define_colormap(wks,"MPL_Greys")      ; choose a colormap
 else
  gsn_define_colormap(wks,"WhiteBlue")   ; choose a colormap
 end if

;---------------------------------------------------------------
res                 = True

;res@gsnDraw         = False      ;don't draw
;res@gsnFrame        = False      ;don't advance frame
res@gsnLeftString   = "a)"
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
res@cnMaxLevelValF       = 13.
res@cnLevelSpacingF      = 1.

;res@tiMainString = "Sahel JAS Rainfall Climatology"   ;add title
;res@tiMainFontHeightF    = 0.04    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@pmLabelBarOrthogonalPosF = 0.15   ;move Label Bar down

plot = gsn_csm_contour_map (wks,PREC_JAS,res)

;************************************************
; add the box
;************************************************
;resp                   = True         ; polyline mods desired
;resp@gsLineThicknessF  = 4.0          ; thickness of lines

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

;dum = new (4,graphic)  

; draw each line separately. Each line must contain two points.
;do i =0,3
; dum(i) = gsn_add_polyline (wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
;end do 

;draw(wks)

end
