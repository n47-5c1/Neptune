;*************************************************************
;Aim: Draw EOF of regional MAM winds
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the EOFs and PCs
;                       He Shan
;                       2016-04-27
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
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"

;time
    mS     = 3
    mE     = 5
    yS     = 1979
    yE     = 2015
    season = "MAM"      ;choose seasonal mean
    year = ispan(1,111,1)

;regiion
    latN = 89
    latS = 0
    lonL = -80
    lonR = 170

    neof        = 3      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "EOF_reg_"+season+"_wind"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path+in_name1,"r")
    V_file = addfile (in_path+in_name2,"r")

;get the time indexs
    time1  = U_file->time
    time2  = V_file->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    month1 = toint ( TIME1(:,1) )
    month2 = toint ( TIME2(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.mS .and. month1.le.mE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.ge.mS .and. month2.le.mE)

;---------------------------------------------------------
;    U_p    = U_file->uwnd(:,2,:,:)      ;850hPa
;    U_p    = U_file->uwnd(:,5,:,:)      ;500hPa
    U_p    = U_file->uwnd(iYYYY1,8,{latS:latN},:)      ;250hPa
    V_p    = V_file->vwnd(iYYYY2,8,{latS:latN},:)      ;250hPa
    U_p    = lonFlip (U_p)
    V_p    = lonFlip (V_p)
    U      = U_p(:,:,{lonL:lonR})
    V      = V_p(:,:,{lonL:lonR})

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME1)
    printVarSummary (TIME2)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = U_file->lat({latS:latN})
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    wU           = U
    wV           = V
    wU           = U*conform (U,clat,1)
    wV           = V*conform (V,clat,1)
    wU@long_name = "Wgt: "+wU@long_name
    wV@long_name = "Wgt: "+wV@long_name

    x = (/wU(lat|:,lon|:,time|:),wV(lat|:,lon|:,time|:)/)   ;recorder the input data
    x!1   = "lat"
    x!2   = "lon"
    x&lat = U&lat
    x&lon = U&lon
    printVarSummary (x)

    eof    = eofunc_Wrap (x,neof,optEOF)
    eof_ts = eofunc_ts_Wrap (x,eof,optETS)
    speed  = eof(:,0,:,:)
    speed  = sqrt ( eof(:,0,:,:)^2.+eof(:,1,:,:)^2.)
    printVarSummary (eof)
    printVarSummary (speed)

;normalize time series: sum spatial weights over the area of used
    dimx   = dimsizes (x)
    sumWgt = dimx(1)*sum(clat)
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

res@gsnDraw           = False      ;don't draw
res@gsnFrame          = False      ;don't advance frame
res@gsnAddCyclic      = False
res@gsnSpreadColorEnd = 250        ; end at color 200

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

res@stArrowLengthF     = 0.008      ;size of the arrows.
res@stMinArrowSpacingF = 0.08       ;arrow spacing.
res@stLineThicknessF   = 1.1        ;changes the line thickness
res@stMinDistanceF     = 0.05       ;distance between streamlines
res@stMinLineSpacingF  = 0.004

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 0.01      ;set min contour level
res@cnMaxLevelValF       = 0.05      ;set max contour level
res@cnLevelSpacingF      = 0.01      ;set contour spacing

res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.2    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

do i=0,neof-1
 if(i.eq.neof-1) then
  res@lbLabelBarOn = True
 end if
 res@gsnLeftString   = text1(2*i)
 res@gsnCenterString = "EOF "+(i+1)
 res@gsnRightString  = sprintf("%5.1f",eof@pcvar(i))+"%"
 plot(2*i) = gsn_csm_streamline_contour_map_ce (wks,eof(i,0,:,:),eof(i,1,:,:),speed(i,:,:),res)
end do

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw       = False      ;don't draw
rts@gsnFrame      = False      ;don't advance frame
rts@gsnYRefLine   = 0.               ;reference line
rts@gsnXYBarChart = True             ;creat bar chart
rts@gsnStringFontHeightF  = 0.024
rts@gsnAboveYRefLineColor = "red"   ;above ref line red
rts@gsnBelowYRefLineColor = "blue"    ;above ref line blue

rts@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.018

rts@vpHeightF = 0.29        ;change aspect ratio of plot

do i=0,neof-1
 rts@gsnLeftString  = text1(2*i+1)
 plot(2*i+1) = gsn_csm_xy(wks,year,eof_ts(i,:),rts)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = season+" monthly EOF of 250 hPa Wind"   ;add common title

gsn_panel(wks,plot,(/3,2/),resP)

end
