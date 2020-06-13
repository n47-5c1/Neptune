;*************************************************************
;Aim: Draw difference in global monthly wind in CAM5 for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-08-06
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------U
;   var2--------------V
;================================================

;data
    in_path = "~/data-model/hes/FC5PM_8297ElNino/"
    in_name1 = "CON.U.mon.nc"
    in_name2 = "CON.V.mon.nc"
;    in_name3 = "SEN1.U.mon.nc"
;    in_name4 = "SEN1.V.mon.nc"
    in_name3 = "SEN3.U.mon.nc"
    in_name4 = "SEN3.V.mon.nc"
    in_name5 = "SEN2.U.mon.nc"
    in_name6 = "SEN2.V.mon.nc"

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
    latN = 31
    latS = -31
    lonW = 150
    lonE = 300

;fig
    out_path = "~/hes/ENSO/Complexity/Fig/Animation/"
    out_name = "diff_g_U_V_"

;text
    text1 = (/"00","01","02","03","04","05","06","07"/)
;    text2 = (/"a) (+) + (-)","b) ((+) - (-))/2"/)
    text2 = (/"CON - SEN","b) ((+) - (-))/2"/)
    text3 = (/"JFM(0)","AMJ(0)","JAS(0)","OND(0)","JFM(+1)","AMJ(+1)","JAS(+1)","OND(+1)"/)
    text4 = "m/s"

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
    U1 = in1->U(:,0,:,:)
    V1 = in2->V(:,0,:,:)
    U2 = in3->U(:,0,:,:)
    V2 = in4->V(:,0,:,:)
    U3 = in5->U(:,0,:,:)
    V3 = in6->V(:,0,:,:)
;    sst = lonFlip(in->ts(iYYYY,{latN:latS},:))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   U1_S = month_to_seasonN(U1, season)
   V1_S = month_to_seasonN(V1, season)
   U2_S = month_to_seasonN(U2, season)
   V2_S = month_to_seasonN(V2, season)
   U3_S = month_to_seasonN(U3, season)
   V3_S = month_to_seasonN(V3, season)
   dim = dimsizes(U1_S)
   dim(1) = 2 * dim(0)

   diffX1 = new((/dim(1),dim(2),dim(3)/), float)
   diffY1 = new((/dim(1),dim(2),dim(3)/), float)
   diffX2 = new((/dim(1),dim(2),dim(3)/), float)
   diffY2 = new((/dim(1),dim(2),dim(3)/), float)
   copy_VarMeta(U1_S(0,0,:,:), diffX1(0,:,:))
   copy_VarMeta(V1_S(0,0,:,:), diffY1(0,:,:))
   copy_VarMeta(U1_S(0,0,:,:), diffX2(0,:,:))
   copy_VarMeta(V1_S(0,0,:,:), diffY2(0,:,:))

   do i = 0, dim(1) - 1
      if(i .lt. dim(0))
         diffX1(i,:,:) = dim_avg_n(U1_S(i,::2,:,:), 0) - dim_avg_n(U2_S(i,::2,:,:), 0)
         diffY1(i,:,:) = dim_avg_n(V1_S(i,::2,:,:), 0) - dim_avg_n(V2_S(i,::2,:,:), 0)
         diffX2(i,:,:) = dim_avg_n(U3_S(i,::2,:,:), 0) - dim_avg_n(U2_S(i,::2,:,:), 0)
         diffY2(i,:,:) = dim_avg_n(V3_S(i,::2,:,:), 0) - dim_avg_n(V2_S(i,::2,:,:), 0)
      else
         diffX1(i,:,:) = dim_avg_n(U1_S(i-dim(0),1::2,:,:), 0) - dim_avg_n(U2_S(i-dim(0),1::2,:,:), 0)
         diffY1(i,:,:) = dim_avg_n(V1_S(i-dim(0),1::2,:,:), 0) - dim_avg_n(V2_S(i-dim(0),1::2,:,:), 0)
         diffX2(i,:,:) = dim_avg_n(U3_S(i-dim(0),1::2,:,:), 0) - dim_avg_n(U2_S(i-dim(0),1::2,:,:), 0)
         diffY2(i,:,:) = dim_avg_n(V3_S(i-dim(0),1::2,:,:), 0) - dim_avg_n(V2_S(i-dim(0),1::2,:,:), 0)
      end if
   end do

   printVarSummary(diffX1)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw = False
res@gsnFrame = False
;res@gsnAddCyclic = True
res@gsnStringFontHeightF = .02

;res@tmXBTickSpacingF = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@mpCenterLonF = 210
;res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@vcGlyphStyle = "CurlyVector"
res@vcRefLengthF = 0.07
res@vcMinDistanceF = 0.05
res@vcRefMagnitudeF = 7
;res@vcRefMagnitudeF = 3
res@vcVectorDrawOrder = "PostDraw"
res@vcLineArrowThicknessF = 1.4
res@vcLineArrowHeadMaxSizeF = 0.024
res@vcLineArrowHeadMinSizeF = 0.008
res@vcRefAnnoOrthogonalPosF = -0.21
;res@stArrowLengthF = 0.01
;res@stMinArrowSpacingF = 0.08
;res@stLineThicknessF = 1.1
;res@stMinDistanceF = 0.05
;res@stMinLineSpacingF = 0.004

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
resP@txString = "Difference in U/V"
resP@txFontHeightF = 0.03

;----------------------------------------------------------
do i = 0,dim(1)-1

 wks = gsn_open_wks("svg", out_path + out_name + text1(i))
 plot = new(2, graphic)

 res@gsnLeftString = text2(0)
 res@gsnCenterString = text3(i)
 res@gsnRightString = text4
; res@tmXBLabelsOn    = False
 NX = diffX1(i,:,:)
 NY = diffY1(i,:,:)
 NX = (/diffX1(i,:,:)/)
 NY = (/diffY1(i,:,:)/)
; NX = (/diffX1(i,:,:) + diffX2(i,:,:)/)
; NY = (/diffY1(i,:,:) + diffY2(i,:,:)/)
 plot(0) = gsn_csm_vector_map_ce(wks, NX, NY, res)

 res@gsnLeftString = text2(1)
 res@gsnCenterString = " "
 res@gsnRightString = " "
 LX = diffX2(i,:,:)
 LY = diffY2(i,:,:)
 LX = (/diffX2(i,:,:)/)
 LY = (/diffY2(i,:,:)/)
; LX = (/diffX1(i,:,:) - diffX2(i,:,:)/) / 2.
; LY = (/diffY1(i,:,:) - diffY2(i,:,:)/) / 2.
 plot(1) = gsn_csm_vector_map_ce(wks, LX, LY, res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline(wks, plot(0), xpts1(j:j+1), ypts1(j:j+1), resb)
  dum2(j) = gsn_add_polyline(wks, plot(1), xpts1(j:j+1), ypts1(j:j+1), resb)
 end do 

 gsn_panel(wks, plot(0), (/1,1/), resP)

 delete([/wks,plot/])
end do

end
