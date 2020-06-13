;*************************************************************
;Aim: Draw the wavelet of TP meteorological elements
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the wavelet
;                       He Shan
;                       2017-05-23
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var3--------------hgt
;   var4--------------air
;   var5--------------olr
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/daily/"

;time
;    yE = 2012

;regiion
    lat = 25
;    lat = 30
;    lat = 35
    lon = 95
;    lon = 60
;    lon = 30
;    lon = 1

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "wavelet_reg_elements"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)
    text2 = (/"250 hPa sf","250 hPa vwnd","250 hPa hgt","2 m air"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis 2
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    H_files  = systemfunc ("ls "+in_path+"hgt/hgt.*.nc")
    TS_files = systemfunc ("ls "+in_path+"air.2m/air.2m.gauss.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files

    U_in  = addfiles (U_files,"r")                ;note the "s" of addfile
    V_in  = addfiles (V_files,"r")
    H_in  = addfiles (H_files,"r")
    TS_in = addfiles (TS_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
    ListSetType (TS_in, "cat")

;----------------------------------------------------------
    TIME    = U_in[:]->time
    YYYY    = cd_calendar (TIME,0)       ;for original data
    year    = toint (YYYY(:,0))
    month   = toint (YYYY(:,1))
    day     = toint (YYYY(:,2))

;get the time indexs
;    iYYYY = ind (year.le.yE)
;    printVarSummary (iYYYY)

;create required yyyyddd
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd
    N       = dimsizes (yyyyddd)
    printVarSummary (yyyyddd)

;----------------------------------------------------------
;    U   = short2flt (U_in[:]->uwnd(:,2,:,:))   ;850hPa
;    U   = short2flt (U_in[:]->uwnd(:,5,:,:))   ;500hPa
    U   = short2flt (U_in[:]->uwnd(:,8,::-1,:))   ;250hPa
    V   = short2flt (V_in[:]->vwnd(:,8,::-1,:))
    H   = short2flt (H_in[:]->hgt(:,8,:,:))
    TS  = short2flt (TS_in[:]->air(:,0,{lat:lat},{lon:lon}))

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (H)
    printVarSummary (TS)

;----------------------------------------------------------
;wavelet
    mother   = 0
    dt       = 1.    ;timesteps in units of days
    param    = 6.
    s0       = dt
    dj       = 0.25
    jtot     = 1+toint(((log10(N*dt/s0))/dj)/log10(2.))
    npad     = N
    noise    = 1
    isigtest = 0
    siglvl   = .05
    nadof    = 0

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;calculate deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   H_xAnom  = dim_rmvmean_Wrap (H)
   printVarSummary (sf_xAnom)

;Daily anomalies
    sfclm  = clmDayTLL (sf_xAnom,yyyyddd)
    Vclm   = clmDayTLL (V,       yyyyddd)
    Hclm   = clmDayTLL (H_xAnom, yyyyddd)
    TSclm  = clmDayTLL (TS,      yyyyddd)

    sf_tAnom  = calcDayAnomTLL (sf_xAnom,yyyyddd,sfclm)
    V_tAnom   = calcDayAnomTLL (V,       yyyyddd,Vclm)
    H_tAnom   = calcDayAnomTLL (H_xAnom, yyyyddd,Hclm)
    TS_tAnom  = calcDayAnomTLL (TS,      yyyyddd,TSclm)
    printVarSummary(V_tAnom)

;----------------------------------------------------------
;calculate wavelet
    w1 = wavelet (sf_tAnom(:,{lat},{lon}), mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
    w2 = wavelet (V_tAnom(:,{lat},{lon}),  mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
    w3 = wavelet (H_tAnom(:,{lat},{lon}),  mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
    w4 = wavelet (TS_tAnom(:,0,0), mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)

    printVarSummary (w1)

; ==============================================================
; Mission 3. Draw the wavelet
; ==============================================================

;create coodinate arrays for plot
  time = fspan (1979,2015,N)

  power           = onedtond(w1@power,(/jtot,N/))
  power!0         = "period"       ; Y axis
  power&period    = w1@period      ; convert period to units of days
  power!1         = "time"         ; X axis
  power&time      = time
  power@long_name = "Power Spectrum"
  power@units     = "1/unit-freq"

;compute significance ( >= 1 is significant)
  SIG           = power
  SIG           = power/conform (power,w1@signif,0)
  SIG@long_name = "Significance"
  SIG@units     = " "

;-----------------------------------------------------------------------------
;initial resource settings
 wks  = gsn_open_wks ("svg",out_path+out_name)
 plot = new(4,graphic)

;----------------------------------------------------------
res = True

res@gsnDraw              = False
res@gsnFrame             = False
res@gsnStringFontHeightF = 0.021

res@vpHeightF = 0.23
res@vpWidthF  = 1.

res@cnFillOn             = True
res@cnFillPalette        = "gsltod"           ; set color map
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/1./)

res@lbLabelBarOn = False

res@trYReverse = True      ;reverse y-axis

res@tiYAxisString      = "Period (days)"
res@tiYAxisFontHeightF = 0.02

res@tmYLMode             = "Explicit"
res@tmYLValues           = (/1,2,4,8,16,32,64,128,365,730,1460/)
res@tmYLLabels           = "" + res@tmYLValues
res@tmLabelAutoStride    = True
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@gsnLeftString   = text1(0)
res@gsnCenterString = "0.05 level, "+lon+"E "+lat+"N"  
res@gsnRightString  = text2(0)
res@tmXBLabelsOn    = False   ;do not draw x labels
plot(0) = gsn_csm_contour(wks,SIG,res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = text2(1)
power   = onedtond(w2@power,(/jtot,N/))
SIG     = power/conform (power,w2@signif,0)
plot(1) = gsn_csm_contour(wks,SIG,res)

res@gsnLeftString   = text1(2)
res@gsnRightString  = text2(2)
power   = onedtond(w3@power,(/jtot,N/))
SIG     = power/conform (power,w3@signif,0)  
plot(2) = gsn_csm_contour(wks,SIG,res)

res@gsnLeftString   = text1(3)
res@gsnRightString  = text2(3)
res@tmXBLabelsOn    = True    ;draw x labels
power   = onedtond(w4@power,(/jtot,N/))
SIG     = power/conform (power,w4@signif,0)
plot(3) = gsn_csm_contour(wks,SIG,res)

/;
;----------------------------------------------------------
;Probability plots
res2 = True

res2@gsnDraw       = False
res2@gsnFrame      = False
res2@gsnLeftString = " "

res2@cnInfoLabelOn       = False
res2@cnLinesOn           = False
res2@cnLineLabelsOn      = False 
res2@cnLevelSelectionMode = "ManualLevels"
res2@cnMinLevelValF      = 0.00
res2@cnMaxLevelValF      = 2.00
res2@cnLevelSpacingF     = 1.00

res2@trYReverse          = True

res2@tmYLMode            = "Explicit"
res2@tmYLValues          = (/1,2,4,8,16,32,64,128/)
res2@tmYLLabels          = "" + res2@tmYLValues

iplot = gsn_csm_contour(wks,SIG,res2)

opt = True

opt@gsnShadeHigh     = 6           ; cross hatch pattern
opt@gsnShadeFillType = "pattern"

iplot = gsn_contour_shade (iplot, 0, 0.8, opt)

overlay (plot(0),iplot)
;/

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString                 = "Wavelet of Meteorological Elements"
resP@gsnPanelBottom           = 0.035
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.015
resP@pmLabelBarWidthF         = 0.4
resP@pmLabelBarOrthogonalPosF = -0.014    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
