;*************************************************************
;Aim: Draw PC1 of regional MAM winds
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the and PC1s
;                       He Shan
;                       2016-05-11
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
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;regiion
    latN = 89
    latS = 0
    lonL = -80
    lonR = 170

    neof        = 1      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "PC1_reg_MAM_wind"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)
    text2 = (/"March","April","May"/)

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

    eof_ts1 = eof_ts(0,::3)
    eof_ts2 = eof_ts(0,1::3)
    eof_ts3 = eof_ts(0,2::3)

    ave1 = avg (eof_ts1)
    ave2 = avg (eof_ts2)
    ave3 = avg (eof_ts3)
    std1 = 0.8*stddev (eof_ts1)
    std2 = 0.8*stddev (eof_ts2)
    std3 = 0.8*stddev (eof_ts3)

    printVarSummary (eof_ts1)

; ==============================================================
; Mission 3. Draw the PC
; ==============================================================

 wks  = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(3,graphic)      ;creat a plot array

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw               = False     ;don't draw
rts@gsnFrame              = False     ;don't advance frame
rts@gsnXYBarChart         = True      ;creat bar chart
rts@gsnStringFontHeightF  = 0.026
rts@gsnAboveYRefLineColor = "red"     ;above ref line red
rts@gsnBelowYRefLineColor = "blue"    ;above ref line blue

rts@vpHeightF = 0.3        ;change aspect ratio of plot

rts@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.025

year = ispan(yS,yE,1)
rts@gsnYRefLine    = ave1               ;reference line
rts@gsnLeftString  = text1(0)
rts@gsnRightString = text2(0)
plot(0) = gsn_csm_xy(wks,year,eof_ts1,rts)
rts@gsnYRefLine    = ave2
rts@gsnLeftString  = text1(1)
rts@gsnRightString = text2(1)
plot(1) = gsn_csm_xy(wks,year,eof_ts2,rts)
rts@gsnYRefLine    = ave3
rts@gsnLeftString  = text1(2)
rts@gsnRightString = text2(2)
plot(2) = gsn_csm_xy(wks,year,eof_ts3,rts)

res                  = True         ; polyline mods desired
;res@gsLineThicknessF = 2            ;thickness of lines
;res@gsLineDashPattern = 1
dum1 = gsn_add_polyline (wks,plot(0),(/yS-1,yE+1/),(/ave1+std1,ave1+std1/),res)
dum2 = gsn_add_polyline (wks,plot(0),(/yS-1,yE+1/),(/ave1-std1,ave1-std1/),res)
dum3 = gsn_add_polyline (wks,plot(1),(/yS-1,yE+1/),(/ave2+std2,ave2+std2/),res)
dum4 = gsn_add_polyline (wks,plot(1),(/yS-1,yE+1/),(/ave2-std2,ave2-std2/),res)
dum5 = gsn_add_polyline (wks,plot(2),(/yS-1,yE+1/),(/ave3+std3,ave3+std3/),res)
dum6 = gsn_add_polyline (wks,plot(2),(/yS-1,yE+1/),(/ave3-std3,ave3-std3/),res)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "PC1 of 250 hPa wind"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text

gsn_panel(wks,plot,(/3,1/),resP)

end
