;*************************************************************
;Aim: Draw hovmoller diagram (time vs. latitude) of correlation between the western/central Pacific wind anomalies and the EP/CP indexes
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the hovmoller
;
;                       Shan He
;                       2018-11-21
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var3--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

    a = 0.05

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2017
    iYY = (/64,70,71,74,75,83,84,88,95,98,99,100,105,107,108,110,111,116/) - 57
    season = "DJF"

;region
    latN = 10
    latS = -10
    lonWW = 120
    lonEW = 160
    lonWC = 160
    lonEC = 240

;Nino1+2
    latN1 = 0
    latS1 = -10
    lonW1 = 270
    lonE1 = 280

;Nino3
    latN2 = 5
    latS2 = -5
    lonW2 = 210
    lonE2 = 270

;Nino4
    latN3 = 5
    latS3 = -5
    lonW3 = 160
    lonE3 = 210

;EOF
    latNeof = 20
    latSeof = -20
    lonWeof = 120
    lonEeof = 290;280
    neof = 1
    optEOF = False
    optETS = False

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "hovmoller_lat_corel_Pacific_UV_anom_EP_CP_index_ElNino"

;text
;    text1 = (/"a) Kao and Yu 2009","b)","a) Yeh et al. 2009","b)"/)
    text1 = (/"a) EP and ~F10~U~B~sfc","c) CP","a) EP and ~F10~U~B~sfc","c) CP"/)
    text2 = (/"The western Pacific","The central Pacific"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Correlation between UVA and EP/CP Indexes"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    time1 = in1->time
    time3 = in3->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    year1 = toint(TIME1(:,0))
    year3 = toint(TIME3(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)

;----------------------------------------------------------

    uwnd = in1->uwnd(iYYYY1,:,:)
    vwnd = in2->vwnd(iYYYY1,:,:)
    sst_p = lonFlip(in3->sst)
    sst = sst_p(iYYYY3,{latNeof:latSeof},{lonWeof:lonEeof})

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw = in3->latitude
    gw = cos (rad*gw)
    clat = in3->latitude({latNeof:latSeof})
    clat = sqrt(cos(rad * clat))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(sst)

;Monthly anomalies
    UA = calcMonAnomTLL(uwnd, clm1)
    VA = calcMonAnomTLL(vwnd, clm2)
    SSTA = calcMonAnomTLL(sst, clm3)

    UA = (/dtrend_msg_n(UA&time, UA, False, False, 0)/)
    VA = (/dtrend_msg_n(VA&time, VA, False, False, 0)/)
    SSTA = (/dtrend_msg_n(SSTA&time, SSTA, False, False, 0)/)

;-------------------------------------------------------------
print("EP/CP-index method (Kao and Yu 2009)")
;subtract values regressed with series
   Nino12 = wgt_areaave_Wrap(SSTA(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0) 
   Nino4 = wgt_areaave_Wrap(SSTA(:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)

   rc = regCoef_n(Nino4, SSTA, 0, 0)
   sst_EP = SSTA - conform(SSTA, rc, (/1,2/)) * conform(SSTA, Nino4, 0)
   copy_VarMeta(SSTA, sst_EP)

   rc = regCoef_n(Nino12, SSTA, 0, 0)
   sst_CP = SSTA - conform(SSTA, rc, (/1,2/)) * conform(SSTA, Nino12, 0)
   copy_VarMeta(SSTA, sst_CP)

;EOF
    y = sst_EP * conform(sst, clat, 1)
    copy_VarMeta(sst, y)
    eof_EP = eofunc_n_Wrap(y, neof, optEOF, 0)
    eof_ts_EP = eofunc_ts_n_Wrap(y, eof_EP, optETS, 0)
    eof_ts_EP = (/-eof_ts_EP/)

    y = sst_CP * conform(sst, clat, 1)
    eof_CP = eofunc_n_Wrap(y, neof, optEOF, 0)
    eof_ts_CP = eofunc_ts_n_Wrap(y, eof_CP, optETS, 0)
    eof_ts_CP = (/-eof_ts_CP/)

    EP1 = month_to_season(eof_ts_EP(0,:), season)
    CP1 = month_to_season(eof_ts_CP(0,:), season)

    EP1(iYY) = (/EP1@_FillValue/)
    CP1(iYY) = (/CP1@_FillValue/)

    x1 = escorc(EP1, CP1)
    print((/x1/))

;-------------------------------------------------------------
print("Niño method (Yeh et al. 2009)")
    Nino3 = wgt_areaave_Wrap(SSTA(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

    EP2 = month_to_season(Nino3, season)
    CP2 = month_to_season(Nino4, season)

    EP2(iYY) = (/EP2@_FillValue/)
    CP2(iYY) = (/CP2@_FillValue/)
    dim = dimsizes(EP2)

    x2 = escorc(EP2, CP2)
    print((/x2/))

;----------------------------------------------------------
   UA12 = month_to_seasonN(UA, (/"DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO","SON","OND","NDJ"/))
   VA12 = month_to_seasonN(VA, (/"DJF","JFM","FMA","MAM","AMJ","MJJ","JJA","JAS","ASO","SON","OND","NDJ"/))
   do i = mS-1, 11
    UA12(i,1:,:,:) = (/UA(i:12*dim-13:12,:,:)/)
    VA12(i,1:,:,:) = (/VA(i:12*dim-13:12,:,:)/)
    UA12(i,0,:,:) = UA12@_FillValue
    VA12(i,0,:,:) = VA12@_FillValue
   end do
   do i = 0, mE-1
    UA12(i,:,:,:) = (/UA(::12,:,:)/)
    VA12(i,:,:,:) = (/VA(::12,:,:)/)
   end do

   UAyW = dim_avg_n_Wrap(UA12(time|:,{lat|latN:latS},{lon|lonWW:lonEW},season|:), 2)
   VAyW = dim_avg_n_Wrap(VA12(time|:,{lat|latN:latS},{lon|lonWW:lonEW},season|:), 2)
   UAyC = dim_avg_n_Wrap(UA12(time|:,{lat|latN:latS},{lon|lonWC:lonEC},season|:), 2)
   VAyC = dim_avg_n_Wrap(VA12(time|:,{lat|latN:latS},{lon|lonWC:lonEC},season|:), 2)

    UAyW&season = ispan(0,11,1)
    VAyW&season = ispan(0,11,1)
    UAyC&season = ispan(0,11,1)
    VAyC&season = ispan(0,11,1)

    ccr1W = escorc_n(UAyW, EP1, 0, 0)
    ccr2W = escorc_n(VAyW, EP1, 0, 0)
    ccr3W = escorc_n(UAyW, CP1, 0, 0)
    ccr4W = escorc_n(VAyW, CP1, 0, 0)
    ccr1C = escorc_n(UAyC, EP1, 0, 0)
    ccr2C = escorc_n(VAyC, EP1, 0, 0)
    ccr3C = escorc_n(UAyC, CP1, 0, 0)
    ccr4C = escorc_n(VAyC, CP1, 0, 0)
    ccr1 = (ccr1W - ccr3W * x1) / sqrt((1. - ccr3W^2.) * (1. - x1^2.))
    ccr2 = (ccr2W - ccr4W * x1) / sqrt((1. - ccr4W^2.) * (1. - x1^2.))
    ccr3 = (ccr3C - ccr1C * x1) / sqrt((1. - ccr1C^2.) * (1. - x1^2.))
    ccr4 = (ccr4C - ccr2C * x1) / sqrt((1. - ccr2C^2.) * (1. - x1^2.))
    ccr5W = escorc_n(UAyW, EP2, 0, 0)
    ccr6W = escorc_n(VAyW, EP2, 0, 0)
    ccr7W = escorc_n(UAyW, CP2, 0, 0)
    ccr8W = escorc_n(VAyW, CP2, 0, 0)
    ccr5C = escorc_n(UAyC, EP2, 0, 0)
    ccr6C = escorc_n(VAyC, EP2, 0, 0)
    ccr7C = escorc_n(UAyC, CP2, 0, 0)
    ccr8C = escorc_n(VAyC, CP2, 0, 0)
    ccr5 = (ccr5W - ccr7W * x2) / sqrt((1. - ccr7W^2.) * (1. - x2^2.))
    ccr6 = (ccr6W - ccr8W * x2) / sqrt((1. - ccr8W^2.) * (1. - x2^2.))
    ccr7 = (ccr7C - ccr5C * x2) / sqrt((1. - ccr5C^2.) * (1. - x2^2.))
    ccr8 = (ccr8C - ccr6C * x2) / sqrt((1. - ccr6C^2.) * (1. - x2^2.))

    ccr1 = (/ccr1(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr2 = (/ccr2(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr3 = (/ccr3(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr4 = (/ccr4(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr5 = (/ccr5(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr6 = (/ccr6(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr7 = (/ccr7(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)
    ccr8 = (/ccr8(:,(/5,6,7,8,9,10,11,0,1,2,3,4/))/)

    copy_VarCoords(UAyW(0,:,:),ccr1)
    copy_VarCoords(VAyW(0,:,:),ccr2)
    copy_VarCoords(UAyC(0,:,:),ccr3)
    copy_VarCoords(VAyC(0,:,:),ccr4)
    copy_VarCoords(UAyW(0,:,:),ccr5)
    copy_VarCoords(VAyW(0,:,:),ccr6)
    copy_VarCoords(UAyC(0,:,:),ccr7)
    copy_VarCoords(VAyC(0,:,:),ccr8)
    
;---------------------------------------------------------------
;perform significance test
    N = num(.not.ismissing(EP1))
    print((/N/))
    H1 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr1)/(1-ccr1))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H2 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr2)/(1-ccr2))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H3 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr3)/(1-ccr3))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H4 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr4)/(1-ccr4))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H5 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr5)/(1-ccr5))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H6 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr6)/(1-ccr6))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H7 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr7)/(1-ccr7))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H8 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr8)/(1-ccr8))) .gt. 1.0/cdfnor_p(1-a/2.0,0,1), 1.0, 0.0)/)
    H1 = H1 + H2
    H3 = H3 + H4
    H5 = H5 + H6
    H7 = H7 + H8

    copy_VarCoords(UAyW(0,:,:),H1)
    copy_VarCoords(VAyW(0,:,:),H2)
    copy_VarCoords(UAyC(0,:,:),H3)
    copy_VarCoords(VAyC(0,:,:),H4)
    copy_VarCoords(UAyW(0,:,:),H5)
    copy_VarCoords(VAyW(0,:,:),H6)
    copy_VarCoords(UAyC(0,:,:),H7)
    copy_VarCoords(VAyC(0,:,:),H8)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)
plot3 = new(4, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnCenterString = " "
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-.6,-.45,-.3,-.15,.15,.3,.45,.6/)

res@lbLabelBarOn = False

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0,11,3)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@vpWidthF = 1.
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
res@gsnRightString = text2(0)
plot1(0) = gsn_csm_hov(wks, ccr1, res)

res@gsnLeftString = text1(2)
plot1(2) = gsn_csm_hov(wks, ccr5, res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(1)
plot1(1) = gsn_csm_hov(wks, ccr3, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ccr7, res)

;---------------------------------------------------------------
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 2

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0/)
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False

plot2(0) = gsn_csm_hov(wks, ccr1, res2)
plot2(1) = gsn_csm_hov(wks, ccr3, res2)
plot2(2) = gsn_csm_hov(wks, ccr5, res2)
plot2(3) = gsn_csm_hov(wks, ccr7, res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do

;---------------------------------------------------------------
res3 = True

res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "

res3@lbLabelBarOn = False

res3@vcLevelPalette = "gsltod"
res3@vcLevelSelectionMode = "ExplicitLevels"
res3@vcLevels = (/-0.1,0.2,0.5/)
res3@vcRefAnnoOn = False
res3@vcRefLengthF = 0.07
res3@vcRefMagnitudeF = 1.2
res3@vcRefAnnoString2On = False
res3@vcRefAnnoFontHeightF = 0.016
res3@vcRefAnnoOrthogonalPosF = 0.27
res3@vcMinDistanceF = 0.04
res3@vcLineArrowThicknessF = 2.
res3@vcLineArrowHeadMaxSizeF = 0.036
res3@vcLineArrowHeadMinSizeF = 0.012

plot3(0) = gsn_csm_vector_scalar(wks, ccr1, ccr2, H1, res3)
plot3(1) = gsn_csm_vector_scalar(wks, ccr3, ccr4, H3, res3)
plot3(2) = gsn_csm_vector_scalar(wks, ccr5, ccr6, H5, res3)
res3@vcRefAnnoOn = True
plot3(3) = gsn_csm_vector_scalar(wks, ccr7, ccr8, H7, res3)

do i = 0, 3
    overlay(plot1(i), plot3(i))
end do
/;
;---------------------------------------------------------------
;probability plots
res3 = True
res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "

res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLevels = fspan(0.01, 0.1, 10)
res3@cnInfoLabelOn = False
res3@cnLinesOn = False
res3@cnLineLabelsOn = False
res3@cnFillDotSizeF = 0.004
res3@cnFillScaleF = 2.

do i = 0, 3
    plot3(i*2) = gsn_csm_contour(wks1, prob5(i,:,:), res3)
    plot3(i*2) = ShadeLtContour(plot3(i*2), 0.055, 17)
    plot4(i*2) = gsn_csm_contour(wks2, prob7(i,:,:), res3)
    plot4(i*2) = ShadeLtContour(plot4(i*2), 0.055, 17)
    plot3(i*2+1) = gsn_csm_contour(wks1, prob6(i,:,:), res3)
    plot3(i*2+1) = ShadeLtContour(plot3(i*2+1), 0.055, 17)
    plot4(i*2+1) = gsn_csm_contour(wks2, prob8(i,:,:), res3)
    plot4(i*2+1) = ShadeLtContour(plot4(i*2+1), 0.055, 17)
    overlay(plot1(i*2), plot3(i*2))
    overlay(plot2(i*2), plot4(i*2))
    overlay(plot1(i*2+1), plot3(i*2+1))
    overlay(plot2(i*2+1), plot4(i*2+1))
end do
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = 0.065
resP@txString = text4
gsn_panel(wks, plot1, (/2,2/), resP)

end
