;*************************************************************
;Aim: Draw time series of regional average March, April and May Ks
;Mission:
;
;   1. Read data from U datasets
;   2. Post-post process to deserved results
;   3. Draw the time series
;                       He Shan
;                       2016-07-06
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
;================================================

;data
    a       = 6378388.
    omega   = 7.27*10.^(-5.)
    deg2rad = 0.0174533      ;2*pi/360
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "uwnd.mon.mean.nc"

;time
    yS     = 1979
    yE     = 2014
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;Region
    latN = 30
    latS = 20
    lonL = 30
    lonR = 60

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "timeseries_reg_MAM_Ks"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)
    text2 = (/"March","April","May"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file   = addfile (in_path+in_name,"r")

;get the time indexs
    time  = U_file->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    month = toint ( TIME(:,1) )
    iYYYY = ind (year.ge.yS .and. year.le.yE .and. month.ge.3 .and. month.le.5)

;---------------------------------------------------------
;    U_p = U_file->uwnd(:,2,:,:)      ;850hPa
;    U_p = U_file->uwnd(:,5,:,:)      ;500hPa
    U   = U_file->uwnd(iYYYY,8,:,:)      ;250hPa

    lat  = U&lat
    dlat = (lat(2)-lat(1))*deg2rad
    dy   = a*dlat                      ;convert to dist

    printVarSummary (U)
    printVarSummary (iYYYY)
    print(dy)

;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.
    gw = U_file->lat({latS:latN})
    gw = cos(rad*gw)
    printVarSummary(gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute Ks
    beta  = conform (U, 2.*omega/a*cos(U&lat*deg2rad), 1)
    betaa = beta - center_finite_diff_n( center_finite_diff_n(U,dy,False,0,1) ,dy,False,0,1 )
    U     = mask (U,U.le.0.,False)
    Ks    = betaa/U/abs(betaa/U) * sqrt ( abs(betaa/U) )
    copy_VarCoords (U,Ks)
    printVarSummary (Ks)

;compute regional average
    Ks_reg = wgt_areaave_Wrap ( Ks(:,{latS:latN},{lonL:lonR}), gw,1.,0)
    Ks_reg = Ks_reg*10^6

    Ks_1 = Ks_reg(::3)
    Ks_2 = Ks_reg(1::3)
    Ks_3 = Ks_reg(2::3)
    ave1 = avg (Ks_1)
    ave2 = avg (Ks_2)
    ave3 = avg (Ks_3)
    std1 = .8*stddev (Ks_1)
    std2 = .8*stddev (Ks_2)
    std3 = .8*stddev (Ks_3)

    printVarSummary (Ks_1)

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
rts@gsnStringFontHeightF  = 0.024
rts@gsnAboveYRefLineColor = "red"     ;above ref line red
rts@gsnBelowYRefLineColor = "blue"    ;above ref line blue

rts@vpHeightF = 0.3        ;change aspect ratio of plot

rts@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.025

x = ispan(yS,yE,1)
rts@gsnYRefLine     = ave1               ;reference line
rts@gsnLeftString   = text1(0)
rts@gsnCenterString = text2(0)
rts@gsnRightString  = "10^-6 m^-1"
plot(0) = gsn_csm_xy(wks,x,Ks_1,rts)
rts@gsnYRefLine     = ave2
rts@gsnLeftString   = text1(1)
rts@gsnCenterString = text2(1)
rts@gsnRightString  = " "
plot(1) = gsn_csm_xy(wks,x,Ks_2,rts)
rts@gsnYRefLine     = ave3
rts@gsnLeftString   = text1(2)
rts@gsnCenterString = text2(2)
plot(2) = gsn_csm_xy(wks,x,Ks_3,rts)

dum1 = gsn_add_polyline (wks,plot(0),(/yS-1,yE+1/),(/ave1+std1,ave1+std1/),False)
dum2 = gsn_add_polyline (wks,plot(0),(/yS-1,yE+1/),(/ave1-std1,ave1-std1/),False)
dum3 = gsn_add_polyline (wks,plot(1),(/yS-1,yE+1/),(/ave2+std2,ave2+std2/),False)
dum4 = gsn_add_polyline (wks,plot(1),(/yS-1,yE+1/),(/ave2-std2,ave2-std2/),False)
dum5 = gsn_add_polyline (wks,plot(2),(/yS-1,yE+1/),(/ave3+std3,ave3+std3/),False)
dum6 = gsn_add_polyline (wks,plot(2),(/yS-1,yE+1/),(/ave3-std3,ave3-std3/),False)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Time Series of 250 hPa Regional Average MAM Ks"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text

gsn_panel(wks,plot,(/3,1/),resP)

end
