;*************************************************************
;Aim: Draw cross correlation between January-February teleconnection index anomalies and global two-month means of sea surface temperature anomalies,
;     and between the index anomalies and global two-month means of stream function anomalies
;
;Mission:
;   1. Read data from INDEX, sst, uwnd and vwnd datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;
;                       He Shan
;                       2017-11-17
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------INDEX
;   var2--------------sst
;   var3--------------uwnd
;   var4--------------vwnd
;================================================

;data
    in_path1 = "~/data/observation/SST/HadISST/HadISST_sst.nc"
    in_path2 = "~/data/observation/NCEP_DOE/monthly/uwnd.mon.mean.nc"
    in_path3 = "~/data/observation/NCEP_DOE/monthly/vwnd.mon.mean.nc"

;time
    mS     = 1
    yS     = 1979
    yE     = 2015
    maxlag = 5                   ;set lag

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "lag_corel_g_Anom_JF_square_index_and_2-mon_SST_sf"

;Map
    latN = 85
    latS = -45
    lonL = -80
    lonR = 170

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","n)"/)
    text2 = (/"-5","-4","-3","-2","-1","0"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f        = addfile ("./PC_square_Index.nc", "r")
    SST_file = addfile (in_path1,"r")
    U_file   = addfile (in_path2,"r")
    V_file   = addfile (in_path3,"r")

    time1 = SST_file->time
    time2 = U_file->time
    printVarSummary (time1)
    printVarSummary (time2)

;get the time indexs
    TIME1  = cd_calendar (time1, 0)
    year1  = toint ( TIME1(:,0) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    month  = toint ( TIME1(iYYYY1,1) )
    iMM    = ind (month.ne.mS)   ;for non-DJ monthes

    TIME2  = cd_calendar (time2, 0)
    year2  = toint ( TIME2(:,0) )
    iYYYY2 = ind (year2.le.yE)
    printVarSummary (iYYYY1)
    printVarSummary (iMM)
    printVarSummary (iYYYY2)

;----------------------------------------------------------
    index = f->INDEX
    SST   = SST_file->sst(iYYYY1,:,:)
    U     = short2flt(U_file->uwnd(iYYYY2,8,::-1,:))   ;250 hPa
    V     = short2flt(V_file->vwnd(iYYYY2,8,::-1,:))
    printVarSummary (index)
    printVarSummary (SST)
    printVarSummary (U)
    printVarSummary (V)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
    sfvp = uv2sfvpG (U,V)
    sf   = sfvp(0,:,:,:)
    copy_VarCoords (U,sf)
    printVarSummary (sf)

;Deviation from zonal mean
    sf_xAnom = dim_rmvmean_Wrap (sf)
    printVarSummary (sf_xAnom)

;Calculate monthly means
    index_mon_p = calculate_monthly_values (index,"avg",0,False)
    dim         = dimsizes (index_mon_p)
    index_mon   = conform_dims ((/dimsizes(index_mon_p),1,1/),index_mon_p,0)
    index_mon   = index_mon_p
    index_mon!1 = "lat"
    index_mon!2 = "lon"
    printVarSummary (index_mon)

;Monthly anomalies
    index_Clm  = clmMonTLL (index_mon)
    SST_Clm    = clmMonTLL (SST)
    sf_Clm     = clmMonTLL (sf_xAnom)
    index_Anom = calcMonAnomTLL (index_mon, index_Clm)
    SST_Anom   = calcMonAnomTLL (SST, SST_Clm)
    sf_Anom    = calcMonAnomTLL (sf_xAnom, sf_Clm)
    index_Anom(:dim-2,:,:) = (/ index_Anom(:dim-2,:,:) + index_Anom(1:,:,:) /)
;    index_Anom(:dim-3,:,:) = (/ index_Anom(:dim-3,:,:) + index_Anom(1:dim-2,:,:) + index_Anom(2:,:,:) /)
    index_Anom(iMM,:,:)    = index_Anom@_FillValue      ;leave DJ alone
    SST_Anom(:dim-2,:,:)   = (/ SST_Anom(:dim-2,:,:) + SST_Anom(1:,:,:) /)
    sf_Anom(:dim-2,:,:)    = (/ sf_Anom(:dim-2,:,:) + sf_Anom(1:,:,:) /)
;    SST_Anom(:dim-3,:,:)   = (/ SST_Anom(:dim-3,:,:) + SST_Anom(1:dim-2,:,:) + SST_Anom(2:,:,:) /)
;    sf_Anom(:dim-3,:,:)    = (/ sf_Anom(:dim-3,:,:) + sf_Anom(1:dim-2,:,:) + sf_Anom(2:,:,:) /)
    printVarSummary (index_Anom)
    printVarSummary (SST_Anom)
    printVarSummary (sf_Anom)

;----------------------------------------------------------
;compute cross correlation
    SST_r = SST_Anom(latitude|:,longitude|:,time|:)
    sf_r  = sf_Anom(lat|:,lon|:,time|:)
    ccr1  = esccr (SST_r,index_Anom(:,0,0),maxlag)
    ccr2  = esccr (sf_r,index_Anom(:,0,0),maxlag)
;    ccr2  = (/mask(ccr2,abs(ccr2).le..06, False)/)
    copy_VarCoords_1 (SST_r,ccr1)   ;copy coordinate variable
    copy_VarCoords_1 (sf_r,ccr2)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (ccr1)
   printVarSummary (ccr2)
;   printVarSummary (ccr3)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks   = gsn_open_wks ("svg",out_path+out_name)   ; open a svg file
 plot  = new(6,graphic)                           ; creat a plot array
 plot2 = new(6,graphic)

;-----------------------------------------------------------------------------
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.028

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap
res@cnLineLabelsOn = False

;res@mpFillOn               = False
res@mpCenterLonF           = 210.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
;res@mpMinLonF              = lonL
;res@mpMaxLonF              = lonR

res@lbLabelBarOn = False

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.025
res@tmYLLabelFontHeightF = 0.025

;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.49,-.38,-.27,.27,.38,.49/)

do i=0,5
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = "Lag: "+text2(i)
 if (i.ge.4) then
  res@tmXBLabelsOn = True    ;draw lon labels
 else
  res@tmXBLabelsOn = False   ;do not draw lon labels
 end if
 if (mod(i,2).eq.0 ) then
  res@tmYLLabelsOn = True    ;draw lat labels
 else
  res@tmYLLabelsOn = False   ;do not draw lat labels
 end if

 plot(i) = gsn_csm_contour_map (wks,ccr1(:,:,maxlag-i),res)
end do

;---------------------------------------------------------------
;plot stream function

res2 = True

res2@gsnDraw         = False
res2@gsnFrame        = False
;res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnContourZeroLineThicknessF   = 0
res2@gsnContourNegLineDashPattern   = 1
res2@gsnContourLineThicknessesScale = 2

res2@cnLevelSelectionMode = "ManualLevels"
res2@cnMinLevelValF       = -.54
res2@cnMaxLevelValF       = .54
res2@cnLevelSpacingF      = 0.27
res2@cnLineLabelsOn       = False
;res2@cnLineDrawOrder      = "PostDraw"
;res2@cnLabelDrawOrder     = "PostDraw"
res2@cnInfoLabelFontHeightF    = 0.016
res2@cnInfoLabelOrthogonalPosF = 0.28   ;move informational label down

do i=0,5
 if(i.eq.5)then
  res2@cnInfoLabelOn = True
 else
  res2@cnInfoLabelOn = False
 end if
 plot2(i) = gsn_csm_contour (wks,ccr2(:,:,maxlag-i),res2)
 overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Cross Correlation of Anom DJ Index against 2-month SF and SST"   ;add common title
resP@lbLabelFontHeightF       = 0.015
resP@gsnPanelLabelBar         = True      ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.007    ;move Label Bar down

gsn_panel(wks,plot,(/3,2/),resP)

end
