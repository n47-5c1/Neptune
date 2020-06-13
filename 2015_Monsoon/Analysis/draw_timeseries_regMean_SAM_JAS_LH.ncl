;*************************************************************
;Aim: Draw the region mean SAM JAS latent heating time series (raw and low pass filtered) and trend
;
;Mission:
;   1. Read data from PREC dataset
;   2. Post-post process to deserved results
;   3. Draw the timeseries and trend
;                       He Shan
;                       2016-01-10
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------prate
;================================================

;    unit2mmday = 60*60*24      ;Kg/m^2/s -> mm/day
    unit2mmday = 2.5*10^6      ;2.5*10^6J/Kg * Kg/m^2/s -> W/m^2

;time
    n      = 7         ;length of Sub-sequence
    yS     = 1950
    yM     = 16        ;1965
    yE     = 2010
    year   = ispan (yS,yE,1)
    season = "JAS"     ;choose seasonal mean

;SAM
    latN = 30
    latS = -10
    lonL = 70
    lonR = 150

;PacHC
;    latN = 20
;    latS = -10
;    lonL = 150
;    lonR = 250

;Lanczos Filter
;the total number of weights (must be an odd number; nwt >= 3). The more weights, the better the filter, but there is a greater loss of data. 
  nWgt   = 21
;the low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2
  ihp    = 0
;cut-off frequency of the ideal high or low-pass filter: (0.0 < fca < 0.5)
  fca    = 1./10.
;the second cut-off frequency (fca < fcb < 0.5), used only when a band-pass filter is desired
  fcb    = -999.
;the power of the sigma factor (nsigma >= 0). Note: nsigma=1. is common. 
  nsigma = 1.0

    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "timeseries_reg_SAM_JAS_LH"

;text
    Text1 = (/"Raw","Low Pass Filtered: 10 years","Trend"/)
    Text2 = (/"a)","b)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;PREC 1948-01~2015-01
    PREC_file = addfile ("~/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc","r")

    PREC   = PREC_file->prate(:,{latS:latN},{lonL:lonR})
;    PREC_p = PREC_file->prate(:,{latS:latN},:)
;    PREC_p = lonFlip(PREC_p)      ;Sahel rainfall
;    PREC   = PREC_p(:,:,{lonL:lonR})
    PREC   = unit2mmday * PREC
    TIME   = PREC_file->time

    printVarSummary (PREC)
    printVarSummary (TIME)

;---------------------------------------------------------------
;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.
    gw = PREC_file->lat({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100
    iYYYY = ind(YYYY.ge.yS .and. YYYY.le.yE)

;creat Lanczos Filter Weights 
    wgt = filwgts_lanczos (nWgt,ihp,fca,fcb,nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   PREC_JAS_reg = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY,:,:) ,season) ,gw,1.,0)
   dim          = dimsizes (PREC_JAS_reg)
   ave          = avg (PREC_JAS_reg)
   ave1         = avg (PREC_JAS_reg(:yM-1))
   ave2         = avg (PREC_JAS_reg(yM:yM+15))
   printVarSummary (PREC_JAS_reg)
   print(ave1)
   print(ave2)
   print((ave2-ave1)/ave1*100)

;calculates the filtered data
   xF = wgt_runave_Wrap (PREC_JAS_reg,wgt,0)
   printVarSummary (xF)

;calculate linear regression coef
   rc = regline (year,PREC_JAS_reg)
   lt = rc*( year - rc@xave ) + rc@yave
   print (rc)

;---------------------------------------------------------------
;running t-test
   prob = new ((/2,dim(0)-2*n+1/),double)
   do i=0,dim(0)-2*n
    ;compute climatologies
    PRECaveS = avg (PREC_JAS_reg(i:i+n-1))
    PRECaveE = avg (PREC_JAS_reg(i+n:i+2*n-1))
    PRECstdS = stddev (PREC_JAS_reg(i:i+n-1))
    PRECstdE = stddev (PREC_JAS_reg(i+n:i+2*n-1))
    ;compute probabilities for means difference
    prob(:,i) = ttest (PRECaveE,PRECstdE^2,n,PRECaveS,PRECstdS^2,n,False,True)
   end do
   
   x = ispan (yS+n-1,yE-n,1)
   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================
 
wks  = gsn_open_wks ("eps",out_path+out_name)   ;open a eps file

;*******************************************
;  plot timeseries
;*******************************************
res          = True

res@gsnDraw  = False      ;don't draw
res@gsnFrame = False      ;don't advance frame

res@gsnYRefLine           = ave      ;reference line
res@gsnXYBarChart         = True     ;creat bar chart
res@gsnAboveYRefLineColor = "light blue"   ;above ref line blue
res@gsnBelowYRefLineColor = "pale violet red"    ;below ref line red
res@gsnLeftString         = "d)"

res@trYMinF = min (PREC_JAS_reg)
res@trYMaxF = max (PREC_JAS_reg)

;res@tiMainString      = "PacHC JAS Rainfall Time Series"   ;add title
res@tiMainFontHeightF = 0.035                              ;change font heights
res@tiYAxisString     = "W/m^2"                           ;y-axis labal

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

res@vpHeightF = 0.3      ;change aspect ratio of plot

plot0 = gsn_csm_xy (wks,year,PREC_JAS_reg,res)

;---------------------------------------------------------------
res@gsnXYBarChart    = False      ;turn off bar chart
delete (res@gsnAboveYRefLineColor)
delete (res@gsnBelowYRefLineColor)
res@xyLineThicknessF = 4.0
plot1 = gsn_csm_xy (wks,year,xF,res)

res@xyDashPatterns = 1      ; Dash patterns 
plot2 = gsn_csm_xy (wks,year,lt,res)

;overlay (plot0,plot1)
;overlay (plot0,plot2)

; add the line
resp                  = True         ; polyline mods desired
resp@gsLineThicknessF = 5.0          ; thickness of lines
dum1 = gsn_add_polyline (wks,plot0,(/1950,1965/),(/ave1,ave1/),resp)
dum2 = gsn_add_polyline (wks,plot0,(/1966,1981/),(/ave2,ave2/),resp)

;*******************************************
;  plot t-test probability
;*******************************************
res1          = True

res1@gsnDraw         = False      ;don't draw
res1@gsnFrame        = False      ;don't advance frame
res1@gsnLeftString   = "b)"
res1@gsnCenterString = "Student t-values"
res1@gsnRightString  = "a = 0.01" 

;res1@gsnYRefLine           = 0.01     ;reference line

;res1@trYMinF = 0.
;res1@trYMaxF = 0.1

res1@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res1@tmYLLabelFontHeightF = 0.025

res1@xyLineThicknesses = 2.0      ;change the thickness of lines

res1@vpHeightF = 0.3      ;change aspect ratio of plot
plot3 = gsn_csm_xy(wks,x,prob(1,:),res1)

resp@gsLineThicknessF  = 1.0          ; thickness of lines
resp@gsLineDashPattern = 1
dum3 = gsn_add_polyline (wks,plot3,(/yS,yE/),(/3.06,3.06/),resp)
dum4 = gsn_add_polyline (wks,plot3,(/yS,yE/),(/-3.06,-3.06/),resp)

;*******************************************
;create panel resources
;*******************************************
gsn_panel(wks,(/plot0,plot3/),(/2,1/),False)          ; create panel

;draw (plot0)
;frame (wks)

end
