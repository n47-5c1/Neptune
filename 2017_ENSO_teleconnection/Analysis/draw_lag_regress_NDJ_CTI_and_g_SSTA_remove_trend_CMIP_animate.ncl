;*************************************************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly sea surface temperature
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-21
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------ts
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
    in_name3 = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
    in_path     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name     = new(37,string)
    in_name(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(6)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(7)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(8)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name)

;time
    yS = 1958
    yE = 2004
    season = (/"MJJ","JJA","JAS","ASO","SON","OND","NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270
;Nino3
;    latNI = 5
;    latSI = -5
;    lonWI = 210
;    lonEI = 270
;Nino3.4
;    latNI = 5
;    latSI = -5
;    lonWI = 190
;    lonEI = 240

;tropical Indian Ocean
;    latN1 = 10
;    latS1 = -10
;    lonW1 = 50
;    lonE1 = 100
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = -55
    lonE2 = -15

; create points for box
    ypts1 = (/latNI,latNI,latSI,latSI,latNI/)
    xpts1 = (/lonWI,lonEI,lonEI,lonWI,lonWI/)
    ypts2 = (/latN1,latN1,latS1,latS1,latN1/)
    xpts2 = (/lonW1,lonE1,lonE1,lonW1,lonW1/)
    ypts3 = (/latN2,latN2,latS2,latS2,latN2/)
    xpts3 = (/lonW2,lonE2,lonE2,lonW2,lonW2/)
;    ypts4 = (/latN3,latN3,latS3,latS3,latN3/)
;    xpts4 = (/lonW3,lonE3,lonE3,lonW3,lonW3/)

;region
    latN = 60
    latS = -60
;    lonW = 120
;    lonE = 280

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/Animation/"
    out_data = "./lag_regress_NDJ_CTI_and_g_SSTA_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_g_SSTA_remove_trend_CMIP_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) ","c) ","d) "/)
    text3 = (/"HadISST","ERSST","COBE SST","MMM"/)
    text4 = (/"Regress "," SSTAs onto NDJ CTI","~F35~J~F~C/~F35~J~F~C"/)
;    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile (in_path + in_name(i),"r")

;get the time indexs
    time  = in->time
    year  = cd_calendar (time,-1) /100
    iYYYY = ind (year.ge.yS .and. year.le.yE)

    sst = in->ts(iYYYY,{latN:latS},:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     time1  = in1->time
     time2  = in2->time
     time3  = in3->time
     lat1   = in1->lat({latN:latS})
     rad = 4.*atan(1.)/180.
     gw     = cos (rad*lat1)
     copy_VarMeta(lat1, gw)
     lon1   = in1->lon
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     year3  = cd_calendar (time3,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst1   = in1->sst(iYYYY1,{latN:latS},:)
     sst2   = in2->sst(iYYYY2,{latN:latS},:)
     sst3   = in3->sst(iYYYY3,{latN:latS},:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
;    rad = 4.*atan(1.)/180.
;    gw  = in1->latitude({latN:latS})
;    gw  = in->lat({latN:latS})
;    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL (sst)
   SSTA = calcMonAnomTLL (sst, clm)
   SSTA = (/dtrend_msg_n (SSTA&time,SSTA,False,False,0)/)

;compute seasonal means
   SSTA_S = month_to_seasonN (SSTA,season)
   dim    = dimsizes (SSTA_S)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I_NDJ = wgt_areaave_Wrap ( SSTA_S(6,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr = new((/dim(0),dim(2),dim(3),nmod/),float)
   end if

;compute linear regression
   ccr(:,:,:,i)   = (/regCoef_n (I_NDJ,SSTA_S,0,1)/)
   ccr(7:,:,:,i) = (/regCoef_n (I_NDJ(:dim(1)-2),SSTA_S(7:,1:,:,:),0,1)/)

   if(i.eq.0)then
    copy_VarMeta (SSTA_S(:,0,:,:),ccr(:,:,:,0))

    clm1    = clmMonTLL (sst1)
    clm2    = clmMonTLL (sst2)
    clm3    = clmMonTLL (sst3)
    SSTA1   = calcMonAnomTLL (sst1,clm1)
    SSTA2   = calcMonAnomTLL (sst2,clm2)
    SSTA3   = calcMonAnomTLL (sst3,clm3)
    SSTA1   = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    SSTA2   = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
    SSTA3   = (/dtrend_msg_n (SSTA3&time,SSTA3,False,False,0)/)
    SSTA1_S = month_to_seasonN (SSTA1,season)
    SSTA2_S = month_to_seasonN (SSTA2,season)
    SSTA3_S = month_to_seasonN (SSTA3,season)
    I1_NDJ  = wgt_areaave_Wrap ( SSTA1_S(6,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I2_NDJ  = wgt_areaave_Wrap ( SSTA2_S(6,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I3_NDJ  = wgt_areaave_Wrap ( SSTA3_S(6,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    ccr1         = regCoef_n (I1_NDJ,SSTA1_S,0,1)
    ccr2         = regCoef_n (I2_NDJ,SSTA2_S,0,1)
    ccr3         = regCoef_n (I3_NDJ,SSTA3_S,0,1)
    ccr1(7:,:,:) = regCoef_n (I1_NDJ(:dim(1)-2),SSTA1_S(7:,1:,:,:), 0,1)
    ccr2(7:,:,:) = regCoef_n (I2_NDJ(:dim(1)-2),SSTA2_S(7:,1:,:,:), 0,1)
    ccr3(7:,:,:) = regCoef_n (I3_NDJ(:dim(1)-2),SSTA3_S(7:,1:,:,:), 0,1)
    copy_VarMeta (SSTA1_S(:,0,:,:),ccr1(:,:,:))
    copy_VarMeta (SSTA2_S(:,0,:,:),ccr2(:,:,:))
    copy_VarMeta (SSTA3_S(:,0,:,:),ccr3(:,:,:))
    printVarSummary (ccr1)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time,year/])

end do

   mnmn = dim_avg ( ccr )
   copy_VarMeta (ccr1,mnmn)
   printVarSummary (mnmn)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","lat","lon"/)
dimSizes = (/dim(0),dim(2),dim(3)/) 
dimUnlim = (/True,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer", "season")
filevardef (fout,"lat",   typeof(lat1),getvardims(lat1))
filevardef (fout,"lon",   typeof(lon1),getvardims(lon1))
filevardef (fout,"r1",  typeof(ccr1),getvardims(ccr1))
filevardef (fout,"r2",  typeof(ccr2),getvardims(ccr2))
filevardef (fout,"r3",  typeof(ccr3),getvardims(ccr3))
filevardef (fout,"r4",  typeof(mnmn),getvardims(mnmn))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lat",lat1)
filevarattdef (fout,"lon",lon1)
filevarattdef (fout,"r1",ccr1)
filevarattdef (fout,"r2",ccr2)
filevarattdef (fout,"r3",ccr3)
filevarattdef (fout,"r4",mnmn)

;output only the data values
fout->season = ispan(1,dim(0),1)
fout->lat   = (/lat1/)
fout->lon   = (/lon1/)
fout->r1  = (/ccr1/)
fout->r2  = (/ccr2/)
fout->r3  = (/ccr3/)
fout->r4  = (/mnmn/)

else

 in   = addfile (out_data,"r")
 ccr1 = in->r1
 ccr2 = in->r2
 ccr3 = in->r3
 mnmn = in->r4
 dim  = dimsizes (ccr1)
 printVarSummary (ccr1)
 printVarSummary (mnmn)

end if

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.4,-.2,-.1,-.05,.05,.1,.2,.4/)

res@lbLabelBarOn = False

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;res@mpFillOn               = False
res@mpCenterLonF           = 200
;res@mpLandFillColor        = "gray80"
;res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 3.0          ; thickness of lines

dum1 = new((/4,4/), graphic)  
dum2 = new((/4,4/), graphic)  
dum3 = new((/4,4/), graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF = 0.023
;resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True

;resP@lbTitleString = text4(2)
;resP@lbOrientation = "vertical"
;resP@lbLabelJust = "centerright"
;resP@lbTitleFontHeightF = 0.015
;resP@lbLabelFontHeightF = 0.013
resP@lbLabelFontHeightF = 0.011
;resP@pmLabelBarWidthF = 0.09
;resP@pmLabelBarHeightF = 0.4
resP@pmLabelBarOrthogonalPosF = -0.006

;----------------------------------------------------------
do i = 0,dim(0)-1

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))
 plot = new (4,graphic)

 res@gsnLeftString   = text2(0)+text3(0)
 res@gsnCenterString = text4(0)+season(i)+text4(1)
; res@gsnCenterString = text4(1)+sprintf("%5.3f",r2(i))
 res@gsnRightString  = " "
; res@tmXBLabelsOn    = False
 plot(0) = gsn_csm_contour_map_ce (wks,ccr1(i,:,:),res)

 res@gsnLeftString   = text2(1)+text3(1)
 res@gsnRightString  = text4(2)
 plot(1) = gsn_csm_contour_map_ce (wks,ccr2(i,:,:),res)

 res@gsnLeftString = text2(2) + text3(2)
 res@gsnCenterString = " "
 res@gsnRightString = " "
 plot(2) = gsn_csm_contour_map_ce(wks, ccr3(i,:,:), res)

 res@gsnLeftString = text2(3) + text3(3)
 plot(3) = gsn_csm_contour_map_ce(wks, mnmn(i,:,:), res)

;----------------------------------------------------------
 do j = 0, 3
  do k = 0, 0
   dum1(k,j) = gsn_add_polyline (wks,plot(k),xpts1(j:j+1),ypts1(j:j+1),resb)
   dum2(k,j) = gsn_add_polyline (wks,plot(k),xpts2(j:j+1),ypts2(j:j+1),resb)
   dum3(k,j) = gsn_add_polyline (wks,plot(k),xpts3(j:j+1),ypts3(j:j+1),resb)
  end do
 end do 

 if(i.eq.0)then
  plot0 = plot(0)
  getvalues plot0@contour
   "cnLevels" : levels
  end getvalues
  resP@lbLabelStrings = sprintf("%3.2f", levels)
 end if
 resP@txString = "Regression of SSTA onto NDJ CTI"
 gsn_panel (wks,plot,(/2,2/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
