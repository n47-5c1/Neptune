;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of composite of tropical sea surface height anomalies during El Nino for transisitonal and non-transistional events
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composite
;
;                       Shan He
;                       2018-12-28
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------ssh
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"
    in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2010

    y1 = (/1969,1972,1982,1997,2006/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002/)
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
    out_name = "hovmoller_lon_comp_tropic_tran_ElNino_SSH_anom"

;text
    text1 = (/"g) Transitional EP","j) Transitional CP","h) Non-transitional EP","k) Non-transitional CP",\
              "i) Transitional - Non-transitional, EP","l) Transitional - Non-transitional, CP"/)
    text2 = (/"SSHA (cm)","EP","CP"/)
    text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
    text4 = "Hovmoller of Composite SSH Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in3 = addfile(in_path + in_name3, "r")

    files2 = systemfunc("ls " + in_path + in_name2)
    setfileoption("cdf", "SuppressClose", False)
    in2 = addfiles(files2, "r")
    ListSetType(in2, "join")

    time1 = in1->time
    time3 = in3->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    year1 = toint(TIME1(:,0))
    month1 = toint(TIME1(:,1))
    dimX = dimsizes(year1)
    year3 = toint(TIME3(:,0))
    iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)

    year = new(dimX+24, typeof(year1))
    month = new(dimX+24, typeof(month1))
    copy_VarMeta(year1, year(:dimX-1))
    copy_VarMeta(month1, month(:dimX-1))
    year(:dimX-1) = (/year1/)
    month(:dimX-1) = (/month1/)
    year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                    2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
    month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

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
    s1 = dimsizes(iMM1)/12
    s2 = dimsizes(iMM2)/12
    s3 = dimsizes(iMM3)/12
    s4 = dimsizes(iMM4)/12

;----------------------------------------------------------
    ssh1 = in1->ssh(:,{latN:latS},{lonW:lonE})
    SSH2 = in2[:]->SSH(:,{latN:latS},{lonW:lonE})
    ssh1 = (/100 * ssh1/)
    SSH2 = (/100 * SSH2/)
    dimY = dimsizes(ssh1)
    ssh = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(ssh1))
    copy_VarMeta(ssh1, ssh(:dimY(0)-1,:,:))
    ssh(:dimY(0)-1,:,:) = (/ssh1/)
    ssh(dimY(0):,:,:) = (/SSH2/)
    sst = lonFlip(in3->sst(iYYYY3,:,:))
    printVarSummary(ssh1)
    printVarSummary(SSH2)
    printVarSummary(ssh)

;----------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat({latN:latS})
    gw3 = in3->latitude({latNI:latSI})
    gw1 = cos(rad * gw1)
    gw3 = cos(rad * gw3)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(ssh)
    clm2 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(ssh, clm1)
    Anom2 = calcMonAnomTLL(sst, clm2)

    Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
    Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom2(:,{latNI:latSI},{lonWI:lonEI}), gw3, 1., 0)
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

;----------------------------------------------------------
;Calculate difference
diff1 = (/ave1 - ave2/)
diff2 = (/ave3 - ave4/)
copy_VarCoords(ave1, diff1)
copy_VarCoords(ave3, diff2)
/;
var1_p = stdMonTLL(Anom1(iMM1,0:0,:))
var2_p = stdMonTLL(Anom1(iMM1,0:0,:))
var3_p = stdMonTLL(Anom1(iMM3,0:0,:))
var4_p = stdMonTLL(Anom1(iMM4,0:0,:))

var1 = var1_p(:,0,:)
var2 = var2_p(:,0,:)
var3 = var3_p(:,0,:)
var4 = var4_p(:,0,:)

P1 = student_t(ave1 / var1 * sqrt(s1), s1 - 1)
P2 = student_t(ave2 / var2 * sqrt(s2), s2 - 1)
P3 = student_t(ave3 / var3 * sqrt(s3), s3 - 1)
P4 = student_t(ave4 / var4 * sqrt(s4), s4 - 1)
copy_VarCoords(ave1, P1)
copy_VarCoords(ave2, P2)
copy_VarCoords(ave3, P3)
copy_VarCoords(ave4, P4)

prob1 = ttest(ave1,var1,s1, ave2,var2,s2, False, False)
prob2 = ttest(ave3,var3,s3, ave4,var4,s4, False, False)
copy_VarCoords(ave1, prob1)
copy_VarCoords(ave3, prob2)
;/
; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(6, graphic)
plot2 = new(6, graphic)
;plot3 = new(6, graphic)

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
;res@cnLevels = (/-9.,-6.,-3.,3.,6.,9./)
res@cnLevels = (/-7.5,-5.,-2.5,2.5,5.,7.5/)

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

;---------------------------------------------------------------
;plot dashed line
resl = True
resl@gsLineThicknessF = 3.0
resl@gsLineDashPattern = 16
dum = gsn_add_polyline(wks, plot1(0), (/130,250/), (/6,11/), resl)
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
res3@cnFillDotSizeF = 0.002
res3@cnFillScaleF = 1.

plot3(0) = gsn_csm_contour(wks, P1, res3)
plot3(0) = ShadeLtContour(plot3(0), 0.11, 17)
plot3(1) = gsn_csm_contour(wks, P2, res3)
plot3(1) = ShadeLtContour(plot3(1), 0.11, 17)
plot3(2) = gsn_csm_contour(wks, P3, res3)
plot3(2) = ShadeLtContour(plot3(2), 0.11, 17)
plot3(3) = gsn_csm_contour(wks, P4, res3)
plot3(3) = ShadeLtContour(plot3(3), 0.11, 17)
;/
;*******************************************
;plot shading

;to have a common label bar
;res@cnLevels = (/-7.5,-5.,-2.5,2.5,5.,7.5/)

res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_hov(wks, diff1, res)

res@gsnLeftString = text1(5)
plot1(5) = gsn_csm_hov(wks, diff2, res)

;---------------------------------------------------------------
;plot zero contour
plot2(4) = gsn_csm_hov(wks, diff1, res2)
plot2(5) = gsn_csm_hov(wks, diff2, res2)

do i = 0, 5
    overlay(plot1(i), plot2(i))
end do
/;
;---------------------------------------------------------------
;probability plots
plot6(0) = gsn_csm_contour(wks, prob1, res3)
plot6(0) = ShadeLtContour(plot6(0), 0.11, 17)
plot6(1) = gsn_csm_contour(wks, prob2, res3)
plot6(1) = ShadeLtContour(plot6(1), 0.11, 17)

do i = 0, 5
    overlay(plot1(i), plot3(i))
end do
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text4
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008
gsn_panel(wks, plot1, (/3,2/), resP)

end
