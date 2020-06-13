;*************************************************************
;Aim: Convert specific daily data into segment (eg, pentad, weekly) data
;Mission:
;
;   1. Read data from sst, uwnd and vwnd datasets
;   2. Post-post process data to deserved results
;   3. Output deserved data
;
;                       He Shan
;                       2017-05-11
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;   var3--------------vwnd
;================================================

;datas
    in_path1 = "~/data/observation/SST/OISST_daily/mean/"
    in_path2 = "~/data/observation/NCEP_DOE/daily/"

;time
    yS   = 1982
    yE   = 2015
    segN = "weekly"

    opt                = True
    opt@nval_crit      = 4          ;the minimum number of values needed
    opt@segment_length = 7

;data
    out_path  = "~/hes/One_Belt_One_Road/NCL/"
    out_name1 = "sst."+segN+".mean.anom_"+yS+"-"+yE+".nc"
    out_name2 = "sf."+segN+".mean.anom_"+yS+"-"+yE+".nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    SST_files = systemfunc ("ls "+in_path1+"sst.day.mean.*.v2.nc")
    U_files   = systemfunc ("ls "+in_path2+"uwnd/uwnd.*.nc")
    V_files   = systemfunc ("ls "+in_path2+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    SST_in = addfiles (SST_files, "r")   ;note the "s" of addfile
    U_in   = addfiles (U_files, "r")
    V_in   = addfiles (V_files, "r")

    SST   = SST_in[:]->sst(:,::8,::8)
    U     = short2flt (U_in[:]->uwnd(:,8,::-1,:))   ;250 hPa
    V     = short2flt (V_in[:]->vwnd(:,8,::-1,:))

    time1 = SST_in[:]->time
    lat1  = SST_in[0]->lat(::8)
    lon1  = SST_in[0]->lon(::8)

    time2 = U_in[:]->time
    lat2  = U_in[0]->lat(::-1)
    lon2  = U_in[0]->lon

    printVarSummary (SST)
    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (time1)
    printVarSummary (lat1)
    printVarSummary (lon1)
    printVarSummary (time2)
    printVarSummary (lat2)
    printVarSummary (lon2)

;----------------------------------------------------------
    TIME1  = cd_calendar (time1,0)
    year1  = floattointeger (TIME1(:,0))
    month1 = floattointeger (TIME1(:,1))
    day1   = floattointeger (TIME1(:,2))
    ddd1   = day_of_year (year1, month1, day1)

    TIME2  = cd_calendar (time2,0)
    year2  = floattointeger (TIME2(:,0))
    month2 = floattointeger (TIME2(:,1))
    day2   = floattointeger (TIME2(:,2))

;get the time indexs
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
    printVarSummary (iYYYY1)

;create required yyyyddd
    ddd1     = day_of_year (year1, month1, day1)
    yyyyddd1 = year1(iYYYY1)*1000 + ddd1(iYYYY1)
    ddd2     = day_of_year (year2, month2, day2)
    yyyyddd2 = year2(iYYYY2)*1000 + ddd2(iYYYY2)
    printVarSummary (yyyyddd1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
    sfvp = uv2sfvpF (U(iYYYY2,:,:),V(iYYYY2,:,:))
    sf   = sfvp(0,:,:,:)
    copy_VarCoords (U(iYYYY2,:,:),sf)
    printVarSummary (sf)

;Deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
    SST_clm  = clmDayTLL (SST(iYYYY1,:,:), yyyyddd1)
    SST_tAnom = calcDayAnomTLL (SST(iYYYY1,:,:), yyyyddd1, SST_clm)

    sf_clm  = clmDayTLL (sf_xAnom, yyyyddd2)
    sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd2, sf_clm)

    printVarSummary (SST_tAnom)

;Calculate segment means
    SST_seg = calculate_segment_values (SST_tAnom, "avg", 0, opt)
    sf_seg  = calculate_segment_values (sf_tAnom, "avg", 0, opt)
    printVarSummary (SST_seg)
    printVarSummary (sf_seg)

    time_seg = SST_seg&time
    dim1     = dimsizes (SST_seg)
    dim2     = dimsizes (sf_seg)

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

system ("rm -f "+out_path+out_name1)        ;remove if exists
system ("rm -f "+out_path+out_name2)

fout1 = addfile (out_path+out_name1,"c")   ;open output file
fout2 = addfile (out_path+out_name2,"c")

setfileoption (fout1,"DefineMode",True)   ;declare file definition mode
setfileoption (fout2,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames1 = (/"time","lat","lon"/)  
dimSizes1 = (/dim1(0),dim1(1),dim1(2)/) 
dimSizes2 = (/dim2(0),dim2(1),dim2(2)/) 
dimUnlim1 = (/True,False,False/)   

filedimdef (fout1,dimNames1,dimSizes1,dimUnlim1)
filedimdef (fout2,dimNames1,dimSizes2,dimUnlim1)

;predefine the the dimensionality of the variables to be written out
filevardef (fout1,"time",typeof(time_seg),getvardims(time_seg))
filevardef (fout2,"time",typeof(time_seg),getvardims(time_seg))

filevardef (fout1,"lat",typeof(lat1),getvardims(lat1))
filevardef (fout2,"lat",typeof(lat2),getvardims(lat2))

filevardef (fout1,"lon",typeof(lon1),getvardims(lon1))
filevardef (fout2,"lon",typeof(lon2),getvardims(lon2))

filevardef (fout1,"sst",typeof(SST_seg),getvardims(SST_seg))
filevardef (fout2,"sf", typeof(sf_seg), getvardims(sf_seg))

;Copy attributes associated with each variable to the file
filevarattdef (fout1,"time",time_seg)
filevarattdef (fout2,"time",time_seg)

filevarattdef (fout1,"lat",lat1)
filevarattdef (fout2,"lat",lat2)

filevarattdef (fout1,"lon",lon1)
filevarattdef (fout2,"lon",lon2)

filevarattdef (fout1,"sst",SST_seg)
filevarattdef (fout2,"sf", sf_seg)

;output only the data values
fout1->time = (/time_seg/)
fout2->time = (/time_seg/)

fout1->lat = (/lat1/)
fout2->lat = (/lat2/)

fout1->lon = (/lon1/) 
fout2->lon = (/lon2/) 

fout1->sst = (/SST_seg/)
fout2->sf  = (/sf_seg/)

end
