;*************************************************************
;Aim: Draw composite life cycles phase of correlation at 2-lag (month) between daily anomalous Nino 3.4 index and Afro-Eurasian daily anomalous
;     stream function deviations from zonal mean with 10-30-day bandpass filters, derived by PC1 and PC2 for animations
;Mission:
;
;   1. Read data from UV, SST, PC12 and index datasets
;   2. Post-post process to deserved results
;   3. Draw the phases
;                       He Shan
;                       2017-05-24
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
;   var3--------------sst
;   var4--------------PC1
;   var5--------------PC2
;   var6--------------INDEX
;================================================

;data
    in_path1 = "~/data/observation/NCEP_DOE/daily/"
    in_path2 = "~/data/observation/SST/OISST_daily/"
    nPhase   = 8
    r2d      = 180./(4.*atan(1.0))
    rad      = 1./r2d

;Nino 3.4
    latN = 5
    latS = -5
    lonW = 190
    lonE = 240

;time
    yS     = 1982
    maxlag = 60      ;set lag

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/Animation/"
    out_name = "phase_lag_corel_daily_Nino3.4_anom_t_Afro-Eurasian_sf_anom_x_t_BP_PC12_"

;text
    text1 = (/"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/DOE Reanalysis 2
    U_files = systemfunc ("ls "+in_path1+"uwnd/uwnd.*.nc")
    V_files = systemfunc ("ls "+in_path1+"vwnd/vwnd.*.nc")
;NOAA OI SST V2 1981/09-
    SST_files = systemfunc ("ls "+in_path2+"sst.day.mean.*.v2.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files

    U_in   = addfiles (U_files,"r")
    V_in   = addfiles (V_files,"r")
    SST_in = addfiles (SST_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
    ListSetType (SST_in, "cat")

;----------------------------------------------------------
    TIME  = U_in[:]->time
    YYYY  = cd_calendar (TIME,0)
    year  = toint (YYYY(:,0))
    month = toint (YYYY(:,1))
    day   = toint (YYYY(:,2))

;get the time indexs
    iYYYY = ind (year.eq.1981 .and. month.ge.9  .or. year.ge.yS)
    printVarSummary (iYYYY)

;create required yyyyddd
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year(iYYYY)*1000 + ddd(iYYYY)
    printVarSummary (yyyyddd)

;----------------------------------------------------------
;    U     = V_file->hgt(:,2,:,:)                ;850hPa
;    U     = V_file->hgt(:,5,:,:)                ;500hPa
    U    = short2flt (U_in[:]->uwnd(iYYYY,8,::-1,:))           ;250hPa
    V    = short2flt (V_in[:]->vwnd(iYYYY,8,::-1,:))           ;250hPa
    SST  = SST_in[:]->sst(:,{latS:latN:2},{lonW:lonE:2})

    f     = addfile ("./PC_Index.nc", "r")
    pc1   = f->PC1(iYYYY)
    pc2   = f->PC2(iYYYY)
    index = f->INDEX(iYYYY)

    index(:maxlag) = index@_FillValue

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (SST)
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

;creat weights: cos(lat)
    gw = SST_in[0]->lat({latS:latN:2})
    gw = cos (rad*gw)
    printVarSummary (gw)

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

    nDays  = new (nPhase, "integer")
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

   SSTClmDay = clmDayTLL (SST, yyyyddd)
   SST_tAnom = calcDayAnomTLL (SST, yyyyddd, SSTClmDay)
   printVarSummary(SST_tAnom)

;Compute regional mean
   SST_reg = wgt_areaave_Wrap ( SST_tAnom, gw, 1., 0)
   printVarSummary(SST_reg)

;Filter
   sfAnom_BP = wgt_runave_Wrap (sf_tAnom(lat|:,lon|:,time|:),wts,0)
   printVarSummary (sfAnom_BP)

; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

res = True

res@gsnDraw                  = False
res@gsnFrame                 = False
res@gsnPolar                 = "NH"
;res@gsnLeftString            = "deg C"
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
res@cnMinLevelValF       = -.2
res@cnMaxLevelValF       = 0.2
res@cnLevelSpacingF      = 0.05

res@pmLabelBarOrthogonalPosF = 0.02    ;move Label Bar down
res@lbLabelFontHeightF       = 0.015

res@tiMainString      = "Life Cycles of Correlation between N3.4 Index and 250 hPa SF anomalies"
res@tiMainFontHeightF = 0.02

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

 nt        = ind (index.gt.1.0 .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i))
 nt_r      = nt - maxlag
 ccr       = escorc (sfAnom_BP(:,:,nt),SST_reg(nt_r))
 nDays(na) = dimsizes (nt)

 if(i.eq.0)then
  print(nt(:9))
  print(nt_r(:9))
  copy_VarCoords_1 (sfAnom_BP,ccr)
  printVarSummary (ccr)
 end if

;----------------------------------------------------------
;draw correlation
 res@gsnCenterString = pLabel(na) + nDays(na)

 plot = gsn_csm_contour_map (wks,ccr(:,:),res)

;----------------------------------------------------------
;draw sf
; plot_ov = gsn_csm_contour (wks,diff_sf,ores)
; overlay(plot,plot_ov)

 draw (plot)
 frame (wks)

 delete([/wks,nt,nt_r,plot/])      ;will change next iteration
end do

end
