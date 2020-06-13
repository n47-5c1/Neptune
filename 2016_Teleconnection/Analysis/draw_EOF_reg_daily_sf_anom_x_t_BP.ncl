;*************************************************************
;Aim: Draw EOF of regional daily anomalous stream function deviations from zonal mean with 10-30-day bandpass filters
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the EOFs and PCs
;                       He Shan
;                       2016-10-23
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
    yS     = 1980
    maxlag = 10          ;set lag

;regiion
    latN = 40
    latS = 10
    lonW = -20
    lonE = 110

    neof        = 3      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "EOF_reg_daily_anom_x_t_sf_BP"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files,"r")                ;note the "s" of addfile
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

;create required yyyyddd
    YYYY    = cd_calendar (TIME,0)       ;for original data
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))
    day     = floattointeger (YYYY(:,2))
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd            ;needed for input
    printVarSummary (yyyyddd)

;get the time indexs
    iYYYY = ind (year.eq.yS)
    printVarSummary (iYYYY)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = U_in[0]->lat({latS:latN})
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

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

;Filter
   sfAnom_BP_p = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP   = sfAnom_BP_p (time|:,{lat|latS:latN},{lon|lonW:lonE})
   printVarSummary (sfAnom_BP)

;-------------------------------------------------------------
;EOF
    wsf           = sfAnom_BP
    wsf           = sfAnom_BP*conform (sfAnom_BP,clat,1)
    wsf@long_name = "Wgt: "+wsf@long_name

    x = wsf(lat|:,lon|:,time|:)   ;recorder the input data

    eof    = eofunc_Wrap (x,neof,optEOF)
    eof_ts = eofunc_ts (x,eof,optETS)
    printVarSummary (eof)

;normalize time series
    eof_ts = dim_standardize_n (eof_ts,0,1)
    printVarSummary (eof_ts)

;---------------------------------------------------------------
;compute cross correlation
   ccr_n = esccr (eof_ts(1,:),eof_ts(0,:),maxlag)
   ccr_n = ccr_n(::-1)
   ccr_p = esccr (eof_ts(0,:),eof_ts(1,:),maxlag)

   ccr = new (2*maxlag+1,"float")

   ccr(:maxlag-1) = (/ccr_n(:maxlag-1)/)
   ccr(maxlag:)   = (/ccr_p/)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   print (ccr)
;   printVarSummary (prob)
    

; ==============================================================
; Mission 3. Draw the EOF
; ==============================================================

 wks  = gsn_open_wks("svg",out_path+out_name)
 plot = new(neof*2,graphic)

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw      = False
res@gsnFrame     = False
res@gsnAddCyclic = False
res@gsnStringFontHeightF = 0.023

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

res@mpFillOn               = False
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonW
res@mpMaxLonF              = lonE

;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.06,-.04,-.02,.02,.04,.08/)

res@pmLabelBarOrthogonalPosF = 0.35    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.022
res@tmYLLabelFontHeightF = 0.022

do i=0,neof-1
 if(i.eq.neof-1) then
  res@lbLabelBarOn = True
 else
  res@lbLabelBarOn = False
 end if
 if (i.eq.neof-1) then
  res@tmXBLabelsOn = True
 else
  res@tmXBLabelsOn = False
 end if
 res@gsnLeftString   = text1(2*i)
 res@gsnCenterString = "EOF "+(i+1)
 res@gsnRightString  = sprintf("%5.1f",eof@pcvar(i))+"%"
 plot(2*i) = gsn_csm_contour_map_ce (wks,eof(i,:,:),res)
end do

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw       = False
rts@gsnFrame      = False
rts@gsnYRefLine   = 0.
rts@gsnStringFontHeightF  = 0.023

rts@tmXBLabelFontHeightF = 0.022
rts@tmYLLabelFontHeightF = 0.018

rts@vpWidthF  = 0.75
rts@vpHeightF = 0.17

do i=0,neof-1
 rts@gsnLeftString   = text1(2*i+1)
 rts@gsnCenterString = "PC "+(i+1)
 if (i.eq.0)then
  rts@gsnRightString = tostring(yS)
 else
  rts@gsnRightString = " "
 end if
 if (i.eq.neof-1) then
  rts@tmXBLabelsOn = True
 else
  rts@tmXBLabelsOn = False
 end if
 plot(2*i+1) = gsn_csm_y (wks,eof_ts(i,iYYYY),rts)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "EOFs of 250 hPa Daily SF Anomalies"
;resP@gsnPanelBottom           = 0.06

gsn_panel(wks,plot,(/3,2/),resP)

end
