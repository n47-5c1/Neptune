;*************************************************************
;Aim: Draw composite life cycles phase of Afro-Eurasian daily anomalous stream function deviations from zonal mean with 10-30-day bandpass filters and
;     daily anomalous 2m air temperature and precipitation derived by PC1 and PC2
;Mission:
;
;   1. Read data from UV, olr and TS  datasets
;   2. Post-post process to deserved results
;   3. Draw the phase
;                       He Shan
;                       2016-11-24
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
;   var3--------------olr
;   var4--------------air
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/daily/"
    in      = "~/data/observation/NOAA-OLR/Daily_CDR/olr.day.mean.nc"
    nPhase  = 4
    r2d     = 180./(4.*atan(1.0))

;time
    yE     = 2012

;regiion
    latN = 60
    latS = 0
    lonW = -40
    lonE = 150

;fig
    out_path  = "~/hes/One_Belt_One_Road/Fig/"
    out_name1 = "phase_Afro-Eurasian_daily_anom_x_t_sf_BP_OLR_anom_t_PC12"
    out_name2 = "phase_Afro-Eurasian_daily_anom_x_t_sf_BP_TS_anom_t_PC12"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis 2
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    TS_files = systemfunc ("ls "+in_path+"air.2m/air.2m.gauss.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files

;NOAA-Daily CDR 1979-2012
    OLR_in = addfile (in,"r")

    f = addfile ("./PC_square_Index.nc", "r")

    U_in  = addfiles (U_files,"r")                ;note the "s" of addfile
    V_in  = addfiles (V_files,"r")
    TS_in = addfiles (TS_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
    ListSetType (TS_in, "cat")

;----------------------------------------------------------
    TIME  = U_in[:]->time
    YYYY  = cd_calendar (TIME,0)       ;for original data
    year  = toint (YYYY(:,0))
    month = toint (YYYY(:,1))
    day   = toint (YYYY(:,2))

;get the time indexs
    iYYYY = ind (year.le.yE)
    printVarSummary (iYYYY)

;create required yyyyddd
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year(iYYYY)*1000 + ddd(iYYYY)
    printVarSummary (yyyyddd)

;----------------------------------------------------------
;    U   = V_file->hgt(:,2,:,:)                ;850hPa
;    U   = V_file->hgt(:,5,:,:)                ;500hPa
    U   = short2flt (U_in[:]->uwnd(iYYYY,8,::-1,:))           ;250hPa
    V   = short2flt (V_in[:]->vwnd(iYYYY,8,::-1,:))           ;250hPa
    OLR = OLR_in->olr
    TS  = short2flt(TS_in[:]->air(iYYYY,0,:,:))

    pc1   = f->PC1(iYYYY)
    pc2   = f->PC2(iYYYY)
    index = f->INDEX(iYYYY)

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (OLR)
    printVarSummary (TS)
    printVarSummary (pc1)
    printVarSummary (pc2)
    printVarSummary (index)

;----------------------------------------------------------
; create the filter weights
    nwt = 61
    fca = 1./30.
    fcb = 1./10.
    ihp = 2          
    nsigma = 1.
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)   ; 10-30 day

;----------------------------------------------------------
;Phase
    angBnd      = new ( (/2,nPhase/), "float")
    angBnd(0,:) = fspan (0,360-360/nPhase,nPhase)
    angBnd(1,:) = fspan (360/nPhase,360,nPhase)

    ang     = atan2(pc2,pc1)*r2d     ;phase space 
    nn      = ind(ang.lt.0)
    ang(nn) = ang(nn) + 360          ;make 0 to 360
    copy_VarCoords(pc1,ang)
    printVarSummary (ang)
;    print(pc1(:19)+"  "+pc2(:19)+"  "+ang(:19))

    nDays  = new (nPhase, "integer")
    pLabel = "P" + ispan(1,nPhase,1) + ": "

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;Deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
   sfClmDay = clmDayTLL (sf_xAnom, yyyyddd)
   sf_tAnom = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   printVarSummary(sf_tAnom)
   OLRClmDay  = clmDayTLL (OLR, yyyyddd)
   OLR_tAnom  = calcDayAnomTLL (OLR, yyyyddd, OLRClmDay)
   printVarSummary(OLR_tAnom)
   TSClmDay = clmDayTLL (TS, yyyyddd)
   TS_tAnom = calcDayAnomTLL (TS, yyyyddd, TSClmDay)
   printVarSummary(sf_tAnom)

;Filter
   sfAnom_BP_p = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP   = sfAnom_BP_p (time|:,lat|:,lon|:)
   printVarSummary (sfAnom_BP)

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks1  = gsn_open_wks ("svg",out_path+out_name1)   ;open a svg file
 plot1 = new (nPhase,graphic)                      ;creat a plot array
 wks2  = gsn_open_wks ("svg",out_path+out_name2)
 plot2 = new (nPhase,graphic)

;*******************************************
;  plot phase
;*******************************************
res = True

res@gsnDraw  = False      ;don't draw
res@gsnFrame = False      ;don't advance frame
;res@gsnPolar = "NH"
;res@gsnPolarLabelFontHeightF = .025

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False        ;turn off cn line labels
res@cnFillPalette  = "MPL_coolwarm"

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

;----------------------------------------------------------
ores = True

ores@gsnDraw       = False
ores@gsnFrame      = False
ores@gsnAddCyclic  = True
ores@gsnLeftString = " "
ores@gsnContourZeroLineThicknessF = 0
ores@gsnContourNegLineDashPattern = 1
ores@gsnContourLineThicknessesScale = 2

ores@cnLevelSelectionMode = "ExplicitLevels"
ores@cnLevels             = ispan(-6,6,2 )
ores@cnLineLabelsOn       = False
ores@cnInfoLabelFontHeightF    = 0.014
ores@cnInfoLabelOrthogonalPosF = 0.25   ;move informational label down

;*******************************************
do i = 0,nPhase-1
 na = i+nPhase/2             ;temporary adjustment for 0 <= ang < 360/nPhase represents phase nPhase/2+1 not MJO phase 1 
 if(na.gt.nPhase-1) then
  na = na - nPhase
 end if

 nt        = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i))
 sfAvg     = dim_avg_Wrap ( sfAnom_BP(lat|:,lon|:,time|nt) )
 OLRAvg    = dim_avg_Wrap ( OLR_tAnom(lat|:,lon|:,time|nt) )
 TSAvg     = dim_avg_Wrap ( TS_tAnom(lat|:,lon|:,time|nt) )
 nDays(na) = dimsizes (nt)

;----------------------------------------------------------
;draw OLR
 res@gsnLeftString   = text1(na)
 res@gsnCenterString = pLabel(na) + nDays(na)
 if (na.eq.1 ) then 
  res@gsnRightString = "W/m^2"
;  res@gsnRightString = OLR@units
 else if (na.eq.0) then
  res@gsnRightString = "10^6"
 else
  res@gsnRightString = " "
 end if
 end if

;to have a common label bar
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels             = (/-6.,-4.,-2.,2.,4.,6./)

 if (na.ge.3) then
  res@tmXBLabelsOn = True    ;draw lon labels
 else
  res@tmXBLabelsOn = False   ;do not draw lon labels
 end if
/;
 if (mod(na,2).eq.0 ) then
  res@tmYLLabelsOn = True    ;draw lat labels
 else
  res@tmYLLabelsOn = False   ;do not draw lat labels
 end if
;/
 plot1(na) = gsn_csm_contour_map (wks1,OLRAvg,res)

;----------------------------------------------------------
;draw TS
 if (na.eq.1 ) then 
  res@gsnRightString = "deg C"
 else if (na.eq.0) then
  res@gsnRightString = "10^6"
 else
  res@gsnRightString = " "
 end if
 end if

 res@cnLevels = (/-1.2,-.8,-.4,.4,.8,1.2/)

 plot2(na) = gsn_csm_contour_map (wks2,TSAvg,res)

;----------------------------------------------------------
;draw sf
 if(na.eq.3)
  ores@cnInfoLabelOn = True
 else
  ores@cnInfoLabelOn = False
 end if
 plot_ov1 = gsn_csm_contour (wks1,sfAvg,ores)
 plot_ov2 = gsn_csm_contour (wks2,sfAvg,ores)

 overlay(plot1(na),plot_ov1)
 overlay(plot2(na),plot_ov2)

 delete([/nt,plot_ov1,plot_ov2/])      ;will change next iteration
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Life Cycles of 250 hPa Daily SF and OLR Anomalies"   ;add common title
resP@gsnPanelBottom           = 0.06
resP@gsnPanelLabelBar         = True    ;add common colorbar
resP@lbLabelFontHeightF       = 0.015
resP@pmLabelBarOrthogonalPosF = -0.008    ;move Label Bar down
gsn_panel(wks1,plot1,(/4,1/),resP)

resP@txString = "Life Cycles of 250 hPa Daily SF and Ts Anomalies"
gsn_panel(wks2,plot2,(/4,1/),resP)

end
