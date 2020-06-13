;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of composite of tropical sea surface height anomalies during El Nino for transisitonal and non-transistional events
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composite
;
;                       Shan He
;                       2020-05-13
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------zeta
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/"
;    in_name1 = "GECCO3/zeta41S6m.nc"
    in_name1 = "GECCO3/zeta41.nc"
    in_name2 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2017

    y1 = (/1969,1972,1982,1997,2006,2015/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)
    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 285

;Nino 3.4
    latNI = 5
    latSI = -5
    lonWI = 190
    lonEI = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "hovmoller_lon_comp_tropic_tran_ElNino_SSH_anom_GECCO"

;text
    text1 = (/"a) Transitional EP","c) Transitional CP","b) Non-transitional EP","d) Non-transitional CP"/)
    text2 = (/"SSHA (cm)","EP","CP"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Composite SSH Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    time1 = in1->time
    time2 = in2->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    year1_p = toint(TIME1(:,0))
    year2_p = toint(TIME2(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)
    iYYYY2 = ind(year2_p.ge.yS .and. year2_p.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1_p(iYYYY1)
    month = month_p(iYYYY1)

    E1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
    E2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
    E3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
    E4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)

    do i = 1, ny1 - 1
     E1 = E1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny2 - 1
     E2 = E2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny3 - 1
     E3 = E3 .or. (year.eq.y3(i) .and. month.ge.mS .or. year.eq.y3(i)+1 .and. month.lt.mS)
    end do
    do i = 1, ny4 - 1
     E4 = E4 .or. (year.eq.y4(i) .and. month.ge.mS .or. year.eq.y4(i)+1 .and. month.lt.mS)
    end do

    iMM1 =ind(E1)
    iMM2 =ind(E2)
    iMM3 =ind(E3)
    iMM4 =ind(E4)

;----------------------------------------------------------
    zeta_p = lonFlip(in1->zeta(iYYYY1,{latN:latS},:))
    zeta = zeta_p(:,:,{lonW:lonE})
    zeta = (/100 * zeta/)
    zeta@units = "cm"
    sst = lonFlip(in2->sst(iYYYY2,:,:))
    printVarSummary(zeta)

;----------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat({latN:latS})
    gw2 = in2->latitude({latNI:latSI})
    gw1 = cos(rad * gw1)
    gw2 = cos(rad * gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(zeta)
    clm2 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(zeta, clm1)
    Anom2 = calcMonAnomTLL(sst, clm2)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom2(:,{latNI:latSI},{lonWI:lonEI}), gw2, 1., 0)
    dim = dimsizes(Nino34)
    Nino34(12::12) =  (/(Nino34(11:dim-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            Nino34(i::12) = (/Nino34(12::12)/)
        else
            Nino34(i:dim-13:12) = (/Nino34(12::12)/)
        end if
    end do

;Normalize
    Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)

;----------------------------------------------------------
Anom1(:,0,:) = dim_avg_wgt_n_Wrap(Anom1, gw1, 1, 1)

ave1_p = clmMonTLL(Anom1(iMM1,0:0,:))
ave2_p = clmMonTLL(Anom1(iMM2,0:0,:))
ave3_p = clmMonTLL(Anom1(iMM3,0:0,:))
ave4_p = clmMonTLL(Anom1(iMM4,0:0,:))

ave1 = ave1_p(:,0,:) 
ave2 = ave2_p(:,0,:) 
ave3 = ave3_p(:,0,:) 
ave4 = ave4_p(:,0,:) 

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-4.,-2.,-1.,1.,2.,4./)

res@lbLabelBarOn = False

res@tmYLMode = "Explicit"
res@tmYLValues = ispan(0,11,3)
res@tmYLLabels = text3
;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@tiYAxisOn = False

res@vpWidthF = 0.93
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
plot1(0) = gsn_csm_hov(wks, ave1, res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2(0)
plot1(1) = gsn_csm_hov(wks, ave3, res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave2, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave4, res)

;---------------------------------------------------------------
;plot zero contour
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

plot2(0) = gsn_csm_hov(wks, ave1, res2)
plot2(1) = gsn_csm_hov(wks, ave3, res2)
plot2(2) = gsn_csm_hov(wks, ave2, res2)
plot2(3) = gsn_csm_hov(wks, ave4, res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do

;---------------------------------------------------------------
;plot dashed line
resl = True
resl@gsLineThicknessF = 3.0
resl@gsLineDashPattern = 16
dum = gsn_add_polyline(wks, plot1(0), (/130,250/), (/6.5,11.5/), resl)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text4
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008
gsn_panel(wks, plot1, (/2,2/), resP)

end
