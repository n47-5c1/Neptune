;*************************************************************
;Aim: Draw teleconnectivity of seasonal geopotential height
;Mission:
;
;   1. Read data from teleconnectivity datasets
;   2. Draw the teleconnectivity
;                       He Shan
;                       2016-05-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------hgt
;================================================

;time
    season = (/"MAM","JJA","SON","DJF"/)

;datas
    in_path = "~/hes/One_Belt_One_Road/NCL/"
    in_name = "tele_"+season+"_LP_60_hgt.nc "      ;<<<<<<change>>>>>>

;Region
    latN = 75
    latS = 0
;    lonL = -60
;    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "tele_seasonal_LP_60_hgt"      ;<<<<<<change>>>>>>

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    tele_files  = systemfunc ("ls "+in_path+in_name(0)+in_path+in_name(1)+in_path+in_name(2)+in_path+in_name(3))
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    tele_in     = addfiles (tele_files, "r")     ;note the "s" of addfile
    ListSetType (tele_in, "join")   ;concatenate or joined

    tele_p      = tele_in[:]->tele(:,{latN:latS},:)
    tele        = tele_p
    tele(0,:,:) = tele_p(2,:,:)
    tele(1,:,:) = tele_p(1,:,:)
    tele(2,:,:) = tele_p(3,:,:)
    tele(3,:,:) = tele_p(0,:,:)
    tele        = -100.*tele

    print (tele_files)
    printVarSummary (tele)

; ==============================================================
; Mission 2. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks ("eps",out_path+out_name)   ;open a ps file
 plot = new(4,graphic)                           ;creat a plot array
 gsn_define_colormap (wks,"gsltod")              ;choose a colormap

;-----------------------------------------------------------------------------
res = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
;res@gsnPolar        = "NH"       ;specify the hemisphere
res@gsnRightString  = " "
;res@gsnPolarLabelFontHeightF = .025

res@mpFillOn       = False      ;turn off map fill
res@mpCenterLonF   = 60.        ;get the correct map
res@mpMinLatF      = latS
res@mpMaxLatF      = latN
;res@mpMinLonF      = lonLm
;res@mpMaxLonF      = lonRm

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels

res@tmXBLabelFontHeightF = .016   ;font height of tick labels
res@tmYLLabelFontHeightF = .016
res@tmXBTickSpacingF     = 60.    ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 64
res@cnMaxLevelValF       = 80
res@cnLevelSpacingF      = 4

res@lbLabelBarOn = False

do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = season(i)
 plot(i) = gsn_csm_contour_map (wks,tele(i,:,:),res)
end do

;---------------------------------------------------------------
;probability plots
;res2 = True

;res2@gsnDraw              = False            ;don't draw
;res2@gsnFrame             = False            ;don't advance frame
;res2@gsnLeftString        = " "
;res2@gsnRightString       = " "

;res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
;res2@cnMinLevelValF       = 0.00             ;set min contour level
;res2@cnMaxLevelValF       = 0.10             ;set max contour level
;res2@cnLevelSpacingF      = 0.01             ;set contour spacing
;res2@cnInfoLabelOn        = False
;res2@cnLinesOn            = False            ;do not draw contour lines
;res2@cnLineLabelsOn       = False            ;do not draw contour labels
;res2@cnFillDotSizeF       = 0.003            ;set a uniform dot size
;res2@cnFillScaleF         = 1.2              ;add extra density

;plot2 = gsn_csm_contour (wks,prob,res2)
;plot2 = ShadeLtContour (plot2,0.015,17)      ;shade all areas < 0.015 contour
;overlay (plot(1),plot3)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "60-day LP Teleconnectivity of seasonal 250 hPa HGT"   ;<<<<<<change>>>>>>
resP@gsnPanelLabelBar         = True      ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.008    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
