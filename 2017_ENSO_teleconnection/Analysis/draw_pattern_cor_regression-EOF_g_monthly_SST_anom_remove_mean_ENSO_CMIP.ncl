;*************************************************************
;Aim: Draw pattern correlation of regression-EOF of deviation of global monthly SST anomalies from time-evolving global-mean SST anomalies for EP- and CP-ENSO in CMIP data
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output  data
;   4. Draw the plots
;                       He Shan
;                       2017-09-15
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

    process = False

;data
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

;time
    yS = 1961
    yE = 2004

;Nino1+2
    latN1 = 0
    latS1 = -10
    lonW1 = 270
    lonE1 = 280

;Nino4
    latN2 = 5
    latS2 = -5
    lonW2 = 160
    lonE2 = 210

;region
    latN = 60
    latS = -60
    lonW = 120
    lonE = 280

    neof        = 1      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

    r = new((/2,46/),double)

;fig
    out_path  = "~/hes/ENSO/Fig/"
    out_data  = "./pattern_cor_EOF1_g_EP_CP_ENSO.nc"
    out_name1 = "regression-EOF_g_monthly_SST_anom_remove_mean_ENSO_CMIP"
    out_name2 = "pattern_cor_regression-EOF_g_monthly_SST_anom_remove_mean_ENSO_CMIP"

;    wks1   = gsn_open_wks("eps",out_path+out_name1)
;    plot1 = new (46*2,graphic)
    plot2 = new (2,graphic)
 
;text
;    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)"/)
    text2 = (/"EP-ENSO","CP-ENSO"/)
    text3 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanCM4","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-CAM5-1-FV2",\
              "CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM",\
              "GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3","HadGEM2-AO","HadGEM2-CC",\
              "HadGEM2-ES","INMCM4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC4h","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR",\
              "MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","NorESM1-M","NorESM1-ME"/)

;-------------------------------------------------------------
;  plot EOF
res = True

res@gsnDraw      = False
res@gsnFrame     = False
res@gsnAddCyclic = True
res@gsnLeftString        = " "
res@gsnStringFontHeightF = 0.026

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

;res@mpFillOn     = False
res@mpCenterLonF = 180
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
;res@mpMinLonF = lonW
;res@mpMaxLonF = lonE

;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.03,-.02,-.01,.01,.02,.03/)

res@lbLabelBarOn = False

res@tmXBLabelsOn         = False
res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.025
res@tmYLLabelFontHeightF = 0.025

;-------------------------------------------------------------

if(process) then

do i=0,45

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in  = addfile (in_path + in_name(i),"r")
    in1 = addfile ("./EOF1_g_EP_CP_ENSO.nc","r")

    time = in->time
;    printVarSummary (time)

;get the time indexs
    year  = cd_calendar (time,-1) /100
    iYYYY = ind (year.ge.yS .and. year.le.yE)

    sst  = in->ts(iYYYY,{latN:latS},:)
    sst1 = in1->sst1
    sst2 = in1->sst2
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))

;    printVarSummary (sst)
    print (min(sst))

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.

    gw   = in->lat({latN:latS})
    clat = in->lat({latN:latS})
    gw   = cos (rad*gw)
    clat = sqrt ( cos(rad*clat) )

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

   print (i+" EOF...")

;monthly anomalies
   clm  = clmMonTLL (sst)
   SSTA = calcMonAnomTLL (sst, clm)

;subtract values regressed with series
   Nino12 = wgt_areaave_Wrap ( SSTA(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 
   Nino4  = wgt_areaave_Wrap ( SSTA(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

   rc     = regCoef_n (Nino4,SSTA,0,0)
   sst_EP = SSTA - conform (SSTA,rc,(/1,2/)) * conform (SSTA,Nino4,0)
   copy_VarMeta (SSTA, sst_EP)

   rc     = regCoef_n (Nino12,SSTA,0,0)
   sst_CP = SSTA - conform (SSTA,rc,(/1,2/)) * conform (SSTA,Nino12,0)
   copy_VarMeta (SSTA, sst_CP)

;deviation from time-evolving global-mean SSTAs
   SSTM   = wgt_areaave_Wrap ( sst_EP, gw, 1., 0)
   sst_EP = sst_EP - conform (SSTA,SSTM,0)

   SSTM   = wgt_areaave_Wrap ( sst_CP, gw, 1., 0)
   sst_CP = sst_CP - conform (SSTA,SSTM,0)

;   printVarSummary (sst_EP)
;   printVarSummary (sst_CP)

;-------------------------------------------------------------
;EOF
    y         = sst_EP*conform (sst,clat,1)
    copy_VarMeta (sst,y)
    eof_EP    = eofunc_n_Wrap (y,neof,optEOF,0)
;    eof_EP    = (/-eof_EP/)      ;reverse the signs
    eof_ts_EP = eofunc_ts_n_Wrap (y,eof_EP,optETS,0)
;    printVarSummary (eof_EP)

    y         = sst_CP*conform (sst,clat,1)
    eof_CP    = eofunc_n_Wrap (y,neof,optEOF,0)
    eof_ts_CP = eofunc_ts_n_Wrap (y,eof_CP,optETS,0)
;    printVarSummary (eof_CP)

;weighted centered pattern correlation
    r(0,i) = abs (pattern_cor (sst1,eof_EP(0,:,:),gw,0))
    r(1,i) = abs (pattern_cor (sst2,eof_CP(0,:,:),gw,0))
    
    r!0 = "a"
    r!1 = "b"

    if(i.eq.0)then
;     copy_VarMeta (eof_ts_EP,r(0:0,:))
    end if

;normalize time series
;    eof_ts_EP = dim_standardize_n (eof_ts_EP,0,1)
;    eof_ts_CP = dim_standardize_n (eof_ts_CP,0,1)

;    printVarSummary (eof_ts_EP)
;    printVarSummary (eof_ts_CP)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

dim = dimsizes (r)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"a","b"/)  
dimSizes = (/dim(0),dim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"a","integer","a")
filevardef (fout,"b","integer","b")
filevardef (fout,"r",typeof(r),getvardims(r))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"env", )
;filevarattdef (fout,"time",time)
filevarattdef (fout,"r",   r)

;output only the data values
fout->env  = (/0,1/)
fout->time = ispan(1,46,1)
fout->r    = (/r/)

; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

/;

;*******************************************
;  plot EOF
;*******************************************

;res@gsnLeftString   = text1(0)+" "+text3(0)
if(i.eq.0)then
 res@gsnCenterString = text2(0)
else
 res@gsnCenterString = " "
end if
res@gsnRightString = sprintf("%5.1f",eof_EP@pcvar(0))+"%"
res@tmXBLabelsOn   = False
if(mod(i,10).eq.0)then
 res@tmYLLabelsOn = True
else
 res@tmYLLabelsOn = False
end if
plot1(i) = gsn_csm_contour_map_ce (wks,eof_EP(0,:,:),res)

;res@gsnLeftString   = text1(1)
if(i.eq.0)then
 res@gsnCenterString = text2(1)
end if
res@gsnRightString = sprintf("%5.1f",eof_CP@pcvar(0))+"%"
if(i+46.ge.46*2-12)then
 res@tmXBLabelsOn = True
else
 res@tmXBLabelsOn = False
end if
if(mod(i+46,10).eq.0 .and. i.lt.43)then
 res@tmYLLabelsOn = True
else
 res@tmYLLabelsOn = False
end if
plot1(i+46) = gsn_csm_contour_map_ce (wks1,eof_CP(0,:,:),res)

;res@gsnCenterString = sprintf("%5.3f",ra)

;/

delete([/time,year/])

end do

/;
;*******************************************
;  plot EOF time series
;*******************************************

if(i.eq.0)then

dim = dimsizes (eof_ts_EP(0,:))

x = fspan (yS,yE,dim)

data1 = new((/46,dim/), typeof(eof_ts_EP))
data2 = new((/46,dim/), typeof(eof_ts_CP))

end if

data1(i,:) = (/eof_ts_EP(0,:)/)
data2(i,:) = (/eof_ts_CP(0,:)/)

rts = True

rts@gsnDraw       = False
rts@gsnFrame      = False
rts@gsnYRefLine   = 0.
rts@gsnCenterString       = "PC 1"
rts@gsnStringFontHeightF  = 0.027

;res@trYMinF = 0
;res@trYMaxF = 6

;rts@tmXBLabelsOn         = False
rts@tmXBLabelFontHeightF = 0.026
rts@tmYLLabelFontHeightF = 0.026

rts@vpWidthF  = 0.85
rts@vpHeightF = 0.35

rts@xyLineColors  = (/"black","orangered","deepskyblue"/)
rts@xyDashPattern = 0

;rts@gsnLeftString  = text1(6)
;rts@gsnRightString = sprintf("%5.3f",ca)+", "+sprintf("%5.3f",cb)
plot2(0) = gsn_csm_xy (wks,x,data1,rts)

;rts@gsnLeftString   = text1(7)
rts@gsnCenterString = " "
;rts@gsnRightString  = sprintf("%5.3f",cc)+", "+sprintf("%5.3f",cd)
plot2(1) = gsn_csm_xy (wks,x,data2,rts)

;-------------------------------------------------------------
;Manually creating a legend
gres = True
gres@YPosPercent = 92.
gres@XPosPercent = 74.

lineres = True
lineres@lgLineColors = (/"black","orangered","deepskyblue"/)
lineres@lgLineThicknesses = 2.5
lineres@LineLengthPercent = 5.

textres = True
textres@lgLabels = text3
;textres@lgLabelFontHeights = 0.025

plot2(0) = simple_legend(wks1,plot2(0),gres,lineres,textres)

;*******************************************
;create panel resources
;*******************************************
resP1                          = True
resP1@txString                 = "EOF 1 of Monthly SSTR"
;resP1@gsnFrame                 = False
resP1@gsnPanelBottom           = 0.05
;resP1@gsnPanelCenter           = False
resP1@gsnPanelRowSpec          = True
resP1@gsnPanelLabelBar         = True
resP1@lbLabelFontHeightF       = 0.005
resP1@pmLabelBarWidthF         = 0.4
resP1@pmLabelBarOrthogonalPosF = -0.01
gsn_panel(wks1,plot1,(/10,10,10,10,10,10,10,10,12/),resP1)

resP2                          = True
resP2@gsnFrame                 = False
resP2@gsnPanelTop              = 0.25
;resP2@gsnPanelBottom           = 0.02
gsn_panel(wks1,plot2,(/1,2/),resP2)

frame (wks1)

;/

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

dim = dimsizes (r)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"a","b"/)  
dimSizes = (/dim(0),dim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"a","integer","a")
filevardef (fout,"b","integer","b")
filevardef (fout,"r",typeof(r),getvardims(r))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"env", )
;filevarattdef (fout,"time",time)
filevarattdef (fout,"r",   r)

;output only the data values
fout->env  = (/0,1/)
fout->time = ispan(1,46,1)
fout->r    = (/r/)

else
    in = addfile (out_data,"r")
    r  = in->r
    printVarSummary (r)
end if


;*******************************************
;  plot bar
;*******************************************

wks2 = gsn_open_wks ("svg",out_path+out_name2)

resB = True

resB@gsnDraw       = False
resB@gsnFrame      = False
resB@gsnXYBarChart = True
resB@gsnXYBarChartBarWidth  = 0.3

resB@vpWidthF  = 0.75
resB@vpHeightF = 0.25

resB@trYMinF = 0
resB@trYMaxF = 1.
resB@trXMinF = 0
resB@trXMaxF = 47
                          
resB@tmXTOn          = False
;resB@tmXBOn          = False
resB@tmXTBorderOn    = False
;resB@tmXBLabelsOn    = True
resB@tmXBMode        = "Explicit"
resB@tmXBValues      = ispan (1,46,1)
resB@tmXBLabels      = text3
resB@tmXBLabelJust   = "CenterLeft"
resB@tmXBLabelAngleF = -60.
resB@tmXBLabelFontHeightF = 0.008
resB@tmYLLabelFontHeightF = 0.012

resB@tiMainFontHeightF = 0.019
resB@tiMainString      = "Pattern Correlation between Observation and CMIP5"

resB@gsnXYBarChartColors = (/"tomato"/)
plot2(0) = gsn_csm_xy(wks2,fspan(.85,45.85,46),r(0,:),resB)

resB@gsnXYBarChartColors = (/"royalblue1"/)
plot2(1) = gsn_csm_xy(wks2,fspan(1.15,46.15,46),r(1,:),resB)

;-------------------------------------------------------------
;Manually creating a legend
gres = True
gres@YPosPercent = 95.
gres@XPosPercent = 6.

lineres = True
lineres@lgLineColors = (/"tomato","royalblue1"/)
lineres@lgLineThicknesses = 2.5
lineres@LineLengthPercent = 5.

textres = True
textres@lgLabels           = text2
textres@lgLabelFontHeights = 0.008

plot2(0) = simple_legend (wks2,plot2(0),gres,lineres,textres)

/;

lbres = True
lbres@vpWidthF           = 0.3
lbres@vpHeightF          = 0.1
lbres@lbBoxMajorExtentF  = 0.36          ; puts space between color boxes
lbres@lbFillColors       = (/"tomato","royalblue1"/)
lbres@lbMonoFillPattern  = True          ; Solid fill pattern
lbres@lbLabelFontHeightF = 0.035
lbres@lbLabelJust        = "CenterLeft"  ; left justify labels
lbres@lbPerimOn          = False
lbres@lgPerimColor       = "white"
gsn_labelbar_ndc (wks2,2,text2,0.52,0.23,lbres)  ; draw right labelbar column

;/
draw (plot2)
frame (wks2)

end
