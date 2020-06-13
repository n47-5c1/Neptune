;*******************************:******************************
;Aim: Draw cross regression between November-December-January cold tongue index and three-month means of global monthly sea level pressure
;     anomalies removed trend in CMIP model for animations
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-24
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
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/slp.mon.mean.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(37,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(6)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(7)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(8)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name3(27) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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
;    in_name4(3)  = "psl_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(4)  = "psl_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(5)  = "psl_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(3)  = "psl_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6)  = "psl_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7)  = "psl_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8)  = "psl_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9) = "psl_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(10) = "psl_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(11) = "psl_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "psl_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "psl_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "psl_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "psl_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(8)  = "psl_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(9)  = "psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(15) = "psl_Amon_EC-EARTH_historical_r1i1p1_185001-200912.nc"
;    in_name4(17) = "psl_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(10) = "psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(19) = "psl_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "psl_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012.nc"
    in_name4(12) = "psl_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(13) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "psl_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(15) = "psl_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "psl_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "psl_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "psl_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "psl_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name4(27) = "psl_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
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
    in_name4(34) = "psl_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name4(35) = "psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(36) = "psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;time
    yS = 1958
    yE  = 2004
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
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

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
    out_path = "~/hes/ENSO/Fig/Animation/"
    out_data = "./lag_regress_NDJ_CTI_and_g_psl_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_g_psl_anom_remove_trend_CMIP_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"a) ","b) ","c) "/)
    text3 = (/"OBS","MMM"/)
    text4 = (/" "+yS+"-"+yE,"hPa/~F35~J~F~C"/)
    text5 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

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

    ts  = in3->ts(iYYYY3,{latN:latS},:)
    psl = in4->psl(iYYYY4,{latN:latS},:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time1  = in1->time
     time2  = in2->time
     lat1   = in1->lat({latN:latS})
     lat2   = in2->lat({latN:latS})
     lon1   = in1->lon
     lon2   = in2->lon
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst    = in1->sst(iYYYY1,{latN:latS},:)
     slp    = in2->slp(iYYYY2,{latN:latS},:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw  = cos (rad*lat1)
     copy_VarCoords (lat1,gw)

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
   tsA_S  = month_to_season (tsA,season(6))
   pslA_S = month_to_seasonN (pslA,season)
   dim    = dimsizes (pslA_S)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2_NDJ = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr2 = new((/dim(0),dim(2),dim(3),nmod/),float)
   end if

;compute linear regression
   ccr2(:,:,:,i)   = (/regCoef_n (I2_NDJ,pslA_S,0,1)/)
   ccr2(7:,:,:,i) = (/regCoef_n (I2_NDJ(:dim(1)-2),pslA_S(7:,1:,:,:),0,1)/)

   if(i.eq.0)then
    copy_VarMeta (pslA_S(:,0,:,:),ccr2(:,:,:,0))

    clm1   = clmMonTLL (sst)
    clm2   = clmMonTLL (slp)
    sstA   = calcMonAnomTLL (sst,clm1)
    slpA   = calcMonAnomTLL (slp,clm2)
    sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
    slpA   = (/dtrend_msg_n (slpA&time,slpA,False,False,0)/)
    sstA_S = month_to_season (sstA,season(6))
    slpA_S = month_to_seasonN (slpA,season)
    I1_NDJ = wgt_areaave_Wrap ( sstA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    ccr1         = regCoef_n (I1_NDJ,slpA_S,0,1)
    ccr1(7:,:,:) = regCoef_n (I1_NDJ(:dim(1)-2),slpA_S(7:,1:,:,:), 0,1)
    copy_VarMeta (slpA_S(:,0,:,:),ccr1)
    printVarSummary (ccr1)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time3,time4,year3,year4/])

end do

   mnmn = dim_avg ( ccr2 )/100.
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
filevardef (fout,"lat",   typeof(lat2),getvardims(lat2))
filevardef (fout,"lon",   typeof(lon2),getvardims(lon2))
filevardef (fout,"ccr1",  typeof(ccr1),getvardims(ccr1))
filevardef (fout,"mnmn",  typeof(mnmn),getvardims(mnmn))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lat",lat2)
filevarattdef (fout,"lon",lon2)
filevarattdef (fout,"ccr1",ccr1)
filevarattdef (fout,"mnmn",mnmn)

;output only the data values
fout->season = ispan(1,dim(0),1)
fout->lat   = (/lat2/)
fout->lon   = (/lon2/)
fout->ccr1  = (/ccr1/)
fout->mnmn  = (/mnmn/)

else

 in   = addfile (out_data,"r")
 ccr1 = in->ccr1
 mnmn = in->mnmn
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
res@cnLevels             = (/-2.,-1.,-.5,-.25,.25,.5,1.,2./)

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

dum1 = new (4,graphic)  
dum2 = new (4,graphic)  
dum3 = new (4,graphic)  
dum4 = new (4,graphic)  
dum5 = new (4,graphic)  
dum6 = new (4,graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.03
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.022
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0,dim(0)-1

 wks  = gsn_open_wks ("svg",out_path + out_name + text1(i))
 plot = new (2,graphic)

 res@gsnLeftString   = text2(0)+text3(0)
 res@gsnCenterString = text4(0)
 res@gsnRightString  = text4(1)
; res@tmXBLabelsOn    = False
 plot(0) = gsn_csm_contour_map_ce (wks,ccr1(i,:,:),res)

 res@gsnLeftString   = text2(1)+text3(1)
; res@gsnCenterString = text4(1)+sprintf("%5.3f",r2(i))
 res@gsnCenterString = " "
 res@gsnRightString  = " "
 plot(1) = gsn_csm_contour_map_ce (wks,mnmn(i,:,:),res)

;----------------------------------------------------------
 do j =0,3
  dum1(j) = gsn_add_polyline (wks,plot(0),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum2(j) = gsn_add_polyline (wks,plot(1),xpts1(j:j+1),ypts1(j:j+1),resb)
  dum3(j) = gsn_add_polyline (wks,plot(0),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum4(j) = gsn_add_polyline (wks,plot(1),xpts2(j:j+1),ypts2(j:j+1),resb)
  dum5(j) = gsn_add_polyline (wks,plot(0),xpts3(j:j+1),ypts3(j:j+1),resb)
  dum6(j) = gsn_add_polyline (wks,plot(1),xpts3(j:j+1),ypts3(j:j+1),resb)
 end do 

 resP@txString = "Regression at "+text5(i)+" of SLP onto NDJ CTI"
 gsn_panel (wks,plot,(/2,1/),resP)

 delete([/wks,plot/])      ;will change next iteration
end do

end
