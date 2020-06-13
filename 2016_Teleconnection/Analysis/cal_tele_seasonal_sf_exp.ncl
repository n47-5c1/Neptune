;*************************************************************
;Aim: Calculate teleconnectivity of seasonal stream function from experiments
;Mission:
;
;   1. Read data from daily U250 & V250 datasets
;   2. Post-post process to deserved results
;   3. Output the teleconnectivity
;                       He Shan
;                       2017-03-20
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------U
;	var2--------------V
;================================================

;datas
    in_path = "~/data/model/hes/1979_2015_SSTice_FC5PM_daily/"
    yS      = 2

;Region
    latN = 75
    latS = 0
;    lonL = -60
;    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/NCL/"

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

    U_file = addfile (in_path+"U.250.nc", "r")   ;note the "s" of addfile
    V_file = addfile (in_path+"V.250.nc", "r")
    U = U_file->U
    V = V_file->V
    lat = U_file->lat({latS:latN})
    lon = U_file->lon
    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (lat)
    printVarSummary (lon)

;---------------------------------------------------------------
; Read time
    time  = U_file->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    month = toint ( TIME(:,1) )

; create the filter weights
    wts    = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
    sfvp = uv2sfvpG (U,V)
    sf_p = sfvp(0,:,:,:)
    copy_VarCoords (U,sf_p)
    sf  = sf_p(:,{latS:latN},:)
    dim = dimsizes (sf)
    printVarSummary (sf)   

;band pass filters
   sf_BPF_p = wgt_runave_Wrap (sf(lat|:,lon|:,time|:),wts,0)

; ==============================================================
do i=0,3

print("<<<<<<<<<<do>>>>>>>>>> "+i)

;time
    if (i.eq.0) then
     mS     = 3
     mE     = 5
     season = "MAM"
    else if (i.eq.1) then
     mS     = 6
     mE     = 8
     season = "JJA"
    else if (i.eq.2) then
     mS     = 9
     mE     = 11
     season = "SON"
    else
     mS     = 12
     mE     = 2
     season = "DJF"
    end if
    end if
    end if

;data
    out_name = "tele_"+season+"_BP_10_30_sf_CON.nc"            ;<<<<<<change>>>>>>
;    out_name = "tele_"+season+"_BP_10_30_sf_SEN.nc"

;get the time indexs
    if (i.eq.3) then
     iMM = ind (year.ge.yS .and. (month.ge.mS .or. month.le.mE))   ;<<<<<<change>>>>>>
    else
     iMM = ind (year.ge.yS .and. month.ge.mS .and. month.le.mE)
    end if
    printVarSummary (iMM)

   sf_BPF   = sf_BPF_p (:,:,iMM)
   printVarSummary (sf_BPF)

;--------------------------------------------------------------
;compute cross correlation
   tele = sf_BPF(:,:,0)

   do j=0,dim(1)-1
    do k=0,dim(2)-1
     tele(j,k) = min (escorc (sf_BPF(j,k,:),sf_BPF))
    end do
    print("OK "+j)
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

delete([/iMM,sf_BPF,tele,fout/])

end do

end
