;*************************************************************
;Aim: Draw a scatter plot with a regression line of the monthly teleconnection index and Niño 3.4 index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the scatter plot
;                       He Shan
;                       2017-11-17
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
    in2 = "~/data/observation/SST/HadISST/HadISST_sst.nc"
    rad = 4.*atan(1.)/180.

;time
    mS     = 11
    mE     = 4
    yS     = 1979
    yE     = 2015
    maxlag = 6
    lag    = ispan(-maxlag,maxlag,1)

;Nino 3.4
    latN = 5
    latS = -5
    lonW = 190
    lonE = 240

;Fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
;    out_name = "timeseries_weekly_index_Nino3.4"      ;<<<<<<change>>>>>>
    out_name = "scatter_monthly_square_index_Nino3.4"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"Scatter","Correlation"/)
    text3 = (/"Lag: -2","a=0.05"/)
    text4 = (/"Index anomalies","SST anomalies (deg C)"," ","Lag (months)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    f        = addfile (in1, "r")
    SST_file = addfile (in2,"r")

    time = SST_file->time

;get the time indexs
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    month = toint ( TIME(iYYYY,1) )
    iMM   = ind (month.lt.mS .and. month.gt.mE)   ;for summer-half year
    printVarSummary (iYYYY)
    printVarSummary (iMM)

    index = f->INDEX
    SST_p = lonFlip (SST_file->sst)
    SST   = SST_p(iYYYY,{latS:latN},{lonW:lonE})
    printVarSummary (index)
    printVarSummary (SST)

;---------------------------------------------------------------
;creat weights: cos(lat)
    gw = SST_file->latitude({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate monthly means
    index_mon_p = calculate_monthly_values (index,"avg",0,False)
    index_mon   = conform_dims ((/dimsizes(index_mon_p),1,1/),index_mon_p,0)
    index_mon   = index_mon_p
    index_mon!1 = "lat"
    index_mon!2 = "lon"
    printVarSummary (index_mon)

;Monthly anomalies
    index_Clm    = clmMonTLL (index_mon)
    SST_Clm      = clmMonTLL (SST)
    index_Anom_p = calcMonAnomTLL (index_mon, index_Clm)
    SST_Anom     = calcMonAnomTLL (SST, SST_Clm)
    index_Anom_p(iMM,:,:) = index_Anom_p@_FillValue      ;leave DJ alone
    index_Anom = index_Anom_p(:,0,0)
    printVarSummary (index_Anom)
    printVarSummary (SST_Anom)

;compute regional means
   Nino34 = wgt_areaave_Wrap ( SST_Anom, gw, 1., 0)
   printVarSummary (Nino34)

;-------------------------------------------------------------
;get the deserved time indexs
   iR1          = ind (index_Anom.ne.index_Anom@_FillValue)
   iR2          = iR1 - 2
   Nino34_r     = Nino34(iR2(2:))
   index_Anom_r = index_Anom(iR1(2:))
   printVarSummary (Nino34_r)

;calculate the regression coefficient
   rc = regline(Nino34_r,index_Anom_r)
   print (rc)

;Create an array
   data      = new((/2,dimsizes(Nino34_r)/),typeof(Nino34_r))
   data(0,:) = index_Anom_r
   data(1,:) = rc*(Nino34_r-rc@xave) + rc@yave
   copy_VarAtts (index_Anom,data)
   printVarSummary (data)
   print ( data(0, ind(index_Anom_r.ge.4.5) ) )
   print ( num(index_Anom_r.ge.4.5) )

;---------------------------------------------------------------
;compute cross correlation of the EOF
   ccr_n = esccr (Nino34,index_Anom,maxlag)
   ccr_p = esccr (index_Anom,Nino34,maxlag)
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
res@gsnLeftString         = text1(1)
res@gsnCenterString       = text2(0)
res@gsnRightString        = text3(0)
;res@gsnRightString        = " "
res@gsnStringFontHeightF  = 0.025

res@tiYAxisString     = text4(0)
res@tiXAxisString     = text4(1)
;res@tiMainString      = "Weekly Teleconnection and Nino 3.4 Index"
;res@tiMainFontHeightF = 0.03

res@trYMaxF = 4.5
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
resc@gsnYRefLine = .137
resc@gsnLeftString          = text1(0)
resc@gsnCenterString        = text2(1)
resc@gsnRightString         = text3(1)
resc@gsnStringFontHeightF   = 0.024
resc@gsnYRefLineDashPattern = 1

resc@tiYAxisString      = text4(2)
resc@tiXAxisString      = text4(3)
resc@tiXAxisFontHeightF = 0.025

resc@trYMaxF = .19
resc@trYMinF = .03

resc@tmXBLabelFontHeightF = 0.025
resc@tmYLLabelFontHeightF = 0.025

resc@vpHeightF = 0.25

plot(1) = gsn_csm_xy (wks,lag,ccr,resc)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString      = "Monthly Teleconnection and Nino 3.4 Index"
;resP@txFontHeightF = 0.026      ;height of text

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end
