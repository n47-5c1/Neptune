;*************************************************************
;Aim: Calculate teleconnectivity of seasonal stream function
;Mission:
;
;   1. Read data from daily PHIS datasets
;   2. Post-post process to deserved results
;   3. Output the mask
;                       He Shan
;                       2016-08-23
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var--------------PHIS
;================================================

;datas
    in_path = "~/hes/input/"

;Region
    latN = 40
    latS = 25
    lonL = 70
    lonR = 105

;data
    out_path = "~/hes/input/"
    out_name = "TP_mask.nc"
    fig_name = "TP_mask"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    TOPO_in = addfile (in_path+"USGS-gtopo30_1.9x2.5_remap_c050602.nc", "r")

    PHIS = TOPO_in->PHIS
    lat = TOPO_in->lat
    lon = TOPO_in->lon
    dim = dimsizes(PHIS)
    printVarSummary (PHIS)
    printVarSummary (lat)
    printVarSummary (lon)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    TP_mask = where (PHIS.eq.0.,0.,0.)
    copy_VarCoords (PHIS,TP_mask)
    TP_mask({latS:latN},{lonL:lonR}) = where (PHIS({latS:latN},{lonL:lonR}).ge.3000*9.8,1.,0.)
    printVarSummary (TP_mask)

; ==============================================================
; Mission 3. Output and draw the TP mask
; ==============================================================

system ("rm -f "+out_path+out_name)      ;remove if exists
fout = addfile (out_path+out_name,"c")   ;open output file

setfileoption (fout,"DefineMode",True)   ;declare file definition mode

;predefine the coordinate variables and their dimensionality
dimNames = (/"lat","lon"/)  
dimSizes = (/dim(0),dim(1)/) 
dimUnlim = (/False,False/)   
filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"lat",typeof(lat),getvardims(lat))                          
filevardef (fout,"lon",typeof(lon),getvardims(lon))                          
filevardef (fout,"TP_mask",typeof(TP_mask),getvardims(TP_mask))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"lat",lat)
filevarattdef (fout,"lon",lon)
;filevarattdef (fout,"TP_mask",TP_mask)

;output only the data values
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->TP_mask = (/TP_mask/)

;---------------------------------------------------------------
;draw
wks = gsn_open_wks("eps",out_path+fig_name)   ; open a ps file

res = True

res@cnFillOn        = True
res@cnLinesOn       = False
res@cnLineLabelsOn  = False        ;turn off cn line labels
res@cnFillPalette   = "GMT_gray"   ;choose a colormap
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"   ;set explicit contour levels
res@cnLevels             = 0.5               ;set levels
res@cnFillColors         = (/9,0/)           ;set the colors to be use

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@mpCenterLonF    = 110          ;get the correct map
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonL
;res@mpMaxLonF = lonR

res@pmLabelBarOrthogonalPosF = 0.25   ;move whole thing down
res@gsnAddCyclic = False
plot = gsn_csm_contour_map_ce (wks,TP_mask,res)

end
