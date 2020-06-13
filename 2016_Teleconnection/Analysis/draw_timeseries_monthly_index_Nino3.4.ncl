;*************************************************************
;Aim: Draw the monthly teleconnection index and Nino 3.4 index time series
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
    in2 = "~/data/observation/SST/HadISST_sst_1870-2016.nc"
;    in2 = "~/hes/One_Belt_One_Road/NCL/sst.weekly.mean.anom_1982-2015.nc"
    rad = 4.*atan(1.)/180.

;time
    mS = 11
    mE = 4
    yS = 1979
    yE = 2015

;Nino 3.4
    latN = 5
    latS = -5
    lonW = -170
    lonE = -120

;Fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "timeseries_monthly_index_Nino3.4"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    f        = addfile (in1, "r")
    SST_file = addfile (in2,"r")

;get the time indexs
    time  = SST_file->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    month = toint ( TIME(iYYYY,1) )
    iMM   = ind (month.lt.mS .and. month.gt.mE)   ;for summer-half year
    x     = fspan (yS,yE,dimsizes(iYYYY))
    printVarSummary (iYYYY)
    printVarSummary (iMM)

    index = f->INDEX
    SST   = SST_file->sst(iYYYY,:,:)
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
    index_Clm  = clmMonTLL (index_mon)
    SST_Clm    = clmMonTLL (SST)
    index_Anom = calcMonAnomTLL (index_mon, index_Clm)
    SST_Anom   = calcMonAnomTLL (SST, SST_Clm)
    index_Anom(iMM,:,:) = index_Anom@_FillValue      ;leave winter-half year alone
    printVarSummary (index_Anom)
    printVarSummary (SST_Anom)

;compute regional means
   Nino34 = wgt_areaave_Wrap ( SST_Anom(:,{latS:latN},{lonW:lonE}), gw, 1., 0)
   printVarSummary (Nino34)

   data      = new((/2,dimsizes(Nino34)/),typeof(Nino34))
   data(0,:) = index_Anom (:,0,0)
   data(1,:) = Nino34
   copy_VarAtts (index_Anom,data)
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
res@tiMainString      = "Monthly Teleconnection and Nino 3.4 Index"
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
