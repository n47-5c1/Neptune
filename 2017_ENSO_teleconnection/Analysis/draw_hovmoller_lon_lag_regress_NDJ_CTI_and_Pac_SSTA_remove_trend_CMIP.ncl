;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of cross regression between November-December-January cold tongue index and three-month means of the sea surface temperature
;     anomalies removed trend at the Pacific equator in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-29
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
;    in_name(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 290

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/"
    out_data = "./hovmoller_lon_lag_regress_NDJ_CTI_and_Pac_SSTA_remove_trend_CMIP.nc"
    out_name = "hovmoller_lon_lag_regress_NDJ_CTI_and_Pac_SSTA_remove_trend_CMIP"

;text
    text1 = (/"a) HadISST","b) ERSST","c) COBE","b) MMM"/)
    text2 = (/"5~F35~J~F~S - 5~F35~J~F~N","~F35~J~F~C/~F35~J~F~C"/)
;    text3 = (/"-6","-3","0","3","6","9"/)
    text3 = (/"MJJ(0)","ASO(0)","NDJ(0)","FMA(+1)","MJJ(+1)","ASO(+1)"/)
    text4 = "The period of SSTAs"

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

    sst = in->ts(iYYYY,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     in3    = addfile (in_name3,"r")
     lon1   = in1->lon
     time1  = in1->time
     time2  = in2->time
     time3  = in3->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     year3  = cd_calendar (time3,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst1   = in1->sst(iYYYY1,:,:)
     sst2   = in2->sst(iYYYY2,:,:)
     sst3   = in3->sst(iYYYY3,:,:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
;    gw  = in1->latitude({latN:latS})
    gw  = in->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL (sst)
   SSTA = calcMonAnomTLL (sst, clm)
   SSTA = (/dtrend_msg_n (SSTA&time,SSTA,False,False,0)/)

;compute seasonal means
   SSTA_S = month_to_seasonN (SSTA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I_NDJ = wgt_areaave_Wrap ( SSTA_S(6,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;the Pacific
;   SSTA_P = dim_avg_wgt_n_Wrap ( SSTA_S(:,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 2)
   SSTA_P = dim_avg_wgt_n_Wrap ( SSTA_S(:,:,{latN:latS},:), gw({latN:latS}), 1, 2)
   dim    = dimsizes (SSTA_P)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr = new((/dim(0),dim(2),nmod+4/),float)
   end if

;compute linear regression
   ccr(:,:,i+4)  = (/regCoef_n (I_NDJ,SSTA_P,0,1)/)
   ccr(7:,:,i+4) = (/regCoef_n (I_NDJ(:dim(1)-2),SSTA_P(7:,1:,:),0,1)/)

   if(i.eq.0)then
    copy_VarMeta (SSTA_P(:,0,:),ccr(:,:,0))

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
;    SSTA1_P = dim_avg_wgt_n_Wrap ( SSTA1_S(:,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 2)
    SSTA1_P = dim_avg_wgt_n_Wrap ( SSTA1_S(:,:,{latN:latS},:), gw({latN:latS}), 1, 2)
    SSTA2_P = dim_avg_wgt_n_Wrap ( SSTA2_S(:,:,{latN:latS},:), gw({latN:latS}), 1, 2)
    SSTA3_P = dim_avg_wgt_n_Wrap ( SSTA3_S(:,:,{latN:latS},:), gw({latN:latS}), 1, 2)
    ccr(:,:,0)  = (/regCoef_n (I1_NDJ,SSTA1_P,0,1)/)
    ccr(:,:,1)  = (/regCoef_n (I2_NDJ,SSTA2_P,0,1)/)
    ccr(:,:,2)  = (/regCoef_n (I3_NDJ,SSTA3_P,0,1)/)
    ccr(7:,:,0) = (/regCoef_n (I1_NDJ(:dim(1)-2),SSTA1_P(7:,1:,:), 0,1)/)
    ccr(7:,:,1) = (/regCoef_n (I2_NDJ(:dim(1)-2),SSTA2_P(7:,1:,:), 0,1)/)
    ccr(7:,:,2) = (/regCoef_n (I3_NDJ(:dim(1)-2),SSTA3_P(7:,1:,:), 0,1)/)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time,year/])

end do

   ccr(:,:,3) = dim_avg ( ccr(:,:,4:) )
   ccr!2 = "model"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","lon","model"/)
dimSizes = dimsizes (ccr)
dimUnlim = (/False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer","season")
filevardef (fout,"lon",typeof(lon1),getvardims(lon1))
filevardef (fout,"model","integer","model")
filevardef (fout,"ccr",typeof(ccr),getvardims(ccr))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lon",lon1)
filevarattdef (fout,"ccr",ccr)

;output only the data values
fout->season = ispan(0,dim(0)-1,1)
;fout->lon   = (/lon1({lonW:lonE})/)
fout->lon    = (/lon1/)
fout->model  = ispan(0,nmod+3,1)
fout->ccr    = (/ccr/)

else

 in  = addfile (out_data,"r")
 ccr = in->ccr
 dim = dimsizes (ccr)
 printVarSummary (ccr)

end if

;ccr(season|:,model|:,lon|:) = lonPivot(ccr(season|:,model|:,lon|:),25.)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks  = gsn_open_wks ("svg",out_path + out_name)
plot = new (4,graphic)

res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .021

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;res@cnFillPalette  = "CBR_coldhot"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.8,-.4,-.2,-.1,.1,.2,.4,.8/)

res@lbLabelBarOn = False

res@tmYLMode             = "Explicit"
res@tmYLValues           = ispan(0,dim(0)-1,3)
res@tmYLLabels           = text3
res@tmYLLabelJust        = "CenterCenter"
res@tmYLMinorOn          = False
res@tmYRMinorOn          = False
;res@tmXBTickSpacingF     = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisString      = text4
res@tiYAxisFontHeightF = 0.021

;res@vpWidthF  = 1.
res@vpHeightF = 0.35

do i = 0, 3
    res@gsnLeftString = text1(i)
    if(i.ne.2)then
        res@gsnCenterString = text2(0)
    else
        res@gsnCenterString = " "
    end if
    if(i.eq.3)then
        res@gsnRightString  = text2(1)
    else
        res@gsnRightString  = " "
    end if
    plot(i) = gsn_csm_hov (wks,ccr(:,{lonW:lonE},i),res)
end do

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
dum1a = gsn_add_polyline (wks,plot(0),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum2a = gsn_add_polyline (wks,plot(1),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum3a = gsn_add_polyline (wks,plot(2),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum4a = gsn_add_polyline (wks,plot(3),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum1b = gsn_add_polyline (wks,plot(0),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum2b = gsn_add_polyline (wks,plot(1),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum3b = gsn_add_polyline (wks,plot(2),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum4b = gsn_add_polyline (wks,plot(3),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.015
resP@pmLabelBarOrthogonalPosF = -0.008
resP@txFontHeightF = 0.023
resP@txString = "Regression of SSTA onto NDJ CTI"

;gsn_panel (wks,plot,(/2,2/),resP)
gsn_panel (wks,plot((/0,3/)),(/1,2/),resP)

end
