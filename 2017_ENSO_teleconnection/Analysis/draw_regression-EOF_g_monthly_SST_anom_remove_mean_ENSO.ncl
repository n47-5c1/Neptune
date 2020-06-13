;*************************************************************
;Aim: Draw regression-EOF of deviation of global monthly SST anomalies from time-evolving global-mean SST anomalies for EP- and CP-ENSO
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output deserved data
;   3. Draw the EOFs and PCs
;                       He Shan
;                       2017-08-18
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

;data
    in_path1  = "~/data/observation/SST/"
    in_path2  = "~/hes/ENSO/Regrid/"
;HadISST1   1870/01 - , 1x1
    in_name1 = "HadISST_sst_2x2.nc"
;    in_name2 = "HadISST/HadISST1_SST_update.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name3 = "NOAA_ERSST/sst.mnmean.v4.nc"
;NOAA PISST 1981/12 - , 1x1
    in_name4 = "NOAA_OISST_sst.mnmean_2x2.nc"
;    in_name5 = "NOAA_OISST/lsmask.nc"


;time
    yS1 = 1960
    yS2 = 1982
    yE  = 2015

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

;fig
    out_data = "./EOF1_g_EP_CP_ENSO.nc"
    out_path = "~/hes/ENSO/Fig/"
    out_name = "regression-EOF_g_monthly_SST_anom_remove_mean_ENSO"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)"/)
    text2 = (/"EP-ENSO","CP-ENSO"/)
    text3 = (/"HadISST","NOAA ERSST","NOAA OISST"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path2 + in_name1,"r")
    in2 = addfile (in_path1 + in_name3,"r")
    in3 = addfile (in_path2 + in_name4,"r")
;    in  = addfile (in_path + in_name5,"r")

    time1 = in1->time
    time2 = in2->time
    time3 = in3->time
;    lmask = in->mask(0,{latN:latS},:)
    printVarSummary (time1)
    printVarSummary (time2)
    printVarSummary (time3)

;get the time indexs
    year1  = cd_calendar (time1,-1) /100
    year2  = cd_calendar (time2,-1) /100
    year3  = cd_calendar (time3,-1) /100
    iYYYY1 = ind (year1.ge.yS1 .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS1 .and. year2.le.yE)
    iYYYY3 = ind (year3.ge.yS2 .and. year3.le.yE)

    sst1 = in1->sst(iYYYY1,{latN:latS},:)
;    sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
    sst2 = in2->sst(iYYYY2,{latN:latS},:)
    sst3 = in3->sst(iYYYY3,{latN:latS},:)

;masking of data
;    sst1 = where (sst1.lt.-1.8,-1.8,sst1)
;    sst3 = mask (sst3, conform(sst3,lmask,(/1,2/)) ,1)

    printVarSummary (sst1)
    printVarSummary (sst2)
    printVarSummary (sst3)

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.

    gw   = in1->lat({latN:latS})
    clat = in1->lat({latN:latS})
    gw   = cos (rad*gw)
    clat = sqrt ( cos(rad*clat) )

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

   print ("pre-EOF...")

;monthly anomalies
   clm1  = clmMonTLL (sst1)
   clm2  = clmMonTLL (sst2)
   clm3  = clmMonTLL (sst3)
   SSTA1 = calcMonAnomTLL (sst1, clm1)
   SSTA2 = calcMonAnomTLL (sst2, clm2)
   SSTA3 = calcMonAnomTLL (sst3, clm3)

;subtract values regressed with series
   Nino12_1 = wgt_areaave_Wrap ( SSTA1(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 
   Nino12_2 = wgt_areaave_Wrap ( SSTA2(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 
   Nino12_3 = wgt_areaave_Wrap ( SSTA3(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 

   Nino4_1 = wgt_areaave_Wrap ( SSTA1(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
   Nino4_2 = wgt_areaave_Wrap ( SSTA2(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0) 
   Nino4_3 = wgt_areaave_Wrap ( SSTA3(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

   rc1 = regCoef_n (Nino4_1,SSTA1,0,0)
   rc2 = regCoef_n (Nino4_2,SSTA2,0,0)
   rc3 = regCoef_n (Nino4_3,SSTA3,0,0)

   sst_EP1 = SSTA1 - conform (SSTA1,rc1,(/1,2/)) * conform (SSTA1,Nino4_1,0)
   sst_EP2 = SSTA2 - conform (SSTA2,rc2,(/1,2/)) * conform (SSTA2,Nino4_2,0)
   sst_EP3 = SSTA3 - conform (SSTA3,rc3,(/1,2/)) * conform (SSTA3,Nino4_3,0)

   copy_VarMeta (SSTA1, sst_EP1)
   copy_VarMeta (SSTA2, sst_EP2)
   copy_VarMeta (SSTA3, sst_EP3)

   rc1 = regCoef_n (Nino12_1,SSTA1,0,0)
   rc2 = regCoef_n (Nino12_2,SSTA2,0,0)
   rc3 = regCoef_n (Nino12_3,SSTA3,0,0)

   sst_CP1 = SSTA1 - conform (SSTA1,rc1,(/1,2/)) * conform (SSTA1,Nino12_1,0)
   sst_CP2 = SSTA2 - conform (SSTA2,rc2,(/1,2/)) * conform (SSTA2,Nino12_2,0)
   sst_CP3 = SSTA3 - conform (SSTA3,rc3,(/1,2/)) * conform (SSTA3,Nino12_3,0)

   copy_VarMeta (SSTA1, sst_CP1)
   copy_VarMeta (SSTA2, sst_CP2)
   copy_VarMeta (SSTA3, sst_CP3)

;deviation from time-evolving global-mean SSTAs
   SSTM1 = wgt_areaave_Wrap ( sst_EP1, gw, 1., 0)
   SSTM2 = wgt_areaave_Wrap ( sst_EP2, gw, 1., 0)
   SSTM3 = wgt_areaave_Wrap ( sst_EP3, gw, 1., 0)

   sst_EP1 = sst_EP1 - conform (SSTA1,SSTM1,0)
   sst_EP2 = sst_EP2 - conform (SSTA2,SSTM2,0)
   sst_EP3 = sst_EP3 - conform (SSTA3,SSTM3,0)

   SSTM1 = wgt_areaave_Wrap ( sst_CP1, gw, 1., 0)
   SSTM2 = wgt_areaave_Wrap ( sst_CP2, gw, 1., 0)
   SSTM3 = wgt_areaave_Wrap ( sst_CP3, gw, 1., 0)

   sst_CP1 = sst_CP1 - conform (SSTA1,SSTM1,0)
   sst_CP2 = sst_CP2 - conform (SSTA2,SSTM2,0)
   sst_CP3 = sst_CP3 - conform (SSTA3,SSTM3,0)

   printVarSummary (sst_EP1)
   printVarSummary (sst_EP2)
   printVarSummary (sst_EP3)
   printVarSummary (sst_CP1)
   printVarSummary (sst_CP2)
   printVarSummary (sst_CP3)

;-------------------------------------------------------------
;EOF
    x1 = sst_EP1*conform (sst1,clat,1)
    x2 = sst_EP2*conform (sst2,clat,1)
    x3 = sst_EP3*conform (sst3,clat,1)

    copy_VarMeta (sst1,x1)
    copy_VarMeta (sst2,x2)
    copy_VarMeta (sst3,x3)

    eof_EP1 = eofunc_n_Wrap (x1,neof,optEOF,0)
    eof_EP2 = eofunc_n_Wrap (x2,neof,optEOF,0)
    eof_EP2 = (/-eof_EP2/)      ;reverse the signs
    eof_EP3 = eofunc_n_Wrap (x3,neof,optEOF,0)

    eof_ts_EP1 = eofunc_ts_n_Wrap (x1,eof_EP1,optETS,0)
    eof_ts_EP2 = eofunc_ts_n_Wrap (x2,eof_EP2,optETS,0)
    eof_ts_EP3 = eofunc_ts_n_Wrap (x3,eof_EP3,optETS,0)

    printVarSummary (eof_EP1)
    printVarSummary (eof_EP2)
    printVarSummary (eof_EP3)

    x1 = sst_CP1*conform (sst1,clat,1)
    x2 = sst_CP2*conform (sst2,clat,1)
    x3 = sst_CP3*conform (sst3,clat,1)

    eof_CP1 = eofunc_n_Wrap (x1,neof,optEOF,0)
    eof_CP2 = eofunc_n_Wrap (x2,neof,optEOF,0)
    eof_CP3 = eofunc_n_Wrap (x3,neof,optEOF,0)

    eof_ts_CP1 = eofunc_ts_n_Wrap (x1,eof_CP1,optETS,0)
    eof_ts_CP2 = eofunc_ts_n_Wrap (x2,eof_CP2,optETS,0)
    eof_ts_CP3 = eofunc_ts_n_Wrap (x3,eof_CP3,optETS,0)

    printVarSummary (eof_CP1)
    printVarSummary (eof_CP2)
    printVarSummary (eof_CP3)

;weighted centered pattern correlation
    ra = pattern_cor (eof_EP1,eof_EP2,gw,0)
    rb = pattern_cor (eof_EP1,eof_EP3,gw,0)
    rc = pattern_cor (eof_CP1,eof_CP2,gw,0)
    rd = pattern_cor (eof_CP1,eof_CP3,gw,0)

;normalize time series
    eof_ts_EP1 = dim_standardize_n (eof_ts_EP1,0,1)
    eof_ts_EP2 = dim_standardize_n (eof_ts_EP2,0,1)
    eof_ts_EP3 = dim_standardize_n (eof_ts_EP3,0,1)
    eof_ts_CP1 = dim_standardize_n (eof_ts_CP1,0,1)
    eof_ts_CP2 = dim_standardize_n (eof_ts_CP2,0,1)
    eof_ts_CP3 = dim_standardize_n (eof_ts_CP3,0,1)

    printVarSummary (eof_ts_EP1)
    printVarSummary (eof_ts_EP2)
    printVarSummary (eof_ts_EP3)
    printVarSummary (eof_ts_CP1)
    printVarSummary (eof_ts_CP2)
    printVarSummary (eof_ts_CP3)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

dim = dimsizes (eof_EP1(0,:,:))
lat = eof_EP1&lat
lon = eof_EP1&lon

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"lat","lon"/)  
dimSizes = (/dim(0),dim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"lat", typeof(lat),getvardims(lat))
filevardef (fout,"lon", typeof(lon),getvardims(lon))
filevardef (fout,"sst1",typeof(eof_EP1(0,:,:)),getvardims(eof_EP1(0,:,:)))
filevardef (fout,"sst2",typeof(eof_CP1(0,:,:)),getvardims(eof_CP1(0,:,:)))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"sst1",eof_EP1(0,:,:))
filevarattdef (fout,"sst2",eof_CP1(0,:,:))

;output only the data values
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->sst1 = (/eof_EP1(0,:,:)/)
fout->sst2 = (/eof_CP1(0,:,:)/)

; ==============================================================
; Mission 4. Draw the EOF
; ==============================================================

 wks   = gsn_open_wks("svg",out_path+out_name)
 plot1 = new (6,graphic)
 plot2 = new (2,graphic)

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw      = False
res@gsnFrame     = False
res@gsnAddCyclic = True
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

res@gsnLeftString   = text1(0)+" "+text3(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = sprintf("%5.1f",eof_EP1@pcvar(0))+"%"
plot1(0) = gsn_csm_contour_map_ce (wks,eof_EP1(0,:,:),res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = sprintf("%5.1f",eof_CP1@pcvar(0))+"%"
res@tmYLLabelsOn    = False
plot1(1) = gsn_csm_contour_map_ce (wks,eof_CP1(0,:,:),res)

res@gsnLeftString   = text1(2)+" "+text3(1)
res@gsnCenterString = sprintf("%5.3f",ra)
res@gsnRightString  = sprintf("%5.1f",eof_EP2@pcvar(0))+"%"
res@tmYLLabelsOn    = True
plot1(2) = gsn_csm_contour_map_ce (wks,eof_EP2(0,:,:),res)

res@gsnLeftString   = text1(3)
res@gsnCenterString = sprintf("%5.3f",rc)
res@gsnRightString  = sprintf("%5.1f",eof_CP2@pcvar(0))+"%"
res@tmYLLabelsOn    = False
plot1(3) = gsn_csm_contour_map_ce (wks,eof_CP2(0,:,:),res)

res@gsnLeftString   = text1(4)+" "+text3(2)
res@gsnCenterString = sprintf("%5.3f",rb)
res@gsnRightString  = sprintf("%5.1f",eof_EP3@pcvar(0))+"%"
res@tmXBLabelsOn    = True
res@tmYLLabelsOn    = True
plot1(4) = gsn_csm_contour_map_ce (wks,eof_EP3(0,:,:),res)

res@gsnLeftString   = text1(5)
res@gsnCenterString = sprintf("%5.3f",rd)
res@gsnRightString  = sprintf("%5.1f",eof_CP3@pcvar(0))+"%"
res@tmYLLabelsOn    = False
plot1(5) = gsn_csm_contour_map_ce (wks,eof_CP3(0,:,:),res)

;*******************************************
;  plot EOF time series
;*******************************************
dim1  = dimsizes (eof_ts_EP1(0,:))
dim2  = dimsizes (eof_ts_EP3(0,:))

x = fspan (yS1,yE,dim1)

data1 = new((/3,dim1/), typeof(eof_ts_EP1))
data2 = new((/3,dim1/), typeof(eof_ts_CP1))

data1(0,:)          = (/eof_ts_EP1(0,:)/)
data1(1,:)          = (/eof_ts_EP2(0,:)/)
data1(2,dim1-dim2:) = (/eof_ts_EP3(0,:)/)
data2(0,:)          = (/eof_ts_CP1(0,:)/)
data2(1,:)          = (/eof_ts_CP2(0,:)/)
data2(2,dim1-dim2:) = (/eof_ts_CP3(0,:)/)

ca = escorc (data1(0,:),data1(1,:))
cb = escorc (data1(0,:),data1(2,:))
cc = escorc (data2(0,:),data2(1,:))
cd = escorc (data2(0,:),data2(2,:))

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

rts@gsnLeftString  = text1(6)
rts@gsnRightString = sprintf("%5.3f",ca)+", "+sprintf("%5.3f",cb)
plot2(0) = gsn_csm_xy (wks,x,data1,rts)

rts@gsnLeftString   = text1(7)
rts@gsnCenterString = " "
rts@gsnRightString  = sprintf("%5.3f",cc)+", "+sprintf("%5.3f",cd)
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

plot2(0) = simple_legend(wks,plot2(0),gres,lineres,textres)

;*******************************************
;create panel resources
;*******************************************
resP1                          = True
resP1@txString                 = "EOF 1 of Monthly SSTR"
resP1@gsnFrame                 = False
resP1@gsnPanelBottom           = 0.35
resP1@gsnPanelLabelBar         = True
resP1@lbLabelFontHeightF       = 0.015
resP1@pmLabelBarOrthogonalPosF = -0.01
gsn_panel(wks,plot1,(/3,2/),resP1)

resP2                          = True
resP2@gsnFrame                 = False
resP2@gsnPanelTop              = 0.35
resP2@gsnPanelBottom           = 0.02
gsn_panel(wks,plot2,(/1,2/),resP2)

frame (wks)
end
