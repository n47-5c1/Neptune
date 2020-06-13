;*************************************************************
;Aim: Draw composites of regional Cp
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2017-06-26
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------x
;   var--------------y
;================================================

;Region
    latN = 65
    latS = 0
    lonW = -50
    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_reg_Cp"

;text
    text1 = (/"a)","b)","c)","d)"/)

 wks   = gsn_open_wks("svg",out_path+out_name)
 plot  = new(4,graphic)      ;creat a plot array

res = True

res@gsnDraw           = False
res@gsnFrame          = False
res@gsnAddCyclic      = False

;res@mpFillOn               = False
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonW
res@mpMaxLonF              = lonE

;res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcRefLengthF            = 0.04            ;the length of the reference magnitude
res@vcMinDistanceF          = 0.05            ;the minimum distance of neighboring vectors
res@vcRefMagnitudeF         = 4               ;the magnitude used as the reference magnitude
;res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcLineArrowThicknessF   = 1.4
res@vcLineArrowHeadMaxSizeF = 0.02            ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.008
res@vcRefAnnoOrthogonalPosF = -0.168          ;move ref vector

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.

do i=1,4

;data
    in_name = "./daily_Ks_xy_P"+i+".nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;TN2001 Flux
    f    = addfile (in_name,"r")
    Cp_x = f->x
    Cp_y = f->y

    printVarSummary (Cp_x)
    printVarSummary (Cp_y)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute composite
   xClm = dim_avg_n_Wrap (Cp_x,0)
   yClm = dim_avg_n_Wrap (Cp_y,0)
   printVarSummary (xClm)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

n = i-1

res@gsnLeftString   = text1(n)
res@gsnCenterString = " "
if(n.eq.1) then
 res@gsnRightString = " "
end if
plot(n) = gsn_csm_vector_map (wks,xClm,yClm,res)

delete ([/Cp_x,Cp_y/])

end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Composites of 250 hPa Cp"   ;add common title
resP@txFontHeightF            = 0.025    ;height of text

gsn_panel (wks,plot,(/4,1/),resP)

end
