;*************************************************************
;Aim: Draw EOF of regional monthly sea surface temperature with bandpass filters
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Draw the EOFs and PCs
;                       He Shan
;                       2017-02-17
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;data
    in_path = "~/data/observation/SST/HadISST_sst_1870-2016.nc"

;time
    yS     = 1979
    yE     = 2015

;regiion
    latN = 30
    latS = -10
    lonW = 30
    lonE = 120

    neof        = 3      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "EOF_IO_monthly_BP_SST"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    SST_in = addfile (in_path,"r")
    SST    = SST_in->sst
    TIME   = SST_in->time

    printVarSummary (SST)
    printVarSummary (TIME)

;get the time indexs
    YYYY  = cd_calendar (TIME,0)       ;for original data
    year  = tointeger (YYYY(:,0))
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    printVarSummary (iYYYY)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = SST_in->latitude({latS:latN})
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

; create the filter weights
    nwt = 19
    fca = 1./9.
    fcb = 1./6.
    ihp = 2
    nsigma = 1.
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Filter
   SST_BP_p = wgt_runave_Wrap (SST({latitude|latS:latN},{longitude|lonW:lonE},time|:),wts,0)
   SST_BP   = SST_BP_p (:,:,iYYYY)
   printVarSummary (SST_BP)

;-------------------------------------------------------------
;EOF
    x           = SST_BP
    x           = SST_BP*conform (SST_BP,clat,0)
    x@long_name = "Wgt: "+x@long_name

    eof    = eofunc_Wrap (x,neof,optEOF)
    eof_ts = eofunc_ts (x,eof,optETS)
    printVarSummary (eof)

;normalize time series: sum spatial weights over the area of used
    dimx   = dimsizes (x)
    sumWgt = dimx(0)*sum(clat)
    eof_ts = eof_ts/sumWgt
    printVarSummary (eof_ts)

; ==============================================================
; Mission 3. Draw the EOF
; ==============================================================

 wks     = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot    = new(neof*2,graphic)      ;creat a plot array

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame
res@gsnAddCyclic = False

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels
res@cnFillPalette  = "BlRe"   ;choose a colormap

;res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonW
res@mpMaxLonF              = lonE

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.04      ;set min contour level
res@cnMaxLevelValF       = 0.04       ;set max contour level
res@cnLevelSpacingF      = 0.01          ;set contour spacing

res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.25    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

do i=0,neof-1
 if(i.eq.neof-1) then
  res@lbLabelBarOn = True
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

rts@gsnDraw       = False      ;don't draw
rts@gsnFrame      = False      ;don't advance frame
rts@gsnYRefLine   = 0.         ;reference line
rts@gsnStringFontHeightF  = 0.024

rts@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.018

rts@vpWidthF  = 0.75        ;change aspect ratio of plot
rts@vpHeightF = 0.35

do i=0,neof-1
 rts@gsnLeftString  = text1(2*i+1)
 plot(2*i+1) = gsn_csm_y (wks,eof_ts(i,0:119),rts)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "EOF of Monthly 6-8-month bandpass SST"   ;add common title

gsn_panel(wks,plot,(/3,2/),resP)

end
