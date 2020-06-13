;*************************************************************
;Aim: Draw the standard deviation of zonal monthly sea surface temperature anomalies removed trend at the Pacific equator in CMIP data
;
;Mission:
;
;   1. Read data from sst datasets
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
;   var2--------------ts
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v4.nc"

    in_path     = "~/data-model/CMIP5-hes/ts/historical/"
    in_name     = new(45,string)
    in_name(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(12) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(13) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(14) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(15) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(18) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(20) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(21) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(22) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(23) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(24) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(25) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(26) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(27) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    in_name(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(29) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(30) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    in_name(31) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(32) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(33) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(34) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(35) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    in_name(36) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    in_name(37) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(38) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(39) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(40) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(41) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(42) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(43) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(44) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
    nmod = dimsizes (in_name)

;time
    yS = 1958
    yE = 2004

;region
    latN = 5
    latS = -5
    lonW = 112
    lonE = 285

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./std_lon_Pac_SSTA_remove_trend_CMIP.nc"
    out_name = "std_lon_Pac_SSTA_remove_trend_CMIP"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)
    text2 = (/"the Pacific","5~F35~J~F~S - 5~F35~J~F~N",yS+"-"+yE/)
    text3 = (/"SST STD (~F35~J~F~C)","Longtitude (deg)"/)
    text4 = (/"HadISST1","NOAA ERSST","CMIP5"/)

    colors = (/"black","orangered","blue"/)

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

     lon = in1->lon({lonW:lonE})
     dim = dimsizes (lon)
     STD = new((/dim,nmod/),float)
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

;computes standard deviation
   STD(:,i) = dim_stddev_n_Wrap ( dim_avg_wgt_n_Wrap ( SSTA(:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 1), 0)

   if(i.eq.0)then
    clm1  = clmMonTLL (sst1)
    clm2  = clmMonTLL (sst2)
    SSTA1 = calcMonAnomTLL (sst1, clm1)
    SSTA2 = calcMonAnomTLL (sst2, clm2)
    SSTA1 = (/dtrend_msg_n (SSTA1&time,SSTA1,False,False,0)/)
    SSTA2 = (/dtrend_msg_n (SSTA2&time,SSTA2,False,False,0)/)
    STD1 = dim_stddev_n_Wrap ( dim_avg_wgt_n_Wrap ( SSTA1(:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 1), 0)
    STD2 = dim_stddev_n_Wrap ( dim_avg_wgt_n_Wrap ( SSTA2(:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1, 1), 0)
   end if

   delete([/time,year/])

end do

   mnmx = new((/5,dim/),float)
   mnmx(0,:) = STD1
   mnmx(1,:) = STD2
   mnmx(2,:) = dim_avg ( STD )
   mnmx(3,:) = dim_min ( STD )
   mnmx(4,:) = dim_max ( STD )

   copy_VarCoords (STD,mnmx(0,:))

   printVarSummary (mnmx)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
/;
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
fout->region = ispan(1,2,1)
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
;/
end if

; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

wks   = gsn_open_wks ("svg",out_path+out_name)

;area filled
res = True

res@gsnDraw     = False
res@gsnFrame    = False
res@gsnYRefLine = .0
res@gsnLeftString          = text2(0)
res@gsnCenterString        = text2(1)
res@gsnRightString         = text2(2)
res@gsnStringFontHeightF   = 0.021
res@gsnYRefLineThicknessF  = 2
res@gsnYRefLineDashPattern = 1

res@tiYAxisString      = text3(0)
res@tiXAxisString      = text3(1)
res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021
res@tiMainString       = "STD of Zonal SSTA"
res@tiMainFontHeightF  = .028

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@trYMinF = -.0
res@trYMaxF = 2.2

res@vpHeightF = 0.25

res@xyLineColor     = -1       ;not want the line, make it transparent
res@gsnXYFillColors = "LightBlue"

plot = gsn_csm_xy (wks,lon,mnmx(3:,:),res)

;--------------------------------------------------------------
reso = True

reso@gsnDraw       = False
reso@gsnFrame      = False

reso@xyLineColors  = colors
reso@xyDashPattern = 0
reso@xyLineThicknessF       = 4.
reso@xyExplicitLegendLabels = text4

;Manually creating a legend
reso@pmLegendDisplayMode    = "Always"
reso@pmLegendWidthF         = 0.06
reso@pmLegendHeightF        = 0.17
reso@pmLegendSide           = "Top"
reso@pmLegendParallelPosF   = .19
reso@pmLegendOrthogonalPosF = -0.7

reso@lgPerimOn              = False
reso@lgLabelFontHeightF     = .014

plot0 = gsn_csm_xy (wks,lon,mnmx(:2,:),reso)

overlay (plot,plot0)

draw  (plot)
frame (wks)

end
