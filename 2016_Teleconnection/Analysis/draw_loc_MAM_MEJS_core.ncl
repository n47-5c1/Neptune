;*************************************************************
;Aim: Draw the location of the MAM Middle East jet stream core
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the position
;                       He Shan
;                       2016-05-18
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
    latN = 40
    latS = 16
    lonL = -20
    lonR = 62

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "loc_MAM_MEJS_core"

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
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.3 .and. month1.le.5)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.ge.3 .and. month2.le.5)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate wind speed
   wind   = U(iYYYY1,{latS:latN},{lonL:lonR})
   wind   = sqrt (U(iYYYY1,{latS:latN},{lonL:lonR})^2.+V(iYYYY2,{latS:latN},{lonL:lonR})^2.)
   wind_1 = wind(::3,:,:)
   wind_2 = wind(1::3,:,:)
   wind_3 = wind(2::3,:,:)
   dim    = dimsizes(wind_1)

   printVarSummary (wind_1)

;find latitude and longitude location of the maximum value
   pos_lat = new ((/3,dim(0)/),float)
   pos_lon = new ((/3,dim(0)/),float)
   do i=0,dim(0)-1
    x    = ndtooned (wind_1(i,:,:))              ;convert 2D array to 1D for use in maxind
    inds = ind_resolve ( maxind (x), dim(1:2))   ;convert 1D array back to 2D
    ilat = inds(0,0)                             ;select the latitude & longitude index where the X array is at its' maximum  
    ilon = inds(0,1)
    pos_lat(0,i) = wind_1&lat(ilat)              ;insert the latitude & longitude index into the lat lon coordinate variable
    pos_lon(0,i) = wind_1&lon(ilon)

    x    = ndtooned (wind_2(i,:,:))
    inds = ind_resolve ( maxind (x), dim(1:2))
    ilat = inds(0,0)
    ilon = inds(0,1)
    pos_lat(1,i) = wind_2&lat(ilat)
    pos_lon(1,i) = wind_2&lon(ilon)

    x    = ndtooned (wind_3(i,:,:))
    inds = ind_resolve ( maxind (x), dim(1:2))
    ilat = inds(0,0)
    ilon = inds(0,1)
    pos_lat(2,i) = wind_3&lat(ilat)
    pos_lon(2,i) = wind_3&lon(ilon)
   end do

   printVarSummary (pos_lat)
   print(pos_lat(0,0))
; ==============================================================
; Mission 3. Draw the position
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(3,graphic)      ;creat a plot array

;*******************************************
;  plot map
;*******************************************
res = True

res@gsnDraw  = False      ;don't draw
res@gsnFrame = False      ;don't advance frame

;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 20.     ;label spacing

do i=0,2
 res@gsnLeftString  = text1(i)
 res@gsnRightString = month(i)
 plot(i) = gsn_csm_map_ce (wks,res)
end do

;-------------------------------------------
; Draw markers on the plot in the lat/lon locations

loc = new(3,graphic)      ;creat a plot array

mkres               = True
mkres@gsMarkerIndex = 17     ; Filled circle
mkres@gsMarkerSizeF = 0.02
;mkres@gsMarkerColor = (/"white"/)   ; choose color

do i=0,2
 loc(i) = gsn_add_polymarker (wks,plot(i),pos_lon(i,:),pos_lat(i,:),mkres)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Locations of 250 hPa MEJS Core"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text

gsn_panel(wks,plot,(/3,1/),resP)

end
