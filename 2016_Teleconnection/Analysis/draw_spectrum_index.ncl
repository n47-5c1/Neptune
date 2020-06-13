;*************************************************************
;Aim: Draw the spectrum of teleconnection index
;Mission:
;
;   1. Read data from INDEX datasets
;   2. Post-post process to deserved results
;   3. Draw the spectrum
;                       He Shan
;                       2017-02-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------INDEX
;================================================

;spectrum function arguments
    d   = 1      ;detrending opt: 0=>remove mean 1=>remove mean + detrend
    sm1 = 21     ;smooth: should be at least 3 and odd
    sm2 = 5      ;smooth: should be at least 3 and odd
    pct = 0.10   ;percent taper: (0.0 <= pct <= 1.0) 0.10 common.
    lowval  = 0.95   ;confidence limit
    highval = 0.99

; create the filter weights
    nwt    = 31
    fca    = 1./15.
    fcb    = 1./999.
    ihp    = 0          
    nsigma = 1.
    wts    = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)   ; 10-30 day

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "spectrum_index"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f       = addfile ("./PC_square_Index.nc", "r")
    index_p = f->INDEX
    TIME    = f->time
    printVarSummary (index_p)
    
    iR1    = ind (ismissing(index_p).eq.False)
    index = index_p(iR1)
    printVarSummary (iR1)
    printVarSummary (index)

;----------------------------------------------------------
;create required yyyyddd
    YYYY1   = cd_calendar (TIME(iR1),0)       ;for original data
    year1   = floattointeger (YYYY1(:,0))
    month1  = floattointeger (YYYY1(:,1))
    day1    = floattointeger (YYYY1(:,2))
    ddd     = day_of_year(year1, month1, day1) 
    yyyyddd = year1*1000 + ddd            ;needed for input
    printVarSummary (yyyyddd)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Filter
    index_BP_p = wgt_runave_Wrap (index,wts,0)
    index_BP   = conform_dims ((/dimsizes(index_BP_p),1,1/),index_BP_p,0)
    index_BP   = index_BP_p
    index_BP!1 = "lat"
    index_BP!2 = "lon"
    printVarSummary (index_BP)

;Calculate monthly means
    index_mon_p = calculate_monthly_values (index,"avg",0,False)
    index_mon   = conform_dims ((/dimsizes(index_mon_p),1,1/),index_mon_p,0)
    index_mon   = index_mon_p
    index_mon!1 = "lat"
    index_mon!2 = "lon"
    printVarSummary (index_mon)

;Daily/monthly anomalies
    ClmDay    = clmDayTLL ( index_BP, yyyyddd)
    DayAnom_p = calcDayAnomTLL (index_BP, yyyyddd, ClmDay)
    iR2       = ind (ismissing(DayAnom_p(:,0,0)).eq.False)
    DayAnom   = DayAnom_p(iR2,0,0)
    printVarSummary(DayAnom)
    ClmMon  = clmMonTLL (index_mon)
    MonAnom = calcMonAnomTLL (index_mon, ClmMon)
    printVarSummary(MonAnom)

;----------------------------------------------------------
;get
    YYYY2  = cd_calendar (MonAnom&time,0)
    year2  = floattointeger (YYYY2(:,0))
    month2 = floattointeger (YYYY2(:,1))
    yyyymm = year2*100+month2
    printVarSummary (yyyymm)

    iMMp = ind(MonAnom(:,0,0).ge.3.)
    iMMn = ind(MonAnom(:,0,0).le.-2.5)

    print(yyyymm(iMMp))
    print(yyyymm(iMMn))

;----------------------------------------------------------
;calculate spectrum
    sdof1 = specx_anal (index,d,sm1,pct)
    sdof2 = specx_anal (index_mon(:,0,0),d,sm2,pct)
    sdof3 = specx_anal (DayAnom,d,sm1,pct)
    sdof4 = specx_anal (MonAnom(:,0,0),d,sm2,pct)
    splt1 = specx_ci (sdof1,lowval,highval)      ;"red noise" confidence interva
    splt2 = specx_ci (sdof2,lowval,highval)
    splt3 = specx_ci (sdof3,lowval,highval)
    splt4 = specx_ci (sdof4,lowval,highval)
    printVarSummary (sdof1)
    printVarSummary (sdof2)
    printVarSummary (sdof3)
    printVarSummary (sdof4)
    printVarSummary (splt1)

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks  = gsn_open_wks ("svg",out_path+out_name)   ; open a eps file
 plot = new(5,graphic)                          ;creat a plot array

;-----------------------------------------------------------------------------
res = True

res@gsnDraw               = False      ;do not draw
res@gsnFrame              = False      ;do not advance frame
res@gsnStringFontHeightF  = 0.032

res@vpWidthF        = 1.37      ;change aspect ratio of plot
res@gsnCenterString = "Monthly Anom"
plot(2) = gsn_csm_y (wks,MonAnom(:,0,0),res)

res@trYLog  = True   ;log scaling

delete(res@gsnCenterString)
delete(res@vpWidthF)
;res@vpWidthF  = 0.75        ;change aspect ratio of plot
;res@vpHeightF = 0.35

res@tmXBLabelFontHeightF = 0.03   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.03

res@xyDashPatterns    = (/0,0,1,1/)       ;Dash patterns 
res@xyLineThicknesses = (/1.2,.4,.4,.4/)   ;Define line thicknesses 

;***********************************************
;PLOT spectrum (frequency)
;***********************************************
;res@tiMainString  = "Index"                    ;title
;res@tiXAxisString = "Frequency (cycles/day)"   ;xaxis
;res@tiYAxisString = "Variance"                 ;yaxis

;plot = gsn_csm_xy (wks,sdof@frq,splt,res)

;***********************************************
;PLOT abscissa as period (1/frequency)
;***********************************************
;PLOT 1 (day)
p1           = 1/sdof1@frq      ;highly non-linear
p1!0         = "f"
p1&f         = sdof1@frq
p1@long_name = "period"
p1@units     = "day"

res@gsnLeftString = text1(0)

res@trYMinF = 0.40   ;set limit
res@trYMaxF = 400
;res@trYMaxF = 4000

res@tiXAxisString = "Period (days)"      ;xaxis
res@tiYAxisString = "Variance"           ;yaxis

ip1     = ind(p1.le.30)      ;all indices for "short" periods
plot(0) = gsn_csm_xy (wks,p1(ip1), splt1(:,ip1),res)

;----------------------------------------------------------
p3           = 1/sdof3@frq
p3!0         = "f"
p3&f         = sdof3@frq
p3@long_name = "period"
p3@units     = "day"

res@trYLog = False

res@gsnLeftString  = text1(2)+" "+ 1./fca+"-day LP"
res@gsnRightString = "Daily Anom"

res@trYMinF = 0.
res@trYMaxF = 180

res@tiXAxisString = " "

ip3     = ind(p3.le.240)
plot(3) = gsn_csm_xy (wks,p3(ip3), splt3(:,ip3),res)

;----------------------------------------------------------
;PLOT 2 (month)
p2           = 1/sdof2@frq
p2!0         = "f"
p2&f         = sdof2@frq
p2@long_name = "period"
p2@units     = "month"

res@trYLog = True

res@gsnLeftString = text1(1)
delete(res@gsnRightString)

res@trYMinF = 0.4
;res@trYMinF = 0.6
res@trYMaxF = 400

res@tiXAxisString = "Period (months)"
delete(res@tiYAxisString)

ip2     = ind(p2.le.18)
plot(1) = gsn_csm_xy (wks,p2(ip2), splt2(:,ip2),res)

;----------------------------------------------------------
p4           = 1/sdof4@frq
p4!0         = "f"
p4&f         = sdof4@frq
p4@long_name = "period"
p4@units     = "day"

res@gsnLeftString  = text1(3)
res@gsnRightString = "Monthly Anom"

res@trYMinF = 0.4
res@trYMaxF = 20

res@tiXAxisString = " "

ip4     = ind(p2.le.12*3)
plot(4) = gsn_csm_xy (wks,p4(ip4), splt4(:,ip4),res)

;*******************************************
;create panel resources
;*******************************************
resP                    = True
resP@txString           = "Power Spectra of Index"
resP@lbLabelFontHeightF = 0.015
resP@gsnPanelCenter     = False
resP@gsnPanelRowSpec    = True      ;tell panel what order to plot

gsn_panel(wks,plot,(/2,1,2/),resP)

end
