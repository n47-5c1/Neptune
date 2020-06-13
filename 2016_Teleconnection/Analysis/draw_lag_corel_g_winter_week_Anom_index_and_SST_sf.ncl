;*************************************************************
;Aim: Draw cross correlation between weekly teleconnection index anomalies and global sea surface temperature anomalies, and between the index
;     anomalies and global stream function anomalies in the winter-half year
;
;Mission:
;   1. Read data from INDEX, sst and sf datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;
;                       He Shan
;                       2017-02-28
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
;   var3--------------sf
;================================================

;data
    in_path = "~/hes/One_Belt_One_Road/NCL/"
;    in1     = "PC_Index.nc"
    in1     = "PC_square_Index.nc"
    in2     = "sst.weekly.mean.anom_1982-2015.nc"
    in3     = "sf.weekly.mean.anom_1982-2015.nc"

;time
    mS     = 11
    mE     = 4
    yS     = 1982
    yE     = 2015
    maxlag = 20      ;set lag

    opt                = True
    opt@nval_crit      = 4          ;the minimum number of values needed
    opt@segment_length = 7

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
;    out_name = "lag_corel_g_winter_week_Anom_index_and_SST_sf"
    out_name = "lag_corel_g_winter_week_Anom_square_index_and_SST_sf"

;Map
    latN = 85
    latS = -45
    lonL = -80
    lonR = 170

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","n)"/)
    text2 = (/"-20","-16","-12","-8","-4","0"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f      = addfile (in_path+in1, "r")
    sst_in = addfile (in_path+in2, "r")
    sf_in  = addfile (in_path+in3, "r")

    index = f->INDEX
    sst   = sst_in->sst
    sf    = sf_in->sf

    time = f->time

    printVarSummary (index)
    printVarSummary (sst)
    printVarSummary (sf)
    printVarSummary (time)

;----------------------------------------------------------
    TIME  = cd_calendar (time, 0)
    year  = toint (TIME(:,0) )
    month = toint (TIME(:,1) )
    day   = toint (TIME(:,2))

;get the time indexs
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    iMM   = ind (month(iYYYY).lt.mS .and. month(iYYYY).gt.mE)   ;for summer-half year
    printVarSummary (iYYYY)
    printVarSummary (iMM)

;create required yyyyddd
    ddd     = day_of_year (year, month, day)
    yyyyddd = year*1000 + ddd
    printVarSummary (yyyyddd)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    index_p   = conform_dims ((/dimsizes(index),1,1/),index,0)
    index_p   = index
    index_p!1 = "lat"
    index_p!2 = "lon"
    printVarSummary (index_p)

;Daily anomalies
    index_clm  = clmDayTLL (index_p(iYYYY,:,:), yyyyddd(iYYYY))
    index_anom = calcDayAnomTLL (index_p(iYYYY,:,:), yyyyddd(iYYYY),index_clm)

;Calculate segment means
    index_anom(iMM,:,:) = index_anom@_FillValue      ;leave winter-half year alone
    index_seg           = calculate_segment_values (index_anom(:,0,0),"avg",0,opt)
    printVarSummary (index_seg)
    print ( num (.not.ismissing (index_seg) ) )

;----------------------------------------------------------
;compute cross correlation
    sst_r = sst(lat|:,lon|:,time|:)
    sf_r  = sf(lat|:,lon|:,time|:)
    ccr1  = esccr (sst_r,index_seg,maxlag)
    ccr2  = esccr (sf_r,index_seg,maxlag)
    copy_VarCoords_1 (sst_r,ccr1)
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

 wks   = gsn_open_wks ("svg",out_path+out_name)
 plot  = new(6,graphic)
 plot2 = new(6,graphic)

;-----------------------------------------------------------------------------
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.028

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnLineLabelsOn = False

;res@mpFillOn               = False
res@mpCenterLonF           = 210.
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
;res@mpMinLonF = lonL
;res@mpMaxLonF = lonR

res@lbLabelBarOn = False

res@tmXBTickSpacingF     = 60.     ;label spacing
res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025

;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.12,-.09,-.06,.06,.09,.12/)

do i=0,5
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = "Lag: "+text2(i)
 if (i.eq.1) then
  res@gsnRightString = "Nov.-Apr."
 else
  res@gsnRightString = " "
 end if

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

 plot(i) = gsn_csm_contour_map (wks,ccr1(:,:,maxlag-i*4),res)
end do

;---------------------------------------------------------------
;plot stream function

res2 = True

res2@gsnDraw         = False
res2@gsnFrame        = False
;res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnContourZeroLineThicknessF   = 0       ;sets thickness of zero contour
res2@gsnContourNegLineDashPattern   = 1       ;sets negative contours to dash lines
res2@gsnContourLineThicknessesScale = 2

res2@cnLevelSelectionMode = "ManualLevels"
res2@cnMinLevelValF       = -.15
res2@cnMaxLevelValF       = .15
res2@cnLevelSpacingF      = 0.05
;res2@cnLevelSelectionMode = "ExplicitLevels"
;res2@cnLevels             = (/-.16,-.13,-.1,.1,.13,.16/)
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
 plot2(i) = gsn_csm_contour (wks,ccr2(:,:,maxlag-i*4),res2)
 overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Lagged Correlation of Index Anomalies against SF and SST Anomalies"   ;add common title
resP@lbLabelFontHeightF       = 0.015
resP@gsnPanelLabelBar         = True      ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.007    ;move Label Bar down

gsn_panel(wks,plot,(/3,2/),resP)

end
