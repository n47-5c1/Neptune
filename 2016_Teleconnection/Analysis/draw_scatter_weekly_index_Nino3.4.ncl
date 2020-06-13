;*************************************************************
;Aim: Draw a scatter plot with a regression line of the weekly teleconnection index and Niño 3.4 index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the scatter plot
;                       He Shan
;                       2017-06-15
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------index
;   var2--------------sst
;================================================

;    in1 = "./PC_Index.nc"      ;<<<<<<change>>>>>>
    in1 = "./PC_square_Index.nc"
    in2 = "~/hes/One_Belt_One_Road/NCL/sst.weekly.mean.anom_1982-2015.nc"
    rad = 4.*atan(1.)/180.

;time
    mS     = 11
    mE     = 4
    yS     = 1982
    yE     = 2015
    maxlag = 16
    lag    = ispan(-maxlag,maxlag,1)

;Nino 3.4
    latN = 5
    latS = -5
    lonW = 190
    lonE = 240

    opt                = True
    opt@nval_crit      = 4          ;the minimum number of values needed
    opt@segment_length = 7

;Fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
;    out_name = "timeseries_weekly_index_Nino3.4"      ;<<<<<<change>>>>>>
    out_name = "scatter_weekly_square_index_Nino3.4"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"Scatter","Correlation"/)
    text3 = (/"Lag: -7","a=0.05"/)
    text4 = (/"Index anomalies","SST anomalies (deg C)"," ","Lag (weeks)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    f        = addfile (in1, "r")
    SST_file = addfile (in2,"r")

;get the time indexs
    time  = f->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    iYYYY = ind (year.ge.yS)
    month = toint ( TIME(iYYYY,1) )
    iMM   = ind (month.lt.mS .and. month.gt.mE)   ;for summer-half year
    printVarSummary (iYYYY)
    printVarSummary (iMM)

;create required yyyyddd
    day     = toint ( TIME(iYYYY,2) )
    ddd     = day_of_year (year(iYYYY), month, day)
    yyyyddd = year(iYYYY)*1000 + ddd

    index = f->INDEX(iYYYY)
    SST   = SST_file->sst(:,{latS:latN},{lonW:lonE})
    printVarSummary (index)
    printVarSummary (SST)

;---------------------------------------------------------------
;creat weights: cos(lat)
    gw = SST_file->lat({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Daily anomalies
    index_p    = conform_dims ((/dimsizes(index),1,1/),index,0)
    index_p    = index
    index_p!1  = "lat"
    index_p!2  = "lon"
    index_clm  = clmDayTLL (index_p, yyyyddd)
    index_anom = calcDayAnomTLL (index_p, yyyyddd, index_clm)
    index_anom(iMM,:,:) = index_anom@_FillValue      ;leave winter-half year alone
    printVarSummary (index_anom)

;Calculate segment means
    index_seg = calculate_segment_values (index_anom(:,0,0), "avg", 0, opt)
    printVarSummary (index_seg)

;compute regional means
   Nino34 = wgt_areaave_Wrap ( SST, gw, 1., 0)
   printVarSummary (Nino34)

;-------------------------------------------------------------
;get the deserved time indexs
   iR1         = ind (index_seg.ne.index_anom@_FillValue)
   iR2         = iR1 - 7
   Nino34_r    = Nino34(iR2(7:))
   index_seg_r = index_seg(iR1(7:))
   printVarSummary (Nino34_r)

;calculate the regression coefficient
   rc = regline(Nino34_r,index_seg_r)
   print (rc)

;Create an array
   data      = new((/2,dimsizes(Nino34_r)/),typeof(Nino34_r))
   data(0,:) = index_seg_r
   data(1,:) = rc*(Nino34_r-rc@xave) + rc@yave
   copy_VarAtts (index_seg,data)
   printVarSummary (data)
   print ( data(0, ind(index_seg_r.ge.9) ) )
   print ( num(index_seg_r.ge.9) )

;---------------------------------------------------------------
;compute cross correlation of the EOF
   ccr_n = esccr (Nino34,index_seg,maxlag)
   ccr_p = esccr (index_seg,Nino34,maxlag)
   ccr   = new (2*maxlag+1,typeof(ccr_n))

   ccr(:maxlag) = ccr_n(::-1)
   ccr(maxlag:) = ccr_p
   printVarSummary (ccr)

;determine the statistical significance
;   prob = rtest (ccr,dimsizes(Nino34_r),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;   print (prob)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================
wks  = gsn_open_wks ("svg",out_path+out_name)
plot = new (2,graphic)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnLeftString         = text1(0)
res@gsnCenterString       = text2(0)
res@gsnRightString        = text3(0)
;res@gsnRightString        = " "
res@gsnStringFontHeightF  = 0.025

res@tiYAxisString     = text4(0)
res@tiXAxisString     = text4(1)
;res@tiMainString      = "Weekly Teleconnection and Nino 3.4 Index"
;res@tiMainFontHeightF = 0.03

res@trYMaxF = 9.
res@trXMaxF = 4.
res@trXMinF = -4.

res@tmXBLabelFontHeightF = 0.025    ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineModes  = (/"Markers","Lines"/)
res@xyMarkers        = 16
res@xyMarkerColor    = "red3"
res@xyMarkerSizeF    = 0.003
res@xyLineColor      = "black"
;res@xyDashPatterns   = 1
res@xyLineThicknessF = 2

plot(0) = gsn_csm_xy (wks,Nino34_r,data,res)

;*******************************************
;  plot cross correlation of the EOF
;*******************************************
resc = True

resc@gsnDraw     = False
resc@gsnFrame    = False
resc@gsnYRefLine = .066
resc@gsnLeftString          = text1(1)
resc@gsnCenterString        = text2(1)
resc@gsnRightString         = text3(1)
resc@gsnStringFontHeightF   = 0.024
resc@gsnYRefLineDashPattern = 1

resc@tiYAxisString      = text4(2)
resc@tiXAxisString      = text4(3)
resc@tiXAxisFontHeightF = 0.025

resc@tmXBLabelFontHeightF = 0.025
resc@tmYLLabelFontHeightF = 0.025

resc@vpHeightF = 0.25

plot(1) = gsn_csm_xy (wks,lag,ccr,resc)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString      = "Weekly Teleconnection and Nino 3.4 Index"
;resP@txFontHeightF = 0.026      ;height of text

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
