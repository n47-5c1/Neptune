;*************************************************************
;Aim: Draw a scatter plot of the time of peak cross regression coefficients between NDJ cold tongue index and 3-month means of area average of monthly SSTAs
;     removed trend in the tropical Indian Ocean as well as in the tropical North Atlantic
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       He Shan
;                       2017-12-15
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
;   var2--------------ts
;================================================

    process = False      ;Statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"

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

;tropical North Atlantic
    latN2 = 25
    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

    rTIO = new((/maxlag,nmod/),float)
    rTNA = new((/maxlag,nmod/),float)

;Fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./scatter_peak_regress_time_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
    out_name = "scatter_peak_regress_time_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP"

;text
    text1 = yS+"-"+yE
    text2 = (/"TNA","TIO"/)
    text3 = (/"HadISST1","MMM","Model Samples"/)

    x       = (/.24,.24,.24/)
    y       = (/.76,.72,.68/)
    colors  = (/"red3","dodgerblue2","grey60"/)
    sizes   = (/.025,.025,.02/)
    indexes = (/5,5,16/)
    thicknesses = (/5.5,5.5,1/)

if (process) then

do i=0,nmod-1

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
    in = addfile (in_path + in_name(i),"r")

;get the time indexes
    time  = in->time
    year  = cd_calendar (time,-1) /100
    iYYYY = ind (year.ge.yS .and. year.le.yE)

    sst = in->ts(iYYYY,:,:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    print (min(sst))

    if(i.eq.0)then 
     in1    = addfile (in_name1,"r")
     time1  = in1->time
     year1  = cd_calendar (time1,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     sst1   = in1->sst(iYYYY1,:,:)
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
   SSTA_3M = month_to_seasonN (SSTA,season)

;--------------------------------------------------------------
;cold tongue (NDJ)
   CTI = wgt_areaave_Wrap ( SSTA_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
   dim = dimsizes (CTI)
;tropical Indian Ocean
   TIO = wgt_areaave_Wrap ( SSTA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
;tropical North Atlantic
   TNA = wgt_areaave_Wrap ( SSTA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

;--------------------------------------------------------------
;compute linear regression
   rTIO(:,i) = (/regCoef (CTI,TIO)/)
   rTNA(:,i) = (/regCoef (CTI,TNA)/)
   rTIO(1:,i) = (/regCoef ( CTI(:dim-2), TIO(1:,1:) )/)
   rTNA(1:,i) = (/regCoef ( CTI(:dim-2), TNA(1:,1:) )/)

   if(i.eq.0)then
    copy_VarCoords (TIO,rTIO(:,0))
    copy_VarCoords (TNA,rTNA(:,0))

    clm1  = clmMonTLL (sst1)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    SSTA_3M1 = month_to_seasonN (SSTA1,season)
    CTI1 = wgt_areaave_Wrap ( SSTA_3M1(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1., 0)
    TIO1 = wgt_areaave_Wrap ( SSTA_3M1(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    TNA1 = wgt_areaave_Wrap ( SSTA_3M1(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
    rTIO1 = regCoef (CTI1,TIO1)
    rTNA1 = regCoef (CTI1,TNA1)
    rTIO1(1:) = regCoef ( CTI1(:dim-2), TIO1(1:,1:) )
    rTNA1(1:) = regCoef ( CTI1(:dim-2), TNA1(1:,1:) )
    copy_VarCoords (TIO1,rTIO1)
    copy_VarCoords (TNA1,rTNA1)

   end if

   delete([/time,year/])

end do

   mnmx = new((/2,nmod+2/),float)
   mnmx(0,0)  = maxind (rTIO1)
   mnmx(0,2:) = dim_maxind (rTIO,0)
   mnmx(0,1)  = dim_avg ( mnmx(0,2:) )
   mnmx(1,0)  = maxind (rTNA1)
   mnmx(1,2:) = dim_maxind (rTNA,0)
   mnmx(1,1)  = dim_avg ( mnmx(1,2:) )

   printVarSummary (mnmx)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

mnmx!0 = "region"
mnmx!1 = "member"
ndim   = dimsizes (mnmx)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"region","member"/)
dimSizes = (/ndim(0),ndim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"region","integer","region")
filevardef (fout,"member","integer","member")
filevardef (fout,"mnmx",typeof(mnmx),getvardims(mnmx))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
;filevarattdef (fout,"S",S)

;output only the data values
fout->region = ispan (1,2,1)
fout->member = ispan (1,nmod+2,1)
fout->mnmx   = (/mnmx/)

else

 in   = addfile (out_data,"r")
 mnmx = in->mnmx
 printVarSummary (mnmx)

end if

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================
wks  = gsn_open_wks ("svg",out_path+out_name)

;*******************************************
;  plot timeseries
;*******************************************

MS = new (nmod,integer)
do j=0,nmod-1
 MS(j) = (/num(mnmx(0,2:).eq.mnmx(0,2+j) .and.  mnmx(1,2:).eq.mnmx(1,2+j))/)
end do
;print(MS)

res = True

res@gsnDraw  = False
res@gsnFrame = False
res@gsnCenterString       = text1
res@gsnStringFontHeightF  = .024

res@tiYAxisString      = text2(0)
res@tiXAxisString      = text2(1)
res@tiXAxisFontHeightF = .023
res@tiMainString       = "Lag T of MR of SSTA onto NDJ CTI"
res@tiMainFontHeightF  = .028

res@trYMaxF = 8
res@trYMinF = -1
res@trXMaxF = 8
res@trXMinF = -1

res@tmXBLabelFontHeightF = .023    ;font height of tick labels
res@tmYLLabelFontHeightF = .023

;res@vpHeightF = 0.2      ;change aspect ratio of plot

res@xyMarkLineMode = "Markers"
res@xyMarker       = indexes(2)
res@xyMarkerSizes  = int2flt(MS)*.01
res@xyMarkerColor  = colors(2)
plot = gsn_csm_xy (wks,transpose((/mnmx(0,2:),mnmx(0,2:)/)), transpose((/mnmx(1,2:),mnmx(1,2:)/)),res)

;--------------------------------------------------------------

reso = True
reso@gsnDraw  = False
reso@gsnFrame = False
reso@xyMarkLineMode = "Markers"
reso@xyMarker       = indexes
reso@xyMarkerSizeF  = sizes
reso@xyMarkerColors = colors
reso@xyMarkerThicknessF = thicknesses
plot1 = gsn_csm_xy (wks, transpose((/mnmx(0,0:1),mnmx(0,0:1)/)), transpose((/mnmx(1,0:1),mnmx(1,0:1)/)) ,reso)
overlay (plot,plot1)

print((/mnmx(:,0:1)/))

draw  (plot)

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
txres@txFontHeightF = 0.015

gsn_text_ndc (wks,text3,x+.02,y,txres)

frame (wks)

end
