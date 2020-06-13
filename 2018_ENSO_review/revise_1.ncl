;*************************************************************
;Aim: Revise figure
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output deserved data
;   4. Draw the EOFs and PCs
;                       He Shan
;                       2018-03-09
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
    in_path = "~/data/observation/"
    in_name1 = "SST/NOAA_ERSST/sst.mnmean.v3.nc"
    in_name2 = "NCEP_NCAR/monthly/air.sig995.mon.mean.nc"
    in_name3 = "CAMS/tanom.nc"
    a      = addfile ("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
    lsdata = a->LSMASK

;time
    yS = 1950
    yE = 2010

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
    latN = 20
    latS = -20
    lonW = 120
    lonE = 280

;region
    latNM = 50
    latSM = 25
    lonWM = 235
    lonEM = 295

    neof        = 1      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_data = "./revise_1.nc"
    out_name = "./revise_1"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)"/)
    text2 = (/" EP El Nino impact"," CP El Nino impact"/)
    text3 = (/"NCEP/NCAR","CAMS"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")

    time1 = in1->time
    time2 = in2->time
    time3 = in3->T
    printVarSummary (time1)
    printVarSummary (time2)
    printVarSummary (time3)

;get the time indexs
    year1  = cd_calendar (time1,-1) /100
    year2  = cd_calendar (time2,-1) /100
    year3  = cd_calendar (time3,-1) /100
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)

    sst   = in1->sst(iYYYY1,{latN:latS},{lonW:lonE})
;    sst1 = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
    air   = in2->air(iYYYY2,:,:)
    tanom = in3->tanom(iYYYY3,:,:)

;masking of data
    lsm1  = landsea_mask (lsdata,air&lat,air&lon)
    lsm2  = landsea_mask (lsdata,tanom&Y,tanom&X)
    air   = mask (air,lsm1.eq.1.or.lsm1.eq.3,True)
    tanom = mask (tanom,lsm2.eq.1.or.lsm2.eq.3,True)

    printVarSummary (sst)
    printVarSummary (air)
    printVarSummary (tanom)

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

   printVarSummary (sst_EP)

;-------------------------------------------------------------
   print ("EOF...")

;EOF
    x = -sst_EP * conform (sst,clat,1)
    copy_VarMeta (sst,x)
    eof_EP = eofunc_n_Wrap (x,neof,optEOF,0)
    ts_EP  = eofunc_ts_n_Wrap (x,eof_EP,optETS,0)
    printVarSummary (eof_EP)

    x      = sst_CP * conform (sst,clat,1)
    eof_CP = eofunc_n_Wrap (x,neof,optEOF,0)
    ts_CP  = eofunc_ts_n_Wrap (x,eof_CP,optETS,0)
    printVarSummary (eof_CP)

;normalize time series
    ts_EP = dim_standardize_n_Wrap (ts_EP,0,1)
    ts_CP = dim_standardize_n_Wrap (ts_CP,0,1)
    ts_EP = -ts_EP

    printVarSummary (ts_EP)

;-------------------------------------------------------------
    print ("post-EOF...")

;compute seasonal means
    air_JFM   = month_to_season (air,"JFM")
    tanom_JFM = month_to_season (tanom,"JFM")
    ts_EP_JFM = month_to_season (ts_EP(0,:),"JFM")
    ts_CP_JFM = month_to_season (ts_CP(0,:),"JFM")
    dim = dimsizes (ts_EP_JFM)

;compute linear regression
    r1 = regCoef_n (ts_EP_JFM,air_JFM,0,0)
    r2 = regCoef_n (ts_CP_JFM,air_JFM,0,0)
    r3 = regCoef_n (ts_EP_JFM,tanom_JFM,0,0)
    r4 = regCoef_n (ts_CP_JFM,tanom_JFM,0,0)
    
    copy_VarMeta (air_JFM(0,:,:),r1)
    copy_VarMeta (air_JFM(0,:,:),r2)
    copy_VarMeta (tanom_JFM(0,:,:),r3)
    copy_VarMeta (tanom_JFM(0,:,:),r4)

    printVarSummary (r1)

;Determines the statistical significance
    p1 = rtest( escorc_n(ts_EP_JFM,air_JFM,0,0), dim, 0 )
    p2 = rtest( escorc_n(ts_CP_JFM,air_JFM,0,0), dim, 0 )
    p3 = rtest( escorc_n(ts_EP_JFM,tanom_JFM,0,0), dim, 0 )
    p4 = rtest( escorc_n(ts_CP_JFM,tanom_JFM,0,0), dim, 0 )
    p1 = mask (p1,lsm1.eq.1.or.lsm1.eq.3,True)
    p2 = mask (p2,lsm1.eq.1.or.lsm1.eq.3,True)
    p3 = mask (p3,lsm2.eq.1.or.lsm2.eq.3,True)
    p4 = mask (p4,lsm2.eq.1.or.lsm2.eq.3,True)
    copy_VarCoords (r1,p1)
    copy_VarCoords (r2,p2)
    copy_VarCoords (r3,p3)
    copy_VarCoords (r4,p4)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
/;
dim = dimsizes (r1)
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
;/
; ==============================================================
; Mission 4. Draw the EOF
; ==============================================================

 wks   = gsn_open_wks("svg",out_name)
 plot1 = new (4,graphic)
 plot2 = new (4,graphic)
 plot3 = new (2,graphic)

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw      = False
res@gsnFrame     = False
;res@gsnAddCyclic = True
res@gsnStringFontHeightF = 0.035

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap

res@mpFillOn     = False
res@mpCenterLonF = 265
res@mpOutlineBoundarySets  = "GeophysicalAndUSStates"
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latSM
res@mpMaxLatF = latNM
res@mpMinLonF = lonWM
res@mpMaxLonF = lonEM

;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.5,-.4,-.3,-.2,-.1,.1,.2,.3,.4,.5/)

res@lbLabelBarOn = False

res@tmXBLabelsOn         = False
res@tmXBTickSpacingF     = 20.
res@tmXBLabelFontHeightF = 0.033
res@tmYLLabelFontHeightF = 0.033

res@tiYAxisOffsetXF    = -.055
res@tiYAxisFontHeightF = .033

res@gsnLeftString   = text1(0)+text2(0)
res@gsnCenterString = " "
res@gsnRightString  = " "
res@tiYAxisString   = text3(0)
plot1(0) = gsn_csm_contour_map_ce (wks,r1,res)

res@gsnLeftString = text1(1)+text2(1)
res@tmYLLabelsOn  = False
res@tiYAxisString = " "
plot1(1) = gsn_csm_contour_map_ce (wks,r2,res)

res@gsnLeftString = text1(2)
res@tmYLLabelsOn  = True
res@tiYAxisString = text3(1)
plot1(2) = gsn_csm_contour_map_ce (wks,r3,res)

res@gsnLeftString = text1(3)
res@tmYLLabelsOn  = False
res@tiYAxisString = " "
plot1(3) = gsn_csm_contour_map_ce (wks,r4,res)

;---------------------------------------------------------------
;probability plots

res2 = True

res2@gsnDraw        = False
res2@gsnFrame       = False
res2@gsnLeftString  = " "
res2@gsnRightString = " "

res2@cnLinesOn      = False
;res2@cnFillScaleF   = 2.6
;res2@cnFillDotSizeF = 0.006
res2@cnInfoLabelOn  = False
res2@cnLineLabelsOn = False
res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels             = (/.01,.05,.1/)

plot2(0) = gsn_csm_contour (wks,p1,res2)
plot2(1) = gsn_csm_contour (wks,p2,res2)
plot2(2) = gsn_csm_contour (wks,p3,res2)
plot2(3) = gsn_csm_contour (wks,p4,res2)
do i=0,3
 plot2(i) = ShadeLtContour (plot2(i),.15,3)
 overlay (plot1(i),plot2(i))
end do

;---------------------------------------------------------------
;map
mpres = True

mpres@gsnDraw  = False
mpres@gsnFrame = False
mpres@gsnStringFontHeightF = 0.035

mpres@tmXBTickSpacingF     = 20.
mpres@tmXBLabelFontHeightF = 0.033
mpres@tmYLLabelFontHeightF = 0.033

mpres@mpFillOn  = False
mpres@mpMinLatF = latSM
mpres@mpMaxLatF = latNM
mpres@mpMinLonF = lonWM
mpres@mpMaxLonF = lonEM
mpres@mpCenterLonF          = 265
mpres@mpOutlineBoundarySets = "GeophysicalAndUSStates"

mpres@gsnLeftString = text1(4)
plot3(0) = gsn_csm_map (wks,mpres)

mpres@gsnLeftString = text1(5)
mpres@tmYLLabelsOn  = False
plot3(1) = gsn_csm_map (wks,mpres)

;*******************************************
;create panel resources
;*******************************************
resP1 = True
resP1@gsnFrame                 = False
resP1@gsnPanelBottom           = 0.63
resP1@gsnPanelLabelBar         = True
resP1@lbOrientation            = "vertical"
resP1@pmLabelBarHeightF        = 0.22
resP1@lbLabelFontHeightF       = 0.014
;resP1@pmLabelBarOrthogonalPosF = -0.01
gsn_panel(wks,plot1,(/2,2/),resP1)

resP2 = True
resP2@gsnFrame       = False
resP2@gsnPanelTop    = 0.63
resP2@gsnPanelBottom = 0.415
resP2@gsnPanelRight  = 0.91
gsn_panel(wks,plot3,(/1,2/),resP2)

frame (wks)
end
