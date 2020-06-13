;*************************************************************
;Aim: Calculate daily phase speed (Cp; m/s)
;Mission:
;
;   1. Read data from daily hgt datasets
;   2. Post-post process to deserved results
;   3. Output the Cp
;                       He Shan
;                       2017-06-23
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/run_cor.ncl"

begin

;================================================
;Variables List:
;	var--------------hgt
;================================================

;datas
    in_path = "~/data/observation/NCEP_DOE/daily/hgt/"

;Region
    latN = 65+10
    latS = 0-10
    lonW = -50-20
    lonE = 150+20

;data
    out_path = "~/hes/One_Belt_One_Road/NCL/"

;the filter
    nwt    = 61
    fca    = 1./30.
    fcb    = 1./10.
    ihp    = 2      ;band pass
;    ihp    = 0      ;low pass
    nsigma = 1.

    wSize = 31

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    hgt_files = systemfunc ("ls "+in_path+"hgt.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    hgt_in = addfiles (hgt_files, "r")
    ListSetType (hgt_in, "cat")   ;concatenate or "merge" (default)

;    hgt  = hgt_in[:]->hgt(:,2,:,:)   ;850 hPa
;    hgt  = hgt_in[:]->hgt(:,5,:,:)   ;500 hPa
    hgt_p = lonFlip (short2flt (hgt_in[:]->hgt(:,8,{latS:latN},:)))   ;250 hPa
    lat   = hgt_in[0]->lat({latS:latN})
    lon_p = lonFlip (hgt_in[0]->lon)
    time  = hgt_in[:]->time
    
    hgt   = hgt_p(:,:,{lonW:lonE})
    lon   = lon_p({lonW:lonE})
    lon   = where (lon .gt. 180, lon-360, lon) 

    dim  = dimsizes (hgt)

    printVarSummary (hgt)
    printVarSummary (lat)
    printVarSummary (lon)
    printVarSummary (time)

;---------------------------------------------------------------
; create the filter weights
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;band pass filters
   hgt_BPF = wgt_runave_n_Wrap (hgt,wts,0,0)
   printVarSummary (hgt_BPF)

do z=1,4
    in_name = "./days_P"+z+"_LaNina.nc"
    out_name = "daily_Ks_P"+z+"_LaNina.nc"

    f     = addfile (in_name, "r")
    nt    = f->nt
    nDays = dimsizes (nt)
    printVarSummary (nt)
;--------------------------------------------------------------
;find latitude and longitude location of the maximum value
   lat1 = new ((/nDays,dim(1),dim(2)/),float)
   lon1 = new ((/nDays,dim(1),dim(2)/),float)
   lat2 = new ((/nDays,dim(1),dim(2)/),float)
   lon2 = new ((/nDays,dim(1),dim(2)/),float)

   do i=0,nDays-1
    do j=0,dim(1)-1
     do k=0,dim(2)-1
      ;compute cross correlation
      x1    = hgt_BPF (nt(i)-wSize:nt(i)+wSize, j, k)
      y1    = hgt_BPF (nt(i)-wSize-1:nt(i)+wSize-1, :, :)
      y2    = hgt_BPF (nt(i)-wSize+1:nt(i)+wSize+1, :, :)
      cLead = escorc_n (x1,y1,0,0)
      cLag  = escorc_n (x1,y2,0,0)

      x    = ndtooned (cLead)                      ;convert 2D array to 1D for use in maxind
      inds = ind_resolve ( maxind (x), dim(1:2))   ;convert 1D array back to 2D
      ilat = inds(0,0)                             ;select the latitude & longitude index where the X array is at its' maximum  
      ilon = inds(0,1)
      lat1(i,j,k) = (/lat(ilat)/)                      ;insert the latitude & longitude index into the lat lon coordinate variable
      lon1(i,j,k) = (/lon(ilon)/)

      x    = ndtooned (cLag)
      inds = ind_resolve ( maxind (x), dim(1:2))
      ilat = inds(0,0)
      ilon = inds(0,1)
      lat2(i,j,k) = (/lat(ilat)/)
      lon2(i,j,k) = (/lon(ilon)/)
     end do
    end do
    print("OK "+i)
   end do

;determine the statistical significance
;   prob = tele      ;copy meta data
;   prob = rtest (tele,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
;   printVarSummary (prob)

   copy_VarCoords (hgt_BPF(nt,:,:),lat1)
   copy_VarCoords (hgt_BPF(nt,:,:),lon1)
   copy_VarCoords (hgt_BPF(nt,:,:),lat2)
   copy_VarCoords (hgt_BPF(nt,:,:),lon2)

   printVarSummary (lat1)
   print(lat1(10,{25},{90}))
   print(lon1(10,{25},{90}))
   print(lat2(10,{25},{90}))
   print(lon2(10,{25},{90}))

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

system ("rm -f "+out_path+out_name)      ;remove if exists
fout = addfile (out_path+out_name,"c")   ;open output file

setfileoption (fout,"DefineMode",True)   ;declare file definition mode

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time","lat","lon"/)  
dimSizes = (/nDays,dim(1),dim(2)/)
dimUnlim = (/True,False,False/)   
filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"time",typeof(time),getvardims(time))
filevardef (fout,"lat", typeof(lat), getvardims(lat))
filevardef (fout,"lon", typeof(lon), getvardims(lon))
filevardef (fout,"lat1",typeof(lat1),getvardims(lat1))
filevardef (fout,"lon1",typeof(lon1),getvardims(lon1))
filevardef (fout,"lat2",typeof(lat2),getvardims(lat2))
filevardef (fout,"lon2",typeof(lon2),getvardims(lon2))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time(nt))
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"lat1",lat1)
filevarattdef (fout,"lon1",lon1)
filevarattdef (fout,"lat2",lat2)
filevarattdef (fout,"lon2",lon2)

;output only the data values
fout->time = (/time(nt)/)
fout->lat  = (/lat/)
fout->lon  = (/lon/)
fout->lat1 = (/lat1/)
fout->lon1 = (/lon1/)
fout->lat2 = (/lat2/)
fout->lon2 = (/lon2/)

delete([/nt,lat1,lon1,lat2,lon2/])
end do

end
