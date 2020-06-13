;*************************************************************
;Aim: Draw (partial?) correlation between tropical seasonal surface wind anomalies during positive phase and DJF EP index as well as CP index
;     calculated by two methods
;
;Mission:
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;
;                       Shan He
;                       2018-11-09
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var5--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

    a = 0.05

;time
    yS = 1958
    yE = 2017
    iYY = (/64,70,71,74,75,83,84,88,95,98,99,100,105,107,108,110,111,116/) - 57
    season = (/"SON","DJF","MAM"/)

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
    latN = 20
    latS = -20
    lonW = 120
    lonE = 290;280
    neof = 1
    optEOF = False
    optETS = False

;map region
    latNm = 30
    latSm = -30
    lonLm = 90
    lonRm = 270

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name1 = "corel_tropic_ElNino_UV_anom_DJF_EP_CP_index_Kao_2009"
    out_name2 = "corel_tropic_ElNino_UV_anom_DJF_EP_CP_index_Yeh_2009"

;text
    text1 = (/"a) SON(0)","b)","b)  EP","d)  CP","e) MAM(+1)","f)"/)
    text2 = (/"EP","CP","DJF(0)"/)
    text3 = "Correlation between Wind Anomalies and EP/CP Index"
    text4 = "Correlation between Wind Anomalies and EP/CP Index"

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
    sst = sst_p(iYYYY3,{latN:latS},{lonW:lonE})

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad = 4. * atan(1.) / 180.
    gw = in3->latitude({latN:latS})
    clat = in3->latitude({latN:latS})
    gw = cos(rad * gw)
    clat = sqrt(cos(rad * clat))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)
    SSTA = calcMonAnomTLL(sst, clm3)
    print("Anom")

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
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

    EP1 = month_to_season(eof_ts_EP(0,:), season(1))
    CP1 = month_to_season(eof_ts_CP(0,:), season(1))

    EP1(iYY) = (/EP1@_FillValue/)
    CP1(iYY) = (/CP1@_FillValue/)

    x1 = escorc(EP1, CP1)
    print((/x1/))

;-------------------------------------------------------------
print("Niño method (Yeh et al. 2009)")
    Nino3 = wgt_areaave_Wrap(SSTA(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)

    EP2 = month_to_season(Nino3, season(1))
    CP2 = month_to_season(Nino4, season(1))

    EP2(iYY) = (/EP2@_FillValue/)
    CP2(iYY) = (/CP2@_FillValue/)

    x2 = escorc(EP2, CP2)
    print((/x2/))

;----------------------------------------------------------
   season1 = month_to_seasonN(Anom1, season)
   season2 = month_to_seasonN(Anom2, season)

    ccr1_p = escorc_n(season1, EP1, 1, 0)
    ccr2_p = escorc_n(season2, EP1, 1, 0)
    ccr3_p = escorc_n(season1, CP1, 1, 0)
    ccr4_p = escorc_n(season2, CP1, 1, 0)
    ccr1 = (ccr1_p - ccr3_p * x1) / sqrt((1. - ccr3_p^2.) * (1. - x1^2.))
    ccr2 = (ccr2_p - ccr4_p * x1) / sqrt((1. - ccr4_p^2.) * (1. - x1^2.))
    ccr3 = (ccr3_p - ccr1_p * x1) / sqrt((1. - ccr1_p^2.) * (1. - x1^2.))
    ccr4 = (ccr4_p - ccr2_p * x1) / sqrt((1. - ccr2_p^2.) * (1. - x1^2.))
    ccr5_p = escorc_n(season1, EP2, 1, 0)
    ccr6_p = escorc_n(season2, EP2, 1, 0)
    ccr7_p = escorc_n(season1, CP2, 1, 0)
    ccr8_p = escorc_n(season2, CP2, 1, 0)
    ccr5 = (ccr5_p - ccr7_p * x2) / sqrt((1. - ccr7_p^2.) * (1. - x2^2.))
    ccr6 = (ccr6_p - ccr8_p * x2) / sqrt((1. - ccr8_p^2.) * (1. - x2^2.))
    ccr7 = (ccr7_p - ccr5_p * x2) / sqrt((1. - ccr5_p^2.) * (1. - x2^2.))
    ccr8 = (ccr8_p - ccr6_p * x2) / sqrt((1. - ccr6_p^2.) * (1. - x2^2.))

    copy_VarCoords(season1(:,0,:,:),ccr1)
    copy_VarCoords(season2(:,0,:,:),ccr2)
    copy_VarCoords(season1(:,0,:,:),ccr3)
    copy_VarCoords(season2(:,0,:,:),ccr4)
    copy_VarCoords(season1(:,0,:,:),ccr5)
    copy_VarCoords(season2(:,0,:,:),ccr6)
    copy_VarCoords(season1(:,0,:,:),ccr7)
    copy_VarCoords(season2(:,0,:,:),ccr8)

;---------------------------------------------------------------
;perform significance test
    N = num(.not.ismissing(EP1))
    print((/N/))
    H1 = (/where(sqrt(N-1-3) * abs(0.5*log((1+ccr1)/(1-ccr1))) .gt. 1.0/cdfnor_p(1-a/2.0,0.0,1.0), 1.0, 0.0)/)
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

    copy_VarCoords(season1(:,0,:,:),H1)
    copy_VarCoords(season2(:,0,:,:),H2)
    copy_VarCoords(season1(:,0,:,:),H3)
    copy_VarCoords(season2(:,0,:,:),H4)
    copy_VarCoords(season1(:,0,:,:),H5)
    copy_VarCoords(season2(:,0,:,:),H6)
    copy_VarCoords(season1(:,0,:,:),H7)
    copy_VarCoords(season2(:,0,:,:),H8)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks1 = gsn_open_wks("svg", out_path + out_name1)
wks2 = gsn_open_wks("svg", out_path + out_name2)
plot1 = new(6, graphic)
plot2 = new(6, graphic)
plot3 = new(6, graphic)
plot4 = new(6, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = text2(2)
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-.6,-.4,-.2,.2,.4,.6/)

res@lbLabelBarOn = False

res@mpFillOn = True
res@mpOutlineOn = False
res@mpFillDrawOrder = "PostDraw"
res@mpCenterLonF = 160.
;map outlines
res@mpMinLatF = latSm
res@mpMaxLatF = latNm
res@mpMinLonF = lonLm
res@mpMaxLonF = lonRm

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

do i = 0, 2
    res@gsnLeftString = text1(2*i)
    if(i .eq. 0)then
        res@gsnCenterString = text2(0)
    else
        res@gsnCenterString = " "
    end if
    plot1(2*i) = gsn_csm_contour_map_ce(wks1, ccr1(i,:,:), res)
    plot2(2*i) = gsn_csm_contour_map_ce(wks2, ccr5(i,:,:), res)

    res@gsnLeftString = text1(2*i+1)
    if(i .eq. 0)then
        res@gsnCenterString = text2(1)
    else
        res@gsnCenterString = " "
    end if
    plot1(2*i+1) = gsn_csm_contour_map_ce(wks1, ccr3(i,:,:), res)
    plot2(2*i+1) = gsn_csm_contour_map_ce(wks2, ccr7(i,:,:), res)
end do

;---------------------------------------------------------------
;plot vector
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "

res2@lbLabelBarOn = False

res2@vcLevelPalette = "gsltod"
res2@vcLevelSelectionMode = "ExplicitLevels"
res2@vcLevels = (/-0.1,0.2,0.5/)
res2@vcRefAnnoOn = False
res2@vcRefLengthF = 0.05
res2@vcRefMagnitudeF = 1.2
res2@vcRefAnnoOrthogonalPosF = 0.28
res2@vcMinDistanceF = 0.03
res2@vcLineArrowThicknessF = 1.6
res2@vcLineArrowHeadMaxSizeF = 0.02
res2@vcLineArrowHeadMinSizeF = 0.01

do i = 0, 2
    plot3(2*i) = gsn_csm_vector_scalar(wks1, ccr1(i,:,:), ccr2(i,:,:), H1(i,:,:), res2)
    plot4(2*i) = gsn_csm_vector_scalar(wks2, ccr5(i,:,:), ccr6(i,:,:), H5(i,:,:), res2)

    if(i .eq. 1)then
        res2@vcRefAnnoOn = True
    end if
    plot3(2*i+1) = gsn_csm_vector_scalar(wks1, ccr3(i,:,:), ccr4(i,:,:), H3(i,:,:), res2)
    plot4(2*i+1) = gsn_csm_vector_scalar(wks2, ccr7(i,:,:), ccr8(i,:,:), H7(i,:,:), res2)
end do

do i = 0, 5
    overlay(plot1(i), plot3(i))
    overlay(plot2(i), plot4(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = 0.05

resP@txString = text3
gsn_panel(wks1, plot1(2:3), (/1,2/), resP)

resP@txString = text4
gsn_panel(wks2, plot2(2:3), (/1,2/), resP)

end
