;*************************************************************
;Aim: Draw difference of regional summer anomalous precipitation and cloud cover 
;Mission:
;
;   1. Read data from PREC & Cloud  datasets
;   2. Post-post process to deserved results
;   3. Draw the difference
;                       He Shan
;                       2017-04-21
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------precip
;	var2--------------prate
;	var3--------------lsp
;	var4--------------cp
;	var5--------------cldc
;================================================

;datas
;1948-01~2012-01
    file1 = "~/data/observation/PRECL/precip.mon.mean.0.5x0.5.nc"
;1948/01-
    file2 = "~/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;1957/09-2002/08
    file3 = "~/data/observation/ERA-40/monthly/lsp.cp.tcc.mon.mean.deg1.nc"

;unit
    unit1 = 60.*60.*24.   ;Kg/m^2/s -> mm/day
    unit2 = 4000.         ;m -> mm/day

;time
    yS1    = 1960
    yE1    = 1969
    yS2    = 1980
    yE2    = 1989
    season = (/"JAS","JJA"/)

;Sahel
    latN1 = 20
    latS1 = 10
    lonW1 = -20
    lonE1 = 35

;Asia
    latN2 = 30
    latS2 = -10
    lonW2 = 70
    lonE2 = 150

;Map
/;
    latNm1 = 40
    latSm1 = -5
    lonWm1 = -35
    lonEm1 = 45

    latNm2 = 40
    latSm2 = -20
    lonWm2 = 50
    lonEm2 = 170
;/
    latNm1 = 40
    latSm1 = -20
    lonWm1 = -35
    lonEm1 = 170

    latNm2 = 40
    latSm2 = -20
    lonWm2 = -35
    lonEm2 = 170

;data
    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "diff_reg_Summer_PREC_Cloud"
    
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

;create points for box
    ypts1 = (/latN1,latN1,latS1,latS1,latN1/)
    xpts1 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)

    ypts2 = (/latN2,latN2,latS2,latS2,latN2/)
    xpts2 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)
/;
;-- define polygon x- and y-arrays
    x = (/110., 160., 160., 110., 110./)
    y = (/-45., -45., -10., -10., -45./)
      
;-- polygon resources
    pgres                        =  True
    pgres@gsFillColor            = "green"      ;-- fill color
    pgres@gsFillOpacityF         =  0.3         ;-- set opacity of polygon
    gon_1 = gsn_add_polygon(wks, map, x, y, pgres)
;/
; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (file1, "r")
    in2 = addfile (file2, "r")
    in3 = addfile (file3, "r")

    PREC1 = in1->precip
    PREC1 = lonFlip (PREC1)
    PREC2 = in2->prate
    PREC2 = unit1*PREC2
    PREC3 = short2flt (in3->lsp)
    PREC4 = short2flt (in3->cp)
    PREC3 = PREC3+PREC4
    PREC3 = unit2*PREC3

    PREC1@units = "mm/day"
    PREC2@units = "mm/day"

    printVarSummary (PREC1)
    printVarSummary (PREC2)
    printVarSummary (PREC3)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time1  = in1->time
    time2  = in2->time
    time3  = in3->time

    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    TIME3  = cd_calendar (time3, 0)

    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    year3  = toint ( TIME3(:,0) )

    printVarSummary (year1)

;get the time indexs
    iYYYY11 = ind (year1.ge.yS1 .and. year1.le.yE1)
    iYYYY21 = ind (year2.ge.yS1 .and. year2.le.yE1)
    iYYYY31 = ind (year3.ge.yS1 .and. year3.le.yE1)
    
    iYYYY12 = ind (year1.ge.yS2 .and. year1.le.yE2)
    iYYYY22 = ind (year2.ge.yS2 .and. year2.le.yE2)
    iYYYY32 = ind (year3.ge.yS2 .and. year3.le.yE2)

    printVarSummary (iYYYY11)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute seasonal means
    y1_mon_1 = month_to_season (PREC1(iYYYY11,:,:),season(0))
    y2_mon_1 = month_to_season (PREC2(iYYYY21,:,:),season(1))
    y3_mon_1 = month_to_season (PREC3(iYYYY31,:,:),season(1))

    y1_mon_2 = month_to_season (PREC1(iYYYY12,:,:),season(0))
    y2_mon_2 = month_to_season (PREC2(iYYYY22,:,:),season(1))
    y3_mon_2 = month_to_season (PREC3(iYYYY32,:,:),season(1))

    dim = dimsizes (y1_mon_1)
 
    printVarSummary (y1_mon_1)

;calculates climatologies
    y11 = dim_avg_n_Wrap ( y1_mon_1, 0)
    y21 = dim_avg_n_Wrap ( y2_mon_1, 0)
    y31 = dim_avg_n_Wrap ( y3_mon_1, 0)

    y1std1 = dim_stddev_n_Wrap ( y1_mon_1, 0)
    y2std1 = dim_stddev_n_Wrap ( y2_mon_1, 0)
    y3std1 = dim_stddev_n_Wrap ( y3_mon_1, 0)

    y12 = dim_avg_n_Wrap ( y1_mon_2, 0)
    y22 = dim_avg_n_Wrap ( y2_mon_2, 0)
    y32 = dim_avg_n_Wrap ( y3_mon_2, 0)

    y1std2 = dim_stddev_n_Wrap ( y1_mon_2, 0)
    y2std2 = dim_stddev_n_Wrap ( y2_mon_2, 0)
    y3std2 = dim_stddev_n_Wrap ( y3_mon_2, 0)

    printVarSummary (y11)

;---------------------------------------------------------------
;copy meta data
    diff1 = y11
    diff2 = y21
    diff3 = y31

    prob1 = y11
    prob2 = y21
    prob3 = y31

;compute probabilities for means difference
    prob1 = ttest (y11,y1std1^2,dim(0),y12,y1std2^2,dim(0),False,False)
    prob2 = ttest (y21,y2std1^2,dim(0),y22,y2std2^2,dim(0),False,False)
    prob3 = ttest (y31,y3std1^2,dim(0),y32,y3std2^2,dim(0),False,False)

;compute differences
    diff1 = y12 - y11
    diff2 = y22 - y21
    diff3 = y32 - y31

    printVarSummary (diff1)
    printVarSummary (diff2)
    printVarSummary (diff3)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
plot  = new (3,graphic)      ;creat a plot array
plot2 = new (3,graphic)
wks   = gsn_open_wks ("svg",out_path+out_name)

;-----------------------------------------------------------------------------
res = True

res@gsnDraw      = False
res@gsnFrame     = False      ;don't advance frame
;res@gsnAddCyclic = False

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "Gray40"   ;colour of ontlines

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_RdBu"     ;choose a colormap

res@tmXBLabelsOn         = False   ;do not draw x labels
;res@tmXBTickSpacingF     = 30.     ;label spacing
res@tmXBLabelFontHeightF = .021    ;font height of tick labels
res@tmYLLabelFontHeightF = .021

;res@lbLabelBarOn  = False
res@lbOrientation = "vertical"

;---------------------------------------------------------------
;Sahel
res@gsnLeftString   = text1(0)
res@gsnCenterString = "80-89 - 60-69: "+season(0)

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -1.5
res@cnMaxLevelValF       = 1.5
res@cnLevelSpacingF      = 0.5

res@mpMinLatF = latSm1
res@mpMaxLatF = latNm1
res@mpMinLonF = lonWm1
res@mpMaxLonF = lonEm1

plot(0) = gsn_csm_contour_map (wks,diff1,res)

;---------------------------------------------------------------
;Asia
res@gsnLeftString   = text1(1)
res@gsnCenterString = season(1)
res@gsnRightString  = " "

res@cnMinLevelValF  = -2.7
res@cnMaxLevelValF  = 2.7
res@cnLevelSpacingF = 0.9

res@mpMinLatF = latSm2
res@mpMaxLatF = latNm2
res@mpMinLonF = lonWm2
res@mpMaxLonF = lonEm2

res@tmXBTickSpacingF = 30.

plot(1) = gsn_csm_contour_map (wks,diff2,res)

res@gsnLeftString   = text1(2)
res@gsnCenterString = " "

res@tmXBLabelsOn = True

res@cnMinLevelValF  = -4.2
res@cnMaxLevelValF  = 4.2
res@cnLevelSpacingF = 1.4

plot(2) = gsn_csm_contour_map (wks,diff3,res)

;---------------------------------------------------------------
;probability plots
res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00
res2@cnMaxLevelValF       = 0.10
res2@cnLevelSpacingF      = 0.01
res2@cnInfoLabelOn        = False
res2@cnLinesOn            = False
res2@cnLineLabelsOn       = False
res2@cnFillDotSizeF       = 0.0075   ;set a uniform dot size
res2@cnFillScaleF         = 2.       ;add extra density

plot2(0) = gsn_csm_contour (wks,prob1,res2)
plot2(1) = gsn_csm_contour (wks,prob2,res2)
plot2(2) = gsn_csm_contour (wks,prob3,res2)

do i=0,2
 plot2(i) = ShadeLtContour (plot2(i),0.055,17)      ;shade all areas less than
 overlay (plot(i),plot2(i))
end do

;---------------------------------------------------------------
; add the box

resB = True

;resB@gsLineColor      = "grey20"
resB@gsLineThicknessF = 2

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.

dum = new ((/4,4/),graphic)

;draw each line separately
do i = 0,3
 dum(i,0) = gsn_add_polyline (wks,plot(0),xpts1(i:i+1),ypts1(i:i+1),resB)
 do j = 1,2
  dum(i,j) = gsn_add_polyline (wks,plot(j),xpts2(i:i+1),ypts2(i:i+1),resB)
 end do
end do 

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@gsnPanelBottom          = 0.05       ;add some space at bottom
resP@gsnPanelMainString      = "Difference of Precipitation"
resP@gsnPanelMainFontHeightF = 0.03

;resP@gsnPanelLabelBar         = True      ;add common colorbar
;resP@lbLabelFontHeightF       = 0.018     ;label heights of labelbars
;resP@pmLabelBarOrthogonalPosF = -0.008    ;move Label Bar down

gsn_panel(wks,plot,(/3,1/),resP)      ;create panel

end
