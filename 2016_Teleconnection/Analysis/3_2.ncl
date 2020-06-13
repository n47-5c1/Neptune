; 3-D wave-activity flux derived by Takaya and Nakamura (1999, 2001)
; See (38) of Takaya and Nakamura (2001, JAS)
;
; Used data: 
;  Daily-mean data of NCEP/NCAR reanalys 1
;   geopotential height (hgt: m) ; hgt.1999.nc hgt.2000.nc hgt.2001.nc 
;
;  Daily climatology of NCEP/NCAR reanalys 1 (365 days)
;   geopotential height (hgt: m) ; hgt.day.ltm.nc
;   air tempeature (air: degK)   ; air.day.ltm.nc
;   zonal wind (uwnd: m/s)       ; uwnd.day.ltm.nc
;   meridional wind (vwnd: m/s)  ; vwnd.day.ltm.nc
;
; The data are available at 
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html
;
; The period for calcuation is 1st January, 2000 to 31th December, 2000
; (see variables of fyear,fmon, fday, lyear, lmon, lday)
;
; The unit of level is [hPa]
;
; Basic state: daily climatology
;
; Perturbation: deviation from climatology for each calendar day
;
; Calculating the flux for each day of input data.
;
; Note that 
; (i)  10-day low-pass filter is applied
;       (Assume that phase speed (Cp) is almost zero)
;
; (ii) "p" (pressure) in Eq. (5.7) is dimensionless (pressure/1000mb)
;
; (iii) The year 2000 is a leap year (366 days)
;
; (iv)  Using height data of 1999 and 2001 is for time filtering. 
;       The filter makes the first and last several days unavailable.

; Output files are
; x-component:  TN2001-Fx.daily.nc
; y-component:  TN2001-Fy.daily.nc
; z-component:  TN2001-Fz.daily.nc
; daily QG stream function anomaly: psidev.daily.nc
; Brunt Vaisala frequency: NN.daily.nc

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; direcotry name
diri = "~/data/observation/NCEP_DOE/daily/"

;Region
    latN = 75
    latS = -10
    lonW = -70
    lonE = 170

; daily mean data
filename = systemfunc ("ls "+diri+"hgt/hgt.*.nc")
zfile    = addfiles (filename,"r")
filename = systemfunc ("ls "+diri+"air/air.*.nc")
tfile    = addfiles (filename,"r")
filename = systemfunc ("ls "+diri+"uwnd/uwnd.*.nc")
ufile    = addfiles (filename,"r")
filename = systemfunc ("ls "+diri+"vwnd/vwnd.*.nc")
vfile    = addfiles (filename,"r")

ListSetType (zfile, "cat")
ListSetType (tfile, "cat")
ListSetType (ufile, "cat")
ListSetType (vfile, "cat")

bzvar_p = lonFlip (short2flt (zfile[:]->hgt(:,7:9,{latS:latN},:)))
btvar_p = lonFlip (short2flt (tfile[:]->air(:,7:9,{latS:latN},:)))
buvar_p = lonFlip (short2flt (ufile[:]->uwnd(:,7:9,{latS:latN},:)))
bvvar_p = lonFlip (short2flt (vfile[:]->vwnd(:,7:9,{latS:latN},:)))

time  = zfile[:]->time
lat   = zfile[0]->lat({latS:latN})
lon_p = lonFlip (zfile[0]->lon)
level = zfile[0]->level(7:9)

bzvar = bzvar_p(:,:,:,{lonW:lonE})
btvar = btvar_p(:,:,:,{lonW:lonE})
buvar = buvar_p(:,:,:,{lonW:lonE})
bvvar = bvvar_p(:,:,:,{lonW:lonE})
lon   = lon_p({lonW:lonE})
lon   = where (lon .gt. 180, lon-360, lon) 

ntime  = dimsizes (time)
nlat   = dimsizes (lat)
nlon   = dimsizes (lon)
nlevel = dimsizes (level)

delete([/bzvar_p,btvar_p,buvar_p,bvvar_p,lon_p/])

;-------------------------------------------------------------
;height anomaly (10-30-day band-pass fileter)
wgt   = filwgts_lanczos (61, 2, 1./30., 1./10., 1.)
zavar = wgt_runave_n_Wrap (bzvar,wgt,0,0)
;Basic state
wgt   = filwgts_lanczos (61, 0, 1./30., -999., 1.)
czvar = wgt_runave_n_Wrap (bzvar,wgt,0,0)
ctvar = wgt_runave_n_Wrap (btvar,wgt,0,0)
cuvar = wgt_runave_n_Wrap (buvar,wgt,0,0)
cvvar = wgt_runave_n_Wrap (bvvar,wgt,0,0)

delete ([/bzvar,btvar,buvar,bvvar/])

;-------------------------------------------------------------
; Gas constant
gc = 290
; Gravitational acceleration
ga = 9.80665

; Radius of the earth
re = 6378388

; scale height
sclhgt = 8000.

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f            =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat(:))
f!0          = "lat"
f&lat        = lat
f@_FillValue = zavar@_FillValue

; missing for 2.5S - 2.5N
do ilat = 0, nlat-1
 if (abs(lat(ilat) ).lt. 2.5 ) then
  f(ilat)= f@_FillValue
 end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)


; ==============================================================
do i=1,4

out1  = "TN2001-Fx.daily.P"+i+"_LaNina.nc"
out2  = "TN2001-Fy.daily.P"+i+"_LaNina.nc"
ffile = addfile ("./daily_Ks_xy_P"+i+"_LaNina.nc","r")
nfile = addfile ("./days_P"+i+"_LaNina.nc","r")

Cp_x = ffile->x
Cp_y = ffile->y
nt   = nfile->nt

; 1-D -> 4-D
leveltmp  = conform_dims (dimsizes(zavar(nt,:,:,:)), level,1)
coslattmp = conform_dims (dimsizes(zavar(nt,:,:,:)), coslat,2)
ftmp      = conform_dims (dimsizes(zavar(nt,:,:,:)), f,2)

; vertical gradient of potential temperature  (K/m)
dthetadz = center_finite_diff_n (ctvar(nt,:,:,:)*(1000./leveltmp)^0.286,-sclhgt*log(level/1000),False,0,1)

; Brunt Vaisala frequency
NN            = (gc*(leveltmp/1000.)^0.286)/sclhgt * dthetadz
NN@_FillValue = ctvar@_FillValue
NN            = where (NN .gt. 0, NN, NN@_FillValue)

; magnitude of climatological wind
cumag            = sqrt (cuvar(nt,:,:,:)^2 + cvvar(nt,:,:,:)^2)
cumag@_FillValue = cuvar@_FillValue
cumag            = where (cumag .gt. 0, cumag, cumag@_FillValue)

;phase speed in the direction of U (Cp) (m/s)
Cpxtmp = conform_dims ( dimsizes(zavar(nt,:,:,:)), Cp_x,(/0,2,3/))
Cpytmp = conform_dims ( dimsizes(zavar(nt,:,:,:)), Cp_y,(/0,2,3/))
Cp     = Cpxtmp*cuvar(nt,:,:,:)/cumag + Cpytmp*cvvar(nt,:,:,:)/cumag
Cp@_FillValue = Cp_x@_FillValue

; QG steam function for anomaly
psidev = zavar(nt,:,:,:)*ga /ftmp
psiclm = czvar(nt,:,:,:)*ga /ftmp

delete (dthetadz)
;-------------------------------------------------------------
;dpsidev/dlon
dpsidevdlon = center_finite_diff_n (psidev,lon*pi/180.,True,0,3)

;ddpsidev/dlonlon
ddpsidevdlonlon = center_finite_diff_n (dpsidevdlon,lon*pi/180.,True,0,3)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n (psidev, lat*pi/180., False,0,2)

;dpsidev*coslattmp/dlat
dpsidevcoslattmpdlat = center_finite_diff_n (psidev*coslattmp, lat*pi/180., False,0,2)

;ddpsidev/dlonlat
ddpsidevdlonlat = center_finite_diff_n (dpsidevdlon,lat*pi/180.,False,0,2)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n (dpsidevdlat, lat*pi/180.,False,0,2)

;ddpsidev/dlat*coslattmp/dlat
ddpsidevdlatcoslattmpdlat = center_finite_diff_n (dpsidevdlat*coslattmp,lat*pi/180.,False,0,2)

;dpsidev/dz
dpsidevdz = center_finite_diff_n (psidev, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dz*p/NNdz
ddpsidevdzpNNdz = center_finite_diff_n (dpsidevdz*leveltmp/1000./NN,-sclhgt*log(level/1000),False,0,1)

;ddpsidev/dlondz
;ddpsidevdlonz = center_finite_diff_n (dpsidevdlon, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dlatdz
;ddpsidevdlatz = center_finite_diff_n (dpsidevdlat, -sclhgt*log(level/1000),False,0,1)


xuterm = (dpsidevdlon*dpsidevdlon - psidev*ddpsidevdlonlon)
xvterm = (dpsidevdlon*dpsidevdlat - psidev*ddpsidevdlonlat)
;yuterm = xvterm
yvterm = (dpsidevdlat*dpsidevdlat - psidev*ddpsidevdlatlat)
;zuterm = (dpsidevdlon*dpsidevdz - psidev*ddpsidevdlonz)
;zvterm = (dpsidevdlat*dpsidevdz - psidev*ddpsidevdlatz)

qavar = ddpsidevdlonlon/(re*re*coslattmp*coslattmp) +  ddpsidevdlatcoslattmpdlat/(re*re*coslattmp) + ftmp*ftmp/leveltmp*1000.*ddpsidevdzpNNdz

evar = ((dpsidevdlon/re/coslattmp)^2.+(dpsidevcoslattmpdlat/re/coslattmp)^2.+(ftmp*dpsidevdz)^2./NN)/2.

delete ([/dpsidevdlon,ddpsidevdlonlon,dpsidevdlat,dpsidevcoslattmpdlat,ddpsidevdlonlat,ddpsidevdlatlat,ddpsidevdlatcoslattmpdlat,dpsidevdz,ddpsidevdzpNNdz/])

;Basic state
;dpsidev/dlon
dpsiclmdlon = center_finite_diff_n (psiclm,lon*pi/180.,True,0,3)

;ddpsidev/dlonlon
ddpsiclmdlonlon =  center_finite_diff_n (dpsiclmdlon,lon*pi/180.,True,0,3)

;dpsidev/dlat
dpsiclmdlat = center_finite_diff_n (psiclm, lat*pi/180., False,0,2)

;ddpsidev/dlat*coslattmp/dlat
ddpsiclmdlatcoslattmpdlat = center_finite_diff_n (dpsiclmdlat*coslattmp,lat*pi/180.,False,0,2)

;dpsidev/dz
dpsiclmdz = center_finite_diff_n (psiclm, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dz*p/NNdz
ddpsiclmdzpNNdz = center_finite_diff_n (dpsiclmdz*leveltmp/1000./NN,-sclhgt*log(level/1000),False,0,1)

cqvar = ddpsiclmdlonlon/(re*re*coslattmp*coslattmp) +  ddpsiclmdlatcoslattmpdlat/(re*re*coslattmp) + ftmp*ftmp/leveltmp*1000.*ddpsiclmdzpNNdz

;dcqvar/dlon
dcqvardlon = center_finite_diff_n (cqvar,lon*pi/180.,True,0,3)

;dcqvar/dlat
dcqvardlat = center_finite_diff_n (cqvar,lat*pi/180.,False,0,2)

; magnitude of climatological q
cqmag            = sqrt((dcqvardlon/re/coslattmp)^2 + (dcqvardlat/re)^2)
cqmag@_FillValue = czvar@_FillValue
cqmag            = where(cqmag .gt. 0, cqmag, cqmag@_FillValue)

Mvar = leveltmp/1000./2.*(qavar*qavar/2./cqmag + evar/(cumag-Cp))*coslattmp

delete ([/qavar,evar,dpsiclmdlon,ddpsiclmdlonlon,dpsiclmdlat,ddpsiclmdlatcoslattmpdlat,dpsiclmdz,ddpsiclmdzpNNdz,cqvar,dcqvardlon,dcqvardlat,cqmag/])
 
;-------------------------------------------------------------
; Mask out where westerlies is small or negative (less than 2 m/s).
;  by using mask

;x-component of (38)
Fx = mask (leveltmp/1000./(2.*cumag*re*re)*( cuvar(nt,:,:,:)/coslattmp*xuterm + cvvar(nt,:,:,:)*xvterm) + cuvar(nt,:,:,:)/cumag*Mvar, cuvar(nt,:,:,:).lt.5.,False)

;y-component 
Fy = mask (leveltmp/1000./(2.*cumag*re*re)*( cuvar(nt,:,:,:)*xvterm + coslattmp*cvvar(nt,:,:,:)*yvterm) + cvvar(nt,:,:,:)/cumag*Mvar,  cuvar(nt,:,:,:).lt.5.,False)

;z-component 
;Fz = mask (leveltmp/1000.*ftmp*ftmp/(2.*cumag*NN*re)*(cuvar*zuterm + coslattmp*cvvar*zvterm), cuvar.lt.5, False)

; for output
Fx!0 = "time"
Fx&time = time(nt)
Fx!1 = "level"
Fx&level = level
Fx!2 = "lat"
Fx&lat = lat
Fx!3 = "lon"
Fx&lon = lon

Fy!0 = "time"
Fy&time = time(nt)
Fy!1 = "level"
Fy&level = level
Fy!2 = "lat"
Fy&lat = lat
Fy!3 = "lon"
Fy&lon = lon

;Fz!0 = "time"
;Fz&time = time
;Fz!1 = "level"
;Fz&level = level
;Fz!2 = "lat"
;Fz&lat = lat
;Fz!3 = "lon"
;Fz&lon = lon

;psidev!0 = "time"
;psidev&time = time
;psidev!1 = "level"
;psidev&level = level
;psidev!2 = "lat"
;psidev&lat = lat
;psidev!3 = "lon"
;psidev&lon = lon

;NN!0 = "time"
;NN&time = time
;NN!1 = "level"
;NN&level = level
;NN!2 = "lat"
;NN&lat = lat
;NN!3 = "lon"
;NN&lon = lon

Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"
;Fz@units = "m^2/s^2"

;psidev@units = "m^2/s"

;NN@units = "1/s^2"

system ("rm -f "+out1)
system ("rm -f "+out2)
ncFx =     addfile (out1,"c")
ncFy =     addfile (out2,"c")
;ncFz =     addfile ("TN2001-Fz.daily.nc","c")
;ncpsidev = addfile ("psidev.daily.nc","c")
;ncNN =     addfile ("NN.daily.nc","c")

ncFx->Fx = Fx
ncFy->Fy = Fy
;ncFz->Fz = Fz
;ncpsidev->psidev = psidev

;ncNN->NN = NN

delete ([/Cp_x,Cp_y,nt,leveltmp,coslattmp,ftmp,NN,cumag,Cpxtmp,Cpytmp,Cp,psidev,psiclm,xuterm,xvterm,yvterm,Mvar,Fx,Fy/])

end do

end

