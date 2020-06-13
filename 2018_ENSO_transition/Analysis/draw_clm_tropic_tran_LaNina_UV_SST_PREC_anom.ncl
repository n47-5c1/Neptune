;*************************************************************
;Aim: Draw climatology of tropical surface wind and sea surface temperature anomalies during La Nina and difference against transitional one
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-09-24
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
    in_name1 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.surf.mon.mean.nc"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 9
    mE = 8
    yS = 1958
    yE = 2017

    y1 = (/1964,1971,2005/)
    y2 = (/1984,1995/)
    y3 = (/1975,2008/)
    y4 = (/1970,1973,1974,1983,1988,1998,1999,2000,2007,2010,2011,2016/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)
    season = (/"AMJ","JAS","OND"/)
    seasonClm = (/"DJF","MAM","JJA"/)

;region
    latN = 30
    latS = -30
    lonL = 90
    lonR = 270

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name1 = "clm_tropic_tran_EP_LaNina_UV_SST_anom"
    out_name2 = "clm_tropic_tran_CP_LaNina_UV_SST_anom"

;text
    text1 = (/"a) DJF(0)","b)","c) MAM(+1)","d)","e) JJA(+1)","f)"/)
    text2 = (/"Transitional","Non-transitional","m s~S~-1~N~, ~F35~J~F~C"/)
    text3 = "UA, VA, & SSTA during EP La Nina"
    text4 = "UA, VA, & SSTA during CP La Nina"

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

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    La1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     La1 = La1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
    end do

    La2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
    do i = 1, ny2 - 1
     La2 = La2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
    end do

    La3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
    do i = 1, ny3 - 1
     La3 = La3 .or. (year.eq.y3(i) .and. month.ge.mS .or. year.eq.y3(i)+1 .and. month.lt.mS)
    end do

    La4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)
    do i = 1, ny4 - 1
     La4 = La4 .or. (year.eq.y4(i) .and. month.ge.mS .or. year.eq.y4(i)+1 .and. month.lt.mS)
    end do

;----------------------------------------------------------

    uwnd = in1->uwnd(iYYYY1,:,:)
    vwnd = in2->vwnd(iYYYY1,:,:)
    sst = in3->sst(iYYYY3,:,:)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(sst)
/;
    varClm1 = dim_variance_n_Wrap(month_to_seasonN(uwnd, seasonClm), 1)
    varClm2 = dim_variance_n_Wrap(month_to_seasonN(vwnd, seasonClm), 1)
    varClm3 = dim_variance_n_Wrap(month_to_seasonN(sst, seasonClm), 1)
;/
;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)
    Anom3 = calcMonAnomTLL(sst, clm3)
    print("Anom")

;----------------------------------------------------------
    iMM1 = ind(La1)
    iMM2 = ind(La2)
    iMM3 = ind(La3)
    iMM4 = ind(La4)

   season1 = month_to_seasonN(Anom1(iMM1,:,:), season)
   season2 = month_to_seasonN(Anom2(iMM1,:,:), season)
   season3 = month_to_seasonN(Anom3(iMM1,:,:), season)
   season4 = month_to_seasonN(Anom1(iMM2,:,:), season)
   season5 = month_to_seasonN(Anom2(iMM2,:,:), season)
   season6 = month_to_seasonN(Anom3(iMM2,:,:), season)
   season7 = month_to_seasonN(Anom1(iMM3,:,:), season)
   season8 = month_to_seasonN(Anom2(iMM3,:,:), season)
   season9 = month_to_seasonN(Anom3(iMM3,:,:), season)
   season10 = month_to_seasonN(Anom1(iMM4,:,:), season)
   season11 = month_to_seasonN(Anom2(iMM4,:,:), season)
   season12 = month_to_seasonN(Anom3(iMM4,:,:), season)

   ave1 = dim_avg_n_Wrap(season1, 1)
   ave2 = dim_avg_n_Wrap(season2, 1)
   ave3 = dim_avg_n_Wrap(season3, 1)
   ave4 = dim_avg_n_Wrap(season4, 1)
   ave5 = dim_avg_n_Wrap(season5, 1)
   ave6 = dim_avg_n_Wrap(season6, 1)
   ave7 = dim_avg_n_Wrap(season7, 1)
   ave8 = dim_avg_n_Wrap(season8, 1)
   ave9 = dim_avg_n_Wrap(season9, 1)
   ave10 = dim_avg_n_Wrap(season10, 1)
   ave11 = dim_avg_n_Wrap(season11, 1)
   ave12 = dim_avg_n_Wrap(season12, 1)
/;
   var1 = dim_variance_n_Wrap(season1, 1)
   var2 = dim_variance_n_Wrap(season2, 1)
   var3 = dim_variance_n_Wrap(season3, 1)
   var4 = dim_variance_n_Wrap(season4, 1)
   var5 = dim_variance_n_Wrap(season5, 1)
   var6 = dim_variance_n_Wrap(season6, 1)
   var7 = dim_variance_n_Wrap(season7, 1)
   var8 = dim_variance_n_Wrap(season8, 1)
   var9 = dim_variance_n_Wrap(season9, 1)
;/
   ave1 = (/ave1 - ave4/)
   ave2 = (/ave2 - ave5/)
   ave3 = (/ave3 - ave6/)
   ave7 = (/ave7 - ave10/)
   ave8 = (/ave8 - ave11/)
   ave9 = (/ave9 - ave12/)
   ave10 = (/ave10 - ave4/)
   ave11 = (/ave11 - ave5/)
   ave12 = (/ave12 - ave6/)
/;
;---------------------------------------------------------------
;compute probabilities for means difference
   prob1 = ttest(ave1+ave4, var1, ny1, ave4, var4, ny2, False, False)
   prob2 = ttest(ave2+ave5, var2, ny1, ave5, var5, ny2, False, False)
   prob3 = ttest(ave3, var3, ny1, ave3*0, varClm3, yE-yS+1, False, False)
   prob4 = ttest(ave4, var4, ny2, ave4*0, varClm1, yE-yS+1, False, False)
   prob5 = ttest(ave5, var5, ny2, ave5*0, varClm2, yE-yS+1, False, False)
   prob6 = ttest(ave6, var6, ny2, ave6*0, varClm3, yE-yS+1, False, False)
   prob7 = ttest(ave7+ave4, var7, ny3, ave4, var4, ny2, False, False)
   prob8 = ttest(ave8+ave5, var8, ny3, ave5, var5, ny2, False, False)
   prob9 = ttest(ave9, var9, ny3, ave9*0, varClm3, yE-yS+1, False, False)

   copy_VarCoords(ave1, prob1)
   copy_VarCoords(ave2, prob2)
   copy_VarCoords(ave3, prob3)
   copy_VarCoords(ave4, prob4)
   copy_VarCoords(ave5, prob5)
   copy_VarCoords(ave6, prob6)
   copy_VarCoords(ave7, prob7)
   copy_VarCoords(ave8, prob8)
   copy_VarCoords(ave9, prob9)

   ave3 = where(prob3.le.0.05, ave3, 0.)
   ave6 = where(prob6.le.0.05, ave6, 0.)
   ave9 = where(prob9.le.0.05, ave9, 0.)
   ave1 = (/mask(ave1, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave2 = (/mask(ave2, prob1.le.0.1 .or. prob2.le.0.1, True)/)
   ave4 = (/mask(ave4, prob4.le.0.05 .or. prob5.le.0.05, True)/)
   ave5 = (/mask(ave5, prob4.le.0.05 .or. prob5.le.0.05, True)/)
   ave7 = (/mask(ave7, prob7.le.0.1 .or. prob8.le.0.1, True)/)
   ave8 = (/mask(ave8, prob7.le.0.1 .or. prob8.le.0.1, True)/)
;/
; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks1 = gsn_open_wks("svg", out_path + out_name1)
wks2 = gsn_open_wks("svg", out_path + out_name2)
plot1 = new(6, graphic)
plot2 = new(6, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = " "
res@gsnScalarContour = True       ;contours desired
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-.8,-.4,-.2,.2,.4,.8/)

res@lbLabelBarOn = False

res@vcGlyphStyle = "CurlyVector"
res@vcRefAnnoOn = False
res@vcRefLengthF = 0.07
res@vcRefMagnitudeF = 5
res@vcRefAnnoOrthogonalPosF = -0.27
res@vcMinDistanceF = 0.03
;res@vcFillArrowsOn = True
;res@vcFillArrowHeadMinFracXF = 0.33
;res@vcFillArrowHeadMinFracYF = 0.33
;res@vcVectorDrawOrder = "PostDraw"
res@vcLineArrowThicknessF = 1.6
res@vcLineArrowHeadMaxSizeF = 0.018
res@vcLineArrowHeadMinSizeF = 0.009

res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

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
    plot1(2*i) = gsn_csm_vector_scalar_map_ce(wks1, ave1(i,:,:), ave2(i,:,:), ave3(i,:,:), res)
    plot2(2*i) = gsn_csm_vector_scalar_map_ce(wks2, ave7(i,:,:), ave8(i,:,:), ave9(i,:,:), res)

    res@gsnLeftString = text1(2*i+1)
    if(i .eq. 0)then
        res@gsnCenterString = text2(1)
        res@gsnRightString = text2(2)
    else
        res@gsnCenterString = " "
        res@gsnRightString = " "
    end if
    if(i .eq. 2)then
        res@vcRefAnnoOn = True
    end if
    plot1(2*i+1) = gsn_csm_vector_scalar_map_ce(wks1, ave4(i,:,:), ave5(i,:,:), ave6(i,:,:), res)
    plot2(2*i+1) = gsn_csm_vector_scalar_map_ce(wks2, ave10(i,:,:), ave11(i,:,:), ave12(i,:,:), res)
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008

resP@txString = text3
gsn_panel(wks1, plot1, (/3,2/), resP)

resP@txString = text4
gsn_panel(wks2, plot2, (/3,2/), resP)

end
