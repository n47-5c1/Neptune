;*************************************************************
;Aim: Draw difference in global monthly total precipitation rate in CAM5 for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-08-08
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------PRECC
;   var2--------------PRECL
;================================================

;data
;    in_path = "~/data-model/hes/FC5PM_EP/"
    in_path = "~/data-model/hes/FC5PM_8297ElNino/"
    in_name1 = "CON.PRECC.mon.nc"
    in_name2 = "CON.PRECL.mon.nc"
    in_name3 = "SEN3.PRECC.mon.nc"
    in_name4 = "SEN3.PRECL.mon.nc"
    in_name5 = "SEN3.PRECC.mon.nc"
    in_name6 = "SEN3.PRECL.mon.nc"

    unit = 1000 * 3600 * 24

;time
    yS = 6
    season = (/"JFM","AMJ","JAS","OND"/)

;cold tongue
    latNI = 5
    latSI = -5
    lonWI = 240
    lonEI = 280

; create points for box
    ypts1 = (/latNI,latNI,latSI,latSI,latNI/)
    xpts1 = (/lonWI,lonEI,lonEI,lonWI,lonWI/)

;region
    latN = 30
    latS = -30
    lonW = 120
    lonE = 300

;fig
    out_path = "~/hes/ENSO/Complexity/Fig/Animation/"
    out_name = "diff_g_PRECT_"

;text
    text1 = (/"00","01","02","03","04","05","06","07"/)
;    text2 = (/"a) SEN1 - CON","b) SEN2 - SEN1"/)
    text2 = (/"CON - SEN","b) SEN2 - SEN1"/)
    text3 = (/"JFM(0)","AMJ(0)","JAS(0)","OND(0)","JFM(+1)","AMJ(+1)","JAS(+1)","OND(+1)"/)
    text4 = "mm/d"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1,"r")
    in2 = addfile(in_path + in_name2,"r")
    in3 = addfile(in_path + in_name3,"r")
    in4 = addfile(in_path + in_name4,"r")
    in5 = addfile(in_path + in_name5,"r")
    in6 = addfile(in_path + in_name6,"r")

;get the time indexs
;    time = in1->time
;    year = cd_calendar(time, -1) /100
;    iYYYY = ind (year .ge. yS)

    a = 12 * 5
    PRECC1 = in1->PRECC(a:,:,:)
    PRECL1 = in2->PRECL(a:,:,:)
    PRECC1 = (/PRECC1 + PRECL1/) * unit
    PRECC2 = in3->PRECC
    PRECL2 = in4->PRECL
    PRECC2 = (/PRECC2 + PRECL2/) * unit
    PRECC3 = in5->PRECC
    PRECL3 = in6->PRECL
    PRECC3 = (/PRECC3 + PRECL3/) * unit
;    sst = lonFlip(in->ts(iYYYY,{latN:latS},:))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   PRECT1 = month_to_seasonN(PRECC1, season)
   PRECT2 = month_to_seasonN(PRECC2, season)
   PRECT3 = month_to_seasonN(PRECC3, season)
   dim = dimsizes(PRECT1)
   dim(1) = 2 * dim(0)

   diff1 = new((/dim(1),dim(2),dim(3)/), float)
   diff2 = new((/dim(1),dim(2),dim(3)/), float)
   copy_VarMeta(PRECT1(0,0,:,:), diff1(0,:,:))
   copy_VarMeta(PRECT1(0,0,:,:), diff2(0,:,:))

   do i = 0, dim(1) - 1
      if(i .lt. dim(0))
         diff1(i,:,:) = (/dim_avg_n(PRECT1(i,:9,:,:), 0) - dim_avg_n(PRECT2(i,::9,:,:), 0)/)
         diff2(i,:,:) = (/dim_avg_n(PRECT3(i,::2,:,:), 0) - dim_avg_n(PRECT2(i,::2,:,:), 0)/)
      else
         diff1(i,:,:) = (/dim_avg_n(PRECT1(i-dim(0),1:,:,:), 0) - dim_avg_n(PRECT2(i-dim(0),1::2,:,:), 0)/)
         diff2(i,:,:) = (/dim_avg_n(PRECT3(i-dim(0),1::2,:,:), 0) - dim_avg_n(PRECT2(i-dim(0),1::2,:,:), 0)/)
      end if
   end do

   printVarSummary(diff1)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw = False
res@gsnFrame = False
;res@gsnAddCyclic = True
res@gsnStringFontHeightF = .02

res@cnFillOn = True
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillPalette = "MPL_RdYlBu"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-6.,-4.5,-3.,-1.5,1.5,3.,4.5,6./)

res@lbLabelBarOn = False

;res@tmXBTickSpacingF = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@mpFillOn = False
res@mpCenterLonF = 210
;res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

;************************************************
; add the box
;************************************************
resb = True
resb@gsLineThicknessF = 3.0

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = "Difference in PRECT"
resP@txFontHeightF = 0.03
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0,dim(1)-1

 wks = gsn_open_wks("svg", out_path + out_name + text1(i))
 plot = new(2, graphic)

 res@gsnLeftString = text2(0)
 res@gsnCenterString = text3(i)
 res@gsnRightString = text4
; res@tmXBLabelsOn    = False
 plot(0) = gsn_csm_contour_map_ce(wks, diff1(i,:,:), res)

 res@gsnLeftString = text2(1)
 res@gsnCenterString = " "
 res@gsnRightString = " "
; plot(1) = gsn_csm_contour_map_ce(wks, diff2(i,:,:), res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline(wks, plot(0), xpts1(j:j+1), ypts1(j:j+1), resb)
;  dum2(j) = gsn_add_polyline(wks, plot(1), xpts1(j:j+1), ypts1(j:j+1), resb)
 end do 

 gsn_panel(wks, plot(0), (/1,1/), resP)

 delete([/wks,plot/])
end do

end
