;*************************************************************
;Aim: Draw correlation between JAS global SST and Sahel region mean rainfall
;Mission:
;
;   1. Read data from SST and PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2016-11-17
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------prate
;   var2--------------precip
;================================================

;time
    yS = 1950
    yE = 2010
;    yE = 1981
    season = "JAS"      ;choose seasonal mean

;SAWPSM
    latN1 = 30.
    latS1 = -10.
    lonL1 = 70.
    lonR1 = 150.

;Sahel
    latN2 = 20
    latS2 = 10
    lonL2 = -20
    lonR2 = 40

;data
    prec2lh  = 2.5*10^6   ;2.5*10^6J/Kg * Kg/m^2/s -> W/m^2
    out_path = "~/hes/Sahel_Rainfall/final/"
    out_name = "corel_annual_decadal_JAS_regMean_SAWPSM_LH_VS_Sahel_PREC"

;the filter
    nwt    = 19
    fca    = 1./9.
    ihph   = 1      ;high pass
    ihpl   = 0      ;low pass
    nsigma = 1.

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    PRATE_file = addfile ("~/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc","r")
;PREC 1948-01~2012-01
    PREC_file = addfile ("~/data/observation/PRECPT/precip-land.mon.mean.0.5x0.5.nc","r")

    PRATE  = PRATE_file->prate(:,{latS1:latN1},{lonL1:lonR1})
    PREC_p = PREC_file->precip(:,{latS2:latN2},:)
    PREC_p = lonFlip (PREC_p)      ;Sahel rainfall
    PREC   = PREC_p(:,:,{lonL2:lonR2})
    printVarSummary (PRATE)
    printVarSummary (PREC)

;---------------------------------------------------------------
;get the time indexs
    TIME1 = PRATE_file->time
    TIME2 = PREC_file->time

    YYYY_1  = cd_calendar (TIME1,-1)/100
    iYYYY_1 = ind (YYYY_1.ge.yS .and. YYYY_1.le.yE)
    YYYY_2  = cd_calendar (TIME2,-1)/100
    iYYYY_2 = ind (YYYY_2.ge.yS .and. YYYY_2.le.yE)

;creat weights: cos(lat)
    rad1  = 4.*atan(1.)/180.
    gw1 = PRATE_file->lat({latS1:latN1})
    gw1 = cos (rad1*gw1)

    rad2  = 4.*atan(1.)/180.
    gw2 = PREC_file->lat({latS2:latN2})
    gw2 = cos (rad2*gw2)

    printVarSummary (gw1)
    printVarSummary (gw2)

; create the filter weights
    wtsh = filwgts_lanczos (nwt, ihph, fca, 999, nsigma)
    wtsl = filwgts_lanczos (nwt, ihpl, fca, 999, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   LH_JAS_reg   = month_to_season ( wgt_areaave_Wrap ( PRATE(iYYYY_1,:,:) ,gw1,1.,0) ,season)
   PREC_JAS_reg = month_to_season ( wgt_areaave_Wrap ( PREC(iYYYY_2,:,:) ,gw2,1.,0) ,season)
   LH_JAS_reg   = prec2lh * LH_JAS_reg
   dim          = dimsizes (LH_JAS_reg)
   printVarSummary (LH_JAS_reg)

;Filters
   LH_HPF   = wgt_runave_Wrap (LH_JAS_reg,wtsh,0)
   LH_LPF   = wgt_runave_Wrap (LH_JAS_reg,wtsl,0)
   PREC_HPF = wgt_runave_Wrap (PREC_JAS_reg,wtsh,0)
   PREC_LPF = wgt_runave_Wrap (PREC_JAS_reg,wtsl,0)

;compute the correlation
   rh = escorc (LH_HPF,PREC_HPF)
   rl = escorc (LH_LPF,PREC_LPF)
   print (rh)
   print (rl)

;determine the statistical significance
   probh = rtest (rh,dim,0)
   probl = rtest (rl,dim,0)
   print (probh)
   print (probl)

exit
; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)  ; open a ps file
 plot = new(2,graphic)       ;creat a plot array
 gsn_define_colormap(wks,"MPL_RdBu") ; choose a colormap

end
