;*************************************************************
;Aim: Calculate teleconnectivity of seasonal geopotential height
;Mission:
;
;   1. Read data from daily hgt datasets
;   2. Post-post process to deserved results
;   3. Output the teleconnectivity
;                       He Shan
;                       2016-05-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------hgt
;================================================

;datas
    in_path = "~/data/observation/NCEP_NCAR/daily/hgt/"

;time
    mS     = 3
    mE     = 5
    season = "MAM"
;    mS     = 6
;    mE     = 8
;    season = "JJA"
;    mS     = 9
;    mE     = 11
;    season = "SON"
;    mS     = 12
;    mE     = 2
;    season = "DJF"

;Region
    latN = 75
    latS = 0
;    lonL = -60
;    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/NCL/"
    out_name = "tele_"+season+"_BP_30_60_hgt.nc"            ;<<<<<<change>>>>>>

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    hgt_files  = systemfunc ("ls "+in_path+"hgt.1979.nc "+in_path+"hgt.19[8-9]*.nc "+in_path+"hgt.2*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    hgt_in = addfiles (hgt_files, "r")   ;note the "s" of addfile
    ListSetType (hgt_in, "cat")   ;concatenate or "merge" (default)

;    hgt = hgt_in[:]->hgt(:,2,:,:)   ;850hPa
;    hgt = hgt_in[:]->hgt(:,5,:,:)   ;500hPa
    hgt = hgt_in[:]->hgt(:,8,{latN:latS},:)   ;250hPa
    lat = hgt_in[0]->lat({latN:latS})
    lon = hgt_in[0]->lon
    dim = dimsizes (hgt)
    printVarSummary (lat)
    printVarSummary (lon)
    printVarSummary (hgt)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time    = hgt_in[:]->time
    TIME    = cd_calendar (time, 0)
    month   = toint ( TIME(:,1) )

;get the time indexs
    iMM = ind (month.ge.mS .and. month.le.mE)      ;<<<<<<change>>>>>>
;    iMM = ind (month.ge.mS .or. month.le.mE)

; create the filter weights
    nwt    = 121                        ;<<<<<<change>>>>>>
    fca    = 1./60.
    fcb    = 1./30.
    ihp    = 2      ;band pass
;    ihp    = 0      ;low pass
    nsigma = 1.
    wts    = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate deviation from zonal mean
   hgt_anom = dim_rmvmean_Wrap (hgt)
   printVarSummary (hgt_anom)

;band pass filters
   hAnom_BPF_p = wgt_runave_Wrap (hgt_anom(lat|:,lon|:,time|:),wts,0)
   hAnom_BPF   = hAnom_BPF_p (:,:,iMM)
   printVarSummary (hAnom_BPF)

;--------------------------------------------------------------
;compute cross correlation
   tele = hAnom_BPF(:,:,0)

   do i=0,dim(1)-1
    do j=0,dim(2)-1
     tele(i,j) = min (escorc (hAnom_BPF(i,j,:),hAnom_BPF))
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
