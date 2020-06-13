;*************************************************************
;Aim: Draw difference between El Nino and La Nina years in composite life cycles phase of Afro-Eurasian daily anomalous stream function deviations
;     from zonal mean with 10-30-day bandpass filters and daily anomalous 2m air temperature derived by PC1 and PC2
;Mission:
;
;   1. Read data from UV, T, PC12 and index  datasets
;   2. Post-post process to deserved results
;   3. Draw the phase
;                       He Shan
;                       2017-05-14
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
    nPhase  = 4
    r2d     = 180./(4.*atan(1.0))

;time
    mS  = 7
    yS1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2015/)
    yS2 = (/1983,1984,1988,1995,1998,1999,2000,2007,2010,2011/)   ;2016!
    ny1 = dimsizes (yS1)
    ny2 = dimsizes (yS2)

;regiion
;    latN = 85
;    latS = 0
;    lonW = -40
;    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "diff_phase_Afro-Eurasian_daily_anom_x_t_sf_BP_TS_anom_t_PC12"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)
    text2 = (/"El Nino","El Nino - La Nina"/)
    text3 = (/"El Nino: "," La Nina: "/)

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

    La = (year.eq.yS2(0) .and. month.ge.mS .or. year.eq.yS2(0)+1 .and. month.lt.mS)
    do i=1,ny2-1
     La = La.or.(year.eq.yS2(i) .and. month.ge.mS .or. year.eq.yS2(i)+1 .and. month.lt.mS)
    end do

    iEl = ind (El)
    iLa = ind (La)
    printVarSummary (iEl)

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

    nDays1 = new (nPhase, "integer")
    nDays2 = new (nPhase, "integer")
    pLabel = "P" + ispan(1,nPhase,1)

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
   TSClmDay1 = clmDayTLL (TS(iEl,:,:), yyyyddd(iEl))
   TS_tAnom1 = calcDayAnomTLL (TS, yyyyddd, TSClmDay1)
   TSClmDay2 = clmDayTLL (TS(iLa,:,:), yyyyddd(iLa))
   TS_tAnom2 = calcDayAnomTLL (TS, yyyyddd, TSClmDay2)
   printVarSummary(TS_tAnom1)

;Filter
   sfAnom_BP_p = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP   = sfAnom_BP_p (time|:,lat|:,lon|:)
   printVarSummary (sfAnom_BP)

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks  = gsn_open_wks ("svg",out_path+out_name)
 plot = new (nPhase*2,graphic)

;*******************************************
;  plot phase
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnPolar = "NH"
res@gsnStringFontHeightF     = .026
res@gsnPolarLabelSpacing     = 45
res@gsnPolarLabelDistance    = 1.06
res@gsnPolarLabelFontHeightF = .026

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"

res@mpFillOn               = False
res@mpCenterLonF           = 90
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

res@lbLabelBarOn = False

;res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
;res@tmYLLabelFontHeightF = 0.02

do i = 0,nPhase-1
 na = i+nPhase/2             ;temporary adjustment for 0 <= ang < 45 represents MJO phase 5 not MJO phase 1 
 if(na.gt.nPhase-1) then
  na = na - nPhase
 end if

 nt1 = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. El)
 nt2 = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. La)

 sfAvg1 = dim_avg_Wrap ( sfAnom_BP(lat|:,lon|:,time|nt1) )
 TSAvg1 = dim_avg_Wrap ( TS_tAnom1(lat|:,lon|:,time|nt1) )
 sfAvg2 = dim_avg_Wrap ( sfAnom_BP(lat|:,lon|:,time|nt2) )
 TSAvg2 = dim_avg_Wrap ( TS_tAnom2(lat|:,lon|:,time|nt2) )

 nDays1(na) = dimsizes (nt1)
 nDays2(na) = dimsizes (nt2)

 diff1 = sfAvg1 - sfAvg2
 diff2 = TSAvg1 - TSAvg2

 if(i.eq.0) then
  copy_VarMeta (sfAvg1,diff1)
  copy_VarMeta (TSAvg1,diff2)
 end if

;----------------------------------------------------------
;draw difference
 res@gsnLeftString   = text1(na)+" "+pLabel(na)
 if (na.eq.0) then
  res@gsnCenterString = text3(0)+nDays1(na)+text3(1)+nDays2(na)
 else 
  res@gsnCenterString = nDays1(na)+" "+nDays2(na)
 end if
; if (na.eq.nPhase-1 ) then 
 if (na.eq.1 ) then 
  res@gsnRightString = "10^6"
 else
  res@gsnRightString = " "
 end if
 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF       = -1.6
 res@cnMaxLevelValF       = 1.6
 res@cnLevelSpacingF      = 0.4
 plot(na) = gsn_csm_contour_map (wks,diff1,res)

 res@gsnLeftString = text1(na+nPhase)
 if (na.eq.0) then
  res@gsnCenterString = text2(0)+", "+text2(1)
 else
  res@gsnCenterString = " "
 end if
 if (na.eq.nPhase-1 ) then 
  res@gsnRightString = "deg C"
 end if
 res@cnMinLevelValF  = -0.8
 res@cnMaxLevelValF  = 0.8
 res@cnLevelSpacingF = 0.2
 plot(na+nPhase) = gsn_csm_contour_map (wks,diff2,res)

;----------------------------------------------------------
;draw climatology
 ores = True

 ores@gsnDraw        = False
 ores@gsnFrame       = False
 ores@gsnAddCyclic   = True
 ores@gsnLeftString  = " "
 ores@gsnRightString = " "
 ores@gsnContourZeroLineThicknessF = 2
 ores@gsnContourNegLineDashPattern = 1

 ores@cnInfoLabelFontHeightF    = 0.021
 ores@cnInfoLabelOrthogonalPosF = 0.07   ;move informational label down

 if(na.eq.nPhase-1)
  ores@cnInfoLabelOn = True
 else
  ores@cnInfoLabelOn = False
 end if
 ores@cnLineLabelsOn = False

 ores@cnLevelSelectionMode = "ExplicitLevels"
 ores@cnLevels             = fspan(-6.,6.,7 )
 plot_ov1 = gsn_csm_contour (wks,sfAvg1,ores)

 ores@cnLevelSelectionMode = "ExplicitLevels"
 ores@cnLevels             = fspan(-1.2,1.2,7 )
 plot_ov2 = gsn_csm_contour (wks,TSAvg1,ores)

 overlay(plot(na),plot_ov1)
 overlay(plot(na+nPhase),plot_ov2)

 delete([/nt1,nt2,plot_ov1,plot_ov2/])      ;will change next iteration
end do

;*******************************************
;create panel resources
;*******************************************
resP1                          = True
;resP1@txString                 = "Difference in Life cycles of 250 hPa daily SF and TS anomalies"
resP1@txString                 = "Difference in Life cycles of 250 hPa daily SF anomalies"
resP1@gsnFrame                 = False
;resP1@gsnPanelBottom           = 0.64
;resP@gsnPanelRowSpec          = True     ;tell panel what order to plot
resP1@gsnPanelLabelBar         = True
resP1@lbLabelFontHeightF       = 0.017
resP1@pmLabelBarOrthogonalPosF = -0.02    ;move Label Bar down
gsn_panel (wks,plot(0:3),(/2,2/),resP1)

resP2                          = True
resP2@gsnFrame                 = False
resP2@gsnPanelTop              = 0.64
resP2@gsnPanelBottom           = 0.28
resP2@gsnPanelLabelBar         = True
resP2@lbLabelFontHeightF       = 0.011
;resP2@pmLabelBarOrthogonalPosF = -0.01
;gsn_panel (wks,plot(4:7),(/1,4/),resP2)

frame (wks)
end
