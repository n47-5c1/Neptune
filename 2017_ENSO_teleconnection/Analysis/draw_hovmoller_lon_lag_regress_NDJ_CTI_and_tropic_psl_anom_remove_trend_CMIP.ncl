;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of cross regression between November-December-January cold tongue index and three-month means of the sea level pressure
;     anomalies removed trend at the tropic in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-04-14
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------slp
;   var3--------------ts
;   var4--------------psl
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP-NCAR
    in_name2 = "~/data-observation/NCEP_NCAR/monthly/slp.mon.mean.nc"
    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(37,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name3(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name3(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name3(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name3)

    in_path4     = "~/data-model/CMIP5-hes/psl/historical/"
    in_name4     = new(nmod,string)
    in_name4(0)  = "psl_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "psl_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "psl_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(3)  = "psl_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "psl_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "psl_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "psl_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "psl_Amon_CNRM-CM5_historical_r2i1p1_185001-200512_2.5x2.5.nc"
    in_name4(8)  = "psl_Amon_CNRM-CM5_historical_r2i1p1_185001-200512_2.5x2.5.nc";
    in_name4(9)  = "psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(10) = "psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "psl_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012.nc"
    in_name4(12) = "psl_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(13) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc";
    in_name4(15) = "psl_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "psl_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "psl_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "psl_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "psl_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name4(20) = "psl_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(21) = "psl_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(22) = "psl_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(23) = "psl_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(24) = "psl_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(25) = "psl_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(26) = "psl_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(27) = "psl_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(28) = "psl_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(29) = "psl_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(30) = "psl_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(31) = "psl_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(32) = "psl_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(33) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(34) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc";
    in_name4(35) = "psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(36) = "psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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
    lonW1 = 50
    lonE1 = 100

;tropical North Atlantic
    lonW2 = 305 
    lonE2 = 345

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 280

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./hovmoller_lon_lag_regress_NDJ_CTI_and_tropic_psl_anom_remove_trend_CMIP.nc"
    out_name = "hovmoller_lon_lag_regress_NDJ_CTI_and_tropic_psl_anom_remove_trend_CMIP"

;text
    text1 = (/"a) ","b) ","c) "/)
    text2 = (/"OBS","MMM"/)
    text3 = (/"5~F35~J~F~S - 5~F35~J~F~N, "+yS+"-"+yE,"Pa/~F35~J~F~C"/)
    text4 = (/"-6","-3","0","3","6","9"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in3 = addfile (in_path3 + in_name3(i),"r")
    in4 = addfile (in_path4 + in_name4(i),"r")

;get the time indexs
    time3  = in3->time
    time4  = in4->time
    year3  = cd_calendar (time3,-1) /100
    year4  = cd_calendar (time4,-1) /100
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    ts  = in3->ts(iYYYY3,:,:)
    psl = in4->psl(iYYYY4,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     lon    = in2->lon
     time1  = in1->time
     time2  = in2->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst    = in1->sst(iYYYY1,:,:)
     slp    = in2->slp(iYYYY2,:,:)
     slp    = (/100.*slp/)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1 = in1->lat
     gw2 = in2->lat
     gw1 = cos (rad*gw1)
     gw2 = cos (rad*gw2)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLL (psl)
   tsA  = calcMonAnomTLL (ts, clm3)
   pslA = calcMonAnomTLL (psl,clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   pslA = (/dtrend_msg_n (pslA&time,pslA,False,False,0)/)

;compute seasonal means
   tsA_NDJ = month_to_season (tsA,season(6))
   pslA_S  = month_to_seasonN (pslA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2_NDJ = wgt_areaave_Wrap ( tsA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)

;the tropic
;   SSTA_P = dim_avg_wgt_n_Wrap ( SSTA_S(:,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 2)
   pslA_T = dim_avg_wgt_n_Wrap ( pslA_S(:,:,{latN:latS},:), gw2({latN:latS}), 1, 2)
   dim    = dimsizes (pslA_T)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr = new((/dim(0),dim(2),nmod+2/),float)
   end if

;compute linear regression
   ccr(:,:,i+2)  = (/regCoef_n (I2_NDJ,pslA_T,0,1)/)
   ccr(7:,:,i+2) = (/regCoef_n (I2_NDJ(:dim(1)-2),pslA_T(7:,1:,:),0,1)/)

   if(i.eq.0)then
    copy_VarMeta (pslA_T(:,0,:),ccr(:,:,0))

    clm1 = clmMonTLL (sst)
    clm2 = clmMonTLL (slp)
    sstA = calcMonAnomTLL (sst,clm1)
    slpA = calcMonAnomTLL (slp,clm2)
    sstA = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    slpA = (/dtrend_msg_n (slpA&time,slpA,False,False,0)/)
    sstA_NDJ = month_to_season (sstA,season(6))
    slpA_S   = month_to_seasonN (slpA,season)
    I1_NDJ   = wgt_areaave_Wrap ( sstA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
;    SSTA1_P  = dim_avg_wgt_n_Wrap ( SSTA1_S(:,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 2)
    slpA_T   = dim_avg_wgt_n_Wrap ( slpA_S(:,:,{latN:latS},:), gw2({latN:latS}), 1, 2)
    ccr(:,:,0)  = (/regCoef_n (I1_NDJ,slpA_T,0,1)/)
    ccr(7:,:,0) = (/regCoef_n (I1_NDJ(:dim(1)-2),slpA_T(7:,1:,:), 0,1)/)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time3,time4,year3,year4/])

end do

   ccr(:,:,1) = dim_avg ( ccr(:,:,2:) )
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
filevardef (fout,"lon",typeof(lon),getvardims(lon))
filevardef (fout,"model","integer","model")
filevardef (fout,"ccr",typeof(ccr),getvardims(ccr))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lon",lon)
filevarattdef (fout,"ccr",ccr)

;output only the data values
fout->season = ispan(0,dim(0)-1,1)
;fout->lon   = (/lon1({lonW:lonE})/)
fout->lon    = (/lon/)
fout->model  = ispan(0,nmod+1,1)
fout->ccr    = (/ccr/)

else

 in  = addfile (out_data,"r")
 ccr = in->ccr
 dim = dimsizes (ccr)
 printVarSummary (ccr)

end if

;ccr = lonPivot (ccr,25)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks  = gsn_open_wks ("svg",out_path + out_name)
plot = new (2,graphic)

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
res@cnLevels             = (/-80,-60,-40,-20,20,40,60,80/)

res@lbLabelBarOn = False

res@tmYLMode             = "Explicit"
res@tmYLValues           = ispan(0,dim(0)-1,3)
res@tmYLLabels           = text4
res@tmYLMinorOn          = False
res@tmYRMinorOn          = False
;res@tmXBTickSpacingF     = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisString      = "Lag (months)"
res@tiYAxisFontHeightF = 0.021

res@vpWidthF  = 1.
res@vpHeightF = 0.25

res@gsnLeftString   = text1(0)+text2(0)
res@gsnCenterString = text3(0)
res@gsnRightString  = text3(1)
plot(0) = gsn_csm_hov (wks,ccr(:,:,0),res)

res@gsnLeftString   = text1(1)+text2(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(1) = gsn_csm_hov (wks,ccr(:,:,1),res)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
;resl@gsLineDashPattern = 1
;dum1 = gsn_add_polyline (wks,plot(0),(/165,165/),(/0,dim(0)-1/),resl)
;dum2 = gsn_add_polyline (wks,plot(1),(/165,165/),(/0,dim(0)-1/),resl)
;dum3 = gsn_add_polyline (wks,plot(0),(/270,270/),(/0,dim(0)-1/),resl)
;dum4 = gsn_add_polyline (wks,plot(1),(/270,270/),(/0,dim(0)-1/),resl)
dum1a = gsn_add_polyline (wks,plot(0),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum2a = gsn_add_polyline (wks,plot(1),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum3a = gsn_add_polyline (wks,plot(0),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum4a = gsn_add_polyline (wks,plot(1),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum1b = gsn_add_polyline (wks,plot(0),(/lonW1,lonW1/),(/0,dim(0)-1/),resl)
dum2b = gsn_add_polyline (wks,plot(1),(/lonW1,lonW1/),(/0,dim(0)-1/),resl)
dum3b = gsn_add_polyline (wks,plot(0),(/lonE1,lonE1/),(/0,dim(0)-1/),resl)
dum4b = gsn_add_polyline (wks,plot(1),(/lonE1,lonE1/),(/0,dim(0)-1/),resl)
dum1c = gsn_add_polyline (wks,plot(0),(/lonW2,lonW2/),(/0,dim(0)-1/),resl)
dum2c = gsn_add_polyline (wks,plot(1),(/lonW2,lonW2/),(/0,dim(0)-1/),resl)
dum3c = gsn_add_polyline (wks,plot(0),(/lonE2,lonE2/),(/0,dim(0)-1/),resl)
dum4c = gsn_add_polyline (wks,plot(1),(/lonE2,lonE2/),(/0,dim(0)-1/),resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.028
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.02
resP@pmLabelBarOrthogonalPosF = -0.008
resP@txString = "Regression of SLP onto NDJ CTI"

gsn_panel (wks,plot,(/2,1/),resP)


end
