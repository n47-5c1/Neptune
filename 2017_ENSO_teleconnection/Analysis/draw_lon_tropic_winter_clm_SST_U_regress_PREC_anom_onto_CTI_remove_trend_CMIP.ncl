;*************************************************************
;Aim: Draw climatology of sea surface temperature as well as tropospheric zonal wind and regression of precipitation anomalies removed trend
;     onto the cold tongue index along the equator in winter and spring in CMIP
;
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-05-29
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;   var3--------------prate
;   var4--------------ts
;   var5--------------ua
;   var6--------------pr
;================================================

process = False   ; true for statistics, false for plot

;data
;HadISST1   1870/01 - , 1x1
in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR
in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
in_name3 = "~/data-observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;CMIP5
in_path4 = "~/data-model/CMIP5-hes/ts/historical/"
in_name4 = new(37, string)
in_name4(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
in_name4(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
in_name4(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
in_name4(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
in_name4(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
in_name4(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name4(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name4(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
in_name4(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
in_name4(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
in_name4(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
in_name4(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
in_name4(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
in_name4(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
in_name4(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
nmod = dimsizes(in_name4)

in_path5 = "~/data-model/CMIP5-hes/ua/historical/"
in_name5 = new(nmod, string)
in_name5(0) = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(1) = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(2) = "ua_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name5(3) = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(4) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(5) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(6) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(7) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name5(8) = "ua_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(9) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(10) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(11) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name5(12) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
in_name5(13) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name5(14) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name5(15) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(16) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name5(17) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(18) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name5(19) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
in_name5(20) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name5(21) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name5(22) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(23) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(24) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(25) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(26) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name5(27) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name5(28) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(29) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(30) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(31) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(32) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(33) = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(34) = "ua_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name5(35) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(36) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

in_path6 = "~/data-model/CMIP5-hes/pr/historical/"
in_name6 = new(nmod, string)
in_name6(0) = "pr_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
in_name6(1) = "pr_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
in_name6(2) = "pr_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
in_name6(3) = "pr_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
in_name6(4) = "pr_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
in_name6(5) = "pr_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
in_name6(6) = "pr_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
in_name6(7) = "pr_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
in_name6(8) = "pr_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
in_name6(9) = "pr_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
in_name6(10) = "pr_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
in_name6(11) = "pr_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
in_name6(12) = "pr_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
in_name6(13) = "pr_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
in_name6(14) = "pr_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
in_name6(15) = "pr_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
in_name6(16) = "pr_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name6(17) = "pr_Amon_GISS-E2-R_historical_r1i1p1_192601-200512_T62.nc"
in_name6(18) = "pr_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
in_name6(19) = "pr_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
in_name6(20) = "pr_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
in_name6(21) = "pr_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
in_name6(22) = "pr_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
in_name6(23) = "pr_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name6(24) = "pr_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name6(25) = "pr_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name6(26) = "pr_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
in_name6(27) = "pr_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
in_name6(28) = "pr_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
in_name6(29) = "pr_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
in_name6(30) = "pr_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
in_name6(31) = "pr_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
in_name6(32) = "pr_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
in_name6(33) = "pr_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
in_name6(34) = "pr_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
in_name6(35) = "pr_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
in_name6(36) = "pr_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

iM =(/9,26,27,28,29/)

;time
yS = 1958
yE = 2004
mS = 12
mE = 5
iMM1 = (/11,0,1,2,3,4/)

;arguments required by vertical mean
;pnew = (/1000,925,850,700,600,500,400,300,250,200/)
pnew = (/850,700,600,500,400,300,250,200/)
pver = pnew * 100
pver@units = "Pa"
dp = dpres_plevel_Wrap(pver, 100000, 20000, 0)
sumdp = sum(dp)

;cold tongue
latNI = 6
latSI = -6
lonWI = 180
lonEI = 270
;Nino3
;latNI = 5
;latSI = -5
;lonWI = 210
;lonEI = 270
;Nino3.4
;latNI = 5
;latSI = -5
;lonWI = 190
;lonEI = 240

;tropical Indian Ocean
lonW1 = 50
lonE1 = 100

;tropical North Atlantic
;lonW2 = 305 
;lonE2 = 345

;region
latN = 5
latS = -5
;lonW = 120
;lonE = 280

;fig
out_path1 = "~/hes/ENSO/Asymmetry/NCL/"
out_path2 = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "lon_tropic_winter_clm_SST_U_regress_PREC_anom_onto_CTI_remove_trend_CMIP.nc"
out_name = "lon_tropic_winter_clm_SST_U_regress_PREC_anom_onto_CTI_remove_trend_CMIP"

;text
text1 = (/"a) SST","b) U850-200","b) U200","d) U500","f) U850","c) PREC"/)
text2 = "5~F35~J~F~S - 5~F35~J~F~N, Dec-May"
text3 = (/"(~F35~J~F~C)","(m/s)","(mm~F34~W~F~d~S~-1~N~/~F35~J~F~C)"/)
colors = (/"black","blue","red"/)
text4 = (/"HadISST","CMIP5","1st cluster"/)

if(process) then

do i = 0, nmod-1

   print(i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

   in4 = addfile(in_path4 + in_name4(i), "r")
   in5 = addfile(in_path5 + in_name5(i), "r")
   in6 = addfile(in_path6 + in_name6(i), "r")

;get the time indexs
   time4 = in4->time
   time5 = in5->time
   time6 = in6->time
   TIME4 = cd_calendar(time4, 0)
   TIME5 = cd_calendar(time5, 0)
   TIME6 = cd_calendar(time6, 0)
   iYYYY4 = ind (TIME4(:,0) .ge. yS .and. TIME4(:,0) .le. yE)
   iYYYY5 = ind (TIME5(:,0) .ge. yS .and. TIME5(:,0) .le. yE)
   iYYYY6 = ind (TIME6(:,0) .ge. yS .and. TIME6(:,0) .le. yE)

   ts = in4->ts(iYYYY4,:,:)
   ua_p = in5->ua(iYYYY5,{pver},:,:)
   dim_p = dimsizes(ua_p)
   ua = new((/dim_p(0),4,dim_p(2),dim_p(3)/), float)
   ua(:,1:,:,:) = ua_p(:,{(/20000,50000,85000/)},:,:)
   pr = in6->pr(iYYYY6,:,:)
;   sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

   if(i .eq. 0)then
      in1 = addfile(in_name1, "r")
      in2 = addfile(in_name2, "r")
      in3 = addfile(in_name3, "r")
      lon1 = in1->lon
      lon2 = in2->lon
      lon3 = in3->lon
      time1 = in1->time
      time2 = in2->time
      time3 = in3->time
      TIME1 = cd_calendar(time1, 0)
      TIME2 = cd_calendar(time2, 0)
      TIME3 = cd_calendar(time3, 0)
      iYYYY1 = ind(TIME1(:,0) .ge. yS .and. TIME1(:,0) .le. yE)
      iYYYY2 = ind(TIME2(:,0) .ge. yS .and. TIME2(:,0) .le. yE)
      iYYYY3 = ind(TIME3(:,0) .ge. yS .and. TIME3(:,0) .le. yE)
      iMM2 = ind(TIME3(iYYYY3,1) .ge. mS .or. TIME3(iYYYY3,1) .le. mE)
      sst = in1->sst(iYYYY1,:,:)
      uwnd_p = in2->uwnd(iYYYY2,{pnew},:,:)
      uwnd = new((/dim_p(0),4,dim_p(2),dim_p(3)/), float)
      uwnd(:,1:,:,:) = uwnd_p(:,{(/200,500,850/)},:,:)
      prate = in3->prate(iYYYY3,:,:)
   end if

;-------------------------------------------------------------
;creat weights: cos(lat)
   rad = 4. * atan(1.) / 180.
   gw1 = in1->lat
   gw2 = in2->lat
   gw3 = in3->lat
;   gw3 = in3->latitude
   gw1 = cos(rad * gw1)
   gw2 = cos(rad * gw2)
   gw3 = cos(rad * gw3)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate the vertical mean
   if(i .eq. 0)then
    dp_cfm = conform_dims(dimsizes(ua_p), dp, 1)
   end if
   ua(:,0,:,:) = (/dim_sum_n(dp_cfm * ua_p / sumdp, 1)/)

;monthly anomalies
   clm4 = clmMonTLL(ts)
   clm5 = clmMonTLLL(ua)
   clm6 = clmMonTLL(pr)
   tsA = calcMonAnomTLL(ts, clm4)
   prA = calcMonAnomTLL(pr, clm6)
   tsA = (/dtrend_msg_n(tsA&time, tsA, False, False, 0)/)
   prA = (/dtrend_msg_n(prA&time, prA, False, False, 0)/)
   ts_x = dim_avg_wgt_n_Wrap(clm4(:,{latN:latS},:), gw1({latN:latS}), 1, 1)
   ua_x = dim_avg_wgt_n_Wrap(clm5(:,:,{latN:latS},:), gw2({latN:latS}), 1, 2)
   pr_x = dim_avg_wgt_n_Wrap(prA(iMM2,{latN:latS},:), gw3({latN:latS}), 1, 1)
   dim1 = dimsizes(ts_x)
   dim2 = dimsizes(ua_x)
   dim3 = dimsizes(pr_x)

;cold tongue
   CTI2 = wgt_areaave_Wrap(tsA(iMM2,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)

;--------------------------------------------------------------
   if(i .eq. 0)then
      ts_clm = new((/dim1(1),nmod+3/), float)
      ua_clm = new((/dim2(1),dim2(2),nmod+3/), float)
      rc = new((/dim3(1),nmod+3/), float)
      ts_clm!1 = "member"
      ua_clm!2 = "member"
      rc!1 = "member"
      copy_VarMeta(ts_x(0,:), ts_clm(:,0))
      copy_VarMeta(ua_x(0,:,:), ua_clm(:,:,0))
      copy_VarMeta(pr_x(0,:), rc(:,0))
      ts_clm!0 = "lon1"
      ua_clm!1 = "lon2"
      rc!0 = "lon3"
   end if

   ts_clm(:,i+3) = dim_avg_n(ts_x(iMM1,:), 0) - 273.16
   ua_clm(:,:,i+3) = (/dim_avg_n(ua_x(iMM1,:,:), 0)/)
   rc(:,i+3) = (/regCoef_n(CTI2, pr_x, 0, 0)/)

   if(i .eq. 0)then
      uwnd(:,0,:,:) = (/dim_sum_n(dp_cfm * uwnd_p / sumdp, 1)/)
      clm1 = clmMonTLL(sst)
      clm2 = clmMonTLLL(uwnd)
      clm3 = clmMonTLL(prate)
      sstA = calcMonAnomTLL(sst, clm1)
      prateA = calcMonAnomTLL(prate, clm3)
      sstA = (/dtrend_msg_n(sstA&time, sstA, False, False, 0)/)
      prateA = (/dtrend_msg_n(prateA&time, prateA, False, False, 0)/)
      sst_x = dim_avg_wgt_n_Wrap(clm1(:,{latN:latS},:), gw1({latN:latS}), 1, 1)
      uwnd_x = dim_avg_wgt_n_Wrap(clm2(:,:,{latN:latS},:), gw2({latN:latS}), 1, 2)
      prate_x = dim_avg_wgt_n_Wrap(prateA(iMM2,{latN:latS},:), gw3({latN:latS}), 1, 1)
      CTI1 = wgt_areaave_Wrap(sstA(iMM2,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)
      ts_clm(:,0) = (/dim_avg_n(sst_x(iMM1,:), 0)/)
      ua_clm(:,:,0) = (/dim_avg_n(uwnd_x(iMM1,:,:), 0)/)
      rc(:,0) = (/regCoef_n(CTI1, prate_x, 0, 0)/)
   end if

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time4,time5,time6,TIME4,TIME5,TIME6/])

end do

ts_clm(:,1) = dim_avg(ts_clm(:,3:))
ua_clm(:,:,1) = dim_avg(ua_clm(:,:,3:))
rc(:,1) = dim_avg(rc(:,3:))
ts_clm(:,2) = dim_avg(ts_clm(:,iM+3))
ua_clm(:,:,2) = dim_avg(ua_clm(:,:,iM+3))
rc(:,2) = dim_avg(rc(:,iM+3))

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system("rm -f " + out_path1 + out_data)
fout = addfile(out_path1 + out_data, "c")
setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"plev","lon1","lon2","lon3","member"/)
dimSizes = (/4,dim1(1),dim2(2),dim3(1),nmod+3/)
dimUnlim = (/False,False,False,False,False/)

filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef(fout, "plev", "integer", "plev")
filevardef(fout, "lon1", typeof(lon1), "lon1")
filevardef(fout, "lon2", typeof(lon2), "lon2")
filevardef(fout, "lon3", typeof(lon3), "lon3")
filevardef(fout, "member", "integer", "member")
filevardef(fout, "ts_clm", typeof(ts_clm), getvardims(ts_clm))
filevardef(fout, "ua_clm", typeof(ua_clm), getvardims(ua_clm))
filevardef(fout, "rc", typeof(rc), getvardims(rc))

;Copy attributes associated with each variable to the file
filevarattdef(fout, "lon1", lon1)
filevarattdef(fout, "lon2", lon2)
filevarattdef(fout, "lon3", lon3)
filevarattdef(fout, "ts_clm", ts_clm)
filevarattdef(fout, "ua_clm", ua_clm)
filevarattdef(fout, "rc", rc)

;output only the data values
fout->plev = ispan(1, 4, 1)
fout->lon1 = (/lon1/)
fout->lon2 = (/lon2/)
fout->lon3 = (/lon3/)
fout->member = ispan(1, nmod+3, 1)
fout->ts_clm = (/ts_clm/)
fout->ua_clm = (/ua_clm/)
fout->rc = (/rc/)

else

in = addfile(out_path1 + out_data, "r")
ts_clm = in->ts_clm({:280},:)
ua_clm = in->ua_clm(:,{:280},:)
rc = in->rc({:280},:)
rc = (/ rc / 10^3 * 1000 * 60 * 60 * 24 /)

end if

printVarSummary(rc)
;ccr = lonPivot (ccr,25)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks = gsn_open_wks("svg", out_path2 + out_name)
plot = new(6, graphic)
dum1 = new(5, graphic)
dum2 = new(6, graphic)
dum3 = new(6, graphic)

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.021

;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisFontHeightF = 0.021

res@xyLineColors = colors
res@xyDashPatterns = 0
res@xyLineThicknessF = 2
res@xyExplicitLegendLabels = text4

;Manually creating a legend
res@pmLegendWidthF = 0.07
res@pmLegendHeightF = 0.09
res@pmLegendSide = "Top"
res@pmLegendParallelPosF = 0.86
res@pmLegendOrthogonalPosF = -0.6

res@lgPerimOn = False
res@lgLabelFontHeightF = 0.018

res@vpWidthF = 0.75
res@vpHeightF = 0.25

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
res@tiYAxisString = text3(0)
;res@trYMaxF = 1.7
res@trYMinF = 26.
res@trXMaxF = 210.
res@trXMinF = 90.
res@pmLegendDisplayMode = "Always"
plot(0) = gsn_csm_xy(wks, ts_clm&lon1, ts_clm(member|:2,lon1|:), res)

res@gsnLeftString = text1(1)
res@gsnCenterString = " "
res@tiYAxisString = text3(1)
delete(res@trYMinF)
res@trXMaxF = 150
res@trXMinF = 30
res@pmLegendDisplayMode = "NoCreate"
plot(2) = gsn_csm_xy(wks, ua_clm&lon2, ua_clm(plev|0,member|:2,lon2|:), res)

res@gsnLeftString = text1(2)
;plot(1) = gsn_csm_xy(wks, ua_clm&lon2, ua_clm(plev|1,member|:2,lon2|:), res)

res@gsnLeftString = text1(3)
;plot(3) = gsn_csm_xy(wks, ua_clm&lon2, ua_clm(plev|2,member|:2,lon2|:), res)

res@gsnLeftString = text1(4)
;plot(5) = gsn_csm_xy(wks, ua_clm&lon2, ua_clm(plev|3,member|:2,lon2|:), res)

res@gsnLeftString = text1(5)
res@tiYAxisString = text3(2)
res@trXMaxF = 210
res@trXMinF = 90
plot(4) = gsn_csm_xy(wks, rc&lon3, rc(member|:2,lon3|:), res)

;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
;resl@gsLineDashPattern = 1
dum1(0) = gsn_add_polyline(wks, plot(1), (/0,360/), (/0,0/), resl)
dum1(1) = gsn_add_polyline(wks, plot(2), (/0,360/), (/0,0/), resl)
dum1(2) = gsn_add_polyline(wks, plot(3), (/0,360/), (/0,0/), resl)
dum1(3) = gsn_add_polyline(wks, plot(4), (/0,360/), (/0,0/), resl)
dum1(4) = gsn_add_polyline(wks, plot(5), (/0,360/), (/0,0/), resl)
resl@gsLineThicknessF  = 1
resl@gsLineDashPattern = 0
dum2(0) = gsn_add_polyline(wks, plot(0), (/lonW1,lonW1/), (/20,35/), resl)
dum2(1) = gsn_add_polyline(wks, plot(1), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(2) = gsn_add_polyline(wks, plot(2), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(3) = gsn_add_polyline(wks, plot(3), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(4) = gsn_add_polyline(wks, plot(4), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(5) = gsn_add_polyline(wks, plot(5), (/lonW1,lonW1/), (/-20,20/), resl)
dum3(0) = gsn_add_polyline(wks, plot(0), (/lonE1,lonE1/), (/20,35/), resl)
dum3(1) = gsn_add_polyline(wks, plot(1), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(2) = gsn_add_polyline(wks, plot(2), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(3) = gsn_add_polyline(wks, plot(3), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(4) = gsn_add_polyline(wks, plot(4), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(5) = gsn_add_polyline(wks, plot(5), (/lonE1,lonE1/), (/-20,20/), resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
;resP@gsnPanelBottom = 0.04
resP@txFontHeightF = 0.021
resP@txString = "CLM SST, U, and RC of P onto CTI"

gsn_panel(wks, plot((/0,2,4/)), (/3,1/), resP)

end
