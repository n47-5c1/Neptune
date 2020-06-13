;*************************************************************
;Aim: Draw the weekly teleconnection index and Nino 3.4 index time series
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the timeseries
;                       He Shan
;                       2017-05-28
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

    in1 = "./PC_Index.nc"
    in2 = "~/hes/One_Belt_One_Road/NCL/sst.weekly.mean.anom_1982-2015.nc"
    rad = 4.*atan(1.)/180.

;time
    mS = 11
    mE = 4
    yS = 1982
    yE = 2015

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
    out_name = "timeseries_weekly_index_Nino3.4"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)

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
    x         = fspan (yS,yE,dimsizes(index_seg))
    printVarSummary (index_seg)

;compute regional means
   Nino34 = wgt_areaave_Wrap ( SST, gw, 1., 0)
   printVarSummary (Nino34)

   data      = new((/2,dimsizes(Nino34)/),typeof(Nino34))
   data(0,:) = index_seg
   data(1,:) = Nino34
   copy_VarAtts (index_seg,data)
   printVarSummary (data)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================
wks = gsn_open_wks ("svg",out_path+out_name)

;*******************************************
;  plot timeseries
;*******************************************
res = True

;res@gsnDraw         = False
;res@gsnFrame        = False
;res@gsnLeftString   = Text1(i)
;res@gsnCenterString = "Sahel: "+lonW1+"-"+lonE1+"E "+latS1+"-"+latN1+"N"
;res@gsnRightString  = season(0)

;res@trYMinF = min (P_reg)
;res@trYMaxF = max (P_reg)

res@tiYAxisString     = SST@units      ;y-axis labal
res@tiMainString      = "Weekly Teleconnection and Nino 3.4 Index"
;res@tiMainFontHeightF = 0.021

res@tmXBLabelFontHeightF = 0.02    ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

res@trXMaxF = yE
res@trXMinF = yS

res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyLineColors     = (/"black","red"/)
res@xyDashPatterns   = (/0,0/)      ;Dash patterns
;res@xyLineThicknessF = 4.0

plot = gsn_csm_xy (wks,x,data,res)

/;
;*******************************************
;create panel resources
;*******************************************
resP                = True
resP@txString       = "Regional Mean Precipitation and Cloudiness"   ;add common title
resP@txFontHeightF  = 0.026      ;height of text
resP@gsnPanelBottom = 0.05       ;add some space at bottom

gsn_panel(wks,plot,(/na,1/),resP)          ; create panel
;/

end
