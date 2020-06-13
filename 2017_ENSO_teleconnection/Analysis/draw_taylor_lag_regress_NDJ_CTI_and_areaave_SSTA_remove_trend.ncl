;*************************************************************
;Aim: Draw Taylor diagrams on simulation of cross regression between November-December-January cold tongue index and three-month means of area average of monthly sea surface
;     temperature anomalies removed trend in CMIP data
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the Taylor diagrams
;                       Shan He
;                       2017-10-16
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/taylor_diagram.ncl"

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
    in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v4.nc"
    in_path     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name     = new(46,string)
    in_name(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(13) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(14) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(15) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(17) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(18) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(19) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(21) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(22) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(23) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(24) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(25) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(26) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(27) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(28) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    in_name(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(30) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(31) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(32) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(33) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(34) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(35) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(36) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name(37) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(38) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(39) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(40) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(41) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(42) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(43) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(44) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(45) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = 46

;time
    yS = 1961
    yE = 2004
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
    maxlag = dimsizes (season)

;cold tongue
    latN = 6
    latS = -6
    lonW = 180
    lonE = 270

;tropical Indian Ocean
    latN1 = 10
    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;North Pacific
    latN2 = 48
    latS2 = 32
    lonW2 = 176
    lonE2 = 218

;tropical North Atlantic
    latN3 = 25
    latS3 = 5
    lonW3 = 305 
    lonE3 = 345

    cc  = new((/3,nmod+1/),double)
    rat = new((/3,nmod+1/),double)
;    S = new((/maxlag,46/),double)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./taylor_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend.nc"
    out_name = "taylor_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"Tropical Indian Ocean","North Pacific","Tropical North Atlantic"/)
    text3 = (/"NOAA ERSST",\
              "ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanCM4","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-CAM5-1-FV2",\
              "CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM",\
              "GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3","HadGEM2-AO","HadGEM2-CC",\
              "HadGEM2-ES","INMCM4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC4h","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR",\
              "MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","NorESM1-M","NorESM1-ME"/)

if(process) then

do i=0,nmod-1

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
    print (min(sst))

    if(i.eq.0)then 
     in1    = addfile (in_name1,"r")
     in2    = addfile (in_name2,"r")
     time1  = in1->time
     time2  = in2->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     sst1   = in1->sst(iYYYY1,:,:)
     sst2   = in2->sst(iYYYY2,:,:)
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
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
   SSTA_Sea = month_to_seasonN (SSTA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI = wgt_areaave_Wrap ( SSTA_Sea(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   dim = dimsizes (CTI)
;tropical Indian Ocean
   TIO = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
;North Pacific
   NP  = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
;tropical North Atlantic
   TNA = wgt_areaave_Wrap ( SSTA_Sea(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO = (/regCoef (CTI,TIO)/)
   rNP  = (/regCoef (CTI,NP)/)
   rTNA = (/regCoef (CTI,TNA)/)
   rTIO(1:) = (/regCoef ( CTI(:dim-2), TIO(1:,1:) )/)
   rNP(1:)  = (/regCoef ( CTI(:dim-2), NP(1:,1:) )/)
   rTNA(1:) = (/regCoef ( CTI(:dim-2), TNA(1:,1:) )/)

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO)
    copy_VarCoords (NP, rNP)
    copy_VarCoords (TNA,rTNA)

    clm1  = clmMonTLL (sst1)
    clm2  = clmMonTLL (sst2)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    SSTA2 = calcMonAnomTLL (sst2, clm2)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    SSTA2 = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
    SSTA_Sea1 = month_to_seasonN (SSTA1,season)
    SSTA_Sea2 = month_to_seasonN (SSTA2,season)
    CTI1 = wgt_areaave_Wrap ( SSTA_Sea1(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    CTI2 = wgt_areaave_Wrap ( SSTA_Sea2(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TIO2 = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    NP1  = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    NP2  = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    TNA1 = wgt_areaave_Wrap ( SSTA_Sea1(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
    TNA2 = wgt_areaave_Wrap ( SSTA_Sea2(:,:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)
    rTIO1 = regCoef (CTI1,TIO1)
    rTIO2 = regCoef (CTI2,TIO2)
    rNP1  = regCoef (CTI1,NP1)
    rNP2  = regCoef (CTI2,NP2)
    rTNA1 = regCoef (CTI1,TNA1)
    rTNA2 = regCoef (CTI2,TNA2)
    rTIO1(1:) = regCoef ( CTI1(:dim-2), TIO1(1:,1:) )
    rTIO2(1:) = regCoef ( CTI2(:dim-2), TIO2(1:,1:) )
    rNP1(1:)  = regCoef ( CTI1(:dim-2), NP1(1:,1:) )
    rNP2(1:)  = regCoef ( CTI2(:dim-2), NP2(1:,1:) )
    rTNA1(1:) = regCoef ( CTI1(:dim-2), TNA1(1:,1:) )
    rTNA2(1:) = regCoef ( CTI2(:dim-2), TNA2(1:,1:) )
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TIO2,rTIO2)
    copy_VarCoords (NP1, rNP1)
    copy_VarCoords (NP2, rNP2)
    copy_VarCoords (TNA1,rTNA1)
    copy_VarCoords (TNA2,rTNA2)

;-------------------------------------------------------------
;ratio of centered RMS difference
    std_TIO1 = dim_stddev_Wrap (rTIO1)
    std_TIO2 = dim_stddev_Wrap (rTIO2)
    std_NP1  = dim_stddev_Wrap (rNP1)
    std_NP2  = dim_stddev_Wrap (rNP2)
    std_TNA1 = dim_stddev_Wrap (rTNA1)
    std_TNA2 = dim_stddev_Wrap (rTNA2)
    rat(0,0) = std_TIO2 / std_TIO1
    rat(1,0) = std_NP2  / std_NP1
    rat(2,0) = std_TNA2 / std_TNA1
    cc(0,0) = escorc (rTIO1,rTIO2)
    cc(1,0) = escorc (rNP1, rNP2)
    cc(2,0) = escorc (rTNA1,rTNA2)
   end if

    std_TIO = dim_stddev_Wrap (rTIO)
    std_NP  = dim_stddev_Wrap (rNP)
    std_TNA = dim_stddev_Wrap (rTNA)

    rat(0,i+1) = std_TIO/std_TIO1
    rat(1,i+1) = std_NP /std_NP1
    rat(2,i+1) = std_TNA/std_TNA1

;centered pattern correlation
    cc(0,i+1) = escorc (rTIO1,rTIO)
    cc(1,i+1) = escorc (rNP1, rNP)
    cc(2,i+1) = escorc (rTNA1,rTNA)

;skill score
;   S(:,i) = 2*(1.+cc) / (rat+1./rat)^2.
;   S(:,i) = (1.+cc)^2. / (rat+1./rat)^2.
;   S(:,i) = (1.+cc)^4. / 4 / (rat+1./rat)^2.

   delete([/time,year/])

end do

   printVarSummary (cc)
   printVarSummary (rat)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

cc!0  = "region"
rat!0 = "region"
cc!1  = "model"
rat!1 = "model"
ndim  = dimsizes (cc)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","model"/)
dimSizes = (/ndim(0),ndim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"model", "integer","model")
filevardef (fout,"cc", typeof(cc), getvardims(cc))
filevardef (fout,"rat",typeof(rat),getvardims(rat))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)

;output only the data values
fout->region = ispan(1,3,1)
fout->model  = ispan(0,nmod,1)
fout->cc     = (/cc/)
fout->rat    = (/rat/)

else
 in   = addfile (out_data,"r")
 cc   = in->cc
 rat  = in->rat
 ndim = dimsizes (cc)
 printVarSummary (cc)
 printVarSummary (rat)
end if

; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)
plot = new (3,graphic)        

; taylor diagram
opt = True

opt@Markers = 16
opt@Colors  = "red" 
opt@varLabels     = text3
opt@varLabelsYloc = 1.5
;opt@caseLabels = (/"Case A", "Case B","Case C","Case D","Case E"/)
                
opt@taylorDraw  = False
opt@taylorFrame = False

;-------------------------------------------------------------
do i=0,2
 opt@tiMainString = text1(i)+" "+text2(i)
 plot(i) = taylor_diagram(wks,rat(i:i,:),cc(i:i,:),opt)
end do

; *******************************************************************
; Create demo panels
; *******************************************************************
resP = True

resP@txString        = "Regression between NDJ CTI and Seasonal SSTA"
resP@txFontHeightF   = 0.025
resP@gsnPanelRowSpec = True
resP@gsnPanelYWhiteSpacePercent = 3
gsn_panel(wks,plot,(/1,2/),resP)

end
