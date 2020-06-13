;*************************************************************
;Aim: Distinguish EP- and CP-ENSO by Yu et al. 2012
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output data
;                       Shan He
;                       2018-09-21
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;data
;    in_path = "~/data/observation/SST/HadISST/HadISST_sst.nc"
    in_path = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v4.nc"

;time
    yS = 1958
;    yE = 2017
    yE = 2015
    season = "DJF"
;    yEl = (/1958,1963,1965,1968,1969,1972,1976,1977,1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015/)
;    yLa = (/1964,1970,1971,1974,1975,1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011,2016/)
    yEl = (/1958,1963,1965,1968,1969,1972,1976,1977,1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014/)
    yLa = (/1964,1970,1971,1974,1975,1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011/)
    ny1 = dimsizes(yEl)
    ny2 = dimsizes(yLa)

;Nino1+2
    latN1 = 0
    latS1 = -10
    lonW1 = 270
    lonE1 = 280

;Nino3
    latN2 = 5
    latS2 = -5
    lonW2 = 210
    lonE2 = 270

;Nino4
    latN3 = 5
    latS3 = -5
    lonW3 = 160
    lonE3 = 210

;EMI
    latNA = 10
    latSA = -10
    lonWA = 165
    lonEA = 220

    latNB = 5
    latSB = -15
    lonWB = 250
    lonEB = 290

    latNC = 20
    latSC = -10
    lonWC = 125
    lonEC = 145

;EOF
    latN = 20
    latS = -20
    lonW = 120
    lonE = 290;280
    neof = 1
    optEOF = False
    optETS = False

;outcome
;    out_path  = "~/hes/ENSO/Fig/"
;    out_data  = "./pattern_cor_EOF1_g_EP_CP_ENSO.nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_path,"r")
    time = in->time

;get the time indexs
    year_p = cd_calendar(time,-1) / 100
    iYYYY = ind (year_p.ge.yS .and. year_p.le.yE)
    year = year_p(iYYYY)
i7100 = ind(year.ge.1971 .and. year.le.2000)

    El = year(::12) .eq. yEl(0) + 1
    do i = 1, ny1 - 1
     El = El .or. year(::12) .eq. yEl(i) + 1
    end do
    iEl = ind(El)

    La = year(::12) .eq. yLa(0) + 1
    do i = 1, ny2 - 1
     La = La .or. year(::12) .eq. yLa(i) + 1
    end do
    iLa = ind(La)

;-------------------------------------------------------------
;    sst_p = lonFlip(in->sst)
    sst_p = in->sst
    sst = sst_p(iYYYY,{latN:latS},{lonW:lonE})

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad = 4. * atan(1.) / 180.

;    gw = in->latitude({latN:latS})
;    clat = in->latitude({latN:latS})
    gw = in->lat({latN:latS})
    clat = in->lat({latN:latS})
    gw = cos(rad * gw)
    clat = sqrt(cos(rad * clat))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm = clmMonTLL(sst(i7100,:,:))
   SSTA = calcMonAnomTLL(sst, clm)

;-------------------------------------------------------------
print("EP/CP-index method (Kao and Yu 2009)")
;subtract values regressed with series
   Nino12 = wgt_areaave_Wrap(SSTA(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 
   Nino4 = wgt_areaave_Wrap(SSTA(:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)

   rc = regCoef_n(Nino4, SSTA, 0, 0)
   sst_EP = SSTA - conform(SSTA, rc, (/1,2/)) * conform(SSTA, Nino4, 0)
   copy_VarMeta(SSTA, sst_EP)

   rc = regCoef_n(Nino12, SSTA, 0, 0)
   sst_CP = SSTA - conform(SSTA, rc, (/1,2/)) * conform(SSTA, Nino12, 0)
   copy_VarMeta(SSTA, sst_CP)

;EOF
    y = sst_EP * conform(sst, clat, 1)
    copy_VarMeta(sst, y)
    eof_EP = eofunc_n_Wrap(y, neof, optEOF, 0)
    eof_ts_EP = eofunc_ts_n_Wrap(y, eof_EP, optETS, 0)
    eof_ts_EP = (/-eof_ts_EP/)

    y = sst_CP * conform(sst, clat, 1)
    eof_CP = eofunc_n_Wrap(y, neof, optEOF, 0)
    eof_ts_CP = eofunc_ts_n_Wrap(y, eof_CP, optETS, 0)
    eof_ts_CP = (/-eof_ts_CP/)

;normalize time series
;    eof_ts_EP = dim_standardize_n (eof_ts_EP,0,1)
;    eof_ts_CP = dim_standardize_n (eof_ts_CP,0,1)

    EP1 = month_to_season(eof_ts_EP(0,:), season)
    CP1 = month_to_season(eof_ts_CP(0,:), season)

    a1 = where(EP1(iEl) .gt. CP1(iEl), "EP", "CP")
    a2 = where(EP1(iLa) .lt. CP1(iLa), "EP", "CP")

;-------------------------------------------------------------
print("Niño method (Yeh et al. 2009)")
    Nino3 = wgt_areaave_Wrap(SSTA(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

    EP2 = month_to_season(Nino3, season)
    CP2 = month_to_season(Nino4, season)

    b1 = where(EP2(iEl) .gt. CP2(iEl), "EP", "CP")
    b2 = where(EP2(iLa) .lt. CP2(iLa), "EP", "CP")

;-------------------------------------------------------------
print("EMI method (Ashok et al. 2007)")
    EMI = wgt_areaave_Wrap(SSTA(:,{latNA:latSA},{lonWA:lonEA}), gw({latNA:latSA}), 1., 0)
    EMI = (/EMI - 0.5 * wgt_areaave_Wrap(SSTA(:,{latNB:latSB},{lonWB:lonEB}), gw({latNB:latSB}), 1., 0) - \
            0.5 * wgt_areaave_Wrap(SSTA(:,{latNC:latSC},{lonWC:lonEC}), gw({latNC:latSC}), 1., 0)/)

    CP3 = month_to_season(EMI, season)
    std = stddev(CP3)

    c1 = where(CP3(iEl) .ge. 0.7 * std, "CP", "EP")
    c2 = where(CP3(iLa) .le. -0.7 * std, "CP", "EP")

;-------------------------------------------------------------
do i = 0, ny1-1
    print((/yEl(i)+" "+a1(i)+" "+b1(i)+" "+c1(i)/))
end do
do i = 0, ny2-1
    print((/yLa(i)+" "+a2(i)+" "+b2(i)+" "+c2(i)/))
end do

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
/;
dim = dimsizes (r)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"a","b"/)  
dimSizes = (/dim(0),dim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"a","integer","a")
filevardef (fout,"b","integer","b")
filevardef (fout,"r",typeof(r),getvardims(r))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"env", )
;filevarattdef (fout,"time",time)
filevarattdef (fout,"r",   r)

;output only the data values
fout->env  = (/0,1/)
fout->time = ispan(1,46,1)
fout->r    = (/r/)
;/
end
