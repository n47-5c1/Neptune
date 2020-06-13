;*************************************************************
;Aim: Draw a scatter plot of the westward extension of ENSO's SSTAs (estimated by regression of seasonal SSTAs removed trend onto the NDJ cold tongue index) and the maximum
;     cross regression coefficients of 3-month means of area average of monthly SSTAs removed trend in the tropical Indian Ocean onto the NDJ cold tongue index
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   4. Draw the plot
;                       Shan He
;                       2018-04-11
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------prate
;   var3--------------ts
;   var4--------------pr
;================================================

    process = True

;data
    in_name1 = "~/hes/ENSO/NCL/hovmoller_lon_lag_regress_NDJ_CTI_and_Pac_SSTA_remove_trend_CMIP.nc"
;    in_name1 = "~/hes/ENSO/NCL/hovmoller_lon_lag_regress_NDJ_CTI_and_tropic_psl_anom_remove_trend_CMIP.nc"
    in_name2 = "~/hes/ENSO/NCL/scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
;    in_name2 = "~/hes/ENSO/NCL/scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
;    in_name2 = "~/hes/ENSO/NCL/scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
;HadISST1   1870/01 -
    in_name3 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP-NCAR
    in_name4 = "~/data-observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;    in_name4 = "~/data-observation/NCEP_NCAR/monthly/slp.mon.mean.nc"
;CMIP5
    in_path5     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name5     = new(37,string)
    in_name5(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name5(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name5(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name5(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name5(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name5(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name5(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name5(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    in_name5(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name5(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name5(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name5(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name5(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    in_name5(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name5(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name5)

    in_path6     = "~/data-model/CMIP5-hes/pr/historical/"
    in_name6     = new (nmod,string)
    in_name6(0)  = "pr_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(1)  = "pr_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(2)  = "pr_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
    in_name6(3)  = "pr_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(4)  = "pr_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(5)  = "pr_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(6)  = "pr_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(7)  = "pr_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(8)  = "pr_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    in_name6(9)  = "pr_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
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
/;
    in_path6     = "~/data-model/CMIP5-hes/psl/historical/"
    in_name6     = new(nmod,string)
    in_name6(0)  = "psl_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(1)  = "psl_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(2)  = "psl_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name6(3)  = "psl_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(4)  = "psl_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(5)  = "psl_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(6)  = "psl_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(7)  = "psl_Amon_CNRM-CM5_historical_r2i1p1_185001-200512_2.5x2.5.nc"
    in_name6(8)  = "psl_Amon_CNRM-CM5_historical_r2i1p1_185001-200512_2.5x2.5.nc";
    in_name6(9)  = "psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(10) = "psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(11) = "psl_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012.nc"
    in_name6(12) = "psl_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
    in_name6(13) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name6(14) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc";
    in_name6(15) = "psl_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(16) = "psl_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name6(17) = "psl_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(18) = "psl_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name6(19) = "psl_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
    in_name6(20) = "psl_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name6(21) = "psl_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    in_name6(22) = "psl_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(23) = "psl_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(24) = "psl_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(25) = "psl_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(26) = "psl_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name6(27) = "psl_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
    in_name6(28) = "psl_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(29) = "psl_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(30) = "psl_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(31) = "psl_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(32) = "psl_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(33) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(34) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc";
    in_name6(35) = "psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name6(36) = "psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;/
;time
    yS = 1958
    yE = 2004
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    maxlag = dimsizes (season)

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270

;tropical Indian Ocean
;    latN1 = 5
;    latS1 = -5
;    lonW1 = 80
;    lonE1 = 160
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100
;    latN1 = 5
;    latS1 = -5
;    lonW1 = 160
;    lonE1 = 210
;    lonW1 = 180
;    lonE1 = 270

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 240

    R2  = new((/maxlag,nmod/),float)
;    clm = new((/nmod+2/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_west_ext_ENSO_and_max_lag_regress_TIO_SSTA_onto_NDJ_CTI_remove_trend_CMIP.nc"
    out_name = "scatter_west_ext_ENSO_and_max_lag_regress_TIO_SSTA_onto_NDJ_CTI_remove_trend_CMIP"

;text
    text1 = yS+"-"+yE
;    text2 = (/"SSTA (~F35~J~F~C/~F35~J~F~C)","Westward Extension (~F35~J~F~E)"/)
    text2 = (/"STD CTI","PREC (TIO)"/)
;    text2 = (/"WSPD.sfc (TIO)","SLP (MC-WP)"/)
;    text2 = (/"WSPD.sfc (TIO)","LOC SLP.max"/)
;    text2 = (/"WSPD.sfc (TIO)","West EXT (ENSO)"/)
;    text2 = (/"NRS (TIO)","LOC SLP.max"/)
;    text2 = (/"NRS (TIO)","West EXT (ENSO)"/)
;    text2 = (/"NRS (TIO)","PREC (TIO)"/)
;    text2 = (/"NRS (TIO)","SLP (MC-WP)"/)
    text3 = (/"HadISST1","MMM","Model Samples"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors  = (/"red3","dodgerblue2","black"/)
    sizes   = (/.025,.025,.04/)
    indexes = (/5,5,1/)
    thicknesses = (/5.5,5.5,1/)

if (process) then

do i=0,nmod-1
;do i=0,0

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in5 = addfile (in_path5 + in_name5(i),"r")
    in6 = addfile (in_path6 + in_name6(i),"r")

;get the time indexes
    time5  = in5->time
    time6  = in6->time
    year5  = cd_calendar (time5,-1) /100
    year6  = cd_calendar (time6,-1) /100
    iYYYY5 = ind (year5.ge.yS .and. year5.le.yE)
    iYYYY6 = ind (year6.ge.yS .and. year6.le.yE)

    ts = in5->ts(iYYYY5,:,:)
;    pr = in6->psl(iYYYY6,:,:)
    pr = in6->pr(iYYYY6,:,:)

    if(i.eq.0)then

     iM = ind( ispan(1,37+3,1).ne.2 )

     in1 = addfile (in_name1,"r")
     in2 = addfile (in_name2,"r")
     in3 = addfile (in_name3,"r")
     in4 = addfile (in_name4,"r")
     time3  = in3->time
     time4  = in4->time
     year3  = cd_calendar (time3,-1) /100
     year4  = cd_calendar (time4,-1) /100
     iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
     iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)
     ccr   = in1->ccr(3:9,{lonW:lonE},:)
;     ccr   = in1->ccr(3:9,:,:)
     lon   = in1->lon({lonW:lonE})
;     lon   = in1->lon
     mnmx  = in2->mnmx(0,:)
;     mnmx  = in2->mnmx(0,iM)
     std   = in2->std(0)
     sst   = in3->sst(iYYYY3,:,:)
     prate = in4->prate(iYYYY4,:,:)
;     prate = in4->slp(iYYYY4,:,:)
;     prate = 100*prate

     dim     = dimsizes (ccr)
     nlon    = new (dim(0),double)
     pos_lon = new (dim(2),double)

;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
     gw3  = in3->lat
     gw4  = in4->lat
     gw3  = cos (rad*gw3)
     gw4  = cos (rad*gw4)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
    clm5 = clmMonTLL (ts)
    clm6 = clmMonTLL (pr)
    tsA  = calcMonAnomTLL (ts,clm5)
    prA  = calcMonAnomTLL (pr,clm6)
    tsA  = (/dtrend_msg_n (tsA&time,tsA,False,False,0)/)
    prA  = (/dtrend_msg_n (prA&time,prA,False,False,0)/)

;compute seasonal means
    tsA_NDJ = month_to_season (tsA,season(0))
    prA_3M  = month_to_seasonN (prA,season)
;    clma    = month_to_season (clm6,"JFM")

;--------------------------------------------------------------
;cold tongue (NDJ)
    CTI2   = wgt_areaave_Wrap ( tsA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw3({latNI:latSI}), 1., 0)
    pos_lon(i+2) = stddev (CTI2)
    prArea = wgt_areaave_Wrap ( prA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
;    clm(i+2) = wgt_areaave_Wrap ( clma(0,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
    nT = dimsizes (CTI2)

;--------------------------------------------------------------
;compute linear regression
    R2(:,i)  = (/regCoef (CTI2,prArea)/)
    R2(1:,i) = (/regCoef (CTI2(:nT-2), prArea(1:,1:) )/)

    if(i.eq.0)then
     clm3 = clmMonTLL (sst)
     clm4 = clmMonTLL (prate)
     sstA   = calcMonAnomTLL (sst,clm3)
     prateA = calcMonAnomTLL (prate,clm4)
     sstA   = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
     prateA = (/dtrend_msg_n (prateA&time,prateA,False,False,0)/)
     sstA_NDJ  = month_to_season (sstA,season(0))
     prateA_3M = month_to_seasonN (prateA,season)
;     clmb      = month_to_season (clm4,"JFM")
     CTI1      = wgt_areaave_Wrap ( sstA_NDJ(:,{latNI:latSI},{lonWI:lonEI}), gw3({latNI:latSI}), 1., 0)
    pos_lon(0) = stddev (CTI1)
     prateArea = wgt_areaave_Wrap ( prateA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
;     clm(0) = wgt_areaave_Wrap ( clmb(0,{latN1:latS1},{lonW1:lonE1}), gw4({latN1:latS1}), 1., 0)
     R1     = (/regCoef (CTI1,prateArea)/)
     R1(1:) = (/regCoef (CTI1(:nT-2), prateArea(1:,1:) )/)
    end if

   delete([/time5,time6,year5,year6/])

end do
/;
     do j=0,dim(2)-1
      do k=0,dim(0)-1
       a = ind (ccr(k,:,j).ge..5)
;       a = maxind (ccr(k,:,j))
       if(dimsizes(a).ne.1)then
        nlon(k) = (/lon( a(0) )/)
;       else
;        nlon(k) = (/lon(a)/)
       end if
       delete (a)
      end do
      pos_lon(j) = (/min (nlon)/)
;      pos_lon(j) = nlon(3)
     end do
;/
     pos_lon(1) = avg (pos_lon(2:))

    mnmx0 = new(nmod+2,float)
    mnmx0(0)  = min (R1)
    mnmx0(2:) = dim_min_n (R2,0)
    mnmx0(1)  = avg ( mnmx0(2:) )
;    clm(1)  = avg ( clm(2:) )

;    std = dim_stddev_Wrap (mnmx0(2:))

    mnmx0!0 = "member"
;    std!0   = "region"

end if

mnmx    = (mnmx - avg(mnmx)) / stddev(mnmx)
mnmx0   = (mnmx0 - avg(mnmx0)) / stddev(mnmx0)
pos_lon = (pos_lon - avg(pos_lon)) / stddev(pos_lon)
;clm = (clm - avg(clm)) / stddev(clm)
;pos_lon = 1

; ==============================================================
; Mission 3. Draw the scatter
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)

;*******************************************
;  plot timeseries
;*******************************************
res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnCenterString       = text1
;res@gsnRightString        = text1(1)
res@gsnStringFontHeightF  = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
;res@tiMainString       = "Position and Regression of TIO SSTA onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = 4.5
res@trYMinF = -4.5
res@trXMaxF = 4.5
res@trXMinF = -4.5

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(2)
res@xyMarkerSizeF  = sizes(2)
;res@xyMarkerColor  = "black"
;plot = gsn_csm_xy (wks,pos_lon(2:),mnmx(2:),res)
plot = gsn_csm_xy (wks,pos_lon(2:),mnmx0(2:),res)
;plot = gsn_csm_xy (wks,pos_lon(2:)*mnmx0(2:),mnmx(2:),res)
;plot = gsn_csm_xy (wks,pos_lon(2:),mnmx0(2:),res)
;plot = gsn_csm_xy (wks,pos_lon(2:)-clm(2:),mnmx0(2:),res)

;--------------------------------------------------------------
/;
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
resl@gsLineDashPattern = 1
dum  = gsn_add_polyline (wks,plot,(/0,.55/),(/0,.55/),resl)
resl@gsLineColor       = colors(2)
resl@gsLineThicknessF  = 3
resl@gsLineDashPattern = 0
a = (res@trYMaxF-res@trYMinF)/50.
dum1 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2),mnmx(1,2)/),resl)
dum2 = gsn_add_polyline (wks,plot,(/mnmx(0,2),mnmx(0,2)/),(/mnmx(1,2)-std(1),mnmx(1,2)+std(1)/),resl)
dum3 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-std(0),mnmx(0,2)-std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
dum4 = gsn_add_polyline (wks,plot,(/mnmx(0,2)+std(0),mnmx(0,2)+std(0)/),(/mnmx(1,2)-a,mnmx(1,2)+a/),resl)
dum5 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)-std(1),mnmx(1,2)-std(1)/),resl)
dum6 = gsn_add_polyline (wks,plot,(/mnmx(0,2)-a,mnmx(0,2)+a/),(/mnmx(1,2)+std(1),mnmx(1,2)+std(1)/),resl)
;/
;--------------------------------------------------------------
reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarkers      = indexes
reso@xyMarkerSizes  = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknesses = thicknesses
;plot1 = gsn_csm_xy (wks, transpose((/pos_lon(:1),pos_lon(:1)/)), transpose((/mnmx(:1),mnmx(:1)/)), reso)
plot1 = gsn_csm_xy (wks, transpose((/pos_lon(:1),pos_lon(:1)/)), transpose((/mnmx0(:1),mnmx0(:1)/)), reso)
;plot1 = gsn_csm_xy (wks, transpose((/pos_lon(:1)*mnmx0(:1),pos_lon(:1)*mnmx0(:1)/)), transpose((/mnmx(:1),mnmx(:1)/)), reso)
;plot1 = gsn_csm_xy (wks, transpose((/pos_lon(:1),pos_lon(:1)/)), transpose((/mnmx0(:1),mnmx0(:1)/)), reso)
;plot1 = gsn_csm_xy (wks, transpose((/pos_lon(:1)-clm(:1),pos_lon(:1)-clm(:1)/)), transpose((/mnmx0(:1),mnmx0(:1)/)), reso)

overlay (plot,plot1)

draw (plot)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i=0,2
gsres@gsMarkerSizeF = sizes(i)
gsres@gsMarkerColor = colors(i)
gsres@gsMarkerIndex = indexes(i)
gsres@gsMarkerThicknessF = thicknesses(i)

gsn_polymarker_ndc (wks,x(i),y(i),gsres)
end do

txres = True
txres@txJust        = "CenterLeft"
txres@txFontHeightF = 0.018

gsn_text_ndc (wks,text3,x+.025,y,txres)

frame (wks)

end
