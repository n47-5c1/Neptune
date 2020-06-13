;*************************************************************
;Aim: Calculate daily phase speed (Cp; m/s)
;Mission:
;
;   1. Read data from daily datasets
;   2. Post-post process to deserved results
;   3. Output the Cp
;                       He Shan
;                       2017-06-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------lat1
;	var2--------------lon1
;	var3--------------lat2
;	var4--------------lon2
;================================================

;data
    out_path = "~/hes/One_Belt_One_Road/NCL/"

    pi   = atan(1.0)*4.
    unit = pi/180.
    re   = 6378388      ;at the equator

do i=1,4
; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in_name  = "./daily_Ks_P"+i+"_LaNina.nc"
    out_name = "daily_Ks_xy_P"+i+"_LaNina.nc"

    f = addfile (in_name, "r")

    lat1 = f->lat1
    lon1 = f->lon1
    lat2 = f->lat2
    lon2 = f->lon2
    lat  = f->lat
    lon  = f->lon
    time = f->time

    lat1 = unit*lat1
    lon1 = unit*lon1
    lat2 = unit*lat2
    lon2 = unit*lon2

    dim = dimsizes (lat1)

    printVarSummary (lat1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate distance between the two points (the haversine formula)
    spd = 2.*re*asin( sqrt( sin((lat2-lat1)/2.)^2. + cos(lat1)*cos(lat2)*sin((lon2-lon1)/2.)^2. ) ) / (2.*24.*60.*60.)
    copy_VarMeta (lat1,spd)
    printVarSummary (spd)

;bearing (or course) between two points
    dir = mod( atan2 ( sin(lon2-lon1)*cos(lat2), cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon2-lon1) ), 2*pi)
    copy_VarMeta (lat1,dir)
    printVarSummary (dir)

    xy = wind_component (spd,dir/unit,0)
    xy = (/-1.*xy/)
    printVarSummary (xy)

    print((/lat1(10,{25},{90})/))
    print((/lon1(10,{25},{90})/))
    print((/lat2(10,{25},{90})/))
    print((/lon2(10,{25},{90})/))
    print((/dir(10,{25},{90})/))
    print((/xy(0,10,{25},{90})/))
    print((/xy(1,10,{25},{90})/))

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

system ("rm -f "+out_path+out_name)
fout = addfile (out_path+out_name,"c")

setfileoption (fout,"DefineMode",True)   ;declare file definition mode

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time","lat","lon"/)  
dimSizes = (/dim(0),dim(1),dim(2)/)
dimUnlim = (/True,False,False/)   
filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"time",typeof(time),getvardims(time))
filevardef (fout,"lat", typeof(lat), getvardims(lat))
filevardef (fout,"lon", typeof(lon), getvardims(lon))
filevardef (fout,"x",   typeof(xy),  getvardims(xy(0,:,:,:)))
filevardef (fout,"y",   typeof(xy),  getvardims(xy(1,:,:,:)))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"x",   xy)
filevarattdef (fout,"y",   xy)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/)
fout->x    = (/xy(0,:,:,:)/)
fout->y    = (/xy(1,:,:,:)/)

delete([/time,lat1,lon1,lat2,lon2,spd,dir,xy/])

end do

end
