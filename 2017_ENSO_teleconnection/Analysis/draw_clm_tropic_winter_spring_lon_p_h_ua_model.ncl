;*************************************************************
;Aim: Draw cross regression of three-month means of tropical monthly pressure/height zonal wind anomalies removed trend
;     onto November-December-January cold tongue index in CMIP model for animations

;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the plot
;                       Shan He
;                       2018-05-17
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
;   var2--------------uwnd
;   var3--------------ts
;   var4--------------ua
;================================================

    process = True      ; Pertinent statistics? Plot?

;data
;NCEP/NCAR 2.5x2.5
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/uwnd.mon.mean.nc"

    in_path4     = "~/data-model/CMIP5-hes/ua/historical/"
    in_name4     = new(37,string)
    in_name4(0)  = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(1)  = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(2)  = "ua_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(2)  = "ua_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    in_name4(3)  = "ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(4)  = "ua_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
    in_name4(3)  = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(5)  = "ua_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(6)  = "ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(7)  = "ua_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(8)  = "ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(9)  = "ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(4)  = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(5)  = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(6)  = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(7)  = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    in_name4(8)  = "ua_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(9)  = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(15) = "ua_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
    in_name4(10) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    in_name4(17) = "ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(11) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    in_name4(12) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
    in_name4(13) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(14) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    in_name4(15) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(16) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(17) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    in_name4(18) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
    in_name4(19) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    in_name4(26) = "ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
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

    iM =(/9,26,27,28,29/)
;    iM1 =(/0,1,3,7,14,17,24,26,27,33/)
;    iM2 =(/4,5,6,9,12,24,25,26,29,30/)

;time
    yS = 1958
    yE = 2004

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
;    latN1 = 10
;    latS1 = -10
    lonW1 = 50
    lonE1 = 100

;North Pacific
;    latN3 = 45
;    latS3 = 35
;    lonW3 = 160
;    lonE3 = 200

;tropical North Atlantic
;    latN2 = 25
;    latS2 = 5
    lonW2 = 305 
    lonE2 = 345

;region
    latN = 10
    latS = -10
    levU = 100
    levL = 1000

; create points for box
    ypts1 = (/levU,levL,levL,levU/)
    xpts1 = (/lonE1,lonE1,lonW1,lonW1/)
    ypts2 = (/levU,levL,levL,levU/)
    xpts2 = (/lonE2,lonE2,lonW2,lonW2/)

;fig
    out_path1 = "~/hes/ENSO/NCL/"
    out_path2 = "~/hes/ENSO/Fig/"
    out_data = "clm_tropic_winter_spring_lon_p_h_ua_model.nc"
    out_name = "clm_tropic_winter_spring_lon_p_h_ua_model"

;text
    text1 = (/"a) OBS","b) MMM","c) Cluster","d) CSIRO-Mk3-6-0","e) MIROC4h","f) MIROC5","g) MIROC-ESM","h) MIROC-ESM-CHEM"/)
    text2 = (/" "+yS+"-"+yE,"m~F34~W~F~s~S~-1~N~/~F35~J~F~C"/)

if(process) then

do i=0,nmod-1

    print (i+" ing...")

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in4 = addfile (in_path4 + in_name4(i),"r")

;get the time indexs
    time4  = in4->time
    year4  = cd_calendar (time4,-1) /100
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)

    if(i .eq. 4 .or. i .eq. 6 .or. i .eq. 28 .or. i .eq. 29)then
     ua = in4->ua(iYYYY4,(/0,1,2,3,4,5,6,7,8,9,11,14/),{latN:latS},:)
    else if(i.eq.12)then
     ua = in4->ua(iYYYY4,(/0,1,2,4,5,6,7,8,9,10,11,12/),{latN:latS},:)
    else
     ua = in4->ua(iYYYY4,{:10000},{latN:latS},:)
    end if
    end if

    if(i.eq.0)then

     in2    = addfile (in_name2,"r")
     time2  = in2->time
     year2  = cd_calendar (time2,-1) /100
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
     uwnd   = in2->uwnd(iYYYY2,{:100},{latN:latS},:)

;-------------------------------------------------------------
     lat4 = in4->lat
     lon  = in4->lon
     plev = in4->plev({:10000})

;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw4 = cos (rad*lat4)
     copy_VarCoords (lat4,gw4)

    end if

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm4 = clmMonTLLL(ua)

;tropical
   uaA = dim_avg_wgt_n_Wrap( clm4, gw4({latN:latS}), 1, 2)
   dim = dimsizes(uaA)

;--------------------------------------------------------------
   if(i.eq.0)then
    ccr2 = new((/dim(1),dim(2),nmod/), float)
    mnmn = new((/dim(1),dim(2),8/), float)
    mnmn!2 = "member"
    copy_VarMeta(uaA(0,:,:), ccr2(:,:,0))
    copy_VarMeta(uaA(0,:,:), mnmn(:,:,0))
   end if

;compute linear regression
   ccr2(:,:,i)  = (/dim_avg_n(uaA((/11,0,1,2,3,4/),:,:), 0)/)

   if(i.eq.0)then
    clm2 = clmMonTLLL(uwnd)
    uwndA = dim_avg_wgt_n_Wrap(clm2, gw4({latN:latS}), 1, 2)
    ccr1 = dim_avg_n_Wrap(uwndA((/11,0,1,2,3,4/),:,:), 0)
   end if

;weighted centered pattern correlation
;    r = pattern_cor ( ccr1,ccr2,gw2,1)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   delete([/time4,year4/])

end do

mnmn(:,:,0) = (/ccr1/)
mnmn(:,:,1) = (/dim_avg(ccr2)/)
mnmn(:,:,2) = (/dim_avg(ccr2(:,:,iM))/)
mnmn(:,:,3:) = (/ccr2(:,:,iM)/)
printVarSummary (mnmn)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

system ("rm -f " + out_path1 + out_data)
fout = addfile(out_path1 + out_data, "c")
setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"plev","lon","member"/)
dimSizes = (/dim(1),dim(2),8/)
dimUnlim = (/False,False,False/)

filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef(fout, "plev", typeof(plev), getvardims(plev))
filevardef(fout, "lon", typeof(lon), getvardims(lon))
filevardef(fout, "member", "integer", "member")
filevardef(fout, "mnmn", typeof(mnmn), getvardims(mnmn))

;Copy attributes associated with each variable to the file
filevarattdef(fout, "plev", plev)
filevarattdef(fout, "lon", lon)
filevarattdef(fout, "mnmn", mnmn)

;output only the data values
fout->plev = (/plev/)
fout->lon = (/lon/)
fout->member = ispan(1, 8, 1)
fout->mnmn = (/mnmn/)

else

 in = addfile(out_path1 + out_data, "r")
 mnmn = in->mnmn
 printVarSummary(mnmn)

end if

; ==============================================================
; Mission 4. Draw the differences
; ==============================================================

wks = gsn_open_wks("svg", out_path2 + out_name)
plot = new(8, graphic)
dum1 = new(16, graphic)  
dum2 = new(16, graphic)  
dum3 = new(8, graphic)  

;----------------------------------------------------------
res = True

res@gsnDraw              = False
res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .018

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-10.,-5.,-2.5,2.5,5.,10./)

res@lbLabelBarOn = False

res@vpHeightF = 0.25

res@tmXBTickSpacingF     = 60.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = text2(1)
; res@tmXBLabelsOn    = False
plot(0) = gsn_csm_pres_hgt (wks,mnmn(:,:,0),res)

res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(1) = gsn_csm_pres_hgt (wks,mnmn(:,:,1),res)

do i = 2, 7
 res@gsnLeftString = text1(i)
 plot(i) = gsn_csm_pres_hgt (wks,mnmn(:,:,i),res)
end do

;************************************************
; add the box
;************************************************
resb1 = True
resb2 = True
resb1@gsLineThicknessF = 3.
resb2@gsLineDashPattern = 1

do i = 0, 7
 do j = 0, 2, 2
  dum1(i*2+j/2) = gsn_add_polyline(wks, plot(i), xpts1(j:j+1), ypts1(j:j+1), resb1)
  dum2(i*2+j/2) = gsn_add_polyline(wks, plot(i), xpts2(j:j+1), ypts2(j:j+1), resb1)
 end do
  dum3(i) = gsn_add_polyline(wks, plot(i), (/0,360/), (/400,400/), resb2)
end do 

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txFontHeightF            = 0.026
resP@gsnPanelBottom           = 0.04
resP@gsnPanelLabelBar         = True
resP@lbLabelFontHeightF       = 0.012
resP@pmLabelBarOrthogonalPosF = -0.008

resP@txString = "CLM of Dec-May UWND"
gsn_panel (wks,plot,(/4,2/),resP)

end
