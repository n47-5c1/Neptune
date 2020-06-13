;*************************************************************
;Aim: Draw EOF of area average of monthly surface wind speed, surface radiative flux, and mean 1000-200-hPa tropospheric temperature anomalies removed trend
;
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Output and draw the EOFs and PCs
;                       He Shan
;                       2018-04-18
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------wspd
;   var2--------------nlwrs
;   var3--------------nswrs
;   var4--------------air
;================================================

;NCEP/NCAR 2.5x2.5/T62
    in_path  = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "wspd.sfc.mon.mean.nc"
    in_name2 = "nlwrs.sfc.mon.mean.nc"
    in_name3 = "nswrs.sfc.mon.mean.nc"
    in_name4 = "air.mon.mean.nc"

;time
    yS = 1958
    yE = 2004

;tropical Indian Ocean
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

;arguments required by vertical mean
    pnew       = (/1000,925,850,700,600,500,400,300,250,200/)
    pver       = pnew*100
    pver@units = "Pa"
    dp         = dpres_plevel_Wrap (pver,100000,20000,0)   ;caculate dp
    sumdp      = sum(dp)

    neof        = 3      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_name = "EOF_areaave_wspd.sfc_nrs_TT_anom_remove_trend"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

     in1 = addfile (in_path+in_name1,"r")
     in2 = addfile (in_path+in_name2,"r")
     in3 = addfile (in_path+in_name3,"r")
     in4 = addfile (in_path+in_name4,"r")

;get the time indexs
     time  = in1->time
     year  = cd_calendar (time,-1) /100
     iYYYY = ind (year.ge.yS .and. year.le.yE)

     wspd  = in1->wspd(iYYYY,0,:,:)
     nlwrs = in2->nlwrs(iYYYY,:,:)
     nswrs = in3->nswrs(iYYYY,:,:)
     nlwrs = nlwrs+nswrs
     air   = in4->air(iYYYY,{:200},:,:)
     lat1  = in1->lat
     lat2  = in2->lat

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw1  = cos (rad*lat1)
     gw2  = cos (rad*lat2)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)

; create the filter weights
    nwt = 61
    fca = 1./30.
    fcb = 1./10.
    ihp = 2
    nsigma = 1.
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)   ; 10-30 day

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate the vertical mean
    dp_cfm = conform_dims ( dimsizes(air), dp,1)
    TT     = dim_sum_n (dp_cfm*air/sumdp,1)
    copy_VarMeta (air(:,0,:,:),TT)

;monthly anomalies
    clm1   = clmMonTLL (wspd)
    clm2   = clmMonTLL (nlwrs)
    clm4   = clmMonTLL (TT)
    wspdA  = calcMonAnomTLL (wspd,clm1)
    nlwrsA = calcMonAnomTLL (nlwrs,clm2)
    TTA    = calcMonAnomTLL (TT,clm4)
    wspdA  = (/dtrend_msg_n (wspdA&time,wspdA,False,False,0)/)
    nlwrsA = (/dtrend_msg_n (nlwrsA&time,nlwrsA,False,False,0)/)
    TTA    = (/dtrend_msg_n (TTA&time,TTA,False,False,0)/)

     wspd_area  = wgt_areaave_Wrap ( wspdA(:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
     nlwrs_area = wgt_areaave_Wrap ( nlwrsA(:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
     TT_area    = wgt_areaave_Wrap ( TTA(:,{latN2:latS2},{lonW2:lonE2}), gw1({latN2:latS2}), 1., 0)
;Filter
;   sfAnom_BP = wgt_runave_Wrap (sf_yAvg(lon|:,time|:),wts,0)
;   printVarSummary (sfAnom_BP)

;-------------------------------------------------------------
;EOF

    cdata      = new ( (/3,dimsizes(TT_area)/), typeof(TT_area), getFillValue(TT_area))
    cdata(0,:) = (/wspd_area/)
    cdata(1,:) = (/nlwrs_area/)
    cdata(2,:) = (/TT_area/)

    eof    = eofunc_Wrap (cdata,neof,optEOF)
    eof_ts = eofunc_ts (cdata,eof,optETS)
    printVarSummary (eof)

;normalize time series
    eof_ts = dim_standardize_n (eof_ts,0,1)
    printVarSummary (eof_ts)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the EOF
; ==============================================================

 wks     = gsn_open_wks("svg",out_path+out_name)
 plot    = new(neof*2,graphic)

;*******************************************
;  plot EOF
;*******************************************

res = True

res@gsnDraw     = False
res@gsnFrame    = False
res@gsnYRefLine = 0.         ;reference line
res@gsnStringFontHeightF  = 0.021

res@tiYAxisString        = " "
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@vpHeightF = 0.15

do i=0,neof-1
 res@gsnLeftString   = text1(2*i)
 res@gsnCenterString = "EOF "+(i+1)
 res@gsnRightString  = sprintf("%5.1f",eof@pcvar(i))+"%"
 plot(2*i) = gsn_csm_xy (wks,(/1,2,3/),eof(i,:),res)
end do

;*******************************************
;  plot EOF time series
;*******************************************

delete ([/res@gsnRightString,res@gsnCenterString/])
do i=0,neof-1
 res@gsnLeftString   = text1(2*i+1)
 res@gsnCenterString = "PC "+(i+1)
; plot(2*i+1) = gsn_csm_xy (wks,year(iYYYY),eof_ts(i,:),res)
 plot(2*i+1) = gsn_csm_y (wks,eof_ts(i,:),res)
end do

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "EOFs"

gsn_panel(wks,plot,(/neof,2/),resP)

end
