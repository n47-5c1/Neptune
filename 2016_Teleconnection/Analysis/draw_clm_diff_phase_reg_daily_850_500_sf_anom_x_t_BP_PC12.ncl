;*************************************************************
;Aim: Draw climatology of El Nino and difference between El Nino and La Nina years in composite life cycles phase of Afro-Eurasian daily anomalous 850
;     and 500 hPa stream function deviations from zonal mean with 10-30-day bandpass filters derived by PC1 and PC2
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the phase
;                       He Shan
;                       2017-05-16
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
;   var3--------------PC1
;   var4--------------PC2
;   var5--------------INDEX
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
;    latS = -60
;    lonW = -40
;    lonE = 150

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_diff_phase_Afro-Eurasian_daily_anom_x_t_850_500_sf_BP"

;text
    text1 = (/"a) 500 hPa","b)","c)","d)","e) 850 hPa","f)","g)","h)"/)
;    text2 = (/"El Nino","El Nino - La Nina"/)
;    text3 = (/"El Nino: ","La Nina: "/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
;NCEP/NCAR Reanalysis
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in  = addfiles (U_files,"r")
    V_in  = addfiles (V_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
;    U      = V_file->hgt(:,2,:,:)                ;850hPa
;    U      = V_file->hgt(:,5,:,:)                ;500hPa
;    U      = V_file->hgt(:,8,:,:)                ;250hPa
    print("wait...")
    U    = short2flt (U_in[:]->uwnd(:,(/2,5/),::-1,:))
    print("U done")
    V    = short2flt (V_in[:]->vwnd(:,(/2,5/),::-1,:))
    print("V done")
    TIME = U_in[:]->time

    f     = addfile ("./PC_square_Index.nc", "r")
    pc1   = f->PC1
    pc2   = f->PC2
    index = f->INDEX

    printVarSummary (U)
    printVarSummary (V)
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

    printVarSummary (El)

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

    nDaysE = new (nPhase, "integer")
    nDaysL = new (nPhase, "integer")
    pLabel = "P" + ispan(1,nPhase,1) + ": "

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Stream function
   sfvp = uv2sfvpF (U,V)
   sf   = sfvp(0,:,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;Deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;Daily anomalies
   sfClmDay  = clmDayTLLL (sf_xAnom, yyyyddd)
   sf_tAnom1 = calcDayAnomTLL (sf_xAnom(:,0,:,:), yyyyddd, sfClmDay(:,0,:,:))
   sf_tAnom2 = calcDayAnomTLL (sf_xAnom(:,1,:,:), yyyyddd, sfClmDay(:,1,:,:))
   printVarSummary(sf_tAnom1)

;Filter
   sfAnom_BP_p1 = wgt_runave_Wrap (sf_tAnom1(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP_p2 = wgt_runave_Wrap (sf_tAnom2(lat|:,lon|:,time|:),wts,0)
   sfAnom_BP1   = sfAnom_BP_p1 (time|:,lat|:,lon|:)
   sfAnom_BP2   = sfAnom_BP_p2 (time|:,lat|:,lon|:)
   printVarSummary (sfAnom_BP1)

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
res@gsnStringFontHeightF     = .027
res@gsnPolarLabelSpacing     = 45
res@gsnPolarLabelDistance    = 1.06
res@gsnPolarLabelFontHeightF = .025

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"

res@mpFillOn               = False      ;turn off map fill
res@mpCenterLonF           = 90
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines

res@lbLabelBarOn = False

do i = 0,nPhase-1
 na = i+nPhase/2             ;temporary adjustment for 0 <= ang < 45 represents MJO phase 5 not MJO phase 1 
 if(na.gt.nPhase-1) then
  na = na - nPhase
 end if

 ntE = ind (index.gt.1. .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. El)
 ntL = ind (index.gt.1. .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. La)

 sfAvg1E = dim_avg_Wrap ( sfAnom_BP1(lat|:,lon|:,time|ntE) )
 sfAvg2E = dim_avg_Wrap ( sfAnom_BP2(lat|:,lon|:,time|ntE) )
 sfAvg1L = dim_avg_Wrap ( sfAnom_BP1(lat|:,lon|:,time|ntL) )
 sfAvg2L = dim_avg_Wrap ( sfAnom_BP2(lat|:,lon|:,time|ntL) )

 nDaysE(na) = dimsizes (ntE)
 nDaysL(na) = dimsizes (ntL)

 diff1 = sfAvg1E - sfAvg1L
 diff2 = sfAvg2E - sfAvg2L

 if(i.eq.0) then
  copy_VarMeta (sfAvg1E,diff1)
  copy_VarMeta (sfAvg2E,diff2)
 end if

;----------------------------------------------------------
;draw difference
 res@gsnLeftString   = text1(na)
 res@gsnCenterString = pLabel(na)+nDaysE(na)+", "+nDaysL(na)
 if (na.eq.nPhase-1 ) then 
  res@gsnRightString = "10^6"
 else
  res@gsnRightString = " "
 end if
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels             = (/-1.2,-.9,-.6,-.3,.3,.6,.9,1.2/)
 plot(na) = gsn_csm_contour_map (wks,diff2,res)

 res@gsnLeftString   = text1(na+nPhase)
 res@gsnCenterString = " "
 res@gsnRightString  = " "
 res@cnLevels        = (/-.8,-.6,-.4,-.2,.2,.4,.6,.8/)
 plot(na+nPhase) = gsn_csm_contour_map (wks,diff1,res)

;----------------------------------------------------------
;draw climatology
 ores = True

 ores@gsnDraw       = False
 ores@gsnFrame      = False
 ores@gsnAddCyclic  = True
 ores@gsnLeftString = " "
 ores@gsnContourZeroLineThicknessF   = 0
 ores@gsnContourNegLineDashPattern   = 14
 ores@gsnContourLineThicknessesScale = 1.8

 ores@cnInfoLabelFontHeightF    = 0.021
 ores@cnInfoLabelOrthogonalPosF = 0.07   ;move informational label down

 if(na.eq.nPhase-1)
  ores@cnInfoLabelOn = True
 else
  ores@cnInfoLabelOn = False
 end if
 ores@cnLineLabelsOn = False

 ores@cnLevelSelectionMode = "ExplicitLevels"
 ores@cnLevels             = fspan(-2.4,2.4,7 )
 plot_ov1 = gsn_csm_contour (wks,sfAvg2E,ores)

 ores@cnLevelSelectionMode = "ExplicitLevels"
 ores@cnLevels             = fspan(-1.5,1.5,7 )
 plot_ov2 = gsn_csm_contour (wks,sfAvg1E,ores)

 overlay(plot(na),plot_ov1)
 overlay(plot(na+nPhase),plot_ov2)

 delete([/ntE,ntL,plot_ov1,plot_ov2/])      ;will change next iteration
end do

;*******************************************
;create panel resources
;*******************************************
resP1                          = True
resP1@txString                 = "Composites and Difference in Life Cycles of 850 and 500 hPa Daily SF Anomalies"   ;add common title
resP1@gsnFrame                 = False
resP1@gsnPanelBottom           = 0.7
resP1@gsnPanelLabelBar         = True
resP1@lbOrientation            = "vertical"
resP1@lbLabelFontHeightF       = 0.009
resP1@pmLabelBarOrthogonalPosF = 0.007    ;move Label Bar down
gsn_panel(wks,plot(0:3),(/1,4/),resP1)

resP2                          = True
resP2@gsnFrame                 = False
resP2@gsnPanelTop              = 0.7
resP2@gsnPanelBottom           = 0.43
resP2@gsnPanelLabelBar         = True
resP2@lbOrientation            = "vertical"
resP2@lbLabelFontHeightF       = 0.009
resP2@pmLabelBarOrthogonalPosF = 0.007
gsn_panel (wks,plot(4:7),(/1,4/),resP2)

frame (wks)
end
