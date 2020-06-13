;*************************************************************
;Aim: Draw composites of regional March, April and May air temperature chosen by regional average Ks
;Mission:
;
;   1. Read data from uwnd, air & pres datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2016-07-07
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------air
;   var3--------------pres
;================================================

;data
    a        = 6378388.
    omega    = 7.27*10.^(-5.)
    deg2rad  = 0.0174533      ;2*pi/360
    in_path  = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "air.mon.mean.nc"
    in_name3 = "pres.mon.mean.nc"

;time
    mS = 3
    mE = 5
    yS = 1979
    yE = 2015

;Map
    latN = 89
    latS = 0
    lonL = -80
    lonR = 170

;Region
    latNK = 30
    latSK = 20
    lonLK = 30
    lonRK = 60

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_reg_MAM_mon_air_Ks"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","m)","n)","o)","p)","q)","r)"/)
    text2 = (/"March","April","May"/)
    text3 = (/"CLM","DIFF"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file   = addfile (in_path+in_name1,"r")
    air_file = addfile (in_path+in_name2,"r")
    PS_file  = addfile (in_path+in_name3,"r")

;get the time indexs
    time1  = U_file->time
    time2  = air_file->time
    time3  = PS_file->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    TIME3  = cd_calendar (time3, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    year3  = toint ( TIME3(:,0) )
    month1 = toint ( TIME1(:,1) )
    month2 = toint ( TIME2(:,1) )
    month3 = toint ( TIME3(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.mS .and. month1.le.mE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.ge.mS .and. month2.le.mE)
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE .and. month3.ge.mS .and. month3.le.mE)

;---------------------------------------------------------
    U   = U_file->uwnd(iYYYY1,(/8,5,2/),:,:)
    air = air_file->air(iYYYY2,(/8,5,2/),:,:)
    PS  = PS_file->pres(iYYYY3,:,:)

    lat  = U&lat
    dlat = (lat(2)-lat(1))*deg2rad
    dy   = a*dlat                      ;convert to dist

    printVarSummary (U)
    printVarSummary (air)
    printVarSummary (PS)
    printVarSummary (iYYYY1)
    printVarSummary (iYYYY2)
    printVarSummary (iYYYY3)
    print(dy)

;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = air_file->lat({latSK:latNK})
    gw  = cos(rad*gw)
    printVarSummary(gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute Ks
    U_p   = U(:,0,:,:)
    beta  = conform (U_p, 2.*omega/a*cos(U_p&lat*deg2rad), 1)
    betaa = beta - center_finite_diff_n( center_finite_diff_n(U_p,dy,False,0,1) ,dy,False,0,1 )
    U_p   = mask (U_p,U_p.le.0.,False)
    Ks    = betaa/U_p/abs(betaa/U_p) * sqrt ( abs(betaa/U_p) )
    copy_VarCoords (U_p,Ks)
    printVarSummary (Ks)

;compute regional average
    Ks_reg = wgt_areaave_Wrap ( Ks(:,{latSK:latNK},{lonLK:lonRK}), gw,1.,0)
   
    Ks_1 = Ks_reg(::3)
    Ks_2 = Ks_reg(1::3)
    Ks_3 = Ks_reg(2::3)
    ave1 = avg (Ks_1)
    ave2 = avg (Ks_2)
    ave3 = avg (Ks_3)
    std1 = .8*stddev (Ks_1)
    std2 = .8*stddev (Ks_2)
    std3 = .8*stddev (Ks_3)

    printVarSummary (Ks_1)

;---------------------------------------------------------
    PS_1 = dim_avg_n_Wrap (PS(::3,:,:),0)
    PS_2 = dim_avg_n_Wrap (PS(1::3,:,:),0)
    PS_3 = dim_avg_n_Wrap (PS(2::3,:,:),0)

;Composite Analysis
    comp1p = ind (Ks_1.gt.ave1+std1)
    comp1n = ind (Ks_1.lt.ave1-std1)
    comp2p = ind (Ks_2.gt.ave2+std2)
    comp2n = ind (Ks_2.lt.ave2-std2)
    comp3p = ind (Ks_3.gt.ave3+std3)
    comp3n = ind (Ks_3.lt.ave3-std3)
    
    year_p = year2(iYYYY2)
    year_c = year_p(::3)
    print(year_c(comp1p))
    print(year_c(comp1n))
    print(year_c(comp2p))
    print(year_c(comp2n))
    print(year_c(comp3p))
    print(year_c(comp3n))

    air_p1 = air(::3,:,:,:)
    air_p2 = air(1::3,:,:,:)
    air_p3 = air(2::3,:,:,:)

    air_c1p = dim_avg_n_Wrap (air_p1(comp1p,:,:,:),0)
    air_c1n = dim_avg_n_Wrap (air_p1(comp1n,:,:,:),0)
    air_c2p = dim_avg_n_Wrap (air_p2(comp2p,:,:,:),0)
    air_c2n = dim_avg_n_Wrap (air_p2(comp2n,:,:,:),0)
    air_c3p = dim_avg_n_Wrap (air_p3(comp3p,:,:,:),0)
    air_c3n = dim_avg_n_Wrap (air_p3(comp3n,:,:,:),0)
    airclm1 = dim_avg_n_Wrap (air_p1,0)
    airclm2 = dim_avg_n_Wrap (air_p2,0)
    airclm3 = dim_avg_n_Wrap (air_p3,0)

    printVarSummary(air_c1p)

    diff_1 = air_c1p
    diff_2 = air_c2p
    diff_3 = air_c3p

    diff_1 = air_c1p - air_c1n
    diff_2 = air_c2p - air_c2n
    diff_3 = air_c3p - air_c3n

    printVarSummary(diff_1)

; ==============================================================
; Mission 3. Draw the composites
; ==============================================================

wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
plot = new (18,graphic)      ;creat a plot array

res = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap
res@cnLineLabelsOn = False       ;turn off cn line labels

;res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.021   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.021

airclm1 = mask (airclm1, conform(airclm1,PS_1,(/1,2/)).ge.conform(airclm1,airclm1&level,0), True)
diff_1  = mask (diff_1, conform(airclm1,PS_1,(/1,2/)).ge.conform(airclm1,airclm1&level,0), True)

airclm2 = mask (airclm2, conform(airclm1,PS_2,(/1,2/)).ge.conform(airclm1,airclm1&level,0),True)
diff_2  = mask (diff_2, conform(airclm1,PS_2,(/1,2/)).ge.conform(airclm1,airclm1&level,0),True)

airclm3 = mask (airclm3, conform(airclm1,PS_3,(/1,2/)).ge.conform(airclm1,airclm1&level,0),True)
diff_3  = mask (diff_3, conform(airclm1,PS_3,(/1,2/)).ge.conform(airclm1,airclm1&level,0),True)

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -56.      ;set min contour level
res@cnMaxLevelValF       = -40.      ;set max contour level
res@cnLevelSpacingF      = 4.        ;set contour spacing
res@gsnLeftString   = text1(0)+" "+airclm1&level(0)+" hPa"
res@gsnCenterString = text2(0)
res@gsnRightString  = text3(0)
plot(0) = gsn_csm_contour_map_ce (wks,airclm1(0,:,:),res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
plot(1) = gsn_csm_contour_map_ce (wks,airclm2(0,:,:),res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
res@gsnRightString  = air@units
plot(2) = gsn_csm_contour_map_ce (wks,airclm3(0,:,:),res)
res@cnMinLevelValF  = -25.
res@cnMaxLevelValF  = -5.
res@cnLevelSpacingF = 5.
res@gsnLeftString   = text1(3)+" "+airclm1&level(1)+" hPa"
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(3) = gsn_csm_contour_map_ce (wks,airclm1(1,:,:),res)
res@gsnLeftString   = text1(4)
plot(4) = gsn_csm_contour_map_ce (wks,airclm2(1,:,:),res)
res@gsnLeftString   = text1(5)
plot(5) = gsn_csm_contour_map_ce (wks,airclm3(1,:,:),res)
res@cnMinLevelValF  = -5.
res@cnMaxLevelValF  = 25.
res@cnLevelSpacingF = 5.
res@gsnLeftString   = text1(6)+" "+airclm1&level(2)+" hPa"
plot(6) = gsn_csm_contour_map_ce (wks,airclm1(2,:,:),res)
res@gsnLeftString   = text1(7)
plot(7) = gsn_csm_contour_map_ce (wks,airclm2(2,:,:),res)
res@gsnLeftString   = text1(8)
plot(8) = gsn_csm_contour_map_ce (wks,airclm3(2,:,:),res)


res@cnFillPalette   = "CBR_coldhot"   ;choose a colormap
res@cnMinLevelValF  = -2.
res@cnMaxLevelValF  = 2.
res@cnLevelSpacingF = .5
res@gsnLeftString   = text1(9)+" "+airclm1&level(0)+" hPa"
res@gsnRightString  = text3(1)
plot(9)  = gsn_csm_contour_map_ce (wks,diff_1(0,:,:),res)
res@gsnLeftString   = text1(10)
res@gsnRightString  = " "
plot(10) = gsn_csm_contour_map_ce (wks,diff_2(0,:,:),res)
res@gsnLeftString   = text1(11)
plot(11) = gsn_csm_contour_map_ce (wks,diff_3(0,:,:),res)
res@gsnLeftString   = text1(12)+" "+airclm1&level(1)+" hPa"
plot(12) = gsn_csm_contour_map_ce (wks,diff_1(1,:,:),res)
res@gsnLeftString   = text1(13)
plot(13) = gsn_csm_contour_map_ce (wks,diff_2(1,:,:),res)
res@gsnLeftString   = text1(14)
plot(14) = gsn_csm_contour_map_ce (wks,diff_3(1,:,:),res)
res@gsnLeftString   = text1(15)+" "+airclm1&level(2)+" hPa"
plot(15) = gsn_csm_contour_map_ce (wks,diff_1(2,:,:),res)
res@gsnLeftString   = text1(16)
plot(16) = gsn_csm_contour_map_ce (wks,diff_2(2,:,:),res)
res@gsnLeftString   = text1(17)
plot(17) = gsn_csm_contour_map_ce (wks,diff_3(2,:,:),res)

;*******************************************
;create panel resources
;*******************************************
resP                    = True
resP@gsnFrame           = False        ;don't advance frame yet
resP@gsnPanelBottom     = 0.8         ;move bottom up
resP@gsnPanelLabelBar   = True         ;common label bar
resP@lbOrientation      = "vertical"   ;vertical label bar
resP@lbLabelFontHeightF = 0.01
resP@txFontHeightF      = 0.025        ;height of text
resP@txString           = "Composites of Air Temperature"   ;add common title
gsn_panel(wks,plot(0:2),(/1,3/),resP)
delete(resP@txString)
resP@gsnPanelTop    = 0.8        ;draw up to the bdry of upper plot
resP@gsnPanelBottom = 0.66       ;move bottom up
gsn_panel(wks,plot(3:5),(/1,3/),resP)
resP@gsnPanelTop    = 0.66
resP@gsnPanelBottom = 0.52
gsn_panel(wks,plot(6:8),(/1,3/),resP)
resP@gsnPanelTop    = 0.52
resP@gsnPanelBottom = 0.11
gsn_panel(wks,plot(9:17),(/3,3/),resP)
frame(wks)

end
