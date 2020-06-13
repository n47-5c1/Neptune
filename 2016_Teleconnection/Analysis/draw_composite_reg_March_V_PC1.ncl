;*************************************************************
;Aim: Draw composites of regional March meridional wind chosen by PC1 of 250 hPa wind
;Mission:
;
;   1. Read data from V datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2016-05-12
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "vwnd.mon.mean.nc"

;time
    yS     = 1979
    yE     = 2014

;regiion
    latN = 89
    latS = 0
    lonL = -80
    lonR = 170

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_reg_March_V_PC1"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)
    text2 = (/"a)","b)","c)","d)","e)","f)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    V_file = addfile (in_path+in_name,"r")

;get the time indexs
    time   = V_file->time
    TIME   = cd_calendar (time, 0)
    year   = toint ( TIME(:,0) )
    month  = toint ( TIME(:,1) )
    iYYYY  = ind (year.ge.yS .and. year.le.yE .and. month.eq.3)
    iYYYYp = ind (year.eq.1983 .or. year.eq.1987 .or. year.eq.1995 .or. year.eq.1997 .or. year.eq.1998 .or. year.eq.2003 .or. year.eq.2014 .and. month.eq.4)
    iYYYYn = ind (year.eq.1985 .or. year.eq.1991 .or. year.eq.1999 .or. year.eq.2004 .or. year.eq.2008 .or. year.eq.2010 .and. month.eq.4)

;---------------------------------------------------------
;    U_p  = U_file->uwnd(:,2,:,:)      ;850hPa
;    U_p  = U_file->uwnd(:,5,:,:)      ;500hPa
    V_p = V_file->vwnd(:,8,:,:)      ;250hPa
    V   = lonFlip (V_p)

    printVarSummary (V)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    V_c  = dim_avg_n_Wrap (V(iYYYY,:,:),0)
    V_cp = dim_avg_n_Wrap (V(iYYYYp,:,:),0)
    V_cn = dim_avg_n_Wrap (V(iYYYYn,:,:),0)

    printVarSummary(V_c)

    diff = V_c
    diff = V_cp - V_cn

; ==============================================================
; Mission 3. Draw the composites
; ==============================================================

wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
plot = new (4,graphic)      ;creat a plot array

res = True

res@gsnDraw           = False      ;don't draw
res@gsnFrame          = False      ;don't advance frame
res@gsnAddCyclic      = False
res@gsnRightString    = " "

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "NCV_blue_red"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -8.      ;set min contour level
res@cnMaxLevelValF       = 8.       ;set max contour level
res@cnLevelSpacingF      = 2.       ;set contour spacing

res@lbLabelBarOn             = False
res@pmLabelBarOrthogonalPosF = 0.21    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.012   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.012
;res@tmXBTickSpacingF     = 60.     ;label spacing

res@vpXF      = 0.12   ;position and size for contour plots
res@vpHeightF = 0.12

res@gsnLeftString   = text1(0)
res@vpYF            = 0.8
plot(0) = gsn_csm_contour_map_ce (wks,V_c,res)
res@gsnLeftString   = text1(1)
res@vpYF            = 0.62
plot(1) = gsn_csm_contour_map_ce (wks,V_cp,res)
res@gsnLeftString   = text1(2)
res@lbLabelBarOn    = True
res@vpYF            = 0.44
plot(2) = gsn_csm_contour_map_ce (wks,V_cn,res)
res@gsnLeftString   = text1(3)
res@cnMinLevelValF  = -2.8      ;set min contour level
res@cnMaxLevelValF  = 2.8       ;set max contour level
res@cnLevelSpacingF = 0.4       ;set contour spacing
res@vpYF            = 0.24
plot(3) = gsn_csm_contour_map_ce (wks,diff,res)

;*******************************************
;create panel resources
;*******************************************
resP               = True
resP@txString      = "Composites of March Meridional Wind"   ;add common title
resP@txFontHeightF = 0.025                                   ;height of text
maximize_output(wks,resP)

end
