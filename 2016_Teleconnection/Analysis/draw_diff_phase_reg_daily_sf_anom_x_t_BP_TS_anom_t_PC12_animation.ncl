;*************************************************************
;Aim: Draw difference between El Nino years and normal years in composite life cycles phase of Afro-Eurasian daily anomalous stream function deviations from zonal mean with 10-30-day
;     bandpass filters and daily anomalous 2m air temperature derived by PC1 and PC2 for animations
;Mission:
;
;   1. Read data from UV, T, PC12 and index  datasets
;   2. Post-post process to deserved results
;   3. Draw the difference
;                       He Shan
;                       2017-05-18
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
;   var3--------------air
;   var4--------------PC1
;   var5--------------PC2
;   var6--------------INDEX
;================================================

;data
    in_path = "~/data/observation/NCEP_DOE/daily/"
    nPhase  = 16
    r2d     = 180./(4.*atan(1.0))

;time
    mS  = 7
    yS1 = (/1987,1991,1994,2002,2004,2009,2015/)
;    yS1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2015/)
    ny1 = dimsizes (yS1)

;regiion
;    latN = 85
;    latS = 0
;    lonW = -40
;    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/Animation/"
    out_name = "diff_phase_Afro-Eurasian_daily_anom_x_t_sf_BP_TS_anom_t_PC12_"

;text
    text1 = (/"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis 2
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    TS_files = systemfunc ("ls "+in_path+"air.2m/air.2m.gauss.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in  = addfiles (U_files,"r")
    V_in  = addfiles (V_files,"r")
    TS_in = addfiles (TS_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
    ListSetType (TS_in, "cat")
;    U      = V_file->hgt(:,2,:,:)                ;850hPa
;    U      = V_file->hgt(:,5,:,:)                ;500hPa
    U    = short2flt (U_in[:]->uwnd(:,8,::-1,:))           ;250hPa
    V    = short2flt (V_in[:]->vwnd(:,8,::-1,:))           ;250hPa
    TS   = short2flt(TS_in[:]->air(:,0,:,:))
    TIME = U_in[:]->time

    f     = addfile ("./PC_Index.nc", "r")
    pc1   = f->PC1
    pc2   = f->PC2
    index = f->INDEX

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TS)
    printVarSummary (TIME)
    printVarSummary (pc1)
    printVarSummary (pc2)
    printVarSummary (index)

;----------------------------------------------------------
;create required yyyyddd
    YYYY    = cd_calendar (TIME,0)       ;for original data
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))
    day     = floattointeger (YYYY(:,2))
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd            ;needed for input
    printVarSummary (yyyyddd)

;get the time indexs
    El = (year.eq.yS1(0) .and. month.ge.mS .or. year.eq.yS1(0)+1 .and. month.lt.mS)
    do i=1,ny1-1
     El = El.or.(year.eq.yS1(i) .and. month.ge.mS .or. year.eq.yS1(i)+1 .and. month.lt.mS)
    end do
    iEl = ind (El)

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
    angBnd(0,:) = fspan (-360/nPhase,360-360/nPhase*2,nPhase)
    angBnd(1,:) = fspan (360/nPhase*2,360+360/nPhase,nPhase)

    ang     = atan2(pc2,pc1)*r2d     ;phase space 
    nn      = ind(ang.lt.0)
    ang(nn) = ang(nn) + 360          ;make 0 to 360
    copy_VarCoords(pc1,ang)
    printVarSummary (ang)
;    print(pc1(:19)+"  "+pc2(:19)+"  "+ang(:19))

    nDays1 = new (nPhase, "integer")
    nDays2 = new (nPhase, "integer")
    pLabel = "P" + ispan(1,nPhase,1) + ": "

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Stream function
   sfvp = uv2sfvpG (U,V)
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
   TSClmDay1 = clmDayTLL (TS, yyyyddd)
   TS_tAnom1 = calcDayAnomTLL (TS, yyyyddd, TSClmDay1)
   TSClmDay2 = clmDayTLL (TS(iEl,:,:), yyyyddd(iEl))   ;2 for El Nino years
   TS_tAnom2 = calcDayAnomTLL (TS, yyyyddd, TSClmDay2)
   printVarSummary(TS_tAnom1)

;Filter
   sfAnom_BP_p = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP   = sfAnom_BP_p (time|:,lat|:,lon|:)
   printVarSummary (sfAnom_BP)

   diff_sf = sfAnom_BP(0,:,:)
   diff_TS = TS_tAnom1(0,:,:)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw                  = False
res@gsnFrame                 = False
res@gsnPolar                 = "NH"
res@gsnLeftString            = "deg C"
res@gsnRightString           = "10^6"
res@gsnStringFontHeightF     = .015
res@gsnPolarLabelSpacing     = 45
res@gsnPolarLabelDistance    = 1.06
res@gsnPolarLabelFontHeightF = .015

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "CBR_coldhot"
;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -2.4
res@cnMaxLevelValF       = 2.4
res@cnLevelSpacingF      = 0.6
;res@cnMinLevelValF       = -1.2
;res@cnMaxLevelValF       = 1.2
;res@cnLevelSpacingF      = 0.3

res@pmLabelBarOrthogonalPosF = 0.02    ;move Label Bar down
res@lbLabelFontHeightF       = 0.015

res@tiMainString      = "Difference in Life cycles of 250 hPa daily SF and TS anomalies"
res@tiMainFontHeightF = 0.021

res@mpFillOn               = False
res@mpCenterLonF           = 90
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

;----------------------------------------------------------
ores = True

ores@gsnDraw                      = False
ores@gsnFrame                     = False
ores@gsnLeftString                = " "
ores@gsnContourZeroLineThicknessF = 3
ores@gsnContourNegLineDashPattern = 1

ores@cnLevelSelectionMode = "ExplicitLevels"
ores@cnLevels             = fspan(-2.4,2.4,7 )
ores@cnLineLabelsOn       = False

;----------------------------------------------------------
do i = 0,nPhase-1

 na = i + nPhase/2             ;temporary adjustment for 0 <= ang < 45 represents MJO phase 5 not MJO phase 1 
 if(na.gt.nPhase-1) then
  na = na - nPhase
 end if

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(na))

 nt1        = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i))
 nt2        = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. El)
 sfAvg1     = dim_avg_Wrap ( sfAnom_BP(lat|:,lon|:,time|nt1) )
 TSAvg1     = dim_avg_Wrap ( TS_tAnom1(lat|:,lon|:,time|nt1) )
 sfAvg2     = dim_avg_Wrap ( sfAnom_BP(lat|:,lon|:,time|nt2) )
 TSAvg2     = dim_avg_Wrap ( TS_tAnom2(lat|:,lon|:,time|nt2) )
 nDays1(na) = dimsizes (nt1)
 nDays2(na) = dimsizes (nt2)

 diff_sf = sfAvg2-sfAvg1
 diff_TS = TSAvg2-TSAvg1

;----------------------------------------------------------
;draw TS
 res@gsnCenterString = pLabel(na) + nDays1(na) + " and " + nDays2(na)

 plot = gsn_csm_contour_map (wks,diff_sf,res)
; plot = gsn_csm_contour_map (wks,diff_TS,res)

;----------------------------------------------------------
;draw sf
 plot_ov = gsn_csm_contour (wks,diff_sf,ores)
; overlay(plot,plot_ov)

 draw (plot)
 frame (wks)

 delete([/wks,nt1,nt2,plot,plot_ov/])      ;will change next iteration
end do

end
