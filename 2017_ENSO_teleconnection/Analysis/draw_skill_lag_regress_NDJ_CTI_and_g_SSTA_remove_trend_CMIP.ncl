;*************************************************************
;Aim: Draw skill score in simulation of cross regression map between November-December-January cold tongue index and three-month means of
;     global monthly sea surface temperature anomalies removed trend in CMIP data
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Output  data
;   4. Draw the plots
;                       He Shan
;                       2017-10-08
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;----------------------------------------------------------------------
; Procedure to attach a horizontal labelbar to the bottom of plot.
;----------------------------------------------------------------------
undef("add_labelbar")
procedure add_labelbar(wks,plot,colors,labels)
local vph, vpw, nboxes, lbres, lbid, amres, annoid
begin
  getvalues plot                      ; Get plot size for use in
    "vpHeightF" : vph                 ; creating labelbar.
    "vpWidthF"  : vpw
  end getvalues

  nboxes = dimsizes(colors)

  lbres                    = True          ; labelbar only resources
  lbres@lbAutoManage       = False         ; Necessary to control sizes
  lbres@vpWidthF           = 0.08 * vpw    ; labelbar width
  lbres@vpHeightF          = 0.95 * vph    ; labelbar height
  lbres@lbFillColors       = colors        ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.01          ; font height. default is small
  lbres@lbLabelAlignment   = "InteriorEdges"  ; center of box
  lbres@lbOrientation      = "Vertical"
  lbres@lbPerimOn          = False

  lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
   
;
; Now, create some annotation resources indicating how we want to
; attach the labelbar to the plot. Here, we are using the top right
; corner of the labelbar as the point which we are going to position
; it, and then we use amParallelPosF and amOrthogonalPosF to indicate
; where we want to place it.
;
; amParallelPosF/amOrthogonalPosF                                       ;
;    0.0/ 0.0  -  annotation in dead center of plot
;    0.5/ 0.5  -  annotation at bottom right of plot
;    0.5/-0.5  -  annotation at top right of plot
;   -0.5/-0.5  -  annotation at top left of plot
;   -0.5/ 0.5  -  annotation at bottom left of plot
;                                                                 
  amres                  = True
  amres@amJust           = "CenterLeft"
  amres@amParallelPosF   =  0.52
  amres@amOrthogonalPosF =  0.0
  plot@annoid = gsn_add_annotation(plot,lbid,amres)
end


begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------ts
;================================================

    process = False      ; Skill score? Plot?

;data
    in_path0 = "~/hes/ENSO/Regrid/"
;HadISST1   1870/01 - , 1x1
    in_name0 = "HadISST_sst_2x2.nc"
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
    season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO"/)
    maxlag = dimsizes (season)

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270

;ENSO region
    latNE = 15
    latSE = -15
    lonWE = 130
    lonEE = 290

;region
    latN = 60
    latS = -60
;    lonW = 120
;    lonE = 280

    S = new((/maxlag,46/),double)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./skill_lag_regress_NDJ_CTI_and_g_SSTA_remove_trend.nc"
    out_name = "skill_lag_regress_NDJ_CTI_and_g_SSTA_remove_trend"

;text
    text1 = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanCM4","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-CAM5-1-FV2",\
              "CESM1-FASTCHEM","CESM1-WACCM","CMCC-CESM","CMCC-CM","CMCC-CMS","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","FIO-ESM",\
              "GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3","HadGEM2-AO","HadGEM2-CC",\
              "HadGEM2-ES","INMCM4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC4h","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR",\
              "MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","NorESM1-M","NorESM1-ME"/)
    text2 = "Lag (months)"

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

    sst = in->ts(iYYYY,{latN:latS},:)
;    sst = lonFlip (in->ts(iYYYY,{latN:latS},:))
    print (min(sst))

    if(i.eq.0)then 
     in0    = addfile (in_path0 + in_name0,"r")
     time0  = in0->time
     year0  = cd_calendar (time0,-1) /100
     iYYYY0 = ind (year0.ge.yS .and. year0.le.yE)
     sst0   = in0->sst(iYYYY0,{latN:latS},:)
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = in->lat({latN:latS})
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

   CTI_NDJ = wgt_areaave_Wrap ( SSTA_Sea(0,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
   dim     = dimsizes (CTI_NDJ)

;compute linear regression
   rc = (/regCoef_n (CTI_NDJ,SSTA_Sea,0,1)/)
   rc(1:,:,:) = (/regCoef_n ( CTI_NDJ(:dim-2), SSTA_Sea(1:,1:,:,:), 0,1)/)

   if(i.eq.0)then
    copy_VarCoords (SSTA_Sea(:,0,:,:),rc)

    clm0  = clmMonTLL (sst0)
    SSTA0 = calcMonAnomTLL (sst0, clm0)
    SSTA0 = (/dtrend_msg_n (SSTA0&time,SSTA0,False,False,0)/)
    SSTA_Sea0 = month_to_seasonN (SSTA0,season)
    CTI_NDJ0 = wgt_areaave_Wrap ( SSTA_Sea0(0,:,{latNI:latSI},{lonWI:lonEI}), gw({latNI:latSI}), 1., 0)
    rc0 = regCoef_n (CTI_NDJ0,SSTA_Sea0,0,1)
    rc0(1:,:,:) = regCoef_n ( CTI_NDJ0(:dim-2), SSTA_Sea0(1:,1:,:,:), 0,1)
    copy_VarCoords (SSTA_Sea0(:,0,:,:),rc0)

;-------------------------------------------------------------
    rc0(:,{latNE:latSE},{lonWE:lonEE}) = rc0@_FillValue

;ratio of centered RMS difference
    wgtc   = conform_dims ( dimsizes(rc0), gw, 1) 
    rc0avg = sum(wgtc*rc0) / sum(wgtc)
    std0   = sum (wgtc*(rc0-rc0avg)^2)
   end if

    rc(:,{latNE:latSE},{lonWE:lonEE}) = rc@_FillValue

    rcavg = sum(wgtc*rc) / sum(wgtc)
    std   = sum (wgtc*(rc-rcavg)^2)

    rat = sqrt (std/std0)
;    copy_VarCoords_2 (SSTA_Sea0(:,0,:,:),rat)
   
;weighted centered pattern correlation
   cc = pattern_cor (rc0,rc,tofloat(gw),0)

;skill score
;   S(:,i) = 2*(1.+cc) / (rat+1./rat)^2.
   S(:,i) = (1.+cc)^2. / (rat+1./rat)^2.
;   S(:,i) = (1.+cc)^4. / 4 / (rat+1./rat)^2.

   delete([/time,year/])

end do

   copy_VarCoords_2 (SSTA_Sea0(:,0,:,:),S)
   printVarSummary (S)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

S!1  = "model"
ndim = dimsizes (S)

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"season","model"/)
dimSizes = (/ndim(0),ndim(1)/) 
dimUnlim = (/False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"season","integer",getvardims(S&season))
filevardef (fout,"model","integer","model")
filevardef (fout,"S",typeof(S),getvardims(S))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"season",S&season)
;filevarattdef (fout," ", )
filevarattdef (fout,"S",S)
;output only the data values
fout->season = ispan(0,maxlag-1,1)
fout->model  = ispan(1,nmod,1)
fout->S      = (/S/)

else
 in = addfile (out_data,"r")
 S  = in->S
 ndim = dimsizes (S)
 printVarSummary (S)
end if


; ==============================================================
; Mission 4. Draw the plots
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)

;-------------------------------------------------------------
;Create a blank plot

res = True

res@gsnDraw       = False
res@gsnFrame      = False
res@gsnShape      = True
res@gsnLeftString = " "
;res@gsnStringFontHeightF = .021

;to have a common label bar
;res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels             = (/-.8,-.4,-.2,-.1,.1,.2,.4,.8/)

;res@vpWidthF  = 0.7
;res@vpHeightF = 0.16

;res@lbLabelBarOn  = False
;res@lbOrientation = "vertical"
;res@lbLabelFontHeightF = 0.013

;res@pmLabelBarWidthF         = 0.04
;res@pmLabelBarOrthogonalPosF = 0.01

res@trXMinF = 0
res@trXMaxF = nmod
res@trYMinF = 0
res@trYMaxF = maxlag

res@tmXBMode    = "Explicit"
res@tmXBValues  = fspan (.5,nmod-.5,nmod)
res@tmXBLabels  = text1
res@tmXBLabelJust        = "CenterLeft"
res@tmXBLabelAngleF      = -60.
res@tmXBLabelFontHeightF = 0.008
;Remove tickmarks
res@tmXBMajorLengthF        = 0.
res@tmXBMajorOutwardLengthF = 0.

res@tmYLMode    = "Explicit"
res@tmYLValues  = fspan (.5,maxlag-.5,maxlag)
res@tmYLLabels  = season
res@tmYLLabelFontHeightF = 0.008

res@tiMainString       = "Skill Score in Global ENSO-related SSTA"
res@tiMainFontHeightF  = 0.018
res@tiYAxisString      = text2
res@tiYAxisFontHeightF = .0

plot = gsn_csm_blank_plot (wks,res)

;-------------------------------------------------------------
;Fill each grid box

levels = fspan(.25,.75,6)
;rgba   = read_colormap_file ("WhiteYellowOrangeRed")
rgba   = read_colormap_file ("MPL_coolwarm")
colors = span_color_rgba (rgba, dimsizes(levels))

gnid = new((/maxlag,nmod/),"graphic")
line = new((/maxlag,nmod/),"graphic")

gnres = True
lnres = True

lnres@gsLineThicknessF = 1.5

do jj = 0,maxlag-1
 do ii = 0,nmod-1
  boxx  = (/ii,ii,ii+1,ii+1,ii/)
  boxy  = (/jj,jj+1,jj+1,jj,jj/)
  index = closest_val( S(jj,ii),levels)
  gnres@gsFillColor = colors(index,:)
  gnid(jj,ii) = gsn_add_polygon (wks,plot,boxx,boxy,gnres)
  line(jj,ii) = gsn_add_polyline(wks,plot,boxx,boxy,lnres)
 end do
end do

plot@gnid = gnid
plot@line = line

add_labelbar(wks,plot,colors,levels(1:)-.05)

draw (plot)
frame (wks)

end
