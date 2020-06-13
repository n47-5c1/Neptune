;*************************************************************
;Aim: Draw the time series of the longitude location of the May Middle East jet stream core
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the time series
;                       He Shan
;                       2016-05-20
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
    yS     = 1979
    yE     = 2014
    month = (/"March","April","May"/)      ;choose seasonal mean

;region
    latN = 50
    latS = 10
    lonL = -40
    lonR = 80

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "timeseries_lon_loc_May_MEJS_core"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path+in_name1,"r")
    V_file = addfile (in_path+in_name2,"r")
;    U      = U_file->uwnd(:,2,:,:)      ;850hPa
;    U      = U_file->uwnd(:,5,:,:)      ;500hPa
    U      = U_file->uwnd(:,8,:,:)      ;250hPa
    V      = V_file->vwnd(:,8,:,:)      ;250hPa
    U      = lonFlip (U)
    V      = lonFlip (V)

    printVarSummary (U)
    printVarSummary (V)

;get the time indexs
    time1  = U_file->time
    time2  = V_file->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    month1 = toint ( TIME1(:,1) )
    month2 = toint ( TIME2(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.eq.5)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.eq.5)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate wind speed
   wind = U(iYYYY1,{latS:latN},{lonL:lonR})
   wind = sqrt (U(iYYYY1,{latS:latN},{lonL:lonR})^2.+V(iYYYY2,{latS:latN},{lonL:lonR})^2.)
   dim  = dimsizes(wind)

   printVarSummary (wind)

;find longitude location of the maximum value
   pos_lon = new (dim(0),float)
   do i=0,dim(0)-1
    x    = ndtooned (wind(i,:,:))              ;convert 2D array to 1D for use in maxind
    inds = ind_resolve ( maxind (x), dim(1:2))   ;convert 1D array back to 2D
    ilat = inds(0,0)                             ;select the latitude & longitude index where the X array is at its' maximum  
    ilon = inds(0,1)
    pos_lon(i) = wind&lon(ilon)
   end do

   ave = avg (pos_lon)
   std = 0.8 * stddev(pos_lon)

   printVarSummary (pos_lon)
   print(pos_lon(0:5))

; ==============================================================
; Mission 3. Draw the time series
; ==============================================================

 wks  = gsn_open_wks("eps",out_path+out_name)   ; open a eps file

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw               = False     ;don't draw
rts@gsnFrame              = False     ;don't advance frame
rts@gsnXYBarChart         = True      ;creat bar chart
rts@gsnAboveYRefLineColor = "red"     ;above ref line red
rts@gsnBelowYRefLineColor = "blue"    ;above ref line blue

rts@vpHeightF = 0.3        ;change aspect ratio of plot

rts@tiMainString = "Time Series of Longitude Location of MEJS Core"    ; title

rts@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.025

year = ispan(yS,yE,1)
rts@gsnYRefLine     = ave               ;reference line
rts@gsnCenterString = month(2)
plot = gsn_csm_xy(wks,year,pos_lon,rts)

res                  = True         ; polyline mods desired
;res@gsLineThicknessF = 2            ;thickness of lines
;res@gsLineDashPattern = 1
dum1 = gsn_add_polyline (wks,plot,(/yS-1,yE+1/),(/ave+std,ave+std/),res)
dum2 = gsn_add_polyline (wks,plot,(/yS-1,yE+1/),(/ave-std,ave-std/),res)

draw(plot)
frame(wks)

end
