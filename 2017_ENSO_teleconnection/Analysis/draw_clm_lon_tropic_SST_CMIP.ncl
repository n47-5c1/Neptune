;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of cross regression between November-December-January cold tongue index and three-month means of the sea surface temperature
;     anomalies removed trend at the Pacific equator in CMIP model
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-01-29
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

    process = False      ; Pertinent statistics? Plot?

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
;    in_name(3)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    in_name(3)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(4)  = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(5)  = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(6)  = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(7)  = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(8)  = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(9)  = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(10) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    in_name(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;    in_name(20) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    in_name(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    in_name(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    in_name(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    in_name(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;    in_name(29) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
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

    iM = (/9,26,27,28,29/)

;time
    yS = 1958
    yE = 2004
    iMM = (/11,0,1,2,3,4/)

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270
;Nino3
;    latNI = 5
;    latSI = -5
;    lonWI = 210
;    lonEI = 270
;Nino3.4
;    latNI = 5
;    latSI = -5
;    lonWI = 190
;    lonEI = 240

;tropical Indian Ocean
    lonW1 = 50
    lonE1 = 100

;tropical North Atlantic
    lonW2 = 305 
    lonE2 = 345

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 280

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./clm_lon_tropic_SST_CMIP.nc"
    out_name = "clm_lon_tropic_SST_CMIP"

;text
    text1 = (/"a) ","b) ","c) "/)
    text2 = (/"HadISST","MMM","Cluster"/)
    text3 = (/"5~F35~J~F~S - 5~F35~J~F~N, "+yS+"-"+yE,"~F35~J~F~C/~F35~J~F~C"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

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

    if(i.eq.0)then
     in1    = addfile (in_name1,"r")
     lon1   = in1->lon
     time1  = in1->time
     year1  = cd_calendar (time1,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
;     sst1   = lonFlip (in1->sst(iYYYY1,{latN:latS},:))
     sst1   = in1->sst(iYYYY1,:,:)
;     sst1   = short2flt (in3->sst(iYYYY3,{latN:latS},:))
    end if

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
;    gw  = in1->latitude({latN:latS})
    gw  = in->lat
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL (sst)
   SSTA = dim_avg_wgt_n_Wrap ( clm(:,{latN:latS},:), gw({latN:latS}), 1, 1)
   dim  = dimsizes (SSTA)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr = new((/dim(0),dim(1),nmod+3/),float)
   end if

;compute linear regression
   ccr(0,:,i+3)  = (/dim_avg_n (SSTA(iMM,:),0)/)

   if(i.eq.0)then
    copy_VarMeta (SSTA,ccr(:,:,0))

    clm1  = clmMonTLL (sst1)
    SSTA1 = dim_avg_wgt_n_Wrap ( clm1(:,{latN:latS},:), gw({latN:latS}), 1, 1)
    ccr(0,:,0) = (/dim_avg_n (SSTA1(iMM,:),0)/)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time,year/])

end do

   ccr(:,:,1) = dim_avg ( ccr(:,:,3:) )
   ccr(:,:,2) = dim_avg ( ccr(:,:,iM+3) )
   ccr!2 = "model"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f "+out_data)
fout = addfile (out_data,"c")
setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"month","lon","model"/)
dimSizes = dimsizes (ccr)
dimUnlim = (/False,False,False/)

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"month","integer","month")
filevardef (fout,"lon",typeof(lon1),getvardims(lon1))
filevardef (fout,"model","integer","model")
filevardef (fout,"ccr",typeof(ccr),getvardims(ccr))

;Copy attributes associated with each variable to the file
;filevarattdef (fout,"season",ccr1&season)
filevarattdef (fout,"lon",lon1)
filevarattdef (fout,"ccr",ccr)

;output only the data values
fout->month = ispan(0,dim(0)-1,1)
;fout->lon   = (/lon1({lonW:lonE})/)
fout->lon    = (/lon1/)
fout->model  = ispan(0,nmod+2,1)
fout->ccr    = (/ccr/)

else

 in  = addfile (out_data,"r")
 ccr = in->ccr
 ccr(:,:,1:) = ccr(:,:,1:)-273.16
 dim = dimsizes (ccr)
 printVarSummary (ccr)

end if

;ccr = lonPivot (ccr,25)

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks  = gsn_open_wks ("svg",out_path + out_name)
plot = new (3,graphic)

res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .021

res@xyLineThicknessF = 2

;res@tmXBTickSpacingF     = 15.
res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

res@tiYAxisString      = "Lag (months)"
res@tiYAxisFontHeightF = 0.021

res@vpWidthF  = .75
res@vpHeightF = 0.25

res@gsnLeftString   = text1(0)+text2(0)
res@gsnCenterString = text3(0)
res@gsnRightString  = text3(1)
plot(0) = gsn_csm_xy (wks,ccr&lon,ccr(0,:,0),res)

;res@gsnLeftString   = text1(1)+text2(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
res@xyLineColor = "blue"
plot(1) = gsn_csm_xy (wks,ccr&lon,ccr(0,:,1),res)

res@xyLineColor = "red"
plot(2) = gsn_csm_xy (wks,ccr&lon,ccr(0,:,2),res)

overlay(plot(0),plot(1))
overlay(plot(0),plot(2))
/;
;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
;resl@gsLineDashPattern = 1
;dum1 = gsn_add_polyline (wks,plot(0),(/165,165/),(/0,dim(0)-1/),resl)
;dum2 = gsn_add_polyline (wks,plot(1),(/165,165/),(/0,dim(0)-1/),resl)
;dum3 = gsn_add_polyline (wks,plot(0),(/270,270/),(/0,dim(0)-1/),resl)
;dum4 = gsn_add_polyline (wks,plot(1),(/270,270/),(/0,dim(0)-1/),resl)
dum1a = gsn_add_polyline (wks,plot(0),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum2a = gsn_add_polyline (wks,plot(1),(/lonWI,lonWI/),(/0,dim(0)-1/),resl)
dum3a = gsn_add_polyline (wks,plot(0),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum4a = gsn_add_polyline (wks,plot(1),(/lonEI,lonEI/),(/0,dim(0)-1/),resl)
dum1b = gsn_add_polyline (wks,plot(0),(/lonW1,lonW1/),(/0,dim(0)-1/),resl)
dum2b = gsn_add_polyline (wks,plot(1),(/lonW1,lonW1/),(/0,dim(0)-1/),resl)
dum3b = gsn_add_polyline (wks,plot(0),(/lonE1,lonE1/),(/0,dim(0)-1/),resl)
dum4b = gsn_add_polyline (wks,plot(1),(/lonE1,lonE1/),(/0,dim(0)-1/),resl)
dum1c = gsn_add_polyline (wks,plot(0),(/lonW2,lonW2/),(/0,dim(0)-1/),resl)
dum2c = gsn_add_polyline (wks,plot(1),(/lonW2,lonW2/),(/0,dim(0)-1/),resl)
dum3c = gsn_add_polyline (wks,plot(0),(/lonE2,lonE2/),(/0,dim(0)-1/),resl)
dum4c = gsn_add_polyline (wks,plot(1),(/lonE2,lonE2/),(/0,dim(0)-1/),resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.028
resP@gsnPanelBottom           = 0.04
;resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.02
;resP@pmLabelBarOrthogonalPosF = -0.008
resP@txString = "Regression of SSTA onto NDJ CTI"

gsn_panel (wks,plot,(/3,1/),resP)
;/

draw(plot(0))
frame(wks)

end
