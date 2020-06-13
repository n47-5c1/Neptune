;*************************************************************
;Aim: Draw EOF of regional daily anomalous stream function deviations from zonal mean averaged latitude with 10-30-day bandpass filters
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Output and draw the EOFs and PCs
;                       He Shan
;                       2016-11-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/daily/"

;time
    yEl    = 1980
    maxlag = 10          ;set lag

;regiion
    latN = 40
    latS = 10
    lonW = -20
    lonE = 110

    neof        = 2      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;file
;    info      = "|PC1|+|PC2|"      ;<<<<<<change>>>>>>
    info      = "PC1^2+PC2^2"
;    filo_name = "PC_Index.nc"      ;<<<<<<change>>>>>>
    filo_name = "PC_square_Index.nc"

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
;    out_name = "EOF_reg_daily_anom_x_t_avg_y_sf_BP_index"      ;<<<<<<change>>>>>>
    out_name = "EOF_reg_daily_anom_x_t_avg_y_sf_BP_square_index"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files,"r")
    V_in = addfiles (V_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
;    U      = V_file->hgt(:,2,:,:)                ;850hPa
;    U      = V_file->hgt(:,5,:,:)                ;500hPa
    U_p  = U_in[:]->uwnd(:,8,::-1,:)           ;250hPa
    V_p  = V_in[:]->vwnd(:,8,::-1,:)           ;250hPa
    U    = short2flt (lonFlip (U_p))
    V    = short2flt (lonFlip (V_p))
    TIME = U_in[:]->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME)

;-------------------------------------------------------------
    YYYY    = cd_calendar (TIME,0)
    year    = toint (YYYY(:,0))
    month   = toint (YYYY(:,1))
    day     = toint (YYYY(:,2))

;create required yyyyddd
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd
    printVarSummary (yyyyddd)

;get the time indexs
    iYYYY = ind (year.eq.yEl)
    dim   = dimsizes (iYYYY)
    printVarSummary (iYYYY)

;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = U_in[0]->lat({latS:latN})
    gw  = cos (rad*gw)
    printVarSummary (gw)

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

;Stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;Deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
   sfClmDay = clmDayTLL (sf_xAnom, yyyyddd)
   sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   printVarSummary(sf_tAnom)

;Average latitude
   sf_yAvg = dim_avg_wgt_Wrap (sf_tAnom(time|:,{lon|lonW:lonE},{lat|latS:latN}),gw,1)
   printVarSummary(sf_yAvg)

;Filter
   sfAnom_BP = wgt_runave_Wrap (sf_yAvg(lon|:,time|:),wts,0)
;   sfAnom_BP = wgt_runave_Wrap (sf_yAvg(lon|:,time|iMM),wts,0)
   printVarSummary (sfAnom_BP)

;-------------------------------------------------------------
;EOF
    eof      = eofunc_Wrap (sfAnom_BP,neof,optEOF)
    eof(0,:) = (/-eof(0,:)/)
    eof_ts   = eofunc_ts (sfAnom_BP,eof,optETS)
    printVarSummary (eof)

;normalize time series
    eof_ts = dim_standardize_n (eof_ts,0,1)
    printVarSummary (eof_ts)

;Compute index & its daily climatology
;    ts_index = abs(eof_ts(0,:)) + abs(eof_ts(1,:))      ;<<<<<<change>>>>>>
    ts_index = eof_ts(0,:)^2 + eof_ts(1,:)^2
    index_p  = conform (sf_tAnom,ts_index,0)
    copy_VarCoords (sf_tAnom,index_p)
    index_clm_p = clmDayTLL (index_p,yyyyddd)
    index_clm   = index_clm_p(:,0,0)
    printVarSummary (ts_index)
    printVarSummary (index_clm)

    nGood   = num(.not.ismissing(ts_index))     ; # non-missing
    nStrong = num(ts_index .ge. 1.0)
    print("nGood="+nGood+"   nStrong="+nStrong+"   nOther="+(nGood-nStrong))

;---------------------------------------------------------------
;compute cross correlation of the EOF
   ccr_n = esccr (eof_ts(1,:),eof_ts(0,:),maxlag)
   ccr_p = esccr (eof_ts(0,:),eof_ts(1,:),maxlag)
   ccr   = new (2*maxlag+1,"float")

   ccr(:maxlag) = ccr_n(::-1)
   ccr(maxlag:) = ccr_p
   printVarSummary (ccr)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Output and Draw the EOF
; ==============================================================

; Write PC results to netCDF for use in another example.
  ts_index!0         = "time"
  ts_index&time      = TIME 
  ts_index@long_name = "PC INDEX" 
  ts_index@info      = info

  PC1           = eof_ts(0,:)
  PC1!0         = "time"
  PC1&time      = TIME
  PC1@long_name = "PC1"
  PC1@info      = "PC1/stddev(PC1)"

  PC2           = eof_ts(1,:)
  PC2!0         = "time"
  PC2&time      = TIME
  PC2@long_name = "PC2"
  PC2@info      = "PC2/stddev(PC2)"

;Output
  diro = "./"
  filo = filo_name
  system ("/bin/rm -f "+diro+filo)   ;remove any pre-existing file
  ncdf = addfile (diro+filo,"c")
  filedimdef (ncdf,"time",-1,True)    ;make time an UNLIMITED dimension
  ncdf->INDEX = ts_index
  ncdf->PC1   = PC1
  ncdf->PC2   = PC2

;---------------------------------------------------------------
 wks     = gsn_open_wks("svg",out_path+out_name)
 plot    = new(neof*2+2,graphic)

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
 plot(2*i) = gsn_csm_xy (wks,eof&lon,eof(i,:),res)
end do

;*******************************************
;  plot EOF time series
;*******************************************
delete ([/res@gsnRightString,res@gsnCenterString/])
res@tmXBLabelsOn = False
do i=0,neof-1
 res@gsnLeftString   = text1(2*i+1)
 res@gsnCenterString = "PC "+(i+1)
 if(i.eq.0)then
  res@gsnRightString = tostring (yEl)
 else
  res@gsnRightString = " "
 end if
 plot(2*i+1) = gsn_csm_y (wks,eof_ts(i,iYYYY),res)
end do

;*******************************************
;  plot cross correlation of the EOF
;*******************************************
lag = ispan(-maxlag,maxlag,1)
lag@long_name = "EOF 2-lead      Lag (days)      EOF 1-lead"

res@gsnLeftString   = text1(2*neof)
res@gsnCenterString = "Lagged correlation: EOF 1 & EOF 2"

res@tiXAxisFontHeightF = 0.02

res@tmXBLabelsOn = True

plot(2*neof)     = gsn_csm_xy (wks,lag,ccr,res)

;************************************************
; plot index
;************************************************
data      = new((/2,dim/),typeof(ts_index))
data(0,:) = ts_index(iYYYY)
data(1,:) = index_clm(0:dim-1)
copy_VarAtts (ts_index,data)
printVarSummary (data)

res@gsnYRefLine      = 1.0
res@gsnYRefLineColor = "black"
res@gsnLeftString    = text1(2*neof+1)
res@gsnCenterString  = "Index"
res@gsnRightString   = yEl+" & CLM"

res@trYMinF = 0
;res@trYMaxF = 6      ;<<<<<<change>>>>>>
res@trYMaxF = 15

res@xyLineColors   = (/"black","red"/)
res@xyDashPatterns = (/0,0/)

plot(2*neof+1) = gsn_csm_y (wks,data,res)

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "EOFs of 250 hPa Daily SF Anomalies ("+latS+"N - "+latN+"N)"

gsn_panel(wks,plot,(/neof+1,2/),resP)

end
