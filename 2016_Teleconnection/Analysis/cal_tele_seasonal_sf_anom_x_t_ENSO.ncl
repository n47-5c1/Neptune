;*************************************************************
;Aim: Calculate teleconnectivity of seasonal stream function for El Nino and La Nina years in the winter-half year
;Mission:
;
;   1. Read data from daily U & V datasets
;   2. Post-post process to deserved results
;   3. Output the teleconnectivity
;                       He Shan
;                       2017-05-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------uwnd
;	var2--------------vwnd
;================================================

;datas
    in_path1 = "~/data/observation/NCEP_DOE/daily/uwnd/"
    in_path2 = "~/data/observation/NCEP_DOE/daily/vwnd/"

;time
;    mS     = 3
;    mE     = 5
;    season = "MAM"
;    mS     = 12
;    mE     = 2
;    season = "DJF"
    mS     = 11
    mE     = 4
    season = "winter"

    yS1 = (/1982,1986,1987,1991,1997,2002,2004,2006,2009,2015/)
    yS2 = (/1983,1984,1988,1995,1998,1999,2000,2007,2010,2011/)   ;2016!
    ny  = dimsizes (yS1)

;Region
    latN = 75
    latS = 0
;    lonL = -60
;    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/NCL/"
;    out_name = "tele_"+season+"_sf_anom_x_t_10_30_BP_ElNino.nc"            ;<<<<<<change>>>>>>
    out_name = "tele_"+season+"_sf_anom_x_t_10_30_BP_LaNina.nc"

;the filter
    nwt    = 61                        ;<<<<<<change>>>>>>
    fca    = 1./30.
    fcb    = 1./10.
    ihp    = 2      ;band pass
;    ihp    = 0      ;low pass
    nsigma = 1.

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    U_files  = systemfunc ("ls "+in_path1+"uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path2+"vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files, "r")   ;note the "s" of addfile
    V_in = addfiles (V_files, "r")
    ListSetType (U_in, "cat")   ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")

;    hgt = hgt_in[:]->hgt(:,2,:,:)   ;850 hPa
;    hgt = hgt_in[:]->hgt(:,5,:,:)   ;500 hPa
    U = U_in[:]->uwnd(:,8,::-1,:)   ;250 hPa
    V = V_in[:]->vwnd(:,8,::-1,:)   ;250 hPa
    lat = U_in[0]->lat({latS:latN})
    lon = U_in[0]->lon
    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (lat)
    printVarSummary (lon)

;---------------------------------------------------------------
    time  = U_in[:]->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    month = toint ( TIME(:,1) )
    day   = toint ( TIME(:,2) )
    ddd   = day_of_year (year,month,day)

; Read time and create required yyyyddd                    
    yyyyddd = year*1000 + ddd      ;needed for input
    printVarSummary (yyyyddd)

;get the time indexs
    El = (year.eq.yS1(0) .and. month.ge.7 .or. year.eq.yS1(0)+1 .and. month.lt.7)
    do i=1,ny-1
     El = El.or.(year.eq.yS1(i) .and. month.ge.7 .or. year.eq.yS1(i)+1 .and. month.lt.7)
    end do

    La = (year.eq.yS2(0) .and. month.ge.7 .or. year.eq.yS2(0)+1 .and. month.lt.7)
    do i=1,ny-1
     La = La.or.(year.eq.yS2(i) .and. month.ge.7 .or. year.eq.yS2(i)+1 .and. month.lt.7)
    end do

    iMM = ind ((month.ge.mS .or. month.le.mE) .and. La)      ;<<<<<<change>>>>>>
;    iMM = ind (month.ge.mS .and. month.le.mE .and. La)

; create the filter weights
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
   sfvp = uv2sfvpF (U,V)
   sf_p = sfvp(0,:,:,:)
   copy_VarCoords (U,sf_p)
   sf  = sf_p(:,{latS:latN},:)
   dim = dimsizes (sf)
   printVarSummary (sf)   

;calculate deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
   sfClmDay = clmDayTLL (sf_xAnom, yyyyddd)
   sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   printVarSummary(sf_tAnom)

;band pass filters
   sf_BPF_p = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   sf_BPF   = sf_BPF_p (:,:,iMM)
   printVarSummary (sf_BPF)

;--------------------------------------------------------------
;compute cross correlation
   tele = sf_BPF(:,:,0)

   do i=0,dim(1)-1
    do j=0,dim(2)-1
     tele(i,j) = min (escorc (sf_BPF(i,j,:),sf_BPF))
    end do
    print("OK "+i)
   end do

;determine the statistical significance
;   prob = tele      ;copy meta data
;   prob = rtest (tele,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (tele)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

system ("rm -f "+out_path+out_name)      ;remove if exists
fout = addfile (out_path+out_name,"c")   ;open output file

setfileoption (fout,"DefineMode",True)   ;declare file definition mode

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"lat","lon"/)  
dimSizes = (/dim(1),dim(2)/) 
dimUnlim = (/False,False/)   
filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"lat",typeof(lat),getvardims(lat))                          
filevardef (fout,"lon",typeof(lon),getvardims(lon))                          
filevardef (fout,"tele",typeof(tele),getvardims(tele))    

;Copy attributes associated with each variable to the file
filevarattdef (fout,"lat",lat)
filevarattdef (fout,"lon",lon)
filevarattdef (fout,"tele",tele)

;output only the data values
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->tele = (/tele/)

end
