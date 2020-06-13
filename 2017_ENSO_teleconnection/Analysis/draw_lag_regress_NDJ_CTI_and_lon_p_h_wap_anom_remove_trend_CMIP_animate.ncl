;*************************************************************
;Aim: Draw cross regression of three-month means of Atlantic monthly pressure/height omega anomalies removed trend onto November-December-January
;     cold tongue index in CMIP model for animations
;
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-02-07
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------omega
;   var3--------------ts
;   var4--------------wap
;================================================

    process = False      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1a = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name1b = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
    in_name1c = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/omega.mon.mean.nc"
;    in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"

    in_path3     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name3     = new(36,string)
    in_name3(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(2)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;    in_name3(3)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;;    in_name3(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name3(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(5)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(6)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(7)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(8)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(9)  = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(10) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(16) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name3(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name3(18) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name3(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name3(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name3(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name3(26) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
;    in_name3(27) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(20) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name3(21) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(22) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(23) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(24) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(25) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name3(26) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name3(27) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(28) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(29) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(30) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(31) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(32) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(33) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name3(34) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name3(35) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name3)

    in_path4     = "~/data-model/CMIP5-hes/wap/historical/"
    in_name4     = new(nmod,string)
    in_name4(0)  = "wap_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "wap_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "wap_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(2)  = "wap_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(3)  = "wap_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(3)  = "wap_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(5)  = "wap_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6)  = "wap_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7)  = "wap_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8)  = "wap_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9)  = "wap_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "wap_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "wap_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "wap_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "wap_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(8)  = "wap_Amon_CNRM-CM5-2_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(9)  = "wap_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(15) = "wap_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(10)  = "wap_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(17) = "wap_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "wap_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(12) = "wap_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name4(13) = "wap_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "wap_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(15) = "wap_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "wap_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "wap_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "wap_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "wap_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name4(26) = "wap_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    in_name4(20) = "wap_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(20) = "wap_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name4(21) = "wap_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(22) = "wap_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(23) = "wap_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(24) = "wap_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(25) = "wap_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(26) = "wap_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name4(27) = "wap_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(28) = "wap_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(29) = "wap_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(30) = "wap_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(31) = "wap_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(32) = "wap_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(33) = "wap_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
    in_name4(34) = "wap_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(35) = "wap_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical North Atlantic
    latN1 = 25
    latS1 = 5
    lonW1 = 305 
    lonE1 = 345

;region
    latN = 70
    latS = -40
    levU = 100
    levM = 700
    levL = 1000

; create points for box
    ypts = (/levU,levL,levL,levU/)
    xpts = (/latS1,latS1,latN1,latN1/)
    xt = 15.0
    yt = 850.0
    yb = (/levM,levM,levL,levL,levM/)
    xb = (/latN1-0.4,latS1+0.4,latS1+0.4,latN1-0.4,latN1-0.4/)

;fig
    out_path = "~/hes/ENSO/Asymmetry/Fig/Animation/"
    out_data = "./lag_regress_NDJ_CTI_and_lon_p_h_wap_anom_remove_trend_CMIP.nc"
    out_name = "lag_regress_NDJ_CTI_and_lon_p_h_wap_anom_remove_trend_CMIP_"

;text
    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"/)
    text2 = (/"b) HadISST","d)","f) ","d) MMM"/)
;    text2 = (/"b)","d)","f)","h)"/)
    text3 = "Pa~F34~W~F~s~S~-1~N~/~F35~J~F~C"
;    text4 = (/"-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9"/)

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

    ts = in3->ts(iYYYY3,:,:)
    if(i.eq.4 .or. i.eq.6 .or. i.eq.27 .or. i.eq.28)then
     wap = in4->wap(iYYYY4,(/0,1,2,3,4,5,6,7,8,9,11,14/),:,:)
    else if(i.eq.12)then
     wap = in4->wap(iYYYY4,(/0,1,2,4,5,6,7,8,9,10,11,12/),:,:)
    else
     wap = in4->wap(iYYYY4,{:10000},:,:)
    end if
    end if
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

    if(i.eq.0)then

     in1a = addfile(in_name1a, "r")
     in1b = addfile(in_name1b, "r")
     in1c = addfile(in_name1c, "r")
     in2 = addfile(in_name2, "r")
     time1a = in1a->time
     time1b = in1b->time
     time1c = in1c->time
     time2 = in2->time
     year1a = cd_calendar(time1a, -1) / 100
     year1b = cd_calendar(time1b, -1) / 100
     year1c = cd_calendar(time1c, -1) / 100
     year2 = cd_calendar(time2, -1) / 100
     iYYYY1a = ind(year1a.ge.yS .and. year1a.le.yE)
     iYYYY1b = ind(year1b.ge.yS .and. year1b.le.yE)
     iYYYY1c = ind(year1c.ge.yS .and. year1c.le.yE)
     iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst1 = in1a->sst(iYYYY1a,:,:)
     sst2 = in1b->sst(iYYYY1b,:,:)
     sst3 = in1c->sst(iYYYY1c,:,:)
     omega = in2->omega(iYYYY2,{:100},:,:)
;     omega  = in2->uwnd(iYYYY2,{:100},:,:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))

;-------------------------------------------------------------
     lat3 = in3->lat
     lat  = in4->lat
     plev = in4->plev({:10000})

;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw = cos (rad*lat3)
     copy_VarCoords (lat3,gw)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm3 = clmMonTLL (ts)
   clm4 = clmMonTLLL (wap)
   tsA  = calcMonAnomTLL (ts,clm3)
   wapA = calcMonAnomTLLL (wap,clm4)
   tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
   wapA = (/dtrend_msg_n (wapA&time,wapA,False,False,0)/)

;compute seasonal means
   tsA_S  = month_to_season (tsA,season(6))
   wapA_S = month_to_seasonN (wapA,season)
   dim    = dimsizes (wapA_S)

;--------------------------------------------------------------
;cold tongue (NDJ)
   I2_NDJ = wgt_areaave_Wrap ( tsA_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
;the Atlantic
   wapA_A = dim_avg_n_Wrap ( wapA_S(:,:,:,:,{lonW1:lonE1}), 4)

;--------------------------------------------------------------
   if(i.eq.0)then
    mnmn = new((/dim(0),dim(2),dim(3),nmod+4/),float)
    copy_VarMeta (wapA_A(:,0,:,:),mnmn(:,:,:,0))
    mnmn!3 = "nmod"
   end if

;compute linear regression
   mnmn(:,:,:,i+4)  = (/regCoef_n (I2_NDJ,wapA_A,0,1)/)
   mnmn(7:,:,:,i+4) = (/regCoef_n (I2_NDJ(:dim(1)-2),wapA_A(7:,1:,:,:),0,1)/)

   if(i.eq.0)then
    clm1a = clmMonTLL(sst1)
    clm1b = clmMonTLL(sst2)
    clm1c = clmMonTLL(sst3)
    clm2 = clmMonTLLL(omega)
    sstA1 = calcMonAnomTLL(sst1, clm1a)
    sstA2 = calcMonAnomTLL(sst2, clm1b)
    sstA3 = calcMonAnomTLL(sst3, clm1c)
    omegaA = calcMonAnomTLLL(omega, clm2)
    sstA1 = (/dtrend_msg_n(sstA1&time, sstA1, False, False, 0)/)
    sstA2 = (/dtrend_msg_n(sstA2&time, sstA2, False, False, 0)/)
    sstA3 = (/dtrend_msg_n(sstA3&time, sstA3, False, False, 0)/)
    omegaA = (/dtrend_msg_n(omegaA&time, omegaA, False, False, 0)/)
    sstA1_S = month_to_season(sstA1, season(6))
    sstA2_S = month_to_season(sstA2, season(6))
    sstA3_S = month_to_season(sstA3, season(6))
    omegaA_S = month_to_seasonN(omegaA, season)
    I1_NDJ = wgt_areaave_Wrap(sstA1_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I2_NDJ = wgt_areaave_Wrap(sstA2_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    I3_NDJ = wgt_areaave_Wrap(sstA3_S(:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    omegaA_A = dim_avg_n_Wrap(omegaA_S(:,:,:,:,{lonW1:lonE1}), 4)
    mnmn(:,:,:,0) = (/regCoef_n(I1_NDJ, omegaA_A, 0, 1)/)
    mnmn(:,:,:,1) = (/regCoef_n(I2_NDJ, omegaA_A, 0, 1)/)
    mnmn(:,:,:,2) = (/regCoef_n(I3_NDJ, omegaA_A, 0, 1)/)
    mnmn(7:,:,:,0) = (/regCoef_n(I1_NDJ(:dim(1)-2), omegaA_A(7:,1:,:,:), 0, 1)/)
    mnmn(7:,:,:,1) = (/regCoef_n(I2_NDJ(:dim(1)-2), omegaA_A(7:,1:,:,:), 0, 1)/)
    mnmn(7:,:,:,2) = (/regCoef_n(I3_NDJ(:dim(1)-2), omegaA_A(7:,1:,:,:), 0, 1)/)
    mnmn(:,:,:,:2) = (/mnmn(:,:,::-1,:2)/)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time3,time4,year3,year4/])

end do

   mnmn(:,:,:,3) = dim_avg(mnmn(:,:,:,4:))
   printVarSummary(mnmn)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","plev","lat","nmod"/)
dimSizes = dimsizes(mnmn)
dimUnlim = (/False,False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer", "season")
filevardef (fout,"plev",  typeof(plev),getvardims(plev))
filevardef (fout,"lat",   typeof(lat),getvardims(lat))
filevardef (fout,"nmod",  "integer", "nmod")
filevardef (fout,"mnmn",  typeof(mnmn),getvardims(mnmn))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"plev",plev)
filevarattdef (fout,"lat",lat)
filevarattdef (fout,"mnmn",mnmn)

;output only the data values
fout->season = ispan(1,dim(0),1)
fout->plev   = (/plev/)
fout->lat    = (/lat/)
fout->nmod   = ispan(1,nmod+4,1)
fout->mnmn   = (/mnmn/)

else

 in   = addfile (out_data,"r")
 mnmn = in->mnmn
 dim  = dimsizes (mnmn)
 printVarSummary (mnmn)

end if

; ==============================================================
; Mission 4. Draw the differences
; ==============================================================

res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .028

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.008,-.004,-.002,-.001,.001,.002,.004,.008/)
;res@cnLevels             = (/-2.,-1.,-.5,-.25,.25,.5,1.,2./)

res@lbLabelBarOn = False

res@vpHeightF = 0.35
;res@vpWidthF = 0.6

res@tmXBTickSpacingF     = 30.
res@tmXBLabelFontHeightF = 0.024
res@tmYLLabelFontHeightF = 0.024

res@tiYAxisFontHeightF = 0.029

;************************************************
; add the box
;************************************************
resb                   = True         ; polyline mods desired
resb@gsLineThicknessF  = 3.0          ; thickness of lines

tres = True
tres@txFontColor = "white"
tres@txFontHeightF = 0.034

pgres = True
pgres@gsFillColor = "red"
pgres@gsFillOpacityF = 0.4

dum = new((/4,2/), graphic)  

;*******************************************
;create panel resources
;*******************************************
resP = True
;resP@txFontHeightF = 0.023
resP@txFontHeightF = 0.03
resP@gsnPanelBottom = 0.04
resP@gsnPanelLabelBar = True
;resP@lbLabelFontHeightF = 0.014
resP@lbLabelFontHeightF = 0.021
resP@pmLabelBarOrthogonalPosF = -0.008

;----------------------------------------------------------
do i = 0, dim(0)-1

    wks = gsn_open_wks("svg", out_path + out_name + text1(i))
    plot = new(4, graphic)
    do j = 0, 3
        res@gsnLeftString = text2(j)
        if(j.eq.0)then
            res@gsnRightString = text3
        else
            res@gsnRightString = " "
        end if
        plot(j) = gsn_csm_pres_hgt(wks, mnmn(i,:,{latS:latN},j), res)
    end do

;----------------------------------------------------------
    do j = 0, 2, 2
        do k = 0, 3
            dum(k,j/2) = gsn_add_polyline(wks, plot(k), xpts(j:j+1), ypts(j:j+1), resb)
        end do
    end do 
    text = gsn_add_text(wks, plot(0), "TNA", xt, yt, tres)
    gon = gsn_add_polygon(wks, plot(0), xb, yb, pgres)

    resP@txString = "Regression of Omega onto NDJ CTI"
;    gsn_panel (wks,plot,(/4,1/),resP)
    gsn_panel (wks,plot((/0,3/)),(/2,1/),resP)

    delete([/wks,plot/])
end do

end
