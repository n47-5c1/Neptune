;*************************************************************
;Aim: Draw the climatology of the regional tropospheric wind at 200 hPa, 500 hPa, and 850 hPa in CMIP
;
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-06-07
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var3--------------prate
;   var4--------------ua
;   var5--------------va
;   var6--------------pr
;================================================

process = False   ; true for statistics, false for plot

;data
;NCEP/NCAR
in_name1 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"
in_name2 = "~/data/observation/NCEP_NCAR/monthly/vwnd.mon.mean.nc"
in_name3 = "~/data-observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"

in_name7 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;CMIP5
in_path4 = "~/data-model/CMIP5-hes/ua/historical/"
in_name4 = new(37, string)
in_name4(0) = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(1) = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(2) = "ua_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name4(3) = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(4) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(5) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(6) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(7) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name4(8) = "ua_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(9) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(10) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(11) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name4(12) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
in_name4(13) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name4(14) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name4(15) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(16) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name4(17) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(18) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name4(19) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
in_name4(20) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name4(21) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name4(22) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(23) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(24) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(25) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(26) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name4(27) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name4(28) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(29) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(30) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(31) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(32) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(33) = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(34) = "ua_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name4(35) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name4(36) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"
nmod = dimsizes(in_name4)

in_path5 = "~/data-model/CMIP5-hes/va/historical/"
in_name5 = new(nmod, string)
in_name5(0) = "va_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(1) = "va_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(2) = "va_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name5(3) = "va_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(4) = "va_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(5) = "va_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(6) = "va_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(7) = "va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name5(8) = "va_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(9) = "va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(10) = "va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(11) = "va_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
in_name5(12) = "va_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
in_name5(13) = "va_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name5(14) = "va_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
in_name5(15) = "va_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(16) = "va_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name5(17) = "va_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(18) = "va_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
in_name5(19) = "va_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
in_name5(20) = "va_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name5(21) = "va_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
in_name5(22) = "va_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(23) = "va_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(24) = "va_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(25) = "va_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(26) = "va_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
in_name5(27) = "va_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
in_name5(28) = "va_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(29) = "va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(30) = "va_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(31) = "va_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(32) = "va_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(33) = "va_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(34) = "va_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
in_name5(35) = "va_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
in_name5(36) = "va_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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

in_path8 = "~/data-model/CMIP5-hes/ts/historical/"
in_name8 = new(nmod, string)
in_name8(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
in_name8(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
in_name8(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
in_name8(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
in_name8(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
in_name8(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name8(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name8(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
in_name8(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
in_name8(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
in_name8(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
in_name8(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
in_name8(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
in_name8(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
in_name8(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"

iM =(/9,26,27,28,29/)

;time
yS = 1958
yE = 2004
mS = 12
mE = 5
iMM = (/11,0,1,2,3,4/)

pnew = (/200,500,850/)
;pnew = (/850,700,600,500,400,300,250,200/)
pver = pnew * 100

;tropical Indian Ocean
latN1 = 10
latS1 = -10
lonW1 = 50
lonE1 = 100

;tropical North Atlantic
;lonW2 = 305 
;lonE2 = 345

;region
latN = 20
latS = -40
lonW = 30
lonE = 240

;fig
out_path1 = "~/hes/ENSO/Asymmetry/NCL/"
out_path2 = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "clm_reg_winter_spring_200_500_850_wind_model.nc"
out_name = "clm_reg_winter_spring_200_500_850_wind_model"

;text
text1 = (/"a) 200 hPa","b)","a) 200 hPa","d) 500 hPa","e)","b) 500 hPa","g) 850 hPa","h)","c) 850 hPa"/)
text2 = (/"OBS","MMM","1st cluster - CMIP5"/)
text3 = (/"PREC","UWND","SST","mm/d","m/s","~F35~J~F~C"/)

if(process) then

do i = 0, nmod-1

   print(i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

   in4 = addfile(in_path4 + in_name4(i), "r")
   in5 = addfile(in_path5 + in_name5(i), "r")
   in6 = addfile(in_path6 + in_name6(i), "r")
   in8 = addfile(in_path8 + in_name8(i), "r")

;get the time indexs
   time4 = in4->time
   time6 = in6->time
   time8 = in8->time
   TIME4 = cd_calendar(time4, 0)
   TIME6 = cd_calendar(time6, 0)
   TIME8 = cd_calendar(time8, 0)
   iYYYY4 = ind (TIME4(:,0) .ge. yS .and. TIME4(:,0) .le. yE)
   iYYYY6 = ind (TIME6(:,0) .ge. yS .and. TIME6(:,0) .le. yE)
   iYYYY8 = ind (TIME8(:,0) .ge. yS .and. TIME8(:,0) .le. yE)

   ua = in4->ua(iYYYY4,{pver},:,:)
   va = in5->va(iYYYY4,{pver},:,:)
   pr = in6->pr(iYYYY6,:,:)
   ts = in8->ts(iYYYY8,:,:)

   if(i .eq. 0)then
      in1 = addfile(in_name1, "r")
      in2 = addfile(in_name2, "r")
      in3 = addfile(in_name3, "r")
      in7 = addfile(in_name7, "r")
      lon1 = in1->lon
      lon3 = in3->lon
      lon7 = in7->lon
      lat1 = in1->lat(::-1)
      lat3 = in3->lat(::-1)
      lat7 = in7->lat
      time1 = in1->time
      time3 = in3->time
      time7 = in7->time
      TIME1 = cd_calendar(time1, 0)
      TIME3 = cd_calendar(time3, 0)
      TIME7 = cd_calendar(time7, 0)
      iYYYY1 = ind(TIME1(:,0) .ge. yS .and. TIME1(:,0) .le. yE)
      iYYYY3 = ind(TIME3(:,0) .ge. yS .and. TIME3(:,0) .le. yE)
      iYYYY7 = ind(TIME7(:,0) .ge. yS .and. TIME7(:,0) .le. yE)
      uwnd = in1->uwnd(iYYYY1,{pnew},::-1,:)
      vwnd = in2->vwnd(iYYYY1,{pnew},::-1,:)
      prate = in3->prate(iYYYY3,::-1,:)
      sst   = in7->sst(iYYYY7,:,:)
   end if

;printVarSummary(ua)
;printVarSummary(va)
;printVarSummary(uwnd)
;printVarSummary(vwnd)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm4 = clmMonTLLL(ua)
   clm5 = clmMonTLLL(va)
   clm6 = clmMonTLL(pr)
   clm8 = clmMonTLL(ts)
   dim1 = dimsizes(clm4)
   dim2 = dimsizes(clm6)
   dim3 = dimsizes(clm8)

;--------------------------------------------------------------
   if(i .eq. 0)then
      ua_clm = new((/dim1(1),dim1(2),dim1(3),nmod+3/), float)
      va_clm = new((/dim1(1),dim1(2),dim1(3),nmod+3/), float)
      pr_clm = new((/dim2(1),dim2(2),nmod+3/), float)
      ts_clm = new((/dim3(1),dim3(2),nmod+3/), float)
      ua_clm!3 = "member"
      va_clm!3 = "member"
      pr_clm!2 = "member"
      ts_clm!2 = "member"
      copy_VarMeta(clm4(0,:,:,:), ua_clm(:,:,:,0))
      copy_VarMeta(clm5(0,:,:,:), va_clm(:,:,:,0))
      copy_VarMeta(clm6(0,:,:), pr_clm(:,:,0))
      copy_VarMeta(clm8(0,:,:), ts_clm(:,:,0))
      ua_clm!1 = "lat1"
      ua_clm!2 = "lon1"
      va_clm!1 = "lat1"
      va_clm!2 = "lon1"
      pr_clm!0 = "lat3"
      pr_clm!1 = "lon3"
      ts_clm!0 = "lat7"
      ts_clm!1 = "lon7"
   end if

   ua_clm(:,:,:,i+3) = (/dim_avg_n(clm4(iMM,:,:,:), 0)/)
   va_clm(:,:,:,i+3) = (/dim_avg_n(clm5(iMM,:,:,:), 0)/)
   pr_clm(:,:,i+3) = (/dim_avg_n(clm6(iMM,:,:), 0)/)
   ts_clm(:,:,i+3) = (/dim_avg_n(clm8(iMM,:,:), 0)/)

   if(i .eq. 0)then
      clm1 = clmMonTLLL(uwnd)
      clm2 = clmMonTLLL(vwnd)
      clm3 = clmMonTLL(prate)
      clm7 = clmMonTLL(sst)
      ua_clm(:,:,:,0) = (/dim_avg_n(clm1(iMM,:,:,:), 0)/)
      va_clm(:,:,:,0) = (/dim_avg_n(clm2(iMM,:,:,:), 0)/)
      pr_clm(:,:,0) = (/dim_avg_n(clm3(iMM,:,:), 0)/)
      ts_clm(:,:,0) = (/dim_avg_n(clm7(iMM,:,:), 0)/)
   end if

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time4,time6,time8,TIME4,TIME6,TIME8/])

end do

ua_clm(:,:,:,1) = dim_avg(ua_clm(:,:,:,3:))
va_clm(:,:,:,1) = dim_avg(va_clm(:,:,:,3:))
pr_clm(:,:,1) = dim_avg(pr_clm(:,:,3:))
ts_clm(:,:,1) = dim_avg(ts_clm(:,:,3:))
ua_clm(:,:,:,2) = dim_avg(ua_clm(:,:,:,iM+3))
va_clm(:,:,:,2) = dim_avg(va_clm(:,:,:,iM+3))
pr_clm(:,:,2) = dim_avg(pr_clm(:,:,iM+3))
ts_clm(:,:,2) = dim_avg(ts_clm(:,:,iM+3))

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system("rm -f " + out_path1 + out_data)
fout = addfile(out_path1 + out_data, "c")
setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"plev","lat1","lat3","lat7","lon1","lon3","lon7","member"/)
dimSizes = (/dim1(1),dim1(2),dim2(1),dim3(1),dim1(3),dim2(2),dim3(2),nmod+3/)
dimUnlim = (/False,False,False,False,False,False,False,False/)

filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef(fout, "plev", "integer", "plev")
filevardef(fout, "lat1", typeof(lat1), "lat1")
filevardef(fout, "lat3", typeof(lat3), "lat3")
filevardef(fout, "lat7", typeof(lat7), "lat7")
filevardef(fout, "lon1", typeof(lon1), "lon1")
filevardef(fout, "lon3", typeof(lon3), "lon3")
filevardef(fout, "lon7", typeof(lon7), "lon7")
filevardef(fout, "member", "integer", "member")
filevardef(fout, "ua_clm", typeof(ua_clm), getvardims(ua_clm))
filevardef(fout, "va_clm", typeof(va_clm), getvardims(va_clm))
filevardef(fout, "pr_clm", typeof(pr_clm), getvardims(pr_clm))
filevardef(fout, "ts_clm", typeof(ts_clm), getvardims(ts_clm))

;Copy attributes associated with each variable to the file
filevarattdef(fout, "lat1", lat1)
filevarattdef(fout, "lat3", lat3)
filevarattdef(fout, "lat7", lat7)
filevarattdef(fout, "lon1", lon1)
filevarattdef(fout, "lon3", lon3)
filevarattdef(fout, "lon7", lon7)
filevarattdef(fout, "ua_clm", ua_clm)
filevarattdef(fout, "va_clm", va_clm)
filevarattdef(fout, "pr_clm", pr_clm)
filevarattdef(fout, "ts_clm", ts_clm)

;output only the data values
fout->plev = (/pver/)
fout->lat1 = (/lat1/)
fout->lat3 = (/lat3/)
fout->lat7 = (/lat7/)
fout->lon1 = (/lon1/)
fout->lon3 = (/lon3/)
fout->lon7 = (/lon7/)
fout->member = ispan(1, nmod+3, 1)
fout->ua_clm = (/ua_clm/)
fout->va_clm = (/va_clm/)
fout->pr_clm = (/pr_clm/)
fout->ts_clm = (/ts_clm/)

else

in = addfile(out_path1 + out_data, "r")
ua_clm = in->ua_clm
va_clm = in->va_clm
pr_clm = in->pr_clm
ts_clm = in->ts_clm

end if

;pr_clm(:,:,1:) = (/ pr_clm(:,:,1:) - 273.16  /)
pr_clm = (/ pr_clm / 10^3 * 1000 * 60 * 60 * 24 /)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks = gsn_open_wks("svg", out_path2 + out_name)
plot1 = new(2, graphic)
plot2 = new(4, graphic)
plot3 = new(3, graphic)

res = True

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = True
res@gsnStringFontHeightF = .019

res@lbLabelBarOn = False

res@tmXBTickSpacingF = 45.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@mpFillOn = False
res@mpCenterLonF = 135
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@stArrowLengthF = 0.01
res@stMinArrowSpacingF = 0.08
res@stLineThicknessF = 1.5
res@stMinDistanceF = 0.05
res@stMinLineSpacingF = 0.004

;--------------------------------------------------------------
ua_clm(:,:,:,2) = (/ua_clm(:,:,:,2) - ua_clm(:,:,:,1)/)
va_clm(:,:,:,2) = (/va_clm(:,:,:,2) - va_clm(:,:,:,1)/)
pr_clm(:,:,2) = (/pr_clm(:,:,2) - pr_clm(:,:,1)/)
ts_clm(:,:,2) = (/ts_clm(:,:,2) - ts_clm(:,:,1)/)

res@cnFillPalette = "WhiteYellowOrangeRed"
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/2.,4.,6.,8.,10./)
;res@cnLevels = (/24.,25.,26.,27.,28.,29./)
res@gsnSpreadColorEnd = 253
res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString = text3(0)
plot1(0) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(0,:,:,0), va_clm(0,:,:,0), pr_clm(:,:,0), res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = " "
plot1(1) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(0,:,:,1), va_clm(0,:,:,1), pr_clm(:,:,1), res)

;--------------------------------------------------------------
res@cnFillPalette = "MPL_coolwarm"
delete(res@cnLevels)
res@cnLevels = (/-6.,-3.,-1.5,0.,1.5,3.,6./)
res@gsnSpreadColorEnd = 127
res@gsnLeftString = text1(3)
res@gsnCenterString = " "
res@gsnRightString = text3(1)
plot2(0) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(1,:,:,0), va_clm(1,:,:,0), ua_clm(1,:,:,0), res)

res@gsnLeftString = text1(4)
res@gsnRightString = text3(2)
plot2(1) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(1,:,:,1), va_clm(1,:,:,1), ua_clm(1,:,:,1), res)

res@gsnLeftString = text1(6)
res@gsnRightString = " "
plot2(2) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(2,:,:,0), va_clm(2,:,:,0), ua_clm(2,:,:,0), res)

res@gsnLeftString = text1(7)
plot2(3) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(2,:,:,1), va_clm(2,:,:,1), ua_clm(2,:,:,1), res)

;--------------------------------------------------------------
res@lbLabelBarOn = True
res@lbOrientation = "vertical"
res@lbLabelJust = "centerright"
res@lbTitleFontHeightF = 0.019
res@lbLabelFontHeightF = 0.018
res@pmLabelBarWidthF = 0.09
delete(res@cnLevels)

res@lbTitleString = text3(3)
res@cnFillPalette = "MPL_RdBu"
res@cnLevels = (/-2.4,-1.2,-0.6,0.6,1.2,2.4/)
res@gsnLeftString = text1(2)
res@gsnCenterString = text2(2)
res@gsnRightString = text3(0)
plot3(0) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(0,:,:,2), va_clm(0,:,:,2), pr_clm(:,:,2), res)

res@lbTitleString = text3(4)
res@cnFillPalette = "MPL_coolwarm"
res@cnLevels = (/-1.6,-0.8,-0.4,0.4,0.8,1.6/)
res@gsnLeftString = text1(5)
res@gsnCenterString = " "
res@gsnRightString = text3(1)
plot3(1) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(1,:,:,2), va_clm(1,:,:,2), ua_clm(1,:,:,2), res)

res@lbTitleString = text3(5)
res@gsnLeftString = text1(8)
res@gsnRightString = text3(2)
plot3(2) = gsn_csm_streamline_contour_map_ce(wks, ua_clm(2,:,:,2), va_clm(2,:,:,2), ts_clm(:,:,2), res)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@lbOrientation = "vertical"
resP@lbLabelFontHeightF = 0.008

resP1 = resP
resP1@gsnPanelTop = 0.663
resP1@gsnPanelBottom = 0.533
resP1@gsnPanelRight = 0.645
;gsn_panel (wks,plot1,(/1,2/),resP1)

resP2 = resP
resP2@gsnPanelTop = 0.552
resP2@gsnPanelBottom = 0.26
resP2@gsnPanelRight = 0.645
;gsn_panel (wks,plot2,(/2,2/),resP2)

resP3 = resP
;resP3@gsnPanelLeft = 0.645
resP3@txFontHeightF = 0.03
resP3@txString = "Climatology of Wind and PREC"
;resP3@txString = "Climatology of Wind and SST"
gsn_panel (wks,plot3,(/3,1/),resP3)

frame(wks)
end
