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
;   var--------------precip
;   var--------------prate
;================================================

;PREC       1948/01-2017/02
    in1 = "/home/yangsong3/data/observation/PREC/precip.mon.anom.nc"
;NCEP/NCAR  1948/01-
    in2 = "/home/yangsong3/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;20thCRV2c  1851/01-2014/12
    in3 = "/home/yangsong3/data/observation/20thCRV2c/prate.mon.mean.nc"
;20thCRV2   1871/01-2012/12
    in4 = "/home/yangsong3/data/observation/20thCRV2/prate.mon.mean.nc"
;ERA-40     1957/09-2002/08
    in5 = "/home/yangsong3/data/observation/ERA40/monthly/lsp.cp.tcc.mon.mean.nc"

;PREC/L     1948/01-2017/02
    in6 = "/home/yangsong3/data/observation/PRECL/precip.mon.mean.1x1.nc"
;UDel V4    1901/01-2014/12
    in7 = "/home/yangsong3/data/observation/UDel/precip.mon.total.v401.nc"
;GPCC V7    1901/01-2013/12
    in8 = "/home/yangsong3/data/observation/GPCC/precip.mon.total.1x1.v7.nc"

    na  = 8
    rad = 4.*atan(1.)/180.

;time
    yS     = 1958
    yE     = 2001
    season = (/"JAS","JJA"/)     ;choose seasonal mean

;Sahel
    latN1 = 20
    latS1 = 10
    lonW1 = -20
    lonE1 = 35

;Asia
    latN2 = 40
    latS2 = -10
    lonW2 = 60
    lonE2 = 180

;Lanczos Filter
    nWgt   = 19
    ihp    = 0      ;the low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2
    fca    = 1./9.
    fcb    = -999.
    nsigma = 1.0
    wgt    = filwgts_lanczos (nWgt,ihp,fca,fcb,nsigma)

;Fig
    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "timeseries_reg_summer_PREC"

    wks   = gsn_open_wks ("svg",out_path+out_name)   ;open a svg file
    plot  = new (2*na,graphic)
    plot1 = new (2*na,graphic)

;text
    Text1 = (/" "," "," "/)
    Text2 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","m)","n)","o)","p)","q)","r)"/)

do i=0,na-1
    print("<<<<<<<<<<START>>>>>>>>>> "+i)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    if(i.eq.0) then
     in_file = addfile (in1,"r")
     PREC    = in_file->precip
    else if(i.eq.1) then
     in_file = addfile (in2,"r")
     PREC    = in_file->prate
    else if(i.eq.2) then
     in_file = addfile (in3,"r")
     PREC    = in_file->prate
    else if(i.eq.3) then
     in_file = addfile (in4,"r")
     PREC    = in_file->prate
    else if(i.eq.4) then
     in_file = addfile (in5,"r")
     PREC    = short2flt (in_file->lsp)
     PREC2   = short2flt (in_file->cp)
     PREC    = PREC + PREC2
    else if(i.eq.5) then
     in_file = addfile (in6,"r")
     PREC    = in_file->precip
    else if(i.eq.6) then
     in_file = addfile (in7,"r")
     PREC    = in_file->precip
    else
     in_file = addfile (in8,"r")
     PREC    = in_file->precip
    end if
    end if
    end if
    end if
    end if
    end if
    end if

    PREC = lonFlip (PREC)

    TIME = in_file->time

    printVarSummary (PREC)
    printVarSummary (TIME)

;---------------------------------------------------------------
;creat weights: cos(lat)
    if(i.eq.4) then
     gw1 = in_file->latitude({latS1:latN1})
     gw2 = in_file->latitude({latS2:latN2})
    else
     gw1 = in_file->lat({latS1:latN1})
     gw2 = in_file->lat({latS2:latN2})
    end if
    gw1 = cos (rad*gw1)
    gw2 = cos (rad*gw2)
    printVarSummary (gw1)
    printVarSummary (gw2)

;get the time indexs
    YYYY  = cd_calendar (TIME,-1)/100
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)
    printVarSummary (iYYYY)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   P_JAS_reg1 = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY,{latS1:latN1},{lonW1:lonE1}), season(0)), gw1, 1., 0)
   P_JAS_reg2 = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY,{latS2:latN2},{lonW2:lonE2}), season(1)), gw2, 1., 0)
;   dim        = dimsizes (PREC_JAS_reg1)
   ave1       = avg (P_JAS_reg1)
   ave2       = avg (P_JAS_reg2)
;   ave1       = avg (PREC_JAS_reg(:yM-1))
;   ave2       = avg (PREC_JAS_reg(yM:yM+15))
   printVarSummary (P_JAS_reg1)
   print(ave1)
;   print((ave-ave1)/ave1*100)

;calculates the filtered data
   x1F = wgt_runave_Wrap (P_JAS_reg1,wgt,0)
   x2F = wgt_runave_Wrap (P_JAS_reg2,wgt,0)
   printVarSummary (x1F)

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

   x = ispan (yS+n-1,yE-n,1)
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
res@gsnLeftString         = Text2(2*i)
res@gsnYRefLine           = ave1                ;reference line
res@gsnXYBarChart         = True                ;creat bar chart
res@gsnAboveYRefLineColor = "light blue"        ;above ref line blue
res@gsnBelowYRefLineColor = "pale violet red"   ;below ref line red
if(i.eq.0) then
 res@gsnCenterString = "Sahel"
 res@gsnRightString  = lonW1+"-"+lonE1+"E "+latS1+"-"+latN1+"N"
end if

res@trYMinF = min (P_JAS_reg1)
res@trYMaxF = max (P_JAS_reg1)

res@tiYAxisString = PREC@units      ;y-axis labal

if (i.ne.na-1) then
 res@tmXBOn       = False   ;do not draw lon labels & tickmarks
 res@tmXBLabelsOn = False
end if
res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
;res@tmXBTickSpacingF     = 60.     ;label spacing

res@vpHeightF = 0.2      ;change aspect ratio of plot

plot(2*i) = gsn_csm_xy (wks, ind( cd_calendar(P_JAS_reg1&time,-1)/100 ),P_JAS_reg1,res)

;overlay timeseries
delete (res@gsnAboveYRefLineColor)
delete (res@gsnBelowYRefLineColor)
res@gsnXYBarChart    = False      ;turn off bar chart
res@xyLineThicknessF = 4.0
plot1(2*i) = gsn_csm_xy (wks, ind( cd_calendar(x2F&time,-1)/100 ),x1F,res)
overlay (plot(2*i),plot1(2*i))

;---------------------------------------------------------------
res@gsnLeftString         = Text2(2*i+1)
res@gsnYRefLine           = ave2
res@gsnXYBarChart         = True
res@gsnAboveYRefLineColor = "light blue"
res@gsnBelowYRefLineColor = "pale violet red"
if(i.eq.0) then
 res@gsnCenterString = "Asia"
 res@gsnRightString  = lonW2+"-"+lonE2+"E "+latS2+"-"+latN2+"N"
end if
res@trYMinF          = min (P_JAS_reg2)
res@trYMaxF          = max (P_JAS_reg2)
res@tiYAxisString    = " "      ;y-axis labal
res@xyLineThicknessF = 1.0
plot(2*i+1)       = gsn_csm_xy (wks, ind( cd_calendar(P_JAS_reg2&time,-1)/100 ),P_JAS_reg2,res)

;overlay timeseries
delete (res@gsnAboveYRefLineColor)
delete (res@gsnBelowYRefLineColor)
res@gsnXYBarChart    = False      ;turn off bar chart
res@xyLineThicknessF = 4.0
plot1(2*i+1) = gsn_csm_xy (wks, ind( cd_calendar(x2F&time,-1)/100 ),x2F,res)
overlay (plot(2*i+1),plot1(2*i+1))

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

;*******************************************
;  plot t-test probability
;*******************************************
res1          = True

res1@gsnDraw         = False      ;don't draw
res1@gsnFrame        = False      ;don't advance frame
res1@gsnLeftString   = "a)"
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

resp@gsLineThicknessF  = 1.0          ;thickness of lines
resp@gsLineDashPattern = 1
dum3 = gsn_add_polyline (wks,plot3,(/yS,yE/),(/2.92,2.92/),resp)
dum4 = gsn_add_polyline (wks,plot3,(/yS,yE/),(/-2.92,-2.92/),resp)
;/

delete([/in_file,PREC,TIME,gw1,gw2,YYYY,iYYYY,P_JAS_reg1,P_JAS_reg2,res,x1F,x2F/])

end do

;*******************************************
;create panel resources
;*******************************************
resP               = True
resP@txString      = "Regional Mean JAS Rainfall Time Series"   ;add common title
resP@txFontHeightF = 0.025      ;height of text

gsn_panel(wks,plot,(/na,2/),resP)          ; create panel

end
