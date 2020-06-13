;*************************************************************
;Aim: Draw the region mean Sahel and Asian JAS rainfall time series (raw and low pass filtered) and trend
;
;Mission:
;   1. Read data from PREC dataset
;   2. Post-post process to deserved results
;   3. Draw the timeseries and trend
;                       He Shan
;                       2015-04-26
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------precip
;   var2--------------prate
;   var3--------------lsp
;   var4--------------cp
;   var5--------------cldc
;================================================

;PREC/L     1948/01-2017/02
    in1 = "/home/yangsong3/data/observation/PRECL/precip.mon.mean.1x1.nc"
;NCEP/NCAR  1948/01-
    in2 = "/home/yangsong3/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;ERA-40     1957/09-2002/08
    in3 = "/home/yangsong3/data/observation/ERA-40/monthly/lsp.cp.tcc.mon.mean.deg1.nc"
;ICOADS 2 E 1800/01-2017/03
    in4 = "/home/yangsong3/data/observation/ICOADS2/Enhanced/cldc.mean.nc"

    na    = 4
    rad   = 4.*atan(1.)/180.
    unit1 = 60.*60.*24.   ;Kg/m^2/s -> mm/day
    unit2 = 4000.         ;m -> mm/day

;time
    yS     = 1958
    yE     = 2001
    x      = ispan (yS,yE,1)
    season = (/"JAS","JJA"/)     ;choose seasonal mean

;Sahel
    latN1 = 20
    latS1 = 10
    lonW1 = -20
    lonE1 = 35

;Asia
;    latN2 = 30
;    latS2 = 15
;    lonW2 = 70
;    lonE2 = 120
    latN2 = 30
    latS2 = -10
    lonW2 = 70
    lonE2 = 150

;Lanczos Filter
    nWgt   = 19
    ihp    = 0      ;the low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2
    fca    = 1./9.
    fcb    = -999.
    nsigma = 1.0
    wgt    = filwgts_lanczos (nWgt,ihp,fca,fcb,nsigma)

;Fig
    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "timeseries_reg_summer_PREC_Cloud"

    wks   = gsn_open_wks ("svg",out_path+out_name)   ;open a svg file
    plot  = new (na,graphic)
    plot1 = new (na,graphic)

;text
    Text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)

do i=0,na-1
    print("<<<<<<<<<<START>>>>>>>>>> "+i)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    if(i.eq.0) then
     in_file = addfile (in1,"r")
     PREC    = in_file->precip
     PREC    = lonFlip (PREC)
    else if(i.eq.1) then
     in_file    = addfile (in2,"r")
     PREC       = in_file->prate
     PREC       = unit1*PREC
     PREC@units = "mm/day"
    else if(i.eq.2) then
     in_file    = addfile (in3,"r")
     PREC       = short2flt (in_file->lsp)
     PREC2      = short2flt (in_file->cp)
     PREC       = unit2 * (PREC + PREC2)
     PREC@units = "mm/day"
    else
     in_file = addfile (in4,"r")
     PREC    = short2flt (in_file->cldc)
    end if
    end if
    end if

    TIME = in_file->time

    printVarSummary (PREC)
    printVarSummary (TIME)

;---------------------------------------------------------------
;creat weights: cos(lat)
    if(i.eq.0) then
     gw = in_file->lat({latS1:latN1})
    else if(i.eq.2) then
     gw = in_file->latitude({latS2:latN2})
    else
     gw = in_file->lat({latS2:latN2})
    end if
    end if
    gw = cos (rad*gw)
    printVarSummary (gw)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)
    printVarSummary (iYYYY)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   if(i.eq.0)then
    P_reg = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY,{latS1:latN1},{lonW1:lonE1}), season(0)), gw, 1., 0)
   else
    P_reg = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY,{latS2:latN2},{lonW2:lonE2}), season(1)), gw, 1., 0)
   end if
   ave  = avg (P_reg)
   ave1 = avg (P_reg(2:2+10))
   ave2 = avg (P_reg(2+20:2+20+10))
   printVarSummary (P_reg)
   print(ave)
   print((ave2-ave1)/ave1*100)

;calculates the filtered data
   yF = wgt_runave_Wrap (P_reg,wgt,0)
   printVarSummary (yF)

/;
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
   printVarSummary (prob)
;/
; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw               = False      ;don't draw
res@gsnFrame              = False      ;don't advance frame
res@gsnLeftString         = Text1(i)
res@gsnYRefLine           = ave                 ;reference line
res@gsnXYBarChart         = True                ;creat bar chart
res@gsnAboveYRefLineColor = "light blue"        ;above ref line blue
res@gsnBelowYRefLineColor = "pale violet red"   ;below ref line red
if(i.eq.0) then
 res@gsnCenterString = "Sahel: "+lonW1+"-"+lonE1+"E "+latS1+"-"+latN1+"N"
 res@gsnRightString  = season(0)
else if(i.eq.1) then
 res@gsnCenterString = "SAWPSM: "+lonW2+"-"+lonE2+"E "+latS2+"-"+latN2+"N"
 res@gsnRightString  = season(1)
end if
end if

res@trYMinF = min (P_reg)
res@trYMaxF = max (P_reg)

if(i.eq.0 .or. i.eq.3) then
 res@tiYAxisString = PREC@units      ;y-axis labal
else
 res@tiYAxisString = " "
end if

if (i.ne.na-1) then
 res@tmXBLabelsOn = False   ;do not draw x labels
end if
res@tmYROn               = False   ;do not draw y tickmarks
res@tmXBLabelFontHeightF = 0.02    ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
;res@tmXBTickSpacingF     = 60.     ;label spacing

res@vpHeightF = 0.2      ;change aspect ratio of plot

plot(i) = gsn_csm_xy (wks,x,P_reg,res)

;overlay timeseries
delete (res@gsnAboveYRefLineColor)
delete (res@gsnBelowYRefLineColor)
res@gsnXYBarChart    = False      ;turn off bar chart
res@xyLineThicknessF = 4.0
plot1(i) = gsn_csm_xy (wks,x,yF,res)
overlay (plot(i),plot1(i))

;---------------------------------------------------------------
/;
res@xyDashPatterns = 1      ;Dash patterns
plot2 = gsn_csm_xy (wks,year,lt,res)

;overlay (plot0,plot2)

; add the line
resp                  = True         ; polyline mods desired
resp@gsLineThicknessF = 5.0          ; thickness of lines
dum1 = gsn_add_polyline (wks,plot0,(/1950,1965/),(/ave1,ave1/),resp)
dum2 = gsn_add_polyline (wks,plot0,(/1966,1981/),(/ave2,ave2/),resp)
;/

delete([/in_file,PREC,TIME,gw,YYYY,iYYYY,P_reg,res,yF/])

end do

;*******************************************
;create panel resources
;*******************************************
resP                = True
resP@txString       = "Regional Mean Precipitation and Cloudiness"   ;add common title
resP@txFontHeightF  = 0.026      ;height of text
resP@gsnPanelBottom = 0.05       ;add some space at bottom

gsn_panel(wks,plot,(/na,1/),resP)          ; create panel

end
